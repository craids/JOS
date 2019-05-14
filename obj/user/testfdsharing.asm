
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 e8 01 00 00       	call   800219 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800043:	00 
  800044:	c7 04 24 20 2d 80 00 	movl   $0x802d20,(%esp)
  80004b:	e8 ef 1c 00 00       	call   801d3f <open>
  800050:	89 c3                	mov    %eax,%ebx
  800052:	85 c0                	test   %eax,%eax
  800054:	79 20                	jns    800076 <umain+0x43>
		panic("open motd: %e", fd);
  800056:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005a:	c7 44 24 08 25 2d 80 	movl   $0x802d25,0x8(%esp)
  800061:	00 
  800062:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  800069:	00 
  80006a:	c7 04 24 33 2d 80 00 	movl   $0x802d33,(%esp)
  800071:	e8 04 02 00 00       	call   80027a <_panic>
	seek(fd, 0);
  800076:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007d:	00 
  80007e:	89 04 24             	mov    %eax,(%esp)
  800081:	e8 ee 18 00 00       	call   801974 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800086:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 20 52 80 	movl   $0x805220,0x4(%esp)
  800095:	00 
  800096:	89 1c 24             	mov    %ebx,(%esp)
  800099:	e8 fe 17 00 00       	call   80189c <readn>
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	85 c0                	test   %eax,%eax
  8000a2:	7f 20                	jg     8000c4 <umain+0x91>
		panic("readn: %e", n);
  8000a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a8:	c7 44 24 08 48 2d 80 	movl   $0x802d48,0x8(%esp)
  8000af:	00 
  8000b0:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000b7:	00 
  8000b8:	c7 04 24 33 2d 80 00 	movl   $0x802d33,(%esp)
  8000bf:	e8 b6 01 00 00       	call   80027a <_panic>

	if ((r = fork()) < 0)
  8000c4:	e8 37 11 00 00       	call   801200 <fork>
  8000c9:	89 c6                	mov    %eax,%esi
  8000cb:	85 c0                	test   %eax,%eax
  8000cd:	79 20                	jns    8000ef <umain+0xbc>
		panic("fork: %e", r);
  8000cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000d3:	c7 44 24 08 52 2d 80 	movl   $0x802d52,0x8(%esp)
  8000da:	00 
  8000db:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8000e2:	00 
  8000e3:	c7 04 24 33 2d 80 00 	movl   $0x802d33,(%esp)
  8000ea:	e8 8b 01 00 00       	call   80027a <_panic>
	if (r == 0) {
  8000ef:	85 c0                	test   %eax,%eax
  8000f1:	0f 85 bd 00 00 00    	jne    8001b4 <umain+0x181>
		seek(fd, 0);
  8000f7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000fe:	00 
  8000ff:	89 1c 24             	mov    %ebx,(%esp)
  800102:	e8 6d 18 00 00       	call   801974 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  800107:	c7 04 24 90 2d 80 00 	movl   $0x802d90,(%esp)
  80010e:	e8 60 02 00 00       	call   800373 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800113:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80011a:	00 
  80011b:	c7 44 24 04 20 50 80 	movl   $0x805020,0x4(%esp)
  800122:	00 
  800123:	89 1c 24             	mov    %ebx,(%esp)
  800126:	e8 71 17 00 00       	call   80189c <readn>
  80012b:	39 f8                	cmp    %edi,%eax
  80012d:	74 24                	je     800153 <umain+0x120>
			panic("read in parent got %d, read in child got %d", n, n2);
  80012f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800133:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800137:	c7 44 24 08 d4 2d 80 	movl   $0x802dd4,0x8(%esp)
  80013e:	00 
  80013f:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  800146:	00 
  800147:	c7 04 24 33 2d 80 00 	movl   $0x802d33,(%esp)
  80014e:	e8 27 01 00 00       	call   80027a <_panic>
		if (memcmp(buf, buf2, n) != 0)
  800153:	89 44 24 08          	mov    %eax,0x8(%esp)
  800157:	c7 44 24 04 20 50 80 	movl   $0x805020,0x4(%esp)
  80015e:	00 
  80015f:	c7 04 24 20 52 80 00 	movl   $0x805220,(%esp)
  800166:	e8 52 0a 00 00       	call   800bbd <memcmp>
  80016b:	85 c0                	test   %eax,%eax
  80016d:	74 1c                	je     80018b <umain+0x158>
			panic("read in parent got different bytes from read in child");
  80016f:	c7 44 24 08 00 2e 80 	movl   $0x802e00,0x8(%esp)
  800176:	00 
  800177:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80017e:	00 
  80017f:	c7 04 24 33 2d 80 00 	movl   $0x802d33,(%esp)
  800186:	e8 ef 00 00 00       	call   80027a <_panic>
		cprintf("read in child succeeded\n");
  80018b:	c7 04 24 5b 2d 80 00 	movl   $0x802d5b,(%esp)
  800192:	e8 dc 01 00 00       	call   800373 <cprintf>
		seek(fd, 0);
  800197:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80019e:	00 
  80019f:	89 1c 24             	mov    %ebx,(%esp)
  8001a2:	e8 cd 17 00 00       	call   801974 <seek>
		close(fd);
  8001a7:	89 1c 24             	mov    %ebx,(%esp)
  8001aa:	e8 f8 14 00 00       	call   8016a7 <close>
		exit();
  8001af:	e8 ad 00 00 00       	call   800261 <exit>
	}
	wait(r);
  8001b4:	89 34 24             	mov    %esi,(%esp)
  8001b7:	e8 ae 24 00 00       	call   80266a <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8001bc:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8001c3:	00 
  8001c4:	c7 44 24 04 20 50 80 	movl   $0x805020,0x4(%esp)
  8001cb:	00 
  8001cc:	89 1c 24             	mov    %ebx,(%esp)
  8001cf:	e8 c8 16 00 00       	call   80189c <readn>
  8001d4:	39 f8                	cmp    %edi,%eax
  8001d6:	74 24                	je     8001fc <umain+0x1c9>
		panic("read in parent got %d, then got %d", n, n2);
  8001d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001dc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001e0:	c7 44 24 08 38 2e 80 	movl   $0x802e38,0x8(%esp)
  8001e7:	00 
  8001e8:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8001ef:	00 
  8001f0:	c7 04 24 33 2d 80 00 	movl   $0x802d33,(%esp)
  8001f7:	e8 7e 00 00 00       	call   80027a <_panic>
	cprintf("read in parent succeeded\n");
  8001fc:	c7 04 24 74 2d 80 00 	movl   $0x802d74,(%esp)
  800203:	e8 6b 01 00 00       	call   800373 <cprintf>
	close(fd);
  800208:	89 1c 24             	mov    %ebx,(%esp)
  80020b:	e8 97 14 00 00       	call   8016a7 <close>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800210:	cc                   	int3   

	breakpoint();
}
  800211:	83 c4 2c             	add    $0x2c,%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5f                   	pop    %edi
  800217:	5d                   	pop    %ebp
  800218:	c3                   	ret    

00800219 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	56                   	push   %esi
  80021d:	53                   	push   %ebx
  80021e:	83 ec 10             	sub    $0x10,%esp
  800221:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800224:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800227:	e8 49 0b 00 00       	call   800d75 <sys_getenvid>
  80022c:	25 ff 03 00 00       	and    $0x3ff,%eax
  800231:	c1 e0 07             	shl    $0x7,%eax
  800234:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800239:	a3 20 54 80 00       	mov    %eax,0x805420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023e:	85 db                	test   %ebx,%ebx
  800240:	7e 07                	jle    800249 <libmain+0x30>
		binaryname = argv[0];
  800242:	8b 06                	mov    (%esi),%eax
  800244:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800249:	89 74 24 04          	mov    %esi,0x4(%esp)
  80024d:	89 1c 24             	mov    %ebx,(%esp)
  800250:	e8 de fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800255:	e8 07 00 00 00       	call   800261 <exit>
}
  80025a:	83 c4 10             	add    $0x10,%esp
  80025d:	5b                   	pop    %ebx
  80025e:	5e                   	pop    %esi
  80025f:	5d                   	pop    %ebp
  800260:	c3                   	ret    

00800261 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800267:	e8 6e 14 00 00       	call   8016da <close_all>
	sys_env_destroy(0);
  80026c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800273:	e8 ab 0a 00 00       	call   800d23 <sys_env_destroy>
}
  800278:	c9                   	leave  
  800279:	c3                   	ret    

0080027a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	56                   	push   %esi
  80027e:	53                   	push   %ebx
  80027f:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800282:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800285:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80028b:	e8 e5 0a 00 00       	call   800d75 <sys_getenvid>
  800290:	8b 55 0c             	mov    0xc(%ebp),%edx
  800293:	89 54 24 10          	mov    %edx,0x10(%esp)
  800297:	8b 55 08             	mov    0x8(%ebp),%edx
  80029a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80029e:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a6:	c7 04 24 68 2e 80 00 	movl   $0x802e68,(%esp)
  8002ad:	e8 c1 00 00 00       	call   800373 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	89 04 24             	mov    %eax,(%esp)
  8002bc:	e8 51 00 00 00       	call   800312 <vcprintf>
	cprintf("\n");
  8002c1:	c7 04 24 72 2d 80 00 	movl   $0x802d72,(%esp)
  8002c8:	e8 a6 00 00 00       	call   800373 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002cd:	cc                   	int3   
  8002ce:	eb fd                	jmp    8002cd <_panic+0x53>

008002d0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	53                   	push   %ebx
  8002d4:	83 ec 14             	sub    $0x14,%esp
  8002d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002da:	8b 13                	mov    (%ebx),%edx
  8002dc:	8d 42 01             	lea    0x1(%edx),%eax
  8002df:	89 03                	mov    %eax,(%ebx)
  8002e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002e8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ed:	75 19                	jne    800308 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002ef:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002f6:	00 
  8002f7:	8d 43 08             	lea    0x8(%ebx),%eax
  8002fa:	89 04 24             	mov    %eax,(%esp)
  8002fd:	e8 e4 09 00 00       	call   800ce6 <sys_cputs>
		b->idx = 0;
  800302:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800308:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80030c:	83 c4 14             	add    $0x14,%esp
  80030f:	5b                   	pop    %ebx
  800310:	5d                   	pop    %ebp
  800311:	c3                   	ret    

00800312 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80031b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800322:	00 00 00 
	b.cnt = 0;
  800325:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800336:	8b 45 08             	mov    0x8(%ebp),%eax
  800339:	89 44 24 08          	mov    %eax,0x8(%esp)
  80033d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800343:	89 44 24 04          	mov    %eax,0x4(%esp)
  800347:	c7 04 24 d0 02 80 00 	movl   $0x8002d0,(%esp)
  80034e:	e8 ab 01 00 00       	call   8004fe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800353:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800359:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800363:	89 04 24             	mov    %eax,(%esp)
  800366:	e8 7b 09 00 00       	call   800ce6 <sys_cputs>

	return b.cnt;
}
  80036b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800371:	c9                   	leave  
  800372:	c3                   	ret    

00800373 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800379:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80037c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800380:	8b 45 08             	mov    0x8(%ebp),%eax
  800383:	89 04 24             	mov    %eax,(%esp)
  800386:	e8 87 ff ff ff       	call   800312 <vcprintf>
	va_end(ap);

	return cnt;
}
  80038b:	c9                   	leave  
  80038c:	c3                   	ret    
  80038d:	66 90                	xchg   %ax,%ax
  80038f:	90                   	nop

00800390 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	57                   	push   %edi
  800394:	56                   	push   %esi
  800395:	53                   	push   %ebx
  800396:	83 ec 3c             	sub    $0x3c,%esp
  800399:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80039c:	89 d7                	mov    %edx,%edi
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a7:	89 c3                	mov    %eax,%ebx
  8003a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8003af:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003bd:	39 d9                	cmp    %ebx,%ecx
  8003bf:	72 05                	jb     8003c6 <printnum+0x36>
  8003c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003c4:	77 69                	ja     80042f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003c9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8003cd:	83 ee 01             	sub    $0x1,%esi
  8003d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003dc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003e0:	89 c3                	mov    %eax,%ebx
  8003e2:	89 d6                	mov    %edx,%esi
  8003e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8003f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f5:	89 04 24             	mov    %eax,(%esp)
  8003f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ff:	e8 8c 26 00 00       	call   802a90 <__udivdi3>
  800404:	89 d9                	mov    %ebx,%ecx
  800406:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80040a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80040e:	89 04 24             	mov    %eax,(%esp)
  800411:	89 54 24 04          	mov    %edx,0x4(%esp)
  800415:	89 fa                	mov    %edi,%edx
  800417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041a:	e8 71 ff ff ff       	call   800390 <printnum>
  80041f:	eb 1b                	jmp    80043c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800421:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800425:	8b 45 18             	mov    0x18(%ebp),%eax
  800428:	89 04 24             	mov    %eax,(%esp)
  80042b:	ff d3                	call   *%ebx
  80042d:	eb 03                	jmp    800432 <printnum+0xa2>
  80042f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800432:	83 ee 01             	sub    $0x1,%esi
  800435:	85 f6                	test   %esi,%esi
  800437:	7f e8                	jg     800421 <printnum+0x91>
  800439:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80043c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800440:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800444:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800447:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80044a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80044e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800452:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800455:	89 04 24             	mov    %eax,(%esp)
  800458:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80045b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80045f:	e8 5c 27 00 00       	call   802bc0 <__umoddi3>
  800464:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800468:	0f be 80 8b 2e 80 00 	movsbl 0x802e8b(%eax),%eax
  80046f:	89 04 24             	mov    %eax,(%esp)
  800472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800475:	ff d0                	call   *%eax
}
  800477:	83 c4 3c             	add    $0x3c,%esp
  80047a:	5b                   	pop    %ebx
  80047b:	5e                   	pop    %esi
  80047c:	5f                   	pop    %edi
  80047d:	5d                   	pop    %ebp
  80047e:	c3                   	ret    

0080047f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80047f:	55                   	push   %ebp
  800480:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800482:	83 fa 01             	cmp    $0x1,%edx
  800485:	7e 0e                	jle    800495 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800487:	8b 10                	mov    (%eax),%edx
  800489:	8d 4a 08             	lea    0x8(%edx),%ecx
  80048c:	89 08                	mov    %ecx,(%eax)
  80048e:	8b 02                	mov    (%edx),%eax
  800490:	8b 52 04             	mov    0x4(%edx),%edx
  800493:	eb 22                	jmp    8004b7 <getuint+0x38>
	else if (lflag)
  800495:	85 d2                	test   %edx,%edx
  800497:	74 10                	je     8004a9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800499:	8b 10                	mov    (%eax),%edx
  80049b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80049e:	89 08                	mov    %ecx,(%eax)
  8004a0:	8b 02                	mov    (%edx),%eax
  8004a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a7:	eb 0e                	jmp    8004b7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004a9:	8b 10                	mov    (%eax),%edx
  8004ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004ae:	89 08                	mov    %ecx,(%eax)
  8004b0:	8b 02                	mov    (%edx),%eax
  8004b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004b7:	5d                   	pop    %ebp
  8004b8:	c3                   	ret    

008004b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004b9:	55                   	push   %ebp
  8004ba:	89 e5                	mov    %esp,%ebp
  8004bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004bf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004c3:	8b 10                	mov    (%eax),%edx
  8004c5:	3b 50 04             	cmp    0x4(%eax),%edx
  8004c8:	73 0a                	jae    8004d4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004cd:	89 08                	mov    %ecx,(%eax)
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d2:	88 02                	mov    %al,(%edx)
}
  8004d4:	5d                   	pop    %ebp
  8004d5:	c3                   	ret    

008004d6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004dc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f4:	89 04 24             	mov    %eax,(%esp)
  8004f7:	e8 02 00 00 00       	call   8004fe <vprintfmt>
	va_end(ap);
}
  8004fc:	c9                   	leave  
  8004fd:	c3                   	ret    

008004fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004fe:	55                   	push   %ebp
  8004ff:	89 e5                	mov    %esp,%ebp
  800501:	57                   	push   %edi
  800502:	56                   	push   %esi
  800503:	53                   	push   %ebx
  800504:	83 ec 3c             	sub    $0x3c,%esp
  800507:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80050a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80050d:	eb 14                	jmp    800523 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80050f:	85 c0                	test   %eax,%eax
  800511:	0f 84 b3 03 00 00    	je     8008ca <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800517:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80051b:	89 04 24             	mov    %eax,(%esp)
  80051e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800521:	89 f3                	mov    %esi,%ebx
  800523:	8d 73 01             	lea    0x1(%ebx),%esi
  800526:	0f b6 03             	movzbl (%ebx),%eax
  800529:	83 f8 25             	cmp    $0x25,%eax
  80052c:	75 e1                	jne    80050f <vprintfmt+0x11>
  80052e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800532:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800539:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800540:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800547:	ba 00 00 00 00       	mov    $0x0,%edx
  80054c:	eb 1d                	jmp    80056b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800550:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800554:	eb 15                	jmp    80056b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800556:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800558:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80055c:	eb 0d                	jmp    80056b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80055e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800561:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800564:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80056e:	0f b6 0e             	movzbl (%esi),%ecx
  800571:	0f b6 c1             	movzbl %cl,%eax
  800574:	83 e9 23             	sub    $0x23,%ecx
  800577:	80 f9 55             	cmp    $0x55,%cl
  80057a:	0f 87 2a 03 00 00    	ja     8008aa <vprintfmt+0x3ac>
  800580:	0f b6 c9             	movzbl %cl,%ecx
  800583:	ff 24 8d c0 2f 80 00 	jmp    *0x802fc0(,%ecx,4)
  80058a:	89 de                	mov    %ebx,%esi
  80058c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800591:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800594:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800598:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80059b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80059e:	83 fb 09             	cmp    $0x9,%ebx
  8005a1:	77 36                	ja     8005d9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005a3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005a6:	eb e9                	jmp    800591 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8d 48 04             	lea    0x4(%eax),%ecx
  8005ae:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005b6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005b8:	eb 22                	jmp    8005dc <vprintfmt+0xde>
  8005ba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005bd:	85 c9                	test   %ecx,%ecx
  8005bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c4:	0f 49 c1             	cmovns %ecx,%eax
  8005c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ca:	89 de                	mov    %ebx,%esi
  8005cc:	eb 9d                	jmp    80056b <vprintfmt+0x6d>
  8005ce:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005d0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8005d7:	eb 92                	jmp    80056b <vprintfmt+0x6d>
  8005d9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8005dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005e0:	79 89                	jns    80056b <vprintfmt+0x6d>
  8005e2:	e9 77 ff ff ff       	jmp    80055e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005e7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ea:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005ec:	e9 7a ff ff ff       	jmp    80056b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f4:	8d 50 04             	lea    0x4(%eax),%edx
  8005f7:	89 55 14             	mov    %edx,0x14(%ebp)
  8005fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	89 04 24             	mov    %eax,(%esp)
  800603:	ff 55 08             	call   *0x8(%ebp)
			break;
  800606:	e9 18 ff ff ff       	jmp    800523 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	8d 50 04             	lea    0x4(%eax),%edx
  800611:	89 55 14             	mov    %edx,0x14(%ebp)
  800614:	8b 00                	mov    (%eax),%eax
  800616:	99                   	cltd   
  800617:	31 d0                	xor    %edx,%eax
  800619:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80061b:	83 f8 11             	cmp    $0x11,%eax
  80061e:	7f 0b                	jg     80062b <vprintfmt+0x12d>
  800620:	8b 14 85 20 31 80 00 	mov    0x803120(,%eax,4),%edx
  800627:	85 d2                	test   %edx,%edx
  800629:	75 20                	jne    80064b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80062b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80062f:	c7 44 24 08 a3 2e 80 	movl   $0x802ea3,0x8(%esp)
  800636:	00 
  800637:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	89 04 24             	mov    %eax,(%esp)
  800641:	e8 90 fe ff ff       	call   8004d6 <printfmt>
  800646:	e9 d8 fe ff ff       	jmp    800523 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80064b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80064f:	c7 44 24 08 4d 33 80 	movl   $0x80334d,0x8(%esp)
  800656:	00 
  800657:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	89 04 24             	mov    %eax,(%esp)
  800661:	e8 70 fe ff ff       	call   8004d6 <printfmt>
  800666:	e9 b8 fe ff ff       	jmp    800523 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80066e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800671:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800674:	8b 45 14             	mov    0x14(%ebp),%eax
  800677:	8d 50 04             	lea    0x4(%eax),%edx
  80067a:	89 55 14             	mov    %edx,0x14(%ebp)
  80067d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80067f:	85 f6                	test   %esi,%esi
  800681:	b8 9c 2e 80 00       	mov    $0x802e9c,%eax
  800686:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800689:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80068d:	0f 84 97 00 00 00    	je     80072a <vprintfmt+0x22c>
  800693:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800697:	0f 8e 9b 00 00 00    	jle    800738 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80069d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006a1:	89 34 24             	mov    %esi,(%esp)
  8006a4:	e8 cf 02 00 00       	call   800978 <strnlen>
  8006a9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006ac:	29 c2                	sub    %eax,%edx
  8006ae:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8006b1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8006b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006b8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006c1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c3:	eb 0f                	jmp    8006d4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8006c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006cc:	89 04 24             	mov    %eax,(%esp)
  8006cf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d1:	83 eb 01             	sub    $0x1,%ebx
  8006d4:	85 db                	test   %ebx,%ebx
  8006d6:	7f ed                	jg     8006c5 <vprintfmt+0x1c7>
  8006d8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8006db:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006de:	85 d2                	test   %edx,%edx
  8006e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e5:	0f 49 c2             	cmovns %edx,%eax
  8006e8:	29 c2                	sub    %eax,%edx
  8006ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006ed:	89 d7                	mov    %edx,%edi
  8006ef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006f2:	eb 50                	jmp    800744 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f8:	74 1e                	je     800718 <vprintfmt+0x21a>
  8006fa:	0f be d2             	movsbl %dl,%edx
  8006fd:	83 ea 20             	sub    $0x20,%edx
  800700:	83 fa 5e             	cmp    $0x5e,%edx
  800703:	76 13                	jbe    800718 <vprintfmt+0x21a>
					putch('?', putdat);
  800705:	8b 45 0c             	mov    0xc(%ebp),%eax
  800708:	89 44 24 04          	mov    %eax,0x4(%esp)
  80070c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800713:	ff 55 08             	call   *0x8(%ebp)
  800716:	eb 0d                	jmp    800725 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800718:	8b 55 0c             	mov    0xc(%ebp),%edx
  80071b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80071f:	89 04 24             	mov    %eax,(%esp)
  800722:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800725:	83 ef 01             	sub    $0x1,%edi
  800728:	eb 1a                	jmp    800744 <vprintfmt+0x246>
  80072a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80072d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800730:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800733:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800736:	eb 0c                	jmp    800744 <vprintfmt+0x246>
  800738:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80073b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80073e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800741:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800744:	83 c6 01             	add    $0x1,%esi
  800747:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80074b:	0f be c2             	movsbl %dl,%eax
  80074e:	85 c0                	test   %eax,%eax
  800750:	74 27                	je     800779 <vprintfmt+0x27b>
  800752:	85 db                	test   %ebx,%ebx
  800754:	78 9e                	js     8006f4 <vprintfmt+0x1f6>
  800756:	83 eb 01             	sub    $0x1,%ebx
  800759:	79 99                	jns    8006f4 <vprintfmt+0x1f6>
  80075b:	89 f8                	mov    %edi,%eax
  80075d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800760:	8b 75 08             	mov    0x8(%ebp),%esi
  800763:	89 c3                	mov    %eax,%ebx
  800765:	eb 1a                	jmp    800781 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800767:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800772:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800774:	83 eb 01             	sub    $0x1,%ebx
  800777:	eb 08                	jmp    800781 <vprintfmt+0x283>
  800779:	89 fb                	mov    %edi,%ebx
  80077b:	8b 75 08             	mov    0x8(%ebp),%esi
  80077e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800781:	85 db                	test   %ebx,%ebx
  800783:	7f e2                	jg     800767 <vprintfmt+0x269>
  800785:	89 75 08             	mov    %esi,0x8(%ebp)
  800788:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80078b:	e9 93 fd ff ff       	jmp    800523 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800790:	83 fa 01             	cmp    $0x1,%edx
  800793:	7e 16                	jle    8007ab <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800795:	8b 45 14             	mov    0x14(%ebp),%eax
  800798:	8d 50 08             	lea    0x8(%eax),%edx
  80079b:	89 55 14             	mov    %edx,0x14(%ebp)
  80079e:	8b 50 04             	mov    0x4(%eax),%edx
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007a9:	eb 32                	jmp    8007dd <vprintfmt+0x2df>
	else if (lflag)
  8007ab:	85 d2                	test   %edx,%edx
  8007ad:	74 18                	je     8007c7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8d 50 04             	lea    0x4(%eax),%edx
  8007b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8007b8:	8b 30                	mov    (%eax),%esi
  8007ba:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007bd:	89 f0                	mov    %esi,%eax
  8007bf:	c1 f8 1f             	sar    $0x1f,%eax
  8007c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007c5:	eb 16                	jmp    8007dd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	8d 50 04             	lea    0x4(%eax),%edx
  8007cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8007d0:	8b 30                	mov    (%eax),%esi
  8007d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007d5:	89 f0                	mov    %esi,%eax
  8007d7:	c1 f8 1f             	sar    $0x1f,%eax
  8007da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ec:	0f 89 80 00 00 00    	jns    800872 <vprintfmt+0x374>
				putch('-', putdat);
  8007f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007fd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800800:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800803:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800806:	f7 d8                	neg    %eax
  800808:	83 d2 00             	adc    $0x0,%edx
  80080b:	f7 da                	neg    %edx
			}
			base = 10;
  80080d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800812:	eb 5e                	jmp    800872 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800814:	8d 45 14             	lea    0x14(%ebp),%eax
  800817:	e8 63 fc ff ff       	call   80047f <getuint>
			base = 10;
  80081c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800821:	eb 4f                	jmp    800872 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800823:	8d 45 14             	lea    0x14(%ebp),%eax
  800826:	e8 54 fc ff ff       	call   80047f <getuint>
			base = 8;
  80082b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800830:	eb 40                	jmp    800872 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800832:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800836:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80083d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800840:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800844:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80084b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	8d 50 04             	lea    0x4(%eax),%edx
  800854:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800857:	8b 00                	mov    (%eax),%eax
  800859:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80085e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800863:	eb 0d                	jmp    800872 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800865:	8d 45 14             	lea    0x14(%ebp),%eax
  800868:	e8 12 fc ff ff       	call   80047f <getuint>
			base = 16;
  80086d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800872:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800876:	89 74 24 10          	mov    %esi,0x10(%esp)
  80087a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80087d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800881:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800885:	89 04 24             	mov    %eax,(%esp)
  800888:	89 54 24 04          	mov    %edx,0x4(%esp)
  80088c:	89 fa                	mov    %edi,%edx
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	e8 fa fa ff ff       	call   800390 <printnum>
			break;
  800896:	e9 88 fc ff ff       	jmp    800523 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80089b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80089f:	89 04 24             	mov    %eax,(%esp)
  8008a2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008a5:	e9 79 fc ff ff       	jmp    800523 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008ae:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008b5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008b8:	89 f3                	mov    %esi,%ebx
  8008ba:	eb 03                	jmp    8008bf <vprintfmt+0x3c1>
  8008bc:	83 eb 01             	sub    $0x1,%ebx
  8008bf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8008c3:	75 f7                	jne    8008bc <vprintfmt+0x3be>
  8008c5:	e9 59 fc ff ff       	jmp    800523 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8008ca:	83 c4 3c             	add    $0x3c,%esp
  8008cd:	5b                   	pop    %ebx
  8008ce:	5e                   	pop    %esi
  8008cf:	5f                   	pop    %edi
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    

008008d2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	83 ec 28             	sub    $0x28,%esp
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008e1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008e5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ef:	85 c0                	test   %eax,%eax
  8008f1:	74 30                	je     800923 <vsnprintf+0x51>
  8008f3:	85 d2                	test   %edx,%edx
  8008f5:	7e 2c                	jle    800923 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800901:	89 44 24 08          	mov    %eax,0x8(%esp)
  800905:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800908:	89 44 24 04          	mov    %eax,0x4(%esp)
  80090c:	c7 04 24 b9 04 80 00 	movl   $0x8004b9,(%esp)
  800913:	e8 e6 fb ff ff       	call   8004fe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800918:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80091b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80091e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800921:	eb 05                	jmp    800928 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800923:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800930:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800933:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800937:	8b 45 10             	mov    0x10(%ebp),%eax
  80093a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80093e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800941:	89 44 24 04          	mov    %eax,0x4(%esp)
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	89 04 24             	mov    %eax,(%esp)
  80094b:	e8 82 ff ff ff       	call   8008d2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800950:	c9                   	leave  
  800951:	c3                   	ret    
  800952:	66 90                	xchg   %ax,%ax
  800954:	66 90                	xchg   %ax,%ax
  800956:	66 90                	xchg   %ax,%ax
  800958:	66 90                	xchg   %ax,%ax
  80095a:	66 90                	xchg   %ax,%ax
  80095c:	66 90                	xchg   %ax,%ax
  80095e:	66 90                	xchg   %ax,%ax

00800960 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800966:	b8 00 00 00 00       	mov    $0x0,%eax
  80096b:	eb 03                	jmp    800970 <strlen+0x10>
		n++;
  80096d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800970:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800974:	75 f7                	jne    80096d <strlen+0xd>
		n++;
	return n;
}
  800976:	5d                   	pop    %ebp
  800977:	c3                   	ret    

00800978 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800978:	55                   	push   %ebp
  800979:	89 e5                	mov    %esp,%ebp
  80097b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80097e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800981:	b8 00 00 00 00       	mov    $0x0,%eax
  800986:	eb 03                	jmp    80098b <strnlen+0x13>
		n++;
  800988:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80098b:	39 d0                	cmp    %edx,%eax
  80098d:	74 06                	je     800995 <strnlen+0x1d>
  80098f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800993:	75 f3                	jne    800988 <strnlen+0x10>
		n++;
	return n;
}
  800995:	5d                   	pop    %ebp
  800996:	c3                   	ret    

00800997 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	53                   	push   %ebx
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009a1:	89 c2                	mov    %eax,%edx
  8009a3:	83 c2 01             	add    $0x1,%edx
  8009a6:	83 c1 01             	add    $0x1,%ecx
  8009a9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009ad:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009b0:	84 db                	test   %bl,%bl
  8009b2:	75 ef                	jne    8009a3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009b4:	5b                   	pop    %ebx
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	53                   	push   %ebx
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009c1:	89 1c 24             	mov    %ebx,(%esp)
  8009c4:	e8 97 ff ff ff       	call   800960 <strlen>
	strcpy(dst + len, src);
  8009c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009d0:	01 d8                	add    %ebx,%eax
  8009d2:	89 04 24             	mov    %eax,(%esp)
  8009d5:	e8 bd ff ff ff       	call   800997 <strcpy>
	return dst;
}
  8009da:	89 d8                	mov    %ebx,%eax
  8009dc:	83 c4 08             	add    $0x8,%esp
  8009df:	5b                   	pop    %ebx
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    

008009e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	56                   	push   %esi
  8009e6:	53                   	push   %ebx
  8009e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ed:	89 f3                	mov    %esi,%ebx
  8009ef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f2:	89 f2                	mov    %esi,%edx
  8009f4:	eb 0f                	jmp    800a05 <strncpy+0x23>
		*dst++ = *src;
  8009f6:	83 c2 01             	add    $0x1,%edx
  8009f9:	0f b6 01             	movzbl (%ecx),%eax
  8009fc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ff:	80 39 01             	cmpb   $0x1,(%ecx)
  800a02:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a05:	39 da                	cmp    %ebx,%edx
  800a07:	75 ed                	jne    8009f6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a09:	89 f0                	mov    %esi,%eax
  800a0b:	5b                   	pop    %ebx
  800a0c:	5e                   	pop    %esi
  800a0d:	5d                   	pop    %ebp
  800a0e:	c3                   	ret    

00800a0f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	56                   	push   %esi
  800a13:	53                   	push   %ebx
  800a14:	8b 75 08             	mov    0x8(%ebp),%esi
  800a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a1d:	89 f0                	mov    %esi,%eax
  800a1f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a23:	85 c9                	test   %ecx,%ecx
  800a25:	75 0b                	jne    800a32 <strlcpy+0x23>
  800a27:	eb 1d                	jmp    800a46 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a29:	83 c0 01             	add    $0x1,%eax
  800a2c:	83 c2 01             	add    $0x1,%edx
  800a2f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a32:	39 d8                	cmp    %ebx,%eax
  800a34:	74 0b                	je     800a41 <strlcpy+0x32>
  800a36:	0f b6 0a             	movzbl (%edx),%ecx
  800a39:	84 c9                	test   %cl,%cl
  800a3b:	75 ec                	jne    800a29 <strlcpy+0x1a>
  800a3d:	89 c2                	mov    %eax,%edx
  800a3f:	eb 02                	jmp    800a43 <strlcpy+0x34>
  800a41:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a43:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a46:	29 f0                	sub    %esi,%eax
}
  800a48:	5b                   	pop    %ebx
  800a49:	5e                   	pop    %esi
  800a4a:	5d                   	pop    %ebp
  800a4b:	c3                   	ret    

00800a4c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a52:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a55:	eb 06                	jmp    800a5d <strcmp+0x11>
		p++, q++;
  800a57:	83 c1 01             	add    $0x1,%ecx
  800a5a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a5d:	0f b6 01             	movzbl (%ecx),%eax
  800a60:	84 c0                	test   %al,%al
  800a62:	74 04                	je     800a68 <strcmp+0x1c>
  800a64:	3a 02                	cmp    (%edx),%al
  800a66:	74 ef                	je     800a57 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a68:	0f b6 c0             	movzbl %al,%eax
  800a6b:	0f b6 12             	movzbl (%edx),%edx
  800a6e:	29 d0                	sub    %edx,%eax
}
  800a70:	5d                   	pop    %ebp
  800a71:	c3                   	ret    

00800a72 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	53                   	push   %ebx
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7c:	89 c3                	mov    %eax,%ebx
  800a7e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a81:	eb 06                	jmp    800a89 <strncmp+0x17>
		n--, p++, q++;
  800a83:	83 c0 01             	add    $0x1,%eax
  800a86:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a89:	39 d8                	cmp    %ebx,%eax
  800a8b:	74 15                	je     800aa2 <strncmp+0x30>
  800a8d:	0f b6 08             	movzbl (%eax),%ecx
  800a90:	84 c9                	test   %cl,%cl
  800a92:	74 04                	je     800a98 <strncmp+0x26>
  800a94:	3a 0a                	cmp    (%edx),%cl
  800a96:	74 eb                	je     800a83 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a98:	0f b6 00             	movzbl (%eax),%eax
  800a9b:	0f b6 12             	movzbl (%edx),%edx
  800a9e:	29 d0                	sub    %edx,%eax
  800aa0:	eb 05                	jmp    800aa7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800aa2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800aa7:	5b                   	pop    %ebx
  800aa8:	5d                   	pop    %ebp
  800aa9:	c3                   	ret    

00800aaa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aaa:	55                   	push   %ebp
  800aab:	89 e5                	mov    %esp,%ebp
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab4:	eb 07                	jmp    800abd <strchr+0x13>
		if (*s == c)
  800ab6:	38 ca                	cmp    %cl,%dl
  800ab8:	74 0f                	je     800ac9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aba:	83 c0 01             	add    $0x1,%eax
  800abd:	0f b6 10             	movzbl (%eax),%edx
  800ac0:	84 d2                	test   %dl,%dl
  800ac2:	75 f2                	jne    800ab6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800ac4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac9:	5d                   	pop    %ebp
  800aca:	c3                   	ret    

00800acb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad5:	eb 07                	jmp    800ade <strfind+0x13>
		if (*s == c)
  800ad7:	38 ca                	cmp    %cl,%dl
  800ad9:	74 0a                	je     800ae5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800adb:	83 c0 01             	add    $0x1,%eax
  800ade:	0f b6 10             	movzbl (%eax),%edx
  800ae1:	84 d2                	test   %dl,%dl
  800ae3:	75 f2                	jne    800ad7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	57                   	push   %edi
  800aeb:	56                   	push   %esi
  800aec:	53                   	push   %ebx
  800aed:	8b 7d 08             	mov    0x8(%ebp),%edi
  800af0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800af3:	85 c9                	test   %ecx,%ecx
  800af5:	74 36                	je     800b2d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800af7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800afd:	75 28                	jne    800b27 <memset+0x40>
  800aff:	f6 c1 03             	test   $0x3,%cl
  800b02:	75 23                	jne    800b27 <memset+0x40>
		c &= 0xFF;
  800b04:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b08:	89 d3                	mov    %edx,%ebx
  800b0a:	c1 e3 08             	shl    $0x8,%ebx
  800b0d:	89 d6                	mov    %edx,%esi
  800b0f:	c1 e6 18             	shl    $0x18,%esi
  800b12:	89 d0                	mov    %edx,%eax
  800b14:	c1 e0 10             	shl    $0x10,%eax
  800b17:	09 f0                	or     %esi,%eax
  800b19:	09 c2                	or     %eax,%edx
  800b1b:	89 d0                	mov    %edx,%eax
  800b1d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b1f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b22:	fc                   	cld    
  800b23:	f3 ab                	rep stos %eax,%es:(%edi)
  800b25:	eb 06                	jmp    800b2d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2a:	fc                   	cld    
  800b2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b2d:	89 f8                	mov    %edi,%eax
  800b2f:	5b                   	pop    %ebx
  800b30:	5e                   	pop    %esi
  800b31:	5f                   	pop    %edi
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	57                   	push   %edi
  800b38:	56                   	push   %esi
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b42:	39 c6                	cmp    %eax,%esi
  800b44:	73 35                	jae    800b7b <memmove+0x47>
  800b46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b49:	39 d0                	cmp    %edx,%eax
  800b4b:	73 2e                	jae    800b7b <memmove+0x47>
		s += n;
		d += n;
  800b4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b50:	89 d6                	mov    %edx,%esi
  800b52:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b54:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b5a:	75 13                	jne    800b6f <memmove+0x3b>
  800b5c:	f6 c1 03             	test   $0x3,%cl
  800b5f:	75 0e                	jne    800b6f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b61:	83 ef 04             	sub    $0x4,%edi
  800b64:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b67:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b6a:	fd                   	std    
  800b6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b6d:	eb 09                	jmp    800b78 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b6f:	83 ef 01             	sub    $0x1,%edi
  800b72:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b75:	fd                   	std    
  800b76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b78:	fc                   	cld    
  800b79:	eb 1d                	jmp    800b98 <memmove+0x64>
  800b7b:	89 f2                	mov    %esi,%edx
  800b7d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b7f:	f6 c2 03             	test   $0x3,%dl
  800b82:	75 0f                	jne    800b93 <memmove+0x5f>
  800b84:	f6 c1 03             	test   $0x3,%cl
  800b87:	75 0a                	jne    800b93 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b89:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b8c:	89 c7                	mov    %eax,%edi
  800b8e:	fc                   	cld    
  800b8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b91:	eb 05                	jmp    800b98 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b93:	89 c7                	mov    %eax,%edi
  800b95:	fc                   	cld    
  800b96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b98:	5e                   	pop    %esi
  800b99:	5f                   	pop    %edi
  800b9a:	5d                   	pop    %ebp
  800b9b:	c3                   	ret    

00800b9c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ba2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	89 04 24             	mov    %eax,(%esp)
  800bb6:	e8 79 ff ff ff       	call   800b34 <memmove>
}
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	56                   	push   %esi
  800bc1:	53                   	push   %ebx
  800bc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc8:	89 d6                	mov    %edx,%esi
  800bca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bcd:	eb 1a                	jmp    800be9 <memcmp+0x2c>
		if (*s1 != *s2)
  800bcf:	0f b6 02             	movzbl (%edx),%eax
  800bd2:	0f b6 19             	movzbl (%ecx),%ebx
  800bd5:	38 d8                	cmp    %bl,%al
  800bd7:	74 0a                	je     800be3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800bd9:	0f b6 c0             	movzbl %al,%eax
  800bdc:	0f b6 db             	movzbl %bl,%ebx
  800bdf:	29 d8                	sub    %ebx,%eax
  800be1:	eb 0f                	jmp    800bf2 <memcmp+0x35>
		s1++, s2++;
  800be3:	83 c2 01             	add    $0x1,%edx
  800be6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800be9:	39 f2                	cmp    %esi,%edx
  800beb:	75 e2                	jne    800bcf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bff:	89 c2                	mov    %eax,%edx
  800c01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c04:	eb 07                	jmp    800c0d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c06:	38 08                	cmp    %cl,(%eax)
  800c08:	74 07                	je     800c11 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c0a:	83 c0 01             	add    $0x1,%eax
  800c0d:	39 d0                	cmp    %edx,%eax
  800c0f:	72 f5                	jb     800c06 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c11:	5d                   	pop    %ebp
  800c12:	c3                   	ret    

00800c13 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	57                   	push   %edi
  800c17:	56                   	push   %esi
  800c18:	53                   	push   %ebx
  800c19:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c1f:	eb 03                	jmp    800c24 <strtol+0x11>
		s++;
  800c21:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c24:	0f b6 0a             	movzbl (%edx),%ecx
  800c27:	80 f9 09             	cmp    $0x9,%cl
  800c2a:	74 f5                	je     800c21 <strtol+0xe>
  800c2c:	80 f9 20             	cmp    $0x20,%cl
  800c2f:	74 f0                	je     800c21 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c31:	80 f9 2b             	cmp    $0x2b,%cl
  800c34:	75 0a                	jne    800c40 <strtol+0x2d>
		s++;
  800c36:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c39:	bf 00 00 00 00       	mov    $0x0,%edi
  800c3e:	eb 11                	jmp    800c51 <strtol+0x3e>
  800c40:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c45:	80 f9 2d             	cmp    $0x2d,%cl
  800c48:	75 07                	jne    800c51 <strtol+0x3e>
		s++, neg = 1;
  800c4a:	8d 52 01             	lea    0x1(%edx),%edx
  800c4d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c51:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c56:	75 15                	jne    800c6d <strtol+0x5a>
  800c58:	80 3a 30             	cmpb   $0x30,(%edx)
  800c5b:	75 10                	jne    800c6d <strtol+0x5a>
  800c5d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c61:	75 0a                	jne    800c6d <strtol+0x5a>
		s += 2, base = 16;
  800c63:	83 c2 02             	add    $0x2,%edx
  800c66:	b8 10 00 00 00       	mov    $0x10,%eax
  800c6b:	eb 10                	jmp    800c7d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c6d:	85 c0                	test   %eax,%eax
  800c6f:	75 0c                	jne    800c7d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c71:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c73:	80 3a 30             	cmpb   $0x30,(%edx)
  800c76:	75 05                	jne    800c7d <strtol+0x6a>
		s++, base = 8;
  800c78:	83 c2 01             	add    $0x1,%edx
  800c7b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c82:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c85:	0f b6 0a             	movzbl (%edx),%ecx
  800c88:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c8b:	89 f0                	mov    %esi,%eax
  800c8d:	3c 09                	cmp    $0x9,%al
  800c8f:	77 08                	ja     800c99 <strtol+0x86>
			dig = *s - '0';
  800c91:	0f be c9             	movsbl %cl,%ecx
  800c94:	83 e9 30             	sub    $0x30,%ecx
  800c97:	eb 20                	jmp    800cb9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c99:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c9c:	89 f0                	mov    %esi,%eax
  800c9e:	3c 19                	cmp    $0x19,%al
  800ca0:	77 08                	ja     800caa <strtol+0x97>
			dig = *s - 'a' + 10;
  800ca2:	0f be c9             	movsbl %cl,%ecx
  800ca5:	83 e9 57             	sub    $0x57,%ecx
  800ca8:	eb 0f                	jmp    800cb9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800caa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800cad:	89 f0                	mov    %esi,%eax
  800caf:	3c 19                	cmp    $0x19,%al
  800cb1:	77 16                	ja     800cc9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800cb3:	0f be c9             	movsbl %cl,%ecx
  800cb6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cb9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800cbc:	7d 0f                	jge    800ccd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800cbe:	83 c2 01             	add    $0x1,%edx
  800cc1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800cc5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800cc7:	eb bc                	jmp    800c85 <strtol+0x72>
  800cc9:	89 d8                	mov    %ebx,%eax
  800ccb:	eb 02                	jmp    800ccf <strtol+0xbc>
  800ccd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800ccf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd3:	74 05                	je     800cda <strtol+0xc7>
		*endptr = (char *) s;
  800cd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cd8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800cda:	f7 d8                	neg    %eax
  800cdc:	85 ff                	test   %edi,%edi
  800cde:	0f 44 c3             	cmove  %ebx,%eax
}
  800ce1:	5b                   	pop    %ebx
  800ce2:	5e                   	pop    %esi
  800ce3:	5f                   	pop    %edi
  800ce4:	5d                   	pop    %ebp
  800ce5:	c3                   	ret    

00800ce6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	57                   	push   %edi
  800cea:	56                   	push   %esi
  800ceb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cec:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf7:	89 c3                	mov    %eax,%ebx
  800cf9:	89 c7                	mov    %eax,%edi
  800cfb:	89 c6                	mov    %eax,%esi
  800cfd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cff:	5b                   	pop    %ebx
  800d00:	5e                   	pop    %esi
  800d01:	5f                   	pop    %edi
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    

00800d04 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	57                   	push   %edi
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0f:	b8 01 00 00 00       	mov    $0x1,%eax
  800d14:	89 d1                	mov    %edx,%ecx
  800d16:	89 d3                	mov    %edx,%ebx
  800d18:	89 d7                	mov    %edx,%edi
  800d1a:	89 d6                	mov    %edx,%esi
  800d1c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d1e:	5b                   	pop    %ebx
  800d1f:	5e                   	pop    %esi
  800d20:	5f                   	pop    %edi
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	57                   	push   %edi
  800d27:	56                   	push   %esi
  800d28:	53                   	push   %ebx
  800d29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d31:	b8 03 00 00 00       	mov    $0x3,%eax
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	89 cb                	mov    %ecx,%ebx
  800d3b:	89 cf                	mov    %ecx,%edi
  800d3d:	89 ce                	mov    %ecx,%esi
  800d3f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d41:	85 c0                	test   %eax,%eax
  800d43:	7e 28                	jle    800d6d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d45:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d49:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d50:	00 
  800d51:	c7 44 24 08 87 31 80 	movl   $0x803187,0x8(%esp)
  800d58:	00 
  800d59:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d60:	00 
  800d61:	c7 04 24 a4 31 80 00 	movl   $0x8031a4,(%esp)
  800d68:	e8 0d f5 ff ff       	call   80027a <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d6d:	83 c4 2c             	add    $0x2c,%esp
  800d70:	5b                   	pop    %ebx
  800d71:	5e                   	pop    %esi
  800d72:	5f                   	pop    %edi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d80:	b8 02 00 00 00       	mov    $0x2,%eax
  800d85:	89 d1                	mov    %edx,%ecx
  800d87:	89 d3                	mov    %edx,%ebx
  800d89:	89 d7                	mov    %edx,%edi
  800d8b:	89 d6                	mov    %edx,%esi
  800d8d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d8f:	5b                   	pop    %ebx
  800d90:	5e                   	pop    %esi
  800d91:	5f                   	pop    %edi
  800d92:	5d                   	pop    %ebp
  800d93:	c3                   	ret    

00800d94 <sys_yield>:

void
sys_yield(void)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	57                   	push   %edi
  800d98:	56                   	push   %esi
  800d99:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d9f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800da4:	89 d1                	mov    %edx,%ecx
  800da6:	89 d3                	mov    %edx,%ebx
  800da8:	89 d7                	mov    %edx,%edi
  800daa:	89 d6                	mov    %edx,%esi
  800dac:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dae:	5b                   	pop    %ebx
  800daf:	5e                   	pop    %esi
  800db0:	5f                   	pop    %edi
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dbc:	be 00 00 00 00       	mov    $0x0,%esi
  800dc1:	b8 04 00 00 00       	mov    $0x4,%eax
  800dc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dcf:	89 f7                	mov    %esi,%edi
  800dd1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800dd3:	85 c0                	test   %eax,%eax
  800dd5:	7e 28                	jle    800dff <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ddb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800de2:	00 
  800de3:	c7 44 24 08 87 31 80 	movl   $0x803187,0x8(%esp)
  800dea:	00 
  800deb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df2:	00 
  800df3:	c7 04 24 a4 31 80 00 	movl   $0x8031a4,(%esp)
  800dfa:	e8 7b f4 ff ff       	call   80027a <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dff:	83 c4 2c             	add    $0x2c,%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5f                   	pop    %edi
  800e05:	5d                   	pop    %ebp
  800e06:	c3                   	ret    

00800e07 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	57                   	push   %edi
  800e0b:	56                   	push   %esi
  800e0c:	53                   	push   %ebx
  800e0d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e10:	b8 05 00 00 00       	mov    $0x5,%eax
  800e15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e18:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e1e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e21:	8b 75 18             	mov    0x18(%ebp),%esi
  800e24:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e26:	85 c0                	test   %eax,%eax
  800e28:	7e 28                	jle    800e52 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e2e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e35:	00 
  800e36:	c7 44 24 08 87 31 80 	movl   $0x803187,0x8(%esp)
  800e3d:	00 
  800e3e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e45:	00 
  800e46:	c7 04 24 a4 31 80 00 	movl   $0x8031a4,(%esp)
  800e4d:	e8 28 f4 ff ff       	call   80027a <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e52:	83 c4 2c             	add    $0x2c,%esp
  800e55:	5b                   	pop    %ebx
  800e56:	5e                   	pop    %esi
  800e57:	5f                   	pop    %edi
  800e58:	5d                   	pop    %ebp
  800e59:	c3                   	ret    

00800e5a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	57                   	push   %edi
  800e5e:	56                   	push   %esi
  800e5f:	53                   	push   %ebx
  800e60:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e63:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e68:	b8 06 00 00 00       	mov    $0x6,%eax
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e70:	8b 55 08             	mov    0x8(%ebp),%edx
  800e73:	89 df                	mov    %ebx,%edi
  800e75:	89 de                	mov    %ebx,%esi
  800e77:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e79:	85 c0                	test   %eax,%eax
  800e7b:	7e 28                	jle    800ea5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e81:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e88:	00 
  800e89:	c7 44 24 08 87 31 80 	movl   $0x803187,0x8(%esp)
  800e90:	00 
  800e91:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e98:	00 
  800e99:	c7 04 24 a4 31 80 00 	movl   $0x8031a4,(%esp)
  800ea0:	e8 d5 f3 ff ff       	call   80027a <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ea5:	83 c4 2c             	add    $0x2c,%esp
  800ea8:	5b                   	pop    %ebx
  800ea9:	5e                   	pop    %esi
  800eaa:	5f                   	pop    %edi
  800eab:	5d                   	pop    %ebp
  800eac:	c3                   	ret    

00800ead <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	57                   	push   %edi
  800eb1:	56                   	push   %esi
  800eb2:	53                   	push   %ebx
  800eb3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebb:	b8 08 00 00 00       	mov    $0x8,%eax
  800ec0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec6:	89 df                	mov    %ebx,%edi
  800ec8:	89 de                	mov    %ebx,%esi
  800eca:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	7e 28                	jle    800ef8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800edb:	00 
  800edc:	c7 44 24 08 87 31 80 	movl   $0x803187,0x8(%esp)
  800ee3:	00 
  800ee4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eeb:	00 
  800eec:	c7 04 24 a4 31 80 00 	movl   $0x8031a4,(%esp)
  800ef3:	e8 82 f3 ff ff       	call   80027a <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ef8:	83 c4 2c             	add    $0x2c,%esp
  800efb:	5b                   	pop    %ebx
  800efc:	5e                   	pop    %esi
  800efd:	5f                   	pop    %edi
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    

00800f00 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	57                   	push   %edi
  800f04:	56                   	push   %esi
  800f05:	53                   	push   %ebx
  800f06:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	89 df                	mov    %ebx,%edi
  800f1b:	89 de                	mov    %ebx,%esi
  800f1d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f1f:	85 c0                	test   %eax,%eax
  800f21:	7e 28                	jle    800f4b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f23:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f27:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f2e:	00 
  800f2f:	c7 44 24 08 87 31 80 	movl   $0x803187,0x8(%esp)
  800f36:	00 
  800f37:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f3e:	00 
  800f3f:	c7 04 24 a4 31 80 00 	movl   $0x8031a4,(%esp)
  800f46:	e8 2f f3 ff ff       	call   80027a <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f4b:	83 c4 2c             	add    $0x2c,%esp
  800f4e:	5b                   	pop    %ebx
  800f4f:	5e                   	pop    %esi
  800f50:	5f                   	pop    %edi
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	57                   	push   %edi
  800f57:	56                   	push   %esi
  800f58:	53                   	push   %ebx
  800f59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f69:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6c:	89 df                	mov    %ebx,%edi
  800f6e:	89 de                	mov    %ebx,%esi
  800f70:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f72:	85 c0                	test   %eax,%eax
  800f74:	7e 28                	jle    800f9e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f76:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f7a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f81:	00 
  800f82:	c7 44 24 08 87 31 80 	movl   $0x803187,0x8(%esp)
  800f89:	00 
  800f8a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f91:	00 
  800f92:	c7 04 24 a4 31 80 00 	movl   $0x8031a4,(%esp)
  800f99:	e8 dc f2 ff ff       	call   80027a <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f9e:	83 c4 2c             	add    $0x2c,%esp
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5f                   	pop    %edi
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    

00800fa6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	57                   	push   %edi
  800faa:	56                   	push   %esi
  800fab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fac:	be 00 00 00 00       	mov    $0x0,%esi
  800fb1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fbf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fc4:	5b                   	pop    %ebx
  800fc5:	5e                   	pop    %esi
  800fc6:	5f                   	pop    %edi
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    

00800fc9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	57                   	push   %edi
  800fcd:	56                   	push   %esi
  800fce:	53                   	push   %ebx
  800fcf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdf:	89 cb                	mov    %ecx,%ebx
  800fe1:	89 cf                	mov    %ecx,%edi
  800fe3:	89 ce                	mov    %ecx,%esi
  800fe5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800fe7:	85 c0                	test   %eax,%eax
  800fe9:	7e 28                	jle    801013 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800feb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fef:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ff6:	00 
  800ff7:	c7 44 24 08 87 31 80 	movl   $0x803187,0x8(%esp)
  800ffe:	00 
  800fff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801006:	00 
  801007:	c7 04 24 a4 31 80 00 	movl   $0x8031a4,(%esp)
  80100e:	e8 67 f2 ff ff       	call   80027a <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801013:	83 c4 2c             	add    $0x2c,%esp
  801016:	5b                   	pop    %ebx
  801017:	5e                   	pop    %esi
  801018:	5f                   	pop    %edi
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    

0080101b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	57                   	push   %edi
  80101f:	56                   	push   %esi
  801020:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801021:	ba 00 00 00 00       	mov    $0x0,%edx
  801026:	b8 0e 00 00 00       	mov    $0xe,%eax
  80102b:	89 d1                	mov    %edx,%ecx
  80102d:	89 d3                	mov    %edx,%ebx
  80102f:	89 d7                	mov    %edx,%edi
  801031:	89 d6                	mov    %edx,%esi
  801033:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801035:	5b                   	pop    %ebx
  801036:	5e                   	pop    %esi
  801037:	5f                   	pop    %edi
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    

0080103a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	57                   	push   %edi
  80103e:	56                   	push   %esi
  80103f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801040:	bb 00 00 00 00       	mov    $0x0,%ebx
  801045:	b8 0f 00 00 00       	mov    $0xf,%eax
  80104a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104d:	8b 55 08             	mov    0x8(%ebp),%edx
  801050:	89 df                	mov    %ebx,%edi
  801052:	89 de                	mov    %ebx,%esi
  801054:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  801056:	5b                   	pop    %ebx
  801057:	5e                   	pop    %esi
  801058:	5f                   	pop    %edi
  801059:	5d                   	pop    %ebp
  80105a:	c3                   	ret    

0080105b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	57                   	push   %edi
  80105f:	56                   	push   %esi
  801060:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801061:	bb 00 00 00 00       	mov    $0x0,%ebx
  801066:	b8 10 00 00 00       	mov    $0x10,%eax
  80106b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80106e:	8b 55 08             	mov    0x8(%ebp),%edx
  801071:	89 df                	mov    %ebx,%edi
  801073:	89 de                	mov    %ebx,%esi
  801075:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  801077:	5b                   	pop    %ebx
  801078:	5e                   	pop    %esi
  801079:	5f                   	pop    %edi
  80107a:	5d                   	pop    %ebp
  80107b:	c3                   	ret    

0080107c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	57                   	push   %edi
  801080:	56                   	push   %esi
  801081:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801082:	b9 00 00 00 00       	mov    $0x0,%ecx
  801087:	b8 11 00 00 00       	mov    $0x11,%eax
  80108c:	8b 55 08             	mov    0x8(%ebp),%edx
  80108f:	89 cb                	mov    %ecx,%ebx
  801091:	89 cf                	mov    %ecx,%edi
  801093:	89 ce                	mov    %ecx,%esi
  801095:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801097:	5b                   	pop    %ebx
  801098:	5e                   	pop    %esi
  801099:	5f                   	pop    %edi
  80109a:	5d                   	pop    %ebp
  80109b:	c3                   	ret    

0080109c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	57                   	push   %edi
  8010a0:	56                   	push   %esi
  8010a1:	53                   	push   %ebx
  8010a2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a5:	be 00 00 00 00       	mov    $0x0,%esi
  8010aa:	b8 12 00 00 00       	mov    $0x12,%eax
  8010af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010b8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010bb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8010bd:	85 c0                	test   %eax,%eax
  8010bf:	7e 28                	jle    8010e9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8010cc:	00 
  8010cd:	c7 44 24 08 87 31 80 	movl   $0x803187,0x8(%esp)
  8010d4:	00 
  8010d5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010dc:	00 
  8010dd:	c7 04 24 a4 31 80 00 	movl   $0x8031a4,(%esp)
  8010e4:	e8 91 f1 ff ff       	call   80027a <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  8010e9:	83 c4 2c             	add    $0x2c,%esp
  8010ec:	5b                   	pop    %ebx
  8010ed:	5e                   	pop    %esi
  8010ee:	5f                   	pop    %edi
  8010ef:	5d                   	pop    %ebp
  8010f0:	c3                   	ret    

008010f1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	53                   	push   %ebx
  8010f5:	83 ec 24             	sub    $0x24,%esp
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8010fb:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0)
  8010fd:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801101:	75 20                	jne    801123 <pgfault+0x32>
		panic("pgfault: faulting address [%08x] not a write\n", addr);
  801103:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801107:	c7 44 24 08 b4 31 80 	movl   $0x8031b4,0x8(%esp)
  80110e:	00 
  80110f:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  801116:	00 
  801117:	c7 04 24 34 32 80 00 	movl   $0x803234,(%esp)
  80111e:	e8 57 f1 ff ff       	call   80027a <_panic>

	void *page_aligned_addr = (void *) ROUNDDOWN(addr, PGSIZE);
  801123:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t page_num = (uint32_t) page_aligned_addr / PGSIZE;
  801129:	89 d8                	mov    %ebx,%eax
  80112b:	c1 e8 0c             	shr    $0xc,%eax
	if (!(uvpt[page_num] & PTE_COW))
  80112e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801135:	f6 c4 08             	test   $0x8,%ah
  801138:	75 1c                	jne    801156 <pgfault+0x65>
		panic("pgfault: fault was not on a copy-on-write page\n");
  80113a:	c7 44 24 08 e4 31 80 	movl   $0x8031e4,0x8(%esp)
  801141:	00 
  801142:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801149:	00 
  80114a:	c7 04 24 34 32 80 00 	movl   $0x803234,(%esp)
  801151:	e8 24 f1 ff ff       	call   80027a <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	// Allocate
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801156:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80115d:	00 
  80115e:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801165:	00 
  801166:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80116d:	e8 41 fc ff ff       	call   800db3 <sys_page_alloc>
  801172:	85 c0                	test   %eax,%eax
  801174:	79 20                	jns    801196 <pgfault+0xa5>
		panic("sys_page_alloc: %e\n", r);
  801176:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80117a:	c7 44 24 08 3f 32 80 	movl   $0x80323f,0x8(%esp)
  801181:	00 
  801182:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  801189:	00 
  80118a:	c7 04 24 34 32 80 00 	movl   $0x803234,(%esp)
  801191:	e8 e4 f0 ff ff       	call   80027a <_panic>

	// Copy over
	void *src_addr = (void *) ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, src_addr, PGSIZE);
  801196:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80119d:	00 
  80119e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011a2:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8011a9:	e8 86 f9 ff ff       	call   800b34 <memmove>

	// Remap
	if ((r = sys_page_map(0, PFTEMP, 0, src_addr, PTE_P | PTE_U | PTE_W)) < 0)
  8011ae:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8011b5:	00 
  8011b6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011c1:	00 
  8011c2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011c9:	00 
  8011ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d1:	e8 31 fc ff ff       	call   800e07 <sys_page_map>
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	79 20                	jns    8011fa <pgfault+0x109>
		panic("sys_page_map: %e\n", r);
  8011da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011de:	c7 44 24 08 53 32 80 	movl   $0x803253,0x8(%esp)
  8011e5:	00 
  8011e6:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  8011ed:	00 
  8011ee:	c7 04 24 34 32 80 00 	movl   $0x803234,(%esp)
  8011f5:	e8 80 f0 ff ff       	call   80027a <_panic>

	//panic("pgfault not implemented");
}
  8011fa:	83 c4 24             	add    $0x24,%esp
  8011fd:	5b                   	pop    %ebx
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    

00801200 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	57                   	push   %edi
  801204:	56                   	push   %esi
  801205:	53                   	push   %ebx
  801206:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	int r;
	envid_t child_envid;

	set_pgfault_handler(pgfault);
  801209:	c7 04 24 f1 10 80 00 	movl   $0x8010f1,(%esp)
  801210:	e8 61 16 00 00       	call   802876 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801215:	b8 07 00 00 00       	mov    $0x7,%eax
  80121a:	cd 30                	int    $0x30
  80121c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80121f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	child_envid = sys_exofork();
	if (child_envid < 0)
  801222:	85 c0                	test   %eax,%eax
  801224:	79 20                	jns    801246 <fork+0x46>
		panic("sys_exofork: %e\n", child_envid);
  801226:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80122a:	c7 44 24 08 65 32 80 	movl   $0x803265,0x8(%esp)
  801231:	00 
  801232:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  801239:	00 
  80123a:	c7 04 24 34 32 80 00 	movl   $0x803234,(%esp)
  801241:	e8 34 f0 ff ff       	call   80027a <_panic>
	if (child_envid == 0) { // child
  801246:	bf 00 00 00 00       	mov    $0x0,%edi
  80124b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801250:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801254:	75 21                	jne    801277 <fork+0x77>
		// Fix thisenv like dumbfork does and return 0
		thisenv = &envs[ENVX(sys_getenvid())];
  801256:	e8 1a fb ff ff       	call   800d75 <sys_getenvid>
  80125b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801260:	c1 e0 07             	shl    $0x7,%eax
  801263:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801268:	a3 20 54 80 00       	mov    %eax,0x805420
		return 0;
  80126d:	b8 00 00 00 00       	mov    $0x0,%eax
  801272:	e9 53 02 00 00       	jmp    8014ca <fork+0x2ca>
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
  801277:	89 d8                	mov    %ebx,%eax
  801279:	c1 e8 0a             	shr    $0xa,%eax
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  80127c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801283:	a8 01                	test   $0x1,%al
  801285:	0f 84 7a 01 00 00    	je     801405 <fork+0x205>
			((uvpt[page_num] & PTE_P) == PTE_P)) {
  80128b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  801292:	a8 01                	test   $0x1,%al
  801294:	0f 84 6b 01 00 00    	je     801405 <fork+0x205>
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
	envid_t this_envid = thisenv->env_id;
  80129a:	a1 20 54 80 00       	mov    0x805420,%eax
  80129f:	8b 40 48             	mov    0x48(%eax),%eax
  8012a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 4: Your code here.
	if (uvpt[pn] & PTE_SHARE) {
  8012a5:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012ac:	f6 c4 04             	test   $0x4,%ah
  8012af:	74 52                	je     801303 <fork+0x103>
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  8012b1:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012b8:	25 07 0e 00 00       	and    $0xe07,%eax
  8012bd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d3:	89 04 24             	mov    %eax,(%esp)
  8012d6:	e8 2c fb ff ff       	call   800e07 <sys_page_map>
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	0f 89 22 01 00 00    	jns    801405 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  8012e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012e7:	c7 44 24 08 53 32 80 	movl   $0x803253,0x8(%esp)
  8012ee:	00 
  8012ef:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  8012f6:	00 
  8012f7:	c7 04 24 34 32 80 00 	movl   $0x803234,(%esp)
  8012fe:	e8 77 ef ff ff       	call   80027a <_panic>
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
  801303:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80130a:	f6 c4 08             	test   $0x8,%ah
  80130d:	75 0f                	jne    80131e <fork+0x11e>
  80130f:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801316:	a8 02                	test   $0x2,%al
  801318:	0f 84 99 00 00 00    	je     8013b7 <fork+0x1b7>
		if (uvpt[pn] & PTE_U)
  80131e:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801325:	83 e0 04             	and    $0x4,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
  801328:	83 f8 01             	cmp    $0x1,%eax
  80132b:	19 f6                	sbb    %esi,%esi
  80132d:	83 e6 fc             	and    $0xfffffffc,%esi
  801330:	81 c6 05 08 00 00    	add    $0x805,%esi
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
		if (uvpt[pn] & PTE_U)
			perm |= PTE_U;

		// Map page COW, U and P in child
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), perm)) < 0)
  801336:	89 74 24 10          	mov    %esi,0x10(%esp)
  80133a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80133e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801341:	89 44 24 08          	mov    %eax,0x8(%esp)
  801345:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801349:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80134c:	89 04 24             	mov    %eax,(%esp)
  80134f:	e8 b3 fa ff ff       	call   800e07 <sys_page_map>
  801354:	85 c0                	test   %eax,%eax
  801356:	79 20                	jns    801378 <fork+0x178>
			panic("sys_page_map: %e\n", r);
  801358:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80135c:	c7 44 24 08 53 32 80 	movl   $0x803253,0x8(%esp)
  801363:	00 
  801364:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80136b:	00 
  80136c:	c7 04 24 34 32 80 00 	movl   $0x803234,(%esp)
  801373:	e8 02 ef ff ff       	call   80027a <_panic>

		// Map page COW, U and P in parent
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), this_envid, (void *) (pn*PGSIZE), perm)) < 0)
  801378:	89 74 24 10          	mov    %esi,0x10(%esp)
  80137c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801380:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801383:	89 44 24 08          	mov    %eax,0x8(%esp)
  801387:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80138b:	89 04 24             	mov    %eax,(%esp)
  80138e:	e8 74 fa ff ff       	call   800e07 <sys_page_map>
  801393:	85 c0                	test   %eax,%eax
  801395:	79 6e                	jns    801405 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801397:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80139b:	c7 44 24 08 53 32 80 	movl   $0x803253,0x8(%esp)
  8013a2:	00 
  8013a3:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8013aa:	00 
  8013ab:	c7 04 24 34 32 80 00 	movl   $0x803234,(%esp)
  8013b2:	e8 c3 ee ff ff       	call   80027a <_panic>

	} else { // map pages that are present but not writable or COW with their original permissions
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  8013b7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8013be:	25 07 0e 00 00       	and    $0xe07,%eax
  8013c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013c7:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d9:	89 04 24             	mov    %eax,(%esp)
  8013dc:	e8 26 fa ff ff       	call   800e07 <sys_page_map>
  8013e1:	85 c0                	test   %eax,%eax
  8013e3:	79 20                	jns    801405 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  8013e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013e9:	c7 44 24 08 53 32 80 	movl   $0x803253,0x8(%esp)
  8013f0:	00 
  8013f1:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  8013f8:	00 
  8013f9:	c7 04 24 34 32 80 00 	movl   $0x803234,(%esp)
  801400:	e8 75 ee ff ff       	call   80027a <_panic>
	// and let duppage worry about the permissions.
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
  801405:	83 c3 01             	add    $0x1,%ebx
  801408:	81 c7 00 10 00 00    	add    $0x1000,%edi
  80140e:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801414:	0f 85 5d fe ff ff    	jne    801277 <fork+0x77>
	}

	// Allocate exception stack space for child. The child can't do this themselves
	// because the mechanism by which it would is to run the pgfault handler, which
	// needs to run on the exception stack (catch 22).
	if ((r = sys_page_alloc(child_envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80141a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801421:	00 
  801422:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801429:	ee 
  80142a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80142d:	89 04 24             	mov    %eax,(%esp)
  801430:	e8 7e f9 ff ff       	call   800db3 <sys_page_alloc>
  801435:	85 c0                	test   %eax,%eax
  801437:	79 20                	jns    801459 <fork+0x259>
		panic("sys_page_alloc: %e\n", r);
  801439:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80143d:	c7 44 24 08 3f 32 80 	movl   $0x80323f,0x8(%esp)
  801444:	00 
  801445:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  80144c:	00 
  80144d:	c7 04 24 34 32 80 00 	movl   $0x803234,(%esp)
  801454:	e8 21 ee ff ff       	call   80027a <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801459:	c7 44 24 04 f7 28 80 	movl   $0x8028f7,0x4(%esp)
  801460:	00 
  801461:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801464:	89 04 24             	mov    %eax,(%esp)
  801467:	e8 e7 fa ff ff       	call   800f53 <sys_env_set_pgfault_upcall>
  80146c:	85 c0                	test   %eax,%eax
  80146e:	79 20                	jns    801490 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801470:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801474:	c7 44 24 08 14 32 80 	movl   $0x803214,0x8(%esp)
  80147b:	00 
  80147c:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801483:	00 
  801484:	c7 04 24 34 32 80 00 	movl   $0x803234,(%esp)
  80148b:	e8 ea ed ff ff       	call   80027a <_panic>

	// Mark child environment as runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801490:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801497:	00 
  801498:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80149b:	89 04 24             	mov    %eax,(%esp)
  80149e:	e8 0a fa ff ff       	call   800ead <sys_env_set_status>
  8014a3:	85 c0                	test   %eax,%eax
  8014a5:	79 20                	jns    8014c7 <fork+0x2c7>
		panic("sys_env_set_status: %e\n", r);
  8014a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014ab:	c7 44 24 08 76 32 80 	movl   $0x803276,0x8(%esp)
  8014b2:	00 
  8014b3:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8014ba:	00 
  8014bb:	c7 04 24 34 32 80 00 	movl   $0x803234,(%esp)
  8014c2:	e8 b3 ed ff ff       	call   80027a <_panic>

	return child_envid;
  8014c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8014ca:	83 c4 2c             	add    $0x2c,%esp
  8014cd:	5b                   	pop    %ebx
  8014ce:	5e                   	pop    %esi
  8014cf:	5f                   	pop    %edi
  8014d0:	5d                   	pop    %ebp
  8014d1:	c3                   	ret    

008014d2 <sfork>:

// Challenge!
int
sfork(void)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	83 ec 18             	sub    $0x18,%esp
//	return __fork(1);
	panic("sfork not implemented");
  8014d8:	c7 44 24 08 8e 32 80 	movl   $0x80328e,0x8(%esp)
  8014df:	00 
  8014e0:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  8014e7:	00 
  8014e8:	c7 04 24 34 32 80 00 	movl   $0x803234,(%esp)
  8014ef:	e8 86 ed ff ff       	call   80027a <_panic>
  8014f4:	66 90                	xchg   %ax,%ax
  8014f6:	66 90                	xchg   %ax,%ax
  8014f8:	66 90                	xchg   %ax,%ax
  8014fa:	66 90                	xchg   %ax,%ax
  8014fc:	66 90                	xchg   %ax,%ax
  8014fe:	66 90                	xchg   %ax,%ax

00801500 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801503:	8b 45 08             	mov    0x8(%ebp),%eax
  801506:	05 00 00 00 30       	add    $0x30000000,%eax
  80150b:	c1 e8 0c             	shr    $0xc,%eax
}
  80150e:	5d                   	pop    %ebp
  80150f:	c3                   	ret    

00801510 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80151b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801520:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801525:	5d                   	pop    %ebp
  801526:	c3                   	ret    

00801527 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801532:	89 c2                	mov    %eax,%edx
  801534:	c1 ea 16             	shr    $0x16,%edx
  801537:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80153e:	f6 c2 01             	test   $0x1,%dl
  801541:	74 11                	je     801554 <fd_alloc+0x2d>
  801543:	89 c2                	mov    %eax,%edx
  801545:	c1 ea 0c             	shr    $0xc,%edx
  801548:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80154f:	f6 c2 01             	test   $0x1,%dl
  801552:	75 09                	jne    80155d <fd_alloc+0x36>
			*fd_store = fd;
  801554:	89 01                	mov    %eax,(%ecx)
			return 0;
  801556:	b8 00 00 00 00       	mov    $0x0,%eax
  80155b:	eb 17                	jmp    801574 <fd_alloc+0x4d>
  80155d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801562:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801567:	75 c9                	jne    801532 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801569:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80156f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801574:	5d                   	pop    %ebp
  801575:	c3                   	ret    

00801576 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80157c:	83 f8 1f             	cmp    $0x1f,%eax
  80157f:	77 36                	ja     8015b7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801581:	c1 e0 0c             	shl    $0xc,%eax
  801584:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801589:	89 c2                	mov    %eax,%edx
  80158b:	c1 ea 16             	shr    $0x16,%edx
  80158e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801595:	f6 c2 01             	test   $0x1,%dl
  801598:	74 24                	je     8015be <fd_lookup+0x48>
  80159a:	89 c2                	mov    %eax,%edx
  80159c:	c1 ea 0c             	shr    $0xc,%edx
  80159f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015a6:	f6 c2 01             	test   $0x1,%dl
  8015a9:	74 1a                	je     8015c5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ae:	89 02                	mov    %eax,(%edx)
	return 0;
  8015b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b5:	eb 13                	jmp    8015ca <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015bc:	eb 0c                	jmp    8015ca <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015c3:	eb 05                	jmp    8015ca <fd_lookup+0x54>
  8015c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8015ca:	5d                   	pop    %ebp
  8015cb:	c3                   	ret    

008015cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
  8015cf:	83 ec 18             	sub    $0x18,%esp
  8015d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8015d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015da:	eb 13                	jmp    8015ef <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8015dc:	39 08                	cmp    %ecx,(%eax)
  8015de:	75 0c                	jne    8015ec <dev_lookup+0x20>
			*dev = devtab[i];
  8015e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ea:	eb 38                	jmp    801624 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015ec:	83 c2 01             	add    $0x1,%edx
  8015ef:	8b 04 95 20 33 80 00 	mov    0x803320(,%edx,4),%eax
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	75 e2                	jne    8015dc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015fa:	a1 20 54 80 00       	mov    0x805420,%eax
  8015ff:	8b 40 48             	mov    0x48(%eax),%eax
  801602:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801606:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160a:	c7 04 24 a4 32 80 00 	movl   $0x8032a4,(%esp)
  801611:	e8 5d ed ff ff       	call   800373 <cprintf>
	*dev = 0;
  801616:	8b 45 0c             	mov    0xc(%ebp),%eax
  801619:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80161f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801624:	c9                   	leave  
  801625:	c3                   	ret    

00801626 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	56                   	push   %esi
  80162a:	53                   	push   %ebx
  80162b:	83 ec 20             	sub    $0x20,%esp
  80162e:	8b 75 08             	mov    0x8(%ebp),%esi
  801631:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801634:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801637:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80163b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801641:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801644:	89 04 24             	mov    %eax,(%esp)
  801647:	e8 2a ff ff ff       	call   801576 <fd_lookup>
  80164c:	85 c0                	test   %eax,%eax
  80164e:	78 05                	js     801655 <fd_close+0x2f>
	    || fd != fd2)
  801650:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801653:	74 0c                	je     801661 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801655:	84 db                	test   %bl,%bl
  801657:	ba 00 00 00 00       	mov    $0x0,%edx
  80165c:	0f 44 c2             	cmove  %edx,%eax
  80165f:	eb 3f                	jmp    8016a0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801661:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801664:	89 44 24 04          	mov    %eax,0x4(%esp)
  801668:	8b 06                	mov    (%esi),%eax
  80166a:	89 04 24             	mov    %eax,(%esp)
  80166d:	e8 5a ff ff ff       	call   8015cc <dev_lookup>
  801672:	89 c3                	mov    %eax,%ebx
  801674:	85 c0                	test   %eax,%eax
  801676:	78 16                	js     80168e <fd_close+0x68>
		if (dev->dev_close)
  801678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80167e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801683:	85 c0                	test   %eax,%eax
  801685:	74 07                	je     80168e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801687:	89 34 24             	mov    %esi,(%esp)
  80168a:	ff d0                	call   *%eax
  80168c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80168e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801692:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801699:	e8 bc f7 ff ff       	call   800e5a <sys_page_unmap>
	return r;
  80169e:	89 d8                	mov    %ebx,%eax
}
  8016a0:	83 c4 20             	add    $0x20,%esp
  8016a3:	5b                   	pop    %ebx
  8016a4:	5e                   	pop    %esi
  8016a5:	5d                   	pop    %ebp
  8016a6:	c3                   	ret    

008016a7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
  8016aa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	89 04 24             	mov    %eax,(%esp)
  8016ba:	e8 b7 fe ff ff       	call   801576 <fd_lookup>
  8016bf:	89 c2                	mov    %eax,%edx
  8016c1:	85 d2                	test   %edx,%edx
  8016c3:	78 13                	js     8016d8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8016c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016cc:	00 
  8016cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d0:	89 04 24             	mov    %eax,(%esp)
  8016d3:	e8 4e ff ff ff       	call   801626 <fd_close>
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <close_all>:

void
close_all(void)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	53                   	push   %ebx
  8016de:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016e6:	89 1c 24             	mov    %ebx,(%esp)
  8016e9:	e8 b9 ff ff ff       	call   8016a7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8016ee:	83 c3 01             	add    $0x1,%ebx
  8016f1:	83 fb 20             	cmp    $0x20,%ebx
  8016f4:	75 f0                	jne    8016e6 <close_all+0xc>
		close(i);
}
  8016f6:	83 c4 14             	add    $0x14,%esp
  8016f9:	5b                   	pop    %ebx
  8016fa:	5d                   	pop    %ebp
  8016fb:	c3                   	ret    

008016fc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	57                   	push   %edi
  801700:	56                   	push   %esi
  801701:	53                   	push   %ebx
  801702:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801705:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801708:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	89 04 24             	mov    %eax,(%esp)
  801712:	e8 5f fe ff ff       	call   801576 <fd_lookup>
  801717:	89 c2                	mov    %eax,%edx
  801719:	85 d2                	test   %edx,%edx
  80171b:	0f 88 e1 00 00 00    	js     801802 <dup+0x106>
		return r;
	close(newfdnum);
  801721:	8b 45 0c             	mov    0xc(%ebp),%eax
  801724:	89 04 24             	mov    %eax,(%esp)
  801727:	e8 7b ff ff ff       	call   8016a7 <close>

	newfd = INDEX2FD(newfdnum);
  80172c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80172f:	c1 e3 0c             	shl    $0xc,%ebx
  801732:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801738:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80173b:	89 04 24             	mov    %eax,(%esp)
  80173e:	e8 cd fd ff ff       	call   801510 <fd2data>
  801743:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801745:	89 1c 24             	mov    %ebx,(%esp)
  801748:	e8 c3 fd ff ff       	call   801510 <fd2data>
  80174d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80174f:	89 f0                	mov    %esi,%eax
  801751:	c1 e8 16             	shr    $0x16,%eax
  801754:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80175b:	a8 01                	test   $0x1,%al
  80175d:	74 43                	je     8017a2 <dup+0xa6>
  80175f:	89 f0                	mov    %esi,%eax
  801761:	c1 e8 0c             	shr    $0xc,%eax
  801764:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80176b:	f6 c2 01             	test   $0x1,%dl
  80176e:	74 32                	je     8017a2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801770:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801777:	25 07 0e 00 00       	and    $0xe07,%eax
  80177c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801780:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801784:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80178b:	00 
  80178c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801790:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801797:	e8 6b f6 ff ff       	call   800e07 <sys_page_map>
  80179c:	89 c6                	mov    %eax,%esi
  80179e:	85 c0                	test   %eax,%eax
  8017a0:	78 3e                	js     8017e0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017a5:	89 c2                	mov    %eax,%edx
  8017a7:	c1 ea 0c             	shr    $0xc,%edx
  8017aa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017b1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017b7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8017bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017c6:	00 
  8017c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017d2:	e8 30 f6 ff ff       	call   800e07 <sys_page_map>
  8017d7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8017d9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017dc:	85 f6                	test   %esi,%esi
  8017de:	79 22                	jns    801802 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8017e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017eb:	e8 6a f6 ff ff       	call   800e5a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017fb:	e8 5a f6 ff ff       	call   800e5a <sys_page_unmap>
	return r;
  801800:	89 f0                	mov    %esi,%eax
}
  801802:	83 c4 3c             	add    $0x3c,%esp
  801805:	5b                   	pop    %ebx
  801806:	5e                   	pop    %esi
  801807:	5f                   	pop    %edi
  801808:	5d                   	pop    %ebp
  801809:	c3                   	ret    

0080180a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	53                   	push   %ebx
  80180e:	83 ec 24             	sub    $0x24,%esp
  801811:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801814:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801817:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181b:	89 1c 24             	mov    %ebx,(%esp)
  80181e:	e8 53 fd ff ff       	call   801576 <fd_lookup>
  801823:	89 c2                	mov    %eax,%edx
  801825:	85 d2                	test   %edx,%edx
  801827:	78 6d                	js     801896 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801829:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80182c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801833:	8b 00                	mov    (%eax),%eax
  801835:	89 04 24             	mov    %eax,(%esp)
  801838:	e8 8f fd ff ff       	call   8015cc <dev_lookup>
  80183d:	85 c0                	test   %eax,%eax
  80183f:	78 55                	js     801896 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801844:	8b 50 08             	mov    0x8(%eax),%edx
  801847:	83 e2 03             	and    $0x3,%edx
  80184a:	83 fa 01             	cmp    $0x1,%edx
  80184d:	75 23                	jne    801872 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80184f:	a1 20 54 80 00       	mov    0x805420,%eax
  801854:	8b 40 48             	mov    0x48(%eax),%eax
  801857:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80185b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80185f:	c7 04 24 e5 32 80 00 	movl   $0x8032e5,(%esp)
  801866:	e8 08 eb ff ff       	call   800373 <cprintf>
		return -E_INVAL;
  80186b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801870:	eb 24                	jmp    801896 <read+0x8c>
	}
	if (!dev->dev_read)
  801872:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801875:	8b 52 08             	mov    0x8(%edx),%edx
  801878:	85 d2                	test   %edx,%edx
  80187a:	74 15                	je     801891 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80187c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80187f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801883:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801886:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80188a:	89 04 24             	mov    %eax,(%esp)
  80188d:	ff d2                	call   *%edx
  80188f:	eb 05                	jmp    801896 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801891:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801896:	83 c4 24             	add    $0x24,%esp
  801899:	5b                   	pop    %ebx
  80189a:	5d                   	pop    %ebp
  80189b:	c3                   	ret    

0080189c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	57                   	push   %edi
  8018a0:	56                   	push   %esi
  8018a1:	53                   	push   %ebx
  8018a2:	83 ec 1c             	sub    $0x1c,%esp
  8018a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018b0:	eb 23                	jmp    8018d5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018b2:	89 f0                	mov    %esi,%eax
  8018b4:	29 d8                	sub    %ebx,%eax
  8018b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018ba:	89 d8                	mov    %ebx,%eax
  8018bc:	03 45 0c             	add    0xc(%ebp),%eax
  8018bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c3:	89 3c 24             	mov    %edi,(%esp)
  8018c6:	e8 3f ff ff ff       	call   80180a <read>
		if (m < 0)
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	78 10                	js     8018df <readn+0x43>
			return m;
		if (m == 0)
  8018cf:	85 c0                	test   %eax,%eax
  8018d1:	74 0a                	je     8018dd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018d3:	01 c3                	add    %eax,%ebx
  8018d5:	39 f3                	cmp    %esi,%ebx
  8018d7:	72 d9                	jb     8018b2 <readn+0x16>
  8018d9:	89 d8                	mov    %ebx,%eax
  8018db:	eb 02                	jmp    8018df <readn+0x43>
  8018dd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8018df:	83 c4 1c             	add    $0x1c,%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5f                   	pop    %edi
  8018e5:	5d                   	pop    %ebp
  8018e6:	c3                   	ret    

008018e7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	53                   	push   %ebx
  8018eb:	83 ec 24             	sub    $0x24,%esp
  8018ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f8:	89 1c 24             	mov    %ebx,(%esp)
  8018fb:	e8 76 fc ff ff       	call   801576 <fd_lookup>
  801900:	89 c2                	mov    %eax,%edx
  801902:	85 d2                	test   %edx,%edx
  801904:	78 68                	js     80196e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801906:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801909:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801910:	8b 00                	mov    (%eax),%eax
  801912:	89 04 24             	mov    %eax,(%esp)
  801915:	e8 b2 fc ff ff       	call   8015cc <dev_lookup>
  80191a:	85 c0                	test   %eax,%eax
  80191c:	78 50                	js     80196e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80191e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801921:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801925:	75 23                	jne    80194a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801927:	a1 20 54 80 00       	mov    0x805420,%eax
  80192c:	8b 40 48             	mov    0x48(%eax),%eax
  80192f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801933:	89 44 24 04          	mov    %eax,0x4(%esp)
  801937:	c7 04 24 01 33 80 00 	movl   $0x803301,(%esp)
  80193e:	e8 30 ea ff ff       	call   800373 <cprintf>
		return -E_INVAL;
  801943:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801948:	eb 24                	jmp    80196e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80194a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80194d:	8b 52 0c             	mov    0xc(%edx),%edx
  801950:	85 d2                	test   %edx,%edx
  801952:	74 15                	je     801969 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801954:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801957:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80195b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80195e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801962:	89 04 24             	mov    %eax,(%esp)
  801965:	ff d2                	call   *%edx
  801967:	eb 05                	jmp    80196e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801969:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80196e:	83 c4 24             	add    $0x24,%esp
  801971:	5b                   	pop    %ebx
  801972:	5d                   	pop    %ebp
  801973:	c3                   	ret    

00801974 <seek>:

int
seek(int fdnum, off_t offset)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80197a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80197d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	89 04 24             	mov    %eax,(%esp)
  801987:	e8 ea fb ff ff       	call   801576 <fd_lookup>
  80198c:	85 c0                	test   %eax,%eax
  80198e:	78 0e                	js     80199e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801990:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801993:	8b 55 0c             	mov    0xc(%ebp),%edx
  801996:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801999:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	53                   	push   %ebx
  8019a4:	83 ec 24             	sub    $0x24,%esp
  8019a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b1:	89 1c 24             	mov    %ebx,(%esp)
  8019b4:	e8 bd fb ff ff       	call   801576 <fd_lookup>
  8019b9:	89 c2                	mov    %eax,%edx
  8019bb:	85 d2                	test   %edx,%edx
  8019bd:	78 61                	js     801a20 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c9:	8b 00                	mov    (%eax),%eax
  8019cb:	89 04 24             	mov    %eax,(%esp)
  8019ce:	e8 f9 fb ff ff       	call   8015cc <dev_lookup>
  8019d3:	85 c0                	test   %eax,%eax
  8019d5:	78 49                	js     801a20 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019da:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019de:	75 23                	jne    801a03 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8019e0:	a1 20 54 80 00       	mov    0x805420,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019e5:	8b 40 48             	mov    0x48(%eax),%eax
  8019e8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f0:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  8019f7:	e8 77 e9 ff ff       	call   800373 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8019fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a01:	eb 1d                	jmp    801a20 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801a03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a06:	8b 52 18             	mov    0x18(%edx),%edx
  801a09:	85 d2                	test   %edx,%edx
  801a0b:	74 0e                	je     801a1b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a10:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a14:	89 04 24             	mov    %eax,(%esp)
  801a17:	ff d2                	call   *%edx
  801a19:	eb 05                	jmp    801a20 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a1b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a20:	83 c4 24             	add    $0x24,%esp
  801a23:	5b                   	pop    %ebx
  801a24:	5d                   	pop    %ebp
  801a25:	c3                   	ret    

00801a26 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	53                   	push   %ebx
  801a2a:	83 ec 24             	sub    $0x24,%esp
  801a2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a30:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	89 04 24             	mov    %eax,(%esp)
  801a3d:	e8 34 fb ff ff       	call   801576 <fd_lookup>
  801a42:	89 c2                	mov    %eax,%edx
  801a44:	85 d2                	test   %edx,%edx
  801a46:	78 52                	js     801a9a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a52:	8b 00                	mov    (%eax),%eax
  801a54:	89 04 24             	mov    %eax,(%esp)
  801a57:	e8 70 fb ff ff       	call   8015cc <dev_lookup>
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	78 3a                	js     801a9a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a63:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a67:	74 2c                	je     801a95 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a69:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a6c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a73:	00 00 00 
	stat->st_isdir = 0;
  801a76:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a7d:	00 00 00 
	stat->st_dev = dev;
  801a80:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a86:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a8d:	89 14 24             	mov    %edx,(%esp)
  801a90:	ff 50 14             	call   *0x14(%eax)
  801a93:	eb 05                	jmp    801a9a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801a95:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801a9a:	83 c4 24             	add    $0x24,%esp
  801a9d:	5b                   	pop    %ebx
  801a9e:	5d                   	pop    %ebp
  801a9f:	c3                   	ret    

00801aa0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	56                   	push   %esi
  801aa4:	53                   	push   %ebx
  801aa5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801aa8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801aaf:	00 
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	89 04 24             	mov    %eax,(%esp)
  801ab6:	e8 84 02 00 00       	call   801d3f <open>
  801abb:	89 c3                	mov    %eax,%ebx
  801abd:	85 db                	test   %ebx,%ebx
  801abf:	78 1b                	js     801adc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801ac1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac8:	89 1c 24             	mov    %ebx,(%esp)
  801acb:	e8 56 ff ff ff       	call   801a26 <fstat>
  801ad0:	89 c6                	mov    %eax,%esi
	close(fd);
  801ad2:	89 1c 24             	mov    %ebx,(%esp)
  801ad5:	e8 cd fb ff ff       	call   8016a7 <close>
	return r;
  801ada:	89 f0                	mov    %esi,%eax
}
  801adc:	83 c4 10             	add    $0x10,%esp
  801adf:	5b                   	pop    %ebx
  801ae0:	5e                   	pop    %esi
  801ae1:	5d                   	pop    %ebp
  801ae2:	c3                   	ret    

00801ae3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	56                   	push   %esi
  801ae7:	53                   	push   %ebx
  801ae8:	83 ec 10             	sub    $0x10,%esp
  801aeb:	89 c6                	mov    %eax,%esi
  801aed:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801aef:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801af6:	75 11                	jne    801b09 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801af8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801aff:	e8 11 0f 00 00       	call   802a15 <ipc_find_env>
  801b04:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b09:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b10:	00 
  801b11:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b18:	00 
  801b19:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b1d:	a1 00 50 80 00       	mov    0x805000,%eax
  801b22:	89 04 24             	mov    %eax,(%esp)
  801b25:	e8 5e 0e 00 00       	call   802988 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b2a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b31:	00 
  801b32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b36:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b3d:	e8 de 0d 00 00       	call   802920 <ipc_recv>
}
  801b42:	83 c4 10             	add    $0x10,%esp
  801b45:	5b                   	pop    %ebx
  801b46:	5e                   	pop    %esi
  801b47:	5d                   	pop    %ebp
  801b48:	c3                   	ret    

00801b49 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	8b 40 0c             	mov    0xc(%eax),%eax
  801b55:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b62:	ba 00 00 00 00       	mov    $0x0,%edx
  801b67:	b8 02 00 00 00       	mov    $0x2,%eax
  801b6c:	e8 72 ff ff ff       	call   801ae3 <fsipc>
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
  801b76:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b84:	ba 00 00 00 00       	mov    $0x0,%edx
  801b89:	b8 06 00 00 00       	mov    $0x6,%eax
  801b8e:	e8 50 ff ff ff       	call   801ae3 <fsipc>
}
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	53                   	push   %ebx
  801b99:	83 ec 14             	sub    $0x14,%esp
  801b9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801baa:	ba 00 00 00 00       	mov    $0x0,%edx
  801baf:	b8 05 00 00 00       	mov    $0x5,%eax
  801bb4:	e8 2a ff ff ff       	call   801ae3 <fsipc>
  801bb9:	89 c2                	mov    %eax,%edx
  801bbb:	85 d2                	test   %edx,%edx
  801bbd:	78 2b                	js     801bea <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bbf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bc6:	00 
  801bc7:	89 1c 24             	mov    %ebx,(%esp)
  801bca:	e8 c8 ed ff ff       	call   800997 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bcf:	a1 80 60 80 00       	mov    0x806080,%eax
  801bd4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bda:	a1 84 60 80 00       	mov    0x806084,%eax
  801bdf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bea:	83 c4 14             	add    $0x14,%esp
  801bed:	5b                   	pop    %ebx
  801bee:	5d                   	pop    %ebp
  801bef:	c3                   	ret    

00801bf0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	53                   	push   %ebx
  801bf4:	83 ec 14             	sub    $0x14,%esp
  801bf7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  801c00:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801c05:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801c0b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801c10:	0f 46 c3             	cmovbe %ebx,%eax
  801c13:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801c18:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c23:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801c2a:	e8 05 ef ff ff       	call   800b34 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c34:	b8 04 00 00 00       	mov    $0x4,%eax
  801c39:	e8 a5 fe ff ff       	call   801ae3 <fsipc>
  801c3e:	85 c0                	test   %eax,%eax
  801c40:	78 53                	js     801c95 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801c42:	39 c3                	cmp    %eax,%ebx
  801c44:	73 24                	jae    801c6a <devfile_write+0x7a>
  801c46:	c7 44 24 0c 34 33 80 	movl   $0x803334,0xc(%esp)
  801c4d:	00 
  801c4e:	c7 44 24 08 3b 33 80 	movl   $0x80333b,0x8(%esp)
  801c55:	00 
  801c56:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801c5d:	00 
  801c5e:	c7 04 24 50 33 80 00 	movl   $0x803350,(%esp)
  801c65:	e8 10 e6 ff ff       	call   80027a <_panic>
	assert(r <= PGSIZE);
  801c6a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c6f:	7e 24                	jle    801c95 <devfile_write+0xa5>
  801c71:	c7 44 24 0c 5b 33 80 	movl   $0x80335b,0xc(%esp)
  801c78:	00 
  801c79:	c7 44 24 08 3b 33 80 	movl   $0x80333b,0x8(%esp)
  801c80:	00 
  801c81:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801c88:	00 
  801c89:	c7 04 24 50 33 80 00 	movl   $0x803350,(%esp)
  801c90:	e8 e5 e5 ff ff       	call   80027a <_panic>
	return r;
}
  801c95:	83 c4 14             	add    $0x14,%esp
  801c98:	5b                   	pop    %ebx
  801c99:	5d                   	pop    %ebp
  801c9a:	c3                   	ret    

00801c9b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	56                   	push   %esi
  801c9f:	53                   	push   %ebx
  801ca0:	83 ec 10             	sub    $0x10,%esp
  801ca3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	8b 40 0c             	mov    0xc(%eax),%eax
  801cac:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801cb1:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbc:	b8 03 00 00 00       	mov    $0x3,%eax
  801cc1:	e8 1d fe ff ff       	call   801ae3 <fsipc>
  801cc6:	89 c3                	mov    %eax,%ebx
  801cc8:	85 c0                	test   %eax,%eax
  801cca:	78 6a                	js     801d36 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ccc:	39 c6                	cmp    %eax,%esi
  801cce:	73 24                	jae    801cf4 <devfile_read+0x59>
  801cd0:	c7 44 24 0c 34 33 80 	movl   $0x803334,0xc(%esp)
  801cd7:	00 
  801cd8:	c7 44 24 08 3b 33 80 	movl   $0x80333b,0x8(%esp)
  801cdf:	00 
  801ce0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801ce7:	00 
  801ce8:	c7 04 24 50 33 80 00 	movl   $0x803350,(%esp)
  801cef:	e8 86 e5 ff ff       	call   80027a <_panic>
	assert(r <= PGSIZE);
  801cf4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cf9:	7e 24                	jle    801d1f <devfile_read+0x84>
  801cfb:	c7 44 24 0c 5b 33 80 	movl   $0x80335b,0xc(%esp)
  801d02:	00 
  801d03:	c7 44 24 08 3b 33 80 	movl   $0x80333b,0x8(%esp)
  801d0a:	00 
  801d0b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801d12:	00 
  801d13:	c7 04 24 50 33 80 00 	movl   $0x803350,(%esp)
  801d1a:	e8 5b e5 ff ff       	call   80027a <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d1f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d23:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d2a:	00 
  801d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2e:	89 04 24             	mov    %eax,(%esp)
  801d31:	e8 fe ed ff ff       	call   800b34 <memmove>
	return r;
}
  801d36:	89 d8                	mov    %ebx,%eax
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5e                   	pop    %esi
  801d3d:	5d                   	pop    %ebp
  801d3e:	c3                   	ret    

00801d3f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	53                   	push   %ebx
  801d43:	83 ec 24             	sub    $0x24,%esp
  801d46:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d49:	89 1c 24             	mov    %ebx,(%esp)
  801d4c:	e8 0f ec ff ff       	call   800960 <strlen>
  801d51:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d56:	7f 60                	jg     801db8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d5b:	89 04 24             	mov    %eax,(%esp)
  801d5e:	e8 c4 f7 ff ff       	call   801527 <fd_alloc>
  801d63:	89 c2                	mov    %eax,%edx
  801d65:	85 d2                	test   %edx,%edx
  801d67:	78 54                	js     801dbd <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d69:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d6d:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801d74:	e8 1e ec ff ff       	call   800997 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d84:	b8 01 00 00 00       	mov    $0x1,%eax
  801d89:	e8 55 fd ff ff       	call   801ae3 <fsipc>
  801d8e:	89 c3                	mov    %eax,%ebx
  801d90:	85 c0                	test   %eax,%eax
  801d92:	79 17                	jns    801dab <open+0x6c>
		fd_close(fd, 0);
  801d94:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d9b:	00 
  801d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9f:	89 04 24             	mov    %eax,(%esp)
  801da2:	e8 7f f8 ff ff       	call   801626 <fd_close>
		return r;
  801da7:	89 d8                	mov    %ebx,%eax
  801da9:	eb 12                	jmp    801dbd <open+0x7e>
	}

	return fd2num(fd);
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	89 04 24             	mov    %eax,(%esp)
  801db1:	e8 4a f7 ff ff       	call   801500 <fd2num>
  801db6:	eb 05                	jmp    801dbd <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801db8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801dbd:	83 c4 24             	add    $0x24,%esp
  801dc0:	5b                   	pop    %ebx
  801dc1:	5d                   	pop    %ebp
  801dc2:	c3                   	ret    

00801dc3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dc9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dce:	b8 08 00 00 00       	mov    $0x8,%eax
  801dd3:	e8 0b fd ff ff       	call   801ae3 <fsipc>
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    
  801dda:	66 90                	xchg   %ax,%ax
  801ddc:	66 90                	xchg   %ax,%ax
  801dde:	66 90                	xchg   %ax,%ax

00801de0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801de6:	c7 44 24 04 67 33 80 	movl   $0x803367,0x4(%esp)
  801ded:	00 
  801dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df1:	89 04 24             	mov    %eax,(%esp)
  801df4:	e8 9e eb ff ff       	call   800997 <strcpy>
	return 0;
}
  801df9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	53                   	push   %ebx
  801e04:	83 ec 14             	sub    $0x14,%esp
  801e07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e0a:	89 1c 24             	mov    %ebx,(%esp)
  801e0d:	e8 3d 0c 00 00       	call   802a4f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801e12:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801e17:	83 f8 01             	cmp    $0x1,%eax
  801e1a:	75 0d                	jne    801e29 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801e1c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e1f:	89 04 24             	mov    %eax,(%esp)
  801e22:	e8 29 03 00 00       	call   802150 <nsipc_close>
  801e27:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801e29:	89 d0                	mov    %edx,%eax
  801e2b:	83 c4 14             	add    $0x14,%esp
  801e2e:	5b                   	pop    %ebx
  801e2f:	5d                   	pop    %ebp
  801e30:	c3                   	ret    

00801e31 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e37:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e3e:	00 
  801e3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e42:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e50:	8b 40 0c             	mov    0xc(%eax),%eax
  801e53:	89 04 24             	mov    %eax,(%esp)
  801e56:	e8 f0 03 00 00       	call   80224b <nsipc_send>
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
  801e60:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e63:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e6a:	00 
  801e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e75:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7f:	89 04 24             	mov    %eax,(%esp)
  801e82:	e8 44 03 00 00       	call   8021cb <nsipc_recv>
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
  801e8c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e8f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e92:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e96:	89 04 24             	mov    %eax,(%esp)
  801e99:	e8 d8 f6 ff ff       	call   801576 <fd_lookup>
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	78 17                	js     801eb9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801eab:	39 08                	cmp    %ecx,(%eax)
  801ead:	75 05                	jne    801eb4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801eaf:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb2:	eb 05                	jmp    801eb9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801eb4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	56                   	push   %esi
  801ebf:	53                   	push   %ebx
  801ec0:	83 ec 20             	sub    $0x20,%esp
  801ec3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ec5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ec8:	89 04 24             	mov    %eax,(%esp)
  801ecb:	e8 57 f6 ff ff       	call   801527 <fd_alloc>
  801ed0:	89 c3                	mov    %eax,%ebx
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	78 21                	js     801ef7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ed6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801edd:	00 
  801ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801eec:	e8 c2 ee ff ff       	call   800db3 <sys_page_alloc>
  801ef1:	89 c3                	mov    %eax,%ebx
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	79 0c                	jns    801f03 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801ef7:	89 34 24             	mov    %esi,(%esp)
  801efa:	e8 51 02 00 00       	call   802150 <nsipc_close>
		return r;
  801eff:	89 d8                	mov    %ebx,%eax
  801f01:	eb 20                	jmp    801f23 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f03:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f11:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801f18:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801f1b:	89 14 24             	mov    %edx,(%esp)
  801f1e:	e8 dd f5 ff ff       	call   801500 <fd2num>
}
  801f23:	83 c4 20             	add    $0x20,%esp
  801f26:	5b                   	pop    %ebx
  801f27:	5e                   	pop    %esi
  801f28:	5d                   	pop    %ebp
  801f29:	c3                   	ret    

00801f2a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f30:	8b 45 08             	mov    0x8(%ebp),%eax
  801f33:	e8 51 ff ff ff       	call   801e89 <fd2sockid>
		return r;
  801f38:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f3a:	85 c0                	test   %eax,%eax
  801f3c:	78 23                	js     801f61 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f3e:	8b 55 10             	mov    0x10(%ebp),%edx
  801f41:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f48:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f4c:	89 04 24             	mov    %eax,(%esp)
  801f4f:	e8 45 01 00 00       	call   802099 <nsipc_accept>
		return r;
  801f54:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f56:	85 c0                	test   %eax,%eax
  801f58:	78 07                	js     801f61 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801f5a:	e8 5c ff ff ff       	call   801ebb <alloc_sockfd>
  801f5f:	89 c1                	mov    %eax,%ecx
}
  801f61:	89 c8                	mov    %ecx,%eax
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	e8 16 ff ff ff       	call   801e89 <fd2sockid>
  801f73:	89 c2                	mov    %eax,%edx
  801f75:	85 d2                	test   %edx,%edx
  801f77:	78 16                	js     801f8f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801f79:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f87:	89 14 24             	mov    %edx,(%esp)
  801f8a:	e8 60 01 00 00       	call   8020ef <nsipc_bind>
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <shutdown>:

int
shutdown(int s, int how)
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	e8 ea fe ff ff       	call   801e89 <fd2sockid>
  801f9f:	89 c2                	mov    %eax,%edx
  801fa1:	85 d2                	test   %edx,%edx
  801fa3:	78 0f                	js     801fb4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fac:	89 14 24             	mov    %edx,(%esp)
  801faf:	e8 7a 01 00 00       	call   80212e <nsipc_shutdown>
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbf:	e8 c5 fe ff ff       	call   801e89 <fd2sockid>
  801fc4:	89 c2                	mov    %eax,%edx
  801fc6:	85 d2                	test   %edx,%edx
  801fc8:	78 16                	js     801fe0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801fca:	8b 45 10             	mov    0x10(%ebp),%eax
  801fcd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd8:	89 14 24             	mov    %edx,(%esp)
  801fdb:	e8 8a 01 00 00       	call   80216a <nsipc_connect>
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <listen>:

int
listen(int s, int backlog)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  801feb:	e8 99 fe ff ff       	call   801e89 <fd2sockid>
  801ff0:	89 c2                	mov    %eax,%edx
  801ff2:	85 d2                	test   %edx,%edx
  801ff4:	78 0f                	js     802005 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ffd:	89 14 24             	mov    %edx,(%esp)
  802000:	e8 a4 01 00 00       	call   8021a9 <nsipc_listen>
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80200d:	8b 45 10             	mov    0x10(%ebp),%eax
  802010:	89 44 24 08          	mov    %eax,0x8(%esp)
  802014:	8b 45 0c             	mov    0xc(%ebp),%eax
  802017:	89 44 24 04          	mov    %eax,0x4(%esp)
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	89 04 24             	mov    %eax,(%esp)
  802021:	e8 98 02 00 00       	call   8022be <nsipc_socket>
  802026:	89 c2                	mov    %eax,%edx
  802028:	85 d2                	test   %edx,%edx
  80202a:	78 05                	js     802031 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80202c:	e8 8a fe ff ff       	call   801ebb <alloc_sockfd>
}
  802031:	c9                   	leave  
  802032:	c3                   	ret    

00802033 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	53                   	push   %ebx
  802037:	83 ec 14             	sub    $0x14,%esp
  80203a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80203c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802043:	75 11                	jne    802056 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802045:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80204c:	e8 c4 09 00 00       	call   802a15 <ipc_find_env>
  802051:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802056:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80205d:	00 
  80205e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802065:	00 
  802066:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80206a:	a1 04 50 80 00       	mov    0x805004,%eax
  80206f:	89 04 24             	mov    %eax,(%esp)
  802072:	e8 11 09 00 00       	call   802988 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802077:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80207e:	00 
  80207f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802086:	00 
  802087:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80208e:	e8 8d 08 00 00       	call   802920 <ipc_recv>
}
  802093:	83 c4 14             	add    $0x14,%esp
  802096:	5b                   	pop    %ebx
  802097:	5d                   	pop    %ebp
  802098:	c3                   	ret    

00802099 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
  80209c:	56                   	push   %esi
  80209d:	53                   	push   %ebx
  80209e:	83 ec 10             	sub    $0x10,%esp
  8020a1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020ac:	8b 06                	mov    (%esi),%eax
  8020ae:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b8:	e8 76 ff ff ff       	call   802033 <nsipc>
  8020bd:	89 c3                	mov    %eax,%ebx
  8020bf:	85 c0                	test   %eax,%eax
  8020c1:	78 23                	js     8020e6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020c3:	a1 10 70 80 00       	mov    0x807010,%eax
  8020c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020cc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8020d3:	00 
  8020d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d7:	89 04 24             	mov    %eax,(%esp)
  8020da:	e8 55 ea ff ff       	call   800b34 <memmove>
		*addrlen = ret->ret_addrlen;
  8020df:	a1 10 70 80 00       	mov    0x807010,%eax
  8020e4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8020e6:	89 d8                	mov    %ebx,%eax
  8020e8:	83 c4 10             	add    $0x10,%esp
  8020eb:	5b                   	pop    %ebx
  8020ec:	5e                   	pop    %esi
  8020ed:	5d                   	pop    %ebp
  8020ee:	c3                   	ret    

008020ef <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	53                   	push   %ebx
  8020f3:	83 ec 14             	sub    $0x14,%esp
  8020f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802101:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802105:	8b 45 0c             	mov    0xc(%ebp),%eax
  802108:	89 44 24 04          	mov    %eax,0x4(%esp)
  80210c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802113:	e8 1c ea ff ff       	call   800b34 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802118:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80211e:	b8 02 00 00 00       	mov    $0x2,%eax
  802123:	e8 0b ff ff ff       	call   802033 <nsipc>
}
  802128:	83 c4 14             	add    $0x14,%esp
  80212b:	5b                   	pop    %ebx
  80212c:	5d                   	pop    %ebp
  80212d:	c3                   	ret    

0080212e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
  802131:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80213c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802144:	b8 03 00 00 00       	mov    $0x3,%eax
  802149:	e8 e5 fe ff ff       	call   802033 <nsipc>
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <nsipc_close>:

int
nsipc_close(int s)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80215e:	b8 04 00 00 00       	mov    $0x4,%eax
  802163:	e8 cb fe ff ff       	call   802033 <nsipc>
}
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	53                   	push   %ebx
  80216e:	83 ec 14             	sub    $0x14,%esp
  802171:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802174:	8b 45 08             	mov    0x8(%ebp),%eax
  802177:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80217c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802180:	8b 45 0c             	mov    0xc(%ebp),%eax
  802183:	89 44 24 04          	mov    %eax,0x4(%esp)
  802187:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80218e:	e8 a1 e9 ff ff       	call   800b34 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802193:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802199:	b8 05 00 00 00       	mov    $0x5,%eax
  80219e:	e8 90 fe ff ff       	call   802033 <nsipc>
}
  8021a3:	83 c4 14             	add    $0x14,%esp
  8021a6:	5b                   	pop    %ebx
  8021a7:	5d                   	pop    %ebp
  8021a8:	c3                   	ret    

008021a9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ba:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021bf:	b8 06 00 00 00       	mov    $0x6,%eax
  8021c4:	e8 6a fe ff ff       	call   802033 <nsipc>
}
  8021c9:	c9                   	leave  
  8021ca:	c3                   	ret    

008021cb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	56                   	push   %esi
  8021cf:	53                   	push   %ebx
  8021d0:	83 ec 10             	sub    $0x10,%esp
  8021d3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021de:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8021e7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021ec:	b8 07 00 00 00       	mov    $0x7,%eax
  8021f1:	e8 3d fe ff ff       	call   802033 <nsipc>
  8021f6:	89 c3                	mov    %eax,%ebx
  8021f8:	85 c0                	test   %eax,%eax
  8021fa:	78 46                	js     802242 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8021fc:	39 f0                	cmp    %esi,%eax
  8021fe:	7f 07                	jg     802207 <nsipc_recv+0x3c>
  802200:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802205:	7e 24                	jle    80222b <nsipc_recv+0x60>
  802207:	c7 44 24 0c 73 33 80 	movl   $0x803373,0xc(%esp)
  80220e:	00 
  80220f:	c7 44 24 08 3b 33 80 	movl   $0x80333b,0x8(%esp)
  802216:	00 
  802217:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80221e:	00 
  80221f:	c7 04 24 88 33 80 00 	movl   $0x803388,(%esp)
  802226:	e8 4f e0 ff ff       	call   80027a <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80222b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80222f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802236:	00 
  802237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223a:	89 04 24             	mov    %eax,(%esp)
  80223d:	e8 f2 e8 ff ff       	call   800b34 <memmove>
	}

	return r;
}
  802242:	89 d8                	mov    %ebx,%eax
  802244:	83 c4 10             	add    $0x10,%esp
  802247:	5b                   	pop    %ebx
  802248:	5e                   	pop    %esi
  802249:	5d                   	pop    %ebp
  80224a:	c3                   	ret    

0080224b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
  80224e:	53                   	push   %ebx
  80224f:	83 ec 14             	sub    $0x14,%esp
  802252:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80225d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802263:	7e 24                	jle    802289 <nsipc_send+0x3e>
  802265:	c7 44 24 0c 94 33 80 	movl   $0x803394,0xc(%esp)
  80226c:	00 
  80226d:	c7 44 24 08 3b 33 80 	movl   $0x80333b,0x8(%esp)
  802274:	00 
  802275:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80227c:	00 
  80227d:	c7 04 24 88 33 80 00 	movl   $0x803388,(%esp)
  802284:	e8 f1 df ff ff       	call   80027a <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802289:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80228d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802290:	89 44 24 04          	mov    %eax,0x4(%esp)
  802294:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80229b:	e8 94 e8 ff ff       	call   800b34 <memmove>
	nsipcbuf.send.req_size = size;
  8022a0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022a9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8022b3:	e8 7b fd ff ff       	call   802033 <nsipc>
}
  8022b8:	83 c4 14             	add    $0x14,%esp
  8022bb:	5b                   	pop    %ebx
  8022bc:	5d                   	pop    %ebp
  8022bd:	c3                   	ret    

008022be <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
  8022c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022dc:	b8 09 00 00 00       	mov    $0x9,%eax
  8022e1:	e8 4d fd ff ff       	call   802033 <nsipc>
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
  8022eb:	56                   	push   %esi
  8022ec:	53                   	push   %ebx
  8022ed:	83 ec 10             	sub    $0x10,%esp
  8022f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	89 04 24             	mov    %eax,(%esp)
  8022f9:	e8 12 f2 ff ff       	call   801510 <fd2data>
  8022fe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802300:	c7 44 24 04 a0 33 80 	movl   $0x8033a0,0x4(%esp)
  802307:	00 
  802308:	89 1c 24             	mov    %ebx,(%esp)
  80230b:	e8 87 e6 ff ff       	call   800997 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802310:	8b 46 04             	mov    0x4(%esi),%eax
  802313:	2b 06                	sub    (%esi),%eax
  802315:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80231b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802322:	00 00 00 
	stat->st_dev = &devpipe;
  802325:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80232c:	40 80 00 
	return 0;
}
  80232f:	b8 00 00 00 00       	mov    $0x0,%eax
  802334:	83 c4 10             	add    $0x10,%esp
  802337:	5b                   	pop    %ebx
  802338:	5e                   	pop    %esi
  802339:	5d                   	pop    %ebp
  80233a:	c3                   	ret    

0080233b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	53                   	push   %ebx
  80233f:	83 ec 14             	sub    $0x14,%esp
  802342:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802345:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802349:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802350:	e8 05 eb ff ff       	call   800e5a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802355:	89 1c 24             	mov    %ebx,(%esp)
  802358:	e8 b3 f1 ff ff       	call   801510 <fd2data>
  80235d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802361:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802368:	e8 ed ea ff ff       	call   800e5a <sys_page_unmap>
}
  80236d:	83 c4 14             	add    $0x14,%esp
  802370:	5b                   	pop    %ebx
  802371:	5d                   	pop    %ebp
  802372:	c3                   	ret    

00802373 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	57                   	push   %edi
  802377:	56                   	push   %esi
  802378:	53                   	push   %ebx
  802379:	83 ec 2c             	sub    $0x2c,%esp
  80237c:	89 c6                	mov    %eax,%esi
  80237e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802381:	a1 20 54 80 00       	mov    0x805420,%eax
  802386:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802389:	89 34 24             	mov    %esi,(%esp)
  80238c:	e8 be 06 00 00       	call   802a4f <pageref>
  802391:	89 c7                	mov    %eax,%edi
  802393:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802396:	89 04 24             	mov    %eax,(%esp)
  802399:	e8 b1 06 00 00       	call   802a4f <pageref>
  80239e:	39 c7                	cmp    %eax,%edi
  8023a0:	0f 94 c2             	sete   %dl
  8023a3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8023a6:	8b 0d 20 54 80 00    	mov    0x805420,%ecx
  8023ac:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8023af:	39 fb                	cmp    %edi,%ebx
  8023b1:	74 21                	je     8023d4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8023b3:	84 d2                	test   %dl,%dl
  8023b5:	74 ca                	je     802381 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023b7:	8b 51 58             	mov    0x58(%ecx),%edx
  8023ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023be:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023c6:	c7 04 24 a7 33 80 00 	movl   $0x8033a7,(%esp)
  8023cd:	e8 a1 df ff ff       	call   800373 <cprintf>
  8023d2:	eb ad                	jmp    802381 <_pipeisclosed+0xe>
	}
}
  8023d4:	83 c4 2c             	add    $0x2c,%esp
  8023d7:	5b                   	pop    %ebx
  8023d8:	5e                   	pop    %esi
  8023d9:	5f                   	pop    %edi
  8023da:	5d                   	pop    %ebp
  8023db:	c3                   	ret    

008023dc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
  8023df:	57                   	push   %edi
  8023e0:	56                   	push   %esi
  8023e1:	53                   	push   %ebx
  8023e2:	83 ec 1c             	sub    $0x1c,%esp
  8023e5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8023e8:	89 34 24             	mov    %esi,(%esp)
  8023eb:	e8 20 f1 ff ff       	call   801510 <fd2data>
  8023f0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8023f7:	eb 45                	jmp    80243e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8023f9:	89 da                	mov    %ebx,%edx
  8023fb:	89 f0                	mov    %esi,%eax
  8023fd:	e8 71 ff ff ff       	call   802373 <_pipeisclosed>
  802402:	85 c0                	test   %eax,%eax
  802404:	75 41                	jne    802447 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802406:	e8 89 e9 ff ff       	call   800d94 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80240b:	8b 43 04             	mov    0x4(%ebx),%eax
  80240e:	8b 0b                	mov    (%ebx),%ecx
  802410:	8d 51 20             	lea    0x20(%ecx),%edx
  802413:	39 d0                	cmp    %edx,%eax
  802415:	73 e2                	jae    8023f9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802417:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80241a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80241e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802421:	99                   	cltd   
  802422:	c1 ea 1b             	shr    $0x1b,%edx
  802425:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802428:	83 e1 1f             	and    $0x1f,%ecx
  80242b:	29 d1                	sub    %edx,%ecx
  80242d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802431:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802435:	83 c0 01             	add    $0x1,%eax
  802438:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80243b:	83 c7 01             	add    $0x1,%edi
  80243e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802441:	75 c8                	jne    80240b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802443:	89 f8                	mov    %edi,%eax
  802445:	eb 05                	jmp    80244c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802447:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80244c:	83 c4 1c             	add    $0x1c,%esp
  80244f:	5b                   	pop    %ebx
  802450:	5e                   	pop    %esi
  802451:	5f                   	pop    %edi
  802452:	5d                   	pop    %ebp
  802453:	c3                   	ret    

00802454 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
  802457:	57                   	push   %edi
  802458:	56                   	push   %esi
  802459:	53                   	push   %ebx
  80245a:	83 ec 1c             	sub    $0x1c,%esp
  80245d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802460:	89 3c 24             	mov    %edi,(%esp)
  802463:	e8 a8 f0 ff ff       	call   801510 <fd2data>
  802468:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80246a:	be 00 00 00 00       	mov    $0x0,%esi
  80246f:	eb 3d                	jmp    8024ae <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802471:	85 f6                	test   %esi,%esi
  802473:	74 04                	je     802479 <devpipe_read+0x25>
				return i;
  802475:	89 f0                	mov    %esi,%eax
  802477:	eb 43                	jmp    8024bc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802479:	89 da                	mov    %ebx,%edx
  80247b:	89 f8                	mov    %edi,%eax
  80247d:	e8 f1 fe ff ff       	call   802373 <_pipeisclosed>
  802482:	85 c0                	test   %eax,%eax
  802484:	75 31                	jne    8024b7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802486:	e8 09 e9 ff ff       	call   800d94 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80248b:	8b 03                	mov    (%ebx),%eax
  80248d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802490:	74 df                	je     802471 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802492:	99                   	cltd   
  802493:	c1 ea 1b             	shr    $0x1b,%edx
  802496:	01 d0                	add    %edx,%eax
  802498:	83 e0 1f             	and    $0x1f,%eax
  80249b:	29 d0                	sub    %edx,%eax
  80249d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024a5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024a8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024ab:	83 c6 01             	add    $0x1,%esi
  8024ae:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024b1:	75 d8                	jne    80248b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8024b3:	89 f0                	mov    %esi,%eax
  8024b5:	eb 05                	jmp    8024bc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024b7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8024bc:	83 c4 1c             	add    $0x1c,%esp
  8024bf:	5b                   	pop    %ebx
  8024c0:	5e                   	pop    %esi
  8024c1:	5f                   	pop    %edi
  8024c2:	5d                   	pop    %ebp
  8024c3:	c3                   	ret    

008024c4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	56                   	push   %esi
  8024c8:	53                   	push   %ebx
  8024c9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8024cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024cf:	89 04 24             	mov    %eax,(%esp)
  8024d2:	e8 50 f0 ff ff       	call   801527 <fd_alloc>
  8024d7:	89 c2                	mov    %eax,%edx
  8024d9:	85 d2                	test   %edx,%edx
  8024db:	0f 88 4d 01 00 00    	js     80262e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024e1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024e8:	00 
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024f7:	e8 b7 e8 ff ff       	call   800db3 <sys_page_alloc>
  8024fc:	89 c2                	mov    %eax,%edx
  8024fe:	85 d2                	test   %edx,%edx
  802500:	0f 88 28 01 00 00    	js     80262e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802506:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802509:	89 04 24             	mov    %eax,(%esp)
  80250c:	e8 16 f0 ff ff       	call   801527 <fd_alloc>
  802511:	89 c3                	mov    %eax,%ebx
  802513:	85 c0                	test   %eax,%eax
  802515:	0f 88 fe 00 00 00    	js     802619 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80251b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802522:	00 
  802523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802526:	89 44 24 04          	mov    %eax,0x4(%esp)
  80252a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802531:	e8 7d e8 ff ff       	call   800db3 <sys_page_alloc>
  802536:	89 c3                	mov    %eax,%ebx
  802538:	85 c0                	test   %eax,%eax
  80253a:	0f 88 d9 00 00 00    	js     802619 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	89 04 24             	mov    %eax,(%esp)
  802546:	e8 c5 ef ff ff       	call   801510 <fd2data>
  80254b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80254d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802554:	00 
  802555:	89 44 24 04          	mov    %eax,0x4(%esp)
  802559:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802560:	e8 4e e8 ff ff       	call   800db3 <sys_page_alloc>
  802565:	89 c3                	mov    %eax,%ebx
  802567:	85 c0                	test   %eax,%eax
  802569:	0f 88 97 00 00 00    	js     802606 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80256f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802572:	89 04 24             	mov    %eax,(%esp)
  802575:	e8 96 ef ff ff       	call   801510 <fd2data>
  80257a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802581:	00 
  802582:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802586:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80258d:	00 
  80258e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802592:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802599:	e8 69 e8 ff ff       	call   800e07 <sys_page_map>
  80259e:	89 c3                	mov    %eax,%ebx
  8025a0:	85 c0                	test   %eax,%eax
  8025a2:	78 52                	js     8025f6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8025a4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8025b9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8025c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	89 04 24             	mov    %eax,(%esp)
  8025d4:	e8 27 ef ff ff       	call   801500 <fd2num>
  8025d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025dc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e1:	89 04 24             	mov    %eax,(%esp)
  8025e4:	e8 17 ef ff ff       	call   801500 <fd2num>
  8025e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025ec:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f4:	eb 38                	jmp    80262e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8025f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802601:	e8 54 e8 ff ff       	call   800e5a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802609:	89 44 24 04          	mov    %eax,0x4(%esp)
  80260d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802614:	e8 41 e8 ff ff       	call   800e5a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802620:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802627:	e8 2e e8 ff ff       	call   800e5a <sys_page_unmap>
  80262c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80262e:	83 c4 30             	add    $0x30,%esp
  802631:	5b                   	pop    %ebx
  802632:	5e                   	pop    %esi
  802633:	5d                   	pop    %ebp
  802634:	c3                   	ret    

00802635 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
  802638:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80263b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80263e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802642:	8b 45 08             	mov    0x8(%ebp),%eax
  802645:	89 04 24             	mov    %eax,(%esp)
  802648:	e8 29 ef ff ff       	call   801576 <fd_lookup>
  80264d:	89 c2                	mov    %eax,%edx
  80264f:	85 d2                	test   %edx,%edx
  802651:	78 15                	js     802668 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	89 04 24             	mov    %eax,(%esp)
  802659:	e8 b2 ee ff ff       	call   801510 <fd2data>
	return _pipeisclosed(fd, p);
  80265e:	89 c2                	mov    %eax,%edx
  802660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802663:	e8 0b fd ff ff       	call   802373 <_pipeisclosed>
}
  802668:	c9                   	leave  
  802669:	c3                   	ret    

0080266a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
  80266d:	56                   	push   %esi
  80266e:	53                   	push   %ebx
  80266f:	83 ec 10             	sub    $0x10,%esp
  802672:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802675:	85 f6                	test   %esi,%esi
  802677:	75 24                	jne    80269d <wait+0x33>
  802679:	c7 44 24 0c bf 33 80 	movl   $0x8033bf,0xc(%esp)
  802680:	00 
  802681:	c7 44 24 08 3b 33 80 	movl   $0x80333b,0x8(%esp)
  802688:	00 
  802689:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802690:	00 
  802691:	c7 04 24 ca 33 80 00 	movl   $0x8033ca,(%esp)
  802698:	e8 dd db ff ff       	call   80027a <_panic>
	e = &envs[ENVX(envid)];
  80269d:	89 f3                	mov    %esi,%ebx
  80269f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8026a5:	c1 e3 07             	shl    $0x7,%ebx
  8026a8:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026ae:	eb 05                	jmp    8026b5 <wait+0x4b>
		sys_yield();
  8026b0:	e8 df e6 ff ff       	call   800d94 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026b5:	8b 43 48             	mov    0x48(%ebx),%eax
  8026b8:	39 f0                	cmp    %esi,%eax
  8026ba:	75 07                	jne    8026c3 <wait+0x59>
  8026bc:	8b 43 54             	mov    0x54(%ebx),%eax
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	75 ed                	jne    8026b0 <wait+0x46>
		sys_yield();
}
  8026c3:	83 c4 10             	add    $0x10,%esp
  8026c6:	5b                   	pop    %ebx
  8026c7:	5e                   	pop    %esi
  8026c8:	5d                   	pop    %ebp
  8026c9:	c3                   	ret    
  8026ca:	66 90                	xchg   %ax,%ax
  8026cc:	66 90                	xchg   %ax,%ax
  8026ce:	66 90                	xchg   %ax,%ax

008026d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8026d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d8:	5d                   	pop    %ebp
  8026d9:	c3                   	ret    

008026da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026da:	55                   	push   %ebp
  8026db:	89 e5                	mov    %esp,%ebp
  8026dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8026e0:	c7 44 24 04 d5 33 80 	movl   $0x8033d5,0x4(%esp)
  8026e7:	00 
  8026e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026eb:	89 04 24             	mov    %eax,(%esp)
  8026ee:	e8 a4 e2 ff ff       	call   800997 <strcpy>
	return 0;
}
  8026f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
  8026fd:	57                   	push   %edi
  8026fe:	56                   	push   %esi
  8026ff:	53                   	push   %ebx
  802700:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802706:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80270b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802711:	eb 31                	jmp    802744 <devcons_write+0x4a>
		m = n - tot;
  802713:	8b 75 10             	mov    0x10(%ebp),%esi
  802716:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802718:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80271b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802720:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802723:	89 74 24 08          	mov    %esi,0x8(%esp)
  802727:	03 45 0c             	add    0xc(%ebp),%eax
  80272a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80272e:	89 3c 24             	mov    %edi,(%esp)
  802731:	e8 fe e3 ff ff       	call   800b34 <memmove>
		sys_cputs(buf, m);
  802736:	89 74 24 04          	mov    %esi,0x4(%esp)
  80273a:	89 3c 24             	mov    %edi,(%esp)
  80273d:	e8 a4 e5 ff ff       	call   800ce6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802742:	01 f3                	add    %esi,%ebx
  802744:	89 d8                	mov    %ebx,%eax
  802746:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802749:	72 c8                	jb     802713 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80274b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802751:	5b                   	pop    %ebx
  802752:	5e                   	pop    %esi
  802753:	5f                   	pop    %edi
  802754:	5d                   	pop    %ebp
  802755:	c3                   	ret    

00802756 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802761:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802765:	75 07                	jne    80276e <devcons_read+0x18>
  802767:	eb 2a                	jmp    802793 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802769:	e8 26 e6 ff ff       	call   800d94 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80276e:	66 90                	xchg   %ax,%ax
  802770:	e8 8f e5 ff ff       	call   800d04 <sys_cgetc>
  802775:	85 c0                	test   %eax,%eax
  802777:	74 f0                	je     802769 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802779:	85 c0                	test   %eax,%eax
  80277b:	78 16                	js     802793 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80277d:	83 f8 04             	cmp    $0x4,%eax
  802780:	74 0c                	je     80278e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802782:	8b 55 0c             	mov    0xc(%ebp),%edx
  802785:	88 02                	mov    %al,(%edx)
	return 1;
  802787:	b8 01 00 00 00       	mov    $0x1,%eax
  80278c:	eb 05                	jmp    802793 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80278e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802793:	c9                   	leave  
  802794:	c3                   	ret    

00802795 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802795:	55                   	push   %ebp
  802796:	89 e5                	mov    %esp,%ebp
  802798:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80279b:	8b 45 08             	mov    0x8(%ebp),%eax
  80279e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8027a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8027a8:	00 
  8027a9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027ac:	89 04 24             	mov    %eax,(%esp)
  8027af:	e8 32 e5 ff ff       	call   800ce6 <sys_cputs>
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <getchar>:

int
getchar(void)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
  8027b9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8027bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8027c3:	00 
  8027c4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d2:	e8 33 f0 ff ff       	call   80180a <read>
	if (r < 0)
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	78 0f                	js     8027ea <getchar+0x34>
		return r;
	if (r < 1)
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	7e 06                	jle    8027e5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8027df:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8027e3:	eb 05                	jmp    8027ea <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8027e5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8027ea:	c9                   	leave  
  8027eb:	c3                   	ret    

008027ec <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
  8027ef:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	89 04 24             	mov    %eax,(%esp)
  8027ff:	e8 72 ed ff ff       	call   801576 <fd_lookup>
  802804:	85 c0                	test   %eax,%eax
  802806:	78 11                	js     802819 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802811:	39 10                	cmp    %edx,(%eax)
  802813:	0f 94 c0             	sete   %al
  802816:	0f b6 c0             	movzbl %al,%eax
}
  802819:	c9                   	leave  
  80281a:	c3                   	ret    

0080281b <opencons>:

int
opencons(void)
{
  80281b:	55                   	push   %ebp
  80281c:	89 e5                	mov    %esp,%ebp
  80281e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802821:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802824:	89 04 24             	mov    %eax,(%esp)
  802827:	e8 fb ec ff ff       	call   801527 <fd_alloc>
		return r;
  80282c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80282e:	85 c0                	test   %eax,%eax
  802830:	78 40                	js     802872 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802832:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802839:	00 
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802841:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802848:	e8 66 e5 ff ff       	call   800db3 <sys_page_alloc>
		return r;
  80284d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80284f:	85 c0                	test   %eax,%eax
  802851:	78 1f                	js     802872 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802853:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802868:	89 04 24             	mov    %eax,(%esp)
  80286b:	e8 90 ec ff ff       	call   801500 <fd2num>
  802870:	89 c2                	mov    %eax,%edx
}
  802872:	89 d0                	mov    %edx,%eax
  802874:	c9                   	leave  
  802875:	c3                   	ret    

00802876 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802876:	55                   	push   %ebp
  802877:	89 e5                	mov    %esp,%ebp
  802879:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80287c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802883:	75 68                	jne    8028ed <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  802885:	a1 20 54 80 00       	mov    0x805420,%eax
  80288a:	8b 40 48             	mov    0x48(%eax),%eax
  80288d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802894:	00 
  802895:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80289c:	ee 
  80289d:	89 04 24             	mov    %eax,(%esp)
  8028a0:	e8 0e e5 ff ff       	call   800db3 <sys_page_alloc>
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	74 2c                	je     8028d5 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  8028a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ad:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  8028b4:	e8 ba da ff ff       	call   800373 <cprintf>
			panic("set_pg_fault_handler");
  8028b9:	c7 44 24 08 18 34 80 	movl   $0x803418,0x8(%esp)
  8028c0:	00 
  8028c1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8028c8:	00 
  8028c9:	c7 04 24 2d 34 80 00 	movl   $0x80342d,(%esp)
  8028d0:	e8 a5 d9 ff ff       	call   80027a <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  8028d5:	a1 20 54 80 00       	mov    0x805420,%eax
  8028da:	8b 40 48             	mov    0x48(%eax),%eax
  8028dd:	c7 44 24 04 f7 28 80 	movl   $0x8028f7,0x4(%esp)
  8028e4:	00 
  8028e5:	89 04 24             	mov    %eax,(%esp)
  8028e8:	e8 66 e6 ff ff       	call   800f53 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f0:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028f5:	c9                   	leave  
  8028f6:	c3                   	ret    

008028f7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028f7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028f8:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8028fd:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028ff:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  802902:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  802906:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  802908:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  80290c:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  80290d:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  802910:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  802912:	58                   	pop    %eax
	popl %eax
  802913:	58                   	pop    %eax
	popal
  802914:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802915:	83 c4 04             	add    $0x4,%esp
	popfl
  802918:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802919:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80291a:	c3                   	ret    
  80291b:	66 90                	xchg   %ax,%ax
  80291d:	66 90                	xchg   %ax,%ax
  80291f:	90                   	nop

00802920 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
  802923:	56                   	push   %esi
  802924:	53                   	push   %ebx
  802925:	83 ec 10             	sub    $0x10,%esp
  802928:	8b 75 08             	mov    0x8(%ebp),%esi
  80292b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80292e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802931:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802933:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802938:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80293b:	89 04 24             	mov    %eax,(%esp)
  80293e:	e8 86 e6 ff ff       	call   800fc9 <sys_ipc_recv>
  802943:	85 c0                	test   %eax,%eax
  802945:	74 16                	je     80295d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802947:	85 f6                	test   %esi,%esi
  802949:	74 06                	je     802951 <ipc_recv+0x31>
			*from_env_store = 0;
  80294b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802951:	85 db                	test   %ebx,%ebx
  802953:	74 2c                	je     802981 <ipc_recv+0x61>
			*perm_store = 0;
  802955:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80295b:	eb 24                	jmp    802981 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80295d:	85 f6                	test   %esi,%esi
  80295f:	74 0a                	je     80296b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802961:	a1 20 54 80 00       	mov    0x805420,%eax
  802966:	8b 40 74             	mov    0x74(%eax),%eax
  802969:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80296b:	85 db                	test   %ebx,%ebx
  80296d:	74 0a                	je     802979 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80296f:	a1 20 54 80 00       	mov    0x805420,%eax
  802974:	8b 40 78             	mov    0x78(%eax),%eax
  802977:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802979:	a1 20 54 80 00       	mov    0x805420,%eax
  80297e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802981:	83 c4 10             	add    $0x10,%esp
  802984:	5b                   	pop    %ebx
  802985:	5e                   	pop    %esi
  802986:	5d                   	pop    %ebp
  802987:	c3                   	ret    

00802988 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802988:	55                   	push   %ebp
  802989:	89 e5                	mov    %esp,%ebp
  80298b:	57                   	push   %edi
  80298c:	56                   	push   %esi
  80298d:	53                   	push   %ebx
  80298e:	83 ec 1c             	sub    $0x1c,%esp
  802991:	8b 75 0c             	mov    0xc(%ebp),%esi
  802994:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802997:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80299a:	85 db                	test   %ebx,%ebx
  80299c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8029a1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8029a4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	89 04 24             	mov    %eax,(%esp)
  8029b6:	e8 eb e5 ff ff       	call   800fa6 <sys_ipc_try_send>
	if (r == 0) return;
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	75 22                	jne    8029e1 <ipc_send+0x59>
  8029bf:	eb 4c                	jmp    802a0d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  8029c1:	84 d2                	test   %dl,%dl
  8029c3:	75 48                	jne    802a0d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  8029c5:	e8 ca e3 ff ff       	call   800d94 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  8029ca:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029ce:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	89 04 24             	mov    %eax,(%esp)
  8029dc:	e8 c5 e5 ff ff       	call   800fa6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  8029e1:	85 c0                	test   %eax,%eax
  8029e3:	0f 94 c2             	sete   %dl
  8029e6:	74 d9                	je     8029c1 <ipc_send+0x39>
  8029e8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8029eb:	74 d4                	je     8029c1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  8029ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029f1:	c7 44 24 08 3b 34 80 	movl   $0x80343b,0x8(%esp)
  8029f8:	00 
  8029f9:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802a00:	00 
  802a01:	c7 04 24 49 34 80 00 	movl   $0x803449,(%esp)
  802a08:	e8 6d d8 ff ff       	call   80027a <_panic>
}
  802a0d:	83 c4 1c             	add    $0x1c,%esp
  802a10:	5b                   	pop    %ebx
  802a11:	5e                   	pop    %esi
  802a12:	5f                   	pop    %edi
  802a13:	5d                   	pop    %ebp
  802a14:	c3                   	ret    

00802a15 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a15:	55                   	push   %ebp
  802a16:	89 e5                	mov    %esp,%ebp
  802a18:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a1b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a20:	89 c2                	mov    %eax,%edx
  802a22:	c1 e2 07             	shl    $0x7,%edx
  802a25:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a2b:	8b 52 50             	mov    0x50(%edx),%edx
  802a2e:	39 ca                	cmp    %ecx,%edx
  802a30:	75 0d                	jne    802a3f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802a32:	c1 e0 07             	shl    $0x7,%eax
  802a35:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802a3a:	8b 40 40             	mov    0x40(%eax),%eax
  802a3d:	eb 0e                	jmp    802a4d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802a3f:	83 c0 01             	add    $0x1,%eax
  802a42:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a47:	75 d7                	jne    802a20 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802a49:	66 b8 00 00          	mov    $0x0,%ax
}
  802a4d:	5d                   	pop    %ebp
  802a4e:	c3                   	ret    

00802a4f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a4f:	55                   	push   %ebp
  802a50:	89 e5                	mov    %esp,%ebp
  802a52:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a55:	89 d0                	mov    %edx,%eax
  802a57:	c1 e8 16             	shr    $0x16,%eax
  802a5a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802a61:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802a66:	f6 c1 01             	test   $0x1,%cl
  802a69:	74 1d                	je     802a88 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802a6b:	c1 ea 0c             	shr    $0xc,%edx
  802a6e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802a75:	f6 c2 01             	test   $0x1,%dl
  802a78:	74 0e                	je     802a88 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802a7a:	c1 ea 0c             	shr    $0xc,%edx
  802a7d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802a84:	ef 
  802a85:	0f b7 c0             	movzwl %ax,%eax
}
  802a88:	5d                   	pop    %ebp
  802a89:	c3                   	ret    
  802a8a:	66 90                	xchg   %ax,%ax
  802a8c:	66 90                	xchg   %ax,%ax
  802a8e:	66 90                	xchg   %ax,%ax

00802a90 <__udivdi3>:
  802a90:	55                   	push   %ebp
  802a91:	57                   	push   %edi
  802a92:	56                   	push   %esi
  802a93:	83 ec 0c             	sub    $0xc,%esp
  802a96:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a9a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802a9e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802aa2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802aac:	89 ea                	mov    %ebp,%edx
  802aae:	89 0c 24             	mov    %ecx,(%esp)
  802ab1:	75 2d                	jne    802ae0 <__udivdi3+0x50>
  802ab3:	39 e9                	cmp    %ebp,%ecx
  802ab5:	77 61                	ja     802b18 <__udivdi3+0x88>
  802ab7:	85 c9                	test   %ecx,%ecx
  802ab9:	89 ce                	mov    %ecx,%esi
  802abb:	75 0b                	jne    802ac8 <__udivdi3+0x38>
  802abd:	b8 01 00 00 00       	mov    $0x1,%eax
  802ac2:	31 d2                	xor    %edx,%edx
  802ac4:	f7 f1                	div    %ecx
  802ac6:	89 c6                	mov    %eax,%esi
  802ac8:	31 d2                	xor    %edx,%edx
  802aca:	89 e8                	mov    %ebp,%eax
  802acc:	f7 f6                	div    %esi
  802ace:	89 c5                	mov    %eax,%ebp
  802ad0:	89 f8                	mov    %edi,%eax
  802ad2:	f7 f6                	div    %esi
  802ad4:	89 ea                	mov    %ebp,%edx
  802ad6:	83 c4 0c             	add    $0xc,%esp
  802ad9:	5e                   	pop    %esi
  802ada:	5f                   	pop    %edi
  802adb:	5d                   	pop    %ebp
  802adc:	c3                   	ret    
  802add:	8d 76 00             	lea    0x0(%esi),%esi
  802ae0:	39 e8                	cmp    %ebp,%eax
  802ae2:	77 24                	ja     802b08 <__udivdi3+0x78>
  802ae4:	0f bd e8             	bsr    %eax,%ebp
  802ae7:	83 f5 1f             	xor    $0x1f,%ebp
  802aea:	75 3c                	jne    802b28 <__udivdi3+0x98>
  802aec:	8b 74 24 04          	mov    0x4(%esp),%esi
  802af0:	39 34 24             	cmp    %esi,(%esp)
  802af3:	0f 86 9f 00 00 00    	jbe    802b98 <__udivdi3+0x108>
  802af9:	39 d0                	cmp    %edx,%eax
  802afb:	0f 82 97 00 00 00    	jb     802b98 <__udivdi3+0x108>
  802b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b08:	31 d2                	xor    %edx,%edx
  802b0a:	31 c0                	xor    %eax,%eax
  802b0c:	83 c4 0c             	add    $0xc,%esp
  802b0f:	5e                   	pop    %esi
  802b10:	5f                   	pop    %edi
  802b11:	5d                   	pop    %ebp
  802b12:	c3                   	ret    
  802b13:	90                   	nop
  802b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b18:	89 f8                	mov    %edi,%eax
  802b1a:	f7 f1                	div    %ecx
  802b1c:	31 d2                	xor    %edx,%edx
  802b1e:	83 c4 0c             	add    $0xc,%esp
  802b21:	5e                   	pop    %esi
  802b22:	5f                   	pop    %edi
  802b23:	5d                   	pop    %ebp
  802b24:	c3                   	ret    
  802b25:	8d 76 00             	lea    0x0(%esi),%esi
  802b28:	89 e9                	mov    %ebp,%ecx
  802b2a:	8b 3c 24             	mov    (%esp),%edi
  802b2d:	d3 e0                	shl    %cl,%eax
  802b2f:	89 c6                	mov    %eax,%esi
  802b31:	b8 20 00 00 00       	mov    $0x20,%eax
  802b36:	29 e8                	sub    %ebp,%eax
  802b38:	89 c1                	mov    %eax,%ecx
  802b3a:	d3 ef                	shr    %cl,%edi
  802b3c:	89 e9                	mov    %ebp,%ecx
  802b3e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802b42:	8b 3c 24             	mov    (%esp),%edi
  802b45:	09 74 24 08          	or     %esi,0x8(%esp)
  802b49:	89 d6                	mov    %edx,%esi
  802b4b:	d3 e7                	shl    %cl,%edi
  802b4d:	89 c1                	mov    %eax,%ecx
  802b4f:	89 3c 24             	mov    %edi,(%esp)
  802b52:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b56:	d3 ee                	shr    %cl,%esi
  802b58:	89 e9                	mov    %ebp,%ecx
  802b5a:	d3 e2                	shl    %cl,%edx
  802b5c:	89 c1                	mov    %eax,%ecx
  802b5e:	d3 ef                	shr    %cl,%edi
  802b60:	09 d7                	or     %edx,%edi
  802b62:	89 f2                	mov    %esi,%edx
  802b64:	89 f8                	mov    %edi,%eax
  802b66:	f7 74 24 08          	divl   0x8(%esp)
  802b6a:	89 d6                	mov    %edx,%esi
  802b6c:	89 c7                	mov    %eax,%edi
  802b6e:	f7 24 24             	mull   (%esp)
  802b71:	39 d6                	cmp    %edx,%esi
  802b73:	89 14 24             	mov    %edx,(%esp)
  802b76:	72 30                	jb     802ba8 <__udivdi3+0x118>
  802b78:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b7c:	89 e9                	mov    %ebp,%ecx
  802b7e:	d3 e2                	shl    %cl,%edx
  802b80:	39 c2                	cmp    %eax,%edx
  802b82:	73 05                	jae    802b89 <__udivdi3+0xf9>
  802b84:	3b 34 24             	cmp    (%esp),%esi
  802b87:	74 1f                	je     802ba8 <__udivdi3+0x118>
  802b89:	89 f8                	mov    %edi,%eax
  802b8b:	31 d2                	xor    %edx,%edx
  802b8d:	e9 7a ff ff ff       	jmp    802b0c <__udivdi3+0x7c>
  802b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b98:	31 d2                	xor    %edx,%edx
  802b9a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b9f:	e9 68 ff ff ff       	jmp    802b0c <__udivdi3+0x7c>
  802ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ba8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802bab:	31 d2                	xor    %edx,%edx
  802bad:	83 c4 0c             	add    $0xc,%esp
  802bb0:	5e                   	pop    %esi
  802bb1:	5f                   	pop    %edi
  802bb2:	5d                   	pop    %ebp
  802bb3:	c3                   	ret    
  802bb4:	66 90                	xchg   %ax,%ax
  802bb6:	66 90                	xchg   %ax,%ax
  802bb8:	66 90                	xchg   %ax,%ax
  802bba:	66 90                	xchg   %ax,%ax
  802bbc:	66 90                	xchg   %ax,%ax
  802bbe:	66 90                	xchg   %ax,%ax

00802bc0 <__umoddi3>:
  802bc0:	55                   	push   %ebp
  802bc1:	57                   	push   %edi
  802bc2:	56                   	push   %esi
  802bc3:	83 ec 14             	sub    $0x14,%esp
  802bc6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802bca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802bce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802bd2:	89 c7                	mov    %eax,%edi
  802bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bd8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802bdc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802be0:	89 34 24             	mov    %esi,(%esp)
  802be3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802be7:	85 c0                	test   %eax,%eax
  802be9:	89 c2                	mov    %eax,%edx
  802beb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bef:	75 17                	jne    802c08 <__umoddi3+0x48>
  802bf1:	39 fe                	cmp    %edi,%esi
  802bf3:	76 4b                	jbe    802c40 <__umoddi3+0x80>
  802bf5:	89 c8                	mov    %ecx,%eax
  802bf7:	89 fa                	mov    %edi,%edx
  802bf9:	f7 f6                	div    %esi
  802bfb:	89 d0                	mov    %edx,%eax
  802bfd:	31 d2                	xor    %edx,%edx
  802bff:	83 c4 14             	add    $0x14,%esp
  802c02:	5e                   	pop    %esi
  802c03:	5f                   	pop    %edi
  802c04:	5d                   	pop    %ebp
  802c05:	c3                   	ret    
  802c06:	66 90                	xchg   %ax,%ax
  802c08:	39 f8                	cmp    %edi,%eax
  802c0a:	77 54                	ja     802c60 <__umoddi3+0xa0>
  802c0c:	0f bd e8             	bsr    %eax,%ebp
  802c0f:	83 f5 1f             	xor    $0x1f,%ebp
  802c12:	75 5c                	jne    802c70 <__umoddi3+0xb0>
  802c14:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802c18:	39 3c 24             	cmp    %edi,(%esp)
  802c1b:	0f 87 e7 00 00 00    	ja     802d08 <__umoddi3+0x148>
  802c21:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c25:	29 f1                	sub    %esi,%ecx
  802c27:	19 c7                	sbb    %eax,%edi
  802c29:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c31:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c35:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802c39:	83 c4 14             	add    $0x14,%esp
  802c3c:	5e                   	pop    %esi
  802c3d:	5f                   	pop    %edi
  802c3e:	5d                   	pop    %ebp
  802c3f:	c3                   	ret    
  802c40:	85 f6                	test   %esi,%esi
  802c42:	89 f5                	mov    %esi,%ebp
  802c44:	75 0b                	jne    802c51 <__umoddi3+0x91>
  802c46:	b8 01 00 00 00       	mov    $0x1,%eax
  802c4b:	31 d2                	xor    %edx,%edx
  802c4d:	f7 f6                	div    %esi
  802c4f:	89 c5                	mov    %eax,%ebp
  802c51:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c55:	31 d2                	xor    %edx,%edx
  802c57:	f7 f5                	div    %ebp
  802c59:	89 c8                	mov    %ecx,%eax
  802c5b:	f7 f5                	div    %ebp
  802c5d:	eb 9c                	jmp    802bfb <__umoddi3+0x3b>
  802c5f:	90                   	nop
  802c60:	89 c8                	mov    %ecx,%eax
  802c62:	89 fa                	mov    %edi,%edx
  802c64:	83 c4 14             	add    $0x14,%esp
  802c67:	5e                   	pop    %esi
  802c68:	5f                   	pop    %edi
  802c69:	5d                   	pop    %ebp
  802c6a:	c3                   	ret    
  802c6b:	90                   	nop
  802c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c70:	8b 04 24             	mov    (%esp),%eax
  802c73:	be 20 00 00 00       	mov    $0x20,%esi
  802c78:	89 e9                	mov    %ebp,%ecx
  802c7a:	29 ee                	sub    %ebp,%esi
  802c7c:	d3 e2                	shl    %cl,%edx
  802c7e:	89 f1                	mov    %esi,%ecx
  802c80:	d3 e8                	shr    %cl,%eax
  802c82:	89 e9                	mov    %ebp,%ecx
  802c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c88:	8b 04 24             	mov    (%esp),%eax
  802c8b:	09 54 24 04          	or     %edx,0x4(%esp)
  802c8f:	89 fa                	mov    %edi,%edx
  802c91:	d3 e0                	shl    %cl,%eax
  802c93:	89 f1                	mov    %esi,%ecx
  802c95:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c99:	8b 44 24 10          	mov    0x10(%esp),%eax
  802c9d:	d3 ea                	shr    %cl,%edx
  802c9f:	89 e9                	mov    %ebp,%ecx
  802ca1:	d3 e7                	shl    %cl,%edi
  802ca3:	89 f1                	mov    %esi,%ecx
  802ca5:	d3 e8                	shr    %cl,%eax
  802ca7:	89 e9                	mov    %ebp,%ecx
  802ca9:	09 f8                	or     %edi,%eax
  802cab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802caf:	f7 74 24 04          	divl   0x4(%esp)
  802cb3:	d3 e7                	shl    %cl,%edi
  802cb5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cb9:	89 d7                	mov    %edx,%edi
  802cbb:	f7 64 24 08          	mull   0x8(%esp)
  802cbf:	39 d7                	cmp    %edx,%edi
  802cc1:	89 c1                	mov    %eax,%ecx
  802cc3:	89 14 24             	mov    %edx,(%esp)
  802cc6:	72 2c                	jb     802cf4 <__umoddi3+0x134>
  802cc8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802ccc:	72 22                	jb     802cf0 <__umoddi3+0x130>
  802cce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802cd2:	29 c8                	sub    %ecx,%eax
  802cd4:	19 d7                	sbb    %edx,%edi
  802cd6:	89 e9                	mov    %ebp,%ecx
  802cd8:	89 fa                	mov    %edi,%edx
  802cda:	d3 e8                	shr    %cl,%eax
  802cdc:	89 f1                	mov    %esi,%ecx
  802cde:	d3 e2                	shl    %cl,%edx
  802ce0:	89 e9                	mov    %ebp,%ecx
  802ce2:	d3 ef                	shr    %cl,%edi
  802ce4:	09 d0                	or     %edx,%eax
  802ce6:	89 fa                	mov    %edi,%edx
  802ce8:	83 c4 14             	add    $0x14,%esp
  802ceb:	5e                   	pop    %esi
  802cec:	5f                   	pop    %edi
  802ced:	5d                   	pop    %ebp
  802cee:	c3                   	ret    
  802cef:	90                   	nop
  802cf0:	39 d7                	cmp    %edx,%edi
  802cf2:	75 da                	jne    802cce <__umoddi3+0x10e>
  802cf4:	8b 14 24             	mov    (%esp),%edx
  802cf7:	89 c1                	mov    %eax,%ecx
  802cf9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802cfd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802d01:	eb cb                	jmp    802cce <__umoddi3+0x10e>
  802d03:	90                   	nop
  802d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d08:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802d0c:	0f 82 0f ff ff ff    	jb     802c21 <__umoddi3+0x61>
  802d12:	e9 1a ff ff ff       	jmp    802c31 <__umoddi3+0x71>
