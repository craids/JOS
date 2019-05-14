
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl		_start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fe 4f 52             	decb   0x52(%edi)
f010000b:	e4 66                	in     $0x66,%al

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0100015:	b8 00 40 12 00       	mov    $0x124000,%eax
	movl	%eax, %cr3
f010001a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010001d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0100020:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0100025:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0100028:	b8 2f 00 10 f0       	mov    $0xf010002f,%eax
	jmp	*%eax
f010002d:	ff e0                	jmp    *%eax

f010002f <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002f:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100034:	bc 00 40 12 f0       	mov    $0xf0124000,%esp

	# now to C code
	call	i386_init
f0100039:	e8 6a 00 00 00       	call   f01000a8 <i386_init>

f010003e <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003e:	eb fe                	jmp    f010003e <spin>

f0100040 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	56                   	push   %esi
f0100044:	53                   	push   %ebx
f0100045:	83 ec 10             	sub    $0x10,%esp
f0100048:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f010004b:	83 3d 8c 9e 2c f0 00 	cmpl   $0x0,0xf02c9e8c
f0100052:	75 46                	jne    f010009a <_panic+0x5a>
		goto dead;
	panicstr = fmt;
f0100054:	89 35 8c 9e 2c f0    	mov    %esi,0xf02c9e8c

	// Be extra sure that the machine is in as reasonable state
	asm volatile("cli; cld");
f010005a:	fa                   	cli    
f010005b:	fc                   	cld    

	va_start(ap, fmt);
f010005c:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010005f:	e8 a5 6d 00 00       	call   f0106e09 <cpunum>
f0100064:	8b 55 0c             	mov    0xc(%ebp),%edx
f0100067:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010006b:	8b 55 08             	mov    0x8(%ebp),%edx
f010006e:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100072:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100076:	c7 04 24 20 81 10 f0 	movl   $0xf0108120,(%esp)
f010007d:	e8 c0 42 00 00       	call   f0104342 <cprintf>
	vcprintf(fmt, ap);
f0100082:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100086:	89 34 24             	mov    %esi,(%esp)
f0100089:	e8 81 42 00 00       	call   f010430f <vcprintf>
	cprintf("\n");
f010008e:	c7 04 24 a9 95 10 f0 	movl   $0xf01095a9,(%esp)
f0100095:	e8 a8 42 00 00       	call   f0104342 <cprintf>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f010009a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01000a1:	e8 39 0d 00 00       	call   f0100ddf <monitor>
f01000a6:	eb f2                	jmp    f010009a <_panic+0x5a>

f01000a8 <i386_init>:
static void boot_aps(void);


void
i386_init(void)
{
f01000a8:	55                   	push   %ebp
f01000a9:	89 e5                	mov    %esp,%ebp
f01000ab:	53                   	push   %ebx
f01000ac:	83 ec 14             	sub    $0x14,%esp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f01000af:	b8 40 ba 35 f0       	mov    $0xf035ba40,%eax
f01000b4:	2d 39 87 2c f0       	sub    $0xf02c8739,%eax
f01000b9:	89 44 24 08          	mov    %eax,0x8(%esp)
f01000bd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01000c4:	00 
f01000c5:	c7 04 24 39 87 2c f0 	movl   $0xf02c8739,(%esp)
f01000cc:	e8 e6 66 00 00       	call   f01067b7 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f01000d1:	e8 e9 05 00 00       	call   f01006bf <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f01000d6:	c7 44 24 04 ac 1a 00 	movl   $0x1aac,0x4(%esp)
f01000dd:	00 
f01000de:	c7 04 24 8c 81 10 f0 	movl   $0xf010818c,(%esp)
f01000e5:	e8 58 42 00 00       	call   f0104342 <cprintf>

	// Lab 2 memory management initialization functions
	mem_init();
f01000ea:	e8 9d 17 00 00       	call   f010188c <mem_init>

	// Lab 3 user environment initialization functions
	env_init();
f01000ef:	e8 50 3a 00 00       	call   f0103b44 <env_init>
	trap_init();
f01000f4:	e8 5d 43 00 00       	call   f0104456 <trap_init>

	// Lab 4 multiprocessor initialization functions
	mp_init();
f01000f9:	e8 fc 69 00 00       	call   f0106afa <mp_init>
	lapic_init();
f01000fe:	66 90                	xchg   %ax,%ax
f0100100:	e8 1f 6d 00 00       	call   f0106e24 <lapic_init>

	// Lab 4 multitasking initialization functions
	pic_init();
f0100105:	e8 55 41 00 00       	call   f010425f <pic_init>

	// Lab 6 hardware initialization functions
	time_init();
f010010a:	e8 0b 7d 00 00       	call   f0107e1a <time_init>
	pci_init();
f010010f:	90                   	nop
f0100110:	e8 d7 7c 00 00       	call   f0107dec <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f0100115:	c7 04 24 c0 63 12 f0 	movl   $0xf01263c0,(%esp)
f010011c:	e8 66 6f 00 00       	call   f0107087 <spin_lock>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100121:	83 3d 94 9e 2c f0 07 	cmpl   $0x7,0xf02c9e94
f0100128:	77 24                	ja     f010014e <i386_init+0xa6>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010012a:	c7 44 24 0c 00 70 00 	movl   $0x7000,0xc(%esp)
f0100131:	00 
f0100132:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0100139:	f0 
f010013a:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
f0100141:	00 
f0100142:	c7 04 24 a7 81 10 f0 	movl   $0xf01081a7,(%esp)
f0100149:	e8 f2 fe ff ff       	call   f0100040 <_panic>
	void *code;
	struct CpuInfo *c;

	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f010014e:	b8 32 6a 10 f0       	mov    $0xf0106a32,%eax
f0100153:	2d b8 69 10 f0       	sub    $0xf01069b8,%eax
f0100158:	89 44 24 08          	mov    %eax,0x8(%esp)
f010015c:	c7 44 24 04 b8 69 10 	movl   $0xf01069b8,0x4(%esp)
f0100163:	f0 
f0100164:	c7 04 24 00 70 00 f0 	movl   $0xf0007000,(%esp)
f010016b:	e8 94 66 00 00       	call   f0106804 <memmove>

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
f0100170:	bb 20 a0 2c f0       	mov    $0xf02ca020,%ebx
f0100175:	eb 4d                	jmp    f01001c4 <i386_init+0x11c>
		if (c == cpus + cpunum())  // We've started already.
f0100177:	e8 8d 6c 00 00       	call   f0106e09 <cpunum>
f010017c:	6b c0 74             	imul   $0x74,%eax,%eax
f010017f:	05 20 a0 2c f0       	add    $0xf02ca020,%eax
f0100184:	39 c3                	cmp    %eax,%ebx
f0100186:	74 39                	je     f01001c1 <i386_init+0x119>
f0100188:	89 d8                	mov    %ebx,%eax
f010018a:	2d 20 a0 2c f0       	sub    $0xf02ca020,%eax
			continue;

		// Tell mpentry.S what stack to use 
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f010018f:	c1 f8 02             	sar    $0x2,%eax
f0100192:	69 c0 35 c2 72 4f    	imul   $0x4f72c235,%eax,%eax
f0100198:	c1 e0 0f             	shl    $0xf,%eax
f010019b:	8d 80 00 30 2d f0    	lea    -0xfd2d000(%eax),%eax
f01001a1:	a3 90 9e 2c f0       	mov    %eax,0xf02c9e90
		// Start the CPU at mpentry_start
		lapic_startap(c->cpu_id, PADDR(code));
f01001a6:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
f01001ad:	00 
f01001ae:	0f b6 03             	movzbl (%ebx),%eax
f01001b1:	89 04 24             	mov    %eax,(%esp)
f01001b4:	e8 bb 6d 00 00       	call   f0106f74 <lapic_startap>
		// Wait for the CPU to finish some basic setup in mp_main()
		while(c->cpu_status != CPU_STARTED)
f01001b9:	8b 43 04             	mov    0x4(%ebx),%eax
f01001bc:	83 f8 01             	cmp    $0x1,%eax
f01001bf:	75 f8                	jne    f01001b9 <i386_init+0x111>
	// Write entry code to unused memory at MPENTRY_PADDR
	code = KADDR(MPENTRY_PADDR);
	memmove(code, mpentry_start, mpentry_end - mpentry_start);

	// Boot each AP one at a time
	for (c = cpus; c < cpus + ncpu; c++) {
f01001c1:	83 c3 74             	add    $0x74,%ebx
f01001c4:	6b 05 c4 a3 2c f0 74 	imul   $0x74,0xf02ca3c4,%eax
f01001cb:	05 20 a0 2c f0       	add    $0xf02ca020,%eax
f01001d0:	39 c3                	cmp    %eax,%ebx
f01001d2:	72 a3                	jb     f0100177 <i386_init+0xcf>
	//cprintf("Result of packet: %d\n", e1000_transmit("HUEHUEHUE", 9));
	// Starting non-boot CPUs
	boot_aps();

	// Start fs.
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f01001d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f01001db:	00 
f01001dc:	c7 04 24 d1 bb 1e f0 	movl   $0xf01ebbd1,(%esp)
f01001e3:	e8 21 3b 00 00       	call   f0103d09 <env_create>

#if !defined(TEST_NO_NS)
	// Start ns.
	ENV_CREATE(net_ns, ENV_TYPE_NS);
f01001e8:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f01001ef:	00 
f01001f0:	c7 04 24 29 9a 24 f0 	movl   $0xf0249a29,(%esp)
f01001f7:	e8 0d 3b 00 00       	call   f0103d09 <env_create>
#endif

#if defined(TEST)
	// Don't touch -- used by grading script!
	ENV_CREATE(TEST, ENV_TYPE_USER);
f01001fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100203:	00 
f0100204:	c7 04 24 ac d6 20 f0 	movl   $0xf020d6ac,(%esp)
f010020b:	e8 f9 3a 00 00       	call   f0103d09 <env_create>
	// Touch all you want.
ENV_CREATE(user_icode, ENV_TYPE_USER);
#endif // TEST*

	// Should not be necessary - drains keyboard because interrupt has given up.
	kbd_intr();
f0100210:	e8 4e 04 00 00       	call   f0100663 <kbd_intr>

	// Schedule and run the first user environment!
	sched_yield();
f0100215:	e8 ac 4e 00 00       	call   f01050c6 <sched_yield>

f010021a <mp_main>:
}

// Setup code for APs
void
mp_main(void)
{
f010021a:	55                   	push   %ebp
f010021b:	89 e5                	mov    %esp,%ebp
f010021d:	83 ec 18             	sub    $0x18,%esp
	// We are in high EIP now, safe to switch to kern_pgdir 
	lcr3(PADDR(kern_pgdir));
f0100220:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0100225:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010022a:	77 20                	ja     f010024c <mp_main+0x32>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010022c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100230:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f0100237:	f0 
f0100238:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
f010023f:	00 
f0100240:	c7 04 24 a7 81 10 f0 	movl   $0xf01081a7,(%esp)
f0100247:	e8 f4 fd ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f010024c:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0100251:	0f 22 d8             	mov    %eax,%cr3
	cprintf("SMP: CPU %d starting\n", cpunum());
f0100254:	e8 b0 6b 00 00       	call   f0106e09 <cpunum>
f0100259:	89 44 24 04          	mov    %eax,0x4(%esp)
f010025d:	c7 04 24 b3 81 10 f0 	movl   $0xf01081b3,(%esp)
f0100264:	e8 d9 40 00 00       	call   f0104342 <cprintf>

	lapic_init();
f0100269:	e8 b6 6b 00 00       	call   f0106e24 <lapic_init>
	env_init_percpu();
f010026e:	e8 a7 38 00 00       	call   f0103b1a <env_init_percpu>
	trap_init_percpu();
f0100273:	e8 e8 40 00 00       	call   f0104360 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f0100278:	e8 8c 6b 00 00       	call   f0106e09 <cpunum>
f010027d:	6b d0 74             	imul   $0x74,%eax,%edx
f0100280:	81 c2 20 a0 2c f0    	add    $0xf02ca020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0100286:	b8 01 00 00 00       	mov    $0x1,%eax
f010028b:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
f010028f:	c7 04 24 c0 63 12 f0 	movl   $0xf01263c0,(%esp)
f0100296:	e8 ec 6d 00 00       	call   f0107087 <spin_lock>
	// to start running processes on this CPU.  But make sure that
	// only one CPU can enter the scheduler at a time!
	//
	// Your code here:
	lock_kernel();
	sched_yield();
f010029b:	e8 26 4e 00 00       	call   f01050c6 <sched_yield>

f01002a0 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f01002a0:	55                   	push   %ebp
f01002a1:	89 e5                	mov    %esp,%ebp
f01002a3:	53                   	push   %ebx
f01002a4:	83 ec 14             	sub    $0x14,%esp
	va_list ap;

	va_start(ap, fmt);
f01002a7:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f01002aa:	8b 45 0c             	mov    0xc(%ebp),%eax
f01002ad:	89 44 24 08          	mov    %eax,0x8(%esp)
f01002b1:	8b 45 08             	mov    0x8(%ebp),%eax
f01002b4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01002b8:	c7 04 24 c9 81 10 f0 	movl   $0xf01081c9,(%esp)
f01002bf:	e8 7e 40 00 00       	call   f0104342 <cprintf>
	vcprintf(fmt, ap);
f01002c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01002c8:	8b 45 10             	mov    0x10(%ebp),%eax
f01002cb:	89 04 24             	mov    %eax,(%esp)
f01002ce:	e8 3c 40 00 00       	call   f010430f <vcprintf>
	cprintf("\n");
f01002d3:	c7 04 24 a9 95 10 f0 	movl   $0xf01095a9,(%esp)
f01002da:	e8 63 40 00 00       	call   f0104342 <cprintf>
	va_end(ap);
}
f01002df:	83 c4 14             	add    $0x14,%esp
f01002e2:	5b                   	pop    %ebx
f01002e3:	5d                   	pop    %ebp
f01002e4:	c3                   	ret    
f01002e5:	66 90                	xchg   %ax,%ax
f01002e7:	66 90                	xchg   %ax,%ax
f01002e9:	66 90                	xchg   %ax,%ax
f01002eb:	66 90                	xchg   %ax,%ax
f01002ed:	66 90                	xchg   %ax,%ax
f01002ef:	90                   	nop

f01002f0 <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f01002f0:	55                   	push   %ebp
f01002f1:	89 e5                	mov    %esp,%ebp

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01002f3:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01002f8:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f01002f9:	a8 01                	test   $0x1,%al
f01002fb:	74 08                	je     f0100305 <serial_proc_data+0x15>
f01002fd:	b2 f8                	mov    $0xf8,%dl
f01002ff:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100300:	0f b6 c0             	movzbl %al,%eax
f0100303:	eb 05                	jmp    f010030a <serial_proc_data+0x1a>

static int
serial_proc_data(void)
{
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
		return -1;
f0100305:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return inb(COM1+COM_RX);
}
f010030a:	5d                   	pop    %ebp
f010030b:	c3                   	ret    

f010030c <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010030c:	55                   	push   %ebp
f010030d:	89 e5                	mov    %esp,%ebp
f010030f:	53                   	push   %ebx
f0100310:	83 ec 04             	sub    $0x4,%esp
f0100313:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100315:	eb 2a                	jmp    f0100341 <cons_intr+0x35>
		if (c == 0)
f0100317:	85 d2                	test   %edx,%edx
f0100319:	74 26                	je     f0100341 <cons_intr+0x35>
			continue;
		cons.buf[cons.wpos++] = c;
f010031b:	a1 24 92 2c f0       	mov    0xf02c9224,%eax
f0100320:	8d 48 01             	lea    0x1(%eax),%ecx
f0100323:	89 0d 24 92 2c f0    	mov    %ecx,0xf02c9224
f0100329:	88 90 20 90 2c f0    	mov    %dl,-0xfd36fe0(%eax)
		if (cons.wpos == CONSBUFSIZE)
f010032f:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f0100335:	75 0a                	jne    f0100341 <cons_intr+0x35>
			cons.wpos = 0;
f0100337:	c7 05 24 92 2c f0 00 	movl   $0x0,0xf02c9224
f010033e:	00 00 00 
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f0100341:	ff d3                	call   *%ebx
f0100343:	89 c2                	mov    %eax,%edx
f0100345:	83 f8 ff             	cmp    $0xffffffff,%eax
f0100348:	75 cd                	jne    f0100317 <cons_intr+0xb>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
f010034a:	83 c4 04             	add    $0x4,%esp
f010034d:	5b                   	pop    %ebx
f010034e:	5d                   	pop    %ebp
f010034f:	c3                   	ret    

f0100350 <kbd_proc_data>:
f0100350:	ba 64 00 00 00       	mov    $0x64,%edx
f0100355:	ec                   	in     (%dx),%al
	int c;
	uint8_t stat, data;
	static uint32_t shift;

	stat = inb(KBSTATP);
	if ((stat & KBS_DIB) == 0)
f0100356:	a8 01                	test   $0x1,%al
f0100358:	0f 84 f7 00 00 00    	je     f0100455 <kbd_proc_data+0x105>
		return -1;
	// Ignore data from mouse.
	if (stat & KBS_TERR)
f010035e:	a8 20                	test   $0x20,%al
f0100360:	0f 85 f5 00 00 00    	jne    f010045b <kbd_proc_data+0x10b>
f0100366:	b2 60                	mov    $0x60,%dl
f0100368:	ec                   	in     (%dx),%al
f0100369:	89 c2                	mov    %eax,%edx
		return -1;

	data = inb(KBDATAP);

	if (data == 0xE0) {
f010036b:	3c e0                	cmp    $0xe0,%al
f010036d:	75 0d                	jne    f010037c <kbd_proc_data+0x2c>
		// E0 escape character
		shift |= E0ESC;
f010036f:	83 0d 00 90 2c f0 40 	orl    $0x40,0xf02c9000
		return 0;
f0100376:	b8 00 00 00 00       	mov    $0x0,%eax
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f010037b:	c3                   	ret    
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f010037c:	55                   	push   %ebp
f010037d:	89 e5                	mov    %esp,%ebp
f010037f:	53                   	push   %ebx
f0100380:	83 ec 14             	sub    $0x14,%esp

	if (data == 0xE0) {
		// E0 escape character
		shift |= E0ESC;
		return 0;
	} else if (data & 0x80) {
f0100383:	84 c0                	test   %al,%al
f0100385:	79 37                	jns    f01003be <kbd_proc_data+0x6e>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f0100387:	8b 0d 00 90 2c f0    	mov    0xf02c9000,%ecx
f010038d:	89 cb                	mov    %ecx,%ebx
f010038f:	83 e3 40             	and    $0x40,%ebx
f0100392:	83 e0 7f             	and    $0x7f,%eax
f0100395:	85 db                	test   %ebx,%ebx
f0100397:	0f 44 d0             	cmove  %eax,%edx
		shift &= ~(shiftcode[data] | E0ESC);
f010039a:	0f b6 d2             	movzbl %dl,%edx
f010039d:	0f b6 82 40 83 10 f0 	movzbl -0xfef7cc0(%edx),%eax
f01003a4:	83 c8 40             	or     $0x40,%eax
f01003a7:	0f b6 c0             	movzbl %al,%eax
f01003aa:	f7 d0                	not    %eax
f01003ac:	21 c1                	and    %eax,%ecx
f01003ae:	89 0d 00 90 2c f0    	mov    %ecx,0xf02c9000
		return 0;
f01003b4:	b8 00 00 00 00       	mov    $0x0,%eax
f01003b9:	e9 a3 00 00 00       	jmp    f0100461 <kbd_proc_data+0x111>
	} else if (shift & E0ESC) {
f01003be:	8b 0d 00 90 2c f0    	mov    0xf02c9000,%ecx
f01003c4:	f6 c1 40             	test   $0x40,%cl
f01003c7:	74 0e                	je     f01003d7 <kbd_proc_data+0x87>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f01003c9:	83 c8 80             	or     $0xffffff80,%eax
f01003cc:	89 c2                	mov    %eax,%edx
		shift &= ~E0ESC;
f01003ce:	83 e1 bf             	and    $0xffffffbf,%ecx
f01003d1:	89 0d 00 90 2c f0    	mov    %ecx,0xf02c9000
	}

	shift |= shiftcode[data];
f01003d7:	0f b6 d2             	movzbl %dl,%edx
f01003da:	0f b6 82 40 83 10 f0 	movzbl -0xfef7cc0(%edx),%eax
f01003e1:	0b 05 00 90 2c f0    	or     0xf02c9000,%eax
	shift ^= togglecode[data];
f01003e7:	0f b6 8a 40 82 10 f0 	movzbl -0xfef7dc0(%edx),%ecx
f01003ee:	31 c8                	xor    %ecx,%eax
f01003f0:	a3 00 90 2c f0       	mov    %eax,0xf02c9000

	c = charcode[shift & (CTL | SHIFT)][data];
f01003f5:	89 c1                	mov    %eax,%ecx
f01003f7:	83 e1 03             	and    $0x3,%ecx
f01003fa:	8b 0c 8d 20 82 10 f0 	mov    -0xfef7de0(,%ecx,4),%ecx
f0100401:	0f b6 14 11          	movzbl (%ecx,%edx,1),%edx
f0100405:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100408:	a8 08                	test   $0x8,%al
f010040a:	74 1b                	je     f0100427 <kbd_proc_data+0xd7>
		if ('a' <= c && c <= 'z')
f010040c:	89 da                	mov    %ebx,%edx
f010040e:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f0100411:	83 f9 19             	cmp    $0x19,%ecx
f0100414:	77 05                	ja     f010041b <kbd_proc_data+0xcb>
			c += 'A' - 'a';
f0100416:	83 eb 20             	sub    $0x20,%ebx
f0100419:	eb 0c                	jmp    f0100427 <kbd_proc_data+0xd7>
		else if ('A' <= c && c <= 'Z')
f010041b:	83 ea 41             	sub    $0x41,%edx
			c += 'a' - 'A';
f010041e:	8d 4b 20             	lea    0x20(%ebx),%ecx
f0100421:	83 fa 19             	cmp    $0x19,%edx
f0100424:	0f 46 d9             	cmovbe %ecx,%ebx
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100427:	f7 d0                	not    %eax
f0100429:	89 c2                	mov    %eax,%edx
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
f010042b:	89 d8                	mov    %ebx,%eax
			c += 'a' - 'A';
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f010042d:	f6 c2 06             	test   $0x6,%dl
f0100430:	75 2f                	jne    f0100461 <kbd_proc_data+0x111>
f0100432:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100438:	75 27                	jne    f0100461 <kbd_proc_data+0x111>
		cprintf("Rebooting!\n");
f010043a:	c7 04 24 e3 81 10 f0 	movl   $0xf01081e3,(%esp)
f0100441:	e8 fc 3e 00 00       	call   f0104342 <cprintf>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100446:	ba 92 00 00 00       	mov    $0x92,%edx
f010044b:	b8 03 00 00 00       	mov    $0x3,%eax
f0100450:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
f0100451:	89 d8                	mov    %ebx,%eax
f0100453:	eb 0c                	jmp    f0100461 <kbd_proc_data+0x111>
	uint8_t stat, data;
	static uint32_t shift;

	stat = inb(KBSTATP);
	if ((stat & KBS_DIB) == 0)
		return -1;
f0100455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010045a:	c3                   	ret    
	// Ignore data from mouse.
	if (stat & KBS_TERR)
		return -1;
f010045b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100460:	c3                   	ret    
		cprintf("Rebooting!\n");
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f0100461:	83 c4 14             	add    $0x14,%esp
f0100464:	5b                   	pop    %ebx
f0100465:	5d                   	pop    %ebp
f0100466:	c3                   	ret    

f0100467 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100467:	55                   	push   %ebp
f0100468:	89 e5                	mov    %esp,%ebp
f010046a:	57                   	push   %edi
f010046b:	56                   	push   %esi
f010046c:	53                   	push   %ebx
f010046d:	83 ec 1c             	sub    $0x1c,%esp
f0100470:	89 c7                	mov    %eax,%edi
f0100472:	bb 01 32 00 00       	mov    $0x3201,%ebx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100477:	be fd 03 00 00       	mov    $0x3fd,%esi
f010047c:	b9 84 00 00 00       	mov    $0x84,%ecx
f0100481:	eb 06                	jmp    f0100489 <cons_putc+0x22>
f0100483:	89 ca                	mov    %ecx,%edx
f0100485:	ec                   	in     (%dx),%al
f0100486:	ec                   	in     (%dx),%al
f0100487:	ec                   	in     (%dx),%al
f0100488:	ec                   	in     (%dx),%al
f0100489:	89 f2                	mov    %esi,%edx
f010048b:	ec                   	in     (%dx),%al
static void
serial_putc(int c)
{
	int i;

	for (i = 0;
f010048c:	a8 20                	test   $0x20,%al
f010048e:	75 05                	jne    f0100495 <cons_putc+0x2e>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f0100490:	83 eb 01             	sub    $0x1,%ebx
f0100493:	75 ee                	jne    f0100483 <cons_putc+0x1c>
	     i++)
		delay();

	outb(COM1 + COM_TX, c);
f0100495:	89 f8                	mov    %edi,%eax
f0100497:	0f b6 c0             	movzbl %al,%eax
f010049a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010049d:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01004a2:	ee                   	out    %al,(%dx)
f01004a3:	bb 01 32 00 00       	mov    $0x3201,%ebx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01004a8:	be 79 03 00 00       	mov    $0x379,%esi
f01004ad:	b9 84 00 00 00       	mov    $0x84,%ecx
f01004b2:	eb 06                	jmp    f01004ba <cons_putc+0x53>
f01004b4:	89 ca                	mov    %ecx,%edx
f01004b6:	ec                   	in     (%dx),%al
f01004b7:	ec                   	in     (%dx),%al
f01004b8:	ec                   	in     (%dx),%al
f01004b9:	ec                   	in     (%dx),%al
f01004ba:	89 f2                	mov    %esi,%edx
f01004bc:	ec                   	in     (%dx),%al
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01004bd:	84 c0                	test   %al,%al
f01004bf:	78 05                	js     f01004c6 <cons_putc+0x5f>
f01004c1:	83 eb 01             	sub    $0x1,%ebx
f01004c4:	75 ee                	jne    f01004b4 <cons_putc+0x4d>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01004c6:	ba 78 03 00 00       	mov    $0x378,%edx
f01004cb:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
f01004cf:	ee                   	out    %al,(%dx)
f01004d0:	b2 7a                	mov    $0x7a,%dl
f01004d2:	b8 0d 00 00 00       	mov    $0xd,%eax
f01004d7:	ee                   	out    %al,(%dx)
f01004d8:	b8 08 00 00 00       	mov    $0x8,%eax
f01004dd:	ee                   	out    %al,(%dx)

static void
cga_putc(int c)
{
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
f01004de:	89 fa                	mov    %edi,%edx
f01004e0:	81 e2 00 ff ff ff    	and    $0xffffff00,%edx
		c |= 0x0700;
f01004e6:	89 f8                	mov    %edi,%eax
f01004e8:	80 cc 07             	or     $0x7,%ah
f01004eb:	85 d2                	test   %edx,%edx
f01004ed:	0f 44 f8             	cmove  %eax,%edi

	switch (c & 0xff) {
f01004f0:	89 f8                	mov    %edi,%eax
f01004f2:	0f b6 c0             	movzbl %al,%eax
f01004f5:	83 f8 09             	cmp    $0x9,%eax
f01004f8:	74 78                	je     f0100572 <cons_putc+0x10b>
f01004fa:	83 f8 09             	cmp    $0x9,%eax
f01004fd:	7f 0a                	jg     f0100509 <cons_putc+0xa2>
f01004ff:	83 f8 08             	cmp    $0x8,%eax
f0100502:	74 18                	je     f010051c <cons_putc+0xb5>
f0100504:	e9 9d 00 00 00       	jmp    f01005a6 <cons_putc+0x13f>
f0100509:	83 f8 0a             	cmp    $0xa,%eax
f010050c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0100510:	74 3a                	je     f010054c <cons_putc+0xe5>
f0100512:	83 f8 0d             	cmp    $0xd,%eax
f0100515:	74 3d                	je     f0100554 <cons_putc+0xed>
f0100517:	e9 8a 00 00 00       	jmp    f01005a6 <cons_putc+0x13f>
	case '\b':
		if (crt_pos > 0) {
f010051c:	0f b7 05 28 92 2c f0 	movzwl 0xf02c9228,%eax
f0100523:	66 85 c0             	test   %ax,%ax
f0100526:	0f 84 e5 00 00 00    	je     f0100611 <cons_putc+0x1aa>
			crt_pos--;
f010052c:	83 e8 01             	sub    $0x1,%eax
f010052f:	66 a3 28 92 2c f0    	mov    %ax,0xf02c9228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100535:	0f b7 c0             	movzwl %ax,%eax
f0100538:	66 81 e7 00 ff       	and    $0xff00,%di
f010053d:	83 cf 20             	or     $0x20,%edi
f0100540:	8b 15 2c 92 2c f0    	mov    0xf02c922c,%edx
f0100546:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f010054a:	eb 78                	jmp    f01005c4 <cons_putc+0x15d>
		}
		break;
	case '\n':
		crt_pos += CRT_COLS;
f010054c:	66 83 05 28 92 2c f0 	addw   $0x50,0xf02c9228
f0100553:	50 
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f0100554:	0f b7 05 28 92 2c f0 	movzwl 0xf02c9228,%eax
f010055b:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f0100561:	c1 e8 16             	shr    $0x16,%eax
f0100564:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0100567:	c1 e0 04             	shl    $0x4,%eax
f010056a:	66 a3 28 92 2c f0    	mov    %ax,0xf02c9228
f0100570:	eb 52                	jmp    f01005c4 <cons_putc+0x15d>
		break;
	case '\t':
		cons_putc(' ');
f0100572:	b8 20 00 00 00       	mov    $0x20,%eax
f0100577:	e8 eb fe ff ff       	call   f0100467 <cons_putc>
		cons_putc(' ');
f010057c:	b8 20 00 00 00       	mov    $0x20,%eax
f0100581:	e8 e1 fe ff ff       	call   f0100467 <cons_putc>
		cons_putc(' ');
f0100586:	b8 20 00 00 00       	mov    $0x20,%eax
f010058b:	e8 d7 fe ff ff       	call   f0100467 <cons_putc>
		cons_putc(' ');
f0100590:	b8 20 00 00 00       	mov    $0x20,%eax
f0100595:	e8 cd fe ff ff       	call   f0100467 <cons_putc>
		cons_putc(' ');
f010059a:	b8 20 00 00 00       	mov    $0x20,%eax
f010059f:	e8 c3 fe ff ff       	call   f0100467 <cons_putc>
f01005a4:	eb 1e                	jmp    f01005c4 <cons_putc+0x15d>
		break;
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f01005a6:	0f b7 05 28 92 2c f0 	movzwl 0xf02c9228,%eax
f01005ad:	8d 50 01             	lea    0x1(%eax),%edx
f01005b0:	66 89 15 28 92 2c f0 	mov    %dx,0xf02c9228
f01005b7:	0f b7 c0             	movzwl %ax,%eax
f01005ba:	8b 15 2c 92 2c f0    	mov    0xf02c922c,%edx
f01005c0:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f01005c4:	66 81 3d 28 92 2c f0 	cmpw   $0x7cf,0xf02c9228
f01005cb:	cf 07 
f01005cd:	76 42                	jbe    f0100611 <cons_putc+0x1aa>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f01005cf:	a1 2c 92 2c f0       	mov    0xf02c922c,%eax
f01005d4:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
f01005db:	00 
f01005dc:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f01005e2:	89 54 24 04          	mov    %edx,0x4(%esp)
f01005e6:	89 04 24             	mov    %eax,(%esp)
f01005e9:	e8 16 62 00 00       	call   f0106804 <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
			crt_buf[i] = 0x0700 | ' ';
f01005ee:	8b 15 2c 92 2c f0    	mov    0xf02c922c,%edx
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005f4:	b8 80 07 00 00       	mov    $0x780,%eax
			crt_buf[i] = 0x0700 | ' ';
f01005f9:	66 c7 04 42 20 07    	movw   $0x720,(%edx,%eax,2)
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f01005ff:	83 c0 01             	add    $0x1,%eax
f0100602:	3d d0 07 00 00       	cmp    $0x7d0,%eax
f0100607:	75 f0                	jne    f01005f9 <cons_putc+0x192>
			crt_buf[i] = 0x0700 | ' ';
		crt_pos -= CRT_COLS;
f0100609:	66 83 2d 28 92 2c f0 	subw   $0x50,0xf02c9228
f0100610:	50 
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
f0100611:	8b 0d 30 92 2c f0    	mov    0xf02c9230,%ecx
f0100617:	b8 0e 00 00 00       	mov    $0xe,%eax
f010061c:	89 ca                	mov    %ecx,%edx
f010061e:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f010061f:	0f b7 1d 28 92 2c f0 	movzwl 0xf02c9228,%ebx
f0100626:	8d 71 01             	lea    0x1(%ecx),%esi
f0100629:	89 d8                	mov    %ebx,%eax
f010062b:	66 c1 e8 08          	shr    $0x8,%ax
f010062f:	89 f2                	mov    %esi,%edx
f0100631:	ee                   	out    %al,(%dx)
f0100632:	b8 0f 00 00 00       	mov    $0xf,%eax
f0100637:	89 ca                	mov    %ecx,%edx
f0100639:	ee                   	out    %al,(%dx)
f010063a:	89 d8                	mov    %ebx,%eax
f010063c:	89 f2                	mov    %esi,%edx
f010063e:	ee                   	out    %al,(%dx)
cons_putc(int c)
{
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f010063f:	83 c4 1c             	add    $0x1c,%esp
f0100642:	5b                   	pop    %ebx
f0100643:	5e                   	pop    %esi
f0100644:	5f                   	pop    %edi
f0100645:	5d                   	pop    %ebp
f0100646:	c3                   	ret    

f0100647 <serial_intr>:
}

void
serial_intr(void)
{
	if (serial_exists)
f0100647:	80 3d 34 92 2c f0 00 	cmpb   $0x0,0xf02c9234
f010064e:	74 11                	je     f0100661 <serial_intr+0x1a>
	return inb(COM1+COM_RX);
}

void
serial_intr(void)
{
f0100650:	55                   	push   %ebp
f0100651:	89 e5                	mov    %esp,%ebp
f0100653:	83 ec 08             	sub    $0x8,%esp
	if (serial_exists)
		cons_intr(serial_proc_data);
f0100656:	b8 f0 02 10 f0       	mov    $0xf01002f0,%eax
f010065b:	e8 ac fc ff ff       	call   f010030c <cons_intr>
}
f0100660:	c9                   	leave  
f0100661:	f3 c3                	repz ret 

f0100663 <kbd_intr>:
	return c;
}

void
kbd_intr(void)
{
f0100663:	55                   	push   %ebp
f0100664:	89 e5                	mov    %esp,%ebp
f0100666:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100669:	b8 50 03 10 f0       	mov    $0xf0100350,%eax
f010066e:	e8 99 fc ff ff       	call   f010030c <cons_intr>
}
f0100673:	c9                   	leave  
f0100674:	c3                   	ret    

f0100675 <cons_getc>:
}

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f0100675:	55                   	push   %ebp
f0100676:	89 e5                	mov    %esp,%ebp
f0100678:	83 ec 08             	sub    $0x8,%esp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f010067b:	e8 c7 ff ff ff       	call   f0100647 <serial_intr>
	kbd_intr();
f0100680:	e8 de ff ff ff       	call   f0100663 <kbd_intr>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f0100685:	a1 20 92 2c f0       	mov    0xf02c9220,%eax
f010068a:	3b 05 24 92 2c f0    	cmp    0xf02c9224,%eax
f0100690:	74 26                	je     f01006b8 <cons_getc+0x43>
		c = cons.buf[cons.rpos++];
f0100692:	8d 50 01             	lea    0x1(%eax),%edx
f0100695:	89 15 20 92 2c f0    	mov    %edx,0xf02c9220
f010069b:	0f b6 88 20 90 2c f0 	movzbl -0xfd36fe0(%eax),%ecx
		if (cons.rpos == CONSBUFSIZE)
			cons.rpos = 0;
		return c;
f01006a2:	89 c8                	mov    %ecx,%eax
	kbd_intr();

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
		c = cons.buf[cons.rpos++];
		if (cons.rpos == CONSBUFSIZE)
f01006a4:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f01006aa:	75 11                	jne    f01006bd <cons_getc+0x48>
			cons.rpos = 0;
f01006ac:	c7 05 20 92 2c f0 00 	movl   $0x0,0xf02c9220
f01006b3:	00 00 00 
f01006b6:	eb 05                	jmp    f01006bd <cons_getc+0x48>
		return c;
	}
	return 0;
f01006b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01006bd:	c9                   	leave  
f01006be:	c3                   	ret    

f01006bf <cons_init>:
}

// initialize the console devices
void
cons_init(void)
{
f01006bf:	55                   	push   %ebp
f01006c0:	89 e5                	mov    %esp,%ebp
f01006c2:	57                   	push   %edi
f01006c3:	56                   	push   %esi
f01006c4:	53                   	push   %ebx
f01006c5:	83 ec 1c             	sub    $0x1c,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
f01006c8:	0f b7 15 00 80 0b f0 	movzwl 0xf00b8000,%edx
	*cp = (uint16_t) 0xA55A;
f01006cf:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f01006d6:	5a a5 
	if (*cp != 0xA55A) {
f01006d8:	0f b7 05 00 80 0b f0 	movzwl 0xf00b8000,%eax
f01006df:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01006e3:	74 11                	je     f01006f6 <cons_init+0x37>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
		addr_6845 = MONO_BASE;
f01006e5:	c7 05 30 92 2c f0 b4 	movl   $0x3b4,0xf02c9230
f01006ec:	03 00 00 

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
	*cp = (uint16_t) 0xA55A;
	if (*cp != 0xA55A) {
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f01006ef:	bf 00 00 0b f0       	mov    $0xf00b0000,%edi
f01006f4:	eb 16                	jmp    f010070c <cons_init+0x4d>
		addr_6845 = MONO_BASE;
	} else {
		*cp = was;
f01006f6:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f01006fd:	c7 05 30 92 2c f0 d4 	movl   $0x3d4,0xf02c9230
f0100704:	03 00 00 
{
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f0100707:	bf 00 80 0b f0       	mov    $0xf00b8000,%edi
		*cp = was;
		addr_6845 = CGA_BASE;
	}

	/* Extract cursor location */
	outb(addr_6845, 14);
f010070c:	8b 0d 30 92 2c f0    	mov    0xf02c9230,%ecx
f0100712:	b8 0e 00 00 00       	mov    $0xe,%eax
f0100717:	89 ca                	mov    %ecx,%edx
f0100719:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f010071a:	8d 59 01             	lea    0x1(%ecx),%ebx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010071d:	89 da                	mov    %ebx,%edx
f010071f:	ec                   	in     (%dx),%al
f0100720:	0f b6 f0             	movzbl %al,%esi
f0100723:	c1 e6 08             	shl    $0x8,%esi
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100726:	b8 0f 00 00 00       	mov    $0xf,%eax
f010072b:	89 ca                	mov    %ecx,%edx
f010072d:	ee                   	out    %al,(%dx)

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010072e:	89 da                	mov    %ebx,%edx
f0100730:	ec                   	in     (%dx),%al
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);

	crt_buf = (uint16_t*) cp;
f0100731:	89 3d 2c 92 2c f0    	mov    %edi,0xf02c922c

	/* Extract cursor location */
	outb(addr_6845, 14);
	pos = inb(addr_6845 + 1) << 8;
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);
f0100737:	0f b6 d8             	movzbl %al,%ebx
f010073a:	09 de                	or     %ebx,%esi

	crt_buf = (uint16_t*) cp;
	crt_pos = pos;
f010073c:	66 89 35 28 92 2c f0 	mov    %si,0xf02c9228

static void
kbd_init(void)
{
	// Drain the kbd buffer so that QEMU generates interrupts.
	kbd_intr();
f0100743:	e8 1b ff ff ff       	call   f0100663 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f0100748:	0f b7 05 a8 63 12 f0 	movzwl 0xf01263a8,%eax
f010074f:	25 fd ff 00 00       	and    $0xfffd,%eax
f0100754:	89 04 24             	mov    %eax,(%esp)
f0100757:	e8 8e 3a 00 00       	call   f01041ea <irq_setmask_8259A>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010075c:	be fa 03 00 00       	mov    $0x3fa,%esi
f0100761:	b8 00 00 00 00       	mov    $0x0,%eax
f0100766:	89 f2                	mov    %esi,%edx
f0100768:	ee                   	out    %al,(%dx)
f0100769:	b2 fb                	mov    $0xfb,%dl
f010076b:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100770:	ee                   	out    %al,(%dx)
f0100771:	bb f8 03 00 00       	mov    $0x3f8,%ebx
f0100776:	b8 0c 00 00 00       	mov    $0xc,%eax
f010077b:	89 da                	mov    %ebx,%edx
f010077d:	ee                   	out    %al,(%dx)
f010077e:	b2 f9                	mov    $0xf9,%dl
f0100780:	b8 00 00 00 00       	mov    $0x0,%eax
f0100785:	ee                   	out    %al,(%dx)
f0100786:	b2 fb                	mov    $0xfb,%dl
f0100788:	b8 03 00 00 00       	mov    $0x3,%eax
f010078d:	ee                   	out    %al,(%dx)
f010078e:	b2 fc                	mov    $0xfc,%dl
f0100790:	b8 00 00 00 00       	mov    $0x0,%eax
f0100795:	ee                   	out    %al,(%dx)
f0100796:	b2 f9                	mov    $0xf9,%dl
f0100798:	b8 01 00 00 00       	mov    $0x1,%eax
f010079d:	ee                   	out    %al,(%dx)

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010079e:	b2 fd                	mov    $0xfd,%dl
f01007a0:	ec                   	in     (%dx),%al
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f01007a1:	3c ff                	cmp    $0xff,%al
f01007a3:	0f 95 c1             	setne  %cl
f01007a6:	88 0d 34 92 2c f0    	mov    %cl,0xf02c9234
f01007ac:	89 f2                	mov    %esi,%edx
f01007ae:	ec                   	in     (%dx),%al
f01007af:	89 da                	mov    %ebx,%edx
f01007b1:	ec                   	in     (%dx),%al
	(void) inb(COM1+COM_IIR);
	(void) inb(COM1+COM_RX);

	// Enable serial interrupts
	if (serial_exists)
f01007b2:	84 c9                	test   %cl,%cl
f01007b4:	74 1d                	je     f01007d3 <cons_init+0x114>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_SERIAL));
f01007b6:	0f b7 05 a8 63 12 f0 	movzwl 0xf01263a8,%eax
f01007bd:	25 ef ff 00 00       	and    $0xffef,%eax
f01007c2:	89 04 24             	mov    %eax,(%esp)
f01007c5:	e8 20 3a 00 00       	call   f01041ea <irq_setmask_8259A>
{
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f01007ca:	80 3d 34 92 2c f0 00 	cmpb   $0x0,0xf02c9234
f01007d1:	75 0c                	jne    f01007df <cons_init+0x120>
		cprintf("Serial port does not exist!\n");
f01007d3:	c7 04 24 ef 81 10 f0 	movl   $0xf01081ef,(%esp)
f01007da:	e8 63 3b 00 00       	call   f0104342 <cprintf>
}
f01007df:	83 c4 1c             	add    $0x1c,%esp
f01007e2:	5b                   	pop    %ebx
f01007e3:	5e                   	pop    %esi
f01007e4:	5f                   	pop    %edi
f01007e5:	5d                   	pop    %ebp
f01007e6:	c3                   	ret    

f01007e7 <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f01007e7:	55                   	push   %ebp
f01007e8:	89 e5                	mov    %esp,%ebp
f01007ea:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f01007ed:	8b 45 08             	mov    0x8(%ebp),%eax
f01007f0:	e8 72 fc ff ff       	call   f0100467 <cons_putc>
}
f01007f5:	c9                   	leave  
f01007f6:	c3                   	ret    

f01007f7 <getchar>:

int
getchar(void)
{
f01007f7:	55                   	push   %ebp
f01007f8:	89 e5                	mov    %esp,%ebp
f01007fa:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f01007fd:	e8 73 fe ff ff       	call   f0100675 <cons_getc>
f0100802:	85 c0                	test   %eax,%eax
f0100804:	74 f7                	je     f01007fd <getchar+0x6>
		/* do nothing */;
	return c;
}
f0100806:	c9                   	leave  
f0100807:	c3                   	ret    

f0100808 <iscons>:

int
iscons(int fdnum)
{
f0100808:	55                   	push   %ebp
f0100809:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f010080b:	b8 01 00 00 00       	mov    $0x1,%eax
f0100810:	5d                   	pop    %ebp
f0100811:	c3                   	ret    
f0100812:	66 90                	xchg   %ax,%ax
f0100814:	66 90                	xchg   %ax,%ax
f0100816:	66 90                	xchg   %ax,%ax
f0100818:	66 90                	xchg   %ax,%ax
f010081a:	66 90                	xchg   %ax,%ax
f010081c:	66 90                	xchg   %ax,%ax
f010081e:	66 90                	xchg   %ax,%ax

f0100820 <continue_exec>:
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

/***** Implementations of basic kernel monitor commands *****/
int
continue_exec(int argc, char **argv, struct Trapframe *tf)
{
f0100820:	55                   	push   %ebp
f0100821:	89 e5                	mov    %esp,%ebp
f0100823:	8b 45 10             	mov    0x10(%ebp),%eax
  tf->tf_eflags &= ~FL_TF;
f0100826:	81 60 38 ff fe ff ff 	andl   $0xfffffeff,0x38(%eax)
  return -1;
}
f010082d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100832:	5d                   	pop    %ebp
f0100833:	c3                   	ret    

f0100834 <single_step>:

int
single_step(int argc, char **argv, struct Trapframe *tf)
{
f0100834:	55                   	push   %ebp
f0100835:	89 e5                	mov    %esp,%ebp
f0100837:	8b 45 10             	mov    0x10(%ebp),%eax
  tf->tf_eflags |= FL_TF;
f010083a:	81 48 38 00 01 00 00 	orl    $0x100,0x38(%eax)
  return -1;
}
f0100841:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100846:	5d                   	pop    %ebp
f0100847:	c3                   	ret    

f0100848 <mon_help>:
    cprintf ("  %s\n", buff);
}

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100848:	55                   	push   %ebp
f0100849:	89 e5                	mov    %esp,%ebp
f010084b:	56                   	push   %esi
f010084c:	53                   	push   %ebx
f010084d:	83 ec 10             	sub    $0x10,%esp
f0100850:	bb c4 88 10 f0       	mov    $0xf01088c4,%ebx
f0100855:	be 24 89 10 f0       	mov    $0xf0108924,%esi
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f010085a:	8b 03                	mov    (%ebx),%eax
f010085c:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100860:	8b 43 fc             	mov    -0x4(%ebx),%eax
f0100863:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100867:	c7 04 24 40 84 10 f0 	movl   $0xf0108440,(%esp)
f010086e:	e8 cf 3a 00 00       	call   f0104342 <cprintf>
f0100873:	83 c3 0c             	add    $0xc,%ebx
int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
f0100876:	39 f3                	cmp    %esi,%ebx
f0100878:	75 e0                	jne    f010085a <mon_help+0x12>
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}
f010087a:	b8 00 00 00 00       	mov    $0x0,%eax
f010087f:	83 c4 10             	add    $0x10,%esp
f0100882:	5b                   	pop    %ebx
f0100883:	5e                   	pop    %esi
f0100884:	5d                   	pop    %ebp
f0100885:	c3                   	ret    

f0100886 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100886:	55                   	push   %ebp
f0100887:	89 e5                	mov    %esp,%ebp
f0100889:	83 ec 18             	sub    $0x18,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f010088c:	c7 04 24 49 84 10 f0 	movl   $0xf0108449,(%esp)
f0100893:	e8 aa 3a 00 00       	call   f0104342 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100898:	c7 44 24 04 0c 00 10 	movl   $0x10000c,0x4(%esp)
f010089f:	00 
f01008a0:	c7 04 24 f0 85 10 f0 	movl   $0xf01085f0,(%esp)
f01008a7:	e8 96 3a 00 00       	call   f0104342 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01008ac:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f01008b3:	00 
f01008b4:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f01008bb:	f0 
f01008bc:	c7 04 24 18 86 10 f0 	movl   $0xf0108618,(%esp)
f01008c3:	e8 7a 3a 00 00       	call   f0104342 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01008c8:	c7 44 24 08 07 81 10 	movl   $0x108107,0x8(%esp)
f01008cf:	00 
f01008d0:	c7 44 24 04 07 81 10 	movl   $0xf0108107,0x4(%esp)
f01008d7:	f0 
f01008d8:	c7 04 24 3c 86 10 f0 	movl   $0xf010863c,(%esp)
f01008df:	e8 5e 3a 00 00       	call   f0104342 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01008e4:	c7 44 24 08 39 87 2c 	movl   $0x2c8739,0x8(%esp)
f01008eb:	00 
f01008ec:	c7 44 24 04 39 87 2c 	movl   $0xf02c8739,0x4(%esp)
f01008f3:	f0 
f01008f4:	c7 04 24 60 86 10 f0 	movl   $0xf0108660,(%esp)
f01008fb:	e8 42 3a 00 00       	call   f0104342 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f0100900:	c7 44 24 08 40 ba 35 	movl   $0x35ba40,0x8(%esp)
f0100907:	00 
f0100908:	c7 44 24 04 40 ba 35 	movl   $0xf035ba40,0x4(%esp)
f010090f:	f0 
f0100910:	c7 04 24 84 86 10 f0 	movl   $0xf0108684,(%esp)
f0100917:	e8 26 3a 00 00       	call   f0104342 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
		ROUNDUP(end - entry, 1024) / 1024);
f010091c:	b8 3f be 35 f0       	mov    $0xf035be3f,%eax
f0100921:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
f0100926:	25 00 fc ff ff       	and    $0xfffffc00,%eax
	cprintf("  _start                  %08x (phys)\n", _start);
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
f010092b:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
f0100931:	85 c0                	test   %eax,%eax
f0100933:	0f 48 c2             	cmovs  %edx,%eax
f0100936:	c1 f8 0a             	sar    $0xa,%eax
f0100939:	89 44 24 04          	mov    %eax,0x4(%esp)
f010093d:	c7 04 24 a8 86 10 f0 	movl   $0xf01086a8,(%esp)
f0100944:	e8 f9 39 00 00       	call   f0104342 <cprintf>
		ROUNDUP(end - entry, 1024) / 1024);
	return 0;
}
f0100949:	b8 00 00 00 00       	mov    $0x0,%eax
f010094e:	c9                   	leave  
f010094f:	c3                   	ret    

f0100950 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100950:	55                   	push   %ebp
f0100951:	89 e5                	mov    %esp,%ebp
f0100953:	57                   	push   %edi
f0100954:	56                   	push   %esi
f0100955:	53                   	push   %ebx
f0100956:	83 ec 4c             	sub    $0x4c,%esp

static inline uint32_t
read_ebp(void)
{
	uint32_t ebp;
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0100959:	89 e8                	mov    %ebp,%eax
	uintptr_t *ebp = (uintptr_t *)read_ebp();
f010095b:	89 c3                	mov    %eax,%ebx
    	uintptr_t eip = ebp[1];
f010095d:	8b 70 04             	mov    0x4(%eax),%esi
    	struct Eipdebuginfo dbgInfo;
	cprintf("Stack backtrace:\n");
f0100960:	c7 04 24 62 84 10 f0 	movl   $0xf0108462,(%esp)
f0100967:	e8 d6 39 00 00       	call   f0104342 <cprintf>
	while(ebp != NULL)
	{
		cprintf("  ebp %08x eip %08x args %08x %08x %08x %08x %08x\n", ebp, eip, ebp[2], ebp[3], ebp[4], ebp[5], ebp[6]);
		debuginfo_eip((uintptr_t) eip, &dbgInfo);
f010096c:	8d 7d d0             	lea    -0x30(%ebp),%edi
{
	uintptr_t *ebp = (uintptr_t *)read_ebp();
    	uintptr_t eip = ebp[1];
    	struct Eipdebuginfo dbgInfo;
	cprintf("Stack backtrace:\n");
	while(ebp != NULL)
f010096f:	eb 70                	jmp    f01009e1 <mon_backtrace+0x91>
	{
		cprintf("  ebp %08x eip %08x args %08x %08x %08x %08x %08x\n", ebp, eip, ebp[2], ebp[3], ebp[4], ebp[5], ebp[6]);
f0100971:	8b 43 18             	mov    0x18(%ebx),%eax
f0100974:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f0100978:	8b 43 14             	mov    0x14(%ebx),%eax
f010097b:	89 44 24 18          	mov    %eax,0x18(%esp)
f010097f:	8b 43 10             	mov    0x10(%ebx),%eax
f0100982:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100986:	8b 43 0c             	mov    0xc(%ebx),%eax
f0100989:	89 44 24 10          	mov    %eax,0x10(%esp)
f010098d:	8b 43 08             	mov    0x8(%ebx),%eax
f0100990:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100994:	89 74 24 08          	mov    %esi,0x8(%esp)
f0100998:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010099c:	c7 04 24 d4 86 10 f0 	movl   $0xf01086d4,(%esp)
f01009a3:	e8 9a 39 00 00       	call   f0104342 <cprintf>
		debuginfo_eip((uintptr_t) eip, &dbgInfo);
f01009a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01009ac:	89 34 24             	mov    %esi,(%esp)
f01009af:	e8 83 53 00 00       	call   f0105d37 <debuginfo_eip>
        	cprintf("\t  %s:%u: %s+%u\n", dbgInfo.eip_file, dbgInfo.eip_line, dbgInfo.eip_fn_name, eip - dbgInfo.eip_fn_addr);
f01009b4:	2b 75 e0             	sub    -0x20(%ebp),%esi
f01009b7:	89 74 24 10          	mov    %esi,0x10(%esp)
f01009bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01009be:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01009c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01009c5:	89 44 24 08          	mov    %eax,0x8(%esp)
f01009c9:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01009cc:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009d0:	c7 04 24 74 84 10 f0 	movl   $0xf0108474,(%esp)
f01009d7:	e8 66 39 00 00       	call   f0104342 <cprintf>

        	ebp = (uintptr_t *)ebp[0];
f01009dc:	8b 1b                	mov    (%ebx),%ebx
        	eip = ebp[1];
f01009de:	8b 73 04             	mov    0x4(%ebx),%esi
{
	uintptr_t *ebp = (uintptr_t *)read_ebp();
    	uintptr_t eip = ebp[1];
    	struct Eipdebuginfo dbgInfo;
	cprintf("Stack backtrace:\n");
	while(ebp != NULL)
f01009e1:	85 db                	test   %ebx,%ebx
f01009e3:	75 8c                	jne    f0100971 <mon_backtrace+0x21>

        	ebp = (uintptr_t *)ebp[0];
        	eip = ebp[1];
	}
	return 0;
}
f01009e5:	b8 00 00 00 00       	mov    $0x0,%eax
f01009ea:	83 c4 4c             	add    $0x4c,%esp
f01009ed:	5b                   	pop    %ebx
f01009ee:	5e                   	pop    %esi
f01009ef:	5f                   	pop    %edi
f01009f0:	5d                   	pop    %ebp
f01009f1:	c3                   	ret    

f01009f2 <mon_showmappings>:

int
mon_showmappings(int argc, char **argv, struct Trapframe *tf)
{
f01009f2:	55                   	push   %ebp
f01009f3:	89 e5                	mov    %esp,%ebp
f01009f5:	57                   	push   %edi
f01009f6:	56                   	push   %esi
f01009f7:	53                   	push   %ebx
f01009f8:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
f01009fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if(argc == 1)
f0100a01:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
f0100a05:	75 16                	jne    f0100a1d <mon_showmappings+0x2b>
	{
		cprintf("Usage: showmappings <start_addr> <end_addr>\n\n");
f0100a07:	c7 04 24 08 87 10 f0 	movl   $0xf0108708,(%esp)
f0100a0e:	e8 2f 39 00 00       	call   f0104342 <cprintf>
		return -1;
f0100a13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100a18:	e9 bf 01 00 00       	jmp    f0100bdc <mon_showmappings+0x1ea>
	}

	int i;
        extern pde_t *kern_pgdir;
        cprintf("Virtual Address\tPhysical Page Mappings\tPermissions\n");
f0100a1d:	c7 04 24 38 87 10 f0 	movl   $0xf0108738,(%esp)
f0100a24:	e8 19 39 00 00       	call   f0104342 <cprintf>
        uintptr_t start = strtol(argv[1], NULL, 16);
f0100a29:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f0100a30:	00 
f0100a31:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100a38:	00 
f0100a39:	8b 43 04             	mov    0x4(%ebx),%eax
f0100a3c:	89 04 24             	mov    %eax,(%esp)
f0100a3f:	e8 9f 5e 00 00       	call   f01068e3 <strtol>
f0100a44:	89 c7                	mov    %eax,%edi
f0100a46:	89 45 8c             	mov    %eax,-0x74(%ebp)
	uintptr_t end = strtol(argv[2], NULL, 16);
f0100a49:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f0100a50:	00 
f0100a51:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100a58:	00 
f0100a59:	8b 43 08             	mov    0x8(%ebx),%eax
f0100a5c:	89 04 24             	mov    %eax,(%esp)
f0100a5f:	e8 7f 5e 00 00       	call   f01068e3 <strtol>


        for (i = 0; i <= end - start; i+=0x1000) {
f0100a64:	ba 00 00 00 00       	mov    $0x0,%edx
f0100a69:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
f0100a70:	29 f8                	sub    %edi,%eax
f0100a72:	89 45 88             	mov    %eax,-0x78(%ebp)

                uintptr_t va = start + i;
f0100a75:	03 55 8c             	add    -0x74(%ebp),%edx
f0100a78:	89 55 90             	mov    %edx,-0x70(%ebp)
                pte_t * pteP = pgdir_walk(kern_pgdir,(void*) va, false);
f0100a7b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100a82:	00 
f0100a83:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100a87:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0100a8c:	89 04 24             	mov    %eax,(%esp)
f0100a8f:	e8 0d 0b 00 00       	call   f01015a1 <pgdir_walk>


                if(pteP == NULL)
f0100a94:	85 c0                	test   %eax,%eax
f0100a96:	75 18                	jne    f0100ab0 <mon_showmappings+0xbe>
                        cprintf("0x%08x\tNone\t\t\tNULL\n", va);
f0100a98:	8b 45 90             	mov    -0x70(%ebp),%eax
f0100a9b:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100a9f:	c7 04 24 85 84 10 f0 	movl   $0xf0108485,(%esp)
f0100aa6:	e8 97 38 00 00       	call   f0104342 <cprintf>
f0100aab:	e9 10 01 00 00       	jmp    f0100bc0 <mon_showmappings+0x1ce>

                else {
                        char perm[9];

                        if(*pteP & PTE_P)
f0100ab0:	8b 00                	mov    (%eax),%eax
f0100ab2:	89 c2                	mov    %eax,%edx
f0100ab4:	83 e2 01             	and    $0x1,%edx
                                perm[0] = 'P';
f0100ab7:	83 fa 01             	cmp    $0x1,%edx
f0100aba:	19 ff                	sbb    %edi,%edi
f0100abc:	83 e7 0f             	and    $0xf,%edi
f0100abf:	83 c7 50             	add    $0x50,%edi
                        else{perm[0] = '_';};

                        if(*pteP & PTE_W)
f0100ac2:	89 c2                	mov    %eax,%edx
f0100ac4:	83 e2 02             	and    $0x2,%edx
                                 perm[1] = 'W';
f0100ac7:	83 fa 01             	cmp    $0x1,%edx
f0100aca:	19 f6                	sbb    %esi,%esi
f0100acc:	83 e6 08             	and    $0x8,%esi
f0100acf:	83 c6 57             	add    $0x57,%esi
                        else{perm[1] = '_';};

                        if(*pteP & PTE_U)
f0100ad2:	89 c2                	mov    %eax,%edx
f0100ad4:	83 e2 04             	and    $0x4,%edx
                                perm[2] = 'U';
f0100ad7:	83 fa 01             	cmp    $0x1,%edx
f0100ada:	19 db                	sbb    %ebx,%ebx
f0100adc:	89 5d 98             	mov    %ebx,-0x68(%ebp)
f0100adf:	80 65 98 0a          	andb   $0xa,-0x68(%ebp)
f0100ae3:	80 45 98 55          	addb   $0x55,-0x68(%ebp)
                        else{perm[2] = '_';};

                        if(*pteP & PTE_PWT)
f0100ae7:	89 c2                	mov    %eax,%edx
f0100ae9:	83 e2 08             	and    $0x8,%edx
                                perm[3] = 'T';
f0100aec:	83 fa 01             	cmp    $0x1,%edx
f0100aef:	19 c9                	sbb    %ecx,%ecx
f0100af1:	89 4d a8             	mov    %ecx,-0x58(%ebp)
f0100af4:	80 65 a8 0b          	andb   $0xb,-0x58(%ebp)
f0100af8:	80 45 a8 54          	addb   $0x54,-0x58(%ebp)
                        else{perm[3] = '_';};

                        if(*pteP & PTE_PCD)
f0100afc:	89 c2                	mov    %eax,%edx
f0100afe:	83 e2 10             	and    $0x10,%edx
                                 perm[4] = 'C';
f0100b01:	83 fa 01             	cmp    $0x1,%edx
f0100b04:	19 db                	sbb    %ebx,%ebx
f0100b06:	89 5d b8             	mov    %ebx,-0x48(%ebp)
f0100b09:	80 65 b8 1c          	andb   $0x1c,-0x48(%ebp)
f0100b0d:	80 45 b8 43          	addb   $0x43,-0x48(%ebp)
                        else{perm[4] = '_';};

                        if(*pteP & PTE_A)
f0100b11:	89 c2                	mov    %eax,%edx
f0100b13:	83 e2 20             	and    $0x20,%edx
                                perm[5] = 'A';
f0100b16:	83 fa 01             	cmp    $0x1,%edx
f0100b19:	19 c9                	sbb    %ecx,%ecx
f0100b1b:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f0100b1e:	80 65 c8 1e          	andb   $0x1e,-0x38(%ebp)
f0100b22:	80 45 c8 41          	addb   $0x41,-0x38(%ebp)
                        else{perm[5] = '_';};

                        if(*pteP & PTE_D)
f0100b26:	89 c2                	mov    %eax,%edx
f0100b28:	83 e2 40             	and    $0x40,%edx
                                 perm[6] = 'D';
f0100b2b:	83 fa 01             	cmp    $0x1,%edx
f0100b2e:	19 db                	sbb    %ebx,%ebx
f0100b30:	83 e3 1b             	and    $0x1b,%ebx
f0100b33:	83 c3 44             	add    $0x44,%ebx
                        else{perm[6] = '_';};

                        if(*pteP & PTE_PS)
f0100b36:	89 c2                	mov    %eax,%edx
f0100b38:	81 e2 80 00 00 00    	and    $0x80,%edx
                                perm[7] = 'S';
f0100b3e:	83 fa 01             	cmp    $0x1,%edx
f0100b41:	19 c9                	sbb    %ecx,%ecx
f0100b43:	83 e1 0c             	and    $0xc,%ecx
f0100b46:	83 c1 53             	add    $0x53,%ecx
                        else{perm[7] = '_';};

                        if(*pteP & PTE_G)
f0100b49:	89 c2                	mov    %eax,%edx
f0100b4b:	81 e2 00 01 00 00    	and    $0x100,%edx
                                 perm[8] = 'G';
f0100b51:	83 fa 01             	cmp    $0x1,%edx
f0100b54:	19 d2                	sbb    %edx,%edx
f0100b56:	89 55 d8             	mov    %edx,-0x28(%ebp)
f0100b59:	80 65 d8 18          	andb   $0x18,-0x28(%ebp)
f0100b5d:	80 45 d8 47          	addb   $0x47,-0x28(%ebp)
			else{perm[8] = '_';};
			
			cprintf("0x%08x\t0x%08x\t\t\t%c%c%c%c%c%c%c%c%c\n", va, *pteP, perm[8], perm[7], perm[6], perm[5], perm[4], perm[3], perm[2], perm[1], perm[0]);
f0100b61:	89 fa                	mov    %edi,%edx
f0100b63:	0f be fa             	movsbl %dl,%edi
f0100b66:	89 7c 24 2c          	mov    %edi,0x2c(%esp)
f0100b6a:	89 f2                	mov    %esi,%edx
f0100b6c:	0f be f2             	movsbl %dl,%esi
f0100b6f:	89 74 24 28          	mov    %esi,0x28(%esp)
f0100b73:	0f be 75 98          	movsbl -0x68(%ebp),%esi
f0100b77:	89 74 24 24          	mov    %esi,0x24(%esp)
f0100b7b:	0f be 75 a8          	movsbl -0x58(%ebp),%esi
f0100b7f:	89 74 24 20          	mov    %esi,0x20(%esp)
f0100b83:	0f be 75 b8          	movsbl -0x48(%ebp),%esi
f0100b87:	89 74 24 1c          	mov    %esi,0x1c(%esp)
f0100b8b:	0f be 75 c8          	movsbl -0x38(%ebp),%esi
f0100b8f:	89 74 24 18          	mov    %esi,0x18(%esp)
f0100b93:	0f be db             	movsbl %bl,%ebx
f0100b96:	89 5c 24 14          	mov    %ebx,0x14(%esp)
f0100b9a:	0f be c9             	movsbl %cl,%ecx
f0100b9d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0100ba1:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
f0100ba5:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100ba9:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100bad:	8b 45 90             	mov    -0x70(%ebp),%eax
f0100bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100bb4:	c7 04 24 6c 87 10 f0 	movl   $0xf010876c,(%esp)
f0100bbb:	e8 82 37 00 00       	call   f0104342 <cprintf>
        cprintf("Virtual Address\tPhysical Page Mappings\tPermissions\n");
        uintptr_t start = strtol(argv[1], NULL, 16);
	uintptr_t end = strtol(argv[2], NULL, 16);


        for (i = 0; i <= end - start; i+=0x1000) {
f0100bc0:	81 45 94 00 10 00 00 	addl   $0x1000,-0x6c(%ebp)
f0100bc7:	8b 45 94             	mov    -0x6c(%ebp),%eax
f0100bca:	89 c2                	mov    %eax,%edx
f0100bcc:	8b 4d 88             	mov    -0x78(%ebp),%ecx
f0100bcf:	39 c8                	cmp    %ecx,%eax
f0100bd1:	0f 86 9e fe ff ff    	jbe    f0100a75 <mon_showmappings+0x83>
			
			cprintf("0x%08x\t0x%08x\t\t\t%c%c%c%c%c%c%c%c%c\n", va, *pteP, perm[8], perm[7], perm[6], perm[5], perm[4], perm[3], perm[2], perm[1], perm[0]);
                }
        }

        return 0;
f0100bd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100bdc:	81 c4 9c 00 00 00    	add    $0x9c,%esp
f0100be2:	5b                   	pop    %ebx
f0100be3:	5e                   	pop    %esi
f0100be4:	5f                   	pop    %edi
f0100be5:	5d                   	pop    %ebp
f0100be6:	c3                   	ret    

f0100be7 <mon_setperms>:
        return 0;
}

int
mon_setperms(int argc, char **argv, struct Trapframe *tf)
{
f0100be7:	55                   	push   %ebp
f0100be8:	89 e5                	mov    %esp,%ebp
f0100bea:	53                   	push   %ebx
f0100beb:	83 ec 14             	sub    $0x14,%esp
f0100bee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set address new

        extern pde_t *kern_pgdir;
        uintptr_t va = strtol(argv[1], NULL, 16);
f0100bf1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f0100bf8:	00 
f0100bf9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100c00:	00 
f0100c01:	8b 43 04             	mov    0x4(%ebx),%eax
f0100c04:	89 04 24             	mov    %eax,(%esp)
f0100c07:	e8 d7 5c 00 00       	call   f01068e3 <strtol>
        int perm = *argv[2];
f0100c0c:	8b 53 08             	mov    0x8(%ebx),%edx
f0100c0f:	0f b6 1a             	movzbl (%edx),%ebx

        pte_t * pteP = pgdir_walk(kern_pgdir,(void*) va, false);
f0100c12:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100c19:	00 
f0100c1a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100c1e:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0100c23:	89 04 24             	mov    %eax,(%esp)
f0100c26:	e8 76 09 00 00       	call   f01015a1 <pgdir_walk>
{
	// set address new

        extern pde_t *kern_pgdir;
        uintptr_t va = strtol(argv[1], NULL, 16);
        int perm = *argv[2];
f0100c2b:	0f be d3             	movsbl %bl,%edx

        pte_t * pteP = pgdir_walk(kern_pgdir,(void*) va, false);

        if (perm < 0x00000FFF){
                *pteP |= perm;
f0100c2e:	89 d3                	mov    %edx,%ebx
f0100c30:	0b 18                	or     (%eax),%ebx
f0100c32:	89 18                	mov    %ebx,(%eax)
                cprintf("The page table entry pointer is now at 0x%08x\n", *pteP);
f0100c34:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100c38:	c7 04 24 90 87 10 f0 	movl   $0xf0108790,(%esp)
f0100c3f:	e8 fe 36 00 00       	call   f0104342 <cprintf>
        }
        else{cprintf("Invalid permission bit\n");};

        return 0;
}
f0100c44:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c49:	83 c4 14             	add    $0x14,%esp
f0100c4c:	5b                   	pop    %ebx
f0100c4d:	5d                   	pop    %ebp
f0100c4e:	c3                   	ret    

f0100c4f <hexdump>:
  tf->tf_eflags |= FL_TF;
  return -1;
}

void hexdump (void *addr, int len)
{
f0100c4f:	55                   	push   %ebp
f0100c50:	89 e5                	mov    %esp,%ebp
f0100c52:	57                   	push   %edi
f0100c53:	56                   	push   %esi
f0100c54:	53                   	push   %ebx
f0100c55:	83 ec 3c             	sub    $0x3c,%esp
f0100c58:	8b 7d 0c             	mov    0xc(%ebp),%edi
    int i;
    unsigned char buff[17];
    unsigned char *pc = (unsigned char*)addr;

    if (len == 0) {
f0100c5b:	85 ff                	test   %edi,%edi
f0100c5d:	75 11                	jne    f0100c70 <hexdump+0x21>
        cprintf("  ZERO LENGTH\n");
f0100c5f:	c7 04 24 b1 84 10 f0 	movl   $0xf01084b1,(%esp)
f0100c66:	e8 d7 36 00 00       	call   f0104342 <cprintf>
        return;
f0100c6b:	e9 f1 00 00 00       	jmp    f0100d61 <hexdump+0x112>
    }
    if (len < 0) {
f0100c70:	85 ff                	test   %edi,%edi
f0100c72:	78 0a                	js     f0100c7e <hexdump+0x2f>
f0100c74:	8b 75 08             	mov    0x8(%ebp),%esi
f0100c77:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100c7c:	eb 15                	jmp    f0100c93 <hexdump+0x44>
        cprintf("  NEGATIVE LENGTH: %i\n",len);
f0100c7e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100c82:	c7 04 24 c0 84 10 f0 	movl   $0xf01084c0,(%esp)
f0100c89:	e8 b4 36 00 00       	call   f0104342 <cprintf>
        return;
f0100c8e:	e9 ce 00 00 00       	jmp    f0100d61 <hexdump+0x112>

    // Process every byte in the data.
    for (i = 0; i < len; i++) {
        // Multiple of 16 means new line (with line offset).

        if ((i % 16) == 0) {
f0100c93:	f6 c3 0f             	test   $0xf,%bl
f0100c96:	75 31                	jne    f0100cc9 <hexdump+0x7a>
            // Just don't print ASCII for the zeroth line.
            if (i != 0)
f0100c98:	85 db                	test   %ebx,%ebx
f0100c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0100ca0:	74 13                	je     f0100cb5 <hexdump+0x66>
                cprintf ("  %s\n", buff);
f0100ca2:	8d 45 d7             	lea    -0x29(%ebp),%eax
f0100ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ca9:	c7 04 24 d7 84 10 f0 	movl   $0xf01084d7,(%esp)
f0100cb0:	e8 8d 36 00 00       	call   f0104342 <cprintf>

            // Output the offset.
            cprintf ("  0x%08x <+%08x>:", (addr+i), i);
f0100cb5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0100cb9:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100cbd:	c7 04 24 dd 84 10 f0 	movl   $0xf01084dd,(%esp)
f0100cc4:	e8 79 36 00 00       	call   f0104342 <cprintf>
        }

        // Now the hex code for the specific character.
        cprintf (" %02x", pc[i]);
f0100cc9:	0f b6 06             	movzbl (%esi),%eax
f0100ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100cd0:	c7 04 24 ef 84 10 f0 	movl   $0xf01084ef,(%esp)
f0100cd7:	e8 66 36 00 00       	call   f0104342 <cprintf>

        // And store a printable ASCII character for later.
        if ((pc[i] < 0x20) || (pc[i] > 0x7e))
f0100cdc:	0f b6 06             	movzbl (%esi),%eax
f0100cdf:	8d 50 e0             	lea    -0x20(%eax),%edx
f0100ce2:	80 fa 5e             	cmp    $0x5e,%dl
f0100ce5:	76 17                	jbe    f0100cfe <hexdump+0xaf>
            buff[i % 16] = '.';
f0100ce7:	89 d8                	mov    %ebx,%eax
f0100ce9:	c1 f8 1f             	sar    $0x1f,%eax
f0100cec:	c1 e8 1c             	shr    $0x1c,%eax
f0100cef:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f0100cf2:	83 e2 0f             	and    $0xf,%edx
f0100cf5:	29 c2                	sub    %eax,%edx
f0100cf7:	c6 44 15 d7 2e       	movb   $0x2e,-0x29(%ebp,%edx,1)
f0100cfc:	eb 14                	jmp    f0100d12 <hexdump+0xc3>
        else
            buff[i % 16] = pc[i];
f0100cfe:	89 da                	mov    %ebx,%edx
f0100d00:	c1 fa 1f             	sar    $0x1f,%edx
f0100d03:	c1 ea 1c             	shr    $0x1c,%edx
f0100d06:	8d 0c 13             	lea    (%ebx,%edx,1),%ecx
f0100d09:	83 e1 0f             	and    $0xf,%ecx
f0100d0c:	29 d1                	sub    %edx,%ecx
f0100d0e:	88 44 0d d7          	mov    %al,-0x29(%ebp,%ecx,1)
        buff[(i % 16) + 1] = '\0';
f0100d12:	89 d8                	mov    %ebx,%eax
f0100d14:	c1 f8 1f             	sar    $0x1f,%eax
f0100d17:	c1 e8 1c             	shr    $0x1c,%eax
f0100d1a:	8d 14 03             	lea    (%ebx,%eax,1),%edx
f0100d1d:	83 e2 0f             	and    $0xf,%edx
f0100d20:	29 c2                	sub    %eax,%edx
f0100d22:	c6 44 15 d8 00       	movb   $0x0,-0x28(%ebp,%edx,1)
        cprintf("  NEGATIVE LENGTH: %i\n",len);
        return;
    }

    // Process every byte in the data.
    for (i = 0; i < len; i++) {
f0100d27:	83 c3 01             	add    $0x1,%ebx
f0100d2a:	83 c6 01             	add    $0x1,%esi
f0100d2d:	39 df                	cmp    %ebx,%edi
f0100d2f:	0f 85 5e ff ff ff    	jne    f0100c93 <hexdump+0x44>
f0100d35:	eb 0f                	jmp    f0100d46 <hexdump+0xf7>
        buff[(i % 16) + 1] = '\0';
    }

    // Pad out last line if not exactly 16 characters.
    while ((i % 16) != 0) {
        cprintf ("   ");
f0100d37:	c7 04 24 f5 84 10 f0 	movl   $0xf01084f5,(%esp)
f0100d3e:	e8 ff 35 00 00       	call   f0104342 <cprintf>
        i++;
f0100d43:	83 c7 01             	add    $0x1,%edi
            buff[i % 16] = pc[i];
        buff[(i % 16) + 1] = '\0';
    }

    // Pad out last line if not exactly 16 characters.
    while ((i % 16) != 0) {
f0100d46:	f7 c7 0f 00 00 00    	test   $0xf,%edi
f0100d4c:	75 e9                	jne    f0100d37 <hexdump+0xe8>
        cprintf ("   ");
        i++;
    }

    // And print the final ASCII bit.
    cprintf ("  %s\n", buff);
f0100d4e:	8d 45 d7             	lea    -0x29(%ebp),%eax
f0100d51:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100d55:	c7 04 24 d7 84 10 f0 	movl   $0xf01084d7,(%esp)
f0100d5c:	e8 e1 35 00 00       	call   f0104342 <cprintf>
}
f0100d61:	83 c4 3c             	add    $0x3c,%esp
f0100d64:	5b                   	pop    %ebx
f0100d65:	5e                   	pop    %esi
f0100d66:	5f                   	pop    %edi
f0100d67:	5d                   	pop    %ebp
f0100d68:	c3                   	ret    

f0100d69 <mon_dump>:

        return 0;
}
int
mon_dump(int argc, char **argv, struct Trapframe *tf)
{
f0100d69:	55                   	push   %ebp
f0100d6a:	89 e5                	mov    %esp,%ebp
f0100d6c:	56                   	push   %esi
f0100d6d:	53                   	push   %ebx
f0100d6e:	83 ec 10             	sub    $0x10,%esp
f0100d71:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if(argc == 1)
f0100d74:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
f0100d78:	75 13                	jne    f0100d8d <mon_dump+0x24>
	{
		cprintf("Usage: dump <start_virtaddr> <end_virtaddr>\n\n");
f0100d7a:	c7 04 24 c0 87 10 f0 	movl   $0xf01087c0,(%esp)
f0100d81:	e8 bc 35 00 00       	call   f0104342 <cprintf>
		return -1;
f0100d86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100d8b:	eb 4b                	jmp    f0100dd8 <mon_dump+0x6f>
	}

	int i;
        extern pde_t *kern_pgdir;
        //cprintf("Virtual Address\tPhysical Page Mappings\tPermissions\n");
        uintptr_t start = strtol(argv[1], NULL, 16);
f0100d8d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f0100d94:	00 
f0100d95:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100d9c:	00 
f0100d9d:	8b 43 04             	mov    0x4(%ebx),%eax
f0100da0:	89 04 24             	mov    %eax,(%esp)
f0100da3:	e8 3b 5b 00 00       	call   f01068e3 <strtol>
f0100da8:	89 c6                	mov    %eax,%esi
	uintptr_t end = strtol(argv[2], NULL, 16);
f0100daa:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
f0100db1:	00 
f0100db2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100db9:	00 
f0100dba:	8b 43 08             	mov    0x8(%ebx),%eax
f0100dbd:	89 04 24             	mov    %eax,(%esp)
f0100dc0:	e8 1e 5b 00 00       	call   f01068e3 <strtol>
	int len = end - start;
f0100dc5:	29 f0                	sub    %esi,%eax
	
	hexdump((void *)start, len);
f0100dc7:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100dcb:	89 34 24             	mov    %esi,(%esp)
f0100dce:	e8 7c fe ff ff       	call   f0100c4f <hexdump>
        return 0;
f0100dd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0100dd8:	83 c4 10             	add    $0x10,%esp
f0100ddb:	5b                   	pop    %ebx
f0100ddc:	5e                   	pop    %esi
f0100ddd:	5d                   	pop    %ebp
f0100dde:	c3                   	ret    

f0100ddf <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f0100ddf:	55                   	push   %ebp
f0100de0:	89 e5                	mov    %esp,%ebp
f0100de2:	57                   	push   %edi
f0100de3:	56                   	push   %esi
f0100de4:	53                   	push   %ebx
f0100de5:	83 ec 5c             	sub    $0x5c,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f0100de8:	c7 04 24 f0 87 10 f0 	movl   $0xf01087f0,(%esp)
f0100def:	e8 4e 35 00 00       	call   f0104342 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100df4:	c7 04 24 14 88 10 f0 	movl   $0xf0108814,(%esp)
f0100dfb:	e8 42 35 00 00       	call   f0104342 <cprintf>

	if (tf != NULL)
f0100e00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100e04:	74 0b                	je     f0100e11 <monitor+0x32>
		print_trapframe(tf);
f0100e06:	8b 45 08             	mov    0x8(%ebp),%eax
f0100e09:	89 04 24             	mov    %eax,(%esp)
f0100e0c:	e8 57 3b 00 00       	call   f0104968 <print_trapframe>

	while (1) {
		buf = readline("K> ");
f0100e11:	c7 04 24 f9 84 10 f0 	movl   $0xf01084f9,(%esp)
f0100e18:	e8 33 57 00 00       	call   f0106550 <readline>
f0100e1d:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100e1f:	85 c0                	test   %eax,%eax
f0100e21:	74 ee                	je     f0100e11 <monitor+0x32>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100e23:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
f0100e2a:	be 00 00 00 00       	mov    $0x0,%esi
f0100e2f:	eb 0a                	jmp    f0100e3b <monitor+0x5c>
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f0100e31:	c6 03 00             	movb   $0x0,(%ebx)
f0100e34:	89 f7                	mov    %esi,%edi
f0100e36:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100e39:	89 fe                	mov    %edi,%esi
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100e3b:	0f b6 03             	movzbl (%ebx),%eax
f0100e3e:	84 c0                	test   %al,%al
f0100e40:	74 63                	je     f0100ea5 <monitor+0xc6>
f0100e42:	0f be c0             	movsbl %al,%eax
f0100e45:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100e49:	c7 04 24 fd 84 10 f0 	movl   $0xf01084fd,(%esp)
f0100e50:	e8 25 59 00 00       	call   f010677a <strchr>
f0100e55:	85 c0                	test   %eax,%eax
f0100e57:	75 d8                	jne    f0100e31 <monitor+0x52>
			*buf++ = 0;
		if (*buf == 0)
f0100e59:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100e5c:	74 47                	je     f0100ea5 <monitor+0xc6>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f0100e5e:	83 fe 0f             	cmp    $0xf,%esi
f0100e61:	75 16                	jne    f0100e79 <monitor+0x9a>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100e63:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f0100e6a:	00 
f0100e6b:	c7 04 24 02 85 10 f0 	movl   $0xf0108502,(%esp)
f0100e72:	e8 cb 34 00 00       	call   f0104342 <cprintf>
f0100e77:	eb 98                	jmp    f0100e11 <monitor+0x32>
			return 0;
		}
		argv[argc++] = buf;
f0100e79:	8d 7e 01             	lea    0x1(%esi),%edi
f0100e7c:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f0100e80:	eb 03                	jmp    f0100e85 <monitor+0xa6>
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
f0100e82:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f0100e85:	0f b6 03             	movzbl (%ebx),%eax
f0100e88:	84 c0                	test   %al,%al
f0100e8a:	74 ad                	je     f0100e39 <monitor+0x5a>
f0100e8c:	0f be c0             	movsbl %al,%eax
f0100e8f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100e93:	c7 04 24 fd 84 10 f0 	movl   $0xf01084fd,(%esp)
f0100e9a:	e8 db 58 00 00       	call   f010677a <strchr>
f0100e9f:	85 c0                	test   %eax,%eax
f0100ea1:	74 df                	je     f0100e82 <monitor+0xa3>
f0100ea3:	eb 94                	jmp    f0100e39 <monitor+0x5a>
			buf++;
	}
	argv[argc] = 0;
f0100ea5:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100eac:	00 

	// Lookup and invoke the command
	if (argc == 0)
f0100ead:	85 f6                	test   %esi,%esi
f0100eaf:	0f 84 5c ff ff ff    	je     f0100e11 <monitor+0x32>
f0100eb5:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100eba:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f0100ebd:	8b 04 85 c0 88 10 f0 	mov    -0xfef7740(,%eax,4),%eax
f0100ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ec8:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100ecb:	89 04 24             	mov    %eax,(%esp)
f0100ece:	e8 49 58 00 00       	call   f010671c <strcmp>
f0100ed3:	85 c0                	test   %eax,%eax
f0100ed5:	75 24                	jne    f0100efb <monitor+0x11c>
			return commands[i].func(argc, argv, tf);
f0100ed7:	8d 04 5b             	lea    (%ebx,%ebx,2),%eax
f0100eda:	8b 55 08             	mov    0x8(%ebp),%edx
f0100edd:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100ee1:	8d 4d a8             	lea    -0x58(%ebp),%ecx
f0100ee4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0100ee8:	89 34 24             	mov    %esi,(%esp)
f0100eeb:	ff 14 85 c8 88 10 f0 	call   *-0xfef7738(,%eax,4)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
f0100ef2:	85 c0                	test   %eax,%eax
f0100ef4:	78 25                	js     f0100f1b <monitor+0x13c>
f0100ef6:	e9 16 ff ff ff       	jmp    f0100e11 <monitor+0x32>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100efb:	83 c3 01             	add    $0x1,%ebx
f0100efe:	83 fb 08             	cmp    $0x8,%ebx
f0100f01:	75 b7                	jne    f0100eba <monitor+0xdb>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100f03:	8b 45 a8             	mov    -0x58(%ebp),%eax
f0100f06:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100f0a:	c7 04 24 1f 85 10 f0 	movl   $0xf010851f,(%esp)
f0100f11:	e8 2c 34 00 00       	call   f0104342 <cprintf>
f0100f16:	e9 f6 fe ff ff       	jmp    f0100e11 <monitor+0x32>
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
f0100f1b:	83 c4 5c             	add    $0x5c,%esp
f0100f1e:	5b                   	pop    %ebx
f0100f1f:	5e                   	pop    %esi
f0100f20:	5f                   	pop    %edi
f0100f21:	5d                   	pop    %ebp
f0100f22:	c3                   	ret    
f0100f23:	66 90                	xchg   %ax,%ax
f0100f25:	66 90                	xchg   %ax,%ax
f0100f27:	66 90                	xchg   %ax,%ax
f0100f29:	66 90                	xchg   %ax,%ax
f0100f2b:	66 90                	xchg   %ax,%ax
f0100f2d:	66 90                	xchg   %ax,%ax
f0100f2f:	90                   	nop

f0100f30 <boot_alloc>:
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f0100f30:	55                   	push   %ebp
f0100f31:	89 e5                	mov    %esp,%ebp
f0100f33:	53                   	push   %ebx
f0100f34:	83 ec 24             	sub    $0x24,%esp
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100f37:	83 3d 38 92 2c f0 00 	cmpl   $0x0,0xf02c9238
f0100f3e:	75 11                	jne    f0100f51 <boot_alloc+0x21>
		extern char end[];
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100f40:	ba 3f ca 35 f0       	mov    $0xf035ca3f,%edx
f0100f45:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100f4b:	89 15 38 92 2c f0    	mov    %edx,0xf02c9238
	}

	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
  	result = nextfree;
f0100f51:	8b 0d 38 92 2c f0    	mov    0xf02c9238,%ecx
  	nextfree = ROUNDUP(nextfree + n, PGSIZE);
f0100f57:	8d 94 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%edx
f0100f5e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100f64:	89 15 38 92 2c f0    	mov    %edx,0xf02c9238

	if ((uint32_t) nextfree - KERNBASE > (npages * PGSIZE))
f0100f6a:	a1 94 9e 2c f0       	mov    0xf02c9e94,%eax
f0100f6f:	c1 e0 0c             	shl    $0xc,%eax
f0100f72:	8d 9a 00 00 00 10    	lea    0x10000000(%edx),%ebx
f0100f78:	39 c3                	cmp    %eax,%ebx
f0100f7a:	76 2a                	jbe    f0100fa6 <boot_alloc+0x76>
		panic("Cannot allocate any more physical memory. Requested %uK, available %uK.\n",
f0100f7c:	c1 e8 0a             	shr    $0xa,%eax
f0100f7f:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100f83:	c1 ea 0a             	shr    $0xa,%edx
f0100f86:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100f8a:	c7 44 24 08 20 89 10 	movl   $0xf0108920,0x8(%esp)
f0100f91:	f0 
f0100f92:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
f0100f99:	00 
f0100f9a:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0100fa1:	e8 9a f0 ff ff       	call   f0100040 <_panic>
			(uint32_t) nextfree / 1024, npages * PGSIZE / 1024);
  
	return result;
}
f0100fa6:	89 c8                	mov    %ecx,%eax
f0100fa8:	83 c4 24             	add    $0x24,%esp
f0100fab:	5b                   	pop    %ebx
f0100fac:	5d                   	pop    %ebp
f0100fad:	c3                   	ret    

f0100fae <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100fae:	89 d1                	mov    %edx,%ecx
f0100fb0:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100fb3:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100fb6:	a8 01                	test   $0x1,%al
f0100fb8:	74 5d                	je     f0101017 <check_va2pa+0x69>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100fba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100fbf:	89 c1                	mov    %eax,%ecx
f0100fc1:	c1 e9 0c             	shr    $0xc,%ecx
f0100fc4:	3b 0d 94 9e 2c f0    	cmp    0xf02c9e94,%ecx
f0100fca:	72 26                	jb     f0100ff2 <check_va2pa+0x44>
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0100fcc:	55                   	push   %ebp
f0100fcd:	89 e5                	mov    %esp,%ebp
f0100fcf:	83 ec 18             	sub    $0x18,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100fd2:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100fd6:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0100fdd:	f0 
f0100fde:	c7 44 24 04 83 03 00 	movl   $0x383,0x4(%esp)
f0100fe5:	00 
f0100fe6:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0100fed:	e8 4e f0 ff ff       	call   f0100040 <_panic>

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
	if (!(p[PTX(va)] & PTE_P))
f0100ff2:	c1 ea 0c             	shr    $0xc,%edx
f0100ff5:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100ffb:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0101002:	89 c2                	mov    %eax,%edx
f0101004:	83 e2 01             	and    $0x1,%edx
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0101007:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010100c:	85 d2                	test   %edx,%edx
f010100e:	ba ff ff ff ff       	mov    $0xffffffff,%edx
f0101013:	0f 44 c2             	cmove  %edx,%eax
f0101016:	c3                   	ret    
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
f0101017:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
	if (!(p[PTX(va)] & PTE_P))
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
}
f010101c:	c3                   	ret    

f010101d <check_page_free_list>:
//
// Check that the pages on the page_free_list are reasonable.
//
static void
check_page_free_list(bool only_low_memory)
{
f010101d:	55                   	push   %ebp
f010101e:	89 e5                	mov    %esp,%ebp
f0101020:	57                   	push   %edi
f0101021:	56                   	push   %esi
f0101022:	53                   	push   %ebx
f0101023:	83 ec 4c             	sub    $0x4c,%esp
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101026:	84 c0                	test   %al,%al
f0101028:	0f 85 31 03 00 00    	jne    f010135f <check_page_free_list+0x342>
f010102e:	e9 3e 03 00 00       	jmp    f0101371 <check_page_free_list+0x354>
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
		panic("'page_free_list' is a null pointer!");
f0101033:	c7 44 24 08 6c 89 10 	movl   $0xf010896c,0x8(%esp)
f010103a:	f0 
f010103b:	c7 44 24 04 b8 02 00 	movl   $0x2b8,0x4(%esp)
f0101042:	00 
f0101043:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010104a:	e8 f1 ef ff ff       	call   f0100040 <_panic>

	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f010104f:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0101052:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0101055:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0101058:	89 55 e4             	mov    %edx,-0x1c(%ebp)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f010105b:	89 c2                	mov    %eax,%edx
f010105d:	2b 15 9c 9e 2c f0    	sub    0xf02c9e9c,%edx
		for (pp = page_free_list; pp; pp = pp->pp_link) {
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0101063:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0101069:	0f 95 c2             	setne  %dl
f010106c:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f010106f:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0101073:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0101075:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101079:	8b 00                	mov    (%eax),%eax
f010107b:	85 c0                	test   %eax,%eax
f010107d:	75 dc                	jne    f010105b <check_page_free_list+0x3e>
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
			*tp[pagetype] = pp;
			tp[pagetype] = &pp->pp_link;
		}
		*tp[1] = 0;
f010107f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101082:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0101088:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010108b:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010108e:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0101090:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101093:	a3 40 92 2c f0       	mov    %eax,0xf02c9240
//
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0101098:	be 01 00 00 00       	mov    $0x1,%esi
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f010109d:	8b 1d 40 92 2c f0    	mov    0xf02c9240,%ebx
f01010a3:	eb 63                	jmp    f0101108 <check_page_free_list+0xeb>
f01010a5:	89 d8                	mov    %ebx,%eax
f01010a7:	2b 05 9c 9e 2c f0    	sub    0xf02c9e9c,%eax
f01010ad:	c1 f8 03             	sar    $0x3,%eax
f01010b0:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f01010b3:	89 c2                	mov    %eax,%edx
f01010b5:	c1 ea 16             	shr    $0x16,%edx
f01010b8:	39 f2                	cmp    %esi,%edx
f01010ba:	73 4a                	jae    f0101106 <check_page_free_list+0xe9>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01010bc:	89 c2                	mov    %eax,%edx
f01010be:	c1 ea 0c             	shr    $0xc,%edx
f01010c1:	3b 15 94 9e 2c f0    	cmp    0xf02c9e94,%edx
f01010c7:	72 20                	jb     f01010e9 <check_page_free_list+0xcc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01010c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01010cd:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f01010d4:	f0 
f01010d5:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f01010dc:	00 
f01010dd:	c7 04 24 b1 92 10 f0 	movl   $0xf01092b1,(%esp)
f01010e4:	e8 57 ef ff ff       	call   f0100040 <_panic>
			memset(page2kva(pp), 0x97, 128);
f01010e9:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
f01010f0:	00 
f01010f1:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
f01010f8:	00 
	return (void *)(pa + KERNBASE);
f01010f9:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01010fe:	89 04 24             	mov    %eax,(%esp)
f0101101:	e8 b1 56 00 00       	call   f01067b7 <memset>
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101106:	8b 1b                	mov    (%ebx),%ebx
f0101108:	85 db                	test   %ebx,%ebx
f010110a:	75 99                	jne    f01010a5 <check_page_free_list+0x88>
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f010110c:	b8 00 00 00 00       	mov    $0x0,%eax
f0101111:	e8 1a fe ff ff       	call   f0100f30 <boot_alloc>
f0101116:	89 45 c8             	mov    %eax,-0x38(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101119:	8b 15 40 92 2c f0    	mov    0xf02c9240,%edx
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f010111f:	8b 0d 9c 9e 2c f0    	mov    0xf02c9e9c,%ecx
		assert(pp < pages + npages);
f0101125:	a1 94 9e 2c f0       	mov    0xf02c9e94,%eax
f010112a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f010112d:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
f0101130:	89 45 d0             	mov    %eax,-0x30(%ebp)
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0101133:	89 4d cc             	mov    %ecx,-0x34(%ebp)
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
f0101136:	bf 00 00 00 00       	mov    $0x0,%edi
f010113b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f010113e:	e9 c4 01 00 00       	jmp    f0101307 <check_page_free_list+0x2ea>
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f0101143:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
f0101146:	73 24                	jae    f010116c <check_page_free_list+0x14f>
f0101148:	c7 44 24 0c bf 92 10 	movl   $0xf01092bf,0xc(%esp)
f010114f:	f0 
f0101150:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101157:	f0 
f0101158:	c7 44 24 04 d2 02 00 	movl   $0x2d2,0x4(%esp)
f010115f:	00 
f0101160:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101167:	e8 d4 ee ff ff       	call   f0100040 <_panic>
		assert(pp < pages + npages);
f010116c:	3b 55 d0             	cmp    -0x30(%ebp),%edx
f010116f:	72 24                	jb     f0101195 <check_page_free_list+0x178>
f0101171:	c7 44 24 0c e0 92 10 	movl   $0xf01092e0,0xc(%esp)
f0101178:	f0 
f0101179:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101180:	f0 
f0101181:	c7 44 24 04 d3 02 00 	movl   $0x2d3,0x4(%esp)
f0101188:	00 
f0101189:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101190:	e8 ab ee ff ff       	call   f0100040 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0101195:	89 d0                	mov    %edx,%eax
f0101197:	2b 45 cc             	sub    -0x34(%ebp),%eax
f010119a:	a8 07                	test   $0x7,%al
f010119c:	74 24                	je     f01011c2 <check_page_free_list+0x1a5>
f010119e:	c7 44 24 0c 90 89 10 	movl   $0xf0108990,0xc(%esp)
f01011a5:	f0 
f01011a6:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01011ad:	f0 
f01011ae:	c7 44 24 04 d4 02 00 	movl   $0x2d4,0x4(%esp)
f01011b5:	00 
f01011b6:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01011bd:	e8 7e ee ff ff       	call   f0100040 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01011c2:	c1 f8 03             	sar    $0x3,%eax
f01011c5:	c1 e0 0c             	shl    $0xc,%eax

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f01011c8:	85 c0                	test   %eax,%eax
f01011ca:	75 24                	jne    f01011f0 <check_page_free_list+0x1d3>
f01011cc:	c7 44 24 0c f4 92 10 	movl   $0xf01092f4,0xc(%esp)
f01011d3:	f0 
f01011d4:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01011db:	f0 
f01011dc:	c7 44 24 04 d7 02 00 	movl   $0x2d7,0x4(%esp)
f01011e3:	00 
f01011e4:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01011eb:	e8 50 ee ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f01011f0:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f01011f5:	75 24                	jne    f010121b <check_page_free_list+0x1fe>
f01011f7:	c7 44 24 0c 05 93 10 	movl   $0xf0109305,0xc(%esp)
f01011fe:	f0 
f01011ff:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101206:	f0 
f0101207:	c7 44 24 04 d8 02 00 	movl   $0x2d8,0x4(%esp)
f010120e:	00 
f010120f:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101216:	e8 25 ee ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f010121b:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0101220:	75 24                	jne    f0101246 <check_page_free_list+0x229>
f0101222:	c7 44 24 0c c4 89 10 	movl   $0xf01089c4,0xc(%esp)
f0101229:	f0 
f010122a:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101231:	f0 
f0101232:	c7 44 24 04 d9 02 00 	movl   $0x2d9,0x4(%esp)
f0101239:	00 
f010123a:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101241:	e8 fa ed ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0101246:	3d 00 00 10 00       	cmp    $0x100000,%eax
f010124b:	75 24                	jne    f0101271 <check_page_free_list+0x254>
f010124d:	c7 44 24 0c 1e 93 10 	movl   $0xf010931e,0xc(%esp)
f0101254:	f0 
f0101255:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010125c:	f0 
f010125d:	c7 44 24 04 da 02 00 	movl   $0x2da,0x4(%esp)
f0101264:	00 
f0101265:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010126c:	e8 cf ed ff ff       	call   f0100040 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0101271:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0101276:	0f 86 1c 01 00 00    	jbe    f0101398 <check_page_free_list+0x37b>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f010127c:	89 c1                	mov    %eax,%ecx
f010127e:	c1 e9 0c             	shr    $0xc,%ecx
f0101281:	39 4d c4             	cmp    %ecx,-0x3c(%ebp)
f0101284:	77 20                	ja     f01012a6 <check_page_free_list+0x289>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101286:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010128a:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0101291:	f0 
f0101292:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0101299:	00 
f010129a:	c7 04 24 b1 92 10 f0 	movl   $0xf01092b1,(%esp)
f01012a1:	e8 9a ed ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f01012a6:	8d 88 00 00 00 f0    	lea    -0x10000000(%eax),%ecx
f01012ac:	39 4d c8             	cmp    %ecx,-0x38(%ebp)
f01012af:	0f 86 d3 00 00 00    	jbe    f0101388 <check_page_free_list+0x36b>
f01012b5:	c7 44 24 0c e8 89 10 	movl   $0xf01089e8,0xc(%esp)
f01012bc:	f0 
f01012bd:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01012c4:	f0 
f01012c5:	c7 44 24 04 db 02 00 	movl   $0x2db,0x4(%esp)
f01012cc:	00 
f01012cd:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01012d4:	e8 67 ed ff ff       	call   f0100040 <_panic>
		// (new test for lab 4)
		assert(page2pa(pp) != MPENTRY_PADDR);
f01012d9:	c7 44 24 0c 38 93 10 	movl   $0xf0109338,0xc(%esp)
f01012e0:	f0 
f01012e1:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01012e8:	f0 
f01012e9:	c7 44 24 04 dd 02 00 	movl   $0x2dd,0x4(%esp)
f01012f0:	00 
f01012f1:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01012f8:	e8 43 ed ff ff       	call   f0100040 <_panic>

		if (page2pa(pp) < EXTPHYSMEM)
			++nfree_basemem;
f01012fd:	83 c3 01             	add    $0x1,%ebx
f0101300:	eb 03                	jmp    f0101305 <check_page_free_list+0x2e8>
		else
			++nfree_extmem;
f0101302:	83 c7 01             	add    $0x1,%edi
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0101305:	8b 12                	mov    (%edx),%edx
f0101307:	85 d2                	test   %edx,%edx
f0101309:	0f 85 34 fe ff ff    	jne    f0101143 <check_page_free_list+0x126>
			++nfree_basemem;
		else
			++nfree_extmem;
	}

	assert(nfree_basemem > 0);
f010130f:	85 db                	test   %ebx,%ebx
f0101311:	7f 24                	jg     f0101337 <check_page_free_list+0x31a>
f0101313:	c7 44 24 0c 55 93 10 	movl   $0xf0109355,0xc(%esp)
f010131a:	f0 
f010131b:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101322:	f0 
f0101323:	c7 44 24 04 e5 02 00 	movl   $0x2e5,0x4(%esp)
f010132a:	00 
f010132b:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101332:	e8 09 ed ff ff       	call   f0100040 <_panic>
	assert(nfree_extmem > 0);
f0101337:	85 ff                	test   %edi,%edi
f0101339:	7f 6d                	jg     f01013a8 <check_page_free_list+0x38b>
f010133b:	c7 44 24 0c 67 93 10 	movl   $0xf0109367,0xc(%esp)
f0101342:	f0 
f0101343:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010134a:	f0 
f010134b:	c7 44 24 04 e6 02 00 	movl   $0x2e6,0x4(%esp)
f0101352:	00 
f0101353:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010135a:	e8 e1 ec ff ff       	call   f0100040 <_panic>
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
f010135f:	a1 40 92 2c f0       	mov    0xf02c9240,%eax
f0101364:	85 c0                	test   %eax,%eax
f0101366:	0f 85 e3 fc ff ff    	jne    f010104f <check_page_free_list+0x32>
f010136c:	e9 c2 fc ff ff       	jmp    f0101033 <check_page_free_list+0x16>
f0101371:	83 3d 40 92 2c f0 00 	cmpl   $0x0,0xf02c9240
f0101378:	0f 84 b5 fc ff ff    	je     f0101033 <check_page_free_list+0x16>
//
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f010137e:	be 00 04 00 00       	mov    $0x400,%esi
f0101383:	e9 15 fd ff ff       	jmp    f010109d <check_page_free_list+0x80>
		assert(page2pa(pp) != IOPHYSMEM);
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
		assert(page2pa(pp) != EXTPHYSMEM);
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
		// (new test for lab 4)
		assert(page2pa(pp) != MPENTRY_PADDR);
f0101388:	3d 00 70 00 00       	cmp    $0x7000,%eax
f010138d:	0f 85 6f ff ff ff    	jne    f0101302 <check_page_free_list+0x2e5>
f0101393:	e9 41 ff ff ff       	jmp    f01012d9 <check_page_free_list+0x2bc>
f0101398:	3d 00 70 00 00       	cmp    $0x7000,%eax
f010139d:	0f 85 5a ff ff ff    	jne    f01012fd <check_page_free_list+0x2e0>
f01013a3:	e9 31 ff ff ff       	jmp    f01012d9 <check_page_free_list+0x2bc>
			++nfree_extmem;
	}

	assert(nfree_basemem > 0);
	assert(nfree_extmem > 0);
}
f01013a8:	83 c4 4c             	add    $0x4c,%esp
f01013ab:	5b                   	pop    %ebx
f01013ac:	5e                   	pop    %esi
f01013ad:	5f                   	pop    %edi
f01013ae:	5d                   	pop    %ebp
f01013af:	c3                   	ret    

f01013b0 <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f01013b0:	55                   	push   %ebp
f01013b1:	89 e5                	mov    %esp,%ebp
f01013b3:	57                   	push   %edi
f01013b4:	56                   	push   %esi
f01013b5:	53                   	push   %ebx
f01013b6:	83 ec 1c             	sub    $0x1c,%esp
	//     page tables and other data structures?
	//
	// Change the code to reflect this.
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
 	page_free_list = NULL;
f01013b9:	c7 05 40 92 2c f0 00 	movl   $0x0,0xf02c9240
f01013c0:	00 00 00 
  	uint32_t num_kpages = (((uint32_t) boot_alloc(0)) - KERNBASE) / PGSIZE;
f01013c3:	b8 00 00 00 00       	mov    $0x0,%eax
f01013c8:	e8 63 fb ff ff       	call   f0100f30 <boot_alloc>
f01013cd:	05 00 00 00 10       	add    $0x10000000,%eax
f01013d2:	c1 e8 0c             	shr    $0xc,%eax
	size_t i;
	for (i = 0; i < npages; i++) {
		if (i == 0 || // First page reserved for BIOS structures
				i == PGNUM(MPENTRY_PADDR) || // 7th page at MPRENTRY_PADDR, reserved for CPU startup code
				// Pages used up by the IO hole from 640K to 1MB
				(npages_basemem <= i && i < npages_basemem + num_pages_io_hole) ||
f01013d5:	8b 35 44 92 2c f0    	mov    0xf02c9244,%esi
f01013db:	8d 7e 60             	lea    0x60(%esi),%edi
f01013de:	8b 1d 40 92 2c f0    	mov    0xf02c9240,%ebx
	// free pages!
 	page_free_list = NULL;
  	uint32_t num_kpages = (((uint32_t) boot_alloc(0)) - KERNBASE) / PGSIZE;
  	uint32_t num_pages_io_hole = 96;
	size_t i;
	for (i = 0; i < npages; i++) {
f01013e4:	ba 00 00 00 00       	mov    $0x0,%edx
				// Pages used up by the IO hole from 640K to 1MB
				(npages_basemem <= i && i < npages_basemem + num_pages_io_hole) ||
				// Pages used up by the kernel and allocated to hold a page dir and
				// the pages array
				(npages_basemem + num_pages_io_hole <= i && \
				i < npages_basemem + num_pages_io_hole + num_kpages)
f01013e9:	01 f8                	add    %edi,%eax
f01013eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	// free pages!
 	page_free_list = NULL;
  	uint32_t num_kpages = (((uint32_t) boot_alloc(0)) - KERNBASE) / PGSIZE;
  	uint32_t num_pages_io_hole = 96;
	size_t i;
	for (i = 0; i < npages; i++) {
f01013ee:	eb 52                	jmp    f0101442 <page_init+0x92>
		if (i == 0 || // First page reserved for BIOS structures
f01013f0:	83 fa 07             	cmp    $0x7,%edx
f01013f3:	74 1d                	je     f0101412 <page_init+0x62>
f01013f5:	85 d2                	test   %edx,%edx
f01013f7:	74 19                	je     f0101412 <page_init+0x62>
				i == PGNUM(MPENTRY_PADDR) || // 7th page at MPRENTRY_PADDR, reserved for CPU startup code
f01013f9:	39 f2                	cmp    %esi,%edx
f01013fb:	72 07                	jb     f0101404 <page_init+0x54>
				// Pages used up by the IO hole from 640K to 1MB
				(npages_basemem <= i && i < npages_basemem + num_pages_io_hole) ||
f01013fd:	39 fa                	cmp    %edi,%edx
f01013ff:	90                   	nop
f0101400:	72 10                	jb     f0101412 <page_init+0x62>
f0101402:	eb 04                	jmp    f0101408 <page_init+0x58>
f0101404:	39 fa                	cmp    %edi,%edx
f0101406:	72 18                	jb     f0101420 <page_init+0x70>
				// Pages used up by the kernel and allocated to hold a page dir and
				// the pages array
				(npages_basemem + num_pages_io_hole <= i && \
f0101408:	3b 55 e4             	cmp    -0x1c(%ebp),%edx
f010140b:	90                   	nop
f010140c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101410:	73 0e                	jae    f0101420 <page_init+0x70>
				i < npages_basemem + num_pages_io_hole + num_kpages)
			) {

			pages[i].pp_ref = 1;
f0101412:	a1 9c 9e 2c f0       	mov    0xf02c9e9c,%eax
f0101417:	66 c7 44 d0 04 01 00 	movw   $0x1,0x4(%eax,%edx,8)
			continue;
f010141e:	eb 1f                	jmp    f010143f <page_init+0x8f>
f0101420:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
    	}
		pages[i].pp_ref = 0;
f0101427:	89 c1                	mov    %eax,%ecx
f0101429:	03 0d 9c 9e 2c f0    	add    0xf02c9e9c,%ecx
f010142f:	66 c7 41 04 00 00    	movw   $0x0,0x4(%ecx)
		pages[i].pp_link = page_free_list;
f0101435:	89 19                	mov    %ebx,(%ecx)
		page_free_list = &pages[i];
f0101437:	03 05 9c 9e 2c f0    	add    0xf02c9e9c,%eax
f010143d:	89 c3                	mov    %eax,%ebx
	// free pages!
 	page_free_list = NULL;
  	uint32_t num_kpages = (((uint32_t) boot_alloc(0)) - KERNBASE) / PGSIZE;
  	uint32_t num_pages_io_hole = 96;
	size_t i;
	for (i = 0; i < npages; i++) {
f010143f:	83 c2 01             	add    $0x1,%edx
f0101442:	3b 15 94 9e 2c f0    	cmp    0xf02c9e94,%edx
f0101448:	72 a6                	jb     f01013f0 <page_init+0x40>
f010144a:	89 1d 40 92 2c f0    	mov    %ebx,0xf02c9240
    	}
		pages[i].pp_ref = 0;
		pages[i].pp_link = page_free_list;
		page_free_list = &pages[i];
	}
}
f0101450:	83 c4 1c             	add    $0x1c,%esp
f0101453:	5b                   	pop    %ebx
f0101454:	5e                   	pop    %esi
f0101455:	5f                   	pop    %edi
f0101456:	5d                   	pop    %ebp
f0101457:	c3                   	ret    

f0101458 <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
f0101458:	55                   	push   %ebp
f0101459:	89 e5                	mov    %esp,%ebp
f010145b:	53                   	push   %ebx
f010145c:	83 ec 14             	sub    $0x14,%esp
	struct PageInfo *pp;
	if (page_free_list == NULL)
f010145f:	8b 1d 40 92 2c f0    	mov    0xf02c9240,%ebx
f0101465:	85 db                	test   %ebx,%ebx
f0101467:	0f 84 9a 00 00 00    	je     f0101507 <page_alloc+0xaf>
		return NULL;

  	pp = page_free_list;
  	assert(pp->pp_ref == 0);
f010146d:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0101472:	74 24                	je     f0101498 <page_alloc+0x40>
f0101474:	c7 44 24 0c 78 93 10 	movl   $0xf0109378,0xc(%esp)
f010147b:	f0 
f010147c:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101483:	f0 
f0101484:	c7 44 24 04 66 01 00 	movl   $0x166,0x4(%esp)
f010148b:	00 
f010148c:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101493:	e8 a8 eb ff ff       	call   f0100040 <_panic>
  	page_free_list = pp->pp_link;
f0101498:	8b 03                	mov    (%ebx),%eax
f010149a:	a3 40 92 2c f0       	mov    %eax,0xf02c9240
  	pp->pp_link = NULL;
f010149f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

	if (alloc_flags & ALLOC_ZERO)
		memset(page2kva(pp), 0, PGSIZE); 

  	return pp;
f01014a5:	89 d8                	mov    %ebx,%eax
  	pp = page_free_list;
  	assert(pp->pp_ref == 0);
  	page_free_list = pp->pp_link;
  	pp->pp_link = NULL;

	if (alloc_flags & ALLOC_ZERO)
f01014a7:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f01014ab:	74 5f                	je     f010150c <page_alloc+0xb4>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01014ad:	2b 05 9c 9e 2c f0    	sub    0xf02c9e9c,%eax
f01014b3:	c1 f8 03             	sar    $0x3,%eax
f01014b6:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01014b9:	89 c2                	mov    %eax,%edx
f01014bb:	c1 ea 0c             	shr    $0xc,%edx
f01014be:	3b 15 94 9e 2c f0    	cmp    0xf02c9e94,%edx
f01014c4:	72 20                	jb     f01014e6 <page_alloc+0x8e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01014c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01014ca:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f01014d1:	f0 
f01014d2:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f01014d9:	00 
f01014da:	c7 04 24 b1 92 10 f0 	movl   $0xf01092b1,(%esp)
f01014e1:	e8 5a eb ff ff       	call   f0100040 <_panic>
		memset(page2kva(pp), 0, PGSIZE); 
f01014e6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01014ed:	00 
f01014ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01014f5:	00 
	return (void *)(pa + KERNBASE);
f01014f6:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01014fb:	89 04 24             	mov    %eax,(%esp)
f01014fe:	e8 b4 52 00 00       	call   f01067b7 <memset>

  	return pp;
f0101503:	89 d8                	mov    %ebx,%eax
f0101505:	eb 05                	jmp    f010150c <page_alloc+0xb4>
struct PageInfo *
page_alloc(int alloc_flags)
{
	struct PageInfo *pp;
	if (page_free_list == NULL)
		return NULL;
f0101507:	b8 00 00 00 00       	mov    $0x0,%eax

	if (alloc_flags & ALLOC_ZERO)
		memset(page2kva(pp), 0, PGSIZE); 

  	return pp;
}
f010150c:	83 c4 14             	add    $0x14,%esp
f010150f:	5b                   	pop    %ebx
f0101510:	5d                   	pop    %ebp
f0101511:	c3                   	ret    

f0101512 <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
f0101512:	55                   	push   %ebp
f0101513:	89 e5                	mov    %esp,%ebp
f0101515:	83 ec 18             	sub    $0x18,%esp
f0101518:	8b 45 08             	mov    0x8(%ebp),%eax
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
  	assert(pp->pp_ref == 0);
f010151b:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0101520:	74 24                	je     f0101546 <page_free+0x34>
f0101522:	c7 44 24 0c 78 93 10 	movl   $0xf0109378,0xc(%esp)
f0101529:	f0 
f010152a:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101531:	f0 
f0101532:	c7 44 24 04 7a 01 00 	movl   $0x17a,0x4(%esp)
f0101539:	00 
f010153a:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101541:	e8 fa ea ff ff       	call   f0100040 <_panic>
  	assert(pp->pp_link == NULL);
f0101546:	83 38 00             	cmpl   $0x0,(%eax)
f0101549:	74 24                	je     f010156f <page_free+0x5d>
f010154b:	c7 44 24 0c 88 93 10 	movl   $0xf0109388,0xc(%esp)
f0101552:	f0 
f0101553:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010155a:	f0 
f010155b:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
f0101562:	00 
f0101563:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010156a:	e8 d1 ea ff ff       	call   f0100040 <_panic>

  	pp->pp_link = page_free_list;
f010156f:	8b 15 40 92 2c f0    	mov    0xf02c9240,%edx
f0101575:	89 10                	mov    %edx,(%eax)
  	page_free_list = pp;
f0101577:	a3 40 92 2c f0       	mov    %eax,0xf02c9240
}
f010157c:	c9                   	leave  
f010157d:	c3                   	ret    

f010157e <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
f010157e:	55                   	push   %ebp
f010157f:	89 e5                	mov    %esp,%ebp
f0101581:	83 ec 18             	sub    $0x18,%esp
f0101584:	8b 45 08             	mov    0x8(%ebp),%eax
	if (--pp->pp_ref == 0)
f0101587:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
f010158b:	8d 51 ff             	lea    -0x1(%ecx),%edx
f010158e:	66 89 50 04          	mov    %dx,0x4(%eax)
f0101592:	66 85 d2             	test   %dx,%dx
f0101595:	75 08                	jne    f010159f <page_decref+0x21>
		page_free(pp);
f0101597:	89 04 24             	mov    %eax,(%esp)
f010159a:	e8 73 ff ff ff       	call   f0101512 <page_free>
}
f010159f:	c9                   	leave  
f01015a0:	c3                   	ret    

f01015a1 <pgdir_walk>:
// Hint 3: look at inc/mmu.h for useful macros that mainipulate page
// table and page directory entries.
//
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f01015a1:	55                   	push   %ebp
f01015a2:	89 e5                	mov    %esp,%ebp
f01015a4:	56                   	push   %esi
f01015a5:	53                   	push   %ebx
f01015a6:	83 ec 10             	sub    $0x10,%esp
f01015a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo *new_page = NULL;
	pde_t *pde = &pgdir[PDX(va)];
f01015ac:	89 f3                	mov    %esi,%ebx
f01015ae:	c1 eb 16             	shr    $0x16,%ebx
f01015b1:	c1 e3 02             	shl    $0x2,%ebx
f01015b4:	03 5d 08             	add    0x8(%ebp),%ebx

	if (!(*pde & PTE_P) && !create)
f01015b7:	f6 03 01             	testb  $0x1,(%ebx)
f01015ba:	75 2c                	jne    f01015e8 <pgdir_walk+0x47>
f01015bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f01015c0:	74 6c                	je     f010162e <pgdir_walk+0x8d>
  		return NULL;
  	else if (!(*pde & PTE_P) && create) {
  		new_page = page_alloc(1);
f01015c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01015c9:	e8 8a fe ff ff       	call   f0101458 <page_alloc>
		if (new_page == NULL) // allocation failed
f01015ce:	85 c0                	test   %eax,%eax
f01015d0:	74 63                	je     f0101635 <pgdir_walk+0x94>
			return NULL;
		new_page->pp_ref += 1;
f01015d2:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01015d7:	2b 05 9c 9e 2c f0    	sub    0xf02c9e9c,%eax
f01015dd:	c1 f8 03             	sar    $0x3,%eax
f01015e0:	c1 e0 0c             	shl    $0xc,%eax
		*pde = (page2pa(new_page) | PTE_P | PTE_U | PTE_W);
f01015e3:	83 c8 07             	or     $0x7,%eax
f01015e6:	89 03                	mov    %eax,(%ebx)
  	}
	pte_t *pte_base = KADDR(PTE_ADDR(*pde));
f01015e8:	8b 03                	mov    (%ebx),%eax
f01015ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01015ef:	89 c2                	mov    %eax,%edx
f01015f1:	c1 ea 0c             	shr    $0xc,%edx
f01015f4:	3b 15 94 9e 2c f0    	cmp    0xf02c9e94,%edx
f01015fa:	72 20                	jb     f010161c <pgdir_walk+0x7b>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01015fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101600:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0101607:	f0 
f0101608:	c7 44 24 04 b1 01 00 	movl   $0x1b1,0x4(%esp)
f010160f:	00 
f0101610:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101617:	e8 24 ea ff ff       	call   f0100040 <_panic>
	return &pte_base[PTX(va)];
f010161c:	c1 ee 0a             	shr    $0xa,%esi
f010161f:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
f0101625:	8d 84 30 00 00 00 f0 	lea    -0x10000000(%eax,%esi,1),%eax
f010162c:	eb 0c                	jmp    f010163a <pgdir_walk+0x99>
{
	struct PageInfo *new_page = NULL;
	pde_t *pde = &pgdir[PDX(va)];

	if (!(*pde & PTE_P) && !create)
  		return NULL;
f010162e:	b8 00 00 00 00       	mov    $0x0,%eax
f0101633:	eb 05                	jmp    f010163a <pgdir_walk+0x99>
  	else if (!(*pde & PTE_P) && create) {
  		new_page = page_alloc(1);
		if (new_page == NULL) // allocation failed
			return NULL;
f0101635:	b8 00 00 00 00       	mov    $0x0,%eax
		new_page->pp_ref += 1;
		*pde = (page2pa(new_page) | PTE_P | PTE_U | PTE_W);
  	}
	pte_t *pte_base = KADDR(PTE_ADDR(*pde));
	return &pte_base[PTX(va)];
}
f010163a:	83 c4 10             	add    $0x10,%esp
f010163d:	5b                   	pop    %ebx
f010163e:	5e                   	pop    %esi
f010163f:	5d                   	pop    %ebp
f0101640:	c3                   	ret    

f0101641 <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
f0101641:	55                   	push   %ebp
f0101642:	89 e5                	mov    %esp,%ebp
f0101644:	57                   	push   %edi
f0101645:	56                   	push   %esi
f0101646:	53                   	push   %ebx
f0101647:	83 ec 2c             	sub    $0x2c,%esp
f010164a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	pte_t *pte;
	uintptr_t current_va = va;
  	physaddr_t current_pa = pa;
  	uint64_t end_va = current_va + size;
f010164d:	01 d1                	add    %edx,%ecx
f010164f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0101652:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)
{
	pte_t *pte;
	uintptr_t current_va = va;
f0101659:	89 d3                	mov    %edx,%ebx
f010165b:	8b 7d 08             	mov    0x8(%ebp),%edi
f010165e:	29 d7                	sub    %edx,%edi
  	// The highest possible address of a virtual page
  	uint32_t last_page_addr = 4294963200LL;

	while (current_va < end_va) {
		pte = pgdir_walk(pgdir, (void *) current_va, true);
		*pte = (current_pa | perm | PTE_P);
f0101660:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101663:	83 c8 01             	or     $0x1,%eax
f0101666:	89 45 d8             	mov    %eax,-0x28(%ebp)
  	physaddr_t current_pa = pa;
  	uint64_t end_va = current_va + size;
  	// The highest possible address of a virtual page
  	uint32_t last_page_addr = 4294963200LL;

	while (current_va < end_va) {
f0101669:	eb 2a                	jmp    f0101695 <boot_map_region+0x54>
		pte = pgdir_walk(pgdir, (void *) current_va, true);
f010166b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0101672:	00 
f0101673:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101677:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010167a:	89 04 24             	mov    %eax,(%esp)
f010167d:	e8 1f ff ff ff       	call   f01015a1 <pgdir_walk>
		*pte = (current_pa | perm | PTE_P);
f0101682:	0b 75 d8             	or     -0x28(%ebp),%esi
f0101685:	89 30                	mov    %esi,(%eax)
		if (current_va == last_page_addr)
f0101687:	81 fb 00 f0 ff ff    	cmp    $0xfffff000,%ebx
f010168d:	74 14                	je     f01016a3 <boot_map_region+0x62>
			break;

		current_va += PGSIZE;
f010168f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101695:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  	physaddr_t current_pa = pa;
  	uint64_t end_va = current_va + size;
  	// The highest possible address of a virtual page
  	uint32_t last_page_addr = 4294963200LL;

	while (current_va < end_va) {
f0101698:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f010169c:	77 cd                	ja     f010166b <boot_map_region+0x2a>
f010169e:	39 5d e0             	cmp    %ebx,-0x20(%ebp)
f01016a1:	77 c8                	ja     f010166b <boot_map_region+0x2a>
			break;

		current_va += PGSIZE;
		current_pa += PGSIZE;
  	}
}
f01016a3:	83 c4 2c             	add    $0x2c,%esp
f01016a6:	5b                   	pop    %ebx
f01016a7:	5e                   	pop    %esi
f01016a8:	5f                   	pop    %edi
f01016a9:	5d                   	pop    %ebp
f01016aa:	c3                   	ret    

f01016ab <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
f01016ab:	55                   	push   %ebp
f01016ac:	89 e5                	mov    %esp,%ebp
f01016ae:	53                   	push   %ebx
f01016af:	83 ec 14             	sub    $0x14,%esp
f01016b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t *pte = pgdir_walk(pgdir, va, false);
f01016b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01016bc:	00 
f01016bd:	8b 45 0c             	mov    0xc(%ebp),%eax
f01016c0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01016c4:	8b 45 08             	mov    0x8(%ebp),%eax
f01016c7:	89 04 24             	mov    %eax,(%esp)
f01016ca:	e8 d2 fe ff ff       	call   f01015a1 <pgdir_walk>
	if (pte == NULL) // pgdir_walk couldn't allocate space for a page table
f01016cf:	85 c0                	test   %eax,%eax
f01016d1:	74 3f                	je     f0101712 <page_lookup+0x67>
		return NULL;
	if (!(*pte & PTE_P)) // no page mapped at va
f01016d3:	f6 00 01             	testb  $0x1,(%eax)
f01016d6:	74 41                	je     f0101719 <page_lookup+0x6e>
		return NULL;
	if (pte_store)
f01016d8:	85 db                	test   %ebx,%ebx
f01016da:	74 02                	je     f01016de <page_lookup+0x33>
		*pte_store = pte;
f01016dc:	89 03                	mov    %eax,(%ebx)
	physaddr_t pp = PTE_ADDR(*pte);
f01016de:	8b 00                	mov    (%eax),%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01016e0:	c1 e8 0c             	shr    $0xc,%eax
f01016e3:	3b 05 94 9e 2c f0    	cmp    0xf02c9e94,%eax
f01016e9:	72 1c                	jb     f0101707 <page_lookup+0x5c>
		panic("pa2page called with invalid pa");
f01016eb:	c7 44 24 08 30 8a 10 	movl   $0xf0108a30,0x8(%esp)
f01016f2:	f0 
f01016f3:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
f01016fa:	00 
f01016fb:	c7 04 24 b1 92 10 f0 	movl   $0xf01092b1,(%esp)
f0101702:	e8 39 e9 ff ff       	call   f0100040 <_panic>
	return &pages[PGNUM(pa)];
f0101707:	8b 15 9c 9e 2c f0    	mov    0xf02c9e9c,%edx
f010170d:	8d 04 c2             	lea    (%edx,%eax,8),%eax
	return pa2page(pp);
f0101710:	eb 0c                	jmp    f010171e <page_lookup+0x73>
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
	pte_t *pte = pgdir_walk(pgdir, va, false);
	if (pte == NULL) // pgdir_walk couldn't allocate space for a page table
		return NULL;
f0101712:	b8 00 00 00 00       	mov    $0x0,%eax
f0101717:	eb 05                	jmp    f010171e <page_lookup+0x73>
	if (!(*pte & PTE_P)) // no page mapped at va
		return NULL;
f0101719:	b8 00 00 00 00       	mov    $0x0,%eax
	if (pte_store)
		*pte_store = pte;
	physaddr_t pp = PTE_ADDR(*pte);
	return pa2page(pp);
}
f010171e:	83 c4 14             	add    $0x14,%esp
f0101721:	5b                   	pop    %ebx
f0101722:	5d                   	pop    %ebp
f0101723:	c3                   	ret    

f0101724 <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f0101724:	55                   	push   %ebp
f0101725:	89 e5                	mov    %esp,%ebp
f0101727:	83 ec 08             	sub    $0x8,%esp
	// Flush the entry only if we're modifying the current address space.
	if (!curenv || curenv->env_pgdir == pgdir)
f010172a:	e8 da 56 00 00       	call   f0106e09 <cpunum>
f010172f:	6b c0 74             	imul   $0x74,%eax,%eax
f0101732:	83 b8 28 a0 2c f0 00 	cmpl   $0x0,-0xfd35fd8(%eax)
f0101739:	74 16                	je     f0101751 <tlb_invalidate+0x2d>
f010173b:	e8 c9 56 00 00       	call   f0106e09 <cpunum>
f0101740:	6b c0 74             	imul   $0x74,%eax,%eax
f0101743:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0101749:	8b 55 08             	mov    0x8(%ebp),%edx
f010174c:	39 50 60             	cmp    %edx,0x60(%eax)
f010174f:	75 06                	jne    f0101757 <tlb_invalidate+0x33>
}

static inline void
invlpg(void *addr)
{
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0101751:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101754:	0f 01 38             	invlpg (%eax)
		invlpg(va);
}
f0101757:	c9                   	leave  
f0101758:	c3                   	ret    

f0101759 <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
f0101759:	55                   	push   %ebp
f010175a:	89 e5                	mov    %esp,%ebp
f010175c:	56                   	push   %esi
f010175d:	53                   	push   %ebx
f010175e:	83 ec 20             	sub    $0x20,%esp
f0101761:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101764:	8b 75 0c             	mov    0xc(%ebp),%esi
	pte_t *pte;
	struct PageInfo *pp = page_lookup(pgdir, va, &pte);
f0101767:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010176a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010176e:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101772:	89 1c 24             	mov    %ebx,(%esp)
f0101775:	e8 31 ff ff ff       	call   f01016ab <page_lookup>
	if (pp == NULL)
f010177a:	85 c0                	test   %eax,%eax
f010177c:	74 1d                	je     f010179b <page_remove+0x42>
		return;
	page_decref(pp);
f010177e:	89 04 24             	mov    %eax,(%esp)
f0101781:	e8 f8 fd ff ff       	call   f010157e <page_decref>
	tlb_invalidate(pgdir, va);
f0101786:	89 74 24 04          	mov    %esi,0x4(%esp)
f010178a:	89 1c 24             	mov    %ebx,(%esp)
f010178d:	e8 92 ff ff ff       	call   f0101724 <tlb_invalidate>
	*pte = (*pte & 0);
f0101792:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101795:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
f010179b:	83 c4 20             	add    $0x20,%esp
f010179e:	5b                   	pop    %ebx
f010179f:	5e                   	pop    %esi
f01017a0:	5d                   	pop    %ebp
f01017a1:	c3                   	ret    

f01017a2 <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
f01017a2:	55                   	push   %ebp
f01017a3:	89 e5                	mov    %esp,%ebp
f01017a5:	57                   	push   %edi
f01017a6:	56                   	push   %esi
f01017a7:	53                   	push   %ebx
f01017a8:	83 ec 1c             	sub    $0x1c,%esp
f01017ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
f01017ae:	8b 7d 0c             	mov    0xc(%ebp),%edi
  	pte_t *pte;

  	pte = pgdir_walk(pgdir, va, true);
f01017b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01017b8:	00 
f01017b9:	8b 45 10             	mov    0x10(%ebp),%eax
f01017bc:	89 44 24 04          	mov    %eax,0x4(%esp)
f01017c0:	89 1c 24             	mov    %ebx,(%esp)
f01017c3:	e8 d9 fd ff ff       	call   f01015a1 <pgdir_walk>
f01017c8:	89 c6                	mov    %eax,%esi
	if (pte == NULL)
f01017ca:	85 c0                	test   %eax,%eax
f01017cc:	74 42                	je     f0101810 <page_insert+0x6e>
		return -E_NO_MEM; // couldn't allocate page table
  	pp->pp_ref += 1;
f01017ce:	66 83 47 04 01       	addw   $0x1,0x4(%edi)
	if (*pte & PTE_P)
f01017d3:	f6 00 01             	testb  $0x1,(%eax)
f01017d6:	74 0f                	je     f01017e7 <page_insert+0x45>
		page_remove(pgdir, va);
f01017d8:	8b 45 10             	mov    0x10(%ebp),%eax
f01017db:	89 44 24 04          	mov    %eax,0x4(%esp)
f01017df:	89 1c 24             	mov    %ebx,(%esp)
f01017e2:	e8 72 ff ff ff       	call   f0101759 <page_remove>

	*pte = (page2pa(pp) | perm | PTE_P);
f01017e7:	8b 45 14             	mov    0x14(%ebp),%eax
f01017ea:	83 c8 01             	or     $0x1,%eax
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01017ed:	2b 3d 9c 9e 2c f0    	sub    0xf02c9e9c,%edi
f01017f3:	c1 ff 03             	sar    $0x3,%edi
f01017f6:	c1 e7 0c             	shl    $0xc,%edi
f01017f9:	09 c7                	or     %eax,%edi
f01017fb:	89 3e                	mov    %edi,(%esi)
	pgdir[PDX(va)] |= perm;
f01017fd:	8b 45 10             	mov    0x10(%ebp),%eax
f0101800:	c1 e8 16             	shr    $0x16,%eax
f0101803:	8b 55 14             	mov    0x14(%ebp),%edx
f0101806:	09 14 83             	or     %edx,(%ebx,%eax,4)
	return 0;
f0101809:	b8 00 00 00 00       	mov    $0x0,%eax
f010180e:	eb 05                	jmp    f0101815 <page_insert+0x73>
{
  	pte_t *pte;

  	pte = pgdir_walk(pgdir, va, true);
	if (pte == NULL)
		return -E_NO_MEM; // couldn't allocate page table
f0101810:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
		page_remove(pgdir, va);

	*pte = (page2pa(pp) | perm | PTE_P);
	pgdir[PDX(va)] |= perm;
	return 0;
}
f0101815:	83 c4 1c             	add    $0x1c,%esp
f0101818:	5b                   	pop    %ebx
f0101819:	5e                   	pop    %esi
f010181a:	5f                   	pop    %edi
f010181b:	5d                   	pop    %ebp
f010181c:	c3                   	ret    

f010181d <mmio_map_region>:
// location.  Return the base of the reserved region.  size does *not*
// have to be multiple of PGSIZE.
//
void *
mmio_map_region(physaddr_t pa, size_t size)
{
f010181d:	55                   	push   %ebp
f010181e:	89 e5                	mov    %esp,%ebp
f0101820:	53                   	push   %ebx
f0101821:	83 ec 14             	sub    $0x14,%esp
	// okay to simply panic if this happens).
	//
	// Hint: The staff solution uses boot_map_region.
	//
	// Your code here:
	size_t round_up_size = ROUNDUP(size, PGSIZE);
f0101824:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101827:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
f010182d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if (base + round_up_size > MMIOLIM)
f0101833:	8b 15 00 63 12 f0    	mov    0xf0126300,%edx
f0101839:	8d 04 13             	lea    (%ebx,%edx,1),%eax
f010183c:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f0101841:	76 1c                	jbe    f010185f <mmio_map_region+0x42>
		panic("mmio_map_region: requested size to map went over MMIOLIM");
f0101843:	c7 44 24 08 50 8a 10 	movl   $0xf0108a50,0x8(%esp)
f010184a:	f0 
f010184b:	c7 44 24 04 61 02 00 	movl   $0x261,0x4(%esp)
f0101852:	00 
f0101853:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010185a:	e8 e1 e7 ff ff       	call   f0100040 <_panic>

	boot_map_region(kern_pgdir, base, round_up_size, pa, PTE_PCD | PTE_PWT | PTE_W);
f010185f:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
f0101866:	00 
f0101867:	8b 45 08             	mov    0x8(%ebp),%eax
f010186a:	89 04 24             	mov    %eax,(%esp)
f010186d:	89 d9                	mov    %ebx,%ecx
f010186f:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0101874:	e8 c8 fd ff ff       	call   f0101641 <boot_map_region>

	uintptr_t mapped_base = base;
f0101879:	a1 00 63 12 f0       	mov    0xf0126300,%eax
	base += round_up_size;
f010187e:	01 c3                	add    %eax,%ebx
f0101880:	89 1d 00 63 12 f0    	mov    %ebx,0xf0126300
	return (void *) mapped_base;
}
f0101886:	83 c4 14             	add    $0x14,%esp
f0101889:	5b                   	pop    %ebx
f010188a:	5d                   	pop    %ebp
f010188b:	c3                   	ret    

f010188c <mem_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f010188c:	55                   	push   %ebp
f010188d:	89 e5                	mov    %esp,%ebp
f010188f:	57                   	push   %edi
f0101890:	56                   	push   %esi
f0101891:	53                   	push   %ebx
f0101892:	83 ec 4c             	sub    $0x4c,%esp
// --------------------------------------------------------------

static int
nvram_read(int r)
{
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0101895:	c7 04 24 15 00 00 00 	movl   $0x15,(%esp)
f010189c:	e8 1f 29 00 00       	call   f01041c0 <mc146818_read>
f01018a1:	89 c3                	mov    %eax,%ebx
f01018a3:	c7 04 24 16 00 00 00 	movl   $0x16,(%esp)
f01018aa:	e8 11 29 00 00       	call   f01041c0 <mc146818_read>
f01018af:	c1 e0 08             	shl    $0x8,%eax
f01018b2:	09 c3                	or     %eax,%ebx
{
	size_t npages_extmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f01018b4:	89 d8                	mov    %ebx,%eax
f01018b6:	c1 e0 0a             	shl    $0xa,%eax
f01018b9:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f01018bf:	85 c0                	test   %eax,%eax
f01018c1:	0f 48 c2             	cmovs  %edx,%eax
f01018c4:	c1 f8 0c             	sar    $0xc,%eax
f01018c7:	a3 44 92 2c f0       	mov    %eax,0xf02c9244
// --------------------------------------------------------------

static int
nvram_read(int r)
{
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f01018cc:	c7 04 24 17 00 00 00 	movl   $0x17,(%esp)
f01018d3:	e8 e8 28 00 00       	call   f01041c0 <mc146818_read>
f01018d8:	89 c3                	mov    %eax,%ebx
f01018da:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
f01018e1:	e8 da 28 00 00       	call   f01041c0 <mc146818_read>
f01018e6:	c1 e0 08             	shl    $0x8,%eax
f01018e9:	09 c3                	or     %eax,%ebx
	size_t npages_extmem;

	// Use CMOS calls to measure available base & extended memory.
	// (CMOS calls return results in kilobytes.)
	npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
	npages_extmem = (nvram_read(NVRAM_EXTLO) * 1024) / PGSIZE;
f01018eb:	89 d8                	mov    %ebx,%eax
f01018ed:	c1 e0 0a             	shl    $0xa,%eax
f01018f0:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f01018f6:	85 c0                	test   %eax,%eax
f01018f8:	0f 48 c2             	cmovs  %edx,%eax
f01018fb:	c1 f8 0c             	sar    $0xc,%eax

	// Calculate the number of physical pages available in both base
	// and extended memory.
	if (npages_extmem)
f01018fe:	85 c0                	test   %eax,%eax
f0101900:	74 0e                	je     f0101910 <mem_init+0x84>
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
f0101902:	8d 90 00 01 00 00    	lea    0x100(%eax),%edx
f0101908:	89 15 94 9e 2c f0    	mov    %edx,0xf02c9e94
f010190e:	eb 0c                	jmp    f010191c <mem_init+0x90>
	else
		npages = npages_basemem;
f0101910:	8b 15 44 92 2c f0    	mov    0xf02c9244,%edx
f0101916:	89 15 94 9e 2c f0    	mov    %edx,0xf02c9e94

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
		npages * PGSIZE / 1024,
		npages_basemem * PGSIZE / 1024,
		npages_extmem * PGSIZE / 1024);
f010191c:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f010191f:	c1 e8 0a             	shr    $0xa,%eax
f0101922:	89 44 24 0c          	mov    %eax,0xc(%esp)
		npages * PGSIZE / 1024,
		npages_basemem * PGSIZE / 1024,
f0101926:	a1 44 92 2c f0       	mov    0xf02c9244,%eax
f010192b:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f010192e:	c1 e8 0a             	shr    $0xa,%eax
f0101931:	89 44 24 08          	mov    %eax,0x8(%esp)
		npages * PGSIZE / 1024,
f0101935:	a1 94 9e 2c f0       	mov    0xf02c9e94,%eax
f010193a:	c1 e0 0c             	shl    $0xc,%eax
	if (npages_extmem)
		npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
	else
		npages = npages_basemem;

	cprintf("Physical memory: %uK available, base = %uK, extended = %uK\n",
f010193d:	c1 e8 0a             	shr    $0xa,%eax
f0101940:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101944:	c7 04 24 8c 8a 10 f0 	movl   $0xf0108a8c,(%esp)
f010194b:	e8 f2 29 00 00       	call   f0104342 <cprintf>
	// Find out how much memory the machine has (npages & npages_basemem).
	i386_detect_memory();

	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f0101950:	b8 00 10 00 00       	mov    $0x1000,%eax
f0101955:	e8 d6 f5 ff ff       	call   f0100f30 <boot_alloc>
f010195a:	a3 98 9e 2c f0       	mov    %eax,0xf02c9e98
	memset(kern_pgdir, 0, PGSIZE);
f010195f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101966:	00 
f0101967:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010196e:	00 
f010196f:	89 04 24             	mov    %eax,(%esp)
f0101972:	e8 40 4e 00 00       	call   f01067b7 <memset>
	// a virtual page table at virtual address UVPT.
	// (For now, you don't have understand the greater purpose of the
	// following line.)

	// Permissions: kernel R, user R
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0101977:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010197c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101981:	77 20                	ja     f01019a3 <mem_init+0x117>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101983:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101987:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f010198e:	f0 
f010198f:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
f0101996:	00 
f0101997:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010199e:	e8 9d e6 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01019a3:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f01019a9:	83 ca 05             	or     $0x5,%edx
f01019ac:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// The kernel uses this array to keep track of physical pages: for
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.  Use memset
	// to initialize all fields of each struct PageInfo to 0.
	// Your code goes here:
 	pages = (struct PageInfo *) boot_alloc(npages * sizeof(struct PageInfo));
f01019b2:	a1 94 9e 2c f0       	mov    0xf02c9e94,%eax
f01019b7:	c1 e0 03             	shl    $0x3,%eax
f01019ba:	e8 71 f5 ff ff       	call   f0100f30 <boot_alloc>
f01019bf:	a3 9c 9e 2c f0       	mov    %eax,0xf02c9e9c
 	memset(pages, 0, npages * sizeof(struct PageInfo));
f01019c4:	8b 0d 94 9e 2c f0    	mov    0xf02c9e94,%ecx
f01019ca:	8d 14 cd 00 00 00 00 	lea    0x0(,%ecx,8),%edx
f01019d1:	89 54 24 08          	mov    %edx,0x8(%esp)
f01019d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01019dc:	00 
f01019dd:	89 04 24             	mov    %eax,(%esp)
f01019e0:	e8 d2 4d 00 00       	call   f01067b7 <memset>

	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.
  	envs = (struct Env *) boot_alloc(NENV * sizeof(struct Env));
f01019e5:	b8 00 00 02 00       	mov    $0x20000,%eax
f01019ea:	e8 41 f5 ff ff       	call   f0100f30 <boot_alloc>
f01019ef:	a3 48 92 2c f0       	mov    %eax,0xf02c9248
  	memset(envs, 0, NENV * sizeof(struct Env));
f01019f4:	c7 44 24 08 00 00 02 	movl   $0x20000,0x8(%esp)
f01019fb:	00 
f01019fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101a03:	00 
f0101a04:	89 04 24             	mov    %eax,(%esp)
f0101a07:	e8 ab 4d 00 00       	call   f01067b7 <memset>
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_region
	// or page_insert
 	page_init();
f0101a0c:	e8 9f f9 ff ff       	call   f01013b0 <page_init>

	check_page_free_list(1);
f0101a11:	b8 01 00 00 00       	mov    $0x1,%eax
f0101a16:	e8 02 f6 ff ff       	call   f010101d <check_page_free_list>
	int nfree;
	struct PageInfo *fl;
	char *c;
	int i;

	if (!pages)
f0101a1b:	83 3d 9c 9e 2c f0 00 	cmpl   $0x0,0xf02c9e9c
f0101a22:	75 1c                	jne    f0101a40 <mem_init+0x1b4>
		panic("'pages' is a null pointer!");
f0101a24:	c7 44 24 08 9c 93 10 	movl   $0xf010939c,0x8(%esp)
f0101a2b:	f0 
f0101a2c:	c7 44 24 04 f7 02 00 	movl   $0x2f7,0x4(%esp)
f0101a33:	00 
f0101a34:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101a3b:	e8 00 e6 ff ff       	call   f0100040 <_panic>

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101a40:	a1 40 92 2c f0       	mov    0xf02c9240,%eax
f0101a45:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101a4a:	eb 05                	jmp    f0101a51 <mem_init+0x1c5>
		++nfree;
f0101a4c:	83 c3 01             	add    $0x1,%ebx

	if (!pages)
		panic("'pages' is a null pointer!");

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101a4f:	8b 00                	mov    (%eax),%eax
f0101a51:	85 c0                	test   %eax,%eax
f0101a53:	75 f7                	jne    f0101a4c <mem_init+0x1c0>
		++nfree;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101a55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101a5c:	e8 f7 f9 ff ff       	call   f0101458 <page_alloc>
f0101a61:	89 c7                	mov    %eax,%edi
f0101a63:	85 c0                	test   %eax,%eax
f0101a65:	75 24                	jne    f0101a8b <mem_init+0x1ff>
f0101a67:	c7 44 24 0c b7 93 10 	movl   $0xf01093b7,0xc(%esp)
f0101a6e:	f0 
f0101a6f:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101a76:	f0 
f0101a77:	c7 44 24 04 ff 02 00 	movl   $0x2ff,0x4(%esp)
f0101a7e:	00 
f0101a7f:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101a86:	e8 b5 e5 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101a8b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101a92:	e8 c1 f9 ff ff       	call   f0101458 <page_alloc>
f0101a97:	89 c6                	mov    %eax,%esi
f0101a99:	85 c0                	test   %eax,%eax
f0101a9b:	75 24                	jne    f0101ac1 <mem_init+0x235>
f0101a9d:	c7 44 24 0c cd 93 10 	movl   $0xf01093cd,0xc(%esp)
f0101aa4:	f0 
f0101aa5:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101aac:	f0 
f0101aad:	c7 44 24 04 00 03 00 	movl   $0x300,0x4(%esp)
f0101ab4:	00 
f0101ab5:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101abc:	e8 7f e5 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101ac1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101ac8:	e8 8b f9 ff ff       	call   f0101458 <page_alloc>
f0101acd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101ad0:	85 c0                	test   %eax,%eax
f0101ad2:	75 24                	jne    f0101af8 <mem_init+0x26c>
f0101ad4:	c7 44 24 0c e3 93 10 	movl   $0xf01093e3,0xc(%esp)
f0101adb:	f0 
f0101adc:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101ae3:	f0 
f0101ae4:	c7 44 24 04 01 03 00 	movl   $0x301,0x4(%esp)
f0101aeb:	00 
f0101aec:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101af3:	e8 48 e5 ff ff       	call   f0100040 <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101af8:	39 f7                	cmp    %esi,%edi
f0101afa:	75 24                	jne    f0101b20 <mem_init+0x294>
f0101afc:	c7 44 24 0c f9 93 10 	movl   $0xf01093f9,0xc(%esp)
f0101b03:	f0 
f0101b04:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101b0b:	f0 
f0101b0c:	c7 44 24 04 04 03 00 	movl   $0x304,0x4(%esp)
f0101b13:	00 
f0101b14:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101b1b:	e8 20 e5 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101b20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101b23:	39 c6                	cmp    %eax,%esi
f0101b25:	74 04                	je     f0101b2b <mem_init+0x29f>
f0101b27:	39 c7                	cmp    %eax,%edi
f0101b29:	75 24                	jne    f0101b4f <mem_init+0x2c3>
f0101b2b:	c7 44 24 0c c8 8a 10 	movl   $0xf0108ac8,0xc(%esp)
f0101b32:	f0 
f0101b33:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101b3a:	f0 
f0101b3b:	c7 44 24 04 05 03 00 	movl   $0x305,0x4(%esp)
f0101b42:	00 
f0101b43:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101b4a:	e8 f1 e4 ff ff       	call   f0100040 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101b4f:	8b 15 9c 9e 2c f0    	mov    0xf02c9e9c,%edx
	assert(page2pa(pp0) < npages*PGSIZE);
f0101b55:	a1 94 9e 2c f0       	mov    0xf02c9e94,%eax
f0101b5a:	c1 e0 0c             	shl    $0xc,%eax
f0101b5d:	89 f9                	mov    %edi,%ecx
f0101b5f:	29 d1                	sub    %edx,%ecx
f0101b61:	c1 f9 03             	sar    $0x3,%ecx
f0101b64:	c1 e1 0c             	shl    $0xc,%ecx
f0101b67:	39 c1                	cmp    %eax,%ecx
f0101b69:	72 24                	jb     f0101b8f <mem_init+0x303>
f0101b6b:	c7 44 24 0c 0b 94 10 	movl   $0xf010940b,0xc(%esp)
f0101b72:	f0 
f0101b73:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101b7a:	f0 
f0101b7b:	c7 44 24 04 06 03 00 	movl   $0x306,0x4(%esp)
f0101b82:	00 
f0101b83:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101b8a:	e8 b1 e4 ff ff       	call   f0100040 <_panic>
f0101b8f:	89 f1                	mov    %esi,%ecx
f0101b91:	29 d1                	sub    %edx,%ecx
f0101b93:	c1 f9 03             	sar    $0x3,%ecx
f0101b96:	c1 e1 0c             	shl    $0xc,%ecx
	assert(page2pa(pp1) < npages*PGSIZE);
f0101b99:	39 c8                	cmp    %ecx,%eax
f0101b9b:	77 24                	ja     f0101bc1 <mem_init+0x335>
f0101b9d:	c7 44 24 0c 28 94 10 	movl   $0xf0109428,0xc(%esp)
f0101ba4:	f0 
f0101ba5:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101bac:	f0 
f0101bad:	c7 44 24 04 07 03 00 	movl   $0x307,0x4(%esp)
f0101bb4:	00 
f0101bb5:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101bbc:	e8 7f e4 ff ff       	call   f0100040 <_panic>
f0101bc1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0101bc4:	29 d1                	sub    %edx,%ecx
f0101bc6:	89 ca                	mov    %ecx,%edx
f0101bc8:	c1 fa 03             	sar    $0x3,%edx
f0101bcb:	c1 e2 0c             	shl    $0xc,%edx
	assert(page2pa(pp2) < npages*PGSIZE);
f0101bce:	39 d0                	cmp    %edx,%eax
f0101bd0:	77 24                	ja     f0101bf6 <mem_init+0x36a>
f0101bd2:	c7 44 24 0c 45 94 10 	movl   $0xf0109445,0xc(%esp)
f0101bd9:	f0 
f0101bda:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101be1:	f0 
f0101be2:	c7 44 24 04 08 03 00 	movl   $0x308,0x4(%esp)
f0101be9:	00 
f0101bea:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101bf1:	e8 4a e4 ff ff       	call   f0100040 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101bf6:	a1 40 92 2c f0       	mov    0xf02c9240,%eax
f0101bfb:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101bfe:	c7 05 40 92 2c f0 00 	movl   $0x0,0xf02c9240
f0101c05:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101c08:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101c0f:	e8 44 f8 ff ff       	call   f0101458 <page_alloc>
f0101c14:	85 c0                	test   %eax,%eax
f0101c16:	74 24                	je     f0101c3c <mem_init+0x3b0>
f0101c18:	c7 44 24 0c 62 94 10 	movl   $0xf0109462,0xc(%esp)
f0101c1f:	f0 
f0101c20:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101c27:	f0 
f0101c28:	c7 44 24 04 0f 03 00 	movl   $0x30f,0x4(%esp)
f0101c2f:	00 
f0101c30:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101c37:	e8 04 e4 ff ff       	call   f0100040 <_panic>

	// free and re-allocate?
	page_free(pp0);
f0101c3c:	89 3c 24             	mov    %edi,(%esp)
f0101c3f:	e8 ce f8 ff ff       	call   f0101512 <page_free>
	page_free(pp1);
f0101c44:	89 34 24             	mov    %esi,(%esp)
f0101c47:	e8 c6 f8 ff ff       	call   f0101512 <page_free>
	page_free(pp2);
f0101c4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101c4f:	89 04 24             	mov    %eax,(%esp)
f0101c52:	e8 bb f8 ff ff       	call   f0101512 <page_free>
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101c57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101c5e:	e8 f5 f7 ff ff       	call   f0101458 <page_alloc>
f0101c63:	89 c6                	mov    %eax,%esi
f0101c65:	85 c0                	test   %eax,%eax
f0101c67:	75 24                	jne    f0101c8d <mem_init+0x401>
f0101c69:	c7 44 24 0c b7 93 10 	movl   $0xf01093b7,0xc(%esp)
f0101c70:	f0 
f0101c71:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101c78:	f0 
f0101c79:	c7 44 24 04 16 03 00 	movl   $0x316,0x4(%esp)
f0101c80:	00 
f0101c81:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101c88:	e8 b3 e3 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101c8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101c94:	e8 bf f7 ff ff       	call   f0101458 <page_alloc>
f0101c99:	89 c7                	mov    %eax,%edi
f0101c9b:	85 c0                	test   %eax,%eax
f0101c9d:	75 24                	jne    f0101cc3 <mem_init+0x437>
f0101c9f:	c7 44 24 0c cd 93 10 	movl   $0xf01093cd,0xc(%esp)
f0101ca6:	f0 
f0101ca7:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101cae:	f0 
f0101caf:	c7 44 24 04 17 03 00 	movl   $0x317,0x4(%esp)
f0101cb6:	00 
f0101cb7:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101cbe:	e8 7d e3 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101cc3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101cca:	e8 89 f7 ff ff       	call   f0101458 <page_alloc>
f0101ccf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101cd2:	85 c0                	test   %eax,%eax
f0101cd4:	75 24                	jne    f0101cfa <mem_init+0x46e>
f0101cd6:	c7 44 24 0c e3 93 10 	movl   $0xf01093e3,0xc(%esp)
f0101cdd:	f0 
f0101cde:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101ce5:	f0 
f0101ce6:	c7 44 24 04 18 03 00 	movl   $0x318,0x4(%esp)
f0101ced:	00 
f0101cee:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101cf5:	e8 46 e3 ff ff       	call   f0100040 <_panic>
	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101cfa:	39 fe                	cmp    %edi,%esi
f0101cfc:	75 24                	jne    f0101d22 <mem_init+0x496>
f0101cfe:	c7 44 24 0c f9 93 10 	movl   $0xf01093f9,0xc(%esp)
f0101d05:	f0 
f0101d06:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101d0d:	f0 
f0101d0e:	c7 44 24 04 1a 03 00 	movl   $0x31a,0x4(%esp)
f0101d15:	00 
f0101d16:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101d1d:	e8 1e e3 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101d22:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d25:	39 c7                	cmp    %eax,%edi
f0101d27:	74 04                	je     f0101d2d <mem_init+0x4a1>
f0101d29:	39 c6                	cmp    %eax,%esi
f0101d2b:	75 24                	jne    f0101d51 <mem_init+0x4c5>
f0101d2d:	c7 44 24 0c c8 8a 10 	movl   $0xf0108ac8,0xc(%esp)
f0101d34:	f0 
f0101d35:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101d3c:	f0 
f0101d3d:	c7 44 24 04 1b 03 00 	movl   $0x31b,0x4(%esp)
f0101d44:	00 
f0101d45:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101d4c:	e8 ef e2 ff ff       	call   f0100040 <_panic>
	assert(!page_alloc(0));
f0101d51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101d58:	e8 fb f6 ff ff       	call   f0101458 <page_alloc>
f0101d5d:	85 c0                	test   %eax,%eax
f0101d5f:	74 24                	je     f0101d85 <mem_init+0x4f9>
f0101d61:	c7 44 24 0c 62 94 10 	movl   $0xf0109462,0xc(%esp)
f0101d68:	f0 
f0101d69:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101d70:	f0 
f0101d71:	c7 44 24 04 1c 03 00 	movl   $0x31c,0x4(%esp)
f0101d78:	00 
f0101d79:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101d80:	e8 bb e2 ff ff       	call   f0100040 <_panic>
f0101d85:	89 f0                	mov    %esi,%eax
f0101d87:	2b 05 9c 9e 2c f0    	sub    0xf02c9e9c,%eax
f0101d8d:	c1 f8 03             	sar    $0x3,%eax
f0101d90:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101d93:	89 c2                	mov    %eax,%edx
f0101d95:	c1 ea 0c             	shr    $0xc,%edx
f0101d98:	3b 15 94 9e 2c f0    	cmp    0xf02c9e94,%edx
f0101d9e:	72 20                	jb     f0101dc0 <mem_init+0x534>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101da0:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101da4:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0101dab:	f0 
f0101dac:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0101db3:	00 
f0101db4:	c7 04 24 b1 92 10 f0 	movl   $0xf01092b1,(%esp)
f0101dbb:	e8 80 e2 ff ff       	call   f0100040 <_panic>

	// test flags
	memset(page2kva(pp0), 1, PGSIZE);
f0101dc0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101dc7:	00 
f0101dc8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0101dcf:	00 
	return (void *)(pa + KERNBASE);
f0101dd0:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101dd5:	89 04 24             	mov    %eax,(%esp)
f0101dd8:	e8 da 49 00 00       	call   f01067b7 <memset>
	page_free(pp0);
f0101ddd:	89 34 24             	mov    %esi,(%esp)
f0101de0:	e8 2d f7 ff ff       	call   f0101512 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101de5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0101dec:	e8 67 f6 ff ff       	call   f0101458 <page_alloc>
f0101df1:	85 c0                	test   %eax,%eax
f0101df3:	75 24                	jne    f0101e19 <mem_init+0x58d>
f0101df5:	c7 44 24 0c 71 94 10 	movl   $0xf0109471,0xc(%esp)
f0101dfc:	f0 
f0101dfd:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101e04:	f0 
f0101e05:	c7 44 24 04 21 03 00 	movl   $0x321,0x4(%esp)
f0101e0c:	00 
f0101e0d:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101e14:	e8 27 e2 ff ff       	call   f0100040 <_panic>
	assert(pp && pp0 == pp);
f0101e19:	39 c6                	cmp    %eax,%esi
f0101e1b:	74 24                	je     f0101e41 <mem_init+0x5b5>
f0101e1d:	c7 44 24 0c 8f 94 10 	movl   $0xf010948f,0xc(%esp)
f0101e24:	f0 
f0101e25:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101e2c:	f0 
f0101e2d:	c7 44 24 04 22 03 00 	movl   $0x322,0x4(%esp)
f0101e34:	00 
f0101e35:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101e3c:	e8 ff e1 ff ff       	call   f0100040 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0101e41:	89 f0                	mov    %esi,%eax
f0101e43:	2b 05 9c 9e 2c f0    	sub    0xf02c9e9c,%eax
f0101e49:	c1 f8 03             	sar    $0x3,%eax
f0101e4c:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0101e4f:	89 c2                	mov    %eax,%edx
f0101e51:	c1 ea 0c             	shr    $0xc,%edx
f0101e54:	3b 15 94 9e 2c f0    	cmp    0xf02c9e94,%edx
f0101e5a:	72 20                	jb     f0101e7c <mem_init+0x5f0>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101e5c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101e60:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0101e67:	f0 
f0101e68:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0101e6f:	00 
f0101e70:	c7 04 24 b1 92 10 f0 	movl   $0xf01092b1,(%esp)
f0101e77:	e8 c4 e1 ff ff       	call   f0100040 <_panic>
f0101e7c:	8d 90 00 10 00 f0    	lea    -0xffff000(%eax),%edx
	return (void *)(pa + KERNBASE);
f0101e82:	8d 80 00 00 00 f0    	lea    -0x10000000(%eax),%eax
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
		assert(c[i] == 0);
f0101e88:	80 38 00             	cmpb   $0x0,(%eax)
f0101e8b:	74 24                	je     f0101eb1 <mem_init+0x625>
f0101e8d:	c7 44 24 0c 9f 94 10 	movl   $0xf010949f,0xc(%esp)
f0101e94:	f0 
f0101e95:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101e9c:	f0 
f0101e9d:	c7 44 24 04 25 03 00 	movl   $0x325,0x4(%esp)
f0101ea4:	00 
f0101ea5:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101eac:	e8 8f e1 ff ff       	call   f0100040 <_panic>
f0101eb1:	83 c0 01             	add    $0x1,%eax
	memset(page2kva(pp0), 1, PGSIZE);
	page_free(pp0);
	assert((pp = page_alloc(ALLOC_ZERO)));
	assert(pp && pp0 == pp);
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
f0101eb4:	39 d0                	cmp    %edx,%eax
f0101eb6:	75 d0                	jne    f0101e88 <mem_init+0x5fc>
		assert(c[i] == 0);

	// give free list back
	page_free_list = fl;
f0101eb8:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101ebb:	a3 40 92 2c f0       	mov    %eax,0xf02c9240

	// free the pages we took
	page_free(pp0);
f0101ec0:	89 34 24             	mov    %esi,(%esp)
f0101ec3:	e8 4a f6 ff ff       	call   f0101512 <page_free>
	page_free(pp1);
f0101ec8:	89 3c 24             	mov    %edi,(%esp)
f0101ecb:	e8 42 f6 ff ff       	call   f0101512 <page_free>
	page_free(pp2);
f0101ed0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101ed3:	89 04 24             	mov    %eax,(%esp)
f0101ed6:	e8 37 f6 ff ff       	call   f0101512 <page_free>

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101edb:	a1 40 92 2c f0       	mov    0xf02c9240,%eax
f0101ee0:	eb 05                	jmp    f0101ee7 <mem_init+0x65b>
		--nfree;
f0101ee2:	83 eb 01             	sub    $0x1,%ebx
	page_free(pp0);
	page_free(pp1);
	page_free(pp2);

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101ee5:	8b 00                	mov    (%eax),%eax
f0101ee7:	85 c0                	test   %eax,%eax
f0101ee9:	75 f7                	jne    f0101ee2 <mem_init+0x656>
		--nfree;
	assert(nfree == 0);
f0101eeb:	85 db                	test   %ebx,%ebx
f0101eed:	74 24                	je     f0101f13 <mem_init+0x687>
f0101eef:	c7 44 24 0c a9 94 10 	movl   $0xf01094a9,0xc(%esp)
f0101ef6:	f0 
f0101ef7:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101efe:	f0 
f0101eff:	c7 44 24 04 32 03 00 	movl   $0x332,0x4(%esp)
f0101f06:	00 
f0101f07:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101f0e:	e8 2d e1 ff ff       	call   f0100040 <_panic>

	cprintf("check_page_alloc() succeeded!\n");
f0101f13:	c7 04 24 e8 8a 10 f0 	movl   $0xf0108ae8,(%esp)
f0101f1a:	e8 23 24 00 00       	call   f0104342 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101f1f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101f26:	e8 2d f5 ff ff       	call   f0101458 <page_alloc>
f0101f2b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101f2e:	85 c0                	test   %eax,%eax
f0101f30:	75 24                	jne    f0101f56 <mem_init+0x6ca>
f0101f32:	c7 44 24 0c b7 93 10 	movl   $0xf01093b7,0xc(%esp)
f0101f39:	f0 
f0101f3a:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101f41:	f0 
f0101f42:	c7 44 24 04 98 03 00 	movl   $0x398,0x4(%esp)
f0101f49:	00 
f0101f4a:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101f51:	e8 ea e0 ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0101f56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101f5d:	e8 f6 f4 ff ff       	call   f0101458 <page_alloc>
f0101f62:	89 c3                	mov    %eax,%ebx
f0101f64:	85 c0                	test   %eax,%eax
f0101f66:	75 24                	jne    f0101f8c <mem_init+0x700>
f0101f68:	c7 44 24 0c cd 93 10 	movl   $0xf01093cd,0xc(%esp)
f0101f6f:	f0 
f0101f70:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101f77:	f0 
f0101f78:	c7 44 24 04 99 03 00 	movl   $0x399,0x4(%esp)
f0101f7f:	00 
f0101f80:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101f87:	e8 b4 e0 ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f0101f8c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101f93:	e8 c0 f4 ff ff       	call   f0101458 <page_alloc>
f0101f98:	89 c6                	mov    %eax,%esi
f0101f9a:	85 c0                	test   %eax,%eax
f0101f9c:	75 24                	jne    f0101fc2 <mem_init+0x736>
f0101f9e:	c7 44 24 0c e3 93 10 	movl   $0xf01093e3,0xc(%esp)
f0101fa5:	f0 
f0101fa6:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101fad:	f0 
f0101fae:	c7 44 24 04 9a 03 00 	movl   $0x39a,0x4(%esp)
f0101fb5:	00 
f0101fb6:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101fbd:	e8 7e e0 ff ff       	call   f0100040 <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101fc2:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0101fc5:	75 24                	jne    f0101feb <mem_init+0x75f>
f0101fc7:	c7 44 24 0c f9 93 10 	movl   $0xf01093f9,0xc(%esp)
f0101fce:	f0 
f0101fcf:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0101fd6:	f0 
f0101fd7:	c7 44 24 04 9d 03 00 	movl   $0x39d,0x4(%esp)
f0101fde:	00 
f0101fdf:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0101fe6:	e8 55 e0 ff ff       	call   f0100040 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101feb:	39 c3                	cmp    %eax,%ebx
f0101fed:	74 05                	je     f0101ff4 <mem_init+0x768>
f0101fef:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
f0101ff2:	75 24                	jne    f0102018 <mem_init+0x78c>
f0101ff4:	c7 44 24 0c c8 8a 10 	movl   $0xf0108ac8,0xc(%esp)
f0101ffb:	f0 
f0101ffc:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102003:	f0 
f0102004:	c7 44 24 04 9e 03 00 	movl   $0x39e,0x4(%esp)
f010200b:	00 
f010200c:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102013:	e8 28 e0 ff ff       	call   f0100040 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0102018:	a1 40 92 2c f0       	mov    0xf02c9240,%eax
f010201d:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0102020:	c7 05 40 92 2c f0 00 	movl   $0x0,0xf02c9240
f0102027:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f010202a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102031:	e8 22 f4 ff ff       	call   f0101458 <page_alloc>
f0102036:	85 c0                	test   %eax,%eax
f0102038:	74 24                	je     f010205e <mem_init+0x7d2>
f010203a:	c7 44 24 0c 62 94 10 	movl   $0xf0109462,0xc(%esp)
f0102041:	f0 
f0102042:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102049:	f0 
f010204a:	c7 44 24 04 a5 03 00 	movl   $0x3a5,0x4(%esp)
f0102051:	00 
f0102052:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102059:	e8 e2 df ff ff       	call   f0100040 <_panic>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f010205e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0102061:	89 44 24 08          	mov    %eax,0x8(%esp)
f0102065:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010206c:	00 
f010206d:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102072:	89 04 24             	mov    %eax,(%esp)
f0102075:	e8 31 f6 ff ff       	call   f01016ab <page_lookup>
f010207a:	85 c0                	test   %eax,%eax
f010207c:	74 24                	je     f01020a2 <mem_init+0x816>
f010207e:	c7 44 24 0c 08 8b 10 	movl   $0xf0108b08,0xc(%esp)
f0102085:	f0 
f0102086:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010208d:	f0 
f010208e:	c7 44 24 04 a8 03 00 	movl   $0x3a8,0x4(%esp)
f0102095:	00 
f0102096:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010209d:	e8 9e df ff ff       	call   f0100040 <_panic>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f01020a2:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01020a9:	00 
f01020aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01020b1:	00 
f01020b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01020b6:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f01020bb:	89 04 24             	mov    %eax,(%esp)
f01020be:	e8 df f6 ff ff       	call   f01017a2 <page_insert>
f01020c3:	85 c0                	test   %eax,%eax
f01020c5:	78 24                	js     f01020eb <mem_init+0x85f>
f01020c7:	c7 44 24 0c 40 8b 10 	movl   $0xf0108b40,0xc(%esp)
f01020ce:	f0 
f01020cf:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01020d6:	f0 
f01020d7:	c7 44 24 04 ab 03 00 	movl   $0x3ab,0x4(%esp)
f01020de:	00 
f01020df:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01020e6:	e8 55 df ff ff       	call   f0100040 <_panic>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f01020eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01020ee:	89 04 24             	mov    %eax,(%esp)
f01020f1:	e8 1c f4 ff ff       	call   f0101512 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f01020f6:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01020fd:	00 
f01020fe:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102105:	00 
f0102106:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010210a:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f010210f:	89 04 24             	mov    %eax,(%esp)
f0102112:	e8 8b f6 ff ff       	call   f01017a2 <page_insert>
f0102117:	85 c0                	test   %eax,%eax
f0102119:	74 24                	je     f010213f <mem_init+0x8b3>
f010211b:	c7 44 24 0c 70 8b 10 	movl   $0xf0108b70,0xc(%esp)
f0102122:	f0 
f0102123:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010212a:	f0 
f010212b:	c7 44 24 04 af 03 00 	movl   $0x3af,0x4(%esp)
f0102132:	00 
f0102133:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010213a:	e8 01 df ff ff       	call   f0100040 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010213f:	8b 3d 98 9e 2c f0    	mov    0xf02c9e98,%edi
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0102145:	a1 9c 9e 2c f0       	mov    0xf02c9e9c,%eax
f010214a:	89 45 cc             	mov    %eax,-0x34(%ebp)
f010214d:	8b 17                	mov    (%edi),%edx
f010214f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102155:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0102158:	29 c1                	sub    %eax,%ecx
f010215a:	89 c8                	mov    %ecx,%eax
f010215c:	c1 f8 03             	sar    $0x3,%eax
f010215f:	c1 e0 0c             	shl    $0xc,%eax
f0102162:	39 c2                	cmp    %eax,%edx
f0102164:	74 24                	je     f010218a <mem_init+0x8fe>
f0102166:	c7 44 24 0c a0 8b 10 	movl   $0xf0108ba0,0xc(%esp)
f010216d:	f0 
f010216e:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102175:	f0 
f0102176:	c7 44 24 04 b0 03 00 	movl   $0x3b0,0x4(%esp)
f010217d:	00 
f010217e:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102185:	e8 b6 de ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010218a:	ba 00 00 00 00       	mov    $0x0,%edx
f010218f:	89 f8                	mov    %edi,%eax
f0102191:	e8 18 ee ff ff       	call   f0100fae <check_va2pa>
f0102196:	89 da                	mov    %ebx,%edx
f0102198:	2b 55 cc             	sub    -0x34(%ebp),%edx
f010219b:	c1 fa 03             	sar    $0x3,%edx
f010219e:	c1 e2 0c             	shl    $0xc,%edx
f01021a1:	39 d0                	cmp    %edx,%eax
f01021a3:	74 24                	je     f01021c9 <mem_init+0x93d>
f01021a5:	c7 44 24 0c c8 8b 10 	movl   $0xf0108bc8,0xc(%esp)
f01021ac:	f0 
f01021ad:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01021b4:	f0 
f01021b5:	c7 44 24 04 b1 03 00 	movl   $0x3b1,0x4(%esp)
f01021bc:	00 
f01021bd:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01021c4:	e8 77 de ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f01021c9:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01021ce:	74 24                	je     f01021f4 <mem_init+0x968>
f01021d0:	c7 44 24 0c b4 94 10 	movl   $0xf01094b4,0xc(%esp)
f01021d7:	f0 
f01021d8:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01021df:	f0 
f01021e0:	c7 44 24 04 b2 03 00 	movl   $0x3b2,0x4(%esp)
f01021e7:	00 
f01021e8:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01021ef:	e8 4c de ff ff       	call   f0100040 <_panic>
	assert(pp0->pp_ref == 1);
f01021f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01021f7:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f01021fc:	74 24                	je     f0102222 <mem_init+0x996>
f01021fe:	c7 44 24 0c c5 94 10 	movl   $0xf01094c5,0xc(%esp)
f0102205:	f0 
f0102206:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010220d:	f0 
f010220e:	c7 44 24 04 b3 03 00 	movl   $0x3b3,0x4(%esp)
f0102215:	00 
f0102216:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010221d:	e8 1e de ff ff       	call   f0100040 <_panic>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102222:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102229:	00 
f010222a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102231:	00 
f0102232:	89 74 24 04          	mov    %esi,0x4(%esp)
f0102236:	89 3c 24             	mov    %edi,(%esp)
f0102239:	e8 64 f5 ff ff       	call   f01017a2 <page_insert>
f010223e:	85 c0                	test   %eax,%eax
f0102240:	74 24                	je     f0102266 <mem_init+0x9da>
f0102242:	c7 44 24 0c f8 8b 10 	movl   $0xf0108bf8,0xc(%esp)
f0102249:	f0 
f010224a:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102251:	f0 
f0102252:	c7 44 24 04 b6 03 00 	movl   $0x3b6,0x4(%esp)
f0102259:	00 
f010225a:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102261:	e8 da dd ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102266:	ba 00 10 00 00       	mov    $0x1000,%edx
f010226b:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102270:	e8 39 ed ff ff       	call   f0100fae <check_va2pa>
f0102275:	89 f2                	mov    %esi,%edx
f0102277:	2b 15 9c 9e 2c f0    	sub    0xf02c9e9c,%edx
f010227d:	c1 fa 03             	sar    $0x3,%edx
f0102280:	c1 e2 0c             	shl    $0xc,%edx
f0102283:	39 d0                	cmp    %edx,%eax
f0102285:	74 24                	je     f01022ab <mem_init+0xa1f>
f0102287:	c7 44 24 0c 34 8c 10 	movl   $0xf0108c34,0xc(%esp)
f010228e:	f0 
f010228f:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102296:	f0 
f0102297:	c7 44 24 04 b7 03 00 	movl   $0x3b7,0x4(%esp)
f010229e:	00 
f010229f:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01022a6:	e8 95 dd ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f01022ab:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01022b0:	74 24                	je     f01022d6 <mem_init+0xa4a>
f01022b2:	c7 44 24 0c d6 94 10 	movl   $0xf01094d6,0xc(%esp)
f01022b9:	f0 
f01022ba:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01022c1:	f0 
f01022c2:	c7 44 24 04 b8 03 00 	movl   $0x3b8,0x4(%esp)
f01022c9:	00 
f01022ca:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01022d1:	e8 6a dd ff ff       	call   f0100040 <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f01022d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01022dd:	e8 76 f1 ff ff       	call   f0101458 <page_alloc>
f01022e2:	85 c0                	test   %eax,%eax
f01022e4:	74 24                	je     f010230a <mem_init+0xa7e>
f01022e6:	c7 44 24 0c 62 94 10 	movl   $0xf0109462,0xc(%esp)
f01022ed:	f0 
f01022ee:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01022f5:	f0 
f01022f6:	c7 44 24 04 bb 03 00 	movl   $0x3bb,0x4(%esp)
f01022fd:	00 
f01022fe:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102305:	e8 36 dd ff ff       	call   f0100040 <_panic>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010230a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102311:	00 
f0102312:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102319:	00 
f010231a:	89 74 24 04          	mov    %esi,0x4(%esp)
f010231e:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102323:	89 04 24             	mov    %eax,(%esp)
f0102326:	e8 77 f4 ff ff       	call   f01017a2 <page_insert>
f010232b:	85 c0                	test   %eax,%eax
f010232d:	74 24                	je     f0102353 <mem_init+0xac7>
f010232f:	c7 44 24 0c f8 8b 10 	movl   $0xf0108bf8,0xc(%esp)
f0102336:	f0 
f0102337:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010233e:	f0 
f010233f:	c7 44 24 04 be 03 00 	movl   $0x3be,0x4(%esp)
f0102346:	00 
f0102347:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010234e:	e8 ed dc ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102353:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102358:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f010235d:	e8 4c ec ff ff       	call   f0100fae <check_va2pa>
f0102362:	89 f2                	mov    %esi,%edx
f0102364:	2b 15 9c 9e 2c f0    	sub    0xf02c9e9c,%edx
f010236a:	c1 fa 03             	sar    $0x3,%edx
f010236d:	c1 e2 0c             	shl    $0xc,%edx
f0102370:	39 d0                	cmp    %edx,%eax
f0102372:	74 24                	je     f0102398 <mem_init+0xb0c>
f0102374:	c7 44 24 0c 34 8c 10 	movl   $0xf0108c34,0xc(%esp)
f010237b:	f0 
f010237c:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102383:	f0 
f0102384:	c7 44 24 04 bf 03 00 	movl   $0x3bf,0x4(%esp)
f010238b:	00 
f010238c:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102393:	e8 a8 dc ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102398:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f010239d:	74 24                	je     f01023c3 <mem_init+0xb37>
f010239f:	c7 44 24 0c d6 94 10 	movl   $0xf01094d6,0xc(%esp)
f01023a6:	f0 
f01023a7:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01023ae:	f0 
f01023af:	c7 44 24 04 c0 03 00 	movl   $0x3c0,0x4(%esp)
f01023b6:	00 
f01023b7:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01023be:	e8 7d dc ff ff       	call   f0100040 <_panic>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f01023c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01023ca:	e8 89 f0 ff ff       	call   f0101458 <page_alloc>
f01023cf:	85 c0                	test   %eax,%eax
f01023d1:	74 24                	je     f01023f7 <mem_init+0xb6b>
f01023d3:	c7 44 24 0c 62 94 10 	movl   $0xf0109462,0xc(%esp)
f01023da:	f0 
f01023db:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01023e2:	f0 
f01023e3:	c7 44 24 04 c4 03 00 	movl   $0x3c4,0x4(%esp)
f01023ea:	00 
f01023eb:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01023f2:	e8 49 dc ff ff       	call   f0100040 <_panic>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f01023f7:	8b 15 98 9e 2c f0    	mov    0xf02c9e98,%edx
f01023fd:	8b 02                	mov    (%edx),%eax
f01023ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102404:	89 c1                	mov    %eax,%ecx
f0102406:	c1 e9 0c             	shr    $0xc,%ecx
f0102409:	3b 0d 94 9e 2c f0    	cmp    0xf02c9e94,%ecx
f010240f:	72 20                	jb     f0102431 <mem_init+0xba5>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102411:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102415:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f010241c:	f0 
f010241d:	c7 44 24 04 c7 03 00 	movl   $0x3c7,0x4(%esp)
f0102424:	00 
f0102425:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010242c:	e8 0f dc ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0102431:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102436:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102439:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102440:	00 
f0102441:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102448:	00 
f0102449:	89 14 24             	mov    %edx,(%esp)
f010244c:	e8 50 f1 ff ff       	call   f01015a1 <pgdir_walk>
f0102451:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0102454:	8d 51 04             	lea    0x4(%ecx),%edx
f0102457:	39 d0                	cmp    %edx,%eax
f0102459:	74 24                	je     f010247f <mem_init+0xbf3>
f010245b:	c7 44 24 0c 64 8c 10 	movl   $0xf0108c64,0xc(%esp)
f0102462:	f0 
f0102463:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010246a:	f0 
f010246b:	c7 44 24 04 c8 03 00 	movl   $0x3c8,0x4(%esp)
f0102472:	00 
f0102473:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010247a:	e8 c1 db ff ff       	call   f0100040 <_panic>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f010247f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f0102486:	00 
f0102487:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010248e:	00 
f010248f:	89 74 24 04          	mov    %esi,0x4(%esp)
f0102493:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102498:	89 04 24             	mov    %eax,(%esp)
f010249b:	e8 02 f3 ff ff       	call   f01017a2 <page_insert>
f01024a0:	85 c0                	test   %eax,%eax
f01024a2:	74 24                	je     f01024c8 <mem_init+0xc3c>
f01024a4:	c7 44 24 0c a4 8c 10 	movl   $0xf0108ca4,0xc(%esp)
f01024ab:	f0 
f01024ac:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01024b3:	f0 
f01024b4:	c7 44 24 04 cb 03 00 	movl   $0x3cb,0x4(%esp)
f01024bb:	00 
f01024bc:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01024c3:	e8 78 db ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01024c8:	8b 3d 98 9e 2c f0    	mov    0xf02c9e98,%edi
f01024ce:	ba 00 10 00 00       	mov    $0x1000,%edx
f01024d3:	89 f8                	mov    %edi,%eax
f01024d5:	e8 d4 ea ff ff       	call   f0100fae <check_va2pa>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01024da:	89 f2                	mov    %esi,%edx
f01024dc:	2b 15 9c 9e 2c f0    	sub    0xf02c9e9c,%edx
f01024e2:	c1 fa 03             	sar    $0x3,%edx
f01024e5:	c1 e2 0c             	shl    $0xc,%edx
f01024e8:	39 d0                	cmp    %edx,%eax
f01024ea:	74 24                	je     f0102510 <mem_init+0xc84>
f01024ec:	c7 44 24 0c 34 8c 10 	movl   $0xf0108c34,0xc(%esp)
f01024f3:	f0 
f01024f4:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01024fb:	f0 
f01024fc:	c7 44 24 04 cc 03 00 	movl   $0x3cc,0x4(%esp)
f0102503:	00 
f0102504:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010250b:	e8 30 db ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0102510:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102515:	74 24                	je     f010253b <mem_init+0xcaf>
f0102517:	c7 44 24 0c d6 94 10 	movl   $0xf01094d6,0xc(%esp)
f010251e:	f0 
f010251f:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102526:	f0 
f0102527:	c7 44 24 04 cd 03 00 	movl   $0x3cd,0x4(%esp)
f010252e:	00 
f010252f:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102536:	e8 05 db ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f010253b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102542:	00 
f0102543:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f010254a:	00 
f010254b:	89 3c 24             	mov    %edi,(%esp)
f010254e:	e8 4e f0 ff ff       	call   f01015a1 <pgdir_walk>
f0102553:	f6 00 04             	testb  $0x4,(%eax)
f0102556:	75 24                	jne    f010257c <mem_init+0xcf0>
f0102558:	c7 44 24 0c e4 8c 10 	movl   $0xf0108ce4,0xc(%esp)
f010255f:	f0 
f0102560:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102567:	f0 
f0102568:	c7 44 24 04 ce 03 00 	movl   $0x3ce,0x4(%esp)
f010256f:	00 
f0102570:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102577:	e8 c4 da ff ff       	call   f0100040 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f010257c:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102581:	f6 00 04             	testb  $0x4,(%eax)
f0102584:	75 24                	jne    f01025aa <mem_init+0xd1e>
f0102586:	c7 44 24 0c e7 94 10 	movl   $0xf01094e7,0xc(%esp)
f010258d:	f0 
f010258e:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102595:	f0 
f0102596:	c7 44 24 04 cf 03 00 	movl   $0x3cf,0x4(%esp)
f010259d:	00 
f010259e:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01025a5:	e8 96 da ff ff       	call   f0100040 <_panic>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01025aa:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01025b1:	00 
f01025b2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01025b9:	00 
f01025ba:	89 74 24 04          	mov    %esi,0x4(%esp)
f01025be:	89 04 24             	mov    %eax,(%esp)
f01025c1:	e8 dc f1 ff ff       	call   f01017a2 <page_insert>
f01025c6:	85 c0                	test   %eax,%eax
f01025c8:	74 24                	je     f01025ee <mem_init+0xd62>
f01025ca:	c7 44 24 0c f8 8b 10 	movl   $0xf0108bf8,0xc(%esp)
f01025d1:	f0 
f01025d2:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01025d9:	f0 
f01025da:	c7 44 24 04 d2 03 00 	movl   $0x3d2,0x4(%esp)
f01025e1:	00 
f01025e2:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01025e9:	e8 52 da ff ff       	call   f0100040 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01025ee:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01025f5:	00 
f01025f6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01025fd:	00 
f01025fe:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102603:	89 04 24             	mov    %eax,(%esp)
f0102606:	e8 96 ef ff ff       	call   f01015a1 <pgdir_walk>
f010260b:	f6 00 02             	testb  $0x2,(%eax)
f010260e:	75 24                	jne    f0102634 <mem_init+0xda8>
f0102610:	c7 44 24 0c 18 8d 10 	movl   $0xf0108d18,0xc(%esp)
f0102617:	f0 
f0102618:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010261f:	f0 
f0102620:	c7 44 24 04 d3 03 00 	movl   $0x3d3,0x4(%esp)
f0102627:	00 
f0102628:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010262f:	e8 0c da ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102634:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010263b:	00 
f010263c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102643:	00 
f0102644:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102649:	89 04 24             	mov    %eax,(%esp)
f010264c:	e8 50 ef ff ff       	call   f01015a1 <pgdir_walk>
f0102651:	f6 00 04             	testb  $0x4,(%eax)
f0102654:	74 24                	je     f010267a <mem_init+0xdee>
f0102656:	c7 44 24 0c 4c 8d 10 	movl   $0xf0108d4c,0xc(%esp)
f010265d:	f0 
f010265e:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102665:	f0 
f0102666:	c7 44 24 04 d4 03 00 	movl   $0x3d4,0x4(%esp)
f010266d:	00 
f010266e:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102675:	e8 c6 d9 ff ff       	call   f0100040 <_panic>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f010267a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0102681:	00 
f0102682:	c7 44 24 08 00 00 40 	movl   $0x400000,0x8(%esp)
f0102689:	00 
f010268a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010268d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102691:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102696:	89 04 24             	mov    %eax,(%esp)
f0102699:	e8 04 f1 ff ff       	call   f01017a2 <page_insert>
f010269e:	85 c0                	test   %eax,%eax
f01026a0:	78 24                	js     f01026c6 <mem_init+0xe3a>
f01026a2:	c7 44 24 0c 84 8d 10 	movl   $0xf0108d84,0xc(%esp)
f01026a9:	f0 
f01026aa:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01026b1:	f0 
f01026b2:	c7 44 24 04 d7 03 00 	movl   $0x3d7,0x4(%esp)
f01026b9:	00 
f01026ba:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01026c1:	e8 7a d9 ff ff       	call   f0100040 <_panic>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f01026c6:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01026cd:	00 
f01026ce:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01026d5:	00 
f01026d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01026da:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f01026df:	89 04 24             	mov    %eax,(%esp)
f01026e2:	e8 bb f0 ff ff       	call   f01017a2 <page_insert>
f01026e7:	85 c0                	test   %eax,%eax
f01026e9:	74 24                	je     f010270f <mem_init+0xe83>
f01026eb:	c7 44 24 0c bc 8d 10 	movl   $0xf0108dbc,0xc(%esp)
f01026f2:	f0 
f01026f3:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01026fa:	f0 
f01026fb:	c7 44 24 04 da 03 00 	movl   $0x3da,0x4(%esp)
f0102702:	00 
f0102703:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010270a:	e8 31 d9 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010270f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102716:	00 
f0102717:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f010271e:	00 
f010271f:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102724:	89 04 24             	mov    %eax,(%esp)
f0102727:	e8 75 ee ff ff       	call   f01015a1 <pgdir_walk>
f010272c:	f6 00 04             	testb  $0x4,(%eax)
f010272f:	74 24                	je     f0102755 <mem_init+0xec9>
f0102731:	c7 44 24 0c 4c 8d 10 	movl   $0xf0108d4c,0xc(%esp)
f0102738:	f0 
f0102739:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102740:	f0 
f0102741:	c7 44 24 04 db 03 00 	movl   $0x3db,0x4(%esp)
f0102748:	00 
f0102749:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102750:	e8 eb d8 ff ff       	call   f0100040 <_panic>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0102755:	8b 3d 98 9e 2c f0    	mov    0xf02c9e98,%edi
f010275b:	ba 00 00 00 00       	mov    $0x0,%edx
f0102760:	89 f8                	mov    %edi,%eax
f0102762:	e8 47 e8 ff ff       	call   f0100fae <check_va2pa>
f0102767:	89 c1                	mov    %eax,%ecx
f0102769:	89 45 cc             	mov    %eax,-0x34(%ebp)
f010276c:	89 d8                	mov    %ebx,%eax
f010276e:	2b 05 9c 9e 2c f0    	sub    0xf02c9e9c,%eax
f0102774:	c1 f8 03             	sar    $0x3,%eax
f0102777:	c1 e0 0c             	shl    $0xc,%eax
f010277a:	39 c1                	cmp    %eax,%ecx
f010277c:	74 24                	je     f01027a2 <mem_init+0xf16>
f010277e:	c7 44 24 0c f8 8d 10 	movl   $0xf0108df8,0xc(%esp)
f0102785:	f0 
f0102786:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010278d:	f0 
f010278e:	c7 44 24 04 de 03 00 	movl   $0x3de,0x4(%esp)
f0102795:	00 
f0102796:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010279d:	e8 9e d8 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01027a2:	ba 00 10 00 00       	mov    $0x1000,%edx
f01027a7:	89 f8                	mov    %edi,%eax
f01027a9:	e8 00 e8 ff ff       	call   f0100fae <check_va2pa>
f01027ae:	39 45 cc             	cmp    %eax,-0x34(%ebp)
f01027b1:	74 24                	je     f01027d7 <mem_init+0xf4b>
f01027b3:	c7 44 24 0c 24 8e 10 	movl   $0xf0108e24,0xc(%esp)
f01027ba:	f0 
f01027bb:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01027c2:	f0 
f01027c3:	c7 44 24 04 df 03 00 	movl   $0x3df,0x4(%esp)
f01027ca:	00 
f01027cb:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01027d2:	e8 69 d8 ff ff       	call   f0100040 <_panic>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f01027d7:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f01027dc:	74 24                	je     f0102802 <mem_init+0xf76>
f01027de:	c7 44 24 0c fd 94 10 	movl   $0xf01094fd,0xc(%esp)
f01027e5:	f0 
f01027e6:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01027ed:	f0 
f01027ee:	c7 44 24 04 e1 03 00 	movl   $0x3e1,0x4(%esp)
f01027f5:	00 
f01027f6:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01027fd:	e8 3e d8 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102802:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102807:	74 24                	je     f010282d <mem_init+0xfa1>
f0102809:	c7 44 24 0c 0e 95 10 	movl   $0xf010950e,0xc(%esp)
f0102810:	f0 
f0102811:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102818:	f0 
f0102819:	c7 44 24 04 e2 03 00 	movl   $0x3e2,0x4(%esp)
f0102820:	00 
f0102821:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102828:	e8 13 d8 ff ff       	call   f0100040 <_panic>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f010282d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102834:	e8 1f ec ff ff       	call   f0101458 <page_alloc>
f0102839:	85 c0                	test   %eax,%eax
f010283b:	74 04                	je     f0102841 <mem_init+0xfb5>
f010283d:	39 c6                	cmp    %eax,%esi
f010283f:	74 24                	je     f0102865 <mem_init+0xfd9>
f0102841:	c7 44 24 0c 54 8e 10 	movl   $0xf0108e54,0xc(%esp)
f0102848:	f0 
f0102849:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102850:	f0 
f0102851:	c7 44 24 04 e5 03 00 	movl   $0x3e5,0x4(%esp)
f0102858:	00 
f0102859:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102860:	e8 db d7 ff ff       	call   f0100040 <_panic>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0102865:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010286c:	00 
f010286d:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102872:	89 04 24             	mov    %eax,(%esp)
f0102875:	e8 df ee ff ff       	call   f0101759 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010287a:	8b 3d 98 9e 2c f0    	mov    0xf02c9e98,%edi
f0102880:	ba 00 00 00 00       	mov    $0x0,%edx
f0102885:	89 f8                	mov    %edi,%eax
f0102887:	e8 22 e7 ff ff       	call   f0100fae <check_va2pa>
f010288c:	83 f8 ff             	cmp    $0xffffffff,%eax
f010288f:	74 24                	je     f01028b5 <mem_init+0x1029>
f0102891:	c7 44 24 0c 78 8e 10 	movl   $0xf0108e78,0xc(%esp)
f0102898:	f0 
f0102899:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01028a0:	f0 
f01028a1:	c7 44 24 04 e9 03 00 	movl   $0x3e9,0x4(%esp)
f01028a8:	00 
f01028a9:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01028b0:	e8 8b d7 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01028b5:	ba 00 10 00 00       	mov    $0x1000,%edx
f01028ba:	89 f8                	mov    %edi,%eax
f01028bc:	e8 ed e6 ff ff       	call   f0100fae <check_va2pa>
f01028c1:	89 da                	mov    %ebx,%edx
f01028c3:	2b 15 9c 9e 2c f0    	sub    0xf02c9e9c,%edx
f01028c9:	c1 fa 03             	sar    $0x3,%edx
f01028cc:	c1 e2 0c             	shl    $0xc,%edx
f01028cf:	39 d0                	cmp    %edx,%eax
f01028d1:	74 24                	je     f01028f7 <mem_init+0x106b>
f01028d3:	c7 44 24 0c 24 8e 10 	movl   $0xf0108e24,0xc(%esp)
f01028da:	f0 
f01028db:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01028e2:	f0 
f01028e3:	c7 44 24 04 ea 03 00 	movl   $0x3ea,0x4(%esp)
f01028ea:	00 
f01028eb:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01028f2:	e8 49 d7 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 1);
f01028f7:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01028fc:	74 24                	je     f0102922 <mem_init+0x1096>
f01028fe:	c7 44 24 0c b4 94 10 	movl   $0xf01094b4,0xc(%esp)
f0102905:	f0 
f0102906:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010290d:	f0 
f010290e:	c7 44 24 04 eb 03 00 	movl   $0x3eb,0x4(%esp)
f0102915:	00 
f0102916:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010291d:	e8 1e d7 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102922:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102927:	74 24                	je     f010294d <mem_init+0x10c1>
f0102929:	c7 44 24 0c 0e 95 10 	movl   $0xf010950e,0xc(%esp)
f0102930:	f0 
f0102931:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102938:	f0 
f0102939:	c7 44 24 04 ec 03 00 	movl   $0x3ec,0x4(%esp)
f0102940:	00 
f0102941:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102948:	e8 f3 d6 ff ff       	call   f0100040 <_panic>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f010294d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0102954:	00 
f0102955:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010295c:	00 
f010295d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102961:	89 3c 24             	mov    %edi,(%esp)
f0102964:	e8 39 ee ff ff       	call   f01017a2 <page_insert>
f0102969:	85 c0                	test   %eax,%eax
f010296b:	74 24                	je     f0102991 <mem_init+0x1105>
f010296d:	c7 44 24 0c 9c 8e 10 	movl   $0xf0108e9c,0xc(%esp)
f0102974:	f0 
f0102975:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010297c:	f0 
f010297d:	c7 44 24 04 ef 03 00 	movl   $0x3ef,0x4(%esp)
f0102984:	00 
f0102985:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010298c:	e8 af d6 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref);
f0102991:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102996:	75 24                	jne    f01029bc <mem_init+0x1130>
f0102998:	c7 44 24 0c 1f 95 10 	movl   $0xf010951f,0xc(%esp)
f010299f:	f0 
f01029a0:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01029a7:	f0 
f01029a8:	c7 44 24 04 f0 03 00 	movl   $0x3f0,0x4(%esp)
f01029af:	00 
f01029b0:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01029b7:	e8 84 d6 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_link == NULL);
f01029bc:	83 3b 00             	cmpl   $0x0,(%ebx)
f01029bf:	74 24                	je     f01029e5 <mem_init+0x1159>
f01029c1:	c7 44 24 0c 2b 95 10 	movl   $0xf010952b,0xc(%esp)
f01029c8:	f0 
f01029c9:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01029d0:	f0 
f01029d1:	c7 44 24 04 f1 03 00 	movl   $0x3f1,0x4(%esp)
f01029d8:	00 
f01029d9:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01029e0:	e8 5b d6 ff ff       	call   f0100040 <_panic>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f01029e5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f01029ec:	00 
f01029ed:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f01029f2:	89 04 24             	mov    %eax,(%esp)
f01029f5:	e8 5f ed ff ff       	call   f0101759 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01029fa:	8b 3d 98 9e 2c f0    	mov    0xf02c9e98,%edi
f0102a00:	ba 00 00 00 00       	mov    $0x0,%edx
f0102a05:	89 f8                	mov    %edi,%eax
f0102a07:	e8 a2 e5 ff ff       	call   f0100fae <check_va2pa>
f0102a0c:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102a0f:	74 24                	je     f0102a35 <mem_init+0x11a9>
f0102a11:	c7 44 24 0c 78 8e 10 	movl   $0xf0108e78,0xc(%esp)
f0102a18:	f0 
f0102a19:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102a20:	f0 
f0102a21:	c7 44 24 04 f5 03 00 	movl   $0x3f5,0x4(%esp)
f0102a28:	00 
f0102a29:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102a30:	e8 0b d6 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f0102a35:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102a3a:	89 f8                	mov    %edi,%eax
f0102a3c:	e8 6d e5 ff ff       	call   f0100fae <check_va2pa>
f0102a41:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102a44:	74 24                	je     f0102a6a <mem_init+0x11de>
f0102a46:	c7 44 24 0c d4 8e 10 	movl   $0xf0108ed4,0xc(%esp)
f0102a4d:	f0 
f0102a4e:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102a55:	f0 
f0102a56:	c7 44 24 04 f6 03 00 	movl   $0x3f6,0x4(%esp)
f0102a5d:	00 
f0102a5e:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102a65:	e8 d6 d5 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0102a6a:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0102a6f:	74 24                	je     f0102a95 <mem_init+0x1209>
f0102a71:	c7 44 24 0c 40 95 10 	movl   $0xf0109540,0xc(%esp)
f0102a78:	f0 
f0102a79:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102a80:	f0 
f0102a81:	c7 44 24 04 f7 03 00 	movl   $0x3f7,0x4(%esp)
f0102a88:	00 
f0102a89:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102a90:	e8 ab d5 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 0);
f0102a95:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102a9a:	74 24                	je     f0102ac0 <mem_init+0x1234>
f0102a9c:	c7 44 24 0c 0e 95 10 	movl   $0xf010950e,0xc(%esp)
f0102aa3:	f0 
f0102aa4:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102aab:	f0 
f0102aac:	c7 44 24 04 f8 03 00 	movl   $0x3f8,0x4(%esp)
f0102ab3:	00 
f0102ab4:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102abb:	e8 80 d5 ff ff       	call   f0100040 <_panic>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f0102ac0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102ac7:	e8 8c e9 ff ff       	call   f0101458 <page_alloc>
f0102acc:	85 c0                	test   %eax,%eax
f0102ace:	74 04                	je     f0102ad4 <mem_init+0x1248>
f0102ad0:	39 c3                	cmp    %eax,%ebx
f0102ad2:	74 24                	je     f0102af8 <mem_init+0x126c>
f0102ad4:	c7 44 24 0c fc 8e 10 	movl   $0xf0108efc,0xc(%esp)
f0102adb:	f0 
f0102adc:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102ae3:	f0 
f0102ae4:	c7 44 24 04 fb 03 00 	movl   $0x3fb,0x4(%esp)
f0102aeb:	00 
f0102aec:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102af3:	e8 48 d5 ff ff       	call   f0100040 <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f0102af8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102aff:	e8 54 e9 ff ff       	call   f0101458 <page_alloc>
f0102b04:	85 c0                	test   %eax,%eax
f0102b06:	74 24                	je     f0102b2c <mem_init+0x12a0>
f0102b08:	c7 44 24 0c 62 94 10 	movl   $0xf0109462,0xc(%esp)
f0102b0f:	f0 
f0102b10:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102b17:	f0 
f0102b18:	c7 44 24 04 fe 03 00 	movl   $0x3fe,0x4(%esp)
f0102b1f:	00 
f0102b20:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102b27:	e8 14 d5 ff ff       	call   f0100040 <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102b2c:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102b31:	8b 08                	mov    (%eax),%ecx
f0102b33:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102b39:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0102b3c:	2b 15 9c 9e 2c f0    	sub    0xf02c9e9c,%edx
f0102b42:	c1 fa 03             	sar    $0x3,%edx
f0102b45:	c1 e2 0c             	shl    $0xc,%edx
f0102b48:	39 d1                	cmp    %edx,%ecx
f0102b4a:	74 24                	je     f0102b70 <mem_init+0x12e4>
f0102b4c:	c7 44 24 0c a0 8b 10 	movl   $0xf0108ba0,0xc(%esp)
f0102b53:	f0 
f0102b54:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102b5b:	f0 
f0102b5c:	c7 44 24 04 01 04 00 	movl   $0x401,0x4(%esp)
f0102b63:	00 
f0102b64:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102b6b:	e8 d0 d4 ff ff       	call   f0100040 <_panic>
	kern_pgdir[0] = 0;
f0102b70:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f0102b76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102b79:	66 83 78 04 01       	cmpw   $0x1,0x4(%eax)
f0102b7e:	74 24                	je     f0102ba4 <mem_init+0x1318>
f0102b80:	c7 44 24 0c c5 94 10 	movl   $0xf01094c5,0xc(%esp)
f0102b87:	f0 
f0102b88:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102b8f:	f0 
f0102b90:	c7 44 24 04 03 04 00 	movl   $0x403,0x4(%esp)
f0102b97:	00 
f0102b98:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102b9f:	e8 9c d4 ff ff       	call   f0100040 <_panic>
	pp0->pp_ref = 0;
f0102ba4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102ba7:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0102bad:	89 04 24             	mov    %eax,(%esp)
f0102bb0:	e8 5d e9 ff ff       	call   f0101512 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0102bb5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0102bbc:	00 
f0102bbd:	c7 44 24 04 00 10 40 	movl   $0x401000,0x4(%esp)
f0102bc4:	00 
f0102bc5:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102bca:	89 04 24             	mov    %eax,(%esp)
f0102bcd:	e8 cf e9 ff ff       	call   f01015a1 <pgdir_walk>
f0102bd2:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102bd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0102bd8:	8b 15 98 9e 2c f0    	mov    0xf02c9e98,%edx
f0102bde:	8b 7a 04             	mov    0x4(%edx),%edi
f0102be1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102be7:	8b 0d 94 9e 2c f0    	mov    0xf02c9e94,%ecx
f0102bed:	89 f8                	mov    %edi,%eax
f0102bef:	c1 e8 0c             	shr    $0xc,%eax
f0102bf2:	39 c8                	cmp    %ecx,%eax
f0102bf4:	72 20                	jb     f0102c16 <mem_init+0x138a>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102bf6:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0102bfa:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0102c01:	f0 
f0102c02:	c7 44 24 04 0a 04 00 	movl   $0x40a,0x4(%esp)
f0102c09:	00 
f0102c0a:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102c11:	e8 2a d4 ff ff       	call   f0100040 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102c16:	81 ef fc ff ff 0f    	sub    $0xffffffc,%edi
f0102c1c:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f0102c1f:	74 24                	je     f0102c45 <mem_init+0x13b9>
f0102c21:	c7 44 24 0c 51 95 10 	movl   $0xf0109551,0xc(%esp)
f0102c28:	f0 
f0102c29:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102c30:	f0 
f0102c31:	c7 44 24 04 0b 04 00 	movl   $0x40b,0x4(%esp)
f0102c38:	00 
f0102c39:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102c40:	e8 fb d3 ff ff       	call   f0100040 <_panic>
	kern_pgdir[PDX(va)] = 0;
f0102c45:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
	pp0->pp_ref = 0;
f0102c4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102c4f:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0102c55:	2b 05 9c 9e 2c f0    	sub    0xf02c9e9c,%eax
f0102c5b:	c1 f8 03             	sar    $0x3,%eax
f0102c5e:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102c61:	89 c2                	mov    %eax,%edx
f0102c63:	c1 ea 0c             	shr    $0xc,%edx
f0102c66:	39 d1                	cmp    %edx,%ecx
f0102c68:	77 20                	ja     f0102c8a <mem_init+0x13fe>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102c6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102c6e:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0102c75:	f0 
f0102c76:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0102c7d:	00 
f0102c7e:	c7 04 24 b1 92 10 f0 	movl   $0xf01092b1,(%esp)
f0102c85:	e8 b6 d3 ff ff       	call   f0100040 <_panic>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0102c8a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102c91:	00 
f0102c92:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
f0102c99:	00 
	return (void *)(pa + KERNBASE);
f0102c9a:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102c9f:	89 04 24             	mov    %eax,(%esp)
f0102ca2:	e8 10 3b 00 00       	call   f01067b7 <memset>
	page_free(pp0);
f0102ca7:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f0102caa:	89 3c 24             	mov    %edi,(%esp)
f0102cad:	e8 60 e8 ff ff       	call   f0101512 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f0102cb2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0102cb9:	00 
f0102cba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102cc1:	00 
f0102cc2:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102cc7:	89 04 24             	mov    %eax,(%esp)
f0102cca:	e8 d2 e8 ff ff       	call   f01015a1 <pgdir_walk>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0102ccf:	89 fa                	mov    %edi,%edx
f0102cd1:	2b 15 9c 9e 2c f0    	sub    0xf02c9e9c,%edx
f0102cd7:	c1 fa 03             	sar    $0x3,%edx
f0102cda:	c1 e2 0c             	shl    $0xc,%edx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0102cdd:	89 d0                	mov    %edx,%eax
f0102cdf:	c1 e8 0c             	shr    $0xc,%eax
f0102ce2:	3b 05 94 9e 2c f0    	cmp    0xf02c9e94,%eax
f0102ce8:	72 20                	jb     f0102d0a <mem_init+0x147e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102cea:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0102cee:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0102cf5:	f0 
f0102cf6:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0102cfd:	00 
f0102cfe:	c7 04 24 b1 92 10 f0 	movl   $0xf01092b1,(%esp)
f0102d05:	e8 36 d3 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0102d0a:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0102d10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0102d13:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0102d19:	f6 00 01             	testb  $0x1,(%eax)
f0102d1c:	74 24                	je     f0102d42 <mem_init+0x14b6>
f0102d1e:	c7 44 24 0c 69 95 10 	movl   $0xf0109569,0xc(%esp)
f0102d25:	f0 
f0102d26:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102d2d:	f0 
f0102d2e:	c7 44 24 04 15 04 00 	movl   $0x415,0x4(%esp)
f0102d35:	00 
f0102d36:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102d3d:	e8 fe d2 ff ff       	call   f0100040 <_panic>
f0102d42:	83 c0 04             	add    $0x4,%eax
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
f0102d45:	39 d0                	cmp    %edx,%eax
f0102d47:	75 d0                	jne    f0102d19 <mem_init+0x148d>
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
f0102d49:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102d4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102d54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102d57:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)

	// give free list back
	page_free_list = fl;
f0102d5d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0102d60:	89 0d 40 92 2c f0    	mov    %ecx,0xf02c9240

	// free the pages we took
	page_free(pp0);
f0102d66:	89 04 24             	mov    %eax,(%esp)
f0102d69:	e8 a4 e7 ff ff       	call   f0101512 <page_free>
	page_free(pp1);
f0102d6e:	89 1c 24             	mov    %ebx,(%esp)
f0102d71:	e8 9c e7 ff ff       	call   f0101512 <page_free>
	page_free(pp2);
f0102d76:	89 34 24             	mov    %esi,(%esp)
f0102d79:	e8 94 e7 ff ff       	call   f0101512 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0102d7e:	c7 44 24 04 01 10 00 	movl   $0x1001,0x4(%esp)
f0102d85:	00 
f0102d86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102d8d:	e8 8b ea ff ff       	call   f010181d <mmio_map_region>
f0102d92:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0102d94:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102d9b:	00 
f0102d9c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102da3:	e8 75 ea ff ff       	call   f010181d <mmio_map_region>
f0102da8:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f0102daa:	8d 83 a0 1f 00 00    	lea    0x1fa0(%ebx),%eax
f0102db0:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0102db5:	77 08                	ja     f0102dbf <mem_init+0x1533>
f0102db7:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f0102dbd:	77 24                	ja     f0102de3 <mem_init+0x1557>
f0102dbf:	c7 44 24 0c 20 8f 10 	movl   $0xf0108f20,0xc(%esp)
f0102dc6:	f0 
f0102dc7:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102dce:	f0 
f0102dcf:	c7 44 24 04 25 04 00 	movl   $0x425,0x4(%esp)
f0102dd6:	00 
f0102dd7:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102dde:	e8 5d d2 ff ff       	call   f0100040 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
f0102de3:	8d 96 a0 1f 00 00    	lea    0x1fa0(%esi),%edx
f0102de9:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0102def:	77 08                	ja     f0102df9 <mem_init+0x156d>
f0102df1:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0102df7:	77 24                	ja     f0102e1d <mem_init+0x1591>
f0102df9:	c7 44 24 0c 48 8f 10 	movl   $0xf0108f48,0xc(%esp)
f0102e00:	f0 
f0102e01:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102e08:	f0 
f0102e09:	c7 44 24 04 26 04 00 	movl   $0x426,0x4(%esp)
f0102e10:	00 
f0102e11:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102e18:	e8 23 d2 ff ff       	call   f0100040 <_panic>
f0102e1d:	89 da                	mov    %ebx,%edx
f0102e1f:	09 f2                	or     %esi,%edx
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102e21:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f0102e27:	74 24                	je     f0102e4d <mem_init+0x15c1>
f0102e29:	c7 44 24 0c 70 8f 10 	movl   $0xf0108f70,0xc(%esp)
f0102e30:	f0 
f0102e31:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102e38:	f0 
f0102e39:	c7 44 24 04 28 04 00 	movl   $0x428,0x4(%esp)
f0102e40:	00 
f0102e41:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102e48:	e8 f3 d1 ff ff       	call   f0100040 <_panic>
	// check that they don't overlap
	assert(mm1 + 8096 <= mm2);
f0102e4d:	39 c6                	cmp    %eax,%esi
f0102e4f:	73 24                	jae    f0102e75 <mem_init+0x15e9>
f0102e51:	c7 44 24 0c 80 95 10 	movl   $0xf0109580,0xc(%esp)
f0102e58:	f0 
f0102e59:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102e60:	f0 
f0102e61:	c7 44 24 04 2a 04 00 	movl   $0x42a,0x4(%esp)
f0102e68:	00 
f0102e69:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102e70:	e8 cb d1 ff ff       	call   f0100040 <_panic>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102e75:	8b 3d 98 9e 2c f0    	mov    0xf02c9e98,%edi
f0102e7b:	89 da                	mov    %ebx,%edx
f0102e7d:	89 f8                	mov    %edi,%eax
f0102e7f:	e8 2a e1 ff ff       	call   f0100fae <check_va2pa>
f0102e84:	85 c0                	test   %eax,%eax
f0102e86:	74 24                	je     f0102eac <mem_init+0x1620>
f0102e88:	c7 44 24 0c 98 8f 10 	movl   $0xf0108f98,0xc(%esp)
f0102e8f:	f0 
f0102e90:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102e97:	f0 
f0102e98:	c7 44 24 04 2c 04 00 	movl   $0x42c,0x4(%esp)
f0102e9f:	00 
f0102ea0:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102ea7:	e8 94 d1 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102eac:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0102eb2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102eb5:	89 c2                	mov    %eax,%edx
f0102eb7:	89 f8                	mov    %edi,%eax
f0102eb9:	e8 f0 e0 ff ff       	call   f0100fae <check_va2pa>
f0102ebe:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0102ec3:	74 24                	je     f0102ee9 <mem_init+0x165d>
f0102ec5:	c7 44 24 0c bc 8f 10 	movl   $0xf0108fbc,0xc(%esp)
f0102ecc:	f0 
f0102ecd:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102ed4:	f0 
f0102ed5:	c7 44 24 04 2d 04 00 	movl   $0x42d,0x4(%esp)
f0102edc:	00 
f0102edd:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102ee4:	e8 57 d1 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102ee9:	89 f2                	mov    %esi,%edx
f0102eeb:	89 f8                	mov    %edi,%eax
f0102eed:	e8 bc e0 ff ff       	call   f0100fae <check_va2pa>
f0102ef2:	85 c0                	test   %eax,%eax
f0102ef4:	74 24                	je     f0102f1a <mem_init+0x168e>
f0102ef6:	c7 44 24 0c ec 8f 10 	movl   $0xf0108fec,0xc(%esp)
f0102efd:	f0 
f0102efe:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102f05:	f0 
f0102f06:	c7 44 24 04 2e 04 00 	movl   $0x42e,0x4(%esp)
f0102f0d:	00 
f0102f0e:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102f15:	e8 26 d1 ff ff       	call   f0100040 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102f1a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0102f20:	89 f8                	mov    %edi,%eax
f0102f22:	e8 87 e0 ff ff       	call   f0100fae <check_va2pa>
f0102f27:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102f2a:	74 24                	je     f0102f50 <mem_init+0x16c4>
f0102f2c:	c7 44 24 0c 10 90 10 	movl   $0xf0109010,0xc(%esp)
f0102f33:	f0 
f0102f34:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102f3b:	f0 
f0102f3c:	c7 44 24 04 2f 04 00 	movl   $0x42f,0x4(%esp)
f0102f43:	00 
f0102f44:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102f4b:	e8 f0 d0 ff ff       	call   f0100040 <_panic>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102f50:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102f57:	00 
f0102f58:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102f5c:	89 3c 24             	mov    %edi,(%esp)
f0102f5f:	e8 3d e6 ff ff       	call   f01015a1 <pgdir_walk>
f0102f64:	f6 00 1a             	testb  $0x1a,(%eax)
f0102f67:	75 24                	jne    f0102f8d <mem_init+0x1701>
f0102f69:	c7 44 24 0c 3c 90 10 	movl   $0xf010903c,0xc(%esp)
f0102f70:	f0 
f0102f71:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102f78:	f0 
f0102f79:	c7 44 24 04 31 04 00 	movl   $0x431,0x4(%esp)
f0102f80:	00 
f0102f81:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102f88:	e8 b3 d0 ff ff       	call   f0100040 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102f8d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102f94:	00 
f0102f95:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102f99:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102f9e:	89 04 24             	mov    %eax,(%esp)
f0102fa1:	e8 fb e5 ff ff       	call   f01015a1 <pgdir_walk>
f0102fa6:	f6 00 04             	testb  $0x4,(%eax)
f0102fa9:	74 24                	je     f0102fcf <mem_init+0x1743>
f0102fab:	c7 44 24 0c 80 90 10 	movl   $0xf0109080,0xc(%esp)
f0102fb2:	f0 
f0102fb3:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0102fba:	f0 
f0102fbb:	c7 44 24 04 32 04 00 	movl   $0x432,0x4(%esp)
f0102fc2:	00 
f0102fc3:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0102fca:	e8 71 d0 ff ff       	call   f0100040 <_panic>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102fcf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102fd6:	00 
f0102fd7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0102fdb:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0102fe0:	89 04 24             	mov    %eax,(%esp)
f0102fe3:	e8 b9 e5 ff ff       	call   f01015a1 <pgdir_walk>
f0102fe8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0102fee:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102ff5:	00 
f0102ff6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102ff9:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102ffd:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0103002:	89 04 24             	mov    %eax,(%esp)
f0103005:	e8 97 e5 ff ff       	call   f01015a1 <pgdir_walk>
f010300a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0103010:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0103017:	00 
f0103018:	89 74 24 04          	mov    %esi,0x4(%esp)
f010301c:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0103021:	89 04 24             	mov    %eax,(%esp)
f0103024:	e8 78 e5 ff ff       	call   f01015a1 <pgdir_walk>
f0103029:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f010302f:	c7 04 24 92 95 10 f0 	movl   $0xf0109592,(%esp)
f0103036:	e8 07 13 00 00       	call   f0104342 <cprintf>
	// Permissions:
	//    - the new image at UPAGES -- kernel R, user R
	//      (ie. perm = PTE_U | PTE_P)
	//    - pages itself -- kernel RW, user NONE
	// Your code goes here:
 	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U | PTE_P);
f010303b:	a1 9c 9e 2c f0       	mov    0xf02c9e9c,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103040:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103045:	77 20                	ja     f0103067 <mem_init+0x17db>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103047:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010304b:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f0103052:	f0 
f0103053:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
f010305a:	00 
f010305b:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0103062:	e8 d9 cf ff ff       	call   f0100040 <_panic>
f0103067:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
f010306e:	00 
	return (physaddr_t)kva - KERNBASE;
f010306f:	05 00 00 00 10       	add    $0x10000000,%eax
f0103074:	89 04 24             	mov    %eax,(%esp)
f0103077:	b9 00 00 40 00       	mov    $0x400000,%ecx
f010307c:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0103081:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0103086:	e8 b6 e5 ff ff       	call   f0101641 <boot_map_region>
	// (ie. perm = PTE_U | PTE_P).
	// Permissions:
	//    - the new image at UENVS  -- kernel R, user R
	//    - envs itself -- kernel RW, user NONE
	// LAB 3: Your code here.
 	boot_map_region(kern_pgdir, UENVS, PTSIZE, PADDR(envs), PTE_U | PTE_P);
f010308b:	a1 48 92 2c f0       	mov    0xf02c9248,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103090:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103095:	77 20                	ja     f01030b7 <mem_init+0x182b>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103097:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010309b:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f01030a2:	f0 
f01030a3:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
f01030aa:	00 
f01030ab:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01030b2:	e8 89 cf ff ff       	call   f0100040 <_panic>
f01030b7:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
f01030be:	00 
	return (physaddr_t)kva - KERNBASE;
f01030bf:	05 00 00 00 10       	add    $0x10000000,%eax
f01030c4:	89 04 24             	mov    %eax,(%esp)
f01030c7:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01030cc:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01030d1:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f01030d6:	e8 66 e5 ff ff       	call   f0101641 <boot_map_region>
	//      the PA range [0, 2^32 - KERNBASE)
	// We might not have 2^32 - KERNBASE bytes of physical memory, but
	// we just set up the mapping anyway.
	// Permissions: kernel RW, user NONE
	// Your code goes here:
  	boot_map_region(kern_pgdir, KERNBASE, 0xffffffff - KERNBASE, 0, PTE_W | PTE_P);
f01030db:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f01030e2:	00 
f01030e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01030ea:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f01030ef:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f01030f4:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f01030f9:	e8 43 e5 ff ff       	call   f0101641 <boot_map_region>
f01030fe:	bb 00 b0 2c f0       	mov    $0xf02cb000,%ebx
	//             Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	//
	// LAB 4: Your code here:
	uint32_t i;
	uint32_t bottom_stack = KSTACKTOP - KSTKSIZE;
f0103103:	be 00 80 ff ef       	mov    $0xefff8000,%esi
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103108:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f010310e:	77 20                	ja     f0103130 <mem_init+0x18a4>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103110:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0103114:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f010311b:	f0 
f010311c:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
f0103123:	00 
f0103124:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010312b:	e8 10 cf ff ff       	call   f0100040 <_panic>
	for (i = 0; i < NCPU; i++) {
		boot_map_region(kern_pgdir, bottom_stack, KSTKSIZE, PADDR(percpu_kstacks[i]), PTE_W | PTE_P);
f0103130:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f0103137:	00 
f0103138:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f010313e:	89 04 24             	mov    %eax,(%esp)
f0103141:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0103146:	89 f2                	mov    %esi,%edx
f0103148:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f010314d:	e8 ef e4 ff ff       	call   f0101641 <boot_map_region>
		bottom_stack -= KSTKGAP; // guard
		bottom_stack -= KSTKSIZE;
f0103152:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0103158:	81 c3 00 80 00 00    	add    $0x8000,%ebx
	//     Permissions: kernel RW, user NONE
	//
	// LAB 4: Your code here:
	uint32_t i;
	uint32_t bottom_stack = KSTACKTOP - KSTKSIZE;
	for (i = 0; i < NCPU; i++) {
f010315e:	81 fe 00 80 f7 ef    	cmp    $0xeff78000,%esi
f0103164:	75 a2                	jne    f0103108 <mem_init+0x187c>
check_kern_pgdir(void)
{
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = kern_pgdir;
f0103166:	8b 3d 98 9e 2c f0    	mov    0xf02c9e98,%edi

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f010316c:	a1 94 9e 2c f0       	mov    0xf02c9e94,%eax
f0103171:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0103174:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f010317b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103180:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0103183:	a1 9c 9e 2c f0       	mov    0xf02c9e9c,%eax
f0103188:	89 45 c8             	mov    %eax,-0x38(%ebp)
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010318b:	89 45 d0             	mov    %eax,-0x30(%ebp)
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
	return (physaddr_t)kva - KERNBASE;
f010318e:	8d b0 00 00 00 10    	lea    0x10000000(%eax),%esi

	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f0103194:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103199:	eb 6a                	jmp    f0103205 <mem_init+0x1979>
f010319b:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01031a1:	89 f8                	mov    %edi,%eax
f01031a3:	e8 06 de ff ff       	call   f0100fae <check_va2pa>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01031a8:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f01031af:	77 23                	ja     f01031d4 <mem_init+0x1948>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01031b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
f01031b4:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01031b8:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f01031bf:	f0 
f01031c0:	c7 44 24 04 4a 03 00 	movl   $0x34a,0x4(%esp)
f01031c7:	00 
f01031c8:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01031cf:	e8 6c ce ff ff       	call   f0100040 <_panic>
f01031d4:	8d 14 33             	lea    (%ebx,%esi,1),%edx
f01031d7:	39 d0                	cmp    %edx,%eax
f01031d9:	74 24                	je     f01031ff <mem_init+0x1973>
f01031db:	c7 44 24 0c b4 90 10 	movl   $0xf01090b4,0xc(%esp)
f01031e2:	f0 
f01031e3:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01031ea:	f0 
f01031eb:	c7 44 24 04 4a 03 00 	movl   $0x34a,0x4(%esp)
f01031f2:	00 
f01031f3:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01031fa:	e8 41 ce ff ff       	call   f0100040 <_panic>

	pgdir = kern_pgdir;

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f01031ff:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103205:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0103208:	77 91                	ja     f010319b <mem_init+0x190f>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f010320a:	8b 1d 48 92 2c f0    	mov    0xf02c9248,%ebx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103210:	89 de                	mov    %ebx,%esi
f0103212:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0103217:	89 f8                	mov    %edi,%eax
f0103219:	e8 90 dd ff ff       	call   f0100fae <check_va2pa>
f010321e:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0103224:	77 20                	ja     f0103246 <mem_init+0x19ba>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103226:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010322a:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f0103231:	f0 
f0103232:	c7 44 24 04 4f 03 00 	movl   $0x34f,0x4(%esp)
f0103239:	00 
f010323a:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0103241:	e8 fa cd ff ff       	call   f0100040 <_panic>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103246:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f010324b:	81 c6 00 00 40 21    	add    $0x21400000,%esi
f0103251:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0103254:	39 d0                	cmp    %edx,%eax
f0103256:	74 24                	je     f010327c <mem_init+0x19f0>
f0103258:	c7 44 24 0c e8 90 10 	movl   $0xf01090e8,0xc(%esp)
f010325f:	f0 
f0103260:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0103267:	f0 
f0103268:	c7 44 24 04 4f 03 00 	movl   $0x34f,0x4(%esp)
f010326f:	00 
f0103270:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0103277:	e8 c4 cd ff ff       	call   f0100040 <_panic>
f010327c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f0103282:	81 fb 00 00 c2 ee    	cmp    $0xeec20000,%ebx
f0103288:	0f 85 57 06 00 00    	jne    f01038e5 <mem_init+0x2059>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f010328e:	8b 75 cc             	mov    -0x34(%ebp),%esi
f0103291:	c1 e6 0c             	shl    $0xc,%esi
f0103294:	bb 00 00 00 00       	mov    $0x0,%ebx
f0103299:	eb 3b                	jmp    f01032d6 <mem_init+0x1a4a>
f010329b:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f01032a1:	89 f8                	mov    %edi,%eax
f01032a3:	e8 06 dd ff ff       	call   f0100fae <check_va2pa>
f01032a8:	39 c3                	cmp    %eax,%ebx
f01032aa:	74 24                	je     f01032d0 <mem_init+0x1a44>
f01032ac:	c7 44 24 0c 1c 91 10 	movl   $0xf010911c,0xc(%esp)
f01032b3:	f0 
f01032b4:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01032bb:	f0 
f01032bc:	c7 44 24 04 53 03 00 	movl   $0x353,0x4(%esp)
f01032c3:	00 
f01032c4:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01032cb:	e8 70 cd ff ff       	call   f0100040 <_panic>
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);

	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f01032d0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f01032d6:	39 f3                	cmp    %esi,%ebx
f01032d8:	72 c1                	jb     f010329b <mem_init+0x1a0f>
f01032da:	c7 45 cc 00 b0 2c f0 	movl   $0xf02cb000,-0x34(%ebp)
f01032e1:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
f01032e8:	be 00 80 ff ef       	mov    $0xefff8000,%esi
f01032ed:	b8 00 b0 2c f0       	mov    $0xf02cb000,%eax
f01032f2:	05 00 80 00 20       	add    $0x20008000,%eax
f01032f7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f01032fa:	8d 86 00 80 00 00    	lea    0x8000(%esi),%eax
f0103300:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0103303:	89 f2                	mov    %esi,%edx
f0103305:	89 f8                	mov    %edi,%eax
f0103307:	e8 a2 dc ff ff       	call   f0100fae <check_va2pa>
f010330c:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f010330f:	81 f9 ff ff ff ef    	cmp    $0xefffffff,%ecx
f0103315:	77 20                	ja     f0103337 <mem_init+0x1aab>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103317:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f010331b:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f0103322:	f0 
f0103323:	c7 44 24 04 5b 03 00 	movl   $0x35b,0x4(%esp)
f010332a:	00 
f010332b:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0103332:	e8 09 cd ff ff       	call   f0100040 <_panic>
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103337:	89 f3                	mov    %esi,%ebx
f0103339:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f010333c:	03 4d d0             	add    -0x30(%ebp),%ecx
f010333f:	89 75 c8             	mov    %esi,-0x38(%ebp)
f0103342:	89 ce                	mov    %ecx,%esi
f0103344:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0103347:	39 c2                	cmp    %eax,%edx
f0103349:	74 24                	je     f010336f <mem_init+0x1ae3>
f010334b:	c7 44 24 0c 44 91 10 	movl   $0xf0109144,0xc(%esp)
f0103352:	f0 
f0103353:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010335a:	f0 
f010335b:	c7 44 24 04 5b 03 00 	movl   $0x35b,0x4(%esp)
f0103362:	00 
f0103363:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010336a:	e8 d1 cc ff ff       	call   f0100040 <_panic>
f010336f:	81 c3 00 10 00 00    	add    $0x1000,%ebx

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0103375:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f0103378:	0f 85 56 05 00 00    	jne    f01038d4 <mem_init+0x2048>
f010337e:	8b 75 c8             	mov    -0x38(%ebp),%esi
f0103381:	8d 9e 00 80 ff ff    	lea    -0x8000(%esi),%ebx
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
				== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
f0103387:	89 da                	mov    %ebx,%edx
f0103389:	89 f8                	mov    %edi,%eax
f010338b:	e8 1e dc ff ff       	call   f0100fae <check_va2pa>
f0103390:	83 f8 ff             	cmp    $0xffffffff,%eax
f0103393:	74 24                	je     f01033b9 <mem_init+0x1b2d>
f0103395:	c7 44 24 0c 8c 91 10 	movl   $0xf010918c,0xc(%esp)
f010339c:	f0 
f010339d:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01033a4:	f0 
f01033a5:	c7 44 24 04 5d 03 00 	movl   $0x35d,0x4(%esp)
f01033ac:	00 
f01033ad:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01033b4:	e8 87 cc ff ff       	call   f0100040 <_panic>
f01033b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
				== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f01033bf:	39 f3                	cmp    %esi,%ebx
f01033c1:	75 c4                	jne    f0103387 <mem_init+0x1afb>
f01033c3:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f01033c9:	81 45 d0 00 80 01 00 	addl   $0x18000,-0x30(%ebp)
f01033d0:	81 45 cc 00 80 00 00 	addl   $0x8000,-0x34(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
f01033d7:	81 fe 00 80 f7 ef    	cmp    $0xeff78000,%esi
f01033dd:	0f 85 17 ff ff ff    	jne    f01032fa <mem_init+0x1a6e>
f01033e3:	b8 00 00 00 00       	mov    $0x0,%eax
f01033e8:	e9 c2 00 00 00       	jmp    f01034af <mem_init+0x1c23>
			assert(check_va2pa(pgdir, base + i) == ~0);
	}

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
		switch (i) {
f01033ed:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f01033f3:	83 fa 04             	cmp    $0x4,%edx
f01033f6:	77 2e                	ja     f0103426 <mem_init+0x1b9a>
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
		case PDX(UENVS):
		case PDX(MMIOBASE):
			assert(pgdir[i] & PTE_P);
f01033f8:	f6 04 87 01          	testb  $0x1,(%edi,%eax,4)
f01033fc:	0f 85 aa 00 00 00    	jne    f01034ac <mem_init+0x1c20>
f0103402:	c7 44 24 0c ab 95 10 	movl   $0xf01095ab,0xc(%esp)
f0103409:	f0 
f010340a:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0103411:	f0 
f0103412:	c7 44 24 04 68 03 00 	movl   $0x368,0x4(%esp)
f0103419:	00 
f010341a:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0103421:	e8 1a cc ff ff       	call   f0100040 <_panic>
			break;
		default:
			if (i >= PDX(KERNBASE)) {
f0103426:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f010342b:	76 55                	jbe    f0103482 <mem_init+0x1bf6>
				assert(pgdir[i] & PTE_P);
f010342d:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0103430:	f6 c2 01             	test   $0x1,%dl
f0103433:	75 24                	jne    f0103459 <mem_init+0x1bcd>
f0103435:	c7 44 24 0c ab 95 10 	movl   $0xf01095ab,0xc(%esp)
f010343c:	f0 
f010343d:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0103444:	f0 
f0103445:	c7 44 24 04 6c 03 00 	movl   $0x36c,0x4(%esp)
f010344c:	00 
f010344d:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0103454:	e8 e7 cb ff ff       	call   f0100040 <_panic>
				assert(pgdir[i] & PTE_W);
f0103459:	f6 c2 02             	test   $0x2,%dl
f010345c:	75 4e                	jne    f01034ac <mem_init+0x1c20>
f010345e:	c7 44 24 0c bc 95 10 	movl   $0xf01095bc,0xc(%esp)
f0103465:	f0 
f0103466:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010346d:	f0 
f010346e:	c7 44 24 04 6d 03 00 	movl   $0x36d,0x4(%esp)
f0103475:	00 
f0103476:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010347d:	e8 be cb ff ff       	call   f0100040 <_panic>
			} else
				assert(pgdir[i] == 0);
f0103482:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f0103486:	74 24                	je     f01034ac <mem_init+0x1c20>
f0103488:	c7 44 24 0c cd 95 10 	movl   $0xf01095cd,0xc(%esp)
f010348f:	f0 
f0103490:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0103497:	f0 
f0103498:	c7 44 24 04 6f 03 00 	movl   $0x36f,0x4(%esp)
f010349f:	00 
f01034a0:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01034a7:	e8 94 cb ff ff       	call   f0100040 <_panic>
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
	}

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
f01034ac:	83 c0 01             	add    $0x1,%eax
f01034af:	3d 00 04 00 00       	cmp    $0x400,%eax
f01034b4:	0f 85 33 ff ff ff    	jne    f01033ed <mem_init+0x1b61>
			} else
				assert(pgdir[i] == 0);
			break;
		}
	}
	cprintf("check_kern_pgdir() succeeded!\n");
f01034ba:	c7 04 24 b0 91 10 f0 	movl   $0xf01091b0,(%esp)
f01034c1:	e8 7c 0e 00 00       	call   f0104342 <cprintf>
	// somewhere between KERNBASE and KERNBASE+4MB right now, which is
	// mapped the same way by both page tables.
	//
	// If the machine reboots at this point, you've probably set up your
	// kern_pgdir wrong.
	lcr3(PADDR(kern_pgdir));
f01034c6:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f01034cb:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01034d0:	77 20                	ja     f01034f2 <mem_init+0x1c66>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01034d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01034d6:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f01034dd:	f0 
f01034de:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
f01034e5:	00 
f01034e6:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01034ed:	e8 4e cb ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01034f2:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01034f7:	0f 22 d8             	mov    %eax,%cr3

	check_page_free_list(0);
f01034fa:	b8 00 00 00 00       	mov    $0x0,%eax
f01034ff:	e8 19 db ff ff       	call   f010101d <check_page_free_list>

static inline uint32_t
rcr0(void)
{
	uint32_t val;
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0103504:	0f 20 c0             	mov    %cr0,%eax

	// entry.S set the really important flags in cr0 (including enabling
	// paging).  Here we configure the rest of the flags that we care about.
	cr0 = rcr0();
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_MP;
	cr0 &= ~(CR0_TS|CR0_EM);
f0103507:	83 e0 f3             	and    $0xfffffff3,%eax
f010350a:	0d 23 00 05 80       	or     $0x80050023,%eax
}

static inline void
lcr0(uint32_t val)
{
	asm volatile("movl %0,%%cr0" : : "r" (val));
f010350f:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0103512:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103519:	e8 3a df ff ff       	call   f0101458 <page_alloc>
f010351e:	89 c3                	mov    %eax,%ebx
f0103520:	85 c0                	test   %eax,%eax
f0103522:	75 24                	jne    f0103548 <mem_init+0x1cbc>
f0103524:	c7 44 24 0c b7 93 10 	movl   $0xf01093b7,0xc(%esp)
f010352b:	f0 
f010352c:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0103533:	f0 
f0103534:	c7 44 24 04 47 04 00 	movl   $0x447,0x4(%esp)
f010353b:	00 
f010353c:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0103543:	e8 f8 ca ff ff       	call   f0100040 <_panic>
	assert((pp1 = page_alloc(0)));
f0103548:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010354f:	e8 04 df ff ff       	call   f0101458 <page_alloc>
f0103554:	89 c7                	mov    %eax,%edi
f0103556:	85 c0                	test   %eax,%eax
f0103558:	75 24                	jne    f010357e <mem_init+0x1cf2>
f010355a:	c7 44 24 0c cd 93 10 	movl   $0xf01093cd,0xc(%esp)
f0103561:	f0 
f0103562:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0103569:	f0 
f010356a:	c7 44 24 04 48 04 00 	movl   $0x448,0x4(%esp)
f0103571:	00 
f0103572:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0103579:	e8 c2 ca ff ff       	call   f0100040 <_panic>
	assert((pp2 = page_alloc(0)));
f010357e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103585:	e8 ce de ff ff       	call   f0101458 <page_alloc>
f010358a:	89 c6                	mov    %eax,%esi
f010358c:	85 c0                	test   %eax,%eax
f010358e:	75 24                	jne    f01035b4 <mem_init+0x1d28>
f0103590:	c7 44 24 0c e3 93 10 	movl   $0xf01093e3,0xc(%esp)
f0103597:	f0 
f0103598:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010359f:	f0 
f01035a0:	c7 44 24 04 49 04 00 	movl   $0x449,0x4(%esp)
f01035a7:	00 
f01035a8:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01035af:	e8 8c ca ff ff       	call   f0100040 <_panic>
	page_free(pp0);
f01035b4:	89 1c 24             	mov    %ebx,(%esp)
f01035b7:	e8 56 df ff ff       	call   f0101512 <page_free>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01035bc:	89 f8                	mov    %edi,%eax
f01035be:	2b 05 9c 9e 2c f0    	sub    0xf02c9e9c,%eax
f01035c4:	c1 f8 03             	sar    $0x3,%eax
f01035c7:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01035ca:	89 c2                	mov    %eax,%edx
f01035cc:	c1 ea 0c             	shr    $0xc,%edx
f01035cf:	3b 15 94 9e 2c f0    	cmp    0xf02c9e94,%edx
f01035d5:	72 20                	jb     f01035f7 <mem_init+0x1d6b>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01035d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01035db:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f01035e2:	f0 
f01035e3:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f01035ea:	00 
f01035eb:	c7 04 24 b1 92 10 f0 	movl   $0xf01092b1,(%esp)
f01035f2:	e8 49 ca ff ff       	call   f0100040 <_panic>
	memset(page2kva(pp1), 1, PGSIZE);
f01035f7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01035fe:	00 
f01035ff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0103606:	00 
	return (void *)(pa + KERNBASE);
f0103607:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010360c:	89 04 24             	mov    %eax,(%esp)
f010360f:	e8 a3 31 00 00       	call   f01067b7 <memset>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0103614:	89 f0                	mov    %esi,%eax
f0103616:	2b 05 9c 9e 2c f0    	sub    0xf02c9e9c,%eax
f010361c:	c1 f8 03             	sar    $0x3,%eax
f010361f:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103622:	89 c2                	mov    %eax,%edx
f0103624:	c1 ea 0c             	shr    $0xc,%edx
f0103627:	3b 15 94 9e 2c f0    	cmp    0xf02c9e94,%edx
f010362d:	72 20                	jb     f010364f <mem_init+0x1dc3>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010362f:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103633:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f010363a:	f0 
f010363b:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0103642:	00 
f0103643:	c7 04 24 b1 92 10 f0 	movl   $0xf01092b1,(%esp)
f010364a:	e8 f1 c9 ff ff       	call   f0100040 <_panic>
	memset(page2kva(pp2), 2, PGSIZE);
f010364f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0103656:	00 
f0103657:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
f010365e:	00 
	return (void *)(pa + KERNBASE);
f010365f:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0103664:	89 04 24             	mov    %eax,(%esp)
f0103667:	e8 4b 31 00 00       	call   f01067b7 <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f010366c:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f0103673:	00 
f0103674:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010367b:	00 
f010367c:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0103680:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0103685:	89 04 24             	mov    %eax,(%esp)
f0103688:	e8 15 e1 ff ff       	call   f01017a2 <page_insert>
	assert(pp1->pp_ref == 1);
f010368d:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0103692:	74 24                	je     f01036b8 <mem_init+0x1e2c>
f0103694:	c7 44 24 0c b4 94 10 	movl   $0xf01094b4,0xc(%esp)
f010369b:	f0 
f010369c:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01036a3:	f0 
f01036a4:	c7 44 24 04 4e 04 00 	movl   $0x44e,0x4(%esp)
f01036ab:	00 
f01036ac:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01036b3:	e8 88 c9 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01036b8:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f01036bf:	01 01 01 
f01036c2:	74 24                	je     f01036e8 <mem_init+0x1e5c>
f01036c4:	c7 44 24 0c d0 91 10 	movl   $0xf01091d0,0xc(%esp)
f01036cb:	f0 
f01036cc:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01036d3:	f0 
f01036d4:	c7 44 24 04 4f 04 00 	movl   $0x44f,0x4(%esp)
f01036db:	00 
f01036dc:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01036e3:	e8 58 c9 ff ff       	call   f0100040 <_panic>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f01036e8:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01036ef:	00 
f01036f0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01036f7:	00 
f01036f8:	89 74 24 04          	mov    %esi,0x4(%esp)
f01036fc:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0103701:	89 04 24             	mov    %eax,(%esp)
f0103704:	e8 99 e0 ff ff       	call   f01017a2 <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f0103709:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0103710:	02 02 02 
f0103713:	74 24                	je     f0103739 <mem_init+0x1ead>
f0103715:	c7 44 24 0c f4 91 10 	movl   $0xf01091f4,0xc(%esp)
f010371c:	f0 
f010371d:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0103724:	f0 
f0103725:	c7 44 24 04 51 04 00 	movl   $0x451,0x4(%esp)
f010372c:	00 
f010372d:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0103734:	e8 07 c9 ff ff       	call   f0100040 <_panic>
	assert(pp2->pp_ref == 1);
f0103739:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f010373e:	74 24                	je     f0103764 <mem_init+0x1ed8>
f0103740:	c7 44 24 0c d6 94 10 	movl   $0xf01094d6,0xc(%esp)
f0103747:	f0 
f0103748:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010374f:	f0 
f0103750:	c7 44 24 04 52 04 00 	movl   $0x452,0x4(%esp)
f0103757:	00 
f0103758:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010375f:	e8 dc c8 ff ff       	call   f0100040 <_panic>
	assert(pp1->pp_ref == 0);
f0103764:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0103769:	74 24                	je     f010378f <mem_init+0x1f03>
f010376b:	c7 44 24 0c 40 95 10 	movl   $0xf0109540,0xc(%esp)
f0103772:	f0 
f0103773:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010377a:	f0 
f010377b:	c7 44 24 04 53 04 00 	movl   $0x453,0x4(%esp)
f0103782:	00 
f0103783:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010378a:	e8 b1 c8 ff ff       	call   f0100040 <_panic>
	*(uint32_t *)PGSIZE = 0x03030303U;
f010378f:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f0103796:	03 03 03 
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0103799:	89 f0                	mov    %esi,%eax
f010379b:	2b 05 9c 9e 2c f0    	sub    0xf02c9e9c,%eax
f01037a1:	c1 f8 03             	sar    $0x3,%eax
f01037a4:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01037a7:	89 c2                	mov    %eax,%edx
f01037a9:	c1 ea 0c             	shr    $0xc,%edx
f01037ac:	3b 15 94 9e 2c f0    	cmp    0xf02c9e94,%edx
f01037b2:	72 20                	jb     f01037d4 <mem_init+0x1f48>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01037b4:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01037b8:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f01037bf:	f0 
f01037c0:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f01037c7:	00 
f01037c8:	c7 04 24 b1 92 10 f0 	movl   $0xf01092b1,(%esp)
f01037cf:	e8 6c c8 ff ff       	call   f0100040 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01037d4:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f01037db:	03 03 03 
f01037de:	74 24                	je     f0103804 <mem_init+0x1f78>
f01037e0:	c7 44 24 0c 18 92 10 	movl   $0xf0109218,0xc(%esp)
f01037e7:	f0 
f01037e8:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01037ef:	f0 
f01037f0:	c7 44 24 04 55 04 00 	movl   $0x455,0x4(%esp)
f01037f7:	00 
f01037f8:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01037ff:	e8 3c c8 ff ff       	call   f0100040 <_panic>
	page_remove(kern_pgdir, (void*) PGSIZE);
f0103804:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f010380b:	00 
f010380c:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0103811:	89 04 24             	mov    %eax,(%esp)
f0103814:	e8 40 df ff ff       	call   f0101759 <page_remove>
	assert(pp2->pp_ref == 0);
f0103819:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f010381e:	74 24                	je     f0103844 <mem_init+0x1fb8>
f0103820:	c7 44 24 0c 0e 95 10 	movl   $0xf010950e,0xc(%esp)
f0103827:	f0 
f0103828:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f010382f:	f0 
f0103830:	c7 44 24 04 57 04 00 	movl   $0x457,0x4(%esp)
f0103837:	00 
f0103838:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f010383f:	e8 fc c7 ff ff       	call   f0100040 <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103844:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
f0103849:	8b 08                	mov    (%eax),%ecx
f010384b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0103851:	89 da                	mov    %ebx,%edx
f0103853:	2b 15 9c 9e 2c f0    	sub    0xf02c9e9c,%edx
f0103859:	c1 fa 03             	sar    $0x3,%edx
f010385c:	c1 e2 0c             	shl    $0xc,%edx
f010385f:	39 d1                	cmp    %edx,%ecx
f0103861:	74 24                	je     f0103887 <mem_init+0x1ffb>
f0103863:	c7 44 24 0c a0 8b 10 	movl   $0xf0108ba0,0xc(%esp)
f010386a:	f0 
f010386b:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0103872:	f0 
f0103873:	c7 44 24 04 5a 04 00 	movl   $0x45a,0x4(%esp)
f010387a:	00 
f010387b:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f0103882:	e8 b9 c7 ff ff       	call   f0100040 <_panic>
	kern_pgdir[0] = 0;
f0103887:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f010388d:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0103892:	74 24                	je     f01038b8 <mem_init+0x202c>
f0103894:	c7 44 24 0c c5 94 10 	movl   $0xf01094c5,0xc(%esp)
f010389b:	f0 
f010389c:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01038a3:	f0 
f01038a4:	c7 44 24 04 5c 04 00 	movl   $0x45c,0x4(%esp)
f01038ab:	00 
f01038ac:	c7 04 24 a5 92 10 f0 	movl   $0xf01092a5,(%esp)
f01038b3:	e8 88 c7 ff ff       	call   f0100040 <_panic>
	pp0->pp_ref = 0;
f01038b8:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

	// free the pages we took
	page_free(pp0);
f01038be:	89 1c 24             	mov    %ebx,(%esp)
f01038c1:	e8 4c dc ff ff       	call   f0101512 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f01038c6:	c7 04 24 44 92 10 f0 	movl   $0xf0109244,(%esp)
f01038cd:	e8 70 0a 00 00       	call   f0104342 <cprintf>
f01038d2:	eb 21                	jmp    f01038f5 <mem_init+0x2069>
	// check kernel stack
	// (updated in lab 4 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f01038d4:	89 da                	mov    %ebx,%edx
f01038d6:	89 f8                	mov    %edi,%eax
f01038d8:	e8 d1 d6 ff ff       	call   f0100fae <check_va2pa>
f01038dd:	8d 76 00             	lea    0x0(%esi),%esi
f01038e0:	e9 5f fa ff ff       	jmp    f0103344 <mem_init+0x1ab8>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f01038e5:	89 da                	mov    %ebx,%edx
f01038e7:	89 f8                	mov    %edi,%eax
f01038e9:	e8 c0 d6 ff ff       	call   f0100fae <check_va2pa>
f01038ee:	66 90                	xchg   %ax,%ax
f01038f0:	e9 5c f9 ff ff       	jmp    f0103251 <mem_init+0x19c5>
	cr0 &= ~(CR0_TS|CR0_EM);
	lcr0(cr0);

	// Some more checks, only possible after kern_pgdir is installed.
	check_page_installed_pgdir();
}
f01038f5:	83 c4 4c             	add    $0x4c,%esp
f01038f8:	5b                   	pop    %ebx
f01038f9:	5e                   	pop    %esi
f01038fa:	5f                   	pop    %edi
f01038fb:	5d                   	pop    %ebp
f01038fc:	c3                   	ret    

f01038fd <user_mem_check>:
// Returns 0 if the user program can access this range of addresses,
// and -E_FAULT otherwise.
//
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
f01038fd:	55                   	push   %ebp
f01038fe:	89 e5                	mov    %esp,%ebp
f0103900:	57                   	push   %edi
f0103901:	56                   	push   %esi
f0103902:	53                   	push   %ebx
f0103903:	83 ec 2c             	sub    $0x2c,%esp
f0103906:	8b 7d 08             	mov    0x8(%ebp),%edi
f0103909:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 3: Your code here.
	uint32_t start = (uint32_t) va;
	uint32_t current = ROUNDDOWN(start, PGSIZE);
f010390c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010390f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103914:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32_t end = start + len;
f0103917:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010391a:	03 4d 10             	add    0x10(%ebp),%ecx
f010391d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
	// LAB 3: Your code here.
	uint32_t start = (uint32_t) va;
	uint32_t current = ROUNDDOWN(start, PGSIZE);
f0103920:	89 c3                	mov    %eax,%ebx
	uint32_t end = start + len;
	pte_t *test_page;

	while (current < end) {
f0103922:	eb 52                	jmp    f0103976 <user_mem_check+0x79>
		test_page = pgdir_walk(env->env_pgdir, (void *) current, false);
f0103924:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010392b:	00 
f010392c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0103930:	8b 47 60             	mov    0x60(%edi),%eax
f0103933:	89 04 24             	mov    %eax,(%esp)
f0103936:	e8 66 dc ff ff       	call   f01015a1 <pgdir_walk>
		if (!test_page || current > ULIM || (((uint32_t) *test_page & perm) != perm)) {
f010393b:	85 c0                	test   %eax,%eax
f010393d:	74 10                	je     f010394f <user_mem_check+0x52>
f010393f:	81 fb 00 00 80 ef    	cmp    $0xef800000,%ebx
f0103945:	77 08                	ja     f010394f <user_mem_check+0x52>
f0103947:	89 f2                	mov    %esi,%edx
f0103949:	23 10                	and    (%eax),%edx
f010394b:	39 d6                	cmp    %edx,%esi
f010394d:	74 21                	je     f0103970 <user_mem_check+0x73>
			if (current == ROUNDDOWN(start, PGSIZE))
f010394f:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
f0103952:	75 0f                	jne    f0103963 <user_mem_check+0x66>
				user_mem_check_addr = (uintptr_t) va;
f0103954:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103957:	a3 3c 92 2c f0       	mov    %eax,0xf02c923c
			else
				user_mem_check_addr = (uintptr_t) current;
			return -E_FAULT;
f010395c:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f0103961:	eb 1d                	jmp    f0103980 <user_mem_check+0x83>
		test_page = pgdir_walk(env->env_pgdir, (void *) current, false);
		if (!test_page || current > ULIM || (((uint32_t) *test_page & perm) != perm)) {
			if (current == ROUNDDOWN(start, PGSIZE))
				user_mem_check_addr = (uintptr_t) va;
			else
				user_mem_check_addr = (uintptr_t) current;
f0103963:	89 1d 3c 92 2c f0    	mov    %ebx,0xf02c923c
			return -E_FAULT;
f0103969:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
f010396e:	eb 10                	jmp    f0103980 <user_mem_check+0x83>
		}
		current += PGSIZE;
f0103970:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	uint32_t start = (uint32_t) va;
	uint32_t current = ROUNDDOWN(start, PGSIZE);
	uint32_t end = start + len;
	pte_t *test_page;

	while (current < end) {
f0103976:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0103979:	72 a9                	jb     f0103924 <user_mem_check+0x27>
			return -E_FAULT;
		}
		current += PGSIZE;
	}

	return 0;
f010397b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103980:	83 c4 2c             	add    $0x2c,%esp
f0103983:	5b                   	pop    %ebx
f0103984:	5e                   	pop    %esi
f0103985:	5f                   	pop    %edi
f0103986:	5d                   	pop    %ebp
f0103987:	c3                   	ret    

f0103988 <user_mem_assert>:
// If it cannot, 'env' is destroyed and, if env is the current
// environment, this function will not return.
//
void
user_mem_assert(struct Env *env, const void *va, size_t len, int perm)
{
f0103988:	55                   	push   %ebp
f0103989:	89 e5                	mov    %esp,%ebp
f010398b:	53                   	push   %ebx
f010398c:	83 ec 14             	sub    $0x14,%esp
f010398f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U | PTE_P) < 0) {
f0103992:	8b 45 14             	mov    0x14(%ebp),%eax
f0103995:	83 c8 05             	or     $0x5,%eax
f0103998:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010399c:	8b 45 10             	mov    0x10(%ebp),%eax
f010399f:	89 44 24 08          	mov    %eax,0x8(%esp)
f01039a3:	8b 45 0c             	mov    0xc(%ebp),%eax
f01039a6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01039aa:	89 1c 24             	mov    %ebx,(%esp)
f01039ad:	e8 4b ff ff ff       	call   f01038fd <user_mem_check>
f01039b2:	85 c0                	test   %eax,%eax
f01039b4:	79 24                	jns    f01039da <user_mem_assert+0x52>
		cprintf("[%08x] user_mem_check assertion failure for "
f01039b6:	a1 3c 92 2c f0       	mov    0xf02c923c,%eax
f01039bb:	89 44 24 08          	mov    %eax,0x8(%esp)
f01039bf:	8b 43 48             	mov    0x48(%ebx),%eax
f01039c2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01039c6:	c7 04 24 70 92 10 f0 	movl   $0xf0109270,(%esp)
f01039cd:	e8 70 09 00 00       	call   f0104342 <cprintf>
			"va %08x\n", env->env_id, user_mem_check_addr);
		env_destroy(env);	// may not return
f01039d2:	89 1c 24             	mov    %ebx,(%esp)
f01039d5:	e8 58 06 00 00       	call   f0104032 <env_destroy>
	}
}
f01039da:	83 c4 14             	add    $0x14,%esp
f01039dd:	5b                   	pop    %ebx
f01039de:	5d                   	pop    %ebp
f01039df:	c3                   	ret    

f01039e0 <region_alloc>:
// Pages should be writable by user and kernel.
// Panic if any allocation attempt fails.
//
static void
region_alloc(struct Env *e, void *va, size_t len)
{
f01039e0:	55                   	push   %ebp
f01039e1:	89 e5                	mov    %esp,%ebp
f01039e3:	57                   	push   %edi
f01039e4:	56                   	push   %esi
f01039e5:	53                   	push   %ebx
f01039e6:	83 ec 1c             	sub    $0x1c,%esp
f01039e9:	89 c7                	mov    %eax,%edi
	//	round_down_start += PGSIZE;
	//}
	int i;
        struct PageInfo *pp;

        va = ROUNDDOWN(va, PGSIZE);
f01039eb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
        len = ROUNDUP(len, PGSIZE);
f01039f1:	8d b1 ff 0f 00 00    	lea    0xfff(%ecx),%esi

        for (i = (int) va; i < (int)ROUNDUP(va + len, PGSIZE); i += PGSIZE)
f01039f7:	89 d3                	mov    %edx,%ebx
	//}
	int i;
        struct PageInfo *pp;

        va = ROUNDDOWN(va, PGSIZE);
        len = ROUNDUP(len, PGSIZE);
f01039f9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi

        for (i = (int) va; i < (int)ROUNDUP(va + len, PGSIZE); i += PGSIZE)
f01039ff:	01 d6                	add    %edx,%esi
f0103a01:	eb 6e                	jmp    f0103a71 <region_alloc+0x91>
        {
                if (!(pp = page_alloc(0)))
f0103a03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103a0a:	e8 49 da ff ff       	call   f0101458 <page_alloc>
f0103a0f:	85 c0                	test   %eax,%eax
f0103a11:	75 1c                	jne    f0103a2f <region_alloc+0x4f>
                        panic("region_alloc: could not alloc page");
f0103a13:	c7 44 24 08 dc 95 10 	movl   $0xf01095dc,0x8(%esp)
f0103a1a:	f0 
f0103a1b:	c7 44 24 04 4d 01 00 	movl   $0x14d,0x4(%esp)
f0103a22:	00 
f0103a23:	c7 04 24 89 96 10 f0 	movl   $0xf0109689,(%esp)
f0103a2a:	e8 11 c6 ff ff       	call   f0100040 <_panic>
                if(page_insert(e->env_pgdir, pp, (void *)i, PTE_W | PTE_U) == -E_NO_MEM)
f0103a2f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f0103a36:	00 
f0103a37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0103a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103a3f:	8b 47 60             	mov    0x60(%edi),%eax
f0103a42:	89 04 24             	mov    %eax,(%esp)
f0103a45:	e8 58 dd ff ff       	call   f01017a2 <page_insert>
f0103a4a:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0103a4d:	75 1c                	jne    f0103a6b <region_alloc+0x8b>
                        panic("region_alloc: no memory available");
f0103a4f:	c7 44 24 08 00 96 10 	movl   $0xf0109600,0x8(%esp)
f0103a56:	f0 
f0103a57:	c7 44 24 04 4f 01 00 	movl   $0x14f,0x4(%esp)
f0103a5e:	00 
f0103a5f:	c7 04 24 89 96 10 f0 	movl   $0xf0109689,(%esp)
f0103a66:	e8 d5 c5 ff ff       	call   f0100040 <_panic>
        struct PageInfo *pp;

        va = ROUNDDOWN(va, PGSIZE);
        len = ROUNDUP(len, PGSIZE);

        for (i = (int) va; i < (int)ROUNDUP(va + len, PGSIZE); i += PGSIZE)
f0103a6b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103a71:	39 f3                	cmp    %esi,%ebx
f0103a73:	7c 8e                	jl     f0103a03 <region_alloc+0x23>
                        panic("region_alloc: could not alloc page");
                if(page_insert(e->env_pgdir, pp, (void *)i, PTE_W | PTE_U) == -E_NO_MEM)
                        panic("region_alloc: no memory available");
        }

}
f0103a75:	83 c4 1c             	add    $0x1c,%esp
f0103a78:	5b                   	pop    %ebx
f0103a79:	5e                   	pop    %esi
f0103a7a:	5f                   	pop    %edi
f0103a7b:	5d                   	pop    %ebp
f0103a7c:	c3                   	ret    

f0103a7d <envid2env>:
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f0103a7d:	55                   	push   %ebp
f0103a7e:	89 e5                	mov    %esp,%ebp
f0103a80:	56                   	push   %esi
f0103a81:	53                   	push   %ebx
f0103a82:	8b 45 08             	mov    0x8(%ebp),%eax
f0103a85:	8b 55 10             	mov    0x10(%ebp),%edx
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f0103a88:	85 c0                	test   %eax,%eax
f0103a8a:	75 1a                	jne    f0103aa6 <envid2env+0x29>
		*env_store = curenv;
f0103a8c:	e8 78 33 00 00       	call   f0106e09 <cpunum>
f0103a91:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a94:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0103a9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0103a9d:	89 01                	mov    %eax,(%ecx)
		return 0;
f0103a9f:	b8 00 00 00 00       	mov    $0x0,%eax
f0103aa4:	eb 70                	jmp    f0103b16 <envid2env+0x99>
	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f0103aa6:	89 c3                	mov    %eax,%ebx
f0103aa8:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
f0103aae:	c1 e3 07             	shl    $0x7,%ebx
f0103ab1:	03 1d 48 92 2c f0    	add    0xf02c9248,%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0103ab7:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f0103abb:	74 05                	je     f0103ac2 <envid2env+0x45>
f0103abd:	39 43 48             	cmp    %eax,0x48(%ebx)
f0103ac0:	74 10                	je     f0103ad2 <envid2env+0x55>
		*env_store = 0;
f0103ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103ac5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103acb:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103ad0:	eb 44                	jmp    f0103b16 <envid2env+0x99>
	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103ad2:	84 d2                	test   %dl,%dl
f0103ad4:	74 36                	je     f0103b0c <envid2env+0x8f>
f0103ad6:	e8 2e 33 00 00       	call   f0106e09 <cpunum>
f0103adb:	6b c0 74             	imul   $0x74,%eax,%eax
f0103ade:	39 98 28 a0 2c f0    	cmp    %ebx,-0xfd35fd8(%eax)
f0103ae4:	74 26                	je     f0103b0c <envid2env+0x8f>
f0103ae6:	8b 73 4c             	mov    0x4c(%ebx),%esi
f0103ae9:	e8 1b 33 00 00       	call   f0106e09 <cpunum>
f0103aee:	6b c0 74             	imul   $0x74,%eax,%eax
f0103af1:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0103af7:	3b 70 48             	cmp    0x48(%eax),%esi
f0103afa:	74 10                	je     f0103b0c <envid2env+0x8f>
		*env_store = 0;
f0103afc:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103aff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103b05:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103b0a:	eb 0a                	jmp    f0103b16 <envid2env+0x99>
	}

	*env_store = e;
f0103b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103b0f:	89 18                	mov    %ebx,(%eax)
	return 0;
f0103b11:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0103b16:	5b                   	pop    %ebx
f0103b17:	5e                   	pop    %esi
f0103b18:	5d                   	pop    %ebp
f0103b19:	c3                   	ret    

f0103b1a <env_init_percpu>:
}

// Load GDT and segment descriptors.
void
env_init_percpu(void)
{
f0103b1a:	55                   	push   %ebp
f0103b1b:	89 e5                	mov    %esp,%ebp
}

static inline void
lgdt(void *p)
{
	asm volatile("lgdt (%0)" : : "r" (p));
f0103b1d:	b8 20 63 12 f0       	mov    $0xf0126320,%eax
f0103b22:	0f 01 10             	lgdtl  (%eax)
	lgdt(&gdt_pd);
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	asm volatile("movw %%ax,%%gs" :: "a" (GD_UD|3));
f0103b25:	b8 23 00 00 00       	mov    $0x23,%eax
f0103b2a:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" :: "a" (GD_UD|3));
f0103b2c:	8e e0                	mov    %eax,%fs
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" :: "a" (GD_KD));
f0103b2e:	b0 10                	mov    $0x10,%al
f0103b30:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" :: "a" (GD_KD));
f0103b32:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" :: "a" (GD_KD));
f0103b34:	8e d0                	mov    %eax,%ss
	// Load the kernel text segment into CS.
	asm volatile("ljmp %0,$1f\n 1:\n" :: "i" (GD_KT));
f0103b36:	ea 3d 3b 10 f0 08 00 	ljmp   $0x8,$0xf0103b3d
}

static inline void
lldt(uint16_t sel)
{
	asm volatile("lldt %0" : : "r" (sel));
f0103b3d:	b0 00                	mov    $0x0,%al
f0103b3f:	0f 00 d0             	lldt   %ax
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	lldt(0);
}
f0103b42:	5d                   	pop    %ebp
f0103b43:	c3                   	ret    

f0103b44 <env_init>:
// they are in the envs array (i.e., so that the first call to
// env_alloc() returns envs[0]).
//
void
env_init(void)
{
f0103b44:	55                   	push   %ebp
f0103b45:	89 e5                	mov    %esp,%ebp
f0103b47:	56                   	push   %esi
f0103b48:	53                   	push   %ebx
	int i = NENV - 1;
        env_free_list = NULL;
        for (; i >= 0; i--)
        {
        //      cprintf("%d\n", i);
                envs[i].env_id = 0;
f0103b49:	8b 35 48 92 2c f0    	mov    0xf02c9248,%esi
f0103b4f:	8d 86 80 ff 01 00    	lea    0x1ff80(%esi),%eax
f0103b55:	ba 00 04 00 00       	mov    $0x400,%edx
f0103b5a:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103b5f:	89 c3                	mov    %eax,%ebx
f0103b61:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
                envs[i].env_link = env_free_list;
f0103b68:	89 48 44             	mov    %ecx,0x44(%eax)
                envs[i].env_status = ENV_FREE;
f0103b6b:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
f0103b72:	83 c0 80             	add    $0xffffff80,%eax
env_init(void)
{
	// Set up envs array
	int i = NENV - 1;
        env_free_list = NULL;
        for (; i >= 0; i--)
f0103b75:	83 ea 01             	sub    $0x1,%edx
f0103b78:	74 04                	je     f0103b7e <env_init+0x3a>
        {
        //      cprintf("%d\n", i);
                envs[i].env_id = 0;
                envs[i].env_link = env_free_list;
                envs[i].env_status = ENV_FREE;
                env_free_list = &envs[i];
f0103b7a:	89 d9                	mov    %ebx,%ecx
f0103b7c:	eb e1                	jmp    f0103b5f <env_init+0x1b>
f0103b7e:	89 35 4c 92 2c f0    	mov    %esi,0xf02c924c
        }

	// Per-CPU part of the initialization
	env_init_percpu();
f0103b84:	e8 91 ff ff ff       	call   f0103b1a <env_init_percpu>
}
f0103b89:	5b                   	pop    %ebx
f0103b8a:	5e                   	pop    %esi
f0103b8b:	5d                   	pop    %ebp
f0103b8c:	c3                   	ret    

f0103b8d <env_alloc>:
//	-E_NO_FREE_ENV if all NENVS environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f0103b8d:	55                   	push   %ebp
f0103b8e:	89 e5                	mov    %esp,%ebp
f0103b90:	53                   	push   %ebx
f0103b91:	83 ec 14             	sub    $0x14,%esp
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
f0103b94:	8b 1d 4c 92 2c f0    	mov    0xf02c924c,%ebx
f0103b9a:	85 db                	test   %ebx,%ebx
f0103b9c:	0f 84 55 01 00 00    	je     f0103cf7 <env_alloc+0x16a>
{
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
f0103ba2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0103ba9:	e8 aa d8 ff ff       	call   f0101458 <page_alloc>
f0103bae:	85 c0                	test   %eax,%eax
f0103bb0:	0f 84 48 01 00 00    	je     f0103cfe <env_alloc+0x171>
f0103bb6:	89 c2                	mov    %eax,%edx
f0103bb8:	2b 15 9c 9e 2c f0    	sub    0xf02c9e9c,%edx
f0103bbe:	c1 fa 03             	sar    $0x3,%edx
f0103bc1:	c1 e2 0c             	shl    $0xc,%edx
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103bc4:	89 d1                	mov    %edx,%ecx
f0103bc6:	c1 e9 0c             	shr    $0xc,%ecx
f0103bc9:	3b 0d 94 9e 2c f0    	cmp    0xf02c9e94,%ecx
f0103bcf:	72 20                	jb     f0103bf1 <env_alloc+0x64>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103bd1:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0103bd5:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0103bdc:	f0 
f0103bdd:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0103be4:	00 
f0103be5:	c7 04 24 b1 92 10 f0 	movl   $0xf01092b1,(%esp)
f0103bec:	e8 4f c4 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0103bf1:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0103bf7:	89 53 60             	mov    %edx,0x60(%ebx)

	// Now, set e->env_pgdir and initialize the page directory.
	e->env_pgdir = page2kva(p);

	// As per hint, increment pp_ref
	p->pp_ref++;
f0103bfa:	66 83 40 04 01       	addw   $0x1,0x4(%eax)
f0103bff:	b8 ec 0e 00 00       	mov    $0xeec,%eax
	// Copy everything from UTOP upwards. Note that we are just filling up
	// the page directory and not creating any page tables. The reason for
	// this is that those page tables already exist, we created them
	// in mem_init() using boot_map_region().
	for (i = PDX(UTOP); i < NPDENTRIES; i++)
		e->env_pgdir[i] = kern_pgdir[i];
f0103c04:	8b 15 98 9e 2c f0    	mov    0xf02c9e98,%edx
f0103c0a:	8b 0c 02             	mov    (%edx,%eax,1),%ecx
f0103c0d:	8b 53 60             	mov    0x60(%ebx),%edx
f0103c10:	89 0c 02             	mov    %ecx,(%edx,%eax,1)
f0103c13:	83 c0 04             	add    $0x4,%eax
	//	e->env_pgdir[i] = 0;
	// Copy everything from UTOP upwards. Note that we are just filling up
	// the page directory and not creating any page tables. The reason for
	// this is that those page tables already exist, we created them
	// in mem_init() using boot_map_region().
	for (i = PDX(UTOP); i < NPDENTRIES; i++)
f0103c16:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0103c1b:	75 e7                	jne    f0103c04 <env_alloc+0x77>
		e->env_pgdir[i] = kern_pgdir[i];

	// UVPT maps the env's own page table read-only.
	// Permissions: kernel R, user R
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103c1d:	8b 43 60             	mov    0x60(%ebx),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103c20:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103c25:	77 20                	ja     f0103c47 <env_alloc+0xba>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103c27:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103c2b:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f0103c32:	f0 
f0103c33:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
f0103c3a:	00 
f0103c3b:	c7 04 24 89 96 10 f0 	movl   $0xf0109689,(%esp)
f0103c42:	e8 f9 c3 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103c47:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103c4d:	83 ca 05             	or     $0x5,%edx
f0103c50:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
		return r;

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103c56:	8b 43 48             	mov    0x48(%ebx),%eax
f0103c59:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f0103c5e:	25 00 fc ff ff       	and    $0xfffffc00,%eax
		generation = 1 << ENVGENSHIFT;
f0103c63:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103c68:	0f 4e c2             	cmovle %edx,%eax
	e->env_id = generation | (e - envs);
f0103c6b:	89 da                	mov    %ebx,%edx
f0103c6d:	2b 15 48 92 2c f0    	sub    0xf02c9248,%edx
f0103c73:	c1 fa 07             	sar    $0x7,%edx
f0103c76:	09 d0                	or     %edx,%eax
f0103c78:	89 43 48             	mov    %eax,0x48(%ebx)

	// Set the basic status variables.
	e->env_parent_id = parent_id;
f0103c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103c7e:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103c81:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0103c88:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103c8f:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103c96:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f0103c9d:	00 
f0103c9e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103ca5:	00 
f0103ca6:	89 1c 24             	mov    %ebx,(%esp)
f0103ca9:	e8 09 2b 00 00       	call   f01067b7 <memset>
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.  When
	// we switch privilege levels, the hardware does various
	// checks involving the RPL and the Descriptor Privilege Level
	// (DPL) stored in the descriptors themselves.
	e->env_tf.tf_ds = GD_UD | 3;
f0103cae:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f0103cb4:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f0103cba:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f0103cc0:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f0103cc7:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	// You will set e->env_tf.tf_eip later.

	// Enable interrupts while in user mode.
	// LAB 4: Your code here.
	e->env_tf.tf_eflags |= FL_IF;
f0103ccd:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	
	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = 0;
f0103cd4:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f0103cdb:	c6 43 68 00          	movb   $0x0,0x68(%ebx)

	// commit the allocation
	env_free_list = e->env_link;
f0103cdf:	8b 43 44             	mov    0x44(%ebx),%eax
f0103ce2:	a3 4c 92 2c f0       	mov    %eax,0xf02c924c
	*newenv_store = e;
f0103ce7:	8b 45 08             	mov    0x8(%ebp),%eax
f0103cea:	89 18                	mov    %ebx,(%eax)

	e->env_e1000_waiting_rx = false;
f0103cec:	c6 43 7c 00          	movb   $0x0,0x7c(%ebx)
	// cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
f0103cf0:	b8 00 00 00 00       	mov    $0x0,%eax
f0103cf5:	eb 0c                	jmp    f0103d03 <env_alloc+0x176>
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
		return -E_NO_FREE_ENV;
f0103cf7:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103cfc:	eb 05                	jmp    f0103d03 <env_alloc+0x176>
	int i;
	struct PageInfo *p = NULL;

	// Allocate a page for the page directory
	if (!(p = page_alloc(ALLOC_ZERO)))
		return -E_NO_MEM;
f0103cfe:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
	*newenv_store = e;

	e->env_e1000_waiting_rx = false;
	// cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
}
f0103d03:	83 c4 14             	add    $0x14,%esp
f0103d06:	5b                   	pop    %ebx
f0103d07:	5d                   	pop    %ebp
f0103d08:	c3                   	ret    

f0103d09 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0103d09:	55                   	push   %ebp
f0103d0a:	89 e5                	mov    %esp,%ebp
f0103d0c:	57                   	push   %edi
f0103d0d:	56                   	push   %esi
f0103d0e:	53                   	push   %ebx
f0103d0f:	83 ec 3c             	sub    $0x3c,%esp
f0103d12:	8b 7d 08             	mov    0x8(%ebp),%edi
	// LAB 5: Your code here.
	
	struct Env *e;
	int ret_code;

	ret_code = env_alloc(&e, 0);
f0103d15:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103d1c:	00 
f0103d1d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103d20:	89 04 24             	mov    %eax,(%esp)
f0103d23:	e8 65 fe ff ff       	call   f0103b8d <env_alloc>
	if (ret_code != 0)
f0103d28:	85 c0                	test   %eax,%eax
f0103d2a:	74 20                	je     f0103d4c <env_create+0x43>
		panic("env_create: %e", ret_code);
f0103d2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103d30:	c7 44 24 08 94 96 10 	movl   $0xf0109694,0x8(%esp)
f0103d37:	f0 
f0103d38:	c7 44 24 04 c4 01 00 	movl   $0x1c4,0x4(%esp)
f0103d3f:	00 
f0103d40:	c7 04 24 89 96 10 f0 	movl   $0xf0109689,(%esp)
f0103d47:	e8 f4 c2 ff ff       	call   f0100040 <_panic>

	load_icode(e, binary);
f0103d4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103d4f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	// LAB 3: Your code here.

	struct Elf *elf_header = (struct Elf *) binary;

	if (elf_header->e_magic != ELF_MAGIC)
f0103d52:	81 3f 7f 45 4c 46    	cmpl   $0x464c457f,(%edi)
f0103d58:	74 1c                	je     f0103d76 <env_create+0x6d>
		panic("load_icode: trying to load bad binary image, magic elf not found :)");
f0103d5a:	c7 44 24 08 24 96 10 	movl   $0xf0109624,0x8(%esp)
f0103d61:	f0 
f0103d62:	c7 44 24 04 8e 01 00 	movl   $0x18e,0x4(%esp)
f0103d69:	00 
f0103d6a:	c7 04 24 89 96 10 f0 	movl   $0xf0109689,(%esp)
f0103d71:	e8 ca c2 ff ff       	call   f0100040 <_panic>

	if (elf_header->e_entry == 0)
f0103d76:	8b 47 18             	mov    0x18(%edi),%eax
f0103d79:	85 c0                	test   %eax,%eax
f0103d7b:	75 1c                	jne    f0103d99 <env_create+0x90>
		panic("load_icode: no elf entry present");
f0103d7d:	c7 44 24 08 68 96 10 	movl   $0xf0109668,0x8(%esp)
f0103d84:	f0 
f0103d85:	c7 44 24 04 91 01 00 	movl   $0x191,0x4(%esp)
f0103d8c:	00 
f0103d8d:	c7 04 24 89 96 10 f0 	movl   $0xf0109689,(%esp)
f0103d94:	e8 a7 c2 ff ff       	call   f0100040 <_panic>

	// When we switch to the user environment we need to start executing
	// at the eip pointed to by the e_entry field of the elf_header
	e->env_tf.tf_eip = elf_header->e_entry;
f0103d99:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0103d9c:	89 41 30             	mov    %eax,0x30(%ecx)

	// We must load the env_pgdir because we're going to be copying data
	// into user pages
	lcr3(PADDR(e->env_pgdir));
f0103d9f:	8b 41 60             	mov    0x60(%ecx),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103da2:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103da7:	77 20                	ja     f0103dc9 <env_create+0xc0>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103da9:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103dad:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f0103db4:	f0 
f0103db5:	c7 44 24 04 99 01 00 	movl   $0x199,0x4(%esp)
f0103dbc:	00 
f0103dbd:	c7 04 24 89 96 10 f0 	movl   $0xf0109689,(%esp)
f0103dc4:	e8 77 c2 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103dc9:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103dce:	0f 22 d8             	mov    %eax,%cr3

	int i;
	struct Proghdr *prog_header = (struct Proghdr *) (binary + elf_header->e_phoff);
f0103dd1:	89 fb                	mov    %edi,%ebx
f0103dd3:	03 5f 1c             	add    0x1c(%edi),%ebx
	for (i = 0; i < elf_header->e_phnum; i++) {
f0103dd6:	be 00 00 00 00       	mov    $0x0,%esi
f0103ddb:	eb 53                	jmp    f0103e30 <env_create+0x127>
		if (prog_header[i].p_type == ELF_PROG_LOAD) {
f0103ddd:	83 3b 01             	cmpl   $0x1,(%ebx)
f0103de0:	75 48                	jne    f0103e2a <env_create+0x121>
			if (prog_header[i].p_memsz - prog_header[i].p_filesz < 0)
				panic("load_icode: badly ");

			region_alloc(e, (void *) prog_header[i].p_va, prog_header[i].p_memsz);
f0103de2:	8b 4b 14             	mov    0x14(%ebx),%ecx
f0103de5:	8b 53 08             	mov    0x8(%ebx),%edx
f0103de8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103deb:	e8 f0 fb ff ff       	call   f01039e0 <region_alloc>
			memmove((void *) prog_header[i].p_va, binary + prog_header[i].p_offset, prog_header[i].p_filesz);
f0103df0:	8b 43 10             	mov    0x10(%ebx),%eax
f0103df3:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103df7:	89 f8                	mov    %edi,%eax
f0103df9:	03 43 04             	add    0x4(%ebx),%eax
f0103dfc:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103e00:	8b 43 08             	mov    0x8(%ebx),%eax
f0103e03:	89 04 24             	mov    %eax,(%esp)
f0103e06:	e8 f9 29 00 00       	call   f0106804 <memmove>
			memset((void *) (prog_header[i].p_va + prog_header[i].p_filesz), 0, prog_header[i].p_memsz - prog_header[i].p_filesz);
f0103e0b:	8b 43 10             	mov    0x10(%ebx),%eax
f0103e0e:	8b 53 14             	mov    0x14(%ebx),%edx
f0103e11:	29 c2                	sub    %eax,%edx
f0103e13:	89 54 24 08          	mov    %edx,0x8(%esp)
f0103e17:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103e1e:	00 
f0103e1f:	03 43 08             	add    0x8(%ebx),%eax
f0103e22:	89 04 24             	mov    %eax,(%esp)
f0103e25:	e8 8d 29 00 00       	call   f01067b7 <memset>
	// into user pages
	lcr3(PADDR(e->env_pgdir));

	int i;
	struct Proghdr *prog_header = (struct Proghdr *) (binary + elf_header->e_phoff);
	for (i = 0; i < elf_header->e_phnum; i++) {
f0103e2a:	83 c6 01             	add    $0x1,%esi
f0103e2d:	83 c3 20             	add    $0x20,%ebx
f0103e30:	0f b7 47 2c          	movzwl 0x2c(%edi),%eax
f0103e34:	39 c6                	cmp    %eax,%esi
f0103e36:	7c a5                	jl     f0103ddd <env_create+0xd4>
	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.

	// LAB 3: Your code here.

	region_alloc(e, (void *) (USTACKTOP - PGSIZE), PGSIZE);
f0103e38:	b9 00 10 00 00       	mov    $0x1000,%ecx
f0103e3d:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f0103e42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0103e45:	e8 96 fb ff ff       	call   f01039e0 <region_alloc>
	ret_code = env_alloc(&e, 0);
	if (ret_code != 0)
		panic("env_create: %e", ret_code);

	load_icode(e, binary);
	e->env_type = type;
f0103e4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103e4d:	8b 55 0c             	mov    0xc(%ebp),%edx
f0103e50:	89 50 50             	mov    %edx,0x50(%eax)

	// If this is the file server (type == ENV_TYPE_FS) give it I/O privileges.
	// LAB 5: Your code here.
	if (type == ENV_TYPE_FS)
f0103e53:	83 fa 01             	cmp    $0x1,%edx
f0103e56:	75 07                	jne    f0103e5f <env_create+0x156>
		e->env_tf.tf_eflags |= FL_IOPL_3;
f0103e58:	81 48 38 00 30 00 00 	orl    $0x3000,0x38(%eax)

}
f0103e5f:	83 c4 3c             	add    $0x3c,%esp
f0103e62:	5b                   	pop    %ebx
f0103e63:	5e                   	pop    %esi
f0103e64:	5f                   	pop    %edi
f0103e65:	5d                   	pop    %ebp
f0103e66:	c3                   	ret    

f0103e67 <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103e67:	55                   	push   %ebp
f0103e68:	89 e5                	mov    %esp,%ebp
f0103e6a:	57                   	push   %edi
f0103e6b:	56                   	push   %esi
f0103e6c:	53                   	push   %ebx
f0103e6d:	83 ec 2c             	sub    $0x2c,%esp
f0103e70:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103e73:	e8 91 2f 00 00       	call   f0106e09 <cpunum>
f0103e78:	6b c0 74             	imul   $0x74,%eax,%eax
f0103e7b:	39 b8 28 a0 2c f0    	cmp    %edi,-0xfd35fd8(%eax)
f0103e81:	74 09                	je     f0103e8c <env_free+0x25>
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f0103e83:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0103e8a:	eb 36                	jmp    f0103ec2 <env_free+0x5b>

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
		lcr3(PADDR(kern_pgdir));
f0103e8c:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103e91:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103e96:	77 20                	ja     f0103eb8 <env_free+0x51>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103e98:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103e9c:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f0103ea3:	f0 
f0103ea4:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
f0103eab:	00 
f0103eac:	c7 04 24 89 96 10 f0 	movl   $0xf0109689,(%esp)
f0103eb3:	e8 88 c1 ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103eb8:	05 00 00 00 10       	add    $0x10000000,%eax
f0103ebd:	0f 22 d8             	mov    %eax,%cr3
f0103ec0:	eb c1                	jmp    f0103e83 <env_free+0x1c>
f0103ec2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103ec5:	89 c8                	mov    %ecx,%eax
f0103ec7:	c1 e0 02             	shl    $0x2,%eax
f0103eca:	89 45 dc             	mov    %eax,-0x24(%ebp)
	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {

		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103ecd:	8b 47 60             	mov    0x60(%edi),%eax
f0103ed0:	8b 34 88             	mov    (%eax,%ecx,4),%esi
f0103ed3:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0103ed9:	0f 84 b7 00 00 00    	je     f0103f96 <env_free+0x12f>
			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103edf:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103ee5:	89 f0                	mov    %esi,%eax
f0103ee7:	c1 e8 0c             	shr    $0xc,%eax
f0103eea:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0103eed:	3b 05 94 9e 2c f0    	cmp    0xf02c9e94,%eax
f0103ef3:	72 20                	jb     f0103f15 <env_free+0xae>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103ef5:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0103ef9:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0103f00:	f0 
f0103f01:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
f0103f08:	00 
f0103f09:	c7 04 24 89 96 10 f0 	movl   $0xf0109689,(%esp)
f0103f10:	e8 2b c1 ff ff       	call   f0100040 <_panic>
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103f15:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0103f18:	c1 e0 16             	shl    $0x16,%eax
f0103f1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103f1e:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (pt[pteno] & PTE_P)
f0103f23:	f6 84 9e 00 00 00 f0 	testb  $0x1,-0x10000000(%esi,%ebx,4)
f0103f2a:	01 
f0103f2b:	74 17                	je     f0103f44 <env_free+0xdd>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0103f2d:	89 d8                	mov    %ebx,%eax
f0103f2f:	c1 e0 0c             	shl    $0xc,%eax
f0103f32:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0103f35:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103f39:	8b 47 60             	mov    0x60(%edi),%eax
f0103f3c:	89 04 24             	mov    %eax,(%esp)
f0103f3f:	e8 15 d8 ff ff       	call   f0101759 <page_remove>
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0103f44:	83 c3 01             	add    $0x1,%ebx
f0103f47:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103f4d:	75 d4                	jne    f0103f23 <env_free+0xbc>
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103f4f:	8b 47 60             	mov    0x60(%edi),%eax
f0103f52:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0103f55:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103f5c:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0103f5f:	3b 05 94 9e 2c f0    	cmp    0xf02c9e94,%eax
f0103f65:	72 1c                	jb     f0103f83 <env_free+0x11c>
		panic("pa2page called with invalid pa");
f0103f67:	c7 44 24 08 30 8a 10 	movl   $0xf0108a30,0x8(%esp)
f0103f6e:	f0 
f0103f6f:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
f0103f76:	00 
f0103f77:	c7 04 24 b1 92 10 f0 	movl   $0xf01092b1,(%esp)
f0103f7e:	e8 bd c0 ff ff       	call   f0100040 <_panic>
	return &pages[PGNUM(pa)];
f0103f83:	a1 9c 9e 2c f0       	mov    0xf02c9e9c,%eax
f0103f88:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0103f8b:	8d 04 d0             	lea    (%eax,%edx,8),%eax
		page_decref(pa2page(pa));
f0103f8e:	89 04 24             	mov    %eax,(%esp)
f0103f91:	e8 e8 d5 ff ff       	call   f010157e <page_decref>
	// Note the environment's demise.
	// cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0103f96:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
f0103f9a:	81 7d e0 bb 03 00 00 	cmpl   $0x3bb,-0x20(%ebp)
f0103fa1:	0f 85 1b ff ff ff    	jne    f0103ec2 <env_free+0x5b>
		e->env_pgdir[pdeno] = 0;
		page_decref(pa2page(pa));
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f0103fa7:	8b 47 60             	mov    0x60(%edi),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103faa:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103faf:	77 20                	ja     f0103fd1 <env_free+0x16a>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103fb1:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103fb5:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f0103fbc:	f0 
f0103fbd:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
f0103fc4:	00 
f0103fc5:	c7 04 24 89 96 10 f0 	movl   $0xf0109689,(%esp)
f0103fcc:	e8 6f c0 ff ff       	call   f0100040 <_panic>
	e->env_pgdir = 0;
f0103fd1:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
	return (physaddr_t)kva - KERNBASE;
f0103fd8:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103fdd:	c1 e8 0c             	shr    $0xc,%eax
f0103fe0:	3b 05 94 9e 2c f0    	cmp    0xf02c9e94,%eax
f0103fe6:	72 1c                	jb     f0104004 <env_free+0x19d>
		panic("pa2page called with invalid pa");
f0103fe8:	c7 44 24 08 30 8a 10 	movl   $0xf0108a30,0x8(%esp)
f0103fef:	f0 
f0103ff0:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
f0103ff7:	00 
f0103ff8:	c7 04 24 b1 92 10 f0 	movl   $0xf01092b1,(%esp)
f0103fff:	e8 3c c0 ff ff       	call   f0100040 <_panic>
	return &pages[PGNUM(pa)];
f0104004:	8b 15 9c 9e 2c f0    	mov    0xf02c9e9c,%edx
f010400a:	8d 04 c2             	lea    (%edx,%eax,8),%eax
	page_decref(pa2page(pa));
f010400d:	89 04 24             	mov    %eax,(%esp)
f0104010:	e8 69 d5 ff ff       	call   f010157e <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0104015:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	e->env_link = env_free_list;
f010401c:	a1 4c 92 2c f0       	mov    0xf02c924c,%eax
f0104021:	89 47 44             	mov    %eax,0x44(%edi)
	env_free_list = e;
f0104024:	89 3d 4c 92 2c f0    	mov    %edi,0xf02c924c
}
f010402a:	83 c4 2c             	add    $0x2c,%esp
f010402d:	5b                   	pop    %ebx
f010402e:	5e                   	pop    %esi
f010402f:	5f                   	pop    %edi
f0104030:	5d                   	pop    %ebp
f0104031:	c3                   	ret    

f0104032 <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0104032:	55                   	push   %ebp
f0104033:	89 e5                	mov    %esp,%ebp
f0104035:	53                   	push   %ebx
f0104036:	83 ec 14             	sub    $0x14,%esp
f0104039:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f010403c:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0104040:	75 19                	jne    f010405b <env_destroy+0x29>
f0104042:	e8 c2 2d 00 00       	call   f0106e09 <cpunum>
f0104047:	6b c0 74             	imul   $0x74,%eax,%eax
f010404a:	39 98 28 a0 2c f0    	cmp    %ebx,-0xfd35fd8(%eax)
f0104050:	74 09                	je     f010405b <env_destroy+0x29>
		e->env_status = ENV_DYING;
f0104052:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0104059:	eb 2f                	jmp    f010408a <env_destroy+0x58>
	}

	env_free(e);
f010405b:	89 1c 24             	mov    %ebx,(%esp)
f010405e:	e8 04 fe ff ff       	call   f0103e67 <env_free>

	if (curenv == e) {
f0104063:	e8 a1 2d 00 00       	call   f0106e09 <cpunum>
f0104068:	6b c0 74             	imul   $0x74,%eax,%eax
f010406b:	39 98 28 a0 2c f0    	cmp    %ebx,-0xfd35fd8(%eax)
f0104071:	75 17                	jne    f010408a <env_destroy+0x58>
		curenv = NULL;
f0104073:	e8 91 2d 00 00       	call   f0106e09 <cpunum>
f0104078:	6b c0 74             	imul   $0x74,%eax,%eax
f010407b:	c7 80 28 a0 2c f0 00 	movl   $0x0,-0xfd35fd8(%eax)
f0104082:	00 00 00 
		sched_yield();
f0104085:	e8 3c 10 00 00       	call   f01050c6 <sched_yield>
	}
}
f010408a:	83 c4 14             	add    $0x14,%esp
f010408d:	5b                   	pop    %ebx
f010408e:	5d                   	pop    %ebp
f010408f:	c3                   	ret    

f0104090 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0104090:	55                   	push   %ebp
f0104091:	89 e5                	mov    %esp,%ebp
f0104093:	53                   	push   %ebx
f0104094:	83 ec 14             	sub    $0x14,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0104097:	e8 6d 2d 00 00       	call   f0106e09 <cpunum>
f010409c:	6b c0 74             	imul   $0x74,%eax,%eax
f010409f:	8b 98 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%ebx
f01040a5:	e8 5f 2d 00 00       	call   f0106e09 <cpunum>
f01040aa:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f01040ad:	8b 65 08             	mov    0x8(%ebp),%esp
f01040b0:	61                   	popa   
f01040b1:	07                   	pop    %es
f01040b2:	1f                   	pop    %ds
f01040b3:	83 c4 08             	add    $0x8,%esp
f01040b6:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f01040b7:	c7 44 24 08 a3 96 10 	movl   $0xf01096a3,0x8(%esp)
f01040be:	f0 
f01040bf:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
f01040c6:	00 
f01040c7:	c7 04 24 89 96 10 f0 	movl   $0xf0109689,(%esp)
f01040ce:	e8 6d bf ff ff       	call   f0100040 <_panic>

f01040d3 <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f01040d3:	55                   	push   %ebp
f01040d4:	89 e5                	mov    %esp,%ebp
f01040d6:	53                   	push   %ebx
f01040d7:	83 ec 14             	sub    $0x14,%esp
f01040da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.

	if (curenv != NULL && curenv != e && curenv->env_status == ENV_RUNNING)
f01040dd:	e8 27 2d 00 00       	call   f0106e09 <cpunum>
f01040e2:	6b c0 74             	imul   $0x74,%eax,%eax
f01040e5:	83 b8 28 a0 2c f0 00 	cmpl   $0x0,-0xfd35fd8(%eax)
f01040ec:	74 39                	je     f0104127 <env_run+0x54>
f01040ee:	e8 16 2d 00 00       	call   f0106e09 <cpunum>
f01040f3:	6b c0 74             	imul   $0x74,%eax,%eax
f01040f6:	39 98 28 a0 2c f0    	cmp    %ebx,-0xfd35fd8(%eax)
f01040fc:	74 29                	je     f0104127 <env_run+0x54>
f01040fe:	e8 06 2d 00 00       	call   f0106e09 <cpunum>
f0104103:	6b c0 74             	imul   $0x74,%eax,%eax
f0104106:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f010410c:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104110:	75 15                	jne    f0104127 <env_run+0x54>
		curenv->env_status = ENV_RUNNABLE;
f0104112:	e8 f2 2c 00 00       	call   f0106e09 <cpunum>
f0104117:	6b c0 74             	imul   $0x74,%eax,%eax
f010411a:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104120:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)

	curenv = e;
f0104127:	e8 dd 2c 00 00       	call   f0106e09 <cpunum>
f010412c:	6b c0 74             	imul   $0x74,%eax,%eax
f010412f:	89 98 28 a0 2c f0    	mov    %ebx,-0xfd35fd8(%eax)
	curenv->env_status = ENV_RUNNING;
f0104135:	e8 cf 2c 00 00       	call   f0106e09 <cpunum>
f010413a:	6b c0 74             	imul   $0x74,%eax,%eax
f010413d:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104143:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
	curenv->env_runs++;
f010414a:	e8 ba 2c 00 00       	call   f0106e09 <cpunum>
f010414f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104152:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104158:	83 40 58 01          	addl   $0x1,0x58(%eax)
	lcr3(PADDR(curenv->env_pgdir));
f010415c:	e8 a8 2c 00 00       	call   f0106e09 <cpunum>
f0104161:	6b c0 74             	imul   $0x74,%eax,%eax
f0104164:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f010416a:	8b 40 60             	mov    0x60(%eax),%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010416d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104172:	77 20                	ja     f0104194 <env_run+0xc1>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104174:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104178:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f010417f:	f0 
f0104180:	c7 44 24 04 57 02 00 	movl   $0x257,0x4(%esp)
f0104187:	00 
f0104188:	c7 04 24 89 96 10 f0 	movl   $0xf0109689,(%esp)
f010418f:	e8 ac be ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0104194:	05 00 00 00 10       	add    $0x10000000,%eax
f0104199:	0f 22 d8             	mov    %eax,%cr3
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f010419c:	c7 04 24 c0 63 12 f0 	movl   $0xf01263c0,(%esp)
f01041a3:	e8 8b 2f 00 00       	call   f0107133 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f01041a8:	f3 90                	pause  
	unlock_kernel();
	env_pop_tf(&(curenv->env_tf));
f01041aa:	e8 5a 2c 00 00       	call   f0106e09 <cpunum>
f01041af:	6b c0 74             	imul   $0x74,%eax,%eax
f01041b2:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f01041b8:	89 04 24             	mov    %eax,(%esp)
f01041bb:	e8 d0 fe ff ff       	call   f0104090 <env_pop_tf>

f01041c0 <mc146818_read>:
#include <kern/kclock.h>


unsigned
mc146818_read(unsigned reg)
{
f01041c0:	55                   	push   %ebp
f01041c1:	89 e5                	mov    %esp,%ebp
f01041c3:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01041c7:	ba 70 00 00 00       	mov    $0x70,%edx
f01041cc:	ee                   	out    %al,(%dx)

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01041cd:	b2 71                	mov    $0x71,%dl
f01041cf:	ec                   	in     (%dx),%al
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f01041d0:	0f b6 c0             	movzbl %al,%eax
}
f01041d3:	5d                   	pop    %ebp
f01041d4:	c3                   	ret    

f01041d5 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f01041d5:	55                   	push   %ebp
f01041d6:	89 e5                	mov    %esp,%ebp
f01041d8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01041dc:	ba 70 00 00 00       	mov    $0x70,%edx
f01041e1:	ee                   	out    %al,(%dx)
f01041e2:	b2 71                	mov    $0x71,%dl
f01041e4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01041e7:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01041e8:	5d                   	pop    %ebp
f01041e9:	c3                   	ret    

f01041ea <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f01041ea:	55                   	push   %ebp
f01041eb:	89 e5                	mov    %esp,%ebp
f01041ed:	56                   	push   %esi
f01041ee:	53                   	push   %ebx
f01041ef:	83 ec 10             	sub    $0x10,%esp
f01041f2:	8b 45 08             	mov    0x8(%ebp),%eax
	int i;
	irq_mask_8259A = mask;
	irq_mask_8259A &= ~(1 << IRQ_E1000);
f01041f5:	89 c2                	mov    %eax,%edx
f01041f7:	80 e6 f7             	and    $0xf7,%dh
f01041fa:	66 89 15 a8 63 12 f0 	mov    %dx,0xf01263a8
	if (!didinit)
f0104201:	80 3d 50 92 2c f0 00 	cmpb   $0x0,0xf02c9250
f0104208:	74 4e                	je     f0104258 <irq_setmask_8259A+0x6e>
f010420a:	89 c6                	mov    %eax,%esi
f010420c:	ba 21 00 00 00       	mov    $0x21,%edx
f0104211:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
f0104212:	66 c1 e8 08          	shr    $0x8,%ax
f0104216:	b2 a1                	mov    $0xa1,%dl
f0104218:	ee                   	out    %al,(%dx)
	cprintf("enabled interrupts:");
f0104219:	c7 04 24 af 96 10 f0 	movl   $0xf01096af,(%esp)
f0104220:	e8 1d 01 00 00       	call   f0104342 <cprintf>
	for (i = 0; i < 16; i++)
f0104225:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (~mask & (1<<i))
f010422a:	0f b7 f6             	movzwl %si,%esi
f010422d:	f7 d6                	not    %esi
f010422f:	0f a3 de             	bt     %ebx,%esi
f0104232:	73 10                	jae    f0104244 <irq_setmask_8259A+0x5a>
			cprintf(" %d", i);
f0104234:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0104238:	c7 04 24 8f 9b 10 f0 	movl   $0xf0109b8f,(%esp)
f010423f:	e8 fe 00 00 00       	call   f0104342 <cprintf>
	if (!didinit)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
f0104244:	83 c3 01             	add    $0x1,%ebx
f0104247:	83 fb 10             	cmp    $0x10,%ebx
f010424a:	75 e3                	jne    f010422f <irq_setmask_8259A+0x45>
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
f010424c:	c7 04 24 a9 95 10 f0 	movl   $0xf01095a9,(%esp)
f0104253:	e8 ea 00 00 00       	call   f0104342 <cprintf>
}
f0104258:	83 c4 10             	add    $0x10,%esp
f010425b:	5b                   	pop    %ebx
f010425c:	5e                   	pop    %esi
f010425d:	5d                   	pop    %ebp
f010425e:	c3                   	ret    

f010425f <pic_init>:

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
	didinit = 1;
f010425f:	c6 05 50 92 2c f0 01 	movb   $0x1,0xf02c9250
f0104266:	ba 21 00 00 00       	mov    $0x21,%edx
f010426b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104270:	ee                   	out    %al,(%dx)
f0104271:	b2 a1                	mov    $0xa1,%dl
f0104273:	ee                   	out    %al,(%dx)
f0104274:	b2 20                	mov    $0x20,%dl
f0104276:	b8 11 00 00 00       	mov    $0x11,%eax
f010427b:	ee                   	out    %al,(%dx)
f010427c:	b2 21                	mov    $0x21,%dl
f010427e:	b8 20 00 00 00       	mov    $0x20,%eax
f0104283:	ee                   	out    %al,(%dx)
f0104284:	b8 04 00 00 00       	mov    $0x4,%eax
f0104289:	ee                   	out    %al,(%dx)
f010428a:	b8 03 00 00 00       	mov    $0x3,%eax
f010428f:	ee                   	out    %al,(%dx)
f0104290:	b2 a0                	mov    $0xa0,%dl
f0104292:	b8 11 00 00 00       	mov    $0x11,%eax
f0104297:	ee                   	out    %al,(%dx)
f0104298:	b2 a1                	mov    $0xa1,%dl
f010429a:	b8 28 00 00 00       	mov    $0x28,%eax
f010429f:	ee                   	out    %al,(%dx)
f01042a0:	b8 02 00 00 00       	mov    $0x2,%eax
f01042a5:	ee                   	out    %al,(%dx)
f01042a6:	b8 01 00 00 00       	mov    $0x1,%eax
f01042ab:	ee                   	out    %al,(%dx)
f01042ac:	b2 20                	mov    $0x20,%dl
f01042ae:	b8 68 00 00 00       	mov    $0x68,%eax
f01042b3:	ee                   	out    %al,(%dx)
f01042b4:	b8 0a 00 00 00       	mov    $0xa,%eax
f01042b9:	ee                   	out    %al,(%dx)
f01042ba:	b2 a0                	mov    $0xa0,%dl
f01042bc:	b8 68 00 00 00       	mov    $0x68,%eax
f01042c1:	ee                   	out    %al,(%dx)
f01042c2:	b8 0a 00 00 00       	mov    $0xa,%eax
f01042c7:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f01042c8:	0f b7 05 a8 63 12 f0 	movzwl 0xf01263a8,%eax
f01042cf:	66 83 f8 ff          	cmp    $0xffff,%ax
f01042d3:	74 12                	je     f01042e7 <pic_init+0x88>
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f01042d5:	55                   	push   %ebp
f01042d6:	89 e5                	mov    %esp,%ebp
f01042d8:	83 ec 18             	sub    $0x18,%esp

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
		irq_setmask_8259A(irq_mask_8259A);
f01042db:	0f b7 c0             	movzwl %ax,%eax
f01042de:	89 04 24             	mov    %eax,(%esp)
f01042e1:	e8 04 ff ff ff       	call   f01041ea <irq_setmask_8259A>
}
f01042e6:	c9                   	leave  
f01042e7:	f3 c3                	repz ret 

f01042e9 <irq_eoi>:
	cprintf("\n");
}

void
irq_eoi(void)
{
f01042e9:	55                   	push   %ebp
f01042ea:	89 e5                	mov    %esp,%ebp
f01042ec:	ba 20 00 00 00       	mov    $0x20,%edx
f01042f1:	b8 20 00 00 00       	mov    $0x20,%eax
f01042f6:	ee                   	out    %al,(%dx)
f01042f7:	b2 a0                	mov    $0xa0,%dl
f01042f9:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f01042fa:	5d                   	pop    %ebp
f01042fb:	c3                   	ret    

f01042fc <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01042fc:	55                   	push   %ebp
f01042fd:	89 e5                	mov    %esp,%ebp
f01042ff:	83 ec 18             	sub    $0x18,%esp
	cputchar(ch);
f0104302:	8b 45 08             	mov    0x8(%ebp),%eax
f0104305:	89 04 24             	mov    %eax,(%esp)
f0104308:	e8 da c4 ff ff       	call   f01007e7 <cputchar>
	*cnt++;
}
f010430d:	c9                   	leave  
f010430e:	c3                   	ret    

f010430f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f010430f:	55                   	push   %ebp
f0104310:	89 e5                	mov    %esp,%ebp
f0104312:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f0104315:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f010431c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010431f:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104323:	8b 45 08             	mov    0x8(%ebp),%eax
f0104326:	89 44 24 08          	mov    %eax,0x8(%esp)
f010432a:	8d 45 f4             	lea    -0xc(%ebp),%eax
f010432d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104331:	c7 04 24 fc 42 10 f0 	movl   $0xf01042fc,(%esp)
f0104338:	e8 b1 1d 00 00       	call   f01060ee <vprintfmt>
	return cnt;
}
f010433d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0104340:	c9                   	leave  
f0104341:	c3                   	ret    

f0104342 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0104342:	55                   	push   %ebp
f0104343:	89 e5                	mov    %esp,%ebp
f0104345:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0104348:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f010434b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010434f:	8b 45 08             	mov    0x8(%ebp),%eax
f0104352:	89 04 24             	mov    %eax,(%esp)
f0104355:	e8 b5 ff ff ff       	call   f010430f <vcprintf>
	va_end(ap);

	return cnt;
}
f010435a:	c9                   	leave  
f010435b:	c3                   	ret    
f010435c:	66 90                	xchg   %ax,%ax
f010435e:	66 90                	xchg   %ax,%ax

f0104360 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0104360:	55                   	push   %ebp
f0104361:	89 e5                	mov    %esp,%ebp
f0104363:	57                   	push   %edi
f0104364:	56                   	push   %esi
f0104365:	53                   	push   %ebx
f0104366:	83 ec 0c             	sub    $0xc,%esp
	//
	// LAB 4: Your code here:

	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	thiscpu->cpu_ts.ts_esp0 = (uintptr_t) percpu_kstacks[thiscpu->cpu_id] + KSTKSIZE;
f0104369:	e8 9b 2a 00 00       	call   f0106e09 <cpunum>
f010436e:	89 c3                	mov    %eax,%ebx
f0104370:	e8 94 2a 00 00       	call   f0106e09 <cpunum>
f0104375:	6b db 74             	imul   $0x74,%ebx,%ebx
f0104378:	6b c0 74             	imul   $0x74,%eax,%eax
f010437b:	0f b6 80 20 a0 2c f0 	movzbl -0xfd35fe0(%eax),%eax
f0104382:	c1 e0 0f             	shl    $0xf,%eax
f0104385:	05 00 30 2d f0       	add    $0xf02d3000,%eax
f010438a:	89 83 30 a0 2c f0    	mov    %eax,-0xfd35fd0(%ebx)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0104390:	e8 74 2a 00 00       	call   f0106e09 <cpunum>
f0104395:	6b c0 74             	imul   $0x74,%eax,%eax
f0104398:	66 c7 80 34 a0 2c f0 	movw   $0x10,-0xfd35fcc(%eax)
f010439f:	10 00 

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3) + thiscpu->cpu_id] = SEG16(STS_T32A, (uint32_t) (&(thiscpu->cpu_ts)),
f01043a1:	e8 63 2a 00 00       	call   f0106e09 <cpunum>
f01043a6:	6b c0 74             	imul   $0x74,%eax,%eax
f01043a9:	0f b6 98 20 a0 2c f0 	movzbl -0xfd35fe0(%eax),%ebx
f01043b0:	83 c3 05             	add    $0x5,%ebx
f01043b3:	e8 51 2a 00 00       	call   f0106e09 <cpunum>
f01043b8:	89 c7                	mov    %eax,%edi
f01043ba:	e8 4a 2a 00 00       	call   f0106e09 <cpunum>
f01043bf:	89 c6                	mov    %eax,%esi
f01043c1:	e8 43 2a 00 00       	call   f0106e09 <cpunum>
f01043c6:	66 c7 04 dd 40 63 12 	movw   $0x67,-0xfed9cc0(,%ebx,8)
f01043cd:	f0 67 00 
f01043d0:	6b ff 74             	imul   $0x74,%edi,%edi
f01043d3:	81 c7 2c a0 2c f0    	add    $0xf02ca02c,%edi
f01043d9:	66 89 3c dd 42 63 12 	mov    %di,-0xfed9cbe(,%ebx,8)
f01043e0:	f0 
f01043e1:	6b d6 74             	imul   $0x74,%esi,%edx
f01043e4:	81 c2 2c a0 2c f0    	add    $0xf02ca02c,%edx
f01043ea:	c1 ea 10             	shr    $0x10,%edx
f01043ed:	88 14 dd 44 63 12 f0 	mov    %dl,-0xfed9cbc(,%ebx,8)
f01043f4:	c6 04 dd 45 63 12 f0 	movb   $0x99,-0xfed9cbb(,%ebx,8)
f01043fb:	99 
f01043fc:	c6 04 dd 46 63 12 f0 	movb   $0x40,-0xfed9cba(,%ebx,8)
f0104403:	40 
f0104404:	6b c0 74             	imul   $0x74,%eax,%eax
f0104407:	05 2c a0 2c f0       	add    $0xf02ca02c,%eax
f010440c:	c1 e8 18             	shr    $0x18,%eax
f010440f:	88 04 dd 47 63 12 f0 	mov    %al,-0xfed9cb9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + thiscpu->cpu_id].sd_s = 0;
f0104416:	e8 ee 29 00 00       	call   f0106e09 <cpunum>
f010441b:	6b c0 74             	imul   $0x74,%eax,%eax
f010441e:	0f b6 80 20 a0 2c f0 	movzbl -0xfd35fe0(%eax),%eax
f0104425:	80 24 c5 6d 63 12 f0 	andb   $0xef,-0xfed9c93(,%eax,8)
f010442c:	ef 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(GD_TSS0 + thiscpu->cpu_id * sizeof(struct Segdesc));
f010442d:	e8 d7 29 00 00       	call   f0106e09 <cpunum>
f0104432:	6b c0 74             	imul   $0x74,%eax,%eax
f0104435:	0f b6 80 20 a0 2c f0 	movzbl -0xfd35fe0(%eax),%eax
f010443c:	8d 04 c5 28 00 00 00 	lea    0x28(,%eax,8),%eax
}

static inline void
ltr(uint16_t sel)
{
	asm volatile("ltr %0" : : "r" (sel));
f0104443:	0f 00 d8             	ltr    %ax
}

static inline void
lidt(void *p)
{
	asm volatile("lidt (%0)" : : "r" (p));
f0104446:	b8 aa 63 12 f0       	mov    $0xf01263aa,%eax
f010444b:	0f 01 18             	lidtl  (%eax)

	// Load the IDT
	lidt(&idt_pd);
}
f010444e:	83 c4 0c             	add    $0xc,%esp
f0104451:	5b                   	pop    %ebx
f0104452:	5e                   	pop    %esi
f0104453:	5f                   	pop    %edi
f0104454:	5d                   	pop    %ebp
f0104455:	c3                   	ret    

f0104456 <trap_init>:
}


void
trap_init(void)
{
f0104456:	55                   	push   %ebp
f0104457:	89 e5                	mov    %esp,%ebp
f0104459:	83 ec 08             	sub    $0x8,%esp
	extern struct Segdesc gdt[];

	// LAB 3: Your code here.

	SETGATE(idt[T_DIVIDE], 0, GD_KT, t_divide, 0);
f010445c:	b8 48 4f 10 f0       	mov    $0xf0104f48,%eax
f0104461:	66 a3 60 92 2c f0    	mov    %ax,0xf02c9260
f0104467:	66 c7 05 62 92 2c f0 	movw   $0x8,0xf02c9262
f010446e:	08 00 
f0104470:	c6 05 64 92 2c f0 00 	movb   $0x0,0xf02c9264
f0104477:	c6 05 65 92 2c f0 8e 	movb   $0x8e,0xf02c9265
f010447e:	c1 e8 10             	shr    $0x10,%eax
f0104481:	66 a3 66 92 2c f0    	mov    %ax,0xf02c9266
	SETGATE(idt[T_DEBUG], 0, GD_KT, t_debug, 0);
f0104487:	b8 52 4f 10 f0       	mov    $0xf0104f52,%eax
f010448c:	66 a3 68 92 2c f0    	mov    %ax,0xf02c9268
f0104492:	66 c7 05 6a 92 2c f0 	movw   $0x8,0xf02c926a
f0104499:	08 00 
f010449b:	c6 05 6c 92 2c f0 00 	movb   $0x0,0xf02c926c
f01044a2:	c6 05 6d 92 2c f0 8e 	movb   $0x8e,0xf02c926d
f01044a9:	c1 e8 10             	shr    $0x10,%eax
f01044ac:	66 a3 6e 92 2c f0    	mov    %ax,0xf02c926e
	SETGATE(idt[T_NMI], 0, GD_KT, t_nmi, 0);
f01044b2:	b8 5c 4f 10 f0       	mov    $0xf0104f5c,%eax
f01044b7:	66 a3 70 92 2c f0    	mov    %ax,0xf02c9270
f01044bd:	66 c7 05 72 92 2c f0 	movw   $0x8,0xf02c9272
f01044c4:	08 00 
f01044c6:	c6 05 74 92 2c f0 00 	movb   $0x0,0xf02c9274
f01044cd:	c6 05 75 92 2c f0 8e 	movb   $0x8e,0xf02c9275
f01044d4:	c1 e8 10             	shr    $0x10,%eax
f01044d7:	66 a3 76 92 2c f0    	mov    %ax,0xf02c9276
	SETGATE(idt[T_BRKPT], 0, GD_KT, t_brkpt, 3);
f01044dd:	b8 62 4f 10 f0       	mov    $0xf0104f62,%eax
f01044e2:	66 a3 78 92 2c f0    	mov    %ax,0xf02c9278
f01044e8:	66 c7 05 7a 92 2c f0 	movw   $0x8,0xf02c927a
f01044ef:	08 00 
f01044f1:	c6 05 7c 92 2c f0 00 	movb   $0x0,0xf02c927c
f01044f8:	c6 05 7d 92 2c f0 ee 	movb   $0xee,0xf02c927d
f01044ff:	c1 e8 10             	shr    $0x10,%eax
f0104502:	66 a3 7e 92 2c f0    	mov    %ax,0xf02c927e
	SETGATE(idt[T_OFLOW], 0, GD_KT, t_oflow, 0);
f0104508:	b8 68 4f 10 f0       	mov    $0xf0104f68,%eax
f010450d:	66 a3 80 92 2c f0    	mov    %ax,0xf02c9280
f0104513:	66 c7 05 82 92 2c f0 	movw   $0x8,0xf02c9282
f010451a:	08 00 
f010451c:	c6 05 84 92 2c f0 00 	movb   $0x0,0xf02c9284
f0104523:	c6 05 85 92 2c f0 8e 	movb   $0x8e,0xf02c9285
f010452a:	c1 e8 10             	shr    $0x10,%eax
f010452d:	66 a3 86 92 2c f0    	mov    %ax,0xf02c9286
	SETGATE(idt[T_BOUND], 0, GD_KT, t_bound, 0);
f0104533:	b8 6e 4f 10 f0       	mov    $0xf0104f6e,%eax
f0104538:	66 a3 88 92 2c f0    	mov    %ax,0xf02c9288
f010453e:	66 c7 05 8a 92 2c f0 	movw   $0x8,0xf02c928a
f0104545:	08 00 
f0104547:	c6 05 8c 92 2c f0 00 	movb   $0x0,0xf02c928c
f010454e:	c6 05 8d 92 2c f0 8e 	movb   $0x8e,0xf02c928d
f0104555:	c1 e8 10             	shr    $0x10,%eax
f0104558:	66 a3 8e 92 2c f0    	mov    %ax,0xf02c928e
	SETGATE(idt[T_ILLOP], 0, GD_KT, t_illop, 0);
f010455e:	b8 74 4f 10 f0       	mov    $0xf0104f74,%eax
f0104563:	66 a3 90 92 2c f0    	mov    %ax,0xf02c9290
f0104569:	66 c7 05 92 92 2c f0 	movw   $0x8,0xf02c9292
f0104570:	08 00 
f0104572:	c6 05 94 92 2c f0 00 	movb   $0x0,0xf02c9294
f0104579:	c6 05 95 92 2c f0 8e 	movb   $0x8e,0xf02c9295
f0104580:	c1 e8 10             	shr    $0x10,%eax
f0104583:	66 a3 96 92 2c f0    	mov    %ax,0xf02c9296
	SETGATE(idt[T_DEVICE], 0, GD_KT, t_device, 0);
f0104589:	b8 7a 4f 10 f0       	mov    $0xf0104f7a,%eax
f010458e:	66 a3 98 92 2c f0    	mov    %ax,0xf02c9298
f0104594:	66 c7 05 9a 92 2c f0 	movw   $0x8,0xf02c929a
f010459b:	08 00 
f010459d:	c6 05 9c 92 2c f0 00 	movb   $0x0,0xf02c929c
f01045a4:	c6 05 9d 92 2c f0 8e 	movb   $0x8e,0xf02c929d
f01045ab:	c1 e8 10             	shr    $0x10,%eax
f01045ae:	66 a3 9e 92 2c f0    	mov    %ax,0xf02c929e
	SETGATE(idt[T_DBLFLT], 0, GD_KT, t_dblflt, 0);
f01045b4:	b8 80 4f 10 f0       	mov    $0xf0104f80,%eax
f01045b9:	66 a3 a0 92 2c f0    	mov    %ax,0xf02c92a0
f01045bf:	66 c7 05 a2 92 2c f0 	movw   $0x8,0xf02c92a2
f01045c6:	08 00 
f01045c8:	c6 05 a4 92 2c f0 00 	movb   $0x0,0xf02c92a4
f01045cf:	c6 05 a5 92 2c f0 8e 	movb   $0x8e,0xf02c92a5
f01045d6:	c1 e8 10             	shr    $0x10,%eax
f01045d9:	66 a3 a6 92 2c f0    	mov    %ax,0xf02c92a6
	SETGATE(idt[T_TSS], 0, GD_KT, t_tss, 0);
f01045df:	b8 84 4f 10 f0       	mov    $0xf0104f84,%eax
f01045e4:	66 a3 b0 92 2c f0    	mov    %ax,0xf02c92b0
f01045ea:	66 c7 05 b2 92 2c f0 	movw   $0x8,0xf02c92b2
f01045f1:	08 00 
f01045f3:	c6 05 b4 92 2c f0 00 	movb   $0x0,0xf02c92b4
f01045fa:	c6 05 b5 92 2c f0 8e 	movb   $0x8e,0xf02c92b5
f0104601:	c1 e8 10             	shr    $0x10,%eax
f0104604:	66 a3 b6 92 2c f0    	mov    %ax,0xf02c92b6
	SETGATE(idt[T_SEGNP], 0, GD_KT, t_segnp, 0);
f010460a:	b8 88 4f 10 f0       	mov    $0xf0104f88,%eax
f010460f:	66 a3 b8 92 2c f0    	mov    %ax,0xf02c92b8
f0104615:	66 c7 05 ba 92 2c f0 	movw   $0x8,0xf02c92ba
f010461c:	08 00 
f010461e:	c6 05 bc 92 2c f0 00 	movb   $0x0,0xf02c92bc
f0104625:	c6 05 bd 92 2c f0 8e 	movb   $0x8e,0xf02c92bd
f010462c:	c1 e8 10             	shr    $0x10,%eax
f010462f:	66 a3 be 92 2c f0    	mov    %ax,0xf02c92be
	SETGATE(idt[T_STACK], 0, GD_KT, t_stack, 0);
f0104635:	b8 8c 4f 10 f0       	mov    $0xf0104f8c,%eax
f010463a:	66 a3 c0 92 2c f0    	mov    %ax,0xf02c92c0
f0104640:	66 c7 05 c2 92 2c f0 	movw   $0x8,0xf02c92c2
f0104647:	08 00 
f0104649:	c6 05 c4 92 2c f0 00 	movb   $0x0,0xf02c92c4
f0104650:	c6 05 c5 92 2c f0 8e 	movb   $0x8e,0xf02c92c5
f0104657:	c1 e8 10             	shr    $0x10,%eax
f010465a:	66 a3 c6 92 2c f0    	mov    %ax,0xf02c92c6
	SETGATE(idt[T_GPFLT], 0, GD_KT, t_gpflt, 0);
f0104660:	b8 90 4f 10 f0       	mov    $0xf0104f90,%eax
f0104665:	66 a3 c8 92 2c f0    	mov    %ax,0xf02c92c8
f010466b:	66 c7 05 ca 92 2c f0 	movw   $0x8,0xf02c92ca
f0104672:	08 00 
f0104674:	c6 05 cc 92 2c f0 00 	movb   $0x0,0xf02c92cc
f010467b:	c6 05 cd 92 2c f0 8e 	movb   $0x8e,0xf02c92cd
f0104682:	c1 e8 10             	shr    $0x10,%eax
f0104685:	66 a3 ce 92 2c f0    	mov    %ax,0xf02c92ce
	SETGATE(idt[T_PGFLT], 0, GD_KT, t_pgflt, 0);
f010468b:	b8 94 4f 10 f0       	mov    $0xf0104f94,%eax
f0104690:	66 a3 d0 92 2c f0    	mov    %ax,0xf02c92d0
f0104696:	66 c7 05 d2 92 2c f0 	movw   $0x8,0xf02c92d2
f010469d:	08 00 
f010469f:	c6 05 d4 92 2c f0 00 	movb   $0x0,0xf02c92d4
f01046a6:	c6 05 d5 92 2c f0 8e 	movb   $0x8e,0xf02c92d5
f01046ad:	c1 e8 10             	shr    $0x10,%eax
f01046b0:	66 a3 d6 92 2c f0    	mov    %ax,0xf02c92d6
	SETGATE(idt[T_FPERR], 0, GD_KT, t_fperr, 0);
f01046b6:	b8 98 4f 10 f0       	mov    $0xf0104f98,%eax
f01046bb:	66 a3 e0 92 2c f0    	mov    %ax,0xf02c92e0
f01046c1:	66 c7 05 e2 92 2c f0 	movw   $0x8,0xf02c92e2
f01046c8:	08 00 
f01046ca:	c6 05 e4 92 2c f0 00 	movb   $0x0,0xf02c92e4
f01046d1:	c6 05 e5 92 2c f0 8e 	movb   $0x8e,0xf02c92e5
f01046d8:	c1 e8 10             	shr    $0x10,%eax
f01046db:	66 a3 e6 92 2c f0    	mov    %ax,0xf02c92e6
	SETGATE(idt[T_ALIGN], 0, GD_KT, t_align, 0);
f01046e1:	b8 9e 4f 10 f0       	mov    $0xf0104f9e,%eax
f01046e6:	66 a3 e8 92 2c f0    	mov    %ax,0xf02c92e8
f01046ec:	66 c7 05 ea 92 2c f0 	movw   $0x8,0xf02c92ea
f01046f3:	08 00 
f01046f5:	c6 05 ec 92 2c f0 00 	movb   $0x0,0xf02c92ec
f01046fc:	c6 05 ed 92 2c f0 8e 	movb   $0x8e,0xf02c92ed
f0104703:	c1 e8 10             	shr    $0x10,%eax
f0104706:	66 a3 ee 92 2c f0    	mov    %ax,0xf02c92ee
	SETGATE(idt[T_MCHK], 0, GD_KT, t_mchk, 0);
f010470c:	b8 a2 4f 10 f0       	mov    $0xf0104fa2,%eax
f0104711:	66 a3 f0 92 2c f0    	mov    %ax,0xf02c92f0
f0104717:	66 c7 05 f2 92 2c f0 	movw   $0x8,0xf02c92f2
f010471e:	08 00 
f0104720:	c6 05 f4 92 2c f0 00 	movb   $0x0,0xf02c92f4
f0104727:	c6 05 f5 92 2c f0 8e 	movb   $0x8e,0xf02c92f5
f010472e:	c1 e8 10             	shr    $0x10,%eax
f0104731:	66 a3 f6 92 2c f0    	mov    %ax,0xf02c92f6
	SETGATE(idt[T_SIMDERR], 0, GD_KT, t_simderr, 0);
f0104737:	b8 a8 4f 10 f0       	mov    $0xf0104fa8,%eax
f010473c:	66 a3 f8 92 2c f0    	mov    %ax,0xf02c92f8
f0104742:	66 c7 05 fa 92 2c f0 	movw   $0x8,0xf02c92fa
f0104749:	08 00 
f010474b:	c6 05 fc 92 2c f0 00 	movb   $0x0,0xf02c92fc
f0104752:	c6 05 fd 92 2c f0 8e 	movb   $0x8e,0xf02c92fd
f0104759:	c1 e8 10             	shr    $0x10,%eax
f010475c:	66 a3 fe 92 2c f0    	mov    %ax,0xf02c92fe

	SETGATE(idt[T_SYSCALL], 0, GD_KT, t_syscall, 3);
f0104762:	b8 ae 4f 10 f0       	mov    $0xf0104fae,%eax
f0104767:	66 a3 e0 93 2c f0    	mov    %ax,0xf02c93e0
f010476d:	66 c7 05 e2 93 2c f0 	movw   $0x8,0xf02c93e2
f0104774:	08 00 
f0104776:	c6 05 e4 93 2c f0 00 	movb   $0x0,0xf02c93e4
f010477d:	c6 05 e5 93 2c f0 ee 	movb   $0xee,0xf02c93e5
f0104784:	c1 e8 10             	shr    $0x10,%eax
f0104787:	66 a3 e6 93 2c f0    	mov    %ax,0xf02c93e6

	SETGATE(idt[IRQ_OFFSET + IRQ_TIMER], 0, GD_KT, irq_timer, 0);
f010478d:	b8 b4 4f 10 f0       	mov    $0xf0104fb4,%eax
f0104792:	66 a3 60 93 2c f0    	mov    %ax,0xf02c9360
f0104798:	66 c7 05 62 93 2c f0 	movw   $0x8,0xf02c9362
f010479f:	08 00 
f01047a1:	c6 05 64 93 2c f0 00 	movb   $0x0,0xf02c9364
f01047a8:	c6 05 65 93 2c f0 8e 	movb   $0x8e,0xf02c9365
f01047af:	c1 e8 10             	shr    $0x10,%eax
f01047b2:	66 a3 66 93 2c f0    	mov    %ax,0xf02c9366
	SETGATE(idt[IRQ_OFFSET + IRQ_KBD], 0, GD_KT, irq_kbd, 0);
f01047b8:	b8 ba 4f 10 f0       	mov    $0xf0104fba,%eax
f01047bd:	66 a3 68 93 2c f0    	mov    %ax,0xf02c9368
f01047c3:	66 c7 05 6a 93 2c f0 	movw   $0x8,0xf02c936a
f01047ca:	08 00 
f01047cc:	c6 05 6c 93 2c f0 00 	movb   $0x0,0xf02c936c
f01047d3:	c6 05 6d 93 2c f0 8e 	movb   $0x8e,0xf02c936d
f01047da:	c1 e8 10             	shr    $0x10,%eax
f01047dd:	66 a3 6e 93 2c f0    	mov    %ax,0xf02c936e
	SETGATE(idt[IRQ_OFFSET + IRQ_SERIAL], 0, GD_KT, irq_serial, 0);
f01047e3:	b8 c0 4f 10 f0       	mov    $0xf0104fc0,%eax
f01047e8:	66 a3 80 93 2c f0    	mov    %ax,0xf02c9380
f01047ee:	66 c7 05 82 93 2c f0 	movw   $0x8,0xf02c9382
f01047f5:	08 00 
f01047f7:	c6 05 84 93 2c f0 00 	movb   $0x0,0xf02c9384
f01047fe:	c6 05 85 93 2c f0 8e 	movb   $0x8e,0xf02c9385
f0104805:	c1 e8 10             	shr    $0x10,%eax
f0104808:	66 a3 86 93 2c f0    	mov    %ax,0xf02c9386
	SETGATE(idt[IRQ_OFFSET + IRQ_SPURIOUS], 0, GD_KT, irq_spurious, 0);
f010480e:	b8 c6 4f 10 f0       	mov    $0xf0104fc6,%eax
f0104813:	66 a3 98 93 2c f0    	mov    %ax,0xf02c9398
f0104819:	66 c7 05 9a 93 2c f0 	movw   $0x8,0xf02c939a
f0104820:	08 00 
f0104822:	c6 05 9c 93 2c f0 00 	movb   $0x0,0xf02c939c
f0104829:	c6 05 9d 93 2c f0 8e 	movb   $0x8e,0xf02c939d
f0104830:	c1 e8 10             	shr    $0x10,%eax
f0104833:	66 a3 9e 93 2c f0    	mov    %ax,0xf02c939e
	SETGATE(idt[IRQ_OFFSET + IRQ_E1000], 0, GD_KT, irq_e1000, 0);
f0104839:	b8 cc 4f 10 f0       	mov    $0xf0104fcc,%eax
f010483e:	66 a3 b8 93 2c f0    	mov    %ax,0xf02c93b8
f0104844:	66 c7 05 ba 93 2c f0 	movw   $0x8,0xf02c93ba
f010484b:	08 00 
f010484d:	c6 05 bc 93 2c f0 00 	movb   $0x0,0xf02c93bc
f0104854:	c6 05 bd 93 2c f0 8e 	movb   $0x8e,0xf02c93bd
f010485b:	c1 e8 10             	shr    $0x10,%eax
f010485e:	66 a3 be 93 2c f0    	mov    %ax,0xf02c93be
	SETGATE(idt[IRQ_OFFSET + IRQ_IDE], 0, GD_KT, irq_ide, 0);
f0104864:	b8 d2 4f 10 f0       	mov    $0xf0104fd2,%eax
f0104869:	66 a3 d0 93 2c f0    	mov    %ax,0xf02c93d0
f010486f:	66 c7 05 d2 93 2c f0 	movw   $0x8,0xf02c93d2
f0104876:	08 00 
f0104878:	c6 05 d4 93 2c f0 00 	movb   $0x0,0xf02c93d4
f010487f:	c6 05 d5 93 2c f0 8e 	movb   $0x8e,0xf02c93d5
f0104886:	c1 e8 10             	shr    $0x10,%eax
f0104889:	66 a3 d6 93 2c f0    	mov    %ax,0xf02c93d6
	SETGATE(idt[IRQ_OFFSET + IRQ_ERROR], 0, GD_KT, irq_error, 0);
f010488f:	b8 d8 4f 10 f0       	mov    $0xf0104fd8,%eax
f0104894:	66 a3 f8 93 2c f0    	mov    %ax,0xf02c93f8
f010489a:	66 c7 05 fa 93 2c f0 	movw   $0x8,0xf02c93fa
f01048a1:	08 00 
f01048a3:	c6 05 fc 93 2c f0 00 	movb   $0x0,0xf02c93fc
f01048aa:	c6 05 fd 93 2c f0 8e 	movb   $0x8e,0xf02c93fd
f01048b1:	c1 e8 10             	shr    $0x10,%eax
f01048b4:	66 a3 fe 93 2c f0    	mov    %ax,0xf02c93fe

	// Per-CPU setup 
	trap_init_percpu();
f01048ba:	e8 a1 fa ff ff       	call   f0104360 <trap_init_percpu>
}
f01048bf:	c9                   	leave  
f01048c0:	c3                   	ret    

f01048c1 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f01048c1:	55                   	push   %ebp
f01048c2:	89 e5                	mov    %esp,%ebp
f01048c4:	53                   	push   %ebx
f01048c5:	83 ec 14             	sub    $0x14,%esp
f01048c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f01048cb:	8b 03                	mov    (%ebx),%eax
f01048cd:	89 44 24 04          	mov    %eax,0x4(%esp)
f01048d1:	c7 04 24 c3 96 10 f0 	movl   $0xf01096c3,(%esp)
f01048d8:	e8 65 fa ff ff       	call   f0104342 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f01048dd:	8b 43 04             	mov    0x4(%ebx),%eax
f01048e0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01048e4:	c7 04 24 d2 96 10 f0 	movl   $0xf01096d2,(%esp)
f01048eb:	e8 52 fa ff ff       	call   f0104342 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f01048f0:	8b 43 08             	mov    0x8(%ebx),%eax
f01048f3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01048f7:	c7 04 24 e1 96 10 f0 	movl   $0xf01096e1,(%esp)
f01048fe:	e8 3f fa ff ff       	call   f0104342 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0104903:	8b 43 0c             	mov    0xc(%ebx),%eax
f0104906:	89 44 24 04          	mov    %eax,0x4(%esp)
f010490a:	c7 04 24 f0 96 10 f0 	movl   $0xf01096f0,(%esp)
f0104911:	e8 2c fa ff ff       	call   f0104342 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0104916:	8b 43 10             	mov    0x10(%ebx),%eax
f0104919:	89 44 24 04          	mov    %eax,0x4(%esp)
f010491d:	c7 04 24 ff 96 10 f0 	movl   $0xf01096ff,(%esp)
f0104924:	e8 19 fa ff ff       	call   f0104342 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0104929:	8b 43 14             	mov    0x14(%ebx),%eax
f010492c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104930:	c7 04 24 0e 97 10 f0 	movl   $0xf010970e,(%esp)
f0104937:	e8 06 fa ff ff       	call   f0104342 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f010493c:	8b 43 18             	mov    0x18(%ebx),%eax
f010493f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104943:	c7 04 24 1d 97 10 f0 	movl   $0xf010971d,(%esp)
f010494a:	e8 f3 f9 ff ff       	call   f0104342 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f010494f:	8b 43 1c             	mov    0x1c(%ebx),%eax
f0104952:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104956:	c7 04 24 2c 97 10 f0 	movl   $0xf010972c,(%esp)
f010495d:	e8 e0 f9 ff ff       	call   f0104342 <cprintf>
}
f0104962:	83 c4 14             	add    $0x14,%esp
f0104965:	5b                   	pop    %ebx
f0104966:	5d                   	pop    %ebp
f0104967:	c3                   	ret    

f0104968 <print_trapframe>:
	lidt(&idt_pd);
}

void
print_trapframe(struct Trapframe *tf)
{
f0104968:	55                   	push   %ebp
f0104969:	89 e5                	mov    %esp,%ebp
f010496b:	56                   	push   %esi
f010496c:	53                   	push   %ebx
f010496d:	83 ec 10             	sub    $0x10,%esp
f0104970:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0104973:	e8 91 24 00 00       	call   f0106e09 <cpunum>
f0104978:	89 44 24 08          	mov    %eax,0x8(%esp)
f010497c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0104980:	c7 04 24 90 97 10 f0 	movl   $0xf0109790,(%esp)
f0104987:	e8 b6 f9 ff ff       	call   f0104342 <cprintf>
	print_regs(&tf->tf_regs);
f010498c:	89 1c 24             	mov    %ebx,(%esp)
f010498f:	e8 2d ff ff ff       	call   f01048c1 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0104994:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0104998:	89 44 24 04          	mov    %eax,0x4(%esp)
f010499c:	c7 04 24 ae 97 10 f0 	movl   $0xf01097ae,(%esp)
f01049a3:	e8 9a f9 ff ff       	call   f0104342 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f01049a8:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f01049ac:	89 44 24 04          	mov    %eax,0x4(%esp)
f01049b0:	c7 04 24 c1 97 10 f0 	movl   $0xf01097c1,(%esp)
f01049b7:	e8 86 f9 ff ff       	call   f0104342 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01049bc:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
f01049bf:	83 f8 13             	cmp    $0x13,%eax
f01049c2:	77 09                	ja     f01049cd <print_trapframe+0x65>
		return excnames[trapno];
f01049c4:	8b 14 85 80 9a 10 f0 	mov    -0xfef6580(,%eax,4),%edx
f01049cb:	eb 1f                	jmp    f01049ec <print_trapframe+0x84>
	if (trapno == T_SYSCALL)
f01049cd:	83 f8 30             	cmp    $0x30,%eax
f01049d0:	74 15                	je     f01049e7 <print_trapframe+0x7f>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f01049d2:	8d 50 e0             	lea    -0x20(%eax),%edx
		return "Hardware Interrupt";
f01049d5:	83 fa 0f             	cmp    $0xf,%edx
f01049d8:	ba 47 97 10 f0       	mov    $0xf0109747,%edx
f01049dd:	b9 5a 97 10 f0       	mov    $0xf010975a,%ecx
f01049e2:	0f 47 d1             	cmova  %ecx,%edx
f01049e5:	eb 05                	jmp    f01049ec <print_trapframe+0x84>
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
f01049e7:	ba 3b 97 10 f0       	mov    $0xf010973b,%edx
{
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f01049ec:	89 54 24 08          	mov    %edx,0x8(%esp)
f01049f0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01049f4:	c7 04 24 d4 97 10 f0 	movl   $0xf01097d4,(%esp)
f01049fb:	e8 42 f9 ff ff       	call   f0104342 <cprintf>
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0104a00:	3b 1d 60 9a 2c f0    	cmp    0xf02c9a60,%ebx
f0104a06:	75 19                	jne    f0104a21 <print_trapframe+0xb9>
f0104a08:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104a0c:	75 13                	jne    f0104a21 <print_trapframe+0xb9>

static inline uint32_t
rcr2(void)
{
	uint32_t val;
	asm volatile("movl %%cr2,%0" : "=r" (val));
f0104a0e:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f0104a11:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a15:	c7 04 24 e6 97 10 f0 	movl   $0xf01097e6,(%esp)
f0104a1c:	e8 21 f9 ff ff       	call   f0104342 <cprintf>
	cprintf("  err  0x%08x", tf->tf_err);
f0104a21:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0104a24:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a28:	c7 04 24 f5 97 10 f0 	movl   $0xf01097f5,(%esp)
f0104a2f:	e8 0e f9 ff ff       	call   f0104342 <cprintf>
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
f0104a34:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104a38:	75 51                	jne    f0104a8b <print_trapframe+0x123>
		cprintf(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
f0104a3a:	8b 43 2c             	mov    0x2c(%ebx),%eax
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		cprintf(" [%s, %s, %s]\n",
f0104a3d:	89 c2                	mov    %eax,%edx
f0104a3f:	83 e2 01             	and    $0x1,%edx
f0104a42:	ba 69 97 10 f0       	mov    $0xf0109769,%edx
f0104a47:	b9 74 97 10 f0       	mov    $0xf0109774,%ecx
f0104a4c:	0f 45 ca             	cmovne %edx,%ecx
f0104a4f:	89 c2                	mov    %eax,%edx
f0104a51:	83 e2 02             	and    $0x2,%edx
f0104a54:	ba 80 97 10 f0       	mov    $0xf0109780,%edx
f0104a59:	be 86 97 10 f0       	mov    $0xf0109786,%esi
f0104a5e:	0f 44 d6             	cmove  %esi,%edx
f0104a61:	83 e0 04             	and    $0x4,%eax
f0104a64:	b8 8b 97 10 f0       	mov    $0xf010978b,%eax
f0104a69:	be c0 98 10 f0       	mov    $0xf01098c0,%esi
f0104a6e:	0f 44 c6             	cmove  %esi,%eax
f0104a71:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0104a75:	89 54 24 08          	mov    %edx,0x8(%esp)
f0104a79:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a7d:	c7 04 24 03 98 10 f0 	movl   $0xf0109803,(%esp)
f0104a84:	e8 b9 f8 ff ff       	call   f0104342 <cprintf>
f0104a89:	eb 0c                	jmp    f0104a97 <print_trapframe+0x12f>
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		cprintf("\n");
f0104a8b:	c7 04 24 a9 95 10 f0 	movl   $0xf01095a9,(%esp)
f0104a92:	e8 ab f8 ff ff       	call   f0104342 <cprintf>
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104a97:	8b 43 30             	mov    0x30(%ebx),%eax
f0104a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104a9e:	c7 04 24 12 98 10 f0 	movl   $0xf0109812,(%esp)
f0104aa5:	e8 98 f8 ff ff       	call   f0104342 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f0104aaa:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0104aae:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104ab2:	c7 04 24 21 98 10 f0 	movl   $0xf0109821,(%esp)
f0104ab9:	e8 84 f8 ff ff       	call   f0104342 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f0104abe:	8b 43 38             	mov    0x38(%ebx),%eax
f0104ac1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104ac5:	c7 04 24 34 98 10 f0 	movl   $0xf0109834,(%esp)
f0104acc:	e8 71 f8 ff ff       	call   f0104342 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f0104ad1:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0104ad5:	74 27                	je     f0104afe <print_trapframe+0x196>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f0104ad7:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104ada:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104ade:	c7 04 24 43 98 10 f0 	movl   $0xf0109843,(%esp)
f0104ae5:	e8 58 f8 ff ff       	call   f0104342 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0104aea:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104aee:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104af2:	c7 04 24 52 98 10 f0 	movl   $0xf0109852,(%esp)
f0104af9:	e8 44 f8 ff ff       	call   f0104342 <cprintf>
	}
}
f0104afe:	83 c4 10             	add    $0x10,%esp
f0104b01:	5b                   	pop    %ebx
f0104b02:	5e                   	pop    %esi
f0104b03:	5d                   	pop    %ebp
f0104b04:	c3                   	ret    

f0104b05 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0104b05:	55                   	push   %ebp
f0104b06:	89 e5                	mov    %esp,%ebp
f0104b08:	57                   	push   %edi
f0104b09:	56                   	push   %esi
f0104b0a:	53                   	push   %ebx
f0104b0b:	83 ec 2c             	sub    $0x2c,%esp
f0104b0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104b11:	0f 20 d6             	mov    %cr2,%esi
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	if ((tf->tf_cs & 0x1) == 0) { // in kernel, panic
f0104b14:	f6 43 34 01          	testb  $0x1,0x34(%ebx)
f0104b18:	75 28                	jne    f0104b42 <page_fault_handler+0x3d>
		print_trapframe(tf);
f0104b1a:	89 1c 24             	mov    %ebx,(%esp)
f0104b1d:	e8 46 fe ff ff       	call   f0104968 <print_trapframe>
		panic("page_fault_handler: page fault in kernel, faulting addr %08x", fault_va);
f0104b22:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0104b26:	c7 44 24 08 0c 9a 10 	movl   $0xf0109a0c,0x8(%esp)
f0104b2d:	f0 
f0104b2e:	c7 44 24 04 81 01 00 	movl   $0x181,0x4(%esp)
f0104b35:	00 
f0104b36:	c7 04 24 65 98 10 f0 	movl   $0xf0109865,(%esp)
f0104b3d:	e8 fe b4 ff ff       	call   f0100040 <_panic>

	// LAB 4: Your code here.

	// If the user didn't set a pgfault handler, or the trap-time
	// stack pointer is out of bounds.
	if (curenv->env_pgfault_upcall == NULL ||
f0104b42:	e8 c2 22 00 00       	call   f0106e09 <cpunum>
f0104b47:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b4a:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104b50:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0104b54:	74 16                	je     f0104b6c <page_fault_handler+0x67>
		tf->tf_esp > UXSTACKTOP ||
f0104b56:	8b 43 3c             	mov    0x3c(%ebx),%eax

	// LAB 4: Your code here.

	// If the user didn't set a pgfault handler, or the trap-time
	// stack pointer is out of bounds.
	if (curenv->env_pgfault_upcall == NULL ||
f0104b59:	3d 00 00 c0 ee       	cmp    $0xeec00000,%eax
f0104b5e:	77 0c                	ja     f0104b6c <page_fault_handler+0x67>
		tf->tf_esp > UXSTACKTOP ||
		(tf->tf_esp > USTACKTOP && tf->tf_esp < (UXSTACKTOP - PGSIZE)))
f0104b60:	05 ff 1f 40 11       	add    $0x11401fff,%eax
	// LAB 4: Your code here.

	// If the user didn't set a pgfault handler, or the trap-time
	// stack pointer is out of bounds.
	if (curenv->env_pgfault_upcall == NULL ||
		tf->tf_esp > UXSTACKTOP ||
f0104b65:	3d fe 0f 00 00       	cmp    $0xffe,%eax
f0104b6a:	77 4a                	ja     f0104bb6 <page_fault_handler+0xb1>
		(tf->tf_esp > USTACKTOP && tf->tf_esp < (UXSTACKTOP - PGSIZE)))
	{
		cprintf("[%08x] user fault va %08x ip %08x\n",
f0104b6c:	8b 7b 30             	mov    0x30(%ebx),%edi
			curenv->env_id, fault_va, tf->tf_eip);
f0104b6f:	e8 95 22 00 00       	call   f0106e09 <cpunum>
	// stack pointer is out of bounds.
	if (curenv->env_pgfault_upcall == NULL ||
		tf->tf_esp > UXSTACKTOP ||
		(tf->tf_esp > USTACKTOP && tf->tf_esp < (UXSTACKTOP - PGSIZE)))
	{
		cprintf("[%08x] user fault va %08x ip %08x\n",
f0104b74:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0104b78:	89 74 24 08          	mov    %esi,0x8(%esp)
			curenv->env_id, fault_va, tf->tf_eip);
f0104b7c:	6b c0 74             	imul   $0x74,%eax,%eax
	// stack pointer is out of bounds.
	if (curenv->env_pgfault_upcall == NULL ||
		tf->tf_esp > UXSTACKTOP ||
		(tf->tf_esp > USTACKTOP && tf->tf_esp < (UXSTACKTOP - PGSIZE)))
	{
		cprintf("[%08x] user fault va %08x ip %08x\n",
f0104b7f:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104b85:	8b 40 48             	mov    0x48(%eax),%eax
f0104b88:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104b8c:	c7 04 24 4c 9a 10 f0 	movl   $0xf0109a4c,(%esp)
f0104b93:	e8 aa f7 ff ff       	call   f0104342 <cprintf>
			curenv->env_id, fault_va, tf->tf_eip);
		print_trapframe(tf);
f0104b98:	89 1c 24             	mov    %ebx,(%esp)
f0104b9b:	e8 c8 fd ff ff       	call   f0104968 <print_trapframe>
		env_destroy(curenv);
f0104ba0:	e8 64 22 00 00       	call   f0106e09 <cpunum>
f0104ba5:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ba8:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104bae:	89 04 24             	mov    %eax,(%esp)
f0104bb1:	e8 7c f4 ff ff       	call   f0104032 <env_destroy>
	}

	// Determine the top of the exception stack
	uint32_t exception_stack_top;
	if (tf->tf_esp < USTACKTOP) {
f0104bb6:	8b 43 3c             	mov    0x3c(%ebx),%eax
	} else {
		// Recursive fault, we're already in the exception stack running the
		// handler code.
		// Note the -4 at the end, that's for the empty word separating the
		// two exception trapframes.
		exception_stack_top = tf->tf_esp - sizeof(struct UTrapframe) - 4;
f0104bb9:	8d 50 c8             	lea    -0x38(%eax),%edx
f0104bbc:	3d ff df bf ee       	cmp    $0xeebfdfff,%eax
f0104bc1:	b8 cc ff bf ee       	mov    $0xeebfffcc,%eax
f0104bc6:	0f 47 c2             	cmova  %edx,%eax
f0104bc9:	89 c7                	mov    %eax,%edi
f0104bcb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Make sure we can write to the top of our exception stack. This implicitly
	// checks two conditions:
	// 1) if the user process mapped a page from UXSTACKTOP to UXSTACKTOP - PGSIZE
	// 2) if we've ran over the exception stack, beyond UXSTACKTOP - PGSIZE
	user_mem_assert(curenv, (void *) exception_stack_top, 1, PTE_W | PTE_U);
f0104bce:	e8 36 22 00 00       	call   f0106e09 <cpunum>
f0104bd3:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f0104bda:	00 
f0104bdb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104be2:	00 
f0104be3:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0104be7:	6b c0 74             	imul   $0x74,%eax,%eax
f0104bea:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104bf0:	89 04 24             	mov    %eax,(%esp)
f0104bf3:	e8 90 ed ff ff       	call   f0103988 <user_mem_assert>

	// Write the UTrapframe to the exception stack
	struct UTrapframe *u_tf = (struct UTrapframe *) exception_stack_top;
f0104bf8:	89 f8                	mov    %edi,%eax
	u_tf->utf_fault_va = fault_va;
f0104bfa:	89 37                	mov    %esi,(%edi)
	u_tf->utf_err = tf->tf_err;
f0104bfc:	8b 53 2c             	mov    0x2c(%ebx),%edx
f0104bff:	89 57 04             	mov    %edx,0x4(%edi)
	u_tf->utf_regs = tf->tf_regs;
f0104c02:	8d 7f 08             	lea    0x8(%edi),%edi
f0104c05:	89 de                	mov    %ebx,%esi
f0104c07:	ba 20 00 00 00       	mov    $0x20,%edx
f0104c0c:	f7 c7 01 00 00 00    	test   $0x1,%edi
f0104c12:	74 03                	je     f0104c17 <page_fault_handler+0x112>
f0104c14:	a4                   	movsb  %ds:(%esi),%es:(%edi)
f0104c15:	b2 1f                	mov    $0x1f,%dl
f0104c17:	f7 c7 02 00 00 00    	test   $0x2,%edi
f0104c1d:	74 05                	je     f0104c24 <page_fault_handler+0x11f>
f0104c1f:	66 a5                	movsw  %ds:(%esi),%es:(%edi)
f0104c21:	83 ea 02             	sub    $0x2,%edx
f0104c24:	89 d1                	mov    %edx,%ecx
f0104c26:	c1 e9 02             	shr    $0x2,%ecx
f0104c29:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0104c2b:	f6 c2 02             	test   $0x2,%dl
f0104c2e:	74 0b                	je     f0104c3b <page_fault_handler+0x136>
f0104c30:	0f b7 0e             	movzwl (%esi),%ecx
f0104c33:	66 89 0f             	mov    %cx,(%edi)
f0104c36:	b9 02 00 00 00       	mov    $0x2,%ecx
f0104c3b:	f6 c2 01             	test   $0x1,%dl
f0104c3e:	74 07                	je     f0104c47 <page_fault_handler+0x142>
f0104c40:	0f b6 14 0e          	movzbl (%esi,%ecx,1),%edx
f0104c44:	88 14 0f             	mov    %dl,(%edi,%ecx,1)
	u_tf->utf_eip = tf->tf_eip;
f0104c47:	8b 53 30             	mov    0x30(%ebx),%edx
f0104c4a:	89 50 28             	mov    %edx,0x28(%eax)
	u_tf->utf_eflags = tf->tf_eflags;
f0104c4d:	8b 53 38             	mov    0x38(%ebx),%edx
f0104c50:	89 50 2c             	mov    %edx,0x2c(%eax)
	u_tf->utf_esp = tf->tf_esp;
f0104c53:	8b 53 3c             	mov    0x3c(%ebx),%edx
f0104c56:	89 50 30             	mov    %edx,0x30(%eax)

	// Now adjust the trap frame so that the user process returns to executing
	// in the exception stack and runs code from the handler.
	tf->tf_esp = (uintptr_t) exception_stack_top;
f0104c59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104c5c:	89 43 3c             	mov    %eax,0x3c(%ebx)
	tf->tf_eip = (uintptr_t) curenv->env_pgfault_upcall;
f0104c5f:	e8 a5 21 00 00       	call   f0106e09 <cpunum>
f0104c64:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c67:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104c6d:	8b 40 64             	mov    0x64(%eax),%eax
f0104c70:	89 43 30             	mov    %eax,0x30(%ebx)

	env_run(curenv);
f0104c73:	e8 91 21 00 00       	call   f0106e09 <cpunum>
f0104c78:	6b c0 74             	imul   $0x74,%eax,%eax
f0104c7b:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104c81:	89 04 24             	mov    %eax,(%esp)
f0104c84:	e8 4a f4 ff ff       	call   f01040d3 <env_run>

f0104c89 <trap>:

}

void
trap(struct Trapframe *tf)
{
f0104c89:	55                   	push   %ebp
f0104c8a:	89 e5                	mov    %esp,%ebp
f0104c8c:	57                   	push   %edi
f0104c8d:	56                   	push   %esi
f0104c8e:	83 ec 20             	sub    $0x20,%esp
f0104c91:	8b 75 08             	mov    0x8(%ebp),%esi
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");
f0104c94:	fc                   	cld    

	// Halt the CPU if some other CPU has called panic()
	extern char *panicstr;
	if (panicstr)
f0104c95:	83 3d 8c 9e 2c f0 00 	cmpl   $0x0,0xf02c9e8c
f0104c9c:	74 01                	je     f0104c9f <trap+0x16>
		asm volatile("hlt");
f0104c9e:	f4                   	hlt    

	// Re-acqurie the big kernel lock if we were halted in
	// sched_yield()
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f0104c9f:	e8 65 21 00 00       	call   f0106e09 <cpunum>
f0104ca4:	6b d0 74             	imul   $0x74,%eax,%edx
f0104ca7:	81 c2 20 a0 2c f0    	add    $0xf02ca020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0104cad:	b8 01 00 00 00       	mov    $0x1,%eax
f0104cb2:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
f0104cb6:	83 f8 02             	cmp    $0x2,%eax
f0104cb9:	75 0c                	jne    f0104cc7 <trap+0x3e>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f0104cbb:	c7 04 24 c0 63 12 f0 	movl   $0xf01263c0,(%esp)
f0104cc2:	e8 c0 23 00 00       	call   f0107087 <spin_lock>

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f0104cc7:	9c                   	pushf  
f0104cc8:	58                   	pop    %eax
		lock_kernel();
	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));
f0104cc9:	f6 c4 02             	test   $0x2,%ah
f0104ccc:	74 24                	je     f0104cf2 <trap+0x69>
f0104cce:	c7 44 24 0c 71 98 10 	movl   $0xf0109871,0xc(%esp)
f0104cd5:	f0 
f0104cd6:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0104cdd:	f0 
f0104cde:	c7 44 24 04 48 01 00 	movl   $0x148,0x4(%esp)
f0104ce5:	00 
f0104ce6:	c7 04 24 65 98 10 f0 	movl   $0xf0109865,(%esp)
f0104ced:	e8 4e b3 ff ff       	call   f0100040 <_panic>

	if ((tf->tf_cs & 3) == 3) {
f0104cf2:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0104cf6:	83 e0 03             	and    $0x3,%eax
f0104cf9:	66 83 f8 03          	cmp    $0x3,%ax
f0104cfd:	0f 85 a7 00 00 00    	jne    f0104daa <trap+0x121>
f0104d03:	c7 04 24 c0 63 12 f0 	movl   $0xf01263c0,(%esp)
f0104d0a:	e8 78 23 00 00       	call   f0107087 <spin_lock>
		// serious kernel work.
		// LAB 4: Your code here.

		lock_kernel();

		assert(curenv);
f0104d0f:	e8 f5 20 00 00       	call   f0106e09 <cpunum>
f0104d14:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d17:	83 b8 28 a0 2c f0 00 	cmpl   $0x0,-0xfd35fd8(%eax)
f0104d1e:	75 24                	jne    f0104d44 <trap+0xbb>
f0104d20:	c7 44 24 0c 8a 98 10 	movl   $0xf010988a,0xc(%esp)
f0104d27:	f0 
f0104d28:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0104d2f:	f0 
f0104d30:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
f0104d37:	00 
f0104d38:	c7 04 24 65 98 10 f0 	movl   $0xf0109865,(%esp)
f0104d3f:	e8 fc b2 ff ff       	call   f0100040 <_panic>

		// Garbage collect if current enviroment is a zombie
		if (curenv->env_status == ENV_DYING) {
f0104d44:	e8 c0 20 00 00       	call   f0106e09 <cpunum>
f0104d49:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d4c:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104d52:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0104d56:	75 2d                	jne    f0104d85 <trap+0xfc>
			env_free(curenv);
f0104d58:	e8 ac 20 00 00       	call   f0106e09 <cpunum>
f0104d5d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d60:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104d66:	89 04 24             	mov    %eax,(%esp)
f0104d69:	e8 f9 f0 ff ff       	call   f0103e67 <env_free>
			curenv = NULL;
f0104d6e:	e8 96 20 00 00       	call   f0106e09 <cpunum>
f0104d73:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d76:	c7 80 28 a0 2c f0 00 	movl   $0x0,-0xfd35fd8(%eax)
f0104d7d:	00 00 00 
			sched_yield();
f0104d80:	e8 41 03 00 00       	call   f01050c6 <sched_yield>
		}

		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		curenv->env_tf = *tf;
f0104d85:	e8 7f 20 00 00       	call   f0106e09 <cpunum>
f0104d8a:	6b c0 74             	imul   $0x74,%eax,%eax
f0104d8d:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104d93:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104d98:	89 c7                	mov    %eax,%edi
f0104d9a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f0104d9c:	e8 68 20 00 00       	call   f0106e09 <cpunum>
f0104da1:	6b c0 74             	imul   $0x74,%eax,%eax
f0104da4:	8b b0 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%esi
	}

	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
f0104daa:	89 35 60 9a 2c f0    	mov    %esi,0xf02c9a60
	int32_t ret_code;

	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0104db0:	8b 46 28             	mov    0x28(%esi),%eax
f0104db3:	83 f8 27             	cmp    $0x27,%eax
f0104db6:	75 19                	jne    f0104dd1 <trap+0x148>
		cprintf("Spurious interrupt on irq 7\n");
f0104db8:	c7 04 24 91 98 10 f0 	movl   $0xf0109891,(%esp)
f0104dbf:	e8 7e f5 ff ff       	call   f0104342 <cprintf>
		print_trapframe(tf);
f0104dc4:	89 34 24             	mov    %esi,(%esp)
f0104dc7:	e8 9c fb ff ff       	call   f0104968 <print_trapframe>
f0104dcc:	e9 37 01 00 00       	jmp    f0104f08 <trap+0x27f>
		return;
	}

	// Handle processor exceptions.
	// LAB 3: Your code here.
	switch(tf->tf_trapno) {
f0104dd1:	83 f8 20             	cmp    $0x20,%eax
f0104dd4:	0f 84 bf 00 00 00    	je     f0104e99 <trap+0x210>
f0104dda:	83 f8 20             	cmp    $0x20,%eax
f0104ddd:	8d 76 00             	lea    0x0(%esi),%esi
f0104de0:	77 16                	ja     f0104df8 <trap+0x16f>
f0104de2:	83 f8 03             	cmp    $0x3,%eax
f0104de5:	74 56                	je     f0104e3d <trap+0x1b4>
f0104de7:	83 f8 0e             	cmp    $0xe,%eax
f0104dea:	74 49                	je     f0104e35 <trap+0x1ac>
f0104dec:	83 f8 01             	cmp    $0x1,%eax
f0104def:	90                   	nop
f0104df0:	0f 85 d1 00 00 00    	jne    f0104ec7 <trap+0x23e>
f0104df6:	eb 5a                	jmp    f0104e52 <trap+0x1c9>
f0104df8:	83 f8 24             	cmp    $0x24,%eax
f0104dfb:	90                   	nop
f0104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0104e00:	0f 84 ac 00 00 00    	je     f0104eb2 <trap+0x229>
f0104e06:	83 f8 24             	cmp    $0x24,%eax
f0104e09:	77 10                	ja     f0104e1b <trap+0x192>
f0104e0b:	83 f8 21             	cmp    $0x21,%eax
f0104e0e:	66 90                	xchg   %ax,%ax
f0104e10:	0f 84 94 00 00 00    	je     f0104eaa <trap+0x221>
f0104e16:	e9 ac 00 00 00       	jmp    f0104ec7 <trap+0x23e>
f0104e1b:	83 f8 2b             	cmp    $0x2b,%eax
f0104e1e:	66 90                	xchg   %ax,%ax
f0104e20:	0f 84 93 00 00 00    	je     f0104eb9 <trap+0x230>
f0104e26:	83 f8 30             	cmp    $0x30,%eax
f0104e29:	74 3c                	je     f0104e67 <trap+0x1de>
f0104e2b:	90                   	nop
f0104e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0104e30:	e9 92 00 00 00       	jmp    f0104ec7 <trap+0x23e>
		case (T_PGFLT):
			page_fault_handler(tf);
f0104e35:	89 34 24             	mov    %esi,(%esp)
f0104e38:	e8 c8 fc ff ff       	call   f0104b05 <page_fault_handler>
			break;
		case (T_BRKPT):
			print_trapframe(tf);
f0104e3d:	89 34 24             	mov    %esi,(%esp)
f0104e40:	e8 23 fb ff ff       	call   f0104968 <print_trapframe>
			monitor(tf);
f0104e45:	89 34 24             	mov    %esi,(%esp)
f0104e48:	e8 92 bf ff ff       	call   f0100ddf <monitor>
f0104e4d:	e9 b6 00 00 00       	jmp    f0104f08 <trap+0x27f>
			break;
		case (T_DEBUG):
			print_trapframe(tf);
f0104e52:	89 34 24             	mov    %esi,(%esp)
f0104e55:	e8 0e fb ff ff       	call   f0104968 <print_trapframe>
			monitor(tf);
f0104e5a:	89 34 24             	mov    %esi,(%esp)
f0104e5d:	e8 7d bf ff ff       	call   f0100ddf <monitor>
f0104e62:	e9 a1 00 00 00       	jmp    f0104f08 <trap+0x27f>
			break;
		case (T_SYSCALL):
			ret_code = syscall(
f0104e67:	8b 46 04             	mov    0x4(%esi),%eax
f0104e6a:	89 44 24 14          	mov    %eax,0x14(%esp)
f0104e6e:	8b 06                	mov    (%esi),%eax
f0104e70:	89 44 24 10          	mov    %eax,0x10(%esp)
f0104e74:	8b 46 10             	mov    0x10(%esi),%eax
f0104e77:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104e7b:	8b 46 18             	mov    0x18(%esi),%eax
f0104e7e:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104e82:	8b 46 14             	mov    0x14(%esi),%eax
f0104e85:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104e89:	8b 46 1c             	mov    0x1c(%esi),%eax
f0104e8c:	89 04 24             	mov    %eax,(%esp)
f0104e8f:	e8 63 03 00 00       	call   f01051f7 <syscall>
				tf->tf_regs.reg_edx,
				tf->tf_regs.reg_ecx,
				tf->tf_regs.reg_ebx,
				tf->tf_regs.reg_edi,
				tf->tf_regs.reg_esi);
			tf->tf_regs.reg_eax = ret_code;
f0104e94:	89 46 1c             	mov    %eax,0x1c(%esi)
f0104e97:	eb 6f                	jmp    f0104f08 <trap+0x27f>
		// Add time tick increment to clock interrupts.
		// Be careful! In multiprocessors, clock interrupts are
		// triggered on every CPU.
		// LAB 6: Your code here.
		case (IRQ_OFFSET + IRQ_TIMER):
			lapic_eoi();
f0104e99:	e8 b8 20 00 00       	call   f0106f56 <lapic_eoi>
			time_tick();
f0104e9e:	66 90                	xchg   %ax,%ax
f0104ea0:	e8 84 2f 00 00       	call   f0107e29 <time_tick>
			sched_yield();
f0104ea5:	e8 1c 02 00 00       	call   f01050c6 <sched_yield>
			break;
        // Handle keyboard and serial interrupts.
	    // LAB 5: Your code here.
		case (IRQ_OFFSET + IRQ_KBD):
			kbd_intr();
f0104eaa:	e8 b4 b7 ff ff       	call   f0100663 <kbd_intr>
f0104eaf:	90                   	nop
f0104eb0:	eb 56                	jmp    f0104f08 <trap+0x27f>
			break;
		case (IRQ_OFFSET + IRQ_SERIAL):
			serial_intr();
f0104eb2:	e8 90 b7 ff ff       	call   f0100647 <serial_intr>
f0104eb7:	eb 4f                	jmp    f0104f08 <trap+0x27f>
			break;
		case (IRQ_OFFSET + IRQ_E1000):
			e1000_trap_handler();
f0104eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0104ec0:	e8 eb 24 00 00       	call   f01073b0 <e1000_trap_handler>
f0104ec5:	eb 41                	jmp    f0104f08 <trap+0x27f>
			break;
		default:
			// Unexpected trap: The user process or the kernel has a bug.
			print_trapframe(tf);
f0104ec7:	89 34 24             	mov    %esi,(%esp)
f0104eca:	e8 99 fa ff ff       	call   f0104968 <print_trapframe>
			if (tf->tf_cs == GD_KT)
f0104ecf:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104ed4:	75 1c                	jne    f0104ef2 <trap+0x269>
				panic("unhandled trap in kernel");
f0104ed6:	c7 44 24 08 ae 98 10 	movl   $0xf01098ae,0x8(%esp)
f0104edd:	f0 
f0104ede:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
f0104ee5:	00 
f0104ee6:	c7 04 24 65 98 10 f0 	movl   $0xf0109865,(%esp)
f0104eed:	e8 4e b1 ff ff       	call   f0100040 <_panic>
			else {
				env_destroy(curenv);
f0104ef2:	e8 12 1f 00 00       	call   f0106e09 <cpunum>
f0104ef7:	6b c0 74             	imul   $0x74,%eax,%eax
f0104efa:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104f00:	89 04 24             	mov    %eax,(%esp)
f0104f03:	e8 2a f1 ff ff       	call   f0104032 <env_destroy>
	trap_dispatch(tf);

	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNING)
f0104f08:	e8 fc 1e 00 00       	call   f0106e09 <cpunum>
f0104f0d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f10:	83 b8 28 a0 2c f0 00 	cmpl   $0x0,-0xfd35fd8(%eax)
f0104f17:	74 2a                	je     f0104f43 <trap+0x2ba>
f0104f19:	e8 eb 1e 00 00       	call   f0106e09 <cpunum>
f0104f1e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f21:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104f27:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0104f2b:	75 16                	jne    f0104f43 <trap+0x2ba>
		env_run(curenv);
f0104f2d:	e8 d7 1e 00 00       	call   f0106e09 <cpunum>
f0104f32:	6b c0 74             	imul   $0x74,%eax,%eax
f0104f35:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0104f3b:	89 04 24             	mov    %eax,(%esp)
f0104f3e:	e8 90 f1 ff ff       	call   f01040d3 <env_run>
	else
		sched_yield();
f0104f43:	e8 7e 01 00 00       	call   f01050c6 <sched_yield>

f0104f48 <t_divide>:

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */

TRAPHANDLER_NOEC(t_divide, T_DIVIDE)
f0104f48:	6a 00                	push   $0x0
f0104f4a:	6a 00                	push   $0x0
f0104f4c:	e9 8d 00 00 00       	jmp    f0104fde <_alltraps>
f0104f51:	90                   	nop

f0104f52 <t_debug>:
TRAPHANDLER_NOEC(t_debug, T_DEBUG)
f0104f52:	6a 00                	push   $0x0
f0104f54:	6a 01                	push   $0x1
f0104f56:	e9 83 00 00 00       	jmp    f0104fde <_alltraps>
f0104f5b:	90                   	nop

f0104f5c <t_nmi>:
TRAPHANDLER_NOEC(t_nmi, T_NMI)
f0104f5c:	6a 00                	push   $0x0
f0104f5e:	6a 02                	push   $0x2
f0104f60:	eb 7c                	jmp    f0104fde <_alltraps>

f0104f62 <t_brkpt>:
TRAPHANDLER_NOEC(t_brkpt, T_BRKPT)
f0104f62:	6a 00                	push   $0x0
f0104f64:	6a 03                	push   $0x3
f0104f66:	eb 76                	jmp    f0104fde <_alltraps>

f0104f68 <t_oflow>:
TRAPHANDLER_NOEC(t_oflow, T_OFLOW)
f0104f68:	6a 00                	push   $0x0
f0104f6a:	6a 04                	push   $0x4
f0104f6c:	eb 70                	jmp    f0104fde <_alltraps>

f0104f6e <t_bound>:
TRAPHANDLER_NOEC(t_bound, T_BOUND)
f0104f6e:	6a 00                	push   $0x0
f0104f70:	6a 05                	push   $0x5
f0104f72:	eb 6a                	jmp    f0104fde <_alltraps>

f0104f74 <t_illop>:
TRAPHANDLER_NOEC(t_illop, T_ILLOP)
f0104f74:	6a 00                	push   $0x0
f0104f76:	6a 06                	push   $0x6
f0104f78:	eb 64                	jmp    f0104fde <_alltraps>

f0104f7a <t_device>:
TRAPHANDLER_NOEC(t_device, T_DEVICE)
f0104f7a:	6a 00                	push   $0x0
f0104f7c:	6a 07                	push   $0x7
f0104f7e:	eb 5e                	jmp    f0104fde <_alltraps>

f0104f80 <t_dblflt>:

TRAPHANDLER(t_dblflt, T_DBLFLT)
f0104f80:	6a 08                	push   $0x8
f0104f82:	eb 5a                	jmp    f0104fde <_alltraps>

f0104f84 <t_tss>:

TRAPHANDLER(t_tss, T_TSS)
f0104f84:	6a 0a                	push   $0xa
f0104f86:	eb 56                	jmp    f0104fde <_alltraps>

f0104f88 <t_segnp>:
TRAPHANDLER(t_segnp, T_SEGNP)
f0104f88:	6a 0b                	push   $0xb
f0104f8a:	eb 52                	jmp    f0104fde <_alltraps>

f0104f8c <t_stack>:
TRAPHANDLER(t_stack, T_STACK)
f0104f8c:	6a 0c                	push   $0xc
f0104f8e:	eb 4e                	jmp    f0104fde <_alltraps>

f0104f90 <t_gpflt>:
TRAPHANDLER(t_gpflt, T_GPFLT)
f0104f90:	6a 0d                	push   $0xd
f0104f92:	eb 4a                	jmp    f0104fde <_alltraps>

f0104f94 <t_pgflt>:
TRAPHANDLER(t_pgflt, T_PGFLT)
f0104f94:	6a 0e                	push   $0xe
f0104f96:	eb 46                	jmp    f0104fde <_alltraps>

f0104f98 <t_fperr>:

TRAPHANDLER_NOEC(t_fperr, T_FPERR)
f0104f98:	6a 00                	push   $0x0
f0104f9a:	6a 10                	push   $0x10
f0104f9c:	eb 40                	jmp    f0104fde <_alltraps>

f0104f9e <t_align>:
TRAPHANDLER(t_align, T_ALIGN)
f0104f9e:	6a 11                	push   $0x11
f0104fa0:	eb 3c                	jmp    f0104fde <_alltraps>

f0104fa2 <t_mchk>:
TRAPHANDLER_NOEC(t_mchk, T_MCHK)
f0104fa2:	6a 00                	push   $0x0
f0104fa4:	6a 12                	push   $0x12
f0104fa6:	eb 36                	jmp    f0104fde <_alltraps>

f0104fa8 <t_simderr>:
TRAPHANDLER_NOEC(t_simderr, T_SIMDERR)
f0104fa8:	6a 00                	push   $0x0
f0104faa:	6a 13                	push   $0x13
f0104fac:	eb 30                	jmp    f0104fde <_alltraps>

f0104fae <t_syscall>:

TRAPHANDLER_NOEC(t_syscall, T_SYSCALL)
f0104fae:	6a 00                	push   $0x0
f0104fb0:	6a 30                	push   $0x30
f0104fb2:	eb 2a                	jmp    f0104fde <_alltraps>

f0104fb4 <irq_timer>:

TRAPHANDLER_NOEC(irq_timer, IRQ_OFFSET + IRQ_TIMER)
f0104fb4:	6a 00                	push   $0x0
f0104fb6:	6a 20                	push   $0x20
f0104fb8:	eb 24                	jmp    f0104fde <_alltraps>

f0104fba <irq_kbd>:
TRAPHANDLER_NOEC(irq_kbd, IRQ_OFFSET + IRQ_KBD)
f0104fba:	6a 00                	push   $0x0
f0104fbc:	6a 21                	push   $0x21
f0104fbe:	eb 1e                	jmp    f0104fde <_alltraps>

f0104fc0 <irq_serial>:
TRAPHANDLER_NOEC(irq_serial, IRQ_OFFSET + IRQ_SERIAL)
f0104fc0:	6a 00                	push   $0x0
f0104fc2:	6a 24                	push   $0x24
f0104fc4:	eb 18                	jmp    f0104fde <_alltraps>

f0104fc6 <irq_spurious>:
TRAPHANDLER_NOEC(irq_spurious, IRQ_OFFSET + IRQ_SPURIOUS)
f0104fc6:	6a 00                	push   $0x0
f0104fc8:	6a 27                	push   $0x27
f0104fca:	eb 12                	jmp    f0104fde <_alltraps>

f0104fcc <irq_e1000>:
TRAPHANDLER_NOEC(irq_e1000, IRQ_OFFSET + IRQ_E1000)
f0104fcc:	6a 00                	push   $0x0
f0104fce:	6a 2b                	push   $0x2b
f0104fd0:	eb 0c                	jmp    f0104fde <_alltraps>

f0104fd2 <irq_ide>:
TRAPHANDLER_NOEC(irq_ide, IRQ_OFFSET + IRQ_IDE)
f0104fd2:	6a 00                	push   $0x0
f0104fd4:	6a 2e                	push   $0x2e
f0104fd6:	eb 06                	jmp    f0104fde <_alltraps>

f0104fd8 <irq_error>:
TRAPHANDLER_NOEC(irq_error, IRQ_OFFSET + IRQ_ERROR)
f0104fd8:	6a 00                	push   $0x0
f0104fda:	6a 33                	push   $0x33
f0104fdc:	eb 00                	jmp    f0104fde <_alltraps>

f0104fde <_alltraps>:
 * Lab 3: Your code here for _alltraps
 */

_alltraps:
	# Setup remainder of trapframe
	pushl %ds
f0104fde:	1e                   	push   %ds
	pushl %es
f0104fdf:	06                   	push   %es
	pushal
f0104fe0:	60                   	pusha  

	movl $GD_KD, %eax
f0104fe1:	b8 10 00 00 00       	mov    $0x10,%eax
	movw %ax, %ds
f0104fe6:	8e d8                	mov    %eax,%ds
	movw %ax, %es
f0104fe8:	8e c0                	mov    %eax,%es

	pushl %esp
f0104fea:	54                   	push   %esp
	call trap
f0104feb:	e8 99 fc ff ff       	call   f0104c89 <trap>

f0104ff0 <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f0104ff0:	55                   	push   %ebp
f0104ff1:	89 e5                	mov    %esp,%ebp
f0104ff3:	83 ec 18             	sub    $0x18,%esp
f0104ff6:	8b 15 48 92 2c f0    	mov    0xf02c9248,%edx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f0104ffc:	b8 00 00 00 00       	mov    $0x0,%eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f0105001:	8b 4a 54             	mov    0x54(%edx),%ecx
f0105004:	83 e9 01             	sub    $0x1,%ecx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
		if ((envs[i].env_status == ENV_RUNNABLE ||
f0105007:	83 f9 02             	cmp    $0x2,%ecx
f010500a:	76 0f                	jbe    f010501b <sched_halt+0x2b>
{
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f010500c:	83 c0 01             	add    $0x1,%eax
f010500f:	83 ea 80             	sub    $0xffffff80,%edx
f0105012:	3d 00 04 00 00       	cmp    $0x400,%eax
f0105017:	75 e8                	jne    f0105001 <sched_halt+0x11>
f0105019:	eb 07                	jmp    f0105022 <sched_halt+0x32>
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
f010501b:	3d 00 04 00 00       	cmp    $0x400,%eax
f0105020:	75 1a                	jne    f010503c <sched_halt+0x4c>
		cprintf("No runnable environments in the system!\n");
f0105022:	c7 04 24 d0 9a 10 f0 	movl   $0xf0109ad0,(%esp)
f0105029:	e8 14 f3 ff ff       	call   f0104342 <cprintf>
		while (1)
			monitor(NULL);
f010502e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0105035:	e8 a5 bd ff ff       	call   f0100ddf <monitor>
f010503a:	eb f2                	jmp    f010502e <sched_halt+0x3e>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f010503c:	e8 c8 1d 00 00       	call   f0106e09 <cpunum>
f0105041:	6b c0 74             	imul   $0x74,%eax,%eax
f0105044:	c7 80 28 a0 2c f0 00 	movl   $0x0,-0xfd35fd8(%eax)
f010504b:	00 00 00 
	lcr3(PADDR(kern_pgdir));
f010504e:	a1 98 9e 2c f0       	mov    0xf02c9e98,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0105053:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0105058:	77 20                	ja     f010507a <sched_halt+0x8a>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010505a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010505e:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f0105065:	f0 
f0105066:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
f010506d:	00 
f010506e:	c7 04 24 f9 9a 10 f0 	movl   $0xf0109af9,(%esp)
f0105075:	e8 c6 af ff ff       	call   f0100040 <_panic>
	return (physaddr_t)kva - KERNBASE;
f010507a:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f010507f:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0105082:	e8 82 1d 00 00       	call   f0106e09 <cpunum>
f0105087:	6b d0 74             	imul   $0x74,%eax,%edx
f010508a:	81 c2 20 a0 2c f0    	add    $0xf02ca020,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0105090:	b8 02 00 00 00       	mov    $0x2,%eax
f0105095:	f0 87 42 04          	lock xchg %eax,0x4(%edx)
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0105099:	c7 04 24 c0 63 12 f0 	movl   $0xf01263c0,(%esp)
f01050a0:	e8 8e 20 00 00       	call   f0107133 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f01050a5:	f3 90                	pause  
		// Uncomment the following line after completing exercise 13
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f01050a7:	e8 5d 1d 00 00       	call   f0106e09 <cpunum>
f01050ac:	6b c0 74             	imul   $0x74,%eax,%eax

	// Release the big kernel lock as if we were "leaving" the kernel
	unlock_kernel();

	// Reset stack pointer, enable interrupts and then halt.
	asm volatile (
f01050af:	8b 80 30 a0 2c f0    	mov    -0xfd35fd0(%eax),%eax
f01050b5:	bd 00 00 00 00       	mov    $0x0,%ebp
f01050ba:	89 c4                	mov    %eax,%esp
f01050bc:	6a 00                	push   $0x0
f01050be:	6a 00                	push   $0x0
f01050c0:	fb                   	sti    
f01050c1:	f4                   	hlt    
f01050c2:	eb fd                	jmp    f01050c1 <sched_halt+0xd1>
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
}
f01050c4:	c9                   	leave  
f01050c5:	c3                   	ret    

f01050c6 <sched_yield>:
void sched_halt(void);

// Choose a user environment to run and run it.
void
sched_yield(void)
{
f01050c6:	55                   	push   %ebp
f01050c7:	89 e5                	mov    %esp,%ebp
f01050c9:	53                   	push   %ebx
f01050ca:	83 ec 14             	sub    $0x14,%esp
	// no runnable environments, simply drop through to the code
	// below to halt the cpu.

	// LAB 4: Your code here.
	int i;
	int current_env_idx = curenv ? ENVX(curenv->env_id) : 0;
f01050cd:	e8 37 1d 00 00       	call   f0106e09 <cpunum>
f01050d2:	6b d0 74             	imul   $0x74,%eax,%edx
f01050d5:	b8 00 00 00 00       	mov    $0x0,%eax
f01050da:	83 ba 28 a0 2c f0 00 	cmpl   $0x0,-0xfd35fd8(%edx)
f01050e1:	74 16                	je     f01050f9 <sched_yield+0x33>
f01050e3:	e8 21 1d 00 00       	call   f0106e09 <cpunum>
f01050e8:	6b c0 74             	imul   $0x74,%eax,%eax
f01050eb:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f01050f1:	8b 40 48             	mov    0x48(%eax),%eax
f01050f4:	25 ff 03 00 00       	and    $0x3ff,%eax
	int idx = (current_env_idx + 1) % NENV; // start by looking at the next process
f01050f9:	83 c0 01             	add    $0x1,%eax
f01050fc:	25 ff 03 00 00       	and    $0x3ff,%eax

	for (i = 0; i < NENV; i++) {
		if (envs[idx].env_status == ENV_RUNNABLE)
f0105101:	8b 1d 48 92 2c f0    	mov    0xf02c9248,%ebx
f0105107:	ba 00 04 00 00       	mov    $0x400,%edx
f010510c:	89 c1                	mov    %eax,%ecx
f010510e:	c1 e1 07             	shl    $0x7,%ecx
f0105111:	01 d9                	add    %ebx,%ecx
f0105113:	83 79 54 02          	cmpl   $0x2,0x54(%ecx)
f0105117:	75 08                	jne    f0105121 <sched_yield+0x5b>
			env_run(&envs[idx]);
f0105119:	89 0c 24             	mov    %ecx,(%esp)
f010511c:	e8 b2 ef ff ff       	call   f01040d3 <env_run>
		idx = (idx + 1) % NENV;
f0105121:	83 c0 01             	add    $0x1,%eax
f0105124:	89 c1                	mov    %eax,%ecx
f0105126:	c1 f9 1f             	sar    $0x1f,%ecx
f0105129:	c1 e9 16             	shr    $0x16,%ecx
f010512c:	01 c8                	add    %ecx,%eax
f010512e:	25 ff 03 00 00       	and    $0x3ff,%eax
f0105133:	29 c8                	sub    %ecx,%eax
	// LAB 4: Your code here.
	int i;
	int current_env_idx = curenv ? ENVX(curenv->env_id) : 0;
	int idx = (current_env_idx + 1) % NENV; // start by looking at the next process

	for (i = 0; i < NENV; i++) {
f0105135:	83 ea 01             	sub    $0x1,%edx
f0105138:	75 d2                	jne    f010510c <sched_yield+0x46>
		if (envs[idx].env_status == ENV_RUNNABLE)
			env_run(&envs[idx]);
		idx = (idx + 1) % NENV;
	}

	if (curenv != NULL && curenv->env_status == ENV_RUNNING)
f010513a:	e8 ca 1c 00 00       	call   f0106e09 <cpunum>
f010513f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105142:	83 b8 28 a0 2c f0 00 	cmpl   $0x0,-0xfd35fd8(%eax)
f0105149:	74 2a                	je     f0105175 <sched_yield+0xaf>
f010514b:	e8 b9 1c 00 00       	call   f0106e09 <cpunum>
f0105150:	6b c0 74             	imul   $0x74,%eax,%eax
f0105153:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105159:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010515d:	75 16                	jne    f0105175 <sched_yield+0xaf>
		env_run(curenv);
f010515f:	e8 a5 1c 00 00       	call   f0106e09 <cpunum>
f0105164:	6b c0 74             	imul   $0x74,%eax,%eax
f0105167:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f010516d:	89 04 24             	mov    %eax,(%esp)
f0105170:	e8 5e ef ff ff       	call   f01040d3 <env_run>
f0105175:	a1 48 92 2c f0       	mov    0xf02c9248,%eax
                
    for (i = 0; i < NENV; i++) {
		if (envs[i].env_e1000_waiting_rx) {
f010517a:	ba 00 04 00 00       	mov    $0x400,%edx
f010517f:	80 78 7c 00          	cmpb   $0x0,0x7c(%eax)
f0105183:	74 0c                	je     f0105191 <sched_yield+0xcb>
			envs[i].env_e1000_waiting_rx = false;
f0105185:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
			env_run(&envs[i]);
f0105189:	89 04 24             	mov    %eax,(%esp)
f010518c:	e8 42 ef ff ff       	call   f01040d3 <env_run>
f0105191:	83 e8 80             	sub    $0xffffff80,%eax
	}

	if (curenv != NULL && curenv->env_status == ENV_RUNNING)
		env_run(curenv);
                
    for (i = 0; i < NENV; i++) {
f0105194:	83 ea 01             	sub    $0x1,%edx
f0105197:	75 e6                	jne    f010517f <sched_yield+0xb9>
			env_run(&envs[i]);
		}
	}

	// sched_halt never returns
	sched_halt();
f0105199:	e8 52 fe ff ff       	call   f0104ff0 <sched_halt>
}
f010519e:	83 c4 14             	add    $0x14,%esp
f01051a1:	5b                   	pop    %ebx
f01051a2:	5d                   	pop    %ebp
f01051a3:	c3                   	ret    
f01051a4:	66 90                	xchg   %ax,%ax
f01051a6:	66 90                	xchg   %ax,%ax
f01051a8:	66 90                	xchg   %ax,%ax
f01051aa:	66 90                	xchg   %ax,%ax
f01051ac:	66 90                	xchg   %ax,%ax
f01051ae:	66 90                	xchg   %ax,%ax

f01051b0 <sys_e1000_get_mac>:
	return 0;
}

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
f01051b0:	55                   	push   %ebp
f01051b1:	89 e5                	mov    %esp,%ebp
f01051b3:	53                   	push   %ebx
f01051b4:	83 ec 14             	sub    $0x14,%esp
f01051b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// Make sure user controls address
	user_mem_assert(curenv, mac_addr, 12, PTE_W);
f01051ba:	e8 4a 1c 00 00       	call   f0106e09 <cpunum>
f01051bf:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01051c6:	00 
f01051c7:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
f01051ce:	00 
f01051cf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01051d3:	6b c0 74             	imul   $0x74,%eax,%eax
f01051d6:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f01051dc:	89 04 24             	mov    %eax,(%esp)
f01051df:	e8 a4 e7 ff ff       	call   f0103988 <user_mem_assert>
	e1000_get_mac(mac_addr);
f01051e4:	89 1c 24             	mov    %ebx,(%esp)
f01051e7:	e8 b4 25 00 00       	call   f01077a0 <e1000_get_mac>
	return 0;
}
f01051ec:	b8 00 00 00 00       	mov    $0x0,%eax
f01051f1:	83 c4 14             	add    $0x14,%esp
f01051f4:	5b                   	pop    %ebx
f01051f5:	5d                   	pop    %ebp
f01051f6:	c3                   	ret    

f01051f7 <syscall>:

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f01051f7:	55                   	push   %ebp
f01051f8:	89 e5                	mov    %esp,%ebp
f01051fa:	57                   	push   %edi
f01051fb:	56                   	push   %esi
f01051fc:	53                   	push   %ebx
f01051fd:	83 ec 4c             	sub    $0x4c,%esp
f0105200:	8b 45 08             	mov    0x8(%ebp),%eax
	// Return any appropriate return value.
	// LAB 3: Your code here.

	//panic("syscall not implemented");

	switch (syscallno) {
f0105203:	83 f8 12             	cmp    $0x12,%eax
f0105206:	0f 87 87 09 00 00    	ja     f0105b93 <syscall+0x99c>
f010520c:	ff 24 85 1c 9b 10 f0 	jmp    *-0xfef64e4(,%eax,4)
{
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.

	// LAB 3: Your code here.
	user_mem_assert(curenv, s, len, 0);
f0105213:	e8 f1 1b 00 00       	call   f0106e09 <cpunum>
f0105218:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f010521f:	00 
f0105220:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105223:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105227:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f010522a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f010522e:	6b c0 74             	imul   $0x74,%eax,%eax
f0105231:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105237:	89 04 24             	mov    %eax,(%esp)
f010523a:	e8 49 e7 ff ff       	call   f0103988 <user_mem_assert>
	
	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
f010523f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105242:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105246:	8b 45 10             	mov    0x10(%ebp),%eax
f0105249:	89 44 24 04          	mov    %eax,0x4(%esp)
f010524d:	c7 04 24 06 9b 10 f0 	movl   $0xf0109b06,(%esp)
f0105254:	e8 e9 f0 ff ff       	call   f0104342 <cprintf>
	//panic("syscall not implemented");

	switch (syscallno) {
		case (SYS_cputs):
			sys_cputs((const char *) a1, a2);
			return 0;
f0105259:	b8 00 00 00 00       	mov    $0x0,%eax
f010525e:	e9 ca 09 00 00       	jmp    f0105c2d <syscall+0xa36>
// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
f0105263:	e8 0d b4 ff ff       	call   f0100675 <cons_getc>
	switch (syscallno) {
		case (SYS_cputs):
			sys_cputs((const char *) a1, a2);
			return 0;
		case (SYS_cgetc):
			return sys_cgetc();
f0105268:	e9 c0 09 00 00       	jmp    f0105c2d <syscall+0xa36>

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
f010526d:	8d 76 00             	lea    0x0(%esi),%esi
f0105270:	e8 94 1b 00 00       	call   f0106e09 <cpunum>
f0105275:	6b c0 74             	imul   $0x74,%eax,%eax
f0105278:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f010527e:	8b 40 48             	mov    0x48(%eax),%eax
			sys_cputs((const char *) a1, a2);
			return 0;
		case (SYS_cgetc):
			return sys_cgetc();
		case (SYS_getenvid):
			return sys_getenvid();
f0105281:	e9 a7 09 00 00       	jmp    f0105c2d <syscall+0xa36>
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f0105286:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010528d:	00 
f010528e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105291:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105295:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105298:	89 04 24             	mov    %eax,(%esp)
f010529b:	e8 dd e7 ff ff       	call   f0103a7d <envid2env>
		return r;
f01052a0:	89 c2                	mov    %eax,%edx
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f01052a2:	85 c0                	test   %eax,%eax
f01052a4:	78 10                	js     f01052b6 <syscall+0xbf>
		return r;
	env_destroy(e);
f01052a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01052a9:	89 04 24             	mov    %eax,(%esp)
f01052ac:	e8 81 ed ff ff       	call   f0104032 <env_destroy>
	return 0;
f01052b1:	ba 00 00 00 00       	mov    $0x0,%edx
		case (SYS_cgetc):
			return sys_cgetc();
		case (SYS_getenvid):
			return sys_getenvid();
		case (SYS_env_destroy):
			return sys_env_destroy((envid_t)a1);
f01052b6:	89 d0                	mov    %edx,%eax
f01052b8:	e9 70 09 00 00       	jmp    f0105c2d <syscall+0xa36>

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
f01052bd:	e8 04 fe ff ff       	call   f01050c6 <sched_yield>

	// LAB 4: Your code here.
	struct Env *new_env;
        int return_code;

        return_code = env_alloc(&new_env, curenv->env_id);
f01052c2:	e8 42 1b 00 00       	call   f0106e09 <cpunum>
f01052c7:	6b c0 74             	imul   $0x74,%eax,%eax
f01052ca:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f01052d0:	8b 40 48             	mov    0x48(%eax),%eax
f01052d3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01052d7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01052da:	89 04 24             	mov    %eax,(%esp)
f01052dd:	e8 ab e8 ff ff       	call   f0103b8d <env_alloc>
        if (return_code < 0) {
f01052e2:	85 c0                	test   %eax,%eax
f01052e4:	79 1a                	jns    f0105300 <syscall+0x109>
                cprintf("sys_exofork: %e\n", return_code);
f01052e6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01052ea:	c7 04 24 0b 9b 10 f0 	movl   $0xf0109b0b,(%esp)
f01052f1:	e8 4c f0 ff ff       	call   f0104342 <cprintf>
                return -E_NO_FREE_ENV;
f01052f6:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f01052fb:	e9 2d 09 00 00       	jmp    f0105c2d <syscall+0xa36>
        }

        new_env->env_status = ENV_NOT_RUNNABLE;
f0105300:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105303:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)

        memmove((void *) &new_env->env_tf, (void *) &curenv->env_tf, sizeof(struct Trapframe));
f010530a:	e8 fa 1a 00 00       	call   f0106e09 <cpunum>
f010530f:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f0105316:	00 
f0105317:	6b c0 74             	imul   $0x74,%eax,%eax
f010531a:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105320:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105324:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105327:	89 04 24             	mov    %eax,(%esp)
f010532a:	e8 d5 14 00 00       	call   f0106804 <memmove>
        new_env->env_tf.tf_regs.reg_eax = 0;
f010532f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105332:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

        return new_env->env_id;
f0105339:	8b 40 48             	mov    0x48(%eax),%eax
			return sys_env_destroy((envid_t)a1);
		case (SYS_yield):
			sys_yield();
			return 0;
		case (SYS_exofork):
                        return sys_exofork();
f010533c:	e9 ec 08 00 00       	jmp    f0105c2d <syscall+0xa36>
	// check whether the current environment has permission to set
	// envid's status.

	// LAB 4: Your code here.
	struct Env *env;
        if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE)
f0105341:	83 7d 10 04          	cmpl   $0x4,0x10(%ebp)
f0105345:	74 06                	je     f010534d <syscall+0x156>
f0105347:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
f010534b:	75 31                	jne    f010537e <syscall+0x187>
                return -E_INVAL;
        else if (envid2env(envid, &env, 1) < 0)
f010534d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105354:	00 
f0105355:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105358:	89 44 24 04          	mov    %eax,0x4(%esp)
f010535c:	8b 45 0c             	mov    0xc(%ebp),%eax
f010535f:	89 04 24             	mov    %eax,(%esp)
f0105362:	e8 16 e7 ff ff       	call   f0103a7d <envid2env>
f0105367:	85 c0                	test   %eax,%eax
f0105369:	78 1d                	js     f0105388 <syscall+0x191>
                return -E_BAD_ENV;

        env->env_status = status;
f010536b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010536e:	8b 55 10             	mov    0x10(%ebp),%edx
f0105371:	89 50 54             	mov    %edx,0x54(%eax)
        return 0;
f0105374:	b8 00 00 00 00       	mov    $0x0,%eax
f0105379:	e9 af 08 00 00       	jmp    f0105c2d <syscall+0xa36>
	// envid's status.

	// LAB 4: Your code here.
	struct Env *env;
        if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE)
                return -E_INVAL;
f010537e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105383:	e9 a5 08 00 00       	jmp    f0105c2d <syscall+0xa36>
        else if (envid2env(envid, &env, 1) < 0)
                return -E_BAD_ENV;
f0105388:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
			sys_yield();
			return 0;
		case (SYS_exofork):
                        return sys_exofork();
                case (SYS_env_set_status):
                        return sys_env_set_status(a1, a2);
f010538d:	e9 9b 08 00 00       	jmp    f0105c2d <syscall+0xa36>
f0105392:	8b 45 14             	mov    0x14(%ebp),%eax
f0105395:	83 e0 05             	and    $0x5,%eax
	// LAB 4: Your code here.
	struct Env *env;

        if ((perm & PTE_U) != PTE_U)
                return -E_INVAL;
        if ((perm & PTE_P) != PTE_P)
f0105398:	83 f8 05             	cmp    $0x5,%eax
f010539b:	0f 85 f1 00 00 00    	jne    f0105492 <syscall+0x29b>
                return -E_INVAL;
        if ((perm & ~PTE_SYSCALL) != 0)
f01053a1:	f7 45 14 f8 f1 ff ff 	testl  $0xfffff1f8,0x14(%ebp)
f01053a8:	0f 85 eb 00 00 00    	jne    f0105499 <syscall+0x2a2>
                return -E_INVAL;

        if ((uint32_t) va >= UTOP || (uint32_t) va % PGSIZE != 0)
f01053ae:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f01053b5:	0f 87 e5 00 00 00    	ja     f01054a0 <syscall+0x2a9>
f01053bb:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f01053c2:	0f 85 df 00 00 00    	jne    f01054a7 <syscall+0x2b0>
                return -E_INVAL;

        if (envid2env(envid, &env, 1) != 0)
f01053c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01053cf:	00 
f01053d0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01053d3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01053d7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01053da:	89 04 24             	mov    %eax,(%esp)
f01053dd:	e8 9b e6 ff ff       	call   f0103a7d <envid2env>
f01053e2:	85 c0                	test   %eax,%eax
f01053e4:	0f 85 c4 00 00 00    	jne    f01054ae <syscall+0x2b7>
                return -E_BAD_ENV;

        struct PageInfo *new_page = page_alloc(ALLOC_ZERO);
f01053ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f01053f1:	e8 62 c0 ff ff       	call   f0101458 <page_alloc>
f01053f6:	89 c3                	mov    %eax,%ebx
        if (new_page == NULL)
f01053f8:	85 c0                	test   %eax,%eax
f01053fa:	0f 84 b5 00 00 00    	je     f01054b5 <syscall+0x2be>
                return -E_NO_MEM;

        if (page_insert(env->env_pgdir, new_page, va, perm) != 0) {
f0105400:	8b 45 14             	mov    0x14(%ebp),%eax
f0105403:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105407:	8b 45 10             	mov    0x10(%ebp),%eax
f010540a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010540e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105412:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105415:	8b 40 60             	mov    0x60(%eax),%eax
f0105418:	89 04 24             	mov    %eax,(%esp)
f010541b:	e8 82 c3 ff ff       	call   f01017a2 <page_insert>
f0105420:	89 c6                	mov    %eax,%esi
f0105422:	85 c0                	test   %eax,%eax
f0105424:	74 12                	je     f0105438 <syscall+0x241>
                page_free(new_page);
f0105426:	89 1c 24             	mov    %ebx,(%esp)
f0105429:	e8 e4 c0 ff ff       	call   f0101512 <page_free>
                return -E_NO_MEM;
f010542e:	be fc ff ff ff       	mov    $0xfffffffc,%esi
f0105433:	e9 82 00 00 00       	jmp    f01054ba <syscall+0x2c3>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0105438:	2b 1d 9c 9e 2c f0    	sub    0xf02c9e9c,%ebx
f010543e:	c1 fb 03             	sar    $0x3,%ebx
f0105441:	89 d8                	mov    %ebx,%eax
f0105443:	c1 e0 0c             	shl    $0xc,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0105446:	89 c2                	mov    %eax,%edx
f0105448:	c1 ea 0c             	shr    $0xc,%edx
f010544b:	3b 15 94 9e 2c f0    	cmp    0xf02c9e94,%edx
f0105451:	72 20                	jb     f0105473 <syscall+0x27c>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0105453:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105457:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f010545e:	f0 
f010545f:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
f0105466:	00 
f0105467:	c7 04 24 b1 92 10 f0 	movl   $0xf01092b1,(%esp)
f010546e:	e8 cd ab ff ff       	call   f0100040 <_panic>
        }
	memset(page2kva(new_page), 0, PGSIZE);
f0105473:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f010547a:	00 
f010547b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0105482:	00 
	return (void *)(pa + KERNBASE);
f0105483:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0105488:	89 04 24             	mov    %eax,(%esp)
f010548b:	e8 27 13 00 00       	call   f01067b7 <memset>
f0105490:	eb 28                	jmp    f01054ba <syscall+0x2c3>
	struct Env *env;

        if ((perm & PTE_U) != PTE_U)
                return -E_INVAL;
        if ((perm & PTE_P) != PTE_P)
                return -E_INVAL;
f0105492:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f0105497:	eb 21                	jmp    f01054ba <syscall+0x2c3>
        if ((perm & ~PTE_SYSCALL) != 0)
                return -E_INVAL;
f0105499:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f010549e:	eb 1a                	jmp    f01054ba <syscall+0x2c3>

        if ((uint32_t) va >= UTOP || (uint32_t) va % PGSIZE != 0)
                return -E_INVAL;
f01054a0:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f01054a5:	eb 13                	jmp    f01054ba <syscall+0x2c3>
f01054a7:	be fd ff ff ff       	mov    $0xfffffffd,%esi
f01054ac:	eb 0c                	jmp    f01054ba <syscall+0x2c3>

        if (envid2env(envid, &env, 1) != 0)
                return -E_BAD_ENV;
f01054ae:	be fe ff ff ff       	mov    $0xfffffffe,%esi
f01054b3:	eb 05                	jmp    f01054ba <syscall+0x2c3>

        struct PageInfo *new_page = page_alloc(ALLOC_ZERO);
        if (new_page == NULL)
                return -E_NO_MEM;
f01054b5:	be fc ff ff ff       	mov    $0xfffffffc,%esi
		case (SYS_exofork):
                        return sys_exofork();
                case (SYS_env_set_status):
                        return sys_env_set_status(a1, a2);
                case (SYS_page_alloc):
                        return sys_page_alloc(a1, (void *) a2, a3);
f01054ba:	89 f0                	mov    %esi,%eax
f01054bc:	e9 6c 07 00 00       	jmp    f0105c2d <syscall+0xa36>
	//   check the current permissions on the page.

	// LAB 4: Your code here.
	struct Env *src_env, *dst_env;

        if (envid2env(srcenvid, &src_env, 1) != 0 ||
f01054c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01054c8:	00 
f01054c9:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01054cc:	89 44 24 04          	mov    %eax,0x4(%esp)
f01054d0:	8b 45 0c             	mov    0xc(%ebp),%eax
f01054d3:	89 04 24             	mov    %eax,(%esp)
f01054d6:	e8 a2 e5 ff ff       	call   f0103a7d <envid2env>
f01054db:	85 c0                	test   %eax,%eax
f01054dd:	0f 85 d7 00 00 00    	jne    f01055ba <syscall+0x3c3>
                envid2env(dstenvid, &dst_env, 1) != 0)
f01054e3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f01054ea:	00 
f01054eb:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01054ee:	89 44 24 04          	mov    %eax,0x4(%esp)
f01054f2:	8b 45 14             	mov    0x14(%ebp),%eax
f01054f5:	89 04 24             	mov    %eax,(%esp)
f01054f8:	e8 80 e5 ff ff       	call   f0103a7d <envid2env>
	//   check the current permissions on the page.

	// LAB 4: Your code here.
	struct Env *src_env, *dst_env;

        if (envid2env(srcenvid, &src_env, 1) != 0 ||
f01054fd:	85 c0                	test   %eax,%eax
f01054ff:	0f 85 bf 00 00 00    	jne    f01055c4 <syscall+0x3cd>
                envid2env(dstenvid, &dst_env, 1) != 0)
                return -E_BAD_ENV;

        if ((uint32_t) srcva >= UTOP || (uint32_t) srcva % PGSIZE != 0 ||
f0105505:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f010550c:	0f 87 bc 00 00 00    	ja     f01055ce <syscall+0x3d7>
f0105512:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0105519:	0f 85 b9 00 00 00    	jne    f01055d8 <syscall+0x3e1>
f010551f:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0105526:	0f 87 b6 00 00 00    	ja     f01055e2 <syscall+0x3eb>
                (uint32_t) dstva >= UTOP || (uint32_t) dstva % PGSIZE != 0)
f010552c:	f7 45 18 ff 0f 00 00 	testl  $0xfff,0x18(%ebp)
f0105533:	0f 85 b3 00 00 00    	jne    f01055ec <syscall+0x3f5>
f0105539:	8b 45 1c             	mov    0x1c(%ebp),%eax
f010553c:	83 e0 05             	and    $0x5,%eax
                return -E_INVAL;

        if ((perm & PTE_U) != PTE_U)
                return -E_INVAL;
        if ((perm & PTE_P) != PTE_P)
f010553f:	83 f8 05             	cmp    $0x5,%eax
f0105542:	0f 85 ae 00 00 00    	jne    f01055f6 <syscall+0x3ff>
                return -E_INVAL;
        if ((perm & ~PTE_SYSCALL) != 0)
f0105548:	f7 45 1c f8 f1 ff ff 	testl  $0xfffff1f8,0x1c(%ebp)
f010554f:	0f 85 ab 00 00 00    	jne    f0105600 <syscall+0x409>
                return -E_INVAL;

        pte_t *pte_src;
        struct PageInfo *pp = page_lookup(src_env->env_pgdir, srcva, &pte_src);
f0105555:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105558:	89 44 24 08          	mov    %eax,0x8(%esp)
f010555c:	8b 45 10             	mov    0x10(%ebp),%eax
f010555f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105563:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105566:	8b 40 60             	mov    0x60(%eax),%eax
f0105569:	89 04 24             	mov    %eax,(%esp)
f010556c:	e8 3a c1 ff ff       	call   f01016ab <page_lookup>
        if (pp == NULL)
f0105571:	85 c0                	test   %eax,%eax
f0105573:	0f 84 91 00 00 00    	je     f010560a <syscall+0x413>
                return -E_INVAL;
	if (((perm & PTE_W) == PTE_W) && ((*pte_src & PTE_W) == 0))
f0105579:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f010557d:	74 0c                	je     f010558b <syscall+0x394>
f010557f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105582:	f6 02 02             	testb  $0x2,(%edx)
f0105585:	0f 84 89 00 00 00    	je     f0105614 <syscall+0x41d>
                return -E_INVAL;
        if (page_insert(dst_env->env_pgdir, pp, dstva, perm) != 0)
f010558b:	8b 75 1c             	mov    0x1c(%ebp),%esi
f010558e:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0105592:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0105595:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105599:	89 44 24 04          	mov    %eax,0x4(%esp)
f010559d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01055a0:	8b 40 60             	mov    0x60(%eax),%eax
f01055a3:	89 04 24             	mov    %eax,(%esp)
f01055a6:	e8 f7 c1 ff ff       	call   f01017a2 <page_insert>
                return -E_NO_MEM;
f01055ab:	85 c0                	test   %eax,%eax
f01055ad:	ba fc ff ff ff       	mov    $0xfffffffc,%edx
f01055b2:	0f 45 c2             	cmovne %edx,%eax
f01055b5:	e9 73 06 00 00       	jmp    f0105c2d <syscall+0xa36>
	// LAB 4: Your code here.
	struct Env *src_env, *dst_env;

        if (envid2env(srcenvid, &src_env, 1) != 0 ||
                envid2env(dstenvid, &dst_env, 1) != 0)
                return -E_BAD_ENV;
f01055ba:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01055bf:	e9 69 06 00 00       	jmp    f0105c2d <syscall+0xa36>
f01055c4:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01055c9:	e9 5f 06 00 00       	jmp    f0105c2d <syscall+0xa36>

        if ((uint32_t) srcva >= UTOP || (uint32_t) srcva % PGSIZE != 0 ||
                (uint32_t) dstva >= UTOP || (uint32_t) dstva % PGSIZE != 0)
                return -E_INVAL;
f01055ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01055d3:	e9 55 06 00 00       	jmp    f0105c2d <syscall+0xa36>
f01055d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01055dd:	e9 4b 06 00 00       	jmp    f0105c2d <syscall+0xa36>
f01055e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01055e7:	e9 41 06 00 00       	jmp    f0105c2d <syscall+0xa36>
f01055ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01055f1:	e9 37 06 00 00       	jmp    f0105c2d <syscall+0xa36>

        if ((perm & PTE_U) != PTE_U)
                return -E_INVAL;
        if ((perm & PTE_P) != PTE_P)
                return -E_INVAL;
f01055f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01055fb:	e9 2d 06 00 00       	jmp    f0105c2d <syscall+0xa36>
        if ((perm & ~PTE_SYSCALL) != 0)
                return -E_INVAL;
f0105600:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105605:	e9 23 06 00 00       	jmp    f0105c2d <syscall+0xa36>

        pte_t *pte_src;
        struct PageInfo *pp = page_lookup(src_env->env_pgdir, srcva, &pte_src);
        if (pp == NULL)
                return -E_INVAL;
f010560a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010560f:	e9 19 06 00 00       	jmp    f0105c2d <syscall+0xa36>
	if (((perm & PTE_W) == PTE_W) && ((*pte_src & PTE_W) == 0))
                return -E_INVAL;
f0105614:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
                case (SYS_env_set_status):
                        return sys_env_set_status(a1, a2);
                case (SYS_page_alloc):
                        return sys_page_alloc(a1, (void *) a2, a3);
                case (SYS_page_map):
                        return sys_page_map(a1, (void *) a2, a3, (void *) a4, a5);
f0105619:	e9 0f 06 00 00       	jmp    f0105c2d <syscall+0xa36>
{
	// Hint: This function is a wrapper around page_remove().

	// LAB 4: Your code here.
	struct Env *env;
	if (envid2env(envid, &env, 1) != 0)
f010561e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105625:	00 
f0105626:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105629:	89 44 24 04          	mov    %eax,0x4(%esp)
f010562d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105630:	89 04 24             	mov    %eax,(%esp)
f0105633:	e8 45 e4 ff ff       	call   f0103a7d <envid2env>
f0105638:	89 c3                	mov    %eax,%ebx
f010563a:	85 c0                	test   %eax,%eax
f010563c:	75 29                	jne    f0105667 <syscall+0x470>
                return -E_BAD_ENV;

        if ((uint32_t) va >= UTOP || (uint32_t) va % PGSIZE != 0)
f010563e:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0105645:	77 27                	ja     f010566e <syscall+0x477>
f0105647:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f010564e:	75 25                	jne    f0105675 <syscall+0x47e>
                return -E_INVAL;

        page_remove(env->env_pgdir, va);
f0105650:	8b 45 10             	mov    0x10(%ebp),%eax
f0105653:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105657:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010565a:	8b 40 60             	mov    0x60(%eax),%eax
f010565d:	89 04 24             	mov    %eax,(%esp)
f0105660:	e8 f4 c0 ff ff       	call   f0101759 <page_remove>
f0105665:	eb 13                	jmp    f010567a <syscall+0x483>
	// Hint: This function is a wrapper around page_remove().

	// LAB 4: Your code here.
	struct Env *env;
	if (envid2env(envid, &env, 1) != 0)
                return -E_BAD_ENV;
f0105667:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
f010566c:	eb 0c                	jmp    f010567a <syscall+0x483>

        if ((uint32_t) va >= UTOP || (uint32_t) va % PGSIZE != 0)
                return -E_INVAL;
f010566e:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
f0105673:	eb 05                	jmp    f010567a <syscall+0x483>
f0105675:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
                case (SYS_page_alloc):
                        return sys_page_alloc(a1, (void *) a2, a3);
                case (SYS_page_map):
                        return sys_page_map(a1, (void *) a2, a3, (void *) a4, a5);
                case (SYS_page_unmap):
                        return sys_page_unmap(a1, (void *) a2);
f010567a:	89 d8                	mov    %ebx,%eax
f010567c:	e9 ac 05 00 00       	jmp    f0105c2d <syscall+0xa36>
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	// LAB 4: Your code here.
	struct Env *env;

        if (envid2env(envid, &env, 1) != 0)
f0105681:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0105688:	00 
f0105689:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010568c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105690:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105693:	89 04 24             	mov    %eax,(%esp)
f0105696:	e8 e2 e3 ff ff       	call   f0103a7d <envid2env>
f010569b:	85 c0                	test   %eax,%eax
f010569d:	75 0e                	jne    f01056ad <syscall+0x4b6>
                return -E_BAD_ENV;

        env->env_pgfault_upcall = func;
f010569f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01056a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01056a5:	89 4a 64             	mov    %ecx,0x64(%edx)
f01056a8:	e9 80 05 00 00       	jmp    f0105c2d <syscall+0xa36>
{
	// LAB 4: Your code here.
	struct Env *env;

        if (envid2env(envid, &env, 1) != 0)
                return -E_BAD_ENV;
f01056ad:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
                case (SYS_page_map):
                        return sys_page_map(a1, (void *) a2, a3, (void *) a4, a5);
                case (SYS_page_unmap):
                        return sys_page_unmap(a1, (void *) a2);
                case (SYS_env_set_pgfault_upcall):
                        return sys_env_set_pgfault_upcall(a1, (void *) a2);
f01056b2:	e9 76 05 00 00       	jmp    f0105c2d <syscall+0xa36>
	// LAB 4: Your code here.
	struct Env *e;
	struct PageInfo *page;
	pte_t *pte;

	if (envid2env(envid, &e, 0) < 0)
f01056b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f01056be:	00 
f01056bf:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01056c2:	89 44 24 04          	mov    %eax,0x4(%esp)
f01056c6:	8b 45 0c             	mov    0xc(%ebp),%eax
f01056c9:	89 04 24             	mov    %eax,(%esp)
f01056cc:	e8 ac e3 ff ff       	call   f0103a7d <envid2env>
f01056d1:	85 c0                	test   %eax,%eax
f01056d3:	0f 88 d2 00 00 00    	js     f01057ab <syscall+0x5b4>
	{
		return -E_BAD_ENV;
	}

	if (e->env_ipc_recving == 0)
f01056d9:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f01056dc:	80 7b 68 00          	cmpb   $0x0,0x68(%ebx)
f01056e0:	0f 84 cf 00 00 00    	je     f01057b5 <syscall+0x5be>
	{
		return -E_IPC_NOT_RECV;
	}

	if ((uint32_t) srcva < UTOP)
f01056e6:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f01056ed:	0f 87 0d 05 00 00    	ja     f0105c00 <syscall+0xa09>
	{
		if ((uint32_t) srcva % PGSIZE != 0) {
f01056f3:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f01056fa:	0f 85 bf 00 00 00    	jne    f01057bf <syscall+0x5c8>
			return -E_INVAL;
		}
		if (!((perm & PTE_U) && (perm & PTE_P))) {
f0105700:	8b 45 18             	mov    0x18(%ebp),%eax
f0105703:	83 e0 05             	and    $0x5,%eax
f0105706:	83 f8 05             	cmp    $0x5,%eax
f0105709:	0f 85 ba 00 00 00    	jne    f01057c9 <syscall+0x5d2>
			return -E_INVAL;
		}
		if (perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) {
f010570f:	f7 45 18 f8 f1 ff ff 	testl  $0xfffff1f8,0x18(%ebp)
f0105716:	0f 85 b7 00 00 00    	jne    f01057d3 <syscall+0x5dc>
			return -E_INVAL;
		}
		if (!(page = page_lookup(curenv->env_pgdir, srcva, &pte))) {
f010571c:	e8 e8 16 00 00       	call   f0106e09 <cpunum>
f0105721:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105724:	89 54 24 08          	mov    %edx,0x8(%esp)
f0105728:	8b 75 14             	mov    0x14(%ebp),%esi
f010572b:	89 74 24 04          	mov    %esi,0x4(%esp)
f010572f:	6b c0 74             	imul   $0x74,%eax,%eax
f0105732:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105738:	8b 40 60             	mov    0x60(%eax),%eax
f010573b:	89 04 24             	mov    %eax,(%esp)
f010573e:	e8 68 bf ff ff       	call   f01016ab <page_lookup>
f0105743:	85 c0                	test   %eax,%eax
f0105745:	0f 84 92 00 00 00    	je     f01057dd <syscall+0x5e6>
			return -E_INVAL;
		}
		if ((perm & PTE_W) && ((*pte & PTE_W) == 0))
f010574b:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f010574f:	74 0c                	je     f010575d <syscall+0x566>
f0105751:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105754:	f6 02 02             	testb  $0x2,(%edx)
f0105757:	0f 84 8a 00 00 00    	je     f01057e7 <syscall+0x5f0>
		{
			return -E_INVAL;
		}
		if ((uint32_t)e->env_ipc_dstva < UTOP)
f010575d:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105760:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f0105763:	81 f9 ff ff bf ee    	cmp    $0xeebfffff,%ecx
f0105769:	0f 87 62 04 00 00    	ja     f0105bd1 <syscall+0x9da>
		{
			if (page_insert(e->env_pgdir, page, e->env_ipc_dstva, perm) < 0)
f010576f:	8b 75 18             	mov    0x18(%ebp),%esi
f0105772:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0105776:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010577a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010577e:	8b 42 60             	mov    0x60(%edx),%eax
f0105781:	89 04 24             	mov    %eax,(%esp)
f0105784:	e8 19 c0 ff ff       	call   f01017a2 <page_insert>
f0105789:	85 c0                	test   %eax,%eax
f010578b:	0f 89 40 04 00 00    	jns    f0105bd1 <syscall+0x9da>
f0105791:	eb 5e                	jmp    f01057f1 <syscall+0x5fa>

	if((int32_t) srcva < UTOP)
	{
		e->env_ipc_perm = perm;
	}
	e->env_status = ENV_RUNNABLE;
f0105793:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	e->env_tf.tf_regs.reg_eax = 0;
f010579a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return 0;
f01057a1:	b8 00 00 00 00       	mov    $0x0,%eax
f01057a6:	e9 82 04 00 00       	jmp    f0105c2d <syscall+0xa36>
	struct PageInfo *page;
	pte_t *pte;

	if (envid2env(envid, &e, 0) < 0)
	{
		return -E_BAD_ENV;
f01057ab:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01057b0:	e9 78 04 00 00       	jmp    f0105c2d <syscall+0xa36>
	}

	if (e->env_ipc_recving == 0)
	{
		return -E_IPC_NOT_RECV;
f01057b5:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
f01057ba:	e9 6e 04 00 00       	jmp    f0105c2d <syscall+0xa36>
	}

	if ((uint32_t) srcva < UTOP)
	{
		if ((uint32_t) srcva % PGSIZE != 0) {
			return -E_INVAL;
f01057bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01057c4:	e9 64 04 00 00       	jmp    f0105c2d <syscall+0xa36>
		}
		if (!((perm & PTE_U) && (perm & PTE_P))) {
			return -E_INVAL;
f01057c9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01057ce:	e9 5a 04 00 00       	jmp    f0105c2d <syscall+0xa36>
		}
		if (perm & ~(PTE_U | PTE_P | PTE_W | PTE_AVAIL)) {
			return -E_INVAL;
f01057d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01057d8:	e9 50 04 00 00       	jmp    f0105c2d <syscall+0xa36>
		}
		if (!(page = page_lookup(curenv->env_pgdir, srcva, &pte))) {
			return -E_INVAL;
f01057dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01057e2:	e9 46 04 00 00       	jmp    f0105c2d <syscall+0xa36>
		}
		if ((perm & PTE_W) && ((*pte & PTE_W) == 0))
		{
			return -E_INVAL;
f01057e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01057ec:	e9 3c 04 00 00       	jmp    f0105c2d <syscall+0xa36>
		}
		if ((uint32_t)e->env_ipc_dstva < UTOP)
		{
			if (page_insert(e->env_pgdir, page, e->env_ipc_dstva, perm) < 0)
			{
				return -E_NO_MEM;
f01057f1:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
                case (SYS_page_unmap):
                        return sys_page_unmap(a1, (void *) a2);
                case (SYS_env_set_pgfault_upcall):
                        return sys_env_set_pgfault_upcall(a1, (void *) a2);
		case (SYS_ipc_try_send):
			return sys_ipc_try_send(a1, a2, (void *) a3, a4);
f01057f6:	e9 32 04 00 00       	jmp    f0105c2d <syscall+0xa36>
//	-E_INVAL if dstva < UTOP but dstva is not page-aligned.
static int
sys_ipc_recv(void *dstva)
{
	// LAB 4: Your code here.
	if ((uint32_t)dstva < UTOP && ((uint32_t)dstva % PGSIZE != 0))
f01057fb:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0105802:	77 0d                	ja     f0105811 <syscall+0x61a>
f0105804:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f010580b:	0f 85 8c 03 00 00    	jne    f0105b9d <syscall+0x9a6>
	{
		return -E_INVAL;
	}
	curenv->env_ipc_recving = 1;
f0105811:	e8 f3 15 00 00       	call   f0106e09 <cpunum>
f0105816:	6b c0 74             	imul   $0x74,%eax,%eax
f0105819:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f010581f:	c6 40 68 01          	movb   $0x1,0x68(%eax)
	curenv->env_ipc_perm = 0;
f0105823:	e8 e1 15 00 00       	call   f0106e09 <cpunum>
f0105828:	6b c0 74             	imul   $0x74,%eax,%eax
f010582b:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105831:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
	curenv->env_ipc_dstva = dstva;
f0105838:	e8 cc 15 00 00       	call   f0106e09 <cpunum>
f010583d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105840:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105846:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105849:	89 50 6c             	mov    %edx,0x6c(%eax)
	curenv->env_status = ENV_NOT_RUNNABLE;
f010584c:	e8 b8 15 00 00       	call   f0106e09 <cpunum>
f0105851:	6b c0 74             	imul   $0x74,%eax,%eax
f0105854:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f010585a:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)

	sched_yield();
f0105861:	e8 60 f8 ff ff       	call   f01050c6 <sched_yield>
	// LAB 5: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
	//panic("sys_env_set_trapframe not implemented");
	struct Env *e;
	int r = envid2env(envid, &e, true);
f0105866:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010586d:	00 
f010586e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0105871:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105875:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105878:	89 04 24             	mov    %eax,(%esp)
f010587b:	e8 fd e1 ff ff       	call   f0103a7d <envid2env>
	if (r < 0) {
		return r;
f0105880:	89 c2                	mov    %eax,%edx
	// Remember to check whether the user has supplied us with a good
	// address!
	//panic("sys_env_set_trapframe not implemented");
	struct Env *e;
	int r = envid2env(envid, &e, true);
	if (r < 0) {
f0105882:	85 c0                	test   %eax,%eax
f0105884:	78 4e                	js     f01058d4 <syscall+0x6dd>
		case (SYS_ipc_try_send):
			return sys_ipc_try_send(a1, a2, (void *) a3, a4);
		case (SYS_ipc_recv):
			return sys_ipc_recv((void *) a1);
		case (SYS_env_set_trapframe):
			return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
f0105886:	8b 75 10             	mov    0x10(%ebp),%esi
	int r = envid2env(envid, &e, true);
	if (r < 0) {
		return r;
	}

	r = user_mem_check(e, tf, sizeof(*tf), PTE_U | PTE_W);
f0105889:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f0105890:	00 
f0105891:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f0105898:	00 
f0105899:	89 74 24 04          	mov    %esi,0x4(%esp)
f010589d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01058a0:	89 04 24             	mov    %eax,(%esp)
f01058a3:	e8 55 e0 ff ff       	call   f01038fd <user_mem_check>
	if (r < 0) {
f01058a8:	85 c0                	test   %eax,%eax
f01058aa:	78 26                	js     f01058d2 <syscall+0x6db>
		return r;
	}
	tf->tf_eflags &= ~FL_IOPL_MASK;
f01058ac:	8b 45 10             	mov    0x10(%ebp),%eax
f01058af:	8b 40 38             	mov    0x38(%eax),%eax
f01058b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01058b5:	80 e4 cf             	and    $0xcf,%ah
	tf->tf_eflags |= FL_IF | FL_IOPL_0;
f01058b8:	80 cc 02             	or     $0x2,%ah
f01058bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01058be:	89 41 38             	mov    %eax,0x38(%ecx)
	assert((tf->tf_eflags & FL_IF) == FL_IF);
	e->env_tf = *tf;
f01058c1:	b9 11 00 00 00       	mov    $0x11,%ecx
f01058c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01058c9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	return 0;
f01058cb:	ba 00 00 00 00       	mov    $0x0,%edx
f01058d0:	eb 02                	jmp    f01058d4 <syscall+0x6dd>
		return r;
	}

	r = user_mem_check(e, tf, sizeof(*tf), PTE_U | PTE_W);
	if (r < 0) {
		return r;
f01058d2:	89 c2                	mov    %eax,%edx
		case (SYS_ipc_try_send):
			return sys_ipc_try_send(a1, a2, (void *) a3, a4);
		case (SYS_ipc_recv):
			return sys_ipc_recv((void *) a1);
		case (SYS_env_set_trapframe):
			return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
f01058d4:	89 d0                	mov    %edx,%eax
f01058d6:	e9 52 03 00 00       	jmp    f0105c2d <syscall+0xa36>
// Return the current time.
static int
sys_time_msec(void)
{
	// LAB 6: Your code here.
	return time_msec();
f01058db:	e8 83 25 00 00       	call   f0107e63 <time_msec>
		case (SYS_ipc_recv):
			return sys_ipc_recv((void *) a1);
		case (SYS_env_set_trapframe):
			return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
		case (SYS_time_msec):
			return sys_time_msec();
f01058e0:	e9 48 03 00 00       	jmp    f0105c2d <syscall+0xa36>
}

static int
sys_e1000_transmit(char *pkt, size_t length)
{
	user_mem_assert(curenv, pkt, length, PTE_W);
f01058e5:	e8 1f 15 00 00       	call   f0106e09 <cpunum>
f01058ea:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f01058f1:	00 
f01058f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01058f5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01058f9:	8b 55 0c             	mov    0xc(%ebp),%edx
f01058fc:	89 54 24 04          	mov    %edx,0x4(%esp)
f0105900:	6b c0 74             	imul   $0x74,%eax,%eax
f0105903:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105909:	89 04 24             	mov    %eax,(%esp)
f010590c:	e8 77 e0 ff ff       	call   f0103988 <user_mem_assert>

	int num_tries = 20;
	while((e1000_transmit(pkt, length) == -1) && (num_tries > 0)) {
f0105911:	8b 45 10             	mov    0x10(%ebp),%eax
f0105914:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105918:	8b 45 0c             	mov    0xc(%ebp),%eax
f010591b:	89 04 24             	mov    %eax,(%esp)
f010591e:	e8 25 19 00 00       	call   f0107248 <e1000_transmit>
f0105923:	83 f8 ff             	cmp    $0xffffffff,%eax
f0105926:	0f 85 7b 02 00 00    	jne    f0105ba7 <syscall+0x9b0>

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
f010592c:	e8 95 f7 ff ff       	call   f01050c6 <sched_yield>
}

static int
sys_e1000_receive(char *pkt, size_t *length)
{
	user_mem_assert(curenv, pkt, PKT_BUF_SIZE, PTE_W);
f0105931:	e8 d3 14 00 00       	call   f0106e09 <cpunum>
f0105936:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
f010593d:	00 
f010593e:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
f0105945:	00 
f0105946:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105949:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f010594d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105950:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105956:	89 04 24             	mov    %eax,(%esp)
f0105959:	e8 2a e0 ff ff       	call   f0103988 <user_mem_assert>
	if (e1000_receive(pkt, length) == 0)
f010595e:	8b 45 10             	mov    0x10(%ebp),%eax
f0105961:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105965:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105968:	89 04 24             	mov    %eax,(%esp)
f010596b:	e8 7b 19 00 00       	call   f01072eb <e1000_receive>
f0105970:	85 c0                	test   %eax,%eax
f0105972:	0f 84 36 02 00 00    	je     f0105bae <syscall+0x9b7>
		return 0;
	else {
		curenv->env_status = ENV_NOT_RUNNABLE;
f0105978:	e8 8c 14 00 00       	call   f0106e09 <cpunum>
f010597d:	6b c0 74             	imul   $0x74,%eax,%eax
f0105980:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105986:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
		curenv->env_e1000_waiting_rx = true;
f010598d:	e8 77 14 00 00       	call   f0106e09 <cpunum>
f0105992:	6b c0 74             	imul   $0x74,%eax,%eax
f0105995:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f010599b:	c6 40 7c 01          	movb   $0x1,0x7c(%eax)
		curenv->env_tf.tf_regs.reg_eax = -E_E1000_RXBUF_EMPTY;
f010599f:	e8 65 14 00 00       	call   f0106e09 <cpunum>
f01059a4:	6b c0 74             	imul   $0x74,%eax,%eax
f01059a7:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f01059ad:	c7 40 1c ef ff ff ff 	movl   $0xffffffef,0x1c(%eax)

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
f01059b4:	e8 0d f7 ff ff       	call   f01050c6 <sched_yield>
		case (SYS_e1000_transmit):
			return sys_e1000_transmit((char *) a1, a2);
		case (SYS_e1000_receive):
			return sys_e1000_receive((char *) a1, (size_t *) a2);
		case (SYS_e1000_get_mac):
			return sys_e1000_get_mac((uint8_t *) a1);
f01059b9:	8b 45 0c             	mov    0xc(%ebp),%eax
f01059bc:	89 04 24             	mov    %eax,(%esp)
f01059bf:	e8 ec f7 ff ff       	call   f01051b0 <sys_e1000_get_mac>
f01059c4:	e9 64 02 00 00       	jmp    f0105c2d <syscall+0xa36>
		case (SYS_exec):
			return sys_exec((uint32_t)a1, (uint32_t)a2, (void *)a3, (uint32_t)a4);
f01059c9:	8b 45 14             	mov    0x14(%ebp),%eax
f01059cc:	89 45 c8             	mov    %eax,-0x38(%ebp)
}

static int
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	curenv->env_tf.tf_eip = eip;
f01059cf:	e8 35 14 00 00       	call   f0106e09 <cpunum>
f01059d4:	6b c0 74             	imul   $0x74,%eax,%eax
f01059d7:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f01059dd:	8b 55 0c             	mov    0xc(%ebp),%edx
f01059e0:	89 50 30             	mov    %edx,0x30(%eax)
	curenv->env_tf.tf_esp = esp;
f01059e3:	e8 21 14 00 00       	call   f0106e09 <cpunum>
f01059e8:	6b c0 74             	imul   $0x74,%eax,%eax
f01059eb:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f01059f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01059f4:	89 48 3c             	mov    %ecx,0x3c(%eax)
f01059f7:	8b 45 18             	mov    0x18(%ebp),%eax
f01059fa:	89 45 c0             	mov    %eax,-0x40(%ebp)

	int perm, i;
	uint32_t tmp = ETEMPREGION;
f01059fd:	bf 00 00 00 e0       	mov    $0xe0000000,%edi
	uint32_t va, end;
	struct PageInfo * pg;

	struct Proghdr * ph = (struct Proghdr *) v_ph; 
	for (i = 0; i < phnum; i++, ph++) {
f0105a02:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
f0105a09:	e9 e6 00 00 00       	jmp    f0105af4 <syscall+0x8fd>
		if (ph->p_type != ELF_PROG_LOAD)
f0105a0e:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0105a11:	83 38 01             	cmpl   $0x1,(%eax)
f0105a14:	0f 85 d2 00 00 00    	jne    f0105aec <syscall+0x8f5>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
f0105a1a:	89 c1                	mov    %eax,%ecx
f0105a1c:	8b 40 18             	mov    0x18(%eax),%eax
f0105a1f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0105a22:	83 e0 02             	and    $0x2,%eax

	struct Proghdr * ph = (struct Proghdr *) v_ph; 
	for (i = 0; i < phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
f0105a25:	83 f8 01             	cmp    $0x1,%eax
f0105a28:	19 c0                	sbb    %eax,%eax
f0105a2a:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105a2d:	83 65 d0 fe          	andl   $0xfffffffe,-0x30(%ebp)
f0105a31:	83 45 d0 07          	addl   $0x7,-0x30(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;

		end = ROUNDUP(ph->p_va + ph->p_memsz, PGSIZE);
f0105a35:	8b 59 08             	mov    0x8(%ecx),%ebx
f0105a38:	89 d8                	mov    %ebx,%eax
f0105a3a:	03 41 14             	add    0x14(%ecx),%eax
f0105a3d:	05 ff 0f 00 00       	add    $0xfff,%eax
f0105a42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0105a47:	89 45 cc             	mov    %eax,-0x34(%ebp)
		for (va = ROUNDDOWN(ph->p_va, PGSIZE); va != end; tmp += PGSIZE, va += PGSIZE) {
f0105a4a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f0105a50:	e9 8e 00 00 00       	jmp    f0105ae3 <syscall+0x8ec>
			if ((pg = page_lookup(curenv->env_pgdir, (void *)tmp, NULL)) == NULL) 
f0105a55:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f0105a58:	e8 ac 13 00 00       	call   f0106e09 <cpunum>
f0105a5d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0105a64:	00 
f0105a65:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105a69:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a6c:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105a72:	8b 40 60             	mov    0x60(%eax),%eax
f0105a75:	89 04 24             	mov    %eax,(%esp)
f0105a78:	e8 2e bc ff ff       	call   f01016ab <page_lookup>
f0105a7d:	89 c6                	mov    %eax,%esi
f0105a7f:	85 c0                	test   %eax,%eax
f0105a81:	0f 84 2e 01 00 00    	je     f0105bb5 <syscall+0x9be>
				return -E_NO_MEM;
			if (page_insert(curenv->env_pgdir, pg, (void *)va, perm) < 0)
f0105a87:	e8 7d 13 00 00       	call   f0106e09 <cpunum>
f0105a8c:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0105a8f:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0105a93:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0105a97:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105a9b:	6b c0 74             	imul   $0x74,%eax,%eax
f0105a9e:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105aa4:	8b 40 60             	mov    0x60(%eax),%eax
f0105aa7:	89 04 24             	mov    %eax,(%esp)
f0105aaa:	e8 f3 bc ff ff       	call   f01017a2 <page_insert>
f0105aaf:	85 c0                	test   %eax,%eax
f0105ab1:	0f 88 05 01 00 00    	js     f0105bbc <syscall+0x9c5>
				return -E_NO_MEM;
			page_remove(curenv->env_pgdir, (void *)tmp);
f0105ab7:	e8 4d 13 00 00       	call   f0106e09 <cpunum>
f0105abc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f0105abf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0105ac3:	6b c0 74             	imul   $0x74,%eax,%eax
f0105ac6:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105acc:	8b 40 60             	mov    0x60(%eax),%eax
f0105acf:	89 04 24             	mov    %eax,(%esp)
f0105ad2:	e8 82 bc ff ff       	call   f0101759 <page_remove>
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;

		end = ROUNDUP(ph->p_va + ph->p_memsz, PGSIZE);
		for (va = ROUNDDOWN(ph->p_va, PGSIZE); va != end; tmp += PGSIZE, va += PGSIZE) {
f0105ad7:	81 c7 00 10 00 00    	add    $0x1000,%edi
f0105add:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0105ae3:	39 5d cc             	cmp    %ebx,-0x34(%ebp)
f0105ae6:	0f 85 69 ff ff ff    	jne    f0105a55 <syscall+0x85e>
	uint32_t tmp = ETEMPREGION;
	uint32_t va, end;
	struct PageInfo * pg;

	struct Proghdr * ph = (struct Proghdr *) v_ph; 
	for (i = 0; i < phnum; i++, ph++) {
f0105aec:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
f0105af0:	83 45 c8 20          	addl   $0x20,-0x38(%ebp)
f0105af4:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0105af7:	39 45 c4             	cmp    %eax,-0x3c(%ebp)
f0105afa:	0f 85 0e ff ff ff    	jne    f0105a0e <syscall+0x817>
				return -E_NO_MEM;
			page_remove(curenv->env_pgdir, (void *)tmp);
		}
	}

	if ((pg = page_lookup(curenv->env_pgdir, (void *)tmp, NULL)) == NULL) 
f0105b00:	e8 04 13 00 00       	call   f0106e09 <cpunum>
f0105b05:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0105b0c:	00 
f0105b0d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105b11:	6b c0 74             	imul   $0x74,%eax,%eax
f0105b14:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105b1a:	8b 40 60             	mov    0x60(%eax),%eax
f0105b1d:	89 04 24             	mov    %eax,(%esp)
f0105b20:	e8 86 bb ff ff       	call   f01016ab <page_lookup>
f0105b25:	89 c3                	mov    %eax,%ebx
f0105b27:	85 c0                	test   %eax,%eax
f0105b29:	0f 84 94 00 00 00    	je     f0105bc3 <syscall+0x9cc>
		return -E_NO_MEM;
	if (page_insert(curenv->env_pgdir, pg, (void *)(USTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W) < 0) 
f0105b2f:	e8 d5 12 00 00       	call   f0106e09 <cpunum>
f0105b34:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
f0105b3b:	00 
f0105b3c:	c7 44 24 08 00 d0 bf 	movl   $0xeebfd000,0x8(%esp)
f0105b43:	ee 
f0105b44:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0105b48:	6b c0 74             	imul   $0x74,%eax,%eax
f0105b4b:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105b51:	8b 40 60             	mov    0x60(%eax),%eax
f0105b54:	89 04 24             	mov    %eax,(%esp)
f0105b57:	e8 46 bc ff ff       	call   f01017a2 <page_insert>
f0105b5c:	85 c0                	test   %eax,%eax
f0105b5e:	78 6a                	js     f0105bca <syscall+0x9d3>
		return -E_NO_MEM;
	page_remove(curenv->env_pgdir, (void *)tmp);
f0105b60:	e8 a4 12 00 00       	call   f0106e09 <cpunum>
f0105b65:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0105b69:	6b c0 74             	imul   $0x74,%eax,%eax
f0105b6c:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105b72:	8b 40 60             	mov    0x60(%eax),%eax
f0105b75:	89 04 24             	mov    %eax,(%esp)
f0105b78:	e8 dc bb ff ff       	call   f0101759 <page_remove>
	
	env_run(curenv);// never return
f0105b7d:	e8 87 12 00 00       	call   f0106e09 <cpunum>
f0105b82:	6b c0 74             	imul   $0x74,%eax,%eax
f0105b85:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105b8b:	89 04 24             	mov    %eax,(%esp)
f0105b8e:	e8 40 e5 ff ff       	call   f01040d3 <env_run>
		case (SYS_e1000_get_mac):
			return sys_e1000_get_mac((uint8_t *) a1);
		case (SYS_exec):
			return sys_exec((uint32_t)a1, (uint32_t)a2, (void *)a3, (uint32_t)a4);
		default:
			return -E_INVAL;
f0105b93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105b98:	e9 90 00 00 00       	jmp    f0105c2d <syscall+0xa36>
                case (SYS_env_set_pgfault_upcall):
                        return sys_env_set_pgfault_upcall(a1, (void *) a2);
		case (SYS_ipc_try_send):
			return sys_ipc_try_send(a1, a2, (void *) a3, a4);
		case (SYS_ipc_recv):
			return sys_ipc_recv((void *) a1);
f0105b9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105ba2:	e9 86 00 00 00       	jmp    f0105c2d <syscall+0xa36>
		case (SYS_env_set_trapframe):
			return sys_env_set_trapframe(a1, (struct Trapframe *)a2);
		case (SYS_time_msec):
			return sys_time_msec();
		case (SYS_e1000_transmit):
			return sys_e1000_transmit((char *) a1, a2);
f0105ba7:	b8 00 00 00 00       	mov    $0x0,%eax
f0105bac:	eb 7f                	jmp    f0105c2d <syscall+0xa36>
		case (SYS_e1000_receive):
			return sys_e1000_receive((char *) a1, (size_t *) a2);
f0105bae:	b8 00 00 00 00       	mov    $0x0,%eax
f0105bb3:	eb 78                	jmp    f0105c2d <syscall+0xa36>
		case (SYS_e1000_get_mac):
			return sys_e1000_get_mac((uint8_t *) a1);
		case (SYS_exec):
			return sys_exec((uint32_t)a1, (uint32_t)a2, (void *)a3, (uint32_t)a4);
f0105bb5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0105bba:	eb 71                	jmp    f0105c2d <syscall+0xa36>
f0105bbc:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0105bc1:	eb 6a                	jmp    f0105c2d <syscall+0xa36>
f0105bc3:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0105bc8:	eb 63                	jmp    f0105c2d <syscall+0xa36>
f0105bca:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0105bcf:	eb 5c                	jmp    f0105c2d <syscall+0xa36>
			{
				return -E_NO_MEM;
			}
		}
	}
	e->env_ipc_recving = 0;
f0105bd1:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0105bd4:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	e->env_ipc_from = curenv->env_id;
f0105bd8:	e8 2c 12 00 00       	call   f0106e09 <cpunum>
f0105bdd:	6b c0 74             	imul   $0x74,%eax,%eax
f0105be0:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105be6:	8b 40 48             	mov    0x48(%eax),%eax
f0105be9:	89 43 74             	mov    %eax,0x74(%ebx)
	e->env_ipc_value = value;
f0105bec:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105bef:	8b 55 10             	mov    0x10(%ebp),%edx
f0105bf2:	89 50 70             	mov    %edx,0x70(%eax)
	e->env_ipc_perm = 0;

	if((int32_t) srcva < UTOP)
	{
		e->env_ipc_perm = perm;
f0105bf5:	8b 75 18             	mov    0x18(%ebp),%esi
f0105bf8:	89 70 78             	mov    %esi,0x78(%eax)
f0105bfb:	e9 93 fb ff ff       	jmp    f0105793 <syscall+0x59c>
			{
				return -E_NO_MEM;
			}
		}
	}
	e->env_ipc_recving = 0;
f0105c00:	c6 43 68 00          	movb   $0x0,0x68(%ebx)
	e->env_ipc_from = curenv->env_id;
f0105c04:	e8 00 12 00 00       	call   f0106e09 <cpunum>
f0105c09:	6b c0 74             	imul   $0x74,%eax,%eax
f0105c0c:	8b 80 28 a0 2c f0    	mov    -0xfd35fd8(%eax),%eax
f0105c12:	8b 40 48             	mov    0x48(%eax),%eax
f0105c15:	89 43 74             	mov    %eax,0x74(%ebx)
	e->env_ipc_value = value;
f0105c18:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105c1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105c1e:	89 48 70             	mov    %ecx,0x70(%eax)
	e->env_ipc_perm = 0;
f0105c21:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
f0105c28:	e9 66 fb ff ff       	jmp    f0105793 <syscall+0x59c>
		case (SYS_exec):
			return sys_exec((uint32_t)a1, (uint32_t)a2, (void *)a3, (uint32_t)a4);
		default:
			return -E_INVAL;
	}
}
f0105c2d:	83 c4 4c             	add    $0x4c,%esp
f0105c30:	5b                   	pop    %ebx
f0105c31:	5e                   	pop    %esi
f0105c32:	5f                   	pop    %edi
f0105c33:	5d                   	pop    %ebp
f0105c34:	c3                   	ret    

f0105c35 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0105c35:	55                   	push   %ebp
f0105c36:	89 e5                	mov    %esp,%ebp
f0105c38:	57                   	push   %edi
f0105c39:	56                   	push   %esi
f0105c3a:	53                   	push   %ebx
f0105c3b:	83 ec 14             	sub    $0x14,%esp
f0105c3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105c41:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0105c44:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105c47:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0105c4a:	8b 1a                	mov    (%edx),%ebx
f0105c4c:	8b 01                	mov    (%ecx),%eax
f0105c4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105c51:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0105c58:	e9 88 00 00 00       	jmp    f0105ce5 <stab_binsearch+0xb0>
		int true_m = (l + r) / 2, m = true_m;
f0105c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0105c60:	01 d8                	add    %ebx,%eax
f0105c62:	89 c7                	mov    %eax,%edi
f0105c64:	c1 ef 1f             	shr    $0x1f,%edi
f0105c67:	01 c7                	add    %eax,%edi
f0105c69:	d1 ff                	sar    %edi
f0105c6b:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0105c6e:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0105c71:	8d 14 81             	lea    (%ecx,%eax,4),%edx
f0105c74:	89 f8                	mov    %edi,%eax

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0105c76:	eb 03                	jmp    f0105c7b <stab_binsearch+0x46>
			m--;
f0105c78:	83 e8 01             	sub    $0x1,%eax

	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0105c7b:	39 c3                	cmp    %eax,%ebx
f0105c7d:	7f 1f                	jg     f0105c9e <stab_binsearch+0x69>
f0105c7f:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
f0105c83:	83 ea 0c             	sub    $0xc,%edx
f0105c86:	39 f1                	cmp    %esi,%ecx
f0105c88:	75 ee                	jne    f0105c78 <stab_binsearch+0x43>
f0105c8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0105c8d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105c90:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0105c93:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0105c97:	39 55 0c             	cmp    %edx,0xc(%ebp)
f0105c9a:	76 18                	jbe    f0105cb4 <stab_binsearch+0x7f>
f0105c9c:	eb 05                	jmp    f0105ca3 <stab_binsearch+0x6e>

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0105c9e:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0105ca1:	eb 42                	jmp    f0105ce5 <stab_binsearch+0xb0>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
			*region_left = m;
f0105ca3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0105ca6:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0105ca8:	8d 5f 01             	lea    0x1(%edi),%ebx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f0105cab:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105cb2:	eb 31                	jmp    f0105ce5 <stab_binsearch+0xb0>
		if (stabs[m].n_value < addr) {
			*region_left = m;
			l = true_m + 1;
		} else if (stabs[m].n_value > addr) {
f0105cb4:	39 55 0c             	cmp    %edx,0xc(%ebp)
f0105cb7:	73 17                	jae    f0105cd0 <stab_binsearch+0x9b>
			*region_right = m - 1;
f0105cb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0105cbc:	83 e8 01             	sub    $0x1,%eax
f0105cbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0105cc2:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105cc5:	89 07                	mov    %eax,(%edi)
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f0105cc7:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0105cce:	eb 15                	jmp    f0105ce5 <stab_binsearch+0xb0>
			*region_right = m - 1;
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0105cd0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105cd3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f0105cd6:	89 1f                	mov    %ebx,(%edi)
			l = m;
			addr++;
f0105cd8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0105cdc:	89 c3                	mov    %eax,%ebx
			l = true_m + 1;
			continue;
		}

		// actual binary search
		any_matches = 1;
f0105cde:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;

	while (l <= r) {
f0105ce5:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0105ce8:	0f 8e 6f ff ff ff    	jle    f0105c5d <stab_binsearch+0x28>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f0105cee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0105cf2:	75 0f                	jne    f0105d03 <stab_binsearch+0xce>
		*region_right = *region_left - 1;
f0105cf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105cf7:	8b 00                	mov    (%eax),%eax
f0105cf9:	83 e8 01             	sub    $0x1,%eax
f0105cfc:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105cff:	89 07                	mov    %eax,(%edi)
f0105d01:	eb 2c                	jmp    f0105d2f <stab_binsearch+0xfa>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105d03:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105d06:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f0105d08:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105d0b:	8b 0f                	mov    (%edi),%ecx
f0105d0d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105d10:	8b 7d ec             	mov    -0x14(%ebp),%edi
f0105d13:	8d 14 97             	lea    (%edi,%edx,4),%edx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105d16:	eb 03                	jmp    f0105d1b <stab_binsearch+0xe6>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
f0105d18:	83 e8 01             	sub    $0x1,%eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105d1b:	39 c8                	cmp    %ecx,%eax
f0105d1d:	7e 0b                	jle    f0105d2a <stab_binsearch+0xf5>
		     l > *region_left && stabs[l].n_type != type;
f0105d1f:	0f b6 5a 04          	movzbl 0x4(%edx),%ebx
f0105d23:	83 ea 0c             	sub    $0xc,%edx
f0105d26:	39 f3                	cmp    %esi,%ebx
f0105d28:	75 ee                	jne    f0105d18 <stab_binsearch+0xe3>
		     l--)
			/* do nothing */;
		*region_left = l;
f0105d2a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0105d2d:	89 07                	mov    %eax,(%edi)
	}
}
f0105d2f:	83 c4 14             	add    $0x14,%esp
f0105d32:	5b                   	pop    %ebx
f0105d33:	5e                   	pop    %esi
f0105d34:	5f                   	pop    %edi
f0105d35:	5d                   	pop    %ebp
f0105d36:	c3                   	ret    

f0105d37 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0105d37:	55                   	push   %ebp
f0105d38:	89 e5                	mov    %esp,%ebp
f0105d3a:	57                   	push   %edi
f0105d3b:	56                   	push   %esi
f0105d3c:	53                   	push   %ebx
f0105d3d:	83 ec 4c             	sub    $0x4c,%esp
f0105d40:	8b 75 08             	mov    0x8(%ebp),%esi
f0105d43:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0105d46:	c7 03 68 9b 10 f0    	movl   $0xf0109b68,(%ebx)
	info->eip_line = 0;
f0105d4c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0105d53:	c7 43 08 68 9b 10 f0 	movl   $0xf0109b68,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0105d5a:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f0105d61:	89 73 10             	mov    %esi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0105d64:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0105d6b:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f0105d71:	77 21                	ja     f0105d94 <debuginfo_eip+0x5d>

		// Make sure this memory is valid.
		// Return -1 if it is not.  Hint: Call user_mem_check.
		// LAB 3: Your code here.

		stabs = usd->stabs;
f0105d73:	a1 00 00 20 00       	mov    0x200000,%eax
f0105d78:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		stab_end = usd->stab_end;
f0105d7b:	a1 04 00 20 00       	mov    0x200004,%eax
		stabstr = usd->stabstr;
f0105d80:	8b 3d 08 00 20 00    	mov    0x200008,%edi
f0105d86:	89 7d c0             	mov    %edi,-0x40(%ebp)
		stabstr_end = usd->stabstr_end;
f0105d89:	8b 3d 0c 00 20 00    	mov    0x20000c,%edi
f0105d8f:	89 7d bc             	mov    %edi,-0x44(%ebp)
f0105d92:	eb 1a                	jmp    f0105dae <debuginfo_eip+0x77>
	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0105d94:	c7 45 bc 85 b4 11 f0 	movl   $0xf011b485,-0x44(%ebp)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
f0105d9b:	c7 45 c0 c9 6a 11 f0 	movl   $0xf0116ac9,-0x40(%ebp)
	info->eip_fn_narg = 0;

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
f0105da2:	b8 c8 6a 11 f0       	mov    $0xf0116ac8,%eax
	info->eip_fn_addr = addr;
	info->eip_fn_narg = 0;

	// Find the relevant set of stabs
	if (addr >= ULIM) {
		stabs = __STAB_BEGIN__;
f0105da7:	c7 45 c4 44 a4 10 f0 	movl   $0xf010a444,-0x3c(%ebp)
		// Make sure the STABS and string table memory is valid.
		// LAB 3: Your code here.
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0105dae:	8b 7d bc             	mov    -0x44(%ebp),%edi
f0105db1:	39 7d c0             	cmp    %edi,-0x40(%ebp)
f0105db4:	0f 83 9d 01 00 00    	jae    f0105f57 <debuginfo_eip+0x220>
f0105dba:	80 7f ff 00          	cmpb   $0x0,-0x1(%edi)
f0105dbe:	0f 85 9a 01 00 00    	jne    f0105f5e <debuginfo_eip+0x227>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0105dc4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f0105dcb:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0105dce:	29 f8                	sub    %edi,%eax
f0105dd0:	c1 f8 02             	sar    $0x2,%eax
f0105dd3:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0105dd9:	83 e8 01             	sub    $0x1,%eax
f0105ddc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0105ddf:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105de3:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0105dea:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0105ded:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105df0:	89 f8                	mov    %edi,%eax
f0105df2:	e8 3e fe ff ff       	call   f0105c35 <stab_binsearch>
	if (lfile == 0)
f0105df7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105dfa:	85 c0                	test   %eax,%eax
f0105dfc:	0f 84 63 01 00 00    	je     f0105f65 <debuginfo_eip+0x22e>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0105e02:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0105e05:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105e08:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0105e0b:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105e0f:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0105e16:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0105e19:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0105e1c:	89 f8                	mov    %edi,%eax
f0105e1e:	e8 12 fe ff ff       	call   f0105c35 <stab_binsearch>

	if (lfun <= rfun) {
f0105e23:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105e26:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0105e29:	39 c8                	cmp    %ecx,%eax
f0105e2b:	7f 32                	jg     f0105e5f <debuginfo_eip+0x128>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f0105e2d:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105e30:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0105e33:	8d 3c 97             	lea    (%edi,%edx,4),%edi
f0105e36:	8b 17                	mov    (%edi),%edx
f0105e38:	89 55 b8             	mov    %edx,-0x48(%ebp)
f0105e3b:	8b 55 bc             	mov    -0x44(%ebp),%edx
f0105e3e:	2b 55 c0             	sub    -0x40(%ebp),%edx
f0105e41:	39 55 b8             	cmp    %edx,-0x48(%ebp)
f0105e44:	73 09                	jae    f0105e4f <debuginfo_eip+0x118>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f0105e46:	8b 55 b8             	mov    -0x48(%ebp),%edx
f0105e49:	03 55 c0             	add    -0x40(%ebp),%edx
f0105e4c:	89 53 08             	mov    %edx,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105e4f:	8b 57 08             	mov    0x8(%edi),%edx
f0105e52:	89 53 10             	mov    %edx,0x10(%ebx)
		addr -= info->eip_fn_addr;
f0105e55:	29 d6                	sub    %edx,%esi
		// Search within the function definition for the line number.
		lline = lfun;
f0105e57:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0105e5a:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0105e5d:	eb 0f                	jmp    f0105e6e <debuginfo_eip+0x137>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f0105e5f:	89 73 10             	mov    %esi,0x10(%ebx)
		lline = lfile;
f0105e62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105e65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f0105e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105e6b:	89 45 d0             	mov    %eax,-0x30(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105e6e:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f0105e75:	00 
f0105e76:	8b 43 08             	mov    0x8(%ebx),%eax
f0105e79:	89 04 24             	mov    %eax,(%esp)
f0105e7c:	e8 1a 09 00 00       	call   f010679b <strfind>
f0105e81:	2b 43 08             	sub    0x8(%ebx),%eax
f0105e84:	89 43 0c             	mov    %eax,0xc(%ebx)
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0105e87:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105e8b:	c7 04 24 44 00 00 00 	movl   $0x44,(%esp)
f0105e92:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105e95:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105e98:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0105e9b:	89 f8                	mov    %edi,%eax
f0105e9d:	e8 93 fd ff ff       	call   f0105c35 <stab_binsearch>
    	if (rline < lline) {
f0105ea2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0105ea5:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0105ea8:	0f 8c be 00 00 00    	jl     f0105f6c <debuginfo_eip+0x235>
        	return -1;
    	}
    	info->eip_line = stabs[lline].n_desc;
f0105eae:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0105eb1:	0f b7 44 87 06       	movzwl 0x6(%edi,%eax,4),%eax
f0105eb6:	89 43 04             	mov    %eax,0x4(%ebx)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0105eb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105ebc:	89 c6                	mov    %eax,%esi
f0105ebe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0105ec1:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0105ec4:	8d 14 97             	lea    (%edi,%edx,4),%edx
f0105ec7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
f0105eca:	eb 06                	jmp    f0105ed2 <debuginfo_eip+0x19b>
f0105ecc:	83 e8 01             	sub    $0x1,%eax
f0105ecf:	83 ea 0c             	sub    $0xc,%edx
f0105ed2:	89 c7                	mov    %eax,%edi
f0105ed4:	39 c6                	cmp    %eax,%esi
f0105ed6:	7f 3c                	jg     f0105f14 <debuginfo_eip+0x1dd>
	       && stabs[lline].n_type != N_SOL
f0105ed8:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
f0105edc:	80 f9 84             	cmp    $0x84,%cl
f0105edf:	75 08                	jne    f0105ee9 <debuginfo_eip+0x1b2>
f0105ee1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105ee4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0105ee7:	eb 11                	jmp    f0105efa <debuginfo_eip+0x1c3>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0105ee9:	80 f9 64             	cmp    $0x64,%cl
f0105eec:	75 de                	jne    f0105ecc <debuginfo_eip+0x195>
f0105eee:	83 7a 08 00          	cmpl   $0x0,0x8(%edx)
f0105ef2:	74 d8                	je     f0105ecc <debuginfo_eip+0x195>
f0105ef4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105ef7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0105efa:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0105efd:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f0105f00:	8b 04 86             	mov    (%esi,%eax,4),%eax
f0105f03:	8b 55 bc             	mov    -0x44(%ebp),%edx
f0105f06:	2b 55 c0             	sub    -0x40(%ebp),%edx
f0105f09:	39 d0                	cmp    %edx,%eax
f0105f0b:	73 0a                	jae    f0105f17 <debuginfo_eip+0x1e0>
		info->eip_file = stabstr + stabs[lline].n_strx;
f0105f0d:	03 45 c0             	add    -0x40(%ebp),%eax
f0105f10:	89 03                	mov    %eax,(%ebx)
f0105f12:	eb 03                	jmp    f0105f17 <debuginfo_eip+0x1e0>
f0105f14:	8b 5d 0c             	mov    0xc(%ebp),%ebx


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105f17:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105f1a:	8b 75 d8             	mov    -0x28(%ebp),%esi
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0105f1d:	b8 00 00 00 00       	mov    $0x0,%eax
		info->eip_file = stabstr + stabs[lline].n_strx;


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f0105f22:	39 f2                	cmp    %esi,%edx
f0105f24:	7d 52                	jge    f0105f78 <debuginfo_eip+0x241>
		for (lline = lfun + 1;
f0105f26:	83 c2 01             	add    $0x1,%edx
f0105f29:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0105f2c:	89 d0                	mov    %edx,%eax
f0105f2e:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0105f31:	8b 7d c4             	mov    -0x3c(%ebp),%edi
f0105f34:	8d 14 97             	lea    (%edi,%edx,4),%edx
f0105f37:	eb 04                	jmp    f0105f3d <debuginfo_eip+0x206>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f0105f39:	83 43 14 01          	addl   $0x1,0x14(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f0105f3d:	39 c6                	cmp    %eax,%esi
f0105f3f:	7e 32                	jle    f0105f73 <debuginfo_eip+0x23c>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0105f41:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
f0105f45:	83 c0 01             	add    $0x1,%eax
f0105f48:	83 c2 0c             	add    $0xc,%edx
f0105f4b:	80 f9 a0             	cmp    $0xa0,%cl
f0105f4e:	74 e9                	je     f0105f39 <debuginfo_eip+0x202>
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0105f50:	b8 00 00 00 00       	mov    $0x0,%eax
f0105f55:	eb 21                	jmp    f0105f78 <debuginfo_eip+0x241>
		// LAB 3: Your code here.
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
		return -1;
f0105f57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f5c:	eb 1a                	jmp    f0105f78 <debuginfo_eip+0x241>
f0105f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f63:	eb 13                	jmp    f0105f78 <debuginfo_eip+0x241>
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
	rfile = (stab_end - stabs) - 1;
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
	if (lfile == 0)
		return -1;
f0105f65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f6a:	eb 0c                	jmp    f0105f78 <debuginfo_eip+0x241>
	//	which one.
	// Your code here.

	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    	if (rline < lline) {
        	return -1;
f0105f6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105f71:	eb 05                	jmp    f0105f78 <debuginfo_eip+0x241>
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;

	return 0;
f0105f73:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105f78:	83 c4 4c             	add    $0x4c,%esp
f0105f7b:	5b                   	pop    %ebx
f0105f7c:	5e                   	pop    %esi
f0105f7d:	5f                   	pop    %edi
f0105f7e:	5d                   	pop    %ebp
f0105f7f:	c3                   	ret    

f0105f80 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0105f80:	55                   	push   %ebp
f0105f81:	89 e5                	mov    %esp,%ebp
f0105f83:	57                   	push   %edi
f0105f84:	56                   	push   %esi
f0105f85:	53                   	push   %ebx
f0105f86:	83 ec 3c             	sub    $0x3c,%esp
f0105f89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105f8c:	89 d7                	mov    %edx,%edi
f0105f8e:	8b 45 08             	mov    0x8(%ebp),%eax
f0105f91:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105f94:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105f97:	89 c3                	mov    %eax,%ebx
f0105f99:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0105f9c:	8b 45 10             	mov    0x10(%ebp),%eax
f0105f9f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0105fa2:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105fa7:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105faa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0105fad:	39 d9                	cmp    %ebx,%ecx
f0105faf:	72 05                	jb     f0105fb6 <printnum+0x36>
f0105fb1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
f0105fb4:	77 69                	ja     f010601f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0105fb6:	8b 4d 18             	mov    0x18(%ebp),%ecx
f0105fb9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0105fbd:	83 ee 01             	sub    $0x1,%esi
f0105fc0:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0105fc4:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105fc8:	8b 44 24 08          	mov    0x8(%esp),%eax
f0105fcc:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0105fd0:	89 c3                	mov    %eax,%ebx
f0105fd2:	89 d6                	mov    %edx,%esi
f0105fd4:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105fd7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0105fda:	89 54 24 08          	mov    %edx,0x8(%esp)
f0105fde:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
f0105fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105fe5:	89 04 24             	mov    %eax,(%esp)
f0105fe8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0105feb:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105fef:	e8 8c 1e 00 00       	call   f0107e80 <__udivdi3>
f0105ff4:	89 d9                	mov    %ebx,%ecx
f0105ff6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0105ffa:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0105ffe:	89 04 24             	mov    %eax,(%esp)
f0106001:	89 54 24 04          	mov    %edx,0x4(%esp)
f0106005:	89 fa                	mov    %edi,%edx
f0106007:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010600a:	e8 71 ff ff ff       	call   f0105f80 <printnum>
f010600f:	eb 1b                	jmp    f010602c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0106011:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106015:	8b 45 18             	mov    0x18(%ebp),%eax
f0106018:	89 04 24             	mov    %eax,(%esp)
f010601b:	ff d3                	call   *%ebx
f010601d:	eb 03                	jmp    f0106022 <printnum+0xa2>
f010601f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0106022:	83 ee 01             	sub    $0x1,%esi
f0106025:	85 f6                	test   %esi,%esi
f0106027:	7f e8                	jg     f0106011 <printnum+0x91>
f0106029:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f010602c:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106030:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0106034:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0106037:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010603a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010603e:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0106042:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106045:	89 04 24             	mov    %eax,(%esp)
f0106048:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010604b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010604f:	e8 5c 1f 00 00       	call   f0107fb0 <__umoddi3>
f0106054:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106058:	0f be 80 72 9b 10 f0 	movsbl -0xfef648e(%eax),%eax
f010605f:	89 04 24             	mov    %eax,(%esp)
f0106062:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106065:	ff d0                	call   *%eax
}
f0106067:	83 c4 3c             	add    $0x3c,%esp
f010606a:	5b                   	pop    %ebx
f010606b:	5e                   	pop    %esi
f010606c:	5f                   	pop    %edi
f010606d:	5d                   	pop    %ebp
f010606e:	c3                   	ret    

f010606f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f010606f:	55                   	push   %ebp
f0106070:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f0106072:	83 fa 01             	cmp    $0x1,%edx
f0106075:	7e 0e                	jle    f0106085 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
f0106077:	8b 10                	mov    (%eax),%edx
f0106079:	8d 4a 08             	lea    0x8(%edx),%ecx
f010607c:	89 08                	mov    %ecx,(%eax)
f010607e:	8b 02                	mov    (%edx),%eax
f0106080:	8b 52 04             	mov    0x4(%edx),%edx
f0106083:	eb 22                	jmp    f01060a7 <getuint+0x38>
	else if (lflag)
f0106085:	85 d2                	test   %edx,%edx
f0106087:	74 10                	je     f0106099 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
f0106089:	8b 10                	mov    (%eax),%edx
f010608b:	8d 4a 04             	lea    0x4(%edx),%ecx
f010608e:	89 08                	mov    %ecx,(%eax)
f0106090:	8b 02                	mov    (%edx),%eax
f0106092:	ba 00 00 00 00       	mov    $0x0,%edx
f0106097:	eb 0e                	jmp    f01060a7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
f0106099:	8b 10                	mov    (%eax),%edx
f010609b:	8d 4a 04             	lea    0x4(%edx),%ecx
f010609e:	89 08                	mov    %ecx,(%eax)
f01060a0:	8b 02                	mov    (%edx),%eax
f01060a2:	ba 00 00 00 00       	mov    $0x0,%edx
}
f01060a7:	5d                   	pop    %ebp
f01060a8:	c3                   	ret    

f01060a9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f01060a9:	55                   	push   %ebp
f01060aa:	89 e5                	mov    %esp,%ebp
f01060ac:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f01060af:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f01060b3:	8b 10                	mov    (%eax),%edx
f01060b5:	3b 50 04             	cmp    0x4(%eax),%edx
f01060b8:	73 0a                	jae    f01060c4 <sprintputch+0x1b>
		*b->buf++ = ch;
f01060ba:	8d 4a 01             	lea    0x1(%edx),%ecx
f01060bd:	89 08                	mov    %ecx,(%eax)
f01060bf:	8b 45 08             	mov    0x8(%ebp),%eax
f01060c2:	88 02                	mov    %al,(%edx)
}
f01060c4:	5d                   	pop    %ebp
f01060c5:	c3                   	ret    

f01060c6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f01060c6:	55                   	push   %ebp
f01060c7:	89 e5                	mov    %esp,%ebp
f01060c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
f01060cc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f01060cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01060d3:	8b 45 10             	mov    0x10(%ebp),%eax
f01060d6:	89 44 24 08          	mov    %eax,0x8(%esp)
f01060da:	8b 45 0c             	mov    0xc(%ebp),%eax
f01060dd:	89 44 24 04          	mov    %eax,0x4(%esp)
f01060e1:	8b 45 08             	mov    0x8(%ebp),%eax
f01060e4:	89 04 24             	mov    %eax,(%esp)
f01060e7:	e8 02 00 00 00       	call   f01060ee <vprintfmt>
	va_end(ap);
}
f01060ec:	c9                   	leave  
f01060ed:	c3                   	ret    

f01060ee <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f01060ee:	55                   	push   %ebp
f01060ef:	89 e5                	mov    %esp,%ebp
f01060f1:	57                   	push   %edi
f01060f2:	56                   	push   %esi
f01060f3:	53                   	push   %ebx
f01060f4:	83 ec 3c             	sub    $0x3c,%esp
f01060f7:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01060fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
f01060fd:	eb 14                	jmp    f0106113 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f01060ff:	85 c0                	test   %eax,%eax
f0106101:	0f 84 b3 03 00 00    	je     f01064ba <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
f0106107:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010610b:	89 04 24             	mov    %eax,(%esp)
f010610e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0106111:	89 f3                	mov    %esi,%ebx
f0106113:	8d 73 01             	lea    0x1(%ebx),%esi
f0106116:	0f b6 03             	movzbl (%ebx),%eax
f0106119:	83 f8 25             	cmp    $0x25,%eax
f010611c:	75 e1                	jne    f01060ff <vprintfmt+0x11>
f010611e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
f0106122:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0106129:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
f0106130:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
f0106137:	ba 00 00 00 00       	mov    $0x0,%edx
f010613c:	eb 1d                	jmp    f010615b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010613e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
f0106140:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
f0106144:	eb 15                	jmp    f010615b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0106146:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
f0106148:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
f010614c:	eb 0d                	jmp    f010615b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
f010614e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0106151:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0106154:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010615b:	8d 5e 01             	lea    0x1(%esi),%ebx
f010615e:	0f b6 0e             	movzbl (%esi),%ecx
f0106161:	0f b6 c1             	movzbl %cl,%eax
f0106164:	83 e9 23             	sub    $0x23,%ecx
f0106167:	80 f9 55             	cmp    $0x55,%cl
f010616a:	0f 87 2a 03 00 00    	ja     f010649a <vprintfmt+0x3ac>
f0106170:	0f b6 c9             	movzbl %cl,%ecx
f0106173:	ff 24 8d c0 9c 10 f0 	jmp    *-0xfef6340(,%ecx,4)
f010617a:	89 de                	mov    %ebx,%esi
f010617c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f0106181:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
f0106184:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
f0106188:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
f010618b:	8d 58 d0             	lea    -0x30(%eax),%ebx
f010618e:	83 fb 09             	cmp    $0x9,%ebx
f0106191:	77 36                	ja     f01061c9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f0106193:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
f0106196:	eb e9                	jmp    f0106181 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f0106198:	8b 45 14             	mov    0x14(%ebp),%eax
f010619b:	8d 48 04             	lea    0x4(%eax),%ecx
f010619e:	89 4d 14             	mov    %ecx,0x14(%ebp)
f01061a1:	8b 00                	mov    (%eax),%eax
f01061a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01061a6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
f01061a8:	eb 22                	jmp    f01061cc <vprintfmt+0xde>
f01061aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01061ad:	85 c9                	test   %ecx,%ecx
f01061af:	b8 00 00 00 00       	mov    $0x0,%eax
f01061b4:	0f 49 c1             	cmovns %ecx,%eax
f01061b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01061ba:	89 de                	mov    %ebx,%esi
f01061bc:	eb 9d                	jmp    f010615b <vprintfmt+0x6d>
f01061be:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
f01061c0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
f01061c7:	eb 92                	jmp    f010615b <vprintfmt+0x6d>
f01061c9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
f01061cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f01061d0:	79 89                	jns    f010615b <vprintfmt+0x6d>
f01061d2:	e9 77 ff ff ff       	jmp    f010614e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f01061d7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01061da:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
f01061dc:	e9 7a ff ff ff       	jmp    f010615b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f01061e1:	8b 45 14             	mov    0x14(%ebp),%eax
f01061e4:	8d 50 04             	lea    0x4(%eax),%edx
f01061e7:	89 55 14             	mov    %edx,0x14(%ebp)
f01061ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01061ee:	8b 00                	mov    (%eax),%eax
f01061f0:	89 04 24             	mov    %eax,(%esp)
f01061f3:	ff 55 08             	call   *0x8(%ebp)
			break;
f01061f6:	e9 18 ff ff ff       	jmp    f0106113 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
f01061fb:	8b 45 14             	mov    0x14(%ebp),%eax
f01061fe:	8d 50 04             	lea    0x4(%eax),%edx
f0106201:	89 55 14             	mov    %edx,0x14(%ebp)
f0106204:	8b 00                	mov    (%eax),%eax
f0106206:	99                   	cltd   
f0106207:	31 d0                	xor    %edx,%eax
f0106209:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f010620b:	83 f8 11             	cmp    $0x11,%eax
f010620e:	7f 0b                	jg     f010621b <vprintfmt+0x12d>
f0106210:	8b 14 85 20 9e 10 f0 	mov    -0xfef61e0(,%eax,4),%edx
f0106217:	85 d2                	test   %edx,%edx
f0106219:	75 20                	jne    f010623b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
f010621b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010621f:	c7 44 24 08 8a 9b 10 	movl   $0xf0109b8a,0x8(%esp)
f0106226:	f0 
f0106227:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010622b:	8b 45 08             	mov    0x8(%ebp),%eax
f010622e:	89 04 24             	mov    %eax,(%esp)
f0106231:	e8 90 fe ff ff       	call   f01060c6 <printfmt>
f0106236:	e9 d8 fe ff ff       	jmp    f0106113 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
f010623b:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010623f:	c7 44 24 08 dd 92 10 	movl   $0xf01092dd,0x8(%esp)
f0106246:	f0 
f0106247:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010624b:	8b 45 08             	mov    0x8(%ebp),%eax
f010624e:	89 04 24             	mov    %eax,(%esp)
f0106251:	e8 70 fe ff ff       	call   f01060c6 <printfmt>
f0106256:	e9 b8 fe ff ff       	jmp    f0106113 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010625b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
f010625e:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0106261:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f0106264:	8b 45 14             	mov    0x14(%ebp),%eax
f0106267:	8d 50 04             	lea    0x4(%eax),%edx
f010626a:	89 55 14             	mov    %edx,0x14(%ebp)
f010626d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
f010626f:	85 f6                	test   %esi,%esi
f0106271:	b8 83 9b 10 f0       	mov    $0xf0109b83,%eax
f0106276:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
f0106279:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
f010627d:	0f 84 97 00 00 00    	je     f010631a <vprintfmt+0x22c>
f0106283:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0106287:	0f 8e 9b 00 00 00    	jle    f0106328 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
f010628d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0106291:	89 34 24             	mov    %esi,(%esp)
f0106294:	e8 af 03 00 00       	call   f0106648 <strnlen>
f0106299:	8b 55 d0             	mov    -0x30(%ebp),%edx
f010629c:	29 c2                	sub    %eax,%edx
f010629e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
f01062a1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
f01062a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
f01062a8:	89 75 d8             	mov    %esi,-0x28(%ebp)
f01062ab:	8b 75 08             	mov    0x8(%ebp),%esi
f01062ae:	89 5d 10             	mov    %ebx,0x10(%ebp)
f01062b1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f01062b3:	eb 0f                	jmp    f01062c4 <vprintfmt+0x1d6>
					putch(padc, putdat);
f01062b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01062b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01062bc:	89 04 24             	mov    %eax,(%esp)
f01062bf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f01062c1:	83 eb 01             	sub    $0x1,%ebx
f01062c4:	85 db                	test   %ebx,%ebx
f01062c6:	7f ed                	jg     f01062b5 <vprintfmt+0x1c7>
f01062c8:	8b 75 d8             	mov    -0x28(%ebp),%esi
f01062cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01062ce:	85 d2                	test   %edx,%edx
f01062d0:	b8 00 00 00 00       	mov    $0x0,%eax
f01062d5:	0f 49 c2             	cmovns %edx,%eax
f01062d8:	29 c2                	sub    %eax,%edx
f01062da:	89 7d 0c             	mov    %edi,0xc(%ebp)
f01062dd:	89 d7                	mov    %edx,%edi
f01062df:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f01062e2:	eb 50                	jmp    f0106334 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f01062e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01062e8:	74 1e                	je     f0106308 <vprintfmt+0x21a>
f01062ea:	0f be d2             	movsbl %dl,%edx
f01062ed:	83 ea 20             	sub    $0x20,%edx
f01062f0:	83 fa 5e             	cmp    $0x5e,%edx
f01062f3:	76 13                	jbe    f0106308 <vprintfmt+0x21a>
					putch('?', putdat);
f01062f5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01062f8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01062fc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f0106303:	ff 55 08             	call   *0x8(%ebp)
f0106306:	eb 0d                	jmp    f0106315 <vprintfmt+0x227>
				else
					putch(ch, putdat);
f0106308:	8b 55 0c             	mov    0xc(%ebp),%edx
f010630b:	89 54 24 04          	mov    %edx,0x4(%esp)
f010630f:	89 04 24             	mov    %eax,(%esp)
f0106312:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0106315:	83 ef 01             	sub    $0x1,%edi
f0106318:	eb 1a                	jmp    f0106334 <vprintfmt+0x246>
f010631a:	89 7d 0c             	mov    %edi,0xc(%ebp)
f010631d:	8b 7d dc             	mov    -0x24(%ebp),%edi
f0106320:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0106323:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0106326:	eb 0c                	jmp    f0106334 <vprintfmt+0x246>
f0106328:	89 7d 0c             	mov    %edi,0xc(%ebp)
f010632b:	8b 7d dc             	mov    -0x24(%ebp),%edi
f010632e:	89 5d 10             	mov    %ebx,0x10(%ebp)
f0106331:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0106334:	83 c6 01             	add    $0x1,%esi
f0106337:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
f010633b:	0f be c2             	movsbl %dl,%eax
f010633e:	85 c0                	test   %eax,%eax
f0106340:	74 27                	je     f0106369 <vprintfmt+0x27b>
f0106342:	85 db                	test   %ebx,%ebx
f0106344:	78 9e                	js     f01062e4 <vprintfmt+0x1f6>
f0106346:	83 eb 01             	sub    $0x1,%ebx
f0106349:	79 99                	jns    f01062e4 <vprintfmt+0x1f6>
f010634b:	89 f8                	mov    %edi,%eax
f010634d:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0106350:	8b 75 08             	mov    0x8(%ebp),%esi
f0106353:	89 c3                	mov    %eax,%ebx
f0106355:	eb 1a                	jmp    f0106371 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f0106357:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010635b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0106362:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0106364:	83 eb 01             	sub    $0x1,%ebx
f0106367:	eb 08                	jmp    f0106371 <vprintfmt+0x283>
f0106369:	89 fb                	mov    %edi,%ebx
f010636b:	8b 75 08             	mov    0x8(%ebp),%esi
f010636e:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0106371:	85 db                	test   %ebx,%ebx
f0106373:	7f e2                	jg     f0106357 <vprintfmt+0x269>
f0106375:	89 75 08             	mov    %esi,0x8(%ebp)
f0106378:	8b 5d 10             	mov    0x10(%ebp),%ebx
f010637b:	e9 93 fd ff ff       	jmp    f0106113 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f0106380:	83 fa 01             	cmp    $0x1,%edx
f0106383:	7e 16                	jle    f010639b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
f0106385:	8b 45 14             	mov    0x14(%ebp),%eax
f0106388:	8d 50 08             	lea    0x8(%eax),%edx
f010638b:	89 55 14             	mov    %edx,0x14(%ebp)
f010638e:	8b 50 04             	mov    0x4(%eax),%edx
f0106391:	8b 00                	mov    (%eax),%eax
f0106393:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0106396:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0106399:	eb 32                	jmp    f01063cd <vprintfmt+0x2df>
	else if (lflag)
f010639b:	85 d2                	test   %edx,%edx
f010639d:	74 18                	je     f01063b7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
f010639f:	8b 45 14             	mov    0x14(%ebp),%eax
f01063a2:	8d 50 04             	lea    0x4(%eax),%edx
f01063a5:	89 55 14             	mov    %edx,0x14(%ebp)
f01063a8:	8b 30                	mov    (%eax),%esi
f01063aa:	89 75 e0             	mov    %esi,-0x20(%ebp)
f01063ad:	89 f0                	mov    %esi,%eax
f01063af:	c1 f8 1f             	sar    $0x1f,%eax
f01063b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01063b5:	eb 16                	jmp    f01063cd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
f01063b7:	8b 45 14             	mov    0x14(%ebp),%eax
f01063ba:	8d 50 04             	lea    0x4(%eax),%edx
f01063bd:	89 55 14             	mov    %edx,0x14(%ebp)
f01063c0:	8b 30                	mov    (%eax),%esi
f01063c2:	89 75 e0             	mov    %esi,-0x20(%ebp)
f01063c5:	89 f0                	mov    %esi,%eax
f01063c7:	c1 f8 1f             	sar    $0x1f,%eax
f01063ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
f01063cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01063d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
f01063d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
f01063d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01063dc:	0f 89 80 00 00 00    	jns    f0106462 <vprintfmt+0x374>
				putch('-', putdat);
f01063e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01063e6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f01063ed:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
f01063f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01063f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01063f6:	f7 d8                	neg    %eax
f01063f8:	83 d2 00             	adc    $0x0,%edx
f01063fb:	f7 da                	neg    %edx
			}
			base = 10;
f01063fd:	b9 0a 00 00 00       	mov    $0xa,%ecx
f0106402:	eb 5e                	jmp    f0106462 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f0106404:	8d 45 14             	lea    0x14(%ebp),%eax
f0106407:	e8 63 fc ff ff       	call   f010606f <getuint>
			base = 10;
f010640c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
f0106411:	eb 4f                	jmp    f0106462 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
f0106413:	8d 45 14             	lea    0x14(%ebp),%eax
f0106416:	e8 54 fc ff ff       	call   f010606f <getuint>
			base = 8;
f010641b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
f0106420:	eb 40                	jmp    f0106462 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
f0106422:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106426:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f010642d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
f0106430:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0106434:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f010643b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
f010643e:	8b 45 14             	mov    0x14(%ebp),%eax
f0106441:	8d 50 04             	lea    0x4(%eax),%edx
f0106444:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
f0106447:	8b 00                	mov    (%eax),%eax
f0106449:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
f010644e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
f0106453:	eb 0d                	jmp    f0106462 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f0106455:	8d 45 14             	lea    0x14(%ebp),%eax
f0106458:	e8 12 fc ff ff       	call   f010606f <getuint>
			base = 16;
f010645d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
f0106462:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
f0106466:	89 74 24 10          	mov    %esi,0x10(%esp)
f010646a:	8b 75 dc             	mov    -0x24(%ebp),%esi
f010646d:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0106471:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0106475:	89 04 24             	mov    %eax,(%esp)
f0106478:	89 54 24 04          	mov    %edx,0x4(%esp)
f010647c:	89 fa                	mov    %edi,%edx
f010647e:	8b 45 08             	mov    0x8(%ebp),%eax
f0106481:	e8 fa fa ff ff       	call   f0105f80 <printnum>
			break;
f0106486:	e9 88 fc ff ff       	jmp    f0106113 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f010648b:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010648f:	89 04 24             	mov    %eax,(%esp)
f0106492:	ff 55 08             	call   *0x8(%ebp)
			break;
f0106495:	e9 79 fc ff ff       	jmp    f0106113 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f010649a:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010649e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f01064a5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
f01064a8:	89 f3                	mov    %esi,%ebx
f01064aa:	eb 03                	jmp    f01064af <vprintfmt+0x3c1>
f01064ac:	83 eb 01             	sub    $0x1,%ebx
f01064af:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
f01064b3:	75 f7                	jne    f01064ac <vprintfmt+0x3be>
f01064b5:	e9 59 fc ff ff       	jmp    f0106113 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
f01064ba:	83 c4 3c             	add    $0x3c,%esp
f01064bd:	5b                   	pop    %ebx
f01064be:	5e                   	pop    %esi
f01064bf:	5f                   	pop    %edi
f01064c0:	5d                   	pop    %ebp
f01064c1:	c3                   	ret    

f01064c2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f01064c2:	55                   	push   %ebp
f01064c3:	89 e5                	mov    %esp,%ebp
f01064c5:	83 ec 28             	sub    $0x28,%esp
f01064c8:	8b 45 08             	mov    0x8(%ebp),%eax
f01064cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f01064ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01064d1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f01064d5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01064d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f01064df:	85 c0                	test   %eax,%eax
f01064e1:	74 30                	je     f0106513 <vsnprintf+0x51>
f01064e3:	85 d2                	test   %edx,%edx
f01064e5:	7e 2c                	jle    f0106513 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f01064e7:	8b 45 14             	mov    0x14(%ebp),%eax
f01064ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01064ee:	8b 45 10             	mov    0x10(%ebp),%eax
f01064f1:	89 44 24 08          	mov    %eax,0x8(%esp)
f01064f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
f01064f8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01064fc:	c7 04 24 a9 60 10 f0 	movl   $0xf01060a9,(%esp)
f0106503:	e8 e6 fb ff ff       	call   f01060ee <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0106508:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010650b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f010650e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0106511:	eb 05                	jmp    f0106518 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
f0106513:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
f0106518:	c9                   	leave  
f0106519:	c3                   	ret    

f010651a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f010651a:	55                   	push   %ebp
f010651b:	89 e5                	mov    %esp,%ebp
f010651d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0106520:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0106523:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106527:	8b 45 10             	mov    0x10(%ebp),%eax
f010652a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010652e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0106531:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106535:	8b 45 08             	mov    0x8(%ebp),%eax
f0106538:	89 04 24             	mov    %eax,(%esp)
f010653b:	e8 82 ff ff ff       	call   f01064c2 <vsnprintf>
	va_end(ap);

	return rc;
}
f0106540:	c9                   	leave  
f0106541:	c3                   	ret    
f0106542:	66 90                	xchg   %ax,%ax
f0106544:	66 90                	xchg   %ax,%ax
f0106546:	66 90                	xchg   %ax,%ax
f0106548:	66 90                	xchg   %ax,%ax
f010654a:	66 90                	xchg   %ax,%ax
f010654c:	66 90                	xchg   %ax,%ax
f010654e:	66 90                	xchg   %ax,%ax

f0106550 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0106550:	55                   	push   %ebp
f0106551:	89 e5                	mov    %esp,%ebp
f0106553:	57                   	push   %edi
f0106554:	56                   	push   %esi
f0106555:	53                   	push   %ebx
f0106556:	83 ec 1c             	sub    $0x1c,%esp
f0106559:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f010655c:	85 c0                	test   %eax,%eax
f010655e:	74 10                	je     f0106570 <readline+0x20>
		cprintf("%s", prompt);
f0106560:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106564:	c7 04 24 dd 92 10 f0 	movl   $0xf01092dd,(%esp)
f010656b:	e8 d2 dd ff ff       	call   f0104342 <cprintf>
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0106570:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0106577:	e8 8c a2 ff ff       	call   f0100808 <iscons>
f010657c:	89 c7                	mov    %eax,%edi
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
f010657e:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
f0106583:	e8 6f a2 ff ff       	call   f01007f7 <getchar>
f0106588:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f010658a:	85 c0                	test   %eax,%eax
f010658c:	79 25                	jns    f01065b3 <readline+0x63>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
f010658e:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
f0106593:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0106596:	0f 84 89 00 00 00    	je     f0106625 <readline+0xd5>
				cprintf("read error: %e\n", c);
f010659c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01065a0:	c7 04 24 87 9e 10 f0 	movl   $0xf0109e87,(%esp)
f01065a7:	e8 96 dd ff ff       	call   f0104342 <cprintf>
			return NULL;
f01065ac:	b8 00 00 00 00       	mov    $0x0,%eax
f01065b1:	eb 72                	jmp    f0106625 <readline+0xd5>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f01065b3:	83 f8 7f             	cmp    $0x7f,%eax
f01065b6:	74 05                	je     f01065bd <readline+0x6d>
f01065b8:	83 f8 08             	cmp    $0x8,%eax
f01065bb:	75 1a                	jne    f01065d7 <readline+0x87>
f01065bd:	85 f6                	test   %esi,%esi
f01065bf:	90                   	nop
f01065c0:	7e 15                	jle    f01065d7 <readline+0x87>
			if (echoing)
f01065c2:	85 ff                	test   %edi,%edi
f01065c4:	74 0c                	je     f01065d2 <readline+0x82>
				cputchar('\b');
f01065c6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f01065cd:	e8 15 a2 ff ff       	call   f01007e7 <cputchar>
			i--;
f01065d2:	83 ee 01             	sub    $0x1,%esi
f01065d5:	eb ac                	jmp    f0106583 <readline+0x33>
		} else if (c >= ' ' && i < BUFLEN-1) {
f01065d7:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f01065dd:	7f 1c                	jg     f01065fb <readline+0xab>
f01065df:	83 fb 1f             	cmp    $0x1f,%ebx
f01065e2:	7e 17                	jle    f01065fb <readline+0xab>
			if (echoing)
f01065e4:	85 ff                	test   %edi,%edi
f01065e6:	74 08                	je     f01065f0 <readline+0xa0>
				cputchar(c);
f01065e8:	89 1c 24             	mov    %ebx,(%esp)
f01065eb:	e8 f7 a1 ff ff       	call   f01007e7 <cputchar>
			buf[i++] = c;
f01065f0:	88 9e 80 9a 2c f0    	mov    %bl,-0xfd36580(%esi)
f01065f6:	8d 76 01             	lea    0x1(%esi),%esi
f01065f9:	eb 88                	jmp    f0106583 <readline+0x33>
		} else if (c == '\n' || c == '\r') {
f01065fb:	83 fb 0d             	cmp    $0xd,%ebx
f01065fe:	74 09                	je     f0106609 <readline+0xb9>
f0106600:	83 fb 0a             	cmp    $0xa,%ebx
f0106603:	0f 85 7a ff ff ff    	jne    f0106583 <readline+0x33>
			if (echoing)
f0106609:	85 ff                	test   %edi,%edi
f010660b:	74 0c                	je     f0106619 <readline+0xc9>
				cputchar('\n');
f010660d:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f0106614:	e8 ce a1 ff ff       	call   f01007e7 <cputchar>
			buf[i] = 0;
f0106619:	c6 86 80 9a 2c f0 00 	movb   $0x0,-0xfd36580(%esi)
			return buf;
f0106620:	b8 80 9a 2c f0       	mov    $0xf02c9a80,%eax
		}
	}
}
f0106625:	83 c4 1c             	add    $0x1c,%esp
f0106628:	5b                   	pop    %ebx
f0106629:	5e                   	pop    %esi
f010662a:	5f                   	pop    %edi
f010662b:	5d                   	pop    %ebp
f010662c:	c3                   	ret    
f010662d:	66 90                	xchg   %ax,%ax
f010662f:	90                   	nop

f0106630 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0106630:	55                   	push   %ebp
f0106631:	89 e5                	mov    %esp,%ebp
f0106633:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0106636:	b8 00 00 00 00       	mov    $0x0,%eax
f010663b:	eb 03                	jmp    f0106640 <strlen+0x10>
		n++;
f010663d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f0106640:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0106644:	75 f7                	jne    f010663d <strlen+0xd>
		n++;
	return n;
}
f0106646:	5d                   	pop    %ebp
f0106647:	c3                   	ret    

f0106648 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0106648:	55                   	push   %ebp
f0106649:	89 e5                	mov    %esp,%ebp
f010664b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010664e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0106651:	b8 00 00 00 00       	mov    $0x0,%eax
f0106656:	eb 03                	jmp    f010665b <strnlen+0x13>
		n++;
f0106658:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f010665b:	39 d0                	cmp    %edx,%eax
f010665d:	74 06                	je     f0106665 <strnlen+0x1d>
f010665f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0106663:	75 f3                	jne    f0106658 <strnlen+0x10>
		n++;
	return n;
}
f0106665:	5d                   	pop    %ebp
f0106666:	c3                   	ret    

f0106667 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0106667:	55                   	push   %ebp
f0106668:	89 e5                	mov    %esp,%ebp
f010666a:	53                   	push   %ebx
f010666b:	8b 45 08             	mov    0x8(%ebp),%eax
f010666e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0106671:	89 c2                	mov    %eax,%edx
f0106673:	83 c2 01             	add    $0x1,%edx
f0106676:	83 c1 01             	add    $0x1,%ecx
f0106679:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
f010667d:	88 5a ff             	mov    %bl,-0x1(%edx)
f0106680:	84 db                	test   %bl,%bl
f0106682:	75 ef                	jne    f0106673 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f0106684:	5b                   	pop    %ebx
f0106685:	5d                   	pop    %ebp
f0106686:	c3                   	ret    

f0106687 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0106687:	55                   	push   %ebp
f0106688:	89 e5                	mov    %esp,%ebp
f010668a:	53                   	push   %ebx
f010668b:	83 ec 08             	sub    $0x8,%esp
f010668e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0106691:	89 1c 24             	mov    %ebx,(%esp)
f0106694:	e8 97 ff ff ff       	call   f0106630 <strlen>
	strcpy(dst + len, src);
f0106699:	8b 55 0c             	mov    0xc(%ebp),%edx
f010669c:	89 54 24 04          	mov    %edx,0x4(%esp)
f01066a0:	01 d8                	add    %ebx,%eax
f01066a2:	89 04 24             	mov    %eax,(%esp)
f01066a5:	e8 bd ff ff ff       	call   f0106667 <strcpy>
	return dst;
}
f01066aa:	89 d8                	mov    %ebx,%eax
f01066ac:	83 c4 08             	add    $0x8,%esp
f01066af:	5b                   	pop    %ebx
f01066b0:	5d                   	pop    %ebp
f01066b1:	c3                   	ret    

f01066b2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f01066b2:	55                   	push   %ebp
f01066b3:	89 e5                	mov    %esp,%ebp
f01066b5:	56                   	push   %esi
f01066b6:	53                   	push   %ebx
f01066b7:	8b 75 08             	mov    0x8(%ebp),%esi
f01066ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01066bd:	89 f3                	mov    %esi,%ebx
f01066bf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01066c2:	89 f2                	mov    %esi,%edx
f01066c4:	eb 0f                	jmp    f01066d5 <strncpy+0x23>
		*dst++ = *src;
f01066c6:	83 c2 01             	add    $0x1,%edx
f01066c9:	0f b6 01             	movzbl (%ecx),%eax
f01066cc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01066cf:	80 39 01             	cmpb   $0x1,(%ecx)
f01066d2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01066d5:	39 da                	cmp    %ebx,%edx
f01066d7:	75 ed                	jne    f01066c6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f01066d9:	89 f0                	mov    %esi,%eax
f01066db:	5b                   	pop    %ebx
f01066dc:	5e                   	pop    %esi
f01066dd:	5d                   	pop    %ebp
f01066de:	c3                   	ret    

f01066df <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01066df:	55                   	push   %ebp
f01066e0:	89 e5                	mov    %esp,%ebp
f01066e2:	56                   	push   %esi
f01066e3:	53                   	push   %ebx
f01066e4:	8b 75 08             	mov    0x8(%ebp),%esi
f01066e7:	8b 55 0c             	mov    0xc(%ebp),%edx
f01066ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01066ed:	89 f0                	mov    %esi,%eax
f01066ef:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01066f3:	85 c9                	test   %ecx,%ecx
f01066f5:	75 0b                	jne    f0106702 <strlcpy+0x23>
f01066f7:	eb 1d                	jmp    f0106716 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f01066f9:	83 c0 01             	add    $0x1,%eax
f01066fc:	83 c2 01             	add    $0x1,%edx
f01066ff:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f0106702:	39 d8                	cmp    %ebx,%eax
f0106704:	74 0b                	je     f0106711 <strlcpy+0x32>
f0106706:	0f b6 0a             	movzbl (%edx),%ecx
f0106709:	84 c9                	test   %cl,%cl
f010670b:	75 ec                	jne    f01066f9 <strlcpy+0x1a>
f010670d:	89 c2                	mov    %eax,%edx
f010670f:	eb 02                	jmp    f0106713 <strlcpy+0x34>
f0106711:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
f0106713:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
f0106716:	29 f0                	sub    %esi,%eax
}
f0106718:	5b                   	pop    %ebx
f0106719:	5e                   	pop    %esi
f010671a:	5d                   	pop    %ebp
f010671b:	c3                   	ret    

f010671c <strcmp>:

int
strcmp(const char *p, const char *q)
{
f010671c:	55                   	push   %ebp
f010671d:	89 e5                	mov    %esp,%ebp
f010671f:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0106722:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0106725:	eb 06                	jmp    f010672d <strcmp+0x11>
		p++, q++;
f0106727:	83 c1 01             	add    $0x1,%ecx
f010672a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f010672d:	0f b6 01             	movzbl (%ecx),%eax
f0106730:	84 c0                	test   %al,%al
f0106732:	74 04                	je     f0106738 <strcmp+0x1c>
f0106734:	3a 02                	cmp    (%edx),%al
f0106736:	74 ef                	je     f0106727 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0106738:	0f b6 c0             	movzbl %al,%eax
f010673b:	0f b6 12             	movzbl (%edx),%edx
f010673e:	29 d0                	sub    %edx,%eax
}
f0106740:	5d                   	pop    %ebp
f0106741:	c3                   	ret    

f0106742 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0106742:	55                   	push   %ebp
f0106743:	89 e5                	mov    %esp,%ebp
f0106745:	53                   	push   %ebx
f0106746:	8b 45 08             	mov    0x8(%ebp),%eax
f0106749:	8b 55 0c             	mov    0xc(%ebp),%edx
f010674c:	89 c3                	mov    %eax,%ebx
f010674e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0106751:	eb 06                	jmp    f0106759 <strncmp+0x17>
		n--, p++, q++;
f0106753:	83 c0 01             	add    $0x1,%eax
f0106756:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f0106759:	39 d8                	cmp    %ebx,%eax
f010675b:	74 15                	je     f0106772 <strncmp+0x30>
f010675d:	0f b6 08             	movzbl (%eax),%ecx
f0106760:	84 c9                	test   %cl,%cl
f0106762:	74 04                	je     f0106768 <strncmp+0x26>
f0106764:	3a 0a                	cmp    (%edx),%cl
f0106766:	74 eb                	je     f0106753 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0106768:	0f b6 00             	movzbl (%eax),%eax
f010676b:	0f b6 12             	movzbl (%edx),%edx
f010676e:	29 d0                	sub    %edx,%eax
f0106770:	eb 05                	jmp    f0106777 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
f0106772:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f0106777:	5b                   	pop    %ebx
f0106778:	5d                   	pop    %ebp
f0106779:	c3                   	ret    

f010677a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f010677a:	55                   	push   %ebp
f010677b:	89 e5                	mov    %esp,%ebp
f010677d:	8b 45 08             	mov    0x8(%ebp),%eax
f0106780:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0106784:	eb 07                	jmp    f010678d <strchr+0x13>
		if (*s == c)
f0106786:	38 ca                	cmp    %cl,%dl
f0106788:	74 0f                	je     f0106799 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f010678a:	83 c0 01             	add    $0x1,%eax
f010678d:	0f b6 10             	movzbl (%eax),%edx
f0106790:	84 d2                	test   %dl,%dl
f0106792:	75 f2                	jne    f0106786 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
f0106794:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106799:	5d                   	pop    %ebp
f010679a:	c3                   	ret    

f010679b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010679b:	55                   	push   %ebp
f010679c:	89 e5                	mov    %esp,%ebp
f010679e:	8b 45 08             	mov    0x8(%ebp),%eax
f01067a1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f01067a5:	eb 07                	jmp    f01067ae <strfind+0x13>
		if (*s == c)
f01067a7:	38 ca                	cmp    %cl,%dl
f01067a9:	74 0a                	je     f01067b5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f01067ab:	83 c0 01             	add    $0x1,%eax
f01067ae:	0f b6 10             	movzbl (%eax),%edx
f01067b1:	84 d2                	test   %dl,%dl
f01067b3:	75 f2                	jne    f01067a7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
f01067b5:	5d                   	pop    %ebp
f01067b6:	c3                   	ret    

f01067b7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01067b7:	55                   	push   %ebp
f01067b8:	89 e5                	mov    %esp,%ebp
f01067ba:	57                   	push   %edi
f01067bb:	56                   	push   %esi
f01067bc:	53                   	push   %ebx
f01067bd:	8b 7d 08             	mov    0x8(%ebp),%edi
f01067c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01067c3:	85 c9                	test   %ecx,%ecx
f01067c5:	74 36                	je     f01067fd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01067c7:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01067cd:	75 28                	jne    f01067f7 <memset+0x40>
f01067cf:	f6 c1 03             	test   $0x3,%cl
f01067d2:	75 23                	jne    f01067f7 <memset+0x40>
		c &= 0xFF;
f01067d4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01067d8:	89 d3                	mov    %edx,%ebx
f01067da:	c1 e3 08             	shl    $0x8,%ebx
f01067dd:	89 d6                	mov    %edx,%esi
f01067df:	c1 e6 18             	shl    $0x18,%esi
f01067e2:	89 d0                	mov    %edx,%eax
f01067e4:	c1 e0 10             	shl    $0x10,%eax
f01067e7:	09 f0                	or     %esi,%eax
f01067e9:	09 c2                	or     %eax,%edx
f01067eb:	89 d0                	mov    %edx,%eax
f01067ed:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f01067ef:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
f01067f2:	fc                   	cld    
f01067f3:	f3 ab                	rep stos %eax,%es:(%edi)
f01067f5:	eb 06                	jmp    f01067fd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01067f7:	8b 45 0c             	mov    0xc(%ebp),%eax
f01067fa:	fc                   	cld    
f01067fb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01067fd:	89 f8                	mov    %edi,%eax
f01067ff:	5b                   	pop    %ebx
f0106800:	5e                   	pop    %esi
f0106801:	5f                   	pop    %edi
f0106802:	5d                   	pop    %ebp
f0106803:	c3                   	ret    

f0106804 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0106804:	55                   	push   %ebp
f0106805:	89 e5                	mov    %esp,%ebp
f0106807:	57                   	push   %edi
f0106808:	56                   	push   %esi
f0106809:	8b 45 08             	mov    0x8(%ebp),%eax
f010680c:	8b 75 0c             	mov    0xc(%ebp),%esi
f010680f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0106812:	39 c6                	cmp    %eax,%esi
f0106814:	73 35                	jae    f010684b <memmove+0x47>
f0106816:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0106819:	39 d0                	cmp    %edx,%eax
f010681b:	73 2e                	jae    f010684b <memmove+0x47>
		s += n;
		d += n;
f010681d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
f0106820:	89 d6                	mov    %edx,%esi
f0106822:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0106824:	f7 c6 03 00 00 00    	test   $0x3,%esi
f010682a:	75 13                	jne    f010683f <memmove+0x3b>
f010682c:	f6 c1 03             	test   $0x3,%cl
f010682f:	75 0e                	jne    f010683f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0106831:	83 ef 04             	sub    $0x4,%edi
f0106834:	8d 72 fc             	lea    -0x4(%edx),%esi
f0106837:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
f010683a:	fd                   	std    
f010683b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f010683d:	eb 09                	jmp    f0106848 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f010683f:	83 ef 01             	sub    $0x1,%edi
f0106842:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f0106845:	fd                   	std    
f0106846:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0106848:	fc                   	cld    
f0106849:	eb 1d                	jmp    f0106868 <memmove+0x64>
f010684b:	89 f2                	mov    %esi,%edx
f010684d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010684f:	f6 c2 03             	test   $0x3,%dl
f0106852:	75 0f                	jne    f0106863 <memmove+0x5f>
f0106854:	f6 c1 03             	test   $0x3,%cl
f0106857:	75 0a                	jne    f0106863 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0106859:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
f010685c:	89 c7                	mov    %eax,%edi
f010685e:	fc                   	cld    
f010685f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0106861:	eb 05                	jmp    f0106868 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0106863:	89 c7                	mov    %eax,%edi
f0106865:	fc                   	cld    
f0106866:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0106868:	5e                   	pop    %esi
f0106869:	5f                   	pop    %edi
f010686a:	5d                   	pop    %ebp
f010686b:	c3                   	ret    

f010686c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f010686c:	55                   	push   %ebp
f010686d:	89 e5                	mov    %esp,%ebp
f010686f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0106872:	8b 45 10             	mov    0x10(%ebp),%eax
f0106875:	89 44 24 08          	mov    %eax,0x8(%esp)
f0106879:	8b 45 0c             	mov    0xc(%ebp),%eax
f010687c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106880:	8b 45 08             	mov    0x8(%ebp),%eax
f0106883:	89 04 24             	mov    %eax,(%esp)
f0106886:	e8 79 ff ff ff       	call   f0106804 <memmove>
}
f010688b:	c9                   	leave  
f010688c:	c3                   	ret    

f010688d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f010688d:	55                   	push   %ebp
f010688e:	89 e5                	mov    %esp,%ebp
f0106890:	56                   	push   %esi
f0106891:	53                   	push   %ebx
f0106892:	8b 55 08             	mov    0x8(%ebp),%edx
f0106895:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0106898:	89 d6                	mov    %edx,%esi
f010689a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010689d:	eb 1a                	jmp    f01068b9 <memcmp+0x2c>
		if (*s1 != *s2)
f010689f:	0f b6 02             	movzbl (%edx),%eax
f01068a2:	0f b6 19             	movzbl (%ecx),%ebx
f01068a5:	38 d8                	cmp    %bl,%al
f01068a7:	74 0a                	je     f01068b3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
f01068a9:	0f b6 c0             	movzbl %al,%eax
f01068ac:	0f b6 db             	movzbl %bl,%ebx
f01068af:	29 d8                	sub    %ebx,%eax
f01068b1:	eb 0f                	jmp    f01068c2 <memcmp+0x35>
		s1++, s2++;
f01068b3:	83 c2 01             	add    $0x1,%edx
f01068b6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01068b9:	39 f2                	cmp    %esi,%edx
f01068bb:	75 e2                	jne    f010689f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
f01068bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01068c2:	5b                   	pop    %ebx
f01068c3:	5e                   	pop    %esi
f01068c4:	5d                   	pop    %ebp
f01068c5:	c3                   	ret    

f01068c6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01068c6:	55                   	push   %ebp
f01068c7:	89 e5                	mov    %esp,%ebp
f01068c9:	8b 45 08             	mov    0x8(%ebp),%eax
f01068cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f01068cf:	89 c2                	mov    %eax,%edx
f01068d1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01068d4:	eb 07                	jmp    f01068dd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
f01068d6:	38 08                	cmp    %cl,(%eax)
f01068d8:	74 07                	je     f01068e1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f01068da:	83 c0 01             	add    $0x1,%eax
f01068dd:	39 d0                	cmp    %edx,%eax
f01068df:	72 f5                	jb     f01068d6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f01068e1:	5d                   	pop    %ebp
f01068e2:	c3                   	ret    

f01068e3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01068e3:	55                   	push   %ebp
f01068e4:	89 e5                	mov    %esp,%ebp
f01068e6:	57                   	push   %edi
f01068e7:	56                   	push   %esi
f01068e8:	53                   	push   %ebx
f01068e9:	8b 55 08             	mov    0x8(%ebp),%edx
f01068ec:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01068ef:	eb 03                	jmp    f01068f4 <strtol+0x11>
		s++;
f01068f1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f01068f4:	0f b6 0a             	movzbl (%edx),%ecx
f01068f7:	80 f9 09             	cmp    $0x9,%cl
f01068fa:	74 f5                	je     f01068f1 <strtol+0xe>
f01068fc:	80 f9 20             	cmp    $0x20,%cl
f01068ff:	74 f0                	je     f01068f1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
f0106901:	80 f9 2b             	cmp    $0x2b,%cl
f0106904:	75 0a                	jne    f0106910 <strtol+0x2d>
		s++;
f0106906:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
f0106909:	bf 00 00 00 00       	mov    $0x0,%edi
f010690e:	eb 11                	jmp    f0106921 <strtol+0x3e>
f0106910:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
f0106915:	80 f9 2d             	cmp    $0x2d,%cl
f0106918:	75 07                	jne    f0106921 <strtol+0x3e>
		s++, neg = 1;
f010691a:	8d 52 01             	lea    0x1(%edx),%edx
f010691d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0106921:	a9 ef ff ff ff       	test   $0xffffffef,%eax
f0106926:	75 15                	jne    f010693d <strtol+0x5a>
f0106928:	80 3a 30             	cmpb   $0x30,(%edx)
f010692b:	75 10                	jne    f010693d <strtol+0x5a>
f010692d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f0106931:	75 0a                	jne    f010693d <strtol+0x5a>
		s += 2, base = 16;
f0106933:	83 c2 02             	add    $0x2,%edx
f0106936:	b8 10 00 00 00       	mov    $0x10,%eax
f010693b:	eb 10                	jmp    f010694d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
f010693d:	85 c0                	test   %eax,%eax
f010693f:	75 0c                	jne    f010694d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0106941:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0106943:	80 3a 30             	cmpb   $0x30,(%edx)
f0106946:	75 05                	jne    f010694d <strtol+0x6a>
		s++, base = 8;
f0106948:	83 c2 01             	add    $0x1,%edx
f010694b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
f010694d:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106952:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0106955:	0f b6 0a             	movzbl (%edx),%ecx
f0106958:	8d 71 d0             	lea    -0x30(%ecx),%esi
f010695b:	89 f0                	mov    %esi,%eax
f010695d:	3c 09                	cmp    $0x9,%al
f010695f:	77 08                	ja     f0106969 <strtol+0x86>
			dig = *s - '0';
f0106961:	0f be c9             	movsbl %cl,%ecx
f0106964:	83 e9 30             	sub    $0x30,%ecx
f0106967:	eb 20                	jmp    f0106989 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
f0106969:	8d 71 9f             	lea    -0x61(%ecx),%esi
f010696c:	89 f0                	mov    %esi,%eax
f010696e:	3c 19                	cmp    $0x19,%al
f0106970:	77 08                	ja     f010697a <strtol+0x97>
			dig = *s - 'a' + 10;
f0106972:	0f be c9             	movsbl %cl,%ecx
f0106975:	83 e9 57             	sub    $0x57,%ecx
f0106978:	eb 0f                	jmp    f0106989 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
f010697a:	8d 71 bf             	lea    -0x41(%ecx),%esi
f010697d:	89 f0                	mov    %esi,%eax
f010697f:	3c 19                	cmp    $0x19,%al
f0106981:	77 16                	ja     f0106999 <strtol+0xb6>
			dig = *s - 'A' + 10;
f0106983:	0f be c9             	movsbl %cl,%ecx
f0106986:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f0106989:	3b 4d 10             	cmp    0x10(%ebp),%ecx
f010698c:	7d 0f                	jge    f010699d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
f010698e:	83 c2 01             	add    $0x1,%edx
f0106991:	0f af 5d 10          	imul   0x10(%ebp),%ebx
f0106995:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
f0106997:	eb bc                	jmp    f0106955 <strtol+0x72>
f0106999:	89 d8                	mov    %ebx,%eax
f010699b:	eb 02                	jmp    f010699f <strtol+0xbc>
f010699d:	89 d8                	mov    %ebx,%eax

	if (endptr)
f010699f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01069a3:	74 05                	je     f01069aa <strtol+0xc7>
		*endptr = (char *) s;
f01069a5:	8b 75 0c             	mov    0xc(%ebp),%esi
f01069a8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
f01069aa:	f7 d8                	neg    %eax
f01069ac:	85 ff                	test   %edi,%edi
f01069ae:	0f 44 c3             	cmove  %ebx,%eax
}
f01069b1:	5b                   	pop    %ebx
f01069b2:	5e                   	pop    %esi
f01069b3:	5f                   	pop    %edi
f01069b4:	5d                   	pop    %ebp
f01069b5:	c3                   	ret    
f01069b6:	66 90                	xchg   %ax,%ax

f01069b8 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f01069b8:	fa                   	cli    

	xorw    %ax, %ax
f01069b9:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f01069bb:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01069bd:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01069bf:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f01069c1:	0f 01 16             	lgdtl  (%esi)
f01069c4:	74 70                	je     f0106a36 <mpentry_end+0x4>
	movl    %cr0, %eax
f01069c6:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f01069c9:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f01069cd:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f01069d0:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f01069d6:	08 00                	or     %al,(%eax)

f01069d8 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f01069d8:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f01069dc:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f01069de:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f01069e0:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f01069e2:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f01069e6:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f01069e8:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f01069ea:	b8 00 40 12 00       	mov    $0x124000,%eax
	movl    %eax, %cr3
f01069ef:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f01069f2:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f01069f5:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f01069fa:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f01069fd:	8b 25 90 9e 2c f0    	mov    0xf02c9e90,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0106a03:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0106a08:	b8 1a 02 10 f0       	mov    $0xf010021a,%eax
	call    *%eax
f0106a0d:	ff d0                	call   *%eax

f0106a0f <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0106a0f:	eb fe                	jmp    f0106a0f <spin>
f0106a11:	8d 76 00             	lea    0x0(%esi),%esi

f0106a14 <gdt>:
	...
f0106a1c:	ff                   	(bad)  
f0106a1d:	ff 00                	incl   (%eax)
f0106a1f:	00 00                	add    %al,(%eax)
f0106a21:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0106a28:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

f0106a2c <gdtdesc>:
f0106a2c:	17                   	pop    %ss
f0106a2d:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0106a32 <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0106a32:	90                   	nop
f0106a33:	66 90                	xchg   %ax,%ax
f0106a35:	66 90                	xchg   %ax,%ax
f0106a37:	66 90                	xchg   %ax,%ax
f0106a39:	66 90                	xchg   %ax,%ax
f0106a3b:	66 90                	xchg   %ax,%ax
f0106a3d:	66 90                	xchg   %ax,%ax
f0106a3f:	90                   	nop

f0106a40 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0106a40:	55                   	push   %ebp
f0106a41:	89 e5                	mov    %esp,%ebp
f0106a43:	56                   	push   %esi
f0106a44:	53                   	push   %ebx
f0106a45:	83 ec 10             	sub    $0x10,%esp
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106a48:	8b 0d 94 9e 2c f0    	mov    0xf02c9e94,%ecx
f0106a4e:	89 c3                	mov    %eax,%ebx
f0106a50:	c1 eb 0c             	shr    $0xc,%ebx
f0106a53:	39 cb                	cmp    %ecx,%ebx
f0106a55:	72 20                	jb     f0106a77 <mpsearch1+0x37>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106a57:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106a5b:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0106a62:	f0 
f0106a63:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
f0106a6a:	00 
f0106a6b:	c7 04 24 25 a0 10 f0 	movl   $0xf010a025,(%esp)
f0106a72:	e8 c9 95 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0106a77:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0106a7d:	01 d0                	add    %edx,%eax
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106a7f:	89 c2                	mov    %eax,%edx
f0106a81:	c1 ea 0c             	shr    $0xc,%edx
f0106a84:	39 d1                	cmp    %edx,%ecx
f0106a86:	77 20                	ja     f0106aa8 <mpsearch1+0x68>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106a88:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0106a8c:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0106a93:	f0 
f0106a94:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
f0106a9b:	00 
f0106a9c:	c7 04 24 25 a0 10 f0 	movl   $0xf010a025,(%esp)
f0106aa3:	e8 98 95 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0106aa8:	8d b0 00 00 00 f0    	lea    -0x10000000(%eax),%esi

	for (; mp < end; mp++)
f0106aae:	eb 36                	jmp    f0106ae6 <mpsearch1+0xa6>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106ab0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0106ab7:	00 
f0106ab8:	c7 44 24 04 35 a0 10 	movl   $0xf010a035,0x4(%esp)
f0106abf:	f0 
f0106ac0:	89 1c 24             	mov    %ebx,(%esp)
f0106ac3:	e8 c5 fd ff ff       	call   f010688d <memcmp>
f0106ac8:	85 c0                	test   %eax,%eax
f0106aca:	75 17                	jne    f0106ae3 <mpsearch1+0xa3>
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0106acc:	ba 00 00 00 00       	mov    $0x0,%edx
		sum += ((uint8_t *)addr)[i];
f0106ad1:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0106ad5:	01 c8                	add    %ecx,%eax
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0106ad7:	83 c2 01             	add    $0x1,%edx
f0106ada:	83 fa 10             	cmp    $0x10,%edx
f0106add:	75 f2                	jne    f0106ad1 <mpsearch1+0x91>
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0106adf:	84 c0                	test   %al,%al
f0106ae1:	74 0e                	je     f0106af1 <mpsearch1+0xb1>
static struct mp *
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
f0106ae3:	83 c3 10             	add    $0x10,%ebx
f0106ae6:	39 f3                	cmp    %esi,%ebx
f0106ae8:	72 c6                	jb     f0106ab0 <mpsearch1+0x70>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0106aea:	b8 00 00 00 00       	mov    $0x0,%eax
f0106aef:	eb 02                	jmp    f0106af3 <mpsearch1+0xb3>
f0106af1:	89 d8                	mov    %ebx,%eax
}
f0106af3:	83 c4 10             	add    $0x10,%esp
f0106af6:	5b                   	pop    %ebx
f0106af7:	5e                   	pop    %esi
f0106af8:	5d                   	pop    %ebp
f0106af9:	c3                   	ret    

f0106afa <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0106afa:	55                   	push   %ebp
f0106afb:	89 e5                	mov    %esp,%ebp
f0106afd:	57                   	push   %edi
f0106afe:	56                   	push   %esi
f0106aff:	53                   	push   %ebx
f0106b00:	83 ec 2c             	sub    $0x2c,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0106b03:	c7 05 c0 a3 2c f0 20 	movl   $0xf02ca020,0xf02ca3c0
f0106b0a:	a0 2c f0 
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106b0d:	83 3d 94 9e 2c f0 00 	cmpl   $0x0,0xf02c9e94
f0106b14:	75 24                	jne    f0106b3a <mp_init+0x40>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106b16:	c7 44 24 0c 00 04 00 	movl   $0x400,0xc(%esp)
f0106b1d:	00 
f0106b1e:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0106b25:	f0 
f0106b26:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
f0106b2d:	00 
f0106b2e:	c7 04 24 25 a0 10 f0 	movl   $0xf010a025,(%esp)
f0106b35:	e8 06 95 ff ff       	call   f0100040 <_panic>
	// The BIOS data area lives in 16-bit segment 0x40.
	bda = (uint8_t *) KADDR(0x40 << 4);

	// [MP 4] The 16-bit segment of the EBDA is in the two bytes
	// starting at byte 0x0E of the BDA.  0 if not present.
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0106b3a:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
f0106b41:	85 c0                	test   %eax,%eax
f0106b43:	74 16                	je     f0106b5b <mp_init+0x61>
		p <<= 4;	// Translate from segment to PA
f0106b45:	c1 e0 04             	shl    $0x4,%eax
		if ((mp = mpsearch1(p, 1024)))
f0106b48:	ba 00 04 00 00       	mov    $0x400,%edx
f0106b4d:	e8 ee fe ff ff       	call   f0106a40 <mpsearch1>
f0106b52:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106b55:	85 c0                	test   %eax,%eax
f0106b57:	75 3c                	jne    f0106b95 <mp_init+0x9b>
f0106b59:	eb 20                	jmp    f0106b7b <mp_init+0x81>
			return mp;
	} else {
		// The size of base memory, in KB is in the two bytes
		// starting at 0x13 of the BDA.
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0106b5b:	0f b7 05 13 04 00 f0 	movzwl 0xf0000413,%eax
f0106b62:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0106b65:	2d 00 04 00 00       	sub    $0x400,%eax
f0106b6a:	ba 00 04 00 00       	mov    $0x400,%edx
f0106b6f:	e8 cc fe ff ff       	call   f0106a40 <mpsearch1>
f0106b74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0106b77:	85 c0                	test   %eax,%eax
f0106b79:	75 1a                	jne    f0106b95 <mp_init+0x9b>
			return mp;
	}
	return mpsearch1(0xF0000, 0x10000);
f0106b7b:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106b80:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0106b85:	e8 b6 fe ff ff       	call   f0106a40 <mpsearch1>
f0106b8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
	struct mpconf *conf;
	struct mp *mp;

	if ((mp = mpsearch()) == 0)
f0106b8d:	85 c0                	test   %eax,%eax
f0106b8f:	0f 84 54 02 00 00    	je     f0106de9 <mp_init+0x2ef>
		return NULL;
	if (mp->physaddr == 0 || mp->type != 0) {
f0106b95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106b98:	8b 70 04             	mov    0x4(%eax),%esi
f0106b9b:	85 f6                	test   %esi,%esi
f0106b9d:	74 06                	je     f0106ba5 <mp_init+0xab>
f0106b9f:	80 78 0b 00          	cmpb   $0x0,0xb(%eax)
f0106ba3:	74 11                	je     f0106bb6 <mp_init+0xbc>
		cprintf("SMP: Default configurations not implemented\n");
f0106ba5:	c7 04 24 98 9e 10 f0 	movl   $0xf0109e98,(%esp)
f0106bac:	e8 91 d7 ff ff       	call   f0104342 <cprintf>
f0106bb1:	e9 33 02 00 00       	jmp    f0106de9 <mp_init+0x2ef>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106bb6:	89 f0                	mov    %esi,%eax
f0106bb8:	c1 e8 0c             	shr    $0xc,%eax
f0106bbb:	3b 05 94 9e 2c f0    	cmp    0xf02c9e94,%eax
f0106bc1:	72 20                	jb     f0106be3 <mp_init+0xe9>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106bc3:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0106bc7:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0106bce:	f0 
f0106bcf:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
f0106bd6:	00 
f0106bd7:	c7 04 24 25 a0 10 f0 	movl   $0xf010a025,(%esp)
f0106bde:	e8 5d 94 ff ff       	call   f0100040 <_panic>
	return (void *)(pa + KERNBASE);
f0106be3:	8d 9e 00 00 00 f0    	lea    -0x10000000(%esi),%ebx
		return NULL;
	}
	conf = (struct mpconf *) KADDR(mp->physaddr);
	if (memcmp(conf, "PCMP", 4) != 0) {
f0106be9:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0106bf0:	00 
f0106bf1:	c7 44 24 04 3a a0 10 	movl   $0xf010a03a,0x4(%esp)
f0106bf8:	f0 
f0106bf9:	89 1c 24             	mov    %ebx,(%esp)
f0106bfc:	e8 8c fc ff ff       	call   f010688d <memcmp>
f0106c01:	85 c0                	test   %eax,%eax
f0106c03:	74 11                	je     f0106c16 <mp_init+0x11c>
		cprintf("SMP: Incorrect MP configuration table signature\n");
f0106c05:	c7 04 24 c8 9e 10 f0 	movl   $0xf0109ec8,(%esp)
f0106c0c:	e8 31 d7 ff ff       	call   f0104342 <cprintf>
f0106c11:	e9 d3 01 00 00       	jmp    f0106de9 <mp_init+0x2ef>
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f0106c16:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
f0106c1a:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
f0106c1e:	0f b7 f8             	movzwl %ax,%edi
static uint8_t
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
f0106c21:	ba 00 00 00 00       	mov    $0x0,%edx
	for (i = 0; i < len; i++)
f0106c26:	b8 00 00 00 00       	mov    $0x0,%eax
f0106c2b:	eb 0d                	jmp    f0106c3a <mp_init+0x140>
		sum += ((uint8_t *)addr)[i];
f0106c2d:	0f b6 8c 30 00 00 00 	movzbl -0x10000000(%eax,%esi,1),%ecx
f0106c34:	f0 
f0106c35:	01 ca                	add    %ecx,%edx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0106c37:	83 c0 01             	add    $0x1,%eax
f0106c3a:	39 c7                	cmp    %eax,%edi
f0106c3c:	7f ef                	jg     f0106c2d <mp_init+0x133>
	conf = (struct mpconf *) KADDR(mp->physaddr);
	if (memcmp(conf, "PCMP", 4) != 0) {
		cprintf("SMP: Incorrect MP configuration table signature\n");
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f0106c3e:	84 d2                	test   %dl,%dl
f0106c40:	74 11                	je     f0106c53 <mp_init+0x159>
		cprintf("SMP: Bad MP configuration checksum\n");
f0106c42:	c7 04 24 fc 9e 10 f0 	movl   $0xf0109efc,(%esp)
f0106c49:	e8 f4 d6 ff ff       	call   f0104342 <cprintf>
f0106c4e:	e9 96 01 00 00       	jmp    f0106de9 <mp_init+0x2ef>
		return NULL;
	}
	if (conf->version != 1 && conf->version != 4) {
f0106c53:	0f b6 43 06          	movzbl 0x6(%ebx),%eax
f0106c57:	3c 04                	cmp    $0x4,%al
f0106c59:	74 1f                	je     f0106c7a <mp_init+0x180>
f0106c5b:	3c 01                	cmp    $0x1,%al
f0106c5d:	8d 76 00             	lea    0x0(%esi),%esi
f0106c60:	74 18                	je     f0106c7a <mp_init+0x180>
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
f0106c62:	0f b6 c0             	movzbl %al,%eax
f0106c65:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106c69:	c7 04 24 20 9f 10 f0 	movl   $0xf0109f20,(%esp)
f0106c70:	e8 cd d6 ff ff       	call   f0104342 <cprintf>
f0106c75:	e9 6f 01 00 00       	jmp    f0106de9 <mp_init+0x2ef>
		return NULL;
	}
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0106c7a:	0f b7 73 28          	movzwl 0x28(%ebx),%esi
f0106c7e:	0f b7 7d e2          	movzwl -0x1e(%ebp),%edi
f0106c82:	01 df                	add    %ebx,%edi
static uint8_t
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
f0106c84:	ba 00 00 00 00       	mov    $0x0,%edx
	for (i = 0; i < len; i++)
f0106c89:	b8 00 00 00 00       	mov    $0x0,%eax
f0106c8e:	eb 09                	jmp    f0106c99 <mp_init+0x19f>
		sum += ((uint8_t *)addr)[i];
f0106c90:	0f b6 0c 07          	movzbl (%edi,%eax,1),%ecx
f0106c94:	01 ca                	add    %ecx,%edx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0106c96:	83 c0 01             	add    $0x1,%eax
f0106c99:	39 c6                	cmp    %eax,%esi
f0106c9b:	7f f3                	jg     f0106c90 <mp_init+0x196>
	}
	if (conf->version != 1 && conf->version != 4) {
		cprintf("SMP: Unsupported MP version %d\n", conf->version);
		return NULL;
	}
	if ((sum((uint8_t *)conf + conf->length, conf->xlength) + conf->xchecksum) & 0xff) {
f0106c9d:	02 53 2a             	add    0x2a(%ebx),%dl
f0106ca0:	84 d2                	test   %dl,%dl
f0106ca2:	74 11                	je     f0106cb5 <mp_init+0x1bb>
		cprintf("SMP: Bad MP configuration extended checksum\n");
f0106ca4:	c7 04 24 40 9f 10 f0 	movl   $0xf0109f40,(%esp)
f0106cab:	e8 92 d6 ff ff       	call   f0104342 <cprintf>
f0106cb0:	e9 34 01 00 00       	jmp    f0106de9 <mp_init+0x2ef>
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
	if ((conf = mpconfig(&mp)) == 0)
f0106cb5:	85 db                	test   %ebx,%ebx
f0106cb7:	0f 84 2c 01 00 00    	je     f0106de9 <mp_init+0x2ef>
		return;
	ismp = 1;
f0106cbd:	c7 05 00 a0 2c f0 01 	movl   $0x1,0xf02ca000
f0106cc4:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0106cc7:	8b 43 24             	mov    0x24(%ebx),%eax
f0106cca:	a3 00 b0 30 f0       	mov    %eax,0xf030b000

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106ccf:	8d 7b 2c             	lea    0x2c(%ebx),%edi
f0106cd2:	be 00 00 00 00       	mov    $0x0,%esi
f0106cd7:	e9 86 00 00 00       	jmp    f0106d62 <mp_init+0x268>
		switch (*p) {
f0106cdc:	0f b6 07             	movzbl (%edi),%eax
f0106cdf:	84 c0                	test   %al,%al
f0106ce1:	74 06                	je     f0106ce9 <mp_init+0x1ef>
f0106ce3:	3c 04                	cmp    $0x4,%al
f0106ce5:	77 57                	ja     f0106d3e <mp_init+0x244>
f0106ce7:	eb 50                	jmp    f0106d39 <mp_init+0x23f>
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0106ce9:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0106ced:	8d 76 00             	lea    0x0(%esi),%esi
f0106cf0:	74 11                	je     f0106d03 <mp_init+0x209>
				bootcpu = &cpus[ncpu];
f0106cf2:	6b 05 c4 a3 2c f0 74 	imul   $0x74,0xf02ca3c4,%eax
f0106cf9:	05 20 a0 2c f0       	add    $0xf02ca020,%eax
f0106cfe:	a3 c0 a3 2c f0       	mov    %eax,0xf02ca3c0
			if (ncpu < NCPU) {
f0106d03:	a1 c4 a3 2c f0       	mov    0xf02ca3c4,%eax
f0106d08:	83 f8 07             	cmp    $0x7,%eax
f0106d0b:	7f 13                	jg     f0106d20 <mp_init+0x226>
				cpus[ncpu].cpu_id = ncpu;
f0106d0d:	6b d0 74             	imul   $0x74,%eax,%edx
f0106d10:	88 82 20 a0 2c f0    	mov    %al,-0xfd35fe0(%edx)
				ncpu++;
f0106d16:	83 c0 01             	add    $0x1,%eax
f0106d19:	a3 c4 a3 2c f0       	mov    %eax,0xf02ca3c4
f0106d1e:	eb 14                	jmp    f0106d34 <mp_init+0x23a>
			} else {
				cprintf("SMP: too many CPUs, CPU %d disabled\n",
f0106d20:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f0106d24:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106d28:	c7 04 24 70 9f 10 f0 	movl   $0xf0109f70,(%esp)
f0106d2f:	e8 0e d6 ff ff       	call   f0104342 <cprintf>
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f0106d34:	83 c7 14             	add    $0x14,%edi
			continue;
f0106d37:	eb 26                	jmp    f0106d5f <mp_init+0x265>
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0106d39:	83 c7 08             	add    $0x8,%edi
			continue;
f0106d3c:	eb 21                	jmp    f0106d5f <mp_init+0x265>
		default:
			cprintf("mpinit: unknown config type %x\n", *p);
f0106d3e:	0f b6 c0             	movzbl %al,%eax
f0106d41:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106d45:	c7 04 24 98 9f 10 f0 	movl   $0xf0109f98,(%esp)
f0106d4c:	e8 f1 d5 ff ff       	call   f0104342 <cprintf>
			ismp = 0;
f0106d51:	c7 05 00 a0 2c f0 00 	movl   $0x0,0xf02ca000
f0106d58:	00 00 00 
			i = conf->entry;
f0106d5b:	0f b7 73 22          	movzwl 0x22(%ebx),%esi
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
	lapicaddr = conf->lapicaddr;

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0106d5f:	83 c6 01             	add    $0x1,%esi
f0106d62:	0f b7 43 22          	movzwl 0x22(%ebx),%eax
f0106d66:	39 c6                	cmp    %eax,%esi
f0106d68:	0f 82 6e ff ff ff    	jb     f0106cdc <mp_init+0x1e2>
			ismp = 0;
			i = conf->entry;
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0106d6e:	a1 c0 a3 2c f0       	mov    0xf02ca3c0,%eax
f0106d73:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0106d7a:	83 3d 00 a0 2c f0 00 	cmpl   $0x0,0xf02ca000
f0106d81:	75 22                	jne    f0106da5 <mp_init+0x2ab>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f0106d83:	c7 05 c4 a3 2c f0 01 	movl   $0x1,0xf02ca3c4
f0106d8a:	00 00 00 
		lapicaddr = 0;
f0106d8d:	c7 05 00 b0 30 f0 00 	movl   $0x0,0xf030b000
f0106d94:	00 00 00 
		cprintf("SMP: configuration not found, SMP disabled\n");
f0106d97:	c7 04 24 b8 9f 10 f0 	movl   $0xf0109fb8,(%esp)
f0106d9e:	e8 9f d5 ff ff       	call   f0104342 <cprintf>
		return;
f0106da3:	eb 44                	jmp    f0106de9 <mp_init+0x2ef>
	}
	cprintf("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f0106da5:	8b 15 c4 a3 2c f0    	mov    0xf02ca3c4,%edx
f0106dab:	89 54 24 08          	mov    %edx,0x8(%esp)
f0106daf:	0f b6 00             	movzbl (%eax),%eax
f0106db2:	89 44 24 04          	mov    %eax,0x4(%esp)
f0106db6:	c7 04 24 3f a0 10 f0 	movl   $0xf010a03f,(%esp)
f0106dbd:	e8 80 d5 ff ff       	call   f0104342 <cprintf>

	if (mp->imcrp) {
f0106dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0106dc5:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
f0106dc9:	74 1e                	je     f0106de9 <mp_init+0x2ef>
		// [MP 3.2.6.1] If the hardware implements PIC mode,
		// switch to getting interrupts from the LAPIC.
		cprintf("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f0106dcb:	c7 04 24 e4 9f 10 f0 	movl   $0xf0109fe4,(%esp)
f0106dd2:	e8 6b d5 ff ff       	call   f0104342 <cprintf>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106dd7:	ba 22 00 00 00       	mov    $0x22,%edx
f0106ddc:	b8 70 00 00 00       	mov    $0x70,%eax
f0106de1:	ee                   	out    %al,(%dx)

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0106de2:	b2 23                	mov    $0x23,%dl
f0106de4:	ec                   	in     (%dx),%al
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f0106de5:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106de8:	ee                   	out    %al,(%dx)
	}
}
f0106de9:	83 c4 2c             	add    $0x2c,%esp
f0106dec:	5b                   	pop    %ebx
f0106ded:	5e                   	pop    %esi
f0106dee:	5f                   	pop    %edi
f0106def:	5d                   	pop    %ebp
f0106df0:	c3                   	ret    

f0106df1 <lapicw>:
physaddr_t lapicaddr;        // Initialized in mpconfig.c
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
f0106df1:	55                   	push   %ebp
f0106df2:	89 e5                	mov    %esp,%ebp
	lapic[index] = value;
f0106df4:	8b 0d 04 b0 30 f0    	mov    0xf030b004,%ecx
f0106dfa:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0106dfd:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0106dff:	a1 04 b0 30 f0       	mov    0xf030b004,%eax
f0106e04:	8b 40 20             	mov    0x20(%eax),%eax
}
f0106e07:	5d                   	pop    %ebp
f0106e08:	c3                   	ret    

f0106e09 <cpunum>:
	lapicw(TPR, 0);
}

int
cpunum(void)
{
f0106e09:	55                   	push   %ebp
f0106e0a:	89 e5                	mov    %esp,%ebp
	if (lapic)
f0106e0c:	a1 04 b0 30 f0       	mov    0xf030b004,%eax
f0106e11:	85 c0                	test   %eax,%eax
f0106e13:	74 08                	je     f0106e1d <cpunum+0x14>
		return lapic[ID] >> 24;
f0106e15:	8b 40 20             	mov    0x20(%eax),%eax
f0106e18:	c1 e8 18             	shr    $0x18,%eax
f0106e1b:	eb 05                	jmp    f0106e22 <cpunum+0x19>
	return 0;
f0106e1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106e22:	5d                   	pop    %ebp
f0106e23:	c3                   	ret    

f0106e24 <lapic_init>:
}

void
lapic_init(void)
{
	if (!lapicaddr)
f0106e24:	a1 00 b0 30 f0       	mov    0xf030b000,%eax
f0106e29:	85 c0                	test   %eax,%eax
f0106e2b:	0f 84 23 01 00 00    	je     f0106f54 <lapic_init+0x130>
	lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(void)
{
f0106e31:	55                   	push   %ebp
f0106e32:	89 e5                	mov    %esp,%ebp
f0106e34:	83 ec 18             	sub    $0x18,%esp
	if (!lapicaddr)
		return;

	// lapicaddr is the physical address of the LAPIC's 4K MMIO
	// region.  Map it in to virtual memory so we can access it.
	lapic = mmio_map_region(lapicaddr, 4096);
f0106e37:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0106e3e:	00 
f0106e3f:	89 04 24             	mov    %eax,(%esp)
f0106e42:	e8 d6 a9 ff ff       	call   f010181d <mmio_map_region>
f0106e47:	a3 04 b0 30 f0       	mov    %eax,0xf030b004

	// Enable local APIC; set spurious interrupt vector.
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0106e4c:	ba 27 01 00 00       	mov    $0x127,%edx
f0106e51:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0106e56:	e8 96 ff ff ff       	call   f0106df1 <lapicw>

	// The timer repeatedly counts down at bus frequency
	// from lapic[TICR] and then issues an interrupt.  
	// If we cared more about precise timekeeping,
	// TICR would be calibrated using an external time source.
	lapicw(TDCR, X1);
f0106e5b:	ba 0b 00 00 00       	mov    $0xb,%edx
f0106e60:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0106e65:	e8 87 ff ff ff       	call   f0106df1 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0106e6a:	ba 20 00 02 00       	mov    $0x20020,%edx
f0106e6f:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0106e74:	e8 78 ff ff ff       	call   f0106df1 <lapicw>
	lapicw(TICR, 10000000); 
f0106e79:	ba 80 96 98 00       	mov    $0x989680,%edx
f0106e7e:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106e83:	e8 69 ff ff ff       	call   f0106df1 <lapicw>
	//
	// According to Intel MP Specification, the BIOS should initialize
	// BSP's local APIC in Virtual Wire Mode, in which 8259A's
	// INTR is virtually connected to BSP's LINTIN0. In this mode,
	// we do not need to program the IOAPIC.
	if (thiscpu != bootcpu)
f0106e88:	e8 7c ff ff ff       	call   f0106e09 <cpunum>
f0106e8d:	6b c0 74             	imul   $0x74,%eax,%eax
f0106e90:	05 20 a0 2c f0       	add    $0xf02ca020,%eax
f0106e95:	39 05 c0 a3 2c f0    	cmp    %eax,0xf02ca3c0
f0106e9b:	74 0f                	je     f0106eac <lapic_init+0x88>
		lapicw(LINT0, MASKED);
f0106e9d:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106ea2:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0106ea7:	e8 45 ff ff ff       	call   f0106df1 <lapicw>

	// Disable NMI (LINT1) on all CPUs
	lapicw(LINT1, MASKED);
f0106eac:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106eb1:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106eb6:	e8 36 ff ff ff       	call   f0106df1 <lapicw>

	// Disable performance counter overflow interrupts
	// on machines that provide that interrupt entry.
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0106ebb:	a1 04 b0 30 f0       	mov    0xf030b004,%eax
f0106ec0:	8b 40 30             	mov    0x30(%eax),%eax
f0106ec3:	c1 e8 10             	shr    $0x10,%eax
f0106ec6:	3c 03                	cmp    $0x3,%al
f0106ec8:	76 0f                	jbe    f0106ed9 <lapic_init+0xb5>
		lapicw(PCINT, MASKED);
f0106eca:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106ecf:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0106ed4:	e8 18 ff ff ff       	call   f0106df1 <lapicw>

	// Map error interrupt to IRQ_ERROR.
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106ed9:	ba 33 00 00 00       	mov    $0x33,%edx
f0106ede:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0106ee3:	e8 09 ff ff ff       	call   f0106df1 <lapicw>

	// Clear error status register (requires back-to-back writes).
	lapicw(ESR, 0);
f0106ee8:	ba 00 00 00 00       	mov    $0x0,%edx
f0106eed:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106ef2:	e8 fa fe ff ff       	call   f0106df1 <lapicw>
	lapicw(ESR, 0);
f0106ef7:	ba 00 00 00 00       	mov    $0x0,%edx
f0106efc:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0106f01:	e8 eb fe ff ff       	call   f0106df1 <lapicw>

	// Ack any outstanding interrupts.
	lapicw(EOI, 0);
f0106f06:	ba 00 00 00 00       	mov    $0x0,%edx
f0106f0b:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106f10:	e8 dc fe ff ff       	call   f0106df1 <lapicw>

	// Send an Init Level De-Assert to synchronize arbitration ID's.
	lapicw(ICRHI, 0);
f0106f15:	ba 00 00 00 00       	mov    $0x0,%edx
f0106f1a:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106f1f:	e8 cd fe ff ff       	call   f0106df1 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0106f24:	ba 00 85 08 00       	mov    $0x88500,%edx
f0106f29:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106f2e:	e8 be fe ff ff       	call   f0106df1 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0106f33:	8b 15 04 b0 30 f0    	mov    0xf030b004,%edx
f0106f39:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0106f3f:	f6 c4 10             	test   $0x10,%ah
f0106f42:	75 f5                	jne    f0106f39 <lapic_init+0x115>
		;

	// Enable interrupts on the APIC (but not on the processor).
	lapicw(TPR, 0);
f0106f44:	ba 00 00 00 00       	mov    $0x0,%edx
f0106f49:	b8 20 00 00 00       	mov    $0x20,%eax
f0106f4e:	e8 9e fe ff ff       	call   f0106df1 <lapicw>
}
f0106f53:	c9                   	leave  
f0106f54:	f3 c3                	repz ret 

f0106f56 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0106f56:	83 3d 04 b0 30 f0 00 	cmpl   $0x0,0xf030b004
f0106f5d:	74 13                	je     f0106f72 <lapic_eoi+0x1c>
}

// Acknowledge interrupt.
void
lapic_eoi(void)
{
f0106f5f:	55                   	push   %ebp
f0106f60:	89 e5                	mov    %esp,%ebp
	if (lapic)
		lapicw(EOI, 0);
f0106f62:	ba 00 00 00 00       	mov    $0x0,%edx
f0106f67:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106f6c:	e8 80 fe ff ff       	call   f0106df1 <lapicw>
}
f0106f71:	5d                   	pop    %ebp
f0106f72:	f3 c3                	repz ret 

f0106f74 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0106f74:	55                   	push   %ebp
f0106f75:	89 e5                	mov    %esp,%ebp
f0106f77:	56                   	push   %esi
f0106f78:	53                   	push   %ebx
f0106f79:	83 ec 10             	sub    $0x10,%esp
f0106f7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0106f7f:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106f82:	ba 70 00 00 00       	mov    $0x70,%edx
f0106f87:	b8 0f 00 00 00       	mov    $0xf,%eax
f0106f8c:	ee                   	out    %al,(%dx)
f0106f8d:	b2 71                	mov    $0x71,%dl
f0106f8f:	b8 0a 00 00 00       	mov    $0xa,%eax
f0106f94:	ee                   	out    %al,(%dx)
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0106f95:	83 3d 94 9e 2c f0 00 	cmpl   $0x0,0xf02c9e94
f0106f9c:	75 24                	jne    f0106fc2 <lapic_startap+0x4e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106f9e:	c7 44 24 0c 67 04 00 	movl   $0x467,0xc(%esp)
f0106fa5:	00 
f0106fa6:	c7 44 24 08 44 81 10 	movl   $0xf0108144,0x8(%esp)
f0106fad:	f0 
f0106fae:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
f0106fb5:	00 
f0106fb6:	c7 04 24 5c a0 10 f0 	movl   $0xf010a05c,(%esp)
f0106fbd:	e8 7e 90 ff ff       	call   f0100040 <_panic>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0106fc2:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106fc9:	00 00 
	wrv[1] = addr >> 4;
f0106fcb:	89 f0                	mov    %esi,%eax
f0106fcd:	c1 e8 04             	shr    $0x4,%eax
f0106fd0:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0106fd6:	c1 e3 18             	shl    $0x18,%ebx
f0106fd9:	89 da                	mov    %ebx,%edx
f0106fdb:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106fe0:	e8 0c fe ff ff       	call   f0106df1 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0106fe5:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106fea:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106fef:	e8 fd fd ff ff       	call   f0106df1 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0106ff4:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106ff9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106ffe:	e8 ee fd ff ff       	call   f0106df1 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0107003:	c1 ee 0c             	shr    $0xc,%esi
f0107006:	81 ce 00 06 00 00    	or     $0x600,%esi
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f010700c:	89 da                	mov    %ebx,%edx
f010700e:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0107013:	e8 d9 fd ff ff       	call   f0106df1 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0107018:	89 f2                	mov    %esi,%edx
f010701a:	b8 c0 00 00 00       	mov    $0xc0,%eax
f010701f:	e8 cd fd ff ff       	call   f0106df1 <lapicw>
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f0107024:	89 da                	mov    %ebx,%edx
f0107026:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010702b:	e8 c1 fd ff ff       	call   f0106df1 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0107030:	89 f2                	mov    %esi,%edx
f0107032:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0107037:	e8 b5 fd ff ff       	call   f0106df1 <lapicw>
		microdelay(200);
	}
}
f010703c:	83 c4 10             	add    $0x10,%esp
f010703f:	5b                   	pop    %ebx
f0107040:	5e                   	pop    %esi
f0107041:	5d                   	pop    %ebp
f0107042:	c3                   	ret    

f0107043 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f0107043:	55                   	push   %ebp
f0107044:	89 e5                	mov    %esp,%ebp
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0107046:	8b 55 08             	mov    0x8(%ebp),%edx
f0107049:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f010704f:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0107054:	e8 98 fd ff ff       	call   f0106df1 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0107059:	8b 15 04 b0 30 f0    	mov    0xf030b004,%edx
f010705f:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
f0107065:	f6 c4 10             	test   $0x10,%ah
f0107068:	75 f5                	jne    f010705f <lapic_ipi+0x1c>
		;
}
f010706a:	5d                   	pop    %ebp
f010706b:	c3                   	ret    

f010706c <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f010706c:	55                   	push   %ebp
f010706d:	89 e5                	mov    %esp,%ebp
f010706f:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f0107072:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0107078:	8b 55 0c             	mov    0xc(%ebp),%edx
f010707b:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f010707e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0107085:	5d                   	pop    %ebp
f0107086:	c3                   	ret    

f0107087 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0107087:	55                   	push   %ebp
f0107088:	89 e5                	mov    %esp,%ebp
f010708a:	56                   	push   %esi
f010708b:	53                   	push   %ebx
f010708c:	83 ec 20             	sub    $0x20,%esp
f010708f:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
	return lock->locked && lock->cpu == thiscpu;
f0107092:	83 3b 00             	cmpl   $0x0,(%ebx)
f0107095:	75 07                	jne    f010709e <spin_lock+0x17>
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f0107097:	ba 01 00 00 00       	mov    $0x1,%edx
f010709c:	eb 42                	jmp    f01070e0 <spin_lock+0x59>
f010709e:	8b 73 08             	mov    0x8(%ebx),%esi
f01070a1:	e8 63 fd ff ff       	call   f0106e09 <cpunum>
f01070a6:	6b c0 74             	imul   $0x74,%eax,%eax
f01070a9:	05 20 a0 2c f0       	add    $0xf02ca020,%eax
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f01070ae:	39 c6                	cmp    %eax,%esi
f01070b0:	75 e5                	jne    f0107097 <spin_lock+0x10>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f01070b2:	8b 5b 04             	mov    0x4(%ebx),%ebx
f01070b5:	e8 4f fd ff ff       	call   f0106e09 <cpunum>
f01070ba:	89 5c 24 10          	mov    %ebx,0x10(%esp)
f01070be:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01070c2:	c7 44 24 08 6c a0 10 	movl   $0xf010a06c,0x8(%esp)
f01070c9:	f0 
f01070ca:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
f01070d1:	00 
f01070d2:	c7 04 24 ce a0 10 f0 	movl   $0xf010a0ce,(%esp)
f01070d9:	e8 62 8f ff ff       	call   f0100040 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f01070de:	f3 90                	pause  
f01070e0:	89 d0                	mov    %edx,%eax
f01070e2:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f01070e5:	85 c0                	test   %eax,%eax
f01070e7:	75 f5                	jne    f01070de <spin_lock+0x57>
		asm volatile ("pause");

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f01070e9:	e8 1b fd ff ff       	call   f0106e09 <cpunum>
f01070ee:	6b c0 74             	imul   $0x74,%eax,%eax
f01070f1:	05 20 a0 2c f0       	add    $0xf02ca020,%eax
f01070f6:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f01070f9:	83 c3 0c             	add    $0xc,%ebx
get_caller_pcs(uint32_t pcs[])
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
f01070fc:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f01070fe:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0107103:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0107109:	76 12                	jbe    f010711d <spin_lock+0x96>
			break;
		pcs[i] = ebp[1];          // saved %eip
f010710b:	8b 4a 04             	mov    0x4(%edx),%ecx
f010710e:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0107111:	8b 12                	mov    (%edx),%edx
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f0107113:	83 c0 01             	add    $0x1,%eax
f0107116:	83 f8 0a             	cmp    $0xa,%eax
f0107119:	75 e8                	jne    f0107103 <spin_lock+0x7c>
f010711b:	eb 0f                	jmp    f010712c <spin_lock+0xa5>
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
		pcs[i] = 0;
f010711d:	c7 04 83 00 00 00 00 	movl   $0x0,(%ebx,%eax,4)
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
f0107124:	83 c0 01             	add    $0x1,%eax
f0107127:	83 f8 09             	cmp    $0x9,%eax
f010712a:	7e f1                	jle    f010711d <spin_lock+0x96>
	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
	get_caller_pcs(lk->pcs);
#endif
}
f010712c:	83 c4 20             	add    $0x20,%esp
f010712f:	5b                   	pop    %ebx
f0107130:	5e                   	pop    %esi
f0107131:	5d                   	pop    %ebp
f0107132:	c3                   	ret    

f0107133 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0107133:	55                   	push   %ebp
f0107134:	89 e5                	mov    %esp,%ebp
f0107136:	57                   	push   %edi
f0107137:	56                   	push   %esi
f0107138:	53                   	push   %ebx
f0107139:	83 ec 6c             	sub    $0x6c,%esp
f010713c:	8b 75 08             	mov    0x8(%ebp),%esi

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
	return lock->locked && lock->cpu == thiscpu;
f010713f:	83 3e 00             	cmpl   $0x0,(%esi)
f0107142:	74 18                	je     f010715c <spin_unlock+0x29>
f0107144:	8b 5e 08             	mov    0x8(%esi),%ebx
f0107147:	e8 bd fc ff ff       	call   f0106e09 <cpunum>
f010714c:	6b c0 74             	imul   $0x74,%eax,%eax
f010714f:	05 20 a0 2c f0       	add    $0xf02ca020,%eax
// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
f0107154:	39 c3                	cmp    %eax,%ebx
f0107156:	0f 84 ce 00 00 00    	je     f010722a <spin_unlock+0xf7>
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f010715c:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
f0107163:	00 
f0107164:	8d 46 0c             	lea    0xc(%esi),%eax
f0107167:	89 44 24 04          	mov    %eax,0x4(%esp)
f010716b:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f010716e:	89 1c 24             	mov    %ebx,(%esp)
f0107171:	e8 8e f6 ff ff       	call   f0106804 <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
f0107176:	8b 46 08             	mov    0x8(%esi),%eax
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f0107179:	0f b6 38             	movzbl (%eax),%edi
f010717c:	8b 76 04             	mov    0x4(%esi),%esi
f010717f:	e8 85 fc ff ff       	call   f0106e09 <cpunum>
f0107184:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0107188:	89 74 24 08          	mov    %esi,0x8(%esp)
f010718c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107190:	c7 04 24 98 a0 10 f0 	movl   $0xf010a098,(%esp)
f0107197:	e8 a6 d1 ff ff       	call   f0104342 <cprintf>
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f010719c:	8d 7d a8             	lea    -0x58(%ebp),%edi
f010719f:	eb 65                	jmp    f0107206 <spin_unlock+0xd3>
f01071a1:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01071a5:	89 04 24             	mov    %eax,(%esp)
f01071a8:	e8 8a eb ff ff       	call   f0105d37 <debuginfo_eip>
f01071ad:	85 c0                	test   %eax,%eax
f01071af:	78 39                	js     f01071ea <spin_unlock+0xb7>
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
f01071b1:	8b 06                	mov    (%esi),%eax
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f01071b3:	89 c2                	mov    %eax,%edx
f01071b5:	2b 55 b8             	sub    -0x48(%ebp),%edx
f01071b8:	89 54 24 18          	mov    %edx,0x18(%esp)
f01071bc:	8b 55 b0             	mov    -0x50(%ebp),%edx
f01071bf:	89 54 24 14          	mov    %edx,0x14(%esp)
f01071c3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
f01071c6:	89 54 24 10          	mov    %edx,0x10(%esp)
f01071ca:	8b 55 ac             	mov    -0x54(%ebp),%edx
f01071cd:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01071d1:	8b 55 a8             	mov    -0x58(%ebp),%edx
f01071d4:	89 54 24 08          	mov    %edx,0x8(%esp)
f01071d8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01071dc:	c7 04 24 de a0 10 f0 	movl   $0xf010a0de,(%esp)
f01071e3:	e8 5a d1 ff ff       	call   f0104342 <cprintf>
f01071e8:	eb 12                	jmp    f01071fc <spin_unlock+0xc9>
					info.eip_file, info.eip_line,
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
f01071ea:	8b 06                	mov    (%esi),%eax
f01071ec:	89 44 24 04          	mov    %eax,0x4(%esp)
f01071f0:	c7 04 24 f5 a0 10 f0 	movl   $0xf010a0f5,(%esp)
f01071f7:	e8 46 d1 ff ff       	call   f0104342 <cprintf>
f01071fc:	83 c3 04             	add    $0x4,%ebx
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu->cpu_id);
		for (i = 0; i < 10 && pcs[i]; i++) {
f01071ff:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0107202:	39 c3                	cmp    %eax,%ebx
f0107204:	74 08                	je     f010720e <spin_unlock+0xdb>
f0107206:	89 de                	mov    %ebx,%esi
f0107208:	8b 03                	mov    (%ebx),%eax
f010720a:	85 c0                	test   %eax,%eax
f010720c:	75 93                	jne    f01071a1 <spin_unlock+0x6e>
					info.eip_fn_namelen, info.eip_fn_name,
					pcs[i] - info.eip_fn_addr);
			else
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
f010720e:	c7 44 24 08 fd a0 10 	movl   $0xf010a0fd,0x8(%esp)
f0107215:	f0 
f0107216:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
f010721d:	00 
f010721e:	c7 04 24 ce a0 10 f0 	movl   $0xf010a0ce,(%esp)
f0107225:	e8 16 8e ff ff       	call   f0100040 <_panic>
	}

	lk->pcs[0] = 0;
f010722a:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f0107231:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
f0107238:	b8 00 00 00 00       	mov    $0x0,%eax
f010723d:	f0 87 06             	lock xchg %eax,(%esi)
	// respect to any other instruction which references the same memory.
	// x86 CPUs will not reorder loads/stores across locked instructions
	// (vol 3, 8.2.2). Because xchg() is implemented using asm volatile,
	// gcc will not reorder C statements across the xchg.
	xchg(&lk->locked, 0);
}
f0107240:	83 c4 6c             	add    $0x6c,%esp
f0107243:	5b                   	pop    %ebx
f0107244:	5e                   	pop    %esi
f0107245:	5f                   	pop    %edi
f0107246:	5d                   	pop    %ebp
f0107247:	c3                   	ret    

f0107248 <e1000_transmit>:
	return 1;
}

int
e1000_transmit(char* pkt, size_t length)
{
f0107248:	55                   	push   %ebp
f0107249:	89 e5                	mov    %esp,%ebp
f010724b:	56                   	push   %esi
f010724c:	53                   	push   %ebx
f010724d:	83 ec 10             	sub    $0x10,%esp
f0107250:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (length > PKT_BUF_SIZE)
f0107253:	81 fe 00 08 00 00    	cmp    $0x800,%esi
f0107259:	76 20                	jbe    f010727b <e1000_transmit+0x33>
		panic("e1000_transmit: size of packet to transmit (%d) larger than max (2048)\n", length);
f010725b:	89 74 24 0c          	mov    %esi,0xc(%esp)
f010725f:	c7 44 24 08 18 a1 10 	movl   $0xf010a118,0x8(%esp)
f0107266:	f0 
f0107267:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
f010726e:	00 
f010726f:	c7 04 24 cc a1 10 f0 	movl   $0xf010a1cc,(%esp)
f0107276:	e8 c5 8d ff ff       	call   f0100040 <_panic>

	size_t tail_idx = network_regs[E1000_TDT];
f010727b:	a1 30 b8 34 f0       	mov    0xf034b830,%eax
f0107280:	8b 98 18 38 00 00    	mov    0x3818(%eax),%ebx

	if (txq[tail_idx].status & E1000_TXD_DD) {
f0107286:	89 d8                	mov    %ebx,%eax
f0107288:	c1 e0 04             	shl    $0x4,%eax
f010728b:	f6 80 4c b8 35 f0 01 	testb  $0x1,-0xfca47b4(%eax)
f0107292:	74 4b                	je     f01072df <e1000_transmit+0x97>
		memmove((void *) &tx_pkts[tail_idx], (void *) pkt, length);
f0107294:	89 74 24 08          	mov    %esi,0x8(%esp)
f0107298:	8b 45 08             	mov    0x8(%ebp),%eax
f010729b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010729f:	89 d8                	mov    %ebx,%eax
f01072a1:	c1 e0 0b             	shl    $0xb,%eax
f01072a4:	05 40 b8 34 f0       	add    $0xf034b840,%eax
f01072a9:	89 04 24             	mov    %eax,(%esp)
f01072ac:	e8 53 f5 ff ff       	call   f0106804 <memmove>
		txq[tail_idx].status &= ~E1000_TXD_DD;
f01072b1:	89 d8                	mov    %ebx,%eax
f01072b3:	c1 e0 04             	shl    $0x4,%eax
f01072b6:	05 40 b8 35 f0       	add    $0xf035b840,%eax
f01072bb:	80 60 0c fe          	andb   $0xfe,0xc(%eax)
		txq[tail_idx].cmd |= E1000_TXD_EOP;
f01072bf:	80 48 0b 01          	orb    $0x1,0xb(%eax)
		txq[tail_idx].length = length;
f01072c3:	66 89 70 08          	mov    %si,0x8(%eax)
		network_regs[E1000_TDT] = (tail_idx + 1) % NTXDESC;
f01072c7:	83 c3 01             	add    $0x1,%ebx
f01072ca:	83 e3 1f             	and    $0x1f,%ebx
f01072cd:	a1 30 b8 34 f0       	mov    0xf034b830,%eax
f01072d2:	89 98 18 38 00 00    	mov    %ebx,0x3818(%eax)

		return 0;
f01072d8:	b8 00 00 00 00       	mov    $0x0,%eax
f01072dd:	eb 05                	jmp    f01072e4 <e1000_transmit+0x9c>
	} else {
		return -1;
f01072df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}
}
f01072e4:	83 c4 10             	add    $0x10,%esp
f01072e7:	5b                   	pop    %ebx
f01072e8:	5e                   	pop    %esi
f01072e9:	5d                   	pop    %ebp
f01072ea:	c3                   	ret    

f01072eb <e1000_receive>:

int
e1000_receive(char* pkt, size_t *length)
{
f01072eb:	55                   	push   %ebp
f01072ec:	89 e5                	mov    %esp,%ebp
f01072ee:	56                   	push   %esi
f01072ef:	53                   	push   %ebx
f01072f0:	83 ec 10             	sub    $0x10,%esp
	size_t tail_idx = (network_regs[E1000_RDT] + 1) % NRXDESC;
f01072f3:	a1 30 b8 34 f0       	mov    0xf034b830,%eax
f01072f8:	8b 98 18 28 00 00    	mov    0x2818(%eax),%ebx
f01072fe:	83 c3 01             	add    $0x1,%ebx
f0107301:	83 e3 7f             	and    $0x7f,%ebx

	if ((rxq[tail_idx].status & E1000_RXD_STATUS_DD) == 0)
f0107304:	89 d8                	mov    %ebx,%eax
f0107306:	c1 e0 04             	shl    $0x4,%eax
f0107309:	0f b6 80 3c b0 34 f0 	movzbl -0xfcb4fc4(%eax),%eax
f0107310:	a8 01                	test   $0x1,%al
f0107312:	74 6a                	je     f010737e <e1000_receive+0x93>
		return -E_E1000_RXBUF_EMPTY;

	if ((rxq[tail_idx].status & E1000_RXD_STATUS_EOP) == 0)
f0107314:	a8 02                	test   $0x2,%al
f0107316:	75 1c                	jne    f0107334 <e1000_receive+0x49>
		panic("e1000_receive: EOP flag not set, all packets should fit in one buffer\n");
f0107318:	c7 44 24 08 60 a1 10 	movl   $0xf010a160,0x8(%esp)
f010731f:	f0 
f0107320:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
f0107327:	00 
f0107328:	c7 04 24 cc a1 10 f0 	movl   $0xf010a1cc,(%esp)
f010732f:	e8 0c 8d ff ff       	call   f0100040 <_panic>

	*length = rxq[tail_idx].length;
f0107334:	89 de                	mov    %ebx,%esi
f0107336:	c1 e6 04             	shl    $0x4,%esi
f0107339:	0f b7 86 38 b0 34 f0 	movzwl -0xfcb4fc8(%esi),%eax
f0107340:	81 c6 30 b0 34 f0    	add    $0xf034b030,%esi
f0107346:	8b 55 0c             	mov    0xc(%ebp),%edx
f0107349:	89 02                	mov    %eax,(%edx)
	memmove(pkt, &rx_pkts[tail_idx], *length);
f010734b:	89 44 24 08          	mov    %eax,0x8(%esp)
f010734f:	89 d8                	mov    %ebx,%eax
f0107351:	c1 e0 0b             	shl    $0xb,%eax
f0107354:	05 20 b0 30 f0       	add    $0xf030b020,%eax
f0107359:	89 44 24 04          	mov    %eax,0x4(%esp)
f010735d:	8b 45 08             	mov    0x8(%ebp),%eax
f0107360:	89 04 24             	mov    %eax,(%esp)
f0107363:	e8 9c f4 ff ff       	call   f0106804 <memmove>

	rxq[tail_idx].status &= ~(E1000_RXD_STATUS_DD);
	rxq[tail_idx].status &= ~(E1000_RXD_STATUS_EOP);
f0107368:	80 66 0c fc          	andb   $0xfc,0xc(%esi)

	network_regs[E1000_RDT] = tail_idx;
f010736c:	a1 30 b8 34 f0       	mov    0xf034b830,%eax
f0107371:	89 98 18 28 00 00    	mov    %ebx,0x2818(%eax)

	return 0;
f0107377:	b8 00 00 00 00       	mov    $0x0,%eax
f010737c:	eb 05                	jmp    f0107383 <e1000_receive+0x98>
e1000_receive(char* pkt, size_t *length)
{
	size_t tail_idx = (network_regs[E1000_RDT] + 1) % NRXDESC;

	if ((rxq[tail_idx].status & E1000_RXD_STATUS_DD) == 0)
		return -E_E1000_RXBUF_EMPTY;
f010737e:	b8 ef ff ff ff       	mov    $0xffffffef,%eax
	rxq[tail_idx].status &= ~(E1000_RXD_STATUS_EOP);

	network_regs[E1000_RDT] = tail_idx;

	return 0;
}
f0107383:	83 c4 10             	add    $0x10,%esp
f0107386:	5b                   	pop    %ebx
f0107387:	5e                   	pop    %esi
f0107388:	5d                   	pop    %ebp
f0107389:	c3                   	ret    

f010738a <clear_e1000_interrupt>:

void
clear_e1000_interrupt(void)
{
f010738a:	55                   	push   %ebp
f010738b:	89 e5                	mov    %esp,%ebp
f010738d:	83 ec 08             	sub    $0x8,%esp
	network_regs[E1000_ICR] |= E1000_RXT0;
f0107390:	a1 30 b8 34 f0       	mov    0xf034b830,%eax
f0107395:	8b 90 c0 00 00 00    	mov    0xc0(%eax),%edx
f010739b:	80 ca 80             	or     $0x80,%dl
f010739e:	89 90 c0 00 00 00    	mov    %edx,0xc0(%eax)
	lapic_eoi();
f01073a4:	e8 ad fb ff ff       	call   f0106f56 <lapic_eoi>
	irq_eoi();
f01073a9:	e8 3b cf ff ff       	call   f01042e9 <irq_eoi>
}
f01073ae:	c9                   	leave  
f01073af:	c3                   	ret    

f01073b0 <e1000_trap_handler>:

void
e1000_trap_handler(void)
{
f01073b0:	a1 48 92 2c f0       	mov    0xf02c9248,%eax
	struct Env *receiver = NULL;
	int i;

	for (i = 0; i < NENV; i++) {
		if (envs[i].env_e1000_waiting_rx)
f01073b5:	ba 00 04 00 00       	mov    $0x400,%edx
}

void
e1000_trap_handler(void)
{
	struct Env *receiver = NULL;
f01073ba:	b9 00 00 00 00       	mov    $0x0,%ecx
	int i;

	for (i = 0; i < NENV; i++) {
		if (envs[i].env_e1000_waiting_rx)
			receiver = &envs[i];
f01073bf:	80 78 7c 00          	cmpb   $0x0,0x7c(%eax)
f01073c3:	0f 45 c8             	cmovne %eax,%ecx
f01073c6:	83 e8 80             	sub    $0xffffff80,%eax
e1000_trap_handler(void)
{
	struct Env *receiver = NULL;
	int i;

	for (i = 0; i < NENV; i++) {
f01073c9:	83 ea 01             	sub    $0x1,%edx
f01073cc:	75 f1                	jne    f01073bf <e1000_trap_handler+0xf>
	irq_eoi();
}

void
e1000_trap_handler(void)
{
f01073ce:	55                   	push   %ebp
f01073cf:	89 e5                	mov    %esp,%ebp
f01073d1:	83 ec 08             	sub    $0x8,%esp
	for (i = 0; i < NENV; i++) {
		if (envs[i].env_e1000_waiting_rx)
			receiver = &envs[i];
	}

	if (!receiver) {
f01073d4:	85 c9                	test   %ecx,%ecx
f01073d6:	75 07                	jne    f01073df <e1000_trap_handler+0x2f>
		clear_e1000_interrupt();
f01073d8:	e8 ad ff ff ff       	call   f010738a <clear_e1000_interrupt>
		return;
f01073dd:	eb 10                	jmp    f01073ef <e1000_trap_handler+0x3f>
	}
	else {
		receiver->env_status = ENV_RUNNABLE;
f01073df:	c7 41 54 02 00 00 00 	movl   $0x2,0x54(%ecx)
		receiver->env_e1000_waiting_rx = false;
f01073e6:	c6 41 7c 00          	movb   $0x0,0x7c(%ecx)
		clear_e1000_interrupt();
f01073ea:	e8 9b ff ff ff       	call   f010738a <clear_e1000_interrupt>
		return;
	}
}
f01073ef:	c9                   	leave  
f01073f0:	c3                   	ret    

f01073f1 <read_mac_from_eeprom>:

void
read_mac_from_eeprom(void)
{
f01073f1:	55                   	push   %ebp
f01073f2:	89 e5                	mov    %esp,%ebp
f01073f4:	53                   	push   %ebx
	uint8_t word_num;
	for (word_num = 0; word_num < E1000_NUM_MAC_WORDS; word_num++) {
		network_regs[E1000_EERD] |= (word_num << E1000_EERD_ADDR);
f01073f5:	8b 15 30 b8 34 f0    	mov    0xf034b830,%edx
f01073fb:	b9 00 00 00 00       	mov    $0x0,%ecx
f0107400:	8b 42 14             	mov    0x14(%edx),%eax
f0107403:	89 cb                	mov    %ecx,%ebx
f0107405:	c1 e3 08             	shl    $0x8,%ebx
f0107408:	09 d8                	or     %ebx,%eax
f010740a:	89 42 14             	mov    %eax,0x14(%edx)
		network_regs[E1000_EERD] |= E1000_EERD_READ;
f010740d:	8b 42 14             	mov    0x14(%edx),%eax
f0107410:	83 c8 01             	or     $0x1,%eax
f0107413:	89 42 14             	mov    %eax,0x14(%edx)
		while (!(network_regs[E1000_EERD] & E1000_EERD_DONE));
f0107416:	8b 42 14             	mov    0x14(%edx),%eax
f0107419:	a8 10                	test   $0x10,%al
f010741b:	74 f9                	je     f0107416 <read_mac_from_eeprom+0x25>
		mac[word_num] = network_regs[E1000_EERD] >> E1000_EERD_DATA;
f010741d:	8b 42 14             	mov    0x14(%edx),%eax
f0107420:	c1 e8 10             	shr    $0x10,%eax
f0107423:	66 89 84 09 20 b0 34 	mov    %ax,-0xfcb4fe0(%ecx,%ecx,1)
f010742a:	f0 
		network_regs[E1000_EERD] = 0x0;
f010742b:	c7 42 14 00 00 00 00 	movl   $0x0,0x14(%edx)
f0107432:	83 c1 01             	add    $0x1,%ecx

void
read_mac_from_eeprom(void)
{
	uint8_t word_num;
	for (word_num = 0; word_num < E1000_NUM_MAC_WORDS; word_num++) {
f0107435:	83 f9 03             	cmp    $0x3,%ecx
f0107438:	75 c6                	jne    f0107400 <read_mac_from_eeprom+0xf>
		network_regs[E1000_EERD] |= E1000_EERD_READ;
		while (!(network_regs[E1000_EERD] & E1000_EERD_DONE));
		mac[word_num] = network_regs[E1000_EERD] >> E1000_EERD_DATA;
		network_regs[E1000_EERD] = 0x0;
	}
}
f010743a:	5b                   	pop    %ebx
f010743b:	5d                   	pop    %ebp
f010743c:	c3                   	ret    

f010743d <pci_network_attach>:
void read_mac_from_eeprom(void);


int
pci_network_attach(struct pci_func *pcif)
{
f010743d:	55                   	push   %ebp
f010743e:	89 e5                	mov    %esp,%ebp
f0107440:	53                   	push   %ebx
f0107441:	83 ec 14             	sub    $0x14,%esp
f0107444:	8b 5d 08             	mov    0x8(%ebp),%ebx
	pci_func_enable(pcif);
f0107447:	89 1c 24             	mov    %ebx,(%esp)
f010744a:	e8 41 08 00 00       	call   f0107c90 <pci_func_enable>
	network_regs = mmio_map_region((physaddr_t) pcif->reg_base[0], pcif->reg_size[0]);
f010744f:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0107452:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107456:	8b 43 14             	mov    0x14(%ebx),%eax
f0107459:	89 04 24             	mov    %eax,(%esp)
f010745c:	e8 bc a3 ff ff       	call   f010181d <mmio_map_region>
f0107461:	a3 30 b8 34 f0       	mov    %eax,0xf034b830
	cprintf("DEV_STAT: 0x%08x\n", network_regs[E1000_STATUS]); // check device status register
f0107466:	8b 40 08             	mov    0x8(%eax),%eax
f0107469:	89 44 24 04          	mov    %eax,0x4(%esp)
f010746d:	c7 04 24 d9 a1 10 f0 	movl   $0xf010a1d9,(%esp)
f0107474:	e8 c9 ce ff ff       	call   f0104342 <cprintf>
	read_mac_from_eeprom();
f0107479:	e8 73 ff ff ff       	call   f01073f1 <read_mac_from_eeprom>

	// TX init

	network_regs[E1000_TDBAL] = PADDR(txq);
f010747e:	8b 15 30 b8 34 f0    	mov    0xf034b830,%edx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0107484:	b8 40 b8 35 f0       	mov    $0xf035b840,%eax
f0107489:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010748e:	77 20                	ja     f01074b0 <pci_network_attach+0x73>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0107490:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107494:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f010749b:	f0 
f010749c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
f01074a3:	00 
f01074a4:	c7 04 24 cc a1 10 f0 	movl   $0xf010a1cc,(%esp)
f01074ab:	e8 90 8b ff ff       	call   f0100040 <_panic>
f01074b0:	c7 82 00 38 00 00 40 	movl   $0x35b840,0x3800(%edx)
f01074b7:	b8 35 00 
	network_regs[E1000_TDBAH] = 0x00000000;
f01074ba:	c7 82 04 38 00 00 00 	movl   $0x0,0x3804(%edx)
f01074c1:	00 00 00 

	network_regs[E1000_TDLEN] = NTXDESC * sizeof(struct tx_desc);
f01074c4:	c7 82 08 38 00 00 00 	movl   $0x200,0x3808(%edx)
f01074cb:	02 00 00 

	network_regs[E1000_TDH] = 0x00000000;
f01074ce:	c7 82 10 38 00 00 00 	movl   $0x0,0x3810(%edx)
f01074d5:	00 00 00 
	network_regs[E1000_TDT] = 0x00000000;
f01074d8:	c7 82 18 38 00 00 00 	movl   $0x0,0x3818(%edx)
f01074df:	00 00 00 
	
	network_regs[E1000_TCTL] |= E1000_TCTL_EN;
f01074e2:	8b 82 00 04 00 00    	mov    0x400(%edx),%eax
f01074e8:	83 c8 02             	or     $0x2,%eax
f01074eb:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	network_regs[E1000_TCTL] |= E1000_TCTL_PSP;
f01074f1:	8b 82 00 04 00 00    	mov    0x400(%edx),%eax
f01074f7:	83 c8 08             	or     $0x8,%eax
f01074fa:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	network_regs[E1000_TCTL] |= E1000_TCTL_CT;
f0107500:	8b 82 00 04 00 00    	mov    0x400(%edx),%eax
f0107506:	80 cc 01             	or     $0x1,%ah
f0107509:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)
	network_regs[E1000_TCTL] |= E1000_TCTL_COLD;
f010750f:	8b 82 00 04 00 00    	mov    0x400(%edx),%eax
f0107515:	0d 00 00 04 00       	or     $0x40000,%eax
f010751a:	89 82 00 04 00 00    	mov    %eax,0x400(%edx)

	network_regs[E1000_TIPG] |= (0xA << E1000_TIPG_IPGT);
f0107520:	8b 82 10 04 00 00    	mov    0x410(%edx),%eax
f0107526:	83 c8 0a             	or     $0xa,%eax
f0107529:	89 82 10 04 00 00    	mov    %eax,0x410(%edx)
	network_regs[E1000_TIPG] |= (0x8 << E1000_TIPG_IPGR1);
f010752f:	8b 82 10 04 00 00    	mov    0x410(%edx),%eax
f0107535:	80 cc 20             	or     $0x20,%ah
f0107538:	89 82 10 04 00 00    	mov    %eax,0x410(%edx)
	network_regs[E1000_TIPG] |= (0xC << E1000_TIPG_IPGR2);
f010753e:	8b 82 10 04 00 00    	mov    0x410(%edx),%eax
f0107544:	0d 00 00 c0 00       	or     $0xc00000,%eax
f0107549:	89 82 10 04 00 00    	mov    %eax,0x410(%edx)
	
	memset(txq, 0, sizeof(struct tx_desc) * NTXDESC);
f010754f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
f0107556:	00 
f0107557:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010755e:	00 
f010755f:	c7 04 24 40 b8 35 f0 	movl   $0xf035b840,(%esp)
f0107566:	e8 4c f2 ff ff       	call   f01067b7 <memset>
f010756b:	ba 40 b8 34 f0       	mov    $0xf034b840,%edx
f0107570:	b8 40 b8 35 f0       	mov    $0xf035b840,%eax
f0107575:	bb 40 b8 35 f0       	mov    $0xf035b840,%ebx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010757a:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0107580:	77 20                	ja     f01075a2 <pci_network_attach+0x165>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0107582:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0107586:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f010758d:	f0 
f010758e:	c7 44 24 04 36 00 00 	movl   $0x36,0x4(%esp)
f0107595:	00 
f0107596:	c7 04 24 cc a1 10 f0 	movl   $0xf010a1cc,(%esp)
f010759d:	e8 9e 8a ff ff       	call   f0100040 <_panic>
f01075a2:	8d 8a 00 00 00 10    	lea    0x10000000(%edx),%ecx

	int i;
	for (i = 0; i < NTXDESC; i++) {
		txq[i].addr = PADDR(&tx_pkts[i]); 	
f01075a8:	89 08                	mov    %ecx,(%eax)
f01075aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		txq[i].cmd |= E1000_TXD_RS;			
		txq[i].cmd &= ~E1000_TXD_DEXT;		
f01075b1:	0f b6 48 0b          	movzbl 0xb(%eax),%ecx
f01075b5:	83 e1 df             	and    $0xffffffdf,%ecx
f01075b8:	83 c9 08             	or     $0x8,%ecx
f01075bb:	88 48 0b             	mov    %cl,0xb(%eax)
		txq[i].status |= E1000_TXD_DD;		
f01075be:	80 48 0c 01          	orb    $0x1,0xc(%eax)
f01075c2:	81 c2 00 08 00 00    	add    $0x800,%edx
f01075c8:	83 c0 10             	add    $0x10,%eax
	network_regs[E1000_TIPG] |= (0xC << E1000_TIPG_IPGR2);
	
	memset(txq, 0, sizeof(struct tx_desc) * NTXDESC);

	int i;
	for (i = 0; i < NTXDESC; i++) {
f01075cb:	39 da                	cmp    %ebx,%edx
f01075cd:	75 ab                	jne    f010757a <pci_network_attach+0x13d>
											
	}
	
	// RX init

	network_regs[E1000_RAL] = 0x0;
f01075cf:	a1 30 b8 34 f0       	mov    0xf034b830,%eax
f01075d4:	c7 80 00 54 00 00 00 	movl   $0x0,0x5400(%eax)
f01075db:	00 00 00 
	network_regs[E1000_RAL] |= mac[0];
f01075de:	8b 90 00 54 00 00    	mov    0x5400(%eax),%edx
f01075e4:	0f b7 0d 20 b0 34 f0 	movzwl 0xf034b020,%ecx
f01075eb:	09 ca                	or     %ecx,%edx
f01075ed:	89 90 00 54 00 00    	mov    %edx,0x5400(%eax)
	network_regs[E1000_RAL] |= (mac[1] << E1000_EERD_DATA);
f01075f3:	8b 90 00 54 00 00    	mov    0x5400(%eax),%edx
f01075f9:	0f b7 0d 22 b0 34 f0 	movzwl 0xf034b022,%ecx
f0107600:	c1 e1 10             	shl    $0x10,%ecx
f0107603:	09 ca                	or     %ecx,%edx
f0107605:	89 90 00 54 00 00    	mov    %edx,0x5400(%eax)

	network_regs[E1000_RAH] = 0x0;
f010760b:	c7 80 04 54 00 00 00 	movl   $0x0,0x5404(%eax)
f0107612:	00 00 00 
	network_regs[E1000_RAH] |= mac[2];
f0107615:	8b 90 04 54 00 00    	mov    0x5404(%eax),%edx
f010761b:	0f b7 0d 24 b0 34 f0 	movzwl 0xf034b024,%ecx
f0107622:	09 ca                	or     %ecx,%edx
f0107624:	89 90 04 54 00 00    	mov    %edx,0x5404(%eax)
	network_regs[E1000_RAH] |= E1000_RAH_AV;
f010762a:	8b 90 04 54 00 00    	mov    0x5404(%eax),%edx
f0107630:	81 ca 00 00 00 80    	or     $0x80000000,%edx
f0107636:	89 90 04 54 00 00    	mov    %edx,0x5404(%eax)
f010763c:	b8 00 52 00 00       	mov    $0x5200,%eax

	for (i = 0; i < NELEM_MTA; i++) {
		network_regs[E1000_MTA + i] = 0x00000000;
f0107641:	89 c2                	mov    %eax,%edx
f0107643:	03 15 30 b8 34 f0    	add    0xf034b830,%edx
f0107649:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
f010764f:	83 c0 04             	add    $0x4,%eax

	network_regs[E1000_RAH] = 0x0;
	network_regs[E1000_RAH] |= mac[2];
	network_regs[E1000_RAH] |= E1000_RAH_AV;

	for (i = 0; i < NELEM_MTA; i++) {
f0107652:	3d 00 54 00 00       	cmp    $0x5400,%eax
f0107657:	75 e8                	jne    f0107641 <pci_network_attach+0x204>
		network_regs[E1000_MTA + i] = 0x00000000;
	}

	network_regs[E1000_RDBAL] = PADDR(&rxq);
f0107659:	a1 30 b8 34 f0       	mov    0xf034b830,%eax
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010765e:	ba 30 b0 34 f0       	mov    $0xf034b030,%edx
f0107663:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0107669:	77 20                	ja     f010768b <pci_network_attach+0x24e>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010766b:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010766f:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f0107676:	f0 
f0107677:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
f010767e:	00 
f010767f:	c7 04 24 cc a1 10 f0 	movl   $0xf010a1cc,(%esp)
f0107686:	e8 b5 89 ff ff       	call   f0100040 <_panic>
f010768b:	c7 80 00 28 00 00 30 	movl   $0x34b030,0x2800(%eax)
f0107692:	b0 34 00 
	network_regs[E1000_RDBAH] = 0x00000000;
f0107695:	c7 80 04 28 00 00 00 	movl   $0x0,0x2804(%eax)
f010769c:	00 00 00 

	network_regs[E1000_RDLEN] = NRXDESC * sizeof(struct rx_desc);
f010769f:	c7 80 08 28 00 00 00 	movl   $0x800,0x2808(%eax)
f01076a6:	08 00 00 

	network_regs[E1000_RDH] = 0;
f01076a9:	c7 80 10 28 00 00 00 	movl   $0x0,0x2810(%eax)
f01076b0:	00 00 00 
	network_regs[E1000_RDT] = NRXDESC - 1;
f01076b3:	c7 80 18 28 00 00 7f 	movl   $0x7f,0x2818(%eax)
f01076ba:	00 00 00 

	memset(rxq, 0, sizeof(struct rx_desc) * NRXDESC);
f01076bd:	c7 44 24 08 00 08 00 	movl   $0x800,0x8(%esp)
f01076c4:	00 
f01076c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01076cc:	00 
f01076cd:	c7 04 24 30 b0 34 f0 	movl   $0xf034b030,(%esp)
f01076d4:	e8 de f0 ff ff       	call   f01067b7 <memset>
f01076d9:	b8 20 b0 30 f0       	mov    $0xf030b020,%eax
f01076de:	ba 00 00 00 00       	mov    $0x0,%edx
#define PADDR(kva) _paddr(__FILE__, __LINE__, kva)

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01076e3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01076e8:	77 20                	ja     f010770a <pci_network_attach+0x2cd>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01076ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01076ee:	c7 44 24 08 68 81 10 	movl   $0xf0108168,0x8(%esp)
f01076f5:	f0 
f01076f6:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
f01076fd:	00 
f01076fe:	c7 04 24 cc a1 10 f0 	movl   $0xf010a1cc,(%esp)
f0107705:	e8 36 89 ff ff       	call   f0100040 <_panic>
f010770a:	8d 88 00 00 00 10    	lea    0x10000000(%eax),%ecx

	for (i = 0; i < NRXDESC; i++) {
		rxq[i].addr = PADDR(&rx_pkts[i]); 	// set packet buffer addr
f0107710:	89 8a 30 b0 34 f0    	mov    %ecx,-0xfcb4fd0(%edx)
f0107716:	c7 82 34 b0 34 f0 00 	movl   $0x0,-0xfcb4fcc(%edx)
f010771d:	00 00 00 
f0107720:	05 00 08 00 00       	add    $0x800,%eax
f0107725:	83 c2 10             	add    $0x10,%edx
	network_regs[E1000_RDH] = 0;
	network_regs[E1000_RDT] = NRXDESC - 1;

	memset(rxq, 0, sizeof(struct rx_desc) * NRXDESC);

	for (i = 0; i < NRXDESC; i++) {
f0107728:	81 fa 00 08 00 00    	cmp    $0x800,%edx
f010772e:	75 b3                	jne    f01076e3 <pci_network_attach+0x2a6>
		rxq[i].addr = PADDR(&rx_pkts[i]); 	// set packet buffer addr
	}

	network_regs[E1000_IMS] |= E1000_RXT0;
f0107730:	a1 30 b8 34 f0       	mov    0xf034b830,%eax
f0107735:	8b 90 d0 00 00 00    	mov    0xd0(%eax),%edx
f010773b:	80 ca 80             	or     $0x80,%dl
f010773e:	89 90 d0 00 00 00    	mov    %edx,0xd0(%eax)
	network_regs[E1000_RCTL] &= E1000_RCTL_LBM_NO;
f0107744:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f010774a:	80 e2 3f             	and    $0x3f,%dl
f010774d:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	network_regs[E1000_RCTL] &= E1000_RCTL_BSIZE_2048;
f0107753:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f0107759:	81 e2 ff ff fc ff    	and    $0xfffcffff,%edx
f010775f:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	network_regs[E1000_RCTL] |= E1000_RCTL_SECRC;
f0107765:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f010776b:	81 ca 00 00 00 04    	or     $0x4000000,%edx
f0107771:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	network_regs[E1000_RCTL] &= E1000_RCTL_LPE_NO;
f0107777:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f010777d:	83 e2 df             	and    $0xffffffdf,%edx
f0107780:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	network_regs[E1000_RCTL] |= E1000_RCTL_EN;
f0107786:	8b 90 00 01 00 00    	mov    0x100(%eax),%edx
f010778c:	83 ca 02             	or     $0x2,%edx
f010778f:	89 90 00 01 00 00    	mov    %edx,0x100(%eax)
	
	return 1;
}
f0107795:	b8 01 00 00 00       	mov    $0x1,%eax
f010779a:	83 c4 14             	add    $0x14,%esp
f010779d:	5b                   	pop    %ebx
f010779e:	5d                   	pop    %ebp
f010779f:	c3                   	ret    

f01077a0 <e1000_get_mac>:
	}
}

void
e1000_get_mac(uint8_t *mac_addr)
{
f01077a0:	55                   	push   %ebp
f01077a1:	89 e5                	mov    %esp,%ebp
f01077a3:	8b 45 08             	mov    0x8(%ebp),%eax
	*((uint32_t *) mac_addr) =  (uint32_t) network_regs[E1000_RAL];
f01077a6:	8b 15 30 b8 34 f0    	mov    0xf034b830,%edx
f01077ac:	8b 92 00 54 00 00    	mov    0x5400(%edx),%edx
f01077b2:	89 10                	mov    %edx,(%eax)
	*((uint16_t*)(mac_addr + 4)) = (uint16_t) network_regs[E1000_RAH];
f01077b4:	8b 15 30 b8 34 f0    	mov    0xf034b830,%edx
f01077ba:	8b 92 04 54 00 00    	mov    0x5404(%edx),%edx
f01077c0:	66 89 50 04          	mov    %dx,0x4(%eax)
}
f01077c4:	5d                   	pop    %ebp
f01077c5:	c3                   	ret    

f01077c6 <print_mac>:

void
print_mac()
{
f01077c6:	55                   	push   %ebp
f01077c7:	89 e5                	mov    %esp,%ebp
f01077c9:	53                   	push   %ebx
f01077ca:	83 ec 24             	sub    $0x24,%esp
	cprintf("MAC: %02x:%02x:%02x:%02x:%02x:%02x\n", mac[0] & 0x00FF, mac[0] >> 8, mac[1] & 0x00FF, mac[1] >> 8, mac[2] & 0xFF, mac[2] >> 8);
f01077cd:	0f b7 0d 24 b0 34 f0 	movzwl 0xf034b024,%ecx
f01077d4:	0f b7 15 22 b0 34 f0 	movzwl 0xf034b022,%edx
f01077db:	0f b7 05 20 b0 34 f0 	movzwl 0xf034b020,%eax
f01077e2:	0f b6 dd             	movzbl %ch,%ebx
f01077e5:	89 5c 24 18          	mov    %ebx,0x18(%esp)
f01077e9:	0f b6 c9             	movzbl %cl,%ecx
f01077ec:	89 4c 24 14          	mov    %ecx,0x14(%esp)
f01077f0:	0f b6 ce             	movzbl %dh,%ecx
f01077f3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f01077f7:	0f b6 d2             	movzbl %dl,%edx
f01077fa:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01077fe:	0f b6 d4             	movzbl %ah,%edx
f0107801:	89 54 24 08          	mov    %edx,0x8(%esp)
f0107805:	0f b6 c0             	movzbl %al,%eax
f0107808:	89 44 24 04          	mov    %eax,0x4(%esp)
f010780c:	c7 04 24 a8 a1 10 f0 	movl   $0xf010a1a8,(%esp)
f0107813:	e8 2a cb ff ff       	call   f0104342 <cprintf>
}
f0107818:	83 c4 24             	add    $0x24,%esp
f010781b:	5b                   	pop    %ebx
f010781c:	5d                   	pop    %ebp
f010781d:	c3                   	ret    

f010781e <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f010781e:	55                   	push   %ebp
f010781f:	89 e5                	mov    %esp,%ebp
f0107821:	57                   	push   %edi
f0107822:	56                   	push   %esi
f0107823:	53                   	push   %ebx
f0107824:	83 ec 2c             	sub    $0x2c,%esp
f0107827:	8b 7d 08             	mov    0x8(%ebp),%edi
f010782a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f010782d:	eb 41                	jmp    f0107870 <pci_attach_match+0x52>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f010782f:	39 3b                	cmp    %edi,(%ebx)
f0107831:	75 3a                	jne    f010786d <pci_attach_match+0x4f>
f0107833:	8b 55 0c             	mov    0xc(%ebp),%edx
f0107836:	39 56 04             	cmp    %edx,0x4(%esi)
f0107839:	75 32                	jne    f010786d <pci_attach_match+0x4f>
			int r = list[i].attachfn(pcif);
f010783b:	8b 4d 14             	mov    0x14(%ebp),%ecx
f010783e:	89 0c 24             	mov    %ecx,(%esp)
f0107841:	ff d0                	call   *%eax
			if (r > 0)
f0107843:	85 c0                	test   %eax,%eax
f0107845:	7f 32                	jg     f0107879 <pci_attach_match+0x5b>
				return r;
			if (r < 0)
f0107847:	85 c0                	test   %eax,%eax
f0107849:	79 22                	jns    f010786d <pci_attach_match+0x4f>
				cprintf("pci_attach_match: attaching "
f010784b:	89 44 24 10          	mov    %eax,0x10(%esp)
f010784f:	8b 46 08             	mov    0x8(%esi),%eax
f0107852:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107856:	8b 45 0c             	mov    0xc(%ebp),%eax
f0107859:	89 44 24 08          	mov    %eax,0x8(%esp)
f010785d:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0107861:	c7 04 24 ec a1 10 f0 	movl   $0xf010a1ec,(%esp)
f0107868:	e8 d5 ca ff ff       	call   f0104342 <cprintf>
f010786d:	83 c3 0c             	add    $0xc,%ebx
f0107870:	89 de                	mov    %ebx,%esi
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0107872:	8b 43 08             	mov    0x8(%ebx),%eax
f0107875:	85 c0                	test   %eax,%eax
f0107877:	75 b6                	jne    f010782f <pci_attach_match+0x11>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f0107879:	83 c4 2c             	add    $0x2c,%esp
f010787c:	5b                   	pop    %ebx
f010787d:	5e                   	pop    %esi
f010787e:	5f                   	pop    %edi
f010787f:	5d                   	pop    %ebp
f0107880:	c3                   	ret    

f0107881 <pci_conf1_set_addr>:
static void
pci_conf1_set_addr(uint32_t bus,
		   uint32_t dev,
		   uint32_t func,
		   uint32_t offset)
{
f0107881:	55                   	push   %ebp
f0107882:	89 e5                	mov    %esp,%ebp
f0107884:	56                   	push   %esi
f0107885:	53                   	push   %ebx
f0107886:	83 ec 10             	sub    $0x10,%esp
f0107889:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f010788c:	3d ff 00 00 00       	cmp    $0xff,%eax
f0107891:	76 24                	jbe    f01078b7 <pci_conf1_set_addr+0x36>
f0107893:	c7 44 24 0c 44 a3 10 	movl   $0xf010a344,0xc(%esp)
f010789a:	f0 
f010789b:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01078a2:	f0 
f01078a3:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
f01078aa:	00 
f01078ab:	c7 04 24 4e a3 10 f0 	movl   $0xf010a34e,(%esp)
f01078b2:	e8 89 87 ff ff       	call   f0100040 <_panic>
	assert(dev < 32);
f01078b7:	83 fa 1f             	cmp    $0x1f,%edx
f01078ba:	76 24                	jbe    f01078e0 <pci_conf1_set_addr+0x5f>
f01078bc:	c7 44 24 0c 59 a3 10 	movl   $0xf010a359,0xc(%esp)
f01078c3:	f0 
f01078c4:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01078cb:	f0 
f01078cc:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
f01078d3:	00 
f01078d4:	c7 04 24 4e a3 10 f0 	movl   $0xf010a34e,(%esp)
f01078db:	e8 60 87 ff ff       	call   f0100040 <_panic>
	assert(func < 8);
f01078e0:	83 f9 07             	cmp    $0x7,%ecx
f01078e3:	76 24                	jbe    f0107909 <pci_conf1_set_addr+0x88>
f01078e5:	c7 44 24 0c 62 a3 10 	movl   $0xf010a362,0xc(%esp)
f01078ec:	f0 
f01078ed:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f01078f4:	f0 
f01078f5:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
f01078fc:	00 
f01078fd:	c7 04 24 4e a3 10 f0 	movl   $0xf010a34e,(%esp)
f0107904:	e8 37 87 ff ff       	call   f0100040 <_panic>
	assert(offset < 256);
f0107909:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f010790f:	76 24                	jbe    f0107935 <pci_conf1_set_addr+0xb4>
f0107911:	c7 44 24 0c 6b a3 10 	movl   $0xf010a36b,0xc(%esp)
f0107918:	f0 
f0107919:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0107920:	f0 
f0107921:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
f0107928:	00 
f0107929:	c7 04 24 4e a3 10 f0 	movl   $0xf010a34e,(%esp)
f0107930:	e8 0b 87 ff ff       	call   f0100040 <_panic>
	assert((offset & 0x3) == 0);
f0107935:	f6 c3 03             	test   $0x3,%bl
f0107938:	74 24                	je     f010795e <pci_conf1_set_addr+0xdd>
f010793a:	c7 44 24 0c 78 a3 10 	movl   $0xf010a378,0xc(%esp)
f0107941:	f0 
f0107942:	c7 44 24 08 cb 92 10 	movl   $0xf01092cb,0x8(%esp)
f0107949:	f0 
f010794a:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
f0107951:	00 
f0107952:	c7 04 24 4e a3 10 f0 	movl   $0xf010a34e,(%esp)
f0107959:	e8 e2 86 ff ff       	call   f0100040 <_panic>

	uint32_t v = (1 << 31) |		// config-space
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f010795e:	81 cb 00 00 00 80    	or     $0x80000000,%ebx
f0107964:	c1 e1 08             	shl    $0x8,%ecx
f0107967:	09 cb                	or     %ecx,%ebx
f0107969:	89 d6                	mov    %edx,%esi
f010796b:	c1 e6 0b             	shl    $0xb,%esi
f010796e:	09 f3                	or     %esi,%ebx
f0107970:	c1 e0 10             	shl    $0x10,%eax
f0107973:	89 c6                	mov    %eax,%esi
	assert(dev < 32);
	assert(func < 8);
	assert(offset < 256);
	assert((offset & 0x3) == 0);

	uint32_t v = (1 << 31) |		// config-space
f0107975:	89 d8                	mov    %ebx,%eax
f0107977:	09 f0                	or     %esi,%eax
}

static inline void
outl(int port, uint32_t data)
{
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0107979:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f010797e:	ef                   	out    %eax,(%dx)
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
	outl(pci_conf1_addr_ioport, v);
}
f010797f:	83 c4 10             	add    $0x10,%esp
f0107982:	5b                   	pop    %ebx
f0107983:	5e                   	pop    %esi
f0107984:	5d                   	pop    %ebp
f0107985:	c3                   	ret    

f0107986 <pci_conf_read>:

static uint32_t
pci_conf_read(struct pci_func *f, uint32_t off)
{
f0107986:	55                   	push   %ebp
f0107987:	89 e5                	mov    %esp,%ebp
f0107989:	53                   	push   %ebx
f010798a:	83 ec 14             	sub    $0x14,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f010798d:	8b 48 08             	mov    0x8(%eax),%ecx
f0107990:	8b 58 04             	mov    0x4(%eax),%ebx
f0107993:	8b 00                	mov    (%eax),%eax
f0107995:	8b 40 04             	mov    0x4(%eax),%eax
f0107998:	89 14 24             	mov    %edx,(%esp)
f010799b:	89 da                	mov    %ebx,%edx
f010799d:	e8 df fe ff ff       	call   f0107881 <pci_conf1_set_addr>

static inline uint32_t
inl(int port)
{
	uint32_t data;
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f01079a2:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f01079a7:	ed                   	in     (%dx),%eax
	return inl(pci_conf1_data_ioport);
}
f01079a8:	83 c4 14             	add    $0x14,%esp
f01079ab:	5b                   	pop    %ebx
f01079ac:	5d                   	pop    %ebp
f01079ad:	c3                   	ret    

f01079ae <pci_scan_bus>:
		f->irq_line);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f01079ae:	55                   	push   %ebp
f01079af:	89 e5                	mov    %esp,%ebp
f01079b1:	57                   	push   %edi
f01079b2:	56                   	push   %esi
f01079b3:	53                   	push   %ebx
f01079b4:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
f01079ba:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f01079bc:	c7 44 24 08 48 00 00 	movl   $0x48,0x8(%esp)
f01079c3:	00 
f01079c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01079cb:	00 
f01079cc:	8d 45 a0             	lea    -0x60(%ebp),%eax
f01079cf:	89 04 24             	mov    %eax,(%esp)
f01079d2:	e8 e0 ed ff ff       	call   f01067b7 <memset>
	df.bus = bus;
f01079d7:	89 5d a0             	mov    %ebx,-0x60(%ebp)

	for (df.dev = 0; df.dev < 32; df.dev++) {
f01079da:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
}

static int
pci_scan_bus(struct pci_bus *bus)
{
	int totaldev = 0;
f01079e1:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f01079e8:	00 00 00 
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;

	for (df.dev = 0; df.dev < 32; df.dev++) {
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f01079eb:	ba 0c 00 00 00       	mov    $0xc,%edx
f01079f0:	8d 45 a0             	lea    -0x60(%ebp),%eax
f01079f3:	e8 8e ff ff ff       	call   f0107986 <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f01079f8:	89 c2                	mov    %eax,%edx
f01079fa:	c1 ea 10             	shr    $0x10,%edx
f01079fd:	83 e2 7f             	and    $0x7f,%edx
f0107a00:	83 fa 01             	cmp    $0x1,%edx
f0107a03:	0f 87 6f 01 00 00    	ja     f0107b78 <pci_scan_bus+0x1ca>
			continue;

		totaldev++;
f0107a09:	83 85 00 ff ff ff 01 	addl   $0x1,-0x100(%ebp)

		struct pci_func f = df;
f0107a10:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107a15:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f0107a1b:	8d 75 a0             	lea    -0x60(%ebp),%esi
f0107a1e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107a20:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f0107a27:	00 00 00 
f0107a2a:	25 00 00 80 00       	and    $0x800000,%eax
f0107a2f:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
		     f.func++) {
			struct pci_func af = f;
f0107a35:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
			continue;

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107a3b:	e9 1d 01 00 00       	jmp    f0107b5d <pci_scan_bus+0x1af>
		     f.func++) {
			struct pci_func af = f;
f0107a40:	b9 12 00 00 00       	mov    $0x12,%ecx
f0107a45:	89 df                	mov    %ebx,%edi
f0107a47:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f0107a4d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f0107a4f:	ba 00 00 00 00       	mov    $0x0,%edx
f0107a54:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f0107a5a:	e8 27 ff ff ff       	call   f0107986 <pci_conf_read>
f0107a5f:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f0107a65:	66 83 f8 ff          	cmp    $0xffff,%ax
f0107a69:	0f 84 e7 00 00 00    	je     f0107b56 <pci_scan_bus+0x1a8>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0107a6f:	ba 3c 00 00 00       	mov    $0x3c,%edx
f0107a74:	89 d8                	mov    %ebx,%eax
f0107a76:	e8 0b ff ff ff       	call   f0107986 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f0107a7b:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0107a7e:	ba 08 00 00 00       	mov    $0x8,%edx
f0107a83:	89 d8                	mov    %ebx,%eax
f0107a85:	e8 fc fe ff ff       	call   f0107986 <pci_conf_read>
f0107a8a:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)

static void
pci_print_func(struct pci_func *f)
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0107a90:	89 c2                	mov    %eax,%edx
f0107a92:	c1 ea 18             	shr    $0x18,%edx
};

static void
pci_print_func(struct pci_func *f)
{
	const char *class = pci_class[0];
f0107a95:	b9 8c a3 10 f0       	mov    $0xf010a38c,%ecx
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0107a9a:	83 fa 06             	cmp    $0x6,%edx
f0107a9d:	77 07                	ja     f0107aa6 <pci_scan_bus+0xf8>
		class = pci_class[PCI_CLASS(f->dev_class)];
f0107a9f:	8b 0c 95 00 a4 10 f0 	mov    -0xfef5c00(,%edx,4),%ecx

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0107aa6:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
		class = pci_class[PCI_CLASS(f->dev_class)];

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0107aac:	0f b6 7d 9c          	movzbl -0x64(%ebp),%edi
f0107ab0:	89 7c 24 24          	mov    %edi,0x24(%esp)
f0107ab4:	89 4c 24 20          	mov    %ecx,0x20(%esp)
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class), class,
f0107ab8:	c1 e8 10             	shr    $0x10,%eax
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
		class = pci_class[PCI_CLASS(f->dev_class)];

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0107abb:	0f b6 c0             	movzbl %al,%eax
f0107abe:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f0107ac2:	89 54 24 18          	mov    %edx,0x18(%esp)
f0107ac6:	89 f0                	mov    %esi,%eax
f0107ac8:	c1 e8 10             	shr    $0x10,%eax
f0107acb:	89 44 24 14          	mov    %eax,0x14(%esp)
f0107acf:	0f b7 f6             	movzwl %si,%esi
f0107ad2:	89 74 24 10          	mov    %esi,0x10(%esp)
f0107ad6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
f0107adc:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107ae0:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
f0107ae6:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107aea:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f0107af0:	8b 40 04             	mov    0x4(%eax),%eax
f0107af3:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107af7:	c7 04 24 18 a2 10 f0 	movl   $0xf010a218,(%esp)
f0107afe:	e8 3f c8 ff ff       	call   f0104342 <cprintf>
static int
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
				 PCI_SUBCLASS(f->dev_class),
f0107b03:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax

static int
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
f0107b09:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0107b0d:	c7 44 24 08 0c 64 12 	movl   $0xf012640c,0x8(%esp)
f0107b14:	f0 
				 PCI_SUBCLASS(f->dev_class),
f0107b15:	89 c2                	mov    %eax,%edx
f0107b17:	c1 ea 10             	shr    $0x10,%edx

static int
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
f0107b1a:	0f b6 d2             	movzbl %dl,%edx
f0107b1d:	89 54 24 04          	mov    %edx,0x4(%esp)
f0107b21:	c1 e8 18             	shr    $0x18,%eax
f0107b24:	89 04 24             	mov    %eax,(%esp)
f0107b27:	e8 f2 fc ff ff       	call   f010781e <pci_attach_match>
				 PCI_SUBCLASS(f->dev_class),
				 &pci_attach_class[0], f) ||
f0107b2c:	85 c0                	test   %eax,%eax
f0107b2e:	75 26                	jne    f0107b56 <pci_scan_bus+0x1a8>
		pci_attach_match(PCI_VENDOR(f->dev_id),
				 PCI_PRODUCT(f->dev_id),
f0107b30:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class),
				 PCI_SUBCLASS(f->dev_class),
				 &pci_attach_class[0], f) ||
		pci_attach_match(PCI_VENDOR(f->dev_id),
f0107b36:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0107b3a:	c7 44 24 08 f4 63 12 	movl   $0xf01263f4,0x8(%esp)
f0107b41:	f0 
f0107b42:	89 c2                	mov    %eax,%edx
f0107b44:	c1 ea 10             	shr    $0x10,%edx
f0107b47:	89 54 24 04          	mov    %edx,0x4(%esp)
f0107b4b:	0f b7 c0             	movzwl %ax,%eax
f0107b4e:	89 04 24             	mov    %eax,(%esp)
f0107b51:	e8 c8 fc ff ff       	call   f010781e <pci_attach_match>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f0107b56:	83 85 18 ff ff ff 01 	addl   $0x1,-0xe8(%ebp)
			continue;

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0107b5d:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
f0107b64:	19 c0                	sbb    %eax,%eax
f0107b66:	83 e0 f9             	and    $0xfffffff9,%eax
f0107b69:	83 c0 08             	add    $0x8,%eax
f0107b6c:	3b 85 18 ff ff ff    	cmp    -0xe8(%ebp),%eax
f0107b72:	0f 87 c8 fe ff ff    	ja     f0107a40 <pci_scan_bus+0x92>
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0107b78:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0107b7b:	83 c0 01             	add    $0x1,%eax
f0107b7e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0107b81:	83 f8 1f             	cmp    $0x1f,%eax
f0107b84:	0f 86 61 fe ff ff    	jbe    f01079eb <pci_scan_bus+0x3d>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f0107b8a:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f0107b90:	81 c4 1c 01 00 00    	add    $0x11c,%esp
f0107b96:	5b                   	pop    %ebx
f0107b97:	5e                   	pop    %esi
f0107b98:	5f                   	pop    %edi
f0107b99:	5d                   	pop    %ebp
f0107b9a:	c3                   	ret    

f0107b9b <pci_bridge_attach>:

static int
pci_bridge_attach(struct pci_func *pcif)
{
f0107b9b:	55                   	push   %ebp
f0107b9c:	89 e5                	mov    %esp,%ebp
f0107b9e:	57                   	push   %edi
f0107b9f:	56                   	push   %esi
f0107ba0:	53                   	push   %ebx
f0107ba1:	83 ec 3c             	sub    $0x3c,%esp
f0107ba4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f0107ba7:	ba 1c 00 00 00       	mov    $0x1c,%edx
f0107bac:	89 d8                	mov    %ebx,%eax
f0107bae:	e8 d3 fd ff ff       	call   f0107986 <pci_conf_read>
f0107bb3:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0107bb5:	ba 18 00 00 00       	mov    $0x18,%edx
f0107bba:	89 d8                	mov    %ebx,%eax
f0107bbc:	e8 c5 fd ff ff       	call   f0107986 <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0107bc1:	83 e7 0f             	and    $0xf,%edi
f0107bc4:	83 ff 01             	cmp    $0x1,%edi
f0107bc7:	75 2a                	jne    f0107bf3 <pci_bridge_attach+0x58>
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f0107bc9:	8b 43 08             	mov    0x8(%ebx),%eax
f0107bcc:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107bd0:	8b 43 04             	mov    0x4(%ebx),%eax
f0107bd3:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107bd7:	8b 03                	mov    (%ebx),%eax
f0107bd9:	8b 40 04             	mov    0x4(%eax),%eax
f0107bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107be0:	c7 04 24 54 a2 10 f0 	movl   $0xf010a254,(%esp)
f0107be7:	e8 56 c7 ff ff       	call   f0104342 <cprintf>
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
f0107bec:	b8 00 00 00 00       	mov    $0x0,%eax
f0107bf1:	eb 67                	jmp    f0107c5a <pci_bridge_attach+0xbf>
f0107bf3:	89 c6                	mov    %eax,%esi
	}

	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f0107bf5:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f0107bfc:	00 
f0107bfd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107c04:	00 
f0107c05:	8d 7d e0             	lea    -0x20(%ebp),%edi
f0107c08:	89 3c 24             	mov    %edi,(%esp)
f0107c0b:	e8 a7 eb ff ff       	call   f01067b7 <memset>
	nbus.parent_bridge = pcif;
f0107c10:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f0107c13:	89 f0                	mov    %esi,%eax
f0107c15:	0f b6 c4             	movzbl %ah,%eax
f0107c18:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f0107c1b:	89 f2                	mov    %esi,%edx
f0107c1d:	c1 ea 10             	shr    $0x10,%edx
	memset(&nbus, 0, sizeof(nbus));
	nbus.parent_bridge = pcif;
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;

	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0107c20:	0f b6 f2             	movzbl %dl,%esi
f0107c23:	89 74 24 14          	mov    %esi,0x14(%esp)
f0107c27:	89 44 24 10          	mov    %eax,0x10(%esp)
f0107c2b:	8b 43 08             	mov    0x8(%ebx),%eax
f0107c2e:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107c32:	8b 43 04             	mov    0x4(%ebx),%eax
f0107c35:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107c39:	8b 03                	mov    (%ebx),%eax
f0107c3b:	8b 40 04             	mov    0x4(%eax),%eax
f0107c3e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107c42:	c7 04 24 88 a2 10 f0 	movl   $0xf010a288,(%esp)
f0107c49:	e8 f4 c6 ff ff       	call   f0104342 <cprintf>
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);

	pci_scan_bus(&nbus);
f0107c4e:	89 f8                	mov    %edi,%eax
f0107c50:	e8 59 fd ff ff       	call   f01079ae <pci_scan_bus>
	return 1;
f0107c55:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0107c5a:	83 c4 3c             	add    $0x3c,%esp
f0107c5d:	5b                   	pop    %ebx
f0107c5e:	5e                   	pop    %esi
f0107c5f:	5f                   	pop    %edi
f0107c60:	5d                   	pop    %ebp
f0107c61:	c3                   	ret    

f0107c62 <pci_conf_write>:
	return inl(pci_conf1_data_ioport);
}

static void
pci_conf_write(struct pci_func *f, uint32_t off, uint32_t v)
{
f0107c62:	55                   	push   %ebp
f0107c63:	89 e5                	mov    %esp,%ebp
f0107c65:	56                   	push   %esi
f0107c66:	53                   	push   %ebx
f0107c67:	83 ec 10             	sub    $0x10,%esp
f0107c6a:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0107c6c:	8b 48 08             	mov    0x8(%eax),%ecx
f0107c6f:	8b 70 04             	mov    0x4(%eax),%esi
f0107c72:	8b 00                	mov    (%eax),%eax
f0107c74:	8b 40 04             	mov    0x4(%eax),%eax
f0107c77:	89 14 24             	mov    %edx,(%esp)
f0107c7a:	89 f2                	mov    %esi,%edx
f0107c7c:	e8 00 fc ff ff       	call   f0107881 <pci_conf1_set_addr>
}

static inline void
outl(int port, uint32_t data)
{
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0107c81:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0107c86:	89 d8                	mov    %ebx,%eax
f0107c88:	ef                   	out    %eax,(%dx)
	outl(pci_conf1_data_ioport, v);
}
f0107c89:	83 c4 10             	add    $0x10,%esp
f0107c8c:	5b                   	pop    %ebx
f0107c8d:	5e                   	pop    %esi
f0107c8e:	5d                   	pop    %ebp
f0107c8f:	c3                   	ret    

f0107c90 <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f0107c90:	55                   	push   %ebp
f0107c91:	89 e5                	mov    %esp,%ebp
f0107c93:	57                   	push   %edi
f0107c94:	56                   	push   %esi
f0107c95:	53                   	push   %ebx
f0107c96:	83 ec 4c             	sub    $0x4c,%esp
f0107c99:	8b 7d 08             	mov    0x8(%ebp),%edi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f0107c9c:	b9 07 00 00 00       	mov    $0x7,%ecx
f0107ca1:	ba 04 00 00 00       	mov    $0x4,%edx
f0107ca6:	89 f8                	mov    %edi,%eax
f0107ca8:	e8 b5 ff ff ff       	call   f0107c62 <pci_conf_write>
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107cad:	be 10 00 00 00       	mov    $0x10,%esi
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);
f0107cb2:	89 f2                	mov    %esi,%edx
f0107cb4:	89 f8                	mov    %edi,%eax
f0107cb6:	e8 cb fc ff ff       	call   f0107986 <pci_conf_read>
f0107cbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		bar_width = 4;
		pci_conf_write(f, bar, 0xffffffff);
f0107cbe:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0107cc3:	89 f2                	mov    %esi,%edx
f0107cc5:	89 f8                	mov    %edi,%eax
f0107cc7:	e8 96 ff ff ff       	call   f0107c62 <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f0107ccc:	89 f2                	mov    %esi,%edx
f0107cce:	89 f8                	mov    %edi,%eax
f0107cd0:	e8 b1 fc ff ff       	call   f0107986 <pci_conf_read>
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);

		bar_width = 4;
f0107cd5:	bb 04 00 00 00       	mov    $0x4,%ebx
		pci_conf_write(f, bar, 0xffffffff);
		uint32_t rv = pci_conf_read(f, bar);

		if (rv == 0)
f0107cda:	85 c0                	test   %eax,%eax
f0107cdc:	0f 84 c1 00 00 00    	je     f0107da3 <pci_func_enable+0x113>
			continue;

		int regnum = PCI_MAPREG_NUM(bar);
f0107ce2:	8d 56 f0             	lea    -0x10(%esi),%edx
f0107ce5:	c1 ea 02             	shr    $0x2,%edx
f0107ce8:	89 55 dc             	mov    %edx,-0x24(%ebp)
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0107ceb:	a8 01                	test   $0x1,%al
f0107ced:	75 2c                	jne    f0107d1b <pci_func_enable+0x8b>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f0107cef:	89 c2                	mov    %eax,%edx
f0107cf1:	83 e2 06             	and    $0x6,%edx
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);

		bar_width = 4;
f0107cf4:	83 fa 04             	cmp    $0x4,%edx
f0107cf7:	0f 94 c3             	sete   %bl
f0107cfa:	0f b6 db             	movzbl %bl,%ebx
f0107cfd:	8d 1c 9d 04 00 00 00 	lea    0x4(,%ebx,4),%ebx
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
				bar_width = 8;

			size = PCI_MAPREG_MEM_SIZE(rv);
f0107d04:	83 e0 f0             	and    $0xfffffff0,%eax
f0107d07:	89 c2                	mov    %eax,%edx
f0107d09:	f7 da                	neg    %edx
f0107d0b:	21 d0                	and    %edx,%eax
f0107d0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = PCI_MAPREG_MEM_ADDR(oldv);
f0107d10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0107d13:	83 e0 f0             	and    $0xfffffff0,%eax
f0107d16:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0107d19:	eb 1a                	jmp    f0107d35 <pci_func_enable+0xa5>
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f0107d1b:	83 e0 fc             	and    $0xfffffffc,%eax
f0107d1e:	89 c2                	mov    %eax,%edx
f0107d20:	f7 da                	neg    %edx
f0107d22:	21 d0                	and    %edx,%eax
f0107d24:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = PCI_MAPREG_IO_ADDR(oldv);
f0107d27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0107d2a:	83 e0 fc             	and    $0xfffffffc,%eax
f0107d2d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);

		bar_width = 4;
f0107d30:	bb 04 00 00 00       	mov    $0x4,%ebx
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}

		pci_conf_write(f, bar, oldv);
f0107d35:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0107d38:	89 f2                	mov    %esi,%edx
f0107d3a:	89 f8                	mov    %edi,%eax
f0107d3c:	e8 21 ff ff ff       	call   f0107c62 <pci_conf_write>
f0107d41:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0107d44:	8d 04 87             	lea    (%edi,%eax,4),%eax
		f->reg_base[regnum] = base;
f0107d47:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0107d4a:	89 48 14             	mov    %ecx,0x14(%eax)
		f->reg_size[regnum] = size;
f0107d4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0107d50:	89 50 2c             	mov    %edx,0x2c(%eax)

		if (size && !base)
f0107d53:	85 c9                	test   %ecx,%ecx
f0107d55:	75 4c                	jne    f0107da3 <pci_func_enable+0x113>
f0107d57:	85 d2                	test   %edx,%edx
f0107d59:	74 48                	je     f0107da3 <pci_func_enable+0x113>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0107d5b:	8b 47 0c             	mov    0xc(%edi),%eax
		pci_conf_write(f, bar, oldv);
		f->reg_base[regnum] = base;
		f->reg_size[regnum] = size;

		if (size && !base)
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f0107d5e:	89 54 24 20          	mov    %edx,0x20(%esp)
f0107d62:	8b 4d d8             	mov    -0x28(%ebp),%ecx
f0107d65:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
f0107d69:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0107d6c:	89 4c 24 18          	mov    %ecx,0x18(%esp)
f0107d70:	89 c2                	mov    %eax,%edx
f0107d72:	c1 ea 10             	shr    $0x10,%edx
f0107d75:	89 54 24 14          	mov    %edx,0x14(%esp)
f0107d79:	0f b7 c0             	movzwl %ax,%eax
f0107d7c:	89 44 24 10          	mov    %eax,0x10(%esp)
f0107d80:	8b 47 08             	mov    0x8(%edi),%eax
f0107d83:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107d87:	8b 47 04             	mov    0x4(%edi),%eax
f0107d8a:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107d8e:	8b 07                	mov    (%edi),%eax
f0107d90:	8b 40 04             	mov    0x4(%eax),%eax
f0107d93:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107d97:	c7 04 24 b8 a2 10 f0 	movl   $0xf010a2b8,(%esp)
f0107d9e:	e8 9f c5 ff ff       	call   f0104342 <cprintf>
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
f0107da3:	01 de                	add    %ebx,%esi
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);

	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0107da5:	83 fe 27             	cmp    $0x27,%esi
f0107da8:	0f 86 04 ff ff ff    	jbe    f0107cb2 <pci_func_enable+0x22>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f0107dae:	8b 47 0c             	mov    0xc(%edi),%eax
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f0107db1:	89 c2                	mov    %eax,%edx
f0107db3:	c1 ea 10             	shr    $0x10,%edx
f0107db6:	89 54 24 14          	mov    %edx,0x14(%esp)
f0107dba:	0f b7 c0             	movzwl %ax,%eax
f0107dbd:	89 44 24 10          	mov    %eax,0x10(%esp)
f0107dc1:	8b 47 08             	mov    0x8(%edi),%eax
f0107dc4:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0107dc8:	8b 47 04             	mov    0x4(%edi),%eax
f0107dcb:	89 44 24 08          	mov    %eax,0x8(%esp)
f0107dcf:	8b 07                	mov    (%edi),%eax
f0107dd1:	8b 40 04             	mov    0x4(%eax),%eax
f0107dd4:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107dd8:	c7 04 24 14 a3 10 f0 	movl   $0xf010a314,(%esp)
f0107ddf:	e8 5e c5 ff ff       	call   f0104342 <cprintf>
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
}
f0107de4:	83 c4 4c             	add    $0x4c,%esp
f0107de7:	5b                   	pop    %ebx
f0107de8:	5e                   	pop    %esi
f0107de9:	5f                   	pop    %edi
f0107dea:	5d                   	pop    %ebp
f0107deb:	c3                   	ret    

f0107dec <pci_init>:

int
pci_init(void)
{
f0107dec:	55                   	push   %ebp
f0107ded:	89 e5                	mov    %esp,%ebp
f0107def:	83 ec 18             	sub    $0x18,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0107df2:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f0107df9:	00 
f0107dfa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0107e01:	00 
f0107e02:	c7 04 24 80 9e 2c f0 	movl   $0xf02c9e80,(%esp)
f0107e09:	e8 a9 e9 ff ff       	call   f01067b7 <memset>

	return pci_scan_bus(&root_bus);
f0107e0e:	b8 80 9e 2c f0       	mov    $0xf02c9e80,%eax
f0107e13:	e8 96 fb ff ff       	call   f01079ae <pci_scan_bus>
}
f0107e18:	c9                   	leave  
f0107e19:	c3                   	ret    

f0107e1a <time_init>:

static unsigned int ticks;

void
time_init(void)
{
f0107e1a:	55                   	push   %ebp
f0107e1b:	89 e5                	mov    %esp,%ebp
	ticks = 0;
f0107e1d:	c7 05 88 9e 2c f0 00 	movl   $0x0,0xf02c9e88
f0107e24:	00 00 00 
}
f0107e27:	5d                   	pop    %ebp
f0107e28:	c3                   	ret    

f0107e29 <time_tick>:
// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
	ticks++;
f0107e29:	a1 88 9e 2c f0       	mov    0xf02c9e88,%eax
f0107e2e:	83 c0 01             	add    $0x1,%eax
f0107e31:	a3 88 9e 2c f0       	mov    %eax,0xf02c9e88
	if (ticks * 10 < ticks)
f0107e36:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0107e39:	01 d2                	add    %edx,%edx
f0107e3b:	39 d0                	cmp    %edx,%eax
f0107e3d:	76 22                	jbe    f0107e61 <time_tick+0x38>

// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
f0107e3f:	55                   	push   %ebp
f0107e40:	89 e5                	mov    %esp,%ebp
f0107e42:	83 ec 18             	sub    $0x18,%esp
	ticks++;
	if (ticks * 10 < ticks)
		panic("time_tick: time overflowed");
f0107e45:	c7 44 24 08 1c a4 10 	movl   $0xf010a41c,0x8(%esp)
f0107e4c:	f0 
f0107e4d:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
f0107e54:	00 
f0107e55:	c7 04 24 37 a4 10 f0 	movl   $0xf010a437,(%esp)
f0107e5c:	e8 df 81 ff ff       	call   f0100040 <_panic>
f0107e61:	f3 c3                	repz ret 

f0107e63 <time_msec>:
}

unsigned int
time_msec(void)
{
f0107e63:	55                   	push   %ebp
f0107e64:	89 e5                	mov    %esp,%ebp
	return ticks * 10;
f0107e66:	a1 88 9e 2c f0       	mov    0xf02c9e88,%eax
f0107e6b:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0107e6e:	01 c0                	add    %eax,%eax
}
f0107e70:	5d                   	pop    %ebp
f0107e71:	c3                   	ret    
f0107e72:	66 90                	xchg   %ax,%ax
f0107e74:	66 90                	xchg   %ax,%ax
f0107e76:	66 90                	xchg   %ax,%ax
f0107e78:	66 90                	xchg   %ax,%ax
f0107e7a:	66 90                	xchg   %ax,%ax
f0107e7c:	66 90                	xchg   %ax,%ax
f0107e7e:	66 90                	xchg   %ax,%ax

f0107e80 <__udivdi3>:
f0107e80:	55                   	push   %ebp
f0107e81:	57                   	push   %edi
f0107e82:	56                   	push   %esi
f0107e83:	83 ec 0c             	sub    $0xc,%esp
f0107e86:	8b 44 24 28          	mov    0x28(%esp),%eax
f0107e8a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
f0107e8e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
f0107e92:	8b 4c 24 24          	mov    0x24(%esp),%ecx
f0107e96:	85 c0                	test   %eax,%eax
f0107e98:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0107e9c:	89 ea                	mov    %ebp,%edx
f0107e9e:	89 0c 24             	mov    %ecx,(%esp)
f0107ea1:	75 2d                	jne    f0107ed0 <__udivdi3+0x50>
f0107ea3:	39 e9                	cmp    %ebp,%ecx
f0107ea5:	77 61                	ja     f0107f08 <__udivdi3+0x88>
f0107ea7:	85 c9                	test   %ecx,%ecx
f0107ea9:	89 ce                	mov    %ecx,%esi
f0107eab:	75 0b                	jne    f0107eb8 <__udivdi3+0x38>
f0107ead:	b8 01 00 00 00       	mov    $0x1,%eax
f0107eb2:	31 d2                	xor    %edx,%edx
f0107eb4:	f7 f1                	div    %ecx
f0107eb6:	89 c6                	mov    %eax,%esi
f0107eb8:	31 d2                	xor    %edx,%edx
f0107eba:	89 e8                	mov    %ebp,%eax
f0107ebc:	f7 f6                	div    %esi
f0107ebe:	89 c5                	mov    %eax,%ebp
f0107ec0:	89 f8                	mov    %edi,%eax
f0107ec2:	f7 f6                	div    %esi
f0107ec4:	89 ea                	mov    %ebp,%edx
f0107ec6:	83 c4 0c             	add    $0xc,%esp
f0107ec9:	5e                   	pop    %esi
f0107eca:	5f                   	pop    %edi
f0107ecb:	5d                   	pop    %ebp
f0107ecc:	c3                   	ret    
f0107ecd:	8d 76 00             	lea    0x0(%esi),%esi
f0107ed0:	39 e8                	cmp    %ebp,%eax
f0107ed2:	77 24                	ja     f0107ef8 <__udivdi3+0x78>
f0107ed4:	0f bd e8             	bsr    %eax,%ebp
f0107ed7:	83 f5 1f             	xor    $0x1f,%ebp
f0107eda:	75 3c                	jne    f0107f18 <__udivdi3+0x98>
f0107edc:	8b 74 24 04          	mov    0x4(%esp),%esi
f0107ee0:	39 34 24             	cmp    %esi,(%esp)
f0107ee3:	0f 86 9f 00 00 00    	jbe    f0107f88 <__udivdi3+0x108>
f0107ee9:	39 d0                	cmp    %edx,%eax
f0107eeb:	0f 82 97 00 00 00    	jb     f0107f88 <__udivdi3+0x108>
f0107ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0107ef8:	31 d2                	xor    %edx,%edx
f0107efa:	31 c0                	xor    %eax,%eax
f0107efc:	83 c4 0c             	add    $0xc,%esp
f0107eff:	5e                   	pop    %esi
f0107f00:	5f                   	pop    %edi
f0107f01:	5d                   	pop    %ebp
f0107f02:	c3                   	ret    
f0107f03:	90                   	nop
f0107f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0107f08:	89 f8                	mov    %edi,%eax
f0107f0a:	f7 f1                	div    %ecx
f0107f0c:	31 d2                	xor    %edx,%edx
f0107f0e:	83 c4 0c             	add    $0xc,%esp
f0107f11:	5e                   	pop    %esi
f0107f12:	5f                   	pop    %edi
f0107f13:	5d                   	pop    %ebp
f0107f14:	c3                   	ret    
f0107f15:	8d 76 00             	lea    0x0(%esi),%esi
f0107f18:	89 e9                	mov    %ebp,%ecx
f0107f1a:	8b 3c 24             	mov    (%esp),%edi
f0107f1d:	d3 e0                	shl    %cl,%eax
f0107f1f:	89 c6                	mov    %eax,%esi
f0107f21:	b8 20 00 00 00       	mov    $0x20,%eax
f0107f26:	29 e8                	sub    %ebp,%eax
f0107f28:	89 c1                	mov    %eax,%ecx
f0107f2a:	d3 ef                	shr    %cl,%edi
f0107f2c:	89 e9                	mov    %ebp,%ecx
f0107f2e:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0107f32:	8b 3c 24             	mov    (%esp),%edi
f0107f35:	09 74 24 08          	or     %esi,0x8(%esp)
f0107f39:	89 d6                	mov    %edx,%esi
f0107f3b:	d3 e7                	shl    %cl,%edi
f0107f3d:	89 c1                	mov    %eax,%ecx
f0107f3f:	89 3c 24             	mov    %edi,(%esp)
f0107f42:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0107f46:	d3 ee                	shr    %cl,%esi
f0107f48:	89 e9                	mov    %ebp,%ecx
f0107f4a:	d3 e2                	shl    %cl,%edx
f0107f4c:	89 c1                	mov    %eax,%ecx
f0107f4e:	d3 ef                	shr    %cl,%edi
f0107f50:	09 d7                	or     %edx,%edi
f0107f52:	89 f2                	mov    %esi,%edx
f0107f54:	89 f8                	mov    %edi,%eax
f0107f56:	f7 74 24 08          	divl   0x8(%esp)
f0107f5a:	89 d6                	mov    %edx,%esi
f0107f5c:	89 c7                	mov    %eax,%edi
f0107f5e:	f7 24 24             	mull   (%esp)
f0107f61:	39 d6                	cmp    %edx,%esi
f0107f63:	89 14 24             	mov    %edx,(%esp)
f0107f66:	72 30                	jb     f0107f98 <__udivdi3+0x118>
f0107f68:	8b 54 24 04          	mov    0x4(%esp),%edx
f0107f6c:	89 e9                	mov    %ebp,%ecx
f0107f6e:	d3 e2                	shl    %cl,%edx
f0107f70:	39 c2                	cmp    %eax,%edx
f0107f72:	73 05                	jae    f0107f79 <__udivdi3+0xf9>
f0107f74:	3b 34 24             	cmp    (%esp),%esi
f0107f77:	74 1f                	je     f0107f98 <__udivdi3+0x118>
f0107f79:	89 f8                	mov    %edi,%eax
f0107f7b:	31 d2                	xor    %edx,%edx
f0107f7d:	e9 7a ff ff ff       	jmp    f0107efc <__udivdi3+0x7c>
f0107f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0107f88:	31 d2                	xor    %edx,%edx
f0107f8a:	b8 01 00 00 00       	mov    $0x1,%eax
f0107f8f:	e9 68 ff ff ff       	jmp    f0107efc <__udivdi3+0x7c>
f0107f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0107f98:	8d 47 ff             	lea    -0x1(%edi),%eax
f0107f9b:	31 d2                	xor    %edx,%edx
f0107f9d:	83 c4 0c             	add    $0xc,%esp
f0107fa0:	5e                   	pop    %esi
f0107fa1:	5f                   	pop    %edi
f0107fa2:	5d                   	pop    %ebp
f0107fa3:	c3                   	ret    
f0107fa4:	66 90                	xchg   %ax,%ax
f0107fa6:	66 90                	xchg   %ax,%ax
f0107fa8:	66 90                	xchg   %ax,%ax
f0107faa:	66 90                	xchg   %ax,%ax
f0107fac:	66 90                	xchg   %ax,%ax
f0107fae:	66 90                	xchg   %ax,%ax

f0107fb0 <__umoddi3>:
f0107fb0:	55                   	push   %ebp
f0107fb1:	57                   	push   %edi
f0107fb2:	56                   	push   %esi
f0107fb3:	83 ec 14             	sub    $0x14,%esp
f0107fb6:	8b 44 24 28          	mov    0x28(%esp),%eax
f0107fba:	8b 4c 24 24          	mov    0x24(%esp),%ecx
f0107fbe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
f0107fc2:	89 c7                	mov    %eax,%edi
f0107fc4:	89 44 24 04          	mov    %eax,0x4(%esp)
f0107fc8:	8b 44 24 30          	mov    0x30(%esp),%eax
f0107fcc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
f0107fd0:	89 34 24             	mov    %esi,(%esp)
f0107fd3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107fd7:	85 c0                	test   %eax,%eax
f0107fd9:	89 c2                	mov    %eax,%edx
f0107fdb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0107fdf:	75 17                	jne    f0107ff8 <__umoddi3+0x48>
f0107fe1:	39 fe                	cmp    %edi,%esi
f0107fe3:	76 4b                	jbe    f0108030 <__umoddi3+0x80>
f0107fe5:	89 c8                	mov    %ecx,%eax
f0107fe7:	89 fa                	mov    %edi,%edx
f0107fe9:	f7 f6                	div    %esi
f0107feb:	89 d0                	mov    %edx,%eax
f0107fed:	31 d2                	xor    %edx,%edx
f0107fef:	83 c4 14             	add    $0x14,%esp
f0107ff2:	5e                   	pop    %esi
f0107ff3:	5f                   	pop    %edi
f0107ff4:	5d                   	pop    %ebp
f0107ff5:	c3                   	ret    
f0107ff6:	66 90                	xchg   %ax,%ax
f0107ff8:	39 f8                	cmp    %edi,%eax
f0107ffa:	77 54                	ja     f0108050 <__umoddi3+0xa0>
f0107ffc:	0f bd e8             	bsr    %eax,%ebp
f0107fff:	83 f5 1f             	xor    $0x1f,%ebp
f0108002:	75 5c                	jne    f0108060 <__umoddi3+0xb0>
f0108004:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0108008:	39 3c 24             	cmp    %edi,(%esp)
f010800b:	0f 87 e7 00 00 00    	ja     f01080f8 <__umoddi3+0x148>
f0108011:	8b 7c 24 04          	mov    0x4(%esp),%edi
f0108015:	29 f1                	sub    %esi,%ecx
f0108017:	19 c7                	sbb    %eax,%edi
f0108019:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010801d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f0108021:	8b 44 24 08          	mov    0x8(%esp),%eax
f0108025:	8b 54 24 0c          	mov    0xc(%esp),%edx
f0108029:	83 c4 14             	add    $0x14,%esp
f010802c:	5e                   	pop    %esi
f010802d:	5f                   	pop    %edi
f010802e:	5d                   	pop    %ebp
f010802f:	c3                   	ret    
f0108030:	85 f6                	test   %esi,%esi
f0108032:	89 f5                	mov    %esi,%ebp
f0108034:	75 0b                	jne    f0108041 <__umoddi3+0x91>
f0108036:	b8 01 00 00 00       	mov    $0x1,%eax
f010803b:	31 d2                	xor    %edx,%edx
f010803d:	f7 f6                	div    %esi
f010803f:	89 c5                	mov    %eax,%ebp
f0108041:	8b 44 24 04          	mov    0x4(%esp),%eax
f0108045:	31 d2                	xor    %edx,%edx
f0108047:	f7 f5                	div    %ebp
f0108049:	89 c8                	mov    %ecx,%eax
f010804b:	f7 f5                	div    %ebp
f010804d:	eb 9c                	jmp    f0107feb <__umoddi3+0x3b>
f010804f:	90                   	nop
f0108050:	89 c8                	mov    %ecx,%eax
f0108052:	89 fa                	mov    %edi,%edx
f0108054:	83 c4 14             	add    $0x14,%esp
f0108057:	5e                   	pop    %esi
f0108058:	5f                   	pop    %edi
f0108059:	5d                   	pop    %ebp
f010805a:	c3                   	ret    
f010805b:	90                   	nop
f010805c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0108060:	8b 04 24             	mov    (%esp),%eax
f0108063:	be 20 00 00 00       	mov    $0x20,%esi
f0108068:	89 e9                	mov    %ebp,%ecx
f010806a:	29 ee                	sub    %ebp,%esi
f010806c:	d3 e2                	shl    %cl,%edx
f010806e:	89 f1                	mov    %esi,%ecx
f0108070:	d3 e8                	shr    %cl,%eax
f0108072:	89 e9                	mov    %ebp,%ecx
f0108074:	89 44 24 04          	mov    %eax,0x4(%esp)
f0108078:	8b 04 24             	mov    (%esp),%eax
f010807b:	09 54 24 04          	or     %edx,0x4(%esp)
f010807f:	89 fa                	mov    %edi,%edx
f0108081:	d3 e0                	shl    %cl,%eax
f0108083:	89 f1                	mov    %esi,%ecx
f0108085:	89 44 24 08          	mov    %eax,0x8(%esp)
f0108089:	8b 44 24 10          	mov    0x10(%esp),%eax
f010808d:	d3 ea                	shr    %cl,%edx
f010808f:	89 e9                	mov    %ebp,%ecx
f0108091:	d3 e7                	shl    %cl,%edi
f0108093:	89 f1                	mov    %esi,%ecx
f0108095:	d3 e8                	shr    %cl,%eax
f0108097:	89 e9                	mov    %ebp,%ecx
f0108099:	09 f8                	or     %edi,%eax
f010809b:	8b 7c 24 10          	mov    0x10(%esp),%edi
f010809f:	f7 74 24 04          	divl   0x4(%esp)
f01080a3:	d3 e7                	shl    %cl,%edi
f01080a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01080a9:	89 d7                	mov    %edx,%edi
f01080ab:	f7 64 24 08          	mull   0x8(%esp)
f01080af:	39 d7                	cmp    %edx,%edi
f01080b1:	89 c1                	mov    %eax,%ecx
f01080b3:	89 14 24             	mov    %edx,(%esp)
f01080b6:	72 2c                	jb     f01080e4 <__umoddi3+0x134>
f01080b8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
f01080bc:	72 22                	jb     f01080e0 <__umoddi3+0x130>
f01080be:	8b 44 24 0c          	mov    0xc(%esp),%eax
f01080c2:	29 c8                	sub    %ecx,%eax
f01080c4:	19 d7                	sbb    %edx,%edi
f01080c6:	89 e9                	mov    %ebp,%ecx
f01080c8:	89 fa                	mov    %edi,%edx
f01080ca:	d3 e8                	shr    %cl,%eax
f01080cc:	89 f1                	mov    %esi,%ecx
f01080ce:	d3 e2                	shl    %cl,%edx
f01080d0:	89 e9                	mov    %ebp,%ecx
f01080d2:	d3 ef                	shr    %cl,%edi
f01080d4:	09 d0                	or     %edx,%eax
f01080d6:	89 fa                	mov    %edi,%edx
f01080d8:	83 c4 14             	add    $0x14,%esp
f01080db:	5e                   	pop    %esi
f01080dc:	5f                   	pop    %edi
f01080dd:	5d                   	pop    %ebp
f01080de:	c3                   	ret    
f01080df:	90                   	nop
f01080e0:	39 d7                	cmp    %edx,%edi
f01080e2:	75 da                	jne    f01080be <__umoddi3+0x10e>
f01080e4:	8b 14 24             	mov    (%esp),%edx
f01080e7:	89 c1                	mov    %eax,%ecx
f01080e9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
f01080ed:	1b 54 24 04          	sbb    0x4(%esp),%edx
f01080f1:	eb cb                	jmp    f01080be <__umoddi3+0x10e>
f01080f3:	90                   	nop
f01080f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01080f8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
f01080fc:	0f 82 0f ff ff ff    	jb     f0108011 <__umoddi3+0x61>
f0108102:	e9 1a ff ff ff       	jmp    f0108021 <__umoddi3+0x71>
