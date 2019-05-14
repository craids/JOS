
obj/user/pingpongs.debug:     file format elf32-i386


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
  80002c:	e8 16 01 00 00       	call   800147 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t val;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 3c             	sub    $0x3c,%esp
	envid_t who;
	uint32_t i;

	i = 0;
	if ((who = sfork()) != 0) {
  80003c:	e8 71 13 00 00       	call   8013b2 <sfork>
  800041:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800044:	85 c0                	test   %eax,%eax
  800046:	74 5e                	je     8000a6 <umain+0x73>
		cprintf("i am %08x; thisenv is %p\n", sys_getenvid(), thisenv);
  800048:	8b 1d 0c 50 80 00    	mov    0x80500c,%ebx
  80004e:	e8 02 0c 00 00       	call   800c55 <sys_getenvid>
  800053:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800057:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005b:	c7 04 24 00 2c 80 00 	movl   $0x802c00,(%esp)
  800062:	e8 e4 01 00 00       	call   80024b <cprintf>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  800067:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80006a:	e8 e6 0b 00 00       	call   800c55 <sys_getenvid>
  80006f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800073:	89 44 24 04          	mov    %eax,0x4(%esp)
  800077:	c7 04 24 1a 2c 80 00 	movl   $0x802c1a,(%esp)
  80007e:	e8 c8 01 00 00       	call   80024b <cprintf>
		ipc_send(who, 0, 0, 0);
  800083:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80008a:	00 
  80008b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800092:	00 
  800093:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80009a:	00 
  80009b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80009e:	89 04 24             	mov    %eax,(%esp)
  8000a1:	e8 a2 13 00 00       	call   801448 <ipc_send>
	}

	while (1) {
		ipc_recv(&who, 0, 0);
  8000a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b5:	00 
  8000b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8000b9:	89 04 24             	mov    %eax,(%esp)
  8000bc:	e8 1f 13 00 00       	call   8013e0 <ipc_recv>
		cprintf("%x got %d from %x (thisenv is %p %x)\n", sys_getenvid(), val, who, thisenv, thisenv->env_id);
  8000c1:	8b 1d 0c 50 80 00    	mov    0x80500c,%ebx
  8000c7:	8b 7b 48             	mov    0x48(%ebx),%edi
  8000ca:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8000cd:	a1 08 50 80 00       	mov    0x805008,%eax
  8000d2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000d5:	e8 7b 0b 00 00       	call   800c55 <sys_getenvid>
  8000da:	89 7c 24 14          	mov    %edi,0x14(%esp)
  8000de:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  8000e2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8000e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000e9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000f1:	c7 04 24 30 2c 80 00 	movl   $0x802c30,(%esp)
  8000f8:	e8 4e 01 00 00       	call   80024b <cprintf>
		if (val == 10)
  8000fd:	a1 08 50 80 00       	mov    0x805008,%eax
  800102:	83 f8 0a             	cmp    $0xa,%eax
  800105:	74 38                	je     80013f <umain+0x10c>
			return;
		++val;
  800107:	83 c0 01             	add    $0x1,%eax
  80010a:	a3 08 50 80 00       	mov    %eax,0x805008
		ipc_send(who, 0, 0, 0);
  80010f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800116:	00 
  800117:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800126:	00 
  800127:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80012a:	89 04 24             	mov    %eax,(%esp)
  80012d:	e8 16 13 00 00       	call   801448 <ipc_send>
		if (val == 10)
  800132:	83 3d 08 50 80 00 0a 	cmpl   $0xa,0x805008
  800139:	0f 85 67 ff ff ff    	jne    8000a6 <umain+0x73>
			return;
	}

}
  80013f:	83 c4 3c             	add    $0x3c,%esp
  800142:	5b                   	pop    %ebx
  800143:	5e                   	pop    %esi
  800144:	5f                   	pop    %edi
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    

00800147 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	56                   	push   %esi
  80014b:	53                   	push   %ebx
  80014c:	83 ec 10             	sub    $0x10,%esp
  80014f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800152:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800155:	e8 fb 0a 00 00       	call   800c55 <sys_getenvid>
  80015a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80015f:	c1 e0 07             	shl    $0x7,%eax
  800162:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800167:	a3 0c 50 80 00       	mov    %eax,0x80500c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016c:	85 db                	test   %ebx,%ebx
  80016e:	7e 07                	jle    800177 <libmain+0x30>
		binaryname = argv[0];
  800170:	8b 06                	mov    (%esi),%eax
  800172:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800177:	89 74 24 04          	mov    %esi,0x4(%esp)
  80017b:	89 1c 24             	mov    %ebx,(%esp)
  80017e:	e8 b0 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800183:	e8 07 00 00 00       	call   80018f <exit>
}
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	5b                   	pop    %ebx
  80018c:	5e                   	pop    %esi
  80018d:	5d                   	pop    %ebp
  80018e:	c3                   	ret    

0080018f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80018f:	55                   	push   %ebp
  800190:	89 e5                	mov    %esp,%ebp
  800192:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800195:	e8 50 15 00 00       	call   8016ea <close_all>
	sys_env_destroy(0);
  80019a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001a1:	e8 5d 0a 00 00       	call   800c03 <sys_env_destroy>
}
  8001a6:	c9                   	leave  
  8001a7:	c3                   	ret    

008001a8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	53                   	push   %ebx
  8001ac:	83 ec 14             	sub    $0x14,%esp
  8001af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b2:	8b 13                	mov    (%ebx),%edx
  8001b4:	8d 42 01             	lea    0x1(%edx),%eax
  8001b7:	89 03                	mov    %eax,(%ebx)
  8001b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001bc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001c0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c5:	75 19                	jne    8001e0 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001c7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001ce:	00 
  8001cf:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d2:	89 04 24             	mov    %eax,(%esp)
  8001d5:	e8 ec 09 00 00       	call   800bc6 <sys_cputs>
		b->idx = 0;
  8001da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001e0:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001e4:	83 c4 14             	add    $0x14,%esp
  8001e7:	5b                   	pop    %ebx
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    

008001ea <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fa:	00 00 00 
	b.cnt = 0;
  8001fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800204:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80020e:	8b 45 08             	mov    0x8(%ebp),%eax
  800211:	89 44 24 08          	mov    %eax,0x8(%esp)
  800215:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021f:	c7 04 24 a8 01 80 00 	movl   $0x8001a8,(%esp)
  800226:	e8 b3 01 00 00       	call   8003de <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80022b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800231:	89 44 24 04          	mov    %eax,0x4(%esp)
  800235:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80023b:	89 04 24             	mov    %eax,(%esp)
  80023e:	e8 83 09 00 00       	call   800bc6 <sys_cputs>

	return b.cnt;
}
  800243:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800249:	c9                   	leave  
  80024a:	c3                   	ret    

0080024b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800251:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800254:	89 44 24 04          	mov    %eax,0x4(%esp)
  800258:	8b 45 08             	mov    0x8(%ebp),%eax
  80025b:	89 04 24             	mov    %eax,(%esp)
  80025e:	e8 87 ff ff ff       	call   8001ea <vcprintf>
	va_end(ap);

	return cnt;
}
  800263:	c9                   	leave  
  800264:	c3                   	ret    
  800265:	66 90                	xchg   %ax,%ax
  800267:	66 90                	xchg   %ax,%ax
  800269:	66 90                	xchg   %ax,%ax
  80026b:	66 90                	xchg   %ax,%ax
  80026d:	66 90                	xchg   %ax,%ax
  80026f:	90                   	nop

00800270 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	57                   	push   %edi
  800274:	56                   	push   %esi
  800275:	53                   	push   %ebx
  800276:	83 ec 3c             	sub    $0x3c,%esp
  800279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80027c:	89 d7                	mov    %edx,%edi
  80027e:	8b 45 08             	mov    0x8(%ebp),%eax
  800281:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	89 c3                	mov    %eax,%ebx
  800289:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80028c:	8b 45 10             	mov    0x10(%ebp),%eax
  80028f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800292:	b9 00 00 00 00       	mov    $0x0,%ecx
  800297:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80029a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80029d:	39 d9                	cmp    %ebx,%ecx
  80029f:	72 05                	jb     8002a6 <printnum+0x36>
  8002a1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a4:	77 69                	ja     80030f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002a6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002a9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002ad:	83 ee 01             	sub    $0x1,%esi
  8002b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002bc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002c0:	89 c3                	mov    %eax,%ebx
  8002c2:	89 d6                	mov    %edx,%esi
  8002c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ca:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002ce:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d5:	89 04 24             	mov    %eax,(%esp)
  8002d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002df:	e8 7c 26 00 00       	call   802960 <__udivdi3>
  8002e4:	89 d9                	mov    %ebx,%ecx
  8002e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002ea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002ee:	89 04 24             	mov    %eax,(%esp)
  8002f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002f5:	89 fa                	mov    %edi,%edx
  8002f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002fa:	e8 71 ff ff ff       	call   800270 <printnum>
  8002ff:	eb 1b                	jmp    80031c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800301:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800305:	8b 45 18             	mov    0x18(%ebp),%eax
  800308:	89 04 24             	mov    %eax,(%esp)
  80030b:	ff d3                	call   *%ebx
  80030d:	eb 03                	jmp    800312 <printnum+0xa2>
  80030f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800312:	83 ee 01             	sub    $0x1,%esi
  800315:	85 f6                	test   %esi,%esi
  800317:	7f e8                	jg     800301 <printnum+0x91>
  800319:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80031c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800320:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800324:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800327:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80032a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80032e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800335:	89 04 24             	mov    %eax,(%esp)
  800338:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80033b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033f:	e8 4c 27 00 00       	call   802a90 <__umoddi3>
  800344:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800348:	0f be 80 60 2c 80 00 	movsbl 0x802c60(%eax),%eax
  80034f:	89 04 24             	mov    %eax,(%esp)
  800352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800355:	ff d0                	call   *%eax
}
  800357:	83 c4 3c             	add    $0x3c,%esp
  80035a:	5b                   	pop    %ebx
  80035b:	5e                   	pop    %esi
  80035c:	5f                   	pop    %edi
  80035d:	5d                   	pop    %ebp
  80035e:	c3                   	ret    

0080035f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800362:	83 fa 01             	cmp    $0x1,%edx
  800365:	7e 0e                	jle    800375 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800367:	8b 10                	mov    (%eax),%edx
  800369:	8d 4a 08             	lea    0x8(%edx),%ecx
  80036c:	89 08                	mov    %ecx,(%eax)
  80036e:	8b 02                	mov    (%edx),%eax
  800370:	8b 52 04             	mov    0x4(%edx),%edx
  800373:	eb 22                	jmp    800397 <getuint+0x38>
	else if (lflag)
  800375:	85 d2                	test   %edx,%edx
  800377:	74 10                	je     800389 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800379:	8b 10                	mov    (%eax),%edx
  80037b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80037e:	89 08                	mov    %ecx,(%eax)
  800380:	8b 02                	mov    (%edx),%eax
  800382:	ba 00 00 00 00       	mov    $0x0,%edx
  800387:	eb 0e                	jmp    800397 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800389:	8b 10                	mov    (%eax),%edx
  80038b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80038e:	89 08                	mov    %ecx,(%eax)
  800390:	8b 02                	mov    (%edx),%eax
  800392:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800397:	5d                   	pop    %ebp
  800398:	c3                   	ret    

00800399 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80039f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003a3:	8b 10                	mov    (%eax),%edx
  8003a5:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a8:	73 0a                	jae    8003b4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003ad:	89 08                	mov    %ecx,(%eax)
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	88 02                	mov    %al,(%edx)
}
  8003b4:	5d                   	pop    %ebp
  8003b5:	c3                   	ret    

008003b6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003bc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	89 04 24             	mov    %eax,(%esp)
  8003d7:	e8 02 00 00 00       	call   8003de <vprintfmt>
	va_end(ap);
}
  8003dc:	c9                   	leave  
  8003dd:	c3                   	ret    

008003de <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003de:	55                   	push   %ebp
  8003df:	89 e5                	mov    %esp,%ebp
  8003e1:	57                   	push   %edi
  8003e2:	56                   	push   %esi
  8003e3:	53                   	push   %ebx
  8003e4:	83 ec 3c             	sub    $0x3c,%esp
  8003e7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003ed:	eb 14                	jmp    800403 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003ef:	85 c0                	test   %eax,%eax
  8003f1:	0f 84 b3 03 00 00    	je     8007aa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8003f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003fb:	89 04 24             	mov    %eax,(%esp)
  8003fe:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800401:	89 f3                	mov    %esi,%ebx
  800403:	8d 73 01             	lea    0x1(%ebx),%esi
  800406:	0f b6 03             	movzbl (%ebx),%eax
  800409:	83 f8 25             	cmp    $0x25,%eax
  80040c:	75 e1                	jne    8003ef <vprintfmt+0x11>
  80040e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800412:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800419:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800420:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800427:	ba 00 00 00 00       	mov    $0x0,%edx
  80042c:	eb 1d                	jmp    80044b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800430:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800434:	eb 15                	jmp    80044b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800436:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800438:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80043c:	eb 0d                	jmp    80044b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80043e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800441:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800444:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80044e:	0f b6 0e             	movzbl (%esi),%ecx
  800451:	0f b6 c1             	movzbl %cl,%eax
  800454:	83 e9 23             	sub    $0x23,%ecx
  800457:	80 f9 55             	cmp    $0x55,%cl
  80045a:	0f 87 2a 03 00 00    	ja     80078a <vprintfmt+0x3ac>
  800460:	0f b6 c9             	movzbl %cl,%ecx
  800463:	ff 24 8d a0 2d 80 00 	jmp    *0x802da0(,%ecx,4)
  80046a:	89 de                	mov    %ebx,%esi
  80046c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800471:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800474:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800478:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80047b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80047e:	83 fb 09             	cmp    $0x9,%ebx
  800481:	77 36                	ja     8004b9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800483:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800486:	eb e9                	jmp    800471 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800488:	8b 45 14             	mov    0x14(%ebp),%eax
  80048b:	8d 48 04             	lea    0x4(%eax),%ecx
  80048e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800491:	8b 00                	mov    (%eax),%eax
  800493:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800496:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800498:	eb 22                	jmp    8004bc <vprintfmt+0xde>
  80049a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80049d:	85 c9                	test   %ecx,%ecx
  80049f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a4:	0f 49 c1             	cmovns %ecx,%eax
  8004a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004aa:	89 de                	mov    %ebx,%esi
  8004ac:	eb 9d                	jmp    80044b <vprintfmt+0x6d>
  8004ae:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004b0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8004b7:	eb 92                	jmp    80044b <vprintfmt+0x6d>
  8004b9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8004bc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004c0:	79 89                	jns    80044b <vprintfmt+0x6d>
  8004c2:	e9 77 ff ff ff       	jmp    80043e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004c7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ca:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004cc:	e9 7a ff ff ff       	jmp    80044b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d4:	8d 50 04             	lea    0x4(%eax),%edx
  8004d7:	89 55 14             	mov    %edx,0x14(%ebp)
  8004da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004de:	8b 00                	mov    (%eax),%eax
  8004e0:	89 04 24             	mov    %eax,(%esp)
  8004e3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004e6:	e9 18 ff ff ff       	jmp    800403 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	8d 50 04             	lea    0x4(%eax),%edx
  8004f1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	99                   	cltd   
  8004f7:	31 d0                	xor    %edx,%eax
  8004f9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004fb:	83 f8 11             	cmp    $0x11,%eax
  8004fe:	7f 0b                	jg     80050b <vprintfmt+0x12d>
  800500:	8b 14 85 00 2f 80 00 	mov    0x802f00(,%eax,4),%edx
  800507:	85 d2                	test   %edx,%edx
  800509:	75 20                	jne    80052b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80050b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80050f:	c7 44 24 08 78 2c 80 	movl   $0x802c78,0x8(%esp)
  800516:	00 
  800517:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80051b:	8b 45 08             	mov    0x8(%ebp),%eax
  80051e:	89 04 24             	mov    %eax,(%esp)
  800521:	e8 90 fe ff ff       	call   8003b6 <printfmt>
  800526:	e9 d8 fe ff ff       	jmp    800403 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80052b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80052f:	c7 44 24 08 45 31 80 	movl   $0x803145,0x8(%esp)
  800536:	00 
  800537:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	89 04 24             	mov    %eax,(%esp)
  800541:	e8 70 fe ff ff       	call   8003b6 <printfmt>
  800546:	e9 b8 fe ff ff       	jmp    800403 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80054e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800551:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	8d 50 04             	lea    0x4(%eax),%edx
  80055a:	89 55 14             	mov    %edx,0x14(%ebp)
  80055d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80055f:	85 f6                	test   %esi,%esi
  800561:	b8 71 2c 80 00       	mov    $0x802c71,%eax
  800566:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800569:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80056d:	0f 84 97 00 00 00    	je     80060a <vprintfmt+0x22c>
  800573:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800577:	0f 8e 9b 00 00 00    	jle    800618 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80057d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800581:	89 34 24             	mov    %esi,(%esp)
  800584:	e8 cf 02 00 00       	call   800858 <strnlen>
  800589:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80058c:	29 c2                	sub    %eax,%edx
  80058e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800591:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800595:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800598:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80059b:	8b 75 08             	mov    0x8(%ebp),%esi
  80059e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005a1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a3:	eb 0f                	jmp    8005b4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8005a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ac:	89 04 24             	mov    %eax,(%esp)
  8005af:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b1:	83 eb 01             	sub    $0x1,%ebx
  8005b4:	85 db                	test   %ebx,%ebx
  8005b6:	7f ed                	jg     8005a5 <vprintfmt+0x1c7>
  8005b8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005bb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005be:	85 d2                	test   %edx,%edx
  8005c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c5:	0f 49 c2             	cmovns %edx,%eax
  8005c8:	29 c2                	sub    %eax,%edx
  8005ca:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005cd:	89 d7                	mov    %edx,%edi
  8005cf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005d2:	eb 50                	jmp    800624 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005d8:	74 1e                	je     8005f8 <vprintfmt+0x21a>
  8005da:	0f be d2             	movsbl %dl,%edx
  8005dd:	83 ea 20             	sub    $0x20,%edx
  8005e0:	83 fa 5e             	cmp    $0x5e,%edx
  8005e3:	76 13                	jbe    8005f8 <vprintfmt+0x21a>
					putch('?', putdat);
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ec:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005f3:	ff 55 08             	call   *0x8(%ebp)
  8005f6:	eb 0d                	jmp    800605 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8005f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005fb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005ff:	89 04 24             	mov    %eax,(%esp)
  800602:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800605:	83 ef 01             	sub    $0x1,%edi
  800608:	eb 1a                	jmp    800624 <vprintfmt+0x246>
  80060a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80060d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800610:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800613:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800616:	eb 0c                	jmp    800624 <vprintfmt+0x246>
  800618:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80061b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80061e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800621:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800624:	83 c6 01             	add    $0x1,%esi
  800627:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80062b:	0f be c2             	movsbl %dl,%eax
  80062e:	85 c0                	test   %eax,%eax
  800630:	74 27                	je     800659 <vprintfmt+0x27b>
  800632:	85 db                	test   %ebx,%ebx
  800634:	78 9e                	js     8005d4 <vprintfmt+0x1f6>
  800636:	83 eb 01             	sub    $0x1,%ebx
  800639:	79 99                	jns    8005d4 <vprintfmt+0x1f6>
  80063b:	89 f8                	mov    %edi,%eax
  80063d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800640:	8b 75 08             	mov    0x8(%ebp),%esi
  800643:	89 c3                	mov    %eax,%ebx
  800645:	eb 1a                	jmp    800661 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800647:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80064b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800652:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800654:	83 eb 01             	sub    $0x1,%ebx
  800657:	eb 08                	jmp    800661 <vprintfmt+0x283>
  800659:	89 fb                	mov    %edi,%ebx
  80065b:	8b 75 08             	mov    0x8(%ebp),%esi
  80065e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800661:	85 db                	test   %ebx,%ebx
  800663:	7f e2                	jg     800647 <vprintfmt+0x269>
  800665:	89 75 08             	mov    %esi,0x8(%ebp)
  800668:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80066b:	e9 93 fd ff ff       	jmp    800403 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800670:	83 fa 01             	cmp    $0x1,%edx
  800673:	7e 16                	jle    80068b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8d 50 08             	lea    0x8(%eax),%edx
  80067b:	89 55 14             	mov    %edx,0x14(%ebp)
  80067e:	8b 50 04             	mov    0x4(%eax),%edx
  800681:	8b 00                	mov    (%eax),%eax
  800683:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800686:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800689:	eb 32                	jmp    8006bd <vprintfmt+0x2df>
	else if (lflag)
  80068b:	85 d2                	test   %edx,%edx
  80068d:	74 18                	je     8006a7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8d 50 04             	lea    0x4(%eax),%edx
  800695:	89 55 14             	mov    %edx,0x14(%ebp)
  800698:	8b 30                	mov    (%eax),%esi
  80069a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80069d:	89 f0                	mov    %esi,%eax
  80069f:	c1 f8 1f             	sar    $0x1f,%eax
  8006a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006a5:	eb 16                	jmp    8006bd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8d 50 04             	lea    0x4(%eax),%edx
  8006ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b0:	8b 30                	mov    (%eax),%esi
  8006b2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006b5:	89 f0                	mov    %esi,%eax
  8006b7:	c1 f8 1f             	sar    $0x1f,%eax
  8006ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006cc:	0f 89 80 00 00 00    	jns    800752 <vprintfmt+0x374>
				putch('-', putdat);
  8006d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006dd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006e6:	f7 d8                	neg    %eax
  8006e8:	83 d2 00             	adc    $0x0,%edx
  8006eb:	f7 da                	neg    %edx
			}
			base = 10;
  8006ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006f2:	eb 5e                	jmp    800752 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f7:	e8 63 fc ff ff       	call   80035f <getuint>
			base = 10;
  8006fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800701:	eb 4f                	jmp    800752 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800703:	8d 45 14             	lea    0x14(%ebp),%eax
  800706:	e8 54 fc ff ff       	call   80035f <getuint>
			base = 8;
  80070b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800710:	eb 40                	jmp    800752 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800712:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800716:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80071d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800720:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800724:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80072b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8d 50 04             	lea    0x4(%eax),%edx
  800734:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800737:	8b 00                	mov    (%eax),%eax
  800739:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80073e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800743:	eb 0d                	jmp    800752 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800745:	8d 45 14             	lea    0x14(%ebp),%eax
  800748:	e8 12 fc ff ff       	call   80035f <getuint>
			base = 16;
  80074d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800752:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800756:	89 74 24 10          	mov    %esi,0x10(%esp)
  80075a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80075d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800761:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800765:	89 04 24             	mov    %eax,(%esp)
  800768:	89 54 24 04          	mov    %edx,0x4(%esp)
  80076c:	89 fa                	mov    %edi,%edx
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	e8 fa fa ff ff       	call   800270 <printnum>
			break;
  800776:	e9 88 fc ff ff       	jmp    800403 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80077b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077f:	89 04 24             	mov    %eax,(%esp)
  800782:	ff 55 08             	call   *0x8(%ebp)
			break;
  800785:	e9 79 fc ff ff       	jmp    800403 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80078a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80078e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800795:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800798:	89 f3                	mov    %esi,%ebx
  80079a:	eb 03                	jmp    80079f <vprintfmt+0x3c1>
  80079c:	83 eb 01             	sub    $0x1,%ebx
  80079f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007a3:	75 f7                	jne    80079c <vprintfmt+0x3be>
  8007a5:	e9 59 fc ff ff       	jmp    800403 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007aa:	83 c4 3c             	add    $0x3c,%esp
  8007ad:	5b                   	pop    %ebx
  8007ae:	5e                   	pop    %esi
  8007af:	5f                   	pop    %edi
  8007b0:	5d                   	pop    %ebp
  8007b1:	c3                   	ret    

008007b2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007b2:	55                   	push   %ebp
  8007b3:	89 e5                	mov    %esp,%ebp
  8007b5:	83 ec 28             	sub    $0x28,%esp
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007c1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007c5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007cf:	85 c0                	test   %eax,%eax
  8007d1:	74 30                	je     800803 <vsnprintf+0x51>
  8007d3:	85 d2                	test   %edx,%edx
  8007d5:	7e 2c                	jle    800803 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007de:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ec:	c7 04 24 99 03 80 00 	movl   $0x800399,(%esp)
  8007f3:	e8 e6 fb ff ff       	call   8003de <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007fb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800801:	eb 05                	jmp    800808 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800803:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800808:	c9                   	leave  
  800809:	c3                   	ret    

0080080a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800810:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800813:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80081e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800821:	89 44 24 04          	mov    %eax,0x4(%esp)
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	89 04 24             	mov    %eax,(%esp)
  80082b:	e8 82 ff ff ff       	call   8007b2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800830:	c9                   	leave  
  800831:	c3                   	ret    
  800832:	66 90                	xchg   %ax,%ax
  800834:	66 90                	xchg   %ax,%ax
  800836:	66 90                	xchg   %ax,%ax
  800838:	66 90                	xchg   %ax,%ax
  80083a:	66 90                	xchg   %ax,%ax
  80083c:	66 90                	xchg   %ax,%ax
  80083e:	66 90                	xchg   %ax,%ax

00800840 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800846:	b8 00 00 00 00       	mov    $0x0,%eax
  80084b:	eb 03                	jmp    800850 <strlen+0x10>
		n++;
  80084d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800850:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800854:	75 f7                	jne    80084d <strlen+0xd>
		n++;
	return n;
}
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80085e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800861:	b8 00 00 00 00       	mov    $0x0,%eax
  800866:	eb 03                	jmp    80086b <strnlen+0x13>
		n++;
  800868:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086b:	39 d0                	cmp    %edx,%eax
  80086d:	74 06                	je     800875 <strnlen+0x1d>
  80086f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800873:	75 f3                	jne    800868 <strnlen+0x10>
		n++;
	return n;
}
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	53                   	push   %ebx
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800881:	89 c2                	mov    %eax,%edx
  800883:	83 c2 01             	add    $0x1,%edx
  800886:	83 c1 01             	add    $0x1,%ecx
  800889:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80088d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800890:	84 db                	test   %bl,%bl
  800892:	75 ef                	jne    800883 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800894:	5b                   	pop    %ebx
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	53                   	push   %ebx
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a1:	89 1c 24             	mov    %ebx,(%esp)
  8008a4:	e8 97 ff ff ff       	call   800840 <strlen>
	strcpy(dst + len, src);
  8008a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008b0:	01 d8                	add    %ebx,%eax
  8008b2:	89 04 24             	mov    %eax,(%esp)
  8008b5:	e8 bd ff ff ff       	call   800877 <strcpy>
	return dst;
}
  8008ba:	89 d8                	mov    %ebx,%eax
  8008bc:	83 c4 08             	add    $0x8,%esp
  8008bf:	5b                   	pop    %ebx
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    

008008c2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	56                   	push   %esi
  8008c6:	53                   	push   %ebx
  8008c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008cd:	89 f3                	mov    %esi,%ebx
  8008cf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d2:	89 f2                	mov    %esi,%edx
  8008d4:	eb 0f                	jmp    8008e5 <strncpy+0x23>
		*dst++ = *src;
  8008d6:	83 c2 01             	add    $0x1,%edx
  8008d9:	0f b6 01             	movzbl (%ecx),%eax
  8008dc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008df:	80 39 01             	cmpb   $0x1,(%ecx)
  8008e2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e5:	39 da                	cmp    %ebx,%edx
  8008e7:	75 ed                	jne    8008d6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008e9:	89 f0                	mov    %esi,%eax
  8008eb:	5b                   	pop    %ebx
  8008ec:	5e                   	pop    %esi
  8008ed:	5d                   	pop    %ebp
  8008ee:	c3                   	ret    

008008ef <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	56                   	push   %esi
  8008f3:	53                   	push   %ebx
  8008f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008fd:	89 f0                	mov    %esi,%eax
  8008ff:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800903:	85 c9                	test   %ecx,%ecx
  800905:	75 0b                	jne    800912 <strlcpy+0x23>
  800907:	eb 1d                	jmp    800926 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800909:	83 c0 01             	add    $0x1,%eax
  80090c:	83 c2 01             	add    $0x1,%edx
  80090f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800912:	39 d8                	cmp    %ebx,%eax
  800914:	74 0b                	je     800921 <strlcpy+0x32>
  800916:	0f b6 0a             	movzbl (%edx),%ecx
  800919:	84 c9                	test   %cl,%cl
  80091b:	75 ec                	jne    800909 <strlcpy+0x1a>
  80091d:	89 c2                	mov    %eax,%edx
  80091f:	eb 02                	jmp    800923 <strlcpy+0x34>
  800921:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800923:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800926:	29 f0                	sub    %esi,%eax
}
  800928:	5b                   	pop    %ebx
  800929:	5e                   	pop    %esi
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800932:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800935:	eb 06                	jmp    80093d <strcmp+0x11>
		p++, q++;
  800937:	83 c1 01             	add    $0x1,%ecx
  80093a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80093d:	0f b6 01             	movzbl (%ecx),%eax
  800940:	84 c0                	test   %al,%al
  800942:	74 04                	je     800948 <strcmp+0x1c>
  800944:	3a 02                	cmp    (%edx),%al
  800946:	74 ef                	je     800937 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800948:	0f b6 c0             	movzbl %al,%eax
  80094b:	0f b6 12             	movzbl (%edx),%edx
  80094e:	29 d0                	sub    %edx,%eax
}
  800950:	5d                   	pop    %ebp
  800951:	c3                   	ret    

00800952 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	53                   	push   %ebx
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095c:	89 c3                	mov    %eax,%ebx
  80095e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800961:	eb 06                	jmp    800969 <strncmp+0x17>
		n--, p++, q++;
  800963:	83 c0 01             	add    $0x1,%eax
  800966:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800969:	39 d8                	cmp    %ebx,%eax
  80096b:	74 15                	je     800982 <strncmp+0x30>
  80096d:	0f b6 08             	movzbl (%eax),%ecx
  800970:	84 c9                	test   %cl,%cl
  800972:	74 04                	je     800978 <strncmp+0x26>
  800974:	3a 0a                	cmp    (%edx),%cl
  800976:	74 eb                	je     800963 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800978:	0f b6 00             	movzbl (%eax),%eax
  80097b:	0f b6 12             	movzbl (%edx),%edx
  80097e:	29 d0                	sub    %edx,%eax
  800980:	eb 05                	jmp    800987 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800982:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800987:	5b                   	pop    %ebx
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800994:	eb 07                	jmp    80099d <strchr+0x13>
		if (*s == c)
  800996:	38 ca                	cmp    %cl,%dl
  800998:	74 0f                	je     8009a9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80099a:	83 c0 01             	add    $0x1,%eax
  80099d:	0f b6 10             	movzbl (%eax),%edx
  8009a0:	84 d2                	test   %dl,%dl
  8009a2:	75 f2                	jne    800996 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b5:	eb 07                	jmp    8009be <strfind+0x13>
		if (*s == c)
  8009b7:	38 ca                	cmp    %cl,%dl
  8009b9:	74 0a                	je     8009c5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009bb:	83 c0 01             	add    $0x1,%eax
  8009be:	0f b6 10             	movzbl (%eax),%edx
  8009c1:	84 d2                	test   %dl,%dl
  8009c3:	75 f2                	jne    8009b7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	57                   	push   %edi
  8009cb:	56                   	push   %esi
  8009cc:	53                   	push   %ebx
  8009cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009d3:	85 c9                	test   %ecx,%ecx
  8009d5:	74 36                	je     800a0d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009dd:	75 28                	jne    800a07 <memset+0x40>
  8009df:	f6 c1 03             	test   $0x3,%cl
  8009e2:	75 23                	jne    800a07 <memset+0x40>
		c &= 0xFF;
  8009e4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e8:	89 d3                	mov    %edx,%ebx
  8009ea:	c1 e3 08             	shl    $0x8,%ebx
  8009ed:	89 d6                	mov    %edx,%esi
  8009ef:	c1 e6 18             	shl    $0x18,%esi
  8009f2:	89 d0                	mov    %edx,%eax
  8009f4:	c1 e0 10             	shl    $0x10,%eax
  8009f7:	09 f0                	or     %esi,%eax
  8009f9:	09 c2                	or     %eax,%edx
  8009fb:	89 d0                	mov    %edx,%eax
  8009fd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ff:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a02:	fc                   	cld    
  800a03:	f3 ab                	rep stos %eax,%es:(%edi)
  800a05:	eb 06                	jmp    800a0d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0a:	fc                   	cld    
  800a0b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a0d:	89 f8                	mov    %edi,%eax
  800a0f:	5b                   	pop    %ebx
  800a10:	5e                   	pop    %esi
  800a11:	5f                   	pop    %edi
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	57                   	push   %edi
  800a18:	56                   	push   %esi
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a22:	39 c6                	cmp    %eax,%esi
  800a24:	73 35                	jae    800a5b <memmove+0x47>
  800a26:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a29:	39 d0                	cmp    %edx,%eax
  800a2b:	73 2e                	jae    800a5b <memmove+0x47>
		s += n;
		d += n;
  800a2d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a30:	89 d6                	mov    %edx,%esi
  800a32:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a34:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a3a:	75 13                	jne    800a4f <memmove+0x3b>
  800a3c:	f6 c1 03             	test   $0x3,%cl
  800a3f:	75 0e                	jne    800a4f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a41:	83 ef 04             	sub    $0x4,%edi
  800a44:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a47:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a4a:	fd                   	std    
  800a4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a4d:	eb 09                	jmp    800a58 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a4f:	83 ef 01             	sub    $0x1,%edi
  800a52:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a55:	fd                   	std    
  800a56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a58:	fc                   	cld    
  800a59:	eb 1d                	jmp    800a78 <memmove+0x64>
  800a5b:	89 f2                	mov    %esi,%edx
  800a5d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5f:	f6 c2 03             	test   $0x3,%dl
  800a62:	75 0f                	jne    800a73 <memmove+0x5f>
  800a64:	f6 c1 03             	test   $0x3,%cl
  800a67:	75 0a                	jne    800a73 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a69:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a6c:	89 c7                	mov    %eax,%edi
  800a6e:	fc                   	cld    
  800a6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a71:	eb 05                	jmp    800a78 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a73:	89 c7                	mov    %eax,%edi
  800a75:	fc                   	cld    
  800a76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a78:	5e                   	pop    %esi
  800a79:	5f                   	pop    %edi
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a82:	8b 45 10             	mov    0x10(%ebp),%eax
  800a85:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	89 04 24             	mov    %eax,(%esp)
  800a96:	e8 79 ff ff ff       	call   800a14 <memmove>
}
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	56                   	push   %esi
  800aa1:	53                   	push   %ebx
  800aa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa8:	89 d6                	mov    %edx,%esi
  800aaa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aad:	eb 1a                	jmp    800ac9 <memcmp+0x2c>
		if (*s1 != *s2)
  800aaf:	0f b6 02             	movzbl (%edx),%eax
  800ab2:	0f b6 19             	movzbl (%ecx),%ebx
  800ab5:	38 d8                	cmp    %bl,%al
  800ab7:	74 0a                	je     800ac3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ab9:	0f b6 c0             	movzbl %al,%eax
  800abc:	0f b6 db             	movzbl %bl,%ebx
  800abf:	29 d8                	sub    %ebx,%eax
  800ac1:	eb 0f                	jmp    800ad2 <memcmp+0x35>
		s1++, s2++;
  800ac3:	83 c2 01             	add    $0x1,%edx
  800ac6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ac9:	39 f2                	cmp    %esi,%edx
  800acb:	75 e2                	jne    800aaf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800acd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800adf:	89 c2                	mov    %eax,%edx
  800ae1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ae4:	eb 07                	jmp    800aed <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae6:	38 08                	cmp    %cl,(%eax)
  800ae8:	74 07                	je     800af1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800aea:	83 c0 01             	add    $0x1,%eax
  800aed:	39 d0                	cmp    %edx,%eax
  800aef:	72 f5                	jb     800ae6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    

00800af3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	57                   	push   %edi
  800af7:	56                   	push   %esi
  800af8:	53                   	push   %ebx
  800af9:	8b 55 08             	mov    0x8(%ebp),%edx
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aff:	eb 03                	jmp    800b04 <strtol+0x11>
		s++;
  800b01:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b04:	0f b6 0a             	movzbl (%edx),%ecx
  800b07:	80 f9 09             	cmp    $0x9,%cl
  800b0a:	74 f5                	je     800b01 <strtol+0xe>
  800b0c:	80 f9 20             	cmp    $0x20,%cl
  800b0f:	74 f0                	je     800b01 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b11:	80 f9 2b             	cmp    $0x2b,%cl
  800b14:	75 0a                	jne    800b20 <strtol+0x2d>
		s++;
  800b16:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b19:	bf 00 00 00 00       	mov    $0x0,%edi
  800b1e:	eb 11                	jmp    800b31 <strtol+0x3e>
  800b20:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b25:	80 f9 2d             	cmp    $0x2d,%cl
  800b28:	75 07                	jne    800b31 <strtol+0x3e>
		s++, neg = 1;
  800b2a:	8d 52 01             	lea    0x1(%edx),%edx
  800b2d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b31:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b36:	75 15                	jne    800b4d <strtol+0x5a>
  800b38:	80 3a 30             	cmpb   $0x30,(%edx)
  800b3b:	75 10                	jne    800b4d <strtol+0x5a>
  800b3d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b41:	75 0a                	jne    800b4d <strtol+0x5a>
		s += 2, base = 16;
  800b43:	83 c2 02             	add    $0x2,%edx
  800b46:	b8 10 00 00 00       	mov    $0x10,%eax
  800b4b:	eb 10                	jmp    800b5d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b4d:	85 c0                	test   %eax,%eax
  800b4f:	75 0c                	jne    800b5d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b51:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b53:	80 3a 30             	cmpb   $0x30,(%edx)
  800b56:	75 05                	jne    800b5d <strtol+0x6a>
		s++, base = 8;
  800b58:	83 c2 01             	add    $0x1,%edx
  800b5b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b62:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b65:	0f b6 0a             	movzbl (%edx),%ecx
  800b68:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b6b:	89 f0                	mov    %esi,%eax
  800b6d:	3c 09                	cmp    $0x9,%al
  800b6f:	77 08                	ja     800b79 <strtol+0x86>
			dig = *s - '0';
  800b71:	0f be c9             	movsbl %cl,%ecx
  800b74:	83 e9 30             	sub    $0x30,%ecx
  800b77:	eb 20                	jmp    800b99 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b79:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b7c:	89 f0                	mov    %esi,%eax
  800b7e:	3c 19                	cmp    $0x19,%al
  800b80:	77 08                	ja     800b8a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b82:	0f be c9             	movsbl %cl,%ecx
  800b85:	83 e9 57             	sub    $0x57,%ecx
  800b88:	eb 0f                	jmp    800b99 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b8a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b8d:	89 f0                	mov    %esi,%eax
  800b8f:	3c 19                	cmp    $0x19,%al
  800b91:	77 16                	ja     800ba9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b93:	0f be c9             	movsbl %cl,%ecx
  800b96:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b99:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b9c:	7d 0f                	jge    800bad <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b9e:	83 c2 01             	add    $0x1,%edx
  800ba1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ba5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ba7:	eb bc                	jmp    800b65 <strtol+0x72>
  800ba9:	89 d8                	mov    %ebx,%eax
  800bab:	eb 02                	jmp    800baf <strtol+0xbc>
  800bad:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800baf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb3:	74 05                	je     800bba <strtol+0xc7>
		*endptr = (char *) s;
  800bb5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bba:	f7 d8                	neg    %eax
  800bbc:	85 ff                	test   %edi,%edi
  800bbe:	0f 44 c3             	cmove  %ebx,%eax
}
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	57                   	push   %edi
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bcc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd7:	89 c3                	mov    %eax,%ebx
  800bd9:	89 c7                	mov    %eax,%edi
  800bdb:	89 c6                	mov    %eax,%esi
  800bdd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5f                   	pop    %edi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	57                   	push   %edi
  800be8:	56                   	push   %esi
  800be9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bea:	ba 00 00 00 00       	mov    $0x0,%edx
  800bef:	b8 01 00 00 00       	mov    $0x1,%eax
  800bf4:	89 d1                	mov    %edx,%ecx
  800bf6:	89 d3                	mov    %edx,%ebx
  800bf8:	89 d7                	mov    %edx,%edi
  800bfa:	89 d6                	mov    %edx,%esi
  800bfc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c03:	55                   	push   %ebp
  800c04:	89 e5                	mov    %esp,%ebp
  800c06:	57                   	push   %edi
  800c07:	56                   	push   %esi
  800c08:	53                   	push   %ebx
  800c09:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c11:	b8 03 00 00 00       	mov    $0x3,%eax
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	89 cb                	mov    %ecx,%ebx
  800c1b:	89 cf                	mov    %ecx,%edi
  800c1d:	89 ce                	mov    %ecx,%esi
  800c1f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c21:	85 c0                	test   %eax,%eax
  800c23:	7e 28                	jle    800c4d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c25:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c29:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c30:	00 
  800c31:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800c38:	00 
  800c39:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c40:	00 
  800c41:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800c48:	e8 d9 1b 00 00       	call   802826 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c4d:	83 c4 2c             	add    $0x2c,%esp
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5f                   	pop    %edi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c60:	b8 02 00 00 00       	mov    $0x2,%eax
  800c65:	89 d1                	mov    %edx,%ecx
  800c67:	89 d3                	mov    %edx,%ebx
  800c69:	89 d7                	mov    %edx,%edi
  800c6b:	89 d6                	mov    %edx,%esi
  800c6d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c6f:	5b                   	pop    %ebx
  800c70:	5e                   	pop    %esi
  800c71:	5f                   	pop    %edi
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <sys_yield>:

void
sys_yield(void)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	57                   	push   %edi
  800c78:	56                   	push   %esi
  800c79:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c84:	89 d1                	mov    %edx,%ecx
  800c86:	89 d3                	mov    %edx,%ebx
  800c88:	89 d7                	mov    %edx,%edi
  800c8a:	89 d6                	mov    %edx,%esi
  800c8c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c8e:	5b                   	pop    %ebx
  800c8f:	5e                   	pop    %esi
  800c90:	5f                   	pop    %edi
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	57                   	push   %edi
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9c:	be 00 00 00 00       	mov    $0x0,%esi
  800ca1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ca6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800caf:	89 f7                	mov    %esi,%edi
  800cb1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cb3:	85 c0                	test   %eax,%eax
  800cb5:	7e 28                	jle    800cdf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cbb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cc2:	00 
  800cc3:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800cca:	00 
  800ccb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cd2:	00 
  800cd3:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800cda:	e8 47 1b 00 00       	call   802826 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cdf:	83 c4 2c             	add    $0x2c,%esp
  800ce2:	5b                   	pop    %ebx
  800ce3:	5e                   	pop    %esi
  800ce4:	5f                   	pop    %edi
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	57                   	push   %edi
  800ceb:	56                   	push   %esi
  800cec:	53                   	push   %ebx
  800ced:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf0:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d01:	8b 75 18             	mov    0x18(%ebp),%esi
  800d04:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d06:	85 c0                	test   %eax,%eax
  800d08:	7e 28                	jle    800d32 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d0e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d15:	00 
  800d16:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800d1d:	00 
  800d1e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d25:	00 
  800d26:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800d2d:	e8 f4 1a 00 00       	call   802826 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d32:	83 c4 2c             	add    $0x2c,%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    

00800d3a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	57                   	push   %edi
  800d3e:	56                   	push   %esi
  800d3f:	53                   	push   %ebx
  800d40:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d48:	b8 06 00 00 00       	mov    $0x6,%eax
  800d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d50:	8b 55 08             	mov    0x8(%ebp),%edx
  800d53:	89 df                	mov    %ebx,%edi
  800d55:	89 de                	mov    %ebx,%esi
  800d57:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d59:	85 c0                	test   %eax,%eax
  800d5b:	7e 28                	jle    800d85 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d61:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d68:	00 
  800d69:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800d70:	00 
  800d71:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d78:	00 
  800d79:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800d80:	e8 a1 1a 00 00       	call   802826 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d85:	83 c4 2c             	add    $0x2c,%esp
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	57                   	push   %edi
  800d91:	56                   	push   %esi
  800d92:	53                   	push   %ebx
  800d93:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9b:	b8 08 00 00 00       	mov    $0x8,%eax
  800da0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da3:	8b 55 08             	mov    0x8(%ebp),%edx
  800da6:	89 df                	mov    %ebx,%edi
  800da8:	89 de                	mov    %ebx,%esi
  800daa:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800dac:	85 c0                	test   %eax,%eax
  800dae:	7e 28                	jle    800dd8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800dbb:	00 
  800dbc:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800dc3:	00 
  800dc4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dcb:	00 
  800dcc:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800dd3:	e8 4e 1a 00 00       	call   802826 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dd8:	83 c4 2c             	add    $0x2c,%esp
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5f                   	pop    %edi
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    

00800de0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	57                   	push   %edi
  800de4:	56                   	push   %esi
  800de5:	53                   	push   %ebx
  800de6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dee:	b8 09 00 00 00       	mov    $0x9,%eax
  800df3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	89 df                	mov    %ebx,%edi
  800dfb:	89 de                	mov    %ebx,%esi
  800dfd:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800dff:	85 c0                	test   %eax,%eax
  800e01:	7e 28                	jle    800e2b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e03:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e07:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e0e:	00 
  800e0f:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800e16:	00 
  800e17:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e1e:	00 
  800e1f:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800e26:	e8 fb 19 00 00       	call   802826 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e2b:	83 c4 2c             	add    $0x2c,%esp
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    

00800e33 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	89 de                	mov    %ebx,%esi
  800e50:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7e 28                	jle    800e7e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e56:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e5a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e61:	00 
  800e62:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800e69:	00 
  800e6a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e71:	00 
  800e72:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800e79:	e8 a8 19 00 00       	call   802826 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e7e:	83 c4 2c             	add    $0x2c,%esp
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    

00800e86 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8c:	be 00 00 00 00       	mov    $0x0,%esi
  800e91:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ea2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ea4:	5b                   	pop    %ebx
  800ea5:	5e                   	pop    %esi
  800ea6:	5f                   	pop    %edi
  800ea7:	5d                   	pop    %ebp
  800ea8:	c3                   	ret    

00800ea9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	57                   	push   %edi
  800ead:	56                   	push   %esi
  800eae:	53                   	push   %ebx
  800eaf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebf:	89 cb                	mov    %ecx,%ebx
  800ec1:	89 cf                	mov    %ecx,%edi
  800ec3:	89 ce                	mov    %ecx,%esi
  800ec5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	7e 28                	jle    800ef3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ecf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ed6:	00 
  800ed7:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800ede:	00 
  800edf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee6:	00 
  800ee7:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800eee:	e8 33 19 00 00       	call   802826 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ef3:	83 c4 2c             	add    $0x2c,%esp
  800ef6:	5b                   	pop    %ebx
  800ef7:	5e                   	pop    %esi
  800ef8:	5f                   	pop    %edi
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    

00800efb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	57                   	push   %edi
  800eff:	56                   	push   %esi
  800f00:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f01:	ba 00 00 00 00       	mov    $0x0,%edx
  800f06:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f0b:	89 d1                	mov    %edx,%ecx
  800f0d:	89 d3                	mov    %edx,%ebx
  800f0f:	89 d7                	mov    %edx,%edi
  800f11:	89 d6                	mov    %edx,%esi
  800f13:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f15:	5b                   	pop    %ebx
  800f16:	5e                   	pop    %esi
  800f17:	5f                   	pop    %edi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    

00800f1a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	57                   	push   %edi
  800f1e:	56                   	push   %esi
  800f1f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f20:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f25:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f30:	89 df                	mov    %ebx,%edi
  800f32:	89 de                	mov    %ebx,%esi
  800f34:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800f36:	5b                   	pop    %ebx
  800f37:	5e                   	pop    %esi
  800f38:	5f                   	pop    %edi
  800f39:	5d                   	pop    %ebp
  800f3a:	c3                   	ret    

00800f3b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	57                   	push   %edi
  800f3f:	56                   	push   %esi
  800f40:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f41:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f46:	b8 10 00 00 00       	mov    $0x10,%eax
  800f4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f51:	89 df                	mov    %ebx,%edi
  800f53:	89 de                	mov    %ebx,%esi
  800f55:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800f57:	5b                   	pop    %ebx
  800f58:	5e                   	pop    %esi
  800f59:	5f                   	pop    %edi
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f67:	b8 11 00 00 00       	mov    $0x11,%eax
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	89 cb                	mov    %ecx,%ebx
  800f71:	89 cf                	mov    %ecx,%edi
  800f73:	89 ce                	mov    %ecx,%esi
  800f75:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
  800f82:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f85:	be 00 00 00 00       	mov    $0x0,%esi
  800f8a:	b8 12 00 00 00       	mov    $0x12,%eax
  800f8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f92:	8b 55 08             	mov    0x8(%ebp),%edx
  800f95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f98:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f9b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	7e 28                	jle    800fc9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800fac:	00 
  800fad:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800fb4:	00 
  800fb5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fbc:	00 
  800fbd:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800fc4:	e8 5d 18 00 00       	call   802826 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  800fc9:	83 c4 2c             	add    $0x2c,%esp
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    

00800fd1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	53                   	push   %ebx
  800fd5:	83 ec 24             	sub    $0x24,%esp
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800fdb:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0)
  800fdd:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fe1:	75 20                	jne    801003 <pgfault+0x32>
		panic("pgfault: faulting address [%08x] not a write\n", addr);
  800fe3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800fe7:	c7 44 24 08 94 2f 80 	movl   $0x802f94,0x8(%esp)
  800fee:	00 
  800fef:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  800ff6:	00 
  800ff7:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  800ffe:	e8 23 18 00 00       	call   802826 <_panic>

	void *page_aligned_addr = (void *) ROUNDDOWN(addr, PGSIZE);
  801003:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t page_num = (uint32_t) page_aligned_addr / PGSIZE;
  801009:	89 d8                	mov    %ebx,%eax
  80100b:	c1 e8 0c             	shr    $0xc,%eax
	if (!(uvpt[page_num] & PTE_COW))
  80100e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801015:	f6 c4 08             	test   $0x8,%ah
  801018:	75 1c                	jne    801036 <pgfault+0x65>
		panic("pgfault: fault was not on a copy-on-write page\n");
  80101a:	c7 44 24 08 c4 2f 80 	movl   $0x802fc4,0x8(%esp)
  801021:	00 
  801022:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801029:	00 
  80102a:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  801031:	e8 f0 17 00 00       	call   802826 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	// Allocate
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801036:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80103d:	00 
  80103e:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801045:	00 
  801046:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80104d:	e8 41 fc ff ff       	call   800c93 <sys_page_alloc>
  801052:	85 c0                	test   %eax,%eax
  801054:	79 20                	jns    801076 <pgfault+0xa5>
		panic("sys_page_alloc: %e\n", r);
  801056:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80105a:	c7 44 24 08 1f 30 80 	movl   $0x80301f,0x8(%esp)
  801061:	00 
  801062:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  801069:	00 
  80106a:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  801071:	e8 b0 17 00 00       	call   802826 <_panic>

	// Copy over
	void *src_addr = (void *) ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, src_addr, PGSIZE);
  801076:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80107d:	00 
  80107e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801082:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801089:	e8 86 f9 ff ff       	call   800a14 <memmove>

	// Remap
	if ((r = sys_page_map(0, PFTEMP, 0, src_addr, PTE_P | PTE_U | PTE_W)) < 0)
  80108e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801095:	00 
  801096:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80109a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010a1:	00 
  8010a2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010a9:	00 
  8010aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010b1:	e8 31 fc ff ff       	call   800ce7 <sys_page_map>
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	79 20                	jns    8010da <pgfault+0x109>
		panic("sys_page_map: %e\n", r);
  8010ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010be:	c7 44 24 08 33 30 80 	movl   $0x803033,0x8(%esp)
  8010c5:	00 
  8010c6:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  8010cd:	00 
  8010ce:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  8010d5:	e8 4c 17 00 00       	call   802826 <_panic>

	//panic("pgfault not implemented");
}
  8010da:	83 c4 24             	add    $0x24,%esp
  8010dd:	5b                   	pop    %ebx
  8010de:	5d                   	pop    %ebp
  8010df:	c3                   	ret    

008010e0 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	57                   	push   %edi
  8010e4:	56                   	push   %esi
  8010e5:	53                   	push   %ebx
  8010e6:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	int r;
	envid_t child_envid;

	set_pgfault_handler(pgfault);
  8010e9:	c7 04 24 d1 0f 80 00 	movl   $0x800fd1,(%esp)
  8010f0:	e8 87 17 00 00       	call   80287c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010f5:	b8 07 00 00 00       	mov    $0x7,%eax
  8010fa:	cd 30                	int    $0x30
  8010fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8010ff:	89 45 e0             	mov    %eax,-0x20(%ebp)

	child_envid = sys_exofork();
	if (child_envid < 0)
  801102:	85 c0                	test   %eax,%eax
  801104:	79 20                	jns    801126 <fork+0x46>
		panic("sys_exofork: %e\n", child_envid);
  801106:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80110a:	c7 44 24 08 45 30 80 	movl   $0x803045,0x8(%esp)
  801111:	00 
  801112:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  801119:	00 
  80111a:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  801121:	e8 00 17 00 00       	call   802826 <_panic>
	if (child_envid == 0) { // child
  801126:	bf 00 00 00 00       	mov    $0x0,%edi
  80112b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801130:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801134:	75 21                	jne    801157 <fork+0x77>
		// Fix thisenv like dumbfork does and return 0
		thisenv = &envs[ENVX(sys_getenvid())];
  801136:	e8 1a fb ff ff       	call   800c55 <sys_getenvid>
  80113b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801140:	c1 e0 07             	shl    $0x7,%eax
  801143:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801148:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  80114d:	b8 00 00 00 00       	mov    $0x0,%eax
  801152:	e9 53 02 00 00       	jmp    8013aa <fork+0x2ca>
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
  801157:	89 d8                	mov    %ebx,%eax
  801159:	c1 e8 0a             	shr    $0xa,%eax
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  80115c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801163:	a8 01                	test   $0x1,%al
  801165:	0f 84 7a 01 00 00    	je     8012e5 <fork+0x205>
			((uvpt[page_num] & PTE_P) == PTE_P)) {
  80116b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  801172:	a8 01                	test   $0x1,%al
  801174:	0f 84 6b 01 00 00    	je     8012e5 <fork+0x205>
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
	envid_t this_envid = thisenv->env_id;
  80117a:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80117f:	8b 40 48             	mov    0x48(%eax),%eax
  801182:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 4: Your code here.
	if (uvpt[pn] & PTE_SHARE) {
  801185:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80118c:	f6 c4 04             	test   $0x4,%ah
  80118f:	74 52                	je     8011e3 <fork+0x103>
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801191:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801198:	25 07 0e 00 00       	and    $0xe07,%eax
  80119d:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011b3:	89 04 24             	mov    %eax,(%esp)
  8011b6:	e8 2c fb ff ff       	call   800ce7 <sys_page_map>
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	0f 89 22 01 00 00    	jns    8012e5 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  8011c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011c7:	c7 44 24 08 33 30 80 	movl   $0x803033,0x8(%esp)
  8011ce:	00 
  8011cf:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  8011d6:	00 
  8011d7:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  8011de:	e8 43 16 00 00       	call   802826 <_panic>
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
  8011e3:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011ea:	f6 c4 08             	test   $0x8,%ah
  8011ed:	75 0f                	jne    8011fe <fork+0x11e>
  8011ef:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011f6:	a8 02                	test   $0x2,%al
  8011f8:	0f 84 99 00 00 00    	je     801297 <fork+0x1b7>
		if (uvpt[pn] & PTE_U)
  8011fe:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801205:	83 e0 04             	and    $0x4,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
  801208:	83 f8 01             	cmp    $0x1,%eax
  80120b:	19 f6                	sbb    %esi,%esi
  80120d:	83 e6 fc             	and    $0xfffffffc,%esi
  801210:	81 c6 05 08 00 00    	add    $0x805,%esi
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
		if (uvpt[pn] & PTE_U)
			perm |= PTE_U;

		// Map page COW, U and P in child
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), perm)) < 0)
  801216:	89 74 24 10          	mov    %esi,0x10(%esp)
  80121a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80121e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801221:	89 44 24 08          	mov    %eax,0x8(%esp)
  801225:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80122c:	89 04 24             	mov    %eax,(%esp)
  80122f:	e8 b3 fa ff ff       	call   800ce7 <sys_page_map>
  801234:	85 c0                	test   %eax,%eax
  801236:	79 20                	jns    801258 <fork+0x178>
			panic("sys_page_map: %e\n", r);
  801238:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80123c:	c7 44 24 08 33 30 80 	movl   $0x803033,0x8(%esp)
  801243:	00 
  801244:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80124b:	00 
  80124c:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  801253:	e8 ce 15 00 00       	call   802826 <_panic>

		// Map page COW, U and P in parent
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), this_envid, (void *) (pn*PGSIZE), perm)) < 0)
  801258:	89 74 24 10          	mov    %esi,0x10(%esp)
  80125c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801260:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801263:	89 44 24 08          	mov    %eax,0x8(%esp)
  801267:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80126b:	89 04 24             	mov    %eax,(%esp)
  80126e:	e8 74 fa ff ff       	call   800ce7 <sys_page_map>
  801273:	85 c0                	test   %eax,%eax
  801275:	79 6e                	jns    8012e5 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801277:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80127b:	c7 44 24 08 33 30 80 	movl   $0x803033,0x8(%esp)
  801282:	00 
  801283:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  80128a:	00 
  80128b:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  801292:	e8 8f 15 00 00       	call   802826 <_panic>

	} else { // map pages that are present but not writable or COW with their original permissions
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801297:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80129e:	25 07 0e 00 00       	and    $0xe07,%eax
  8012a3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012a7:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b9:	89 04 24             	mov    %eax,(%esp)
  8012bc:	e8 26 fa ff ff       	call   800ce7 <sys_page_map>
  8012c1:	85 c0                	test   %eax,%eax
  8012c3:	79 20                	jns    8012e5 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  8012c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012c9:	c7 44 24 08 33 30 80 	movl   $0x803033,0x8(%esp)
  8012d0:	00 
  8012d1:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  8012d8:	00 
  8012d9:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  8012e0:	e8 41 15 00 00       	call   802826 <_panic>
	// and let duppage worry about the permissions.
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
  8012e5:	83 c3 01             	add    $0x1,%ebx
  8012e8:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8012ee:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  8012f4:	0f 85 5d fe ff ff    	jne    801157 <fork+0x77>
	}

	// Allocate exception stack space for child. The child can't do this themselves
	// because the mechanism by which it would is to run the pgfault handler, which
	// needs to run on the exception stack (catch 22).
	if ((r = sys_page_alloc(child_envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8012fa:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801301:	00 
  801302:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801309:	ee 
  80130a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80130d:	89 04 24             	mov    %eax,(%esp)
  801310:	e8 7e f9 ff ff       	call   800c93 <sys_page_alloc>
  801315:	85 c0                	test   %eax,%eax
  801317:	79 20                	jns    801339 <fork+0x259>
		panic("sys_page_alloc: %e\n", r);
  801319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80131d:	c7 44 24 08 1f 30 80 	movl   $0x80301f,0x8(%esp)
  801324:	00 
  801325:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  80132c:	00 
  80132d:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  801334:	e8 ed 14 00 00       	call   802826 <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801339:	c7 44 24 04 fd 28 80 	movl   $0x8028fd,0x4(%esp)
  801340:	00 
  801341:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801344:	89 04 24             	mov    %eax,(%esp)
  801347:	e8 e7 fa ff ff       	call   800e33 <sys_env_set_pgfault_upcall>
  80134c:	85 c0                	test   %eax,%eax
  80134e:	79 20                	jns    801370 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801350:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801354:	c7 44 24 08 f4 2f 80 	movl   $0x802ff4,0x8(%esp)
  80135b:	00 
  80135c:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801363:	00 
  801364:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  80136b:	e8 b6 14 00 00       	call   802826 <_panic>

	// Mark child environment as runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801370:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801377:	00 
  801378:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80137b:	89 04 24             	mov    %eax,(%esp)
  80137e:	e8 0a fa ff ff       	call   800d8d <sys_env_set_status>
  801383:	85 c0                	test   %eax,%eax
  801385:	79 20                	jns    8013a7 <fork+0x2c7>
		panic("sys_env_set_status: %e\n", r);
  801387:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80138b:	c7 44 24 08 56 30 80 	movl   $0x803056,0x8(%esp)
  801392:	00 
  801393:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80139a:	00 
  80139b:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  8013a2:	e8 7f 14 00 00       	call   802826 <_panic>

	return child_envid;
  8013a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8013aa:	83 c4 2c             	add    $0x2c,%esp
  8013ad:	5b                   	pop    %ebx
  8013ae:	5e                   	pop    %esi
  8013af:	5f                   	pop    %edi
  8013b0:	5d                   	pop    %ebp
  8013b1:	c3                   	ret    

008013b2 <sfork>:

// Challenge!
int
sfork(void)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
  8013b5:	83 ec 18             	sub    $0x18,%esp
//	return __fork(1);
	panic("sfork not implemented");
  8013b8:	c7 44 24 08 6e 30 80 	movl   $0x80306e,0x8(%esp)
  8013bf:	00 
  8013c0:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  8013c7:	00 
  8013c8:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  8013cf:	e8 52 14 00 00       	call   802826 <_panic>
  8013d4:	66 90                	xchg   %ax,%ax
  8013d6:	66 90                	xchg   %ax,%ax
  8013d8:	66 90                	xchg   %ax,%ax
  8013da:	66 90                	xchg   %ax,%ax
  8013dc:	66 90                	xchg   %ax,%ax
  8013de:	66 90                	xchg   %ax,%ax

008013e0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	56                   	push   %esi
  8013e4:	53                   	push   %ebx
  8013e5:	83 ec 10             	sub    $0x10,%esp
  8013e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8013eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8013f1:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  8013f3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8013f8:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  8013fb:	89 04 24             	mov    %eax,(%esp)
  8013fe:	e8 a6 fa ff ff       	call   800ea9 <sys_ipc_recv>
  801403:	85 c0                	test   %eax,%eax
  801405:	74 16                	je     80141d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  801407:	85 f6                	test   %esi,%esi
  801409:	74 06                	je     801411 <ipc_recv+0x31>
			*from_env_store = 0;
  80140b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  801411:	85 db                	test   %ebx,%ebx
  801413:	74 2c                	je     801441 <ipc_recv+0x61>
			*perm_store = 0;
  801415:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80141b:	eb 24                	jmp    801441 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80141d:	85 f6                	test   %esi,%esi
  80141f:	74 0a                	je     80142b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  801421:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801426:	8b 40 74             	mov    0x74(%eax),%eax
  801429:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80142b:	85 db                	test   %ebx,%ebx
  80142d:	74 0a                	je     801439 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80142f:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801434:	8b 40 78             	mov    0x78(%eax),%eax
  801437:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  801439:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80143e:	8b 40 70             	mov    0x70(%eax),%eax
}
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	5b                   	pop    %ebx
  801445:	5e                   	pop    %esi
  801446:	5d                   	pop    %ebp
  801447:	c3                   	ret    

00801448 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	57                   	push   %edi
  80144c:	56                   	push   %esi
  80144d:	53                   	push   %ebx
  80144e:	83 ec 1c             	sub    $0x1c,%esp
  801451:	8b 75 0c             	mov    0xc(%ebp),%esi
  801454:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801457:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80145a:	85 db                	test   %ebx,%ebx
  80145c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  801461:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  801464:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801468:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80146c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801470:	8b 45 08             	mov    0x8(%ebp),%eax
  801473:	89 04 24             	mov    %eax,(%esp)
  801476:	e8 0b fa ff ff       	call   800e86 <sys_ipc_try_send>
	if (r == 0) return;
  80147b:	85 c0                	test   %eax,%eax
  80147d:	75 22                	jne    8014a1 <ipc_send+0x59>
  80147f:	eb 4c                	jmp    8014cd <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  801481:	84 d2                	test   %dl,%dl
  801483:	75 48                	jne    8014cd <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  801485:	e8 ea f7 ff ff       	call   800c74 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80148a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80148e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801492:	89 74 24 04          	mov    %esi,0x4(%esp)
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 04 24             	mov    %eax,(%esp)
  80149c:	e8 e5 f9 ff ff       	call   800e86 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	0f 94 c2             	sete   %dl
  8014a6:	74 d9                	je     801481 <ipc_send+0x39>
  8014a8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8014ab:	74 d4                	je     801481 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  8014ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014b1:	c7 44 24 08 84 30 80 	movl   $0x803084,0x8(%esp)
  8014b8:	00 
  8014b9:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  8014c0:	00 
  8014c1:	c7 04 24 92 30 80 00 	movl   $0x803092,(%esp)
  8014c8:	e8 59 13 00 00       	call   802826 <_panic>
}
  8014cd:	83 c4 1c             	add    $0x1c,%esp
  8014d0:	5b                   	pop    %ebx
  8014d1:	5e                   	pop    %esi
  8014d2:	5f                   	pop    %edi
  8014d3:	5d                   	pop    %ebp
  8014d4:	c3                   	ret    

008014d5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8014db:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8014e0:	89 c2                	mov    %eax,%edx
  8014e2:	c1 e2 07             	shl    $0x7,%edx
  8014e5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8014eb:	8b 52 50             	mov    0x50(%edx),%edx
  8014ee:	39 ca                	cmp    %ecx,%edx
  8014f0:	75 0d                	jne    8014ff <ipc_find_env+0x2a>
			return envs[i].env_id;
  8014f2:	c1 e0 07             	shl    $0x7,%eax
  8014f5:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8014fa:	8b 40 40             	mov    0x40(%eax),%eax
  8014fd:	eb 0e                	jmp    80150d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8014ff:	83 c0 01             	add    $0x1,%eax
  801502:	3d 00 04 00 00       	cmp    $0x400,%eax
  801507:	75 d7                	jne    8014e0 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801509:	66 b8 00 00          	mov    $0x0,%ax
}
  80150d:	5d                   	pop    %ebp
  80150e:	c3                   	ret    
  80150f:	90                   	nop

00801510 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	05 00 00 00 30       	add    $0x30000000,%eax
  80151b:	c1 e8 0c             	shr    $0xc,%eax
}
  80151e:	5d                   	pop    %ebp
  80151f:	c3                   	ret    

00801520 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80152b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801530:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801535:	5d                   	pop    %ebp
  801536:	c3                   	ret    

00801537 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80153d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801542:	89 c2                	mov    %eax,%edx
  801544:	c1 ea 16             	shr    $0x16,%edx
  801547:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80154e:	f6 c2 01             	test   $0x1,%dl
  801551:	74 11                	je     801564 <fd_alloc+0x2d>
  801553:	89 c2                	mov    %eax,%edx
  801555:	c1 ea 0c             	shr    $0xc,%edx
  801558:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80155f:	f6 c2 01             	test   $0x1,%dl
  801562:	75 09                	jne    80156d <fd_alloc+0x36>
			*fd_store = fd;
  801564:	89 01                	mov    %eax,(%ecx)
			return 0;
  801566:	b8 00 00 00 00       	mov    $0x0,%eax
  80156b:	eb 17                	jmp    801584 <fd_alloc+0x4d>
  80156d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801572:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801577:	75 c9                	jne    801542 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801579:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80157f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    

00801586 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80158c:	83 f8 1f             	cmp    $0x1f,%eax
  80158f:	77 36                	ja     8015c7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801591:	c1 e0 0c             	shl    $0xc,%eax
  801594:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801599:	89 c2                	mov    %eax,%edx
  80159b:	c1 ea 16             	shr    $0x16,%edx
  80159e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015a5:	f6 c2 01             	test   $0x1,%dl
  8015a8:	74 24                	je     8015ce <fd_lookup+0x48>
  8015aa:	89 c2                	mov    %eax,%edx
  8015ac:	c1 ea 0c             	shr    $0xc,%edx
  8015af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015b6:	f6 c2 01             	test   $0x1,%dl
  8015b9:	74 1a                	je     8015d5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015be:	89 02                	mov    %eax,(%edx)
	return 0;
  8015c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c5:	eb 13                	jmp    8015da <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015cc:	eb 0c                	jmp    8015da <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8015ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d3:	eb 05                	jmp    8015da <fd_lookup+0x54>
  8015d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    

008015dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	83 ec 18             	sub    $0x18,%esp
  8015e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8015e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ea:	eb 13                	jmp    8015ff <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8015ec:	39 08                	cmp    %ecx,(%eax)
  8015ee:	75 0c                	jne    8015fc <dev_lookup+0x20>
			*dev = devtab[i];
  8015f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fa:	eb 38                	jmp    801634 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015fc:	83 c2 01             	add    $0x1,%edx
  8015ff:	8b 04 95 18 31 80 00 	mov    0x803118(,%edx,4),%eax
  801606:	85 c0                	test   %eax,%eax
  801608:	75 e2                	jne    8015ec <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80160a:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80160f:	8b 40 48             	mov    0x48(%eax),%eax
  801612:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801616:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161a:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  801621:	e8 25 ec ff ff       	call   80024b <cprintf>
	*dev = 0;
  801626:	8b 45 0c             	mov    0xc(%ebp),%eax
  801629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80162f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	56                   	push   %esi
  80163a:	53                   	push   %ebx
  80163b:	83 ec 20             	sub    $0x20,%esp
  80163e:	8b 75 08             	mov    0x8(%ebp),%esi
  801641:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801644:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801647:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80164b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801651:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801654:	89 04 24             	mov    %eax,(%esp)
  801657:	e8 2a ff ff ff       	call   801586 <fd_lookup>
  80165c:	85 c0                	test   %eax,%eax
  80165e:	78 05                	js     801665 <fd_close+0x2f>
	    || fd != fd2)
  801660:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801663:	74 0c                	je     801671 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801665:	84 db                	test   %bl,%bl
  801667:	ba 00 00 00 00       	mov    $0x0,%edx
  80166c:	0f 44 c2             	cmove  %edx,%eax
  80166f:	eb 3f                	jmp    8016b0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801671:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801674:	89 44 24 04          	mov    %eax,0x4(%esp)
  801678:	8b 06                	mov    (%esi),%eax
  80167a:	89 04 24             	mov    %eax,(%esp)
  80167d:	e8 5a ff ff ff       	call   8015dc <dev_lookup>
  801682:	89 c3                	mov    %eax,%ebx
  801684:	85 c0                	test   %eax,%eax
  801686:	78 16                	js     80169e <fd_close+0x68>
		if (dev->dev_close)
  801688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80168e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801693:	85 c0                	test   %eax,%eax
  801695:	74 07                	je     80169e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801697:	89 34 24             	mov    %esi,(%esp)
  80169a:	ff d0                	call   *%eax
  80169c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80169e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016a9:	e8 8c f6 ff ff       	call   800d3a <sys_page_unmap>
	return r;
  8016ae:	89 d8                	mov    %ebx,%eax
}
  8016b0:	83 c4 20             	add    $0x20,%esp
  8016b3:	5b                   	pop    %ebx
  8016b4:	5e                   	pop    %esi
  8016b5:	5d                   	pop    %ebp
  8016b6:	c3                   	ret    

008016b7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	89 04 24             	mov    %eax,(%esp)
  8016ca:	e8 b7 fe ff ff       	call   801586 <fd_lookup>
  8016cf:	89 c2                	mov    %eax,%edx
  8016d1:	85 d2                	test   %edx,%edx
  8016d3:	78 13                	js     8016e8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8016d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016dc:	00 
  8016dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e0:	89 04 24             	mov    %eax,(%esp)
  8016e3:	e8 4e ff ff ff       	call   801636 <fd_close>
}
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    

008016ea <close_all>:

void
close_all(void)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	53                   	push   %ebx
  8016ee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016f6:	89 1c 24             	mov    %ebx,(%esp)
  8016f9:	e8 b9 ff ff ff       	call   8016b7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8016fe:	83 c3 01             	add    $0x1,%ebx
  801701:	83 fb 20             	cmp    $0x20,%ebx
  801704:	75 f0                	jne    8016f6 <close_all+0xc>
		close(i);
}
  801706:	83 c4 14             	add    $0x14,%esp
  801709:	5b                   	pop    %ebx
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    

0080170c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	57                   	push   %edi
  801710:	56                   	push   %esi
  801711:	53                   	push   %ebx
  801712:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801715:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801718:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	89 04 24             	mov    %eax,(%esp)
  801722:	e8 5f fe ff ff       	call   801586 <fd_lookup>
  801727:	89 c2                	mov    %eax,%edx
  801729:	85 d2                	test   %edx,%edx
  80172b:	0f 88 e1 00 00 00    	js     801812 <dup+0x106>
		return r;
	close(newfdnum);
  801731:	8b 45 0c             	mov    0xc(%ebp),%eax
  801734:	89 04 24             	mov    %eax,(%esp)
  801737:	e8 7b ff ff ff       	call   8016b7 <close>

	newfd = INDEX2FD(newfdnum);
  80173c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80173f:	c1 e3 0c             	shl    $0xc,%ebx
  801742:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80174b:	89 04 24             	mov    %eax,(%esp)
  80174e:	e8 cd fd ff ff       	call   801520 <fd2data>
  801753:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801755:	89 1c 24             	mov    %ebx,(%esp)
  801758:	e8 c3 fd ff ff       	call   801520 <fd2data>
  80175d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80175f:	89 f0                	mov    %esi,%eax
  801761:	c1 e8 16             	shr    $0x16,%eax
  801764:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80176b:	a8 01                	test   $0x1,%al
  80176d:	74 43                	je     8017b2 <dup+0xa6>
  80176f:	89 f0                	mov    %esi,%eax
  801771:	c1 e8 0c             	shr    $0xc,%eax
  801774:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80177b:	f6 c2 01             	test   $0x1,%dl
  80177e:	74 32                	je     8017b2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801780:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801787:	25 07 0e 00 00       	and    $0xe07,%eax
  80178c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801790:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801794:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80179b:	00 
  80179c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a7:	e8 3b f5 ff ff       	call   800ce7 <sys_page_map>
  8017ac:	89 c6                	mov    %eax,%esi
  8017ae:	85 c0                	test   %eax,%eax
  8017b0:	78 3e                	js     8017f0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017b5:	89 c2                	mov    %eax,%edx
  8017b7:	c1 ea 0c             	shr    $0xc,%edx
  8017ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017c1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017c7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8017cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017d6:	00 
  8017d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017e2:	e8 00 f5 ff ff       	call   800ce7 <sys_page_map>
  8017e7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8017e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017ec:	85 f6                	test   %esi,%esi
  8017ee:	79 22                	jns    801812 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8017f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017fb:	e8 3a f5 ff ff       	call   800d3a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801800:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801804:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80180b:	e8 2a f5 ff ff       	call   800d3a <sys_page_unmap>
	return r;
  801810:	89 f0                	mov    %esi,%eax
}
  801812:	83 c4 3c             	add    $0x3c,%esp
  801815:	5b                   	pop    %ebx
  801816:	5e                   	pop    %esi
  801817:	5f                   	pop    %edi
  801818:	5d                   	pop    %ebp
  801819:	c3                   	ret    

0080181a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	53                   	push   %ebx
  80181e:	83 ec 24             	sub    $0x24,%esp
  801821:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801824:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801827:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182b:	89 1c 24             	mov    %ebx,(%esp)
  80182e:	e8 53 fd ff ff       	call   801586 <fd_lookup>
  801833:	89 c2                	mov    %eax,%edx
  801835:	85 d2                	test   %edx,%edx
  801837:	78 6d                	js     8018a6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801839:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801840:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801843:	8b 00                	mov    (%eax),%eax
  801845:	89 04 24             	mov    %eax,(%esp)
  801848:	e8 8f fd ff ff       	call   8015dc <dev_lookup>
  80184d:	85 c0                	test   %eax,%eax
  80184f:	78 55                	js     8018a6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801854:	8b 50 08             	mov    0x8(%eax),%edx
  801857:	83 e2 03             	and    $0x3,%edx
  80185a:	83 fa 01             	cmp    $0x1,%edx
  80185d:	75 23                	jne    801882 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80185f:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801864:	8b 40 48             	mov    0x48(%eax),%eax
  801867:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80186b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186f:	c7 04 24 dd 30 80 00 	movl   $0x8030dd,(%esp)
  801876:	e8 d0 e9 ff ff       	call   80024b <cprintf>
		return -E_INVAL;
  80187b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801880:	eb 24                	jmp    8018a6 <read+0x8c>
	}
	if (!dev->dev_read)
  801882:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801885:	8b 52 08             	mov    0x8(%edx),%edx
  801888:	85 d2                	test   %edx,%edx
  80188a:	74 15                	je     8018a1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80188c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801893:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801896:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80189a:	89 04 24             	mov    %eax,(%esp)
  80189d:	ff d2                	call   *%edx
  80189f:	eb 05                	jmp    8018a6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8018a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8018a6:	83 c4 24             	add    $0x24,%esp
  8018a9:	5b                   	pop    %ebx
  8018aa:	5d                   	pop    %ebp
  8018ab:	c3                   	ret    

008018ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	57                   	push   %edi
  8018b0:	56                   	push   %esi
  8018b1:	53                   	push   %ebx
  8018b2:	83 ec 1c             	sub    $0x1c,%esp
  8018b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018c0:	eb 23                	jmp    8018e5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018c2:	89 f0                	mov    %esi,%eax
  8018c4:	29 d8                	sub    %ebx,%eax
  8018c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018ca:	89 d8                	mov    %ebx,%eax
  8018cc:	03 45 0c             	add    0xc(%ebp),%eax
  8018cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d3:	89 3c 24             	mov    %edi,(%esp)
  8018d6:	e8 3f ff ff ff       	call   80181a <read>
		if (m < 0)
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	78 10                	js     8018ef <readn+0x43>
			return m;
		if (m == 0)
  8018df:	85 c0                	test   %eax,%eax
  8018e1:	74 0a                	je     8018ed <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018e3:	01 c3                	add    %eax,%ebx
  8018e5:	39 f3                	cmp    %esi,%ebx
  8018e7:	72 d9                	jb     8018c2 <readn+0x16>
  8018e9:	89 d8                	mov    %ebx,%eax
  8018eb:	eb 02                	jmp    8018ef <readn+0x43>
  8018ed:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8018ef:	83 c4 1c             	add    $0x1c,%esp
  8018f2:	5b                   	pop    %ebx
  8018f3:	5e                   	pop    %esi
  8018f4:	5f                   	pop    %edi
  8018f5:	5d                   	pop    %ebp
  8018f6:	c3                   	ret    

008018f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	53                   	push   %ebx
  8018fb:	83 ec 24             	sub    $0x24,%esp
  8018fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801901:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801904:	89 44 24 04          	mov    %eax,0x4(%esp)
  801908:	89 1c 24             	mov    %ebx,(%esp)
  80190b:	e8 76 fc ff ff       	call   801586 <fd_lookup>
  801910:	89 c2                	mov    %eax,%edx
  801912:	85 d2                	test   %edx,%edx
  801914:	78 68                	js     80197e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801916:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801919:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801920:	8b 00                	mov    (%eax),%eax
  801922:	89 04 24             	mov    %eax,(%esp)
  801925:	e8 b2 fc ff ff       	call   8015dc <dev_lookup>
  80192a:	85 c0                	test   %eax,%eax
  80192c:	78 50                	js     80197e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80192e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801931:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801935:	75 23                	jne    80195a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801937:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80193c:	8b 40 48             	mov    0x48(%eax),%eax
  80193f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801943:	89 44 24 04          	mov    %eax,0x4(%esp)
  801947:	c7 04 24 f9 30 80 00 	movl   $0x8030f9,(%esp)
  80194e:	e8 f8 e8 ff ff       	call   80024b <cprintf>
		return -E_INVAL;
  801953:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801958:	eb 24                	jmp    80197e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80195a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80195d:	8b 52 0c             	mov    0xc(%edx),%edx
  801960:	85 d2                	test   %edx,%edx
  801962:	74 15                	je     801979 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801964:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801967:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80196b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80196e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801972:	89 04 24             	mov    %eax,(%esp)
  801975:	ff d2                	call   *%edx
  801977:	eb 05                	jmp    80197e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801979:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80197e:	83 c4 24             	add    $0x24,%esp
  801981:	5b                   	pop    %ebx
  801982:	5d                   	pop    %ebp
  801983:	c3                   	ret    

00801984 <seek>:

int
seek(int fdnum, off_t offset)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80198a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80198d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	89 04 24             	mov    %eax,(%esp)
  801997:	e8 ea fb ff ff       	call   801586 <fd_lookup>
  80199c:	85 c0                	test   %eax,%eax
  80199e:	78 0e                	js     8019ae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	53                   	push   %ebx
  8019b4:	83 ec 24             	sub    $0x24,%esp
  8019b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c1:	89 1c 24             	mov    %ebx,(%esp)
  8019c4:	e8 bd fb ff ff       	call   801586 <fd_lookup>
  8019c9:	89 c2                	mov    %eax,%edx
  8019cb:	85 d2                	test   %edx,%edx
  8019cd:	78 61                	js     801a30 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d9:	8b 00                	mov    (%eax),%eax
  8019db:	89 04 24             	mov    %eax,(%esp)
  8019de:	e8 f9 fb ff ff       	call   8015dc <dev_lookup>
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	78 49                	js     801a30 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019ee:	75 23                	jne    801a13 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8019f0:	a1 0c 50 80 00       	mov    0x80500c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019f5:	8b 40 48             	mov    0x48(%eax),%eax
  8019f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a00:	c7 04 24 bc 30 80 00 	movl   $0x8030bc,(%esp)
  801a07:	e8 3f e8 ff ff       	call   80024b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a11:	eb 1d                	jmp    801a30 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801a13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a16:	8b 52 18             	mov    0x18(%edx),%edx
  801a19:	85 d2                	test   %edx,%edx
  801a1b:	74 0e                	je     801a2b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a20:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a24:	89 04 24             	mov    %eax,(%esp)
  801a27:	ff d2                	call   *%edx
  801a29:	eb 05                	jmp    801a30 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a2b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a30:	83 c4 24             	add    $0x24,%esp
  801a33:	5b                   	pop    %ebx
  801a34:	5d                   	pop    %ebp
  801a35:	c3                   	ret    

00801a36 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	53                   	push   %ebx
  801a3a:	83 ec 24             	sub    $0x24,%esp
  801a3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a40:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	89 04 24             	mov    %eax,(%esp)
  801a4d:	e8 34 fb ff ff       	call   801586 <fd_lookup>
  801a52:	89 c2                	mov    %eax,%edx
  801a54:	85 d2                	test   %edx,%edx
  801a56:	78 52                	js     801aaa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a62:	8b 00                	mov    (%eax),%eax
  801a64:	89 04 24             	mov    %eax,(%esp)
  801a67:	e8 70 fb ff ff       	call   8015dc <dev_lookup>
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	78 3a                	js     801aaa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a73:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a77:	74 2c                	je     801aa5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a79:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a7c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a83:	00 00 00 
	stat->st_isdir = 0;
  801a86:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a8d:	00 00 00 
	stat->st_dev = dev;
  801a90:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a9d:	89 14 24             	mov    %edx,(%esp)
  801aa0:	ff 50 14             	call   *0x14(%eax)
  801aa3:	eb 05                	jmp    801aaa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801aa5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801aaa:	83 c4 24             	add    $0x24,%esp
  801aad:	5b                   	pop    %ebx
  801aae:	5d                   	pop    %ebp
  801aaf:	c3                   	ret    

00801ab0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
  801ab3:	56                   	push   %esi
  801ab4:	53                   	push   %ebx
  801ab5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ab8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801abf:	00 
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	89 04 24             	mov    %eax,(%esp)
  801ac6:	e8 84 02 00 00       	call   801d4f <open>
  801acb:	89 c3                	mov    %eax,%ebx
  801acd:	85 db                	test   %ebx,%ebx
  801acf:	78 1b                	js     801aec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad8:	89 1c 24             	mov    %ebx,(%esp)
  801adb:	e8 56 ff ff ff       	call   801a36 <fstat>
  801ae0:	89 c6                	mov    %eax,%esi
	close(fd);
  801ae2:	89 1c 24             	mov    %ebx,(%esp)
  801ae5:	e8 cd fb ff ff       	call   8016b7 <close>
	return r;
  801aea:	89 f0                	mov    %esi,%eax
}
  801aec:	83 c4 10             	add    $0x10,%esp
  801aef:	5b                   	pop    %ebx
  801af0:	5e                   	pop    %esi
  801af1:	5d                   	pop    %ebp
  801af2:	c3                   	ret    

00801af3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	56                   	push   %esi
  801af7:	53                   	push   %ebx
  801af8:	83 ec 10             	sub    $0x10,%esp
  801afb:	89 c6                	mov    %eax,%esi
  801afd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801aff:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b06:	75 11                	jne    801b19 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b08:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b0f:	e8 c1 f9 ff ff       	call   8014d5 <ipc_find_env>
  801b14:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b19:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b20:	00 
  801b21:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b28:	00 
  801b29:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b2d:	a1 00 50 80 00       	mov    0x805000,%eax
  801b32:	89 04 24             	mov    %eax,(%esp)
  801b35:	e8 0e f9 ff ff       	call   801448 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b41:	00 
  801b42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b4d:	e8 8e f8 ff ff       	call   8013e0 <ipc_recv>
}
  801b52:	83 c4 10             	add    $0x10,%esp
  801b55:	5b                   	pop    %ebx
  801b56:	5e                   	pop    %esi
  801b57:	5d                   	pop    %ebp
  801b58:	c3                   	ret    

00801b59 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	8b 40 0c             	mov    0xc(%eax),%eax
  801b65:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b72:	ba 00 00 00 00       	mov    $0x0,%edx
  801b77:	b8 02 00 00 00       	mov    $0x2,%eax
  801b7c:	e8 72 ff ff ff       	call   801af3 <fsipc>
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b8f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b94:	ba 00 00 00 00       	mov    $0x0,%edx
  801b99:	b8 06 00 00 00       	mov    $0x6,%eax
  801b9e:	e8 50 ff ff ff       	call   801af3 <fsipc>
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	53                   	push   %ebx
  801ba9:	83 ec 14             	sub    $0x14,%esp
  801bac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bba:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbf:	b8 05 00 00 00       	mov    $0x5,%eax
  801bc4:	e8 2a ff ff ff       	call   801af3 <fsipc>
  801bc9:	89 c2                	mov    %eax,%edx
  801bcb:	85 d2                	test   %edx,%edx
  801bcd:	78 2b                	js     801bfa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bcf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bd6:	00 
  801bd7:	89 1c 24             	mov    %ebx,(%esp)
  801bda:	e8 98 ec ff ff       	call   800877 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bdf:	a1 80 60 80 00       	mov    0x806080,%eax
  801be4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bea:	a1 84 60 80 00       	mov    0x806084,%eax
  801bef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfa:	83 c4 14             	add    $0x14,%esp
  801bfd:	5b                   	pop    %ebx
  801bfe:	5d                   	pop    %ebp
  801bff:	c3                   	ret    

00801c00 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	53                   	push   %ebx
  801c04:	83 ec 14             	sub    $0x14,%esp
  801c07:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c10:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801c15:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801c1b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801c20:	0f 46 c3             	cmovbe %ebx,%eax
  801c23:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801c28:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c33:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801c3a:	e8 d5 ed ff ff       	call   800a14 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c44:	b8 04 00 00 00       	mov    $0x4,%eax
  801c49:	e8 a5 fe ff ff       	call   801af3 <fsipc>
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	78 53                	js     801ca5 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801c52:	39 c3                	cmp    %eax,%ebx
  801c54:	73 24                	jae    801c7a <devfile_write+0x7a>
  801c56:	c7 44 24 0c 2c 31 80 	movl   $0x80312c,0xc(%esp)
  801c5d:	00 
  801c5e:	c7 44 24 08 33 31 80 	movl   $0x803133,0x8(%esp)
  801c65:	00 
  801c66:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801c6d:	00 
  801c6e:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  801c75:	e8 ac 0b 00 00       	call   802826 <_panic>
	assert(r <= PGSIZE);
  801c7a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c7f:	7e 24                	jle    801ca5 <devfile_write+0xa5>
  801c81:	c7 44 24 0c 53 31 80 	movl   $0x803153,0xc(%esp)
  801c88:	00 
  801c89:	c7 44 24 08 33 31 80 	movl   $0x803133,0x8(%esp)
  801c90:	00 
  801c91:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801c98:	00 
  801c99:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  801ca0:	e8 81 0b 00 00       	call   802826 <_panic>
	return r;
}
  801ca5:	83 c4 14             	add    $0x14,%esp
  801ca8:	5b                   	pop    %ebx
  801ca9:	5d                   	pop    %ebp
  801caa:	c3                   	ret    

00801cab <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	56                   	push   %esi
  801caf:	53                   	push   %ebx
  801cb0:	83 ec 10             	sub    $0x10,%esp
  801cb3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	8b 40 0c             	mov    0xc(%eax),%eax
  801cbc:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801cc1:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cc7:	ba 00 00 00 00       	mov    $0x0,%edx
  801ccc:	b8 03 00 00 00       	mov    $0x3,%eax
  801cd1:	e8 1d fe ff ff       	call   801af3 <fsipc>
  801cd6:	89 c3                	mov    %eax,%ebx
  801cd8:	85 c0                	test   %eax,%eax
  801cda:	78 6a                	js     801d46 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801cdc:	39 c6                	cmp    %eax,%esi
  801cde:	73 24                	jae    801d04 <devfile_read+0x59>
  801ce0:	c7 44 24 0c 2c 31 80 	movl   $0x80312c,0xc(%esp)
  801ce7:	00 
  801ce8:	c7 44 24 08 33 31 80 	movl   $0x803133,0x8(%esp)
  801cef:	00 
  801cf0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801cf7:	00 
  801cf8:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  801cff:	e8 22 0b 00 00       	call   802826 <_panic>
	assert(r <= PGSIZE);
  801d04:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d09:	7e 24                	jle    801d2f <devfile_read+0x84>
  801d0b:	c7 44 24 0c 53 31 80 	movl   $0x803153,0xc(%esp)
  801d12:	00 
  801d13:	c7 44 24 08 33 31 80 	movl   $0x803133,0x8(%esp)
  801d1a:	00 
  801d1b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801d22:	00 
  801d23:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  801d2a:	e8 f7 0a 00 00       	call   802826 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d2f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d33:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d3a:	00 
  801d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3e:	89 04 24             	mov    %eax,(%esp)
  801d41:	e8 ce ec ff ff       	call   800a14 <memmove>
	return r;
}
  801d46:	89 d8                	mov    %ebx,%eax
  801d48:	83 c4 10             	add    $0x10,%esp
  801d4b:	5b                   	pop    %ebx
  801d4c:	5e                   	pop    %esi
  801d4d:	5d                   	pop    %ebp
  801d4e:	c3                   	ret    

00801d4f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	53                   	push   %ebx
  801d53:	83 ec 24             	sub    $0x24,%esp
  801d56:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d59:	89 1c 24             	mov    %ebx,(%esp)
  801d5c:	e8 df ea ff ff       	call   800840 <strlen>
  801d61:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d66:	7f 60                	jg     801dc8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d68:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6b:	89 04 24             	mov    %eax,(%esp)
  801d6e:	e8 c4 f7 ff ff       	call   801537 <fd_alloc>
  801d73:	89 c2                	mov    %eax,%edx
  801d75:	85 d2                	test   %edx,%edx
  801d77:	78 54                	js     801dcd <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d79:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d7d:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801d84:	e8 ee ea ff ff       	call   800877 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d94:	b8 01 00 00 00       	mov    $0x1,%eax
  801d99:	e8 55 fd ff ff       	call   801af3 <fsipc>
  801d9e:	89 c3                	mov    %eax,%ebx
  801da0:	85 c0                	test   %eax,%eax
  801da2:	79 17                	jns    801dbb <open+0x6c>
		fd_close(fd, 0);
  801da4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801dab:	00 
  801dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daf:	89 04 24             	mov    %eax,(%esp)
  801db2:	e8 7f f8 ff ff       	call   801636 <fd_close>
		return r;
  801db7:	89 d8                	mov    %ebx,%eax
  801db9:	eb 12                	jmp    801dcd <open+0x7e>
	}

	return fd2num(fd);
  801dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbe:	89 04 24             	mov    %eax,(%esp)
  801dc1:	e8 4a f7 ff ff       	call   801510 <fd2num>
  801dc6:	eb 05                	jmp    801dcd <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801dc8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801dcd:	83 c4 24             	add    $0x24,%esp
  801dd0:	5b                   	pop    %ebx
  801dd1:	5d                   	pop    %ebp
  801dd2:	c3                   	ret    

00801dd3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dd9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dde:	b8 08 00 00 00       	mov    $0x8,%eax
  801de3:	e8 0b fd ff ff       	call   801af3 <fsipc>
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    
  801dea:	66 90                	xchg   %ax,%ax
  801dec:	66 90                	xchg   %ax,%ax
  801dee:	66 90                	xchg   %ax,%ax

00801df0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801df6:	c7 44 24 04 5f 31 80 	movl   $0x80315f,0x4(%esp)
  801dfd:	00 
  801dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e01:	89 04 24             	mov    %eax,(%esp)
  801e04:	e8 6e ea ff ff       	call   800877 <strcpy>
	return 0;
}
  801e09:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	53                   	push   %ebx
  801e14:	83 ec 14             	sub    $0x14,%esp
  801e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e1a:	89 1c 24             	mov    %ebx,(%esp)
  801e1d:	e8 ff 0a 00 00       	call   802921 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801e22:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801e27:	83 f8 01             	cmp    $0x1,%eax
  801e2a:	75 0d                	jne    801e39 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801e2c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e2f:	89 04 24             	mov    %eax,(%esp)
  801e32:	e8 29 03 00 00       	call   802160 <nsipc_close>
  801e37:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801e39:	89 d0                	mov    %edx,%eax
  801e3b:	83 c4 14             	add    $0x14,%esp
  801e3e:	5b                   	pop    %ebx
  801e3f:	5d                   	pop    %ebp
  801e40:	c3                   	ret    

00801e41 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e47:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e4e:	00 
  801e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e52:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	8b 40 0c             	mov    0xc(%eax),%eax
  801e63:	89 04 24             	mov    %eax,(%esp)
  801e66:	e8 f0 03 00 00       	call   80225b <nsipc_send>
}
  801e6b:	c9                   	leave  
  801e6c:	c3                   	ret    

00801e6d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801e6d:	55                   	push   %ebp
  801e6e:	89 e5                	mov    %esp,%ebp
  801e70:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e73:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e7a:	00 
  801e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e85:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8f:	89 04 24             	mov    %eax,(%esp)
  801e92:	e8 44 03 00 00       	call   8021db <nsipc_recv>
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801e9f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ea2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ea6:	89 04 24             	mov    %eax,(%esp)
  801ea9:	e8 d8 f6 ff ff       	call   801586 <fd_lookup>
  801eae:	85 c0                	test   %eax,%eax
  801eb0:	78 17                	js     801ec9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801ebb:	39 08                	cmp    %ecx,(%eax)
  801ebd:	75 05                	jne    801ec4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801ebf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec2:	eb 05                	jmp    801ec9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ec4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	56                   	push   %esi
  801ecf:	53                   	push   %ebx
  801ed0:	83 ec 20             	sub    $0x20,%esp
  801ed3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ed5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed8:	89 04 24             	mov    %eax,(%esp)
  801edb:	e8 57 f6 ff ff       	call   801537 <fd_alloc>
  801ee0:	89 c3                	mov    %eax,%ebx
  801ee2:	85 c0                	test   %eax,%eax
  801ee4:	78 21                	js     801f07 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801ee6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801eed:	00 
  801eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801efc:	e8 92 ed ff ff       	call   800c93 <sys_page_alloc>
  801f01:	89 c3                	mov    %eax,%ebx
  801f03:	85 c0                	test   %eax,%eax
  801f05:	79 0c                	jns    801f13 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801f07:	89 34 24             	mov    %esi,(%esp)
  801f0a:	e8 51 02 00 00       	call   802160 <nsipc_close>
		return r;
  801f0f:	89 d8                	mov    %ebx,%eax
  801f11:	eb 20                	jmp    801f33 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f13:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f21:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801f28:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801f2b:	89 14 24             	mov    %edx,(%esp)
  801f2e:	e8 dd f5 ff ff       	call   801510 <fd2num>
}
  801f33:	83 c4 20             	add    $0x20,%esp
  801f36:	5b                   	pop    %ebx
  801f37:	5e                   	pop    %esi
  801f38:	5d                   	pop    %ebp
  801f39:	c3                   	ret    

00801f3a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f40:	8b 45 08             	mov    0x8(%ebp),%eax
  801f43:	e8 51 ff ff ff       	call   801e99 <fd2sockid>
		return r;
  801f48:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f4a:	85 c0                	test   %eax,%eax
  801f4c:	78 23                	js     801f71 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f4e:	8b 55 10             	mov    0x10(%ebp),%edx
  801f51:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f58:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f5c:	89 04 24             	mov    %eax,(%esp)
  801f5f:	e8 45 01 00 00       	call   8020a9 <nsipc_accept>
		return r;
  801f64:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f66:	85 c0                	test   %eax,%eax
  801f68:	78 07                	js     801f71 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801f6a:	e8 5c ff ff ff       	call   801ecb <alloc_sockfd>
  801f6f:	89 c1                	mov    %eax,%ecx
}
  801f71:	89 c8                	mov    %ecx,%eax
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	e8 16 ff ff ff       	call   801e99 <fd2sockid>
  801f83:	89 c2                	mov    %eax,%edx
  801f85:	85 d2                	test   %edx,%edx
  801f87:	78 16                	js     801f9f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801f89:	8b 45 10             	mov    0x10(%ebp),%eax
  801f8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f97:	89 14 24             	mov    %edx,(%esp)
  801f9a:	e8 60 01 00 00       	call   8020ff <nsipc_bind>
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <shutdown>:

int
shutdown(int s, int how)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801faa:	e8 ea fe ff ff       	call   801e99 <fd2sockid>
  801faf:	89 c2                	mov    %eax,%edx
  801fb1:	85 d2                	test   %edx,%edx
  801fb3:	78 0f                	js     801fc4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbc:	89 14 24             	mov    %edx,(%esp)
  801fbf:	e8 7a 01 00 00       	call   80213e <nsipc_shutdown>
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
  801fc9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	e8 c5 fe ff ff       	call   801e99 <fd2sockid>
  801fd4:	89 c2                	mov    %eax,%edx
  801fd6:	85 d2                	test   %edx,%edx
  801fd8:	78 16                	js     801ff0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801fda:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe8:	89 14 24             	mov    %edx,(%esp)
  801feb:	e8 8a 01 00 00       	call   80217a <nsipc_connect>
}
  801ff0:	c9                   	leave  
  801ff1:	c3                   	ret    

00801ff2 <listen>:

int
listen(int s, int backlog)
{
  801ff2:	55                   	push   %ebp
  801ff3:	89 e5                	mov    %esp,%ebp
  801ff5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	e8 99 fe ff ff       	call   801e99 <fd2sockid>
  802000:	89 c2                	mov    %eax,%edx
  802002:	85 d2                	test   %edx,%edx
  802004:	78 0f                	js     802015 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802006:	8b 45 0c             	mov    0xc(%ebp),%eax
  802009:	89 44 24 04          	mov    %eax,0x4(%esp)
  80200d:	89 14 24             	mov    %edx,(%esp)
  802010:	e8 a4 01 00 00       	call   8021b9 <nsipc_listen>
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80201d:	8b 45 10             	mov    0x10(%ebp),%eax
  802020:	89 44 24 08          	mov    %eax,0x8(%esp)
  802024:	8b 45 0c             	mov    0xc(%ebp),%eax
  802027:	89 44 24 04          	mov    %eax,0x4(%esp)
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	89 04 24             	mov    %eax,(%esp)
  802031:	e8 98 02 00 00       	call   8022ce <nsipc_socket>
  802036:	89 c2                	mov    %eax,%edx
  802038:	85 d2                	test   %edx,%edx
  80203a:	78 05                	js     802041 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80203c:	e8 8a fe ff ff       	call   801ecb <alloc_sockfd>
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	53                   	push   %ebx
  802047:	83 ec 14             	sub    $0x14,%esp
  80204a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80204c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802053:	75 11                	jne    802066 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802055:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80205c:	e8 74 f4 ff ff       	call   8014d5 <ipc_find_env>
  802061:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802066:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80206d:	00 
  80206e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802075:	00 
  802076:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80207a:	a1 04 50 80 00       	mov    0x805004,%eax
  80207f:	89 04 24             	mov    %eax,(%esp)
  802082:	e8 c1 f3 ff ff       	call   801448 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802087:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80208e:	00 
  80208f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802096:	00 
  802097:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80209e:	e8 3d f3 ff ff       	call   8013e0 <ipc_recv>
}
  8020a3:	83 c4 14             	add    $0x14,%esp
  8020a6:	5b                   	pop    %ebx
  8020a7:	5d                   	pop    %ebp
  8020a8:	c3                   	ret    

008020a9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	56                   	push   %esi
  8020ad:	53                   	push   %ebx
  8020ae:	83 ec 10             	sub    $0x10,%esp
  8020b1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020bc:	8b 06                	mov    (%esi),%eax
  8020be:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020c8:	e8 76 ff ff ff       	call   802043 <nsipc>
  8020cd:	89 c3                	mov    %eax,%ebx
  8020cf:	85 c0                	test   %eax,%eax
  8020d1:	78 23                	js     8020f6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020d3:	a1 10 70 80 00       	mov    0x807010,%eax
  8020d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020dc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8020e3:	00 
  8020e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e7:	89 04 24             	mov    %eax,(%esp)
  8020ea:	e8 25 e9 ff ff       	call   800a14 <memmove>
		*addrlen = ret->ret_addrlen;
  8020ef:	a1 10 70 80 00       	mov    0x807010,%eax
  8020f4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8020f6:	89 d8                	mov    %ebx,%eax
  8020f8:	83 c4 10             	add    $0x10,%esp
  8020fb:	5b                   	pop    %ebx
  8020fc:	5e                   	pop    %esi
  8020fd:	5d                   	pop    %ebp
  8020fe:	c3                   	ret    

008020ff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	53                   	push   %ebx
  802103:	83 ec 14             	sub    $0x14,%esp
  802106:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802111:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802115:	8b 45 0c             	mov    0xc(%ebp),%eax
  802118:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802123:	e8 ec e8 ff ff       	call   800a14 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802128:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80212e:	b8 02 00 00 00       	mov    $0x2,%eax
  802133:	e8 0b ff ff ff       	call   802043 <nsipc>
}
  802138:	83 c4 14             	add    $0x14,%esp
  80213b:	5b                   	pop    %ebx
  80213c:	5d                   	pop    %ebp
  80213d:	c3                   	ret    

0080213e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80214c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802154:	b8 03 00 00 00       	mov    $0x3,%eax
  802159:	e8 e5 fe ff ff       	call   802043 <nsipc>
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <nsipc_close>:

int
nsipc_close(int s)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80216e:	b8 04 00 00 00       	mov    $0x4,%eax
  802173:	e8 cb fe ff ff       	call   802043 <nsipc>
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	53                   	push   %ebx
  80217e:	83 ec 14             	sub    $0x14,%esp
  802181:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80218c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802190:	8b 45 0c             	mov    0xc(%ebp),%eax
  802193:	89 44 24 04          	mov    %eax,0x4(%esp)
  802197:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80219e:	e8 71 e8 ff ff       	call   800a14 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021a3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021a9:	b8 05 00 00 00       	mov    $0x5,%eax
  8021ae:	e8 90 fe ff ff       	call   802043 <nsipc>
}
  8021b3:	83 c4 14             	add    $0x14,%esp
  8021b6:	5b                   	pop    %ebx
  8021b7:	5d                   	pop    %ebp
  8021b8:	c3                   	ret    

008021b9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ca:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021cf:	b8 06 00 00 00       	mov    $0x6,%eax
  8021d4:	e8 6a fe ff ff       	call   802043 <nsipc>
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	56                   	push   %esi
  8021df:	53                   	push   %ebx
  8021e0:	83 ec 10             	sub    $0x10,%esp
  8021e3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8021ee:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8021f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8021fc:	b8 07 00 00 00       	mov    $0x7,%eax
  802201:	e8 3d fe ff ff       	call   802043 <nsipc>
  802206:	89 c3                	mov    %eax,%ebx
  802208:	85 c0                	test   %eax,%eax
  80220a:	78 46                	js     802252 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80220c:	39 f0                	cmp    %esi,%eax
  80220e:	7f 07                	jg     802217 <nsipc_recv+0x3c>
  802210:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802215:	7e 24                	jle    80223b <nsipc_recv+0x60>
  802217:	c7 44 24 0c 6b 31 80 	movl   $0x80316b,0xc(%esp)
  80221e:	00 
  80221f:	c7 44 24 08 33 31 80 	movl   $0x803133,0x8(%esp)
  802226:	00 
  802227:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80222e:	00 
  80222f:	c7 04 24 80 31 80 00 	movl   $0x803180,(%esp)
  802236:	e8 eb 05 00 00       	call   802826 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80223b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80223f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802246:	00 
  802247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224a:	89 04 24             	mov    %eax,(%esp)
  80224d:	e8 c2 e7 ff ff       	call   800a14 <memmove>
	}

	return r;
}
  802252:	89 d8                	mov    %ebx,%eax
  802254:	83 c4 10             	add    $0x10,%esp
  802257:	5b                   	pop    %ebx
  802258:	5e                   	pop    %esi
  802259:	5d                   	pop    %ebp
  80225a:	c3                   	ret    

0080225b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	53                   	push   %ebx
  80225f:	83 ec 14             	sub    $0x14,%esp
  802262:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80226d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802273:	7e 24                	jle    802299 <nsipc_send+0x3e>
  802275:	c7 44 24 0c 8c 31 80 	movl   $0x80318c,0xc(%esp)
  80227c:	00 
  80227d:	c7 44 24 08 33 31 80 	movl   $0x803133,0x8(%esp)
  802284:	00 
  802285:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80228c:	00 
  80228d:	c7 04 24 80 31 80 00 	movl   $0x803180,(%esp)
  802294:	e8 8d 05 00 00       	call   802826 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802299:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80229d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8022ab:	e8 64 e7 ff ff       	call   800a14 <memmove>
	nsipcbuf.send.req_size = size;
  8022b0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022b9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022be:	b8 08 00 00 00       	mov    $0x8,%eax
  8022c3:	e8 7b fd ff ff       	call   802043 <nsipc>
}
  8022c8:	83 c4 14             	add    $0x14,%esp
  8022cb:	5b                   	pop    %ebx
  8022cc:	5d                   	pop    %ebp
  8022cd:	c3                   	ret    

008022ce <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
  8022d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022df:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8022e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8022ec:	b8 09 00 00 00       	mov    $0x9,%eax
  8022f1:	e8 4d fd ff ff       	call   802043 <nsipc>
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
  8022fb:	56                   	push   %esi
  8022fc:	53                   	push   %ebx
  8022fd:	83 ec 10             	sub    $0x10,%esp
  802300:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	89 04 24             	mov    %eax,(%esp)
  802309:	e8 12 f2 ff ff       	call   801520 <fd2data>
  80230e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802310:	c7 44 24 04 98 31 80 	movl   $0x803198,0x4(%esp)
  802317:	00 
  802318:	89 1c 24             	mov    %ebx,(%esp)
  80231b:	e8 57 e5 ff ff       	call   800877 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802320:	8b 46 04             	mov    0x4(%esi),%eax
  802323:	2b 06                	sub    (%esi),%eax
  802325:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80232b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802332:	00 00 00 
	stat->st_dev = &devpipe;
  802335:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80233c:	40 80 00 
	return 0;
}
  80233f:	b8 00 00 00 00       	mov    $0x0,%eax
  802344:	83 c4 10             	add    $0x10,%esp
  802347:	5b                   	pop    %ebx
  802348:	5e                   	pop    %esi
  802349:	5d                   	pop    %ebp
  80234a:	c3                   	ret    

0080234b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	53                   	push   %ebx
  80234f:	83 ec 14             	sub    $0x14,%esp
  802352:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802355:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802359:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802360:	e8 d5 e9 ff ff       	call   800d3a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802365:	89 1c 24             	mov    %ebx,(%esp)
  802368:	e8 b3 f1 ff ff       	call   801520 <fd2data>
  80236d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802371:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802378:	e8 bd e9 ff ff       	call   800d3a <sys_page_unmap>
}
  80237d:	83 c4 14             	add    $0x14,%esp
  802380:	5b                   	pop    %ebx
  802381:	5d                   	pop    %ebp
  802382:	c3                   	ret    

00802383 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	57                   	push   %edi
  802387:	56                   	push   %esi
  802388:	53                   	push   %ebx
  802389:	83 ec 2c             	sub    $0x2c,%esp
  80238c:	89 c6                	mov    %eax,%esi
  80238e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802391:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802396:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802399:	89 34 24             	mov    %esi,(%esp)
  80239c:	e8 80 05 00 00       	call   802921 <pageref>
  8023a1:	89 c7                	mov    %eax,%edi
  8023a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023a6:	89 04 24             	mov    %eax,(%esp)
  8023a9:	e8 73 05 00 00       	call   802921 <pageref>
  8023ae:	39 c7                	cmp    %eax,%edi
  8023b0:	0f 94 c2             	sete   %dl
  8023b3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8023b6:	8b 0d 0c 50 80 00    	mov    0x80500c,%ecx
  8023bc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8023bf:	39 fb                	cmp    %edi,%ebx
  8023c1:	74 21                	je     8023e4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8023c3:	84 d2                	test   %dl,%dl
  8023c5:	74 ca                	je     802391 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023c7:	8b 51 58             	mov    0x58(%ecx),%edx
  8023ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023ce:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023d6:	c7 04 24 9f 31 80 00 	movl   $0x80319f,(%esp)
  8023dd:	e8 69 de ff ff       	call   80024b <cprintf>
  8023e2:	eb ad                	jmp    802391 <_pipeisclosed+0xe>
	}
}
  8023e4:	83 c4 2c             	add    $0x2c,%esp
  8023e7:	5b                   	pop    %ebx
  8023e8:	5e                   	pop    %esi
  8023e9:	5f                   	pop    %edi
  8023ea:	5d                   	pop    %ebp
  8023eb:	c3                   	ret    

008023ec <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	57                   	push   %edi
  8023f0:	56                   	push   %esi
  8023f1:	53                   	push   %ebx
  8023f2:	83 ec 1c             	sub    $0x1c,%esp
  8023f5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8023f8:	89 34 24             	mov    %esi,(%esp)
  8023fb:	e8 20 f1 ff ff       	call   801520 <fd2data>
  802400:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802402:	bf 00 00 00 00       	mov    $0x0,%edi
  802407:	eb 45                	jmp    80244e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802409:	89 da                	mov    %ebx,%edx
  80240b:	89 f0                	mov    %esi,%eax
  80240d:	e8 71 ff ff ff       	call   802383 <_pipeisclosed>
  802412:	85 c0                	test   %eax,%eax
  802414:	75 41                	jne    802457 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802416:	e8 59 e8 ff ff       	call   800c74 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80241b:	8b 43 04             	mov    0x4(%ebx),%eax
  80241e:	8b 0b                	mov    (%ebx),%ecx
  802420:	8d 51 20             	lea    0x20(%ecx),%edx
  802423:	39 d0                	cmp    %edx,%eax
  802425:	73 e2                	jae    802409 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802427:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80242a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80242e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802431:	99                   	cltd   
  802432:	c1 ea 1b             	shr    $0x1b,%edx
  802435:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802438:	83 e1 1f             	and    $0x1f,%ecx
  80243b:	29 d1                	sub    %edx,%ecx
  80243d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802441:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802445:	83 c0 01             	add    $0x1,%eax
  802448:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80244b:	83 c7 01             	add    $0x1,%edi
  80244e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802451:	75 c8                	jne    80241b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802453:	89 f8                	mov    %edi,%eax
  802455:	eb 05                	jmp    80245c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802457:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80245c:	83 c4 1c             	add    $0x1c,%esp
  80245f:	5b                   	pop    %ebx
  802460:	5e                   	pop    %esi
  802461:	5f                   	pop    %edi
  802462:	5d                   	pop    %ebp
  802463:	c3                   	ret    

00802464 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
  802467:	57                   	push   %edi
  802468:	56                   	push   %esi
  802469:	53                   	push   %ebx
  80246a:	83 ec 1c             	sub    $0x1c,%esp
  80246d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802470:	89 3c 24             	mov    %edi,(%esp)
  802473:	e8 a8 f0 ff ff       	call   801520 <fd2data>
  802478:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80247a:	be 00 00 00 00       	mov    $0x0,%esi
  80247f:	eb 3d                	jmp    8024be <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802481:	85 f6                	test   %esi,%esi
  802483:	74 04                	je     802489 <devpipe_read+0x25>
				return i;
  802485:	89 f0                	mov    %esi,%eax
  802487:	eb 43                	jmp    8024cc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802489:	89 da                	mov    %ebx,%edx
  80248b:	89 f8                	mov    %edi,%eax
  80248d:	e8 f1 fe ff ff       	call   802383 <_pipeisclosed>
  802492:	85 c0                	test   %eax,%eax
  802494:	75 31                	jne    8024c7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802496:	e8 d9 e7 ff ff       	call   800c74 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80249b:	8b 03                	mov    (%ebx),%eax
  80249d:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024a0:	74 df                	je     802481 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024a2:	99                   	cltd   
  8024a3:	c1 ea 1b             	shr    $0x1b,%edx
  8024a6:	01 d0                	add    %edx,%eax
  8024a8:	83 e0 1f             	and    $0x1f,%eax
  8024ab:	29 d0                	sub    %edx,%eax
  8024ad:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024b5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024b8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024bb:	83 c6 01             	add    $0x1,%esi
  8024be:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024c1:	75 d8                	jne    80249b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8024c3:	89 f0                	mov    %esi,%eax
  8024c5:	eb 05                	jmp    8024cc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024c7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8024cc:	83 c4 1c             	add    $0x1c,%esp
  8024cf:	5b                   	pop    %ebx
  8024d0:	5e                   	pop    %esi
  8024d1:	5f                   	pop    %edi
  8024d2:	5d                   	pop    %ebp
  8024d3:	c3                   	ret    

008024d4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
  8024d7:	56                   	push   %esi
  8024d8:	53                   	push   %ebx
  8024d9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8024dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024df:	89 04 24             	mov    %eax,(%esp)
  8024e2:	e8 50 f0 ff ff       	call   801537 <fd_alloc>
  8024e7:	89 c2                	mov    %eax,%edx
  8024e9:	85 d2                	test   %edx,%edx
  8024eb:	0f 88 4d 01 00 00    	js     80263e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024f1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024f8:	00 
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802500:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802507:	e8 87 e7 ff ff       	call   800c93 <sys_page_alloc>
  80250c:	89 c2                	mov    %eax,%edx
  80250e:	85 d2                	test   %edx,%edx
  802510:	0f 88 28 01 00 00    	js     80263e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802516:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802519:	89 04 24             	mov    %eax,(%esp)
  80251c:	e8 16 f0 ff ff       	call   801537 <fd_alloc>
  802521:	89 c3                	mov    %eax,%ebx
  802523:	85 c0                	test   %eax,%eax
  802525:	0f 88 fe 00 00 00    	js     802629 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80252b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802532:	00 
  802533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802536:	89 44 24 04          	mov    %eax,0x4(%esp)
  80253a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802541:	e8 4d e7 ff ff       	call   800c93 <sys_page_alloc>
  802546:	89 c3                	mov    %eax,%ebx
  802548:	85 c0                	test   %eax,%eax
  80254a:	0f 88 d9 00 00 00    	js     802629 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	89 04 24             	mov    %eax,(%esp)
  802556:	e8 c5 ef ff ff       	call   801520 <fd2data>
  80255b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80255d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802564:	00 
  802565:	89 44 24 04          	mov    %eax,0x4(%esp)
  802569:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802570:	e8 1e e7 ff ff       	call   800c93 <sys_page_alloc>
  802575:	89 c3                	mov    %eax,%ebx
  802577:	85 c0                	test   %eax,%eax
  802579:	0f 88 97 00 00 00    	js     802616 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80257f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802582:	89 04 24             	mov    %eax,(%esp)
  802585:	e8 96 ef ff ff       	call   801520 <fd2data>
  80258a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802591:	00 
  802592:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802596:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80259d:	00 
  80259e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a9:	e8 39 e7 ff ff       	call   800ce7 <sys_page_map>
  8025ae:	89 c3                	mov    %eax,%ebx
  8025b0:	85 c0                	test   %eax,%eax
  8025b2:	78 52                	js     802606 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8025b4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8025c9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8025d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	89 04 24             	mov    %eax,(%esp)
  8025e4:	e8 27 ef ff ff       	call   801510 <fd2num>
  8025e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025ec:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f1:	89 04 24             	mov    %eax,(%esp)
  8025f4:	e8 17 ef ff ff       	call   801510 <fd2num>
  8025f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025fc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8025ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802604:	eb 38                	jmp    80263e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802606:	89 74 24 04          	mov    %esi,0x4(%esp)
  80260a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802611:	e8 24 e7 ff ff       	call   800d3a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802619:	89 44 24 04          	mov    %eax,0x4(%esp)
  80261d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802624:	e8 11 e7 ff ff       	call   800d3a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802630:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802637:	e8 fe e6 ff ff       	call   800d3a <sys_page_unmap>
  80263c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80263e:	83 c4 30             	add    $0x30,%esp
  802641:	5b                   	pop    %ebx
  802642:	5e                   	pop    %esi
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    

00802645 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80264b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80264e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802652:	8b 45 08             	mov    0x8(%ebp),%eax
  802655:	89 04 24             	mov    %eax,(%esp)
  802658:	e8 29 ef ff ff       	call   801586 <fd_lookup>
  80265d:	89 c2                	mov    %eax,%edx
  80265f:	85 d2                	test   %edx,%edx
  802661:	78 15                	js     802678 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	89 04 24             	mov    %eax,(%esp)
  802669:	e8 b2 ee ff ff       	call   801520 <fd2data>
	return _pipeisclosed(fd, p);
  80266e:	89 c2                	mov    %eax,%edx
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	e8 0b fd ff ff       	call   802383 <_pipeisclosed>
}
  802678:	c9                   	leave  
  802679:	c3                   	ret    
  80267a:	66 90                	xchg   %ax,%ax
  80267c:	66 90                	xchg   %ax,%ax
  80267e:	66 90                	xchg   %ax,%ax

00802680 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802683:	b8 00 00 00 00       	mov    $0x0,%eax
  802688:	5d                   	pop    %ebp
  802689:	c3                   	ret    

0080268a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802690:	c7 44 24 04 b7 31 80 	movl   $0x8031b7,0x4(%esp)
  802697:	00 
  802698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80269b:	89 04 24             	mov    %eax,(%esp)
  80269e:	e8 d4 e1 ff ff       	call   800877 <strcpy>
	return 0;
}
  8026a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a8:	c9                   	leave  
  8026a9:	c3                   	ret    

008026aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
  8026ad:	57                   	push   %edi
  8026ae:	56                   	push   %esi
  8026af:	53                   	push   %ebx
  8026b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026bb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026c1:	eb 31                	jmp    8026f4 <devcons_write+0x4a>
		m = n - tot;
  8026c3:	8b 75 10             	mov    0x10(%ebp),%esi
  8026c6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8026c8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8026cb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8026d0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026d3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8026d7:	03 45 0c             	add    0xc(%ebp),%eax
  8026da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026de:	89 3c 24             	mov    %edi,(%esp)
  8026e1:	e8 2e e3 ff ff       	call   800a14 <memmove>
		sys_cputs(buf, m);
  8026e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026ea:	89 3c 24             	mov    %edi,(%esp)
  8026ed:	e8 d4 e4 ff ff       	call   800bc6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026f2:	01 f3                	add    %esi,%ebx
  8026f4:	89 d8                	mov    %ebx,%eax
  8026f6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8026f9:	72 c8                	jb     8026c3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8026fb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802701:	5b                   	pop    %ebx
  802702:	5e                   	pop    %esi
  802703:	5f                   	pop    %edi
  802704:	5d                   	pop    %ebp
  802705:	c3                   	ret    

00802706 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80270c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802711:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802715:	75 07                	jne    80271e <devcons_read+0x18>
  802717:	eb 2a                	jmp    802743 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802719:	e8 56 e5 ff ff       	call   800c74 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80271e:	66 90                	xchg   %ax,%ax
  802720:	e8 bf e4 ff ff       	call   800be4 <sys_cgetc>
  802725:	85 c0                	test   %eax,%eax
  802727:	74 f0                	je     802719 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802729:	85 c0                	test   %eax,%eax
  80272b:	78 16                	js     802743 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80272d:	83 f8 04             	cmp    $0x4,%eax
  802730:	74 0c                	je     80273e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802732:	8b 55 0c             	mov    0xc(%ebp),%edx
  802735:	88 02                	mov    %al,(%edx)
	return 1;
  802737:	b8 01 00 00 00       	mov    $0x1,%eax
  80273c:	eb 05                	jmp    802743 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80273e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802743:	c9                   	leave  
  802744:	c3                   	ret    

00802745 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802745:	55                   	push   %ebp
  802746:	89 e5                	mov    %esp,%ebp
  802748:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802751:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802758:	00 
  802759:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80275c:	89 04 24             	mov    %eax,(%esp)
  80275f:	e8 62 e4 ff ff       	call   800bc6 <sys_cputs>
}
  802764:	c9                   	leave  
  802765:	c3                   	ret    

00802766 <getchar>:

int
getchar(void)
{
  802766:	55                   	push   %ebp
  802767:	89 e5                	mov    %esp,%ebp
  802769:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80276c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802773:	00 
  802774:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802777:	89 44 24 04          	mov    %eax,0x4(%esp)
  80277b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802782:	e8 93 f0 ff ff       	call   80181a <read>
	if (r < 0)
  802787:	85 c0                	test   %eax,%eax
  802789:	78 0f                	js     80279a <getchar+0x34>
		return r;
	if (r < 1)
  80278b:	85 c0                	test   %eax,%eax
  80278d:	7e 06                	jle    802795 <getchar+0x2f>
		return -E_EOF;
	return c;
  80278f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802793:	eb 05                	jmp    80279a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802795:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80279a:	c9                   	leave  
  80279b:	c3                   	ret    

0080279c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
  80279f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ac:	89 04 24             	mov    %eax,(%esp)
  8027af:	e8 d2 ed ff ff       	call   801586 <fd_lookup>
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	78 11                	js     8027c9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027c1:	39 10                	cmp    %edx,(%eax)
  8027c3:	0f 94 c0             	sete   %al
  8027c6:	0f b6 c0             	movzbl %al,%eax
}
  8027c9:	c9                   	leave  
  8027ca:	c3                   	ret    

008027cb <opencons>:

int
opencons(void)
{
  8027cb:	55                   	push   %ebp
  8027cc:	89 e5                	mov    %esp,%ebp
  8027ce:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8027d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027d4:	89 04 24             	mov    %eax,(%esp)
  8027d7:	e8 5b ed ff ff       	call   801537 <fd_alloc>
		return r;
  8027dc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8027de:	85 c0                	test   %eax,%eax
  8027e0:	78 40                	js     802822 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027e2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027e9:	00 
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027f8:	e8 96 e4 ff ff       	call   800c93 <sys_page_alloc>
		return r;
  8027fd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8027ff:	85 c0                	test   %eax,%eax
  802801:	78 1f                	js     802822 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802803:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802818:	89 04 24             	mov    %eax,(%esp)
  80281b:	e8 f0 ec ff ff       	call   801510 <fd2num>
  802820:	89 c2                	mov    %eax,%edx
}
  802822:	89 d0                	mov    %edx,%eax
  802824:	c9                   	leave  
  802825:	c3                   	ret    

00802826 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802826:	55                   	push   %ebp
  802827:	89 e5                	mov    %esp,%ebp
  802829:	56                   	push   %esi
  80282a:	53                   	push   %ebx
  80282b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80282e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802831:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802837:	e8 19 e4 ff ff       	call   800c55 <sys_getenvid>
  80283c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80283f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802843:	8b 55 08             	mov    0x8(%ebp),%edx
  802846:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80284a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80284e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802852:	c7 04 24 c4 31 80 00 	movl   $0x8031c4,(%esp)
  802859:	e8 ed d9 ff ff       	call   80024b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80285e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802862:	8b 45 10             	mov    0x10(%ebp),%eax
  802865:	89 04 24             	mov    %eax,(%esp)
  802868:	e8 7d d9 ff ff       	call   8001ea <vcprintf>
	cprintf("\n");
  80286d:	c7 04 24 b0 31 80 00 	movl   $0x8031b0,(%esp)
  802874:	e8 d2 d9 ff ff       	call   80024b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802879:	cc                   	int3   
  80287a:	eb fd                	jmp    802879 <_panic+0x53>

0080287c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80287c:	55                   	push   %ebp
  80287d:	89 e5                	mov    %esp,%ebp
  80287f:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802882:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802889:	75 68                	jne    8028f3 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  80288b:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802890:	8b 40 48             	mov    0x48(%eax),%eax
  802893:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80289a:	00 
  80289b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8028a2:	ee 
  8028a3:	89 04 24             	mov    %eax,(%esp)
  8028a6:	e8 e8 e3 ff ff       	call   800c93 <sys_page_alloc>
  8028ab:	85 c0                	test   %eax,%eax
  8028ad:	74 2c                	je     8028db <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  8028af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028b3:	c7 04 24 e8 31 80 00 	movl   $0x8031e8,(%esp)
  8028ba:	e8 8c d9 ff ff       	call   80024b <cprintf>
			panic("set_pg_fault_handler");
  8028bf:	c7 44 24 08 1c 32 80 	movl   $0x80321c,0x8(%esp)
  8028c6:	00 
  8028c7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8028ce:	00 
  8028cf:	c7 04 24 31 32 80 00 	movl   $0x803231,(%esp)
  8028d6:	e8 4b ff ff ff       	call   802826 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  8028db:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8028e0:	8b 40 48             	mov    0x48(%eax),%eax
  8028e3:	c7 44 24 04 fd 28 80 	movl   $0x8028fd,0x4(%esp)
  8028ea:	00 
  8028eb:	89 04 24             	mov    %eax,(%esp)
  8028ee:	e8 40 e5 ff ff       	call   800e33 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028fb:	c9                   	leave  
  8028fc:	c3                   	ret    

008028fd <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028fd:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028fe:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802903:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802905:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  802908:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  80290c:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  80290e:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  802912:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  802913:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  802916:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  802918:	58                   	pop    %eax
	popl %eax
  802919:	58                   	pop    %eax
	popal
  80291a:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80291b:	83 c4 04             	add    $0x4,%esp
	popfl
  80291e:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80291f:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802920:	c3                   	ret    

00802921 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802921:	55                   	push   %ebp
  802922:	89 e5                	mov    %esp,%ebp
  802924:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802927:	89 d0                	mov    %edx,%eax
  802929:	c1 e8 16             	shr    $0x16,%eax
  80292c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802933:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802938:	f6 c1 01             	test   $0x1,%cl
  80293b:	74 1d                	je     80295a <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80293d:	c1 ea 0c             	shr    $0xc,%edx
  802940:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802947:	f6 c2 01             	test   $0x1,%dl
  80294a:	74 0e                	je     80295a <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80294c:	c1 ea 0c             	shr    $0xc,%edx
  80294f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802956:	ef 
  802957:	0f b7 c0             	movzwl %ax,%eax
}
  80295a:	5d                   	pop    %ebp
  80295b:	c3                   	ret    
  80295c:	66 90                	xchg   %ax,%ax
  80295e:	66 90                	xchg   %ax,%ax

00802960 <__udivdi3>:
  802960:	55                   	push   %ebp
  802961:	57                   	push   %edi
  802962:	56                   	push   %esi
  802963:	83 ec 0c             	sub    $0xc,%esp
  802966:	8b 44 24 28          	mov    0x28(%esp),%eax
  80296a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80296e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802972:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802976:	85 c0                	test   %eax,%eax
  802978:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80297c:	89 ea                	mov    %ebp,%edx
  80297e:	89 0c 24             	mov    %ecx,(%esp)
  802981:	75 2d                	jne    8029b0 <__udivdi3+0x50>
  802983:	39 e9                	cmp    %ebp,%ecx
  802985:	77 61                	ja     8029e8 <__udivdi3+0x88>
  802987:	85 c9                	test   %ecx,%ecx
  802989:	89 ce                	mov    %ecx,%esi
  80298b:	75 0b                	jne    802998 <__udivdi3+0x38>
  80298d:	b8 01 00 00 00       	mov    $0x1,%eax
  802992:	31 d2                	xor    %edx,%edx
  802994:	f7 f1                	div    %ecx
  802996:	89 c6                	mov    %eax,%esi
  802998:	31 d2                	xor    %edx,%edx
  80299a:	89 e8                	mov    %ebp,%eax
  80299c:	f7 f6                	div    %esi
  80299e:	89 c5                	mov    %eax,%ebp
  8029a0:	89 f8                	mov    %edi,%eax
  8029a2:	f7 f6                	div    %esi
  8029a4:	89 ea                	mov    %ebp,%edx
  8029a6:	83 c4 0c             	add    $0xc,%esp
  8029a9:	5e                   	pop    %esi
  8029aa:	5f                   	pop    %edi
  8029ab:	5d                   	pop    %ebp
  8029ac:	c3                   	ret    
  8029ad:	8d 76 00             	lea    0x0(%esi),%esi
  8029b0:	39 e8                	cmp    %ebp,%eax
  8029b2:	77 24                	ja     8029d8 <__udivdi3+0x78>
  8029b4:	0f bd e8             	bsr    %eax,%ebp
  8029b7:	83 f5 1f             	xor    $0x1f,%ebp
  8029ba:	75 3c                	jne    8029f8 <__udivdi3+0x98>
  8029bc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8029c0:	39 34 24             	cmp    %esi,(%esp)
  8029c3:	0f 86 9f 00 00 00    	jbe    802a68 <__udivdi3+0x108>
  8029c9:	39 d0                	cmp    %edx,%eax
  8029cb:	0f 82 97 00 00 00    	jb     802a68 <__udivdi3+0x108>
  8029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029d8:	31 d2                	xor    %edx,%edx
  8029da:	31 c0                	xor    %eax,%eax
  8029dc:	83 c4 0c             	add    $0xc,%esp
  8029df:	5e                   	pop    %esi
  8029e0:	5f                   	pop    %edi
  8029e1:	5d                   	pop    %ebp
  8029e2:	c3                   	ret    
  8029e3:	90                   	nop
  8029e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029e8:	89 f8                	mov    %edi,%eax
  8029ea:	f7 f1                	div    %ecx
  8029ec:	31 d2                	xor    %edx,%edx
  8029ee:	83 c4 0c             	add    $0xc,%esp
  8029f1:	5e                   	pop    %esi
  8029f2:	5f                   	pop    %edi
  8029f3:	5d                   	pop    %ebp
  8029f4:	c3                   	ret    
  8029f5:	8d 76 00             	lea    0x0(%esi),%esi
  8029f8:	89 e9                	mov    %ebp,%ecx
  8029fa:	8b 3c 24             	mov    (%esp),%edi
  8029fd:	d3 e0                	shl    %cl,%eax
  8029ff:	89 c6                	mov    %eax,%esi
  802a01:	b8 20 00 00 00       	mov    $0x20,%eax
  802a06:	29 e8                	sub    %ebp,%eax
  802a08:	89 c1                	mov    %eax,%ecx
  802a0a:	d3 ef                	shr    %cl,%edi
  802a0c:	89 e9                	mov    %ebp,%ecx
  802a0e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802a12:	8b 3c 24             	mov    (%esp),%edi
  802a15:	09 74 24 08          	or     %esi,0x8(%esp)
  802a19:	89 d6                	mov    %edx,%esi
  802a1b:	d3 e7                	shl    %cl,%edi
  802a1d:	89 c1                	mov    %eax,%ecx
  802a1f:	89 3c 24             	mov    %edi,(%esp)
  802a22:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a26:	d3 ee                	shr    %cl,%esi
  802a28:	89 e9                	mov    %ebp,%ecx
  802a2a:	d3 e2                	shl    %cl,%edx
  802a2c:	89 c1                	mov    %eax,%ecx
  802a2e:	d3 ef                	shr    %cl,%edi
  802a30:	09 d7                	or     %edx,%edi
  802a32:	89 f2                	mov    %esi,%edx
  802a34:	89 f8                	mov    %edi,%eax
  802a36:	f7 74 24 08          	divl   0x8(%esp)
  802a3a:	89 d6                	mov    %edx,%esi
  802a3c:	89 c7                	mov    %eax,%edi
  802a3e:	f7 24 24             	mull   (%esp)
  802a41:	39 d6                	cmp    %edx,%esi
  802a43:	89 14 24             	mov    %edx,(%esp)
  802a46:	72 30                	jb     802a78 <__udivdi3+0x118>
  802a48:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a4c:	89 e9                	mov    %ebp,%ecx
  802a4e:	d3 e2                	shl    %cl,%edx
  802a50:	39 c2                	cmp    %eax,%edx
  802a52:	73 05                	jae    802a59 <__udivdi3+0xf9>
  802a54:	3b 34 24             	cmp    (%esp),%esi
  802a57:	74 1f                	je     802a78 <__udivdi3+0x118>
  802a59:	89 f8                	mov    %edi,%eax
  802a5b:	31 d2                	xor    %edx,%edx
  802a5d:	e9 7a ff ff ff       	jmp    8029dc <__udivdi3+0x7c>
  802a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a68:	31 d2                	xor    %edx,%edx
  802a6a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a6f:	e9 68 ff ff ff       	jmp    8029dc <__udivdi3+0x7c>
  802a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a78:	8d 47 ff             	lea    -0x1(%edi),%eax
  802a7b:	31 d2                	xor    %edx,%edx
  802a7d:	83 c4 0c             	add    $0xc,%esp
  802a80:	5e                   	pop    %esi
  802a81:	5f                   	pop    %edi
  802a82:	5d                   	pop    %ebp
  802a83:	c3                   	ret    
  802a84:	66 90                	xchg   %ax,%ax
  802a86:	66 90                	xchg   %ax,%ax
  802a88:	66 90                	xchg   %ax,%ax
  802a8a:	66 90                	xchg   %ax,%ax
  802a8c:	66 90                	xchg   %ax,%ax
  802a8e:	66 90                	xchg   %ax,%ax

00802a90 <__umoddi3>:
  802a90:	55                   	push   %ebp
  802a91:	57                   	push   %edi
  802a92:	56                   	push   %esi
  802a93:	83 ec 14             	sub    $0x14,%esp
  802a96:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a9a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a9e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802aa2:	89 c7                	mov    %eax,%edi
  802aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aa8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802aac:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ab0:	89 34 24             	mov    %esi,(%esp)
  802ab3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ab7:	85 c0                	test   %eax,%eax
  802ab9:	89 c2                	mov    %eax,%edx
  802abb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802abf:	75 17                	jne    802ad8 <__umoddi3+0x48>
  802ac1:	39 fe                	cmp    %edi,%esi
  802ac3:	76 4b                	jbe    802b10 <__umoddi3+0x80>
  802ac5:	89 c8                	mov    %ecx,%eax
  802ac7:	89 fa                	mov    %edi,%edx
  802ac9:	f7 f6                	div    %esi
  802acb:	89 d0                	mov    %edx,%eax
  802acd:	31 d2                	xor    %edx,%edx
  802acf:	83 c4 14             	add    $0x14,%esp
  802ad2:	5e                   	pop    %esi
  802ad3:	5f                   	pop    %edi
  802ad4:	5d                   	pop    %ebp
  802ad5:	c3                   	ret    
  802ad6:	66 90                	xchg   %ax,%ax
  802ad8:	39 f8                	cmp    %edi,%eax
  802ada:	77 54                	ja     802b30 <__umoddi3+0xa0>
  802adc:	0f bd e8             	bsr    %eax,%ebp
  802adf:	83 f5 1f             	xor    $0x1f,%ebp
  802ae2:	75 5c                	jne    802b40 <__umoddi3+0xb0>
  802ae4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802ae8:	39 3c 24             	cmp    %edi,(%esp)
  802aeb:	0f 87 e7 00 00 00    	ja     802bd8 <__umoddi3+0x148>
  802af1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802af5:	29 f1                	sub    %esi,%ecx
  802af7:	19 c7                	sbb    %eax,%edi
  802af9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802afd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b01:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b05:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802b09:	83 c4 14             	add    $0x14,%esp
  802b0c:	5e                   	pop    %esi
  802b0d:	5f                   	pop    %edi
  802b0e:	5d                   	pop    %ebp
  802b0f:	c3                   	ret    
  802b10:	85 f6                	test   %esi,%esi
  802b12:	89 f5                	mov    %esi,%ebp
  802b14:	75 0b                	jne    802b21 <__umoddi3+0x91>
  802b16:	b8 01 00 00 00       	mov    $0x1,%eax
  802b1b:	31 d2                	xor    %edx,%edx
  802b1d:	f7 f6                	div    %esi
  802b1f:	89 c5                	mov    %eax,%ebp
  802b21:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b25:	31 d2                	xor    %edx,%edx
  802b27:	f7 f5                	div    %ebp
  802b29:	89 c8                	mov    %ecx,%eax
  802b2b:	f7 f5                	div    %ebp
  802b2d:	eb 9c                	jmp    802acb <__umoddi3+0x3b>
  802b2f:	90                   	nop
  802b30:	89 c8                	mov    %ecx,%eax
  802b32:	89 fa                	mov    %edi,%edx
  802b34:	83 c4 14             	add    $0x14,%esp
  802b37:	5e                   	pop    %esi
  802b38:	5f                   	pop    %edi
  802b39:	5d                   	pop    %ebp
  802b3a:	c3                   	ret    
  802b3b:	90                   	nop
  802b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b40:	8b 04 24             	mov    (%esp),%eax
  802b43:	be 20 00 00 00       	mov    $0x20,%esi
  802b48:	89 e9                	mov    %ebp,%ecx
  802b4a:	29 ee                	sub    %ebp,%esi
  802b4c:	d3 e2                	shl    %cl,%edx
  802b4e:	89 f1                	mov    %esi,%ecx
  802b50:	d3 e8                	shr    %cl,%eax
  802b52:	89 e9                	mov    %ebp,%ecx
  802b54:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b58:	8b 04 24             	mov    (%esp),%eax
  802b5b:	09 54 24 04          	or     %edx,0x4(%esp)
  802b5f:	89 fa                	mov    %edi,%edx
  802b61:	d3 e0                	shl    %cl,%eax
  802b63:	89 f1                	mov    %esi,%ecx
  802b65:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b69:	8b 44 24 10          	mov    0x10(%esp),%eax
  802b6d:	d3 ea                	shr    %cl,%edx
  802b6f:	89 e9                	mov    %ebp,%ecx
  802b71:	d3 e7                	shl    %cl,%edi
  802b73:	89 f1                	mov    %esi,%ecx
  802b75:	d3 e8                	shr    %cl,%eax
  802b77:	89 e9                	mov    %ebp,%ecx
  802b79:	09 f8                	or     %edi,%eax
  802b7b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802b7f:	f7 74 24 04          	divl   0x4(%esp)
  802b83:	d3 e7                	shl    %cl,%edi
  802b85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b89:	89 d7                	mov    %edx,%edi
  802b8b:	f7 64 24 08          	mull   0x8(%esp)
  802b8f:	39 d7                	cmp    %edx,%edi
  802b91:	89 c1                	mov    %eax,%ecx
  802b93:	89 14 24             	mov    %edx,(%esp)
  802b96:	72 2c                	jb     802bc4 <__umoddi3+0x134>
  802b98:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802b9c:	72 22                	jb     802bc0 <__umoddi3+0x130>
  802b9e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802ba2:	29 c8                	sub    %ecx,%eax
  802ba4:	19 d7                	sbb    %edx,%edi
  802ba6:	89 e9                	mov    %ebp,%ecx
  802ba8:	89 fa                	mov    %edi,%edx
  802baa:	d3 e8                	shr    %cl,%eax
  802bac:	89 f1                	mov    %esi,%ecx
  802bae:	d3 e2                	shl    %cl,%edx
  802bb0:	89 e9                	mov    %ebp,%ecx
  802bb2:	d3 ef                	shr    %cl,%edi
  802bb4:	09 d0                	or     %edx,%eax
  802bb6:	89 fa                	mov    %edi,%edx
  802bb8:	83 c4 14             	add    $0x14,%esp
  802bbb:	5e                   	pop    %esi
  802bbc:	5f                   	pop    %edi
  802bbd:	5d                   	pop    %ebp
  802bbe:	c3                   	ret    
  802bbf:	90                   	nop
  802bc0:	39 d7                	cmp    %edx,%edi
  802bc2:	75 da                	jne    802b9e <__umoddi3+0x10e>
  802bc4:	8b 14 24             	mov    (%esp),%edx
  802bc7:	89 c1                	mov    %eax,%ecx
  802bc9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802bcd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802bd1:	eb cb                	jmp    802b9e <__umoddi3+0x10e>
  802bd3:	90                   	nop
  802bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bd8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802bdc:	0f 82 0f ff ff ff    	jb     802af1 <__umoddi3+0x61>
  802be2:	e9 1a ff ff ff       	jmp    802b01 <__umoddi3+0x71>
