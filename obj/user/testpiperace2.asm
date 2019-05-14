
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 b9 01 00 00       	call   8001ea <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	c7 04 24 a0 2c 80 00 	movl   $0x802ca0,(%esp)
  800043:	e8 fc 02 00 00       	call   800344 <cprintf>
	if ((r = pipe(p)) < 0)
  800048:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80004b:	89 04 24             	mov    %eax,(%esp)
  80004e:	e8 41 24 00 00       	call   802494 <pipe>
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x44>
		panic("pipe: %e", r);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 ee 2c 80 	movl   $0x802cee,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 f7 2c 80 00 	movl   $0x802cf7,(%esp)
  800072:	e8 d4 01 00 00       	call   80024b <_panic>
	if ((r = fork()) < 0)
  800077:	e8 54 11 00 00       	call   8011d0 <fork>
  80007c:	89 c7                	mov    %eax,%edi
  80007e:	85 c0                	test   %eax,%eax
  800080:	79 20                	jns    8000a2 <umain+0x6f>
		panic("fork: %e", r);
  800082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800086:	c7 44 24 08 0c 2d 80 	movl   $0x802d0c,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 f7 2c 80 00 	movl   $0x802cf7,(%esp)
  80009d:	e8 a9 01 00 00       	call   80024b <_panic>
	if (r == 0) {
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	75 75                	jne    80011b <umain+0xe8>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  8000a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000a9:	89 04 24             	mov    %eax,(%esp)
  8000ac:	e8 c6 15 00 00       	call   801677 <close>
		for (i = 0; i < 200; i++) {
  8000b1:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (i % 10 == 0)
  8000b6:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000bb:	89 d8                	mov    %ebx,%eax
  8000bd:	f7 ee                	imul   %esi
  8000bf:	c1 fa 02             	sar    $0x2,%edx
  8000c2:	89 d8                	mov    %ebx,%eax
  8000c4:	c1 f8 1f             	sar    $0x1f,%eax
  8000c7:	29 c2                	sub    %eax,%edx
  8000c9:	8d 04 92             	lea    (%edx,%edx,4),%eax
  8000cc:	01 c0                	add    %eax,%eax
  8000ce:	39 c3                	cmp    %eax,%ebx
  8000d0:	75 10                	jne    8000e2 <umain+0xaf>
				cprintf("%d.", i);
  8000d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d6:	c7 04 24 15 2d 80 00 	movl   $0x802d15,(%esp)
  8000dd:	e8 62 02 00 00       	call   800344 <cprintf>
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  8000e2:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8000e9:	00 
  8000ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ed:	89 04 24             	mov    %eax,(%esp)
  8000f0:	e8 d7 15 00 00       	call   8016cc <dup>
			sys_yield();
  8000f5:	e8 6a 0c 00 00       	call   800d64 <sys_yield>
			close(10);
  8000fa:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800101:	e8 71 15 00 00       	call   801677 <close>
			sys_yield();
  800106:	e8 59 0c 00 00       	call   800d64 <sys_yield>
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  80010b:	83 c3 01             	add    $0x1,%ebx
  80010e:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800114:	75 a5                	jne    8000bb <umain+0x88>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  800116:	e8 17 01 00 00       	call   800232 <exit>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  80011b:	89 fb                	mov    %edi,%ebx
  80011d:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  800123:	c1 e3 07             	shl    $0x7,%ebx
  800126:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80012c:	eb 28                	jmp    800156 <umain+0x123>
		if (pipeisclosed(p[0]) != 0) {
  80012e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800131:	89 04 24             	mov    %eax,(%esp)
  800134:	e8 cc 24 00 00       	call   802605 <pipeisclosed>
  800139:	85 c0                	test   %eax,%eax
  80013b:	74 19                	je     800156 <umain+0x123>
			cprintf("\nRACE: pipe appears closed\n");
  80013d:	c7 04 24 19 2d 80 00 	movl   $0x802d19,(%esp)
  800144:	e8 fb 01 00 00       	call   800344 <cprintf>
			sys_env_destroy(r);
  800149:	89 3c 24             	mov    %edi,(%esp)
  80014c:	e8 a2 0b 00 00       	call   800cf3 <sys_env_destroy>
			exit();
  800151:	e8 dc 00 00 00       	call   800232 <exit>
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800156:	8b 43 54             	mov    0x54(%ebx),%eax
  800159:	83 f8 02             	cmp    $0x2,%eax
  80015c:	74 d0                	je     80012e <umain+0xfb>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  80015e:	c7 04 24 35 2d 80 00 	movl   $0x802d35,(%esp)
  800165:	e8 da 01 00 00       	call   800344 <cprintf>
	if (pipeisclosed(p[0]))
  80016a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016d:	89 04 24             	mov    %eax,(%esp)
  800170:	e8 90 24 00 00       	call   802605 <pipeisclosed>
  800175:	85 c0                	test   %eax,%eax
  800177:	74 1c                	je     800195 <umain+0x162>
		panic("somehow the other end of p[0] got closed!");
  800179:	c7 44 24 08 c4 2c 80 	movl   $0x802cc4,0x8(%esp)
  800180:	00 
  800181:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  800188:	00 
  800189:	c7 04 24 f7 2c 80 00 	movl   $0x802cf7,(%esp)
  800190:	e8 b6 00 00 00       	call   80024b <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800195:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019f:	89 04 24             	mov    %eax,(%esp)
  8001a2:	e8 9f 13 00 00       	call   801546 <fd_lookup>
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	79 20                	jns    8001cb <umain+0x198>
		panic("cannot look up p[0]: %e", r);
  8001ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001af:	c7 44 24 08 4b 2d 80 	movl   $0x802d4b,0x8(%esp)
  8001b6:	00 
  8001b7:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
  8001be:	00 
  8001bf:	c7 04 24 f7 2c 80 00 	movl   $0x802cf7,(%esp)
  8001c6:	e8 80 00 00 00       	call   80024b <_panic>
	(void) fd2data(fd);
  8001cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ce:	89 04 24             	mov    %eax,(%esp)
  8001d1:	e8 0a 13 00 00       	call   8014e0 <fd2data>
	cprintf("race didn't happen\n");
  8001d6:	c7 04 24 63 2d 80 00 	movl   $0x802d63,(%esp)
  8001dd:	e8 62 01 00 00       	call   800344 <cprintf>
}
  8001e2:	83 c4 2c             	add    $0x2c,%esp
  8001e5:	5b                   	pop    %ebx
  8001e6:	5e                   	pop    %esi
  8001e7:	5f                   	pop    %edi
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    

008001ea <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	56                   	push   %esi
  8001ee:	53                   	push   %ebx
  8001ef:	83 ec 10             	sub    $0x10,%esp
  8001f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001f5:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001f8:	e8 48 0b 00 00       	call   800d45 <sys_getenvid>
  8001fd:	25 ff 03 00 00       	and    $0x3ff,%eax
  800202:	c1 e0 07             	shl    $0x7,%eax
  800205:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80020a:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80020f:	85 db                	test   %ebx,%ebx
  800211:	7e 07                	jle    80021a <libmain+0x30>
		binaryname = argv[0];
  800213:	8b 06                	mov    (%esi),%eax
  800215:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80021a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80021e:	89 1c 24             	mov    %ebx,(%esp)
  800221:	e8 0d fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800226:	e8 07 00 00 00       	call   800232 <exit>
}
  80022b:	83 c4 10             	add    $0x10,%esp
  80022e:	5b                   	pop    %ebx
  80022f:	5e                   	pop    %esi
  800230:	5d                   	pop    %ebp
  800231:	c3                   	ret    

00800232 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800238:	e8 6d 14 00 00       	call   8016aa <close_all>
	sys_env_destroy(0);
  80023d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800244:	e8 aa 0a 00 00       	call   800cf3 <sys_env_destroy>
}
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	56                   	push   %esi
  80024f:	53                   	push   %ebx
  800250:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800253:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800256:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80025c:	e8 e4 0a 00 00       	call   800d45 <sys_getenvid>
  800261:	8b 55 0c             	mov    0xc(%ebp),%edx
  800264:	89 54 24 10          	mov    %edx,0x10(%esp)
  800268:	8b 55 08             	mov    0x8(%ebp),%edx
  80026b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80026f:	89 74 24 08          	mov    %esi,0x8(%esp)
  800273:	89 44 24 04          	mov    %eax,0x4(%esp)
  800277:	c7 04 24 84 2d 80 00 	movl   $0x802d84,(%esp)
  80027e:	e8 c1 00 00 00       	call   800344 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800283:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800287:	8b 45 10             	mov    0x10(%ebp),%eax
  80028a:	89 04 24             	mov    %eax,(%esp)
  80028d:	e8 51 00 00 00       	call   8002e3 <vcprintf>
	cprintf("\n");
  800292:	c7 04 24 d8 32 80 00 	movl   $0x8032d8,(%esp)
  800299:	e8 a6 00 00 00       	call   800344 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80029e:	cc                   	int3   
  80029f:	eb fd                	jmp    80029e <_panic+0x53>

008002a1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002a1:	55                   	push   %ebp
  8002a2:	89 e5                	mov    %esp,%ebp
  8002a4:	53                   	push   %ebx
  8002a5:	83 ec 14             	sub    $0x14,%esp
  8002a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002ab:	8b 13                	mov    (%ebx),%edx
  8002ad:	8d 42 01             	lea    0x1(%edx),%eax
  8002b0:	89 03                	mov    %eax,(%ebx)
  8002b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002b5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002b9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002be:	75 19                	jne    8002d9 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002c0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002c7:	00 
  8002c8:	8d 43 08             	lea    0x8(%ebx),%eax
  8002cb:	89 04 24             	mov    %eax,(%esp)
  8002ce:	e8 e3 09 00 00       	call   800cb6 <sys_cputs>
		b->idx = 0;
  8002d3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002d9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002dd:	83 c4 14             	add    $0x14,%esp
  8002e0:	5b                   	pop    %ebx
  8002e1:	5d                   	pop    %ebp
  8002e2:	c3                   	ret    

008002e3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002ec:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002f3:	00 00 00 
	b.cnt = 0;
  8002f6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002fd:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800300:	8b 45 0c             	mov    0xc(%ebp),%eax
  800303:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800307:	8b 45 08             	mov    0x8(%ebp),%eax
  80030a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80030e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800314:	89 44 24 04          	mov    %eax,0x4(%esp)
  800318:	c7 04 24 a1 02 80 00 	movl   $0x8002a1,(%esp)
  80031f:	e8 aa 01 00 00       	call   8004ce <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800324:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80032a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800334:	89 04 24             	mov    %eax,(%esp)
  800337:	e8 7a 09 00 00       	call   800cb6 <sys_cputs>

	return b.cnt;
}
  80033c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800342:	c9                   	leave  
  800343:	c3                   	ret    

00800344 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80034a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80034d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800351:	8b 45 08             	mov    0x8(%ebp),%eax
  800354:	89 04 24             	mov    %eax,(%esp)
  800357:	e8 87 ff ff ff       	call   8002e3 <vcprintf>
	va_end(ap);

	return cnt;
}
  80035c:	c9                   	leave  
  80035d:	c3                   	ret    
  80035e:	66 90                	xchg   %ax,%ax

00800360 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	57                   	push   %edi
  800364:	56                   	push   %esi
  800365:	53                   	push   %ebx
  800366:	83 ec 3c             	sub    $0x3c,%esp
  800369:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036c:	89 d7                	mov    %edx,%edi
  80036e:	8b 45 08             	mov    0x8(%ebp),%eax
  800371:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800374:	8b 45 0c             	mov    0xc(%ebp),%eax
  800377:	89 c3                	mov    %eax,%ebx
  800379:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800382:	b9 00 00 00 00       	mov    $0x0,%ecx
  800387:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80038a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80038d:	39 d9                	cmp    %ebx,%ecx
  80038f:	72 05                	jb     800396 <printnum+0x36>
  800391:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800394:	77 69                	ja     8003ff <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800396:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800399:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80039d:	83 ee 01             	sub    $0x1,%esi
  8003a0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003ac:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003b0:	89 c3                	mov    %eax,%ebx
  8003b2:	89 d6                	mov    %edx,%esi
  8003b4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003ba:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003be:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8003c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c5:	89 04 24             	mov    %eax,(%esp)
  8003c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003cf:	e8 2c 26 00 00       	call   802a00 <__udivdi3>
  8003d4:	89 d9                	mov    %ebx,%ecx
  8003d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003da:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003de:	89 04 24             	mov    %eax,(%esp)
  8003e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003e5:	89 fa                	mov    %edi,%edx
  8003e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ea:	e8 71 ff ff ff       	call   800360 <printnum>
  8003ef:	eb 1b                	jmp    80040c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003f1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003f8:	89 04 24             	mov    %eax,(%esp)
  8003fb:	ff d3                	call   *%ebx
  8003fd:	eb 03                	jmp    800402 <printnum+0xa2>
  8003ff:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800402:	83 ee 01             	sub    $0x1,%esi
  800405:	85 f6                	test   %esi,%esi
  800407:	7f e8                	jg     8003f1 <printnum+0x91>
  800409:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80040c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800410:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800414:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800417:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80041a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80041e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800422:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800425:	89 04 24             	mov    %eax,(%esp)
  800428:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80042b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80042f:	e8 fc 26 00 00       	call   802b30 <__umoddi3>
  800434:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800438:	0f be 80 a7 2d 80 00 	movsbl 0x802da7(%eax),%eax
  80043f:	89 04 24             	mov    %eax,(%esp)
  800442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800445:	ff d0                	call   *%eax
}
  800447:	83 c4 3c             	add    $0x3c,%esp
  80044a:	5b                   	pop    %ebx
  80044b:	5e                   	pop    %esi
  80044c:	5f                   	pop    %edi
  80044d:	5d                   	pop    %ebp
  80044e:	c3                   	ret    

0080044f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80044f:	55                   	push   %ebp
  800450:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800452:	83 fa 01             	cmp    $0x1,%edx
  800455:	7e 0e                	jle    800465 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800457:	8b 10                	mov    (%eax),%edx
  800459:	8d 4a 08             	lea    0x8(%edx),%ecx
  80045c:	89 08                	mov    %ecx,(%eax)
  80045e:	8b 02                	mov    (%edx),%eax
  800460:	8b 52 04             	mov    0x4(%edx),%edx
  800463:	eb 22                	jmp    800487 <getuint+0x38>
	else if (lflag)
  800465:	85 d2                	test   %edx,%edx
  800467:	74 10                	je     800479 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800469:	8b 10                	mov    (%eax),%edx
  80046b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80046e:	89 08                	mov    %ecx,(%eax)
  800470:	8b 02                	mov    (%edx),%eax
  800472:	ba 00 00 00 00       	mov    $0x0,%edx
  800477:	eb 0e                	jmp    800487 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800479:	8b 10                	mov    (%eax),%edx
  80047b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80047e:	89 08                	mov    %ecx,(%eax)
  800480:	8b 02                	mov    (%edx),%eax
  800482:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800487:	5d                   	pop    %ebp
  800488:	c3                   	ret    

00800489 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800489:	55                   	push   %ebp
  80048a:	89 e5                	mov    %esp,%ebp
  80048c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80048f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800493:	8b 10                	mov    (%eax),%edx
  800495:	3b 50 04             	cmp    0x4(%eax),%edx
  800498:	73 0a                	jae    8004a4 <sprintputch+0x1b>
		*b->buf++ = ch;
  80049a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80049d:	89 08                	mov    %ecx,(%eax)
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	88 02                	mov    %al,(%edx)
}
  8004a4:	5d                   	pop    %ebp
  8004a5:	c3                   	ret    

008004a6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004ac:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c4:	89 04 24             	mov    %eax,(%esp)
  8004c7:	e8 02 00 00 00       	call   8004ce <vprintfmt>
	va_end(ap);
}
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	57                   	push   %edi
  8004d2:	56                   	push   %esi
  8004d3:	53                   	push   %ebx
  8004d4:	83 ec 3c             	sub    $0x3c,%esp
  8004d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8004da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004dd:	eb 14                	jmp    8004f3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004df:	85 c0                	test   %eax,%eax
  8004e1:	0f 84 b3 03 00 00    	je     80089a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8004e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004eb:	89 04 24             	mov    %eax,(%esp)
  8004ee:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f1:	89 f3                	mov    %esi,%ebx
  8004f3:	8d 73 01             	lea    0x1(%ebx),%esi
  8004f6:	0f b6 03             	movzbl (%ebx),%eax
  8004f9:	83 f8 25             	cmp    $0x25,%eax
  8004fc:	75 e1                	jne    8004df <vprintfmt+0x11>
  8004fe:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800502:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800509:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800510:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800517:	ba 00 00 00 00       	mov    $0x0,%edx
  80051c:	eb 1d                	jmp    80053b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800520:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800524:	eb 15                	jmp    80053b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800526:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800528:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80052c:	eb 0d                	jmp    80053b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80052e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800531:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800534:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80053e:	0f b6 0e             	movzbl (%esi),%ecx
  800541:	0f b6 c1             	movzbl %cl,%eax
  800544:	83 e9 23             	sub    $0x23,%ecx
  800547:	80 f9 55             	cmp    $0x55,%cl
  80054a:	0f 87 2a 03 00 00    	ja     80087a <vprintfmt+0x3ac>
  800550:	0f b6 c9             	movzbl %cl,%ecx
  800553:	ff 24 8d e0 2e 80 00 	jmp    *0x802ee0(,%ecx,4)
  80055a:	89 de                	mov    %ebx,%esi
  80055c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800561:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800564:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800568:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80056b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80056e:	83 fb 09             	cmp    $0x9,%ebx
  800571:	77 36                	ja     8005a9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800573:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800576:	eb e9                	jmp    800561 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800578:	8b 45 14             	mov    0x14(%ebp),%eax
  80057b:	8d 48 04             	lea    0x4(%eax),%ecx
  80057e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800581:	8b 00                	mov    (%eax),%eax
  800583:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800586:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800588:	eb 22                	jmp    8005ac <vprintfmt+0xde>
  80058a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80058d:	85 c9                	test   %ecx,%ecx
  80058f:	b8 00 00 00 00       	mov    $0x0,%eax
  800594:	0f 49 c1             	cmovns %ecx,%eax
  800597:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059a:	89 de                	mov    %ebx,%esi
  80059c:	eb 9d                	jmp    80053b <vprintfmt+0x6d>
  80059e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005a0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8005a7:	eb 92                	jmp    80053b <vprintfmt+0x6d>
  8005a9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8005ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005b0:	79 89                	jns    80053b <vprintfmt+0x6d>
  8005b2:	e9 77 ff ff ff       	jmp    80052e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005b7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ba:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005bc:	e9 7a ff ff ff       	jmp    80053b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	8d 50 04             	lea    0x4(%eax),%edx
  8005c7:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ce:	8b 00                	mov    (%eax),%eax
  8005d0:	89 04 24             	mov    %eax,(%esp)
  8005d3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005d6:	e9 18 ff ff ff       	jmp    8004f3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	8d 50 04             	lea    0x4(%eax),%edx
  8005e1:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e4:	8b 00                	mov    (%eax),%eax
  8005e6:	99                   	cltd   
  8005e7:	31 d0                	xor    %edx,%eax
  8005e9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005eb:	83 f8 11             	cmp    $0x11,%eax
  8005ee:	7f 0b                	jg     8005fb <vprintfmt+0x12d>
  8005f0:	8b 14 85 40 30 80 00 	mov    0x803040(,%eax,4),%edx
  8005f7:	85 d2                	test   %edx,%edx
  8005f9:	75 20                	jne    80061b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8005fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005ff:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  800606:	00 
  800607:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80060b:	8b 45 08             	mov    0x8(%ebp),%eax
  80060e:	89 04 24             	mov    %eax,(%esp)
  800611:	e8 90 fe ff ff       	call   8004a6 <printfmt>
  800616:	e9 d8 fe ff ff       	jmp    8004f3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80061b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80061f:	c7 44 24 08 6d 32 80 	movl   $0x80326d,0x8(%esp)
  800626:	00 
  800627:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	89 04 24             	mov    %eax,(%esp)
  800631:	e8 70 fe ff ff       	call   8004a6 <printfmt>
  800636:	e9 b8 fe ff ff       	jmp    8004f3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80063b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80063e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800641:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8d 50 04             	lea    0x4(%eax),%edx
  80064a:	89 55 14             	mov    %edx,0x14(%ebp)
  80064d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80064f:	85 f6                	test   %esi,%esi
  800651:	b8 b8 2d 80 00       	mov    $0x802db8,%eax
  800656:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800659:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80065d:	0f 84 97 00 00 00    	je     8006fa <vprintfmt+0x22c>
  800663:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800667:	0f 8e 9b 00 00 00    	jle    800708 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80066d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800671:	89 34 24             	mov    %esi,(%esp)
  800674:	e8 cf 02 00 00       	call   800948 <strnlen>
  800679:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80067c:	29 c2                	sub    %eax,%edx
  80067e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800681:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800685:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800688:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80068b:	8b 75 08             	mov    0x8(%ebp),%esi
  80068e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800691:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800693:	eb 0f                	jmp    8006a4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800695:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800699:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80069c:	89 04 24             	mov    %eax,(%esp)
  80069f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a1:	83 eb 01             	sub    $0x1,%ebx
  8006a4:	85 db                	test   %ebx,%ebx
  8006a6:	7f ed                	jg     800695 <vprintfmt+0x1c7>
  8006a8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8006ab:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006ae:	85 d2                	test   %edx,%edx
  8006b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006b5:	0f 49 c2             	cmovns %edx,%eax
  8006b8:	29 c2                	sub    %eax,%edx
  8006ba:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006bd:	89 d7                	mov    %edx,%edi
  8006bf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006c2:	eb 50                	jmp    800714 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006c8:	74 1e                	je     8006e8 <vprintfmt+0x21a>
  8006ca:	0f be d2             	movsbl %dl,%edx
  8006cd:	83 ea 20             	sub    $0x20,%edx
  8006d0:	83 fa 5e             	cmp    $0x5e,%edx
  8006d3:	76 13                	jbe    8006e8 <vprintfmt+0x21a>
					putch('?', putdat);
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006dc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006e3:	ff 55 08             	call   *0x8(%ebp)
  8006e6:	eb 0d                	jmp    8006f5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8006e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006eb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006ef:	89 04 24             	mov    %eax,(%esp)
  8006f2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f5:	83 ef 01             	sub    $0x1,%edi
  8006f8:	eb 1a                	jmp    800714 <vprintfmt+0x246>
  8006fa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006fd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800700:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800703:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800706:	eb 0c                	jmp    800714 <vprintfmt+0x246>
  800708:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80070b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80070e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800711:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800714:	83 c6 01             	add    $0x1,%esi
  800717:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80071b:	0f be c2             	movsbl %dl,%eax
  80071e:	85 c0                	test   %eax,%eax
  800720:	74 27                	je     800749 <vprintfmt+0x27b>
  800722:	85 db                	test   %ebx,%ebx
  800724:	78 9e                	js     8006c4 <vprintfmt+0x1f6>
  800726:	83 eb 01             	sub    $0x1,%ebx
  800729:	79 99                	jns    8006c4 <vprintfmt+0x1f6>
  80072b:	89 f8                	mov    %edi,%eax
  80072d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800730:	8b 75 08             	mov    0x8(%ebp),%esi
  800733:	89 c3                	mov    %eax,%ebx
  800735:	eb 1a                	jmp    800751 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800737:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80073b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800742:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800744:	83 eb 01             	sub    $0x1,%ebx
  800747:	eb 08                	jmp    800751 <vprintfmt+0x283>
  800749:	89 fb                	mov    %edi,%ebx
  80074b:	8b 75 08             	mov    0x8(%ebp),%esi
  80074e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800751:	85 db                	test   %ebx,%ebx
  800753:	7f e2                	jg     800737 <vprintfmt+0x269>
  800755:	89 75 08             	mov    %esi,0x8(%ebp)
  800758:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80075b:	e9 93 fd ff ff       	jmp    8004f3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800760:	83 fa 01             	cmp    $0x1,%edx
  800763:	7e 16                	jle    80077b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8d 50 08             	lea    0x8(%eax),%edx
  80076b:	89 55 14             	mov    %edx,0x14(%ebp)
  80076e:	8b 50 04             	mov    0x4(%eax),%edx
  800771:	8b 00                	mov    (%eax),%eax
  800773:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800776:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800779:	eb 32                	jmp    8007ad <vprintfmt+0x2df>
	else if (lflag)
  80077b:	85 d2                	test   %edx,%edx
  80077d:	74 18                	je     800797 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8d 50 04             	lea    0x4(%eax),%edx
  800785:	89 55 14             	mov    %edx,0x14(%ebp)
  800788:	8b 30                	mov    (%eax),%esi
  80078a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80078d:	89 f0                	mov    %esi,%eax
  80078f:	c1 f8 1f             	sar    $0x1f,%eax
  800792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800795:	eb 16                	jmp    8007ad <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8d 50 04             	lea    0x4(%eax),%edx
  80079d:	89 55 14             	mov    %edx,0x14(%ebp)
  8007a0:	8b 30                	mov    (%eax),%esi
  8007a2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007a5:	89 f0                	mov    %esi,%eax
  8007a7:	c1 f8 1f             	sar    $0x1f,%eax
  8007aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007bc:	0f 89 80 00 00 00    	jns    800842 <vprintfmt+0x374>
				putch('-', putdat);
  8007c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007cd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007d6:	f7 d8                	neg    %eax
  8007d8:	83 d2 00             	adc    $0x0,%edx
  8007db:	f7 da                	neg    %edx
			}
			base = 10;
  8007dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007e2:	eb 5e                	jmp    800842 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e7:	e8 63 fc ff ff       	call   80044f <getuint>
			base = 10;
  8007ec:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007f1:	eb 4f                	jmp    800842 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8007f3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f6:	e8 54 fc ff ff       	call   80044f <getuint>
			base = 8;
  8007fb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800800:	eb 40                	jmp    800842 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800802:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800806:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80080d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800810:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800814:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80081b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	8d 50 04             	lea    0x4(%eax),%edx
  800824:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800827:	8b 00                	mov    (%eax),%eax
  800829:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80082e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800833:	eb 0d                	jmp    800842 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800835:	8d 45 14             	lea    0x14(%ebp),%eax
  800838:	e8 12 fc ff ff       	call   80044f <getuint>
			base = 16;
  80083d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800842:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800846:	89 74 24 10          	mov    %esi,0x10(%esp)
  80084a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80084d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800851:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800855:	89 04 24             	mov    %eax,(%esp)
  800858:	89 54 24 04          	mov    %edx,0x4(%esp)
  80085c:	89 fa                	mov    %edi,%edx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	e8 fa fa ff ff       	call   800360 <printnum>
			break;
  800866:	e9 88 fc ff ff       	jmp    8004f3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80086b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80086f:	89 04 24             	mov    %eax,(%esp)
  800872:	ff 55 08             	call   *0x8(%ebp)
			break;
  800875:	e9 79 fc ff ff       	jmp    8004f3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80087a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80087e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800885:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800888:	89 f3                	mov    %esi,%ebx
  80088a:	eb 03                	jmp    80088f <vprintfmt+0x3c1>
  80088c:	83 eb 01             	sub    $0x1,%ebx
  80088f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800893:	75 f7                	jne    80088c <vprintfmt+0x3be>
  800895:	e9 59 fc ff ff       	jmp    8004f3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80089a:	83 c4 3c             	add    $0x3c,%esp
  80089d:	5b                   	pop    %ebx
  80089e:	5e                   	pop    %esi
  80089f:	5f                   	pop    %edi
  8008a0:	5d                   	pop    %ebp
  8008a1:	c3                   	ret    

008008a2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	83 ec 28             	sub    $0x28,%esp
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008b1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008b5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008bf:	85 c0                	test   %eax,%eax
  8008c1:	74 30                	je     8008f3 <vsnprintf+0x51>
  8008c3:	85 d2                	test   %edx,%edx
  8008c5:	7e 2c                	jle    8008f3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008dc:	c7 04 24 89 04 80 00 	movl   $0x800489,(%esp)
  8008e3:	e8 e6 fb ff ff       	call   8004ce <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008eb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f1:	eb 05                	jmp    8008f8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008f8:	c9                   	leave  
  8008f9:	c3                   	ret    

008008fa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800900:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800903:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800907:	8b 45 10             	mov    0x10(%ebp),%eax
  80090a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80090e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800911:	89 44 24 04          	mov    %eax,0x4(%esp)
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	89 04 24             	mov    %eax,(%esp)
  80091b:	e8 82 ff ff ff       	call   8008a2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800920:	c9                   	leave  
  800921:	c3                   	ret    
  800922:	66 90                	xchg   %ax,%ax
  800924:	66 90                	xchg   %ax,%ax
  800926:	66 90                	xchg   %ax,%ax
  800928:	66 90                	xchg   %ax,%ax
  80092a:	66 90                	xchg   %ax,%ax
  80092c:	66 90                	xchg   %ax,%ax
  80092e:	66 90                	xchg   %ax,%ax

00800930 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800936:	b8 00 00 00 00       	mov    $0x0,%eax
  80093b:	eb 03                	jmp    800940 <strlen+0x10>
		n++;
  80093d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800940:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800944:	75 f7                	jne    80093d <strlen+0xd>
		n++;
	return n;
}
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80094e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800951:	b8 00 00 00 00       	mov    $0x0,%eax
  800956:	eb 03                	jmp    80095b <strnlen+0x13>
		n++;
  800958:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80095b:	39 d0                	cmp    %edx,%eax
  80095d:	74 06                	je     800965 <strnlen+0x1d>
  80095f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800963:	75 f3                	jne    800958 <strnlen+0x10>
		n++;
	return n;
}
  800965:	5d                   	pop    %ebp
  800966:	c3                   	ret    

00800967 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	53                   	push   %ebx
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800971:	89 c2                	mov    %eax,%edx
  800973:	83 c2 01             	add    $0x1,%edx
  800976:	83 c1 01             	add    $0x1,%ecx
  800979:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80097d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800980:	84 db                	test   %bl,%bl
  800982:	75 ef                	jne    800973 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800984:	5b                   	pop    %ebx
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    

00800987 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	53                   	push   %ebx
  80098b:	83 ec 08             	sub    $0x8,%esp
  80098e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800991:	89 1c 24             	mov    %ebx,(%esp)
  800994:	e8 97 ff ff ff       	call   800930 <strlen>
	strcpy(dst + len, src);
  800999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099c:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009a0:	01 d8                	add    %ebx,%eax
  8009a2:	89 04 24             	mov    %eax,(%esp)
  8009a5:	e8 bd ff ff ff       	call   800967 <strcpy>
	return dst;
}
  8009aa:	89 d8                	mov    %ebx,%eax
  8009ac:	83 c4 08             	add    $0x8,%esp
  8009af:	5b                   	pop    %ebx
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    

008009b2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	56                   	push   %esi
  8009b6:	53                   	push   %ebx
  8009b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009bd:	89 f3                	mov    %esi,%ebx
  8009bf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009c2:	89 f2                	mov    %esi,%edx
  8009c4:	eb 0f                	jmp    8009d5 <strncpy+0x23>
		*dst++ = *src;
  8009c6:	83 c2 01             	add    $0x1,%edx
  8009c9:	0f b6 01             	movzbl (%ecx),%eax
  8009cc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009cf:	80 39 01             	cmpb   $0x1,(%ecx)
  8009d2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009d5:	39 da                	cmp    %ebx,%edx
  8009d7:	75 ed                	jne    8009c6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009d9:	89 f0                	mov    %esi,%eax
  8009db:	5b                   	pop    %ebx
  8009dc:	5e                   	pop    %esi
  8009dd:	5d                   	pop    %ebp
  8009de:	c3                   	ret    

008009df <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	56                   	push   %esi
  8009e3:	53                   	push   %ebx
  8009e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009ed:	89 f0                	mov    %esi,%eax
  8009ef:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009f3:	85 c9                	test   %ecx,%ecx
  8009f5:	75 0b                	jne    800a02 <strlcpy+0x23>
  8009f7:	eb 1d                	jmp    800a16 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009f9:	83 c0 01             	add    $0x1,%eax
  8009fc:	83 c2 01             	add    $0x1,%edx
  8009ff:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a02:	39 d8                	cmp    %ebx,%eax
  800a04:	74 0b                	je     800a11 <strlcpy+0x32>
  800a06:	0f b6 0a             	movzbl (%edx),%ecx
  800a09:	84 c9                	test   %cl,%cl
  800a0b:	75 ec                	jne    8009f9 <strlcpy+0x1a>
  800a0d:	89 c2                	mov    %eax,%edx
  800a0f:	eb 02                	jmp    800a13 <strlcpy+0x34>
  800a11:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a13:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a16:	29 f0                	sub    %esi,%eax
}
  800a18:	5b                   	pop    %ebx
  800a19:	5e                   	pop    %esi
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a22:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a25:	eb 06                	jmp    800a2d <strcmp+0x11>
		p++, q++;
  800a27:	83 c1 01             	add    $0x1,%ecx
  800a2a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a2d:	0f b6 01             	movzbl (%ecx),%eax
  800a30:	84 c0                	test   %al,%al
  800a32:	74 04                	je     800a38 <strcmp+0x1c>
  800a34:	3a 02                	cmp    (%edx),%al
  800a36:	74 ef                	je     800a27 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a38:	0f b6 c0             	movzbl %al,%eax
  800a3b:	0f b6 12             	movzbl (%edx),%edx
  800a3e:	29 d0                	sub    %edx,%eax
}
  800a40:	5d                   	pop    %ebp
  800a41:	c3                   	ret    

00800a42 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
  800a45:	53                   	push   %ebx
  800a46:	8b 45 08             	mov    0x8(%ebp),%eax
  800a49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4c:	89 c3                	mov    %eax,%ebx
  800a4e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a51:	eb 06                	jmp    800a59 <strncmp+0x17>
		n--, p++, q++;
  800a53:	83 c0 01             	add    $0x1,%eax
  800a56:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a59:	39 d8                	cmp    %ebx,%eax
  800a5b:	74 15                	je     800a72 <strncmp+0x30>
  800a5d:	0f b6 08             	movzbl (%eax),%ecx
  800a60:	84 c9                	test   %cl,%cl
  800a62:	74 04                	je     800a68 <strncmp+0x26>
  800a64:	3a 0a                	cmp    (%edx),%cl
  800a66:	74 eb                	je     800a53 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a68:	0f b6 00             	movzbl (%eax),%eax
  800a6b:	0f b6 12             	movzbl (%edx),%edx
  800a6e:	29 d0                	sub    %edx,%eax
  800a70:	eb 05                	jmp    800a77 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a72:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a77:	5b                   	pop    %ebx
  800a78:	5d                   	pop    %ebp
  800a79:	c3                   	ret    

00800a7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a84:	eb 07                	jmp    800a8d <strchr+0x13>
		if (*s == c)
  800a86:	38 ca                	cmp    %cl,%dl
  800a88:	74 0f                	je     800a99 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a8a:	83 c0 01             	add    $0x1,%eax
  800a8d:	0f b6 10             	movzbl (%eax),%edx
  800a90:	84 d2                	test   %dl,%dl
  800a92:	75 f2                	jne    800a86 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa5:	eb 07                	jmp    800aae <strfind+0x13>
		if (*s == c)
  800aa7:	38 ca                	cmp    %cl,%dl
  800aa9:	74 0a                	je     800ab5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800aab:	83 c0 01             	add    $0x1,%eax
  800aae:	0f b6 10             	movzbl (%eax),%edx
  800ab1:	84 d2                	test   %dl,%dl
  800ab3:	75 f2                	jne    800aa7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	57                   	push   %edi
  800abb:	56                   	push   %esi
  800abc:	53                   	push   %ebx
  800abd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ac0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ac3:	85 c9                	test   %ecx,%ecx
  800ac5:	74 36                	je     800afd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ac7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800acd:	75 28                	jne    800af7 <memset+0x40>
  800acf:	f6 c1 03             	test   $0x3,%cl
  800ad2:	75 23                	jne    800af7 <memset+0x40>
		c &= 0xFF;
  800ad4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ad8:	89 d3                	mov    %edx,%ebx
  800ada:	c1 e3 08             	shl    $0x8,%ebx
  800add:	89 d6                	mov    %edx,%esi
  800adf:	c1 e6 18             	shl    $0x18,%esi
  800ae2:	89 d0                	mov    %edx,%eax
  800ae4:	c1 e0 10             	shl    $0x10,%eax
  800ae7:	09 f0                	or     %esi,%eax
  800ae9:	09 c2                	or     %eax,%edx
  800aeb:	89 d0                	mov    %edx,%eax
  800aed:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aef:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800af2:	fc                   	cld    
  800af3:	f3 ab                	rep stos %eax,%es:(%edi)
  800af5:	eb 06                	jmp    800afd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afa:	fc                   	cld    
  800afb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800afd:	89 f8                	mov    %edi,%eax
  800aff:	5b                   	pop    %ebx
  800b00:	5e                   	pop    %esi
  800b01:	5f                   	pop    %edi
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	57                   	push   %edi
  800b08:	56                   	push   %esi
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b12:	39 c6                	cmp    %eax,%esi
  800b14:	73 35                	jae    800b4b <memmove+0x47>
  800b16:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b19:	39 d0                	cmp    %edx,%eax
  800b1b:	73 2e                	jae    800b4b <memmove+0x47>
		s += n;
		d += n;
  800b1d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b20:	89 d6                	mov    %edx,%esi
  800b22:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b24:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b2a:	75 13                	jne    800b3f <memmove+0x3b>
  800b2c:	f6 c1 03             	test   $0x3,%cl
  800b2f:	75 0e                	jne    800b3f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b31:	83 ef 04             	sub    $0x4,%edi
  800b34:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b37:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b3a:	fd                   	std    
  800b3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3d:	eb 09                	jmp    800b48 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b3f:	83 ef 01             	sub    $0x1,%edi
  800b42:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b45:	fd                   	std    
  800b46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b48:	fc                   	cld    
  800b49:	eb 1d                	jmp    800b68 <memmove+0x64>
  800b4b:	89 f2                	mov    %esi,%edx
  800b4d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b4f:	f6 c2 03             	test   $0x3,%dl
  800b52:	75 0f                	jne    800b63 <memmove+0x5f>
  800b54:	f6 c1 03             	test   $0x3,%cl
  800b57:	75 0a                	jne    800b63 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b59:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b5c:	89 c7                	mov    %eax,%edi
  800b5e:	fc                   	cld    
  800b5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b61:	eb 05                	jmp    800b68 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b63:	89 c7                	mov    %eax,%edi
  800b65:	fc                   	cld    
  800b66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b68:	5e                   	pop    %esi
  800b69:	5f                   	pop    %edi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b72:	8b 45 10             	mov    0x10(%ebp),%eax
  800b75:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 04 24             	mov    %eax,(%esp)
  800b86:	e8 79 ff ff ff       	call   800b04 <memmove>
}
  800b8b:	c9                   	leave  
  800b8c:	c3                   	ret    

00800b8d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	56                   	push   %esi
  800b91:	53                   	push   %ebx
  800b92:	8b 55 08             	mov    0x8(%ebp),%edx
  800b95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b98:	89 d6                	mov    %edx,%esi
  800b9a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b9d:	eb 1a                	jmp    800bb9 <memcmp+0x2c>
		if (*s1 != *s2)
  800b9f:	0f b6 02             	movzbl (%edx),%eax
  800ba2:	0f b6 19             	movzbl (%ecx),%ebx
  800ba5:	38 d8                	cmp    %bl,%al
  800ba7:	74 0a                	je     800bb3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ba9:	0f b6 c0             	movzbl %al,%eax
  800bac:	0f b6 db             	movzbl %bl,%ebx
  800baf:	29 d8                	sub    %ebx,%eax
  800bb1:	eb 0f                	jmp    800bc2 <memcmp+0x35>
		s1++, s2++;
  800bb3:	83 c2 01             	add    $0x1,%edx
  800bb6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bb9:	39 f2                	cmp    %esi,%edx
  800bbb:	75 e2                	jne    800b9f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc2:	5b                   	pop    %ebx
  800bc3:	5e                   	pop    %esi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bcf:	89 c2                	mov    %eax,%edx
  800bd1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bd4:	eb 07                	jmp    800bdd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bd6:	38 08                	cmp    %cl,(%eax)
  800bd8:	74 07                	je     800be1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bda:	83 c0 01             	add    $0x1,%eax
  800bdd:	39 d0                	cmp    %edx,%eax
  800bdf:	72 f5                	jb     800bd6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    

00800be3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	57                   	push   %edi
  800be7:	56                   	push   %esi
  800be8:	53                   	push   %ebx
  800be9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bec:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bef:	eb 03                	jmp    800bf4 <strtol+0x11>
		s++;
  800bf1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bf4:	0f b6 0a             	movzbl (%edx),%ecx
  800bf7:	80 f9 09             	cmp    $0x9,%cl
  800bfa:	74 f5                	je     800bf1 <strtol+0xe>
  800bfc:	80 f9 20             	cmp    $0x20,%cl
  800bff:	74 f0                	je     800bf1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c01:	80 f9 2b             	cmp    $0x2b,%cl
  800c04:	75 0a                	jne    800c10 <strtol+0x2d>
		s++;
  800c06:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c09:	bf 00 00 00 00       	mov    $0x0,%edi
  800c0e:	eb 11                	jmp    800c21 <strtol+0x3e>
  800c10:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c15:	80 f9 2d             	cmp    $0x2d,%cl
  800c18:	75 07                	jne    800c21 <strtol+0x3e>
		s++, neg = 1;
  800c1a:	8d 52 01             	lea    0x1(%edx),%edx
  800c1d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c21:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c26:	75 15                	jne    800c3d <strtol+0x5a>
  800c28:	80 3a 30             	cmpb   $0x30,(%edx)
  800c2b:	75 10                	jne    800c3d <strtol+0x5a>
  800c2d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c31:	75 0a                	jne    800c3d <strtol+0x5a>
		s += 2, base = 16;
  800c33:	83 c2 02             	add    $0x2,%edx
  800c36:	b8 10 00 00 00       	mov    $0x10,%eax
  800c3b:	eb 10                	jmp    800c4d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c3d:	85 c0                	test   %eax,%eax
  800c3f:	75 0c                	jne    800c4d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c41:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c43:	80 3a 30             	cmpb   $0x30,(%edx)
  800c46:	75 05                	jne    800c4d <strtol+0x6a>
		s++, base = 8;
  800c48:	83 c2 01             	add    $0x1,%edx
  800c4b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c52:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c55:	0f b6 0a             	movzbl (%edx),%ecx
  800c58:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c5b:	89 f0                	mov    %esi,%eax
  800c5d:	3c 09                	cmp    $0x9,%al
  800c5f:	77 08                	ja     800c69 <strtol+0x86>
			dig = *s - '0';
  800c61:	0f be c9             	movsbl %cl,%ecx
  800c64:	83 e9 30             	sub    $0x30,%ecx
  800c67:	eb 20                	jmp    800c89 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c69:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c6c:	89 f0                	mov    %esi,%eax
  800c6e:	3c 19                	cmp    $0x19,%al
  800c70:	77 08                	ja     800c7a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c72:	0f be c9             	movsbl %cl,%ecx
  800c75:	83 e9 57             	sub    $0x57,%ecx
  800c78:	eb 0f                	jmp    800c89 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c7a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c7d:	89 f0                	mov    %esi,%eax
  800c7f:	3c 19                	cmp    $0x19,%al
  800c81:	77 16                	ja     800c99 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c83:	0f be c9             	movsbl %cl,%ecx
  800c86:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c89:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c8c:	7d 0f                	jge    800c9d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c8e:	83 c2 01             	add    $0x1,%edx
  800c91:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c95:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c97:	eb bc                	jmp    800c55 <strtol+0x72>
  800c99:	89 d8                	mov    %ebx,%eax
  800c9b:	eb 02                	jmp    800c9f <strtol+0xbc>
  800c9d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca3:	74 05                	je     800caa <strtol+0xc7>
		*endptr = (char *) s;
  800ca5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ca8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800caa:	f7 d8                	neg    %eax
  800cac:	85 ff                	test   %edi,%edi
  800cae:	0f 44 c3             	cmove  %ebx,%eax
}
  800cb1:	5b                   	pop    %ebx
  800cb2:	5e                   	pop    %esi
  800cb3:	5f                   	pop    %edi
  800cb4:	5d                   	pop    %ebp
  800cb5:	c3                   	ret    

00800cb6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	57                   	push   %edi
  800cba:	56                   	push   %esi
  800cbb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc7:	89 c3                	mov    %eax,%ebx
  800cc9:	89 c7                	mov    %eax,%edi
  800ccb:	89 c6                	mov    %eax,%esi
  800ccd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cda:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdf:	b8 01 00 00 00       	mov    $0x1,%eax
  800ce4:	89 d1                	mov    %edx,%ecx
  800ce6:	89 d3                	mov    %edx,%ebx
  800ce8:	89 d7                	mov    %edx,%edi
  800cea:	89 d6                	mov    %edx,%esi
  800cec:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
  800cf9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d01:	b8 03 00 00 00       	mov    $0x3,%eax
  800d06:	8b 55 08             	mov    0x8(%ebp),%edx
  800d09:	89 cb                	mov    %ecx,%ebx
  800d0b:	89 cf                	mov    %ecx,%edi
  800d0d:	89 ce                	mov    %ecx,%esi
  800d0f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d11:	85 c0                	test   %eax,%eax
  800d13:	7e 28                	jle    800d3d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d15:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d19:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d20:	00 
  800d21:	c7 44 24 08 a7 30 80 	movl   $0x8030a7,0x8(%esp)
  800d28:	00 
  800d29:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d30:	00 
  800d31:	c7 04 24 c4 30 80 00 	movl   $0x8030c4,(%esp)
  800d38:	e8 0e f5 ff ff       	call   80024b <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d3d:	83 c4 2c             	add    $0x2c,%esp
  800d40:	5b                   	pop    %ebx
  800d41:	5e                   	pop    %esi
  800d42:	5f                   	pop    %edi
  800d43:	5d                   	pop    %ebp
  800d44:	c3                   	ret    

00800d45 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	57                   	push   %edi
  800d49:	56                   	push   %esi
  800d4a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d50:	b8 02 00 00 00       	mov    $0x2,%eax
  800d55:	89 d1                	mov    %edx,%ecx
  800d57:	89 d3                	mov    %edx,%ebx
  800d59:	89 d7                	mov    %edx,%edi
  800d5b:	89 d6                	mov    %edx,%esi
  800d5d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d5f:	5b                   	pop    %ebx
  800d60:	5e                   	pop    %esi
  800d61:	5f                   	pop    %edi
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    

00800d64 <sys_yield>:

void
sys_yield(void)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	57                   	push   %edi
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d6f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d74:	89 d1                	mov    %edx,%ecx
  800d76:	89 d3                	mov    %edx,%ebx
  800d78:	89 d7                	mov    %edx,%edi
  800d7a:	89 d6                	mov    %edx,%esi
  800d7c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	57                   	push   %edi
  800d87:	56                   	push   %esi
  800d88:	53                   	push   %ebx
  800d89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8c:	be 00 00 00 00       	mov    $0x0,%esi
  800d91:	b8 04 00 00 00       	mov    $0x4,%eax
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9f:	89 f7                	mov    %esi,%edi
  800da1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800da3:	85 c0                	test   %eax,%eax
  800da5:	7e 28                	jle    800dcf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dab:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800db2:	00 
  800db3:	c7 44 24 08 a7 30 80 	movl   $0x8030a7,0x8(%esp)
  800dba:	00 
  800dbb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc2:	00 
  800dc3:	c7 04 24 c4 30 80 00 	movl   $0x8030c4,(%esp)
  800dca:	e8 7c f4 ff ff       	call   80024b <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dcf:	83 c4 2c             	add    $0x2c,%esp
  800dd2:	5b                   	pop    %ebx
  800dd3:	5e                   	pop    %esi
  800dd4:	5f                   	pop    %edi
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    

00800dd7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	57                   	push   %edi
  800ddb:	56                   	push   %esi
  800ddc:	53                   	push   %ebx
  800ddd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de0:	b8 05 00 00 00       	mov    $0x5,%eax
  800de5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dee:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df1:	8b 75 18             	mov    0x18(%ebp),%esi
  800df4:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800df6:	85 c0                	test   %eax,%eax
  800df8:	7e 28                	jle    800e22 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfa:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dfe:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e05:	00 
  800e06:	c7 44 24 08 a7 30 80 	movl   $0x8030a7,0x8(%esp)
  800e0d:	00 
  800e0e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e15:	00 
  800e16:	c7 04 24 c4 30 80 00 	movl   $0x8030c4,(%esp)
  800e1d:	e8 29 f4 ff ff       	call   80024b <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e22:	83 c4 2c             	add    $0x2c,%esp
  800e25:	5b                   	pop    %ebx
  800e26:	5e                   	pop    %esi
  800e27:	5f                   	pop    %edi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	57                   	push   %edi
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
  800e30:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e38:	b8 06 00 00 00       	mov    $0x6,%eax
  800e3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e40:	8b 55 08             	mov    0x8(%ebp),%edx
  800e43:	89 df                	mov    %ebx,%edi
  800e45:	89 de                	mov    %ebx,%esi
  800e47:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e49:	85 c0                	test   %eax,%eax
  800e4b:	7e 28                	jle    800e75 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e51:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e58:	00 
  800e59:	c7 44 24 08 a7 30 80 	movl   $0x8030a7,0x8(%esp)
  800e60:	00 
  800e61:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e68:	00 
  800e69:	c7 04 24 c4 30 80 00 	movl   $0x8030c4,(%esp)
  800e70:	e8 d6 f3 ff ff       	call   80024b <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e75:	83 c4 2c             	add    $0x2c,%esp
  800e78:	5b                   	pop    %ebx
  800e79:	5e                   	pop    %esi
  800e7a:	5f                   	pop    %edi
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    

00800e7d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	57                   	push   %edi
  800e81:	56                   	push   %esi
  800e82:	53                   	push   %ebx
  800e83:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e93:	8b 55 08             	mov    0x8(%ebp),%edx
  800e96:	89 df                	mov    %ebx,%edi
  800e98:	89 de                	mov    %ebx,%esi
  800e9a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	7e 28                	jle    800ec8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800eab:	00 
  800eac:	c7 44 24 08 a7 30 80 	movl   $0x8030a7,0x8(%esp)
  800eb3:	00 
  800eb4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ebb:	00 
  800ebc:	c7 04 24 c4 30 80 00 	movl   $0x8030c4,(%esp)
  800ec3:	e8 83 f3 ff ff       	call   80024b <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ec8:	83 c4 2c             	add    $0x2c,%esp
  800ecb:	5b                   	pop    %ebx
  800ecc:	5e                   	pop    %esi
  800ecd:	5f                   	pop    %edi
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    

00800ed0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	57                   	push   %edi
  800ed4:	56                   	push   %esi
  800ed5:	53                   	push   %ebx
  800ed6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ede:	b8 09 00 00 00       	mov    $0x9,%eax
  800ee3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	89 df                	mov    %ebx,%edi
  800eeb:	89 de                	mov    %ebx,%esi
  800eed:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800eef:	85 c0                	test   %eax,%eax
  800ef1:	7e 28                	jle    800f1b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800efe:	00 
  800eff:	c7 44 24 08 a7 30 80 	movl   $0x8030a7,0x8(%esp)
  800f06:	00 
  800f07:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f0e:	00 
  800f0f:	c7 04 24 c4 30 80 00 	movl   $0x8030c4,(%esp)
  800f16:	e8 30 f3 ff ff       	call   80024b <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f1b:	83 c4 2c             	add    $0x2c,%esp
  800f1e:	5b                   	pop    %ebx
  800f1f:	5e                   	pop    %esi
  800f20:	5f                   	pop    %edi
  800f21:	5d                   	pop    %ebp
  800f22:	c3                   	ret    

00800f23 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	57                   	push   %edi
  800f27:	56                   	push   %esi
  800f28:	53                   	push   %ebx
  800f29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f39:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3c:	89 df                	mov    %ebx,%edi
  800f3e:	89 de                	mov    %ebx,%esi
  800f40:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f42:	85 c0                	test   %eax,%eax
  800f44:	7e 28                	jle    800f6e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f46:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f4a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f51:	00 
  800f52:	c7 44 24 08 a7 30 80 	movl   $0x8030a7,0x8(%esp)
  800f59:	00 
  800f5a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f61:	00 
  800f62:	c7 04 24 c4 30 80 00 	movl   $0x8030c4,(%esp)
  800f69:	e8 dd f2 ff ff       	call   80024b <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f6e:	83 c4 2c             	add    $0x2c,%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	57                   	push   %edi
  800f7a:	56                   	push   %esi
  800f7b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f7c:	be 00 00 00 00       	mov    $0x0,%esi
  800f81:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f89:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f8f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f92:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f94:	5b                   	pop    %ebx
  800f95:	5e                   	pop    %esi
  800f96:	5f                   	pop    %edi
  800f97:	5d                   	pop    %ebp
  800f98:	c3                   	ret    

00800f99 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	57                   	push   %edi
  800f9d:	56                   	push   %esi
  800f9e:	53                   	push   %ebx
  800f9f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fac:	8b 55 08             	mov    0x8(%ebp),%edx
  800faf:	89 cb                	mov    %ecx,%ebx
  800fb1:	89 cf                	mov    %ecx,%edi
  800fb3:	89 ce                	mov    %ecx,%esi
  800fb5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800fb7:	85 c0                	test   %eax,%eax
  800fb9:	7e 28                	jle    800fe3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fbb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fbf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fc6:	00 
  800fc7:	c7 44 24 08 a7 30 80 	movl   $0x8030a7,0x8(%esp)
  800fce:	00 
  800fcf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd6:	00 
  800fd7:	c7 04 24 c4 30 80 00 	movl   $0x8030c4,(%esp)
  800fde:	e8 68 f2 ff ff       	call   80024b <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fe3:	83 c4 2c             	add    $0x2c,%esp
  800fe6:	5b                   	pop    %ebx
  800fe7:	5e                   	pop    %esi
  800fe8:	5f                   	pop    %edi
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    

00800feb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	57                   	push   %edi
  800fef:	56                   	push   %esi
  800ff0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ff6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ffb:	89 d1                	mov    %edx,%ecx
  800ffd:	89 d3                	mov    %edx,%ebx
  800fff:	89 d7                	mov    %edx,%edi
  801001:	89 d6                	mov    %edx,%esi
  801003:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801005:	5b                   	pop    %ebx
  801006:	5e                   	pop    %esi
  801007:	5f                   	pop    %edi
  801008:	5d                   	pop    %ebp
  801009:	c3                   	ret    

0080100a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	57                   	push   %edi
  80100e:	56                   	push   %esi
  80100f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801010:	bb 00 00 00 00       	mov    $0x0,%ebx
  801015:	b8 0f 00 00 00       	mov    $0xf,%eax
  80101a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101d:	8b 55 08             	mov    0x8(%ebp),%edx
  801020:	89 df                	mov    %ebx,%edi
  801022:	89 de                	mov    %ebx,%esi
  801024:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  801026:	5b                   	pop    %ebx
  801027:	5e                   	pop    %esi
  801028:	5f                   	pop    %edi
  801029:	5d                   	pop    %ebp
  80102a:	c3                   	ret    

0080102b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	57                   	push   %edi
  80102f:	56                   	push   %esi
  801030:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801031:	bb 00 00 00 00       	mov    $0x0,%ebx
  801036:	b8 10 00 00 00       	mov    $0x10,%eax
  80103b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103e:	8b 55 08             	mov    0x8(%ebp),%edx
  801041:	89 df                	mov    %ebx,%edi
  801043:	89 de                	mov    %ebx,%esi
  801045:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  801047:	5b                   	pop    %ebx
  801048:	5e                   	pop    %esi
  801049:	5f                   	pop    %edi
  80104a:	5d                   	pop    %ebp
  80104b:	c3                   	ret    

0080104c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	57                   	push   %edi
  801050:	56                   	push   %esi
  801051:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801052:	b9 00 00 00 00       	mov    $0x0,%ecx
  801057:	b8 11 00 00 00       	mov    $0x11,%eax
  80105c:	8b 55 08             	mov    0x8(%ebp),%edx
  80105f:	89 cb                	mov    %ecx,%ebx
  801061:	89 cf                	mov    %ecx,%edi
  801063:	89 ce                	mov    %ecx,%esi
  801065:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801067:	5b                   	pop    %ebx
  801068:	5e                   	pop    %esi
  801069:	5f                   	pop    %edi
  80106a:	5d                   	pop    %ebp
  80106b:	c3                   	ret    

0080106c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	57                   	push   %edi
  801070:	56                   	push   %esi
  801071:	53                   	push   %ebx
  801072:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801075:	be 00 00 00 00       	mov    $0x0,%esi
  80107a:	b8 12 00 00 00       	mov    $0x12,%eax
  80107f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801082:	8b 55 08             	mov    0x8(%ebp),%edx
  801085:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801088:	8b 7d 14             	mov    0x14(%ebp),%edi
  80108b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80108d:	85 c0                	test   %eax,%eax
  80108f:	7e 28                	jle    8010b9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801091:	89 44 24 10          	mov    %eax,0x10(%esp)
  801095:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80109c:	00 
  80109d:	c7 44 24 08 a7 30 80 	movl   $0x8030a7,0x8(%esp)
  8010a4:	00 
  8010a5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ac:	00 
  8010ad:	c7 04 24 c4 30 80 00 	movl   $0x8030c4,(%esp)
  8010b4:	e8 92 f1 ff ff       	call   80024b <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  8010b9:	83 c4 2c             	add    $0x2c,%esp
  8010bc:	5b                   	pop    %ebx
  8010bd:	5e                   	pop    %esi
  8010be:	5f                   	pop    %edi
  8010bf:	5d                   	pop    %ebp
  8010c0:	c3                   	ret    

008010c1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	53                   	push   %ebx
  8010c5:	83 ec 24             	sub    $0x24,%esp
  8010c8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8010cb:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0)
  8010cd:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8010d1:	75 20                	jne    8010f3 <pgfault+0x32>
		panic("pgfault: faulting address [%08x] not a write\n", addr);
  8010d3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010d7:	c7 44 24 08 d4 30 80 	movl   $0x8030d4,0x8(%esp)
  8010de:	00 
  8010df:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8010e6:	00 
  8010e7:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  8010ee:	e8 58 f1 ff ff       	call   80024b <_panic>

	void *page_aligned_addr = (void *) ROUNDDOWN(addr, PGSIZE);
  8010f3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t page_num = (uint32_t) page_aligned_addr / PGSIZE;
  8010f9:	89 d8                	mov    %ebx,%eax
  8010fb:	c1 e8 0c             	shr    $0xc,%eax
	if (!(uvpt[page_num] & PTE_COW))
  8010fe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801105:	f6 c4 08             	test   $0x8,%ah
  801108:	75 1c                	jne    801126 <pgfault+0x65>
		panic("pgfault: fault was not on a copy-on-write page\n");
  80110a:	c7 44 24 08 04 31 80 	movl   $0x803104,0x8(%esp)
  801111:	00 
  801112:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801119:	00 
  80111a:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  801121:	e8 25 f1 ff ff       	call   80024b <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	// Allocate
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801126:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80112d:	00 
  80112e:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801135:	00 
  801136:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80113d:	e8 41 fc ff ff       	call   800d83 <sys_page_alloc>
  801142:	85 c0                	test   %eax,%eax
  801144:	79 20                	jns    801166 <pgfault+0xa5>
		panic("sys_page_alloc: %e\n", r);
  801146:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80114a:	c7 44 24 08 5f 31 80 	movl   $0x80315f,0x8(%esp)
  801151:	00 
  801152:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  801159:	00 
  80115a:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  801161:	e8 e5 f0 ff ff       	call   80024b <_panic>

	// Copy over
	void *src_addr = (void *) ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, src_addr, PGSIZE);
  801166:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80116d:	00 
  80116e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801172:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801179:	e8 86 f9 ff ff       	call   800b04 <memmove>

	// Remap
	if ((r = sys_page_map(0, PFTEMP, 0, src_addr, PTE_P | PTE_U | PTE_W)) < 0)
  80117e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801185:	00 
  801186:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80118a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801191:	00 
  801192:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801199:	00 
  80119a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011a1:	e8 31 fc ff ff       	call   800dd7 <sys_page_map>
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	79 20                	jns    8011ca <pgfault+0x109>
		panic("sys_page_map: %e\n", r);
  8011aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011ae:	c7 44 24 08 73 31 80 	movl   $0x803173,0x8(%esp)
  8011b5:	00 
  8011b6:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  8011bd:	00 
  8011be:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  8011c5:	e8 81 f0 ff ff       	call   80024b <_panic>

	//panic("pgfault not implemented");
}
  8011ca:	83 c4 24             	add    $0x24,%esp
  8011cd:	5b                   	pop    %ebx
  8011ce:	5d                   	pop    %ebp
  8011cf:	c3                   	ret    

008011d0 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	57                   	push   %edi
  8011d4:	56                   	push   %esi
  8011d5:	53                   	push   %ebx
  8011d6:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	int r;
	envid_t child_envid;

	set_pgfault_handler(pgfault);
  8011d9:	c7 04 24 c1 10 80 00 	movl   $0x8010c1,(%esp)
  8011e0:	e8 01 16 00 00       	call   8027e6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8011e5:	b8 07 00 00 00       	mov    $0x7,%eax
  8011ea:	cd 30                	int    $0x30
  8011ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8011ef:	89 45 e0             	mov    %eax,-0x20(%ebp)

	child_envid = sys_exofork();
	if (child_envid < 0)
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	79 20                	jns    801216 <fork+0x46>
		panic("sys_exofork: %e\n", child_envid);
  8011f6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011fa:	c7 44 24 08 85 31 80 	movl   $0x803185,0x8(%esp)
  801201:	00 
  801202:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  801209:	00 
  80120a:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  801211:	e8 35 f0 ff ff       	call   80024b <_panic>
	if (child_envid == 0) { // child
  801216:	bf 00 00 00 00       	mov    $0x0,%edi
  80121b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801220:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801224:	75 21                	jne    801247 <fork+0x77>
		// Fix thisenv like dumbfork does and return 0
		thisenv = &envs[ENVX(sys_getenvid())];
  801226:	e8 1a fb ff ff       	call   800d45 <sys_getenvid>
  80122b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801230:	c1 e0 07             	shl    $0x7,%eax
  801233:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801238:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80123d:	b8 00 00 00 00       	mov    $0x0,%eax
  801242:	e9 53 02 00 00       	jmp    80149a <fork+0x2ca>
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
  801247:	89 d8                	mov    %ebx,%eax
  801249:	c1 e8 0a             	shr    $0xa,%eax
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  80124c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801253:	a8 01                	test   $0x1,%al
  801255:	0f 84 7a 01 00 00    	je     8013d5 <fork+0x205>
			((uvpt[page_num] & PTE_P) == PTE_P)) {
  80125b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  801262:	a8 01                	test   $0x1,%al
  801264:	0f 84 6b 01 00 00    	je     8013d5 <fork+0x205>
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
	envid_t this_envid = thisenv->env_id;
  80126a:	a1 08 50 80 00       	mov    0x805008,%eax
  80126f:	8b 40 48             	mov    0x48(%eax),%eax
  801272:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 4: Your code here.
	if (uvpt[pn] & PTE_SHARE) {
  801275:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80127c:	f6 c4 04             	test   $0x4,%ah
  80127f:	74 52                	je     8012d3 <fork+0x103>
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801281:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801288:	25 07 0e 00 00       	and    $0xe07,%eax
  80128d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801291:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801295:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801298:	89 44 24 08          	mov    %eax,0x8(%esp)
  80129c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012a3:	89 04 24             	mov    %eax,(%esp)
  8012a6:	e8 2c fb ff ff       	call   800dd7 <sys_page_map>
  8012ab:	85 c0                	test   %eax,%eax
  8012ad:	0f 89 22 01 00 00    	jns    8013d5 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  8012b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012b7:	c7 44 24 08 73 31 80 	movl   $0x803173,0x8(%esp)
  8012be:	00 
  8012bf:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  8012c6:	00 
  8012c7:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  8012ce:	e8 78 ef ff ff       	call   80024b <_panic>
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
  8012d3:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012da:	f6 c4 08             	test   $0x8,%ah
  8012dd:	75 0f                	jne    8012ee <fork+0x11e>
  8012df:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012e6:	a8 02                	test   $0x2,%al
  8012e8:	0f 84 99 00 00 00    	je     801387 <fork+0x1b7>
		if (uvpt[pn] & PTE_U)
  8012ee:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012f5:	83 e0 04             	and    $0x4,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
  8012f8:	83 f8 01             	cmp    $0x1,%eax
  8012fb:	19 f6                	sbb    %esi,%esi
  8012fd:	83 e6 fc             	and    $0xfffffffc,%esi
  801300:	81 c6 05 08 00 00    	add    $0x805,%esi
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
		if (uvpt[pn] & PTE_U)
			perm |= PTE_U;

		// Map page COW, U and P in child
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), perm)) < 0)
  801306:	89 74 24 10          	mov    %esi,0x10(%esp)
  80130a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80130e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801311:	89 44 24 08          	mov    %eax,0x8(%esp)
  801315:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801319:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80131c:	89 04 24             	mov    %eax,(%esp)
  80131f:	e8 b3 fa ff ff       	call   800dd7 <sys_page_map>
  801324:	85 c0                	test   %eax,%eax
  801326:	79 20                	jns    801348 <fork+0x178>
			panic("sys_page_map: %e\n", r);
  801328:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80132c:	c7 44 24 08 73 31 80 	movl   $0x803173,0x8(%esp)
  801333:	00 
  801334:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80133b:	00 
  80133c:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  801343:	e8 03 ef ff ff       	call   80024b <_panic>

		// Map page COW, U and P in parent
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), this_envid, (void *) (pn*PGSIZE), perm)) < 0)
  801348:	89 74 24 10          	mov    %esi,0x10(%esp)
  80134c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801350:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801353:	89 44 24 08          	mov    %eax,0x8(%esp)
  801357:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80135b:	89 04 24             	mov    %eax,(%esp)
  80135e:	e8 74 fa ff ff       	call   800dd7 <sys_page_map>
  801363:	85 c0                	test   %eax,%eax
  801365:	79 6e                	jns    8013d5 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801367:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80136b:	c7 44 24 08 73 31 80 	movl   $0x803173,0x8(%esp)
  801372:	00 
  801373:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  80137a:	00 
  80137b:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  801382:	e8 c4 ee ff ff       	call   80024b <_panic>

	} else { // map pages that are present but not writable or COW with their original permissions
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801387:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80138e:	25 07 0e 00 00       	and    $0xe07,%eax
  801393:	89 44 24 10          	mov    %eax,0x10(%esp)
  801397:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80139b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80139e:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a9:	89 04 24             	mov    %eax,(%esp)
  8013ac:	e8 26 fa ff ff       	call   800dd7 <sys_page_map>
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	79 20                	jns    8013d5 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  8013b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013b9:	c7 44 24 08 73 31 80 	movl   $0x803173,0x8(%esp)
  8013c0:	00 
  8013c1:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  8013c8:	00 
  8013c9:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  8013d0:	e8 76 ee ff ff       	call   80024b <_panic>
	// and let duppage worry about the permissions.
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
  8013d5:	83 c3 01             	add    $0x1,%ebx
  8013d8:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8013de:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  8013e4:	0f 85 5d fe ff ff    	jne    801247 <fork+0x77>
	}

	// Allocate exception stack space for child. The child can't do this themselves
	// because the mechanism by which it would is to run the pgfault handler, which
	// needs to run on the exception stack (catch 22).
	if ((r = sys_page_alloc(child_envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8013ea:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013f1:	00 
  8013f2:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8013f9:	ee 
  8013fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013fd:	89 04 24             	mov    %eax,(%esp)
  801400:	e8 7e f9 ff ff       	call   800d83 <sys_page_alloc>
  801405:	85 c0                	test   %eax,%eax
  801407:	79 20                	jns    801429 <fork+0x259>
		panic("sys_page_alloc: %e\n", r);
  801409:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80140d:	c7 44 24 08 5f 31 80 	movl   $0x80315f,0x8(%esp)
  801414:	00 
  801415:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  80141c:	00 
  80141d:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  801424:	e8 22 ee ff ff       	call   80024b <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801429:	c7 44 24 04 67 28 80 	movl   $0x802867,0x4(%esp)
  801430:	00 
  801431:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801434:	89 04 24             	mov    %eax,(%esp)
  801437:	e8 e7 fa ff ff       	call   800f23 <sys_env_set_pgfault_upcall>
  80143c:	85 c0                	test   %eax,%eax
  80143e:	79 20                	jns    801460 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801440:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801444:	c7 44 24 08 34 31 80 	movl   $0x803134,0x8(%esp)
  80144b:	00 
  80144c:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801453:	00 
  801454:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  80145b:	e8 eb ed ff ff       	call   80024b <_panic>

	// Mark child environment as runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801460:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801467:	00 
  801468:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80146b:	89 04 24             	mov    %eax,(%esp)
  80146e:	e8 0a fa ff ff       	call   800e7d <sys_env_set_status>
  801473:	85 c0                	test   %eax,%eax
  801475:	79 20                	jns    801497 <fork+0x2c7>
		panic("sys_env_set_status: %e\n", r);
  801477:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80147b:	c7 44 24 08 96 31 80 	movl   $0x803196,0x8(%esp)
  801482:	00 
  801483:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80148a:	00 
  80148b:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  801492:	e8 b4 ed ff ff       	call   80024b <_panic>

	return child_envid;
  801497:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  80149a:	83 c4 2c             	add    $0x2c,%esp
  80149d:	5b                   	pop    %ebx
  80149e:	5e                   	pop    %esi
  80149f:	5f                   	pop    %edi
  8014a0:	5d                   	pop    %ebp
  8014a1:	c3                   	ret    

008014a2 <sfork>:

// Challenge!
int
sfork(void)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	83 ec 18             	sub    $0x18,%esp
//	return __fork(1);
	panic("sfork not implemented");
  8014a8:	c7 44 24 08 ae 31 80 	movl   $0x8031ae,0x8(%esp)
  8014af:	00 
  8014b0:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  8014b7:	00 
  8014b8:	c7 04 24 54 31 80 00 	movl   $0x803154,(%esp)
  8014bf:	e8 87 ed ff ff       	call   80024b <_panic>
  8014c4:	66 90                	xchg   %ax,%ax
  8014c6:	66 90                	xchg   %ax,%ax
  8014c8:	66 90                	xchg   %ax,%ax
  8014ca:	66 90                	xchg   %ax,%ax
  8014cc:	66 90                	xchg   %ax,%ax
  8014ce:	66 90                	xchg   %ax,%ax

008014d0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	05 00 00 00 30       	add    $0x30000000,%eax
  8014db:	c1 e8 0c             	shr    $0xc,%eax
}
  8014de:	5d                   	pop    %ebp
  8014df:	c3                   	ret    

008014e0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8014eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014f0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014f5:	5d                   	pop    %ebp
  8014f6:	c3                   	ret    

008014f7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014fd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801502:	89 c2                	mov    %eax,%edx
  801504:	c1 ea 16             	shr    $0x16,%edx
  801507:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80150e:	f6 c2 01             	test   $0x1,%dl
  801511:	74 11                	je     801524 <fd_alloc+0x2d>
  801513:	89 c2                	mov    %eax,%edx
  801515:	c1 ea 0c             	shr    $0xc,%edx
  801518:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80151f:	f6 c2 01             	test   $0x1,%dl
  801522:	75 09                	jne    80152d <fd_alloc+0x36>
			*fd_store = fd;
  801524:	89 01                	mov    %eax,(%ecx)
			return 0;
  801526:	b8 00 00 00 00       	mov    $0x0,%eax
  80152b:	eb 17                	jmp    801544 <fd_alloc+0x4d>
  80152d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801532:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801537:	75 c9                	jne    801502 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801539:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80153f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801544:	5d                   	pop    %ebp
  801545:	c3                   	ret    

00801546 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80154c:	83 f8 1f             	cmp    $0x1f,%eax
  80154f:	77 36                	ja     801587 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801551:	c1 e0 0c             	shl    $0xc,%eax
  801554:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801559:	89 c2                	mov    %eax,%edx
  80155b:	c1 ea 16             	shr    $0x16,%edx
  80155e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801565:	f6 c2 01             	test   $0x1,%dl
  801568:	74 24                	je     80158e <fd_lookup+0x48>
  80156a:	89 c2                	mov    %eax,%edx
  80156c:	c1 ea 0c             	shr    $0xc,%edx
  80156f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801576:	f6 c2 01             	test   $0x1,%dl
  801579:	74 1a                	je     801595 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80157b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157e:	89 02                	mov    %eax,(%edx)
	return 0;
  801580:	b8 00 00 00 00       	mov    $0x0,%eax
  801585:	eb 13                	jmp    80159a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801587:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80158c:	eb 0c                	jmp    80159a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80158e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801593:	eb 05                	jmp    80159a <fd_lookup+0x54>
  801595:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80159a:	5d                   	pop    %ebp
  80159b:	c3                   	ret    

0080159c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 18             	sub    $0x18,%esp
  8015a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8015a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015aa:	eb 13                	jmp    8015bf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8015ac:	39 08                	cmp    %ecx,(%eax)
  8015ae:	75 0c                	jne    8015bc <dev_lookup+0x20>
			*dev = devtab[i];
  8015b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015b3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ba:	eb 38                	jmp    8015f4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015bc:	83 c2 01             	add    $0x1,%edx
  8015bf:	8b 04 95 40 32 80 00 	mov    0x803240(,%edx,4),%eax
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	75 e2                	jne    8015ac <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015ca:	a1 08 50 80 00       	mov    0x805008,%eax
  8015cf:	8b 40 48             	mov    0x48(%eax),%eax
  8015d2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015da:	c7 04 24 c4 31 80 00 	movl   $0x8031c4,(%esp)
  8015e1:	e8 5e ed ff ff       	call   800344 <cprintf>
	*dev = 0;
  8015e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	56                   	push   %esi
  8015fa:	53                   	push   %ebx
  8015fb:	83 ec 20             	sub    $0x20,%esp
  8015fe:	8b 75 08             	mov    0x8(%ebp),%esi
  801601:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801604:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801607:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80160b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801611:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801614:	89 04 24             	mov    %eax,(%esp)
  801617:	e8 2a ff ff ff       	call   801546 <fd_lookup>
  80161c:	85 c0                	test   %eax,%eax
  80161e:	78 05                	js     801625 <fd_close+0x2f>
	    || fd != fd2)
  801620:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801623:	74 0c                	je     801631 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801625:	84 db                	test   %bl,%bl
  801627:	ba 00 00 00 00       	mov    $0x0,%edx
  80162c:	0f 44 c2             	cmove  %edx,%eax
  80162f:	eb 3f                	jmp    801670 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801631:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801634:	89 44 24 04          	mov    %eax,0x4(%esp)
  801638:	8b 06                	mov    (%esi),%eax
  80163a:	89 04 24             	mov    %eax,(%esp)
  80163d:	e8 5a ff ff ff       	call   80159c <dev_lookup>
  801642:	89 c3                	mov    %eax,%ebx
  801644:	85 c0                	test   %eax,%eax
  801646:	78 16                	js     80165e <fd_close+0x68>
		if (dev->dev_close)
  801648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80164e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801653:	85 c0                	test   %eax,%eax
  801655:	74 07                	je     80165e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801657:	89 34 24             	mov    %esi,(%esp)
  80165a:	ff d0                	call   *%eax
  80165c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80165e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801662:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801669:	e8 bc f7 ff ff       	call   800e2a <sys_page_unmap>
	return r;
  80166e:	89 d8                	mov    %ebx,%eax
}
  801670:	83 c4 20             	add    $0x20,%esp
  801673:	5b                   	pop    %ebx
  801674:	5e                   	pop    %esi
  801675:	5d                   	pop    %ebp
  801676:	c3                   	ret    

00801677 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80167d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801680:	89 44 24 04          	mov    %eax,0x4(%esp)
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	89 04 24             	mov    %eax,(%esp)
  80168a:	e8 b7 fe ff ff       	call   801546 <fd_lookup>
  80168f:	89 c2                	mov    %eax,%edx
  801691:	85 d2                	test   %edx,%edx
  801693:	78 13                	js     8016a8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801695:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80169c:	00 
  80169d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a0:	89 04 24             	mov    %eax,(%esp)
  8016a3:	e8 4e ff ff ff       	call   8015f6 <fd_close>
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <close_all>:

void
close_all(void)
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	53                   	push   %ebx
  8016ae:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016b6:	89 1c 24             	mov    %ebx,(%esp)
  8016b9:	e8 b9 ff ff ff       	call   801677 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8016be:	83 c3 01             	add    $0x1,%ebx
  8016c1:	83 fb 20             	cmp    $0x20,%ebx
  8016c4:	75 f0                	jne    8016b6 <close_all+0xc>
		close(i);
}
  8016c6:	83 c4 14             	add    $0x14,%esp
  8016c9:	5b                   	pop    %ebx
  8016ca:	5d                   	pop    %ebp
  8016cb:	c3                   	ret    

008016cc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	57                   	push   %edi
  8016d0:	56                   	push   %esi
  8016d1:	53                   	push   %ebx
  8016d2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016d5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	89 04 24             	mov    %eax,(%esp)
  8016e2:	e8 5f fe ff ff       	call   801546 <fd_lookup>
  8016e7:	89 c2                	mov    %eax,%edx
  8016e9:	85 d2                	test   %edx,%edx
  8016eb:	0f 88 e1 00 00 00    	js     8017d2 <dup+0x106>
		return r;
	close(newfdnum);
  8016f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f4:	89 04 24             	mov    %eax,(%esp)
  8016f7:	e8 7b ff ff ff       	call   801677 <close>

	newfd = INDEX2FD(newfdnum);
  8016fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016ff:	c1 e3 0c             	shl    $0xc,%ebx
  801702:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801708:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80170b:	89 04 24             	mov    %eax,(%esp)
  80170e:	e8 cd fd ff ff       	call   8014e0 <fd2data>
  801713:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801715:	89 1c 24             	mov    %ebx,(%esp)
  801718:	e8 c3 fd ff ff       	call   8014e0 <fd2data>
  80171d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80171f:	89 f0                	mov    %esi,%eax
  801721:	c1 e8 16             	shr    $0x16,%eax
  801724:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80172b:	a8 01                	test   $0x1,%al
  80172d:	74 43                	je     801772 <dup+0xa6>
  80172f:	89 f0                	mov    %esi,%eax
  801731:	c1 e8 0c             	shr    $0xc,%eax
  801734:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80173b:	f6 c2 01             	test   $0x1,%dl
  80173e:	74 32                	je     801772 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801740:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801747:	25 07 0e 00 00       	and    $0xe07,%eax
  80174c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801750:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801754:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80175b:	00 
  80175c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801760:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801767:	e8 6b f6 ff ff       	call   800dd7 <sys_page_map>
  80176c:	89 c6                	mov    %eax,%esi
  80176e:	85 c0                	test   %eax,%eax
  801770:	78 3e                	js     8017b0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801772:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801775:	89 c2                	mov    %eax,%edx
  801777:	c1 ea 0c             	shr    $0xc,%edx
  80177a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801781:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801787:	89 54 24 10          	mov    %edx,0x10(%esp)
  80178b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80178f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801796:	00 
  801797:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a2:	e8 30 f6 ff ff       	call   800dd7 <sys_page_map>
  8017a7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8017a9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017ac:	85 f6                	test   %esi,%esi
  8017ae:	79 22                	jns    8017d2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8017b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017bb:	e8 6a f6 ff ff       	call   800e2a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017cb:	e8 5a f6 ff ff       	call   800e2a <sys_page_unmap>
	return r;
  8017d0:	89 f0                	mov    %esi,%eax
}
  8017d2:	83 c4 3c             	add    $0x3c,%esp
  8017d5:	5b                   	pop    %ebx
  8017d6:	5e                   	pop    %esi
  8017d7:	5f                   	pop    %edi
  8017d8:	5d                   	pop    %ebp
  8017d9:	c3                   	ret    

008017da <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	53                   	push   %ebx
  8017de:	83 ec 24             	sub    $0x24,%esp
  8017e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017eb:	89 1c 24             	mov    %ebx,(%esp)
  8017ee:	e8 53 fd ff ff       	call   801546 <fd_lookup>
  8017f3:	89 c2                	mov    %eax,%edx
  8017f5:	85 d2                	test   %edx,%edx
  8017f7:	78 6d                	js     801866 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801803:	8b 00                	mov    (%eax),%eax
  801805:	89 04 24             	mov    %eax,(%esp)
  801808:	e8 8f fd ff ff       	call   80159c <dev_lookup>
  80180d:	85 c0                	test   %eax,%eax
  80180f:	78 55                	js     801866 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801814:	8b 50 08             	mov    0x8(%eax),%edx
  801817:	83 e2 03             	and    $0x3,%edx
  80181a:	83 fa 01             	cmp    $0x1,%edx
  80181d:	75 23                	jne    801842 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80181f:	a1 08 50 80 00       	mov    0x805008,%eax
  801824:	8b 40 48             	mov    0x48(%eax),%eax
  801827:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80182b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182f:	c7 04 24 05 32 80 00 	movl   $0x803205,(%esp)
  801836:	e8 09 eb ff ff       	call   800344 <cprintf>
		return -E_INVAL;
  80183b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801840:	eb 24                	jmp    801866 <read+0x8c>
	}
	if (!dev->dev_read)
  801842:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801845:	8b 52 08             	mov    0x8(%edx),%edx
  801848:	85 d2                	test   %edx,%edx
  80184a:	74 15                	je     801861 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80184c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80184f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801853:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801856:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80185a:	89 04 24             	mov    %eax,(%esp)
  80185d:	ff d2                	call   *%edx
  80185f:	eb 05                	jmp    801866 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801861:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801866:	83 c4 24             	add    $0x24,%esp
  801869:	5b                   	pop    %ebx
  80186a:	5d                   	pop    %ebp
  80186b:	c3                   	ret    

0080186c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	57                   	push   %edi
  801870:	56                   	push   %esi
  801871:	53                   	push   %ebx
  801872:	83 ec 1c             	sub    $0x1c,%esp
  801875:	8b 7d 08             	mov    0x8(%ebp),%edi
  801878:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80187b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801880:	eb 23                	jmp    8018a5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801882:	89 f0                	mov    %esi,%eax
  801884:	29 d8                	sub    %ebx,%eax
  801886:	89 44 24 08          	mov    %eax,0x8(%esp)
  80188a:	89 d8                	mov    %ebx,%eax
  80188c:	03 45 0c             	add    0xc(%ebp),%eax
  80188f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801893:	89 3c 24             	mov    %edi,(%esp)
  801896:	e8 3f ff ff ff       	call   8017da <read>
		if (m < 0)
  80189b:	85 c0                	test   %eax,%eax
  80189d:	78 10                	js     8018af <readn+0x43>
			return m;
		if (m == 0)
  80189f:	85 c0                	test   %eax,%eax
  8018a1:	74 0a                	je     8018ad <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018a3:	01 c3                	add    %eax,%ebx
  8018a5:	39 f3                	cmp    %esi,%ebx
  8018a7:	72 d9                	jb     801882 <readn+0x16>
  8018a9:	89 d8                	mov    %ebx,%eax
  8018ab:	eb 02                	jmp    8018af <readn+0x43>
  8018ad:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8018af:	83 c4 1c             	add    $0x1c,%esp
  8018b2:	5b                   	pop    %ebx
  8018b3:	5e                   	pop    %esi
  8018b4:	5f                   	pop    %edi
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	53                   	push   %ebx
  8018bb:	83 ec 24             	sub    $0x24,%esp
  8018be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c8:	89 1c 24             	mov    %ebx,(%esp)
  8018cb:	e8 76 fc ff ff       	call   801546 <fd_lookup>
  8018d0:	89 c2                	mov    %eax,%edx
  8018d2:	85 d2                	test   %edx,%edx
  8018d4:	78 68                	js     80193e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e0:	8b 00                	mov    (%eax),%eax
  8018e2:	89 04 24             	mov    %eax,(%esp)
  8018e5:	e8 b2 fc ff ff       	call   80159c <dev_lookup>
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	78 50                	js     80193e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018f5:	75 23                	jne    80191a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018f7:	a1 08 50 80 00       	mov    0x805008,%eax
  8018fc:	8b 40 48             	mov    0x48(%eax),%eax
  8018ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801903:	89 44 24 04          	mov    %eax,0x4(%esp)
  801907:	c7 04 24 21 32 80 00 	movl   $0x803221,(%esp)
  80190e:	e8 31 ea ff ff       	call   800344 <cprintf>
		return -E_INVAL;
  801913:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801918:	eb 24                	jmp    80193e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80191a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80191d:	8b 52 0c             	mov    0xc(%edx),%edx
  801920:	85 d2                	test   %edx,%edx
  801922:	74 15                	je     801939 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801924:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801927:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80192b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80192e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801932:	89 04 24             	mov    %eax,(%esp)
  801935:	ff d2                	call   *%edx
  801937:	eb 05                	jmp    80193e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801939:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80193e:	83 c4 24             	add    $0x24,%esp
  801941:	5b                   	pop    %ebx
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    

00801944 <seek>:

int
seek(int fdnum, off_t offset)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80194a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80194d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	89 04 24             	mov    %eax,(%esp)
  801957:	e8 ea fb ff ff       	call   801546 <fd_lookup>
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 0e                	js     80196e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801960:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801963:	8b 55 0c             	mov    0xc(%ebp),%edx
  801966:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801969:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	53                   	push   %ebx
  801974:	83 ec 24             	sub    $0x24,%esp
  801977:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80197a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80197d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801981:	89 1c 24             	mov    %ebx,(%esp)
  801984:	e8 bd fb ff ff       	call   801546 <fd_lookup>
  801989:	89 c2                	mov    %eax,%edx
  80198b:	85 d2                	test   %edx,%edx
  80198d:	78 61                	js     8019f0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80198f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801992:	89 44 24 04          	mov    %eax,0x4(%esp)
  801996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801999:	8b 00                	mov    (%eax),%eax
  80199b:	89 04 24             	mov    %eax,(%esp)
  80199e:	e8 f9 fb ff ff       	call   80159c <dev_lookup>
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	78 49                	js     8019f0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019aa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019ae:	75 23                	jne    8019d3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8019b0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019b5:	8b 40 48             	mov    0x48(%eax),%eax
  8019b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c0:	c7 04 24 e4 31 80 00 	movl   $0x8031e4,(%esp)
  8019c7:	e8 78 e9 ff ff       	call   800344 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8019cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019d1:	eb 1d                	jmp    8019f0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8019d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019d6:	8b 52 18             	mov    0x18(%edx),%edx
  8019d9:	85 d2                	test   %edx,%edx
  8019db:	74 0e                	je     8019eb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019e0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019e4:	89 04 24             	mov    %eax,(%esp)
  8019e7:	ff d2                	call   *%edx
  8019e9:	eb 05                	jmp    8019f0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8019eb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8019f0:	83 c4 24             	add    $0x24,%esp
  8019f3:	5b                   	pop    %ebx
  8019f4:	5d                   	pop    %ebp
  8019f5:	c3                   	ret    

008019f6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	53                   	push   %ebx
  8019fa:	83 ec 24             	sub    $0x24,%esp
  8019fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a00:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	89 04 24             	mov    %eax,(%esp)
  801a0d:	e8 34 fb ff ff       	call   801546 <fd_lookup>
  801a12:	89 c2                	mov    %eax,%edx
  801a14:	85 d2                	test   %edx,%edx
  801a16:	78 52                	js     801a6a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a22:	8b 00                	mov    (%eax),%eax
  801a24:	89 04 24             	mov    %eax,(%esp)
  801a27:	e8 70 fb ff ff       	call   80159c <dev_lookup>
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	78 3a                	js     801a6a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a33:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a37:	74 2c                	je     801a65 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a39:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a3c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a43:	00 00 00 
	stat->st_isdir = 0;
  801a46:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a4d:	00 00 00 
	stat->st_dev = dev;
  801a50:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a56:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a5d:	89 14 24             	mov    %edx,(%esp)
  801a60:	ff 50 14             	call   *0x14(%eax)
  801a63:	eb 05                	jmp    801a6a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801a65:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801a6a:	83 c4 24             	add    $0x24,%esp
  801a6d:	5b                   	pop    %ebx
  801a6e:	5d                   	pop    %ebp
  801a6f:	c3                   	ret    

00801a70 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	56                   	push   %esi
  801a74:	53                   	push   %ebx
  801a75:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a7f:	00 
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	89 04 24             	mov    %eax,(%esp)
  801a86:	e8 84 02 00 00       	call   801d0f <open>
  801a8b:	89 c3                	mov    %eax,%ebx
  801a8d:	85 db                	test   %ebx,%ebx
  801a8f:	78 1b                	js     801aac <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a98:	89 1c 24             	mov    %ebx,(%esp)
  801a9b:	e8 56 ff ff ff       	call   8019f6 <fstat>
  801aa0:	89 c6                	mov    %eax,%esi
	close(fd);
  801aa2:	89 1c 24             	mov    %ebx,(%esp)
  801aa5:	e8 cd fb ff ff       	call   801677 <close>
	return r;
  801aaa:	89 f0                	mov    %esi,%eax
}
  801aac:	83 c4 10             	add    $0x10,%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5d                   	pop    %ebp
  801ab2:	c3                   	ret    

00801ab3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	56                   	push   %esi
  801ab7:	53                   	push   %ebx
  801ab8:	83 ec 10             	sub    $0x10,%esp
  801abb:	89 c6                	mov    %eax,%esi
  801abd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801abf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ac6:	75 11                	jne    801ad9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ac8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801acf:	e8 b1 0e 00 00       	call   802985 <ipc_find_env>
  801ad4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ad9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ae0:	00 
  801ae1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801ae8:	00 
  801ae9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801aed:	a1 00 50 80 00       	mov    0x805000,%eax
  801af2:	89 04 24             	mov    %eax,(%esp)
  801af5:	e8 fe 0d 00 00       	call   8028f8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801afa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b01:	00 
  801b02:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b0d:	e8 7e 0d 00 00       	call   802890 <ipc_recv>
}
  801b12:	83 c4 10             	add    $0x10,%esp
  801b15:	5b                   	pop    %ebx
  801b16:	5e                   	pop    %esi
  801b17:	5d                   	pop    %ebp
  801b18:	c3                   	ret    

00801b19 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	8b 40 0c             	mov    0xc(%eax),%eax
  801b25:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b32:	ba 00 00 00 00       	mov    $0x0,%edx
  801b37:	b8 02 00 00 00       	mov    $0x2,%eax
  801b3c:	e8 72 ff ff ff       	call   801ab3 <fsipc>
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b4f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b54:	ba 00 00 00 00       	mov    $0x0,%edx
  801b59:	b8 06 00 00 00       	mov    $0x6,%eax
  801b5e:	e8 50 ff ff ff       	call   801ab3 <fsipc>
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	53                   	push   %ebx
  801b69:	83 ec 14             	sub    $0x14,%esp
  801b6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	8b 40 0c             	mov    0xc(%eax),%eax
  801b75:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b7a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b7f:	b8 05 00 00 00       	mov    $0x5,%eax
  801b84:	e8 2a ff ff ff       	call   801ab3 <fsipc>
  801b89:	89 c2                	mov    %eax,%edx
  801b8b:	85 d2                	test   %edx,%edx
  801b8d:	78 2b                	js     801bba <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b8f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b96:	00 
  801b97:	89 1c 24             	mov    %ebx,(%esp)
  801b9a:	e8 c8 ed ff ff       	call   800967 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b9f:	a1 80 60 80 00       	mov    0x806080,%eax
  801ba4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801baa:	a1 84 60 80 00       	mov    0x806084,%eax
  801baf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bba:	83 c4 14             	add    $0x14,%esp
  801bbd:	5b                   	pop    %ebx
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    

00801bc0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	53                   	push   %ebx
  801bc4:	83 ec 14             	sub    $0x14,%esp
  801bc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801bd5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801bdb:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801be0:	0f 46 c3             	cmovbe %ebx,%eax
  801be3:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801be8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bef:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf3:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801bfa:	e8 05 ef ff ff       	call   800b04 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801bff:	ba 00 00 00 00       	mov    $0x0,%edx
  801c04:	b8 04 00 00 00       	mov    $0x4,%eax
  801c09:	e8 a5 fe ff ff       	call   801ab3 <fsipc>
  801c0e:	85 c0                	test   %eax,%eax
  801c10:	78 53                	js     801c65 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801c12:	39 c3                	cmp    %eax,%ebx
  801c14:	73 24                	jae    801c3a <devfile_write+0x7a>
  801c16:	c7 44 24 0c 54 32 80 	movl   $0x803254,0xc(%esp)
  801c1d:	00 
  801c1e:	c7 44 24 08 5b 32 80 	movl   $0x80325b,0x8(%esp)
  801c25:	00 
  801c26:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801c2d:	00 
  801c2e:	c7 04 24 70 32 80 00 	movl   $0x803270,(%esp)
  801c35:	e8 11 e6 ff ff       	call   80024b <_panic>
	assert(r <= PGSIZE);
  801c3a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c3f:	7e 24                	jle    801c65 <devfile_write+0xa5>
  801c41:	c7 44 24 0c 7b 32 80 	movl   $0x80327b,0xc(%esp)
  801c48:	00 
  801c49:	c7 44 24 08 5b 32 80 	movl   $0x80325b,0x8(%esp)
  801c50:	00 
  801c51:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801c58:	00 
  801c59:	c7 04 24 70 32 80 00 	movl   $0x803270,(%esp)
  801c60:	e8 e6 e5 ff ff       	call   80024b <_panic>
	return r;
}
  801c65:	83 c4 14             	add    $0x14,%esp
  801c68:	5b                   	pop    %ebx
  801c69:	5d                   	pop    %ebp
  801c6a:	c3                   	ret    

00801c6b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	56                   	push   %esi
  801c6f:	53                   	push   %ebx
  801c70:	83 ec 10             	sub    $0x10,%esp
  801c73:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	8b 40 0c             	mov    0xc(%eax),%eax
  801c7c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c81:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c87:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8c:	b8 03 00 00 00       	mov    $0x3,%eax
  801c91:	e8 1d fe ff ff       	call   801ab3 <fsipc>
  801c96:	89 c3                	mov    %eax,%ebx
  801c98:	85 c0                	test   %eax,%eax
  801c9a:	78 6a                	js     801d06 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c9c:	39 c6                	cmp    %eax,%esi
  801c9e:	73 24                	jae    801cc4 <devfile_read+0x59>
  801ca0:	c7 44 24 0c 54 32 80 	movl   $0x803254,0xc(%esp)
  801ca7:	00 
  801ca8:	c7 44 24 08 5b 32 80 	movl   $0x80325b,0x8(%esp)
  801caf:	00 
  801cb0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801cb7:	00 
  801cb8:	c7 04 24 70 32 80 00 	movl   $0x803270,(%esp)
  801cbf:	e8 87 e5 ff ff       	call   80024b <_panic>
	assert(r <= PGSIZE);
  801cc4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cc9:	7e 24                	jle    801cef <devfile_read+0x84>
  801ccb:	c7 44 24 0c 7b 32 80 	movl   $0x80327b,0xc(%esp)
  801cd2:	00 
  801cd3:	c7 44 24 08 5b 32 80 	movl   $0x80325b,0x8(%esp)
  801cda:	00 
  801cdb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801ce2:	00 
  801ce3:	c7 04 24 70 32 80 00 	movl   $0x803270,(%esp)
  801cea:	e8 5c e5 ff ff       	call   80024b <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cef:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cf3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cfa:	00 
  801cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfe:	89 04 24             	mov    %eax,(%esp)
  801d01:	e8 fe ed ff ff       	call   800b04 <memmove>
	return r;
}
  801d06:	89 d8                	mov    %ebx,%eax
  801d08:	83 c4 10             	add    $0x10,%esp
  801d0b:	5b                   	pop    %ebx
  801d0c:	5e                   	pop    %esi
  801d0d:	5d                   	pop    %ebp
  801d0e:	c3                   	ret    

00801d0f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	53                   	push   %ebx
  801d13:	83 ec 24             	sub    $0x24,%esp
  801d16:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d19:	89 1c 24             	mov    %ebx,(%esp)
  801d1c:	e8 0f ec ff ff       	call   800930 <strlen>
  801d21:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d26:	7f 60                	jg     801d88 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d2b:	89 04 24             	mov    %eax,(%esp)
  801d2e:	e8 c4 f7 ff ff       	call   8014f7 <fd_alloc>
  801d33:	89 c2                	mov    %eax,%edx
  801d35:	85 d2                	test   %edx,%edx
  801d37:	78 54                	js     801d8d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d39:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d3d:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801d44:	e8 1e ec ff ff       	call   800967 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d54:	b8 01 00 00 00       	mov    $0x1,%eax
  801d59:	e8 55 fd ff ff       	call   801ab3 <fsipc>
  801d5e:	89 c3                	mov    %eax,%ebx
  801d60:	85 c0                	test   %eax,%eax
  801d62:	79 17                	jns    801d7b <open+0x6c>
		fd_close(fd, 0);
  801d64:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d6b:	00 
  801d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6f:	89 04 24             	mov    %eax,(%esp)
  801d72:	e8 7f f8 ff ff       	call   8015f6 <fd_close>
		return r;
  801d77:	89 d8                	mov    %ebx,%eax
  801d79:	eb 12                	jmp    801d8d <open+0x7e>
	}

	return fd2num(fd);
  801d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7e:	89 04 24             	mov    %eax,(%esp)
  801d81:	e8 4a f7 ff ff       	call   8014d0 <fd2num>
  801d86:	eb 05                	jmp    801d8d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801d88:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801d8d:	83 c4 24             	add    $0x24,%esp
  801d90:	5b                   	pop    %ebx
  801d91:	5d                   	pop    %ebp
  801d92:	c3                   	ret    

00801d93 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d99:	ba 00 00 00 00       	mov    $0x0,%edx
  801d9e:	b8 08 00 00 00       	mov    $0x8,%eax
  801da3:	e8 0b fd ff ff       	call   801ab3 <fsipc>
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    
  801daa:	66 90                	xchg   %ax,%ax
  801dac:	66 90                	xchg   %ax,%ax
  801dae:	66 90                	xchg   %ax,%ax

00801db0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801db6:	c7 44 24 04 87 32 80 	movl   $0x803287,0x4(%esp)
  801dbd:	00 
  801dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc1:	89 04 24             	mov    %eax,(%esp)
  801dc4:	e8 9e eb ff ff       	call   800967 <strcpy>
	return 0;
}
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 14             	sub    $0x14,%esp
  801dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801dda:	89 1c 24             	mov    %ebx,(%esp)
  801ddd:	e8 dd 0b 00 00       	call   8029bf <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801de2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801de7:	83 f8 01             	cmp    $0x1,%eax
  801dea:	75 0d                	jne    801df9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801dec:	8b 43 0c             	mov    0xc(%ebx),%eax
  801def:	89 04 24             	mov    %eax,(%esp)
  801df2:	e8 29 03 00 00       	call   802120 <nsipc_close>
  801df7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801df9:	89 d0                	mov    %edx,%eax
  801dfb:	83 c4 14             	add    $0x14,%esp
  801dfe:	5b                   	pop    %ebx
  801dff:	5d                   	pop    %ebp
  801e00:	c3                   	ret    

00801e01 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
  801e04:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e07:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e0e:	00 
  801e0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e12:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	8b 40 0c             	mov    0xc(%eax),%eax
  801e23:	89 04 24             	mov    %eax,(%esp)
  801e26:	e8 f0 03 00 00       	call   80221b <nsipc_send>
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
  801e30:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e33:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e3a:	00 
  801e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e45:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e4f:	89 04 24             	mov    %eax,(%esp)
  801e52:	e8 44 03 00 00       	call   80219b <nsipc_recv>
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e5f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801e62:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e66:	89 04 24             	mov    %eax,(%esp)
  801e69:	e8 d8 f6 ff ff       	call   801546 <fd_lookup>
  801e6e:	85 c0                	test   %eax,%eax
  801e70:	78 17                	js     801e89 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e75:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801e7b:	39 08                	cmp    %ecx,(%eax)
  801e7d:	75 05                	jne    801e84 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801e7f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e82:	eb 05                	jmp    801e89 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801e84:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	56                   	push   %esi
  801e8f:	53                   	push   %ebx
  801e90:	83 ec 20             	sub    $0x20,%esp
  801e93:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801e95:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e98:	89 04 24             	mov    %eax,(%esp)
  801e9b:	e8 57 f6 ff ff       	call   8014f7 <fd_alloc>
  801ea0:	89 c3                	mov    %eax,%ebx
  801ea2:	85 c0                	test   %eax,%eax
  801ea4:	78 21                	js     801ec7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ea6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ead:	00 
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ebc:	e8 c2 ee ff ff       	call   800d83 <sys_page_alloc>
  801ec1:	89 c3                	mov    %eax,%ebx
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	79 0c                	jns    801ed3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801ec7:	89 34 24             	mov    %esi,(%esp)
  801eca:	e8 51 02 00 00       	call   802120 <nsipc_close>
		return r;
  801ecf:	89 d8                	mov    %ebx,%eax
  801ed1:	eb 20                	jmp    801ef3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801ed3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801ede:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801ee8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801eeb:	89 14 24             	mov    %edx,(%esp)
  801eee:	e8 dd f5 ff ff       	call   8014d0 <fd2num>
}
  801ef3:	83 c4 20             	add    $0x20,%esp
  801ef6:	5b                   	pop    %ebx
  801ef7:	5e                   	pop    %esi
  801ef8:	5d                   	pop    %ebp
  801ef9:	c3                   	ret    

00801efa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f00:	8b 45 08             	mov    0x8(%ebp),%eax
  801f03:	e8 51 ff ff ff       	call   801e59 <fd2sockid>
		return r;
  801f08:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	78 23                	js     801f31 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f0e:	8b 55 10             	mov    0x10(%ebp),%edx
  801f11:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f18:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f1c:	89 04 24             	mov    %eax,(%esp)
  801f1f:	e8 45 01 00 00       	call   802069 <nsipc_accept>
		return r;
  801f24:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f26:	85 c0                	test   %eax,%eax
  801f28:	78 07                	js     801f31 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801f2a:	e8 5c ff ff ff       	call   801e8b <alloc_sockfd>
  801f2f:	89 c1                	mov    %eax,%ecx
}
  801f31:	89 c8                	mov    %ecx,%eax
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
  801f38:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	e8 16 ff ff ff       	call   801e59 <fd2sockid>
  801f43:	89 c2                	mov    %eax,%edx
  801f45:	85 d2                	test   %edx,%edx
  801f47:	78 16                	js     801f5f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801f49:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f53:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f57:	89 14 24             	mov    %edx,(%esp)
  801f5a:	e8 60 01 00 00       	call   8020bf <nsipc_bind>
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <shutdown>:

int
shutdown(int s, int how)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f67:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6a:	e8 ea fe ff ff       	call   801e59 <fd2sockid>
  801f6f:	89 c2                	mov    %eax,%edx
  801f71:	85 d2                	test   %edx,%edx
  801f73:	78 0f                	js     801f84 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f7c:	89 14 24             	mov    %edx,(%esp)
  801f7f:	e8 7a 01 00 00       	call   8020fe <nsipc_shutdown>
}
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    

00801f86 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp
  801f89:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8f:	e8 c5 fe ff ff       	call   801e59 <fd2sockid>
  801f94:	89 c2                	mov    %eax,%edx
  801f96:	85 d2                	test   %edx,%edx
  801f98:	78 16                	js     801fb0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801f9a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa8:	89 14 24             	mov    %edx,(%esp)
  801fab:	e8 8a 01 00 00       	call   80213a <nsipc_connect>
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <listen>:

int
listen(int s, int backlog)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbb:	e8 99 fe ff ff       	call   801e59 <fd2sockid>
  801fc0:	89 c2                	mov    %eax,%edx
  801fc2:	85 d2                	test   %edx,%edx
  801fc4:	78 0f                	js     801fd5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fcd:	89 14 24             	mov    %edx,(%esp)
  801fd0:	e8 a4 01 00 00       	call   802179 <nsipc_listen>
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fdd:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	89 04 24             	mov    %eax,(%esp)
  801ff1:	e8 98 02 00 00       	call   80228e <nsipc_socket>
  801ff6:	89 c2                	mov    %eax,%edx
  801ff8:	85 d2                	test   %edx,%edx
  801ffa:	78 05                	js     802001 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801ffc:	e8 8a fe ff ff       	call   801e8b <alloc_sockfd>
}
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	53                   	push   %ebx
  802007:	83 ec 14             	sub    $0x14,%esp
  80200a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80200c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802013:	75 11                	jne    802026 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802015:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80201c:	e8 64 09 00 00       	call   802985 <ipc_find_env>
  802021:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802026:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80202d:	00 
  80202e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802035:	00 
  802036:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80203a:	a1 04 50 80 00       	mov    0x805004,%eax
  80203f:	89 04 24             	mov    %eax,(%esp)
  802042:	e8 b1 08 00 00       	call   8028f8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802047:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80204e:	00 
  80204f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802056:	00 
  802057:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80205e:	e8 2d 08 00 00       	call   802890 <ipc_recv>
}
  802063:	83 c4 14             	add    $0x14,%esp
  802066:	5b                   	pop    %ebx
  802067:	5d                   	pop    %ebp
  802068:	c3                   	ret    

00802069 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	56                   	push   %esi
  80206d:	53                   	push   %ebx
  80206e:	83 ec 10             	sub    $0x10,%esp
  802071:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80207c:	8b 06                	mov    (%esi),%eax
  80207e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802083:	b8 01 00 00 00       	mov    $0x1,%eax
  802088:	e8 76 ff ff ff       	call   802003 <nsipc>
  80208d:	89 c3                	mov    %eax,%ebx
  80208f:	85 c0                	test   %eax,%eax
  802091:	78 23                	js     8020b6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802093:	a1 10 70 80 00       	mov    0x807010,%eax
  802098:	89 44 24 08          	mov    %eax,0x8(%esp)
  80209c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8020a3:	00 
  8020a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a7:	89 04 24             	mov    %eax,(%esp)
  8020aa:	e8 55 ea ff ff       	call   800b04 <memmove>
		*addrlen = ret->ret_addrlen;
  8020af:	a1 10 70 80 00       	mov    0x807010,%eax
  8020b4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8020b6:	89 d8                	mov    %ebx,%eax
  8020b8:	83 c4 10             	add    $0x10,%esp
  8020bb:	5b                   	pop    %ebx
  8020bc:	5e                   	pop    %esi
  8020bd:	5d                   	pop    %ebp
  8020be:	c3                   	ret    

008020bf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	53                   	push   %ebx
  8020c3:	83 ec 14             	sub    $0x14,%esp
  8020c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020d1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020dc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8020e3:	e8 1c ea ff ff       	call   800b04 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020e8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8020ee:	b8 02 00 00 00       	mov    $0x2,%eax
  8020f3:	e8 0b ff ff ff       	call   802003 <nsipc>
}
  8020f8:	83 c4 14             	add    $0x14,%esp
  8020fb:	5b                   	pop    %ebx
  8020fc:	5d                   	pop    %ebp
  8020fd:	c3                   	ret    

008020fe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80210c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80210f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802114:	b8 03 00 00 00       	mov    $0x3,%eax
  802119:	e8 e5 fe ff ff       	call   802003 <nsipc>
}
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <nsipc_close>:

int
nsipc_close(int s)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80212e:	b8 04 00 00 00       	mov    $0x4,%eax
  802133:	e8 cb fe ff ff       	call   802003 <nsipc>
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	53                   	push   %ebx
  80213e:	83 ec 14             	sub    $0x14,%esp
  802141:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80214c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802150:	8b 45 0c             	mov    0xc(%ebp),%eax
  802153:	89 44 24 04          	mov    %eax,0x4(%esp)
  802157:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80215e:	e8 a1 e9 ff ff       	call   800b04 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802163:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802169:	b8 05 00 00 00       	mov    $0x5,%eax
  80216e:	e8 90 fe ff ff       	call   802003 <nsipc>
}
  802173:	83 c4 14             	add    $0x14,%esp
  802176:	5b                   	pop    %ebx
  802177:	5d                   	pop    %ebp
  802178:	c3                   	ret    

00802179 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
  80217c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80218f:	b8 06 00 00 00       	mov    $0x6,%eax
  802194:	e8 6a fe ff ff       	call   802003 <nsipc>
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	56                   	push   %esi
  80219f:	53                   	push   %ebx
  8021a0:	83 ec 10             	sub    $0x10,%esp
  8021a3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021ae:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8021b7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021bc:	b8 07 00 00 00       	mov    $0x7,%eax
  8021c1:	e8 3d fe ff ff       	call   802003 <nsipc>
  8021c6:	89 c3                	mov    %eax,%ebx
  8021c8:	85 c0                	test   %eax,%eax
  8021ca:	78 46                	js     802212 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8021cc:	39 f0                	cmp    %esi,%eax
  8021ce:	7f 07                	jg     8021d7 <nsipc_recv+0x3c>
  8021d0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8021d5:	7e 24                	jle    8021fb <nsipc_recv+0x60>
  8021d7:	c7 44 24 0c 93 32 80 	movl   $0x803293,0xc(%esp)
  8021de:	00 
  8021df:	c7 44 24 08 5b 32 80 	movl   $0x80325b,0x8(%esp)
  8021e6:	00 
  8021e7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8021ee:	00 
  8021ef:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  8021f6:	e8 50 e0 ff ff       	call   80024b <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8021fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021ff:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802206:	00 
  802207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220a:	89 04 24             	mov    %eax,(%esp)
  80220d:	e8 f2 e8 ff ff       	call   800b04 <memmove>
	}

	return r;
}
  802212:	89 d8                	mov    %ebx,%eax
  802214:	83 c4 10             	add    $0x10,%esp
  802217:	5b                   	pop    %ebx
  802218:	5e                   	pop    %esi
  802219:	5d                   	pop    %ebp
  80221a:	c3                   	ret    

0080221b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	53                   	push   %ebx
  80221f:	83 ec 14             	sub    $0x14,%esp
  802222:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80222d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802233:	7e 24                	jle    802259 <nsipc_send+0x3e>
  802235:	c7 44 24 0c b4 32 80 	movl   $0x8032b4,0xc(%esp)
  80223c:	00 
  80223d:	c7 44 24 08 5b 32 80 	movl   $0x80325b,0x8(%esp)
  802244:	00 
  802245:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80224c:	00 
  80224d:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  802254:	e8 f2 df ff ff       	call   80024b <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802259:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80225d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802260:	89 44 24 04          	mov    %eax,0x4(%esp)
  802264:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80226b:	e8 94 e8 ff ff       	call   800b04 <memmove>
	nsipcbuf.send.req_size = size;
  802270:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802276:	8b 45 14             	mov    0x14(%ebp),%eax
  802279:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80227e:	b8 08 00 00 00       	mov    $0x8,%eax
  802283:	e8 7b fd ff ff       	call   802003 <nsipc>
}
  802288:	83 c4 14             	add    $0x14,%esp
  80228b:	5b                   	pop    %ebx
  80228c:	5d                   	pop    %ebp
  80228d:	c3                   	ret    

0080228e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
  802291:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80229c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022ac:	b8 09 00 00 00       	mov    $0x9,%eax
  8022b1:	e8 4d fd ff ff       	call   802003 <nsipc>
}
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	56                   	push   %esi
  8022bc:	53                   	push   %ebx
  8022bd:	83 ec 10             	sub    $0x10,%esp
  8022c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	89 04 24             	mov    %eax,(%esp)
  8022c9:	e8 12 f2 ff ff       	call   8014e0 <fd2data>
  8022ce:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8022d0:	c7 44 24 04 c0 32 80 	movl   $0x8032c0,0x4(%esp)
  8022d7:	00 
  8022d8:	89 1c 24             	mov    %ebx,(%esp)
  8022db:	e8 87 e6 ff ff       	call   800967 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8022e0:	8b 46 04             	mov    0x4(%esi),%eax
  8022e3:	2b 06                	sub    (%esi),%eax
  8022e5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8022eb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8022f2:	00 00 00 
	stat->st_dev = &devpipe;
  8022f5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8022fc:	40 80 00 
	return 0;
}
  8022ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802304:	83 c4 10             	add    $0x10,%esp
  802307:	5b                   	pop    %ebx
  802308:	5e                   	pop    %esi
  802309:	5d                   	pop    %ebp
  80230a:	c3                   	ret    

0080230b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80230b:	55                   	push   %ebp
  80230c:	89 e5                	mov    %esp,%ebp
  80230e:	53                   	push   %ebx
  80230f:	83 ec 14             	sub    $0x14,%esp
  802312:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802315:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802319:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802320:	e8 05 eb ff ff       	call   800e2a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802325:	89 1c 24             	mov    %ebx,(%esp)
  802328:	e8 b3 f1 ff ff       	call   8014e0 <fd2data>
  80232d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802331:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802338:	e8 ed ea ff ff       	call   800e2a <sys_page_unmap>
}
  80233d:	83 c4 14             	add    $0x14,%esp
  802340:	5b                   	pop    %ebx
  802341:	5d                   	pop    %ebp
  802342:	c3                   	ret    

00802343 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
  802346:	57                   	push   %edi
  802347:	56                   	push   %esi
  802348:	53                   	push   %ebx
  802349:	83 ec 2c             	sub    $0x2c,%esp
  80234c:	89 c6                	mov    %eax,%esi
  80234e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802351:	a1 08 50 80 00       	mov    0x805008,%eax
  802356:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802359:	89 34 24             	mov    %esi,(%esp)
  80235c:	e8 5e 06 00 00       	call   8029bf <pageref>
  802361:	89 c7                	mov    %eax,%edi
  802363:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802366:	89 04 24             	mov    %eax,(%esp)
  802369:	e8 51 06 00 00       	call   8029bf <pageref>
  80236e:	39 c7                	cmp    %eax,%edi
  802370:	0f 94 c2             	sete   %dl
  802373:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802376:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80237c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80237f:	39 fb                	cmp    %edi,%ebx
  802381:	74 21                	je     8023a4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802383:	84 d2                	test   %dl,%dl
  802385:	74 ca                	je     802351 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802387:	8b 51 58             	mov    0x58(%ecx),%edx
  80238a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80238e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802392:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802396:	c7 04 24 c7 32 80 00 	movl   $0x8032c7,(%esp)
  80239d:	e8 a2 df ff ff       	call   800344 <cprintf>
  8023a2:	eb ad                	jmp    802351 <_pipeisclosed+0xe>
	}
}
  8023a4:	83 c4 2c             	add    $0x2c,%esp
  8023a7:	5b                   	pop    %ebx
  8023a8:	5e                   	pop    %esi
  8023a9:	5f                   	pop    %edi
  8023aa:	5d                   	pop    %ebp
  8023ab:	c3                   	ret    

008023ac <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023ac:	55                   	push   %ebp
  8023ad:	89 e5                	mov    %esp,%ebp
  8023af:	57                   	push   %edi
  8023b0:	56                   	push   %esi
  8023b1:	53                   	push   %ebx
  8023b2:	83 ec 1c             	sub    $0x1c,%esp
  8023b5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8023b8:	89 34 24             	mov    %esi,(%esp)
  8023bb:	e8 20 f1 ff ff       	call   8014e0 <fd2data>
  8023c0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8023c7:	eb 45                	jmp    80240e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8023c9:	89 da                	mov    %ebx,%edx
  8023cb:	89 f0                	mov    %esi,%eax
  8023cd:	e8 71 ff ff ff       	call   802343 <_pipeisclosed>
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	75 41                	jne    802417 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8023d6:	e8 89 e9 ff ff       	call   800d64 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8023db:	8b 43 04             	mov    0x4(%ebx),%eax
  8023de:	8b 0b                	mov    (%ebx),%ecx
  8023e0:	8d 51 20             	lea    0x20(%ecx),%edx
  8023e3:	39 d0                	cmp    %edx,%eax
  8023e5:	73 e2                	jae    8023c9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8023e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023ea:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8023ee:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8023f1:	99                   	cltd   
  8023f2:	c1 ea 1b             	shr    $0x1b,%edx
  8023f5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8023f8:	83 e1 1f             	and    $0x1f,%ecx
  8023fb:	29 d1                	sub    %edx,%ecx
  8023fd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802401:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802405:	83 c0 01             	add    $0x1,%eax
  802408:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80240b:	83 c7 01             	add    $0x1,%edi
  80240e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802411:	75 c8                	jne    8023db <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802413:	89 f8                	mov    %edi,%eax
  802415:	eb 05                	jmp    80241c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80241c:	83 c4 1c             	add    $0x1c,%esp
  80241f:	5b                   	pop    %ebx
  802420:	5e                   	pop    %esi
  802421:	5f                   	pop    %edi
  802422:	5d                   	pop    %ebp
  802423:	c3                   	ret    

00802424 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
  802427:	57                   	push   %edi
  802428:	56                   	push   %esi
  802429:	53                   	push   %ebx
  80242a:	83 ec 1c             	sub    $0x1c,%esp
  80242d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802430:	89 3c 24             	mov    %edi,(%esp)
  802433:	e8 a8 f0 ff ff       	call   8014e0 <fd2data>
  802438:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80243a:	be 00 00 00 00       	mov    $0x0,%esi
  80243f:	eb 3d                	jmp    80247e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802441:	85 f6                	test   %esi,%esi
  802443:	74 04                	je     802449 <devpipe_read+0x25>
				return i;
  802445:	89 f0                	mov    %esi,%eax
  802447:	eb 43                	jmp    80248c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802449:	89 da                	mov    %ebx,%edx
  80244b:	89 f8                	mov    %edi,%eax
  80244d:	e8 f1 fe ff ff       	call   802343 <_pipeisclosed>
  802452:	85 c0                	test   %eax,%eax
  802454:	75 31                	jne    802487 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802456:	e8 09 e9 ff ff       	call   800d64 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80245b:	8b 03                	mov    (%ebx),%eax
  80245d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802460:	74 df                	je     802441 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802462:	99                   	cltd   
  802463:	c1 ea 1b             	shr    $0x1b,%edx
  802466:	01 d0                	add    %edx,%eax
  802468:	83 e0 1f             	and    $0x1f,%eax
  80246b:	29 d0                	sub    %edx,%eax
  80246d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802472:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802475:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802478:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80247b:	83 c6 01             	add    $0x1,%esi
  80247e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802481:	75 d8                	jne    80245b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802483:	89 f0                	mov    %esi,%eax
  802485:	eb 05                	jmp    80248c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802487:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80248c:	83 c4 1c             	add    $0x1c,%esp
  80248f:	5b                   	pop    %ebx
  802490:	5e                   	pop    %esi
  802491:	5f                   	pop    %edi
  802492:	5d                   	pop    %ebp
  802493:	c3                   	ret    

00802494 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
  802497:	56                   	push   %esi
  802498:	53                   	push   %ebx
  802499:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80249c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80249f:	89 04 24             	mov    %eax,(%esp)
  8024a2:	e8 50 f0 ff ff       	call   8014f7 <fd_alloc>
  8024a7:	89 c2                	mov    %eax,%edx
  8024a9:	85 d2                	test   %edx,%edx
  8024ab:	0f 88 4d 01 00 00    	js     8025fe <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024b1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024b8:	00 
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c7:	e8 b7 e8 ff ff       	call   800d83 <sys_page_alloc>
  8024cc:	89 c2                	mov    %eax,%edx
  8024ce:	85 d2                	test   %edx,%edx
  8024d0:	0f 88 28 01 00 00    	js     8025fe <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8024d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8024d9:	89 04 24             	mov    %eax,(%esp)
  8024dc:	e8 16 f0 ff ff       	call   8014f7 <fd_alloc>
  8024e1:	89 c3                	mov    %eax,%ebx
  8024e3:	85 c0                	test   %eax,%eax
  8024e5:	0f 88 fe 00 00 00    	js     8025e9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024eb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024f2:	00 
  8024f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802501:	e8 7d e8 ff ff       	call   800d83 <sys_page_alloc>
  802506:	89 c3                	mov    %eax,%ebx
  802508:	85 c0                	test   %eax,%eax
  80250a:	0f 88 d9 00 00 00    	js     8025e9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802513:	89 04 24             	mov    %eax,(%esp)
  802516:	e8 c5 ef ff ff       	call   8014e0 <fd2data>
  80251b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80251d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802524:	00 
  802525:	89 44 24 04          	mov    %eax,0x4(%esp)
  802529:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802530:	e8 4e e8 ff ff       	call   800d83 <sys_page_alloc>
  802535:	89 c3                	mov    %eax,%ebx
  802537:	85 c0                	test   %eax,%eax
  802539:	0f 88 97 00 00 00    	js     8025d6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80253f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802542:	89 04 24             	mov    %eax,(%esp)
  802545:	e8 96 ef ff ff       	call   8014e0 <fd2data>
  80254a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802551:	00 
  802552:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802556:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80255d:	00 
  80255e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802562:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802569:	e8 69 e8 ff ff       	call   800dd7 <sys_page_map>
  80256e:	89 c3                	mov    %eax,%ebx
  802570:	85 c0                	test   %eax,%eax
  802572:	78 52                	js     8025c6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802574:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802589:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80258f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802592:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802594:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802597:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	89 04 24             	mov    %eax,(%esp)
  8025a4:	e8 27 ef ff ff       	call   8014d0 <fd2num>
  8025a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025ac:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b1:	89 04 24             	mov    %eax,(%esp)
  8025b4:	e8 17 ef ff ff       	call   8014d0 <fd2num>
  8025b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025bc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c4:	eb 38                	jmp    8025fe <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8025c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025d1:	e8 54 e8 ff ff       	call   800e2a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8025d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025e4:	e8 41 e8 ff ff       	call   800e2a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025f7:	e8 2e e8 ff ff       	call   800e2a <sys_page_unmap>
  8025fc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8025fe:	83 c4 30             	add    $0x30,%esp
  802601:	5b                   	pop    %ebx
  802602:	5e                   	pop    %esi
  802603:	5d                   	pop    %ebp
  802604:	c3                   	ret    

00802605 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
  802608:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80260b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80260e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802612:	8b 45 08             	mov    0x8(%ebp),%eax
  802615:	89 04 24             	mov    %eax,(%esp)
  802618:	e8 29 ef ff ff       	call   801546 <fd_lookup>
  80261d:	89 c2                	mov    %eax,%edx
  80261f:	85 d2                	test   %edx,%edx
  802621:	78 15                	js     802638 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802623:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802626:	89 04 24             	mov    %eax,(%esp)
  802629:	e8 b2 ee ff ff       	call   8014e0 <fd2data>
	return _pipeisclosed(fd, p);
  80262e:	89 c2                	mov    %eax,%edx
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	e8 0b fd ff ff       	call   802343 <_pipeisclosed>
}
  802638:	c9                   	leave  
  802639:	c3                   	ret    
  80263a:	66 90                	xchg   %ax,%ax
  80263c:	66 90                	xchg   %ax,%ax
  80263e:	66 90                	xchg   %ax,%ax

00802640 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802643:	b8 00 00 00 00       	mov    $0x0,%eax
  802648:	5d                   	pop    %ebp
  802649:	c3                   	ret    

0080264a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80264a:	55                   	push   %ebp
  80264b:	89 e5                	mov    %esp,%ebp
  80264d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802650:	c7 44 24 04 df 32 80 	movl   $0x8032df,0x4(%esp)
  802657:	00 
  802658:	8b 45 0c             	mov    0xc(%ebp),%eax
  80265b:	89 04 24             	mov    %eax,(%esp)
  80265e:	e8 04 e3 ff ff       	call   800967 <strcpy>
	return 0;
}
  802663:	b8 00 00 00 00       	mov    $0x0,%eax
  802668:	c9                   	leave  
  802669:	c3                   	ret    

0080266a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
  80266d:	57                   	push   %edi
  80266e:	56                   	push   %esi
  80266f:	53                   	push   %ebx
  802670:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802676:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80267b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802681:	eb 31                	jmp    8026b4 <devcons_write+0x4a>
		m = n - tot;
  802683:	8b 75 10             	mov    0x10(%ebp),%esi
  802686:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802688:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80268b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802690:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802693:	89 74 24 08          	mov    %esi,0x8(%esp)
  802697:	03 45 0c             	add    0xc(%ebp),%eax
  80269a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80269e:	89 3c 24             	mov    %edi,(%esp)
  8026a1:	e8 5e e4 ff ff       	call   800b04 <memmove>
		sys_cputs(buf, m);
  8026a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026aa:	89 3c 24             	mov    %edi,(%esp)
  8026ad:	e8 04 e6 ff ff       	call   800cb6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026b2:	01 f3                	add    %esi,%ebx
  8026b4:	89 d8                	mov    %ebx,%eax
  8026b6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8026b9:	72 c8                	jb     802683 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8026bb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8026c1:	5b                   	pop    %ebx
  8026c2:	5e                   	pop    %esi
  8026c3:	5f                   	pop    %edi
  8026c4:	5d                   	pop    %ebp
  8026c5:	c3                   	ret    

008026c6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026c6:	55                   	push   %ebp
  8026c7:	89 e5                	mov    %esp,%ebp
  8026c9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8026cc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8026d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026d5:	75 07                	jne    8026de <devcons_read+0x18>
  8026d7:	eb 2a                	jmp    802703 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8026d9:	e8 86 e6 ff ff       	call   800d64 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8026de:	66 90                	xchg   %ax,%ax
  8026e0:	e8 ef e5 ff ff       	call   800cd4 <sys_cgetc>
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	74 f0                	je     8026d9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8026e9:	85 c0                	test   %eax,%eax
  8026eb:	78 16                	js     802703 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8026ed:	83 f8 04             	cmp    $0x4,%eax
  8026f0:	74 0c                	je     8026fe <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8026f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f5:	88 02                	mov    %al,(%edx)
	return 1;
  8026f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8026fc:	eb 05                	jmp    802703 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8026fe:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802703:	c9                   	leave  
  802704:	c3                   	ret    

00802705 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802705:	55                   	push   %ebp
  802706:	89 e5                	mov    %esp,%ebp
  802708:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80270b:	8b 45 08             	mov    0x8(%ebp),%eax
  80270e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802711:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802718:	00 
  802719:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80271c:	89 04 24             	mov    %eax,(%esp)
  80271f:	e8 92 e5 ff ff       	call   800cb6 <sys_cputs>
}
  802724:	c9                   	leave  
  802725:	c3                   	ret    

00802726 <getchar>:

int
getchar(void)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80272c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802733:	00 
  802734:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802737:	89 44 24 04          	mov    %eax,0x4(%esp)
  80273b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802742:	e8 93 f0 ff ff       	call   8017da <read>
	if (r < 0)
  802747:	85 c0                	test   %eax,%eax
  802749:	78 0f                	js     80275a <getchar+0x34>
		return r;
	if (r < 1)
  80274b:	85 c0                	test   %eax,%eax
  80274d:	7e 06                	jle    802755 <getchar+0x2f>
		return -E_EOF;
	return c;
  80274f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802753:	eb 05                	jmp    80275a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802755:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80275a:	c9                   	leave  
  80275b:	c3                   	ret    

0080275c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80275c:	55                   	push   %ebp
  80275d:	89 e5                	mov    %esp,%ebp
  80275f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802762:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802765:	89 44 24 04          	mov    %eax,0x4(%esp)
  802769:	8b 45 08             	mov    0x8(%ebp),%eax
  80276c:	89 04 24             	mov    %eax,(%esp)
  80276f:	e8 d2 ed ff ff       	call   801546 <fd_lookup>
  802774:	85 c0                	test   %eax,%eax
  802776:	78 11                	js     802789 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802781:	39 10                	cmp    %edx,(%eax)
  802783:	0f 94 c0             	sete   %al
  802786:	0f b6 c0             	movzbl %al,%eax
}
  802789:	c9                   	leave  
  80278a:	c3                   	ret    

0080278b <opencons>:

int
opencons(void)
{
  80278b:	55                   	push   %ebp
  80278c:	89 e5                	mov    %esp,%ebp
  80278e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802791:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802794:	89 04 24             	mov    %eax,(%esp)
  802797:	e8 5b ed ff ff       	call   8014f7 <fd_alloc>
		return r;
  80279c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	78 40                	js     8027e2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027a2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027a9:	00 
  8027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027b8:	e8 c6 e5 ff ff       	call   800d83 <sys_page_alloc>
		return r;
  8027bd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	78 1f                	js     8027e2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8027c3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8027d8:	89 04 24             	mov    %eax,(%esp)
  8027db:	e8 f0 ec ff ff       	call   8014d0 <fd2num>
  8027e0:	89 c2                	mov    %eax,%edx
}
  8027e2:	89 d0                	mov    %edx,%eax
  8027e4:	c9                   	leave  
  8027e5:	c3                   	ret    

008027e6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8027e6:	55                   	push   %ebp
  8027e7:	89 e5                	mov    %esp,%ebp
  8027e9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8027ec:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8027f3:	75 68                	jne    80285d <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  8027f5:	a1 08 50 80 00       	mov    0x805008,%eax
  8027fa:	8b 40 48             	mov    0x48(%eax),%eax
  8027fd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802804:	00 
  802805:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80280c:	ee 
  80280d:	89 04 24             	mov    %eax,(%esp)
  802810:	e8 6e e5 ff ff       	call   800d83 <sys_page_alloc>
  802815:	85 c0                	test   %eax,%eax
  802817:	74 2c                	je     802845 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  802819:	89 44 24 04          	mov    %eax,0x4(%esp)
  80281d:	c7 04 24 ec 32 80 00 	movl   $0x8032ec,(%esp)
  802824:	e8 1b db ff ff       	call   800344 <cprintf>
			panic("set_pg_fault_handler");
  802829:	c7 44 24 08 20 33 80 	movl   $0x803320,0x8(%esp)
  802830:	00 
  802831:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802838:	00 
  802839:	c7 04 24 35 33 80 00 	movl   $0x803335,(%esp)
  802840:	e8 06 da ff ff       	call   80024b <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802845:	a1 08 50 80 00       	mov    0x805008,%eax
  80284a:	8b 40 48             	mov    0x48(%eax),%eax
  80284d:	c7 44 24 04 67 28 80 	movl   $0x802867,0x4(%esp)
  802854:	00 
  802855:	89 04 24             	mov    %eax,(%esp)
  802858:	e8 c6 e6 ff ff       	call   800f23 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80285d:	8b 45 08             	mov    0x8(%ebp),%eax
  802860:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802865:	c9                   	leave  
  802866:	c3                   	ret    

00802867 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802867:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802868:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80286d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80286f:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  802872:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  802876:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  802878:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  80287c:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  80287d:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  802880:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  802882:	58                   	pop    %eax
	popl %eax
  802883:	58                   	pop    %eax
	popal
  802884:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802885:	83 c4 04             	add    $0x4,%esp
	popfl
  802888:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802889:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80288a:	c3                   	ret    
  80288b:	66 90                	xchg   %ax,%ax
  80288d:	66 90                	xchg   %ax,%ax
  80288f:	90                   	nop

00802890 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
  802893:	56                   	push   %esi
  802894:	53                   	push   %ebx
  802895:	83 ec 10             	sub    $0x10,%esp
  802898:	8b 75 08             	mov    0x8(%ebp),%esi
  80289b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80289e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8028a1:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  8028a3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8028a8:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  8028ab:	89 04 24             	mov    %eax,(%esp)
  8028ae:	e8 e6 e6 ff ff       	call   800f99 <sys_ipc_recv>
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	74 16                	je     8028cd <ipc_recv+0x3d>
		if (from_env_store != NULL)
  8028b7:	85 f6                	test   %esi,%esi
  8028b9:	74 06                	je     8028c1 <ipc_recv+0x31>
			*from_env_store = 0;
  8028bb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8028c1:	85 db                	test   %ebx,%ebx
  8028c3:	74 2c                	je     8028f1 <ipc_recv+0x61>
			*perm_store = 0;
  8028c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8028cb:	eb 24                	jmp    8028f1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8028cd:	85 f6                	test   %esi,%esi
  8028cf:	74 0a                	je     8028db <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8028d1:	a1 08 50 80 00       	mov    0x805008,%eax
  8028d6:	8b 40 74             	mov    0x74(%eax),%eax
  8028d9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8028db:	85 db                	test   %ebx,%ebx
  8028dd:	74 0a                	je     8028e9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8028df:	a1 08 50 80 00       	mov    0x805008,%eax
  8028e4:	8b 40 78             	mov    0x78(%eax),%eax
  8028e7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8028e9:	a1 08 50 80 00       	mov    0x805008,%eax
  8028ee:	8b 40 70             	mov    0x70(%eax),%eax
}
  8028f1:	83 c4 10             	add    $0x10,%esp
  8028f4:	5b                   	pop    %ebx
  8028f5:	5e                   	pop    %esi
  8028f6:	5d                   	pop    %ebp
  8028f7:	c3                   	ret    

008028f8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028f8:	55                   	push   %ebp
  8028f9:	89 e5                	mov    %esp,%ebp
  8028fb:	57                   	push   %edi
  8028fc:	56                   	push   %esi
  8028fd:	53                   	push   %ebx
  8028fe:	83 ec 1c             	sub    $0x1c,%esp
  802901:	8b 75 0c             	mov    0xc(%ebp),%esi
  802904:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802907:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80290a:	85 db                	test   %ebx,%ebx
  80290c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802911:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802914:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802918:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80291c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	89 04 24             	mov    %eax,(%esp)
  802926:	e8 4b e6 ff ff       	call   800f76 <sys_ipc_try_send>
	if (r == 0) return;
  80292b:	85 c0                	test   %eax,%eax
  80292d:	75 22                	jne    802951 <ipc_send+0x59>
  80292f:	eb 4c                	jmp    80297d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802931:	84 d2                	test   %dl,%dl
  802933:	75 48                	jne    80297d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802935:	e8 2a e4 ff ff       	call   800d64 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80293a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80293e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802942:	89 74 24 04          	mov    %esi,0x4(%esp)
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	89 04 24             	mov    %eax,(%esp)
  80294c:	e8 25 e6 ff ff       	call   800f76 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802951:	85 c0                	test   %eax,%eax
  802953:	0f 94 c2             	sete   %dl
  802956:	74 d9                	je     802931 <ipc_send+0x39>
  802958:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80295b:	74 d4                	je     802931 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80295d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802961:	c7 44 24 08 43 33 80 	movl   $0x803343,0x8(%esp)
  802968:	00 
  802969:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802970:	00 
  802971:	c7 04 24 51 33 80 00 	movl   $0x803351,(%esp)
  802978:	e8 ce d8 ff ff       	call   80024b <_panic>
}
  80297d:	83 c4 1c             	add    $0x1c,%esp
  802980:	5b                   	pop    %ebx
  802981:	5e                   	pop    %esi
  802982:	5f                   	pop    %edi
  802983:	5d                   	pop    %ebp
  802984:	c3                   	ret    

00802985 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802985:	55                   	push   %ebp
  802986:	89 e5                	mov    %esp,%ebp
  802988:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80298b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802990:	89 c2                	mov    %eax,%edx
  802992:	c1 e2 07             	shl    $0x7,%edx
  802995:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80299b:	8b 52 50             	mov    0x50(%edx),%edx
  80299e:	39 ca                	cmp    %ecx,%edx
  8029a0:	75 0d                	jne    8029af <ipc_find_env+0x2a>
			return envs[i].env_id;
  8029a2:	c1 e0 07             	shl    $0x7,%eax
  8029a5:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8029aa:	8b 40 40             	mov    0x40(%eax),%eax
  8029ad:	eb 0e                	jmp    8029bd <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8029af:	83 c0 01             	add    $0x1,%eax
  8029b2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8029b7:	75 d7                	jne    802990 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8029b9:	66 b8 00 00          	mov    $0x0,%ax
}
  8029bd:	5d                   	pop    %ebp
  8029be:	c3                   	ret    

008029bf <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029bf:	55                   	push   %ebp
  8029c0:	89 e5                	mov    %esp,%ebp
  8029c2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029c5:	89 d0                	mov    %edx,%eax
  8029c7:	c1 e8 16             	shr    $0x16,%eax
  8029ca:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029d1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029d6:	f6 c1 01             	test   $0x1,%cl
  8029d9:	74 1d                	je     8029f8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8029db:	c1 ea 0c             	shr    $0xc,%edx
  8029de:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029e5:	f6 c2 01             	test   $0x1,%dl
  8029e8:	74 0e                	je     8029f8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029ea:	c1 ea 0c             	shr    $0xc,%edx
  8029ed:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029f4:	ef 
  8029f5:	0f b7 c0             	movzwl %ax,%eax
}
  8029f8:	5d                   	pop    %ebp
  8029f9:	c3                   	ret    
  8029fa:	66 90                	xchg   %ax,%ax
  8029fc:	66 90                	xchg   %ax,%ax
  8029fe:	66 90                	xchg   %ax,%ax

00802a00 <__udivdi3>:
  802a00:	55                   	push   %ebp
  802a01:	57                   	push   %edi
  802a02:	56                   	push   %esi
  802a03:	83 ec 0c             	sub    $0xc,%esp
  802a06:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a0a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802a0e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802a12:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a16:	85 c0                	test   %eax,%eax
  802a18:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802a1c:	89 ea                	mov    %ebp,%edx
  802a1e:	89 0c 24             	mov    %ecx,(%esp)
  802a21:	75 2d                	jne    802a50 <__udivdi3+0x50>
  802a23:	39 e9                	cmp    %ebp,%ecx
  802a25:	77 61                	ja     802a88 <__udivdi3+0x88>
  802a27:	85 c9                	test   %ecx,%ecx
  802a29:	89 ce                	mov    %ecx,%esi
  802a2b:	75 0b                	jne    802a38 <__udivdi3+0x38>
  802a2d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a32:	31 d2                	xor    %edx,%edx
  802a34:	f7 f1                	div    %ecx
  802a36:	89 c6                	mov    %eax,%esi
  802a38:	31 d2                	xor    %edx,%edx
  802a3a:	89 e8                	mov    %ebp,%eax
  802a3c:	f7 f6                	div    %esi
  802a3e:	89 c5                	mov    %eax,%ebp
  802a40:	89 f8                	mov    %edi,%eax
  802a42:	f7 f6                	div    %esi
  802a44:	89 ea                	mov    %ebp,%edx
  802a46:	83 c4 0c             	add    $0xc,%esp
  802a49:	5e                   	pop    %esi
  802a4a:	5f                   	pop    %edi
  802a4b:	5d                   	pop    %ebp
  802a4c:	c3                   	ret    
  802a4d:	8d 76 00             	lea    0x0(%esi),%esi
  802a50:	39 e8                	cmp    %ebp,%eax
  802a52:	77 24                	ja     802a78 <__udivdi3+0x78>
  802a54:	0f bd e8             	bsr    %eax,%ebp
  802a57:	83 f5 1f             	xor    $0x1f,%ebp
  802a5a:	75 3c                	jne    802a98 <__udivdi3+0x98>
  802a5c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802a60:	39 34 24             	cmp    %esi,(%esp)
  802a63:	0f 86 9f 00 00 00    	jbe    802b08 <__udivdi3+0x108>
  802a69:	39 d0                	cmp    %edx,%eax
  802a6b:	0f 82 97 00 00 00    	jb     802b08 <__udivdi3+0x108>
  802a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a78:	31 d2                	xor    %edx,%edx
  802a7a:	31 c0                	xor    %eax,%eax
  802a7c:	83 c4 0c             	add    $0xc,%esp
  802a7f:	5e                   	pop    %esi
  802a80:	5f                   	pop    %edi
  802a81:	5d                   	pop    %ebp
  802a82:	c3                   	ret    
  802a83:	90                   	nop
  802a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a88:	89 f8                	mov    %edi,%eax
  802a8a:	f7 f1                	div    %ecx
  802a8c:	31 d2                	xor    %edx,%edx
  802a8e:	83 c4 0c             	add    $0xc,%esp
  802a91:	5e                   	pop    %esi
  802a92:	5f                   	pop    %edi
  802a93:	5d                   	pop    %ebp
  802a94:	c3                   	ret    
  802a95:	8d 76 00             	lea    0x0(%esi),%esi
  802a98:	89 e9                	mov    %ebp,%ecx
  802a9a:	8b 3c 24             	mov    (%esp),%edi
  802a9d:	d3 e0                	shl    %cl,%eax
  802a9f:	89 c6                	mov    %eax,%esi
  802aa1:	b8 20 00 00 00       	mov    $0x20,%eax
  802aa6:	29 e8                	sub    %ebp,%eax
  802aa8:	89 c1                	mov    %eax,%ecx
  802aaa:	d3 ef                	shr    %cl,%edi
  802aac:	89 e9                	mov    %ebp,%ecx
  802aae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802ab2:	8b 3c 24             	mov    (%esp),%edi
  802ab5:	09 74 24 08          	or     %esi,0x8(%esp)
  802ab9:	89 d6                	mov    %edx,%esi
  802abb:	d3 e7                	shl    %cl,%edi
  802abd:	89 c1                	mov    %eax,%ecx
  802abf:	89 3c 24             	mov    %edi,(%esp)
  802ac2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ac6:	d3 ee                	shr    %cl,%esi
  802ac8:	89 e9                	mov    %ebp,%ecx
  802aca:	d3 e2                	shl    %cl,%edx
  802acc:	89 c1                	mov    %eax,%ecx
  802ace:	d3 ef                	shr    %cl,%edi
  802ad0:	09 d7                	or     %edx,%edi
  802ad2:	89 f2                	mov    %esi,%edx
  802ad4:	89 f8                	mov    %edi,%eax
  802ad6:	f7 74 24 08          	divl   0x8(%esp)
  802ada:	89 d6                	mov    %edx,%esi
  802adc:	89 c7                	mov    %eax,%edi
  802ade:	f7 24 24             	mull   (%esp)
  802ae1:	39 d6                	cmp    %edx,%esi
  802ae3:	89 14 24             	mov    %edx,(%esp)
  802ae6:	72 30                	jb     802b18 <__udivdi3+0x118>
  802ae8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802aec:	89 e9                	mov    %ebp,%ecx
  802aee:	d3 e2                	shl    %cl,%edx
  802af0:	39 c2                	cmp    %eax,%edx
  802af2:	73 05                	jae    802af9 <__udivdi3+0xf9>
  802af4:	3b 34 24             	cmp    (%esp),%esi
  802af7:	74 1f                	je     802b18 <__udivdi3+0x118>
  802af9:	89 f8                	mov    %edi,%eax
  802afb:	31 d2                	xor    %edx,%edx
  802afd:	e9 7a ff ff ff       	jmp    802a7c <__udivdi3+0x7c>
  802b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b08:	31 d2                	xor    %edx,%edx
  802b0a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b0f:	e9 68 ff ff ff       	jmp    802a7c <__udivdi3+0x7c>
  802b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b18:	8d 47 ff             	lea    -0x1(%edi),%eax
  802b1b:	31 d2                	xor    %edx,%edx
  802b1d:	83 c4 0c             	add    $0xc,%esp
  802b20:	5e                   	pop    %esi
  802b21:	5f                   	pop    %edi
  802b22:	5d                   	pop    %ebp
  802b23:	c3                   	ret    
  802b24:	66 90                	xchg   %ax,%ax
  802b26:	66 90                	xchg   %ax,%ax
  802b28:	66 90                	xchg   %ax,%ax
  802b2a:	66 90                	xchg   %ax,%ax
  802b2c:	66 90                	xchg   %ax,%ax
  802b2e:	66 90                	xchg   %ax,%ax

00802b30 <__umoddi3>:
  802b30:	55                   	push   %ebp
  802b31:	57                   	push   %edi
  802b32:	56                   	push   %esi
  802b33:	83 ec 14             	sub    $0x14,%esp
  802b36:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b3a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b3e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802b42:	89 c7                	mov    %eax,%edi
  802b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b48:	8b 44 24 30          	mov    0x30(%esp),%eax
  802b4c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802b50:	89 34 24             	mov    %esi,(%esp)
  802b53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b57:	85 c0                	test   %eax,%eax
  802b59:	89 c2                	mov    %eax,%edx
  802b5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b5f:	75 17                	jne    802b78 <__umoddi3+0x48>
  802b61:	39 fe                	cmp    %edi,%esi
  802b63:	76 4b                	jbe    802bb0 <__umoddi3+0x80>
  802b65:	89 c8                	mov    %ecx,%eax
  802b67:	89 fa                	mov    %edi,%edx
  802b69:	f7 f6                	div    %esi
  802b6b:	89 d0                	mov    %edx,%eax
  802b6d:	31 d2                	xor    %edx,%edx
  802b6f:	83 c4 14             	add    $0x14,%esp
  802b72:	5e                   	pop    %esi
  802b73:	5f                   	pop    %edi
  802b74:	5d                   	pop    %ebp
  802b75:	c3                   	ret    
  802b76:	66 90                	xchg   %ax,%ax
  802b78:	39 f8                	cmp    %edi,%eax
  802b7a:	77 54                	ja     802bd0 <__umoddi3+0xa0>
  802b7c:	0f bd e8             	bsr    %eax,%ebp
  802b7f:	83 f5 1f             	xor    $0x1f,%ebp
  802b82:	75 5c                	jne    802be0 <__umoddi3+0xb0>
  802b84:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802b88:	39 3c 24             	cmp    %edi,(%esp)
  802b8b:	0f 87 e7 00 00 00    	ja     802c78 <__umoddi3+0x148>
  802b91:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b95:	29 f1                	sub    %esi,%ecx
  802b97:	19 c7                	sbb    %eax,%edi
  802b99:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ba1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ba5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802ba9:	83 c4 14             	add    $0x14,%esp
  802bac:	5e                   	pop    %esi
  802bad:	5f                   	pop    %edi
  802bae:	5d                   	pop    %ebp
  802baf:	c3                   	ret    
  802bb0:	85 f6                	test   %esi,%esi
  802bb2:	89 f5                	mov    %esi,%ebp
  802bb4:	75 0b                	jne    802bc1 <__umoddi3+0x91>
  802bb6:	b8 01 00 00 00       	mov    $0x1,%eax
  802bbb:	31 d2                	xor    %edx,%edx
  802bbd:	f7 f6                	div    %esi
  802bbf:	89 c5                	mov    %eax,%ebp
  802bc1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802bc5:	31 d2                	xor    %edx,%edx
  802bc7:	f7 f5                	div    %ebp
  802bc9:	89 c8                	mov    %ecx,%eax
  802bcb:	f7 f5                	div    %ebp
  802bcd:	eb 9c                	jmp    802b6b <__umoddi3+0x3b>
  802bcf:	90                   	nop
  802bd0:	89 c8                	mov    %ecx,%eax
  802bd2:	89 fa                	mov    %edi,%edx
  802bd4:	83 c4 14             	add    $0x14,%esp
  802bd7:	5e                   	pop    %esi
  802bd8:	5f                   	pop    %edi
  802bd9:	5d                   	pop    %ebp
  802bda:	c3                   	ret    
  802bdb:	90                   	nop
  802bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802be0:	8b 04 24             	mov    (%esp),%eax
  802be3:	be 20 00 00 00       	mov    $0x20,%esi
  802be8:	89 e9                	mov    %ebp,%ecx
  802bea:	29 ee                	sub    %ebp,%esi
  802bec:	d3 e2                	shl    %cl,%edx
  802bee:	89 f1                	mov    %esi,%ecx
  802bf0:	d3 e8                	shr    %cl,%eax
  802bf2:	89 e9                	mov    %ebp,%ecx
  802bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bf8:	8b 04 24             	mov    (%esp),%eax
  802bfb:	09 54 24 04          	or     %edx,0x4(%esp)
  802bff:	89 fa                	mov    %edi,%edx
  802c01:	d3 e0                	shl    %cl,%eax
  802c03:	89 f1                	mov    %esi,%ecx
  802c05:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c09:	8b 44 24 10          	mov    0x10(%esp),%eax
  802c0d:	d3 ea                	shr    %cl,%edx
  802c0f:	89 e9                	mov    %ebp,%ecx
  802c11:	d3 e7                	shl    %cl,%edi
  802c13:	89 f1                	mov    %esi,%ecx
  802c15:	d3 e8                	shr    %cl,%eax
  802c17:	89 e9                	mov    %ebp,%ecx
  802c19:	09 f8                	or     %edi,%eax
  802c1b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802c1f:	f7 74 24 04          	divl   0x4(%esp)
  802c23:	d3 e7                	shl    %cl,%edi
  802c25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c29:	89 d7                	mov    %edx,%edi
  802c2b:	f7 64 24 08          	mull   0x8(%esp)
  802c2f:	39 d7                	cmp    %edx,%edi
  802c31:	89 c1                	mov    %eax,%ecx
  802c33:	89 14 24             	mov    %edx,(%esp)
  802c36:	72 2c                	jb     802c64 <__umoddi3+0x134>
  802c38:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802c3c:	72 22                	jb     802c60 <__umoddi3+0x130>
  802c3e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802c42:	29 c8                	sub    %ecx,%eax
  802c44:	19 d7                	sbb    %edx,%edi
  802c46:	89 e9                	mov    %ebp,%ecx
  802c48:	89 fa                	mov    %edi,%edx
  802c4a:	d3 e8                	shr    %cl,%eax
  802c4c:	89 f1                	mov    %esi,%ecx
  802c4e:	d3 e2                	shl    %cl,%edx
  802c50:	89 e9                	mov    %ebp,%ecx
  802c52:	d3 ef                	shr    %cl,%edi
  802c54:	09 d0                	or     %edx,%eax
  802c56:	89 fa                	mov    %edi,%edx
  802c58:	83 c4 14             	add    $0x14,%esp
  802c5b:	5e                   	pop    %esi
  802c5c:	5f                   	pop    %edi
  802c5d:	5d                   	pop    %ebp
  802c5e:	c3                   	ret    
  802c5f:	90                   	nop
  802c60:	39 d7                	cmp    %edx,%edi
  802c62:	75 da                	jne    802c3e <__umoddi3+0x10e>
  802c64:	8b 14 24             	mov    (%esp),%edx
  802c67:	89 c1                	mov    %eax,%ecx
  802c69:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802c6d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802c71:	eb cb                	jmp    802c3e <__umoddi3+0x10e>
  802c73:	90                   	nop
  802c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c78:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802c7c:	0f 82 0f ff ff ff    	jb     802b91 <__umoddi3+0x61>
  802c82:	e9 1a ff ff ff       	jmp    802ba1 <__umoddi3+0x71>
