
obj/net/testoutput:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 43 03 00 00       	call   800374 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t ns_envid = sys_getenvid();
  80003b:	e8 95 0e 00 00       	call   800ed5 <sys_getenvid>
  800040:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  800042:	c7 05 00 40 80 00 20 	movl   $0x802e20,0x804000
  800049:	2e 80 00 

	output_envid = fork();
  80004c:	e8 0f 13 00 00       	call   801360 <fork>
  800051:	a3 00 50 80 00       	mov    %eax,0x805000
	if (output_envid < 0)
  800056:	85 c0                	test   %eax,%eax
  800058:	79 1c                	jns    800076 <umain+0x43>
		panic("error forking");
  80005a:	c7 44 24 08 2b 2e 80 	movl   $0x802e2b,0x8(%esp)
  800061:	00 
  800062:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
  800069:	00 
  80006a:	c7 04 24 39 2e 80 00 	movl   $0x802e39,(%esp)
  800071:	e8 5f 03 00 00       	call   8003d5 <_panic>
	else if (output_envid == 0) {
  800076:	bb 00 00 00 00       	mov    $0x0,%ebx
  80007b:	85 c0                	test   %eax,%eax
  80007d:	75 0d                	jne    80008c <umain+0x59>
		output(ns_envid);
  80007f:	89 34 24             	mov    %esi,(%esp)
  800082:	e8 55 02 00 00       	call   8002dc <output>
		return;
  800087:	e9 c6 00 00 00       	jmp    800152 <umain+0x11f>
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
		if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  80008c:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800093:	00 
  800094:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  80009b:	0f 
  80009c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a3:	e8 6b 0e 00 00       	call   800f13 <sys_page_alloc>
  8000a8:	85 c0                	test   %eax,%eax
  8000aa:	79 20                	jns    8000cc <umain+0x99>
			panic("sys_page_alloc: %e", r);
  8000ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b0:	c7 44 24 08 4a 2e 80 	movl   $0x802e4a,0x8(%esp)
  8000b7:	00 
  8000b8:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8000bf:	00 
  8000c0:	c7 04 24 39 2e 80 00 	movl   $0x802e39,(%esp)
  8000c7:	e8 09 03 00 00       	call   8003d5 <_panic>
		pkt->jp_len = snprintf(pkt->jp_data,
  8000cc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000d0:	c7 44 24 08 5d 2e 80 	movl   $0x802e5d,0x8(%esp)
  8000d7:	00 
  8000d8:	c7 44 24 04 fc 0f 00 	movl   $0xffc,0x4(%esp)
  8000df:	00 
  8000e0:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  8000e7:	e8 9e 09 00 00       	call   800a8a <snprintf>
  8000ec:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  8000f1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000f5:	c7 04 24 69 2e 80 00 	movl   $0x802e69,(%esp)
  8000fc:	e8 cd 03 00 00       	call   8004ce <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  800101:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800108:	00 
  800109:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  800110:	0f 
  800111:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800118:	00 
  800119:	a1 00 50 80 00       	mov    0x805000,%eax
  80011e:	89 04 24             	mov    %eax,(%esp)
  800121:	e8 a2 15 00 00       	call   8016c8 <ipc_send>
		sys_page_unmap(0, pkt);
  800126:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  80012d:	0f 
  80012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800135:	e8 80 0e 00 00       	call   800fba <sys_page_unmap>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  80013a:	83 c3 01             	add    $0x1,%ebx
  80013d:	83 fb 0a             	cmp    $0xa,%ebx
  800140:	0f 85 46 ff ff ff    	jne    80008c <umain+0x59>
  800146:	b3 14                	mov    $0x14,%bl
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
		sys_yield();
  800148:	e8 a7 0d 00 00       	call   800ef4 <sys_yield>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  80014d:	83 eb 01             	sub    $0x1,%ebx
  800150:	75 f6                	jne    800148 <umain+0x115>
		sys_yield();
}
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5d                   	pop    %ebp
  800158:	c3                   	ret    
  800159:	66 90                	xchg   %ax,%ax
  80015b:	66 90                	xchg   %ax,%ax
  80015d:	66 90                	xchg   %ax,%ax
  80015f:	90                   	nop

00800160 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	57                   	push   %edi
  800164:	56                   	push   %esi
  800165:	53                   	push   %ebx
  800166:	83 ec 2c             	sub    $0x2c,%esp
  800169:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  80016c:	e8 0a 10 00 00       	call   80117b <sys_time_msec>
  800171:	03 45 0c             	add    0xc(%ebp),%eax
  800174:	89 c6                	mov    %eax,%esi

	binaryname = "ns_timer";
  800176:	c7 05 00 40 80 00 81 	movl   $0x802e81,0x804000
  80017d:	2e 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800180:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800183:	eb 05                	jmp    80018a <timer+0x2a>

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
			sys_yield();
  800185:	e8 6a 0d 00 00       	call   800ef4 <sys_yield>
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  80018a:	e8 ec 0f 00 00       	call   80117b <sys_time_msec>
  80018f:	39 c6                	cmp    %eax,%esi
  800191:	76 06                	jbe    800199 <timer+0x39>
  800193:	85 c0                	test   %eax,%eax
  800195:	79 ee                	jns    800185 <timer+0x25>
  800197:	eb 09                	jmp    8001a2 <timer+0x42>
			sys_yield();
		}
		if (r < 0)
  800199:	85 c0                	test   %eax,%eax
  80019b:	90                   	nop
  80019c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8001a0:	79 20                	jns    8001c2 <timer+0x62>
			panic("sys_time_msec: %e", r);
  8001a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001a6:	c7 44 24 08 8a 2e 80 	movl   $0x802e8a,0x8(%esp)
  8001ad:	00 
  8001ae:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8001b5:	00 
  8001b6:	c7 04 24 9c 2e 80 00 	movl   $0x802e9c,(%esp)
  8001bd:	e8 13 02 00 00       	call   8003d5 <_panic>

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8001c2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001c9:	00 
  8001ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001d1:	00 
  8001d2:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  8001d9:	00 
  8001da:	89 1c 24             	mov    %ebx,(%esp)
  8001dd:	e8 e6 14 00 00       	call   8016c8 <ipc_send>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8001e2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001e9:	00 
  8001ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001f1:	00 
  8001f2:	89 3c 24             	mov    %edi,(%esp)
  8001f5:	e8 66 14 00 00       	call   801660 <ipc_recv>
  8001fa:	89 c6                	mov    %eax,%esi

			if (whom != ns_envid) {
  8001fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ff:	39 c3                	cmp    %eax,%ebx
  800201:	74 12                	je     800215 <timer+0xb5>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800203:	89 44 24 04          	mov    %eax,0x4(%esp)
  800207:	c7 04 24 a8 2e 80 00 	movl   $0x802ea8,(%esp)
  80020e:	e8 bb 02 00 00       	call   8004ce <cprintf>
  800213:	eb cd                	jmp    8001e2 <timer+0x82>
				continue;
			}

			stop = sys_time_msec() + to;
  800215:	e8 61 0f 00 00       	call   80117b <sys_time_msec>
  80021a:	01 c6                	add    %eax,%esi
  80021c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800220:	e9 65 ff ff ff       	jmp    80018a <timer+0x2a>

00800225 <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	57                   	push   %edi
  800229:	56                   	push   %esi
  80022a:	53                   	push   %ebx
  80022b:	81 ec 2c 08 00 00    	sub    $0x82c,%esp
  800231:	8b 7d 08             	mov    0x8(%ebp),%edi
	binaryname = "ns_input";
  800234:	c7 05 00 40 80 00 e3 	movl   $0x802ee3,0x804000
  80023b:	2e 80 00 
	int perm = PTE_P | PTE_W | PTE_U;
	size_t length;
	char pkt[PKT_BUF_SIZE];

	while (1) {
		while (sys_e1000_receive(pkt, &length) == -E_E1000_RXBUF_EMPTY);
  80023e:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800241:	8d 9d e4 f7 ff ff    	lea    -0x81c(%ebp),%ebx
  800247:	89 74 24 04          	mov    %esi,0x4(%esp)
  80024b:	89 1c 24             	mov    %ebx,(%esp)
  80024e:	e8 68 0f 00 00       	call   8011bb <sys_e1000_receive>
  800253:	83 f8 ef             	cmp    $0xffffffef,%eax
  800256:	74 ef                	je     800247 <input+0x22>

		int r;
		if ((r = sys_page_alloc(0, &nsipcbuf, perm)) < 0)
  800258:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80025f:	00 
  800260:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  800267:	00 
  800268:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80026f:	e8 9f 0c 00 00       	call   800f13 <sys_page_alloc>
  800274:	85 c0                	test   %eax,%eax
  800276:	79 20                	jns    800298 <input+0x73>
			panic("input: unable to allocate new page, error %e\n", r);
  800278:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80027c:	c7 44 24 08 f8 2e 80 	movl   $0x802ef8,0x8(%esp)
  800283:	00 
  800284:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80028b:	00 
  80028c:	c7 04 24 ec 2e 80 00 	movl   $0x802eec,(%esp)
  800293:	e8 3d 01 00 00       	call   8003d5 <_panic>

		memmove(nsipcbuf.pkt.jp_data, pkt, length);
  800298:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80029b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80029f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002a3:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8002aa:	e8 e5 09 00 00       	call   800c94 <memmove>
		nsipcbuf.pkt.jp_len = length;
  8002af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b2:	a3 00 70 80 00       	mov    %eax,0x807000

		ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, perm);
  8002b7:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8002be:	00 
  8002bf:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8002c6:	00 
  8002c7:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8002ce:	00 
  8002cf:	89 3c 24             	mov    %edi,(%esp)
  8002d2:	e8 f1 13 00 00       	call   8016c8 <ipc_send>
	}
  8002d7:	e9 6b ff ff ff       	jmp    800247 <input+0x22>

008002dc <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
  8002df:	57                   	push   %edi
  8002e0:	56                   	push   %esi
  8002e1:	53                   	push   %ebx
  8002e2:	83 ec 2c             	sub    $0x2c,%esp
  8002e5:	8b 7d 08             	mov    0x8(%ebp),%edi
	binaryname = "ns_output";
  8002e8:	c7 05 00 40 80 00 26 	movl   $0x802f26,0x804000
  8002ef:	2f 80 00 
	uint32_t req;
	int perm;

	while(1) {
		perm = 0;
		req = ipc_recv(&sender_envid, &nsipcbuf, &perm);
  8002f2:	8d 75 e0             	lea    -0x20(%ebp),%esi
  8002f5:	8d 5d e4             	lea    -0x1c(%ebp),%ebx
	envid_t sender_envid;
	uint32_t req;
	int perm;

	while(1) {
		perm = 0;
  8002f8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		req = ipc_recv(&sender_envid, &nsipcbuf, &perm);
  8002ff:	89 74 24 08          	mov    %esi,0x8(%esp)
  800303:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80030a:	00 
  80030b:	89 1c 24             	mov    %ebx,(%esp)
  80030e:	e8 4d 13 00 00       	call   801660 <ipc_recv>

		if (((uint32_t *) sender_envid == 0) || (perm == 0)) {
  800313:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800316:	85 d2                	test   %edx,%edx
  800318:	74 06                	je     800320 <output+0x44>
  80031a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80031e:	75 12                	jne    800332 <output+0x56>
			cprintf("Invalid request; ipc_recv encountered an error %e\n", req);
  800320:	89 44 24 04          	mov    %eax,0x4(%esp)
  800324:	c7 04 24 30 2f 80 00 	movl   $0x802f30,(%esp)
  80032b:	e8 9e 01 00 00       	call   8004ce <cprintf>
			continue;
  800330:	eb c6                	jmp    8002f8 <output+0x1c>
		}

		if (sender_envid != ns_envid) {
  800332:	39 fa                	cmp    %edi,%edx
  800334:	74 16                	je     80034c <output+0x70>
			cprintf("Received IPC from envid %08x, expected to receive from %08x\n",
  800336:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80033a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80033e:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  800345:	e8 84 01 00 00       	call   8004ce <cprintf>
				sender_envid, ns_envid);
			continue;
  80034a:	eb ac                	jmp    8002f8 <output+0x1c>
		}

		if (sys_e1000_transmit(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len) == -E_E1000_TXBUF_FULL)
  80034c:	a1 00 70 80 00       	mov    0x807000,%eax
  800351:	89 44 24 04          	mov    %eax,0x4(%esp)
  800355:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80035c:	e8 39 0e 00 00       	call   80119a <sys_e1000_transmit>
  800361:	83 f8 f0             	cmp    $0xfffffff0,%eax
  800364:	75 92                	jne    8002f8 <output+0x1c>
			cprintf("Dropping packet, after 20 tries cannot transmit");
  800366:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  80036d:	e8 5c 01 00 00       	call   8004ce <cprintf>
  800372:	eb 84                	jmp    8002f8 <output+0x1c>

00800374 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	56                   	push   %esi
  800378:	53                   	push   %ebx
  800379:	83 ec 10             	sub    $0x10,%esp
  80037c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80037f:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800382:	e8 4e 0b 00 00       	call   800ed5 <sys_getenvid>
  800387:	25 ff 03 00 00       	and    $0x3ff,%eax
  80038c:	c1 e0 07             	shl    $0x7,%eax
  80038f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800394:	a3 0c 50 80 00       	mov    %eax,0x80500c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800399:	85 db                	test   %ebx,%ebx
  80039b:	7e 07                	jle    8003a4 <libmain+0x30>
		binaryname = argv[0];
  80039d:	8b 06                	mov    (%esi),%eax
  80039f:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8003a4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003a8:	89 1c 24             	mov    %ebx,(%esp)
  8003ab:	e8 83 fc ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8003b0:	e8 07 00 00 00       	call   8003bc <exit>
}
  8003b5:	83 c4 10             	add    $0x10,%esp
  8003b8:	5b                   	pop    %ebx
  8003b9:	5e                   	pop    %esi
  8003ba:	5d                   	pop    %ebp
  8003bb:	c3                   	ret    

008003bc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003bc:	55                   	push   %ebp
  8003bd:	89 e5                	mov    %esp,%ebp
  8003bf:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8003c2:	e8 a3 15 00 00       	call   80196a <close_all>
	sys_env_destroy(0);
  8003c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003ce:	e8 b0 0a 00 00       	call   800e83 <sys_env_destroy>
}
  8003d3:	c9                   	leave  
  8003d4:	c3                   	ret    

008003d5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003d5:	55                   	push   %ebp
  8003d6:	89 e5                	mov    %esp,%ebp
  8003d8:	56                   	push   %esi
  8003d9:	53                   	push   %ebx
  8003da:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8003dd:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003e0:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8003e6:	e8 ea 0a 00 00       	call   800ed5 <sys_getenvid>
  8003eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003ee:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003f5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003f9:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800401:	c7 04 24 e0 2f 80 00 	movl   $0x802fe0,(%esp)
  800408:	e8 c1 00 00 00       	call   8004ce <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80040d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800411:	8b 45 10             	mov    0x10(%ebp),%eax
  800414:	89 04 24             	mov    %eax,(%esp)
  800417:	e8 51 00 00 00       	call   80046d <vcprintf>
	cprintf("\n");
  80041c:	c7 04 24 7f 2e 80 00 	movl   $0x802e7f,(%esp)
  800423:	e8 a6 00 00 00       	call   8004ce <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800428:	cc                   	int3   
  800429:	eb fd                	jmp    800428 <_panic+0x53>

0080042b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80042b:	55                   	push   %ebp
  80042c:	89 e5                	mov    %esp,%ebp
  80042e:	53                   	push   %ebx
  80042f:	83 ec 14             	sub    $0x14,%esp
  800432:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800435:	8b 13                	mov    (%ebx),%edx
  800437:	8d 42 01             	lea    0x1(%edx),%eax
  80043a:	89 03                	mov    %eax,(%ebx)
  80043c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80043f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800443:	3d ff 00 00 00       	cmp    $0xff,%eax
  800448:	75 19                	jne    800463 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80044a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800451:	00 
  800452:	8d 43 08             	lea    0x8(%ebx),%eax
  800455:	89 04 24             	mov    %eax,(%esp)
  800458:	e8 e9 09 00 00       	call   800e46 <sys_cputs>
		b->idx = 0;
  80045d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800463:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800467:	83 c4 14             	add    $0x14,%esp
  80046a:	5b                   	pop    %ebx
  80046b:	5d                   	pop    %ebp
  80046c:	c3                   	ret    

0080046d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80046d:	55                   	push   %ebp
  80046e:	89 e5                	mov    %esp,%ebp
  800470:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800476:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80047d:	00 00 00 
	b.cnt = 0;
  800480:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800487:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80048a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800491:	8b 45 08             	mov    0x8(%ebp),%eax
  800494:	89 44 24 08          	mov    %eax,0x8(%esp)
  800498:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80049e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a2:	c7 04 24 2b 04 80 00 	movl   $0x80042b,(%esp)
  8004a9:	e8 b0 01 00 00       	call   80065e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004ae:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8004b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004b8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004be:	89 04 24             	mov    %eax,(%esp)
  8004c1:	e8 80 09 00 00       	call   800e46 <sys_cputs>

	return b.cnt;
}
  8004c6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004d4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004db:	8b 45 08             	mov    0x8(%ebp),%eax
  8004de:	89 04 24             	mov    %eax,(%esp)
  8004e1:	e8 87 ff ff ff       	call   80046d <vcprintf>
	va_end(ap);

	return cnt;
}
  8004e6:	c9                   	leave  
  8004e7:	c3                   	ret    
  8004e8:	66 90                	xchg   %ax,%ax
  8004ea:	66 90                	xchg   %ax,%ax
  8004ec:	66 90                	xchg   %ax,%ax
  8004ee:	66 90                	xchg   %ax,%ax

008004f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	57                   	push   %edi
  8004f4:	56                   	push   %esi
  8004f5:	53                   	push   %ebx
  8004f6:	83 ec 3c             	sub    $0x3c,%esp
  8004f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004fc:	89 d7                	mov    %edx,%edi
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800504:	8b 45 0c             	mov    0xc(%ebp),%eax
  800507:	89 c3                	mov    %eax,%ebx
  800509:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80050c:	8b 45 10             	mov    0x10(%ebp),%eax
  80050f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800512:	b9 00 00 00 00       	mov    $0x0,%ecx
  800517:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80051a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80051d:	39 d9                	cmp    %ebx,%ecx
  80051f:	72 05                	jb     800526 <printnum+0x36>
  800521:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800524:	77 69                	ja     80058f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800526:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800529:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80052d:	83 ee 01             	sub    $0x1,%esi
  800530:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800534:	89 44 24 08          	mov    %eax,0x8(%esp)
  800538:	8b 44 24 08          	mov    0x8(%esp),%eax
  80053c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800540:	89 c3                	mov    %eax,%ebx
  800542:	89 d6                	mov    %edx,%esi
  800544:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800547:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80054a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80054e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800552:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800555:	89 04 24             	mov    %eax,(%esp)
  800558:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80055b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80055f:	e8 2c 26 00 00       	call   802b90 <__udivdi3>
  800564:	89 d9                	mov    %ebx,%ecx
  800566:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80056a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80056e:	89 04 24             	mov    %eax,(%esp)
  800571:	89 54 24 04          	mov    %edx,0x4(%esp)
  800575:	89 fa                	mov    %edi,%edx
  800577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80057a:	e8 71 ff ff ff       	call   8004f0 <printnum>
  80057f:	eb 1b                	jmp    80059c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800581:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800585:	8b 45 18             	mov    0x18(%ebp),%eax
  800588:	89 04 24             	mov    %eax,(%esp)
  80058b:	ff d3                	call   *%ebx
  80058d:	eb 03                	jmp    800592 <printnum+0xa2>
  80058f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800592:	83 ee 01             	sub    $0x1,%esi
  800595:	85 f6                	test   %esi,%esi
  800597:	7f e8                	jg     800581 <printnum+0x91>
  800599:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80059c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005a0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8005a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005a7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8005aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005ae:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b5:	89 04 24             	mov    %eax,(%esp)
  8005b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005bf:	e8 fc 26 00 00       	call   802cc0 <__umoddi3>
  8005c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005c8:	0f be 80 03 30 80 00 	movsbl 0x803003(%eax),%eax
  8005cf:	89 04 24             	mov    %eax,(%esp)
  8005d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005d5:	ff d0                	call   *%eax
}
  8005d7:	83 c4 3c             	add    $0x3c,%esp
  8005da:	5b                   	pop    %ebx
  8005db:	5e                   	pop    %esi
  8005dc:	5f                   	pop    %edi
  8005dd:	5d                   	pop    %ebp
  8005de:	c3                   	ret    

008005df <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005e2:	83 fa 01             	cmp    $0x1,%edx
  8005e5:	7e 0e                	jle    8005f5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8005e7:	8b 10                	mov    (%eax),%edx
  8005e9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005ec:	89 08                	mov    %ecx,(%eax)
  8005ee:	8b 02                	mov    (%edx),%eax
  8005f0:	8b 52 04             	mov    0x4(%edx),%edx
  8005f3:	eb 22                	jmp    800617 <getuint+0x38>
	else if (lflag)
  8005f5:	85 d2                	test   %edx,%edx
  8005f7:	74 10                	je     800609 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005f9:	8b 10                	mov    (%eax),%edx
  8005fb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005fe:	89 08                	mov    %ecx,(%eax)
  800600:	8b 02                	mov    (%edx),%eax
  800602:	ba 00 00 00 00       	mov    $0x0,%edx
  800607:	eb 0e                	jmp    800617 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80060e:	89 08                	mov    %ecx,(%eax)
  800610:	8b 02                	mov    (%edx),%eax
  800612:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800617:	5d                   	pop    %ebp
  800618:	c3                   	ret    

00800619 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800619:	55                   	push   %ebp
  80061a:	89 e5                	mov    %esp,%ebp
  80061c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80061f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800623:	8b 10                	mov    (%eax),%edx
  800625:	3b 50 04             	cmp    0x4(%eax),%edx
  800628:	73 0a                	jae    800634 <sprintputch+0x1b>
		*b->buf++ = ch;
  80062a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80062d:	89 08                	mov    %ecx,(%eax)
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	88 02                	mov    %al,(%edx)
}
  800634:	5d                   	pop    %ebp
  800635:	c3                   	ret    

00800636 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
  800639:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80063c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80063f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800643:	8b 45 10             	mov    0x10(%ebp),%eax
  800646:	89 44 24 08          	mov    %eax,0x8(%esp)
  80064a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80064d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800651:	8b 45 08             	mov    0x8(%ebp),%eax
  800654:	89 04 24             	mov    %eax,(%esp)
  800657:	e8 02 00 00 00       	call   80065e <vprintfmt>
	va_end(ap);
}
  80065c:	c9                   	leave  
  80065d:	c3                   	ret    

0080065e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80065e:	55                   	push   %ebp
  80065f:	89 e5                	mov    %esp,%ebp
  800661:	57                   	push   %edi
  800662:	56                   	push   %esi
  800663:	53                   	push   %ebx
  800664:	83 ec 3c             	sub    $0x3c,%esp
  800667:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80066a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80066d:	eb 14                	jmp    800683 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80066f:	85 c0                	test   %eax,%eax
  800671:	0f 84 b3 03 00 00    	je     800a2a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800677:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80067b:	89 04 24             	mov    %eax,(%esp)
  80067e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800681:	89 f3                	mov    %esi,%ebx
  800683:	8d 73 01             	lea    0x1(%ebx),%esi
  800686:	0f b6 03             	movzbl (%ebx),%eax
  800689:	83 f8 25             	cmp    $0x25,%eax
  80068c:	75 e1                	jne    80066f <vprintfmt+0x11>
  80068e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800692:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800699:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8006a0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8006a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ac:	eb 1d                	jmp    8006cb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ae:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8006b0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8006b4:	eb 15                	jmp    8006cb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8006bc:	eb 0d                	jmp    8006cb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8006be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006c4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006cb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8006ce:	0f b6 0e             	movzbl (%esi),%ecx
  8006d1:	0f b6 c1             	movzbl %cl,%eax
  8006d4:	83 e9 23             	sub    $0x23,%ecx
  8006d7:	80 f9 55             	cmp    $0x55,%cl
  8006da:	0f 87 2a 03 00 00    	ja     800a0a <vprintfmt+0x3ac>
  8006e0:	0f b6 c9             	movzbl %cl,%ecx
  8006e3:	ff 24 8d 40 31 80 00 	jmp    *0x803140(,%ecx,4)
  8006ea:	89 de                	mov    %ebx,%esi
  8006ec:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8006f1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8006f4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8006f8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8006fb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8006fe:	83 fb 09             	cmp    $0x9,%ebx
  800701:	77 36                	ja     800739 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800703:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800706:	eb e9                	jmp    8006f1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8d 48 04             	lea    0x4(%eax),%ecx
  80070e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800711:	8b 00                	mov    (%eax),%eax
  800713:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800716:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800718:	eb 22                	jmp    80073c <vprintfmt+0xde>
  80071a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80071d:	85 c9                	test   %ecx,%ecx
  80071f:	b8 00 00 00 00       	mov    $0x0,%eax
  800724:	0f 49 c1             	cmovns %ecx,%eax
  800727:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80072a:	89 de                	mov    %ebx,%esi
  80072c:	eb 9d                	jmp    8006cb <vprintfmt+0x6d>
  80072e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800730:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800737:	eb 92                	jmp    8006cb <vprintfmt+0x6d>
  800739:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80073c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800740:	79 89                	jns    8006cb <vprintfmt+0x6d>
  800742:	e9 77 ff ff ff       	jmp    8006be <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800747:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80074a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80074c:	e9 7a ff ff ff       	jmp    8006cb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800751:	8b 45 14             	mov    0x14(%ebp),%eax
  800754:	8d 50 04             	lea    0x4(%eax),%edx
  800757:	89 55 14             	mov    %edx,0x14(%ebp)
  80075a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	89 04 24             	mov    %eax,(%esp)
  800763:	ff 55 08             	call   *0x8(%ebp)
			break;
  800766:	e9 18 ff ff ff       	jmp    800683 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80076b:	8b 45 14             	mov    0x14(%ebp),%eax
  80076e:	8d 50 04             	lea    0x4(%eax),%edx
  800771:	89 55 14             	mov    %edx,0x14(%ebp)
  800774:	8b 00                	mov    (%eax),%eax
  800776:	99                   	cltd   
  800777:	31 d0                	xor    %edx,%eax
  800779:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80077b:	83 f8 11             	cmp    $0x11,%eax
  80077e:	7f 0b                	jg     80078b <vprintfmt+0x12d>
  800780:	8b 14 85 a0 32 80 00 	mov    0x8032a0(,%eax,4),%edx
  800787:	85 d2                	test   %edx,%edx
  800789:	75 20                	jne    8007ab <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80078b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80078f:	c7 44 24 08 1b 30 80 	movl   $0x80301b,0x8(%esp)
  800796:	00 
  800797:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	89 04 24             	mov    %eax,(%esp)
  8007a1:	e8 90 fe ff ff       	call   800636 <printfmt>
  8007a6:	e9 d8 fe ff ff       	jmp    800683 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8007ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007af:	c7 44 24 08 e5 34 80 	movl   $0x8034e5,0x8(%esp)
  8007b6:	00 
  8007b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	89 04 24             	mov    %eax,(%esp)
  8007c1:	e8 70 fe ff ff       	call   800636 <printfmt>
  8007c6:	e9 b8 fe ff ff       	jmp    800683 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007cb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8007ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	8d 50 04             	lea    0x4(%eax),%edx
  8007da:	89 55 14             	mov    %edx,0x14(%ebp)
  8007dd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8007df:	85 f6                	test   %esi,%esi
  8007e1:	b8 14 30 80 00       	mov    $0x803014,%eax
  8007e6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8007e9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8007ed:	0f 84 97 00 00 00    	je     80088a <vprintfmt+0x22c>
  8007f3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007f7:	0f 8e 9b 00 00 00    	jle    800898 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007fd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800801:	89 34 24             	mov    %esi,(%esp)
  800804:	e8 cf 02 00 00       	call   800ad8 <strnlen>
  800809:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80080c:	29 c2                	sub    %eax,%edx
  80080e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800811:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800815:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800818:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80081b:	8b 75 08             	mov    0x8(%ebp),%esi
  80081e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800821:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800823:	eb 0f                	jmp    800834 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800825:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800829:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80082c:	89 04 24             	mov    %eax,(%esp)
  80082f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800831:	83 eb 01             	sub    $0x1,%ebx
  800834:	85 db                	test   %ebx,%ebx
  800836:	7f ed                	jg     800825 <vprintfmt+0x1c7>
  800838:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80083b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80083e:	85 d2                	test   %edx,%edx
  800840:	b8 00 00 00 00       	mov    $0x0,%eax
  800845:	0f 49 c2             	cmovns %edx,%eax
  800848:	29 c2                	sub    %eax,%edx
  80084a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80084d:	89 d7                	mov    %edx,%edi
  80084f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800852:	eb 50                	jmp    8008a4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800854:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800858:	74 1e                	je     800878 <vprintfmt+0x21a>
  80085a:	0f be d2             	movsbl %dl,%edx
  80085d:	83 ea 20             	sub    $0x20,%edx
  800860:	83 fa 5e             	cmp    $0x5e,%edx
  800863:	76 13                	jbe    800878 <vprintfmt+0x21a>
					putch('?', putdat);
  800865:	8b 45 0c             	mov    0xc(%ebp),%eax
  800868:	89 44 24 04          	mov    %eax,0x4(%esp)
  80086c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800873:	ff 55 08             	call   *0x8(%ebp)
  800876:	eb 0d                	jmp    800885 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800878:	8b 55 0c             	mov    0xc(%ebp),%edx
  80087b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80087f:	89 04 24             	mov    %eax,(%esp)
  800882:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800885:	83 ef 01             	sub    $0x1,%edi
  800888:	eb 1a                	jmp    8008a4 <vprintfmt+0x246>
  80088a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80088d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800890:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800893:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800896:	eb 0c                	jmp    8008a4 <vprintfmt+0x246>
  800898:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80089b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80089e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8008a1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8008a4:	83 c6 01             	add    $0x1,%esi
  8008a7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8008ab:	0f be c2             	movsbl %dl,%eax
  8008ae:	85 c0                	test   %eax,%eax
  8008b0:	74 27                	je     8008d9 <vprintfmt+0x27b>
  8008b2:	85 db                	test   %ebx,%ebx
  8008b4:	78 9e                	js     800854 <vprintfmt+0x1f6>
  8008b6:	83 eb 01             	sub    $0x1,%ebx
  8008b9:	79 99                	jns    800854 <vprintfmt+0x1f6>
  8008bb:	89 f8                	mov    %edi,%eax
  8008bd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8008c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c3:	89 c3                	mov    %eax,%ebx
  8008c5:	eb 1a                	jmp    8008e1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8008c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008cb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8008d2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008d4:	83 eb 01             	sub    $0x1,%ebx
  8008d7:	eb 08                	jmp    8008e1 <vprintfmt+0x283>
  8008d9:	89 fb                	mov    %edi,%ebx
  8008db:	8b 75 08             	mov    0x8(%ebp),%esi
  8008de:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8008e1:	85 db                	test   %ebx,%ebx
  8008e3:	7f e2                	jg     8008c7 <vprintfmt+0x269>
  8008e5:	89 75 08             	mov    %esi,0x8(%ebp)
  8008e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008eb:	e9 93 fd ff ff       	jmp    800683 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008f0:	83 fa 01             	cmp    $0x1,%edx
  8008f3:	7e 16                	jle    80090b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8008f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f8:	8d 50 08             	lea    0x8(%eax),%edx
  8008fb:	89 55 14             	mov    %edx,0x14(%ebp)
  8008fe:	8b 50 04             	mov    0x4(%eax),%edx
  800901:	8b 00                	mov    (%eax),%eax
  800903:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800906:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800909:	eb 32                	jmp    80093d <vprintfmt+0x2df>
	else if (lflag)
  80090b:	85 d2                	test   %edx,%edx
  80090d:	74 18                	je     800927 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	8d 50 04             	lea    0x4(%eax),%edx
  800915:	89 55 14             	mov    %edx,0x14(%ebp)
  800918:	8b 30                	mov    (%eax),%esi
  80091a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80091d:	89 f0                	mov    %esi,%eax
  80091f:	c1 f8 1f             	sar    $0x1f,%eax
  800922:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800925:	eb 16                	jmp    80093d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800927:	8b 45 14             	mov    0x14(%ebp),%eax
  80092a:	8d 50 04             	lea    0x4(%eax),%edx
  80092d:	89 55 14             	mov    %edx,0x14(%ebp)
  800930:	8b 30                	mov    (%eax),%esi
  800932:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800935:	89 f0                	mov    %esi,%eax
  800937:	c1 f8 1f             	sar    $0x1f,%eax
  80093a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80093d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800940:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800943:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800948:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094c:	0f 89 80 00 00 00    	jns    8009d2 <vprintfmt+0x374>
				putch('-', putdat);
  800952:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800956:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80095d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800960:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800963:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800966:	f7 d8                	neg    %eax
  800968:	83 d2 00             	adc    $0x0,%edx
  80096b:	f7 da                	neg    %edx
			}
			base = 10;
  80096d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800972:	eb 5e                	jmp    8009d2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800974:	8d 45 14             	lea    0x14(%ebp),%eax
  800977:	e8 63 fc ff ff       	call   8005df <getuint>
			base = 10;
  80097c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800981:	eb 4f                	jmp    8009d2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800983:	8d 45 14             	lea    0x14(%ebp),%eax
  800986:	e8 54 fc ff ff       	call   8005df <getuint>
			base = 8;
  80098b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800990:	eb 40                	jmp    8009d2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800992:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800996:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80099d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8009a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009a4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8009ab:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8009ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b1:	8d 50 04             	lea    0x4(%eax),%edx
  8009b4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8009be:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8009c3:	eb 0d                	jmp    8009d2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c8:	e8 12 fc ff ff       	call   8005df <getuint>
			base = 16;
  8009cd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009d2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8009d6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8009da:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8009dd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8009e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8009e5:	89 04 24             	mov    %eax,(%esp)
  8009e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009ec:	89 fa                	mov    %edi,%edx
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	e8 fa fa ff ff       	call   8004f0 <printnum>
			break;
  8009f6:	e9 88 fc ff ff       	jmp    800683 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009fb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ff:	89 04 24             	mov    %eax,(%esp)
  800a02:	ff 55 08             	call   *0x8(%ebp)
			break;
  800a05:	e9 79 fc ff ff       	jmp    800683 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a0a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a0e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800a15:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a18:	89 f3                	mov    %esi,%ebx
  800a1a:	eb 03                	jmp    800a1f <vprintfmt+0x3c1>
  800a1c:	83 eb 01             	sub    $0x1,%ebx
  800a1f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800a23:	75 f7                	jne    800a1c <vprintfmt+0x3be>
  800a25:	e9 59 fc ff ff       	jmp    800683 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800a2a:	83 c4 3c             	add    $0x3c,%esp
  800a2d:	5b                   	pop    %ebx
  800a2e:	5e                   	pop    %esi
  800a2f:	5f                   	pop    %edi
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    

00800a32 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a32:	55                   	push   %ebp
  800a33:	89 e5                	mov    %esp,%ebp
  800a35:	83 ec 28             	sub    $0x28,%esp
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a41:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a45:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a4f:	85 c0                	test   %eax,%eax
  800a51:	74 30                	je     800a83 <vsnprintf+0x51>
  800a53:	85 d2                	test   %edx,%edx
  800a55:	7e 2c                	jle    800a83 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a57:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a61:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a65:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a68:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a6c:	c7 04 24 19 06 80 00 	movl   $0x800619,(%esp)
  800a73:	e8 e6 fb ff ff       	call   80065e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a81:	eb 05                	jmp    800a88 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a83:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a88:	c9                   	leave  
  800a89:	c3                   	ret    

00800a8a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a90:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a97:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa8:	89 04 24             	mov    %eax,(%esp)
  800aab:	e8 82 ff ff ff       	call   800a32 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ab0:	c9                   	leave  
  800ab1:	c3                   	ret    
  800ab2:	66 90                	xchg   %ax,%ax
  800ab4:	66 90                	xchg   %ax,%ax
  800ab6:	66 90                	xchg   %ax,%ax
  800ab8:	66 90                	xchg   %ax,%ax
  800aba:	66 90                	xchg   %ax,%ax
  800abc:	66 90                	xchg   %ax,%ax
  800abe:	66 90                	xchg   %ax,%ax

00800ac0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac6:	b8 00 00 00 00       	mov    $0x0,%eax
  800acb:	eb 03                	jmp    800ad0 <strlen+0x10>
		n++;
  800acd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ad0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ad4:	75 f7                	jne    800acd <strlen+0xd>
		n++;
	return n;
}
  800ad6:	5d                   	pop    %ebp
  800ad7:	c3                   	ret    

00800ad8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ad8:	55                   	push   %ebp
  800ad9:	89 e5                	mov    %esp,%ebp
  800adb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ade:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ae1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae6:	eb 03                	jmp    800aeb <strnlen+0x13>
		n++;
  800ae8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800aeb:	39 d0                	cmp    %edx,%eax
  800aed:	74 06                	je     800af5 <strnlen+0x1d>
  800aef:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800af3:	75 f3                	jne    800ae8 <strnlen+0x10>
		n++;
	return n;
}
  800af5:	5d                   	pop    %ebp
  800af6:	c3                   	ret    

00800af7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	53                   	push   %ebx
  800afb:	8b 45 08             	mov    0x8(%ebp),%eax
  800afe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b01:	89 c2                	mov    %eax,%edx
  800b03:	83 c2 01             	add    $0x1,%edx
  800b06:	83 c1 01             	add    $0x1,%ecx
  800b09:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800b0d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b10:	84 db                	test   %bl,%bl
  800b12:	75 ef                	jne    800b03 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800b14:	5b                   	pop    %ebx
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	53                   	push   %ebx
  800b1b:	83 ec 08             	sub    $0x8,%esp
  800b1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b21:	89 1c 24             	mov    %ebx,(%esp)
  800b24:	e8 97 ff ff ff       	call   800ac0 <strlen>
	strcpy(dst + len, src);
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b30:	01 d8                	add    %ebx,%eax
  800b32:	89 04 24             	mov    %eax,(%esp)
  800b35:	e8 bd ff ff ff       	call   800af7 <strcpy>
	return dst;
}
  800b3a:	89 d8                	mov    %ebx,%eax
  800b3c:	83 c4 08             	add    $0x8,%esp
  800b3f:	5b                   	pop    %ebx
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	56                   	push   %esi
  800b46:	53                   	push   %ebx
  800b47:	8b 75 08             	mov    0x8(%ebp),%esi
  800b4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4d:	89 f3                	mov    %esi,%ebx
  800b4f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b52:	89 f2                	mov    %esi,%edx
  800b54:	eb 0f                	jmp    800b65 <strncpy+0x23>
		*dst++ = *src;
  800b56:	83 c2 01             	add    $0x1,%edx
  800b59:	0f b6 01             	movzbl (%ecx),%eax
  800b5c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b5f:	80 39 01             	cmpb   $0x1,(%ecx)
  800b62:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b65:	39 da                	cmp    %ebx,%edx
  800b67:	75 ed                	jne    800b56 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b69:	89 f0                	mov    %esi,%eax
  800b6b:	5b                   	pop    %ebx
  800b6c:	5e                   	pop    %esi
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	8b 75 08             	mov    0x8(%ebp),%esi
  800b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b83:	85 c9                	test   %ecx,%ecx
  800b85:	75 0b                	jne    800b92 <strlcpy+0x23>
  800b87:	eb 1d                	jmp    800ba6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b89:	83 c0 01             	add    $0x1,%eax
  800b8c:	83 c2 01             	add    $0x1,%edx
  800b8f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b92:	39 d8                	cmp    %ebx,%eax
  800b94:	74 0b                	je     800ba1 <strlcpy+0x32>
  800b96:	0f b6 0a             	movzbl (%edx),%ecx
  800b99:	84 c9                	test   %cl,%cl
  800b9b:	75 ec                	jne    800b89 <strlcpy+0x1a>
  800b9d:	89 c2                	mov    %eax,%edx
  800b9f:	eb 02                	jmp    800ba3 <strlcpy+0x34>
  800ba1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800ba3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800ba6:	29 f0                	sub    %esi,%eax
}
  800ba8:	5b                   	pop    %ebx
  800ba9:	5e                   	pop    %esi
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bb5:	eb 06                	jmp    800bbd <strcmp+0x11>
		p++, q++;
  800bb7:	83 c1 01             	add    $0x1,%ecx
  800bba:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bbd:	0f b6 01             	movzbl (%ecx),%eax
  800bc0:	84 c0                	test   %al,%al
  800bc2:	74 04                	je     800bc8 <strcmp+0x1c>
  800bc4:	3a 02                	cmp    (%edx),%al
  800bc6:	74 ef                	je     800bb7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bc8:	0f b6 c0             	movzbl %al,%eax
  800bcb:	0f b6 12             	movzbl (%edx),%edx
  800bce:	29 d0                	sub    %edx,%eax
}
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    

00800bd2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	53                   	push   %ebx
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdc:	89 c3                	mov    %eax,%ebx
  800bde:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800be1:	eb 06                	jmp    800be9 <strncmp+0x17>
		n--, p++, q++;
  800be3:	83 c0 01             	add    $0x1,%eax
  800be6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800be9:	39 d8                	cmp    %ebx,%eax
  800beb:	74 15                	je     800c02 <strncmp+0x30>
  800bed:	0f b6 08             	movzbl (%eax),%ecx
  800bf0:	84 c9                	test   %cl,%cl
  800bf2:	74 04                	je     800bf8 <strncmp+0x26>
  800bf4:	3a 0a                	cmp    (%edx),%cl
  800bf6:	74 eb                	je     800be3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bf8:	0f b6 00             	movzbl (%eax),%eax
  800bfb:	0f b6 12             	movzbl (%edx),%edx
  800bfe:	29 d0                	sub    %edx,%eax
  800c00:	eb 05                	jmp    800c07 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800c02:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c07:	5b                   	pop    %ebx
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c14:	eb 07                	jmp    800c1d <strchr+0x13>
		if (*s == c)
  800c16:	38 ca                	cmp    %cl,%dl
  800c18:	74 0f                	je     800c29 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c1a:	83 c0 01             	add    $0x1,%eax
  800c1d:	0f b6 10             	movzbl (%eax),%edx
  800c20:	84 d2                	test   %dl,%dl
  800c22:	75 f2                	jne    800c16 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800c24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c29:	5d                   	pop    %ebp
  800c2a:	c3                   	ret    

00800c2b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c35:	eb 07                	jmp    800c3e <strfind+0x13>
		if (*s == c)
  800c37:	38 ca                	cmp    %cl,%dl
  800c39:	74 0a                	je     800c45 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c3b:	83 c0 01             	add    $0x1,%eax
  800c3e:	0f b6 10             	movzbl (%eax),%edx
  800c41:	84 d2                	test   %dl,%dl
  800c43:	75 f2                	jne    800c37 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	57                   	push   %edi
  800c4b:	56                   	push   %esi
  800c4c:	53                   	push   %ebx
  800c4d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c50:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c53:	85 c9                	test   %ecx,%ecx
  800c55:	74 36                	je     800c8d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c57:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c5d:	75 28                	jne    800c87 <memset+0x40>
  800c5f:	f6 c1 03             	test   $0x3,%cl
  800c62:	75 23                	jne    800c87 <memset+0x40>
		c &= 0xFF;
  800c64:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c68:	89 d3                	mov    %edx,%ebx
  800c6a:	c1 e3 08             	shl    $0x8,%ebx
  800c6d:	89 d6                	mov    %edx,%esi
  800c6f:	c1 e6 18             	shl    $0x18,%esi
  800c72:	89 d0                	mov    %edx,%eax
  800c74:	c1 e0 10             	shl    $0x10,%eax
  800c77:	09 f0                	or     %esi,%eax
  800c79:	09 c2                	or     %eax,%edx
  800c7b:	89 d0                	mov    %edx,%eax
  800c7d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c7f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c82:	fc                   	cld    
  800c83:	f3 ab                	rep stos %eax,%es:(%edi)
  800c85:	eb 06                	jmp    800c8d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8a:	fc                   	cld    
  800c8b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c8d:	89 f8                	mov    %edi,%eax
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    

00800c94 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	57                   	push   %edi
  800c98:	56                   	push   %esi
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ca2:	39 c6                	cmp    %eax,%esi
  800ca4:	73 35                	jae    800cdb <memmove+0x47>
  800ca6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ca9:	39 d0                	cmp    %edx,%eax
  800cab:	73 2e                	jae    800cdb <memmove+0x47>
		s += n;
		d += n;
  800cad:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800cb0:	89 d6                	mov    %edx,%esi
  800cb2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cb4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cba:	75 13                	jne    800ccf <memmove+0x3b>
  800cbc:	f6 c1 03             	test   $0x3,%cl
  800cbf:	75 0e                	jne    800ccf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cc1:	83 ef 04             	sub    $0x4,%edi
  800cc4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cc7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800cca:	fd                   	std    
  800ccb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ccd:	eb 09                	jmp    800cd8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ccf:	83 ef 01             	sub    $0x1,%edi
  800cd2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800cd5:	fd                   	std    
  800cd6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cd8:	fc                   	cld    
  800cd9:	eb 1d                	jmp    800cf8 <memmove+0x64>
  800cdb:	89 f2                	mov    %esi,%edx
  800cdd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cdf:	f6 c2 03             	test   $0x3,%dl
  800ce2:	75 0f                	jne    800cf3 <memmove+0x5f>
  800ce4:	f6 c1 03             	test   $0x3,%cl
  800ce7:	75 0a                	jne    800cf3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ce9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800cec:	89 c7                	mov    %eax,%edi
  800cee:	fc                   	cld    
  800cef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cf1:	eb 05                	jmp    800cf8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800cf3:	89 c7                	mov    %eax,%edi
  800cf5:	fc                   	cld    
  800cf6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cf8:	5e                   	pop    %esi
  800cf9:	5f                   	pop    %edi
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d02:	8b 45 10             	mov    0x10(%ebp),%eax
  800d05:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	89 04 24             	mov    %eax,(%esp)
  800d16:	e8 79 ff ff ff       	call   800c94 <memmove>
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	56                   	push   %esi
  800d21:	53                   	push   %ebx
  800d22:	8b 55 08             	mov    0x8(%ebp),%edx
  800d25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d28:	89 d6                	mov    %edx,%esi
  800d2a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d2d:	eb 1a                	jmp    800d49 <memcmp+0x2c>
		if (*s1 != *s2)
  800d2f:	0f b6 02             	movzbl (%edx),%eax
  800d32:	0f b6 19             	movzbl (%ecx),%ebx
  800d35:	38 d8                	cmp    %bl,%al
  800d37:	74 0a                	je     800d43 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800d39:	0f b6 c0             	movzbl %al,%eax
  800d3c:	0f b6 db             	movzbl %bl,%ebx
  800d3f:	29 d8                	sub    %ebx,%eax
  800d41:	eb 0f                	jmp    800d52 <memcmp+0x35>
		s1++, s2++;
  800d43:	83 c2 01             	add    $0x1,%edx
  800d46:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d49:	39 f2                	cmp    %esi,%edx
  800d4b:	75 e2                	jne    800d2f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5d                   	pop    %ebp
  800d55:	c3                   	ret    

00800d56 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d5f:	89 c2                	mov    %eax,%edx
  800d61:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d64:	eb 07                	jmp    800d6d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d66:	38 08                	cmp    %cl,(%eax)
  800d68:	74 07                	je     800d71 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d6a:	83 c0 01             	add    $0x1,%eax
  800d6d:	39 d0                	cmp    %edx,%eax
  800d6f:	72 f5                	jb     800d66 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	57                   	push   %edi
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d7f:	eb 03                	jmp    800d84 <strtol+0x11>
		s++;
  800d81:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d84:	0f b6 0a             	movzbl (%edx),%ecx
  800d87:	80 f9 09             	cmp    $0x9,%cl
  800d8a:	74 f5                	je     800d81 <strtol+0xe>
  800d8c:	80 f9 20             	cmp    $0x20,%cl
  800d8f:	74 f0                	je     800d81 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d91:	80 f9 2b             	cmp    $0x2b,%cl
  800d94:	75 0a                	jne    800da0 <strtol+0x2d>
		s++;
  800d96:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d99:	bf 00 00 00 00       	mov    $0x0,%edi
  800d9e:	eb 11                	jmp    800db1 <strtol+0x3e>
  800da0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800da5:	80 f9 2d             	cmp    $0x2d,%cl
  800da8:	75 07                	jne    800db1 <strtol+0x3e>
		s++, neg = 1;
  800daa:	8d 52 01             	lea    0x1(%edx),%edx
  800dad:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800db6:	75 15                	jne    800dcd <strtol+0x5a>
  800db8:	80 3a 30             	cmpb   $0x30,(%edx)
  800dbb:	75 10                	jne    800dcd <strtol+0x5a>
  800dbd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800dc1:	75 0a                	jne    800dcd <strtol+0x5a>
		s += 2, base = 16;
  800dc3:	83 c2 02             	add    $0x2,%edx
  800dc6:	b8 10 00 00 00       	mov    $0x10,%eax
  800dcb:	eb 10                	jmp    800ddd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800dcd:	85 c0                	test   %eax,%eax
  800dcf:	75 0c                	jne    800ddd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800dd1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800dd3:	80 3a 30             	cmpb   $0x30,(%edx)
  800dd6:	75 05                	jne    800ddd <strtol+0x6a>
		s++, base = 8;
  800dd8:	83 c2 01             	add    $0x1,%edx
  800ddb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800ddd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800de5:	0f b6 0a             	movzbl (%edx),%ecx
  800de8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800deb:	89 f0                	mov    %esi,%eax
  800ded:	3c 09                	cmp    $0x9,%al
  800def:	77 08                	ja     800df9 <strtol+0x86>
			dig = *s - '0';
  800df1:	0f be c9             	movsbl %cl,%ecx
  800df4:	83 e9 30             	sub    $0x30,%ecx
  800df7:	eb 20                	jmp    800e19 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800df9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800dfc:	89 f0                	mov    %esi,%eax
  800dfe:	3c 19                	cmp    $0x19,%al
  800e00:	77 08                	ja     800e0a <strtol+0x97>
			dig = *s - 'a' + 10;
  800e02:	0f be c9             	movsbl %cl,%ecx
  800e05:	83 e9 57             	sub    $0x57,%ecx
  800e08:	eb 0f                	jmp    800e19 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800e0a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800e0d:	89 f0                	mov    %esi,%eax
  800e0f:	3c 19                	cmp    $0x19,%al
  800e11:	77 16                	ja     800e29 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800e13:	0f be c9             	movsbl %cl,%ecx
  800e16:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e19:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800e1c:	7d 0f                	jge    800e2d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800e1e:	83 c2 01             	add    $0x1,%edx
  800e21:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800e25:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800e27:	eb bc                	jmp    800de5 <strtol+0x72>
  800e29:	89 d8                	mov    %ebx,%eax
  800e2b:	eb 02                	jmp    800e2f <strtol+0xbc>
  800e2d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800e2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e33:	74 05                	je     800e3a <strtol+0xc7>
		*endptr = (char *) s;
  800e35:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e38:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800e3a:	f7 d8                	neg    %eax
  800e3c:	85 ff                	test   %edi,%edi
  800e3e:	0f 44 c3             	cmove  %ebx,%eax
}
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e51:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e54:	8b 55 08             	mov    0x8(%ebp),%edx
  800e57:	89 c3                	mov    %eax,%ebx
  800e59:	89 c7                	mov    %eax,%edi
  800e5b:	89 c6                	mov    %eax,%esi
  800e5d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e5f:	5b                   	pop    %ebx
  800e60:	5e                   	pop    %esi
  800e61:	5f                   	pop    %edi
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    

00800e64 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e6f:	b8 01 00 00 00       	mov    $0x1,%eax
  800e74:	89 d1                	mov    %edx,%ecx
  800e76:	89 d3                	mov    %edx,%ebx
  800e78:	89 d7                	mov    %edx,%edi
  800e7a:	89 d6                	mov    %edx,%esi
  800e7c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5f                   	pop    %edi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	57                   	push   %edi
  800e87:	56                   	push   %esi
  800e88:	53                   	push   %ebx
  800e89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e91:	b8 03 00 00 00       	mov    $0x3,%eax
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	89 cb                	mov    %ecx,%ebx
  800e9b:	89 cf                	mov    %ecx,%edi
  800e9d:	89 ce                	mov    %ecx,%esi
  800e9f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ea1:	85 c0                	test   %eax,%eax
  800ea3:	7e 28                	jle    800ecd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800eb0:	00 
  800eb1:	c7 44 24 08 07 33 80 	movl   $0x803307,0x8(%esp)
  800eb8:	00 
  800eb9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ec0:	00 
  800ec1:	c7 04 24 24 33 80 00 	movl   $0x803324,(%esp)
  800ec8:	e8 08 f5 ff ff       	call   8003d5 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ecd:	83 c4 2c             	add    $0x2c,%esp
  800ed0:	5b                   	pop    %ebx
  800ed1:	5e                   	pop    %esi
  800ed2:	5f                   	pop    %edi
  800ed3:	5d                   	pop    %ebp
  800ed4:	c3                   	ret    

00800ed5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	57                   	push   %edi
  800ed9:	56                   	push   %esi
  800eda:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800edb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee0:	b8 02 00 00 00       	mov    $0x2,%eax
  800ee5:	89 d1                	mov    %edx,%ecx
  800ee7:	89 d3                	mov    %edx,%ebx
  800ee9:	89 d7                	mov    %edx,%edi
  800eeb:	89 d6                	mov    %edx,%esi
  800eed:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800eef:	5b                   	pop    %ebx
  800ef0:	5e                   	pop    %esi
  800ef1:	5f                   	pop    %edi
  800ef2:	5d                   	pop    %ebp
  800ef3:	c3                   	ret    

00800ef4 <sys_yield>:

void
sys_yield(void)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	57                   	push   %edi
  800ef8:	56                   	push   %esi
  800ef9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efa:	ba 00 00 00 00       	mov    $0x0,%edx
  800eff:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f04:	89 d1                	mov    %edx,%ecx
  800f06:	89 d3                	mov    %edx,%ebx
  800f08:	89 d7                	mov    %edx,%edi
  800f0a:	89 d6                	mov    %edx,%esi
  800f0c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f0e:	5b                   	pop    %ebx
  800f0f:	5e                   	pop    %esi
  800f10:	5f                   	pop    %edi
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	57                   	push   %edi
  800f17:	56                   	push   %esi
  800f18:	53                   	push   %ebx
  800f19:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1c:	be 00 00 00 00       	mov    $0x0,%esi
  800f21:	b8 04 00 00 00       	mov    $0x4,%eax
  800f26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f29:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2f:	89 f7                	mov    %esi,%edi
  800f31:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f33:	85 c0                	test   %eax,%eax
  800f35:	7e 28                	jle    800f5f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f37:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f42:	00 
  800f43:	c7 44 24 08 07 33 80 	movl   $0x803307,0x8(%esp)
  800f4a:	00 
  800f4b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f52:	00 
  800f53:	c7 04 24 24 33 80 00 	movl   $0x803324,(%esp)
  800f5a:	e8 76 f4 ff ff       	call   8003d5 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f5f:	83 c4 2c             	add    $0x2c,%esp
  800f62:	5b                   	pop    %ebx
  800f63:	5e                   	pop    %esi
  800f64:	5f                   	pop    %edi
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	57                   	push   %edi
  800f6b:	56                   	push   %esi
  800f6c:	53                   	push   %ebx
  800f6d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f70:	b8 05 00 00 00       	mov    $0x5,%eax
  800f75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f78:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f81:	8b 75 18             	mov    0x18(%ebp),%esi
  800f84:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f86:	85 c0                	test   %eax,%eax
  800f88:	7e 28                	jle    800fb2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f95:	00 
  800f96:	c7 44 24 08 07 33 80 	movl   $0x803307,0x8(%esp)
  800f9d:	00 
  800f9e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa5:	00 
  800fa6:	c7 04 24 24 33 80 00 	movl   $0x803324,(%esp)
  800fad:	e8 23 f4 ff ff       	call   8003d5 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800fb2:	83 c4 2c             	add    $0x2c,%esp
  800fb5:	5b                   	pop    %ebx
  800fb6:	5e                   	pop    %esi
  800fb7:	5f                   	pop    %edi
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	57                   	push   %edi
  800fbe:	56                   	push   %esi
  800fbf:	53                   	push   %ebx
  800fc0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc8:	b8 06 00 00 00       	mov    $0x6,%eax
  800fcd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd3:	89 df                	mov    %ebx,%edi
  800fd5:	89 de                	mov    %ebx,%esi
  800fd7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800fd9:	85 c0                	test   %eax,%eax
  800fdb:	7e 28                	jle    801005 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fdd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800fe8:	00 
  800fe9:	c7 44 24 08 07 33 80 	movl   $0x803307,0x8(%esp)
  800ff0:	00 
  800ff1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff8:	00 
  800ff9:	c7 04 24 24 33 80 00 	movl   $0x803324,(%esp)
  801000:	e8 d0 f3 ff ff       	call   8003d5 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801005:	83 c4 2c             	add    $0x2c,%esp
  801008:	5b                   	pop    %ebx
  801009:	5e                   	pop    %esi
  80100a:	5f                   	pop    %edi
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    

0080100d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	57                   	push   %edi
  801011:	56                   	push   %esi
  801012:	53                   	push   %ebx
  801013:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801016:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101b:	b8 08 00 00 00       	mov    $0x8,%eax
  801020:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801023:	8b 55 08             	mov    0x8(%ebp),%edx
  801026:	89 df                	mov    %ebx,%edi
  801028:	89 de                	mov    %ebx,%esi
  80102a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80102c:	85 c0                	test   %eax,%eax
  80102e:	7e 28                	jle    801058 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801030:	89 44 24 10          	mov    %eax,0x10(%esp)
  801034:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80103b:	00 
  80103c:	c7 44 24 08 07 33 80 	movl   $0x803307,0x8(%esp)
  801043:	00 
  801044:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80104b:	00 
  80104c:	c7 04 24 24 33 80 00 	movl   $0x803324,(%esp)
  801053:	e8 7d f3 ff ff       	call   8003d5 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801058:	83 c4 2c             	add    $0x2c,%esp
  80105b:	5b                   	pop    %ebx
  80105c:	5e                   	pop    %esi
  80105d:	5f                   	pop    %edi
  80105e:	5d                   	pop    %ebp
  80105f:	c3                   	ret    

00801060 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	57                   	push   %edi
  801064:	56                   	push   %esi
  801065:	53                   	push   %ebx
  801066:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801069:	bb 00 00 00 00       	mov    $0x0,%ebx
  80106e:	b8 09 00 00 00       	mov    $0x9,%eax
  801073:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801076:	8b 55 08             	mov    0x8(%ebp),%edx
  801079:	89 df                	mov    %ebx,%edi
  80107b:	89 de                	mov    %ebx,%esi
  80107d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80107f:	85 c0                	test   %eax,%eax
  801081:	7e 28                	jle    8010ab <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801083:	89 44 24 10          	mov    %eax,0x10(%esp)
  801087:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80108e:	00 
  80108f:	c7 44 24 08 07 33 80 	movl   $0x803307,0x8(%esp)
  801096:	00 
  801097:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80109e:	00 
  80109f:	c7 04 24 24 33 80 00 	movl   $0x803324,(%esp)
  8010a6:	e8 2a f3 ff ff       	call   8003d5 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010ab:	83 c4 2c             	add    $0x2c,%esp
  8010ae:	5b                   	pop    %ebx
  8010af:	5e                   	pop    %esi
  8010b0:	5f                   	pop    %edi
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    

008010b3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	57                   	push   %edi
  8010b7:	56                   	push   %esi
  8010b8:	53                   	push   %ebx
  8010b9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cc:	89 df                	mov    %ebx,%edi
  8010ce:	89 de                	mov    %ebx,%esi
  8010d0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	7e 28                	jle    8010fe <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010da:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8010e1:	00 
  8010e2:	c7 44 24 08 07 33 80 	movl   $0x803307,0x8(%esp)
  8010e9:	00 
  8010ea:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f1:	00 
  8010f2:	c7 04 24 24 33 80 00 	movl   $0x803324,(%esp)
  8010f9:	e8 d7 f2 ff ff       	call   8003d5 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010fe:	83 c4 2c             	add    $0x2c,%esp
  801101:	5b                   	pop    %ebx
  801102:	5e                   	pop    %esi
  801103:	5f                   	pop    %edi
  801104:	5d                   	pop    %ebp
  801105:	c3                   	ret    

00801106 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	57                   	push   %edi
  80110a:	56                   	push   %esi
  80110b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80110c:	be 00 00 00 00       	mov    $0x0,%esi
  801111:	b8 0c 00 00 00       	mov    $0xc,%eax
  801116:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801119:	8b 55 08             	mov    0x8(%ebp),%edx
  80111c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80111f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801122:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801124:	5b                   	pop    %ebx
  801125:	5e                   	pop    %esi
  801126:	5f                   	pop    %edi
  801127:	5d                   	pop    %ebp
  801128:	c3                   	ret    

00801129 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801129:	55                   	push   %ebp
  80112a:	89 e5                	mov    %esp,%ebp
  80112c:	57                   	push   %edi
  80112d:	56                   	push   %esi
  80112e:	53                   	push   %ebx
  80112f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801132:	b9 00 00 00 00       	mov    $0x0,%ecx
  801137:	b8 0d 00 00 00       	mov    $0xd,%eax
  80113c:	8b 55 08             	mov    0x8(%ebp),%edx
  80113f:	89 cb                	mov    %ecx,%ebx
  801141:	89 cf                	mov    %ecx,%edi
  801143:	89 ce                	mov    %ecx,%esi
  801145:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801147:	85 c0                	test   %eax,%eax
  801149:	7e 28                	jle    801173 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80114b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80114f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801156:	00 
  801157:	c7 44 24 08 07 33 80 	movl   $0x803307,0x8(%esp)
  80115e:	00 
  80115f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801166:	00 
  801167:	c7 04 24 24 33 80 00 	movl   $0x803324,(%esp)
  80116e:	e8 62 f2 ff ff       	call   8003d5 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801173:	83 c4 2c             	add    $0x2c,%esp
  801176:	5b                   	pop    %ebx
  801177:	5e                   	pop    %esi
  801178:	5f                   	pop    %edi
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    

0080117b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	57                   	push   %edi
  80117f:	56                   	push   %esi
  801180:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801181:	ba 00 00 00 00       	mov    $0x0,%edx
  801186:	b8 0e 00 00 00       	mov    $0xe,%eax
  80118b:	89 d1                	mov    %edx,%ecx
  80118d:	89 d3                	mov    %edx,%ebx
  80118f:	89 d7                	mov    %edx,%edi
  801191:	89 d6                	mov    %edx,%esi
  801193:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801195:	5b                   	pop    %ebx
  801196:	5e                   	pop    %esi
  801197:	5f                   	pop    %edi
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    

0080119a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	57                   	push   %edi
  80119e:	56                   	push   %esi
  80119f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a5:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b0:	89 df                	mov    %ebx,%edi
  8011b2:	89 de                	mov    %ebx,%esi
  8011b4:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  8011b6:	5b                   	pop    %ebx
  8011b7:	5e                   	pop    %esi
  8011b8:	5f                   	pop    %edi
  8011b9:	5d                   	pop    %ebp
  8011ba:	c3                   	ret    

008011bb <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	57                   	push   %edi
  8011bf:	56                   	push   %esi
  8011c0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c6:	b8 10 00 00 00       	mov    $0x10,%eax
  8011cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d1:	89 df                	mov    %ebx,%edi
  8011d3:	89 de                	mov    %ebx,%esi
  8011d5:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  8011d7:	5b                   	pop    %ebx
  8011d8:	5e                   	pop    %esi
  8011d9:	5f                   	pop    %edi
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    

008011dc <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	57                   	push   %edi
  8011e0:	56                   	push   %esi
  8011e1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011e7:	b8 11 00 00 00       	mov    $0x11,%eax
  8011ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ef:	89 cb                	mov    %ecx,%ebx
  8011f1:	89 cf                	mov    %ecx,%edi
  8011f3:	89 ce                	mov    %ecx,%esi
  8011f5:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  8011f7:	5b                   	pop    %ebx
  8011f8:	5e                   	pop    %esi
  8011f9:	5f                   	pop    %edi
  8011fa:	5d                   	pop    %ebp
  8011fb:	c3                   	ret    

008011fc <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	57                   	push   %edi
  801200:	56                   	push   %esi
  801201:	53                   	push   %ebx
  801202:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801205:	be 00 00 00 00       	mov    $0x0,%esi
  80120a:	b8 12 00 00 00       	mov    $0x12,%eax
  80120f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801212:	8b 55 08             	mov    0x8(%ebp),%edx
  801215:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801218:	8b 7d 14             	mov    0x14(%ebp),%edi
  80121b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80121d:	85 c0                	test   %eax,%eax
  80121f:	7e 28                	jle    801249 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801221:	89 44 24 10          	mov    %eax,0x10(%esp)
  801225:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80122c:	00 
  80122d:	c7 44 24 08 07 33 80 	movl   $0x803307,0x8(%esp)
  801234:	00 
  801235:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80123c:	00 
  80123d:	c7 04 24 24 33 80 00 	movl   $0x803324,(%esp)
  801244:	e8 8c f1 ff ff       	call   8003d5 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801249:	83 c4 2c             	add    $0x2c,%esp
  80124c:	5b                   	pop    %ebx
  80124d:	5e                   	pop    %esi
  80124e:	5f                   	pop    %edi
  80124f:	5d                   	pop    %ebp
  801250:	c3                   	ret    

00801251 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	53                   	push   %ebx
  801255:	83 ec 24             	sub    $0x24,%esp
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80125b:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0)
  80125d:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801261:	75 20                	jne    801283 <pgfault+0x32>
		panic("pgfault: faulting address [%08x] not a write\n", addr);
  801263:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801267:	c7 44 24 08 34 33 80 	movl   $0x803334,0x8(%esp)
  80126e:	00 
  80126f:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  801276:	00 
  801277:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  80127e:	e8 52 f1 ff ff       	call   8003d5 <_panic>

	void *page_aligned_addr = (void *) ROUNDDOWN(addr, PGSIZE);
  801283:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t page_num = (uint32_t) page_aligned_addr / PGSIZE;
  801289:	89 d8                	mov    %ebx,%eax
  80128b:	c1 e8 0c             	shr    $0xc,%eax
	if (!(uvpt[page_num] & PTE_COW))
  80128e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801295:	f6 c4 08             	test   $0x8,%ah
  801298:	75 1c                	jne    8012b6 <pgfault+0x65>
		panic("pgfault: fault was not on a copy-on-write page\n");
  80129a:	c7 44 24 08 64 33 80 	movl   $0x803364,0x8(%esp)
  8012a1:	00 
  8012a2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012a9:	00 
  8012aa:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  8012b1:	e8 1f f1 ff ff       	call   8003d5 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	// Allocate
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8012b6:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012bd:	00 
  8012be:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012c5:	00 
  8012c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012cd:	e8 41 fc ff ff       	call   800f13 <sys_page_alloc>
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	79 20                	jns    8012f6 <pgfault+0xa5>
		panic("sys_page_alloc: %e\n", r);
  8012d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012da:	c7 44 24 08 bf 33 80 	movl   $0x8033bf,0x8(%esp)
  8012e1:	00 
  8012e2:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  8012e9:	00 
  8012ea:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  8012f1:	e8 df f0 ff ff       	call   8003d5 <_panic>

	// Copy over
	void *src_addr = (void *) ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, src_addr, PGSIZE);
  8012f6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8012fd:	00 
  8012fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801302:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801309:	e8 86 f9 ff ff       	call   800c94 <memmove>

	// Remap
	if ((r = sys_page_map(0, PFTEMP, 0, src_addr, PTE_P | PTE_U | PTE_W)) < 0)
  80130e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801315:	00 
  801316:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80131a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801321:	00 
  801322:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801329:	00 
  80132a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801331:	e8 31 fc ff ff       	call   800f67 <sys_page_map>
  801336:	85 c0                	test   %eax,%eax
  801338:	79 20                	jns    80135a <pgfault+0x109>
		panic("sys_page_map: %e\n", r);
  80133a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80133e:	c7 44 24 08 d3 33 80 	movl   $0x8033d3,0x8(%esp)
  801345:	00 
  801346:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  80134d:	00 
  80134e:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  801355:	e8 7b f0 ff ff       	call   8003d5 <_panic>

	//panic("pgfault not implemented");
}
  80135a:	83 c4 24             	add    $0x24,%esp
  80135d:	5b                   	pop    %ebx
  80135e:	5d                   	pop    %ebp
  80135f:	c3                   	ret    

00801360 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	57                   	push   %edi
  801364:	56                   	push   %esi
  801365:	53                   	push   %ebx
  801366:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	int r;
	envid_t child_envid;

	set_pgfault_handler(pgfault);
  801369:	c7 04 24 51 12 80 00 	movl   $0x801251,(%esp)
  801370:	e8 31 17 00 00       	call   802aa6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801375:	b8 07 00 00 00       	mov    $0x7,%eax
  80137a:	cd 30                	int    $0x30
  80137c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80137f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	child_envid = sys_exofork();
	if (child_envid < 0)
  801382:	85 c0                	test   %eax,%eax
  801384:	79 20                	jns    8013a6 <fork+0x46>
		panic("sys_exofork: %e\n", child_envid);
  801386:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80138a:	c7 44 24 08 e5 33 80 	movl   $0x8033e5,0x8(%esp)
  801391:	00 
  801392:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  801399:	00 
  80139a:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  8013a1:	e8 2f f0 ff ff       	call   8003d5 <_panic>
	if (child_envid == 0) { // child
  8013a6:	bf 00 00 00 00       	mov    $0x0,%edi
  8013ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8013b4:	75 21                	jne    8013d7 <fork+0x77>
		// Fix thisenv like dumbfork does and return 0
		thisenv = &envs[ENVX(sys_getenvid())];
  8013b6:	e8 1a fb ff ff       	call   800ed5 <sys_getenvid>
  8013bb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013c0:	c1 e0 07             	shl    $0x7,%eax
  8013c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8013c8:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  8013cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d2:	e9 53 02 00 00       	jmp    80162a <fork+0x2ca>
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
  8013d7:	89 d8                	mov    %ebx,%eax
  8013d9:	c1 e8 0a             	shr    $0xa,%eax
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  8013dc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013e3:	a8 01                	test   $0x1,%al
  8013e5:	0f 84 7a 01 00 00    	je     801565 <fork+0x205>
			((uvpt[page_num] & PTE_P) == PTE_P)) {
  8013eb:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  8013f2:	a8 01                	test   $0x1,%al
  8013f4:	0f 84 6b 01 00 00    	je     801565 <fork+0x205>
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
	envid_t this_envid = thisenv->env_id;
  8013fa:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8013ff:	8b 40 48             	mov    0x48(%eax),%eax
  801402:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 4: Your code here.
	if (uvpt[pn] & PTE_SHARE) {
  801405:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80140c:	f6 c4 04             	test   $0x4,%ah
  80140f:	74 52                	je     801463 <fork+0x103>
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801411:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801418:	25 07 0e 00 00       	and    $0xe07,%eax
  80141d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801421:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801425:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801428:	89 44 24 08          	mov    %eax,0x8(%esp)
  80142c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801433:	89 04 24             	mov    %eax,(%esp)
  801436:	e8 2c fb ff ff       	call   800f67 <sys_page_map>
  80143b:	85 c0                	test   %eax,%eax
  80143d:	0f 89 22 01 00 00    	jns    801565 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801443:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801447:	c7 44 24 08 d3 33 80 	movl   $0x8033d3,0x8(%esp)
  80144e:	00 
  80144f:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  801456:	00 
  801457:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  80145e:	e8 72 ef ff ff       	call   8003d5 <_panic>
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
  801463:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80146a:	f6 c4 08             	test   $0x8,%ah
  80146d:	75 0f                	jne    80147e <fork+0x11e>
  80146f:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801476:	a8 02                	test   $0x2,%al
  801478:	0f 84 99 00 00 00    	je     801517 <fork+0x1b7>
		if (uvpt[pn] & PTE_U)
  80147e:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801485:	83 e0 04             	and    $0x4,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
  801488:	83 f8 01             	cmp    $0x1,%eax
  80148b:	19 f6                	sbb    %esi,%esi
  80148d:	83 e6 fc             	and    $0xfffffffc,%esi
  801490:	81 c6 05 08 00 00    	add    $0x805,%esi
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
		if (uvpt[pn] & PTE_U)
			perm |= PTE_U;

		// Map page COW, U and P in child
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), perm)) < 0)
  801496:	89 74 24 10          	mov    %esi,0x10(%esp)
  80149a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80149e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ac:	89 04 24             	mov    %eax,(%esp)
  8014af:	e8 b3 fa ff ff       	call   800f67 <sys_page_map>
  8014b4:	85 c0                	test   %eax,%eax
  8014b6:	79 20                	jns    8014d8 <fork+0x178>
			panic("sys_page_map: %e\n", r);
  8014b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014bc:	c7 44 24 08 d3 33 80 	movl   $0x8033d3,0x8(%esp)
  8014c3:	00 
  8014c4:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  8014cb:	00 
  8014cc:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  8014d3:	e8 fd ee ff ff       	call   8003d5 <_panic>

		// Map page COW, U and P in parent
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), this_envid, (void *) (pn*PGSIZE), perm)) < 0)
  8014d8:	89 74 24 10          	mov    %esi,0x10(%esp)
  8014dc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8014e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014eb:	89 04 24             	mov    %eax,(%esp)
  8014ee:	e8 74 fa ff ff       	call   800f67 <sys_page_map>
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	79 6e                	jns    801565 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  8014f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014fb:	c7 44 24 08 d3 33 80 	movl   $0x8033d3,0x8(%esp)
  801502:	00 
  801503:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  80150a:	00 
  80150b:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  801512:	e8 be ee ff ff       	call   8003d5 <_panic>

	} else { // map pages that are present but not writable or COW with their original permissions
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801517:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80151e:	25 07 0e 00 00       	and    $0xe07,%eax
  801523:	89 44 24 10          	mov    %eax,0x10(%esp)
  801527:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80152b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801532:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801536:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801539:	89 04 24             	mov    %eax,(%esp)
  80153c:	e8 26 fa ff ff       	call   800f67 <sys_page_map>
  801541:	85 c0                	test   %eax,%eax
  801543:	79 20                	jns    801565 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801545:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801549:	c7 44 24 08 d3 33 80 	movl   $0x8033d3,0x8(%esp)
  801550:	00 
  801551:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  801558:	00 
  801559:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  801560:	e8 70 ee ff ff       	call   8003d5 <_panic>
	// and let duppage worry about the permissions.
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
  801565:	83 c3 01             	add    $0x1,%ebx
  801568:	81 c7 00 10 00 00    	add    $0x1000,%edi
  80156e:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801574:	0f 85 5d fe ff ff    	jne    8013d7 <fork+0x77>
	}

	// Allocate exception stack space for child. The child can't do this themselves
	// because the mechanism by which it would is to run the pgfault handler, which
	// needs to run on the exception stack (catch 22).
	if ((r = sys_page_alloc(child_envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80157a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801581:	00 
  801582:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801589:	ee 
  80158a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80158d:	89 04 24             	mov    %eax,(%esp)
  801590:	e8 7e f9 ff ff       	call   800f13 <sys_page_alloc>
  801595:	85 c0                	test   %eax,%eax
  801597:	79 20                	jns    8015b9 <fork+0x259>
		panic("sys_page_alloc: %e\n", r);
  801599:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80159d:	c7 44 24 08 bf 33 80 	movl   $0x8033bf,0x8(%esp)
  8015a4:	00 
  8015a5:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  8015ac:	00 
  8015ad:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  8015b4:	e8 1c ee ff ff       	call   8003d5 <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  8015b9:	c7 44 24 04 27 2b 80 	movl   $0x802b27,0x4(%esp)
  8015c0:	00 
  8015c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015c4:	89 04 24             	mov    %eax,(%esp)
  8015c7:	e8 e7 fa ff ff       	call   8010b3 <sys_env_set_pgfault_upcall>
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	79 20                	jns    8015f0 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  8015d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015d4:	c7 44 24 08 94 33 80 	movl   $0x803394,0x8(%esp)
  8015db:	00 
  8015dc:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8015e3:	00 
  8015e4:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  8015eb:	e8 e5 ed ff ff       	call   8003d5 <_panic>

	// Mark child environment as runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  8015f0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8015f7:	00 
  8015f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015fb:	89 04 24             	mov    %eax,(%esp)
  8015fe:	e8 0a fa ff ff       	call   80100d <sys_env_set_status>
  801603:	85 c0                	test   %eax,%eax
  801605:	79 20                	jns    801627 <fork+0x2c7>
		panic("sys_env_set_status: %e\n", r);
  801607:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80160b:	c7 44 24 08 f6 33 80 	movl   $0x8033f6,0x8(%esp)
  801612:	00 
  801613:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80161a:	00 
  80161b:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  801622:	e8 ae ed ff ff       	call   8003d5 <_panic>

	return child_envid;
  801627:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  80162a:	83 c4 2c             	add    $0x2c,%esp
  80162d:	5b                   	pop    %ebx
  80162e:	5e                   	pop    %esi
  80162f:	5f                   	pop    %edi
  801630:	5d                   	pop    %ebp
  801631:	c3                   	ret    

00801632 <sfork>:

// Challenge!
int
sfork(void)
{
  801632:	55                   	push   %ebp
  801633:	89 e5                	mov    %esp,%ebp
  801635:	83 ec 18             	sub    $0x18,%esp
//	return __fork(1);
	panic("sfork not implemented");
  801638:	c7 44 24 08 0e 34 80 	movl   $0x80340e,0x8(%esp)
  80163f:	00 
  801640:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  801647:	00 
  801648:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  80164f:	e8 81 ed ff ff       	call   8003d5 <_panic>
  801654:	66 90                	xchg   %ax,%ax
  801656:	66 90                	xchg   %ax,%ax
  801658:	66 90                	xchg   %ax,%ax
  80165a:	66 90                	xchg   %ax,%ax
  80165c:	66 90                	xchg   %ax,%ax
  80165e:	66 90                	xchg   %ax,%ax

00801660 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	56                   	push   %esi
  801664:	53                   	push   %ebx
  801665:	83 ec 10             	sub    $0x10,%esp
  801668:	8b 75 08             	mov    0x8(%ebp),%esi
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  801671:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  801673:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  801678:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80167b:	89 04 24             	mov    %eax,(%esp)
  80167e:	e8 a6 fa ff ff       	call   801129 <sys_ipc_recv>
  801683:	85 c0                	test   %eax,%eax
  801685:	74 16                	je     80169d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  801687:	85 f6                	test   %esi,%esi
  801689:	74 06                	je     801691 <ipc_recv+0x31>
			*from_env_store = 0;
  80168b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  801691:	85 db                	test   %ebx,%ebx
  801693:	74 2c                	je     8016c1 <ipc_recv+0x61>
			*perm_store = 0;
  801695:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80169b:	eb 24                	jmp    8016c1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80169d:	85 f6                	test   %esi,%esi
  80169f:	74 0a                	je     8016ab <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8016a1:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8016a6:	8b 40 74             	mov    0x74(%eax),%eax
  8016a9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8016ab:	85 db                	test   %ebx,%ebx
  8016ad:	74 0a                	je     8016b9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8016af:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8016b4:	8b 40 78             	mov    0x78(%eax),%eax
  8016b7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8016b9:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8016be:	8b 40 70             	mov    0x70(%eax),%eax
}
  8016c1:	83 c4 10             	add    $0x10,%esp
  8016c4:	5b                   	pop    %ebx
  8016c5:	5e                   	pop    %esi
  8016c6:	5d                   	pop    %ebp
  8016c7:	c3                   	ret    

008016c8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8016c8:	55                   	push   %ebp
  8016c9:	89 e5                	mov    %esp,%ebp
  8016cb:	57                   	push   %edi
  8016cc:	56                   	push   %esi
  8016cd:	53                   	push   %ebx
  8016ce:	83 ec 1c             	sub    $0x1c,%esp
  8016d1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016d7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8016da:	85 db                	test   %ebx,%ebx
  8016dc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8016e1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8016e4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016e8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	89 04 24             	mov    %eax,(%esp)
  8016f6:	e8 0b fa ff ff       	call   801106 <sys_ipc_try_send>
	if (r == 0) return;
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	75 22                	jne    801721 <ipc_send+0x59>
  8016ff:	eb 4c                	jmp    80174d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  801701:	84 d2                	test   %dl,%dl
  801703:	75 48                	jne    80174d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  801705:	e8 ea f7 ff ff       	call   800ef4 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80170a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80170e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801712:	89 74 24 04          	mov    %esi,0x4(%esp)
  801716:	8b 45 08             	mov    0x8(%ebp),%eax
  801719:	89 04 24             	mov    %eax,(%esp)
  80171c:	e8 e5 f9 ff ff       	call   801106 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  801721:	85 c0                	test   %eax,%eax
  801723:	0f 94 c2             	sete   %dl
  801726:	74 d9                	je     801701 <ipc_send+0x39>
  801728:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80172b:	74 d4                	je     801701 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80172d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801731:	c7 44 24 08 24 34 80 	movl   $0x803424,0x8(%esp)
  801738:	00 
  801739:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  801740:	00 
  801741:	c7 04 24 32 34 80 00 	movl   $0x803432,(%esp)
  801748:	e8 88 ec ff ff       	call   8003d5 <_panic>
}
  80174d:	83 c4 1c             	add    $0x1c,%esp
  801750:	5b                   	pop    %ebx
  801751:	5e                   	pop    %esi
  801752:	5f                   	pop    %edi
  801753:	5d                   	pop    %ebp
  801754:	c3                   	ret    

00801755 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80175b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801760:	89 c2                	mov    %eax,%edx
  801762:	c1 e2 07             	shl    $0x7,%edx
  801765:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80176b:	8b 52 50             	mov    0x50(%edx),%edx
  80176e:	39 ca                	cmp    %ecx,%edx
  801770:	75 0d                	jne    80177f <ipc_find_env+0x2a>
			return envs[i].env_id;
  801772:	c1 e0 07             	shl    $0x7,%eax
  801775:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80177a:	8b 40 40             	mov    0x40(%eax),%eax
  80177d:	eb 0e                	jmp    80178d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80177f:	83 c0 01             	add    $0x1,%eax
  801782:	3d 00 04 00 00       	cmp    $0x400,%eax
  801787:	75 d7                	jne    801760 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801789:	66 b8 00 00          	mov    $0x0,%ax
}
  80178d:	5d                   	pop    %ebp
  80178e:	c3                   	ret    
  80178f:	90                   	nop

00801790 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
  801796:	05 00 00 00 30       	add    $0x30000000,%eax
  80179b:	c1 e8 0c             	shr    $0xc,%eax
}
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    

008017a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8017ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017b0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8017b5:	5d                   	pop    %ebp
  8017b6:	c3                   	ret    

008017b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017bd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8017c2:	89 c2                	mov    %eax,%edx
  8017c4:	c1 ea 16             	shr    $0x16,%edx
  8017c7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017ce:	f6 c2 01             	test   $0x1,%dl
  8017d1:	74 11                	je     8017e4 <fd_alloc+0x2d>
  8017d3:	89 c2                	mov    %eax,%edx
  8017d5:	c1 ea 0c             	shr    $0xc,%edx
  8017d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017df:	f6 c2 01             	test   $0x1,%dl
  8017e2:	75 09                	jne    8017ed <fd_alloc+0x36>
			*fd_store = fd;
  8017e4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8017e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017eb:	eb 17                	jmp    801804 <fd_alloc+0x4d>
  8017ed:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8017f2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017f7:	75 c9                	jne    8017c2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017f9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8017ff:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    

00801806 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80180c:	83 f8 1f             	cmp    $0x1f,%eax
  80180f:	77 36                	ja     801847 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801811:	c1 e0 0c             	shl    $0xc,%eax
  801814:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801819:	89 c2                	mov    %eax,%edx
  80181b:	c1 ea 16             	shr    $0x16,%edx
  80181e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801825:	f6 c2 01             	test   $0x1,%dl
  801828:	74 24                	je     80184e <fd_lookup+0x48>
  80182a:	89 c2                	mov    %eax,%edx
  80182c:	c1 ea 0c             	shr    $0xc,%edx
  80182f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801836:	f6 c2 01             	test   $0x1,%dl
  801839:	74 1a                	je     801855 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80183b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183e:	89 02                	mov    %eax,(%edx)
	return 0;
  801840:	b8 00 00 00 00       	mov    $0x0,%eax
  801845:	eb 13                	jmp    80185a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801847:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80184c:	eb 0c                	jmp    80185a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80184e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801853:	eb 05                	jmp    80185a <fd_lookup+0x54>
  801855:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80185a:	5d                   	pop    %ebp
  80185b:	c3                   	ret    

0080185c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 18             	sub    $0x18,%esp
  801862:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801865:	ba 00 00 00 00       	mov    $0x0,%edx
  80186a:	eb 13                	jmp    80187f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80186c:	39 08                	cmp    %ecx,(%eax)
  80186e:	75 0c                	jne    80187c <dev_lookup+0x20>
			*dev = devtab[i];
  801870:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801873:	89 01                	mov    %eax,(%ecx)
			return 0;
  801875:	b8 00 00 00 00       	mov    $0x0,%eax
  80187a:	eb 38                	jmp    8018b4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80187c:	83 c2 01             	add    $0x1,%edx
  80187f:	8b 04 95 b8 34 80 00 	mov    0x8034b8(,%edx,4),%eax
  801886:	85 c0                	test   %eax,%eax
  801888:	75 e2                	jne    80186c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80188a:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80188f:	8b 40 48             	mov    0x48(%eax),%eax
  801892:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801896:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189a:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  8018a1:	e8 28 ec ff ff       	call   8004ce <cprintf>
	*dev = 0;
  8018a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8018af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	56                   	push   %esi
  8018ba:	53                   	push   %ebx
  8018bb:	83 ec 20             	sub    $0x20,%esp
  8018be:	8b 75 08             	mov    0x8(%ebp),%esi
  8018c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8018cb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8018d1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018d4:	89 04 24             	mov    %eax,(%esp)
  8018d7:	e8 2a ff ff ff       	call   801806 <fd_lookup>
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	78 05                	js     8018e5 <fd_close+0x2f>
	    || fd != fd2)
  8018e0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8018e3:	74 0c                	je     8018f1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8018e5:	84 db                	test   %bl,%bl
  8018e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ec:	0f 44 c2             	cmove  %edx,%eax
  8018ef:	eb 3f                	jmp    801930 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f8:	8b 06                	mov    (%esi),%eax
  8018fa:	89 04 24             	mov    %eax,(%esp)
  8018fd:	e8 5a ff ff ff       	call   80185c <dev_lookup>
  801902:	89 c3                	mov    %eax,%ebx
  801904:	85 c0                	test   %eax,%eax
  801906:	78 16                	js     80191e <fd_close+0x68>
		if (dev->dev_close)
  801908:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80190e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801913:	85 c0                	test   %eax,%eax
  801915:	74 07                	je     80191e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801917:	89 34 24             	mov    %esi,(%esp)
  80191a:	ff d0                	call   *%eax
  80191c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80191e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801922:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801929:	e8 8c f6 ff ff       	call   800fba <sys_page_unmap>
	return r;
  80192e:	89 d8                	mov    %ebx,%eax
}
  801930:	83 c4 20             	add    $0x20,%esp
  801933:	5b                   	pop    %ebx
  801934:	5e                   	pop    %esi
  801935:	5d                   	pop    %ebp
  801936:	c3                   	ret    

00801937 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80193d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801940:	89 44 24 04          	mov    %eax,0x4(%esp)
  801944:	8b 45 08             	mov    0x8(%ebp),%eax
  801947:	89 04 24             	mov    %eax,(%esp)
  80194a:	e8 b7 fe ff ff       	call   801806 <fd_lookup>
  80194f:	89 c2                	mov    %eax,%edx
  801951:	85 d2                	test   %edx,%edx
  801953:	78 13                	js     801968 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801955:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80195c:	00 
  80195d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801960:	89 04 24             	mov    %eax,(%esp)
  801963:	e8 4e ff ff ff       	call   8018b6 <fd_close>
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <close_all>:

void
close_all(void)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	53                   	push   %ebx
  80196e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801971:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801976:	89 1c 24             	mov    %ebx,(%esp)
  801979:	e8 b9 ff ff ff       	call   801937 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80197e:	83 c3 01             	add    $0x1,%ebx
  801981:	83 fb 20             	cmp    $0x20,%ebx
  801984:	75 f0                	jne    801976 <close_all+0xc>
		close(i);
}
  801986:	83 c4 14             	add    $0x14,%esp
  801989:	5b                   	pop    %ebx
  80198a:	5d                   	pop    %ebp
  80198b:	c3                   	ret    

0080198c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	57                   	push   %edi
  801990:	56                   	push   %esi
  801991:	53                   	push   %ebx
  801992:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801995:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801998:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	89 04 24             	mov    %eax,(%esp)
  8019a2:	e8 5f fe ff ff       	call   801806 <fd_lookup>
  8019a7:	89 c2                	mov    %eax,%edx
  8019a9:	85 d2                	test   %edx,%edx
  8019ab:	0f 88 e1 00 00 00    	js     801a92 <dup+0x106>
		return r;
	close(newfdnum);
  8019b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b4:	89 04 24             	mov    %eax,(%esp)
  8019b7:	e8 7b ff ff ff       	call   801937 <close>

	newfd = INDEX2FD(newfdnum);
  8019bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8019bf:	c1 e3 0c             	shl    $0xc,%ebx
  8019c2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8019c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019cb:	89 04 24             	mov    %eax,(%esp)
  8019ce:	e8 cd fd ff ff       	call   8017a0 <fd2data>
  8019d3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8019d5:	89 1c 24             	mov    %ebx,(%esp)
  8019d8:	e8 c3 fd ff ff       	call   8017a0 <fd2data>
  8019dd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8019df:	89 f0                	mov    %esi,%eax
  8019e1:	c1 e8 16             	shr    $0x16,%eax
  8019e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019eb:	a8 01                	test   $0x1,%al
  8019ed:	74 43                	je     801a32 <dup+0xa6>
  8019ef:	89 f0                	mov    %esi,%eax
  8019f1:	c1 e8 0c             	shr    $0xc,%eax
  8019f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8019fb:	f6 c2 01             	test   $0x1,%dl
  8019fe:	74 32                	je     801a32 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801a00:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a07:	25 07 0e 00 00       	and    $0xe07,%eax
  801a0c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a10:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a14:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a1b:	00 
  801a1c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a27:	e8 3b f5 ff ff       	call   800f67 <sys_page_map>
  801a2c:	89 c6                	mov    %eax,%esi
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	78 3e                	js     801a70 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a35:	89 c2                	mov    %eax,%edx
  801a37:	c1 ea 0c             	shr    $0xc,%edx
  801a3a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a41:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a47:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a4f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a56:	00 
  801a57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a62:	e8 00 f5 ff ff       	call   800f67 <sys_page_map>
  801a67:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801a69:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801a6c:	85 f6                	test   %esi,%esi
  801a6e:	79 22                	jns    801a92 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a74:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a7b:	e8 3a f5 ff ff       	call   800fba <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a80:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a8b:	e8 2a f5 ff ff       	call   800fba <sys_page_unmap>
	return r;
  801a90:	89 f0                	mov    %esi,%eax
}
  801a92:	83 c4 3c             	add    $0x3c,%esp
  801a95:	5b                   	pop    %ebx
  801a96:	5e                   	pop    %esi
  801a97:	5f                   	pop    %edi
  801a98:	5d                   	pop    %ebp
  801a99:	c3                   	ret    

00801a9a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	53                   	push   %ebx
  801a9e:	83 ec 24             	sub    $0x24,%esp
  801aa1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aa4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aab:	89 1c 24             	mov    %ebx,(%esp)
  801aae:	e8 53 fd ff ff       	call   801806 <fd_lookup>
  801ab3:	89 c2                	mov    %eax,%edx
  801ab5:	85 d2                	test   %edx,%edx
  801ab7:	78 6d                	js     801b26 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801abc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac3:	8b 00                	mov    (%eax),%eax
  801ac5:	89 04 24             	mov    %eax,(%esp)
  801ac8:	e8 8f fd ff ff       	call   80185c <dev_lookup>
  801acd:	85 c0                	test   %eax,%eax
  801acf:	78 55                	js     801b26 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad4:	8b 50 08             	mov    0x8(%eax),%edx
  801ad7:	83 e2 03             	and    $0x3,%edx
  801ada:	83 fa 01             	cmp    $0x1,%edx
  801add:	75 23                	jne    801b02 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801adf:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801ae4:	8b 40 48             	mov    0x48(%eax),%eax
  801ae7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aef:	c7 04 24 7d 34 80 00 	movl   $0x80347d,(%esp)
  801af6:	e8 d3 e9 ff ff       	call   8004ce <cprintf>
		return -E_INVAL;
  801afb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b00:	eb 24                	jmp    801b26 <read+0x8c>
	}
	if (!dev->dev_read)
  801b02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b05:	8b 52 08             	mov    0x8(%edx),%edx
  801b08:	85 d2                	test   %edx,%edx
  801b0a:	74 15                	je     801b21 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b0c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b16:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b1a:	89 04 24             	mov    %eax,(%esp)
  801b1d:	ff d2                	call   *%edx
  801b1f:	eb 05                	jmp    801b26 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801b21:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801b26:	83 c4 24             	add    $0x24,%esp
  801b29:	5b                   	pop    %ebx
  801b2a:	5d                   	pop    %ebp
  801b2b:	c3                   	ret    

00801b2c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	57                   	push   %edi
  801b30:	56                   	push   %esi
  801b31:	53                   	push   %ebx
  801b32:	83 ec 1c             	sub    $0x1c,%esp
  801b35:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b38:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b40:	eb 23                	jmp    801b65 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b42:	89 f0                	mov    %esi,%eax
  801b44:	29 d8                	sub    %ebx,%eax
  801b46:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b4a:	89 d8                	mov    %ebx,%eax
  801b4c:	03 45 0c             	add    0xc(%ebp),%eax
  801b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b53:	89 3c 24             	mov    %edi,(%esp)
  801b56:	e8 3f ff ff ff       	call   801a9a <read>
		if (m < 0)
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	78 10                	js     801b6f <readn+0x43>
			return m;
		if (m == 0)
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	74 0a                	je     801b6d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b63:	01 c3                	add    %eax,%ebx
  801b65:	39 f3                	cmp    %esi,%ebx
  801b67:	72 d9                	jb     801b42 <readn+0x16>
  801b69:	89 d8                	mov    %ebx,%eax
  801b6b:	eb 02                	jmp    801b6f <readn+0x43>
  801b6d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801b6f:	83 c4 1c             	add    $0x1c,%esp
  801b72:	5b                   	pop    %ebx
  801b73:	5e                   	pop    %esi
  801b74:	5f                   	pop    %edi
  801b75:	5d                   	pop    %ebp
  801b76:	c3                   	ret    

00801b77 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	53                   	push   %ebx
  801b7b:	83 ec 24             	sub    $0x24,%esp
  801b7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b81:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b88:	89 1c 24             	mov    %ebx,(%esp)
  801b8b:	e8 76 fc ff ff       	call   801806 <fd_lookup>
  801b90:	89 c2                	mov    %eax,%edx
  801b92:	85 d2                	test   %edx,%edx
  801b94:	78 68                	js     801bfe <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b96:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba0:	8b 00                	mov    (%eax),%eax
  801ba2:	89 04 24             	mov    %eax,(%esp)
  801ba5:	e8 b2 fc ff ff       	call   80185c <dev_lookup>
  801baa:	85 c0                	test   %eax,%eax
  801bac:	78 50                	js     801bfe <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801bb5:	75 23                	jne    801bda <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801bb7:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801bbc:	8b 40 48             	mov    0x48(%eax),%eax
  801bbf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc7:	c7 04 24 99 34 80 00 	movl   $0x803499,(%esp)
  801bce:	e8 fb e8 ff ff       	call   8004ce <cprintf>
		return -E_INVAL;
  801bd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801bd8:	eb 24                	jmp    801bfe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801bda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bdd:	8b 52 0c             	mov    0xc(%edx),%edx
  801be0:	85 d2                	test   %edx,%edx
  801be2:	74 15                	je     801bf9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801be4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801beb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bf2:	89 04 24             	mov    %eax,(%esp)
  801bf5:	ff d2                	call   *%edx
  801bf7:	eb 05                	jmp    801bfe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801bf9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801bfe:	83 c4 24             	add    $0x24,%esp
  801c01:	5b                   	pop    %ebx
  801c02:	5d                   	pop    %ebp
  801c03:	c3                   	ret    

00801c04 <seek>:

int
seek(int fdnum, off_t offset)
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
  801c07:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c0a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	89 04 24             	mov    %eax,(%esp)
  801c17:	e8 ea fb ff ff       	call   801806 <fd_lookup>
  801c1c:	85 c0                	test   %eax,%eax
  801c1e:	78 0e                	js     801c2e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801c20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c26:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801c29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	53                   	push   %ebx
  801c34:	83 ec 24             	sub    $0x24,%esp
  801c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c3a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c41:	89 1c 24             	mov    %ebx,(%esp)
  801c44:	e8 bd fb ff ff       	call   801806 <fd_lookup>
  801c49:	89 c2                	mov    %eax,%edx
  801c4b:	85 d2                	test   %edx,%edx
  801c4d:	78 61                	js     801cb0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c52:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c59:	8b 00                	mov    (%eax),%eax
  801c5b:	89 04 24             	mov    %eax,(%esp)
  801c5e:	e8 f9 fb ff ff       	call   80185c <dev_lookup>
  801c63:	85 c0                	test   %eax,%eax
  801c65:	78 49                	js     801cb0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c6e:	75 23                	jne    801c93 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801c70:	a1 0c 50 80 00       	mov    0x80500c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801c75:	8b 40 48             	mov    0x48(%eax),%eax
  801c78:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c80:	c7 04 24 5c 34 80 00 	movl   $0x80345c,(%esp)
  801c87:	e8 42 e8 ff ff       	call   8004ce <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801c8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c91:	eb 1d                	jmp    801cb0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801c93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c96:	8b 52 18             	mov    0x18(%edx),%edx
  801c99:	85 d2                	test   %edx,%edx
  801c9b:	74 0e                	je     801cab <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ca0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ca4:	89 04 24             	mov    %eax,(%esp)
  801ca7:	ff d2                	call   *%edx
  801ca9:	eb 05                	jmp    801cb0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801cab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801cb0:	83 c4 24             	add    $0x24,%esp
  801cb3:	5b                   	pop    %ebx
  801cb4:	5d                   	pop    %ebp
  801cb5:	c3                   	ret    

00801cb6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	53                   	push   %ebx
  801cba:	83 ec 24             	sub    $0x24,%esp
  801cbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cc0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cca:	89 04 24             	mov    %eax,(%esp)
  801ccd:	e8 34 fb ff ff       	call   801806 <fd_lookup>
  801cd2:	89 c2                	mov    %eax,%edx
  801cd4:	85 d2                	test   %edx,%edx
  801cd6:	78 52                	js     801d2a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce2:	8b 00                	mov    (%eax),%eax
  801ce4:	89 04 24             	mov    %eax,(%esp)
  801ce7:	e8 70 fb ff ff       	call   80185c <dev_lookup>
  801cec:	85 c0                	test   %eax,%eax
  801cee:	78 3a                	js     801d2a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801cf7:	74 2c                	je     801d25 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801cf9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801cfc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d03:	00 00 00 
	stat->st_isdir = 0;
  801d06:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d0d:	00 00 00 
	stat->st_dev = dev;
  801d10:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801d16:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d1d:	89 14 24             	mov    %edx,(%esp)
  801d20:	ff 50 14             	call   *0x14(%eax)
  801d23:	eb 05                	jmp    801d2a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801d25:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801d2a:	83 c4 24             	add    $0x24,%esp
  801d2d:	5b                   	pop    %ebx
  801d2e:	5d                   	pop    %ebp
  801d2f:	c3                   	ret    

00801d30 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	56                   	push   %esi
  801d34:	53                   	push   %ebx
  801d35:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d38:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d3f:	00 
  801d40:	8b 45 08             	mov    0x8(%ebp),%eax
  801d43:	89 04 24             	mov    %eax,(%esp)
  801d46:	e8 84 02 00 00       	call   801fcf <open>
  801d4b:	89 c3                	mov    %eax,%ebx
  801d4d:	85 db                	test   %ebx,%ebx
  801d4f:	78 1b                	js     801d6c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d58:	89 1c 24             	mov    %ebx,(%esp)
  801d5b:	e8 56 ff ff ff       	call   801cb6 <fstat>
  801d60:	89 c6                	mov    %eax,%esi
	close(fd);
  801d62:	89 1c 24             	mov    %ebx,(%esp)
  801d65:	e8 cd fb ff ff       	call   801937 <close>
	return r;
  801d6a:	89 f0                	mov    %esi,%eax
}
  801d6c:	83 c4 10             	add    $0x10,%esp
  801d6f:	5b                   	pop    %ebx
  801d70:	5e                   	pop    %esi
  801d71:	5d                   	pop    %ebp
  801d72:	c3                   	ret    

00801d73 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	56                   	push   %esi
  801d77:	53                   	push   %ebx
  801d78:	83 ec 10             	sub    $0x10,%esp
  801d7b:	89 c6                	mov    %eax,%esi
  801d7d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801d7f:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801d86:	75 11                	jne    801d99 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801d88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801d8f:	e8 c1 f9 ff ff       	call   801755 <ipc_find_env>
  801d94:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d99:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801da0:	00 
  801da1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801da8:	00 
  801da9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dad:	a1 04 50 80 00       	mov    0x805004,%eax
  801db2:	89 04 24             	mov    %eax,(%esp)
  801db5:	e8 0e f9 ff ff       	call   8016c8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801dba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dc1:	00 
  801dc2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dc6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dcd:	e8 8e f8 ff ff       	call   801660 <ipc_recv>
}
  801dd2:	83 c4 10             	add    $0x10,%esp
  801dd5:	5b                   	pop    %ebx
  801dd6:	5e                   	pop    %esi
  801dd7:	5d                   	pop    %ebp
  801dd8:	c3                   	ret    

00801dd9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  801de2:	8b 40 0c             	mov    0xc(%eax),%eax
  801de5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ded:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801df2:	ba 00 00 00 00       	mov    $0x0,%edx
  801df7:	b8 02 00 00 00       	mov    $0x2,%eax
  801dfc:	e8 72 ff ff ff       	call   801d73 <fsipc>
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e0f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801e14:	ba 00 00 00 00       	mov    $0x0,%edx
  801e19:	b8 06 00 00 00       	mov    $0x6,%eax
  801e1e:	e8 50 ff ff ff       	call   801d73 <fsipc>
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	53                   	push   %ebx
  801e29:	83 ec 14             	sub    $0x14,%esp
  801e2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	8b 40 0c             	mov    0xc(%eax),%eax
  801e35:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801e3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e3f:	b8 05 00 00 00       	mov    $0x5,%eax
  801e44:	e8 2a ff ff ff       	call   801d73 <fsipc>
  801e49:	89 c2                	mov    %eax,%edx
  801e4b:	85 d2                	test   %edx,%edx
  801e4d:	78 2b                	js     801e7a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e4f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e56:	00 
  801e57:	89 1c 24             	mov    %ebx,(%esp)
  801e5a:	e8 98 ec ff ff       	call   800af7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e5f:	a1 80 60 80 00       	mov    0x806080,%eax
  801e64:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e6a:	a1 84 60 80 00       	mov    0x806084,%eax
  801e6f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7a:	83 c4 14             	add    $0x14,%esp
  801e7d:	5b                   	pop    %ebx
  801e7e:	5d                   	pop    %ebp
  801e7f:	c3                   	ret    

00801e80 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	53                   	push   %ebx
  801e84:	83 ec 14             	sub    $0x14,%esp
  801e87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e90:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801e95:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801e9b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801ea0:	0f 46 c3             	cmovbe %ebx,%eax
  801ea3:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801ea8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb3:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801eba:	e8 d5 ed ff ff       	call   800c94 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec4:	b8 04 00 00 00       	mov    $0x4,%eax
  801ec9:	e8 a5 fe ff ff       	call   801d73 <fsipc>
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	78 53                	js     801f25 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801ed2:	39 c3                	cmp    %eax,%ebx
  801ed4:	73 24                	jae    801efa <devfile_write+0x7a>
  801ed6:	c7 44 24 0c cc 34 80 	movl   $0x8034cc,0xc(%esp)
  801edd:	00 
  801ede:	c7 44 24 08 d3 34 80 	movl   $0x8034d3,0x8(%esp)
  801ee5:	00 
  801ee6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801eed:	00 
  801eee:	c7 04 24 e8 34 80 00 	movl   $0x8034e8,(%esp)
  801ef5:	e8 db e4 ff ff       	call   8003d5 <_panic>
	assert(r <= PGSIZE);
  801efa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801eff:	7e 24                	jle    801f25 <devfile_write+0xa5>
  801f01:	c7 44 24 0c f3 34 80 	movl   $0x8034f3,0xc(%esp)
  801f08:	00 
  801f09:	c7 44 24 08 d3 34 80 	movl   $0x8034d3,0x8(%esp)
  801f10:	00 
  801f11:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801f18:	00 
  801f19:	c7 04 24 e8 34 80 00 	movl   $0x8034e8,(%esp)
  801f20:	e8 b0 e4 ff ff       	call   8003d5 <_panic>
	return r;
}
  801f25:	83 c4 14             	add    $0x14,%esp
  801f28:	5b                   	pop    %ebx
  801f29:	5d                   	pop    %ebp
  801f2a:	c3                   	ret    

00801f2b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	56                   	push   %esi
  801f2f:	53                   	push   %ebx
  801f30:	83 ec 10             	sub    $0x10,%esp
  801f33:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	8b 40 0c             	mov    0xc(%eax),%eax
  801f3c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801f41:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801f47:	ba 00 00 00 00       	mov    $0x0,%edx
  801f4c:	b8 03 00 00 00       	mov    $0x3,%eax
  801f51:	e8 1d fe ff ff       	call   801d73 <fsipc>
  801f56:	89 c3                	mov    %eax,%ebx
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	78 6a                	js     801fc6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801f5c:	39 c6                	cmp    %eax,%esi
  801f5e:	73 24                	jae    801f84 <devfile_read+0x59>
  801f60:	c7 44 24 0c cc 34 80 	movl   $0x8034cc,0xc(%esp)
  801f67:	00 
  801f68:	c7 44 24 08 d3 34 80 	movl   $0x8034d3,0x8(%esp)
  801f6f:	00 
  801f70:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801f77:	00 
  801f78:	c7 04 24 e8 34 80 00 	movl   $0x8034e8,(%esp)
  801f7f:	e8 51 e4 ff ff       	call   8003d5 <_panic>
	assert(r <= PGSIZE);
  801f84:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f89:	7e 24                	jle    801faf <devfile_read+0x84>
  801f8b:	c7 44 24 0c f3 34 80 	movl   $0x8034f3,0xc(%esp)
  801f92:	00 
  801f93:	c7 44 24 08 d3 34 80 	movl   $0x8034d3,0x8(%esp)
  801f9a:	00 
  801f9b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801fa2:	00 
  801fa3:	c7 04 24 e8 34 80 00 	movl   $0x8034e8,(%esp)
  801faa:	e8 26 e4 ff ff       	call   8003d5 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801faf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fb3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801fba:	00 
  801fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbe:	89 04 24             	mov    %eax,(%esp)
  801fc1:	e8 ce ec ff ff       	call   800c94 <memmove>
	return r;
}
  801fc6:	89 d8                	mov    %ebx,%eax
  801fc8:	83 c4 10             	add    $0x10,%esp
  801fcb:	5b                   	pop    %ebx
  801fcc:	5e                   	pop    %esi
  801fcd:	5d                   	pop    %ebp
  801fce:	c3                   	ret    

00801fcf <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	53                   	push   %ebx
  801fd3:	83 ec 24             	sub    $0x24,%esp
  801fd6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801fd9:	89 1c 24             	mov    %ebx,(%esp)
  801fdc:	e8 df ea ff ff       	call   800ac0 <strlen>
  801fe1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fe6:	7f 60                	jg     802048 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801fe8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801feb:	89 04 24             	mov    %eax,(%esp)
  801fee:	e8 c4 f7 ff ff       	call   8017b7 <fd_alloc>
  801ff3:	89 c2                	mov    %eax,%edx
  801ff5:	85 d2                	test   %edx,%edx
  801ff7:	78 54                	js     80204d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801ff9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ffd:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  802004:	e8 ee ea ff ff       	call   800af7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  802009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80200c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802011:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802014:	b8 01 00 00 00       	mov    $0x1,%eax
  802019:	e8 55 fd ff ff       	call   801d73 <fsipc>
  80201e:	89 c3                	mov    %eax,%ebx
  802020:	85 c0                	test   %eax,%eax
  802022:	79 17                	jns    80203b <open+0x6c>
		fd_close(fd, 0);
  802024:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80202b:	00 
  80202c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202f:	89 04 24             	mov    %eax,(%esp)
  802032:	e8 7f f8 ff ff       	call   8018b6 <fd_close>
		return r;
  802037:	89 d8                	mov    %ebx,%eax
  802039:	eb 12                	jmp    80204d <open+0x7e>
	}

	return fd2num(fd);
  80203b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203e:	89 04 24             	mov    %eax,(%esp)
  802041:	e8 4a f7 ff ff       	call   801790 <fd2num>
  802046:	eb 05                	jmp    80204d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  802048:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80204d:	83 c4 24             	add    $0x24,%esp
  802050:	5b                   	pop    %ebx
  802051:	5d                   	pop    %ebp
  802052:	c3                   	ret    

00802053 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
  802056:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802059:	ba 00 00 00 00       	mov    $0x0,%edx
  80205e:	b8 08 00 00 00       	mov    $0x8,%eax
  802063:	e8 0b fd ff ff       	call   801d73 <fsipc>
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    
  80206a:	66 90                	xchg   %ax,%ax
  80206c:	66 90                	xchg   %ax,%ax
  80206e:	66 90                	xchg   %ax,%ax

00802070 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802076:	c7 44 24 04 ff 34 80 	movl   $0x8034ff,0x4(%esp)
  80207d:	00 
  80207e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802081:	89 04 24             	mov    %eax,(%esp)
  802084:	e8 6e ea ff ff       	call   800af7 <strcpy>
	return 0;
}
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	53                   	push   %ebx
  802094:	83 ec 14             	sub    $0x14,%esp
  802097:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80209a:	89 1c 24             	mov    %ebx,(%esp)
  80209d:	e8 a9 0a 00 00       	call   802b4b <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8020a2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8020a7:	83 f8 01             	cmp    $0x1,%eax
  8020aa:	75 0d                	jne    8020b9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8020ac:	8b 43 0c             	mov    0xc(%ebx),%eax
  8020af:	89 04 24             	mov    %eax,(%esp)
  8020b2:	e8 29 03 00 00       	call   8023e0 <nsipc_close>
  8020b7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8020b9:	89 d0                	mov    %edx,%eax
  8020bb:	83 c4 14             	add    $0x14,%esp
  8020be:	5b                   	pop    %ebx
  8020bf:	5d                   	pop    %ebp
  8020c0:	c3                   	ret    

008020c1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020c7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020ce:	00 
  8020cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8020d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e3:	89 04 24             	mov    %eax,(%esp)
  8020e6:	e8 f0 03 00 00       	call   8024db <nsipc_send>
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
  8020f0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020fa:	00 
  8020fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8020fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  802102:	8b 45 0c             	mov    0xc(%ebp),%eax
  802105:	89 44 24 04          	mov    %eax,0x4(%esp)
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	8b 40 0c             	mov    0xc(%eax),%eax
  80210f:	89 04 24             	mov    %eax,(%esp)
  802112:	e8 44 03 00 00       	call   80245b <nsipc_recv>
}
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80211f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802122:	89 54 24 04          	mov    %edx,0x4(%esp)
  802126:	89 04 24             	mov    %eax,(%esp)
  802129:	e8 d8 f6 ff ff       	call   801806 <fd_lookup>
  80212e:	85 c0                	test   %eax,%eax
  802130:	78 17                	js     802149 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802135:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80213b:	39 08                	cmp    %ecx,(%eax)
  80213d:	75 05                	jne    802144 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80213f:	8b 40 0c             	mov    0xc(%eax),%eax
  802142:	eb 05                	jmp    802149 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802144:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	56                   	push   %esi
  80214f:	53                   	push   %ebx
  802150:	83 ec 20             	sub    $0x20,%esp
  802153:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802155:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802158:	89 04 24             	mov    %eax,(%esp)
  80215b:	e8 57 f6 ff ff       	call   8017b7 <fd_alloc>
  802160:	89 c3                	mov    %eax,%ebx
  802162:	85 c0                	test   %eax,%eax
  802164:	78 21                	js     802187 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802166:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80216d:	00 
  80216e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802171:	89 44 24 04          	mov    %eax,0x4(%esp)
  802175:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80217c:	e8 92 ed ff ff       	call   800f13 <sys_page_alloc>
  802181:	89 c3                	mov    %eax,%ebx
  802183:	85 c0                	test   %eax,%eax
  802185:	79 0c                	jns    802193 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802187:	89 34 24             	mov    %esi,(%esp)
  80218a:	e8 51 02 00 00       	call   8023e0 <nsipc_close>
		return r;
  80218f:	89 d8                	mov    %ebx,%eax
  802191:	eb 20                	jmp    8021b3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802193:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80219e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8021a8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8021ab:	89 14 24             	mov    %edx,(%esp)
  8021ae:	e8 dd f5 ff ff       	call   801790 <fd2num>
}
  8021b3:	83 c4 20             	add    $0x20,%esp
  8021b6:	5b                   	pop    %ebx
  8021b7:	5e                   	pop    %esi
  8021b8:	5d                   	pop    %ebp
  8021b9:	c3                   	ret    

008021ba <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	e8 51 ff ff ff       	call   802119 <fd2sockid>
		return r;
  8021c8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021ca:	85 c0                	test   %eax,%eax
  8021cc:	78 23                	js     8021f1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021ce:	8b 55 10             	mov    0x10(%ebp),%edx
  8021d1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021dc:	89 04 24             	mov    %eax,(%esp)
  8021df:	e8 45 01 00 00       	call   802329 <nsipc_accept>
		return r;
  8021e4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	78 07                	js     8021f1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8021ea:	e8 5c ff ff ff       	call   80214b <alloc_sockfd>
  8021ef:	89 c1                	mov    %eax,%ecx
}
  8021f1:	89 c8                	mov    %ecx,%eax
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	e8 16 ff ff ff       	call   802119 <fd2sockid>
  802203:	89 c2                	mov    %eax,%edx
  802205:	85 d2                	test   %edx,%edx
  802207:	78 16                	js     80221f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802209:	8b 45 10             	mov    0x10(%ebp),%eax
  80220c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802210:	8b 45 0c             	mov    0xc(%ebp),%eax
  802213:	89 44 24 04          	mov    %eax,0x4(%esp)
  802217:	89 14 24             	mov    %edx,(%esp)
  80221a:	e8 60 01 00 00       	call   80237f <nsipc_bind>
}
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <shutdown>:

int
shutdown(int s, int how)
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	e8 ea fe ff ff       	call   802119 <fd2sockid>
  80222f:	89 c2                	mov    %eax,%edx
  802231:	85 d2                	test   %edx,%edx
  802233:	78 0f                	js     802244 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802235:	8b 45 0c             	mov    0xc(%ebp),%eax
  802238:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223c:	89 14 24             	mov    %edx,(%esp)
  80223f:	e8 7a 01 00 00       	call   8023be <nsipc_shutdown>
}
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	e8 c5 fe ff ff       	call   802119 <fd2sockid>
  802254:	89 c2                	mov    %eax,%edx
  802256:	85 d2                	test   %edx,%edx
  802258:	78 16                	js     802270 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80225a:	8b 45 10             	mov    0x10(%ebp),%eax
  80225d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802261:	8b 45 0c             	mov    0xc(%ebp),%eax
  802264:	89 44 24 04          	mov    %eax,0x4(%esp)
  802268:	89 14 24             	mov    %edx,(%esp)
  80226b:	e8 8a 01 00 00       	call   8023fa <nsipc_connect>
}
  802270:	c9                   	leave  
  802271:	c3                   	ret    

00802272 <listen>:

int
listen(int s, int backlog)
{
  802272:	55                   	push   %ebp
  802273:	89 e5                	mov    %esp,%ebp
  802275:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	e8 99 fe ff ff       	call   802119 <fd2sockid>
  802280:	89 c2                	mov    %eax,%edx
  802282:	85 d2                	test   %edx,%edx
  802284:	78 0f                	js     802295 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802286:	8b 45 0c             	mov    0xc(%ebp),%eax
  802289:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228d:	89 14 24             	mov    %edx,(%esp)
  802290:	e8 a4 01 00 00       	call   802439 <nsipc_listen>
}
  802295:	c9                   	leave  
  802296:	c3                   	ret    

00802297 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802297:	55                   	push   %ebp
  802298:	89 e5                	mov    %esp,%ebp
  80229a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80229d:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	89 04 24             	mov    %eax,(%esp)
  8022b1:	e8 98 02 00 00       	call   80254e <nsipc_socket>
  8022b6:	89 c2                	mov    %eax,%edx
  8022b8:	85 d2                	test   %edx,%edx
  8022ba:	78 05                	js     8022c1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8022bc:	e8 8a fe ff ff       	call   80214b <alloc_sockfd>
}
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
  8022c6:	53                   	push   %ebx
  8022c7:	83 ec 14             	sub    $0x14,%esp
  8022ca:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8022cc:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  8022d3:	75 11                	jne    8022e6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8022d5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8022dc:	e8 74 f4 ff ff       	call   801755 <ipc_find_env>
  8022e1:	a3 08 50 80 00       	mov    %eax,0x805008
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022e6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8022ed:	00 
  8022ee:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8022f5:	00 
  8022f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022fa:	a1 08 50 80 00       	mov    0x805008,%eax
  8022ff:	89 04 24             	mov    %eax,(%esp)
  802302:	e8 c1 f3 ff ff       	call   8016c8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802307:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80230e:	00 
  80230f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802316:	00 
  802317:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80231e:	e8 3d f3 ff ff       	call   801660 <ipc_recv>
}
  802323:	83 c4 14             	add    $0x14,%esp
  802326:	5b                   	pop    %ebx
  802327:	5d                   	pop    %ebp
  802328:	c3                   	ret    

00802329 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
  80232c:	56                   	push   %esi
  80232d:	53                   	push   %ebx
  80232e:	83 ec 10             	sub    $0x10,%esp
  802331:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80233c:	8b 06                	mov    (%esi),%eax
  80233e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802343:	b8 01 00 00 00       	mov    $0x1,%eax
  802348:	e8 76 ff ff ff       	call   8022c3 <nsipc>
  80234d:	89 c3                	mov    %eax,%ebx
  80234f:	85 c0                	test   %eax,%eax
  802351:	78 23                	js     802376 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802353:	a1 10 70 80 00       	mov    0x807010,%eax
  802358:	89 44 24 08          	mov    %eax,0x8(%esp)
  80235c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802363:	00 
  802364:	8b 45 0c             	mov    0xc(%ebp),%eax
  802367:	89 04 24             	mov    %eax,(%esp)
  80236a:	e8 25 e9 ff ff       	call   800c94 <memmove>
		*addrlen = ret->ret_addrlen;
  80236f:	a1 10 70 80 00       	mov    0x807010,%eax
  802374:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802376:	89 d8                	mov    %ebx,%eax
  802378:	83 c4 10             	add    $0x10,%esp
  80237b:	5b                   	pop    %ebx
  80237c:	5e                   	pop    %esi
  80237d:	5d                   	pop    %ebp
  80237e:	c3                   	ret    

0080237f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
  802382:	53                   	push   %ebx
  802383:	83 ec 14             	sub    $0x14,%esp
  802386:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802389:	8b 45 08             	mov    0x8(%ebp),%eax
  80238c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802391:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802395:	8b 45 0c             	mov    0xc(%ebp),%eax
  802398:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8023a3:	e8 ec e8 ff ff       	call   800c94 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8023a8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8023ae:	b8 02 00 00 00       	mov    $0x2,%eax
  8023b3:	e8 0b ff ff ff       	call   8022c3 <nsipc>
}
  8023b8:	83 c4 14             	add    $0x14,%esp
  8023bb:	5b                   	pop    %ebx
  8023bc:	5d                   	pop    %ebp
  8023bd:	c3                   	ret    

008023be <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8023cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8023d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8023d9:	e8 e5 fe ff ff       	call   8022c3 <nsipc>
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <nsipc_close>:

int
nsipc_close(int s)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8023ee:	b8 04 00 00 00       	mov    $0x4,%eax
  8023f3:	e8 cb fe ff ff       	call   8022c3 <nsipc>
}
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	53                   	push   %ebx
  8023fe:	83 ec 14             	sub    $0x14,%esp
  802401:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80240c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802410:	8b 45 0c             	mov    0xc(%ebp),%eax
  802413:	89 44 24 04          	mov    %eax,0x4(%esp)
  802417:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80241e:	e8 71 e8 ff ff       	call   800c94 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802423:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802429:	b8 05 00 00 00       	mov    $0x5,%eax
  80242e:	e8 90 fe ff ff       	call   8022c3 <nsipc>
}
  802433:	83 c4 14             	add    $0x14,%esp
  802436:	5b                   	pop    %ebx
  802437:	5d                   	pop    %ebp
  802438:	c3                   	ret    

00802439 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802439:	55                   	push   %ebp
  80243a:	89 e5                	mov    %esp,%ebp
  80243c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80244f:	b8 06 00 00 00       	mov    $0x6,%eax
  802454:	e8 6a fe ff ff       	call   8022c3 <nsipc>
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
  80245e:	56                   	push   %esi
  80245f:	53                   	push   %ebx
  802460:	83 ec 10             	sub    $0x10,%esp
  802463:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802466:	8b 45 08             	mov    0x8(%ebp),%eax
  802469:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80246e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802474:	8b 45 14             	mov    0x14(%ebp),%eax
  802477:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80247c:	b8 07 00 00 00       	mov    $0x7,%eax
  802481:	e8 3d fe ff ff       	call   8022c3 <nsipc>
  802486:	89 c3                	mov    %eax,%ebx
  802488:	85 c0                	test   %eax,%eax
  80248a:	78 46                	js     8024d2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80248c:	39 f0                	cmp    %esi,%eax
  80248e:	7f 07                	jg     802497 <nsipc_recv+0x3c>
  802490:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802495:	7e 24                	jle    8024bb <nsipc_recv+0x60>
  802497:	c7 44 24 0c 0b 35 80 	movl   $0x80350b,0xc(%esp)
  80249e:	00 
  80249f:	c7 44 24 08 d3 34 80 	movl   $0x8034d3,0x8(%esp)
  8024a6:	00 
  8024a7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8024ae:	00 
  8024af:	c7 04 24 20 35 80 00 	movl   $0x803520,(%esp)
  8024b6:	e8 1a df ff ff       	call   8003d5 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8024bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024bf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8024c6:	00 
  8024c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ca:	89 04 24             	mov    %eax,(%esp)
  8024cd:	e8 c2 e7 ff ff       	call   800c94 <memmove>
	}

	return r;
}
  8024d2:	89 d8                	mov    %ebx,%eax
  8024d4:	83 c4 10             	add    $0x10,%esp
  8024d7:	5b                   	pop    %ebx
  8024d8:	5e                   	pop    %esi
  8024d9:	5d                   	pop    %ebp
  8024da:	c3                   	ret    

008024db <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
  8024de:	53                   	push   %ebx
  8024df:	83 ec 14             	sub    $0x14,%esp
  8024e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8024e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8024ed:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8024f3:	7e 24                	jle    802519 <nsipc_send+0x3e>
  8024f5:	c7 44 24 0c 2c 35 80 	movl   $0x80352c,0xc(%esp)
  8024fc:	00 
  8024fd:	c7 44 24 08 d3 34 80 	movl   $0x8034d3,0x8(%esp)
  802504:	00 
  802505:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80250c:	00 
  80250d:	c7 04 24 20 35 80 00 	movl   $0x803520,(%esp)
  802514:	e8 bc de ff ff       	call   8003d5 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802519:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80251d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802520:	89 44 24 04          	mov    %eax,0x4(%esp)
  802524:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80252b:	e8 64 e7 ff ff       	call   800c94 <memmove>
	nsipcbuf.send.req_size = size;
  802530:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802536:	8b 45 14             	mov    0x14(%ebp),%eax
  802539:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80253e:	b8 08 00 00 00       	mov    $0x8,%eax
  802543:	e8 7b fd ff ff       	call   8022c3 <nsipc>
}
  802548:	83 c4 14             	add    $0x14,%esp
  80254b:	5b                   	pop    %ebx
  80254c:	5d                   	pop    %ebp
  80254d:	c3                   	ret    

0080254e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
  802551:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802554:	8b 45 08             	mov    0x8(%ebp),%eax
  802557:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80255c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802564:	8b 45 10             	mov    0x10(%ebp),%eax
  802567:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80256c:	b8 09 00 00 00       	mov    $0x9,%eax
  802571:	e8 4d fd ff ff       	call   8022c3 <nsipc>
}
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
  80257b:	56                   	push   %esi
  80257c:	53                   	push   %ebx
  80257d:	83 ec 10             	sub    $0x10,%esp
  802580:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	89 04 24             	mov    %eax,(%esp)
  802589:	e8 12 f2 ff ff       	call   8017a0 <fd2data>
  80258e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802590:	c7 44 24 04 38 35 80 	movl   $0x803538,0x4(%esp)
  802597:	00 
  802598:	89 1c 24             	mov    %ebx,(%esp)
  80259b:	e8 57 e5 ff ff       	call   800af7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8025a0:	8b 46 04             	mov    0x4(%esi),%eax
  8025a3:	2b 06                	sub    (%esi),%eax
  8025a5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8025ab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8025b2:	00 00 00 
	stat->st_dev = &devpipe;
  8025b5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8025bc:	40 80 00 
	return 0;
}
  8025bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c4:	83 c4 10             	add    $0x10,%esp
  8025c7:	5b                   	pop    %ebx
  8025c8:	5e                   	pop    %esi
  8025c9:	5d                   	pop    %ebp
  8025ca:	c3                   	ret    

008025cb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8025cb:	55                   	push   %ebp
  8025cc:	89 e5                	mov    %esp,%ebp
  8025ce:	53                   	push   %ebx
  8025cf:	83 ec 14             	sub    $0x14,%esp
  8025d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8025d5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025e0:	e8 d5 e9 ff ff       	call   800fba <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8025e5:	89 1c 24             	mov    %ebx,(%esp)
  8025e8:	e8 b3 f1 ff ff       	call   8017a0 <fd2data>
  8025ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025f8:	e8 bd e9 ff ff       	call   800fba <sys_page_unmap>
}
  8025fd:	83 c4 14             	add    $0x14,%esp
  802600:	5b                   	pop    %ebx
  802601:	5d                   	pop    %ebp
  802602:	c3                   	ret    

00802603 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
  802606:	57                   	push   %edi
  802607:	56                   	push   %esi
  802608:	53                   	push   %ebx
  802609:	83 ec 2c             	sub    $0x2c,%esp
  80260c:	89 c6                	mov    %eax,%esi
  80260e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802611:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802616:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802619:	89 34 24             	mov    %esi,(%esp)
  80261c:	e8 2a 05 00 00       	call   802b4b <pageref>
  802621:	89 c7                	mov    %eax,%edi
  802623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802626:	89 04 24             	mov    %eax,(%esp)
  802629:	e8 1d 05 00 00       	call   802b4b <pageref>
  80262e:	39 c7                	cmp    %eax,%edi
  802630:	0f 94 c2             	sete   %dl
  802633:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802636:	8b 0d 0c 50 80 00    	mov    0x80500c,%ecx
  80263c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80263f:	39 fb                	cmp    %edi,%ebx
  802641:	74 21                	je     802664 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802643:	84 d2                	test   %dl,%dl
  802645:	74 ca                	je     802611 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802647:	8b 51 58             	mov    0x58(%ecx),%edx
  80264a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80264e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802652:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802656:	c7 04 24 3f 35 80 00 	movl   $0x80353f,(%esp)
  80265d:	e8 6c de ff ff       	call   8004ce <cprintf>
  802662:	eb ad                	jmp    802611 <_pipeisclosed+0xe>
	}
}
  802664:	83 c4 2c             	add    $0x2c,%esp
  802667:	5b                   	pop    %ebx
  802668:	5e                   	pop    %esi
  802669:	5f                   	pop    %edi
  80266a:	5d                   	pop    %ebp
  80266b:	c3                   	ret    

0080266c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
  80266f:	57                   	push   %edi
  802670:	56                   	push   %esi
  802671:	53                   	push   %ebx
  802672:	83 ec 1c             	sub    $0x1c,%esp
  802675:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802678:	89 34 24             	mov    %esi,(%esp)
  80267b:	e8 20 f1 ff ff       	call   8017a0 <fd2data>
  802680:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802682:	bf 00 00 00 00       	mov    $0x0,%edi
  802687:	eb 45                	jmp    8026ce <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802689:	89 da                	mov    %ebx,%edx
  80268b:	89 f0                	mov    %esi,%eax
  80268d:	e8 71 ff ff ff       	call   802603 <_pipeisclosed>
  802692:	85 c0                	test   %eax,%eax
  802694:	75 41                	jne    8026d7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802696:	e8 59 e8 ff ff       	call   800ef4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80269b:	8b 43 04             	mov    0x4(%ebx),%eax
  80269e:	8b 0b                	mov    (%ebx),%ecx
  8026a0:	8d 51 20             	lea    0x20(%ecx),%edx
  8026a3:	39 d0                	cmp    %edx,%eax
  8026a5:	73 e2                	jae    802689 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8026a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026aa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8026ae:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8026b1:	99                   	cltd   
  8026b2:	c1 ea 1b             	shr    $0x1b,%edx
  8026b5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8026b8:	83 e1 1f             	and    $0x1f,%ecx
  8026bb:	29 d1                	sub    %edx,%ecx
  8026bd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8026c1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8026c5:	83 c0 01             	add    $0x1,%eax
  8026c8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026cb:	83 c7 01             	add    $0x1,%edi
  8026ce:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8026d1:	75 c8                	jne    80269b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8026d3:	89 f8                	mov    %edi,%eax
  8026d5:	eb 05                	jmp    8026dc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8026d7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8026dc:	83 c4 1c             	add    $0x1c,%esp
  8026df:	5b                   	pop    %ebx
  8026e0:	5e                   	pop    %esi
  8026e1:	5f                   	pop    %edi
  8026e2:	5d                   	pop    %ebp
  8026e3:	c3                   	ret    

008026e4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026e4:	55                   	push   %ebp
  8026e5:	89 e5                	mov    %esp,%ebp
  8026e7:	57                   	push   %edi
  8026e8:	56                   	push   %esi
  8026e9:	53                   	push   %ebx
  8026ea:	83 ec 1c             	sub    $0x1c,%esp
  8026ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8026f0:	89 3c 24             	mov    %edi,(%esp)
  8026f3:	e8 a8 f0 ff ff       	call   8017a0 <fd2data>
  8026f8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026fa:	be 00 00 00 00       	mov    $0x0,%esi
  8026ff:	eb 3d                	jmp    80273e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802701:	85 f6                	test   %esi,%esi
  802703:	74 04                	je     802709 <devpipe_read+0x25>
				return i;
  802705:	89 f0                	mov    %esi,%eax
  802707:	eb 43                	jmp    80274c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802709:	89 da                	mov    %ebx,%edx
  80270b:	89 f8                	mov    %edi,%eax
  80270d:	e8 f1 fe ff ff       	call   802603 <_pipeisclosed>
  802712:	85 c0                	test   %eax,%eax
  802714:	75 31                	jne    802747 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802716:	e8 d9 e7 ff ff       	call   800ef4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80271b:	8b 03                	mov    (%ebx),%eax
  80271d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802720:	74 df                	je     802701 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802722:	99                   	cltd   
  802723:	c1 ea 1b             	shr    $0x1b,%edx
  802726:	01 d0                	add    %edx,%eax
  802728:	83 e0 1f             	and    $0x1f,%eax
  80272b:	29 d0                	sub    %edx,%eax
  80272d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802732:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802735:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802738:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80273b:	83 c6 01             	add    $0x1,%esi
  80273e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802741:	75 d8                	jne    80271b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802743:	89 f0                	mov    %esi,%eax
  802745:	eb 05                	jmp    80274c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802747:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80274c:	83 c4 1c             	add    $0x1c,%esp
  80274f:	5b                   	pop    %ebx
  802750:	5e                   	pop    %esi
  802751:	5f                   	pop    %edi
  802752:	5d                   	pop    %ebp
  802753:	c3                   	ret    

00802754 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	56                   	push   %esi
  802758:	53                   	push   %ebx
  802759:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80275c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80275f:	89 04 24             	mov    %eax,(%esp)
  802762:	e8 50 f0 ff ff       	call   8017b7 <fd_alloc>
  802767:	89 c2                	mov    %eax,%edx
  802769:	85 d2                	test   %edx,%edx
  80276b:	0f 88 4d 01 00 00    	js     8028be <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802771:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802778:	00 
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802780:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802787:	e8 87 e7 ff ff       	call   800f13 <sys_page_alloc>
  80278c:	89 c2                	mov    %eax,%edx
  80278e:	85 d2                	test   %edx,%edx
  802790:	0f 88 28 01 00 00    	js     8028be <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802796:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802799:	89 04 24             	mov    %eax,(%esp)
  80279c:	e8 16 f0 ff ff       	call   8017b7 <fd_alloc>
  8027a1:	89 c3                	mov    %eax,%ebx
  8027a3:	85 c0                	test   %eax,%eax
  8027a5:	0f 88 fe 00 00 00    	js     8028a9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027ab:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027b2:	00 
  8027b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027c1:	e8 4d e7 ff ff       	call   800f13 <sys_page_alloc>
  8027c6:	89 c3                	mov    %eax,%ebx
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	0f 88 d9 00 00 00    	js     8028a9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	89 04 24             	mov    %eax,(%esp)
  8027d6:	e8 c5 ef ff ff       	call   8017a0 <fd2data>
  8027db:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027dd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027e4:	00 
  8027e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027f0:	e8 1e e7 ff ff       	call   800f13 <sys_page_alloc>
  8027f5:	89 c3                	mov    %eax,%ebx
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	0f 88 97 00 00 00    	js     802896 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802802:	89 04 24             	mov    %eax,(%esp)
  802805:	e8 96 ef ff ff       	call   8017a0 <fd2data>
  80280a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802811:	00 
  802812:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802816:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80281d:	00 
  80281e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802822:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802829:	e8 39 e7 ff ff       	call   800f67 <sys_page_map>
  80282e:	89 c3                	mov    %eax,%ebx
  802830:	85 c0                	test   %eax,%eax
  802832:	78 52                	js     802886 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802834:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802849:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80284f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802852:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802857:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	89 04 24             	mov    %eax,(%esp)
  802864:	e8 27 ef ff ff       	call   801790 <fd2num>
  802869:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80286c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80286e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802871:	89 04 24             	mov    %eax,(%esp)
  802874:	e8 17 ef ff ff       	call   801790 <fd2num>
  802879:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80287c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80287f:	b8 00 00 00 00       	mov    $0x0,%eax
  802884:	eb 38                	jmp    8028be <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802886:	89 74 24 04          	mov    %esi,0x4(%esp)
  80288a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802891:	e8 24 e7 ff ff       	call   800fba <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802899:	89 44 24 04          	mov    %eax,0x4(%esp)
  80289d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028a4:	e8 11 e7 ff ff       	call   800fba <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028b7:	e8 fe e6 ff ff       	call   800fba <sys_page_unmap>
  8028bc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8028be:	83 c4 30             	add    $0x30,%esp
  8028c1:	5b                   	pop    %ebx
  8028c2:	5e                   	pop    %esi
  8028c3:	5d                   	pop    %ebp
  8028c4:	c3                   	ret    

008028c5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8028c5:	55                   	push   %ebp
  8028c6:	89 e5                	mov    %esp,%ebp
  8028c8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d5:	89 04 24             	mov    %eax,(%esp)
  8028d8:	e8 29 ef ff ff       	call   801806 <fd_lookup>
  8028dd:	89 c2                	mov    %eax,%edx
  8028df:	85 d2                	test   %edx,%edx
  8028e1:	78 15                	js     8028f8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8028e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e6:	89 04 24             	mov    %eax,(%esp)
  8028e9:	e8 b2 ee ff ff       	call   8017a0 <fd2data>
	return _pipeisclosed(fd, p);
  8028ee:	89 c2                	mov    %eax,%edx
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	e8 0b fd ff ff       	call   802603 <_pipeisclosed>
}
  8028f8:	c9                   	leave  
  8028f9:	c3                   	ret    
  8028fa:	66 90                	xchg   %ax,%ax
  8028fc:	66 90                	xchg   %ax,%ax
  8028fe:	66 90                	xchg   %ax,%ax

00802900 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
  802908:	5d                   	pop    %ebp
  802909:	c3                   	ret    

0080290a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80290a:	55                   	push   %ebp
  80290b:	89 e5                	mov    %esp,%ebp
  80290d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802910:	c7 44 24 04 57 35 80 	movl   $0x803557,0x4(%esp)
  802917:	00 
  802918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80291b:	89 04 24             	mov    %eax,(%esp)
  80291e:	e8 d4 e1 ff ff       	call   800af7 <strcpy>
	return 0;
}
  802923:	b8 00 00 00 00       	mov    $0x0,%eax
  802928:	c9                   	leave  
  802929:	c3                   	ret    

0080292a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80292a:	55                   	push   %ebp
  80292b:	89 e5                	mov    %esp,%ebp
  80292d:	57                   	push   %edi
  80292e:	56                   	push   %esi
  80292f:	53                   	push   %ebx
  802930:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802936:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80293b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802941:	eb 31                	jmp    802974 <devcons_write+0x4a>
		m = n - tot;
  802943:	8b 75 10             	mov    0x10(%ebp),%esi
  802946:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802948:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80294b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802950:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802953:	89 74 24 08          	mov    %esi,0x8(%esp)
  802957:	03 45 0c             	add    0xc(%ebp),%eax
  80295a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80295e:	89 3c 24             	mov    %edi,(%esp)
  802961:	e8 2e e3 ff ff       	call   800c94 <memmove>
		sys_cputs(buf, m);
  802966:	89 74 24 04          	mov    %esi,0x4(%esp)
  80296a:	89 3c 24             	mov    %edi,(%esp)
  80296d:	e8 d4 e4 ff ff       	call   800e46 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802972:	01 f3                	add    %esi,%ebx
  802974:	89 d8                	mov    %ebx,%eax
  802976:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802979:	72 c8                	jb     802943 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80297b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802981:	5b                   	pop    %ebx
  802982:	5e                   	pop    %esi
  802983:	5f                   	pop    %edi
  802984:	5d                   	pop    %ebp
  802985:	c3                   	ret    

00802986 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802986:	55                   	push   %ebp
  802987:	89 e5                	mov    %esp,%ebp
  802989:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80298c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802991:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802995:	75 07                	jne    80299e <devcons_read+0x18>
  802997:	eb 2a                	jmp    8029c3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802999:	e8 56 e5 ff ff       	call   800ef4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80299e:	66 90                	xchg   %ax,%ax
  8029a0:	e8 bf e4 ff ff       	call   800e64 <sys_cgetc>
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	74 f0                	je     802999 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8029a9:	85 c0                	test   %eax,%eax
  8029ab:	78 16                	js     8029c3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8029ad:	83 f8 04             	cmp    $0x4,%eax
  8029b0:	74 0c                	je     8029be <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8029b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029b5:	88 02                	mov    %al,(%edx)
	return 1;
  8029b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8029bc:	eb 05                	jmp    8029c3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8029be:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8029c3:	c9                   	leave  
  8029c4:	c3                   	ret    

008029c5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8029c5:	55                   	push   %ebp
  8029c6:	89 e5                	mov    %esp,%ebp
  8029c8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8029d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8029d8:	00 
  8029d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029dc:	89 04 24             	mov    %eax,(%esp)
  8029df:	e8 62 e4 ff ff       	call   800e46 <sys_cputs>
}
  8029e4:	c9                   	leave  
  8029e5:	c3                   	ret    

008029e6 <getchar>:

int
getchar(void)
{
  8029e6:	55                   	push   %ebp
  8029e7:	89 e5                	mov    %esp,%ebp
  8029e9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8029ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8029f3:	00 
  8029f4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a02:	e8 93 f0 ff ff       	call   801a9a <read>
	if (r < 0)
  802a07:	85 c0                	test   %eax,%eax
  802a09:	78 0f                	js     802a1a <getchar+0x34>
		return r;
	if (r < 1)
  802a0b:	85 c0                	test   %eax,%eax
  802a0d:	7e 06                	jle    802a15 <getchar+0x2f>
		return -E_EOF;
	return c;
  802a0f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802a13:	eb 05                	jmp    802a1a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802a15:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802a1a:	c9                   	leave  
  802a1b:	c3                   	ret    

00802a1c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a1c:	55                   	push   %ebp
  802a1d:	89 e5                	mov    %esp,%ebp
  802a1f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a25:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	89 04 24             	mov    %eax,(%esp)
  802a2f:	e8 d2 ed ff ff       	call   801806 <fd_lookup>
  802a34:	85 c0                	test   %eax,%eax
  802a36:	78 11                	js     802a49 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a41:	39 10                	cmp    %edx,(%eax)
  802a43:	0f 94 c0             	sete   %al
  802a46:	0f b6 c0             	movzbl %al,%eax
}
  802a49:	c9                   	leave  
  802a4a:	c3                   	ret    

00802a4b <opencons>:

int
opencons(void)
{
  802a4b:	55                   	push   %ebp
  802a4c:	89 e5                	mov    %esp,%ebp
  802a4e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a51:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a54:	89 04 24             	mov    %eax,(%esp)
  802a57:	e8 5b ed ff ff       	call   8017b7 <fd_alloc>
		return r;
  802a5c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a5e:	85 c0                	test   %eax,%eax
  802a60:	78 40                	js     802aa2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a62:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a69:	00 
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a78:	e8 96 e4 ff ff       	call   800f13 <sys_page_alloc>
		return r;
  802a7d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a7f:	85 c0                	test   %eax,%eax
  802a81:	78 1f                	js     802aa2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a83:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a98:	89 04 24             	mov    %eax,(%esp)
  802a9b:	e8 f0 ec ff ff       	call   801790 <fd2num>
  802aa0:	89 c2                	mov    %eax,%edx
}
  802aa2:	89 d0                	mov    %edx,%eax
  802aa4:	c9                   	leave  
  802aa5:	c3                   	ret    

00802aa6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802aa6:	55                   	push   %ebp
  802aa7:	89 e5                	mov    %esp,%ebp
  802aa9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802aac:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802ab3:	75 68                	jne    802b1d <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  802ab5:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802aba:	8b 40 48             	mov    0x48(%eax),%eax
  802abd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802ac4:	00 
  802ac5:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802acc:	ee 
  802acd:	89 04 24             	mov    %eax,(%esp)
  802ad0:	e8 3e e4 ff ff       	call   800f13 <sys_page_alloc>
  802ad5:	85 c0                	test   %eax,%eax
  802ad7:	74 2c                	je     802b05 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  802ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  802add:	c7 04 24 64 35 80 00 	movl   $0x803564,(%esp)
  802ae4:	e8 e5 d9 ff ff       	call   8004ce <cprintf>
			panic("set_pg_fault_handler");
  802ae9:	c7 44 24 08 98 35 80 	movl   $0x803598,0x8(%esp)
  802af0:	00 
  802af1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802af8:	00 
  802af9:	c7 04 24 ad 35 80 00 	movl   $0x8035ad,(%esp)
  802b00:	e8 d0 d8 ff ff       	call   8003d5 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802b05:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802b0a:	8b 40 48             	mov    0x48(%eax),%eax
  802b0d:	c7 44 24 04 27 2b 80 	movl   $0x802b27,0x4(%esp)
  802b14:	00 
  802b15:	89 04 24             	mov    %eax,(%esp)
  802b18:	e8 96 e5 ff ff       	call   8010b3 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802b25:	c9                   	leave  
  802b26:	c3                   	ret    

00802b27 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802b27:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802b28:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802b2d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802b2f:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  802b32:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  802b36:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  802b38:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  802b3c:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  802b3d:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  802b40:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  802b42:	58                   	pop    %eax
	popl %eax
  802b43:	58                   	pop    %eax
	popal
  802b44:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802b45:	83 c4 04             	add    $0x4,%esp
	popfl
  802b48:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802b49:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802b4a:	c3                   	ret    

00802b4b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b4b:	55                   	push   %ebp
  802b4c:	89 e5                	mov    %esp,%ebp
  802b4e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b51:	89 d0                	mov    %edx,%eax
  802b53:	c1 e8 16             	shr    $0x16,%eax
  802b56:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b5d:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b62:	f6 c1 01             	test   $0x1,%cl
  802b65:	74 1d                	je     802b84 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b67:	c1 ea 0c             	shr    $0xc,%edx
  802b6a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b71:	f6 c2 01             	test   $0x1,%dl
  802b74:	74 0e                	je     802b84 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b76:	c1 ea 0c             	shr    $0xc,%edx
  802b79:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b80:	ef 
  802b81:	0f b7 c0             	movzwl %ax,%eax
}
  802b84:	5d                   	pop    %ebp
  802b85:	c3                   	ret    
  802b86:	66 90                	xchg   %ax,%ax
  802b88:	66 90                	xchg   %ax,%ax
  802b8a:	66 90                	xchg   %ax,%ax
  802b8c:	66 90                	xchg   %ax,%ax
  802b8e:	66 90                	xchg   %ax,%ax

00802b90 <__udivdi3>:
  802b90:	55                   	push   %ebp
  802b91:	57                   	push   %edi
  802b92:	56                   	push   %esi
  802b93:	83 ec 0c             	sub    $0xc,%esp
  802b96:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b9a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802b9e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802ba2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802bac:	89 ea                	mov    %ebp,%edx
  802bae:	89 0c 24             	mov    %ecx,(%esp)
  802bb1:	75 2d                	jne    802be0 <__udivdi3+0x50>
  802bb3:	39 e9                	cmp    %ebp,%ecx
  802bb5:	77 61                	ja     802c18 <__udivdi3+0x88>
  802bb7:	85 c9                	test   %ecx,%ecx
  802bb9:	89 ce                	mov    %ecx,%esi
  802bbb:	75 0b                	jne    802bc8 <__udivdi3+0x38>
  802bbd:	b8 01 00 00 00       	mov    $0x1,%eax
  802bc2:	31 d2                	xor    %edx,%edx
  802bc4:	f7 f1                	div    %ecx
  802bc6:	89 c6                	mov    %eax,%esi
  802bc8:	31 d2                	xor    %edx,%edx
  802bca:	89 e8                	mov    %ebp,%eax
  802bcc:	f7 f6                	div    %esi
  802bce:	89 c5                	mov    %eax,%ebp
  802bd0:	89 f8                	mov    %edi,%eax
  802bd2:	f7 f6                	div    %esi
  802bd4:	89 ea                	mov    %ebp,%edx
  802bd6:	83 c4 0c             	add    $0xc,%esp
  802bd9:	5e                   	pop    %esi
  802bda:	5f                   	pop    %edi
  802bdb:	5d                   	pop    %ebp
  802bdc:	c3                   	ret    
  802bdd:	8d 76 00             	lea    0x0(%esi),%esi
  802be0:	39 e8                	cmp    %ebp,%eax
  802be2:	77 24                	ja     802c08 <__udivdi3+0x78>
  802be4:	0f bd e8             	bsr    %eax,%ebp
  802be7:	83 f5 1f             	xor    $0x1f,%ebp
  802bea:	75 3c                	jne    802c28 <__udivdi3+0x98>
  802bec:	8b 74 24 04          	mov    0x4(%esp),%esi
  802bf0:	39 34 24             	cmp    %esi,(%esp)
  802bf3:	0f 86 9f 00 00 00    	jbe    802c98 <__udivdi3+0x108>
  802bf9:	39 d0                	cmp    %edx,%eax
  802bfb:	0f 82 97 00 00 00    	jb     802c98 <__udivdi3+0x108>
  802c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c08:	31 d2                	xor    %edx,%edx
  802c0a:	31 c0                	xor    %eax,%eax
  802c0c:	83 c4 0c             	add    $0xc,%esp
  802c0f:	5e                   	pop    %esi
  802c10:	5f                   	pop    %edi
  802c11:	5d                   	pop    %ebp
  802c12:	c3                   	ret    
  802c13:	90                   	nop
  802c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c18:	89 f8                	mov    %edi,%eax
  802c1a:	f7 f1                	div    %ecx
  802c1c:	31 d2                	xor    %edx,%edx
  802c1e:	83 c4 0c             	add    $0xc,%esp
  802c21:	5e                   	pop    %esi
  802c22:	5f                   	pop    %edi
  802c23:	5d                   	pop    %ebp
  802c24:	c3                   	ret    
  802c25:	8d 76 00             	lea    0x0(%esi),%esi
  802c28:	89 e9                	mov    %ebp,%ecx
  802c2a:	8b 3c 24             	mov    (%esp),%edi
  802c2d:	d3 e0                	shl    %cl,%eax
  802c2f:	89 c6                	mov    %eax,%esi
  802c31:	b8 20 00 00 00       	mov    $0x20,%eax
  802c36:	29 e8                	sub    %ebp,%eax
  802c38:	89 c1                	mov    %eax,%ecx
  802c3a:	d3 ef                	shr    %cl,%edi
  802c3c:	89 e9                	mov    %ebp,%ecx
  802c3e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c42:	8b 3c 24             	mov    (%esp),%edi
  802c45:	09 74 24 08          	or     %esi,0x8(%esp)
  802c49:	89 d6                	mov    %edx,%esi
  802c4b:	d3 e7                	shl    %cl,%edi
  802c4d:	89 c1                	mov    %eax,%ecx
  802c4f:	89 3c 24             	mov    %edi,(%esp)
  802c52:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c56:	d3 ee                	shr    %cl,%esi
  802c58:	89 e9                	mov    %ebp,%ecx
  802c5a:	d3 e2                	shl    %cl,%edx
  802c5c:	89 c1                	mov    %eax,%ecx
  802c5e:	d3 ef                	shr    %cl,%edi
  802c60:	09 d7                	or     %edx,%edi
  802c62:	89 f2                	mov    %esi,%edx
  802c64:	89 f8                	mov    %edi,%eax
  802c66:	f7 74 24 08          	divl   0x8(%esp)
  802c6a:	89 d6                	mov    %edx,%esi
  802c6c:	89 c7                	mov    %eax,%edi
  802c6e:	f7 24 24             	mull   (%esp)
  802c71:	39 d6                	cmp    %edx,%esi
  802c73:	89 14 24             	mov    %edx,(%esp)
  802c76:	72 30                	jb     802ca8 <__udivdi3+0x118>
  802c78:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c7c:	89 e9                	mov    %ebp,%ecx
  802c7e:	d3 e2                	shl    %cl,%edx
  802c80:	39 c2                	cmp    %eax,%edx
  802c82:	73 05                	jae    802c89 <__udivdi3+0xf9>
  802c84:	3b 34 24             	cmp    (%esp),%esi
  802c87:	74 1f                	je     802ca8 <__udivdi3+0x118>
  802c89:	89 f8                	mov    %edi,%eax
  802c8b:	31 d2                	xor    %edx,%edx
  802c8d:	e9 7a ff ff ff       	jmp    802c0c <__udivdi3+0x7c>
  802c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c98:	31 d2                	xor    %edx,%edx
  802c9a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c9f:	e9 68 ff ff ff       	jmp    802c0c <__udivdi3+0x7c>
  802ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ca8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802cab:	31 d2                	xor    %edx,%edx
  802cad:	83 c4 0c             	add    $0xc,%esp
  802cb0:	5e                   	pop    %esi
  802cb1:	5f                   	pop    %edi
  802cb2:	5d                   	pop    %ebp
  802cb3:	c3                   	ret    
  802cb4:	66 90                	xchg   %ax,%ax
  802cb6:	66 90                	xchg   %ax,%ax
  802cb8:	66 90                	xchg   %ax,%ax
  802cba:	66 90                	xchg   %ax,%ax
  802cbc:	66 90                	xchg   %ax,%ax
  802cbe:	66 90                	xchg   %ax,%ax

00802cc0 <__umoddi3>:
  802cc0:	55                   	push   %ebp
  802cc1:	57                   	push   %edi
  802cc2:	56                   	push   %esi
  802cc3:	83 ec 14             	sub    $0x14,%esp
  802cc6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802cca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802cce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802cd2:	89 c7                	mov    %eax,%edi
  802cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cd8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802cdc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ce0:	89 34 24             	mov    %esi,(%esp)
  802ce3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ce7:	85 c0                	test   %eax,%eax
  802ce9:	89 c2                	mov    %eax,%edx
  802ceb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cef:	75 17                	jne    802d08 <__umoddi3+0x48>
  802cf1:	39 fe                	cmp    %edi,%esi
  802cf3:	76 4b                	jbe    802d40 <__umoddi3+0x80>
  802cf5:	89 c8                	mov    %ecx,%eax
  802cf7:	89 fa                	mov    %edi,%edx
  802cf9:	f7 f6                	div    %esi
  802cfb:	89 d0                	mov    %edx,%eax
  802cfd:	31 d2                	xor    %edx,%edx
  802cff:	83 c4 14             	add    $0x14,%esp
  802d02:	5e                   	pop    %esi
  802d03:	5f                   	pop    %edi
  802d04:	5d                   	pop    %ebp
  802d05:	c3                   	ret    
  802d06:	66 90                	xchg   %ax,%ax
  802d08:	39 f8                	cmp    %edi,%eax
  802d0a:	77 54                	ja     802d60 <__umoddi3+0xa0>
  802d0c:	0f bd e8             	bsr    %eax,%ebp
  802d0f:	83 f5 1f             	xor    $0x1f,%ebp
  802d12:	75 5c                	jne    802d70 <__umoddi3+0xb0>
  802d14:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802d18:	39 3c 24             	cmp    %edi,(%esp)
  802d1b:	0f 87 e7 00 00 00    	ja     802e08 <__umoddi3+0x148>
  802d21:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d25:	29 f1                	sub    %esi,%ecx
  802d27:	19 c7                	sbb    %eax,%edi
  802d29:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d31:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d35:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802d39:	83 c4 14             	add    $0x14,%esp
  802d3c:	5e                   	pop    %esi
  802d3d:	5f                   	pop    %edi
  802d3e:	5d                   	pop    %ebp
  802d3f:	c3                   	ret    
  802d40:	85 f6                	test   %esi,%esi
  802d42:	89 f5                	mov    %esi,%ebp
  802d44:	75 0b                	jne    802d51 <__umoddi3+0x91>
  802d46:	b8 01 00 00 00       	mov    $0x1,%eax
  802d4b:	31 d2                	xor    %edx,%edx
  802d4d:	f7 f6                	div    %esi
  802d4f:	89 c5                	mov    %eax,%ebp
  802d51:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d55:	31 d2                	xor    %edx,%edx
  802d57:	f7 f5                	div    %ebp
  802d59:	89 c8                	mov    %ecx,%eax
  802d5b:	f7 f5                	div    %ebp
  802d5d:	eb 9c                	jmp    802cfb <__umoddi3+0x3b>
  802d5f:	90                   	nop
  802d60:	89 c8                	mov    %ecx,%eax
  802d62:	89 fa                	mov    %edi,%edx
  802d64:	83 c4 14             	add    $0x14,%esp
  802d67:	5e                   	pop    %esi
  802d68:	5f                   	pop    %edi
  802d69:	5d                   	pop    %ebp
  802d6a:	c3                   	ret    
  802d6b:	90                   	nop
  802d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d70:	8b 04 24             	mov    (%esp),%eax
  802d73:	be 20 00 00 00       	mov    $0x20,%esi
  802d78:	89 e9                	mov    %ebp,%ecx
  802d7a:	29 ee                	sub    %ebp,%esi
  802d7c:	d3 e2                	shl    %cl,%edx
  802d7e:	89 f1                	mov    %esi,%ecx
  802d80:	d3 e8                	shr    %cl,%eax
  802d82:	89 e9                	mov    %ebp,%ecx
  802d84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d88:	8b 04 24             	mov    (%esp),%eax
  802d8b:	09 54 24 04          	or     %edx,0x4(%esp)
  802d8f:	89 fa                	mov    %edi,%edx
  802d91:	d3 e0                	shl    %cl,%eax
  802d93:	89 f1                	mov    %esi,%ecx
  802d95:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d99:	8b 44 24 10          	mov    0x10(%esp),%eax
  802d9d:	d3 ea                	shr    %cl,%edx
  802d9f:	89 e9                	mov    %ebp,%ecx
  802da1:	d3 e7                	shl    %cl,%edi
  802da3:	89 f1                	mov    %esi,%ecx
  802da5:	d3 e8                	shr    %cl,%eax
  802da7:	89 e9                	mov    %ebp,%ecx
  802da9:	09 f8                	or     %edi,%eax
  802dab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802daf:	f7 74 24 04          	divl   0x4(%esp)
  802db3:	d3 e7                	shl    %cl,%edi
  802db5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802db9:	89 d7                	mov    %edx,%edi
  802dbb:	f7 64 24 08          	mull   0x8(%esp)
  802dbf:	39 d7                	cmp    %edx,%edi
  802dc1:	89 c1                	mov    %eax,%ecx
  802dc3:	89 14 24             	mov    %edx,(%esp)
  802dc6:	72 2c                	jb     802df4 <__umoddi3+0x134>
  802dc8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802dcc:	72 22                	jb     802df0 <__umoddi3+0x130>
  802dce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802dd2:	29 c8                	sub    %ecx,%eax
  802dd4:	19 d7                	sbb    %edx,%edi
  802dd6:	89 e9                	mov    %ebp,%ecx
  802dd8:	89 fa                	mov    %edi,%edx
  802dda:	d3 e8                	shr    %cl,%eax
  802ddc:	89 f1                	mov    %esi,%ecx
  802dde:	d3 e2                	shl    %cl,%edx
  802de0:	89 e9                	mov    %ebp,%ecx
  802de2:	d3 ef                	shr    %cl,%edi
  802de4:	09 d0                	or     %edx,%eax
  802de6:	89 fa                	mov    %edi,%edx
  802de8:	83 c4 14             	add    $0x14,%esp
  802deb:	5e                   	pop    %esi
  802dec:	5f                   	pop    %edi
  802ded:	5d                   	pop    %ebp
  802dee:	c3                   	ret    
  802def:	90                   	nop
  802df0:	39 d7                	cmp    %edx,%edi
  802df2:	75 da                	jne    802dce <__umoddi3+0x10e>
  802df4:	8b 14 24             	mov    (%esp),%edx
  802df7:	89 c1                	mov    %eax,%ecx
  802df9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802dfd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802e01:	eb cb                	jmp    802dce <__umoddi3+0x10e>
  802e03:	90                   	nop
  802e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e08:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802e0c:	0f 82 0f ff ff ff    	jb     802d21 <__umoddi3+0x61>
  802e12:	e9 1a ff ff ff       	jmp    802d31 <__umoddi3+0x71>
