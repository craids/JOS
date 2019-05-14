
obj/user/faultreadkernel.debug:     file format elf32-i386


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
  80002c:	e8 1f 00 00 00       	call   800050 <libmain>
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
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  800039:	a1 00 00 10 f0       	mov    0xf0100000,%eax
  80003e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800042:	c7 04 24 60 26 80 00 	movl   $0x802660,(%esp)
  800049:	e8 06 01 00 00       	call   800154 <cprintf>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	56                   	push   %esi
  800054:	53                   	push   %ebx
  800055:	83 ec 10             	sub    $0x10,%esp
  800058:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005e:	e8 f2 0a 00 00       	call   800b55 <sys_getenvid>
  800063:	25 ff 03 00 00       	and    $0x3ff,%eax
  800068:	c1 e0 07             	shl    $0x7,%eax
  80006b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800070:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800075:	85 db                	test   %ebx,%ebx
  800077:	7e 07                	jle    800080 <libmain+0x30>
		binaryname = argv[0];
  800079:	8b 06                	mov    (%esi),%eax
  80007b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800080:	89 74 24 04          	mov    %esi,0x4(%esp)
  800084:	89 1c 24             	mov    %ebx,(%esp)
  800087:	e8 a7 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008c:	e8 07 00 00 00       	call   800098 <exit>
}
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	5b                   	pop    %ebx
  800095:	5e                   	pop    %esi
  800096:	5d                   	pop    %ebp
  800097:	c3                   	ret    

00800098 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800098:	55                   	push   %ebp
  800099:	89 e5                	mov    %esp,%ebp
  80009b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80009e:	e8 17 10 00 00       	call   8010ba <close_all>
	sys_env_destroy(0);
  8000a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000aa:	e8 54 0a 00 00       	call   800b03 <sys_env_destroy>
}
  8000af:	c9                   	leave  
  8000b0:	c3                   	ret    

008000b1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000b1:	55                   	push   %ebp
  8000b2:	89 e5                	mov    %esp,%ebp
  8000b4:	53                   	push   %ebx
  8000b5:	83 ec 14             	sub    $0x14,%esp
  8000b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000bb:	8b 13                	mov    (%ebx),%edx
  8000bd:	8d 42 01             	lea    0x1(%edx),%eax
  8000c0:	89 03                	mov    %eax,(%ebx)
  8000c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000c5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000c9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000ce:	75 19                	jne    8000e9 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8000d0:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8000d7:	00 
  8000d8:	8d 43 08             	lea    0x8(%ebx),%eax
  8000db:	89 04 24             	mov    %eax,(%esp)
  8000de:	e8 e3 09 00 00       	call   800ac6 <sys_cputs>
		b->idx = 0;
  8000e3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8000e9:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8000ed:	83 c4 14             	add    $0x14,%esp
  8000f0:	5b                   	pop    %ebx
  8000f1:	5d                   	pop    %ebp
  8000f2:	c3                   	ret    

008000f3 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8000fc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800103:	00 00 00 
	b.cnt = 0;
  800106:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80010d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800110:	8b 45 0c             	mov    0xc(%ebp),%eax
  800113:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800117:	8b 45 08             	mov    0x8(%ebp),%eax
  80011a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80011e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800124:	89 44 24 04          	mov    %eax,0x4(%esp)
  800128:	c7 04 24 b1 00 80 00 	movl   $0x8000b1,(%esp)
  80012f:	e8 aa 01 00 00       	call   8002de <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800134:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80013a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80013e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800144:	89 04 24             	mov    %eax,(%esp)
  800147:	e8 7a 09 00 00       	call   800ac6 <sys_cputs>

	return b.cnt;
}
  80014c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80015a:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80015d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800161:	8b 45 08             	mov    0x8(%ebp),%eax
  800164:	89 04 24             	mov    %eax,(%esp)
  800167:	e8 87 ff ff ff       	call   8000f3 <vcprintf>
	va_end(ap);

	return cnt;
}
  80016c:	c9                   	leave  
  80016d:	c3                   	ret    
  80016e:	66 90                	xchg   %ax,%ax

00800170 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	57                   	push   %edi
  800174:	56                   	push   %esi
  800175:	53                   	push   %ebx
  800176:	83 ec 3c             	sub    $0x3c,%esp
  800179:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80017c:	89 d7                	mov    %edx,%edi
  80017e:	8b 45 08             	mov    0x8(%ebp),%eax
  800181:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800184:	8b 45 0c             	mov    0xc(%ebp),%eax
  800187:	89 c3                	mov    %eax,%ebx
  800189:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80018c:	8b 45 10             	mov    0x10(%ebp),%eax
  80018f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800192:	b9 00 00 00 00       	mov    $0x0,%ecx
  800197:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80019a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80019d:	39 d9                	cmp    %ebx,%ecx
  80019f:	72 05                	jb     8001a6 <printnum+0x36>
  8001a1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001a4:	77 69                	ja     80020f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001a6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8001a9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8001ad:	83 ee 01             	sub    $0x1,%esi
  8001b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8001b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8001bc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8001c0:	89 c3                	mov    %eax,%ebx
  8001c2:	89 d6                	mov    %edx,%esi
  8001c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8001ca:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001ce:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8001d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d5:	89 04 24             	mov    %eax,(%esp)
  8001d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001df:	e8 dc 21 00 00       	call   8023c0 <__udivdi3>
  8001e4:	89 d9                	mov    %ebx,%ecx
  8001e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8001ea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8001ee:	89 04 24             	mov    %eax,(%esp)
  8001f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8001f5:	89 fa                	mov    %edi,%edx
  8001f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001fa:	e8 71 ff ff ff       	call   800170 <printnum>
  8001ff:	eb 1b                	jmp    80021c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800201:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800205:	8b 45 18             	mov    0x18(%ebp),%eax
  800208:	89 04 24             	mov    %eax,(%esp)
  80020b:	ff d3                	call   *%ebx
  80020d:	eb 03                	jmp    800212 <printnum+0xa2>
  80020f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800212:	83 ee 01             	sub    $0x1,%esi
  800215:	85 f6                	test   %esi,%esi
  800217:	7f e8                	jg     800201 <printnum+0x91>
  800219:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80021c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800220:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800224:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800227:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80022a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80022e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800232:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800235:	89 04 24             	mov    %eax,(%esp)
  800238:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023f:	e8 ac 22 00 00       	call   8024f0 <__umoddi3>
  800244:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800248:	0f be 80 91 26 80 00 	movsbl 0x802691(%eax),%eax
  80024f:	89 04 24             	mov    %eax,(%esp)
  800252:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800255:	ff d0                	call   *%eax
}
  800257:	83 c4 3c             	add    $0x3c,%esp
  80025a:	5b                   	pop    %ebx
  80025b:	5e                   	pop    %esi
  80025c:	5f                   	pop    %edi
  80025d:	5d                   	pop    %ebp
  80025e:	c3                   	ret    

0080025f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80025f:	55                   	push   %ebp
  800260:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800262:	83 fa 01             	cmp    $0x1,%edx
  800265:	7e 0e                	jle    800275 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800267:	8b 10                	mov    (%eax),%edx
  800269:	8d 4a 08             	lea    0x8(%edx),%ecx
  80026c:	89 08                	mov    %ecx,(%eax)
  80026e:	8b 02                	mov    (%edx),%eax
  800270:	8b 52 04             	mov    0x4(%edx),%edx
  800273:	eb 22                	jmp    800297 <getuint+0x38>
	else if (lflag)
  800275:	85 d2                	test   %edx,%edx
  800277:	74 10                	je     800289 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800279:	8b 10                	mov    (%eax),%edx
  80027b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80027e:	89 08                	mov    %ecx,(%eax)
  800280:	8b 02                	mov    (%edx),%eax
  800282:	ba 00 00 00 00       	mov    $0x0,%edx
  800287:	eb 0e                	jmp    800297 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800289:	8b 10                	mov    (%eax),%edx
  80028b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80028e:	89 08                	mov    %ecx,(%eax)
  800290:	8b 02                	mov    (%edx),%eax
  800292:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800297:	5d                   	pop    %ebp
  800298:	c3                   	ret    

00800299 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80029f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002a3:	8b 10                	mov    (%eax),%edx
  8002a5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002a8:	73 0a                	jae    8002b4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ad:	89 08                	mov    %ecx,(%eax)
  8002af:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b2:	88 02                	mov    %al,(%edx)
}
  8002b4:	5d                   	pop    %ebp
  8002b5:	c3                   	ret    

008002b6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8002bc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	89 04 24             	mov    %eax,(%esp)
  8002d7:	e8 02 00 00 00       	call   8002de <vprintfmt>
	va_end(ap);
}
  8002dc:	c9                   	leave  
  8002dd:	c3                   	ret    

008002de <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002de:	55                   	push   %ebp
  8002df:	89 e5                	mov    %esp,%ebp
  8002e1:	57                   	push   %edi
  8002e2:	56                   	push   %esi
  8002e3:	53                   	push   %ebx
  8002e4:	83 ec 3c             	sub    $0x3c,%esp
  8002e7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8002ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002ed:	eb 14                	jmp    800303 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8002ef:	85 c0                	test   %eax,%eax
  8002f1:	0f 84 b3 03 00 00    	je     8006aa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8002f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002fb:	89 04 24             	mov    %eax,(%esp)
  8002fe:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800301:	89 f3                	mov    %esi,%ebx
  800303:	8d 73 01             	lea    0x1(%ebx),%esi
  800306:	0f b6 03             	movzbl (%ebx),%eax
  800309:	83 f8 25             	cmp    $0x25,%eax
  80030c:	75 e1                	jne    8002ef <vprintfmt+0x11>
  80030e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800312:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800319:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800320:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800327:	ba 00 00 00 00       	mov    $0x0,%edx
  80032c:	eb 1d                	jmp    80034b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80032e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800330:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800334:	eb 15                	jmp    80034b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800336:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800338:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80033c:	eb 0d                	jmp    80034b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80033e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800341:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800344:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80034b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80034e:	0f b6 0e             	movzbl (%esi),%ecx
  800351:	0f b6 c1             	movzbl %cl,%eax
  800354:	83 e9 23             	sub    $0x23,%ecx
  800357:	80 f9 55             	cmp    $0x55,%cl
  80035a:	0f 87 2a 03 00 00    	ja     80068a <vprintfmt+0x3ac>
  800360:	0f b6 c9             	movzbl %cl,%ecx
  800363:	ff 24 8d e0 27 80 00 	jmp    *0x8027e0(,%ecx,4)
  80036a:	89 de                	mov    %ebx,%esi
  80036c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800371:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800374:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800378:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80037b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80037e:	83 fb 09             	cmp    $0x9,%ebx
  800381:	77 36                	ja     8003b9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800383:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800386:	eb e9                	jmp    800371 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800388:	8b 45 14             	mov    0x14(%ebp),%eax
  80038b:	8d 48 04             	lea    0x4(%eax),%ecx
  80038e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800391:	8b 00                	mov    (%eax),%eax
  800393:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800396:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800398:	eb 22                	jmp    8003bc <vprintfmt+0xde>
  80039a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80039d:	85 c9                	test   %ecx,%ecx
  80039f:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a4:	0f 49 c1             	cmovns %ecx,%eax
  8003a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003aa:	89 de                	mov    %ebx,%esi
  8003ac:	eb 9d                	jmp    80034b <vprintfmt+0x6d>
  8003ae:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003b0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8003b7:	eb 92                	jmp    80034b <vprintfmt+0x6d>
  8003b9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8003bc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8003c0:	79 89                	jns    80034b <vprintfmt+0x6d>
  8003c2:	e9 77 ff ff ff       	jmp    80033e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003c7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ca:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003cc:	e9 7a ff ff ff       	jmp    80034b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d4:	8d 50 04             	lea    0x4(%eax),%edx
  8003d7:	89 55 14             	mov    %edx,0x14(%ebp)
  8003da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003de:	8b 00                	mov    (%eax),%eax
  8003e0:	89 04 24             	mov    %eax,(%esp)
  8003e3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8003e6:	e9 18 ff ff ff       	jmp    800303 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8003eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ee:	8d 50 04             	lea    0x4(%eax),%edx
  8003f1:	89 55 14             	mov    %edx,0x14(%ebp)
  8003f4:	8b 00                	mov    (%eax),%eax
  8003f6:	99                   	cltd   
  8003f7:	31 d0                	xor    %edx,%eax
  8003f9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003fb:	83 f8 11             	cmp    $0x11,%eax
  8003fe:	7f 0b                	jg     80040b <vprintfmt+0x12d>
  800400:	8b 14 85 40 29 80 00 	mov    0x802940(,%eax,4),%edx
  800407:	85 d2                	test   %edx,%edx
  800409:	75 20                	jne    80042b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80040b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80040f:	c7 44 24 08 a9 26 80 	movl   $0x8026a9,0x8(%esp)
  800416:	00 
  800417:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	89 04 24             	mov    %eax,(%esp)
  800421:	e8 90 fe ff ff       	call   8002b6 <printfmt>
  800426:	e9 d8 fe ff ff       	jmp    800303 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80042b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80042f:	c7 44 24 08 7d 2a 80 	movl   $0x802a7d,0x8(%esp)
  800436:	00 
  800437:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	89 04 24             	mov    %eax,(%esp)
  800441:	e8 70 fe ff ff       	call   8002b6 <printfmt>
  800446:	e9 b8 fe ff ff       	jmp    800303 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80044e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800451:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800454:	8b 45 14             	mov    0x14(%ebp),%eax
  800457:	8d 50 04             	lea    0x4(%eax),%edx
  80045a:	89 55 14             	mov    %edx,0x14(%ebp)
  80045d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80045f:	85 f6                	test   %esi,%esi
  800461:	b8 a2 26 80 00       	mov    $0x8026a2,%eax
  800466:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800469:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80046d:	0f 84 97 00 00 00    	je     80050a <vprintfmt+0x22c>
  800473:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800477:	0f 8e 9b 00 00 00    	jle    800518 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80047d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800481:	89 34 24             	mov    %esi,(%esp)
  800484:	e8 cf 02 00 00       	call   800758 <strnlen>
  800489:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80048c:	29 c2                	sub    %eax,%edx
  80048e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800491:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800495:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800498:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80049b:	8b 75 08             	mov    0x8(%ebp),%esi
  80049e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004a1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a3:	eb 0f                	jmp    8004b4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8004a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ac:	89 04 24             	mov    %eax,(%esp)
  8004af:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004b1:	83 eb 01             	sub    $0x1,%ebx
  8004b4:	85 db                	test   %ebx,%ebx
  8004b6:	7f ed                	jg     8004a5 <vprintfmt+0x1c7>
  8004b8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8004bb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004be:	85 d2                	test   %edx,%edx
  8004c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c5:	0f 49 c2             	cmovns %edx,%eax
  8004c8:	29 c2                	sub    %eax,%edx
  8004ca:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8004cd:	89 d7                	mov    %edx,%edi
  8004cf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8004d2:	eb 50                	jmp    800524 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004d8:	74 1e                	je     8004f8 <vprintfmt+0x21a>
  8004da:	0f be d2             	movsbl %dl,%edx
  8004dd:	83 ea 20             	sub    $0x20,%edx
  8004e0:	83 fa 5e             	cmp    $0x5e,%edx
  8004e3:	76 13                	jbe    8004f8 <vprintfmt+0x21a>
					putch('?', putdat);
  8004e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ec:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8004f3:	ff 55 08             	call   *0x8(%ebp)
  8004f6:	eb 0d                	jmp    800505 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8004f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004ff:	89 04 24             	mov    %eax,(%esp)
  800502:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800505:	83 ef 01             	sub    $0x1,%edi
  800508:	eb 1a                	jmp    800524 <vprintfmt+0x246>
  80050a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80050d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800510:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800513:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800516:	eb 0c                	jmp    800524 <vprintfmt+0x246>
  800518:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80051b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80051e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800521:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800524:	83 c6 01             	add    $0x1,%esi
  800527:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80052b:	0f be c2             	movsbl %dl,%eax
  80052e:	85 c0                	test   %eax,%eax
  800530:	74 27                	je     800559 <vprintfmt+0x27b>
  800532:	85 db                	test   %ebx,%ebx
  800534:	78 9e                	js     8004d4 <vprintfmt+0x1f6>
  800536:	83 eb 01             	sub    $0x1,%ebx
  800539:	79 99                	jns    8004d4 <vprintfmt+0x1f6>
  80053b:	89 f8                	mov    %edi,%eax
  80053d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800540:	8b 75 08             	mov    0x8(%ebp),%esi
  800543:	89 c3                	mov    %eax,%ebx
  800545:	eb 1a                	jmp    800561 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800547:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80054b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800552:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800554:	83 eb 01             	sub    $0x1,%ebx
  800557:	eb 08                	jmp    800561 <vprintfmt+0x283>
  800559:	89 fb                	mov    %edi,%ebx
  80055b:	8b 75 08             	mov    0x8(%ebp),%esi
  80055e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800561:	85 db                	test   %ebx,%ebx
  800563:	7f e2                	jg     800547 <vprintfmt+0x269>
  800565:	89 75 08             	mov    %esi,0x8(%ebp)
  800568:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80056b:	e9 93 fd ff ff       	jmp    800303 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800570:	83 fa 01             	cmp    $0x1,%edx
  800573:	7e 16                	jle    80058b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800575:	8b 45 14             	mov    0x14(%ebp),%eax
  800578:	8d 50 08             	lea    0x8(%eax),%edx
  80057b:	89 55 14             	mov    %edx,0x14(%ebp)
  80057e:	8b 50 04             	mov    0x4(%eax),%edx
  800581:	8b 00                	mov    (%eax),%eax
  800583:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800586:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800589:	eb 32                	jmp    8005bd <vprintfmt+0x2df>
	else if (lflag)
  80058b:	85 d2                	test   %edx,%edx
  80058d:	74 18                	je     8005a7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	8d 50 04             	lea    0x4(%eax),%edx
  800595:	89 55 14             	mov    %edx,0x14(%ebp)
  800598:	8b 30                	mov    (%eax),%esi
  80059a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80059d:	89 f0                	mov    %esi,%eax
  80059f:	c1 f8 1f             	sar    $0x1f,%eax
  8005a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005a5:	eb 16                	jmp    8005bd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8d 50 04             	lea    0x4(%eax),%edx
  8005ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b0:	8b 30                	mov    (%eax),%esi
  8005b2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005b5:	89 f0                	mov    %esi,%eax
  8005b7:	c1 f8 1f             	sar    $0x1f,%eax
  8005ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005cc:	0f 89 80 00 00 00    	jns    800652 <vprintfmt+0x374>
				putch('-', putdat);
  8005d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005d6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005dd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8005e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005e6:	f7 d8                	neg    %eax
  8005e8:	83 d2 00             	adc    $0x0,%edx
  8005eb:	f7 da                	neg    %edx
			}
			base = 10;
  8005ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8005f2:	eb 5e                	jmp    800652 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8005f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8005f7:	e8 63 fc ff ff       	call   80025f <getuint>
			base = 10;
  8005fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800601:	eb 4f                	jmp    800652 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800603:	8d 45 14             	lea    0x14(%ebp),%eax
  800606:	e8 54 fc ff ff       	call   80025f <getuint>
			base = 8;
  80060b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800610:	eb 40                	jmp    800652 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800612:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800616:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80061d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800620:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800624:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80062b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8d 50 04             	lea    0x4(%eax),%edx
  800634:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800637:	8b 00                	mov    (%eax),%eax
  800639:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80063e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800643:	eb 0d                	jmp    800652 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800645:	8d 45 14             	lea    0x14(%ebp),%eax
  800648:	e8 12 fc ff ff       	call   80025f <getuint>
			base = 16;
  80064d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800652:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800656:	89 74 24 10          	mov    %esi,0x10(%esp)
  80065a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80065d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800661:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800665:	89 04 24             	mov    %eax,(%esp)
  800668:	89 54 24 04          	mov    %edx,0x4(%esp)
  80066c:	89 fa                	mov    %edi,%edx
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	e8 fa fa ff ff       	call   800170 <printnum>
			break;
  800676:	e9 88 fc ff ff       	jmp    800303 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80067b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80067f:	89 04 24             	mov    %eax,(%esp)
  800682:	ff 55 08             	call   *0x8(%ebp)
			break;
  800685:	e9 79 fc ff ff       	jmp    800303 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80068a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80068e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800695:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800698:	89 f3                	mov    %esi,%ebx
  80069a:	eb 03                	jmp    80069f <vprintfmt+0x3c1>
  80069c:	83 eb 01             	sub    $0x1,%ebx
  80069f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8006a3:	75 f7                	jne    80069c <vprintfmt+0x3be>
  8006a5:	e9 59 fc ff ff       	jmp    800303 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8006aa:	83 c4 3c             	add    $0x3c,%esp
  8006ad:	5b                   	pop    %ebx
  8006ae:	5e                   	pop    %esi
  8006af:	5f                   	pop    %edi
  8006b0:	5d                   	pop    %ebp
  8006b1:	c3                   	ret    

008006b2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006b2:	55                   	push   %ebp
  8006b3:	89 e5                	mov    %esp,%ebp
  8006b5:	83 ec 28             	sub    $0x28,%esp
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006c1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006c5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006cf:	85 c0                	test   %eax,%eax
  8006d1:	74 30                	je     800703 <vsnprintf+0x51>
  8006d3:	85 d2                	test   %edx,%edx
  8006d5:	7e 2c                	jle    800703 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006de:	8b 45 10             	mov    0x10(%ebp),%eax
  8006e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ec:	c7 04 24 99 02 80 00 	movl   $0x800299,(%esp)
  8006f3:	e8 e6 fb ff ff       	call   8002de <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006fb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800701:	eb 05                	jmp    800708 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800703:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800708:	c9                   	leave  
  800709:	c3                   	ret    

0080070a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80070a:	55                   	push   %ebp
  80070b:	89 e5                	mov    %esp,%ebp
  80070d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800710:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800713:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800717:	8b 45 10             	mov    0x10(%ebp),%eax
  80071a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80071e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800721:	89 44 24 04          	mov    %eax,0x4(%esp)
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	89 04 24             	mov    %eax,(%esp)
  80072b:	e8 82 ff ff ff       	call   8006b2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800730:	c9                   	leave  
  800731:	c3                   	ret    
  800732:	66 90                	xchg   %ax,%ax
  800734:	66 90                	xchg   %ax,%ax
  800736:	66 90                	xchg   %ax,%ax
  800738:	66 90                	xchg   %ax,%ax
  80073a:	66 90                	xchg   %ax,%ax
  80073c:	66 90                	xchg   %ax,%ax
  80073e:	66 90                	xchg   %ax,%ax

00800740 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800746:	b8 00 00 00 00       	mov    $0x0,%eax
  80074b:	eb 03                	jmp    800750 <strlen+0x10>
		n++;
  80074d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800750:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800754:	75 f7                	jne    80074d <strlen+0xd>
		n++;
	return n;
}
  800756:	5d                   	pop    %ebp
  800757:	c3                   	ret    

00800758 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
  80075b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80075e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800761:	b8 00 00 00 00       	mov    $0x0,%eax
  800766:	eb 03                	jmp    80076b <strnlen+0x13>
		n++;
  800768:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80076b:	39 d0                	cmp    %edx,%eax
  80076d:	74 06                	je     800775 <strnlen+0x1d>
  80076f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800773:	75 f3                	jne    800768 <strnlen+0x10>
		n++;
	return n;
}
  800775:	5d                   	pop    %ebp
  800776:	c3                   	ret    

00800777 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	53                   	push   %ebx
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800781:	89 c2                	mov    %eax,%edx
  800783:	83 c2 01             	add    $0x1,%edx
  800786:	83 c1 01             	add    $0x1,%ecx
  800789:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80078d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800790:	84 db                	test   %bl,%bl
  800792:	75 ef                	jne    800783 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800794:	5b                   	pop    %ebx
  800795:	5d                   	pop    %ebp
  800796:	c3                   	ret    

00800797 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
  80079a:	53                   	push   %ebx
  80079b:	83 ec 08             	sub    $0x8,%esp
  80079e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007a1:	89 1c 24             	mov    %ebx,(%esp)
  8007a4:	e8 97 ff ff ff       	call   800740 <strlen>
	strcpy(dst + len, src);
  8007a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007b0:	01 d8                	add    %ebx,%eax
  8007b2:	89 04 24             	mov    %eax,(%esp)
  8007b5:	e8 bd ff ff ff       	call   800777 <strcpy>
	return dst;
}
  8007ba:	89 d8                	mov    %ebx,%eax
  8007bc:	83 c4 08             	add    $0x8,%esp
  8007bf:	5b                   	pop    %ebx
  8007c0:	5d                   	pop    %ebp
  8007c1:	c3                   	ret    

008007c2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007c2:	55                   	push   %ebp
  8007c3:	89 e5                	mov    %esp,%ebp
  8007c5:	56                   	push   %esi
  8007c6:	53                   	push   %ebx
  8007c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007cd:	89 f3                	mov    %esi,%ebx
  8007cf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007d2:	89 f2                	mov    %esi,%edx
  8007d4:	eb 0f                	jmp    8007e5 <strncpy+0x23>
		*dst++ = *src;
  8007d6:	83 c2 01             	add    $0x1,%edx
  8007d9:	0f b6 01             	movzbl (%ecx),%eax
  8007dc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007df:	80 39 01             	cmpb   $0x1,(%ecx)
  8007e2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007e5:	39 da                	cmp    %ebx,%edx
  8007e7:	75 ed                	jne    8007d6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8007e9:	89 f0                	mov    %esi,%eax
  8007eb:	5b                   	pop    %ebx
  8007ec:	5e                   	pop    %esi
  8007ed:	5d                   	pop    %ebp
  8007ee:	c3                   	ret    

008007ef <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007ef:	55                   	push   %ebp
  8007f0:	89 e5                	mov    %esp,%ebp
  8007f2:	56                   	push   %esi
  8007f3:	53                   	push   %ebx
  8007f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007fd:	89 f0                	mov    %esi,%eax
  8007ff:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800803:	85 c9                	test   %ecx,%ecx
  800805:	75 0b                	jne    800812 <strlcpy+0x23>
  800807:	eb 1d                	jmp    800826 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800809:	83 c0 01             	add    $0x1,%eax
  80080c:	83 c2 01             	add    $0x1,%edx
  80080f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800812:	39 d8                	cmp    %ebx,%eax
  800814:	74 0b                	je     800821 <strlcpy+0x32>
  800816:	0f b6 0a             	movzbl (%edx),%ecx
  800819:	84 c9                	test   %cl,%cl
  80081b:	75 ec                	jne    800809 <strlcpy+0x1a>
  80081d:	89 c2                	mov    %eax,%edx
  80081f:	eb 02                	jmp    800823 <strlcpy+0x34>
  800821:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800823:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800826:	29 f0                	sub    %esi,%eax
}
  800828:	5b                   	pop    %ebx
  800829:	5e                   	pop    %esi
  80082a:	5d                   	pop    %ebp
  80082b:	c3                   	ret    

0080082c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80082c:	55                   	push   %ebp
  80082d:	89 e5                	mov    %esp,%ebp
  80082f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800832:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800835:	eb 06                	jmp    80083d <strcmp+0x11>
		p++, q++;
  800837:	83 c1 01             	add    $0x1,%ecx
  80083a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80083d:	0f b6 01             	movzbl (%ecx),%eax
  800840:	84 c0                	test   %al,%al
  800842:	74 04                	je     800848 <strcmp+0x1c>
  800844:	3a 02                	cmp    (%edx),%al
  800846:	74 ef                	je     800837 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800848:	0f b6 c0             	movzbl %al,%eax
  80084b:	0f b6 12             	movzbl (%edx),%edx
  80084e:	29 d0                	sub    %edx,%eax
}
  800850:	5d                   	pop    %ebp
  800851:	c3                   	ret    

00800852 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800852:	55                   	push   %ebp
  800853:	89 e5                	mov    %esp,%ebp
  800855:	53                   	push   %ebx
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085c:	89 c3                	mov    %eax,%ebx
  80085e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800861:	eb 06                	jmp    800869 <strncmp+0x17>
		n--, p++, q++;
  800863:	83 c0 01             	add    $0x1,%eax
  800866:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800869:	39 d8                	cmp    %ebx,%eax
  80086b:	74 15                	je     800882 <strncmp+0x30>
  80086d:	0f b6 08             	movzbl (%eax),%ecx
  800870:	84 c9                	test   %cl,%cl
  800872:	74 04                	je     800878 <strncmp+0x26>
  800874:	3a 0a                	cmp    (%edx),%cl
  800876:	74 eb                	je     800863 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800878:	0f b6 00             	movzbl (%eax),%eax
  80087b:	0f b6 12             	movzbl (%edx),%edx
  80087e:	29 d0                	sub    %edx,%eax
  800880:	eb 05                	jmp    800887 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800882:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800887:	5b                   	pop    %ebx
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800894:	eb 07                	jmp    80089d <strchr+0x13>
		if (*s == c)
  800896:	38 ca                	cmp    %cl,%dl
  800898:	74 0f                	je     8008a9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80089a:	83 c0 01             	add    $0x1,%eax
  80089d:	0f b6 10             	movzbl (%eax),%edx
  8008a0:	84 d2                	test   %dl,%dl
  8008a2:	75 f2                	jne    800896 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8008a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008b5:	eb 07                	jmp    8008be <strfind+0x13>
		if (*s == c)
  8008b7:	38 ca                	cmp    %cl,%dl
  8008b9:	74 0a                	je     8008c5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8008bb:	83 c0 01             	add    $0x1,%eax
  8008be:	0f b6 10             	movzbl (%eax),%edx
  8008c1:	84 d2                	test   %dl,%dl
  8008c3:	75 f2                	jne    8008b7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8008c5:	5d                   	pop    %ebp
  8008c6:	c3                   	ret    

008008c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	57                   	push   %edi
  8008cb:	56                   	push   %esi
  8008cc:	53                   	push   %ebx
  8008cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008d3:	85 c9                	test   %ecx,%ecx
  8008d5:	74 36                	je     80090d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008d7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008dd:	75 28                	jne    800907 <memset+0x40>
  8008df:	f6 c1 03             	test   $0x3,%cl
  8008e2:	75 23                	jne    800907 <memset+0x40>
		c &= 0xFF;
  8008e4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008e8:	89 d3                	mov    %edx,%ebx
  8008ea:	c1 e3 08             	shl    $0x8,%ebx
  8008ed:	89 d6                	mov    %edx,%esi
  8008ef:	c1 e6 18             	shl    $0x18,%esi
  8008f2:	89 d0                	mov    %edx,%eax
  8008f4:	c1 e0 10             	shl    $0x10,%eax
  8008f7:	09 f0                	or     %esi,%eax
  8008f9:	09 c2                	or     %eax,%edx
  8008fb:	89 d0                	mov    %edx,%eax
  8008fd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8008ff:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800902:	fc                   	cld    
  800903:	f3 ab                	rep stos %eax,%es:(%edi)
  800905:	eb 06                	jmp    80090d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800907:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090a:	fc                   	cld    
  80090b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80090d:	89 f8                	mov    %edi,%eax
  80090f:	5b                   	pop    %ebx
  800910:	5e                   	pop    %esi
  800911:	5f                   	pop    %edi
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	57                   	push   %edi
  800918:	56                   	push   %esi
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80091f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800922:	39 c6                	cmp    %eax,%esi
  800924:	73 35                	jae    80095b <memmove+0x47>
  800926:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800929:	39 d0                	cmp    %edx,%eax
  80092b:	73 2e                	jae    80095b <memmove+0x47>
		s += n;
		d += n;
  80092d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800930:	89 d6                	mov    %edx,%esi
  800932:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800934:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80093a:	75 13                	jne    80094f <memmove+0x3b>
  80093c:	f6 c1 03             	test   $0x3,%cl
  80093f:	75 0e                	jne    80094f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800941:	83 ef 04             	sub    $0x4,%edi
  800944:	8d 72 fc             	lea    -0x4(%edx),%esi
  800947:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80094a:	fd                   	std    
  80094b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80094d:	eb 09                	jmp    800958 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80094f:	83 ef 01             	sub    $0x1,%edi
  800952:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800955:	fd                   	std    
  800956:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800958:	fc                   	cld    
  800959:	eb 1d                	jmp    800978 <memmove+0x64>
  80095b:	89 f2                	mov    %esi,%edx
  80095d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80095f:	f6 c2 03             	test   $0x3,%dl
  800962:	75 0f                	jne    800973 <memmove+0x5f>
  800964:	f6 c1 03             	test   $0x3,%cl
  800967:	75 0a                	jne    800973 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800969:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80096c:	89 c7                	mov    %eax,%edi
  80096e:	fc                   	cld    
  80096f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800971:	eb 05                	jmp    800978 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800973:	89 c7                	mov    %eax,%edi
  800975:	fc                   	cld    
  800976:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800978:	5e                   	pop    %esi
  800979:	5f                   	pop    %edi
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800982:	8b 45 10             	mov    0x10(%ebp),%eax
  800985:	89 44 24 08          	mov    %eax,0x8(%esp)
  800989:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	89 04 24             	mov    %eax,(%esp)
  800996:	e8 79 ff ff ff       	call   800914 <memmove>
}
  80099b:	c9                   	leave  
  80099c:	c3                   	ret    

0080099d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80099d:	55                   	push   %ebp
  80099e:	89 e5                	mov    %esp,%ebp
  8009a0:	56                   	push   %esi
  8009a1:	53                   	push   %ebx
  8009a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a8:	89 d6                	mov    %edx,%esi
  8009aa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009ad:	eb 1a                	jmp    8009c9 <memcmp+0x2c>
		if (*s1 != *s2)
  8009af:	0f b6 02             	movzbl (%edx),%eax
  8009b2:	0f b6 19             	movzbl (%ecx),%ebx
  8009b5:	38 d8                	cmp    %bl,%al
  8009b7:	74 0a                	je     8009c3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8009b9:	0f b6 c0             	movzbl %al,%eax
  8009bc:	0f b6 db             	movzbl %bl,%ebx
  8009bf:	29 d8                	sub    %ebx,%eax
  8009c1:	eb 0f                	jmp    8009d2 <memcmp+0x35>
		s1++, s2++;
  8009c3:	83 c2 01             	add    $0x1,%edx
  8009c6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009c9:	39 f2                	cmp    %esi,%edx
  8009cb:	75 e2                	jne    8009af <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8009cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d2:	5b                   	pop    %ebx
  8009d3:	5e                   	pop    %esi
  8009d4:	5d                   	pop    %ebp
  8009d5:	c3                   	ret    

008009d6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009df:	89 c2                	mov    %eax,%edx
  8009e1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009e4:	eb 07                	jmp    8009ed <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009e6:	38 08                	cmp    %cl,(%eax)
  8009e8:	74 07                	je     8009f1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8009ea:	83 c0 01             	add    $0x1,%eax
  8009ed:	39 d0                	cmp    %edx,%eax
  8009ef:	72 f5                	jb     8009e6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8009f1:	5d                   	pop    %ebp
  8009f2:	c3                   	ret    

008009f3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	57                   	push   %edi
  8009f7:	56                   	push   %esi
  8009f8:	53                   	push   %ebx
  8009f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8009fc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009ff:	eb 03                	jmp    800a04 <strtol+0x11>
		s++;
  800a01:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a04:	0f b6 0a             	movzbl (%edx),%ecx
  800a07:	80 f9 09             	cmp    $0x9,%cl
  800a0a:	74 f5                	je     800a01 <strtol+0xe>
  800a0c:	80 f9 20             	cmp    $0x20,%cl
  800a0f:	74 f0                	je     800a01 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a11:	80 f9 2b             	cmp    $0x2b,%cl
  800a14:	75 0a                	jne    800a20 <strtol+0x2d>
		s++;
  800a16:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a19:	bf 00 00 00 00       	mov    $0x0,%edi
  800a1e:	eb 11                	jmp    800a31 <strtol+0x3e>
  800a20:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a25:	80 f9 2d             	cmp    $0x2d,%cl
  800a28:	75 07                	jne    800a31 <strtol+0x3e>
		s++, neg = 1;
  800a2a:	8d 52 01             	lea    0x1(%edx),%edx
  800a2d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a31:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800a36:	75 15                	jne    800a4d <strtol+0x5a>
  800a38:	80 3a 30             	cmpb   $0x30,(%edx)
  800a3b:	75 10                	jne    800a4d <strtol+0x5a>
  800a3d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800a41:	75 0a                	jne    800a4d <strtol+0x5a>
		s += 2, base = 16;
  800a43:	83 c2 02             	add    $0x2,%edx
  800a46:	b8 10 00 00 00       	mov    $0x10,%eax
  800a4b:	eb 10                	jmp    800a5d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800a4d:	85 c0                	test   %eax,%eax
  800a4f:	75 0c                	jne    800a5d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a51:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a53:	80 3a 30             	cmpb   $0x30,(%edx)
  800a56:	75 05                	jne    800a5d <strtol+0x6a>
		s++, base = 8;
  800a58:	83 c2 01             	add    $0x1,%edx
  800a5b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800a5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a62:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a65:	0f b6 0a             	movzbl (%edx),%ecx
  800a68:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800a6b:	89 f0                	mov    %esi,%eax
  800a6d:	3c 09                	cmp    $0x9,%al
  800a6f:	77 08                	ja     800a79 <strtol+0x86>
			dig = *s - '0';
  800a71:	0f be c9             	movsbl %cl,%ecx
  800a74:	83 e9 30             	sub    $0x30,%ecx
  800a77:	eb 20                	jmp    800a99 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800a79:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800a7c:	89 f0                	mov    %esi,%eax
  800a7e:	3c 19                	cmp    $0x19,%al
  800a80:	77 08                	ja     800a8a <strtol+0x97>
			dig = *s - 'a' + 10;
  800a82:	0f be c9             	movsbl %cl,%ecx
  800a85:	83 e9 57             	sub    $0x57,%ecx
  800a88:	eb 0f                	jmp    800a99 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800a8a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800a8d:	89 f0                	mov    %esi,%eax
  800a8f:	3c 19                	cmp    $0x19,%al
  800a91:	77 16                	ja     800aa9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800a93:	0f be c9             	movsbl %cl,%ecx
  800a96:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800a99:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800a9c:	7d 0f                	jge    800aad <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800a9e:	83 c2 01             	add    $0x1,%edx
  800aa1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800aa5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800aa7:	eb bc                	jmp    800a65 <strtol+0x72>
  800aa9:	89 d8                	mov    %ebx,%eax
  800aab:	eb 02                	jmp    800aaf <strtol+0xbc>
  800aad:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800aaf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ab3:	74 05                	je     800aba <strtol+0xc7>
		*endptr = (char *) s;
  800ab5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ab8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800aba:	f7 d8                	neg    %eax
  800abc:	85 ff                	test   %edi,%edi
  800abe:	0f 44 c3             	cmove  %ebx,%eax
}
  800ac1:	5b                   	pop    %ebx
  800ac2:	5e                   	pop    %esi
  800ac3:	5f                   	pop    %edi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	57                   	push   %edi
  800aca:	56                   	push   %esi
  800acb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800acc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ad4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad7:	89 c3                	mov    %eax,%ebx
  800ad9:	89 c7                	mov    %eax,%edi
  800adb:	89 c6                	mov    %eax,%esi
  800add:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800adf:	5b                   	pop    %ebx
  800ae0:	5e                   	pop    %esi
  800ae1:	5f                   	pop    %edi
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	57                   	push   %edi
  800ae8:	56                   	push   %esi
  800ae9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800aea:	ba 00 00 00 00       	mov    $0x0,%edx
  800aef:	b8 01 00 00 00       	mov    $0x1,%eax
  800af4:	89 d1                	mov    %edx,%ecx
  800af6:	89 d3                	mov    %edx,%ebx
  800af8:	89 d7                	mov    %edx,%edi
  800afa:	89 d6                	mov    %edx,%esi
  800afc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800afe:	5b                   	pop    %ebx
  800aff:	5e                   	pop    %esi
  800b00:	5f                   	pop    %edi
  800b01:	5d                   	pop    %ebp
  800b02:	c3                   	ret    

00800b03 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b03:	55                   	push   %ebp
  800b04:	89 e5                	mov    %esp,%ebp
  800b06:	57                   	push   %edi
  800b07:	56                   	push   %esi
  800b08:	53                   	push   %ebx
  800b09:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b11:	b8 03 00 00 00       	mov    $0x3,%eax
  800b16:	8b 55 08             	mov    0x8(%ebp),%edx
  800b19:	89 cb                	mov    %ecx,%ebx
  800b1b:	89 cf                	mov    %ecx,%edi
  800b1d:	89 ce                	mov    %ecx,%esi
  800b1f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b21:	85 c0                	test   %eax,%eax
  800b23:	7e 28                	jle    800b4d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b25:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b29:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800b30:	00 
  800b31:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800b38:	00 
  800b39:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800b40:	00 
  800b41:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800b48:	e8 a9 16 00 00       	call   8021f6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b4d:	83 c4 2c             	add    $0x2c,%esp
  800b50:	5b                   	pop    %ebx
  800b51:	5e                   	pop    %esi
  800b52:	5f                   	pop    %edi
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	57                   	push   %edi
  800b59:	56                   	push   %esi
  800b5a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b60:	b8 02 00 00 00       	mov    $0x2,%eax
  800b65:	89 d1                	mov    %edx,%ecx
  800b67:	89 d3                	mov    %edx,%ebx
  800b69:	89 d7                	mov    %edx,%edi
  800b6b:	89 d6                	mov    %edx,%esi
  800b6d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b6f:	5b                   	pop    %ebx
  800b70:	5e                   	pop    %esi
  800b71:	5f                   	pop    %edi
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <sys_yield>:

void
sys_yield(void)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	57                   	push   %edi
  800b78:	56                   	push   %esi
  800b79:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b84:	89 d1                	mov    %edx,%ecx
  800b86:	89 d3                	mov    %edx,%ebx
  800b88:	89 d7                	mov    %edx,%edi
  800b8a:	89 d6                	mov    %edx,%esi
  800b8c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b8e:	5b                   	pop    %ebx
  800b8f:	5e                   	pop    %esi
  800b90:	5f                   	pop    %edi
  800b91:	5d                   	pop    %ebp
  800b92:	c3                   	ret    

00800b93 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
  800b96:	57                   	push   %edi
  800b97:	56                   	push   %esi
  800b98:	53                   	push   %ebx
  800b99:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b9c:	be 00 00 00 00       	mov    $0x0,%esi
  800ba1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ba6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800baf:	89 f7                	mov    %esi,%edi
  800bb1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800bb3:	85 c0                	test   %eax,%eax
  800bb5:	7e 28                	jle    800bdf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bbb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800bc2:	00 
  800bc3:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800bca:	00 
  800bcb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bd2:	00 
  800bd3:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800bda:	e8 17 16 00 00       	call   8021f6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bdf:	83 c4 2c             	add    $0x2c,%esp
  800be2:	5b                   	pop    %ebx
  800be3:	5e                   	pop    %esi
  800be4:	5f                   	pop    %edi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	57                   	push   %edi
  800beb:	56                   	push   %esi
  800bec:	53                   	push   %ebx
  800bed:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bf0:	b8 05 00 00 00       	mov    $0x5,%eax
  800bf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bfe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c01:	8b 75 18             	mov    0x18(%ebp),%esi
  800c04:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c06:	85 c0                	test   %eax,%eax
  800c08:	7e 28                	jle    800c32 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c0a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c0e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800c15:	00 
  800c16:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800c1d:	00 
  800c1e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c25:	00 
  800c26:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800c2d:	e8 c4 15 00 00       	call   8021f6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c32:	83 c4 2c             	add    $0x2c,%esp
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5f                   	pop    %edi
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    

00800c3a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	57                   	push   %edi
  800c3e:	56                   	push   %esi
  800c3f:	53                   	push   %ebx
  800c40:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c48:	b8 06 00 00 00       	mov    $0x6,%eax
  800c4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c50:	8b 55 08             	mov    0x8(%ebp),%edx
  800c53:	89 df                	mov    %ebx,%edi
  800c55:	89 de                	mov    %ebx,%esi
  800c57:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c59:	85 c0                	test   %eax,%eax
  800c5b:	7e 28                	jle    800c85 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c61:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800c68:	00 
  800c69:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800c70:	00 
  800c71:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c78:	00 
  800c79:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800c80:	e8 71 15 00 00       	call   8021f6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c85:	83 c4 2c             	add    $0x2c,%esp
  800c88:	5b                   	pop    %ebx
  800c89:	5e                   	pop    %esi
  800c8a:	5f                   	pop    %edi
  800c8b:	5d                   	pop    %ebp
  800c8c:	c3                   	ret    

00800c8d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c8d:	55                   	push   %ebp
  800c8e:	89 e5                	mov    %esp,%ebp
  800c90:	57                   	push   %edi
  800c91:	56                   	push   %esi
  800c92:	53                   	push   %ebx
  800c93:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c9b:	b8 08 00 00 00       	mov    $0x8,%eax
  800ca0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca6:	89 df                	mov    %ebx,%edi
  800ca8:	89 de                	mov    %ebx,%esi
  800caa:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cac:	85 c0                	test   %eax,%eax
  800cae:	7e 28                	jle    800cd8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cb4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800cbb:	00 
  800cbc:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800cc3:	00 
  800cc4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ccb:	00 
  800ccc:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800cd3:	e8 1e 15 00 00       	call   8021f6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cd8:	83 c4 2c             	add    $0x2c,%esp
  800cdb:	5b                   	pop    %ebx
  800cdc:	5e                   	pop    %esi
  800cdd:	5f                   	pop    %edi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	57                   	push   %edi
  800ce4:	56                   	push   %esi
  800ce5:	53                   	push   %ebx
  800ce6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cee:	b8 09 00 00 00       	mov    $0x9,%eax
  800cf3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf9:	89 df                	mov    %ebx,%edi
  800cfb:	89 de                	mov    %ebx,%esi
  800cfd:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cff:	85 c0                	test   %eax,%eax
  800d01:	7e 28                	jle    800d2b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d03:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d07:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d0e:	00 
  800d0f:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800d16:	00 
  800d17:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d1e:	00 
  800d1f:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800d26:	e8 cb 14 00 00       	call   8021f6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d2b:	83 c4 2c             	add    $0x2c,%esp
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d49:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4c:	89 df                	mov    %ebx,%edi
  800d4e:	89 de                	mov    %ebx,%esi
  800d50:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d52:	85 c0                	test   %eax,%eax
  800d54:	7e 28                	jle    800d7e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d56:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d5a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800d61:	00 
  800d62:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800d69:	00 
  800d6a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d71:	00 
  800d72:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800d79:	e8 78 14 00 00       	call   8021f6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d7e:	83 c4 2c             	add    $0x2c,%esp
  800d81:	5b                   	pop    %ebx
  800d82:	5e                   	pop    %esi
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	57                   	push   %edi
  800d8a:	56                   	push   %esi
  800d8b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8c:	be 00 00 00 00       	mov    $0x0,%esi
  800d91:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800da4:	5b                   	pop    %ebx
  800da5:	5e                   	pop    %esi
  800da6:	5f                   	pop    %edi
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    

00800da9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	57                   	push   %edi
  800dad:	56                   	push   %esi
  800dae:	53                   	push   %ebx
  800daf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800dbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbf:	89 cb                	mov    %ecx,%ebx
  800dc1:	89 cf                	mov    %ecx,%edi
  800dc3:	89 ce                	mov    %ecx,%esi
  800dc5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800dc7:	85 c0                	test   %eax,%eax
  800dc9:	7e 28                	jle    800df3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dcf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800dd6:	00 
  800dd7:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800dde:	00 
  800ddf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800de6:	00 
  800de7:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800dee:	e8 03 14 00 00       	call   8021f6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800df3:	83 c4 2c             	add    $0x2c,%esp
  800df6:	5b                   	pop    %ebx
  800df7:	5e                   	pop    %esi
  800df8:	5f                   	pop    %edi
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e01:	ba 00 00 00 00       	mov    $0x0,%edx
  800e06:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e0b:	89 d1                	mov    %edx,%ecx
  800e0d:	89 d3                	mov    %edx,%ebx
  800e0f:	89 d7                	mov    %edx,%edi
  800e11:	89 d6                	mov    %edx,%esi
  800e13:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e15:	5b                   	pop    %ebx
  800e16:	5e                   	pop    %esi
  800e17:	5f                   	pop    %edi
  800e18:	5d                   	pop    %ebp
  800e19:	c3                   	ret    

00800e1a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	57                   	push   %edi
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e20:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e25:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e30:	89 df                	mov    %ebx,%edi
  800e32:	89 de                	mov    %ebx,%esi
  800e34:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800e36:	5b                   	pop    %ebx
  800e37:	5e                   	pop    %esi
  800e38:	5f                   	pop    %edi
  800e39:	5d                   	pop    %ebp
  800e3a:	c3                   	ret    

00800e3b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
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
  800e41:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e46:	b8 10 00 00 00       	mov    $0x10,%eax
  800e4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e51:	89 df                	mov    %ebx,%edi
  800e53:	89 de                	mov    %ebx,%esi
  800e55:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800e57:	5b                   	pop    %ebx
  800e58:	5e                   	pop    %esi
  800e59:	5f                   	pop    %edi
  800e5a:	5d                   	pop    %ebp
  800e5b:	c3                   	ret    

00800e5c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	57                   	push   %edi
  800e60:	56                   	push   %esi
  800e61:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e67:	b8 11 00 00 00       	mov    $0x11,%eax
  800e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6f:	89 cb                	mov    %ecx,%ebx
  800e71:	89 cf                	mov    %ecx,%edi
  800e73:	89 ce                	mov    %ecx,%esi
  800e75:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800e77:	5b                   	pop    %ebx
  800e78:	5e                   	pop    %esi
  800e79:	5f                   	pop    %edi
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    

00800e7c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	57                   	push   %edi
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
  800e82:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e85:	be 00 00 00 00       	mov    $0x0,%esi
  800e8a:	b8 12 00 00 00       	mov    $0x12,%eax
  800e8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e92:	8b 55 08             	mov    0x8(%ebp),%edx
  800e95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e98:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e9b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e9d:	85 c0                	test   %eax,%eax
  800e9f:	7e 28                	jle    800ec9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800eac:	00 
  800ead:	c7 44 24 08 a7 29 80 	movl   $0x8029a7,0x8(%esp)
  800eb4:	00 
  800eb5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ebc:	00 
  800ebd:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  800ec4:	e8 2d 13 00 00       	call   8021f6 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  800ec9:	83 c4 2c             	add    $0x2c,%esp
  800ecc:	5b                   	pop    %ebx
  800ecd:	5e                   	pop    %esi
  800ece:	5f                   	pop    %edi
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    
  800ed1:	66 90                	xchg   %ax,%ax
  800ed3:	66 90                	xchg   %ax,%ax
  800ed5:	66 90                	xchg   %ax,%ax
  800ed7:	66 90                	xchg   %ax,%ax
  800ed9:	66 90                	xchg   %ax,%ax
  800edb:	66 90                	xchg   %ax,%ax
  800edd:	66 90                	xchg   %ax,%ax
  800edf:	90                   	nop

00800ee0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	05 00 00 00 30       	add    $0x30000000,%eax
  800eeb:	c1 e8 0c             	shr    $0xc,%eax
}
  800eee:	5d                   	pop    %ebp
  800eef:	c3                   	ret    

00800ef0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800efb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f00:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    

00800f07 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f0d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f12:	89 c2                	mov    %eax,%edx
  800f14:	c1 ea 16             	shr    $0x16,%edx
  800f17:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f1e:	f6 c2 01             	test   $0x1,%dl
  800f21:	74 11                	je     800f34 <fd_alloc+0x2d>
  800f23:	89 c2                	mov    %eax,%edx
  800f25:	c1 ea 0c             	shr    $0xc,%edx
  800f28:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f2f:	f6 c2 01             	test   $0x1,%dl
  800f32:	75 09                	jne    800f3d <fd_alloc+0x36>
			*fd_store = fd;
  800f34:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f36:	b8 00 00 00 00       	mov    $0x0,%eax
  800f3b:	eb 17                	jmp    800f54 <fd_alloc+0x4d>
  800f3d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f42:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f47:	75 c9                	jne    800f12 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f49:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f4f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800f54:	5d                   	pop    %ebp
  800f55:	c3                   	ret    

00800f56 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f5c:	83 f8 1f             	cmp    $0x1f,%eax
  800f5f:	77 36                	ja     800f97 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f61:	c1 e0 0c             	shl    $0xc,%eax
  800f64:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f69:	89 c2                	mov    %eax,%edx
  800f6b:	c1 ea 16             	shr    $0x16,%edx
  800f6e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f75:	f6 c2 01             	test   $0x1,%dl
  800f78:	74 24                	je     800f9e <fd_lookup+0x48>
  800f7a:	89 c2                	mov    %eax,%edx
  800f7c:	c1 ea 0c             	shr    $0xc,%edx
  800f7f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f86:	f6 c2 01             	test   $0x1,%dl
  800f89:	74 1a                	je     800fa5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8e:	89 02                	mov    %eax,(%edx)
	return 0;
  800f90:	b8 00 00 00 00       	mov    $0x0,%eax
  800f95:	eb 13                	jmp    800faa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800f97:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f9c:	eb 0c                	jmp    800faa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800f9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fa3:	eb 05                	jmp    800faa <fd_lookup+0x54>
  800fa5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    

00800fac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
  800faf:	83 ec 18             	sub    $0x18,%esp
  800fb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800fb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800fba:	eb 13                	jmp    800fcf <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  800fbc:	39 08                	cmp    %ecx,(%eax)
  800fbe:	75 0c                	jne    800fcc <dev_lookup+0x20>
			*dev = devtab[i];
  800fc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc3:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fc5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fca:	eb 38                	jmp    801004 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800fcc:	83 c2 01             	add    $0x1,%edx
  800fcf:	8b 04 95 50 2a 80 00 	mov    0x802a50(,%edx,4),%eax
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	75 e2                	jne    800fbc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fda:	a1 08 40 80 00       	mov    0x804008,%eax
  800fdf:	8b 40 48             	mov    0x48(%eax),%eax
  800fe2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800fe6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fea:	c7 04 24 d4 29 80 00 	movl   $0x8029d4,(%esp)
  800ff1:	e8 5e f1 ff ff       	call   800154 <cprintf>
	*dev = 0;
  800ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801004:	c9                   	leave  
  801005:	c3                   	ret    

00801006 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	56                   	push   %esi
  80100a:	53                   	push   %ebx
  80100b:	83 ec 20             	sub    $0x20,%esp
  80100e:	8b 75 08             	mov    0x8(%ebp),%esi
  801011:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801014:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801017:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80101b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801021:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801024:	89 04 24             	mov    %eax,(%esp)
  801027:	e8 2a ff ff ff       	call   800f56 <fd_lookup>
  80102c:	85 c0                	test   %eax,%eax
  80102e:	78 05                	js     801035 <fd_close+0x2f>
	    || fd != fd2)
  801030:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801033:	74 0c                	je     801041 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801035:	84 db                	test   %bl,%bl
  801037:	ba 00 00 00 00       	mov    $0x0,%edx
  80103c:	0f 44 c2             	cmove  %edx,%eax
  80103f:	eb 3f                	jmp    801080 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801041:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801044:	89 44 24 04          	mov    %eax,0x4(%esp)
  801048:	8b 06                	mov    (%esi),%eax
  80104a:	89 04 24             	mov    %eax,(%esp)
  80104d:	e8 5a ff ff ff       	call   800fac <dev_lookup>
  801052:	89 c3                	mov    %eax,%ebx
  801054:	85 c0                	test   %eax,%eax
  801056:	78 16                	js     80106e <fd_close+0x68>
		if (dev->dev_close)
  801058:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80105e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801063:	85 c0                	test   %eax,%eax
  801065:	74 07                	je     80106e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801067:	89 34 24             	mov    %esi,(%esp)
  80106a:	ff d0                	call   *%eax
  80106c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80106e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801072:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801079:	e8 bc fb ff ff       	call   800c3a <sys_page_unmap>
	return r;
  80107e:	89 d8                	mov    %ebx,%eax
}
  801080:	83 c4 20             	add    $0x20,%esp
  801083:	5b                   	pop    %ebx
  801084:	5e                   	pop    %esi
  801085:	5d                   	pop    %ebp
  801086:	c3                   	ret    

00801087 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80108d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801090:	89 44 24 04          	mov    %eax,0x4(%esp)
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	89 04 24             	mov    %eax,(%esp)
  80109a:	e8 b7 fe ff ff       	call   800f56 <fd_lookup>
  80109f:	89 c2                	mov    %eax,%edx
  8010a1:	85 d2                	test   %edx,%edx
  8010a3:	78 13                	js     8010b8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8010a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8010ac:	00 
  8010ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b0:	89 04 24             	mov    %eax,(%esp)
  8010b3:	e8 4e ff ff ff       	call   801006 <fd_close>
}
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <close_all>:

void
close_all(void)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	53                   	push   %ebx
  8010be:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010c6:	89 1c 24             	mov    %ebx,(%esp)
  8010c9:	e8 b9 ff ff ff       	call   801087 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8010ce:	83 c3 01             	add    $0x1,%ebx
  8010d1:	83 fb 20             	cmp    $0x20,%ebx
  8010d4:	75 f0                	jne    8010c6 <close_all+0xc>
		close(i);
}
  8010d6:	83 c4 14             	add    $0x14,%esp
  8010d9:	5b                   	pop    %ebx
  8010da:	5d                   	pop    %ebp
  8010db:	c3                   	ret    

008010dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	57                   	push   %edi
  8010e0:	56                   	push   %esi
  8010e1:	53                   	push   %ebx
  8010e2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	89 04 24             	mov    %eax,(%esp)
  8010f2:	e8 5f fe ff ff       	call   800f56 <fd_lookup>
  8010f7:	89 c2                	mov    %eax,%edx
  8010f9:	85 d2                	test   %edx,%edx
  8010fb:	0f 88 e1 00 00 00    	js     8011e2 <dup+0x106>
		return r;
	close(newfdnum);
  801101:	8b 45 0c             	mov    0xc(%ebp),%eax
  801104:	89 04 24             	mov    %eax,(%esp)
  801107:	e8 7b ff ff ff       	call   801087 <close>

	newfd = INDEX2FD(newfdnum);
  80110c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80110f:	c1 e3 0c             	shl    $0xc,%ebx
  801112:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80111b:	89 04 24             	mov    %eax,(%esp)
  80111e:	e8 cd fd ff ff       	call   800ef0 <fd2data>
  801123:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801125:	89 1c 24             	mov    %ebx,(%esp)
  801128:	e8 c3 fd ff ff       	call   800ef0 <fd2data>
  80112d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80112f:	89 f0                	mov    %esi,%eax
  801131:	c1 e8 16             	shr    $0x16,%eax
  801134:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80113b:	a8 01                	test   $0x1,%al
  80113d:	74 43                	je     801182 <dup+0xa6>
  80113f:	89 f0                	mov    %esi,%eax
  801141:	c1 e8 0c             	shr    $0xc,%eax
  801144:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80114b:	f6 c2 01             	test   $0x1,%dl
  80114e:	74 32                	je     801182 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801150:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801157:	25 07 0e 00 00       	and    $0xe07,%eax
  80115c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801160:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801164:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80116b:	00 
  80116c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801170:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801177:	e8 6b fa ff ff       	call   800be7 <sys_page_map>
  80117c:	89 c6                	mov    %eax,%esi
  80117e:	85 c0                	test   %eax,%eax
  801180:	78 3e                	js     8011c0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801182:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801185:	89 c2                	mov    %eax,%edx
  801187:	c1 ea 0c             	shr    $0xc,%edx
  80118a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801191:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801197:	89 54 24 10          	mov    %edx,0x10(%esp)
  80119b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80119f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011a6:	00 
  8011a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011b2:	e8 30 fa ff ff       	call   800be7 <sys_page_map>
  8011b7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011bc:	85 f6                	test   %esi,%esi
  8011be:	79 22                	jns    8011e2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8011c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011cb:	e8 6a fa ff ff       	call   800c3a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011db:	e8 5a fa ff ff       	call   800c3a <sys_page_unmap>
	return r;
  8011e0:	89 f0                	mov    %esi,%eax
}
  8011e2:	83 c4 3c             	add    $0x3c,%esp
  8011e5:	5b                   	pop    %ebx
  8011e6:	5e                   	pop    %esi
  8011e7:	5f                   	pop    %edi
  8011e8:	5d                   	pop    %ebp
  8011e9:	c3                   	ret    

008011ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	53                   	push   %ebx
  8011ee:	83 ec 24             	sub    $0x24,%esp
  8011f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011fb:	89 1c 24             	mov    %ebx,(%esp)
  8011fe:	e8 53 fd ff ff       	call   800f56 <fd_lookup>
  801203:	89 c2                	mov    %eax,%edx
  801205:	85 d2                	test   %edx,%edx
  801207:	78 6d                	js     801276 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801209:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80120c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801210:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801213:	8b 00                	mov    (%eax),%eax
  801215:	89 04 24             	mov    %eax,(%esp)
  801218:	e8 8f fd ff ff       	call   800fac <dev_lookup>
  80121d:	85 c0                	test   %eax,%eax
  80121f:	78 55                	js     801276 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801224:	8b 50 08             	mov    0x8(%eax),%edx
  801227:	83 e2 03             	and    $0x3,%edx
  80122a:	83 fa 01             	cmp    $0x1,%edx
  80122d:	75 23                	jne    801252 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80122f:	a1 08 40 80 00       	mov    0x804008,%eax
  801234:	8b 40 48             	mov    0x48(%eax),%eax
  801237:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80123b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80123f:	c7 04 24 15 2a 80 00 	movl   $0x802a15,(%esp)
  801246:	e8 09 ef ff ff       	call   800154 <cprintf>
		return -E_INVAL;
  80124b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801250:	eb 24                	jmp    801276 <read+0x8c>
	}
	if (!dev->dev_read)
  801252:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801255:	8b 52 08             	mov    0x8(%edx),%edx
  801258:	85 d2                	test   %edx,%edx
  80125a:	74 15                	je     801271 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80125c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80125f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801263:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801266:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80126a:	89 04 24             	mov    %eax,(%esp)
  80126d:	ff d2                	call   *%edx
  80126f:	eb 05                	jmp    801276 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801271:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801276:	83 c4 24             	add    $0x24,%esp
  801279:	5b                   	pop    %ebx
  80127a:	5d                   	pop    %ebp
  80127b:	c3                   	ret    

0080127c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
  80127f:	57                   	push   %edi
  801280:	56                   	push   %esi
  801281:	53                   	push   %ebx
  801282:	83 ec 1c             	sub    $0x1c,%esp
  801285:	8b 7d 08             	mov    0x8(%ebp),%edi
  801288:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80128b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801290:	eb 23                	jmp    8012b5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801292:	89 f0                	mov    %esi,%eax
  801294:	29 d8                	sub    %ebx,%eax
  801296:	89 44 24 08          	mov    %eax,0x8(%esp)
  80129a:	89 d8                	mov    %ebx,%eax
  80129c:	03 45 0c             	add    0xc(%ebp),%eax
  80129f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012a3:	89 3c 24             	mov    %edi,(%esp)
  8012a6:	e8 3f ff ff ff       	call   8011ea <read>
		if (m < 0)
  8012ab:	85 c0                	test   %eax,%eax
  8012ad:	78 10                	js     8012bf <readn+0x43>
			return m;
		if (m == 0)
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	74 0a                	je     8012bd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012b3:	01 c3                	add    %eax,%ebx
  8012b5:	39 f3                	cmp    %esi,%ebx
  8012b7:	72 d9                	jb     801292 <readn+0x16>
  8012b9:	89 d8                	mov    %ebx,%eax
  8012bb:	eb 02                	jmp    8012bf <readn+0x43>
  8012bd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8012bf:	83 c4 1c             	add    $0x1c,%esp
  8012c2:	5b                   	pop    %ebx
  8012c3:	5e                   	pop    %esi
  8012c4:	5f                   	pop    %edi
  8012c5:	5d                   	pop    %ebp
  8012c6:	c3                   	ret    

008012c7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	53                   	push   %ebx
  8012cb:	83 ec 24             	sub    $0x24,%esp
  8012ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012d8:	89 1c 24             	mov    %ebx,(%esp)
  8012db:	e8 76 fc ff ff       	call   800f56 <fd_lookup>
  8012e0:	89 c2                	mov    %eax,%edx
  8012e2:	85 d2                	test   %edx,%edx
  8012e4:	78 68                	js     80134e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f0:	8b 00                	mov    (%eax),%eax
  8012f2:	89 04 24             	mov    %eax,(%esp)
  8012f5:	e8 b2 fc ff ff       	call   800fac <dev_lookup>
  8012fa:	85 c0                	test   %eax,%eax
  8012fc:	78 50                	js     80134e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801301:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801305:	75 23                	jne    80132a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801307:	a1 08 40 80 00       	mov    0x804008,%eax
  80130c:	8b 40 48             	mov    0x48(%eax),%eax
  80130f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801313:	89 44 24 04          	mov    %eax,0x4(%esp)
  801317:	c7 04 24 31 2a 80 00 	movl   $0x802a31,(%esp)
  80131e:	e8 31 ee ff ff       	call   800154 <cprintf>
		return -E_INVAL;
  801323:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801328:	eb 24                	jmp    80134e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80132a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80132d:	8b 52 0c             	mov    0xc(%edx),%edx
  801330:	85 d2                	test   %edx,%edx
  801332:	74 15                	je     801349 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801334:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801337:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80133b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80133e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801342:	89 04 24             	mov    %eax,(%esp)
  801345:	ff d2                	call   *%edx
  801347:	eb 05                	jmp    80134e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801349:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80134e:	83 c4 24             	add    $0x24,%esp
  801351:	5b                   	pop    %ebx
  801352:	5d                   	pop    %ebp
  801353:	c3                   	ret    

00801354 <seek>:

int
seek(int fdnum, off_t offset)
{
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80135a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80135d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801361:	8b 45 08             	mov    0x8(%ebp),%eax
  801364:	89 04 24             	mov    %eax,(%esp)
  801367:	e8 ea fb ff ff       	call   800f56 <fd_lookup>
  80136c:	85 c0                	test   %eax,%eax
  80136e:	78 0e                	js     80137e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801370:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801373:	8b 55 0c             	mov    0xc(%ebp),%edx
  801376:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801379:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137e:	c9                   	leave  
  80137f:	c3                   	ret    

00801380 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	53                   	push   %ebx
  801384:	83 ec 24             	sub    $0x24,%esp
  801387:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80138a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80138d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801391:	89 1c 24             	mov    %ebx,(%esp)
  801394:	e8 bd fb ff ff       	call   800f56 <fd_lookup>
  801399:	89 c2                	mov    %eax,%edx
  80139b:	85 d2                	test   %edx,%edx
  80139d:	78 61                	js     801400 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80139f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a9:	8b 00                	mov    (%eax),%eax
  8013ab:	89 04 24             	mov    %eax,(%esp)
  8013ae:	e8 f9 fb ff ff       	call   800fac <dev_lookup>
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	78 49                	js     801400 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013be:	75 23                	jne    8013e3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8013c0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013c5:	8b 40 48             	mov    0x48(%eax),%eax
  8013c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d0:	c7 04 24 f4 29 80 00 	movl   $0x8029f4,(%esp)
  8013d7:	e8 78 ed ff ff       	call   800154 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8013dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e1:	eb 1d                	jmp    801400 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8013e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e6:	8b 52 18             	mov    0x18(%edx),%edx
  8013e9:	85 d2                	test   %edx,%edx
  8013eb:	74 0e                	je     8013fb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8013ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013f4:	89 04 24             	mov    %eax,(%esp)
  8013f7:	ff d2                	call   *%edx
  8013f9:	eb 05                	jmp    801400 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8013fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801400:	83 c4 24             	add    $0x24,%esp
  801403:	5b                   	pop    %ebx
  801404:	5d                   	pop    %ebp
  801405:	c3                   	ret    

00801406 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	53                   	push   %ebx
  80140a:	83 ec 24             	sub    $0x24,%esp
  80140d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801410:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801413:	89 44 24 04          	mov    %eax,0x4(%esp)
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	89 04 24             	mov    %eax,(%esp)
  80141d:	e8 34 fb ff ff       	call   800f56 <fd_lookup>
  801422:	89 c2                	mov    %eax,%edx
  801424:	85 d2                	test   %edx,%edx
  801426:	78 52                	js     80147a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801428:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80142b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801432:	8b 00                	mov    (%eax),%eax
  801434:	89 04 24             	mov    %eax,(%esp)
  801437:	e8 70 fb ff ff       	call   800fac <dev_lookup>
  80143c:	85 c0                	test   %eax,%eax
  80143e:	78 3a                	js     80147a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801443:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801447:	74 2c                	je     801475 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801449:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80144c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801453:	00 00 00 
	stat->st_isdir = 0;
  801456:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80145d:	00 00 00 
	stat->st_dev = dev;
  801460:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801466:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80146a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80146d:	89 14 24             	mov    %edx,(%esp)
  801470:	ff 50 14             	call   *0x14(%eax)
  801473:	eb 05                	jmp    80147a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801475:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80147a:	83 c4 24             	add    $0x24,%esp
  80147d:	5b                   	pop    %ebx
  80147e:	5d                   	pop    %ebp
  80147f:	c3                   	ret    

00801480 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	56                   	push   %esi
  801484:	53                   	push   %ebx
  801485:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801488:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80148f:	00 
  801490:	8b 45 08             	mov    0x8(%ebp),%eax
  801493:	89 04 24             	mov    %eax,(%esp)
  801496:	e8 84 02 00 00       	call   80171f <open>
  80149b:	89 c3                	mov    %eax,%ebx
  80149d:	85 db                	test   %ebx,%ebx
  80149f:	78 1b                	js     8014bc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8014a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a8:	89 1c 24             	mov    %ebx,(%esp)
  8014ab:	e8 56 ff ff ff       	call   801406 <fstat>
  8014b0:	89 c6                	mov    %eax,%esi
	close(fd);
  8014b2:	89 1c 24             	mov    %ebx,(%esp)
  8014b5:	e8 cd fb ff ff       	call   801087 <close>
	return r;
  8014ba:	89 f0                	mov    %esi,%eax
}
  8014bc:	83 c4 10             	add    $0x10,%esp
  8014bf:	5b                   	pop    %ebx
  8014c0:	5e                   	pop    %esi
  8014c1:	5d                   	pop    %ebp
  8014c2:	c3                   	ret    

008014c3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	56                   	push   %esi
  8014c7:	53                   	push   %ebx
  8014c8:	83 ec 10             	sub    $0x10,%esp
  8014cb:	89 c6                	mov    %eax,%esi
  8014cd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014cf:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014d6:	75 11                	jne    8014e9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8014df:	e8 61 0e 00 00       	call   802345 <ipc_find_env>
  8014e4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8014e9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8014f0:	00 
  8014f1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8014f8:	00 
  8014f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014fd:	a1 00 40 80 00       	mov    0x804000,%eax
  801502:	89 04 24             	mov    %eax,(%esp)
  801505:	e8 ae 0d 00 00       	call   8022b8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80150a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801511:	00 
  801512:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801516:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80151d:	e8 2e 0d 00 00       	call   802250 <ipc_recv>
}
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	5b                   	pop    %ebx
  801526:	5e                   	pop    %esi
  801527:	5d                   	pop    %ebp
  801528:	c3                   	ret    

00801529 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8b 40 0c             	mov    0xc(%eax),%eax
  801535:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80153a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801542:	ba 00 00 00 00       	mov    $0x0,%edx
  801547:	b8 02 00 00 00       	mov    $0x2,%eax
  80154c:	e8 72 ff ff ff       	call   8014c3 <fsipc>
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	8b 40 0c             	mov    0xc(%eax),%eax
  80155f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801564:	ba 00 00 00 00       	mov    $0x0,%edx
  801569:	b8 06 00 00 00       	mov    $0x6,%eax
  80156e:	e8 50 ff ff ff       	call   8014c3 <fsipc>
}
  801573:	c9                   	leave  
  801574:	c3                   	ret    

00801575 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801575:	55                   	push   %ebp
  801576:	89 e5                	mov    %esp,%ebp
  801578:	53                   	push   %ebx
  801579:	83 ec 14             	sub    $0x14,%esp
  80157c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	8b 40 0c             	mov    0xc(%eax),%eax
  801585:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80158a:	ba 00 00 00 00       	mov    $0x0,%edx
  80158f:	b8 05 00 00 00       	mov    $0x5,%eax
  801594:	e8 2a ff ff ff       	call   8014c3 <fsipc>
  801599:	89 c2                	mov    %eax,%edx
  80159b:	85 d2                	test   %edx,%edx
  80159d:	78 2b                	js     8015ca <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80159f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8015a6:	00 
  8015a7:	89 1c 24             	mov    %ebx,(%esp)
  8015aa:	e8 c8 f1 ff ff       	call   800777 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015af:	a1 80 50 80 00       	mov    0x805080,%eax
  8015b4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015ba:	a1 84 50 80 00       	mov    0x805084,%eax
  8015bf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ca:	83 c4 14             	add    $0x14,%esp
  8015cd:	5b                   	pop    %ebx
  8015ce:	5d                   	pop    %ebp
  8015cf:	c3                   	ret    

008015d0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8015d0:	55                   	push   %ebp
  8015d1:	89 e5                	mov    %esp,%ebp
  8015d3:	53                   	push   %ebx
  8015d4:	83 ec 14             	sub    $0x14,%esp
  8015d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  8015e5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8015eb:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8015f0:	0f 46 c3             	cmovbe %ebx,%eax
  8015f3:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8015f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801603:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80160a:	e8 05 f3 ff ff       	call   800914 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80160f:	ba 00 00 00 00       	mov    $0x0,%edx
  801614:	b8 04 00 00 00       	mov    $0x4,%eax
  801619:	e8 a5 fe ff ff       	call   8014c3 <fsipc>
  80161e:	85 c0                	test   %eax,%eax
  801620:	78 53                	js     801675 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801622:	39 c3                	cmp    %eax,%ebx
  801624:	73 24                	jae    80164a <devfile_write+0x7a>
  801626:	c7 44 24 0c 64 2a 80 	movl   $0x802a64,0xc(%esp)
  80162d:	00 
  80162e:	c7 44 24 08 6b 2a 80 	movl   $0x802a6b,0x8(%esp)
  801635:	00 
  801636:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  80163d:	00 
  80163e:	c7 04 24 80 2a 80 00 	movl   $0x802a80,(%esp)
  801645:	e8 ac 0b 00 00       	call   8021f6 <_panic>
	assert(r <= PGSIZE);
  80164a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80164f:	7e 24                	jle    801675 <devfile_write+0xa5>
  801651:	c7 44 24 0c 8b 2a 80 	movl   $0x802a8b,0xc(%esp)
  801658:	00 
  801659:	c7 44 24 08 6b 2a 80 	movl   $0x802a6b,0x8(%esp)
  801660:	00 
  801661:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801668:	00 
  801669:	c7 04 24 80 2a 80 00 	movl   $0x802a80,(%esp)
  801670:	e8 81 0b 00 00       	call   8021f6 <_panic>
	return r;
}
  801675:	83 c4 14             	add    $0x14,%esp
  801678:	5b                   	pop    %ebx
  801679:	5d                   	pop    %ebp
  80167a:	c3                   	ret    

0080167b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	56                   	push   %esi
  80167f:	53                   	push   %ebx
  801680:	83 ec 10             	sub    $0x10,%esp
  801683:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	8b 40 0c             	mov    0xc(%eax),%eax
  80168c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801691:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801697:	ba 00 00 00 00       	mov    $0x0,%edx
  80169c:	b8 03 00 00 00       	mov    $0x3,%eax
  8016a1:	e8 1d fe ff ff       	call   8014c3 <fsipc>
  8016a6:	89 c3                	mov    %eax,%ebx
  8016a8:	85 c0                	test   %eax,%eax
  8016aa:	78 6a                	js     801716 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8016ac:	39 c6                	cmp    %eax,%esi
  8016ae:	73 24                	jae    8016d4 <devfile_read+0x59>
  8016b0:	c7 44 24 0c 64 2a 80 	movl   $0x802a64,0xc(%esp)
  8016b7:	00 
  8016b8:	c7 44 24 08 6b 2a 80 	movl   $0x802a6b,0x8(%esp)
  8016bf:	00 
  8016c0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8016c7:	00 
  8016c8:	c7 04 24 80 2a 80 00 	movl   $0x802a80,(%esp)
  8016cf:	e8 22 0b 00 00       	call   8021f6 <_panic>
	assert(r <= PGSIZE);
  8016d4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016d9:	7e 24                	jle    8016ff <devfile_read+0x84>
  8016db:	c7 44 24 0c 8b 2a 80 	movl   $0x802a8b,0xc(%esp)
  8016e2:	00 
  8016e3:	c7 44 24 08 6b 2a 80 	movl   $0x802a6b,0x8(%esp)
  8016ea:	00 
  8016eb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8016f2:	00 
  8016f3:	c7 04 24 80 2a 80 00 	movl   $0x802a80,(%esp)
  8016fa:	e8 f7 0a 00 00       	call   8021f6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  801703:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80170a:	00 
  80170b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170e:	89 04 24             	mov    %eax,(%esp)
  801711:	e8 fe f1 ff ff       	call   800914 <memmove>
	return r;
}
  801716:	89 d8                	mov    %ebx,%eax
  801718:	83 c4 10             	add    $0x10,%esp
  80171b:	5b                   	pop    %ebx
  80171c:	5e                   	pop    %esi
  80171d:	5d                   	pop    %ebp
  80171e:	c3                   	ret    

0080171f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	53                   	push   %ebx
  801723:	83 ec 24             	sub    $0x24,%esp
  801726:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801729:	89 1c 24             	mov    %ebx,(%esp)
  80172c:	e8 0f f0 ff ff       	call   800740 <strlen>
  801731:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801736:	7f 60                	jg     801798 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801738:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80173b:	89 04 24             	mov    %eax,(%esp)
  80173e:	e8 c4 f7 ff ff       	call   800f07 <fd_alloc>
  801743:	89 c2                	mov    %eax,%edx
  801745:	85 d2                	test   %edx,%edx
  801747:	78 54                	js     80179d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801749:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80174d:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801754:	e8 1e f0 ff ff       	call   800777 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175c:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801761:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801764:	b8 01 00 00 00       	mov    $0x1,%eax
  801769:	e8 55 fd ff ff       	call   8014c3 <fsipc>
  80176e:	89 c3                	mov    %eax,%ebx
  801770:	85 c0                	test   %eax,%eax
  801772:	79 17                	jns    80178b <open+0x6c>
		fd_close(fd, 0);
  801774:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80177b:	00 
  80177c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177f:	89 04 24             	mov    %eax,(%esp)
  801782:	e8 7f f8 ff ff       	call   801006 <fd_close>
		return r;
  801787:	89 d8                	mov    %ebx,%eax
  801789:	eb 12                	jmp    80179d <open+0x7e>
	}

	return fd2num(fd);
  80178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178e:	89 04 24             	mov    %eax,(%esp)
  801791:	e8 4a f7 ff ff       	call   800ee0 <fd2num>
  801796:	eb 05                	jmp    80179d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801798:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80179d:	83 c4 24             	add    $0x24,%esp
  8017a0:	5b                   	pop    %ebx
  8017a1:	5d                   	pop    %ebp
  8017a2:	c3                   	ret    

008017a3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
  8017a6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8017b3:	e8 0b fd ff ff       	call   8014c3 <fsipc>
}
  8017b8:	c9                   	leave  
  8017b9:	c3                   	ret    
  8017ba:	66 90                	xchg   %ax,%ax
  8017bc:	66 90                	xchg   %ax,%ax
  8017be:	66 90                	xchg   %ax,%ax

008017c0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8017c6:	c7 44 24 04 97 2a 80 	movl   $0x802a97,0x4(%esp)
  8017cd:	00 
  8017ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d1:	89 04 24             	mov    %eax,(%esp)
  8017d4:	e8 9e ef ff ff       	call   800777 <strcpy>
	return 0;
}
  8017d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	53                   	push   %ebx
  8017e4:	83 ec 14             	sub    $0x14,%esp
  8017e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017ea:	89 1c 24             	mov    %ebx,(%esp)
  8017ed:	e8 8d 0b 00 00       	call   80237f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8017f2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8017f7:	83 f8 01             	cmp    $0x1,%eax
  8017fa:	75 0d                	jne    801809 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8017fc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8017ff:	89 04 24             	mov    %eax,(%esp)
  801802:	e8 29 03 00 00       	call   801b30 <nsipc_close>
  801807:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801809:	89 d0                	mov    %edx,%eax
  80180b:	83 c4 14             	add    $0x14,%esp
  80180e:	5b                   	pop    %ebx
  80180f:	5d                   	pop    %ebp
  801810:	c3                   	ret    

00801811 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801817:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80181e:	00 
  80181f:	8b 45 10             	mov    0x10(%ebp),%eax
  801822:	89 44 24 08          	mov    %eax,0x8(%esp)
  801826:	8b 45 0c             	mov    0xc(%ebp),%eax
  801829:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	8b 40 0c             	mov    0xc(%eax),%eax
  801833:	89 04 24             	mov    %eax,(%esp)
  801836:	e8 f0 03 00 00       	call   801c2b <nsipc_send>
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801843:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80184a:	00 
  80184b:	8b 45 10             	mov    0x10(%ebp),%eax
  80184e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801852:	8b 45 0c             	mov    0xc(%ebp),%eax
  801855:	89 44 24 04          	mov    %eax,0x4(%esp)
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	8b 40 0c             	mov    0xc(%eax),%eax
  80185f:	89 04 24             	mov    %eax,(%esp)
  801862:	e8 44 03 00 00       	call   801bab <nsipc_recv>
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80186f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801872:	89 54 24 04          	mov    %edx,0x4(%esp)
  801876:	89 04 24             	mov    %eax,(%esp)
  801879:	e8 d8 f6 ff ff       	call   800f56 <fd_lookup>
  80187e:	85 c0                	test   %eax,%eax
  801880:	78 17                	js     801899 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801885:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80188b:	39 08                	cmp    %ecx,(%eax)
  80188d:	75 05                	jne    801894 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80188f:	8b 40 0c             	mov    0xc(%eax),%eax
  801892:	eb 05                	jmp    801899 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801894:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	56                   	push   %esi
  80189f:	53                   	push   %ebx
  8018a0:	83 ec 20             	sub    $0x20,%esp
  8018a3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8018a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a8:	89 04 24             	mov    %eax,(%esp)
  8018ab:	e8 57 f6 ff ff       	call   800f07 <fd_alloc>
  8018b0:	89 c3                	mov    %eax,%ebx
  8018b2:	85 c0                	test   %eax,%eax
  8018b4:	78 21                	js     8018d7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018b6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8018bd:	00 
  8018be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018cc:	e8 c2 f2 ff ff       	call   800b93 <sys_page_alloc>
  8018d1:	89 c3                	mov    %eax,%ebx
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	79 0c                	jns    8018e3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8018d7:	89 34 24             	mov    %esi,(%esp)
  8018da:	e8 51 02 00 00       	call   801b30 <nsipc_close>
		return r;
  8018df:	89 d8                	mov    %ebx,%eax
  8018e1:	eb 20                	jmp    801903 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8018e3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ec:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8018f8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8018fb:	89 14 24             	mov    %edx,(%esp)
  8018fe:	e8 dd f5 ff ff       	call   800ee0 <fd2num>
}
  801903:	83 c4 20             	add    $0x20,%esp
  801906:	5b                   	pop    %ebx
  801907:	5e                   	pop    %esi
  801908:	5d                   	pop    %ebp
  801909:	c3                   	ret    

0080190a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	e8 51 ff ff ff       	call   801869 <fd2sockid>
		return r;
  801918:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80191a:	85 c0                	test   %eax,%eax
  80191c:	78 23                	js     801941 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80191e:	8b 55 10             	mov    0x10(%ebp),%edx
  801921:	89 54 24 08          	mov    %edx,0x8(%esp)
  801925:	8b 55 0c             	mov    0xc(%ebp),%edx
  801928:	89 54 24 04          	mov    %edx,0x4(%esp)
  80192c:	89 04 24             	mov    %eax,(%esp)
  80192f:	e8 45 01 00 00       	call   801a79 <nsipc_accept>
		return r;
  801934:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801936:	85 c0                	test   %eax,%eax
  801938:	78 07                	js     801941 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80193a:	e8 5c ff ff ff       	call   80189b <alloc_sockfd>
  80193f:	89 c1                	mov    %eax,%ecx
}
  801941:	89 c8                	mov    %ecx,%eax
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	e8 16 ff ff ff       	call   801869 <fd2sockid>
  801953:	89 c2                	mov    %eax,%edx
  801955:	85 d2                	test   %edx,%edx
  801957:	78 16                	js     80196f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801959:	8b 45 10             	mov    0x10(%ebp),%eax
  80195c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801960:	8b 45 0c             	mov    0xc(%ebp),%eax
  801963:	89 44 24 04          	mov    %eax,0x4(%esp)
  801967:	89 14 24             	mov    %edx,(%esp)
  80196a:	e8 60 01 00 00       	call   801acf <nsipc_bind>
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <shutdown>:

int
shutdown(int s, int how)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	e8 ea fe ff ff       	call   801869 <fd2sockid>
  80197f:	89 c2                	mov    %eax,%edx
  801981:	85 d2                	test   %edx,%edx
  801983:	78 0f                	js     801994 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801985:	8b 45 0c             	mov    0xc(%ebp),%eax
  801988:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198c:	89 14 24             	mov    %edx,(%esp)
  80198f:	e8 7a 01 00 00       	call   801b0e <nsipc_shutdown>
}
  801994:	c9                   	leave  
  801995:	c3                   	ret    

00801996 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	e8 c5 fe ff ff       	call   801869 <fd2sockid>
  8019a4:	89 c2                	mov    %eax,%edx
  8019a6:	85 d2                	test   %edx,%edx
  8019a8:	78 16                	js     8019c0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8019aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b8:	89 14 24             	mov    %edx,(%esp)
  8019bb:	e8 8a 01 00 00       	call   801b4a <nsipc_connect>
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <listen>:

int
listen(int s, int backlog)
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
  8019c5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	e8 99 fe ff ff       	call   801869 <fd2sockid>
  8019d0:	89 c2                	mov    %eax,%edx
  8019d2:	85 d2                	test   %edx,%edx
  8019d4:	78 0f                	js     8019e5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8019d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019dd:	89 14 24             	mov    %edx,(%esp)
  8019e0:	e8 a4 01 00 00       	call   801b89 <nsipc_listen>
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	89 04 24             	mov    %eax,(%esp)
  801a01:	e8 98 02 00 00       	call   801c9e <nsipc_socket>
  801a06:	89 c2                	mov    %eax,%edx
  801a08:	85 d2                	test   %edx,%edx
  801a0a:	78 05                	js     801a11 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801a0c:	e8 8a fe ff ff       	call   80189b <alloc_sockfd>
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	53                   	push   %ebx
  801a17:	83 ec 14             	sub    $0x14,%esp
  801a1a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a1c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a23:	75 11                	jne    801a36 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a25:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801a2c:	e8 14 09 00 00       	call   802345 <ipc_find_env>
  801a31:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a36:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a3d:	00 
  801a3e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a45:	00 
  801a46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a4a:	a1 04 40 80 00       	mov    0x804004,%eax
  801a4f:	89 04 24             	mov    %eax,(%esp)
  801a52:	e8 61 08 00 00       	call   8022b8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a57:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a5e:	00 
  801a5f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a66:	00 
  801a67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a6e:	e8 dd 07 00 00       	call   802250 <ipc_recv>
}
  801a73:	83 c4 14             	add    $0x14,%esp
  801a76:	5b                   	pop    %ebx
  801a77:	5d                   	pop    %ebp
  801a78:	c3                   	ret    

00801a79 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	56                   	push   %esi
  801a7d:	53                   	push   %ebx
  801a7e:	83 ec 10             	sub    $0x10,%esp
  801a81:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a84:	8b 45 08             	mov    0x8(%ebp),%eax
  801a87:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a8c:	8b 06                	mov    (%esi),%eax
  801a8e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a93:	b8 01 00 00 00       	mov    $0x1,%eax
  801a98:	e8 76 ff ff ff       	call   801a13 <nsipc>
  801a9d:	89 c3                	mov    %eax,%ebx
  801a9f:	85 c0                	test   %eax,%eax
  801aa1:	78 23                	js     801ac6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801aa3:	a1 10 60 80 00       	mov    0x806010,%eax
  801aa8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aac:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ab3:	00 
  801ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab7:	89 04 24             	mov    %eax,(%esp)
  801aba:	e8 55 ee ff ff       	call   800914 <memmove>
		*addrlen = ret->ret_addrlen;
  801abf:	a1 10 60 80 00       	mov    0x806010,%eax
  801ac4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801ac6:	89 d8                	mov    %ebx,%eax
  801ac8:	83 c4 10             	add    $0x10,%esp
  801acb:	5b                   	pop    %ebx
  801acc:	5e                   	pop    %esi
  801acd:	5d                   	pop    %ebp
  801ace:	c3                   	ret    

00801acf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	53                   	push   %ebx
  801ad3:	83 ec 14             	sub    $0x14,%esp
  801ad6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ae1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aec:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801af3:	e8 1c ee ff ff       	call   800914 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801af8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801afe:	b8 02 00 00 00       	mov    $0x2,%eax
  801b03:	e8 0b ff ff ff       	call   801a13 <nsipc>
}
  801b08:	83 c4 14             	add    $0x14,%esp
  801b0b:	5b                   	pop    %ebx
  801b0c:	5d                   	pop    %ebp
  801b0d:	c3                   	ret    

00801b0e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b24:	b8 03 00 00 00       	mov    $0x3,%eax
  801b29:	e8 e5 fe ff ff       	call   801a13 <nsipc>
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <nsipc_close>:

int
nsipc_close(int s)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b3e:	b8 04 00 00 00       	mov    $0x4,%eax
  801b43:	e8 cb fe ff ff       	call   801a13 <nsipc>
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	53                   	push   %ebx
  801b4e:	83 ec 14             	sub    $0x14,%esp
  801b51:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b5c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b67:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801b6e:	e8 a1 ed ff ff       	call   800914 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b73:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b79:	b8 05 00 00 00       	mov    $0x5,%eax
  801b7e:	e8 90 fe ff ff       	call   801a13 <nsipc>
}
  801b83:	83 c4 14             	add    $0x14,%esp
  801b86:	5b                   	pop    %ebx
  801b87:	5d                   	pop    %ebp
  801b88:	c3                   	ret    

00801b89 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b9f:	b8 06 00 00 00       	mov    $0x6,%eax
  801ba4:	e8 6a fe ff ff       	call   801a13 <nsipc>
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	56                   	push   %esi
  801baf:	53                   	push   %ebx
  801bb0:	83 ec 10             	sub    $0x10,%esp
  801bb3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bbe:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bc4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bc7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bcc:	b8 07 00 00 00       	mov    $0x7,%eax
  801bd1:	e8 3d fe ff ff       	call   801a13 <nsipc>
  801bd6:	89 c3                	mov    %eax,%ebx
  801bd8:	85 c0                	test   %eax,%eax
  801bda:	78 46                	js     801c22 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801bdc:	39 f0                	cmp    %esi,%eax
  801bde:	7f 07                	jg     801be7 <nsipc_recv+0x3c>
  801be0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801be5:	7e 24                	jle    801c0b <nsipc_recv+0x60>
  801be7:	c7 44 24 0c a3 2a 80 	movl   $0x802aa3,0xc(%esp)
  801bee:	00 
  801bef:	c7 44 24 08 6b 2a 80 	movl   $0x802a6b,0x8(%esp)
  801bf6:	00 
  801bf7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801bfe:	00 
  801bff:	c7 04 24 b8 2a 80 00 	movl   $0x802ab8,(%esp)
  801c06:	e8 eb 05 00 00       	call   8021f6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c0b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c0f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c16:	00 
  801c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c1a:	89 04 24             	mov    %eax,(%esp)
  801c1d:	e8 f2 ec ff ff       	call   800914 <memmove>
	}

	return r;
}
  801c22:	89 d8                	mov    %ebx,%eax
  801c24:	83 c4 10             	add    $0x10,%esp
  801c27:	5b                   	pop    %ebx
  801c28:	5e                   	pop    %esi
  801c29:	5d                   	pop    %ebp
  801c2a:	c3                   	ret    

00801c2b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	53                   	push   %ebx
  801c2f:	83 ec 14             	sub    $0x14,%esp
  801c32:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c3d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c43:	7e 24                	jle    801c69 <nsipc_send+0x3e>
  801c45:	c7 44 24 0c c4 2a 80 	movl   $0x802ac4,0xc(%esp)
  801c4c:	00 
  801c4d:	c7 44 24 08 6b 2a 80 	movl   $0x802a6b,0x8(%esp)
  801c54:	00 
  801c55:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801c5c:	00 
  801c5d:	c7 04 24 b8 2a 80 00 	movl   $0x802ab8,(%esp)
  801c64:	e8 8d 05 00 00       	call   8021f6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c69:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c70:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c74:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801c7b:	e8 94 ec ff ff       	call   800914 <memmove>
	nsipcbuf.send.req_size = size;
  801c80:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c86:	8b 45 14             	mov    0x14(%ebp),%eax
  801c89:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c8e:	b8 08 00 00 00       	mov    $0x8,%eax
  801c93:	e8 7b fd ff ff       	call   801a13 <nsipc>
}
  801c98:	83 c4 14             	add    $0x14,%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5d                   	pop    %ebp
  801c9d:	c3                   	ret    

00801c9e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801caf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cb4:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cbc:	b8 09 00 00 00       	mov    $0x9,%eax
  801cc1:	e8 4d fd ff ff       	call   801a13 <nsipc>
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	56                   	push   %esi
  801ccc:	53                   	push   %ebx
  801ccd:	83 ec 10             	sub    $0x10,%esp
  801cd0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd6:	89 04 24             	mov    %eax,(%esp)
  801cd9:	e8 12 f2 ff ff       	call   800ef0 <fd2data>
  801cde:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ce0:	c7 44 24 04 d0 2a 80 	movl   $0x802ad0,0x4(%esp)
  801ce7:	00 
  801ce8:	89 1c 24             	mov    %ebx,(%esp)
  801ceb:	e8 87 ea ff ff       	call   800777 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cf0:	8b 46 04             	mov    0x4(%esi),%eax
  801cf3:	2b 06                	sub    (%esi),%eax
  801cf5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cfb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d02:	00 00 00 
	stat->st_dev = &devpipe;
  801d05:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d0c:	30 80 00 
	return 0;
}
  801d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d14:	83 c4 10             	add    $0x10,%esp
  801d17:	5b                   	pop    %ebx
  801d18:	5e                   	pop    %esi
  801d19:	5d                   	pop    %ebp
  801d1a:	c3                   	ret    

00801d1b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
  801d1e:	53                   	push   %ebx
  801d1f:	83 ec 14             	sub    $0x14,%esp
  801d22:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d25:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d30:	e8 05 ef ff ff       	call   800c3a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d35:	89 1c 24             	mov    %ebx,(%esp)
  801d38:	e8 b3 f1 ff ff       	call   800ef0 <fd2data>
  801d3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d48:	e8 ed ee ff ff       	call   800c3a <sys_page_unmap>
}
  801d4d:	83 c4 14             	add    $0x14,%esp
  801d50:	5b                   	pop    %ebx
  801d51:	5d                   	pop    %ebp
  801d52:	c3                   	ret    

00801d53 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	57                   	push   %edi
  801d57:	56                   	push   %esi
  801d58:	53                   	push   %ebx
  801d59:	83 ec 2c             	sub    $0x2c,%esp
  801d5c:	89 c6                	mov    %eax,%esi
  801d5e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801d61:	a1 08 40 80 00       	mov    0x804008,%eax
  801d66:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d69:	89 34 24             	mov    %esi,(%esp)
  801d6c:	e8 0e 06 00 00       	call   80237f <pageref>
  801d71:	89 c7                	mov    %eax,%edi
  801d73:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d76:	89 04 24             	mov    %eax,(%esp)
  801d79:	e8 01 06 00 00       	call   80237f <pageref>
  801d7e:	39 c7                	cmp    %eax,%edi
  801d80:	0f 94 c2             	sete   %dl
  801d83:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801d86:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801d8c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801d8f:	39 fb                	cmp    %edi,%ebx
  801d91:	74 21                	je     801db4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801d93:	84 d2                	test   %dl,%dl
  801d95:	74 ca                	je     801d61 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d97:	8b 51 58             	mov    0x58(%ecx),%edx
  801d9a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d9e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801da2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801da6:	c7 04 24 d7 2a 80 00 	movl   $0x802ad7,(%esp)
  801dad:	e8 a2 e3 ff ff       	call   800154 <cprintf>
  801db2:	eb ad                	jmp    801d61 <_pipeisclosed+0xe>
	}
}
  801db4:	83 c4 2c             	add    $0x2c,%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5f                   	pop    %edi
  801dba:	5d                   	pop    %ebp
  801dbb:	c3                   	ret    

00801dbc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	57                   	push   %edi
  801dc0:	56                   	push   %esi
  801dc1:	53                   	push   %ebx
  801dc2:	83 ec 1c             	sub    $0x1c,%esp
  801dc5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801dc8:	89 34 24             	mov    %esi,(%esp)
  801dcb:	e8 20 f1 ff ff       	call   800ef0 <fd2data>
  801dd0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801dd2:	bf 00 00 00 00       	mov    $0x0,%edi
  801dd7:	eb 45                	jmp    801e1e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801dd9:	89 da                	mov    %ebx,%edx
  801ddb:	89 f0                	mov    %esi,%eax
  801ddd:	e8 71 ff ff ff       	call   801d53 <_pipeisclosed>
  801de2:	85 c0                	test   %eax,%eax
  801de4:	75 41                	jne    801e27 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801de6:	e8 89 ed ff ff       	call   800b74 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801deb:	8b 43 04             	mov    0x4(%ebx),%eax
  801dee:	8b 0b                	mov    (%ebx),%ecx
  801df0:	8d 51 20             	lea    0x20(%ecx),%edx
  801df3:	39 d0                	cmp    %edx,%eax
  801df5:	73 e2                	jae    801dd9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801df7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dfa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dfe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e01:	99                   	cltd   
  801e02:	c1 ea 1b             	shr    $0x1b,%edx
  801e05:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801e08:	83 e1 1f             	and    $0x1f,%ecx
  801e0b:	29 d1                	sub    %edx,%ecx
  801e0d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801e11:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801e15:	83 c0 01             	add    $0x1,%eax
  801e18:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e1b:	83 c7 01             	add    $0x1,%edi
  801e1e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e21:	75 c8                	jne    801deb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801e23:	89 f8                	mov    %edi,%eax
  801e25:	eb 05                	jmp    801e2c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e27:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801e2c:	83 c4 1c             	add    $0x1c,%esp
  801e2f:	5b                   	pop    %ebx
  801e30:	5e                   	pop    %esi
  801e31:	5f                   	pop    %edi
  801e32:	5d                   	pop    %ebp
  801e33:	c3                   	ret    

00801e34 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	57                   	push   %edi
  801e38:	56                   	push   %esi
  801e39:	53                   	push   %ebx
  801e3a:	83 ec 1c             	sub    $0x1c,%esp
  801e3d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801e40:	89 3c 24             	mov    %edi,(%esp)
  801e43:	e8 a8 f0 ff ff       	call   800ef0 <fd2data>
  801e48:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e4a:	be 00 00 00 00       	mov    $0x0,%esi
  801e4f:	eb 3d                	jmp    801e8e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801e51:	85 f6                	test   %esi,%esi
  801e53:	74 04                	je     801e59 <devpipe_read+0x25>
				return i;
  801e55:	89 f0                	mov    %esi,%eax
  801e57:	eb 43                	jmp    801e9c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801e59:	89 da                	mov    %ebx,%edx
  801e5b:	89 f8                	mov    %edi,%eax
  801e5d:	e8 f1 fe ff ff       	call   801d53 <_pipeisclosed>
  801e62:	85 c0                	test   %eax,%eax
  801e64:	75 31                	jne    801e97 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801e66:	e8 09 ed ff ff       	call   800b74 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801e6b:	8b 03                	mov    (%ebx),%eax
  801e6d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e70:	74 df                	je     801e51 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e72:	99                   	cltd   
  801e73:	c1 ea 1b             	shr    $0x1b,%edx
  801e76:	01 d0                	add    %edx,%eax
  801e78:	83 e0 1f             	and    $0x1f,%eax
  801e7b:	29 d0                	sub    %edx,%eax
  801e7d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e85:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e88:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e8b:	83 c6 01             	add    $0x1,%esi
  801e8e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e91:	75 d8                	jne    801e6b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801e93:	89 f0                	mov    %esi,%eax
  801e95:	eb 05                	jmp    801e9c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e97:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801e9c:	83 c4 1c             	add    $0x1c,%esp
  801e9f:	5b                   	pop    %ebx
  801ea0:	5e                   	pop    %esi
  801ea1:	5f                   	pop    %edi
  801ea2:	5d                   	pop    %ebp
  801ea3:	c3                   	ret    

00801ea4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	56                   	push   %esi
  801ea8:	53                   	push   %ebx
  801ea9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801eac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eaf:	89 04 24             	mov    %eax,(%esp)
  801eb2:	e8 50 f0 ff ff       	call   800f07 <fd_alloc>
  801eb7:	89 c2                	mov    %eax,%edx
  801eb9:	85 d2                	test   %edx,%edx
  801ebb:	0f 88 4d 01 00 00    	js     80200e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ec1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ec8:	00 
  801ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ed7:	e8 b7 ec ff ff       	call   800b93 <sys_page_alloc>
  801edc:	89 c2                	mov    %eax,%edx
  801ede:	85 d2                	test   %edx,%edx
  801ee0:	0f 88 28 01 00 00    	js     80200e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801ee6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ee9:	89 04 24             	mov    %eax,(%esp)
  801eec:	e8 16 f0 ff ff       	call   800f07 <fd_alloc>
  801ef1:	89 c3                	mov    %eax,%ebx
  801ef3:	85 c0                	test   %eax,%eax
  801ef5:	0f 88 fe 00 00 00    	js     801ff9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801efb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f02:	00 
  801f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f06:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f0a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f11:	e8 7d ec ff ff       	call   800b93 <sys_page_alloc>
  801f16:	89 c3                	mov    %eax,%ebx
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	0f 88 d9 00 00 00    	js     801ff9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f23:	89 04 24             	mov    %eax,(%esp)
  801f26:	e8 c5 ef ff ff       	call   800ef0 <fd2data>
  801f2b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f2d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f34:	00 
  801f35:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f39:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f40:	e8 4e ec ff ff       	call   800b93 <sys_page_alloc>
  801f45:	89 c3                	mov    %eax,%ebx
  801f47:	85 c0                	test   %eax,%eax
  801f49:	0f 88 97 00 00 00    	js     801fe6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f52:	89 04 24             	mov    %eax,(%esp)
  801f55:	e8 96 ef ff ff       	call   800ef0 <fd2data>
  801f5a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801f61:	00 
  801f62:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f66:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f6d:	00 
  801f6e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f79:	e8 69 ec ff ff       	call   800be7 <sys_page_map>
  801f7e:	89 c3                	mov    %eax,%ebx
  801f80:	85 c0                	test   %eax,%eax
  801f82:	78 52                	js     801fd6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801f84:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801f99:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb1:	89 04 24             	mov    %eax,(%esp)
  801fb4:	e8 27 ef ff ff       	call   800ee0 <fd2num>
  801fb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fbc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc1:	89 04 24             	mov    %eax,(%esp)
  801fc4:	e8 17 ef ff ff       	call   800ee0 <fd2num>
  801fc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fcc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd4:	eb 38                	jmp    80200e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801fd6:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe1:	e8 54 ec ff ff       	call   800c3a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ff4:	e8 41 ec ff ff       	call   800c3a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802000:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802007:	e8 2e ec ff ff       	call   800c3a <sys_page_unmap>
  80200c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80200e:	83 c4 30             	add    $0x30,%esp
  802011:	5b                   	pop    %ebx
  802012:	5e                   	pop    %esi
  802013:	5d                   	pop    %ebp
  802014:	c3                   	ret    

00802015 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80201b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80201e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	89 04 24             	mov    %eax,(%esp)
  802028:	e8 29 ef ff ff       	call   800f56 <fd_lookup>
  80202d:	89 c2                	mov    %eax,%edx
  80202f:	85 d2                	test   %edx,%edx
  802031:	78 15                	js     802048 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802036:	89 04 24             	mov    %eax,(%esp)
  802039:	e8 b2 ee ff ff       	call   800ef0 <fd2data>
	return _pipeisclosed(fd, p);
  80203e:	89 c2                	mov    %eax,%edx
  802040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802043:	e8 0b fd ff ff       	call   801d53 <_pipeisclosed>
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    
  80204a:	66 90                	xchg   %ax,%ax
  80204c:	66 90                	xchg   %ax,%ax
  80204e:	66 90                	xchg   %ax,%ax

00802050 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802053:	b8 00 00 00 00       	mov    $0x0,%eax
  802058:	5d                   	pop    %ebp
  802059:	c3                   	ret    

0080205a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802060:	c7 44 24 04 ef 2a 80 	movl   $0x802aef,0x4(%esp)
  802067:	00 
  802068:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206b:	89 04 24             	mov    %eax,(%esp)
  80206e:	e8 04 e7 ff ff       	call   800777 <strcpy>
	return 0;
}
  802073:	b8 00 00 00 00       	mov    $0x0,%eax
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	57                   	push   %edi
  80207e:	56                   	push   %esi
  80207f:	53                   	push   %ebx
  802080:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802086:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80208b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802091:	eb 31                	jmp    8020c4 <devcons_write+0x4a>
		m = n - tot;
  802093:	8b 75 10             	mov    0x10(%ebp),%esi
  802096:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802098:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80209b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8020a0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8020a3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8020a7:	03 45 0c             	add    0xc(%ebp),%eax
  8020aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ae:	89 3c 24             	mov    %edi,(%esp)
  8020b1:	e8 5e e8 ff ff       	call   800914 <memmove>
		sys_cputs(buf, m);
  8020b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020ba:	89 3c 24             	mov    %edi,(%esp)
  8020bd:	e8 04 ea ff ff       	call   800ac6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020c2:	01 f3                	add    %esi,%ebx
  8020c4:	89 d8                	mov    %ebx,%eax
  8020c6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8020c9:	72 c8                	jb     802093 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8020cb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8020d1:	5b                   	pop    %ebx
  8020d2:	5e                   	pop    %esi
  8020d3:	5f                   	pop    %edi
  8020d4:	5d                   	pop    %ebp
  8020d5:	c3                   	ret    

008020d6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8020dc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8020e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020e5:	75 07                	jne    8020ee <devcons_read+0x18>
  8020e7:	eb 2a                	jmp    802113 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8020e9:	e8 86 ea ff ff       	call   800b74 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8020ee:	66 90                	xchg   %ax,%ax
  8020f0:	e8 ef e9 ff ff       	call   800ae4 <sys_cgetc>
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	74 f0                	je     8020e9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8020f9:	85 c0                	test   %eax,%eax
  8020fb:	78 16                	js     802113 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8020fd:	83 f8 04             	cmp    $0x4,%eax
  802100:	74 0c                	je     80210e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802102:	8b 55 0c             	mov    0xc(%ebp),%edx
  802105:	88 02                	mov    %al,(%edx)
	return 1;
  802107:	b8 01 00 00 00       	mov    $0x1,%eax
  80210c:	eb 05                	jmp    802113 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80210e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802121:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802128:	00 
  802129:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80212c:	89 04 24             	mov    %eax,(%esp)
  80212f:	e8 92 e9 ff ff       	call   800ac6 <sys_cputs>
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <getchar>:

int
getchar(void)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80213c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802143:	00 
  802144:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802147:	89 44 24 04          	mov    %eax,0x4(%esp)
  80214b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802152:	e8 93 f0 ff ff       	call   8011ea <read>
	if (r < 0)
  802157:	85 c0                	test   %eax,%eax
  802159:	78 0f                	js     80216a <getchar+0x34>
		return r;
	if (r < 1)
  80215b:	85 c0                	test   %eax,%eax
  80215d:	7e 06                	jle    802165 <getchar+0x2f>
		return -E_EOF;
	return c;
  80215f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802163:	eb 05                	jmp    80216a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802165:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802172:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802175:	89 44 24 04          	mov    %eax,0x4(%esp)
  802179:	8b 45 08             	mov    0x8(%ebp),%eax
  80217c:	89 04 24             	mov    %eax,(%esp)
  80217f:	e8 d2 ed ff ff       	call   800f56 <fd_lookup>
  802184:	85 c0                	test   %eax,%eax
  802186:	78 11                	js     802199 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802191:	39 10                	cmp    %edx,(%eax)
  802193:	0f 94 c0             	sete   %al
  802196:	0f b6 c0             	movzbl %al,%eax
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <opencons>:

int
opencons(void)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8021a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021a4:	89 04 24             	mov    %eax,(%esp)
  8021a7:	e8 5b ed ff ff       	call   800f07 <fd_alloc>
		return r;
  8021ac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8021ae:	85 c0                	test   %eax,%eax
  8021b0:	78 40                	js     8021f2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021b2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021b9:	00 
  8021ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021c8:	e8 c6 e9 ff ff       	call   800b93 <sys_page_alloc>
		return r;
  8021cd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021cf:	85 c0                	test   %eax,%eax
  8021d1:	78 1f                	js     8021f2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8021d3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021e8:	89 04 24             	mov    %eax,(%esp)
  8021eb:	e8 f0 ec ff ff       	call   800ee0 <fd2num>
  8021f0:	89 c2                	mov    %eax,%edx
}
  8021f2:	89 d0                	mov    %edx,%eax
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	56                   	push   %esi
  8021fa:	53                   	push   %ebx
  8021fb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8021fe:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802201:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802207:	e8 49 e9 ff ff       	call   800b55 <sys_getenvid>
  80220c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802213:	8b 55 08             	mov    0x8(%ebp),%edx
  802216:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80221a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80221e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802222:	c7 04 24 fc 2a 80 00 	movl   $0x802afc,(%esp)
  802229:	e8 26 df ff ff       	call   800154 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80222e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802232:	8b 45 10             	mov    0x10(%ebp),%eax
  802235:	89 04 24             	mov    %eax,(%esp)
  802238:	e8 b6 de ff ff       	call   8000f3 <vcprintf>
	cprintf("\n");
  80223d:	c7 04 24 e8 2a 80 00 	movl   $0x802ae8,(%esp)
  802244:	e8 0b df ff ff       	call   800154 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802249:	cc                   	int3   
  80224a:	eb fd                	jmp    802249 <_panic+0x53>
  80224c:	66 90                	xchg   %ax,%ax
  80224e:	66 90                	xchg   %ax,%ax

00802250 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	56                   	push   %esi
  802254:	53                   	push   %ebx
  802255:	83 ec 10             	sub    $0x10,%esp
  802258:	8b 75 08             	mov    0x8(%ebp),%esi
  80225b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802261:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802263:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802268:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80226b:	89 04 24             	mov    %eax,(%esp)
  80226e:	e8 36 eb ff ff       	call   800da9 <sys_ipc_recv>
  802273:	85 c0                	test   %eax,%eax
  802275:	74 16                	je     80228d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802277:	85 f6                	test   %esi,%esi
  802279:	74 06                	je     802281 <ipc_recv+0x31>
			*from_env_store = 0;
  80227b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802281:	85 db                	test   %ebx,%ebx
  802283:	74 2c                	je     8022b1 <ipc_recv+0x61>
			*perm_store = 0;
  802285:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80228b:	eb 24                	jmp    8022b1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80228d:	85 f6                	test   %esi,%esi
  80228f:	74 0a                	je     80229b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802291:	a1 08 40 80 00       	mov    0x804008,%eax
  802296:	8b 40 74             	mov    0x74(%eax),%eax
  802299:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80229b:	85 db                	test   %ebx,%ebx
  80229d:	74 0a                	je     8022a9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80229f:	a1 08 40 80 00       	mov    0x804008,%eax
  8022a4:	8b 40 78             	mov    0x78(%eax),%eax
  8022a7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8022a9:	a1 08 40 80 00       	mov    0x804008,%eax
  8022ae:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022b1:	83 c4 10             	add    $0x10,%esp
  8022b4:	5b                   	pop    %ebx
  8022b5:	5e                   	pop    %esi
  8022b6:	5d                   	pop    %ebp
  8022b7:	c3                   	ret    

008022b8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	57                   	push   %edi
  8022bc:	56                   	push   %esi
  8022bd:	53                   	push   %ebx
  8022be:	83 ec 1c             	sub    $0x1c,%esp
  8022c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022c7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8022ca:	85 db                	test   %ebx,%ebx
  8022cc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8022d1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8022d4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	89 04 24             	mov    %eax,(%esp)
  8022e6:	e8 9b ea ff ff       	call   800d86 <sys_ipc_try_send>
	if (r == 0) return;
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	75 22                	jne    802311 <ipc_send+0x59>
  8022ef:	eb 4c                	jmp    80233d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  8022f1:	84 d2                	test   %dl,%dl
  8022f3:	75 48                	jne    80233d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  8022f5:	e8 7a e8 ff ff       	call   800b74 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  8022fa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022fe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802302:	89 74 24 04          	mov    %esi,0x4(%esp)
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	89 04 24             	mov    %eax,(%esp)
  80230c:	e8 75 ea ff ff       	call   800d86 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802311:	85 c0                	test   %eax,%eax
  802313:	0f 94 c2             	sete   %dl
  802316:	74 d9                	je     8022f1 <ipc_send+0x39>
  802318:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80231b:	74 d4                	je     8022f1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80231d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802321:	c7 44 24 08 20 2b 80 	movl   $0x802b20,0x8(%esp)
  802328:	00 
  802329:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802330:	00 
  802331:	c7 04 24 2e 2b 80 00 	movl   $0x802b2e,(%esp)
  802338:	e8 b9 fe ff ff       	call   8021f6 <_panic>
}
  80233d:	83 c4 1c             	add    $0x1c,%esp
  802340:	5b                   	pop    %ebx
  802341:	5e                   	pop    %esi
  802342:	5f                   	pop    %edi
  802343:	5d                   	pop    %ebp
  802344:	c3                   	ret    

00802345 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80234b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802350:	89 c2                	mov    %eax,%edx
  802352:	c1 e2 07             	shl    $0x7,%edx
  802355:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80235b:	8b 52 50             	mov    0x50(%edx),%edx
  80235e:	39 ca                	cmp    %ecx,%edx
  802360:	75 0d                	jne    80236f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802362:	c1 e0 07             	shl    $0x7,%eax
  802365:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80236a:	8b 40 40             	mov    0x40(%eax),%eax
  80236d:	eb 0e                	jmp    80237d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80236f:	83 c0 01             	add    $0x1,%eax
  802372:	3d 00 04 00 00       	cmp    $0x400,%eax
  802377:	75 d7                	jne    802350 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802379:	66 b8 00 00          	mov    $0x0,%ax
}
  80237d:	5d                   	pop    %ebp
  80237e:	c3                   	ret    

0080237f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
  802382:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802385:	89 d0                	mov    %edx,%eax
  802387:	c1 e8 16             	shr    $0x16,%eax
  80238a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802391:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802396:	f6 c1 01             	test   $0x1,%cl
  802399:	74 1d                	je     8023b8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80239b:	c1 ea 0c             	shr    $0xc,%edx
  80239e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023a5:	f6 c2 01             	test   $0x1,%dl
  8023a8:	74 0e                	je     8023b8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023aa:	c1 ea 0c             	shr    $0xc,%edx
  8023ad:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023b4:	ef 
  8023b5:	0f b7 c0             	movzwl %ax,%eax
}
  8023b8:	5d                   	pop    %ebp
  8023b9:	c3                   	ret    
  8023ba:	66 90                	xchg   %ax,%ax
  8023bc:	66 90                	xchg   %ax,%ax
  8023be:	66 90                	xchg   %ax,%ax

008023c0 <__udivdi3>:
  8023c0:	55                   	push   %ebp
  8023c1:	57                   	push   %edi
  8023c2:	56                   	push   %esi
  8023c3:	83 ec 0c             	sub    $0xc,%esp
  8023c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8023ca:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8023ce:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8023d2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8023dc:	89 ea                	mov    %ebp,%edx
  8023de:	89 0c 24             	mov    %ecx,(%esp)
  8023e1:	75 2d                	jne    802410 <__udivdi3+0x50>
  8023e3:	39 e9                	cmp    %ebp,%ecx
  8023e5:	77 61                	ja     802448 <__udivdi3+0x88>
  8023e7:	85 c9                	test   %ecx,%ecx
  8023e9:	89 ce                	mov    %ecx,%esi
  8023eb:	75 0b                	jne    8023f8 <__udivdi3+0x38>
  8023ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f2:	31 d2                	xor    %edx,%edx
  8023f4:	f7 f1                	div    %ecx
  8023f6:	89 c6                	mov    %eax,%esi
  8023f8:	31 d2                	xor    %edx,%edx
  8023fa:	89 e8                	mov    %ebp,%eax
  8023fc:	f7 f6                	div    %esi
  8023fe:	89 c5                	mov    %eax,%ebp
  802400:	89 f8                	mov    %edi,%eax
  802402:	f7 f6                	div    %esi
  802404:	89 ea                	mov    %ebp,%edx
  802406:	83 c4 0c             	add    $0xc,%esp
  802409:	5e                   	pop    %esi
  80240a:	5f                   	pop    %edi
  80240b:	5d                   	pop    %ebp
  80240c:	c3                   	ret    
  80240d:	8d 76 00             	lea    0x0(%esi),%esi
  802410:	39 e8                	cmp    %ebp,%eax
  802412:	77 24                	ja     802438 <__udivdi3+0x78>
  802414:	0f bd e8             	bsr    %eax,%ebp
  802417:	83 f5 1f             	xor    $0x1f,%ebp
  80241a:	75 3c                	jne    802458 <__udivdi3+0x98>
  80241c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802420:	39 34 24             	cmp    %esi,(%esp)
  802423:	0f 86 9f 00 00 00    	jbe    8024c8 <__udivdi3+0x108>
  802429:	39 d0                	cmp    %edx,%eax
  80242b:	0f 82 97 00 00 00    	jb     8024c8 <__udivdi3+0x108>
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	31 d2                	xor    %edx,%edx
  80243a:	31 c0                	xor    %eax,%eax
  80243c:	83 c4 0c             	add    $0xc,%esp
  80243f:	5e                   	pop    %esi
  802440:	5f                   	pop    %edi
  802441:	5d                   	pop    %ebp
  802442:	c3                   	ret    
  802443:	90                   	nop
  802444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802448:	89 f8                	mov    %edi,%eax
  80244a:	f7 f1                	div    %ecx
  80244c:	31 d2                	xor    %edx,%edx
  80244e:	83 c4 0c             	add    $0xc,%esp
  802451:	5e                   	pop    %esi
  802452:	5f                   	pop    %edi
  802453:	5d                   	pop    %ebp
  802454:	c3                   	ret    
  802455:	8d 76 00             	lea    0x0(%esi),%esi
  802458:	89 e9                	mov    %ebp,%ecx
  80245a:	8b 3c 24             	mov    (%esp),%edi
  80245d:	d3 e0                	shl    %cl,%eax
  80245f:	89 c6                	mov    %eax,%esi
  802461:	b8 20 00 00 00       	mov    $0x20,%eax
  802466:	29 e8                	sub    %ebp,%eax
  802468:	89 c1                	mov    %eax,%ecx
  80246a:	d3 ef                	shr    %cl,%edi
  80246c:	89 e9                	mov    %ebp,%ecx
  80246e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802472:	8b 3c 24             	mov    (%esp),%edi
  802475:	09 74 24 08          	or     %esi,0x8(%esp)
  802479:	89 d6                	mov    %edx,%esi
  80247b:	d3 e7                	shl    %cl,%edi
  80247d:	89 c1                	mov    %eax,%ecx
  80247f:	89 3c 24             	mov    %edi,(%esp)
  802482:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802486:	d3 ee                	shr    %cl,%esi
  802488:	89 e9                	mov    %ebp,%ecx
  80248a:	d3 e2                	shl    %cl,%edx
  80248c:	89 c1                	mov    %eax,%ecx
  80248e:	d3 ef                	shr    %cl,%edi
  802490:	09 d7                	or     %edx,%edi
  802492:	89 f2                	mov    %esi,%edx
  802494:	89 f8                	mov    %edi,%eax
  802496:	f7 74 24 08          	divl   0x8(%esp)
  80249a:	89 d6                	mov    %edx,%esi
  80249c:	89 c7                	mov    %eax,%edi
  80249e:	f7 24 24             	mull   (%esp)
  8024a1:	39 d6                	cmp    %edx,%esi
  8024a3:	89 14 24             	mov    %edx,(%esp)
  8024a6:	72 30                	jb     8024d8 <__udivdi3+0x118>
  8024a8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024ac:	89 e9                	mov    %ebp,%ecx
  8024ae:	d3 e2                	shl    %cl,%edx
  8024b0:	39 c2                	cmp    %eax,%edx
  8024b2:	73 05                	jae    8024b9 <__udivdi3+0xf9>
  8024b4:	3b 34 24             	cmp    (%esp),%esi
  8024b7:	74 1f                	je     8024d8 <__udivdi3+0x118>
  8024b9:	89 f8                	mov    %edi,%eax
  8024bb:	31 d2                	xor    %edx,%edx
  8024bd:	e9 7a ff ff ff       	jmp    80243c <__udivdi3+0x7c>
  8024c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024c8:	31 d2                	xor    %edx,%edx
  8024ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8024cf:	e9 68 ff ff ff       	jmp    80243c <__udivdi3+0x7c>
  8024d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024d8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8024db:	31 d2                	xor    %edx,%edx
  8024dd:	83 c4 0c             	add    $0xc,%esp
  8024e0:	5e                   	pop    %esi
  8024e1:	5f                   	pop    %edi
  8024e2:	5d                   	pop    %ebp
  8024e3:	c3                   	ret    
  8024e4:	66 90                	xchg   %ax,%ax
  8024e6:	66 90                	xchg   %ax,%ax
  8024e8:	66 90                	xchg   %ax,%ax
  8024ea:	66 90                	xchg   %ax,%ax
  8024ec:	66 90                	xchg   %ax,%ax
  8024ee:	66 90                	xchg   %ax,%ax

008024f0 <__umoddi3>:
  8024f0:	55                   	push   %ebp
  8024f1:	57                   	push   %edi
  8024f2:	56                   	push   %esi
  8024f3:	83 ec 14             	sub    $0x14,%esp
  8024f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8024fa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024fe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802502:	89 c7                	mov    %eax,%edi
  802504:	89 44 24 04          	mov    %eax,0x4(%esp)
  802508:	8b 44 24 30          	mov    0x30(%esp),%eax
  80250c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802510:	89 34 24             	mov    %esi,(%esp)
  802513:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802517:	85 c0                	test   %eax,%eax
  802519:	89 c2                	mov    %eax,%edx
  80251b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80251f:	75 17                	jne    802538 <__umoddi3+0x48>
  802521:	39 fe                	cmp    %edi,%esi
  802523:	76 4b                	jbe    802570 <__umoddi3+0x80>
  802525:	89 c8                	mov    %ecx,%eax
  802527:	89 fa                	mov    %edi,%edx
  802529:	f7 f6                	div    %esi
  80252b:	89 d0                	mov    %edx,%eax
  80252d:	31 d2                	xor    %edx,%edx
  80252f:	83 c4 14             	add    $0x14,%esp
  802532:	5e                   	pop    %esi
  802533:	5f                   	pop    %edi
  802534:	5d                   	pop    %ebp
  802535:	c3                   	ret    
  802536:	66 90                	xchg   %ax,%ax
  802538:	39 f8                	cmp    %edi,%eax
  80253a:	77 54                	ja     802590 <__umoddi3+0xa0>
  80253c:	0f bd e8             	bsr    %eax,%ebp
  80253f:	83 f5 1f             	xor    $0x1f,%ebp
  802542:	75 5c                	jne    8025a0 <__umoddi3+0xb0>
  802544:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802548:	39 3c 24             	cmp    %edi,(%esp)
  80254b:	0f 87 e7 00 00 00    	ja     802638 <__umoddi3+0x148>
  802551:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802555:	29 f1                	sub    %esi,%ecx
  802557:	19 c7                	sbb    %eax,%edi
  802559:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80255d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802561:	8b 44 24 08          	mov    0x8(%esp),%eax
  802565:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802569:	83 c4 14             	add    $0x14,%esp
  80256c:	5e                   	pop    %esi
  80256d:	5f                   	pop    %edi
  80256e:	5d                   	pop    %ebp
  80256f:	c3                   	ret    
  802570:	85 f6                	test   %esi,%esi
  802572:	89 f5                	mov    %esi,%ebp
  802574:	75 0b                	jne    802581 <__umoddi3+0x91>
  802576:	b8 01 00 00 00       	mov    $0x1,%eax
  80257b:	31 d2                	xor    %edx,%edx
  80257d:	f7 f6                	div    %esi
  80257f:	89 c5                	mov    %eax,%ebp
  802581:	8b 44 24 04          	mov    0x4(%esp),%eax
  802585:	31 d2                	xor    %edx,%edx
  802587:	f7 f5                	div    %ebp
  802589:	89 c8                	mov    %ecx,%eax
  80258b:	f7 f5                	div    %ebp
  80258d:	eb 9c                	jmp    80252b <__umoddi3+0x3b>
  80258f:	90                   	nop
  802590:	89 c8                	mov    %ecx,%eax
  802592:	89 fa                	mov    %edi,%edx
  802594:	83 c4 14             	add    $0x14,%esp
  802597:	5e                   	pop    %esi
  802598:	5f                   	pop    %edi
  802599:	5d                   	pop    %ebp
  80259a:	c3                   	ret    
  80259b:	90                   	nop
  80259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025a0:	8b 04 24             	mov    (%esp),%eax
  8025a3:	be 20 00 00 00       	mov    $0x20,%esi
  8025a8:	89 e9                	mov    %ebp,%ecx
  8025aa:	29 ee                	sub    %ebp,%esi
  8025ac:	d3 e2                	shl    %cl,%edx
  8025ae:	89 f1                	mov    %esi,%ecx
  8025b0:	d3 e8                	shr    %cl,%eax
  8025b2:	89 e9                	mov    %ebp,%ecx
  8025b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b8:	8b 04 24             	mov    (%esp),%eax
  8025bb:	09 54 24 04          	or     %edx,0x4(%esp)
  8025bf:	89 fa                	mov    %edi,%edx
  8025c1:	d3 e0                	shl    %cl,%eax
  8025c3:	89 f1                	mov    %esi,%ecx
  8025c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025c9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8025cd:	d3 ea                	shr    %cl,%edx
  8025cf:	89 e9                	mov    %ebp,%ecx
  8025d1:	d3 e7                	shl    %cl,%edi
  8025d3:	89 f1                	mov    %esi,%ecx
  8025d5:	d3 e8                	shr    %cl,%eax
  8025d7:	89 e9                	mov    %ebp,%ecx
  8025d9:	09 f8                	or     %edi,%eax
  8025db:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8025df:	f7 74 24 04          	divl   0x4(%esp)
  8025e3:	d3 e7                	shl    %cl,%edi
  8025e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025e9:	89 d7                	mov    %edx,%edi
  8025eb:	f7 64 24 08          	mull   0x8(%esp)
  8025ef:	39 d7                	cmp    %edx,%edi
  8025f1:	89 c1                	mov    %eax,%ecx
  8025f3:	89 14 24             	mov    %edx,(%esp)
  8025f6:	72 2c                	jb     802624 <__umoddi3+0x134>
  8025f8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8025fc:	72 22                	jb     802620 <__umoddi3+0x130>
  8025fe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802602:	29 c8                	sub    %ecx,%eax
  802604:	19 d7                	sbb    %edx,%edi
  802606:	89 e9                	mov    %ebp,%ecx
  802608:	89 fa                	mov    %edi,%edx
  80260a:	d3 e8                	shr    %cl,%eax
  80260c:	89 f1                	mov    %esi,%ecx
  80260e:	d3 e2                	shl    %cl,%edx
  802610:	89 e9                	mov    %ebp,%ecx
  802612:	d3 ef                	shr    %cl,%edi
  802614:	09 d0                	or     %edx,%eax
  802616:	89 fa                	mov    %edi,%edx
  802618:	83 c4 14             	add    $0x14,%esp
  80261b:	5e                   	pop    %esi
  80261c:	5f                   	pop    %edi
  80261d:	5d                   	pop    %ebp
  80261e:	c3                   	ret    
  80261f:	90                   	nop
  802620:	39 d7                	cmp    %edx,%edi
  802622:	75 da                	jne    8025fe <__umoddi3+0x10e>
  802624:	8b 14 24             	mov    (%esp),%edx
  802627:	89 c1                	mov    %eax,%ecx
  802629:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80262d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802631:	eb cb                	jmp    8025fe <__umoddi3+0x10e>
  802633:	90                   	nop
  802634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802638:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80263c:	0f 82 0f ff ff ff    	jb     802551 <__umoddi3+0x61>
  802642:	e9 1a ff ff ff       	jmp    802561 <__umoddi3+0x71>
