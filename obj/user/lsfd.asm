
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 01 01 00 00       	call   800132 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	c7 04 24 c0 29 80 00 	movl   $0x8029c0,(%esp)
  800040:	e8 f1 01 00 00       	call   800236 <cprintf>
	exit();
  800045:	e8 30 01 00 00       	call   80017a <exit>
}
  80004a:	c9                   	leave  
  80004b:	c3                   	ret    

0080004c <umain>:

void
umain(int argc, char **argv)
{
  80004c:	55                   	push   %ebp
  80004d:	89 e5                	mov    %esp,%ebp
  80004f:	57                   	push   %edi
  800050:	56                   	push   %esi
  800051:	53                   	push   %ebx
  800052:	81 ec cc 00 00 00    	sub    $0xcc,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800058:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800062:	8b 45 0c             	mov    0xc(%ebp),%eax
  800065:	89 44 24 04          	mov    %eax,0x4(%esp)
  800069:	8d 45 08             	lea    0x8(%ebp),%eax
  80006c:	89 04 24             	mov    %eax,(%esp)
  80006f:	e8 3d 0f 00 00       	call   800fb1 <argstart>
}

void
umain(int argc, char **argv)
{
	int i, usefprint = 0;
  800074:	be 00 00 00 00       	mov    $0x0,%esi
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800079:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
  80007f:	eb 11                	jmp    800092 <umain+0x46>
		if (i == '1')
  800081:	83 f8 31             	cmp    $0x31,%eax
  800084:	75 07                	jne    80008d <umain+0x41>
			usefprint = 1;
  800086:	be 01 00 00 00       	mov    $0x1,%esi
  80008b:	eb 05                	jmp    800092 <umain+0x46>
		else
			usage();
  80008d:	e8 a1 ff ff ff       	call   800033 <usage>
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
	while ((i = argnext(&args)) >= 0)
  800092:	89 1c 24             	mov    %ebx,(%esp)
  800095:	e8 4f 0f 00 00       	call   800fe9 <argnext>
  80009a:	85 c0                	test   %eax,%eax
  80009c:	79 e3                	jns    800081 <umain+0x35>
  80009e:	bb 00 00 00 00       	mov    $0x0,%ebx
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
  8000a3:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  8000a9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8000ad:	89 1c 24             	mov    %ebx,(%esp)
  8000b0:	e8 81 15 00 00       	call   801636 <fstat>
  8000b5:	85 c0                	test   %eax,%eax
  8000b7:	78 66                	js     80011f <umain+0xd3>
			if (usefprint)
  8000b9:	85 f6                	test   %esi,%esi
  8000bb:	74 36                	je     8000f3 <umain+0xa7>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000c0:	8b 40 04             	mov    0x4(%eax),%eax
  8000c3:	89 44 24 18          	mov    %eax,0x18(%esp)
  8000c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000ca:	89 44 24 14          	mov    %eax,0x14(%esp)
  8000ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000d5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000dd:	c7 44 24 04 d4 29 80 	movl   $0x8029d4,0x4(%esp)
  8000e4:	00 
  8000e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000ec:	e8 ed 19 00 00       	call   801ade <fprintf>
  8000f1:	eb 2c                	jmp    80011f <umain+0xd3>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f6:	8b 40 04             	mov    0x4(%eax),%eax
  8000f9:	89 44 24 14          	mov    %eax,0x14(%esp)
  8000fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800100:	89 44 24 10          	mov    %eax,0x10(%esp)
  800104:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800107:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80010b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80010f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800113:	c7 04 24 d4 29 80 00 	movl   $0x8029d4,(%esp)
  80011a:	e8 17 01 00 00       	call   800236 <cprintf>
		if (i == '1')
			usefprint = 1;
		else
			usage();

	for (i = 0; i < 32; i++)
  80011f:	83 c3 01             	add    $0x1,%ebx
  800122:	83 fb 20             	cmp    $0x20,%ebx
  800125:	75 82                	jne    8000a9 <umain+0x5d>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  800127:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5f                   	pop    %edi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	56                   	push   %esi
  800136:	53                   	push   %ebx
  800137:	83 ec 10             	sub    $0x10,%esp
  80013a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80013d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800140:	e8 f0 0a 00 00       	call   800c35 <sys_getenvid>
  800145:	25 ff 03 00 00       	and    $0x3ff,%eax
  80014a:	c1 e0 07             	shl    $0x7,%eax
  80014d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800152:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800157:	85 db                	test   %ebx,%ebx
  800159:	7e 07                	jle    800162 <libmain+0x30>
		binaryname = argv[0];
  80015b:	8b 06                	mov    (%esi),%eax
  80015d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800162:	89 74 24 04          	mov    %esi,0x4(%esp)
  800166:	89 1c 24             	mov    %ebx,(%esp)
  800169:	e8 de fe ff ff       	call   80004c <umain>

	// exit gracefully
	exit();
  80016e:	e8 07 00 00 00       	call   80017a <exit>
}
  800173:	83 c4 10             	add    $0x10,%esp
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5d                   	pop    %ebp
  800179:	c3                   	ret    

0080017a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800180:	e8 65 11 00 00       	call   8012ea <close_all>
	sys_env_destroy(0);
  800185:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80018c:	e8 52 0a 00 00       	call   800be3 <sys_env_destroy>
}
  800191:	c9                   	leave  
  800192:	c3                   	ret    

00800193 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800193:	55                   	push   %ebp
  800194:	89 e5                	mov    %esp,%ebp
  800196:	53                   	push   %ebx
  800197:	83 ec 14             	sub    $0x14,%esp
  80019a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80019d:	8b 13                	mov    (%ebx),%edx
  80019f:	8d 42 01             	lea    0x1(%edx),%eax
  8001a2:	89 03                	mov    %eax,(%ebx)
  8001a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001a7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b0:	75 19                	jne    8001cb <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001b2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001b9:	00 
  8001ba:	8d 43 08             	lea    0x8(%ebx),%eax
  8001bd:	89 04 24             	mov    %eax,(%esp)
  8001c0:	e8 e1 09 00 00       	call   800ba6 <sys_cputs>
		b->idx = 0;
  8001c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001cb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001cf:	83 c4 14             	add    $0x14,%esp
  8001d2:	5b                   	pop    %ebx
  8001d3:	5d                   	pop    %ebp
  8001d4:	c3                   	ret    

008001d5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d5:	55                   	push   %ebp
  8001d6:	89 e5                	mov    %esp,%ebp
  8001d8:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001de:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e5:	00 00 00 
	b.cnt = 0;
  8001e8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ef:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800200:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800206:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020a:	c7 04 24 93 01 80 00 	movl   $0x800193,(%esp)
  800211:	e8 a8 01 00 00       	call   8003be <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800216:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80021c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800220:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800226:	89 04 24             	mov    %eax,(%esp)
  800229:	e8 78 09 00 00       	call   800ba6 <sys_cputs>

	return b.cnt;
}
  80022e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80023c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80023f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800243:	8b 45 08             	mov    0x8(%ebp),%eax
  800246:	89 04 24             	mov    %eax,(%esp)
  800249:	e8 87 ff ff ff       	call   8001d5 <vcprintf>
	va_end(ap);

	return cnt;
}
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	57                   	push   %edi
  800254:	56                   	push   %esi
  800255:	53                   	push   %ebx
  800256:	83 ec 3c             	sub    $0x3c,%esp
  800259:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80025c:	89 d7                	mov    %edx,%edi
  80025e:	8b 45 08             	mov    0x8(%ebp),%eax
  800261:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800264:	8b 45 0c             	mov    0xc(%ebp),%eax
  800267:	89 c3                	mov    %eax,%ebx
  800269:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80026c:	8b 45 10             	mov    0x10(%ebp),%eax
  80026f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800272:	b9 00 00 00 00       	mov    $0x0,%ecx
  800277:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80027a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80027d:	39 d9                	cmp    %ebx,%ecx
  80027f:	72 05                	jb     800286 <printnum+0x36>
  800281:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800284:	77 69                	ja     8002ef <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800286:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800289:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80028d:	83 ee 01             	sub    $0x1,%esi
  800290:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800294:	89 44 24 08          	mov    %eax,0x8(%esp)
  800298:	8b 44 24 08          	mov    0x8(%esp),%eax
  80029c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002a0:	89 c3                	mov    %eax,%ebx
  8002a2:	89 d6                	mov    %edx,%esi
  8002a4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002a7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002ae:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b5:	89 04 24             	mov    %eax,(%esp)
  8002b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002bf:	e8 6c 24 00 00       	call   802730 <__udivdi3>
  8002c4:	89 d9                	mov    %ebx,%ecx
  8002c6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002ca:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002ce:	89 04 24             	mov    %eax,(%esp)
  8002d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002d5:	89 fa                	mov    %edi,%edx
  8002d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002da:	e8 71 ff ff ff       	call   800250 <printnum>
  8002df:	eb 1b                	jmp    8002fc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002e1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e8:	89 04 24             	mov    %eax,(%esp)
  8002eb:	ff d3                	call   *%ebx
  8002ed:	eb 03                	jmp    8002f2 <printnum+0xa2>
  8002ef:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002f2:	83 ee 01             	sub    $0x1,%esi
  8002f5:	85 f6                	test   %esi,%esi
  8002f7:	7f e8                	jg     8002e1 <printnum+0x91>
  8002f9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800300:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800304:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800307:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80030a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80030e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800312:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800315:	89 04 24             	mov    %eax,(%esp)
  800318:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80031b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80031f:	e8 3c 25 00 00       	call   802860 <__umoddi3>
  800324:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800328:	0f be 80 06 2a 80 00 	movsbl 0x802a06(%eax),%eax
  80032f:	89 04 24             	mov    %eax,(%esp)
  800332:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800335:	ff d0                	call   *%eax
}
  800337:	83 c4 3c             	add    $0x3c,%esp
  80033a:	5b                   	pop    %ebx
  80033b:	5e                   	pop    %esi
  80033c:	5f                   	pop    %edi
  80033d:	5d                   	pop    %ebp
  80033e:	c3                   	ret    

0080033f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80033f:	55                   	push   %ebp
  800340:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800342:	83 fa 01             	cmp    $0x1,%edx
  800345:	7e 0e                	jle    800355 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800347:	8b 10                	mov    (%eax),%edx
  800349:	8d 4a 08             	lea    0x8(%edx),%ecx
  80034c:	89 08                	mov    %ecx,(%eax)
  80034e:	8b 02                	mov    (%edx),%eax
  800350:	8b 52 04             	mov    0x4(%edx),%edx
  800353:	eb 22                	jmp    800377 <getuint+0x38>
	else if (lflag)
  800355:	85 d2                	test   %edx,%edx
  800357:	74 10                	je     800369 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800359:	8b 10                	mov    (%eax),%edx
  80035b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80035e:	89 08                	mov    %ecx,(%eax)
  800360:	8b 02                	mov    (%edx),%eax
  800362:	ba 00 00 00 00       	mov    $0x0,%edx
  800367:	eb 0e                	jmp    800377 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800369:	8b 10                	mov    (%eax),%edx
  80036b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80036e:	89 08                	mov    %ecx,(%eax)
  800370:	8b 02                	mov    (%edx),%eax
  800372:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800377:	5d                   	pop    %ebp
  800378:	c3                   	ret    

00800379 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80037f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800383:	8b 10                	mov    (%eax),%edx
  800385:	3b 50 04             	cmp    0x4(%eax),%edx
  800388:	73 0a                	jae    800394 <sprintputch+0x1b>
		*b->buf++ = ch;
  80038a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80038d:	89 08                	mov    %ecx,(%eax)
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	88 02                	mov    %al,(%edx)
}
  800394:	5d                   	pop    %ebp
  800395:	c3                   	ret    

00800396 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80039c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80039f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b4:	89 04 24             	mov    %eax,(%esp)
  8003b7:	e8 02 00 00 00       	call   8003be <vprintfmt>
	va_end(ap);
}
  8003bc:	c9                   	leave  
  8003bd:	c3                   	ret    

008003be <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
  8003c1:	57                   	push   %edi
  8003c2:	56                   	push   %esi
  8003c3:	53                   	push   %ebx
  8003c4:	83 ec 3c             	sub    $0x3c,%esp
  8003c7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003cd:	eb 14                	jmp    8003e3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003cf:	85 c0                	test   %eax,%eax
  8003d1:	0f 84 b3 03 00 00    	je     80078a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8003d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003db:	89 04 24             	mov    %eax,(%esp)
  8003de:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003e1:	89 f3                	mov    %esi,%ebx
  8003e3:	8d 73 01             	lea    0x1(%ebx),%esi
  8003e6:	0f b6 03             	movzbl (%ebx),%eax
  8003e9:	83 f8 25             	cmp    $0x25,%eax
  8003ec:	75 e1                	jne    8003cf <vprintfmt+0x11>
  8003ee:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8003f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003f9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800400:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800407:	ba 00 00 00 00       	mov    $0x0,%edx
  80040c:	eb 1d                	jmp    80042b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80040e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800410:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800414:	eb 15                	jmp    80042b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800416:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800418:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80041c:	eb 0d                	jmp    80042b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80041e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800421:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800424:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80042e:	0f b6 0e             	movzbl (%esi),%ecx
  800431:	0f b6 c1             	movzbl %cl,%eax
  800434:	83 e9 23             	sub    $0x23,%ecx
  800437:	80 f9 55             	cmp    $0x55,%cl
  80043a:	0f 87 2a 03 00 00    	ja     80076a <vprintfmt+0x3ac>
  800440:	0f b6 c9             	movzbl %cl,%ecx
  800443:	ff 24 8d 40 2b 80 00 	jmp    *0x802b40(,%ecx,4)
  80044a:	89 de                	mov    %ebx,%esi
  80044c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800451:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800454:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800458:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80045b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80045e:	83 fb 09             	cmp    $0x9,%ebx
  800461:	77 36                	ja     800499 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800463:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800466:	eb e9                	jmp    800451 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800468:	8b 45 14             	mov    0x14(%ebp),%eax
  80046b:	8d 48 04             	lea    0x4(%eax),%ecx
  80046e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800471:	8b 00                	mov    (%eax),%eax
  800473:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800476:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800478:	eb 22                	jmp    80049c <vprintfmt+0xde>
  80047a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80047d:	85 c9                	test   %ecx,%ecx
  80047f:	b8 00 00 00 00       	mov    $0x0,%eax
  800484:	0f 49 c1             	cmovns %ecx,%eax
  800487:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048a:	89 de                	mov    %ebx,%esi
  80048c:	eb 9d                	jmp    80042b <vprintfmt+0x6d>
  80048e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800490:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800497:	eb 92                	jmp    80042b <vprintfmt+0x6d>
  800499:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80049c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004a0:	79 89                	jns    80042b <vprintfmt+0x6d>
  8004a2:	e9 77 ff ff ff       	jmp    80041e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004a7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004aa:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004ac:	e9 7a ff ff ff       	jmp    80042b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b4:	8d 50 04             	lea    0x4(%eax),%edx
  8004b7:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	89 04 24             	mov    %eax,(%esp)
  8004c3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004c6:	e9 18 ff ff ff       	jmp    8003e3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ce:	8d 50 04             	lea    0x4(%eax),%edx
  8004d1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004d4:	8b 00                	mov    (%eax),%eax
  8004d6:	99                   	cltd   
  8004d7:	31 d0                	xor    %edx,%eax
  8004d9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004db:	83 f8 11             	cmp    $0x11,%eax
  8004de:	7f 0b                	jg     8004eb <vprintfmt+0x12d>
  8004e0:	8b 14 85 a0 2c 80 00 	mov    0x802ca0(,%eax,4),%edx
  8004e7:	85 d2                	test   %edx,%edx
  8004e9:	75 20                	jne    80050b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8004eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ef:	c7 44 24 08 1e 2a 80 	movl   $0x802a1e,0x8(%esp)
  8004f6:	00 
  8004f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	89 04 24             	mov    %eax,(%esp)
  800501:	e8 90 fe ff ff       	call   800396 <printfmt>
  800506:	e9 d8 fe ff ff       	jmp    8003e3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80050b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80050f:	c7 44 24 08 dd 2d 80 	movl   $0x802ddd,0x8(%esp)
  800516:	00 
  800517:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80051b:	8b 45 08             	mov    0x8(%ebp),%eax
  80051e:	89 04 24             	mov    %eax,(%esp)
  800521:	e8 70 fe ff ff       	call   800396 <printfmt>
  800526:	e9 b8 fe ff ff       	jmp    8003e3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80052e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800531:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8d 50 04             	lea    0x4(%eax),%edx
  80053a:	89 55 14             	mov    %edx,0x14(%ebp)
  80053d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80053f:	85 f6                	test   %esi,%esi
  800541:	b8 17 2a 80 00       	mov    $0x802a17,%eax
  800546:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800549:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80054d:	0f 84 97 00 00 00    	je     8005ea <vprintfmt+0x22c>
  800553:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800557:	0f 8e 9b 00 00 00    	jle    8005f8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80055d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800561:	89 34 24             	mov    %esi,(%esp)
  800564:	e8 cf 02 00 00       	call   800838 <strnlen>
  800569:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80056c:	29 c2                	sub    %eax,%edx
  80056e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800571:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800575:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800578:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80057b:	8b 75 08             	mov    0x8(%ebp),%esi
  80057e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800581:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800583:	eb 0f                	jmp    800594 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800585:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800589:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80058c:	89 04 24             	mov    %eax,(%esp)
  80058f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800591:	83 eb 01             	sub    $0x1,%ebx
  800594:	85 db                	test   %ebx,%ebx
  800596:	7f ed                	jg     800585 <vprintfmt+0x1c7>
  800598:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80059b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80059e:	85 d2                	test   %edx,%edx
  8005a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a5:	0f 49 c2             	cmovns %edx,%eax
  8005a8:	29 c2                	sub    %eax,%edx
  8005aa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005ad:	89 d7                	mov    %edx,%edi
  8005af:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005b2:	eb 50                	jmp    800604 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005b4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005b8:	74 1e                	je     8005d8 <vprintfmt+0x21a>
  8005ba:	0f be d2             	movsbl %dl,%edx
  8005bd:	83 ea 20             	sub    $0x20,%edx
  8005c0:	83 fa 5e             	cmp    $0x5e,%edx
  8005c3:	76 13                	jbe    8005d8 <vprintfmt+0x21a>
					putch('?', putdat);
  8005c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005cc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005d3:	ff 55 08             	call   *0x8(%ebp)
  8005d6:	eb 0d                	jmp    8005e5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8005d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005db:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005df:	89 04 24             	mov    %eax,(%esp)
  8005e2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e5:	83 ef 01             	sub    $0x1,%edi
  8005e8:	eb 1a                	jmp    800604 <vprintfmt+0x246>
  8005ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005ed:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005f0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005f3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005f6:	eb 0c                	jmp    800604 <vprintfmt+0x246>
  8005f8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005fb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800601:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800604:	83 c6 01             	add    $0x1,%esi
  800607:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80060b:	0f be c2             	movsbl %dl,%eax
  80060e:	85 c0                	test   %eax,%eax
  800610:	74 27                	je     800639 <vprintfmt+0x27b>
  800612:	85 db                	test   %ebx,%ebx
  800614:	78 9e                	js     8005b4 <vprintfmt+0x1f6>
  800616:	83 eb 01             	sub    $0x1,%ebx
  800619:	79 99                	jns    8005b4 <vprintfmt+0x1f6>
  80061b:	89 f8                	mov    %edi,%eax
  80061d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800620:	8b 75 08             	mov    0x8(%ebp),%esi
  800623:	89 c3                	mov    %eax,%ebx
  800625:	eb 1a                	jmp    800641 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800627:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80062b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800632:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800634:	83 eb 01             	sub    $0x1,%ebx
  800637:	eb 08                	jmp    800641 <vprintfmt+0x283>
  800639:	89 fb                	mov    %edi,%ebx
  80063b:	8b 75 08             	mov    0x8(%ebp),%esi
  80063e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800641:	85 db                	test   %ebx,%ebx
  800643:	7f e2                	jg     800627 <vprintfmt+0x269>
  800645:	89 75 08             	mov    %esi,0x8(%ebp)
  800648:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80064b:	e9 93 fd ff ff       	jmp    8003e3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800650:	83 fa 01             	cmp    $0x1,%edx
  800653:	7e 16                	jle    80066b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	8d 50 08             	lea    0x8(%eax),%edx
  80065b:	89 55 14             	mov    %edx,0x14(%ebp)
  80065e:	8b 50 04             	mov    0x4(%eax),%edx
  800661:	8b 00                	mov    (%eax),%eax
  800663:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800666:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800669:	eb 32                	jmp    80069d <vprintfmt+0x2df>
	else if (lflag)
  80066b:	85 d2                	test   %edx,%edx
  80066d:	74 18                	je     800687 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8d 50 04             	lea    0x4(%eax),%edx
  800675:	89 55 14             	mov    %edx,0x14(%ebp)
  800678:	8b 30                	mov    (%eax),%esi
  80067a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80067d:	89 f0                	mov    %esi,%eax
  80067f:	c1 f8 1f             	sar    $0x1f,%eax
  800682:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800685:	eb 16                	jmp    80069d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	8d 50 04             	lea    0x4(%eax),%edx
  80068d:	89 55 14             	mov    %edx,0x14(%ebp)
  800690:	8b 30                	mov    (%eax),%esi
  800692:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800695:	89 f0                	mov    %esi,%eax
  800697:	c1 f8 1f             	sar    $0x1f,%eax
  80069a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80069d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ac:	0f 89 80 00 00 00    	jns    800732 <vprintfmt+0x374>
				putch('-', putdat);
  8006b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006b6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006bd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006c6:	f7 d8                	neg    %eax
  8006c8:	83 d2 00             	adc    $0x0,%edx
  8006cb:	f7 da                	neg    %edx
			}
			base = 10;
  8006cd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006d2:	eb 5e                	jmp    800732 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006d4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006d7:	e8 63 fc ff ff       	call   80033f <getuint>
			base = 10;
  8006dc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006e1:	eb 4f                	jmp    800732 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e6:	e8 54 fc ff ff       	call   80033f <getuint>
			base = 8;
  8006eb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006f0:	eb 40                	jmp    800732 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  8006f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006f6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006fd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800700:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800704:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80070b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8d 50 04             	lea    0x4(%eax),%edx
  800714:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800717:	8b 00                	mov    (%eax),%eax
  800719:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80071e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800723:	eb 0d                	jmp    800732 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800725:	8d 45 14             	lea    0x14(%ebp),%eax
  800728:	e8 12 fc ff ff       	call   80033f <getuint>
			base = 16;
  80072d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800732:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800736:	89 74 24 10          	mov    %esi,0x10(%esp)
  80073a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80073d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800741:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800745:	89 04 24             	mov    %eax,(%esp)
  800748:	89 54 24 04          	mov    %edx,0x4(%esp)
  80074c:	89 fa                	mov    %edi,%edx
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	e8 fa fa ff ff       	call   800250 <printnum>
			break;
  800756:	e9 88 fc ff ff       	jmp    8003e3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80075b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80075f:	89 04 24             	mov    %eax,(%esp)
  800762:	ff 55 08             	call   *0x8(%ebp)
			break;
  800765:	e9 79 fc ff ff       	jmp    8003e3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80076a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800775:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800778:	89 f3                	mov    %esi,%ebx
  80077a:	eb 03                	jmp    80077f <vprintfmt+0x3c1>
  80077c:	83 eb 01             	sub    $0x1,%ebx
  80077f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800783:	75 f7                	jne    80077c <vprintfmt+0x3be>
  800785:	e9 59 fc ff ff       	jmp    8003e3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80078a:	83 c4 3c             	add    $0x3c,%esp
  80078d:	5b                   	pop    %ebx
  80078e:	5e                   	pop    %esi
  80078f:	5f                   	pop    %edi
  800790:	5d                   	pop    %ebp
  800791:	c3                   	ret    

00800792 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800792:	55                   	push   %ebp
  800793:	89 e5                	mov    %esp,%ebp
  800795:	83 ec 28             	sub    $0x28,%esp
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80079e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007a1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007a5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007af:	85 c0                	test   %eax,%eax
  8007b1:	74 30                	je     8007e3 <vsnprintf+0x51>
  8007b3:	85 d2                	test   %edx,%edx
  8007b5:	7e 2c                	jle    8007e3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007be:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007cc:	c7 04 24 79 03 80 00 	movl   $0x800379,(%esp)
  8007d3:	e8 e6 fb ff ff       	call   8003be <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007db:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007e1:	eb 05                	jmp    8007e8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007e8:	c9                   	leave  
  8007e9:	c3                   	ret    

008007ea <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ea:	55                   	push   %ebp
  8007eb:	89 e5                	mov    %esp,%ebp
  8007ed:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007f0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800801:	89 44 24 04          	mov    %eax,0x4(%esp)
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	89 04 24             	mov    %eax,(%esp)
  80080b:	e8 82 ff ff ff       	call   800792 <vsnprintf>
	va_end(ap);

	return rc;
}
  800810:	c9                   	leave  
  800811:	c3                   	ret    
  800812:	66 90                	xchg   %ax,%ax
  800814:	66 90                	xchg   %ax,%ax
  800816:	66 90                	xchg   %ax,%ax
  800818:	66 90                	xchg   %ax,%ax
  80081a:	66 90                	xchg   %ax,%ax
  80081c:	66 90                	xchg   %ax,%ax
  80081e:	66 90                	xchg   %ax,%ax

00800820 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800826:	b8 00 00 00 00       	mov    $0x0,%eax
  80082b:	eb 03                	jmp    800830 <strlen+0x10>
		n++;
  80082d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800830:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800834:	75 f7                	jne    80082d <strlen+0xd>
		n++;
	return n;
}
  800836:	5d                   	pop    %ebp
  800837:	c3                   	ret    

00800838 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80083e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800841:	b8 00 00 00 00       	mov    $0x0,%eax
  800846:	eb 03                	jmp    80084b <strnlen+0x13>
		n++;
  800848:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80084b:	39 d0                	cmp    %edx,%eax
  80084d:	74 06                	je     800855 <strnlen+0x1d>
  80084f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800853:	75 f3                	jne    800848 <strnlen+0x10>
		n++;
	return n;
}
  800855:	5d                   	pop    %ebp
  800856:	c3                   	ret    

00800857 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	53                   	push   %ebx
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800861:	89 c2                	mov    %eax,%edx
  800863:	83 c2 01             	add    $0x1,%edx
  800866:	83 c1 01             	add    $0x1,%ecx
  800869:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80086d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800870:	84 db                	test   %bl,%bl
  800872:	75 ef                	jne    800863 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800874:	5b                   	pop    %ebx
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	53                   	push   %ebx
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800881:	89 1c 24             	mov    %ebx,(%esp)
  800884:	e8 97 ff ff ff       	call   800820 <strlen>
	strcpy(dst + len, src);
  800889:	8b 55 0c             	mov    0xc(%ebp),%edx
  80088c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800890:	01 d8                	add    %ebx,%eax
  800892:	89 04 24             	mov    %eax,(%esp)
  800895:	e8 bd ff ff ff       	call   800857 <strcpy>
	return dst;
}
  80089a:	89 d8                	mov    %ebx,%eax
  80089c:	83 c4 08             	add    $0x8,%esp
  80089f:	5b                   	pop    %ebx
  8008a0:	5d                   	pop    %ebp
  8008a1:	c3                   	ret    

008008a2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	56                   	push   %esi
  8008a6:	53                   	push   %ebx
  8008a7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ad:	89 f3                	mov    %esi,%ebx
  8008af:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008b2:	89 f2                	mov    %esi,%edx
  8008b4:	eb 0f                	jmp    8008c5 <strncpy+0x23>
		*dst++ = *src;
  8008b6:	83 c2 01             	add    $0x1,%edx
  8008b9:	0f b6 01             	movzbl (%ecx),%eax
  8008bc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008bf:	80 39 01             	cmpb   $0x1,(%ecx)
  8008c2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c5:	39 da                	cmp    %ebx,%edx
  8008c7:	75 ed                	jne    8008b6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008c9:	89 f0                	mov    %esi,%eax
  8008cb:	5b                   	pop    %ebx
  8008cc:	5e                   	pop    %esi
  8008cd:	5d                   	pop    %ebp
  8008ce:	c3                   	ret    

008008cf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	56                   	push   %esi
  8008d3:	53                   	push   %ebx
  8008d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008dd:	89 f0                	mov    %esi,%eax
  8008df:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008e3:	85 c9                	test   %ecx,%ecx
  8008e5:	75 0b                	jne    8008f2 <strlcpy+0x23>
  8008e7:	eb 1d                	jmp    800906 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008e9:	83 c0 01             	add    $0x1,%eax
  8008ec:	83 c2 01             	add    $0x1,%edx
  8008ef:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008f2:	39 d8                	cmp    %ebx,%eax
  8008f4:	74 0b                	je     800901 <strlcpy+0x32>
  8008f6:	0f b6 0a             	movzbl (%edx),%ecx
  8008f9:	84 c9                	test   %cl,%cl
  8008fb:	75 ec                	jne    8008e9 <strlcpy+0x1a>
  8008fd:	89 c2                	mov    %eax,%edx
  8008ff:	eb 02                	jmp    800903 <strlcpy+0x34>
  800901:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800903:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800906:	29 f0                	sub    %esi,%eax
}
  800908:	5b                   	pop    %ebx
  800909:	5e                   	pop    %esi
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    

0080090c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800912:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800915:	eb 06                	jmp    80091d <strcmp+0x11>
		p++, q++;
  800917:	83 c1 01             	add    $0x1,%ecx
  80091a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80091d:	0f b6 01             	movzbl (%ecx),%eax
  800920:	84 c0                	test   %al,%al
  800922:	74 04                	je     800928 <strcmp+0x1c>
  800924:	3a 02                	cmp    (%edx),%al
  800926:	74 ef                	je     800917 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800928:	0f b6 c0             	movzbl %al,%eax
  80092b:	0f b6 12             	movzbl (%edx),%edx
  80092e:	29 d0                	sub    %edx,%eax
}
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	53                   	push   %ebx
  800936:	8b 45 08             	mov    0x8(%ebp),%eax
  800939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093c:	89 c3                	mov    %eax,%ebx
  80093e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800941:	eb 06                	jmp    800949 <strncmp+0x17>
		n--, p++, q++;
  800943:	83 c0 01             	add    $0x1,%eax
  800946:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800949:	39 d8                	cmp    %ebx,%eax
  80094b:	74 15                	je     800962 <strncmp+0x30>
  80094d:	0f b6 08             	movzbl (%eax),%ecx
  800950:	84 c9                	test   %cl,%cl
  800952:	74 04                	je     800958 <strncmp+0x26>
  800954:	3a 0a                	cmp    (%edx),%cl
  800956:	74 eb                	je     800943 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800958:	0f b6 00             	movzbl (%eax),%eax
  80095b:	0f b6 12             	movzbl (%edx),%edx
  80095e:	29 d0                	sub    %edx,%eax
  800960:	eb 05                	jmp    800967 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800962:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800967:	5b                   	pop    %ebx
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800974:	eb 07                	jmp    80097d <strchr+0x13>
		if (*s == c)
  800976:	38 ca                	cmp    %cl,%dl
  800978:	74 0f                	je     800989 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80097a:	83 c0 01             	add    $0x1,%eax
  80097d:	0f b6 10             	movzbl (%eax),%edx
  800980:	84 d2                	test   %dl,%dl
  800982:	75 f2                	jne    800976 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800984:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800989:	5d                   	pop    %ebp
  80098a:	c3                   	ret    

0080098b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80098b:	55                   	push   %ebp
  80098c:	89 e5                	mov    %esp,%ebp
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800995:	eb 07                	jmp    80099e <strfind+0x13>
		if (*s == c)
  800997:	38 ca                	cmp    %cl,%dl
  800999:	74 0a                	je     8009a5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80099b:	83 c0 01             	add    $0x1,%eax
  80099e:	0f b6 10             	movzbl (%eax),%edx
  8009a1:	84 d2                	test   %dl,%dl
  8009a3:	75 f2                	jne    800997 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	57                   	push   %edi
  8009ab:	56                   	push   %esi
  8009ac:	53                   	push   %ebx
  8009ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009b3:	85 c9                	test   %ecx,%ecx
  8009b5:	74 36                	je     8009ed <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009b7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009bd:	75 28                	jne    8009e7 <memset+0x40>
  8009bf:	f6 c1 03             	test   $0x3,%cl
  8009c2:	75 23                	jne    8009e7 <memset+0x40>
		c &= 0xFF;
  8009c4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009c8:	89 d3                	mov    %edx,%ebx
  8009ca:	c1 e3 08             	shl    $0x8,%ebx
  8009cd:	89 d6                	mov    %edx,%esi
  8009cf:	c1 e6 18             	shl    $0x18,%esi
  8009d2:	89 d0                	mov    %edx,%eax
  8009d4:	c1 e0 10             	shl    $0x10,%eax
  8009d7:	09 f0                	or     %esi,%eax
  8009d9:	09 c2                	or     %eax,%edx
  8009db:	89 d0                	mov    %edx,%eax
  8009dd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009df:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009e2:	fc                   	cld    
  8009e3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009e5:	eb 06                	jmp    8009ed <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ea:	fc                   	cld    
  8009eb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009ed:	89 f8                	mov    %edi,%eax
  8009ef:	5b                   	pop    %ebx
  8009f0:	5e                   	pop    %esi
  8009f1:	5f                   	pop    %edi
  8009f2:	5d                   	pop    %ebp
  8009f3:	c3                   	ret    

008009f4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009f4:	55                   	push   %ebp
  8009f5:	89 e5                	mov    %esp,%ebp
  8009f7:	57                   	push   %edi
  8009f8:	56                   	push   %esi
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a02:	39 c6                	cmp    %eax,%esi
  800a04:	73 35                	jae    800a3b <memmove+0x47>
  800a06:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a09:	39 d0                	cmp    %edx,%eax
  800a0b:	73 2e                	jae    800a3b <memmove+0x47>
		s += n;
		d += n;
  800a0d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a10:	89 d6                	mov    %edx,%esi
  800a12:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a14:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a1a:	75 13                	jne    800a2f <memmove+0x3b>
  800a1c:	f6 c1 03             	test   $0x3,%cl
  800a1f:	75 0e                	jne    800a2f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a21:	83 ef 04             	sub    $0x4,%edi
  800a24:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a27:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a2a:	fd                   	std    
  800a2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a2d:	eb 09                	jmp    800a38 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a2f:	83 ef 01             	sub    $0x1,%edi
  800a32:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a35:	fd                   	std    
  800a36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a38:	fc                   	cld    
  800a39:	eb 1d                	jmp    800a58 <memmove+0x64>
  800a3b:	89 f2                	mov    %esi,%edx
  800a3d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a3f:	f6 c2 03             	test   $0x3,%dl
  800a42:	75 0f                	jne    800a53 <memmove+0x5f>
  800a44:	f6 c1 03             	test   $0x3,%cl
  800a47:	75 0a                	jne    800a53 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a49:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a4c:	89 c7                	mov    %eax,%edi
  800a4e:	fc                   	cld    
  800a4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a51:	eb 05                	jmp    800a58 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a53:	89 c7                	mov    %eax,%edi
  800a55:	fc                   	cld    
  800a56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a58:	5e                   	pop    %esi
  800a59:	5f                   	pop    %edi
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a62:	8b 45 10             	mov    0x10(%ebp),%eax
  800a65:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	89 04 24             	mov    %eax,(%esp)
  800a76:	e8 79 ff ff ff       	call   8009f4 <memmove>
}
  800a7b:	c9                   	leave  
  800a7c:	c3                   	ret    

00800a7d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	56                   	push   %esi
  800a81:	53                   	push   %ebx
  800a82:	8b 55 08             	mov    0x8(%ebp),%edx
  800a85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a88:	89 d6                	mov    %edx,%esi
  800a8a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a8d:	eb 1a                	jmp    800aa9 <memcmp+0x2c>
		if (*s1 != *s2)
  800a8f:	0f b6 02             	movzbl (%edx),%eax
  800a92:	0f b6 19             	movzbl (%ecx),%ebx
  800a95:	38 d8                	cmp    %bl,%al
  800a97:	74 0a                	je     800aa3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a99:	0f b6 c0             	movzbl %al,%eax
  800a9c:	0f b6 db             	movzbl %bl,%ebx
  800a9f:	29 d8                	sub    %ebx,%eax
  800aa1:	eb 0f                	jmp    800ab2 <memcmp+0x35>
		s1++, s2++;
  800aa3:	83 c2 01             	add    $0x1,%edx
  800aa6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aa9:	39 f2                	cmp    %esi,%edx
  800aab:	75 e2                	jne    800a8f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800aad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab2:	5b                   	pop    %ebx
  800ab3:	5e                   	pop    %esi
  800ab4:	5d                   	pop    %ebp
  800ab5:	c3                   	ret    

00800ab6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  800abc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800abf:	89 c2                	mov    %eax,%edx
  800ac1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ac4:	eb 07                	jmp    800acd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ac6:	38 08                	cmp    %cl,(%eax)
  800ac8:	74 07                	je     800ad1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800aca:	83 c0 01             	add    $0x1,%eax
  800acd:	39 d0                	cmp    %edx,%eax
  800acf:	72 f5                	jb     800ac6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ad1:	5d                   	pop    %ebp
  800ad2:	c3                   	ret    

00800ad3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	57                   	push   %edi
  800ad7:	56                   	push   %esi
  800ad8:	53                   	push   %ebx
  800ad9:	8b 55 08             	mov    0x8(%ebp),%edx
  800adc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800adf:	eb 03                	jmp    800ae4 <strtol+0x11>
		s++;
  800ae1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ae4:	0f b6 0a             	movzbl (%edx),%ecx
  800ae7:	80 f9 09             	cmp    $0x9,%cl
  800aea:	74 f5                	je     800ae1 <strtol+0xe>
  800aec:	80 f9 20             	cmp    $0x20,%cl
  800aef:	74 f0                	je     800ae1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800af1:	80 f9 2b             	cmp    $0x2b,%cl
  800af4:	75 0a                	jne    800b00 <strtol+0x2d>
		s++;
  800af6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800af9:	bf 00 00 00 00       	mov    $0x0,%edi
  800afe:	eb 11                	jmp    800b11 <strtol+0x3e>
  800b00:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b05:	80 f9 2d             	cmp    $0x2d,%cl
  800b08:	75 07                	jne    800b11 <strtol+0x3e>
		s++, neg = 1;
  800b0a:	8d 52 01             	lea    0x1(%edx),%edx
  800b0d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b11:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b16:	75 15                	jne    800b2d <strtol+0x5a>
  800b18:	80 3a 30             	cmpb   $0x30,(%edx)
  800b1b:	75 10                	jne    800b2d <strtol+0x5a>
  800b1d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b21:	75 0a                	jne    800b2d <strtol+0x5a>
		s += 2, base = 16;
  800b23:	83 c2 02             	add    $0x2,%edx
  800b26:	b8 10 00 00 00       	mov    $0x10,%eax
  800b2b:	eb 10                	jmp    800b3d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b2d:	85 c0                	test   %eax,%eax
  800b2f:	75 0c                	jne    800b3d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b31:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b33:	80 3a 30             	cmpb   $0x30,(%edx)
  800b36:	75 05                	jne    800b3d <strtol+0x6a>
		s++, base = 8;
  800b38:	83 c2 01             	add    $0x1,%edx
  800b3b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b42:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b45:	0f b6 0a             	movzbl (%edx),%ecx
  800b48:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b4b:	89 f0                	mov    %esi,%eax
  800b4d:	3c 09                	cmp    $0x9,%al
  800b4f:	77 08                	ja     800b59 <strtol+0x86>
			dig = *s - '0';
  800b51:	0f be c9             	movsbl %cl,%ecx
  800b54:	83 e9 30             	sub    $0x30,%ecx
  800b57:	eb 20                	jmp    800b79 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b59:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b5c:	89 f0                	mov    %esi,%eax
  800b5e:	3c 19                	cmp    $0x19,%al
  800b60:	77 08                	ja     800b6a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b62:	0f be c9             	movsbl %cl,%ecx
  800b65:	83 e9 57             	sub    $0x57,%ecx
  800b68:	eb 0f                	jmp    800b79 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b6a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b6d:	89 f0                	mov    %esi,%eax
  800b6f:	3c 19                	cmp    $0x19,%al
  800b71:	77 16                	ja     800b89 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b73:	0f be c9             	movsbl %cl,%ecx
  800b76:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b79:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b7c:	7d 0f                	jge    800b8d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b7e:	83 c2 01             	add    $0x1,%edx
  800b81:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b85:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b87:	eb bc                	jmp    800b45 <strtol+0x72>
  800b89:	89 d8                	mov    %ebx,%eax
  800b8b:	eb 02                	jmp    800b8f <strtol+0xbc>
  800b8d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b93:	74 05                	je     800b9a <strtol+0xc7>
		*endptr = (char *) s;
  800b95:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b98:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b9a:	f7 d8                	neg    %eax
  800b9c:	85 ff                	test   %edi,%edi
  800b9e:	0f 44 c3             	cmove  %ebx,%eax
}
  800ba1:	5b                   	pop    %ebx
  800ba2:	5e                   	pop    %esi
  800ba3:	5f                   	pop    %edi
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	57                   	push   %edi
  800baa:	56                   	push   %esi
  800bab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bac:	b8 00 00 00 00       	mov    $0x0,%eax
  800bb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb7:	89 c3                	mov    %eax,%ebx
  800bb9:	89 c7                	mov    %eax,%edi
  800bbb:	89 c6                	mov    %eax,%esi
  800bbd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <sys_cgetc>:

int
sys_cgetc(void)
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
  800bcf:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd4:	89 d1                	mov    %edx,%ecx
  800bd6:	89 d3                	mov    %edx,%ebx
  800bd8:	89 d7                	mov    %edx,%edi
  800bda:	89 d6                	mov    %edx,%esi
  800bdc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bde:	5b                   	pop    %ebx
  800bdf:	5e                   	pop    %esi
  800be0:	5f                   	pop    %edi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    

00800be3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800bec:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bf1:	b8 03 00 00 00       	mov    $0x3,%eax
  800bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf9:	89 cb                	mov    %ecx,%ebx
  800bfb:	89 cf                	mov    %ecx,%edi
  800bfd:	89 ce                	mov    %ecx,%esi
  800bff:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c01:	85 c0                	test   %eax,%eax
  800c03:	7e 28                	jle    800c2d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c05:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c09:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c10:	00 
  800c11:	c7 44 24 08 07 2d 80 	movl   $0x802d07,0x8(%esp)
  800c18:	00 
  800c19:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c20:	00 
  800c21:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  800c28:	e8 39 19 00 00       	call   802566 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c2d:	83 c4 2c             	add    $0x2c,%esp
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	57                   	push   %edi
  800c39:	56                   	push   %esi
  800c3a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c40:	b8 02 00 00 00       	mov    $0x2,%eax
  800c45:	89 d1                	mov    %edx,%ecx
  800c47:	89 d3                	mov    %edx,%ebx
  800c49:	89 d7                	mov    %edx,%edi
  800c4b:	89 d6                	mov    %edx,%esi
  800c4d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <sys_yield>:

void
sys_yield(void)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	57                   	push   %edi
  800c58:	56                   	push   %esi
  800c59:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c64:	89 d1                	mov    %edx,%ecx
  800c66:	89 d3                	mov    %edx,%ebx
  800c68:	89 d7                	mov    %edx,%edi
  800c6a:	89 d6                	mov    %edx,%esi
  800c6c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	57                   	push   %edi
  800c77:	56                   	push   %esi
  800c78:	53                   	push   %ebx
  800c79:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7c:	be 00 00 00 00       	mov    $0x0,%esi
  800c81:	b8 04 00 00 00       	mov    $0x4,%eax
  800c86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c89:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c8f:	89 f7                	mov    %esi,%edi
  800c91:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c93:	85 c0                	test   %eax,%eax
  800c95:	7e 28                	jle    800cbf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c97:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c9b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ca2:	00 
  800ca3:	c7 44 24 08 07 2d 80 	movl   $0x802d07,0x8(%esp)
  800caa:	00 
  800cab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cb2:	00 
  800cb3:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  800cba:	e8 a7 18 00 00       	call   802566 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cbf:	83 c4 2c             	add    $0x2c,%esp
  800cc2:	5b                   	pop    %ebx
  800cc3:	5e                   	pop    %esi
  800cc4:	5f                   	pop    %edi
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	57                   	push   %edi
  800ccb:	56                   	push   %esi
  800ccc:	53                   	push   %ebx
  800ccd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cd0:	b8 05 00 00 00       	mov    $0x5,%eax
  800cd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cde:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ce1:	8b 75 18             	mov    0x18(%ebp),%esi
  800ce4:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ce6:	85 c0                	test   %eax,%eax
  800ce8:	7e 28                	jle    800d12 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cea:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cee:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800cf5:	00 
  800cf6:	c7 44 24 08 07 2d 80 	movl   $0x802d07,0x8(%esp)
  800cfd:	00 
  800cfe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d05:	00 
  800d06:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  800d0d:	e8 54 18 00 00       	call   802566 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d12:	83 c4 2c             	add    $0x2c,%esp
  800d15:	5b                   	pop    %ebx
  800d16:	5e                   	pop    %esi
  800d17:	5f                   	pop    %edi
  800d18:	5d                   	pop    %ebp
  800d19:	c3                   	ret    

00800d1a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	57                   	push   %edi
  800d1e:	56                   	push   %esi
  800d1f:	53                   	push   %ebx
  800d20:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d28:	b8 06 00 00 00       	mov    $0x6,%eax
  800d2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d30:	8b 55 08             	mov    0x8(%ebp),%edx
  800d33:	89 df                	mov    %ebx,%edi
  800d35:	89 de                	mov    %ebx,%esi
  800d37:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d39:	85 c0                	test   %eax,%eax
  800d3b:	7e 28                	jle    800d65 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d41:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d48:	00 
  800d49:	c7 44 24 08 07 2d 80 	movl   $0x802d07,0x8(%esp)
  800d50:	00 
  800d51:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d58:	00 
  800d59:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  800d60:	e8 01 18 00 00       	call   802566 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d65:	83 c4 2c             	add    $0x2c,%esp
  800d68:	5b                   	pop    %ebx
  800d69:	5e                   	pop    %esi
  800d6a:	5f                   	pop    %edi
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    

00800d6d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d83:	8b 55 08             	mov    0x8(%ebp),%edx
  800d86:	89 df                	mov    %ebx,%edi
  800d88:	89 de                	mov    %ebx,%esi
  800d8a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d8c:	85 c0                	test   %eax,%eax
  800d8e:	7e 28                	jle    800db8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d90:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d94:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d9b:	00 
  800d9c:	c7 44 24 08 07 2d 80 	movl   $0x802d07,0x8(%esp)
  800da3:	00 
  800da4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dab:	00 
  800dac:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  800db3:	e8 ae 17 00 00       	call   802566 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800db8:	83 c4 2c             	add    $0x2c,%esp
  800dbb:	5b                   	pop    %ebx
  800dbc:	5e                   	pop    %esi
  800dbd:	5f                   	pop    %edi
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    

00800dc0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	57                   	push   %edi
  800dc4:	56                   	push   %esi
  800dc5:	53                   	push   %ebx
  800dc6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dce:	b8 09 00 00 00       	mov    $0x9,%eax
  800dd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd9:	89 df                	mov    %ebx,%edi
  800ddb:	89 de                	mov    %ebx,%esi
  800ddd:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ddf:	85 c0                	test   %eax,%eax
  800de1:	7e 28                	jle    800e0b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800de3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800de7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dee:	00 
  800def:	c7 44 24 08 07 2d 80 	movl   $0x802d07,0x8(%esp)
  800df6:	00 
  800df7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dfe:	00 
  800dff:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  800e06:	e8 5b 17 00 00       	call   802566 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e0b:	83 c4 2c             	add    $0x2c,%esp
  800e0e:	5b                   	pop    %ebx
  800e0f:	5e                   	pop    %esi
  800e10:	5f                   	pop    %edi
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    

00800e13 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	57                   	push   %edi
  800e17:	56                   	push   %esi
  800e18:	53                   	push   %ebx
  800e19:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e21:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e29:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2c:	89 df                	mov    %ebx,%edi
  800e2e:	89 de                	mov    %ebx,%esi
  800e30:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e32:	85 c0                	test   %eax,%eax
  800e34:	7e 28                	jle    800e5e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e36:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e3a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e41:	00 
  800e42:	c7 44 24 08 07 2d 80 	movl   $0x802d07,0x8(%esp)
  800e49:	00 
  800e4a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e51:	00 
  800e52:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  800e59:	e8 08 17 00 00       	call   802566 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e5e:	83 c4 2c             	add    $0x2c,%esp
  800e61:	5b                   	pop    %ebx
  800e62:	5e                   	pop    %esi
  800e63:	5f                   	pop    %edi
  800e64:	5d                   	pop    %ebp
  800e65:	c3                   	ret    

00800e66 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	57                   	push   %edi
  800e6a:	56                   	push   %esi
  800e6b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6c:	be 00 00 00 00       	mov    $0x0,%esi
  800e71:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e79:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e82:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e84:	5b                   	pop    %ebx
  800e85:	5e                   	pop    %esi
  800e86:	5f                   	pop    %edi
  800e87:	5d                   	pop    %ebp
  800e88:	c3                   	ret    

00800e89 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	57                   	push   %edi
  800e8d:	56                   	push   %esi
  800e8e:	53                   	push   %ebx
  800e8f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e92:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e97:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9f:	89 cb                	mov    %ecx,%ebx
  800ea1:	89 cf                	mov    %ecx,%edi
  800ea3:	89 ce                	mov    %ecx,%esi
  800ea5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ea7:	85 c0                	test   %eax,%eax
  800ea9:	7e 28                	jle    800ed3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eab:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eaf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800eb6:	00 
  800eb7:	c7 44 24 08 07 2d 80 	movl   $0x802d07,0x8(%esp)
  800ebe:	00 
  800ebf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ec6:	00 
  800ec7:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  800ece:	e8 93 16 00 00       	call   802566 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ed3:	83 c4 2c             	add    $0x2c,%esp
  800ed6:	5b                   	pop    %ebx
  800ed7:	5e                   	pop    %esi
  800ed8:	5f                   	pop    %edi
  800ed9:	5d                   	pop    %ebp
  800eda:	c3                   	ret    

00800edb <sys_time_msec>:

unsigned int
sys_time_msec(void)
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
  800ee1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eeb:	89 d1                	mov    %edx,%ecx
  800eed:	89 d3                	mov    %edx,%ebx
  800eef:	89 d7                	mov    %edx,%edi
  800ef1:	89 d6                	mov    %edx,%esi
  800ef3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ef5:	5b                   	pop    %ebx
  800ef6:	5e                   	pop    %esi
  800ef7:	5f                   	pop    %edi
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    

00800efa <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	57                   	push   %edi
  800efe:	56                   	push   %esi
  800eff:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f00:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f05:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f10:	89 df                	mov    %ebx,%edi
  800f12:	89 de                	mov    %ebx,%esi
  800f14:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
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
  800f21:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f26:	b8 10 00 00 00       	mov    $0x10,%eax
  800f2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f31:	89 df                	mov    %ebx,%edi
  800f33:	89 de                	mov    %ebx,%esi
  800f35:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800f37:	5b                   	pop    %ebx
  800f38:	5e                   	pop    %esi
  800f39:	5f                   	pop    %edi
  800f3a:	5d                   	pop    %ebp
  800f3b:	c3                   	ret    

00800f3c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800f3c:	55                   	push   %ebp
  800f3d:	89 e5                	mov    %esp,%ebp
  800f3f:	57                   	push   %edi
  800f40:	56                   	push   %esi
  800f41:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f47:	b8 11 00 00 00       	mov    $0x11,%eax
  800f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4f:	89 cb                	mov    %ecx,%ebx
  800f51:	89 cf                	mov    %ecx,%edi
  800f53:	89 ce                	mov    %ecx,%esi
  800f55:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800f57:	5b                   	pop    %ebx
  800f58:	5e                   	pop    %esi
  800f59:	5f                   	pop    %edi
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
  800f62:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f65:	be 00 00 00 00       	mov    $0x0,%esi
  800f6a:	b8 12 00 00 00       	mov    $0x12,%eax
  800f6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f72:	8b 55 08             	mov    0x8(%ebp),%edx
  800f75:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f78:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f7b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f7d:	85 c0                	test   %eax,%eax
  800f7f:	7e 28                	jle    800fa9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f81:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f85:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800f8c:	00 
  800f8d:	c7 44 24 08 07 2d 80 	movl   $0x802d07,0x8(%esp)
  800f94:	00 
  800f95:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f9c:	00 
  800f9d:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  800fa4:	e8 bd 15 00 00       	call   802566 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  800fa9:	83 c4 2c             	add    $0x2c,%esp
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5f                   	pop    %edi
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    

00800fb1 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	53                   	push   %ebx
  800fb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fbb:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800fbe:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  800fc0:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800fc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc8:	83 39 01             	cmpl   $0x1,(%ecx)
  800fcb:	7e 0f                	jle    800fdc <argstart+0x2b>
  800fcd:	85 d2                	test   %edx,%edx
  800fcf:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd4:	bb d1 29 80 00       	mov    $0x8029d1,%ebx
  800fd9:	0f 44 da             	cmove  %edx,%ebx
  800fdc:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  800fdf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800fe6:	5b                   	pop    %ebx
  800fe7:	5d                   	pop    %ebp
  800fe8:	c3                   	ret    

00800fe9 <argnext>:

int
argnext(struct Argstate *args)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	53                   	push   %ebx
  800fed:	83 ec 14             	sub    $0x14,%esp
  800ff0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800ff3:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800ffa:	8b 43 08             	mov    0x8(%ebx),%eax
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	74 71                	je     801072 <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  801001:	80 38 00             	cmpb   $0x0,(%eax)
  801004:	75 50                	jne    801056 <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801006:	8b 0b                	mov    (%ebx),%ecx
  801008:	83 39 01             	cmpl   $0x1,(%ecx)
  80100b:	74 57                	je     801064 <argnext+0x7b>
		    || args->argv[1][0] != '-'
  80100d:	8b 53 04             	mov    0x4(%ebx),%edx
  801010:	8b 42 04             	mov    0x4(%edx),%eax
  801013:	80 38 2d             	cmpb   $0x2d,(%eax)
  801016:	75 4c                	jne    801064 <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  801018:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  80101c:	74 46                	je     801064 <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  80101e:	83 c0 01             	add    $0x1,%eax
  801021:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801024:	8b 01                	mov    (%ecx),%eax
  801026:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  80102d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801031:	8d 42 08             	lea    0x8(%edx),%eax
  801034:	89 44 24 04          	mov    %eax,0x4(%esp)
  801038:	83 c2 04             	add    $0x4,%edx
  80103b:	89 14 24             	mov    %edx,(%esp)
  80103e:	e8 b1 f9 ff ff       	call   8009f4 <memmove>
		(*args->argc)--;
  801043:	8b 03                	mov    (%ebx),%eax
  801045:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801048:	8b 43 08             	mov    0x8(%ebx),%eax
  80104b:	80 38 2d             	cmpb   $0x2d,(%eax)
  80104e:	75 06                	jne    801056 <argnext+0x6d>
  801050:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801054:	74 0e                	je     801064 <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801056:	8b 53 08             	mov    0x8(%ebx),%edx
  801059:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  80105c:	83 c2 01             	add    $0x1,%edx
  80105f:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  801062:	eb 13                	jmp    801077 <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  801064:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  80106b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801070:	eb 05                	jmp    801077 <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  801072:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801077:	83 c4 14             	add    $0x14,%esp
  80107a:	5b                   	pop    %ebx
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    

0080107d <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	53                   	push   %ebx
  801081:	83 ec 14             	sub    $0x14,%esp
  801084:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801087:	8b 43 08             	mov    0x8(%ebx),%eax
  80108a:	85 c0                	test   %eax,%eax
  80108c:	74 5a                	je     8010e8 <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  80108e:	80 38 00             	cmpb   $0x0,(%eax)
  801091:	74 0c                	je     80109f <argnextvalue+0x22>
		args->argvalue = args->curarg;
  801093:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801096:	c7 43 08 d1 29 80 00 	movl   $0x8029d1,0x8(%ebx)
  80109d:	eb 44                	jmp    8010e3 <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  80109f:	8b 03                	mov    (%ebx),%eax
  8010a1:	83 38 01             	cmpl   $0x1,(%eax)
  8010a4:	7e 2f                	jle    8010d5 <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  8010a6:	8b 53 04             	mov    0x4(%ebx),%edx
  8010a9:	8b 4a 04             	mov    0x4(%edx),%ecx
  8010ac:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  8010af:	8b 00                	mov    (%eax),%eax
  8010b1:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  8010b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010bc:	8d 42 08             	lea    0x8(%edx),%eax
  8010bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010c3:	83 c2 04             	add    $0x4,%edx
  8010c6:	89 14 24             	mov    %edx,(%esp)
  8010c9:	e8 26 f9 ff ff       	call   8009f4 <memmove>
		(*args->argc)--;
  8010ce:	8b 03                	mov    (%ebx),%eax
  8010d0:	83 28 01             	subl   $0x1,(%eax)
  8010d3:	eb 0e                	jmp    8010e3 <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  8010d5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  8010dc:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  8010e3:	8b 43 0c             	mov    0xc(%ebx),%eax
  8010e6:	eb 05                	jmp    8010ed <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  8010e8:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  8010ed:	83 c4 14             	add    $0x14,%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    

008010f3 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	83 ec 18             	sub    $0x18,%esp
  8010f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  8010fc:	8b 51 0c             	mov    0xc(%ecx),%edx
  8010ff:	89 d0                	mov    %edx,%eax
  801101:	85 d2                	test   %edx,%edx
  801103:	75 08                	jne    80110d <argvalue+0x1a>
  801105:	89 0c 24             	mov    %ecx,(%esp)
  801108:	e8 70 ff ff ff       	call   80107d <argnextvalue>
}
  80110d:	c9                   	leave  
  80110e:	c3                   	ret    
  80110f:	90                   	nop

00801110 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	05 00 00 00 30       	add    $0x30000000,%eax
  80111b:	c1 e8 0c             	shr    $0xc,%eax
}
  80111e:	5d                   	pop    %ebp
  80111f:	c3                   	ret    

00801120 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80112b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801130:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80113d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801142:	89 c2                	mov    %eax,%edx
  801144:	c1 ea 16             	shr    $0x16,%edx
  801147:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80114e:	f6 c2 01             	test   $0x1,%dl
  801151:	74 11                	je     801164 <fd_alloc+0x2d>
  801153:	89 c2                	mov    %eax,%edx
  801155:	c1 ea 0c             	shr    $0xc,%edx
  801158:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80115f:	f6 c2 01             	test   $0x1,%dl
  801162:	75 09                	jne    80116d <fd_alloc+0x36>
			*fd_store = fd;
  801164:	89 01                	mov    %eax,(%ecx)
			return 0;
  801166:	b8 00 00 00 00       	mov    $0x0,%eax
  80116b:	eb 17                	jmp    801184 <fd_alloc+0x4d>
  80116d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801172:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801177:	75 c9                	jne    801142 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801179:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80117f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801184:	5d                   	pop    %ebp
  801185:	c3                   	ret    

00801186 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80118c:	83 f8 1f             	cmp    $0x1f,%eax
  80118f:	77 36                	ja     8011c7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801191:	c1 e0 0c             	shl    $0xc,%eax
  801194:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801199:	89 c2                	mov    %eax,%edx
  80119b:	c1 ea 16             	shr    $0x16,%edx
  80119e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011a5:	f6 c2 01             	test   $0x1,%dl
  8011a8:	74 24                	je     8011ce <fd_lookup+0x48>
  8011aa:	89 c2                	mov    %eax,%edx
  8011ac:	c1 ea 0c             	shr    $0xc,%edx
  8011af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011b6:	f6 c2 01             	test   $0x1,%dl
  8011b9:	74 1a                	je     8011d5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011be:	89 02                	mov    %eax,(%edx)
	return 0;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c5:	eb 13                	jmp    8011da <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011cc:	eb 0c                	jmp    8011da <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d3:	eb 05                	jmp    8011da <fd_lookup+0x54>
  8011d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8011da:	5d                   	pop    %ebp
  8011db:	c3                   	ret    

008011dc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 18             	sub    $0x18,%esp
  8011e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ea:	eb 13                	jmp    8011ff <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8011ec:	39 08                	cmp    %ecx,(%eax)
  8011ee:	75 0c                	jne    8011fc <dev_lookup+0x20>
			*dev = devtab[i];
  8011f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8011fa:	eb 38                	jmp    801234 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011fc:	83 c2 01             	add    $0x1,%edx
  8011ff:	8b 04 95 b0 2d 80 00 	mov    0x802db0(,%edx,4),%eax
  801206:	85 c0                	test   %eax,%eax
  801208:	75 e2                	jne    8011ec <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80120a:	a1 08 40 80 00       	mov    0x804008,%eax
  80120f:	8b 40 48             	mov    0x48(%eax),%eax
  801212:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801216:	89 44 24 04          	mov    %eax,0x4(%esp)
  80121a:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  801221:	e8 10 f0 ff ff       	call   800236 <cprintf>
	*dev = 0;
  801226:	8b 45 0c             	mov    0xc(%ebp),%eax
  801229:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80122f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801234:	c9                   	leave  
  801235:	c3                   	ret    

00801236 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	56                   	push   %esi
  80123a:	53                   	push   %ebx
  80123b:	83 ec 20             	sub    $0x20,%esp
  80123e:	8b 75 08             	mov    0x8(%ebp),%esi
  801241:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801244:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801247:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80124b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801251:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801254:	89 04 24             	mov    %eax,(%esp)
  801257:	e8 2a ff ff ff       	call   801186 <fd_lookup>
  80125c:	85 c0                	test   %eax,%eax
  80125e:	78 05                	js     801265 <fd_close+0x2f>
	    || fd != fd2)
  801260:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801263:	74 0c                	je     801271 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801265:	84 db                	test   %bl,%bl
  801267:	ba 00 00 00 00       	mov    $0x0,%edx
  80126c:	0f 44 c2             	cmove  %edx,%eax
  80126f:	eb 3f                	jmp    8012b0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801271:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801274:	89 44 24 04          	mov    %eax,0x4(%esp)
  801278:	8b 06                	mov    (%esi),%eax
  80127a:	89 04 24             	mov    %eax,(%esp)
  80127d:	e8 5a ff ff ff       	call   8011dc <dev_lookup>
  801282:	89 c3                	mov    %eax,%ebx
  801284:	85 c0                	test   %eax,%eax
  801286:	78 16                	js     80129e <fd_close+0x68>
		if (dev->dev_close)
  801288:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80128e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801293:	85 c0                	test   %eax,%eax
  801295:	74 07                	je     80129e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801297:	89 34 24             	mov    %esi,(%esp)
  80129a:	ff d0                	call   *%eax
  80129c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80129e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012a9:	e8 6c fa ff ff       	call   800d1a <sys_page_unmap>
	return r;
  8012ae:	89 d8                	mov    %ebx,%eax
}
  8012b0:	83 c4 20             	add    $0x20,%esp
  8012b3:	5b                   	pop    %ebx
  8012b4:	5e                   	pop    %esi
  8012b5:	5d                   	pop    %ebp
  8012b6:	c3                   	ret    

008012b7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	89 04 24             	mov    %eax,(%esp)
  8012ca:	e8 b7 fe ff ff       	call   801186 <fd_lookup>
  8012cf:	89 c2                	mov    %eax,%edx
  8012d1:	85 d2                	test   %edx,%edx
  8012d3:	78 13                	js     8012e8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8012d5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8012dc:	00 
  8012dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e0:	89 04 24             	mov    %eax,(%esp)
  8012e3:	e8 4e ff ff ff       	call   801236 <fd_close>
}
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <close_all>:

void
close_all(void)
{
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
  8012ed:	53                   	push   %ebx
  8012ee:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012f6:	89 1c 24             	mov    %ebx,(%esp)
  8012f9:	e8 b9 ff ff ff       	call   8012b7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8012fe:	83 c3 01             	add    $0x1,%ebx
  801301:	83 fb 20             	cmp    $0x20,%ebx
  801304:	75 f0                	jne    8012f6 <close_all+0xc>
		close(i);
}
  801306:	83 c4 14             	add    $0x14,%esp
  801309:	5b                   	pop    %ebx
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    

0080130c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	57                   	push   %edi
  801310:	56                   	push   %esi
  801311:	53                   	push   %ebx
  801312:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801315:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801318:	89 44 24 04          	mov    %eax,0x4(%esp)
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	89 04 24             	mov    %eax,(%esp)
  801322:	e8 5f fe ff ff       	call   801186 <fd_lookup>
  801327:	89 c2                	mov    %eax,%edx
  801329:	85 d2                	test   %edx,%edx
  80132b:	0f 88 e1 00 00 00    	js     801412 <dup+0x106>
		return r;
	close(newfdnum);
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	89 04 24             	mov    %eax,(%esp)
  801337:	e8 7b ff ff ff       	call   8012b7 <close>

	newfd = INDEX2FD(newfdnum);
  80133c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80133f:	c1 e3 0c             	shl    $0xc,%ebx
  801342:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801348:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80134b:	89 04 24             	mov    %eax,(%esp)
  80134e:	e8 cd fd ff ff       	call   801120 <fd2data>
  801353:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801355:	89 1c 24             	mov    %ebx,(%esp)
  801358:	e8 c3 fd ff ff       	call   801120 <fd2data>
  80135d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80135f:	89 f0                	mov    %esi,%eax
  801361:	c1 e8 16             	shr    $0x16,%eax
  801364:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80136b:	a8 01                	test   $0x1,%al
  80136d:	74 43                	je     8013b2 <dup+0xa6>
  80136f:	89 f0                	mov    %esi,%eax
  801371:	c1 e8 0c             	shr    $0xc,%eax
  801374:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80137b:	f6 c2 01             	test   $0x1,%dl
  80137e:	74 32                	je     8013b2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801380:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801387:	25 07 0e 00 00       	and    $0xe07,%eax
  80138c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801390:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801394:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80139b:	00 
  80139c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013a7:	e8 1b f9 ff ff       	call   800cc7 <sys_page_map>
  8013ac:	89 c6                	mov    %eax,%esi
  8013ae:	85 c0                	test   %eax,%eax
  8013b0:	78 3e                	js     8013f0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b5:	89 c2                	mov    %eax,%edx
  8013b7:	c1 ea 0c             	shr    $0xc,%edx
  8013ba:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013c1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013c7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013d6:	00 
  8013d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013e2:	e8 e0 f8 ff ff       	call   800cc7 <sys_page_map>
  8013e7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8013e9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013ec:	85 f6                	test   %esi,%esi
  8013ee:	79 22                	jns    801412 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8013f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013fb:	e8 1a f9 ff ff       	call   800d1a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801400:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801404:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80140b:	e8 0a f9 ff ff       	call   800d1a <sys_page_unmap>
	return r;
  801410:	89 f0                	mov    %esi,%eax
}
  801412:	83 c4 3c             	add    $0x3c,%esp
  801415:	5b                   	pop    %ebx
  801416:	5e                   	pop    %esi
  801417:	5f                   	pop    %edi
  801418:	5d                   	pop    %ebp
  801419:	c3                   	ret    

0080141a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	53                   	push   %ebx
  80141e:	83 ec 24             	sub    $0x24,%esp
  801421:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801424:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801427:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142b:	89 1c 24             	mov    %ebx,(%esp)
  80142e:	e8 53 fd ff ff       	call   801186 <fd_lookup>
  801433:	89 c2                	mov    %eax,%edx
  801435:	85 d2                	test   %edx,%edx
  801437:	78 6d                	js     8014a6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801439:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801443:	8b 00                	mov    (%eax),%eax
  801445:	89 04 24             	mov    %eax,(%esp)
  801448:	e8 8f fd ff ff       	call   8011dc <dev_lookup>
  80144d:	85 c0                	test   %eax,%eax
  80144f:	78 55                	js     8014a6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801454:	8b 50 08             	mov    0x8(%eax),%edx
  801457:	83 e2 03             	and    $0x3,%edx
  80145a:	83 fa 01             	cmp    $0x1,%edx
  80145d:	75 23                	jne    801482 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80145f:	a1 08 40 80 00       	mov    0x804008,%eax
  801464:	8b 40 48             	mov    0x48(%eax),%eax
  801467:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80146b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80146f:	c7 04 24 75 2d 80 00 	movl   $0x802d75,(%esp)
  801476:	e8 bb ed ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  80147b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801480:	eb 24                	jmp    8014a6 <read+0x8c>
	}
	if (!dev->dev_read)
  801482:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801485:	8b 52 08             	mov    0x8(%edx),%edx
  801488:	85 d2                	test   %edx,%edx
  80148a:	74 15                	je     8014a1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80148c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80148f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801493:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801496:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80149a:	89 04 24             	mov    %eax,(%esp)
  80149d:	ff d2                	call   *%edx
  80149f:	eb 05                	jmp    8014a6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8014a1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8014a6:	83 c4 24             	add    $0x24,%esp
  8014a9:	5b                   	pop    %ebx
  8014aa:	5d                   	pop    %ebp
  8014ab:	c3                   	ret    

008014ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	57                   	push   %edi
  8014b0:	56                   	push   %esi
  8014b1:	53                   	push   %ebx
  8014b2:	83 ec 1c             	sub    $0x1c,%esp
  8014b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014c0:	eb 23                	jmp    8014e5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014c2:	89 f0                	mov    %esi,%eax
  8014c4:	29 d8                	sub    %ebx,%eax
  8014c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014ca:	89 d8                	mov    %ebx,%eax
  8014cc:	03 45 0c             	add    0xc(%ebp),%eax
  8014cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d3:	89 3c 24             	mov    %edi,(%esp)
  8014d6:	e8 3f ff ff ff       	call   80141a <read>
		if (m < 0)
  8014db:	85 c0                	test   %eax,%eax
  8014dd:	78 10                	js     8014ef <readn+0x43>
			return m;
		if (m == 0)
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	74 0a                	je     8014ed <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014e3:	01 c3                	add    %eax,%ebx
  8014e5:	39 f3                	cmp    %esi,%ebx
  8014e7:	72 d9                	jb     8014c2 <readn+0x16>
  8014e9:	89 d8                	mov    %ebx,%eax
  8014eb:	eb 02                	jmp    8014ef <readn+0x43>
  8014ed:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8014ef:	83 c4 1c             	add    $0x1c,%esp
  8014f2:	5b                   	pop    %ebx
  8014f3:	5e                   	pop    %esi
  8014f4:	5f                   	pop    %edi
  8014f5:	5d                   	pop    %ebp
  8014f6:	c3                   	ret    

008014f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014f7:	55                   	push   %ebp
  8014f8:	89 e5                	mov    %esp,%ebp
  8014fa:	53                   	push   %ebx
  8014fb:	83 ec 24             	sub    $0x24,%esp
  8014fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801501:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801504:	89 44 24 04          	mov    %eax,0x4(%esp)
  801508:	89 1c 24             	mov    %ebx,(%esp)
  80150b:	e8 76 fc ff ff       	call   801186 <fd_lookup>
  801510:	89 c2                	mov    %eax,%edx
  801512:	85 d2                	test   %edx,%edx
  801514:	78 68                	js     80157e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801516:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801519:	89 44 24 04          	mov    %eax,0x4(%esp)
  80151d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801520:	8b 00                	mov    (%eax),%eax
  801522:	89 04 24             	mov    %eax,(%esp)
  801525:	e8 b2 fc ff ff       	call   8011dc <dev_lookup>
  80152a:	85 c0                	test   %eax,%eax
  80152c:	78 50                	js     80157e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80152e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801531:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801535:	75 23                	jne    80155a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801537:	a1 08 40 80 00       	mov    0x804008,%eax
  80153c:	8b 40 48             	mov    0x48(%eax),%eax
  80153f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801543:	89 44 24 04          	mov    %eax,0x4(%esp)
  801547:	c7 04 24 91 2d 80 00 	movl   $0x802d91,(%esp)
  80154e:	e8 e3 ec ff ff       	call   800236 <cprintf>
		return -E_INVAL;
  801553:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801558:	eb 24                	jmp    80157e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80155a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155d:	8b 52 0c             	mov    0xc(%edx),%edx
  801560:	85 d2                	test   %edx,%edx
  801562:	74 15                	je     801579 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801564:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801567:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80156b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80156e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801572:	89 04 24             	mov    %eax,(%esp)
  801575:	ff d2                	call   *%edx
  801577:	eb 05                	jmp    80157e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801579:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80157e:	83 c4 24             	add    $0x24,%esp
  801581:	5b                   	pop    %ebx
  801582:	5d                   	pop    %ebp
  801583:	c3                   	ret    

00801584 <seek>:

int
seek(int fdnum, off_t offset)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80158a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80158d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	89 04 24             	mov    %eax,(%esp)
  801597:	e8 ea fb ff ff       	call   801186 <fd_lookup>
  80159c:	85 c0                	test   %eax,%eax
  80159e:	78 0e                	js     8015ae <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	53                   	push   %ebx
  8015b4:	83 ec 24             	sub    $0x24,%esp
  8015b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c1:	89 1c 24             	mov    %ebx,(%esp)
  8015c4:	e8 bd fb ff ff       	call   801186 <fd_lookup>
  8015c9:	89 c2                	mov    %eax,%edx
  8015cb:	85 d2                	test   %edx,%edx
  8015cd:	78 61                	js     801630 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d9:	8b 00                	mov    (%eax),%eax
  8015db:	89 04 24             	mov    %eax,(%esp)
  8015de:	e8 f9 fb ff ff       	call   8011dc <dev_lookup>
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	78 49                	js     801630 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8015ee:	75 23                	jne    801613 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8015f0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8015f5:	8b 40 48             	mov    0x48(%eax),%eax
  8015f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801600:	c7 04 24 54 2d 80 00 	movl   $0x802d54,(%esp)
  801607:	e8 2a ec ff ff       	call   800236 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80160c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801611:	eb 1d                	jmp    801630 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801613:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801616:	8b 52 18             	mov    0x18(%edx),%edx
  801619:	85 d2                	test   %edx,%edx
  80161b:	74 0e                	je     80162b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80161d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801620:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801624:	89 04 24             	mov    %eax,(%esp)
  801627:	ff d2                	call   *%edx
  801629:	eb 05                	jmp    801630 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80162b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801630:	83 c4 24             	add    $0x24,%esp
  801633:	5b                   	pop    %ebx
  801634:	5d                   	pop    %ebp
  801635:	c3                   	ret    

00801636 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	53                   	push   %ebx
  80163a:	83 ec 24             	sub    $0x24,%esp
  80163d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801640:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801643:	89 44 24 04          	mov    %eax,0x4(%esp)
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	89 04 24             	mov    %eax,(%esp)
  80164d:	e8 34 fb ff ff       	call   801186 <fd_lookup>
  801652:	89 c2                	mov    %eax,%edx
  801654:	85 d2                	test   %edx,%edx
  801656:	78 52                	js     8016aa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801658:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801662:	8b 00                	mov    (%eax),%eax
  801664:	89 04 24             	mov    %eax,(%esp)
  801667:	e8 70 fb ff ff       	call   8011dc <dev_lookup>
  80166c:	85 c0                	test   %eax,%eax
  80166e:	78 3a                	js     8016aa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801673:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801677:	74 2c                	je     8016a5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801679:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80167c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801683:	00 00 00 
	stat->st_isdir = 0;
  801686:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80168d:	00 00 00 
	stat->st_dev = dev;
  801690:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801696:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80169a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80169d:	89 14 24             	mov    %edx,(%esp)
  8016a0:	ff 50 14             	call   *0x14(%eax)
  8016a3:	eb 05                	jmp    8016aa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016aa:	83 c4 24             	add    $0x24,%esp
  8016ad:	5b                   	pop    %ebx
  8016ae:	5d                   	pop    %ebp
  8016af:	c3                   	ret    

008016b0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	56                   	push   %esi
  8016b4:	53                   	push   %ebx
  8016b5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016bf:	00 
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	89 04 24             	mov    %eax,(%esp)
  8016c6:	e8 84 02 00 00       	call   80194f <open>
  8016cb:	89 c3                	mov    %eax,%ebx
  8016cd:	85 db                	test   %ebx,%ebx
  8016cf:	78 1b                	js     8016ec <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8016d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d8:	89 1c 24             	mov    %ebx,(%esp)
  8016db:	e8 56 ff ff ff       	call   801636 <fstat>
  8016e0:	89 c6                	mov    %eax,%esi
	close(fd);
  8016e2:	89 1c 24             	mov    %ebx,(%esp)
  8016e5:	e8 cd fb ff ff       	call   8012b7 <close>
	return r;
  8016ea:	89 f0                	mov    %esi,%eax
}
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	5b                   	pop    %ebx
  8016f0:	5e                   	pop    %esi
  8016f1:	5d                   	pop    %ebp
  8016f2:	c3                   	ret    

008016f3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	56                   	push   %esi
  8016f7:	53                   	push   %ebx
  8016f8:	83 ec 10             	sub    $0x10,%esp
  8016fb:	89 c6                	mov    %eax,%esi
  8016fd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8016ff:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801706:	75 11                	jne    801719 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801708:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80170f:	e8 a1 0f 00 00       	call   8026b5 <ipc_find_env>
  801714:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801719:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801720:	00 
  801721:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801728:	00 
  801729:	89 74 24 04          	mov    %esi,0x4(%esp)
  80172d:	a1 00 40 80 00       	mov    0x804000,%eax
  801732:	89 04 24             	mov    %eax,(%esp)
  801735:	e8 ee 0e 00 00       	call   802628 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80173a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801741:	00 
  801742:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801746:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80174d:	e8 6e 0e 00 00       	call   8025c0 <ipc_recv>
}
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	5b                   	pop    %ebx
  801756:	5e                   	pop    %esi
  801757:	5d                   	pop    %ebp
  801758:	c3                   	ret    

00801759 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	8b 40 0c             	mov    0xc(%eax),%eax
  801765:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80176a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801772:	ba 00 00 00 00       	mov    $0x0,%edx
  801777:	b8 02 00 00 00       	mov    $0x2,%eax
  80177c:	e8 72 ff ff ff       	call   8016f3 <fsipc>
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801789:	8b 45 08             	mov    0x8(%ebp),%eax
  80178c:	8b 40 0c             	mov    0xc(%eax),%eax
  80178f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801794:	ba 00 00 00 00       	mov    $0x0,%edx
  801799:	b8 06 00 00 00       	mov    $0x6,%eax
  80179e:	e8 50 ff ff ff       	call   8016f3 <fsipc>
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	53                   	push   %ebx
  8017a9:	83 ec 14             	sub    $0x14,%esp
  8017ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bf:	b8 05 00 00 00       	mov    $0x5,%eax
  8017c4:	e8 2a ff ff ff       	call   8016f3 <fsipc>
  8017c9:	89 c2                	mov    %eax,%edx
  8017cb:	85 d2                	test   %edx,%edx
  8017cd:	78 2b                	js     8017fa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017cf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017d6:	00 
  8017d7:	89 1c 24             	mov    %ebx,(%esp)
  8017da:	e8 78 f0 ff ff       	call   800857 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017df:	a1 80 50 80 00       	mov    0x805080,%eax
  8017e4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017ea:	a1 84 50 80 00       	mov    0x805084,%eax
  8017ef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fa:	83 c4 14             	add    $0x14,%esp
  8017fd:	5b                   	pop    %ebx
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    

00801800 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	53                   	push   %ebx
  801804:	83 ec 14             	sub    $0x14,%esp
  801807:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80180a:	8b 45 08             	mov    0x8(%ebp),%eax
  80180d:	8b 40 0c             	mov    0xc(%eax),%eax
  801810:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801815:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80181b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801820:	0f 46 c3             	cmovbe %ebx,%eax
  801823:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801828:	89 44 24 08          	mov    %eax,0x8(%esp)
  80182c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801833:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80183a:	e8 b5 f1 ff ff       	call   8009f4 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80183f:	ba 00 00 00 00       	mov    $0x0,%edx
  801844:	b8 04 00 00 00       	mov    $0x4,%eax
  801849:	e8 a5 fe ff ff       	call   8016f3 <fsipc>
  80184e:	85 c0                	test   %eax,%eax
  801850:	78 53                	js     8018a5 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801852:	39 c3                	cmp    %eax,%ebx
  801854:	73 24                	jae    80187a <devfile_write+0x7a>
  801856:	c7 44 24 0c c4 2d 80 	movl   $0x802dc4,0xc(%esp)
  80185d:	00 
  80185e:	c7 44 24 08 cb 2d 80 	movl   $0x802dcb,0x8(%esp)
  801865:	00 
  801866:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  80186d:	00 
  80186e:	c7 04 24 e0 2d 80 00 	movl   $0x802de0,(%esp)
  801875:	e8 ec 0c 00 00       	call   802566 <_panic>
	assert(r <= PGSIZE);
  80187a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80187f:	7e 24                	jle    8018a5 <devfile_write+0xa5>
  801881:	c7 44 24 0c eb 2d 80 	movl   $0x802deb,0xc(%esp)
  801888:	00 
  801889:	c7 44 24 08 cb 2d 80 	movl   $0x802dcb,0x8(%esp)
  801890:	00 
  801891:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801898:	00 
  801899:	c7 04 24 e0 2d 80 00 	movl   $0x802de0,(%esp)
  8018a0:	e8 c1 0c 00 00       	call   802566 <_panic>
	return r;
}
  8018a5:	83 c4 14             	add    $0x14,%esp
  8018a8:	5b                   	pop    %ebx
  8018a9:	5d                   	pop    %ebp
  8018aa:	c3                   	ret    

008018ab <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	56                   	push   %esi
  8018af:	53                   	push   %ebx
  8018b0:	83 ec 10             	sub    $0x10,%esp
  8018b3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018bc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018c1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cc:	b8 03 00 00 00       	mov    $0x3,%eax
  8018d1:	e8 1d fe ff ff       	call   8016f3 <fsipc>
  8018d6:	89 c3                	mov    %eax,%ebx
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 6a                	js     801946 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8018dc:	39 c6                	cmp    %eax,%esi
  8018de:	73 24                	jae    801904 <devfile_read+0x59>
  8018e0:	c7 44 24 0c c4 2d 80 	movl   $0x802dc4,0xc(%esp)
  8018e7:	00 
  8018e8:	c7 44 24 08 cb 2d 80 	movl   $0x802dcb,0x8(%esp)
  8018ef:	00 
  8018f0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8018f7:	00 
  8018f8:	c7 04 24 e0 2d 80 00 	movl   $0x802de0,(%esp)
  8018ff:	e8 62 0c 00 00       	call   802566 <_panic>
	assert(r <= PGSIZE);
  801904:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801909:	7e 24                	jle    80192f <devfile_read+0x84>
  80190b:	c7 44 24 0c eb 2d 80 	movl   $0x802deb,0xc(%esp)
  801912:	00 
  801913:	c7 44 24 08 cb 2d 80 	movl   $0x802dcb,0x8(%esp)
  80191a:	00 
  80191b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801922:	00 
  801923:	c7 04 24 e0 2d 80 00 	movl   $0x802de0,(%esp)
  80192a:	e8 37 0c 00 00       	call   802566 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80192f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801933:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80193a:	00 
  80193b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193e:	89 04 24             	mov    %eax,(%esp)
  801941:	e8 ae f0 ff ff       	call   8009f4 <memmove>
	return r;
}
  801946:	89 d8                	mov    %ebx,%eax
  801948:	83 c4 10             	add    $0x10,%esp
  80194b:	5b                   	pop    %ebx
  80194c:	5e                   	pop    %esi
  80194d:	5d                   	pop    %ebp
  80194e:	c3                   	ret    

0080194f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	53                   	push   %ebx
  801953:	83 ec 24             	sub    $0x24,%esp
  801956:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801959:	89 1c 24             	mov    %ebx,(%esp)
  80195c:	e8 bf ee ff ff       	call   800820 <strlen>
  801961:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801966:	7f 60                	jg     8019c8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801968:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80196b:	89 04 24             	mov    %eax,(%esp)
  80196e:	e8 c4 f7 ff ff       	call   801137 <fd_alloc>
  801973:	89 c2                	mov    %eax,%edx
  801975:	85 d2                	test   %edx,%edx
  801977:	78 54                	js     8019cd <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801979:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80197d:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801984:	e8 ce ee ff ff       	call   800857 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801989:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198c:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801994:	b8 01 00 00 00       	mov    $0x1,%eax
  801999:	e8 55 fd ff ff       	call   8016f3 <fsipc>
  80199e:	89 c3                	mov    %eax,%ebx
  8019a0:	85 c0                	test   %eax,%eax
  8019a2:	79 17                	jns    8019bb <open+0x6c>
		fd_close(fd, 0);
  8019a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019ab:	00 
  8019ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019af:	89 04 24             	mov    %eax,(%esp)
  8019b2:	e8 7f f8 ff ff       	call   801236 <fd_close>
		return r;
  8019b7:	89 d8                	mov    %ebx,%eax
  8019b9:	eb 12                	jmp    8019cd <open+0x7e>
	}

	return fd2num(fd);
  8019bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019be:	89 04 24             	mov    %eax,(%esp)
  8019c1:	e8 4a f7 ff ff       	call   801110 <fd2num>
  8019c6:	eb 05                	jmp    8019cd <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8019c8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8019cd:	83 c4 24             	add    $0x24,%esp
  8019d0:	5b                   	pop    %ebx
  8019d1:	5d                   	pop    %ebp
  8019d2:	c3                   	ret    

008019d3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8019de:	b8 08 00 00 00       	mov    $0x8,%eax
  8019e3:	e8 0b fd ff ff       	call   8016f3 <fsipc>
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	53                   	push   %ebx
  8019ee:	83 ec 14             	sub    $0x14,%esp
  8019f1:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  8019f3:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8019f7:	7e 31                	jle    801a2a <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8019f9:	8b 40 04             	mov    0x4(%eax),%eax
  8019fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a00:	8d 43 10             	lea    0x10(%ebx),%eax
  801a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a07:	8b 03                	mov    (%ebx),%eax
  801a09:	89 04 24             	mov    %eax,(%esp)
  801a0c:	e8 e6 fa ff ff       	call   8014f7 <write>
		if (result > 0)
  801a11:	85 c0                	test   %eax,%eax
  801a13:	7e 03                	jle    801a18 <writebuf+0x2e>
			b->result += result;
  801a15:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801a18:	39 43 04             	cmp    %eax,0x4(%ebx)
  801a1b:	74 0d                	je     801a2a <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a24:	0f 4f c2             	cmovg  %edx,%eax
  801a27:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801a2a:	83 c4 14             	add    $0x14,%esp
  801a2d:	5b                   	pop    %ebx
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <putch>:

static void
putch(int ch, void *thunk)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	53                   	push   %ebx
  801a34:	83 ec 04             	sub    $0x4,%esp
  801a37:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801a3a:	8b 53 04             	mov    0x4(%ebx),%edx
  801a3d:	8d 42 01             	lea    0x1(%edx),%eax
  801a40:	89 43 04             	mov    %eax,0x4(%ebx)
  801a43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a46:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801a4a:	3d 00 01 00 00       	cmp    $0x100,%eax
  801a4f:	75 0e                	jne    801a5f <putch+0x2f>
		writebuf(b);
  801a51:	89 d8                	mov    %ebx,%eax
  801a53:	e8 92 ff ff ff       	call   8019ea <writebuf>
		b->idx = 0;
  801a58:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801a5f:	83 c4 04             	add    $0x4,%esp
  801a62:	5b                   	pop    %ebx
  801a63:	5d                   	pop    %ebp
  801a64:	c3                   	ret    

00801a65 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a77:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a7e:	00 00 00 
	b.result = 0;
  801a81:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a88:	00 00 00 
	b.error = 1;
  801a8b:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a92:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a95:	8b 45 10             	mov    0x10(%ebp),%eax
  801a98:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aa3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aad:	c7 04 24 30 1a 80 00 	movl   $0x801a30,(%esp)
  801ab4:	e8 05 e9 ff ff       	call   8003be <vprintfmt>
	if (b.idx > 0)
  801ab9:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801ac0:	7e 0b                	jle    801acd <vfprintf+0x68>
		writebuf(&b);
  801ac2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ac8:	e8 1d ff ff ff       	call   8019ea <writebuf>

	return (b.result ? b.result : b.error);
  801acd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801ae4:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801ae7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aee:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	89 04 24             	mov    %eax,(%esp)
  801af8:	e8 68 ff ff ff       	call   801a65 <vfprintf>
	va_end(ap);

	return cnt;
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <printf>:

int
printf(const char *fmt, ...)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801b05:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801b08:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b13:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b1a:	e8 46 ff ff ff       	call   801a65 <vfprintf>
	va_end(ap);

	return cnt;
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    
  801b21:	66 90                	xchg   %ax,%ax
  801b23:	66 90                	xchg   %ax,%ax
  801b25:	66 90                	xchg   %ax,%ax
  801b27:	66 90                	xchg   %ax,%ax
  801b29:	66 90                	xchg   %ax,%ax
  801b2b:	66 90                	xchg   %ax,%ax
  801b2d:	66 90                	xchg   %ax,%ax
  801b2f:	90                   	nop

00801b30 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801b36:	c7 44 24 04 f7 2d 80 	movl   $0x802df7,0x4(%esp)
  801b3d:	00 
  801b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b41:	89 04 24             	mov    %eax,(%esp)
  801b44:	e8 0e ed ff ff       	call   800857 <strcpy>
	return 0;
}
  801b49:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	53                   	push   %ebx
  801b54:	83 ec 14             	sub    $0x14,%esp
  801b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801b5a:	89 1c 24             	mov    %ebx,(%esp)
  801b5d:	e8 8d 0b 00 00       	call   8026ef <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801b62:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801b67:	83 f8 01             	cmp    $0x1,%eax
  801b6a:	75 0d                	jne    801b79 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801b6c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801b6f:	89 04 24             	mov    %eax,(%esp)
  801b72:	e8 29 03 00 00       	call   801ea0 <nsipc_close>
  801b77:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801b79:	89 d0                	mov    %edx,%eax
  801b7b:	83 c4 14             	add    $0x14,%esp
  801b7e:	5b                   	pop    %ebx
  801b7f:	5d                   	pop    %ebp
  801b80:	c3                   	ret    

00801b81 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b87:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b8e:	00 
  801b8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b92:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba3:	89 04 24             	mov    %eax,(%esp)
  801ba6:	e8 f0 03 00 00       	call   801f9b <nsipc_send>
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801bb3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801bba:	00 
  801bbb:	8b 45 10             	mov    0x10(%ebp),%eax
  801bbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	8b 40 0c             	mov    0xc(%eax),%eax
  801bcf:	89 04 24             	mov    %eax,(%esp)
  801bd2:	e8 44 03 00 00       	call   801f1b <nsipc_recv>
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801bdf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801be2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801be6:	89 04 24             	mov    %eax,(%esp)
  801be9:	e8 98 f5 ff ff       	call   801186 <fd_lookup>
  801bee:	85 c0                	test   %eax,%eax
  801bf0:	78 17                	js     801c09 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801bf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801bfb:	39 08                	cmp    %ecx,(%eax)
  801bfd:	75 05                	jne    801c04 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801bff:	8b 40 0c             	mov    0xc(%eax),%eax
  801c02:	eb 05                	jmp    801c09 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801c04:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	56                   	push   %esi
  801c0f:	53                   	push   %ebx
  801c10:	83 ec 20             	sub    $0x20,%esp
  801c13:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801c15:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c18:	89 04 24             	mov    %eax,(%esp)
  801c1b:	e8 17 f5 ff ff       	call   801137 <fd_alloc>
  801c20:	89 c3                	mov    %eax,%ebx
  801c22:	85 c0                	test   %eax,%eax
  801c24:	78 21                	js     801c47 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801c26:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801c2d:	00 
  801c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c31:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c3c:	e8 32 f0 ff ff       	call   800c73 <sys_page_alloc>
  801c41:	89 c3                	mov    %eax,%ebx
  801c43:	85 c0                	test   %eax,%eax
  801c45:	79 0c                	jns    801c53 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801c47:	89 34 24             	mov    %esi,(%esp)
  801c4a:	e8 51 02 00 00       	call   801ea0 <nsipc_close>
		return r;
  801c4f:	89 d8                	mov    %ebx,%eax
  801c51:	eb 20                	jmp    801c73 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801c53:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c61:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801c68:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801c6b:	89 14 24             	mov    %edx,(%esp)
  801c6e:	e8 9d f4 ff ff       	call   801110 <fd2num>
}
  801c73:	83 c4 20             	add    $0x20,%esp
  801c76:	5b                   	pop    %ebx
  801c77:	5e                   	pop    %esi
  801c78:	5d                   	pop    %ebp
  801c79:	c3                   	ret    

00801c7a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
  801c7d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	e8 51 ff ff ff       	call   801bd9 <fd2sockid>
		return r;
  801c88:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c8a:	85 c0                	test   %eax,%eax
  801c8c:	78 23                	js     801cb1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c8e:	8b 55 10             	mov    0x10(%ebp),%edx
  801c91:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c98:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c9c:	89 04 24             	mov    %eax,(%esp)
  801c9f:	e8 45 01 00 00       	call   801de9 <nsipc_accept>
		return r;
  801ca4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	78 07                	js     801cb1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801caa:	e8 5c ff ff ff       	call   801c0b <alloc_sockfd>
  801caf:	89 c1                	mov    %eax,%ecx
}
  801cb1:	89 c8                	mov    %ecx,%eax
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	e8 16 ff ff ff       	call   801bd9 <fd2sockid>
  801cc3:	89 c2                	mov    %eax,%edx
  801cc5:	85 d2                	test   %edx,%edx
  801cc7:	78 16                	js     801cdf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd7:	89 14 24             	mov    %edx,(%esp)
  801cda:	e8 60 01 00 00       	call   801e3f <nsipc_bind>
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <shutdown>:

int
shutdown(int s, int how)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cea:	e8 ea fe ff ff       	call   801bd9 <fd2sockid>
  801cef:	89 c2                	mov    %eax,%edx
  801cf1:	85 d2                	test   %edx,%edx
  801cf3:	78 0f                	js     801d04 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cfc:	89 14 24             	mov    %edx,(%esp)
  801cff:	e8 7a 01 00 00       	call   801e7e <nsipc_shutdown>
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	e8 c5 fe ff ff       	call   801bd9 <fd2sockid>
  801d14:	89 c2                	mov    %eax,%edx
  801d16:	85 d2                	test   %edx,%edx
  801d18:	78 16                	js     801d30 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d28:	89 14 24             	mov    %edx,(%esp)
  801d2b:	e8 8a 01 00 00       	call   801eba <nsipc_connect>
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <listen>:

int
listen(int s, int backlog)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	e8 99 fe ff ff       	call   801bd9 <fd2sockid>
  801d40:	89 c2                	mov    %eax,%edx
  801d42:	85 d2                	test   %edx,%edx
  801d44:	78 0f                	js     801d55 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d4d:	89 14 24             	mov    %edx,(%esp)
  801d50:	e8 a4 01 00 00       	call   801ef9 <nsipc_listen>
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d60:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6e:	89 04 24             	mov    %eax,(%esp)
  801d71:	e8 98 02 00 00       	call   80200e <nsipc_socket>
  801d76:	89 c2                	mov    %eax,%edx
  801d78:	85 d2                	test   %edx,%edx
  801d7a:	78 05                	js     801d81 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801d7c:	e8 8a fe ff ff       	call   801c0b <alloc_sockfd>
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	53                   	push   %ebx
  801d87:	83 ec 14             	sub    $0x14,%esp
  801d8a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d8c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801d93:	75 11                	jne    801da6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d95:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801d9c:	e8 14 09 00 00       	call   8026b5 <ipc_find_env>
  801da1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801da6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801dad:	00 
  801dae:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801db5:	00 
  801db6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dba:	a1 04 40 80 00       	mov    0x804004,%eax
  801dbf:	89 04 24             	mov    %eax,(%esp)
  801dc2:	e8 61 08 00 00       	call   802628 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801dc7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dce:	00 
  801dcf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801dd6:	00 
  801dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dde:	e8 dd 07 00 00       	call   8025c0 <ipc_recv>
}
  801de3:	83 c4 14             	add    $0x14,%esp
  801de6:	5b                   	pop    %ebx
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    

00801de9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	56                   	push   %esi
  801ded:	53                   	push   %ebx
  801dee:	83 ec 10             	sub    $0x10,%esp
  801df1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801df4:	8b 45 08             	mov    0x8(%ebp),%eax
  801df7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801dfc:	8b 06                	mov    (%esi),%eax
  801dfe:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e03:	b8 01 00 00 00       	mov    $0x1,%eax
  801e08:	e8 76 ff ff ff       	call   801d83 <nsipc>
  801e0d:	89 c3                	mov    %eax,%ebx
  801e0f:	85 c0                	test   %eax,%eax
  801e11:	78 23                	js     801e36 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e13:	a1 10 60 80 00       	mov    0x806010,%eax
  801e18:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e1c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e23:	00 
  801e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e27:	89 04 24             	mov    %eax,(%esp)
  801e2a:	e8 c5 eb ff ff       	call   8009f4 <memmove>
		*addrlen = ret->ret_addrlen;
  801e2f:	a1 10 60 80 00       	mov    0x806010,%eax
  801e34:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801e36:	89 d8                	mov    %ebx,%eax
  801e38:	83 c4 10             	add    $0x10,%esp
  801e3b:	5b                   	pop    %ebx
  801e3c:	5e                   	pop    %esi
  801e3d:	5d                   	pop    %ebp
  801e3e:	c3                   	ret    

00801e3f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	53                   	push   %ebx
  801e43:	83 ec 14             	sub    $0x14,%esp
  801e46:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e51:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801e63:	e8 8c eb ff ff       	call   8009f4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e68:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e6e:	b8 02 00 00 00       	mov    $0x2,%eax
  801e73:	e8 0b ff ff ff       	call   801d83 <nsipc>
}
  801e78:	83 c4 14             	add    $0x14,%esp
  801e7b:	5b                   	pop    %ebx
  801e7c:	5d                   	pop    %ebp
  801e7d:	c3                   	ret    

00801e7e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e84:	8b 45 08             	mov    0x8(%ebp),%eax
  801e87:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e94:	b8 03 00 00 00       	mov    $0x3,%eax
  801e99:	e8 e5 fe ff ff       	call   801d83 <nsipc>
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <nsipc_close>:

int
nsipc_close(int s)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801eae:	b8 04 00 00 00       	mov    $0x4,%eax
  801eb3:	e8 cb fe ff ff       	call   801d83 <nsipc>
}
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	53                   	push   %ebx
  801ebe:	83 ec 14             	sub    $0x14,%esp
  801ec1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ecc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801ede:	e8 11 eb ff ff       	call   8009f4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ee3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ee9:	b8 05 00 00 00       	mov    $0x5,%eax
  801eee:	e8 90 fe ff ff       	call   801d83 <nsipc>
}
  801ef3:	83 c4 14             	add    $0x14,%esp
  801ef6:	5b                   	pop    %ebx
  801ef7:	5d                   	pop    %ebp
  801ef8:	c3                   	ret    

00801ef9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801f0f:	b8 06 00 00 00       	mov    $0x6,%eax
  801f14:	e8 6a fe ff ff       	call   801d83 <nsipc>
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	56                   	push   %esi
  801f1f:	53                   	push   %ebx
  801f20:	83 ec 10             	sub    $0x10,%esp
  801f23:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801f2e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801f34:	8b 45 14             	mov    0x14(%ebp),%eax
  801f37:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f3c:	b8 07 00 00 00       	mov    $0x7,%eax
  801f41:	e8 3d fe ff ff       	call   801d83 <nsipc>
  801f46:	89 c3                	mov    %eax,%ebx
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	78 46                	js     801f92 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801f4c:	39 f0                	cmp    %esi,%eax
  801f4e:	7f 07                	jg     801f57 <nsipc_recv+0x3c>
  801f50:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f55:	7e 24                	jle    801f7b <nsipc_recv+0x60>
  801f57:	c7 44 24 0c 03 2e 80 	movl   $0x802e03,0xc(%esp)
  801f5e:	00 
  801f5f:	c7 44 24 08 cb 2d 80 	movl   $0x802dcb,0x8(%esp)
  801f66:	00 
  801f67:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801f6e:	00 
  801f6f:	c7 04 24 18 2e 80 00 	movl   $0x802e18,(%esp)
  801f76:	e8 eb 05 00 00       	call   802566 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f7b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f7f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f86:	00 
  801f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8a:	89 04 24             	mov    %eax,(%esp)
  801f8d:	e8 62 ea ff ff       	call   8009f4 <memmove>
	}

	return r;
}
  801f92:	89 d8                	mov    %ebx,%eax
  801f94:	83 c4 10             	add    $0x10,%esp
  801f97:	5b                   	pop    %ebx
  801f98:	5e                   	pop    %esi
  801f99:	5d                   	pop    %ebp
  801f9a:	c3                   	ret    

00801f9b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	53                   	push   %ebx
  801f9f:	83 ec 14             	sub    $0x14,%esp
  801fa2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801fad:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fb3:	7e 24                	jle    801fd9 <nsipc_send+0x3e>
  801fb5:	c7 44 24 0c 24 2e 80 	movl   $0x802e24,0xc(%esp)
  801fbc:	00 
  801fbd:	c7 44 24 08 cb 2d 80 	movl   $0x802dcb,0x8(%esp)
  801fc4:	00 
  801fc5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801fcc:	00 
  801fcd:	c7 04 24 18 2e 80 00 	movl   $0x802e18,(%esp)
  801fd4:	e8 8d 05 00 00       	call   802566 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fd9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801feb:	e8 04 ea ff ff       	call   8009f4 <memmove>
	nsipcbuf.send.req_size = size;
  801ff0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ff6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ff9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ffe:	b8 08 00 00 00       	mov    $0x8,%eax
  802003:	e8 7b fd ff ff       	call   801d83 <nsipc>
}
  802008:	83 c4 14             	add    $0x14,%esp
  80200b:	5b                   	pop    %ebx
  80200c:	5d                   	pop    %ebp
  80200d:	c3                   	ret    

0080200e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  80201c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802024:	8b 45 10             	mov    0x10(%ebp),%eax
  802027:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  80202c:	b8 09 00 00 00       	mov    $0x9,%eax
  802031:	e8 4d fd ff ff       	call   801d83 <nsipc>
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	56                   	push   %esi
  80203c:	53                   	push   %ebx
  80203d:	83 ec 10             	sub    $0x10,%esp
  802040:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	89 04 24             	mov    %eax,(%esp)
  802049:	e8 d2 f0 ff ff       	call   801120 <fd2data>
  80204e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802050:	c7 44 24 04 30 2e 80 	movl   $0x802e30,0x4(%esp)
  802057:	00 
  802058:	89 1c 24             	mov    %ebx,(%esp)
  80205b:	e8 f7 e7 ff ff       	call   800857 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802060:	8b 46 04             	mov    0x4(%esi),%eax
  802063:	2b 06                	sub    (%esi),%eax
  802065:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80206b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802072:	00 00 00 
	stat->st_dev = &devpipe;
  802075:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  80207c:	30 80 00 
	return 0;
}
  80207f:	b8 00 00 00 00       	mov    $0x0,%eax
  802084:	83 c4 10             	add    $0x10,%esp
  802087:	5b                   	pop    %ebx
  802088:	5e                   	pop    %esi
  802089:	5d                   	pop    %ebp
  80208a:	c3                   	ret    

0080208b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	53                   	push   %ebx
  80208f:	83 ec 14             	sub    $0x14,%esp
  802092:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802095:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802099:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a0:	e8 75 ec ff ff       	call   800d1a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8020a5:	89 1c 24             	mov    %ebx,(%esp)
  8020a8:	e8 73 f0 ff ff       	call   801120 <fd2data>
  8020ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b8:	e8 5d ec ff ff       	call   800d1a <sys_page_unmap>
}
  8020bd:	83 c4 14             	add    $0x14,%esp
  8020c0:	5b                   	pop    %ebx
  8020c1:	5d                   	pop    %ebp
  8020c2:	c3                   	ret    

008020c3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	57                   	push   %edi
  8020c7:	56                   	push   %esi
  8020c8:	53                   	push   %ebx
  8020c9:	83 ec 2c             	sub    $0x2c,%esp
  8020cc:	89 c6                	mov    %eax,%esi
  8020ce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8020d1:	a1 08 40 80 00       	mov    0x804008,%eax
  8020d6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020d9:	89 34 24             	mov    %esi,(%esp)
  8020dc:	e8 0e 06 00 00       	call   8026ef <pageref>
  8020e1:	89 c7                	mov    %eax,%edi
  8020e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e6:	89 04 24             	mov    %eax,(%esp)
  8020e9:	e8 01 06 00 00       	call   8026ef <pageref>
  8020ee:	39 c7                	cmp    %eax,%edi
  8020f0:	0f 94 c2             	sete   %dl
  8020f3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8020f6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  8020fc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8020ff:	39 fb                	cmp    %edi,%ebx
  802101:	74 21                	je     802124 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802103:	84 d2                	test   %dl,%dl
  802105:	74 ca                	je     8020d1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802107:	8b 51 58             	mov    0x58(%ecx),%edx
  80210a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80210e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802112:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802116:	c7 04 24 37 2e 80 00 	movl   $0x802e37,(%esp)
  80211d:	e8 14 e1 ff ff       	call   800236 <cprintf>
  802122:	eb ad                	jmp    8020d1 <_pipeisclosed+0xe>
	}
}
  802124:	83 c4 2c             	add    $0x2c,%esp
  802127:	5b                   	pop    %ebx
  802128:	5e                   	pop    %esi
  802129:	5f                   	pop    %edi
  80212a:	5d                   	pop    %ebp
  80212b:	c3                   	ret    

0080212c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	57                   	push   %edi
  802130:	56                   	push   %esi
  802131:	53                   	push   %ebx
  802132:	83 ec 1c             	sub    $0x1c,%esp
  802135:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802138:	89 34 24             	mov    %esi,(%esp)
  80213b:	e8 e0 ef ff ff       	call   801120 <fd2data>
  802140:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802142:	bf 00 00 00 00       	mov    $0x0,%edi
  802147:	eb 45                	jmp    80218e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802149:	89 da                	mov    %ebx,%edx
  80214b:	89 f0                	mov    %esi,%eax
  80214d:	e8 71 ff ff ff       	call   8020c3 <_pipeisclosed>
  802152:	85 c0                	test   %eax,%eax
  802154:	75 41                	jne    802197 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802156:	e8 f9 ea ff ff       	call   800c54 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80215b:	8b 43 04             	mov    0x4(%ebx),%eax
  80215e:	8b 0b                	mov    (%ebx),%ecx
  802160:	8d 51 20             	lea    0x20(%ecx),%edx
  802163:	39 d0                	cmp    %edx,%eax
  802165:	73 e2                	jae    802149 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802167:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80216a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80216e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802171:	99                   	cltd   
  802172:	c1 ea 1b             	shr    $0x1b,%edx
  802175:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802178:	83 e1 1f             	and    $0x1f,%ecx
  80217b:	29 d1                	sub    %edx,%ecx
  80217d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802181:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802185:	83 c0 01             	add    $0x1,%eax
  802188:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80218b:	83 c7 01             	add    $0x1,%edi
  80218e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802191:	75 c8                	jne    80215b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802193:	89 f8                	mov    %edi,%eax
  802195:	eb 05                	jmp    80219c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802197:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80219c:	83 c4 1c             	add    $0x1c,%esp
  80219f:	5b                   	pop    %ebx
  8021a0:	5e                   	pop    %esi
  8021a1:	5f                   	pop    %edi
  8021a2:	5d                   	pop    %ebp
  8021a3:	c3                   	ret    

008021a4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	57                   	push   %edi
  8021a8:	56                   	push   %esi
  8021a9:	53                   	push   %ebx
  8021aa:	83 ec 1c             	sub    $0x1c,%esp
  8021ad:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8021b0:	89 3c 24             	mov    %edi,(%esp)
  8021b3:	e8 68 ef ff ff       	call   801120 <fd2data>
  8021b8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021ba:	be 00 00 00 00       	mov    $0x0,%esi
  8021bf:	eb 3d                	jmp    8021fe <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8021c1:	85 f6                	test   %esi,%esi
  8021c3:	74 04                	je     8021c9 <devpipe_read+0x25>
				return i;
  8021c5:	89 f0                	mov    %esi,%eax
  8021c7:	eb 43                	jmp    80220c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8021c9:	89 da                	mov    %ebx,%edx
  8021cb:	89 f8                	mov    %edi,%eax
  8021cd:	e8 f1 fe ff ff       	call   8020c3 <_pipeisclosed>
  8021d2:	85 c0                	test   %eax,%eax
  8021d4:	75 31                	jne    802207 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8021d6:	e8 79 ea ff ff       	call   800c54 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8021db:	8b 03                	mov    (%ebx),%eax
  8021dd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021e0:	74 df                	je     8021c1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021e2:	99                   	cltd   
  8021e3:	c1 ea 1b             	shr    $0x1b,%edx
  8021e6:	01 d0                	add    %edx,%eax
  8021e8:	83 e0 1f             	and    $0x1f,%eax
  8021eb:	29 d0                	sub    %edx,%eax
  8021ed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021f5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021f8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021fb:	83 c6 01             	add    $0x1,%esi
  8021fe:	3b 75 10             	cmp    0x10(%ebp),%esi
  802201:	75 d8                	jne    8021db <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802203:	89 f0                	mov    %esi,%eax
  802205:	eb 05                	jmp    80220c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802207:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80220c:	83 c4 1c             	add    $0x1c,%esp
  80220f:	5b                   	pop    %ebx
  802210:	5e                   	pop    %esi
  802211:	5f                   	pop    %edi
  802212:	5d                   	pop    %ebp
  802213:	c3                   	ret    

00802214 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	56                   	push   %esi
  802218:	53                   	push   %ebx
  802219:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80221c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80221f:	89 04 24             	mov    %eax,(%esp)
  802222:	e8 10 ef ff ff       	call   801137 <fd_alloc>
  802227:	89 c2                	mov    %eax,%edx
  802229:	85 d2                	test   %edx,%edx
  80222b:	0f 88 4d 01 00 00    	js     80237e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802231:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802238:	00 
  802239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802247:	e8 27 ea ff ff       	call   800c73 <sys_page_alloc>
  80224c:	89 c2                	mov    %eax,%edx
  80224e:	85 d2                	test   %edx,%edx
  802250:	0f 88 28 01 00 00    	js     80237e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802256:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802259:	89 04 24             	mov    %eax,(%esp)
  80225c:	e8 d6 ee ff ff       	call   801137 <fd_alloc>
  802261:	89 c3                	mov    %eax,%ebx
  802263:	85 c0                	test   %eax,%eax
  802265:	0f 88 fe 00 00 00    	js     802369 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80226b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802272:	00 
  802273:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802276:	89 44 24 04          	mov    %eax,0x4(%esp)
  80227a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802281:	e8 ed e9 ff ff       	call   800c73 <sys_page_alloc>
  802286:	89 c3                	mov    %eax,%ebx
  802288:	85 c0                	test   %eax,%eax
  80228a:	0f 88 d9 00 00 00    	js     802369 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	89 04 24             	mov    %eax,(%esp)
  802296:	e8 85 ee ff ff       	call   801120 <fd2data>
  80229b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80229d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022a4:	00 
  8022a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b0:	e8 be e9 ff ff       	call   800c73 <sys_page_alloc>
  8022b5:	89 c3                	mov    %eax,%ebx
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	0f 88 97 00 00 00    	js     802356 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c2:	89 04 24             	mov    %eax,(%esp)
  8022c5:	e8 56 ee ff ff       	call   801120 <fd2data>
  8022ca:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8022d1:	00 
  8022d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022dd:	00 
  8022de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022e9:	e8 d9 e9 ff ff       	call   800cc7 <sys_page_map>
  8022ee:	89 c3                	mov    %eax,%ebx
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	78 52                	js     802346 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8022f4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802309:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80230f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802312:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802317:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80231e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802321:	89 04 24             	mov    %eax,(%esp)
  802324:	e8 e7 ed ff ff       	call   801110 <fd2num>
  802329:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80232c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80232e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802331:	89 04 24             	mov    %eax,(%esp)
  802334:	e8 d7 ed ff ff       	call   801110 <fd2num>
  802339:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80233c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80233f:	b8 00 00 00 00       	mov    $0x0,%eax
  802344:	eb 38                	jmp    80237e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802346:	89 74 24 04          	mov    %esi,0x4(%esp)
  80234a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802351:	e8 c4 e9 ff ff       	call   800d1a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802359:	89 44 24 04          	mov    %eax,0x4(%esp)
  80235d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802364:	e8 b1 e9 ff ff       	call   800d1a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802370:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802377:	e8 9e e9 ff ff       	call   800d1a <sys_page_unmap>
  80237c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80237e:	83 c4 30             	add    $0x30,%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5d                   	pop    %ebp
  802384:	c3                   	ret    

00802385 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
  802388:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80238b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80238e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	89 04 24             	mov    %eax,(%esp)
  802398:	e8 e9 ed ff ff       	call   801186 <fd_lookup>
  80239d:	89 c2                	mov    %eax,%edx
  80239f:	85 d2                	test   %edx,%edx
  8023a1:	78 15                	js     8023b8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a6:	89 04 24             	mov    %eax,(%esp)
  8023a9:	e8 72 ed ff ff       	call   801120 <fd2data>
	return _pipeisclosed(fd, p);
  8023ae:	89 c2                	mov    %eax,%edx
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	e8 0b fd ff ff       	call   8020c3 <_pipeisclosed>
}
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    
  8023ba:	66 90                	xchg   %ax,%ax
  8023bc:	66 90                	xchg   %ax,%ax
  8023be:	66 90                	xchg   %ax,%ax

008023c0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8023c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c8:	5d                   	pop    %ebp
  8023c9:	c3                   	ret    

008023ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8023d0:	c7 44 24 04 4f 2e 80 	movl   $0x802e4f,0x4(%esp)
  8023d7:	00 
  8023d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023db:	89 04 24             	mov    %eax,(%esp)
  8023de:	e8 74 e4 ff ff       	call   800857 <strcpy>
	return 0;
}
  8023e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e8:	c9                   	leave  
  8023e9:	c3                   	ret    

008023ea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
  8023ed:	57                   	push   %edi
  8023ee:	56                   	push   %esi
  8023ef:	53                   	push   %ebx
  8023f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023f6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8023fb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802401:	eb 31                	jmp    802434 <devcons_write+0x4a>
		m = n - tot;
  802403:	8b 75 10             	mov    0x10(%ebp),%esi
  802406:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802408:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80240b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802410:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802413:	89 74 24 08          	mov    %esi,0x8(%esp)
  802417:	03 45 0c             	add    0xc(%ebp),%eax
  80241a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80241e:	89 3c 24             	mov    %edi,(%esp)
  802421:	e8 ce e5 ff ff       	call   8009f4 <memmove>
		sys_cputs(buf, m);
  802426:	89 74 24 04          	mov    %esi,0x4(%esp)
  80242a:	89 3c 24             	mov    %edi,(%esp)
  80242d:	e8 74 e7 ff ff       	call   800ba6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802432:	01 f3                	add    %esi,%ebx
  802434:	89 d8                	mov    %ebx,%eax
  802436:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802439:	72 c8                	jb     802403 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80243b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802441:	5b                   	pop    %ebx
  802442:	5e                   	pop    %esi
  802443:	5f                   	pop    %edi
  802444:	5d                   	pop    %ebp
  802445:	c3                   	ret    

00802446 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802446:	55                   	push   %ebp
  802447:	89 e5                	mov    %esp,%ebp
  802449:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80244c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802451:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802455:	75 07                	jne    80245e <devcons_read+0x18>
  802457:	eb 2a                	jmp    802483 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802459:	e8 f6 e7 ff ff       	call   800c54 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80245e:	66 90                	xchg   %ax,%ax
  802460:	e8 5f e7 ff ff       	call   800bc4 <sys_cgetc>
  802465:	85 c0                	test   %eax,%eax
  802467:	74 f0                	je     802459 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802469:	85 c0                	test   %eax,%eax
  80246b:	78 16                	js     802483 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80246d:	83 f8 04             	cmp    $0x4,%eax
  802470:	74 0c                	je     80247e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802472:	8b 55 0c             	mov    0xc(%ebp),%edx
  802475:	88 02                	mov    %al,(%edx)
	return 1;
  802477:	b8 01 00 00 00       	mov    $0x1,%eax
  80247c:	eb 05                	jmp    802483 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80247e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802483:	c9                   	leave  
  802484:	c3                   	ret    

00802485 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802491:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802498:	00 
  802499:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80249c:	89 04 24             	mov    %eax,(%esp)
  80249f:	e8 02 e7 ff ff       	call   800ba6 <sys_cputs>
}
  8024a4:	c9                   	leave  
  8024a5:	c3                   	ret    

008024a6 <getchar>:

int
getchar(void)
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
  8024a9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8024ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8024b3:	00 
  8024b4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c2:	e8 53 ef ff ff       	call   80141a <read>
	if (r < 0)
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	78 0f                	js     8024da <getchar+0x34>
		return r;
	if (r < 1)
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	7e 06                	jle    8024d5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8024cf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8024d3:	eb 05                	jmp    8024da <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8024d5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8024da:	c9                   	leave  
  8024db:	c3                   	ret    

008024dc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
  8024df:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ec:	89 04 24             	mov    %eax,(%esp)
  8024ef:	e8 92 ec ff ff       	call   801186 <fd_lookup>
  8024f4:	85 c0                	test   %eax,%eax
  8024f6:	78 11                	js     802509 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802501:	39 10                	cmp    %edx,(%eax)
  802503:	0f 94 c0             	sete   %al
  802506:	0f b6 c0             	movzbl %al,%eax
}
  802509:	c9                   	leave  
  80250a:	c3                   	ret    

0080250b <opencons>:

int
opencons(void)
{
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
  80250e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802511:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802514:	89 04 24             	mov    %eax,(%esp)
  802517:	e8 1b ec ff ff       	call   801137 <fd_alloc>
		return r;
  80251c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80251e:	85 c0                	test   %eax,%eax
  802520:	78 40                	js     802562 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802522:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802529:	00 
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802531:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802538:	e8 36 e7 ff ff       	call   800c73 <sys_page_alloc>
		return r;
  80253d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80253f:	85 c0                	test   %eax,%eax
  802541:	78 1f                	js     802562 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802543:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802558:	89 04 24             	mov    %eax,(%esp)
  80255b:	e8 b0 eb ff ff       	call   801110 <fd2num>
  802560:	89 c2                	mov    %eax,%edx
}
  802562:	89 d0                	mov    %edx,%eax
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
  802569:	56                   	push   %esi
  80256a:	53                   	push   %ebx
  80256b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80256e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802571:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802577:	e8 b9 e6 ff ff       	call   800c35 <sys_getenvid>
  80257c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802583:	8b 55 08             	mov    0x8(%ebp),%edx
  802586:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80258a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80258e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802592:	c7 04 24 5c 2e 80 00 	movl   $0x802e5c,(%esp)
  802599:	e8 98 dc ff ff       	call   800236 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80259e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8025a5:	89 04 24             	mov    %eax,(%esp)
  8025a8:	e8 28 dc ff ff       	call   8001d5 <vcprintf>
	cprintf("\n");
  8025ad:	c7 04 24 d0 29 80 00 	movl   $0x8029d0,(%esp)
  8025b4:	e8 7d dc ff ff       	call   800236 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8025b9:	cc                   	int3   
  8025ba:	eb fd                	jmp    8025b9 <_panic+0x53>
  8025bc:	66 90                	xchg   %ax,%ax
  8025be:	66 90                	xchg   %ax,%ax

008025c0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	56                   	push   %esi
  8025c4:	53                   	push   %ebx
  8025c5:	83 ec 10             	sub    $0x10,%esp
  8025c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8025cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8025d1:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  8025d3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8025d8:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  8025db:	89 04 24             	mov    %eax,(%esp)
  8025de:	e8 a6 e8 ff ff       	call   800e89 <sys_ipc_recv>
  8025e3:	85 c0                	test   %eax,%eax
  8025e5:	74 16                	je     8025fd <ipc_recv+0x3d>
		if (from_env_store != NULL)
  8025e7:	85 f6                	test   %esi,%esi
  8025e9:	74 06                	je     8025f1 <ipc_recv+0x31>
			*from_env_store = 0;
  8025eb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8025f1:	85 db                	test   %ebx,%ebx
  8025f3:	74 2c                	je     802621 <ipc_recv+0x61>
			*perm_store = 0;
  8025f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8025fb:	eb 24                	jmp    802621 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8025fd:	85 f6                	test   %esi,%esi
  8025ff:	74 0a                	je     80260b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802601:	a1 08 40 80 00       	mov    0x804008,%eax
  802606:	8b 40 74             	mov    0x74(%eax),%eax
  802609:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80260b:	85 db                	test   %ebx,%ebx
  80260d:	74 0a                	je     802619 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80260f:	a1 08 40 80 00       	mov    0x804008,%eax
  802614:	8b 40 78             	mov    0x78(%eax),%eax
  802617:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802619:	a1 08 40 80 00       	mov    0x804008,%eax
  80261e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802621:	83 c4 10             	add    $0x10,%esp
  802624:	5b                   	pop    %ebx
  802625:	5e                   	pop    %esi
  802626:	5d                   	pop    %ebp
  802627:	c3                   	ret    

00802628 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802628:	55                   	push   %ebp
  802629:	89 e5                	mov    %esp,%ebp
  80262b:	57                   	push   %edi
  80262c:	56                   	push   %esi
  80262d:	53                   	push   %ebx
  80262e:	83 ec 1c             	sub    $0x1c,%esp
  802631:	8b 75 0c             	mov    0xc(%ebp),%esi
  802634:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802637:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80263a:	85 db                	test   %ebx,%ebx
  80263c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802641:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802644:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802648:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80264c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802650:	8b 45 08             	mov    0x8(%ebp),%eax
  802653:	89 04 24             	mov    %eax,(%esp)
  802656:	e8 0b e8 ff ff       	call   800e66 <sys_ipc_try_send>
	if (r == 0) return;
  80265b:	85 c0                	test   %eax,%eax
  80265d:	75 22                	jne    802681 <ipc_send+0x59>
  80265f:	eb 4c                	jmp    8026ad <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802661:	84 d2                	test   %dl,%dl
  802663:	75 48                	jne    8026ad <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802665:	e8 ea e5 ff ff       	call   800c54 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80266a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80266e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802672:	89 74 24 04          	mov    %esi,0x4(%esp)
  802676:	8b 45 08             	mov    0x8(%ebp),%eax
  802679:	89 04 24             	mov    %eax,(%esp)
  80267c:	e8 e5 e7 ff ff       	call   800e66 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802681:	85 c0                	test   %eax,%eax
  802683:	0f 94 c2             	sete   %dl
  802686:	74 d9                	je     802661 <ipc_send+0x39>
  802688:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80268b:	74 d4                	je     802661 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80268d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802691:	c7 44 24 08 80 2e 80 	movl   $0x802e80,0x8(%esp)
  802698:	00 
  802699:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  8026a0:	00 
  8026a1:	c7 04 24 8e 2e 80 00 	movl   $0x802e8e,(%esp)
  8026a8:	e8 b9 fe ff ff       	call   802566 <_panic>
}
  8026ad:	83 c4 1c             	add    $0x1c,%esp
  8026b0:	5b                   	pop    %ebx
  8026b1:	5e                   	pop    %esi
  8026b2:	5f                   	pop    %edi
  8026b3:	5d                   	pop    %ebp
  8026b4:	c3                   	ret    

008026b5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
  8026b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8026bb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8026c0:	89 c2                	mov    %eax,%edx
  8026c2:	c1 e2 07             	shl    $0x7,%edx
  8026c5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8026cb:	8b 52 50             	mov    0x50(%edx),%edx
  8026ce:	39 ca                	cmp    %ecx,%edx
  8026d0:	75 0d                	jne    8026df <ipc_find_env+0x2a>
			return envs[i].env_id;
  8026d2:	c1 e0 07             	shl    $0x7,%eax
  8026d5:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8026da:	8b 40 40             	mov    0x40(%eax),%eax
  8026dd:	eb 0e                	jmp    8026ed <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8026df:	83 c0 01             	add    $0x1,%eax
  8026e2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8026e7:	75 d7                	jne    8026c0 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8026e9:	66 b8 00 00          	mov    $0x0,%ax
}
  8026ed:	5d                   	pop    %ebp
  8026ee:	c3                   	ret    

008026ef <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
  8026f2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8026f5:	89 d0                	mov    %edx,%eax
  8026f7:	c1 e8 16             	shr    $0x16,%eax
  8026fa:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802701:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802706:	f6 c1 01             	test   $0x1,%cl
  802709:	74 1d                	je     802728 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80270b:	c1 ea 0c             	shr    $0xc,%edx
  80270e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802715:	f6 c2 01             	test   $0x1,%dl
  802718:	74 0e                	je     802728 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80271a:	c1 ea 0c             	shr    $0xc,%edx
  80271d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802724:	ef 
  802725:	0f b7 c0             	movzwl %ax,%eax
}
  802728:	5d                   	pop    %ebp
  802729:	c3                   	ret    
  80272a:	66 90                	xchg   %ax,%ax
  80272c:	66 90                	xchg   %ax,%ax
  80272e:	66 90                	xchg   %ax,%ax

00802730 <__udivdi3>:
  802730:	55                   	push   %ebp
  802731:	57                   	push   %edi
  802732:	56                   	push   %esi
  802733:	83 ec 0c             	sub    $0xc,%esp
  802736:	8b 44 24 28          	mov    0x28(%esp),%eax
  80273a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80273e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802742:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802746:	85 c0                	test   %eax,%eax
  802748:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80274c:	89 ea                	mov    %ebp,%edx
  80274e:	89 0c 24             	mov    %ecx,(%esp)
  802751:	75 2d                	jne    802780 <__udivdi3+0x50>
  802753:	39 e9                	cmp    %ebp,%ecx
  802755:	77 61                	ja     8027b8 <__udivdi3+0x88>
  802757:	85 c9                	test   %ecx,%ecx
  802759:	89 ce                	mov    %ecx,%esi
  80275b:	75 0b                	jne    802768 <__udivdi3+0x38>
  80275d:	b8 01 00 00 00       	mov    $0x1,%eax
  802762:	31 d2                	xor    %edx,%edx
  802764:	f7 f1                	div    %ecx
  802766:	89 c6                	mov    %eax,%esi
  802768:	31 d2                	xor    %edx,%edx
  80276a:	89 e8                	mov    %ebp,%eax
  80276c:	f7 f6                	div    %esi
  80276e:	89 c5                	mov    %eax,%ebp
  802770:	89 f8                	mov    %edi,%eax
  802772:	f7 f6                	div    %esi
  802774:	89 ea                	mov    %ebp,%edx
  802776:	83 c4 0c             	add    $0xc,%esp
  802779:	5e                   	pop    %esi
  80277a:	5f                   	pop    %edi
  80277b:	5d                   	pop    %ebp
  80277c:	c3                   	ret    
  80277d:	8d 76 00             	lea    0x0(%esi),%esi
  802780:	39 e8                	cmp    %ebp,%eax
  802782:	77 24                	ja     8027a8 <__udivdi3+0x78>
  802784:	0f bd e8             	bsr    %eax,%ebp
  802787:	83 f5 1f             	xor    $0x1f,%ebp
  80278a:	75 3c                	jne    8027c8 <__udivdi3+0x98>
  80278c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802790:	39 34 24             	cmp    %esi,(%esp)
  802793:	0f 86 9f 00 00 00    	jbe    802838 <__udivdi3+0x108>
  802799:	39 d0                	cmp    %edx,%eax
  80279b:	0f 82 97 00 00 00    	jb     802838 <__udivdi3+0x108>
  8027a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8027a8:	31 d2                	xor    %edx,%edx
  8027aa:	31 c0                	xor    %eax,%eax
  8027ac:	83 c4 0c             	add    $0xc,%esp
  8027af:	5e                   	pop    %esi
  8027b0:	5f                   	pop    %edi
  8027b1:	5d                   	pop    %ebp
  8027b2:	c3                   	ret    
  8027b3:	90                   	nop
  8027b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027b8:	89 f8                	mov    %edi,%eax
  8027ba:	f7 f1                	div    %ecx
  8027bc:	31 d2                	xor    %edx,%edx
  8027be:	83 c4 0c             	add    $0xc,%esp
  8027c1:	5e                   	pop    %esi
  8027c2:	5f                   	pop    %edi
  8027c3:	5d                   	pop    %ebp
  8027c4:	c3                   	ret    
  8027c5:	8d 76 00             	lea    0x0(%esi),%esi
  8027c8:	89 e9                	mov    %ebp,%ecx
  8027ca:	8b 3c 24             	mov    (%esp),%edi
  8027cd:	d3 e0                	shl    %cl,%eax
  8027cf:	89 c6                	mov    %eax,%esi
  8027d1:	b8 20 00 00 00       	mov    $0x20,%eax
  8027d6:	29 e8                	sub    %ebp,%eax
  8027d8:	89 c1                	mov    %eax,%ecx
  8027da:	d3 ef                	shr    %cl,%edi
  8027dc:	89 e9                	mov    %ebp,%ecx
  8027de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8027e2:	8b 3c 24             	mov    (%esp),%edi
  8027e5:	09 74 24 08          	or     %esi,0x8(%esp)
  8027e9:	89 d6                	mov    %edx,%esi
  8027eb:	d3 e7                	shl    %cl,%edi
  8027ed:	89 c1                	mov    %eax,%ecx
  8027ef:	89 3c 24             	mov    %edi,(%esp)
  8027f2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8027f6:	d3 ee                	shr    %cl,%esi
  8027f8:	89 e9                	mov    %ebp,%ecx
  8027fa:	d3 e2                	shl    %cl,%edx
  8027fc:	89 c1                	mov    %eax,%ecx
  8027fe:	d3 ef                	shr    %cl,%edi
  802800:	09 d7                	or     %edx,%edi
  802802:	89 f2                	mov    %esi,%edx
  802804:	89 f8                	mov    %edi,%eax
  802806:	f7 74 24 08          	divl   0x8(%esp)
  80280a:	89 d6                	mov    %edx,%esi
  80280c:	89 c7                	mov    %eax,%edi
  80280e:	f7 24 24             	mull   (%esp)
  802811:	39 d6                	cmp    %edx,%esi
  802813:	89 14 24             	mov    %edx,(%esp)
  802816:	72 30                	jb     802848 <__udivdi3+0x118>
  802818:	8b 54 24 04          	mov    0x4(%esp),%edx
  80281c:	89 e9                	mov    %ebp,%ecx
  80281e:	d3 e2                	shl    %cl,%edx
  802820:	39 c2                	cmp    %eax,%edx
  802822:	73 05                	jae    802829 <__udivdi3+0xf9>
  802824:	3b 34 24             	cmp    (%esp),%esi
  802827:	74 1f                	je     802848 <__udivdi3+0x118>
  802829:	89 f8                	mov    %edi,%eax
  80282b:	31 d2                	xor    %edx,%edx
  80282d:	e9 7a ff ff ff       	jmp    8027ac <__udivdi3+0x7c>
  802832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802838:	31 d2                	xor    %edx,%edx
  80283a:	b8 01 00 00 00       	mov    $0x1,%eax
  80283f:	e9 68 ff ff ff       	jmp    8027ac <__udivdi3+0x7c>
  802844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802848:	8d 47 ff             	lea    -0x1(%edi),%eax
  80284b:	31 d2                	xor    %edx,%edx
  80284d:	83 c4 0c             	add    $0xc,%esp
  802850:	5e                   	pop    %esi
  802851:	5f                   	pop    %edi
  802852:	5d                   	pop    %ebp
  802853:	c3                   	ret    
  802854:	66 90                	xchg   %ax,%ax
  802856:	66 90                	xchg   %ax,%ax
  802858:	66 90                	xchg   %ax,%ax
  80285a:	66 90                	xchg   %ax,%ax
  80285c:	66 90                	xchg   %ax,%ax
  80285e:	66 90                	xchg   %ax,%ax

00802860 <__umoddi3>:
  802860:	55                   	push   %ebp
  802861:	57                   	push   %edi
  802862:	56                   	push   %esi
  802863:	83 ec 14             	sub    $0x14,%esp
  802866:	8b 44 24 28          	mov    0x28(%esp),%eax
  80286a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80286e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802872:	89 c7                	mov    %eax,%edi
  802874:	89 44 24 04          	mov    %eax,0x4(%esp)
  802878:	8b 44 24 30          	mov    0x30(%esp),%eax
  80287c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802880:	89 34 24             	mov    %esi,(%esp)
  802883:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802887:	85 c0                	test   %eax,%eax
  802889:	89 c2                	mov    %eax,%edx
  80288b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80288f:	75 17                	jne    8028a8 <__umoddi3+0x48>
  802891:	39 fe                	cmp    %edi,%esi
  802893:	76 4b                	jbe    8028e0 <__umoddi3+0x80>
  802895:	89 c8                	mov    %ecx,%eax
  802897:	89 fa                	mov    %edi,%edx
  802899:	f7 f6                	div    %esi
  80289b:	89 d0                	mov    %edx,%eax
  80289d:	31 d2                	xor    %edx,%edx
  80289f:	83 c4 14             	add    $0x14,%esp
  8028a2:	5e                   	pop    %esi
  8028a3:	5f                   	pop    %edi
  8028a4:	5d                   	pop    %ebp
  8028a5:	c3                   	ret    
  8028a6:	66 90                	xchg   %ax,%ax
  8028a8:	39 f8                	cmp    %edi,%eax
  8028aa:	77 54                	ja     802900 <__umoddi3+0xa0>
  8028ac:	0f bd e8             	bsr    %eax,%ebp
  8028af:	83 f5 1f             	xor    $0x1f,%ebp
  8028b2:	75 5c                	jne    802910 <__umoddi3+0xb0>
  8028b4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8028b8:	39 3c 24             	cmp    %edi,(%esp)
  8028bb:	0f 87 e7 00 00 00    	ja     8029a8 <__umoddi3+0x148>
  8028c1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8028c5:	29 f1                	sub    %esi,%ecx
  8028c7:	19 c7                	sbb    %eax,%edi
  8028c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8028cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028d1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028d5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8028d9:	83 c4 14             	add    $0x14,%esp
  8028dc:	5e                   	pop    %esi
  8028dd:	5f                   	pop    %edi
  8028de:	5d                   	pop    %ebp
  8028df:	c3                   	ret    
  8028e0:	85 f6                	test   %esi,%esi
  8028e2:	89 f5                	mov    %esi,%ebp
  8028e4:	75 0b                	jne    8028f1 <__umoddi3+0x91>
  8028e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8028eb:	31 d2                	xor    %edx,%edx
  8028ed:	f7 f6                	div    %esi
  8028ef:	89 c5                	mov    %eax,%ebp
  8028f1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8028f5:	31 d2                	xor    %edx,%edx
  8028f7:	f7 f5                	div    %ebp
  8028f9:	89 c8                	mov    %ecx,%eax
  8028fb:	f7 f5                	div    %ebp
  8028fd:	eb 9c                	jmp    80289b <__umoddi3+0x3b>
  8028ff:	90                   	nop
  802900:	89 c8                	mov    %ecx,%eax
  802902:	89 fa                	mov    %edi,%edx
  802904:	83 c4 14             	add    $0x14,%esp
  802907:	5e                   	pop    %esi
  802908:	5f                   	pop    %edi
  802909:	5d                   	pop    %ebp
  80290a:	c3                   	ret    
  80290b:	90                   	nop
  80290c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802910:	8b 04 24             	mov    (%esp),%eax
  802913:	be 20 00 00 00       	mov    $0x20,%esi
  802918:	89 e9                	mov    %ebp,%ecx
  80291a:	29 ee                	sub    %ebp,%esi
  80291c:	d3 e2                	shl    %cl,%edx
  80291e:	89 f1                	mov    %esi,%ecx
  802920:	d3 e8                	shr    %cl,%eax
  802922:	89 e9                	mov    %ebp,%ecx
  802924:	89 44 24 04          	mov    %eax,0x4(%esp)
  802928:	8b 04 24             	mov    (%esp),%eax
  80292b:	09 54 24 04          	or     %edx,0x4(%esp)
  80292f:	89 fa                	mov    %edi,%edx
  802931:	d3 e0                	shl    %cl,%eax
  802933:	89 f1                	mov    %esi,%ecx
  802935:	89 44 24 08          	mov    %eax,0x8(%esp)
  802939:	8b 44 24 10          	mov    0x10(%esp),%eax
  80293d:	d3 ea                	shr    %cl,%edx
  80293f:	89 e9                	mov    %ebp,%ecx
  802941:	d3 e7                	shl    %cl,%edi
  802943:	89 f1                	mov    %esi,%ecx
  802945:	d3 e8                	shr    %cl,%eax
  802947:	89 e9                	mov    %ebp,%ecx
  802949:	09 f8                	or     %edi,%eax
  80294b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80294f:	f7 74 24 04          	divl   0x4(%esp)
  802953:	d3 e7                	shl    %cl,%edi
  802955:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802959:	89 d7                	mov    %edx,%edi
  80295b:	f7 64 24 08          	mull   0x8(%esp)
  80295f:	39 d7                	cmp    %edx,%edi
  802961:	89 c1                	mov    %eax,%ecx
  802963:	89 14 24             	mov    %edx,(%esp)
  802966:	72 2c                	jb     802994 <__umoddi3+0x134>
  802968:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80296c:	72 22                	jb     802990 <__umoddi3+0x130>
  80296e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802972:	29 c8                	sub    %ecx,%eax
  802974:	19 d7                	sbb    %edx,%edi
  802976:	89 e9                	mov    %ebp,%ecx
  802978:	89 fa                	mov    %edi,%edx
  80297a:	d3 e8                	shr    %cl,%eax
  80297c:	89 f1                	mov    %esi,%ecx
  80297e:	d3 e2                	shl    %cl,%edx
  802980:	89 e9                	mov    %ebp,%ecx
  802982:	d3 ef                	shr    %cl,%edi
  802984:	09 d0                	or     %edx,%eax
  802986:	89 fa                	mov    %edi,%edx
  802988:	83 c4 14             	add    $0x14,%esp
  80298b:	5e                   	pop    %esi
  80298c:	5f                   	pop    %edi
  80298d:	5d                   	pop    %ebp
  80298e:	c3                   	ret    
  80298f:	90                   	nop
  802990:	39 d7                	cmp    %edx,%edi
  802992:	75 da                	jne    80296e <__umoddi3+0x10e>
  802994:	8b 14 24             	mov    (%esp),%edx
  802997:	89 c1                	mov    %eax,%ecx
  802999:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80299d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8029a1:	eb cb                	jmp    80296e <__umoddi3+0x10e>
  8029a3:	90                   	nop
  8029a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029a8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8029ac:	0f 82 0f ff ff ff    	jb     8028c1 <__umoddi3+0x61>
  8029b2:	e9 1a ff ff ff       	jmp    8028d1 <__umoddi3+0x71>
