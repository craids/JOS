
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 61 00 00 00       	call   800092 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
  800046:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800049:	8b 50 04             	mov    0x4(%eax),%edx
  80004c:	83 e2 07             	and    $0x7,%edx
  80004f:	89 54 24 08          	mov    %edx,0x8(%esp)
  800053:	8b 00                	mov    (%eax),%eax
  800055:	89 44 24 04          	mov    %eax,0x4(%esp)
  800059:	c7 04 24 40 27 80 00 	movl   $0x802740,(%esp)
  800060:	e8 31 01 00 00       	call   800196 <cprintf>
	sys_env_destroy(sys_getenvid());
  800065:	e8 2b 0b 00 00       	call   800b95 <sys_getenvid>
  80006a:	89 04 24             	mov    %eax,(%esp)
  80006d:	e8 d1 0a 00 00       	call   800b43 <sys_env_destroy>
}
  800072:	c9                   	leave  
  800073:	c3                   	ret    

00800074 <umain>:

void
umain(int argc, char **argv)
{
  800074:	55                   	push   %ebp
  800075:	89 e5                	mov    %esp,%ebp
  800077:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  80007a:	c7 04 24 40 00 80 00 	movl   $0x800040,(%esp)
  800081:	e8 8b 0e 00 00       	call   800f11 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800086:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  80008d:	00 00 00 
}
  800090:	c9                   	leave  
  800091:	c3                   	ret    

00800092 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	56                   	push   %esi
  800096:	53                   	push   %ebx
  800097:	83 ec 10             	sub    $0x10,%esp
  80009a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80009d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000a0:	e8 f0 0a 00 00       	call   800b95 <sys_getenvid>
  8000a5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000aa:	c1 e0 07             	shl    $0x7,%eax
  8000ad:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000b2:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b7:	85 db                	test   %ebx,%ebx
  8000b9:	7e 07                	jle    8000c2 <libmain+0x30>
		binaryname = argv[0];
  8000bb:	8b 06                	mov    (%esi),%eax
  8000bd:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000c6:	89 1c 24             	mov    %ebx,(%esp)
  8000c9:	e8 a6 ff ff ff       	call   800074 <umain>

	// exit gracefully
	exit();
  8000ce:	e8 07 00 00 00       	call   8000da <exit>
}
  8000d3:	83 c4 10             	add    $0x10,%esp
  8000d6:	5b                   	pop    %ebx
  8000d7:	5e                   	pop    %esi
  8000d8:	5d                   	pop    %ebp
  8000d9:	c3                   	ret    

008000da <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000da:	55                   	push   %ebp
  8000db:	89 e5                	mov    %esp,%ebp
  8000dd:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000e0:	e8 b5 10 00 00       	call   80119a <close_all>
	sys_env_destroy(0);
  8000e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ec:	e8 52 0a 00 00       	call   800b43 <sys_env_destroy>
}
  8000f1:	c9                   	leave  
  8000f2:	c3                   	ret    

008000f3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	53                   	push   %ebx
  8000f7:	83 ec 14             	sub    $0x14,%esp
  8000fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000fd:	8b 13                	mov    (%ebx),%edx
  8000ff:	8d 42 01             	lea    0x1(%edx),%eax
  800102:	89 03                	mov    %eax,(%ebx)
  800104:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800107:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80010b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800110:	75 19                	jne    80012b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800112:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800119:	00 
  80011a:	8d 43 08             	lea    0x8(%ebx),%eax
  80011d:	89 04 24             	mov    %eax,(%esp)
  800120:	e8 e1 09 00 00       	call   800b06 <sys_cputs>
		b->idx = 0;
  800125:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80012b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80012f:	83 c4 14             	add    $0x14,%esp
  800132:	5b                   	pop    %ebx
  800133:	5d                   	pop    %ebp
  800134:	c3                   	ret    

00800135 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80013e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800145:	00 00 00 
	b.cnt = 0;
  800148:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80014f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800152:	8b 45 0c             	mov    0xc(%ebp),%eax
  800155:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800159:	8b 45 08             	mov    0x8(%ebp),%eax
  80015c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800160:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800166:	89 44 24 04          	mov    %eax,0x4(%esp)
  80016a:	c7 04 24 f3 00 80 00 	movl   $0x8000f3,(%esp)
  800171:	e8 a8 01 00 00       	call   80031e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800176:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80017c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800180:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800186:	89 04 24             	mov    %eax,(%esp)
  800189:	e8 78 09 00 00       	call   800b06 <sys_cputs>

	return b.cnt;
}
  80018e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800194:	c9                   	leave  
  800195:	c3                   	ret    

00800196 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80019c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80019f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a6:	89 04 24             	mov    %eax,(%esp)
  8001a9:	e8 87 ff ff ff       	call   800135 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ae:	c9                   	leave  
  8001af:	c3                   	ret    

008001b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	57                   	push   %edi
  8001b4:	56                   	push   %esi
  8001b5:	53                   	push   %ebx
  8001b6:	83 ec 3c             	sub    $0x3c,%esp
  8001b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001bc:	89 d7                	mov    %edx,%edi
  8001be:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c7:	89 c3                	mov    %eax,%ebx
  8001c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8001cf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001da:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001dd:	39 d9                	cmp    %ebx,%ecx
  8001df:	72 05                	jb     8001e6 <printnum+0x36>
  8001e1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001e4:	77 69                	ja     80024f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001e6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8001e9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8001ed:	83 ee 01             	sub    $0x1,%esi
  8001f0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8001f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8001fc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800200:	89 c3                	mov    %eax,%ebx
  800202:	89 d6                	mov    %edx,%esi
  800204:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800207:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80020a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80020e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800212:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800215:	89 04 24             	mov    %eax,(%esp)
  800218:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80021b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021f:	e8 7c 22 00 00       	call   8024a0 <__udivdi3>
  800224:	89 d9                	mov    %ebx,%ecx
  800226:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80022a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80022e:	89 04 24             	mov    %eax,(%esp)
  800231:	89 54 24 04          	mov    %edx,0x4(%esp)
  800235:	89 fa                	mov    %edi,%edx
  800237:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023a:	e8 71 ff ff ff       	call   8001b0 <printnum>
  80023f:	eb 1b                	jmp    80025c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800241:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800245:	8b 45 18             	mov    0x18(%ebp),%eax
  800248:	89 04 24             	mov    %eax,(%esp)
  80024b:	ff d3                	call   *%ebx
  80024d:	eb 03                	jmp    800252 <printnum+0xa2>
  80024f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800252:	83 ee 01             	sub    $0x1,%esi
  800255:	85 f6                	test   %esi,%esi
  800257:	7f e8                	jg     800241 <printnum+0x91>
  800259:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80025c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800260:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800264:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800267:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80026a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800272:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800275:	89 04 24             	mov    %eax,(%esp)
  800278:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80027b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027f:	e8 4c 23 00 00       	call   8025d0 <__umoddi3>
  800284:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800288:	0f be 80 66 27 80 00 	movsbl 0x802766(%eax),%eax
  80028f:	89 04 24             	mov    %eax,(%esp)
  800292:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800295:	ff d0                	call   *%eax
}
  800297:	83 c4 3c             	add    $0x3c,%esp
  80029a:	5b                   	pop    %ebx
  80029b:	5e                   	pop    %esi
  80029c:	5f                   	pop    %edi
  80029d:	5d                   	pop    %ebp
  80029e:	c3                   	ret    

0080029f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002a2:	83 fa 01             	cmp    $0x1,%edx
  8002a5:	7e 0e                	jle    8002b5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002a7:	8b 10                	mov    (%eax),%edx
  8002a9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002ac:	89 08                	mov    %ecx,(%eax)
  8002ae:	8b 02                	mov    (%edx),%eax
  8002b0:	8b 52 04             	mov    0x4(%edx),%edx
  8002b3:	eb 22                	jmp    8002d7 <getuint+0x38>
	else if (lflag)
  8002b5:	85 d2                	test   %edx,%edx
  8002b7:	74 10                	je     8002c9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002b9:	8b 10                	mov    (%eax),%edx
  8002bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002be:	89 08                	mov    %ecx,(%eax)
  8002c0:	8b 02                	mov    (%edx),%eax
  8002c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002c7:	eb 0e                	jmp    8002d7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002c9:	8b 10                	mov    (%eax),%edx
  8002cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ce:	89 08                	mov    %ecx,(%eax)
  8002d0:	8b 02                	mov    (%edx),%eax
  8002d2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002d7:	5d                   	pop    %ebp
  8002d8:	c3                   	ret    

008002d9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002d9:	55                   	push   %ebp
  8002da:	89 e5                	mov    %esp,%ebp
  8002dc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002df:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e3:	8b 10                	mov    (%eax),%edx
  8002e5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002e8:	73 0a                	jae    8002f4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ed:	89 08                	mov    %ecx,(%eax)
  8002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f2:	88 02                	mov    %al,(%edx)
}
  8002f4:	5d                   	pop    %ebp
  8002f5:	c3                   	ret    

008002f6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002f6:	55                   	push   %ebp
  8002f7:	89 e5                	mov    %esp,%ebp
  8002f9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8002fc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800303:	8b 45 10             	mov    0x10(%ebp),%eax
  800306:	89 44 24 08          	mov    %eax,0x8(%esp)
  80030a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800311:	8b 45 08             	mov    0x8(%ebp),%eax
  800314:	89 04 24             	mov    %eax,(%esp)
  800317:	e8 02 00 00 00       	call   80031e <vprintfmt>
	va_end(ap);
}
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	57                   	push   %edi
  800322:	56                   	push   %esi
  800323:	53                   	push   %ebx
  800324:	83 ec 3c             	sub    $0x3c,%esp
  800327:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80032a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80032d:	eb 14                	jmp    800343 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80032f:	85 c0                	test   %eax,%eax
  800331:	0f 84 b3 03 00 00    	je     8006ea <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800337:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80033b:	89 04 24             	mov    %eax,(%esp)
  80033e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800341:	89 f3                	mov    %esi,%ebx
  800343:	8d 73 01             	lea    0x1(%ebx),%esi
  800346:	0f b6 03             	movzbl (%ebx),%eax
  800349:	83 f8 25             	cmp    $0x25,%eax
  80034c:	75 e1                	jne    80032f <vprintfmt+0x11>
  80034e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800352:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800359:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800360:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800367:	ba 00 00 00 00       	mov    $0x0,%edx
  80036c:	eb 1d                	jmp    80038b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80036e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800370:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800374:	eb 15                	jmp    80038b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800376:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800378:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80037c:	eb 0d                	jmp    80038b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80037e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800381:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800384:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80038b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80038e:	0f b6 0e             	movzbl (%esi),%ecx
  800391:	0f b6 c1             	movzbl %cl,%eax
  800394:	83 e9 23             	sub    $0x23,%ecx
  800397:	80 f9 55             	cmp    $0x55,%cl
  80039a:	0f 87 2a 03 00 00    	ja     8006ca <vprintfmt+0x3ac>
  8003a0:	0f b6 c9             	movzbl %cl,%ecx
  8003a3:	ff 24 8d a0 28 80 00 	jmp    *0x8028a0(,%ecx,4)
  8003aa:	89 de                	mov    %ebx,%esi
  8003ac:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003b1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003b4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8003b8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8003bb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8003be:	83 fb 09             	cmp    $0x9,%ebx
  8003c1:	77 36                	ja     8003f9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003c3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003c6:	eb e9                	jmp    8003b1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cb:	8d 48 04             	lea    0x4(%eax),%ecx
  8003ce:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003d6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003d8:	eb 22                	jmp    8003fc <vprintfmt+0xde>
  8003da:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003dd:	85 c9                	test   %ecx,%ecx
  8003df:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e4:	0f 49 c1             	cmovns %ecx,%eax
  8003e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ea:	89 de                	mov    %ebx,%esi
  8003ec:	eb 9d                	jmp    80038b <vprintfmt+0x6d>
  8003ee:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003f0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8003f7:	eb 92                	jmp    80038b <vprintfmt+0x6d>
  8003f9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8003fc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800400:	79 89                	jns    80038b <vprintfmt+0x6d>
  800402:	e9 77 ff ff ff       	jmp    80037e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800407:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80040a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80040c:	e9 7a ff ff ff       	jmp    80038b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800411:	8b 45 14             	mov    0x14(%ebp),%eax
  800414:	8d 50 04             	lea    0x4(%eax),%edx
  800417:	89 55 14             	mov    %edx,0x14(%ebp)
  80041a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	89 04 24             	mov    %eax,(%esp)
  800423:	ff 55 08             	call   *0x8(%ebp)
			break;
  800426:	e9 18 ff ff ff       	jmp    800343 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80042b:	8b 45 14             	mov    0x14(%ebp),%eax
  80042e:	8d 50 04             	lea    0x4(%eax),%edx
  800431:	89 55 14             	mov    %edx,0x14(%ebp)
  800434:	8b 00                	mov    (%eax),%eax
  800436:	99                   	cltd   
  800437:	31 d0                	xor    %edx,%eax
  800439:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043b:	83 f8 11             	cmp    $0x11,%eax
  80043e:	7f 0b                	jg     80044b <vprintfmt+0x12d>
  800440:	8b 14 85 00 2a 80 00 	mov    0x802a00(,%eax,4),%edx
  800447:	85 d2                	test   %edx,%edx
  800449:	75 20                	jne    80046b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80044b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80044f:	c7 44 24 08 7e 27 80 	movl   $0x80277e,0x8(%esp)
  800456:	00 
  800457:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80045b:	8b 45 08             	mov    0x8(%ebp),%eax
  80045e:	89 04 24             	mov    %eax,(%esp)
  800461:	e8 90 fe ff ff       	call   8002f6 <printfmt>
  800466:	e9 d8 fe ff ff       	jmp    800343 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80046b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80046f:	c7 44 24 08 95 2b 80 	movl   $0x802b95,0x8(%esp)
  800476:	00 
  800477:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	89 04 24             	mov    %eax,(%esp)
  800481:	e8 70 fe ff ff       	call   8002f6 <printfmt>
  800486:	e9 b8 fe ff ff       	jmp    800343 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80048e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800491:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800494:	8b 45 14             	mov    0x14(%ebp),%eax
  800497:	8d 50 04             	lea    0x4(%eax),%edx
  80049a:	89 55 14             	mov    %edx,0x14(%ebp)
  80049d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80049f:	85 f6                	test   %esi,%esi
  8004a1:	b8 77 27 80 00       	mov    $0x802777,%eax
  8004a6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8004a9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8004ad:	0f 84 97 00 00 00    	je     80054a <vprintfmt+0x22c>
  8004b3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004b7:	0f 8e 9b 00 00 00    	jle    800558 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004c1:	89 34 24             	mov    %esi,(%esp)
  8004c4:	e8 cf 02 00 00       	call   800798 <strnlen>
  8004c9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004cc:	29 c2                	sub    %eax,%edx
  8004ce:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8004d1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8004d5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004d8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004db:	8b 75 08             	mov    0x8(%ebp),%esi
  8004de:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004e1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e3:	eb 0f                	jmp    8004f4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8004e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ec:	89 04 24             	mov    %eax,(%esp)
  8004ef:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f1:	83 eb 01             	sub    $0x1,%ebx
  8004f4:	85 db                	test   %ebx,%ebx
  8004f6:	7f ed                	jg     8004e5 <vprintfmt+0x1c7>
  8004f8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8004fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004fe:	85 d2                	test   %edx,%edx
  800500:	b8 00 00 00 00       	mov    $0x0,%eax
  800505:	0f 49 c2             	cmovns %edx,%eax
  800508:	29 c2                	sub    %eax,%edx
  80050a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80050d:	89 d7                	mov    %edx,%edi
  80050f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800512:	eb 50                	jmp    800564 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800514:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800518:	74 1e                	je     800538 <vprintfmt+0x21a>
  80051a:	0f be d2             	movsbl %dl,%edx
  80051d:	83 ea 20             	sub    $0x20,%edx
  800520:	83 fa 5e             	cmp    $0x5e,%edx
  800523:	76 13                	jbe    800538 <vprintfmt+0x21a>
					putch('?', putdat);
  800525:	8b 45 0c             	mov    0xc(%ebp),%eax
  800528:	89 44 24 04          	mov    %eax,0x4(%esp)
  80052c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800533:	ff 55 08             	call   *0x8(%ebp)
  800536:	eb 0d                	jmp    800545 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800538:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80053f:	89 04 24             	mov    %eax,(%esp)
  800542:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800545:	83 ef 01             	sub    $0x1,%edi
  800548:	eb 1a                	jmp    800564 <vprintfmt+0x246>
  80054a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80054d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800550:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800553:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800556:	eb 0c                	jmp    800564 <vprintfmt+0x246>
  800558:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80055b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80055e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800561:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800564:	83 c6 01             	add    $0x1,%esi
  800567:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80056b:	0f be c2             	movsbl %dl,%eax
  80056e:	85 c0                	test   %eax,%eax
  800570:	74 27                	je     800599 <vprintfmt+0x27b>
  800572:	85 db                	test   %ebx,%ebx
  800574:	78 9e                	js     800514 <vprintfmt+0x1f6>
  800576:	83 eb 01             	sub    $0x1,%ebx
  800579:	79 99                	jns    800514 <vprintfmt+0x1f6>
  80057b:	89 f8                	mov    %edi,%eax
  80057d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800580:	8b 75 08             	mov    0x8(%ebp),%esi
  800583:	89 c3                	mov    %eax,%ebx
  800585:	eb 1a                	jmp    8005a1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800587:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80058b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800592:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800594:	83 eb 01             	sub    $0x1,%ebx
  800597:	eb 08                	jmp    8005a1 <vprintfmt+0x283>
  800599:	89 fb                	mov    %edi,%ebx
  80059b:	8b 75 08             	mov    0x8(%ebp),%esi
  80059e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005a1:	85 db                	test   %ebx,%ebx
  8005a3:	7f e2                	jg     800587 <vprintfmt+0x269>
  8005a5:	89 75 08             	mov    %esi,0x8(%ebp)
  8005a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005ab:	e9 93 fd ff ff       	jmp    800343 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005b0:	83 fa 01             	cmp    $0x1,%edx
  8005b3:	7e 16                	jle    8005cb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8005b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b8:	8d 50 08             	lea    0x8(%eax),%edx
  8005bb:	89 55 14             	mov    %edx,0x14(%ebp)
  8005be:	8b 50 04             	mov    0x4(%eax),%edx
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005c9:	eb 32                	jmp    8005fd <vprintfmt+0x2df>
	else if (lflag)
  8005cb:	85 d2                	test   %edx,%edx
  8005cd:	74 18                	je     8005e7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8d 50 04             	lea    0x4(%eax),%edx
  8005d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d8:	8b 30                	mov    (%eax),%esi
  8005da:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005dd:	89 f0                	mov    %esi,%eax
  8005df:	c1 f8 1f             	sar    $0x1f,%eax
  8005e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e5:	eb 16                	jmp    8005fd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8005e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ea:	8d 50 04             	lea    0x4(%eax),%edx
  8005ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8005f0:	8b 30                	mov    (%eax),%esi
  8005f2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005f5:	89 f0                	mov    %esi,%eax
  8005f7:	c1 f8 1f             	sar    $0x1f,%eax
  8005fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800600:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800603:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800608:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80060c:	0f 89 80 00 00 00    	jns    800692 <vprintfmt+0x374>
				putch('-', putdat);
  800612:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800616:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80061d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800620:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800623:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800626:	f7 d8                	neg    %eax
  800628:	83 d2 00             	adc    $0x0,%edx
  80062b:	f7 da                	neg    %edx
			}
			base = 10;
  80062d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800632:	eb 5e                	jmp    800692 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800634:	8d 45 14             	lea    0x14(%ebp),%eax
  800637:	e8 63 fc ff ff       	call   80029f <getuint>
			base = 10;
  80063c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800641:	eb 4f                	jmp    800692 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800643:	8d 45 14             	lea    0x14(%ebp),%eax
  800646:	e8 54 fc ff ff       	call   80029f <getuint>
			base = 8;
  80064b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800650:	eb 40                	jmp    800692 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800652:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800656:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80065d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800660:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800664:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80066b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8d 50 04             	lea    0x4(%eax),%edx
  800674:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800677:	8b 00                	mov    (%eax),%eax
  800679:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80067e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800683:	eb 0d                	jmp    800692 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800685:	8d 45 14             	lea    0x14(%ebp),%eax
  800688:	e8 12 fc ff ff       	call   80029f <getuint>
			base = 16;
  80068d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800692:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800696:	89 74 24 10          	mov    %esi,0x10(%esp)
  80069a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80069d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006a1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006a5:	89 04 24             	mov    %eax,(%esp)
  8006a8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006ac:	89 fa                	mov    %edi,%edx
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	e8 fa fa ff ff       	call   8001b0 <printnum>
			break;
  8006b6:	e9 88 fc ff ff       	jmp    800343 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006bb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006bf:	89 04 24             	mov    %eax,(%esp)
  8006c2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006c5:	e9 79 fc ff ff       	jmp    800343 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ce:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006d5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006d8:	89 f3                	mov    %esi,%ebx
  8006da:	eb 03                	jmp    8006df <vprintfmt+0x3c1>
  8006dc:	83 eb 01             	sub    $0x1,%ebx
  8006df:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8006e3:	75 f7                	jne    8006dc <vprintfmt+0x3be>
  8006e5:	e9 59 fc ff ff       	jmp    800343 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8006ea:	83 c4 3c             	add    $0x3c,%esp
  8006ed:	5b                   	pop    %ebx
  8006ee:	5e                   	pop    %esi
  8006ef:	5f                   	pop    %edi
  8006f0:	5d                   	pop    %ebp
  8006f1:	c3                   	ret    

008006f2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006f2:	55                   	push   %ebp
  8006f3:	89 e5                	mov    %esp,%ebp
  8006f5:	83 ec 28             	sub    $0x28,%esp
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800701:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800705:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800708:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80070f:	85 c0                	test   %eax,%eax
  800711:	74 30                	je     800743 <vsnprintf+0x51>
  800713:	85 d2                	test   %edx,%edx
  800715:	7e 2c                	jle    800743 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80071e:	8b 45 10             	mov    0x10(%ebp),%eax
  800721:	89 44 24 08          	mov    %eax,0x8(%esp)
  800725:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800728:	89 44 24 04          	mov    %eax,0x4(%esp)
  80072c:	c7 04 24 d9 02 80 00 	movl   $0x8002d9,(%esp)
  800733:	e8 e6 fb ff ff       	call   80031e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80073b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800741:	eb 05                	jmp    800748 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800743:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800748:	c9                   	leave  
  800749:	c3                   	ret    

0080074a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80074a:	55                   	push   %ebp
  80074b:	89 e5                	mov    %esp,%ebp
  80074d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800750:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800753:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800757:	8b 45 10             	mov    0x10(%ebp),%eax
  80075a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80075e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800761:	89 44 24 04          	mov    %eax,0x4(%esp)
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 04 24             	mov    %eax,(%esp)
  80076b:	e8 82 ff ff ff       	call   8006f2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800770:	c9                   	leave  
  800771:	c3                   	ret    
  800772:	66 90                	xchg   %ax,%ax
  800774:	66 90                	xchg   %ax,%ax
  800776:	66 90                	xchg   %ax,%ax
  800778:	66 90                	xchg   %ax,%ax
  80077a:	66 90                	xchg   %ax,%ax
  80077c:	66 90                	xchg   %ax,%ax
  80077e:	66 90                	xchg   %ax,%ax

00800780 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800786:	b8 00 00 00 00       	mov    $0x0,%eax
  80078b:	eb 03                	jmp    800790 <strlen+0x10>
		n++;
  80078d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800790:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800794:	75 f7                	jne    80078d <strlen+0xd>
		n++;
	return n;
}
  800796:	5d                   	pop    %ebp
  800797:	c3                   	ret    

00800798 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80079e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a6:	eb 03                	jmp    8007ab <strnlen+0x13>
		n++;
  8007a8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ab:	39 d0                	cmp    %edx,%eax
  8007ad:	74 06                	je     8007b5 <strnlen+0x1d>
  8007af:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007b3:	75 f3                	jne    8007a8 <strnlen+0x10>
		n++;
	return n;
}
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	53                   	push   %ebx
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007c1:	89 c2                	mov    %eax,%edx
  8007c3:	83 c2 01             	add    $0x1,%edx
  8007c6:	83 c1 01             	add    $0x1,%ecx
  8007c9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007cd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007d0:	84 db                	test   %bl,%bl
  8007d2:	75 ef                	jne    8007c3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007d4:	5b                   	pop    %ebx
  8007d5:	5d                   	pop    %ebp
  8007d6:	c3                   	ret    

008007d7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	53                   	push   %ebx
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007e1:	89 1c 24             	mov    %ebx,(%esp)
  8007e4:	e8 97 ff ff ff       	call   800780 <strlen>
	strcpy(dst + len, src);
  8007e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ec:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007f0:	01 d8                	add    %ebx,%eax
  8007f2:	89 04 24             	mov    %eax,(%esp)
  8007f5:	e8 bd ff ff ff       	call   8007b7 <strcpy>
	return dst;
}
  8007fa:	89 d8                	mov    %ebx,%eax
  8007fc:	83 c4 08             	add    $0x8,%esp
  8007ff:	5b                   	pop    %ebx
  800800:	5d                   	pop    %ebp
  800801:	c3                   	ret    

00800802 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	56                   	push   %esi
  800806:	53                   	push   %ebx
  800807:	8b 75 08             	mov    0x8(%ebp),%esi
  80080a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80080d:	89 f3                	mov    %esi,%ebx
  80080f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800812:	89 f2                	mov    %esi,%edx
  800814:	eb 0f                	jmp    800825 <strncpy+0x23>
		*dst++ = *src;
  800816:	83 c2 01             	add    $0x1,%edx
  800819:	0f b6 01             	movzbl (%ecx),%eax
  80081c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80081f:	80 39 01             	cmpb   $0x1,(%ecx)
  800822:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800825:	39 da                	cmp    %ebx,%edx
  800827:	75 ed                	jne    800816 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800829:	89 f0                	mov    %esi,%eax
  80082b:	5b                   	pop    %ebx
  80082c:	5e                   	pop    %esi
  80082d:	5d                   	pop    %ebp
  80082e:	c3                   	ret    

0080082f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	56                   	push   %esi
  800833:	53                   	push   %ebx
  800834:	8b 75 08             	mov    0x8(%ebp),%esi
  800837:	8b 55 0c             	mov    0xc(%ebp),%edx
  80083a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80083d:	89 f0                	mov    %esi,%eax
  80083f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800843:	85 c9                	test   %ecx,%ecx
  800845:	75 0b                	jne    800852 <strlcpy+0x23>
  800847:	eb 1d                	jmp    800866 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800849:	83 c0 01             	add    $0x1,%eax
  80084c:	83 c2 01             	add    $0x1,%edx
  80084f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800852:	39 d8                	cmp    %ebx,%eax
  800854:	74 0b                	je     800861 <strlcpy+0x32>
  800856:	0f b6 0a             	movzbl (%edx),%ecx
  800859:	84 c9                	test   %cl,%cl
  80085b:	75 ec                	jne    800849 <strlcpy+0x1a>
  80085d:	89 c2                	mov    %eax,%edx
  80085f:	eb 02                	jmp    800863 <strlcpy+0x34>
  800861:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800863:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800866:	29 f0                	sub    %esi,%eax
}
  800868:	5b                   	pop    %ebx
  800869:	5e                   	pop    %esi
  80086a:	5d                   	pop    %ebp
  80086b:	c3                   	ret    

0080086c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80086c:	55                   	push   %ebp
  80086d:	89 e5                	mov    %esp,%ebp
  80086f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800872:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800875:	eb 06                	jmp    80087d <strcmp+0x11>
		p++, q++;
  800877:	83 c1 01             	add    $0x1,%ecx
  80087a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80087d:	0f b6 01             	movzbl (%ecx),%eax
  800880:	84 c0                	test   %al,%al
  800882:	74 04                	je     800888 <strcmp+0x1c>
  800884:	3a 02                	cmp    (%edx),%al
  800886:	74 ef                	je     800877 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800888:	0f b6 c0             	movzbl %al,%eax
  80088b:	0f b6 12             	movzbl (%edx),%edx
  80088e:	29 d0                	sub    %edx,%eax
}
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    

00800892 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	53                   	push   %ebx
  800896:	8b 45 08             	mov    0x8(%ebp),%eax
  800899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089c:	89 c3                	mov    %eax,%ebx
  80089e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008a1:	eb 06                	jmp    8008a9 <strncmp+0x17>
		n--, p++, q++;
  8008a3:	83 c0 01             	add    $0x1,%eax
  8008a6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008a9:	39 d8                	cmp    %ebx,%eax
  8008ab:	74 15                	je     8008c2 <strncmp+0x30>
  8008ad:	0f b6 08             	movzbl (%eax),%ecx
  8008b0:	84 c9                	test   %cl,%cl
  8008b2:	74 04                	je     8008b8 <strncmp+0x26>
  8008b4:	3a 0a                	cmp    (%edx),%cl
  8008b6:	74 eb                	je     8008a3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008b8:	0f b6 00             	movzbl (%eax),%eax
  8008bb:	0f b6 12             	movzbl (%edx),%edx
  8008be:	29 d0                	sub    %edx,%eax
  8008c0:	eb 05                	jmp    8008c7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008c2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008c7:	5b                   	pop    %ebx
  8008c8:	5d                   	pop    %ebp
  8008c9:	c3                   	ret    

008008ca <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008d4:	eb 07                	jmp    8008dd <strchr+0x13>
		if (*s == c)
  8008d6:	38 ca                	cmp    %cl,%dl
  8008d8:	74 0f                	je     8008e9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008da:	83 c0 01             	add    $0x1,%eax
  8008dd:	0f b6 10             	movzbl (%eax),%edx
  8008e0:	84 d2                	test   %dl,%dl
  8008e2:	75 f2                	jne    8008d6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8008e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008e9:	5d                   	pop    %ebp
  8008ea:	c3                   	ret    

008008eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008f5:	eb 07                	jmp    8008fe <strfind+0x13>
		if (*s == c)
  8008f7:	38 ca                	cmp    %cl,%dl
  8008f9:	74 0a                	je     800905 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8008fb:	83 c0 01             	add    $0x1,%eax
  8008fe:	0f b6 10             	movzbl (%eax),%edx
  800901:	84 d2                	test   %dl,%dl
  800903:	75 f2                	jne    8008f7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	57                   	push   %edi
  80090b:	56                   	push   %esi
  80090c:	53                   	push   %ebx
  80090d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800910:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800913:	85 c9                	test   %ecx,%ecx
  800915:	74 36                	je     80094d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800917:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80091d:	75 28                	jne    800947 <memset+0x40>
  80091f:	f6 c1 03             	test   $0x3,%cl
  800922:	75 23                	jne    800947 <memset+0x40>
		c &= 0xFF;
  800924:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800928:	89 d3                	mov    %edx,%ebx
  80092a:	c1 e3 08             	shl    $0x8,%ebx
  80092d:	89 d6                	mov    %edx,%esi
  80092f:	c1 e6 18             	shl    $0x18,%esi
  800932:	89 d0                	mov    %edx,%eax
  800934:	c1 e0 10             	shl    $0x10,%eax
  800937:	09 f0                	or     %esi,%eax
  800939:	09 c2                	or     %eax,%edx
  80093b:	89 d0                	mov    %edx,%eax
  80093d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80093f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800942:	fc                   	cld    
  800943:	f3 ab                	rep stos %eax,%es:(%edi)
  800945:	eb 06                	jmp    80094d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094a:	fc                   	cld    
  80094b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80094d:	89 f8                	mov    %edi,%eax
  80094f:	5b                   	pop    %ebx
  800950:	5e                   	pop    %esi
  800951:	5f                   	pop    %edi
  800952:	5d                   	pop    %ebp
  800953:	c3                   	ret    

00800954 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800954:	55                   	push   %ebp
  800955:	89 e5                	mov    %esp,%ebp
  800957:	57                   	push   %edi
  800958:	56                   	push   %esi
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80095f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800962:	39 c6                	cmp    %eax,%esi
  800964:	73 35                	jae    80099b <memmove+0x47>
  800966:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800969:	39 d0                	cmp    %edx,%eax
  80096b:	73 2e                	jae    80099b <memmove+0x47>
		s += n;
		d += n;
  80096d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800970:	89 d6                	mov    %edx,%esi
  800972:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800974:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80097a:	75 13                	jne    80098f <memmove+0x3b>
  80097c:	f6 c1 03             	test   $0x3,%cl
  80097f:	75 0e                	jne    80098f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800981:	83 ef 04             	sub    $0x4,%edi
  800984:	8d 72 fc             	lea    -0x4(%edx),%esi
  800987:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80098a:	fd                   	std    
  80098b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80098d:	eb 09                	jmp    800998 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80098f:	83 ef 01             	sub    $0x1,%edi
  800992:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800995:	fd                   	std    
  800996:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800998:	fc                   	cld    
  800999:	eb 1d                	jmp    8009b8 <memmove+0x64>
  80099b:	89 f2                	mov    %esi,%edx
  80099d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099f:	f6 c2 03             	test   $0x3,%dl
  8009a2:	75 0f                	jne    8009b3 <memmove+0x5f>
  8009a4:	f6 c1 03             	test   $0x3,%cl
  8009a7:	75 0a                	jne    8009b3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009a9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8009ac:	89 c7                	mov    %eax,%edi
  8009ae:	fc                   	cld    
  8009af:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b1:	eb 05                	jmp    8009b8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009b3:	89 c7                	mov    %eax,%edi
  8009b5:	fc                   	cld    
  8009b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009b8:	5e                   	pop    %esi
  8009b9:	5f                   	pop    %edi
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	89 04 24             	mov    %eax,(%esp)
  8009d6:	e8 79 ff ff ff       	call   800954 <memmove>
}
  8009db:	c9                   	leave  
  8009dc:	c3                   	ret    

008009dd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	56                   	push   %esi
  8009e1:	53                   	push   %ebx
  8009e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e8:	89 d6                	mov    %edx,%esi
  8009ea:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ed:	eb 1a                	jmp    800a09 <memcmp+0x2c>
		if (*s1 != *s2)
  8009ef:	0f b6 02             	movzbl (%edx),%eax
  8009f2:	0f b6 19             	movzbl (%ecx),%ebx
  8009f5:	38 d8                	cmp    %bl,%al
  8009f7:	74 0a                	je     800a03 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8009f9:	0f b6 c0             	movzbl %al,%eax
  8009fc:	0f b6 db             	movzbl %bl,%ebx
  8009ff:	29 d8                	sub    %ebx,%eax
  800a01:	eb 0f                	jmp    800a12 <memcmp+0x35>
		s1++, s2++;
  800a03:	83 c2 01             	add    $0x1,%edx
  800a06:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a09:	39 f2                	cmp    %esi,%edx
  800a0b:	75 e2                	jne    8009ef <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a12:	5b                   	pop    %ebx
  800a13:	5e                   	pop    %esi
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a1f:	89 c2                	mov    %eax,%edx
  800a21:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a24:	eb 07                	jmp    800a2d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a26:	38 08                	cmp    %cl,(%eax)
  800a28:	74 07                	je     800a31 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a2a:	83 c0 01             	add    $0x1,%eax
  800a2d:	39 d0                	cmp    %edx,%eax
  800a2f:	72 f5                	jb     800a26 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a31:	5d                   	pop    %ebp
  800a32:	c3                   	ret    

00800a33 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a33:	55                   	push   %ebp
  800a34:	89 e5                	mov    %esp,%ebp
  800a36:	57                   	push   %edi
  800a37:	56                   	push   %esi
  800a38:	53                   	push   %ebx
  800a39:	8b 55 08             	mov    0x8(%ebp),%edx
  800a3c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a3f:	eb 03                	jmp    800a44 <strtol+0x11>
		s++;
  800a41:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a44:	0f b6 0a             	movzbl (%edx),%ecx
  800a47:	80 f9 09             	cmp    $0x9,%cl
  800a4a:	74 f5                	je     800a41 <strtol+0xe>
  800a4c:	80 f9 20             	cmp    $0x20,%cl
  800a4f:	74 f0                	je     800a41 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a51:	80 f9 2b             	cmp    $0x2b,%cl
  800a54:	75 0a                	jne    800a60 <strtol+0x2d>
		s++;
  800a56:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a59:	bf 00 00 00 00       	mov    $0x0,%edi
  800a5e:	eb 11                	jmp    800a71 <strtol+0x3e>
  800a60:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a65:	80 f9 2d             	cmp    $0x2d,%cl
  800a68:	75 07                	jne    800a71 <strtol+0x3e>
		s++, neg = 1;
  800a6a:	8d 52 01             	lea    0x1(%edx),%edx
  800a6d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a71:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800a76:	75 15                	jne    800a8d <strtol+0x5a>
  800a78:	80 3a 30             	cmpb   $0x30,(%edx)
  800a7b:	75 10                	jne    800a8d <strtol+0x5a>
  800a7d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800a81:	75 0a                	jne    800a8d <strtol+0x5a>
		s += 2, base = 16;
  800a83:	83 c2 02             	add    $0x2,%edx
  800a86:	b8 10 00 00 00       	mov    $0x10,%eax
  800a8b:	eb 10                	jmp    800a9d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800a8d:	85 c0                	test   %eax,%eax
  800a8f:	75 0c                	jne    800a9d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a91:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a93:	80 3a 30             	cmpb   $0x30,(%edx)
  800a96:	75 05                	jne    800a9d <strtol+0x6a>
		s++, base = 8;
  800a98:	83 c2 01             	add    $0x1,%edx
  800a9b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800a9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800aa2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800aa5:	0f b6 0a             	movzbl (%edx),%ecx
  800aa8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800aab:	89 f0                	mov    %esi,%eax
  800aad:	3c 09                	cmp    $0x9,%al
  800aaf:	77 08                	ja     800ab9 <strtol+0x86>
			dig = *s - '0';
  800ab1:	0f be c9             	movsbl %cl,%ecx
  800ab4:	83 e9 30             	sub    $0x30,%ecx
  800ab7:	eb 20                	jmp    800ad9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ab9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800abc:	89 f0                	mov    %esi,%eax
  800abe:	3c 19                	cmp    $0x19,%al
  800ac0:	77 08                	ja     800aca <strtol+0x97>
			dig = *s - 'a' + 10;
  800ac2:	0f be c9             	movsbl %cl,%ecx
  800ac5:	83 e9 57             	sub    $0x57,%ecx
  800ac8:	eb 0f                	jmp    800ad9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800aca:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800acd:	89 f0                	mov    %esi,%eax
  800acf:	3c 19                	cmp    $0x19,%al
  800ad1:	77 16                	ja     800ae9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800ad3:	0f be c9             	movsbl %cl,%ecx
  800ad6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ad9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800adc:	7d 0f                	jge    800aed <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800ade:	83 c2 01             	add    $0x1,%edx
  800ae1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ae5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ae7:	eb bc                	jmp    800aa5 <strtol+0x72>
  800ae9:	89 d8                	mov    %ebx,%eax
  800aeb:	eb 02                	jmp    800aef <strtol+0xbc>
  800aed:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800aef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af3:	74 05                	je     800afa <strtol+0xc7>
		*endptr = (char *) s;
  800af5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800af8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800afa:	f7 d8                	neg    %eax
  800afc:	85 ff                	test   %edi,%edi
  800afe:	0f 44 c3             	cmove  %ebx,%eax
}
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	57                   	push   %edi
  800b0a:	56                   	push   %esi
  800b0b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b14:	8b 55 08             	mov    0x8(%ebp),%edx
  800b17:	89 c3                	mov    %eax,%ebx
  800b19:	89 c7                	mov    %eax,%edi
  800b1b:	89 c6                	mov    %eax,%esi
  800b1d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b1f:	5b                   	pop    %ebx
  800b20:	5e                   	pop    %esi
  800b21:	5f                   	pop    %edi
  800b22:	5d                   	pop    %ebp
  800b23:	c3                   	ret    

00800b24 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b24:	55                   	push   %ebp
  800b25:	89 e5                	mov    %esp,%ebp
  800b27:	57                   	push   %edi
  800b28:	56                   	push   %esi
  800b29:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b34:	89 d1                	mov    %edx,%ecx
  800b36:	89 d3                	mov    %edx,%ebx
  800b38:	89 d7                	mov    %edx,%edi
  800b3a:	89 d6                	mov    %edx,%esi
  800b3c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b3e:	5b                   	pop    %ebx
  800b3f:	5e                   	pop    %esi
  800b40:	5f                   	pop    %edi
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	57                   	push   %edi
  800b47:	56                   	push   %esi
  800b48:	53                   	push   %ebx
  800b49:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b4c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b51:	b8 03 00 00 00       	mov    $0x3,%eax
  800b56:	8b 55 08             	mov    0x8(%ebp),%edx
  800b59:	89 cb                	mov    %ecx,%ebx
  800b5b:	89 cf                	mov    %ecx,%edi
  800b5d:	89 ce                	mov    %ecx,%esi
  800b5f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b61:	85 c0                	test   %eax,%eax
  800b63:	7e 28                	jle    800b8d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b65:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b69:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800b70:	00 
  800b71:	c7 44 24 08 67 2a 80 	movl   $0x802a67,0x8(%esp)
  800b78:	00 
  800b79:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800b80:	00 
  800b81:	c7 04 24 84 2a 80 00 	movl   $0x802a84,(%esp)
  800b88:	e8 49 17 00 00       	call   8022d6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b8d:	83 c4 2c             	add    $0x2c,%esp
  800b90:	5b                   	pop    %ebx
  800b91:	5e                   	pop    %esi
  800b92:	5f                   	pop    %edi
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	57                   	push   %edi
  800b99:	56                   	push   %esi
  800b9a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	b8 02 00 00 00       	mov    $0x2,%eax
  800ba5:	89 d1                	mov    %edx,%ecx
  800ba7:	89 d3                	mov    %edx,%ebx
  800ba9:	89 d7                	mov    %edx,%edi
  800bab:	89 d6                	mov    %edx,%esi
  800bad:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800baf:	5b                   	pop    %ebx
  800bb0:	5e                   	pop    %esi
  800bb1:	5f                   	pop    %edi
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <sys_yield>:

void
sys_yield(void)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	57                   	push   %edi
  800bb8:	56                   	push   %esi
  800bb9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bba:	ba 00 00 00 00       	mov    $0x0,%edx
  800bbf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bc4:	89 d1                	mov    %edx,%ecx
  800bc6:	89 d3                	mov    %edx,%ebx
  800bc8:	89 d7                	mov    %edx,%edi
  800bca:	89 d6                	mov    %edx,%esi
  800bcc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5f                   	pop    %edi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
  800bd9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bdc:	be 00 00 00 00       	mov    $0x0,%esi
  800be1:	b8 04 00 00 00       	mov    $0x4,%eax
  800be6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800be9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bef:	89 f7                	mov    %esi,%edi
  800bf1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800bf3:	85 c0                	test   %eax,%eax
  800bf5:	7e 28                	jle    800c1f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bf7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bfb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c02:	00 
  800c03:	c7 44 24 08 67 2a 80 	movl   $0x802a67,0x8(%esp)
  800c0a:	00 
  800c0b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c12:	00 
  800c13:	c7 04 24 84 2a 80 00 	movl   $0x802a84,(%esp)
  800c1a:	e8 b7 16 00 00       	call   8022d6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c1f:	83 c4 2c             	add    $0x2c,%esp
  800c22:	5b                   	pop    %ebx
  800c23:	5e                   	pop    %esi
  800c24:	5f                   	pop    %edi
  800c25:	5d                   	pop    %ebp
  800c26:	c3                   	ret    

00800c27 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	57                   	push   %edi
  800c2b:	56                   	push   %esi
  800c2c:	53                   	push   %ebx
  800c2d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c30:	b8 05 00 00 00       	mov    $0x5,%eax
  800c35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c38:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c3e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c41:	8b 75 18             	mov    0x18(%ebp),%esi
  800c44:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c46:	85 c0                	test   %eax,%eax
  800c48:	7e 28                	jle    800c72 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c4e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800c55:	00 
  800c56:	c7 44 24 08 67 2a 80 	movl   $0x802a67,0x8(%esp)
  800c5d:	00 
  800c5e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c65:	00 
  800c66:	c7 04 24 84 2a 80 00 	movl   $0x802a84,(%esp)
  800c6d:	e8 64 16 00 00       	call   8022d6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c72:	83 c4 2c             	add    $0x2c,%esp
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5f                   	pop    %edi
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    

00800c7a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
  800c7d:	57                   	push   %edi
  800c7e:	56                   	push   %esi
  800c7f:	53                   	push   %ebx
  800c80:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c88:	b8 06 00 00 00       	mov    $0x6,%eax
  800c8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c90:	8b 55 08             	mov    0x8(%ebp),%edx
  800c93:	89 df                	mov    %ebx,%edi
  800c95:	89 de                	mov    %ebx,%esi
  800c97:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c99:	85 c0                	test   %eax,%eax
  800c9b:	7e 28                	jle    800cc5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c9d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ca1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ca8:	00 
  800ca9:	c7 44 24 08 67 2a 80 	movl   $0x802a67,0x8(%esp)
  800cb0:	00 
  800cb1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cb8:	00 
  800cb9:	c7 04 24 84 2a 80 00 	movl   $0x802a84,(%esp)
  800cc0:	e8 11 16 00 00       	call   8022d6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cc5:	83 c4 2c             	add    $0x2c,%esp
  800cc8:	5b                   	pop    %ebx
  800cc9:	5e                   	pop    %esi
  800cca:	5f                   	pop    %edi
  800ccb:	5d                   	pop    %ebp
  800ccc:	c3                   	ret    

00800ccd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ccd:	55                   	push   %ebp
  800cce:	89 e5                	mov    %esp,%ebp
  800cd0:	57                   	push   %edi
  800cd1:	56                   	push   %esi
  800cd2:	53                   	push   %ebx
  800cd3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdb:	b8 08 00 00 00       	mov    $0x8,%eax
  800ce0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce6:	89 df                	mov    %ebx,%edi
  800ce8:	89 de                	mov    %ebx,%esi
  800cea:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cec:	85 c0                	test   %eax,%eax
  800cee:	7e 28                	jle    800d18 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cf4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800cfb:	00 
  800cfc:	c7 44 24 08 67 2a 80 	movl   $0x802a67,0x8(%esp)
  800d03:	00 
  800d04:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d0b:	00 
  800d0c:	c7 04 24 84 2a 80 00 	movl   $0x802a84,(%esp)
  800d13:	e8 be 15 00 00       	call   8022d6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d18:	83 c4 2c             	add    $0x2c,%esp
  800d1b:	5b                   	pop    %ebx
  800d1c:	5e                   	pop    %esi
  800d1d:	5f                   	pop    %edi
  800d1e:	5d                   	pop    %ebp
  800d1f:	c3                   	ret    

00800d20 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	57                   	push   %edi
  800d24:	56                   	push   %esi
  800d25:	53                   	push   %ebx
  800d26:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d29:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d2e:	b8 09 00 00 00       	mov    $0x9,%eax
  800d33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	89 df                	mov    %ebx,%edi
  800d3b:	89 de                	mov    %ebx,%esi
  800d3d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d3f:	85 c0                	test   %eax,%eax
  800d41:	7e 28                	jle    800d6b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d43:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d47:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d4e:	00 
  800d4f:	c7 44 24 08 67 2a 80 	movl   $0x802a67,0x8(%esp)
  800d56:	00 
  800d57:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d5e:	00 
  800d5f:	c7 04 24 84 2a 80 00 	movl   $0x802a84,(%esp)
  800d66:	e8 6b 15 00 00       	call   8022d6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d6b:	83 c4 2c             	add    $0x2c,%esp
  800d6e:	5b                   	pop    %ebx
  800d6f:	5e                   	pop    %esi
  800d70:	5f                   	pop    %edi
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	57                   	push   %edi
  800d77:	56                   	push   %esi
  800d78:	53                   	push   %ebx
  800d79:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d7c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d81:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d89:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8c:	89 df                	mov    %ebx,%edi
  800d8e:	89 de                	mov    %ebx,%esi
  800d90:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d92:	85 c0                	test   %eax,%eax
  800d94:	7e 28                	jle    800dbe <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d96:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d9a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800da1:	00 
  800da2:	c7 44 24 08 67 2a 80 	movl   $0x802a67,0x8(%esp)
  800da9:	00 
  800daa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800db1:	00 
  800db2:	c7 04 24 84 2a 80 00 	movl   $0x802a84,(%esp)
  800db9:	e8 18 15 00 00       	call   8022d6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dbe:	83 c4 2c             	add    $0x2c,%esp
  800dc1:	5b                   	pop    %ebx
  800dc2:	5e                   	pop    %esi
  800dc3:	5f                   	pop    %edi
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    

00800dc6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	57                   	push   %edi
  800dca:	56                   	push   %esi
  800dcb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dcc:	be 00 00 00 00       	mov    $0x0,%esi
  800dd1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800dd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5f                   	pop    %edi
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	57                   	push   %edi
  800ded:	56                   	push   %esi
  800dee:	53                   	push   %ebx
  800def:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800df7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dfc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dff:	89 cb                	mov    %ecx,%ebx
  800e01:	89 cf                	mov    %ecx,%edi
  800e03:	89 ce                	mov    %ecx,%esi
  800e05:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e07:	85 c0                	test   %eax,%eax
  800e09:	7e 28                	jle    800e33 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e16:	00 
  800e17:	c7 44 24 08 67 2a 80 	movl   $0x802a67,0x8(%esp)
  800e1e:	00 
  800e1f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e26:	00 
  800e27:	c7 04 24 84 2a 80 00 	movl   $0x802a84,(%esp)
  800e2e:	e8 a3 14 00 00       	call   8022d6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e33:	83 c4 2c             	add    $0x2c,%esp
  800e36:	5b                   	pop    %ebx
  800e37:	5e                   	pop    %esi
  800e38:	5f                   	pop    %edi
  800e39:	5d                   	pop    %ebp
  800e3a:	c3                   	ret    

00800e3b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e3b:	55                   	push   %ebp
  800e3c:	89 e5                	mov    %esp,%ebp
  800e3e:	57                   	push   %edi
  800e3f:	56                   	push   %esi
  800e40:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e41:	ba 00 00 00 00       	mov    $0x0,%edx
  800e46:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e4b:	89 d1                	mov    %edx,%ecx
  800e4d:	89 d3                	mov    %edx,%ebx
  800e4f:	89 d7                	mov    %edx,%edi
  800e51:	89 d6                	mov    %edx,%esi
  800e53:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e55:	5b                   	pop    %ebx
  800e56:	5e                   	pop    %esi
  800e57:	5f                   	pop    %edi
  800e58:	5d                   	pop    %ebp
  800e59:	c3                   	ret    

00800e5a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	57                   	push   %edi
  800e5e:	56                   	push   %esi
  800e5f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e60:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e65:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e70:	89 df                	mov    %ebx,%edi
  800e72:	89 de                	mov    %ebx,%esi
  800e74:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5f                   	pop    %edi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	57                   	push   %edi
  800e7f:	56                   	push   %esi
  800e80:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e86:	b8 10 00 00 00       	mov    $0x10,%eax
  800e8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e91:	89 df                	mov    %ebx,%edi
  800e93:	89 de                	mov    %ebx,%esi
  800e95:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800e97:	5b                   	pop    %ebx
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	57                   	push   %edi
  800ea0:	56                   	push   %esi
  800ea1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea7:	b8 11 00 00 00       	mov    $0x11,%eax
  800eac:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaf:	89 cb                	mov    %ecx,%ebx
  800eb1:	89 cf                	mov    %ecx,%edi
  800eb3:	89 ce                	mov    %ecx,%esi
  800eb5:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800eb7:	5b                   	pop    %ebx
  800eb8:	5e                   	pop    %esi
  800eb9:	5f                   	pop    %edi
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	57                   	push   %edi
  800ec0:	56                   	push   %esi
  800ec1:	53                   	push   %ebx
  800ec2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec5:	be 00 00 00 00       	mov    $0x0,%esi
  800eca:	b8 12 00 00 00       	mov    $0x12,%eax
  800ecf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800edb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800edd:	85 c0                	test   %eax,%eax
  800edf:	7e 28                	jle    800f09 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800eec:	00 
  800eed:	c7 44 24 08 67 2a 80 	movl   $0x802a67,0x8(%esp)
  800ef4:	00 
  800ef5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800efc:	00 
  800efd:	c7 04 24 84 2a 80 00 	movl   $0x802a84,(%esp)
  800f04:	e8 cd 13 00 00       	call   8022d6 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  800f09:	83 c4 2c             	add    $0x2c,%esp
  800f0c:	5b                   	pop    %ebx
  800f0d:	5e                   	pop    %esi
  800f0e:	5f                   	pop    %edi
  800f0f:	5d                   	pop    %ebp
  800f10:	c3                   	ret    

00800f11 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800f11:	55                   	push   %ebp
  800f12:	89 e5                	mov    %esp,%ebp
  800f14:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  800f17:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800f1e:	75 68                	jne    800f88 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  800f20:	a1 08 40 80 00       	mov    0x804008,%eax
  800f25:	8b 40 48             	mov    0x48(%eax),%eax
  800f28:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800f2f:	00 
  800f30:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800f37:	ee 
  800f38:	89 04 24             	mov    %eax,(%esp)
  800f3b:	e8 93 fc ff ff       	call   800bd3 <sys_page_alloc>
  800f40:	85 c0                	test   %eax,%eax
  800f42:	74 2c                	je     800f70 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  800f44:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f48:	c7 04 24 94 2a 80 00 	movl   $0x802a94,(%esp)
  800f4f:	e8 42 f2 ff ff       	call   800196 <cprintf>
			panic("set_pg_fault_handler");
  800f54:	c7 44 24 08 c7 2a 80 	movl   $0x802ac7,0x8(%esp)
  800f5b:	00 
  800f5c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800f63:	00 
  800f64:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  800f6b:	e8 66 13 00 00       	call   8022d6 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  800f70:	a1 08 40 80 00       	mov    0x804008,%eax
  800f75:	8b 40 48             	mov    0x48(%eax),%eax
  800f78:	c7 44 24 04 92 0f 80 	movl   $0x800f92,0x4(%esp)
  800f7f:	00 
  800f80:	89 04 24             	mov    %eax,(%esp)
  800f83:	e8 eb fd ff ff       	call   800d73 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800f90:	c9                   	leave  
  800f91:	c3                   	ret    

00800f92 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800f92:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800f93:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800f98:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800f9a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  800f9d:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  800fa3:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  800fa7:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  800fa8:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  800fab:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  800fad:	58                   	pop    %eax
	popl %eax
  800fae:	58                   	pop    %eax
	popal
  800faf:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  800fb0:	83 c4 04             	add    $0x4,%esp
	popfl
  800fb3:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800fb4:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  800fb5:	c3                   	ret    
  800fb6:	66 90                	xchg   %ax,%ax
  800fb8:	66 90                	xchg   %ax,%ax
  800fba:	66 90                	xchg   %ax,%ax
  800fbc:	66 90                	xchg   %ax,%ax
  800fbe:	66 90                	xchg   %ax,%ax

00800fc0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	05 00 00 00 30       	add    $0x30000000,%eax
  800fcb:	c1 e8 0c             	shr    $0xc,%eax
}
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800fdb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fe0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fe5:	5d                   	pop    %ebp
  800fe6:	c3                   	ret    

00800fe7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fed:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ff2:	89 c2                	mov    %eax,%edx
  800ff4:	c1 ea 16             	shr    $0x16,%edx
  800ff7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ffe:	f6 c2 01             	test   $0x1,%dl
  801001:	74 11                	je     801014 <fd_alloc+0x2d>
  801003:	89 c2                	mov    %eax,%edx
  801005:	c1 ea 0c             	shr    $0xc,%edx
  801008:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80100f:	f6 c2 01             	test   $0x1,%dl
  801012:	75 09                	jne    80101d <fd_alloc+0x36>
			*fd_store = fd;
  801014:	89 01                	mov    %eax,(%ecx)
			return 0;
  801016:	b8 00 00 00 00       	mov    $0x0,%eax
  80101b:	eb 17                	jmp    801034 <fd_alloc+0x4d>
  80101d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801022:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801027:	75 c9                	jne    800ff2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801029:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80102f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    

00801036 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80103c:	83 f8 1f             	cmp    $0x1f,%eax
  80103f:	77 36                	ja     801077 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801041:	c1 e0 0c             	shl    $0xc,%eax
  801044:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801049:	89 c2                	mov    %eax,%edx
  80104b:	c1 ea 16             	shr    $0x16,%edx
  80104e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801055:	f6 c2 01             	test   $0x1,%dl
  801058:	74 24                	je     80107e <fd_lookup+0x48>
  80105a:	89 c2                	mov    %eax,%edx
  80105c:	c1 ea 0c             	shr    $0xc,%edx
  80105f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801066:	f6 c2 01             	test   $0x1,%dl
  801069:	74 1a                	je     801085 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80106b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106e:	89 02                	mov    %eax,(%edx)
	return 0;
  801070:	b8 00 00 00 00       	mov    $0x0,%eax
  801075:	eb 13                	jmp    80108a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801077:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107c:	eb 0c                	jmp    80108a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80107e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801083:	eb 05                	jmp    80108a <fd_lookup+0x54>
  801085:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80108a:	5d                   	pop    %ebp
  80108b:	c3                   	ret    

0080108c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	83 ec 18             	sub    $0x18,%esp
  801092:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801095:	ba 00 00 00 00       	mov    $0x0,%edx
  80109a:	eb 13                	jmp    8010af <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80109c:	39 08                	cmp    %ecx,(%eax)
  80109e:	75 0c                	jne    8010ac <dev_lookup+0x20>
			*dev = devtab[i];
  8010a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010aa:	eb 38                	jmp    8010e4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8010ac:	83 c2 01             	add    $0x1,%edx
  8010af:	8b 04 95 68 2b 80 00 	mov    0x802b68(,%edx,4),%eax
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	75 e2                	jne    80109c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010ba:	a1 08 40 80 00       	mov    0x804008,%eax
  8010bf:	8b 40 48             	mov    0x48(%eax),%eax
  8010c2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010ca:	c7 04 24 ec 2a 80 00 	movl   $0x802aec,(%esp)
  8010d1:	e8 c0 f0 ff ff       	call   800196 <cprintf>
	*dev = 0;
  8010d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010e4:	c9                   	leave  
  8010e5:	c3                   	ret    

008010e6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	56                   	push   %esi
  8010ea:	53                   	push   %ebx
  8010eb:	83 ec 20             	sub    $0x20,%esp
  8010ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8010f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010f7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010fb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801101:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801104:	89 04 24             	mov    %eax,(%esp)
  801107:	e8 2a ff ff ff       	call   801036 <fd_lookup>
  80110c:	85 c0                	test   %eax,%eax
  80110e:	78 05                	js     801115 <fd_close+0x2f>
	    || fd != fd2)
  801110:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801113:	74 0c                	je     801121 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801115:	84 db                	test   %bl,%bl
  801117:	ba 00 00 00 00       	mov    $0x0,%edx
  80111c:	0f 44 c2             	cmove  %edx,%eax
  80111f:	eb 3f                	jmp    801160 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801121:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801124:	89 44 24 04          	mov    %eax,0x4(%esp)
  801128:	8b 06                	mov    (%esi),%eax
  80112a:	89 04 24             	mov    %eax,(%esp)
  80112d:	e8 5a ff ff ff       	call   80108c <dev_lookup>
  801132:	89 c3                	mov    %eax,%ebx
  801134:	85 c0                	test   %eax,%eax
  801136:	78 16                	js     80114e <fd_close+0x68>
		if (dev->dev_close)
  801138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80113b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80113e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801143:	85 c0                	test   %eax,%eax
  801145:	74 07                	je     80114e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801147:	89 34 24             	mov    %esi,(%esp)
  80114a:	ff d0                	call   *%eax
  80114c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80114e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801152:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801159:	e8 1c fb ff ff       	call   800c7a <sys_page_unmap>
	return r;
  80115e:	89 d8                	mov    %ebx,%eax
}
  801160:	83 c4 20             	add    $0x20,%esp
  801163:	5b                   	pop    %ebx
  801164:	5e                   	pop    %esi
  801165:	5d                   	pop    %ebp
  801166:	c3                   	ret    

00801167 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80116d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801170:	89 44 24 04          	mov    %eax,0x4(%esp)
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	89 04 24             	mov    %eax,(%esp)
  80117a:	e8 b7 fe ff ff       	call   801036 <fd_lookup>
  80117f:	89 c2                	mov    %eax,%edx
  801181:	85 d2                	test   %edx,%edx
  801183:	78 13                	js     801198 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801185:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80118c:	00 
  80118d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801190:	89 04 24             	mov    %eax,(%esp)
  801193:	e8 4e ff ff ff       	call   8010e6 <fd_close>
}
  801198:	c9                   	leave  
  801199:	c3                   	ret    

0080119a <close_all>:

void
close_all(void)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	53                   	push   %ebx
  80119e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011a1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011a6:	89 1c 24             	mov    %ebx,(%esp)
  8011a9:	e8 b9 ff ff ff       	call   801167 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8011ae:	83 c3 01             	add    $0x1,%ebx
  8011b1:	83 fb 20             	cmp    $0x20,%ebx
  8011b4:	75 f0                	jne    8011a6 <close_all+0xc>
		close(i);
}
  8011b6:	83 c4 14             	add    $0x14,%esp
  8011b9:	5b                   	pop    %ebx
  8011ba:	5d                   	pop    %ebp
  8011bb:	c3                   	ret    

008011bc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	57                   	push   %edi
  8011c0:	56                   	push   %esi
  8011c1:	53                   	push   %ebx
  8011c2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011c5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cf:	89 04 24             	mov    %eax,(%esp)
  8011d2:	e8 5f fe ff ff       	call   801036 <fd_lookup>
  8011d7:	89 c2                	mov    %eax,%edx
  8011d9:	85 d2                	test   %edx,%edx
  8011db:	0f 88 e1 00 00 00    	js     8012c2 <dup+0x106>
		return r;
	close(newfdnum);
  8011e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e4:	89 04 24             	mov    %eax,(%esp)
  8011e7:	e8 7b ff ff ff       	call   801167 <close>

	newfd = INDEX2FD(newfdnum);
  8011ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8011ef:	c1 e3 0c             	shl    $0xc,%ebx
  8011f2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8011f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011fb:	89 04 24             	mov    %eax,(%esp)
  8011fe:	e8 cd fd ff ff       	call   800fd0 <fd2data>
  801203:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801205:	89 1c 24             	mov    %ebx,(%esp)
  801208:	e8 c3 fd ff ff       	call   800fd0 <fd2data>
  80120d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80120f:	89 f0                	mov    %esi,%eax
  801211:	c1 e8 16             	shr    $0x16,%eax
  801214:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80121b:	a8 01                	test   $0x1,%al
  80121d:	74 43                	je     801262 <dup+0xa6>
  80121f:	89 f0                	mov    %esi,%eax
  801221:	c1 e8 0c             	shr    $0xc,%eax
  801224:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80122b:	f6 c2 01             	test   $0x1,%dl
  80122e:	74 32                	je     801262 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801230:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801237:	25 07 0e 00 00       	and    $0xe07,%eax
  80123c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801240:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801244:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80124b:	00 
  80124c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801250:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801257:	e8 cb f9 ff ff       	call   800c27 <sys_page_map>
  80125c:	89 c6                	mov    %eax,%esi
  80125e:	85 c0                	test   %eax,%eax
  801260:	78 3e                	js     8012a0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801265:	89 c2                	mov    %eax,%edx
  801267:	c1 ea 0c             	shr    $0xc,%edx
  80126a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801271:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801277:	89 54 24 10          	mov    %edx,0x10(%esp)
  80127b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80127f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801286:	00 
  801287:	89 44 24 04          	mov    %eax,0x4(%esp)
  80128b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801292:	e8 90 f9 ff ff       	call   800c27 <sys_page_map>
  801297:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801299:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80129c:	85 f6                	test   %esi,%esi
  80129e:	79 22                	jns    8012c2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8012a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012ab:	e8 ca f9 ff ff       	call   800c7a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012bb:	e8 ba f9 ff ff       	call   800c7a <sys_page_unmap>
	return r;
  8012c0:	89 f0                	mov    %esi,%eax
}
  8012c2:	83 c4 3c             	add    $0x3c,%esp
  8012c5:	5b                   	pop    %ebx
  8012c6:	5e                   	pop    %esi
  8012c7:	5f                   	pop    %edi
  8012c8:	5d                   	pop    %ebp
  8012c9:	c3                   	ret    

008012ca <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	53                   	push   %ebx
  8012ce:	83 ec 24             	sub    $0x24,%esp
  8012d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012db:	89 1c 24             	mov    %ebx,(%esp)
  8012de:	e8 53 fd ff ff       	call   801036 <fd_lookup>
  8012e3:	89 c2                	mov    %eax,%edx
  8012e5:	85 d2                	test   %edx,%edx
  8012e7:	78 6d                	js     801356 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f3:	8b 00                	mov    (%eax),%eax
  8012f5:	89 04 24             	mov    %eax,(%esp)
  8012f8:	e8 8f fd ff ff       	call   80108c <dev_lookup>
  8012fd:	85 c0                	test   %eax,%eax
  8012ff:	78 55                	js     801356 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801301:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801304:	8b 50 08             	mov    0x8(%eax),%edx
  801307:	83 e2 03             	and    $0x3,%edx
  80130a:	83 fa 01             	cmp    $0x1,%edx
  80130d:	75 23                	jne    801332 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80130f:	a1 08 40 80 00       	mov    0x804008,%eax
  801314:	8b 40 48             	mov    0x48(%eax),%eax
  801317:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80131b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80131f:	c7 04 24 2d 2b 80 00 	movl   $0x802b2d,(%esp)
  801326:	e8 6b ee ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  80132b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801330:	eb 24                	jmp    801356 <read+0x8c>
	}
	if (!dev->dev_read)
  801332:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801335:	8b 52 08             	mov    0x8(%edx),%edx
  801338:	85 d2                	test   %edx,%edx
  80133a:	74 15                	je     801351 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80133c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80133f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801343:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801346:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80134a:	89 04 24             	mov    %eax,(%esp)
  80134d:	ff d2                	call   *%edx
  80134f:	eb 05                	jmp    801356 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801351:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801356:	83 c4 24             	add    $0x24,%esp
  801359:	5b                   	pop    %ebx
  80135a:	5d                   	pop    %ebp
  80135b:	c3                   	ret    

0080135c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	57                   	push   %edi
  801360:	56                   	push   %esi
  801361:	53                   	push   %ebx
  801362:	83 ec 1c             	sub    $0x1c,%esp
  801365:	8b 7d 08             	mov    0x8(%ebp),%edi
  801368:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80136b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801370:	eb 23                	jmp    801395 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801372:	89 f0                	mov    %esi,%eax
  801374:	29 d8                	sub    %ebx,%eax
  801376:	89 44 24 08          	mov    %eax,0x8(%esp)
  80137a:	89 d8                	mov    %ebx,%eax
  80137c:	03 45 0c             	add    0xc(%ebp),%eax
  80137f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801383:	89 3c 24             	mov    %edi,(%esp)
  801386:	e8 3f ff ff ff       	call   8012ca <read>
		if (m < 0)
  80138b:	85 c0                	test   %eax,%eax
  80138d:	78 10                	js     80139f <readn+0x43>
			return m;
		if (m == 0)
  80138f:	85 c0                	test   %eax,%eax
  801391:	74 0a                	je     80139d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801393:	01 c3                	add    %eax,%ebx
  801395:	39 f3                	cmp    %esi,%ebx
  801397:	72 d9                	jb     801372 <readn+0x16>
  801399:	89 d8                	mov    %ebx,%eax
  80139b:	eb 02                	jmp    80139f <readn+0x43>
  80139d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80139f:	83 c4 1c             	add    $0x1c,%esp
  8013a2:	5b                   	pop    %ebx
  8013a3:	5e                   	pop    %esi
  8013a4:	5f                   	pop    %edi
  8013a5:	5d                   	pop    %ebp
  8013a6:	c3                   	ret    

008013a7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	53                   	push   %ebx
  8013ab:	83 ec 24             	sub    $0x24,%esp
  8013ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b8:	89 1c 24             	mov    %ebx,(%esp)
  8013bb:	e8 76 fc ff ff       	call   801036 <fd_lookup>
  8013c0:	89 c2                	mov    %eax,%edx
  8013c2:	85 d2                	test   %edx,%edx
  8013c4:	78 68                	js     80142e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d0:	8b 00                	mov    (%eax),%eax
  8013d2:	89 04 24             	mov    %eax,(%esp)
  8013d5:	e8 b2 fc ff ff       	call   80108c <dev_lookup>
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	78 50                	js     80142e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013e5:	75 23                	jne    80140a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013e7:	a1 08 40 80 00       	mov    0x804008,%eax
  8013ec:	8b 40 48             	mov    0x48(%eax),%eax
  8013ef:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f7:	c7 04 24 49 2b 80 00 	movl   $0x802b49,(%esp)
  8013fe:	e8 93 ed ff ff       	call   800196 <cprintf>
		return -E_INVAL;
  801403:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801408:	eb 24                	jmp    80142e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80140a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140d:	8b 52 0c             	mov    0xc(%edx),%edx
  801410:	85 d2                	test   %edx,%edx
  801412:	74 15                	je     801429 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801414:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801417:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80141b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80141e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801422:	89 04 24             	mov    %eax,(%esp)
  801425:	ff d2                	call   *%edx
  801427:	eb 05                	jmp    80142e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801429:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80142e:	83 c4 24             	add    $0x24,%esp
  801431:	5b                   	pop    %ebx
  801432:	5d                   	pop    %ebp
  801433:	c3                   	ret    

00801434 <seek>:

int
seek(int fdnum, off_t offset)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80143a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80143d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801441:	8b 45 08             	mov    0x8(%ebp),%eax
  801444:	89 04 24             	mov    %eax,(%esp)
  801447:	e8 ea fb ff ff       	call   801036 <fd_lookup>
  80144c:	85 c0                	test   %eax,%eax
  80144e:	78 0e                	js     80145e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801450:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801453:	8b 55 0c             	mov    0xc(%ebp),%edx
  801456:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801459:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	53                   	push   %ebx
  801464:	83 ec 24             	sub    $0x24,%esp
  801467:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80146d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801471:	89 1c 24             	mov    %ebx,(%esp)
  801474:	e8 bd fb ff ff       	call   801036 <fd_lookup>
  801479:	89 c2                	mov    %eax,%edx
  80147b:	85 d2                	test   %edx,%edx
  80147d:	78 61                	js     8014e0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80147f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801482:	89 44 24 04          	mov    %eax,0x4(%esp)
  801486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801489:	8b 00                	mov    (%eax),%eax
  80148b:	89 04 24             	mov    %eax,(%esp)
  80148e:	e8 f9 fb ff ff       	call   80108c <dev_lookup>
  801493:	85 c0                	test   %eax,%eax
  801495:	78 49                	js     8014e0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80149e:	75 23                	jne    8014c3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8014a0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014a5:	8b 40 48             	mov    0x48(%eax),%eax
  8014a8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b0:	c7 04 24 0c 2b 80 00 	movl   $0x802b0c,(%esp)
  8014b7:	e8 da ec ff ff       	call   800196 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8014bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c1:	eb 1d                	jmp    8014e0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8014c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c6:	8b 52 18             	mov    0x18(%edx),%edx
  8014c9:	85 d2                	test   %edx,%edx
  8014cb:	74 0e                	je     8014db <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014d4:	89 04 24             	mov    %eax,(%esp)
  8014d7:	ff d2                	call   *%edx
  8014d9:	eb 05                	jmp    8014e0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8014db:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8014e0:	83 c4 24             	add    $0x24,%esp
  8014e3:	5b                   	pop    %ebx
  8014e4:	5d                   	pop    %ebp
  8014e5:	c3                   	ret    

008014e6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	53                   	push   %ebx
  8014ea:	83 ec 24             	sub    $0x24,%esp
  8014ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	89 04 24             	mov    %eax,(%esp)
  8014fd:	e8 34 fb ff ff       	call   801036 <fd_lookup>
  801502:	89 c2                	mov    %eax,%edx
  801504:	85 d2                	test   %edx,%edx
  801506:	78 52                	js     80155a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801508:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80150f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801512:	8b 00                	mov    (%eax),%eax
  801514:	89 04 24             	mov    %eax,(%esp)
  801517:	e8 70 fb ff ff       	call   80108c <dev_lookup>
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 3a                	js     80155a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801523:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801527:	74 2c                	je     801555 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801529:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80152c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801533:	00 00 00 
	stat->st_isdir = 0;
  801536:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80153d:	00 00 00 
	stat->st_dev = dev;
  801540:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801546:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80154a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80154d:	89 14 24             	mov    %edx,(%esp)
  801550:	ff 50 14             	call   *0x14(%eax)
  801553:	eb 05                	jmp    80155a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801555:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80155a:	83 c4 24             	add    $0x24,%esp
  80155d:	5b                   	pop    %ebx
  80155e:	5d                   	pop    %ebp
  80155f:	c3                   	ret    

00801560 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	56                   	push   %esi
  801564:	53                   	push   %ebx
  801565:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801568:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80156f:	00 
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	89 04 24             	mov    %eax,(%esp)
  801576:	e8 84 02 00 00       	call   8017ff <open>
  80157b:	89 c3                	mov    %eax,%ebx
  80157d:	85 db                	test   %ebx,%ebx
  80157f:	78 1b                	js     80159c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801581:	8b 45 0c             	mov    0xc(%ebp),%eax
  801584:	89 44 24 04          	mov    %eax,0x4(%esp)
  801588:	89 1c 24             	mov    %ebx,(%esp)
  80158b:	e8 56 ff ff ff       	call   8014e6 <fstat>
  801590:	89 c6                	mov    %eax,%esi
	close(fd);
  801592:	89 1c 24             	mov    %ebx,(%esp)
  801595:	e8 cd fb ff ff       	call   801167 <close>
	return r;
  80159a:	89 f0                	mov    %esi,%eax
}
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	5b                   	pop    %ebx
  8015a0:	5e                   	pop    %esi
  8015a1:	5d                   	pop    %ebp
  8015a2:	c3                   	ret    

008015a3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	56                   	push   %esi
  8015a7:	53                   	push   %ebx
  8015a8:	83 ec 10             	sub    $0x10,%esp
  8015ab:	89 c6                	mov    %eax,%esi
  8015ad:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015af:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015b6:	75 11                	jne    8015c9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8015bf:	e8 61 0e 00 00       	call   802425 <ipc_find_env>
  8015c4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015c9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015d0:	00 
  8015d1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8015d8:	00 
  8015d9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015dd:	a1 00 40 80 00       	mov    0x804000,%eax
  8015e2:	89 04 24             	mov    %eax,(%esp)
  8015e5:	e8 ae 0d 00 00       	call   802398 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015f1:	00 
  8015f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015fd:	e8 2e 0d 00 00       	call   802330 <ipc_recv>
}
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	5b                   	pop    %ebx
  801606:	5e                   	pop    %esi
  801607:	5d                   	pop    %ebp
  801608:	c3                   	ret    

00801609 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	8b 40 0c             	mov    0xc(%eax),%eax
  801615:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80161a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801622:	ba 00 00 00 00       	mov    $0x0,%edx
  801627:	b8 02 00 00 00       	mov    $0x2,%eax
  80162c:	e8 72 ff ff ff       	call   8015a3 <fsipc>
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	8b 40 0c             	mov    0xc(%eax),%eax
  80163f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801644:	ba 00 00 00 00       	mov    $0x0,%edx
  801649:	b8 06 00 00 00       	mov    $0x6,%eax
  80164e:	e8 50 ff ff ff       	call   8015a3 <fsipc>
}
  801653:	c9                   	leave  
  801654:	c3                   	ret    

00801655 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801655:	55                   	push   %ebp
  801656:	89 e5                	mov    %esp,%ebp
  801658:	53                   	push   %ebx
  801659:	83 ec 14             	sub    $0x14,%esp
  80165c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80165f:	8b 45 08             	mov    0x8(%ebp),%eax
  801662:	8b 40 0c             	mov    0xc(%eax),%eax
  801665:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80166a:	ba 00 00 00 00       	mov    $0x0,%edx
  80166f:	b8 05 00 00 00       	mov    $0x5,%eax
  801674:	e8 2a ff ff ff       	call   8015a3 <fsipc>
  801679:	89 c2                	mov    %eax,%edx
  80167b:	85 d2                	test   %edx,%edx
  80167d:	78 2b                	js     8016aa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80167f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801686:	00 
  801687:	89 1c 24             	mov    %ebx,(%esp)
  80168a:	e8 28 f1 ff ff       	call   8007b7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80168f:	a1 80 50 80 00       	mov    0x805080,%eax
  801694:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80169a:	a1 84 50 80 00       	mov    0x805084,%eax
  80169f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016aa:	83 c4 14             	add    $0x14,%esp
  8016ad:	5b                   	pop    %ebx
  8016ae:	5d                   	pop    %ebp
  8016af:	c3                   	ret    

008016b0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	53                   	push   %ebx
  8016b4:	83 ec 14             	sub    $0x14,%esp
  8016b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  8016c5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8016cb:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8016d0:	0f 46 c3             	cmovbe %ebx,%eax
  8016d3:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8016d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e3:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8016ea:	e8 65 f2 ff ff       	call   800954 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f4:	b8 04 00 00 00       	mov    $0x4,%eax
  8016f9:	e8 a5 fe ff ff       	call   8015a3 <fsipc>
  8016fe:	85 c0                	test   %eax,%eax
  801700:	78 53                	js     801755 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801702:	39 c3                	cmp    %eax,%ebx
  801704:	73 24                	jae    80172a <devfile_write+0x7a>
  801706:	c7 44 24 0c 7c 2b 80 	movl   $0x802b7c,0xc(%esp)
  80170d:	00 
  80170e:	c7 44 24 08 83 2b 80 	movl   $0x802b83,0x8(%esp)
  801715:	00 
  801716:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  80171d:	00 
  80171e:	c7 04 24 98 2b 80 00 	movl   $0x802b98,(%esp)
  801725:	e8 ac 0b 00 00       	call   8022d6 <_panic>
	assert(r <= PGSIZE);
  80172a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80172f:	7e 24                	jle    801755 <devfile_write+0xa5>
  801731:	c7 44 24 0c a3 2b 80 	movl   $0x802ba3,0xc(%esp)
  801738:	00 
  801739:	c7 44 24 08 83 2b 80 	movl   $0x802b83,0x8(%esp)
  801740:	00 
  801741:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801748:	00 
  801749:	c7 04 24 98 2b 80 00 	movl   $0x802b98,(%esp)
  801750:	e8 81 0b 00 00       	call   8022d6 <_panic>
	return r;
}
  801755:	83 c4 14             	add    $0x14,%esp
  801758:	5b                   	pop    %ebx
  801759:	5d                   	pop    %ebp
  80175a:	c3                   	ret    

0080175b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	56                   	push   %esi
  80175f:	53                   	push   %ebx
  801760:	83 ec 10             	sub    $0x10,%esp
  801763:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801766:	8b 45 08             	mov    0x8(%ebp),%eax
  801769:	8b 40 0c             	mov    0xc(%eax),%eax
  80176c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801771:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801777:	ba 00 00 00 00       	mov    $0x0,%edx
  80177c:	b8 03 00 00 00       	mov    $0x3,%eax
  801781:	e8 1d fe ff ff       	call   8015a3 <fsipc>
  801786:	89 c3                	mov    %eax,%ebx
  801788:	85 c0                	test   %eax,%eax
  80178a:	78 6a                	js     8017f6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  80178c:	39 c6                	cmp    %eax,%esi
  80178e:	73 24                	jae    8017b4 <devfile_read+0x59>
  801790:	c7 44 24 0c 7c 2b 80 	movl   $0x802b7c,0xc(%esp)
  801797:	00 
  801798:	c7 44 24 08 83 2b 80 	movl   $0x802b83,0x8(%esp)
  80179f:	00 
  8017a0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8017a7:	00 
  8017a8:	c7 04 24 98 2b 80 00 	movl   $0x802b98,(%esp)
  8017af:	e8 22 0b 00 00       	call   8022d6 <_panic>
	assert(r <= PGSIZE);
  8017b4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017b9:	7e 24                	jle    8017df <devfile_read+0x84>
  8017bb:	c7 44 24 0c a3 2b 80 	movl   $0x802ba3,0xc(%esp)
  8017c2:	00 
  8017c3:	c7 44 24 08 83 2b 80 	movl   $0x802b83,0x8(%esp)
  8017ca:	00 
  8017cb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8017d2:	00 
  8017d3:	c7 04 24 98 2b 80 00 	movl   $0x802b98,(%esp)
  8017da:	e8 f7 0a 00 00       	call   8022d6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017e3:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017ea:	00 
  8017eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ee:	89 04 24             	mov    %eax,(%esp)
  8017f1:	e8 5e f1 ff ff       	call   800954 <memmove>
	return r;
}
  8017f6:	89 d8                	mov    %ebx,%eax
  8017f8:	83 c4 10             	add    $0x10,%esp
  8017fb:	5b                   	pop    %ebx
  8017fc:	5e                   	pop    %esi
  8017fd:	5d                   	pop    %ebp
  8017fe:	c3                   	ret    

008017ff <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	53                   	push   %ebx
  801803:	83 ec 24             	sub    $0x24,%esp
  801806:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801809:	89 1c 24             	mov    %ebx,(%esp)
  80180c:	e8 6f ef ff ff       	call   800780 <strlen>
  801811:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801816:	7f 60                	jg     801878 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801818:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80181b:	89 04 24             	mov    %eax,(%esp)
  80181e:	e8 c4 f7 ff ff       	call   800fe7 <fd_alloc>
  801823:	89 c2                	mov    %eax,%edx
  801825:	85 d2                	test   %edx,%edx
  801827:	78 54                	js     80187d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801829:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80182d:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801834:	e8 7e ef ff ff       	call   8007b7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183c:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801841:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801844:	b8 01 00 00 00       	mov    $0x1,%eax
  801849:	e8 55 fd ff ff       	call   8015a3 <fsipc>
  80184e:	89 c3                	mov    %eax,%ebx
  801850:	85 c0                	test   %eax,%eax
  801852:	79 17                	jns    80186b <open+0x6c>
		fd_close(fd, 0);
  801854:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80185b:	00 
  80185c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185f:	89 04 24             	mov    %eax,(%esp)
  801862:	e8 7f f8 ff ff       	call   8010e6 <fd_close>
		return r;
  801867:	89 d8                	mov    %ebx,%eax
  801869:	eb 12                	jmp    80187d <open+0x7e>
	}

	return fd2num(fd);
  80186b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186e:	89 04 24             	mov    %eax,(%esp)
  801871:	e8 4a f7 ff ff       	call   800fc0 <fd2num>
  801876:	eb 05                	jmp    80187d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801878:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80187d:	83 c4 24             	add    $0x24,%esp
  801880:	5b                   	pop    %ebx
  801881:	5d                   	pop    %ebp
  801882:	c3                   	ret    

00801883 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801889:	ba 00 00 00 00       	mov    $0x0,%edx
  80188e:	b8 08 00 00 00       	mov    $0x8,%eax
  801893:	e8 0b fd ff ff       	call   8015a3 <fsipc>
}
  801898:	c9                   	leave  
  801899:	c3                   	ret    
  80189a:	66 90                	xchg   %ax,%ax
  80189c:	66 90                	xchg   %ax,%ax
  80189e:	66 90                	xchg   %ax,%ax

008018a0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8018a6:	c7 44 24 04 af 2b 80 	movl   $0x802baf,0x4(%esp)
  8018ad:	00 
  8018ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b1:	89 04 24             	mov    %eax,(%esp)
  8018b4:	e8 fe ee ff ff       	call   8007b7 <strcpy>
	return 0;
}
  8018b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	53                   	push   %ebx
  8018c4:	83 ec 14             	sub    $0x14,%esp
  8018c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018ca:	89 1c 24             	mov    %ebx,(%esp)
  8018cd:	e8 8d 0b 00 00       	call   80245f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8018d2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8018d7:	83 f8 01             	cmp    $0x1,%eax
  8018da:	75 0d                	jne    8018e9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8018dc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8018df:	89 04 24             	mov    %eax,(%esp)
  8018e2:	e8 29 03 00 00       	call   801c10 <nsipc_close>
  8018e7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8018e9:	89 d0                	mov    %edx,%eax
  8018eb:	83 c4 14             	add    $0x14,%esp
  8018ee:	5b                   	pop    %ebx
  8018ef:	5d                   	pop    %ebp
  8018f0:	c3                   	ret    

008018f1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018f7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018fe:	00 
  8018ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801902:	89 44 24 08          	mov    %eax,0x8(%esp)
  801906:	8b 45 0c             	mov    0xc(%ebp),%eax
  801909:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	8b 40 0c             	mov    0xc(%eax),%eax
  801913:	89 04 24             	mov    %eax,(%esp)
  801916:	e8 f0 03 00 00       	call   801d0b <nsipc_send>
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801923:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80192a:	00 
  80192b:	8b 45 10             	mov    0x10(%ebp),%eax
  80192e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801932:	8b 45 0c             	mov    0xc(%ebp),%eax
  801935:	89 44 24 04          	mov    %eax,0x4(%esp)
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	8b 40 0c             	mov    0xc(%eax),%eax
  80193f:	89 04 24             	mov    %eax,(%esp)
  801942:	e8 44 03 00 00       	call   801c8b <nsipc_recv>
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80194f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801952:	89 54 24 04          	mov    %edx,0x4(%esp)
  801956:	89 04 24             	mov    %eax,(%esp)
  801959:	e8 d8 f6 ff ff       	call   801036 <fd_lookup>
  80195e:	85 c0                	test   %eax,%eax
  801960:	78 17                	js     801979 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801965:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80196b:	39 08                	cmp    %ecx,(%eax)
  80196d:	75 05                	jne    801974 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80196f:	8b 40 0c             	mov    0xc(%eax),%eax
  801972:	eb 05                	jmp    801979 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801974:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	56                   	push   %esi
  80197f:	53                   	push   %ebx
  801980:	83 ec 20             	sub    $0x20,%esp
  801983:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801985:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801988:	89 04 24             	mov    %eax,(%esp)
  80198b:	e8 57 f6 ff ff       	call   800fe7 <fd_alloc>
  801990:	89 c3                	mov    %eax,%ebx
  801992:	85 c0                	test   %eax,%eax
  801994:	78 21                	js     8019b7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801996:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80199d:	00 
  80199e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019ac:	e8 22 f2 ff ff       	call   800bd3 <sys_page_alloc>
  8019b1:	89 c3                	mov    %eax,%ebx
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	79 0c                	jns    8019c3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8019b7:	89 34 24             	mov    %esi,(%esp)
  8019ba:	e8 51 02 00 00       	call   801c10 <nsipc_close>
		return r;
  8019bf:	89 d8                	mov    %ebx,%eax
  8019c1:	eb 20                	jmp    8019e3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8019c3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019cc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019d1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8019d8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8019db:	89 14 24             	mov    %edx,(%esp)
  8019de:	e8 dd f5 ff ff       	call   800fc0 <fd2num>
}
  8019e3:	83 c4 20             	add    $0x20,%esp
  8019e6:	5b                   	pop    %ebx
  8019e7:	5e                   	pop    %esi
  8019e8:	5d                   	pop    %ebp
  8019e9:	c3                   	ret    

008019ea <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f3:	e8 51 ff ff ff       	call   801949 <fd2sockid>
		return r;
  8019f8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	78 23                	js     801a21 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019fe:	8b 55 10             	mov    0x10(%ebp),%edx
  801a01:	89 54 24 08          	mov    %edx,0x8(%esp)
  801a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a08:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a0c:	89 04 24             	mov    %eax,(%esp)
  801a0f:	e8 45 01 00 00       	call   801b59 <nsipc_accept>
		return r;
  801a14:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a16:	85 c0                	test   %eax,%eax
  801a18:	78 07                	js     801a21 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801a1a:	e8 5c ff ff ff       	call   80197b <alloc_sockfd>
  801a1f:	89 c1                	mov    %eax,%ecx
}
  801a21:	89 c8                	mov    %ecx,%eax
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	e8 16 ff ff ff       	call   801949 <fd2sockid>
  801a33:	89 c2                	mov    %eax,%edx
  801a35:	85 d2                	test   %edx,%edx
  801a37:	78 16                	js     801a4f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801a39:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a47:	89 14 24             	mov    %edx,(%esp)
  801a4a:	e8 60 01 00 00       	call   801baf <nsipc_bind>
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <shutdown>:

int
shutdown(int s, int how)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	e8 ea fe ff ff       	call   801949 <fd2sockid>
  801a5f:	89 c2                	mov    %eax,%edx
  801a61:	85 d2                	test   %edx,%edx
  801a63:	78 0f                	js     801a74 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801a65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6c:	89 14 24             	mov    %edx,(%esp)
  801a6f:	e8 7a 01 00 00       	call   801bee <nsipc_shutdown>
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	e8 c5 fe ff ff       	call   801949 <fd2sockid>
  801a84:	89 c2                	mov    %eax,%edx
  801a86:	85 d2                	test   %edx,%edx
  801a88:	78 16                	js     801aa0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801a8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a98:	89 14 24             	mov    %edx,(%esp)
  801a9b:	e8 8a 01 00 00       	call   801c2a <nsipc_connect>
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <listen>:

int
listen(int s, int backlog)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	e8 99 fe ff ff       	call   801949 <fd2sockid>
  801ab0:	89 c2                	mov    %eax,%edx
  801ab2:	85 d2                	test   %edx,%edx
  801ab4:	78 0f                	js     801ac5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801abd:	89 14 24             	mov    %edx,(%esp)
  801ac0:	e8 a4 01 00 00       	call   801c69 <nsipc_listen>
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801acd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	89 04 24             	mov    %eax,(%esp)
  801ae1:	e8 98 02 00 00       	call   801d7e <nsipc_socket>
  801ae6:	89 c2                	mov    %eax,%edx
  801ae8:	85 d2                	test   %edx,%edx
  801aea:	78 05                	js     801af1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801aec:	e8 8a fe ff ff       	call   80197b <alloc_sockfd>
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	53                   	push   %ebx
  801af7:	83 ec 14             	sub    $0x14,%esp
  801afa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801afc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b03:	75 11                	jne    801b16 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b05:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801b0c:	e8 14 09 00 00       	call   802425 <ipc_find_env>
  801b11:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b16:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b1d:	00 
  801b1e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b25:	00 
  801b26:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b2a:	a1 04 40 80 00       	mov    0x804004,%eax
  801b2f:	89 04 24             	mov    %eax,(%esp)
  801b32:	e8 61 08 00 00       	call   802398 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b37:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b3e:	00 
  801b3f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b46:	00 
  801b47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b4e:	e8 dd 07 00 00       	call   802330 <ipc_recv>
}
  801b53:	83 c4 14             	add    $0x14,%esp
  801b56:	5b                   	pop    %ebx
  801b57:	5d                   	pop    %ebp
  801b58:	c3                   	ret    

00801b59 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	56                   	push   %esi
  801b5d:	53                   	push   %ebx
  801b5e:	83 ec 10             	sub    $0x10,%esp
  801b61:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b6c:	8b 06                	mov    (%esi),%eax
  801b6e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b73:	b8 01 00 00 00       	mov    $0x1,%eax
  801b78:	e8 76 ff ff ff       	call   801af3 <nsipc>
  801b7d:	89 c3                	mov    %eax,%ebx
  801b7f:	85 c0                	test   %eax,%eax
  801b81:	78 23                	js     801ba6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b83:	a1 10 60 80 00       	mov    0x806010,%eax
  801b88:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b8c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b93:	00 
  801b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b97:	89 04 24             	mov    %eax,(%esp)
  801b9a:	e8 b5 ed ff ff       	call   800954 <memmove>
		*addrlen = ret->ret_addrlen;
  801b9f:	a1 10 60 80 00       	mov    0x806010,%eax
  801ba4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801ba6:	89 d8                	mov    %ebx,%eax
  801ba8:	83 c4 10             	add    $0x10,%esp
  801bab:	5b                   	pop    %ebx
  801bac:	5e                   	pop    %esi
  801bad:	5d                   	pop    %ebp
  801bae:	c3                   	ret    

00801baf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	53                   	push   %ebx
  801bb3:	83 ec 14             	sub    $0x14,%esp
  801bb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bc1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bcc:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801bd3:	e8 7c ed ff ff       	call   800954 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801bd8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801bde:	b8 02 00 00 00       	mov    $0x2,%eax
  801be3:	e8 0b ff ff ff       	call   801af3 <nsipc>
}
  801be8:	83 c4 14             	add    $0x14,%esp
  801beb:	5b                   	pop    %ebx
  801bec:	5d                   	pop    %ebp
  801bed:	c3                   	ret    

00801bee <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bff:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801c04:	b8 03 00 00 00       	mov    $0x3,%eax
  801c09:	e8 e5 fe ff ff       	call   801af3 <nsipc>
}
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    

00801c10 <nsipc_close>:

int
nsipc_close(int s)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c1e:	b8 04 00 00 00       	mov    $0x4,%eax
  801c23:	e8 cb fe ff ff       	call   801af3 <nsipc>
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	53                   	push   %ebx
  801c2e:	83 ec 14             	sub    $0x14,%esp
  801c31:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c3c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c47:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c4e:	e8 01 ed ff ff       	call   800954 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c53:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c59:	b8 05 00 00 00       	mov    $0x5,%eax
  801c5e:	e8 90 fe ff ff       	call   801af3 <nsipc>
}
  801c63:	83 c4 14             	add    $0x14,%esp
  801c66:	5b                   	pop    %ebx
  801c67:	5d                   	pop    %ebp
  801c68:	c3                   	ret    

00801c69 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c7f:	b8 06 00 00 00       	mov    $0x6,%eax
  801c84:	e8 6a fe ff ff       	call   801af3 <nsipc>
}
  801c89:	c9                   	leave  
  801c8a:	c3                   	ret    

00801c8b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c8b:	55                   	push   %ebp
  801c8c:	89 e5                	mov    %esp,%ebp
  801c8e:	56                   	push   %esi
  801c8f:	53                   	push   %ebx
  801c90:	83 ec 10             	sub    $0x10,%esp
  801c93:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c9e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ca4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801cac:	b8 07 00 00 00       	mov    $0x7,%eax
  801cb1:	e8 3d fe ff ff       	call   801af3 <nsipc>
  801cb6:	89 c3                	mov    %eax,%ebx
  801cb8:	85 c0                	test   %eax,%eax
  801cba:	78 46                	js     801d02 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801cbc:	39 f0                	cmp    %esi,%eax
  801cbe:	7f 07                	jg     801cc7 <nsipc_recv+0x3c>
  801cc0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801cc5:	7e 24                	jle    801ceb <nsipc_recv+0x60>
  801cc7:	c7 44 24 0c bb 2b 80 	movl   $0x802bbb,0xc(%esp)
  801cce:	00 
  801ccf:	c7 44 24 08 83 2b 80 	movl   $0x802b83,0x8(%esp)
  801cd6:	00 
  801cd7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801cde:	00 
  801cdf:	c7 04 24 d0 2b 80 00 	movl   $0x802bd0,(%esp)
  801ce6:	e8 eb 05 00 00       	call   8022d6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ceb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cef:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cf6:	00 
  801cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfa:	89 04 24             	mov    %eax,(%esp)
  801cfd:	e8 52 ec ff ff       	call   800954 <memmove>
	}

	return r;
}
  801d02:	89 d8                	mov    %ebx,%eax
  801d04:	83 c4 10             	add    $0x10,%esp
  801d07:	5b                   	pop    %ebx
  801d08:	5e                   	pop    %esi
  801d09:	5d                   	pop    %ebp
  801d0a:	c3                   	ret    

00801d0b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	53                   	push   %ebx
  801d0f:	83 ec 14             	sub    $0x14,%esp
  801d12:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801d1d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d23:	7e 24                	jle    801d49 <nsipc_send+0x3e>
  801d25:	c7 44 24 0c dc 2b 80 	movl   $0x802bdc,0xc(%esp)
  801d2c:	00 
  801d2d:	c7 44 24 08 83 2b 80 	movl   $0x802b83,0x8(%esp)
  801d34:	00 
  801d35:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801d3c:	00 
  801d3d:	c7 04 24 d0 2b 80 00 	movl   $0x802bd0,(%esp)
  801d44:	e8 8d 05 00 00       	call   8022d6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d49:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d54:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801d5b:	e8 f4 eb ff ff       	call   800954 <memmove>
	nsipcbuf.send.req_size = size;
  801d60:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d66:	8b 45 14             	mov    0x14(%ebp),%eax
  801d69:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d6e:	b8 08 00 00 00       	mov    $0x8,%eax
  801d73:	e8 7b fd ff ff       	call   801af3 <nsipc>
}
  801d78:	83 c4 14             	add    $0x14,%esp
  801d7b:	5b                   	pop    %ebx
  801d7c:	5d                   	pop    %ebp
  801d7d:	c3                   	ret    

00801d7e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d94:	8b 45 10             	mov    0x10(%ebp),%eax
  801d97:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d9c:	b8 09 00 00 00       	mov    $0x9,%eax
  801da1:	e8 4d fd ff ff       	call   801af3 <nsipc>
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	56                   	push   %esi
  801dac:	53                   	push   %ebx
  801dad:	83 ec 10             	sub    $0x10,%esp
  801db0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801db3:	8b 45 08             	mov    0x8(%ebp),%eax
  801db6:	89 04 24             	mov    %eax,(%esp)
  801db9:	e8 12 f2 ff ff       	call   800fd0 <fd2data>
  801dbe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dc0:	c7 44 24 04 e8 2b 80 	movl   $0x802be8,0x4(%esp)
  801dc7:	00 
  801dc8:	89 1c 24             	mov    %ebx,(%esp)
  801dcb:	e8 e7 e9 ff ff       	call   8007b7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dd0:	8b 46 04             	mov    0x4(%esi),%eax
  801dd3:	2b 06                	sub    (%esi),%eax
  801dd5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ddb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801de2:	00 00 00 
	stat->st_dev = &devpipe;
  801de5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801dec:	30 80 00 
	return 0;
}
  801def:	b8 00 00 00 00       	mov    $0x0,%eax
  801df4:	83 c4 10             	add    $0x10,%esp
  801df7:	5b                   	pop    %ebx
  801df8:	5e                   	pop    %esi
  801df9:	5d                   	pop    %ebp
  801dfa:	c3                   	ret    

00801dfb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	53                   	push   %ebx
  801dff:	83 ec 14             	sub    $0x14,%esp
  801e02:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e05:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e10:	e8 65 ee ff ff       	call   800c7a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e15:	89 1c 24             	mov    %ebx,(%esp)
  801e18:	e8 b3 f1 ff ff       	call   800fd0 <fd2data>
  801e1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e28:	e8 4d ee ff ff       	call   800c7a <sys_page_unmap>
}
  801e2d:	83 c4 14             	add    $0x14,%esp
  801e30:	5b                   	pop    %ebx
  801e31:	5d                   	pop    %ebp
  801e32:	c3                   	ret    

00801e33 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	57                   	push   %edi
  801e37:	56                   	push   %esi
  801e38:	53                   	push   %ebx
  801e39:	83 ec 2c             	sub    $0x2c,%esp
  801e3c:	89 c6                	mov    %eax,%esi
  801e3e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e41:	a1 08 40 80 00       	mov    0x804008,%eax
  801e46:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e49:	89 34 24             	mov    %esi,(%esp)
  801e4c:	e8 0e 06 00 00       	call   80245f <pageref>
  801e51:	89 c7                	mov    %eax,%edi
  801e53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e56:	89 04 24             	mov    %eax,(%esp)
  801e59:	e8 01 06 00 00       	call   80245f <pageref>
  801e5e:	39 c7                	cmp    %eax,%edi
  801e60:	0f 94 c2             	sete   %dl
  801e63:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801e66:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801e6c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801e6f:	39 fb                	cmp    %edi,%ebx
  801e71:	74 21                	je     801e94 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801e73:	84 d2                	test   %dl,%dl
  801e75:	74 ca                	je     801e41 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e77:	8b 51 58             	mov    0x58(%ecx),%edx
  801e7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e7e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e82:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e86:	c7 04 24 ef 2b 80 00 	movl   $0x802bef,(%esp)
  801e8d:	e8 04 e3 ff ff       	call   800196 <cprintf>
  801e92:	eb ad                	jmp    801e41 <_pipeisclosed+0xe>
	}
}
  801e94:	83 c4 2c             	add    $0x2c,%esp
  801e97:	5b                   	pop    %ebx
  801e98:	5e                   	pop    %esi
  801e99:	5f                   	pop    %edi
  801e9a:	5d                   	pop    %ebp
  801e9b:	c3                   	ret    

00801e9c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	57                   	push   %edi
  801ea0:	56                   	push   %esi
  801ea1:	53                   	push   %ebx
  801ea2:	83 ec 1c             	sub    $0x1c,%esp
  801ea5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801ea8:	89 34 24             	mov    %esi,(%esp)
  801eab:	e8 20 f1 ff ff       	call   800fd0 <fd2data>
  801eb0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801eb2:	bf 00 00 00 00       	mov    $0x0,%edi
  801eb7:	eb 45                	jmp    801efe <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801eb9:	89 da                	mov    %ebx,%edx
  801ebb:	89 f0                	mov    %esi,%eax
  801ebd:	e8 71 ff ff ff       	call   801e33 <_pipeisclosed>
  801ec2:	85 c0                	test   %eax,%eax
  801ec4:	75 41                	jne    801f07 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801ec6:	e8 e9 ec ff ff       	call   800bb4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ecb:	8b 43 04             	mov    0x4(%ebx),%eax
  801ece:	8b 0b                	mov    (%ebx),%ecx
  801ed0:	8d 51 20             	lea    0x20(%ecx),%edx
  801ed3:	39 d0                	cmp    %edx,%eax
  801ed5:	73 e2                	jae    801eb9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ed7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eda:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ede:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ee1:	99                   	cltd   
  801ee2:	c1 ea 1b             	shr    $0x1b,%edx
  801ee5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801ee8:	83 e1 1f             	and    $0x1f,%ecx
  801eeb:	29 d1                	sub    %edx,%ecx
  801eed:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801ef1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801ef5:	83 c0 01             	add    $0x1,%eax
  801ef8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801efb:	83 c7 01             	add    $0x1,%edi
  801efe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801f01:	75 c8                	jne    801ecb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801f03:	89 f8                	mov    %edi,%eax
  801f05:	eb 05                	jmp    801f0c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f07:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801f0c:	83 c4 1c             	add    $0x1c,%esp
  801f0f:	5b                   	pop    %ebx
  801f10:	5e                   	pop    %esi
  801f11:	5f                   	pop    %edi
  801f12:	5d                   	pop    %ebp
  801f13:	c3                   	ret    

00801f14 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	57                   	push   %edi
  801f18:	56                   	push   %esi
  801f19:	53                   	push   %ebx
  801f1a:	83 ec 1c             	sub    $0x1c,%esp
  801f1d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f20:	89 3c 24             	mov    %edi,(%esp)
  801f23:	e8 a8 f0 ff ff       	call   800fd0 <fd2data>
  801f28:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f2a:	be 00 00 00 00       	mov    $0x0,%esi
  801f2f:	eb 3d                	jmp    801f6e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f31:	85 f6                	test   %esi,%esi
  801f33:	74 04                	je     801f39 <devpipe_read+0x25>
				return i;
  801f35:	89 f0                	mov    %esi,%eax
  801f37:	eb 43                	jmp    801f7c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f39:	89 da                	mov    %ebx,%edx
  801f3b:	89 f8                	mov    %edi,%eax
  801f3d:	e8 f1 fe ff ff       	call   801e33 <_pipeisclosed>
  801f42:	85 c0                	test   %eax,%eax
  801f44:	75 31                	jne    801f77 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f46:	e8 69 ec ff ff       	call   800bb4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f4b:	8b 03                	mov    (%ebx),%eax
  801f4d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f50:	74 df                	je     801f31 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f52:	99                   	cltd   
  801f53:	c1 ea 1b             	shr    $0x1b,%edx
  801f56:	01 d0                	add    %edx,%eax
  801f58:	83 e0 1f             	and    $0x1f,%eax
  801f5b:	29 d0                	sub    %edx,%eax
  801f5d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f65:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f68:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f6b:	83 c6 01             	add    $0x1,%esi
  801f6e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f71:	75 d8                	jne    801f4b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f73:	89 f0                	mov    %esi,%eax
  801f75:	eb 05                	jmp    801f7c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f77:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f7c:	83 c4 1c             	add    $0x1c,%esp
  801f7f:	5b                   	pop    %ebx
  801f80:	5e                   	pop    %esi
  801f81:	5f                   	pop    %edi
  801f82:	5d                   	pop    %ebp
  801f83:	c3                   	ret    

00801f84 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	56                   	push   %esi
  801f88:	53                   	push   %ebx
  801f89:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f8f:	89 04 24             	mov    %eax,(%esp)
  801f92:	e8 50 f0 ff ff       	call   800fe7 <fd_alloc>
  801f97:	89 c2                	mov    %eax,%edx
  801f99:	85 d2                	test   %edx,%edx
  801f9b:	0f 88 4d 01 00 00    	js     8020ee <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fa1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fa8:	00 
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fb0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fb7:	e8 17 ec ff ff       	call   800bd3 <sys_page_alloc>
  801fbc:	89 c2                	mov    %eax,%edx
  801fbe:	85 d2                	test   %edx,%edx
  801fc0:	0f 88 28 01 00 00    	js     8020ee <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801fc6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fc9:	89 04 24             	mov    %eax,(%esp)
  801fcc:	e8 16 f0 ff ff       	call   800fe7 <fd_alloc>
  801fd1:	89 c3                	mov    %eax,%ebx
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	0f 88 fe 00 00 00    	js     8020d9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fdb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fe2:	00 
  801fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ff1:	e8 dd eb ff ff       	call   800bd3 <sys_page_alloc>
  801ff6:	89 c3                	mov    %eax,%ebx
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	0f 88 d9 00 00 00    	js     8020d9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802003:	89 04 24             	mov    %eax,(%esp)
  802006:	e8 c5 ef ff ff       	call   800fd0 <fd2data>
  80200b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80200d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802014:	00 
  802015:	89 44 24 04          	mov    %eax,0x4(%esp)
  802019:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802020:	e8 ae eb ff ff       	call   800bd3 <sys_page_alloc>
  802025:	89 c3                	mov    %eax,%ebx
  802027:	85 c0                	test   %eax,%eax
  802029:	0f 88 97 00 00 00    	js     8020c6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80202f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802032:	89 04 24             	mov    %eax,(%esp)
  802035:	e8 96 ef ff ff       	call   800fd0 <fd2data>
  80203a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802041:	00 
  802042:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802046:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80204d:	00 
  80204e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802052:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802059:	e8 c9 eb ff ff       	call   800c27 <sys_page_map>
  80205e:	89 c3                	mov    %eax,%ebx
  802060:	85 c0                	test   %eax,%eax
  802062:	78 52                	js     8020b6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802064:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80206f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802072:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802079:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80207f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802082:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802087:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80208e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802091:	89 04 24             	mov    %eax,(%esp)
  802094:	e8 27 ef ff ff       	call   800fc0 <fd2num>
  802099:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80209c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80209e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a1:	89 04 24             	mov    %eax,(%esp)
  8020a4:	e8 17 ef ff ff       	call   800fc0 <fd2num>
  8020a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020ac:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020af:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b4:	eb 38                	jmp    8020ee <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8020b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020c1:	e8 b4 eb ff ff       	call   800c7a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8020c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d4:	e8 a1 eb ff ff       	call   800c7a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020e7:	e8 8e eb ff ff       	call   800c7a <sys_page_unmap>
  8020ec:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8020ee:	83 c4 30             	add    $0x30,%esp
  8020f1:	5b                   	pop    %ebx
  8020f2:	5e                   	pop    %esi
  8020f3:	5d                   	pop    %ebp
  8020f4:	c3                   	ret    

008020f5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802102:	8b 45 08             	mov    0x8(%ebp),%eax
  802105:	89 04 24             	mov    %eax,(%esp)
  802108:	e8 29 ef ff ff       	call   801036 <fd_lookup>
  80210d:	89 c2                	mov    %eax,%edx
  80210f:	85 d2                	test   %edx,%edx
  802111:	78 15                	js     802128 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802116:	89 04 24             	mov    %eax,(%esp)
  802119:	e8 b2 ee ff ff       	call   800fd0 <fd2data>
	return _pipeisclosed(fd, p);
  80211e:	89 c2                	mov    %eax,%edx
  802120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802123:	e8 0b fd ff ff       	call   801e33 <_pipeisclosed>
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    
  80212a:	66 90                	xchg   %ax,%ax
  80212c:	66 90                	xchg   %ax,%ax
  80212e:	66 90                	xchg   %ax,%ax

00802130 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
  802138:	5d                   	pop    %ebp
  802139:	c3                   	ret    

0080213a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802140:	c7 44 24 04 07 2c 80 	movl   $0x802c07,0x4(%esp)
  802147:	00 
  802148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214b:	89 04 24             	mov    %eax,(%esp)
  80214e:	e8 64 e6 ff ff       	call   8007b7 <strcpy>
	return 0;
}
  802153:	b8 00 00 00 00       	mov    $0x0,%eax
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
  80215d:	57                   	push   %edi
  80215e:	56                   	push   %esi
  80215f:	53                   	push   %ebx
  802160:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802166:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80216b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802171:	eb 31                	jmp    8021a4 <devcons_write+0x4a>
		m = n - tot;
  802173:	8b 75 10             	mov    0x10(%ebp),%esi
  802176:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802178:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80217b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802180:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802183:	89 74 24 08          	mov    %esi,0x8(%esp)
  802187:	03 45 0c             	add    0xc(%ebp),%eax
  80218a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80218e:	89 3c 24             	mov    %edi,(%esp)
  802191:	e8 be e7 ff ff       	call   800954 <memmove>
		sys_cputs(buf, m);
  802196:	89 74 24 04          	mov    %esi,0x4(%esp)
  80219a:	89 3c 24             	mov    %edi,(%esp)
  80219d:	e8 64 e9 ff ff       	call   800b06 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021a2:	01 f3                	add    %esi,%ebx
  8021a4:	89 d8                	mov    %ebx,%eax
  8021a6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8021a9:	72 c8                	jb     802173 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8021ab:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8021b1:	5b                   	pop    %ebx
  8021b2:	5e                   	pop    %esi
  8021b3:	5f                   	pop    %edi
  8021b4:	5d                   	pop    %ebp
  8021b5:	c3                   	ret    

008021b6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8021bc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8021c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021c5:	75 07                	jne    8021ce <devcons_read+0x18>
  8021c7:	eb 2a                	jmp    8021f3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8021c9:	e8 e6 e9 ff ff       	call   800bb4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8021ce:	66 90                	xchg   %ax,%ax
  8021d0:	e8 4f e9 ff ff       	call   800b24 <sys_cgetc>
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	74 f0                	je     8021c9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	78 16                	js     8021f3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8021dd:	83 f8 04             	cmp    $0x4,%eax
  8021e0:	74 0c                	je     8021ee <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8021e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e5:	88 02                	mov    %al,(%edx)
	return 1;
  8021e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ec:	eb 05                	jmp    8021f3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8021ee:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802201:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802208:	00 
  802209:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80220c:	89 04 24             	mov    %eax,(%esp)
  80220f:	e8 f2 e8 ff ff       	call   800b06 <sys_cputs>
}
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <getchar>:

int
getchar(void)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80221c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802223:	00 
  802224:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802227:	89 44 24 04          	mov    %eax,0x4(%esp)
  80222b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802232:	e8 93 f0 ff ff       	call   8012ca <read>
	if (r < 0)
  802237:	85 c0                	test   %eax,%eax
  802239:	78 0f                	js     80224a <getchar+0x34>
		return r;
	if (r < 1)
  80223b:	85 c0                	test   %eax,%eax
  80223d:	7e 06                	jle    802245 <getchar+0x2f>
		return -E_EOF;
	return c;
  80223f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802243:	eb 05                	jmp    80224a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802245:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802252:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802255:	89 44 24 04          	mov    %eax,0x4(%esp)
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	89 04 24             	mov    %eax,(%esp)
  80225f:	e8 d2 ed ff ff       	call   801036 <fd_lookup>
  802264:	85 c0                	test   %eax,%eax
  802266:	78 11                	js     802279 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802271:	39 10                	cmp    %edx,(%eax)
  802273:	0f 94 c0             	sete   %al
  802276:	0f b6 c0             	movzbl %al,%eax
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <opencons>:

int
opencons(void)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802281:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802284:	89 04 24             	mov    %eax,(%esp)
  802287:	e8 5b ed ff ff       	call   800fe7 <fd_alloc>
		return r;
  80228c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80228e:	85 c0                	test   %eax,%eax
  802290:	78 40                	js     8022d2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802292:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802299:	00 
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022a8:	e8 26 e9 ff ff       	call   800bd3 <sys_page_alloc>
		return r;
  8022ad:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	78 1f                	js     8022d2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8022b3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8022b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022c8:	89 04 24             	mov    %eax,(%esp)
  8022cb:	e8 f0 ec ff ff       	call   800fc0 <fd2num>
  8022d0:	89 c2                	mov    %eax,%edx
}
  8022d2:	89 d0                	mov    %edx,%eax
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	56                   	push   %esi
  8022da:	53                   	push   %ebx
  8022db:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8022de:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8022e1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8022e7:	e8 a9 e8 ff ff       	call   800b95 <sys_getenvid>
  8022ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ef:	89 54 24 10          	mov    %edx,0x10(%esp)
  8022f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022fa:	89 74 24 08          	mov    %esi,0x8(%esp)
  8022fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802302:	c7 04 24 14 2c 80 00 	movl   $0x802c14,(%esp)
  802309:	e8 88 de ff ff       	call   800196 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80230e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802312:	8b 45 10             	mov    0x10(%ebp),%eax
  802315:	89 04 24             	mov    %eax,(%esp)
  802318:	e8 18 de ff ff       	call   800135 <vcprintf>
	cprintf("\n");
  80231d:	c7 04 24 00 2c 80 00 	movl   $0x802c00,(%esp)
  802324:	e8 6d de ff ff       	call   800196 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802329:	cc                   	int3   
  80232a:	eb fd                	jmp    802329 <_panic+0x53>
  80232c:	66 90                	xchg   %ax,%ax
  80232e:	66 90                	xchg   %ax,%ax

00802330 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
  802333:	56                   	push   %esi
  802334:	53                   	push   %ebx
  802335:	83 ec 10             	sub    $0x10,%esp
  802338:	8b 75 08             	mov    0x8(%ebp),%esi
  80233b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802341:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802343:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802348:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80234b:	89 04 24             	mov    %eax,(%esp)
  80234e:	e8 96 ea ff ff       	call   800de9 <sys_ipc_recv>
  802353:	85 c0                	test   %eax,%eax
  802355:	74 16                	je     80236d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802357:	85 f6                	test   %esi,%esi
  802359:	74 06                	je     802361 <ipc_recv+0x31>
			*from_env_store = 0;
  80235b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802361:	85 db                	test   %ebx,%ebx
  802363:	74 2c                	je     802391 <ipc_recv+0x61>
			*perm_store = 0;
  802365:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80236b:	eb 24                	jmp    802391 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80236d:	85 f6                	test   %esi,%esi
  80236f:	74 0a                	je     80237b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802371:	a1 08 40 80 00       	mov    0x804008,%eax
  802376:	8b 40 74             	mov    0x74(%eax),%eax
  802379:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80237b:	85 db                	test   %ebx,%ebx
  80237d:	74 0a                	je     802389 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80237f:	a1 08 40 80 00       	mov    0x804008,%eax
  802384:	8b 40 78             	mov    0x78(%eax),%eax
  802387:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802389:	a1 08 40 80 00       	mov    0x804008,%eax
  80238e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802391:	83 c4 10             	add    $0x10,%esp
  802394:	5b                   	pop    %ebx
  802395:	5e                   	pop    %esi
  802396:	5d                   	pop    %ebp
  802397:	c3                   	ret    

00802398 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802398:	55                   	push   %ebp
  802399:	89 e5                	mov    %esp,%ebp
  80239b:	57                   	push   %edi
  80239c:	56                   	push   %esi
  80239d:	53                   	push   %ebx
  80239e:	83 ec 1c             	sub    $0x1c,%esp
  8023a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023a7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8023aa:	85 db                	test   %ebx,%ebx
  8023ac:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8023b1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8023b4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	89 04 24             	mov    %eax,(%esp)
  8023c6:	e8 fb e9 ff ff       	call   800dc6 <sys_ipc_try_send>
	if (r == 0) return;
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	75 22                	jne    8023f1 <ipc_send+0x59>
  8023cf:	eb 4c                	jmp    80241d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  8023d1:	84 d2                	test   %dl,%dl
  8023d3:	75 48                	jne    80241d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  8023d5:	e8 da e7 ff ff       	call   800bb4 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  8023da:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8023de:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	89 04 24             	mov    %eax,(%esp)
  8023ec:	e8 d5 e9 ff ff       	call   800dc6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  8023f1:	85 c0                	test   %eax,%eax
  8023f3:	0f 94 c2             	sete   %dl
  8023f6:	74 d9                	je     8023d1 <ipc_send+0x39>
  8023f8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8023fb:	74 d4                	je     8023d1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  8023fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802401:	c7 44 24 08 38 2c 80 	movl   $0x802c38,0x8(%esp)
  802408:	00 
  802409:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802410:	00 
  802411:	c7 04 24 46 2c 80 00 	movl   $0x802c46,(%esp)
  802418:	e8 b9 fe ff ff       	call   8022d6 <_panic>
}
  80241d:	83 c4 1c             	add    $0x1c,%esp
  802420:	5b                   	pop    %ebx
  802421:	5e                   	pop    %esi
  802422:	5f                   	pop    %edi
  802423:	5d                   	pop    %ebp
  802424:	c3                   	ret    

00802425 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802425:	55                   	push   %ebp
  802426:	89 e5                	mov    %esp,%ebp
  802428:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80242b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802430:	89 c2                	mov    %eax,%edx
  802432:	c1 e2 07             	shl    $0x7,%edx
  802435:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80243b:	8b 52 50             	mov    0x50(%edx),%edx
  80243e:	39 ca                	cmp    %ecx,%edx
  802440:	75 0d                	jne    80244f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802442:	c1 e0 07             	shl    $0x7,%eax
  802445:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80244a:	8b 40 40             	mov    0x40(%eax),%eax
  80244d:	eb 0e                	jmp    80245d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80244f:	83 c0 01             	add    $0x1,%eax
  802452:	3d 00 04 00 00       	cmp    $0x400,%eax
  802457:	75 d7                	jne    802430 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802459:	66 b8 00 00          	mov    $0x0,%ax
}
  80245d:	5d                   	pop    %ebp
  80245e:	c3                   	ret    

0080245f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80245f:	55                   	push   %ebp
  802460:	89 e5                	mov    %esp,%ebp
  802462:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802465:	89 d0                	mov    %edx,%eax
  802467:	c1 e8 16             	shr    $0x16,%eax
  80246a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802476:	f6 c1 01             	test   $0x1,%cl
  802479:	74 1d                	je     802498 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80247b:	c1 ea 0c             	shr    $0xc,%edx
  80247e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802485:	f6 c2 01             	test   $0x1,%dl
  802488:	74 0e                	je     802498 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80248a:	c1 ea 0c             	shr    $0xc,%edx
  80248d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802494:	ef 
  802495:	0f b7 c0             	movzwl %ax,%eax
}
  802498:	5d                   	pop    %ebp
  802499:	c3                   	ret    
  80249a:	66 90                	xchg   %ax,%ax
  80249c:	66 90                	xchg   %ax,%ax
  80249e:	66 90                	xchg   %ax,%ax

008024a0 <__udivdi3>:
  8024a0:	55                   	push   %ebp
  8024a1:	57                   	push   %edi
  8024a2:	56                   	push   %esi
  8024a3:	83 ec 0c             	sub    $0xc,%esp
  8024a6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8024aa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8024ae:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8024b2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8024bc:	89 ea                	mov    %ebp,%edx
  8024be:	89 0c 24             	mov    %ecx,(%esp)
  8024c1:	75 2d                	jne    8024f0 <__udivdi3+0x50>
  8024c3:	39 e9                	cmp    %ebp,%ecx
  8024c5:	77 61                	ja     802528 <__udivdi3+0x88>
  8024c7:	85 c9                	test   %ecx,%ecx
  8024c9:	89 ce                	mov    %ecx,%esi
  8024cb:	75 0b                	jne    8024d8 <__udivdi3+0x38>
  8024cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d2:	31 d2                	xor    %edx,%edx
  8024d4:	f7 f1                	div    %ecx
  8024d6:	89 c6                	mov    %eax,%esi
  8024d8:	31 d2                	xor    %edx,%edx
  8024da:	89 e8                	mov    %ebp,%eax
  8024dc:	f7 f6                	div    %esi
  8024de:	89 c5                	mov    %eax,%ebp
  8024e0:	89 f8                	mov    %edi,%eax
  8024e2:	f7 f6                	div    %esi
  8024e4:	89 ea                	mov    %ebp,%edx
  8024e6:	83 c4 0c             	add    $0xc,%esp
  8024e9:	5e                   	pop    %esi
  8024ea:	5f                   	pop    %edi
  8024eb:	5d                   	pop    %ebp
  8024ec:	c3                   	ret    
  8024ed:	8d 76 00             	lea    0x0(%esi),%esi
  8024f0:	39 e8                	cmp    %ebp,%eax
  8024f2:	77 24                	ja     802518 <__udivdi3+0x78>
  8024f4:	0f bd e8             	bsr    %eax,%ebp
  8024f7:	83 f5 1f             	xor    $0x1f,%ebp
  8024fa:	75 3c                	jne    802538 <__udivdi3+0x98>
  8024fc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802500:	39 34 24             	cmp    %esi,(%esp)
  802503:	0f 86 9f 00 00 00    	jbe    8025a8 <__udivdi3+0x108>
  802509:	39 d0                	cmp    %edx,%eax
  80250b:	0f 82 97 00 00 00    	jb     8025a8 <__udivdi3+0x108>
  802511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802518:	31 d2                	xor    %edx,%edx
  80251a:	31 c0                	xor    %eax,%eax
  80251c:	83 c4 0c             	add    $0xc,%esp
  80251f:	5e                   	pop    %esi
  802520:	5f                   	pop    %edi
  802521:	5d                   	pop    %ebp
  802522:	c3                   	ret    
  802523:	90                   	nop
  802524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802528:	89 f8                	mov    %edi,%eax
  80252a:	f7 f1                	div    %ecx
  80252c:	31 d2                	xor    %edx,%edx
  80252e:	83 c4 0c             	add    $0xc,%esp
  802531:	5e                   	pop    %esi
  802532:	5f                   	pop    %edi
  802533:	5d                   	pop    %ebp
  802534:	c3                   	ret    
  802535:	8d 76 00             	lea    0x0(%esi),%esi
  802538:	89 e9                	mov    %ebp,%ecx
  80253a:	8b 3c 24             	mov    (%esp),%edi
  80253d:	d3 e0                	shl    %cl,%eax
  80253f:	89 c6                	mov    %eax,%esi
  802541:	b8 20 00 00 00       	mov    $0x20,%eax
  802546:	29 e8                	sub    %ebp,%eax
  802548:	89 c1                	mov    %eax,%ecx
  80254a:	d3 ef                	shr    %cl,%edi
  80254c:	89 e9                	mov    %ebp,%ecx
  80254e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802552:	8b 3c 24             	mov    (%esp),%edi
  802555:	09 74 24 08          	or     %esi,0x8(%esp)
  802559:	89 d6                	mov    %edx,%esi
  80255b:	d3 e7                	shl    %cl,%edi
  80255d:	89 c1                	mov    %eax,%ecx
  80255f:	89 3c 24             	mov    %edi,(%esp)
  802562:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802566:	d3 ee                	shr    %cl,%esi
  802568:	89 e9                	mov    %ebp,%ecx
  80256a:	d3 e2                	shl    %cl,%edx
  80256c:	89 c1                	mov    %eax,%ecx
  80256e:	d3 ef                	shr    %cl,%edi
  802570:	09 d7                	or     %edx,%edi
  802572:	89 f2                	mov    %esi,%edx
  802574:	89 f8                	mov    %edi,%eax
  802576:	f7 74 24 08          	divl   0x8(%esp)
  80257a:	89 d6                	mov    %edx,%esi
  80257c:	89 c7                	mov    %eax,%edi
  80257e:	f7 24 24             	mull   (%esp)
  802581:	39 d6                	cmp    %edx,%esi
  802583:	89 14 24             	mov    %edx,(%esp)
  802586:	72 30                	jb     8025b8 <__udivdi3+0x118>
  802588:	8b 54 24 04          	mov    0x4(%esp),%edx
  80258c:	89 e9                	mov    %ebp,%ecx
  80258e:	d3 e2                	shl    %cl,%edx
  802590:	39 c2                	cmp    %eax,%edx
  802592:	73 05                	jae    802599 <__udivdi3+0xf9>
  802594:	3b 34 24             	cmp    (%esp),%esi
  802597:	74 1f                	je     8025b8 <__udivdi3+0x118>
  802599:	89 f8                	mov    %edi,%eax
  80259b:	31 d2                	xor    %edx,%edx
  80259d:	e9 7a ff ff ff       	jmp    80251c <__udivdi3+0x7c>
  8025a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025a8:	31 d2                	xor    %edx,%edx
  8025aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8025af:	e9 68 ff ff ff       	jmp    80251c <__udivdi3+0x7c>
  8025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025b8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8025bb:	31 d2                	xor    %edx,%edx
  8025bd:	83 c4 0c             	add    $0xc,%esp
  8025c0:	5e                   	pop    %esi
  8025c1:	5f                   	pop    %edi
  8025c2:	5d                   	pop    %ebp
  8025c3:	c3                   	ret    
  8025c4:	66 90                	xchg   %ax,%ax
  8025c6:	66 90                	xchg   %ax,%ax
  8025c8:	66 90                	xchg   %ax,%ax
  8025ca:	66 90                	xchg   %ax,%ax
  8025cc:	66 90                	xchg   %ax,%ax
  8025ce:	66 90                	xchg   %ax,%ax

008025d0 <__umoddi3>:
  8025d0:	55                   	push   %ebp
  8025d1:	57                   	push   %edi
  8025d2:	56                   	push   %esi
  8025d3:	83 ec 14             	sub    $0x14,%esp
  8025d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025da:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025de:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8025e2:	89 c7                	mov    %eax,%edi
  8025e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8025ec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8025f0:	89 34 24             	mov    %esi,(%esp)
  8025f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025f7:	85 c0                	test   %eax,%eax
  8025f9:	89 c2                	mov    %eax,%edx
  8025fb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025ff:	75 17                	jne    802618 <__umoddi3+0x48>
  802601:	39 fe                	cmp    %edi,%esi
  802603:	76 4b                	jbe    802650 <__umoddi3+0x80>
  802605:	89 c8                	mov    %ecx,%eax
  802607:	89 fa                	mov    %edi,%edx
  802609:	f7 f6                	div    %esi
  80260b:	89 d0                	mov    %edx,%eax
  80260d:	31 d2                	xor    %edx,%edx
  80260f:	83 c4 14             	add    $0x14,%esp
  802612:	5e                   	pop    %esi
  802613:	5f                   	pop    %edi
  802614:	5d                   	pop    %ebp
  802615:	c3                   	ret    
  802616:	66 90                	xchg   %ax,%ax
  802618:	39 f8                	cmp    %edi,%eax
  80261a:	77 54                	ja     802670 <__umoddi3+0xa0>
  80261c:	0f bd e8             	bsr    %eax,%ebp
  80261f:	83 f5 1f             	xor    $0x1f,%ebp
  802622:	75 5c                	jne    802680 <__umoddi3+0xb0>
  802624:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802628:	39 3c 24             	cmp    %edi,(%esp)
  80262b:	0f 87 e7 00 00 00    	ja     802718 <__umoddi3+0x148>
  802631:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802635:	29 f1                	sub    %esi,%ecx
  802637:	19 c7                	sbb    %eax,%edi
  802639:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80263d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802641:	8b 44 24 08          	mov    0x8(%esp),%eax
  802645:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802649:	83 c4 14             	add    $0x14,%esp
  80264c:	5e                   	pop    %esi
  80264d:	5f                   	pop    %edi
  80264e:	5d                   	pop    %ebp
  80264f:	c3                   	ret    
  802650:	85 f6                	test   %esi,%esi
  802652:	89 f5                	mov    %esi,%ebp
  802654:	75 0b                	jne    802661 <__umoddi3+0x91>
  802656:	b8 01 00 00 00       	mov    $0x1,%eax
  80265b:	31 d2                	xor    %edx,%edx
  80265d:	f7 f6                	div    %esi
  80265f:	89 c5                	mov    %eax,%ebp
  802661:	8b 44 24 04          	mov    0x4(%esp),%eax
  802665:	31 d2                	xor    %edx,%edx
  802667:	f7 f5                	div    %ebp
  802669:	89 c8                	mov    %ecx,%eax
  80266b:	f7 f5                	div    %ebp
  80266d:	eb 9c                	jmp    80260b <__umoddi3+0x3b>
  80266f:	90                   	nop
  802670:	89 c8                	mov    %ecx,%eax
  802672:	89 fa                	mov    %edi,%edx
  802674:	83 c4 14             	add    $0x14,%esp
  802677:	5e                   	pop    %esi
  802678:	5f                   	pop    %edi
  802679:	5d                   	pop    %ebp
  80267a:	c3                   	ret    
  80267b:	90                   	nop
  80267c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802680:	8b 04 24             	mov    (%esp),%eax
  802683:	be 20 00 00 00       	mov    $0x20,%esi
  802688:	89 e9                	mov    %ebp,%ecx
  80268a:	29 ee                	sub    %ebp,%esi
  80268c:	d3 e2                	shl    %cl,%edx
  80268e:	89 f1                	mov    %esi,%ecx
  802690:	d3 e8                	shr    %cl,%eax
  802692:	89 e9                	mov    %ebp,%ecx
  802694:	89 44 24 04          	mov    %eax,0x4(%esp)
  802698:	8b 04 24             	mov    (%esp),%eax
  80269b:	09 54 24 04          	or     %edx,0x4(%esp)
  80269f:	89 fa                	mov    %edi,%edx
  8026a1:	d3 e0                	shl    %cl,%eax
  8026a3:	89 f1                	mov    %esi,%ecx
  8026a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026a9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8026ad:	d3 ea                	shr    %cl,%edx
  8026af:	89 e9                	mov    %ebp,%ecx
  8026b1:	d3 e7                	shl    %cl,%edi
  8026b3:	89 f1                	mov    %esi,%ecx
  8026b5:	d3 e8                	shr    %cl,%eax
  8026b7:	89 e9                	mov    %ebp,%ecx
  8026b9:	09 f8                	or     %edi,%eax
  8026bb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8026bf:	f7 74 24 04          	divl   0x4(%esp)
  8026c3:	d3 e7                	shl    %cl,%edi
  8026c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026c9:	89 d7                	mov    %edx,%edi
  8026cb:	f7 64 24 08          	mull   0x8(%esp)
  8026cf:	39 d7                	cmp    %edx,%edi
  8026d1:	89 c1                	mov    %eax,%ecx
  8026d3:	89 14 24             	mov    %edx,(%esp)
  8026d6:	72 2c                	jb     802704 <__umoddi3+0x134>
  8026d8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8026dc:	72 22                	jb     802700 <__umoddi3+0x130>
  8026de:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8026e2:	29 c8                	sub    %ecx,%eax
  8026e4:	19 d7                	sbb    %edx,%edi
  8026e6:	89 e9                	mov    %ebp,%ecx
  8026e8:	89 fa                	mov    %edi,%edx
  8026ea:	d3 e8                	shr    %cl,%eax
  8026ec:	89 f1                	mov    %esi,%ecx
  8026ee:	d3 e2                	shl    %cl,%edx
  8026f0:	89 e9                	mov    %ebp,%ecx
  8026f2:	d3 ef                	shr    %cl,%edi
  8026f4:	09 d0                	or     %edx,%eax
  8026f6:	89 fa                	mov    %edi,%edx
  8026f8:	83 c4 14             	add    $0x14,%esp
  8026fb:	5e                   	pop    %esi
  8026fc:	5f                   	pop    %edi
  8026fd:	5d                   	pop    %ebp
  8026fe:	c3                   	ret    
  8026ff:	90                   	nop
  802700:	39 d7                	cmp    %edx,%edi
  802702:	75 da                	jne    8026de <__umoddi3+0x10e>
  802704:	8b 14 24             	mov    (%esp),%edx
  802707:	89 c1                	mov    %eax,%ecx
  802709:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80270d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802711:	eb cb                	jmp    8026de <__umoddi3+0x10e>
  802713:	90                   	nop
  802714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802718:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80271c:	0f 82 0f ff ff ff    	jb     802631 <__umoddi3+0x61>
  802722:	e9 1a ff ff ff       	jmp    802641 <__umoddi3+0x71>
