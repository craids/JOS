
obj/user/spawnfaultio.debug:     file format elf32-i386


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
  80002c:	e8 62 00 00 00       	call   800093 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	int r;
	cprintf("i am parent environment %08x\n", thisenv->env_id);
  800039:	a1 08 50 80 00       	mov    0x805008,%eax
  80003e:	8b 40 48             	mov    0x48(%eax),%eax
  800041:	89 44 24 04          	mov    %eax,0x4(%esp)
  800045:	c7 04 24 a0 30 80 00 	movl   $0x8030a0,(%esp)
  80004c:	e8 9c 01 00 00       	call   8001ed <cprintf>
	if ((r = spawnl("faultio", "faultio", 0)) < 0)
  800051:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800058:	00 
  800059:	c7 44 24 04 be 30 80 	movl   $0x8030be,0x4(%esp)
  800060:	00 
  800061:	c7 04 24 be 30 80 00 	movl   $0x8030be,(%esp)
  800068:	e8 96 1d 00 00       	call   801e03 <spawnl>
  80006d:	85 c0                	test   %eax,%eax
  80006f:	79 20                	jns    800091 <umain+0x5e>
		panic("spawn(faultio) failed: %e", r);
  800071:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800075:	c7 44 24 08 c6 30 80 	movl   $0x8030c6,0x8(%esp)
  80007c:	00 
  80007d:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800084:	00 
  800085:	c7 04 24 e0 30 80 00 	movl   $0x8030e0,(%esp)
  80008c:	e8 63 00 00 00       	call   8000f4 <_panic>
}
  800091:	c9                   	leave  
  800092:	c3                   	ret    

00800093 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800093:	55                   	push   %ebp
  800094:	89 e5                	mov    %esp,%ebp
  800096:	56                   	push   %esi
  800097:	53                   	push   %ebx
  800098:	83 ec 10             	sub    $0x10,%esp
  80009b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80009e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000a1:	e8 4f 0b 00 00       	call   800bf5 <sys_getenvid>
  8000a6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ab:	c1 e0 07             	shl    $0x7,%eax
  8000ae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000b3:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b8:	85 db                	test   %ebx,%ebx
  8000ba:	7e 07                	jle    8000c3 <libmain+0x30>
		binaryname = argv[0];
  8000bc:	8b 06                	mov    (%esi),%eax
  8000be:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8000c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000c7:	89 1c 24             	mov    %ebx,(%esp)
  8000ca:	e8 64 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000cf:	e8 07 00 00 00       	call   8000db <exit>
}
  8000d4:	83 c4 10             	add    $0x10,%esp
  8000d7:	5b                   	pop    %ebx
  8000d8:	5e                   	pop    %esi
  8000d9:	5d                   	pop    %ebp
  8000da:	c3                   	ret    

008000db <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000e1:	e8 74 10 00 00       	call   80115a <close_all>
	sys_env_destroy(0);
  8000e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ed:	e8 b1 0a 00 00       	call   800ba3 <sys_env_destroy>
}
  8000f2:	c9                   	leave  
  8000f3:	c3                   	ret    

008000f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8000fc:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8000ff:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800105:	e8 eb 0a 00 00       	call   800bf5 <sys_getenvid>
  80010a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80010d:	89 54 24 10          	mov    %edx,0x10(%esp)
  800111:	8b 55 08             	mov    0x8(%ebp),%edx
  800114:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800118:	89 74 24 08          	mov    %esi,0x8(%esp)
  80011c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800120:	c7 04 24 00 31 80 00 	movl   $0x803100,(%esp)
  800127:	e8 c1 00 00 00       	call   8001ed <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80012c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800130:	8b 45 10             	mov    0x10(%ebp),%eax
  800133:	89 04 24             	mov    %eax,(%esp)
  800136:	e8 51 00 00 00       	call   80018c <vcprintf>
	cprintf("\n");
  80013b:	c7 04 24 31 36 80 00 	movl   $0x803631,(%esp)
  800142:	e8 a6 00 00 00       	call   8001ed <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800147:	cc                   	int3   
  800148:	eb fd                	jmp    800147 <_panic+0x53>

0080014a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	53                   	push   %ebx
  80014e:	83 ec 14             	sub    $0x14,%esp
  800151:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800154:	8b 13                	mov    (%ebx),%edx
  800156:	8d 42 01             	lea    0x1(%edx),%eax
  800159:	89 03                	mov    %eax,(%ebx)
  80015b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800162:	3d ff 00 00 00       	cmp    $0xff,%eax
  800167:	75 19                	jne    800182 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800169:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800170:	00 
  800171:	8d 43 08             	lea    0x8(%ebx),%eax
  800174:	89 04 24             	mov    %eax,(%esp)
  800177:	e8 ea 09 00 00       	call   800b66 <sys_cputs>
		b->idx = 0;
  80017c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800182:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800186:	83 c4 14             	add    $0x14,%esp
  800189:	5b                   	pop    %ebx
  80018a:	5d                   	pop    %ebp
  80018b:	c3                   	ret    

0080018c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800195:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80019c:	00 00 00 
	b.cnt = 0;
  80019f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001b7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001c1:	c7 04 24 4a 01 80 00 	movl   $0x80014a,(%esp)
  8001c8:	e8 b1 01 00 00       	call   80037e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001cd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001dd:	89 04 24             	mov    %eax,(%esp)
  8001e0:	e8 81 09 00 00       	call   800b66 <sys_cputs>

	return b.cnt;
}
  8001e5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001eb:	c9                   	leave  
  8001ec:	c3                   	ret    

008001ed <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fd:	89 04 24             	mov    %eax,(%esp)
  800200:	e8 87 ff ff ff       	call   80018c <vcprintf>
	va_end(ap);

	return cnt;
}
  800205:	c9                   	leave  
  800206:	c3                   	ret    
  800207:	66 90                	xchg   %ax,%ax
  800209:	66 90                	xchg   %ax,%ax
  80020b:	66 90                	xchg   %ax,%ax
  80020d:	66 90                	xchg   %ax,%ax
  80020f:	90                   	nop

00800210 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	57                   	push   %edi
  800214:	56                   	push   %esi
  800215:	53                   	push   %ebx
  800216:	83 ec 3c             	sub    $0x3c,%esp
  800219:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80021c:	89 d7                	mov    %edx,%edi
  80021e:	8b 45 08             	mov    0x8(%ebp),%eax
  800221:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800224:	8b 45 0c             	mov    0xc(%ebp),%eax
  800227:	89 c3                	mov    %eax,%ebx
  800229:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80022c:	8b 45 10             	mov    0x10(%ebp),%eax
  80022f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800232:	b9 00 00 00 00       	mov    $0x0,%ecx
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80023a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80023d:	39 d9                	cmp    %ebx,%ecx
  80023f:	72 05                	jb     800246 <printnum+0x36>
  800241:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800244:	77 69                	ja     8002af <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800246:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800249:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80024d:	83 ee 01             	sub    $0x1,%esi
  800250:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800254:	89 44 24 08          	mov    %eax,0x8(%esp)
  800258:	8b 44 24 08          	mov    0x8(%esp),%eax
  80025c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800260:	89 c3                	mov    %eax,%ebx
  800262:	89 d6                	mov    %edx,%esi
  800264:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800267:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80026a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80026e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800272:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800275:	89 04 24             	mov    %eax,(%esp)
  800278:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80027b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027f:	e8 8c 2b 00 00       	call   802e10 <__udivdi3>
  800284:	89 d9                	mov    %ebx,%ecx
  800286:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80028a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80028e:	89 04 24             	mov    %eax,(%esp)
  800291:	89 54 24 04          	mov    %edx,0x4(%esp)
  800295:	89 fa                	mov    %edi,%edx
  800297:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80029a:	e8 71 ff ff ff       	call   800210 <printnum>
  80029f:	eb 1b                	jmp    8002bc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002a1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002a5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002a8:	89 04 24             	mov    %eax,(%esp)
  8002ab:	ff d3                	call   *%ebx
  8002ad:	eb 03                	jmp    8002b2 <printnum+0xa2>
  8002af:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002b2:	83 ee 01             	sub    $0x1,%esi
  8002b5:	85 f6                	test   %esi,%esi
  8002b7:	7f e8                	jg     8002a1 <printnum+0x91>
  8002b9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002c0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ce:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d5:	89 04 24             	mov    %eax,(%esp)
  8002d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002df:	e8 5c 2c 00 00       	call   802f40 <__umoddi3>
  8002e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002e8:	0f be 80 23 31 80 00 	movsbl 0x803123(%eax),%eax
  8002ef:	89 04 24             	mov    %eax,(%esp)
  8002f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002f5:	ff d0                	call   *%eax
}
  8002f7:	83 c4 3c             	add    $0x3c,%esp
  8002fa:	5b                   	pop    %ebx
  8002fb:	5e                   	pop    %esi
  8002fc:	5f                   	pop    %edi
  8002fd:	5d                   	pop    %ebp
  8002fe:	c3                   	ret    

008002ff <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800302:	83 fa 01             	cmp    $0x1,%edx
  800305:	7e 0e                	jle    800315 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800307:	8b 10                	mov    (%eax),%edx
  800309:	8d 4a 08             	lea    0x8(%edx),%ecx
  80030c:	89 08                	mov    %ecx,(%eax)
  80030e:	8b 02                	mov    (%edx),%eax
  800310:	8b 52 04             	mov    0x4(%edx),%edx
  800313:	eb 22                	jmp    800337 <getuint+0x38>
	else if (lflag)
  800315:	85 d2                	test   %edx,%edx
  800317:	74 10                	je     800329 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800319:	8b 10                	mov    (%eax),%edx
  80031b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80031e:	89 08                	mov    %ecx,(%eax)
  800320:	8b 02                	mov    (%edx),%eax
  800322:	ba 00 00 00 00       	mov    $0x0,%edx
  800327:	eb 0e                	jmp    800337 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800329:	8b 10                	mov    (%eax),%edx
  80032b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80032e:	89 08                	mov    %ecx,(%eax)
  800330:	8b 02                	mov    (%edx),%eax
  800332:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800337:	5d                   	pop    %ebp
  800338:	c3                   	ret    

00800339 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80033f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800343:	8b 10                	mov    (%eax),%edx
  800345:	3b 50 04             	cmp    0x4(%eax),%edx
  800348:	73 0a                	jae    800354 <sprintputch+0x1b>
		*b->buf++ = ch;
  80034a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80034d:	89 08                	mov    %ecx,(%eax)
  80034f:	8b 45 08             	mov    0x8(%ebp),%eax
  800352:	88 02                	mov    %al,(%edx)
}
  800354:	5d                   	pop    %ebp
  800355:	c3                   	ret    

00800356 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80035c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80035f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800363:	8b 45 10             	mov    0x10(%ebp),%eax
  800366:	89 44 24 08          	mov    %eax,0x8(%esp)
  80036a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800371:	8b 45 08             	mov    0x8(%ebp),%eax
  800374:	89 04 24             	mov    %eax,(%esp)
  800377:	e8 02 00 00 00       	call   80037e <vprintfmt>
	va_end(ap);
}
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	57                   	push   %edi
  800382:	56                   	push   %esi
  800383:	53                   	push   %ebx
  800384:	83 ec 3c             	sub    $0x3c,%esp
  800387:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80038a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80038d:	eb 14                	jmp    8003a3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80038f:	85 c0                	test   %eax,%eax
  800391:	0f 84 b3 03 00 00    	je     80074a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800397:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80039b:	89 04 24             	mov    %eax,(%esp)
  80039e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003a1:	89 f3                	mov    %esi,%ebx
  8003a3:	8d 73 01             	lea    0x1(%ebx),%esi
  8003a6:	0f b6 03             	movzbl (%ebx),%eax
  8003a9:	83 f8 25             	cmp    $0x25,%eax
  8003ac:	75 e1                	jne    80038f <vprintfmt+0x11>
  8003ae:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8003b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003b9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8003c0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8003c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003cc:	eb 1d                	jmp    8003eb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ce:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003d0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8003d4:	eb 15                	jmp    8003eb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003d8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8003dc:	eb 0d                	jmp    8003eb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003e4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003eb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8003ee:	0f b6 0e             	movzbl (%esi),%ecx
  8003f1:	0f b6 c1             	movzbl %cl,%eax
  8003f4:	83 e9 23             	sub    $0x23,%ecx
  8003f7:	80 f9 55             	cmp    $0x55,%cl
  8003fa:	0f 87 2a 03 00 00    	ja     80072a <vprintfmt+0x3ac>
  800400:	0f b6 c9             	movzbl %cl,%ecx
  800403:	ff 24 8d 60 32 80 00 	jmp    *0x803260(,%ecx,4)
  80040a:	89 de                	mov    %ebx,%esi
  80040c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800411:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800414:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800418:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80041b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80041e:	83 fb 09             	cmp    $0x9,%ebx
  800421:	77 36                	ja     800459 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800423:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800426:	eb e9                	jmp    800411 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800428:	8b 45 14             	mov    0x14(%ebp),%eax
  80042b:	8d 48 04             	lea    0x4(%eax),%ecx
  80042e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800431:	8b 00                	mov    (%eax),%eax
  800433:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800436:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800438:	eb 22                	jmp    80045c <vprintfmt+0xde>
  80043a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80043d:	85 c9                	test   %ecx,%ecx
  80043f:	b8 00 00 00 00       	mov    $0x0,%eax
  800444:	0f 49 c1             	cmovns %ecx,%eax
  800447:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044a:	89 de                	mov    %ebx,%esi
  80044c:	eb 9d                	jmp    8003eb <vprintfmt+0x6d>
  80044e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800450:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800457:	eb 92                	jmp    8003eb <vprintfmt+0x6d>
  800459:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80045c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800460:	79 89                	jns    8003eb <vprintfmt+0x6d>
  800462:	e9 77 ff ff ff       	jmp    8003de <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800467:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80046c:	e9 7a ff ff ff       	jmp    8003eb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800471:	8b 45 14             	mov    0x14(%ebp),%eax
  800474:	8d 50 04             	lea    0x4(%eax),%edx
  800477:	89 55 14             	mov    %edx,0x14(%ebp)
  80047a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	89 04 24             	mov    %eax,(%esp)
  800483:	ff 55 08             	call   *0x8(%ebp)
			break;
  800486:	e9 18 ff ff ff       	jmp    8003a3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80048b:	8b 45 14             	mov    0x14(%ebp),%eax
  80048e:	8d 50 04             	lea    0x4(%eax),%edx
  800491:	89 55 14             	mov    %edx,0x14(%ebp)
  800494:	8b 00                	mov    (%eax),%eax
  800496:	99                   	cltd   
  800497:	31 d0                	xor    %edx,%eax
  800499:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80049b:	83 f8 11             	cmp    $0x11,%eax
  80049e:	7f 0b                	jg     8004ab <vprintfmt+0x12d>
  8004a0:	8b 14 85 c0 33 80 00 	mov    0x8033c0(,%eax,4),%edx
  8004a7:	85 d2                	test   %edx,%edx
  8004a9:	75 20                	jne    8004cb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8004ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004af:	c7 44 24 08 3b 31 80 	movl   $0x80313b,0x8(%esp)
  8004b6:	00 
  8004b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	89 04 24             	mov    %eax,(%esp)
  8004c1:	e8 90 fe ff ff       	call   800356 <printfmt>
  8004c6:	e9 d8 fe ff ff       	jmp    8003a3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8004cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004cf:	c7 44 24 08 fd 34 80 	movl   $0x8034fd,0x8(%esp)
  8004d6:	00 
  8004d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004db:	8b 45 08             	mov    0x8(%ebp),%eax
  8004de:	89 04 24             	mov    %eax,(%esp)
  8004e1:	e8 70 fe ff ff       	call   800356 <printfmt>
  8004e6:	e9 b8 fe ff ff       	jmp    8003a3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004eb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f7:	8d 50 04             	lea    0x4(%eax),%edx
  8004fa:	89 55 14             	mov    %edx,0x14(%ebp)
  8004fd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8004ff:	85 f6                	test   %esi,%esi
  800501:	b8 34 31 80 00       	mov    $0x803134,%eax
  800506:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800509:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80050d:	0f 84 97 00 00 00    	je     8005aa <vprintfmt+0x22c>
  800513:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800517:	0f 8e 9b 00 00 00    	jle    8005b8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80051d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800521:	89 34 24             	mov    %esi,(%esp)
  800524:	e8 cf 02 00 00       	call   8007f8 <strnlen>
  800529:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80052c:	29 c2                	sub    %eax,%edx
  80052e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800531:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800535:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800538:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80053b:	8b 75 08             	mov    0x8(%ebp),%esi
  80053e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800541:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800543:	eb 0f                	jmp    800554 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800545:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800549:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054c:	89 04 24             	mov    %eax,(%esp)
  80054f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800551:	83 eb 01             	sub    $0x1,%ebx
  800554:	85 db                	test   %ebx,%ebx
  800556:	7f ed                	jg     800545 <vprintfmt+0x1c7>
  800558:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80055b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80055e:	85 d2                	test   %edx,%edx
  800560:	b8 00 00 00 00       	mov    $0x0,%eax
  800565:	0f 49 c2             	cmovns %edx,%eax
  800568:	29 c2                	sub    %eax,%edx
  80056a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80056d:	89 d7                	mov    %edx,%edi
  80056f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800572:	eb 50                	jmp    8005c4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800574:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800578:	74 1e                	je     800598 <vprintfmt+0x21a>
  80057a:	0f be d2             	movsbl %dl,%edx
  80057d:	83 ea 20             	sub    $0x20,%edx
  800580:	83 fa 5e             	cmp    $0x5e,%edx
  800583:	76 13                	jbe    800598 <vprintfmt+0x21a>
					putch('?', putdat);
  800585:	8b 45 0c             	mov    0xc(%ebp),%eax
  800588:	89 44 24 04          	mov    %eax,0x4(%esp)
  80058c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800593:	ff 55 08             	call   *0x8(%ebp)
  800596:	eb 0d                	jmp    8005a5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800598:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80059f:	89 04 24             	mov    %eax,(%esp)
  8005a2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005a5:	83 ef 01             	sub    $0x1,%edi
  8005a8:	eb 1a                	jmp    8005c4 <vprintfmt+0x246>
  8005aa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005ad:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005b0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005b3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005b6:	eb 0c                	jmp    8005c4 <vprintfmt+0x246>
  8005b8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005bb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005c1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005c4:	83 c6 01             	add    $0x1,%esi
  8005c7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8005cb:	0f be c2             	movsbl %dl,%eax
  8005ce:	85 c0                	test   %eax,%eax
  8005d0:	74 27                	je     8005f9 <vprintfmt+0x27b>
  8005d2:	85 db                	test   %ebx,%ebx
  8005d4:	78 9e                	js     800574 <vprintfmt+0x1f6>
  8005d6:	83 eb 01             	sub    $0x1,%ebx
  8005d9:	79 99                	jns    800574 <vprintfmt+0x1f6>
  8005db:	89 f8                	mov    %edi,%eax
  8005dd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e3:	89 c3                	mov    %eax,%ebx
  8005e5:	eb 1a                	jmp    800601 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005eb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005f2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005f4:	83 eb 01             	sub    $0x1,%ebx
  8005f7:	eb 08                	jmp    800601 <vprintfmt+0x283>
  8005f9:	89 fb                	mov    %edi,%ebx
  8005fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005fe:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800601:	85 db                	test   %ebx,%ebx
  800603:	7f e2                	jg     8005e7 <vprintfmt+0x269>
  800605:	89 75 08             	mov    %esi,0x8(%ebp)
  800608:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80060b:	e9 93 fd ff ff       	jmp    8003a3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800610:	83 fa 01             	cmp    $0x1,%edx
  800613:	7e 16                	jle    80062b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8d 50 08             	lea    0x8(%eax),%edx
  80061b:	89 55 14             	mov    %edx,0x14(%ebp)
  80061e:	8b 50 04             	mov    0x4(%eax),%edx
  800621:	8b 00                	mov    (%eax),%eax
  800623:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800626:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800629:	eb 32                	jmp    80065d <vprintfmt+0x2df>
	else if (lflag)
  80062b:	85 d2                	test   %edx,%edx
  80062d:	74 18                	je     800647 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	8d 50 04             	lea    0x4(%eax),%edx
  800635:	89 55 14             	mov    %edx,0x14(%ebp)
  800638:	8b 30                	mov    (%eax),%esi
  80063a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80063d:	89 f0                	mov    %esi,%eax
  80063f:	c1 f8 1f             	sar    $0x1f,%eax
  800642:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800645:	eb 16                	jmp    80065d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8d 50 04             	lea    0x4(%eax),%edx
  80064d:	89 55 14             	mov    %edx,0x14(%ebp)
  800650:	8b 30                	mov    (%eax),%esi
  800652:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800655:	89 f0                	mov    %esi,%eax
  800657:	c1 f8 1f             	sar    $0x1f,%eax
  80065a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80065d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800660:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800663:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800668:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80066c:	0f 89 80 00 00 00    	jns    8006f2 <vprintfmt+0x374>
				putch('-', putdat);
  800672:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800676:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80067d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800680:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800683:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800686:	f7 d8                	neg    %eax
  800688:	83 d2 00             	adc    $0x0,%edx
  80068b:	f7 da                	neg    %edx
			}
			base = 10;
  80068d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800692:	eb 5e                	jmp    8006f2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800694:	8d 45 14             	lea    0x14(%ebp),%eax
  800697:	e8 63 fc ff ff       	call   8002ff <getuint>
			base = 10;
  80069c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006a1:	eb 4f                	jmp    8006f2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a6:	e8 54 fc ff ff       	call   8002ff <getuint>
			base = 8;
  8006ab:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006b0:	eb 40                	jmp    8006f2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  8006b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006b6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006bd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006cb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8d 50 04             	lea    0x4(%eax),%edx
  8006d4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006de:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006e3:	eb 0d                	jmp    8006f2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006e5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e8:	e8 12 fc ff ff       	call   8002ff <getuint>
			base = 16;
  8006ed:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006f2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8006f6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8006fa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8006fd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800701:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800705:	89 04 24             	mov    %eax,(%esp)
  800708:	89 54 24 04          	mov    %edx,0x4(%esp)
  80070c:	89 fa                	mov    %edi,%edx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	e8 fa fa ff ff       	call   800210 <printnum>
			break;
  800716:	e9 88 fc ff ff       	jmp    8003a3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80071b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80071f:	89 04 24             	mov    %eax,(%esp)
  800722:	ff 55 08             	call   *0x8(%ebp)
			break;
  800725:	e9 79 fc ff ff       	jmp    8003a3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80072a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80072e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800735:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800738:	89 f3                	mov    %esi,%ebx
  80073a:	eb 03                	jmp    80073f <vprintfmt+0x3c1>
  80073c:	83 eb 01             	sub    $0x1,%ebx
  80073f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800743:	75 f7                	jne    80073c <vprintfmt+0x3be>
  800745:	e9 59 fc ff ff       	jmp    8003a3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80074a:	83 c4 3c             	add    $0x3c,%esp
  80074d:	5b                   	pop    %ebx
  80074e:	5e                   	pop    %esi
  80074f:	5f                   	pop    %edi
  800750:	5d                   	pop    %ebp
  800751:	c3                   	ret    

00800752 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800752:	55                   	push   %ebp
  800753:	89 e5                	mov    %esp,%ebp
  800755:	83 ec 28             	sub    $0x28,%esp
  800758:	8b 45 08             	mov    0x8(%ebp),%eax
  80075b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80075e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800761:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800765:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800768:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80076f:	85 c0                	test   %eax,%eax
  800771:	74 30                	je     8007a3 <vsnprintf+0x51>
  800773:	85 d2                	test   %edx,%edx
  800775:	7e 2c                	jle    8007a3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80077e:	8b 45 10             	mov    0x10(%ebp),%eax
  800781:	89 44 24 08          	mov    %eax,0x8(%esp)
  800785:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800788:	89 44 24 04          	mov    %eax,0x4(%esp)
  80078c:	c7 04 24 39 03 80 00 	movl   $0x800339,(%esp)
  800793:	e8 e6 fb ff ff       	call   80037e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800798:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80079b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80079e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a1:	eb 05                	jmp    8007a8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007a8:	c9                   	leave  
  8007a9:	c3                   	ret    

008007aa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007b0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	89 04 24             	mov    %eax,(%esp)
  8007cb:	e8 82 ff ff ff       	call   800752 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d0:	c9                   	leave  
  8007d1:	c3                   	ret    
  8007d2:	66 90                	xchg   %ax,%ax
  8007d4:	66 90                	xchg   %ax,%ax
  8007d6:	66 90                	xchg   %ax,%ax
  8007d8:	66 90                	xchg   %ax,%ax
  8007da:	66 90                	xchg   %ax,%ax
  8007dc:	66 90                	xchg   %ax,%ax
  8007de:	66 90                	xchg   %ax,%ax

008007e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007e0:	55                   	push   %ebp
  8007e1:	89 e5                	mov    %esp,%ebp
  8007e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007eb:	eb 03                	jmp    8007f0 <strlen+0x10>
		n++;
  8007ed:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007f4:	75 f7                	jne    8007ed <strlen+0xd>
		n++;
	return n;
}
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007fe:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800801:	b8 00 00 00 00       	mov    $0x0,%eax
  800806:	eb 03                	jmp    80080b <strnlen+0x13>
		n++;
  800808:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80080b:	39 d0                	cmp    %edx,%eax
  80080d:	74 06                	je     800815 <strnlen+0x1d>
  80080f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800813:	75 f3                	jne    800808 <strnlen+0x10>
		n++;
	return n;
}
  800815:	5d                   	pop    %ebp
  800816:	c3                   	ret    

00800817 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800817:	55                   	push   %ebp
  800818:	89 e5                	mov    %esp,%ebp
  80081a:	53                   	push   %ebx
  80081b:	8b 45 08             	mov    0x8(%ebp),%eax
  80081e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800821:	89 c2                	mov    %eax,%edx
  800823:	83 c2 01             	add    $0x1,%edx
  800826:	83 c1 01             	add    $0x1,%ecx
  800829:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80082d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800830:	84 db                	test   %bl,%bl
  800832:	75 ef                	jne    800823 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800834:	5b                   	pop    %ebx
  800835:	5d                   	pop    %ebp
  800836:	c3                   	ret    

00800837 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
  80083a:	53                   	push   %ebx
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800841:	89 1c 24             	mov    %ebx,(%esp)
  800844:	e8 97 ff ff ff       	call   8007e0 <strlen>
	strcpy(dst + len, src);
  800849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800850:	01 d8                	add    %ebx,%eax
  800852:	89 04 24             	mov    %eax,(%esp)
  800855:	e8 bd ff ff ff       	call   800817 <strcpy>
	return dst;
}
  80085a:	89 d8                	mov    %ebx,%eax
  80085c:	83 c4 08             	add    $0x8,%esp
  80085f:	5b                   	pop    %ebx
  800860:	5d                   	pop    %ebp
  800861:	c3                   	ret    

00800862 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	56                   	push   %esi
  800866:	53                   	push   %ebx
  800867:	8b 75 08             	mov    0x8(%ebp),%esi
  80086a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80086d:	89 f3                	mov    %esi,%ebx
  80086f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800872:	89 f2                	mov    %esi,%edx
  800874:	eb 0f                	jmp    800885 <strncpy+0x23>
		*dst++ = *src;
  800876:	83 c2 01             	add    $0x1,%edx
  800879:	0f b6 01             	movzbl (%ecx),%eax
  80087c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80087f:	80 39 01             	cmpb   $0x1,(%ecx)
  800882:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800885:	39 da                	cmp    %ebx,%edx
  800887:	75 ed                	jne    800876 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800889:	89 f0                	mov    %esi,%eax
  80088b:	5b                   	pop    %ebx
  80088c:	5e                   	pop    %esi
  80088d:	5d                   	pop    %ebp
  80088e:	c3                   	ret    

0080088f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	56                   	push   %esi
  800893:	53                   	push   %ebx
  800894:	8b 75 08             	mov    0x8(%ebp),%esi
  800897:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80089d:	89 f0                	mov    %esi,%eax
  80089f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008a3:	85 c9                	test   %ecx,%ecx
  8008a5:	75 0b                	jne    8008b2 <strlcpy+0x23>
  8008a7:	eb 1d                	jmp    8008c6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008a9:	83 c0 01             	add    $0x1,%eax
  8008ac:	83 c2 01             	add    $0x1,%edx
  8008af:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008b2:	39 d8                	cmp    %ebx,%eax
  8008b4:	74 0b                	je     8008c1 <strlcpy+0x32>
  8008b6:	0f b6 0a             	movzbl (%edx),%ecx
  8008b9:	84 c9                	test   %cl,%cl
  8008bb:	75 ec                	jne    8008a9 <strlcpy+0x1a>
  8008bd:	89 c2                	mov    %eax,%edx
  8008bf:	eb 02                	jmp    8008c3 <strlcpy+0x34>
  8008c1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8008c3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8008c6:	29 f0                	sub    %esi,%eax
}
  8008c8:	5b                   	pop    %ebx
  8008c9:	5e                   	pop    %esi
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    

008008cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008d5:	eb 06                	jmp    8008dd <strcmp+0x11>
		p++, q++;
  8008d7:	83 c1 01             	add    $0x1,%ecx
  8008da:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008dd:	0f b6 01             	movzbl (%ecx),%eax
  8008e0:	84 c0                	test   %al,%al
  8008e2:	74 04                	je     8008e8 <strcmp+0x1c>
  8008e4:	3a 02                	cmp    (%edx),%al
  8008e6:	74 ef                	je     8008d7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e8:	0f b6 c0             	movzbl %al,%eax
  8008eb:	0f b6 12             	movzbl (%edx),%edx
  8008ee:	29 d0                	sub    %edx,%eax
}
  8008f0:	5d                   	pop    %ebp
  8008f1:	c3                   	ret    

008008f2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	53                   	push   %ebx
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fc:	89 c3                	mov    %eax,%ebx
  8008fe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800901:	eb 06                	jmp    800909 <strncmp+0x17>
		n--, p++, q++;
  800903:	83 c0 01             	add    $0x1,%eax
  800906:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800909:	39 d8                	cmp    %ebx,%eax
  80090b:	74 15                	je     800922 <strncmp+0x30>
  80090d:	0f b6 08             	movzbl (%eax),%ecx
  800910:	84 c9                	test   %cl,%cl
  800912:	74 04                	je     800918 <strncmp+0x26>
  800914:	3a 0a                	cmp    (%edx),%cl
  800916:	74 eb                	je     800903 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800918:	0f b6 00             	movzbl (%eax),%eax
  80091b:	0f b6 12             	movzbl (%edx),%edx
  80091e:	29 d0                	sub    %edx,%eax
  800920:	eb 05                	jmp    800927 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800922:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800927:	5b                   	pop    %ebx
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800934:	eb 07                	jmp    80093d <strchr+0x13>
		if (*s == c)
  800936:	38 ca                	cmp    %cl,%dl
  800938:	74 0f                	je     800949 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80093a:	83 c0 01             	add    $0x1,%eax
  80093d:	0f b6 10             	movzbl (%eax),%edx
  800940:	84 d2                	test   %dl,%dl
  800942:	75 f2                	jne    800936 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800944:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800955:	eb 07                	jmp    80095e <strfind+0x13>
		if (*s == c)
  800957:	38 ca                	cmp    %cl,%dl
  800959:	74 0a                	je     800965 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80095b:	83 c0 01             	add    $0x1,%eax
  80095e:	0f b6 10             	movzbl (%eax),%edx
  800961:	84 d2                	test   %dl,%dl
  800963:	75 f2                	jne    800957 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800965:	5d                   	pop    %ebp
  800966:	c3                   	ret    

00800967 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	57                   	push   %edi
  80096b:	56                   	push   %esi
  80096c:	53                   	push   %ebx
  80096d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800970:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800973:	85 c9                	test   %ecx,%ecx
  800975:	74 36                	je     8009ad <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800977:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80097d:	75 28                	jne    8009a7 <memset+0x40>
  80097f:	f6 c1 03             	test   $0x3,%cl
  800982:	75 23                	jne    8009a7 <memset+0x40>
		c &= 0xFF;
  800984:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800988:	89 d3                	mov    %edx,%ebx
  80098a:	c1 e3 08             	shl    $0x8,%ebx
  80098d:	89 d6                	mov    %edx,%esi
  80098f:	c1 e6 18             	shl    $0x18,%esi
  800992:	89 d0                	mov    %edx,%eax
  800994:	c1 e0 10             	shl    $0x10,%eax
  800997:	09 f0                	or     %esi,%eax
  800999:	09 c2                	or     %eax,%edx
  80099b:	89 d0                	mov    %edx,%eax
  80099d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80099f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009a2:	fc                   	cld    
  8009a3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009a5:	eb 06                	jmp    8009ad <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009aa:	fc                   	cld    
  8009ab:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ad:	89 f8                	mov    %edi,%eax
  8009af:	5b                   	pop    %ebx
  8009b0:	5e                   	pop    %esi
  8009b1:	5f                   	pop    %edi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	57                   	push   %edi
  8009b8:	56                   	push   %esi
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009c2:	39 c6                	cmp    %eax,%esi
  8009c4:	73 35                	jae    8009fb <memmove+0x47>
  8009c6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009c9:	39 d0                	cmp    %edx,%eax
  8009cb:	73 2e                	jae    8009fb <memmove+0x47>
		s += n;
		d += n;
  8009cd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8009d0:	89 d6                	mov    %edx,%esi
  8009d2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009d4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009da:	75 13                	jne    8009ef <memmove+0x3b>
  8009dc:	f6 c1 03             	test   $0x3,%cl
  8009df:	75 0e                	jne    8009ef <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009e1:	83 ef 04             	sub    $0x4,%edi
  8009e4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009e7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009ea:	fd                   	std    
  8009eb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ed:	eb 09                	jmp    8009f8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ef:	83 ef 01             	sub    $0x1,%edi
  8009f2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009f5:	fd                   	std    
  8009f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009f8:	fc                   	cld    
  8009f9:	eb 1d                	jmp    800a18 <memmove+0x64>
  8009fb:	89 f2                	mov    %esi,%edx
  8009fd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009ff:	f6 c2 03             	test   $0x3,%dl
  800a02:	75 0f                	jne    800a13 <memmove+0x5f>
  800a04:	f6 c1 03             	test   $0x3,%cl
  800a07:	75 0a                	jne    800a13 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a09:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a0c:	89 c7                	mov    %eax,%edi
  800a0e:	fc                   	cld    
  800a0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a11:	eb 05                	jmp    800a18 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a13:	89 c7                	mov    %eax,%edi
  800a15:	fc                   	cld    
  800a16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a18:	5e                   	pop    %esi
  800a19:	5f                   	pop    %edi
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a22:	8b 45 10             	mov    0x10(%ebp),%eax
  800a25:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	89 04 24             	mov    %eax,(%esp)
  800a36:	e8 79 ff ff ff       	call   8009b4 <memmove>
}
  800a3b:	c9                   	leave  
  800a3c:	c3                   	ret    

00800a3d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	8b 55 08             	mov    0x8(%ebp),%edx
  800a45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a48:	89 d6                	mov    %edx,%esi
  800a4a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a4d:	eb 1a                	jmp    800a69 <memcmp+0x2c>
		if (*s1 != *s2)
  800a4f:	0f b6 02             	movzbl (%edx),%eax
  800a52:	0f b6 19             	movzbl (%ecx),%ebx
  800a55:	38 d8                	cmp    %bl,%al
  800a57:	74 0a                	je     800a63 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a59:	0f b6 c0             	movzbl %al,%eax
  800a5c:	0f b6 db             	movzbl %bl,%ebx
  800a5f:	29 d8                	sub    %ebx,%eax
  800a61:	eb 0f                	jmp    800a72 <memcmp+0x35>
		s1++, s2++;
  800a63:	83 c2 01             	add    $0x1,%edx
  800a66:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a69:	39 f2                	cmp    %esi,%edx
  800a6b:	75 e2                	jne    800a4f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a72:	5b                   	pop    %ebx
  800a73:	5e                   	pop    %esi
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    

00800a76 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a7f:	89 c2                	mov    %eax,%edx
  800a81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a84:	eb 07                	jmp    800a8d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a86:	38 08                	cmp    %cl,(%eax)
  800a88:	74 07                	je     800a91 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a8a:	83 c0 01             	add    $0x1,%eax
  800a8d:	39 d0                	cmp    %edx,%eax
  800a8f:	72 f5                	jb     800a86 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a91:	5d                   	pop    %ebp
  800a92:	c3                   	ret    

00800a93 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	57                   	push   %edi
  800a97:	56                   	push   %esi
  800a98:	53                   	push   %ebx
  800a99:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a9f:	eb 03                	jmp    800aa4 <strtol+0x11>
		s++;
  800aa1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aa4:	0f b6 0a             	movzbl (%edx),%ecx
  800aa7:	80 f9 09             	cmp    $0x9,%cl
  800aaa:	74 f5                	je     800aa1 <strtol+0xe>
  800aac:	80 f9 20             	cmp    $0x20,%cl
  800aaf:	74 f0                	je     800aa1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ab1:	80 f9 2b             	cmp    $0x2b,%cl
  800ab4:	75 0a                	jne    800ac0 <strtol+0x2d>
		s++;
  800ab6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ab9:	bf 00 00 00 00       	mov    $0x0,%edi
  800abe:	eb 11                	jmp    800ad1 <strtol+0x3e>
  800ac0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ac5:	80 f9 2d             	cmp    $0x2d,%cl
  800ac8:	75 07                	jne    800ad1 <strtol+0x3e>
		s++, neg = 1;
  800aca:	8d 52 01             	lea    0x1(%edx),%edx
  800acd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ad1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ad6:	75 15                	jne    800aed <strtol+0x5a>
  800ad8:	80 3a 30             	cmpb   $0x30,(%edx)
  800adb:	75 10                	jne    800aed <strtol+0x5a>
  800add:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ae1:	75 0a                	jne    800aed <strtol+0x5a>
		s += 2, base = 16;
  800ae3:	83 c2 02             	add    $0x2,%edx
  800ae6:	b8 10 00 00 00       	mov    $0x10,%eax
  800aeb:	eb 10                	jmp    800afd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800aed:	85 c0                	test   %eax,%eax
  800aef:	75 0c                	jne    800afd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800af1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800af3:	80 3a 30             	cmpb   $0x30,(%edx)
  800af6:	75 05                	jne    800afd <strtol+0x6a>
		s++, base = 8;
  800af8:	83 c2 01             	add    $0x1,%edx
  800afb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800afd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b02:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b05:	0f b6 0a             	movzbl (%edx),%ecx
  800b08:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b0b:	89 f0                	mov    %esi,%eax
  800b0d:	3c 09                	cmp    $0x9,%al
  800b0f:	77 08                	ja     800b19 <strtol+0x86>
			dig = *s - '0';
  800b11:	0f be c9             	movsbl %cl,%ecx
  800b14:	83 e9 30             	sub    $0x30,%ecx
  800b17:	eb 20                	jmp    800b39 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b19:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b1c:	89 f0                	mov    %esi,%eax
  800b1e:	3c 19                	cmp    $0x19,%al
  800b20:	77 08                	ja     800b2a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b22:	0f be c9             	movsbl %cl,%ecx
  800b25:	83 e9 57             	sub    $0x57,%ecx
  800b28:	eb 0f                	jmp    800b39 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b2a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b2d:	89 f0                	mov    %esi,%eax
  800b2f:	3c 19                	cmp    $0x19,%al
  800b31:	77 16                	ja     800b49 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b33:	0f be c9             	movsbl %cl,%ecx
  800b36:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b39:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b3c:	7d 0f                	jge    800b4d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b3e:	83 c2 01             	add    $0x1,%edx
  800b41:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b45:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b47:	eb bc                	jmp    800b05 <strtol+0x72>
  800b49:	89 d8                	mov    %ebx,%eax
  800b4b:	eb 02                	jmp    800b4f <strtol+0xbc>
  800b4d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b53:	74 05                	je     800b5a <strtol+0xc7>
		*endptr = (char *) s;
  800b55:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b58:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b5a:	f7 d8                	neg    %eax
  800b5c:	85 ff                	test   %edi,%edi
  800b5e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5f                   	pop    %edi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	57                   	push   %edi
  800b6a:	56                   	push   %esi
  800b6b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b71:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b74:	8b 55 08             	mov    0x8(%ebp),%edx
  800b77:	89 c3                	mov    %eax,%ebx
  800b79:	89 c7                	mov    %eax,%edi
  800b7b:	89 c6                	mov    %eax,%esi
  800b7d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	57                   	push   %edi
  800b88:	56                   	push   %esi
  800b89:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b94:	89 d1                	mov    %edx,%ecx
  800b96:	89 d3                	mov    %edx,%ebx
  800b98:	89 d7                	mov    %edx,%edi
  800b9a:	89 d6                	mov    %edx,%esi
  800b9c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b9e:	5b                   	pop    %ebx
  800b9f:	5e                   	pop    %esi
  800ba0:	5f                   	pop    %edi
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ba3:	55                   	push   %ebp
  800ba4:	89 e5                	mov    %esp,%ebp
  800ba6:	57                   	push   %edi
  800ba7:	56                   	push   %esi
  800ba8:	53                   	push   %ebx
  800ba9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bac:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bb1:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb9:	89 cb                	mov    %ecx,%ebx
  800bbb:	89 cf                	mov    %ecx,%edi
  800bbd:	89 ce                	mov    %ecx,%esi
  800bbf:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800bc1:	85 c0                	test   %eax,%eax
  800bc3:	7e 28                	jle    800bed <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bc9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800bd0:	00 
  800bd1:	c7 44 24 08 27 34 80 	movl   $0x803427,0x8(%esp)
  800bd8:	00 
  800bd9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800be0:	00 
  800be1:	c7 04 24 44 34 80 00 	movl   $0x803444,(%esp)
  800be8:	e8 07 f5 ff ff       	call   8000f4 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bed:	83 c4 2c             	add    $0x2c,%esp
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5f                   	pop    %edi
  800bf3:	5d                   	pop    %ebp
  800bf4:	c3                   	ret    

00800bf5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	57                   	push   %edi
  800bf9:	56                   	push   %esi
  800bfa:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfb:	ba 00 00 00 00       	mov    $0x0,%edx
  800c00:	b8 02 00 00 00       	mov    $0x2,%eax
  800c05:	89 d1                	mov    %edx,%ecx
  800c07:	89 d3                	mov    %edx,%ebx
  800c09:	89 d7                	mov    %edx,%edi
  800c0b:	89 d6                	mov    %edx,%esi
  800c0d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c0f:	5b                   	pop    %ebx
  800c10:	5e                   	pop    %esi
  800c11:	5f                   	pop    %edi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <sys_yield>:

void
sys_yield(void)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	57                   	push   %edi
  800c18:	56                   	push   %esi
  800c19:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c24:	89 d1                	mov    %edx,%ecx
  800c26:	89 d3                	mov    %edx,%ebx
  800c28:	89 d7                	mov    %edx,%edi
  800c2a:	89 d6                	mov    %edx,%esi
  800c2c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c2e:	5b                   	pop    %ebx
  800c2f:	5e                   	pop    %esi
  800c30:	5f                   	pop    %edi
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
  800c39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3c:	be 00 00 00 00       	mov    $0x0,%esi
  800c41:	b8 04 00 00 00       	mov    $0x4,%eax
  800c46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c49:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c4f:	89 f7                	mov    %esi,%edi
  800c51:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c53:	85 c0                	test   %eax,%eax
  800c55:	7e 28                	jle    800c7f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c57:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c5b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c62:	00 
  800c63:	c7 44 24 08 27 34 80 	movl   $0x803427,0x8(%esp)
  800c6a:	00 
  800c6b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c72:	00 
  800c73:	c7 04 24 44 34 80 00 	movl   $0x803444,(%esp)
  800c7a:	e8 75 f4 ff ff       	call   8000f4 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c7f:	83 c4 2c             	add    $0x2c,%esp
  800c82:	5b                   	pop    %ebx
  800c83:	5e                   	pop    %esi
  800c84:	5f                   	pop    %edi
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
  800c8d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c90:	b8 05 00 00 00       	mov    $0x5,%eax
  800c95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c98:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ca1:	8b 75 18             	mov    0x18(%ebp),%esi
  800ca4:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	7e 28                	jle    800cd2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800caa:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cae:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800cb5:	00 
  800cb6:	c7 44 24 08 27 34 80 	movl   $0x803427,0x8(%esp)
  800cbd:	00 
  800cbe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc5:	00 
  800cc6:	c7 04 24 44 34 80 00 	movl   $0x803444,(%esp)
  800ccd:	e8 22 f4 ff ff       	call   8000f4 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cd2:	83 c4 2c             	add    $0x2c,%esp
  800cd5:	5b                   	pop    %ebx
  800cd6:	5e                   	pop    %esi
  800cd7:	5f                   	pop    %edi
  800cd8:	5d                   	pop    %ebp
  800cd9:	c3                   	ret    

00800cda <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	57                   	push   %edi
  800cde:	56                   	push   %esi
  800cdf:	53                   	push   %ebx
  800ce0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce8:	b8 06 00 00 00       	mov    $0x6,%eax
  800ced:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf3:	89 df                	mov    %ebx,%edi
  800cf5:	89 de                	mov    %ebx,%esi
  800cf7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cf9:	85 c0                	test   %eax,%eax
  800cfb:	7e 28                	jle    800d25 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d01:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d08:	00 
  800d09:	c7 44 24 08 27 34 80 	movl   $0x803427,0x8(%esp)
  800d10:	00 
  800d11:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d18:	00 
  800d19:	c7 04 24 44 34 80 00 	movl   $0x803444,(%esp)
  800d20:	e8 cf f3 ff ff       	call   8000f4 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d25:	83 c4 2c             	add    $0x2c,%esp
  800d28:	5b                   	pop    %ebx
  800d29:	5e                   	pop    %esi
  800d2a:	5f                   	pop    %edi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	57                   	push   %edi
  800d31:	56                   	push   %esi
  800d32:	53                   	push   %ebx
  800d33:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d36:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d43:	8b 55 08             	mov    0x8(%ebp),%edx
  800d46:	89 df                	mov    %ebx,%edi
  800d48:	89 de                	mov    %ebx,%esi
  800d4a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	7e 28                	jle    800d78 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d50:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d54:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d5b:	00 
  800d5c:	c7 44 24 08 27 34 80 	movl   $0x803427,0x8(%esp)
  800d63:	00 
  800d64:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d6b:	00 
  800d6c:	c7 04 24 44 34 80 00 	movl   $0x803444,(%esp)
  800d73:	e8 7c f3 ff ff       	call   8000f4 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d78:	83 c4 2c             	add    $0x2c,%esp
  800d7b:	5b                   	pop    %ebx
  800d7c:	5e                   	pop    %esi
  800d7d:	5f                   	pop    %edi
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d89:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8e:	b8 09 00 00 00       	mov    $0x9,%eax
  800d93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d96:	8b 55 08             	mov    0x8(%ebp),%edx
  800d99:	89 df                	mov    %ebx,%edi
  800d9b:	89 de                	mov    %ebx,%esi
  800d9d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	7e 28                	jle    800dcb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dae:	00 
  800daf:	c7 44 24 08 27 34 80 	movl   $0x803427,0x8(%esp)
  800db6:	00 
  800db7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dbe:	00 
  800dbf:	c7 04 24 44 34 80 00 	movl   $0x803444,(%esp)
  800dc6:	e8 29 f3 ff ff       	call   8000f4 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dcb:	83 c4 2c             	add    $0x2c,%esp
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5f                   	pop    %edi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	57                   	push   %edi
  800dd7:	56                   	push   %esi
  800dd8:	53                   	push   %ebx
  800dd9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ddc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800de6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	89 df                	mov    %ebx,%edi
  800dee:	89 de                	mov    %ebx,%esi
  800df0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800df2:	85 c0                	test   %eax,%eax
  800df4:	7e 28                	jle    800e1e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dfa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e01:	00 
  800e02:	c7 44 24 08 27 34 80 	movl   $0x803427,0x8(%esp)
  800e09:	00 
  800e0a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e11:	00 
  800e12:	c7 04 24 44 34 80 00 	movl   $0x803444,(%esp)
  800e19:	e8 d6 f2 ff ff       	call   8000f4 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e1e:	83 c4 2c             	add    $0x2c,%esp
  800e21:	5b                   	pop    %ebx
  800e22:	5e                   	pop    %esi
  800e23:	5f                   	pop    %edi
  800e24:	5d                   	pop    %ebp
  800e25:	c3                   	ret    

00800e26 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	57                   	push   %edi
  800e2a:	56                   	push   %esi
  800e2b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2c:	be 00 00 00 00       	mov    $0x0,%esi
  800e31:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e39:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e42:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	57                   	push   %edi
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e57:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5f:	89 cb                	mov    %ecx,%ebx
  800e61:	89 cf                	mov    %ecx,%edi
  800e63:	89 ce                	mov    %ecx,%esi
  800e65:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e67:	85 c0                	test   %eax,%eax
  800e69:	7e 28                	jle    800e93 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e76:	00 
  800e77:	c7 44 24 08 27 34 80 	movl   $0x803427,0x8(%esp)
  800e7e:	00 
  800e7f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e86:	00 
  800e87:	c7 04 24 44 34 80 00 	movl   $0x803444,(%esp)
  800e8e:	e8 61 f2 ff ff       	call   8000f4 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e93:	83 c4 2c             	add    $0x2c,%esp
  800e96:	5b                   	pop    %ebx
  800e97:	5e                   	pop    %esi
  800e98:	5f                   	pop    %edi
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	57                   	push   %edi
  800e9f:	56                   	push   %esi
  800ea0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eab:	89 d1                	mov    %edx,%ecx
  800ead:	89 d3                	mov    %edx,%ebx
  800eaf:	89 d7                	mov    %edx,%edi
  800eb1:	89 d6                	mov    %edx,%esi
  800eb3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800eb5:	5b                   	pop    %ebx
  800eb6:	5e                   	pop    %esi
  800eb7:	5f                   	pop    %edi
  800eb8:	5d                   	pop    %ebp
  800eb9:	c3                   	ret    

00800eba <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	57                   	push   %edi
  800ebe:	56                   	push   %esi
  800ebf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec5:	b8 0f 00 00 00       	mov    $0xf,%eax
  800eca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed0:	89 df                	mov    %ebx,%edi
  800ed2:	89 de                	mov    %ebx,%esi
  800ed4:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800ed6:	5b                   	pop    %ebx
  800ed7:	5e                   	pop    %esi
  800ed8:	5f                   	pop    %edi
  800ed9:	5d                   	pop    %ebp
  800eda:	c3                   	ret    

00800edb <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	57                   	push   %edi
  800edf:	56                   	push   %esi
  800ee0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee6:	b8 10 00 00 00       	mov    $0x10,%eax
  800eeb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef1:	89 df                	mov    %ebx,%edi
  800ef3:	89 de                	mov    %ebx,%esi
  800ef5:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800ef7:	5b                   	pop    %ebx
  800ef8:	5e                   	pop    %esi
  800ef9:	5f                   	pop    %edi
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    

00800efc <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	57                   	push   %edi
  800f00:	56                   	push   %esi
  800f01:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f07:	b8 11 00 00 00       	mov    $0x11,%eax
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	89 cb                	mov    %ecx,%ebx
  800f11:	89 cf                	mov    %ecx,%edi
  800f13:	89 ce                	mov    %ecx,%esi
  800f15:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800f17:	5b                   	pop    %ebx
  800f18:	5e                   	pop    %esi
  800f19:	5f                   	pop    %edi
  800f1a:	5d                   	pop    %ebp
  800f1b:	c3                   	ret    

00800f1c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800f1c:	55                   	push   %ebp
  800f1d:	89 e5                	mov    %esp,%ebp
  800f1f:	57                   	push   %edi
  800f20:	56                   	push   %esi
  800f21:	53                   	push   %ebx
  800f22:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f25:	be 00 00 00 00       	mov    $0x0,%esi
  800f2a:	b8 12 00 00 00       	mov    $0x12,%eax
  800f2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f38:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f3b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	7e 28                	jle    800f69 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f41:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f45:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800f4c:	00 
  800f4d:	c7 44 24 08 27 34 80 	movl   $0x803427,0x8(%esp)
  800f54:	00 
  800f55:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f5c:	00 
  800f5d:	c7 04 24 44 34 80 00 	movl   $0x803444,(%esp)
  800f64:	e8 8b f1 ff ff       	call   8000f4 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  800f69:	83 c4 2c             	add    $0x2c,%esp
  800f6c:	5b                   	pop    %ebx
  800f6d:	5e                   	pop    %esi
  800f6e:	5f                   	pop    %edi
  800f6f:	5d                   	pop    %ebp
  800f70:	c3                   	ret    
  800f71:	66 90                	xchg   %ax,%ax
  800f73:	66 90                	xchg   %ax,%ax
  800f75:	66 90                	xchg   %ax,%ax
  800f77:	66 90                	xchg   %ax,%ax
  800f79:	66 90                	xchg   %ax,%ax
  800f7b:	66 90                	xchg   %ax,%ax
  800f7d:	66 90                	xchg   %ax,%ax
  800f7f:	90                   	nop

00800f80 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	05 00 00 00 30       	add    $0x30000000,%eax
  800f8b:	c1 e8 0c             	shr    $0xc,%eax
}
  800f8e:	5d                   	pop    %ebp
  800f8f:	c3                   	ret    

00800f90 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f90:	55                   	push   %ebp
  800f91:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800f9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fa0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    

00800fa7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fad:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fb2:	89 c2                	mov    %eax,%edx
  800fb4:	c1 ea 16             	shr    $0x16,%edx
  800fb7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fbe:	f6 c2 01             	test   $0x1,%dl
  800fc1:	74 11                	je     800fd4 <fd_alloc+0x2d>
  800fc3:	89 c2                	mov    %eax,%edx
  800fc5:	c1 ea 0c             	shr    $0xc,%edx
  800fc8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fcf:	f6 c2 01             	test   $0x1,%dl
  800fd2:	75 09                	jne    800fdd <fd_alloc+0x36>
			*fd_store = fd;
  800fd4:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdb:	eb 17                	jmp    800ff4 <fd_alloc+0x4d>
  800fdd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800fe2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800fe7:	75 c9                	jne    800fb2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800fe9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800fef:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800ff4:	5d                   	pop    %ebp
  800ff5:	c3                   	ret    

00800ff6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ffc:	83 f8 1f             	cmp    $0x1f,%eax
  800fff:	77 36                	ja     801037 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801001:	c1 e0 0c             	shl    $0xc,%eax
  801004:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801009:	89 c2                	mov    %eax,%edx
  80100b:	c1 ea 16             	shr    $0x16,%edx
  80100e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801015:	f6 c2 01             	test   $0x1,%dl
  801018:	74 24                	je     80103e <fd_lookup+0x48>
  80101a:	89 c2                	mov    %eax,%edx
  80101c:	c1 ea 0c             	shr    $0xc,%edx
  80101f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801026:	f6 c2 01             	test   $0x1,%dl
  801029:	74 1a                	je     801045 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80102b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102e:	89 02                	mov    %eax,(%edx)
	return 0;
  801030:	b8 00 00 00 00       	mov    $0x0,%eax
  801035:	eb 13                	jmp    80104a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801037:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80103c:	eb 0c                	jmp    80104a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80103e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801043:	eb 05                	jmp    80104a <fd_lookup+0x54>
  801045:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80104a:	5d                   	pop    %ebp
  80104b:	c3                   	ret    

0080104c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	83 ec 18             	sub    $0x18,%esp
  801052:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801055:	ba 00 00 00 00       	mov    $0x0,%edx
  80105a:	eb 13                	jmp    80106f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80105c:	39 08                	cmp    %ecx,(%eax)
  80105e:	75 0c                	jne    80106c <dev_lookup+0x20>
			*dev = devtab[i];
  801060:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801063:	89 01                	mov    %eax,(%ecx)
			return 0;
  801065:	b8 00 00 00 00       	mov    $0x0,%eax
  80106a:	eb 38                	jmp    8010a4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80106c:	83 c2 01             	add    $0x1,%edx
  80106f:	8b 04 95 d0 34 80 00 	mov    0x8034d0(,%edx,4),%eax
  801076:	85 c0                	test   %eax,%eax
  801078:	75 e2                	jne    80105c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80107a:	a1 08 50 80 00       	mov    0x805008,%eax
  80107f:	8b 40 48             	mov    0x48(%eax),%eax
  801082:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801086:	89 44 24 04          	mov    %eax,0x4(%esp)
  80108a:	c7 04 24 54 34 80 00 	movl   $0x803454,(%esp)
  801091:	e8 57 f1 ff ff       	call   8001ed <cprintf>
	*dev = 0;
  801096:	8b 45 0c             	mov    0xc(%ebp),%eax
  801099:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80109f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010a4:	c9                   	leave  
  8010a5:	c3                   	ret    

008010a6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	56                   	push   %esi
  8010aa:	53                   	push   %ebx
  8010ab:	83 ec 20             	sub    $0x20,%esp
  8010ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8010b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010b7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010bb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010c1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010c4:	89 04 24             	mov    %eax,(%esp)
  8010c7:	e8 2a ff ff ff       	call   800ff6 <fd_lookup>
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	78 05                	js     8010d5 <fd_close+0x2f>
	    || fd != fd2)
  8010d0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8010d3:	74 0c                	je     8010e1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8010d5:	84 db                	test   %bl,%bl
  8010d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8010dc:	0f 44 c2             	cmove  %edx,%eax
  8010df:	eb 3f                	jmp    801120 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8010e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010e8:	8b 06                	mov    (%esi),%eax
  8010ea:	89 04 24             	mov    %eax,(%esp)
  8010ed:	e8 5a ff ff ff       	call   80104c <dev_lookup>
  8010f2:	89 c3                	mov    %eax,%ebx
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	78 16                	js     80110e <fd_close+0x68>
		if (dev->dev_close)
  8010f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010fb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8010fe:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801103:	85 c0                	test   %eax,%eax
  801105:	74 07                	je     80110e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801107:	89 34 24             	mov    %esi,(%esp)
  80110a:	ff d0                	call   *%eax
  80110c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80110e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801112:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801119:	e8 bc fb ff ff       	call   800cda <sys_page_unmap>
	return r;
  80111e:	89 d8                	mov    %ebx,%eax
}
  801120:	83 c4 20             	add    $0x20,%esp
  801123:	5b                   	pop    %ebx
  801124:	5e                   	pop    %esi
  801125:	5d                   	pop    %ebp
  801126:	c3                   	ret    

00801127 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
  80112a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80112d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801130:	89 44 24 04          	mov    %eax,0x4(%esp)
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	89 04 24             	mov    %eax,(%esp)
  80113a:	e8 b7 fe ff ff       	call   800ff6 <fd_lookup>
  80113f:	89 c2                	mov    %eax,%edx
  801141:	85 d2                	test   %edx,%edx
  801143:	78 13                	js     801158 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801145:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80114c:	00 
  80114d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801150:	89 04 24             	mov    %eax,(%esp)
  801153:	e8 4e ff ff ff       	call   8010a6 <fd_close>
}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <close_all>:

void
close_all(void)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	53                   	push   %ebx
  80115e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801161:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801166:	89 1c 24             	mov    %ebx,(%esp)
  801169:	e8 b9 ff ff ff       	call   801127 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80116e:	83 c3 01             	add    $0x1,%ebx
  801171:	83 fb 20             	cmp    $0x20,%ebx
  801174:	75 f0                	jne    801166 <close_all+0xc>
		close(i);
}
  801176:	83 c4 14             	add    $0x14,%esp
  801179:	5b                   	pop    %ebx
  80117a:	5d                   	pop    %ebp
  80117b:	c3                   	ret    

0080117c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	57                   	push   %edi
  801180:	56                   	push   %esi
  801181:	53                   	push   %ebx
  801182:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801185:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801188:	89 44 24 04          	mov    %eax,0x4(%esp)
  80118c:	8b 45 08             	mov    0x8(%ebp),%eax
  80118f:	89 04 24             	mov    %eax,(%esp)
  801192:	e8 5f fe ff ff       	call   800ff6 <fd_lookup>
  801197:	89 c2                	mov    %eax,%edx
  801199:	85 d2                	test   %edx,%edx
  80119b:	0f 88 e1 00 00 00    	js     801282 <dup+0x106>
		return r;
	close(newfdnum);
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	89 04 24             	mov    %eax,(%esp)
  8011a7:	e8 7b ff ff ff       	call   801127 <close>

	newfd = INDEX2FD(newfdnum);
  8011ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8011af:	c1 e3 0c             	shl    $0xc,%ebx
  8011b2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8011b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011bb:	89 04 24             	mov    %eax,(%esp)
  8011be:	e8 cd fd ff ff       	call   800f90 <fd2data>
  8011c3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8011c5:	89 1c 24             	mov    %ebx,(%esp)
  8011c8:	e8 c3 fd ff ff       	call   800f90 <fd2data>
  8011cd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011cf:	89 f0                	mov    %esi,%eax
  8011d1:	c1 e8 16             	shr    $0x16,%eax
  8011d4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011db:	a8 01                	test   $0x1,%al
  8011dd:	74 43                	je     801222 <dup+0xa6>
  8011df:	89 f0                	mov    %esi,%eax
  8011e1:	c1 e8 0c             	shr    $0xc,%eax
  8011e4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8011eb:	f6 c2 01             	test   $0x1,%dl
  8011ee:	74 32                	je     801222 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8011fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  801200:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801204:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80120b:	00 
  80120c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801210:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801217:	e8 6b fa ff ff       	call   800c87 <sys_page_map>
  80121c:	89 c6                	mov    %eax,%esi
  80121e:	85 c0                	test   %eax,%eax
  801220:	78 3e                	js     801260 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801225:	89 c2                	mov    %eax,%edx
  801227:	c1 ea 0c             	shr    $0xc,%edx
  80122a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801231:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801237:	89 54 24 10          	mov    %edx,0x10(%esp)
  80123b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80123f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801246:	00 
  801247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80124b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801252:	e8 30 fa ff ff       	call   800c87 <sys_page_map>
  801257:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80125c:	85 f6                	test   %esi,%esi
  80125e:	79 22                	jns    801282 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801260:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801264:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80126b:	e8 6a fa ff ff       	call   800cda <sys_page_unmap>
	sys_page_unmap(0, nva);
  801270:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801274:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80127b:	e8 5a fa ff ff       	call   800cda <sys_page_unmap>
	return r;
  801280:	89 f0                	mov    %esi,%eax
}
  801282:	83 c4 3c             	add    $0x3c,%esp
  801285:	5b                   	pop    %ebx
  801286:	5e                   	pop    %esi
  801287:	5f                   	pop    %edi
  801288:	5d                   	pop    %ebp
  801289:	c3                   	ret    

0080128a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	53                   	push   %ebx
  80128e:	83 ec 24             	sub    $0x24,%esp
  801291:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801294:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801297:	89 44 24 04          	mov    %eax,0x4(%esp)
  80129b:	89 1c 24             	mov    %ebx,(%esp)
  80129e:	e8 53 fd ff ff       	call   800ff6 <fd_lookup>
  8012a3:	89 c2                	mov    %eax,%edx
  8012a5:	85 d2                	test   %edx,%edx
  8012a7:	78 6d                	js     801316 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012b3:	8b 00                	mov    (%eax),%eax
  8012b5:	89 04 24             	mov    %eax,(%esp)
  8012b8:	e8 8f fd ff ff       	call   80104c <dev_lookup>
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	78 55                	js     801316 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012c4:	8b 50 08             	mov    0x8(%eax),%edx
  8012c7:	83 e2 03             	and    $0x3,%edx
  8012ca:	83 fa 01             	cmp    $0x1,%edx
  8012cd:	75 23                	jne    8012f2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012cf:	a1 08 50 80 00       	mov    0x805008,%eax
  8012d4:	8b 40 48             	mov    0x48(%eax),%eax
  8012d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012df:	c7 04 24 95 34 80 00 	movl   $0x803495,(%esp)
  8012e6:	e8 02 ef ff ff       	call   8001ed <cprintf>
		return -E_INVAL;
  8012eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f0:	eb 24                	jmp    801316 <read+0x8c>
	}
	if (!dev->dev_read)
  8012f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f5:	8b 52 08             	mov    0x8(%edx),%edx
  8012f8:	85 d2                	test   %edx,%edx
  8012fa:	74 15                	je     801311 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801303:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801306:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80130a:	89 04 24             	mov    %eax,(%esp)
  80130d:	ff d2                	call   *%edx
  80130f:	eb 05                	jmp    801316 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801311:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801316:	83 c4 24             	add    $0x24,%esp
  801319:	5b                   	pop    %ebx
  80131a:	5d                   	pop    %ebp
  80131b:	c3                   	ret    

0080131c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	57                   	push   %edi
  801320:	56                   	push   %esi
  801321:	53                   	push   %ebx
  801322:	83 ec 1c             	sub    $0x1c,%esp
  801325:	8b 7d 08             	mov    0x8(%ebp),%edi
  801328:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80132b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801330:	eb 23                	jmp    801355 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801332:	89 f0                	mov    %esi,%eax
  801334:	29 d8                	sub    %ebx,%eax
  801336:	89 44 24 08          	mov    %eax,0x8(%esp)
  80133a:	89 d8                	mov    %ebx,%eax
  80133c:	03 45 0c             	add    0xc(%ebp),%eax
  80133f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801343:	89 3c 24             	mov    %edi,(%esp)
  801346:	e8 3f ff ff ff       	call   80128a <read>
		if (m < 0)
  80134b:	85 c0                	test   %eax,%eax
  80134d:	78 10                	js     80135f <readn+0x43>
			return m;
		if (m == 0)
  80134f:	85 c0                	test   %eax,%eax
  801351:	74 0a                	je     80135d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801353:	01 c3                	add    %eax,%ebx
  801355:	39 f3                	cmp    %esi,%ebx
  801357:	72 d9                	jb     801332 <readn+0x16>
  801359:	89 d8                	mov    %ebx,%eax
  80135b:	eb 02                	jmp    80135f <readn+0x43>
  80135d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80135f:	83 c4 1c             	add    $0x1c,%esp
  801362:	5b                   	pop    %ebx
  801363:	5e                   	pop    %esi
  801364:	5f                   	pop    %edi
  801365:	5d                   	pop    %ebp
  801366:	c3                   	ret    

00801367 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	53                   	push   %ebx
  80136b:	83 ec 24             	sub    $0x24,%esp
  80136e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801371:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801374:	89 44 24 04          	mov    %eax,0x4(%esp)
  801378:	89 1c 24             	mov    %ebx,(%esp)
  80137b:	e8 76 fc ff ff       	call   800ff6 <fd_lookup>
  801380:	89 c2                	mov    %eax,%edx
  801382:	85 d2                	test   %edx,%edx
  801384:	78 68                	js     8013ee <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801386:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801389:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801390:	8b 00                	mov    (%eax),%eax
  801392:	89 04 24             	mov    %eax,(%esp)
  801395:	e8 b2 fc ff ff       	call   80104c <dev_lookup>
  80139a:	85 c0                	test   %eax,%eax
  80139c:	78 50                	js     8013ee <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80139e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013a5:	75 23                	jne    8013ca <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013a7:	a1 08 50 80 00       	mov    0x805008,%eax
  8013ac:	8b 40 48             	mov    0x48(%eax),%eax
  8013af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b7:	c7 04 24 b1 34 80 00 	movl   $0x8034b1,(%esp)
  8013be:	e8 2a ee ff ff       	call   8001ed <cprintf>
		return -E_INVAL;
  8013c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c8:	eb 24                	jmp    8013ee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013cd:	8b 52 0c             	mov    0xc(%edx),%edx
  8013d0:	85 d2                	test   %edx,%edx
  8013d2:	74 15                	je     8013e9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013e2:	89 04 24             	mov    %eax,(%esp)
  8013e5:	ff d2                	call   *%edx
  8013e7:	eb 05                	jmp    8013ee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8013e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8013ee:	83 c4 24             	add    $0x24,%esp
  8013f1:	5b                   	pop    %ebx
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013fa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8013fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	89 04 24             	mov    %eax,(%esp)
  801407:	e8 ea fb ff ff       	call   800ff6 <fd_lookup>
  80140c:	85 c0                	test   %eax,%eax
  80140e:	78 0e                	js     80141e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801410:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801413:	8b 55 0c             	mov    0xc(%ebp),%edx
  801416:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801419:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141e:	c9                   	leave  
  80141f:	c3                   	ret    

00801420 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	53                   	push   %ebx
  801424:	83 ec 24             	sub    $0x24,%esp
  801427:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801431:	89 1c 24             	mov    %ebx,(%esp)
  801434:	e8 bd fb ff ff       	call   800ff6 <fd_lookup>
  801439:	89 c2                	mov    %eax,%edx
  80143b:	85 d2                	test   %edx,%edx
  80143d:	78 61                	js     8014a0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801442:	89 44 24 04          	mov    %eax,0x4(%esp)
  801446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801449:	8b 00                	mov    (%eax),%eax
  80144b:	89 04 24             	mov    %eax,(%esp)
  80144e:	e8 f9 fb ff ff       	call   80104c <dev_lookup>
  801453:	85 c0                	test   %eax,%eax
  801455:	78 49                	js     8014a0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80145e:	75 23                	jne    801483 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801460:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801465:	8b 40 48             	mov    0x48(%eax),%eax
  801468:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80146c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801470:	c7 04 24 74 34 80 00 	movl   $0x803474,(%esp)
  801477:	e8 71 ed ff ff       	call   8001ed <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80147c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801481:	eb 1d                	jmp    8014a0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801483:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801486:	8b 52 18             	mov    0x18(%edx),%edx
  801489:	85 d2                	test   %edx,%edx
  80148b:	74 0e                	je     80149b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80148d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801490:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801494:	89 04 24             	mov    %eax,(%esp)
  801497:	ff d2                	call   *%edx
  801499:	eb 05                	jmp    8014a0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80149b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8014a0:	83 c4 24             	add    $0x24,%esp
  8014a3:	5b                   	pop    %ebx
  8014a4:	5d                   	pop    %ebp
  8014a5:	c3                   	ret    

008014a6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014a6:	55                   	push   %ebp
  8014a7:	89 e5                	mov    %esp,%ebp
  8014a9:	53                   	push   %ebx
  8014aa:	83 ec 24             	sub    $0x24,%esp
  8014ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	89 04 24             	mov    %eax,(%esp)
  8014bd:	e8 34 fb ff ff       	call   800ff6 <fd_lookup>
  8014c2:	89 c2                	mov    %eax,%edx
  8014c4:	85 d2                	test   %edx,%edx
  8014c6:	78 52                	js     80151a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d2:	8b 00                	mov    (%eax),%eax
  8014d4:	89 04 24             	mov    %eax,(%esp)
  8014d7:	e8 70 fb ff ff       	call   80104c <dev_lookup>
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 3a                	js     80151a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8014e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014e7:	74 2c                	je     801515 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014e9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014ec:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014f3:	00 00 00 
	stat->st_isdir = 0;
  8014f6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014fd:	00 00 00 
	stat->st_dev = dev;
  801500:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801506:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80150a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80150d:	89 14 24             	mov    %edx,(%esp)
  801510:	ff 50 14             	call   *0x14(%eax)
  801513:	eb 05                	jmp    80151a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801515:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80151a:	83 c4 24             	add    $0x24,%esp
  80151d:	5b                   	pop    %ebx
  80151e:	5d                   	pop    %ebp
  80151f:	c3                   	ret    

00801520 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	56                   	push   %esi
  801524:	53                   	push   %ebx
  801525:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801528:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80152f:	00 
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	89 04 24             	mov    %eax,(%esp)
  801536:	e8 84 02 00 00       	call   8017bf <open>
  80153b:	89 c3                	mov    %eax,%ebx
  80153d:	85 db                	test   %ebx,%ebx
  80153f:	78 1b                	js     80155c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801541:	8b 45 0c             	mov    0xc(%ebp),%eax
  801544:	89 44 24 04          	mov    %eax,0x4(%esp)
  801548:	89 1c 24             	mov    %ebx,(%esp)
  80154b:	e8 56 ff ff ff       	call   8014a6 <fstat>
  801550:	89 c6                	mov    %eax,%esi
	close(fd);
  801552:	89 1c 24             	mov    %ebx,(%esp)
  801555:	e8 cd fb ff ff       	call   801127 <close>
	return r;
  80155a:	89 f0                	mov    %esi,%eax
}
  80155c:	83 c4 10             	add    $0x10,%esp
  80155f:	5b                   	pop    %ebx
  801560:	5e                   	pop    %esi
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    

00801563 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	56                   	push   %esi
  801567:	53                   	push   %ebx
  801568:	83 ec 10             	sub    $0x10,%esp
  80156b:	89 c6                	mov    %eax,%esi
  80156d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80156f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801576:	75 11                	jne    801589 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801578:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80157f:	e8 11 18 00 00       	call   802d95 <ipc_find_env>
  801584:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801589:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801590:	00 
  801591:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801598:	00 
  801599:	89 74 24 04          	mov    %esi,0x4(%esp)
  80159d:	a1 00 50 80 00       	mov    0x805000,%eax
  8015a2:	89 04 24             	mov    %eax,(%esp)
  8015a5:	e8 5e 17 00 00       	call   802d08 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015b1:	00 
  8015b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015bd:	e8 de 16 00 00       	call   802ca0 <ipc_recv>
}
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	5b                   	pop    %ebx
  8015c6:	5e                   	pop    %esi
  8015c7:	5d                   	pop    %ebp
  8015c8:	c3                   	ret    

008015c9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8015da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e7:	b8 02 00 00 00       	mov    $0x2,%eax
  8015ec:	e8 72 ff ff ff       	call   801563 <fsipc>
}
  8015f1:	c9                   	leave  
  8015f2:	c3                   	ret    

008015f3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8015f3:	55                   	push   %ebp
  8015f4:	89 e5                	mov    %esp,%ebp
  8015f6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ff:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801604:	ba 00 00 00 00       	mov    $0x0,%edx
  801609:	b8 06 00 00 00       	mov    $0x6,%eax
  80160e:	e8 50 ff ff ff       	call   801563 <fsipc>
}
  801613:	c9                   	leave  
  801614:	c3                   	ret    

00801615 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	53                   	push   %ebx
  801619:	83 ec 14             	sub    $0x14,%esp
  80161c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80161f:	8b 45 08             	mov    0x8(%ebp),%eax
  801622:	8b 40 0c             	mov    0xc(%eax),%eax
  801625:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80162a:	ba 00 00 00 00       	mov    $0x0,%edx
  80162f:	b8 05 00 00 00       	mov    $0x5,%eax
  801634:	e8 2a ff ff ff       	call   801563 <fsipc>
  801639:	89 c2                	mov    %eax,%edx
  80163b:	85 d2                	test   %edx,%edx
  80163d:	78 2b                	js     80166a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80163f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801646:	00 
  801647:	89 1c 24             	mov    %ebx,(%esp)
  80164a:	e8 c8 f1 ff ff       	call   800817 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80164f:	a1 80 60 80 00       	mov    0x806080,%eax
  801654:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80165a:	a1 84 60 80 00       	mov    0x806084,%eax
  80165f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801665:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80166a:	83 c4 14             	add    $0x14,%esp
  80166d:	5b                   	pop    %ebx
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    

00801670 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	53                   	push   %ebx
  801674:	83 ec 14             	sub    $0x14,%esp
  801677:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80167a:	8b 45 08             	mov    0x8(%ebp),%eax
  80167d:	8b 40 0c             	mov    0xc(%eax),%eax
  801680:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801685:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80168b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801690:	0f 46 c3             	cmovbe %ebx,%eax
  801693:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801698:	89 44 24 08          	mov    %eax,0x8(%esp)
  80169c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a3:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  8016aa:	e8 05 f3 ff ff       	call   8009b4 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016af:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b4:	b8 04 00 00 00       	mov    $0x4,%eax
  8016b9:	e8 a5 fe ff ff       	call   801563 <fsipc>
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	78 53                	js     801715 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  8016c2:	39 c3                	cmp    %eax,%ebx
  8016c4:	73 24                	jae    8016ea <devfile_write+0x7a>
  8016c6:	c7 44 24 0c e4 34 80 	movl   $0x8034e4,0xc(%esp)
  8016cd:	00 
  8016ce:	c7 44 24 08 eb 34 80 	movl   $0x8034eb,0x8(%esp)
  8016d5:	00 
  8016d6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  8016dd:	00 
  8016de:	c7 04 24 00 35 80 00 	movl   $0x803500,(%esp)
  8016e5:	e8 0a ea ff ff       	call   8000f4 <_panic>
	assert(r <= PGSIZE);
  8016ea:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016ef:	7e 24                	jle    801715 <devfile_write+0xa5>
  8016f1:	c7 44 24 0c 0b 35 80 	movl   $0x80350b,0xc(%esp)
  8016f8:	00 
  8016f9:	c7 44 24 08 eb 34 80 	movl   $0x8034eb,0x8(%esp)
  801700:	00 
  801701:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801708:	00 
  801709:	c7 04 24 00 35 80 00 	movl   $0x803500,(%esp)
  801710:	e8 df e9 ff ff       	call   8000f4 <_panic>
	return r;
}
  801715:	83 c4 14             	add    $0x14,%esp
  801718:	5b                   	pop    %ebx
  801719:	5d                   	pop    %ebp
  80171a:	c3                   	ret    

0080171b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	56                   	push   %esi
  80171f:	53                   	push   %ebx
  801720:	83 ec 10             	sub    $0x10,%esp
  801723:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	8b 40 0c             	mov    0xc(%eax),%eax
  80172c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801731:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801737:	ba 00 00 00 00       	mov    $0x0,%edx
  80173c:	b8 03 00 00 00       	mov    $0x3,%eax
  801741:	e8 1d fe ff ff       	call   801563 <fsipc>
  801746:	89 c3                	mov    %eax,%ebx
  801748:	85 c0                	test   %eax,%eax
  80174a:	78 6a                	js     8017b6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  80174c:	39 c6                	cmp    %eax,%esi
  80174e:	73 24                	jae    801774 <devfile_read+0x59>
  801750:	c7 44 24 0c e4 34 80 	movl   $0x8034e4,0xc(%esp)
  801757:	00 
  801758:	c7 44 24 08 eb 34 80 	movl   $0x8034eb,0x8(%esp)
  80175f:	00 
  801760:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801767:	00 
  801768:	c7 04 24 00 35 80 00 	movl   $0x803500,(%esp)
  80176f:	e8 80 e9 ff ff       	call   8000f4 <_panic>
	assert(r <= PGSIZE);
  801774:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801779:	7e 24                	jle    80179f <devfile_read+0x84>
  80177b:	c7 44 24 0c 0b 35 80 	movl   $0x80350b,0xc(%esp)
  801782:	00 
  801783:	c7 44 24 08 eb 34 80 	movl   $0x8034eb,0x8(%esp)
  80178a:	00 
  80178b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801792:	00 
  801793:	c7 04 24 00 35 80 00 	movl   $0x803500,(%esp)
  80179a:	e8 55 e9 ff ff       	call   8000f4 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80179f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017a3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8017aa:	00 
  8017ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ae:	89 04 24             	mov    %eax,(%esp)
  8017b1:	e8 fe f1 ff ff       	call   8009b4 <memmove>
	return r;
}
  8017b6:	89 d8                	mov    %ebx,%eax
  8017b8:	83 c4 10             	add    $0x10,%esp
  8017bb:	5b                   	pop    %ebx
  8017bc:	5e                   	pop    %esi
  8017bd:	5d                   	pop    %ebp
  8017be:	c3                   	ret    

008017bf <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	53                   	push   %ebx
  8017c3:	83 ec 24             	sub    $0x24,%esp
  8017c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8017c9:	89 1c 24             	mov    %ebx,(%esp)
  8017cc:	e8 0f f0 ff ff       	call   8007e0 <strlen>
  8017d1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017d6:	7f 60                	jg     801838 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8017d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017db:	89 04 24             	mov    %eax,(%esp)
  8017de:	e8 c4 f7 ff ff       	call   800fa7 <fd_alloc>
  8017e3:	89 c2                	mov    %eax,%edx
  8017e5:	85 d2                	test   %edx,%edx
  8017e7:	78 54                	js     80183d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8017e9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017ed:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  8017f4:	e8 1e f0 ff ff       	call   800817 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fc:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801801:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801804:	b8 01 00 00 00       	mov    $0x1,%eax
  801809:	e8 55 fd ff ff       	call   801563 <fsipc>
  80180e:	89 c3                	mov    %eax,%ebx
  801810:	85 c0                	test   %eax,%eax
  801812:	79 17                	jns    80182b <open+0x6c>
		fd_close(fd, 0);
  801814:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80181b:	00 
  80181c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181f:	89 04 24             	mov    %eax,(%esp)
  801822:	e8 7f f8 ff ff       	call   8010a6 <fd_close>
		return r;
  801827:	89 d8                	mov    %ebx,%eax
  801829:	eb 12                	jmp    80183d <open+0x7e>
	}

	return fd2num(fd);
  80182b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182e:	89 04 24             	mov    %eax,(%esp)
  801831:	e8 4a f7 ff ff       	call   800f80 <fd2num>
  801836:	eb 05                	jmp    80183d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801838:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80183d:	83 c4 24             	add    $0x24,%esp
  801840:	5b                   	pop    %ebx
  801841:	5d                   	pop    %ebp
  801842:	c3                   	ret    

00801843 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801849:	ba 00 00 00 00       	mov    $0x0,%edx
  80184e:	b8 08 00 00 00       	mov    $0x8,%eax
  801853:	e8 0b fd ff ff       	call   801563 <fsipc>
}
  801858:	c9                   	leave  
  801859:	c3                   	ret    
  80185a:	66 90                	xchg   %ax,%ax
  80185c:	66 90                	xchg   %ax,%ax
  80185e:	66 90                	xchg   %ax,%ax

00801860 <map_segment>:
}

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	57                   	push   %edi
  801864:	56                   	push   %esi
  801865:	53                   	push   %ebx
  801866:	83 ec 2c             	sub    $0x2c,%esp
  801869:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80186c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80186f:	89 d0                	mov    %edx,%eax
  801871:	25 ff 0f 00 00       	and    $0xfff,%eax
  801876:	74 0b                	je     801883 <map_segment+0x23>
		va -= i;
  801878:	29 c2                	sub    %eax,%edx
		memsz += i;
  80187a:	01 45 e4             	add    %eax,-0x1c(%ebp)
		filesz += i;
  80187d:	01 45 0c             	add    %eax,0xc(%ebp)
		fileoffset -= i;
  801880:	29 45 10             	sub    %eax,0x10(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801883:	89 d6                	mov    %edx,%esi
  801885:	bb 00 00 00 00       	mov    $0x0,%ebx
  80188a:	e9 ff 00 00 00       	jmp    80198e <map_segment+0x12e>
		if (i >= filesz) {
  80188f:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
  801892:	77 23                	ja     8018b7 <map_segment+0x57>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801894:	8b 45 14             	mov    0x14(%ebp),%eax
  801897:	89 44 24 08          	mov    %eax,0x8(%esp)
  80189b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80189f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a2:	89 04 24             	mov    %eax,(%esp)
  8018a5:	e8 89 f3 ff ff       	call   800c33 <sys_page_alloc>
  8018aa:	85 c0                	test   %eax,%eax
  8018ac:	0f 89 d0 00 00 00    	jns    801982 <map_segment+0x122>
  8018b2:	e9 e7 00 00 00       	jmp    80199e <map_segment+0x13e>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8018b7:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8018be:	00 
  8018bf:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8018c6:	00 
  8018c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018ce:	e8 60 f3 ff ff       	call   800c33 <sys_page_alloc>
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	0f 88 c3 00 00 00    	js     80199e <map_segment+0x13e>
  8018db:	89 f8                	mov    %edi,%eax
  8018dd:	03 45 10             	add    0x10(%ebp),%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8018e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	89 04 24             	mov    %eax,(%esp)
  8018ea:	e8 05 fb ff ff       	call   8013f4 <seek>
  8018ef:	85 c0                	test   %eax,%eax
  8018f1:	0f 88 a7 00 00 00    	js     80199e <map_segment+0x13e>
  8018f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fa:	29 f8                	sub    %edi,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8018fc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801901:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801906:	0f 47 c1             	cmova  %ecx,%eax
  801909:	89 44 24 08          	mov    %eax,0x8(%esp)
  80190d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801914:	00 
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	89 04 24             	mov    %eax,(%esp)
  80191b:	e8 fc f9 ff ff       	call   80131c <readn>
  801920:	85 c0                	test   %eax,%eax
  801922:	78 7a                	js     80199e <map_segment+0x13e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801924:	8b 45 14             	mov    0x14(%ebp),%eax
  801927:	89 44 24 10          	mov    %eax,0x10(%esp)
  80192b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80192f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801932:	89 44 24 08          	mov    %eax,0x8(%esp)
  801936:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80193d:	00 
  80193e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801945:	e8 3d f3 ff ff       	call   800c87 <sys_page_map>
  80194a:	85 c0                	test   %eax,%eax
  80194c:	79 20                	jns    80196e <map_segment+0x10e>
				panic("spawn: sys_page_map data: %e", r);
  80194e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801952:	c7 44 24 08 17 35 80 	movl   $0x803517,0x8(%esp)
  801959:	00 
  80195a:	c7 44 24 04 ac 01 00 	movl   $0x1ac,0x4(%esp)
  801961:	00 
  801962:	c7 04 24 34 35 80 00 	movl   $0x803534,(%esp)
  801969:	e8 86 e7 ff ff       	call   8000f4 <_panic>
			sys_page_unmap(0, UTEMP);
  80196e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801975:	00 
  801976:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80197d:	e8 58 f3 ff ff       	call   800cda <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801982:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801988:	81 c6 00 10 00 00    	add    $0x1000,%esi
  80198e:	89 df                	mov    %ebx,%edi
  801990:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  801993:	0f 87 f6 fe ff ff    	ja     80188f <map_segment+0x2f>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  801999:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80199e:	83 c4 2c             	add    $0x2c,%esp
  8019a1:	5b                   	pop    %ebx
  8019a2:	5e                   	pop    %esi
  8019a3:	5f                   	pop    %edi
  8019a4:	5d                   	pop    %ebp
  8019a5:	c3                   	ret    

008019a6 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	57                   	push   %edi
  8019aa:	56                   	push   %esi
  8019ab:	53                   	push   %ebx
  8019ac:	81 ec 8c 02 00 00    	sub    $0x28c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8019b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019b9:	00 
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	89 04 24             	mov    %eax,(%esp)
  8019c0:	e8 fa fd ff ff       	call   8017bf <open>
  8019c5:	89 c1                	mov    %eax,%ecx
  8019c7:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  8019cd:	85 c0                	test   %eax,%eax
  8019cf:	0f 88 9f 03 00 00    	js     801d74 <spawn+0x3ce>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8019d5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8019dc:	00 
  8019dd:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8019e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e7:	89 0c 24             	mov    %ecx,(%esp)
  8019ea:	e8 2d f9 ff ff       	call   80131c <readn>
  8019ef:	3d 00 02 00 00       	cmp    $0x200,%eax
  8019f4:	75 0c                	jne    801a02 <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  8019f6:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8019fd:	45 4c 46 
  801a00:	74 36                	je     801a38 <spawn+0x92>
		close(fd);
  801a02:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801a08:	89 04 24             	mov    %eax,(%esp)
  801a0b:	e8 17 f7 ff ff       	call   801127 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801a10:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801a17:	46 
  801a18:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a22:	c7 04 24 40 35 80 00 	movl   $0x803540,(%esp)
  801a29:	e8 bf e7 ff ff       	call   8001ed <cprintf>
		return -E_NOT_EXEC;
  801a2e:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801a33:	e9 c0 03 00 00       	jmp    801df8 <spawn+0x452>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801a38:	b8 07 00 00 00       	mov    $0x7,%eax
  801a3d:	cd 30                	int    $0x30
  801a3f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  801a45:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801a4b:	85 c0                	test   %eax,%eax
  801a4d:	0f 88 29 03 00 00    	js     801d7c <spawn+0x3d6>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801a53:	89 c6                	mov    %eax,%esi
  801a55:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801a5b:	c1 e6 07             	shl    $0x7,%esi
  801a5e:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801a64:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801a6a:	b9 11 00 00 00       	mov    $0x11,%ecx
  801a6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801a71:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801a77:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a7d:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801a82:	be 00 00 00 00       	mov    $0x0,%esi
  801a87:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801a8a:	eb 0f                	jmp    801a9b <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801a8c:	89 04 24             	mov    %eax,(%esp)
  801a8f:	e8 4c ed ff ff       	call   8007e0 <strlen>
  801a94:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a98:	83 c3 01             	add    $0x1,%ebx
  801a9b:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801aa2:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	75 e3                	jne    801a8c <spawn+0xe6>
  801aa9:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
  801aaf:	89 8d 7c fd ff ff    	mov    %ecx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801ab5:	bf 00 10 40 00       	mov    $0x401000,%edi
  801aba:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801abc:	89 fa                	mov    %edi,%edx
  801abe:	83 e2 fc             	and    $0xfffffffc,%edx
  801ac1:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801ac8:	29 c2                	sub    %eax,%edx
  801aca:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801ad0:	8d 42 f8             	lea    -0x8(%edx),%eax
  801ad3:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801ad8:	0f 86 ae 02 00 00    	jbe    801d8c <spawn+0x3e6>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ade:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801ae5:	00 
  801ae6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801aed:	00 
  801aee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801af5:	e8 39 f1 ff ff       	call   800c33 <sys_page_alloc>
  801afa:	85 c0                	test   %eax,%eax
  801afc:	0f 88 f6 02 00 00    	js     801df8 <spawn+0x452>
  801b02:	be 00 00 00 00       	mov    $0x0,%esi
  801b07:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801b0d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801b10:	eb 30                	jmp    801b42 <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801b12:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801b18:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801b1e:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801b21:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b28:	89 3c 24             	mov    %edi,(%esp)
  801b2b:	e8 e7 ec ff ff       	call   800817 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801b30:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801b33:	89 04 24             	mov    %eax,(%esp)
  801b36:	e8 a5 ec ff ff       	call   8007e0 <strlen>
  801b3b:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801b3f:	83 c6 01             	add    $0x1,%esi
  801b42:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  801b48:	7c c8                	jl     801b12 <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801b4a:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b50:	8b 8d 7c fd ff ff    	mov    -0x284(%ebp),%ecx
  801b56:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b5d:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801b63:	74 24                	je     801b89 <spawn+0x1e3>
  801b65:	c7 44 24 0c b8 35 80 	movl   $0x8035b8,0xc(%esp)
  801b6c:	00 
  801b6d:	c7 44 24 08 eb 34 80 	movl   $0x8034eb,0x8(%esp)
  801b74:	00 
  801b75:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
  801b7c:	00 
  801b7d:	c7 04 24 34 35 80 00 	movl   $0x803534,(%esp)
  801b84:	e8 6b e5 ff ff       	call   8000f4 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801b89:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801b8f:	89 c8                	mov    %ecx,%eax
  801b91:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801b96:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801b99:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801b9f:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801ba2:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801ba8:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801bae:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801bb5:	00 
  801bb6:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801bbd:	ee 
  801bbe:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801bc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bc8:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801bcf:	00 
  801bd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bd7:	e8 ab f0 ff ff       	call   800c87 <sys_page_map>
  801bdc:	89 c7                	mov    %eax,%edi
  801bde:	85 c0                	test   %eax,%eax
  801be0:	0f 88 fc 01 00 00    	js     801de2 <spawn+0x43c>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801be6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801bed:	00 
  801bee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bf5:	e8 e0 f0 ff ff       	call   800cda <sys_page_unmap>
  801bfa:	89 c7                	mov    %eax,%edi
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	0f 88 de 01 00 00    	js     801de2 <spawn+0x43c>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801c04:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801c0a:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c11:	be 00 00 00 00       	mov    $0x0,%esi
  801c16:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  801c1c:	eb 4a                	jmp    801c68 <spawn+0x2c2>
		if (ph->p_type != ELF_PROG_LOAD)
  801c1e:	83 3b 01             	cmpl   $0x1,(%ebx)
  801c21:	75 3f                	jne    801c62 <spawn+0x2bc>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801c23:	8b 43 18             	mov    0x18(%ebx),%eax
  801c26:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801c29:	83 f8 01             	cmp    $0x1,%eax
  801c2c:	19 c0                	sbb    %eax,%eax
  801c2e:	83 e0 fe             	and    $0xfffffffe,%eax
  801c31:	83 c0 07             	add    $0x7,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801c34:	8b 4b 14             	mov    0x14(%ebx),%ecx
  801c37:	8b 53 08             	mov    0x8(%ebx),%edx
  801c3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c3e:	8b 43 04             	mov    0x4(%ebx),%eax
  801c41:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c45:	8b 43 10             	mov    0x10(%ebx),%eax
  801c48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4c:	89 3c 24             	mov    %edi,(%esp)
  801c4f:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801c55:	e8 06 fc ff ff       	call   801860 <map_segment>
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	0f 88 ed 00 00 00    	js     801d4f <spawn+0x3a9>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c62:	83 c6 01             	add    $0x1,%esi
  801c65:	83 c3 20             	add    $0x20,%ebx
  801c68:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801c6f:	39 c6                	cmp    %eax,%esi
  801c71:	7c ab                	jl     801c1e <spawn+0x278>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801c73:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801c79:	89 04 24             	mov    %eax,(%esp)
  801c7c:	e8 a6 f4 ff ff       	call   801127 <close>
	uint8_t *addr, *end_addr;
    int perm;
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
  801c81:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c86:	8b b5 8c fd ff ff    	mov    -0x274(%ebp),%esi
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)) {
  801c8c:	89 d8                	mov    %ebx,%eax
  801c8e:	c1 e8 16             	shr    $0x16,%eax
  801c91:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c98:	a8 01                	test   $0x1,%al
  801c9a:	74 46                	je     801ce2 <spawn+0x33c>
  801c9c:	89 d8                	mov    %ebx,%eax
  801c9e:	c1 e8 0c             	shr    $0xc,%eax
  801ca1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ca8:	f6 c2 01             	test   $0x1,%dl
  801cab:	74 35                	je     801ce2 <spawn+0x33c>
			perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  801cad:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
            if (perm & PTE_SHARE) {
  801cb4:	f6 c4 04             	test   $0x4,%ah
  801cb7:	74 29                	je     801ce2 <spawn+0x33c>
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)) {
			perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  801cb9:	25 07 0e 00 00       	and    $0xe07,%eax
            if (perm & PTE_SHARE) {
                if ((r = sys_page_map(0, addr, child, addr, perm)) < 0) 
  801cbe:	89 44 24 10          	mov    %eax,0x10(%esp)
  801cc2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801cc6:	89 74 24 08          	mov    %esi,0x8(%esp)
  801cca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cd5:	e8 ad ef ff ff       	call   800c87 <sys_page_map>
  801cda:	85 c0                	test   %eax,%eax
  801cdc:	0f 88 b1 00 00 00    	js     801d93 <spawn+0x3ed>
	uint8_t *addr, *end_addr;
    int perm;
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
  801ce2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ce8:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801cee:	75 9c                	jne    801c8c <spawn+0x2e6>
  801cf0:	e9 be 00 00 00       	jmp    801db3 <spawn+0x40d>
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  801cf5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cf9:	c7 44 24 08 5a 35 80 	movl   $0x80355a,0x8(%esp)
  801d00:	00 
  801d01:	c7 44 24 04 8b 00 00 	movl   $0x8b,0x4(%esp)
  801d08:	00 
  801d09:	c7 04 24 34 35 80 00 	movl   $0x803534,(%esp)
  801d10:	e8 df e3 ff ff       	call   8000f4 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801d15:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801d1c:	00 
  801d1d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801d23:	89 04 24             	mov    %eax,(%esp)
  801d26:	e8 02 f0 ff ff       	call   800d2d <sys_env_set_status>
  801d2b:	85 c0                	test   %eax,%eax
  801d2d:	79 55                	jns    801d84 <spawn+0x3de>
		panic("sys_env_set_status: %e", r);
  801d2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d33:	c7 44 24 08 74 35 80 	movl   $0x803574,0x8(%esp)
  801d3a:	00 
  801d3b:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  801d42:	00 
  801d43:	c7 04 24 34 35 80 00 	movl   $0x803534,(%esp)
  801d4a:	e8 a5 e3 ff ff       	call   8000f4 <_panic>
  801d4f:	89 c7                	mov    %eax,%edi

	return child;

error:
	sys_env_destroy(child);
  801d51:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801d57:	89 04 24             	mov    %eax,(%esp)
  801d5a:	e8 44 ee ff ff       	call   800ba3 <sys_env_destroy>
	close(fd);
  801d5f:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d65:	89 04 24             	mov    %eax,(%esp)
  801d68:	e8 ba f3 ff ff       	call   801127 <close>
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801d6d:	89 f8                	mov    %edi,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801d6f:	e9 84 00 00 00       	jmp    801df8 <spawn+0x452>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801d74:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d7a:	eb 7c                	jmp    801df8 <spawn+0x452>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801d7c:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801d82:	eb 74                	jmp    801df8 <spawn+0x452>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  801d84:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801d8a:	eb 6c                	jmp    801df8 <spawn+0x452>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  801d8c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  801d91:	eb 65                	jmp    801df8 <spawn+0x452>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  801d93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d97:	c7 44 24 08 8b 35 80 	movl   $0x80358b,0x8(%esp)
  801d9e:	00 
  801d9f:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801da6:	00 
  801da7:	c7 04 24 34 35 80 00 	movl   $0x803534,(%esp)
  801dae:	e8 41 e3 ff ff       	call   8000f4 <_panic>

	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801db3:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801dba:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801dbd:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801dc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc7:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801dcd:	89 04 24             	mov    %eax,(%esp)
  801dd0:	e8 ab ef ff ff       	call   800d80 <sys_env_set_trapframe>
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	0f 89 38 ff ff ff    	jns    801d15 <spawn+0x36f>
  801ddd:	e9 13 ff ff ff       	jmp    801cf5 <spawn+0x34f>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801de2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801de9:	00 
  801dea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801df1:	e8 e4 ee ff ff       	call   800cda <sys_page_unmap>
  801df6:	89 f8                	mov    %edi,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801df8:	81 c4 8c 02 00 00    	add    $0x28c,%esp
  801dfe:	5b                   	pop    %ebx
  801dff:	5e                   	pop    %esi
  801e00:	5f                   	pop    %edi
  801e01:	5d                   	pop    %ebp
  801e02:	c3                   	ret    

00801e03 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	56                   	push   %esi
  801e07:	53                   	push   %ebx
  801e08:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801e0b:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  801e0e:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801e13:	eb 03                	jmp    801e18 <spawnl+0x15>
		argc++;
  801e15:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801e18:	83 c0 04             	add    $0x4,%eax
  801e1b:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  801e1f:	75 f4                	jne    801e15 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801e21:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  801e28:	83 e0 f0             	and    $0xfffffff0,%eax
  801e2b:	29 c4                	sub    %eax,%esp
  801e2d:	8d 44 24 0b          	lea    0xb(%esp),%eax
  801e31:	c1 e8 02             	shr    $0x2,%eax
  801e34:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  801e3b:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801e3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e40:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  801e47:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  801e4e:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801e4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e54:	eb 0a                	jmp    801e60 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  801e56:	83 c0 01             	add    $0x1,%eax
  801e59:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  801e5d:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801e60:	39 d0                	cmp    %edx,%eax
  801e62:	75 f2                	jne    801e56 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801e64:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	89 04 24             	mov    %eax,(%esp)
  801e6e:	e8 33 fb ff ff       	call   8019a6 <spawn>
}
  801e73:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e76:	5b                   	pop    %ebx
  801e77:	5e                   	pop    %esi
  801e78:	5d                   	pop    %ebp
  801e79:	c3                   	ret    

00801e7a <exec>:

int
exec(const char *prog, const char **argv)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	57                   	push   %edi
  801e7e:	56                   	push   %esi
  801e7f:	53                   	push   %ebx
  801e80:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
	int fd, i, r;
	struct Elf *elf;
	struct Proghdr *ph;
	int perm;	

	if ((r = open(prog, O_RDONLY)) < 0)
  801e86:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e8d:	00 
  801e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e91:	89 04 24             	mov    %eax,(%esp)
  801e94:	e8 26 f9 ff ff       	call   8017bf <open>
  801e99:	89 c7                	mov    %eax,%edi
  801e9b:	85 c0                	test   %eax,%eax
  801e9d:	0f 88 14 03 00 00    	js     8021b7 <exec+0x33d>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801ea3:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801eaa:	00 
  801eab:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb5:	89 3c 24             	mov    %edi,(%esp)
  801eb8:	e8 5f f4 ff ff       	call   80131c <readn>
  801ebd:	3d 00 02 00 00       	cmp    $0x200,%eax
  801ec2:	75 0c                	jne    801ed0 <exec+0x56>
	    || elf->e_magic != ELF_MAGIC) {
  801ec4:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801ecb:	45 4c 46 
  801ece:	74 30                	je     801f00 <exec+0x86>
		close(fd);
  801ed0:	89 3c 24             	mov    %edi,(%esp)
  801ed3:	e8 4f f2 ff ff       	call   801127 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801ed8:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801edf:	46 
  801ee0:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801ee6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eea:	c7 04 24 40 35 80 00 	movl   $0x803540,(%esp)
  801ef1:	e8 f7 e2 ff ff       	call   8001ed <cprintf>
		return -E_NOT_EXEC;
  801ef6:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801efb:	e9 d8 02 00 00       	jmp    8021d8 <exec+0x35e>
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801f00:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801f06:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
  801f0d:	b8 00 00 00 e0       	mov    $0xe0000000,%eax
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f12:	be 00 00 00 00       	mov    $0x0,%esi
  801f17:	89 bd e4 fd ff ff    	mov    %edi,-0x21c(%ebp)
  801f1d:	89 c7                	mov    %eax,%edi
  801f1f:	eb 71                	jmp    801f92 <exec+0x118>
		if (ph->p_type != ELF_PROG_LOAD)
  801f21:	83 3b 01             	cmpl   $0x1,(%ebx)
  801f24:	75 66                	jne    801f8c <exec+0x112>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801f26:	8b 43 18             	mov    0x18(%ebx),%eax
  801f29:	83 e0 02             	and    $0x2,%eax
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801f2c:	83 f8 01             	cmp    $0x1,%eax
  801f2f:	19 c0                	sbb    %eax,%eax
  801f31:	83 e0 fe             	and    $0xfffffffe,%eax
  801f34:	83 c0 07             	add    $0x7,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(0, PGOFF(ph->p_va) + tmp, ph->p_memsz,
  801f37:	8b 4b 14             	mov    0x14(%ebx),%ecx
  801f3a:	8b 53 08             	mov    0x8(%ebx),%edx
  801f3d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  801f43:	01 fa                	add    %edi,%edx
  801f45:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f49:	8b 43 04             	mov    0x4(%ebx),%eax
  801f4c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f50:	8b 43 10             	mov    0x10(%ebx),%eax
  801f53:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f57:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
  801f5d:	89 04 24             	mov    %eax,(%esp)
  801f60:	b8 00 00 00 00       	mov    $0x0,%eax
  801f65:	e8 f6 f8 ff ff       	call   801860 <map_segment>
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	0f 88 25 02 00 00    	js     802197 <exec+0x31d>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
  801f72:	8b 53 14             	mov    0x14(%ebx),%edx
  801f75:	8b 43 08             	mov    0x8(%ebx),%eax
  801f78:	25 ff 0f 00 00       	and    $0xfff,%eax
  801f7d:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
  801f84:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f89:	8d 3c 38             	lea    (%eax,%edi,1),%edi
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f8c:	83 c6 01             	add    $0x1,%esi
  801f8f:	83 c3 20             	add    $0x20,%ebx
  801f92:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801f99:	39 c6                	cmp    %eax,%esi
  801f9b:	7c 84                	jl     801f21 <exec+0xa7>
  801f9d:	89 bd dc fd ff ff    	mov    %edi,-0x224(%ebp)
  801fa3:	8b bd e4 fd ff ff    	mov    -0x21c(%ebp),%edi
		if ((r = map_segment(0, PGOFF(ph->p_va) + tmp, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
	}
	close(fd);
  801fa9:	89 3c 24             	mov    %edi,(%esp)
  801fac:	e8 76 f1 ff ff       	call   801127 <close>
	fd = -1;
	cprintf("tf_esp: %x\n", tf_esp);
  801fb1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fb8:	00 
  801fb9:	c7 04 24 a1 35 80 00 	movl   $0x8035a1,(%esp)
  801fc0:	e8 28 e2 ff ff       	call   8001ed <cprintf>
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801fc5:	bb 00 00 00 00       	mov    $0x0,%ebx
	size_t string_size;
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
  801fca:	be 00 00 00 00       	mov    $0x0,%esi
  801fcf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801fd2:	eb 0f                	jmp    801fe3 <exec+0x169>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801fd4:	89 04 24             	mov    %eax,(%esp)
  801fd7:	e8 04 e8 ff ff       	call   8007e0 <strlen>
  801fdc:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801fe0:	83 c3 01             	add    $0x1,%ebx
  801fe3:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801fea:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801fed:	85 c0                	test   %eax,%eax
  801fef:	75 e3                	jne    801fd4 <exec+0x15a>
  801ff1:	89 9d d8 fd ff ff    	mov    %ebx,-0x228(%ebp)
  801ff7:	89 8d d4 fd ff ff    	mov    %ecx,-0x22c(%ebp)
		string_size += strlen(argv[argc]) + 1;

	string_store = (char*) UTEMP + PGSIZE - string_size;
  801ffd:	bf 00 10 40 00       	mov    $0x401000,%edi
  802002:	29 f7                	sub    %esi,%edi
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802004:	89 fa                	mov    %edi,%edx
  802006:	83 e2 fc             	and    $0xfffffffc,%edx
  802009:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802010:	29 c2                	sub    %eax,%edx
  802012:	89 95 e4 fd ff ff    	mov    %edx,-0x21c(%ebp)
	
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802018:	8d 42 f8             	lea    -0x8(%edx),%eax
  80201b:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802020:	0f 86 93 01 00 00    	jbe    8021b9 <exec+0x33f>
		return -E_NO_MEM;

	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802026:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80202d:	00 
  80202e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802035:	00 
  802036:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80203d:	e8 f1 eb ff ff       	call   800c33 <sys_page_alloc>
  802042:	85 c0                	test   %eax,%eax
  802044:	0f 88 8e 01 00 00    	js     8021d8 <exec+0x35e>
  80204a:	be 00 00 00 00       	mov    $0x0,%esi
  80204f:	89 9d e0 fd ff ff    	mov    %ebx,-0x220(%ebp)
  802055:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802058:	eb 30                	jmp    80208a <exec+0x210>
		return r;

	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  80205a:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802060:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
  802066:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802069:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80206c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802070:	89 3c 24             	mov    %edi,(%esp)
  802073:	e8 9f e7 ff ff       	call   800817 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802078:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80207b:	89 04 24             	mov    %eax,(%esp)
  80207e:	e8 5d e7 ff ff       	call   8007e0 <strlen>
  802083:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
		return -E_NO_MEM;

	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		return r;

	for (i = 0; i < argc; i++) {
  802087:	83 c6 01             	add    $0x1,%esi
  80208a:	39 b5 e0 fd ff ff    	cmp    %esi,-0x220(%ebp)
  802090:	7f c8                	jg     80205a <exec+0x1e0>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802092:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
  802098:	8b 8d d4 fd ff ff    	mov    -0x22c(%ebp),%ecx
  80209e:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8020a5:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8020ab:	74 24                	je     8020d1 <exec+0x257>
  8020ad:	c7 44 24 0c b8 35 80 	movl   $0x8035b8,0xc(%esp)
  8020b4:	00 
  8020b5:	c7 44 24 08 eb 34 80 	movl   $0x8034eb,0x8(%esp)
  8020bc:	00 
  8020bd:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
  8020c4:	00 
  8020c5:	c7 04 24 34 35 80 00 	movl   $0x803534,(%esp)
  8020cc:	e8 23 e0 ff ff       	call   8000f4 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8020d1:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
  8020d7:	89 c8                	mov    %ecx,%eax
  8020d9:	2d 00 30 80 11       	sub    $0x11803000,%eax
  8020de:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8020e1:	8b 85 d8 fd ff ff    	mov    -0x228(%ebp),%eax
  8020e7:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8020ea:	8d 99 f8 cf 7f ee    	lea    -0x11803008(%ecx),%ebx

	cprintf("stack: %x\n", stack);
  8020f0:	8b bd dc fd ff ff    	mov    -0x224(%ebp),%edi
  8020f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8020fa:	c7 04 24 ad 35 80 00 	movl   $0x8035ad,(%esp)
  802101:	e8 e7 e0 ff ff       	call   8001ed <cprintf>
	if ((r = sys_page_map(0, UTEMP, child, (void*) stack, PTE_P | PTE_U | PTE_W)) < 0)
  802106:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80210d:	00 
  80210e:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802112:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802119:	00 
  80211a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802121:	00 
  802122:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802129:	e8 59 eb ff ff       	call   800c87 <sys_page_map>
  80212e:	89 c7                	mov    %eax,%edi
  802130:	85 c0                	test   %eax,%eax
  802132:	0f 88 8a 00 00 00    	js     8021c2 <exec+0x348>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802138:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80213f:	00 
  802140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802147:	e8 8e eb ff ff       	call   800cda <sys_page_unmap>
  80214c:	89 c7                	mov    %eax,%edi
  80214e:	85 c0                	test   %eax,%eax
  802150:	78 70                	js     8021c2 <exec+0x348>
	// cprintf("tf_eip: %x\n", tf_eip);
	if ((r = init_stack_with_addr(0, argv, &tf_esp, tmp)) < 0)
		return r;

	// Syscall to exec
	if (sys_exec(elf->e_entry, tf_esp, (void *)(elf_buf + elf->e_phoff), elf->e_phnum) < 0)
  802152:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802159:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80215d:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802163:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  80216a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80216e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802172:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802178:	89 04 24             	mov    %eax,(%esp)
  80217b:	e8 9c ed ff ff       	call   800f1c <sys_exec>
  802180:	89 c2                	mov    %eax,%edx
		goto error;
	return 0;
  802182:	b8 00 00 00 00       	mov    $0x0,%eax
  802187:	be 00 00 00 00       	mov    $0x0,%esi
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
	}
	close(fd);
	fd = -1;
  80218c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
	// cprintf("tf_eip: %x\n", tf_eip);
	if ((r = init_stack_with_addr(0, argv, &tf_esp, tmp)) < 0)
		return r;

	// Syscall to exec
	if (sys_exec(elf->e_entry, tf_esp, (void *)(elf_buf + elf->e_phoff), elf->e_phnum) < 0)
  802191:	85 d2                	test   %edx,%edx
  802193:	78 0a                	js     80219f <exec+0x325>
  802195:	eb 41                	jmp    8021d8 <exec+0x35e>
  802197:	8b bd e4 fd ff ff    	mov    -0x21c(%ebp),%edi
  80219d:	89 c6                	mov    %eax,%esi
		goto error;
	return 0;

error:
	sys_env_destroy(0);
  80219f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a6:	e8 f8 e9 ff ff       	call   800ba3 <sys_env_destroy>
	close(fd);
  8021ab:	89 3c 24             	mov    %edi,(%esp)
  8021ae:	e8 74 ef ff ff       	call   801127 <close>
	return r;
  8021b3:	89 f0                	mov    %esi,%eax
  8021b5:	eb 21                	jmp    8021d8 <exec+0x35e>
  8021b7:	eb 1f                	jmp    8021d8 <exec+0x35e>

	string_store = (char*) UTEMP + PGSIZE - string_size;
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  8021b9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8021be:	66 90                	xchg   %ax,%ax
  8021c0:	eb 16                	jmp    8021d8 <exec+0x35e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8021c2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8021c9:	00 
  8021ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d1:	e8 04 eb ff ff       	call   800cda <sys_page_unmap>
  8021d6:	89 f8                	mov    %edi,%eax

error:
	sys_env_destroy(0);
	close(fd);
	return r;
}
  8021d8:	81 c4 3c 02 00 00    	add    $0x23c,%esp
  8021de:	5b                   	pop    %ebx
  8021df:	5e                   	pop    %esi
  8021e0:	5f                   	pop    %edi
  8021e1:	5d                   	pop    %ebp
  8021e2:	c3                   	ret    

008021e3 <execl>:

int
execl(const char *prog, const char *arg0, ...)
{
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
  8021e6:	56                   	push   %esi
  8021e7:	53                   	push   %ebx
  8021e8:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8021eb:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8021ee:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8021f3:	eb 03                	jmp    8021f8 <execl+0x15>
		argc++;
  8021f5:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8021f8:	83 c0 04             	add    $0x4,%eax
  8021fb:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  8021ff:	75 f4                	jne    8021f5 <execl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802201:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  802208:	83 e0 f0             	and    $0xfffffff0,%eax
  80220b:	29 c4                	sub    %eax,%esp
  80220d:	8d 44 24 0b          	lea    0xb(%esp),%eax
  802211:	c1 e8 02             	shr    $0x2,%eax
  802214:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  80221b:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80221d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802220:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  802227:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  80222e:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80222f:	b8 00 00 00 00       	mov    $0x0,%eax
  802234:	eb 0a                	jmp    802240 <execl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  802236:	83 c0 01             	add    $0x1,%eax
  802239:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  80223d:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802240:	39 d0                	cmp    %edx,%eax
  802242:	75 f2                	jne    802236 <execl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return exec(prog, argv);
  802244:	89 74 24 04          	mov    %esi,0x4(%esp)
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	89 04 24             	mov    %eax,(%esp)
  80224e:	e8 27 fc ff ff       	call   801e7a <exec>
}
  802253:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802256:	5b                   	pop    %ebx
  802257:	5e                   	pop    %esi
  802258:	5d                   	pop    %ebp
  802259:	c3                   	ret    
  80225a:	66 90                	xchg   %ax,%ax
  80225c:	66 90                	xchg   %ax,%ax
  80225e:	66 90                	xchg   %ax,%ax

00802260 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802266:	c7 44 24 04 e0 35 80 	movl   $0x8035e0,0x4(%esp)
  80226d:	00 
  80226e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802271:	89 04 24             	mov    %eax,(%esp)
  802274:	e8 9e e5 ff ff       	call   800817 <strcpy>
	return 0;
}
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
  802283:	53                   	push   %ebx
  802284:	83 ec 14             	sub    $0x14,%esp
  802287:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80228a:	89 1c 24             	mov    %ebx,(%esp)
  80228d:	e8 3d 0b 00 00       	call   802dcf <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802292:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802297:	83 f8 01             	cmp    $0x1,%eax
  80229a:	75 0d                	jne    8022a9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80229c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80229f:	89 04 24             	mov    %eax,(%esp)
  8022a2:	e8 29 03 00 00       	call   8025d0 <nsipc_close>
  8022a7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8022a9:	89 d0                	mov    %edx,%eax
  8022ab:	83 c4 14             	add    $0x14,%esp
  8022ae:	5b                   	pop    %ebx
  8022af:	5d                   	pop    %ebp
  8022b0:	c3                   	ret    

008022b1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8022b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8022be:	00 
  8022bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d3:	89 04 24             	mov    %eax,(%esp)
  8022d6:	e8 f0 03 00 00       	call   8026cb <nsipc_send>
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8022e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8022ea:	00 
  8022eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8022ff:	89 04 24             	mov    %eax,(%esp)
  802302:	e8 44 03 00 00       	call   80264b <nsipc_recv>
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
  80230c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80230f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802312:	89 54 24 04          	mov    %edx,0x4(%esp)
  802316:	89 04 24             	mov    %eax,(%esp)
  802319:	e8 d8 ec ff ff       	call   800ff6 <fd_lookup>
  80231e:	85 c0                	test   %eax,%eax
  802320:	78 17                	js     802339 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802325:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  80232b:	39 08                	cmp    %ecx,(%eax)
  80232d:	75 05                	jne    802334 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80232f:	8b 40 0c             	mov    0xc(%eax),%eax
  802332:	eb 05                	jmp    802339 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802334:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	56                   	push   %esi
  80233f:	53                   	push   %ebx
  802340:	83 ec 20             	sub    $0x20,%esp
  802343:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802345:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802348:	89 04 24             	mov    %eax,(%esp)
  80234b:	e8 57 ec ff ff       	call   800fa7 <fd_alloc>
  802350:	89 c3                	mov    %eax,%ebx
  802352:	85 c0                	test   %eax,%eax
  802354:	78 21                	js     802377 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802356:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80235d:	00 
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	89 44 24 04          	mov    %eax,0x4(%esp)
  802365:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80236c:	e8 c2 e8 ff ff       	call   800c33 <sys_page_alloc>
  802371:	89 c3                	mov    %eax,%ebx
  802373:	85 c0                	test   %eax,%eax
  802375:	79 0c                	jns    802383 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802377:	89 34 24             	mov    %esi,(%esp)
  80237a:	e8 51 02 00 00       	call   8025d0 <nsipc_close>
		return r;
  80237f:	89 d8                	mov    %ebx,%eax
  802381:	eb 20                	jmp    8023a3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802383:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80238e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802391:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802398:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80239b:	89 14 24             	mov    %edx,(%esp)
  80239e:	e8 dd eb ff ff       	call   800f80 <fd2num>
}
  8023a3:	83 c4 20             	add    $0x20,%esp
  8023a6:	5b                   	pop    %ebx
  8023a7:	5e                   	pop    %esi
  8023a8:	5d                   	pop    %ebp
  8023a9:	c3                   	ret    

008023aa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	e8 51 ff ff ff       	call   802309 <fd2sockid>
		return r;
  8023b8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8023ba:	85 c0                	test   %eax,%eax
  8023bc:	78 23                	js     8023e1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8023be:	8b 55 10             	mov    0x10(%ebp),%edx
  8023c1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023cc:	89 04 24             	mov    %eax,(%esp)
  8023cf:	e8 45 01 00 00       	call   802519 <nsipc_accept>
		return r;
  8023d4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	78 07                	js     8023e1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8023da:	e8 5c ff ff ff       	call   80233b <alloc_sockfd>
  8023df:	89 c1                	mov    %eax,%ecx
}
  8023e1:	89 c8                	mov    %ecx,%eax
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
  8023e8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8023eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ee:	e8 16 ff ff ff       	call   802309 <fd2sockid>
  8023f3:	89 c2                	mov    %eax,%edx
  8023f5:	85 d2                	test   %edx,%edx
  8023f7:	78 16                	js     80240f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8023f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8023fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802400:	8b 45 0c             	mov    0xc(%ebp),%eax
  802403:	89 44 24 04          	mov    %eax,0x4(%esp)
  802407:	89 14 24             	mov    %edx,(%esp)
  80240a:	e8 60 01 00 00       	call   80256f <nsipc_bind>
}
  80240f:	c9                   	leave  
  802410:	c3                   	ret    

00802411 <shutdown>:

int
shutdown(int s, int how)
{
  802411:	55                   	push   %ebp
  802412:	89 e5                	mov    %esp,%ebp
  802414:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802417:	8b 45 08             	mov    0x8(%ebp),%eax
  80241a:	e8 ea fe ff ff       	call   802309 <fd2sockid>
  80241f:	89 c2                	mov    %eax,%edx
  802421:	85 d2                	test   %edx,%edx
  802423:	78 0f                	js     802434 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802425:	8b 45 0c             	mov    0xc(%ebp),%eax
  802428:	89 44 24 04          	mov    %eax,0x4(%esp)
  80242c:	89 14 24             	mov    %edx,(%esp)
  80242f:	e8 7a 01 00 00       	call   8025ae <nsipc_shutdown>
}
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
  802439:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80243c:	8b 45 08             	mov    0x8(%ebp),%eax
  80243f:	e8 c5 fe ff ff       	call   802309 <fd2sockid>
  802444:	89 c2                	mov    %eax,%edx
  802446:	85 d2                	test   %edx,%edx
  802448:	78 16                	js     802460 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80244a:	8b 45 10             	mov    0x10(%ebp),%eax
  80244d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802451:	8b 45 0c             	mov    0xc(%ebp),%eax
  802454:	89 44 24 04          	mov    %eax,0x4(%esp)
  802458:	89 14 24             	mov    %edx,(%esp)
  80245b:	e8 8a 01 00 00       	call   8025ea <nsipc_connect>
}
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <listen>:

int
listen(int s, int backlog)
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
  802465:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	e8 99 fe ff ff       	call   802309 <fd2sockid>
  802470:	89 c2                	mov    %eax,%edx
  802472:	85 d2                	test   %edx,%edx
  802474:	78 0f                	js     802485 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802476:	8b 45 0c             	mov    0xc(%ebp),%eax
  802479:	89 44 24 04          	mov    %eax,0x4(%esp)
  80247d:	89 14 24             	mov    %edx,(%esp)
  802480:	e8 a4 01 00 00       	call   802629 <nsipc_listen>
}
  802485:	c9                   	leave  
  802486:	c3                   	ret    

00802487 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802487:	55                   	push   %ebp
  802488:	89 e5                	mov    %esp,%ebp
  80248a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80248d:	8b 45 10             	mov    0x10(%ebp),%eax
  802490:	89 44 24 08          	mov    %eax,0x8(%esp)
  802494:	8b 45 0c             	mov    0xc(%ebp),%eax
  802497:	89 44 24 04          	mov    %eax,0x4(%esp)
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	89 04 24             	mov    %eax,(%esp)
  8024a1:	e8 98 02 00 00       	call   80273e <nsipc_socket>
  8024a6:	89 c2                	mov    %eax,%edx
  8024a8:	85 d2                	test   %edx,%edx
  8024aa:	78 05                	js     8024b1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8024ac:	e8 8a fe ff ff       	call   80233b <alloc_sockfd>
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
  8024b6:	53                   	push   %ebx
  8024b7:	83 ec 14             	sub    $0x14,%esp
  8024ba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8024bc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8024c3:	75 11                	jne    8024d6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8024c5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8024cc:	e8 c4 08 00 00       	call   802d95 <ipc_find_env>
  8024d1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8024d6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8024dd:	00 
  8024de:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8024e5:	00 
  8024e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024ea:	a1 04 50 80 00       	mov    0x805004,%eax
  8024ef:	89 04 24             	mov    %eax,(%esp)
  8024f2:	e8 11 08 00 00       	call   802d08 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8024f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024fe:	00 
  8024ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802506:	00 
  802507:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80250e:	e8 8d 07 00 00       	call   802ca0 <ipc_recv>
}
  802513:	83 c4 14             	add    $0x14,%esp
  802516:	5b                   	pop    %ebx
  802517:	5d                   	pop    %ebp
  802518:	c3                   	ret    

00802519 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
  80251c:	56                   	push   %esi
  80251d:	53                   	push   %ebx
  80251e:	83 ec 10             	sub    $0x10,%esp
  802521:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802524:	8b 45 08             	mov    0x8(%ebp),%eax
  802527:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80252c:	8b 06                	mov    (%esi),%eax
  80252e:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802533:	b8 01 00 00 00       	mov    $0x1,%eax
  802538:	e8 76 ff ff ff       	call   8024b3 <nsipc>
  80253d:	89 c3                	mov    %eax,%ebx
  80253f:	85 c0                	test   %eax,%eax
  802541:	78 23                	js     802566 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802543:	a1 10 80 80 00       	mov    0x808010,%eax
  802548:	89 44 24 08          	mov    %eax,0x8(%esp)
  80254c:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802553:	00 
  802554:	8b 45 0c             	mov    0xc(%ebp),%eax
  802557:	89 04 24             	mov    %eax,(%esp)
  80255a:	e8 55 e4 ff ff       	call   8009b4 <memmove>
		*addrlen = ret->ret_addrlen;
  80255f:	a1 10 80 80 00       	mov    0x808010,%eax
  802564:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802566:	89 d8                	mov    %ebx,%eax
  802568:	83 c4 10             	add    $0x10,%esp
  80256b:	5b                   	pop    %ebx
  80256c:	5e                   	pop    %esi
  80256d:	5d                   	pop    %ebp
  80256e:	c3                   	ret    

0080256f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80256f:	55                   	push   %ebp
  802570:	89 e5                	mov    %esp,%ebp
  802572:	53                   	push   %ebx
  802573:	83 ec 14             	sub    $0x14,%esp
  802576:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802581:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802585:	8b 45 0c             	mov    0xc(%ebp),%eax
  802588:	89 44 24 04          	mov    %eax,0x4(%esp)
  80258c:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  802593:	e8 1c e4 ff ff       	call   8009b4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802598:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  80259e:	b8 02 00 00 00       	mov    $0x2,%eax
  8025a3:	e8 0b ff ff ff       	call   8024b3 <nsipc>
}
  8025a8:	83 c4 14             	add    $0x14,%esp
  8025ab:	5b                   	pop    %ebx
  8025ac:	5d                   	pop    %ebp
  8025ad:	c3                   	ret    

008025ae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
  8025b1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8025b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  8025bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025bf:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  8025c4:	b8 03 00 00 00       	mov    $0x3,%eax
  8025c9:	e8 e5 fe ff ff       	call   8024b3 <nsipc>
}
  8025ce:	c9                   	leave  
  8025cf:	c3                   	ret    

008025d0 <nsipc_close>:

int
nsipc_close(int s)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8025d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d9:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  8025de:	b8 04 00 00 00       	mov    $0x4,%eax
  8025e3:	e8 cb fe ff ff       	call   8024b3 <nsipc>
}
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
  8025ed:	53                   	push   %ebx
  8025ee:	83 ec 14             	sub    $0x14,%esp
  8025f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8025fc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802600:	8b 45 0c             	mov    0xc(%ebp),%eax
  802603:	89 44 24 04          	mov    %eax,0x4(%esp)
  802607:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  80260e:	e8 a1 e3 ff ff       	call   8009b4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802613:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  802619:	b8 05 00 00 00       	mov    $0x5,%eax
  80261e:	e8 90 fe ff ff       	call   8024b3 <nsipc>
}
  802623:	83 c4 14             	add    $0x14,%esp
  802626:	5b                   	pop    %ebx
  802627:	5d                   	pop    %ebp
  802628:	c3                   	ret    

00802629 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802629:	55                   	push   %ebp
  80262a:	89 e5                	mov    %esp,%ebp
  80262c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80262f:	8b 45 08             	mov    0x8(%ebp),%eax
  802632:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  802637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80263a:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  80263f:	b8 06 00 00 00       	mov    $0x6,%eax
  802644:	e8 6a fe ff ff       	call   8024b3 <nsipc>
}
  802649:	c9                   	leave  
  80264a:	c3                   	ret    

0080264b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
  80264e:	56                   	push   %esi
  80264f:	53                   	push   %ebx
  802650:	83 ec 10             	sub    $0x10,%esp
  802653:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802656:	8b 45 08             	mov    0x8(%ebp),%eax
  802659:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  80265e:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  802664:	8b 45 14             	mov    0x14(%ebp),%eax
  802667:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80266c:	b8 07 00 00 00       	mov    $0x7,%eax
  802671:	e8 3d fe ff ff       	call   8024b3 <nsipc>
  802676:	89 c3                	mov    %eax,%ebx
  802678:	85 c0                	test   %eax,%eax
  80267a:	78 46                	js     8026c2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80267c:	39 f0                	cmp    %esi,%eax
  80267e:	7f 07                	jg     802687 <nsipc_recv+0x3c>
  802680:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802685:	7e 24                	jle    8026ab <nsipc_recv+0x60>
  802687:	c7 44 24 0c ec 35 80 	movl   $0x8035ec,0xc(%esp)
  80268e:	00 
  80268f:	c7 44 24 08 eb 34 80 	movl   $0x8034eb,0x8(%esp)
  802696:	00 
  802697:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80269e:	00 
  80269f:	c7 04 24 01 36 80 00 	movl   $0x803601,(%esp)
  8026a6:	e8 49 da ff ff       	call   8000f4 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8026ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026af:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8026b6:	00 
  8026b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ba:	89 04 24             	mov    %eax,(%esp)
  8026bd:	e8 f2 e2 ff ff       	call   8009b4 <memmove>
	}

	return r;
}
  8026c2:	89 d8                	mov    %ebx,%eax
  8026c4:	83 c4 10             	add    $0x10,%esp
  8026c7:	5b                   	pop    %ebx
  8026c8:	5e                   	pop    %esi
  8026c9:	5d                   	pop    %ebp
  8026ca:	c3                   	ret    

008026cb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8026cb:	55                   	push   %ebp
  8026cc:	89 e5                	mov    %esp,%ebp
  8026ce:	53                   	push   %ebx
  8026cf:	83 ec 14             	sub    $0x14,%esp
  8026d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8026d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d8:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  8026dd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8026e3:	7e 24                	jle    802709 <nsipc_send+0x3e>
  8026e5:	c7 44 24 0c 0d 36 80 	movl   $0x80360d,0xc(%esp)
  8026ec:	00 
  8026ed:	c7 44 24 08 eb 34 80 	movl   $0x8034eb,0x8(%esp)
  8026f4:	00 
  8026f5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8026fc:	00 
  8026fd:	c7 04 24 01 36 80 00 	movl   $0x803601,(%esp)
  802704:	e8 eb d9 ff ff       	call   8000f4 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802709:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80270d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802710:	89 44 24 04          	mov    %eax,0x4(%esp)
  802714:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  80271b:	e8 94 e2 ff ff       	call   8009b4 <memmove>
	nsipcbuf.send.req_size = size;
  802720:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  802726:	8b 45 14             	mov    0x14(%ebp),%eax
  802729:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  80272e:	b8 08 00 00 00       	mov    $0x8,%eax
  802733:	e8 7b fd ff ff       	call   8024b3 <nsipc>
}
  802738:	83 c4 14             	add    $0x14,%esp
  80273b:	5b                   	pop    %ebx
  80273c:	5d                   	pop    %ebp
  80273d:	c3                   	ret    

0080273e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
  802741:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802744:	8b 45 08             	mov    0x8(%ebp),%eax
  802747:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  80274c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80274f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  802754:	8b 45 10             	mov    0x10(%ebp),%eax
  802757:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80275c:	b8 09 00 00 00       	mov    $0x9,%eax
  802761:	e8 4d fd ff ff       	call   8024b3 <nsipc>
}
  802766:	c9                   	leave  
  802767:	c3                   	ret    

00802768 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802768:	55                   	push   %ebp
  802769:	89 e5                	mov    %esp,%ebp
  80276b:	56                   	push   %esi
  80276c:	53                   	push   %ebx
  80276d:	83 ec 10             	sub    $0x10,%esp
  802770:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802773:	8b 45 08             	mov    0x8(%ebp),%eax
  802776:	89 04 24             	mov    %eax,(%esp)
  802779:	e8 12 e8 ff ff       	call   800f90 <fd2data>
  80277e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802780:	c7 44 24 04 19 36 80 	movl   $0x803619,0x4(%esp)
  802787:	00 
  802788:	89 1c 24             	mov    %ebx,(%esp)
  80278b:	e8 87 e0 ff ff       	call   800817 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802790:	8b 46 04             	mov    0x4(%esi),%eax
  802793:	2b 06                	sub    (%esi),%eax
  802795:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80279b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8027a2:	00 00 00 
	stat->st_dev = &devpipe;
  8027a5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8027ac:	40 80 00 
	return 0;
}
  8027af:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b4:	83 c4 10             	add    $0x10,%esp
  8027b7:	5b                   	pop    %ebx
  8027b8:	5e                   	pop    %esi
  8027b9:	5d                   	pop    %ebp
  8027ba:	c3                   	ret    

008027bb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
  8027be:	53                   	push   %ebx
  8027bf:	83 ec 14             	sub    $0x14,%esp
  8027c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8027c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d0:	e8 05 e5 ff ff       	call   800cda <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8027d5:	89 1c 24             	mov    %ebx,(%esp)
  8027d8:	e8 b3 e7 ff ff       	call   800f90 <fd2data>
  8027dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027e8:	e8 ed e4 ff ff       	call   800cda <sys_page_unmap>
}
  8027ed:	83 c4 14             	add    $0x14,%esp
  8027f0:	5b                   	pop    %ebx
  8027f1:	5d                   	pop    %ebp
  8027f2:	c3                   	ret    

008027f3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8027f3:	55                   	push   %ebp
  8027f4:	89 e5                	mov    %esp,%ebp
  8027f6:	57                   	push   %edi
  8027f7:	56                   	push   %esi
  8027f8:	53                   	push   %ebx
  8027f9:	83 ec 2c             	sub    $0x2c,%esp
  8027fc:	89 c6                	mov    %eax,%esi
  8027fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802801:	a1 08 50 80 00       	mov    0x805008,%eax
  802806:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802809:	89 34 24             	mov    %esi,(%esp)
  80280c:	e8 be 05 00 00       	call   802dcf <pageref>
  802811:	89 c7                	mov    %eax,%edi
  802813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802816:	89 04 24             	mov    %eax,(%esp)
  802819:	e8 b1 05 00 00       	call   802dcf <pageref>
  80281e:	39 c7                	cmp    %eax,%edi
  802820:	0f 94 c2             	sete   %dl
  802823:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802826:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80282c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80282f:	39 fb                	cmp    %edi,%ebx
  802831:	74 21                	je     802854 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802833:	84 d2                	test   %dl,%dl
  802835:	74 ca                	je     802801 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802837:	8b 51 58             	mov    0x58(%ecx),%edx
  80283a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80283e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802842:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802846:	c7 04 24 20 36 80 00 	movl   $0x803620,(%esp)
  80284d:	e8 9b d9 ff ff       	call   8001ed <cprintf>
  802852:	eb ad                	jmp    802801 <_pipeisclosed+0xe>
	}
}
  802854:	83 c4 2c             	add    $0x2c,%esp
  802857:	5b                   	pop    %ebx
  802858:	5e                   	pop    %esi
  802859:	5f                   	pop    %edi
  80285a:	5d                   	pop    %ebp
  80285b:	c3                   	ret    

0080285c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80285c:	55                   	push   %ebp
  80285d:	89 e5                	mov    %esp,%ebp
  80285f:	57                   	push   %edi
  802860:	56                   	push   %esi
  802861:	53                   	push   %ebx
  802862:	83 ec 1c             	sub    $0x1c,%esp
  802865:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802868:	89 34 24             	mov    %esi,(%esp)
  80286b:	e8 20 e7 ff ff       	call   800f90 <fd2data>
  802870:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802872:	bf 00 00 00 00       	mov    $0x0,%edi
  802877:	eb 45                	jmp    8028be <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802879:	89 da                	mov    %ebx,%edx
  80287b:	89 f0                	mov    %esi,%eax
  80287d:	e8 71 ff ff ff       	call   8027f3 <_pipeisclosed>
  802882:	85 c0                	test   %eax,%eax
  802884:	75 41                	jne    8028c7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802886:	e8 89 e3 ff ff       	call   800c14 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80288b:	8b 43 04             	mov    0x4(%ebx),%eax
  80288e:	8b 0b                	mov    (%ebx),%ecx
  802890:	8d 51 20             	lea    0x20(%ecx),%edx
  802893:	39 d0                	cmp    %edx,%eax
  802895:	73 e2                	jae    802879 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802897:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80289a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80289e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8028a1:	99                   	cltd   
  8028a2:	c1 ea 1b             	shr    $0x1b,%edx
  8028a5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8028a8:	83 e1 1f             	and    $0x1f,%ecx
  8028ab:	29 d1                	sub    %edx,%ecx
  8028ad:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8028b1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8028b5:	83 c0 01             	add    $0x1,%eax
  8028b8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8028bb:	83 c7 01             	add    $0x1,%edi
  8028be:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8028c1:	75 c8                	jne    80288b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8028c3:	89 f8                	mov    %edi,%eax
  8028c5:	eb 05                	jmp    8028cc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8028c7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8028cc:	83 c4 1c             	add    $0x1c,%esp
  8028cf:	5b                   	pop    %ebx
  8028d0:	5e                   	pop    %esi
  8028d1:	5f                   	pop    %edi
  8028d2:	5d                   	pop    %ebp
  8028d3:	c3                   	ret    

008028d4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8028d4:	55                   	push   %ebp
  8028d5:	89 e5                	mov    %esp,%ebp
  8028d7:	57                   	push   %edi
  8028d8:	56                   	push   %esi
  8028d9:	53                   	push   %ebx
  8028da:	83 ec 1c             	sub    $0x1c,%esp
  8028dd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8028e0:	89 3c 24             	mov    %edi,(%esp)
  8028e3:	e8 a8 e6 ff ff       	call   800f90 <fd2data>
  8028e8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8028ea:	be 00 00 00 00       	mov    $0x0,%esi
  8028ef:	eb 3d                	jmp    80292e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8028f1:	85 f6                	test   %esi,%esi
  8028f3:	74 04                	je     8028f9 <devpipe_read+0x25>
				return i;
  8028f5:	89 f0                	mov    %esi,%eax
  8028f7:	eb 43                	jmp    80293c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8028f9:	89 da                	mov    %ebx,%edx
  8028fb:	89 f8                	mov    %edi,%eax
  8028fd:	e8 f1 fe ff ff       	call   8027f3 <_pipeisclosed>
  802902:	85 c0                	test   %eax,%eax
  802904:	75 31                	jne    802937 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802906:	e8 09 e3 ff ff       	call   800c14 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80290b:	8b 03                	mov    (%ebx),%eax
  80290d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802910:	74 df                	je     8028f1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802912:	99                   	cltd   
  802913:	c1 ea 1b             	shr    $0x1b,%edx
  802916:	01 d0                	add    %edx,%eax
  802918:	83 e0 1f             	and    $0x1f,%eax
  80291b:	29 d0                	sub    %edx,%eax
  80291d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802922:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802925:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802928:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80292b:	83 c6 01             	add    $0x1,%esi
  80292e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802931:	75 d8                	jne    80290b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802933:	89 f0                	mov    %esi,%eax
  802935:	eb 05                	jmp    80293c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802937:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80293c:	83 c4 1c             	add    $0x1c,%esp
  80293f:	5b                   	pop    %ebx
  802940:	5e                   	pop    %esi
  802941:	5f                   	pop    %edi
  802942:	5d                   	pop    %ebp
  802943:	c3                   	ret    

00802944 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802944:	55                   	push   %ebp
  802945:	89 e5                	mov    %esp,%ebp
  802947:	56                   	push   %esi
  802948:	53                   	push   %ebx
  802949:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80294c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80294f:	89 04 24             	mov    %eax,(%esp)
  802952:	e8 50 e6 ff ff       	call   800fa7 <fd_alloc>
  802957:	89 c2                	mov    %eax,%edx
  802959:	85 d2                	test   %edx,%edx
  80295b:	0f 88 4d 01 00 00    	js     802aae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802961:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802968:	00 
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802970:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802977:	e8 b7 e2 ff ff       	call   800c33 <sys_page_alloc>
  80297c:	89 c2                	mov    %eax,%edx
  80297e:	85 d2                	test   %edx,%edx
  802980:	0f 88 28 01 00 00    	js     802aae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802986:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802989:	89 04 24             	mov    %eax,(%esp)
  80298c:	e8 16 e6 ff ff       	call   800fa7 <fd_alloc>
  802991:	89 c3                	mov    %eax,%ebx
  802993:	85 c0                	test   %eax,%eax
  802995:	0f 88 fe 00 00 00    	js     802a99 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80299b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029a2:	00 
  8029a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029b1:	e8 7d e2 ff ff       	call   800c33 <sys_page_alloc>
  8029b6:	89 c3                	mov    %eax,%ebx
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	0f 88 d9 00 00 00    	js     802a99 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	89 04 24             	mov    %eax,(%esp)
  8029c6:	e8 c5 e5 ff ff       	call   800f90 <fd2data>
  8029cb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029cd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029d4:	00 
  8029d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029e0:	e8 4e e2 ff ff       	call   800c33 <sys_page_alloc>
  8029e5:	89 c3                	mov    %eax,%ebx
  8029e7:	85 c0                	test   %eax,%eax
  8029e9:	0f 88 97 00 00 00    	js     802a86 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8029ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f2:	89 04 24             	mov    %eax,(%esp)
  8029f5:	e8 96 e5 ff ff       	call   800f90 <fd2data>
  8029fa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802a01:	00 
  802a02:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a06:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802a0d:	00 
  802a0e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a19:	e8 69 e2 ff ff       	call   800c87 <sys_page_map>
  802a1e:	89 c3                	mov    %eax,%ebx
  802a20:	85 c0                	test   %eax,%eax
  802a22:	78 52                	js     802a76 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802a24:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802a39:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a42:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a47:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	89 04 24             	mov    %eax,(%esp)
  802a54:	e8 27 e5 ff ff       	call   800f80 <fd2num>
  802a59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a5c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a61:	89 04 24             	mov    %eax,(%esp)
  802a64:	e8 17 e5 ff ff       	call   800f80 <fd2num>
  802a69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802a6c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a74:	eb 38                	jmp    802aae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802a76:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a81:	e8 54 e2 ff ff       	call   800cda <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a89:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a8d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a94:	e8 41 e2 ff ff       	call   800cda <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aa0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802aa7:	e8 2e e2 ff ff       	call   800cda <sys_page_unmap>
  802aac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802aae:	83 c4 30             	add    $0x30,%esp
  802ab1:	5b                   	pop    %ebx
  802ab2:	5e                   	pop    %esi
  802ab3:	5d                   	pop    %ebp
  802ab4:	c3                   	ret    

00802ab5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802ab5:	55                   	push   %ebp
  802ab6:	89 e5                	mov    %esp,%ebp
  802ab8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802abb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802abe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac5:	89 04 24             	mov    %eax,(%esp)
  802ac8:	e8 29 e5 ff ff       	call   800ff6 <fd_lookup>
  802acd:	89 c2                	mov    %eax,%edx
  802acf:	85 d2                	test   %edx,%edx
  802ad1:	78 15                	js     802ae8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	89 04 24             	mov    %eax,(%esp)
  802ad9:	e8 b2 e4 ff ff       	call   800f90 <fd2data>
	return _pipeisclosed(fd, p);
  802ade:	89 c2                	mov    %eax,%edx
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	e8 0b fd ff ff       	call   8027f3 <_pipeisclosed>
}
  802ae8:	c9                   	leave  
  802ae9:	c3                   	ret    
  802aea:	66 90                	xchg   %ax,%ax
  802aec:	66 90                	xchg   %ax,%ax
  802aee:	66 90                	xchg   %ax,%ax

00802af0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802af0:	55                   	push   %ebp
  802af1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802af3:	b8 00 00 00 00       	mov    $0x0,%eax
  802af8:	5d                   	pop    %ebp
  802af9:	c3                   	ret    

00802afa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802afa:	55                   	push   %ebp
  802afb:	89 e5                	mov    %esp,%ebp
  802afd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802b00:	c7 44 24 04 38 36 80 	movl   $0x803638,0x4(%esp)
  802b07:	00 
  802b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b0b:	89 04 24             	mov    %eax,(%esp)
  802b0e:	e8 04 dd ff ff       	call   800817 <strcpy>
	return 0;
}
  802b13:	b8 00 00 00 00       	mov    $0x0,%eax
  802b18:	c9                   	leave  
  802b19:	c3                   	ret    

00802b1a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802b1a:	55                   	push   %ebp
  802b1b:	89 e5                	mov    %esp,%ebp
  802b1d:	57                   	push   %edi
  802b1e:	56                   	push   %esi
  802b1f:	53                   	push   %ebx
  802b20:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802b26:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802b2b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802b31:	eb 31                	jmp    802b64 <devcons_write+0x4a>
		m = n - tot;
  802b33:	8b 75 10             	mov    0x10(%ebp),%esi
  802b36:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802b38:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802b3b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802b40:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802b43:	89 74 24 08          	mov    %esi,0x8(%esp)
  802b47:	03 45 0c             	add    0xc(%ebp),%eax
  802b4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b4e:	89 3c 24             	mov    %edi,(%esp)
  802b51:	e8 5e de ff ff       	call   8009b4 <memmove>
		sys_cputs(buf, m);
  802b56:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b5a:	89 3c 24             	mov    %edi,(%esp)
  802b5d:	e8 04 e0 ff ff       	call   800b66 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802b62:	01 f3                	add    %esi,%ebx
  802b64:	89 d8                	mov    %ebx,%eax
  802b66:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802b69:	72 c8                	jb     802b33 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802b6b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802b71:	5b                   	pop    %ebx
  802b72:	5e                   	pop    %esi
  802b73:	5f                   	pop    %edi
  802b74:	5d                   	pop    %ebp
  802b75:	c3                   	ret    

00802b76 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802b76:	55                   	push   %ebp
  802b77:	89 e5                	mov    %esp,%ebp
  802b79:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802b7c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802b81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802b85:	75 07                	jne    802b8e <devcons_read+0x18>
  802b87:	eb 2a                	jmp    802bb3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802b89:	e8 86 e0 ff ff       	call   800c14 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802b8e:	66 90                	xchg   %ax,%ax
  802b90:	e8 ef df ff ff       	call   800b84 <sys_cgetc>
  802b95:	85 c0                	test   %eax,%eax
  802b97:	74 f0                	je     802b89 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	78 16                	js     802bb3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802b9d:	83 f8 04             	cmp    $0x4,%eax
  802ba0:	74 0c                	je     802bae <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ba5:	88 02                	mov    %al,(%edx)
	return 1;
  802ba7:	b8 01 00 00 00       	mov    $0x1,%eax
  802bac:	eb 05                	jmp    802bb3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802bae:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802bb3:	c9                   	leave  
  802bb4:	c3                   	ret    

00802bb5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802bb5:	55                   	push   %ebp
  802bb6:	89 e5                	mov    %esp,%ebp
  802bb8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802bc1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802bc8:	00 
  802bc9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802bcc:	89 04 24             	mov    %eax,(%esp)
  802bcf:	e8 92 df ff ff       	call   800b66 <sys_cputs>
}
  802bd4:	c9                   	leave  
  802bd5:	c3                   	ret    

00802bd6 <getchar>:

int
getchar(void)
{
  802bd6:	55                   	push   %ebp
  802bd7:	89 e5                	mov    %esp,%ebp
  802bd9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802bdc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802be3:	00 
  802be4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  802beb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bf2:	e8 93 e6 ff ff       	call   80128a <read>
	if (r < 0)
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	78 0f                	js     802c0a <getchar+0x34>
		return r;
	if (r < 1)
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	7e 06                	jle    802c05 <getchar+0x2f>
		return -E_EOF;
	return c;
  802bff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802c03:	eb 05                	jmp    802c0a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802c05:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802c0a:	c9                   	leave  
  802c0b:	c3                   	ret    

00802c0c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802c0c:	55                   	push   %ebp
  802c0d:	89 e5                	mov    %esp,%ebp
  802c0f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c12:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c15:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c19:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1c:	89 04 24             	mov    %eax,(%esp)
  802c1f:	e8 d2 e3 ff ff       	call   800ff6 <fd_lookup>
  802c24:	85 c0                	test   %eax,%eax
  802c26:	78 11                	js     802c39 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802c31:	39 10                	cmp    %edx,(%eax)
  802c33:	0f 94 c0             	sete   %al
  802c36:	0f b6 c0             	movzbl %al,%eax
}
  802c39:	c9                   	leave  
  802c3a:	c3                   	ret    

00802c3b <opencons>:

int
opencons(void)
{
  802c3b:	55                   	push   %ebp
  802c3c:	89 e5                	mov    %esp,%ebp
  802c3e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802c41:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c44:	89 04 24             	mov    %eax,(%esp)
  802c47:	e8 5b e3 ff ff       	call   800fa7 <fd_alloc>
		return r;
  802c4c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802c4e:	85 c0                	test   %eax,%eax
  802c50:	78 40                	js     802c92 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802c52:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802c59:	00 
  802c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c68:	e8 c6 df ff ff       	call   800c33 <sys_page_alloc>
		return r;
  802c6d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802c6f:	85 c0                	test   %eax,%eax
  802c71:	78 1f                	js     802c92 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802c73:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802c88:	89 04 24             	mov    %eax,(%esp)
  802c8b:	e8 f0 e2 ff ff       	call   800f80 <fd2num>
  802c90:	89 c2                	mov    %eax,%edx
}
  802c92:	89 d0                	mov    %edx,%eax
  802c94:	c9                   	leave  
  802c95:	c3                   	ret    
  802c96:	66 90                	xchg   %ax,%ax
  802c98:	66 90                	xchg   %ax,%ax
  802c9a:	66 90                	xchg   %ax,%ax
  802c9c:	66 90                	xchg   %ax,%ax
  802c9e:	66 90                	xchg   %ax,%ax

00802ca0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802ca0:	55                   	push   %ebp
  802ca1:	89 e5                	mov    %esp,%ebp
  802ca3:	56                   	push   %esi
  802ca4:	53                   	push   %ebx
  802ca5:	83 ec 10             	sub    $0x10,%esp
  802ca8:	8b 75 08             	mov    0x8(%ebp),%esi
  802cab:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802cb1:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802cb3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802cb8:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  802cbb:	89 04 24             	mov    %eax,(%esp)
  802cbe:	e8 86 e1 ff ff       	call   800e49 <sys_ipc_recv>
  802cc3:	85 c0                	test   %eax,%eax
  802cc5:	74 16                	je     802cdd <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802cc7:	85 f6                	test   %esi,%esi
  802cc9:	74 06                	je     802cd1 <ipc_recv+0x31>
			*from_env_store = 0;
  802ccb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802cd1:	85 db                	test   %ebx,%ebx
  802cd3:	74 2c                	je     802d01 <ipc_recv+0x61>
			*perm_store = 0;
  802cd5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802cdb:	eb 24                	jmp    802d01 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  802cdd:	85 f6                	test   %esi,%esi
  802cdf:	74 0a                	je     802ceb <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802ce1:	a1 08 50 80 00       	mov    0x805008,%eax
  802ce6:	8b 40 74             	mov    0x74(%eax),%eax
  802ce9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  802ceb:	85 db                	test   %ebx,%ebx
  802ced:	74 0a                	je     802cf9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  802cef:	a1 08 50 80 00       	mov    0x805008,%eax
  802cf4:	8b 40 78             	mov    0x78(%eax),%eax
  802cf7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802cf9:	a1 08 50 80 00       	mov    0x805008,%eax
  802cfe:	8b 40 70             	mov    0x70(%eax),%eax
}
  802d01:	83 c4 10             	add    $0x10,%esp
  802d04:	5b                   	pop    %ebx
  802d05:	5e                   	pop    %esi
  802d06:	5d                   	pop    %ebp
  802d07:	c3                   	ret    

00802d08 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802d08:	55                   	push   %ebp
  802d09:	89 e5                	mov    %esp,%ebp
  802d0b:	57                   	push   %edi
  802d0c:	56                   	push   %esi
  802d0d:	53                   	push   %ebx
  802d0e:	83 ec 1c             	sub    $0x1c,%esp
  802d11:	8b 75 0c             	mov    0xc(%ebp),%esi
  802d14:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802d17:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  802d1a:	85 db                	test   %ebx,%ebx
  802d1c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802d21:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802d24:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d28:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d2c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	89 04 24             	mov    %eax,(%esp)
  802d36:	e8 eb e0 ff ff       	call   800e26 <sys_ipc_try_send>
	if (r == 0) return;
  802d3b:	85 c0                	test   %eax,%eax
  802d3d:	75 22                	jne    802d61 <ipc_send+0x59>
  802d3f:	eb 4c                	jmp    802d8d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802d41:	84 d2                	test   %dl,%dl
  802d43:	75 48                	jne    802d8d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802d45:	e8 ca de ff ff       	call   800c14 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  802d4a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d4e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d52:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d56:	8b 45 08             	mov    0x8(%ebp),%eax
  802d59:	89 04 24             	mov    %eax,(%esp)
  802d5c:	e8 c5 e0 ff ff       	call   800e26 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802d61:	85 c0                	test   %eax,%eax
  802d63:	0f 94 c2             	sete   %dl
  802d66:	74 d9                	je     802d41 <ipc_send+0x39>
  802d68:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802d6b:	74 d4                	je     802d41 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  802d6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d71:	c7 44 24 08 44 36 80 	movl   $0x803644,0x8(%esp)
  802d78:	00 
  802d79:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802d80:	00 
  802d81:	c7 04 24 52 36 80 00 	movl   $0x803652,(%esp)
  802d88:	e8 67 d3 ff ff       	call   8000f4 <_panic>
}
  802d8d:	83 c4 1c             	add    $0x1c,%esp
  802d90:	5b                   	pop    %ebx
  802d91:	5e                   	pop    %esi
  802d92:	5f                   	pop    %edi
  802d93:	5d                   	pop    %ebp
  802d94:	c3                   	ret    

00802d95 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802d95:	55                   	push   %ebp
  802d96:	89 e5                	mov    %esp,%ebp
  802d98:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802d9b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802da0:	89 c2                	mov    %eax,%edx
  802da2:	c1 e2 07             	shl    $0x7,%edx
  802da5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802dab:	8b 52 50             	mov    0x50(%edx),%edx
  802dae:	39 ca                	cmp    %ecx,%edx
  802db0:	75 0d                	jne    802dbf <ipc_find_env+0x2a>
			return envs[i].env_id;
  802db2:	c1 e0 07             	shl    $0x7,%eax
  802db5:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802dba:	8b 40 40             	mov    0x40(%eax),%eax
  802dbd:	eb 0e                	jmp    802dcd <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802dbf:	83 c0 01             	add    $0x1,%eax
  802dc2:	3d 00 04 00 00       	cmp    $0x400,%eax
  802dc7:	75 d7                	jne    802da0 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802dc9:	66 b8 00 00          	mov    $0x0,%ax
}
  802dcd:	5d                   	pop    %ebp
  802dce:	c3                   	ret    

00802dcf <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802dcf:	55                   	push   %ebp
  802dd0:	89 e5                	mov    %esp,%ebp
  802dd2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802dd5:	89 d0                	mov    %edx,%eax
  802dd7:	c1 e8 16             	shr    $0x16,%eax
  802dda:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802de1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802de6:	f6 c1 01             	test   $0x1,%cl
  802de9:	74 1d                	je     802e08 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802deb:	c1 ea 0c             	shr    $0xc,%edx
  802dee:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802df5:	f6 c2 01             	test   $0x1,%dl
  802df8:	74 0e                	je     802e08 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802dfa:	c1 ea 0c             	shr    $0xc,%edx
  802dfd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802e04:	ef 
  802e05:	0f b7 c0             	movzwl %ax,%eax
}
  802e08:	5d                   	pop    %ebp
  802e09:	c3                   	ret    
  802e0a:	66 90                	xchg   %ax,%ax
  802e0c:	66 90                	xchg   %ax,%ax
  802e0e:	66 90                	xchg   %ax,%ax

00802e10 <__udivdi3>:
  802e10:	55                   	push   %ebp
  802e11:	57                   	push   %edi
  802e12:	56                   	push   %esi
  802e13:	83 ec 0c             	sub    $0xc,%esp
  802e16:	8b 44 24 28          	mov    0x28(%esp),%eax
  802e1a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802e1e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802e22:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802e26:	85 c0                	test   %eax,%eax
  802e28:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802e2c:	89 ea                	mov    %ebp,%edx
  802e2e:	89 0c 24             	mov    %ecx,(%esp)
  802e31:	75 2d                	jne    802e60 <__udivdi3+0x50>
  802e33:	39 e9                	cmp    %ebp,%ecx
  802e35:	77 61                	ja     802e98 <__udivdi3+0x88>
  802e37:	85 c9                	test   %ecx,%ecx
  802e39:	89 ce                	mov    %ecx,%esi
  802e3b:	75 0b                	jne    802e48 <__udivdi3+0x38>
  802e3d:	b8 01 00 00 00       	mov    $0x1,%eax
  802e42:	31 d2                	xor    %edx,%edx
  802e44:	f7 f1                	div    %ecx
  802e46:	89 c6                	mov    %eax,%esi
  802e48:	31 d2                	xor    %edx,%edx
  802e4a:	89 e8                	mov    %ebp,%eax
  802e4c:	f7 f6                	div    %esi
  802e4e:	89 c5                	mov    %eax,%ebp
  802e50:	89 f8                	mov    %edi,%eax
  802e52:	f7 f6                	div    %esi
  802e54:	89 ea                	mov    %ebp,%edx
  802e56:	83 c4 0c             	add    $0xc,%esp
  802e59:	5e                   	pop    %esi
  802e5a:	5f                   	pop    %edi
  802e5b:	5d                   	pop    %ebp
  802e5c:	c3                   	ret    
  802e5d:	8d 76 00             	lea    0x0(%esi),%esi
  802e60:	39 e8                	cmp    %ebp,%eax
  802e62:	77 24                	ja     802e88 <__udivdi3+0x78>
  802e64:	0f bd e8             	bsr    %eax,%ebp
  802e67:	83 f5 1f             	xor    $0x1f,%ebp
  802e6a:	75 3c                	jne    802ea8 <__udivdi3+0x98>
  802e6c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802e70:	39 34 24             	cmp    %esi,(%esp)
  802e73:	0f 86 9f 00 00 00    	jbe    802f18 <__udivdi3+0x108>
  802e79:	39 d0                	cmp    %edx,%eax
  802e7b:	0f 82 97 00 00 00    	jb     802f18 <__udivdi3+0x108>
  802e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802e88:	31 d2                	xor    %edx,%edx
  802e8a:	31 c0                	xor    %eax,%eax
  802e8c:	83 c4 0c             	add    $0xc,%esp
  802e8f:	5e                   	pop    %esi
  802e90:	5f                   	pop    %edi
  802e91:	5d                   	pop    %ebp
  802e92:	c3                   	ret    
  802e93:	90                   	nop
  802e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e98:	89 f8                	mov    %edi,%eax
  802e9a:	f7 f1                	div    %ecx
  802e9c:	31 d2                	xor    %edx,%edx
  802e9e:	83 c4 0c             	add    $0xc,%esp
  802ea1:	5e                   	pop    %esi
  802ea2:	5f                   	pop    %edi
  802ea3:	5d                   	pop    %ebp
  802ea4:	c3                   	ret    
  802ea5:	8d 76 00             	lea    0x0(%esi),%esi
  802ea8:	89 e9                	mov    %ebp,%ecx
  802eaa:	8b 3c 24             	mov    (%esp),%edi
  802ead:	d3 e0                	shl    %cl,%eax
  802eaf:	89 c6                	mov    %eax,%esi
  802eb1:	b8 20 00 00 00       	mov    $0x20,%eax
  802eb6:	29 e8                	sub    %ebp,%eax
  802eb8:	89 c1                	mov    %eax,%ecx
  802eba:	d3 ef                	shr    %cl,%edi
  802ebc:	89 e9                	mov    %ebp,%ecx
  802ebe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802ec2:	8b 3c 24             	mov    (%esp),%edi
  802ec5:	09 74 24 08          	or     %esi,0x8(%esp)
  802ec9:	89 d6                	mov    %edx,%esi
  802ecb:	d3 e7                	shl    %cl,%edi
  802ecd:	89 c1                	mov    %eax,%ecx
  802ecf:	89 3c 24             	mov    %edi,(%esp)
  802ed2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ed6:	d3 ee                	shr    %cl,%esi
  802ed8:	89 e9                	mov    %ebp,%ecx
  802eda:	d3 e2                	shl    %cl,%edx
  802edc:	89 c1                	mov    %eax,%ecx
  802ede:	d3 ef                	shr    %cl,%edi
  802ee0:	09 d7                	or     %edx,%edi
  802ee2:	89 f2                	mov    %esi,%edx
  802ee4:	89 f8                	mov    %edi,%eax
  802ee6:	f7 74 24 08          	divl   0x8(%esp)
  802eea:	89 d6                	mov    %edx,%esi
  802eec:	89 c7                	mov    %eax,%edi
  802eee:	f7 24 24             	mull   (%esp)
  802ef1:	39 d6                	cmp    %edx,%esi
  802ef3:	89 14 24             	mov    %edx,(%esp)
  802ef6:	72 30                	jb     802f28 <__udivdi3+0x118>
  802ef8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802efc:	89 e9                	mov    %ebp,%ecx
  802efe:	d3 e2                	shl    %cl,%edx
  802f00:	39 c2                	cmp    %eax,%edx
  802f02:	73 05                	jae    802f09 <__udivdi3+0xf9>
  802f04:	3b 34 24             	cmp    (%esp),%esi
  802f07:	74 1f                	je     802f28 <__udivdi3+0x118>
  802f09:	89 f8                	mov    %edi,%eax
  802f0b:	31 d2                	xor    %edx,%edx
  802f0d:	e9 7a ff ff ff       	jmp    802e8c <__udivdi3+0x7c>
  802f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802f18:	31 d2                	xor    %edx,%edx
  802f1a:	b8 01 00 00 00       	mov    $0x1,%eax
  802f1f:	e9 68 ff ff ff       	jmp    802e8c <__udivdi3+0x7c>
  802f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f28:	8d 47 ff             	lea    -0x1(%edi),%eax
  802f2b:	31 d2                	xor    %edx,%edx
  802f2d:	83 c4 0c             	add    $0xc,%esp
  802f30:	5e                   	pop    %esi
  802f31:	5f                   	pop    %edi
  802f32:	5d                   	pop    %ebp
  802f33:	c3                   	ret    
  802f34:	66 90                	xchg   %ax,%ax
  802f36:	66 90                	xchg   %ax,%ax
  802f38:	66 90                	xchg   %ax,%ax
  802f3a:	66 90                	xchg   %ax,%ax
  802f3c:	66 90                	xchg   %ax,%ax
  802f3e:	66 90                	xchg   %ax,%ax

00802f40 <__umoddi3>:
  802f40:	55                   	push   %ebp
  802f41:	57                   	push   %edi
  802f42:	56                   	push   %esi
  802f43:	83 ec 14             	sub    $0x14,%esp
  802f46:	8b 44 24 28          	mov    0x28(%esp),%eax
  802f4a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802f4e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802f52:	89 c7                	mov    %eax,%edi
  802f54:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f58:	8b 44 24 30          	mov    0x30(%esp),%eax
  802f5c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802f60:	89 34 24             	mov    %esi,(%esp)
  802f63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802f67:	85 c0                	test   %eax,%eax
  802f69:	89 c2                	mov    %eax,%edx
  802f6b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f6f:	75 17                	jne    802f88 <__umoddi3+0x48>
  802f71:	39 fe                	cmp    %edi,%esi
  802f73:	76 4b                	jbe    802fc0 <__umoddi3+0x80>
  802f75:	89 c8                	mov    %ecx,%eax
  802f77:	89 fa                	mov    %edi,%edx
  802f79:	f7 f6                	div    %esi
  802f7b:	89 d0                	mov    %edx,%eax
  802f7d:	31 d2                	xor    %edx,%edx
  802f7f:	83 c4 14             	add    $0x14,%esp
  802f82:	5e                   	pop    %esi
  802f83:	5f                   	pop    %edi
  802f84:	5d                   	pop    %ebp
  802f85:	c3                   	ret    
  802f86:	66 90                	xchg   %ax,%ax
  802f88:	39 f8                	cmp    %edi,%eax
  802f8a:	77 54                	ja     802fe0 <__umoddi3+0xa0>
  802f8c:	0f bd e8             	bsr    %eax,%ebp
  802f8f:	83 f5 1f             	xor    $0x1f,%ebp
  802f92:	75 5c                	jne    802ff0 <__umoddi3+0xb0>
  802f94:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802f98:	39 3c 24             	cmp    %edi,(%esp)
  802f9b:	0f 87 e7 00 00 00    	ja     803088 <__umoddi3+0x148>
  802fa1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802fa5:	29 f1                	sub    %esi,%ecx
  802fa7:	19 c7                	sbb    %eax,%edi
  802fa9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802fad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802fb1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802fb5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802fb9:	83 c4 14             	add    $0x14,%esp
  802fbc:	5e                   	pop    %esi
  802fbd:	5f                   	pop    %edi
  802fbe:	5d                   	pop    %ebp
  802fbf:	c3                   	ret    
  802fc0:	85 f6                	test   %esi,%esi
  802fc2:	89 f5                	mov    %esi,%ebp
  802fc4:	75 0b                	jne    802fd1 <__umoddi3+0x91>
  802fc6:	b8 01 00 00 00       	mov    $0x1,%eax
  802fcb:	31 d2                	xor    %edx,%edx
  802fcd:	f7 f6                	div    %esi
  802fcf:	89 c5                	mov    %eax,%ebp
  802fd1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802fd5:	31 d2                	xor    %edx,%edx
  802fd7:	f7 f5                	div    %ebp
  802fd9:	89 c8                	mov    %ecx,%eax
  802fdb:	f7 f5                	div    %ebp
  802fdd:	eb 9c                	jmp    802f7b <__umoddi3+0x3b>
  802fdf:	90                   	nop
  802fe0:	89 c8                	mov    %ecx,%eax
  802fe2:	89 fa                	mov    %edi,%edx
  802fe4:	83 c4 14             	add    $0x14,%esp
  802fe7:	5e                   	pop    %esi
  802fe8:	5f                   	pop    %edi
  802fe9:	5d                   	pop    %ebp
  802fea:	c3                   	ret    
  802feb:	90                   	nop
  802fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ff0:	8b 04 24             	mov    (%esp),%eax
  802ff3:	be 20 00 00 00       	mov    $0x20,%esi
  802ff8:	89 e9                	mov    %ebp,%ecx
  802ffa:	29 ee                	sub    %ebp,%esi
  802ffc:	d3 e2                	shl    %cl,%edx
  802ffe:	89 f1                	mov    %esi,%ecx
  803000:	d3 e8                	shr    %cl,%eax
  803002:	89 e9                	mov    %ebp,%ecx
  803004:	89 44 24 04          	mov    %eax,0x4(%esp)
  803008:	8b 04 24             	mov    (%esp),%eax
  80300b:	09 54 24 04          	or     %edx,0x4(%esp)
  80300f:	89 fa                	mov    %edi,%edx
  803011:	d3 e0                	shl    %cl,%eax
  803013:	89 f1                	mov    %esi,%ecx
  803015:	89 44 24 08          	mov    %eax,0x8(%esp)
  803019:	8b 44 24 10          	mov    0x10(%esp),%eax
  80301d:	d3 ea                	shr    %cl,%edx
  80301f:	89 e9                	mov    %ebp,%ecx
  803021:	d3 e7                	shl    %cl,%edi
  803023:	89 f1                	mov    %esi,%ecx
  803025:	d3 e8                	shr    %cl,%eax
  803027:	89 e9                	mov    %ebp,%ecx
  803029:	09 f8                	or     %edi,%eax
  80302b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80302f:	f7 74 24 04          	divl   0x4(%esp)
  803033:	d3 e7                	shl    %cl,%edi
  803035:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803039:	89 d7                	mov    %edx,%edi
  80303b:	f7 64 24 08          	mull   0x8(%esp)
  80303f:	39 d7                	cmp    %edx,%edi
  803041:	89 c1                	mov    %eax,%ecx
  803043:	89 14 24             	mov    %edx,(%esp)
  803046:	72 2c                	jb     803074 <__umoddi3+0x134>
  803048:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80304c:	72 22                	jb     803070 <__umoddi3+0x130>
  80304e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803052:	29 c8                	sub    %ecx,%eax
  803054:	19 d7                	sbb    %edx,%edi
  803056:	89 e9                	mov    %ebp,%ecx
  803058:	89 fa                	mov    %edi,%edx
  80305a:	d3 e8                	shr    %cl,%eax
  80305c:	89 f1                	mov    %esi,%ecx
  80305e:	d3 e2                	shl    %cl,%edx
  803060:	89 e9                	mov    %ebp,%ecx
  803062:	d3 ef                	shr    %cl,%edi
  803064:	09 d0                	or     %edx,%eax
  803066:	89 fa                	mov    %edi,%edx
  803068:	83 c4 14             	add    $0x14,%esp
  80306b:	5e                   	pop    %esi
  80306c:	5f                   	pop    %edi
  80306d:	5d                   	pop    %ebp
  80306e:	c3                   	ret    
  80306f:	90                   	nop
  803070:	39 d7                	cmp    %edx,%edi
  803072:	75 da                	jne    80304e <__umoddi3+0x10e>
  803074:	8b 14 24             	mov    (%esp),%edx
  803077:	89 c1                	mov    %eax,%ecx
  803079:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80307d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803081:	eb cb                	jmp    80304e <__umoddi3+0x10e>
  803083:	90                   	nop
  803084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803088:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80308c:	0f 82 0f ff ff ff    	jb     802fa1 <__umoddi3+0x61>
  803092:	e9 1a ff ff ff       	jmp    802fb1 <__umoddi3+0x71>
