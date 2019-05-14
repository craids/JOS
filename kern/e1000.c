#include <kern/e1000.h>
#include <kern/pmap.h>
#include <kern/picirq.h>
#include <kern/cpu.h>
#include <kern/env.h>

#include <inc/string.h>
#include <inc/error.h>


// LAB 6: Your driver code here

struct tx_desc txq[NTXDESC] __attribute__ ((aligned (16)));
struct packet tx_pkts[NTXDESC];
struct rx_desc rxq[NRXDESC] __attribute__ ((aligned (16)));
struct packet rx_pkts[NRXDESC];
volatile uint32_t *network_regs;
uint16_t mac[E1000_NUM_MAC_WORDS];

void read_mac_from_eeprom(void);


int
pci_network_attach(struct pci_func *pcif)
{
	pci_func_enable(pcif);
	network_regs = mmio_map_region((physaddr_t) pcif->reg_base[0], pcif->reg_size[0]);
	cprintf("DEV_STAT: 0x%08x\n", network_regs[E1000_STATUS]); // check device status register
	read_mac_from_eeprom();

	// TX init

	network_regs[E1000_TDBAL] = PADDR(txq);
	network_regs[E1000_TDBAH] = 0x00000000;

	network_regs[E1000_TDLEN] = NTXDESC * sizeof(struct tx_desc);

	network_regs[E1000_TDH] = 0x00000000;
	network_regs[E1000_TDT] = 0x00000000;
	
	network_regs[E1000_TCTL] |= E1000_TCTL_EN;
	network_regs[E1000_TCTL] |= E1000_TCTL_PSP;
	network_regs[E1000_TCTL] |= E1000_TCTL_CT;
	network_regs[E1000_TCTL] |= E1000_TCTL_COLD;

	network_regs[E1000_TIPG] |= (0xA << E1000_TIPG_IPGT);
	network_regs[E1000_TIPG] |= (0x8 << E1000_TIPG_IPGR1);
	network_regs[E1000_TIPG] |= (0xC << E1000_TIPG_IPGR2);
	
	memset(txq, 0, sizeof(struct tx_desc) * NTXDESC);

	int i;
	for (i = 0; i < NTXDESC; i++) {
		txq[i].addr = PADDR(&tx_pkts[i]); 	
		txq[i].cmd |= E1000_TXD_RS;			
		txq[i].cmd &= ~E1000_TXD_DEXT;		
		txq[i].status |= E1000_TXD_DD;		
											
	}
	
	// RX init

	network_regs[E1000_RAL] = 0x0;
	network_regs[E1000_RAL] |= mac[0];
	network_regs[E1000_RAL] |= (mac[1] << E1000_EERD_DATA);

	network_regs[E1000_RAH] = 0x0;
	network_regs[E1000_RAH] |= mac[2];
	network_regs[E1000_RAH] |= E1000_RAH_AV;

	for (i = 0; i < NELEM_MTA; i++) {
		network_regs[E1000_MTA + i] = 0x00000000;
	}

	network_regs[E1000_RDBAL] = PADDR(&rxq);
	network_regs[E1000_RDBAH] = 0x00000000;

	network_regs[E1000_RDLEN] = NRXDESC * sizeof(struct rx_desc);

	network_regs[E1000_RDH] = 0;
	network_regs[E1000_RDT] = NRXDESC - 1;

	memset(rxq, 0, sizeof(struct rx_desc) * NRXDESC);

	for (i = 0; i < NRXDESC; i++) {
		rxq[i].addr = PADDR(&rx_pkts[i]); 	// set packet buffer addr
	}

	network_regs[E1000_IMS] |= E1000_RXT0;
	network_regs[E1000_RCTL] &= E1000_RCTL_LBM_NO;
	network_regs[E1000_RCTL] &= E1000_RCTL_BSIZE_2048;
	network_regs[E1000_RCTL] |= E1000_RCTL_SECRC;
	network_regs[E1000_RCTL] &= E1000_RCTL_LPE_NO;
	network_regs[E1000_RCTL] |= E1000_RCTL_EN;
	
	return 1;
}

int
e1000_transmit(char* pkt, size_t length)
{
	if (length > PKT_BUF_SIZE)
		panic("e1000_transmit: size of packet to transmit (%d) larger than max (2048)\n", length);

	size_t tail_idx = network_regs[E1000_TDT];

	if (txq[tail_idx].status & E1000_TXD_DD) {
		memmove((void *) &tx_pkts[tail_idx], (void *) pkt, length);
		txq[tail_idx].status &= ~E1000_TXD_DD;
		txq[tail_idx].cmd |= E1000_TXD_EOP;
		txq[tail_idx].length = length;
		network_regs[E1000_TDT] = (tail_idx + 1) % NTXDESC;

		return 0;
	} else {
		return -1;
	}
}

int
e1000_receive(char* pkt, size_t *length)
{
	size_t tail_idx = (network_regs[E1000_RDT] + 1) % NRXDESC;

	if ((rxq[tail_idx].status & E1000_RXD_STATUS_DD) == 0)
		return -E_E1000_RXBUF_EMPTY;

	if ((rxq[tail_idx].status & E1000_RXD_STATUS_EOP) == 0)
		panic("e1000_receive: EOP flag not set, all packets should fit in one buffer\n");

	*length = rxq[tail_idx].length;
	memmove(pkt, &rx_pkts[tail_idx], *length);

	rxq[tail_idx].status &= ~(E1000_RXD_STATUS_DD);
	rxq[tail_idx].status &= ~(E1000_RXD_STATUS_EOP);

	network_regs[E1000_RDT] = tail_idx;

	return 0;
}

void
clear_e1000_interrupt(void)
{
	network_regs[E1000_ICR] |= E1000_RXT0;
	lapic_eoi();
	irq_eoi();
}

void
e1000_trap_handler(void)
{
	struct Env *receiver = NULL;
	int i;

	for (i = 0; i < NENV; i++) {
		if (envs[i].env_e1000_waiting_rx)
			receiver = &envs[i];
	}

	if (!receiver) {
		clear_e1000_interrupt();
		return;
	}
	else {
		receiver->env_status = ENV_RUNNABLE;
		receiver->env_e1000_waiting_rx = false;
		clear_e1000_interrupt();
		return;
	}
}

void
read_mac_from_eeprom(void)
{
	uint8_t word_num;
	for (word_num = 0; word_num < E1000_NUM_MAC_WORDS; word_num++) {
		network_regs[E1000_EERD] |= (word_num << E1000_EERD_ADDR);
		network_regs[E1000_EERD] |= E1000_EERD_READ;
		while (!(network_regs[E1000_EERD] & E1000_EERD_DONE));
		mac[word_num] = network_regs[E1000_EERD] >> E1000_EERD_DATA;
		network_regs[E1000_EERD] = 0x0;
	}
}

void
e1000_get_mac(uint8_t *mac_addr)
{
	*((uint32_t *) mac_addr) =  (uint32_t) network_regs[E1000_RAL];
	*((uint16_t*)(mac_addr + 4)) = (uint16_t) network_regs[E1000_RAH];
}

void
print_mac()
{
	cprintf("MAC: %02x:%02x:%02x:%02x:%02x:%02x\n", mac[0] & 0x00FF, mac[0] >> 8, mac[1] & 0x00FF, mac[1] >> 8, mac[2] & 0xFF, mac[2] >> 8);
}

