
obj/fs/fs:     file format elf32-i386


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
  80002c:	e8 41 1d 00 00       	call   801d72 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
		return -1;
	return 0;
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	53                   	push   %ebx
  800063:	83 ec 14             	sub    $0x14,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  800066:	b8 00 00 00 00       	mov    $0x0,%eax
  80006b:	e8 c3 ff ff ff       	call   800033 <ide_wait_ready>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800070:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800075:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80007a:	ee                   	out    %al,(%dx)

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80007b:	b9 00 00 00 00       	mov    $0x0,%ecx

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800080:	b2 f7                	mov    $0xf7,%dl
  800082:	eb 0b                	jmp    80008f <ide_probe_disk1+0x30>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
	     x++)
  800084:	83 c1 01             	add    $0x1,%ecx

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  800087:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  80008d:	74 05                	je     800094 <ide_probe_disk1+0x35>
  80008f:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  800090:	a8 a1                	test   $0xa1,%al
  800092:	75 f0                	jne    800084 <ide_probe_disk1+0x25>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800094:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800099:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80009e:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  80009f:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000a5:	0f 9e c3             	setle  %bl
  8000a8:	0f b6 c3             	movzbl %bl,%eax
  8000ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000af:	c7 04 24 20 44 80 00 	movl   $0x804420,(%esp)
  8000b6:	e8 11 1e 00 00       	call   801ecc <cprintf>
	return (x < 1000);
}
  8000bb:	89 d8                	mov    %ebx,%eax
  8000bd:	83 c4 14             	add    $0x14,%esp
  8000c0:	5b                   	pop    %ebx
  8000c1:	5d                   	pop    %ebp
  8000c2:	c3                   	ret    

008000c3 <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000c3:	55                   	push   %ebp
  8000c4:	89 e5                	mov    %esp,%ebp
  8000c6:	83 ec 18             	sub    $0x18,%esp
  8000c9:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000cc:	83 f8 01             	cmp    $0x1,%eax
  8000cf:	76 1c                	jbe    8000ed <ide_set_disk+0x2a>
		panic("bad disk number");
  8000d1:	c7 44 24 08 37 44 80 	movl   $0x804437,0x8(%esp)
  8000d8:	00 
  8000d9:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8000e0:	00 
  8000e1:	c7 04 24 47 44 80 00 	movl   $0x804447,(%esp)
  8000e8:	e8 e6 1c 00 00       	call   801dd3 <_panic>
	diskno = d;
  8000ed:	a3 00 50 80 00       	mov    %eax,0x805000
}
  8000f2:	c9                   	leave  
  8000f3:	c3                   	ret    

008000f4 <ide_read>:


int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	57                   	push   %edi
  8000f8:	56                   	push   %esi
  8000f9:	53                   	push   %ebx
  8000fa:	83 ec 1c             	sub    $0x1c,%esp
  8000fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800100:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800103:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  800106:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  80010c:	76 24                	jbe    800132 <ide_read+0x3e>
  80010e:	c7 44 24 0c 50 44 80 	movl   $0x804450,0xc(%esp)
  800115:	00 
  800116:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  80011d:	00 
  80011e:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  800125:	00 
  800126:	c7 04 24 47 44 80 00 	movl   $0x804447,(%esp)
  80012d:	e8 a1 1c 00 00       	call   801dd3 <_panic>

	ide_wait_ready(0);
  800132:	b8 00 00 00 00       	mov    $0x0,%eax
  800137:	e8 f7 fe ff ff       	call   800033 <ide_wait_ready>
  80013c:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800141:	89 f0                	mov    %esi,%eax
  800143:	ee                   	out    %al,(%dx)
  800144:	b2 f3                	mov    $0xf3,%dl
  800146:	89 f8                	mov    %edi,%eax
  800148:	ee                   	out    %al,(%dx)
  800149:	89 f8                	mov    %edi,%eax
  80014b:	0f b6 c4             	movzbl %ah,%eax
  80014e:	b2 f4                	mov    $0xf4,%dl
  800150:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
  800151:	89 f8                	mov    %edi,%eax
  800153:	c1 e8 10             	shr    $0x10,%eax
  800156:	b2 f5                	mov    $0xf5,%dl
  800158:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800159:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800160:	83 e0 01             	and    $0x1,%eax
  800163:	c1 e0 04             	shl    $0x4,%eax
  800166:	83 c8 e0             	or     $0xffffffe0,%eax
  800169:	c1 ef 18             	shr    $0x18,%edi
  80016c:	83 e7 0f             	and    $0xf,%edi
  80016f:	09 f8                	or     %edi,%eax
  800171:	b2 f6                	mov    $0xf6,%dl
  800173:	ee                   	out    %al,(%dx)
  800174:	b2 f7                	mov    $0xf7,%dl
  800176:	b8 20 00 00 00       	mov    $0x20,%eax
  80017b:	ee                   	out    %al,(%dx)
  80017c:	c1 e6 09             	shl    $0x9,%esi
  80017f:	01 de                	add    %ebx,%esi
  800181:	eb 23                	jmp    8001a6 <ide_read+0xb2>
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
		if ((r = ide_wait_ready(1)) < 0)
  800183:	b8 01 00 00 00       	mov    $0x1,%eax
  800188:	e8 a6 fe ff ff       	call   800033 <ide_wait_ready>
  80018d:	85 c0                	test   %eax,%eax
  80018f:	78 1e                	js     8001af <ide_read+0xbb>
}

static inline void
insl(int port, void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\tinsl"
  800191:	89 df                	mov    %ebx,%edi
  800193:	b9 80 00 00 00       	mov    $0x80,%ecx
  800198:	ba f0 01 00 00       	mov    $0x1f0,%edx
  80019d:	fc                   	cld    
  80019e:	f2 6d                	repnz insl (%dx),%es:(%edi)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001a0:	81 c3 00 02 00 00    	add    $0x200,%ebx
  8001a6:	39 f3                	cmp    %esi,%ebx
  8001a8:	75 d9                	jne    800183 <ide_read+0x8f>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001af:	83 c4 1c             	add    $0x1c,%esp
  8001b2:	5b                   	pop    %ebx
  8001b3:	5e                   	pop    %esi
  8001b4:	5f                   	pop    %edi
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	57                   	push   %edi
  8001bb:	56                   	push   %esi
  8001bc:	53                   	push   %ebx
  8001bd:	83 ec 1c             	sub    $0x1c,%esp
  8001c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8001c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001c6:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;

	assert(nsecs <= 256);
  8001c9:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  8001cf:	76 24                	jbe    8001f5 <ide_write+0x3e>
  8001d1:	c7 44 24 0c 50 44 80 	movl   $0x804450,0xc(%esp)
  8001d8:	00 
  8001d9:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  8001e0:	00 
  8001e1:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8001e8:	00 
  8001e9:	c7 04 24 47 44 80 00 	movl   $0x804447,(%esp)
  8001f0:	e8 de 1b 00 00       	call   801dd3 <_panic>

	ide_wait_ready(0);
  8001f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8001fa:	e8 34 fe ff ff       	call   800033 <ide_wait_ready>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8001ff:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800204:	89 f8                	mov    %edi,%eax
  800206:	ee                   	out    %al,(%dx)
  800207:	b2 f3                	mov    $0xf3,%dl
  800209:	89 f0                	mov    %esi,%eax
  80020b:	ee                   	out    %al,(%dx)
  80020c:	89 f0                	mov    %esi,%eax
  80020e:	0f b6 c4             	movzbl %ah,%eax
  800211:	b2 f4                	mov    $0xf4,%dl
  800213:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
  800214:	89 f0                	mov    %esi,%eax
  800216:	c1 e8 10             	shr    $0x10,%eax
  800219:	b2 f5                	mov    $0xf5,%dl
  80021b:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  80021c:	0f b6 05 00 50 80 00 	movzbl 0x805000,%eax
  800223:	83 e0 01             	and    $0x1,%eax
  800226:	c1 e0 04             	shl    $0x4,%eax
  800229:	83 c8 e0             	or     $0xffffffe0,%eax
  80022c:	c1 ee 18             	shr    $0x18,%esi
  80022f:	83 e6 0f             	and    $0xf,%esi
  800232:	09 f0                	or     %esi,%eax
  800234:	b2 f6                	mov    $0xf6,%dl
  800236:	ee                   	out    %al,(%dx)
  800237:	b2 f7                	mov    $0xf7,%dl
  800239:	b8 30 00 00 00       	mov    $0x30,%eax
  80023e:	ee                   	out    %al,(%dx)
  80023f:	c1 e7 09             	shl    $0x9,%edi
  800242:	01 df                	add    %ebx,%edi
  800244:	eb 23                	jmp    800269 <ide_write+0xb2>
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
		if ((r = ide_wait_ready(1)) < 0)
  800246:	b8 01 00 00 00       	mov    $0x1,%eax
  80024b:	e8 e3 fd ff ff       	call   800033 <ide_wait_ready>
  800250:	85 c0                	test   %eax,%eax
  800252:	78 1e                	js     800272 <ide_write+0xbb>
}

static inline void
outsl(int port, const void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\toutsl"
  800254:	89 de                	mov    %ebx,%esi
  800256:	b9 80 00 00 00       	mov    $0x80,%ecx
  80025b:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800260:	fc                   	cld    
  800261:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800263:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800269:	39 fb                	cmp    %edi,%ebx
  80026b:	75 d9                	jne    800246 <ide_write+0x8f>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  80026d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800272:	83 c4 1c             	add    $0x1c,%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	56                   	push   %esi
  80027e:	53                   	push   %ebx
  80027f:	83 ec 20             	sub    $0x20,%esp
  800282:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  800285:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800287:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  80028d:	89 c6                	mov    %eax,%esi
  80028f:	c1 ee 0c             	shr    $0xc,%esi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800292:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800297:	76 2e                	jbe    8002c7 <bc_pgfault+0x4d>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  800299:	8b 42 04             	mov    0x4(%edx),%eax
  80029c:	89 44 24 14          	mov    %eax,0x14(%esp)
  8002a0:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  8002a4:	8b 42 28             	mov    0x28(%edx),%eax
  8002a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002ab:	c7 44 24 08 74 44 80 	movl   $0x804474,0x8(%esp)
  8002b2:	00 
  8002b3:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  8002ba:	00 
  8002bb:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  8002c2:	e8 0c 1b 00 00       	call   801dd3 <_panic>
		      utf->utf_eip, addr, utf->utf_err);
	
	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  8002c7:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8002cc:	85 c0                	test   %eax,%eax
  8002ce:	74 25                	je     8002f5 <bc_pgfault+0x7b>
  8002d0:	3b 70 04             	cmp    0x4(%eax),%esi
  8002d3:	72 20                	jb     8002f5 <bc_pgfault+0x7b>
		panic("reading non-existent block %08x\n", blockno);
  8002d5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002d9:	c7 44 24 08 a4 44 80 	movl   $0x8044a4,0x8(%esp)
  8002e0:	00 
  8002e1:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8002e8:	00 
  8002e9:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  8002f0:	e8 de 1a 00 00       	call   801dd3 <_panic>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary. fs/ide.c has code to read
	// the disk.
	//
	// LAB 5: you code here:
	addr = ROUNDDOWN(addr, BLKSIZE);
  8002f5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	if ((r = sys_page_alloc(sys_getenvid(), addr, PTE_P | PTE_U | PTE_W)) != 0)
  8002fb:	e8 d5 25 00 00       	call   8028d5 <sys_getenvid>
  800300:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800307:	00 
  800308:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80030c:	89 04 24             	mov    %eax,(%esp)
  80030f:	e8 ff 25 00 00       	call   802913 <sys_page_alloc>
  800314:	85 c0                	test   %eax,%eax
  800316:	74 24                	je     80033c <bc_pgfault+0xc2>
		panic("bc_pgfault, sys_page_alloc: error %e addr %08x\n", r, addr);
  800318:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  80031c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800320:	c7 44 24 08 c8 44 80 	movl   $0x8044c8,0x8(%esp)
  800327:	00 
  800328:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  80032f:	00 
  800330:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  800337:	e8 97 1a 00 00       	call   801dd3 <_panic>

	if (ide_read(blockno * BLKSECTS, addr, BLKSECTS) != 0)
  80033c:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  800343:	00 
  800344:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800348:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  80034f:	89 04 24             	mov    %eax,(%esp)
  800352:	e8 9d fd ff ff       	call   8000f4 <ide_read>
  800357:	85 c0                	test   %eax,%eax
  800359:	74 1c                	je     800377 <bc_pgfault+0xfd>
		panic("bc_pgfault, ide_read failed\n");
  80035b:	c7 44 24 08 98 45 80 	movl   $0x804598,0x8(%esp)
  800362:	00 
  800363:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  80036a:	00 
  80036b:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  800372:	e8 5c 1a 00 00       	call   801dd3 <_panic>

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  800377:	89 d8                	mov    %ebx,%eax
  800379:	c1 e8 0c             	shr    $0xc,%eax
  80037c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800383:	25 07 0e 00 00       	and    $0xe07,%eax
  800388:	89 44 24 10          	mov    %eax,0x10(%esp)
  80038c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800390:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800397:	00 
  800398:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80039c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003a3:	e8 bf 25 00 00       	call   802967 <sys_page_map>
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	79 20                	jns    8003cc <bc_pgfault+0x152>
		panic("in bc_pgfault, sys_page_map: %e", r);
  8003ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003b0:	c7 44 24 08 f8 44 80 	movl   $0x8044f8,0x8(%esp)
  8003b7:	00 
  8003b8:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  8003bf:	00 
  8003c0:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  8003c7:	e8 07 1a 00 00       	call   801dd3 <_panic>

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  8003cc:	83 3d 08 a0 80 00 00 	cmpl   $0x0,0x80a008
  8003d3:	74 2c                	je     800401 <bc_pgfault+0x187>
  8003d5:	89 34 24             	mov    %esi,(%esp)
  8003d8:	e8 73 05 00 00       	call   800950 <block_is_free>
  8003dd:	84 c0                	test   %al,%al
  8003df:	74 20                	je     800401 <bc_pgfault+0x187>
		panic("reading free block %08x\n", blockno);
  8003e1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003e5:	c7 44 24 08 b5 45 80 	movl   $0x8045b5,0x8(%esp)
  8003ec:	00 
  8003ed:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  8003f4:	00 
  8003f5:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  8003fc:	e8 d2 19 00 00       	call   801dd3 <_panic>
}
  800401:	83 c4 20             	add    $0x20,%esp
  800404:	5b                   	pop    %ebx
  800405:	5e                   	pop    %esi
  800406:	5d                   	pop    %ebp
  800407:	c3                   	ret    

00800408 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint32_t blockno)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	83 ec 18             	sub    $0x18,%esp
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  800411:	85 c0                	test   %eax,%eax
  800413:	74 0f                	je     800424 <diskaddr+0x1c>
  800415:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  80041b:	85 d2                	test   %edx,%edx
  80041d:	74 25                	je     800444 <diskaddr+0x3c>
  80041f:	3b 42 04             	cmp    0x4(%edx),%eax
  800422:	72 20                	jb     800444 <diskaddr+0x3c>
		panic("bad block number %08x in diskaddr", blockno);
  800424:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800428:	c7 44 24 08 18 45 80 	movl   $0x804518,0x8(%esp)
  80042f:	00 
  800430:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800437:	00 
  800438:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  80043f:	e8 8f 19 00 00       	call   801dd3 <_panic>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800444:	05 00 00 01 00       	add    $0x10000,%eax
  800449:	c1 e0 0c             	shl    $0xc,%eax
}
  80044c:	c9                   	leave  
  80044d:	c3                   	ret    

0080044e <va_is_mapped>:

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
  800451:	8b 55 08             	mov    0x8(%ebp),%edx
	return (uvpd[PDX(va)] & PTE_P) && (uvpt[PGNUM(va)] & PTE_P);
  800454:	89 d0                	mov    %edx,%eax
  800456:	c1 e8 16             	shr    $0x16,%eax
  800459:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  800460:	b8 00 00 00 00       	mov    $0x0,%eax
  800465:	f6 c1 01             	test   $0x1,%cl
  800468:	74 0d                	je     800477 <va_is_mapped+0x29>
  80046a:	c1 ea 0c             	shr    $0xc,%edx
  80046d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800474:	83 e0 01             	and    $0x1,%eax
  800477:	83 e0 01             	and    $0x1,%eax
}
  80047a:	5d                   	pop    %ebp
  80047b:	c3                   	ret    

0080047c <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  80047c:	55                   	push   %ebp
  80047d:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	c1 e8 0c             	shr    $0xc,%eax
  800485:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80048c:	c1 e8 06             	shr    $0x6,%eax
  80048f:	83 e0 01             	and    $0x1,%eax
}
  800492:	5d                   	pop    %ebp
  800493:	c3                   	ret    

00800494 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800494:	55                   	push   %ebp
  800495:	89 e5                	mov    %esp,%ebp
  800497:	56                   	push   %esi
  800498:	53                   	push   %ebx
  800499:	83 ec 20             	sub    $0x20,%esp
  80049c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
	
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80049f:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  8004a5:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  8004aa:	76 20                	jbe    8004cc <flush_block+0x38>
		panic("flush_block of bad va %08x", addr);
  8004ac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004b0:	c7 44 24 08 ce 45 80 	movl   $0x8045ce,0x8(%esp)
  8004b7:	00 
  8004b8:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  8004bf:	00 
  8004c0:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  8004c7:	e8 07 19 00 00       	call   801dd3 <_panic>

	// LAB 5: Your code here.
	int r;
	addr = ROUNDDOWN(addr, BLKSIZE);
  8004cc:	89 de                	mov    %ebx,%esi
  8004ce:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
	if (va_is_mapped(addr) && va_is_dirty(addr)) {
  8004d4:	89 34 24             	mov    %esi,(%esp)
  8004d7:	e8 72 ff ff ff       	call   80044e <va_is_mapped>
  8004dc:	84 c0                	test   %al,%al
  8004de:	0f 84 a9 00 00 00    	je     80058d <flush_block+0xf9>
  8004e4:	89 34 24             	mov    %esi,(%esp)
  8004e7:	e8 90 ff ff ff       	call   80047c <va_is_dirty>
  8004ec:	84 c0                	test   %al,%al
  8004ee:	0f 84 99 00 00 00    	je     80058d <flush_block+0xf9>
		if (ide_write(blockno * BLKSECTS, addr, BLKSECTS) != 0)
  8004f4:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  8004fb:	00 
  8004fc:	89 74 24 04          	mov    %esi,0x4(%esp)
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800500:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
  800506:	c1 eb 0c             	shr    $0xc,%ebx

	// LAB 5: Your code here.
	int r;
	addr = ROUNDDOWN(addr, BLKSIZE);
	if (va_is_mapped(addr) && va_is_dirty(addr)) {
		if (ide_write(blockno * BLKSECTS, addr, BLKSECTS) != 0)
  800509:	c1 e3 03             	shl    $0x3,%ebx
  80050c:	89 1c 24             	mov    %ebx,(%esp)
  80050f:	e8 a3 fc ff ff       	call   8001b7 <ide_write>
  800514:	85 c0                	test   %eax,%eax
  800516:	74 1c                	je     800534 <flush_block+0xa0>
			panic("ide_write failed\n");
  800518:	c7 44 24 08 e9 45 80 	movl   $0x8045e9,0x8(%esp)
  80051f:	00 
  800520:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  800527:	00 
  800528:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  80052f:	e8 9f 18 00 00       	call   801dd3 <_panic>
		if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  800534:	89 f0                	mov    %esi,%eax
  800536:	c1 e8 0c             	shr    $0xc,%eax
  800539:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800540:	25 07 0e 00 00       	and    $0xe07,%eax
  800545:	89 44 24 10          	mov    %eax,0x10(%esp)
  800549:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80054d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800554:	00 
  800555:	89 74 24 04          	mov    %esi,0x4(%esp)
  800559:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800560:	e8 02 24 00 00       	call   802967 <sys_page_map>
  800565:	85 c0                	test   %eax,%eax
  800567:	79 24                	jns    80058d <flush_block+0xf9>
			panic("flush_block - sys_page_map: error %e addr %08x\n", r, addr);
  800569:	89 74 24 10          	mov    %esi,0x10(%esp)
  80056d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800571:	c7 44 24 08 3c 45 80 	movl   $0x80453c,0x8(%esp)
  800578:	00 
  800579:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800580:	00 
  800581:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  800588:	e8 46 18 00 00       	call   801dd3 <_panic>
	}
	//panic("flush_block not implemented");
}
  80058d:	83 c4 20             	add    $0x20,%esp
  800590:	5b                   	pop    %ebx
  800591:	5e                   	pop    %esi
  800592:	5d                   	pop    %ebp
  800593:	c3                   	ret    

00800594 <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  800594:	55                   	push   %ebp
  800595:	89 e5                	mov    %esp,%ebp
  800597:	53                   	push   %ebx
  800598:	81 ec 24 02 00 00    	sub    $0x224,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  80059e:	c7 04 24 7a 02 80 00 	movl   $0x80027a,(%esp)
  8005a5:	e8 a7 26 00 00       	call   802c51 <set_pgfault_handler>
check_bc(void)
{
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  8005aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005b1:	e8 52 fe ff ff       	call   800408 <diskaddr>
  8005b6:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  8005bd:	00 
  8005be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c2:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8005c8:	89 04 24             	mov    %eax,(%esp)
  8005cb:	e8 c4 20 00 00       	call   802694 <memmove>

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  8005d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005d7:	e8 2c fe ff ff       	call   800408 <diskaddr>
  8005dc:	c7 44 24 04 fb 45 80 	movl   $0x8045fb,0x4(%esp)
  8005e3:	00 
  8005e4:	89 04 24             	mov    %eax,(%esp)
  8005e7:	e8 0b 1f 00 00       	call   8024f7 <strcpy>
	flush_block(diskaddr(1));
  8005ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005f3:	e8 10 fe ff ff       	call   800408 <diskaddr>
  8005f8:	89 04 24             	mov    %eax,(%esp)
  8005fb:	e8 94 fe ff ff       	call   800494 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800600:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800607:	e8 fc fd ff ff       	call   800408 <diskaddr>
  80060c:	89 04 24             	mov    %eax,(%esp)
  80060f:	e8 3a fe ff ff       	call   80044e <va_is_mapped>
  800614:	84 c0                	test   %al,%al
  800616:	75 24                	jne    80063c <bc_init+0xa8>
  800618:	c7 44 24 0c 1d 46 80 	movl   $0x80461d,0xc(%esp)
  80061f:	00 
  800620:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  800627:	00 
  800628:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  80062f:	00 
  800630:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  800637:	e8 97 17 00 00       	call   801dd3 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  80063c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800643:	e8 c0 fd ff ff       	call   800408 <diskaddr>
  800648:	89 04 24             	mov    %eax,(%esp)
  80064b:	e8 2c fe ff ff       	call   80047c <va_is_dirty>
  800650:	84 c0                	test   %al,%al
  800652:	74 24                	je     800678 <bc_init+0xe4>
  800654:	c7 44 24 0c 02 46 80 	movl   $0x804602,0xc(%esp)
  80065b:	00 
  80065c:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  800663:	00 
  800664:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
  80066b:	00 
  80066c:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  800673:	e8 5b 17 00 00       	call   801dd3 <_panic>

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  800678:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80067f:	e8 84 fd ff ff       	call   800408 <diskaddr>
  800684:	89 44 24 04          	mov    %eax,0x4(%esp)
  800688:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80068f:	e8 26 23 00 00       	call   8029ba <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800694:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80069b:	e8 68 fd ff ff       	call   800408 <diskaddr>
  8006a0:	89 04 24             	mov    %eax,(%esp)
  8006a3:	e8 a6 fd ff ff       	call   80044e <va_is_mapped>
  8006a8:	84 c0                	test   %al,%al
  8006aa:	74 24                	je     8006d0 <bc_init+0x13c>
  8006ac:	c7 44 24 0c 1c 46 80 	movl   $0x80461c,0xc(%esp)
  8006b3:	00 
  8006b4:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  8006bb:	00 
  8006bc:	c7 44 24 04 73 00 00 	movl   $0x73,0x4(%esp)
  8006c3:	00 
  8006c4:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  8006cb:	e8 03 17 00 00       	call   801dd3 <_panic>

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  8006d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006d7:	e8 2c fd ff ff       	call   800408 <diskaddr>
  8006dc:	c7 44 24 04 fb 45 80 	movl   $0x8045fb,0x4(%esp)
  8006e3:	00 
  8006e4:	89 04 24             	mov    %eax,(%esp)
  8006e7:	e8 c0 1e 00 00       	call   8025ac <strcmp>
  8006ec:	85 c0                	test   %eax,%eax
  8006ee:	74 24                	je     800714 <bc_init+0x180>
  8006f0:	c7 44 24 0c 6c 45 80 	movl   $0x80456c,0xc(%esp)
  8006f7:	00 
  8006f8:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  8006ff:	00 
  800700:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
  800707:	00 
  800708:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  80070f:	e8 bf 16 00 00       	call   801dd3 <_panic>

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800714:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80071b:	e8 e8 fc ff ff       	call   800408 <diskaddr>
  800720:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  800727:	00 
  800728:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
  80072e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800732:	89 04 24             	mov    %eax,(%esp)
  800735:	e8 5a 1f 00 00       	call   802694 <memmove>
	flush_block(diskaddr(1));
  80073a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800741:	e8 c2 fc ff ff       	call   800408 <diskaddr>
  800746:	89 04 24             	mov    %eax,(%esp)
  800749:	e8 46 fd ff ff       	call   800494 <flush_block>

	// Now repeat the same experiment, but pass an unaligned address to
	// flush_block.

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  80074e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800755:	e8 ae fc ff ff       	call   800408 <diskaddr>
  80075a:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  800761:	00 
  800762:	89 44 24 04          	mov    %eax,0x4(%esp)
  800766:	89 1c 24             	mov    %ebx,(%esp)
  800769:	e8 26 1f 00 00       	call   802694 <memmove>

	// smash it
	strcpy(diskaddr(1), "OOPS!\n");
  80076e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800775:	e8 8e fc ff ff       	call   800408 <diskaddr>
  80077a:	c7 44 24 04 fb 45 80 	movl   $0x8045fb,0x4(%esp)
  800781:	00 
  800782:	89 04 24             	mov    %eax,(%esp)
  800785:	e8 6d 1d 00 00       	call   8024f7 <strcpy>

	// Pass an unaligned address to flush_block.
	flush_block(diskaddr(1) + 20);
  80078a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800791:	e8 72 fc ff ff       	call   800408 <diskaddr>
  800796:	83 c0 14             	add    $0x14,%eax
  800799:	89 04 24             	mov    %eax,(%esp)
  80079c:	e8 f3 fc ff ff       	call   800494 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  8007a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8007a8:	e8 5b fc ff ff       	call   800408 <diskaddr>
  8007ad:	89 04 24             	mov    %eax,(%esp)
  8007b0:	e8 99 fc ff ff       	call   80044e <va_is_mapped>
  8007b5:	84 c0                	test   %al,%al
  8007b7:	75 24                	jne    8007dd <bc_init+0x249>
  8007b9:	c7 44 24 0c 1d 46 80 	movl   $0x80461d,0xc(%esp)
  8007c0:	00 
  8007c1:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  8007c8:	00 
  8007c9:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  8007d0:	00 
  8007d1:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  8007d8:	e8 f6 15 00 00       	call   801dd3 <_panic>
	// Skip the !va_is_dirty() check because it makes the bug somewhat
	// obscure and hence harder to debug.
	//assert(!va_is_dirty(diskaddr(1)));

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  8007dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8007e4:	e8 1f fc ff ff       	call   800408 <diskaddr>
  8007e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007f4:	e8 c1 21 00 00       	call   8029ba <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  8007f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800800:	e8 03 fc ff ff       	call   800408 <diskaddr>
  800805:	89 04 24             	mov    %eax,(%esp)
  800808:	e8 41 fc ff ff       	call   80044e <va_is_mapped>
  80080d:	84 c0                	test   %al,%al
  80080f:	74 24                	je     800835 <bc_init+0x2a1>
  800811:	c7 44 24 0c 1c 46 80 	movl   $0x80461c,0xc(%esp)
  800818:	00 
  800819:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  800820:	00 
  800821:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  800828:	00 
  800829:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  800830:	e8 9e 15 00 00       	call   801dd3 <_panic>

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800835:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80083c:	e8 c7 fb ff ff       	call   800408 <diskaddr>
  800841:	c7 44 24 04 fb 45 80 	movl   $0x8045fb,0x4(%esp)
  800848:	00 
  800849:	89 04 24             	mov    %eax,(%esp)
  80084c:	e8 5b 1d 00 00       	call   8025ac <strcmp>
  800851:	85 c0                	test   %eax,%eax
  800853:	74 24                	je     800879 <bc_init+0x2e5>
  800855:	c7 44 24 0c 6c 45 80 	movl   $0x80456c,0xc(%esp)
  80085c:	00 
  80085d:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  800864:	00 
  800865:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
  80086c:	00 
  80086d:	c7 04 24 90 45 80 00 	movl   $0x804590,(%esp)
  800874:	e8 5a 15 00 00       	call   801dd3 <_panic>

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  800879:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800880:	e8 83 fb ff ff       	call   800408 <diskaddr>
  800885:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  80088c:	00 
  80088d:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  800893:	89 54 24 04          	mov    %edx,0x4(%esp)
  800897:	89 04 24             	mov    %eax,(%esp)
  80089a:	e8 f5 1d 00 00       	call   802694 <memmove>
	flush_block(diskaddr(1));
  80089f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8008a6:	e8 5d fb ff ff       	call   800408 <diskaddr>
  8008ab:	89 04 24             	mov    %eax,(%esp)
  8008ae:	e8 e1 fb ff ff       	call   800494 <flush_block>

	cprintf("block cache is good\n");
  8008b3:	c7 04 24 37 46 80 00 	movl   $0x804637,(%esp)
  8008ba:	e8 0d 16 00 00       	call   801ecc <cprintf>
	struct Super super;
	set_pgfault_handler(bc_pgfault);
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  8008bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8008c6:	e8 3d fb ff ff       	call   800408 <diskaddr>
  8008cb:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  8008d2:	00 
  8008d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008dd:	89 04 24             	mov    %eax,(%esp)
  8008e0:	e8 af 1d 00 00       	call   802694 <memmove>
}
  8008e5:	81 c4 24 02 00 00    	add    $0x224,%esp
  8008eb:	5b                   	pop    %ebx
  8008ec:	5d                   	pop    %ebp
  8008ed:	c3                   	ret    

008008ee <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	83 ec 18             	sub    $0x18,%esp
	if (super->s_magic != FS_MAGIC)
  8008f4:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8008f9:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  8008ff:	74 1c                	je     80091d <check_super+0x2f>
		panic("bad file system magic number");
  800901:	c7 44 24 08 4c 46 80 	movl   $0x80464c,0x8(%esp)
  800908:	00 
  800909:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800910:	00 
  800911:	c7 04 24 69 46 80 00 	movl   $0x804669,(%esp)
  800918:	e8 b6 14 00 00       	call   801dd3 <_panic>

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  80091d:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  800924:	76 1c                	jbe    800942 <check_super+0x54>
		panic("file system is too large");
  800926:	c7 44 24 08 71 46 80 	movl   $0x804671,0x8(%esp)
  80092d:	00 
  80092e:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  800935:	00 
  800936:	c7 04 24 69 46 80 00 	movl   $0x804669,(%esp)
  80093d:	e8 91 14 00 00       	call   801dd3 <_panic>

	cprintf("superblock is good\n");
  800942:	c7 04 24 8a 46 80 00 	movl   $0x80468a,(%esp)
  800949:	e8 7e 15 00 00       	call   801ecc <cprintf>
}
  80094e:	c9                   	leave  
  80094f:	c3                   	ret    

00800950 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  800956:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  80095c:	85 d2                	test   %edx,%edx
  80095e:	74 22                	je     800982 <block_is_free+0x32>
		return 0;
  800960:	b8 00 00 00 00       	mov    $0x0,%eax
// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
	if (super == 0 || blockno >= super->s_nblocks)
  800965:	39 4a 04             	cmp    %ecx,0x4(%edx)
  800968:	76 1d                	jbe    800987 <block_is_free+0x37>
		return 0;
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
  80096a:	b8 01 00 00 00       	mov    $0x1,%eax
  80096f:	d3 e0                	shl    %cl,%eax
  800971:	c1 e9 05             	shr    $0x5,%ecx
  800974:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  80097a:	85 04 8a             	test   %eax,(%edx,%ecx,4)
		return 1;
  80097d:	0f 95 c0             	setne  %al
  800980:	eb 05                	jmp    800987 <block_is_free+0x37>
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
	if (super == 0 || blockno >= super->s_nblocks)
		return 0;
  800982:	b8 00 00 00 00       	mov    $0x0,%eax
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
		return 1;
	return 0;
}
  800987:	5d                   	pop    %ebp
  800988:	c3                   	ret    

00800989 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	53                   	push   %ebx
  80098d:	83 ec 14             	sub    $0x14,%esp
  800990:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800993:	85 c9                	test   %ecx,%ecx
  800995:	75 1c                	jne    8009b3 <free_block+0x2a>
		panic("attempt to free zero block");
  800997:	c7 44 24 08 9e 46 80 	movl   $0x80469e,0x8(%esp)
  80099e:	00 
  80099f:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  8009a6:	00 
  8009a7:	c7 04 24 69 46 80 00 	movl   $0x804669,(%esp)
  8009ae:	e8 20 14 00 00       	call   801dd3 <_panic>
	bitmap[blockno/32] |= 1<<(blockno%32);
  8009b3:	89 ca                	mov    %ecx,%edx
  8009b5:	c1 ea 05             	shr    $0x5,%edx
  8009b8:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8009bd:	bb 01 00 00 00       	mov    $0x1,%ebx
  8009c2:	d3 e3                	shl    %cl,%ebx
  8009c4:	09 1c 90             	or     %ebx,(%eax,%edx,4)
}
  8009c7:	83 c4 14             	add    $0x14,%esp
  8009ca:	5b                   	pop    %ebx
  8009cb:	5d                   	pop    %ebp
  8009cc:	c3                   	ret    

008009cd <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	57                   	push   %edi
  8009d1:	56                   	push   %esi
  8009d2:	53                   	push   %ebx
  8009d3:	83 ec 1c             	sub    $0x1c,%esp
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	uint32_t blockno;
	for (blockno = 0; blockno < super->s_nblocks; blockno++) {
  8009d6:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  8009db:	8b 40 04             	mov    0x4(%eax),%eax
  8009de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (bitmap[blockno / 32] & (1 << (blockno % 32))) {
  8009e1:	8b 1d 08 a0 80 00    	mov    0x80a008,%ebx
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	uint32_t blockno;
	for (blockno = 0; blockno < super->s_nblocks; blockno++) {
  8009e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8009ec:	eb 37                	jmp    800a25 <alloc_block+0x58>
		if (bitmap[blockno / 32] & (1 << (blockno % 32))) {
  8009ee:	89 ca                	mov    %ecx,%edx
  8009f0:	c1 ea 05             	shr    $0x5,%edx
  8009f3:	c1 e2 02             	shl    $0x2,%edx
  8009f6:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  8009f9:	8b 30                	mov    (%eax),%esi
  8009fb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8009fe:	bf 01 00 00 00       	mov    $0x1,%edi
  800a03:	d3 e7                	shl    %cl,%edi
  800a05:	85 f7                	test   %esi,%edi
  800a07:	74 19                	je     800a22 <alloc_block+0x55>
			bitmap[blockno / 32] &= ~(1 << (blockno % 32));
  800a09:	f7 d7                	not    %edi
  800a0b:	21 fe                	and    %edi,%esi
  800a0d:	89 30                	mov    %esi,(%eax)
			flush_block((void *) &bitmap[blockno / 32]);
  800a0f:	03 15 08 a0 80 00    	add    0x80a008,%edx
  800a15:	89 14 24             	mov    %edx,(%esp)
  800a18:	e8 77 fa ff ff       	call   800494 <flush_block>
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	uint32_t blockno;
	for (blockno = 0; blockno < super->s_nblocks; blockno++) {
		if (bitmap[blockno / 32] & (1 << (blockno % 32))) {
  800a1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
			bitmap[blockno / 32] &= ~(1 << (blockno % 32));
			flush_block((void *) &bitmap[blockno / 32]);
			return blockno;
  800a20:	eb 0d                	jmp    800a2f <alloc_block+0x62>
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	uint32_t blockno;
	for (blockno = 0; blockno < super->s_nblocks; blockno++) {
  800a22:	83 c1 01             	add    $0x1,%ecx
  800a25:	3b 4d e4             	cmp    -0x1c(%ebp),%ecx
  800a28:	75 c4                	jne    8009ee <alloc_block+0x21>
			flush_block((void *) &bitmap[blockno / 32]);
			return blockno;
		}
	}
	//panic("alloc_block not implemented");
	return -E_NO_DISK;
  800a2a:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
}
  800a2f:	83 c4 1c             	add    $0x1c,%esp
  800a32:	5b                   	pop    %ebx
  800a33:	5e                   	pop    %esi
  800a34:	5f                   	pop    %edi
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    

00800a37 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	57                   	push   %edi
  800a3b:	56                   	push   %esi
  800a3c:	53                   	push   %ebx
  800a3d:	83 ec 1c             	sub    $0x1c,%esp
  800a40:	89 c6                	mov    %eax,%esi
  800a42:	89 d3                	mov    %edx,%ebx
  800a44:	89 cf                	mov    %ecx,%edi
  800a46:	8b 55 08             	mov    0x8(%ebp),%edx
    // LAB 5: Your code here.
    if (filebno < NDIRECT)
  800a49:	83 fb 09             	cmp    $0x9,%ebx
  800a4c:	77 13                	ja     800a61 <file_block_walk+0x2a>
		*ppdiskbno = &f->f_direct[filebno];
  800a4e:	8d 84 98 88 00 00 00 	lea    0x88(%eax,%ebx,4),%eax
  800a55:	89 01                	mov    %eax,(%ecx)
		else if (!alloc && !f->f_indirect) // No indirect block and we can't allocate one
			return -E_NOT_FOUND;
	}
	else
		return -E_INVAL; // Out of range
	return 0;
  800a57:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5c:	e9 86 00 00 00       	jmp    800ae7 <file_block_walk+0xb0>
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
    // LAB 5: Your code here.
    if (filebno < NDIRECT)
		*ppdiskbno = &f->f_direct[filebno];
	else if (filebno < (NDIRECT + NINDIRECT)) {
  800a61:	81 fb 09 04 00 00    	cmp    $0x409,%ebx
  800a67:	77 72                	ja     800adb <file_block_walk+0xa4>
		// Indirect block
		if (f->f_indirect) {
  800a69:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  800a6f:	85 c0                	test   %eax,%eax
  800a71:	74 15                	je     800a88 <file_block_walk+0x51>
			*ppdiskbno = &((uint32_t *) diskaddr(f->f_indirect))[filebno - NDIRECT];
  800a73:	89 04 24             	mov    %eax,(%esp)
  800a76:	e8 8d f9 ff ff       	call   800408 <diskaddr>
  800a7b:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  800a7f:	89 07                	mov    %eax,(%edi)
		else if (!alloc && !f->f_indirect) // No indirect block and we can't allocate one
			return -E_NOT_FOUND;
	}
	else
		return -E_INVAL; // Out of range
	return 0;
  800a81:	b8 00 00 00 00       	mov    $0x0,%eax
  800a86:	eb 5f                	jmp    800ae7 <file_block_walk+0xb0>
			memset(diskaddr(new_blockno), 0, BLKSIZE);
			f->f_indirect = new_blockno;
			*ppdiskbno = &((uint32_t *) diskaddr(f->f_indirect))[filebno - NDIRECT];
		}
		else if (!alloc && !f->f_indirect) // No indirect block and we can't allocate one
			return -E_NOT_FOUND;
  800a88:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
	else if (filebno < (NDIRECT + NINDIRECT)) {
		// Indirect block
		if (f->f_indirect) {
			*ppdiskbno = &((uint32_t *) diskaddr(f->f_indirect))[filebno - NDIRECT];
		} 
		else if (alloc && !f->f_indirect) { // Allocate new indirect block
  800a8d:	84 d2                	test   %dl,%dl
  800a8f:	74 56                	je     800ae7 <file_block_walk+0xb0>
			uint32_t new_blockno = alloc_block();
  800a91:	e8 37 ff ff ff       	call   8009cd <alloc_block>
			if (!new_blockno)
  800a96:	85 c0                	test   %eax,%eax
  800a98:	74 48                	je     800ae2 <file_block_walk+0xab>
				return -E_NO_DISK;
			memset(diskaddr(new_blockno), 0, BLKSIZE);
  800a9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a9d:	89 04 24             	mov    %eax,(%esp)
  800aa0:	e8 63 f9 ff ff       	call   800408 <diskaddr>
  800aa5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800aac:	00 
  800aad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800ab4:	00 
  800ab5:	89 04 24             	mov    %eax,(%esp)
  800ab8:	e8 8a 1b 00 00       	call   802647 <memset>
			f->f_indirect = new_blockno;
  800abd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ac0:	89 86 b0 00 00 00    	mov    %eax,0xb0(%esi)
			*ppdiskbno = &((uint32_t *) diskaddr(f->f_indirect))[filebno - NDIRECT];
  800ac6:	89 04 24             	mov    %eax,(%esp)
  800ac9:	e8 3a f9 ff ff       	call   800408 <diskaddr>
  800ace:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  800ad2:	89 07                	mov    %eax,(%edi)
		else if (!alloc && !f->f_indirect) // No indirect block and we can't allocate one
			return -E_NOT_FOUND;
	}
	else
		return -E_INVAL; // Out of range
	return 0;
  800ad4:	b8 00 00 00 00       	mov    $0x0,%eax
	else if (filebno < (NDIRECT + NINDIRECT)) {
		// Indirect block
		if (f->f_indirect) {
			*ppdiskbno = &((uint32_t *) diskaddr(f->f_indirect))[filebno - NDIRECT];
		} 
		else if (alloc && !f->f_indirect) { // Allocate new indirect block
  800ad9:	eb 0c                	jmp    800ae7 <file_block_walk+0xb0>
		}
		else if (!alloc && !f->f_indirect) // No indirect block and we can't allocate one
			return -E_NOT_FOUND;
	}
	else
		return -E_INVAL; // Out of range
  800adb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ae0:	eb 05                	jmp    800ae7 <file_block_walk+0xb0>
			*ppdiskbno = &((uint32_t *) diskaddr(f->f_indirect))[filebno - NDIRECT];
		} 
		else if (alloc && !f->f_indirect) { // Allocate new indirect block
			uint32_t new_blockno = alloc_block();
			if (!new_blockno)
				return -E_NO_DISK;
  800ae2:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
			return -E_NOT_FOUND;
	}
	else
		return -E_INVAL; // Out of range
	return 0;
}
  800ae7:	83 c4 1c             	add    $0x1c,%esp
  800aea:	5b                   	pop    %ebx
  800aeb:	5e                   	pop    %esi
  800aec:	5f                   	pop    %edi
  800aed:	5d                   	pop    %ebp
  800aee:	c3                   	ret    

00800aef <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	56                   	push   %esi
  800af3:	53                   	push   %ebx
  800af4:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800af7:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  800afc:	8b 70 04             	mov    0x4(%eax),%esi
  800aff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b04:	eb 36                	jmp    800b3c <check_bitmap+0x4d>
  800b06:	8d 43 02             	lea    0x2(%ebx),%eax
		assert(!block_is_free(2+i));
  800b09:	89 04 24             	mov    %eax,(%esp)
  800b0c:	e8 3f fe ff ff       	call   800950 <block_is_free>
  800b11:	84 c0                	test   %al,%al
  800b13:	74 24                	je     800b39 <check_bitmap+0x4a>
  800b15:	c7 44 24 0c b9 46 80 	movl   $0x8046b9,0xc(%esp)
  800b1c:	00 
  800b1d:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  800b24:	00 
  800b25:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  800b2c:	00 
  800b2d:	c7 04 24 69 46 80 00 	movl   $0x804669,(%esp)
  800b34:	e8 9a 12 00 00       	call   801dd3 <_panic>
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800b39:	83 c3 01             	add    $0x1,%ebx
  800b3c:	89 d8                	mov    %ebx,%eax
  800b3e:	c1 e0 0f             	shl    $0xf,%eax
  800b41:	39 c6                	cmp    %eax,%esi
  800b43:	77 c1                	ja     800b06 <check_bitmap+0x17>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800b45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b4c:	e8 ff fd ff ff       	call   800950 <block_is_free>
  800b51:	84 c0                	test   %al,%al
  800b53:	74 24                	je     800b79 <check_bitmap+0x8a>
  800b55:	c7 44 24 0c cd 46 80 	movl   $0x8046cd,0xc(%esp)
  800b5c:	00 
  800b5d:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  800b64:	00 
  800b65:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  800b6c:	00 
  800b6d:	c7 04 24 69 46 80 00 	movl   $0x804669,(%esp)
  800b74:	e8 5a 12 00 00       	call   801dd3 <_panic>
	assert(!block_is_free(1));
  800b79:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800b80:	e8 cb fd ff ff       	call   800950 <block_is_free>
  800b85:	84 c0                	test   %al,%al
  800b87:	74 24                	je     800bad <check_bitmap+0xbe>
  800b89:	c7 44 24 0c df 46 80 	movl   $0x8046df,0xc(%esp)
  800b90:	00 
  800b91:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  800b98:	00 
  800b99:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800ba0:	00 
  800ba1:	c7 04 24 69 46 80 00 	movl   $0x804669,(%esp)
  800ba8:	e8 26 12 00 00       	call   801dd3 <_panic>

	cprintf("bitmap is good\n");
  800bad:	c7 04 24 f1 46 80 00 	movl   $0x8046f1,(%esp)
  800bb4:	e8 13 13 00 00       	call   801ecc <cprintf>
}
  800bb9:	83 c4 10             	add    $0x10,%esp
  800bbc:	5b                   	pop    %ebx
  800bbd:	5e                   	pop    %esi
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <fs_init>:


// Initialize the file system
void
fs_init(void)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);

	// Find a JOS disk.  Use the second IDE disk (number 1) if available
	if (ide_probe_disk1())
  800bc6:	e8 94 f4 ff ff       	call   80005f <ide_probe_disk1>
  800bcb:	84 c0                	test   %al,%al
  800bcd:	74 0e                	je     800bdd <fs_init+0x1d>
		ide_set_disk(1);
  800bcf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800bd6:	e8 e8 f4 ff ff       	call   8000c3 <ide_set_disk>
  800bdb:	eb 0c                	jmp    800be9 <fs_init+0x29>
	else
		ide_set_disk(0);
  800bdd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800be4:	e8 da f4 ff ff       	call   8000c3 <ide_set_disk>
	bc_init();
  800be9:	e8 a6 f9 ff ff       	call   800594 <bc_init>

	// Set "super" to point to the super block.
	super = diskaddr(1);
  800bee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800bf5:	e8 0e f8 ff ff       	call   800408 <diskaddr>
  800bfa:	a3 0c a0 80 00       	mov    %eax,0x80a00c
	check_super();
  800bff:	e8 ea fc ff ff       	call   8008ee <check_super>

	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  800c04:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800c0b:	e8 f8 f7 ff ff       	call   800408 <diskaddr>
  800c10:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_bitmap();
  800c15:	e8 d5 fe ff ff       	call   800aef <check_bitmap>
	
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	53                   	push   %ebx
  800c20:	83 ec 24             	sub    $0x24,%esp
	// LAB 5: Your code here.
	int r;
	uint32_t *pblockno;

	if ((r = file_block_walk(f, filebno, &pblockno, 1)) != 0) {
  800c23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800c2a:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800c2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	e8 ff fd ff ff       	call   800a37 <file_block_walk>
  800c38:	89 c3                	mov    %eax,%ebx
  800c3a:	85 c0                	test   %eax,%eax
  800c3c:	74 14                	je     800c52 <file_get_block+0x36>
		cprintf("file_get_block: error from file_block_walk %e\n", r);
  800c3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c42:	c7 04 24 3c 47 80 00 	movl   $0x80473c,(%esp)
  800c49:	e8 7e 12 00 00       	call   801ecc <cprintf>
		return r;
  800c4e:	89 d8                	mov    %ebx,%eax
  800c50:	eb 26                	jmp    800c78 <file_get_block+0x5c>
	}

	// No block mapped at this block number, allocate and assign one
	if (!*pblockno) {
  800c52:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c55:	83 3b 00             	cmpl   $0x0,(%ebx)
  800c58:	75 07                	jne    800c61 <file_get_block+0x45>
		*pblockno = alloc_block();
  800c5a:	e8 6e fd ff ff       	call   8009cd <alloc_block>
  800c5f:	89 03                	mov    %eax,(%ebx)
		if (*pblockno < 0)
			return -E_NO_DISK;
	}

	*blk = (char *) diskaddr(*pblockno);
  800c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c64:	8b 00                	mov    (%eax),%eax
  800c66:	89 04 24             	mov    %eax,(%esp)
  800c69:	e8 9a f7 ff ff       	call   800408 <diskaddr>
  800c6e:	8b 55 10             	mov    0x10(%ebp),%edx
  800c71:	89 02                	mov    %eax,(%edx)
	return 0;
  800c73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c78:	83 c4 24             	add    $0x24,%esp
  800c7b:	5b                   	pop    %ebx
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    

00800c7e <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
  800c84:	81 ec cc 00 00 00    	sub    $0xcc,%esp
  800c8a:	89 95 44 ff ff ff    	mov    %edx,-0xbc(%ebp)
  800c90:	89 8d 40 ff ff ff    	mov    %ecx,-0xc0(%ebp)
  800c96:	eb 03                	jmp    800c9b <walk_path+0x1d>
// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
		p++;
  800c98:	83 c0 01             	add    $0x1,%eax

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  800c9b:	80 38 2f             	cmpb   $0x2f,(%eax)
  800c9e:	74 f8                	je     800c98 <walk_path+0x1a>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800ca0:	8b 0d 0c a0 80 00    	mov    0x80a00c,%ecx
  800ca6:	83 c1 08             	add    $0x8,%ecx
  800ca9:	89 8d 50 ff ff ff    	mov    %ecx,-0xb0(%ebp)
	dir = 0;
	name[0] = 0;
  800caf:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800cb6:	8b 8d 44 ff ff ff    	mov    -0xbc(%ebp),%ecx
  800cbc:	85 c9                	test   %ecx,%ecx
  800cbe:	74 06                	je     800cc6 <walk_path+0x48>
		*pdir = 0;
  800cc0:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  800cc6:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800ccc:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
	dir = 0;
  800cd2:	ba 00 00 00 00       	mov    $0x0,%edx
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  800cd7:	e9 71 01 00 00       	jmp    800e4d <walk_path+0x1cf>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800cdc:	83 c7 01             	add    $0x1,%edi
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  800cdf:	0f b6 17             	movzbl (%edi),%edx
  800ce2:	84 d2                	test   %dl,%dl
  800ce4:	74 05                	je     800ceb <walk_path+0x6d>
  800ce6:	80 fa 2f             	cmp    $0x2f,%dl
  800ce9:	75 f1                	jne    800cdc <walk_path+0x5e>
			path++;
		if (path - p >= MAXNAMELEN)
  800ceb:	89 fb                	mov    %edi,%ebx
  800ced:	29 c3                	sub    %eax,%ebx
  800cef:	83 fb 7f             	cmp    $0x7f,%ebx
  800cf2:	0f 8f 82 01 00 00    	jg     800e7a <walk_path+0x1fc>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800cf8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d00:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800d06:	89 04 24             	mov    %eax,(%esp)
  800d09:	e8 86 19 00 00       	call   802694 <memmove>
		name[path - p] = '\0';
  800d0e:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800d15:	00 
  800d16:	eb 03                	jmp    800d1b <walk_path+0x9d>
// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
		p++;
  800d18:	83 c7 01             	add    $0x1,%edi

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  800d1b:	80 3f 2f             	cmpb   $0x2f,(%edi)
  800d1e:	74 f8                	je     800d18 <walk_path+0x9a>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800d20:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800d26:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800d2d:	0f 85 4e 01 00 00    	jne    800e81 <walk_path+0x203>
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  800d33:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800d39:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800d3e:	74 24                	je     800d64 <walk_path+0xe6>
  800d40:	c7 44 24 0c 01 47 80 	movl   $0x804701,0xc(%esp)
  800d47:	00 
  800d48:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  800d4f:	00 
  800d50:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  800d57:	00 
  800d58:	c7 04 24 69 46 80 00 	movl   $0x804669,(%esp)
  800d5f:	e8 6f 10 00 00       	call   801dd3 <_panic>
	nblock = dir->f_size / BLKSIZE;
  800d64:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800d6a:	85 c0                	test   %eax,%eax
  800d6c:	0f 48 c2             	cmovs  %edx,%eax
  800d6f:	c1 f8 0c             	sar    $0xc,%eax
  800d72:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
	for (i = 0; i < nblock; i++) {
  800d78:	c7 85 54 ff ff ff 00 	movl   $0x0,-0xac(%ebp)
  800d7f:	00 00 00 
  800d82:	89 bd 48 ff ff ff    	mov    %edi,-0xb8(%ebp)
  800d88:	eb 61                	jmp    800deb <walk_path+0x16d>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800d8a:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800d90:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d94:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d9e:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800da4:	89 04 24             	mov    %eax,(%esp)
  800da7:	e8 70 fe ff ff       	call   800c1c <file_get_block>
  800dac:	85 c0                	test   %eax,%eax
  800dae:	0f 88 ea 00 00 00    	js     800e9e <walk_path+0x220>
  800db4:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
			return r;
		f = (struct File*) blk;
  800dba:	be 10 00 00 00       	mov    $0x10,%esi
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800dbf:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800dc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dc9:	89 1c 24             	mov    %ebx,(%esp)
  800dcc:	e8 db 17 00 00       	call   8025ac <strcmp>
  800dd1:	85 c0                	test   %eax,%eax
  800dd3:	0f 84 af 00 00 00    	je     800e88 <walk_path+0x20a>
  800dd9:	81 c3 00 01 00 00    	add    $0x100,%ebx
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  800ddf:	83 ee 01             	sub    $0x1,%esi
  800de2:	75 db                	jne    800dbf <walk_path+0x141>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  800de4:	83 85 54 ff ff ff 01 	addl   $0x1,-0xac(%ebp)
  800deb:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800df1:	39 85 4c ff ff ff    	cmp    %eax,-0xb4(%ebp)
  800df7:	75 91                	jne    800d8a <walk_path+0x10c>
  800df9:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800dff:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  800e04:	80 3f 00             	cmpb   $0x0,(%edi)
  800e07:	0f 85 a0 00 00 00    	jne    800ead <walk_path+0x22f>
				if (pdir)
  800e0d:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800e13:	85 c0                	test   %eax,%eax
  800e15:	74 08                	je     800e1f <walk_path+0x1a1>
					*pdir = dir;
  800e17:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800e1d:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  800e1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e23:	74 15                	je     800e3a <walk_path+0x1bc>
					strcpy(lastelem, name);
  800e25:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800e2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	89 04 24             	mov    %eax,(%esp)
  800e35:	e8 bd 16 00 00       	call   8024f7 <strcpy>
				*pf = 0;
  800e3a:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800e40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			}
			return r;
  800e46:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800e4b:	eb 60                	jmp    800ead <walk_path+0x22f>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  800e4d:	80 38 00             	cmpb   $0x0,(%eax)
  800e50:	74 07                	je     800e59 <walk_path+0x1db>
  800e52:	89 c7                	mov    %eax,%edi
  800e54:	e9 86 fe ff ff       	jmp    800cdf <walk_path+0x61>
			}
			return r;
		}
	}

	if (pdir)
  800e59:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	74 02                	je     800e65 <walk_path+0x1e7>
		*pdir = dir;
  800e63:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800e65:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800e6b:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  800e71:	89 08                	mov    %ecx,(%eax)
	return 0;
  800e73:	b8 00 00 00 00       	mov    $0x0,%eax
  800e78:	eb 33                	jmp    800ead <walk_path+0x22f>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
		if (path - p >= MAXNAMELEN)
			return -E_BAD_PATH;
  800e7a:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800e7f:	eb 2c                	jmp    800ead <walk_path+0x22f>
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;
  800e81:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800e86:	eb 25                	jmp    800ead <walk_path+0x22f>
  800e88:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi
  800e8e:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800e94:	89 9d 50 ff ff ff    	mov    %ebx,-0xb0(%ebp)
  800e9a:	89 f8                	mov    %edi,%eax
  800e9c:	eb af                	jmp    800e4d <walk_path+0x1cf>
  800e9e:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  800ea4:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800ea7:	0f 84 52 ff ff ff    	je     800dff <walk_path+0x181>

	if (pdir)
		*pdir = dir;
	*pf = f;
	return 0;
}
  800ead:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  800eb3:	5b                   	pop    %ebx
  800eb4:	5e                   	pop    %esi
  800eb5:	5f                   	pop    %edi
  800eb6:	5d                   	pop    %ebp
  800eb7:	c3                   	ret    

00800eb8 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 18             	sub    $0x18,%esp
	return walk_path(path, 0, pf, 0);
  800ebe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ec5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	e8 a9 fd ff ff       	call   800c7e <walk_path>
}
  800ed5:	c9                   	leave  
  800ed6:	c3                   	ret    

00800ed7 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	57                   	push   %edi
  800edb:	56                   	push   %esi
  800edc:	53                   	push   %ebx
  800edd:	83 ec 3c             	sub    $0x3c,%esp
  800ee0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800ee3:	8b 55 14             	mov    0x14(%ebp),%edx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
		return 0;
  800eef:	b8 00 00 00 00       	mov    $0x0,%eax
{
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800ef4:	39 d1                	cmp    %edx,%ecx
  800ef6:	0f 8e 83 00 00 00    	jle    800f7f <file_read+0xa8>
		return 0;

	count = MIN(count, f->f_size - offset);
  800efc:	29 d1                	sub    %edx,%ecx
  800efe:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800f01:	0f 47 4d 10          	cmova  0x10(%ebp),%ecx
  800f05:	89 4d d0             	mov    %ecx,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800f08:	89 d3                	mov    %edx,%ebx
  800f0a:	01 ca                	add    %ecx,%edx
  800f0c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800f0f:	eb 64                	jmp    800f75 <file_read+0x9e>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800f11:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f14:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f18:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800f1e:	85 db                	test   %ebx,%ebx
  800f20:	0f 49 c3             	cmovns %ebx,%eax
  800f23:	c1 f8 0c             	sar    $0xc,%eax
  800f26:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	89 04 24             	mov    %eax,(%esp)
  800f30:	e8 e7 fc ff ff       	call   800c1c <file_get_block>
  800f35:	85 c0                	test   %eax,%eax
  800f37:	78 46                	js     800f7f <file_read+0xa8>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800f39:	89 da                	mov    %ebx,%edx
  800f3b:	c1 fa 1f             	sar    $0x1f,%edx
  800f3e:	c1 ea 14             	shr    $0x14,%edx
  800f41:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800f44:	25 ff 0f 00 00       	and    $0xfff,%eax
  800f49:	29 d0                	sub    %edx,%eax
  800f4b:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800f50:	29 c1                	sub    %eax,%ecx
  800f52:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f55:	29 f2                	sub    %esi,%edx
  800f57:	39 d1                	cmp    %edx,%ecx
  800f59:	89 d6                	mov    %edx,%esi
  800f5b:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  800f5e:	89 74 24 08          	mov    %esi,0x8(%esp)
  800f62:	03 45 e4             	add    -0x1c(%ebp),%eax
  800f65:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f69:	89 3c 24             	mov    %edi,(%esp)
  800f6c:	e8 23 17 00 00       	call   802694 <memmove>
		pos += bn;
  800f71:	01 f3                	add    %esi,%ebx
		buf += bn;
  800f73:	01 f7                	add    %esi,%edi
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  800f75:	89 de                	mov    %ebx,%esi
  800f77:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
  800f7a:	72 95                	jb     800f11 <file_read+0x3a>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  800f7c:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  800f7f:	83 c4 3c             	add    $0x3c,%esp
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5f                   	pop    %edi
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    

00800f87 <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	57                   	push   %edi
  800f8b:	56                   	push   %esi
  800f8c:	53                   	push   %ebx
  800f8d:	83 ec 2c             	sub    $0x2c,%esp
  800f90:	8b 75 08             	mov    0x8(%ebp),%esi
	if (f->f_size > newsize)
  800f93:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  800f99:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800f9c:	0f 8e 9a 00 00 00    	jle    80103c <file_set_size+0xb5>
file_truncate_blocks(struct File *f, off_t newsize)
{
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800fa2:	8d b8 fe 1f 00 00    	lea    0x1ffe(%eax),%edi
  800fa8:	05 ff 0f 00 00       	add    $0xfff,%eax
  800fad:	0f 49 f8             	cmovns %eax,%edi
  800fb0:	c1 ff 0c             	sar    $0xc,%edi
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8d 90 fe 1f 00 00    	lea    0x1ffe(%eax),%edx
  800fbc:	05 ff 0f 00 00       	add    $0xfff,%eax
  800fc1:	0f 48 c2             	cmovs  %edx,%eax
  800fc4:	c1 f8 0c             	sar    $0xc,%eax
  800fc7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800fca:	89 c3                	mov    %eax,%ebx
  800fcc:	eb 34                	jmp    801002 <file_set_size+0x7b>
file_free_block(struct File *f, uint32_t filebno)
{
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800fce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fd5:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800fd8:	89 da                	mov    %ebx,%edx
  800fda:	89 f0                	mov    %esi,%eax
  800fdc:	e8 56 fa ff ff       	call   800a37 <file_block_walk>
  800fe1:	85 c0                	test   %eax,%eax
  800fe3:	78 45                	js     80102a <file_set_size+0xa3>
		return r;
	if (*ptr) {
  800fe5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fe8:	8b 00                	mov    (%eax),%eax
  800fea:	85 c0                	test   %eax,%eax
  800fec:	74 11                	je     800fff <file_set_size+0x78>
		free_block(*ptr);
  800fee:	89 04 24             	mov    %eax,(%esp)
  800ff1:	e8 93 f9 ff ff       	call   800989 <free_block>
		*ptr = 0;
  800ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ff9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800fff:	83 c3 01             	add    $0x1,%ebx
  801002:	39 df                	cmp    %ebx,%edi
  801004:	77 c8                	ja     800fce <file_set_size+0x47>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  801006:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
  80100a:	77 30                	ja     80103c <file_set_size+0xb5>
  80100c:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  801012:	85 c0                	test   %eax,%eax
  801014:	74 26                	je     80103c <file_set_size+0xb5>
		free_block(f->f_indirect);
  801016:	89 04 24             	mov    %eax,(%esp)
  801019:	e8 6b f9 ff ff       	call   800989 <free_block>
		f->f_indirect = 0;
  80101e:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
  801025:	00 00 00 
  801028:	eb 12                	jmp    80103c <file_set_size+0xb5>

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);
  80102a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80102e:	c7 04 24 1e 47 80 00 	movl   $0x80471e,(%esp)
  801035:	e8 92 0e 00 00       	call   801ecc <cprintf>
  80103a:	eb c3                	jmp    800fff <file_set_size+0x78>
int
file_set_size(struct File *f, off_t newsize)
{
	if (f->f_size > newsize)
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  80103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103f:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	flush_block(f);
  801045:	89 34 24             	mov    %esi,(%esp)
  801048:	e8 47 f4 ff ff       	call   800494 <flush_block>
	return 0;
}
  80104d:	b8 00 00 00 00       	mov    $0x0,%eax
  801052:	83 c4 2c             	add    $0x2c,%esp
  801055:	5b                   	pop    %ebx
  801056:	5e                   	pop    %esi
  801057:	5f                   	pop    %edi
  801058:	5d                   	pop    %ebp
  801059:	c3                   	ret    

0080105a <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	57                   	push   %edi
  80105e:	56                   	push   %esi
  80105f:	53                   	push   %ebx
  801060:	83 ec 2c             	sub    $0x2c,%esp
  801063:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801066:	8b 5d 14             	mov    0x14(%ebp),%ebx
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  801069:	89 d8                	mov    %ebx,%eax
  80106b:	03 45 10             	add    0x10(%ebp),%eax
  80106e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801071:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801074:	3b 81 80 00 00 00    	cmp    0x80(%ecx),%eax
  80107a:	76 7c                	jbe    8010f8 <file_write+0x9e>
		if ((r = file_set_size(f, offset + count)) < 0)
  80107c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80107f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	89 04 24             	mov    %eax,(%esp)
  801089:	e8 f9 fe ff ff       	call   800f87 <file_set_size>
  80108e:	85 c0                	test   %eax,%eax
  801090:	79 66                	jns    8010f8 <file_write+0x9e>
  801092:	eb 6e                	jmp    801102 <file_write+0xa8>
			return r;

	for (pos = offset; pos < offset + count; ) {
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  801094:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801097:	89 44 24 08          	mov    %eax,0x8(%esp)
  80109b:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  8010a1:	85 db                	test   %ebx,%ebx
  8010a3:	0f 49 c3             	cmovns %ebx,%eax
  8010a6:	c1 f8 0c             	sar    $0xc,%eax
  8010a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	89 04 24             	mov    %eax,(%esp)
  8010b3:	e8 64 fb ff ff       	call   800c1c <file_get_block>
  8010b8:	85 c0                	test   %eax,%eax
  8010ba:	78 46                	js     801102 <file_write+0xa8>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  8010bc:	89 da                	mov    %ebx,%edx
  8010be:	c1 fa 1f             	sar    $0x1f,%edx
  8010c1:	c1 ea 14             	shr    $0x14,%edx
  8010c4:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  8010c7:	25 ff 0f 00 00       	and    $0xfff,%eax
  8010cc:	29 d0                	sub    %edx,%eax
  8010ce:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8010d3:	29 c1                	sub    %eax,%ecx
  8010d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8010d8:	29 f2                	sub    %esi,%edx
  8010da:	39 d1                	cmp    %edx,%ecx
  8010dc:	89 d6                	mov    %edx,%esi
  8010de:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(blk + pos % BLKSIZE, buf, bn);
  8010e1:	89 74 24 08          	mov    %esi,0x8(%esp)
  8010e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010e9:	03 45 e4             	add    -0x1c(%ebp),%eax
  8010ec:	89 04 24             	mov    %eax,(%esp)
  8010ef:	e8 a0 15 00 00       	call   802694 <memmove>
		pos += bn;
  8010f4:	01 f3                	add    %esi,%ebx
		buf += bn;
  8010f6:	01 f7                	add    %esi,%edi
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  8010f8:	89 de                	mov    %ebx,%esi
  8010fa:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  8010fd:	77 95                	ja     801094 <file_write+0x3a>
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  8010ff:	8b 45 10             	mov    0x10(%ebp),%eax
}
  801102:	83 c4 2c             	add    $0x2c,%esp
  801105:	5b                   	pop    %ebx
  801106:	5e                   	pop    %esi
  801107:	5f                   	pop    %edi
  801108:	5d                   	pop    %ebp
  801109:	c3                   	ret    

0080110a <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	56                   	push   %esi
  80110e:	53                   	push   %ebx
  80110f:	83 ec 20             	sub    $0x20,%esp
  801112:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801115:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111a:	eb 37                	jmp    801153 <file_flush+0x49>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  80111c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801123:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  801126:	89 da                	mov    %ebx,%edx
  801128:	89 f0                	mov    %esi,%eax
  80112a:	e8 08 f9 ff ff       	call   800a37 <file_block_walk>
  80112f:	85 c0                	test   %eax,%eax
  801131:	78 1d                	js     801150 <file_flush+0x46>
		    pdiskbno == NULL || *pdiskbno == 0)
  801133:	8b 45 f4             	mov    -0xc(%ebp),%eax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  801136:	85 c0                	test   %eax,%eax
  801138:	74 16                	je     801150 <file_flush+0x46>
		    pdiskbno == NULL || *pdiskbno == 0)
  80113a:	8b 00                	mov    (%eax),%eax
  80113c:	85 c0                	test   %eax,%eax
  80113e:	74 10                	je     801150 <file_flush+0x46>
			continue;
		flush_block(diskaddr(*pdiskbno));
  801140:	89 04 24             	mov    %eax,(%esp)
  801143:	e8 c0 f2 ff ff       	call   800408 <diskaddr>
  801148:	89 04 24             	mov    %eax,(%esp)
  80114b:	e8 44 f3 ff ff       	call   800494 <flush_block>
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  801150:	83 c3 01             	add    $0x1,%ebx
  801153:	8b 96 80 00 00 00    	mov    0x80(%esi),%edx
  801159:	8d 8a ff 0f 00 00    	lea    0xfff(%edx),%ecx
  80115f:	8d 82 fe 1f 00 00    	lea    0x1ffe(%edx),%eax
  801165:	85 c9                	test   %ecx,%ecx
  801167:	0f 49 c1             	cmovns %ecx,%eax
  80116a:	c1 f8 0c             	sar    $0xc,%eax
  80116d:	39 c3                	cmp    %eax,%ebx
  80116f:	7c ab                	jl     80111c <file_flush+0x12>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  801171:	89 34 24             	mov    %esi,(%esp)
  801174:	e8 1b f3 ff ff       	call   800494 <flush_block>
	if (f->f_indirect)
  801179:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  80117f:	85 c0                	test   %eax,%eax
  801181:	74 10                	je     801193 <file_flush+0x89>
		flush_block(diskaddr(f->f_indirect));
  801183:	89 04 24             	mov    %eax,(%esp)
  801186:	e8 7d f2 ff ff       	call   800408 <diskaddr>
  80118b:	89 04 24             	mov    %eax,(%esp)
  80118e:	e8 01 f3 ff ff       	call   800494 <flush_block>
}
  801193:	83 c4 20             	add    $0x20,%esp
  801196:	5b                   	pop    %ebx
  801197:	5e                   	pop    %esi
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    

0080119a <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	57                   	push   %edi
  80119e:	56                   	push   %esi
  80119f:	53                   	push   %ebx
  8011a0:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  8011a6:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8011ac:	89 04 24             	mov    %eax,(%esp)
  8011af:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  8011b5:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	e8 bb fa ff ff       	call   800c7e <walk_path>
  8011c3:	89 c2                	mov    %eax,%edx
  8011c5:	85 c0                	test   %eax,%eax
  8011c7:	0f 84 e0 00 00 00    	je     8012ad <file_create+0x113>
		return -E_FILE_EXISTS;
	if (r != -E_NOT_FOUND || dir == 0)
  8011cd:	83 fa f5             	cmp    $0xfffffff5,%edx
  8011d0:	0f 85 1b 01 00 00    	jne    8012f1 <file_create+0x157>
  8011d6:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
  8011dc:	85 f6                	test   %esi,%esi
  8011de:	0f 84 d0 00 00 00    	je     8012b4 <file_create+0x11a>
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  8011e4:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  8011ea:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8011ef:	74 24                	je     801215 <file_create+0x7b>
  8011f1:	c7 44 24 0c 01 47 80 	movl   $0x804701,0xc(%esp)
  8011f8:	00 
  8011f9:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  801200:	00 
  801201:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  801208:	00 
  801209:	c7 04 24 69 46 80 00 	movl   $0x804669,(%esp)
  801210:	e8 be 0b 00 00       	call   801dd3 <_panic>
	nblock = dir->f_size / BLKSIZE;
  801215:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  80121b:	85 c0                	test   %eax,%eax
  80121d:	0f 48 c2             	cmovs  %edx,%eax
  801220:	c1 f8 0c             	sar    $0xc,%eax
  801223:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
	for (i = 0; i < nblock; i++) {
  801229:	bb 00 00 00 00       	mov    $0x0,%ebx
		if ((r = file_get_block(dir, i, &blk)) < 0)
  80122e:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  801234:	eb 3d                	jmp    801273 <file_create+0xd9>
  801236:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80123a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80123e:	89 34 24             	mov    %esi,(%esp)
  801241:	e8 d6 f9 ff ff       	call   800c1c <file_get_block>
  801246:	85 c0                	test   %eax,%eax
  801248:	0f 88 a3 00 00 00    	js     8012f1 <file_create+0x157>
  80124e:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
			return r;
		f = (struct File*) blk;
  801254:	ba 10 00 00 00       	mov    $0x10,%edx
		for (j = 0; j < BLKFILES; j++)
			if (f[j].f_name[0] == '\0') {
  801259:	80 38 00             	cmpb   $0x0,(%eax)
  80125c:	75 08                	jne    801266 <file_create+0xcc>
				*file = &f[j];
  80125e:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  801264:	eb 55                	jmp    8012bb <file_create+0x121>
  801266:	05 00 01 00 00       	add    $0x100,%eax
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  80126b:	83 ea 01             	sub    $0x1,%edx
  80126e:	75 e9                	jne    801259 <file_create+0xbf>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  801270:	83 c3 01             	add    $0x1,%ebx
  801273:	39 9d 54 ff ff ff    	cmp    %ebx,-0xac(%ebp)
  801279:	75 bb                	jne    801236 <file_create+0x9c>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  80127b:	81 86 80 00 00 00 00 	addl   $0x1000,0x80(%esi)
  801282:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801285:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  80128b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80128f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801293:	89 34 24             	mov    %esi,(%esp)
  801296:	e8 81 f9 ff ff       	call   800c1c <file_get_block>
  80129b:	85 c0                	test   %eax,%eax
  80129d:	78 52                	js     8012f1 <file_create+0x157>
		return r;
	f = (struct File*) blk;
	*file = &f[0];
  80129f:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8012a5:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  8012ab:	eb 0e                	jmp    8012bb <file_create+0x121>
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
		return -E_FILE_EXISTS;
  8012ad:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  8012b2:	eb 3d                	jmp    8012f1 <file_create+0x157>
	if (r != -E_NOT_FOUND || dir == 0)
		return r;
  8012b4:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8012b9:	eb 36                	jmp    8012f1 <file_create+0x157>
	if ((r = dir_alloc_file(dir, &f)) < 0)
		return r;

	strcpy(f->f_name, name);
  8012bb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8012c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c5:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8012cb:	89 04 24             	mov    %eax,(%esp)
  8012ce:	e8 24 12 00 00       	call   8024f7 <strcpy>
	*pf = f;
  8012d3:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  8012d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012dc:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  8012de:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8012e4:	89 04 24             	mov    %eax,(%esp)
  8012e7:	e8 1e fe ff ff       	call   80110a <file_flush>
	return 0;
  8012ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f1:	81 c4 bc 00 00 00    	add    $0xbc,%esp
  8012f7:	5b                   	pop    %ebx
  8012f8:	5e                   	pop    %esi
  8012f9:	5f                   	pop    %edi
  8012fa:	5d                   	pop    %ebp
  8012fb:	c3                   	ret    

008012fc <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	53                   	push   %ebx
  801300:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  801303:	bb 01 00 00 00       	mov    $0x1,%ebx
  801308:	eb 13                	jmp    80131d <fs_sync+0x21>
		flush_block(diskaddr(i));
  80130a:	89 1c 24             	mov    %ebx,(%esp)
  80130d:	e8 f6 f0 ff ff       	call   800408 <diskaddr>
  801312:	89 04 24             	mov    %eax,(%esp)
  801315:	e8 7a f1 ff ff       	call   800494 <flush_block>
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  80131a:	83 c3 01             	add    $0x1,%ebx
  80131d:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  801322:	3b 58 04             	cmp    0x4(%eax),%ebx
  801325:	72 e3                	jb     80130a <fs_sync+0xe>
		flush_block(diskaddr(i));
}
  801327:	83 c4 14             	add    $0x14,%esp
  80132a:	5b                   	pop    %ebx
  80132b:	5d                   	pop    %ebp
  80132c:	c3                   	ret    
  80132d:	66 90                	xchg   %ax,%ax
  80132f:	90                   	nop

00801330 <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  801336:	e8 c1 ff ff ff       	call   8012fc <fs_sync>
	return 0;
}
  80133b:	b8 00 00 00 00       	mov    $0x0,%eax
  801340:	c9                   	leave  
  801341:	c3                   	ret    

00801342 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  801342:	55                   	push   %ebp
  801343:	89 e5                	mov    %esp,%ebp
  801345:	ba 60 50 80 00       	mov    $0x805060,%edx
	int i;
	uintptr_t va = FILEVA;
  80134a:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  80134f:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  801354:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  801356:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  801359:	81 c1 00 10 00 00    	add    $0x1000,%ecx
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  80135f:	83 c0 01             	add    $0x1,%eax
  801362:	83 c2 10             	add    $0x10,%edx
  801365:	3d 00 04 00 00       	cmp    $0x400,%eax
  80136a:	75 e8                	jne    801354 <serve_init+0x12>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  80136c:	5d                   	pop    %ebp
  80136d:	c3                   	ret    

0080136e <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
  801371:	56                   	push   %esi
  801372:	53                   	push   %ebx
  801373:	83 ec 10             	sub    $0x10,%esp
  801376:	8b 75 08             	mov    0x8(%ebp),%esi
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801379:	bb 00 00 00 00       	mov    $0x0,%ebx
  80137e:	89 d8                	mov    %ebx,%eax
  801380:	c1 e0 04             	shl    $0x4,%eax
		switch (pageref(opentab[i].o_fd)) {
  801383:	8b 80 6c 50 80 00    	mov    0x80506c(%eax),%eax
  801389:	89 04 24             	mov    %eax,(%esp)
  80138c:	e8 79 23 00 00       	call   80370a <pageref>
  801391:	85 c0                	test   %eax,%eax
  801393:	74 0d                	je     8013a2 <openfile_alloc+0x34>
  801395:	83 f8 01             	cmp    $0x1,%eax
  801398:	74 31                	je     8013cb <openfile_alloc+0x5d>
  80139a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8013a0:	eb 62                	jmp    801404 <openfile_alloc+0x96>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  8013a2:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013a9:	00 
  8013aa:	89 d8                	mov    %ebx,%eax
  8013ac:	c1 e0 04             	shl    $0x4,%eax
  8013af:	8b 80 6c 50 80 00    	mov    0x80506c(%eax),%eax
  8013b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013c0:	e8 4e 15 00 00       	call   802913 <sys_page_alloc>
  8013c5:	89 c2                	mov    %eax,%edx
  8013c7:	85 d2                	test   %edx,%edx
  8013c9:	78 4d                	js     801418 <openfile_alloc+0xaa>
				return r;
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  8013cb:	c1 e3 04             	shl    $0x4,%ebx
  8013ce:	8d 83 60 50 80 00    	lea    0x805060(%ebx),%eax
  8013d4:	81 83 60 50 80 00 00 	addl   $0x400,0x805060(%ebx)
  8013db:	04 00 00 
			*o = &opentab[i];
  8013de:	89 06                	mov    %eax,(%esi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  8013e0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8013e7:	00 
  8013e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8013ef:	00 
  8013f0:	8b 83 6c 50 80 00    	mov    0x80506c(%ebx),%eax
  8013f6:	89 04 24             	mov    %eax,(%esp)
  8013f9:	e8 49 12 00 00       	call   802647 <memset>
			return (*o)->o_fileid;
  8013fe:	8b 06                	mov    (%esi),%eax
  801400:	8b 00                	mov    (%eax),%eax
  801402:	eb 14                	jmp    801418 <openfile_alloc+0xaa>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801404:	83 c3 01             	add    $0x1,%ebx
  801407:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  80140d:	0f 85 6b ff ff ff    	jne    80137e <openfile_alloc+0x10>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	return -E_MAX_OPEN;
  801413:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	5b                   	pop    %ebx
  80141c:	5e                   	pop    %esi
  80141d:	5d                   	pop    %ebp
  80141e:	c3                   	ret    

0080141f <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	57                   	push   %edi
  801423:	56                   	push   %esi
  801424:	53                   	push   %ebx
  801425:	83 ec 1c             	sub    $0x1c,%esp
  801428:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  80142b:	89 de                	mov    %ebx,%esi
  80142d:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801433:	c1 e6 04             	shl    $0x4,%esi
  801436:	8d be 60 50 80 00    	lea    0x805060(%esi),%edi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  80143c:	8b 86 6c 50 80 00    	mov    0x80506c(%esi),%eax
  801442:	89 04 24             	mov    %eax,(%esp)
  801445:	e8 c0 22 00 00       	call   80370a <pageref>
  80144a:	83 f8 01             	cmp    $0x1,%eax
  80144d:	7e 14                	jle    801463 <openfile_lookup+0x44>
  80144f:	39 9e 60 50 80 00    	cmp    %ebx,0x805060(%esi)
  801455:	75 13                	jne    80146a <openfile_lookup+0x4b>
		return -E_INVAL;
	*po = o;
  801457:	8b 45 10             	mov    0x10(%ebp),%eax
  80145a:	89 38                	mov    %edi,(%eax)
	return 0;
  80145c:	b8 00 00 00 00       	mov    $0x0,%eax
  801461:	eb 0c                	jmp    80146f <openfile_lookup+0x50>
{
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
		return -E_INVAL;
  801463:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801468:	eb 05                	jmp    80146f <openfile_lookup+0x50>
  80146a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	*po = o;
	return 0;
}
  80146f:	83 c4 1c             	add    $0x1c,%esp
  801472:	5b                   	pop    %ebx
  801473:	5e                   	pop    %esi
  801474:	5f                   	pop    %edi
  801475:	5d                   	pop    %ebp
  801476:	c3                   	ret    

00801477 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	53                   	push   %ebx
  80147b:	83 ec 24             	sub    $0x24,%esp
  80147e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801481:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801484:	89 44 24 08          	mov    %eax,0x8(%esp)
  801488:	8b 03                	mov    (%ebx),%eax
  80148a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	89 04 24             	mov    %eax,(%esp)
  801494:	e8 86 ff ff ff       	call   80141f <openfile_lookup>
  801499:	89 c2                	mov    %eax,%edx
  80149b:	85 d2                	test   %edx,%edx
  80149d:	78 15                	js     8014b4 <serve_set_size+0x3d>
		return r;

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  80149f:	8b 43 04             	mov    0x4(%ebx),%eax
  8014a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a9:	8b 40 04             	mov    0x4(%eax),%eax
  8014ac:	89 04 24             	mov    %eax,(%esp)
  8014af:	e8 d3 fa ff ff       	call   800f87 <file_set_size>
}
  8014b4:	83 c4 24             	add    $0x24,%esp
  8014b7:	5b                   	pop    %ebx
  8014b8:	5d                   	pop    %ebp
  8014b9:	c3                   	ret    

008014ba <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	53                   	push   %ebx
  8014be:	83 ec 24             	sub    $0x24,%esp
  8014c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		cprintf("serve_read %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// Lab 5: Your code here:
	int r;
	struct OpenFile *o;
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8014c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014cb:	8b 03                	mov    (%ebx),%eax
  8014cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	89 04 24             	mov    %eax,(%esp)
  8014d7:	e8 43 ff ff ff       	call   80141f <openfile_lookup>
		return r;
  8014dc:	89 c2                	mov    %eax,%edx
		cprintf("serve_read %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// Lab 5: Your code here:
	int r;
	struct OpenFile *o;
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8014de:	85 c0                	test   %eax,%eax
  8014e0:	78 34                	js     801516 <serve_read+0x5c>
		return r;

	int nread = file_read(o->o_file, ret->ret_buf, req->req_n, o->o_fd->fd_offset);
  8014e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e5:	8b 50 0c             	mov    0xc(%eax),%edx
  8014e8:	8b 52 04             	mov    0x4(%edx),%edx
  8014eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8014ef:	8b 53 04             	mov    0x4(%ebx),%edx
  8014f2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8014f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014fa:	8b 40 04             	mov    0x4(%eax),%eax
  8014fd:	89 04 24             	mov    %eax,(%esp)
  801500:	e8 d2 f9 ff ff       	call   800ed7 <file_read>
	if (nread > 0) {
		o->o_fd->fd_offset += nread;
	}
	return nread;
  801505:	89 c2                	mov    %eax,%edx
	struct OpenFile *o;
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	int nread = file_read(o->o_file, ret->ret_buf, req->req_n, o->o_fd->fd_offset);
	if (nread > 0) {
  801507:	85 c0                	test   %eax,%eax
  801509:	7e 0b                	jle    801516 <serve_read+0x5c>
		o->o_fd->fd_offset += nread;
  80150b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150e:	8b 52 0c             	mov    0xc(%edx),%edx
  801511:	01 42 04             	add    %eax,0x4(%edx)
	}
	return nread;
  801514:	89 c2                	mov    %eax,%edx
}
  801516:	89 d0                	mov    %edx,%eax
  801518:	83 c4 24             	add    $0x24,%esp
  80151b:	5b                   	pop    %ebx
  80151c:	5d                   	pop    %ebp
  80151d:	c3                   	ret    

0080151e <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	53                   	push   %ebx
  801522:	83 ec 24             	sub    $0x24,%esp
  801525:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	struct OpenFile *o;
	int r;
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801528:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80152f:	8b 03                	mov    (%ebx),%eax
  801531:	89 44 24 04          	mov    %eax,0x4(%esp)
  801535:	8b 45 08             	mov    0x8(%ebp),%eax
  801538:	89 04 24             	mov    %eax,(%esp)
  80153b:	e8 df fe ff ff       	call   80141f <openfile_lookup>
		return r;
  801540:	89 c2                	mov    %eax,%edx
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
	struct OpenFile *o;
	int r;
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801542:	85 c0                	test   %eax,%eax
  801544:	78 37                	js     80157d <serve_write+0x5f>
		return r;

	int nwrite = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset);
  801546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801549:	8b 50 0c             	mov    0xc(%eax),%edx
  80154c:	8b 52 04             	mov    0x4(%edx),%edx
  80154f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801553:	8b 53 04             	mov    0x4(%ebx),%edx
  801556:	89 54 24 08          	mov    %edx,0x8(%esp)
  80155a:	83 c3 08             	add    $0x8,%ebx
  80155d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801561:	8b 40 04             	mov    0x4(%eax),%eax
  801564:	89 04 24             	mov    %eax,(%esp)
  801567:	e8 ee fa ff ff       	call   80105a <file_write>
	if (nwrite > 0) {
		o->o_fd->fd_offset += nwrite;
	}
	return nwrite;
  80156c:	89 c2                	mov    %eax,%edx
	int r;
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	int nwrite = file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset);
	if (nwrite > 0) {
  80156e:	85 c0                	test   %eax,%eax
  801570:	7e 0b                	jle    80157d <serve_write+0x5f>
		o->o_fd->fd_offset += nwrite;
  801572:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801575:	8b 52 0c             	mov    0xc(%edx),%edx
  801578:	01 42 04             	add    %eax,0x4(%edx)
	}
	return nwrite;
  80157b:	89 c2                	mov    %eax,%edx
}
  80157d:	89 d0                	mov    %edx,%eax
  80157f:	83 c4 24             	add    $0x24,%esp
  801582:	5b                   	pop    %ebx
  801583:	5d                   	pop    %ebp
  801584:	c3                   	ret    

00801585 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	53                   	push   %ebx
  801589:	83 ec 24             	sub    $0x24,%esp
  80158c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80158f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801592:	89 44 24 08          	mov    %eax,0x8(%esp)
  801596:	8b 03                	mov    (%ebx),%eax
  801598:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	89 04 24             	mov    %eax,(%esp)
  8015a2:	e8 78 fe ff ff       	call   80141f <openfile_lookup>
  8015a7:	89 c2                	mov    %eax,%edx
  8015a9:	85 d2                	test   %edx,%edx
  8015ab:	78 3f                	js     8015ec <serve_stat+0x67>
		return r;

	strcpy(ret->ret_name, o->o_file->f_name);
  8015ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b0:	8b 40 04             	mov    0x4(%eax),%eax
  8015b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b7:	89 1c 24             	mov    %ebx,(%esp)
  8015ba:	e8 38 0f 00 00       	call   8024f7 <strcpy>
	ret->ret_size = o->o_file->f_size;
  8015bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c2:	8b 50 04             	mov    0x4(%eax),%edx
  8015c5:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  8015cb:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8015d1:	8b 40 04             	mov    0x4(%eax),%eax
  8015d4:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  8015db:	0f 94 c0             	sete   %al
  8015de:	0f b6 c0             	movzbl %al,%eax
  8015e1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ec:	83 c4 24             	add    $0x24,%esp
  8015ef:	5b                   	pop    %ebx
  8015f0:	5d                   	pop    %ebp
  8015f1:	c3                   	ret    

008015f2 <serve_flush>:

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 28             	sub    $0x28,%esp
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8015f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801602:	8b 00                	mov    (%eax),%eax
  801604:	89 44 24 04          	mov    %eax,0x4(%esp)
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	89 04 24             	mov    %eax,(%esp)
  80160e:	e8 0c fe ff ff       	call   80141f <openfile_lookup>
  801613:	89 c2                	mov    %eax,%edx
  801615:	85 d2                	test   %edx,%edx
  801617:	78 13                	js     80162c <serve_flush+0x3a>
		return r;
	file_flush(o->o_file);
  801619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161c:	8b 40 04             	mov    0x4(%eax),%eax
  80161f:	89 04 24             	mov    %eax,(%esp)
  801622:	e8 e3 fa ff ff       	call   80110a <file_flush>
	return 0;
  801627:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	53                   	push   %ebx
  801632:	81 ec 24 04 00 00    	sub    $0x424,%esp
  801638:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  80163b:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  801642:	00 
  801643:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801647:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  80164d:	89 04 24             	mov    %eax,(%esp)
  801650:	e8 3f 10 00 00       	call   802694 <memmove>
	path[MAXPATHLEN-1] = 0;
  801655:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  801659:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  80165f:	89 04 24             	mov    %eax,(%esp)
  801662:	e8 07 fd ff ff       	call   80136e <openfile_alloc>
  801667:	85 c0                	test   %eax,%eax
  801669:	0f 88 f2 00 00 00    	js     801761 <serve_open+0x133>
		return r;
	}
	fileid = r;

	// Open the file
	if (req->req_omode & O_CREAT) {
  80166f:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  801676:	74 34                	je     8016ac <serve_open+0x7e>
		if ((r = file_create(path, &f)) < 0) {
  801678:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  80167e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801682:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801688:	89 04 24             	mov    %eax,(%esp)
  80168b:	e8 0a fb ff ff       	call   80119a <file_create>
  801690:	89 c2                	mov    %eax,%edx
  801692:	85 c0                	test   %eax,%eax
  801694:	79 36                	jns    8016cc <serve_open+0x9e>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  801696:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  80169d:	0f 85 be 00 00 00    	jne    801761 <serve_open+0x133>
  8016a3:	83 fa f3             	cmp    $0xfffffff3,%edx
  8016a6:	0f 85 b5 00 00 00    	jne    801761 <serve_open+0x133>
				cprintf("file_create failed: %e", r);
			return r;
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  8016ac:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8016b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b6:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8016bc:	89 04 24             	mov    %eax,(%esp)
  8016bf:	e8 f4 f7 ff ff       	call   800eb8 <file_open>
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	0f 88 95 00 00 00    	js     801761 <serve_open+0x133>
			return r;
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  8016cc:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  8016d3:	74 1a                	je     8016ef <serve_open+0xc1>
		if ((r = file_set_size(f, 0)) < 0) {
  8016d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016dc:	00 
  8016dd:	8b 85 f4 fb ff ff    	mov    -0x40c(%ebp),%eax
  8016e3:	89 04 24             	mov    %eax,(%esp)
  8016e6:	e8 9c f8 ff ff       	call   800f87 <file_set_size>
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	78 72                	js     801761 <serve_open+0x133>
			if (debug)
				cprintf("file_set_size failed: %e", r);
			return r;
		}
	}
	if ((r = file_open(path, &f)) < 0) {
  8016ef:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8016f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f9:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8016ff:	89 04 24             	mov    %eax,(%esp)
  801702:	e8 b1 f7 ff ff       	call   800eb8 <file_open>
  801707:	85 c0                	test   %eax,%eax
  801709:	78 56                	js     801761 <serve_open+0x133>
			cprintf("file_open failed: %e", r);
		return r;
	}

	// Save the file pointer
	o->o_file = f;
  80170b:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801711:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  801717:	89 50 04             	mov    %edx,0x4(%eax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  80171a:	8b 50 0c             	mov    0xc(%eax),%edx
  80171d:	8b 08                	mov    (%eax),%ecx
  80171f:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  801722:	8b 50 0c             	mov    0xc(%eax),%edx
  801725:	8b 8b 00 04 00 00    	mov    0x400(%ebx),%ecx
  80172b:	83 e1 03             	and    $0x3,%ecx
  80172e:	89 4a 08             	mov    %ecx,0x8(%edx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801731:	8b 40 0c             	mov    0xc(%eax),%eax
  801734:	8b 15 64 90 80 00    	mov    0x809064,%edx
  80173a:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  80173c:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801742:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  801748:	89 50 08             	mov    %edx,0x8(%eax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  80174b:	8b 50 0c             	mov    0xc(%eax),%edx
  80174e:	8b 45 10             	mov    0x10(%ebp),%eax
  801751:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  801753:	8b 45 14             	mov    0x14(%ebp),%eax
  801756:	c7 00 07 04 00 00    	movl   $0x407,(%eax)

	return 0;
  80175c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801761:	81 c4 24 04 00 00    	add    $0x424,%esp
  801767:	5b                   	pop    %ebx
  801768:	5d                   	pop    %ebp
  801769:	c3                   	ret    

0080176a <serve>:
	[FSREQ_SYNC] =		serve_sync
};

void
serve(void)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	56                   	push   %esi
  80176e:	53                   	push   %ebx
  80176f:	83 ec 20             	sub    $0x20,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801772:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  801775:	8d 75 f4             	lea    -0xc(%ebp),%esi
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  801778:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  80177f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801783:	a1 44 50 80 00       	mov    0x805044,%eax
  801788:	89 44 24 04          	mov    %eax,0x4(%esp)
  80178c:	89 34 24             	mov    %esi,(%esp)
  80178f:	e8 6c 15 00 00       	call   802d00 <ipc_recv>
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  801794:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  801798:	75 15                	jne    8017af <serve+0x45>
			cprintf("Invalid request from %08x: no argument page\n",
  80179a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a1:	c7 04 24 6c 47 80 00 	movl   $0x80476c,(%esp)
  8017a8:	e8 1f 07 00 00       	call   801ecc <cprintf>
				whom);
			continue; // just leave it hanging...
  8017ad:	eb c9                	jmp    801778 <serve+0xe>
		}

		pg = NULL;
  8017af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  8017b6:	83 f8 01             	cmp    $0x1,%eax
  8017b9:	75 21                	jne    8017dc <serve+0x72>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8017bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8017bf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017c6:	a1 44 50 80 00       	mov    0x805044,%eax
  8017cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d2:	89 04 24             	mov    %eax,(%esp)
  8017d5:	e8 54 fe ff ff       	call   80162e <serve_open>
  8017da:	eb 3f                	jmp    80181b <serve+0xb1>
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  8017dc:	83 f8 08             	cmp    $0x8,%eax
  8017df:	77 1e                	ja     8017ff <serve+0x95>
  8017e1:	8b 14 85 20 50 80 00 	mov    0x805020(,%eax,4),%edx
  8017e8:	85 d2                	test   %edx,%edx
  8017ea:	74 13                	je     8017ff <serve+0x95>
			r = handlers[req](whom, fsreq);
  8017ec:	a1 44 50 80 00       	mov    0x805044,%eax
  8017f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f8:	89 04 24             	mov    %eax,(%esp)
  8017fb:	ff d2                	call   *%edx
  8017fd:	eb 1c                	jmp    80181b <serve+0xb1>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  8017ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801802:	89 54 24 08          	mov    %edx,0x8(%esp)
  801806:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180a:	c7 04 24 9c 47 80 00 	movl   $0x80479c,(%esp)
  801811:	e8 b6 06 00 00       	call   801ecc <cprintf>
			r = -E_INVAL;
  801816:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  80181b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80181e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801822:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801825:	89 54 24 08          	mov    %edx,0x8(%esp)
  801829:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801830:	89 04 24             	mov    %eax,(%esp)
  801833:	e8 30 15 00 00       	call   802d68 <ipc_send>
		sys_page_unmap(0, fsreq);
  801838:	a1 44 50 80 00       	mov    0x805044,%eax
  80183d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801841:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801848:	e8 6d 11 00 00       	call   8029ba <sys_page_unmap>
  80184d:	e9 26 ff ff ff       	jmp    801778 <serve+0xe>

00801852 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  801858:	c7 05 60 90 80 00 bf 	movl   $0x8047bf,0x809060
  80185f:	47 80 00 
	cprintf("FS is running\n");
  801862:	c7 04 24 c2 47 80 00 	movl   $0x8047c2,(%esp)
  801869:	e8 5e 06 00 00       	call   801ecc <cprintf>
}

static inline void
outw(int port, uint16_t data)
{
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
  80186e:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  801873:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  801878:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  80187a:	c7 04 24 d1 47 80 00 	movl   $0x8047d1,(%esp)
  801881:	e8 46 06 00 00       	call   801ecc <cprintf>

	serve_init();
  801886:	e8 b7 fa ff ff       	call   801342 <serve_init>
	fs_init();
  80188b:	e8 30 f3 ff ff       	call   800bc0 <fs_init>
	serve();
  801890:	e8 d5 fe ff ff       	call   80176a <serve>

00801895 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	53                   	push   %ebx
  801899:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  80189c:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8018a3:	00 
  8018a4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  8018ab:	00 
  8018ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018b3:	e8 5b 10 00 00       	call   802913 <sys_page_alloc>
  8018b8:	85 c0                	test   %eax,%eax
  8018ba:	79 20                	jns    8018dc <fs_test+0x47>
		panic("sys_page_alloc: %e", r);
  8018bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018c0:	c7 44 24 08 e0 47 80 	movl   $0x8047e0,0x8(%esp)
  8018c7:	00 
  8018c8:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8018cf:	00 
  8018d0:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  8018d7:	e8 f7 04 00 00       	call   801dd3 <_panic>
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  8018dc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8018e3:	00 
  8018e4:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8018e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ed:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  8018f4:	e8 9b 0d 00 00       	call   802694 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  8018f9:	e8 cf f0 ff ff       	call   8009cd <alloc_block>
  8018fe:	85 c0                	test   %eax,%eax
  801900:	79 20                	jns    801922 <fs_test+0x8d>
		panic("alloc_block: %e", r);
  801902:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801906:	c7 44 24 08 fd 47 80 	movl   $0x8047fd,0x8(%esp)
  80190d:	00 
  80190e:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  801915:	00 
  801916:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  80191d:	e8 b1 04 00 00       	call   801dd3 <_panic>
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  801922:	8d 58 1f             	lea    0x1f(%eax),%ebx
  801925:	85 c0                	test   %eax,%eax
  801927:	0f 49 d8             	cmovns %eax,%ebx
  80192a:	c1 fb 05             	sar    $0x5,%ebx
  80192d:	99                   	cltd   
  80192e:	c1 ea 1b             	shr    $0x1b,%edx
  801931:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801934:	83 e1 1f             	and    $0x1f,%ecx
  801937:	29 d1                	sub    %edx,%ecx
  801939:	ba 01 00 00 00       	mov    $0x1,%edx
  80193e:	d3 e2                	shl    %cl,%edx
  801940:	85 14 9d 00 10 00 00 	test   %edx,0x1000(,%ebx,4)
  801947:	75 24                	jne    80196d <fs_test+0xd8>
  801949:	c7 44 24 0c 0d 48 80 	movl   $0x80480d,0xc(%esp)
  801950:	00 
  801951:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  801958:	00 
  801959:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  801960:	00 
  801961:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801968:	e8 66 04 00 00       	call   801dd3 <_panic>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  80196d:	a1 08 a0 80 00       	mov    0x80a008,%eax
  801972:	85 14 98             	test   %edx,(%eax,%ebx,4)
  801975:	74 24                	je     80199b <fs_test+0x106>
  801977:	c7 44 24 0c 88 49 80 	movl   $0x804988,0xc(%esp)
  80197e:	00 
  80197f:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  801986:	00 
  801987:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  80198e:	00 
  80198f:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801996:	e8 38 04 00 00       	call   801dd3 <_panic>
	cprintf("alloc_block is good\n");
  80199b:	c7 04 24 28 48 80 00 	movl   $0x804828,(%esp)
  8019a2:	e8 25 05 00 00       	call   801ecc <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  8019a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ae:	c7 04 24 3d 48 80 00 	movl   $0x80483d,(%esp)
  8019b5:	e8 fe f4 ff ff       	call   800eb8 <file_open>
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	79 25                	jns    8019e3 <fs_test+0x14e>
  8019be:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8019c1:	74 40                	je     801a03 <fs_test+0x16e>
		panic("file_open /not-found: %e", r);
  8019c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019c7:	c7 44 24 08 48 48 80 	movl   $0x804848,0x8(%esp)
  8019ce:	00 
  8019cf:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8019d6:	00 
  8019d7:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  8019de:	e8 f0 03 00 00       	call   801dd3 <_panic>
	else if (r == 0)
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	75 1c                	jne    801a03 <fs_test+0x16e>
		panic("file_open /not-found succeeded!");
  8019e7:	c7 44 24 08 a8 49 80 	movl   $0x8049a8,0x8(%esp)
  8019ee:	00 
  8019ef:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8019f6:	00 
  8019f7:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  8019fe:	e8 d0 03 00 00       	call   801dd3 <_panic>
	if ((r = file_open("/newmotd", &f)) < 0)
  801a03:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a06:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0a:	c7 04 24 61 48 80 00 	movl   $0x804861,(%esp)
  801a11:	e8 a2 f4 ff ff       	call   800eb8 <file_open>
  801a16:	85 c0                	test   %eax,%eax
  801a18:	79 20                	jns    801a3a <fs_test+0x1a5>
		panic("file_open /newmotd: %e", r);
  801a1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a1e:	c7 44 24 08 6a 48 80 	movl   $0x80486a,0x8(%esp)
  801a25:	00 
  801a26:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801a2d:	00 
  801a2e:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801a35:	e8 99 03 00 00       	call   801dd3 <_panic>
	cprintf("file_open is good\n");
  801a3a:	c7 04 24 81 48 80 00 	movl   $0x804881,(%esp)
  801a41:	e8 86 04 00 00       	call   801ecc <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  801a46:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a49:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a4d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a54:	00 
  801a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a58:	89 04 24             	mov    %eax,(%esp)
  801a5b:	e8 bc f1 ff ff       	call   800c1c <file_get_block>
  801a60:	85 c0                	test   %eax,%eax
  801a62:	79 20                	jns    801a84 <fs_test+0x1ef>
		panic("file_get_block: %e", r);
  801a64:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a68:	c7 44 24 08 94 48 80 	movl   $0x804894,0x8(%esp)
  801a6f:	00 
  801a70:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  801a77:	00 
  801a78:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801a7f:	e8 4f 03 00 00       	call   801dd3 <_panic>
	if (strcmp(blk, msg) != 0)
  801a84:	c7 44 24 04 c8 49 80 	movl   $0x8049c8,0x4(%esp)
  801a8b:	00 
  801a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8f:	89 04 24             	mov    %eax,(%esp)
  801a92:	e8 15 0b 00 00       	call   8025ac <strcmp>
  801a97:	85 c0                	test   %eax,%eax
  801a99:	74 1c                	je     801ab7 <fs_test+0x222>
		panic("file_get_block returned wrong data");
  801a9b:	c7 44 24 08 f0 49 80 	movl   $0x8049f0,0x8(%esp)
  801aa2:	00 
  801aa3:	c7 44 24 04 29 00 00 	movl   $0x29,0x4(%esp)
  801aaa:	00 
  801aab:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801ab2:	e8 1c 03 00 00       	call   801dd3 <_panic>
	cprintf("file_get_block is good\n");
  801ab7:	c7 04 24 a7 48 80 00 	movl   $0x8048a7,(%esp)
  801abe:	e8 09 04 00 00       	call   801ecc <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac6:	0f b6 10             	movzbl (%eax),%edx
  801ac9:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ace:	c1 e8 0c             	shr    $0xc,%eax
  801ad1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ad8:	a8 40                	test   $0x40,%al
  801ada:	75 24                	jne    801b00 <fs_test+0x26b>
  801adc:	c7 44 24 0c c0 48 80 	movl   $0x8048c0,0xc(%esp)
  801ae3:	00 
  801ae4:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  801aeb:	00 
  801aec:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  801af3:	00 
  801af4:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801afb:	e8 d3 02 00 00       	call   801dd3 <_panic>
	file_flush(f);
  801b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b03:	89 04 24             	mov    %eax,(%esp)
  801b06:	e8 ff f5 ff ff       	call   80110a <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0e:	c1 e8 0c             	shr    $0xc,%eax
  801b11:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801b18:	a8 40                	test   $0x40,%al
  801b1a:	74 24                	je     801b40 <fs_test+0x2ab>
  801b1c:	c7 44 24 0c bf 48 80 	movl   $0x8048bf,0xc(%esp)
  801b23:	00 
  801b24:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  801b2b:	00 
  801b2c:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  801b33:	00 
  801b34:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801b3b:	e8 93 02 00 00       	call   801dd3 <_panic>
	cprintf("file_flush is good\n");
  801b40:	c7 04 24 db 48 80 00 	movl   $0x8048db,(%esp)
  801b47:	e8 80 03 00 00       	call   801ecc <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801b4c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b53:	00 
  801b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b57:	89 04 24             	mov    %eax,(%esp)
  801b5a:	e8 28 f4 ff ff       	call   800f87 <file_set_size>
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	79 20                	jns    801b83 <fs_test+0x2ee>
		panic("file_set_size: %e", r);
  801b63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b67:	c7 44 24 08 ef 48 80 	movl   $0x8048ef,0x8(%esp)
  801b6e:	00 
  801b6f:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801b76:	00 
  801b77:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801b7e:	e8 50 02 00 00       	call   801dd3 <_panic>
	assert(f->f_direct[0] == 0);
  801b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b86:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801b8d:	74 24                	je     801bb3 <fs_test+0x31e>
  801b8f:	c7 44 24 0c 01 49 80 	movl   $0x804901,0xc(%esp)
  801b96:	00 
  801b97:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  801b9e:	00 
  801b9f:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801ba6:	00 
  801ba7:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801bae:	e8 20 02 00 00       	call   801dd3 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801bb3:	c1 e8 0c             	shr    $0xc,%eax
  801bb6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bbd:	a8 40                	test   $0x40,%al
  801bbf:	74 24                	je     801be5 <fs_test+0x350>
  801bc1:	c7 44 24 0c 15 49 80 	movl   $0x804915,0xc(%esp)
  801bc8:	00 
  801bc9:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  801bd0:	00 
  801bd1:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  801bd8:	00 
  801bd9:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801be0:	e8 ee 01 00 00       	call   801dd3 <_panic>
	cprintf("file_truncate is good\n");
  801be5:	c7 04 24 2f 49 80 00 	movl   $0x80492f,(%esp)
  801bec:	e8 db 02 00 00       	call   801ecc <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  801bf1:	c7 04 24 c8 49 80 00 	movl   $0x8049c8,(%esp)
  801bf8:	e8 c3 08 00 00       	call   8024c0 <strlen>
  801bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c04:	89 04 24             	mov    %eax,(%esp)
  801c07:	e8 7b f3 ff ff       	call   800f87 <file_set_size>
  801c0c:	85 c0                	test   %eax,%eax
  801c0e:	79 20                	jns    801c30 <fs_test+0x39b>
		panic("file_set_size 2: %e", r);
  801c10:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c14:	c7 44 24 08 46 49 80 	movl   $0x804946,0x8(%esp)
  801c1b:	00 
  801c1c:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  801c23:	00 
  801c24:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801c2b:	e8 a3 01 00 00       	call   801dd3 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c33:	89 c2                	mov    %eax,%edx
  801c35:	c1 ea 0c             	shr    $0xc,%edx
  801c38:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c3f:	f6 c2 40             	test   $0x40,%dl
  801c42:	74 24                	je     801c68 <fs_test+0x3d3>
  801c44:	c7 44 24 0c 15 49 80 	movl   $0x804915,0xc(%esp)
  801c4b:	00 
  801c4c:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  801c53:	00 
  801c54:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801c5b:	00 
  801c5c:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801c63:	e8 6b 01 00 00       	call   801dd3 <_panic>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801c68:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801c6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c76:	00 
  801c77:	89 04 24             	mov    %eax,(%esp)
  801c7a:	e8 9d ef ff ff       	call   800c1c <file_get_block>
  801c7f:	85 c0                	test   %eax,%eax
  801c81:	79 20                	jns    801ca3 <fs_test+0x40e>
		panic("file_get_block 2: %e", r);
  801c83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c87:	c7 44 24 08 5a 49 80 	movl   $0x80495a,0x8(%esp)
  801c8e:	00 
  801c8f:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  801c96:	00 
  801c97:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801c9e:	e8 30 01 00 00       	call   801dd3 <_panic>
	strcpy(blk, msg);
  801ca3:	c7 44 24 04 c8 49 80 	movl   $0x8049c8,0x4(%esp)
  801caa:	00 
  801cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cae:	89 04 24             	mov    %eax,(%esp)
  801cb1:	e8 41 08 00 00       	call   8024f7 <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb9:	c1 e8 0c             	shr    $0xc,%eax
  801cbc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801cc3:	a8 40                	test   $0x40,%al
  801cc5:	75 24                	jne    801ceb <fs_test+0x456>
  801cc7:	c7 44 24 0c c0 48 80 	movl   $0x8048c0,0xc(%esp)
  801cce:	00 
  801ccf:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  801cd6:	00 
  801cd7:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  801cde:	00 
  801cdf:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801ce6:	e8 e8 00 00 00       	call   801dd3 <_panic>
	file_flush(f);
  801ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cee:	89 04 24             	mov    %eax,(%esp)
  801cf1:	e8 14 f4 ff ff       	call   80110a <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  801cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf9:	c1 e8 0c             	shr    $0xc,%eax
  801cfc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801d03:	a8 40                	test   $0x40,%al
  801d05:	74 24                	je     801d2b <fs_test+0x496>
  801d07:	c7 44 24 0c bf 48 80 	movl   $0x8048bf,0xc(%esp)
  801d0e:	00 
  801d0f:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  801d16:	00 
  801d17:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  801d1e:	00 
  801d1f:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801d26:	e8 a8 00 00 00       	call   801dd3 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2e:	c1 e8 0c             	shr    $0xc,%eax
  801d31:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801d38:	a8 40                	test   $0x40,%al
  801d3a:	74 24                	je     801d60 <fs_test+0x4cb>
  801d3c:	c7 44 24 0c 15 49 80 	movl   $0x804915,0xc(%esp)
  801d43:	00 
  801d44:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  801d4b:	00 
  801d4c:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
  801d53:	00 
  801d54:	c7 04 24 f3 47 80 00 	movl   $0x8047f3,(%esp)
  801d5b:	e8 73 00 00 00       	call   801dd3 <_panic>
	cprintf("file rewrite is good\n");
  801d60:	c7 04 24 6f 49 80 00 	movl   $0x80496f,(%esp)
  801d67:	e8 60 01 00 00       	call   801ecc <cprintf>
}
  801d6c:	83 c4 24             	add    $0x24,%esp
  801d6f:	5b                   	pop    %ebx
  801d70:	5d                   	pop    %ebp
  801d71:	c3                   	ret    

00801d72 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	56                   	push   %esi
  801d76:	53                   	push   %ebx
  801d77:	83 ec 10             	sub    $0x10,%esp
  801d7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801d7d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  801d80:	e8 50 0b 00 00       	call   8028d5 <sys_getenvid>
  801d85:	25 ff 03 00 00       	and    $0x3ff,%eax
  801d8a:	c1 e0 07             	shl    $0x7,%eax
  801d8d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801d92:	a3 10 a0 80 00       	mov    %eax,0x80a010

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801d97:	85 db                	test   %ebx,%ebx
  801d99:	7e 07                	jle    801da2 <libmain+0x30>
		binaryname = argv[0];
  801d9b:	8b 06                	mov    (%esi),%eax
  801d9d:	a3 60 90 80 00       	mov    %eax,0x809060

	// call user main routine
	umain(argc, argv);
  801da2:	89 74 24 04          	mov    %esi,0x4(%esp)
  801da6:	89 1c 24             	mov    %ebx,(%esp)
  801da9:	e8 a4 fa ff ff       	call   801852 <umain>

	// exit gracefully
	exit();
  801dae:	e8 07 00 00 00       	call   801dba <exit>
}
  801db3:	83 c4 10             	add    $0x10,%esp
  801db6:	5b                   	pop    %ebx
  801db7:	5e                   	pop    %esi
  801db8:	5d                   	pop    %ebp
  801db9:	c3                   	ret    

00801dba <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	83 ec 18             	sub    $0x18,%esp
	close_all();
  801dc0:	e8 45 12 00 00       	call   80300a <close_all>
	sys_env_destroy(0);
  801dc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dcc:	e8 b2 0a 00 00       	call   802883 <sys_env_destroy>
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	56                   	push   %esi
  801dd7:	53                   	push   %ebx
  801dd8:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  801ddb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801dde:	8b 35 60 90 80 00    	mov    0x809060,%esi
  801de4:	e8 ec 0a 00 00       	call   8028d5 <sys_getenvid>
  801de9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dec:	89 54 24 10          	mov    %edx,0x10(%esp)
  801df0:	8b 55 08             	mov    0x8(%ebp),%edx
  801df3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801df7:	89 74 24 08          	mov    %esi,0x8(%esp)
  801dfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dff:	c7 04 24 20 4a 80 00 	movl   $0x804a20,(%esp)
  801e06:	e8 c1 00 00 00       	call   801ecc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  801e0b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e12:	89 04 24             	mov    %eax,(%esp)
  801e15:	e8 51 00 00 00       	call   801e6b <vcprintf>
	cprintf("\n");
  801e1a:	c7 04 24 00 46 80 00 	movl   $0x804600,(%esp)
  801e21:	e8 a6 00 00 00       	call   801ecc <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e26:	cc                   	int3   
  801e27:	eb fd                	jmp    801e26 <_panic+0x53>

00801e29 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	53                   	push   %ebx
  801e2d:	83 ec 14             	sub    $0x14,%esp
  801e30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801e33:	8b 13                	mov    (%ebx),%edx
  801e35:	8d 42 01             	lea    0x1(%edx),%eax
  801e38:	89 03                	mov    %eax,(%ebx)
  801e3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e3d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801e41:	3d ff 00 00 00       	cmp    $0xff,%eax
  801e46:	75 19                	jne    801e61 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801e48:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801e4f:	00 
  801e50:	8d 43 08             	lea    0x8(%ebx),%eax
  801e53:	89 04 24             	mov    %eax,(%esp)
  801e56:	e8 eb 09 00 00       	call   802846 <sys_cputs>
		b->idx = 0;
  801e5b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801e61:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801e65:	83 c4 14             	add    $0x14,%esp
  801e68:	5b                   	pop    %ebx
  801e69:	5d                   	pop    %ebp
  801e6a:	c3                   	ret    

00801e6b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801e74:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801e7b:	00 00 00 
	b.cnt = 0;
  801e7e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801e85:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e92:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e96:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801e9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea0:	c7 04 24 29 1e 80 00 	movl   $0x801e29,(%esp)
  801ea7:	e8 b2 01 00 00       	call   80205e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801eac:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801eb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb6:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801ebc:	89 04 24             	mov    %eax,(%esp)
  801ebf:	e8 82 09 00 00       	call   802846 <sys_cputs>

	return b.cnt;
}
  801ec4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ed2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801ed5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	89 04 24             	mov    %eax,(%esp)
  801edf:	e8 87 ff ff ff       	call   801e6b <vcprintf>
	va_end(ap);

	return cnt;
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    
  801ee6:	66 90                	xchg   %ax,%ax
  801ee8:	66 90                	xchg   %ax,%ax
  801eea:	66 90                	xchg   %ax,%ax
  801eec:	66 90                	xchg   %ax,%ax
  801eee:	66 90                	xchg   %ax,%ax

00801ef0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	57                   	push   %edi
  801ef4:	56                   	push   %esi
  801ef5:	53                   	push   %ebx
  801ef6:	83 ec 3c             	sub    $0x3c,%esp
  801ef9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801efc:	89 d7                	mov    %edx,%edi
  801efe:	8b 45 08             	mov    0x8(%ebp),%eax
  801f01:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f07:	89 c3                	mov    %eax,%ebx
  801f09:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  801f0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801f12:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f17:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f1a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801f1d:	39 d9                	cmp    %ebx,%ecx
  801f1f:	72 05                	jb     801f26 <printnum+0x36>
  801f21:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  801f24:	77 69                	ja     801f8f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801f26:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801f29:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801f2d:	83 ee 01             	sub    $0x1,%esi
  801f30:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801f34:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f38:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f3c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801f40:	89 c3                	mov    %eax,%ebx
  801f42:	89 d6                	mov    %edx,%esi
  801f44:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f47:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801f4a:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f4e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801f52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f55:	89 04 24             	mov    %eax,(%esp)
  801f58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5f:	e8 2c 22 00 00       	call   804190 <__udivdi3>
  801f64:	89 d9                	mov    %ebx,%ecx
  801f66:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f6a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801f6e:	89 04 24             	mov    %eax,(%esp)
  801f71:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f75:	89 fa                	mov    %edi,%edx
  801f77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f7a:	e8 71 ff ff ff       	call   801ef0 <printnum>
  801f7f:	eb 1b                	jmp    801f9c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801f81:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f85:	8b 45 18             	mov    0x18(%ebp),%eax
  801f88:	89 04 24             	mov    %eax,(%esp)
  801f8b:	ff d3                	call   *%ebx
  801f8d:	eb 03                	jmp    801f92 <printnum+0xa2>
  801f8f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801f92:	83 ee 01             	sub    $0x1,%esi
  801f95:	85 f6                	test   %esi,%esi
  801f97:	7f e8                	jg     801f81 <printnum+0x91>
  801f99:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801f9c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801fa0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801fa4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801fa7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801faa:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fae:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801fb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fb5:	89 04 24             	mov    %eax,(%esp)
  801fb8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbf:	e8 fc 22 00 00       	call   8042c0 <__umoddi3>
  801fc4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801fc8:	0f be 80 43 4a 80 00 	movsbl 0x804a43(%eax),%eax
  801fcf:	89 04 24             	mov    %eax,(%esp)
  801fd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fd5:	ff d0                	call   *%eax
}
  801fd7:	83 c4 3c             	add    $0x3c,%esp
  801fda:	5b                   	pop    %ebx
  801fdb:	5e                   	pop    %esi
  801fdc:	5f                   	pop    %edi
  801fdd:	5d                   	pop    %ebp
  801fde:	c3                   	ret    

00801fdf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801fe2:	83 fa 01             	cmp    $0x1,%edx
  801fe5:	7e 0e                	jle    801ff5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801fe7:	8b 10                	mov    (%eax),%edx
  801fe9:	8d 4a 08             	lea    0x8(%edx),%ecx
  801fec:	89 08                	mov    %ecx,(%eax)
  801fee:	8b 02                	mov    (%edx),%eax
  801ff0:	8b 52 04             	mov    0x4(%edx),%edx
  801ff3:	eb 22                	jmp    802017 <getuint+0x38>
	else if (lflag)
  801ff5:	85 d2                	test   %edx,%edx
  801ff7:	74 10                	je     802009 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801ff9:	8b 10                	mov    (%eax),%edx
  801ffb:	8d 4a 04             	lea    0x4(%edx),%ecx
  801ffe:	89 08                	mov    %ecx,(%eax)
  802000:	8b 02                	mov    (%edx),%eax
  802002:	ba 00 00 00 00       	mov    $0x0,%edx
  802007:	eb 0e                	jmp    802017 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  802009:	8b 10                	mov    (%eax),%edx
  80200b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80200e:	89 08                	mov    %ecx,(%eax)
  802010:	8b 02                	mov    (%edx),%eax
  802012:	ba 00 00 00 00       	mov    $0x0,%edx
}
  802017:	5d                   	pop    %ebp
  802018:	c3                   	ret    

00802019 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80201f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  802023:	8b 10                	mov    (%eax),%edx
  802025:	3b 50 04             	cmp    0x4(%eax),%edx
  802028:	73 0a                	jae    802034 <sprintputch+0x1b>
		*b->buf++ = ch;
  80202a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80202d:	89 08                	mov    %ecx,(%eax)
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	88 02                	mov    %al,(%edx)
}
  802034:	5d                   	pop    %ebp
  802035:	c3                   	ret    

00802036 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
  802039:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80203c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80203f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802043:	8b 45 10             	mov    0x10(%ebp),%eax
  802046:	89 44 24 08          	mov    %eax,0x8(%esp)
  80204a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	89 04 24             	mov    %eax,(%esp)
  802057:	e8 02 00 00 00       	call   80205e <vprintfmt>
	va_end(ap);
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	57                   	push   %edi
  802062:	56                   	push   %esi
  802063:	53                   	push   %ebx
  802064:	83 ec 3c             	sub    $0x3c,%esp
  802067:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80206a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80206d:	eb 14                	jmp    802083 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80206f:	85 c0                	test   %eax,%eax
  802071:	0f 84 b3 03 00 00    	je     80242a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  802077:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80207b:	89 04 24             	mov    %eax,(%esp)
  80207e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802081:	89 f3                	mov    %esi,%ebx
  802083:	8d 73 01             	lea    0x1(%ebx),%esi
  802086:	0f b6 03             	movzbl (%ebx),%eax
  802089:	83 f8 25             	cmp    $0x25,%eax
  80208c:	75 e1                	jne    80206f <vprintfmt+0x11>
  80208e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  802092:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  802099:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8020a0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8020a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ac:	eb 1d                	jmp    8020cb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8020ae:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8020b0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8020b4:	eb 15                	jmp    8020cb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8020b6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8020b8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8020bc:	eb 0d                	jmp    8020cb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8020be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8020c4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8020cb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8020ce:	0f b6 0e             	movzbl (%esi),%ecx
  8020d1:	0f b6 c1             	movzbl %cl,%eax
  8020d4:	83 e9 23             	sub    $0x23,%ecx
  8020d7:	80 f9 55             	cmp    $0x55,%cl
  8020da:	0f 87 2a 03 00 00    	ja     80240a <vprintfmt+0x3ac>
  8020e0:	0f b6 c9             	movzbl %cl,%ecx
  8020e3:	ff 24 8d 80 4b 80 00 	jmp    *0x804b80(,%ecx,4)
  8020ea:	89 de                	mov    %ebx,%esi
  8020ec:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8020f1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8020f4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8020f8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8020fb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8020fe:	83 fb 09             	cmp    $0x9,%ebx
  802101:	77 36                	ja     802139 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  802103:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  802106:	eb e9                	jmp    8020f1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  802108:	8b 45 14             	mov    0x14(%ebp),%eax
  80210b:	8d 48 04             	lea    0x4(%eax),%ecx
  80210e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  802111:	8b 00                	mov    (%eax),%eax
  802113:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  802116:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  802118:	eb 22                	jmp    80213c <vprintfmt+0xde>
  80211a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80211d:	85 c9                	test   %ecx,%ecx
  80211f:	b8 00 00 00 00       	mov    $0x0,%eax
  802124:	0f 49 c1             	cmovns %ecx,%eax
  802127:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80212a:	89 de                	mov    %ebx,%esi
  80212c:	eb 9d                	jmp    8020cb <vprintfmt+0x6d>
  80212e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  802130:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  802137:	eb 92                	jmp    8020cb <vprintfmt+0x6d>
  802139:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80213c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802140:	79 89                	jns    8020cb <vprintfmt+0x6d>
  802142:	e9 77 ff ff ff       	jmp    8020be <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  802147:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80214a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80214c:	e9 7a ff ff ff       	jmp    8020cb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  802151:	8b 45 14             	mov    0x14(%ebp),%eax
  802154:	8d 50 04             	lea    0x4(%eax),%edx
  802157:	89 55 14             	mov    %edx,0x14(%ebp)
  80215a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80215e:	8b 00                	mov    (%eax),%eax
  802160:	89 04 24             	mov    %eax,(%esp)
  802163:	ff 55 08             	call   *0x8(%ebp)
			break;
  802166:	e9 18 ff ff ff       	jmp    802083 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80216b:	8b 45 14             	mov    0x14(%ebp),%eax
  80216e:	8d 50 04             	lea    0x4(%eax),%edx
  802171:	89 55 14             	mov    %edx,0x14(%ebp)
  802174:	8b 00                	mov    (%eax),%eax
  802176:	99                   	cltd   
  802177:	31 d0                	xor    %edx,%eax
  802179:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80217b:	83 f8 11             	cmp    $0x11,%eax
  80217e:	7f 0b                	jg     80218b <vprintfmt+0x12d>
  802180:	8b 14 85 e0 4c 80 00 	mov    0x804ce0(,%eax,4),%edx
  802187:	85 d2                	test   %edx,%edx
  802189:	75 20                	jne    8021ab <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80218b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80218f:	c7 44 24 08 5b 4a 80 	movl   $0x804a5b,0x8(%esp)
  802196:	00 
  802197:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	89 04 24             	mov    %eax,(%esp)
  8021a1:	e8 90 fe ff ff       	call   802036 <printfmt>
  8021a6:	e9 d8 fe ff ff       	jmp    802083 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8021ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8021af:	c7 44 24 08 6f 44 80 	movl   $0x80446f,0x8(%esp)
  8021b6:	00 
  8021b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	89 04 24             	mov    %eax,(%esp)
  8021c1:	e8 70 fe ff ff       	call   802036 <printfmt>
  8021c6:	e9 b8 fe ff ff       	jmp    802083 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8021cb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8021ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8021d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8021d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d7:	8d 50 04             	lea    0x4(%eax),%edx
  8021da:	89 55 14             	mov    %edx,0x14(%ebp)
  8021dd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8021df:	85 f6                	test   %esi,%esi
  8021e1:	b8 54 4a 80 00       	mov    $0x804a54,%eax
  8021e6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8021e9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8021ed:	0f 84 97 00 00 00    	je     80228a <vprintfmt+0x22c>
  8021f3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8021f7:	0f 8e 9b 00 00 00    	jle    802298 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8021fd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802201:	89 34 24             	mov    %esi,(%esp)
  802204:	e8 cf 02 00 00       	call   8024d8 <strnlen>
  802209:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80220c:	29 c2                	sub    %eax,%edx
  80220e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  802211:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  802215:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802218:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80221b:	8b 75 08             	mov    0x8(%ebp),%esi
  80221e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802221:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802223:	eb 0f                	jmp    802234 <vprintfmt+0x1d6>
					putch(padc, putdat);
  802225:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802229:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80222c:	89 04 24             	mov    %eax,(%esp)
  80222f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802231:	83 eb 01             	sub    $0x1,%ebx
  802234:	85 db                	test   %ebx,%ebx
  802236:	7f ed                	jg     802225 <vprintfmt+0x1c7>
  802238:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80223b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80223e:	85 d2                	test   %edx,%edx
  802240:	b8 00 00 00 00       	mov    $0x0,%eax
  802245:	0f 49 c2             	cmovns %edx,%eax
  802248:	29 c2                	sub    %eax,%edx
  80224a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80224d:	89 d7                	mov    %edx,%edi
  80224f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802252:	eb 50                	jmp    8022a4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802254:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802258:	74 1e                	je     802278 <vprintfmt+0x21a>
  80225a:	0f be d2             	movsbl %dl,%edx
  80225d:	83 ea 20             	sub    $0x20,%edx
  802260:	83 fa 5e             	cmp    $0x5e,%edx
  802263:	76 13                	jbe    802278 <vprintfmt+0x21a>
					putch('?', putdat);
  802265:	8b 45 0c             	mov    0xc(%ebp),%eax
  802268:	89 44 24 04          	mov    %eax,0x4(%esp)
  80226c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  802273:	ff 55 08             	call   *0x8(%ebp)
  802276:	eb 0d                	jmp    802285 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  802278:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80227f:	89 04 24             	mov    %eax,(%esp)
  802282:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802285:	83 ef 01             	sub    $0x1,%edi
  802288:	eb 1a                	jmp    8022a4 <vprintfmt+0x246>
  80228a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80228d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  802290:	89 5d 10             	mov    %ebx,0x10(%ebp)
  802293:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802296:	eb 0c                	jmp    8022a4 <vprintfmt+0x246>
  802298:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80229b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80229e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8022a1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8022a4:	83 c6 01             	add    $0x1,%esi
  8022a7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8022ab:	0f be c2             	movsbl %dl,%eax
  8022ae:	85 c0                	test   %eax,%eax
  8022b0:	74 27                	je     8022d9 <vprintfmt+0x27b>
  8022b2:	85 db                	test   %ebx,%ebx
  8022b4:	78 9e                	js     802254 <vprintfmt+0x1f6>
  8022b6:	83 eb 01             	sub    $0x1,%ebx
  8022b9:	79 99                	jns    802254 <vprintfmt+0x1f6>
  8022bb:	89 f8                	mov    %edi,%eax
  8022bd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8022c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8022c3:	89 c3                	mov    %eax,%ebx
  8022c5:	eb 1a                	jmp    8022e1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8022c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8022cb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8022d2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8022d4:	83 eb 01             	sub    $0x1,%ebx
  8022d7:	eb 08                	jmp    8022e1 <vprintfmt+0x283>
  8022d9:	89 fb                	mov    %edi,%ebx
  8022db:	8b 75 08             	mov    0x8(%ebp),%esi
  8022de:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8022e1:	85 db                	test   %ebx,%ebx
  8022e3:	7f e2                	jg     8022c7 <vprintfmt+0x269>
  8022e5:	89 75 08             	mov    %esi,0x8(%ebp)
  8022e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022eb:	e9 93 fd ff ff       	jmp    802083 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8022f0:	83 fa 01             	cmp    $0x1,%edx
  8022f3:	7e 16                	jle    80230b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8022f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8022f8:	8d 50 08             	lea    0x8(%eax),%edx
  8022fb:	89 55 14             	mov    %edx,0x14(%ebp)
  8022fe:	8b 50 04             	mov    0x4(%eax),%edx
  802301:	8b 00                	mov    (%eax),%eax
  802303:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802306:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802309:	eb 32                	jmp    80233d <vprintfmt+0x2df>
	else if (lflag)
  80230b:	85 d2                	test   %edx,%edx
  80230d:	74 18                	je     802327 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80230f:	8b 45 14             	mov    0x14(%ebp),%eax
  802312:	8d 50 04             	lea    0x4(%eax),%edx
  802315:	89 55 14             	mov    %edx,0x14(%ebp)
  802318:	8b 30                	mov    (%eax),%esi
  80231a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80231d:	89 f0                	mov    %esi,%eax
  80231f:	c1 f8 1f             	sar    $0x1f,%eax
  802322:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802325:	eb 16                	jmp    80233d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  802327:	8b 45 14             	mov    0x14(%ebp),%eax
  80232a:	8d 50 04             	lea    0x4(%eax),%edx
  80232d:	89 55 14             	mov    %edx,0x14(%ebp)
  802330:	8b 30                	mov    (%eax),%esi
  802332:	89 75 e0             	mov    %esi,-0x20(%ebp)
  802335:	89 f0                	mov    %esi,%eax
  802337:	c1 f8 1f             	sar    $0x1f,%eax
  80233a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80233d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802340:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  802343:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  802348:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80234c:	0f 89 80 00 00 00    	jns    8023d2 <vprintfmt+0x374>
				putch('-', putdat);
  802352:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802356:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80235d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  802360:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802363:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802366:	f7 d8                	neg    %eax
  802368:	83 d2 00             	adc    $0x0,%edx
  80236b:	f7 da                	neg    %edx
			}
			base = 10;
  80236d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802372:	eb 5e                	jmp    8023d2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802374:	8d 45 14             	lea    0x14(%ebp),%eax
  802377:	e8 63 fc ff ff       	call   801fdf <getuint>
			base = 10;
  80237c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  802381:	eb 4f                	jmp    8023d2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  802383:	8d 45 14             	lea    0x14(%ebp),%eax
  802386:	e8 54 fc ff ff       	call   801fdf <getuint>
			base = 8;
  80238b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  802390:	eb 40                	jmp    8023d2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  802392:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802396:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80239d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8023a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8023a4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8023ab:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8023ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8023b1:	8d 50 04             	lea    0x4(%eax),%edx
  8023b4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8023b7:	8b 00                	mov    (%eax),%eax
  8023b9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8023be:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8023c3:	eb 0d                	jmp    8023d2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8023c5:	8d 45 14             	lea    0x14(%ebp),%eax
  8023c8:	e8 12 fc ff ff       	call   801fdf <getuint>
			base = 16;
  8023cd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8023d2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8023d6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8023da:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8023dd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8023e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023e5:	89 04 24             	mov    %eax,(%esp)
  8023e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023ec:	89 fa                	mov    %edi,%edx
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	e8 fa fa ff ff       	call   801ef0 <printnum>
			break;
  8023f6:	e9 88 fc ff ff       	jmp    802083 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8023fb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8023ff:	89 04 24             	mov    %eax,(%esp)
  802402:	ff 55 08             	call   *0x8(%ebp)
			break;
  802405:	e9 79 fc ff ff       	jmp    802083 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80240a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80240e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  802415:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  802418:	89 f3                	mov    %esi,%ebx
  80241a:	eb 03                	jmp    80241f <vprintfmt+0x3c1>
  80241c:	83 eb 01             	sub    $0x1,%ebx
  80241f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  802423:	75 f7                	jne    80241c <vprintfmt+0x3be>
  802425:	e9 59 fc ff ff       	jmp    802083 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80242a:	83 c4 3c             	add    $0x3c,%esp
  80242d:	5b                   	pop    %ebx
  80242e:	5e                   	pop    %esi
  80242f:	5f                   	pop    %edi
  802430:	5d                   	pop    %ebp
  802431:	c3                   	ret    

00802432 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
  802435:	83 ec 28             	sub    $0x28,%esp
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80243e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802441:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  802445:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802448:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80244f:	85 c0                	test   %eax,%eax
  802451:	74 30                	je     802483 <vsnprintf+0x51>
  802453:	85 d2                	test   %edx,%edx
  802455:	7e 2c                	jle    802483 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802457:	8b 45 14             	mov    0x14(%ebp),%eax
  80245a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80245e:	8b 45 10             	mov    0x10(%ebp),%eax
  802461:	89 44 24 08          	mov    %eax,0x8(%esp)
  802465:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802468:	89 44 24 04          	mov    %eax,0x4(%esp)
  80246c:	c7 04 24 19 20 80 00 	movl   $0x802019,(%esp)
  802473:	e8 e6 fb ff ff       	call   80205e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  802478:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	eb 05                	jmp    802488 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  802483:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  802488:	c9                   	leave  
  802489:	c3                   	ret    

0080248a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80248a:	55                   	push   %ebp
  80248b:	89 e5                	mov    %esp,%ebp
  80248d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802490:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  802493:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802497:	8b 45 10             	mov    0x10(%ebp),%eax
  80249a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80249e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	89 04 24             	mov    %eax,(%esp)
  8024ab:	e8 82 ff ff ff       	call   802432 <vsnprintf>
	va_end(ap);

	return rc;
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    
  8024b2:	66 90                	xchg   %ax,%ax
  8024b4:	66 90                	xchg   %ax,%ax
  8024b6:	66 90                	xchg   %ax,%ax
  8024b8:	66 90                	xchg   %ax,%ax
  8024ba:	66 90                	xchg   %ax,%ax
  8024bc:	66 90                	xchg   %ax,%ax
  8024be:	66 90                	xchg   %ax,%ax

008024c0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
  8024c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8024c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024cb:	eb 03                	jmp    8024d0 <strlen+0x10>
		n++;
  8024cd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8024d0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8024d4:	75 f7                	jne    8024cd <strlen+0xd>
		n++;
	return n;
}
  8024d6:	5d                   	pop    %ebp
  8024d7:	c3                   	ret    

008024d8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
  8024db:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024de:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e6:	eb 03                	jmp    8024eb <strnlen+0x13>
		n++;
  8024e8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8024eb:	39 d0                	cmp    %edx,%eax
  8024ed:	74 06                	je     8024f5 <strnlen+0x1d>
  8024ef:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8024f3:	75 f3                	jne    8024e8 <strnlen+0x10>
		n++;
	return n;
}
  8024f5:	5d                   	pop    %ebp
  8024f6:	c3                   	ret    

008024f7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8024f7:	55                   	push   %ebp
  8024f8:	89 e5                	mov    %esp,%ebp
  8024fa:	53                   	push   %ebx
  8024fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  802501:	89 c2                	mov    %eax,%edx
  802503:	83 c2 01             	add    $0x1,%edx
  802506:	83 c1 01             	add    $0x1,%ecx
  802509:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80250d:	88 5a ff             	mov    %bl,-0x1(%edx)
  802510:	84 db                	test   %bl,%bl
  802512:	75 ef                	jne    802503 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  802514:	5b                   	pop    %ebx
  802515:	5d                   	pop    %ebp
  802516:	c3                   	ret    

00802517 <strcat>:

char *
strcat(char *dst, const char *src)
{
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
  80251a:	53                   	push   %ebx
  80251b:	83 ec 08             	sub    $0x8,%esp
  80251e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  802521:	89 1c 24             	mov    %ebx,(%esp)
  802524:	e8 97 ff ff ff       	call   8024c0 <strlen>
	strcpy(dst + len, src);
  802529:	8b 55 0c             	mov    0xc(%ebp),%edx
  80252c:	89 54 24 04          	mov    %edx,0x4(%esp)
  802530:	01 d8                	add    %ebx,%eax
  802532:	89 04 24             	mov    %eax,(%esp)
  802535:	e8 bd ff ff ff       	call   8024f7 <strcpy>
	return dst;
}
  80253a:	89 d8                	mov    %ebx,%eax
  80253c:	83 c4 08             	add    $0x8,%esp
  80253f:	5b                   	pop    %ebx
  802540:	5d                   	pop    %ebp
  802541:	c3                   	ret    

00802542 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
  802545:	56                   	push   %esi
  802546:	53                   	push   %ebx
  802547:	8b 75 08             	mov    0x8(%ebp),%esi
  80254a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80254d:	89 f3                	mov    %esi,%ebx
  80254f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802552:	89 f2                	mov    %esi,%edx
  802554:	eb 0f                	jmp    802565 <strncpy+0x23>
		*dst++ = *src;
  802556:	83 c2 01             	add    $0x1,%edx
  802559:	0f b6 01             	movzbl (%ecx),%eax
  80255c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80255f:	80 39 01             	cmpb   $0x1,(%ecx)
  802562:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802565:	39 da                	cmp    %ebx,%edx
  802567:	75 ed                	jne    802556 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  802569:	89 f0                	mov    %esi,%eax
  80256b:	5b                   	pop    %ebx
  80256c:	5e                   	pop    %esi
  80256d:	5d                   	pop    %ebp
  80256e:	c3                   	ret    

0080256f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80256f:	55                   	push   %ebp
  802570:	89 e5                	mov    %esp,%ebp
  802572:	56                   	push   %esi
  802573:	53                   	push   %ebx
  802574:	8b 75 08             	mov    0x8(%ebp),%esi
  802577:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80257d:	89 f0                	mov    %esi,%eax
  80257f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802583:	85 c9                	test   %ecx,%ecx
  802585:	75 0b                	jne    802592 <strlcpy+0x23>
  802587:	eb 1d                	jmp    8025a6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  802589:	83 c0 01             	add    $0x1,%eax
  80258c:	83 c2 01             	add    $0x1,%edx
  80258f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802592:	39 d8                	cmp    %ebx,%eax
  802594:	74 0b                	je     8025a1 <strlcpy+0x32>
  802596:	0f b6 0a             	movzbl (%edx),%ecx
  802599:	84 c9                	test   %cl,%cl
  80259b:	75 ec                	jne    802589 <strlcpy+0x1a>
  80259d:	89 c2                	mov    %eax,%edx
  80259f:	eb 02                	jmp    8025a3 <strlcpy+0x34>
  8025a1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8025a3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8025a6:	29 f0                	sub    %esi,%eax
}
  8025a8:	5b                   	pop    %ebx
  8025a9:	5e                   	pop    %esi
  8025aa:	5d                   	pop    %ebp
  8025ab:	c3                   	ret    

008025ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8025ac:	55                   	push   %ebp
  8025ad:	89 e5                	mov    %esp,%ebp
  8025af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025b2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8025b5:	eb 06                	jmp    8025bd <strcmp+0x11>
		p++, q++;
  8025b7:	83 c1 01             	add    $0x1,%ecx
  8025ba:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8025bd:	0f b6 01             	movzbl (%ecx),%eax
  8025c0:	84 c0                	test   %al,%al
  8025c2:	74 04                	je     8025c8 <strcmp+0x1c>
  8025c4:	3a 02                	cmp    (%edx),%al
  8025c6:	74 ef                	je     8025b7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8025c8:	0f b6 c0             	movzbl %al,%eax
  8025cb:	0f b6 12             	movzbl (%edx),%edx
  8025ce:	29 d0                	sub    %edx,%eax
}
  8025d0:	5d                   	pop    %ebp
  8025d1:	c3                   	ret    

008025d2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
  8025d5:	53                   	push   %ebx
  8025d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025dc:	89 c3                	mov    %eax,%ebx
  8025de:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8025e1:	eb 06                	jmp    8025e9 <strncmp+0x17>
		n--, p++, q++;
  8025e3:	83 c0 01             	add    $0x1,%eax
  8025e6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8025e9:	39 d8                	cmp    %ebx,%eax
  8025eb:	74 15                	je     802602 <strncmp+0x30>
  8025ed:	0f b6 08             	movzbl (%eax),%ecx
  8025f0:	84 c9                	test   %cl,%cl
  8025f2:	74 04                	je     8025f8 <strncmp+0x26>
  8025f4:	3a 0a                	cmp    (%edx),%cl
  8025f6:	74 eb                	je     8025e3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8025f8:	0f b6 00             	movzbl (%eax),%eax
  8025fb:	0f b6 12             	movzbl (%edx),%edx
  8025fe:	29 d0                	sub    %edx,%eax
  802600:	eb 05                	jmp    802607 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  802602:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802607:	5b                   	pop    %ebx
  802608:	5d                   	pop    %ebp
  802609:	c3                   	ret    

0080260a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	8b 45 08             	mov    0x8(%ebp),%eax
  802610:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802614:	eb 07                	jmp    80261d <strchr+0x13>
		if (*s == c)
  802616:	38 ca                	cmp    %cl,%dl
  802618:	74 0f                	je     802629 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80261a:	83 c0 01             	add    $0x1,%eax
  80261d:	0f b6 10             	movzbl (%eax),%edx
  802620:	84 d2                	test   %dl,%dl
  802622:	75 f2                	jne    802616 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  802624:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802629:	5d                   	pop    %ebp
  80262a:	c3                   	ret    

0080262b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80262b:	55                   	push   %ebp
  80262c:	89 e5                	mov    %esp,%ebp
  80262e:	8b 45 08             	mov    0x8(%ebp),%eax
  802631:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802635:	eb 07                	jmp    80263e <strfind+0x13>
		if (*s == c)
  802637:	38 ca                	cmp    %cl,%dl
  802639:	74 0a                	je     802645 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80263b:	83 c0 01             	add    $0x1,%eax
  80263e:	0f b6 10             	movzbl (%eax),%edx
  802641:	84 d2                	test   %dl,%dl
  802643:	75 f2                	jne    802637 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  802645:	5d                   	pop    %ebp
  802646:	c3                   	ret    

00802647 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802647:	55                   	push   %ebp
  802648:	89 e5                	mov    %esp,%ebp
  80264a:	57                   	push   %edi
  80264b:	56                   	push   %esi
  80264c:	53                   	push   %ebx
  80264d:	8b 7d 08             	mov    0x8(%ebp),%edi
  802650:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802653:	85 c9                	test   %ecx,%ecx
  802655:	74 36                	je     80268d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802657:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80265d:	75 28                	jne    802687 <memset+0x40>
  80265f:	f6 c1 03             	test   $0x3,%cl
  802662:	75 23                	jne    802687 <memset+0x40>
		c &= 0xFF;
  802664:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802668:	89 d3                	mov    %edx,%ebx
  80266a:	c1 e3 08             	shl    $0x8,%ebx
  80266d:	89 d6                	mov    %edx,%esi
  80266f:	c1 e6 18             	shl    $0x18,%esi
  802672:	89 d0                	mov    %edx,%eax
  802674:	c1 e0 10             	shl    $0x10,%eax
  802677:	09 f0                	or     %esi,%eax
  802679:	09 c2                	or     %eax,%edx
  80267b:	89 d0                	mov    %edx,%eax
  80267d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80267f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  802682:	fc                   	cld    
  802683:	f3 ab                	rep stos %eax,%es:(%edi)
  802685:	eb 06                	jmp    80268d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802687:	8b 45 0c             	mov    0xc(%ebp),%eax
  80268a:	fc                   	cld    
  80268b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80268d:	89 f8                	mov    %edi,%eax
  80268f:	5b                   	pop    %ebx
  802690:	5e                   	pop    %esi
  802691:	5f                   	pop    %edi
  802692:	5d                   	pop    %ebp
  802693:	c3                   	ret    

00802694 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802694:	55                   	push   %ebp
  802695:	89 e5                	mov    %esp,%ebp
  802697:	57                   	push   %edi
  802698:	56                   	push   %esi
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80269f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8026a2:	39 c6                	cmp    %eax,%esi
  8026a4:	73 35                	jae    8026db <memmove+0x47>
  8026a6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8026a9:	39 d0                	cmp    %edx,%eax
  8026ab:	73 2e                	jae    8026db <memmove+0x47>
		s += n;
		d += n;
  8026ad:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8026b0:	89 d6                	mov    %edx,%esi
  8026b2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8026b4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8026ba:	75 13                	jne    8026cf <memmove+0x3b>
  8026bc:	f6 c1 03             	test   $0x3,%cl
  8026bf:	75 0e                	jne    8026cf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8026c1:	83 ef 04             	sub    $0x4,%edi
  8026c4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8026c7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8026ca:	fd                   	std    
  8026cb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8026cd:	eb 09                	jmp    8026d8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8026cf:	83 ef 01             	sub    $0x1,%edi
  8026d2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8026d5:	fd                   	std    
  8026d6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8026d8:	fc                   	cld    
  8026d9:	eb 1d                	jmp    8026f8 <memmove+0x64>
  8026db:	89 f2                	mov    %esi,%edx
  8026dd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8026df:	f6 c2 03             	test   $0x3,%dl
  8026e2:	75 0f                	jne    8026f3 <memmove+0x5f>
  8026e4:	f6 c1 03             	test   $0x3,%cl
  8026e7:	75 0a                	jne    8026f3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8026e9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8026ec:	89 c7                	mov    %eax,%edi
  8026ee:	fc                   	cld    
  8026ef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8026f1:	eb 05                	jmp    8026f8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8026f3:	89 c7                	mov    %eax,%edi
  8026f5:	fc                   	cld    
  8026f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8026f8:	5e                   	pop    %esi
  8026f9:	5f                   	pop    %edi
  8026fa:	5d                   	pop    %ebp
  8026fb:	c3                   	ret    

008026fc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8026fc:	55                   	push   %ebp
  8026fd:	89 e5                	mov    %esp,%ebp
  8026ff:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802702:	8b 45 10             	mov    0x10(%ebp),%eax
  802705:	89 44 24 08          	mov    %eax,0x8(%esp)
  802709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80270c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802710:	8b 45 08             	mov    0x8(%ebp),%eax
  802713:	89 04 24             	mov    %eax,(%esp)
  802716:	e8 79 ff ff ff       	call   802694 <memmove>
}
  80271b:	c9                   	leave  
  80271c:	c3                   	ret    

0080271d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80271d:	55                   	push   %ebp
  80271e:	89 e5                	mov    %esp,%ebp
  802720:	56                   	push   %esi
  802721:	53                   	push   %ebx
  802722:	8b 55 08             	mov    0x8(%ebp),%edx
  802725:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802728:	89 d6                	mov    %edx,%esi
  80272a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80272d:	eb 1a                	jmp    802749 <memcmp+0x2c>
		if (*s1 != *s2)
  80272f:	0f b6 02             	movzbl (%edx),%eax
  802732:	0f b6 19             	movzbl (%ecx),%ebx
  802735:	38 d8                	cmp    %bl,%al
  802737:	74 0a                	je     802743 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  802739:	0f b6 c0             	movzbl %al,%eax
  80273c:	0f b6 db             	movzbl %bl,%ebx
  80273f:	29 d8                	sub    %ebx,%eax
  802741:	eb 0f                	jmp    802752 <memcmp+0x35>
		s1++, s2++;
  802743:	83 c2 01             	add    $0x1,%edx
  802746:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802749:	39 f2                	cmp    %esi,%edx
  80274b:	75 e2                	jne    80272f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80274d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802752:	5b                   	pop    %ebx
  802753:	5e                   	pop    %esi
  802754:	5d                   	pop    %ebp
  802755:	c3                   	ret    

00802756 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	8b 45 08             	mov    0x8(%ebp),%eax
  80275c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80275f:	89 c2                	mov    %eax,%edx
  802761:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802764:	eb 07                	jmp    80276d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  802766:	38 08                	cmp    %cl,(%eax)
  802768:	74 07                	je     802771 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80276a:	83 c0 01             	add    $0x1,%eax
  80276d:	39 d0                	cmp    %edx,%eax
  80276f:	72 f5                	jb     802766 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802771:	5d                   	pop    %ebp
  802772:	c3                   	ret    

00802773 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802773:	55                   	push   %ebp
  802774:	89 e5                	mov    %esp,%ebp
  802776:	57                   	push   %edi
  802777:	56                   	push   %esi
  802778:	53                   	push   %ebx
  802779:	8b 55 08             	mov    0x8(%ebp),%edx
  80277c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80277f:	eb 03                	jmp    802784 <strtol+0x11>
		s++;
  802781:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802784:	0f b6 0a             	movzbl (%edx),%ecx
  802787:	80 f9 09             	cmp    $0x9,%cl
  80278a:	74 f5                	je     802781 <strtol+0xe>
  80278c:	80 f9 20             	cmp    $0x20,%cl
  80278f:	74 f0                	je     802781 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  802791:	80 f9 2b             	cmp    $0x2b,%cl
  802794:	75 0a                	jne    8027a0 <strtol+0x2d>
		s++;
  802796:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  802799:	bf 00 00 00 00       	mov    $0x0,%edi
  80279e:	eb 11                	jmp    8027b1 <strtol+0x3e>
  8027a0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8027a5:	80 f9 2d             	cmp    $0x2d,%cl
  8027a8:	75 07                	jne    8027b1 <strtol+0x3e>
		s++, neg = 1;
  8027aa:	8d 52 01             	lea    0x1(%edx),%edx
  8027ad:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8027b1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8027b6:	75 15                	jne    8027cd <strtol+0x5a>
  8027b8:	80 3a 30             	cmpb   $0x30,(%edx)
  8027bb:	75 10                	jne    8027cd <strtol+0x5a>
  8027bd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8027c1:	75 0a                	jne    8027cd <strtol+0x5a>
		s += 2, base = 16;
  8027c3:	83 c2 02             	add    $0x2,%edx
  8027c6:	b8 10 00 00 00       	mov    $0x10,%eax
  8027cb:	eb 10                	jmp    8027dd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  8027cd:	85 c0                	test   %eax,%eax
  8027cf:	75 0c                	jne    8027dd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8027d1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8027d3:	80 3a 30             	cmpb   $0x30,(%edx)
  8027d6:	75 05                	jne    8027dd <strtol+0x6a>
		s++, base = 8;
  8027d8:	83 c2 01             	add    $0x1,%edx
  8027db:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8027dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8027e2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8027e5:	0f b6 0a             	movzbl (%edx),%ecx
  8027e8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8027eb:	89 f0                	mov    %esi,%eax
  8027ed:	3c 09                	cmp    $0x9,%al
  8027ef:	77 08                	ja     8027f9 <strtol+0x86>
			dig = *s - '0';
  8027f1:	0f be c9             	movsbl %cl,%ecx
  8027f4:	83 e9 30             	sub    $0x30,%ecx
  8027f7:	eb 20                	jmp    802819 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  8027f9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8027fc:	89 f0                	mov    %esi,%eax
  8027fe:	3c 19                	cmp    $0x19,%al
  802800:	77 08                	ja     80280a <strtol+0x97>
			dig = *s - 'a' + 10;
  802802:	0f be c9             	movsbl %cl,%ecx
  802805:	83 e9 57             	sub    $0x57,%ecx
  802808:	eb 0f                	jmp    802819 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  80280a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  80280d:	89 f0                	mov    %esi,%eax
  80280f:	3c 19                	cmp    $0x19,%al
  802811:	77 16                	ja     802829 <strtol+0xb6>
			dig = *s - 'A' + 10;
  802813:	0f be c9             	movsbl %cl,%ecx
  802816:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  802819:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  80281c:	7d 0f                	jge    80282d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  80281e:	83 c2 01             	add    $0x1,%edx
  802821:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  802825:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  802827:	eb bc                	jmp    8027e5 <strtol+0x72>
  802829:	89 d8                	mov    %ebx,%eax
  80282b:	eb 02                	jmp    80282f <strtol+0xbc>
  80282d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  80282f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802833:	74 05                	je     80283a <strtol+0xc7>
		*endptr = (char *) s;
  802835:	8b 75 0c             	mov    0xc(%ebp),%esi
  802838:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80283a:	f7 d8                	neg    %eax
  80283c:	85 ff                	test   %edi,%edi
  80283e:	0f 44 c3             	cmove  %ebx,%eax
}
  802841:	5b                   	pop    %ebx
  802842:	5e                   	pop    %esi
  802843:	5f                   	pop    %edi
  802844:	5d                   	pop    %ebp
  802845:	c3                   	ret    

00802846 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	57                   	push   %edi
  80284a:	56                   	push   %esi
  80284b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80284c:	b8 00 00 00 00       	mov    $0x0,%eax
  802851:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802854:	8b 55 08             	mov    0x8(%ebp),%edx
  802857:	89 c3                	mov    %eax,%ebx
  802859:	89 c7                	mov    %eax,%edi
  80285b:	89 c6                	mov    %eax,%esi
  80285d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80285f:	5b                   	pop    %ebx
  802860:	5e                   	pop    %esi
  802861:	5f                   	pop    %edi
  802862:	5d                   	pop    %ebp
  802863:	c3                   	ret    

00802864 <sys_cgetc>:

int
sys_cgetc(void)
{
  802864:	55                   	push   %ebp
  802865:	89 e5                	mov    %esp,%ebp
  802867:	57                   	push   %edi
  802868:	56                   	push   %esi
  802869:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80286a:	ba 00 00 00 00       	mov    $0x0,%edx
  80286f:	b8 01 00 00 00       	mov    $0x1,%eax
  802874:	89 d1                	mov    %edx,%ecx
  802876:	89 d3                	mov    %edx,%ebx
  802878:	89 d7                	mov    %edx,%edi
  80287a:	89 d6                	mov    %edx,%esi
  80287c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80287e:	5b                   	pop    %ebx
  80287f:	5e                   	pop    %esi
  802880:	5f                   	pop    %edi
  802881:	5d                   	pop    %ebp
  802882:	c3                   	ret    

00802883 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  802883:	55                   	push   %ebp
  802884:	89 e5                	mov    %esp,%ebp
  802886:	57                   	push   %edi
  802887:	56                   	push   %esi
  802888:	53                   	push   %ebx
  802889:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80288c:	b9 00 00 00 00       	mov    $0x0,%ecx
  802891:	b8 03 00 00 00       	mov    $0x3,%eax
  802896:	8b 55 08             	mov    0x8(%ebp),%edx
  802899:	89 cb                	mov    %ecx,%ebx
  80289b:	89 cf                	mov    %ecx,%edi
  80289d:	89 ce                	mov    %ecx,%esi
  80289f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8028a1:	85 c0                	test   %eax,%eax
  8028a3:	7e 28                	jle    8028cd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8028a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8028a9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8028b0:	00 
  8028b1:	c7 44 24 08 47 4d 80 	movl   $0x804d47,0x8(%esp)
  8028b8:	00 
  8028b9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8028c0:	00 
  8028c1:	c7 04 24 64 4d 80 00 	movl   $0x804d64,(%esp)
  8028c8:	e8 06 f5 ff ff       	call   801dd3 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8028cd:	83 c4 2c             	add    $0x2c,%esp
  8028d0:	5b                   	pop    %ebx
  8028d1:	5e                   	pop    %esi
  8028d2:	5f                   	pop    %edi
  8028d3:	5d                   	pop    %ebp
  8028d4:	c3                   	ret    

008028d5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8028d5:	55                   	push   %ebp
  8028d6:	89 e5                	mov    %esp,%ebp
  8028d8:	57                   	push   %edi
  8028d9:	56                   	push   %esi
  8028da:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028db:	ba 00 00 00 00       	mov    $0x0,%edx
  8028e0:	b8 02 00 00 00       	mov    $0x2,%eax
  8028e5:	89 d1                	mov    %edx,%ecx
  8028e7:	89 d3                	mov    %edx,%ebx
  8028e9:	89 d7                	mov    %edx,%edi
  8028eb:	89 d6                	mov    %edx,%esi
  8028ed:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8028ef:	5b                   	pop    %ebx
  8028f0:	5e                   	pop    %esi
  8028f1:	5f                   	pop    %edi
  8028f2:	5d                   	pop    %ebp
  8028f3:	c3                   	ret    

008028f4 <sys_yield>:

void
sys_yield(void)
{
  8028f4:	55                   	push   %ebp
  8028f5:	89 e5                	mov    %esp,%ebp
  8028f7:	57                   	push   %edi
  8028f8:	56                   	push   %esi
  8028f9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ff:	b8 0b 00 00 00       	mov    $0xb,%eax
  802904:	89 d1                	mov    %edx,%ecx
  802906:	89 d3                	mov    %edx,%ebx
  802908:	89 d7                	mov    %edx,%edi
  80290a:	89 d6                	mov    %edx,%esi
  80290c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80290e:	5b                   	pop    %ebx
  80290f:	5e                   	pop    %esi
  802910:	5f                   	pop    %edi
  802911:	5d                   	pop    %ebp
  802912:	c3                   	ret    

00802913 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802913:	55                   	push   %ebp
  802914:	89 e5                	mov    %esp,%ebp
  802916:	57                   	push   %edi
  802917:	56                   	push   %esi
  802918:	53                   	push   %ebx
  802919:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80291c:	be 00 00 00 00       	mov    $0x0,%esi
  802921:	b8 04 00 00 00       	mov    $0x4,%eax
  802926:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802929:	8b 55 08             	mov    0x8(%ebp),%edx
  80292c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80292f:	89 f7                	mov    %esi,%edi
  802931:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802933:	85 c0                	test   %eax,%eax
  802935:	7e 28                	jle    80295f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  802937:	89 44 24 10          	mov    %eax,0x10(%esp)
  80293b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  802942:	00 
  802943:	c7 44 24 08 47 4d 80 	movl   $0x804d47,0x8(%esp)
  80294a:	00 
  80294b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802952:	00 
  802953:	c7 04 24 64 4d 80 00 	movl   $0x804d64,(%esp)
  80295a:	e8 74 f4 ff ff       	call   801dd3 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80295f:	83 c4 2c             	add    $0x2c,%esp
  802962:	5b                   	pop    %ebx
  802963:	5e                   	pop    %esi
  802964:	5f                   	pop    %edi
  802965:	5d                   	pop    %ebp
  802966:	c3                   	ret    

00802967 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802967:	55                   	push   %ebp
  802968:	89 e5                	mov    %esp,%ebp
  80296a:	57                   	push   %edi
  80296b:	56                   	push   %esi
  80296c:	53                   	push   %ebx
  80296d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802970:	b8 05 00 00 00       	mov    $0x5,%eax
  802975:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802978:	8b 55 08             	mov    0x8(%ebp),%edx
  80297b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80297e:	8b 7d 14             	mov    0x14(%ebp),%edi
  802981:	8b 75 18             	mov    0x18(%ebp),%esi
  802984:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802986:	85 c0                	test   %eax,%eax
  802988:	7e 28                	jle    8029b2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80298a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80298e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  802995:	00 
  802996:	c7 44 24 08 47 4d 80 	movl   $0x804d47,0x8(%esp)
  80299d:	00 
  80299e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8029a5:	00 
  8029a6:	c7 04 24 64 4d 80 00 	movl   $0x804d64,(%esp)
  8029ad:	e8 21 f4 ff ff       	call   801dd3 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8029b2:	83 c4 2c             	add    $0x2c,%esp
  8029b5:	5b                   	pop    %ebx
  8029b6:	5e                   	pop    %esi
  8029b7:	5f                   	pop    %edi
  8029b8:	5d                   	pop    %ebp
  8029b9:	c3                   	ret    

008029ba <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8029ba:	55                   	push   %ebp
  8029bb:	89 e5                	mov    %esp,%ebp
  8029bd:	57                   	push   %edi
  8029be:	56                   	push   %esi
  8029bf:	53                   	push   %ebx
  8029c0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8029c8:	b8 06 00 00 00       	mov    $0x6,%eax
  8029cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d3:	89 df                	mov    %ebx,%edi
  8029d5:	89 de                	mov    %ebx,%esi
  8029d7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	7e 28                	jle    802a05 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8029dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8029e1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8029e8:	00 
  8029e9:	c7 44 24 08 47 4d 80 	movl   $0x804d47,0x8(%esp)
  8029f0:	00 
  8029f1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8029f8:	00 
  8029f9:	c7 04 24 64 4d 80 00 	movl   $0x804d64,(%esp)
  802a00:	e8 ce f3 ff ff       	call   801dd3 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802a05:	83 c4 2c             	add    $0x2c,%esp
  802a08:	5b                   	pop    %ebx
  802a09:	5e                   	pop    %esi
  802a0a:	5f                   	pop    %edi
  802a0b:	5d                   	pop    %ebp
  802a0c:	c3                   	ret    

00802a0d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802a0d:	55                   	push   %ebp
  802a0e:	89 e5                	mov    %esp,%ebp
  802a10:	57                   	push   %edi
  802a11:	56                   	push   %esi
  802a12:	53                   	push   %ebx
  802a13:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802a16:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a1b:	b8 08 00 00 00       	mov    $0x8,%eax
  802a20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a23:	8b 55 08             	mov    0x8(%ebp),%edx
  802a26:	89 df                	mov    %ebx,%edi
  802a28:	89 de                	mov    %ebx,%esi
  802a2a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	7e 28                	jle    802a58 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802a30:	89 44 24 10          	mov    %eax,0x10(%esp)
  802a34:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  802a3b:	00 
  802a3c:	c7 44 24 08 47 4d 80 	movl   $0x804d47,0x8(%esp)
  802a43:	00 
  802a44:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802a4b:	00 
  802a4c:	c7 04 24 64 4d 80 00 	movl   $0x804d64,(%esp)
  802a53:	e8 7b f3 ff ff       	call   801dd3 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802a58:	83 c4 2c             	add    $0x2c,%esp
  802a5b:	5b                   	pop    %ebx
  802a5c:	5e                   	pop    %esi
  802a5d:	5f                   	pop    %edi
  802a5e:	5d                   	pop    %ebp
  802a5f:	c3                   	ret    

00802a60 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802a60:	55                   	push   %ebp
  802a61:	89 e5                	mov    %esp,%ebp
  802a63:	57                   	push   %edi
  802a64:	56                   	push   %esi
  802a65:	53                   	push   %ebx
  802a66:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802a69:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a6e:	b8 09 00 00 00       	mov    $0x9,%eax
  802a73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a76:	8b 55 08             	mov    0x8(%ebp),%edx
  802a79:	89 df                	mov    %ebx,%edi
  802a7b:	89 de                	mov    %ebx,%esi
  802a7d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802a7f:	85 c0                	test   %eax,%eax
  802a81:	7e 28                	jle    802aab <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802a83:	89 44 24 10          	mov    %eax,0x10(%esp)
  802a87:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  802a8e:	00 
  802a8f:	c7 44 24 08 47 4d 80 	movl   $0x804d47,0x8(%esp)
  802a96:	00 
  802a97:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802a9e:	00 
  802a9f:	c7 04 24 64 4d 80 00 	movl   $0x804d64,(%esp)
  802aa6:	e8 28 f3 ff ff       	call   801dd3 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  802aab:	83 c4 2c             	add    $0x2c,%esp
  802aae:	5b                   	pop    %ebx
  802aaf:	5e                   	pop    %esi
  802ab0:	5f                   	pop    %edi
  802ab1:	5d                   	pop    %ebp
  802ab2:	c3                   	ret    

00802ab3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802ab3:	55                   	push   %ebp
  802ab4:	89 e5                	mov    %esp,%ebp
  802ab6:	57                   	push   %edi
  802ab7:	56                   	push   %esi
  802ab8:	53                   	push   %ebx
  802ab9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802abc:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ac1:	b8 0a 00 00 00       	mov    $0xa,%eax
  802ac6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ac9:	8b 55 08             	mov    0x8(%ebp),%edx
  802acc:	89 df                	mov    %ebx,%edi
  802ace:	89 de                	mov    %ebx,%esi
  802ad0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	7e 28                	jle    802afe <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  802ad6:	89 44 24 10          	mov    %eax,0x10(%esp)
  802ada:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  802ae1:	00 
  802ae2:	c7 44 24 08 47 4d 80 	movl   $0x804d47,0x8(%esp)
  802ae9:	00 
  802aea:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802af1:	00 
  802af2:	c7 04 24 64 4d 80 00 	movl   $0x804d64,(%esp)
  802af9:	e8 d5 f2 ff ff       	call   801dd3 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  802afe:	83 c4 2c             	add    $0x2c,%esp
  802b01:	5b                   	pop    %ebx
  802b02:	5e                   	pop    %esi
  802b03:	5f                   	pop    %edi
  802b04:	5d                   	pop    %ebp
  802b05:	c3                   	ret    

00802b06 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  802b06:	55                   	push   %ebp
  802b07:	89 e5                	mov    %esp,%ebp
  802b09:	57                   	push   %edi
  802b0a:	56                   	push   %esi
  802b0b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b0c:	be 00 00 00 00       	mov    $0x0,%esi
  802b11:	b8 0c 00 00 00       	mov    $0xc,%eax
  802b16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b19:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802b1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  802b22:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  802b24:	5b                   	pop    %ebx
  802b25:	5e                   	pop    %esi
  802b26:	5f                   	pop    %edi
  802b27:	5d                   	pop    %ebp
  802b28:	c3                   	ret    

00802b29 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802b29:	55                   	push   %ebp
  802b2a:	89 e5                	mov    %esp,%ebp
  802b2c:	57                   	push   %edi
  802b2d:	56                   	push   %esi
  802b2e:	53                   	push   %ebx
  802b2f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b32:	b9 00 00 00 00       	mov    $0x0,%ecx
  802b37:	b8 0d 00 00 00       	mov    $0xd,%eax
  802b3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3f:	89 cb                	mov    %ecx,%ebx
  802b41:	89 cf                	mov    %ecx,%edi
  802b43:	89 ce                	mov    %ecx,%esi
  802b45:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802b47:	85 c0                	test   %eax,%eax
  802b49:	7e 28                	jle    802b73 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  802b4b:	89 44 24 10          	mov    %eax,0x10(%esp)
  802b4f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  802b56:	00 
  802b57:	c7 44 24 08 47 4d 80 	movl   $0x804d47,0x8(%esp)
  802b5e:	00 
  802b5f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802b66:	00 
  802b67:	c7 04 24 64 4d 80 00 	movl   $0x804d64,(%esp)
  802b6e:	e8 60 f2 ff ff       	call   801dd3 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802b73:	83 c4 2c             	add    $0x2c,%esp
  802b76:	5b                   	pop    %ebx
  802b77:	5e                   	pop    %esi
  802b78:	5f                   	pop    %edi
  802b79:	5d                   	pop    %ebp
  802b7a:	c3                   	ret    

00802b7b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  802b7b:	55                   	push   %ebp
  802b7c:	89 e5                	mov    %esp,%ebp
  802b7e:	57                   	push   %edi
  802b7f:	56                   	push   %esi
  802b80:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b81:	ba 00 00 00 00       	mov    $0x0,%edx
  802b86:	b8 0e 00 00 00       	mov    $0xe,%eax
  802b8b:	89 d1                	mov    %edx,%ecx
  802b8d:	89 d3                	mov    %edx,%ebx
  802b8f:	89 d7                	mov    %edx,%edi
  802b91:	89 d6                	mov    %edx,%esi
  802b93:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  802b95:	5b                   	pop    %ebx
  802b96:	5e                   	pop    %esi
  802b97:	5f                   	pop    %edi
  802b98:	5d                   	pop    %ebp
  802b99:	c3                   	ret    

00802b9a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  802b9a:	55                   	push   %ebp
  802b9b:	89 e5                	mov    %esp,%ebp
  802b9d:	57                   	push   %edi
  802b9e:	56                   	push   %esi
  802b9f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ba0:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ba5:	b8 0f 00 00 00       	mov    $0xf,%eax
  802baa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802bad:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb0:	89 df                	mov    %ebx,%edi
  802bb2:	89 de                	mov    %ebx,%esi
  802bb4:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  802bb6:	5b                   	pop    %ebx
  802bb7:	5e                   	pop    %esi
  802bb8:	5f                   	pop    %edi
  802bb9:	5d                   	pop    %ebp
  802bba:	c3                   	ret    

00802bbb <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  802bbb:	55                   	push   %ebp
  802bbc:	89 e5                	mov    %esp,%ebp
  802bbe:	57                   	push   %edi
  802bbf:	56                   	push   %esi
  802bc0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802bc1:	bb 00 00 00 00       	mov    $0x0,%ebx
  802bc6:	b8 10 00 00 00       	mov    $0x10,%eax
  802bcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802bce:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd1:	89 df                	mov    %ebx,%edi
  802bd3:	89 de                	mov    %ebx,%esi
  802bd5:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  802bd7:	5b                   	pop    %ebx
  802bd8:	5e                   	pop    %esi
  802bd9:	5f                   	pop    %edi
  802bda:	5d                   	pop    %ebp
  802bdb:	c3                   	ret    

00802bdc <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  802bdc:	55                   	push   %ebp
  802bdd:	89 e5                	mov    %esp,%ebp
  802bdf:	57                   	push   %edi
  802be0:	56                   	push   %esi
  802be1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802be2:	b9 00 00 00 00       	mov    $0x0,%ecx
  802be7:	b8 11 00 00 00       	mov    $0x11,%eax
  802bec:	8b 55 08             	mov    0x8(%ebp),%edx
  802bef:	89 cb                	mov    %ecx,%ebx
  802bf1:	89 cf                	mov    %ecx,%edi
  802bf3:	89 ce                	mov    %ecx,%esi
  802bf5:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  802bf7:	5b                   	pop    %ebx
  802bf8:	5e                   	pop    %esi
  802bf9:	5f                   	pop    %edi
  802bfa:	5d                   	pop    %ebp
  802bfb:	c3                   	ret    

00802bfc <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  802bfc:	55                   	push   %ebp
  802bfd:	89 e5                	mov    %esp,%ebp
  802bff:	57                   	push   %edi
  802c00:	56                   	push   %esi
  802c01:	53                   	push   %ebx
  802c02:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802c05:	be 00 00 00 00       	mov    $0x0,%esi
  802c0a:	b8 12 00 00 00       	mov    $0x12,%eax
  802c0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c12:	8b 55 08             	mov    0x8(%ebp),%edx
  802c15:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802c18:	8b 7d 14             	mov    0x14(%ebp),%edi
  802c1b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  802c1d:	85 c0                	test   %eax,%eax
  802c1f:	7e 28                	jle    802c49 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  802c21:	89 44 24 10          	mov    %eax,0x10(%esp)
  802c25:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  802c2c:	00 
  802c2d:	c7 44 24 08 47 4d 80 	movl   $0x804d47,0x8(%esp)
  802c34:	00 
  802c35:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802c3c:	00 
  802c3d:	c7 04 24 64 4d 80 00 	movl   $0x804d64,(%esp)
  802c44:	e8 8a f1 ff ff       	call   801dd3 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  802c49:	83 c4 2c             	add    $0x2c,%esp
  802c4c:	5b                   	pop    %ebx
  802c4d:	5e                   	pop    %esi
  802c4e:	5f                   	pop    %edi
  802c4f:	5d                   	pop    %ebp
  802c50:	c3                   	ret    

00802c51 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802c51:	55                   	push   %ebp
  802c52:	89 e5                	mov    %esp,%ebp
  802c54:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802c57:	83 3d 14 a0 80 00 00 	cmpl   $0x0,0x80a014
  802c5e:	75 68                	jne    802cc8 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  802c60:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802c65:	8b 40 48             	mov    0x48(%eax),%eax
  802c68:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802c6f:	00 
  802c70:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802c77:	ee 
  802c78:	89 04 24             	mov    %eax,(%esp)
  802c7b:	e8 93 fc ff ff       	call   802913 <sys_page_alloc>
  802c80:	85 c0                	test   %eax,%eax
  802c82:	74 2c                	je     802cb0 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  802c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c88:	c7 04 24 74 4d 80 00 	movl   $0x804d74,(%esp)
  802c8f:	e8 38 f2 ff ff       	call   801ecc <cprintf>
			panic("set_pg_fault_handler");
  802c94:	c7 44 24 08 a7 4d 80 	movl   $0x804da7,0x8(%esp)
  802c9b:	00 
  802c9c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802ca3:	00 
  802ca4:	c7 04 24 bc 4d 80 00 	movl   $0x804dbc,(%esp)
  802cab:	e8 23 f1 ff ff       	call   801dd3 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802cb0:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802cb5:	8b 40 48             	mov    0x48(%eax),%eax
  802cb8:	c7 44 24 04 d2 2c 80 	movl   $0x802cd2,0x4(%esp)
  802cbf:	00 
  802cc0:	89 04 24             	mov    %eax,(%esp)
  802cc3:	e8 eb fd ff ff       	call   802ab3 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccb:	a3 14 a0 80 00       	mov    %eax,0x80a014
}
  802cd0:	c9                   	leave  
  802cd1:	c3                   	ret    

00802cd2 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802cd2:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802cd3:	a1 14 a0 80 00       	mov    0x80a014,%eax
	call *%eax
  802cd8:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802cda:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  802cdd:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  802ce1:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  802ce3:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  802ce7:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  802ce8:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  802ceb:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  802ced:	58                   	pop    %eax
	popl %eax
  802cee:	58                   	pop    %eax
	popal
  802cef:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802cf0:	83 c4 04             	add    $0x4,%esp
	popfl
  802cf3:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802cf4:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802cf5:	c3                   	ret    
  802cf6:	66 90                	xchg   %ax,%ax
  802cf8:	66 90                	xchg   %ax,%ax
  802cfa:	66 90                	xchg   %ax,%ax
  802cfc:	66 90                	xchg   %ax,%ax
  802cfe:	66 90                	xchg   %ax,%ax

00802d00 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802d00:	55                   	push   %ebp
  802d01:	89 e5                	mov    %esp,%ebp
  802d03:	56                   	push   %esi
  802d04:	53                   	push   %ebx
  802d05:	83 ec 10             	sub    $0x10,%esp
  802d08:	8b 75 08             	mov    0x8(%ebp),%esi
  802d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802d11:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802d13:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802d18:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  802d1b:	89 04 24             	mov    %eax,(%esp)
  802d1e:	e8 06 fe ff ff       	call   802b29 <sys_ipc_recv>
  802d23:	85 c0                	test   %eax,%eax
  802d25:	74 16                	je     802d3d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802d27:	85 f6                	test   %esi,%esi
  802d29:	74 06                	je     802d31 <ipc_recv+0x31>
			*from_env_store = 0;
  802d2b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802d31:	85 db                	test   %ebx,%ebx
  802d33:	74 2c                	je     802d61 <ipc_recv+0x61>
			*perm_store = 0;
  802d35:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802d3b:	eb 24                	jmp    802d61 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  802d3d:	85 f6                	test   %esi,%esi
  802d3f:	74 0a                	je     802d4b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802d41:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802d46:	8b 40 74             	mov    0x74(%eax),%eax
  802d49:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  802d4b:	85 db                	test   %ebx,%ebx
  802d4d:	74 0a                	je     802d59 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  802d4f:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802d54:	8b 40 78             	mov    0x78(%eax),%eax
  802d57:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802d59:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802d5e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802d61:	83 c4 10             	add    $0x10,%esp
  802d64:	5b                   	pop    %ebx
  802d65:	5e                   	pop    %esi
  802d66:	5d                   	pop    %ebp
  802d67:	c3                   	ret    

00802d68 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802d68:	55                   	push   %ebp
  802d69:	89 e5                	mov    %esp,%ebp
  802d6b:	57                   	push   %edi
  802d6c:	56                   	push   %esi
  802d6d:	53                   	push   %ebx
  802d6e:	83 ec 1c             	sub    $0x1c,%esp
  802d71:	8b 75 0c             	mov    0xc(%ebp),%esi
  802d74:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802d77:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  802d7a:	85 db                	test   %ebx,%ebx
  802d7c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802d81:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802d84:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d88:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d8c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	89 04 24             	mov    %eax,(%esp)
  802d96:	e8 6b fd ff ff       	call   802b06 <sys_ipc_try_send>
	if (r == 0) return;
  802d9b:	85 c0                	test   %eax,%eax
  802d9d:	75 22                	jne    802dc1 <ipc_send+0x59>
  802d9f:	eb 4c                	jmp    802ded <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802da1:	84 d2                	test   %dl,%dl
  802da3:	75 48                	jne    802ded <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802da5:	e8 4a fb ff ff       	call   8028f4 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  802daa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802dae:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802db2:	89 74 24 04          	mov    %esi,0x4(%esp)
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	89 04 24             	mov    %eax,(%esp)
  802dbc:	e8 45 fd ff ff       	call   802b06 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802dc1:	85 c0                	test   %eax,%eax
  802dc3:	0f 94 c2             	sete   %dl
  802dc6:	74 d9                	je     802da1 <ipc_send+0x39>
  802dc8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802dcb:	74 d4                	je     802da1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  802dcd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802dd1:	c7 44 24 08 ca 4d 80 	movl   $0x804dca,0x8(%esp)
  802dd8:	00 
  802dd9:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802de0:	00 
  802de1:	c7 04 24 d8 4d 80 00 	movl   $0x804dd8,(%esp)
  802de8:	e8 e6 ef ff ff       	call   801dd3 <_panic>
}
  802ded:	83 c4 1c             	add    $0x1c,%esp
  802df0:	5b                   	pop    %ebx
  802df1:	5e                   	pop    %esi
  802df2:	5f                   	pop    %edi
  802df3:	5d                   	pop    %ebp
  802df4:	c3                   	ret    

00802df5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802df5:	55                   	push   %ebp
  802df6:	89 e5                	mov    %esp,%ebp
  802df8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802dfb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802e00:	89 c2                	mov    %eax,%edx
  802e02:	c1 e2 07             	shl    $0x7,%edx
  802e05:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802e0b:	8b 52 50             	mov    0x50(%edx),%edx
  802e0e:	39 ca                	cmp    %ecx,%edx
  802e10:	75 0d                	jne    802e1f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802e12:	c1 e0 07             	shl    $0x7,%eax
  802e15:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802e1a:	8b 40 40             	mov    0x40(%eax),%eax
  802e1d:	eb 0e                	jmp    802e2d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802e1f:	83 c0 01             	add    $0x1,%eax
  802e22:	3d 00 04 00 00       	cmp    $0x400,%eax
  802e27:	75 d7                	jne    802e00 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802e29:	66 b8 00 00          	mov    $0x0,%ax
}
  802e2d:	5d                   	pop    %ebp
  802e2e:	c3                   	ret    
  802e2f:	90                   	nop

00802e30 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802e30:	55                   	push   %ebp
  802e31:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	05 00 00 00 30       	add    $0x30000000,%eax
  802e3b:	c1 e8 0c             	shr    $0xc,%eax
}
  802e3e:	5d                   	pop    %ebp
  802e3f:	c3                   	ret    

00802e40 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802e40:	55                   	push   %ebp
  802e41:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802e43:	8b 45 08             	mov    0x8(%ebp),%eax
  802e46:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  802e4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802e50:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  802e55:	5d                   	pop    %ebp
  802e56:	c3                   	ret    

00802e57 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802e57:	55                   	push   %ebp
  802e58:	89 e5                	mov    %esp,%ebp
  802e5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e5d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  802e62:	89 c2                	mov    %eax,%edx
  802e64:	c1 ea 16             	shr    $0x16,%edx
  802e67:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802e6e:	f6 c2 01             	test   $0x1,%dl
  802e71:	74 11                	je     802e84 <fd_alloc+0x2d>
  802e73:	89 c2                	mov    %eax,%edx
  802e75:	c1 ea 0c             	shr    $0xc,%edx
  802e78:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802e7f:	f6 c2 01             	test   $0x1,%dl
  802e82:	75 09                	jne    802e8d <fd_alloc+0x36>
			*fd_store = fd;
  802e84:	89 01                	mov    %eax,(%ecx)
			return 0;
  802e86:	b8 00 00 00 00       	mov    $0x0,%eax
  802e8b:	eb 17                	jmp    802ea4 <fd_alloc+0x4d>
  802e8d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802e92:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802e97:	75 c9                	jne    802e62 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802e99:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  802e9f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  802ea4:	5d                   	pop    %ebp
  802ea5:	c3                   	ret    

00802ea6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802ea6:	55                   	push   %ebp
  802ea7:	89 e5                	mov    %esp,%ebp
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802eac:	83 f8 1f             	cmp    $0x1f,%eax
  802eaf:	77 36                	ja     802ee7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802eb1:	c1 e0 0c             	shl    $0xc,%eax
  802eb4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  802eb9:	89 c2                	mov    %eax,%edx
  802ebb:	c1 ea 16             	shr    $0x16,%edx
  802ebe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802ec5:	f6 c2 01             	test   $0x1,%dl
  802ec8:	74 24                	je     802eee <fd_lookup+0x48>
  802eca:	89 c2                	mov    %eax,%edx
  802ecc:	c1 ea 0c             	shr    $0xc,%edx
  802ecf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802ed6:	f6 c2 01             	test   $0x1,%dl
  802ed9:	74 1a                	je     802ef5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  802edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ede:	89 02                	mov    %eax,(%edx)
	return 0;
  802ee0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ee5:	eb 13                	jmp    802efa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802ee7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802eec:	eb 0c                	jmp    802efa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  802eee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802ef3:	eb 05                	jmp    802efa <fd_lookup+0x54>
  802ef5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  802efa:	5d                   	pop    %ebp
  802efb:	c3                   	ret    

00802efc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802efc:	55                   	push   %ebp
  802efd:	89 e5                	mov    %esp,%ebp
  802eff:	83 ec 18             	sub    $0x18,%esp
  802f02:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  802f05:	ba 00 00 00 00       	mov    $0x0,%edx
  802f0a:	eb 13                	jmp    802f1f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  802f0c:	39 08                	cmp    %ecx,(%eax)
  802f0e:	75 0c                	jne    802f1c <dev_lookup+0x20>
			*dev = devtab[i];
  802f10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f13:	89 01                	mov    %eax,(%ecx)
			return 0;
  802f15:	b8 00 00 00 00       	mov    $0x0,%eax
  802f1a:	eb 38                	jmp    802f54 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802f1c:	83 c2 01             	add    $0x1,%edx
  802f1f:	8b 04 95 64 4e 80 00 	mov    0x804e64(,%edx,4),%eax
  802f26:	85 c0                	test   %eax,%eax
  802f28:	75 e2                	jne    802f0c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802f2a:	a1 10 a0 80 00       	mov    0x80a010,%eax
  802f2f:	8b 40 48             	mov    0x48(%eax),%eax
  802f32:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f36:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f3a:	c7 04 24 e4 4d 80 00 	movl   $0x804de4,(%esp)
  802f41:	e8 86 ef ff ff       	call   801ecc <cprintf>
	*dev = 0;
  802f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802f4f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802f54:	c9                   	leave  
  802f55:	c3                   	ret    

00802f56 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802f56:	55                   	push   %ebp
  802f57:	89 e5                	mov    %esp,%ebp
  802f59:	56                   	push   %esi
  802f5a:	53                   	push   %ebx
  802f5b:	83 ec 20             	sub    $0x20,%esp
  802f5e:	8b 75 08             	mov    0x8(%ebp),%esi
  802f61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802f64:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f67:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802f6b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802f71:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802f74:	89 04 24             	mov    %eax,(%esp)
  802f77:	e8 2a ff ff ff       	call   802ea6 <fd_lookup>
  802f7c:	85 c0                	test   %eax,%eax
  802f7e:	78 05                	js     802f85 <fd_close+0x2f>
	    || fd != fd2)
  802f80:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  802f83:	74 0c                	je     802f91 <fd_close+0x3b>
		return (must_exist ? r : 0);
  802f85:	84 db                	test   %bl,%bl
  802f87:	ba 00 00 00 00       	mov    $0x0,%edx
  802f8c:	0f 44 c2             	cmove  %edx,%eax
  802f8f:	eb 3f                	jmp    802fd0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802f91:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f94:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f98:	8b 06                	mov    (%esi),%eax
  802f9a:	89 04 24             	mov    %eax,(%esp)
  802f9d:	e8 5a ff ff ff       	call   802efc <dev_lookup>
  802fa2:	89 c3                	mov    %eax,%ebx
  802fa4:	85 c0                	test   %eax,%eax
  802fa6:	78 16                	js     802fbe <fd_close+0x68>
		if (dev->dev_close)
  802fa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fab:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  802fae:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  802fb3:	85 c0                	test   %eax,%eax
  802fb5:	74 07                	je     802fbe <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  802fb7:	89 34 24             	mov    %esi,(%esp)
  802fba:	ff d0                	call   *%eax
  802fbc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802fbe:	89 74 24 04          	mov    %esi,0x4(%esp)
  802fc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802fc9:	e8 ec f9 ff ff       	call   8029ba <sys_page_unmap>
	return r;
  802fce:	89 d8                	mov    %ebx,%eax
}
  802fd0:	83 c4 20             	add    $0x20,%esp
  802fd3:	5b                   	pop    %ebx
  802fd4:	5e                   	pop    %esi
  802fd5:	5d                   	pop    %ebp
  802fd6:	c3                   	ret    

00802fd7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  802fd7:	55                   	push   %ebp
  802fd8:	89 e5                	mov    %esp,%ebp
  802fda:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fdd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802fe0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe7:	89 04 24             	mov    %eax,(%esp)
  802fea:	e8 b7 fe ff ff       	call   802ea6 <fd_lookup>
  802fef:	89 c2                	mov    %eax,%edx
  802ff1:	85 d2                	test   %edx,%edx
  802ff3:	78 13                	js     803008 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  802ff5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802ffc:	00 
  802ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803000:	89 04 24             	mov    %eax,(%esp)
  803003:	e8 4e ff ff ff       	call   802f56 <fd_close>
}
  803008:	c9                   	leave  
  803009:	c3                   	ret    

0080300a <close_all>:

void
close_all(void)
{
  80300a:	55                   	push   %ebp
  80300b:	89 e5                	mov    %esp,%ebp
  80300d:	53                   	push   %ebx
  80300e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  803011:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  803016:	89 1c 24             	mov    %ebx,(%esp)
  803019:	e8 b9 ff ff ff       	call   802fd7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80301e:	83 c3 01             	add    $0x1,%ebx
  803021:	83 fb 20             	cmp    $0x20,%ebx
  803024:	75 f0                	jne    803016 <close_all+0xc>
		close(i);
}
  803026:	83 c4 14             	add    $0x14,%esp
  803029:	5b                   	pop    %ebx
  80302a:	5d                   	pop    %ebp
  80302b:	c3                   	ret    

0080302c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80302c:	55                   	push   %ebp
  80302d:	89 e5                	mov    %esp,%ebp
  80302f:	57                   	push   %edi
  803030:	56                   	push   %esi
  803031:	53                   	push   %ebx
  803032:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  803035:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803038:	89 44 24 04          	mov    %eax,0x4(%esp)
  80303c:	8b 45 08             	mov    0x8(%ebp),%eax
  80303f:	89 04 24             	mov    %eax,(%esp)
  803042:	e8 5f fe ff ff       	call   802ea6 <fd_lookup>
  803047:	89 c2                	mov    %eax,%edx
  803049:	85 d2                	test   %edx,%edx
  80304b:	0f 88 e1 00 00 00    	js     803132 <dup+0x106>
		return r;
	close(newfdnum);
  803051:	8b 45 0c             	mov    0xc(%ebp),%eax
  803054:	89 04 24             	mov    %eax,(%esp)
  803057:	e8 7b ff ff ff       	call   802fd7 <close>

	newfd = INDEX2FD(newfdnum);
  80305c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80305f:	c1 e3 0c             	shl    $0xc,%ebx
  803062:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  803068:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306b:	89 04 24             	mov    %eax,(%esp)
  80306e:	e8 cd fd ff ff       	call   802e40 <fd2data>
  803073:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  803075:	89 1c 24             	mov    %ebx,(%esp)
  803078:	e8 c3 fd ff ff       	call   802e40 <fd2data>
  80307d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80307f:	89 f0                	mov    %esi,%eax
  803081:	c1 e8 16             	shr    $0x16,%eax
  803084:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80308b:	a8 01                	test   $0x1,%al
  80308d:	74 43                	je     8030d2 <dup+0xa6>
  80308f:	89 f0                	mov    %esi,%eax
  803091:	c1 e8 0c             	shr    $0xc,%eax
  803094:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80309b:	f6 c2 01             	test   $0x1,%dl
  80309e:	74 32                	je     8030d2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8030a0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8030a7:	25 07 0e 00 00       	and    $0xe07,%eax
  8030ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  8030b0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030b4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8030bb:	00 
  8030bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8030c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030c7:	e8 9b f8 ff ff       	call   802967 <sys_page_map>
  8030cc:	89 c6                	mov    %eax,%esi
  8030ce:	85 c0                	test   %eax,%eax
  8030d0:	78 3e                	js     803110 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8030d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d5:	89 c2                	mov    %eax,%edx
  8030d7:	c1 ea 0c             	shr    $0xc,%edx
  8030da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8030e1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8030e7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8030eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8030ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8030f6:	00 
  8030f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803102:	e8 60 f8 ff ff       	call   802967 <sys_page_map>
  803107:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  803109:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80310c:	85 f6                	test   %esi,%esi
  80310e:	79 22                	jns    803132 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  803110:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803114:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80311b:	e8 9a f8 ff ff       	call   8029ba <sys_page_unmap>
	sys_page_unmap(0, nva);
  803120:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803124:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80312b:	e8 8a f8 ff ff       	call   8029ba <sys_page_unmap>
	return r;
  803130:	89 f0                	mov    %esi,%eax
}
  803132:	83 c4 3c             	add    $0x3c,%esp
  803135:	5b                   	pop    %ebx
  803136:	5e                   	pop    %esi
  803137:	5f                   	pop    %edi
  803138:	5d                   	pop    %ebp
  803139:	c3                   	ret    

0080313a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80313a:	55                   	push   %ebp
  80313b:	89 e5                	mov    %esp,%ebp
  80313d:	53                   	push   %ebx
  80313e:	83 ec 24             	sub    $0x24,%esp
  803141:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803144:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803147:	89 44 24 04          	mov    %eax,0x4(%esp)
  80314b:	89 1c 24             	mov    %ebx,(%esp)
  80314e:	e8 53 fd ff ff       	call   802ea6 <fd_lookup>
  803153:	89 c2                	mov    %eax,%edx
  803155:	85 d2                	test   %edx,%edx
  803157:	78 6d                	js     8031c6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803159:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80315c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803160:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803163:	8b 00                	mov    (%eax),%eax
  803165:	89 04 24             	mov    %eax,(%esp)
  803168:	e8 8f fd ff ff       	call   802efc <dev_lookup>
  80316d:	85 c0                	test   %eax,%eax
  80316f:	78 55                	js     8031c6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803174:	8b 50 08             	mov    0x8(%eax),%edx
  803177:	83 e2 03             	and    $0x3,%edx
  80317a:	83 fa 01             	cmp    $0x1,%edx
  80317d:	75 23                	jne    8031a2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80317f:	a1 10 a0 80 00       	mov    0x80a010,%eax
  803184:	8b 40 48             	mov    0x48(%eax),%eax
  803187:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80318b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80318f:	c7 04 24 28 4e 80 00 	movl   $0x804e28,(%esp)
  803196:	e8 31 ed ff ff       	call   801ecc <cprintf>
		return -E_INVAL;
  80319b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8031a0:	eb 24                	jmp    8031c6 <read+0x8c>
	}
	if (!dev->dev_read)
  8031a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031a5:	8b 52 08             	mov    0x8(%edx),%edx
  8031a8:	85 d2                	test   %edx,%edx
  8031aa:	74 15                	je     8031c1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8031ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8031b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031ba:	89 04 24             	mov    %eax,(%esp)
  8031bd:	ff d2                	call   *%edx
  8031bf:	eb 05                	jmp    8031c6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8031c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8031c6:	83 c4 24             	add    $0x24,%esp
  8031c9:	5b                   	pop    %ebx
  8031ca:	5d                   	pop    %ebp
  8031cb:	c3                   	ret    

008031cc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8031cc:	55                   	push   %ebp
  8031cd:	89 e5                	mov    %esp,%ebp
  8031cf:	57                   	push   %edi
  8031d0:	56                   	push   %esi
  8031d1:	53                   	push   %ebx
  8031d2:	83 ec 1c             	sub    $0x1c,%esp
  8031d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8031d8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8031db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8031e0:	eb 23                	jmp    803205 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8031e2:	89 f0                	mov    %esi,%eax
  8031e4:	29 d8                	sub    %ebx,%eax
  8031e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8031ea:	89 d8                	mov    %ebx,%eax
  8031ec:	03 45 0c             	add    0xc(%ebp),%eax
  8031ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031f3:	89 3c 24             	mov    %edi,(%esp)
  8031f6:	e8 3f ff ff ff       	call   80313a <read>
		if (m < 0)
  8031fb:	85 c0                	test   %eax,%eax
  8031fd:	78 10                	js     80320f <readn+0x43>
			return m;
		if (m == 0)
  8031ff:	85 c0                	test   %eax,%eax
  803201:	74 0a                	je     80320d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  803203:	01 c3                	add    %eax,%ebx
  803205:	39 f3                	cmp    %esi,%ebx
  803207:	72 d9                	jb     8031e2 <readn+0x16>
  803209:	89 d8                	mov    %ebx,%eax
  80320b:	eb 02                	jmp    80320f <readn+0x43>
  80320d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80320f:	83 c4 1c             	add    $0x1c,%esp
  803212:	5b                   	pop    %ebx
  803213:	5e                   	pop    %esi
  803214:	5f                   	pop    %edi
  803215:	5d                   	pop    %ebp
  803216:	c3                   	ret    

00803217 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803217:	55                   	push   %ebp
  803218:	89 e5                	mov    %esp,%ebp
  80321a:	53                   	push   %ebx
  80321b:	83 ec 24             	sub    $0x24,%esp
  80321e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803221:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803224:	89 44 24 04          	mov    %eax,0x4(%esp)
  803228:	89 1c 24             	mov    %ebx,(%esp)
  80322b:	e8 76 fc ff ff       	call   802ea6 <fd_lookup>
  803230:	89 c2                	mov    %eax,%edx
  803232:	85 d2                	test   %edx,%edx
  803234:	78 68                	js     80329e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803236:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803239:	89 44 24 04          	mov    %eax,0x4(%esp)
  80323d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803240:	8b 00                	mov    (%eax),%eax
  803242:	89 04 24             	mov    %eax,(%esp)
  803245:	e8 b2 fc ff ff       	call   802efc <dev_lookup>
  80324a:	85 c0                	test   %eax,%eax
  80324c:	78 50                	js     80329e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80324e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803251:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  803255:	75 23                	jne    80327a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  803257:	a1 10 a0 80 00       	mov    0x80a010,%eax
  80325c:	8b 40 48             	mov    0x48(%eax),%eax
  80325f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803263:	89 44 24 04          	mov    %eax,0x4(%esp)
  803267:	c7 04 24 44 4e 80 00 	movl   $0x804e44,(%esp)
  80326e:	e8 59 ec ff ff       	call   801ecc <cprintf>
		return -E_INVAL;
  803273:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803278:	eb 24                	jmp    80329e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80327a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80327d:	8b 52 0c             	mov    0xc(%edx),%edx
  803280:	85 d2                	test   %edx,%edx
  803282:	74 15                	je     803299 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  803284:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803287:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80328b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80328e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803292:	89 04 24             	mov    %eax,(%esp)
  803295:	ff d2                	call   *%edx
  803297:	eb 05                	jmp    80329e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  803299:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80329e:	83 c4 24             	add    $0x24,%esp
  8032a1:	5b                   	pop    %ebx
  8032a2:	5d                   	pop    %ebp
  8032a3:	c3                   	ret    

008032a4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8032a4:	55                   	push   %ebp
  8032a5:	89 e5                	mov    %esp,%ebp
  8032a7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8032aa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8032ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b4:	89 04 24             	mov    %eax,(%esp)
  8032b7:	e8 ea fb ff ff       	call   802ea6 <fd_lookup>
  8032bc:	85 c0                	test   %eax,%eax
  8032be:	78 0e                	js     8032ce <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8032c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8032c6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8032c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8032ce:	c9                   	leave  
  8032cf:	c3                   	ret    

008032d0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8032d0:	55                   	push   %ebp
  8032d1:	89 e5                	mov    %esp,%ebp
  8032d3:	53                   	push   %ebx
  8032d4:	83 ec 24             	sub    $0x24,%esp
  8032d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8032da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8032dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032e1:	89 1c 24             	mov    %ebx,(%esp)
  8032e4:	e8 bd fb ff ff       	call   802ea6 <fd_lookup>
  8032e9:	89 c2                	mov    %eax,%edx
  8032eb:	85 d2                	test   %edx,%edx
  8032ed:	78 61                	js     803350 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8032ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f9:	8b 00                	mov    (%eax),%eax
  8032fb:	89 04 24             	mov    %eax,(%esp)
  8032fe:	e8 f9 fb ff ff       	call   802efc <dev_lookup>
  803303:	85 c0                	test   %eax,%eax
  803305:	78 49                	js     803350 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803307:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80330e:	75 23                	jne    803333 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  803310:	a1 10 a0 80 00       	mov    0x80a010,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803315:	8b 40 48             	mov    0x48(%eax),%eax
  803318:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80331c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803320:	c7 04 24 04 4e 80 00 	movl   $0x804e04,(%esp)
  803327:	e8 a0 eb ff ff       	call   801ecc <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80332c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  803331:	eb 1d                	jmp    803350 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  803333:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803336:	8b 52 18             	mov    0x18(%edx),%edx
  803339:	85 d2                	test   %edx,%edx
  80333b:	74 0e                	je     80334b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80333d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803340:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803344:	89 04 24             	mov    %eax,(%esp)
  803347:	ff d2                	call   *%edx
  803349:	eb 05                	jmp    803350 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80334b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  803350:	83 c4 24             	add    $0x24,%esp
  803353:	5b                   	pop    %ebx
  803354:	5d                   	pop    %ebp
  803355:	c3                   	ret    

00803356 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  803356:	55                   	push   %ebp
  803357:	89 e5                	mov    %esp,%ebp
  803359:	53                   	push   %ebx
  80335a:	83 ec 24             	sub    $0x24,%esp
  80335d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803360:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803363:	89 44 24 04          	mov    %eax,0x4(%esp)
  803367:	8b 45 08             	mov    0x8(%ebp),%eax
  80336a:	89 04 24             	mov    %eax,(%esp)
  80336d:	e8 34 fb ff ff       	call   802ea6 <fd_lookup>
  803372:	89 c2                	mov    %eax,%edx
  803374:	85 d2                	test   %edx,%edx
  803376:	78 52                	js     8033ca <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803378:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80337b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80337f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803382:	8b 00                	mov    (%eax),%eax
  803384:	89 04 24             	mov    %eax,(%esp)
  803387:	e8 70 fb ff ff       	call   802efc <dev_lookup>
  80338c:	85 c0                	test   %eax,%eax
  80338e:	78 3a                	js     8033ca <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  803390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803393:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  803397:	74 2c                	je     8033c5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  803399:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80339c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8033a3:	00 00 00 
	stat->st_isdir = 0;
  8033a6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8033ad:	00 00 00 
	stat->st_dev = dev;
  8033b0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8033b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8033ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033bd:	89 14 24             	mov    %edx,(%esp)
  8033c0:	ff 50 14             	call   *0x14(%eax)
  8033c3:	eb 05                	jmp    8033ca <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8033c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8033ca:	83 c4 24             	add    $0x24,%esp
  8033cd:	5b                   	pop    %ebx
  8033ce:	5d                   	pop    %ebp
  8033cf:	c3                   	ret    

008033d0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8033d0:	55                   	push   %ebp
  8033d1:	89 e5                	mov    %esp,%ebp
  8033d3:	56                   	push   %esi
  8033d4:	53                   	push   %ebx
  8033d5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8033d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8033df:	00 
  8033e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e3:	89 04 24             	mov    %eax,(%esp)
  8033e6:	e8 84 02 00 00       	call   80366f <open>
  8033eb:	89 c3                	mov    %eax,%ebx
  8033ed:	85 db                	test   %ebx,%ebx
  8033ef:	78 1b                	js     80340c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8033f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033f8:	89 1c 24             	mov    %ebx,(%esp)
  8033fb:	e8 56 ff ff ff       	call   803356 <fstat>
  803400:	89 c6                	mov    %eax,%esi
	close(fd);
  803402:	89 1c 24             	mov    %ebx,(%esp)
  803405:	e8 cd fb ff ff       	call   802fd7 <close>
	return r;
  80340a:	89 f0                	mov    %esi,%eax
}
  80340c:	83 c4 10             	add    $0x10,%esp
  80340f:	5b                   	pop    %ebx
  803410:	5e                   	pop    %esi
  803411:	5d                   	pop    %ebp
  803412:	c3                   	ret    

00803413 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  803413:	55                   	push   %ebp
  803414:	89 e5                	mov    %esp,%ebp
  803416:	56                   	push   %esi
  803417:	53                   	push   %ebx
  803418:	83 ec 10             	sub    $0x10,%esp
  80341b:	89 c6                	mov    %eax,%esi
  80341d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80341f:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  803426:	75 11                	jne    803439 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  803428:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80342f:	e8 c1 f9 ff ff       	call   802df5 <ipc_find_env>
  803434:	a3 00 a0 80 00       	mov    %eax,0x80a000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803439:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803440:	00 
  803441:	c7 44 24 08 00 b0 80 	movl   $0x80b000,0x8(%esp)
  803448:	00 
  803449:	89 74 24 04          	mov    %esi,0x4(%esp)
  80344d:	a1 00 a0 80 00       	mov    0x80a000,%eax
  803452:	89 04 24             	mov    %eax,(%esp)
  803455:	e8 0e f9 ff ff       	call   802d68 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80345a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803461:	00 
  803462:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803466:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80346d:	e8 8e f8 ff ff       	call   802d00 <ipc_recv>
}
  803472:	83 c4 10             	add    $0x10,%esp
  803475:	5b                   	pop    %ebx
  803476:	5e                   	pop    %esi
  803477:	5d                   	pop    %ebp
  803478:	c3                   	ret    

00803479 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803479:	55                   	push   %ebp
  80347a:	89 e5                	mov    %esp,%ebp
  80347c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80347f:	8b 45 08             	mov    0x8(%ebp),%eax
  803482:	8b 40 0c             	mov    0xc(%eax),%eax
  803485:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  80348a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80348d:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  803492:	ba 00 00 00 00       	mov    $0x0,%edx
  803497:	b8 02 00 00 00       	mov    $0x2,%eax
  80349c:	e8 72 ff ff ff       	call   803413 <fsipc>
}
  8034a1:	c9                   	leave  
  8034a2:	c3                   	ret    

008034a3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8034a3:	55                   	push   %ebp
  8034a4:	89 e5                	mov    %esp,%ebp
  8034a6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8034a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8034af:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  8034b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8034b9:	b8 06 00 00 00       	mov    $0x6,%eax
  8034be:	e8 50 ff ff ff       	call   803413 <fsipc>
}
  8034c3:	c9                   	leave  
  8034c4:	c3                   	ret    

008034c5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8034c5:	55                   	push   %ebp
  8034c6:	89 e5                	mov    %esp,%ebp
  8034c8:	53                   	push   %ebx
  8034c9:	83 ec 14             	sub    $0x14,%esp
  8034cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8034cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d5:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8034da:	ba 00 00 00 00       	mov    $0x0,%edx
  8034df:	b8 05 00 00 00       	mov    $0x5,%eax
  8034e4:	e8 2a ff ff ff       	call   803413 <fsipc>
  8034e9:	89 c2                	mov    %eax,%edx
  8034eb:	85 d2                	test   %edx,%edx
  8034ed:	78 2b                	js     80351a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8034ef:	c7 44 24 04 00 b0 80 	movl   $0x80b000,0x4(%esp)
  8034f6:	00 
  8034f7:	89 1c 24             	mov    %ebx,(%esp)
  8034fa:	e8 f8 ef ff ff       	call   8024f7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8034ff:	a1 80 b0 80 00       	mov    0x80b080,%eax
  803504:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80350a:	a1 84 b0 80 00       	mov    0x80b084,%eax
  80350f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  803515:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80351a:	83 c4 14             	add    $0x14,%esp
  80351d:	5b                   	pop    %ebx
  80351e:	5d                   	pop    %ebp
  80351f:	c3                   	ret    

00803520 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803520:	55                   	push   %ebp
  803521:	89 e5                	mov    %esp,%ebp
  803523:	53                   	push   %ebx
  803524:	83 ec 14             	sub    $0x14,%esp
  803527:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80352a:	8b 45 08             	mov    0x8(%ebp),%eax
  80352d:	8b 40 0c             	mov    0xc(%eax),%eax
  803530:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  803535:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80353b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  803540:	0f 46 c3             	cmovbe %ebx,%eax
  803543:	a3 04 b0 80 00       	mov    %eax,0x80b004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  803548:	89 44 24 08          	mov    %eax,0x8(%esp)
  80354c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80354f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803553:	c7 04 24 08 b0 80 00 	movl   $0x80b008,(%esp)
  80355a:	e8 35 f1 ff ff       	call   802694 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80355f:	ba 00 00 00 00       	mov    $0x0,%edx
  803564:	b8 04 00 00 00       	mov    $0x4,%eax
  803569:	e8 a5 fe ff ff       	call   803413 <fsipc>
  80356e:	85 c0                	test   %eax,%eax
  803570:	78 53                	js     8035c5 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  803572:	39 c3                	cmp    %eax,%ebx
  803574:	73 24                	jae    80359a <devfile_write+0x7a>
  803576:	c7 44 24 0c 78 4e 80 	movl   $0x804e78,0xc(%esp)
  80357d:	00 
  80357e:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  803585:	00 
  803586:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  80358d:	00 
  80358e:	c7 04 24 7f 4e 80 00 	movl   $0x804e7f,(%esp)
  803595:	e8 39 e8 ff ff       	call   801dd3 <_panic>
	assert(r <= PGSIZE);
  80359a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80359f:	7e 24                	jle    8035c5 <devfile_write+0xa5>
  8035a1:	c7 44 24 0c 8a 4e 80 	movl   $0x804e8a,0xc(%esp)
  8035a8:	00 
  8035a9:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  8035b0:	00 
  8035b1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  8035b8:	00 
  8035b9:	c7 04 24 7f 4e 80 00 	movl   $0x804e7f,(%esp)
  8035c0:	e8 0e e8 ff ff       	call   801dd3 <_panic>
	return r;
}
  8035c5:	83 c4 14             	add    $0x14,%esp
  8035c8:	5b                   	pop    %ebx
  8035c9:	5d                   	pop    %ebp
  8035ca:	c3                   	ret    

008035cb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8035cb:	55                   	push   %ebp
  8035cc:	89 e5                	mov    %esp,%ebp
  8035ce:	56                   	push   %esi
  8035cf:	53                   	push   %ebx
  8035d0:	83 ec 10             	sub    $0x10,%esp
  8035d3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8035d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035dc:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  8035e1:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8035e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8035ec:	b8 03 00 00 00       	mov    $0x3,%eax
  8035f1:	e8 1d fe ff ff       	call   803413 <fsipc>
  8035f6:	89 c3                	mov    %eax,%ebx
  8035f8:	85 c0                	test   %eax,%eax
  8035fa:	78 6a                	js     803666 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8035fc:	39 c6                	cmp    %eax,%esi
  8035fe:	73 24                	jae    803624 <devfile_read+0x59>
  803600:	c7 44 24 0c 78 4e 80 	movl   $0x804e78,0xc(%esp)
  803607:	00 
  803608:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  80360f:	00 
  803610:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  803617:	00 
  803618:	c7 04 24 7f 4e 80 00 	movl   $0x804e7f,(%esp)
  80361f:	e8 af e7 ff ff       	call   801dd3 <_panic>
	assert(r <= PGSIZE);
  803624:	3d 00 10 00 00       	cmp    $0x1000,%eax
  803629:	7e 24                	jle    80364f <devfile_read+0x84>
  80362b:	c7 44 24 0c 8a 4e 80 	movl   $0x804e8a,0xc(%esp)
  803632:	00 
  803633:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  80363a:	00 
  80363b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  803642:	00 
  803643:	c7 04 24 7f 4e 80 00 	movl   $0x804e7f,(%esp)
  80364a:	e8 84 e7 ff ff       	call   801dd3 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80364f:	89 44 24 08          	mov    %eax,0x8(%esp)
  803653:	c7 44 24 04 00 b0 80 	movl   $0x80b000,0x4(%esp)
  80365a:	00 
  80365b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80365e:	89 04 24             	mov    %eax,(%esp)
  803661:	e8 2e f0 ff ff       	call   802694 <memmove>
	return r;
}
  803666:	89 d8                	mov    %ebx,%eax
  803668:	83 c4 10             	add    $0x10,%esp
  80366b:	5b                   	pop    %ebx
  80366c:	5e                   	pop    %esi
  80366d:	5d                   	pop    %ebp
  80366e:	c3                   	ret    

0080366f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80366f:	55                   	push   %ebp
  803670:	89 e5                	mov    %esp,%ebp
  803672:	53                   	push   %ebx
  803673:	83 ec 24             	sub    $0x24,%esp
  803676:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  803679:	89 1c 24             	mov    %ebx,(%esp)
  80367c:	e8 3f ee ff ff       	call   8024c0 <strlen>
  803681:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803686:	7f 60                	jg     8036e8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  803688:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80368b:	89 04 24             	mov    %eax,(%esp)
  80368e:	e8 c4 f7 ff ff       	call   802e57 <fd_alloc>
  803693:	89 c2                	mov    %eax,%edx
  803695:	85 d2                	test   %edx,%edx
  803697:	78 54                	js     8036ed <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  803699:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80369d:	c7 04 24 00 b0 80 00 	movl   $0x80b000,(%esp)
  8036a4:	e8 4e ee ff ff       	call   8024f7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8036a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ac:	a3 00 b4 80 00       	mov    %eax,0x80b400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8036b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8036b9:	e8 55 fd ff ff       	call   803413 <fsipc>
  8036be:	89 c3                	mov    %eax,%ebx
  8036c0:	85 c0                	test   %eax,%eax
  8036c2:	79 17                	jns    8036db <open+0x6c>
		fd_close(fd, 0);
  8036c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8036cb:	00 
  8036cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cf:	89 04 24             	mov    %eax,(%esp)
  8036d2:	e8 7f f8 ff ff       	call   802f56 <fd_close>
		return r;
  8036d7:	89 d8                	mov    %ebx,%eax
  8036d9:	eb 12                	jmp    8036ed <open+0x7e>
	}

	return fd2num(fd);
  8036db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036de:	89 04 24             	mov    %eax,(%esp)
  8036e1:	e8 4a f7 ff ff       	call   802e30 <fd2num>
  8036e6:	eb 05                	jmp    8036ed <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8036e8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8036ed:	83 c4 24             	add    $0x24,%esp
  8036f0:	5b                   	pop    %ebx
  8036f1:	5d                   	pop    %ebp
  8036f2:	c3                   	ret    

008036f3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8036f3:	55                   	push   %ebp
  8036f4:	89 e5                	mov    %esp,%ebp
  8036f6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8036f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8036fe:	b8 08 00 00 00       	mov    $0x8,%eax
  803703:	e8 0b fd ff ff       	call   803413 <fsipc>
}
  803708:	c9                   	leave  
  803709:	c3                   	ret    

0080370a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80370a:	55                   	push   %ebp
  80370b:	89 e5                	mov    %esp,%ebp
  80370d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803710:	89 d0                	mov    %edx,%eax
  803712:	c1 e8 16             	shr    $0x16,%eax
  803715:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80371c:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803721:	f6 c1 01             	test   $0x1,%cl
  803724:	74 1d                	je     803743 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  803726:	c1 ea 0c             	shr    $0xc,%edx
  803729:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803730:	f6 c2 01             	test   $0x1,%dl
  803733:	74 0e                	je     803743 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803735:	c1 ea 0c             	shr    $0xc,%edx
  803738:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80373f:	ef 
  803740:	0f b7 c0             	movzwl %ax,%eax
}
  803743:	5d                   	pop    %ebp
  803744:	c3                   	ret    
  803745:	66 90                	xchg   %ax,%ax
  803747:	66 90                	xchg   %ax,%ax
  803749:	66 90                	xchg   %ax,%ax
  80374b:	66 90                	xchg   %ax,%ax
  80374d:	66 90                	xchg   %ax,%ax
  80374f:	90                   	nop

00803750 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803750:	55                   	push   %ebp
  803751:	89 e5                	mov    %esp,%ebp
  803753:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803756:	c7 44 24 04 96 4e 80 	movl   $0x804e96,0x4(%esp)
  80375d:	00 
  80375e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803761:	89 04 24             	mov    %eax,(%esp)
  803764:	e8 8e ed ff ff       	call   8024f7 <strcpy>
	return 0;
}
  803769:	b8 00 00 00 00       	mov    $0x0,%eax
  80376e:	c9                   	leave  
  80376f:	c3                   	ret    

00803770 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803770:	55                   	push   %ebp
  803771:	89 e5                	mov    %esp,%ebp
  803773:	53                   	push   %ebx
  803774:	83 ec 14             	sub    $0x14,%esp
  803777:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80377a:	89 1c 24             	mov    %ebx,(%esp)
  80377d:	e8 88 ff ff ff       	call   80370a <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  803782:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  803787:	83 f8 01             	cmp    $0x1,%eax
  80378a:	75 0d                	jne    803799 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80378c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80378f:	89 04 24             	mov    %eax,(%esp)
  803792:	e8 29 03 00 00       	call   803ac0 <nsipc_close>
  803797:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  803799:	89 d0                	mov    %edx,%eax
  80379b:	83 c4 14             	add    $0x14,%esp
  80379e:	5b                   	pop    %ebx
  80379f:	5d                   	pop    %ebp
  8037a0:	c3                   	ret    

008037a1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8037a1:	55                   	push   %ebp
  8037a2:	89 e5                	mov    %esp,%ebp
  8037a4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8037a7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8037ae:	00 
  8037af:	8b 45 10             	mov    0x10(%ebp),%eax
  8037b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8037b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8037c3:	89 04 24             	mov    %eax,(%esp)
  8037c6:	e8 f0 03 00 00       	call   803bbb <nsipc_send>
}
  8037cb:	c9                   	leave  
  8037cc:	c3                   	ret    

008037cd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8037cd:	55                   	push   %ebp
  8037ce:	89 e5                	mov    %esp,%ebp
  8037d0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8037d3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8037da:	00 
  8037db:	8b 45 10             	mov    0x10(%ebp),%eax
  8037de:	89 44 24 08          	mov    %eax,0x8(%esp)
  8037e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ef:	89 04 24             	mov    %eax,(%esp)
  8037f2:	e8 44 03 00 00       	call   803b3b <nsipc_recv>
}
  8037f7:	c9                   	leave  
  8037f8:	c3                   	ret    

008037f9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8037f9:	55                   	push   %ebp
  8037fa:	89 e5                	mov    %esp,%ebp
  8037fc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8037ff:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803802:	89 54 24 04          	mov    %edx,0x4(%esp)
  803806:	89 04 24             	mov    %eax,(%esp)
  803809:	e8 98 f6 ff ff       	call   802ea6 <fd_lookup>
  80380e:	85 c0                	test   %eax,%eax
  803810:	78 17                	js     803829 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803812:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803815:	8b 0d 80 90 80 00    	mov    0x809080,%ecx
  80381b:	39 08                	cmp    %ecx,(%eax)
  80381d:	75 05                	jne    803824 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80381f:	8b 40 0c             	mov    0xc(%eax),%eax
  803822:	eb 05                	jmp    803829 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  803824:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  803829:	c9                   	leave  
  80382a:	c3                   	ret    

0080382b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80382b:	55                   	push   %ebp
  80382c:	89 e5                	mov    %esp,%ebp
  80382e:	56                   	push   %esi
  80382f:	53                   	push   %ebx
  803830:	83 ec 20             	sub    $0x20,%esp
  803833:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803835:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803838:	89 04 24             	mov    %eax,(%esp)
  80383b:	e8 17 f6 ff ff       	call   802e57 <fd_alloc>
  803840:	89 c3                	mov    %eax,%ebx
  803842:	85 c0                	test   %eax,%eax
  803844:	78 21                	js     803867 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  803846:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80384d:	00 
  80384e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803851:	89 44 24 04          	mov    %eax,0x4(%esp)
  803855:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80385c:	e8 b2 f0 ff ff       	call   802913 <sys_page_alloc>
  803861:	89 c3                	mov    %eax,%ebx
  803863:	85 c0                	test   %eax,%eax
  803865:	79 0c                	jns    803873 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  803867:	89 34 24             	mov    %esi,(%esp)
  80386a:	e8 51 02 00 00       	call   803ac0 <nsipc_close>
		return r;
  80386f:	89 d8                	mov    %ebx,%eax
  803871:	eb 20                	jmp    803893 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803873:	8b 15 80 90 80 00    	mov    0x809080,%edx
  803879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80387e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803881:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  803888:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80388b:	89 14 24             	mov    %edx,(%esp)
  80388e:	e8 9d f5 ff ff       	call   802e30 <fd2num>
}
  803893:	83 c4 20             	add    $0x20,%esp
  803896:	5b                   	pop    %ebx
  803897:	5e                   	pop    %esi
  803898:	5d                   	pop    %ebp
  803899:	c3                   	ret    

0080389a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80389a:	55                   	push   %ebp
  80389b:	89 e5                	mov    %esp,%ebp
  80389d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a3:	e8 51 ff ff ff       	call   8037f9 <fd2sockid>
		return r;
  8038a8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038aa:	85 c0                	test   %eax,%eax
  8038ac:	78 23                	js     8038d1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8038ae:	8b 55 10             	mov    0x10(%ebp),%edx
  8038b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8038b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8038b8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8038bc:	89 04 24             	mov    %eax,(%esp)
  8038bf:	e8 45 01 00 00       	call   803a09 <nsipc_accept>
		return r;
  8038c4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8038c6:	85 c0                	test   %eax,%eax
  8038c8:	78 07                	js     8038d1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8038ca:	e8 5c ff ff ff       	call   80382b <alloc_sockfd>
  8038cf:	89 c1                	mov    %eax,%ecx
}
  8038d1:	89 c8                	mov    %ecx,%eax
  8038d3:	c9                   	leave  
  8038d4:	c3                   	ret    

008038d5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8038d5:	55                   	push   %ebp
  8038d6:	89 e5                	mov    %esp,%ebp
  8038d8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8038db:	8b 45 08             	mov    0x8(%ebp),%eax
  8038de:	e8 16 ff ff ff       	call   8037f9 <fd2sockid>
  8038e3:	89 c2                	mov    %eax,%edx
  8038e5:	85 d2                	test   %edx,%edx
  8038e7:	78 16                	js     8038ff <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8038e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8038ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8038f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038f7:	89 14 24             	mov    %edx,(%esp)
  8038fa:	e8 60 01 00 00       	call   803a5f <nsipc_bind>
}
  8038ff:	c9                   	leave  
  803900:	c3                   	ret    

00803901 <shutdown>:

int
shutdown(int s, int how)
{
  803901:	55                   	push   %ebp
  803902:	89 e5                	mov    %esp,%ebp
  803904:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803907:	8b 45 08             	mov    0x8(%ebp),%eax
  80390a:	e8 ea fe ff ff       	call   8037f9 <fd2sockid>
  80390f:	89 c2                	mov    %eax,%edx
  803911:	85 d2                	test   %edx,%edx
  803913:	78 0f                	js     803924 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  803915:	8b 45 0c             	mov    0xc(%ebp),%eax
  803918:	89 44 24 04          	mov    %eax,0x4(%esp)
  80391c:	89 14 24             	mov    %edx,(%esp)
  80391f:	e8 7a 01 00 00       	call   803a9e <nsipc_shutdown>
}
  803924:	c9                   	leave  
  803925:	c3                   	ret    

00803926 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803926:	55                   	push   %ebp
  803927:	89 e5                	mov    %esp,%ebp
  803929:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80392c:	8b 45 08             	mov    0x8(%ebp),%eax
  80392f:	e8 c5 fe ff ff       	call   8037f9 <fd2sockid>
  803934:	89 c2                	mov    %eax,%edx
  803936:	85 d2                	test   %edx,%edx
  803938:	78 16                	js     803950 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80393a:	8b 45 10             	mov    0x10(%ebp),%eax
  80393d:	89 44 24 08          	mov    %eax,0x8(%esp)
  803941:	8b 45 0c             	mov    0xc(%ebp),%eax
  803944:	89 44 24 04          	mov    %eax,0x4(%esp)
  803948:	89 14 24             	mov    %edx,(%esp)
  80394b:	e8 8a 01 00 00       	call   803ada <nsipc_connect>
}
  803950:	c9                   	leave  
  803951:	c3                   	ret    

00803952 <listen>:

int
listen(int s, int backlog)
{
  803952:	55                   	push   %ebp
  803953:	89 e5                	mov    %esp,%ebp
  803955:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803958:	8b 45 08             	mov    0x8(%ebp),%eax
  80395b:	e8 99 fe ff ff       	call   8037f9 <fd2sockid>
  803960:	89 c2                	mov    %eax,%edx
  803962:	85 d2                	test   %edx,%edx
  803964:	78 0f                	js     803975 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  803966:	8b 45 0c             	mov    0xc(%ebp),%eax
  803969:	89 44 24 04          	mov    %eax,0x4(%esp)
  80396d:	89 14 24             	mov    %edx,(%esp)
  803970:	e8 a4 01 00 00       	call   803b19 <nsipc_listen>
}
  803975:	c9                   	leave  
  803976:	c3                   	ret    

00803977 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803977:	55                   	push   %ebp
  803978:	89 e5                	mov    %esp,%ebp
  80397a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80397d:	8b 45 10             	mov    0x10(%ebp),%eax
  803980:	89 44 24 08          	mov    %eax,0x8(%esp)
  803984:	8b 45 0c             	mov    0xc(%ebp),%eax
  803987:	89 44 24 04          	mov    %eax,0x4(%esp)
  80398b:	8b 45 08             	mov    0x8(%ebp),%eax
  80398e:	89 04 24             	mov    %eax,(%esp)
  803991:	e8 98 02 00 00       	call   803c2e <nsipc_socket>
  803996:	89 c2                	mov    %eax,%edx
  803998:	85 d2                	test   %edx,%edx
  80399a:	78 05                	js     8039a1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80399c:	e8 8a fe ff ff       	call   80382b <alloc_sockfd>
}
  8039a1:	c9                   	leave  
  8039a2:	c3                   	ret    

008039a3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8039a3:	55                   	push   %ebp
  8039a4:	89 e5                	mov    %esp,%ebp
  8039a6:	53                   	push   %ebx
  8039a7:	83 ec 14             	sub    $0x14,%esp
  8039aa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8039ac:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  8039b3:	75 11                	jne    8039c6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8039b5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8039bc:	e8 34 f4 ff ff       	call   802df5 <ipc_find_env>
  8039c1:	a3 04 a0 80 00       	mov    %eax,0x80a004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8039c6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8039cd:	00 
  8039ce:	c7 44 24 08 00 c0 80 	movl   $0x80c000,0x8(%esp)
  8039d5:	00 
  8039d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8039da:	a1 04 a0 80 00       	mov    0x80a004,%eax
  8039df:	89 04 24             	mov    %eax,(%esp)
  8039e2:	e8 81 f3 ff ff       	call   802d68 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8039e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8039ee:	00 
  8039ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8039f6:	00 
  8039f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039fe:	e8 fd f2 ff ff       	call   802d00 <ipc_recv>
}
  803a03:	83 c4 14             	add    $0x14,%esp
  803a06:	5b                   	pop    %ebx
  803a07:	5d                   	pop    %ebp
  803a08:	c3                   	ret    

00803a09 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803a09:	55                   	push   %ebp
  803a0a:	89 e5                	mov    %esp,%ebp
  803a0c:	56                   	push   %esi
  803a0d:	53                   	push   %ebx
  803a0e:	83 ec 10             	sub    $0x10,%esp
  803a11:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  803a14:	8b 45 08             	mov    0x8(%ebp),%eax
  803a17:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.accept.req_addrlen = *addrlen;
  803a1c:	8b 06                	mov    (%esi),%eax
  803a1e:	a3 04 c0 80 00       	mov    %eax,0x80c004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803a23:	b8 01 00 00 00       	mov    $0x1,%eax
  803a28:	e8 76 ff ff ff       	call   8039a3 <nsipc>
  803a2d:	89 c3                	mov    %eax,%ebx
  803a2f:	85 c0                	test   %eax,%eax
  803a31:	78 23                	js     803a56 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803a33:	a1 10 c0 80 00       	mov    0x80c010,%eax
  803a38:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a3c:	c7 44 24 04 00 c0 80 	movl   $0x80c000,0x4(%esp)
  803a43:	00 
  803a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a47:	89 04 24             	mov    %eax,(%esp)
  803a4a:	e8 45 ec ff ff       	call   802694 <memmove>
		*addrlen = ret->ret_addrlen;
  803a4f:	a1 10 c0 80 00       	mov    0x80c010,%eax
  803a54:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  803a56:	89 d8                	mov    %ebx,%eax
  803a58:	83 c4 10             	add    $0x10,%esp
  803a5b:	5b                   	pop    %ebx
  803a5c:	5e                   	pop    %esi
  803a5d:	5d                   	pop    %ebp
  803a5e:	c3                   	ret    

00803a5f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803a5f:	55                   	push   %ebp
  803a60:	89 e5                	mov    %esp,%ebp
  803a62:	53                   	push   %ebx
  803a63:	83 ec 14             	sub    $0x14,%esp
  803a66:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803a69:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6c:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803a71:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a78:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a7c:	c7 04 24 04 c0 80 00 	movl   $0x80c004,(%esp)
  803a83:	e8 0c ec ff ff       	call   802694 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803a88:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_BIND);
  803a8e:	b8 02 00 00 00       	mov    $0x2,%eax
  803a93:	e8 0b ff ff ff       	call   8039a3 <nsipc>
}
  803a98:	83 c4 14             	add    $0x14,%esp
  803a9b:	5b                   	pop    %ebx
  803a9c:	5d                   	pop    %ebp
  803a9d:	c3                   	ret    

00803a9e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  803a9e:	55                   	push   %ebp
  803a9f:	89 e5                	mov    %esp,%ebp
  803aa1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa7:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.shutdown.req_how = how;
  803aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aaf:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_SHUTDOWN);
  803ab4:	b8 03 00 00 00       	mov    $0x3,%eax
  803ab9:	e8 e5 fe ff ff       	call   8039a3 <nsipc>
}
  803abe:	c9                   	leave  
  803abf:	c3                   	ret    

00803ac0 <nsipc_close>:

int
nsipc_close(int s)
{
  803ac0:	55                   	push   %ebp
  803ac1:	89 e5                	mov    %esp,%ebp
  803ac3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac9:	a3 00 c0 80 00       	mov    %eax,0x80c000
	return nsipc(NSREQ_CLOSE);
  803ace:	b8 04 00 00 00       	mov    $0x4,%eax
  803ad3:	e8 cb fe ff ff       	call   8039a3 <nsipc>
}
  803ad8:	c9                   	leave  
  803ad9:	c3                   	ret    

00803ada <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803ada:	55                   	push   %ebp
  803adb:	89 e5                	mov    %esp,%ebp
  803add:	53                   	push   %ebx
  803ade:	83 ec 14             	sub    $0x14,%esp
  803ae1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae7:	a3 00 c0 80 00       	mov    %eax,0x80c000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803aec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  803af3:	89 44 24 04          	mov    %eax,0x4(%esp)
  803af7:	c7 04 24 04 c0 80 00 	movl   $0x80c004,(%esp)
  803afe:	e8 91 eb ff ff       	call   802694 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803b03:	89 1d 14 c0 80 00    	mov    %ebx,0x80c014
	return nsipc(NSREQ_CONNECT);
  803b09:	b8 05 00 00 00       	mov    $0x5,%eax
  803b0e:	e8 90 fe ff ff       	call   8039a3 <nsipc>
}
  803b13:	83 c4 14             	add    $0x14,%esp
  803b16:	5b                   	pop    %ebx
  803b17:	5d                   	pop    %ebp
  803b18:	c3                   	ret    

00803b19 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  803b19:	55                   	push   %ebp
  803b1a:	89 e5                	mov    %esp,%ebp
  803b1c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b22:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.listen.req_backlog = backlog;
  803b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b2a:	a3 04 c0 80 00       	mov    %eax,0x80c004
	return nsipc(NSREQ_LISTEN);
  803b2f:	b8 06 00 00 00       	mov    $0x6,%eax
  803b34:	e8 6a fe ff ff       	call   8039a3 <nsipc>
}
  803b39:	c9                   	leave  
  803b3a:	c3                   	ret    

00803b3b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803b3b:	55                   	push   %ebp
  803b3c:	89 e5                	mov    %esp,%ebp
  803b3e:	56                   	push   %esi
  803b3f:	53                   	push   %ebx
  803b40:	83 ec 10             	sub    $0x10,%esp
  803b43:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803b46:	8b 45 08             	mov    0x8(%ebp),%eax
  803b49:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.recv.req_len = len;
  803b4e:	89 35 04 c0 80 00    	mov    %esi,0x80c004
	nsipcbuf.recv.req_flags = flags;
  803b54:	8b 45 14             	mov    0x14(%ebp),%eax
  803b57:	a3 08 c0 80 00       	mov    %eax,0x80c008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803b5c:	b8 07 00 00 00       	mov    $0x7,%eax
  803b61:	e8 3d fe ff ff       	call   8039a3 <nsipc>
  803b66:	89 c3                	mov    %eax,%ebx
  803b68:	85 c0                	test   %eax,%eax
  803b6a:	78 46                	js     803bb2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  803b6c:	39 f0                	cmp    %esi,%eax
  803b6e:	7f 07                	jg     803b77 <nsipc_recv+0x3c>
  803b70:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803b75:	7e 24                	jle    803b9b <nsipc_recv+0x60>
  803b77:	c7 44 24 0c a2 4e 80 	movl   $0x804ea2,0xc(%esp)
  803b7e:	00 
  803b7f:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  803b86:	00 
  803b87:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  803b8e:	00 
  803b8f:	c7 04 24 b7 4e 80 00 	movl   $0x804eb7,(%esp)
  803b96:	e8 38 e2 ff ff       	call   801dd3 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803b9b:	89 44 24 08          	mov    %eax,0x8(%esp)
  803b9f:	c7 44 24 04 00 c0 80 	movl   $0x80c000,0x4(%esp)
  803ba6:	00 
  803ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803baa:	89 04 24             	mov    %eax,(%esp)
  803bad:	e8 e2 ea ff ff       	call   802694 <memmove>
	}

	return r;
}
  803bb2:	89 d8                	mov    %ebx,%eax
  803bb4:	83 c4 10             	add    $0x10,%esp
  803bb7:	5b                   	pop    %ebx
  803bb8:	5e                   	pop    %esi
  803bb9:	5d                   	pop    %ebp
  803bba:	c3                   	ret    

00803bbb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803bbb:	55                   	push   %ebp
  803bbc:	89 e5                	mov    %esp,%ebp
  803bbe:	53                   	push   %ebx
  803bbf:	83 ec 14             	sub    $0x14,%esp
  803bc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  803bc8:	a3 00 c0 80 00       	mov    %eax,0x80c000
	assert(size < 1600);
  803bcd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803bd3:	7e 24                	jle    803bf9 <nsipc_send+0x3e>
  803bd5:	c7 44 24 0c c3 4e 80 	movl   $0x804ec3,0xc(%esp)
  803bdc:	00 
  803bdd:	c7 44 24 08 5d 44 80 	movl   $0x80445d,0x8(%esp)
  803be4:	00 
  803be5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  803bec:	00 
  803bed:	c7 04 24 b7 4e 80 00 	movl   $0x804eb7,(%esp)
  803bf4:	e8 da e1 ff ff       	call   801dd3 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803bf9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c00:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c04:	c7 04 24 0c c0 80 00 	movl   $0x80c00c,(%esp)
  803c0b:	e8 84 ea ff ff       	call   802694 <memmove>
	nsipcbuf.send.req_size = size;
  803c10:	89 1d 04 c0 80 00    	mov    %ebx,0x80c004
	nsipcbuf.send.req_flags = flags;
  803c16:	8b 45 14             	mov    0x14(%ebp),%eax
  803c19:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SEND);
  803c1e:	b8 08 00 00 00       	mov    $0x8,%eax
  803c23:	e8 7b fd ff ff       	call   8039a3 <nsipc>
}
  803c28:	83 c4 14             	add    $0x14,%esp
  803c2b:	5b                   	pop    %ebx
  803c2c:	5d                   	pop    %ebp
  803c2d:	c3                   	ret    

00803c2e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  803c2e:	55                   	push   %ebp
  803c2f:	89 e5                	mov    %esp,%ebp
  803c31:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803c34:	8b 45 08             	mov    0x8(%ebp),%eax
  803c37:	a3 00 c0 80 00       	mov    %eax,0x80c000
	nsipcbuf.socket.req_type = type;
  803c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c3f:	a3 04 c0 80 00       	mov    %eax,0x80c004
	nsipcbuf.socket.req_protocol = protocol;
  803c44:	8b 45 10             	mov    0x10(%ebp),%eax
  803c47:	a3 08 c0 80 00       	mov    %eax,0x80c008
	return nsipc(NSREQ_SOCKET);
  803c4c:	b8 09 00 00 00       	mov    $0x9,%eax
  803c51:	e8 4d fd ff ff       	call   8039a3 <nsipc>
}
  803c56:	c9                   	leave  
  803c57:	c3                   	ret    

00803c58 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803c58:	55                   	push   %ebp
  803c59:	89 e5                	mov    %esp,%ebp
  803c5b:	56                   	push   %esi
  803c5c:	53                   	push   %ebx
  803c5d:	83 ec 10             	sub    $0x10,%esp
  803c60:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803c63:	8b 45 08             	mov    0x8(%ebp),%eax
  803c66:	89 04 24             	mov    %eax,(%esp)
  803c69:	e8 d2 f1 ff ff       	call   802e40 <fd2data>
  803c6e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803c70:	c7 44 24 04 cf 4e 80 	movl   $0x804ecf,0x4(%esp)
  803c77:	00 
  803c78:	89 1c 24             	mov    %ebx,(%esp)
  803c7b:	e8 77 e8 ff ff       	call   8024f7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803c80:	8b 46 04             	mov    0x4(%esi),%eax
  803c83:	2b 06                	sub    (%esi),%eax
  803c85:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  803c8b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803c92:	00 00 00 
	stat->st_dev = &devpipe;
  803c95:	c7 83 88 00 00 00 9c 	movl   $0x80909c,0x88(%ebx)
  803c9c:	90 80 00 
	return 0;
}
  803c9f:	b8 00 00 00 00       	mov    $0x0,%eax
  803ca4:	83 c4 10             	add    $0x10,%esp
  803ca7:	5b                   	pop    %ebx
  803ca8:	5e                   	pop    %esi
  803ca9:	5d                   	pop    %ebp
  803caa:	c3                   	ret    

00803cab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803cab:	55                   	push   %ebp
  803cac:	89 e5                	mov    %esp,%ebp
  803cae:	53                   	push   %ebx
  803caf:	83 ec 14             	sub    $0x14,%esp
  803cb2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803cb5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803cb9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803cc0:	e8 f5 ec ff ff       	call   8029ba <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803cc5:	89 1c 24             	mov    %ebx,(%esp)
  803cc8:	e8 73 f1 ff ff       	call   802e40 <fd2data>
  803ccd:	89 44 24 04          	mov    %eax,0x4(%esp)
  803cd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803cd8:	e8 dd ec ff ff       	call   8029ba <sys_page_unmap>
}
  803cdd:	83 c4 14             	add    $0x14,%esp
  803ce0:	5b                   	pop    %ebx
  803ce1:	5d                   	pop    %ebp
  803ce2:	c3                   	ret    

00803ce3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803ce3:	55                   	push   %ebp
  803ce4:	89 e5                	mov    %esp,%ebp
  803ce6:	57                   	push   %edi
  803ce7:	56                   	push   %esi
  803ce8:	53                   	push   %ebx
  803ce9:	83 ec 2c             	sub    $0x2c,%esp
  803cec:	89 c6                	mov    %eax,%esi
  803cee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  803cf1:	a1 10 a0 80 00       	mov    0x80a010,%eax
  803cf6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803cf9:	89 34 24             	mov    %esi,(%esp)
  803cfc:	e8 09 fa ff ff       	call   80370a <pageref>
  803d01:	89 c7                	mov    %eax,%edi
  803d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d06:	89 04 24             	mov    %eax,(%esp)
  803d09:	e8 fc f9 ff ff       	call   80370a <pageref>
  803d0e:	39 c7                	cmp    %eax,%edi
  803d10:	0f 94 c2             	sete   %dl
  803d13:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  803d16:	8b 0d 10 a0 80 00    	mov    0x80a010,%ecx
  803d1c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  803d1f:	39 fb                	cmp    %edi,%ebx
  803d21:	74 21                	je     803d44 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  803d23:	84 d2                	test   %dl,%dl
  803d25:	74 ca                	je     803cf1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  803d27:	8b 51 58             	mov    0x58(%ecx),%edx
  803d2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803d2e:	89 54 24 08          	mov    %edx,0x8(%esp)
  803d32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803d36:	c7 04 24 d6 4e 80 00 	movl   $0x804ed6,(%esp)
  803d3d:	e8 8a e1 ff ff       	call   801ecc <cprintf>
  803d42:	eb ad                	jmp    803cf1 <_pipeisclosed+0xe>
	}
}
  803d44:	83 c4 2c             	add    $0x2c,%esp
  803d47:	5b                   	pop    %ebx
  803d48:	5e                   	pop    %esi
  803d49:	5f                   	pop    %edi
  803d4a:	5d                   	pop    %ebp
  803d4b:	c3                   	ret    

00803d4c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803d4c:	55                   	push   %ebp
  803d4d:	89 e5                	mov    %esp,%ebp
  803d4f:	57                   	push   %edi
  803d50:	56                   	push   %esi
  803d51:	53                   	push   %ebx
  803d52:	83 ec 1c             	sub    $0x1c,%esp
  803d55:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803d58:	89 34 24             	mov    %esi,(%esp)
  803d5b:	e8 e0 f0 ff ff       	call   802e40 <fd2data>
  803d60:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803d62:	bf 00 00 00 00       	mov    $0x0,%edi
  803d67:	eb 45                	jmp    803dae <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803d69:	89 da                	mov    %ebx,%edx
  803d6b:	89 f0                	mov    %esi,%eax
  803d6d:	e8 71 ff ff ff       	call   803ce3 <_pipeisclosed>
  803d72:	85 c0                	test   %eax,%eax
  803d74:	75 41                	jne    803db7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803d76:	e8 79 eb ff ff       	call   8028f4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803d7b:	8b 43 04             	mov    0x4(%ebx),%eax
  803d7e:	8b 0b                	mov    (%ebx),%ecx
  803d80:	8d 51 20             	lea    0x20(%ecx),%edx
  803d83:	39 d0                	cmp    %edx,%eax
  803d85:	73 e2                	jae    803d69 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803d87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803d8a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  803d8e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803d91:	99                   	cltd   
  803d92:	c1 ea 1b             	shr    $0x1b,%edx
  803d95:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  803d98:	83 e1 1f             	and    $0x1f,%ecx
  803d9b:	29 d1                	sub    %edx,%ecx
  803d9d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  803da1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  803da5:	83 c0 01             	add    $0x1,%eax
  803da8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803dab:	83 c7 01             	add    $0x1,%edi
  803dae:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803db1:	75 c8                	jne    803d7b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803db3:	89 f8                	mov    %edi,%eax
  803db5:	eb 05                	jmp    803dbc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803db7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  803dbc:	83 c4 1c             	add    $0x1c,%esp
  803dbf:	5b                   	pop    %ebx
  803dc0:	5e                   	pop    %esi
  803dc1:	5f                   	pop    %edi
  803dc2:	5d                   	pop    %ebp
  803dc3:	c3                   	ret    

00803dc4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803dc4:	55                   	push   %ebp
  803dc5:	89 e5                	mov    %esp,%ebp
  803dc7:	57                   	push   %edi
  803dc8:	56                   	push   %esi
  803dc9:	53                   	push   %ebx
  803dca:	83 ec 1c             	sub    $0x1c,%esp
  803dcd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803dd0:	89 3c 24             	mov    %edi,(%esp)
  803dd3:	e8 68 f0 ff ff       	call   802e40 <fd2data>
  803dd8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803dda:	be 00 00 00 00       	mov    $0x0,%esi
  803ddf:	eb 3d                	jmp    803e1e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803de1:	85 f6                	test   %esi,%esi
  803de3:	74 04                	je     803de9 <devpipe_read+0x25>
				return i;
  803de5:	89 f0                	mov    %esi,%eax
  803de7:	eb 43                	jmp    803e2c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803de9:	89 da                	mov    %ebx,%edx
  803deb:	89 f8                	mov    %edi,%eax
  803ded:	e8 f1 fe ff ff       	call   803ce3 <_pipeisclosed>
  803df2:	85 c0                	test   %eax,%eax
  803df4:	75 31                	jne    803e27 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803df6:	e8 f9 ea ff ff       	call   8028f4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803dfb:	8b 03                	mov    (%ebx),%eax
  803dfd:	3b 43 04             	cmp    0x4(%ebx),%eax
  803e00:	74 df                	je     803de1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803e02:	99                   	cltd   
  803e03:	c1 ea 1b             	shr    $0x1b,%edx
  803e06:	01 d0                	add    %edx,%eax
  803e08:	83 e0 1f             	and    $0x1f,%eax
  803e0b:	29 d0                	sub    %edx,%eax
  803e0d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803e12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803e15:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  803e18:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e1b:	83 c6 01             	add    $0x1,%esi
  803e1e:	3b 75 10             	cmp    0x10(%ebp),%esi
  803e21:	75 d8                	jne    803dfb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803e23:	89 f0                	mov    %esi,%eax
  803e25:	eb 05                	jmp    803e2c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803e27:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  803e2c:	83 c4 1c             	add    $0x1c,%esp
  803e2f:	5b                   	pop    %ebx
  803e30:	5e                   	pop    %esi
  803e31:	5f                   	pop    %edi
  803e32:	5d                   	pop    %ebp
  803e33:	c3                   	ret    

00803e34 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803e34:	55                   	push   %ebp
  803e35:	89 e5                	mov    %esp,%ebp
  803e37:	56                   	push   %esi
  803e38:	53                   	push   %ebx
  803e39:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803e3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803e3f:	89 04 24             	mov    %eax,(%esp)
  803e42:	e8 10 f0 ff ff       	call   802e57 <fd_alloc>
  803e47:	89 c2                	mov    %eax,%edx
  803e49:	85 d2                	test   %edx,%edx
  803e4b:	0f 88 4d 01 00 00    	js     803f9e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e51:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803e58:	00 
  803e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803e67:	e8 a7 ea ff ff       	call   802913 <sys_page_alloc>
  803e6c:	89 c2                	mov    %eax,%edx
  803e6e:	85 d2                	test   %edx,%edx
  803e70:	0f 88 28 01 00 00    	js     803f9e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803e76:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803e79:	89 04 24             	mov    %eax,(%esp)
  803e7c:	e8 d6 ef ff ff       	call   802e57 <fd_alloc>
  803e81:	89 c3                	mov    %eax,%ebx
  803e83:	85 c0                	test   %eax,%eax
  803e85:	0f 88 fe 00 00 00    	js     803f89 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803e8b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803e92:	00 
  803e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e96:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ea1:	e8 6d ea ff ff       	call   802913 <sys_page_alloc>
  803ea6:	89 c3                	mov    %eax,%ebx
  803ea8:	85 c0                	test   %eax,%eax
  803eaa:	0f 88 d9 00 00 00    	js     803f89 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb3:	89 04 24             	mov    %eax,(%esp)
  803eb6:	e8 85 ef ff ff       	call   802e40 <fd2data>
  803ebb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803ebd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803ec4:	00 
  803ec5:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ec9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ed0:	e8 3e ea ff ff       	call   802913 <sys_page_alloc>
  803ed5:	89 c3                	mov    %eax,%ebx
  803ed7:	85 c0                	test   %eax,%eax
  803ed9:	0f 88 97 00 00 00    	js     803f76 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ee2:	89 04 24             	mov    %eax,(%esp)
  803ee5:	e8 56 ef ff ff       	call   802e40 <fd2data>
  803eea:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803ef1:	00 
  803ef2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803ef6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803efd:	00 
  803efe:	89 74 24 04          	mov    %esi,0x4(%esp)
  803f02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f09:	e8 59 ea ff ff       	call   802967 <sys_page_map>
  803f0e:	89 c3                	mov    %eax,%ebx
  803f10:	85 c0                	test   %eax,%eax
  803f12:	78 52                	js     803f66 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803f14:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f1d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  803f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  803f29:	8b 15 9c 90 80 00    	mov    0x80909c,%edx
  803f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f32:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f37:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f41:	89 04 24             	mov    %eax,(%esp)
  803f44:	e8 e7 ee ff ff       	call   802e30 <fd2num>
  803f49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803f4c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f51:	89 04 24             	mov    %eax,(%esp)
  803f54:	e8 d7 ee ff ff       	call   802e30 <fd2num>
  803f59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803f5c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803f5f:	b8 00 00 00 00       	mov    $0x0,%eax
  803f64:	eb 38                	jmp    803f9e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  803f66:	89 74 24 04          	mov    %esi,0x4(%esp)
  803f6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f71:	e8 44 ea ff ff       	call   8029ba <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  803f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f79:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f7d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f84:	e8 31 ea ff ff       	call   8029ba <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  803f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f97:	e8 1e ea ff ff       	call   8029ba <sys_page_unmap>
  803f9c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  803f9e:	83 c4 30             	add    $0x30,%esp
  803fa1:	5b                   	pop    %ebx
  803fa2:	5e                   	pop    %esi
  803fa3:	5d                   	pop    %ebp
  803fa4:	c3                   	ret    

00803fa5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  803fa5:	55                   	push   %ebp
  803fa6:	89 e5                	mov    %esp,%ebp
  803fa8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803fab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803fae:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  803fb5:	89 04 24             	mov    %eax,(%esp)
  803fb8:	e8 e9 ee ff ff       	call   802ea6 <fd_lookup>
  803fbd:	89 c2                	mov    %eax,%edx
  803fbf:	85 d2                	test   %edx,%edx
  803fc1:	78 15                	js     803fd8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc6:	89 04 24             	mov    %eax,(%esp)
  803fc9:	e8 72 ee ff ff       	call   802e40 <fd2data>
	return _pipeisclosed(fd, p);
  803fce:	89 c2                	mov    %eax,%edx
  803fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fd3:	e8 0b fd ff ff       	call   803ce3 <_pipeisclosed>
}
  803fd8:	c9                   	leave  
  803fd9:	c3                   	ret    
  803fda:	66 90                	xchg   %ax,%ax
  803fdc:	66 90                	xchg   %ax,%ax
  803fde:	66 90                	xchg   %ax,%ax

00803fe0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803fe0:	55                   	push   %ebp
  803fe1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  803fe8:	5d                   	pop    %ebp
  803fe9:	c3                   	ret    

00803fea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803fea:	55                   	push   %ebp
  803feb:	89 e5                	mov    %esp,%ebp
  803fed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803ff0:	c7 44 24 04 ee 4e 80 	movl   $0x804eee,0x4(%esp)
  803ff7:	00 
  803ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ffb:	89 04 24             	mov    %eax,(%esp)
  803ffe:	e8 f4 e4 ff ff       	call   8024f7 <strcpy>
	return 0;
}
  804003:	b8 00 00 00 00       	mov    $0x0,%eax
  804008:	c9                   	leave  
  804009:	c3                   	ret    

0080400a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80400a:	55                   	push   %ebp
  80400b:	89 e5                	mov    %esp,%ebp
  80400d:	57                   	push   %edi
  80400e:	56                   	push   %esi
  80400f:	53                   	push   %ebx
  804010:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804016:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80401b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804021:	eb 31                	jmp    804054 <devcons_write+0x4a>
		m = n - tot;
  804023:	8b 75 10             	mov    0x10(%ebp),%esi
  804026:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  804028:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80402b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  804030:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  804033:	89 74 24 08          	mov    %esi,0x8(%esp)
  804037:	03 45 0c             	add    0xc(%ebp),%eax
  80403a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80403e:	89 3c 24             	mov    %edi,(%esp)
  804041:	e8 4e e6 ff ff       	call   802694 <memmove>
		sys_cputs(buf, m);
  804046:	89 74 24 04          	mov    %esi,0x4(%esp)
  80404a:	89 3c 24             	mov    %edi,(%esp)
  80404d:	e8 f4 e7 ff ff       	call   802846 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  804052:	01 f3                	add    %esi,%ebx
  804054:	89 d8                	mov    %ebx,%eax
  804056:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  804059:	72 c8                	jb     804023 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80405b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  804061:	5b                   	pop    %ebx
  804062:	5e                   	pop    %esi
  804063:	5f                   	pop    %edi
  804064:	5d                   	pop    %ebp
  804065:	c3                   	ret    

00804066 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804066:	55                   	push   %ebp
  804067:	89 e5                	mov    %esp,%ebp
  804069:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80406c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  804071:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  804075:	75 07                	jne    80407e <devcons_read+0x18>
  804077:	eb 2a                	jmp    8040a3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804079:	e8 76 e8 ff ff       	call   8028f4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80407e:	66 90                	xchg   %ax,%ax
  804080:	e8 df e7 ff ff       	call   802864 <sys_cgetc>
  804085:	85 c0                	test   %eax,%eax
  804087:	74 f0                	je     804079 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  804089:	85 c0                	test   %eax,%eax
  80408b:	78 16                	js     8040a3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80408d:	83 f8 04             	cmp    $0x4,%eax
  804090:	74 0c                	je     80409e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  804092:	8b 55 0c             	mov    0xc(%ebp),%edx
  804095:	88 02                	mov    %al,(%edx)
	return 1;
  804097:	b8 01 00 00 00       	mov    $0x1,%eax
  80409c:	eb 05                	jmp    8040a3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80409e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8040a3:	c9                   	leave  
  8040a4:	c3                   	ret    

008040a5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8040a5:	55                   	push   %ebp
  8040a6:	89 e5                	mov    %esp,%ebp
  8040a8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8040ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ae:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8040b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8040b8:	00 
  8040b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8040bc:	89 04 24             	mov    %eax,(%esp)
  8040bf:	e8 82 e7 ff ff       	call   802846 <sys_cputs>
}
  8040c4:	c9                   	leave  
  8040c5:	c3                   	ret    

008040c6 <getchar>:

int
getchar(void)
{
  8040c6:	55                   	push   %ebp
  8040c7:	89 e5                	mov    %esp,%ebp
  8040c9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8040cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8040d3:	00 
  8040d4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8040d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8040db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8040e2:	e8 53 f0 ff ff       	call   80313a <read>
	if (r < 0)
  8040e7:	85 c0                	test   %eax,%eax
  8040e9:	78 0f                	js     8040fa <getchar+0x34>
		return r;
	if (r < 1)
  8040eb:	85 c0                	test   %eax,%eax
  8040ed:	7e 06                	jle    8040f5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8040ef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8040f3:	eb 05                	jmp    8040fa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8040f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8040fa:	c9                   	leave  
  8040fb:	c3                   	ret    

008040fc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8040fc:	55                   	push   %ebp
  8040fd:	89 e5                	mov    %esp,%ebp
  8040ff:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  804102:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804105:	89 44 24 04          	mov    %eax,0x4(%esp)
  804109:	8b 45 08             	mov    0x8(%ebp),%eax
  80410c:	89 04 24             	mov    %eax,(%esp)
  80410f:	e8 92 ed ff ff       	call   802ea6 <fd_lookup>
  804114:	85 c0                	test   %eax,%eax
  804116:	78 11                	js     804129 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  804118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80411b:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  804121:	39 10                	cmp    %edx,(%eax)
  804123:	0f 94 c0             	sete   %al
  804126:	0f b6 c0             	movzbl %al,%eax
}
  804129:	c9                   	leave  
  80412a:	c3                   	ret    

0080412b <opencons>:

int
opencons(void)
{
  80412b:	55                   	push   %ebp
  80412c:	89 e5                	mov    %esp,%ebp
  80412e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804131:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804134:	89 04 24             	mov    %eax,(%esp)
  804137:	e8 1b ed ff ff       	call   802e57 <fd_alloc>
		return r;
  80413c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80413e:	85 c0                	test   %eax,%eax
  804140:	78 40                	js     804182 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804142:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804149:	00 
  80414a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80414d:	89 44 24 04          	mov    %eax,0x4(%esp)
  804151:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804158:	e8 b6 e7 ff ff       	call   802913 <sys_page_alloc>
		return r;
  80415d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80415f:	85 c0                	test   %eax,%eax
  804161:	78 1f                	js     804182 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  804163:	8b 15 b8 90 80 00    	mov    0x8090b8,%edx
  804169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80416c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80416e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804171:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  804178:	89 04 24             	mov    %eax,(%esp)
  80417b:	e8 b0 ec ff ff       	call   802e30 <fd2num>
  804180:	89 c2                	mov    %eax,%edx
}
  804182:	89 d0                	mov    %edx,%eax
  804184:	c9                   	leave  
  804185:	c3                   	ret    
  804186:	66 90                	xchg   %ax,%ax
  804188:	66 90                	xchg   %ax,%ax
  80418a:	66 90                	xchg   %ax,%ax
  80418c:	66 90                	xchg   %ax,%ax
  80418e:	66 90                	xchg   %ax,%ax

00804190 <__udivdi3>:
  804190:	55                   	push   %ebp
  804191:	57                   	push   %edi
  804192:	56                   	push   %esi
  804193:	83 ec 0c             	sub    $0xc,%esp
  804196:	8b 44 24 28          	mov    0x28(%esp),%eax
  80419a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80419e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8041a2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8041a6:	85 c0                	test   %eax,%eax
  8041a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8041ac:	89 ea                	mov    %ebp,%edx
  8041ae:	89 0c 24             	mov    %ecx,(%esp)
  8041b1:	75 2d                	jne    8041e0 <__udivdi3+0x50>
  8041b3:	39 e9                	cmp    %ebp,%ecx
  8041b5:	77 61                	ja     804218 <__udivdi3+0x88>
  8041b7:	85 c9                	test   %ecx,%ecx
  8041b9:	89 ce                	mov    %ecx,%esi
  8041bb:	75 0b                	jne    8041c8 <__udivdi3+0x38>
  8041bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8041c2:	31 d2                	xor    %edx,%edx
  8041c4:	f7 f1                	div    %ecx
  8041c6:	89 c6                	mov    %eax,%esi
  8041c8:	31 d2                	xor    %edx,%edx
  8041ca:	89 e8                	mov    %ebp,%eax
  8041cc:	f7 f6                	div    %esi
  8041ce:	89 c5                	mov    %eax,%ebp
  8041d0:	89 f8                	mov    %edi,%eax
  8041d2:	f7 f6                	div    %esi
  8041d4:	89 ea                	mov    %ebp,%edx
  8041d6:	83 c4 0c             	add    $0xc,%esp
  8041d9:	5e                   	pop    %esi
  8041da:	5f                   	pop    %edi
  8041db:	5d                   	pop    %ebp
  8041dc:	c3                   	ret    
  8041dd:	8d 76 00             	lea    0x0(%esi),%esi
  8041e0:	39 e8                	cmp    %ebp,%eax
  8041e2:	77 24                	ja     804208 <__udivdi3+0x78>
  8041e4:	0f bd e8             	bsr    %eax,%ebp
  8041e7:	83 f5 1f             	xor    $0x1f,%ebp
  8041ea:	75 3c                	jne    804228 <__udivdi3+0x98>
  8041ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8041f0:	39 34 24             	cmp    %esi,(%esp)
  8041f3:	0f 86 9f 00 00 00    	jbe    804298 <__udivdi3+0x108>
  8041f9:	39 d0                	cmp    %edx,%eax
  8041fb:	0f 82 97 00 00 00    	jb     804298 <__udivdi3+0x108>
  804201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  804208:	31 d2                	xor    %edx,%edx
  80420a:	31 c0                	xor    %eax,%eax
  80420c:	83 c4 0c             	add    $0xc,%esp
  80420f:	5e                   	pop    %esi
  804210:	5f                   	pop    %edi
  804211:	5d                   	pop    %ebp
  804212:	c3                   	ret    
  804213:	90                   	nop
  804214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804218:	89 f8                	mov    %edi,%eax
  80421a:	f7 f1                	div    %ecx
  80421c:	31 d2                	xor    %edx,%edx
  80421e:	83 c4 0c             	add    $0xc,%esp
  804221:	5e                   	pop    %esi
  804222:	5f                   	pop    %edi
  804223:	5d                   	pop    %ebp
  804224:	c3                   	ret    
  804225:	8d 76 00             	lea    0x0(%esi),%esi
  804228:	89 e9                	mov    %ebp,%ecx
  80422a:	8b 3c 24             	mov    (%esp),%edi
  80422d:	d3 e0                	shl    %cl,%eax
  80422f:	89 c6                	mov    %eax,%esi
  804231:	b8 20 00 00 00       	mov    $0x20,%eax
  804236:	29 e8                	sub    %ebp,%eax
  804238:	89 c1                	mov    %eax,%ecx
  80423a:	d3 ef                	shr    %cl,%edi
  80423c:	89 e9                	mov    %ebp,%ecx
  80423e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  804242:	8b 3c 24             	mov    (%esp),%edi
  804245:	09 74 24 08          	or     %esi,0x8(%esp)
  804249:	89 d6                	mov    %edx,%esi
  80424b:	d3 e7                	shl    %cl,%edi
  80424d:	89 c1                	mov    %eax,%ecx
  80424f:	89 3c 24             	mov    %edi,(%esp)
  804252:	8b 7c 24 04          	mov    0x4(%esp),%edi
  804256:	d3 ee                	shr    %cl,%esi
  804258:	89 e9                	mov    %ebp,%ecx
  80425a:	d3 e2                	shl    %cl,%edx
  80425c:	89 c1                	mov    %eax,%ecx
  80425e:	d3 ef                	shr    %cl,%edi
  804260:	09 d7                	or     %edx,%edi
  804262:	89 f2                	mov    %esi,%edx
  804264:	89 f8                	mov    %edi,%eax
  804266:	f7 74 24 08          	divl   0x8(%esp)
  80426a:	89 d6                	mov    %edx,%esi
  80426c:	89 c7                	mov    %eax,%edi
  80426e:	f7 24 24             	mull   (%esp)
  804271:	39 d6                	cmp    %edx,%esi
  804273:	89 14 24             	mov    %edx,(%esp)
  804276:	72 30                	jb     8042a8 <__udivdi3+0x118>
  804278:	8b 54 24 04          	mov    0x4(%esp),%edx
  80427c:	89 e9                	mov    %ebp,%ecx
  80427e:	d3 e2                	shl    %cl,%edx
  804280:	39 c2                	cmp    %eax,%edx
  804282:	73 05                	jae    804289 <__udivdi3+0xf9>
  804284:	3b 34 24             	cmp    (%esp),%esi
  804287:	74 1f                	je     8042a8 <__udivdi3+0x118>
  804289:	89 f8                	mov    %edi,%eax
  80428b:	31 d2                	xor    %edx,%edx
  80428d:	e9 7a ff ff ff       	jmp    80420c <__udivdi3+0x7c>
  804292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804298:	31 d2                	xor    %edx,%edx
  80429a:	b8 01 00 00 00       	mov    $0x1,%eax
  80429f:	e9 68 ff ff ff       	jmp    80420c <__udivdi3+0x7c>
  8042a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8042a8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8042ab:	31 d2                	xor    %edx,%edx
  8042ad:	83 c4 0c             	add    $0xc,%esp
  8042b0:	5e                   	pop    %esi
  8042b1:	5f                   	pop    %edi
  8042b2:	5d                   	pop    %ebp
  8042b3:	c3                   	ret    
  8042b4:	66 90                	xchg   %ax,%ax
  8042b6:	66 90                	xchg   %ax,%ax
  8042b8:	66 90                	xchg   %ax,%ax
  8042ba:	66 90                	xchg   %ax,%ax
  8042bc:	66 90                	xchg   %ax,%ax
  8042be:	66 90                	xchg   %ax,%ax

008042c0 <__umoddi3>:
  8042c0:	55                   	push   %ebp
  8042c1:	57                   	push   %edi
  8042c2:	56                   	push   %esi
  8042c3:	83 ec 14             	sub    $0x14,%esp
  8042c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8042ca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8042ce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8042d2:	89 c7                	mov    %eax,%edi
  8042d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042d8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8042dc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8042e0:	89 34 24             	mov    %esi,(%esp)
  8042e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8042e7:	85 c0                	test   %eax,%eax
  8042e9:	89 c2                	mov    %eax,%edx
  8042eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8042ef:	75 17                	jne    804308 <__umoddi3+0x48>
  8042f1:	39 fe                	cmp    %edi,%esi
  8042f3:	76 4b                	jbe    804340 <__umoddi3+0x80>
  8042f5:	89 c8                	mov    %ecx,%eax
  8042f7:	89 fa                	mov    %edi,%edx
  8042f9:	f7 f6                	div    %esi
  8042fb:	89 d0                	mov    %edx,%eax
  8042fd:	31 d2                	xor    %edx,%edx
  8042ff:	83 c4 14             	add    $0x14,%esp
  804302:	5e                   	pop    %esi
  804303:	5f                   	pop    %edi
  804304:	5d                   	pop    %ebp
  804305:	c3                   	ret    
  804306:	66 90                	xchg   %ax,%ax
  804308:	39 f8                	cmp    %edi,%eax
  80430a:	77 54                	ja     804360 <__umoddi3+0xa0>
  80430c:	0f bd e8             	bsr    %eax,%ebp
  80430f:	83 f5 1f             	xor    $0x1f,%ebp
  804312:	75 5c                	jne    804370 <__umoddi3+0xb0>
  804314:	8b 7c 24 08          	mov    0x8(%esp),%edi
  804318:	39 3c 24             	cmp    %edi,(%esp)
  80431b:	0f 87 e7 00 00 00    	ja     804408 <__umoddi3+0x148>
  804321:	8b 7c 24 04          	mov    0x4(%esp),%edi
  804325:	29 f1                	sub    %esi,%ecx
  804327:	19 c7                	sbb    %eax,%edi
  804329:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80432d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804331:	8b 44 24 08          	mov    0x8(%esp),%eax
  804335:	8b 54 24 0c          	mov    0xc(%esp),%edx
  804339:	83 c4 14             	add    $0x14,%esp
  80433c:	5e                   	pop    %esi
  80433d:	5f                   	pop    %edi
  80433e:	5d                   	pop    %ebp
  80433f:	c3                   	ret    
  804340:	85 f6                	test   %esi,%esi
  804342:	89 f5                	mov    %esi,%ebp
  804344:	75 0b                	jne    804351 <__umoddi3+0x91>
  804346:	b8 01 00 00 00       	mov    $0x1,%eax
  80434b:	31 d2                	xor    %edx,%edx
  80434d:	f7 f6                	div    %esi
  80434f:	89 c5                	mov    %eax,%ebp
  804351:	8b 44 24 04          	mov    0x4(%esp),%eax
  804355:	31 d2                	xor    %edx,%edx
  804357:	f7 f5                	div    %ebp
  804359:	89 c8                	mov    %ecx,%eax
  80435b:	f7 f5                	div    %ebp
  80435d:	eb 9c                	jmp    8042fb <__umoddi3+0x3b>
  80435f:	90                   	nop
  804360:	89 c8                	mov    %ecx,%eax
  804362:	89 fa                	mov    %edi,%edx
  804364:	83 c4 14             	add    $0x14,%esp
  804367:	5e                   	pop    %esi
  804368:	5f                   	pop    %edi
  804369:	5d                   	pop    %ebp
  80436a:	c3                   	ret    
  80436b:	90                   	nop
  80436c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804370:	8b 04 24             	mov    (%esp),%eax
  804373:	be 20 00 00 00       	mov    $0x20,%esi
  804378:	89 e9                	mov    %ebp,%ecx
  80437a:	29 ee                	sub    %ebp,%esi
  80437c:	d3 e2                	shl    %cl,%edx
  80437e:	89 f1                	mov    %esi,%ecx
  804380:	d3 e8                	shr    %cl,%eax
  804382:	89 e9                	mov    %ebp,%ecx
  804384:	89 44 24 04          	mov    %eax,0x4(%esp)
  804388:	8b 04 24             	mov    (%esp),%eax
  80438b:	09 54 24 04          	or     %edx,0x4(%esp)
  80438f:	89 fa                	mov    %edi,%edx
  804391:	d3 e0                	shl    %cl,%eax
  804393:	89 f1                	mov    %esi,%ecx
  804395:	89 44 24 08          	mov    %eax,0x8(%esp)
  804399:	8b 44 24 10          	mov    0x10(%esp),%eax
  80439d:	d3 ea                	shr    %cl,%edx
  80439f:	89 e9                	mov    %ebp,%ecx
  8043a1:	d3 e7                	shl    %cl,%edi
  8043a3:	89 f1                	mov    %esi,%ecx
  8043a5:	d3 e8                	shr    %cl,%eax
  8043a7:	89 e9                	mov    %ebp,%ecx
  8043a9:	09 f8                	or     %edi,%eax
  8043ab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8043af:	f7 74 24 04          	divl   0x4(%esp)
  8043b3:	d3 e7                	shl    %cl,%edi
  8043b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8043b9:	89 d7                	mov    %edx,%edi
  8043bb:	f7 64 24 08          	mull   0x8(%esp)
  8043bf:	39 d7                	cmp    %edx,%edi
  8043c1:	89 c1                	mov    %eax,%ecx
  8043c3:	89 14 24             	mov    %edx,(%esp)
  8043c6:	72 2c                	jb     8043f4 <__umoddi3+0x134>
  8043c8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8043cc:	72 22                	jb     8043f0 <__umoddi3+0x130>
  8043ce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8043d2:	29 c8                	sub    %ecx,%eax
  8043d4:	19 d7                	sbb    %edx,%edi
  8043d6:	89 e9                	mov    %ebp,%ecx
  8043d8:	89 fa                	mov    %edi,%edx
  8043da:	d3 e8                	shr    %cl,%eax
  8043dc:	89 f1                	mov    %esi,%ecx
  8043de:	d3 e2                	shl    %cl,%edx
  8043e0:	89 e9                	mov    %ebp,%ecx
  8043e2:	d3 ef                	shr    %cl,%edi
  8043e4:	09 d0                	or     %edx,%eax
  8043e6:	89 fa                	mov    %edi,%edx
  8043e8:	83 c4 14             	add    $0x14,%esp
  8043eb:	5e                   	pop    %esi
  8043ec:	5f                   	pop    %edi
  8043ed:	5d                   	pop    %ebp
  8043ee:	c3                   	ret    
  8043ef:	90                   	nop
  8043f0:	39 d7                	cmp    %edx,%edi
  8043f2:	75 da                	jne    8043ce <__umoddi3+0x10e>
  8043f4:	8b 14 24             	mov    (%esp),%edx
  8043f7:	89 c1                	mov    %eax,%ecx
  8043f9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8043fd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  804401:	eb cb                	jmp    8043ce <__umoddi3+0x10e>
  804403:	90                   	nop
  804404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804408:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80440c:	0f 82 0f ff ff ff    	jb     804321 <__umoddi3+0x61>
  804412:	e9 1a ff ff ff       	jmp    804331 <__umoddi3+0x71>
