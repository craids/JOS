
obj/user/testtime.debug:     file format elf32-i386


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
  80002c:	e8 e5 00 00 00       	call   800116 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	53                   	push   %ebx
  800044:	83 ec 14             	sub    $0x14,%esp
	unsigned now = sys_time_msec();
  800047:	e8 cf 0e 00 00       	call   800f1b <sys_time_msec>
	unsigned end = now + sec * 1000;
  80004c:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx
  800053:	01 c3                	add    %eax,%ebx

	if ((int)now < 0 && (int)now > -MAXERROR)
  800055:	83 f8 ef             	cmp    $0xffffffef,%eax
  800058:	7c 29                	jl     800083 <sleep+0x43>
  80005a:	89 c2                	mov    %eax,%edx
  80005c:	c1 ea 1f             	shr    $0x1f,%edx
  80005f:	84 d2                	test   %dl,%dl
  800061:	74 20                	je     800083 <sleep+0x43>
		panic("sys_time_msec: %e", (int)now);
  800063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800067:	c7 44 24 08 20 27 80 	movl   $0x802720,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 32 27 80 00 	movl   $0x802732,(%esp)
  80007e:	e8 f4 00 00 00       	call   800177 <_panic>
	if (end < now)
  800083:	39 d8                	cmp    %ebx,%eax
  800085:	76 21                	jbe    8000a8 <sleep+0x68>
		panic("sleep: wrap");
  800087:	c7 44 24 08 42 27 80 	movl   $0x802742,0x8(%esp)
  80008e:	00 
  80008f:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800096:	00 
  800097:	c7 04 24 32 27 80 00 	movl   $0x802732,(%esp)
  80009e:	e8 d4 00 00 00       	call   800177 <_panic>

	while (sys_time_msec() < end)
		sys_yield();
  8000a3:	e8 ec 0b 00 00       	call   800c94 <sys_yield>
	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  8000a8:	e8 6e 0e 00 00       	call   800f1b <sys_time_msec>
  8000ad:	39 c3                	cmp    %eax,%ebx
  8000af:	90                   	nop
  8000b0:	77 f1                	ja     8000a3 <sleep+0x63>
		sys_yield();
}
  8000b2:	83 c4 14             	add    $0x14,%esp
  8000b5:	5b                   	pop    %ebx
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <umain>:

void
umain(int argc, char **argv)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	53                   	push   %ebx
  8000bc:	83 ec 14             	sub    $0x14,%esp
  8000bf:	bb 32 00 00 00       	mov    $0x32,%ebx
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();
  8000c4:	e8 cb 0b 00 00       	call   800c94 <sys_yield>
umain(int argc, char **argv)
{
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  8000c9:	83 eb 01             	sub    $0x1,%ebx
  8000cc:	75 f6                	jne    8000c4 <umain+0xc>
		sys_yield();

	cprintf("starting count down: ");
  8000ce:	c7 04 24 4e 27 80 00 	movl   $0x80274e,(%esp)
  8000d5:	e8 96 01 00 00       	call   800270 <cprintf>
	for (i = 5; i >= 0; i--) {
  8000da:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  8000df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000e3:	c7 04 24 64 27 80 00 	movl   $0x802764,(%esp)
  8000ea:	e8 81 01 00 00       	call   800270 <cprintf>
		sleep(1);
  8000ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000f6:	e8 45 ff ff ff       	call   800040 <sleep>
	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();

	cprintf("starting count down: ");
	for (i = 5; i >= 0; i--) {
  8000fb:	83 eb 01             	sub    $0x1,%ebx
  8000fe:	83 fb ff             	cmp    $0xffffffff,%ebx
  800101:	75 dc                	jne    8000df <umain+0x27>
		cprintf("%d ", i);
		sleep(1);
	}
	cprintf("\n");
  800103:	c7 04 24 ec 2b 80 00 	movl   $0x802bec,(%esp)
  80010a:	e8 61 01 00 00       	call   800270 <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80010f:	cc                   	int3   
	breakpoint();
}
  800110:	83 c4 14             	add    $0x14,%esp
  800113:	5b                   	pop    %ebx
  800114:	5d                   	pop    %ebp
  800115:	c3                   	ret    

00800116 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	56                   	push   %esi
  80011a:	53                   	push   %ebx
  80011b:	83 ec 10             	sub    $0x10,%esp
  80011e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800121:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800124:	e8 4c 0b 00 00       	call   800c75 <sys_getenvid>
  800129:	25 ff 03 00 00       	and    $0x3ff,%eax
  80012e:	c1 e0 07             	shl    $0x7,%eax
  800131:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800136:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013b:	85 db                	test   %ebx,%ebx
  80013d:	7e 07                	jle    800146 <libmain+0x30>
		binaryname = argv[0];
  80013f:	8b 06                	mov    (%esi),%eax
  800141:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800146:	89 74 24 04          	mov    %esi,0x4(%esp)
  80014a:	89 1c 24             	mov    %ebx,(%esp)
  80014d:	e8 66 ff ff ff       	call   8000b8 <umain>

	// exit gracefully
	exit();
  800152:	e8 07 00 00 00       	call   80015e <exit>
}
  800157:	83 c4 10             	add    $0x10,%esp
  80015a:	5b                   	pop    %ebx
  80015b:	5e                   	pop    %esi
  80015c:	5d                   	pop    %ebp
  80015d:	c3                   	ret    

0080015e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800164:	e8 71 10 00 00       	call   8011da <close_all>
	sys_env_destroy(0);
  800169:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800170:	e8 ae 0a 00 00       	call   800c23 <sys_env_destroy>
}
  800175:	c9                   	leave  
  800176:	c3                   	ret    

00800177 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	56                   	push   %esi
  80017b:	53                   	push   %ebx
  80017c:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80017f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800182:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800188:	e8 e8 0a 00 00       	call   800c75 <sys_getenvid>
  80018d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800190:	89 54 24 10          	mov    %edx,0x10(%esp)
  800194:	8b 55 08             	mov    0x8(%ebp),%edx
  800197:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80019b:	89 74 24 08          	mov    %esi,0x8(%esp)
  80019f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a3:	c7 04 24 74 27 80 00 	movl   $0x802774,(%esp)
  8001aa:	e8 c1 00 00 00       	call   800270 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8001b6:	89 04 24             	mov    %eax,(%esp)
  8001b9:	e8 51 00 00 00       	call   80020f <vcprintf>
	cprintf("\n");
  8001be:	c7 04 24 ec 2b 80 00 	movl   $0x802bec,(%esp)
  8001c5:	e8 a6 00 00 00       	call   800270 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001ca:	cc                   	int3   
  8001cb:	eb fd                	jmp    8001ca <_panic+0x53>

008001cd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001cd:	55                   	push   %ebp
  8001ce:	89 e5                	mov    %esp,%ebp
  8001d0:	53                   	push   %ebx
  8001d1:	83 ec 14             	sub    $0x14,%esp
  8001d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d7:	8b 13                	mov    (%ebx),%edx
  8001d9:	8d 42 01             	lea    0x1(%edx),%eax
  8001dc:	89 03                	mov    %eax,(%ebx)
  8001de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ea:	75 19                	jne    800205 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001ec:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001f3:	00 
  8001f4:	8d 43 08             	lea    0x8(%ebx),%eax
  8001f7:	89 04 24             	mov    %eax,(%esp)
  8001fa:	e8 e7 09 00 00       	call   800be6 <sys_cputs>
		b->idx = 0;
  8001ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800205:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800209:	83 c4 14             	add    $0x14,%esp
  80020c:	5b                   	pop    %ebx
  80020d:	5d                   	pop    %ebp
  80020e:	c3                   	ret    

0080020f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800218:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80021f:	00 00 00 
	b.cnt = 0;
  800222:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800229:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80022c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800233:	8b 45 08             	mov    0x8(%ebp),%eax
  800236:	89 44 24 08          	mov    %eax,0x8(%esp)
  80023a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800240:	89 44 24 04          	mov    %eax,0x4(%esp)
  800244:	c7 04 24 cd 01 80 00 	movl   $0x8001cd,(%esp)
  80024b:	e8 ae 01 00 00       	call   8003fe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800250:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800256:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800260:	89 04 24             	mov    %eax,(%esp)
  800263:	e8 7e 09 00 00       	call   800be6 <sys_cputs>

	return b.cnt;
}
  800268:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80026e:	c9                   	leave  
  80026f:	c3                   	ret    

00800270 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800276:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800279:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027d:	8b 45 08             	mov    0x8(%ebp),%eax
  800280:	89 04 24             	mov    %eax,(%esp)
  800283:	e8 87 ff ff ff       	call   80020f <vcprintf>
	va_end(ap);

	return cnt;
}
  800288:	c9                   	leave  
  800289:	c3                   	ret    
  80028a:	66 90                	xchg   %ax,%ax
  80028c:	66 90                	xchg   %ax,%ax
  80028e:	66 90                	xchg   %ax,%ax

00800290 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	57                   	push   %edi
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	83 ec 3c             	sub    $0x3c,%esp
  800299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80029c:	89 d7                	mov    %edx,%edi
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a7:	89 c3                	mov    %eax,%ebx
  8002a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8002af:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002bd:	39 d9                	cmp    %ebx,%ecx
  8002bf:	72 05                	jb     8002c6 <printnum+0x36>
  8002c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c4:	77 69                	ja     80032f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002c9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002cd:	83 ee 01             	sub    $0x1,%esi
  8002d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002dc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002e0:	89 c3                	mov    %eax,%ebx
  8002e2:	89 d6                	mov    %edx,%esi
  8002e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f5:	89 04 24             	mov    %eax,(%esp)
  8002f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ff:	e8 8c 21 00 00       	call   802490 <__udivdi3>
  800304:	89 d9                	mov    %ebx,%ecx
  800306:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80030a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80030e:	89 04 24             	mov    %eax,(%esp)
  800311:	89 54 24 04          	mov    %edx,0x4(%esp)
  800315:	89 fa                	mov    %edi,%edx
  800317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031a:	e8 71 ff ff ff       	call   800290 <printnum>
  80031f:	eb 1b                	jmp    80033c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800321:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800325:	8b 45 18             	mov    0x18(%ebp),%eax
  800328:	89 04 24             	mov    %eax,(%esp)
  80032b:	ff d3                	call   *%ebx
  80032d:	eb 03                	jmp    800332 <printnum+0xa2>
  80032f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800332:	83 ee 01             	sub    $0x1,%esi
  800335:	85 f6                	test   %esi,%esi
  800337:	7f e8                	jg     800321 <printnum+0x91>
  800339:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80033c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800340:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800344:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800347:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80034a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80034e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800352:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800355:	89 04 24             	mov    %eax,(%esp)
  800358:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035f:	e8 5c 22 00 00       	call   8025c0 <__umoddi3>
  800364:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800368:	0f be 80 97 27 80 00 	movsbl 0x802797(%eax),%eax
  80036f:	89 04 24             	mov    %eax,(%esp)
  800372:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800375:	ff d0                	call   *%eax
}
  800377:	83 c4 3c             	add    $0x3c,%esp
  80037a:	5b                   	pop    %ebx
  80037b:	5e                   	pop    %esi
  80037c:	5f                   	pop    %edi
  80037d:	5d                   	pop    %ebp
  80037e:	c3                   	ret    

0080037f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800382:	83 fa 01             	cmp    $0x1,%edx
  800385:	7e 0e                	jle    800395 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800387:	8b 10                	mov    (%eax),%edx
  800389:	8d 4a 08             	lea    0x8(%edx),%ecx
  80038c:	89 08                	mov    %ecx,(%eax)
  80038e:	8b 02                	mov    (%edx),%eax
  800390:	8b 52 04             	mov    0x4(%edx),%edx
  800393:	eb 22                	jmp    8003b7 <getuint+0x38>
	else if (lflag)
  800395:	85 d2                	test   %edx,%edx
  800397:	74 10                	je     8003a9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800399:	8b 10                	mov    (%eax),%edx
  80039b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80039e:	89 08                	mov    %ecx,(%eax)
  8003a0:	8b 02                	mov    (%edx),%eax
  8003a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a7:	eb 0e                	jmp    8003b7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003a9:	8b 10                	mov    (%eax),%edx
  8003ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ae:	89 08                	mov    %ecx,(%eax)
  8003b0:	8b 02                	mov    (%edx),%eax
  8003b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003b7:	5d                   	pop    %ebp
  8003b8:	c3                   	ret    

008003b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003b9:	55                   	push   %ebp
  8003ba:	89 e5                	mov    %esp,%ebp
  8003bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003bf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003c3:	8b 10                	mov    (%eax),%edx
  8003c5:	3b 50 04             	cmp    0x4(%eax),%edx
  8003c8:	73 0a                	jae    8003d4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003cd:	89 08                	mov    %ecx,(%eax)
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	88 02                	mov    %al,(%edx)
}
  8003d4:	5d                   	pop    %ebp
  8003d5:	c3                   	ret    

008003d6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
  8003d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003dc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	89 04 24             	mov    %eax,(%esp)
  8003f7:	e8 02 00 00 00       	call   8003fe <vprintfmt>
	va_end(ap);
}
  8003fc:	c9                   	leave  
  8003fd:	c3                   	ret    

008003fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	57                   	push   %edi
  800402:	56                   	push   %esi
  800403:	53                   	push   %ebx
  800404:	83 ec 3c             	sub    $0x3c,%esp
  800407:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80040a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80040d:	eb 14                	jmp    800423 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80040f:	85 c0                	test   %eax,%eax
  800411:	0f 84 b3 03 00 00    	je     8007ca <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800417:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80041b:	89 04 24             	mov    %eax,(%esp)
  80041e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800421:	89 f3                	mov    %esi,%ebx
  800423:	8d 73 01             	lea    0x1(%ebx),%esi
  800426:	0f b6 03             	movzbl (%ebx),%eax
  800429:	83 f8 25             	cmp    $0x25,%eax
  80042c:	75 e1                	jne    80040f <vprintfmt+0x11>
  80042e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800432:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800439:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800440:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800447:	ba 00 00 00 00       	mov    $0x0,%edx
  80044c:	eb 1d                	jmp    80046b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800450:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800454:	eb 15                	jmp    80046b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800456:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800458:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80045c:	eb 0d                	jmp    80046b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80045e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800461:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800464:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80046e:	0f b6 0e             	movzbl (%esi),%ecx
  800471:	0f b6 c1             	movzbl %cl,%eax
  800474:	83 e9 23             	sub    $0x23,%ecx
  800477:	80 f9 55             	cmp    $0x55,%cl
  80047a:	0f 87 2a 03 00 00    	ja     8007aa <vprintfmt+0x3ac>
  800480:	0f b6 c9             	movzbl %cl,%ecx
  800483:	ff 24 8d e0 28 80 00 	jmp    *0x8028e0(,%ecx,4)
  80048a:	89 de                	mov    %ebx,%esi
  80048c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800491:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800494:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800498:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80049b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80049e:	83 fb 09             	cmp    $0x9,%ebx
  8004a1:	77 36                	ja     8004d9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004a3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004a6:	eb e9                	jmp    800491 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	8d 48 04             	lea    0x4(%eax),%ecx
  8004ae:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004b8:	eb 22                	jmp    8004dc <vprintfmt+0xde>
  8004ba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004bd:	85 c9                	test   %ecx,%ecx
  8004bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c4:	0f 49 c1             	cmovns %ecx,%eax
  8004c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ca:	89 de                	mov    %ebx,%esi
  8004cc:	eb 9d                	jmp    80046b <vprintfmt+0x6d>
  8004ce:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004d0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8004d7:	eb 92                	jmp    80046b <vprintfmt+0x6d>
  8004d9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8004dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004e0:	79 89                	jns    80046b <vprintfmt+0x6d>
  8004e2:	e9 77 ff ff ff       	jmp    80045e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004e7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ea:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004ec:	e9 7a ff ff ff       	jmp    80046b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8d 50 04             	lea    0x4(%eax),%edx
  8004f7:	89 55 14             	mov    %edx,0x14(%ebp)
  8004fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	89 04 24             	mov    %eax,(%esp)
  800503:	ff 55 08             	call   *0x8(%ebp)
			break;
  800506:	e9 18 ff ff ff       	jmp    800423 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	8d 50 04             	lea    0x4(%eax),%edx
  800511:	89 55 14             	mov    %edx,0x14(%ebp)
  800514:	8b 00                	mov    (%eax),%eax
  800516:	99                   	cltd   
  800517:	31 d0                	xor    %edx,%eax
  800519:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051b:	83 f8 11             	cmp    $0x11,%eax
  80051e:	7f 0b                	jg     80052b <vprintfmt+0x12d>
  800520:	8b 14 85 40 2a 80 00 	mov    0x802a40(,%eax,4),%edx
  800527:	85 d2                	test   %edx,%edx
  800529:	75 20                	jne    80054b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80052b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80052f:	c7 44 24 08 af 27 80 	movl   $0x8027af,0x8(%esp)
  800536:	00 
  800537:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	89 04 24             	mov    %eax,(%esp)
  800541:	e8 90 fe ff ff       	call   8003d6 <printfmt>
  800546:	e9 d8 fe ff ff       	jmp    800423 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80054b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80054f:	c7 44 24 08 81 2b 80 	movl   $0x802b81,0x8(%esp)
  800556:	00 
  800557:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	89 04 24             	mov    %eax,(%esp)
  800561:	e8 70 fe ff ff       	call   8003d6 <printfmt>
  800566:	e9 b8 fe ff ff       	jmp    800423 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80056e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800571:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8d 50 04             	lea    0x4(%eax),%edx
  80057a:	89 55 14             	mov    %edx,0x14(%ebp)
  80057d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80057f:	85 f6                	test   %esi,%esi
  800581:	b8 a8 27 80 00       	mov    $0x8027a8,%eax
  800586:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800589:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80058d:	0f 84 97 00 00 00    	je     80062a <vprintfmt+0x22c>
  800593:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800597:	0f 8e 9b 00 00 00    	jle    800638 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80059d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005a1:	89 34 24             	mov    %esi,(%esp)
  8005a4:	e8 cf 02 00 00       	call   800878 <strnlen>
  8005a9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ac:	29 c2                	sub    %eax,%edx
  8005ae:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8005b1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005c1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c3:	eb 0f                	jmp    8005d4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8005c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005cc:	89 04 24             	mov    %eax,(%esp)
  8005cf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d1:	83 eb 01             	sub    $0x1,%ebx
  8005d4:	85 db                	test   %ebx,%ebx
  8005d6:	7f ed                	jg     8005c5 <vprintfmt+0x1c7>
  8005d8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005db:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005de:	85 d2                	test   %edx,%edx
  8005e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e5:	0f 49 c2             	cmovns %edx,%eax
  8005e8:	29 c2                	sub    %eax,%edx
  8005ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005ed:	89 d7                	mov    %edx,%edi
  8005ef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005f2:	eb 50                	jmp    800644 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f8:	74 1e                	je     800618 <vprintfmt+0x21a>
  8005fa:	0f be d2             	movsbl %dl,%edx
  8005fd:	83 ea 20             	sub    $0x20,%edx
  800600:	83 fa 5e             	cmp    $0x5e,%edx
  800603:	76 13                	jbe    800618 <vprintfmt+0x21a>
					putch('?', putdat);
  800605:	8b 45 0c             	mov    0xc(%ebp),%eax
  800608:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800613:	ff 55 08             	call   *0x8(%ebp)
  800616:	eb 0d                	jmp    800625 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800618:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80061f:	89 04 24             	mov    %eax,(%esp)
  800622:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800625:	83 ef 01             	sub    $0x1,%edi
  800628:	eb 1a                	jmp    800644 <vprintfmt+0x246>
  80062a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80062d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800630:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800633:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800636:	eb 0c                	jmp    800644 <vprintfmt+0x246>
  800638:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80063b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80063e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800641:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800644:	83 c6 01             	add    $0x1,%esi
  800647:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80064b:	0f be c2             	movsbl %dl,%eax
  80064e:	85 c0                	test   %eax,%eax
  800650:	74 27                	je     800679 <vprintfmt+0x27b>
  800652:	85 db                	test   %ebx,%ebx
  800654:	78 9e                	js     8005f4 <vprintfmt+0x1f6>
  800656:	83 eb 01             	sub    $0x1,%ebx
  800659:	79 99                	jns    8005f4 <vprintfmt+0x1f6>
  80065b:	89 f8                	mov    %edi,%eax
  80065d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800660:	8b 75 08             	mov    0x8(%ebp),%esi
  800663:	89 c3                	mov    %eax,%ebx
  800665:	eb 1a                	jmp    800681 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800667:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80066b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800672:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800674:	83 eb 01             	sub    $0x1,%ebx
  800677:	eb 08                	jmp    800681 <vprintfmt+0x283>
  800679:	89 fb                	mov    %edi,%ebx
  80067b:	8b 75 08             	mov    0x8(%ebp),%esi
  80067e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800681:	85 db                	test   %ebx,%ebx
  800683:	7f e2                	jg     800667 <vprintfmt+0x269>
  800685:	89 75 08             	mov    %esi,0x8(%ebp)
  800688:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80068b:	e9 93 fd ff ff       	jmp    800423 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800690:	83 fa 01             	cmp    $0x1,%edx
  800693:	7e 16                	jle    8006ab <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 50 08             	lea    0x8(%eax),%edx
  80069b:	89 55 14             	mov    %edx,0x14(%ebp)
  80069e:	8b 50 04             	mov    0x4(%eax),%edx
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006a9:	eb 32                	jmp    8006dd <vprintfmt+0x2df>
	else if (lflag)
  8006ab:	85 d2                	test   %edx,%edx
  8006ad:	74 18                	je     8006c7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8d 50 04             	lea    0x4(%eax),%edx
  8006b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b8:	8b 30                	mov    (%eax),%esi
  8006ba:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006bd:	89 f0                	mov    %esi,%eax
  8006bf:	c1 f8 1f             	sar    $0x1f,%eax
  8006c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006c5:	eb 16                	jmp    8006dd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8d 50 04             	lea    0x4(%eax),%edx
  8006cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d0:	8b 30                	mov    (%eax),%esi
  8006d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006d5:	89 f0                	mov    %esi,%eax
  8006d7:	c1 f8 1f             	sar    $0x1f,%eax
  8006da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ec:	0f 89 80 00 00 00    	jns    800772 <vprintfmt+0x374>
				putch('-', putdat);
  8006f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006fd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800703:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800706:	f7 d8                	neg    %eax
  800708:	83 d2 00             	adc    $0x0,%edx
  80070b:	f7 da                	neg    %edx
			}
			base = 10;
  80070d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800712:	eb 5e                	jmp    800772 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800714:	8d 45 14             	lea    0x14(%ebp),%eax
  800717:	e8 63 fc ff ff       	call   80037f <getuint>
			base = 10;
  80071c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800721:	eb 4f                	jmp    800772 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800723:	8d 45 14             	lea    0x14(%ebp),%eax
  800726:	e8 54 fc ff ff       	call   80037f <getuint>
			base = 8;
  80072b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800730:	eb 40                	jmp    800772 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800732:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800736:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80073d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800740:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800744:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80074b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8d 50 04             	lea    0x4(%eax),%edx
  800754:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800757:	8b 00                	mov    (%eax),%eax
  800759:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80075e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800763:	eb 0d                	jmp    800772 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800765:	8d 45 14             	lea    0x14(%ebp),%eax
  800768:	e8 12 fc ff ff       	call   80037f <getuint>
			base = 16;
  80076d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800772:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800776:	89 74 24 10          	mov    %esi,0x10(%esp)
  80077a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80077d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800781:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800785:	89 04 24             	mov    %eax,(%esp)
  800788:	89 54 24 04          	mov    %edx,0x4(%esp)
  80078c:	89 fa                	mov    %edi,%edx
  80078e:	8b 45 08             	mov    0x8(%ebp),%eax
  800791:	e8 fa fa ff ff       	call   800290 <printnum>
			break;
  800796:	e9 88 fc ff ff       	jmp    800423 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80079b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80079f:	89 04 24             	mov    %eax,(%esp)
  8007a2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007a5:	e9 79 fc ff ff       	jmp    800423 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ae:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007b5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007b8:	89 f3                	mov    %esi,%ebx
  8007ba:	eb 03                	jmp    8007bf <vprintfmt+0x3c1>
  8007bc:	83 eb 01             	sub    $0x1,%ebx
  8007bf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007c3:	75 f7                	jne    8007bc <vprintfmt+0x3be>
  8007c5:	e9 59 fc ff ff       	jmp    800423 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007ca:	83 c4 3c             	add    $0x3c,%esp
  8007cd:	5b                   	pop    %ebx
  8007ce:	5e                   	pop    %esi
  8007cf:	5f                   	pop    %edi
  8007d0:	5d                   	pop    %ebp
  8007d1:	c3                   	ret    

008007d2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	83 ec 28             	sub    $0x28,%esp
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007e1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007e5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ef:	85 c0                	test   %eax,%eax
  8007f1:	74 30                	je     800823 <vsnprintf+0x51>
  8007f3:	85 d2                	test   %edx,%edx
  8007f5:	7e 2c                	jle    800823 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800801:	89 44 24 08          	mov    %eax,0x8(%esp)
  800805:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800808:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080c:	c7 04 24 b9 03 80 00 	movl   $0x8003b9,(%esp)
  800813:	e8 e6 fb ff ff       	call   8003fe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800818:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80081e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800821:	eb 05                	jmp    800828 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800823:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800828:	c9                   	leave  
  800829:	c3                   	ret    

0080082a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800830:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800833:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800837:	8b 45 10             	mov    0x10(%ebp),%eax
  80083a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80083e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800841:	89 44 24 04          	mov    %eax,0x4(%esp)
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	89 04 24             	mov    %eax,(%esp)
  80084b:	e8 82 ff ff ff       	call   8007d2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800850:	c9                   	leave  
  800851:	c3                   	ret    
  800852:	66 90                	xchg   %ax,%ax
  800854:	66 90                	xchg   %ax,%ax
  800856:	66 90                	xchg   %ax,%ax
  800858:	66 90                	xchg   %ax,%ax
  80085a:	66 90                	xchg   %ax,%ax
  80085c:	66 90                	xchg   %ax,%ax
  80085e:	66 90                	xchg   %ax,%ax

00800860 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800866:	b8 00 00 00 00       	mov    $0x0,%eax
  80086b:	eb 03                	jmp    800870 <strlen+0x10>
		n++;
  80086d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800870:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800874:	75 f7                	jne    80086d <strlen+0xd>
		n++;
	return n;
}
  800876:	5d                   	pop    %ebp
  800877:	c3                   	ret    

00800878 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800881:	b8 00 00 00 00       	mov    $0x0,%eax
  800886:	eb 03                	jmp    80088b <strnlen+0x13>
		n++;
  800888:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80088b:	39 d0                	cmp    %edx,%eax
  80088d:	74 06                	je     800895 <strnlen+0x1d>
  80088f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800893:	75 f3                	jne    800888 <strnlen+0x10>
		n++;
	return n;
}
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	53                   	push   %ebx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008a1:	89 c2                	mov    %eax,%edx
  8008a3:	83 c2 01             	add    $0x1,%edx
  8008a6:	83 c1 01             	add    $0x1,%ecx
  8008a9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008ad:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008b0:	84 db                	test   %bl,%bl
  8008b2:	75 ef                	jne    8008a3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008b4:	5b                   	pop    %ebx
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	53                   	push   %ebx
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c1:	89 1c 24             	mov    %ebx,(%esp)
  8008c4:	e8 97 ff ff ff       	call   800860 <strlen>
	strcpy(dst + len, src);
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008d0:	01 d8                	add    %ebx,%eax
  8008d2:	89 04 24             	mov    %eax,(%esp)
  8008d5:	e8 bd ff ff ff       	call   800897 <strcpy>
	return dst;
}
  8008da:	89 d8                	mov    %ebx,%eax
  8008dc:	83 c4 08             	add    $0x8,%esp
  8008df:	5b                   	pop    %ebx
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	56                   	push   %esi
  8008e6:	53                   	push   %ebx
  8008e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ed:	89 f3                	mov    %esi,%ebx
  8008ef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f2:	89 f2                	mov    %esi,%edx
  8008f4:	eb 0f                	jmp    800905 <strncpy+0x23>
		*dst++ = *src;
  8008f6:	83 c2 01             	add    $0x1,%edx
  8008f9:	0f b6 01             	movzbl (%ecx),%eax
  8008fc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ff:	80 39 01             	cmpb   $0x1,(%ecx)
  800902:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800905:	39 da                	cmp    %ebx,%edx
  800907:	75 ed                	jne    8008f6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800909:	89 f0                	mov    %esi,%eax
  80090b:	5b                   	pop    %ebx
  80090c:	5e                   	pop    %esi
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	56                   	push   %esi
  800913:	53                   	push   %ebx
  800914:	8b 75 08             	mov    0x8(%ebp),%esi
  800917:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80091d:	89 f0                	mov    %esi,%eax
  80091f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800923:	85 c9                	test   %ecx,%ecx
  800925:	75 0b                	jne    800932 <strlcpy+0x23>
  800927:	eb 1d                	jmp    800946 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800929:	83 c0 01             	add    $0x1,%eax
  80092c:	83 c2 01             	add    $0x1,%edx
  80092f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800932:	39 d8                	cmp    %ebx,%eax
  800934:	74 0b                	je     800941 <strlcpy+0x32>
  800936:	0f b6 0a             	movzbl (%edx),%ecx
  800939:	84 c9                	test   %cl,%cl
  80093b:	75 ec                	jne    800929 <strlcpy+0x1a>
  80093d:	89 c2                	mov    %eax,%edx
  80093f:	eb 02                	jmp    800943 <strlcpy+0x34>
  800941:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800943:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800946:	29 f0                	sub    %esi,%eax
}
  800948:	5b                   	pop    %ebx
  800949:	5e                   	pop    %esi
  80094a:	5d                   	pop    %ebp
  80094b:	c3                   	ret    

0080094c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800952:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800955:	eb 06                	jmp    80095d <strcmp+0x11>
		p++, q++;
  800957:	83 c1 01             	add    $0x1,%ecx
  80095a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80095d:	0f b6 01             	movzbl (%ecx),%eax
  800960:	84 c0                	test   %al,%al
  800962:	74 04                	je     800968 <strcmp+0x1c>
  800964:	3a 02                	cmp    (%edx),%al
  800966:	74 ef                	je     800957 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800968:	0f b6 c0             	movzbl %al,%eax
  80096b:	0f b6 12             	movzbl (%edx),%edx
  80096e:	29 d0                	sub    %edx,%eax
}
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	53                   	push   %ebx
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097c:	89 c3                	mov    %eax,%ebx
  80097e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800981:	eb 06                	jmp    800989 <strncmp+0x17>
		n--, p++, q++;
  800983:	83 c0 01             	add    $0x1,%eax
  800986:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800989:	39 d8                	cmp    %ebx,%eax
  80098b:	74 15                	je     8009a2 <strncmp+0x30>
  80098d:	0f b6 08             	movzbl (%eax),%ecx
  800990:	84 c9                	test   %cl,%cl
  800992:	74 04                	je     800998 <strncmp+0x26>
  800994:	3a 0a                	cmp    (%edx),%cl
  800996:	74 eb                	je     800983 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800998:	0f b6 00             	movzbl (%eax),%eax
  80099b:	0f b6 12             	movzbl (%edx),%edx
  80099e:	29 d0                	sub    %edx,%eax
  8009a0:	eb 05                	jmp    8009a7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009a2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009a7:	5b                   	pop    %ebx
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b4:	eb 07                	jmp    8009bd <strchr+0x13>
		if (*s == c)
  8009b6:	38 ca                	cmp    %cl,%dl
  8009b8:	74 0f                	je     8009c9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009ba:	83 c0 01             	add    $0x1,%eax
  8009bd:	0f b6 10             	movzbl (%eax),%edx
  8009c0:	84 d2                	test   %dl,%dl
  8009c2:	75 f2                	jne    8009b6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009d5:	eb 07                	jmp    8009de <strfind+0x13>
		if (*s == c)
  8009d7:	38 ca                	cmp    %cl,%dl
  8009d9:	74 0a                	je     8009e5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009db:	83 c0 01             	add    $0x1,%eax
  8009de:	0f b6 10             	movzbl (%eax),%edx
  8009e1:	84 d2                	test   %dl,%dl
  8009e3:	75 f2                	jne    8009d7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    

008009e7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	57                   	push   %edi
  8009eb:	56                   	push   %esi
  8009ec:	53                   	push   %ebx
  8009ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009f3:	85 c9                	test   %ecx,%ecx
  8009f5:	74 36                	je     800a2d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009f7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009fd:	75 28                	jne    800a27 <memset+0x40>
  8009ff:	f6 c1 03             	test   $0x3,%cl
  800a02:	75 23                	jne    800a27 <memset+0x40>
		c &= 0xFF;
  800a04:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a08:	89 d3                	mov    %edx,%ebx
  800a0a:	c1 e3 08             	shl    $0x8,%ebx
  800a0d:	89 d6                	mov    %edx,%esi
  800a0f:	c1 e6 18             	shl    $0x18,%esi
  800a12:	89 d0                	mov    %edx,%eax
  800a14:	c1 e0 10             	shl    $0x10,%eax
  800a17:	09 f0                	or     %esi,%eax
  800a19:	09 c2                	or     %eax,%edx
  800a1b:	89 d0                	mov    %edx,%eax
  800a1d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a1f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a22:	fc                   	cld    
  800a23:	f3 ab                	rep stos %eax,%es:(%edi)
  800a25:	eb 06                	jmp    800a2d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	fc                   	cld    
  800a2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a2d:	89 f8                	mov    %edi,%eax
  800a2f:	5b                   	pop    %ebx
  800a30:	5e                   	pop    %esi
  800a31:	5f                   	pop    %edi
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	57                   	push   %edi
  800a38:	56                   	push   %esi
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a42:	39 c6                	cmp    %eax,%esi
  800a44:	73 35                	jae    800a7b <memmove+0x47>
  800a46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a49:	39 d0                	cmp    %edx,%eax
  800a4b:	73 2e                	jae    800a7b <memmove+0x47>
		s += n;
		d += n;
  800a4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a50:	89 d6                	mov    %edx,%esi
  800a52:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a54:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a5a:	75 13                	jne    800a6f <memmove+0x3b>
  800a5c:	f6 c1 03             	test   $0x3,%cl
  800a5f:	75 0e                	jne    800a6f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a61:	83 ef 04             	sub    $0x4,%edi
  800a64:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a67:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a6a:	fd                   	std    
  800a6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a6d:	eb 09                	jmp    800a78 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a6f:	83 ef 01             	sub    $0x1,%edi
  800a72:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a75:	fd                   	std    
  800a76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a78:	fc                   	cld    
  800a79:	eb 1d                	jmp    800a98 <memmove+0x64>
  800a7b:	89 f2                	mov    %esi,%edx
  800a7d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7f:	f6 c2 03             	test   $0x3,%dl
  800a82:	75 0f                	jne    800a93 <memmove+0x5f>
  800a84:	f6 c1 03             	test   $0x3,%cl
  800a87:	75 0a                	jne    800a93 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a89:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a8c:	89 c7                	mov    %eax,%edi
  800a8e:	fc                   	cld    
  800a8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a91:	eb 05                	jmp    800a98 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a93:	89 c7                	mov    %eax,%edi
  800a95:	fc                   	cld    
  800a96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a98:	5e                   	pop    %esi
  800a99:	5f                   	pop    %edi
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aa2:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	89 04 24             	mov    %eax,(%esp)
  800ab6:	e8 79 ff ff ff       	call   800a34 <memmove>
}
  800abb:	c9                   	leave  
  800abc:	c3                   	ret    

00800abd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	56                   	push   %esi
  800ac1:	53                   	push   %ebx
  800ac2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac8:	89 d6                	mov    %edx,%esi
  800aca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800acd:	eb 1a                	jmp    800ae9 <memcmp+0x2c>
		if (*s1 != *s2)
  800acf:	0f b6 02             	movzbl (%edx),%eax
  800ad2:	0f b6 19             	movzbl (%ecx),%ebx
  800ad5:	38 d8                	cmp    %bl,%al
  800ad7:	74 0a                	je     800ae3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ad9:	0f b6 c0             	movzbl %al,%eax
  800adc:	0f b6 db             	movzbl %bl,%ebx
  800adf:	29 d8                	sub    %ebx,%eax
  800ae1:	eb 0f                	jmp    800af2 <memcmp+0x35>
		s1++, s2++;
  800ae3:	83 c2 01             	add    $0x1,%edx
  800ae6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ae9:	39 f2                	cmp    %esi,%edx
  800aeb:	75 e2                	jne    800acf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800aed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af2:	5b                   	pop    %ebx
  800af3:	5e                   	pop    %esi
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aff:	89 c2                	mov    %eax,%edx
  800b01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b04:	eb 07                	jmp    800b0d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b06:	38 08                	cmp    %cl,(%eax)
  800b08:	74 07                	je     800b11 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b0a:	83 c0 01             	add    $0x1,%eax
  800b0d:	39 d0                	cmp    %edx,%eax
  800b0f:	72 f5                	jb     800b06 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	57                   	push   %edi
  800b17:	56                   	push   %esi
  800b18:	53                   	push   %ebx
  800b19:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b1f:	eb 03                	jmp    800b24 <strtol+0x11>
		s++;
  800b21:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b24:	0f b6 0a             	movzbl (%edx),%ecx
  800b27:	80 f9 09             	cmp    $0x9,%cl
  800b2a:	74 f5                	je     800b21 <strtol+0xe>
  800b2c:	80 f9 20             	cmp    $0x20,%cl
  800b2f:	74 f0                	je     800b21 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b31:	80 f9 2b             	cmp    $0x2b,%cl
  800b34:	75 0a                	jne    800b40 <strtol+0x2d>
		s++;
  800b36:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b39:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3e:	eb 11                	jmp    800b51 <strtol+0x3e>
  800b40:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b45:	80 f9 2d             	cmp    $0x2d,%cl
  800b48:	75 07                	jne    800b51 <strtol+0x3e>
		s++, neg = 1;
  800b4a:	8d 52 01             	lea    0x1(%edx),%edx
  800b4d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b51:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b56:	75 15                	jne    800b6d <strtol+0x5a>
  800b58:	80 3a 30             	cmpb   $0x30,(%edx)
  800b5b:	75 10                	jne    800b6d <strtol+0x5a>
  800b5d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b61:	75 0a                	jne    800b6d <strtol+0x5a>
		s += 2, base = 16;
  800b63:	83 c2 02             	add    $0x2,%edx
  800b66:	b8 10 00 00 00       	mov    $0x10,%eax
  800b6b:	eb 10                	jmp    800b7d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b6d:	85 c0                	test   %eax,%eax
  800b6f:	75 0c                	jne    800b7d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b71:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b73:	80 3a 30             	cmpb   $0x30,(%edx)
  800b76:	75 05                	jne    800b7d <strtol+0x6a>
		s++, base = 8;
  800b78:	83 c2 01             	add    $0x1,%edx
  800b7b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b82:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b85:	0f b6 0a             	movzbl (%edx),%ecx
  800b88:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b8b:	89 f0                	mov    %esi,%eax
  800b8d:	3c 09                	cmp    $0x9,%al
  800b8f:	77 08                	ja     800b99 <strtol+0x86>
			dig = *s - '0';
  800b91:	0f be c9             	movsbl %cl,%ecx
  800b94:	83 e9 30             	sub    $0x30,%ecx
  800b97:	eb 20                	jmp    800bb9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b99:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b9c:	89 f0                	mov    %esi,%eax
  800b9e:	3c 19                	cmp    $0x19,%al
  800ba0:	77 08                	ja     800baa <strtol+0x97>
			dig = *s - 'a' + 10;
  800ba2:	0f be c9             	movsbl %cl,%ecx
  800ba5:	83 e9 57             	sub    $0x57,%ecx
  800ba8:	eb 0f                	jmp    800bb9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800baa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bad:	89 f0                	mov    %esi,%eax
  800baf:	3c 19                	cmp    $0x19,%al
  800bb1:	77 16                	ja     800bc9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800bb3:	0f be c9             	movsbl %cl,%ecx
  800bb6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bb9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bbc:	7d 0f                	jge    800bcd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bbe:	83 c2 01             	add    $0x1,%edx
  800bc1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800bc5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800bc7:	eb bc                	jmp    800b85 <strtol+0x72>
  800bc9:	89 d8                	mov    %ebx,%eax
  800bcb:	eb 02                	jmp    800bcf <strtol+0xbc>
  800bcd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800bcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd3:	74 05                	je     800bda <strtol+0xc7>
		*endptr = (char *) s;
  800bd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bda:	f7 d8                	neg    %eax
  800bdc:	85 ff                	test   %edi,%edi
  800bde:	0f 44 c3             	cmove  %ebx,%eax
}
  800be1:	5b                   	pop    %ebx
  800be2:	5e                   	pop    %esi
  800be3:	5f                   	pop    %edi
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    

00800be6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	57                   	push   %edi
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bec:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf7:	89 c3                	mov    %eax,%ebx
  800bf9:	89 c7                	mov    %eax,%edi
  800bfb:	89 c6                	mov    %eax,%esi
  800bfd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bff:	5b                   	pop    %ebx
  800c00:	5e                   	pop    %esi
  800c01:	5f                   	pop    %edi
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	57                   	push   %edi
  800c08:	56                   	push   %esi
  800c09:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c14:	89 d1                	mov    %edx,%ecx
  800c16:	89 d3                	mov    %edx,%ebx
  800c18:	89 d7                	mov    %edx,%edi
  800c1a:	89 d6                	mov    %edx,%esi
  800c1c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c1e:	5b                   	pop    %ebx
  800c1f:	5e                   	pop    %esi
  800c20:	5f                   	pop    %edi
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	57                   	push   %edi
  800c27:	56                   	push   %esi
  800c28:	53                   	push   %ebx
  800c29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c31:	b8 03 00 00 00       	mov    $0x3,%eax
  800c36:	8b 55 08             	mov    0x8(%ebp),%edx
  800c39:	89 cb                	mov    %ecx,%ebx
  800c3b:	89 cf                	mov    %ecx,%edi
  800c3d:	89 ce                	mov    %ecx,%esi
  800c3f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c41:	85 c0                	test   %eax,%eax
  800c43:	7e 28                	jle    800c6d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c45:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c49:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c50:	00 
  800c51:	c7 44 24 08 a7 2a 80 	movl   $0x802aa7,0x8(%esp)
  800c58:	00 
  800c59:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c60:	00 
  800c61:	c7 04 24 c4 2a 80 00 	movl   $0x802ac4,(%esp)
  800c68:	e8 0a f5 ff ff       	call   800177 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c6d:	83 c4 2c             	add    $0x2c,%esp
  800c70:	5b                   	pop    %ebx
  800c71:	5e                   	pop    %esi
  800c72:	5f                   	pop    %edi
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	57                   	push   %edi
  800c79:	56                   	push   %esi
  800c7a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c80:	b8 02 00 00 00       	mov    $0x2,%eax
  800c85:	89 d1                	mov    %edx,%ecx
  800c87:	89 d3                	mov    %edx,%ebx
  800c89:	89 d7                	mov    %edx,%edi
  800c8b:	89 d6                	mov    %edx,%esi
  800c8d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    

00800c94 <sys_yield>:

void
sys_yield(void)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	57                   	push   %edi
  800c98:	56                   	push   %esi
  800c99:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ca4:	89 d1                	mov    %edx,%ecx
  800ca6:	89 d3                	mov    %edx,%ebx
  800ca8:	89 d7                	mov    %edx,%edi
  800caa:	89 d6                	mov    %edx,%esi
  800cac:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cae:	5b                   	pop    %ebx
  800caf:	5e                   	pop    %esi
  800cb0:	5f                   	pop    %edi
  800cb1:	5d                   	pop    %ebp
  800cb2:	c3                   	ret    

00800cb3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	57                   	push   %edi
  800cb7:	56                   	push   %esi
  800cb8:	53                   	push   %ebx
  800cb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cbc:	be 00 00 00 00       	mov    $0x0,%esi
  800cc1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ccf:	89 f7                	mov    %esi,%edi
  800cd1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	7e 28                	jle    800cff <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cdb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ce2:	00 
  800ce3:	c7 44 24 08 a7 2a 80 	movl   $0x802aa7,0x8(%esp)
  800cea:	00 
  800ceb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cf2:	00 
  800cf3:	c7 04 24 c4 2a 80 00 	movl   $0x802ac4,(%esp)
  800cfa:	e8 78 f4 ff ff       	call   800177 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cff:	83 c4 2c             	add    $0x2c,%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	57                   	push   %edi
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
  800d0d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d10:	b8 05 00 00 00       	mov    $0x5,%eax
  800d15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d18:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d21:	8b 75 18             	mov    0x18(%ebp),%esi
  800d24:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d26:	85 c0                	test   %eax,%eax
  800d28:	7e 28                	jle    800d52 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d2e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d35:	00 
  800d36:	c7 44 24 08 a7 2a 80 	movl   $0x802aa7,0x8(%esp)
  800d3d:	00 
  800d3e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d45:	00 
  800d46:	c7 04 24 c4 2a 80 00 	movl   $0x802ac4,(%esp)
  800d4d:	e8 25 f4 ff ff       	call   800177 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d52:	83 c4 2c             	add    $0x2c,%esp
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	57                   	push   %edi
  800d5e:	56                   	push   %esi
  800d5f:	53                   	push   %ebx
  800d60:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d63:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d68:	b8 06 00 00 00       	mov    $0x6,%eax
  800d6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d70:	8b 55 08             	mov    0x8(%ebp),%edx
  800d73:	89 df                	mov    %ebx,%edi
  800d75:	89 de                	mov    %ebx,%esi
  800d77:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d79:	85 c0                	test   %eax,%eax
  800d7b:	7e 28                	jle    800da5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d81:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d88:	00 
  800d89:	c7 44 24 08 a7 2a 80 	movl   $0x802aa7,0x8(%esp)
  800d90:	00 
  800d91:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d98:	00 
  800d99:	c7 04 24 c4 2a 80 00 	movl   $0x802ac4,(%esp)
  800da0:	e8 d2 f3 ff ff       	call   800177 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800da5:	83 c4 2c             	add    $0x2c,%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	57                   	push   %edi
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
  800db3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbb:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	89 df                	mov    %ebx,%edi
  800dc8:	89 de                	mov    %ebx,%esi
  800dca:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	7e 28                	jle    800df8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dd4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ddb:	00 
  800ddc:	c7 44 24 08 a7 2a 80 	movl   $0x802aa7,0x8(%esp)
  800de3:	00 
  800de4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800deb:	00 
  800dec:	c7 04 24 c4 2a 80 00 	movl   $0x802ac4,(%esp)
  800df3:	e8 7f f3 ff ff       	call   800177 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800df8:	83 c4 2c             	add    $0x2c,%esp
  800dfb:	5b                   	pop    %ebx
  800dfc:	5e                   	pop    %esi
  800dfd:	5f                   	pop    %edi
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	57                   	push   %edi
  800e04:	56                   	push   %esi
  800e05:	53                   	push   %ebx
  800e06:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e16:	8b 55 08             	mov    0x8(%ebp),%edx
  800e19:	89 df                	mov    %ebx,%edi
  800e1b:	89 de                	mov    %ebx,%esi
  800e1d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e1f:	85 c0                	test   %eax,%eax
  800e21:	7e 28                	jle    800e4b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e23:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e27:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e2e:	00 
  800e2f:	c7 44 24 08 a7 2a 80 	movl   $0x802aa7,0x8(%esp)
  800e36:	00 
  800e37:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e3e:	00 
  800e3f:	c7 04 24 c4 2a 80 00 	movl   $0x802ac4,(%esp)
  800e46:	e8 2c f3 ff ff       	call   800177 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e4b:	83 c4 2c             	add    $0x2c,%esp
  800e4e:	5b                   	pop    %ebx
  800e4f:	5e                   	pop    %esi
  800e50:	5f                   	pop    %edi
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    

00800e53 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	57                   	push   %edi
  800e57:	56                   	push   %esi
  800e58:	53                   	push   %ebx
  800e59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e69:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6c:	89 df                	mov    %ebx,%edi
  800e6e:	89 de                	mov    %ebx,%esi
  800e70:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e72:	85 c0                	test   %eax,%eax
  800e74:	7e 28                	jle    800e9e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e76:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e7a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e81:	00 
  800e82:	c7 44 24 08 a7 2a 80 	movl   $0x802aa7,0x8(%esp)
  800e89:	00 
  800e8a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e91:	00 
  800e92:	c7 04 24 c4 2a 80 00 	movl   $0x802ac4,(%esp)
  800e99:	e8 d9 f2 ff ff       	call   800177 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e9e:	83 c4 2c             	add    $0x2c,%esp
  800ea1:	5b                   	pop    %ebx
  800ea2:	5e                   	pop    %esi
  800ea3:	5f                   	pop    %edi
  800ea4:	5d                   	pop    %ebp
  800ea5:	c3                   	ret    

00800ea6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	57                   	push   %edi
  800eaa:	56                   	push   %esi
  800eab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eac:	be 00 00 00 00       	mov    $0x0,%esi
  800eb1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800edc:	8b 55 08             	mov    0x8(%ebp),%edx
  800edf:	89 cb                	mov    %ecx,%ebx
  800ee1:	89 cf                	mov    %ecx,%edi
  800ee3:	89 ce                	mov    %ecx,%esi
  800ee5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	7e 28                	jle    800f13 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eeb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eef:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ef6:	00 
  800ef7:	c7 44 24 08 a7 2a 80 	movl   $0x802aa7,0x8(%esp)
  800efe:	00 
  800eff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f06:	00 
  800f07:	c7 04 24 c4 2a 80 00 	movl   $0x802ac4,(%esp)
  800f0e:	e8 64 f2 ff ff       	call   800177 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f13:	83 c4 2c             	add    $0x2c,%esp
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	57                   	push   %edi
  800f1f:	56                   	push   %esi
  800f20:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f21:	ba 00 00 00 00       	mov    $0x0,%edx
  800f26:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f2b:	89 d1                	mov    %edx,%ecx
  800f2d:	89 d3                	mov    %edx,%ebx
  800f2f:	89 d7                	mov    %edx,%edi
  800f31:	89 d6                	mov    %edx,%esi
  800f33:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    

00800f3a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	57                   	push   %edi
  800f3e:	56                   	push   %esi
  800f3f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f45:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	89 df                	mov    %ebx,%edi
  800f52:	89 de                	mov    %ebx,%esi
  800f54:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	57                   	push   %edi
  800f5f:	56                   	push   %esi
  800f60:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f66:	b8 10 00 00 00       	mov    $0x10,%eax
  800f6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	89 df                	mov    %ebx,%edi
  800f73:	89 de                	mov    %ebx,%esi
  800f75:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f87:	b8 11 00 00 00       	mov    $0x11,%eax
  800f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8f:	89 cb                	mov    %ecx,%ebx
  800f91:	89 cf                	mov    %ecx,%edi
  800f93:	89 ce                	mov    %ecx,%esi
  800f95:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800f97:	5b                   	pop    %ebx
  800f98:	5e                   	pop    %esi
  800f99:	5f                   	pop    %edi
  800f9a:	5d                   	pop    %ebp
  800f9b:	c3                   	ret    

00800f9c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	57                   	push   %edi
  800fa0:	56                   	push   %esi
  800fa1:	53                   	push   %ebx
  800fa2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa5:	be 00 00 00 00       	mov    $0x0,%esi
  800faa:	b8 12 00 00 00       	mov    $0x12,%eax
  800faf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fb8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fbb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	7e 28                	jle    800fe9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800fcc:	00 
  800fcd:	c7 44 24 08 a7 2a 80 	movl   $0x802aa7,0x8(%esp)
  800fd4:	00 
  800fd5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fdc:	00 
  800fdd:	c7 04 24 c4 2a 80 00 	movl   $0x802ac4,(%esp)
  800fe4:	e8 8e f1 ff ff       	call   800177 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  800fe9:	83 c4 2c             	add    $0x2c,%esp
  800fec:	5b                   	pop    %ebx
  800fed:	5e                   	pop    %esi
  800fee:	5f                   	pop    %edi
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    
  800ff1:	66 90                	xchg   %ax,%ax
  800ff3:	66 90                	xchg   %ax,%ax
  800ff5:	66 90                	xchg   %ax,%ax
  800ff7:	66 90                	xchg   %ax,%ax
  800ff9:	66 90                	xchg   %ax,%ax
  800ffb:	66 90                	xchg   %ax,%ax
  800ffd:	66 90                	xchg   %ax,%ax
  800fff:	90                   	nop

00801000 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	05 00 00 00 30       	add    $0x30000000,%eax
  80100b:	c1 e8 0c             	shr    $0xc,%eax
}
  80100e:	5d                   	pop    %ebp
  80100f:	c3                   	ret    

00801010 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80101b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801020:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    

00801027 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801027:	55                   	push   %ebp
  801028:	89 e5                	mov    %esp,%ebp
  80102a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80102d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801032:	89 c2                	mov    %eax,%edx
  801034:	c1 ea 16             	shr    $0x16,%edx
  801037:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80103e:	f6 c2 01             	test   $0x1,%dl
  801041:	74 11                	je     801054 <fd_alloc+0x2d>
  801043:	89 c2                	mov    %eax,%edx
  801045:	c1 ea 0c             	shr    $0xc,%edx
  801048:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80104f:	f6 c2 01             	test   $0x1,%dl
  801052:	75 09                	jne    80105d <fd_alloc+0x36>
			*fd_store = fd;
  801054:	89 01                	mov    %eax,(%ecx)
			return 0;
  801056:	b8 00 00 00 00       	mov    $0x0,%eax
  80105b:	eb 17                	jmp    801074 <fd_alloc+0x4d>
  80105d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801062:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801067:	75 c9                	jne    801032 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801069:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80106f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801074:	5d                   	pop    %ebp
  801075:	c3                   	ret    

00801076 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80107c:	83 f8 1f             	cmp    $0x1f,%eax
  80107f:	77 36                	ja     8010b7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801081:	c1 e0 0c             	shl    $0xc,%eax
  801084:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801089:	89 c2                	mov    %eax,%edx
  80108b:	c1 ea 16             	shr    $0x16,%edx
  80108e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801095:	f6 c2 01             	test   $0x1,%dl
  801098:	74 24                	je     8010be <fd_lookup+0x48>
  80109a:	89 c2                	mov    %eax,%edx
  80109c:	c1 ea 0c             	shr    $0xc,%edx
  80109f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010a6:	f6 c2 01             	test   $0x1,%dl
  8010a9:	74 1a                	je     8010c5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ae:	89 02                	mov    %eax,(%edx)
	return 0;
  8010b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b5:	eb 13                	jmp    8010ca <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010bc:	eb 0c                	jmp    8010ca <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c3:	eb 05                	jmp    8010ca <fd_lookup+0x54>
  8010c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8010ca:	5d                   	pop    %ebp
  8010cb:	c3                   	ret    

008010cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
  8010cf:	83 ec 18             	sub    $0x18,%esp
  8010d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8010da:	eb 13                	jmp    8010ef <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8010dc:	39 08                	cmp    %ecx,(%eax)
  8010de:	75 0c                	jne    8010ec <dev_lookup+0x20>
			*dev = devtab[i];
  8010e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ea:	eb 38                	jmp    801124 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8010ec:	83 c2 01             	add    $0x1,%edx
  8010ef:	8b 04 95 54 2b 80 00 	mov    0x802b54(,%edx,4),%eax
  8010f6:	85 c0                	test   %eax,%eax
  8010f8:	75 e2                	jne    8010dc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010fa:	a1 08 40 80 00       	mov    0x804008,%eax
  8010ff:	8b 40 48             	mov    0x48(%eax),%eax
  801102:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801106:	89 44 24 04          	mov    %eax,0x4(%esp)
  80110a:	c7 04 24 d4 2a 80 00 	movl   $0x802ad4,(%esp)
  801111:	e8 5a f1 ff ff       	call   800270 <cprintf>
	*dev = 0;
  801116:	8b 45 0c             	mov    0xc(%ebp),%eax
  801119:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80111f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801124:	c9                   	leave  
  801125:	c3                   	ret    

00801126 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	56                   	push   %esi
  80112a:	53                   	push   %ebx
  80112b:	83 ec 20             	sub    $0x20,%esp
  80112e:	8b 75 08             	mov    0x8(%ebp),%esi
  801131:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801134:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801137:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80113b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801141:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801144:	89 04 24             	mov    %eax,(%esp)
  801147:	e8 2a ff ff ff       	call   801076 <fd_lookup>
  80114c:	85 c0                	test   %eax,%eax
  80114e:	78 05                	js     801155 <fd_close+0x2f>
	    || fd != fd2)
  801150:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801153:	74 0c                	je     801161 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801155:	84 db                	test   %bl,%bl
  801157:	ba 00 00 00 00       	mov    $0x0,%edx
  80115c:	0f 44 c2             	cmove  %edx,%eax
  80115f:	eb 3f                	jmp    8011a0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801161:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801164:	89 44 24 04          	mov    %eax,0x4(%esp)
  801168:	8b 06                	mov    (%esi),%eax
  80116a:	89 04 24             	mov    %eax,(%esp)
  80116d:	e8 5a ff ff ff       	call   8010cc <dev_lookup>
  801172:	89 c3                	mov    %eax,%ebx
  801174:	85 c0                	test   %eax,%eax
  801176:	78 16                	js     80118e <fd_close+0x68>
		if (dev->dev_close)
  801178:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80117b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80117e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801183:	85 c0                	test   %eax,%eax
  801185:	74 07                	je     80118e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801187:	89 34 24             	mov    %esi,(%esp)
  80118a:	ff d0                	call   *%eax
  80118c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80118e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801192:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801199:	e8 bc fb ff ff       	call   800d5a <sys_page_unmap>
	return r;
  80119e:	89 d8                	mov    %ebx,%eax
}
  8011a0:	83 c4 20             	add    $0x20,%esp
  8011a3:	5b                   	pop    %ebx
  8011a4:	5e                   	pop    %esi
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	89 04 24             	mov    %eax,(%esp)
  8011ba:	e8 b7 fe ff ff       	call   801076 <fd_lookup>
  8011bf:	89 c2                	mov    %eax,%edx
  8011c1:	85 d2                	test   %edx,%edx
  8011c3:	78 13                	js     8011d8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8011c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011cc:	00 
  8011cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d0:	89 04 24             	mov    %eax,(%esp)
  8011d3:	e8 4e ff ff ff       	call   801126 <fd_close>
}
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    

008011da <close_all>:

void
close_all(void)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	53                   	push   %ebx
  8011de:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011e6:	89 1c 24             	mov    %ebx,(%esp)
  8011e9:	e8 b9 ff ff ff       	call   8011a7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8011ee:	83 c3 01             	add    $0x1,%ebx
  8011f1:	83 fb 20             	cmp    $0x20,%ebx
  8011f4:	75 f0                	jne    8011e6 <close_all+0xc>
		close(i);
}
  8011f6:	83 c4 14             	add    $0x14,%esp
  8011f9:	5b                   	pop    %ebx
  8011fa:	5d                   	pop    %ebp
  8011fb:	c3                   	ret    

008011fc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	57                   	push   %edi
  801200:	56                   	push   %esi
  801201:	53                   	push   %ebx
  801202:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801205:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801208:	89 44 24 04          	mov    %eax,0x4(%esp)
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	89 04 24             	mov    %eax,(%esp)
  801212:	e8 5f fe ff ff       	call   801076 <fd_lookup>
  801217:	89 c2                	mov    %eax,%edx
  801219:	85 d2                	test   %edx,%edx
  80121b:	0f 88 e1 00 00 00    	js     801302 <dup+0x106>
		return r;
	close(newfdnum);
  801221:	8b 45 0c             	mov    0xc(%ebp),%eax
  801224:	89 04 24             	mov    %eax,(%esp)
  801227:	e8 7b ff ff ff       	call   8011a7 <close>

	newfd = INDEX2FD(newfdnum);
  80122c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80122f:	c1 e3 0c             	shl    $0xc,%ebx
  801232:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80123b:	89 04 24             	mov    %eax,(%esp)
  80123e:	e8 cd fd ff ff       	call   801010 <fd2data>
  801243:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801245:	89 1c 24             	mov    %ebx,(%esp)
  801248:	e8 c3 fd ff ff       	call   801010 <fd2data>
  80124d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80124f:	89 f0                	mov    %esi,%eax
  801251:	c1 e8 16             	shr    $0x16,%eax
  801254:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80125b:	a8 01                	test   $0x1,%al
  80125d:	74 43                	je     8012a2 <dup+0xa6>
  80125f:	89 f0                	mov    %esi,%eax
  801261:	c1 e8 0c             	shr    $0xc,%eax
  801264:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80126b:	f6 c2 01             	test   $0x1,%dl
  80126e:	74 32                	je     8012a2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801270:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801277:	25 07 0e 00 00       	and    $0xe07,%eax
  80127c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801280:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801284:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80128b:	00 
  80128c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801290:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801297:	e8 6b fa ff ff       	call   800d07 <sys_page_map>
  80129c:	89 c6                	mov    %eax,%esi
  80129e:	85 c0                	test   %eax,%eax
  8012a0:	78 3e                	js     8012e0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012a5:	89 c2                	mov    %eax,%edx
  8012a7:	c1 ea 0c             	shr    $0xc,%edx
  8012aa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012b1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8012b7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012c6:	00 
  8012c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d2:	e8 30 fa ff ff       	call   800d07 <sys_page_map>
  8012d7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8012d9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012dc:	85 f6                	test   %esi,%esi
  8012de:	79 22                	jns    801302 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8012e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012eb:	e8 6a fa ff ff       	call   800d5a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012fb:	e8 5a fa ff ff       	call   800d5a <sys_page_unmap>
	return r;
  801300:	89 f0                	mov    %esi,%eax
}
  801302:	83 c4 3c             	add    $0x3c,%esp
  801305:	5b                   	pop    %ebx
  801306:	5e                   	pop    %esi
  801307:	5f                   	pop    %edi
  801308:	5d                   	pop    %ebp
  801309:	c3                   	ret    

0080130a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80130a:	55                   	push   %ebp
  80130b:	89 e5                	mov    %esp,%ebp
  80130d:	53                   	push   %ebx
  80130e:	83 ec 24             	sub    $0x24,%esp
  801311:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801314:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801317:	89 44 24 04          	mov    %eax,0x4(%esp)
  80131b:	89 1c 24             	mov    %ebx,(%esp)
  80131e:	e8 53 fd ff ff       	call   801076 <fd_lookup>
  801323:	89 c2                	mov    %eax,%edx
  801325:	85 d2                	test   %edx,%edx
  801327:	78 6d                	js     801396 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801329:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80132c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801333:	8b 00                	mov    (%eax),%eax
  801335:	89 04 24             	mov    %eax,(%esp)
  801338:	e8 8f fd ff ff       	call   8010cc <dev_lookup>
  80133d:	85 c0                	test   %eax,%eax
  80133f:	78 55                	js     801396 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801344:	8b 50 08             	mov    0x8(%eax),%edx
  801347:	83 e2 03             	and    $0x3,%edx
  80134a:	83 fa 01             	cmp    $0x1,%edx
  80134d:	75 23                	jne    801372 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80134f:	a1 08 40 80 00       	mov    0x804008,%eax
  801354:	8b 40 48             	mov    0x48(%eax),%eax
  801357:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80135b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80135f:	c7 04 24 18 2b 80 00 	movl   $0x802b18,(%esp)
  801366:	e8 05 ef ff ff       	call   800270 <cprintf>
		return -E_INVAL;
  80136b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801370:	eb 24                	jmp    801396 <read+0x8c>
	}
	if (!dev->dev_read)
  801372:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801375:	8b 52 08             	mov    0x8(%edx),%edx
  801378:	85 d2                	test   %edx,%edx
  80137a:	74 15                	je     801391 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80137c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80137f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801383:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801386:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80138a:	89 04 24             	mov    %eax,(%esp)
  80138d:	ff d2                	call   *%edx
  80138f:	eb 05                	jmp    801396 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801391:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801396:	83 c4 24             	add    $0x24,%esp
  801399:	5b                   	pop    %ebx
  80139a:	5d                   	pop    %ebp
  80139b:	c3                   	ret    

0080139c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	57                   	push   %edi
  8013a0:	56                   	push   %esi
  8013a1:	53                   	push   %ebx
  8013a2:	83 ec 1c             	sub    $0x1c,%esp
  8013a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b0:	eb 23                	jmp    8013d5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013b2:	89 f0                	mov    %esi,%eax
  8013b4:	29 d8                	sub    %ebx,%eax
  8013b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013ba:	89 d8                	mov    %ebx,%eax
  8013bc:	03 45 0c             	add    0xc(%ebp),%eax
  8013bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c3:	89 3c 24             	mov    %edi,(%esp)
  8013c6:	e8 3f ff ff ff       	call   80130a <read>
		if (m < 0)
  8013cb:	85 c0                	test   %eax,%eax
  8013cd:	78 10                	js     8013df <readn+0x43>
			return m;
		if (m == 0)
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	74 0a                	je     8013dd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013d3:	01 c3                	add    %eax,%ebx
  8013d5:	39 f3                	cmp    %esi,%ebx
  8013d7:	72 d9                	jb     8013b2 <readn+0x16>
  8013d9:	89 d8                	mov    %ebx,%eax
  8013db:	eb 02                	jmp    8013df <readn+0x43>
  8013dd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8013df:	83 c4 1c             	add    $0x1c,%esp
  8013e2:	5b                   	pop    %ebx
  8013e3:	5e                   	pop    %esi
  8013e4:	5f                   	pop    %edi
  8013e5:	5d                   	pop    %ebp
  8013e6:	c3                   	ret    

008013e7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013e7:	55                   	push   %ebp
  8013e8:	89 e5                	mov    %esp,%ebp
  8013ea:	53                   	push   %ebx
  8013eb:	83 ec 24             	sub    $0x24,%esp
  8013ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f8:	89 1c 24             	mov    %ebx,(%esp)
  8013fb:	e8 76 fc ff ff       	call   801076 <fd_lookup>
  801400:	89 c2                	mov    %eax,%edx
  801402:	85 d2                	test   %edx,%edx
  801404:	78 68                	js     80146e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801406:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801409:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801410:	8b 00                	mov    (%eax),%eax
  801412:	89 04 24             	mov    %eax,(%esp)
  801415:	e8 b2 fc ff ff       	call   8010cc <dev_lookup>
  80141a:	85 c0                	test   %eax,%eax
  80141c:	78 50                	js     80146e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80141e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801421:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801425:	75 23                	jne    80144a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801427:	a1 08 40 80 00       	mov    0x804008,%eax
  80142c:	8b 40 48             	mov    0x48(%eax),%eax
  80142f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801433:	89 44 24 04          	mov    %eax,0x4(%esp)
  801437:	c7 04 24 34 2b 80 00 	movl   $0x802b34,(%esp)
  80143e:	e8 2d ee ff ff       	call   800270 <cprintf>
		return -E_INVAL;
  801443:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801448:	eb 24                	jmp    80146e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80144a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144d:	8b 52 0c             	mov    0xc(%edx),%edx
  801450:	85 d2                	test   %edx,%edx
  801452:	74 15                	je     801469 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801454:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801457:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80145b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80145e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801462:	89 04 24             	mov    %eax,(%esp)
  801465:	ff d2                	call   *%edx
  801467:	eb 05                	jmp    80146e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801469:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80146e:	83 c4 24             	add    $0x24,%esp
  801471:	5b                   	pop    %ebx
  801472:	5d                   	pop    %ebp
  801473:	c3                   	ret    

00801474 <seek>:

int
seek(int fdnum, off_t offset)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80147a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80147d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	89 04 24             	mov    %eax,(%esp)
  801487:	e8 ea fb ff ff       	call   801076 <fd_lookup>
  80148c:	85 c0                	test   %eax,%eax
  80148e:	78 0e                	js     80149e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801490:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801493:	8b 55 0c             	mov    0xc(%ebp),%edx
  801496:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801499:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	53                   	push   %ebx
  8014a4:	83 ec 24             	sub    $0x24,%esp
  8014a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b1:	89 1c 24             	mov    %ebx,(%esp)
  8014b4:	e8 bd fb ff ff       	call   801076 <fd_lookup>
  8014b9:	89 c2                	mov    %eax,%edx
  8014bb:	85 d2                	test   %edx,%edx
  8014bd:	78 61                	js     801520 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c9:	8b 00                	mov    (%eax),%eax
  8014cb:	89 04 24             	mov    %eax,(%esp)
  8014ce:	e8 f9 fb ff ff       	call   8010cc <dev_lookup>
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	78 49                	js     801520 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014da:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014de:	75 23                	jne    801503 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8014e0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014e5:	8b 40 48             	mov    0x48(%eax),%eax
  8014e8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f0:	c7 04 24 f4 2a 80 00 	movl   $0x802af4,(%esp)
  8014f7:	e8 74 ed ff ff       	call   800270 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8014fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801501:	eb 1d                	jmp    801520 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801503:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801506:	8b 52 18             	mov    0x18(%edx),%edx
  801509:	85 d2                	test   %edx,%edx
  80150b:	74 0e                	je     80151b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80150d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801510:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801514:	89 04 24             	mov    %eax,(%esp)
  801517:	ff d2                	call   *%edx
  801519:	eb 05                	jmp    801520 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80151b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801520:	83 c4 24             	add    $0x24,%esp
  801523:	5b                   	pop    %ebx
  801524:	5d                   	pop    %ebp
  801525:	c3                   	ret    

00801526 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	53                   	push   %ebx
  80152a:	83 ec 24             	sub    $0x24,%esp
  80152d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801530:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801533:	89 44 24 04          	mov    %eax,0x4(%esp)
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	89 04 24             	mov    %eax,(%esp)
  80153d:	e8 34 fb ff ff       	call   801076 <fd_lookup>
  801542:	89 c2                	mov    %eax,%edx
  801544:	85 d2                	test   %edx,%edx
  801546:	78 52                	js     80159a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801548:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80154f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801552:	8b 00                	mov    (%eax),%eax
  801554:	89 04 24             	mov    %eax,(%esp)
  801557:	e8 70 fb ff ff       	call   8010cc <dev_lookup>
  80155c:	85 c0                	test   %eax,%eax
  80155e:	78 3a                	js     80159a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801563:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801567:	74 2c                	je     801595 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801569:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80156c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801573:	00 00 00 
	stat->st_isdir = 0;
  801576:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80157d:	00 00 00 
	stat->st_dev = dev;
  801580:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801586:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80158a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80158d:	89 14 24             	mov    %edx,(%esp)
  801590:	ff 50 14             	call   *0x14(%eax)
  801593:	eb 05                	jmp    80159a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801595:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80159a:	83 c4 24             	add    $0x24,%esp
  80159d:	5b                   	pop    %ebx
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    

008015a0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	56                   	push   %esi
  8015a4:	53                   	push   %ebx
  8015a5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015af:	00 
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	89 04 24             	mov    %eax,(%esp)
  8015b6:	e8 84 02 00 00       	call   80183f <open>
  8015bb:	89 c3                	mov    %eax,%ebx
  8015bd:	85 db                	test   %ebx,%ebx
  8015bf:	78 1b                	js     8015dc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c8:	89 1c 24             	mov    %ebx,(%esp)
  8015cb:	e8 56 ff ff ff       	call   801526 <fstat>
  8015d0:	89 c6                	mov    %eax,%esi
	close(fd);
  8015d2:	89 1c 24             	mov    %ebx,(%esp)
  8015d5:	e8 cd fb ff ff       	call   8011a7 <close>
	return r;
  8015da:	89 f0                	mov    %esi,%eax
}
  8015dc:	83 c4 10             	add    $0x10,%esp
  8015df:	5b                   	pop    %ebx
  8015e0:	5e                   	pop    %esi
  8015e1:	5d                   	pop    %ebp
  8015e2:	c3                   	ret    

008015e3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	56                   	push   %esi
  8015e7:	53                   	push   %ebx
  8015e8:	83 ec 10             	sub    $0x10,%esp
  8015eb:	89 c6                	mov    %eax,%esi
  8015ed:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015ef:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015f6:	75 11                	jne    801609 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8015ff:	e8 11 0e 00 00       	call   802415 <ipc_find_env>
  801604:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801609:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801610:	00 
  801611:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801618:	00 
  801619:	89 74 24 04          	mov    %esi,0x4(%esp)
  80161d:	a1 00 40 80 00       	mov    0x804000,%eax
  801622:	89 04 24             	mov    %eax,(%esp)
  801625:	e8 5e 0d 00 00       	call   802388 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80162a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801631:	00 
  801632:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801636:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80163d:	e8 de 0c 00 00       	call   802320 <ipc_recv>
}
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	5b                   	pop    %ebx
  801646:	5e                   	pop    %esi
  801647:	5d                   	pop    %ebp
  801648:	c3                   	ret    

00801649 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8b 40 0c             	mov    0xc(%eax),%eax
  801655:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80165a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801662:	ba 00 00 00 00       	mov    $0x0,%edx
  801667:	b8 02 00 00 00       	mov    $0x2,%eax
  80166c:	e8 72 ff ff ff       	call   8015e3 <fsipc>
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	8b 40 0c             	mov    0xc(%eax),%eax
  80167f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801684:	ba 00 00 00 00       	mov    $0x0,%edx
  801689:	b8 06 00 00 00       	mov    $0x6,%eax
  80168e:	e8 50 ff ff ff       	call   8015e3 <fsipc>
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	53                   	push   %ebx
  801699:	83 ec 14             	sub    $0x14,%esp
  80169c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8016af:	b8 05 00 00 00       	mov    $0x5,%eax
  8016b4:	e8 2a ff ff ff       	call   8015e3 <fsipc>
  8016b9:	89 c2                	mov    %eax,%edx
  8016bb:	85 d2                	test   %edx,%edx
  8016bd:	78 2b                	js     8016ea <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016bf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8016c6:	00 
  8016c7:	89 1c 24             	mov    %ebx,(%esp)
  8016ca:	e8 c8 f1 ff ff       	call   800897 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016cf:	a1 80 50 80 00       	mov    0x805080,%eax
  8016d4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016da:	a1 84 50 80 00       	mov    0x805084,%eax
  8016df:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ea:	83 c4 14             	add    $0x14,%esp
  8016ed:	5b                   	pop    %ebx
  8016ee:	5d                   	pop    %ebp
  8016ef:	c3                   	ret    

008016f0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	53                   	push   %ebx
  8016f4:	83 ec 14             	sub    $0x14,%esp
  8016f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801700:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801705:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80170b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801710:	0f 46 c3             	cmovbe %ebx,%eax
  801713:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801718:	89 44 24 08          	mov    %eax,0x8(%esp)
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801723:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80172a:	e8 05 f3 ff ff       	call   800a34 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80172f:	ba 00 00 00 00       	mov    $0x0,%edx
  801734:	b8 04 00 00 00       	mov    $0x4,%eax
  801739:	e8 a5 fe ff ff       	call   8015e3 <fsipc>
  80173e:	85 c0                	test   %eax,%eax
  801740:	78 53                	js     801795 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801742:	39 c3                	cmp    %eax,%ebx
  801744:	73 24                	jae    80176a <devfile_write+0x7a>
  801746:	c7 44 24 0c 68 2b 80 	movl   $0x802b68,0xc(%esp)
  80174d:	00 
  80174e:	c7 44 24 08 6f 2b 80 	movl   $0x802b6f,0x8(%esp)
  801755:	00 
  801756:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  80175d:	00 
  80175e:	c7 04 24 84 2b 80 00 	movl   $0x802b84,(%esp)
  801765:	e8 0d ea ff ff       	call   800177 <_panic>
	assert(r <= PGSIZE);
  80176a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80176f:	7e 24                	jle    801795 <devfile_write+0xa5>
  801771:	c7 44 24 0c 8f 2b 80 	movl   $0x802b8f,0xc(%esp)
  801778:	00 
  801779:	c7 44 24 08 6f 2b 80 	movl   $0x802b6f,0x8(%esp)
  801780:	00 
  801781:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801788:	00 
  801789:	c7 04 24 84 2b 80 00 	movl   $0x802b84,(%esp)
  801790:	e8 e2 e9 ff ff       	call   800177 <_panic>
	return r;
}
  801795:	83 c4 14             	add    $0x14,%esp
  801798:	5b                   	pop    %ebx
  801799:	5d                   	pop    %ebp
  80179a:	c3                   	ret    

0080179b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	56                   	push   %esi
  80179f:	53                   	push   %ebx
  8017a0:	83 ec 10             	sub    $0x10,%esp
  8017a3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ac:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017b1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bc:	b8 03 00 00 00       	mov    $0x3,%eax
  8017c1:	e8 1d fe ff ff       	call   8015e3 <fsipc>
  8017c6:	89 c3                	mov    %eax,%ebx
  8017c8:	85 c0                	test   %eax,%eax
  8017ca:	78 6a                	js     801836 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8017cc:	39 c6                	cmp    %eax,%esi
  8017ce:	73 24                	jae    8017f4 <devfile_read+0x59>
  8017d0:	c7 44 24 0c 68 2b 80 	movl   $0x802b68,0xc(%esp)
  8017d7:	00 
  8017d8:	c7 44 24 08 6f 2b 80 	movl   $0x802b6f,0x8(%esp)
  8017df:	00 
  8017e0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8017e7:	00 
  8017e8:	c7 04 24 84 2b 80 00 	movl   $0x802b84,(%esp)
  8017ef:	e8 83 e9 ff ff       	call   800177 <_panic>
	assert(r <= PGSIZE);
  8017f4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017f9:	7e 24                	jle    80181f <devfile_read+0x84>
  8017fb:	c7 44 24 0c 8f 2b 80 	movl   $0x802b8f,0xc(%esp)
  801802:	00 
  801803:	c7 44 24 08 6f 2b 80 	movl   $0x802b6f,0x8(%esp)
  80180a:	00 
  80180b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801812:	00 
  801813:	c7 04 24 84 2b 80 00 	movl   $0x802b84,(%esp)
  80181a:	e8 58 e9 ff ff       	call   800177 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80181f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801823:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80182a:	00 
  80182b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182e:	89 04 24             	mov    %eax,(%esp)
  801831:	e8 fe f1 ff ff       	call   800a34 <memmove>
	return r;
}
  801836:	89 d8                	mov    %ebx,%eax
  801838:	83 c4 10             	add    $0x10,%esp
  80183b:	5b                   	pop    %ebx
  80183c:	5e                   	pop    %esi
  80183d:	5d                   	pop    %ebp
  80183e:	c3                   	ret    

0080183f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	53                   	push   %ebx
  801843:	83 ec 24             	sub    $0x24,%esp
  801846:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801849:	89 1c 24             	mov    %ebx,(%esp)
  80184c:	e8 0f f0 ff ff       	call   800860 <strlen>
  801851:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801856:	7f 60                	jg     8018b8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801858:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80185b:	89 04 24             	mov    %eax,(%esp)
  80185e:	e8 c4 f7 ff ff       	call   801027 <fd_alloc>
  801863:	89 c2                	mov    %eax,%edx
  801865:	85 d2                	test   %edx,%edx
  801867:	78 54                	js     8018bd <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801869:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80186d:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801874:	e8 1e f0 ff ff       	call   800897 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801879:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187c:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801881:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801884:	b8 01 00 00 00       	mov    $0x1,%eax
  801889:	e8 55 fd ff ff       	call   8015e3 <fsipc>
  80188e:	89 c3                	mov    %eax,%ebx
  801890:	85 c0                	test   %eax,%eax
  801892:	79 17                	jns    8018ab <open+0x6c>
		fd_close(fd, 0);
  801894:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80189b:	00 
  80189c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189f:	89 04 24             	mov    %eax,(%esp)
  8018a2:	e8 7f f8 ff ff       	call   801126 <fd_close>
		return r;
  8018a7:	89 d8                	mov    %ebx,%eax
  8018a9:	eb 12                	jmp    8018bd <open+0x7e>
	}

	return fd2num(fd);
  8018ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ae:	89 04 24             	mov    %eax,(%esp)
  8018b1:	e8 4a f7 ff ff       	call   801000 <fd2num>
  8018b6:	eb 05                	jmp    8018bd <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8018b8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8018bd:	83 c4 24             	add    $0x24,%esp
  8018c0:	5b                   	pop    %ebx
  8018c1:	5d                   	pop    %ebp
  8018c2:	c3                   	ret    

008018c3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8018d3:	e8 0b fd ff ff       	call   8015e3 <fsipc>
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    
  8018da:	66 90                	xchg   %ax,%ax
  8018dc:	66 90                	xchg   %ax,%ax
  8018de:	66 90                	xchg   %ax,%ax

008018e0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8018e6:	c7 44 24 04 9b 2b 80 	movl   $0x802b9b,0x4(%esp)
  8018ed:	00 
  8018ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f1:	89 04 24             	mov    %eax,(%esp)
  8018f4:	e8 9e ef ff ff       	call   800897 <strcpy>
	return 0;
}
  8018f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	53                   	push   %ebx
  801904:	83 ec 14             	sub    $0x14,%esp
  801907:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80190a:	89 1c 24             	mov    %ebx,(%esp)
  80190d:	e8 3d 0b 00 00       	call   80244f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801912:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801917:	83 f8 01             	cmp    $0x1,%eax
  80191a:	75 0d                	jne    801929 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80191c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80191f:	89 04 24             	mov    %eax,(%esp)
  801922:	e8 29 03 00 00       	call   801c50 <nsipc_close>
  801927:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801929:	89 d0                	mov    %edx,%eax
  80192b:	83 c4 14             	add    $0x14,%esp
  80192e:	5b                   	pop    %ebx
  80192f:	5d                   	pop    %ebp
  801930:	c3                   	ret    

00801931 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801937:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80193e:	00 
  80193f:	8b 45 10             	mov    0x10(%ebp),%eax
  801942:	89 44 24 08          	mov    %eax,0x8(%esp)
  801946:	8b 45 0c             	mov    0xc(%ebp),%eax
  801949:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194d:	8b 45 08             	mov    0x8(%ebp),%eax
  801950:	8b 40 0c             	mov    0xc(%eax),%eax
  801953:	89 04 24             	mov    %eax,(%esp)
  801956:	e8 f0 03 00 00       	call   801d4b <nsipc_send>
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801963:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80196a:	00 
  80196b:	8b 45 10             	mov    0x10(%ebp),%eax
  80196e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801972:	8b 45 0c             	mov    0xc(%ebp),%eax
  801975:	89 44 24 04          	mov    %eax,0x4(%esp)
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	8b 40 0c             	mov    0xc(%eax),%eax
  80197f:	89 04 24             	mov    %eax,(%esp)
  801982:	e8 44 03 00 00       	call   801ccb <nsipc_recv>
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80198f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801992:	89 54 24 04          	mov    %edx,0x4(%esp)
  801996:	89 04 24             	mov    %eax,(%esp)
  801999:	e8 d8 f6 ff ff       	call   801076 <fd_lookup>
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	78 17                	js     8019b9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8019a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019ab:	39 08                	cmp    %ecx,(%eax)
  8019ad:	75 05                	jne    8019b4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8019af:	8b 40 0c             	mov    0xc(%eax),%eax
  8019b2:	eb 05                	jmp    8019b9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8019b4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	56                   	push   %esi
  8019bf:	53                   	push   %ebx
  8019c0:	83 ec 20             	sub    $0x20,%esp
  8019c3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8019c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019c8:	89 04 24             	mov    %eax,(%esp)
  8019cb:	e8 57 f6 ff ff       	call   801027 <fd_alloc>
  8019d0:	89 c3                	mov    %eax,%ebx
  8019d2:	85 c0                	test   %eax,%eax
  8019d4:	78 21                	js     8019f7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019d6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8019dd:	00 
  8019de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019ec:	e8 c2 f2 ff ff       	call   800cb3 <sys_page_alloc>
  8019f1:	89 c3                	mov    %eax,%ebx
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	79 0c                	jns    801a03 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8019f7:	89 34 24             	mov    %esi,(%esp)
  8019fa:	e8 51 02 00 00       	call   801c50 <nsipc_close>
		return r;
  8019ff:	89 d8                	mov    %ebx,%eax
  801a01:	eb 20                	jmp    801a23 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801a03:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a11:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801a18:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801a1b:	89 14 24             	mov    %edx,(%esp)
  801a1e:	e8 dd f5 ff ff       	call   801000 <fd2num>
}
  801a23:	83 c4 20             	add    $0x20,%esp
  801a26:	5b                   	pop    %ebx
  801a27:	5e                   	pop    %esi
  801a28:	5d                   	pop    %ebp
  801a29:	c3                   	ret    

00801a2a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	e8 51 ff ff ff       	call   801989 <fd2sockid>
		return r;
  801a38:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a3a:	85 c0                	test   %eax,%eax
  801a3c:	78 23                	js     801a61 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a3e:	8b 55 10             	mov    0x10(%ebp),%edx
  801a41:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a48:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a4c:	89 04 24             	mov    %eax,(%esp)
  801a4f:	e8 45 01 00 00       	call   801b99 <nsipc_accept>
		return r;
  801a54:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a56:	85 c0                	test   %eax,%eax
  801a58:	78 07                	js     801a61 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801a5a:	e8 5c ff ff ff       	call   8019bb <alloc_sockfd>
  801a5f:	89 c1                	mov    %eax,%ecx
}
  801a61:	89 c8                	mov    %ecx,%eax
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	e8 16 ff ff ff       	call   801989 <fd2sockid>
  801a73:	89 c2                	mov    %eax,%edx
  801a75:	85 d2                	test   %edx,%edx
  801a77:	78 16                	js     801a8f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801a79:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a87:	89 14 24             	mov    %edx,(%esp)
  801a8a:	e8 60 01 00 00       	call   801bef <nsipc_bind>
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <shutdown>:

int
shutdown(int s, int how)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	e8 ea fe ff ff       	call   801989 <fd2sockid>
  801a9f:	89 c2                	mov    %eax,%edx
  801aa1:	85 d2                	test   %edx,%edx
  801aa3:	78 0f                	js     801ab4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801aa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aac:	89 14 24             	mov    %edx,(%esp)
  801aaf:	e8 7a 01 00 00       	call   801c2e <nsipc_shutdown>
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	e8 c5 fe ff ff       	call   801989 <fd2sockid>
  801ac4:	89 c2                	mov    %eax,%edx
  801ac6:	85 d2                	test   %edx,%edx
  801ac8:	78 16                	js     801ae0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801aca:	8b 45 10             	mov    0x10(%ebp),%eax
  801acd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad8:	89 14 24             	mov    %edx,(%esp)
  801adb:	e8 8a 01 00 00       	call   801c6a <nsipc_connect>
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <listen>:

int
listen(int s, int backlog)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
  801ae5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	e8 99 fe ff ff       	call   801989 <fd2sockid>
  801af0:	89 c2                	mov    %eax,%edx
  801af2:	85 d2                	test   %edx,%edx
  801af4:	78 0f                	js     801b05 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afd:	89 14 24             	mov    %edx,(%esp)
  801b00:	e8 a4 01 00 00       	call   801ca9 <nsipc_listen>
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b10:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	89 04 24             	mov    %eax,(%esp)
  801b21:	e8 98 02 00 00       	call   801dbe <nsipc_socket>
  801b26:	89 c2                	mov    %eax,%edx
  801b28:	85 d2                	test   %edx,%edx
  801b2a:	78 05                	js     801b31 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801b2c:	e8 8a fe ff ff       	call   8019bb <alloc_sockfd>
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	53                   	push   %ebx
  801b37:	83 ec 14             	sub    $0x14,%esp
  801b3a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b3c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b43:	75 11                	jne    801b56 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b45:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801b4c:	e8 c4 08 00 00       	call   802415 <ipc_find_env>
  801b51:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b56:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b5d:	00 
  801b5e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b65:	00 
  801b66:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b6a:	a1 04 40 80 00       	mov    0x804004,%eax
  801b6f:	89 04 24             	mov    %eax,(%esp)
  801b72:	e8 11 08 00 00       	call   802388 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b77:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b7e:	00 
  801b7f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b86:	00 
  801b87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b8e:	e8 8d 07 00 00       	call   802320 <ipc_recv>
}
  801b93:	83 c4 14             	add    $0x14,%esp
  801b96:	5b                   	pop    %ebx
  801b97:	5d                   	pop    %ebp
  801b98:	c3                   	ret    

00801b99 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	56                   	push   %esi
  801b9d:	53                   	push   %ebx
  801b9e:	83 ec 10             	sub    $0x10,%esp
  801ba1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801bac:	8b 06                	mov    (%esi),%eax
  801bae:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801bb3:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb8:	e8 76 ff ff ff       	call   801b33 <nsipc>
  801bbd:	89 c3                	mov    %eax,%ebx
  801bbf:	85 c0                	test   %eax,%eax
  801bc1:	78 23                	js     801be6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801bc3:	a1 10 60 80 00       	mov    0x806010,%eax
  801bc8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bcc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bd3:	00 
  801bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd7:	89 04 24             	mov    %eax,(%esp)
  801bda:	e8 55 ee ff ff       	call   800a34 <memmove>
		*addrlen = ret->ret_addrlen;
  801bdf:	a1 10 60 80 00       	mov    0x806010,%eax
  801be4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801be6:	89 d8                	mov    %ebx,%eax
  801be8:	83 c4 10             	add    $0x10,%esp
  801beb:	5b                   	pop    %ebx
  801bec:	5e                   	pop    %esi
  801bed:	5d                   	pop    %ebp
  801bee:	c3                   	ret    

00801bef <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	53                   	push   %ebx
  801bf3:	83 ec 14             	sub    $0x14,%esp
  801bf6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c01:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c13:	e8 1c ee ff ff       	call   800a34 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c18:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c1e:	b8 02 00 00 00       	mov    $0x2,%eax
  801c23:	e8 0b ff ff ff       	call   801b33 <nsipc>
}
  801c28:	83 c4 14             	add    $0x14,%esp
  801c2b:	5b                   	pop    %ebx
  801c2c:	5d                   	pop    %ebp
  801c2d:	c3                   	ret    

00801c2e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c44:	b8 03 00 00 00       	mov    $0x3,%eax
  801c49:	e8 e5 fe ff ff       	call   801b33 <nsipc>
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <nsipc_close>:

int
nsipc_close(int s)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c5e:	b8 04 00 00 00       	mov    $0x4,%eax
  801c63:	e8 cb fe ff ff       	call   801b33 <nsipc>
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	53                   	push   %ebx
  801c6e:	83 ec 14             	sub    $0x14,%esp
  801c71:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c74:	8b 45 08             	mov    0x8(%ebp),%eax
  801c77:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c7c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c87:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c8e:	e8 a1 ed ff ff       	call   800a34 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c93:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c99:	b8 05 00 00 00       	mov    $0x5,%eax
  801c9e:	e8 90 fe ff ff       	call   801b33 <nsipc>
}
  801ca3:	83 c4 14             	add    $0x14,%esp
  801ca6:	5b                   	pop    %ebx
  801ca7:	5d                   	pop    %ebp
  801ca8:	c3                   	ret    

00801ca9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801caf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cba:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801cbf:	b8 06 00 00 00       	mov    $0x6,%eax
  801cc4:	e8 6a fe ff ff       	call   801b33 <nsipc>
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	56                   	push   %esi
  801ccf:	53                   	push   %ebx
  801cd0:	83 ec 10             	sub    $0x10,%esp
  801cd3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801cde:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ce4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cec:	b8 07 00 00 00       	mov    $0x7,%eax
  801cf1:	e8 3d fe ff ff       	call   801b33 <nsipc>
  801cf6:	89 c3                	mov    %eax,%ebx
  801cf8:	85 c0                	test   %eax,%eax
  801cfa:	78 46                	js     801d42 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801cfc:	39 f0                	cmp    %esi,%eax
  801cfe:	7f 07                	jg     801d07 <nsipc_recv+0x3c>
  801d00:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d05:	7e 24                	jle    801d2b <nsipc_recv+0x60>
  801d07:	c7 44 24 0c a7 2b 80 	movl   $0x802ba7,0xc(%esp)
  801d0e:	00 
  801d0f:	c7 44 24 08 6f 2b 80 	movl   $0x802b6f,0x8(%esp)
  801d16:	00 
  801d17:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801d1e:	00 
  801d1f:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  801d26:	e8 4c e4 ff ff       	call   800177 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d2f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d36:	00 
  801d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3a:	89 04 24             	mov    %eax,(%esp)
  801d3d:	e8 f2 ec ff ff       	call   800a34 <memmove>
	}

	return r;
}
  801d42:	89 d8                	mov    %ebx,%eax
  801d44:	83 c4 10             	add    $0x10,%esp
  801d47:	5b                   	pop    %ebx
  801d48:	5e                   	pop    %esi
  801d49:	5d                   	pop    %ebp
  801d4a:	c3                   	ret    

00801d4b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	53                   	push   %ebx
  801d4f:	83 ec 14             	sub    $0x14,%esp
  801d52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d55:	8b 45 08             	mov    0x8(%ebp),%eax
  801d58:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d5d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d63:	7e 24                	jle    801d89 <nsipc_send+0x3e>
  801d65:	c7 44 24 0c c8 2b 80 	movl   $0x802bc8,0xc(%esp)
  801d6c:	00 
  801d6d:	c7 44 24 08 6f 2b 80 	movl   $0x802b6f,0x8(%esp)
  801d74:	00 
  801d75:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801d7c:	00 
  801d7d:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  801d84:	e8 ee e3 ff ff       	call   800177 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d89:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d94:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801d9b:	e8 94 ec ff ff       	call   800a34 <memmove>
	nsipcbuf.send.req_size = size;
  801da0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801da6:	8b 45 14             	mov    0x14(%ebp),%eax
  801da9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801dae:	b8 08 00 00 00       	mov    $0x8,%eax
  801db3:	e8 7b fd ff ff       	call   801b33 <nsipc>
}
  801db8:	83 c4 14             	add    $0x14,%esp
  801dbb:	5b                   	pop    %ebx
  801dbc:	5d                   	pop    %ebp
  801dbd:	c3                   	ret    

00801dbe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dcf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801dd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ddc:	b8 09 00 00 00       	mov    $0x9,%eax
  801de1:	e8 4d fd ff ff       	call   801b33 <nsipc>
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	56                   	push   %esi
  801dec:	53                   	push   %ebx
  801ded:	83 ec 10             	sub    $0x10,%esp
  801df0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801df3:	8b 45 08             	mov    0x8(%ebp),%eax
  801df6:	89 04 24             	mov    %eax,(%esp)
  801df9:	e8 12 f2 ff ff       	call   801010 <fd2data>
  801dfe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e00:	c7 44 24 04 d4 2b 80 	movl   $0x802bd4,0x4(%esp)
  801e07:	00 
  801e08:	89 1c 24             	mov    %ebx,(%esp)
  801e0b:	e8 87 ea ff ff       	call   800897 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e10:	8b 46 04             	mov    0x4(%esi),%eax
  801e13:	2b 06                	sub    (%esi),%eax
  801e15:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e1b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e22:	00 00 00 
	stat->st_dev = &devpipe;
  801e25:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e2c:	30 80 00 
	return 0;
}
  801e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	5b                   	pop    %ebx
  801e38:	5e                   	pop    %esi
  801e39:	5d                   	pop    %ebp
  801e3a:	c3                   	ret    

00801e3b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
  801e3e:	53                   	push   %ebx
  801e3f:	83 ec 14             	sub    $0x14,%esp
  801e42:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e45:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e50:	e8 05 ef ff ff       	call   800d5a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e55:	89 1c 24             	mov    %ebx,(%esp)
  801e58:	e8 b3 f1 ff ff       	call   801010 <fd2data>
  801e5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e68:	e8 ed ee ff ff       	call   800d5a <sys_page_unmap>
}
  801e6d:	83 c4 14             	add    $0x14,%esp
  801e70:	5b                   	pop    %ebx
  801e71:	5d                   	pop    %ebp
  801e72:	c3                   	ret    

00801e73 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	57                   	push   %edi
  801e77:	56                   	push   %esi
  801e78:	53                   	push   %ebx
  801e79:	83 ec 2c             	sub    $0x2c,%esp
  801e7c:	89 c6                	mov    %eax,%esi
  801e7e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e81:	a1 08 40 80 00       	mov    0x804008,%eax
  801e86:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e89:	89 34 24             	mov    %esi,(%esp)
  801e8c:	e8 be 05 00 00       	call   80244f <pageref>
  801e91:	89 c7                	mov    %eax,%edi
  801e93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e96:	89 04 24             	mov    %eax,(%esp)
  801e99:	e8 b1 05 00 00       	call   80244f <pageref>
  801e9e:	39 c7                	cmp    %eax,%edi
  801ea0:	0f 94 c2             	sete   %dl
  801ea3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801ea6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801eac:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801eaf:	39 fb                	cmp    %edi,%ebx
  801eb1:	74 21                	je     801ed4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801eb3:	84 d2                	test   %dl,%dl
  801eb5:	74 ca                	je     801e81 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801eb7:	8b 51 58             	mov    0x58(%ecx),%edx
  801eba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ebe:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ec2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ec6:	c7 04 24 db 2b 80 00 	movl   $0x802bdb,(%esp)
  801ecd:	e8 9e e3 ff ff       	call   800270 <cprintf>
  801ed2:	eb ad                	jmp    801e81 <_pipeisclosed+0xe>
	}
}
  801ed4:	83 c4 2c             	add    $0x2c,%esp
  801ed7:	5b                   	pop    %ebx
  801ed8:	5e                   	pop    %esi
  801ed9:	5f                   	pop    %edi
  801eda:	5d                   	pop    %ebp
  801edb:	c3                   	ret    

00801edc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	57                   	push   %edi
  801ee0:	56                   	push   %esi
  801ee1:	53                   	push   %ebx
  801ee2:	83 ec 1c             	sub    $0x1c,%esp
  801ee5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801ee8:	89 34 24             	mov    %esi,(%esp)
  801eeb:	e8 20 f1 ff ff       	call   801010 <fd2data>
  801ef0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ef2:	bf 00 00 00 00       	mov    $0x0,%edi
  801ef7:	eb 45                	jmp    801f3e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801ef9:	89 da                	mov    %ebx,%edx
  801efb:	89 f0                	mov    %esi,%eax
  801efd:	e8 71 ff ff ff       	call   801e73 <_pipeisclosed>
  801f02:	85 c0                	test   %eax,%eax
  801f04:	75 41                	jne    801f47 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f06:	e8 89 ed ff ff       	call   800c94 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f0b:	8b 43 04             	mov    0x4(%ebx),%eax
  801f0e:	8b 0b                	mov    (%ebx),%ecx
  801f10:	8d 51 20             	lea    0x20(%ecx),%edx
  801f13:	39 d0                	cmp    %edx,%eax
  801f15:	73 e2                	jae    801ef9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f1a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f1e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f21:	99                   	cltd   
  801f22:	c1 ea 1b             	shr    $0x1b,%edx
  801f25:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801f28:	83 e1 1f             	and    $0x1f,%ecx
  801f2b:	29 d1                	sub    %edx,%ecx
  801f2d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801f31:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801f35:	83 c0 01             	add    $0x1,%eax
  801f38:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f3b:	83 c7 01             	add    $0x1,%edi
  801f3e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f41:	75 c8                	jne    801f0b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801f43:	89 f8                	mov    %edi,%eax
  801f45:	eb 05                	jmp    801f4c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801f4c:	83 c4 1c             	add    $0x1c,%esp
  801f4f:	5b                   	pop    %ebx
  801f50:	5e                   	pop    %esi
  801f51:	5f                   	pop    %edi
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    

00801f54 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	57                   	push   %edi
  801f58:	56                   	push   %esi
  801f59:	53                   	push   %ebx
  801f5a:	83 ec 1c             	sub    $0x1c,%esp
  801f5d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f60:	89 3c 24             	mov    %edi,(%esp)
  801f63:	e8 a8 f0 ff ff       	call   801010 <fd2data>
  801f68:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f6a:	be 00 00 00 00       	mov    $0x0,%esi
  801f6f:	eb 3d                	jmp    801fae <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f71:	85 f6                	test   %esi,%esi
  801f73:	74 04                	je     801f79 <devpipe_read+0x25>
				return i;
  801f75:	89 f0                	mov    %esi,%eax
  801f77:	eb 43                	jmp    801fbc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f79:	89 da                	mov    %ebx,%edx
  801f7b:	89 f8                	mov    %edi,%eax
  801f7d:	e8 f1 fe ff ff       	call   801e73 <_pipeisclosed>
  801f82:	85 c0                	test   %eax,%eax
  801f84:	75 31                	jne    801fb7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f86:	e8 09 ed ff ff       	call   800c94 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f8b:	8b 03                	mov    (%ebx),%eax
  801f8d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f90:	74 df                	je     801f71 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f92:	99                   	cltd   
  801f93:	c1 ea 1b             	shr    $0x1b,%edx
  801f96:	01 d0                	add    %edx,%eax
  801f98:	83 e0 1f             	and    $0x1f,%eax
  801f9b:	29 d0                	sub    %edx,%eax
  801f9d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801fa2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801fa5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801fa8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fab:	83 c6 01             	add    $0x1,%esi
  801fae:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fb1:	75 d8                	jne    801f8b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801fb3:	89 f0                	mov    %esi,%eax
  801fb5:	eb 05                	jmp    801fbc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fb7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801fbc:	83 c4 1c             	add    $0x1c,%esp
  801fbf:	5b                   	pop    %ebx
  801fc0:	5e                   	pop    %esi
  801fc1:	5f                   	pop    %edi
  801fc2:	5d                   	pop    %ebp
  801fc3:	c3                   	ret    

00801fc4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	56                   	push   %esi
  801fc8:	53                   	push   %ebx
  801fc9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801fcc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fcf:	89 04 24             	mov    %eax,(%esp)
  801fd2:	e8 50 f0 ff ff       	call   801027 <fd_alloc>
  801fd7:	89 c2                	mov    %eax,%edx
  801fd9:	85 d2                	test   %edx,%edx
  801fdb:	0f 88 4d 01 00 00    	js     80212e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fe1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fe8:	00 
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ff7:	e8 b7 ec ff ff       	call   800cb3 <sys_page_alloc>
  801ffc:	89 c2                	mov    %eax,%edx
  801ffe:	85 d2                	test   %edx,%edx
  802000:	0f 88 28 01 00 00    	js     80212e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802006:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802009:	89 04 24             	mov    %eax,(%esp)
  80200c:	e8 16 f0 ff ff       	call   801027 <fd_alloc>
  802011:	89 c3                	mov    %eax,%ebx
  802013:	85 c0                	test   %eax,%eax
  802015:	0f 88 fe 00 00 00    	js     802119 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80201b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802022:	00 
  802023:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802026:	89 44 24 04          	mov    %eax,0x4(%esp)
  80202a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802031:	e8 7d ec ff ff       	call   800cb3 <sys_page_alloc>
  802036:	89 c3                	mov    %eax,%ebx
  802038:	85 c0                	test   %eax,%eax
  80203a:	0f 88 d9 00 00 00    	js     802119 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802043:	89 04 24             	mov    %eax,(%esp)
  802046:	e8 c5 ef ff ff       	call   801010 <fd2data>
  80204b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80204d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802054:	00 
  802055:	89 44 24 04          	mov    %eax,0x4(%esp)
  802059:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802060:	e8 4e ec ff ff       	call   800cb3 <sys_page_alloc>
  802065:	89 c3                	mov    %eax,%ebx
  802067:	85 c0                	test   %eax,%eax
  802069:	0f 88 97 00 00 00    	js     802106 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80206f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802072:	89 04 24             	mov    %eax,(%esp)
  802075:	e8 96 ef ff ff       	call   801010 <fd2data>
  80207a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802081:	00 
  802082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802086:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80208d:	00 
  80208e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802092:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802099:	e8 69 ec ff ff       	call   800d07 <sys_page_map>
  80209e:	89 c3                	mov    %eax,%ebx
  8020a0:	85 c0                	test   %eax,%eax
  8020a2:	78 52                	js     8020f6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8020a4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8020af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8020b9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8020c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8020ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d1:	89 04 24             	mov    %eax,(%esp)
  8020d4:	e8 27 ef ff ff       	call   801000 <fd2num>
  8020d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020dc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e1:	89 04 24             	mov    %eax,(%esp)
  8020e4:	e8 17 ef ff ff       	call   801000 <fd2num>
  8020e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020ec:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f4:	eb 38                	jmp    80212e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8020f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802101:	e8 54 ec ff ff       	call   800d5a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802106:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802109:	89 44 24 04          	mov    %eax,0x4(%esp)
  80210d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802114:	e8 41 ec ff ff       	call   800d5a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802120:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802127:	e8 2e ec ff ff       	call   800d5a <sys_page_unmap>
  80212c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80212e:	83 c4 30             	add    $0x30,%esp
  802131:	5b                   	pop    %ebx
  802132:	5e                   	pop    %esi
  802133:	5d                   	pop    %ebp
  802134:	c3                   	ret    

00802135 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80213b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	89 04 24             	mov    %eax,(%esp)
  802148:	e8 29 ef ff ff       	call   801076 <fd_lookup>
  80214d:	89 c2                	mov    %eax,%edx
  80214f:	85 d2                	test   %edx,%edx
  802151:	78 15                	js     802168 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802156:	89 04 24             	mov    %eax,(%esp)
  802159:	e8 b2 ee ff ff       	call   801010 <fd2data>
	return _pipeisclosed(fd, p);
  80215e:	89 c2                	mov    %eax,%edx
  802160:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802163:	e8 0b fd ff ff       	call   801e73 <_pipeisclosed>
}
  802168:	c9                   	leave  
  802169:	c3                   	ret    
  80216a:	66 90                	xchg   %ax,%ax
  80216c:	66 90                	xchg   %ax,%ax
  80216e:	66 90                	xchg   %ax,%ax

00802170 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802173:	b8 00 00 00 00       	mov    $0x0,%eax
  802178:	5d                   	pop    %ebp
  802179:	c3                   	ret    

0080217a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802180:	c7 44 24 04 f3 2b 80 	movl   $0x802bf3,0x4(%esp)
  802187:	00 
  802188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218b:	89 04 24             	mov    %eax,(%esp)
  80218e:	e8 04 e7 ff ff       	call   800897 <strcpy>
	return 0;
}
  802193:	b8 00 00 00 00       	mov    $0x0,%eax
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	57                   	push   %edi
  80219e:	56                   	push   %esi
  80219f:	53                   	push   %ebx
  8021a0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8021ab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021b1:	eb 31                	jmp    8021e4 <devcons_write+0x4a>
		m = n - tot;
  8021b3:	8b 75 10             	mov    0x10(%ebp),%esi
  8021b6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8021b8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8021bb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8021c0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8021c3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8021c7:	03 45 0c             	add    0xc(%ebp),%eax
  8021ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ce:	89 3c 24             	mov    %edi,(%esp)
  8021d1:	e8 5e e8 ff ff       	call   800a34 <memmove>
		sys_cputs(buf, m);
  8021d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021da:	89 3c 24             	mov    %edi,(%esp)
  8021dd:	e8 04 ea ff ff       	call   800be6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021e2:	01 f3                	add    %esi,%ebx
  8021e4:	89 d8                	mov    %ebx,%eax
  8021e6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8021e9:	72 c8                	jb     8021b3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8021eb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8021f1:	5b                   	pop    %ebx
  8021f2:	5e                   	pop    %esi
  8021f3:	5f                   	pop    %edi
  8021f4:	5d                   	pop    %ebp
  8021f5:	c3                   	ret    

008021f6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802201:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802205:	75 07                	jne    80220e <devcons_read+0x18>
  802207:	eb 2a                	jmp    802233 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802209:	e8 86 ea ff ff       	call   800c94 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80220e:	66 90                	xchg   %ax,%ax
  802210:	e8 ef e9 ff ff       	call   800c04 <sys_cgetc>
  802215:	85 c0                	test   %eax,%eax
  802217:	74 f0                	je     802209 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802219:	85 c0                	test   %eax,%eax
  80221b:	78 16                	js     802233 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80221d:	83 f8 04             	cmp    $0x4,%eax
  802220:	74 0c                	je     80222e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802222:	8b 55 0c             	mov    0xc(%ebp),%edx
  802225:	88 02                	mov    %al,(%edx)
	return 1;
  802227:	b8 01 00 00 00       	mov    $0x1,%eax
  80222c:	eb 05                	jmp    802233 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80222e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802241:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802248:	00 
  802249:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80224c:	89 04 24             	mov    %eax,(%esp)
  80224f:	e8 92 e9 ff ff       	call   800be6 <sys_cputs>
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <getchar>:

int
getchar(void)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80225c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802263:	00 
  802264:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802267:	89 44 24 04          	mov    %eax,0x4(%esp)
  80226b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802272:	e8 93 f0 ff ff       	call   80130a <read>
	if (r < 0)
  802277:	85 c0                	test   %eax,%eax
  802279:	78 0f                	js     80228a <getchar+0x34>
		return r;
	if (r < 1)
  80227b:	85 c0                	test   %eax,%eax
  80227d:	7e 06                	jle    802285 <getchar+0x2f>
		return -E_EOF;
	return c;
  80227f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802283:	eb 05                	jmp    80228a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802285:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80228a:	c9                   	leave  
  80228b:	c3                   	ret    

0080228c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
  80228f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802292:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802295:	89 44 24 04          	mov    %eax,0x4(%esp)
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	89 04 24             	mov    %eax,(%esp)
  80229f:	e8 d2 ed ff ff       	call   801076 <fd_lookup>
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	78 11                	js     8022b9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ab:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022b1:	39 10                	cmp    %edx,(%eax)
  8022b3:	0f 94 c0             	sete   %al
  8022b6:	0f b6 c0             	movzbl %al,%eax
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <opencons>:

int
opencons(void)
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
  8022be:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8022c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022c4:	89 04 24             	mov    %eax,(%esp)
  8022c7:	e8 5b ed ff ff       	call   801027 <fd_alloc>
		return r;
  8022cc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8022ce:	85 c0                	test   %eax,%eax
  8022d0:	78 40                	js     802312 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022d9:	00 
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022e8:	e8 c6 e9 ff ff       	call   800cb3 <sys_page_alloc>
		return r;
  8022ed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	78 1f                	js     802312 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8022f3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802301:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802308:	89 04 24             	mov    %eax,(%esp)
  80230b:	e8 f0 ec ff ff       	call   801000 <fd2num>
  802310:	89 c2                	mov    %eax,%edx
}
  802312:	89 d0                	mov    %edx,%eax
  802314:	c9                   	leave  
  802315:	c3                   	ret    
  802316:	66 90                	xchg   %ax,%ax
  802318:	66 90                	xchg   %ax,%ax
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	66 90                	xchg   %ax,%ax
  80231e:	66 90                	xchg   %ax,%ax

00802320 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	56                   	push   %esi
  802324:	53                   	push   %ebx
  802325:	83 ec 10             	sub    $0x10,%esp
  802328:	8b 75 08             	mov    0x8(%ebp),%esi
  80232b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802331:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802333:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802338:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80233b:	89 04 24             	mov    %eax,(%esp)
  80233e:	e8 86 eb ff ff       	call   800ec9 <sys_ipc_recv>
  802343:	85 c0                	test   %eax,%eax
  802345:	74 16                	je     80235d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802347:	85 f6                	test   %esi,%esi
  802349:	74 06                	je     802351 <ipc_recv+0x31>
			*from_env_store = 0;
  80234b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802351:	85 db                	test   %ebx,%ebx
  802353:	74 2c                	je     802381 <ipc_recv+0x61>
			*perm_store = 0;
  802355:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80235b:	eb 24                	jmp    802381 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80235d:	85 f6                	test   %esi,%esi
  80235f:	74 0a                	je     80236b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802361:	a1 08 40 80 00       	mov    0x804008,%eax
  802366:	8b 40 74             	mov    0x74(%eax),%eax
  802369:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80236b:	85 db                	test   %ebx,%ebx
  80236d:	74 0a                	je     802379 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80236f:	a1 08 40 80 00       	mov    0x804008,%eax
  802374:	8b 40 78             	mov    0x78(%eax),%eax
  802377:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802379:	a1 08 40 80 00       	mov    0x804008,%eax
  80237e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802381:	83 c4 10             	add    $0x10,%esp
  802384:	5b                   	pop    %ebx
  802385:	5e                   	pop    %esi
  802386:	5d                   	pop    %ebp
  802387:	c3                   	ret    

00802388 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
  80238b:	57                   	push   %edi
  80238c:	56                   	push   %esi
  80238d:	53                   	push   %ebx
  80238e:	83 ec 1c             	sub    $0x1c,%esp
  802391:	8b 75 0c             	mov    0xc(%ebp),%esi
  802394:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802397:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80239a:	85 db                	test   %ebx,%ebx
  80239c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8023a1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8023a4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	89 04 24             	mov    %eax,(%esp)
  8023b6:	e8 eb ea ff ff       	call   800ea6 <sys_ipc_try_send>
	if (r == 0) return;
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	75 22                	jne    8023e1 <ipc_send+0x59>
  8023bf:	eb 4c                	jmp    80240d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  8023c1:	84 d2                	test   %dl,%dl
  8023c3:	75 48                	jne    80240d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  8023c5:	e8 ca e8 ff ff       	call   800c94 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  8023ca:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023ce:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	89 04 24             	mov    %eax,(%esp)
  8023dc:	e8 c5 ea ff ff       	call   800ea6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	0f 94 c2             	sete   %dl
  8023e6:	74 d9                	je     8023c1 <ipc_send+0x39>
  8023e8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023eb:	74 d4                	je     8023c1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  8023ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023f1:	c7 44 24 08 ff 2b 80 	movl   $0x802bff,0x8(%esp)
  8023f8:	00 
  8023f9:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802400:	00 
  802401:	c7 04 24 0d 2c 80 00 	movl   $0x802c0d,(%esp)
  802408:	e8 6a dd ff ff       	call   800177 <_panic>
}
  80240d:	83 c4 1c             	add    $0x1c,%esp
  802410:	5b                   	pop    %ebx
  802411:	5e                   	pop    %esi
  802412:	5f                   	pop    %edi
  802413:	5d                   	pop    %ebp
  802414:	c3                   	ret    

00802415 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80241b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802420:	89 c2                	mov    %eax,%edx
  802422:	c1 e2 07             	shl    $0x7,%edx
  802425:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80242b:	8b 52 50             	mov    0x50(%edx),%edx
  80242e:	39 ca                	cmp    %ecx,%edx
  802430:	75 0d                	jne    80243f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802432:	c1 e0 07             	shl    $0x7,%eax
  802435:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80243a:	8b 40 40             	mov    0x40(%eax),%eax
  80243d:	eb 0e                	jmp    80244d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80243f:	83 c0 01             	add    $0x1,%eax
  802442:	3d 00 04 00 00       	cmp    $0x400,%eax
  802447:	75 d7                	jne    802420 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802449:	66 b8 00 00          	mov    $0x0,%ax
}
  80244d:	5d                   	pop    %ebp
  80244e:	c3                   	ret    

0080244f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
  802452:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802455:	89 d0                	mov    %edx,%eax
  802457:	c1 e8 16             	shr    $0x16,%eax
  80245a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802461:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802466:	f6 c1 01             	test   $0x1,%cl
  802469:	74 1d                	je     802488 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80246b:	c1 ea 0c             	shr    $0xc,%edx
  80246e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802475:	f6 c2 01             	test   $0x1,%dl
  802478:	74 0e                	je     802488 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80247a:	c1 ea 0c             	shr    $0xc,%edx
  80247d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802484:	ef 
  802485:	0f b7 c0             	movzwl %ax,%eax
}
  802488:	5d                   	pop    %ebp
  802489:	c3                   	ret    
  80248a:	66 90                	xchg   %ax,%ax
  80248c:	66 90                	xchg   %ax,%ax
  80248e:	66 90                	xchg   %ax,%ax

00802490 <__udivdi3>:
  802490:	55                   	push   %ebp
  802491:	57                   	push   %edi
  802492:	56                   	push   %esi
  802493:	83 ec 0c             	sub    $0xc,%esp
  802496:	8b 44 24 28          	mov    0x28(%esp),%eax
  80249a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80249e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8024a2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024ac:	89 ea                	mov    %ebp,%edx
  8024ae:	89 0c 24             	mov    %ecx,(%esp)
  8024b1:	75 2d                	jne    8024e0 <__udivdi3+0x50>
  8024b3:	39 e9                	cmp    %ebp,%ecx
  8024b5:	77 61                	ja     802518 <__udivdi3+0x88>
  8024b7:	85 c9                	test   %ecx,%ecx
  8024b9:	89 ce                	mov    %ecx,%esi
  8024bb:	75 0b                	jne    8024c8 <__udivdi3+0x38>
  8024bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c2:	31 d2                	xor    %edx,%edx
  8024c4:	f7 f1                	div    %ecx
  8024c6:	89 c6                	mov    %eax,%esi
  8024c8:	31 d2                	xor    %edx,%edx
  8024ca:	89 e8                	mov    %ebp,%eax
  8024cc:	f7 f6                	div    %esi
  8024ce:	89 c5                	mov    %eax,%ebp
  8024d0:	89 f8                	mov    %edi,%eax
  8024d2:	f7 f6                	div    %esi
  8024d4:	89 ea                	mov    %ebp,%edx
  8024d6:	83 c4 0c             	add    $0xc,%esp
  8024d9:	5e                   	pop    %esi
  8024da:	5f                   	pop    %edi
  8024db:	5d                   	pop    %ebp
  8024dc:	c3                   	ret    
  8024dd:	8d 76 00             	lea    0x0(%esi),%esi
  8024e0:	39 e8                	cmp    %ebp,%eax
  8024e2:	77 24                	ja     802508 <__udivdi3+0x78>
  8024e4:	0f bd e8             	bsr    %eax,%ebp
  8024e7:	83 f5 1f             	xor    $0x1f,%ebp
  8024ea:	75 3c                	jne    802528 <__udivdi3+0x98>
  8024ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8024f0:	39 34 24             	cmp    %esi,(%esp)
  8024f3:	0f 86 9f 00 00 00    	jbe    802598 <__udivdi3+0x108>
  8024f9:	39 d0                	cmp    %edx,%eax
  8024fb:	0f 82 97 00 00 00    	jb     802598 <__udivdi3+0x108>
  802501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802508:	31 d2                	xor    %edx,%edx
  80250a:	31 c0                	xor    %eax,%eax
  80250c:	83 c4 0c             	add    $0xc,%esp
  80250f:	5e                   	pop    %esi
  802510:	5f                   	pop    %edi
  802511:	5d                   	pop    %ebp
  802512:	c3                   	ret    
  802513:	90                   	nop
  802514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802518:	89 f8                	mov    %edi,%eax
  80251a:	f7 f1                	div    %ecx
  80251c:	31 d2                	xor    %edx,%edx
  80251e:	83 c4 0c             	add    $0xc,%esp
  802521:	5e                   	pop    %esi
  802522:	5f                   	pop    %edi
  802523:	5d                   	pop    %ebp
  802524:	c3                   	ret    
  802525:	8d 76 00             	lea    0x0(%esi),%esi
  802528:	89 e9                	mov    %ebp,%ecx
  80252a:	8b 3c 24             	mov    (%esp),%edi
  80252d:	d3 e0                	shl    %cl,%eax
  80252f:	89 c6                	mov    %eax,%esi
  802531:	b8 20 00 00 00       	mov    $0x20,%eax
  802536:	29 e8                	sub    %ebp,%eax
  802538:	89 c1                	mov    %eax,%ecx
  80253a:	d3 ef                	shr    %cl,%edi
  80253c:	89 e9                	mov    %ebp,%ecx
  80253e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802542:	8b 3c 24             	mov    (%esp),%edi
  802545:	09 74 24 08          	or     %esi,0x8(%esp)
  802549:	89 d6                	mov    %edx,%esi
  80254b:	d3 e7                	shl    %cl,%edi
  80254d:	89 c1                	mov    %eax,%ecx
  80254f:	89 3c 24             	mov    %edi,(%esp)
  802552:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802556:	d3 ee                	shr    %cl,%esi
  802558:	89 e9                	mov    %ebp,%ecx
  80255a:	d3 e2                	shl    %cl,%edx
  80255c:	89 c1                	mov    %eax,%ecx
  80255e:	d3 ef                	shr    %cl,%edi
  802560:	09 d7                	or     %edx,%edi
  802562:	89 f2                	mov    %esi,%edx
  802564:	89 f8                	mov    %edi,%eax
  802566:	f7 74 24 08          	divl   0x8(%esp)
  80256a:	89 d6                	mov    %edx,%esi
  80256c:	89 c7                	mov    %eax,%edi
  80256e:	f7 24 24             	mull   (%esp)
  802571:	39 d6                	cmp    %edx,%esi
  802573:	89 14 24             	mov    %edx,(%esp)
  802576:	72 30                	jb     8025a8 <__udivdi3+0x118>
  802578:	8b 54 24 04          	mov    0x4(%esp),%edx
  80257c:	89 e9                	mov    %ebp,%ecx
  80257e:	d3 e2                	shl    %cl,%edx
  802580:	39 c2                	cmp    %eax,%edx
  802582:	73 05                	jae    802589 <__udivdi3+0xf9>
  802584:	3b 34 24             	cmp    (%esp),%esi
  802587:	74 1f                	je     8025a8 <__udivdi3+0x118>
  802589:	89 f8                	mov    %edi,%eax
  80258b:	31 d2                	xor    %edx,%edx
  80258d:	e9 7a ff ff ff       	jmp    80250c <__udivdi3+0x7c>
  802592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802598:	31 d2                	xor    %edx,%edx
  80259a:	b8 01 00 00 00       	mov    $0x1,%eax
  80259f:	e9 68 ff ff ff       	jmp    80250c <__udivdi3+0x7c>
  8025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025a8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8025ab:	31 d2                	xor    %edx,%edx
  8025ad:	83 c4 0c             	add    $0xc,%esp
  8025b0:	5e                   	pop    %esi
  8025b1:	5f                   	pop    %edi
  8025b2:	5d                   	pop    %ebp
  8025b3:	c3                   	ret    
  8025b4:	66 90                	xchg   %ax,%ax
  8025b6:	66 90                	xchg   %ax,%ax
  8025b8:	66 90                	xchg   %ax,%ax
  8025ba:	66 90                	xchg   %ax,%ax
  8025bc:	66 90                	xchg   %ax,%ax
  8025be:	66 90                	xchg   %ax,%ax

008025c0 <__umoddi3>:
  8025c0:	55                   	push   %ebp
  8025c1:	57                   	push   %edi
  8025c2:	56                   	push   %esi
  8025c3:	83 ec 14             	sub    $0x14,%esp
  8025c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025ca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025ce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8025d2:	89 c7                	mov    %eax,%edi
  8025d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8025dc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8025e0:	89 34 24             	mov    %esi,(%esp)
  8025e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	89 c2                	mov    %eax,%edx
  8025eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025ef:	75 17                	jne    802608 <__umoddi3+0x48>
  8025f1:	39 fe                	cmp    %edi,%esi
  8025f3:	76 4b                	jbe    802640 <__umoddi3+0x80>
  8025f5:	89 c8                	mov    %ecx,%eax
  8025f7:	89 fa                	mov    %edi,%edx
  8025f9:	f7 f6                	div    %esi
  8025fb:	89 d0                	mov    %edx,%eax
  8025fd:	31 d2                	xor    %edx,%edx
  8025ff:	83 c4 14             	add    $0x14,%esp
  802602:	5e                   	pop    %esi
  802603:	5f                   	pop    %edi
  802604:	5d                   	pop    %ebp
  802605:	c3                   	ret    
  802606:	66 90                	xchg   %ax,%ax
  802608:	39 f8                	cmp    %edi,%eax
  80260a:	77 54                	ja     802660 <__umoddi3+0xa0>
  80260c:	0f bd e8             	bsr    %eax,%ebp
  80260f:	83 f5 1f             	xor    $0x1f,%ebp
  802612:	75 5c                	jne    802670 <__umoddi3+0xb0>
  802614:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802618:	39 3c 24             	cmp    %edi,(%esp)
  80261b:	0f 87 e7 00 00 00    	ja     802708 <__umoddi3+0x148>
  802621:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802625:	29 f1                	sub    %esi,%ecx
  802627:	19 c7                	sbb    %eax,%edi
  802629:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80262d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802631:	8b 44 24 08          	mov    0x8(%esp),%eax
  802635:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802639:	83 c4 14             	add    $0x14,%esp
  80263c:	5e                   	pop    %esi
  80263d:	5f                   	pop    %edi
  80263e:	5d                   	pop    %ebp
  80263f:	c3                   	ret    
  802640:	85 f6                	test   %esi,%esi
  802642:	89 f5                	mov    %esi,%ebp
  802644:	75 0b                	jne    802651 <__umoddi3+0x91>
  802646:	b8 01 00 00 00       	mov    $0x1,%eax
  80264b:	31 d2                	xor    %edx,%edx
  80264d:	f7 f6                	div    %esi
  80264f:	89 c5                	mov    %eax,%ebp
  802651:	8b 44 24 04          	mov    0x4(%esp),%eax
  802655:	31 d2                	xor    %edx,%edx
  802657:	f7 f5                	div    %ebp
  802659:	89 c8                	mov    %ecx,%eax
  80265b:	f7 f5                	div    %ebp
  80265d:	eb 9c                	jmp    8025fb <__umoddi3+0x3b>
  80265f:	90                   	nop
  802660:	89 c8                	mov    %ecx,%eax
  802662:	89 fa                	mov    %edi,%edx
  802664:	83 c4 14             	add    $0x14,%esp
  802667:	5e                   	pop    %esi
  802668:	5f                   	pop    %edi
  802669:	5d                   	pop    %ebp
  80266a:	c3                   	ret    
  80266b:	90                   	nop
  80266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802670:	8b 04 24             	mov    (%esp),%eax
  802673:	be 20 00 00 00       	mov    $0x20,%esi
  802678:	89 e9                	mov    %ebp,%ecx
  80267a:	29 ee                	sub    %ebp,%esi
  80267c:	d3 e2                	shl    %cl,%edx
  80267e:	89 f1                	mov    %esi,%ecx
  802680:	d3 e8                	shr    %cl,%eax
  802682:	89 e9                	mov    %ebp,%ecx
  802684:	89 44 24 04          	mov    %eax,0x4(%esp)
  802688:	8b 04 24             	mov    (%esp),%eax
  80268b:	09 54 24 04          	or     %edx,0x4(%esp)
  80268f:	89 fa                	mov    %edi,%edx
  802691:	d3 e0                	shl    %cl,%eax
  802693:	89 f1                	mov    %esi,%ecx
  802695:	89 44 24 08          	mov    %eax,0x8(%esp)
  802699:	8b 44 24 10          	mov    0x10(%esp),%eax
  80269d:	d3 ea                	shr    %cl,%edx
  80269f:	89 e9                	mov    %ebp,%ecx
  8026a1:	d3 e7                	shl    %cl,%edi
  8026a3:	89 f1                	mov    %esi,%ecx
  8026a5:	d3 e8                	shr    %cl,%eax
  8026a7:	89 e9                	mov    %ebp,%ecx
  8026a9:	09 f8                	or     %edi,%eax
  8026ab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8026af:	f7 74 24 04          	divl   0x4(%esp)
  8026b3:	d3 e7                	shl    %cl,%edi
  8026b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026b9:	89 d7                	mov    %edx,%edi
  8026bb:	f7 64 24 08          	mull   0x8(%esp)
  8026bf:	39 d7                	cmp    %edx,%edi
  8026c1:	89 c1                	mov    %eax,%ecx
  8026c3:	89 14 24             	mov    %edx,(%esp)
  8026c6:	72 2c                	jb     8026f4 <__umoddi3+0x134>
  8026c8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8026cc:	72 22                	jb     8026f0 <__umoddi3+0x130>
  8026ce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8026d2:	29 c8                	sub    %ecx,%eax
  8026d4:	19 d7                	sbb    %edx,%edi
  8026d6:	89 e9                	mov    %ebp,%ecx
  8026d8:	89 fa                	mov    %edi,%edx
  8026da:	d3 e8                	shr    %cl,%eax
  8026dc:	89 f1                	mov    %esi,%ecx
  8026de:	d3 e2                	shl    %cl,%edx
  8026e0:	89 e9                	mov    %ebp,%ecx
  8026e2:	d3 ef                	shr    %cl,%edi
  8026e4:	09 d0                	or     %edx,%eax
  8026e6:	89 fa                	mov    %edi,%edx
  8026e8:	83 c4 14             	add    $0x14,%esp
  8026eb:	5e                   	pop    %esi
  8026ec:	5f                   	pop    %edi
  8026ed:	5d                   	pop    %ebp
  8026ee:	c3                   	ret    
  8026ef:	90                   	nop
  8026f0:	39 d7                	cmp    %edx,%edi
  8026f2:	75 da                	jne    8026ce <__umoddi3+0x10e>
  8026f4:	8b 14 24             	mov    (%esp),%edx
  8026f7:	89 c1                	mov    %eax,%ecx
  8026f9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8026fd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802701:	eb cb                	jmp    8026ce <__umoddi3+0x10e>
  802703:	90                   	nop
  802704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802708:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80270c:	0f 82 0f ff ff ff    	jb     802621 <__umoddi3+0x61>
  802712:	e9 1a ff ff ff       	jmp    802631 <__umoddi3+0x71>
