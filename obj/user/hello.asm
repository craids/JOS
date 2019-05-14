
obj/user/hello.debug:     file format elf32-i386


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
  80002c:	e8 2e 00 00 00       	call   80005f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("hello, world\n");
  800039:	c7 04 24 60 26 80 00 	movl   $0x802660,(%esp)
  800040:	e8 1e 01 00 00       	call   800163 <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800045:	a1 08 40 80 00       	mov    0x804008,%eax
  80004a:	8b 40 48             	mov    0x48(%eax),%eax
  80004d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800051:	c7 04 24 6e 26 80 00 	movl   $0x80266e,(%esp)
  800058:	e8 06 01 00 00       	call   800163 <cprintf>
}
  80005d:	c9                   	leave  
  80005e:	c3                   	ret    

0080005f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	56                   	push   %esi
  800063:	53                   	push   %ebx
  800064:	83 ec 10             	sub    $0x10,%esp
  800067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80006d:	e8 f3 0a 00 00       	call   800b65 <sys_getenvid>
  800072:	25 ff 03 00 00       	and    $0x3ff,%eax
  800077:	c1 e0 07             	shl    $0x7,%eax
  80007a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007f:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800084:	85 db                	test   %ebx,%ebx
  800086:	7e 07                	jle    80008f <libmain+0x30>
		binaryname = argv[0];
  800088:	8b 06                	mov    (%esi),%eax
  80008a:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80008f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800093:	89 1c 24             	mov    %ebx,(%esp)
  800096:	e8 98 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009b:	e8 07 00 00 00       	call   8000a7 <exit>
}
  8000a0:	83 c4 10             	add    $0x10,%esp
  8000a3:	5b                   	pop    %ebx
  8000a4:	5e                   	pop    %esi
  8000a5:	5d                   	pop    %ebp
  8000a6:	c3                   	ret    

008000a7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a7:	55                   	push   %ebp
  8000a8:	89 e5                	mov    %esp,%ebp
  8000aa:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000ad:	e8 18 10 00 00       	call   8010ca <close_all>
	sys_env_destroy(0);
  8000b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b9:	e8 55 0a 00 00       	call   800b13 <sys_env_destroy>
}
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	53                   	push   %ebx
  8000c4:	83 ec 14             	sub    $0x14,%esp
  8000c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ca:	8b 13                	mov    (%ebx),%edx
  8000cc:	8d 42 01             	lea    0x1(%edx),%eax
  8000cf:	89 03                	mov    %eax,(%ebx)
  8000d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000d8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000dd:	75 19                	jne    8000f8 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8000df:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8000e6:	00 
  8000e7:	8d 43 08             	lea    0x8(%ebx),%eax
  8000ea:	89 04 24             	mov    %eax,(%esp)
  8000ed:	e8 e4 09 00 00       	call   800ad6 <sys_cputs>
		b->idx = 0;
  8000f2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8000f8:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000fc:	83 c4 14             	add    $0x14,%esp
  8000ff:	5b                   	pop    %ebx
  800100:	5d                   	pop    %ebp
  800101:	c3                   	ret    

00800102 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800102:	55                   	push   %ebp
  800103:	89 e5                	mov    %esp,%ebp
  800105:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80010b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800112:	00 00 00 
	b.cnt = 0;
  800115:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80011c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80011f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800122:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800126:	8b 45 08             	mov    0x8(%ebp),%eax
  800129:	89 44 24 08          	mov    %eax,0x8(%esp)
  80012d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800133:	89 44 24 04          	mov    %eax,0x4(%esp)
  800137:	c7 04 24 c0 00 80 00 	movl   $0x8000c0,(%esp)
  80013e:	e8 ab 01 00 00       	call   8002ee <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800143:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800149:	89 44 24 04          	mov    %eax,0x4(%esp)
  80014d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800153:	89 04 24             	mov    %eax,(%esp)
  800156:	e8 7b 09 00 00       	call   800ad6 <sys_cputs>

	return b.cnt;
}
  80015b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800161:	c9                   	leave  
  800162:	c3                   	ret    

00800163 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800169:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800170:	8b 45 08             	mov    0x8(%ebp),%eax
  800173:	89 04 24             	mov    %eax,(%esp)
  800176:	e8 87 ff ff ff       	call   800102 <vcprintf>
	va_end(ap);

	return cnt;
}
  80017b:	c9                   	leave  
  80017c:	c3                   	ret    
  80017d:	66 90                	xchg   %ax,%ax
  80017f:	90                   	nop

00800180 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	57                   	push   %edi
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	83 ec 3c             	sub    $0x3c,%esp
  800189:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80018c:	89 d7                	mov    %edx,%edi
  80018e:	8b 45 08             	mov    0x8(%ebp),%eax
  800191:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800194:	8b 45 0c             	mov    0xc(%ebp),%eax
  800197:	89 c3                	mov    %eax,%ebx
  800199:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80019c:	8b 45 10             	mov    0x10(%ebp),%eax
  80019f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001aa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001ad:	39 d9                	cmp    %ebx,%ecx
  8001af:	72 05                	jb     8001b6 <printnum+0x36>
  8001b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001b4:	77 69                	ja     80021f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001b6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8001b9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8001bd:	83 ee 01             	sub    $0x1,%esi
  8001c0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8001c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8001cc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8001d0:	89 c3                	mov    %eax,%ebx
  8001d2:	89 d6                	mov    %edx,%esi
  8001d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001d7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8001da:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8001e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001e5:	89 04 24             	mov    %eax,(%esp)
  8001e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ef:	e8 dc 21 00 00       	call   8023d0 <__udivdi3>
  8001f4:	89 d9                	mov    %ebx,%ecx
  8001f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8001fa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8001fe:	89 04 24             	mov    %eax,(%esp)
  800201:	89 54 24 04          	mov    %edx,0x4(%esp)
  800205:	89 fa                	mov    %edi,%edx
  800207:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80020a:	e8 71 ff ff ff       	call   800180 <printnum>
  80020f:	eb 1b                	jmp    80022c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800211:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800215:	8b 45 18             	mov    0x18(%ebp),%eax
  800218:	89 04 24             	mov    %eax,(%esp)
  80021b:	ff d3                	call   *%ebx
  80021d:	eb 03                	jmp    800222 <printnum+0xa2>
  80021f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800222:	83 ee 01             	sub    $0x1,%esi
  800225:	85 f6                	test   %esi,%esi
  800227:	7f e8                	jg     800211 <printnum+0x91>
  800229:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80022c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800230:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800234:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800237:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80023a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80023e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800242:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800245:	89 04 24             	mov    %eax,(%esp)
  800248:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80024b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024f:	e8 ac 22 00 00       	call   802500 <__umoddi3>
  800254:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800258:	0f be 80 8f 26 80 00 	movsbl 0x80268f(%eax),%eax
  80025f:	89 04 24             	mov    %eax,(%esp)
  800262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800265:	ff d0                	call   *%eax
}
  800267:	83 c4 3c             	add    $0x3c,%esp
  80026a:	5b                   	pop    %ebx
  80026b:	5e                   	pop    %esi
  80026c:	5f                   	pop    %edi
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    

0080026f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80026f:	55                   	push   %ebp
  800270:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800272:	83 fa 01             	cmp    $0x1,%edx
  800275:	7e 0e                	jle    800285 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800277:	8b 10                	mov    (%eax),%edx
  800279:	8d 4a 08             	lea    0x8(%edx),%ecx
  80027c:	89 08                	mov    %ecx,(%eax)
  80027e:	8b 02                	mov    (%edx),%eax
  800280:	8b 52 04             	mov    0x4(%edx),%edx
  800283:	eb 22                	jmp    8002a7 <getuint+0x38>
	else if (lflag)
  800285:	85 d2                	test   %edx,%edx
  800287:	74 10                	je     800299 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800289:	8b 10                	mov    (%eax),%edx
  80028b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80028e:	89 08                	mov    %ecx,(%eax)
  800290:	8b 02                	mov    (%edx),%eax
  800292:	ba 00 00 00 00       	mov    $0x0,%edx
  800297:	eb 0e                	jmp    8002a7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800299:	8b 10                	mov    (%eax),%edx
  80029b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80029e:	89 08                	mov    %ecx,(%eax)
  8002a0:	8b 02                	mov    (%edx),%eax
  8002a2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002a7:	5d                   	pop    %ebp
  8002a8:	c3                   	ret    

008002a9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002af:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002b8:	73 0a                	jae    8002c4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002bd:	89 08                	mov    %ecx,(%eax)
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	88 02                	mov    %al,(%edx)
}
  8002c4:	5d                   	pop    %ebp
  8002c5:	c3                   	ret    

008002c6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8002cc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	89 04 24             	mov    %eax,(%esp)
  8002e7:	e8 02 00 00 00       	call   8002ee <vprintfmt>
	va_end(ap);
}
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    

008002ee <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	57                   	push   %edi
  8002f2:	56                   	push   %esi
  8002f3:	53                   	push   %ebx
  8002f4:	83 ec 3c             	sub    $0x3c,%esp
  8002f7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8002fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002fd:	eb 14                	jmp    800313 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002ff:	85 c0                	test   %eax,%eax
  800301:	0f 84 b3 03 00 00    	je     8006ba <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800307:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80030b:	89 04 24             	mov    %eax,(%esp)
  80030e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800311:	89 f3                	mov    %esi,%ebx
  800313:	8d 73 01             	lea    0x1(%ebx),%esi
  800316:	0f b6 03             	movzbl (%ebx),%eax
  800319:	83 f8 25             	cmp    $0x25,%eax
  80031c:	75 e1                	jne    8002ff <vprintfmt+0x11>
  80031e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800322:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800329:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800330:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800337:	ba 00 00 00 00       	mov    $0x0,%edx
  80033c:	eb 1d                	jmp    80035b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80033e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800340:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800344:	eb 15                	jmp    80035b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800346:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800348:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80034c:	eb 0d                	jmp    80035b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80034e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800351:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800354:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80035b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80035e:	0f b6 0e             	movzbl (%esi),%ecx
  800361:	0f b6 c1             	movzbl %cl,%eax
  800364:	83 e9 23             	sub    $0x23,%ecx
  800367:	80 f9 55             	cmp    $0x55,%cl
  80036a:	0f 87 2a 03 00 00    	ja     80069a <vprintfmt+0x3ac>
  800370:	0f b6 c9             	movzbl %cl,%ecx
  800373:	ff 24 8d e0 27 80 00 	jmp    *0x8027e0(,%ecx,4)
  80037a:	89 de                	mov    %ebx,%esi
  80037c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800381:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800384:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800388:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80038b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80038e:	83 fb 09             	cmp    $0x9,%ebx
  800391:	77 36                	ja     8003c9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800393:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800396:	eb e9                	jmp    800381 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800398:	8b 45 14             	mov    0x14(%ebp),%eax
  80039b:	8d 48 04             	lea    0x4(%eax),%ecx
  80039e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003a1:	8b 00                	mov    (%eax),%eax
  8003a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003a6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003a8:	eb 22                	jmp    8003cc <vprintfmt+0xde>
  8003aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003ad:	85 c9                	test   %ecx,%ecx
  8003af:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b4:	0f 49 c1             	cmovns %ecx,%eax
  8003b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ba:	89 de                	mov    %ebx,%esi
  8003bc:	eb 9d                	jmp    80035b <vprintfmt+0x6d>
  8003be:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003c0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8003c7:	eb 92                	jmp    80035b <vprintfmt+0x6d>
  8003c9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8003cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8003d0:	79 89                	jns    80035b <vprintfmt+0x6d>
  8003d2:	e9 77 ff ff ff       	jmp    80034e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003d7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003dc:	e9 7a ff ff ff       	jmp    80035b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e4:	8d 50 04             	lea    0x4(%eax),%edx
  8003e7:	89 55 14             	mov    %edx,0x14(%ebp)
  8003ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003ee:	8b 00                	mov    (%eax),%eax
  8003f0:	89 04 24             	mov    %eax,(%esp)
  8003f3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8003f6:	e9 18 ff ff ff       	jmp    800313 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fe:	8d 50 04             	lea    0x4(%eax),%edx
  800401:	89 55 14             	mov    %edx,0x14(%ebp)
  800404:	8b 00                	mov    (%eax),%eax
  800406:	99                   	cltd   
  800407:	31 d0                	xor    %edx,%eax
  800409:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80040b:	83 f8 11             	cmp    $0x11,%eax
  80040e:	7f 0b                	jg     80041b <vprintfmt+0x12d>
  800410:	8b 14 85 40 29 80 00 	mov    0x802940(,%eax,4),%edx
  800417:	85 d2                	test   %edx,%edx
  800419:	75 20                	jne    80043b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80041b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80041f:	c7 44 24 08 a7 26 80 	movl   $0x8026a7,0x8(%esp)
  800426:	00 
  800427:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	89 04 24             	mov    %eax,(%esp)
  800431:	e8 90 fe ff ff       	call   8002c6 <printfmt>
  800436:	e9 d8 fe ff ff       	jmp    800313 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80043b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80043f:	c7 44 24 08 7d 2a 80 	movl   $0x802a7d,0x8(%esp)
  800446:	00 
  800447:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80044b:	8b 45 08             	mov    0x8(%ebp),%eax
  80044e:	89 04 24             	mov    %eax,(%esp)
  800451:	e8 70 fe ff ff       	call   8002c6 <printfmt>
  800456:	e9 b8 fe ff ff       	jmp    800313 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80045e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800461:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	8d 50 04             	lea    0x4(%eax),%edx
  80046a:	89 55 14             	mov    %edx,0x14(%ebp)
  80046d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80046f:	85 f6                	test   %esi,%esi
  800471:	b8 a0 26 80 00       	mov    $0x8026a0,%eax
  800476:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800479:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80047d:	0f 84 97 00 00 00    	je     80051a <vprintfmt+0x22c>
  800483:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800487:	0f 8e 9b 00 00 00    	jle    800528 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80048d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800491:	89 34 24             	mov    %esi,(%esp)
  800494:	e8 cf 02 00 00       	call   800768 <strnlen>
  800499:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80049c:	29 c2                	sub    %eax,%edx
  80049e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8004a1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8004a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004b1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b3:	eb 0f                	jmp    8004c4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8004b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004bc:	89 04 24             	mov    %eax,(%esp)
  8004bf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c1:	83 eb 01             	sub    $0x1,%ebx
  8004c4:	85 db                	test   %ebx,%ebx
  8004c6:	7f ed                	jg     8004b5 <vprintfmt+0x1c7>
  8004c8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8004cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004ce:	85 d2                	test   %edx,%edx
  8004d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d5:	0f 49 c2             	cmovns %edx,%eax
  8004d8:	29 c2                	sub    %eax,%edx
  8004da:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8004dd:	89 d7                	mov    %edx,%edi
  8004df:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8004e2:	eb 50                	jmp    800534 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e8:	74 1e                	je     800508 <vprintfmt+0x21a>
  8004ea:	0f be d2             	movsbl %dl,%edx
  8004ed:	83 ea 20             	sub    $0x20,%edx
  8004f0:	83 fa 5e             	cmp    $0x5e,%edx
  8004f3:	76 13                	jbe    800508 <vprintfmt+0x21a>
					putch('?', putdat);
  8004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004fc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800503:	ff 55 08             	call   *0x8(%ebp)
  800506:	eb 0d                	jmp    800515 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800508:	8b 55 0c             	mov    0xc(%ebp),%edx
  80050b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80050f:	89 04 24             	mov    %eax,(%esp)
  800512:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800515:	83 ef 01             	sub    $0x1,%edi
  800518:	eb 1a                	jmp    800534 <vprintfmt+0x246>
  80051a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80051d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800520:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800523:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800526:	eb 0c                	jmp    800534 <vprintfmt+0x246>
  800528:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80052b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80052e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800531:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800534:	83 c6 01             	add    $0x1,%esi
  800537:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80053b:	0f be c2             	movsbl %dl,%eax
  80053e:	85 c0                	test   %eax,%eax
  800540:	74 27                	je     800569 <vprintfmt+0x27b>
  800542:	85 db                	test   %ebx,%ebx
  800544:	78 9e                	js     8004e4 <vprintfmt+0x1f6>
  800546:	83 eb 01             	sub    $0x1,%ebx
  800549:	79 99                	jns    8004e4 <vprintfmt+0x1f6>
  80054b:	89 f8                	mov    %edi,%eax
  80054d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800550:	8b 75 08             	mov    0x8(%ebp),%esi
  800553:	89 c3                	mov    %eax,%ebx
  800555:	eb 1a                	jmp    800571 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800557:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80055b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800562:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800564:	83 eb 01             	sub    $0x1,%ebx
  800567:	eb 08                	jmp    800571 <vprintfmt+0x283>
  800569:	89 fb                	mov    %edi,%ebx
  80056b:	8b 75 08             	mov    0x8(%ebp),%esi
  80056e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800571:	85 db                	test   %ebx,%ebx
  800573:	7f e2                	jg     800557 <vprintfmt+0x269>
  800575:	89 75 08             	mov    %esi,0x8(%ebp)
  800578:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80057b:	e9 93 fd ff ff       	jmp    800313 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800580:	83 fa 01             	cmp    $0x1,%edx
  800583:	7e 16                	jle    80059b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800585:	8b 45 14             	mov    0x14(%ebp),%eax
  800588:	8d 50 08             	lea    0x8(%eax),%edx
  80058b:	89 55 14             	mov    %edx,0x14(%ebp)
  80058e:	8b 50 04             	mov    0x4(%eax),%edx
  800591:	8b 00                	mov    (%eax),%eax
  800593:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800596:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800599:	eb 32                	jmp    8005cd <vprintfmt+0x2df>
	else if (lflag)
  80059b:	85 d2                	test   %edx,%edx
  80059d:	74 18                	je     8005b7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80059f:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a2:	8d 50 04             	lea    0x4(%eax),%edx
  8005a5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005a8:	8b 30                	mov    (%eax),%esi
  8005aa:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005ad:	89 f0                	mov    %esi,%eax
  8005af:	c1 f8 1f             	sar    $0x1f,%eax
  8005b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005b5:	eb 16                	jmp    8005cd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8005b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ba:	8d 50 04             	lea    0x4(%eax),%edx
  8005bd:	89 55 14             	mov    %edx,0x14(%ebp)
  8005c0:	8b 30                	mov    (%eax),%esi
  8005c2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005c5:	89 f0                	mov    %esi,%eax
  8005c7:	c1 f8 1f             	sar    $0x1f,%eax
  8005ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005dc:	0f 89 80 00 00 00    	jns    800662 <vprintfmt+0x374>
				putch('-', putdat);
  8005e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005e6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005ed:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8005f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005f6:	f7 d8                	neg    %eax
  8005f8:	83 d2 00             	adc    $0x0,%edx
  8005fb:	f7 da                	neg    %edx
			}
			base = 10;
  8005fd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800602:	eb 5e                	jmp    800662 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800604:	8d 45 14             	lea    0x14(%ebp),%eax
  800607:	e8 63 fc ff ff       	call   80026f <getuint>
			base = 10;
  80060c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800611:	eb 4f                	jmp    800662 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800613:	8d 45 14             	lea    0x14(%ebp),%eax
  800616:	e8 54 fc ff ff       	call   80026f <getuint>
			base = 8;
  80061b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800620:	eb 40                	jmp    800662 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800622:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800626:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80062d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800630:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800634:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80063b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8d 50 04             	lea    0x4(%eax),%edx
  800644:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800647:	8b 00                	mov    (%eax),%eax
  800649:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80064e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800653:	eb 0d                	jmp    800662 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800655:	8d 45 14             	lea    0x14(%ebp),%eax
  800658:	e8 12 fc ff ff       	call   80026f <getuint>
			base = 16;
  80065d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800662:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800666:	89 74 24 10          	mov    %esi,0x10(%esp)
  80066a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80066d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800671:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800675:	89 04 24             	mov    %eax,(%esp)
  800678:	89 54 24 04          	mov    %edx,0x4(%esp)
  80067c:	89 fa                	mov    %edi,%edx
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	e8 fa fa ff ff       	call   800180 <printnum>
			break;
  800686:	e9 88 fc ff ff       	jmp    800313 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80068b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80068f:	89 04 24             	mov    %eax,(%esp)
  800692:	ff 55 08             	call   *0x8(%ebp)
			break;
  800695:	e9 79 fc ff ff       	jmp    800313 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80069a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80069e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006a5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006a8:	89 f3                	mov    %esi,%ebx
  8006aa:	eb 03                	jmp    8006af <vprintfmt+0x3c1>
  8006ac:	83 eb 01             	sub    $0x1,%ebx
  8006af:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8006b3:	75 f7                	jne    8006ac <vprintfmt+0x3be>
  8006b5:	e9 59 fc ff ff       	jmp    800313 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8006ba:	83 c4 3c             	add    $0x3c,%esp
  8006bd:	5b                   	pop    %ebx
  8006be:	5e                   	pop    %esi
  8006bf:	5f                   	pop    %edi
  8006c0:	5d                   	pop    %ebp
  8006c1:	c3                   	ret    

008006c2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006c2:	55                   	push   %ebp
  8006c3:	89 e5                	mov    %esp,%ebp
  8006c5:	83 ec 28             	sub    $0x28,%esp
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006d1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006d5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006df:	85 c0                	test   %eax,%eax
  8006e1:	74 30                	je     800713 <vsnprintf+0x51>
  8006e3:	85 d2                	test   %edx,%edx
  8006e5:	7e 2c                	jle    800713 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006fc:	c7 04 24 a9 02 80 00 	movl   $0x8002a9,(%esp)
  800703:	e8 e6 fb ff ff       	call   8002ee <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800708:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80070b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80070e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800711:	eb 05                	jmp    800718 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800713:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800720:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800723:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800727:	8b 45 10             	mov    0x10(%ebp),%eax
  80072a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80072e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800731:	89 44 24 04          	mov    %eax,0x4(%esp)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	89 04 24             	mov    %eax,(%esp)
  80073b:	e8 82 ff ff ff       	call   8006c2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800740:	c9                   	leave  
  800741:	c3                   	ret    
  800742:	66 90                	xchg   %ax,%ax
  800744:	66 90                	xchg   %ax,%ax
  800746:	66 90                	xchg   %ax,%ax
  800748:	66 90                	xchg   %ax,%ax
  80074a:	66 90                	xchg   %ax,%ax
  80074c:	66 90                	xchg   %ax,%ax
  80074e:	66 90                	xchg   %ax,%ax

00800750 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800756:	b8 00 00 00 00       	mov    $0x0,%eax
  80075b:	eb 03                	jmp    800760 <strlen+0x10>
		n++;
  80075d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800760:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800764:	75 f7                	jne    80075d <strlen+0xd>
		n++;
	return n;
}
  800766:	5d                   	pop    %ebp
  800767:	c3                   	ret    

00800768 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800768:	55                   	push   %ebp
  800769:	89 e5                	mov    %esp,%ebp
  80076b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80076e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800771:	b8 00 00 00 00       	mov    $0x0,%eax
  800776:	eb 03                	jmp    80077b <strnlen+0x13>
		n++;
  800778:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80077b:	39 d0                	cmp    %edx,%eax
  80077d:	74 06                	je     800785 <strnlen+0x1d>
  80077f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800783:	75 f3                	jne    800778 <strnlen+0x10>
		n++;
	return n;
}
  800785:	5d                   	pop    %ebp
  800786:	c3                   	ret    

00800787 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800787:	55                   	push   %ebp
  800788:	89 e5                	mov    %esp,%ebp
  80078a:	53                   	push   %ebx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800791:	89 c2                	mov    %eax,%edx
  800793:	83 c2 01             	add    $0x1,%edx
  800796:	83 c1 01             	add    $0x1,%ecx
  800799:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80079d:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007a0:	84 db                	test   %bl,%bl
  8007a2:	75 ef                	jne    800793 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007a4:	5b                   	pop    %ebx
  8007a5:	5d                   	pop    %ebp
  8007a6:	c3                   	ret    

008007a7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007a7:	55                   	push   %ebp
  8007a8:	89 e5                	mov    %esp,%ebp
  8007aa:	53                   	push   %ebx
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007b1:	89 1c 24             	mov    %ebx,(%esp)
  8007b4:	e8 97 ff ff ff       	call   800750 <strlen>
	strcpy(dst + len, src);
  8007b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007c0:	01 d8                	add    %ebx,%eax
  8007c2:	89 04 24             	mov    %eax,(%esp)
  8007c5:	e8 bd ff ff ff       	call   800787 <strcpy>
	return dst;
}
  8007ca:	89 d8                	mov    %ebx,%eax
  8007cc:	83 c4 08             	add    $0x8,%esp
  8007cf:	5b                   	pop    %ebx
  8007d0:	5d                   	pop    %ebp
  8007d1:	c3                   	ret    

008007d2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	56                   	push   %esi
  8007d6:	53                   	push   %ebx
  8007d7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007dd:	89 f3                	mov    %esi,%ebx
  8007df:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007e2:	89 f2                	mov    %esi,%edx
  8007e4:	eb 0f                	jmp    8007f5 <strncpy+0x23>
		*dst++ = *src;
  8007e6:	83 c2 01             	add    $0x1,%edx
  8007e9:	0f b6 01             	movzbl (%ecx),%eax
  8007ec:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007ef:	80 39 01             	cmpb   $0x1,(%ecx)
  8007f2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007f5:	39 da                	cmp    %ebx,%edx
  8007f7:	75 ed                	jne    8007e6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8007f9:	89 f0                	mov    %esi,%eax
  8007fb:	5b                   	pop    %ebx
  8007fc:	5e                   	pop    %esi
  8007fd:	5d                   	pop    %ebp
  8007fe:	c3                   	ret    

008007ff <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	56                   	push   %esi
  800803:	53                   	push   %ebx
  800804:	8b 75 08             	mov    0x8(%ebp),%esi
  800807:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80080d:	89 f0                	mov    %esi,%eax
  80080f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800813:	85 c9                	test   %ecx,%ecx
  800815:	75 0b                	jne    800822 <strlcpy+0x23>
  800817:	eb 1d                	jmp    800836 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800819:	83 c0 01             	add    $0x1,%eax
  80081c:	83 c2 01             	add    $0x1,%edx
  80081f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800822:	39 d8                	cmp    %ebx,%eax
  800824:	74 0b                	je     800831 <strlcpy+0x32>
  800826:	0f b6 0a             	movzbl (%edx),%ecx
  800829:	84 c9                	test   %cl,%cl
  80082b:	75 ec                	jne    800819 <strlcpy+0x1a>
  80082d:	89 c2                	mov    %eax,%edx
  80082f:	eb 02                	jmp    800833 <strlcpy+0x34>
  800831:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800833:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800836:	29 f0                	sub    %esi,%eax
}
  800838:	5b                   	pop    %ebx
  800839:	5e                   	pop    %esi
  80083a:	5d                   	pop    %ebp
  80083b:	c3                   	ret    

0080083c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800842:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800845:	eb 06                	jmp    80084d <strcmp+0x11>
		p++, q++;
  800847:	83 c1 01             	add    $0x1,%ecx
  80084a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80084d:	0f b6 01             	movzbl (%ecx),%eax
  800850:	84 c0                	test   %al,%al
  800852:	74 04                	je     800858 <strcmp+0x1c>
  800854:	3a 02                	cmp    (%edx),%al
  800856:	74 ef                	je     800847 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800858:	0f b6 c0             	movzbl %al,%eax
  80085b:	0f b6 12             	movzbl (%edx),%edx
  80085e:	29 d0                	sub    %edx,%eax
}
  800860:	5d                   	pop    %ebp
  800861:	c3                   	ret    

00800862 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800862:	55                   	push   %ebp
  800863:	89 e5                	mov    %esp,%ebp
  800865:	53                   	push   %ebx
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086c:	89 c3                	mov    %eax,%ebx
  80086e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800871:	eb 06                	jmp    800879 <strncmp+0x17>
		n--, p++, q++;
  800873:	83 c0 01             	add    $0x1,%eax
  800876:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800879:	39 d8                	cmp    %ebx,%eax
  80087b:	74 15                	je     800892 <strncmp+0x30>
  80087d:	0f b6 08             	movzbl (%eax),%ecx
  800880:	84 c9                	test   %cl,%cl
  800882:	74 04                	je     800888 <strncmp+0x26>
  800884:	3a 0a                	cmp    (%edx),%cl
  800886:	74 eb                	je     800873 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800888:	0f b6 00             	movzbl (%eax),%eax
  80088b:	0f b6 12             	movzbl (%edx),%edx
  80088e:	29 d0                	sub    %edx,%eax
  800890:	eb 05                	jmp    800897 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800892:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800897:	5b                   	pop    %ebx
  800898:	5d                   	pop    %ebp
  800899:	c3                   	ret    

0080089a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008a4:	eb 07                	jmp    8008ad <strchr+0x13>
		if (*s == c)
  8008a6:	38 ca                	cmp    %cl,%dl
  8008a8:	74 0f                	je     8008b9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008aa:	83 c0 01             	add    $0x1,%eax
  8008ad:	0f b6 10             	movzbl (%eax),%edx
  8008b0:	84 d2                	test   %dl,%dl
  8008b2:	75 f2                	jne    8008a6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8008b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008c5:	eb 07                	jmp    8008ce <strfind+0x13>
		if (*s == c)
  8008c7:	38 ca                	cmp    %cl,%dl
  8008c9:	74 0a                	je     8008d5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8008cb:	83 c0 01             	add    $0x1,%eax
  8008ce:	0f b6 10             	movzbl (%eax),%edx
  8008d1:	84 d2                	test   %dl,%dl
  8008d3:	75 f2                	jne    8008c7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	57                   	push   %edi
  8008db:	56                   	push   %esi
  8008dc:	53                   	push   %ebx
  8008dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008e3:	85 c9                	test   %ecx,%ecx
  8008e5:	74 36                	je     80091d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008e7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008ed:	75 28                	jne    800917 <memset+0x40>
  8008ef:	f6 c1 03             	test   $0x3,%cl
  8008f2:	75 23                	jne    800917 <memset+0x40>
		c &= 0xFF;
  8008f4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008f8:	89 d3                	mov    %edx,%ebx
  8008fa:	c1 e3 08             	shl    $0x8,%ebx
  8008fd:	89 d6                	mov    %edx,%esi
  8008ff:	c1 e6 18             	shl    $0x18,%esi
  800902:	89 d0                	mov    %edx,%eax
  800904:	c1 e0 10             	shl    $0x10,%eax
  800907:	09 f0                	or     %esi,%eax
  800909:	09 c2                	or     %eax,%edx
  80090b:	89 d0                	mov    %edx,%eax
  80090d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80090f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800912:	fc                   	cld    
  800913:	f3 ab                	rep stos %eax,%es:(%edi)
  800915:	eb 06                	jmp    80091d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800917:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091a:	fc                   	cld    
  80091b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80091d:	89 f8                	mov    %edi,%eax
  80091f:	5b                   	pop    %ebx
  800920:	5e                   	pop    %esi
  800921:	5f                   	pop    %edi
  800922:	5d                   	pop    %ebp
  800923:	c3                   	ret    

00800924 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	57                   	push   %edi
  800928:	56                   	push   %esi
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80092f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800932:	39 c6                	cmp    %eax,%esi
  800934:	73 35                	jae    80096b <memmove+0x47>
  800936:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800939:	39 d0                	cmp    %edx,%eax
  80093b:	73 2e                	jae    80096b <memmove+0x47>
		s += n;
		d += n;
  80093d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800940:	89 d6                	mov    %edx,%esi
  800942:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800944:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80094a:	75 13                	jne    80095f <memmove+0x3b>
  80094c:	f6 c1 03             	test   $0x3,%cl
  80094f:	75 0e                	jne    80095f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800951:	83 ef 04             	sub    $0x4,%edi
  800954:	8d 72 fc             	lea    -0x4(%edx),%esi
  800957:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80095a:	fd                   	std    
  80095b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80095d:	eb 09                	jmp    800968 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80095f:	83 ef 01             	sub    $0x1,%edi
  800962:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800965:	fd                   	std    
  800966:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800968:	fc                   	cld    
  800969:	eb 1d                	jmp    800988 <memmove+0x64>
  80096b:	89 f2                	mov    %esi,%edx
  80096d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80096f:	f6 c2 03             	test   $0x3,%dl
  800972:	75 0f                	jne    800983 <memmove+0x5f>
  800974:	f6 c1 03             	test   $0x3,%cl
  800977:	75 0a                	jne    800983 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800979:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80097c:	89 c7                	mov    %eax,%edi
  80097e:	fc                   	cld    
  80097f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800981:	eb 05                	jmp    800988 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800983:	89 c7                	mov    %eax,%edi
  800985:	fc                   	cld    
  800986:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800988:	5e                   	pop    %esi
  800989:	5f                   	pop    %edi
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800992:	8b 45 10             	mov    0x10(%ebp),%eax
  800995:	89 44 24 08          	mov    %eax,0x8(%esp)
  800999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	89 04 24             	mov    %eax,(%esp)
  8009a6:	e8 79 ff ff ff       	call   800924 <memmove>
}
  8009ab:	c9                   	leave  
  8009ac:	c3                   	ret    

008009ad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	56                   	push   %esi
  8009b1:	53                   	push   %ebx
  8009b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b8:	89 d6                	mov    %edx,%esi
  8009ba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009bd:	eb 1a                	jmp    8009d9 <memcmp+0x2c>
		if (*s1 != *s2)
  8009bf:	0f b6 02             	movzbl (%edx),%eax
  8009c2:	0f b6 19             	movzbl (%ecx),%ebx
  8009c5:	38 d8                	cmp    %bl,%al
  8009c7:	74 0a                	je     8009d3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8009c9:	0f b6 c0             	movzbl %al,%eax
  8009cc:	0f b6 db             	movzbl %bl,%ebx
  8009cf:	29 d8                	sub    %ebx,%eax
  8009d1:	eb 0f                	jmp    8009e2 <memcmp+0x35>
		s1++, s2++;
  8009d3:	83 c2 01             	add    $0x1,%edx
  8009d6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009d9:	39 f2                	cmp    %esi,%edx
  8009db:	75 e2                	jne    8009bf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8009dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009e2:	5b                   	pop    %ebx
  8009e3:	5e                   	pop    %esi
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009ef:	89 c2                	mov    %eax,%edx
  8009f1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009f4:	eb 07                	jmp    8009fd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009f6:	38 08                	cmp    %cl,(%eax)
  8009f8:	74 07                	je     800a01 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009fa:	83 c0 01             	add    $0x1,%eax
  8009fd:	39 d0                	cmp    %edx,%eax
  8009ff:	72 f5                	jb     8009f6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a01:	5d                   	pop    %ebp
  800a02:	c3                   	ret    

00800a03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a03:	55                   	push   %ebp
  800a04:	89 e5                	mov    %esp,%ebp
  800a06:	57                   	push   %edi
  800a07:	56                   	push   %esi
  800a08:	53                   	push   %ebx
  800a09:	8b 55 08             	mov    0x8(%ebp),%edx
  800a0c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a0f:	eb 03                	jmp    800a14 <strtol+0x11>
		s++;
  800a11:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a14:	0f b6 0a             	movzbl (%edx),%ecx
  800a17:	80 f9 09             	cmp    $0x9,%cl
  800a1a:	74 f5                	je     800a11 <strtol+0xe>
  800a1c:	80 f9 20             	cmp    $0x20,%cl
  800a1f:	74 f0                	je     800a11 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a21:	80 f9 2b             	cmp    $0x2b,%cl
  800a24:	75 0a                	jne    800a30 <strtol+0x2d>
		s++;
  800a26:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a29:	bf 00 00 00 00       	mov    $0x0,%edi
  800a2e:	eb 11                	jmp    800a41 <strtol+0x3e>
  800a30:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a35:	80 f9 2d             	cmp    $0x2d,%cl
  800a38:	75 07                	jne    800a41 <strtol+0x3e>
		s++, neg = 1;
  800a3a:	8d 52 01             	lea    0x1(%edx),%edx
  800a3d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a41:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800a46:	75 15                	jne    800a5d <strtol+0x5a>
  800a48:	80 3a 30             	cmpb   $0x30,(%edx)
  800a4b:	75 10                	jne    800a5d <strtol+0x5a>
  800a4d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800a51:	75 0a                	jne    800a5d <strtol+0x5a>
		s += 2, base = 16;
  800a53:	83 c2 02             	add    $0x2,%edx
  800a56:	b8 10 00 00 00       	mov    $0x10,%eax
  800a5b:	eb 10                	jmp    800a6d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800a5d:	85 c0                	test   %eax,%eax
  800a5f:	75 0c                	jne    800a6d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a61:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a63:	80 3a 30             	cmpb   $0x30,(%edx)
  800a66:	75 05                	jne    800a6d <strtol+0x6a>
		s++, base = 8;
  800a68:	83 c2 01             	add    $0x1,%edx
  800a6b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800a6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a72:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a75:	0f b6 0a             	movzbl (%edx),%ecx
  800a78:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800a7b:	89 f0                	mov    %esi,%eax
  800a7d:	3c 09                	cmp    $0x9,%al
  800a7f:	77 08                	ja     800a89 <strtol+0x86>
			dig = *s - '0';
  800a81:	0f be c9             	movsbl %cl,%ecx
  800a84:	83 e9 30             	sub    $0x30,%ecx
  800a87:	eb 20                	jmp    800aa9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800a89:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800a8c:	89 f0                	mov    %esi,%eax
  800a8e:	3c 19                	cmp    $0x19,%al
  800a90:	77 08                	ja     800a9a <strtol+0x97>
			dig = *s - 'a' + 10;
  800a92:	0f be c9             	movsbl %cl,%ecx
  800a95:	83 e9 57             	sub    $0x57,%ecx
  800a98:	eb 0f                	jmp    800aa9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800a9a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800a9d:	89 f0                	mov    %esi,%eax
  800a9f:	3c 19                	cmp    $0x19,%al
  800aa1:	77 16                	ja     800ab9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800aa3:	0f be c9             	movsbl %cl,%ecx
  800aa6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800aa9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800aac:	7d 0f                	jge    800abd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800aae:	83 c2 01             	add    $0x1,%edx
  800ab1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ab5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ab7:	eb bc                	jmp    800a75 <strtol+0x72>
  800ab9:	89 d8                	mov    %ebx,%eax
  800abb:	eb 02                	jmp    800abf <strtol+0xbc>
  800abd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800abf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac3:	74 05                	je     800aca <strtol+0xc7>
		*endptr = (char *) s;
  800ac5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800aca:	f7 d8                	neg    %eax
  800acc:	85 ff                	test   %edi,%edi
  800ace:	0f 44 c3             	cmove  %ebx,%eax
}
  800ad1:	5b                   	pop    %ebx
  800ad2:	5e                   	pop    %esi
  800ad3:	5f                   	pop    %edi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	57                   	push   %edi
  800ada:	56                   	push   %esi
  800adb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800adc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ae1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ae4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae7:	89 c3                	mov    %eax,%ebx
  800ae9:	89 c7                	mov    %eax,%edi
  800aeb:	89 c6                	mov    %eax,%esi
  800aed:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    

00800af4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800af4:	55                   	push   %ebp
  800af5:	89 e5                	mov    %esp,%ebp
  800af7:	57                   	push   %edi
  800af8:	56                   	push   %esi
  800af9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800afa:	ba 00 00 00 00       	mov    $0x0,%edx
  800aff:	b8 01 00 00 00       	mov    $0x1,%eax
  800b04:	89 d1                	mov    %edx,%ecx
  800b06:	89 d3                	mov    %edx,%ebx
  800b08:	89 d7                	mov    %edx,%edi
  800b0a:	89 d6                	mov    %edx,%esi
  800b0c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b0e:	5b                   	pop    %ebx
  800b0f:	5e                   	pop    %esi
  800b10:	5f                   	pop    %edi
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	57                   	push   %edi
  800b17:	56                   	push   %esi
  800b18:	53                   	push   %ebx
  800b19:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b21:	b8 03 00 00 00       	mov    $0x3,%eax
  800b26:	8b 55 08             	mov    0x8(%ebp),%edx
  800b29:	89 cb                	mov    %ecx,%ebx
  800b2b:	89 cf                	mov    %ecx,%edi
  800b2d:	89 ce                	mov    %ecx,%esi
  800b2f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b31:	85 c0                	test   %eax,%eax
  800b33:	7e 28                	jle    800b5d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b35:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b39:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800b40:	00 
  800b41:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800b48:	00 
  800b49:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800b50:	00 
  800b51:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800b58:	e8 a9 16 00 00       	call   802206 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b5d:	83 c4 2c             	add    $0x2c,%esp
  800b60:	5b                   	pop    %ebx
  800b61:	5e                   	pop    %esi
  800b62:	5f                   	pop    %edi
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	57                   	push   %edi
  800b69:	56                   	push   %esi
  800b6a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b70:	b8 02 00 00 00       	mov    $0x2,%eax
  800b75:	89 d1                	mov    %edx,%ecx
  800b77:	89 d3                	mov    %edx,%ebx
  800b79:	89 d7                	mov    %edx,%edi
  800b7b:	89 d6                	mov    %edx,%esi
  800b7d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b7f:	5b                   	pop    %ebx
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <sys_yield>:

void
sys_yield(void)
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
  800b8f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b94:	89 d1                	mov    %edx,%ecx
  800b96:	89 d3                	mov    %edx,%ebx
  800b98:	89 d7                	mov    %edx,%edi
  800b9a:	89 d6                	mov    %edx,%esi
  800b9c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b9e:	5b                   	pop    %ebx
  800b9f:	5e                   	pop    %esi
  800ba0:	5f                   	pop    %edi
  800ba1:	5d                   	pop    %ebp
  800ba2:	c3                   	ret    

00800ba3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800bac:	be 00 00 00 00       	mov    $0x0,%esi
  800bb1:	b8 04 00 00 00       	mov    $0x4,%eax
  800bb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bbf:	89 f7                	mov    %esi,%edi
  800bc1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800bc3:	85 c0                	test   %eax,%eax
  800bc5:	7e 28                	jle    800bef <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bcb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800bd2:	00 
  800bd3:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800bda:	00 
  800bdb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800be2:	00 
  800be3:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800bea:	e8 17 16 00 00       	call   802206 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bef:	83 c4 2c             	add    $0x2c,%esp
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5f                   	pop    %edi
  800bf5:	5d                   	pop    %ebp
  800bf6:	c3                   	ret    

00800bf7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	57                   	push   %edi
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
  800bfd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c00:	b8 05 00 00 00       	mov    $0x5,%eax
  800c05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c08:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c0e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c11:	8b 75 18             	mov    0x18(%ebp),%esi
  800c14:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c16:	85 c0                	test   %eax,%eax
  800c18:	7e 28                	jle    800c42 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c1e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800c25:	00 
  800c26:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800c2d:	00 
  800c2e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c35:	00 
  800c36:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800c3d:	e8 c4 15 00 00       	call   802206 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c42:	83 c4 2c             	add    $0x2c,%esp
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	57                   	push   %edi
  800c4e:	56                   	push   %esi
  800c4f:	53                   	push   %ebx
  800c50:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c58:	b8 06 00 00 00       	mov    $0x6,%eax
  800c5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c60:	8b 55 08             	mov    0x8(%ebp),%edx
  800c63:	89 df                	mov    %ebx,%edi
  800c65:	89 de                	mov    %ebx,%esi
  800c67:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c69:	85 c0                	test   %eax,%eax
  800c6b:	7e 28                	jle    800c95 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c71:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800c78:	00 
  800c79:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800c80:	00 
  800c81:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c88:	00 
  800c89:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800c90:	e8 71 15 00 00       	call   802206 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c95:	83 c4 2c             	add    $0x2c,%esp
  800c98:	5b                   	pop    %ebx
  800c99:	5e                   	pop    %esi
  800c9a:	5f                   	pop    %edi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    

00800c9d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
  800ca3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cab:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb6:	89 df                	mov    %ebx,%edi
  800cb8:	89 de                	mov    %ebx,%esi
  800cba:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cbc:	85 c0                	test   %eax,%eax
  800cbe:	7e 28                	jle    800ce8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cc4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ccb:	00 
  800ccc:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800cd3:	00 
  800cd4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cdb:	00 
  800cdc:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800ce3:	e8 1e 15 00 00       	call   802206 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ce8:	83 c4 2c             	add    $0x2c,%esp
  800ceb:	5b                   	pop    %ebx
  800cec:	5e                   	pop    %esi
  800ced:	5f                   	pop    %edi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	57                   	push   %edi
  800cf4:	56                   	push   %esi
  800cf5:	53                   	push   %ebx
  800cf6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfe:	b8 09 00 00 00       	mov    $0x9,%eax
  800d03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d06:	8b 55 08             	mov    0x8(%ebp),%edx
  800d09:	89 df                	mov    %ebx,%edi
  800d0b:	89 de                	mov    %ebx,%esi
  800d0d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d0f:	85 c0                	test   %eax,%eax
  800d11:	7e 28                	jle    800d3b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d13:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d17:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d1e:	00 
  800d1f:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800d26:	00 
  800d27:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d2e:	00 
  800d2f:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800d36:	e8 cb 14 00 00       	call   802206 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d3b:	83 c4 2c             	add    $0x2c,%esp
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d51:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d59:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5c:	89 df                	mov    %ebx,%edi
  800d5e:	89 de                	mov    %ebx,%esi
  800d60:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d62:	85 c0                	test   %eax,%eax
  800d64:	7e 28                	jle    800d8e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d66:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d6a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800d71:	00 
  800d72:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800d79:	00 
  800d7a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d81:	00 
  800d82:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800d89:	e8 78 14 00 00       	call   802206 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d8e:	83 c4 2c             	add    $0x2c,%esp
  800d91:	5b                   	pop    %ebx
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	57                   	push   %edi
  800d9a:	56                   	push   %esi
  800d9b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9c:	be 00 00 00 00       	mov    $0x0,%esi
  800da1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800da6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800daf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800db2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800db4:	5b                   	pop    %ebx
  800db5:	5e                   	pop    %esi
  800db6:	5f                   	pop    %edi
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    

00800db9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	57                   	push   %edi
  800dbd:	56                   	push   %esi
  800dbe:	53                   	push   %ebx
  800dbf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcf:	89 cb                	mov    %ecx,%ebx
  800dd1:	89 cf                	mov    %ecx,%edi
  800dd3:	89 ce                	mov    %ecx,%esi
  800dd5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800dd7:	85 c0                	test   %eax,%eax
  800dd9:	7e 28                	jle    800e03 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ddf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800de6:	00 
  800de7:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800dee:	00 
  800def:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df6:	00 
  800df7:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800dfe:	e8 03 14 00 00       	call   802206 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e03:	83 c4 2c             	add    $0x2c,%esp
  800e06:	5b                   	pop    %ebx
  800e07:	5e                   	pop    %esi
  800e08:	5f                   	pop    %edi
  800e09:	5d                   	pop    %ebp
  800e0a:	c3                   	ret    

00800e0b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	57                   	push   %edi
  800e0f:	56                   	push   %esi
  800e10:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e11:	ba 00 00 00 00       	mov    $0x0,%edx
  800e16:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e1b:	89 d1                	mov    %edx,%ecx
  800e1d:	89 d3                	mov    %edx,%ebx
  800e1f:	89 d7                	mov    %edx,%edi
  800e21:	89 d6                	mov    %edx,%esi
  800e23:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e25:	5b                   	pop    %ebx
  800e26:	5e                   	pop    %esi
  800e27:	5f                   	pop    %edi
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	57                   	push   %edi
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e30:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e35:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e40:	89 df                	mov    %ebx,%edi
  800e42:	89 de                	mov    %ebx,%esi
  800e44:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800e46:	5b                   	pop    %ebx
  800e47:	5e                   	pop    %esi
  800e48:	5f                   	pop    %edi
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	57                   	push   %edi
  800e4f:	56                   	push   %esi
  800e50:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e51:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e56:	b8 10 00 00 00       	mov    $0x10,%eax
  800e5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e61:	89 df                	mov    %ebx,%edi
  800e63:	89 de                	mov    %ebx,%esi
  800e65:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800e67:	5b                   	pop    %ebx
  800e68:	5e                   	pop    %esi
  800e69:	5f                   	pop    %edi
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    

00800e6c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	57                   	push   %edi
  800e70:	56                   	push   %esi
  800e71:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e77:	b8 11 00 00 00       	mov    $0x11,%eax
  800e7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7f:	89 cb                	mov    %ecx,%ebx
  800e81:	89 cf                	mov    %ecx,%edi
  800e83:	89 ce                	mov    %ecx,%esi
  800e85:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800e87:	5b                   	pop    %ebx
  800e88:	5e                   	pop    %esi
  800e89:	5f                   	pop    %edi
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    

00800e8c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	57                   	push   %edi
  800e90:	56                   	push   %esi
  800e91:	53                   	push   %ebx
  800e92:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e95:	be 00 00 00 00       	mov    $0x0,%esi
  800e9a:	b8 12 00 00 00       	mov    $0x12,%eax
  800e9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ea8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eab:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	7e 28                	jle    800ed9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eb5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800ebc:	00 
  800ebd:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800ec4:	00 
  800ec5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ecc:	00 
  800ecd:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800ed4:	e8 2d 13 00 00       	call   802206 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  800ed9:	83 c4 2c             	add    $0x2c,%esp
  800edc:	5b                   	pop    %ebx
  800edd:	5e                   	pop    %esi
  800ede:	5f                   	pop    %edi
  800edf:	5d                   	pop    %ebp
  800ee0:	c3                   	ret    
  800ee1:	66 90                	xchg   %ax,%ax
  800ee3:	66 90                	xchg   %ax,%ax
  800ee5:	66 90                	xchg   %ax,%ax
  800ee7:	66 90                	xchg   %ax,%ax
  800ee9:	66 90                	xchg   %ax,%ax
  800eeb:	66 90                	xchg   %ax,%ax
  800eed:	66 90                	xchg   %ax,%ax
  800eef:	90                   	nop

00800ef0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	05 00 00 00 30       	add    $0x30000000,%eax
  800efb:	c1 e8 0c             	shr    $0xc,%eax
}
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    

00800f00 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800f0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f10:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    

00800f17 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f17:	55                   	push   %ebp
  800f18:	89 e5                	mov    %esp,%ebp
  800f1a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f1d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f22:	89 c2                	mov    %eax,%edx
  800f24:	c1 ea 16             	shr    $0x16,%edx
  800f27:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f2e:	f6 c2 01             	test   $0x1,%dl
  800f31:	74 11                	je     800f44 <fd_alloc+0x2d>
  800f33:	89 c2                	mov    %eax,%edx
  800f35:	c1 ea 0c             	shr    $0xc,%edx
  800f38:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f3f:	f6 c2 01             	test   $0x1,%dl
  800f42:	75 09                	jne    800f4d <fd_alloc+0x36>
			*fd_store = fd;
  800f44:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f46:	b8 00 00 00 00       	mov    $0x0,%eax
  800f4b:	eb 17                	jmp    800f64 <fd_alloc+0x4d>
  800f4d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f52:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f57:	75 c9                	jne    800f22 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f59:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f5f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800f64:	5d                   	pop    %ebp
  800f65:	c3                   	ret    

00800f66 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f6c:	83 f8 1f             	cmp    $0x1f,%eax
  800f6f:	77 36                	ja     800fa7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f71:	c1 e0 0c             	shl    $0xc,%eax
  800f74:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f79:	89 c2                	mov    %eax,%edx
  800f7b:	c1 ea 16             	shr    $0x16,%edx
  800f7e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f85:	f6 c2 01             	test   $0x1,%dl
  800f88:	74 24                	je     800fae <fd_lookup+0x48>
  800f8a:	89 c2                	mov    %eax,%edx
  800f8c:	c1 ea 0c             	shr    $0xc,%edx
  800f8f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f96:	f6 c2 01             	test   $0x1,%dl
  800f99:	74 1a                	je     800fb5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f9e:	89 02                	mov    %eax,(%edx)
	return 0;
  800fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa5:	eb 13                	jmp    800fba <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800fa7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fac:	eb 0c                	jmp    800fba <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800fae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fb3:	eb 05                	jmp    800fba <fd_lookup+0x54>
  800fb5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    

00800fbc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 18             	sub    $0x18,%esp
  800fc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800fc5:	ba 00 00 00 00       	mov    $0x0,%edx
  800fca:	eb 13                	jmp    800fdf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  800fcc:	39 08                	cmp    %ecx,(%eax)
  800fce:	75 0c                	jne    800fdc <dev_lookup+0x20>
			*dev = devtab[i];
  800fd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd3:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fda:	eb 38                	jmp    801014 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800fdc:	83 c2 01             	add    $0x1,%edx
  800fdf:	8b 04 95 50 2a 80 00 	mov    0x802a50(,%edx,4),%eax
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	75 e2                	jne    800fcc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fea:	a1 08 40 80 00       	mov    0x804008,%eax
  800fef:	8b 40 48             	mov    0x48(%eax),%eax
  800ff2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ff6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ffa:	c7 04 24 d4 29 80 00 	movl   $0x8029d4,(%esp)
  801001:	e8 5d f1 ff ff       	call   800163 <cprintf>
	*dev = 0;
  801006:	8b 45 0c             	mov    0xc(%ebp),%eax
  801009:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80100f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	56                   	push   %esi
  80101a:	53                   	push   %ebx
  80101b:	83 ec 20             	sub    $0x20,%esp
  80101e:	8b 75 08             	mov    0x8(%ebp),%esi
  801021:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801024:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801027:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80102b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801031:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801034:	89 04 24             	mov    %eax,(%esp)
  801037:	e8 2a ff ff ff       	call   800f66 <fd_lookup>
  80103c:	85 c0                	test   %eax,%eax
  80103e:	78 05                	js     801045 <fd_close+0x2f>
	    || fd != fd2)
  801040:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801043:	74 0c                	je     801051 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801045:	84 db                	test   %bl,%bl
  801047:	ba 00 00 00 00       	mov    $0x0,%edx
  80104c:	0f 44 c2             	cmove  %edx,%eax
  80104f:	eb 3f                	jmp    801090 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801051:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801054:	89 44 24 04          	mov    %eax,0x4(%esp)
  801058:	8b 06                	mov    (%esi),%eax
  80105a:	89 04 24             	mov    %eax,(%esp)
  80105d:	e8 5a ff ff ff       	call   800fbc <dev_lookup>
  801062:	89 c3                	mov    %eax,%ebx
  801064:	85 c0                	test   %eax,%eax
  801066:	78 16                	js     80107e <fd_close+0x68>
		if (dev->dev_close)
  801068:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80106e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801073:	85 c0                	test   %eax,%eax
  801075:	74 07                	je     80107e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801077:	89 34 24             	mov    %esi,(%esp)
  80107a:	ff d0                	call   *%eax
  80107c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80107e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801082:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801089:	e8 bc fb ff ff       	call   800c4a <sys_page_unmap>
	return r;
  80108e:	89 d8                	mov    %ebx,%eax
}
  801090:	83 c4 20             	add    $0x20,%esp
  801093:	5b                   	pop    %ebx
  801094:	5e                   	pop    %esi
  801095:	5d                   	pop    %ebp
  801096:	c3                   	ret    

00801097 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80109d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	89 04 24             	mov    %eax,(%esp)
  8010aa:	e8 b7 fe ff ff       	call   800f66 <fd_lookup>
  8010af:	89 c2                	mov    %eax,%edx
  8010b1:	85 d2                	test   %edx,%edx
  8010b3:	78 13                	js     8010c8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8010b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8010bc:	00 
  8010bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c0:	89 04 24             	mov    %eax,(%esp)
  8010c3:	e8 4e ff ff ff       	call   801016 <fd_close>
}
  8010c8:	c9                   	leave  
  8010c9:	c3                   	ret    

008010ca <close_all>:

void
close_all(void)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	53                   	push   %ebx
  8010ce:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010d6:	89 1c 24             	mov    %ebx,(%esp)
  8010d9:	e8 b9 ff ff ff       	call   801097 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8010de:	83 c3 01             	add    $0x1,%ebx
  8010e1:	83 fb 20             	cmp    $0x20,%ebx
  8010e4:	75 f0                	jne    8010d6 <close_all+0xc>
		close(i);
}
  8010e6:	83 c4 14             	add    $0x14,%esp
  8010e9:	5b                   	pop    %ebx
  8010ea:	5d                   	pop    %ebp
  8010eb:	c3                   	ret    

008010ec <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
  8010ef:	57                   	push   %edi
  8010f0:	56                   	push   %esi
  8010f1:	53                   	push   %ebx
  8010f2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ff:	89 04 24             	mov    %eax,(%esp)
  801102:	e8 5f fe ff ff       	call   800f66 <fd_lookup>
  801107:	89 c2                	mov    %eax,%edx
  801109:	85 d2                	test   %edx,%edx
  80110b:	0f 88 e1 00 00 00    	js     8011f2 <dup+0x106>
		return r;
	close(newfdnum);
  801111:	8b 45 0c             	mov    0xc(%ebp),%eax
  801114:	89 04 24             	mov    %eax,(%esp)
  801117:	e8 7b ff ff ff       	call   801097 <close>

	newfd = INDEX2FD(newfdnum);
  80111c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80111f:	c1 e3 0c             	shl    $0xc,%ebx
  801122:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80112b:	89 04 24             	mov    %eax,(%esp)
  80112e:	e8 cd fd ff ff       	call   800f00 <fd2data>
  801133:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801135:	89 1c 24             	mov    %ebx,(%esp)
  801138:	e8 c3 fd ff ff       	call   800f00 <fd2data>
  80113d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80113f:	89 f0                	mov    %esi,%eax
  801141:	c1 e8 16             	shr    $0x16,%eax
  801144:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80114b:	a8 01                	test   $0x1,%al
  80114d:	74 43                	je     801192 <dup+0xa6>
  80114f:	89 f0                	mov    %esi,%eax
  801151:	c1 e8 0c             	shr    $0xc,%eax
  801154:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80115b:	f6 c2 01             	test   $0x1,%dl
  80115e:	74 32                	je     801192 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801160:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801167:	25 07 0e 00 00       	and    $0xe07,%eax
  80116c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801170:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801174:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80117b:	00 
  80117c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801180:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801187:	e8 6b fa ff ff       	call   800bf7 <sys_page_map>
  80118c:	89 c6                	mov    %eax,%esi
  80118e:	85 c0                	test   %eax,%eax
  801190:	78 3e                	js     8011d0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801195:	89 c2                	mov    %eax,%edx
  801197:	c1 ea 0c             	shr    $0xc,%edx
  80119a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011a1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8011a7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8011ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011b6:	00 
  8011b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011c2:	e8 30 fa ff ff       	call   800bf7 <sys_page_map>
  8011c7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8011c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011cc:	85 f6                	test   %esi,%esi
  8011ce:	79 22                	jns    8011f2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8011d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011db:	e8 6a fa ff ff       	call   800c4a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011eb:	e8 5a fa ff ff       	call   800c4a <sys_page_unmap>
	return r;
  8011f0:	89 f0                	mov    %esi,%eax
}
  8011f2:	83 c4 3c             	add    $0x3c,%esp
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5f                   	pop    %edi
  8011f8:	5d                   	pop    %ebp
  8011f9:	c3                   	ret    

008011fa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	53                   	push   %ebx
  8011fe:	83 ec 24             	sub    $0x24,%esp
  801201:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801204:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801207:	89 44 24 04          	mov    %eax,0x4(%esp)
  80120b:	89 1c 24             	mov    %ebx,(%esp)
  80120e:	e8 53 fd ff ff       	call   800f66 <fd_lookup>
  801213:	89 c2                	mov    %eax,%edx
  801215:	85 d2                	test   %edx,%edx
  801217:	78 6d                	js     801286 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801219:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80121c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801220:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801223:	8b 00                	mov    (%eax),%eax
  801225:	89 04 24             	mov    %eax,(%esp)
  801228:	e8 8f fd ff ff       	call   800fbc <dev_lookup>
  80122d:	85 c0                	test   %eax,%eax
  80122f:	78 55                	js     801286 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801231:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801234:	8b 50 08             	mov    0x8(%eax),%edx
  801237:	83 e2 03             	and    $0x3,%edx
  80123a:	83 fa 01             	cmp    $0x1,%edx
  80123d:	75 23                	jne    801262 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80123f:	a1 08 40 80 00       	mov    0x804008,%eax
  801244:	8b 40 48             	mov    0x48(%eax),%eax
  801247:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80124b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80124f:	c7 04 24 15 2a 80 00 	movl   $0x802a15,(%esp)
  801256:	e8 08 ef ff ff       	call   800163 <cprintf>
		return -E_INVAL;
  80125b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801260:	eb 24                	jmp    801286 <read+0x8c>
	}
	if (!dev->dev_read)
  801262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801265:	8b 52 08             	mov    0x8(%edx),%edx
  801268:	85 d2                	test   %edx,%edx
  80126a:	74 15                	je     801281 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80126c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80126f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801273:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801276:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80127a:	89 04 24             	mov    %eax,(%esp)
  80127d:	ff d2                	call   *%edx
  80127f:	eb 05                	jmp    801286 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801281:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801286:	83 c4 24             	add    $0x24,%esp
  801289:	5b                   	pop    %ebx
  80128a:	5d                   	pop    %ebp
  80128b:	c3                   	ret    

0080128c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	57                   	push   %edi
  801290:	56                   	push   %esi
  801291:	53                   	push   %ebx
  801292:	83 ec 1c             	sub    $0x1c,%esp
  801295:	8b 7d 08             	mov    0x8(%ebp),%edi
  801298:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80129b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012a0:	eb 23                	jmp    8012c5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012a2:	89 f0                	mov    %esi,%eax
  8012a4:	29 d8                	sub    %ebx,%eax
  8012a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012aa:	89 d8                	mov    %ebx,%eax
  8012ac:	03 45 0c             	add    0xc(%ebp),%eax
  8012af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012b3:	89 3c 24             	mov    %edi,(%esp)
  8012b6:	e8 3f ff ff ff       	call   8011fa <read>
		if (m < 0)
  8012bb:	85 c0                	test   %eax,%eax
  8012bd:	78 10                	js     8012cf <readn+0x43>
			return m;
		if (m == 0)
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	74 0a                	je     8012cd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012c3:	01 c3                	add    %eax,%ebx
  8012c5:	39 f3                	cmp    %esi,%ebx
  8012c7:	72 d9                	jb     8012a2 <readn+0x16>
  8012c9:	89 d8                	mov    %ebx,%eax
  8012cb:	eb 02                	jmp    8012cf <readn+0x43>
  8012cd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8012cf:	83 c4 1c             	add    $0x1c,%esp
  8012d2:	5b                   	pop    %ebx
  8012d3:	5e                   	pop    %esi
  8012d4:	5f                   	pop    %edi
  8012d5:	5d                   	pop    %ebp
  8012d6:	c3                   	ret    

008012d7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	53                   	push   %ebx
  8012db:	83 ec 24             	sub    $0x24,%esp
  8012de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e8:	89 1c 24             	mov    %ebx,(%esp)
  8012eb:	e8 76 fc ff ff       	call   800f66 <fd_lookup>
  8012f0:	89 c2                	mov    %eax,%edx
  8012f2:	85 d2                	test   %edx,%edx
  8012f4:	78 68                	js     80135e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801300:	8b 00                	mov    (%eax),%eax
  801302:	89 04 24             	mov    %eax,(%esp)
  801305:	e8 b2 fc ff ff       	call   800fbc <dev_lookup>
  80130a:	85 c0                	test   %eax,%eax
  80130c:	78 50                	js     80135e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80130e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801311:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801315:	75 23                	jne    80133a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801317:	a1 08 40 80 00       	mov    0x804008,%eax
  80131c:	8b 40 48             	mov    0x48(%eax),%eax
  80131f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801323:	89 44 24 04          	mov    %eax,0x4(%esp)
  801327:	c7 04 24 31 2a 80 00 	movl   $0x802a31,(%esp)
  80132e:	e8 30 ee ff ff       	call   800163 <cprintf>
		return -E_INVAL;
  801333:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801338:	eb 24                	jmp    80135e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80133a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80133d:	8b 52 0c             	mov    0xc(%edx),%edx
  801340:	85 d2                	test   %edx,%edx
  801342:	74 15                	je     801359 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801344:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801347:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80134b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80134e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801352:	89 04 24             	mov    %eax,(%esp)
  801355:	ff d2                	call   *%edx
  801357:	eb 05                	jmp    80135e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801359:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80135e:	83 c4 24             	add    $0x24,%esp
  801361:	5b                   	pop    %ebx
  801362:	5d                   	pop    %ebp
  801363:	c3                   	ret    

00801364 <seek>:

int
seek(int fdnum, off_t offset)
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80136a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80136d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801371:	8b 45 08             	mov    0x8(%ebp),%eax
  801374:	89 04 24             	mov    %eax,(%esp)
  801377:	e8 ea fb ff ff       	call   800f66 <fd_lookup>
  80137c:	85 c0                	test   %eax,%eax
  80137e:	78 0e                	js     80138e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801380:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801383:	8b 55 0c             	mov    0xc(%ebp),%edx
  801386:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801389:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    

00801390 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	53                   	push   %ebx
  801394:	83 ec 24             	sub    $0x24,%esp
  801397:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80139a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a1:	89 1c 24             	mov    %ebx,(%esp)
  8013a4:	e8 bd fb ff ff       	call   800f66 <fd_lookup>
  8013a9:	89 c2                	mov    %eax,%edx
  8013ab:	85 d2                	test   %edx,%edx
  8013ad:	78 61                	js     801410 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b9:	8b 00                	mov    (%eax),%eax
  8013bb:	89 04 24             	mov    %eax,(%esp)
  8013be:	e8 f9 fb ff ff       	call   800fbc <dev_lookup>
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	78 49                	js     801410 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013ce:	75 23                	jne    8013f3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8013d0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013d5:	8b 40 48             	mov    0x48(%eax),%eax
  8013d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e0:	c7 04 24 f4 29 80 00 	movl   $0x8029f4,(%esp)
  8013e7:	e8 77 ed ff ff       	call   800163 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8013ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f1:	eb 1d                	jmp    801410 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8013f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f6:	8b 52 18             	mov    0x18(%edx),%edx
  8013f9:	85 d2                	test   %edx,%edx
  8013fb:	74 0e                	je     80140b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801400:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801404:	89 04 24             	mov    %eax,(%esp)
  801407:	ff d2                	call   *%edx
  801409:	eb 05                	jmp    801410 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80140b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801410:	83 c4 24             	add    $0x24,%esp
  801413:	5b                   	pop    %ebx
  801414:	5d                   	pop    %ebp
  801415:	c3                   	ret    

00801416 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	53                   	push   %ebx
  80141a:	83 ec 24             	sub    $0x24,%esp
  80141d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801420:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801423:	89 44 24 04          	mov    %eax,0x4(%esp)
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	89 04 24             	mov    %eax,(%esp)
  80142d:	e8 34 fb ff ff       	call   800f66 <fd_lookup>
  801432:	89 c2                	mov    %eax,%edx
  801434:	85 d2                	test   %edx,%edx
  801436:	78 52                	js     80148a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801438:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80143f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801442:	8b 00                	mov    (%eax),%eax
  801444:	89 04 24             	mov    %eax,(%esp)
  801447:	e8 70 fb ff ff       	call   800fbc <dev_lookup>
  80144c:	85 c0                	test   %eax,%eax
  80144e:	78 3a                	js     80148a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801453:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801457:	74 2c                	je     801485 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801459:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80145c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801463:	00 00 00 
	stat->st_isdir = 0;
  801466:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80146d:	00 00 00 
	stat->st_dev = dev;
  801470:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801476:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80147a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80147d:	89 14 24             	mov    %edx,(%esp)
  801480:	ff 50 14             	call   *0x14(%eax)
  801483:	eb 05                	jmp    80148a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801485:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80148a:	83 c4 24             	add    $0x24,%esp
  80148d:	5b                   	pop    %ebx
  80148e:	5d                   	pop    %ebp
  80148f:	c3                   	ret    

00801490 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	56                   	push   %esi
  801494:	53                   	push   %ebx
  801495:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801498:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80149f:	00 
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	89 04 24             	mov    %eax,(%esp)
  8014a6:	e8 84 02 00 00       	call   80172f <open>
  8014ab:	89 c3                	mov    %eax,%ebx
  8014ad:	85 db                	test   %ebx,%ebx
  8014af:	78 1b                	js     8014cc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8014b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b8:	89 1c 24             	mov    %ebx,(%esp)
  8014bb:	e8 56 ff ff ff       	call   801416 <fstat>
  8014c0:	89 c6                	mov    %eax,%esi
	close(fd);
  8014c2:	89 1c 24             	mov    %ebx,(%esp)
  8014c5:	e8 cd fb ff ff       	call   801097 <close>
	return r;
  8014ca:	89 f0                	mov    %esi,%eax
}
  8014cc:	83 c4 10             	add    $0x10,%esp
  8014cf:	5b                   	pop    %ebx
  8014d0:	5e                   	pop    %esi
  8014d1:	5d                   	pop    %ebp
  8014d2:	c3                   	ret    

008014d3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
  8014d6:	56                   	push   %esi
  8014d7:	53                   	push   %ebx
  8014d8:	83 ec 10             	sub    $0x10,%esp
  8014db:	89 c6                	mov    %eax,%esi
  8014dd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014df:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014e6:	75 11                	jne    8014f9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8014ef:	e8 61 0e 00 00       	call   802355 <ipc_find_env>
  8014f4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014f9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801500:	00 
  801501:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801508:	00 
  801509:	89 74 24 04          	mov    %esi,0x4(%esp)
  80150d:	a1 00 40 80 00       	mov    0x804000,%eax
  801512:	89 04 24             	mov    %eax,(%esp)
  801515:	e8 ae 0d 00 00       	call   8022c8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80151a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801521:	00 
  801522:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801526:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80152d:	e8 2e 0d 00 00       	call   802260 <ipc_recv>
}
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	5b                   	pop    %ebx
  801536:	5e                   	pop    %esi
  801537:	5d                   	pop    %ebp
  801538:	c3                   	ret    

00801539 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	8b 40 0c             	mov    0xc(%eax),%eax
  801545:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80154a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801552:	ba 00 00 00 00       	mov    $0x0,%edx
  801557:	b8 02 00 00 00       	mov    $0x2,%eax
  80155c:	e8 72 ff ff ff       	call   8014d3 <fsipc>
}
  801561:	c9                   	leave  
  801562:	c3                   	ret    

00801563 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
  80156c:	8b 40 0c             	mov    0xc(%eax),%eax
  80156f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801574:	ba 00 00 00 00       	mov    $0x0,%edx
  801579:	b8 06 00 00 00       	mov    $0x6,%eax
  80157e:	e8 50 ff ff ff       	call   8014d3 <fsipc>
}
  801583:	c9                   	leave  
  801584:	c3                   	ret    

00801585 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	53                   	push   %ebx
  801589:	83 ec 14             	sub    $0x14,%esp
  80158c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8b 40 0c             	mov    0xc(%eax),%eax
  801595:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80159a:	ba 00 00 00 00       	mov    $0x0,%edx
  80159f:	b8 05 00 00 00       	mov    $0x5,%eax
  8015a4:	e8 2a ff ff ff       	call   8014d3 <fsipc>
  8015a9:	89 c2                	mov    %eax,%edx
  8015ab:	85 d2                	test   %edx,%edx
  8015ad:	78 2b                	js     8015da <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015af:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8015b6:	00 
  8015b7:	89 1c 24             	mov    %ebx,(%esp)
  8015ba:	e8 c8 f1 ff ff       	call   800787 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015bf:	a1 80 50 80 00       	mov    0x805080,%eax
  8015c4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015ca:	a1 84 50 80 00       	mov    0x805084,%eax
  8015cf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015da:	83 c4 14             	add    $0x14,%esp
  8015dd:	5b                   	pop    %ebx
  8015de:	5d                   	pop    %ebp
  8015df:	c3                   	ret    

008015e0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	53                   	push   %ebx
  8015e4:	83 ec 14             	sub    $0x14,%esp
  8015e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  8015f5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8015fb:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801600:	0f 46 c3             	cmovbe %ebx,%eax
  801603:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801608:	89 44 24 08          	mov    %eax,0x8(%esp)
  80160c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801613:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80161a:	e8 05 f3 ff ff       	call   800924 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80161f:	ba 00 00 00 00       	mov    $0x0,%edx
  801624:	b8 04 00 00 00       	mov    $0x4,%eax
  801629:	e8 a5 fe ff ff       	call   8014d3 <fsipc>
  80162e:	85 c0                	test   %eax,%eax
  801630:	78 53                	js     801685 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801632:	39 c3                	cmp    %eax,%ebx
  801634:	73 24                	jae    80165a <devfile_write+0x7a>
  801636:	c7 44 24 0c 64 2a 80 	movl   $0x802a64,0xc(%esp)
  80163d:	00 
  80163e:	c7 44 24 08 6b 2a 80 	movl   $0x802a6b,0x8(%esp)
  801645:	00 
  801646:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  80164d:	00 
  80164e:	c7 04 24 80 2a 80 00 	movl   $0x802a80,(%esp)
  801655:	e8 ac 0b 00 00       	call   802206 <_panic>
	assert(r <= PGSIZE);
  80165a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80165f:	7e 24                	jle    801685 <devfile_write+0xa5>
  801661:	c7 44 24 0c 8b 2a 80 	movl   $0x802a8b,0xc(%esp)
  801668:	00 
  801669:	c7 44 24 08 6b 2a 80 	movl   $0x802a6b,0x8(%esp)
  801670:	00 
  801671:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801678:	00 
  801679:	c7 04 24 80 2a 80 00 	movl   $0x802a80,(%esp)
  801680:	e8 81 0b 00 00       	call   802206 <_panic>
	return r;
}
  801685:	83 c4 14             	add    $0x14,%esp
  801688:	5b                   	pop    %ebx
  801689:	5d                   	pop    %ebp
  80168a:	c3                   	ret    

0080168b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	56                   	push   %esi
  80168f:	53                   	push   %ebx
  801690:	83 ec 10             	sub    $0x10,%esp
  801693:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	8b 40 0c             	mov    0xc(%eax),%eax
  80169c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016a1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ac:	b8 03 00 00 00       	mov    $0x3,%eax
  8016b1:	e8 1d fe ff ff       	call   8014d3 <fsipc>
  8016b6:	89 c3                	mov    %eax,%ebx
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	78 6a                	js     801726 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8016bc:	39 c6                	cmp    %eax,%esi
  8016be:	73 24                	jae    8016e4 <devfile_read+0x59>
  8016c0:	c7 44 24 0c 64 2a 80 	movl   $0x802a64,0xc(%esp)
  8016c7:	00 
  8016c8:	c7 44 24 08 6b 2a 80 	movl   $0x802a6b,0x8(%esp)
  8016cf:	00 
  8016d0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8016d7:	00 
  8016d8:	c7 04 24 80 2a 80 00 	movl   $0x802a80,(%esp)
  8016df:	e8 22 0b 00 00       	call   802206 <_panic>
	assert(r <= PGSIZE);
  8016e4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016e9:	7e 24                	jle    80170f <devfile_read+0x84>
  8016eb:	c7 44 24 0c 8b 2a 80 	movl   $0x802a8b,0xc(%esp)
  8016f2:	00 
  8016f3:	c7 44 24 08 6b 2a 80 	movl   $0x802a6b,0x8(%esp)
  8016fa:	00 
  8016fb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801702:	00 
  801703:	c7 04 24 80 2a 80 00 	movl   $0x802a80,(%esp)
  80170a:	e8 f7 0a 00 00       	call   802206 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80170f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801713:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80171a:	00 
  80171b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171e:	89 04 24             	mov    %eax,(%esp)
  801721:	e8 fe f1 ff ff       	call   800924 <memmove>
	return r;
}
  801726:	89 d8                	mov    %ebx,%eax
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	5b                   	pop    %ebx
  80172c:	5e                   	pop    %esi
  80172d:	5d                   	pop    %ebp
  80172e:	c3                   	ret    

0080172f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	53                   	push   %ebx
  801733:	83 ec 24             	sub    $0x24,%esp
  801736:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801739:	89 1c 24             	mov    %ebx,(%esp)
  80173c:	e8 0f f0 ff ff       	call   800750 <strlen>
  801741:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801746:	7f 60                	jg     8017a8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801748:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174b:	89 04 24             	mov    %eax,(%esp)
  80174e:	e8 c4 f7 ff ff       	call   800f17 <fd_alloc>
  801753:	89 c2                	mov    %eax,%edx
  801755:	85 d2                	test   %edx,%edx
  801757:	78 54                	js     8017ad <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801759:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80175d:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801764:	e8 1e f0 ff ff       	call   800787 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801769:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176c:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801771:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801774:	b8 01 00 00 00       	mov    $0x1,%eax
  801779:	e8 55 fd ff ff       	call   8014d3 <fsipc>
  80177e:	89 c3                	mov    %eax,%ebx
  801780:	85 c0                	test   %eax,%eax
  801782:	79 17                	jns    80179b <open+0x6c>
		fd_close(fd, 0);
  801784:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80178b:	00 
  80178c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178f:	89 04 24             	mov    %eax,(%esp)
  801792:	e8 7f f8 ff ff       	call   801016 <fd_close>
		return r;
  801797:	89 d8                	mov    %ebx,%eax
  801799:	eb 12                	jmp    8017ad <open+0x7e>
	}

	return fd2num(fd);
  80179b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179e:	89 04 24             	mov    %eax,(%esp)
  8017a1:	e8 4a f7 ff ff       	call   800ef0 <fd2num>
  8017a6:	eb 05                	jmp    8017ad <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8017a8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8017ad:	83 c4 24             	add    $0x24,%esp
  8017b0:	5b                   	pop    %ebx
  8017b1:	5d                   	pop    %ebp
  8017b2:	c3                   	ret    

008017b3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017be:	b8 08 00 00 00       	mov    $0x8,%eax
  8017c3:	e8 0b fd ff ff       	call   8014d3 <fsipc>
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    
  8017ca:	66 90                	xchg   %ax,%ax
  8017cc:	66 90                	xchg   %ax,%ax
  8017ce:	66 90                	xchg   %ax,%ax

008017d0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8017d6:	c7 44 24 04 97 2a 80 	movl   $0x802a97,0x4(%esp)
  8017dd:	00 
  8017de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e1:	89 04 24             	mov    %eax,(%esp)
  8017e4:	e8 9e ef ff ff       	call   800787 <strcpy>
	return 0;
}
  8017e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ee:	c9                   	leave  
  8017ef:	c3                   	ret    

008017f0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	53                   	push   %ebx
  8017f4:	83 ec 14             	sub    $0x14,%esp
  8017f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017fa:	89 1c 24             	mov    %ebx,(%esp)
  8017fd:	e8 8d 0b 00 00       	call   80238f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801802:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801807:	83 f8 01             	cmp    $0x1,%eax
  80180a:	75 0d                	jne    801819 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80180c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80180f:	89 04 24             	mov    %eax,(%esp)
  801812:	e8 29 03 00 00       	call   801b40 <nsipc_close>
  801817:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801819:	89 d0                	mov    %edx,%eax
  80181b:	83 c4 14             	add    $0x14,%esp
  80181e:	5b                   	pop    %ebx
  80181f:	5d                   	pop    %ebp
  801820:	c3                   	ret    

00801821 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801827:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80182e:	00 
  80182f:	8b 45 10             	mov    0x10(%ebp),%eax
  801832:	89 44 24 08          	mov    %eax,0x8(%esp)
  801836:	8b 45 0c             	mov    0xc(%ebp),%eax
  801839:	89 44 24 04          	mov    %eax,0x4(%esp)
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8b 40 0c             	mov    0xc(%eax),%eax
  801843:	89 04 24             	mov    %eax,(%esp)
  801846:	e8 f0 03 00 00       	call   801c3b <nsipc_send>
}
  80184b:	c9                   	leave  
  80184c:	c3                   	ret    

0080184d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801853:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80185a:	00 
  80185b:	8b 45 10             	mov    0x10(%ebp),%eax
  80185e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801862:	8b 45 0c             	mov    0xc(%ebp),%eax
  801865:	89 44 24 04          	mov    %eax,0x4(%esp)
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8b 40 0c             	mov    0xc(%eax),%eax
  80186f:	89 04 24             	mov    %eax,(%esp)
  801872:	e8 44 03 00 00       	call   801bbb <nsipc_recv>
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80187f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801882:	89 54 24 04          	mov    %edx,0x4(%esp)
  801886:	89 04 24             	mov    %eax,(%esp)
  801889:	e8 d8 f6 ff ff       	call   800f66 <fd_lookup>
  80188e:	85 c0                	test   %eax,%eax
  801890:	78 17                	js     8018a9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801895:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80189b:	39 08                	cmp    %ecx,(%eax)
  80189d:	75 05                	jne    8018a4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80189f:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a2:	eb 05                	jmp    8018a9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8018a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	56                   	push   %esi
  8018af:	53                   	push   %ebx
  8018b0:	83 ec 20             	sub    $0x20,%esp
  8018b3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8018b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b8:	89 04 24             	mov    %eax,(%esp)
  8018bb:	e8 57 f6 ff ff       	call   800f17 <fd_alloc>
  8018c0:	89 c3                	mov    %eax,%ebx
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	78 21                	js     8018e7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018c6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8018cd:	00 
  8018ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018dc:	e8 c2 f2 ff ff       	call   800ba3 <sys_page_alloc>
  8018e1:	89 c3                	mov    %eax,%ebx
  8018e3:	85 c0                	test   %eax,%eax
  8018e5:	79 0c                	jns    8018f3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8018e7:	89 34 24             	mov    %esi,(%esp)
  8018ea:	e8 51 02 00 00       	call   801b40 <nsipc_close>
		return r;
  8018ef:	89 d8                	mov    %ebx,%eax
  8018f1:	eb 20                	jmp    801913 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8018f3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801901:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801908:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80190b:	89 14 24             	mov    %edx,(%esp)
  80190e:	e8 dd f5 ff ff       	call   800ef0 <fd2num>
}
  801913:	83 c4 20             	add    $0x20,%esp
  801916:	5b                   	pop    %ebx
  801917:	5e                   	pop    %esi
  801918:	5d                   	pop    %ebp
  801919:	c3                   	ret    

0080191a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	e8 51 ff ff ff       	call   801879 <fd2sockid>
		return r;
  801928:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80192a:	85 c0                	test   %eax,%eax
  80192c:	78 23                	js     801951 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80192e:	8b 55 10             	mov    0x10(%ebp),%edx
  801931:	89 54 24 08          	mov    %edx,0x8(%esp)
  801935:	8b 55 0c             	mov    0xc(%ebp),%edx
  801938:	89 54 24 04          	mov    %edx,0x4(%esp)
  80193c:	89 04 24             	mov    %eax,(%esp)
  80193f:	e8 45 01 00 00       	call   801a89 <nsipc_accept>
		return r;
  801944:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801946:	85 c0                	test   %eax,%eax
  801948:	78 07                	js     801951 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80194a:	e8 5c ff ff ff       	call   8018ab <alloc_sockfd>
  80194f:	89 c1                	mov    %eax,%ecx
}
  801951:	89 c8                	mov    %ecx,%eax
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
  801958:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80195b:	8b 45 08             	mov    0x8(%ebp),%eax
  80195e:	e8 16 ff ff ff       	call   801879 <fd2sockid>
  801963:	89 c2                	mov    %eax,%edx
  801965:	85 d2                	test   %edx,%edx
  801967:	78 16                	js     80197f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801969:	8b 45 10             	mov    0x10(%ebp),%eax
  80196c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801970:	8b 45 0c             	mov    0xc(%ebp),%eax
  801973:	89 44 24 04          	mov    %eax,0x4(%esp)
  801977:	89 14 24             	mov    %edx,(%esp)
  80197a:	e8 60 01 00 00       	call   801adf <nsipc_bind>
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <shutdown>:

int
shutdown(int s, int how)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801987:	8b 45 08             	mov    0x8(%ebp),%eax
  80198a:	e8 ea fe ff ff       	call   801879 <fd2sockid>
  80198f:	89 c2                	mov    %eax,%edx
  801991:	85 d2                	test   %edx,%edx
  801993:	78 0f                	js     8019a4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801995:	8b 45 0c             	mov    0xc(%ebp),%eax
  801998:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199c:	89 14 24             	mov    %edx,(%esp)
  80199f:	e8 7a 01 00 00       	call   801b1e <nsipc_shutdown>
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	e8 c5 fe ff ff       	call   801879 <fd2sockid>
  8019b4:	89 c2                	mov    %eax,%edx
  8019b6:	85 d2                	test   %edx,%edx
  8019b8:	78 16                	js     8019d0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8019ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8019bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c8:	89 14 24             	mov    %edx,(%esp)
  8019cb:	e8 8a 01 00 00       	call   801b5a <nsipc_connect>
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <listen>:

int
listen(int s, int backlog)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
  8019d5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019db:	e8 99 fe ff ff       	call   801879 <fd2sockid>
  8019e0:	89 c2                	mov    %eax,%edx
  8019e2:	85 d2                	test   %edx,%edx
  8019e4:	78 0f                	js     8019f5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8019e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ed:	89 14 24             	mov    %edx,(%esp)
  8019f0:	e8 a4 01 00 00       	call   801b99 <nsipc_listen>
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801a00:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	89 04 24             	mov    %eax,(%esp)
  801a11:	e8 98 02 00 00       	call   801cae <nsipc_socket>
  801a16:	89 c2                	mov    %eax,%edx
  801a18:	85 d2                	test   %edx,%edx
  801a1a:	78 05                	js     801a21 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801a1c:	e8 8a fe ff ff       	call   8018ab <alloc_sockfd>
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	53                   	push   %ebx
  801a27:	83 ec 14             	sub    $0x14,%esp
  801a2a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a2c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a33:	75 11                	jne    801a46 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a35:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801a3c:	e8 14 09 00 00       	call   802355 <ipc_find_env>
  801a41:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a46:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a4d:	00 
  801a4e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a55:	00 
  801a56:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a5a:	a1 04 40 80 00       	mov    0x804004,%eax
  801a5f:	89 04 24             	mov    %eax,(%esp)
  801a62:	e8 61 08 00 00       	call   8022c8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a67:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a6e:	00 
  801a6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a76:	00 
  801a77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a7e:	e8 dd 07 00 00       	call   802260 <ipc_recv>
}
  801a83:	83 c4 14             	add    $0x14,%esp
  801a86:	5b                   	pop    %ebx
  801a87:	5d                   	pop    %ebp
  801a88:	c3                   	ret    

00801a89 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	56                   	push   %esi
  801a8d:	53                   	push   %ebx
  801a8e:	83 ec 10             	sub    $0x10,%esp
  801a91:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a9c:	8b 06                	mov    (%esi),%eax
  801a9e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801aa3:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa8:	e8 76 ff ff ff       	call   801a23 <nsipc>
  801aad:	89 c3                	mov    %eax,%ebx
  801aaf:	85 c0                	test   %eax,%eax
  801ab1:	78 23                	js     801ad6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ab3:	a1 10 60 80 00       	mov    0x806010,%eax
  801ab8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801abc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ac3:	00 
  801ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac7:	89 04 24             	mov    %eax,(%esp)
  801aca:	e8 55 ee ff ff       	call   800924 <memmove>
		*addrlen = ret->ret_addrlen;
  801acf:	a1 10 60 80 00       	mov    0x806010,%eax
  801ad4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801ad6:	89 d8                	mov    %ebx,%eax
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	5b                   	pop    %ebx
  801adc:	5e                   	pop    %esi
  801add:	5d                   	pop    %ebp
  801ade:	c3                   	ret    

00801adf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	53                   	push   %ebx
  801ae3:	83 ec 14             	sub    $0x14,%esp
  801ae6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801af1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801af5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afc:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801b03:	e8 1c ee ff ff       	call   800924 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b08:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b0e:	b8 02 00 00 00       	mov    $0x2,%eax
  801b13:	e8 0b ff ff ff       	call   801a23 <nsipc>
}
  801b18:	83 c4 14             	add    $0x14,%esp
  801b1b:	5b                   	pop    %ebx
  801b1c:	5d                   	pop    %ebp
  801b1d:	c3                   	ret    

00801b1e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b34:	b8 03 00 00 00       	mov    $0x3,%eax
  801b39:	e8 e5 fe ff ff       	call   801a23 <nsipc>
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <nsipc_close>:

int
nsipc_close(int s)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b4e:	b8 04 00 00 00       	mov    $0x4,%eax
  801b53:	e8 cb fe ff ff       	call   801a23 <nsipc>
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	53                   	push   %ebx
  801b5e:	83 ec 14             	sub    $0x14,%esp
  801b61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b6c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b77:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801b7e:	e8 a1 ed ff ff       	call   800924 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b83:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b89:	b8 05 00 00 00       	mov    $0x5,%eax
  801b8e:	e8 90 fe ff ff       	call   801a23 <nsipc>
}
  801b93:	83 c4 14             	add    $0x14,%esp
  801b96:	5b                   	pop    %ebx
  801b97:	5d                   	pop    %ebp
  801b98:	c3                   	ret    

00801b99 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801baa:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801baf:	b8 06 00 00 00       	mov    $0x6,%eax
  801bb4:	e8 6a fe ff ff       	call   801a23 <nsipc>
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
  801bbe:	56                   	push   %esi
  801bbf:	53                   	push   %ebx
  801bc0:	83 ec 10             	sub    $0x10,%esp
  801bc3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bce:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bd4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bdc:	b8 07 00 00 00       	mov    $0x7,%eax
  801be1:	e8 3d fe ff ff       	call   801a23 <nsipc>
  801be6:	89 c3                	mov    %eax,%ebx
  801be8:	85 c0                	test   %eax,%eax
  801bea:	78 46                	js     801c32 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801bec:	39 f0                	cmp    %esi,%eax
  801bee:	7f 07                	jg     801bf7 <nsipc_recv+0x3c>
  801bf0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bf5:	7e 24                	jle    801c1b <nsipc_recv+0x60>
  801bf7:	c7 44 24 0c a3 2a 80 	movl   $0x802aa3,0xc(%esp)
  801bfe:	00 
  801bff:	c7 44 24 08 6b 2a 80 	movl   $0x802a6b,0x8(%esp)
  801c06:	00 
  801c07:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801c0e:	00 
  801c0f:	c7 04 24 b8 2a 80 00 	movl   $0x802ab8,(%esp)
  801c16:	e8 eb 05 00 00       	call   802206 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c1b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c1f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c26:	00 
  801c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2a:	89 04 24             	mov    %eax,(%esp)
  801c2d:	e8 f2 ec ff ff       	call   800924 <memmove>
	}

	return r;
}
  801c32:	89 d8                	mov    %ebx,%eax
  801c34:	83 c4 10             	add    $0x10,%esp
  801c37:	5b                   	pop    %ebx
  801c38:	5e                   	pop    %esi
  801c39:	5d                   	pop    %ebp
  801c3a:	c3                   	ret    

00801c3b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	53                   	push   %ebx
  801c3f:	83 ec 14             	sub    $0x14,%esp
  801c42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c4d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c53:	7e 24                	jle    801c79 <nsipc_send+0x3e>
  801c55:	c7 44 24 0c c4 2a 80 	movl   $0x802ac4,0xc(%esp)
  801c5c:	00 
  801c5d:	c7 44 24 08 6b 2a 80 	movl   $0x802a6b,0x8(%esp)
  801c64:	00 
  801c65:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801c6c:	00 
  801c6d:	c7 04 24 b8 2a 80 00 	movl   $0x802ab8,(%esp)
  801c74:	e8 8d 05 00 00       	call   802206 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c79:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c84:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801c8b:	e8 94 ec ff ff       	call   800924 <memmove>
	nsipcbuf.send.req_size = size;
  801c90:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c96:	8b 45 14             	mov    0x14(%ebp),%eax
  801c99:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c9e:	b8 08 00 00 00       	mov    $0x8,%eax
  801ca3:	e8 7b fd ff ff       	call   801a23 <nsipc>
}
  801ca8:	83 c4 14             	add    $0x14,%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5d                   	pop    %ebp
  801cad:	c3                   	ret    

00801cae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cc4:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ccc:	b8 09 00 00 00       	mov    $0x9,%eax
  801cd1:	e8 4d fd ff ff       	call   801a23 <nsipc>
}
  801cd6:	c9                   	leave  
  801cd7:	c3                   	ret    

00801cd8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
  801cdb:	56                   	push   %esi
  801cdc:	53                   	push   %ebx
  801cdd:	83 ec 10             	sub    $0x10,%esp
  801ce0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	89 04 24             	mov    %eax,(%esp)
  801ce9:	e8 12 f2 ff ff       	call   800f00 <fd2data>
  801cee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cf0:	c7 44 24 04 d0 2a 80 	movl   $0x802ad0,0x4(%esp)
  801cf7:	00 
  801cf8:	89 1c 24             	mov    %ebx,(%esp)
  801cfb:	e8 87 ea ff ff       	call   800787 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d00:	8b 46 04             	mov    0x4(%esi),%eax
  801d03:	2b 06                	sub    (%esi),%eax
  801d05:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d0b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d12:	00 00 00 
	stat->st_dev = &devpipe;
  801d15:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d1c:	30 80 00 
	return 0;
}
  801d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d24:	83 c4 10             	add    $0x10,%esp
  801d27:	5b                   	pop    %ebx
  801d28:	5e                   	pop    %esi
  801d29:	5d                   	pop    %ebp
  801d2a:	c3                   	ret    

00801d2b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	53                   	push   %ebx
  801d2f:	83 ec 14             	sub    $0x14,%esp
  801d32:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d35:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d39:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d40:	e8 05 ef ff ff       	call   800c4a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d45:	89 1c 24             	mov    %ebx,(%esp)
  801d48:	e8 b3 f1 ff ff       	call   800f00 <fd2data>
  801d4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d58:	e8 ed ee ff ff       	call   800c4a <sys_page_unmap>
}
  801d5d:	83 c4 14             	add    $0x14,%esp
  801d60:	5b                   	pop    %ebx
  801d61:	5d                   	pop    %ebp
  801d62:	c3                   	ret    

00801d63 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	57                   	push   %edi
  801d67:	56                   	push   %esi
  801d68:	53                   	push   %ebx
  801d69:	83 ec 2c             	sub    $0x2c,%esp
  801d6c:	89 c6                	mov    %eax,%esi
  801d6e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801d71:	a1 08 40 80 00       	mov    0x804008,%eax
  801d76:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d79:	89 34 24             	mov    %esi,(%esp)
  801d7c:	e8 0e 06 00 00       	call   80238f <pageref>
  801d81:	89 c7                	mov    %eax,%edi
  801d83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d86:	89 04 24             	mov    %eax,(%esp)
  801d89:	e8 01 06 00 00       	call   80238f <pageref>
  801d8e:	39 c7                	cmp    %eax,%edi
  801d90:	0f 94 c2             	sete   %dl
  801d93:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801d96:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801d9c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801d9f:	39 fb                	cmp    %edi,%ebx
  801da1:	74 21                	je     801dc4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801da3:	84 d2                	test   %dl,%dl
  801da5:	74 ca                	je     801d71 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801da7:	8b 51 58             	mov    0x58(%ecx),%edx
  801daa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dae:	89 54 24 08          	mov    %edx,0x8(%esp)
  801db2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801db6:	c7 04 24 d7 2a 80 00 	movl   $0x802ad7,(%esp)
  801dbd:	e8 a1 e3 ff ff       	call   800163 <cprintf>
  801dc2:	eb ad                	jmp    801d71 <_pipeisclosed+0xe>
	}
}
  801dc4:	83 c4 2c             	add    $0x2c,%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5f                   	pop    %edi
  801dca:	5d                   	pop    %ebp
  801dcb:	c3                   	ret    

00801dcc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
  801dcf:	57                   	push   %edi
  801dd0:	56                   	push   %esi
  801dd1:	53                   	push   %ebx
  801dd2:	83 ec 1c             	sub    $0x1c,%esp
  801dd5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801dd8:	89 34 24             	mov    %esi,(%esp)
  801ddb:	e8 20 f1 ff ff       	call   800f00 <fd2data>
  801de0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801de2:	bf 00 00 00 00       	mov    $0x0,%edi
  801de7:	eb 45                	jmp    801e2e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801de9:	89 da                	mov    %ebx,%edx
  801deb:	89 f0                	mov    %esi,%eax
  801ded:	e8 71 ff ff ff       	call   801d63 <_pipeisclosed>
  801df2:	85 c0                	test   %eax,%eax
  801df4:	75 41                	jne    801e37 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801df6:	e8 89 ed ff ff       	call   800b84 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dfb:	8b 43 04             	mov    0x4(%ebx),%eax
  801dfe:	8b 0b                	mov    (%ebx),%ecx
  801e00:	8d 51 20             	lea    0x20(%ecx),%edx
  801e03:	39 d0                	cmp    %edx,%eax
  801e05:	73 e2                	jae    801de9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e0a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e0e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e11:	99                   	cltd   
  801e12:	c1 ea 1b             	shr    $0x1b,%edx
  801e15:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801e18:	83 e1 1f             	and    $0x1f,%ecx
  801e1b:	29 d1                	sub    %edx,%ecx
  801e1d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801e21:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801e25:	83 c0 01             	add    $0x1,%eax
  801e28:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e2b:	83 c7 01             	add    $0x1,%edi
  801e2e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e31:	75 c8                	jne    801dfb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801e33:	89 f8                	mov    %edi,%eax
  801e35:	eb 05                	jmp    801e3c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e37:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801e3c:	83 c4 1c             	add    $0x1c,%esp
  801e3f:	5b                   	pop    %ebx
  801e40:	5e                   	pop    %esi
  801e41:	5f                   	pop    %edi
  801e42:	5d                   	pop    %ebp
  801e43:	c3                   	ret    

00801e44 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	57                   	push   %edi
  801e48:	56                   	push   %esi
  801e49:	53                   	push   %ebx
  801e4a:	83 ec 1c             	sub    $0x1c,%esp
  801e4d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801e50:	89 3c 24             	mov    %edi,(%esp)
  801e53:	e8 a8 f0 ff ff       	call   800f00 <fd2data>
  801e58:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e5a:	be 00 00 00 00       	mov    $0x0,%esi
  801e5f:	eb 3d                	jmp    801e9e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801e61:	85 f6                	test   %esi,%esi
  801e63:	74 04                	je     801e69 <devpipe_read+0x25>
				return i;
  801e65:	89 f0                	mov    %esi,%eax
  801e67:	eb 43                	jmp    801eac <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801e69:	89 da                	mov    %ebx,%edx
  801e6b:	89 f8                	mov    %edi,%eax
  801e6d:	e8 f1 fe ff ff       	call   801d63 <_pipeisclosed>
  801e72:	85 c0                	test   %eax,%eax
  801e74:	75 31                	jne    801ea7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801e76:	e8 09 ed ff ff       	call   800b84 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801e7b:	8b 03                	mov    (%ebx),%eax
  801e7d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e80:	74 df                	je     801e61 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e82:	99                   	cltd   
  801e83:	c1 ea 1b             	shr    $0x1b,%edx
  801e86:	01 d0                	add    %edx,%eax
  801e88:	83 e0 1f             	and    $0x1f,%eax
  801e8b:	29 d0                	sub    %edx,%eax
  801e8d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e95:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e98:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e9b:	83 c6 01             	add    $0x1,%esi
  801e9e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ea1:	75 d8                	jne    801e7b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801ea3:	89 f0                	mov    %esi,%eax
  801ea5:	eb 05                	jmp    801eac <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801ea7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801eac:	83 c4 1c             	add    $0x1c,%esp
  801eaf:	5b                   	pop    %ebx
  801eb0:	5e                   	pop    %esi
  801eb1:	5f                   	pop    %edi
  801eb2:	5d                   	pop    %ebp
  801eb3:	c3                   	ret    

00801eb4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801eb4:	55                   	push   %ebp
  801eb5:	89 e5                	mov    %esp,%ebp
  801eb7:	56                   	push   %esi
  801eb8:	53                   	push   %ebx
  801eb9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801ebc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ebf:	89 04 24             	mov    %eax,(%esp)
  801ec2:	e8 50 f0 ff ff       	call   800f17 <fd_alloc>
  801ec7:	89 c2                	mov    %eax,%edx
  801ec9:	85 d2                	test   %edx,%edx
  801ecb:	0f 88 4d 01 00 00    	js     80201e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ed8:	00 
  801ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ee7:	e8 b7 ec ff ff       	call   800ba3 <sys_page_alloc>
  801eec:	89 c2                	mov    %eax,%edx
  801eee:	85 d2                	test   %edx,%edx
  801ef0:	0f 88 28 01 00 00    	js     80201e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801ef6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ef9:	89 04 24             	mov    %eax,(%esp)
  801efc:	e8 16 f0 ff ff       	call   800f17 <fd_alloc>
  801f01:	89 c3                	mov    %eax,%ebx
  801f03:	85 c0                	test   %eax,%eax
  801f05:	0f 88 fe 00 00 00    	js     802009 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f0b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f12:	00 
  801f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f16:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f21:	e8 7d ec ff ff       	call   800ba3 <sys_page_alloc>
  801f26:	89 c3                	mov    %eax,%ebx
  801f28:	85 c0                	test   %eax,%eax
  801f2a:	0f 88 d9 00 00 00    	js     802009 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f33:	89 04 24             	mov    %eax,(%esp)
  801f36:	e8 c5 ef ff ff       	call   800f00 <fd2data>
  801f3b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f3d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f44:	00 
  801f45:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f50:	e8 4e ec ff ff       	call   800ba3 <sys_page_alloc>
  801f55:	89 c3                	mov    %eax,%ebx
  801f57:	85 c0                	test   %eax,%eax
  801f59:	0f 88 97 00 00 00    	js     801ff6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f62:	89 04 24             	mov    %eax,(%esp)
  801f65:	e8 96 ef ff ff       	call   800f00 <fd2data>
  801f6a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801f71:	00 
  801f72:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f76:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f7d:	00 
  801f7e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f89:	e8 69 ec ff ff       	call   800bf7 <sys_page_map>
  801f8e:	89 c3                	mov    %eax,%ebx
  801f90:	85 c0                	test   %eax,%eax
  801f92:	78 52                	js     801fe6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801f94:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801fa9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc1:	89 04 24             	mov    %eax,(%esp)
  801fc4:	e8 27 ef ff ff       	call   800ef0 <fd2num>
  801fc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fcc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd1:	89 04 24             	mov    %eax,(%esp)
  801fd4:	e8 17 ef ff ff       	call   800ef0 <fd2num>
  801fd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fdc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fdf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe4:	eb 38                	jmp    80201e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801fe6:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ff1:	e8 54 ec ff ff       	call   800c4a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ffd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802004:	e8 41 ec ff ff       	call   800c4a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802010:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802017:	e8 2e ec ff ff       	call   800c4a <sys_page_unmap>
  80201c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80201e:	83 c4 30             	add    $0x30,%esp
  802021:	5b                   	pop    %ebx
  802022:	5e                   	pop    %esi
  802023:	5d                   	pop    %ebp
  802024:	c3                   	ret    

00802025 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80202b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80202e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	89 04 24             	mov    %eax,(%esp)
  802038:	e8 29 ef ff ff       	call   800f66 <fd_lookup>
  80203d:	89 c2                	mov    %eax,%edx
  80203f:	85 d2                	test   %edx,%edx
  802041:	78 15                	js     802058 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802046:	89 04 24             	mov    %eax,(%esp)
  802049:	e8 b2 ee ff ff       	call   800f00 <fd2data>
	return _pipeisclosed(fd, p);
  80204e:	89 c2                	mov    %eax,%edx
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	e8 0b fd ff ff       	call   801d63 <_pipeisclosed>
}
  802058:	c9                   	leave  
  802059:	c3                   	ret    
  80205a:	66 90                	xchg   %ax,%ax
  80205c:	66 90                	xchg   %ax,%ax
  80205e:	66 90                	xchg   %ax,%ax

00802060 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802063:	b8 00 00 00 00       	mov    $0x0,%eax
  802068:	5d                   	pop    %ebp
  802069:	c3                   	ret    

0080206a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802070:	c7 44 24 04 ef 2a 80 	movl   $0x802aef,0x4(%esp)
  802077:	00 
  802078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207b:	89 04 24             	mov    %eax,(%esp)
  80207e:	e8 04 e7 ff ff       	call   800787 <strcpy>
	return 0;
}
  802083:	b8 00 00 00 00       	mov    $0x0,%eax
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	57                   	push   %edi
  80208e:	56                   	push   %esi
  80208f:	53                   	push   %ebx
  802090:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802096:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80209b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020a1:	eb 31                	jmp    8020d4 <devcons_write+0x4a>
		m = n - tot;
  8020a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8020a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8020a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8020ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8020b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8020b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8020b7:	03 45 0c             	add    0xc(%ebp),%eax
  8020ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020be:	89 3c 24             	mov    %edi,(%esp)
  8020c1:	e8 5e e8 ff ff       	call   800924 <memmove>
		sys_cputs(buf, m);
  8020c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020ca:	89 3c 24             	mov    %edi,(%esp)
  8020cd:	e8 04 ea ff ff       	call   800ad6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020d2:	01 f3                	add    %esi,%ebx
  8020d4:	89 d8                	mov    %ebx,%eax
  8020d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8020d9:	72 c8                	jb     8020a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8020db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8020e1:	5b                   	pop    %ebx
  8020e2:	5e                   	pop    %esi
  8020e3:	5f                   	pop    %edi
  8020e4:	5d                   	pop    %ebp
  8020e5:	c3                   	ret    

008020e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8020ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8020f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020f5:	75 07                	jne    8020fe <devcons_read+0x18>
  8020f7:	eb 2a                	jmp    802123 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8020f9:	e8 86 ea ff ff       	call   800b84 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8020fe:	66 90                	xchg   %ax,%ax
  802100:	e8 ef e9 ff ff       	call   800af4 <sys_cgetc>
  802105:	85 c0                	test   %eax,%eax
  802107:	74 f0                	je     8020f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802109:	85 c0                	test   %eax,%eax
  80210b:	78 16                	js     802123 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80210d:	83 f8 04             	cmp    $0x4,%eax
  802110:	74 0c                	je     80211e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802112:	8b 55 0c             	mov    0xc(%ebp),%edx
  802115:	88 02                	mov    %al,(%edx)
	return 1;
  802117:	b8 01 00 00 00       	mov    $0x1,%eax
  80211c:	eb 05                	jmp    802123 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80211e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802131:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802138:	00 
  802139:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80213c:	89 04 24             	mov    %eax,(%esp)
  80213f:	e8 92 e9 ff ff       	call   800ad6 <sys_cputs>
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <getchar>:

int
getchar(void)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80214c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802153:	00 
  802154:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802157:	89 44 24 04          	mov    %eax,0x4(%esp)
  80215b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802162:	e8 93 f0 ff ff       	call   8011fa <read>
	if (r < 0)
  802167:	85 c0                	test   %eax,%eax
  802169:	78 0f                	js     80217a <getchar+0x34>
		return r;
	if (r < 1)
  80216b:	85 c0                	test   %eax,%eax
  80216d:	7e 06                	jle    802175 <getchar+0x2f>
		return -E_EOF;
	return c;
  80216f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802173:	eb 05                	jmp    80217a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802175:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802182:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802185:	89 44 24 04          	mov    %eax,0x4(%esp)
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	89 04 24             	mov    %eax,(%esp)
  80218f:	e8 d2 ed ff ff       	call   800f66 <fd_lookup>
  802194:	85 c0                	test   %eax,%eax
  802196:	78 11                	js     8021a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021a1:	39 10                	cmp    %edx,(%eax)
  8021a3:	0f 94 c0             	sete   %al
  8021a6:	0f b6 c0             	movzbl %al,%eax
}
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <opencons>:

int
opencons(void)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8021b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b4:	89 04 24             	mov    %eax,(%esp)
  8021b7:	e8 5b ed ff ff       	call   800f17 <fd_alloc>
		return r;
  8021bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	78 40                	js     802202 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021c9:	00 
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d8:	e8 c6 e9 ff ff       	call   800ba3 <sys_page_alloc>
		return r;
  8021dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	78 1f                	js     802202 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8021e3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021f8:	89 04 24             	mov    %eax,(%esp)
  8021fb:	e8 f0 ec ff ff       	call   800ef0 <fd2num>
  802200:	89 c2                	mov    %eax,%edx
}
  802202:	89 d0                	mov    %edx,%eax
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
  802209:	56                   	push   %esi
  80220a:	53                   	push   %ebx
  80220b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80220e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802211:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802217:	e8 49 e9 ff ff       	call   800b65 <sys_getenvid>
  80221c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80221f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802223:	8b 55 08             	mov    0x8(%ebp),%edx
  802226:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80222a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80222e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802232:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  802239:	e8 25 df ff ff       	call   800163 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80223e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802242:	8b 45 10             	mov    0x10(%ebp),%eax
  802245:	89 04 24             	mov    %eax,(%esp)
  802248:	e8 b5 de ff ff       	call   800102 <vcprintf>
	cprintf("\n");
  80224d:	c7 04 24 e8 2a 80 00 	movl   $0x802ae8,(%esp)
  802254:	e8 0a df ff ff       	call   800163 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802259:	cc                   	int3   
  80225a:	eb fd                	jmp    802259 <_panic+0x53>
  80225c:	66 90                	xchg   %ax,%ax
  80225e:	66 90                	xchg   %ax,%ax

00802260 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	56                   	push   %esi
  802264:	53                   	push   %ebx
  802265:	83 ec 10             	sub    $0x10,%esp
  802268:	8b 75 08             	mov    0x8(%ebp),%esi
  80226b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802271:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802273:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802278:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80227b:	89 04 24             	mov    %eax,(%esp)
  80227e:	e8 36 eb ff ff       	call   800db9 <sys_ipc_recv>
  802283:	85 c0                	test   %eax,%eax
  802285:	74 16                	je     80229d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802287:	85 f6                	test   %esi,%esi
  802289:	74 06                	je     802291 <ipc_recv+0x31>
			*from_env_store = 0;
  80228b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802291:	85 db                	test   %ebx,%ebx
  802293:	74 2c                	je     8022c1 <ipc_recv+0x61>
			*perm_store = 0;
  802295:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80229b:	eb 24                	jmp    8022c1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80229d:	85 f6                	test   %esi,%esi
  80229f:	74 0a                	je     8022ab <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8022a1:	a1 08 40 80 00       	mov    0x804008,%eax
  8022a6:	8b 40 74             	mov    0x74(%eax),%eax
  8022a9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8022ab:	85 db                	test   %ebx,%ebx
  8022ad:	74 0a                	je     8022b9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8022af:	a1 08 40 80 00       	mov    0x804008,%eax
  8022b4:	8b 40 78             	mov    0x78(%eax),%eax
  8022b7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8022b9:	a1 08 40 80 00       	mov    0x804008,%eax
  8022be:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022c1:	83 c4 10             	add    $0x10,%esp
  8022c4:	5b                   	pop    %ebx
  8022c5:	5e                   	pop    %esi
  8022c6:	5d                   	pop    %ebp
  8022c7:	c3                   	ret    

008022c8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022c8:	55                   	push   %ebp
  8022c9:	89 e5                	mov    %esp,%ebp
  8022cb:	57                   	push   %edi
  8022cc:	56                   	push   %esi
  8022cd:	53                   	push   %ebx
  8022ce:	83 ec 1c             	sub    $0x1c,%esp
  8022d1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022d7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8022da:	85 db                	test   %ebx,%ebx
  8022dc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8022e1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8022e4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022e8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	89 04 24             	mov    %eax,(%esp)
  8022f6:	e8 9b ea ff ff       	call   800d96 <sys_ipc_try_send>
	if (r == 0) return;
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	75 22                	jne    802321 <ipc_send+0x59>
  8022ff:	eb 4c                	jmp    80234d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802301:	84 d2                	test   %dl,%dl
  802303:	75 48                	jne    80234d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802305:	e8 7a e8 ff ff       	call   800b84 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80230a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80230e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802312:	89 74 24 04          	mov    %esi,0x4(%esp)
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	89 04 24             	mov    %eax,(%esp)
  80231c:	e8 75 ea ff ff       	call   800d96 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802321:	85 c0                	test   %eax,%eax
  802323:	0f 94 c2             	sete   %dl
  802326:	74 d9                	je     802301 <ipc_send+0x39>
  802328:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80232b:	74 d4                	je     802301 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80232d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802331:	c7 44 24 08 20 2b 80 	movl   $0x802b20,0x8(%esp)
  802338:	00 
  802339:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802340:	00 
  802341:	c7 04 24 2e 2b 80 00 	movl   $0x802b2e,(%esp)
  802348:	e8 b9 fe ff ff       	call   802206 <_panic>
}
  80234d:	83 c4 1c             	add    $0x1c,%esp
  802350:	5b                   	pop    %ebx
  802351:	5e                   	pop    %esi
  802352:	5f                   	pop    %edi
  802353:	5d                   	pop    %ebp
  802354:	c3                   	ret    

00802355 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
  802358:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80235b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802360:	89 c2                	mov    %eax,%edx
  802362:	c1 e2 07             	shl    $0x7,%edx
  802365:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80236b:	8b 52 50             	mov    0x50(%edx),%edx
  80236e:	39 ca                	cmp    %ecx,%edx
  802370:	75 0d                	jne    80237f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802372:	c1 e0 07             	shl    $0x7,%eax
  802375:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80237a:	8b 40 40             	mov    0x40(%eax),%eax
  80237d:	eb 0e                	jmp    80238d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80237f:	83 c0 01             	add    $0x1,%eax
  802382:	3d 00 04 00 00       	cmp    $0x400,%eax
  802387:	75 d7                	jne    802360 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802389:	66 b8 00 00          	mov    $0x0,%ax
}
  80238d:	5d                   	pop    %ebp
  80238e:	c3                   	ret    

0080238f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802395:	89 d0                	mov    %edx,%eax
  802397:	c1 e8 16             	shr    $0x16,%eax
  80239a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023a1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023a6:	f6 c1 01             	test   $0x1,%cl
  8023a9:	74 1d                	je     8023c8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023ab:	c1 ea 0c             	shr    $0xc,%edx
  8023ae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023b5:	f6 c2 01             	test   $0x1,%dl
  8023b8:	74 0e                	je     8023c8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023ba:	c1 ea 0c             	shr    $0xc,%edx
  8023bd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023c4:	ef 
  8023c5:	0f b7 c0             	movzwl %ax,%eax
}
  8023c8:	5d                   	pop    %ebp
  8023c9:	c3                   	ret    
  8023ca:	66 90                	xchg   %ax,%ax
  8023cc:	66 90                	xchg   %ax,%ax
  8023ce:	66 90                	xchg   %ax,%ax

008023d0 <__udivdi3>:
  8023d0:	55                   	push   %ebp
  8023d1:	57                   	push   %edi
  8023d2:	56                   	push   %esi
  8023d3:	83 ec 0c             	sub    $0xc,%esp
  8023d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8023da:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8023de:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8023e2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8023e6:	85 c0                	test   %eax,%eax
  8023e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8023ec:	89 ea                	mov    %ebp,%edx
  8023ee:	89 0c 24             	mov    %ecx,(%esp)
  8023f1:	75 2d                	jne    802420 <__udivdi3+0x50>
  8023f3:	39 e9                	cmp    %ebp,%ecx
  8023f5:	77 61                	ja     802458 <__udivdi3+0x88>
  8023f7:	85 c9                	test   %ecx,%ecx
  8023f9:	89 ce                	mov    %ecx,%esi
  8023fb:	75 0b                	jne    802408 <__udivdi3+0x38>
  8023fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802402:	31 d2                	xor    %edx,%edx
  802404:	f7 f1                	div    %ecx
  802406:	89 c6                	mov    %eax,%esi
  802408:	31 d2                	xor    %edx,%edx
  80240a:	89 e8                	mov    %ebp,%eax
  80240c:	f7 f6                	div    %esi
  80240e:	89 c5                	mov    %eax,%ebp
  802410:	89 f8                	mov    %edi,%eax
  802412:	f7 f6                	div    %esi
  802414:	89 ea                	mov    %ebp,%edx
  802416:	83 c4 0c             	add    $0xc,%esp
  802419:	5e                   	pop    %esi
  80241a:	5f                   	pop    %edi
  80241b:	5d                   	pop    %ebp
  80241c:	c3                   	ret    
  80241d:	8d 76 00             	lea    0x0(%esi),%esi
  802420:	39 e8                	cmp    %ebp,%eax
  802422:	77 24                	ja     802448 <__udivdi3+0x78>
  802424:	0f bd e8             	bsr    %eax,%ebp
  802427:	83 f5 1f             	xor    $0x1f,%ebp
  80242a:	75 3c                	jne    802468 <__udivdi3+0x98>
  80242c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802430:	39 34 24             	cmp    %esi,(%esp)
  802433:	0f 86 9f 00 00 00    	jbe    8024d8 <__udivdi3+0x108>
  802439:	39 d0                	cmp    %edx,%eax
  80243b:	0f 82 97 00 00 00    	jb     8024d8 <__udivdi3+0x108>
  802441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802448:	31 d2                	xor    %edx,%edx
  80244a:	31 c0                	xor    %eax,%eax
  80244c:	83 c4 0c             	add    $0xc,%esp
  80244f:	5e                   	pop    %esi
  802450:	5f                   	pop    %edi
  802451:	5d                   	pop    %ebp
  802452:	c3                   	ret    
  802453:	90                   	nop
  802454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802458:	89 f8                	mov    %edi,%eax
  80245a:	f7 f1                	div    %ecx
  80245c:	31 d2                	xor    %edx,%edx
  80245e:	83 c4 0c             	add    $0xc,%esp
  802461:	5e                   	pop    %esi
  802462:	5f                   	pop    %edi
  802463:	5d                   	pop    %ebp
  802464:	c3                   	ret    
  802465:	8d 76 00             	lea    0x0(%esi),%esi
  802468:	89 e9                	mov    %ebp,%ecx
  80246a:	8b 3c 24             	mov    (%esp),%edi
  80246d:	d3 e0                	shl    %cl,%eax
  80246f:	89 c6                	mov    %eax,%esi
  802471:	b8 20 00 00 00       	mov    $0x20,%eax
  802476:	29 e8                	sub    %ebp,%eax
  802478:	89 c1                	mov    %eax,%ecx
  80247a:	d3 ef                	shr    %cl,%edi
  80247c:	89 e9                	mov    %ebp,%ecx
  80247e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802482:	8b 3c 24             	mov    (%esp),%edi
  802485:	09 74 24 08          	or     %esi,0x8(%esp)
  802489:	89 d6                	mov    %edx,%esi
  80248b:	d3 e7                	shl    %cl,%edi
  80248d:	89 c1                	mov    %eax,%ecx
  80248f:	89 3c 24             	mov    %edi,(%esp)
  802492:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802496:	d3 ee                	shr    %cl,%esi
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	d3 e2                	shl    %cl,%edx
  80249c:	89 c1                	mov    %eax,%ecx
  80249e:	d3 ef                	shr    %cl,%edi
  8024a0:	09 d7                	or     %edx,%edi
  8024a2:	89 f2                	mov    %esi,%edx
  8024a4:	89 f8                	mov    %edi,%eax
  8024a6:	f7 74 24 08          	divl   0x8(%esp)
  8024aa:	89 d6                	mov    %edx,%esi
  8024ac:	89 c7                	mov    %eax,%edi
  8024ae:	f7 24 24             	mull   (%esp)
  8024b1:	39 d6                	cmp    %edx,%esi
  8024b3:	89 14 24             	mov    %edx,(%esp)
  8024b6:	72 30                	jb     8024e8 <__udivdi3+0x118>
  8024b8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024bc:	89 e9                	mov    %ebp,%ecx
  8024be:	d3 e2                	shl    %cl,%edx
  8024c0:	39 c2                	cmp    %eax,%edx
  8024c2:	73 05                	jae    8024c9 <__udivdi3+0xf9>
  8024c4:	3b 34 24             	cmp    (%esp),%esi
  8024c7:	74 1f                	je     8024e8 <__udivdi3+0x118>
  8024c9:	89 f8                	mov    %edi,%eax
  8024cb:	31 d2                	xor    %edx,%edx
  8024cd:	e9 7a ff ff ff       	jmp    80244c <__udivdi3+0x7c>
  8024d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024d8:	31 d2                	xor    %edx,%edx
  8024da:	b8 01 00 00 00       	mov    $0x1,%eax
  8024df:	e9 68 ff ff ff       	jmp    80244c <__udivdi3+0x7c>
  8024e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024e8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8024eb:	31 d2                	xor    %edx,%edx
  8024ed:	83 c4 0c             	add    $0xc,%esp
  8024f0:	5e                   	pop    %esi
  8024f1:	5f                   	pop    %edi
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    
  8024f4:	66 90                	xchg   %ax,%ax
  8024f6:	66 90                	xchg   %ax,%ax
  8024f8:	66 90                	xchg   %ax,%ax
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <__umoddi3>:
  802500:	55                   	push   %ebp
  802501:	57                   	push   %edi
  802502:	56                   	push   %esi
  802503:	83 ec 14             	sub    $0x14,%esp
  802506:	8b 44 24 28          	mov    0x28(%esp),%eax
  80250a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80250e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802512:	89 c7                	mov    %eax,%edi
  802514:	89 44 24 04          	mov    %eax,0x4(%esp)
  802518:	8b 44 24 30          	mov    0x30(%esp),%eax
  80251c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802520:	89 34 24             	mov    %esi,(%esp)
  802523:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802527:	85 c0                	test   %eax,%eax
  802529:	89 c2                	mov    %eax,%edx
  80252b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80252f:	75 17                	jne    802548 <__umoddi3+0x48>
  802531:	39 fe                	cmp    %edi,%esi
  802533:	76 4b                	jbe    802580 <__umoddi3+0x80>
  802535:	89 c8                	mov    %ecx,%eax
  802537:	89 fa                	mov    %edi,%edx
  802539:	f7 f6                	div    %esi
  80253b:	89 d0                	mov    %edx,%eax
  80253d:	31 d2                	xor    %edx,%edx
  80253f:	83 c4 14             	add    $0x14,%esp
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    
  802546:	66 90                	xchg   %ax,%ax
  802548:	39 f8                	cmp    %edi,%eax
  80254a:	77 54                	ja     8025a0 <__umoddi3+0xa0>
  80254c:	0f bd e8             	bsr    %eax,%ebp
  80254f:	83 f5 1f             	xor    $0x1f,%ebp
  802552:	75 5c                	jne    8025b0 <__umoddi3+0xb0>
  802554:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802558:	39 3c 24             	cmp    %edi,(%esp)
  80255b:	0f 87 e7 00 00 00    	ja     802648 <__umoddi3+0x148>
  802561:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802565:	29 f1                	sub    %esi,%ecx
  802567:	19 c7                	sbb    %eax,%edi
  802569:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80256d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802571:	8b 44 24 08          	mov    0x8(%esp),%eax
  802575:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802579:	83 c4 14             	add    $0x14,%esp
  80257c:	5e                   	pop    %esi
  80257d:	5f                   	pop    %edi
  80257e:	5d                   	pop    %ebp
  80257f:	c3                   	ret    
  802580:	85 f6                	test   %esi,%esi
  802582:	89 f5                	mov    %esi,%ebp
  802584:	75 0b                	jne    802591 <__umoddi3+0x91>
  802586:	b8 01 00 00 00       	mov    $0x1,%eax
  80258b:	31 d2                	xor    %edx,%edx
  80258d:	f7 f6                	div    %esi
  80258f:	89 c5                	mov    %eax,%ebp
  802591:	8b 44 24 04          	mov    0x4(%esp),%eax
  802595:	31 d2                	xor    %edx,%edx
  802597:	f7 f5                	div    %ebp
  802599:	89 c8                	mov    %ecx,%eax
  80259b:	f7 f5                	div    %ebp
  80259d:	eb 9c                	jmp    80253b <__umoddi3+0x3b>
  80259f:	90                   	nop
  8025a0:	89 c8                	mov    %ecx,%eax
  8025a2:	89 fa                	mov    %edi,%edx
  8025a4:	83 c4 14             	add    $0x14,%esp
  8025a7:	5e                   	pop    %esi
  8025a8:	5f                   	pop    %edi
  8025a9:	5d                   	pop    %ebp
  8025aa:	c3                   	ret    
  8025ab:	90                   	nop
  8025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025b0:	8b 04 24             	mov    (%esp),%eax
  8025b3:	be 20 00 00 00       	mov    $0x20,%esi
  8025b8:	89 e9                	mov    %ebp,%ecx
  8025ba:	29 ee                	sub    %ebp,%esi
  8025bc:	d3 e2                	shl    %cl,%edx
  8025be:	89 f1                	mov    %esi,%ecx
  8025c0:	d3 e8                	shr    %cl,%eax
  8025c2:	89 e9                	mov    %ebp,%ecx
  8025c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c8:	8b 04 24             	mov    (%esp),%eax
  8025cb:	09 54 24 04          	or     %edx,0x4(%esp)
  8025cf:	89 fa                	mov    %edi,%edx
  8025d1:	d3 e0                	shl    %cl,%eax
  8025d3:	89 f1                	mov    %esi,%ecx
  8025d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025d9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8025dd:	d3 ea                	shr    %cl,%edx
  8025df:	89 e9                	mov    %ebp,%ecx
  8025e1:	d3 e7                	shl    %cl,%edi
  8025e3:	89 f1                	mov    %esi,%ecx
  8025e5:	d3 e8                	shr    %cl,%eax
  8025e7:	89 e9                	mov    %ebp,%ecx
  8025e9:	09 f8                	or     %edi,%eax
  8025eb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8025ef:	f7 74 24 04          	divl   0x4(%esp)
  8025f3:	d3 e7                	shl    %cl,%edi
  8025f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025f9:	89 d7                	mov    %edx,%edi
  8025fb:	f7 64 24 08          	mull   0x8(%esp)
  8025ff:	39 d7                	cmp    %edx,%edi
  802601:	89 c1                	mov    %eax,%ecx
  802603:	89 14 24             	mov    %edx,(%esp)
  802606:	72 2c                	jb     802634 <__umoddi3+0x134>
  802608:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80260c:	72 22                	jb     802630 <__umoddi3+0x130>
  80260e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802612:	29 c8                	sub    %ecx,%eax
  802614:	19 d7                	sbb    %edx,%edi
  802616:	89 e9                	mov    %ebp,%ecx
  802618:	89 fa                	mov    %edi,%edx
  80261a:	d3 e8                	shr    %cl,%eax
  80261c:	89 f1                	mov    %esi,%ecx
  80261e:	d3 e2                	shl    %cl,%edx
  802620:	89 e9                	mov    %ebp,%ecx
  802622:	d3 ef                	shr    %cl,%edi
  802624:	09 d0                	or     %edx,%eax
  802626:	89 fa                	mov    %edi,%edx
  802628:	83 c4 14             	add    $0x14,%esp
  80262b:	5e                   	pop    %esi
  80262c:	5f                   	pop    %edi
  80262d:	5d                   	pop    %ebp
  80262e:	c3                   	ret    
  80262f:	90                   	nop
  802630:	39 d7                	cmp    %edx,%edi
  802632:	75 da                	jne    80260e <__umoddi3+0x10e>
  802634:	8b 14 24             	mov    (%esp),%edx
  802637:	89 c1                	mov    %eax,%ecx
  802639:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80263d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802641:	eb cb                	jmp    80260e <__umoddi3+0x10e>
  802643:	90                   	nop
  802644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802648:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80264c:	0f 82 0f ff ff ff    	jb     802561 <__umoddi3+0x61>
  802652:	e9 1a ff ff ff       	jmp    802571 <__umoddi3+0x71>
