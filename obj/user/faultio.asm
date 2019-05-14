
obj/user/faultio.debug:     file format elf32-i386


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
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>
#include <inc/x86.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp

static inline uint32_t
read_eflags(void)
{
	uint32_t eflags;
	asm volatile("pushfl; popl %0" : "=r" (eflags));
  800039:	9c                   	pushf  
  80003a:	58                   	pop    %eax
        int x, r;
	int nsecs = 1;
	int secno = 0;
	int diskno = 1;

	if (read_eflags() & FL_IOPL_3)
  80003b:	f6 c4 30             	test   $0x30,%ah
  80003e:	74 0c                	je     80004c <umain+0x19>
		cprintf("eflags wrong\n");
  800040:	c7 04 24 80 26 80 00 	movl   $0x802680,(%esp)
  800047:	e8 1d 01 00 00       	call   800169 <cprintf>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80004c:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800051:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  800056:	ee                   	out    %al,(%dx)

	// this outb to select disk 1 should result in a general protection
	// fault, because user-level code shouldn't be able to use the io space.
	outb(0x1F6, 0xE0 | (1<<4));

        cprintf("%s: made it here --- bug\n");
  800057:	c7 04 24 8e 26 80 00 	movl   $0x80268e,(%esp)
  80005e:	e8 06 01 00 00       	call   800169 <cprintf>
}
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	56                   	push   %esi
  800069:	53                   	push   %ebx
  80006a:	83 ec 10             	sub    $0x10,%esp
  80006d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800070:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800073:	e8 fd 0a 00 00       	call   800b75 <sys_getenvid>
  800078:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007d:	c1 e0 07             	shl    $0x7,%eax
  800080:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800085:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008a:	85 db                	test   %ebx,%ebx
  80008c:	7e 07                	jle    800095 <libmain+0x30>
		binaryname = argv[0];
  80008e:	8b 06                	mov    (%esi),%eax
  800090:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800095:	89 74 24 04          	mov    %esi,0x4(%esp)
  800099:	89 1c 24             	mov    %ebx,(%esp)
  80009c:	e8 92 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a1:	e8 07 00 00 00       	call   8000ad <exit>
}
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	5b                   	pop    %ebx
  8000aa:	5e                   	pop    %esi
  8000ab:	5d                   	pop    %ebp
  8000ac:	c3                   	ret    

008000ad <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ad:	55                   	push   %ebp
  8000ae:	89 e5                	mov    %esp,%ebp
  8000b0:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000b3:	e8 22 10 00 00       	call   8010da <close_all>
	sys_env_destroy(0);
  8000b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000bf:	e8 5f 0a 00 00       	call   800b23 <sys_env_destroy>
}
  8000c4:	c9                   	leave  
  8000c5:	c3                   	ret    

008000c6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c6:	55                   	push   %ebp
  8000c7:	89 e5                	mov    %esp,%ebp
  8000c9:	53                   	push   %ebx
  8000ca:	83 ec 14             	sub    $0x14,%esp
  8000cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d0:	8b 13                	mov    (%ebx),%edx
  8000d2:	8d 42 01             	lea    0x1(%edx),%eax
  8000d5:	89 03                	mov    %eax,(%ebx)
  8000d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000da:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000de:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e3:	75 19                	jne    8000fe <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8000e5:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8000ec:	00 
  8000ed:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f0:	89 04 24             	mov    %eax,(%esp)
  8000f3:	e8 ee 09 00 00       	call   800ae6 <sys_cputs>
		b->idx = 0;
  8000f8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8000fe:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800102:	83 c4 14             	add    $0x14,%esp
  800105:	5b                   	pop    %ebx
  800106:	5d                   	pop    %ebp
  800107:	c3                   	ret    

00800108 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800111:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800118:	00 00 00 
	b.cnt = 0;
  80011b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800122:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800125:	8b 45 0c             	mov    0xc(%ebp),%eax
  800128:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80012c:	8b 45 08             	mov    0x8(%ebp),%eax
  80012f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800133:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800139:	89 44 24 04          	mov    %eax,0x4(%esp)
  80013d:	c7 04 24 c6 00 80 00 	movl   $0x8000c6,(%esp)
  800144:	e8 b5 01 00 00       	call   8002fe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800149:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80014f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800153:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800159:	89 04 24             	mov    %eax,(%esp)
  80015c:	e8 85 09 00 00       	call   800ae6 <sys_cputs>

	return b.cnt;
}
  800161:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800167:	c9                   	leave  
  800168:	c3                   	ret    

00800169 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800169:	55                   	push   %ebp
  80016a:	89 e5                	mov    %esp,%ebp
  80016c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80016f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800172:	89 44 24 04          	mov    %eax,0x4(%esp)
  800176:	8b 45 08             	mov    0x8(%ebp),%eax
  800179:	89 04 24             	mov    %eax,(%esp)
  80017c:	e8 87 ff ff ff       	call   800108 <vcprintf>
	va_end(ap);

	return cnt;
}
  800181:	c9                   	leave  
  800182:	c3                   	ret    
  800183:	66 90                	xchg   %ax,%ax
  800185:	66 90                	xchg   %ax,%ax
  800187:	66 90                	xchg   %ax,%ax
  800189:	66 90                	xchg   %ax,%ax
  80018b:	66 90                	xchg   %ax,%ax
  80018d:	66 90                	xchg   %ax,%ax
  80018f:	90                   	nop

00800190 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	57                   	push   %edi
  800194:	56                   	push   %esi
  800195:	53                   	push   %ebx
  800196:	83 ec 3c             	sub    $0x3c,%esp
  800199:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80019c:	89 d7                	mov    %edx,%edi
  80019e:	8b 45 08             	mov    0x8(%ebp),%eax
  8001a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a7:	89 c3                	mov    %eax,%ebx
  8001a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8001af:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001bd:	39 d9                	cmp    %ebx,%ecx
  8001bf:	72 05                	jb     8001c6 <printnum+0x36>
  8001c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001c4:	77 69                	ja     80022f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8001c9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8001cd:	83 ee 01             	sub    $0x1,%esi
  8001d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8001d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8001dc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8001e0:	89 c3                	mov    %eax,%ebx
  8001e2:	89 d6                	mov    %edx,%esi
  8001e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8001f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001f5:	89 04 24             	mov    %eax,(%esp)
  8001f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ff:	e8 dc 21 00 00       	call   8023e0 <__udivdi3>
  800204:	89 d9                	mov    %ebx,%ecx
  800206:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80020a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80020e:	89 04 24             	mov    %eax,(%esp)
  800211:	89 54 24 04          	mov    %edx,0x4(%esp)
  800215:	89 fa                	mov    %edi,%edx
  800217:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80021a:	e8 71 ff ff ff       	call   800190 <printnum>
  80021f:	eb 1b                	jmp    80023c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800221:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800225:	8b 45 18             	mov    0x18(%ebp),%eax
  800228:	89 04 24             	mov    %eax,(%esp)
  80022b:	ff d3                	call   *%ebx
  80022d:	eb 03                	jmp    800232 <printnum+0xa2>
  80022f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800232:	83 ee 01             	sub    $0x1,%esi
  800235:	85 f6                	test   %esi,%esi
  800237:	7f e8                	jg     800221 <printnum+0x91>
  800239:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80023c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800240:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800244:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800247:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80024a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80024e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800252:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800255:	89 04 24             	mov    %eax,(%esp)
  800258:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80025b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025f:	e8 ac 22 00 00       	call   802510 <__umoddi3>
  800264:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800268:	0f be 80 b2 26 80 00 	movsbl 0x8026b2(%eax),%eax
  80026f:	89 04 24             	mov    %eax,(%esp)
  800272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800275:	ff d0                	call   *%eax
}
  800277:	83 c4 3c             	add    $0x3c,%esp
  80027a:	5b                   	pop    %ebx
  80027b:	5e                   	pop    %esi
  80027c:	5f                   	pop    %edi
  80027d:	5d                   	pop    %ebp
  80027e:	c3                   	ret    

0080027f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800282:	83 fa 01             	cmp    $0x1,%edx
  800285:	7e 0e                	jle    800295 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800287:	8b 10                	mov    (%eax),%edx
  800289:	8d 4a 08             	lea    0x8(%edx),%ecx
  80028c:	89 08                	mov    %ecx,(%eax)
  80028e:	8b 02                	mov    (%edx),%eax
  800290:	8b 52 04             	mov    0x4(%edx),%edx
  800293:	eb 22                	jmp    8002b7 <getuint+0x38>
	else if (lflag)
  800295:	85 d2                	test   %edx,%edx
  800297:	74 10                	je     8002a9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800299:	8b 10                	mov    (%eax),%edx
  80029b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80029e:	89 08                	mov    %ecx,(%eax)
  8002a0:	8b 02                	mov    (%edx),%eax
  8002a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002a7:	eb 0e                	jmp    8002b7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002a9:	8b 10                	mov    (%eax),%edx
  8002ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ae:	89 08                	mov    %ecx,(%eax)
  8002b0:	8b 02                	mov    (%edx),%eax
  8002b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002b7:	5d                   	pop    %ebp
  8002b8:	c3                   	ret    

008002b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002b9:	55                   	push   %ebp
  8002ba:	89 e5                	mov    %esp,%ebp
  8002bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002bf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002c3:	8b 10                	mov    (%eax),%edx
  8002c5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002c8:	73 0a                	jae    8002d4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002cd:	89 08                	mov    %ecx,(%eax)
  8002cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d2:	88 02                	mov    %al,(%edx)
}
  8002d4:	5d                   	pop    %ebp
  8002d5:	c3                   	ret    

008002d6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8002dc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f4:	89 04 24             	mov    %eax,(%esp)
  8002f7:	e8 02 00 00 00       	call   8002fe <vprintfmt>
	va_end(ap);
}
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    

008002fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8002fe:	55                   	push   %ebp
  8002ff:	89 e5                	mov    %esp,%ebp
  800301:	57                   	push   %edi
  800302:	56                   	push   %esi
  800303:	53                   	push   %ebx
  800304:	83 ec 3c             	sub    $0x3c,%esp
  800307:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80030a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80030d:	eb 14                	jmp    800323 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80030f:	85 c0                	test   %eax,%eax
  800311:	0f 84 b3 03 00 00    	je     8006ca <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800317:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80031b:	89 04 24             	mov    %eax,(%esp)
  80031e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800321:	89 f3                	mov    %esi,%ebx
  800323:	8d 73 01             	lea    0x1(%ebx),%esi
  800326:	0f b6 03             	movzbl (%ebx),%eax
  800329:	83 f8 25             	cmp    $0x25,%eax
  80032c:	75 e1                	jne    80030f <vprintfmt+0x11>
  80032e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800332:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800339:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800340:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800347:	ba 00 00 00 00       	mov    $0x0,%edx
  80034c:	eb 1d                	jmp    80036b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80034e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800350:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800354:	eb 15                	jmp    80036b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800356:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800358:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80035c:	eb 0d                	jmp    80036b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80035e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800361:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800364:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80036b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80036e:	0f b6 0e             	movzbl (%esi),%ecx
  800371:	0f b6 c1             	movzbl %cl,%eax
  800374:	83 e9 23             	sub    $0x23,%ecx
  800377:	80 f9 55             	cmp    $0x55,%cl
  80037a:	0f 87 2a 03 00 00    	ja     8006aa <vprintfmt+0x3ac>
  800380:	0f b6 c9             	movzbl %cl,%ecx
  800383:	ff 24 8d 00 28 80 00 	jmp    *0x802800(,%ecx,4)
  80038a:	89 de                	mov    %ebx,%esi
  80038c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800391:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800394:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800398:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80039b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80039e:	83 fb 09             	cmp    $0x9,%ebx
  8003a1:	77 36                	ja     8003d9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003a3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003a6:	eb e9                	jmp    800391 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ab:	8d 48 04             	lea    0x4(%eax),%ecx
  8003ae:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003b1:	8b 00                	mov    (%eax),%eax
  8003b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003b6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003b8:	eb 22                	jmp    8003dc <vprintfmt+0xde>
  8003ba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003bd:	85 c9                	test   %ecx,%ecx
  8003bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c4:	0f 49 c1             	cmovns %ecx,%eax
  8003c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ca:	89 de                	mov    %ebx,%esi
  8003cc:	eb 9d                	jmp    80036b <vprintfmt+0x6d>
  8003ce:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8003d0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8003d7:	eb 92                	jmp    80036b <vprintfmt+0x6d>
  8003d9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8003dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8003e0:	79 89                	jns    80036b <vprintfmt+0x6d>
  8003e2:	e9 77 ff ff ff       	jmp    80035e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8003e7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ea:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8003ec:	e9 7a ff ff ff       	jmp    80036b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8003f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003f4:	8d 50 04             	lea    0x4(%eax),%edx
  8003f7:	89 55 14             	mov    %edx,0x14(%ebp)
  8003fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003fe:	8b 00                	mov    (%eax),%eax
  800400:	89 04 24             	mov    %eax,(%esp)
  800403:	ff 55 08             	call   *0x8(%ebp)
			break;
  800406:	e9 18 ff ff ff       	jmp    800323 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80040b:	8b 45 14             	mov    0x14(%ebp),%eax
  80040e:	8d 50 04             	lea    0x4(%eax),%edx
  800411:	89 55 14             	mov    %edx,0x14(%ebp)
  800414:	8b 00                	mov    (%eax),%eax
  800416:	99                   	cltd   
  800417:	31 d0                	xor    %edx,%eax
  800419:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80041b:	83 f8 11             	cmp    $0x11,%eax
  80041e:	7f 0b                	jg     80042b <vprintfmt+0x12d>
  800420:	8b 14 85 60 29 80 00 	mov    0x802960(,%eax,4),%edx
  800427:	85 d2                	test   %edx,%edx
  800429:	75 20                	jne    80044b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80042b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80042f:	c7 44 24 08 ca 26 80 	movl   $0x8026ca,0x8(%esp)
  800436:	00 
  800437:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	89 04 24             	mov    %eax,(%esp)
  800441:	e8 90 fe ff ff       	call   8002d6 <printfmt>
  800446:	e9 d8 fe ff ff       	jmp    800323 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80044b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80044f:	c7 44 24 08 9d 2a 80 	movl   $0x802a9d,0x8(%esp)
  800456:	00 
  800457:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80045b:	8b 45 08             	mov    0x8(%ebp),%eax
  80045e:	89 04 24             	mov    %eax,(%esp)
  800461:	e8 70 fe ff ff       	call   8002d6 <printfmt>
  800466:	e9 b8 fe ff ff       	jmp    800323 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80046e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800471:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800474:	8b 45 14             	mov    0x14(%ebp),%eax
  800477:	8d 50 04             	lea    0x4(%eax),%edx
  80047a:	89 55 14             	mov    %edx,0x14(%ebp)
  80047d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80047f:	85 f6                	test   %esi,%esi
  800481:	b8 c3 26 80 00       	mov    $0x8026c3,%eax
  800486:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800489:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80048d:	0f 84 97 00 00 00    	je     80052a <vprintfmt+0x22c>
  800493:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800497:	0f 8e 9b 00 00 00    	jle    800538 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80049d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004a1:	89 34 24             	mov    %esi,(%esp)
  8004a4:	e8 cf 02 00 00       	call   800778 <strnlen>
  8004a9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004ac:	29 c2                	sub    %eax,%edx
  8004ae:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8004b1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8004b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004c1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c3:	eb 0f                	jmp    8004d4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8004c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004cc:	89 04 24             	mov    %eax,(%esp)
  8004cf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d1:	83 eb 01             	sub    $0x1,%ebx
  8004d4:	85 db                	test   %ebx,%ebx
  8004d6:	7f ed                	jg     8004c5 <vprintfmt+0x1c7>
  8004d8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8004db:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004de:	85 d2                	test   %edx,%edx
  8004e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e5:	0f 49 c2             	cmovns %edx,%eax
  8004e8:	29 c2                	sub    %eax,%edx
  8004ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8004ed:	89 d7                	mov    %edx,%edi
  8004ef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8004f2:	eb 50                	jmp    800544 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8004f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f8:	74 1e                	je     800518 <vprintfmt+0x21a>
  8004fa:	0f be d2             	movsbl %dl,%edx
  8004fd:	83 ea 20             	sub    $0x20,%edx
  800500:	83 fa 5e             	cmp    $0x5e,%edx
  800503:	76 13                	jbe    800518 <vprintfmt+0x21a>
					putch('?', putdat);
  800505:	8b 45 0c             	mov    0xc(%ebp),%eax
  800508:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800513:	ff 55 08             	call   *0x8(%ebp)
  800516:	eb 0d                	jmp    800525 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800518:	8b 55 0c             	mov    0xc(%ebp),%edx
  80051b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80051f:	89 04 24             	mov    %eax,(%esp)
  800522:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800525:	83 ef 01             	sub    $0x1,%edi
  800528:	eb 1a                	jmp    800544 <vprintfmt+0x246>
  80052a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80052d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800530:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800533:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800536:	eb 0c                	jmp    800544 <vprintfmt+0x246>
  800538:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80053b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80053e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800541:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800544:	83 c6 01             	add    $0x1,%esi
  800547:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80054b:	0f be c2             	movsbl %dl,%eax
  80054e:	85 c0                	test   %eax,%eax
  800550:	74 27                	je     800579 <vprintfmt+0x27b>
  800552:	85 db                	test   %ebx,%ebx
  800554:	78 9e                	js     8004f4 <vprintfmt+0x1f6>
  800556:	83 eb 01             	sub    $0x1,%ebx
  800559:	79 99                	jns    8004f4 <vprintfmt+0x1f6>
  80055b:	89 f8                	mov    %edi,%eax
  80055d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800560:	8b 75 08             	mov    0x8(%ebp),%esi
  800563:	89 c3                	mov    %eax,%ebx
  800565:	eb 1a                	jmp    800581 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800567:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80056b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800572:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800574:	83 eb 01             	sub    $0x1,%ebx
  800577:	eb 08                	jmp    800581 <vprintfmt+0x283>
  800579:	89 fb                	mov    %edi,%ebx
  80057b:	8b 75 08             	mov    0x8(%ebp),%esi
  80057e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800581:	85 db                	test   %ebx,%ebx
  800583:	7f e2                	jg     800567 <vprintfmt+0x269>
  800585:	89 75 08             	mov    %esi,0x8(%ebp)
  800588:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80058b:	e9 93 fd ff ff       	jmp    800323 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800590:	83 fa 01             	cmp    $0x1,%edx
  800593:	7e 16                	jle    8005ab <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8d 50 08             	lea    0x8(%eax),%edx
  80059b:	89 55 14             	mov    %edx,0x14(%ebp)
  80059e:	8b 50 04             	mov    0x4(%eax),%edx
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005a9:	eb 32                	jmp    8005dd <vprintfmt+0x2df>
	else if (lflag)
  8005ab:	85 d2                	test   %edx,%edx
  8005ad:	74 18                	je     8005c7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	8d 50 04             	lea    0x4(%eax),%edx
  8005b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b8:	8b 30                	mov    (%eax),%esi
  8005ba:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005bd:	89 f0                	mov    %esi,%eax
  8005bf:	c1 f8 1f             	sar    $0x1f,%eax
  8005c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005c5:	eb 16                	jmp    8005dd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 50 04             	lea    0x4(%eax),%edx
  8005cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d0:	8b 30                	mov    (%eax),%esi
  8005d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005d5:	89 f0                	mov    %esi,%eax
  8005d7:	c1 f8 1f             	sar    $0x1f,%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8005dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8005e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8005e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ec:	0f 89 80 00 00 00    	jns    800672 <vprintfmt+0x374>
				putch('-', putdat);
  8005f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8005fd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800600:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800603:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800606:	f7 d8                	neg    %eax
  800608:	83 d2 00             	adc    $0x0,%edx
  80060b:	f7 da                	neg    %edx
			}
			base = 10;
  80060d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800612:	eb 5e                	jmp    800672 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800614:	8d 45 14             	lea    0x14(%ebp),%eax
  800617:	e8 63 fc ff ff       	call   80027f <getuint>
			base = 10;
  80061c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800621:	eb 4f                	jmp    800672 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800623:	8d 45 14             	lea    0x14(%ebp),%eax
  800626:	e8 54 fc ff ff       	call   80027f <getuint>
			base = 8;
  80062b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800630:	eb 40                	jmp    800672 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800632:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800636:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80063d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800640:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800644:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80064b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8d 50 04             	lea    0x4(%eax),%edx
  800654:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800657:	8b 00                	mov    (%eax),%eax
  800659:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80065e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800663:	eb 0d                	jmp    800672 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800665:	8d 45 14             	lea    0x14(%ebp),%eax
  800668:	e8 12 fc ff ff       	call   80027f <getuint>
			base = 16;
  80066d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800672:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800676:	89 74 24 10          	mov    %esi,0x10(%esp)
  80067a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80067d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800681:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800685:	89 04 24             	mov    %eax,(%esp)
  800688:	89 54 24 04          	mov    %edx,0x4(%esp)
  80068c:	89 fa                	mov    %edi,%edx
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	e8 fa fa ff ff       	call   800190 <printnum>
			break;
  800696:	e9 88 fc ff ff       	jmp    800323 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80069b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80069f:	89 04 24             	mov    %eax,(%esp)
  8006a2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006a5:	e9 79 fc ff ff       	jmp    800323 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ae:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006b5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006b8:	89 f3                	mov    %esi,%ebx
  8006ba:	eb 03                	jmp    8006bf <vprintfmt+0x3c1>
  8006bc:	83 eb 01             	sub    $0x1,%ebx
  8006bf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8006c3:	75 f7                	jne    8006bc <vprintfmt+0x3be>
  8006c5:	e9 59 fc ff ff       	jmp    800323 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8006ca:	83 c4 3c             	add    $0x3c,%esp
  8006cd:	5b                   	pop    %ebx
  8006ce:	5e                   	pop    %esi
  8006cf:	5f                   	pop    %edi
  8006d0:	5d                   	pop    %ebp
  8006d1:	c3                   	ret    

008006d2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	83 ec 28             	sub    $0x28,%esp
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006e1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006e5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006ef:	85 c0                	test   %eax,%eax
  8006f1:	74 30                	je     800723 <vsnprintf+0x51>
  8006f3:	85 d2                	test   %edx,%edx
  8006f5:	7e 2c                	jle    800723 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800701:	89 44 24 08          	mov    %eax,0x8(%esp)
  800705:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800708:	89 44 24 04          	mov    %eax,0x4(%esp)
  80070c:	c7 04 24 b9 02 80 00 	movl   $0x8002b9,(%esp)
  800713:	e8 e6 fb ff ff       	call   8002fe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800718:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80071b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80071e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800721:	eb 05                	jmp    800728 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800723:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800728:	c9                   	leave  
  800729:	c3                   	ret    

0080072a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
  80072d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800730:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800733:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800737:	8b 45 10             	mov    0x10(%ebp),%eax
  80073a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80073e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800741:	89 44 24 04          	mov    %eax,0x4(%esp)
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	89 04 24             	mov    %eax,(%esp)
  80074b:	e8 82 ff ff ff       	call   8006d2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800750:	c9                   	leave  
  800751:	c3                   	ret    
  800752:	66 90                	xchg   %ax,%ax
  800754:	66 90                	xchg   %ax,%ax
  800756:	66 90                	xchg   %ax,%ax
  800758:	66 90                	xchg   %ax,%ax
  80075a:	66 90                	xchg   %ax,%ax
  80075c:	66 90                	xchg   %ax,%ax
  80075e:	66 90                	xchg   %ax,%ax

00800760 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800760:	55                   	push   %ebp
  800761:	89 e5                	mov    %esp,%ebp
  800763:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800766:	b8 00 00 00 00       	mov    $0x0,%eax
  80076b:	eb 03                	jmp    800770 <strlen+0x10>
		n++;
  80076d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800770:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800774:	75 f7                	jne    80076d <strlen+0xd>
		n++;
	return n;
}
  800776:	5d                   	pop    %ebp
  800777:	c3                   	ret    

00800778 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80077e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800781:	b8 00 00 00 00       	mov    $0x0,%eax
  800786:	eb 03                	jmp    80078b <strnlen+0x13>
		n++;
  800788:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80078b:	39 d0                	cmp    %edx,%eax
  80078d:	74 06                	je     800795 <strnlen+0x1d>
  80078f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800793:	75 f3                	jne    800788 <strnlen+0x10>
		n++;
	return n;
}
  800795:	5d                   	pop    %ebp
  800796:	c3                   	ret    

00800797 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
  80079a:	53                   	push   %ebx
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007a1:	89 c2                	mov    %eax,%edx
  8007a3:	83 c2 01             	add    $0x1,%edx
  8007a6:	83 c1 01             	add    $0x1,%ecx
  8007a9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007ad:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007b0:	84 db                	test   %bl,%bl
  8007b2:	75 ef                	jne    8007a3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007b4:	5b                   	pop    %ebx
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	53                   	push   %ebx
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007c1:	89 1c 24             	mov    %ebx,(%esp)
  8007c4:	e8 97 ff ff ff       	call   800760 <strlen>
	strcpy(dst + len, src);
  8007c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007d0:	01 d8                	add    %ebx,%eax
  8007d2:	89 04 24             	mov    %eax,(%esp)
  8007d5:	e8 bd ff ff ff       	call   800797 <strcpy>
	return dst;
}
  8007da:	89 d8                	mov    %ebx,%eax
  8007dc:	83 c4 08             	add    $0x8,%esp
  8007df:	5b                   	pop    %ebx
  8007e0:	5d                   	pop    %ebp
  8007e1:	c3                   	ret    

008007e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	56                   	push   %esi
  8007e6:	53                   	push   %ebx
  8007e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ed:	89 f3                	mov    %esi,%ebx
  8007ef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007f2:	89 f2                	mov    %esi,%edx
  8007f4:	eb 0f                	jmp    800805 <strncpy+0x23>
		*dst++ = *src;
  8007f6:	83 c2 01             	add    $0x1,%edx
  8007f9:	0f b6 01             	movzbl (%ecx),%eax
  8007fc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007ff:	80 39 01             	cmpb   $0x1,(%ecx)
  800802:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800805:	39 da                	cmp    %ebx,%edx
  800807:	75 ed                	jne    8007f6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800809:	89 f0                	mov    %esi,%eax
  80080b:	5b                   	pop    %ebx
  80080c:	5e                   	pop    %esi
  80080d:	5d                   	pop    %ebp
  80080e:	c3                   	ret    

0080080f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80080f:	55                   	push   %ebp
  800810:	89 e5                	mov    %esp,%ebp
  800812:	56                   	push   %esi
  800813:	53                   	push   %ebx
  800814:	8b 75 08             	mov    0x8(%ebp),%esi
  800817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80081d:	89 f0                	mov    %esi,%eax
  80081f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800823:	85 c9                	test   %ecx,%ecx
  800825:	75 0b                	jne    800832 <strlcpy+0x23>
  800827:	eb 1d                	jmp    800846 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800829:	83 c0 01             	add    $0x1,%eax
  80082c:	83 c2 01             	add    $0x1,%edx
  80082f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800832:	39 d8                	cmp    %ebx,%eax
  800834:	74 0b                	je     800841 <strlcpy+0x32>
  800836:	0f b6 0a             	movzbl (%edx),%ecx
  800839:	84 c9                	test   %cl,%cl
  80083b:	75 ec                	jne    800829 <strlcpy+0x1a>
  80083d:	89 c2                	mov    %eax,%edx
  80083f:	eb 02                	jmp    800843 <strlcpy+0x34>
  800841:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800843:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800846:	29 f0                	sub    %esi,%eax
}
  800848:	5b                   	pop    %ebx
  800849:	5e                   	pop    %esi
  80084a:	5d                   	pop    %ebp
  80084b:	c3                   	ret    

0080084c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800852:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800855:	eb 06                	jmp    80085d <strcmp+0x11>
		p++, q++;
  800857:	83 c1 01             	add    $0x1,%ecx
  80085a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80085d:	0f b6 01             	movzbl (%ecx),%eax
  800860:	84 c0                	test   %al,%al
  800862:	74 04                	je     800868 <strcmp+0x1c>
  800864:	3a 02                	cmp    (%edx),%al
  800866:	74 ef                	je     800857 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800868:	0f b6 c0             	movzbl %al,%eax
  80086b:	0f b6 12             	movzbl (%edx),%edx
  80086e:	29 d0                	sub    %edx,%eax
}
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	53                   	push   %ebx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	8b 55 0c             	mov    0xc(%ebp),%edx
  80087c:	89 c3                	mov    %eax,%ebx
  80087e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800881:	eb 06                	jmp    800889 <strncmp+0x17>
		n--, p++, q++;
  800883:	83 c0 01             	add    $0x1,%eax
  800886:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800889:	39 d8                	cmp    %ebx,%eax
  80088b:	74 15                	je     8008a2 <strncmp+0x30>
  80088d:	0f b6 08             	movzbl (%eax),%ecx
  800890:	84 c9                	test   %cl,%cl
  800892:	74 04                	je     800898 <strncmp+0x26>
  800894:	3a 0a                	cmp    (%edx),%cl
  800896:	74 eb                	je     800883 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800898:	0f b6 00             	movzbl (%eax),%eax
  80089b:	0f b6 12             	movzbl (%edx),%edx
  80089e:	29 d0                	sub    %edx,%eax
  8008a0:	eb 05                	jmp    8008a7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008a2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008a7:	5b                   	pop    %ebx
  8008a8:	5d                   	pop    %ebp
  8008a9:	c3                   	ret    

008008aa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008b4:	eb 07                	jmp    8008bd <strchr+0x13>
		if (*s == c)
  8008b6:	38 ca                	cmp    %cl,%dl
  8008b8:	74 0f                	je     8008c9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008ba:	83 c0 01             	add    $0x1,%eax
  8008bd:	0f b6 10             	movzbl (%eax),%edx
  8008c0:	84 d2                	test   %dl,%dl
  8008c2:	75 f2                	jne    8008b6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8008c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008c9:	5d                   	pop    %ebp
  8008ca:	c3                   	ret    

008008cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008d5:	eb 07                	jmp    8008de <strfind+0x13>
		if (*s == c)
  8008d7:	38 ca                	cmp    %cl,%dl
  8008d9:	74 0a                	je     8008e5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8008db:	83 c0 01             	add    $0x1,%eax
  8008de:	0f b6 10             	movzbl (%eax),%edx
  8008e1:	84 d2                	test   %dl,%dl
  8008e3:	75 f2                	jne    8008d7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	57                   	push   %edi
  8008eb:	56                   	push   %esi
  8008ec:	53                   	push   %ebx
  8008ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008f3:	85 c9                	test   %ecx,%ecx
  8008f5:	74 36                	je     80092d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008f7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008fd:	75 28                	jne    800927 <memset+0x40>
  8008ff:	f6 c1 03             	test   $0x3,%cl
  800902:	75 23                	jne    800927 <memset+0x40>
		c &= 0xFF;
  800904:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800908:	89 d3                	mov    %edx,%ebx
  80090a:	c1 e3 08             	shl    $0x8,%ebx
  80090d:	89 d6                	mov    %edx,%esi
  80090f:	c1 e6 18             	shl    $0x18,%esi
  800912:	89 d0                	mov    %edx,%eax
  800914:	c1 e0 10             	shl    $0x10,%eax
  800917:	09 f0                	or     %esi,%eax
  800919:	09 c2                	or     %eax,%edx
  80091b:	89 d0                	mov    %edx,%eax
  80091d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80091f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800922:	fc                   	cld    
  800923:	f3 ab                	rep stos %eax,%es:(%edi)
  800925:	eb 06                	jmp    80092d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800927:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092a:	fc                   	cld    
  80092b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80092d:	89 f8                	mov    %edi,%eax
  80092f:	5b                   	pop    %ebx
  800930:	5e                   	pop    %esi
  800931:	5f                   	pop    %edi
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	57                   	push   %edi
  800938:	56                   	push   %esi
  800939:	8b 45 08             	mov    0x8(%ebp),%eax
  80093c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80093f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800942:	39 c6                	cmp    %eax,%esi
  800944:	73 35                	jae    80097b <memmove+0x47>
  800946:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800949:	39 d0                	cmp    %edx,%eax
  80094b:	73 2e                	jae    80097b <memmove+0x47>
		s += n;
		d += n;
  80094d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800950:	89 d6                	mov    %edx,%esi
  800952:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800954:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80095a:	75 13                	jne    80096f <memmove+0x3b>
  80095c:	f6 c1 03             	test   $0x3,%cl
  80095f:	75 0e                	jne    80096f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800961:	83 ef 04             	sub    $0x4,%edi
  800964:	8d 72 fc             	lea    -0x4(%edx),%esi
  800967:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80096a:	fd                   	std    
  80096b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80096d:	eb 09                	jmp    800978 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80096f:	83 ef 01             	sub    $0x1,%edi
  800972:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800975:	fd                   	std    
  800976:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800978:	fc                   	cld    
  800979:	eb 1d                	jmp    800998 <memmove+0x64>
  80097b:	89 f2                	mov    %esi,%edx
  80097d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80097f:	f6 c2 03             	test   $0x3,%dl
  800982:	75 0f                	jne    800993 <memmove+0x5f>
  800984:	f6 c1 03             	test   $0x3,%cl
  800987:	75 0a                	jne    800993 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800989:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80098c:	89 c7                	mov    %eax,%edi
  80098e:	fc                   	cld    
  80098f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800991:	eb 05                	jmp    800998 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800993:	89 c7                	mov    %eax,%edi
  800995:	fc                   	cld    
  800996:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800998:	5e                   	pop    %esi
  800999:	5f                   	pop    %edi
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	89 04 24             	mov    %eax,(%esp)
  8009b6:	e8 79 ff ff ff       	call   800934 <memmove>
}
  8009bb:	c9                   	leave  
  8009bc:	c3                   	ret    

008009bd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009bd:	55                   	push   %ebp
  8009be:	89 e5                	mov    %esp,%ebp
  8009c0:	56                   	push   %esi
  8009c1:	53                   	push   %ebx
  8009c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c8:	89 d6                	mov    %edx,%esi
  8009ca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009cd:	eb 1a                	jmp    8009e9 <memcmp+0x2c>
		if (*s1 != *s2)
  8009cf:	0f b6 02             	movzbl (%edx),%eax
  8009d2:	0f b6 19             	movzbl (%ecx),%ebx
  8009d5:	38 d8                	cmp    %bl,%al
  8009d7:	74 0a                	je     8009e3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  8009d9:	0f b6 c0             	movzbl %al,%eax
  8009dc:	0f b6 db             	movzbl %bl,%ebx
  8009df:	29 d8                	sub    %ebx,%eax
  8009e1:	eb 0f                	jmp    8009f2 <memcmp+0x35>
		s1++, s2++;
  8009e3:	83 c2 01             	add    $0x1,%edx
  8009e6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009e9:	39 f2                	cmp    %esi,%edx
  8009eb:	75 e2                	jne    8009cf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8009ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f2:	5b                   	pop    %ebx
  8009f3:	5e                   	pop    %esi
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009ff:	89 c2                	mov    %eax,%edx
  800a01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a04:	eb 07                	jmp    800a0d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a06:	38 08                	cmp    %cl,(%eax)
  800a08:	74 07                	je     800a11 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a0a:	83 c0 01             	add    $0x1,%eax
  800a0d:	39 d0                	cmp    %edx,%eax
  800a0f:	72 f5                	jb     800a06 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a11:	5d                   	pop    %ebp
  800a12:	c3                   	ret    

00800a13 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a13:	55                   	push   %ebp
  800a14:	89 e5                	mov    %esp,%ebp
  800a16:	57                   	push   %edi
  800a17:	56                   	push   %esi
  800a18:	53                   	push   %ebx
  800a19:	8b 55 08             	mov    0x8(%ebp),%edx
  800a1c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a1f:	eb 03                	jmp    800a24 <strtol+0x11>
		s++;
  800a21:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a24:	0f b6 0a             	movzbl (%edx),%ecx
  800a27:	80 f9 09             	cmp    $0x9,%cl
  800a2a:	74 f5                	je     800a21 <strtol+0xe>
  800a2c:	80 f9 20             	cmp    $0x20,%cl
  800a2f:	74 f0                	je     800a21 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a31:	80 f9 2b             	cmp    $0x2b,%cl
  800a34:	75 0a                	jne    800a40 <strtol+0x2d>
		s++;
  800a36:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a39:	bf 00 00 00 00       	mov    $0x0,%edi
  800a3e:	eb 11                	jmp    800a51 <strtol+0x3e>
  800a40:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a45:	80 f9 2d             	cmp    $0x2d,%cl
  800a48:	75 07                	jne    800a51 <strtol+0x3e>
		s++, neg = 1;
  800a4a:	8d 52 01             	lea    0x1(%edx),%edx
  800a4d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a51:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800a56:	75 15                	jne    800a6d <strtol+0x5a>
  800a58:	80 3a 30             	cmpb   $0x30,(%edx)
  800a5b:	75 10                	jne    800a6d <strtol+0x5a>
  800a5d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800a61:	75 0a                	jne    800a6d <strtol+0x5a>
		s += 2, base = 16;
  800a63:	83 c2 02             	add    $0x2,%edx
  800a66:	b8 10 00 00 00       	mov    $0x10,%eax
  800a6b:	eb 10                	jmp    800a7d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800a6d:	85 c0                	test   %eax,%eax
  800a6f:	75 0c                	jne    800a7d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a71:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a73:	80 3a 30             	cmpb   $0x30,(%edx)
  800a76:	75 05                	jne    800a7d <strtol+0x6a>
		s++, base = 8;
  800a78:	83 c2 01             	add    $0x1,%edx
  800a7b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800a7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a82:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800a85:	0f b6 0a             	movzbl (%edx),%ecx
  800a88:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800a8b:	89 f0                	mov    %esi,%eax
  800a8d:	3c 09                	cmp    $0x9,%al
  800a8f:	77 08                	ja     800a99 <strtol+0x86>
			dig = *s - '0';
  800a91:	0f be c9             	movsbl %cl,%ecx
  800a94:	83 e9 30             	sub    $0x30,%ecx
  800a97:	eb 20                	jmp    800ab9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800a99:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800a9c:	89 f0                	mov    %esi,%eax
  800a9e:	3c 19                	cmp    $0x19,%al
  800aa0:	77 08                	ja     800aaa <strtol+0x97>
			dig = *s - 'a' + 10;
  800aa2:	0f be c9             	movsbl %cl,%ecx
  800aa5:	83 e9 57             	sub    $0x57,%ecx
  800aa8:	eb 0f                	jmp    800ab9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800aaa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800aad:	89 f0                	mov    %esi,%eax
  800aaf:	3c 19                	cmp    $0x19,%al
  800ab1:	77 16                	ja     800ac9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800ab3:	0f be c9             	movsbl %cl,%ecx
  800ab6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ab9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800abc:	7d 0f                	jge    800acd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800abe:	83 c2 01             	add    $0x1,%edx
  800ac1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ac5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ac7:	eb bc                	jmp    800a85 <strtol+0x72>
  800ac9:	89 d8                	mov    %ebx,%eax
  800acb:	eb 02                	jmp    800acf <strtol+0xbc>
  800acd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800acf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad3:	74 05                	je     800ada <strtol+0xc7>
		*endptr = (char *) s;
  800ad5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800ada:	f7 d8                	neg    %eax
  800adc:	85 ff                	test   %edi,%edi
  800ade:	0f 44 c3             	cmove  %ebx,%eax
}
  800ae1:	5b                   	pop    %ebx
  800ae2:	5e                   	pop    %esi
  800ae3:	5f                   	pop    %edi
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	57                   	push   %edi
  800aea:	56                   	push   %esi
  800aeb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800aec:	b8 00 00 00 00       	mov    $0x0,%eax
  800af1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af4:	8b 55 08             	mov    0x8(%ebp),%edx
  800af7:	89 c3                	mov    %eax,%ebx
  800af9:	89 c7                	mov    %eax,%edi
  800afb:	89 c6                	mov    %eax,%esi
  800afd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800aff:	5b                   	pop    %ebx
  800b00:	5e                   	pop    %esi
  800b01:	5f                   	pop    %edi
  800b02:	5d                   	pop    %ebp
  800b03:	c3                   	ret    

00800b04 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	57                   	push   %edi
  800b08:	56                   	push   %esi
  800b09:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b14:	89 d1                	mov    %edx,%ecx
  800b16:	89 d3                	mov    %edx,%ebx
  800b18:	89 d7                	mov    %edx,%edi
  800b1a:	89 d6                	mov    %edx,%esi
  800b1c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b1e:	5b                   	pop    %ebx
  800b1f:	5e                   	pop    %esi
  800b20:	5f                   	pop    %edi
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	57                   	push   %edi
  800b27:	56                   	push   %esi
  800b28:	53                   	push   %ebx
  800b29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b31:	b8 03 00 00 00       	mov    $0x3,%eax
  800b36:	8b 55 08             	mov    0x8(%ebp),%edx
  800b39:	89 cb                	mov    %ecx,%ebx
  800b3b:	89 cf                	mov    %ecx,%edi
  800b3d:	89 ce                	mov    %ecx,%esi
  800b3f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b41:	85 c0                	test   %eax,%eax
  800b43:	7e 28                	jle    800b6d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b45:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b49:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800b50:	00 
  800b51:	c7 44 24 08 c7 29 80 	movl   $0x8029c7,0x8(%esp)
  800b58:	00 
  800b59:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800b60:	00 
  800b61:	c7 04 24 e4 29 80 00 	movl   $0x8029e4,(%esp)
  800b68:	e8 a9 16 00 00       	call   802216 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b6d:	83 c4 2c             	add    $0x2c,%esp
  800b70:	5b                   	pop    %ebx
  800b71:	5e                   	pop    %esi
  800b72:	5f                   	pop    %edi
  800b73:	5d                   	pop    %ebp
  800b74:	c3                   	ret    

00800b75 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	57                   	push   %edi
  800b79:	56                   	push   %esi
  800b7a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b80:	b8 02 00 00 00       	mov    $0x2,%eax
  800b85:	89 d1                	mov    %edx,%ecx
  800b87:	89 d3                	mov    %edx,%ebx
  800b89:	89 d7                	mov    %edx,%edi
  800b8b:	89 d6                	mov    %edx,%esi
  800b8d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5f                   	pop    %edi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <sys_yield>:

void
sys_yield(void)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	57                   	push   %edi
  800b98:	56                   	push   %esi
  800b99:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ba4:	89 d1                	mov    %edx,%ecx
  800ba6:	89 d3                	mov    %edx,%ebx
  800ba8:	89 d7                	mov    %edx,%edi
  800baa:	89 d6                	mov    %edx,%esi
  800bac:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bae:	5b                   	pop    %ebx
  800baf:	5e                   	pop    %esi
  800bb0:	5f                   	pop    %edi
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	57                   	push   %edi
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bbc:	be 00 00 00 00       	mov    $0x0,%esi
  800bc1:	b8 04 00 00 00       	mov    $0x4,%eax
  800bc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bcf:	89 f7                	mov    %esi,%edi
  800bd1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800bd3:	85 c0                	test   %eax,%eax
  800bd5:	7e 28                	jle    800bff <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bdb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800be2:	00 
  800be3:	c7 44 24 08 c7 29 80 	movl   $0x8029c7,0x8(%esp)
  800bea:	00 
  800beb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bf2:	00 
  800bf3:	c7 04 24 e4 29 80 00 	movl   $0x8029e4,(%esp)
  800bfa:	e8 17 16 00 00       	call   802216 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bff:	83 c4 2c             	add    $0x2c,%esp
  800c02:	5b                   	pop    %ebx
  800c03:	5e                   	pop    %esi
  800c04:	5f                   	pop    %edi
  800c05:	5d                   	pop    %ebp
  800c06:	c3                   	ret    

00800c07 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	57                   	push   %edi
  800c0b:	56                   	push   %esi
  800c0c:	53                   	push   %ebx
  800c0d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c10:	b8 05 00 00 00       	mov    $0x5,%eax
  800c15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c18:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c1e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c21:	8b 75 18             	mov    0x18(%ebp),%esi
  800c24:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c26:	85 c0                	test   %eax,%eax
  800c28:	7e 28                	jle    800c52 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c2a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c2e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800c35:	00 
  800c36:	c7 44 24 08 c7 29 80 	movl   $0x8029c7,0x8(%esp)
  800c3d:	00 
  800c3e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c45:	00 
  800c46:	c7 04 24 e4 29 80 00 	movl   $0x8029e4,(%esp)
  800c4d:	e8 c4 15 00 00       	call   802216 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c52:	83 c4 2c             	add    $0x2c,%esp
  800c55:	5b                   	pop    %ebx
  800c56:	5e                   	pop    %esi
  800c57:	5f                   	pop    %edi
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    

00800c5a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	57                   	push   %edi
  800c5e:	56                   	push   %esi
  800c5f:	53                   	push   %ebx
  800c60:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c63:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c68:	b8 06 00 00 00       	mov    $0x6,%eax
  800c6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c70:	8b 55 08             	mov    0x8(%ebp),%edx
  800c73:	89 df                	mov    %ebx,%edi
  800c75:	89 de                	mov    %ebx,%esi
  800c77:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c79:	85 c0                	test   %eax,%eax
  800c7b:	7e 28                	jle    800ca5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c81:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800c88:	00 
  800c89:	c7 44 24 08 c7 29 80 	movl   $0x8029c7,0x8(%esp)
  800c90:	00 
  800c91:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c98:	00 
  800c99:	c7 04 24 e4 29 80 00 	movl   $0x8029e4,(%esp)
  800ca0:	e8 71 15 00 00       	call   802216 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ca5:	83 c4 2c             	add    $0x2c,%esp
  800ca8:	5b                   	pop    %ebx
  800ca9:	5e                   	pop    %esi
  800caa:	5f                   	pop    %edi
  800cab:	5d                   	pop    %ebp
  800cac:	c3                   	ret    

00800cad <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	57                   	push   %edi
  800cb1:	56                   	push   %esi
  800cb2:	53                   	push   %ebx
  800cb3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbb:	b8 08 00 00 00       	mov    $0x8,%eax
  800cc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc6:	89 df                	mov    %ebx,%edi
  800cc8:	89 de                	mov    %ebx,%esi
  800cca:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ccc:	85 c0                	test   %eax,%eax
  800cce:	7e 28                	jle    800cf8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cd4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800cdb:	00 
  800cdc:	c7 44 24 08 c7 29 80 	movl   $0x8029c7,0x8(%esp)
  800ce3:	00 
  800ce4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ceb:	00 
  800cec:	c7 04 24 e4 29 80 00 	movl   $0x8029e4,(%esp)
  800cf3:	e8 1e 15 00 00       	call   802216 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cf8:	83 c4 2c             	add    $0x2c,%esp
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    

00800d00 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	57                   	push   %edi
  800d04:	56                   	push   %esi
  800d05:	53                   	push   %ebx
  800d06:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d0e:	b8 09 00 00 00       	mov    $0x9,%eax
  800d13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d16:	8b 55 08             	mov    0x8(%ebp),%edx
  800d19:	89 df                	mov    %ebx,%edi
  800d1b:	89 de                	mov    %ebx,%esi
  800d1d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	7e 28                	jle    800d4b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d23:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d27:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d2e:	00 
  800d2f:	c7 44 24 08 c7 29 80 	movl   $0x8029c7,0x8(%esp)
  800d36:	00 
  800d37:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d3e:	00 
  800d3f:	c7 04 24 e4 29 80 00 	movl   $0x8029e4,(%esp)
  800d46:	e8 cb 14 00 00       	call   802216 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d4b:	83 c4 2c             	add    $0x2c,%esp
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	57                   	push   %edi
  800d57:	56                   	push   %esi
  800d58:	53                   	push   %ebx
  800d59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	89 df                	mov    %ebx,%edi
  800d6e:	89 de                	mov    %ebx,%esi
  800d70:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d72:	85 c0                	test   %eax,%eax
  800d74:	7e 28                	jle    800d9e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d76:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d7a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800d81:	00 
  800d82:	c7 44 24 08 c7 29 80 	movl   $0x8029c7,0x8(%esp)
  800d89:	00 
  800d8a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d91:	00 
  800d92:	c7 04 24 e4 29 80 00 	movl   $0x8029e4,(%esp)
  800d99:	e8 78 14 00 00       	call   802216 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d9e:	83 c4 2c             	add    $0x2c,%esp
  800da1:	5b                   	pop    %ebx
  800da2:	5e                   	pop    %esi
  800da3:	5f                   	pop    %edi
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	57                   	push   %edi
  800daa:	56                   	push   %esi
  800dab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dac:	be 00 00 00 00       	mov    $0x0,%esi
  800db1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800db6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dbf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dc4:	5b                   	pop    %ebx
  800dc5:	5e                   	pop    %esi
  800dc6:	5f                   	pop    %edi
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    

00800dc9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	57                   	push   %edi
  800dcd:	56                   	push   %esi
  800dce:	53                   	push   %ebx
  800dcf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddf:	89 cb                	mov    %ecx,%ebx
  800de1:	89 cf                	mov    %ecx,%edi
  800de3:	89 ce                	mov    %ecx,%esi
  800de5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800de7:	85 c0                	test   %eax,%eax
  800de9:	7e 28                	jle    800e13 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800deb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800def:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800df6:	00 
  800df7:	c7 44 24 08 c7 29 80 	movl   $0x8029c7,0x8(%esp)
  800dfe:	00 
  800dff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e06:	00 
  800e07:	c7 04 24 e4 29 80 00 	movl   $0x8029e4,(%esp)
  800e0e:	e8 03 14 00 00       	call   802216 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e13:	83 c4 2c             	add    $0x2c,%esp
  800e16:	5b                   	pop    %ebx
  800e17:	5e                   	pop    %esi
  800e18:	5f                   	pop    %edi
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    

00800e1b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	57                   	push   %edi
  800e1f:	56                   	push   %esi
  800e20:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e21:	ba 00 00 00 00       	mov    $0x0,%edx
  800e26:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e2b:	89 d1                	mov    %edx,%ecx
  800e2d:	89 d3                	mov    %edx,%ebx
  800e2f:	89 d7                	mov    %edx,%edi
  800e31:	89 d6                	mov    %edx,%esi
  800e33:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    

00800e3a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e45:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e50:	89 df                	mov    %ebx,%edi
  800e52:	89 de                	mov    %ebx,%esi
  800e54:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800e56:	5b                   	pop    %ebx
  800e57:	5e                   	pop    %esi
  800e58:	5f                   	pop    %edi
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    

00800e5b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e66:	b8 10 00 00 00       	mov    $0x10,%eax
  800e6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e71:	89 df                	mov    %ebx,%edi
  800e73:	89 de                	mov    %ebx,%esi
  800e75:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800e77:	5b                   	pop    %ebx
  800e78:	5e                   	pop    %esi
  800e79:	5f                   	pop    %edi
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    

00800e7c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	57                   	push   %edi
  800e80:	56                   	push   %esi
  800e81:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e87:	b8 11 00 00 00       	mov    $0x11,%eax
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	89 cb                	mov    %ecx,%ebx
  800e91:	89 cf                	mov    %ecx,%edi
  800e93:	89 ce                	mov    %ecx,%esi
  800e95:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800e97:	5b                   	pop    %ebx
  800e98:	5e                   	pop    %esi
  800e99:	5f                   	pop    %edi
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	57                   	push   %edi
  800ea0:	56                   	push   %esi
  800ea1:	53                   	push   %ebx
  800ea2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea5:	be 00 00 00 00       	mov    $0x0,%esi
  800eaa:	b8 12 00 00 00       	mov    $0x12,%eax
  800eaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eb8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ebb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ebd:	85 c0                	test   %eax,%eax
  800ebf:	7e 28                	jle    800ee9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800ecc:	00 
  800ecd:	c7 44 24 08 c7 29 80 	movl   $0x8029c7,0x8(%esp)
  800ed4:	00 
  800ed5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800edc:	00 
  800edd:	c7 04 24 e4 29 80 00 	movl   $0x8029e4,(%esp)
  800ee4:	e8 2d 13 00 00       	call   802216 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  800ee9:	83 c4 2c             	add    $0x2c,%esp
  800eec:	5b                   	pop    %ebx
  800eed:	5e                   	pop    %esi
  800eee:	5f                   	pop    %edi
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    
  800ef1:	66 90                	xchg   %ax,%ax
  800ef3:	66 90                	xchg   %ax,%ax
  800ef5:	66 90                	xchg   %ax,%ax
  800ef7:	66 90                	xchg   %ax,%ax
  800ef9:	66 90                	xchg   %ax,%ax
  800efb:	66 90                	xchg   %ax,%ax
  800efd:	66 90                	xchg   %ax,%ax
  800eff:	90                   	nop

00800f00 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	05 00 00 00 30       	add    $0x30000000,%eax
  800f0b:	c1 e8 0c             	shr    $0xc,%eax
}
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800f1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f20:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f25:	5d                   	pop    %ebp
  800f26:	c3                   	ret    

00800f27 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f27:	55                   	push   %ebp
  800f28:	89 e5                	mov    %esp,%ebp
  800f2a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f2d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f32:	89 c2                	mov    %eax,%edx
  800f34:	c1 ea 16             	shr    $0x16,%edx
  800f37:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f3e:	f6 c2 01             	test   $0x1,%dl
  800f41:	74 11                	je     800f54 <fd_alloc+0x2d>
  800f43:	89 c2                	mov    %eax,%edx
  800f45:	c1 ea 0c             	shr    $0xc,%edx
  800f48:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f4f:	f6 c2 01             	test   $0x1,%dl
  800f52:	75 09                	jne    800f5d <fd_alloc+0x36>
			*fd_store = fd;
  800f54:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f56:	b8 00 00 00 00       	mov    $0x0,%eax
  800f5b:	eb 17                	jmp    800f74 <fd_alloc+0x4d>
  800f5d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f62:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f67:	75 c9                	jne    800f32 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f69:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f6f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f7c:	83 f8 1f             	cmp    $0x1f,%eax
  800f7f:	77 36                	ja     800fb7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f81:	c1 e0 0c             	shl    $0xc,%eax
  800f84:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f89:	89 c2                	mov    %eax,%edx
  800f8b:	c1 ea 16             	shr    $0x16,%edx
  800f8e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f95:	f6 c2 01             	test   $0x1,%dl
  800f98:	74 24                	je     800fbe <fd_lookup+0x48>
  800f9a:	89 c2                	mov    %eax,%edx
  800f9c:	c1 ea 0c             	shr    $0xc,%edx
  800f9f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fa6:	f6 c2 01             	test   $0x1,%dl
  800fa9:	74 1a                	je     800fc5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fae:	89 02                	mov    %eax,(%edx)
	return 0;
  800fb0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb5:	eb 13                	jmp    800fca <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800fb7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fbc:	eb 0c                	jmp    800fca <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800fbe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fc3:	eb 05                	jmp    800fca <fd_lookup+0x54>
  800fc5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800fca:	5d                   	pop    %ebp
  800fcb:	c3                   	ret    

00800fcc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 18             	sub    $0x18,%esp
  800fd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  800fd5:	ba 00 00 00 00       	mov    $0x0,%edx
  800fda:	eb 13                	jmp    800fef <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  800fdc:	39 08                	cmp    %ecx,(%eax)
  800fde:	75 0c                	jne    800fec <dev_lookup+0x20>
			*dev = devtab[i];
  800fe0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe3:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fea:	eb 38                	jmp    801024 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800fec:	83 c2 01             	add    $0x1,%edx
  800fef:	8b 04 95 70 2a 80 00 	mov    0x802a70(,%edx,4),%eax
  800ff6:	85 c0                	test   %eax,%eax
  800ff8:	75 e2                	jne    800fdc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ffa:	a1 08 40 80 00       	mov    0x804008,%eax
  800fff:	8b 40 48             	mov    0x48(%eax),%eax
  801002:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801006:	89 44 24 04          	mov    %eax,0x4(%esp)
  80100a:	c7 04 24 f4 29 80 00 	movl   $0x8029f4,(%esp)
  801011:	e8 53 f1 ff ff       	call   800169 <cprintf>
	*dev = 0;
  801016:	8b 45 0c             	mov    0xc(%ebp),%eax
  801019:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80101f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	56                   	push   %esi
  80102a:	53                   	push   %ebx
  80102b:	83 ec 20             	sub    $0x20,%esp
  80102e:	8b 75 08             	mov    0x8(%ebp),%esi
  801031:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801034:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801037:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80103b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801041:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801044:	89 04 24             	mov    %eax,(%esp)
  801047:	e8 2a ff ff ff       	call   800f76 <fd_lookup>
  80104c:	85 c0                	test   %eax,%eax
  80104e:	78 05                	js     801055 <fd_close+0x2f>
	    || fd != fd2)
  801050:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801053:	74 0c                	je     801061 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801055:	84 db                	test   %bl,%bl
  801057:	ba 00 00 00 00       	mov    $0x0,%edx
  80105c:	0f 44 c2             	cmove  %edx,%eax
  80105f:	eb 3f                	jmp    8010a0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801061:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801064:	89 44 24 04          	mov    %eax,0x4(%esp)
  801068:	8b 06                	mov    (%esi),%eax
  80106a:	89 04 24             	mov    %eax,(%esp)
  80106d:	e8 5a ff ff ff       	call   800fcc <dev_lookup>
  801072:	89 c3                	mov    %eax,%ebx
  801074:	85 c0                	test   %eax,%eax
  801076:	78 16                	js     80108e <fd_close+0x68>
		if (dev->dev_close)
  801078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80107b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80107e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801083:	85 c0                	test   %eax,%eax
  801085:	74 07                	je     80108e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801087:	89 34 24             	mov    %esi,(%esp)
  80108a:	ff d0                	call   *%eax
  80108c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80108e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801092:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801099:	e8 bc fb ff ff       	call   800c5a <sys_page_unmap>
	return r;
  80109e:	89 d8                	mov    %ebx,%eax
}
  8010a0:	83 c4 20             	add    $0x20,%esp
  8010a3:	5b                   	pop    %ebx
  8010a4:	5e                   	pop    %esi
  8010a5:	5d                   	pop    %ebp
  8010a6:	c3                   	ret    

008010a7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	89 04 24             	mov    %eax,(%esp)
  8010ba:	e8 b7 fe ff ff       	call   800f76 <fd_lookup>
  8010bf:	89 c2                	mov    %eax,%edx
  8010c1:	85 d2                	test   %edx,%edx
  8010c3:	78 13                	js     8010d8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8010c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8010cc:	00 
  8010cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d0:	89 04 24             	mov    %eax,(%esp)
  8010d3:	e8 4e ff ff ff       	call   801026 <fd_close>
}
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <close_all>:

void
close_all(void)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	53                   	push   %ebx
  8010de:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8010e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010e6:	89 1c 24             	mov    %ebx,(%esp)
  8010e9:	e8 b9 ff ff ff       	call   8010a7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8010ee:	83 c3 01             	add    $0x1,%ebx
  8010f1:	83 fb 20             	cmp    $0x20,%ebx
  8010f4:	75 f0                	jne    8010e6 <close_all+0xc>
		close(i);
}
  8010f6:	83 c4 14             	add    $0x14,%esp
  8010f9:	5b                   	pop    %ebx
  8010fa:	5d                   	pop    %ebp
  8010fb:	c3                   	ret    

008010fc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	57                   	push   %edi
  801100:	56                   	push   %esi
  801101:	53                   	push   %ebx
  801102:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801105:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801108:	89 44 24 04          	mov    %eax,0x4(%esp)
  80110c:	8b 45 08             	mov    0x8(%ebp),%eax
  80110f:	89 04 24             	mov    %eax,(%esp)
  801112:	e8 5f fe ff ff       	call   800f76 <fd_lookup>
  801117:	89 c2                	mov    %eax,%edx
  801119:	85 d2                	test   %edx,%edx
  80111b:	0f 88 e1 00 00 00    	js     801202 <dup+0x106>
		return r;
	close(newfdnum);
  801121:	8b 45 0c             	mov    0xc(%ebp),%eax
  801124:	89 04 24             	mov    %eax,(%esp)
  801127:	e8 7b ff ff ff       	call   8010a7 <close>

	newfd = INDEX2FD(newfdnum);
  80112c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80112f:	c1 e3 0c             	shl    $0xc,%ebx
  801132:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801138:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80113b:	89 04 24             	mov    %eax,(%esp)
  80113e:	e8 cd fd ff ff       	call   800f10 <fd2data>
  801143:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801145:	89 1c 24             	mov    %ebx,(%esp)
  801148:	e8 c3 fd ff ff       	call   800f10 <fd2data>
  80114d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80114f:	89 f0                	mov    %esi,%eax
  801151:	c1 e8 16             	shr    $0x16,%eax
  801154:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80115b:	a8 01                	test   $0x1,%al
  80115d:	74 43                	je     8011a2 <dup+0xa6>
  80115f:	89 f0                	mov    %esi,%eax
  801161:	c1 e8 0c             	shr    $0xc,%eax
  801164:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80116b:	f6 c2 01             	test   $0x1,%dl
  80116e:	74 32                	je     8011a2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801170:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801177:	25 07 0e 00 00       	and    $0xe07,%eax
  80117c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801180:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801184:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80118b:	00 
  80118c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801190:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801197:	e8 6b fa ff ff       	call   800c07 <sys_page_map>
  80119c:	89 c6                	mov    %eax,%esi
  80119e:	85 c0                	test   %eax,%eax
  8011a0:	78 3e                	js     8011e0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011a5:	89 c2                	mov    %eax,%edx
  8011a7:	c1 ea 0c             	shr    $0xc,%edx
  8011aa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011b1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8011b7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8011bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011c6:	00 
  8011c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d2:	e8 30 fa ff ff       	call   800c07 <sys_page_map>
  8011d7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8011d9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011dc:	85 f6                	test   %esi,%esi
  8011de:	79 22                	jns    801202 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8011e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011eb:	e8 6a fa ff ff       	call   800c5a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011fb:	e8 5a fa ff ff       	call   800c5a <sys_page_unmap>
	return r;
  801200:	89 f0                	mov    %esi,%eax
}
  801202:	83 c4 3c             	add    $0x3c,%esp
  801205:	5b                   	pop    %ebx
  801206:	5e                   	pop    %esi
  801207:	5f                   	pop    %edi
  801208:	5d                   	pop    %ebp
  801209:	c3                   	ret    

0080120a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	53                   	push   %ebx
  80120e:	83 ec 24             	sub    $0x24,%esp
  801211:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801214:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801217:	89 44 24 04          	mov    %eax,0x4(%esp)
  80121b:	89 1c 24             	mov    %ebx,(%esp)
  80121e:	e8 53 fd ff ff       	call   800f76 <fd_lookup>
  801223:	89 c2                	mov    %eax,%edx
  801225:	85 d2                	test   %edx,%edx
  801227:	78 6d                	js     801296 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801229:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80122c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801233:	8b 00                	mov    (%eax),%eax
  801235:	89 04 24             	mov    %eax,(%esp)
  801238:	e8 8f fd ff ff       	call   800fcc <dev_lookup>
  80123d:	85 c0                	test   %eax,%eax
  80123f:	78 55                	js     801296 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801241:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801244:	8b 50 08             	mov    0x8(%eax),%edx
  801247:	83 e2 03             	and    $0x3,%edx
  80124a:	83 fa 01             	cmp    $0x1,%edx
  80124d:	75 23                	jne    801272 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80124f:	a1 08 40 80 00       	mov    0x804008,%eax
  801254:	8b 40 48             	mov    0x48(%eax),%eax
  801257:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80125b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80125f:	c7 04 24 35 2a 80 00 	movl   $0x802a35,(%esp)
  801266:	e8 fe ee ff ff       	call   800169 <cprintf>
		return -E_INVAL;
  80126b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801270:	eb 24                	jmp    801296 <read+0x8c>
	}
	if (!dev->dev_read)
  801272:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801275:	8b 52 08             	mov    0x8(%edx),%edx
  801278:	85 d2                	test   %edx,%edx
  80127a:	74 15                	je     801291 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80127c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80127f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801283:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801286:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80128a:	89 04 24             	mov    %eax,(%esp)
  80128d:	ff d2                	call   *%edx
  80128f:	eb 05                	jmp    801296 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801291:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801296:	83 c4 24             	add    $0x24,%esp
  801299:	5b                   	pop    %ebx
  80129a:	5d                   	pop    %ebp
  80129b:	c3                   	ret    

0080129c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	57                   	push   %edi
  8012a0:	56                   	push   %esi
  8012a1:	53                   	push   %ebx
  8012a2:	83 ec 1c             	sub    $0x1c,%esp
  8012a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b0:	eb 23                	jmp    8012d5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012b2:	89 f0                	mov    %esi,%eax
  8012b4:	29 d8                	sub    %ebx,%eax
  8012b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012ba:	89 d8                	mov    %ebx,%eax
  8012bc:	03 45 0c             	add    0xc(%ebp),%eax
  8012bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c3:	89 3c 24             	mov    %edi,(%esp)
  8012c6:	e8 3f ff ff ff       	call   80120a <read>
		if (m < 0)
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	78 10                	js     8012df <readn+0x43>
			return m;
		if (m == 0)
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	74 0a                	je     8012dd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012d3:	01 c3                	add    %eax,%ebx
  8012d5:	39 f3                	cmp    %esi,%ebx
  8012d7:	72 d9                	jb     8012b2 <readn+0x16>
  8012d9:	89 d8                	mov    %ebx,%eax
  8012db:	eb 02                	jmp    8012df <readn+0x43>
  8012dd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8012df:	83 c4 1c             	add    $0x1c,%esp
  8012e2:	5b                   	pop    %ebx
  8012e3:	5e                   	pop    %esi
  8012e4:	5f                   	pop    %edi
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    

008012e7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	53                   	push   %ebx
  8012eb:	83 ec 24             	sub    $0x24,%esp
  8012ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012f8:	89 1c 24             	mov    %ebx,(%esp)
  8012fb:	e8 76 fc ff ff       	call   800f76 <fd_lookup>
  801300:	89 c2                	mov    %eax,%edx
  801302:	85 d2                	test   %edx,%edx
  801304:	78 68                	js     80136e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801306:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801309:	89 44 24 04          	mov    %eax,0x4(%esp)
  80130d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801310:	8b 00                	mov    (%eax),%eax
  801312:	89 04 24             	mov    %eax,(%esp)
  801315:	e8 b2 fc ff ff       	call   800fcc <dev_lookup>
  80131a:	85 c0                	test   %eax,%eax
  80131c:	78 50                	js     80136e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80131e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801321:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801325:	75 23                	jne    80134a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801327:	a1 08 40 80 00       	mov    0x804008,%eax
  80132c:	8b 40 48             	mov    0x48(%eax),%eax
  80132f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801333:	89 44 24 04          	mov    %eax,0x4(%esp)
  801337:	c7 04 24 51 2a 80 00 	movl   $0x802a51,(%esp)
  80133e:	e8 26 ee ff ff       	call   800169 <cprintf>
		return -E_INVAL;
  801343:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801348:	eb 24                	jmp    80136e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80134a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80134d:	8b 52 0c             	mov    0xc(%edx),%edx
  801350:	85 d2                	test   %edx,%edx
  801352:	74 15                	je     801369 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801354:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801357:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80135b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80135e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801362:	89 04 24             	mov    %eax,(%esp)
  801365:	ff d2                	call   *%edx
  801367:	eb 05                	jmp    80136e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801369:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80136e:	83 c4 24             	add    $0x24,%esp
  801371:	5b                   	pop    %ebx
  801372:	5d                   	pop    %ebp
  801373:	c3                   	ret    

00801374 <seek>:

int
seek(int fdnum, off_t offset)
{
  801374:	55                   	push   %ebp
  801375:	89 e5                	mov    %esp,%ebp
  801377:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80137a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80137d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	89 04 24             	mov    %eax,(%esp)
  801387:	e8 ea fb ff ff       	call   800f76 <fd_lookup>
  80138c:	85 c0                	test   %eax,%eax
  80138e:	78 0e                	js     80139e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801390:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801393:	8b 55 0c             	mov    0xc(%ebp),%edx
  801396:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801399:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    

008013a0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	53                   	push   %ebx
  8013a4:	83 ec 24             	sub    $0x24,%esp
  8013a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b1:	89 1c 24             	mov    %ebx,(%esp)
  8013b4:	e8 bd fb ff ff       	call   800f76 <fd_lookup>
  8013b9:	89 c2                	mov    %eax,%edx
  8013bb:	85 d2                	test   %edx,%edx
  8013bd:	78 61                	js     801420 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c9:	8b 00                	mov    (%eax),%eax
  8013cb:	89 04 24             	mov    %eax,(%esp)
  8013ce:	e8 f9 fb ff ff       	call   800fcc <dev_lookup>
  8013d3:	85 c0                	test   %eax,%eax
  8013d5:	78 49                	js     801420 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013da:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013de:	75 23                	jne    801403 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8013e0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8013e5:	8b 40 48             	mov    0x48(%eax),%eax
  8013e8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f0:	c7 04 24 14 2a 80 00 	movl   $0x802a14,(%esp)
  8013f7:	e8 6d ed ff ff       	call   800169 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8013fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801401:	eb 1d                	jmp    801420 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801403:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801406:	8b 52 18             	mov    0x18(%edx),%edx
  801409:	85 d2                	test   %edx,%edx
  80140b:	74 0e                	je     80141b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80140d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801410:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801414:	89 04 24             	mov    %eax,(%esp)
  801417:	ff d2                	call   *%edx
  801419:	eb 05                	jmp    801420 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80141b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801420:	83 c4 24             	add    $0x24,%esp
  801423:	5b                   	pop    %ebx
  801424:	5d                   	pop    %ebp
  801425:	c3                   	ret    

00801426 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
  801429:	53                   	push   %ebx
  80142a:	83 ec 24             	sub    $0x24,%esp
  80142d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801430:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801433:	89 44 24 04          	mov    %eax,0x4(%esp)
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	89 04 24             	mov    %eax,(%esp)
  80143d:	e8 34 fb ff ff       	call   800f76 <fd_lookup>
  801442:	89 c2                	mov    %eax,%edx
  801444:	85 d2                	test   %edx,%edx
  801446:	78 52                	js     80149a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801448:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801452:	8b 00                	mov    (%eax),%eax
  801454:	89 04 24             	mov    %eax,(%esp)
  801457:	e8 70 fb ff ff       	call   800fcc <dev_lookup>
  80145c:	85 c0                	test   %eax,%eax
  80145e:	78 3a                	js     80149a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801463:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801467:	74 2c                	je     801495 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801469:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80146c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801473:	00 00 00 
	stat->st_isdir = 0;
  801476:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80147d:	00 00 00 
	stat->st_dev = dev;
  801480:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801486:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80148a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80148d:	89 14 24             	mov    %edx,(%esp)
  801490:	ff 50 14             	call   *0x14(%eax)
  801493:	eb 05                	jmp    80149a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801495:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80149a:	83 c4 24             	add    $0x24,%esp
  80149d:	5b                   	pop    %ebx
  80149e:	5d                   	pop    %ebp
  80149f:	c3                   	ret    

008014a0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	56                   	push   %esi
  8014a4:	53                   	push   %ebx
  8014a5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8014af:	00 
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	89 04 24             	mov    %eax,(%esp)
  8014b6:	e8 84 02 00 00       	call   80173f <open>
  8014bb:	89 c3                	mov    %eax,%ebx
  8014bd:	85 db                	test   %ebx,%ebx
  8014bf:	78 1b                	js     8014dc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8014c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c8:	89 1c 24             	mov    %ebx,(%esp)
  8014cb:	e8 56 ff ff ff       	call   801426 <fstat>
  8014d0:	89 c6                	mov    %eax,%esi
	close(fd);
  8014d2:	89 1c 24             	mov    %ebx,(%esp)
  8014d5:	e8 cd fb ff ff       	call   8010a7 <close>
	return r;
  8014da:	89 f0                	mov    %esi,%eax
}
  8014dc:	83 c4 10             	add    $0x10,%esp
  8014df:	5b                   	pop    %ebx
  8014e0:	5e                   	pop    %esi
  8014e1:	5d                   	pop    %ebp
  8014e2:	c3                   	ret    

008014e3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	56                   	push   %esi
  8014e7:	53                   	push   %ebx
  8014e8:	83 ec 10             	sub    $0x10,%esp
  8014eb:	89 c6                	mov    %eax,%esi
  8014ed:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8014ef:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8014f6:	75 11                	jne    801509 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8014f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8014ff:	e8 61 0e 00 00       	call   802365 <ipc_find_env>
  801504:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801509:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801510:	00 
  801511:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801518:	00 
  801519:	89 74 24 04          	mov    %esi,0x4(%esp)
  80151d:	a1 00 40 80 00       	mov    0x804000,%eax
  801522:	89 04 24             	mov    %eax,(%esp)
  801525:	e8 ae 0d 00 00       	call   8022d8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80152a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801531:	00 
  801532:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801536:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80153d:	e8 2e 0d 00 00       	call   802270 <ipc_recv>
}
  801542:	83 c4 10             	add    $0x10,%esp
  801545:	5b                   	pop    %ebx
  801546:	5e                   	pop    %esi
  801547:	5d                   	pop    %ebp
  801548:	c3                   	ret    

00801549 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80154f:	8b 45 08             	mov    0x8(%ebp),%eax
  801552:	8b 40 0c             	mov    0xc(%eax),%eax
  801555:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80155a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801562:	ba 00 00 00 00       	mov    $0x0,%edx
  801567:	b8 02 00 00 00       	mov    $0x2,%eax
  80156c:	e8 72 ff ff ff       	call   8014e3 <fsipc>
}
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8b 40 0c             	mov    0xc(%eax),%eax
  80157f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801584:	ba 00 00 00 00       	mov    $0x0,%edx
  801589:	b8 06 00 00 00       	mov    $0x6,%eax
  80158e:	e8 50 ff ff ff       	call   8014e3 <fsipc>
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	53                   	push   %ebx
  801599:	83 ec 14             	sub    $0x14,%esp
  80159c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80159f:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8015af:	b8 05 00 00 00       	mov    $0x5,%eax
  8015b4:	e8 2a ff ff ff       	call   8014e3 <fsipc>
  8015b9:	89 c2                	mov    %eax,%edx
  8015bb:	85 d2                	test   %edx,%edx
  8015bd:	78 2b                	js     8015ea <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015bf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8015c6:	00 
  8015c7:	89 1c 24             	mov    %ebx,(%esp)
  8015ca:	e8 c8 f1 ff ff       	call   800797 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015cf:	a1 80 50 80 00       	mov    0x805080,%eax
  8015d4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015da:	a1 84 50 80 00       	mov    0x805084,%eax
  8015df:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8015e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ea:	83 c4 14             	add    $0x14,%esp
  8015ed:	5b                   	pop    %ebx
  8015ee:	5d                   	pop    %ebp
  8015ef:	c3                   	ret    

008015f0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	53                   	push   %ebx
  8015f4:	83 ec 14             	sub    $0x14,%esp
  8015f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801600:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801605:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80160b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801610:	0f 46 c3             	cmovbe %ebx,%eax
  801613:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801618:	89 44 24 08          	mov    %eax,0x8(%esp)
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801623:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80162a:	e8 05 f3 ff ff       	call   800934 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80162f:	ba 00 00 00 00       	mov    $0x0,%edx
  801634:	b8 04 00 00 00       	mov    $0x4,%eax
  801639:	e8 a5 fe ff ff       	call   8014e3 <fsipc>
  80163e:	85 c0                	test   %eax,%eax
  801640:	78 53                	js     801695 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801642:	39 c3                	cmp    %eax,%ebx
  801644:	73 24                	jae    80166a <devfile_write+0x7a>
  801646:	c7 44 24 0c 84 2a 80 	movl   $0x802a84,0xc(%esp)
  80164d:	00 
  80164e:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  801655:	00 
  801656:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  80165d:	00 
  80165e:	c7 04 24 a0 2a 80 00 	movl   $0x802aa0,(%esp)
  801665:	e8 ac 0b 00 00       	call   802216 <_panic>
	assert(r <= PGSIZE);
  80166a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80166f:	7e 24                	jle    801695 <devfile_write+0xa5>
  801671:	c7 44 24 0c ab 2a 80 	movl   $0x802aab,0xc(%esp)
  801678:	00 
  801679:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  801680:	00 
  801681:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801688:	00 
  801689:	c7 04 24 a0 2a 80 00 	movl   $0x802aa0,(%esp)
  801690:	e8 81 0b 00 00       	call   802216 <_panic>
	return r;
}
  801695:	83 c4 14             	add    $0x14,%esp
  801698:	5b                   	pop    %ebx
  801699:	5d                   	pop    %ebp
  80169a:	c3                   	ret    

0080169b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
  80169e:	56                   	push   %esi
  80169f:	53                   	push   %ebx
  8016a0:	83 ec 10             	sub    $0x10,%esp
  8016a3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ac:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016b1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bc:	b8 03 00 00 00       	mov    $0x3,%eax
  8016c1:	e8 1d fe ff ff       	call   8014e3 <fsipc>
  8016c6:	89 c3                	mov    %eax,%ebx
  8016c8:	85 c0                	test   %eax,%eax
  8016ca:	78 6a                	js     801736 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8016cc:	39 c6                	cmp    %eax,%esi
  8016ce:	73 24                	jae    8016f4 <devfile_read+0x59>
  8016d0:	c7 44 24 0c 84 2a 80 	movl   $0x802a84,0xc(%esp)
  8016d7:	00 
  8016d8:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  8016df:	00 
  8016e0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8016e7:	00 
  8016e8:	c7 04 24 a0 2a 80 00 	movl   $0x802aa0,(%esp)
  8016ef:	e8 22 0b 00 00       	call   802216 <_panic>
	assert(r <= PGSIZE);
  8016f4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016f9:	7e 24                	jle    80171f <devfile_read+0x84>
  8016fb:	c7 44 24 0c ab 2a 80 	movl   $0x802aab,0xc(%esp)
  801702:	00 
  801703:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  80170a:	00 
  80170b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801712:	00 
  801713:	c7 04 24 a0 2a 80 00 	movl   $0x802aa0,(%esp)
  80171a:	e8 f7 0a 00 00       	call   802216 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80171f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801723:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80172a:	00 
  80172b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172e:	89 04 24             	mov    %eax,(%esp)
  801731:	e8 fe f1 ff ff       	call   800934 <memmove>
	return r;
}
  801736:	89 d8                	mov    %ebx,%eax
  801738:	83 c4 10             	add    $0x10,%esp
  80173b:	5b                   	pop    %ebx
  80173c:	5e                   	pop    %esi
  80173d:	5d                   	pop    %ebp
  80173e:	c3                   	ret    

0080173f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	53                   	push   %ebx
  801743:	83 ec 24             	sub    $0x24,%esp
  801746:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801749:	89 1c 24             	mov    %ebx,(%esp)
  80174c:	e8 0f f0 ff ff       	call   800760 <strlen>
  801751:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801756:	7f 60                	jg     8017b8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801758:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80175b:	89 04 24             	mov    %eax,(%esp)
  80175e:	e8 c4 f7 ff ff       	call   800f27 <fd_alloc>
  801763:	89 c2                	mov    %eax,%edx
  801765:	85 d2                	test   %edx,%edx
  801767:	78 54                	js     8017bd <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801769:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80176d:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801774:	e8 1e f0 ff ff       	call   800797 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801779:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177c:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801781:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801784:	b8 01 00 00 00       	mov    $0x1,%eax
  801789:	e8 55 fd ff ff       	call   8014e3 <fsipc>
  80178e:	89 c3                	mov    %eax,%ebx
  801790:	85 c0                	test   %eax,%eax
  801792:	79 17                	jns    8017ab <open+0x6c>
		fd_close(fd, 0);
  801794:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80179b:	00 
  80179c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179f:	89 04 24             	mov    %eax,(%esp)
  8017a2:	e8 7f f8 ff ff       	call   801026 <fd_close>
		return r;
  8017a7:	89 d8                	mov    %ebx,%eax
  8017a9:	eb 12                	jmp    8017bd <open+0x7e>
	}

	return fd2num(fd);
  8017ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ae:	89 04 24             	mov    %eax,(%esp)
  8017b1:	e8 4a f7 ff ff       	call   800f00 <fd2num>
  8017b6:	eb 05                	jmp    8017bd <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8017b8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8017bd:	83 c4 24             	add    $0x24,%esp
  8017c0:	5b                   	pop    %ebx
  8017c1:	5d                   	pop    %ebp
  8017c2:	c3                   	ret    

008017c3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8017d3:	e8 0b fd ff ff       	call   8014e3 <fsipc>
}
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    
  8017da:	66 90                	xchg   %ax,%ax
  8017dc:	66 90                	xchg   %ax,%ax
  8017de:	66 90                	xchg   %ax,%ax

008017e0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8017e6:	c7 44 24 04 b7 2a 80 	movl   $0x802ab7,0x4(%esp)
  8017ed:	00 
  8017ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f1:	89 04 24             	mov    %eax,(%esp)
  8017f4:	e8 9e ef ff ff       	call   800797 <strcpy>
	return 0;
}
  8017f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	53                   	push   %ebx
  801804:	83 ec 14             	sub    $0x14,%esp
  801807:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80180a:	89 1c 24             	mov    %ebx,(%esp)
  80180d:	e8 8d 0b 00 00       	call   80239f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801812:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801817:	83 f8 01             	cmp    $0x1,%eax
  80181a:	75 0d                	jne    801829 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80181c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80181f:	89 04 24             	mov    %eax,(%esp)
  801822:	e8 29 03 00 00       	call   801b50 <nsipc_close>
  801827:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801829:	89 d0                	mov    %edx,%eax
  80182b:	83 c4 14             	add    $0x14,%esp
  80182e:	5b                   	pop    %ebx
  80182f:	5d                   	pop    %ebp
  801830:	c3                   	ret    

00801831 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
  801834:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801837:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80183e:	00 
  80183f:	8b 45 10             	mov    0x10(%ebp),%eax
  801842:	89 44 24 08          	mov    %eax,0x8(%esp)
  801846:	8b 45 0c             	mov    0xc(%ebp),%eax
  801849:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	8b 40 0c             	mov    0xc(%eax),%eax
  801853:	89 04 24             	mov    %eax,(%esp)
  801856:	e8 f0 03 00 00       	call   801c4b <nsipc_send>
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801863:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80186a:	00 
  80186b:	8b 45 10             	mov    0x10(%ebp),%eax
  80186e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801872:	8b 45 0c             	mov    0xc(%ebp),%eax
  801875:	89 44 24 04          	mov    %eax,0x4(%esp)
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	8b 40 0c             	mov    0xc(%eax),%eax
  80187f:	89 04 24             	mov    %eax,(%esp)
  801882:	e8 44 03 00 00       	call   801bcb <nsipc_recv>
}
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
  80188c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80188f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801892:	89 54 24 04          	mov    %edx,0x4(%esp)
  801896:	89 04 24             	mov    %eax,(%esp)
  801899:	e8 d8 f6 ff ff       	call   800f76 <fd_lookup>
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	78 17                	js     8018b9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8018a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018ab:	39 08                	cmp    %ecx,(%eax)
  8018ad:	75 05                	jne    8018b4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8018af:	8b 40 0c             	mov    0xc(%eax),%eax
  8018b2:	eb 05                	jmp    8018b9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8018b4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8018b9:	c9                   	leave  
  8018ba:	c3                   	ret    

008018bb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	56                   	push   %esi
  8018bf:	53                   	push   %ebx
  8018c0:	83 ec 20             	sub    $0x20,%esp
  8018c3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8018c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c8:	89 04 24             	mov    %eax,(%esp)
  8018cb:	e8 57 f6 ff ff       	call   800f27 <fd_alloc>
  8018d0:	89 c3                	mov    %eax,%ebx
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	78 21                	js     8018f7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018d6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8018dd:	00 
  8018de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018ec:	e8 c2 f2 ff ff       	call   800bb3 <sys_page_alloc>
  8018f1:	89 c3                	mov    %eax,%ebx
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	79 0c                	jns    801903 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8018f7:	89 34 24             	mov    %esi,(%esp)
  8018fa:	e8 51 02 00 00       	call   801b50 <nsipc_close>
		return r;
  8018ff:	89 d8                	mov    %ebx,%eax
  801901:	eb 20                	jmp    801923 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801903:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80190e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801911:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801918:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80191b:	89 14 24             	mov    %edx,(%esp)
  80191e:	e8 dd f5 ff ff       	call   800f00 <fd2num>
}
  801923:	83 c4 20             	add    $0x20,%esp
  801926:	5b                   	pop    %ebx
  801927:	5e                   	pop    %esi
  801928:	5d                   	pop    %ebp
  801929:	c3                   	ret    

0080192a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	e8 51 ff ff ff       	call   801889 <fd2sockid>
		return r;
  801938:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80193a:	85 c0                	test   %eax,%eax
  80193c:	78 23                	js     801961 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80193e:	8b 55 10             	mov    0x10(%ebp),%edx
  801941:	89 54 24 08          	mov    %edx,0x8(%esp)
  801945:	8b 55 0c             	mov    0xc(%ebp),%edx
  801948:	89 54 24 04          	mov    %edx,0x4(%esp)
  80194c:	89 04 24             	mov    %eax,(%esp)
  80194f:	e8 45 01 00 00       	call   801a99 <nsipc_accept>
		return r;
  801954:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801956:	85 c0                	test   %eax,%eax
  801958:	78 07                	js     801961 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80195a:	e8 5c ff ff ff       	call   8018bb <alloc_sockfd>
  80195f:	89 c1                	mov    %eax,%ecx
}
  801961:	89 c8                	mov    %ecx,%eax
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	e8 16 ff ff ff       	call   801889 <fd2sockid>
  801973:	89 c2                	mov    %eax,%edx
  801975:	85 d2                	test   %edx,%edx
  801977:	78 16                	js     80198f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801979:	8b 45 10             	mov    0x10(%ebp),%eax
  80197c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801980:	8b 45 0c             	mov    0xc(%ebp),%eax
  801983:	89 44 24 04          	mov    %eax,0x4(%esp)
  801987:	89 14 24             	mov    %edx,(%esp)
  80198a:	e8 60 01 00 00       	call   801aef <nsipc_bind>
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <shutdown>:

int
shutdown(int s, int how)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801997:	8b 45 08             	mov    0x8(%ebp),%eax
  80199a:	e8 ea fe ff ff       	call   801889 <fd2sockid>
  80199f:	89 c2                	mov    %eax,%edx
  8019a1:	85 d2                	test   %edx,%edx
  8019a3:	78 0f                	js     8019b4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8019a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ac:	89 14 24             	mov    %edx,(%esp)
  8019af:	e8 7a 01 00 00       	call   801b2e <nsipc_shutdown>
}
  8019b4:	c9                   	leave  
  8019b5:	c3                   	ret    

008019b6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bf:	e8 c5 fe ff ff       	call   801889 <fd2sockid>
  8019c4:	89 c2                	mov    %eax,%edx
  8019c6:	85 d2                	test   %edx,%edx
  8019c8:	78 16                	js     8019e0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8019ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d8:	89 14 24             	mov    %edx,(%esp)
  8019db:	e8 8a 01 00 00       	call   801b6a <nsipc_connect>
}
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <listen>:

int
listen(int s, int backlog)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	e8 99 fe ff ff       	call   801889 <fd2sockid>
  8019f0:	89 c2                	mov    %eax,%edx
  8019f2:	85 d2                	test   %edx,%edx
  8019f4:	78 0f                	js     801a05 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8019f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fd:	89 14 24             	mov    %edx,(%esp)
  801a00:	e8 a4 01 00 00       	call   801ba9 <nsipc_listen>
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a10:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1e:	89 04 24             	mov    %eax,(%esp)
  801a21:	e8 98 02 00 00       	call   801cbe <nsipc_socket>
  801a26:	89 c2                	mov    %eax,%edx
  801a28:	85 d2                	test   %edx,%edx
  801a2a:	78 05                	js     801a31 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801a2c:	e8 8a fe ff ff       	call   8018bb <alloc_sockfd>
}
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
  801a36:	53                   	push   %ebx
  801a37:	83 ec 14             	sub    $0x14,%esp
  801a3a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a3c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a43:	75 11                	jne    801a56 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a45:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801a4c:	e8 14 09 00 00       	call   802365 <ipc_find_env>
  801a51:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a56:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a5d:	00 
  801a5e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a65:	00 
  801a66:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a6a:	a1 04 40 80 00       	mov    0x804004,%eax
  801a6f:	89 04 24             	mov    %eax,(%esp)
  801a72:	e8 61 08 00 00       	call   8022d8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a77:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a7e:	00 
  801a7f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a86:	00 
  801a87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a8e:	e8 dd 07 00 00       	call   802270 <ipc_recv>
}
  801a93:	83 c4 14             	add    $0x14,%esp
  801a96:	5b                   	pop    %ebx
  801a97:	5d                   	pop    %ebp
  801a98:	c3                   	ret    

00801a99 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	56                   	push   %esi
  801a9d:	53                   	push   %ebx
  801a9e:	83 ec 10             	sub    $0x10,%esp
  801aa1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801aac:	8b 06                	mov    (%esi),%eax
  801aae:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ab3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab8:	e8 76 ff ff ff       	call   801a33 <nsipc>
  801abd:	89 c3                	mov    %eax,%ebx
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	78 23                	js     801ae6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ac3:	a1 10 60 80 00       	mov    0x806010,%eax
  801ac8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801acc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ad3:	00 
  801ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad7:	89 04 24             	mov    %eax,(%esp)
  801ada:	e8 55 ee ff ff       	call   800934 <memmove>
		*addrlen = ret->ret_addrlen;
  801adf:	a1 10 60 80 00       	mov    0x806010,%eax
  801ae4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801ae6:	89 d8                	mov    %ebx,%eax
  801ae8:	83 c4 10             	add    $0x10,%esp
  801aeb:	5b                   	pop    %ebx
  801aec:	5e                   	pop    %esi
  801aed:	5d                   	pop    %ebp
  801aee:	c3                   	ret    

00801aef <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	53                   	push   %ebx
  801af3:	83 ec 14             	sub    $0x14,%esp
  801af6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b01:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801b13:	e8 1c ee ff ff       	call   800934 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b18:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b1e:	b8 02 00 00 00       	mov    $0x2,%eax
  801b23:	e8 0b ff ff ff       	call   801a33 <nsipc>
}
  801b28:	83 c4 14             	add    $0x14,%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5d                   	pop    %ebp
  801b2d:	c3                   	ret    

00801b2e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
  801b31:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b44:	b8 03 00 00 00       	mov    $0x3,%eax
  801b49:	e8 e5 fe ff ff       	call   801a33 <nsipc>
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <nsipc_close>:

int
nsipc_close(int s)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b5e:	b8 04 00 00 00       	mov    $0x4,%eax
  801b63:	e8 cb fe ff ff       	call   801a33 <nsipc>
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	53                   	push   %ebx
  801b6e:	83 ec 14             	sub    $0x14,%esp
  801b71:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b7c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b87:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801b8e:	e8 a1 ed ff ff       	call   800934 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b93:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b99:	b8 05 00 00 00       	mov    $0x5,%eax
  801b9e:	e8 90 fe ff ff       	call   801a33 <nsipc>
}
  801ba3:	83 c4 14             	add    $0x14,%esp
  801ba6:	5b                   	pop    %ebx
  801ba7:	5d                   	pop    %ebp
  801ba8:	c3                   	ret    

00801ba9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bba:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bbf:	b8 06 00 00 00       	mov    $0x6,%eax
  801bc4:	e8 6a fe ff ff       	call   801a33 <nsipc>
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	56                   	push   %esi
  801bcf:	53                   	push   %ebx
  801bd0:	83 ec 10             	sub    $0x10,%esp
  801bd3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bde:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801be4:	8b 45 14             	mov    0x14(%ebp),%eax
  801be7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bec:	b8 07 00 00 00       	mov    $0x7,%eax
  801bf1:	e8 3d fe ff ff       	call   801a33 <nsipc>
  801bf6:	89 c3                	mov    %eax,%ebx
  801bf8:	85 c0                	test   %eax,%eax
  801bfa:	78 46                	js     801c42 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801bfc:	39 f0                	cmp    %esi,%eax
  801bfe:	7f 07                	jg     801c07 <nsipc_recv+0x3c>
  801c00:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c05:	7e 24                	jle    801c2b <nsipc_recv+0x60>
  801c07:	c7 44 24 0c c3 2a 80 	movl   $0x802ac3,0xc(%esp)
  801c0e:	00 
  801c0f:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  801c16:	00 
  801c17:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801c1e:	00 
  801c1f:	c7 04 24 d8 2a 80 00 	movl   $0x802ad8,(%esp)
  801c26:	e8 eb 05 00 00       	call   802216 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c2b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c2f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c36:	00 
  801c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3a:	89 04 24             	mov    %eax,(%esp)
  801c3d:	e8 f2 ec ff ff       	call   800934 <memmove>
	}

	return r;
}
  801c42:	89 d8                	mov    %ebx,%eax
  801c44:	83 c4 10             	add    $0x10,%esp
  801c47:	5b                   	pop    %ebx
  801c48:	5e                   	pop    %esi
  801c49:	5d                   	pop    %ebp
  801c4a:	c3                   	ret    

00801c4b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	53                   	push   %ebx
  801c4f:	83 ec 14             	sub    $0x14,%esp
  801c52:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c5d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c63:	7e 24                	jle    801c89 <nsipc_send+0x3e>
  801c65:	c7 44 24 0c e4 2a 80 	movl   $0x802ae4,0xc(%esp)
  801c6c:	00 
  801c6d:	c7 44 24 08 8b 2a 80 	movl   $0x802a8b,0x8(%esp)
  801c74:	00 
  801c75:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801c7c:	00 
  801c7d:	c7 04 24 d8 2a 80 00 	movl   $0x802ad8,(%esp)
  801c84:	e8 8d 05 00 00       	call   802216 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c89:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c94:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801c9b:	e8 94 ec ff ff       	call   800934 <memmove>
	nsipcbuf.send.req_size = size;
  801ca0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ca6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801cae:	b8 08 00 00 00       	mov    $0x8,%eax
  801cb3:	e8 7b fd ff ff       	call   801a33 <nsipc>
}
  801cb8:	83 c4 14             	add    $0x14,%esp
  801cbb:	5b                   	pop    %ebx
  801cbc:	5d                   	pop    %ebp
  801cbd:	c3                   	ret    

00801cbe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cdc:	b8 09 00 00 00       	mov    $0x9,%eax
  801ce1:	e8 4d fd ff ff       	call   801a33 <nsipc>
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	56                   	push   %esi
  801cec:	53                   	push   %ebx
  801ced:	83 ec 10             	sub    $0x10,%esp
  801cf0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	89 04 24             	mov    %eax,(%esp)
  801cf9:	e8 12 f2 ff ff       	call   800f10 <fd2data>
  801cfe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d00:	c7 44 24 04 f0 2a 80 	movl   $0x802af0,0x4(%esp)
  801d07:	00 
  801d08:	89 1c 24             	mov    %ebx,(%esp)
  801d0b:	e8 87 ea ff ff       	call   800797 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d10:	8b 46 04             	mov    0x4(%esi),%eax
  801d13:	2b 06                	sub    (%esi),%eax
  801d15:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d1b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d22:	00 00 00 
	stat->st_dev = &devpipe;
  801d25:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d2c:	30 80 00 
	return 0;
}
  801d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d34:	83 c4 10             	add    $0x10,%esp
  801d37:	5b                   	pop    %ebx
  801d38:	5e                   	pop    %esi
  801d39:	5d                   	pop    %ebp
  801d3a:	c3                   	ret    

00801d3b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	53                   	push   %ebx
  801d3f:	83 ec 14             	sub    $0x14,%esp
  801d42:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d45:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d50:	e8 05 ef ff ff       	call   800c5a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d55:	89 1c 24             	mov    %ebx,(%esp)
  801d58:	e8 b3 f1 ff ff       	call   800f10 <fd2data>
  801d5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d68:	e8 ed ee ff ff       	call   800c5a <sys_page_unmap>
}
  801d6d:	83 c4 14             	add    $0x14,%esp
  801d70:	5b                   	pop    %ebx
  801d71:	5d                   	pop    %ebp
  801d72:	c3                   	ret    

00801d73 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
  801d76:	57                   	push   %edi
  801d77:	56                   	push   %esi
  801d78:	53                   	push   %ebx
  801d79:	83 ec 2c             	sub    $0x2c,%esp
  801d7c:	89 c6                	mov    %eax,%esi
  801d7e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801d81:	a1 08 40 80 00       	mov    0x804008,%eax
  801d86:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d89:	89 34 24             	mov    %esi,(%esp)
  801d8c:	e8 0e 06 00 00       	call   80239f <pageref>
  801d91:	89 c7                	mov    %eax,%edi
  801d93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d96:	89 04 24             	mov    %eax,(%esp)
  801d99:	e8 01 06 00 00       	call   80239f <pageref>
  801d9e:	39 c7                	cmp    %eax,%edi
  801da0:	0f 94 c2             	sete   %dl
  801da3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801da6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801dac:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801daf:	39 fb                	cmp    %edi,%ebx
  801db1:	74 21                	je     801dd4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801db3:	84 d2                	test   %dl,%dl
  801db5:	74 ca                	je     801d81 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801db7:	8b 51 58             	mov    0x58(%ecx),%edx
  801dba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dbe:	89 54 24 08          	mov    %edx,0x8(%esp)
  801dc2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dc6:	c7 04 24 f7 2a 80 00 	movl   $0x802af7,(%esp)
  801dcd:	e8 97 e3 ff ff       	call   800169 <cprintf>
  801dd2:	eb ad                	jmp    801d81 <_pipeisclosed+0xe>
	}
}
  801dd4:	83 c4 2c             	add    $0x2c,%esp
  801dd7:	5b                   	pop    %ebx
  801dd8:	5e                   	pop    %esi
  801dd9:	5f                   	pop    %edi
  801dda:	5d                   	pop    %ebp
  801ddb:	c3                   	ret    

00801ddc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	57                   	push   %edi
  801de0:	56                   	push   %esi
  801de1:	53                   	push   %ebx
  801de2:	83 ec 1c             	sub    $0x1c,%esp
  801de5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801de8:	89 34 24             	mov    %esi,(%esp)
  801deb:	e8 20 f1 ff ff       	call   800f10 <fd2data>
  801df0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801df2:	bf 00 00 00 00       	mov    $0x0,%edi
  801df7:	eb 45                	jmp    801e3e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801df9:	89 da                	mov    %ebx,%edx
  801dfb:	89 f0                	mov    %esi,%eax
  801dfd:	e8 71 ff ff ff       	call   801d73 <_pipeisclosed>
  801e02:	85 c0                	test   %eax,%eax
  801e04:	75 41                	jne    801e47 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e06:	e8 89 ed ff ff       	call   800b94 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e0b:	8b 43 04             	mov    0x4(%ebx),%eax
  801e0e:	8b 0b                	mov    (%ebx),%ecx
  801e10:	8d 51 20             	lea    0x20(%ecx),%edx
  801e13:	39 d0                	cmp    %edx,%eax
  801e15:	73 e2                	jae    801df9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e1a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e1e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e21:	99                   	cltd   
  801e22:	c1 ea 1b             	shr    $0x1b,%edx
  801e25:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801e28:	83 e1 1f             	and    $0x1f,%ecx
  801e2b:	29 d1                	sub    %edx,%ecx
  801e2d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801e31:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801e35:	83 c0 01             	add    $0x1,%eax
  801e38:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e3b:	83 c7 01             	add    $0x1,%edi
  801e3e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e41:	75 c8                	jne    801e0b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801e43:	89 f8                	mov    %edi,%eax
  801e45:	eb 05                	jmp    801e4c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e47:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801e4c:	83 c4 1c             	add    $0x1c,%esp
  801e4f:	5b                   	pop    %ebx
  801e50:	5e                   	pop    %esi
  801e51:	5f                   	pop    %edi
  801e52:	5d                   	pop    %ebp
  801e53:	c3                   	ret    

00801e54 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	57                   	push   %edi
  801e58:	56                   	push   %esi
  801e59:	53                   	push   %ebx
  801e5a:	83 ec 1c             	sub    $0x1c,%esp
  801e5d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801e60:	89 3c 24             	mov    %edi,(%esp)
  801e63:	e8 a8 f0 ff ff       	call   800f10 <fd2data>
  801e68:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e6a:	be 00 00 00 00       	mov    $0x0,%esi
  801e6f:	eb 3d                	jmp    801eae <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801e71:	85 f6                	test   %esi,%esi
  801e73:	74 04                	je     801e79 <devpipe_read+0x25>
				return i;
  801e75:	89 f0                	mov    %esi,%eax
  801e77:	eb 43                	jmp    801ebc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801e79:	89 da                	mov    %ebx,%edx
  801e7b:	89 f8                	mov    %edi,%eax
  801e7d:	e8 f1 fe ff ff       	call   801d73 <_pipeisclosed>
  801e82:	85 c0                	test   %eax,%eax
  801e84:	75 31                	jne    801eb7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801e86:	e8 09 ed ff ff       	call   800b94 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801e8b:	8b 03                	mov    (%ebx),%eax
  801e8d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e90:	74 df                	je     801e71 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e92:	99                   	cltd   
  801e93:	c1 ea 1b             	shr    $0x1b,%edx
  801e96:	01 d0                	add    %edx,%eax
  801e98:	83 e0 1f             	and    $0x1f,%eax
  801e9b:	29 d0                	sub    %edx,%eax
  801e9d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ea2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ea5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ea8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801eab:	83 c6 01             	add    $0x1,%esi
  801eae:	3b 75 10             	cmp    0x10(%ebp),%esi
  801eb1:	75 d8                	jne    801e8b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801eb3:	89 f0                	mov    %esi,%eax
  801eb5:	eb 05                	jmp    801ebc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801ebc:	83 c4 1c             	add    $0x1c,%esp
  801ebf:	5b                   	pop    %ebx
  801ec0:	5e                   	pop    %esi
  801ec1:	5f                   	pop    %edi
  801ec2:	5d                   	pop    %ebp
  801ec3:	c3                   	ret    

00801ec4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	56                   	push   %esi
  801ec8:	53                   	push   %ebx
  801ec9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801ecc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ecf:	89 04 24             	mov    %eax,(%esp)
  801ed2:	e8 50 f0 ff ff       	call   800f27 <fd_alloc>
  801ed7:	89 c2                	mov    %eax,%edx
  801ed9:	85 d2                	test   %edx,%edx
  801edb:	0f 88 4d 01 00 00    	js     80202e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ee8:	00 
  801ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ef7:	e8 b7 ec ff ff       	call   800bb3 <sys_page_alloc>
  801efc:	89 c2                	mov    %eax,%edx
  801efe:	85 d2                	test   %edx,%edx
  801f00:	0f 88 28 01 00 00    	js     80202e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f06:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f09:	89 04 24             	mov    %eax,(%esp)
  801f0c:	e8 16 f0 ff ff       	call   800f27 <fd_alloc>
  801f11:	89 c3                	mov    %eax,%ebx
  801f13:	85 c0                	test   %eax,%eax
  801f15:	0f 88 fe 00 00 00    	js     802019 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f1b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f22:	00 
  801f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f26:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f31:	e8 7d ec ff ff       	call   800bb3 <sys_page_alloc>
  801f36:	89 c3                	mov    %eax,%ebx
  801f38:	85 c0                	test   %eax,%eax
  801f3a:	0f 88 d9 00 00 00    	js     802019 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f43:	89 04 24             	mov    %eax,(%esp)
  801f46:	e8 c5 ef ff ff       	call   800f10 <fd2data>
  801f4b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f4d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f54:	00 
  801f55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f60:	e8 4e ec ff ff       	call   800bb3 <sys_page_alloc>
  801f65:	89 c3                	mov    %eax,%ebx
  801f67:	85 c0                	test   %eax,%eax
  801f69:	0f 88 97 00 00 00    	js     802006 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f72:	89 04 24             	mov    %eax,(%esp)
  801f75:	e8 96 ef ff ff       	call   800f10 <fd2data>
  801f7a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801f81:	00 
  801f82:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f8d:	00 
  801f8e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f99:	e8 69 ec ff ff       	call   800c07 <sys_page_map>
  801f9e:	89 c3                	mov    %eax,%ebx
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	78 52                	js     801ff6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801fa4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801fb9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd1:	89 04 24             	mov    %eax,(%esp)
  801fd4:	e8 27 ef ff ff       	call   800f00 <fd2num>
  801fd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fdc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe1:	89 04 24             	mov    %eax,(%esp)
  801fe4:	e8 17 ef ff ff       	call   800f00 <fd2num>
  801fe9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fec:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff4:	eb 38                	jmp    80202e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801ff6:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ffa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802001:	e8 54 ec ff ff       	call   800c5a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802006:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802009:	89 44 24 04          	mov    %eax,0x4(%esp)
  80200d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802014:	e8 41 ec ff ff       	call   800c5a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802020:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802027:	e8 2e ec ff ff       	call   800c5a <sys_page_unmap>
  80202c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80202e:	83 c4 30             	add    $0x30,%esp
  802031:	5b                   	pop    %ebx
  802032:	5e                   	pop    %esi
  802033:	5d                   	pop    %ebp
  802034:	c3                   	ret    

00802035 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80203b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80203e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	89 04 24             	mov    %eax,(%esp)
  802048:	e8 29 ef ff ff       	call   800f76 <fd_lookup>
  80204d:	89 c2                	mov    %eax,%edx
  80204f:	85 d2                	test   %edx,%edx
  802051:	78 15                	js     802068 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802056:	89 04 24             	mov    %eax,(%esp)
  802059:	e8 b2 ee ff ff       	call   800f10 <fd2data>
	return _pipeisclosed(fd, p);
  80205e:	89 c2                	mov    %eax,%edx
  802060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802063:	e8 0b fd ff ff       	call   801d73 <_pipeisclosed>
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    
  80206a:	66 90                	xchg   %ax,%ax
  80206c:	66 90                	xchg   %ax,%ax
  80206e:	66 90                	xchg   %ax,%ax

00802070 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802073:	b8 00 00 00 00       	mov    $0x0,%eax
  802078:	5d                   	pop    %ebp
  802079:	c3                   	ret    

0080207a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802080:	c7 44 24 04 0f 2b 80 	movl   $0x802b0f,0x4(%esp)
  802087:	00 
  802088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208b:	89 04 24             	mov    %eax,(%esp)
  80208e:	e8 04 e7 ff ff       	call   800797 <strcpy>
	return 0;
}
  802093:	b8 00 00 00 00       	mov    $0x0,%eax
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	57                   	push   %edi
  80209e:	56                   	push   %esi
  80209f:	53                   	push   %ebx
  8020a0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8020ab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020b1:	eb 31                	jmp    8020e4 <devcons_write+0x4a>
		m = n - tot;
  8020b3:	8b 75 10             	mov    0x10(%ebp),%esi
  8020b6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8020b8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8020bb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8020c0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8020c3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8020c7:	03 45 0c             	add    0xc(%ebp),%eax
  8020ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ce:	89 3c 24             	mov    %edi,(%esp)
  8020d1:	e8 5e e8 ff ff       	call   800934 <memmove>
		sys_cputs(buf, m);
  8020d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020da:	89 3c 24             	mov    %edi,(%esp)
  8020dd:	e8 04 ea ff ff       	call   800ae6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020e2:	01 f3                	add    %esi,%ebx
  8020e4:	89 d8                	mov    %ebx,%eax
  8020e6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8020e9:	72 c8                	jb     8020b3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8020eb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8020f1:	5b                   	pop    %ebx
  8020f2:	5e                   	pop    %esi
  8020f3:	5f                   	pop    %edi
  8020f4:	5d                   	pop    %ebp
  8020f5:	c3                   	ret    

008020f6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802101:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802105:	75 07                	jne    80210e <devcons_read+0x18>
  802107:	eb 2a                	jmp    802133 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802109:	e8 86 ea ff ff       	call   800b94 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80210e:	66 90                	xchg   %ax,%ax
  802110:	e8 ef e9 ff ff       	call   800b04 <sys_cgetc>
  802115:	85 c0                	test   %eax,%eax
  802117:	74 f0                	je     802109 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802119:	85 c0                	test   %eax,%eax
  80211b:	78 16                	js     802133 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80211d:	83 f8 04             	cmp    $0x4,%eax
  802120:	74 0c                	je     80212e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802122:	8b 55 0c             	mov    0xc(%ebp),%edx
  802125:	88 02                	mov    %al,(%edx)
	return 1;
  802127:	b8 01 00 00 00       	mov    $0x1,%eax
  80212c:	eb 05                	jmp    802133 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80212e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802133:	c9                   	leave  
  802134:	c3                   	ret    

00802135 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802141:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802148:	00 
  802149:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80214c:	89 04 24             	mov    %eax,(%esp)
  80214f:	e8 92 e9 ff ff       	call   800ae6 <sys_cputs>
}
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <getchar>:

int
getchar(void)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80215c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802163:	00 
  802164:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802167:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802172:	e8 93 f0 ff ff       	call   80120a <read>
	if (r < 0)
  802177:	85 c0                	test   %eax,%eax
  802179:	78 0f                	js     80218a <getchar+0x34>
		return r;
	if (r < 1)
  80217b:	85 c0                	test   %eax,%eax
  80217d:	7e 06                	jle    802185 <getchar+0x2f>
		return -E_EOF;
	return c;
  80217f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802183:	eb 05                	jmp    80218a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802185:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802192:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802195:	89 44 24 04          	mov    %eax,0x4(%esp)
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	89 04 24             	mov    %eax,(%esp)
  80219f:	e8 d2 ed ff ff       	call   800f76 <fd_lookup>
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	78 11                	js     8021b9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8021a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ab:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021b1:	39 10                	cmp    %edx,(%eax)
  8021b3:	0f 94 c0             	sete   %al
  8021b6:	0f b6 c0             	movzbl %al,%eax
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <opencons>:

int
opencons(void)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8021c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c4:	89 04 24             	mov    %eax,(%esp)
  8021c7:	e8 5b ed ff ff       	call   800f27 <fd_alloc>
		return r;
  8021cc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8021ce:	85 c0                	test   %eax,%eax
  8021d0:	78 40                	js     802212 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021d9:	00 
  8021da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021e8:	e8 c6 e9 ff ff       	call   800bb3 <sys_page_alloc>
		return r;
  8021ed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021ef:	85 c0                	test   %eax,%eax
  8021f1:	78 1f                	js     802212 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8021f3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802201:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802208:	89 04 24             	mov    %eax,(%esp)
  80220b:	e8 f0 ec ff ff       	call   800f00 <fd2num>
  802210:	89 c2                	mov    %eax,%edx
}
  802212:	89 d0                	mov    %edx,%eax
  802214:	c9                   	leave  
  802215:	c3                   	ret    

00802216 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	56                   	push   %esi
  80221a:	53                   	push   %ebx
  80221b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80221e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802221:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802227:	e8 49 e9 ff ff       	call   800b75 <sys_getenvid>
  80222c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80222f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802233:	8b 55 08             	mov    0x8(%ebp),%edx
  802236:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80223a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80223e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802242:	c7 04 24 1c 2b 80 00 	movl   $0x802b1c,(%esp)
  802249:	e8 1b df ff ff       	call   800169 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80224e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802252:	8b 45 10             	mov    0x10(%ebp),%eax
  802255:	89 04 24             	mov    %eax,(%esp)
  802258:	e8 ab de ff ff       	call   800108 <vcprintf>
	cprintf("\n");
  80225d:	c7 04 24 08 2b 80 00 	movl   $0x802b08,(%esp)
  802264:	e8 00 df ff ff       	call   800169 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802269:	cc                   	int3   
  80226a:	eb fd                	jmp    802269 <_panic+0x53>
  80226c:	66 90                	xchg   %ax,%ax
  80226e:	66 90                	xchg   %ax,%ax

00802270 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
  802273:	56                   	push   %esi
  802274:	53                   	push   %ebx
  802275:	83 ec 10             	sub    $0x10,%esp
  802278:	8b 75 08             	mov    0x8(%ebp),%esi
  80227b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80227e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802281:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802283:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802288:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80228b:	89 04 24             	mov    %eax,(%esp)
  80228e:	e8 36 eb ff ff       	call   800dc9 <sys_ipc_recv>
  802293:	85 c0                	test   %eax,%eax
  802295:	74 16                	je     8022ad <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802297:	85 f6                	test   %esi,%esi
  802299:	74 06                	je     8022a1 <ipc_recv+0x31>
			*from_env_store = 0;
  80229b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8022a1:	85 db                	test   %ebx,%ebx
  8022a3:	74 2c                	je     8022d1 <ipc_recv+0x61>
			*perm_store = 0;
  8022a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022ab:	eb 24                	jmp    8022d1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8022ad:	85 f6                	test   %esi,%esi
  8022af:	74 0a                	je     8022bb <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8022b1:	a1 08 40 80 00       	mov    0x804008,%eax
  8022b6:	8b 40 74             	mov    0x74(%eax),%eax
  8022b9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8022bb:	85 db                	test   %ebx,%ebx
  8022bd:	74 0a                	je     8022c9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8022bf:	a1 08 40 80 00       	mov    0x804008,%eax
  8022c4:	8b 40 78             	mov    0x78(%eax),%eax
  8022c7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8022c9:	a1 08 40 80 00       	mov    0x804008,%eax
  8022ce:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022d1:	83 c4 10             	add    $0x10,%esp
  8022d4:	5b                   	pop    %ebx
  8022d5:	5e                   	pop    %esi
  8022d6:	5d                   	pop    %ebp
  8022d7:	c3                   	ret    

008022d8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
  8022db:	57                   	push   %edi
  8022dc:	56                   	push   %esi
  8022dd:	53                   	push   %ebx
  8022de:	83 ec 1c             	sub    $0x1c,%esp
  8022e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022e7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8022ea:	85 db                	test   %ebx,%ebx
  8022ec:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8022f1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8022f4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	89 04 24             	mov    %eax,(%esp)
  802306:	e8 9b ea ff ff       	call   800da6 <sys_ipc_try_send>
	if (r == 0) return;
  80230b:	85 c0                	test   %eax,%eax
  80230d:	75 22                	jne    802331 <ipc_send+0x59>
  80230f:	eb 4c                	jmp    80235d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802311:	84 d2                	test   %dl,%dl
  802313:	75 48                	jne    80235d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802315:	e8 7a e8 ff ff       	call   800b94 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80231a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80231e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802322:	89 74 24 04          	mov    %esi,0x4(%esp)
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	89 04 24             	mov    %eax,(%esp)
  80232c:	e8 75 ea ff ff       	call   800da6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802331:	85 c0                	test   %eax,%eax
  802333:	0f 94 c2             	sete   %dl
  802336:	74 d9                	je     802311 <ipc_send+0x39>
  802338:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80233b:	74 d4                	je     802311 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80233d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802341:	c7 44 24 08 40 2b 80 	movl   $0x802b40,0x8(%esp)
  802348:	00 
  802349:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802350:	00 
  802351:	c7 04 24 4e 2b 80 00 	movl   $0x802b4e,(%esp)
  802358:	e8 b9 fe ff ff       	call   802216 <_panic>
}
  80235d:	83 c4 1c             	add    $0x1c,%esp
  802360:	5b                   	pop    %ebx
  802361:	5e                   	pop    %esi
  802362:	5f                   	pop    %edi
  802363:	5d                   	pop    %ebp
  802364:	c3                   	ret    

00802365 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80236b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802370:	89 c2                	mov    %eax,%edx
  802372:	c1 e2 07             	shl    $0x7,%edx
  802375:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80237b:	8b 52 50             	mov    0x50(%edx),%edx
  80237e:	39 ca                	cmp    %ecx,%edx
  802380:	75 0d                	jne    80238f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802382:	c1 e0 07             	shl    $0x7,%eax
  802385:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80238a:	8b 40 40             	mov    0x40(%eax),%eax
  80238d:	eb 0e                	jmp    80239d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80238f:	83 c0 01             	add    $0x1,%eax
  802392:	3d 00 04 00 00       	cmp    $0x400,%eax
  802397:	75 d7                	jne    802370 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802399:	66 b8 00 00          	mov    $0x0,%ax
}
  80239d:	5d                   	pop    %ebp
  80239e:	c3                   	ret    

0080239f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
  8023a2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023a5:	89 d0                	mov    %edx,%eax
  8023a7:	c1 e8 16             	shr    $0x16,%eax
  8023aa:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023b1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023b6:	f6 c1 01             	test   $0x1,%cl
  8023b9:	74 1d                	je     8023d8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023bb:	c1 ea 0c             	shr    $0xc,%edx
  8023be:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023c5:	f6 c2 01             	test   $0x1,%dl
  8023c8:	74 0e                	je     8023d8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023ca:	c1 ea 0c             	shr    $0xc,%edx
  8023cd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023d4:	ef 
  8023d5:	0f b7 c0             	movzwl %ax,%eax
}
  8023d8:	5d                   	pop    %ebp
  8023d9:	c3                   	ret    
  8023da:	66 90                	xchg   %ax,%ax
  8023dc:	66 90                	xchg   %ax,%ax
  8023de:	66 90                	xchg   %ax,%ax

008023e0 <__udivdi3>:
  8023e0:	55                   	push   %ebp
  8023e1:	57                   	push   %edi
  8023e2:	56                   	push   %esi
  8023e3:	83 ec 0c             	sub    $0xc,%esp
  8023e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8023ea:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8023ee:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8023f2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8023f6:	85 c0                	test   %eax,%eax
  8023f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8023fc:	89 ea                	mov    %ebp,%edx
  8023fe:	89 0c 24             	mov    %ecx,(%esp)
  802401:	75 2d                	jne    802430 <__udivdi3+0x50>
  802403:	39 e9                	cmp    %ebp,%ecx
  802405:	77 61                	ja     802468 <__udivdi3+0x88>
  802407:	85 c9                	test   %ecx,%ecx
  802409:	89 ce                	mov    %ecx,%esi
  80240b:	75 0b                	jne    802418 <__udivdi3+0x38>
  80240d:	b8 01 00 00 00       	mov    $0x1,%eax
  802412:	31 d2                	xor    %edx,%edx
  802414:	f7 f1                	div    %ecx
  802416:	89 c6                	mov    %eax,%esi
  802418:	31 d2                	xor    %edx,%edx
  80241a:	89 e8                	mov    %ebp,%eax
  80241c:	f7 f6                	div    %esi
  80241e:	89 c5                	mov    %eax,%ebp
  802420:	89 f8                	mov    %edi,%eax
  802422:	f7 f6                	div    %esi
  802424:	89 ea                	mov    %ebp,%edx
  802426:	83 c4 0c             	add    $0xc,%esp
  802429:	5e                   	pop    %esi
  80242a:	5f                   	pop    %edi
  80242b:	5d                   	pop    %ebp
  80242c:	c3                   	ret    
  80242d:	8d 76 00             	lea    0x0(%esi),%esi
  802430:	39 e8                	cmp    %ebp,%eax
  802432:	77 24                	ja     802458 <__udivdi3+0x78>
  802434:	0f bd e8             	bsr    %eax,%ebp
  802437:	83 f5 1f             	xor    $0x1f,%ebp
  80243a:	75 3c                	jne    802478 <__udivdi3+0x98>
  80243c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802440:	39 34 24             	cmp    %esi,(%esp)
  802443:	0f 86 9f 00 00 00    	jbe    8024e8 <__udivdi3+0x108>
  802449:	39 d0                	cmp    %edx,%eax
  80244b:	0f 82 97 00 00 00    	jb     8024e8 <__udivdi3+0x108>
  802451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802458:	31 d2                	xor    %edx,%edx
  80245a:	31 c0                	xor    %eax,%eax
  80245c:	83 c4 0c             	add    $0xc,%esp
  80245f:	5e                   	pop    %esi
  802460:	5f                   	pop    %edi
  802461:	5d                   	pop    %ebp
  802462:	c3                   	ret    
  802463:	90                   	nop
  802464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802468:	89 f8                	mov    %edi,%eax
  80246a:	f7 f1                	div    %ecx
  80246c:	31 d2                	xor    %edx,%edx
  80246e:	83 c4 0c             	add    $0xc,%esp
  802471:	5e                   	pop    %esi
  802472:	5f                   	pop    %edi
  802473:	5d                   	pop    %ebp
  802474:	c3                   	ret    
  802475:	8d 76 00             	lea    0x0(%esi),%esi
  802478:	89 e9                	mov    %ebp,%ecx
  80247a:	8b 3c 24             	mov    (%esp),%edi
  80247d:	d3 e0                	shl    %cl,%eax
  80247f:	89 c6                	mov    %eax,%esi
  802481:	b8 20 00 00 00       	mov    $0x20,%eax
  802486:	29 e8                	sub    %ebp,%eax
  802488:	89 c1                	mov    %eax,%ecx
  80248a:	d3 ef                	shr    %cl,%edi
  80248c:	89 e9                	mov    %ebp,%ecx
  80248e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802492:	8b 3c 24             	mov    (%esp),%edi
  802495:	09 74 24 08          	or     %esi,0x8(%esp)
  802499:	89 d6                	mov    %edx,%esi
  80249b:	d3 e7                	shl    %cl,%edi
  80249d:	89 c1                	mov    %eax,%ecx
  80249f:	89 3c 24             	mov    %edi,(%esp)
  8024a2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024a6:	d3 ee                	shr    %cl,%esi
  8024a8:	89 e9                	mov    %ebp,%ecx
  8024aa:	d3 e2                	shl    %cl,%edx
  8024ac:	89 c1                	mov    %eax,%ecx
  8024ae:	d3 ef                	shr    %cl,%edi
  8024b0:	09 d7                	or     %edx,%edi
  8024b2:	89 f2                	mov    %esi,%edx
  8024b4:	89 f8                	mov    %edi,%eax
  8024b6:	f7 74 24 08          	divl   0x8(%esp)
  8024ba:	89 d6                	mov    %edx,%esi
  8024bc:	89 c7                	mov    %eax,%edi
  8024be:	f7 24 24             	mull   (%esp)
  8024c1:	39 d6                	cmp    %edx,%esi
  8024c3:	89 14 24             	mov    %edx,(%esp)
  8024c6:	72 30                	jb     8024f8 <__udivdi3+0x118>
  8024c8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024cc:	89 e9                	mov    %ebp,%ecx
  8024ce:	d3 e2                	shl    %cl,%edx
  8024d0:	39 c2                	cmp    %eax,%edx
  8024d2:	73 05                	jae    8024d9 <__udivdi3+0xf9>
  8024d4:	3b 34 24             	cmp    (%esp),%esi
  8024d7:	74 1f                	je     8024f8 <__udivdi3+0x118>
  8024d9:	89 f8                	mov    %edi,%eax
  8024db:	31 d2                	xor    %edx,%edx
  8024dd:	e9 7a ff ff ff       	jmp    80245c <__udivdi3+0x7c>
  8024e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024e8:	31 d2                	xor    %edx,%edx
  8024ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ef:	e9 68 ff ff ff       	jmp    80245c <__udivdi3+0x7c>
  8024f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024f8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8024fb:	31 d2                	xor    %edx,%edx
  8024fd:	83 c4 0c             	add    $0xc,%esp
  802500:	5e                   	pop    %esi
  802501:	5f                   	pop    %edi
  802502:	5d                   	pop    %ebp
  802503:	c3                   	ret    
  802504:	66 90                	xchg   %ax,%ax
  802506:	66 90                	xchg   %ax,%ax
  802508:	66 90                	xchg   %ax,%ax
  80250a:	66 90                	xchg   %ax,%ax
  80250c:	66 90                	xchg   %ax,%ax
  80250e:	66 90                	xchg   %ax,%ax

00802510 <__umoddi3>:
  802510:	55                   	push   %ebp
  802511:	57                   	push   %edi
  802512:	56                   	push   %esi
  802513:	83 ec 14             	sub    $0x14,%esp
  802516:	8b 44 24 28          	mov    0x28(%esp),%eax
  80251a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80251e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802522:	89 c7                	mov    %eax,%edi
  802524:	89 44 24 04          	mov    %eax,0x4(%esp)
  802528:	8b 44 24 30          	mov    0x30(%esp),%eax
  80252c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802530:	89 34 24             	mov    %esi,(%esp)
  802533:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802537:	85 c0                	test   %eax,%eax
  802539:	89 c2                	mov    %eax,%edx
  80253b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80253f:	75 17                	jne    802558 <__umoddi3+0x48>
  802541:	39 fe                	cmp    %edi,%esi
  802543:	76 4b                	jbe    802590 <__umoddi3+0x80>
  802545:	89 c8                	mov    %ecx,%eax
  802547:	89 fa                	mov    %edi,%edx
  802549:	f7 f6                	div    %esi
  80254b:	89 d0                	mov    %edx,%eax
  80254d:	31 d2                	xor    %edx,%edx
  80254f:	83 c4 14             	add    $0x14,%esp
  802552:	5e                   	pop    %esi
  802553:	5f                   	pop    %edi
  802554:	5d                   	pop    %ebp
  802555:	c3                   	ret    
  802556:	66 90                	xchg   %ax,%ax
  802558:	39 f8                	cmp    %edi,%eax
  80255a:	77 54                	ja     8025b0 <__umoddi3+0xa0>
  80255c:	0f bd e8             	bsr    %eax,%ebp
  80255f:	83 f5 1f             	xor    $0x1f,%ebp
  802562:	75 5c                	jne    8025c0 <__umoddi3+0xb0>
  802564:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802568:	39 3c 24             	cmp    %edi,(%esp)
  80256b:	0f 87 e7 00 00 00    	ja     802658 <__umoddi3+0x148>
  802571:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802575:	29 f1                	sub    %esi,%ecx
  802577:	19 c7                	sbb    %eax,%edi
  802579:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80257d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802581:	8b 44 24 08          	mov    0x8(%esp),%eax
  802585:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802589:	83 c4 14             	add    $0x14,%esp
  80258c:	5e                   	pop    %esi
  80258d:	5f                   	pop    %edi
  80258e:	5d                   	pop    %ebp
  80258f:	c3                   	ret    
  802590:	85 f6                	test   %esi,%esi
  802592:	89 f5                	mov    %esi,%ebp
  802594:	75 0b                	jne    8025a1 <__umoddi3+0x91>
  802596:	b8 01 00 00 00       	mov    $0x1,%eax
  80259b:	31 d2                	xor    %edx,%edx
  80259d:	f7 f6                	div    %esi
  80259f:	89 c5                	mov    %eax,%ebp
  8025a1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025a5:	31 d2                	xor    %edx,%edx
  8025a7:	f7 f5                	div    %ebp
  8025a9:	89 c8                	mov    %ecx,%eax
  8025ab:	f7 f5                	div    %ebp
  8025ad:	eb 9c                	jmp    80254b <__umoddi3+0x3b>
  8025af:	90                   	nop
  8025b0:	89 c8                	mov    %ecx,%eax
  8025b2:	89 fa                	mov    %edi,%edx
  8025b4:	83 c4 14             	add    $0x14,%esp
  8025b7:	5e                   	pop    %esi
  8025b8:	5f                   	pop    %edi
  8025b9:	5d                   	pop    %ebp
  8025ba:	c3                   	ret    
  8025bb:	90                   	nop
  8025bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025c0:	8b 04 24             	mov    (%esp),%eax
  8025c3:	be 20 00 00 00       	mov    $0x20,%esi
  8025c8:	89 e9                	mov    %ebp,%ecx
  8025ca:	29 ee                	sub    %ebp,%esi
  8025cc:	d3 e2                	shl    %cl,%edx
  8025ce:	89 f1                	mov    %esi,%ecx
  8025d0:	d3 e8                	shr    %cl,%eax
  8025d2:	89 e9                	mov    %ebp,%ecx
  8025d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d8:	8b 04 24             	mov    (%esp),%eax
  8025db:	09 54 24 04          	or     %edx,0x4(%esp)
  8025df:	89 fa                	mov    %edi,%edx
  8025e1:	d3 e0                	shl    %cl,%eax
  8025e3:	89 f1                	mov    %esi,%ecx
  8025e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025e9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8025ed:	d3 ea                	shr    %cl,%edx
  8025ef:	89 e9                	mov    %ebp,%ecx
  8025f1:	d3 e7                	shl    %cl,%edi
  8025f3:	89 f1                	mov    %esi,%ecx
  8025f5:	d3 e8                	shr    %cl,%eax
  8025f7:	89 e9                	mov    %ebp,%ecx
  8025f9:	09 f8                	or     %edi,%eax
  8025fb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8025ff:	f7 74 24 04          	divl   0x4(%esp)
  802603:	d3 e7                	shl    %cl,%edi
  802605:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802609:	89 d7                	mov    %edx,%edi
  80260b:	f7 64 24 08          	mull   0x8(%esp)
  80260f:	39 d7                	cmp    %edx,%edi
  802611:	89 c1                	mov    %eax,%ecx
  802613:	89 14 24             	mov    %edx,(%esp)
  802616:	72 2c                	jb     802644 <__umoddi3+0x134>
  802618:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80261c:	72 22                	jb     802640 <__umoddi3+0x130>
  80261e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802622:	29 c8                	sub    %ecx,%eax
  802624:	19 d7                	sbb    %edx,%edi
  802626:	89 e9                	mov    %ebp,%ecx
  802628:	89 fa                	mov    %edi,%edx
  80262a:	d3 e8                	shr    %cl,%eax
  80262c:	89 f1                	mov    %esi,%ecx
  80262e:	d3 e2                	shl    %cl,%edx
  802630:	89 e9                	mov    %ebp,%ecx
  802632:	d3 ef                	shr    %cl,%edi
  802634:	09 d0                	or     %edx,%eax
  802636:	89 fa                	mov    %edi,%edx
  802638:	83 c4 14             	add    $0x14,%esp
  80263b:	5e                   	pop    %esi
  80263c:	5f                   	pop    %edi
  80263d:	5d                   	pop    %ebp
  80263e:	c3                   	ret    
  80263f:	90                   	nop
  802640:	39 d7                	cmp    %edx,%edi
  802642:	75 da                	jne    80261e <__umoddi3+0x10e>
  802644:	8b 14 24             	mov    (%esp),%edx
  802647:	89 c1                	mov    %eax,%ecx
  802649:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80264d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802651:	eb cb                	jmp    80261e <__umoddi3+0x10e>
  802653:	90                   	nop
  802654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802658:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80265c:	0f 82 0f ff ff ff    	jb     802571 <__umoddi3+0x61>
  802662:	e9 1a ff ff ff       	jmp    802581 <__umoddi3+0x71>
