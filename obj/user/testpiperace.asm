
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 e7 01 00 00       	call   800218 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 20             	sub    $0x20,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800048:	c7 04 24 c0 2c 80 00 	movl   $0x802cc0,(%esp)
  80004f:	e8 1e 03 00 00       	call   800372 <cprintf>
	if ((r = pipe(p)) < 0)
  800054:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800057:	89 04 24             	mov    %eax,(%esp)
  80005a:	e8 d5 25 00 00       	call   802634 <pipe>
  80005f:	85 c0                	test   %eax,%eax
  800061:	79 20                	jns    800083 <umain+0x43>
		panic("pipe: %e", r);
  800063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800067:	c7 44 24 08 d9 2c 80 	movl   $0x802cd9,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 e2 2c 80 00 	movl   $0x802ce2,(%esp)
  80007e:	e8 f6 01 00 00       	call   800279 <_panic>
	max = 200;
	if ((r = fork()) < 0)
  800083:	e8 78 11 00 00       	call   801200 <fork>
  800088:	89 c6                	mov    %eax,%esi
  80008a:	85 c0                	test   %eax,%eax
  80008c:	79 20                	jns    8000ae <umain+0x6e>
		panic("fork: %e", r);
  80008e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800092:	c7 44 24 08 f6 2c 80 	movl   $0x802cf6,0x8(%esp)
  800099:	00 
  80009a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  8000a1:	00 
  8000a2:	c7 04 24 e2 2c 80 00 	movl   $0x802ce2,(%esp)
  8000a9:	e8 cb 01 00 00       	call   800279 <_panic>
	if (r == 0) {
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 56                	jne    800108 <umain+0xc8>
		close(p[1]);
  8000b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b5:	89 04 24             	mov    %eax,(%esp)
  8000b8:	e8 1a 17 00 00       	call   8017d7 <close>
  8000bd:	bb c8 00 00 00       	mov    $0xc8,%ebx
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
			if(pipeisclosed(p[0])){
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	89 04 24             	mov    %eax,(%esp)
  8000c8:	e8 d8 26 00 00       	call   8027a5 <pipeisclosed>
  8000cd:	85 c0                	test   %eax,%eax
  8000cf:	74 11                	je     8000e2 <umain+0xa2>
				cprintf("RACE: pipe appears closed\n");
  8000d1:	c7 04 24 ff 2c 80 00 	movl   $0x802cff,(%esp)
  8000d8:	e8 95 02 00 00       	call   800372 <cprintf>
				exit();
  8000dd:	e8 7e 01 00 00       	call   800260 <exit>
			}
			sys_yield();
  8000e2:	e8 ad 0c 00 00       	call   800d94 <sys_yield>
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  8000e7:	83 eb 01             	sub    $0x1,%ebx
  8000ea:	75 d6                	jne    8000c2 <umain+0x82>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  8000ec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000f3:	00 
  8000f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000fb:	00 
  8000fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800103:	e8 f8 13 00 00       	call   801500 <ipc_recv>
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800108:	89 74 24 04          	mov    %esi,0x4(%esp)
  80010c:	c7 04 24 1a 2d 80 00 	movl   $0x802d1a,(%esp)
  800113:	e8 5a 02 00 00       	call   800372 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800118:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  80011e:	c1 e6 07             	shl    $0x7,%esi
	cprintf("kid is %d\n", kid-envs);
  800121:	8d 9e 00 00 c0 ee    	lea    -0x11400000(%esi),%ebx
  800127:	c1 ee 07             	shr    $0x7,%esi
  80012a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80012e:	c7 04 24 25 2d 80 00 	movl   $0x802d25,(%esp)
  800135:	e8 38 02 00 00       	call   800372 <cprintf>
	dup(p[0], 10);
  80013a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800141:	00 
  800142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800145:	89 04 24             	mov    %eax,(%esp)
  800148:	e8 df 16 00 00       	call   80182c <dup>
	while (kid->env_status == ENV_RUNNABLE)
  80014d:	eb 13                	jmp    800162 <umain+0x122>
		dup(p[0], 10);
  80014f:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800156:	00 
  800157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80015a:	89 04 24             	mov    %eax,(%esp)
  80015d:	e8 ca 16 00 00       	call   80182c <dup>
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  800162:	8b 43 54             	mov    0x54(%ebx),%eax
  800165:	83 f8 02             	cmp    $0x2,%eax
  800168:	74 e5                	je     80014f <umain+0x10f>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  80016a:	c7 04 24 30 2d 80 00 	movl   $0x802d30,(%esp)
  800171:	e8 fc 01 00 00       	call   800372 <cprintf>
	if (pipeisclosed(p[0]))
  800176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800179:	89 04 24             	mov    %eax,(%esp)
  80017c:	e8 24 26 00 00       	call   8027a5 <pipeisclosed>
  800181:	85 c0                	test   %eax,%eax
  800183:	74 1c                	je     8001a1 <umain+0x161>
		panic("somehow the other end of p[0] got closed!");
  800185:	c7 44 24 08 8c 2d 80 	movl   $0x802d8c,0x8(%esp)
  80018c:	00 
  80018d:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  800194:	00 
  800195:	c7 04 24 e2 2c 80 00 	movl   $0x802ce2,(%esp)
  80019c:	e8 d8 00 00 00       	call   800279 <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8001a1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001ab:	89 04 24             	mov    %eax,(%esp)
  8001ae:	e8 f3 14 00 00       	call   8016a6 <fd_lookup>
  8001b3:	85 c0                	test   %eax,%eax
  8001b5:	79 20                	jns    8001d7 <umain+0x197>
		panic("cannot look up p[0]: %e", r);
  8001b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001bb:	c7 44 24 08 46 2d 80 	movl   $0x802d46,0x8(%esp)
  8001c2:	00 
  8001c3:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  8001ca:	00 
  8001cb:	c7 04 24 e2 2c 80 00 	movl   $0x802ce2,(%esp)
  8001d2:	e8 a2 00 00 00       	call   800279 <_panic>
	va = fd2data(fd);
  8001d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001da:	89 04 24             	mov    %eax,(%esp)
  8001dd:	e8 5e 14 00 00       	call   801640 <fd2data>
	if (pageref(va) != 3+1)
  8001e2:	89 04 24             	mov    %eax,(%esp)
  8001e5:	e8 20 1d 00 00       	call   801f0a <pageref>
  8001ea:	83 f8 04             	cmp    $0x4,%eax
  8001ed:	74 0e                	je     8001fd <umain+0x1bd>
		cprintf("\nchild detected race\n");
  8001ef:	c7 04 24 5e 2d 80 00 	movl   $0x802d5e,(%esp)
  8001f6:	e8 77 01 00 00       	call   800372 <cprintf>
  8001fb:	eb 14                	jmp    800211 <umain+0x1d1>
	else
		cprintf("\nrace didn't happen\n", max);
  8001fd:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  800204:	00 
  800205:	c7 04 24 74 2d 80 00 	movl   $0x802d74,(%esp)
  80020c:	e8 61 01 00 00       	call   800372 <cprintf>
}
  800211:	83 c4 20             	add    $0x20,%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	56                   	push   %esi
  80021c:	53                   	push   %ebx
  80021d:	83 ec 10             	sub    $0x10,%esp
  800220:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800223:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800226:	e8 4a 0b 00 00       	call   800d75 <sys_getenvid>
  80022b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800230:	c1 e0 07             	shl    $0x7,%eax
  800233:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800238:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023d:	85 db                	test   %ebx,%ebx
  80023f:	7e 07                	jle    800248 <libmain+0x30>
		binaryname = argv[0];
  800241:	8b 06                	mov    (%esi),%eax
  800243:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800248:	89 74 24 04          	mov    %esi,0x4(%esp)
  80024c:	89 1c 24             	mov    %ebx,(%esp)
  80024f:	e8 ec fd ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800254:	e8 07 00 00 00       	call   800260 <exit>
}
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	5b                   	pop    %ebx
  80025d:	5e                   	pop    %esi
  80025e:	5d                   	pop    %ebp
  80025f:	c3                   	ret    

00800260 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800266:	e8 9f 15 00 00       	call   80180a <close_all>
	sys_env_destroy(0);
  80026b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800272:	e8 ac 0a 00 00       	call   800d23 <sys_env_destroy>
}
  800277:	c9                   	leave  
  800278:	c3                   	ret    

00800279 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	56                   	push   %esi
  80027d:	53                   	push   %ebx
  80027e:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800281:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800284:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80028a:	e8 e6 0a 00 00       	call   800d75 <sys_getenvid>
  80028f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800292:	89 54 24 10          	mov    %edx,0x10(%esp)
  800296:	8b 55 08             	mov    0x8(%ebp),%edx
  800299:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80029d:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a5:	c7 04 24 c0 2d 80 00 	movl   $0x802dc0,(%esp)
  8002ac:	e8 c1 00 00 00       	call   800372 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002b1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b8:	89 04 24             	mov    %eax,(%esp)
  8002bb:	e8 51 00 00 00       	call   800311 <vcprintf>
	cprintf("\n");
  8002c0:	c7 04 24 d7 2c 80 00 	movl   $0x802cd7,(%esp)
  8002c7:	e8 a6 00 00 00       	call   800372 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002cc:	cc                   	int3   
  8002cd:	eb fd                	jmp    8002cc <_panic+0x53>

008002cf <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	53                   	push   %ebx
  8002d3:	83 ec 14             	sub    $0x14,%esp
  8002d6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002d9:	8b 13                	mov    (%ebx),%edx
  8002db:	8d 42 01             	lea    0x1(%edx),%eax
  8002de:	89 03                	mov    %eax,(%ebx)
  8002e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002e3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ec:	75 19                	jne    800307 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002ee:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002f5:	00 
  8002f6:	8d 43 08             	lea    0x8(%ebx),%eax
  8002f9:	89 04 24             	mov    %eax,(%esp)
  8002fc:	e8 e5 09 00 00       	call   800ce6 <sys_cputs>
		b->idx = 0;
  800301:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800307:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80030b:	83 c4 14             	add    $0x14,%esp
  80030e:	5b                   	pop    %ebx
  80030f:	5d                   	pop    %ebp
  800310:	c3                   	ret    

00800311 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80031a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800321:	00 00 00 
	b.cnt = 0;
  800324:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80032e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800331:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800335:	8b 45 08             	mov    0x8(%ebp),%eax
  800338:	89 44 24 08          	mov    %eax,0x8(%esp)
  80033c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800342:	89 44 24 04          	mov    %eax,0x4(%esp)
  800346:	c7 04 24 cf 02 80 00 	movl   $0x8002cf,(%esp)
  80034d:	e8 ac 01 00 00       	call   8004fe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800352:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800358:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800362:	89 04 24             	mov    %eax,(%esp)
  800365:	e8 7c 09 00 00       	call   800ce6 <sys_cputs>

	return b.cnt;
}
  80036a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800370:	c9                   	leave  
  800371:	c3                   	ret    

00800372 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800378:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80037b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80037f:	8b 45 08             	mov    0x8(%ebp),%eax
  800382:	89 04 24             	mov    %eax,(%esp)
  800385:	e8 87 ff ff ff       	call   800311 <vcprintf>
	va_end(ap);

	return cnt;
}
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    
  80038c:	66 90                	xchg   %ax,%ax
  80038e:	66 90                	xchg   %ax,%ax

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
  8003ff:	e8 2c 26 00 00       	call   802a30 <__udivdi3>
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
  80045f:	e8 fc 26 00 00       	call   802b60 <__umoddi3>
  800464:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800468:	0f be 80 e3 2d 80 00 	movsbl 0x802de3(%eax),%eax
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
  800583:	ff 24 8d 20 2f 80 00 	jmp    *0x802f20(,%ecx,4)
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
  800620:	8b 14 85 80 30 80 00 	mov    0x803080(,%eax,4),%edx
  800627:	85 d2                	test   %edx,%edx
  800629:	75 20                	jne    80064b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80062b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80062f:	c7 44 24 08 fb 2d 80 	movl   $0x802dfb,0x8(%esp)
  800636:	00 
  800637:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	89 04 24             	mov    %eax,(%esp)
  800641:	e8 90 fe ff ff       	call   8004d6 <printfmt>
  800646:	e9 d8 fe ff ff       	jmp    800523 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80064b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80064f:	c7 44 24 08 c5 32 80 	movl   $0x8032c5,0x8(%esp)
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
  800681:	b8 f4 2d 80 00       	mov    $0x802df4,%eax
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
  800d51:	c7 44 24 08 e7 30 80 	movl   $0x8030e7,0x8(%esp)
  800d58:	00 
  800d59:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d60:	00 
  800d61:	c7 04 24 04 31 80 00 	movl   $0x803104,(%esp)
  800d68:	e8 0c f5 ff ff       	call   800279 <_panic>

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
  800de3:	c7 44 24 08 e7 30 80 	movl   $0x8030e7,0x8(%esp)
  800dea:	00 
  800deb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df2:	00 
  800df3:	c7 04 24 04 31 80 00 	movl   $0x803104,(%esp)
  800dfa:	e8 7a f4 ff ff       	call   800279 <_panic>

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
  800e36:	c7 44 24 08 e7 30 80 	movl   $0x8030e7,0x8(%esp)
  800e3d:	00 
  800e3e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e45:	00 
  800e46:	c7 04 24 04 31 80 00 	movl   $0x803104,(%esp)
  800e4d:	e8 27 f4 ff ff       	call   800279 <_panic>

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
  800e89:	c7 44 24 08 e7 30 80 	movl   $0x8030e7,0x8(%esp)
  800e90:	00 
  800e91:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e98:	00 
  800e99:	c7 04 24 04 31 80 00 	movl   $0x803104,(%esp)
  800ea0:	e8 d4 f3 ff ff       	call   800279 <_panic>

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
  800edc:	c7 44 24 08 e7 30 80 	movl   $0x8030e7,0x8(%esp)
  800ee3:	00 
  800ee4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eeb:	00 
  800eec:	c7 04 24 04 31 80 00 	movl   $0x803104,(%esp)
  800ef3:	e8 81 f3 ff ff       	call   800279 <_panic>

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
  800f2f:	c7 44 24 08 e7 30 80 	movl   $0x8030e7,0x8(%esp)
  800f36:	00 
  800f37:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f3e:	00 
  800f3f:	c7 04 24 04 31 80 00 	movl   $0x803104,(%esp)
  800f46:	e8 2e f3 ff ff       	call   800279 <_panic>

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
  800f82:	c7 44 24 08 e7 30 80 	movl   $0x8030e7,0x8(%esp)
  800f89:	00 
  800f8a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f91:	00 
  800f92:	c7 04 24 04 31 80 00 	movl   $0x803104,(%esp)
  800f99:	e8 db f2 ff ff       	call   800279 <_panic>

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
  800ff7:	c7 44 24 08 e7 30 80 	movl   $0x8030e7,0x8(%esp)
  800ffe:	00 
  800fff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801006:	00 
  801007:	c7 04 24 04 31 80 00 	movl   $0x803104,(%esp)
  80100e:	e8 66 f2 ff ff       	call   800279 <_panic>

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
  8010cd:	c7 44 24 08 e7 30 80 	movl   $0x8030e7,0x8(%esp)
  8010d4:	00 
  8010d5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010dc:	00 
  8010dd:	c7 04 24 04 31 80 00 	movl   $0x803104,(%esp)
  8010e4:	e8 90 f1 ff ff       	call   800279 <_panic>

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
  801107:	c7 44 24 08 14 31 80 	movl   $0x803114,0x8(%esp)
  80110e:	00 
  80110f:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  801116:	00 
  801117:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  80111e:	e8 56 f1 ff ff       	call   800279 <_panic>

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
  80113a:	c7 44 24 08 44 31 80 	movl   $0x803144,0x8(%esp)
  801141:	00 
  801142:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801149:	00 
  80114a:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  801151:	e8 23 f1 ff ff       	call   800279 <_panic>
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
  80117a:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  801181:	00 
  801182:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  801189:	00 
  80118a:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  801191:	e8 e3 f0 ff ff       	call   800279 <_panic>

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
  8011de:	c7 44 24 08 b3 31 80 	movl   $0x8031b3,0x8(%esp)
  8011e5:	00 
  8011e6:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  8011ed:	00 
  8011ee:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  8011f5:	e8 7f f0 ff ff       	call   800279 <_panic>

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
  801210:	e8 71 17 00 00       	call   802986 <set_pgfault_handler>
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
  80122a:	c7 44 24 08 c5 31 80 	movl   $0x8031c5,0x8(%esp)
  801231:	00 
  801232:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  801239:	00 
  80123a:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  801241:	e8 33 f0 ff ff       	call   800279 <_panic>
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
  801268:	a3 08 50 80 00       	mov    %eax,0x805008
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
  80129a:	a1 08 50 80 00       	mov    0x805008,%eax
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
  8012e7:	c7 44 24 08 b3 31 80 	movl   $0x8031b3,0x8(%esp)
  8012ee:	00 
  8012ef:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  8012f6:	00 
  8012f7:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  8012fe:	e8 76 ef ff ff       	call   800279 <_panic>
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
  80135c:	c7 44 24 08 b3 31 80 	movl   $0x8031b3,0x8(%esp)
  801363:	00 
  801364:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80136b:	00 
  80136c:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  801373:	e8 01 ef ff ff       	call   800279 <_panic>

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
  80139b:	c7 44 24 08 b3 31 80 	movl   $0x8031b3,0x8(%esp)
  8013a2:	00 
  8013a3:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8013aa:	00 
  8013ab:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  8013b2:	e8 c2 ee ff ff       	call   800279 <_panic>

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
  8013e9:	c7 44 24 08 b3 31 80 	movl   $0x8031b3,0x8(%esp)
  8013f0:	00 
  8013f1:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  8013f8:	00 
  8013f9:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  801400:	e8 74 ee ff ff       	call   800279 <_panic>
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
  80143d:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  801444:	00 
  801445:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  80144c:	00 
  80144d:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  801454:	e8 20 ee ff ff       	call   800279 <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801459:	c7 44 24 04 07 2a 80 	movl   $0x802a07,0x4(%esp)
  801460:	00 
  801461:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801464:	89 04 24             	mov    %eax,(%esp)
  801467:	e8 e7 fa ff ff       	call   800f53 <sys_env_set_pgfault_upcall>
  80146c:	85 c0                	test   %eax,%eax
  80146e:	79 20                	jns    801490 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801470:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801474:	c7 44 24 08 74 31 80 	movl   $0x803174,0x8(%esp)
  80147b:	00 
  80147c:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801483:	00 
  801484:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  80148b:	e8 e9 ed ff ff       	call   800279 <_panic>

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
  8014ab:	c7 44 24 08 d6 31 80 	movl   $0x8031d6,0x8(%esp)
  8014b2:	00 
  8014b3:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8014ba:	00 
  8014bb:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  8014c2:	e8 b2 ed ff ff       	call   800279 <_panic>

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
  8014d8:	c7 44 24 08 ee 31 80 	movl   $0x8031ee,0x8(%esp)
  8014df:	00 
  8014e0:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  8014e7:	00 
  8014e8:	c7 04 24 94 31 80 00 	movl   $0x803194,(%esp)
  8014ef:	e8 85 ed ff ff       	call   800279 <_panic>
  8014f4:	66 90                	xchg   %ax,%ax
  8014f6:	66 90                	xchg   %ax,%ax
  8014f8:	66 90                	xchg   %ax,%ax
  8014fa:	66 90                	xchg   %ax,%ax
  8014fc:	66 90                	xchg   %ax,%ax
  8014fe:	66 90                	xchg   %ax,%ax

00801500 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	56                   	push   %esi
  801504:	53                   	push   %ebx
  801505:	83 ec 10             	sub    $0x10,%esp
  801508:	8b 75 08             	mov    0x8(%ebp),%esi
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  801511:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  801513:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  801518:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80151b:	89 04 24             	mov    %eax,(%esp)
  80151e:	e8 a6 fa ff ff       	call   800fc9 <sys_ipc_recv>
  801523:	85 c0                	test   %eax,%eax
  801525:	74 16                	je     80153d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  801527:	85 f6                	test   %esi,%esi
  801529:	74 06                	je     801531 <ipc_recv+0x31>
			*from_env_store = 0;
  80152b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  801531:	85 db                	test   %ebx,%ebx
  801533:	74 2c                	je     801561 <ipc_recv+0x61>
			*perm_store = 0;
  801535:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80153b:	eb 24                	jmp    801561 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80153d:	85 f6                	test   %esi,%esi
  80153f:	74 0a                	je     80154b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  801541:	a1 08 50 80 00       	mov    0x805008,%eax
  801546:	8b 40 74             	mov    0x74(%eax),%eax
  801549:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80154b:	85 db                	test   %ebx,%ebx
  80154d:	74 0a                	je     801559 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80154f:	a1 08 50 80 00       	mov    0x805008,%eax
  801554:	8b 40 78             	mov    0x78(%eax),%eax
  801557:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  801559:	a1 08 50 80 00       	mov    0x805008,%eax
  80155e:	8b 40 70             	mov    0x70(%eax),%eax
}
  801561:	83 c4 10             	add    $0x10,%esp
  801564:	5b                   	pop    %ebx
  801565:	5e                   	pop    %esi
  801566:	5d                   	pop    %ebp
  801567:	c3                   	ret    

00801568 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	57                   	push   %edi
  80156c:	56                   	push   %esi
  80156d:	53                   	push   %ebx
  80156e:	83 ec 1c             	sub    $0x1c,%esp
  801571:	8b 75 0c             	mov    0xc(%ebp),%esi
  801574:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801577:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80157a:	85 db                	test   %ebx,%ebx
  80157c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  801581:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  801584:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801588:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80158c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	89 04 24             	mov    %eax,(%esp)
  801596:	e8 0b fa ff ff       	call   800fa6 <sys_ipc_try_send>
	if (r == 0) return;
  80159b:	85 c0                	test   %eax,%eax
  80159d:	75 22                	jne    8015c1 <ipc_send+0x59>
  80159f:	eb 4c                	jmp    8015ed <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  8015a1:	84 d2                	test   %dl,%dl
  8015a3:	75 48                	jne    8015ed <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  8015a5:	e8 ea f7 ff ff       	call   800d94 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  8015aa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015ae:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	89 04 24             	mov    %eax,(%esp)
  8015bc:	e8 e5 f9 ff ff       	call   800fa6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	0f 94 c2             	sete   %dl
  8015c6:	74 d9                	je     8015a1 <ipc_send+0x39>
  8015c8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8015cb:	74 d4                	je     8015a1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  8015cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015d1:	c7 44 24 08 04 32 80 	movl   $0x803204,0x8(%esp)
  8015d8:	00 
  8015d9:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  8015e0:	00 
  8015e1:	c7 04 24 12 32 80 00 	movl   $0x803212,(%esp)
  8015e8:	e8 8c ec ff ff       	call   800279 <_panic>
}
  8015ed:	83 c4 1c             	add    $0x1c,%esp
  8015f0:	5b                   	pop    %ebx
  8015f1:	5e                   	pop    %esi
  8015f2:	5f                   	pop    %edi
  8015f3:	5d                   	pop    %ebp
  8015f4:	c3                   	ret    

008015f5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8015fb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801600:	89 c2                	mov    %eax,%edx
  801602:	c1 e2 07             	shl    $0x7,%edx
  801605:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80160b:	8b 52 50             	mov    0x50(%edx),%edx
  80160e:	39 ca                	cmp    %ecx,%edx
  801610:	75 0d                	jne    80161f <ipc_find_env+0x2a>
			return envs[i].env_id;
  801612:	c1 e0 07             	shl    $0x7,%eax
  801615:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80161a:	8b 40 40             	mov    0x40(%eax),%eax
  80161d:	eb 0e                	jmp    80162d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80161f:	83 c0 01             	add    $0x1,%eax
  801622:	3d 00 04 00 00       	cmp    $0x400,%eax
  801627:	75 d7                	jne    801600 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801629:	66 b8 00 00          	mov    $0x0,%ax
}
  80162d:	5d                   	pop    %ebp
  80162e:	c3                   	ret    
  80162f:	90                   	nop

00801630 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	05 00 00 00 30       	add    $0x30000000,%eax
  80163b:	c1 e8 0c             	shr    $0xc,%eax
}
  80163e:	5d                   	pop    %ebp
  80163f:	c3                   	ret    

00801640 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80164b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801650:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801655:	5d                   	pop    %ebp
  801656:	c3                   	ret    

00801657 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80165d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801662:	89 c2                	mov    %eax,%edx
  801664:	c1 ea 16             	shr    $0x16,%edx
  801667:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80166e:	f6 c2 01             	test   $0x1,%dl
  801671:	74 11                	je     801684 <fd_alloc+0x2d>
  801673:	89 c2                	mov    %eax,%edx
  801675:	c1 ea 0c             	shr    $0xc,%edx
  801678:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80167f:	f6 c2 01             	test   $0x1,%dl
  801682:	75 09                	jne    80168d <fd_alloc+0x36>
			*fd_store = fd;
  801684:	89 01                	mov    %eax,(%ecx)
			return 0;
  801686:	b8 00 00 00 00       	mov    $0x0,%eax
  80168b:	eb 17                	jmp    8016a4 <fd_alloc+0x4d>
  80168d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801692:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801697:	75 c9                	jne    801662 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801699:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80169f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8016a4:	5d                   	pop    %ebp
  8016a5:	c3                   	ret    

008016a6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016ac:	83 f8 1f             	cmp    $0x1f,%eax
  8016af:	77 36                	ja     8016e7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016b1:	c1 e0 0c             	shl    $0xc,%eax
  8016b4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016b9:	89 c2                	mov    %eax,%edx
  8016bb:	c1 ea 16             	shr    $0x16,%edx
  8016be:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016c5:	f6 c2 01             	test   $0x1,%dl
  8016c8:	74 24                	je     8016ee <fd_lookup+0x48>
  8016ca:	89 c2                	mov    %eax,%edx
  8016cc:	c1 ea 0c             	shr    $0xc,%edx
  8016cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016d6:	f6 c2 01             	test   $0x1,%dl
  8016d9:	74 1a                	je     8016f5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016de:	89 02                	mov    %eax,(%edx)
	return 0;
  8016e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e5:	eb 13                	jmp    8016fa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016ec:	eb 0c                	jmp    8016fa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016f3:	eb 05                	jmp    8016fa <fd_lookup+0x54>
  8016f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8016fa:	5d                   	pop    %ebp
  8016fb:	c3                   	ret    

008016fc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 18             	sub    $0x18,%esp
  801702:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801705:	ba 00 00 00 00       	mov    $0x0,%edx
  80170a:	eb 13                	jmp    80171f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80170c:	39 08                	cmp    %ecx,(%eax)
  80170e:	75 0c                	jne    80171c <dev_lookup+0x20>
			*dev = devtab[i];
  801710:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801713:	89 01                	mov    %eax,(%ecx)
			return 0;
  801715:	b8 00 00 00 00       	mov    $0x0,%eax
  80171a:	eb 38                	jmp    801754 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80171c:	83 c2 01             	add    $0x1,%edx
  80171f:	8b 04 95 98 32 80 00 	mov    0x803298(,%edx,4),%eax
  801726:	85 c0                	test   %eax,%eax
  801728:	75 e2                	jne    80170c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80172a:	a1 08 50 80 00       	mov    0x805008,%eax
  80172f:	8b 40 48             	mov    0x48(%eax),%eax
  801732:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801736:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173a:	c7 04 24 1c 32 80 00 	movl   $0x80321c,(%esp)
  801741:	e8 2c ec ff ff       	call   800372 <cprintf>
	*dev = 0;
  801746:	8b 45 0c             	mov    0xc(%ebp),%eax
  801749:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80174f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	56                   	push   %esi
  80175a:	53                   	push   %ebx
  80175b:	83 ec 20             	sub    $0x20,%esp
  80175e:	8b 75 08             	mov    0x8(%ebp),%esi
  801761:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801764:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801767:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80176b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801771:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801774:	89 04 24             	mov    %eax,(%esp)
  801777:	e8 2a ff ff ff       	call   8016a6 <fd_lookup>
  80177c:	85 c0                	test   %eax,%eax
  80177e:	78 05                	js     801785 <fd_close+0x2f>
	    || fd != fd2)
  801780:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801783:	74 0c                	je     801791 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801785:	84 db                	test   %bl,%bl
  801787:	ba 00 00 00 00       	mov    $0x0,%edx
  80178c:	0f 44 c2             	cmove  %edx,%eax
  80178f:	eb 3f                	jmp    8017d0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801791:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801794:	89 44 24 04          	mov    %eax,0x4(%esp)
  801798:	8b 06                	mov    (%esi),%eax
  80179a:	89 04 24             	mov    %eax,(%esp)
  80179d:	e8 5a ff ff ff       	call   8016fc <dev_lookup>
  8017a2:	89 c3                	mov    %eax,%ebx
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	78 16                	js     8017be <fd_close+0x68>
		if (dev->dev_close)
  8017a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ab:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8017ae:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8017b3:	85 c0                	test   %eax,%eax
  8017b5:	74 07                	je     8017be <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8017b7:	89 34 24             	mov    %esi,(%esp)
  8017ba:	ff d0                	call   *%eax
  8017bc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8017be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017c9:	e8 8c f6 ff ff       	call   800e5a <sys_page_unmap>
	return r;
  8017ce:	89 d8                	mov    %ebx,%eax
}
  8017d0:	83 c4 20             	add    $0x20,%esp
  8017d3:	5b                   	pop    %ebx
  8017d4:	5e                   	pop    %esi
  8017d5:	5d                   	pop    %ebp
  8017d6:	c3                   	ret    

008017d7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	89 04 24             	mov    %eax,(%esp)
  8017ea:	e8 b7 fe ff ff       	call   8016a6 <fd_lookup>
  8017ef:	89 c2                	mov    %eax,%edx
  8017f1:	85 d2                	test   %edx,%edx
  8017f3:	78 13                	js     801808 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8017f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017fc:	00 
  8017fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801800:	89 04 24             	mov    %eax,(%esp)
  801803:	e8 4e ff ff ff       	call   801756 <fd_close>
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <close_all>:

void
close_all(void)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	53                   	push   %ebx
  80180e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801811:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801816:	89 1c 24             	mov    %ebx,(%esp)
  801819:	e8 b9 ff ff ff       	call   8017d7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80181e:	83 c3 01             	add    $0x1,%ebx
  801821:	83 fb 20             	cmp    $0x20,%ebx
  801824:	75 f0                	jne    801816 <close_all+0xc>
		close(i);
}
  801826:	83 c4 14             	add    $0x14,%esp
  801829:	5b                   	pop    %ebx
  80182a:	5d                   	pop    %ebp
  80182b:	c3                   	ret    

0080182c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	57                   	push   %edi
  801830:	56                   	push   %esi
  801831:	53                   	push   %ebx
  801832:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801835:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801838:	89 44 24 04          	mov    %eax,0x4(%esp)
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	89 04 24             	mov    %eax,(%esp)
  801842:	e8 5f fe ff ff       	call   8016a6 <fd_lookup>
  801847:	89 c2                	mov    %eax,%edx
  801849:	85 d2                	test   %edx,%edx
  80184b:	0f 88 e1 00 00 00    	js     801932 <dup+0x106>
		return r;
	close(newfdnum);
  801851:	8b 45 0c             	mov    0xc(%ebp),%eax
  801854:	89 04 24             	mov    %eax,(%esp)
  801857:	e8 7b ff ff ff       	call   8017d7 <close>

	newfd = INDEX2FD(newfdnum);
  80185c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80185f:	c1 e3 0c             	shl    $0xc,%ebx
  801862:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801868:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80186b:	89 04 24             	mov    %eax,(%esp)
  80186e:	e8 cd fd ff ff       	call   801640 <fd2data>
  801873:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801875:	89 1c 24             	mov    %ebx,(%esp)
  801878:	e8 c3 fd ff ff       	call   801640 <fd2data>
  80187d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80187f:	89 f0                	mov    %esi,%eax
  801881:	c1 e8 16             	shr    $0x16,%eax
  801884:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80188b:	a8 01                	test   $0x1,%al
  80188d:	74 43                	je     8018d2 <dup+0xa6>
  80188f:	89 f0                	mov    %esi,%eax
  801891:	c1 e8 0c             	shr    $0xc,%eax
  801894:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80189b:	f6 c2 01             	test   $0x1,%dl
  80189e:	74 32                	je     8018d2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018a0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018a7:	25 07 0e 00 00       	and    $0xe07,%eax
  8018ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018b0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018b4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018bb:	00 
  8018bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018c7:	e8 3b f5 ff ff       	call   800e07 <sys_page_map>
  8018cc:	89 c6                	mov    %eax,%esi
  8018ce:	85 c0                	test   %eax,%eax
  8018d0:	78 3e                	js     801910 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	c1 ea 0c             	shr    $0xc,%edx
  8018da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018e1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8018e7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8018eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8018ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018f6:	00 
  8018f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801902:	e8 00 f5 ff ff       	call   800e07 <sys_page_map>
  801907:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801909:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80190c:	85 f6                	test   %esi,%esi
  80190e:	79 22                	jns    801932 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801910:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801914:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80191b:	e8 3a f5 ff ff       	call   800e5a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801920:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801924:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80192b:	e8 2a f5 ff ff       	call   800e5a <sys_page_unmap>
	return r;
  801930:	89 f0                	mov    %esi,%eax
}
  801932:	83 c4 3c             	add    $0x3c,%esp
  801935:	5b                   	pop    %ebx
  801936:	5e                   	pop    %esi
  801937:	5f                   	pop    %edi
  801938:	5d                   	pop    %ebp
  801939:	c3                   	ret    

0080193a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	53                   	push   %ebx
  80193e:	83 ec 24             	sub    $0x24,%esp
  801941:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801944:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801947:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194b:	89 1c 24             	mov    %ebx,(%esp)
  80194e:	e8 53 fd ff ff       	call   8016a6 <fd_lookup>
  801953:	89 c2                	mov    %eax,%edx
  801955:	85 d2                	test   %edx,%edx
  801957:	78 6d                	js     8019c6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801959:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801960:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801963:	8b 00                	mov    (%eax),%eax
  801965:	89 04 24             	mov    %eax,(%esp)
  801968:	e8 8f fd ff ff       	call   8016fc <dev_lookup>
  80196d:	85 c0                	test   %eax,%eax
  80196f:	78 55                	js     8019c6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801974:	8b 50 08             	mov    0x8(%eax),%edx
  801977:	83 e2 03             	and    $0x3,%edx
  80197a:	83 fa 01             	cmp    $0x1,%edx
  80197d:	75 23                	jne    8019a2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80197f:	a1 08 50 80 00       	mov    0x805008,%eax
  801984:	8b 40 48             	mov    0x48(%eax),%eax
  801987:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80198b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198f:	c7 04 24 5d 32 80 00 	movl   $0x80325d,(%esp)
  801996:	e8 d7 e9 ff ff       	call   800372 <cprintf>
		return -E_INVAL;
  80199b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019a0:	eb 24                	jmp    8019c6 <read+0x8c>
	}
	if (!dev->dev_read)
  8019a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a5:	8b 52 08             	mov    0x8(%edx),%edx
  8019a8:	85 d2                	test   %edx,%edx
  8019aa:	74 15                	je     8019c1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019ba:	89 04 24             	mov    %eax,(%esp)
  8019bd:	ff d2                	call   *%edx
  8019bf:	eb 05                	jmp    8019c6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8019c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8019c6:	83 c4 24             	add    $0x24,%esp
  8019c9:	5b                   	pop    %ebx
  8019ca:	5d                   	pop    %ebp
  8019cb:	c3                   	ret    

008019cc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	57                   	push   %edi
  8019d0:	56                   	push   %esi
  8019d1:	53                   	push   %ebx
  8019d2:	83 ec 1c             	sub    $0x1c,%esp
  8019d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019d8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019e0:	eb 23                	jmp    801a05 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019e2:	89 f0                	mov    %esi,%eax
  8019e4:	29 d8                	sub    %ebx,%eax
  8019e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019ea:	89 d8                	mov    %ebx,%eax
  8019ec:	03 45 0c             	add    0xc(%ebp),%eax
  8019ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f3:	89 3c 24             	mov    %edi,(%esp)
  8019f6:	e8 3f ff ff ff       	call   80193a <read>
		if (m < 0)
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	78 10                	js     801a0f <readn+0x43>
			return m;
		if (m == 0)
  8019ff:	85 c0                	test   %eax,%eax
  801a01:	74 0a                	je     801a0d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a03:	01 c3                	add    %eax,%ebx
  801a05:	39 f3                	cmp    %esi,%ebx
  801a07:	72 d9                	jb     8019e2 <readn+0x16>
  801a09:	89 d8                	mov    %ebx,%eax
  801a0b:	eb 02                	jmp    801a0f <readn+0x43>
  801a0d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801a0f:	83 c4 1c             	add    $0x1c,%esp
  801a12:	5b                   	pop    %ebx
  801a13:	5e                   	pop    %esi
  801a14:	5f                   	pop    %edi
  801a15:	5d                   	pop    %ebp
  801a16:	c3                   	ret    

00801a17 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
  801a1a:	53                   	push   %ebx
  801a1b:	83 ec 24             	sub    $0x24,%esp
  801a1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a21:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a28:	89 1c 24             	mov    %ebx,(%esp)
  801a2b:	e8 76 fc ff ff       	call   8016a6 <fd_lookup>
  801a30:	89 c2                	mov    %eax,%edx
  801a32:	85 d2                	test   %edx,%edx
  801a34:	78 68                	js     801a9e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a40:	8b 00                	mov    (%eax),%eax
  801a42:	89 04 24             	mov    %eax,(%esp)
  801a45:	e8 b2 fc ff ff       	call   8016fc <dev_lookup>
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	78 50                	js     801a9e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a51:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a55:	75 23                	jne    801a7a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a57:	a1 08 50 80 00       	mov    0x805008,%eax
  801a5c:	8b 40 48             	mov    0x48(%eax),%eax
  801a5f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a67:	c7 04 24 79 32 80 00 	movl   $0x803279,(%esp)
  801a6e:	e8 ff e8 ff ff       	call   800372 <cprintf>
		return -E_INVAL;
  801a73:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a78:	eb 24                	jmp    801a9e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a7d:	8b 52 0c             	mov    0xc(%edx),%edx
  801a80:	85 d2                	test   %edx,%edx
  801a82:	74 15                	je     801a99 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a84:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a92:	89 04 24             	mov    %eax,(%esp)
  801a95:	ff d2                	call   *%edx
  801a97:	eb 05                	jmp    801a9e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a99:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a9e:	83 c4 24             	add    $0x24,%esp
  801aa1:	5b                   	pop    %ebx
  801aa2:	5d                   	pop    %ebp
  801aa3:	c3                   	ret    

00801aa4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801aa4:	55                   	push   %ebp
  801aa5:	89 e5                	mov    %esp,%ebp
  801aa7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aaa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801aad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	89 04 24             	mov    %eax,(%esp)
  801ab7:	e8 ea fb ff ff       	call   8016a6 <fd_lookup>
  801abc:	85 c0                	test   %eax,%eax
  801abe:	78 0e                	js     801ace <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801ac0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801ac9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	53                   	push   %ebx
  801ad4:	83 ec 24             	sub    $0x24,%esp
  801ad7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ada:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801add:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae1:	89 1c 24             	mov    %ebx,(%esp)
  801ae4:	e8 bd fb ff ff       	call   8016a6 <fd_lookup>
  801ae9:	89 c2                	mov    %eax,%edx
  801aeb:	85 d2                	test   %edx,%edx
  801aed:	78 61                	js     801b50 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af9:	8b 00                	mov    (%eax),%eax
  801afb:	89 04 24             	mov    %eax,(%esp)
  801afe:	e8 f9 fb ff ff       	call   8016fc <dev_lookup>
  801b03:	85 c0                	test   %eax,%eax
  801b05:	78 49                	js     801b50 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b0e:	75 23                	jne    801b33 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801b10:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b15:	8b 40 48             	mov    0x48(%eax),%eax
  801b18:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b20:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  801b27:	e8 46 e8 ff ff       	call   800372 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801b2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b31:	eb 1d                	jmp    801b50 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801b33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b36:	8b 52 18             	mov    0x18(%edx),%edx
  801b39:	85 d2                	test   %edx,%edx
  801b3b:	74 0e                	je     801b4b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b40:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b44:	89 04 24             	mov    %eax,(%esp)
  801b47:	ff d2                	call   *%edx
  801b49:	eb 05                	jmp    801b50 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801b4b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801b50:	83 c4 24             	add    $0x24,%esp
  801b53:	5b                   	pop    %ebx
  801b54:	5d                   	pop    %ebp
  801b55:	c3                   	ret    

00801b56 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	53                   	push   %ebx
  801b5a:	83 ec 24             	sub    $0x24,%esp
  801b5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b60:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	89 04 24             	mov    %eax,(%esp)
  801b6d:	e8 34 fb ff ff       	call   8016a6 <fd_lookup>
  801b72:	89 c2                	mov    %eax,%edx
  801b74:	85 d2                	test   %edx,%edx
  801b76:	78 52                	js     801bca <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b78:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b82:	8b 00                	mov    (%eax),%eax
  801b84:	89 04 24             	mov    %eax,(%esp)
  801b87:	e8 70 fb ff ff       	call   8016fc <dev_lookup>
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	78 3a                	js     801bca <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b93:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b97:	74 2c                	je     801bc5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b99:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b9c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ba3:	00 00 00 
	stat->st_isdir = 0;
  801ba6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bad:	00 00 00 
	stat->st_dev = dev;
  801bb0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bb6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bbd:	89 14 24             	mov    %edx,(%esp)
  801bc0:	ff 50 14             	call   *0x14(%eax)
  801bc3:	eb 05                	jmp    801bca <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801bc5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801bca:	83 c4 24             	add    $0x24,%esp
  801bcd:	5b                   	pop    %ebx
  801bce:	5d                   	pop    %ebp
  801bcf:	c3                   	ret    

00801bd0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	56                   	push   %esi
  801bd4:	53                   	push   %ebx
  801bd5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bd8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bdf:	00 
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	89 04 24             	mov    %eax,(%esp)
  801be6:	e8 84 02 00 00       	call   801e6f <open>
  801beb:	89 c3                	mov    %eax,%ebx
  801bed:	85 db                	test   %ebx,%ebx
  801bef:	78 1b                	js     801c0c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf8:	89 1c 24             	mov    %ebx,(%esp)
  801bfb:	e8 56 ff ff ff       	call   801b56 <fstat>
  801c00:	89 c6                	mov    %eax,%esi
	close(fd);
  801c02:	89 1c 24             	mov    %ebx,(%esp)
  801c05:	e8 cd fb ff ff       	call   8017d7 <close>
	return r;
  801c0a:	89 f0                	mov    %esi,%eax
}
  801c0c:	83 c4 10             	add    $0x10,%esp
  801c0f:	5b                   	pop    %ebx
  801c10:	5e                   	pop    %esi
  801c11:	5d                   	pop    %ebp
  801c12:	c3                   	ret    

00801c13 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	56                   	push   %esi
  801c17:	53                   	push   %ebx
  801c18:	83 ec 10             	sub    $0x10,%esp
  801c1b:	89 c6                	mov    %eax,%esi
  801c1d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c1f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801c26:	75 11                	jne    801c39 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c2f:	e8 c1 f9 ff ff       	call   8015f5 <ipc_find_env>
  801c34:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c39:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c40:	00 
  801c41:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c48:	00 
  801c49:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c4d:	a1 00 50 80 00       	mov    0x805000,%eax
  801c52:	89 04 24             	mov    %eax,(%esp)
  801c55:	e8 0e f9 ff ff       	call   801568 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c5a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c61:	00 
  801c62:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c66:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c6d:	e8 8e f8 ff ff       	call   801500 <ipc_recv>
}
  801c72:	83 c4 10             	add    $0x10,%esp
  801c75:	5b                   	pop    %ebx
  801c76:	5e                   	pop    %esi
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    

00801c79 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
  801c7c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	8b 40 0c             	mov    0xc(%eax),%eax
  801c85:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c92:	ba 00 00 00 00       	mov    $0x0,%edx
  801c97:	b8 02 00 00 00       	mov    $0x2,%eax
  801c9c:	e8 72 ff ff ff       	call   801c13 <fsipc>
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	8b 40 0c             	mov    0xc(%eax),%eax
  801caf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801cb4:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb9:	b8 06 00 00 00       	mov    $0x6,%eax
  801cbe:	e8 50 ff ff ff       	call   801c13 <fsipc>
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	53                   	push   %ebx
  801cc9:	83 ec 14             	sub    $0x14,%esp
  801ccc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd2:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cda:	ba 00 00 00 00       	mov    $0x0,%edx
  801cdf:	b8 05 00 00 00       	mov    $0x5,%eax
  801ce4:	e8 2a ff ff ff       	call   801c13 <fsipc>
  801ce9:	89 c2                	mov    %eax,%edx
  801ceb:	85 d2                	test   %edx,%edx
  801ced:	78 2b                	js     801d1a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cef:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cf6:	00 
  801cf7:	89 1c 24             	mov    %ebx,(%esp)
  801cfa:	e8 98 ec ff ff       	call   800997 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cff:	a1 80 60 80 00       	mov    0x806080,%eax
  801d04:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d0a:	a1 84 60 80 00       	mov    0x806084,%eax
  801d0f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1a:	83 c4 14             	add    $0x14,%esp
  801d1d:	5b                   	pop    %ebx
  801d1e:	5d                   	pop    %ebp
  801d1f:	c3                   	ret    

00801d20 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	53                   	push   %ebx
  801d24:	83 ec 14             	sub    $0x14,%esp
  801d27:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801d30:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801d35:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801d3b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801d40:	0f 46 c3             	cmovbe %ebx,%eax
  801d43:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801d48:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d53:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801d5a:	e8 d5 ed ff ff       	call   800b34 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d64:	b8 04 00 00 00       	mov    $0x4,%eax
  801d69:	e8 a5 fe ff ff       	call   801c13 <fsipc>
  801d6e:	85 c0                	test   %eax,%eax
  801d70:	78 53                	js     801dc5 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801d72:	39 c3                	cmp    %eax,%ebx
  801d74:	73 24                	jae    801d9a <devfile_write+0x7a>
  801d76:	c7 44 24 0c ac 32 80 	movl   $0x8032ac,0xc(%esp)
  801d7d:	00 
  801d7e:	c7 44 24 08 b3 32 80 	movl   $0x8032b3,0x8(%esp)
  801d85:	00 
  801d86:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801d8d:	00 
  801d8e:	c7 04 24 c8 32 80 00 	movl   $0x8032c8,(%esp)
  801d95:	e8 df e4 ff ff       	call   800279 <_panic>
	assert(r <= PGSIZE);
  801d9a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d9f:	7e 24                	jle    801dc5 <devfile_write+0xa5>
  801da1:	c7 44 24 0c d3 32 80 	movl   $0x8032d3,0xc(%esp)
  801da8:	00 
  801da9:	c7 44 24 08 b3 32 80 	movl   $0x8032b3,0x8(%esp)
  801db0:	00 
  801db1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801db8:	00 
  801db9:	c7 04 24 c8 32 80 00 	movl   $0x8032c8,(%esp)
  801dc0:	e8 b4 e4 ff ff       	call   800279 <_panic>
	return r;
}
  801dc5:	83 c4 14             	add    $0x14,%esp
  801dc8:	5b                   	pop    %ebx
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    

00801dcb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	56                   	push   %esi
  801dcf:	53                   	push   %ebx
  801dd0:	83 ec 10             	sub    $0x10,%esp
  801dd3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd9:	8b 40 0c             	mov    0xc(%eax),%eax
  801ddc:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801de1:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801de7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dec:	b8 03 00 00 00       	mov    $0x3,%eax
  801df1:	e8 1d fe ff ff       	call   801c13 <fsipc>
  801df6:	89 c3                	mov    %eax,%ebx
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	78 6a                	js     801e66 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801dfc:	39 c6                	cmp    %eax,%esi
  801dfe:	73 24                	jae    801e24 <devfile_read+0x59>
  801e00:	c7 44 24 0c ac 32 80 	movl   $0x8032ac,0xc(%esp)
  801e07:	00 
  801e08:	c7 44 24 08 b3 32 80 	movl   $0x8032b3,0x8(%esp)
  801e0f:	00 
  801e10:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801e17:	00 
  801e18:	c7 04 24 c8 32 80 00 	movl   $0x8032c8,(%esp)
  801e1f:	e8 55 e4 ff ff       	call   800279 <_panic>
	assert(r <= PGSIZE);
  801e24:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e29:	7e 24                	jle    801e4f <devfile_read+0x84>
  801e2b:	c7 44 24 0c d3 32 80 	movl   $0x8032d3,0xc(%esp)
  801e32:	00 
  801e33:	c7 44 24 08 b3 32 80 	movl   $0x8032b3,0x8(%esp)
  801e3a:	00 
  801e3b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801e42:	00 
  801e43:	c7 04 24 c8 32 80 00 	movl   $0x8032c8,(%esp)
  801e4a:	e8 2a e4 ff ff       	call   800279 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e4f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e53:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e5a:	00 
  801e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e5e:	89 04 24             	mov    %eax,(%esp)
  801e61:	e8 ce ec ff ff       	call   800b34 <memmove>
	return r;
}
  801e66:	89 d8                	mov    %ebx,%eax
  801e68:	83 c4 10             	add    $0x10,%esp
  801e6b:	5b                   	pop    %ebx
  801e6c:	5e                   	pop    %esi
  801e6d:	5d                   	pop    %ebp
  801e6e:	c3                   	ret    

00801e6f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	53                   	push   %ebx
  801e73:	83 ec 24             	sub    $0x24,%esp
  801e76:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801e79:	89 1c 24             	mov    %ebx,(%esp)
  801e7c:	e8 df ea ff ff       	call   800960 <strlen>
  801e81:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e86:	7f 60                	jg     801ee8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801e88:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e8b:	89 04 24             	mov    %eax,(%esp)
  801e8e:	e8 c4 f7 ff ff       	call   801657 <fd_alloc>
  801e93:	89 c2                	mov    %eax,%edx
  801e95:	85 d2                	test   %edx,%edx
  801e97:	78 54                	js     801eed <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801e99:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e9d:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801ea4:	e8 ee ea ff ff       	call   800997 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eac:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801eb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb4:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb9:	e8 55 fd ff ff       	call   801c13 <fsipc>
  801ebe:	89 c3                	mov    %eax,%ebx
  801ec0:	85 c0                	test   %eax,%eax
  801ec2:	79 17                	jns    801edb <open+0x6c>
		fd_close(fd, 0);
  801ec4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ecb:	00 
  801ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecf:	89 04 24             	mov    %eax,(%esp)
  801ed2:	e8 7f f8 ff ff       	call   801756 <fd_close>
		return r;
  801ed7:	89 d8                	mov    %ebx,%eax
  801ed9:	eb 12                	jmp    801eed <open+0x7e>
	}

	return fd2num(fd);
  801edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ede:	89 04 24             	mov    %eax,(%esp)
  801ee1:	e8 4a f7 ff ff       	call   801630 <fd2num>
  801ee6:	eb 05                	jmp    801eed <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801ee8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801eed:	83 c4 24             	add    $0x24,%esp
  801ef0:	5b                   	pop    %ebx
  801ef1:	5d                   	pop    %ebp
  801ef2:	c3                   	ret    

00801ef3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ef9:	ba 00 00 00 00       	mov    $0x0,%edx
  801efe:	b8 08 00 00 00       	mov    $0x8,%eax
  801f03:	e8 0b fd ff ff       	call   801c13 <fsipc>
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f10:	89 d0                	mov    %edx,%eax
  801f12:	c1 e8 16             	shr    $0x16,%eax
  801f15:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f1c:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f21:	f6 c1 01             	test   $0x1,%cl
  801f24:	74 1d                	je     801f43 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801f26:	c1 ea 0c             	shr    $0xc,%edx
  801f29:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f30:	f6 c2 01             	test   $0x1,%dl
  801f33:	74 0e                	je     801f43 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f35:	c1 ea 0c             	shr    $0xc,%edx
  801f38:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f3f:	ef 
  801f40:	0f b7 c0             	movzwl %ax,%eax
}
  801f43:	5d                   	pop    %ebp
  801f44:	c3                   	ret    
  801f45:	66 90                	xchg   %ax,%ax
  801f47:	66 90                	xchg   %ax,%ax
  801f49:	66 90                	xchg   %ax,%ax
  801f4b:	66 90                	xchg   %ax,%ax
  801f4d:	66 90                	xchg   %ax,%ax
  801f4f:	90                   	nop

00801f50 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f50:	55                   	push   %ebp
  801f51:	89 e5                	mov    %esp,%ebp
  801f53:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801f56:	c7 44 24 04 df 32 80 	movl   $0x8032df,0x4(%esp)
  801f5d:	00 
  801f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f61:	89 04 24             	mov    %eax,(%esp)
  801f64:	e8 2e ea ff ff       	call   800997 <strcpy>
	return 0;
}
  801f69:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	53                   	push   %ebx
  801f74:	83 ec 14             	sub    $0x14,%esp
  801f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f7a:	89 1c 24             	mov    %ebx,(%esp)
  801f7d:	e8 88 ff ff ff       	call   801f0a <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801f82:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801f87:	83 f8 01             	cmp    $0x1,%eax
  801f8a:	75 0d                	jne    801f99 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801f8c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f8f:	89 04 24             	mov    %eax,(%esp)
  801f92:	e8 29 03 00 00       	call   8022c0 <nsipc_close>
  801f97:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801f99:	89 d0                	mov    %edx,%eax
  801f9b:	83 c4 14             	add    $0x14,%esp
  801f9e:	5b                   	pop    %ebx
  801f9f:	5d                   	pop    %ebp
  801fa0:	c3                   	ret    

00801fa1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fa7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fae:	00 
  801faf:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc3:	89 04 24             	mov    %eax,(%esp)
  801fc6:	e8 f0 03 00 00       	call   8023bb <nsipc_send>
}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fd3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fda:	00 
  801fdb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fde:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	8b 40 0c             	mov    0xc(%eax),%eax
  801fef:	89 04 24             	mov    %eax,(%esp)
  801ff2:	e8 44 03 00 00       	call   80233b <nsipc_recv>
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fff:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802002:	89 54 24 04          	mov    %edx,0x4(%esp)
  802006:	89 04 24             	mov    %eax,(%esp)
  802009:	e8 98 f6 ff ff       	call   8016a6 <fd_lookup>
  80200e:	85 c0                	test   %eax,%eax
  802010:	78 17                	js     802029 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802015:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80201b:	39 08                	cmp    %ecx,(%eax)
  80201d:	75 05                	jne    802024 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80201f:	8b 40 0c             	mov    0xc(%eax),%eax
  802022:	eb 05                	jmp    802029 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802024:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	56                   	push   %esi
  80202f:	53                   	push   %ebx
  802030:	83 ec 20             	sub    $0x20,%esp
  802033:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802035:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802038:	89 04 24             	mov    %eax,(%esp)
  80203b:	e8 17 f6 ff ff       	call   801657 <fd_alloc>
  802040:	89 c3                	mov    %eax,%ebx
  802042:	85 c0                	test   %eax,%eax
  802044:	78 21                	js     802067 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802046:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80204d:	00 
  80204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802051:	89 44 24 04          	mov    %eax,0x4(%esp)
  802055:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80205c:	e8 52 ed ff ff       	call   800db3 <sys_page_alloc>
  802061:	89 c3                	mov    %eax,%ebx
  802063:	85 c0                	test   %eax,%eax
  802065:	79 0c                	jns    802073 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802067:	89 34 24             	mov    %esi,(%esp)
  80206a:	e8 51 02 00 00       	call   8022c0 <nsipc_close>
		return r;
  80206f:	89 d8                	mov    %ebx,%eax
  802071:	eb 20                	jmp    802093 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802073:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80207e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802081:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802088:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80208b:	89 14 24             	mov    %edx,(%esp)
  80208e:	e8 9d f5 ff ff       	call   801630 <fd2num>
}
  802093:	83 c4 20             	add    $0x20,%esp
  802096:	5b                   	pop    %ebx
  802097:	5e                   	pop    %esi
  802098:	5d                   	pop    %ebp
  802099:	c3                   	ret    

0080209a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	e8 51 ff ff ff       	call   801ff9 <fd2sockid>
		return r;
  8020a8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	78 23                	js     8020d1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020ae:	8b 55 10             	mov    0x10(%ebp),%edx
  8020b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020bc:	89 04 24             	mov    %eax,(%esp)
  8020bf:	e8 45 01 00 00       	call   802209 <nsipc_accept>
		return r;
  8020c4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020c6:	85 c0                	test   %eax,%eax
  8020c8:	78 07                	js     8020d1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8020ca:	e8 5c ff ff ff       	call   80202b <alloc_sockfd>
  8020cf:	89 c1                	mov    %eax,%ecx
}
  8020d1:	89 c8                	mov    %ecx,%eax
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	e8 16 ff ff ff       	call   801ff9 <fd2sockid>
  8020e3:	89 c2                	mov    %eax,%edx
  8020e5:	85 d2                	test   %edx,%edx
  8020e7:	78 16                	js     8020ff <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8020e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f7:	89 14 24             	mov    %edx,(%esp)
  8020fa:	e8 60 01 00 00       	call   80225f <nsipc_bind>
}
  8020ff:	c9                   	leave  
  802100:	c3                   	ret    

00802101 <shutdown>:

int
shutdown(int s, int how)
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
  802104:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	e8 ea fe ff ff       	call   801ff9 <fd2sockid>
  80210f:	89 c2                	mov    %eax,%edx
  802111:	85 d2                	test   %edx,%edx
  802113:	78 0f                	js     802124 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802115:	8b 45 0c             	mov    0xc(%ebp),%eax
  802118:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211c:	89 14 24             	mov    %edx,(%esp)
  80211f:	e8 7a 01 00 00       	call   80229e <nsipc_shutdown>
}
  802124:	c9                   	leave  
  802125:	c3                   	ret    

00802126 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	e8 c5 fe ff ff       	call   801ff9 <fd2sockid>
  802134:	89 c2                	mov    %eax,%edx
  802136:	85 d2                	test   %edx,%edx
  802138:	78 16                	js     802150 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80213a:	8b 45 10             	mov    0x10(%ebp),%eax
  80213d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802141:	8b 45 0c             	mov    0xc(%ebp),%eax
  802144:	89 44 24 04          	mov    %eax,0x4(%esp)
  802148:	89 14 24             	mov    %edx,(%esp)
  80214b:	e8 8a 01 00 00       	call   8022da <nsipc_connect>
}
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <listen>:

int
listen(int s, int backlog)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802158:	8b 45 08             	mov    0x8(%ebp),%eax
  80215b:	e8 99 fe ff ff       	call   801ff9 <fd2sockid>
  802160:	89 c2                	mov    %eax,%edx
  802162:	85 d2                	test   %edx,%edx
  802164:	78 0f                	js     802175 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802166:	8b 45 0c             	mov    0xc(%ebp),%eax
  802169:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216d:	89 14 24             	mov    %edx,(%esp)
  802170:	e8 a4 01 00 00       	call   802319 <nsipc_listen>
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80217d:	8b 45 10             	mov    0x10(%ebp),%eax
  802180:	89 44 24 08          	mov    %eax,0x8(%esp)
  802184:	8b 45 0c             	mov    0xc(%ebp),%eax
  802187:	89 44 24 04          	mov    %eax,0x4(%esp)
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	89 04 24             	mov    %eax,(%esp)
  802191:	e8 98 02 00 00       	call   80242e <nsipc_socket>
  802196:	89 c2                	mov    %eax,%edx
  802198:	85 d2                	test   %edx,%edx
  80219a:	78 05                	js     8021a1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80219c:	e8 8a fe ff ff       	call   80202b <alloc_sockfd>
}
  8021a1:	c9                   	leave  
  8021a2:	c3                   	ret    

008021a3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	53                   	push   %ebx
  8021a7:	83 ec 14             	sub    $0x14,%esp
  8021aa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8021ac:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8021b3:	75 11                	jne    8021c6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8021b5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8021bc:	e8 34 f4 ff ff       	call   8015f5 <ipc_find_env>
  8021c1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021c6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8021cd:	00 
  8021ce:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8021d5:	00 
  8021d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021da:	a1 04 50 80 00       	mov    0x805004,%eax
  8021df:	89 04 24             	mov    %eax,(%esp)
  8021e2:	e8 81 f3 ff ff       	call   801568 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021ee:	00 
  8021ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8021f6:	00 
  8021f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021fe:	e8 fd f2 ff ff       	call   801500 <ipc_recv>
}
  802203:	83 c4 14             	add    $0x14,%esp
  802206:	5b                   	pop    %ebx
  802207:	5d                   	pop    %ebp
  802208:	c3                   	ret    

00802209 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	56                   	push   %esi
  80220d:	53                   	push   %ebx
  80220e:	83 ec 10             	sub    $0x10,%esp
  802211:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80221c:	8b 06                	mov    (%esi),%eax
  80221e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802223:	b8 01 00 00 00       	mov    $0x1,%eax
  802228:	e8 76 ff ff ff       	call   8021a3 <nsipc>
  80222d:	89 c3                	mov    %eax,%ebx
  80222f:	85 c0                	test   %eax,%eax
  802231:	78 23                	js     802256 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802233:	a1 10 70 80 00       	mov    0x807010,%eax
  802238:	89 44 24 08          	mov    %eax,0x8(%esp)
  80223c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802243:	00 
  802244:	8b 45 0c             	mov    0xc(%ebp),%eax
  802247:	89 04 24             	mov    %eax,(%esp)
  80224a:	e8 e5 e8 ff ff       	call   800b34 <memmove>
		*addrlen = ret->ret_addrlen;
  80224f:	a1 10 70 80 00       	mov    0x807010,%eax
  802254:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802256:	89 d8                	mov    %ebx,%eax
  802258:	83 c4 10             	add    $0x10,%esp
  80225b:	5b                   	pop    %ebx
  80225c:	5e                   	pop    %esi
  80225d:	5d                   	pop    %ebp
  80225e:	c3                   	ret    

0080225f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
  802262:	53                   	push   %ebx
  802263:	83 ec 14             	sub    $0x14,%esp
  802266:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802271:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802275:	8b 45 0c             	mov    0xc(%ebp),%eax
  802278:	89 44 24 04          	mov    %eax,0x4(%esp)
  80227c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802283:	e8 ac e8 ff ff       	call   800b34 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802288:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80228e:	b8 02 00 00 00       	mov    $0x2,%eax
  802293:	e8 0b ff ff ff       	call   8021a3 <nsipc>
}
  802298:	83 c4 14             	add    $0x14,%esp
  80229b:	5b                   	pop    %ebx
  80229c:	5d                   	pop    %ebp
  80229d:	c3                   	ret    

0080229e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8022ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022af:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8022b4:	b8 03 00 00 00       	mov    $0x3,%eax
  8022b9:	e8 e5 fe ff ff       	call   8021a3 <nsipc>
}
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <nsipc_close>:

int
nsipc_close(int s)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8022ce:	b8 04 00 00 00       	mov    $0x4,%eax
  8022d3:	e8 cb fe ff ff       	call   8021a3 <nsipc>
}
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	53                   	push   %ebx
  8022de:	83 ec 14             	sub    $0x14,%esp
  8022e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8022fe:	e8 31 e8 ff ff       	call   800b34 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802303:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802309:	b8 05 00 00 00       	mov    $0x5,%eax
  80230e:	e8 90 fe ff ff       	call   8021a3 <nsipc>
}
  802313:	83 c4 14             	add    $0x14,%esp
  802316:	5b                   	pop    %ebx
  802317:	5d                   	pop    %ebp
  802318:	c3                   	ret    

00802319 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80232f:	b8 06 00 00 00       	mov    $0x6,%eax
  802334:	e8 6a fe ff ff       	call   8021a3 <nsipc>
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	56                   	push   %esi
  80233f:	53                   	push   %ebx
  802340:	83 ec 10             	sub    $0x10,%esp
  802343:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80234e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802354:	8b 45 14             	mov    0x14(%ebp),%eax
  802357:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80235c:	b8 07 00 00 00       	mov    $0x7,%eax
  802361:	e8 3d fe ff ff       	call   8021a3 <nsipc>
  802366:	89 c3                	mov    %eax,%ebx
  802368:	85 c0                	test   %eax,%eax
  80236a:	78 46                	js     8023b2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80236c:	39 f0                	cmp    %esi,%eax
  80236e:	7f 07                	jg     802377 <nsipc_recv+0x3c>
  802370:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802375:	7e 24                	jle    80239b <nsipc_recv+0x60>
  802377:	c7 44 24 0c eb 32 80 	movl   $0x8032eb,0xc(%esp)
  80237e:	00 
  80237f:	c7 44 24 08 b3 32 80 	movl   $0x8032b3,0x8(%esp)
  802386:	00 
  802387:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80238e:	00 
  80238f:	c7 04 24 00 33 80 00 	movl   $0x803300,(%esp)
  802396:	e8 de de ff ff       	call   800279 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80239b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80239f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8023a6:	00 
  8023a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023aa:	89 04 24             	mov    %eax,(%esp)
  8023ad:	e8 82 e7 ff ff       	call   800b34 <memmove>
	}

	return r;
}
  8023b2:	89 d8                	mov    %ebx,%eax
  8023b4:	83 c4 10             	add    $0x10,%esp
  8023b7:	5b                   	pop    %ebx
  8023b8:	5e                   	pop    %esi
  8023b9:	5d                   	pop    %ebp
  8023ba:	c3                   	ret    

008023bb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	53                   	push   %ebx
  8023bf:	83 ec 14             	sub    $0x14,%esp
  8023c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8023c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8023cd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023d3:	7e 24                	jle    8023f9 <nsipc_send+0x3e>
  8023d5:	c7 44 24 0c 0c 33 80 	movl   $0x80330c,0xc(%esp)
  8023dc:	00 
  8023dd:	c7 44 24 08 b3 32 80 	movl   $0x8032b3,0x8(%esp)
  8023e4:	00 
  8023e5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8023ec:	00 
  8023ed:	c7 04 24 00 33 80 00 	movl   $0x803300,(%esp)
  8023f4:	e8 80 de ff ff       	call   800279 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802400:	89 44 24 04          	mov    %eax,0x4(%esp)
  802404:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80240b:	e8 24 e7 ff ff       	call   800b34 <memmove>
	nsipcbuf.send.req_size = size;
  802410:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802416:	8b 45 14             	mov    0x14(%ebp),%eax
  802419:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80241e:	b8 08 00 00 00       	mov    $0x8,%eax
  802423:	e8 7b fd ff ff       	call   8021a3 <nsipc>
}
  802428:	83 c4 14             	add    $0x14,%esp
  80242b:	5b                   	pop    %ebx
  80242c:	5d                   	pop    %ebp
  80242d:	c3                   	ret    

0080242e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80242e:	55                   	push   %ebp
  80242f:	89 e5                	mov    %esp,%ebp
  802431:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802434:	8b 45 08             	mov    0x8(%ebp),%eax
  802437:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80243c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802444:	8b 45 10             	mov    0x10(%ebp),%eax
  802447:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80244c:	b8 09 00 00 00       	mov    $0x9,%eax
  802451:	e8 4d fd ff ff       	call   8021a3 <nsipc>
}
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	56                   	push   %esi
  80245c:	53                   	push   %ebx
  80245d:	83 ec 10             	sub    $0x10,%esp
  802460:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	89 04 24             	mov    %eax,(%esp)
  802469:	e8 d2 f1 ff ff       	call   801640 <fd2data>
  80246e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802470:	c7 44 24 04 18 33 80 	movl   $0x803318,0x4(%esp)
  802477:	00 
  802478:	89 1c 24             	mov    %ebx,(%esp)
  80247b:	e8 17 e5 ff ff       	call   800997 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802480:	8b 46 04             	mov    0x4(%esi),%eax
  802483:	2b 06                	sub    (%esi),%eax
  802485:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80248b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802492:	00 00 00 
	stat->st_dev = &devpipe;
  802495:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80249c:	40 80 00 
	return 0;
}
  80249f:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a4:	83 c4 10             	add    $0x10,%esp
  8024a7:	5b                   	pop    %ebx
  8024a8:	5e                   	pop    %esi
  8024a9:	5d                   	pop    %ebp
  8024aa:	c3                   	ret    

008024ab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
  8024ae:	53                   	push   %ebx
  8024af:	83 ec 14             	sub    $0x14,%esp
  8024b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c0:	e8 95 e9 ff ff       	call   800e5a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024c5:	89 1c 24             	mov    %ebx,(%esp)
  8024c8:	e8 73 f1 ff ff       	call   801640 <fd2data>
  8024cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d8:	e8 7d e9 ff ff       	call   800e5a <sys_page_unmap>
}
  8024dd:	83 c4 14             	add    $0x14,%esp
  8024e0:	5b                   	pop    %ebx
  8024e1:	5d                   	pop    %ebp
  8024e2:	c3                   	ret    

008024e3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8024e3:	55                   	push   %ebp
  8024e4:	89 e5                	mov    %esp,%ebp
  8024e6:	57                   	push   %edi
  8024e7:	56                   	push   %esi
  8024e8:	53                   	push   %ebx
  8024e9:	83 ec 2c             	sub    $0x2c,%esp
  8024ec:	89 c6                	mov    %eax,%esi
  8024ee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8024f1:	a1 08 50 80 00       	mov    0x805008,%eax
  8024f6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024f9:	89 34 24             	mov    %esi,(%esp)
  8024fc:	e8 09 fa ff ff       	call   801f0a <pageref>
  802501:	89 c7                	mov    %eax,%edi
  802503:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802506:	89 04 24             	mov    %eax,(%esp)
  802509:	e8 fc f9 ff ff       	call   801f0a <pageref>
  80250e:	39 c7                	cmp    %eax,%edi
  802510:	0f 94 c2             	sete   %dl
  802513:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802516:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80251c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80251f:	39 fb                	cmp    %edi,%ebx
  802521:	74 21                	je     802544 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802523:	84 d2                	test   %dl,%dl
  802525:	74 ca                	je     8024f1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802527:	8b 51 58             	mov    0x58(%ecx),%edx
  80252a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80252e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802532:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802536:	c7 04 24 1f 33 80 00 	movl   $0x80331f,(%esp)
  80253d:	e8 30 de ff ff       	call   800372 <cprintf>
  802542:	eb ad                	jmp    8024f1 <_pipeisclosed+0xe>
	}
}
  802544:	83 c4 2c             	add    $0x2c,%esp
  802547:	5b                   	pop    %ebx
  802548:	5e                   	pop    %esi
  802549:	5f                   	pop    %edi
  80254a:	5d                   	pop    %ebp
  80254b:	c3                   	ret    

0080254c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
  80254f:	57                   	push   %edi
  802550:	56                   	push   %esi
  802551:	53                   	push   %ebx
  802552:	83 ec 1c             	sub    $0x1c,%esp
  802555:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802558:	89 34 24             	mov    %esi,(%esp)
  80255b:	e8 e0 f0 ff ff       	call   801640 <fd2data>
  802560:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802562:	bf 00 00 00 00       	mov    $0x0,%edi
  802567:	eb 45                	jmp    8025ae <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802569:	89 da                	mov    %ebx,%edx
  80256b:	89 f0                	mov    %esi,%eax
  80256d:	e8 71 ff ff ff       	call   8024e3 <_pipeisclosed>
  802572:	85 c0                	test   %eax,%eax
  802574:	75 41                	jne    8025b7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802576:	e8 19 e8 ff ff       	call   800d94 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80257b:	8b 43 04             	mov    0x4(%ebx),%eax
  80257e:	8b 0b                	mov    (%ebx),%ecx
  802580:	8d 51 20             	lea    0x20(%ecx),%edx
  802583:	39 d0                	cmp    %edx,%eax
  802585:	73 e2                	jae    802569 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802587:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80258a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80258e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802591:	99                   	cltd   
  802592:	c1 ea 1b             	shr    $0x1b,%edx
  802595:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802598:	83 e1 1f             	and    $0x1f,%ecx
  80259b:	29 d1                	sub    %edx,%ecx
  80259d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8025a1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8025a5:	83 c0 01             	add    $0x1,%eax
  8025a8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025ab:	83 c7 01             	add    $0x1,%edi
  8025ae:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8025b1:	75 c8                	jne    80257b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8025b3:	89 f8                	mov    %edi,%eax
  8025b5:	eb 05                	jmp    8025bc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8025b7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8025bc:	83 c4 1c             	add    $0x1c,%esp
  8025bf:	5b                   	pop    %ebx
  8025c0:	5e                   	pop    %esi
  8025c1:	5f                   	pop    %edi
  8025c2:	5d                   	pop    %ebp
  8025c3:	c3                   	ret    

008025c4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	57                   	push   %edi
  8025c8:	56                   	push   %esi
  8025c9:	53                   	push   %ebx
  8025ca:	83 ec 1c             	sub    $0x1c,%esp
  8025cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8025d0:	89 3c 24             	mov    %edi,(%esp)
  8025d3:	e8 68 f0 ff ff       	call   801640 <fd2data>
  8025d8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025da:	be 00 00 00 00       	mov    $0x0,%esi
  8025df:	eb 3d                	jmp    80261e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8025e1:	85 f6                	test   %esi,%esi
  8025e3:	74 04                	je     8025e9 <devpipe_read+0x25>
				return i;
  8025e5:	89 f0                	mov    %esi,%eax
  8025e7:	eb 43                	jmp    80262c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8025e9:	89 da                	mov    %ebx,%edx
  8025eb:	89 f8                	mov    %edi,%eax
  8025ed:	e8 f1 fe ff ff       	call   8024e3 <_pipeisclosed>
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	75 31                	jne    802627 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8025f6:	e8 99 e7 ff ff       	call   800d94 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8025fb:	8b 03                	mov    (%ebx),%eax
  8025fd:	3b 43 04             	cmp    0x4(%ebx),%eax
  802600:	74 df                	je     8025e1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802602:	99                   	cltd   
  802603:	c1 ea 1b             	shr    $0x1b,%edx
  802606:	01 d0                	add    %edx,%eax
  802608:	83 e0 1f             	and    $0x1f,%eax
  80260b:	29 d0                	sub    %edx,%eax
  80260d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802612:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802615:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802618:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80261b:	83 c6 01             	add    $0x1,%esi
  80261e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802621:	75 d8                	jne    8025fb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802623:	89 f0                	mov    %esi,%eax
  802625:	eb 05                	jmp    80262c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802627:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80262c:	83 c4 1c             	add    $0x1c,%esp
  80262f:	5b                   	pop    %ebx
  802630:	5e                   	pop    %esi
  802631:	5f                   	pop    %edi
  802632:	5d                   	pop    %ebp
  802633:	c3                   	ret    

00802634 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802634:	55                   	push   %ebp
  802635:	89 e5                	mov    %esp,%ebp
  802637:	56                   	push   %esi
  802638:	53                   	push   %ebx
  802639:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80263c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80263f:	89 04 24             	mov    %eax,(%esp)
  802642:	e8 10 f0 ff ff       	call   801657 <fd_alloc>
  802647:	89 c2                	mov    %eax,%edx
  802649:	85 d2                	test   %edx,%edx
  80264b:	0f 88 4d 01 00 00    	js     80279e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802651:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802658:	00 
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802660:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802667:	e8 47 e7 ff ff       	call   800db3 <sys_page_alloc>
  80266c:	89 c2                	mov    %eax,%edx
  80266e:	85 d2                	test   %edx,%edx
  802670:	0f 88 28 01 00 00    	js     80279e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802676:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802679:	89 04 24             	mov    %eax,(%esp)
  80267c:	e8 d6 ef ff ff       	call   801657 <fd_alloc>
  802681:	89 c3                	mov    %eax,%ebx
  802683:	85 c0                	test   %eax,%eax
  802685:	0f 88 fe 00 00 00    	js     802789 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80268b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802692:	00 
  802693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802696:	89 44 24 04          	mov    %eax,0x4(%esp)
  80269a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a1:	e8 0d e7 ff ff       	call   800db3 <sys_page_alloc>
  8026a6:	89 c3                	mov    %eax,%ebx
  8026a8:	85 c0                	test   %eax,%eax
  8026aa:	0f 88 d9 00 00 00    	js     802789 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	89 04 24             	mov    %eax,(%esp)
  8026b6:	e8 85 ef ff ff       	call   801640 <fd2data>
  8026bb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026bd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026c4:	00 
  8026c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026d0:	e8 de e6 ff ff       	call   800db3 <sys_page_alloc>
  8026d5:	89 c3                	mov    %eax,%ebx
  8026d7:	85 c0                	test   %eax,%eax
  8026d9:	0f 88 97 00 00 00    	js     802776 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e2:	89 04 24             	mov    %eax,(%esp)
  8026e5:	e8 56 ef ff ff       	call   801640 <fd2data>
  8026ea:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8026f1:	00 
  8026f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8026fd:	00 
  8026fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  802702:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802709:	e8 f9 e6 ff ff       	call   800e07 <sys_page_map>
  80270e:	89 c3                	mov    %eax,%ebx
  802710:	85 c0                	test   %eax,%eax
  802712:	78 52                	js     802766 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802714:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802729:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80272f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802732:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802737:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80273e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802741:	89 04 24             	mov    %eax,(%esp)
  802744:	e8 e7 ee ff ff       	call   801630 <fd2num>
  802749:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80274c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80274e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802751:	89 04 24             	mov    %eax,(%esp)
  802754:	e8 d7 ee ff ff       	call   801630 <fd2num>
  802759:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80275c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80275f:	b8 00 00 00 00       	mov    $0x0,%eax
  802764:	eb 38                	jmp    80279e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802766:	89 74 24 04          	mov    %esi,0x4(%esp)
  80276a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802771:	e8 e4 e6 ff ff       	call   800e5a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802779:	89 44 24 04          	mov    %eax,0x4(%esp)
  80277d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802784:	e8 d1 e6 ff ff       	call   800e5a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802790:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802797:	e8 be e6 ff ff       	call   800e5a <sys_page_unmap>
  80279c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80279e:	83 c4 30             	add    $0x30,%esp
  8027a1:	5b                   	pop    %ebx
  8027a2:	5e                   	pop    %esi
  8027a3:	5d                   	pop    %ebp
  8027a4:	c3                   	ret    

008027a5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8027a5:	55                   	push   %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
  8027a8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b5:	89 04 24             	mov    %eax,(%esp)
  8027b8:	e8 e9 ee ff ff       	call   8016a6 <fd_lookup>
  8027bd:	89 c2                	mov    %eax,%edx
  8027bf:	85 d2                	test   %edx,%edx
  8027c1:	78 15                	js     8027d8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	89 04 24             	mov    %eax,(%esp)
  8027c9:	e8 72 ee ff ff       	call   801640 <fd2data>
	return _pipeisclosed(fd, p);
  8027ce:	89 c2                	mov    %eax,%edx
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	e8 0b fd ff ff       	call   8024e3 <_pipeisclosed>
}
  8027d8:	c9                   	leave  
  8027d9:	c3                   	ret    
  8027da:	66 90                	xchg   %ax,%ax
  8027dc:	66 90                	xchg   %ax,%ax
  8027de:	66 90                	xchg   %ax,%ax

008027e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8027e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e8:	5d                   	pop    %ebp
  8027e9:	c3                   	ret    

008027ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027ea:	55                   	push   %ebp
  8027eb:	89 e5                	mov    %esp,%ebp
  8027ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8027f0:	c7 44 24 04 37 33 80 	movl   $0x803337,0x4(%esp)
  8027f7:	00 
  8027f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027fb:	89 04 24             	mov    %eax,(%esp)
  8027fe:	e8 94 e1 ff ff       	call   800997 <strcpy>
	return 0;
}
  802803:	b8 00 00 00 00       	mov    $0x0,%eax
  802808:	c9                   	leave  
  802809:	c3                   	ret    

0080280a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80280a:	55                   	push   %ebp
  80280b:	89 e5                	mov    %esp,%ebp
  80280d:	57                   	push   %edi
  80280e:	56                   	push   %esi
  80280f:	53                   	push   %ebx
  802810:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802816:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80281b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802821:	eb 31                	jmp    802854 <devcons_write+0x4a>
		m = n - tot;
  802823:	8b 75 10             	mov    0x10(%ebp),%esi
  802826:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802828:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80282b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802830:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802833:	89 74 24 08          	mov    %esi,0x8(%esp)
  802837:	03 45 0c             	add    0xc(%ebp),%eax
  80283a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80283e:	89 3c 24             	mov    %edi,(%esp)
  802841:	e8 ee e2 ff ff       	call   800b34 <memmove>
		sys_cputs(buf, m);
  802846:	89 74 24 04          	mov    %esi,0x4(%esp)
  80284a:	89 3c 24             	mov    %edi,(%esp)
  80284d:	e8 94 e4 ff ff       	call   800ce6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802852:	01 f3                	add    %esi,%ebx
  802854:	89 d8                	mov    %ebx,%eax
  802856:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802859:	72 c8                	jb     802823 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80285b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802861:	5b                   	pop    %ebx
  802862:	5e                   	pop    %esi
  802863:	5f                   	pop    %edi
  802864:	5d                   	pop    %ebp
  802865:	c3                   	ret    

00802866 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
  802869:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80286c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802871:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802875:	75 07                	jne    80287e <devcons_read+0x18>
  802877:	eb 2a                	jmp    8028a3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802879:	e8 16 e5 ff ff       	call   800d94 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80287e:	66 90                	xchg   %ax,%ax
  802880:	e8 7f e4 ff ff       	call   800d04 <sys_cgetc>
  802885:	85 c0                	test   %eax,%eax
  802887:	74 f0                	je     802879 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802889:	85 c0                	test   %eax,%eax
  80288b:	78 16                	js     8028a3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80288d:	83 f8 04             	cmp    $0x4,%eax
  802890:	74 0c                	je     80289e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802892:	8b 55 0c             	mov    0xc(%ebp),%edx
  802895:	88 02                	mov    %al,(%edx)
	return 1;
  802897:	b8 01 00 00 00       	mov    $0x1,%eax
  80289c:	eb 05                	jmp    8028a3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80289e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8028a3:	c9                   	leave  
  8028a4:	c3                   	ret    

008028a5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8028a5:	55                   	push   %ebp
  8028a6:	89 e5                	mov    %esp,%ebp
  8028a8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8028b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8028b8:	00 
  8028b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028bc:	89 04 24             	mov    %eax,(%esp)
  8028bf:	e8 22 e4 ff ff       	call   800ce6 <sys_cputs>
}
  8028c4:	c9                   	leave  
  8028c5:	c3                   	ret    

008028c6 <getchar>:

int
getchar(void)
{
  8028c6:	55                   	push   %ebp
  8028c7:	89 e5                	mov    %esp,%ebp
  8028c9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8028cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8028d3:	00 
  8028d4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028e2:	e8 53 f0 ff ff       	call   80193a <read>
	if (r < 0)
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	78 0f                	js     8028fa <getchar+0x34>
		return r;
	if (r < 1)
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	7e 06                	jle    8028f5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8028ef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8028f3:	eb 05                	jmp    8028fa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8028f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8028fa:	c9                   	leave  
  8028fb:	c3                   	ret    

008028fc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8028fc:	55                   	push   %ebp
  8028fd:	89 e5                	mov    %esp,%ebp
  8028ff:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802902:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802905:	89 44 24 04          	mov    %eax,0x4(%esp)
  802909:	8b 45 08             	mov    0x8(%ebp),%eax
  80290c:	89 04 24             	mov    %eax,(%esp)
  80290f:	e8 92 ed ff ff       	call   8016a6 <fd_lookup>
  802914:	85 c0                	test   %eax,%eax
  802916:	78 11                	js     802929 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802921:	39 10                	cmp    %edx,(%eax)
  802923:	0f 94 c0             	sete   %al
  802926:	0f b6 c0             	movzbl %al,%eax
}
  802929:	c9                   	leave  
  80292a:	c3                   	ret    

0080292b <opencons>:

int
opencons(void)
{
  80292b:	55                   	push   %ebp
  80292c:	89 e5                	mov    %esp,%ebp
  80292e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802931:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802934:	89 04 24             	mov    %eax,(%esp)
  802937:	e8 1b ed ff ff       	call   801657 <fd_alloc>
		return r;
  80293c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80293e:	85 c0                	test   %eax,%eax
  802940:	78 40                	js     802982 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802942:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802949:	00 
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802951:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802958:	e8 56 e4 ff ff       	call   800db3 <sys_page_alloc>
		return r;
  80295d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80295f:	85 c0                	test   %eax,%eax
  802961:	78 1f                	js     802982 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802963:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802978:	89 04 24             	mov    %eax,(%esp)
  80297b:	e8 b0 ec ff ff       	call   801630 <fd2num>
  802980:	89 c2                	mov    %eax,%edx
}
  802982:	89 d0                	mov    %edx,%eax
  802984:	c9                   	leave  
  802985:	c3                   	ret    

00802986 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802986:	55                   	push   %ebp
  802987:	89 e5                	mov    %esp,%ebp
  802989:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80298c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802993:	75 68                	jne    8029fd <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  802995:	a1 08 50 80 00       	mov    0x805008,%eax
  80299a:	8b 40 48             	mov    0x48(%eax),%eax
  80299d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8029a4:	00 
  8029a5:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8029ac:	ee 
  8029ad:	89 04 24             	mov    %eax,(%esp)
  8029b0:	e8 fe e3 ff ff       	call   800db3 <sys_page_alloc>
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	74 2c                	je     8029e5 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  8029b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029bd:	c7 04 24 44 33 80 00 	movl   $0x803344,(%esp)
  8029c4:	e8 a9 d9 ff ff       	call   800372 <cprintf>
			panic("set_pg_fault_handler");
  8029c9:	c7 44 24 08 78 33 80 	movl   $0x803378,0x8(%esp)
  8029d0:	00 
  8029d1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8029d8:	00 
  8029d9:	c7 04 24 8d 33 80 00 	movl   $0x80338d,(%esp)
  8029e0:	e8 94 d8 ff ff       	call   800279 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  8029e5:	a1 08 50 80 00       	mov    0x805008,%eax
  8029ea:	8b 40 48             	mov    0x48(%eax),%eax
  8029ed:	c7 44 24 04 07 2a 80 	movl   $0x802a07,0x4(%esp)
  8029f4:	00 
  8029f5:	89 04 24             	mov    %eax,(%esp)
  8029f8:	e8 56 e5 ff ff       	call   800f53 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802a05:	c9                   	leave  
  802a06:	c3                   	ret    

00802a07 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a07:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a08:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802a0d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a0f:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  802a12:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  802a16:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  802a18:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  802a1c:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  802a1d:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  802a20:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  802a22:	58                   	pop    %eax
	popl %eax
  802a23:	58                   	pop    %eax
	popal
  802a24:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802a25:	83 c4 04             	add    $0x4,%esp
	popfl
  802a28:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a29:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802a2a:	c3                   	ret    
  802a2b:	66 90                	xchg   %ax,%ax
  802a2d:	66 90                	xchg   %ax,%ax
  802a2f:	90                   	nop

00802a30 <__udivdi3>:
  802a30:	55                   	push   %ebp
  802a31:	57                   	push   %edi
  802a32:	56                   	push   %esi
  802a33:	83 ec 0c             	sub    $0xc,%esp
  802a36:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a3a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802a3e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802a42:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a46:	85 c0                	test   %eax,%eax
  802a48:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802a4c:	89 ea                	mov    %ebp,%edx
  802a4e:	89 0c 24             	mov    %ecx,(%esp)
  802a51:	75 2d                	jne    802a80 <__udivdi3+0x50>
  802a53:	39 e9                	cmp    %ebp,%ecx
  802a55:	77 61                	ja     802ab8 <__udivdi3+0x88>
  802a57:	85 c9                	test   %ecx,%ecx
  802a59:	89 ce                	mov    %ecx,%esi
  802a5b:	75 0b                	jne    802a68 <__udivdi3+0x38>
  802a5d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a62:	31 d2                	xor    %edx,%edx
  802a64:	f7 f1                	div    %ecx
  802a66:	89 c6                	mov    %eax,%esi
  802a68:	31 d2                	xor    %edx,%edx
  802a6a:	89 e8                	mov    %ebp,%eax
  802a6c:	f7 f6                	div    %esi
  802a6e:	89 c5                	mov    %eax,%ebp
  802a70:	89 f8                	mov    %edi,%eax
  802a72:	f7 f6                	div    %esi
  802a74:	89 ea                	mov    %ebp,%edx
  802a76:	83 c4 0c             	add    $0xc,%esp
  802a79:	5e                   	pop    %esi
  802a7a:	5f                   	pop    %edi
  802a7b:	5d                   	pop    %ebp
  802a7c:	c3                   	ret    
  802a7d:	8d 76 00             	lea    0x0(%esi),%esi
  802a80:	39 e8                	cmp    %ebp,%eax
  802a82:	77 24                	ja     802aa8 <__udivdi3+0x78>
  802a84:	0f bd e8             	bsr    %eax,%ebp
  802a87:	83 f5 1f             	xor    $0x1f,%ebp
  802a8a:	75 3c                	jne    802ac8 <__udivdi3+0x98>
  802a8c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802a90:	39 34 24             	cmp    %esi,(%esp)
  802a93:	0f 86 9f 00 00 00    	jbe    802b38 <__udivdi3+0x108>
  802a99:	39 d0                	cmp    %edx,%eax
  802a9b:	0f 82 97 00 00 00    	jb     802b38 <__udivdi3+0x108>
  802aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802aa8:	31 d2                	xor    %edx,%edx
  802aaa:	31 c0                	xor    %eax,%eax
  802aac:	83 c4 0c             	add    $0xc,%esp
  802aaf:	5e                   	pop    %esi
  802ab0:	5f                   	pop    %edi
  802ab1:	5d                   	pop    %ebp
  802ab2:	c3                   	ret    
  802ab3:	90                   	nop
  802ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ab8:	89 f8                	mov    %edi,%eax
  802aba:	f7 f1                	div    %ecx
  802abc:	31 d2                	xor    %edx,%edx
  802abe:	83 c4 0c             	add    $0xc,%esp
  802ac1:	5e                   	pop    %esi
  802ac2:	5f                   	pop    %edi
  802ac3:	5d                   	pop    %ebp
  802ac4:	c3                   	ret    
  802ac5:	8d 76 00             	lea    0x0(%esi),%esi
  802ac8:	89 e9                	mov    %ebp,%ecx
  802aca:	8b 3c 24             	mov    (%esp),%edi
  802acd:	d3 e0                	shl    %cl,%eax
  802acf:	89 c6                	mov    %eax,%esi
  802ad1:	b8 20 00 00 00       	mov    $0x20,%eax
  802ad6:	29 e8                	sub    %ebp,%eax
  802ad8:	89 c1                	mov    %eax,%ecx
  802ada:	d3 ef                	shr    %cl,%edi
  802adc:	89 e9                	mov    %ebp,%ecx
  802ade:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802ae2:	8b 3c 24             	mov    (%esp),%edi
  802ae5:	09 74 24 08          	or     %esi,0x8(%esp)
  802ae9:	89 d6                	mov    %edx,%esi
  802aeb:	d3 e7                	shl    %cl,%edi
  802aed:	89 c1                	mov    %eax,%ecx
  802aef:	89 3c 24             	mov    %edi,(%esp)
  802af2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802af6:	d3 ee                	shr    %cl,%esi
  802af8:	89 e9                	mov    %ebp,%ecx
  802afa:	d3 e2                	shl    %cl,%edx
  802afc:	89 c1                	mov    %eax,%ecx
  802afe:	d3 ef                	shr    %cl,%edi
  802b00:	09 d7                	or     %edx,%edi
  802b02:	89 f2                	mov    %esi,%edx
  802b04:	89 f8                	mov    %edi,%eax
  802b06:	f7 74 24 08          	divl   0x8(%esp)
  802b0a:	89 d6                	mov    %edx,%esi
  802b0c:	89 c7                	mov    %eax,%edi
  802b0e:	f7 24 24             	mull   (%esp)
  802b11:	39 d6                	cmp    %edx,%esi
  802b13:	89 14 24             	mov    %edx,(%esp)
  802b16:	72 30                	jb     802b48 <__udivdi3+0x118>
  802b18:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b1c:	89 e9                	mov    %ebp,%ecx
  802b1e:	d3 e2                	shl    %cl,%edx
  802b20:	39 c2                	cmp    %eax,%edx
  802b22:	73 05                	jae    802b29 <__udivdi3+0xf9>
  802b24:	3b 34 24             	cmp    (%esp),%esi
  802b27:	74 1f                	je     802b48 <__udivdi3+0x118>
  802b29:	89 f8                	mov    %edi,%eax
  802b2b:	31 d2                	xor    %edx,%edx
  802b2d:	e9 7a ff ff ff       	jmp    802aac <__udivdi3+0x7c>
  802b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b38:	31 d2                	xor    %edx,%edx
  802b3a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b3f:	e9 68 ff ff ff       	jmp    802aac <__udivdi3+0x7c>
  802b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b48:	8d 47 ff             	lea    -0x1(%edi),%eax
  802b4b:	31 d2                	xor    %edx,%edx
  802b4d:	83 c4 0c             	add    $0xc,%esp
  802b50:	5e                   	pop    %esi
  802b51:	5f                   	pop    %edi
  802b52:	5d                   	pop    %ebp
  802b53:	c3                   	ret    
  802b54:	66 90                	xchg   %ax,%ax
  802b56:	66 90                	xchg   %ax,%ax
  802b58:	66 90                	xchg   %ax,%ax
  802b5a:	66 90                	xchg   %ax,%ax
  802b5c:	66 90                	xchg   %ax,%ax
  802b5e:	66 90                	xchg   %ax,%ax

00802b60 <__umoddi3>:
  802b60:	55                   	push   %ebp
  802b61:	57                   	push   %edi
  802b62:	56                   	push   %esi
  802b63:	83 ec 14             	sub    $0x14,%esp
  802b66:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b6a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b6e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802b72:	89 c7                	mov    %eax,%edi
  802b74:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b78:	8b 44 24 30          	mov    0x30(%esp),%eax
  802b7c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802b80:	89 34 24             	mov    %esi,(%esp)
  802b83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b87:	85 c0                	test   %eax,%eax
  802b89:	89 c2                	mov    %eax,%edx
  802b8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b8f:	75 17                	jne    802ba8 <__umoddi3+0x48>
  802b91:	39 fe                	cmp    %edi,%esi
  802b93:	76 4b                	jbe    802be0 <__umoddi3+0x80>
  802b95:	89 c8                	mov    %ecx,%eax
  802b97:	89 fa                	mov    %edi,%edx
  802b99:	f7 f6                	div    %esi
  802b9b:	89 d0                	mov    %edx,%eax
  802b9d:	31 d2                	xor    %edx,%edx
  802b9f:	83 c4 14             	add    $0x14,%esp
  802ba2:	5e                   	pop    %esi
  802ba3:	5f                   	pop    %edi
  802ba4:	5d                   	pop    %ebp
  802ba5:	c3                   	ret    
  802ba6:	66 90                	xchg   %ax,%ax
  802ba8:	39 f8                	cmp    %edi,%eax
  802baa:	77 54                	ja     802c00 <__umoddi3+0xa0>
  802bac:	0f bd e8             	bsr    %eax,%ebp
  802baf:	83 f5 1f             	xor    $0x1f,%ebp
  802bb2:	75 5c                	jne    802c10 <__umoddi3+0xb0>
  802bb4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802bb8:	39 3c 24             	cmp    %edi,(%esp)
  802bbb:	0f 87 e7 00 00 00    	ja     802ca8 <__umoddi3+0x148>
  802bc1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802bc5:	29 f1                	sub    %esi,%ecx
  802bc7:	19 c7                	sbb    %eax,%edi
  802bc9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bcd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bd1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bd5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802bd9:	83 c4 14             	add    $0x14,%esp
  802bdc:	5e                   	pop    %esi
  802bdd:	5f                   	pop    %edi
  802bde:	5d                   	pop    %ebp
  802bdf:	c3                   	ret    
  802be0:	85 f6                	test   %esi,%esi
  802be2:	89 f5                	mov    %esi,%ebp
  802be4:	75 0b                	jne    802bf1 <__umoddi3+0x91>
  802be6:	b8 01 00 00 00       	mov    $0x1,%eax
  802beb:	31 d2                	xor    %edx,%edx
  802bed:	f7 f6                	div    %esi
  802bef:	89 c5                	mov    %eax,%ebp
  802bf1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802bf5:	31 d2                	xor    %edx,%edx
  802bf7:	f7 f5                	div    %ebp
  802bf9:	89 c8                	mov    %ecx,%eax
  802bfb:	f7 f5                	div    %ebp
  802bfd:	eb 9c                	jmp    802b9b <__umoddi3+0x3b>
  802bff:	90                   	nop
  802c00:	89 c8                	mov    %ecx,%eax
  802c02:	89 fa                	mov    %edi,%edx
  802c04:	83 c4 14             	add    $0x14,%esp
  802c07:	5e                   	pop    %esi
  802c08:	5f                   	pop    %edi
  802c09:	5d                   	pop    %ebp
  802c0a:	c3                   	ret    
  802c0b:	90                   	nop
  802c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c10:	8b 04 24             	mov    (%esp),%eax
  802c13:	be 20 00 00 00       	mov    $0x20,%esi
  802c18:	89 e9                	mov    %ebp,%ecx
  802c1a:	29 ee                	sub    %ebp,%esi
  802c1c:	d3 e2                	shl    %cl,%edx
  802c1e:	89 f1                	mov    %esi,%ecx
  802c20:	d3 e8                	shr    %cl,%eax
  802c22:	89 e9                	mov    %ebp,%ecx
  802c24:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c28:	8b 04 24             	mov    (%esp),%eax
  802c2b:	09 54 24 04          	or     %edx,0x4(%esp)
  802c2f:	89 fa                	mov    %edi,%edx
  802c31:	d3 e0                	shl    %cl,%eax
  802c33:	89 f1                	mov    %esi,%ecx
  802c35:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c39:	8b 44 24 10          	mov    0x10(%esp),%eax
  802c3d:	d3 ea                	shr    %cl,%edx
  802c3f:	89 e9                	mov    %ebp,%ecx
  802c41:	d3 e7                	shl    %cl,%edi
  802c43:	89 f1                	mov    %esi,%ecx
  802c45:	d3 e8                	shr    %cl,%eax
  802c47:	89 e9                	mov    %ebp,%ecx
  802c49:	09 f8                	or     %edi,%eax
  802c4b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802c4f:	f7 74 24 04          	divl   0x4(%esp)
  802c53:	d3 e7                	shl    %cl,%edi
  802c55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c59:	89 d7                	mov    %edx,%edi
  802c5b:	f7 64 24 08          	mull   0x8(%esp)
  802c5f:	39 d7                	cmp    %edx,%edi
  802c61:	89 c1                	mov    %eax,%ecx
  802c63:	89 14 24             	mov    %edx,(%esp)
  802c66:	72 2c                	jb     802c94 <__umoddi3+0x134>
  802c68:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802c6c:	72 22                	jb     802c90 <__umoddi3+0x130>
  802c6e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802c72:	29 c8                	sub    %ecx,%eax
  802c74:	19 d7                	sbb    %edx,%edi
  802c76:	89 e9                	mov    %ebp,%ecx
  802c78:	89 fa                	mov    %edi,%edx
  802c7a:	d3 e8                	shr    %cl,%eax
  802c7c:	89 f1                	mov    %esi,%ecx
  802c7e:	d3 e2                	shl    %cl,%edx
  802c80:	89 e9                	mov    %ebp,%ecx
  802c82:	d3 ef                	shr    %cl,%edi
  802c84:	09 d0                	or     %edx,%eax
  802c86:	89 fa                	mov    %edi,%edx
  802c88:	83 c4 14             	add    $0x14,%esp
  802c8b:	5e                   	pop    %esi
  802c8c:	5f                   	pop    %edi
  802c8d:	5d                   	pop    %ebp
  802c8e:	c3                   	ret    
  802c8f:	90                   	nop
  802c90:	39 d7                	cmp    %edx,%edi
  802c92:	75 da                	jne    802c6e <__umoddi3+0x10e>
  802c94:	8b 14 24             	mov    (%esp),%edx
  802c97:	89 c1                	mov    %eax,%ecx
  802c99:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802c9d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802ca1:	eb cb                	jmp    802c6e <__umoddi3+0x10e>
  802ca3:	90                   	nop
  802ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ca8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802cac:	0f 82 0f ff ff ff    	jb     802bc1 <__umoddi3+0x61>
  802cb2:	e9 1a ff ff ff       	jmp    802bd1 <__umoddi3+0x71>
