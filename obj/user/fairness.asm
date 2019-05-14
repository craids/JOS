
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 91 00 00 00       	call   8000c2 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 20             	sub    $0x20,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 85 0b 00 00       	call   800bc5 <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 08 40 80 00 80 	cmpl   $0xeec00080,0x804008
  800049:	00 c0 ee 
  80004c:	75 34                	jne    800082 <umain+0x4f>
		while (1) {
			ipc_recv(&who, 0, 0);
  80004e:	8d 75 f4             	lea    -0xc(%ebp),%esi
  800051:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800058:	00 
  800059:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800060:	00 
  800061:	89 34 24             	mov    %esi,(%esp)
  800064:	e8 e7 0e 00 00       	call   800f50 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  800069:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80006c:	89 54 24 08          	mov    %edx,0x8(%esp)
  800070:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800074:	c7 04 24 c0 26 80 00 	movl   $0x8026c0,(%esp)
  80007b:	e8 46 01 00 00       	call   8001c6 <cprintf>
  800080:	eb cf                	jmp    800051 <umain+0x1e>
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  800082:	a1 c8 00 c0 ee       	mov    0xeec000c8,%eax
  800087:	89 44 24 08          	mov    %eax,0x8(%esp)
  80008b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80008f:	c7 04 24 d1 26 80 00 	movl   $0x8026d1,(%esp)
  800096:	e8 2b 01 00 00       	call   8001c6 <cprintf>
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  80009b:	a1 c8 00 c0 ee       	mov    0xeec000c8,%eax
  8000a0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000a7:	00 
  8000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000af:	00 
  8000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b7:	00 
  8000b8:	89 04 24             	mov    %eax,(%esp)
  8000bb:	e8 f8 0e 00 00       	call   800fb8 <ipc_send>
  8000c0:	eb d9                	jmp    80009b <umain+0x68>

008000c2 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000c2:	55                   	push   %ebp
  8000c3:	89 e5                	mov    %esp,%ebp
  8000c5:	56                   	push   %esi
  8000c6:	53                   	push   %ebx
  8000c7:	83 ec 10             	sub    $0x10,%esp
  8000ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000cd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000d0:	e8 f0 0a 00 00       	call   800bc5 <sys_getenvid>
  8000d5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000da:	c1 e0 07             	shl    $0x7,%eax
  8000dd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000e2:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000e7:	85 db                	test   %ebx,%ebx
  8000e9:	7e 07                	jle    8000f2 <libmain+0x30>
		binaryname = argv[0];
  8000eb:	8b 06                	mov    (%esi),%eax
  8000ed:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000f6:	89 1c 24             	mov    %ebx,(%esp)
  8000f9:	e8 35 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000fe:	e8 07 00 00 00       	call   80010a <exit>
}
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	5b                   	pop    %ebx
  800107:	5e                   	pop    %esi
  800108:	5d                   	pop    %ebp
  800109:	c3                   	ret    

0080010a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80010a:	55                   	push   %ebp
  80010b:	89 e5                	mov    %esp,%ebp
  80010d:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800110:	e8 45 11 00 00       	call   80125a <close_all>
	sys_env_destroy(0);
  800115:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80011c:	e8 52 0a 00 00       	call   800b73 <sys_env_destroy>
}
  800121:	c9                   	leave  
  800122:	c3                   	ret    

00800123 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800123:	55                   	push   %ebp
  800124:	89 e5                	mov    %esp,%ebp
  800126:	53                   	push   %ebx
  800127:	83 ec 14             	sub    $0x14,%esp
  80012a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80012d:	8b 13                	mov    (%ebx),%edx
  80012f:	8d 42 01             	lea    0x1(%edx),%eax
  800132:	89 03                	mov    %eax,(%ebx)
  800134:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800137:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80013b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800140:	75 19                	jne    80015b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800142:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800149:	00 
  80014a:	8d 43 08             	lea    0x8(%ebx),%eax
  80014d:	89 04 24             	mov    %eax,(%esp)
  800150:	e8 e1 09 00 00       	call   800b36 <sys_cputs>
		b->idx = 0;
  800155:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80015b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80015f:	83 c4 14             	add    $0x14,%esp
  800162:	5b                   	pop    %ebx
  800163:	5d                   	pop    %ebp
  800164:	c3                   	ret    

00800165 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80016e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800175:	00 00 00 
	b.cnt = 0;
  800178:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800182:	8b 45 0c             	mov    0xc(%ebp),%eax
  800185:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800189:	8b 45 08             	mov    0x8(%ebp),%eax
  80018c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800190:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800196:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019a:	c7 04 24 23 01 80 00 	movl   $0x800123,(%esp)
  8001a1:	e8 a8 01 00 00       	call   80034e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001a6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001b6:	89 04 24             	mov    %eax,(%esp)
  8001b9:	e8 78 09 00 00       	call   800b36 <sys_cputs>

	return b.cnt;
}
  8001be:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001c4:	c9                   	leave  
  8001c5:	c3                   	ret    

008001c6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001cc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d6:	89 04 24             	mov    %eax,(%esp)
  8001d9:	e8 87 ff ff ff       	call   800165 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001de:	c9                   	leave  
  8001df:	c3                   	ret    

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
  80024f:	e8 dc 21 00 00       	call   802430 <__udivdi3>
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
  8002af:	e8 ac 22 00 00       	call   802560 <__umoddi3>
  8002b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002b8:	0f be 80 f2 26 80 00 	movsbl 0x8026f2(%eax),%eax
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
  8003d3:	ff 24 8d 40 28 80 00 	jmp    *0x802840(,%ecx,4)
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
  800470:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  800477:	85 d2                	test   %edx,%edx
  800479:	75 20                	jne    80049b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80047b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80047f:	c7 44 24 08 0a 27 80 	movl   $0x80270a,0x8(%esp)
  800486:	00 
  800487:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	89 04 24             	mov    %eax,(%esp)
  800491:	e8 90 fe ff ff       	call   800326 <printfmt>
  800496:	e9 d8 fe ff ff       	jmp    800373 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80049b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80049f:	c7 44 24 08 f5 2a 80 	movl   $0x802af5,0x8(%esp)
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
  8004d1:	b8 03 27 80 00       	mov    $0x802703,%eax
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
  800ba1:	c7 44 24 08 07 2a 80 	movl   $0x802a07,0x8(%esp)
  800ba8:	00 
  800ba9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bb0:	00 
  800bb1:	c7 04 24 24 2a 80 00 	movl   $0x802a24,(%esp)
  800bb8:	e8 d9 17 00 00       	call   802396 <_panic>

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
  800c33:	c7 44 24 08 07 2a 80 	movl   $0x802a07,0x8(%esp)
  800c3a:	00 
  800c3b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c42:	00 
  800c43:	c7 04 24 24 2a 80 00 	movl   $0x802a24,(%esp)
  800c4a:	e8 47 17 00 00       	call   802396 <_panic>

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
  800c86:	c7 44 24 08 07 2a 80 	movl   $0x802a07,0x8(%esp)
  800c8d:	00 
  800c8e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c95:	00 
  800c96:	c7 04 24 24 2a 80 00 	movl   $0x802a24,(%esp)
  800c9d:	e8 f4 16 00 00       	call   802396 <_panic>

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
  800cd9:	c7 44 24 08 07 2a 80 	movl   $0x802a07,0x8(%esp)
  800ce0:	00 
  800ce1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ce8:	00 
  800ce9:	c7 04 24 24 2a 80 00 	movl   $0x802a24,(%esp)
  800cf0:	e8 a1 16 00 00       	call   802396 <_panic>

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
  800d2c:	c7 44 24 08 07 2a 80 	movl   $0x802a07,0x8(%esp)
  800d33:	00 
  800d34:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d3b:	00 
  800d3c:	c7 04 24 24 2a 80 00 	movl   $0x802a24,(%esp)
  800d43:	e8 4e 16 00 00       	call   802396 <_panic>

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
  800d7f:	c7 44 24 08 07 2a 80 	movl   $0x802a07,0x8(%esp)
  800d86:	00 
  800d87:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d8e:	00 
  800d8f:	c7 04 24 24 2a 80 00 	movl   $0x802a24,(%esp)
  800d96:	e8 fb 15 00 00       	call   802396 <_panic>

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
  800dd2:	c7 44 24 08 07 2a 80 	movl   $0x802a07,0x8(%esp)
  800dd9:	00 
  800dda:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800de1:	00 
  800de2:	c7 04 24 24 2a 80 00 	movl   $0x802a24,(%esp)
  800de9:	e8 a8 15 00 00       	call   802396 <_panic>

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
  800e47:	c7 44 24 08 07 2a 80 	movl   $0x802a07,0x8(%esp)
  800e4e:	00 
  800e4f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e56:	00 
  800e57:	c7 04 24 24 2a 80 00 	movl   $0x802a24,(%esp)
  800e5e:	e8 33 15 00 00       	call   802396 <_panic>

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
  800f1d:	c7 44 24 08 07 2a 80 	movl   $0x802a07,0x8(%esp)
  800f24:	00 
  800f25:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f2c:	00 
  800f2d:	c7 04 24 24 2a 80 00 	movl   $0x802a24,(%esp)
  800f34:	e8 5d 14 00 00       	call   802396 <_panic>

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
  800f41:	66 90                	xchg   %ax,%ax
  800f43:	66 90                	xchg   %ax,%ax
  800f45:	66 90                	xchg   %ax,%ax
  800f47:	66 90                	xchg   %ax,%ax
  800f49:	66 90                	xchg   %ax,%ax
  800f4b:	66 90                	xchg   %ax,%ax
  800f4d:	66 90                	xchg   %ax,%ax
  800f4f:	90                   	nop

00800f50 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	56                   	push   %esi
  800f54:	53                   	push   %ebx
  800f55:	83 ec 10             	sub    $0x10,%esp
  800f58:	8b 75 08             	mov    0x8(%ebp),%esi
  800f5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  800f61:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  800f63:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  800f68:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  800f6b:	89 04 24             	mov    %eax,(%esp)
  800f6e:	e8 a6 fe ff ff       	call   800e19 <sys_ipc_recv>
  800f73:	85 c0                	test   %eax,%eax
  800f75:	74 16                	je     800f8d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  800f77:	85 f6                	test   %esi,%esi
  800f79:	74 06                	je     800f81 <ipc_recv+0x31>
			*from_env_store = 0;
  800f7b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  800f81:	85 db                	test   %ebx,%ebx
  800f83:	74 2c                	je     800fb1 <ipc_recv+0x61>
			*perm_store = 0;
  800f85:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800f8b:	eb 24                	jmp    800fb1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  800f8d:	85 f6                	test   %esi,%esi
  800f8f:	74 0a                	je     800f9b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  800f91:	a1 08 40 80 00       	mov    0x804008,%eax
  800f96:	8b 40 74             	mov    0x74(%eax),%eax
  800f99:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  800f9b:	85 db                	test   %ebx,%ebx
  800f9d:	74 0a                	je     800fa9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  800f9f:	a1 08 40 80 00       	mov    0x804008,%eax
  800fa4:	8b 40 78             	mov    0x78(%eax),%eax
  800fa7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  800fa9:	a1 08 40 80 00       	mov    0x804008,%eax
  800fae:	8b 40 70             	mov    0x70(%eax),%eax
}
  800fb1:	83 c4 10             	add    $0x10,%esp
  800fb4:	5b                   	pop    %ebx
  800fb5:	5e                   	pop    %esi
  800fb6:	5d                   	pop    %ebp
  800fb7:	c3                   	ret    

00800fb8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	57                   	push   %edi
  800fbc:	56                   	push   %esi
  800fbd:	53                   	push   %ebx
  800fbe:	83 ec 1c             	sub    $0x1c,%esp
  800fc1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  800fca:	85 db                	test   %ebx,%ebx
  800fcc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  800fd1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  800fd4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800fd8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800fdc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	89 04 24             	mov    %eax,(%esp)
  800fe6:	e8 0b fe ff ff       	call   800df6 <sys_ipc_try_send>
	if (r == 0) return;
  800feb:	85 c0                	test   %eax,%eax
  800fed:	75 22                	jne    801011 <ipc_send+0x59>
  800fef:	eb 4c                	jmp    80103d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  800ff1:	84 d2                	test   %dl,%dl
  800ff3:	75 48                	jne    80103d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  800ff5:	e8 ea fb ff ff       	call   800be4 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  800ffa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800ffe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801002:	89 74 24 04          	mov    %esi,0x4(%esp)
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	89 04 24             	mov    %eax,(%esp)
  80100c:	e8 e5 fd ff ff       	call   800df6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  801011:	85 c0                	test   %eax,%eax
  801013:	0f 94 c2             	sete   %dl
  801016:	74 d9                	je     800ff1 <ipc_send+0x39>
  801018:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80101b:	74 d4                	je     800ff1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80101d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801021:	c7 44 24 08 32 2a 80 	movl   $0x802a32,0x8(%esp)
  801028:	00 
  801029:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  801030:	00 
  801031:	c7 04 24 40 2a 80 00 	movl   $0x802a40,(%esp)
  801038:	e8 59 13 00 00       	call   802396 <_panic>
}
  80103d:	83 c4 1c             	add    $0x1c,%esp
  801040:	5b                   	pop    %ebx
  801041:	5e                   	pop    %esi
  801042:	5f                   	pop    %edi
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    

00801045 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801050:	89 c2                	mov    %eax,%edx
  801052:	c1 e2 07             	shl    $0x7,%edx
  801055:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80105b:	8b 52 50             	mov    0x50(%edx),%edx
  80105e:	39 ca                	cmp    %ecx,%edx
  801060:	75 0d                	jne    80106f <ipc_find_env+0x2a>
			return envs[i].env_id;
  801062:	c1 e0 07             	shl    $0x7,%eax
  801065:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80106a:	8b 40 40             	mov    0x40(%eax),%eax
  80106d:	eb 0e                	jmp    80107d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80106f:	83 c0 01             	add    $0x1,%eax
  801072:	3d 00 04 00 00       	cmp    $0x400,%eax
  801077:	75 d7                	jne    801050 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801079:	66 b8 00 00          	mov    $0x0,%ax
}
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    
  80107f:	90                   	nop

00801080 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	05 00 00 00 30       	add    $0x30000000,%eax
  80108b:	c1 e8 0c             	shr    $0xc,%eax
}
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80109b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010a0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010a5:	5d                   	pop    %ebp
  8010a6:	c3                   	ret    

008010a7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ad:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010b2:	89 c2                	mov    %eax,%edx
  8010b4:	c1 ea 16             	shr    $0x16,%edx
  8010b7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010be:	f6 c2 01             	test   $0x1,%dl
  8010c1:	74 11                	je     8010d4 <fd_alloc+0x2d>
  8010c3:	89 c2                	mov    %eax,%edx
  8010c5:	c1 ea 0c             	shr    $0xc,%edx
  8010c8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010cf:	f6 c2 01             	test   $0x1,%dl
  8010d2:	75 09                	jne    8010dd <fd_alloc+0x36>
			*fd_store = fd;
  8010d4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010db:	eb 17                	jmp    8010f4 <fd_alloc+0x4d>
  8010dd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010e2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010e7:	75 c9                	jne    8010b2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010e9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8010ef:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010f4:	5d                   	pop    %ebp
  8010f5:	c3                   	ret    

008010f6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010fc:	83 f8 1f             	cmp    $0x1f,%eax
  8010ff:	77 36                	ja     801137 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801101:	c1 e0 0c             	shl    $0xc,%eax
  801104:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801109:	89 c2                	mov    %eax,%edx
  80110b:	c1 ea 16             	shr    $0x16,%edx
  80110e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801115:	f6 c2 01             	test   $0x1,%dl
  801118:	74 24                	je     80113e <fd_lookup+0x48>
  80111a:	89 c2                	mov    %eax,%edx
  80111c:	c1 ea 0c             	shr    $0xc,%edx
  80111f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801126:	f6 c2 01             	test   $0x1,%dl
  801129:	74 1a                	je     801145 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80112b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112e:	89 02                	mov    %eax,(%edx)
	return 0;
  801130:	b8 00 00 00 00       	mov    $0x0,%eax
  801135:	eb 13                	jmp    80114a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801137:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80113c:	eb 0c                	jmp    80114a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80113e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801143:	eb 05                	jmp    80114a <fd_lookup+0x54>
  801145:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    

0080114c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 18             	sub    $0x18,%esp
  801152:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801155:	ba 00 00 00 00       	mov    $0x0,%edx
  80115a:	eb 13                	jmp    80116f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80115c:	39 08                	cmp    %ecx,(%eax)
  80115e:	75 0c                	jne    80116c <dev_lookup+0x20>
			*dev = devtab[i];
  801160:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801163:	89 01                	mov    %eax,(%ecx)
			return 0;
  801165:	b8 00 00 00 00       	mov    $0x0,%eax
  80116a:	eb 38                	jmp    8011a4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80116c:	83 c2 01             	add    $0x1,%edx
  80116f:	8b 04 95 c8 2a 80 00 	mov    0x802ac8(,%edx,4),%eax
  801176:	85 c0                	test   %eax,%eax
  801178:	75 e2                	jne    80115c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80117a:	a1 08 40 80 00       	mov    0x804008,%eax
  80117f:	8b 40 48             	mov    0x48(%eax),%eax
  801182:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801186:	89 44 24 04          	mov    %eax,0x4(%esp)
  80118a:	c7 04 24 4c 2a 80 00 	movl   $0x802a4c,(%esp)
  801191:	e8 30 f0 ff ff       	call   8001c6 <cprintf>
	*dev = 0;
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80119f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    

008011a6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	56                   	push   %esi
  8011aa:	53                   	push   %ebx
  8011ab:	83 ec 20             	sub    $0x20,%esp
  8011ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8011b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011bb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011c1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011c4:	89 04 24             	mov    %eax,(%esp)
  8011c7:	e8 2a ff ff ff       	call   8010f6 <fd_lookup>
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	78 05                	js     8011d5 <fd_close+0x2f>
	    || fd != fd2)
  8011d0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8011d3:	74 0c                	je     8011e1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8011d5:	84 db                	test   %bl,%bl
  8011d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011dc:	0f 44 c2             	cmove  %edx,%eax
  8011df:	eb 3f                	jmp    801220 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011e8:	8b 06                	mov    (%esi),%eax
  8011ea:	89 04 24             	mov    %eax,(%esp)
  8011ed:	e8 5a ff ff ff       	call   80114c <dev_lookup>
  8011f2:	89 c3                	mov    %eax,%ebx
  8011f4:	85 c0                	test   %eax,%eax
  8011f6:	78 16                	js     80120e <fd_close+0x68>
		if (dev->dev_close)
  8011f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011fe:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801203:	85 c0                	test   %eax,%eax
  801205:	74 07                	je     80120e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801207:	89 34 24             	mov    %esi,(%esp)
  80120a:	ff d0                	call   *%eax
  80120c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80120e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801212:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801219:	e8 8c fa ff ff       	call   800caa <sys_page_unmap>
	return r;
  80121e:	89 d8                	mov    %ebx,%eax
}
  801220:	83 c4 20             	add    $0x20,%esp
  801223:	5b                   	pop    %ebx
  801224:	5e                   	pop    %esi
  801225:	5d                   	pop    %ebp
  801226:	c3                   	ret    

00801227 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
  80122a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80122d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801230:	89 44 24 04          	mov    %eax,0x4(%esp)
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	89 04 24             	mov    %eax,(%esp)
  80123a:	e8 b7 fe ff ff       	call   8010f6 <fd_lookup>
  80123f:	89 c2                	mov    %eax,%edx
  801241:	85 d2                	test   %edx,%edx
  801243:	78 13                	js     801258 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801245:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80124c:	00 
  80124d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801250:	89 04 24             	mov    %eax,(%esp)
  801253:	e8 4e ff ff ff       	call   8011a6 <fd_close>
}
  801258:	c9                   	leave  
  801259:	c3                   	ret    

0080125a <close_all>:

void
close_all(void)
{
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	53                   	push   %ebx
  80125e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801261:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801266:	89 1c 24             	mov    %ebx,(%esp)
  801269:	e8 b9 ff ff ff       	call   801227 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80126e:	83 c3 01             	add    $0x1,%ebx
  801271:	83 fb 20             	cmp    $0x20,%ebx
  801274:	75 f0                	jne    801266 <close_all+0xc>
		close(i);
}
  801276:	83 c4 14             	add    $0x14,%esp
  801279:	5b                   	pop    %ebx
  80127a:	5d                   	pop    %ebp
  80127b:	c3                   	ret    

0080127c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
  80127f:	57                   	push   %edi
  801280:	56                   	push   %esi
  801281:	53                   	push   %ebx
  801282:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801285:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801288:	89 44 24 04          	mov    %eax,0x4(%esp)
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	89 04 24             	mov    %eax,(%esp)
  801292:	e8 5f fe ff ff       	call   8010f6 <fd_lookup>
  801297:	89 c2                	mov    %eax,%edx
  801299:	85 d2                	test   %edx,%edx
  80129b:	0f 88 e1 00 00 00    	js     801382 <dup+0x106>
		return r;
	close(newfdnum);
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	89 04 24             	mov    %eax,(%esp)
  8012a7:	e8 7b ff ff ff       	call   801227 <close>

	newfd = INDEX2FD(newfdnum);
  8012ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012af:	c1 e3 0c             	shl    $0xc,%ebx
  8012b2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8012b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012bb:	89 04 24             	mov    %eax,(%esp)
  8012be:	e8 cd fd ff ff       	call   801090 <fd2data>
  8012c3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8012c5:	89 1c 24             	mov    %ebx,(%esp)
  8012c8:	e8 c3 fd ff ff       	call   801090 <fd2data>
  8012cd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012cf:	89 f0                	mov    %esi,%eax
  8012d1:	c1 e8 16             	shr    $0x16,%eax
  8012d4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012db:	a8 01                	test   $0x1,%al
  8012dd:	74 43                	je     801322 <dup+0xa6>
  8012df:	89 f0                	mov    %esi,%eax
  8012e1:	c1 e8 0c             	shr    $0xc,%eax
  8012e4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012eb:	f6 c2 01             	test   $0x1,%dl
  8012ee:	74 32                	je     801322 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  801300:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801304:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80130b:	00 
  80130c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801310:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801317:	e8 3b f9 ff ff       	call   800c57 <sys_page_map>
  80131c:	89 c6                	mov    %eax,%esi
  80131e:	85 c0                	test   %eax,%eax
  801320:	78 3e                	js     801360 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801322:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801325:	89 c2                	mov    %eax,%edx
  801327:	c1 ea 0c             	shr    $0xc,%edx
  80132a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801331:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801337:	89 54 24 10          	mov    %edx,0x10(%esp)
  80133b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80133f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801346:	00 
  801347:	89 44 24 04          	mov    %eax,0x4(%esp)
  80134b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801352:	e8 00 f9 ff ff       	call   800c57 <sys_page_map>
  801357:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801359:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80135c:	85 f6                	test   %esi,%esi
  80135e:	79 22                	jns    801382 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801360:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801364:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80136b:	e8 3a f9 ff ff       	call   800caa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801370:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801374:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80137b:	e8 2a f9 ff ff       	call   800caa <sys_page_unmap>
	return r;
  801380:	89 f0                	mov    %esi,%eax
}
  801382:	83 c4 3c             	add    $0x3c,%esp
  801385:	5b                   	pop    %ebx
  801386:	5e                   	pop    %esi
  801387:	5f                   	pop    %edi
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	53                   	push   %ebx
  80138e:	83 ec 24             	sub    $0x24,%esp
  801391:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801394:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801397:	89 44 24 04          	mov    %eax,0x4(%esp)
  80139b:	89 1c 24             	mov    %ebx,(%esp)
  80139e:	e8 53 fd ff ff       	call   8010f6 <fd_lookup>
  8013a3:	89 c2                	mov    %eax,%edx
  8013a5:	85 d2                	test   %edx,%edx
  8013a7:	78 6d                	js     801416 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b3:	8b 00                	mov    (%eax),%eax
  8013b5:	89 04 24             	mov    %eax,(%esp)
  8013b8:	e8 8f fd ff ff       	call   80114c <dev_lookup>
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	78 55                	js     801416 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c4:	8b 50 08             	mov    0x8(%eax),%edx
  8013c7:	83 e2 03             	and    $0x3,%edx
  8013ca:	83 fa 01             	cmp    $0x1,%edx
  8013cd:	75 23                	jne    8013f2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013cf:	a1 08 40 80 00       	mov    0x804008,%eax
  8013d4:	8b 40 48             	mov    0x48(%eax),%eax
  8013d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013df:	c7 04 24 8d 2a 80 00 	movl   $0x802a8d,(%esp)
  8013e6:	e8 db ed ff ff       	call   8001c6 <cprintf>
		return -E_INVAL;
  8013eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f0:	eb 24                	jmp    801416 <read+0x8c>
	}
	if (!dev->dev_read)
  8013f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f5:	8b 52 08             	mov    0x8(%edx),%edx
  8013f8:	85 d2                	test   %edx,%edx
  8013fa:	74 15                	je     801411 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801403:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801406:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80140a:	89 04 24             	mov    %eax,(%esp)
  80140d:	ff d2                	call   *%edx
  80140f:	eb 05                	jmp    801416 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801411:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801416:	83 c4 24             	add    $0x24,%esp
  801419:	5b                   	pop    %ebx
  80141a:	5d                   	pop    %ebp
  80141b:	c3                   	ret    

0080141c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	57                   	push   %edi
  801420:	56                   	push   %esi
  801421:	53                   	push   %ebx
  801422:	83 ec 1c             	sub    $0x1c,%esp
  801425:	8b 7d 08             	mov    0x8(%ebp),%edi
  801428:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80142b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801430:	eb 23                	jmp    801455 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801432:	89 f0                	mov    %esi,%eax
  801434:	29 d8                	sub    %ebx,%eax
  801436:	89 44 24 08          	mov    %eax,0x8(%esp)
  80143a:	89 d8                	mov    %ebx,%eax
  80143c:	03 45 0c             	add    0xc(%ebp),%eax
  80143f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801443:	89 3c 24             	mov    %edi,(%esp)
  801446:	e8 3f ff ff ff       	call   80138a <read>
		if (m < 0)
  80144b:	85 c0                	test   %eax,%eax
  80144d:	78 10                	js     80145f <readn+0x43>
			return m;
		if (m == 0)
  80144f:	85 c0                	test   %eax,%eax
  801451:	74 0a                	je     80145d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801453:	01 c3                	add    %eax,%ebx
  801455:	39 f3                	cmp    %esi,%ebx
  801457:	72 d9                	jb     801432 <readn+0x16>
  801459:	89 d8                	mov    %ebx,%eax
  80145b:	eb 02                	jmp    80145f <readn+0x43>
  80145d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80145f:	83 c4 1c             	add    $0x1c,%esp
  801462:	5b                   	pop    %ebx
  801463:	5e                   	pop    %esi
  801464:	5f                   	pop    %edi
  801465:	5d                   	pop    %ebp
  801466:	c3                   	ret    

00801467 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
  80146a:	53                   	push   %ebx
  80146b:	83 ec 24             	sub    $0x24,%esp
  80146e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801471:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801474:	89 44 24 04          	mov    %eax,0x4(%esp)
  801478:	89 1c 24             	mov    %ebx,(%esp)
  80147b:	e8 76 fc ff ff       	call   8010f6 <fd_lookup>
  801480:	89 c2                	mov    %eax,%edx
  801482:	85 d2                	test   %edx,%edx
  801484:	78 68                	js     8014ee <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801486:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801489:	89 44 24 04          	mov    %eax,0x4(%esp)
  80148d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801490:	8b 00                	mov    (%eax),%eax
  801492:	89 04 24             	mov    %eax,(%esp)
  801495:	e8 b2 fc ff ff       	call   80114c <dev_lookup>
  80149a:	85 c0                	test   %eax,%eax
  80149c:	78 50                	js     8014ee <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80149e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014a5:	75 23                	jne    8014ca <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014a7:	a1 08 40 80 00       	mov    0x804008,%eax
  8014ac:	8b 40 48             	mov    0x48(%eax),%eax
  8014af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b7:	c7 04 24 a9 2a 80 00 	movl   $0x802aa9,(%esp)
  8014be:	e8 03 ed ff ff       	call   8001c6 <cprintf>
		return -E_INVAL;
  8014c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c8:	eb 24                	jmp    8014ee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014cd:	8b 52 0c             	mov    0xc(%edx),%edx
  8014d0:	85 d2                	test   %edx,%edx
  8014d2:	74 15                	je     8014e9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014e2:	89 04 24             	mov    %eax,(%esp)
  8014e5:	ff d2                	call   *%edx
  8014e7:	eb 05                	jmp    8014ee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8014e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8014ee:	83 c4 24             	add    $0x24,%esp
  8014f1:	5b                   	pop    %ebx
  8014f2:	5d                   	pop    %ebp
  8014f3:	c3                   	ret    

008014f4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014fa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	89 04 24             	mov    %eax,(%esp)
  801507:	e8 ea fb ff ff       	call   8010f6 <fd_lookup>
  80150c:	85 c0                	test   %eax,%eax
  80150e:	78 0e                	js     80151e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801510:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801513:	8b 55 0c             	mov    0xc(%ebp),%edx
  801516:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801519:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151e:	c9                   	leave  
  80151f:	c3                   	ret    

00801520 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	53                   	push   %ebx
  801524:	83 ec 24             	sub    $0x24,%esp
  801527:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80152a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80152d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801531:	89 1c 24             	mov    %ebx,(%esp)
  801534:	e8 bd fb ff ff       	call   8010f6 <fd_lookup>
  801539:	89 c2                	mov    %eax,%edx
  80153b:	85 d2                	test   %edx,%edx
  80153d:	78 61                	js     8015a0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80153f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801542:	89 44 24 04          	mov    %eax,0x4(%esp)
  801546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801549:	8b 00                	mov    (%eax),%eax
  80154b:	89 04 24             	mov    %eax,(%esp)
  80154e:	e8 f9 fb ff ff       	call   80114c <dev_lookup>
  801553:	85 c0                	test   %eax,%eax
  801555:	78 49                	js     8015a0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80155e:	75 23                	jne    801583 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801560:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801565:	8b 40 48             	mov    0x48(%eax),%eax
  801568:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80156c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801570:	c7 04 24 6c 2a 80 00 	movl   $0x802a6c,(%esp)
  801577:	e8 4a ec ff ff       	call   8001c6 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80157c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801581:	eb 1d                	jmp    8015a0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801583:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801586:	8b 52 18             	mov    0x18(%edx),%edx
  801589:	85 d2                	test   %edx,%edx
  80158b:	74 0e                	je     80159b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80158d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801590:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801594:	89 04 24             	mov    %eax,(%esp)
  801597:	ff d2                	call   *%edx
  801599:	eb 05                	jmp    8015a0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80159b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8015a0:	83 c4 24             	add    $0x24,%esp
  8015a3:	5b                   	pop    %ebx
  8015a4:	5d                   	pop    %ebp
  8015a5:	c3                   	ret    

008015a6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	53                   	push   %ebx
  8015aa:	83 ec 24             	sub    $0x24,%esp
  8015ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ba:	89 04 24             	mov    %eax,(%esp)
  8015bd:	e8 34 fb ff ff       	call   8010f6 <fd_lookup>
  8015c2:	89 c2                	mov    %eax,%edx
  8015c4:	85 d2                	test   %edx,%edx
  8015c6:	78 52                	js     80161a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d2:	8b 00                	mov    (%eax),%eax
  8015d4:	89 04 24             	mov    %eax,(%esp)
  8015d7:	e8 70 fb ff ff       	call   80114c <dev_lookup>
  8015dc:	85 c0                	test   %eax,%eax
  8015de:	78 3a                	js     80161a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8015e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015e7:	74 2c                	je     801615 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015e9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015ec:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015f3:	00 00 00 
	stat->st_isdir = 0;
  8015f6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015fd:	00 00 00 
	stat->st_dev = dev;
  801600:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801606:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80160a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80160d:	89 14 24             	mov    %edx,(%esp)
  801610:	ff 50 14             	call   *0x14(%eax)
  801613:	eb 05                	jmp    80161a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801615:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80161a:	83 c4 24             	add    $0x24,%esp
  80161d:	5b                   	pop    %ebx
  80161e:	5d                   	pop    %ebp
  80161f:	c3                   	ret    

00801620 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	56                   	push   %esi
  801624:	53                   	push   %ebx
  801625:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801628:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80162f:	00 
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	89 04 24             	mov    %eax,(%esp)
  801636:	e8 84 02 00 00       	call   8018bf <open>
  80163b:	89 c3                	mov    %eax,%ebx
  80163d:	85 db                	test   %ebx,%ebx
  80163f:	78 1b                	js     80165c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801641:	8b 45 0c             	mov    0xc(%ebp),%eax
  801644:	89 44 24 04          	mov    %eax,0x4(%esp)
  801648:	89 1c 24             	mov    %ebx,(%esp)
  80164b:	e8 56 ff ff ff       	call   8015a6 <fstat>
  801650:	89 c6                	mov    %eax,%esi
	close(fd);
  801652:	89 1c 24             	mov    %ebx,(%esp)
  801655:	e8 cd fb ff ff       	call   801227 <close>
	return r;
  80165a:	89 f0                	mov    %esi,%eax
}
  80165c:	83 c4 10             	add    $0x10,%esp
  80165f:	5b                   	pop    %ebx
  801660:	5e                   	pop    %esi
  801661:	5d                   	pop    %ebp
  801662:	c3                   	ret    

00801663 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	56                   	push   %esi
  801667:	53                   	push   %ebx
  801668:	83 ec 10             	sub    $0x10,%esp
  80166b:	89 c6                	mov    %eax,%esi
  80166d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80166f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801676:	75 11                	jne    801689 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801678:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80167f:	e8 c1 f9 ff ff       	call   801045 <ipc_find_env>
  801684:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801689:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801690:	00 
  801691:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801698:	00 
  801699:	89 74 24 04          	mov    %esi,0x4(%esp)
  80169d:	a1 00 40 80 00       	mov    0x804000,%eax
  8016a2:	89 04 24             	mov    %eax,(%esp)
  8016a5:	e8 0e f9 ff ff       	call   800fb8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016b1:	00 
  8016b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016bd:	e8 8e f8 ff ff       	call   800f50 <ipc_recv>
}
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	5b                   	pop    %ebx
  8016c6:	5e                   	pop    %esi
  8016c7:	5d                   	pop    %ebp
  8016c8:	c3                   	ret    

008016c9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
  8016cc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e7:	b8 02 00 00 00       	mov    $0x2,%eax
  8016ec:	e8 72 ff ff ff       	call   801663 <fsipc>
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ff:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801704:	ba 00 00 00 00       	mov    $0x0,%edx
  801709:	b8 06 00 00 00       	mov    $0x6,%eax
  80170e:	e8 50 ff ff ff       	call   801663 <fsipc>
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	53                   	push   %ebx
  801719:	83 ec 14             	sub    $0x14,%esp
  80171c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	8b 40 0c             	mov    0xc(%eax),%eax
  801725:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80172a:	ba 00 00 00 00       	mov    $0x0,%edx
  80172f:	b8 05 00 00 00       	mov    $0x5,%eax
  801734:	e8 2a ff ff ff       	call   801663 <fsipc>
  801739:	89 c2                	mov    %eax,%edx
  80173b:	85 d2                	test   %edx,%edx
  80173d:	78 2b                	js     80176a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80173f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801746:	00 
  801747:	89 1c 24             	mov    %ebx,(%esp)
  80174a:	e8 98 f0 ff ff       	call   8007e7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80174f:	a1 80 50 80 00       	mov    0x805080,%eax
  801754:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80175a:	a1 84 50 80 00       	mov    0x805084,%eax
  80175f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801765:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176a:	83 c4 14             	add    $0x14,%esp
  80176d:	5b                   	pop    %ebx
  80176e:	5d                   	pop    %ebp
  80176f:	c3                   	ret    

00801770 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
  801773:	53                   	push   %ebx
  801774:	83 ec 14             	sub    $0x14,%esp
  801777:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80177a:	8b 45 08             	mov    0x8(%ebp),%eax
  80177d:	8b 40 0c             	mov    0xc(%eax),%eax
  801780:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801785:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80178b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801790:	0f 46 c3             	cmovbe %ebx,%eax
  801793:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801798:	89 44 24 08          	mov    %eax,0x8(%esp)
  80179c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a3:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8017aa:	e8 d5 f1 ff ff       	call   800984 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017af:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b4:	b8 04 00 00 00       	mov    $0x4,%eax
  8017b9:	e8 a5 fe ff ff       	call   801663 <fsipc>
  8017be:	85 c0                	test   %eax,%eax
  8017c0:	78 53                	js     801815 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  8017c2:	39 c3                	cmp    %eax,%ebx
  8017c4:	73 24                	jae    8017ea <devfile_write+0x7a>
  8017c6:	c7 44 24 0c dc 2a 80 	movl   $0x802adc,0xc(%esp)
  8017cd:	00 
  8017ce:	c7 44 24 08 e3 2a 80 	movl   $0x802ae3,0x8(%esp)
  8017d5:	00 
  8017d6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  8017dd:	00 
  8017de:	c7 04 24 f8 2a 80 00 	movl   $0x802af8,(%esp)
  8017e5:	e8 ac 0b 00 00       	call   802396 <_panic>
	assert(r <= PGSIZE);
  8017ea:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017ef:	7e 24                	jle    801815 <devfile_write+0xa5>
  8017f1:	c7 44 24 0c 03 2b 80 	movl   $0x802b03,0xc(%esp)
  8017f8:	00 
  8017f9:	c7 44 24 08 e3 2a 80 	movl   $0x802ae3,0x8(%esp)
  801800:	00 
  801801:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801808:	00 
  801809:	c7 04 24 f8 2a 80 00 	movl   $0x802af8,(%esp)
  801810:	e8 81 0b 00 00       	call   802396 <_panic>
	return r;
}
  801815:	83 c4 14             	add    $0x14,%esp
  801818:	5b                   	pop    %ebx
  801819:	5d                   	pop    %ebp
  80181a:	c3                   	ret    

0080181b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	56                   	push   %esi
  80181f:	53                   	push   %ebx
  801820:	83 ec 10             	sub    $0x10,%esp
  801823:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	8b 40 0c             	mov    0xc(%eax),%eax
  80182c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801831:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801837:	ba 00 00 00 00       	mov    $0x0,%edx
  80183c:	b8 03 00 00 00       	mov    $0x3,%eax
  801841:	e8 1d fe ff ff       	call   801663 <fsipc>
  801846:	89 c3                	mov    %eax,%ebx
  801848:	85 c0                	test   %eax,%eax
  80184a:	78 6a                	js     8018b6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  80184c:	39 c6                	cmp    %eax,%esi
  80184e:	73 24                	jae    801874 <devfile_read+0x59>
  801850:	c7 44 24 0c dc 2a 80 	movl   $0x802adc,0xc(%esp)
  801857:	00 
  801858:	c7 44 24 08 e3 2a 80 	movl   $0x802ae3,0x8(%esp)
  80185f:	00 
  801860:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801867:	00 
  801868:	c7 04 24 f8 2a 80 00 	movl   $0x802af8,(%esp)
  80186f:	e8 22 0b 00 00       	call   802396 <_panic>
	assert(r <= PGSIZE);
  801874:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801879:	7e 24                	jle    80189f <devfile_read+0x84>
  80187b:	c7 44 24 0c 03 2b 80 	movl   $0x802b03,0xc(%esp)
  801882:	00 
  801883:	c7 44 24 08 e3 2a 80 	movl   $0x802ae3,0x8(%esp)
  80188a:	00 
  80188b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801892:	00 
  801893:	c7 04 24 f8 2a 80 00 	movl   $0x802af8,(%esp)
  80189a:	e8 f7 0a 00 00       	call   802396 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80189f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018a3:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8018aa:	00 
  8018ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ae:	89 04 24             	mov    %eax,(%esp)
  8018b1:	e8 ce f0 ff ff       	call   800984 <memmove>
	return r;
}
  8018b6:	89 d8                	mov    %ebx,%eax
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	5b                   	pop    %ebx
  8018bc:	5e                   	pop    %esi
  8018bd:	5d                   	pop    %ebp
  8018be:	c3                   	ret    

008018bf <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	53                   	push   %ebx
  8018c3:	83 ec 24             	sub    $0x24,%esp
  8018c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018c9:	89 1c 24             	mov    %ebx,(%esp)
  8018cc:	e8 df ee ff ff       	call   8007b0 <strlen>
  8018d1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018d6:	7f 60                	jg     801938 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018db:	89 04 24             	mov    %eax,(%esp)
  8018de:	e8 c4 f7 ff ff       	call   8010a7 <fd_alloc>
  8018e3:	89 c2                	mov    %eax,%edx
  8018e5:	85 d2                	test   %edx,%edx
  8018e7:	78 54                	js     80193d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018e9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018ed:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8018f4:	e8 ee ee ff ff       	call   8007e7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fc:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801901:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801904:	b8 01 00 00 00       	mov    $0x1,%eax
  801909:	e8 55 fd ff ff       	call   801663 <fsipc>
  80190e:	89 c3                	mov    %eax,%ebx
  801910:	85 c0                	test   %eax,%eax
  801912:	79 17                	jns    80192b <open+0x6c>
		fd_close(fd, 0);
  801914:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80191b:	00 
  80191c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191f:	89 04 24             	mov    %eax,(%esp)
  801922:	e8 7f f8 ff ff       	call   8011a6 <fd_close>
		return r;
  801927:	89 d8                	mov    %ebx,%eax
  801929:	eb 12                	jmp    80193d <open+0x7e>
	}

	return fd2num(fd);
  80192b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192e:	89 04 24             	mov    %eax,(%esp)
  801931:	e8 4a f7 ff ff       	call   801080 <fd2num>
  801936:	eb 05                	jmp    80193d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801938:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80193d:	83 c4 24             	add    $0x24,%esp
  801940:	5b                   	pop    %ebx
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    

00801943 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801949:	ba 00 00 00 00       	mov    $0x0,%edx
  80194e:	b8 08 00 00 00       	mov    $0x8,%eax
  801953:	e8 0b fd ff ff       	call   801663 <fsipc>
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    
  80195a:	66 90                	xchg   %ax,%ax
  80195c:	66 90                	xchg   %ax,%ax
  80195e:	66 90                	xchg   %ax,%ax

00801960 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801966:	c7 44 24 04 0f 2b 80 	movl   $0x802b0f,0x4(%esp)
  80196d:	00 
  80196e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801971:	89 04 24             	mov    %eax,(%esp)
  801974:	e8 6e ee ff ff       	call   8007e7 <strcpy>
	return 0;
}
  801979:	b8 00 00 00 00       	mov    $0x0,%eax
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	53                   	push   %ebx
  801984:	83 ec 14             	sub    $0x14,%esp
  801987:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80198a:	89 1c 24             	mov    %ebx,(%esp)
  80198d:	e8 5a 0a 00 00       	call   8023ec <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801992:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801997:	83 f8 01             	cmp    $0x1,%eax
  80199a:	75 0d                	jne    8019a9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80199c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80199f:	89 04 24             	mov    %eax,(%esp)
  8019a2:	e8 29 03 00 00       	call   801cd0 <nsipc_close>
  8019a7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8019a9:	89 d0                	mov    %edx,%eax
  8019ab:	83 c4 14             	add    $0x14,%esp
  8019ae:	5b                   	pop    %ebx
  8019af:	5d                   	pop    %ebp
  8019b0:	c3                   	ret    

008019b1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019b7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019be:	00 
  8019bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d3:	89 04 24             	mov    %eax,(%esp)
  8019d6:	e8 f0 03 00 00       	call   801dcb <nsipc_send>
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019e3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019ea:	00 
  8019eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ff:	89 04 24             	mov    %eax,(%esp)
  801a02:	e8 44 03 00 00       	call   801d4b <nsipc_recv>
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801a0f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a12:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a16:	89 04 24             	mov    %eax,(%esp)
  801a19:	e8 d8 f6 ff ff       	call   8010f6 <fd_lookup>
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	78 17                	js     801a39 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a25:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a2b:	39 08                	cmp    %ecx,(%eax)
  801a2d:	75 05                	jne    801a34 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801a2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a32:	eb 05                	jmp    801a39 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801a34:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	56                   	push   %esi
  801a3f:	53                   	push   %ebx
  801a40:	83 ec 20             	sub    $0x20,%esp
  801a43:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a48:	89 04 24             	mov    %eax,(%esp)
  801a4b:	e8 57 f6 ff ff       	call   8010a7 <fd_alloc>
  801a50:	89 c3                	mov    %eax,%ebx
  801a52:	85 c0                	test   %eax,%eax
  801a54:	78 21                	js     801a77 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a56:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a5d:	00 
  801a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a61:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a6c:	e8 92 f1 ff ff       	call   800c03 <sys_page_alloc>
  801a71:	89 c3                	mov    %eax,%ebx
  801a73:	85 c0                	test   %eax,%eax
  801a75:	79 0c                	jns    801a83 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801a77:	89 34 24             	mov    %esi,(%esp)
  801a7a:	e8 51 02 00 00       	call   801cd0 <nsipc_close>
		return r;
  801a7f:	89 d8                	mov    %ebx,%eax
  801a81:	eb 20                	jmp    801aa3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801a83:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a91:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801a98:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801a9b:	89 14 24             	mov    %edx,(%esp)
  801a9e:	e8 dd f5 ff ff       	call   801080 <fd2num>
}
  801aa3:	83 c4 20             	add    $0x20,%esp
  801aa6:	5b                   	pop    %ebx
  801aa7:	5e                   	pop    %esi
  801aa8:	5d                   	pop    %ebp
  801aa9:	c3                   	ret    

00801aaa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
  801aad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	e8 51 ff ff ff       	call   801a09 <fd2sockid>
		return r;
  801ab8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801aba:	85 c0                	test   %eax,%eax
  801abc:	78 23                	js     801ae1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801abe:	8b 55 10             	mov    0x10(%ebp),%edx
  801ac1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801acc:	89 04 24             	mov    %eax,(%esp)
  801acf:	e8 45 01 00 00       	call   801c19 <nsipc_accept>
		return r;
  801ad4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ad6:	85 c0                	test   %eax,%eax
  801ad8:	78 07                	js     801ae1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801ada:	e8 5c ff ff ff       	call   801a3b <alloc_sockfd>
  801adf:	89 c1                	mov    %eax,%ecx
}
  801ae1:	89 c8                	mov    %ecx,%eax
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	e8 16 ff ff ff       	call   801a09 <fd2sockid>
  801af3:	89 c2                	mov    %eax,%edx
  801af5:	85 d2                	test   %edx,%edx
  801af7:	78 16                	js     801b0f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801af9:	8b 45 10             	mov    0x10(%ebp),%eax
  801afc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b07:	89 14 24             	mov    %edx,(%esp)
  801b0a:	e8 60 01 00 00       	call   801c6f <nsipc_bind>
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <shutdown>:

int
shutdown(int s, int how)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	e8 ea fe ff ff       	call   801a09 <fd2sockid>
  801b1f:	89 c2                	mov    %eax,%edx
  801b21:	85 d2                	test   %edx,%edx
  801b23:	78 0f                	js     801b34 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2c:	89 14 24             	mov    %edx,(%esp)
  801b2f:	e8 7a 01 00 00       	call   801cae <nsipc_shutdown>
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	e8 c5 fe ff ff       	call   801a09 <fd2sockid>
  801b44:	89 c2                	mov    %eax,%edx
  801b46:	85 d2                	test   %edx,%edx
  801b48:	78 16                	js     801b60 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801b4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b58:	89 14 24             	mov    %edx,(%esp)
  801b5b:	e8 8a 01 00 00       	call   801cea <nsipc_connect>
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <listen>:

int
listen(int s, int backlog)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	e8 99 fe ff ff       	call   801a09 <fd2sockid>
  801b70:	89 c2                	mov    %eax,%edx
  801b72:	85 d2                	test   %edx,%edx
  801b74:	78 0f                	js     801b85 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7d:	89 14 24             	mov    %edx,(%esp)
  801b80:	e8 a4 01 00 00       	call   801d29 <nsipc_listen>
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b90:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	89 04 24             	mov    %eax,(%esp)
  801ba1:	e8 98 02 00 00       	call   801e3e <nsipc_socket>
  801ba6:	89 c2                	mov    %eax,%edx
  801ba8:	85 d2                	test   %edx,%edx
  801baa:	78 05                	js     801bb1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801bac:	e8 8a fe ff ff       	call   801a3b <alloc_sockfd>
}
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	53                   	push   %ebx
  801bb7:	83 ec 14             	sub    $0x14,%esp
  801bba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bbc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bc3:	75 11                	jne    801bd6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bc5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801bcc:	e8 74 f4 ff ff       	call   801045 <ipc_find_env>
  801bd1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bd6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bdd:	00 
  801bde:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801be5:	00 
  801be6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bea:	a1 04 40 80 00       	mov    0x804004,%eax
  801bef:	89 04 24             	mov    %eax,(%esp)
  801bf2:	e8 c1 f3 ff ff       	call   800fb8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bf7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bfe:	00 
  801bff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c06:	00 
  801c07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0e:	e8 3d f3 ff ff       	call   800f50 <ipc_recv>
}
  801c13:	83 c4 14             	add    $0x14,%esp
  801c16:	5b                   	pop    %ebx
  801c17:	5d                   	pop    %ebp
  801c18:	c3                   	ret    

00801c19 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	56                   	push   %esi
  801c1d:	53                   	push   %ebx
  801c1e:	83 ec 10             	sub    $0x10,%esp
  801c21:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c2c:	8b 06                	mov    (%esi),%eax
  801c2e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c33:	b8 01 00 00 00       	mov    $0x1,%eax
  801c38:	e8 76 ff ff ff       	call   801bb3 <nsipc>
  801c3d:	89 c3                	mov    %eax,%ebx
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	78 23                	js     801c66 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c43:	a1 10 60 80 00       	mov    0x806010,%eax
  801c48:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c4c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c53:	00 
  801c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c57:	89 04 24             	mov    %eax,(%esp)
  801c5a:	e8 25 ed ff ff       	call   800984 <memmove>
		*addrlen = ret->ret_addrlen;
  801c5f:	a1 10 60 80 00       	mov    0x806010,%eax
  801c64:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801c66:	89 d8                	mov    %ebx,%eax
  801c68:	83 c4 10             	add    $0x10,%esp
  801c6b:	5b                   	pop    %ebx
  801c6c:	5e                   	pop    %esi
  801c6d:	5d                   	pop    %ebp
  801c6e:	c3                   	ret    

00801c6f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	53                   	push   %ebx
  801c73:	83 ec 14             	sub    $0x14,%esp
  801c76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c81:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c8c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c93:	e8 ec ec ff ff       	call   800984 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c98:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c9e:	b8 02 00 00 00       	mov    $0x2,%eax
  801ca3:	e8 0b ff ff ff       	call   801bb3 <nsipc>
}
  801ca8:	83 c4 14             	add    $0x14,%esp
  801cab:	5b                   	pop    %ebx
  801cac:	5d                   	pop    %ebp
  801cad:	c3                   	ret    

00801cae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801cc4:	b8 03 00 00 00       	mov    $0x3,%eax
  801cc9:	e8 e5 fe ff ff       	call   801bb3 <nsipc>
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <nsipc_close>:

int
nsipc_close(int s)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cde:	b8 04 00 00 00       	mov    $0x4,%eax
  801ce3:	e8 cb fe ff ff       	call   801bb3 <nsipc>
}
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	53                   	push   %ebx
  801cee:	83 ec 14             	sub    $0x14,%esp
  801cf1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cfc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d07:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d0e:	e8 71 ec ff ff       	call   800984 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d13:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d19:	b8 05 00 00 00       	mov    $0x5,%eax
  801d1e:	e8 90 fe ff ff       	call   801bb3 <nsipc>
}
  801d23:	83 c4 14             	add    $0x14,%esp
  801d26:	5b                   	pop    %ebx
  801d27:	5d                   	pop    %ebp
  801d28:	c3                   	ret    

00801d29 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d3f:	b8 06 00 00 00       	mov    $0x6,%eax
  801d44:	e8 6a fe ff ff       	call   801bb3 <nsipc>
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	56                   	push   %esi
  801d4f:	53                   	push   %ebx
  801d50:	83 ec 10             	sub    $0x10,%esp
  801d53:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d5e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d64:	8b 45 14             	mov    0x14(%ebp),%eax
  801d67:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d6c:	b8 07 00 00 00       	mov    $0x7,%eax
  801d71:	e8 3d fe ff ff       	call   801bb3 <nsipc>
  801d76:	89 c3                	mov    %eax,%ebx
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	78 46                	js     801dc2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801d7c:	39 f0                	cmp    %esi,%eax
  801d7e:	7f 07                	jg     801d87 <nsipc_recv+0x3c>
  801d80:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d85:	7e 24                	jle    801dab <nsipc_recv+0x60>
  801d87:	c7 44 24 0c 1b 2b 80 	movl   $0x802b1b,0xc(%esp)
  801d8e:	00 
  801d8f:	c7 44 24 08 e3 2a 80 	movl   $0x802ae3,0x8(%esp)
  801d96:	00 
  801d97:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801d9e:	00 
  801d9f:	c7 04 24 30 2b 80 00 	movl   $0x802b30,(%esp)
  801da6:	e8 eb 05 00 00       	call   802396 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801dab:	89 44 24 08          	mov    %eax,0x8(%esp)
  801daf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801db6:	00 
  801db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dba:	89 04 24             	mov    %eax,(%esp)
  801dbd:	e8 c2 eb ff ff       	call   800984 <memmove>
	}

	return r;
}
  801dc2:	89 d8                	mov    %ebx,%eax
  801dc4:	83 c4 10             	add    $0x10,%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    

00801dcb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	53                   	push   %ebx
  801dcf:	83 ec 14             	sub    $0x14,%esp
  801dd2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ddd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801de3:	7e 24                	jle    801e09 <nsipc_send+0x3e>
  801de5:	c7 44 24 0c 3c 2b 80 	movl   $0x802b3c,0xc(%esp)
  801dec:	00 
  801ded:	c7 44 24 08 e3 2a 80 	movl   $0x802ae3,0x8(%esp)
  801df4:	00 
  801df5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801dfc:	00 
  801dfd:	c7 04 24 30 2b 80 00 	movl   $0x802b30,(%esp)
  801e04:	e8 8d 05 00 00       	call   802396 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e14:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801e1b:	e8 64 eb ff ff       	call   800984 <memmove>
	nsipcbuf.send.req_size = size;
  801e20:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e26:	8b 45 14             	mov    0x14(%ebp),%eax
  801e29:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e2e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e33:	e8 7b fd ff ff       	call   801bb3 <nsipc>
}
  801e38:	83 c4 14             	add    $0x14,%esp
  801e3b:	5b                   	pop    %ebx
  801e3c:	5d                   	pop    %ebp
  801e3d:	c3                   	ret    

00801e3e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e54:	8b 45 10             	mov    0x10(%ebp),%eax
  801e57:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e5c:	b8 09 00 00 00       	mov    $0x9,%eax
  801e61:	e8 4d fd ff ff       	call   801bb3 <nsipc>
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	56                   	push   %esi
  801e6c:	53                   	push   %ebx
  801e6d:	83 ec 10             	sub    $0x10,%esp
  801e70:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e73:	8b 45 08             	mov    0x8(%ebp),%eax
  801e76:	89 04 24             	mov    %eax,(%esp)
  801e79:	e8 12 f2 ff ff       	call   801090 <fd2data>
  801e7e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e80:	c7 44 24 04 48 2b 80 	movl   $0x802b48,0x4(%esp)
  801e87:	00 
  801e88:	89 1c 24             	mov    %ebx,(%esp)
  801e8b:	e8 57 e9 ff ff       	call   8007e7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e90:	8b 46 04             	mov    0x4(%esi),%eax
  801e93:	2b 06                	sub    (%esi),%eax
  801e95:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e9b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ea2:	00 00 00 
	stat->st_dev = &devpipe;
  801ea5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801eac:	30 80 00 
	return 0;
}
  801eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb4:	83 c4 10             	add    $0x10,%esp
  801eb7:	5b                   	pop    %ebx
  801eb8:	5e                   	pop    %esi
  801eb9:	5d                   	pop    %ebp
  801eba:	c3                   	ret    

00801ebb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	53                   	push   %ebx
  801ebf:	83 ec 14             	sub    $0x14,%esp
  801ec2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ec5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ec9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ed0:	e8 d5 ed ff ff       	call   800caa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ed5:	89 1c 24             	mov    %ebx,(%esp)
  801ed8:	e8 b3 f1 ff ff       	call   801090 <fd2data>
  801edd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ee8:	e8 bd ed ff ff       	call   800caa <sys_page_unmap>
}
  801eed:	83 c4 14             	add    $0x14,%esp
  801ef0:	5b                   	pop    %ebx
  801ef1:	5d                   	pop    %ebp
  801ef2:	c3                   	ret    

00801ef3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	57                   	push   %edi
  801ef7:	56                   	push   %esi
  801ef8:	53                   	push   %ebx
  801ef9:	83 ec 2c             	sub    $0x2c,%esp
  801efc:	89 c6                	mov    %eax,%esi
  801efe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801f01:	a1 08 40 80 00       	mov    0x804008,%eax
  801f06:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f09:	89 34 24             	mov    %esi,(%esp)
  801f0c:	e8 db 04 00 00       	call   8023ec <pageref>
  801f11:	89 c7                	mov    %eax,%edi
  801f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f16:	89 04 24             	mov    %eax,(%esp)
  801f19:	e8 ce 04 00 00       	call   8023ec <pageref>
  801f1e:	39 c7                	cmp    %eax,%edi
  801f20:	0f 94 c2             	sete   %dl
  801f23:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801f26:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801f2c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801f2f:	39 fb                	cmp    %edi,%ebx
  801f31:	74 21                	je     801f54 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801f33:	84 d2                	test   %dl,%dl
  801f35:	74 ca                	je     801f01 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f37:	8b 51 58             	mov    0x58(%ecx),%edx
  801f3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f3e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f46:	c7 04 24 4f 2b 80 00 	movl   $0x802b4f,(%esp)
  801f4d:	e8 74 e2 ff ff       	call   8001c6 <cprintf>
  801f52:	eb ad                	jmp    801f01 <_pipeisclosed+0xe>
	}
}
  801f54:	83 c4 2c             	add    $0x2c,%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5f                   	pop    %edi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    

00801f5c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	57                   	push   %edi
  801f60:	56                   	push   %esi
  801f61:	53                   	push   %ebx
  801f62:	83 ec 1c             	sub    $0x1c,%esp
  801f65:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801f68:	89 34 24             	mov    %esi,(%esp)
  801f6b:	e8 20 f1 ff ff       	call   801090 <fd2data>
  801f70:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f72:	bf 00 00 00 00       	mov    $0x0,%edi
  801f77:	eb 45                	jmp    801fbe <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f79:	89 da                	mov    %ebx,%edx
  801f7b:	89 f0                	mov    %esi,%eax
  801f7d:	e8 71 ff ff ff       	call   801ef3 <_pipeisclosed>
  801f82:	85 c0                	test   %eax,%eax
  801f84:	75 41                	jne    801fc7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f86:	e8 59 ec ff ff       	call   800be4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f8b:	8b 43 04             	mov    0x4(%ebx),%eax
  801f8e:	8b 0b                	mov    (%ebx),%ecx
  801f90:	8d 51 20             	lea    0x20(%ecx),%edx
  801f93:	39 d0                	cmp    %edx,%eax
  801f95:	73 e2                	jae    801f79 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f9a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f9e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801fa1:	99                   	cltd   
  801fa2:	c1 ea 1b             	shr    $0x1b,%edx
  801fa5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801fa8:	83 e1 1f             	and    $0x1f,%ecx
  801fab:	29 d1                	sub    %edx,%ecx
  801fad:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801fb1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801fb5:	83 c0 01             	add    $0x1,%eax
  801fb8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fbb:	83 c7 01             	add    $0x1,%edi
  801fbe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fc1:	75 c8                	jne    801f8b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801fc3:	89 f8                	mov    %edi,%eax
  801fc5:	eb 05                	jmp    801fcc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fc7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801fcc:	83 c4 1c             	add    $0x1c,%esp
  801fcf:	5b                   	pop    %ebx
  801fd0:	5e                   	pop    %esi
  801fd1:	5f                   	pop    %edi
  801fd2:	5d                   	pop    %ebp
  801fd3:	c3                   	ret    

00801fd4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	57                   	push   %edi
  801fd8:	56                   	push   %esi
  801fd9:	53                   	push   %ebx
  801fda:	83 ec 1c             	sub    $0x1c,%esp
  801fdd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801fe0:	89 3c 24             	mov    %edi,(%esp)
  801fe3:	e8 a8 f0 ff ff       	call   801090 <fd2data>
  801fe8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fea:	be 00 00 00 00       	mov    $0x0,%esi
  801fef:	eb 3d                	jmp    80202e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801ff1:	85 f6                	test   %esi,%esi
  801ff3:	74 04                	je     801ff9 <devpipe_read+0x25>
				return i;
  801ff5:	89 f0                	mov    %esi,%eax
  801ff7:	eb 43                	jmp    80203c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ff9:	89 da                	mov    %ebx,%edx
  801ffb:	89 f8                	mov    %edi,%eax
  801ffd:	e8 f1 fe ff ff       	call   801ef3 <_pipeisclosed>
  802002:	85 c0                	test   %eax,%eax
  802004:	75 31                	jne    802037 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802006:	e8 d9 eb ff ff       	call   800be4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80200b:	8b 03                	mov    (%ebx),%eax
  80200d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802010:	74 df                	je     801ff1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802012:	99                   	cltd   
  802013:	c1 ea 1b             	shr    $0x1b,%edx
  802016:	01 d0                	add    %edx,%eax
  802018:	83 e0 1f             	and    $0x1f,%eax
  80201b:	29 d0                	sub    %edx,%eax
  80201d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802022:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802025:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802028:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80202b:	83 c6 01             	add    $0x1,%esi
  80202e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802031:	75 d8                	jne    80200b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802033:	89 f0                	mov    %esi,%eax
  802035:	eb 05                	jmp    80203c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802037:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80203c:	83 c4 1c             	add    $0x1c,%esp
  80203f:	5b                   	pop    %ebx
  802040:	5e                   	pop    %esi
  802041:	5f                   	pop    %edi
  802042:	5d                   	pop    %ebp
  802043:	c3                   	ret    

00802044 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	56                   	push   %esi
  802048:	53                   	push   %ebx
  802049:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80204c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80204f:	89 04 24             	mov    %eax,(%esp)
  802052:	e8 50 f0 ff ff       	call   8010a7 <fd_alloc>
  802057:	89 c2                	mov    %eax,%edx
  802059:	85 d2                	test   %edx,%edx
  80205b:	0f 88 4d 01 00 00    	js     8021ae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802061:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802068:	00 
  802069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802070:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802077:	e8 87 eb ff ff       	call   800c03 <sys_page_alloc>
  80207c:	89 c2                	mov    %eax,%edx
  80207e:	85 d2                	test   %edx,%edx
  802080:	0f 88 28 01 00 00    	js     8021ae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802086:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802089:	89 04 24             	mov    %eax,(%esp)
  80208c:	e8 16 f0 ff ff       	call   8010a7 <fd_alloc>
  802091:	89 c3                	mov    %eax,%ebx
  802093:	85 c0                	test   %eax,%eax
  802095:	0f 88 fe 00 00 00    	js     802199 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80209b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020a2:	00 
  8020a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b1:	e8 4d eb ff ff       	call   800c03 <sys_page_alloc>
  8020b6:	89 c3                	mov    %eax,%ebx
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	0f 88 d9 00 00 00    	js     802199 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8020c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c3:	89 04 24             	mov    %eax,(%esp)
  8020c6:	e8 c5 ef ff ff       	call   801090 <fd2data>
  8020cb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020cd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020d4:	00 
  8020d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020e0:	e8 1e eb ff ff       	call   800c03 <sys_page_alloc>
  8020e5:	89 c3                	mov    %eax,%ebx
  8020e7:	85 c0                	test   %eax,%eax
  8020e9:	0f 88 97 00 00 00    	js     802186 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f2:	89 04 24             	mov    %eax,(%esp)
  8020f5:	e8 96 ef ff ff       	call   801090 <fd2data>
  8020fa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802101:	00 
  802102:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802106:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80210d:	00 
  80210e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802112:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802119:	e8 39 eb ff ff       	call   800c57 <sys_page_map>
  80211e:	89 c3                	mov    %eax,%ebx
  802120:	85 c0                	test   %eax,%eax
  802122:	78 52                	js     802176 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802124:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80212a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802139:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80213f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802142:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802144:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802147:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80214e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802151:	89 04 24             	mov    %eax,(%esp)
  802154:	e8 27 ef ff ff       	call   801080 <fd2num>
  802159:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80215c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80215e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802161:	89 04 24             	mov    %eax,(%esp)
  802164:	e8 17 ef ff ff       	call   801080 <fd2num>
  802169:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80216c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80216f:	b8 00 00 00 00       	mov    $0x0,%eax
  802174:	eb 38                	jmp    8021ae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802176:	89 74 24 04          	mov    %esi,0x4(%esp)
  80217a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802181:	e8 24 eb ff ff       	call   800caa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802189:	89 44 24 04          	mov    %eax,0x4(%esp)
  80218d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802194:	e8 11 eb ff ff       	call   800caa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a7:	e8 fe ea ff ff       	call   800caa <sys_page_unmap>
  8021ac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8021ae:	83 c4 30             	add    $0x30,%esp
  8021b1:	5b                   	pop    %ebx
  8021b2:	5e                   	pop    %esi
  8021b3:	5d                   	pop    %ebp
  8021b4:	c3                   	ret    

008021b5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
  8021b8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	89 04 24             	mov    %eax,(%esp)
  8021c8:	e8 29 ef ff ff       	call   8010f6 <fd_lookup>
  8021cd:	89 c2                	mov    %eax,%edx
  8021cf:	85 d2                	test   %edx,%edx
  8021d1:	78 15                	js     8021e8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8021d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d6:	89 04 24             	mov    %eax,(%esp)
  8021d9:	e8 b2 ee ff ff       	call   801090 <fd2data>
	return _pipeisclosed(fd, p);
  8021de:	89 c2                	mov    %eax,%edx
  8021e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e3:	e8 0b fd ff ff       	call   801ef3 <_pipeisclosed>
}
  8021e8:	c9                   	leave  
  8021e9:	c3                   	ret    
  8021ea:	66 90                	xchg   %ax,%ax
  8021ec:	66 90                	xchg   %ax,%ax
  8021ee:	66 90                	xchg   %ax,%ax

008021f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f8:	5d                   	pop    %ebp
  8021f9:	c3                   	ret    

008021fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802200:	c7 44 24 04 67 2b 80 	movl   $0x802b67,0x4(%esp)
  802207:	00 
  802208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220b:	89 04 24             	mov    %eax,(%esp)
  80220e:	e8 d4 e5 ff ff       	call   8007e7 <strcpy>
	return 0;
}
  802213:	b8 00 00 00 00       	mov    $0x0,%eax
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	57                   	push   %edi
  80221e:	56                   	push   %esi
  80221f:	53                   	push   %ebx
  802220:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802226:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80222b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802231:	eb 31                	jmp    802264 <devcons_write+0x4a>
		m = n - tot;
  802233:	8b 75 10             	mov    0x10(%ebp),%esi
  802236:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802238:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80223b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802240:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802243:	89 74 24 08          	mov    %esi,0x8(%esp)
  802247:	03 45 0c             	add    0xc(%ebp),%eax
  80224a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224e:	89 3c 24             	mov    %edi,(%esp)
  802251:	e8 2e e7 ff ff       	call   800984 <memmove>
		sys_cputs(buf, m);
  802256:	89 74 24 04          	mov    %esi,0x4(%esp)
  80225a:	89 3c 24             	mov    %edi,(%esp)
  80225d:	e8 d4 e8 ff ff       	call   800b36 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802262:	01 f3                	add    %esi,%ebx
  802264:	89 d8                	mov    %ebx,%eax
  802266:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802269:	72 c8                	jb     802233 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80226b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802271:	5b                   	pop    %ebx
  802272:	5e                   	pop    %esi
  802273:	5f                   	pop    %edi
  802274:	5d                   	pop    %ebp
  802275:	c3                   	ret    

00802276 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
  802279:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80227c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802281:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802285:	75 07                	jne    80228e <devcons_read+0x18>
  802287:	eb 2a                	jmp    8022b3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802289:	e8 56 e9 ff ff       	call   800be4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80228e:	66 90                	xchg   %ax,%ax
  802290:	e8 bf e8 ff ff       	call   800b54 <sys_cgetc>
  802295:	85 c0                	test   %eax,%eax
  802297:	74 f0                	je     802289 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802299:	85 c0                	test   %eax,%eax
  80229b:	78 16                	js     8022b3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80229d:	83 f8 04             	cmp    $0x4,%eax
  8022a0:	74 0c                	je     8022ae <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8022a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a5:	88 02                	mov    %al,(%edx)
	return 1;
  8022a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ac:	eb 05                	jmp    8022b3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8022ae:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
  8022b8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022c8:	00 
  8022c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022cc:	89 04 24             	mov    %eax,(%esp)
  8022cf:	e8 62 e8 ff ff       	call   800b36 <sys_cputs>
}
  8022d4:	c9                   	leave  
  8022d5:	c3                   	ret    

008022d6 <getchar>:

int
getchar(void)
{
  8022d6:	55                   	push   %ebp
  8022d7:	89 e5                	mov    %esp,%ebp
  8022d9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8022dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8022e3:	00 
  8022e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022f2:	e8 93 f0 ff ff       	call   80138a <read>
	if (r < 0)
  8022f7:	85 c0                	test   %eax,%eax
  8022f9:	78 0f                	js     80230a <getchar+0x34>
		return r;
	if (r < 1)
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	7e 06                	jle    802305 <getchar+0x2f>
		return -E_EOF;
	return c;
  8022ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802303:	eb 05                	jmp    80230a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802305:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802312:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802315:	89 44 24 04          	mov    %eax,0x4(%esp)
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	89 04 24             	mov    %eax,(%esp)
  80231f:	e8 d2 ed ff ff       	call   8010f6 <fd_lookup>
  802324:	85 c0                	test   %eax,%eax
  802326:	78 11                	js     802339 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802331:	39 10                	cmp    %edx,(%eax)
  802333:	0f 94 c0             	sete   %al
  802336:	0f b6 c0             	movzbl %al,%eax
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <opencons>:

int
opencons(void)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802341:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802344:	89 04 24             	mov    %eax,(%esp)
  802347:	e8 5b ed ff ff       	call   8010a7 <fd_alloc>
		return r;
  80234c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80234e:	85 c0                	test   %eax,%eax
  802350:	78 40                	js     802392 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802352:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802359:	00 
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802361:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802368:	e8 96 e8 ff ff       	call   800c03 <sys_page_alloc>
		return r;
  80236d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80236f:	85 c0                	test   %eax,%eax
  802371:	78 1f                	js     802392 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802373:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80237e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802381:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802388:	89 04 24             	mov    %eax,(%esp)
  80238b:	e8 f0 ec ff ff       	call   801080 <fd2num>
  802390:	89 c2                	mov    %eax,%edx
}
  802392:	89 d0                	mov    %edx,%eax
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	56                   	push   %esi
  80239a:	53                   	push   %ebx
  80239b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80239e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8023a1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8023a7:	e8 19 e8 ff ff       	call   800bc5 <sys_getenvid>
  8023ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023af:	89 54 24 10          	mov    %edx,0x10(%esp)
  8023b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8023b6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8023ba:	89 74 24 08          	mov    %esi,0x8(%esp)
  8023be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c2:	c7 04 24 74 2b 80 00 	movl   $0x802b74,(%esp)
  8023c9:	e8 f8 dd ff ff       	call   8001c6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8023ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d5:	89 04 24             	mov    %eax,(%esp)
  8023d8:	e8 88 dd ff ff       	call   800165 <vcprintf>
	cprintf("\n");
  8023dd:	c7 04 24 60 2b 80 00 	movl   $0x802b60,(%esp)
  8023e4:	e8 dd dd ff ff       	call   8001c6 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8023e9:	cc                   	int3   
  8023ea:	eb fd                	jmp    8023e9 <_panic+0x53>

008023ec <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
  8023ef:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023f2:	89 d0                	mov    %edx,%eax
  8023f4:	c1 e8 16             	shr    $0x16,%eax
  8023f7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023fe:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802403:	f6 c1 01             	test   $0x1,%cl
  802406:	74 1d                	je     802425 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802408:	c1 ea 0c             	shr    $0xc,%edx
  80240b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802412:	f6 c2 01             	test   $0x1,%dl
  802415:	74 0e                	je     802425 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802417:	c1 ea 0c             	shr    $0xc,%edx
  80241a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802421:	ef 
  802422:	0f b7 c0             	movzwl %ax,%eax
}
  802425:	5d                   	pop    %ebp
  802426:	c3                   	ret    
  802427:	66 90                	xchg   %ax,%ax
  802429:	66 90                	xchg   %ax,%ax
  80242b:	66 90                	xchg   %ax,%ax
  80242d:	66 90                	xchg   %ax,%ax
  80242f:	90                   	nop

00802430 <__udivdi3>:
  802430:	55                   	push   %ebp
  802431:	57                   	push   %edi
  802432:	56                   	push   %esi
  802433:	83 ec 0c             	sub    $0xc,%esp
  802436:	8b 44 24 28          	mov    0x28(%esp),%eax
  80243a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80243e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802442:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802446:	85 c0                	test   %eax,%eax
  802448:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80244c:	89 ea                	mov    %ebp,%edx
  80244e:	89 0c 24             	mov    %ecx,(%esp)
  802451:	75 2d                	jne    802480 <__udivdi3+0x50>
  802453:	39 e9                	cmp    %ebp,%ecx
  802455:	77 61                	ja     8024b8 <__udivdi3+0x88>
  802457:	85 c9                	test   %ecx,%ecx
  802459:	89 ce                	mov    %ecx,%esi
  80245b:	75 0b                	jne    802468 <__udivdi3+0x38>
  80245d:	b8 01 00 00 00       	mov    $0x1,%eax
  802462:	31 d2                	xor    %edx,%edx
  802464:	f7 f1                	div    %ecx
  802466:	89 c6                	mov    %eax,%esi
  802468:	31 d2                	xor    %edx,%edx
  80246a:	89 e8                	mov    %ebp,%eax
  80246c:	f7 f6                	div    %esi
  80246e:	89 c5                	mov    %eax,%ebp
  802470:	89 f8                	mov    %edi,%eax
  802472:	f7 f6                	div    %esi
  802474:	89 ea                	mov    %ebp,%edx
  802476:	83 c4 0c             	add    $0xc,%esp
  802479:	5e                   	pop    %esi
  80247a:	5f                   	pop    %edi
  80247b:	5d                   	pop    %ebp
  80247c:	c3                   	ret    
  80247d:	8d 76 00             	lea    0x0(%esi),%esi
  802480:	39 e8                	cmp    %ebp,%eax
  802482:	77 24                	ja     8024a8 <__udivdi3+0x78>
  802484:	0f bd e8             	bsr    %eax,%ebp
  802487:	83 f5 1f             	xor    $0x1f,%ebp
  80248a:	75 3c                	jne    8024c8 <__udivdi3+0x98>
  80248c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802490:	39 34 24             	cmp    %esi,(%esp)
  802493:	0f 86 9f 00 00 00    	jbe    802538 <__udivdi3+0x108>
  802499:	39 d0                	cmp    %edx,%eax
  80249b:	0f 82 97 00 00 00    	jb     802538 <__udivdi3+0x108>
  8024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024a8:	31 d2                	xor    %edx,%edx
  8024aa:	31 c0                	xor    %eax,%eax
  8024ac:	83 c4 0c             	add    $0xc,%esp
  8024af:	5e                   	pop    %esi
  8024b0:	5f                   	pop    %edi
  8024b1:	5d                   	pop    %ebp
  8024b2:	c3                   	ret    
  8024b3:	90                   	nop
  8024b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024b8:	89 f8                	mov    %edi,%eax
  8024ba:	f7 f1                	div    %ecx
  8024bc:	31 d2                	xor    %edx,%edx
  8024be:	83 c4 0c             	add    $0xc,%esp
  8024c1:	5e                   	pop    %esi
  8024c2:	5f                   	pop    %edi
  8024c3:	5d                   	pop    %ebp
  8024c4:	c3                   	ret    
  8024c5:	8d 76 00             	lea    0x0(%esi),%esi
  8024c8:	89 e9                	mov    %ebp,%ecx
  8024ca:	8b 3c 24             	mov    (%esp),%edi
  8024cd:	d3 e0                	shl    %cl,%eax
  8024cf:	89 c6                	mov    %eax,%esi
  8024d1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024d6:	29 e8                	sub    %ebp,%eax
  8024d8:	89 c1                	mov    %eax,%ecx
  8024da:	d3 ef                	shr    %cl,%edi
  8024dc:	89 e9                	mov    %ebp,%ecx
  8024de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024e2:	8b 3c 24             	mov    (%esp),%edi
  8024e5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024e9:	89 d6                	mov    %edx,%esi
  8024eb:	d3 e7                	shl    %cl,%edi
  8024ed:	89 c1                	mov    %eax,%ecx
  8024ef:	89 3c 24             	mov    %edi,(%esp)
  8024f2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024f6:	d3 ee                	shr    %cl,%esi
  8024f8:	89 e9                	mov    %ebp,%ecx
  8024fa:	d3 e2                	shl    %cl,%edx
  8024fc:	89 c1                	mov    %eax,%ecx
  8024fe:	d3 ef                	shr    %cl,%edi
  802500:	09 d7                	or     %edx,%edi
  802502:	89 f2                	mov    %esi,%edx
  802504:	89 f8                	mov    %edi,%eax
  802506:	f7 74 24 08          	divl   0x8(%esp)
  80250a:	89 d6                	mov    %edx,%esi
  80250c:	89 c7                	mov    %eax,%edi
  80250e:	f7 24 24             	mull   (%esp)
  802511:	39 d6                	cmp    %edx,%esi
  802513:	89 14 24             	mov    %edx,(%esp)
  802516:	72 30                	jb     802548 <__udivdi3+0x118>
  802518:	8b 54 24 04          	mov    0x4(%esp),%edx
  80251c:	89 e9                	mov    %ebp,%ecx
  80251e:	d3 e2                	shl    %cl,%edx
  802520:	39 c2                	cmp    %eax,%edx
  802522:	73 05                	jae    802529 <__udivdi3+0xf9>
  802524:	3b 34 24             	cmp    (%esp),%esi
  802527:	74 1f                	je     802548 <__udivdi3+0x118>
  802529:	89 f8                	mov    %edi,%eax
  80252b:	31 d2                	xor    %edx,%edx
  80252d:	e9 7a ff ff ff       	jmp    8024ac <__udivdi3+0x7c>
  802532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802538:	31 d2                	xor    %edx,%edx
  80253a:	b8 01 00 00 00       	mov    $0x1,%eax
  80253f:	e9 68 ff ff ff       	jmp    8024ac <__udivdi3+0x7c>
  802544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802548:	8d 47 ff             	lea    -0x1(%edi),%eax
  80254b:	31 d2                	xor    %edx,%edx
  80254d:	83 c4 0c             	add    $0xc,%esp
  802550:	5e                   	pop    %esi
  802551:	5f                   	pop    %edi
  802552:	5d                   	pop    %ebp
  802553:	c3                   	ret    
  802554:	66 90                	xchg   %ax,%ax
  802556:	66 90                	xchg   %ax,%ax
  802558:	66 90                	xchg   %ax,%ax
  80255a:	66 90                	xchg   %ax,%ax
  80255c:	66 90                	xchg   %ax,%ax
  80255e:	66 90                	xchg   %ax,%ax

00802560 <__umoddi3>:
  802560:	55                   	push   %ebp
  802561:	57                   	push   %edi
  802562:	56                   	push   %esi
  802563:	83 ec 14             	sub    $0x14,%esp
  802566:	8b 44 24 28          	mov    0x28(%esp),%eax
  80256a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80256e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802572:	89 c7                	mov    %eax,%edi
  802574:	89 44 24 04          	mov    %eax,0x4(%esp)
  802578:	8b 44 24 30          	mov    0x30(%esp),%eax
  80257c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802580:	89 34 24             	mov    %esi,(%esp)
  802583:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802587:	85 c0                	test   %eax,%eax
  802589:	89 c2                	mov    %eax,%edx
  80258b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80258f:	75 17                	jne    8025a8 <__umoddi3+0x48>
  802591:	39 fe                	cmp    %edi,%esi
  802593:	76 4b                	jbe    8025e0 <__umoddi3+0x80>
  802595:	89 c8                	mov    %ecx,%eax
  802597:	89 fa                	mov    %edi,%edx
  802599:	f7 f6                	div    %esi
  80259b:	89 d0                	mov    %edx,%eax
  80259d:	31 d2                	xor    %edx,%edx
  80259f:	83 c4 14             	add    $0x14,%esp
  8025a2:	5e                   	pop    %esi
  8025a3:	5f                   	pop    %edi
  8025a4:	5d                   	pop    %ebp
  8025a5:	c3                   	ret    
  8025a6:	66 90                	xchg   %ax,%ax
  8025a8:	39 f8                	cmp    %edi,%eax
  8025aa:	77 54                	ja     802600 <__umoddi3+0xa0>
  8025ac:	0f bd e8             	bsr    %eax,%ebp
  8025af:	83 f5 1f             	xor    $0x1f,%ebp
  8025b2:	75 5c                	jne    802610 <__umoddi3+0xb0>
  8025b4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025b8:	39 3c 24             	cmp    %edi,(%esp)
  8025bb:	0f 87 e7 00 00 00    	ja     8026a8 <__umoddi3+0x148>
  8025c1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025c5:	29 f1                	sub    %esi,%ecx
  8025c7:	19 c7                	sbb    %eax,%edi
  8025c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025d1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025d5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025d9:	83 c4 14             	add    $0x14,%esp
  8025dc:	5e                   	pop    %esi
  8025dd:	5f                   	pop    %edi
  8025de:	5d                   	pop    %ebp
  8025df:	c3                   	ret    
  8025e0:	85 f6                	test   %esi,%esi
  8025e2:	89 f5                	mov    %esi,%ebp
  8025e4:	75 0b                	jne    8025f1 <__umoddi3+0x91>
  8025e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025eb:	31 d2                	xor    %edx,%edx
  8025ed:	f7 f6                	div    %esi
  8025ef:	89 c5                	mov    %eax,%ebp
  8025f1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025f5:	31 d2                	xor    %edx,%edx
  8025f7:	f7 f5                	div    %ebp
  8025f9:	89 c8                	mov    %ecx,%eax
  8025fb:	f7 f5                	div    %ebp
  8025fd:	eb 9c                	jmp    80259b <__umoddi3+0x3b>
  8025ff:	90                   	nop
  802600:	89 c8                	mov    %ecx,%eax
  802602:	89 fa                	mov    %edi,%edx
  802604:	83 c4 14             	add    $0x14,%esp
  802607:	5e                   	pop    %esi
  802608:	5f                   	pop    %edi
  802609:	5d                   	pop    %ebp
  80260a:	c3                   	ret    
  80260b:	90                   	nop
  80260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802610:	8b 04 24             	mov    (%esp),%eax
  802613:	be 20 00 00 00       	mov    $0x20,%esi
  802618:	89 e9                	mov    %ebp,%ecx
  80261a:	29 ee                	sub    %ebp,%esi
  80261c:	d3 e2                	shl    %cl,%edx
  80261e:	89 f1                	mov    %esi,%ecx
  802620:	d3 e8                	shr    %cl,%eax
  802622:	89 e9                	mov    %ebp,%ecx
  802624:	89 44 24 04          	mov    %eax,0x4(%esp)
  802628:	8b 04 24             	mov    (%esp),%eax
  80262b:	09 54 24 04          	or     %edx,0x4(%esp)
  80262f:	89 fa                	mov    %edi,%edx
  802631:	d3 e0                	shl    %cl,%eax
  802633:	89 f1                	mov    %esi,%ecx
  802635:	89 44 24 08          	mov    %eax,0x8(%esp)
  802639:	8b 44 24 10          	mov    0x10(%esp),%eax
  80263d:	d3 ea                	shr    %cl,%edx
  80263f:	89 e9                	mov    %ebp,%ecx
  802641:	d3 e7                	shl    %cl,%edi
  802643:	89 f1                	mov    %esi,%ecx
  802645:	d3 e8                	shr    %cl,%eax
  802647:	89 e9                	mov    %ebp,%ecx
  802649:	09 f8                	or     %edi,%eax
  80264b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80264f:	f7 74 24 04          	divl   0x4(%esp)
  802653:	d3 e7                	shl    %cl,%edi
  802655:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802659:	89 d7                	mov    %edx,%edi
  80265b:	f7 64 24 08          	mull   0x8(%esp)
  80265f:	39 d7                	cmp    %edx,%edi
  802661:	89 c1                	mov    %eax,%ecx
  802663:	89 14 24             	mov    %edx,(%esp)
  802666:	72 2c                	jb     802694 <__umoddi3+0x134>
  802668:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80266c:	72 22                	jb     802690 <__umoddi3+0x130>
  80266e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802672:	29 c8                	sub    %ecx,%eax
  802674:	19 d7                	sbb    %edx,%edi
  802676:	89 e9                	mov    %ebp,%ecx
  802678:	89 fa                	mov    %edi,%edx
  80267a:	d3 e8                	shr    %cl,%eax
  80267c:	89 f1                	mov    %esi,%ecx
  80267e:	d3 e2                	shl    %cl,%edx
  802680:	89 e9                	mov    %ebp,%ecx
  802682:	d3 ef                	shr    %cl,%edi
  802684:	09 d0                	or     %edx,%eax
  802686:	89 fa                	mov    %edi,%edx
  802688:	83 c4 14             	add    $0x14,%esp
  80268b:	5e                   	pop    %esi
  80268c:	5f                   	pop    %edi
  80268d:	5d                   	pop    %ebp
  80268e:	c3                   	ret    
  80268f:	90                   	nop
  802690:	39 d7                	cmp    %edx,%edi
  802692:	75 da                	jne    80266e <__umoddi3+0x10e>
  802694:	8b 14 24             	mov    (%esp),%edx
  802697:	89 c1                	mov    %eax,%ecx
  802699:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80269d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8026a1:	eb cb                	jmp    80266e <__umoddi3+0x10e>
  8026a3:	90                   	nop
  8026a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026a8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8026ac:	0f 82 0f ff ff ff    	jb     8025c1 <__umoddi3+0x61>
  8026b2:	e9 1a ff ff ff       	jmp    8025d1 <__umoddi3+0x71>
