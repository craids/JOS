
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 6d 00 00 00       	call   80009e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 08 40 80 00       	mov    0x804008,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	89 44 24 04          	mov    %eax,0x4(%esp)
  800046:	c7 04 24 a0 26 80 00 	movl   $0x8026a0,(%esp)
  80004d:	e8 50 01 00 00       	call   8001a2 <cprintf>
	for (i = 0; i < 5; i++) {
  800052:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800057:	e8 68 0b 00 00       	call   800bc4 <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005c:	a1 08 40 80 00       	mov    0x804008,%eax
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
  800061:	8b 40 48             	mov    0x48(%eax),%eax
  800064:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800068:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006c:	c7 04 24 c0 26 80 00 	movl   $0x8026c0,(%esp)
  800073:	e8 2a 01 00 00       	call   8001a2 <cprintf>
umain(int argc, char **argv)
{
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
  800078:	83 c3 01             	add    $0x1,%ebx
  80007b:	83 fb 05             	cmp    $0x5,%ebx
  80007e:	75 d7                	jne    800057 <umain+0x24>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  800080:	a1 08 40 80 00       	mov    0x804008,%eax
  800085:	8b 40 48             	mov    0x48(%eax),%eax
  800088:	89 44 24 04          	mov    %eax,0x4(%esp)
  80008c:	c7 04 24 ec 26 80 00 	movl   $0x8026ec,(%esp)
  800093:	e8 0a 01 00 00       	call   8001a2 <cprintf>
}
  800098:	83 c4 14             	add    $0x14,%esp
  80009b:	5b                   	pop    %ebx
  80009c:	5d                   	pop    %ebp
  80009d:	c3                   	ret    

0080009e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	56                   	push   %esi
  8000a2:	53                   	push   %ebx
  8000a3:	83 ec 10             	sub    $0x10,%esp
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ac:	e8 f4 0a 00 00       	call   800ba5 <sys_getenvid>
  8000b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000b6:	c1 e0 07             	shl    $0x7,%eax
  8000b9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000be:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c3:	85 db                	test   %ebx,%ebx
  8000c5:	7e 07                	jle    8000ce <libmain+0x30>
		binaryname = argv[0];
  8000c7:	8b 06                	mov    (%esi),%eax
  8000c9:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000d2:	89 1c 24             	mov    %ebx,(%esp)
  8000d5:	e8 59 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000da:	e8 07 00 00 00       	call   8000e6 <exit>
}
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	5b                   	pop    %ebx
  8000e3:	5e                   	pop    %esi
  8000e4:	5d                   	pop    %ebp
  8000e5:	c3                   	ret    

008000e6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000ec:	e8 19 10 00 00       	call   80110a <close_all>
	sys_env_destroy(0);
  8000f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000f8:	e8 56 0a 00 00       	call   800b53 <sys_env_destroy>
}
  8000fd:	c9                   	leave  
  8000fe:	c3                   	ret    

008000ff <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000ff:	55                   	push   %ebp
  800100:	89 e5                	mov    %esp,%ebp
  800102:	53                   	push   %ebx
  800103:	83 ec 14             	sub    $0x14,%esp
  800106:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800109:	8b 13                	mov    (%ebx),%edx
  80010b:	8d 42 01             	lea    0x1(%edx),%eax
  80010e:	89 03                	mov    %eax,(%ebx)
  800110:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800113:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800117:	3d ff 00 00 00       	cmp    $0xff,%eax
  80011c:	75 19                	jne    800137 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80011e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800125:	00 
  800126:	8d 43 08             	lea    0x8(%ebx),%eax
  800129:	89 04 24             	mov    %eax,(%esp)
  80012c:	e8 e5 09 00 00       	call   800b16 <sys_cputs>
		b->idx = 0;
  800131:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800137:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80013b:	83 c4 14             	add    $0x14,%esp
  80013e:	5b                   	pop    %ebx
  80013f:	5d                   	pop    %ebp
  800140:	c3                   	ret    

00800141 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
  800144:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80014a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800151:	00 00 00 
	b.cnt = 0;
  800154:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80015b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800161:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800165:	8b 45 08             	mov    0x8(%ebp),%eax
  800168:	89 44 24 08          	mov    %eax,0x8(%esp)
  80016c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800172:	89 44 24 04          	mov    %eax,0x4(%esp)
  800176:	c7 04 24 ff 00 80 00 	movl   $0x8000ff,(%esp)
  80017d:	e8 ac 01 00 00       	call   80032e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800182:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800188:	89 44 24 04          	mov    %eax,0x4(%esp)
  80018c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800192:	89 04 24             	mov    %eax,(%esp)
  800195:	e8 7c 09 00 00       	call   800b16 <sys_cputs>

	return b.cnt;
}
  80019a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001a0:	c9                   	leave  
  8001a1:	c3                   	ret    

008001a2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a2:	55                   	push   %ebp
  8001a3:	89 e5                	mov    %esp,%ebp
  8001a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001af:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b2:	89 04 24             	mov    %eax,(%esp)
  8001b5:	e8 87 ff ff ff       	call   800141 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ba:	c9                   	leave  
  8001bb:	c3                   	ret    
  8001bc:	66 90                	xchg   %ax,%ax
  8001be:	66 90                	xchg   %ax,%ax

008001c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	57                   	push   %edi
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
  8001c6:	83 ec 3c             	sub    $0x3c,%esp
  8001c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001cc:	89 d7                	mov    %edx,%edi
  8001ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	89 c3                	mov    %eax,%ebx
  8001d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8001df:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ea:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001ed:	39 d9                	cmp    %ebx,%ecx
  8001ef:	72 05                	jb     8001f6 <printnum+0x36>
  8001f1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001f4:	77 69                	ja     80025f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8001f9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8001fd:	83 ee 01             	sub    $0x1,%esi
  800200:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800204:	89 44 24 08          	mov    %eax,0x8(%esp)
  800208:	8b 44 24 08          	mov    0x8(%esp),%eax
  80020c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800210:	89 c3                	mov    %eax,%ebx
  800212:	89 d6                	mov    %edx,%esi
  800214:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800217:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80021a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80021e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800225:	89 04 24             	mov    %eax,(%esp)
  800228:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80022b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022f:	e8 dc 21 00 00       	call   802410 <__udivdi3>
  800234:	89 d9                	mov    %ebx,%ecx
  800236:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80023a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80023e:	89 04 24             	mov    %eax,(%esp)
  800241:	89 54 24 04          	mov    %edx,0x4(%esp)
  800245:	89 fa                	mov    %edi,%edx
  800247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80024a:	e8 71 ff ff ff       	call   8001c0 <printnum>
  80024f:	eb 1b                	jmp    80026c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800251:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800255:	8b 45 18             	mov    0x18(%ebp),%eax
  800258:	89 04 24             	mov    %eax,(%esp)
  80025b:	ff d3                	call   *%ebx
  80025d:	eb 03                	jmp    800262 <printnum+0xa2>
  80025f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800262:	83 ee 01             	sub    $0x1,%esi
  800265:	85 f6                	test   %esi,%esi
  800267:	7f e8                	jg     800251 <printnum+0x91>
  800269:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80026c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800270:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800274:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800277:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80027a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80027e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800282:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800285:	89 04 24             	mov    %eax,(%esp)
  800288:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028f:	e8 ac 22 00 00       	call   802540 <__umoddi3>
  800294:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800298:	0f be 80 15 27 80 00 	movsbl 0x802715(%eax),%eax
  80029f:	89 04 24             	mov    %eax,(%esp)
  8002a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a5:	ff d0                	call   *%eax
}
  8002a7:	83 c4 3c             	add    $0x3c,%esp
  8002aa:	5b                   	pop    %ebx
  8002ab:	5e                   	pop    %esi
  8002ac:	5f                   	pop    %edi
  8002ad:	5d                   	pop    %ebp
  8002ae:	c3                   	ret    

008002af <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002b2:	83 fa 01             	cmp    $0x1,%edx
  8002b5:	7e 0e                	jle    8002c5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002b7:	8b 10                	mov    (%eax),%edx
  8002b9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002bc:	89 08                	mov    %ecx,(%eax)
  8002be:	8b 02                	mov    (%edx),%eax
  8002c0:	8b 52 04             	mov    0x4(%edx),%edx
  8002c3:	eb 22                	jmp    8002e7 <getuint+0x38>
	else if (lflag)
  8002c5:	85 d2                	test   %edx,%edx
  8002c7:	74 10                	je     8002d9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002c9:	8b 10                	mov    (%eax),%edx
  8002cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ce:	89 08                	mov    %ecx,(%eax)
  8002d0:	8b 02                	mov    (%edx),%eax
  8002d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d7:	eb 0e                	jmp    8002e7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002d9:	8b 10                	mov    (%eax),%edx
  8002db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002de:	89 08                	mov    %ecx,(%eax)
  8002e0:	8b 02                	mov    (%edx),%eax
  8002e2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    

008002e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ef:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f3:	8b 10                	mov    (%eax),%edx
  8002f5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f8:	73 0a                	jae    800304 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fd:	89 08                	mov    %ecx,(%eax)
  8002ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800302:	88 02                	mov    %al,(%edx)
}
  800304:	5d                   	pop    %ebp
  800305:	c3                   	ret    

00800306 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80030c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800313:	8b 45 10             	mov    0x10(%ebp),%eax
  800316:	89 44 24 08          	mov    %eax,0x8(%esp)
  80031a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800321:	8b 45 08             	mov    0x8(%ebp),%eax
  800324:	89 04 24             	mov    %eax,(%esp)
  800327:	e8 02 00 00 00       	call   80032e <vprintfmt>
	va_end(ap);
}
  80032c:	c9                   	leave  
  80032d:	c3                   	ret    

0080032e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80032e:	55                   	push   %ebp
  80032f:	89 e5                	mov    %esp,%ebp
  800331:	57                   	push   %edi
  800332:	56                   	push   %esi
  800333:	53                   	push   %ebx
  800334:	83 ec 3c             	sub    $0x3c,%esp
  800337:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80033a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80033d:	eb 14                	jmp    800353 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80033f:	85 c0                	test   %eax,%eax
  800341:	0f 84 b3 03 00 00    	je     8006fa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800347:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80034b:	89 04 24             	mov    %eax,(%esp)
  80034e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800351:	89 f3                	mov    %esi,%ebx
  800353:	8d 73 01             	lea    0x1(%ebx),%esi
  800356:	0f b6 03             	movzbl (%ebx),%eax
  800359:	83 f8 25             	cmp    $0x25,%eax
  80035c:	75 e1                	jne    80033f <vprintfmt+0x11>
  80035e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800362:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800369:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800370:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800377:	ba 00 00 00 00       	mov    $0x0,%edx
  80037c:	eb 1d                	jmp    80039b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80037e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800380:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800384:	eb 15                	jmp    80039b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800386:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800388:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80038c:	eb 0d                	jmp    80039b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80038e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800391:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800394:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80039b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80039e:	0f b6 0e             	movzbl (%esi),%ecx
  8003a1:	0f b6 c1             	movzbl %cl,%eax
  8003a4:	83 e9 23             	sub    $0x23,%ecx
  8003a7:	80 f9 55             	cmp    $0x55,%cl
  8003aa:	0f 87 2a 03 00 00    	ja     8006da <vprintfmt+0x3ac>
  8003b0:	0f b6 c9             	movzbl %cl,%ecx
  8003b3:	ff 24 8d 60 28 80 00 	jmp    *0x802860(,%ecx,4)
  8003ba:	89 de                	mov    %ebx,%esi
  8003bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003c1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003c4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8003c8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8003cb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8003ce:	83 fb 09             	cmp    $0x9,%ebx
  8003d1:	77 36                	ja     800409 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003d3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003d6:	eb e9                	jmp    8003c1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003db:	8d 48 04             	lea    0x4(%eax),%ecx
  8003de:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003e1:	8b 00                	mov    (%eax),%eax
  8003e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003e8:	eb 22                	jmp    80040c <vprintfmt+0xde>
  8003ea:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003ed:	85 c9                	test   %ecx,%ecx
  8003ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f4:	0f 49 c1             	cmovns %ecx,%eax
  8003f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	89 de                	mov    %ebx,%esi
  8003fc:	eb 9d                	jmp    80039b <vprintfmt+0x6d>
  8003fe:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800400:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800407:	eb 92                	jmp    80039b <vprintfmt+0x6d>
  800409:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80040c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800410:	79 89                	jns    80039b <vprintfmt+0x6d>
  800412:	e9 77 ff ff ff       	jmp    80038e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800417:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80041c:	e9 7a ff ff ff       	jmp    80039b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800421:	8b 45 14             	mov    0x14(%ebp),%eax
  800424:	8d 50 04             	lea    0x4(%eax),%edx
  800427:	89 55 14             	mov    %edx,0x14(%ebp)
  80042a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 04 24             	mov    %eax,(%esp)
  800433:	ff 55 08             	call   *0x8(%ebp)
			break;
  800436:	e9 18 ff ff ff       	jmp    800353 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80043b:	8b 45 14             	mov    0x14(%ebp),%eax
  80043e:	8d 50 04             	lea    0x4(%eax),%edx
  800441:	89 55 14             	mov    %edx,0x14(%ebp)
  800444:	8b 00                	mov    (%eax),%eax
  800446:	99                   	cltd   
  800447:	31 d0                	xor    %edx,%eax
  800449:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80044b:	83 f8 11             	cmp    $0x11,%eax
  80044e:	7f 0b                	jg     80045b <vprintfmt+0x12d>
  800450:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  800457:	85 d2                	test   %edx,%edx
  800459:	75 20                	jne    80047b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80045b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80045f:	c7 44 24 08 2d 27 80 	movl   $0x80272d,0x8(%esp)
  800466:	00 
  800467:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	89 04 24             	mov    %eax,(%esp)
  800471:	e8 90 fe ff ff       	call   800306 <printfmt>
  800476:	e9 d8 fe ff ff       	jmp    800353 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80047b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80047f:	c7 44 24 08 fd 2a 80 	movl   $0x802afd,0x8(%esp)
  800486:	00 
  800487:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	89 04 24             	mov    %eax,(%esp)
  800491:	e8 70 fe ff ff       	call   800306 <printfmt>
  800496:	e9 b8 fe ff ff       	jmp    800353 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80049e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a7:	8d 50 04             	lea    0x4(%eax),%edx
  8004aa:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ad:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8004af:	85 f6                	test   %esi,%esi
  8004b1:	b8 26 27 80 00       	mov    $0x802726,%eax
  8004b6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8004b9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8004bd:	0f 84 97 00 00 00    	je     80055a <vprintfmt+0x22c>
  8004c3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004c7:	0f 8e 9b 00 00 00    	jle    800568 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004d1:	89 34 24             	mov    %esi,(%esp)
  8004d4:	e8 cf 02 00 00       	call   8007a8 <strnlen>
  8004d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004dc:	29 c2                	sub    %eax,%edx
  8004de:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8004e1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8004e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004e8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004f1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f3:	eb 0f                	jmp    800504 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8004f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004fc:	89 04 24             	mov    %eax,(%esp)
  8004ff:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800501:	83 eb 01             	sub    $0x1,%ebx
  800504:	85 db                	test   %ebx,%ebx
  800506:	7f ed                	jg     8004f5 <vprintfmt+0x1c7>
  800508:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80050b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050e:	85 d2                	test   %edx,%edx
  800510:	b8 00 00 00 00       	mov    $0x0,%eax
  800515:	0f 49 c2             	cmovns %edx,%eax
  800518:	29 c2                	sub    %eax,%edx
  80051a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80051d:	89 d7                	mov    %edx,%edi
  80051f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800522:	eb 50                	jmp    800574 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800524:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800528:	74 1e                	je     800548 <vprintfmt+0x21a>
  80052a:	0f be d2             	movsbl %dl,%edx
  80052d:	83 ea 20             	sub    $0x20,%edx
  800530:	83 fa 5e             	cmp    $0x5e,%edx
  800533:	76 13                	jbe    800548 <vprintfmt+0x21a>
					putch('?', putdat);
  800535:	8b 45 0c             	mov    0xc(%ebp),%eax
  800538:	89 44 24 04          	mov    %eax,0x4(%esp)
  80053c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800543:	ff 55 08             	call   *0x8(%ebp)
  800546:	eb 0d                	jmp    800555 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80054b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80054f:	89 04 24             	mov    %eax,(%esp)
  800552:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800555:	83 ef 01             	sub    $0x1,%edi
  800558:	eb 1a                	jmp    800574 <vprintfmt+0x246>
  80055a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80055d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800560:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800563:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800566:	eb 0c                	jmp    800574 <vprintfmt+0x246>
  800568:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80056b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80056e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800571:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800574:	83 c6 01             	add    $0x1,%esi
  800577:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80057b:	0f be c2             	movsbl %dl,%eax
  80057e:	85 c0                	test   %eax,%eax
  800580:	74 27                	je     8005a9 <vprintfmt+0x27b>
  800582:	85 db                	test   %ebx,%ebx
  800584:	78 9e                	js     800524 <vprintfmt+0x1f6>
  800586:	83 eb 01             	sub    $0x1,%ebx
  800589:	79 99                	jns    800524 <vprintfmt+0x1f6>
  80058b:	89 f8                	mov    %edi,%eax
  80058d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800590:	8b 75 08             	mov    0x8(%ebp),%esi
  800593:	89 c3                	mov    %eax,%ebx
  800595:	eb 1a                	jmp    8005b1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800597:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80059b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005a2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005a4:	83 eb 01             	sub    $0x1,%ebx
  8005a7:	eb 08                	jmp    8005b1 <vprintfmt+0x283>
  8005a9:	89 fb                	mov    %edi,%ebx
  8005ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ae:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005b1:	85 db                	test   %ebx,%ebx
  8005b3:	7f e2                	jg     800597 <vprintfmt+0x269>
  8005b5:	89 75 08             	mov    %esi,0x8(%ebp)
  8005b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005bb:	e9 93 fd ff ff       	jmp    800353 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005c0:	83 fa 01             	cmp    $0x1,%edx
  8005c3:	7e 16                	jle    8005db <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	8d 50 08             	lea    0x8(%eax),%edx
  8005cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ce:	8b 50 04             	mov    0x4(%eax),%edx
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005d9:	eb 32                	jmp    80060d <vprintfmt+0x2df>
	else if (lflag)
  8005db:	85 d2                	test   %edx,%edx
  8005dd:	74 18                	je     8005f7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 50 04             	lea    0x4(%eax),%edx
  8005e5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e8:	8b 30                	mov    (%eax),%esi
  8005ea:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005ed:	89 f0                	mov    %esi,%eax
  8005ef:	c1 f8 1f             	sar    $0x1f,%eax
  8005f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005f5:	eb 16                	jmp    80060d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 50 04             	lea    0x4(%eax),%edx
  8005fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800600:	8b 30                	mov    (%eax),%esi
  800602:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800605:	89 f0                	mov    %esi,%eax
  800607:	c1 f8 1f             	sar    $0x1f,%eax
  80060a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800610:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800613:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800618:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80061c:	0f 89 80 00 00 00    	jns    8006a2 <vprintfmt+0x374>
				putch('-', putdat);
  800622:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800626:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80062d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800630:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800633:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800636:	f7 d8                	neg    %eax
  800638:	83 d2 00             	adc    $0x0,%edx
  80063b:	f7 da                	neg    %edx
			}
			base = 10;
  80063d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800642:	eb 5e                	jmp    8006a2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800644:	8d 45 14             	lea    0x14(%ebp),%eax
  800647:	e8 63 fc ff ff       	call   8002af <getuint>
			base = 10;
  80064c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800651:	eb 4f                	jmp    8006a2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800653:	8d 45 14             	lea    0x14(%ebp),%eax
  800656:	e8 54 fc ff ff       	call   8002af <getuint>
			base = 8;
  80065b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800660:	eb 40                	jmp    8006a2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800662:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800666:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80066d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800670:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800674:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80067b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8d 50 04             	lea    0x4(%eax),%edx
  800684:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80068e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800693:	eb 0d                	jmp    8006a2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800695:	8d 45 14             	lea    0x14(%ebp),%eax
  800698:	e8 12 fc ff ff       	call   8002af <getuint>
			base = 16;
  80069d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006a2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8006a6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8006aa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8006ad:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006b1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006b5:	89 04 24             	mov    %eax,(%esp)
  8006b8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006bc:	89 fa                	mov    %edi,%edx
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	e8 fa fa ff ff       	call   8001c0 <printnum>
			break;
  8006c6:	e9 88 fc ff ff       	jmp    800353 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006cb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006cf:	89 04 24             	mov    %eax,(%esp)
  8006d2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006d5:	e9 79 fc ff ff       	jmp    800353 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006de:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006e5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006e8:	89 f3                	mov    %esi,%ebx
  8006ea:	eb 03                	jmp    8006ef <vprintfmt+0x3c1>
  8006ec:	83 eb 01             	sub    $0x1,%ebx
  8006ef:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8006f3:	75 f7                	jne    8006ec <vprintfmt+0x3be>
  8006f5:	e9 59 fc ff ff       	jmp    800353 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8006fa:	83 c4 3c             	add    $0x3c,%esp
  8006fd:	5b                   	pop    %ebx
  8006fe:	5e                   	pop    %esi
  8006ff:	5f                   	pop    %edi
  800700:	5d                   	pop    %ebp
  800701:	c3                   	ret    

00800702 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	83 ec 28             	sub    $0x28,%esp
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80070e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800711:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800715:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800718:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80071f:	85 c0                	test   %eax,%eax
  800721:	74 30                	je     800753 <vsnprintf+0x51>
  800723:	85 d2                	test   %edx,%edx
  800725:	7e 2c                	jle    800753 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80072e:	8b 45 10             	mov    0x10(%ebp),%eax
  800731:	89 44 24 08          	mov    %eax,0x8(%esp)
  800735:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800738:	89 44 24 04          	mov    %eax,0x4(%esp)
  80073c:	c7 04 24 e9 02 80 00 	movl   $0x8002e9,(%esp)
  800743:	e8 e6 fb ff ff       	call   80032e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80074b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80074e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800751:	eb 05                	jmp    800758 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800753:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800758:	c9                   	leave  
  800759:	c3                   	ret    

0080075a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80075a:	55                   	push   %ebp
  80075b:	89 e5                	mov    %esp,%ebp
  80075d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800760:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800763:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800767:	8b 45 10             	mov    0x10(%ebp),%eax
  80076a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80076e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800771:	89 44 24 04          	mov    %eax,0x4(%esp)
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	89 04 24             	mov    %eax,(%esp)
  80077b:	e8 82 ff ff ff       	call   800702 <vsnprintf>
	va_end(ap);

	return rc;
}
  800780:	c9                   	leave  
  800781:	c3                   	ret    
  800782:	66 90                	xchg   %ax,%ax
  800784:	66 90                	xchg   %ax,%ax
  800786:	66 90                	xchg   %ax,%ax
  800788:	66 90                	xchg   %ax,%ax
  80078a:	66 90                	xchg   %ax,%ax
  80078c:	66 90                	xchg   %ax,%ax
  80078e:	66 90                	xchg   %ax,%ax

00800790 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800796:	b8 00 00 00 00       	mov    $0x0,%eax
  80079b:	eb 03                	jmp    8007a0 <strlen+0x10>
		n++;
  80079d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a4:	75 f7                	jne    80079d <strlen+0xd>
		n++;
	return n;
}
  8007a6:	5d                   	pop    %ebp
  8007a7:	c3                   	ret    

008007a8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b6:	eb 03                	jmp    8007bb <strnlen+0x13>
		n++;
  8007b8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007bb:	39 d0                	cmp    %edx,%eax
  8007bd:	74 06                	je     8007c5 <strnlen+0x1d>
  8007bf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007c3:	75 f3                	jne    8007b8 <strnlen+0x10>
		n++;
	return n;
}
  8007c5:	5d                   	pop    %ebp
  8007c6:	c3                   	ret    

008007c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007c7:	55                   	push   %ebp
  8007c8:	89 e5                	mov    %esp,%ebp
  8007ca:	53                   	push   %ebx
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007d1:	89 c2                	mov    %eax,%edx
  8007d3:	83 c2 01             	add    $0x1,%edx
  8007d6:	83 c1 01             	add    $0x1,%ecx
  8007d9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007dd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007e0:	84 db                	test   %bl,%bl
  8007e2:	75 ef                	jne    8007d3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007e4:	5b                   	pop    %ebx
  8007e5:	5d                   	pop    %ebp
  8007e6:	c3                   	ret    

008007e7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	53                   	push   %ebx
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007f1:	89 1c 24             	mov    %ebx,(%esp)
  8007f4:	e8 97 ff ff ff       	call   800790 <strlen>
	strcpy(dst + len, src);
  8007f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800800:	01 d8                	add    %ebx,%eax
  800802:	89 04 24             	mov    %eax,(%esp)
  800805:	e8 bd ff ff ff       	call   8007c7 <strcpy>
	return dst;
}
  80080a:	89 d8                	mov    %ebx,%eax
  80080c:	83 c4 08             	add    $0x8,%esp
  80080f:	5b                   	pop    %ebx
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	56                   	push   %esi
  800816:	53                   	push   %ebx
  800817:	8b 75 08             	mov    0x8(%ebp),%esi
  80081a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80081d:	89 f3                	mov    %esi,%ebx
  80081f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800822:	89 f2                	mov    %esi,%edx
  800824:	eb 0f                	jmp    800835 <strncpy+0x23>
		*dst++ = *src;
  800826:	83 c2 01             	add    $0x1,%edx
  800829:	0f b6 01             	movzbl (%ecx),%eax
  80082c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80082f:	80 39 01             	cmpb   $0x1,(%ecx)
  800832:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800835:	39 da                	cmp    %ebx,%edx
  800837:	75 ed                	jne    800826 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800839:	89 f0                	mov    %esi,%eax
  80083b:	5b                   	pop    %ebx
  80083c:	5e                   	pop    %esi
  80083d:	5d                   	pop    %ebp
  80083e:	c3                   	ret    

0080083f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80083f:	55                   	push   %ebp
  800840:	89 e5                	mov    %esp,%ebp
  800842:	56                   	push   %esi
  800843:	53                   	push   %ebx
  800844:	8b 75 08             	mov    0x8(%ebp),%esi
  800847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80084d:	89 f0                	mov    %esi,%eax
  80084f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800853:	85 c9                	test   %ecx,%ecx
  800855:	75 0b                	jne    800862 <strlcpy+0x23>
  800857:	eb 1d                	jmp    800876 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800859:	83 c0 01             	add    $0x1,%eax
  80085c:	83 c2 01             	add    $0x1,%edx
  80085f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800862:	39 d8                	cmp    %ebx,%eax
  800864:	74 0b                	je     800871 <strlcpy+0x32>
  800866:	0f b6 0a             	movzbl (%edx),%ecx
  800869:	84 c9                	test   %cl,%cl
  80086b:	75 ec                	jne    800859 <strlcpy+0x1a>
  80086d:	89 c2                	mov    %eax,%edx
  80086f:	eb 02                	jmp    800873 <strlcpy+0x34>
  800871:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800873:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800876:	29 f0                	sub    %esi,%eax
}
  800878:	5b                   	pop    %ebx
  800879:	5e                   	pop    %esi
  80087a:	5d                   	pop    %ebp
  80087b:	c3                   	ret    

0080087c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800882:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800885:	eb 06                	jmp    80088d <strcmp+0x11>
		p++, q++;
  800887:	83 c1 01             	add    $0x1,%ecx
  80088a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80088d:	0f b6 01             	movzbl (%ecx),%eax
  800890:	84 c0                	test   %al,%al
  800892:	74 04                	je     800898 <strcmp+0x1c>
  800894:	3a 02                	cmp    (%edx),%al
  800896:	74 ef                	je     800887 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800898:	0f b6 c0             	movzbl %al,%eax
  80089b:	0f b6 12             	movzbl (%edx),%edx
  80089e:	29 d0                	sub    %edx,%eax
}
  8008a0:	5d                   	pop    %ebp
  8008a1:	c3                   	ret    

008008a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	53                   	push   %ebx
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ac:	89 c3                	mov    %eax,%ebx
  8008ae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008b1:	eb 06                	jmp    8008b9 <strncmp+0x17>
		n--, p++, q++;
  8008b3:	83 c0 01             	add    $0x1,%eax
  8008b6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008b9:	39 d8                	cmp    %ebx,%eax
  8008bb:	74 15                	je     8008d2 <strncmp+0x30>
  8008bd:	0f b6 08             	movzbl (%eax),%ecx
  8008c0:	84 c9                	test   %cl,%cl
  8008c2:	74 04                	je     8008c8 <strncmp+0x26>
  8008c4:	3a 0a                	cmp    (%edx),%cl
  8008c6:	74 eb                	je     8008b3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c8:	0f b6 00             	movzbl (%eax),%eax
  8008cb:	0f b6 12             	movzbl (%edx),%edx
  8008ce:	29 d0                	sub    %edx,%eax
  8008d0:	eb 05                	jmp    8008d7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008d7:	5b                   	pop    %ebx
  8008d8:	5d                   	pop    %ebp
  8008d9:	c3                   	ret    

008008da <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e4:	eb 07                	jmp    8008ed <strchr+0x13>
		if (*s == c)
  8008e6:	38 ca                	cmp    %cl,%dl
  8008e8:	74 0f                	je     8008f9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008ea:	83 c0 01             	add    $0x1,%eax
  8008ed:	0f b6 10             	movzbl (%eax),%edx
  8008f0:	84 d2                	test   %dl,%dl
  8008f2:	75 f2                	jne    8008e6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8008f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f9:	5d                   	pop    %ebp
  8008fa:	c3                   	ret    

008008fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800905:	eb 07                	jmp    80090e <strfind+0x13>
		if (*s == c)
  800907:	38 ca                	cmp    %cl,%dl
  800909:	74 0a                	je     800915 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80090b:	83 c0 01             	add    $0x1,%eax
  80090e:	0f b6 10             	movzbl (%eax),%edx
  800911:	84 d2                	test   %dl,%dl
  800913:	75 f2                	jne    800907 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	57                   	push   %edi
  80091b:	56                   	push   %esi
  80091c:	53                   	push   %ebx
  80091d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800920:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800923:	85 c9                	test   %ecx,%ecx
  800925:	74 36                	je     80095d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800927:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80092d:	75 28                	jne    800957 <memset+0x40>
  80092f:	f6 c1 03             	test   $0x3,%cl
  800932:	75 23                	jne    800957 <memset+0x40>
		c &= 0xFF;
  800934:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800938:	89 d3                	mov    %edx,%ebx
  80093a:	c1 e3 08             	shl    $0x8,%ebx
  80093d:	89 d6                	mov    %edx,%esi
  80093f:	c1 e6 18             	shl    $0x18,%esi
  800942:	89 d0                	mov    %edx,%eax
  800944:	c1 e0 10             	shl    $0x10,%eax
  800947:	09 f0                	or     %esi,%eax
  800949:	09 c2                	or     %eax,%edx
  80094b:	89 d0                	mov    %edx,%eax
  80094d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80094f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800952:	fc                   	cld    
  800953:	f3 ab                	rep stos %eax,%es:(%edi)
  800955:	eb 06                	jmp    80095d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	fc                   	cld    
  80095b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80095d:	89 f8                	mov    %edi,%eax
  80095f:	5b                   	pop    %ebx
  800960:	5e                   	pop    %esi
  800961:	5f                   	pop    %edi
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	57                   	push   %edi
  800968:	56                   	push   %esi
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80096f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800972:	39 c6                	cmp    %eax,%esi
  800974:	73 35                	jae    8009ab <memmove+0x47>
  800976:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800979:	39 d0                	cmp    %edx,%eax
  80097b:	73 2e                	jae    8009ab <memmove+0x47>
		s += n;
		d += n;
  80097d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800980:	89 d6                	mov    %edx,%esi
  800982:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800984:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80098a:	75 13                	jne    80099f <memmove+0x3b>
  80098c:	f6 c1 03             	test   $0x3,%cl
  80098f:	75 0e                	jne    80099f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800991:	83 ef 04             	sub    $0x4,%edi
  800994:	8d 72 fc             	lea    -0x4(%edx),%esi
  800997:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80099a:	fd                   	std    
  80099b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80099d:	eb 09                	jmp    8009a8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80099f:	83 ef 01             	sub    $0x1,%edi
  8009a2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009a5:	fd                   	std    
  8009a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009a8:	fc                   	cld    
  8009a9:	eb 1d                	jmp    8009c8 <memmove+0x64>
  8009ab:	89 f2                	mov    %esi,%edx
  8009ad:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009af:	f6 c2 03             	test   $0x3,%dl
  8009b2:	75 0f                	jne    8009c3 <memmove+0x5f>
  8009b4:	f6 c1 03             	test   $0x3,%cl
  8009b7:	75 0a                	jne    8009c3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009b9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8009bc:	89 c7                	mov    %eax,%edi
  8009be:	fc                   	cld    
  8009bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c1:	eb 05                	jmp    8009c8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009c3:	89 c7                	mov    %eax,%edi
  8009c5:	fc                   	cld    
  8009c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009c8:	5e                   	pop    %esi
  8009c9:	5f                   	pop    %edi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	89 04 24             	mov    %eax,(%esp)
  8009e6:	e8 79 ff ff ff       	call   800964 <memmove>
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	56                   	push   %esi
  8009f1:	53                   	push   %ebx
  8009f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f8:	89 d6                	mov    %edx,%esi
  8009fa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009fd:	eb 1a                	jmp    800a19 <memcmp+0x2c>
		if (*s1 != *s2)
  8009ff:	0f b6 02             	movzbl (%edx),%eax
  800a02:	0f b6 19             	movzbl (%ecx),%ebx
  800a05:	38 d8                	cmp    %bl,%al
  800a07:	74 0a                	je     800a13 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a09:	0f b6 c0             	movzbl %al,%eax
  800a0c:	0f b6 db             	movzbl %bl,%ebx
  800a0f:	29 d8                	sub    %ebx,%eax
  800a11:	eb 0f                	jmp    800a22 <memcmp+0x35>
		s1++, s2++;
  800a13:	83 c2 01             	add    $0x1,%edx
  800a16:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a19:	39 f2                	cmp    %esi,%edx
  800a1b:	75 e2                	jne    8009ff <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a22:	5b                   	pop    %ebx
  800a23:	5e                   	pop    %esi
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a34:	eb 07                	jmp    800a3d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a36:	38 08                	cmp    %cl,(%eax)
  800a38:	74 07                	je     800a41 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a3a:	83 c0 01             	add    $0x1,%eax
  800a3d:	39 d0                	cmp    %edx,%eax
  800a3f:	72 f5                	jb     800a36 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    

00800a43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	57                   	push   %edi
  800a47:	56                   	push   %esi
  800a48:	53                   	push   %ebx
  800a49:	8b 55 08             	mov    0x8(%ebp),%edx
  800a4c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a4f:	eb 03                	jmp    800a54 <strtol+0x11>
		s++;
  800a51:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a54:	0f b6 0a             	movzbl (%edx),%ecx
  800a57:	80 f9 09             	cmp    $0x9,%cl
  800a5a:	74 f5                	je     800a51 <strtol+0xe>
  800a5c:	80 f9 20             	cmp    $0x20,%cl
  800a5f:	74 f0                	je     800a51 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a61:	80 f9 2b             	cmp    $0x2b,%cl
  800a64:	75 0a                	jne    800a70 <strtol+0x2d>
		s++;
  800a66:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a69:	bf 00 00 00 00       	mov    $0x0,%edi
  800a6e:	eb 11                	jmp    800a81 <strtol+0x3e>
  800a70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a75:	80 f9 2d             	cmp    $0x2d,%cl
  800a78:	75 07                	jne    800a81 <strtol+0x3e>
		s++, neg = 1;
  800a7a:	8d 52 01             	lea    0x1(%edx),%edx
  800a7d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a81:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800a86:	75 15                	jne    800a9d <strtol+0x5a>
  800a88:	80 3a 30             	cmpb   $0x30,(%edx)
  800a8b:	75 10                	jne    800a9d <strtol+0x5a>
  800a8d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800a91:	75 0a                	jne    800a9d <strtol+0x5a>
		s += 2, base = 16;
  800a93:	83 c2 02             	add    $0x2,%edx
  800a96:	b8 10 00 00 00       	mov    $0x10,%eax
  800a9b:	eb 10                	jmp    800aad <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800a9d:	85 c0                	test   %eax,%eax
  800a9f:	75 0c                	jne    800aad <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aa3:	80 3a 30             	cmpb   $0x30,(%edx)
  800aa6:	75 05                	jne    800aad <strtol+0x6a>
		s++, base = 8;
  800aa8:	83 c2 01             	add    $0x1,%edx
  800aab:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800aad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ab2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ab5:	0f b6 0a             	movzbl (%edx),%ecx
  800ab8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800abb:	89 f0                	mov    %esi,%eax
  800abd:	3c 09                	cmp    $0x9,%al
  800abf:	77 08                	ja     800ac9 <strtol+0x86>
			dig = *s - '0';
  800ac1:	0f be c9             	movsbl %cl,%ecx
  800ac4:	83 e9 30             	sub    $0x30,%ecx
  800ac7:	eb 20                	jmp    800ae9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ac9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800acc:	89 f0                	mov    %esi,%eax
  800ace:	3c 19                	cmp    $0x19,%al
  800ad0:	77 08                	ja     800ada <strtol+0x97>
			dig = *s - 'a' + 10;
  800ad2:	0f be c9             	movsbl %cl,%ecx
  800ad5:	83 e9 57             	sub    $0x57,%ecx
  800ad8:	eb 0f                	jmp    800ae9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800ada:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800add:	89 f0                	mov    %esi,%eax
  800adf:	3c 19                	cmp    $0x19,%al
  800ae1:	77 16                	ja     800af9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800ae3:	0f be c9             	movsbl %cl,%ecx
  800ae6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ae9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800aec:	7d 0f                	jge    800afd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800aee:	83 c2 01             	add    $0x1,%edx
  800af1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800af5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800af7:	eb bc                	jmp    800ab5 <strtol+0x72>
  800af9:	89 d8                	mov    %ebx,%eax
  800afb:	eb 02                	jmp    800aff <strtol+0xbc>
  800afd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800aff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b03:	74 05                	je     800b0a <strtol+0xc7>
		*endptr = (char *) s;
  800b05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b08:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b0a:	f7 d8                	neg    %eax
  800b0c:	85 ff                	test   %edi,%edi
  800b0e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	57                   	push   %edi
  800b1a:	56                   	push   %esi
  800b1b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b24:	8b 55 08             	mov    0x8(%ebp),%edx
  800b27:	89 c3                	mov    %eax,%ebx
  800b29:	89 c7                	mov    %eax,%edi
  800b2b:	89 c6                	mov    %eax,%esi
  800b2d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b2f:	5b                   	pop    %ebx
  800b30:	5e                   	pop    %esi
  800b31:	5f                   	pop    %edi
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	57                   	push   %edi
  800b38:	56                   	push   %esi
  800b39:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b44:	89 d1                	mov    %edx,%ecx
  800b46:	89 d3                	mov    %edx,%ebx
  800b48:	89 d7                	mov    %edx,%edi
  800b4a:	89 d6                	mov    %edx,%esi
  800b4c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b4e:	5b                   	pop    %ebx
  800b4f:	5e                   	pop    %esi
  800b50:	5f                   	pop    %edi
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	57                   	push   %edi
  800b57:	56                   	push   %esi
  800b58:	53                   	push   %ebx
  800b59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b61:	b8 03 00 00 00       	mov    $0x3,%eax
  800b66:	8b 55 08             	mov    0x8(%ebp),%edx
  800b69:	89 cb                	mov    %ecx,%ebx
  800b6b:	89 cf                	mov    %ecx,%edi
  800b6d:	89 ce                	mov    %ecx,%esi
  800b6f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800b71:	85 c0                	test   %eax,%eax
  800b73:	7e 28                	jle    800b9d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b75:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b79:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800b80:	00 
  800b81:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  800b88:	00 
  800b89:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800b90:	00 
  800b91:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  800b98:	e8 a9 16 00 00       	call   802246 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b9d:	83 c4 2c             	add    $0x2c,%esp
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5f                   	pop    %edi
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    

00800ba5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	57                   	push   %edi
  800ba9:	56                   	push   %esi
  800baa:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bab:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb0:	b8 02 00 00 00       	mov    $0x2,%eax
  800bb5:	89 d1                	mov    %edx,%ecx
  800bb7:	89 d3                	mov    %edx,%ebx
  800bb9:	89 d7                	mov    %edx,%edi
  800bbb:	89 d6                	mov    %edx,%esi
  800bbd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <sys_yield>:

void
sys_yield(void)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	57                   	push   %edi
  800bc8:	56                   	push   %esi
  800bc9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bca:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bd4:	89 d1                	mov    %edx,%ecx
  800bd6:	89 d3                	mov    %edx,%ebx
  800bd8:	89 d7                	mov    %edx,%edi
  800bda:	89 d6                	mov    %edx,%esi
  800bdc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bde:	5b                   	pop    %ebx
  800bdf:	5e                   	pop    %esi
  800be0:	5f                   	pop    %edi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    

00800be3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	57                   	push   %edi
  800be7:	56                   	push   %esi
  800be8:	53                   	push   %ebx
  800be9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bec:	be 00 00 00 00       	mov    $0x0,%esi
  800bf1:	b8 04 00 00 00       	mov    $0x4,%eax
  800bf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bff:	89 f7                	mov    %esi,%edi
  800c01:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c03:	85 c0                	test   %eax,%eax
  800c05:	7e 28                	jle    800c2f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c07:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c0b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c12:	00 
  800c13:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  800c1a:	00 
  800c1b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c22:	00 
  800c23:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  800c2a:	e8 17 16 00 00       	call   802246 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c2f:	83 c4 2c             	add    $0x2c,%esp
  800c32:	5b                   	pop    %ebx
  800c33:	5e                   	pop    %esi
  800c34:	5f                   	pop    %edi
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	57                   	push   %edi
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
  800c3d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c40:	b8 05 00 00 00       	mov    $0x5,%eax
  800c45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c48:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c4e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c51:	8b 75 18             	mov    0x18(%ebp),%esi
  800c54:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c56:	85 c0                	test   %eax,%eax
  800c58:	7e 28                	jle    800c82 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c5e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800c65:	00 
  800c66:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  800c6d:	00 
  800c6e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c75:	00 
  800c76:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  800c7d:	e8 c4 15 00 00       	call   802246 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c82:	83 c4 2c             	add    $0x2c,%esp
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
  800c90:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c98:	b8 06 00 00 00       	mov    $0x6,%eax
  800c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	89 df                	mov    %ebx,%edi
  800ca5:	89 de                	mov    %ebx,%esi
  800ca7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ca9:	85 c0                	test   %eax,%eax
  800cab:	7e 28                	jle    800cd5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cad:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cb1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800cb8:	00 
  800cb9:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  800cc0:	00 
  800cc1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc8:	00 
  800cc9:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  800cd0:	e8 71 15 00 00       	call   802246 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cd5:	83 c4 2c             	add    $0x2c,%esp
  800cd8:	5b                   	pop    %ebx
  800cd9:	5e                   	pop    %esi
  800cda:	5f                   	pop    %edi
  800cdb:	5d                   	pop    %ebp
  800cdc:	c3                   	ret    

00800cdd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	57                   	push   %edi
  800ce1:	56                   	push   %esi
  800ce2:	53                   	push   %ebx
  800ce3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ceb:	b8 08 00 00 00       	mov    $0x8,%eax
  800cf0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	89 df                	mov    %ebx,%edi
  800cf8:	89 de                	mov    %ebx,%esi
  800cfa:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cfc:	85 c0                	test   %eax,%eax
  800cfe:	7e 28                	jle    800d28 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d00:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d04:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d0b:	00 
  800d0c:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  800d13:	00 
  800d14:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d1b:	00 
  800d1c:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  800d23:	e8 1e 15 00 00       	call   802246 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d28:	83 c4 2c             	add    $0x2c,%esp
  800d2b:	5b                   	pop    %ebx
  800d2c:	5e                   	pop    %esi
  800d2d:	5f                   	pop    %edi
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	57                   	push   %edi
  800d34:	56                   	push   %esi
  800d35:	53                   	push   %ebx
  800d36:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3e:	b8 09 00 00 00       	mov    $0x9,%eax
  800d43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d46:	8b 55 08             	mov    0x8(%ebp),%edx
  800d49:	89 df                	mov    %ebx,%edi
  800d4b:	89 de                	mov    %ebx,%esi
  800d4d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	7e 28                	jle    800d7b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d53:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d57:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d5e:	00 
  800d5f:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  800d66:	00 
  800d67:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d6e:	00 
  800d6f:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  800d76:	e8 cb 14 00 00       	call   802246 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d7b:	83 c4 2c             	add    $0x2c,%esp
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800d8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d91:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	89 df                	mov    %ebx,%edi
  800d9e:	89 de                	mov    %ebx,%esi
  800da0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800da2:	85 c0                	test   %eax,%eax
  800da4:	7e 28                	jle    800dce <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800daa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800db1:	00 
  800db2:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  800db9:	00 
  800dba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc1:	00 
  800dc2:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  800dc9:	e8 78 14 00 00       	call   802246 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dce:	83 c4 2c             	add    $0x2c,%esp
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	57                   	push   %edi
  800dda:	56                   	push   %esi
  800ddb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ddc:	be 00 00 00 00       	mov    $0x0,%esi
  800de1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800de6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800def:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
  800dff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e07:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0f:	89 cb                	mov    %ecx,%ebx
  800e11:	89 cf                	mov    %ecx,%edi
  800e13:	89 ce                	mov    %ecx,%esi
  800e15:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	7e 28                	jle    800e43 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e1f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e26:	00 
  800e27:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  800e2e:	00 
  800e2f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e36:	00 
  800e37:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  800e3e:	e8 03 14 00 00       	call   802246 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e43:	83 c4 2c             	add    $0x2c,%esp
  800e46:	5b                   	pop    %ebx
  800e47:	5e                   	pop    %esi
  800e48:	5f                   	pop    %edi
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <sys_time_msec>:

unsigned int
sys_time_msec(void)
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
  800e51:	ba 00 00 00 00       	mov    $0x0,%edx
  800e56:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e5b:	89 d1                	mov    %edx,%ecx
  800e5d:	89 d3                	mov    %edx,%ebx
  800e5f:	89 d7                	mov    %edx,%edi
  800e61:	89 d6                	mov    %edx,%esi
  800e63:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5f                   	pop    %edi
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	57                   	push   %edi
  800e6e:	56                   	push   %esi
  800e6f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e70:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e75:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e80:	89 df                	mov    %ebx,%edi
  800e82:	89 de                	mov    %ebx,%esi
  800e84:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800e86:	5b                   	pop    %ebx
  800e87:	5e                   	pop    %esi
  800e88:	5f                   	pop    %edi
  800e89:	5d                   	pop    %ebp
  800e8a:	c3                   	ret    

00800e8b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	57                   	push   %edi
  800e8f:	56                   	push   %esi
  800e90:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e91:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e96:	b8 10 00 00 00       	mov    $0x10,%eax
  800e9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea1:	89 df                	mov    %ebx,%edi
  800ea3:	89 de                	mov    %ebx,%esi
  800ea5:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800ea7:	5b                   	pop    %ebx
  800ea8:	5e                   	pop    %esi
  800ea9:	5f                   	pop    %edi
  800eaa:	5d                   	pop    %ebp
  800eab:	c3                   	ret    

00800eac <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800eac:	55                   	push   %ebp
  800ead:	89 e5                	mov    %esp,%ebp
  800eaf:	57                   	push   %edi
  800eb0:	56                   	push   %esi
  800eb1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb7:	b8 11 00 00 00       	mov    $0x11,%eax
  800ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebf:	89 cb                	mov    %ecx,%ebx
  800ec1:	89 cf                	mov    %ecx,%edi
  800ec3:	89 ce                	mov    %ecx,%esi
  800ec5:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800ec7:	5b                   	pop    %ebx
  800ec8:	5e                   	pop    %esi
  800ec9:	5f                   	pop    %edi
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    

00800ecc <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	57                   	push   %edi
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
  800ed2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed5:	be 00 00 00 00       	mov    $0x0,%esi
  800eda:	b8 12 00 00 00       	mov    $0x12,%eax
  800edf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eeb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800eed:	85 c0                	test   %eax,%eax
  800eef:	7e 28                	jle    800f19 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800efc:	00 
  800efd:	c7 44 24 08 27 2a 80 	movl   $0x802a27,0x8(%esp)
  800f04:	00 
  800f05:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f0c:	00 
  800f0d:	c7 04 24 44 2a 80 00 	movl   $0x802a44,(%esp)
  800f14:	e8 2d 13 00 00       	call   802246 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  800f19:	83 c4 2c             	add    $0x2c,%esp
  800f1c:	5b                   	pop    %ebx
  800f1d:	5e                   	pop    %esi
  800f1e:	5f                   	pop    %edi
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    
  800f21:	66 90                	xchg   %ax,%ax
  800f23:	66 90                	xchg   %ax,%ax
  800f25:	66 90                	xchg   %ax,%ax
  800f27:	66 90                	xchg   %ax,%ax
  800f29:	66 90                	xchg   %ax,%ax
  800f2b:	66 90                	xchg   %ax,%ax
  800f2d:	66 90                	xchg   %ax,%ax
  800f2f:	90                   	nop

00800f30 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	05 00 00 00 30       	add    $0x30000000,%eax
  800f3b:	c1 e8 0c             	shr    $0xc,%eax
}
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800f4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f50:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    

00800f57 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f5d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f62:	89 c2                	mov    %eax,%edx
  800f64:	c1 ea 16             	shr    $0x16,%edx
  800f67:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f6e:	f6 c2 01             	test   $0x1,%dl
  800f71:	74 11                	je     800f84 <fd_alloc+0x2d>
  800f73:	89 c2                	mov    %eax,%edx
  800f75:	c1 ea 0c             	shr    $0xc,%edx
  800f78:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f7f:	f6 c2 01             	test   $0x1,%dl
  800f82:	75 09                	jne    800f8d <fd_alloc+0x36>
			*fd_store = fd;
  800f84:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f86:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8b:	eb 17                	jmp    800fa4 <fd_alloc+0x4d>
  800f8d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f92:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f97:	75 c9                	jne    800f62 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f99:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f9f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800fa4:	5d                   	pop    %ebp
  800fa5:	c3                   	ret    

00800fa6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800fa6:	55                   	push   %ebp
  800fa7:	89 e5                	mov    %esp,%ebp
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800fac:	83 f8 1f             	cmp    $0x1f,%eax
  800faf:	77 36                	ja     800fe7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fb1:	c1 e0 0c             	shl    $0xc,%eax
  800fb4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fb9:	89 c2                	mov    %eax,%edx
  800fbb:	c1 ea 16             	shr    $0x16,%edx
  800fbe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fc5:	f6 c2 01             	test   $0x1,%dl
  800fc8:	74 24                	je     800fee <fd_lookup+0x48>
  800fca:	89 c2                	mov    %eax,%edx
  800fcc:	c1 ea 0c             	shr    $0xc,%edx
  800fcf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fd6:	f6 c2 01             	test   $0x1,%dl
  800fd9:	74 1a                	je     800ff5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fde:	89 02                	mov    %eax,(%edx)
	return 0;
  800fe0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe5:	eb 13                	jmp    800ffa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800fe7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fec:	eb 0c                	jmp    800ffa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800fee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff3:	eb 05                	jmp    800ffa <fd_lookup+0x54>
  800ff5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800ffa:	5d                   	pop    %ebp
  800ffb:	c3                   	ret    

00800ffc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ffc:	55                   	push   %ebp
  800ffd:	89 e5                	mov    %esp,%ebp
  800fff:	83 ec 18             	sub    $0x18,%esp
  801002:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801005:	ba 00 00 00 00       	mov    $0x0,%edx
  80100a:	eb 13                	jmp    80101f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80100c:	39 08                	cmp    %ecx,(%eax)
  80100e:	75 0c                	jne    80101c <dev_lookup+0x20>
			*dev = devtab[i];
  801010:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801013:	89 01                	mov    %eax,(%ecx)
			return 0;
  801015:	b8 00 00 00 00       	mov    $0x0,%eax
  80101a:	eb 38                	jmp    801054 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80101c:	83 c2 01             	add    $0x1,%edx
  80101f:	8b 04 95 d0 2a 80 00 	mov    0x802ad0(,%edx,4),%eax
  801026:	85 c0                	test   %eax,%eax
  801028:	75 e2                	jne    80100c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80102a:	a1 08 40 80 00       	mov    0x804008,%eax
  80102f:	8b 40 48             	mov    0x48(%eax),%eax
  801032:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801036:	89 44 24 04          	mov    %eax,0x4(%esp)
  80103a:	c7 04 24 54 2a 80 00 	movl   $0x802a54,(%esp)
  801041:	e8 5c f1 ff ff       	call   8001a2 <cprintf>
	*dev = 0;
  801046:	8b 45 0c             	mov    0xc(%ebp),%eax
  801049:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80104f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801054:	c9                   	leave  
  801055:	c3                   	ret    

00801056 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	56                   	push   %esi
  80105a:	53                   	push   %ebx
  80105b:	83 ec 20             	sub    $0x20,%esp
  80105e:	8b 75 08             	mov    0x8(%ebp),%esi
  801061:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801064:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801067:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80106b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801071:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801074:	89 04 24             	mov    %eax,(%esp)
  801077:	e8 2a ff ff ff       	call   800fa6 <fd_lookup>
  80107c:	85 c0                	test   %eax,%eax
  80107e:	78 05                	js     801085 <fd_close+0x2f>
	    || fd != fd2)
  801080:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801083:	74 0c                	je     801091 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801085:	84 db                	test   %bl,%bl
  801087:	ba 00 00 00 00       	mov    $0x0,%edx
  80108c:	0f 44 c2             	cmove  %edx,%eax
  80108f:	eb 3f                	jmp    8010d0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801091:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801094:	89 44 24 04          	mov    %eax,0x4(%esp)
  801098:	8b 06                	mov    (%esi),%eax
  80109a:	89 04 24             	mov    %eax,(%esp)
  80109d:	e8 5a ff ff ff       	call   800ffc <dev_lookup>
  8010a2:	89 c3                	mov    %eax,%ebx
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	78 16                	js     8010be <fd_close+0x68>
		if (dev->dev_close)
  8010a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010ab:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8010ae:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	74 07                	je     8010be <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8010b7:	89 34 24             	mov    %esi,(%esp)
  8010ba:	ff d0                	call   *%eax
  8010bc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8010be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010c9:	e8 bc fb ff ff       	call   800c8a <sys_page_unmap>
	return r;
  8010ce:	89 d8                	mov    %ebx,%eax
}
  8010d0:	83 c4 20             	add    $0x20,%esp
  8010d3:	5b                   	pop    %ebx
  8010d4:	5e                   	pop    %esi
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    

008010d7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	89 04 24             	mov    %eax,(%esp)
  8010ea:	e8 b7 fe ff ff       	call   800fa6 <fd_lookup>
  8010ef:	89 c2                	mov    %eax,%edx
  8010f1:	85 d2                	test   %edx,%edx
  8010f3:	78 13                	js     801108 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8010f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8010fc:	00 
  8010fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801100:	89 04 24             	mov    %eax,(%esp)
  801103:	e8 4e ff ff ff       	call   801056 <fd_close>
}
  801108:	c9                   	leave  
  801109:	c3                   	ret    

0080110a <close_all>:

void
close_all(void)
{
  80110a:	55                   	push   %ebp
  80110b:	89 e5                	mov    %esp,%ebp
  80110d:	53                   	push   %ebx
  80110e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801111:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801116:	89 1c 24             	mov    %ebx,(%esp)
  801119:	e8 b9 ff ff ff       	call   8010d7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80111e:	83 c3 01             	add    $0x1,%ebx
  801121:	83 fb 20             	cmp    $0x20,%ebx
  801124:	75 f0                	jne    801116 <close_all+0xc>
		close(i);
}
  801126:	83 c4 14             	add    $0x14,%esp
  801129:	5b                   	pop    %ebx
  80112a:	5d                   	pop    %ebp
  80112b:	c3                   	ret    

0080112c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	57                   	push   %edi
  801130:	56                   	push   %esi
  801131:	53                   	push   %ebx
  801132:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801135:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801138:	89 44 24 04          	mov    %eax,0x4(%esp)
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	89 04 24             	mov    %eax,(%esp)
  801142:	e8 5f fe ff ff       	call   800fa6 <fd_lookup>
  801147:	89 c2                	mov    %eax,%edx
  801149:	85 d2                	test   %edx,%edx
  80114b:	0f 88 e1 00 00 00    	js     801232 <dup+0x106>
		return r;
	close(newfdnum);
  801151:	8b 45 0c             	mov    0xc(%ebp),%eax
  801154:	89 04 24             	mov    %eax,(%esp)
  801157:	e8 7b ff ff ff       	call   8010d7 <close>

	newfd = INDEX2FD(newfdnum);
  80115c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80115f:	c1 e3 0c             	shl    $0xc,%ebx
  801162:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801168:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80116b:	89 04 24             	mov    %eax,(%esp)
  80116e:	e8 cd fd ff ff       	call   800f40 <fd2data>
  801173:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801175:	89 1c 24             	mov    %ebx,(%esp)
  801178:	e8 c3 fd ff ff       	call   800f40 <fd2data>
  80117d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80117f:	89 f0                	mov    %esi,%eax
  801181:	c1 e8 16             	shr    $0x16,%eax
  801184:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80118b:	a8 01                	test   $0x1,%al
  80118d:	74 43                	je     8011d2 <dup+0xa6>
  80118f:	89 f0                	mov    %esi,%eax
  801191:	c1 e8 0c             	shr    $0xc,%eax
  801194:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80119b:	f6 c2 01             	test   $0x1,%dl
  80119e:	74 32                	je     8011d2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8011a0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011a7:	25 07 0e 00 00       	and    $0xe07,%eax
  8011ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011b0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011b4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011bb:	00 
  8011bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011c7:	e8 6b fa ff ff       	call   800c37 <sys_page_map>
  8011cc:	89 c6                	mov    %eax,%esi
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	78 3e                	js     801210 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011d5:	89 c2                	mov    %eax,%edx
  8011d7:	c1 ea 0c             	shr    $0xc,%edx
  8011da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011e1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8011e7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8011eb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011f6:	00 
  8011f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801202:	e8 30 fa ff ff       	call   800c37 <sys_page_map>
  801207:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801209:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80120c:	85 f6                	test   %esi,%esi
  80120e:	79 22                	jns    801232 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801210:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801214:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80121b:	e8 6a fa ff ff       	call   800c8a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801220:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801224:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80122b:	e8 5a fa ff ff       	call   800c8a <sys_page_unmap>
	return r;
  801230:	89 f0                	mov    %esi,%eax
}
  801232:	83 c4 3c             	add    $0x3c,%esp
  801235:	5b                   	pop    %ebx
  801236:	5e                   	pop    %esi
  801237:	5f                   	pop    %edi
  801238:	5d                   	pop    %ebp
  801239:	c3                   	ret    

0080123a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	53                   	push   %ebx
  80123e:	83 ec 24             	sub    $0x24,%esp
  801241:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801244:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80124b:	89 1c 24             	mov    %ebx,(%esp)
  80124e:	e8 53 fd ff ff       	call   800fa6 <fd_lookup>
  801253:	89 c2                	mov    %eax,%edx
  801255:	85 d2                	test   %edx,%edx
  801257:	78 6d                	js     8012c6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801259:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80125c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801260:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801263:	8b 00                	mov    (%eax),%eax
  801265:	89 04 24             	mov    %eax,(%esp)
  801268:	e8 8f fd ff ff       	call   800ffc <dev_lookup>
  80126d:	85 c0                	test   %eax,%eax
  80126f:	78 55                	js     8012c6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801271:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801274:	8b 50 08             	mov    0x8(%eax),%edx
  801277:	83 e2 03             	and    $0x3,%edx
  80127a:	83 fa 01             	cmp    $0x1,%edx
  80127d:	75 23                	jne    8012a2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80127f:	a1 08 40 80 00       	mov    0x804008,%eax
  801284:	8b 40 48             	mov    0x48(%eax),%eax
  801287:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80128b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80128f:	c7 04 24 95 2a 80 00 	movl   $0x802a95,(%esp)
  801296:	e8 07 ef ff ff       	call   8001a2 <cprintf>
		return -E_INVAL;
  80129b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012a0:	eb 24                	jmp    8012c6 <read+0x8c>
	}
	if (!dev->dev_read)
  8012a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a5:	8b 52 08             	mov    0x8(%edx),%edx
  8012a8:	85 d2                	test   %edx,%edx
  8012aa:	74 15                	je     8012c1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012af:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8012ba:	89 04 24             	mov    %eax,(%esp)
  8012bd:	ff d2                	call   *%edx
  8012bf:	eb 05                	jmp    8012c6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8012c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8012c6:	83 c4 24             	add    $0x24,%esp
  8012c9:	5b                   	pop    %ebx
  8012ca:	5d                   	pop    %ebp
  8012cb:	c3                   	ret    

008012cc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	57                   	push   %edi
  8012d0:	56                   	push   %esi
  8012d1:	53                   	push   %ebx
  8012d2:	83 ec 1c             	sub    $0x1c,%esp
  8012d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012d8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e0:	eb 23                	jmp    801305 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012e2:	89 f0                	mov    %esi,%eax
  8012e4:	29 d8                	sub    %ebx,%eax
  8012e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012ea:	89 d8                	mov    %ebx,%eax
  8012ec:	03 45 0c             	add    0xc(%ebp),%eax
  8012ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012f3:	89 3c 24             	mov    %edi,(%esp)
  8012f6:	e8 3f ff ff ff       	call   80123a <read>
		if (m < 0)
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	78 10                	js     80130f <readn+0x43>
			return m;
		if (m == 0)
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 0a                	je     80130d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801303:	01 c3                	add    %eax,%ebx
  801305:	39 f3                	cmp    %esi,%ebx
  801307:	72 d9                	jb     8012e2 <readn+0x16>
  801309:	89 d8                	mov    %ebx,%eax
  80130b:	eb 02                	jmp    80130f <readn+0x43>
  80130d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80130f:	83 c4 1c             	add    $0x1c,%esp
  801312:	5b                   	pop    %ebx
  801313:	5e                   	pop    %esi
  801314:	5f                   	pop    %edi
  801315:	5d                   	pop    %ebp
  801316:	c3                   	ret    

00801317 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	53                   	push   %ebx
  80131b:	83 ec 24             	sub    $0x24,%esp
  80131e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801321:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801324:	89 44 24 04          	mov    %eax,0x4(%esp)
  801328:	89 1c 24             	mov    %ebx,(%esp)
  80132b:	e8 76 fc ff ff       	call   800fa6 <fd_lookup>
  801330:	89 c2                	mov    %eax,%edx
  801332:	85 d2                	test   %edx,%edx
  801334:	78 68                	js     80139e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801336:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801339:	89 44 24 04          	mov    %eax,0x4(%esp)
  80133d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801340:	8b 00                	mov    (%eax),%eax
  801342:	89 04 24             	mov    %eax,(%esp)
  801345:	e8 b2 fc ff ff       	call   800ffc <dev_lookup>
  80134a:	85 c0                	test   %eax,%eax
  80134c:	78 50                	js     80139e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80134e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801351:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801355:	75 23                	jne    80137a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801357:	a1 08 40 80 00       	mov    0x804008,%eax
  80135c:	8b 40 48             	mov    0x48(%eax),%eax
  80135f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801363:	89 44 24 04          	mov    %eax,0x4(%esp)
  801367:	c7 04 24 b1 2a 80 00 	movl   $0x802ab1,(%esp)
  80136e:	e8 2f ee ff ff       	call   8001a2 <cprintf>
		return -E_INVAL;
  801373:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801378:	eb 24                	jmp    80139e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80137a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137d:	8b 52 0c             	mov    0xc(%edx),%edx
  801380:	85 d2                	test   %edx,%edx
  801382:	74 15                	je     801399 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801384:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801387:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80138b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80138e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801392:	89 04 24             	mov    %eax,(%esp)
  801395:	ff d2                	call   *%edx
  801397:	eb 05                	jmp    80139e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801399:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80139e:	83 c4 24             	add    $0x24,%esp
  8013a1:	5b                   	pop    %ebx
  8013a2:	5d                   	pop    %ebp
  8013a3:	c3                   	ret    

008013a4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013aa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8013ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b4:	89 04 24             	mov    %eax,(%esp)
  8013b7:	e8 ea fb ff ff       	call   800fa6 <fd_lookup>
  8013bc:	85 c0                	test   %eax,%eax
  8013be:	78 0e                	js     8013ce <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8013c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	53                   	push   %ebx
  8013d4:	83 ec 24             	sub    $0x24,%esp
  8013d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013da:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e1:	89 1c 24             	mov    %ebx,(%esp)
  8013e4:	e8 bd fb ff ff       	call   800fa6 <fd_lookup>
  8013e9:	89 c2                	mov    %eax,%edx
  8013eb:	85 d2                	test   %edx,%edx
  8013ed:	78 61                	js     801450 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f9:	8b 00                	mov    (%eax),%eax
  8013fb:	89 04 24             	mov    %eax,(%esp)
  8013fe:	e8 f9 fb ff ff       	call   800ffc <dev_lookup>
  801403:	85 c0                	test   %eax,%eax
  801405:	78 49                	js     801450 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80140e:	75 23                	jne    801433 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801410:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801415:	8b 40 48             	mov    0x48(%eax),%eax
  801418:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80141c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801420:	c7 04 24 74 2a 80 00 	movl   $0x802a74,(%esp)
  801427:	e8 76 ed ff ff       	call   8001a2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80142c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801431:	eb 1d                	jmp    801450 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801433:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801436:	8b 52 18             	mov    0x18(%edx),%edx
  801439:	85 d2                	test   %edx,%edx
  80143b:	74 0e                	je     80144b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80143d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801440:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801444:	89 04 24             	mov    %eax,(%esp)
  801447:	ff d2                	call   *%edx
  801449:	eb 05                	jmp    801450 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80144b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801450:	83 c4 24             	add    $0x24,%esp
  801453:	5b                   	pop    %ebx
  801454:	5d                   	pop    %ebp
  801455:	c3                   	ret    

00801456 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	53                   	push   %ebx
  80145a:	83 ec 24             	sub    $0x24,%esp
  80145d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801460:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801463:	89 44 24 04          	mov    %eax,0x4(%esp)
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	89 04 24             	mov    %eax,(%esp)
  80146d:	e8 34 fb ff ff       	call   800fa6 <fd_lookup>
  801472:	89 c2                	mov    %eax,%edx
  801474:	85 d2                	test   %edx,%edx
  801476:	78 52                	js     8014ca <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801478:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80147f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801482:	8b 00                	mov    (%eax),%eax
  801484:	89 04 24             	mov    %eax,(%esp)
  801487:	e8 70 fb ff ff       	call   800ffc <dev_lookup>
  80148c:	85 c0                	test   %eax,%eax
  80148e:	78 3a                	js     8014ca <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801493:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801497:	74 2c                	je     8014c5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801499:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80149c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014a3:	00 00 00 
	stat->st_isdir = 0;
  8014a6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014ad:	00 00 00 
	stat->st_dev = dev;
  8014b0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014b6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014bd:	89 14 24             	mov    %edx,(%esp)
  8014c0:	ff 50 14             	call   *0x14(%eax)
  8014c3:	eb 05                	jmp    8014ca <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8014c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8014ca:	83 c4 24             	add    $0x24,%esp
  8014cd:	5b                   	pop    %ebx
  8014ce:	5d                   	pop    %ebp
  8014cf:	c3                   	ret    

008014d0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	56                   	push   %esi
  8014d4:	53                   	push   %ebx
  8014d5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8014df:	00 
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	89 04 24             	mov    %eax,(%esp)
  8014e6:	e8 84 02 00 00       	call   80176f <open>
  8014eb:	89 c3                	mov    %eax,%ebx
  8014ed:	85 db                	test   %ebx,%ebx
  8014ef:	78 1b                	js     80150c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f8:	89 1c 24             	mov    %ebx,(%esp)
  8014fb:	e8 56 ff ff ff       	call   801456 <fstat>
  801500:	89 c6                	mov    %eax,%esi
	close(fd);
  801502:	89 1c 24             	mov    %ebx,(%esp)
  801505:	e8 cd fb ff ff       	call   8010d7 <close>
	return r;
  80150a:	89 f0                	mov    %esi,%eax
}
  80150c:	83 c4 10             	add    $0x10,%esp
  80150f:	5b                   	pop    %ebx
  801510:	5e                   	pop    %esi
  801511:	5d                   	pop    %ebp
  801512:	c3                   	ret    

00801513 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	56                   	push   %esi
  801517:	53                   	push   %ebx
  801518:	83 ec 10             	sub    $0x10,%esp
  80151b:	89 c6                	mov    %eax,%esi
  80151d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80151f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801526:	75 11                	jne    801539 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801528:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80152f:	e8 61 0e 00 00       	call   802395 <ipc_find_env>
  801534:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801539:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801540:	00 
  801541:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801548:	00 
  801549:	89 74 24 04          	mov    %esi,0x4(%esp)
  80154d:	a1 00 40 80 00       	mov    0x804000,%eax
  801552:	89 04 24             	mov    %eax,(%esp)
  801555:	e8 ae 0d 00 00       	call   802308 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80155a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801561:	00 
  801562:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801566:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80156d:	e8 2e 0d 00 00       	call   8022a0 <ipc_recv>
}
  801572:	83 c4 10             	add    $0x10,%esp
  801575:	5b                   	pop    %ebx
  801576:	5e                   	pop    %esi
  801577:	5d                   	pop    %ebp
  801578:	c3                   	ret    

00801579 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80157f:	8b 45 08             	mov    0x8(%ebp),%eax
  801582:	8b 40 0c             	mov    0xc(%eax),%eax
  801585:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80158a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801592:	ba 00 00 00 00       	mov    $0x0,%edx
  801597:	b8 02 00 00 00       	mov    $0x2,%eax
  80159c:	e8 72 ff ff ff       	call   801513 <fsipc>
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8015af:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b9:	b8 06 00 00 00       	mov    $0x6,%eax
  8015be:	e8 50 ff ff ff       	call   801513 <fsipc>
}
  8015c3:	c9                   	leave  
  8015c4:	c3                   	ret    

008015c5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	53                   	push   %ebx
  8015c9:	83 ec 14             	sub    $0x14,%esp
  8015cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015da:	ba 00 00 00 00       	mov    $0x0,%edx
  8015df:	b8 05 00 00 00       	mov    $0x5,%eax
  8015e4:	e8 2a ff ff ff       	call   801513 <fsipc>
  8015e9:	89 c2                	mov    %eax,%edx
  8015eb:	85 d2                	test   %edx,%edx
  8015ed:	78 2b                	js     80161a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015ef:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8015f6:	00 
  8015f7:	89 1c 24             	mov    %ebx,(%esp)
  8015fa:	e8 c8 f1 ff ff       	call   8007c7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015ff:	a1 80 50 80 00       	mov    0x805080,%eax
  801604:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80160a:	a1 84 50 80 00       	mov    0x805084,%eax
  80160f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801615:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161a:	83 c4 14             	add    $0x14,%esp
  80161d:	5b                   	pop    %ebx
  80161e:	5d                   	pop    %ebp
  80161f:	c3                   	ret    

00801620 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	53                   	push   %ebx
  801624:	83 ec 14             	sub    $0x14,%esp
  801627:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
  80162d:	8b 40 0c             	mov    0xc(%eax),%eax
  801630:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801635:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80163b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801640:	0f 46 c3             	cmovbe %ebx,%eax
  801643:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801648:	89 44 24 08          	mov    %eax,0x8(%esp)
  80164c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801653:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80165a:	e8 05 f3 ff ff       	call   800964 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80165f:	ba 00 00 00 00       	mov    $0x0,%edx
  801664:	b8 04 00 00 00       	mov    $0x4,%eax
  801669:	e8 a5 fe ff ff       	call   801513 <fsipc>
  80166e:	85 c0                	test   %eax,%eax
  801670:	78 53                	js     8016c5 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801672:	39 c3                	cmp    %eax,%ebx
  801674:	73 24                	jae    80169a <devfile_write+0x7a>
  801676:	c7 44 24 0c e4 2a 80 	movl   $0x802ae4,0xc(%esp)
  80167d:	00 
  80167e:	c7 44 24 08 eb 2a 80 	movl   $0x802aeb,0x8(%esp)
  801685:	00 
  801686:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  80168d:	00 
  80168e:	c7 04 24 00 2b 80 00 	movl   $0x802b00,(%esp)
  801695:	e8 ac 0b 00 00       	call   802246 <_panic>
	assert(r <= PGSIZE);
  80169a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80169f:	7e 24                	jle    8016c5 <devfile_write+0xa5>
  8016a1:	c7 44 24 0c 0b 2b 80 	movl   $0x802b0b,0xc(%esp)
  8016a8:	00 
  8016a9:	c7 44 24 08 eb 2a 80 	movl   $0x802aeb,0x8(%esp)
  8016b0:	00 
  8016b1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  8016b8:	00 
  8016b9:	c7 04 24 00 2b 80 00 	movl   $0x802b00,(%esp)
  8016c0:	e8 81 0b 00 00       	call   802246 <_panic>
	return r;
}
  8016c5:	83 c4 14             	add    $0x14,%esp
  8016c8:	5b                   	pop    %ebx
  8016c9:	5d                   	pop    %ebp
  8016ca:	c3                   	ret    

008016cb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	56                   	push   %esi
  8016cf:	53                   	push   %ebx
  8016d0:	83 ec 10             	sub    $0x10,%esp
  8016d3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8016dc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016e1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ec:	b8 03 00 00 00       	mov    $0x3,%eax
  8016f1:	e8 1d fe ff ff       	call   801513 <fsipc>
  8016f6:	89 c3                	mov    %eax,%ebx
  8016f8:	85 c0                	test   %eax,%eax
  8016fa:	78 6a                	js     801766 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8016fc:	39 c6                	cmp    %eax,%esi
  8016fe:	73 24                	jae    801724 <devfile_read+0x59>
  801700:	c7 44 24 0c e4 2a 80 	movl   $0x802ae4,0xc(%esp)
  801707:	00 
  801708:	c7 44 24 08 eb 2a 80 	movl   $0x802aeb,0x8(%esp)
  80170f:	00 
  801710:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801717:	00 
  801718:	c7 04 24 00 2b 80 00 	movl   $0x802b00,(%esp)
  80171f:	e8 22 0b 00 00       	call   802246 <_panic>
	assert(r <= PGSIZE);
  801724:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801729:	7e 24                	jle    80174f <devfile_read+0x84>
  80172b:	c7 44 24 0c 0b 2b 80 	movl   $0x802b0b,0xc(%esp)
  801732:	00 
  801733:	c7 44 24 08 eb 2a 80 	movl   $0x802aeb,0x8(%esp)
  80173a:	00 
  80173b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801742:	00 
  801743:	c7 04 24 00 2b 80 00 	movl   $0x802b00,(%esp)
  80174a:	e8 f7 0a 00 00       	call   802246 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80174f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801753:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80175a:	00 
  80175b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175e:	89 04 24             	mov    %eax,(%esp)
  801761:	e8 fe f1 ff ff       	call   800964 <memmove>
	return r;
}
  801766:	89 d8                	mov    %ebx,%eax
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	5b                   	pop    %ebx
  80176c:	5e                   	pop    %esi
  80176d:	5d                   	pop    %ebp
  80176e:	c3                   	ret    

0080176f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	53                   	push   %ebx
  801773:	83 ec 24             	sub    $0x24,%esp
  801776:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801779:	89 1c 24             	mov    %ebx,(%esp)
  80177c:	e8 0f f0 ff ff       	call   800790 <strlen>
  801781:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801786:	7f 60                	jg     8017e8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801788:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178b:	89 04 24             	mov    %eax,(%esp)
  80178e:	e8 c4 f7 ff ff       	call   800f57 <fd_alloc>
  801793:	89 c2                	mov    %eax,%edx
  801795:	85 d2                	test   %edx,%edx
  801797:	78 54                	js     8017ed <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801799:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80179d:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8017a4:	e8 1e f0 ff ff       	call   8007c7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ac:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b9:	e8 55 fd ff ff       	call   801513 <fsipc>
  8017be:	89 c3                	mov    %eax,%ebx
  8017c0:	85 c0                	test   %eax,%eax
  8017c2:	79 17                	jns    8017db <open+0x6c>
		fd_close(fd, 0);
  8017c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8017cb:	00 
  8017cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cf:	89 04 24             	mov    %eax,(%esp)
  8017d2:	e8 7f f8 ff ff       	call   801056 <fd_close>
		return r;
  8017d7:	89 d8                	mov    %ebx,%eax
  8017d9:	eb 12                	jmp    8017ed <open+0x7e>
	}

	return fd2num(fd);
  8017db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017de:	89 04 24             	mov    %eax,(%esp)
  8017e1:	e8 4a f7 ff ff       	call   800f30 <fd2num>
  8017e6:	eb 05                	jmp    8017ed <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8017e8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8017ed:	83 c4 24             	add    $0x24,%esp
  8017f0:	5b                   	pop    %ebx
  8017f1:	5d                   	pop    %ebp
  8017f2:	c3                   	ret    

008017f3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fe:	b8 08 00 00 00       	mov    $0x8,%eax
  801803:	e8 0b fd ff ff       	call   801513 <fsipc>
}
  801808:	c9                   	leave  
  801809:	c3                   	ret    
  80180a:	66 90                	xchg   %ax,%ax
  80180c:	66 90                	xchg   %ax,%ax
  80180e:	66 90                	xchg   %ax,%ax

00801810 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801816:	c7 44 24 04 17 2b 80 	movl   $0x802b17,0x4(%esp)
  80181d:	00 
  80181e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801821:	89 04 24             	mov    %eax,(%esp)
  801824:	e8 9e ef ff ff       	call   8007c7 <strcpy>
	return 0;
}
  801829:	b8 00 00 00 00       	mov    $0x0,%eax
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	53                   	push   %ebx
  801834:	83 ec 14             	sub    $0x14,%esp
  801837:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80183a:	89 1c 24             	mov    %ebx,(%esp)
  80183d:	e8 8d 0b 00 00       	call   8023cf <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801842:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801847:	83 f8 01             	cmp    $0x1,%eax
  80184a:	75 0d                	jne    801859 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80184c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80184f:	89 04 24             	mov    %eax,(%esp)
  801852:	e8 29 03 00 00       	call   801b80 <nsipc_close>
  801857:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801859:	89 d0                	mov    %edx,%eax
  80185b:	83 c4 14             	add    $0x14,%esp
  80185e:	5b                   	pop    %ebx
  80185f:	5d                   	pop    %ebp
  801860:	c3                   	ret    

00801861 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
  801864:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801867:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80186e:	00 
  80186f:	8b 45 10             	mov    0x10(%ebp),%eax
  801872:	89 44 24 08          	mov    %eax,0x8(%esp)
  801876:	8b 45 0c             	mov    0xc(%ebp),%eax
  801879:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187d:	8b 45 08             	mov    0x8(%ebp),%eax
  801880:	8b 40 0c             	mov    0xc(%eax),%eax
  801883:	89 04 24             	mov    %eax,(%esp)
  801886:	e8 f0 03 00 00       	call   801c7b <nsipc_send>
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801893:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80189a:	00 
  80189b:	8b 45 10             	mov    0x10(%ebp),%eax
  80189e:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8018af:	89 04 24             	mov    %eax,(%esp)
  8018b2:	e8 44 03 00 00       	call   801bfb <nsipc_recv>
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018bf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018c2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8018c6:	89 04 24             	mov    %eax,(%esp)
  8018c9:	e8 d8 f6 ff ff       	call   800fa6 <fd_lookup>
  8018ce:	85 c0                	test   %eax,%eax
  8018d0:	78 17                	js     8018e9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8018d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018db:	39 08                	cmp    %ecx,(%eax)
  8018dd:	75 05                	jne    8018e4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8018df:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e2:	eb 05                	jmp    8018e9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8018e4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	56                   	push   %esi
  8018ef:	53                   	push   %ebx
  8018f0:	83 ec 20             	sub    $0x20,%esp
  8018f3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8018f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f8:	89 04 24             	mov    %eax,(%esp)
  8018fb:	e8 57 f6 ff ff       	call   800f57 <fd_alloc>
  801900:	89 c3                	mov    %eax,%ebx
  801902:	85 c0                	test   %eax,%eax
  801904:	78 21                	js     801927 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801906:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80190d:	00 
  80190e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801911:	89 44 24 04          	mov    %eax,0x4(%esp)
  801915:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80191c:	e8 c2 f2 ff ff       	call   800be3 <sys_page_alloc>
  801921:	89 c3                	mov    %eax,%ebx
  801923:	85 c0                	test   %eax,%eax
  801925:	79 0c                	jns    801933 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801927:	89 34 24             	mov    %esi,(%esp)
  80192a:	e8 51 02 00 00       	call   801b80 <nsipc_close>
		return r;
  80192f:	89 d8                	mov    %ebx,%eax
  801931:	eb 20                	jmp    801953 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801933:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80193e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801941:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801948:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80194b:	89 14 24             	mov    %edx,(%esp)
  80194e:	e8 dd f5 ff ff       	call   800f30 <fd2num>
}
  801953:	83 c4 20             	add    $0x20,%esp
  801956:	5b                   	pop    %ebx
  801957:	5e                   	pop    %esi
  801958:	5d                   	pop    %ebp
  801959:	c3                   	ret    

0080195a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	e8 51 ff ff ff       	call   8018b9 <fd2sockid>
		return r;
  801968:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 23                	js     801991 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80196e:	8b 55 10             	mov    0x10(%ebp),%edx
  801971:	89 54 24 08          	mov    %edx,0x8(%esp)
  801975:	8b 55 0c             	mov    0xc(%ebp),%edx
  801978:	89 54 24 04          	mov    %edx,0x4(%esp)
  80197c:	89 04 24             	mov    %eax,(%esp)
  80197f:	e8 45 01 00 00       	call   801ac9 <nsipc_accept>
		return r;
  801984:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801986:	85 c0                	test   %eax,%eax
  801988:	78 07                	js     801991 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80198a:	e8 5c ff ff ff       	call   8018eb <alloc_sockfd>
  80198f:	89 c1                	mov    %eax,%ecx
}
  801991:	89 c8                	mov    %ecx,%eax
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	e8 16 ff ff ff       	call   8018b9 <fd2sockid>
  8019a3:	89 c2                	mov    %eax,%edx
  8019a5:	85 d2                	test   %edx,%edx
  8019a7:	78 16                	js     8019bf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8019a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b7:	89 14 24             	mov    %edx,(%esp)
  8019ba:	e8 60 01 00 00       	call   801b1f <nsipc_bind>
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <shutdown>:

int
shutdown(int s, int how)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	e8 ea fe ff ff       	call   8018b9 <fd2sockid>
  8019cf:	89 c2                	mov    %eax,%edx
  8019d1:	85 d2                	test   %edx,%edx
  8019d3:	78 0f                	js     8019e4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8019d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019dc:	89 14 24             	mov    %edx,(%esp)
  8019df:	e8 7a 01 00 00       	call   801b5e <nsipc_shutdown>
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	e8 c5 fe ff ff       	call   8018b9 <fd2sockid>
  8019f4:	89 c2                	mov    %eax,%edx
  8019f6:	85 d2                	test   %edx,%edx
  8019f8:	78 16                	js     801a10 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8019fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a08:	89 14 24             	mov    %edx,(%esp)
  801a0b:	e8 8a 01 00 00       	call   801b9a <nsipc_connect>
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <listen>:

int
listen(int s, int backlog)
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	e8 99 fe ff ff       	call   8018b9 <fd2sockid>
  801a20:	89 c2                	mov    %eax,%edx
  801a22:	85 d2                	test   %edx,%edx
  801a24:	78 0f                	js     801a35 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2d:	89 14 24             	mov    %edx,(%esp)
  801a30:	e8 a4 01 00 00       	call   801bd9 <nsipc_listen>
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a40:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	89 04 24             	mov    %eax,(%esp)
  801a51:	e8 98 02 00 00       	call   801cee <nsipc_socket>
  801a56:	89 c2                	mov    %eax,%edx
  801a58:	85 d2                	test   %edx,%edx
  801a5a:	78 05                	js     801a61 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801a5c:	e8 8a fe ff ff       	call   8018eb <alloc_sockfd>
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	53                   	push   %ebx
  801a67:	83 ec 14             	sub    $0x14,%esp
  801a6a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a6c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a73:	75 11                	jne    801a86 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a75:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801a7c:	e8 14 09 00 00       	call   802395 <ipc_find_env>
  801a81:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a86:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a8d:	00 
  801a8e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a95:	00 
  801a96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a9a:	a1 04 40 80 00       	mov    0x804004,%eax
  801a9f:	89 04 24             	mov    %eax,(%esp)
  801aa2:	e8 61 08 00 00       	call   802308 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801aa7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801aae:	00 
  801aaf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ab6:	00 
  801ab7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801abe:	e8 dd 07 00 00       	call   8022a0 <ipc_recv>
}
  801ac3:	83 c4 14             	add    $0x14,%esp
  801ac6:	5b                   	pop    %ebx
  801ac7:	5d                   	pop    %ebp
  801ac8:	c3                   	ret    

00801ac9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	56                   	push   %esi
  801acd:	53                   	push   %ebx
  801ace:	83 ec 10             	sub    $0x10,%esp
  801ad1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801adc:	8b 06                	mov    (%esi),%eax
  801ade:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ae3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae8:	e8 76 ff ff ff       	call   801a63 <nsipc>
  801aed:	89 c3                	mov    %eax,%ebx
  801aef:	85 c0                	test   %eax,%eax
  801af1:	78 23                	js     801b16 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801af3:	a1 10 60 80 00       	mov    0x806010,%eax
  801af8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801afc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b03:	00 
  801b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b07:	89 04 24             	mov    %eax,(%esp)
  801b0a:	e8 55 ee ff ff       	call   800964 <memmove>
		*addrlen = ret->ret_addrlen;
  801b0f:	a1 10 60 80 00       	mov    0x806010,%eax
  801b14:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801b16:	89 d8                	mov    %ebx,%eax
  801b18:	83 c4 10             	add    $0x10,%esp
  801b1b:	5b                   	pop    %ebx
  801b1c:	5e                   	pop    %esi
  801b1d:	5d                   	pop    %ebp
  801b1e:	c3                   	ret    

00801b1f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	53                   	push   %ebx
  801b23:	83 ec 14             	sub    $0x14,%esp
  801b26:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b31:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b3c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801b43:	e8 1c ee ff ff       	call   800964 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b48:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b4e:	b8 02 00 00 00       	mov    $0x2,%eax
  801b53:	e8 0b ff ff ff       	call   801a63 <nsipc>
}
  801b58:	83 c4 14             	add    $0x14,%esp
  801b5b:	5b                   	pop    %ebx
  801b5c:	5d                   	pop    %ebp
  801b5d:	c3                   	ret    

00801b5e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b74:	b8 03 00 00 00       	mov    $0x3,%eax
  801b79:	e8 e5 fe ff ff       	call   801a63 <nsipc>
}
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <nsipc_close>:

int
nsipc_close(int s)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b8e:	b8 04 00 00 00       	mov    $0x4,%eax
  801b93:	e8 cb fe ff ff       	call   801a63 <nsipc>
}
  801b98:	c9                   	leave  
  801b99:	c3                   	ret    

00801b9a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b9a:	55                   	push   %ebp
  801b9b:	89 e5                	mov    %esp,%ebp
  801b9d:	53                   	push   %ebx
  801b9e:	83 ec 14             	sub    $0x14,%esp
  801ba1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801bbe:	e8 a1 ed ff ff       	call   800964 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bc3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bc9:	b8 05 00 00 00       	mov    $0x5,%eax
  801bce:	e8 90 fe ff ff       	call   801a63 <nsipc>
}
  801bd3:	83 c4 14             	add    $0x14,%esp
  801bd6:	5b                   	pop    %ebx
  801bd7:	5d                   	pop    %ebp
  801bd8:	c3                   	ret    

00801bd9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bea:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bef:	b8 06 00 00 00       	mov    $0x6,%eax
  801bf4:	e8 6a fe ff ff       	call   801a63 <nsipc>
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	56                   	push   %esi
  801bff:	53                   	push   %ebx
  801c00:	83 ec 10             	sub    $0x10,%esp
  801c03:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c0e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c14:	8b 45 14             	mov    0x14(%ebp),%eax
  801c17:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c1c:	b8 07 00 00 00       	mov    $0x7,%eax
  801c21:	e8 3d fe ff ff       	call   801a63 <nsipc>
  801c26:	89 c3                	mov    %eax,%ebx
  801c28:	85 c0                	test   %eax,%eax
  801c2a:	78 46                	js     801c72 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801c2c:	39 f0                	cmp    %esi,%eax
  801c2e:	7f 07                	jg     801c37 <nsipc_recv+0x3c>
  801c30:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c35:	7e 24                	jle    801c5b <nsipc_recv+0x60>
  801c37:	c7 44 24 0c 23 2b 80 	movl   $0x802b23,0xc(%esp)
  801c3e:	00 
  801c3f:	c7 44 24 08 eb 2a 80 	movl   $0x802aeb,0x8(%esp)
  801c46:	00 
  801c47:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801c4e:	00 
  801c4f:	c7 04 24 38 2b 80 00 	movl   $0x802b38,(%esp)
  801c56:	e8 eb 05 00 00       	call   802246 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c5b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c5f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c66:	00 
  801c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6a:	89 04 24             	mov    %eax,(%esp)
  801c6d:	e8 f2 ec ff ff       	call   800964 <memmove>
	}

	return r;
}
  801c72:	89 d8                	mov    %ebx,%eax
  801c74:	83 c4 10             	add    $0x10,%esp
  801c77:	5b                   	pop    %ebx
  801c78:	5e                   	pop    %esi
  801c79:	5d                   	pop    %ebp
  801c7a:	c3                   	ret    

00801c7b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	53                   	push   %ebx
  801c7f:	83 ec 14             	sub    $0x14,%esp
  801c82:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c8d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c93:	7e 24                	jle    801cb9 <nsipc_send+0x3e>
  801c95:	c7 44 24 0c 44 2b 80 	movl   $0x802b44,0xc(%esp)
  801c9c:	00 
  801c9d:	c7 44 24 08 eb 2a 80 	movl   $0x802aeb,0x8(%esp)
  801ca4:	00 
  801ca5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801cac:	00 
  801cad:	c7 04 24 38 2b 80 00 	movl   $0x802b38,(%esp)
  801cb4:	e8 8d 05 00 00       	call   802246 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cb9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801ccb:	e8 94 ec ff ff       	call   800964 <memmove>
	nsipcbuf.send.req_size = size;
  801cd0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  801cd9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801cde:	b8 08 00 00 00       	mov    $0x8,%eax
  801ce3:	e8 7b fd ff ff       	call   801a63 <nsipc>
}
  801ce8:	83 c4 14             	add    $0x14,%esp
  801ceb:	5b                   	pop    %ebx
  801cec:	5d                   	pop    %ebp
  801ced:	c3                   	ret    

00801cee <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cff:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d04:	8b 45 10             	mov    0x10(%ebp),%eax
  801d07:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d0c:	b8 09 00 00 00       	mov    $0x9,%eax
  801d11:	e8 4d fd ff ff       	call   801a63 <nsipc>
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	56                   	push   %esi
  801d1c:	53                   	push   %ebx
  801d1d:	83 ec 10             	sub    $0x10,%esp
  801d20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	89 04 24             	mov    %eax,(%esp)
  801d29:	e8 12 f2 ff ff       	call   800f40 <fd2data>
  801d2e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d30:	c7 44 24 04 50 2b 80 	movl   $0x802b50,0x4(%esp)
  801d37:	00 
  801d38:	89 1c 24             	mov    %ebx,(%esp)
  801d3b:	e8 87 ea ff ff       	call   8007c7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d40:	8b 46 04             	mov    0x4(%esi),%eax
  801d43:	2b 06                	sub    (%esi),%eax
  801d45:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d4b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d52:	00 00 00 
	stat->st_dev = &devpipe;
  801d55:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d5c:	30 80 00 
	return 0;
}
  801d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d64:	83 c4 10             	add    $0x10,%esp
  801d67:	5b                   	pop    %ebx
  801d68:	5e                   	pop    %esi
  801d69:	5d                   	pop    %ebp
  801d6a:	c3                   	ret    

00801d6b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	53                   	push   %ebx
  801d6f:	83 ec 14             	sub    $0x14,%esp
  801d72:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d75:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d79:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d80:	e8 05 ef ff ff       	call   800c8a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d85:	89 1c 24             	mov    %ebx,(%esp)
  801d88:	e8 b3 f1 ff ff       	call   800f40 <fd2data>
  801d8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d98:	e8 ed ee ff ff       	call   800c8a <sys_page_unmap>
}
  801d9d:	83 c4 14             	add    $0x14,%esp
  801da0:	5b                   	pop    %ebx
  801da1:	5d                   	pop    %ebp
  801da2:	c3                   	ret    

00801da3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	57                   	push   %edi
  801da7:	56                   	push   %esi
  801da8:	53                   	push   %ebx
  801da9:	83 ec 2c             	sub    $0x2c,%esp
  801dac:	89 c6                	mov    %eax,%esi
  801dae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801db1:	a1 08 40 80 00       	mov    0x804008,%eax
  801db6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801db9:	89 34 24             	mov    %esi,(%esp)
  801dbc:	e8 0e 06 00 00       	call   8023cf <pageref>
  801dc1:	89 c7                	mov    %eax,%edi
  801dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dc6:	89 04 24             	mov    %eax,(%esp)
  801dc9:	e8 01 06 00 00       	call   8023cf <pageref>
  801dce:	39 c7                	cmp    %eax,%edi
  801dd0:	0f 94 c2             	sete   %dl
  801dd3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801dd6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801ddc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801ddf:	39 fb                	cmp    %edi,%ebx
  801de1:	74 21                	je     801e04 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801de3:	84 d2                	test   %dl,%dl
  801de5:	74 ca                	je     801db1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801de7:	8b 51 58             	mov    0x58(%ecx),%edx
  801dea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dee:	89 54 24 08          	mov    %edx,0x8(%esp)
  801df2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801df6:	c7 04 24 57 2b 80 00 	movl   $0x802b57,(%esp)
  801dfd:	e8 a0 e3 ff ff       	call   8001a2 <cprintf>
  801e02:	eb ad                	jmp    801db1 <_pipeisclosed+0xe>
	}
}
  801e04:	83 c4 2c             	add    $0x2c,%esp
  801e07:	5b                   	pop    %ebx
  801e08:	5e                   	pop    %esi
  801e09:	5f                   	pop    %edi
  801e0a:	5d                   	pop    %ebp
  801e0b:	c3                   	ret    

00801e0c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	57                   	push   %edi
  801e10:	56                   	push   %esi
  801e11:	53                   	push   %ebx
  801e12:	83 ec 1c             	sub    $0x1c,%esp
  801e15:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e18:	89 34 24             	mov    %esi,(%esp)
  801e1b:	e8 20 f1 ff ff       	call   800f40 <fd2data>
  801e20:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e22:	bf 00 00 00 00       	mov    $0x0,%edi
  801e27:	eb 45                	jmp    801e6e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e29:	89 da                	mov    %ebx,%edx
  801e2b:	89 f0                	mov    %esi,%eax
  801e2d:	e8 71 ff ff ff       	call   801da3 <_pipeisclosed>
  801e32:	85 c0                	test   %eax,%eax
  801e34:	75 41                	jne    801e77 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e36:	e8 89 ed ff ff       	call   800bc4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e3b:	8b 43 04             	mov    0x4(%ebx),%eax
  801e3e:	8b 0b                	mov    (%ebx),%ecx
  801e40:	8d 51 20             	lea    0x20(%ecx),%edx
  801e43:	39 d0                	cmp    %edx,%eax
  801e45:	73 e2                	jae    801e29 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e4a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e4e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e51:	99                   	cltd   
  801e52:	c1 ea 1b             	shr    $0x1b,%edx
  801e55:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801e58:	83 e1 1f             	and    $0x1f,%ecx
  801e5b:	29 d1                	sub    %edx,%ecx
  801e5d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801e61:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801e65:	83 c0 01             	add    $0x1,%eax
  801e68:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e6b:	83 c7 01             	add    $0x1,%edi
  801e6e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e71:	75 c8                	jne    801e3b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801e73:	89 f8                	mov    %edi,%eax
  801e75:	eb 05                	jmp    801e7c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801e7c:	83 c4 1c             	add    $0x1c,%esp
  801e7f:	5b                   	pop    %ebx
  801e80:	5e                   	pop    %esi
  801e81:	5f                   	pop    %edi
  801e82:	5d                   	pop    %ebp
  801e83:	c3                   	ret    

00801e84 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	57                   	push   %edi
  801e88:	56                   	push   %esi
  801e89:	53                   	push   %ebx
  801e8a:	83 ec 1c             	sub    $0x1c,%esp
  801e8d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801e90:	89 3c 24             	mov    %edi,(%esp)
  801e93:	e8 a8 f0 ff ff       	call   800f40 <fd2data>
  801e98:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e9a:	be 00 00 00 00       	mov    $0x0,%esi
  801e9f:	eb 3d                	jmp    801ede <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801ea1:	85 f6                	test   %esi,%esi
  801ea3:	74 04                	je     801ea9 <devpipe_read+0x25>
				return i;
  801ea5:	89 f0                	mov    %esi,%eax
  801ea7:	eb 43                	jmp    801eec <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ea9:	89 da                	mov    %ebx,%edx
  801eab:	89 f8                	mov    %edi,%eax
  801ead:	e8 f1 fe ff ff       	call   801da3 <_pipeisclosed>
  801eb2:	85 c0                	test   %eax,%eax
  801eb4:	75 31                	jne    801ee7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801eb6:	e8 09 ed ff ff       	call   800bc4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801ebb:	8b 03                	mov    (%ebx),%eax
  801ebd:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ec0:	74 df                	je     801ea1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ec2:	99                   	cltd   
  801ec3:	c1 ea 1b             	shr    $0x1b,%edx
  801ec6:	01 d0                	add    %edx,%eax
  801ec8:	83 e0 1f             	and    $0x1f,%eax
  801ecb:	29 d0                	sub    %edx,%eax
  801ecd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ed2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ed5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ed8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801edb:	83 c6 01             	add    $0x1,%esi
  801ede:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ee1:	75 d8                	jne    801ebb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801ee3:	89 f0                	mov    %esi,%eax
  801ee5:	eb 05                	jmp    801eec <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801ee7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801eec:	83 c4 1c             	add    $0x1c,%esp
  801eef:	5b                   	pop    %ebx
  801ef0:	5e                   	pop    %esi
  801ef1:	5f                   	pop    %edi
  801ef2:	5d                   	pop    %ebp
  801ef3:	c3                   	ret    

00801ef4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
  801ef7:	56                   	push   %esi
  801ef8:	53                   	push   %ebx
  801ef9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801efc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eff:	89 04 24             	mov    %eax,(%esp)
  801f02:	e8 50 f0 ff ff       	call   800f57 <fd_alloc>
  801f07:	89 c2                	mov    %eax,%edx
  801f09:	85 d2                	test   %edx,%edx
  801f0b:	0f 88 4d 01 00 00    	js     80205e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f11:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f18:	00 
  801f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f27:	e8 b7 ec ff ff       	call   800be3 <sys_page_alloc>
  801f2c:	89 c2                	mov    %eax,%edx
  801f2e:	85 d2                	test   %edx,%edx
  801f30:	0f 88 28 01 00 00    	js     80205e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f36:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f39:	89 04 24             	mov    %eax,(%esp)
  801f3c:	e8 16 f0 ff ff       	call   800f57 <fd_alloc>
  801f41:	89 c3                	mov    %eax,%ebx
  801f43:	85 c0                	test   %eax,%eax
  801f45:	0f 88 fe 00 00 00    	js     802049 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f4b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f52:	00 
  801f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f56:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f61:	e8 7d ec ff ff       	call   800be3 <sys_page_alloc>
  801f66:	89 c3                	mov    %eax,%ebx
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	0f 88 d9 00 00 00    	js     802049 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f73:	89 04 24             	mov    %eax,(%esp)
  801f76:	e8 c5 ef ff ff       	call   800f40 <fd2data>
  801f7b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f7d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f84:	00 
  801f85:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f90:	e8 4e ec ff ff       	call   800be3 <sys_page_alloc>
  801f95:	89 c3                	mov    %eax,%ebx
  801f97:	85 c0                	test   %eax,%eax
  801f99:	0f 88 97 00 00 00    	js     802036 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa2:	89 04 24             	mov    %eax,(%esp)
  801fa5:	e8 96 ef ff ff       	call   800f40 <fd2data>
  801faa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801fb1:	00 
  801fb2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fb6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fbd:	00 
  801fbe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fc9:	e8 69 ec ff ff       	call   800c37 <sys_page_map>
  801fce:	89 c3                	mov    %eax,%ebx
  801fd0:	85 c0                	test   %eax,%eax
  801fd2:	78 52                	js     802026 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801fd4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801fe9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802001:	89 04 24             	mov    %eax,(%esp)
  802004:	e8 27 ef ff ff       	call   800f30 <fd2num>
  802009:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80200c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80200e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802011:	89 04 24             	mov    %eax,(%esp)
  802014:	e8 17 ef ff ff       	call   800f30 <fd2num>
  802019:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80201c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80201f:	b8 00 00 00 00       	mov    $0x0,%eax
  802024:	eb 38                	jmp    80205e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802026:	89 74 24 04          	mov    %esi,0x4(%esp)
  80202a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802031:	e8 54 ec ff ff       	call   800c8a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802036:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80203d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802044:	e8 41 ec ff ff       	call   800c8a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802050:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802057:	e8 2e ec ff ff       	call   800c8a <sys_page_unmap>
  80205c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80205e:	83 c4 30             	add    $0x30,%esp
  802061:	5b                   	pop    %ebx
  802062:	5e                   	pop    %esi
  802063:	5d                   	pop    %ebp
  802064:	c3                   	ret    

00802065 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80206b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80206e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802072:	8b 45 08             	mov    0x8(%ebp),%eax
  802075:	89 04 24             	mov    %eax,(%esp)
  802078:	e8 29 ef ff ff       	call   800fa6 <fd_lookup>
  80207d:	89 c2                	mov    %eax,%edx
  80207f:	85 d2                	test   %edx,%edx
  802081:	78 15                	js     802098 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802086:	89 04 24             	mov    %eax,(%esp)
  802089:	e8 b2 ee ff ff       	call   800f40 <fd2data>
	return _pipeisclosed(fd, p);
  80208e:	89 c2                	mov    %eax,%edx
  802090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802093:	e8 0b fd ff ff       	call   801da3 <_pipeisclosed>
}
  802098:	c9                   	leave  
  802099:	c3                   	ret    
  80209a:	66 90                	xchg   %ax,%ax
  80209c:	66 90                	xchg   %ax,%ax
  80209e:	66 90                	xchg   %ax,%ax

008020a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8020a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a8:	5d                   	pop    %ebp
  8020a9:	c3                   	ret    

008020aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8020b0:	c7 44 24 04 6f 2b 80 	movl   $0x802b6f,0x4(%esp)
  8020b7:	00 
  8020b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020bb:	89 04 24             	mov    %eax,(%esp)
  8020be:	e8 04 e7 ff ff       	call   8007c7 <strcpy>
	return 0;
}
  8020c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	57                   	push   %edi
  8020ce:	56                   	push   %esi
  8020cf:	53                   	push   %ebx
  8020d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8020db:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020e1:	eb 31                	jmp    802114 <devcons_write+0x4a>
		m = n - tot;
  8020e3:	8b 75 10             	mov    0x10(%ebp),%esi
  8020e6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8020e8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8020eb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8020f0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8020f3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8020f7:	03 45 0c             	add    0xc(%ebp),%eax
  8020fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fe:	89 3c 24             	mov    %edi,(%esp)
  802101:	e8 5e e8 ff ff       	call   800964 <memmove>
		sys_cputs(buf, m);
  802106:	89 74 24 04          	mov    %esi,0x4(%esp)
  80210a:	89 3c 24             	mov    %edi,(%esp)
  80210d:	e8 04 ea ff ff       	call   800b16 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802112:	01 f3                	add    %esi,%ebx
  802114:	89 d8                	mov    %ebx,%eax
  802116:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802119:	72 c8                	jb     8020e3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80211b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802121:	5b                   	pop    %ebx
  802122:	5e                   	pop    %esi
  802123:	5f                   	pop    %edi
  802124:	5d                   	pop    %ebp
  802125:	c3                   	ret    

00802126 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80212c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802131:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802135:	75 07                	jne    80213e <devcons_read+0x18>
  802137:	eb 2a                	jmp    802163 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802139:	e8 86 ea ff ff       	call   800bc4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80213e:	66 90                	xchg   %ax,%ax
  802140:	e8 ef e9 ff ff       	call   800b34 <sys_cgetc>
  802145:	85 c0                	test   %eax,%eax
  802147:	74 f0                	je     802139 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802149:	85 c0                	test   %eax,%eax
  80214b:	78 16                	js     802163 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80214d:	83 f8 04             	cmp    $0x4,%eax
  802150:	74 0c                	je     80215e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802152:	8b 55 0c             	mov    0xc(%ebp),%edx
  802155:	88 02                	mov    %al,(%edx)
	return 1;
  802157:	b8 01 00 00 00       	mov    $0x1,%eax
  80215c:	eb 05                	jmp    802163 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80215e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
  802168:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802171:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802178:	00 
  802179:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80217c:	89 04 24             	mov    %eax,(%esp)
  80217f:	e8 92 e9 ff ff       	call   800b16 <sys_cputs>
}
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <getchar>:

int
getchar(void)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80218c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802193:	00 
  802194:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802197:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a2:	e8 93 f0 ff ff       	call   80123a <read>
	if (r < 0)
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	78 0f                	js     8021ba <getchar+0x34>
		return r;
	if (r < 1)
  8021ab:	85 c0                	test   %eax,%eax
  8021ad:	7e 06                	jle    8021b5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8021af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8021b3:	eb 05                	jmp    8021ba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8021b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	89 04 24             	mov    %eax,(%esp)
  8021cf:	e8 d2 ed ff ff       	call   800fa6 <fd_lookup>
  8021d4:	85 c0                	test   %eax,%eax
  8021d6:	78 11                	js     8021e9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8021d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021db:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021e1:	39 10                	cmp    %edx,(%eax)
  8021e3:	0f 94 c0             	sete   %al
  8021e6:	0f b6 c0             	movzbl %al,%eax
}
  8021e9:	c9                   	leave  
  8021ea:	c3                   	ret    

008021eb <opencons>:

int
opencons(void)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8021f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f4:	89 04 24             	mov    %eax,(%esp)
  8021f7:	e8 5b ed ff ff       	call   800f57 <fd_alloc>
		return r;
  8021fc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8021fe:	85 c0                	test   %eax,%eax
  802200:	78 40                	js     802242 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802202:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802209:	00 
  80220a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802211:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802218:	e8 c6 e9 ff ff       	call   800be3 <sys_page_alloc>
		return r;
  80221d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80221f:	85 c0                	test   %eax,%eax
  802221:	78 1f                	js     802242 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802223:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802238:	89 04 24             	mov    %eax,(%esp)
  80223b:	e8 f0 ec ff ff       	call   800f30 <fd2num>
  802240:	89 c2                	mov    %eax,%edx
}
  802242:	89 d0                	mov    %edx,%eax
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	56                   	push   %esi
  80224a:	53                   	push   %ebx
  80224b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80224e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802251:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802257:	e8 49 e9 ff ff       	call   800ba5 <sys_getenvid>
  80225c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802263:	8b 55 08             	mov    0x8(%ebp),%edx
  802266:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80226a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80226e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802272:	c7 04 24 7c 2b 80 00 	movl   $0x802b7c,(%esp)
  802279:	e8 24 df ff ff       	call   8001a2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80227e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802282:	8b 45 10             	mov    0x10(%ebp),%eax
  802285:	89 04 24             	mov    %eax,(%esp)
  802288:	e8 b4 de ff ff       	call   800141 <vcprintf>
	cprintf("\n");
  80228d:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  802294:	e8 09 df ff ff       	call   8001a2 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802299:	cc                   	int3   
  80229a:	eb fd                	jmp    802299 <_panic+0x53>
  80229c:	66 90                	xchg   %ax,%ax
  80229e:	66 90                	xchg   %ax,%ax

008022a0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
  8022a3:	56                   	push   %esi
  8022a4:	53                   	push   %ebx
  8022a5:	83 ec 10             	sub    $0x10,%esp
  8022a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8022ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8022b1:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  8022b3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8022b8:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  8022bb:	89 04 24             	mov    %eax,(%esp)
  8022be:	e8 36 eb ff ff       	call   800df9 <sys_ipc_recv>
  8022c3:	85 c0                	test   %eax,%eax
  8022c5:	74 16                	je     8022dd <ipc_recv+0x3d>
		if (from_env_store != NULL)
  8022c7:	85 f6                	test   %esi,%esi
  8022c9:	74 06                	je     8022d1 <ipc_recv+0x31>
			*from_env_store = 0;
  8022cb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8022d1:	85 db                	test   %ebx,%ebx
  8022d3:	74 2c                	je     802301 <ipc_recv+0x61>
			*perm_store = 0;
  8022d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022db:	eb 24                	jmp    802301 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8022dd:	85 f6                	test   %esi,%esi
  8022df:	74 0a                	je     8022eb <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8022e1:	a1 08 40 80 00       	mov    0x804008,%eax
  8022e6:	8b 40 74             	mov    0x74(%eax),%eax
  8022e9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8022eb:	85 db                	test   %ebx,%ebx
  8022ed:	74 0a                	je     8022f9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8022ef:	a1 08 40 80 00       	mov    0x804008,%eax
  8022f4:	8b 40 78             	mov    0x78(%eax),%eax
  8022f7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8022f9:	a1 08 40 80 00       	mov    0x804008,%eax
  8022fe:	8b 40 70             	mov    0x70(%eax),%eax
}
  802301:	83 c4 10             	add    $0x10,%esp
  802304:	5b                   	pop    %ebx
  802305:	5e                   	pop    %esi
  802306:	5d                   	pop    %ebp
  802307:	c3                   	ret    

00802308 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
  80230b:	57                   	push   %edi
  80230c:	56                   	push   %esi
  80230d:	53                   	push   %ebx
  80230e:	83 ec 1c             	sub    $0x1c,%esp
  802311:	8b 75 0c             	mov    0xc(%ebp),%esi
  802314:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802317:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80231a:	85 db                	test   %ebx,%ebx
  80231c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802321:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802324:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802328:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80232c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	89 04 24             	mov    %eax,(%esp)
  802336:	e8 9b ea ff ff       	call   800dd6 <sys_ipc_try_send>
	if (r == 0) return;
  80233b:	85 c0                	test   %eax,%eax
  80233d:	75 22                	jne    802361 <ipc_send+0x59>
  80233f:	eb 4c                	jmp    80238d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802341:	84 d2                	test   %dl,%dl
  802343:	75 48                	jne    80238d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802345:	e8 7a e8 ff ff       	call   800bc4 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80234a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80234e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802352:	89 74 24 04          	mov    %esi,0x4(%esp)
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	89 04 24             	mov    %eax,(%esp)
  80235c:	e8 75 ea ff ff       	call   800dd6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802361:	85 c0                	test   %eax,%eax
  802363:	0f 94 c2             	sete   %dl
  802366:	74 d9                	je     802341 <ipc_send+0x39>
  802368:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80236b:	74 d4                	je     802341 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80236d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802371:	c7 44 24 08 a0 2b 80 	movl   $0x802ba0,0x8(%esp)
  802378:	00 
  802379:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802380:	00 
  802381:	c7 04 24 ae 2b 80 00 	movl   $0x802bae,(%esp)
  802388:	e8 b9 fe ff ff       	call   802246 <_panic>
}
  80238d:	83 c4 1c             	add    $0x1c,%esp
  802390:	5b                   	pop    %ebx
  802391:	5e                   	pop    %esi
  802392:	5f                   	pop    %edi
  802393:	5d                   	pop    %ebp
  802394:	c3                   	ret    

00802395 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80239b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8023a0:	89 c2                	mov    %eax,%edx
  8023a2:	c1 e2 07             	shl    $0x7,%edx
  8023a5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023ab:	8b 52 50             	mov    0x50(%edx),%edx
  8023ae:	39 ca                	cmp    %ecx,%edx
  8023b0:	75 0d                	jne    8023bf <ipc_find_env+0x2a>
			return envs[i].env_id;
  8023b2:	c1 e0 07             	shl    $0x7,%eax
  8023b5:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8023ba:	8b 40 40             	mov    0x40(%eax),%eax
  8023bd:	eb 0e                	jmp    8023cd <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023bf:	83 c0 01             	add    $0x1,%eax
  8023c2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023c7:	75 d7                	jne    8023a0 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023c9:	66 b8 00 00          	mov    $0x0,%ax
}
  8023cd:	5d                   	pop    %ebp
  8023ce:	c3                   	ret    

008023cf <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023cf:	55                   	push   %ebp
  8023d0:	89 e5                	mov    %esp,%ebp
  8023d2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023d5:	89 d0                	mov    %edx,%eax
  8023d7:	c1 e8 16             	shr    $0x16,%eax
  8023da:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023e1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023e6:	f6 c1 01             	test   $0x1,%cl
  8023e9:	74 1d                	je     802408 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023eb:	c1 ea 0c             	shr    $0xc,%edx
  8023ee:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023f5:	f6 c2 01             	test   $0x1,%dl
  8023f8:	74 0e                	je     802408 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023fa:	c1 ea 0c             	shr    $0xc,%edx
  8023fd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802404:	ef 
  802405:	0f b7 c0             	movzwl %ax,%eax
}
  802408:	5d                   	pop    %ebp
  802409:	c3                   	ret    
  80240a:	66 90                	xchg   %ax,%ax
  80240c:	66 90                	xchg   %ax,%ax
  80240e:	66 90                	xchg   %ax,%ax

00802410 <__udivdi3>:
  802410:	55                   	push   %ebp
  802411:	57                   	push   %edi
  802412:	56                   	push   %esi
  802413:	83 ec 0c             	sub    $0xc,%esp
  802416:	8b 44 24 28          	mov    0x28(%esp),%eax
  80241a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80241e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802422:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802426:	85 c0                	test   %eax,%eax
  802428:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80242c:	89 ea                	mov    %ebp,%edx
  80242e:	89 0c 24             	mov    %ecx,(%esp)
  802431:	75 2d                	jne    802460 <__udivdi3+0x50>
  802433:	39 e9                	cmp    %ebp,%ecx
  802435:	77 61                	ja     802498 <__udivdi3+0x88>
  802437:	85 c9                	test   %ecx,%ecx
  802439:	89 ce                	mov    %ecx,%esi
  80243b:	75 0b                	jne    802448 <__udivdi3+0x38>
  80243d:	b8 01 00 00 00       	mov    $0x1,%eax
  802442:	31 d2                	xor    %edx,%edx
  802444:	f7 f1                	div    %ecx
  802446:	89 c6                	mov    %eax,%esi
  802448:	31 d2                	xor    %edx,%edx
  80244a:	89 e8                	mov    %ebp,%eax
  80244c:	f7 f6                	div    %esi
  80244e:	89 c5                	mov    %eax,%ebp
  802450:	89 f8                	mov    %edi,%eax
  802452:	f7 f6                	div    %esi
  802454:	89 ea                	mov    %ebp,%edx
  802456:	83 c4 0c             	add    $0xc,%esp
  802459:	5e                   	pop    %esi
  80245a:	5f                   	pop    %edi
  80245b:	5d                   	pop    %ebp
  80245c:	c3                   	ret    
  80245d:	8d 76 00             	lea    0x0(%esi),%esi
  802460:	39 e8                	cmp    %ebp,%eax
  802462:	77 24                	ja     802488 <__udivdi3+0x78>
  802464:	0f bd e8             	bsr    %eax,%ebp
  802467:	83 f5 1f             	xor    $0x1f,%ebp
  80246a:	75 3c                	jne    8024a8 <__udivdi3+0x98>
  80246c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802470:	39 34 24             	cmp    %esi,(%esp)
  802473:	0f 86 9f 00 00 00    	jbe    802518 <__udivdi3+0x108>
  802479:	39 d0                	cmp    %edx,%eax
  80247b:	0f 82 97 00 00 00    	jb     802518 <__udivdi3+0x108>
  802481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802488:	31 d2                	xor    %edx,%edx
  80248a:	31 c0                	xor    %eax,%eax
  80248c:	83 c4 0c             	add    $0xc,%esp
  80248f:	5e                   	pop    %esi
  802490:	5f                   	pop    %edi
  802491:	5d                   	pop    %ebp
  802492:	c3                   	ret    
  802493:	90                   	nop
  802494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802498:	89 f8                	mov    %edi,%eax
  80249a:	f7 f1                	div    %ecx
  80249c:	31 d2                	xor    %edx,%edx
  80249e:	83 c4 0c             	add    $0xc,%esp
  8024a1:	5e                   	pop    %esi
  8024a2:	5f                   	pop    %edi
  8024a3:	5d                   	pop    %ebp
  8024a4:	c3                   	ret    
  8024a5:	8d 76 00             	lea    0x0(%esi),%esi
  8024a8:	89 e9                	mov    %ebp,%ecx
  8024aa:	8b 3c 24             	mov    (%esp),%edi
  8024ad:	d3 e0                	shl    %cl,%eax
  8024af:	89 c6                	mov    %eax,%esi
  8024b1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024b6:	29 e8                	sub    %ebp,%eax
  8024b8:	89 c1                	mov    %eax,%ecx
  8024ba:	d3 ef                	shr    %cl,%edi
  8024bc:	89 e9                	mov    %ebp,%ecx
  8024be:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024c2:	8b 3c 24             	mov    (%esp),%edi
  8024c5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024c9:	89 d6                	mov    %edx,%esi
  8024cb:	d3 e7                	shl    %cl,%edi
  8024cd:	89 c1                	mov    %eax,%ecx
  8024cf:	89 3c 24             	mov    %edi,(%esp)
  8024d2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024d6:	d3 ee                	shr    %cl,%esi
  8024d8:	89 e9                	mov    %ebp,%ecx
  8024da:	d3 e2                	shl    %cl,%edx
  8024dc:	89 c1                	mov    %eax,%ecx
  8024de:	d3 ef                	shr    %cl,%edi
  8024e0:	09 d7                	or     %edx,%edi
  8024e2:	89 f2                	mov    %esi,%edx
  8024e4:	89 f8                	mov    %edi,%eax
  8024e6:	f7 74 24 08          	divl   0x8(%esp)
  8024ea:	89 d6                	mov    %edx,%esi
  8024ec:	89 c7                	mov    %eax,%edi
  8024ee:	f7 24 24             	mull   (%esp)
  8024f1:	39 d6                	cmp    %edx,%esi
  8024f3:	89 14 24             	mov    %edx,(%esp)
  8024f6:	72 30                	jb     802528 <__udivdi3+0x118>
  8024f8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024fc:	89 e9                	mov    %ebp,%ecx
  8024fe:	d3 e2                	shl    %cl,%edx
  802500:	39 c2                	cmp    %eax,%edx
  802502:	73 05                	jae    802509 <__udivdi3+0xf9>
  802504:	3b 34 24             	cmp    (%esp),%esi
  802507:	74 1f                	je     802528 <__udivdi3+0x118>
  802509:	89 f8                	mov    %edi,%eax
  80250b:	31 d2                	xor    %edx,%edx
  80250d:	e9 7a ff ff ff       	jmp    80248c <__udivdi3+0x7c>
  802512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802518:	31 d2                	xor    %edx,%edx
  80251a:	b8 01 00 00 00       	mov    $0x1,%eax
  80251f:	e9 68 ff ff ff       	jmp    80248c <__udivdi3+0x7c>
  802524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802528:	8d 47 ff             	lea    -0x1(%edi),%eax
  80252b:	31 d2                	xor    %edx,%edx
  80252d:	83 c4 0c             	add    $0xc,%esp
  802530:	5e                   	pop    %esi
  802531:	5f                   	pop    %edi
  802532:	5d                   	pop    %ebp
  802533:	c3                   	ret    
  802534:	66 90                	xchg   %ax,%ax
  802536:	66 90                	xchg   %ax,%ax
  802538:	66 90                	xchg   %ax,%ax
  80253a:	66 90                	xchg   %ax,%ax
  80253c:	66 90                	xchg   %ax,%ax
  80253e:	66 90                	xchg   %ax,%ax

00802540 <__umoddi3>:
  802540:	55                   	push   %ebp
  802541:	57                   	push   %edi
  802542:	56                   	push   %esi
  802543:	83 ec 14             	sub    $0x14,%esp
  802546:	8b 44 24 28          	mov    0x28(%esp),%eax
  80254a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80254e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802552:	89 c7                	mov    %eax,%edi
  802554:	89 44 24 04          	mov    %eax,0x4(%esp)
  802558:	8b 44 24 30          	mov    0x30(%esp),%eax
  80255c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802560:	89 34 24             	mov    %esi,(%esp)
  802563:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802567:	85 c0                	test   %eax,%eax
  802569:	89 c2                	mov    %eax,%edx
  80256b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80256f:	75 17                	jne    802588 <__umoddi3+0x48>
  802571:	39 fe                	cmp    %edi,%esi
  802573:	76 4b                	jbe    8025c0 <__umoddi3+0x80>
  802575:	89 c8                	mov    %ecx,%eax
  802577:	89 fa                	mov    %edi,%edx
  802579:	f7 f6                	div    %esi
  80257b:	89 d0                	mov    %edx,%eax
  80257d:	31 d2                	xor    %edx,%edx
  80257f:	83 c4 14             	add    $0x14,%esp
  802582:	5e                   	pop    %esi
  802583:	5f                   	pop    %edi
  802584:	5d                   	pop    %ebp
  802585:	c3                   	ret    
  802586:	66 90                	xchg   %ax,%ax
  802588:	39 f8                	cmp    %edi,%eax
  80258a:	77 54                	ja     8025e0 <__umoddi3+0xa0>
  80258c:	0f bd e8             	bsr    %eax,%ebp
  80258f:	83 f5 1f             	xor    $0x1f,%ebp
  802592:	75 5c                	jne    8025f0 <__umoddi3+0xb0>
  802594:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802598:	39 3c 24             	cmp    %edi,(%esp)
  80259b:	0f 87 e7 00 00 00    	ja     802688 <__umoddi3+0x148>
  8025a1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025a5:	29 f1                	sub    %esi,%ecx
  8025a7:	19 c7                	sbb    %eax,%edi
  8025a9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025b1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025b5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025b9:	83 c4 14             	add    $0x14,%esp
  8025bc:	5e                   	pop    %esi
  8025bd:	5f                   	pop    %edi
  8025be:	5d                   	pop    %ebp
  8025bf:	c3                   	ret    
  8025c0:	85 f6                	test   %esi,%esi
  8025c2:	89 f5                	mov    %esi,%ebp
  8025c4:	75 0b                	jne    8025d1 <__umoddi3+0x91>
  8025c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025cb:	31 d2                	xor    %edx,%edx
  8025cd:	f7 f6                	div    %esi
  8025cf:	89 c5                	mov    %eax,%ebp
  8025d1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025d5:	31 d2                	xor    %edx,%edx
  8025d7:	f7 f5                	div    %ebp
  8025d9:	89 c8                	mov    %ecx,%eax
  8025db:	f7 f5                	div    %ebp
  8025dd:	eb 9c                	jmp    80257b <__umoddi3+0x3b>
  8025df:	90                   	nop
  8025e0:	89 c8                	mov    %ecx,%eax
  8025e2:	89 fa                	mov    %edi,%edx
  8025e4:	83 c4 14             	add    $0x14,%esp
  8025e7:	5e                   	pop    %esi
  8025e8:	5f                   	pop    %edi
  8025e9:	5d                   	pop    %ebp
  8025ea:	c3                   	ret    
  8025eb:	90                   	nop
  8025ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025f0:	8b 04 24             	mov    (%esp),%eax
  8025f3:	be 20 00 00 00       	mov    $0x20,%esi
  8025f8:	89 e9                	mov    %ebp,%ecx
  8025fa:	29 ee                	sub    %ebp,%esi
  8025fc:	d3 e2                	shl    %cl,%edx
  8025fe:	89 f1                	mov    %esi,%ecx
  802600:	d3 e8                	shr    %cl,%eax
  802602:	89 e9                	mov    %ebp,%ecx
  802604:	89 44 24 04          	mov    %eax,0x4(%esp)
  802608:	8b 04 24             	mov    (%esp),%eax
  80260b:	09 54 24 04          	or     %edx,0x4(%esp)
  80260f:	89 fa                	mov    %edi,%edx
  802611:	d3 e0                	shl    %cl,%eax
  802613:	89 f1                	mov    %esi,%ecx
  802615:	89 44 24 08          	mov    %eax,0x8(%esp)
  802619:	8b 44 24 10          	mov    0x10(%esp),%eax
  80261d:	d3 ea                	shr    %cl,%edx
  80261f:	89 e9                	mov    %ebp,%ecx
  802621:	d3 e7                	shl    %cl,%edi
  802623:	89 f1                	mov    %esi,%ecx
  802625:	d3 e8                	shr    %cl,%eax
  802627:	89 e9                	mov    %ebp,%ecx
  802629:	09 f8                	or     %edi,%eax
  80262b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80262f:	f7 74 24 04          	divl   0x4(%esp)
  802633:	d3 e7                	shl    %cl,%edi
  802635:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802639:	89 d7                	mov    %edx,%edi
  80263b:	f7 64 24 08          	mull   0x8(%esp)
  80263f:	39 d7                	cmp    %edx,%edi
  802641:	89 c1                	mov    %eax,%ecx
  802643:	89 14 24             	mov    %edx,(%esp)
  802646:	72 2c                	jb     802674 <__umoddi3+0x134>
  802648:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80264c:	72 22                	jb     802670 <__umoddi3+0x130>
  80264e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802652:	29 c8                	sub    %ecx,%eax
  802654:	19 d7                	sbb    %edx,%edi
  802656:	89 e9                	mov    %ebp,%ecx
  802658:	89 fa                	mov    %edi,%edx
  80265a:	d3 e8                	shr    %cl,%eax
  80265c:	89 f1                	mov    %esi,%ecx
  80265e:	d3 e2                	shl    %cl,%edx
  802660:	89 e9                	mov    %ebp,%ecx
  802662:	d3 ef                	shr    %cl,%edi
  802664:	09 d0                	or     %edx,%eax
  802666:	89 fa                	mov    %edi,%edx
  802668:	83 c4 14             	add    $0x14,%esp
  80266b:	5e                   	pop    %esi
  80266c:	5f                   	pop    %edi
  80266d:	5d                   	pop    %ebp
  80266e:	c3                   	ret    
  80266f:	90                   	nop
  802670:	39 d7                	cmp    %edx,%edi
  802672:	75 da                	jne    80264e <__umoddi3+0x10e>
  802674:	8b 14 24             	mov    (%esp),%edx
  802677:	89 c1                	mov    %eax,%ecx
  802679:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80267d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802681:	eb cb                	jmp    80264e <__umoddi3+0x10e>
  802683:	90                   	nop
  802684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802688:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80268c:	0f 82 0f ff ff ff    	jb     8025a1 <__umoddi3+0x61>
  802692:	e9 1a ff ff ff       	jmp    8025b1 <__umoddi3+0x71>
