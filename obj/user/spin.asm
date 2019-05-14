
obj/user/spin.debug:     file format elf32-i386


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
  80002c:	e8 8e 00 00 00       	call   8000bf <libmain>
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
  800043:	53                   	push   %ebx
  800044:	83 ec 14             	sub    $0x14,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  800047:	c7 04 24 80 2b 80 00 	movl   $0x802b80,(%esp)
  80004e:	e8 70 01 00 00       	call   8001c3 <cprintf>
	if ((env = fork()) == 0) {
  800053:	e8 f8 0f 00 00       	call   801050 <fork>
  800058:	89 c3                	mov    %eax,%ebx
  80005a:	85 c0                	test   %eax,%eax
  80005c:	75 0e                	jne    80006c <umain+0x2c>
		cprintf("I am the child.  Spinning...\n");
  80005e:	c7 04 24 f8 2b 80 00 	movl   $0x802bf8,(%esp)
  800065:	e8 59 01 00 00       	call   8001c3 <cprintf>
  80006a:	eb fe                	jmp    80006a <umain+0x2a>
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  80006c:	c7 04 24 a8 2b 80 00 	movl   $0x802ba8,(%esp)
  800073:	e8 4b 01 00 00       	call   8001c3 <cprintf>
	sys_yield();
  800078:	e8 67 0b 00 00       	call   800be4 <sys_yield>
	sys_yield();
  80007d:	e8 62 0b 00 00       	call   800be4 <sys_yield>
	sys_yield();
  800082:	e8 5d 0b 00 00       	call   800be4 <sys_yield>
	sys_yield();
  800087:	e8 58 0b 00 00       	call   800be4 <sys_yield>
	sys_yield();
  80008c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800090:	e8 4f 0b 00 00       	call   800be4 <sys_yield>
	sys_yield();
  800095:	e8 4a 0b 00 00       	call   800be4 <sys_yield>
	sys_yield();
  80009a:	e8 45 0b 00 00       	call   800be4 <sys_yield>
	sys_yield();
  80009f:	90                   	nop
  8000a0:	e8 3f 0b 00 00       	call   800be4 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  8000a5:	c7 04 24 d0 2b 80 00 	movl   $0x802bd0,(%esp)
  8000ac:	e8 12 01 00 00       	call   8001c3 <cprintf>
	sys_env_destroy(env);
  8000b1:	89 1c 24             	mov    %ebx,(%esp)
  8000b4:	e8 ba 0a 00 00       	call   800b73 <sys_env_destroy>
}
  8000b9:	83 c4 14             	add    $0x14,%esp
  8000bc:	5b                   	pop    %ebx
  8000bd:	5d                   	pop    %ebp
  8000be:	c3                   	ret    

008000bf <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000bf:	55                   	push   %ebp
  8000c0:	89 e5                	mov    %esp,%ebp
  8000c2:	56                   	push   %esi
  8000c3:	53                   	push   %ebx
  8000c4:	83 ec 10             	sub    $0x10,%esp
  8000c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ca:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000cd:	e8 f3 0a 00 00       	call   800bc5 <sys_getenvid>
  8000d2:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000d7:	c1 e0 07             	shl    $0x7,%eax
  8000da:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000df:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e4:	85 db                	test   %ebx,%ebx
  8000e6:	7e 07                	jle    8000ef <libmain+0x30>
		binaryname = argv[0];
  8000e8:	8b 06                	mov    (%esi),%eax
  8000ea:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8000ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000f3:	89 1c 24             	mov    %ebx,(%esp)
  8000f6:	e8 45 ff ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  8000fb:	e8 07 00 00 00       	call   800107 <exit>
}
  800100:	83 c4 10             	add    $0x10,%esp
  800103:	5b                   	pop    %ebx
  800104:	5e                   	pop    %esi
  800105:	5d                   	pop    %ebp
  800106:	c3                   	ret    

00800107 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800107:	55                   	push   %ebp
  800108:	89 e5                	mov    %esp,%ebp
  80010a:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80010d:	e8 18 14 00 00       	call   80152a <close_all>
	sys_env_destroy(0);
  800112:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800119:	e8 55 0a 00 00       	call   800b73 <sys_env_destroy>
}
  80011e:	c9                   	leave  
  80011f:	c3                   	ret    

00800120 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	53                   	push   %ebx
  800124:	83 ec 14             	sub    $0x14,%esp
  800127:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012a:	8b 13                	mov    (%ebx),%edx
  80012c:	8d 42 01             	lea    0x1(%edx),%eax
  80012f:	89 03                	mov    %eax,(%ebx)
  800131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800134:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800138:	3d ff 00 00 00       	cmp    $0xff,%eax
  80013d:	75 19                	jne    800158 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80013f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800146:	00 
  800147:	8d 43 08             	lea    0x8(%ebx),%eax
  80014a:	89 04 24             	mov    %eax,(%esp)
  80014d:	e8 e4 09 00 00       	call   800b36 <sys_cputs>
		b->idx = 0;
  800152:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800158:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80015c:	83 c4 14             	add    $0x14,%esp
  80015f:	5b                   	pop    %ebx
  800160:	5d                   	pop    %ebp
  800161:	c3                   	ret    

00800162 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800162:	55                   	push   %ebp
  800163:	89 e5                	mov    %esp,%ebp
  800165:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80016b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800172:	00 00 00 
	b.cnt = 0;
  800175:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80017f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800182:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800186:	8b 45 08             	mov    0x8(%ebp),%eax
  800189:	89 44 24 08          	mov    %eax,0x8(%esp)
  80018d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800193:	89 44 24 04          	mov    %eax,0x4(%esp)
  800197:	c7 04 24 20 01 80 00 	movl   $0x800120,(%esp)
  80019e:	e8 ab 01 00 00       	call   80034e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001a3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ad:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001b3:	89 04 24             	mov    %eax,(%esp)
  8001b6:	e8 7b 09 00 00       	call   800b36 <sys_cputs>

	return b.cnt;
}
  8001bb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001c1:	c9                   	leave  
  8001c2:	c3                   	ret    

008001c3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001c3:	55                   	push   %ebp
  8001c4:	89 e5                	mov    %esp,%ebp
  8001c6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001c9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d3:	89 04 24             	mov    %eax,(%esp)
  8001d6:	e8 87 ff ff ff       	call   800162 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001db:	c9                   	leave  
  8001dc:	c3                   	ret    
  8001dd:	66 90                	xchg   %ax,%ax
  8001df:	90                   	nop

008001e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	57                   	push   %edi
  8001e4:	56                   	push   %esi
  8001e5:	53                   	push   %ebx
  8001e6:	83 ec 3c             	sub    $0x3c,%esp
  8001e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001ec:	89 d7                	mov    %edx,%edi
  8001ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f7:	89 c3                	mov    %eax,%ebx
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ff:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800202:	b9 00 00 00 00       	mov    $0x0,%ecx
  800207:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80020a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80020d:	39 d9                	cmp    %ebx,%ecx
  80020f:	72 05                	jb     800216 <printnum+0x36>
  800211:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800214:	77 69                	ja     80027f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800216:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800219:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80021d:	83 ee 01             	sub    $0x1,%esi
  800220:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800224:	89 44 24 08          	mov    %eax,0x8(%esp)
  800228:	8b 44 24 08          	mov    0x8(%esp),%eax
  80022c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800230:	89 c3                	mov    %eax,%ebx
  800232:	89 d6                	mov    %edx,%esi
  800234:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800237:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80023a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80023e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800242:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800245:	89 04 24             	mov    %eax,(%esp)
  800248:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80024b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024f:	e8 8c 26 00 00       	call   8028e0 <__udivdi3>
  800254:	89 d9                	mov    %ebx,%ecx
  800256:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80025a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80025e:	89 04 24             	mov    %eax,(%esp)
  800261:	89 54 24 04          	mov    %edx,0x4(%esp)
  800265:	89 fa                	mov    %edi,%edx
  800267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80026a:	e8 71 ff ff ff       	call   8001e0 <printnum>
  80026f:	eb 1b                	jmp    80028c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800271:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800275:	8b 45 18             	mov    0x18(%ebp),%eax
  800278:	89 04 24             	mov    %eax,(%esp)
  80027b:	ff d3                	call   *%ebx
  80027d:	eb 03                	jmp    800282 <printnum+0xa2>
  80027f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800282:	83 ee 01             	sub    $0x1,%esi
  800285:	85 f6                	test   %esi,%esi
  800287:	7f e8                	jg     800271 <printnum+0x91>
  800289:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80028c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800290:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800294:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800297:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80029a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80029e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002a5:	89 04 24             	mov    %eax,(%esp)
  8002a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002af:	e8 5c 27 00 00       	call   802a10 <__umoddi3>
  8002b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002b8:	0f be 80 20 2c 80 00 	movsbl 0x802c20(%eax),%eax
  8002bf:	89 04 24             	mov    %eax,(%esp)
  8002c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002c5:	ff d0                	call   *%eax
}
  8002c7:	83 c4 3c             	add    $0x3c,%esp
  8002ca:	5b                   	pop    %ebx
  8002cb:	5e                   	pop    %esi
  8002cc:	5f                   	pop    %edi
  8002cd:	5d                   	pop    %ebp
  8002ce:	c3                   	ret    

008002cf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002d2:	83 fa 01             	cmp    $0x1,%edx
  8002d5:	7e 0e                	jle    8002e5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002d7:	8b 10                	mov    (%eax),%edx
  8002d9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002dc:	89 08                	mov    %ecx,(%eax)
  8002de:	8b 02                	mov    (%edx),%eax
  8002e0:	8b 52 04             	mov    0x4(%edx),%edx
  8002e3:	eb 22                	jmp    800307 <getuint+0x38>
	else if (lflag)
  8002e5:	85 d2                	test   %edx,%edx
  8002e7:	74 10                	je     8002f9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ee:	89 08                	mov    %ecx,(%eax)
  8002f0:	8b 02                	mov    (%edx),%eax
  8002f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f7:	eb 0e                	jmp    800307 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002f9:	8b 10                	mov    (%eax),%edx
  8002fb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002fe:	89 08                	mov    %ecx,(%eax)
  800300:	8b 02                	mov    (%edx),%eax
  800302:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800307:	5d                   	pop    %ebp
  800308:	c3                   	ret    

00800309 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800309:	55                   	push   %ebp
  80030a:	89 e5                	mov    %esp,%ebp
  80030c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80030f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800313:	8b 10                	mov    (%eax),%edx
  800315:	3b 50 04             	cmp    0x4(%eax),%edx
  800318:	73 0a                	jae    800324 <sprintputch+0x1b>
		*b->buf++ = ch;
  80031a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80031d:	89 08                	mov    %ecx,(%eax)
  80031f:	8b 45 08             	mov    0x8(%ebp),%eax
  800322:	88 02                	mov    %al,(%edx)
}
  800324:	5d                   	pop    %ebp
  800325:	c3                   	ret    

00800326 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80032c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80032f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800333:	8b 45 10             	mov    0x10(%ebp),%eax
  800336:	89 44 24 08          	mov    %eax,0x8(%esp)
  80033a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800341:	8b 45 08             	mov    0x8(%ebp),%eax
  800344:	89 04 24             	mov    %eax,(%esp)
  800347:	e8 02 00 00 00       	call   80034e <vprintfmt>
	va_end(ap);
}
  80034c:	c9                   	leave  
  80034d:	c3                   	ret    

0080034e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	57                   	push   %edi
  800352:	56                   	push   %esi
  800353:	53                   	push   %ebx
  800354:	83 ec 3c             	sub    $0x3c,%esp
  800357:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80035a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80035d:	eb 14                	jmp    800373 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80035f:	85 c0                	test   %eax,%eax
  800361:	0f 84 b3 03 00 00    	je     80071a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800367:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80036b:	89 04 24             	mov    %eax,(%esp)
  80036e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800371:	89 f3                	mov    %esi,%ebx
  800373:	8d 73 01             	lea    0x1(%ebx),%esi
  800376:	0f b6 03             	movzbl (%ebx),%eax
  800379:	83 f8 25             	cmp    $0x25,%eax
  80037c:	75 e1                	jne    80035f <vprintfmt+0x11>
  80037e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800382:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800389:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800390:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800397:	ba 00 00 00 00       	mov    $0x0,%edx
  80039c:	eb 1d                	jmp    8003bb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80039e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003a0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8003a4:	eb 15                	jmp    8003bb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003a6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003a8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8003ac:	eb 0d                	jmp    8003bb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003b4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003bb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8003be:	0f b6 0e             	movzbl (%esi),%ecx
  8003c1:	0f b6 c1             	movzbl %cl,%eax
  8003c4:	83 e9 23             	sub    $0x23,%ecx
  8003c7:	80 f9 55             	cmp    $0x55,%cl
  8003ca:	0f 87 2a 03 00 00    	ja     8006fa <vprintfmt+0x3ac>
  8003d0:	0f b6 c9             	movzbl %cl,%ecx
  8003d3:	ff 24 8d 60 2d 80 00 	jmp    *0x802d60(,%ecx,4)
  8003da:	89 de                	mov    %ebx,%esi
  8003dc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003e1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003e4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8003e8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8003eb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8003ee:	83 fb 09             	cmp    $0x9,%ebx
  8003f1:	77 36                	ja     800429 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003f3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003f6:	eb e9                	jmp    8003e1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fb:	8d 48 04             	lea    0x4(%eax),%ecx
  8003fe:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800401:	8b 00                	mov    (%eax),%eax
  800403:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800406:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800408:	eb 22                	jmp    80042c <vprintfmt+0xde>
  80040a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80040d:	85 c9                	test   %ecx,%ecx
  80040f:	b8 00 00 00 00       	mov    $0x0,%eax
  800414:	0f 49 c1             	cmovns %ecx,%eax
  800417:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041a:	89 de                	mov    %ebx,%esi
  80041c:	eb 9d                	jmp    8003bb <vprintfmt+0x6d>
  80041e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800420:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800427:	eb 92                	jmp    8003bb <vprintfmt+0x6d>
  800429:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80042c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800430:	79 89                	jns    8003bb <vprintfmt+0x6d>
  800432:	e9 77 ff ff ff       	jmp    8003ae <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800437:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80043a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80043c:	e9 7a ff ff ff       	jmp    8003bb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800441:	8b 45 14             	mov    0x14(%ebp),%eax
  800444:	8d 50 04             	lea    0x4(%eax),%edx
  800447:	89 55 14             	mov    %edx,0x14(%ebp)
  80044a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	89 04 24             	mov    %eax,(%esp)
  800453:	ff 55 08             	call   *0x8(%ebp)
			break;
  800456:	e9 18 ff ff ff       	jmp    800373 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80045b:	8b 45 14             	mov    0x14(%ebp),%eax
  80045e:	8d 50 04             	lea    0x4(%eax),%edx
  800461:	89 55 14             	mov    %edx,0x14(%ebp)
  800464:	8b 00                	mov    (%eax),%eax
  800466:	99                   	cltd   
  800467:	31 d0                	xor    %edx,%eax
  800469:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80046b:	83 f8 11             	cmp    $0x11,%eax
  80046e:	7f 0b                	jg     80047b <vprintfmt+0x12d>
  800470:	8b 14 85 c0 2e 80 00 	mov    0x802ec0(,%eax,4),%edx
  800477:	85 d2                	test   %edx,%edx
  800479:	75 20                	jne    80049b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80047b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80047f:	c7 44 24 08 38 2c 80 	movl   $0x802c38,0x8(%esp)
  800486:	00 
  800487:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	89 04 24             	mov    %eax,(%esp)
  800491:	e8 90 fe ff ff       	call   800326 <printfmt>
  800496:	e9 d8 fe ff ff       	jmp    800373 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80049b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80049f:	c7 44 24 08 ed 30 80 	movl   $0x8030ed,0x8(%esp)
  8004a6:	00 
  8004a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	89 04 24             	mov    %eax,(%esp)
  8004b1:	e8 70 fe ff ff       	call   800326 <printfmt>
  8004b6:	e9 b8 fe ff ff       	jmp    800373 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004bb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8d 50 04             	lea    0x4(%eax),%edx
  8004ca:	89 55 14             	mov    %edx,0x14(%ebp)
  8004cd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8004cf:	85 f6                	test   %esi,%esi
  8004d1:	b8 31 2c 80 00       	mov    $0x802c31,%eax
  8004d6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8004d9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8004dd:	0f 84 97 00 00 00    	je     80057a <vprintfmt+0x22c>
  8004e3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004e7:	0f 8e 9b 00 00 00    	jle    800588 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ed:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004f1:	89 34 24             	mov    %esi,(%esp)
  8004f4:	e8 cf 02 00 00       	call   8007c8 <strnlen>
  8004f9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004fc:	29 c2                	sub    %eax,%edx
  8004fe:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800501:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800505:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800508:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80050b:	8b 75 08             	mov    0x8(%ebp),%esi
  80050e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800511:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800513:	eb 0f                	jmp    800524 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800515:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800519:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80051c:	89 04 24             	mov    %eax,(%esp)
  80051f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800521:	83 eb 01             	sub    $0x1,%ebx
  800524:	85 db                	test   %ebx,%ebx
  800526:	7f ed                	jg     800515 <vprintfmt+0x1c7>
  800528:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80052b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80052e:	85 d2                	test   %edx,%edx
  800530:	b8 00 00 00 00       	mov    $0x0,%eax
  800535:	0f 49 c2             	cmovns %edx,%eax
  800538:	29 c2                	sub    %eax,%edx
  80053a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80053d:	89 d7                	mov    %edx,%edi
  80053f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800542:	eb 50                	jmp    800594 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800544:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800548:	74 1e                	je     800568 <vprintfmt+0x21a>
  80054a:	0f be d2             	movsbl %dl,%edx
  80054d:	83 ea 20             	sub    $0x20,%edx
  800550:	83 fa 5e             	cmp    $0x5e,%edx
  800553:	76 13                	jbe    800568 <vprintfmt+0x21a>
					putch('?', putdat);
  800555:	8b 45 0c             	mov    0xc(%ebp),%eax
  800558:	89 44 24 04          	mov    %eax,0x4(%esp)
  80055c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800563:	ff 55 08             	call   *0x8(%ebp)
  800566:	eb 0d                	jmp    800575 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80056b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80056f:	89 04 24             	mov    %eax,(%esp)
  800572:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800575:	83 ef 01             	sub    $0x1,%edi
  800578:	eb 1a                	jmp    800594 <vprintfmt+0x246>
  80057a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80057d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800580:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800583:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800586:	eb 0c                	jmp    800594 <vprintfmt+0x246>
  800588:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80058b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80058e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800591:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800594:	83 c6 01             	add    $0x1,%esi
  800597:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80059b:	0f be c2             	movsbl %dl,%eax
  80059e:	85 c0                	test   %eax,%eax
  8005a0:	74 27                	je     8005c9 <vprintfmt+0x27b>
  8005a2:	85 db                	test   %ebx,%ebx
  8005a4:	78 9e                	js     800544 <vprintfmt+0x1f6>
  8005a6:	83 eb 01             	sub    $0x1,%ebx
  8005a9:	79 99                	jns    800544 <vprintfmt+0x1f6>
  8005ab:	89 f8                	mov    %edi,%eax
  8005ad:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005b3:	89 c3                	mov    %eax,%ebx
  8005b5:	eb 1a                	jmp    8005d1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005bb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005c2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005c4:	83 eb 01             	sub    $0x1,%ebx
  8005c7:	eb 08                	jmp    8005d1 <vprintfmt+0x283>
  8005c9:	89 fb                	mov    %edi,%ebx
  8005cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ce:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005d1:	85 db                	test   %ebx,%ebx
  8005d3:	7f e2                	jg     8005b7 <vprintfmt+0x269>
  8005d5:	89 75 08             	mov    %esi,0x8(%ebp)
  8005d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005db:	e9 93 fd ff ff       	jmp    800373 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005e0:	83 fa 01             	cmp    $0x1,%edx
  8005e3:	7e 16                	jle    8005fb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8d 50 08             	lea    0x8(%eax),%edx
  8005eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ee:	8b 50 04             	mov    0x4(%eax),%edx
  8005f1:	8b 00                	mov    (%eax),%eax
  8005f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005f6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005f9:	eb 32                	jmp    80062d <vprintfmt+0x2df>
	else if (lflag)
  8005fb:	85 d2                	test   %edx,%edx
  8005fd:	74 18                	je     800617 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8d 50 04             	lea    0x4(%eax),%edx
  800605:	89 55 14             	mov    %edx,0x14(%ebp)
  800608:	8b 30                	mov    (%eax),%esi
  80060a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80060d:	89 f0                	mov    %esi,%eax
  80060f:	c1 f8 1f             	sar    $0x1f,%eax
  800612:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800615:	eb 16                	jmp    80062d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8d 50 04             	lea    0x4(%eax),%edx
  80061d:	89 55 14             	mov    %edx,0x14(%ebp)
  800620:	8b 30                	mov    (%eax),%esi
  800622:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800625:	89 f0                	mov    %esi,%eax
  800627:	c1 f8 1f             	sar    $0x1f,%eax
  80062a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80062d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800630:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800633:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800638:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80063c:	0f 89 80 00 00 00    	jns    8006c2 <vprintfmt+0x374>
				putch('-', putdat);
  800642:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800646:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80064d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800650:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800653:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800656:	f7 d8                	neg    %eax
  800658:	83 d2 00             	adc    $0x0,%edx
  80065b:	f7 da                	neg    %edx
			}
			base = 10;
  80065d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800662:	eb 5e                	jmp    8006c2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800664:	8d 45 14             	lea    0x14(%ebp),%eax
  800667:	e8 63 fc ff ff       	call   8002cf <getuint>
			base = 10;
  80066c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800671:	eb 4f                	jmp    8006c2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800673:	8d 45 14             	lea    0x14(%ebp),%eax
  800676:	e8 54 fc ff ff       	call   8002cf <getuint>
			base = 8;
  80067b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800680:	eb 40                	jmp    8006c2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800682:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800686:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80068d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800690:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800694:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80069b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80069e:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a1:	8d 50 04             	lea    0x4(%eax),%edx
  8006a4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006a7:	8b 00                	mov    (%eax),%eax
  8006a9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006ae:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006b3:	eb 0d                	jmp    8006c2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006b5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b8:	e8 12 fc ff ff       	call   8002cf <getuint>
			base = 16;
  8006bd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006c2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8006c6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8006ca:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8006cd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006d1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006d5:	89 04 24             	mov    %eax,(%esp)
  8006d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006dc:	89 fa                	mov    %edi,%edx
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	e8 fa fa ff ff       	call   8001e0 <printnum>
			break;
  8006e6:	e9 88 fc ff ff       	jmp    800373 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006eb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ef:	89 04 24             	mov    %eax,(%esp)
  8006f2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006f5:	e9 79 fc ff ff       	jmp    800373 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006fe:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800705:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800708:	89 f3                	mov    %esi,%ebx
  80070a:	eb 03                	jmp    80070f <vprintfmt+0x3c1>
  80070c:	83 eb 01             	sub    $0x1,%ebx
  80070f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800713:	75 f7                	jne    80070c <vprintfmt+0x3be>
  800715:	e9 59 fc ff ff       	jmp    800373 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80071a:	83 c4 3c             	add    $0x3c,%esp
  80071d:	5b                   	pop    %ebx
  80071e:	5e                   	pop    %esi
  80071f:	5f                   	pop    %edi
  800720:	5d                   	pop    %ebp
  800721:	c3                   	ret    

00800722 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800722:	55                   	push   %ebp
  800723:	89 e5                	mov    %esp,%ebp
  800725:	83 ec 28             	sub    $0x28,%esp
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80072e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800731:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800735:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800738:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80073f:	85 c0                	test   %eax,%eax
  800741:	74 30                	je     800773 <vsnprintf+0x51>
  800743:	85 d2                	test   %edx,%edx
  800745:	7e 2c                	jle    800773 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80074e:	8b 45 10             	mov    0x10(%ebp),%eax
  800751:	89 44 24 08          	mov    %eax,0x8(%esp)
  800755:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800758:	89 44 24 04          	mov    %eax,0x4(%esp)
  80075c:	c7 04 24 09 03 80 00 	movl   $0x800309,(%esp)
  800763:	e8 e6 fb ff ff       	call   80034e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800768:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80076b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80076e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800771:	eb 05                	jmp    800778 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800773:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800778:	c9                   	leave  
  800779:	c3                   	ret    

0080077a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800780:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800783:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800787:	8b 45 10             	mov    0x10(%ebp),%eax
  80078a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80078e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800791:	89 44 24 04          	mov    %eax,0x4(%esp)
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	89 04 24             	mov    %eax,(%esp)
  80079b:	e8 82 ff ff ff       	call   800722 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007a0:	c9                   	leave  
  8007a1:	c3                   	ret    
  8007a2:	66 90                	xchg   %ax,%ax
  8007a4:	66 90                	xchg   %ax,%ax
  8007a6:	66 90                	xchg   %ax,%ax
  8007a8:	66 90                	xchg   %ax,%ax
  8007aa:	66 90                	xchg   %ax,%ax
  8007ac:	66 90                	xchg   %ax,%ax
  8007ae:	66 90                	xchg   %ax,%ax

008007b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007b0:	55                   	push   %ebp
  8007b1:	89 e5                	mov    %esp,%ebp
  8007b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007bb:	eb 03                	jmp    8007c0 <strlen+0x10>
		n++;
  8007bd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007c4:	75 f7                	jne    8007bd <strlen+0xd>
		n++;
	return n;
}
  8007c6:	5d                   	pop    %ebp
  8007c7:	c3                   	ret    

008007c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
  8007cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d6:	eb 03                	jmp    8007db <strnlen+0x13>
		n++;
  8007d8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007db:	39 d0                	cmp    %edx,%eax
  8007dd:	74 06                	je     8007e5 <strnlen+0x1d>
  8007df:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007e3:	75 f3                	jne    8007d8 <strnlen+0x10>
		n++;
	return n;
}
  8007e5:	5d                   	pop    %ebp
  8007e6:	c3                   	ret    

008007e7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	53                   	push   %ebx
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007f1:	89 c2                	mov    %eax,%edx
  8007f3:	83 c2 01             	add    $0x1,%edx
  8007f6:	83 c1 01             	add    $0x1,%ecx
  8007f9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007fd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800800:	84 db                	test   %bl,%bl
  800802:	75 ef                	jne    8007f3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800804:	5b                   	pop    %ebx
  800805:	5d                   	pop    %ebp
  800806:	c3                   	ret    

00800807 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800807:	55                   	push   %ebp
  800808:	89 e5                	mov    %esp,%ebp
  80080a:	53                   	push   %ebx
  80080b:	83 ec 08             	sub    $0x8,%esp
  80080e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800811:	89 1c 24             	mov    %ebx,(%esp)
  800814:	e8 97 ff ff ff       	call   8007b0 <strlen>
	strcpy(dst + len, src);
  800819:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800820:	01 d8                	add    %ebx,%eax
  800822:	89 04 24             	mov    %eax,(%esp)
  800825:	e8 bd ff ff ff       	call   8007e7 <strcpy>
	return dst;
}
  80082a:	89 d8                	mov    %ebx,%eax
  80082c:	83 c4 08             	add    $0x8,%esp
  80082f:	5b                   	pop    %ebx
  800830:	5d                   	pop    %ebp
  800831:	c3                   	ret    

00800832 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800832:	55                   	push   %ebp
  800833:	89 e5                	mov    %esp,%ebp
  800835:	56                   	push   %esi
  800836:	53                   	push   %ebx
  800837:	8b 75 08             	mov    0x8(%ebp),%esi
  80083a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80083d:	89 f3                	mov    %esi,%ebx
  80083f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800842:	89 f2                	mov    %esi,%edx
  800844:	eb 0f                	jmp    800855 <strncpy+0x23>
		*dst++ = *src;
  800846:	83 c2 01             	add    $0x1,%edx
  800849:	0f b6 01             	movzbl (%ecx),%eax
  80084c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80084f:	80 39 01             	cmpb   $0x1,(%ecx)
  800852:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800855:	39 da                	cmp    %ebx,%edx
  800857:	75 ed                	jne    800846 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800859:	89 f0                	mov    %esi,%eax
  80085b:	5b                   	pop    %ebx
  80085c:	5e                   	pop    %esi
  80085d:	5d                   	pop    %ebp
  80085e:	c3                   	ret    

0080085f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80085f:	55                   	push   %ebp
  800860:	89 e5                	mov    %esp,%ebp
  800862:	56                   	push   %esi
  800863:	53                   	push   %ebx
  800864:	8b 75 08             	mov    0x8(%ebp),%esi
  800867:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80086d:	89 f0                	mov    %esi,%eax
  80086f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800873:	85 c9                	test   %ecx,%ecx
  800875:	75 0b                	jne    800882 <strlcpy+0x23>
  800877:	eb 1d                	jmp    800896 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800879:	83 c0 01             	add    $0x1,%eax
  80087c:	83 c2 01             	add    $0x1,%edx
  80087f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800882:	39 d8                	cmp    %ebx,%eax
  800884:	74 0b                	je     800891 <strlcpy+0x32>
  800886:	0f b6 0a             	movzbl (%edx),%ecx
  800889:	84 c9                	test   %cl,%cl
  80088b:	75 ec                	jne    800879 <strlcpy+0x1a>
  80088d:	89 c2                	mov    %eax,%edx
  80088f:	eb 02                	jmp    800893 <strlcpy+0x34>
  800891:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800893:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800896:	29 f0                	sub    %esi,%eax
}
  800898:	5b                   	pop    %ebx
  800899:	5e                   	pop    %esi
  80089a:	5d                   	pop    %ebp
  80089b:	c3                   	ret    

0080089c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008a5:	eb 06                	jmp    8008ad <strcmp+0x11>
		p++, q++;
  8008a7:	83 c1 01             	add    $0x1,%ecx
  8008aa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008ad:	0f b6 01             	movzbl (%ecx),%eax
  8008b0:	84 c0                	test   %al,%al
  8008b2:	74 04                	je     8008b8 <strcmp+0x1c>
  8008b4:	3a 02                	cmp    (%edx),%al
  8008b6:	74 ef                	je     8008a7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b8:	0f b6 c0             	movzbl %al,%eax
  8008bb:	0f b6 12             	movzbl (%edx),%edx
  8008be:	29 d0                	sub    %edx,%eax
}
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    

008008c2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	53                   	push   %ebx
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cc:	89 c3                	mov    %eax,%ebx
  8008ce:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008d1:	eb 06                	jmp    8008d9 <strncmp+0x17>
		n--, p++, q++;
  8008d3:	83 c0 01             	add    $0x1,%eax
  8008d6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008d9:	39 d8                	cmp    %ebx,%eax
  8008db:	74 15                	je     8008f2 <strncmp+0x30>
  8008dd:	0f b6 08             	movzbl (%eax),%ecx
  8008e0:	84 c9                	test   %cl,%cl
  8008e2:	74 04                	je     8008e8 <strncmp+0x26>
  8008e4:	3a 0a                	cmp    (%edx),%cl
  8008e6:	74 eb                	je     8008d3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e8:	0f b6 00             	movzbl (%eax),%eax
  8008eb:	0f b6 12             	movzbl (%edx),%edx
  8008ee:	29 d0                	sub    %edx,%eax
  8008f0:	eb 05                	jmp    8008f7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008f2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008f7:	5b                   	pop    %ebx
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800904:	eb 07                	jmp    80090d <strchr+0x13>
		if (*s == c)
  800906:	38 ca                	cmp    %cl,%dl
  800908:	74 0f                	je     800919 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80090a:	83 c0 01             	add    $0x1,%eax
  80090d:	0f b6 10             	movzbl (%eax),%edx
  800910:	84 d2                	test   %dl,%dl
  800912:	75 f2                	jne    800906 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800914:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800925:	eb 07                	jmp    80092e <strfind+0x13>
		if (*s == c)
  800927:	38 ca                	cmp    %cl,%dl
  800929:	74 0a                	je     800935 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80092b:	83 c0 01             	add    $0x1,%eax
  80092e:	0f b6 10             	movzbl (%eax),%edx
  800931:	84 d2                	test   %dl,%dl
  800933:	75 f2                	jne    800927 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	57                   	push   %edi
  80093b:	56                   	push   %esi
  80093c:	53                   	push   %ebx
  80093d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800940:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800943:	85 c9                	test   %ecx,%ecx
  800945:	74 36                	je     80097d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800947:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80094d:	75 28                	jne    800977 <memset+0x40>
  80094f:	f6 c1 03             	test   $0x3,%cl
  800952:	75 23                	jne    800977 <memset+0x40>
		c &= 0xFF;
  800954:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800958:	89 d3                	mov    %edx,%ebx
  80095a:	c1 e3 08             	shl    $0x8,%ebx
  80095d:	89 d6                	mov    %edx,%esi
  80095f:	c1 e6 18             	shl    $0x18,%esi
  800962:	89 d0                	mov    %edx,%eax
  800964:	c1 e0 10             	shl    $0x10,%eax
  800967:	09 f0                	or     %esi,%eax
  800969:	09 c2                	or     %eax,%edx
  80096b:	89 d0                	mov    %edx,%eax
  80096d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80096f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800972:	fc                   	cld    
  800973:	f3 ab                	rep stos %eax,%es:(%edi)
  800975:	eb 06                	jmp    80097d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097a:	fc                   	cld    
  80097b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80097d:	89 f8                	mov    %edi,%eax
  80097f:	5b                   	pop    %ebx
  800980:	5e                   	pop    %esi
  800981:	5f                   	pop    %edi
  800982:	5d                   	pop    %ebp
  800983:	c3                   	ret    

00800984 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800984:	55                   	push   %ebp
  800985:	89 e5                	mov    %esp,%ebp
  800987:	57                   	push   %edi
  800988:	56                   	push   %esi
  800989:	8b 45 08             	mov    0x8(%ebp),%eax
  80098c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80098f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800992:	39 c6                	cmp    %eax,%esi
  800994:	73 35                	jae    8009cb <memmove+0x47>
  800996:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800999:	39 d0                	cmp    %edx,%eax
  80099b:	73 2e                	jae    8009cb <memmove+0x47>
		s += n;
		d += n;
  80099d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8009a0:	89 d6                	mov    %edx,%esi
  8009a2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009a4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009aa:	75 13                	jne    8009bf <memmove+0x3b>
  8009ac:	f6 c1 03             	test   $0x3,%cl
  8009af:	75 0e                	jne    8009bf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009b1:	83 ef 04             	sub    $0x4,%edi
  8009b4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009b7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009ba:	fd                   	std    
  8009bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009bd:	eb 09                	jmp    8009c8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009bf:	83 ef 01             	sub    $0x1,%edi
  8009c2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009c5:	fd                   	std    
  8009c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009c8:	fc                   	cld    
  8009c9:	eb 1d                	jmp    8009e8 <memmove+0x64>
  8009cb:	89 f2                	mov    %esi,%edx
  8009cd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009cf:	f6 c2 03             	test   $0x3,%dl
  8009d2:	75 0f                	jne    8009e3 <memmove+0x5f>
  8009d4:	f6 c1 03             	test   $0x3,%cl
  8009d7:	75 0a                	jne    8009e3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009d9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8009dc:	89 c7                	mov    %eax,%edi
  8009de:	fc                   	cld    
  8009df:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009e1:	eb 05                	jmp    8009e8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009e3:	89 c7                	mov    %eax,%edi
  8009e5:	fc                   	cld    
  8009e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009e8:	5e                   	pop    %esi
  8009e9:	5f                   	pop    %edi
  8009ea:	5d                   	pop    %ebp
  8009eb:	c3                   	ret    

008009ec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	89 04 24             	mov    %eax,(%esp)
  800a06:	e8 79 ff ff ff       	call   800984 <memmove>
}
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	56                   	push   %esi
  800a11:	53                   	push   %ebx
  800a12:	8b 55 08             	mov    0x8(%ebp),%edx
  800a15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a18:	89 d6                	mov    %edx,%esi
  800a1a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a1d:	eb 1a                	jmp    800a39 <memcmp+0x2c>
		if (*s1 != *s2)
  800a1f:	0f b6 02             	movzbl (%edx),%eax
  800a22:	0f b6 19             	movzbl (%ecx),%ebx
  800a25:	38 d8                	cmp    %bl,%al
  800a27:	74 0a                	je     800a33 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a29:	0f b6 c0             	movzbl %al,%eax
  800a2c:	0f b6 db             	movzbl %bl,%ebx
  800a2f:	29 d8                	sub    %ebx,%eax
  800a31:	eb 0f                	jmp    800a42 <memcmp+0x35>
		s1++, s2++;
  800a33:	83 c2 01             	add    $0x1,%edx
  800a36:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a39:	39 f2                	cmp    %esi,%edx
  800a3b:	75 e2                	jne    800a1f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a42:	5b                   	pop    %ebx
  800a43:	5e                   	pop    %esi
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a4f:	89 c2                	mov    %eax,%edx
  800a51:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a54:	eb 07                	jmp    800a5d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a56:	38 08                	cmp    %cl,(%eax)
  800a58:	74 07                	je     800a61 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a5a:	83 c0 01             	add    $0x1,%eax
  800a5d:	39 d0                	cmp    %edx,%eax
  800a5f:	72 f5                	jb     800a56 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a61:	5d                   	pop    %ebp
  800a62:	c3                   	ret    

00800a63 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a63:	55                   	push   %ebp
  800a64:	89 e5                	mov    %esp,%ebp
  800a66:	57                   	push   %edi
  800a67:	56                   	push   %esi
  800a68:	53                   	push   %ebx
  800a69:	8b 55 08             	mov    0x8(%ebp),%edx
  800a6c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a6f:	eb 03                	jmp    800a74 <strtol+0x11>
		s++;
  800a71:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a74:	0f b6 0a             	movzbl (%edx),%ecx
  800a77:	80 f9 09             	cmp    $0x9,%cl
  800a7a:	74 f5                	je     800a71 <strtol+0xe>
  800a7c:	80 f9 20             	cmp    $0x20,%cl
  800a7f:	74 f0                	je     800a71 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a81:	80 f9 2b             	cmp    $0x2b,%cl
  800a84:	75 0a                	jne    800a90 <strtol+0x2d>
		s++;
  800a86:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a89:	bf 00 00 00 00       	mov    $0x0,%edi
  800a8e:	eb 11                	jmp    800aa1 <strtol+0x3e>
  800a90:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a95:	80 f9 2d             	cmp    $0x2d,%cl
  800a98:	75 07                	jne    800aa1 <strtol+0x3e>
		s++, neg = 1;
  800a9a:	8d 52 01             	lea    0x1(%edx),%edx
  800a9d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800aa1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800aa6:	75 15                	jne    800abd <strtol+0x5a>
  800aa8:	80 3a 30             	cmpb   $0x30,(%edx)
  800aab:	75 10                	jne    800abd <strtol+0x5a>
  800aad:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ab1:	75 0a                	jne    800abd <strtol+0x5a>
		s += 2, base = 16;
  800ab3:	83 c2 02             	add    $0x2,%edx
  800ab6:	b8 10 00 00 00       	mov    $0x10,%eax
  800abb:	eb 10                	jmp    800acd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800abd:	85 c0                	test   %eax,%eax
  800abf:	75 0c                	jne    800acd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ac1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ac3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ac6:	75 05                	jne    800acd <strtol+0x6a>
		s++, base = 8;
  800ac8:	83 c2 01             	add    $0x1,%edx
  800acb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800acd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ad2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ad5:	0f b6 0a             	movzbl (%edx),%ecx
  800ad8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800adb:	89 f0                	mov    %esi,%eax
  800add:	3c 09                	cmp    $0x9,%al
  800adf:	77 08                	ja     800ae9 <strtol+0x86>
			dig = *s - '0';
  800ae1:	0f be c9             	movsbl %cl,%ecx
  800ae4:	83 e9 30             	sub    $0x30,%ecx
  800ae7:	eb 20                	jmp    800b09 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ae9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800aec:	89 f0                	mov    %esi,%eax
  800aee:	3c 19                	cmp    $0x19,%al
  800af0:	77 08                	ja     800afa <strtol+0x97>
			dig = *s - 'a' + 10;
  800af2:	0f be c9             	movsbl %cl,%ecx
  800af5:	83 e9 57             	sub    $0x57,%ecx
  800af8:	eb 0f                	jmp    800b09 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800afa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800afd:	89 f0                	mov    %esi,%eax
  800aff:	3c 19                	cmp    $0x19,%al
  800b01:	77 16                	ja     800b19 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b03:	0f be c9             	movsbl %cl,%ecx
  800b06:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b09:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b0c:	7d 0f                	jge    800b1d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b0e:	83 c2 01             	add    $0x1,%edx
  800b11:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b15:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b17:	eb bc                	jmp    800ad5 <strtol+0x72>
  800b19:	89 d8                	mov    %ebx,%eax
  800b1b:	eb 02                	jmp    800b1f <strtol+0xbc>
  800b1d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b23:	74 05                	je     800b2a <strtol+0xc7>
		*endptr = (char *) s;
  800b25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b28:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b2a:	f7 d8                	neg    %eax
  800b2c:	85 ff                	test   %edi,%edi
  800b2e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b31:	5b                   	pop    %ebx
  800b32:	5e                   	pop    %esi
  800b33:	5f                   	pop    %edi
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	57                   	push   %edi
  800b3a:	56                   	push   %esi
  800b3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b44:	8b 55 08             	mov    0x8(%ebp),%edx
  800b47:	89 c3                	mov    %eax,%ebx
  800b49:	89 c7                	mov    %eax,%edi
  800b4b:	89 c6                	mov    %eax,%esi
  800b4d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b4f:	5b                   	pop    %ebx
  800b50:	5e                   	pop    %esi
  800b51:	5f                   	pop    %edi
  800b52:	5d                   	pop    %ebp
  800b53:	c3                   	ret    

00800b54 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	57                   	push   %edi
  800b58:	56                   	push   %esi
  800b59:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b64:	89 d1                	mov    %edx,%ecx
  800b66:	89 d3                	mov    %edx,%ebx
  800b68:	89 d7                	mov    %edx,%edi
  800b6a:	89 d6                	mov    %edx,%esi
  800b6c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b6e:	5b                   	pop    %ebx
  800b6f:	5e                   	pop    %esi
  800b70:	5f                   	pop    %edi
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    

00800b73 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	57                   	push   %edi
  800b77:	56                   	push   %esi
  800b78:	53                   	push   %ebx
  800b79:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b81:	b8 03 00 00 00       	mov    $0x3,%eax
  800b86:	8b 55 08             	mov    0x8(%ebp),%edx
  800b89:	89 cb                	mov    %ecx,%ebx
  800b8b:	89 cf                	mov    %ecx,%edi
  800b8d:	89 ce                	mov    %ecx,%esi
  800b8f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b91:	85 c0                	test   %eax,%eax
  800b93:	7e 28                	jle    800bbd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b95:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b99:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ba0:	00 
  800ba1:	c7 44 24 08 27 2f 80 	movl   $0x802f27,0x8(%esp)
  800ba8:	00 
  800ba9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bb0:	00 
  800bb1:	c7 04 24 44 2f 80 00 	movl   $0x802f44,(%esp)
  800bb8:	e8 a9 1a 00 00       	call   802666 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bbd:	83 c4 2c             	add    $0x2c,%esp
  800bc0:	5b                   	pop    %ebx
  800bc1:	5e                   	pop    %esi
  800bc2:	5f                   	pop    %edi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	57                   	push   %edi
  800bc9:	56                   	push   %esi
  800bca:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd0:	b8 02 00 00 00       	mov    $0x2,%eax
  800bd5:	89 d1                	mov    %edx,%ecx
  800bd7:	89 d3                	mov    %edx,%ebx
  800bd9:	89 d7                	mov    %edx,%edi
  800bdb:	89 d6                	mov    %edx,%esi
  800bdd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5f                   	pop    %edi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <sys_yield>:

void
sys_yield(void)
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
  800bef:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bf4:	89 d1                	mov    %edx,%ecx
  800bf6:	89 d3                	mov    %edx,%ebx
  800bf8:	89 d7                	mov    %edx,%edi
  800bfa:	89 d6                	mov    %edx,%esi
  800bfc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800c0c:	be 00 00 00 00       	mov    $0x0,%esi
  800c11:	b8 04 00 00 00       	mov    $0x4,%eax
  800c16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c19:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c1f:	89 f7                	mov    %esi,%edi
  800c21:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c23:	85 c0                	test   %eax,%eax
  800c25:	7e 28                	jle    800c4f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c27:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c2b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c32:	00 
  800c33:	c7 44 24 08 27 2f 80 	movl   $0x802f27,0x8(%esp)
  800c3a:	00 
  800c3b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c42:	00 
  800c43:	c7 04 24 44 2f 80 00 	movl   $0x802f44,(%esp)
  800c4a:	e8 17 1a 00 00       	call   802666 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c4f:	83 c4 2c             	add    $0x2c,%esp
  800c52:	5b                   	pop    %ebx
  800c53:	5e                   	pop    %esi
  800c54:	5f                   	pop    %edi
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    

00800c57 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	57                   	push   %edi
  800c5b:	56                   	push   %esi
  800c5c:	53                   	push   %ebx
  800c5d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c60:	b8 05 00 00 00       	mov    $0x5,%eax
  800c65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c68:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c6e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c71:	8b 75 18             	mov    0x18(%ebp),%esi
  800c74:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c76:	85 c0                	test   %eax,%eax
  800c78:	7e 28                	jle    800ca2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c7e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800c85:	00 
  800c86:	c7 44 24 08 27 2f 80 	movl   $0x802f27,0x8(%esp)
  800c8d:	00 
  800c8e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c95:	00 
  800c96:	c7 04 24 44 2f 80 00 	movl   $0x802f44,(%esp)
  800c9d:	e8 c4 19 00 00       	call   802666 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ca2:	83 c4 2c             	add    $0x2c,%esp
  800ca5:	5b                   	pop    %ebx
  800ca6:	5e                   	pop    %esi
  800ca7:	5f                   	pop    %edi
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    

00800caa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	57                   	push   %edi
  800cae:	56                   	push   %esi
  800caf:	53                   	push   %ebx
  800cb0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb8:	b8 06 00 00 00       	mov    $0x6,%eax
  800cbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc3:	89 df                	mov    %ebx,%edi
  800cc5:	89 de                	mov    %ebx,%esi
  800cc7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cc9:	85 c0                	test   %eax,%eax
  800ccb:	7e 28                	jle    800cf5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cd1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800cd8:	00 
  800cd9:	c7 44 24 08 27 2f 80 	movl   $0x802f27,0x8(%esp)
  800ce0:	00 
  800ce1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ce8:	00 
  800ce9:	c7 04 24 44 2f 80 00 	movl   $0x802f44,(%esp)
  800cf0:	e8 71 19 00 00       	call   802666 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cf5:	83 c4 2c             	add    $0x2c,%esp
  800cf8:	5b                   	pop    %ebx
  800cf9:	5e                   	pop    %esi
  800cfa:	5f                   	pop    %edi
  800cfb:	5d                   	pop    %ebp
  800cfc:	c3                   	ret    

00800cfd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	57                   	push   %edi
  800d01:	56                   	push   %esi
  800d02:	53                   	push   %ebx
  800d03:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d13:	8b 55 08             	mov    0x8(%ebp),%edx
  800d16:	89 df                	mov    %ebx,%edi
  800d18:	89 de                	mov    %ebx,%esi
  800d1a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d1c:	85 c0                	test   %eax,%eax
  800d1e:	7e 28                	jle    800d48 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d20:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d24:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d2b:	00 
  800d2c:	c7 44 24 08 27 2f 80 	movl   $0x802f27,0x8(%esp)
  800d33:	00 
  800d34:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d3b:	00 
  800d3c:	c7 04 24 44 2f 80 00 	movl   $0x802f44,(%esp)
  800d43:	e8 1e 19 00 00       	call   802666 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d48:	83 c4 2c             	add    $0x2c,%esp
  800d4b:	5b                   	pop    %ebx
  800d4c:	5e                   	pop    %esi
  800d4d:	5f                   	pop    %edi
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	57                   	push   %edi
  800d54:	56                   	push   %esi
  800d55:	53                   	push   %ebx
  800d56:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5e:	b8 09 00 00 00       	mov    $0x9,%eax
  800d63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
  800d69:	89 df                	mov    %ebx,%edi
  800d6b:	89 de                	mov    %ebx,%esi
  800d6d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d6f:	85 c0                	test   %eax,%eax
  800d71:	7e 28                	jle    800d9b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d73:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d77:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d7e:	00 
  800d7f:	c7 44 24 08 27 2f 80 	movl   $0x802f27,0x8(%esp)
  800d86:	00 
  800d87:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d8e:	00 
  800d8f:	c7 04 24 44 2f 80 00 	movl   $0x802f44,(%esp)
  800d96:	e8 cb 18 00 00       	call   802666 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d9b:	83 c4 2c             	add    $0x2c,%esp
  800d9e:	5b                   	pop    %ebx
  800d9f:	5e                   	pop    %esi
  800da0:	5f                   	pop    %edi
  800da1:	5d                   	pop    %ebp
  800da2:	c3                   	ret    

00800da3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	57                   	push   %edi
  800da7:	56                   	push   %esi
  800da8:	53                   	push   %ebx
  800da9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800db6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	89 df                	mov    %ebx,%edi
  800dbe:	89 de                	mov    %ebx,%esi
  800dc0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800dc2:	85 c0                	test   %eax,%eax
  800dc4:	7e 28                	jle    800dee <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dca:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800dd1:	00 
  800dd2:	c7 44 24 08 27 2f 80 	movl   $0x802f27,0x8(%esp)
  800dd9:	00 
  800dda:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800de1:	00 
  800de2:	c7 04 24 44 2f 80 00 	movl   $0x802f44,(%esp)
  800de9:	e8 78 18 00 00       	call   802666 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dee:	83 c4 2c             	add    $0x2c,%esp
  800df1:	5b                   	pop    %ebx
  800df2:	5e                   	pop    %esi
  800df3:	5f                   	pop    %edi
  800df4:	5d                   	pop    %ebp
  800df5:	c3                   	ret    

00800df6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	57                   	push   %edi
  800dfa:	56                   	push   %esi
  800dfb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dfc:	be 00 00 00 00       	mov    $0x0,%esi
  800e01:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e12:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e14:	5b                   	pop    %ebx
  800e15:	5e                   	pop    %esi
  800e16:	5f                   	pop    %edi
  800e17:	5d                   	pop    %ebp
  800e18:	c3                   	ret    

00800e19 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	57                   	push   %edi
  800e1d:	56                   	push   %esi
  800e1e:	53                   	push   %ebx
  800e1f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e22:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e27:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2f:	89 cb                	mov    %ecx,%ebx
  800e31:	89 cf                	mov    %ecx,%edi
  800e33:	89 ce                	mov    %ecx,%esi
  800e35:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e37:	85 c0                	test   %eax,%eax
  800e39:	7e 28                	jle    800e63 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e3f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e46:	00 
  800e47:	c7 44 24 08 27 2f 80 	movl   $0x802f27,0x8(%esp)
  800e4e:	00 
  800e4f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e56:	00 
  800e57:	c7 04 24 44 2f 80 00 	movl   $0x802f44,(%esp)
  800e5e:	e8 03 18 00 00       	call   802666 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e63:	83 c4 2c             	add    $0x2c,%esp
  800e66:	5b                   	pop    %ebx
  800e67:	5e                   	pop    %esi
  800e68:	5f                   	pop    %edi
  800e69:	5d                   	pop    %ebp
  800e6a:	c3                   	ret    

00800e6b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	57                   	push   %edi
  800e6f:	56                   	push   %esi
  800e70:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e71:	ba 00 00 00 00       	mov    $0x0,%edx
  800e76:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e7b:	89 d1                	mov    %edx,%ecx
  800e7d:	89 d3                	mov    %edx,%ebx
  800e7f:	89 d7                	mov    %edx,%edi
  800e81:	89 d6                	mov    %edx,%esi
  800e83:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e85:	5b                   	pop    %ebx
  800e86:	5e                   	pop    %esi
  800e87:	5f                   	pop    %edi
  800e88:	5d                   	pop    %ebp
  800e89:	c3                   	ret    

00800e8a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800e8a:	55                   	push   %ebp
  800e8b:	89 e5                	mov    %esp,%ebp
  800e8d:	57                   	push   %edi
  800e8e:	56                   	push   %esi
  800e8f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e95:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea0:	89 df                	mov    %ebx,%edi
  800ea2:	89 de                	mov    %ebx,%esi
  800ea4:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800ea6:	5b                   	pop    %ebx
  800ea7:	5e                   	pop    %esi
  800ea8:	5f                   	pop    %edi
  800ea9:	5d                   	pop    %ebp
  800eaa:	c3                   	ret    

00800eab <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	57                   	push   %edi
  800eaf:	56                   	push   %esi
  800eb0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb6:	b8 10 00 00 00       	mov    $0x10,%eax
  800ebb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec1:	89 df                	mov    %ebx,%edi
  800ec3:	89 de                	mov    %ebx,%esi
  800ec5:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800ec7:	5b                   	pop    %ebx
  800ec8:	5e                   	pop    %esi
  800ec9:	5f                   	pop    %edi
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    

00800ecc <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	57                   	push   %edi
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed7:	b8 11 00 00 00       	mov    $0x11,%eax
  800edc:	8b 55 08             	mov    0x8(%ebp),%edx
  800edf:	89 cb                	mov    %ecx,%ebx
  800ee1:	89 cf                	mov    %ecx,%edi
  800ee3:	89 ce                	mov    %ecx,%esi
  800ee5:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800ee7:	5b                   	pop    %ebx
  800ee8:	5e                   	pop    %esi
  800ee9:	5f                   	pop    %edi
  800eea:	5d                   	pop    %ebp
  800eeb:	c3                   	ret    

00800eec <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	57                   	push   %edi
  800ef0:	56                   	push   %esi
  800ef1:	53                   	push   %ebx
  800ef2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef5:	be 00 00 00 00       	mov    $0x0,%esi
  800efa:	b8 12 00 00 00       	mov    $0x12,%eax
  800eff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f02:	8b 55 08             	mov    0x8(%ebp),%edx
  800f05:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f08:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f0b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f0d:	85 c0                	test   %eax,%eax
  800f0f:	7e 28                	jle    800f39 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f11:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f15:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800f1c:	00 
  800f1d:	c7 44 24 08 27 2f 80 	movl   $0x802f27,0x8(%esp)
  800f24:	00 
  800f25:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f2c:	00 
  800f2d:	c7 04 24 44 2f 80 00 	movl   $0x802f44,(%esp)
  800f34:	e8 2d 17 00 00       	call   802666 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  800f39:	83 c4 2c             	add    $0x2c,%esp
  800f3c:	5b                   	pop    %ebx
  800f3d:	5e                   	pop    %esi
  800f3e:	5f                   	pop    %edi
  800f3f:	5d                   	pop    %ebp
  800f40:	c3                   	ret    

00800f41 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	53                   	push   %ebx
  800f45:	83 ec 24             	sub    $0x24,%esp
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f4b:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0)
  800f4d:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f51:	75 20                	jne    800f73 <pgfault+0x32>
		panic("pgfault: faulting address [%08x] not a write\n", addr);
  800f53:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f57:	c7 44 24 08 54 2f 80 	movl   $0x802f54,0x8(%esp)
  800f5e:	00 
  800f5f:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  800f66:	00 
  800f67:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  800f6e:	e8 f3 16 00 00       	call   802666 <_panic>

	void *page_aligned_addr = (void *) ROUNDDOWN(addr, PGSIZE);
  800f73:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t page_num = (uint32_t) page_aligned_addr / PGSIZE;
  800f79:	89 d8                	mov    %ebx,%eax
  800f7b:	c1 e8 0c             	shr    $0xc,%eax
	if (!(uvpt[page_num] & PTE_COW))
  800f7e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f85:	f6 c4 08             	test   $0x8,%ah
  800f88:	75 1c                	jne    800fa6 <pgfault+0x65>
		panic("pgfault: fault was not on a copy-on-write page\n");
  800f8a:	c7 44 24 08 84 2f 80 	movl   $0x802f84,0x8(%esp)
  800f91:	00 
  800f92:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f99:	00 
  800f9a:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  800fa1:	e8 c0 16 00 00       	call   802666 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	// Allocate
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  800fa6:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800fad:	00 
  800fae:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  800fb5:	00 
  800fb6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fbd:	e8 41 fc ff ff       	call   800c03 <sys_page_alloc>
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	79 20                	jns    800fe6 <pgfault+0xa5>
		panic("sys_page_alloc: %e\n", r);
  800fc6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fca:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  800fd1:	00 
  800fd2:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  800fd9:	00 
  800fda:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  800fe1:	e8 80 16 00 00       	call   802666 <_panic>

	// Copy over
	void *src_addr = (void *) ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, src_addr, PGSIZE);
  800fe6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800fed:	00 
  800fee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ff2:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  800ff9:	e8 86 f9 ff ff       	call   800984 <memmove>

	// Remap
	if ((r = sys_page_map(0, PFTEMP, 0, src_addr, PTE_P | PTE_U | PTE_W)) < 0)
  800ffe:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801005:	00 
  801006:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80100a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801011:	00 
  801012:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801019:	00 
  80101a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801021:	e8 31 fc ff ff       	call   800c57 <sys_page_map>
  801026:	85 c0                	test   %eax,%eax
  801028:	79 20                	jns    80104a <pgfault+0x109>
		panic("sys_page_map: %e\n", r);
  80102a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80102e:	c7 44 24 08 f3 2f 80 	movl   $0x802ff3,0x8(%esp)
  801035:	00 
  801036:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  80103d:	00 
  80103e:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  801045:	e8 1c 16 00 00       	call   802666 <_panic>

	//panic("pgfault not implemented");
}
  80104a:	83 c4 24             	add    $0x24,%esp
  80104d:	5b                   	pop    %ebx
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    

00801050 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
  801053:	57                   	push   %edi
  801054:	56                   	push   %esi
  801055:	53                   	push   %ebx
  801056:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	int r;
	envid_t child_envid;

	set_pgfault_handler(pgfault);
  801059:	c7 04 24 41 0f 80 00 	movl   $0x800f41,(%esp)
  801060:	e8 57 16 00 00       	call   8026bc <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801065:	b8 07 00 00 00       	mov    $0x7,%eax
  80106a:	cd 30                	int    $0x30
  80106c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80106f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	child_envid = sys_exofork();
	if (child_envid < 0)
  801072:	85 c0                	test   %eax,%eax
  801074:	79 20                	jns    801096 <fork+0x46>
		panic("sys_exofork: %e\n", child_envid);
  801076:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80107a:	c7 44 24 08 05 30 80 	movl   $0x803005,0x8(%esp)
  801081:	00 
  801082:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  801089:	00 
  80108a:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  801091:	e8 d0 15 00 00       	call   802666 <_panic>
	if (child_envid == 0) { // child
  801096:	bf 00 00 00 00       	mov    $0x0,%edi
  80109b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010a4:	75 21                	jne    8010c7 <fork+0x77>
		// Fix thisenv like dumbfork does and return 0
		thisenv = &envs[ENVX(sys_getenvid())];
  8010a6:	e8 1a fb ff ff       	call   800bc5 <sys_getenvid>
  8010ab:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010b0:	c1 e0 07             	shl    $0x7,%eax
  8010b3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010b8:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8010bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8010c2:	e9 53 02 00 00       	jmp    80131a <fork+0x2ca>
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
  8010c7:	89 d8                	mov    %ebx,%eax
  8010c9:	c1 e8 0a             	shr    $0xa,%eax
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  8010cc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010d3:	a8 01                	test   $0x1,%al
  8010d5:	0f 84 7a 01 00 00    	je     801255 <fork+0x205>
			((uvpt[page_num] & PTE_P) == PTE_P)) {
  8010db:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  8010e2:	a8 01                	test   $0x1,%al
  8010e4:	0f 84 6b 01 00 00    	je     801255 <fork+0x205>
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
	envid_t this_envid = thisenv->env_id;
  8010ea:	a1 08 50 80 00       	mov    0x805008,%eax
  8010ef:	8b 40 48             	mov    0x48(%eax),%eax
  8010f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 4: Your code here.
	if (uvpt[pn] & PTE_SHARE) {
  8010f5:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8010fc:	f6 c4 04             	test   $0x4,%ah
  8010ff:	74 52                	je     801153 <fork+0x103>
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801101:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801108:	25 07 0e 00 00       	and    $0xe07,%eax
  80110d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801111:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801115:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801118:	89 44 24 08          	mov    %eax,0x8(%esp)
  80111c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801120:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801123:	89 04 24             	mov    %eax,(%esp)
  801126:	e8 2c fb ff ff       	call   800c57 <sys_page_map>
  80112b:	85 c0                	test   %eax,%eax
  80112d:	0f 89 22 01 00 00    	jns    801255 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801133:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801137:	c7 44 24 08 f3 2f 80 	movl   $0x802ff3,0x8(%esp)
  80113e:	00 
  80113f:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  801146:	00 
  801147:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  80114e:	e8 13 15 00 00       	call   802666 <_panic>
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
  801153:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80115a:	f6 c4 08             	test   $0x8,%ah
  80115d:	75 0f                	jne    80116e <fork+0x11e>
  80115f:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801166:	a8 02                	test   $0x2,%al
  801168:	0f 84 99 00 00 00    	je     801207 <fork+0x1b7>
		if (uvpt[pn] & PTE_U)
  80116e:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801175:	83 e0 04             	and    $0x4,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
  801178:	83 f8 01             	cmp    $0x1,%eax
  80117b:	19 f6                	sbb    %esi,%esi
  80117d:	83 e6 fc             	and    $0xfffffffc,%esi
  801180:	81 c6 05 08 00 00    	add    $0x805,%esi
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
		if (uvpt[pn] & PTE_U)
			perm |= PTE_U;

		// Map page COW, U and P in child
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), perm)) < 0)
  801186:	89 74 24 10          	mov    %esi,0x10(%esp)
  80118a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80118e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801191:	89 44 24 08          	mov    %eax,0x8(%esp)
  801195:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801199:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80119c:	89 04 24             	mov    %eax,(%esp)
  80119f:	e8 b3 fa ff ff       	call   800c57 <sys_page_map>
  8011a4:	85 c0                	test   %eax,%eax
  8011a6:	79 20                	jns    8011c8 <fork+0x178>
			panic("sys_page_map: %e\n", r);
  8011a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011ac:	c7 44 24 08 f3 2f 80 	movl   $0x802ff3,0x8(%esp)
  8011b3:	00 
  8011b4:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  8011bb:	00 
  8011bc:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  8011c3:	e8 9e 14 00 00       	call   802666 <_panic>

		// Map page COW, U and P in parent
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), this_envid, (void *) (pn*PGSIZE), perm)) < 0)
  8011c8:	89 74 24 10          	mov    %esi,0x10(%esp)
  8011cc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011db:	89 04 24             	mov    %eax,(%esp)
  8011de:	e8 74 fa ff ff       	call   800c57 <sys_page_map>
  8011e3:	85 c0                	test   %eax,%eax
  8011e5:	79 6e                	jns    801255 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  8011e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011eb:	c7 44 24 08 f3 2f 80 	movl   $0x802ff3,0x8(%esp)
  8011f2:	00 
  8011f3:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8011fa:	00 
  8011fb:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  801202:	e8 5f 14 00 00       	call   802666 <_panic>

	} else { // map pages that are present but not writable or COW with their original permissions
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801207:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80120e:	25 07 0e 00 00       	and    $0xe07,%eax
  801213:	89 44 24 10          	mov    %eax,0x10(%esp)
  801217:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80121b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80121e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801222:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801229:	89 04 24             	mov    %eax,(%esp)
  80122c:	e8 26 fa ff ff       	call   800c57 <sys_page_map>
  801231:	85 c0                	test   %eax,%eax
  801233:	79 20                	jns    801255 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801235:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801239:	c7 44 24 08 f3 2f 80 	movl   $0x802ff3,0x8(%esp)
  801240:	00 
  801241:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  801248:	00 
  801249:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  801250:	e8 11 14 00 00       	call   802666 <_panic>
	// and let duppage worry about the permissions.
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
  801255:	83 c3 01             	add    $0x1,%ebx
  801258:	81 c7 00 10 00 00    	add    $0x1000,%edi
  80125e:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801264:	0f 85 5d fe ff ff    	jne    8010c7 <fork+0x77>
	}

	// Allocate exception stack space for child. The child can't do this themselves
	// because the mechanism by which it would is to run the pgfault handler, which
	// needs to run on the exception stack (catch 22).
	if ((r = sys_page_alloc(child_envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80126a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801271:	00 
  801272:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801279:	ee 
  80127a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80127d:	89 04 24             	mov    %eax,(%esp)
  801280:	e8 7e f9 ff ff       	call   800c03 <sys_page_alloc>
  801285:	85 c0                	test   %eax,%eax
  801287:	79 20                	jns    8012a9 <fork+0x259>
		panic("sys_page_alloc: %e\n", r);
  801289:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80128d:	c7 44 24 08 df 2f 80 	movl   $0x802fdf,0x8(%esp)
  801294:	00 
  801295:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  80129c:	00 
  80129d:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  8012a4:	e8 bd 13 00 00       	call   802666 <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  8012a9:	c7 44 24 04 3d 27 80 	movl   $0x80273d,0x4(%esp)
  8012b0:	00 
  8012b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012b4:	89 04 24             	mov    %eax,(%esp)
  8012b7:	e8 e7 fa ff ff       	call   800da3 <sys_env_set_pgfault_upcall>
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	79 20                	jns    8012e0 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  8012c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012c4:	c7 44 24 08 b4 2f 80 	movl   $0x802fb4,0x8(%esp)
  8012cb:	00 
  8012cc:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8012d3:	00 
  8012d4:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  8012db:	e8 86 13 00 00       	call   802666 <_panic>

	// Mark child environment as runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  8012e0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8012e7:	00 
  8012e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012eb:	89 04 24             	mov    %eax,(%esp)
  8012ee:	e8 0a fa ff ff       	call   800cfd <sys_env_set_status>
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	79 20                	jns    801317 <fork+0x2c7>
		panic("sys_env_set_status: %e\n", r);
  8012f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012fb:	c7 44 24 08 16 30 80 	movl   $0x803016,0x8(%esp)
  801302:	00 
  801303:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80130a:	00 
  80130b:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  801312:	e8 4f 13 00 00       	call   802666 <_panic>

	return child_envid;
  801317:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  80131a:	83 c4 2c             	add    $0x2c,%esp
  80131d:	5b                   	pop    %ebx
  80131e:	5e                   	pop    %esi
  80131f:	5f                   	pop    %edi
  801320:	5d                   	pop    %ebp
  801321:	c3                   	ret    

00801322 <sfork>:

// Challenge!
int
sfork(void)
{
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	83 ec 18             	sub    $0x18,%esp
//	return __fork(1);
	panic("sfork not implemented");
  801328:	c7 44 24 08 2e 30 80 	movl   $0x80302e,0x8(%esp)
  80132f:	00 
  801330:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  801337:	00 
  801338:	c7 04 24 d4 2f 80 00 	movl   $0x802fd4,(%esp)
  80133f:	e8 22 13 00 00       	call   802666 <_panic>
  801344:	66 90                	xchg   %ax,%ax
  801346:	66 90                	xchg   %ax,%ax
  801348:	66 90                	xchg   %ax,%ax
  80134a:	66 90                	xchg   %ax,%ax
  80134c:	66 90                	xchg   %ax,%ax
  80134e:	66 90                	xchg   %ax,%ax

00801350 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	05 00 00 00 30       	add    $0x30000000,%eax
  80135b:	c1 e8 0c             	shr    $0xc,%eax
}
  80135e:	5d                   	pop    %ebp
  80135f:	c3                   	ret    

00801360 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80136b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801370:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801375:	5d                   	pop    %ebp
  801376:	c3                   	ret    

00801377 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801382:	89 c2                	mov    %eax,%edx
  801384:	c1 ea 16             	shr    $0x16,%edx
  801387:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80138e:	f6 c2 01             	test   $0x1,%dl
  801391:	74 11                	je     8013a4 <fd_alloc+0x2d>
  801393:	89 c2                	mov    %eax,%edx
  801395:	c1 ea 0c             	shr    $0xc,%edx
  801398:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80139f:	f6 c2 01             	test   $0x1,%dl
  8013a2:	75 09                	jne    8013ad <fd_alloc+0x36>
			*fd_store = fd;
  8013a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ab:	eb 17                	jmp    8013c4 <fd_alloc+0x4d>
  8013ad:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013b2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013b7:	75 c9                	jne    801382 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013b9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8013bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8013c4:	5d                   	pop    %ebp
  8013c5:	c3                   	ret    

008013c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013cc:	83 f8 1f             	cmp    $0x1f,%eax
  8013cf:	77 36                	ja     801407 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013d1:	c1 e0 0c             	shl    $0xc,%eax
  8013d4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013d9:	89 c2                	mov    %eax,%edx
  8013db:	c1 ea 16             	shr    $0x16,%edx
  8013de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013e5:	f6 c2 01             	test   $0x1,%dl
  8013e8:	74 24                	je     80140e <fd_lookup+0x48>
  8013ea:	89 c2                	mov    %eax,%edx
  8013ec:	c1 ea 0c             	shr    $0xc,%edx
  8013ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013f6:	f6 c2 01             	test   $0x1,%dl
  8013f9:	74 1a                	je     801415 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fe:	89 02                	mov    %eax,(%edx)
	return 0;
  801400:	b8 00 00 00 00       	mov    $0x0,%eax
  801405:	eb 13                	jmp    80141a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801407:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80140c:	eb 0c                	jmp    80141a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80140e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801413:	eb 05                	jmp    80141a <fd_lookup+0x54>
  801415:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80141a:	5d                   	pop    %ebp
  80141b:	c3                   	ret    

0080141c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	83 ec 18             	sub    $0x18,%esp
  801422:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801425:	ba 00 00 00 00       	mov    $0x0,%edx
  80142a:	eb 13                	jmp    80143f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80142c:	39 08                	cmp    %ecx,(%eax)
  80142e:	75 0c                	jne    80143c <dev_lookup+0x20>
			*dev = devtab[i];
  801430:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801433:	89 01                	mov    %eax,(%ecx)
			return 0;
  801435:	b8 00 00 00 00       	mov    $0x0,%eax
  80143a:	eb 38                	jmp    801474 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80143c:	83 c2 01             	add    $0x1,%edx
  80143f:	8b 04 95 c0 30 80 00 	mov    0x8030c0(,%edx,4),%eax
  801446:	85 c0                	test   %eax,%eax
  801448:	75 e2                	jne    80142c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80144a:	a1 08 50 80 00       	mov    0x805008,%eax
  80144f:	8b 40 48             	mov    0x48(%eax),%eax
  801452:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801456:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145a:	c7 04 24 44 30 80 00 	movl   $0x803044,(%esp)
  801461:	e8 5d ed ff ff       	call   8001c3 <cprintf>
	*dev = 0;
  801466:	8b 45 0c             	mov    0xc(%ebp),%eax
  801469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80146f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801474:	c9                   	leave  
  801475:	c3                   	ret    

00801476 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	56                   	push   %esi
  80147a:	53                   	push   %ebx
  80147b:	83 ec 20             	sub    $0x20,%esp
  80147e:	8b 75 08             	mov    0x8(%ebp),%esi
  801481:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801484:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801487:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80148b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801491:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801494:	89 04 24             	mov    %eax,(%esp)
  801497:	e8 2a ff ff ff       	call   8013c6 <fd_lookup>
  80149c:	85 c0                	test   %eax,%eax
  80149e:	78 05                	js     8014a5 <fd_close+0x2f>
	    || fd != fd2)
  8014a0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014a3:	74 0c                	je     8014b1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8014a5:	84 db                	test   %bl,%bl
  8014a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ac:	0f 44 c2             	cmove  %edx,%eax
  8014af:	eb 3f                	jmp    8014f0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b8:	8b 06                	mov    (%esi),%eax
  8014ba:	89 04 24             	mov    %eax,(%esp)
  8014bd:	e8 5a ff ff ff       	call   80141c <dev_lookup>
  8014c2:	89 c3                	mov    %eax,%ebx
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	78 16                	js     8014de <fd_close+0x68>
		if (dev->dev_close)
  8014c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8014ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8014d3:	85 c0                	test   %eax,%eax
  8014d5:	74 07                	je     8014de <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8014d7:	89 34 24             	mov    %esi,(%esp)
  8014da:	ff d0                	call   *%eax
  8014dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8014de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014e9:	e8 bc f7 ff ff       	call   800caa <sys_page_unmap>
	return r;
  8014ee:	89 d8                	mov    %ebx,%eax
}
  8014f0:	83 c4 20             	add    $0x20,%esp
  8014f3:	5b                   	pop    %ebx
  8014f4:	5e                   	pop    %esi
  8014f5:	5d                   	pop    %ebp
  8014f6:	c3                   	ret    

008014f7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801500:	89 44 24 04          	mov    %eax,0x4(%esp)
  801504:	8b 45 08             	mov    0x8(%ebp),%eax
  801507:	89 04 24             	mov    %eax,(%esp)
  80150a:	e8 b7 fe ff ff       	call   8013c6 <fd_lookup>
  80150f:	89 c2                	mov    %eax,%edx
  801511:	85 d2                	test   %edx,%edx
  801513:	78 13                	js     801528 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801515:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80151c:	00 
  80151d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801520:	89 04 24             	mov    %eax,(%esp)
  801523:	e8 4e ff ff ff       	call   801476 <fd_close>
}
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <close_all>:

void
close_all(void)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	53                   	push   %ebx
  80152e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801531:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801536:	89 1c 24             	mov    %ebx,(%esp)
  801539:	e8 b9 ff ff ff       	call   8014f7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80153e:	83 c3 01             	add    $0x1,%ebx
  801541:	83 fb 20             	cmp    $0x20,%ebx
  801544:	75 f0                	jne    801536 <close_all+0xc>
		close(i);
}
  801546:	83 c4 14             	add    $0x14,%esp
  801549:	5b                   	pop    %ebx
  80154a:	5d                   	pop    %ebp
  80154b:	c3                   	ret    

0080154c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	57                   	push   %edi
  801550:	56                   	push   %esi
  801551:	53                   	push   %ebx
  801552:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801555:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801558:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	89 04 24             	mov    %eax,(%esp)
  801562:	e8 5f fe ff ff       	call   8013c6 <fd_lookup>
  801567:	89 c2                	mov    %eax,%edx
  801569:	85 d2                	test   %edx,%edx
  80156b:	0f 88 e1 00 00 00    	js     801652 <dup+0x106>
		return r;
	close(newfdnum);
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	89 04 24             	mov    %eax,(%esp)
  801577:	e8 7b ff ff ff       	call   8014f7 <close>

	newfd = INDEX2FD(newfdnum);
  80157c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80157f:	c1 e3 0c             	shl    $0xc,%ebx
  801582:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80158b:	89 04 24             	mov    %eax,(%esp)
  80158e:	e8 cd fd ff ff       	call   801360 <fd2data>
  801593:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801595:	89 1c 24             	mov    %ebx,(%esp)
  801598:	e8 c3 fd ff ff       	call   801360 <fd2data>
  80159d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80159f:	89 f0                	mov    %esi,%eax
  8015a1:	c1 e8 16             	shr    $0x16,%eax
  8015a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015ab:	a8 01                	test   $0x1,%al
  8015ad:	74 43                	je     8015f2 <dup+0xa6>
  8015af:	89 f0                	mov    %esi,%eax
  8015b1:	c1 e8 0c             	shr    $0xc,%eax
  8015b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015bb:	f6 c2 01             	test   $0x1,%dl
  8015be:	74 32                	je     8015f2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8015cc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015d0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015db:	00 
  8015dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015e7:	e8 6b f6 ff ff       	call   800c57 <sys_page_map>
  8015ec:	89 c6                	mov    %eax,%esi
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	78 3e                	js     801630 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015f5:	89 c2                	mov    %eax,%edx
  8015f7:	c1 ea 0c             	shr    $0xc,%edx
  8015fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801601:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801607:	89 54 24 10          	mov    %edx,0x10(%esp)
  80160b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80160f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801616:	00 
  801617:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801622:	e8 30 f6 ff ff       	call   800c57 <sys_page_map>
  801627:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801629:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80162c:	85 f6                	test   %esi,%esi
  80162e:	79 22                	jns    801652 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801630:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801634:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80163b:	e8 6a f6 ff ff       	call   800caa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801640:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801644:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80164b:	e8 5a f6 ff ff       	call   800caa <sys_page_unmap>
	return r;
  801650:	89 f0                	mov    %esi,%eax
}
  801652:	83 c4 3c             	add    $0x3c,%esp
  801655:	5b                   	pop    %ebx
  801656:	5e                   	pop    %esi
  801657:	5f                   	pop    %edi
  801658:	5d                   	pop    %ebp
  801659:	c3                   	ret    

0080165a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	53                   	push   %ebx
  80165e:	83 ec 24             	sub    $0x24,%esp
  801661:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801664:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801667:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166b:	89 1c 24             	mov    %ebx,(%esp)
  80166e:	e8 53 fd ff ff       	call   8013c6 <fd_lookup>
  801673:	89 c2                	mov    %eax,%edx
  801675:	85 d2                	test   %edx,%edx
  801677:	78 6d                	js     8016e6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801679:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801683:	8b 00                	mov    (%eax),%eax
  801685:	89 04 24             	mov    %eax,(%esp)
  801688:	e8 8f fd ff ff       	call   80141c <dev_lookup>
  80168d:	85 c0                	test   %eax,%eax
  80168f:	78 55                	js     8016e6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801694:	8b 50 08             	mov    0x8(%eax),%edx
  801697:	83 e2 03             	and    $0x3,%edx
  80169a:	83 fa 01             	cmp    $0x1,%edx
  80169d:	75 23                	jne    8016c2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80169f:	a1 08 50 80 00       	mov    0x805008,%eax
  8016a4:	8b 40 48             	mov    0x48(%eax),%eax
  8016a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016af:	c7 04 24 85 30 80 00 	movl   $0x803085,(%esp)
  8016b6:	e8 08 eb ff ff       	call   8001c3 <cprintf>
		return -E_INVAL;
  8016bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c0:	eb 24                	jmp    8016e6 <read+0x8c>
	}
	if (!dev->dev_read)
  8016c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c5:	8b 52 08             	mov    0x8(%edx),%edx
  8016c8:	85 d2                	test   %edx,%edx
  8016ca:	74 15                	je     8016e1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016da:	89 04 24             	mov    %eax,(%esp)
  8016dd:	ff d2                	call   *%edx
  8016df:	eb 05                	jmp    8016e6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8016e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8016e6:	83 c4 24             	add    $0x24,%esp
  8016e9:	5b                   	pop    %ebx
  8016ea:	5d                   	pop    %ebp
  8016eb:	c3                   	ret    

008016ec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	57                   	push   %edi
  8016f0:	56                   	push   %esi
  8016f1:	53                   	push   %ebx
  8016f2:	83 ec 1c             	sub    $0x1c,%esp
  8016f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016f8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801700:	eb 23                	jmp    801725 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801702:	89 f0                	mov    %esi,%eax
  801704:	29 d8                	sub    %ebx,%eax
  801706:	89 44 24 08          	mov    %eax,0x8(%esp)
  80170a:	89 d8                	mov    %ebx,%eax
  80170c:	03 45 0c             	add    0xc(%ebp),%eax
  80170f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801713:	89 3c 24             	mov    %edi,(%esp)
  801716:	e8 3f ff ff ff       	call   80165a <read>
		if (m < 0)
  80171b:	85 c0                	test   %eax,%eax
  80171d:	78 10                	js     80172f <readn+0x43>
			return m;
		if (m == 0)
  80171f:	85 c0                	test   %eax,%eax
  801721:	74 0a                	je     80172d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801723:	01 c3                	add    %eax,%ebx
  801725:	39 f3                	cmp    %esi,%ebx
  801727:	72 d9                	jb     801702 <readn+0x16>
  801729:	89 d8                	mov    %ebx,%eax
  80172b:	eb 02                	jmp    80172f <readn+0x43>
  80172d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80172f:	83 c4 1c             	add    $0x1c,%esp
  801732:	5b                   	pop    %ebx
  801733:	5e                   	pop    %esi
  801734:	5f                   	pop    %edi
  801735:	5d                   	pop    %ebp
  801736:	c3                   	ret    

00801737 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	53                   	push   %ebx
  80173b:	83 ec 24             	sub    $0x24,%esp
  80173e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801741:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801744:	89 44 24 04          	mov    %eax,0x4(%esp)
  801748:	89 1c 24             	mov    %ebx,(%esp)
  80174b:	e8 76 fc ff ff       	call   8013c6 <fd_lookup>
  801750:	89 c2                	mov    %eax,%edx
  801752:	85 d2                	test   %edx,%edx
  801754:	78 68                	js     8017be <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801756:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801759:	89 44 24 04          	mov    %eax,0x4(%esp)
  80175d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801760:	8b 00                	mov    (%eax),%eax
  801762:	89 04 24             	mov    %eax,(%esp)
  801765:	e8 b2 fc ff ff       	call   80141c <dev_lookup>
  80176a:	85 c0                	test   %eax,%eax
  80176c:	78 50                	js     8017be <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80176e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801771:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801775:	75 23                	jne    80179a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801777:	a1 08 50 80 00       	mov    0x805008,%eax
  80177c:	8b 40 48             	mov    0x48(%eax),%eax
  80177f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801783:	89 44 24 04          	mov    %eax,0x4(%esp)
  801787:	c7 04 24 a1 30 80 00 	movl   $0x8030a1,(%esp)
  80178e:	e8 30 ea ff ff       	call   8001c3 <cprintf>
		return -E_INVAL;
  801793:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801798:	eb 24                	jmp    8017be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80179a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80179d:	8b 52 0c             	mov    0xc(%edx),%edx
  8017a0:	85 d2                	test   %edx,%edx
  8017a2:	74 15                	je     8017b9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017b2:	89 04 24             	mov    %eax,(%esp)
  8017b5:	ff d2                	call   *%edx
  8017b7:	eb 05                	jmp    8017be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8017b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8017be:	83 c4 24             	add    $0x24,%esp
  8017c1:	5b                   	pop    %ebx
  8017c2:	5d                   	pop    %ebp
  8017c3:	c3                   	ret    

008017c4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
  8017c7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017ca:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	89 04 24             	mov    %eax,(%esp)
  8017d7:	e8 ea fb ff ff       	call   8013c6 <fd_lookup>
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	78 0e                	js     8017ee <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8017e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	53                   	push   %ebx
  8017f4:	83 ec 24             	sub    $0x24,%esp
  8017f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801801:	89 1c 24             	mov    %ebx,(%esp)
  801804:	e8 bd fb ff ff       	call   8013c6 <fd_lookup>
  801809:	89 c2                	mov    %eax,%edx
  80180b:	85 d2                	test   %edx,%edx
  80180d:	78 61                	js     801870 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80180f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801812:	89 44 24 04          	mov    %eax,0x4(%esp)
  801816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801819:	8b 00                	mov    (%eax),%eax
  80181b:	89 04 24             	mov    %eax,(%esp)
  80181e:	e8 f9 fb ff ff       	call   80141c <dev_lookup>
  801823:	85 c0                	test   %eax,%eax
  801825:	78 49                	js     801870 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80182e:	75 23                	jne    801853 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801830:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801835:	8b 40 48             	mov    0x48(%eax),%eax
  801838:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80183c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801840:	c7 04 24 64 30 80 00 	movl   $0x803064,(%esp)
  801847:	e8 77 e9 ff ff       	call   8001c3 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80184c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801851:	eb 1d                	jmp    801870 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801853:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801856:	8b 52 18             	mov    0x18(%edx),%edx
  801859:	85 d2                	test   %edx,%edx
  80185b:	74 0e                	je     80186b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80185d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801860:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801864:	89 04 24             	mov    %eax,(%esp)
  801867:	ff d2                	call   *%edx
  801869:	eb 05                	jmp    801870 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80186b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801870:	83 c4 24             	add    $0x24,%esp
  801873:	5b                   	pop    %ebx
  801874:	5d                   	pop    %ebp
  801875:	c3                   	ret    

00801876 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	53                   	push   %ebx
  80187a:	83 ec 24             	sub    $0x24,%esp
  80187d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801880:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801883:	89 44 24 04          	mov    %eax,0x4(%esp)
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	89 04 24             	mov    %eax,(%esp)
  80188d:	e8 34 fb ff ff       	call   8013c6 <fd_lookup>
  801892:	89 c2                	mov    %eax,%edx
  801894:	85 d2                	test   %edx,%edx
  801896:	78 52                	js     8018ea <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801898:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a2:	8b 00                	mov    (%eax),%eax
  8018a4:	89 04 24             	mov    %eax,(%esp)
  8018a7:	e8 70 fb ff ff       	call   80141c <dev_lookup>
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 3a                	js     8018ea <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8018b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018b7:	74 2c                	je     8018e5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018b9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018bc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018c3:	00 00 00 
	stat->st_isdir = 0;
  8018c6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018cd:	00 00 00 
	stat->st_dev = dev;
  8018d0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018dd:	89 14 24             	mov    %edx,(%esp)
  8018e0:	ff 50 14             	call   *0x14(%eax)
  8018e3:	eb 05                	jmp    8018ea <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8018e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8018ea:	83 c4 24             	add    $0x24,%esp
  8018ed:	5b                   	pop    %ebx
  8018ee:	5d                   	pop    %ebp
  8018ef:	c3                   	ret    

008018f0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	56                   	push   %esi
  8018f4:	53                   	push   %ebx
  8018f5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018ff:	00 
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	89 04 24             	mov    %eax,(%esp)
  801906:	e8 84 02 00 00       	call   801b8f <open>
  80190b:	89 c3                	mov    %eax,%ebx
  80190d:	85 db                	test   %ebx,%ebx
  80190f:	78 1b                	js     80192c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801911:	8b 45 0c             	mov    0xc(%ebp),%eax
  801914:	89 44 24 04          	mov    %eax,0x4(%esp)
  801918:	89 1c 24             	mov    %ebx,(%esp)
  80191b:	e8 56 ff ff ff       	call   801876 <fstat>
  801920:	89 c6                	mov    %eax,%esi
	close(fd);
  801922:	89 1c 24             	mov    %ebx,(%esp)
  801925:	e8 cd fb ff ff       	call   8014f7 <close>
	return r;
  80192a:	89 f0                	mov    %esi,%eax
}
  80192c:	83 c4 10             	add    $0x10,%esp
  80192f:	5b                   	pop    %ebx
  801930:	5e                   	pop    %esi
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    

00801933 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	56                   	push   %esi
  801937:	53                   	push   %ebx
  801938:	83 ec 10             	sub    $0x10,%esp
  80193b:	89 c6                	mov    %eax,%esi
  80193d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80193f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801946:	75 11                	jne    801959 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801948:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80194f:	e8 11 0f 00 00       	call   802865 <ipc_find_env>
  801954:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801959:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801960:	00 
  801961:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801968:	00 
  801969:	89 74 24 04          	mov    %esi,0x4(%esp)
  80196d:	a1 00 50 80 00       	mov    0x805000,%eax
  801972:	89 04 24             	mov    %eax,(%esp)
  801975:	e8 5e 0e 00 00       	call   8027d8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80197a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801981:	00 
  801982:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801986:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80198d:	e8 de 0d 00 00       	call   802770 <ipc_recv>
}
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	5b                   	pop    %ebx
  801996:	5e                   	pop    %esi
  801997:	5d                   	pop    %ebp
  801998:	c3                   	ret    

00801999 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
  80199c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8019aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ad:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8019bc:	e8 72 ff ff ff       	call   801933 <fsipc>
}
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8019cf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8019d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d9:	b8 06 00 00 00       	mov    $0x6,%eax
  8019de:	e8 50 ff ff ff       	call   801933 <fsipc>
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	53                   	push   %ebx
  8019e9:	83 ec 14             	sub    $0x14,%esp
  8019ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ff:	b8 05 00 00 00       	mov    $0x5,%eax
  801a04:	e8 2a ff ff ff       	call   801933 <fsipc>
  801a09:	89 c2                	mov    %eax,%edx
  801a0b:	85 d2                	test   %edx,%edx
  801a0d:	78 2b                	js     801a3a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a0f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801a16:	00 
  801a17:	89 1c 24             	mov    %ebx,(%esp)
  801a1a:	e8 c8 ed ff ff       	call   8007e7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a1f:	a1 80 60 80 00       	mov    0x806080,%eax
  801a24:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a2a:	a1 84 60 80 00       	mov    0x806084,%eax
  801a2f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3a:	83 c4 14             	add    $0x14,%esp
  801a3d:	5b                   	pop    %ebx
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    

00801a40 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	53                   	push   %ebx
  801a44:	83 ec 14             	sub    $0x14,%esp
  801a47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a50:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801a55:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801a5b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801a60:	0f 46 c3             	cmovbe %ebx,%eax
  801a63:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801a68:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a73:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801a7a:	e8 05 ef ff ff       	call   800984 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a7f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a84:	b8 04 00 00 00       	mov    $0x4,%eax
  801a89:	e8 a5 fe ff ff       	call   801933 <fsipc>
  801a8e:	85 c0                	test   %eax,%eax
  801a90:	78 53                	js     801ae5 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801a92:	39 c3                	cmp    %eax,%ebx
  801a94:	73 24                	jae    801aba <devfile_write+0x7a>
  801a96:	c7 44 24 0c d4 30 80 	movl   $0x8030d4,0xc(%esp)
  801a9d:	00 
  801a9e:	c7 44 24 08 db 30 80 	movl   $0x8030db,0x8(%esp)
  801aa5:	00 
  801aa6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801aad:	00 
  801aae:	c7 04 24 f0 30 80 00 	movl   $0x8030f0,(%esp)
  801ab5:	e8 ac 0b 00 00       	call   802666 <_panic>
	assert(r <= PGSIZE);
  801aba:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801abf:	7e 24                	jle    801ae5 <devfile_write+0xa5>
  801ac1:	c7 44 24 0c fb 30 80 	movl   $0x8030fb,0xc(%esp)
  801ac8:	00 
  801ac9:	c7 44 24 08 db 30 80 	movl   $0x8030db,0x8(%esp)
  801ad0:	00 
  801ad1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801ad8:	00 
  801ad9:	c7 04 24 f0 30 80 00 	movl   $0x8030f0,(%esp)
  801ae0:	e8 81 0b 00 00       	call   802666 <_panic>
	return r;
}
  801ae5:	83 c4 14             	add    $0x14,%esp
  801ae8:	5b                   	pop    %ebx
  801ae9:	5d                   	pop    %ebp
  801aea:	c3                   	ret    

00801aeb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	56                   	push   %esi
  801aef:	53                   	push   %ebx
  801af0:	83 ec 10             	sub    $0x10,%esp
  801af3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	8b 40 0c             	mov    0xc(%eax),%eax
  801afc:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b01:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b07:	ba 00 00 00 00       	mov    $0x0,%edx
  801b0c:	b8 03 00 00 00       	mov    $0x3,%eax
  801b11:	e8 1d fe ff ff       	call   801933 <fsipc>
  801b16:	89 c3                	mov    %eax,%ebx
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	78 6a                	js     801b86 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b1c:	39 c6                	cmp    %eax,%esi
  801b1e:	73 24                	jae    801b44 <devfile_read+0x59>
  801b20:	c7 44 24 0c d4 30 80 	movl   $0x8030d4,0xc(%esp)
  801b27:	00 
  801b28:	c7 44 24 08 db 30 80 	movl   $0x8030db,0x8(%esp)
  801b2f:	00 
  801b30:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801b37:	00 
  801b38:	c7 04 24 f0 30 80 00 	movl   $0x8030f0,(%esp)
  801b3f:	e8 22 0b 00 00       	call   802666 <_panic>
	assert(r <= PGSIZE);
  801b44:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b49:	7e 24                	jle    801b6f <devfile_read+0x84>
  801b4b:	c7 44 24 0c fb 30 80 	movl   $0x8030fb,0xc(%esp)
  801b52:	00 
  801b53:	c7 44 24 08 db 30 80 	movl   $0x8030db,0x8(%esp)
  801b5a:	00 
  801b5b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801b62:	00 
  801b63:	c7 04 24 f0 30 80 00 	movl   $0x8030f0,(%esp)
  801b6a:	e8 f7 0a 00 00       	call   802666 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b6f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b73:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b7a:	00 
  801b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7e:	89 04 24             	mov    %eax,(%esp)
  801b81:	e8 fe ed ff ff       	call   800984 <memmove>
	return r;
}
  801b86:	89 d8                	mov    %ebx,%eax
  801b88:	83 c4 10             	add    $0x10,%esp
  801b8b:	5b                   	pop    %ebx
  801b8c:	5e                   	pop    %esi
  801b8d:	5d                   	pop    %ebp
  801b8e:	c3                   	ret    

00801b8f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	53                   	push   %ebx
  801b93:	83 ec 24             	sub    $0x24,%esp
  801b96:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b99:	89 1c 24             	mov    %ebx,(%esp)
  801b9c:	e8 0f ec ff ff       	call   8007b0 <strlen>
  801ba1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ba6:	7f 60                	jg     801c08 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801ba8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bab:	89 04 24             	mov    %eax,(%esp)
  801bae:	e8 c4 f7 ff ff       	call   801377 <fd_alloc>
  801bb3:	89 c2                	mov    %eax,%edx
  801bb5:	85 d2                	test   %edx,%edx
  801bb7:	78 54                	js     801c0d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801bb9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bbd:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801bc4:	e8 1e ec ff ff       	call   8007e7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcc:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd4:	b8 01 00 00 00       	mov    $0x1,%eax
  801bd9:	e8 55 fd ff ff       	call   801933 <fsipc>
  801bde:	89 c3                	mov    %eax,%ebx
  801be0:	85 c0                	test   %eax,%eax
  801be2:	79 17                	jns    801bfb <open+0x6c>
		fd_close(fd, 0);
  801be4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801beb:	00 
  801bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bef:	89 04 24             	mov    %eax,(%esp)
  801bf2:	e8 7f f8 ff ff       	call   801476 <fd_close>
		return r;
  801bf7:	89 d8                	mov    %ebx,%eax
  801bf9:	eb 12                	jmp    801c0d <open+0x7e>
	}

	return fd2num(fd);
  801bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfe:	89 04 24             	mov    %eax,(%esp)
  801c01:	e8 4a f7 ff ff       	call   801350 <fd2num>
  801c06:	eb 05                	jmp    801c0d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c08:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801c0d:	83 c4 24             	add    $0x24,%esp
  801c10:	5b                   	pop    %ebx
  801c11:	5d                   	pop    %ebp
  801c12:	c3                   	ret    

00801c13 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c19:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1e:	b8 08 00 00 00       	mov    $0x8,%eax
  801c23:	e8 0b fd ff ff       	call   801933 <fsipc>
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    
  801c2a:	66 90                	xchg   %ax,%ax
  801c2c:	66 90                	xchg   %ax,%ax
  801c2e:	66 90                	xchg   %ax,%ax

00801c30 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801c36:	c7 44 24 04 07 31 80 	movl   $0x803107,0x4(%esp)
  801c3d:	00 
  801c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c41:	89 04 24             	mov    %eax,(%esp)
  801c44:	e8 9e eb ff ff       	call   8007e7 <strcpy>
	return 0;
}
  801c49:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	53                   	push   %ebx
  801c54:	83 ec 14             	sub    $0x14,%esp
  801c57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c5a:	89 1c 24             	mov    %ebx,(%esp)
  801c5d:	e8 3d 0c 00 00       	call   80289f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801c62:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801c67:	83 f8 01             	cmp    $0x1,%eax
  801c6a:	75 0d                	jne    801c79 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801c6c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801c6f:	89 04 24             	mov    %eax,(%esp)
  801c72:	e8 29 03 00 00       	call   801fa0 <nsipc_close>
  801c77:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801c79:	89 d0                	mov    %edx,%eax
  801c7b:	83 c4 14             	add    $0x14,%esp
  801c7e:	5b                   	pop    %ebx
  801c7f:	5d                   	pop    %ebp
  801c80:	c3                   	ret    

00801c81 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c87:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c8e:	00 
  801c8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c92:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca3:	89 04 24             	mov    %eax,(%esp)
  801ca6:	e8 f0 03 00 00       	call   80209b <nsipc_send>
}
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cb3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cba:	00 
  801cbb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccc:	8b 40 0c             	mov    0xc(%eax),%eax
  801ccf:	89 04 24             	mov    %eax,(%esp)
  801cd2:	e8 44 03 00 00       	call   80201b <nsipc_recv>
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801cdf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ce2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ce6:	89 04 24             	mov    %eax,(%esp)
  801ce9:	e8 d8 f6 ff ff       	call   8013c6 <fd_lookup>
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	78 17                	js     801d09 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801cfb:	39 08                	cmp    %ecx,(%eax)
  801cfd:	75 05                	jne    801d04 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801cff:	8b 40 0c             	mov    0xc(%eax),%eax
  801d02:	eb 05                	jmp    801d09 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801d04:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	56                   	push   %esi
  801d0f:	53                   	push   %ebx
  801d10:	83 ec 20             	sub    $0x20,%esp
  801d13:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d18:	89 04 24             	mov    %eax,(%esp)
  801d1b:	e8 57 f6 ff ff       	call   801377 <fd_alloc>
  801d20:	89 c3                	mov    %eax,%ebx
  801d22:	85 c0                	test   %eax,%eax
  801d24:	78 21                	js     801d47 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d26:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d2d:	00 
  801d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d31:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d3c:	e8 c2 ee ff ff       	call   800c03 <sys_page_alloc>
  801d41:	89 c3                	mov    %eax,%ebx
  801d43:	85 c0                	test   %eax,%eax
  801d45:	79 0c                	jns    801d53 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801d47:	89 34 24             	mov    %esi,(%esp)
  801d4a:	e8 51 02 00 00       	call   801fa0 <nsipc_close>
		return r;
  801d4f:	89 d8                	mov    %ebx,%eax
  801d51:	eb 20                	jmp    801d73 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801d53:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d61:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801d68:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801d6b:	89 14 24             	mov    %edx,(%esp)
  801d6e:	e8 dd f5 ff ff       	call   801350 <fd2num>
}
  801d73:	83 c4 20             	add    $0x20,%esp
  801d76:	5b                   	pop    %ebx
  801d77:	5e                   	pop    %esi
  801d78:	5d                   	pop    %ebp
  801d79:	c3                   	ret    

00801d7a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	e8 51 ff ff ff       	call   801cd9 <fd2sockid>
		return r;
  801d88:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	78 23                	js     801db1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d8e:	8b 55 10             	mov    0x10(%ebp),%edx
  801d91:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d98:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d9c:	89 04 24             	mov    %eax,(%esp)
  801d9f:	e8 45 01 00 00       	call   801ee9 <nsipc_accept>
		return r;
  801da4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801da6:	85 c0                	test   %eax,%eax
  801da8:	78 07                	js     801db1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801daa:	e8 5c ff ff ff       	call   801d0b <alloc_sockfd>
  801daf:	89 c1                	mov    %eax,%ecx
}
  801db1:	89 c8                	mov    %ecx,%eax
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	e8 16 ff ff ff       	call   801cd9 <fd2sockid>
  801dc3:	89 c2                	mov    %eax,%edx
  801dc5:	85 d2                	test   %edx,%edx
  801dc7:	78 16                	js     801ddf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dcc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd7:	89 14 24             	mov    %edx,(%esp)
  801dda:	e8 60 01 00 00       	call   801f3f <nsipc_bind>
}
  801ddf:	c9                   	leave  
  801de0:	c3                   	ret    

00801de1 <shutdown>:

int
shutdown(int s, int how)
{
  801de1:	55                   	push   %ebp
  801de2:	89 e5                	mov    %esp,%ebp
  801de4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801de7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dea:	e8 ea fe ff ff       	call   801cd9 <fd2sockid>
  801def:	89 c2                	mov    %eax,%edx
  801df1:	85 d2                	test   %edx,%edx
  801df3:	78 0f                	js     801e04 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfc:	89 14 24             	mov    %edx,(%esp)
  801dff:	e8 7a 01 00 00       	call   801f7e <nsipc_shutdown>
}
  801e04:	c9                   	leave  
  801e05:	c3                   	ret    

00801e06 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e06:	55                   	push   %ebp
  801e07:	89 e5                	mov    %esp,%ebp
  801e09:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	e8 c5 fe ff ff       	call   801cd9 <fd2sockid>
  801e14:	89 c2                	mov    %eax,%edx
  801e16:	85 d2                	test   %edx,%edx
  801e18:	78 16                	js     801e30 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801e1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e28:	89 14 24             	mov    %edx,(%esp)
  801e2b:	e8 8a 01 00 00       	call   801fba <nsipc_connect>
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <listen>:

int
listen(int s, int backlog)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e38:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3b:	e8 99 fe ff ff       	call   801cd9 <fd2sockid>
  801e40:	89 c2                	mov    %eax,%edx
  801e42:	85 d2                	test   %edx,%edx
  801e44:	78 0f                	js     801e55 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4d:	89 14 24             	mov    %edx,(%esp)
  801e50:	e8 a4 01 00 00       	call   801ff9 <nsipc_listen>
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e60:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6e:	89 04 24             	mov    %eax,(%esp)
  801e71:	e8 98 02 00 00       	call   80210e <nsipc_socket>
  801e76:	89 c2                	mov    %eax,%edx
  801e78:	85 d2                	test   %edx,%edx
  801e7a:	78 05                	js     801e81 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801e7c:	e8 8a fe ff ff       	call   801d0b <alloc_sockfd>
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	53                   	push   %ebx
  801e87:	83 ec 14             	sub    $0x14,%esp
  801e8a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e8c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801e93:	75 11                	jne    801ea6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e95:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801e9c:	e8 c4 09 00 00       	call   802865 <ipc_find_env>
  801ea1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ea6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ead:	00 
  801eae:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801eb5:	00 
  801eb6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801eba:	a1 04 50 80 00       	mov    0x805004,%eax
  801ebf:	89 04 24             	mov    %eax,(%esp)
  801ec2:	e8 11 09 00 00       	call   8027d8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ec7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ece:	00 
  801ecf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ed6:	00 
  801ed7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ede:	e8 8d 08 00 00       	call   802770 <ipc_recv>
}
  801ee3:	83 c4 14             	add    $0x14,%esp
  801ee6:	5b                   	pop    %ebx
  801ee7:	5d                   	pop    %ebp
  801ee8:	c3                   	ret    

00801ee9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	56                   	push   %esi
  801eed:	53                   	push   %ebx
  801eee:	83 ec 10             	sub    $0x10,%esp
  801ef1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801efc:	8b 06                	mov    (%esi),%eax
  801efe:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f03:	b8 01 00 00 00       	mov    $0x1,%eax
  801f08:	e8 76 ff ff ff       	call   801e83 <nsipc>
  801f0d:	89 c3                	mov    %eax,%ebx
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	78 23                	js     801f36 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f13:	a1 10 70 80 00       	mov    0x807010,%eax
  801f18:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f1c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801f23:	00 
  801f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f27:	89 04 24             	mov    %eax,(%esp)
  801f2a:	e8 55 ea ff ff       	call   800984 <memmove>
		*addrlen = ret->ret_addrlen;
  801f2f:	a1 10 70 80 00       	mov    0x807010,%eax
  801f34:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801f36:	89 d8                	mov    %ebx,%eax
  801f38:	83 c4 10             	add    $0x10,%esp
  801f3b:	5b                   	pop    %ebx
  801f3c:	5e                   	pop    %esi
  801f3d:	5d                   	pop    %ebp
  801f3e:	c3                   	ret    

00801f3f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	53                   	push   %ebx
  801f43:	83 ec 14             	sub    $0x14,%esp
  801f46:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f51:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801f63:	e8 1c ea ff ff       	call   800984 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f68:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801f6e:	b8 02 00 00 00       	mov    $0x2,%eax
  801f73:	e8 0b ff ff ff       	call   801e83 <nsipc>
}
  801f78:	83 c4 14             	add    $0x14,%esp
  801f7b:	5b                   	pop    %ebx
  801f7c:	5d                   	pop    %ebp
  801f7d:	c3                   	ret    

00801f7e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801f94:	b8 03 00 00 00       	mov    $0x3,%eax
  801f99:	e8 e5 fe ff ff       	call   801e83 <nsipc>
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <nsipc_close>:

int
nsipc_close(int s)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801fae:	b8 04 00 00 00       	mov    $0x4,%eax
  801fb3:	e8 cb fe ff ff       	call   801e83 <nsipc>
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
  801fbd:	53                   	push   %ebx
  801fbe:	83 ec 14             	sub    $0x14,%esp
  801fc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801fcc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801fde:	e8 a1 e9 ff ff       	call   800984 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801fe3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801fe9:	b8 05 00 00 00       	mov    $0x5,%eax
  801fee:	e8 90 fe ff ff       	call   801e83 <nsipc>
}
  801ff3:	83 c4 14             	add    $0x14,%esp
  801ff6:	5b                   	pop    %ebx
  801ff7:	5d                   	pop    %ebp
  801ff8:	c3                   	ret    

00801ff9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801fff:	8b 45 08             	mov    0x8(%ebp),%eax
  802002:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802007:	8b 45 0c             	mov    0xc(%ebp),%eax
  80200a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80200f:	b8 06 00 00 00       	mov    $0x6,%eax
  802014:	e8 6a fe ff ff       	call   801e83 <nsipc>
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
  80201e:	56                   	push   %esi
  80201f:	53                   	push   %ebx
  802020:	83 ec 10             	sub    $0x10,%esp
  802023:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80202e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802034:	8b 45 14             	mov    0x14(%ebp),%eax
  802037:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80203c:	b8 07 00 00 00       	mov    $0x7,%eax
  802041:	e8 3d fe ff ff       	call   801e83 <nsipc>
  802046:	89 c3                	mov    %eax,%ebx
  802048:	85 c0                	test   %eax,%eax
  80204a:	78 46                	js     802092 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80204c:	39 f0                	cmp    %esi,%eax
  80204e:	7f 07                	jg     802057 <nsipc_recv+0x3c>
  802050:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802055:	7e 24                	jle    80207b <nsipc_recv+0x60>
  802057:	c7 44 24 0c 13 31 80 	movl   $0x803113,0xc(%esp)
  80205e:	00 
  80205f:	c7 44 24 08 db 30 80 	movl   $0x8030db,0x8(%esp)
  802066:	00 
  802067:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80206e:	00 
  80206f:	c7 04 24 28 31 80 00 	movl   $0x803128,(%esp)
  802076:	e8 eb 05 00 00       	call   802666 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80207b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80207f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802086:	00 
  802087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208a:	89 04 24             	mov    %eax,(%esp)
  80208d:	e8 f2 e8 ff ff       	call   800984 <memmove>
	}

	return r;
}
  802092:	89 d8                	mov    %ebx,%eax
  802094:	83 c4 10             	add    $0x10,%esp
  802097:	5b                   	pop    %ebx
  802098:	5e                   	pop    %esi
  802099:	5d                   	pop    %ebp
  80209a:	c3                   	ret    

0080209b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
  80209e:	53                   	push   %ebx
  80209f:	83 ec 14             	sub    $0x14,%esp
  8020a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8020ad:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020b3:	7e 24                	jle    8020d9 <nsipc_send+0x3e>
  8020b5:	c7 44 24 0c 34 31 80 	movl   $0x803134,0xc(%esp)
  8020bc:	00 
  8020bd:	c7 44 24 08 db 30 80 	movl   $0x8030db,0x8(%esp)
  8020c4:	00 
  8020c5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8020cc:	00 
  8020cd:	c7 04 24 28 31 80 00 	movl   $0x803128,(%esp)
  8020d4:	e8 8d 05 00 00       	call   802666 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8020d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8020eb:	e8 94 e8 ff ff       	call   800984 <memmove>
	nsipcbuf.send.req_size = size;
  8020f0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8020f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8020f9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8020fe:	b8 08 00 00 00       	mov    $0x8,%eax
  802103:	e8 7b fd ff ff       	call   801e83 <nsipc>
}
  802108:	83 c4 14             	add    $0x14,%esp
  80210b:	5b                   	pop    %ebx
  80210c:	5d                   	pop    %ebp
  80210d:	c3                   	ret    

0080210e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802114:	8b 45 08             	mov    0x8(%ebp),%eax
  802117:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80211c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802124:	8b 45 10             	mov    0x10(%ebp),%eax
  802127:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80212c:	b8 09 00 00 00       	mov    $0x9,%eax
  802131:	e8 4d fd ff ff       	call   801e83 <nsipc>
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	56                   	push   %esi
  80213c:	53                   	push   %ebx
  80213d:	83 ec 10             	sub    $0x10,%esp
  802140:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	89 04 24             	mov    %eax,(%esp)
  802149:	e8 12 f2 ff ff       	call   801360 <fd2data>
  80214e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802150:	c7 44 24 04 40 31 80 	movl   $0x803140,0x4(%esp)
  802157:	00 
  802158:	89 1c 24             	mov    %ebx,(%esp)
  80215b:	e8 87 e6 ff ff       	call   8007e7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802160:	8b 46 04             	mov    0x4(%esi),%eax
  802163:	2b 06                	sub    (%esi),%eax
  802165:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80216b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802172:	00 00 00 
	stat->st_dev = &devpipe;
  802175:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80217c:	40 80 00 
	return 0;
}
  80217f:	b8 00 00 00 00       	mov    $0x0,%eax
  802184:	83 c4 10             	add    $0x10,%esp
  802187:	5b                   	pop    %ebx
  802188:	5e                   	pop    %esi
  802189:	5d                   	pop    %ebp
  80218a:	c3                   	ret    

0080218b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
  80218e:	53                   	push   %ebx
  80218f:	83 ec 14             	sub    $0x14,%esp
  802192:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802195:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802199:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a0:	e8 05 eb ff ff       	call   800caa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021a5:	89 1c 24             	mov    %ebx,(%esp)
  8021a8:	e8 b3 f1 ff ff       	call   801360 <fd2data>
  8021ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021b8:	e8 ed ea ff ff       	call   800caa <sys_page_unmap>
}
  8021bd:	83 c4 14             	add    $0x14,%esp
  8021c0:	5b                   	pop    %ebx
  8021c1:	5d                   	pop    %ebp
  8021c2:	c3                   	ret    

008021c3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	57                   	push   %edi
  8021c7:	56                   	push   %esi
  8021c8:	53                   	push   %ebx
  8021c9:	83 ec 2c             	sub    $0x2c,%esp
  8021cc:	89 c6                	mov    %eax,%esi
  8021ce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8021d1:	a1 08 50 80 00       	mov    0x805008,%eax
  8021d6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021d9:	89 34 24             	mov    %esi,(%esp)
  8021dc:	e8 be 06 00 00       	call   80289f <pageref>
  8021e1:	89 c7                	mov    %eax,%edi
  8021e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021e6:	89 04 24             	mov    %eax,(%esp)
  8021e9:	e8 b1 06 00 00       	call   80289f <pageref>
  8021ee:	39 c7                	cmp    %eax,%edi
  8021f0:	0f 94 c2             	sete   %dl
  8021f3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8021f6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8021fc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8021ff:	39 fb                	cmp    %edi,%ebx
  802201:	74 21                	je     802224 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802203:	84 d2                	test   %dl,%dl
  802205:	74 ca                	je     8021d1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802207:	8b 51 58             	mov    0x58(%ecx),%edx
  80220a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80220e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802212:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802216:	c7 04 24 47 31 80 00 	movl   $0x803147,(%esp)
  80221d:	e8 a1 df ff ff       	call   8001c3 <cprintf>
  802222:	eb ad                	jmp    8021d1 <_pipeisclosed+0xe>
	}
}
  802224:	83 c4 2c             	add    $0x2c,%esp
  802227:	5b                   	pop    %ebx
  802228:	5e                   	pop    %esi
  802229:	5f                   	pop    %edi
  80222a:	5d                   	pop    %ebp
  80222b:	c3                   	ret    

0080222c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	57                   	push   %edi
  802230:	56                   	push   %esi
  802231:	53                   	push   %ebx
  802232:	83 ec 1c             	sub    $0x1c,%esp
  802235:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802238:	89 34 24             	mov    %esi,(%esp)
  80223b:	e8 20 f1 ff ff       	call   801360 <fd2data>
  802240:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802242:	bf 00 00 00 00       	mov    $0x0,%edi
  802247:	eb 45                	jmp    80228e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802249:	89 da                	mov    %ebx,%edx
  80224b:	89 f0                	mov    %esi,%eax
  80224d:	e8 71 ff ff ff       	call   8021c3 <_pipeisclosed>
  802252:	85 c0                	test   %eax,%eax
  802254:	75 41                	jne    802297 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802256:	e8 89 e9 ff ff       	call   800be4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80225b:	8b 43 04             	mov    0x4(%ebx),%eax
  80225e:	8b 0b                	mov    (%ebx),%ecx
  802260:	8d 51 20             	lea    0x20(%ecx),%edx
  802263:	39 d0                	cmp    %edx,%eax
  802265:	73 e2                	jae    802249 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802267:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80226a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80226e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802271:	99                   	cltd   
  802272:	c1 ea 1b             	shr    $0x1b,%edx
  802275:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802278:	83 e1 1f             	and    $0x1f,%ecx
  80227b:	29 d1                	sub    %edx,%ecx
  80227d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802281:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802285:	83 c0 01             	add    $0x1,%eax
  802288:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80228b:	83 c7 01             	add    $0x1,%edi
  80228e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802291:	75 c8                	jne    80225b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802293:	89 f8                	mov    %edi,%eax
  802295:	eb 05                	jmp    80229c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802297:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80229c:	83 c4 1c             	add    $0x1c,%esp
  80229f:	5b                   	pop    %ebx
  8022a0:	5e                   	pop    %esi
  8022a1:	5f                   	pop    %edi
  8022a2:	5d                   	pop    %ebp
  8022a3:	c3                   	ret    

008022a4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	57                   	push   %edi
  8022a8:	56                   	push   %esi
  8022a9:	53                   	push   %ebx
  8022aa:	83 ec 1c             	sub    $0x1c,%esp
  8022ad:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8022b0:	89 3c 24             	mov    %edi,(%esp)
  8022b3:	e8 a8 f0 ff ff       	call   801360 <fd2data>
  8022b8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022ba:	be 00 00 00 00       	mov    $0x0,%esi
  8022bf:	eb 3d                	jmp    8022fe <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8022c1:	85 f6                	test   %esi,%esi
  8022c3:	74 04                	je     8022c9 <devpipe_read+0x25>
				return i;
  8022c5:	89 f0                	mov    %esi,%eax
  8022c7:	eb 43                	jmp    80230c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8022c9:	89 da                	mov    %ebx,%edx
  8022cb:	89 f8                	mov    %edi,%eax
  8022cd:	e8 f1 fe ff ff       	call   8021c3 <_pipeisclosed>
  8022d2:	85 c0                	test   %eax,%eax
  8022d4:	75 31                	jne    802307 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8022d6:	e8 09 e9 ff ff       	call   800be4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8022db:	8b 03                	mov    (%ebx),%eax
  8022dd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022e0:	74 df                	je     8022c1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8022e2:	99                   	cltd   
  8022e3:	c1 ea 1b             	shr    $0x1b,%edx
  8022e6:	01 d0                	add    %edx,%eax
  8022e8:	83 e0 1f             	and    $0x1f,%eax
  8022eb:	29 d0                	sub    %edx,%eax
  8022ed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022f5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8022f8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022fb:	83 c6 01             	add    $0x1,%esi
  8022fe:	3b 75 10             	cmp    0x10(%ebp),%esi
  802301:	75 d8                	jne    8022db <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802303:	89 f0                	mov    %esi,%eax
  802305:	eb 05                	jmp    80230c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802307:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80230c:	83 c4 1c             	add    $0x1c,%esp
  80230f:	5b                   	pop    %ebx
  802310:	5e                   	pop    %esi
  802311:	5f                   	pop    %edi
  802312:	5d                   	pop    %ebp
  802313:	c3                   	ret    

00802314 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	56                   	push   %esi
  802318:	53                   	push   %ebx
  802319:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80231c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80231f:	89 04 24             	mov    %eax,(%esp)
  802322:	e8 50 f0 ff ff       	call   801377 <fd_alloc>
  802327:	89 c2                	mov    %eax,%edx
  802329:	85 d2                	test   %edx,%edx
  80232b:	0f 88 4d 01 00 00    	js     80247e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802331:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802338:	00 
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802340:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802347:	e8 b7 e8 ff ff       	call   800c03 <sys_page_alloc>
  80234c:	89 c2                	mov    %eax,%edx
  80234e:	85 d2                	test   %edx,%edx
  802350:	0f 88 28 01 00 00    	js     80247e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802356:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802359:	89 04 24             	mov    %eax,(%esp)
  80235c:	e8 16 f0 ff ff       	call   801377 <fd_alloc>
  802361:	89 c3                	mov    %eax,%ebx
  802363:	85 c0                	test   %eax,%eax
  802365:	0f 88 fe 00 00 00    	js     802469 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80236b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802372:	00 
  802373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802376:	89 44 24 04          	mov    %eax,0x4(%esp)
  80237a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802381:	e8 7d e8 ff ff       	call   800c03 <sys_page_alloc>
  802386:	89 c3                	mov    %eax,%ebx
  802388:	85 c0                	test   %eax,%eax
  80238a:	0f 88 d9 00 00 00    	js     802469 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802393:	89 04 24             	mov    %eax,(%esp)
  802396:	e8 c5 ef ff ff       	call   801360 <fd2data>
  80239b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80239d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023a4:	00 
  8023a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023b0:	e8 4e e8 ff ff       	call   800c03 <sys_page_alloc>
  8023b5:	89 c3                	mov    %eax,%ebx
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	0f 88 97 00 00 00    	js     802456 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c2:	89 04 24             	mov    %eax,(%esp)
  8023c5:	e8 96 ef ff ff       	call   801360 <fd2data>
  8023ca:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8023d1:	00 
  8023d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023dd:	00 
  8023de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e9:	e8 69 e8 ff ff       	call   800c57 <sys_page_map>
  8023ee:	89 c3                	mov    %eax,%ebx
  8023f0:	85 c0                	test   %eax,%eax
  8023f2:	78 52                	js     802446 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8023f4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8023ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802402:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802409:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80240f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802412:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802417:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	89 04 24             	mov    %eax,(%esp)
  802424:	e8 27 ef ff ff       	call   801350 <fd2num>
  802429:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80242c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80242e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802431:	89 04 24             	mov    %eax,(%esp)
  802434:	e8 17 ef ff ff       	call   801350 <fd2num>
  802439:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80243c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80243f:	b8 00 00 00 00       	mov    $0x0,%eax
  802444:	eb 38                	jmp    80247e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802446:	89 74 24 04          	mov    %esi,0x4(%esp)
  80244a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802451:	e8 54 e8 ff ff       	call   800caa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802459:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802464:	e8 41 e8 ff ff       	call   800caa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802470:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802477:	e8 2e e8 ff ff       	call   800caa <sys_page_unmap>
  80247c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80247e:	83 c4 30             	add    $0x30,%esp
  802481:	5b                   	pop    %ebx
  802482:	5e                   	pop    %esi
  802483:	5d                   	pop    %ebp
  802484:	c3                   	ret    

00802485 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80248b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80248e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802492:	8b 45 08             	mov    0x8(%ebp),%eax
  802495:	89 04 24             	mov    %eax,(%esp)
  802498:	e8 29 ef ff ff       	call   8013c6 <fd_lookup>
  80249d:	89 c2                	mov    %eax,%edx
  80249f:	85 d2                	test   %edx,%edx
  8024a1:	78 15                	js     8024b8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	89 04 24             	mov    %eax,(%esp)
  8024a9:	e8 b2 ee ff ff       	call   801360 <fd2data>
	return _pipeisclosed(fd, p);
  8024ae:	89 c2                	mov    %eax,%edx
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	e8 0b fd ff ff       	call   8021c3 <_pipeisclosed>
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    
  8024ba:	66 90                	xchg   %ax,%ax
  8024bc:	66 90                	xchg   %ax,%ax
  8024be:	66 90                	xchg   %ax,%ax

008024c0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8024c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c8:	5d                   	pop    %ebp
  8024c9:	c3                   	ret    

008024ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
  8024cd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8024d0:	c7 44 24 04 5f 31 80 	movl   $0x80315f,0x4(%esp)
  8024d7:	00 
  8024d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024db:	89 04 24             	mov    %eax,(%esp)
  8024de:	e8 04 e3 ff ff       	call   8007e7 <strcpy>
	return 0;
}
  8024e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e8:	c9                   	leave  
  8024e9:	c3                   	ret    

008024ea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
  8024ed:	57                   	push   %edi
  8024ee:	56                   	push   %esi
  8024ef:	53                   	push   %ebx
  8024f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8024f6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8024fb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802501:	eb 31                	jmp    802534 <devcons_write+0x4a>
		m = n - tot;
  802503:	8b 75 10             	mov    0x10(%ebp),%esi
  802506:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802508:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80250b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802510:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802513:	89 74 24 08          	mov    %esi,0x8(%esp)
  802517:	03 45 0c             	add    0xc(%ebp),%eax
  80251a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80251e:	89 3c 24             	mov    %edi,(%esp)
  802521:	e8 5e e4 ff ff       	call   800984 <memmove>
		sys_cputs(buf, m);
  802526:	89 74 24 04          	mov    %esi,0x4(%esp)
  80252a:	89 3c 24             	mov    %edi,(%esp)
  80252d:	e8 04 e6 ff ff       	call   800b36 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802532:	01 f3                	add    %esi,%ebx
  802534:	89 d8                	mov    %ebx,%eax
  802536:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802539:	72 c8                	jb     802503 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80253b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802541:	5b                   	pop    %ebx
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    

00802546 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
  802549:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80254c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802551:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802555:	75 07                	jne    80255e <devcons_read+0x18>
  802557:	eb 2a                	jmp    802583 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802559:	e8 86 e6 ff ff       	call   800be4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80255e:	66 90                	xchg   %ax,%ax
  802560:	e8 ef e5 ff ff       	call   800b54 <sys_cgetc>
  802565:	85 c0                	test   %eax,%eax
  802567:	74 f0                	je     802559 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802569:	85 c0                	test   %eax,%eax
  80256b:	78 16                	js     802583 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80256d:	83 f8 04             	cmp    $0x4,%eax
  802570:	74 0c                	je     80257e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802572:	8b 55 0c             	mov    0xc(%ebp),%edx
  802575:	88 02                	mov    %al,(%edx)
	return 1;
  802577:	b8 01 00 00 00       	mov    $0x1,%eax
  80257c:	eb 05                	jmp    802583 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80257e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802583:	c9                   	leave  
  802584:	c3                   	ret    

00802585 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802585:	55                   	push   %ebp
  802586:	89 e5                	mov    %esp,%ebp
  802588:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802591:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802598:	00 
  802599:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80259c:	89 04 24             	mov    %eax,(%esp)
  80259f:	e8 92 e5 ff ff       	call   800b36 <sys_cputs>
}
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <getchar>:

int
getchar(void)
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8025ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8025b3:	00 
  8025b4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c2:	e8 93 f0 ff ff       	call   80165a <read>
	if (r < 0)
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	78 0f                	js     8025da <getchar+0x34>
		return r;
	if (r < 1)
  8025cb:	85 c0                	test   %eax,%eax
  8025cd:	7e 06                	jle    8025d5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8025cf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8025d3:	eb 05                	jmp    8025da <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8025d5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8025da:	c9                   	leave  
  8025db:	c3                   	ret    

008025dc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ec:	89 04 24             	mov    %eax,(%esp)
  8025ef:	e8 d2 ed ff ff       	call   8013c6 <fd_lookup>
  8025f4:	85 c0                	test   %eax,%eax
  8025f6:	78 11                	js     802609 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802601:	39 10                	cmp    %edx,(%eax)
  802603:	0f 94 c0             	sete   %al
  802606:	0f b6 c0             	movzbl %al,%eax
}
  802609:	c9                   	leave  
  80260a:	c3                   	ret    

0080260b <opencons>:

int
opencons(void)
{
  80260b:	55                   	push   %ebp
  80260c:	89 e5                	mov    %esp,%ebp
  80260e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802611:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802614:	89 04 24             	mov    %eax,(%esp)
  802617:	e8 5b ed ff ff       	call   801377 <fd_alloc>
		return r;
  80261c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80261e:	85 c0                	test   %eax,%eax
  802620:	78 40                	js     802662 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802622:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802629:	00 
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802631:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802638:	e8 c6 e5 ff ff       	call   800c03 <sys_page_alloc>
		return r;
  80263d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80263f:	85 c0                	test   %eax,%eax
  802641:	78 1f                	js     802662 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802643:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802658:	89 04 24             	mov    %eax,(%esp)
  80265b:	e8 f0 ec ff ff       	call   801350 <fd2num>
  802660:	89 c2                	mov    %eax,%edx
}
  802662:	89 d0                	mov    %edx,%eax
  802664:	c9                   	leave  
  802665:	c3                   	ret    

00802666 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802666:	55                   	push   %ebp
  802667:	89 e5                	mov    %esp,%ebp
  802669:	56                   	push   %esi
  80266a:	53                   	push   %ebx
  80266b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80266e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802671:	8b 35 00 40 80 00    	mov    0x804000,%esi
  802677:	e8 49 e5 ff ff       	call   800bc5 <sys_getenvid>
  80267c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80267f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802683:	8b 55 08             	mov    0x8(%ebp),%edx
  802686:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80268a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80268e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802692:	c7 04 24 6c 31 80 00 	movl   $0x80316c,(%esp)
  802699:	e8 25 db ff ff       	call   8001c3 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80269e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8026a5:	89 04 24             	mov    %eax,(%esp)
  8026a8:	e8 b5 da ff ff       	call   800162 <vcprintf>
	cprintf("\n");
  8026ad:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  8026b4:	e8 0a db ff ff       	call   8001c3 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8026b9:	cc                   	int3   
  8026ba:	eb fd                	jmp    8026b9 <_panic+0x53>

008026bc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8026bc:	55                   	push   %ebp
  8026bd:	89 e5                	mov    %esp,%ebp
  8026bf:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8026c2:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8026c9:	75 68                	jne    802733 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  8026cb:	a1 08 50 80 00       	mov    0x805008,%eax
  8026d0:	8b 40 48             	mov    0x48(%eax),%eax
  8026d3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8026da:	00 
  8026db:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8026e2:	ee 
  8026e3:	89 04 24             	mov    %eax,(%esp)
  8026e6:	e8 18 e5 ff ff       	call   800c03 <sys_page_alloc>
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	74 2c                	je     80271b <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  8026ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026f3:	c7 04 24 90 31 80 00 	movl   $0x803190,(%esp)
  8026fa:	e8 c4 da ff ff       	call   8001c3 <cprintf>
			panic("set_pg_fault_handler");
  8026ff:	c7 44 24 08 c4 31 80 	movl   $0x8031c4,0x8(%esp)
  802706:	00 
  802707:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  80270e:	00 
  80270f:	c7 04 24 d9 31 80 00 	movl   $0x8031d9,(%esp)
  802716:	e8 4b ff ff ff       	call   802666 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80271b:	a1 08 50 80 00       	mov    0x805008,%eax
  802720:	8b 40 48             	mov    0x48(%eax),%eax
  802723:	c7 44 24 04 3d 27 80 	movl   $0x80273d,0x4(%esp)
  80272a:	00 
  80272b:	89 04 24             	mov    %eax,(%esp)
  80272e:	e8 70 e6 ff ff       	call   800da3 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802733:	8b 45 08             	mov    0x8(%ebp),%eax
  802736:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80273b:	c9                   	leave  
  80273c:	c3                   	ret    

0080273d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80273d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80273e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802743:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802745:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  802748:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  80274c:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  80274e:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  802752:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  802753:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  802756:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  802758:	58                   	pop    %eax
	popl %eax
  802759:	58                   	pop    %eax
	popal
  80275a:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80275b:	83 c4 04             	add    $0x4,%esp
	popfl
  80275e:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80275f:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802760:	c3                   	ret    
  802761:	66 90                	xchg   %ax,%ax
  802763:	66 90                	xchg   %ax,%ax
  802765:	66 90                	xchg   %ax,%ax
  802767:	66 90                	xchg   %ax,%ax
  802769:	66 90                	xchg   %ax,%ax
  80276b:	66 90                	xchg   %ax,%ax
  80276d:	66 90                	xchg   %ax,%ax
  80276f:	90                   	nop

00802770 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
  802773:	56                   	push   %esi
  802774:	53                   	push   %ebx
  802775:	83 ec 10             	sub    $0x10,%esp
  802778:	8b 75 08             	mov    0x8(%ebp),%esi
  80277b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80277e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802781:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802783:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802788:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80278b:	89 04 24             	mov    %eax,(%esp)
  80278e:	e8 86 e6 ff ff       	call   800e19 <sys_ipc_recv>
  802793:	85 c0                	test   %eax,%eax
  802795:	74 16                	je     8027ad <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802797:	85 f6                	test   %esi,%esi
  802799:	74 06                	je     8027a1 <ipc_recv+0x31>
			*from_env_store = 0;
  80279b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8027a1:	85 db                	test   %ebx,%ebx
  8027a3:	74 2c                	je     8027d1 <ipc_recv+0x61>
			*perm_store = 0;
  8027a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8027ab:	eb 24                	jmp    8027d1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8027ad:	85 f6                	test   %esi,%esi
  8027af:	74 0a                	je     8027bb <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8027b1:	a1 08 50 80 00       	mov    0x805008,%eax
  8027b6:	8b 40 74             	mov    0x74(%eax),%eax
  8027b9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8027bb:	85 db                	test   %ebx,%ebx
  8027bd:	74 0a                	je     8027c9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8027bf:	a1 08 50 80 00       	mov    0x805008,%eax
  8027c4:	8b 40 78             	mov    0x78(%eax),%eax
  8027c7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8027c9:	a1 08 50 80 00       	mov    0x805008,%eax
  8027ce:	8b 40 70             	mov    0x70(%eax),%eax
}
  8027d1:	83 c4 10             	add    $0x10,%esp
  8027d4:	5b                   	pop    %ebx
  8027d5:	5e                   	pop    %esi
  8027d6:	5d                   	pop    %ebp
  8027d7:	c3                   	ret    

008027d8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8027d8:	55                   	push   %ebp
  8027d9:	89 e5                	mov    %esp,%ebp
  8027db:	57                   	push   %edi
  8027dc:	56                   	push   %esi
  8027dd:	53                   	push   %ebx
  8027de:	83 ec 1c             	sub    $0x1c,%esp
  8027e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027e7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8027ea:	85 db                	test   %ebx,%ebx
  8027ec:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8027f1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8027f4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802800:	8b 45 08             	mov    0x8(%ebp),%eax
  802803:	89 04 24             	mov    %eax,(%esp)
  802806:	e8 eb e5 ff ff       	call   800df6 <sys_ipc_try_send>
	if (r == 0) return;
  80280b:	85 c0                	test   %eax,%eax
  80280d:	75 22                	jne    802831 <ipc_send+0x59>
  80280f:	eb 4c                	jmp    80285d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802811:	84 d2                	test   %dl,%dl
  802813:	75 48                	jne    80285d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802815:	e8 ca e3 ff ff       	call   800be4 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80281a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80281e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802822:	89 74 24 04          	mov    %esi,0x4(%esp)
  802826:	8b 45 08             	mov    0x8(%ebp),%eax
  802829:	89 04 24             	mov    %eax,(%esp)
  80282c:	e8 c5 e5 ff ff       	call   800df6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802831:	85 c0                	test   %eax,%eax
  802833:	0f 94 c2             	sete   %dl
  802836:	74 d9                	je     802811 <ipc_send+0x39>
  802838:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80283b:	74 d4                	je     802811 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80283d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802841:	c7 44 24 08 e7 31 80 	movl   $0x8031e7,0x8(%esp)
  802848:	00 
  802849:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802850:	00 
  802851:	c7 04 24 f5 31 80 00 	movl   $0x8031f5,(%esp)
  802858:	e8 09 fe ff ff       	call   802666 <_panic>
}
  80285d:	83 c4 1c             	add    $0x1c,%esp
  802860:	5b                   	pop    %ebx
  802861:	5e                   	pop    %esi
  802862:	5f                   	pop    %edi
  802863:	5d                   	pop    %ebp
  802864:	c3                   	ret    

00802865 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802865:	55                   	push   %ebp
  802866:	89 e5                	mov    %esp,%ebp
  802868:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80286b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802870:	89 c2                	mov    %eax,%edx
  802872:	c1 e2 07             	shl    $0x7,%edx
  802875:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80287b:	8b 52 50             	mov    0x50(%edx),%edx
  80287e:	39 ca                	cmp    %ecx,%edx
  802880:	75 0d                	jne    80288f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802882:	c1 e0 07             	shl    $0x7,%eax
  802885:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80288a:	8b 40 40             	mov    0x40(%eax),%eax
  80288d:	eb 0e                	jmp    80289d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80288f:	83 c0 01             	add    $0x1,%eax
  802892:	3d 00 04 00 00       	cmp    $0x400,%eax
  802897:	75 d7                	jne    802870 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802899:	66 b8 00 00          	mov    $0x0,%ax
}
  80289d:	5d                   	pop    %ebp
  80289e:	c3                   	ret    

0080289f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80289f:	55                   	push   %ebp
  8028a0:	89 e5                	mov    %esp,%ebp
  8028a2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028a5:	89 d0                	mov    %edx,%eax
  8028a7:	c1 e8 16             	shr    $0x16,%eax
  8028aa:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028b1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028b6:	f6 c1 01             	test   $0x1,%cl
  8028b9:	74 1d                	je     8028d8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8028bb:	c1 ea 0c             	shr    $0xc,%edx
  8028be:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8028c5:	f6 c2 01             	test   $0x1,%dl
  8028c8:	74 0e                	je     8028d8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8028ca:	c1 ea 0c             	shr    $0xc,%edx
  8028cd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028d4:	ef 
  8028d5:	0f b7 c0             	movzwl %ax,%eax
}
  8028d8:	5d                   	pop    %ebp
  8028d9:	c3                   	ret    
  8028da:	66 90                	xchg   %ax,%ax
  8028dc:	66 90                	xchg   %ax,%ax
  8028de:	66 90                	xchg   %ax,%ax

008028e0 <__udivdi3>:
  8028e0:	55                   	push   %ebp
  8028e1:	57                   	push   %edi
  8028e2:	56                   	push   %esi
  8028e3:	83 ec 0c             	sub    $0xc,%esp
  8028e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8028ea:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8028ee:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8028f2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8028fc:	89 ea                	mov    %ebp,%edx
  8028fe:	89 0c 24             	mov    %ecx,(%esp)
  802901:	75 2d                	jne    802930 <__udivdi3+0x50>
  802903:	39 e9                	cmp    %ebp,%ecx
  802905:	77 61                	ja     802968 <__udivdi3+0x88>
  802907:	85 c9                	test   %ecx,%ecx
  802909:	89 ce                	mov    %ecx,%esi
  80290b:	75 0b                	jne    802918 <__udivdi3+0x38>
  80290d:	b8 01 00 00 00       	mov    $0x1,%eax
  802912:	31 d2                	xor    %edx,%edx
  802914:	f7 f1                	div    %ecx
  802916:	89 c6                	mov    %eax,%esi
  802918:	31 d2                	xor    %edx,%edx
  80291a:	89 e8                	mov    %ebp,%eax
  80291c:	f7 f6                	div    %esi
  80291e:	89 c5                	mov    %eax,%ebp
  802920:	89 f8                	mov    %edi,%eax
  802922:	f7 f6                	div    %esi
  802924:	89 ea                	mov    %ebp,%edx
  802926:	83 c4 0c             	add    $0xc,%esp
  802929:	5e                   	pop    %esi
  80292a:	5f                   	pop    %edi
  80292b:	5d                   	pop    %ebp
  80292c:	c3                   	ret    
  80292d:	8d 76 00             	lea    0x0(%esi),%esi
  802930:	39 e8                	cmp    %ebp,%eax
  802932:	77 24                	ja     802958 <__udivdi3+0x78>
  802934:	0f bd e8             	bsr    %eax,%ebp
  802937:	83 f5 1f             	xor    $0x1f,%ebp
  80293a:	75 3c                	jne    802978 <__udivdi3+0x98>
  80293c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802940:	39 34 24             	cmp    %esi,(%esp)
  802943:	0f 86 9f 00 00 00    	jbe    8029e8 <__udivdi3+0x108>
  802949:	39 d0                	cmp    %edx,%eax
  80294b:	0f 82 97 00 00 00    	jb     8029e8 <__udivdi3+0x108>
  802951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802958:	31 d2                	xor    %edx,%edx
  80295a:	31 c0                	xor    %eax,%eax
  80295c:	83 c4 0c             	add    $0xc,%esp
  80295f:	5e                   	pop    %esi
  802960:	5f                   	pop    %edi
  802961:	5d                   	pop    %ebp
  802962:	c3                   	ret    
  802963:	90                   	nop
  802964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802968:	89 f8                	mov    %edi,%eax
  80296a:	f7 f1                	div    %ecx
  80296c:	31 d2                	xor    %edx,%edx
  80296e:	83 c4 0c             	add    $0xc,%esp
  802971:	5e                   	pop    %esi
  802972:	5f                   	pop    %edi
  802973:	5d                   	pop    %ebp
  802974:	c3                   	ret    
  802975:	8d 76 00             	lea    0x0(%esi),%esi
  802978:	89 e9                	mov    %ebp,%ecx
  80297a:	8b 3c 24             	mov    (%esp),%edi
  80297d:	d3 e0                	shl    %cl,%eax
  80297f:	89 c6                	mov    %eax,%esi
  802981:	b8 20 00 00 00       	mov    $0x20,%eax
  802986:	29 e8                	sub    %ebp,%eax
  802988:	89 c1                	mov    %eax,%ecx
  80298a:	d3 ef                	shr    %cl,%edi
  80298c:	89 e9                	mov    %ebp,%ecx
  80298e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802992:	8b 3c 24             	mov    (%esp),%edi
  802995:	09 74 24 08          	or     %esi,0x8(%esp)
  802999:	89 d6                	mov    %edx,%esi
  80299b:	d3 e7                	shl    %cl,%edi
  80299d:	89 c1                	mov    %eax,%ecx
  80299f:	89 3c 24             	mov    %edi,(%esp)
  8029a2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8029a6:	d3 ee                	shr    %cl,%esi
  8029a8:	89 e9                	mov    %ebp,%ecx
  8029aa:	d3 e2                	shl    %cl,%edx
  8029ac:	89 c1                	mov    %eax,%ecx
  8029ae:	d3 ef                	shr    %cl,%edi
  8029b0:	09 d7                	or     %edx,%edi
  8029b2:	89 f2                	mov    %esi,%edx
  8029b4:	89 f8                	mov    %edi,%eax
  8029b6:	f7 74 24 08          	divl   0x8(%esp)
  8029ba:	89 d6                	mov    %edx,%esi
  8029bc:	89 c7                	mov    %eax,%edi
  8029be:	f7 24 24             	mull   (%esp)
  8029c1:	39 d6                	cmp    %edx,%esi
  8029c3:	89 14 24             	mov    %edx,(%esp)
  8029c6:	72 30                	jb     8029f8 <__udivdi3+0x118>
  8029c8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029cc:	89 e9                	mov    %ebp,%ecx
  8029ce:	d3 e2                	shl    %cl,%edx
  8029d0:	39 c2                	cmp    %eax,%edx
  8029d2:	73 05                	jae    8029d9 <__udivdi3+0xf9>
  8029d4:	3b 34 24             	cmp    (%esp),%esi
  8029d7:	74 1f                	je     8029f8 <__udivdi3+0x118>
  8029d9:	89 f8                	mov    %edi,%eax
  8029db:	31 d2                	xor    %edx,%edx
  8029dd:	e9 7a ff ff ff       	jmp    80295c <__udivdi3+0x7c>
  8029e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029e8:	31 d2                	xor    %edx,%edx
  8029ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ef:	e9 68 ff ff ff       	jmp    80295c <__udivdi3+0x7c>
  8029f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8029fb:	31 d2                	xor    %edx,%edx
  8029fd:	83 c4 0c             	add    $0xc,%esp
  802a00:	5e                   	pop    %esi
  802a01:	5f                   	pop    %edi
  802a02:	5d                   	pop    %ebp
  802a03:	c3                   	ret    
  802a04:	66 90                	xchg   %ax,%ax
  802a06:	66 90                	xchg   %ax,%ax
  802a08:	66 90                	xchg   %ax,%ax
  802a0a:	66 90                	xchg   %ax,%ax
  802a0c:	66 90                	xchg   %ax,%ax
  802a0e:	66 90                	xchg   %ax,%ax

00802a10 <__umoddi3>:
  802a10:	55                   	push   %ebp
  802a11:	57                   	push   %edi
  802a12:	56                   	push   %esi
  802a13:	83 ec 14             	sub    $0x14,%esp
  802a16:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a1a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a1e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802a22:	89 c7                	mov    %eax,%edi
  802a24:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a28:	8b 44 24 30          	mov    0x30(%esp),%eax
  802a2c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802a30:	89 34 24             	mov    %esi,(%esp)
  802a33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a37:	85 c0                	test   %eax,%eax
  802a39:	89 c2                	mov    %eax,%edx
  802a3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a3f:	75 17                	jne    802a58 <__umoddi3+0x48>
  802a41:	39 fe                	cmp    %edi,%esi
  802a43:	76 4b                	jbe    802a90 <__umoddi3+0x80>
  802a45:	89 c8                	mov    %ecx,%eax
  802a47:	89 fa                	mov    %edi,%edx
  802a49:	f7 f6                	div    %esi
  802a4b:	89 d0                	mov    %edx,%eax
  802a4d:	31 d2                	xor    %edx,%edx
  802a4f:	83 c4 14             	add    $0x14,%esp
  802a52:	5e                   	pop    %esi
  802a53:	5f                   	pop    %edi
  802a54:	5d                   	pop    %ebp
  802a55:	c3                   	ret    
  802a56:	66 90                	xchg   %ax,%ax
  802a58:	39 f8                	cmp    %edi,%eax
  802a5a:	77 54                	ja     802ab0 <__umoddi3+0xa0>
  802a5c:	0f bd e8             	bsr    %eax,%ebp
  802a5f:	83 f5 1f             	xor    $0x1f,%ebp
  802a62:	75 5c                	jne    802ac0 <__umoddi3+0xb0>
  802a64:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802a68:	39 3c 24             	cmp    %edi,(%esp)
  802a6b:	0f 87 e7 00 00 00    	ja     802b58 <__umoddi3+0x148>
  802a71:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a75:	29 f1                	sub    %esi,%ecx
  802a77:	19 c7                	sbb    %eax,%edi
  802a79:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a7d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a81:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a85:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802a89:	83 c4 14             	add    $0x14,%esp
  802a8c:	5e                   	pop    %esi
  802a8d:	5f                   	pop    %edi
  802a8e:	5d                   	pop    %ebp
  802a8f:	c3                   	ret    
  802a90:	85 f6                	test   %esi,%esi
  802a92:	89 f5                	mov    %esi,%ebp
  802a94:	75 0b                	jne    802aa1 <__umoddi3+0x91>
  802a96:	b8 01 00 00 00       	mov    $0x1,%eax
  802a9b:	31 d2                	xor    %edx,%edx
  802a9d:	f7 f6                	div    %esi
  802a9f:	89 c5                	mov    %eax,%ebp
  802aa1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802aa5:	31 d2                	xor    %edx,%edx
  802aa7:	f7 f5                	div    %ebp
  802aa9:	89 c8                	mov    %ecx,%eax
  802aab:	f7 f5                	div    %ebp
  802aad:	eb 9c                	jmp    802a4b <__umoddi3+0x3b>
  802aaf:	90                   	nop
  802ab0:	89 c8                	mov    %ecx,%eax
  802ab2:	89 fa                	mov    %edi,%edx
  802ab4:	83 c4 14             	add    $0x14,%esp
  802ab7:	5e                   	pop    %esi
  802ab8:	5f                   	pop    %edi
  802ab9:	5d                   	pop    %ebp
  802aba:	c3                   	ret    
  802abb:	90                   	nop
  802abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ac0:	8b 04 24             	mov    (%esp),%eax
  802ac3:	be 20 00 00 00       	mov    $0x20,%esi
  802ac8:	89 e9                	mov    %ebp,%ecx
  802aca:	29 ee                	sub    %ebp,%esi
  802acc:	d3 e2                	shl    %cl,%edx
  802ace:	89 f1                	mov    %esi,%ecx
  802ad0:	d3 e8                	shr    %cl,%eax
  802ad2:	89 e9                	mov    %ebp,%ecx
  802ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ad8:	8b 04 24             	mov    (%esp),%eax
  802adb:	09 54 24 04          	or     %edx,0x4(%esp)
  802adf:	89 fa                	mov    %edi,%edx
  802ae1:	d3 e0                	shl    %cl,%eax
  802ae3:	89 f1                	mov    %esi,%ecx
  802ae5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ae9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802aed:	d3 ea                	shr    %cl,%edx
  802aef:	89 e9                	mov    %ebp,%ecx
  802af1:	d3 e7                	shl    %cl,%edi
  802af3:	89 f1                	mov    %esi,%ecx
  802af5:	d3 e8                	shr    %cl,%eax
  802af7:	89 e9                	mov    %ebp,%ecx
  802af9:	09 f8                	or     %edi,%eax
  802afb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802aff:	f7 74 24 04          	divl   0x4(%esp)
  802b03:	d3 e7                	shl    %cl,%edi
  802b05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b09:	89 d7                	mov    %edx,%edi
  802b0b:	f7 64 24 08          	mull   0x8(%esp)
  802b0f:	39 d7                	cmp    %edx,%edi
  802b11:	89 c1                	mov    %eax,%ecx
  802b13:	89 14 24             	mov    %edx,(%esp)
  802b16:	72 2c                	jb     802b44 <__umoddi3+0x134>
  802b18:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802b1c:	72 22                	jb     802b40 <__umoddi3+0x130>
  802b1e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802b22:	29 c8                	sub    %ecx,%eax
  802b24:	19 d7                	sbb    %edx,%edi
  802b26:	89 e9                	mov    %ebp,%ecx
  802b28:	89 fa                	mov    %edi,%edx
  802b2a:	d3 e8                	shr    %cl,%eax
  802b2c:	89 f1                	mov    %esi,%ecx
  802b2e:	d3 e2                	shl    %cl,%edx
  802b30:	89 e9                	mov    %ebp,%ecx
  802b32:	d3 ef                	shr    %cl,%edi
  802b34:	09 d0                	or     %edx,%eax
  802b36:	89 fa                	mov    %edi,%edx
  802b38:	83 c4 14             	add    $0x14,%esp
  802b3b:	5e                   	pop    %esi
  802b3c:	5f                   	pop    %edi
  802b3d:	5d                   	pop    %ebp
  802b3e:	c3                   	ret    
  802b3f:	90                   	nop
  802b40:	39 d7                	cmp    %edx,%edi
  802b42:	75 da                	jne    802b1e <__umoddi3+0x10e>
  802b44:	8b 14 24             	mov    (%esp),%edx
  802b47:	89 c1                	mov    %eax,%ecx
  802b49:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802b4d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802b51:	eb cb                	jmp    802b1e <__umoddi3+0x10e>
  802b53:	90                   	nop
  802b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b58:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802b5c:	0f 82 0f ff ff ff    	jb     802a71 <__umoddi3+0x61>
  802b62:	e9 1a ff ff ff       	jmp    802a81 <__umoddi3+0x71>
