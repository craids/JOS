
obj/user/forktree.debug:     file format elf32-i386


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
  80002c:	e8 c2 00 00 00       	call   8000f3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003d:	e8 c3 0b 00 00       	call   800c05 <sys_getenvid>
  800042:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800046:	89 44 24 04          	mov    %eax,0x4(%esp)
  80004a:	c7 04 24 c0 2b 80 00 	movl   $0x802bc0,(%esp)
  800051:	e8 a1 01 00 00       	call   8001f7 <cprintf>

	forkchild(cur, '0');
  800056:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80005d:	00 
  80005e:	89 1c 24             	mov    %ebx,(%esp)
  800061:	e8 16 00 00 00       	call   80007c <forkchild>
	forkchild(cur, '1');
  800066:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
  80006d:	00 
  80006e:	89 1c 24             	mov    %ebx,(%esp)
  800071:	e8 06 00 00 00       	call   80007c <forkchild>
}
  800076:	83 c4 14             	add    $0x14,%esp
  800079:	5b                   	pop    %ebx
  80007a:	5d                   	pop    %ebp
  80007b:	c3                   	ret    

0080007c <forkchild>:

void forktree(const char *cur);

void
forkchild(const char *cur, char branch)
{
  80007c:	55                   	push   %ebp
  80007d:	89 e5                	mov    %esp,%ebp
  80007f:	56                   	push   %esi
  800080:	53                   	push   %ebx
  800081:	83 ec 30             	sub    $0x30,%esp
  800084:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800087:	8b 75 0c             	mov    0xc(%ebp),%esi
	char nxt[DEPTH+1];

	if (strlen(cur) >= DEPTH)
  80008a:	89 1c 24             	mov    %ebx,(%esp)
  80008d:	e8 5e 07 00 00       	call   8007f0 <strlen>
  800092:	83 f8 02             	cmp    $0x2,%eax
  800095:	7f 41                	jg     8000d8 <forkchild+0x5c>
		return;

	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800097:	89 f0                	mov    %esi,%eax
  800099:	0f be f0             	movsbl %al,%esi
  80009c:	89 74 24 10          	mov    %esi,0x10(%esp)
  8000a0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000a4:	c7 44 24 08 d1 2b 80 	movl   $0x802bd1,0x8(%esp)
  8000ab:	00 
  8000ac:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  8000b3:	00 
  8000b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000b7:	89 04 24             	mov    %eax,(%esp)
  8000ba:	e8 fb 06 00 00       	call   8007ba <snprintf>
	if (fork() == 0) {
  8000bf:	e8 cc 0f 00 00       	call   801090 <fork>
  8000c4:	85 c0                	test   %eax,%eax
  8000c6:	75 10                	jne    8000d8 <forkchild+0x5c>
		forktree(nxt);
  8000c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000cb:	89 04 24             	mov    %eax,(%esp)
  8000ce:	e8 60 ff ff ff       	call   800033 <forktree>
		exit();
  8000d3:	e8 63 00 00 00       	call   80013b <exit>
	}
}
  8000d8:	83 c4 30             	add    $0x30,%esp
  8000db:	5b                   	pop    %ebx
  8000dc:	5e                   	pop    %esi
  8000dd:	5d                   	pop    %ebp
  8000de:	c3                   	ret    

008000df <umain>:
	forkchild(cur, '1');
}

void
umain(int argc, char **argv)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	83 ec 18             	sub    $0x18,%esp
	forktree("");
  8000e5:	c7 04 24 d0 2b 80 00 	movl   $0x802bd0,(%esp)
  8000ec:	e8 42 ff ff ff       	call   800033 <forktree>
}
  8000f1:	c9                   	leave  
  8000f2:	c3                   	ret    

008000f3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f3:	55                   	push   %ebp
  8000f4:	89 e5                	mov    %esp,%ebp
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	83 ec 10             	sub    $0x10,%esp
  8000fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000fe:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800101:	e8 ff 0a 00 00       	call   800c05 <sys_getenvid>
  800106:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010b:	c1 e0 07             	shl    $0x7,%eax
  80010e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800113:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800118:	85 db                	test   %ebx,%ebx
  80011a:	7e 07                	jle    800123 <libmain+0x30>
		binaryname = argv[0];
  80011c:	8b 06                	mov    (%esi),%eax
  80011e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800123:	89 74 24 04          	mov    %esi,0x4(%esp)
  800127:	89 1c 24             	mov    %ebx,(%esp)
  80012a:	e8 b0 ff ff ff       	call   8000df <umain>

	// exit gracefully
	exit();
  80012f:	e8 07 00 00 00       	call   80013b <exit>
}
  800134:	83 c4 10             	add    $0x10,%esp
  800137:	5b                   	pop    %ebx
  800138:	5e                   	pop    %esi
  800139:	5d                   	pop    %ebp
  80013a:	c3                   	ret    

0080013b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800141:	e8 24 14 00 00       	call   80156a <close_all>
	sys_env_destroy(0);
  800146:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014d:	e8 61 0a 00 00       	call   800bb3 <sys_env_destroy>
}
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	53                   	push   %ebx
  800158:	83 ec 14             	sub    $0x14,%esp
  80015b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80015e:	8b 13                	mov    (%ebx),%edx
  800160:	8d 42 01             	lea    0x1(%edx),%eax
  800163:	89 03                	mov    %eax,(%ebx)
  800165:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800168:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80016c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800171:	75 19                	jne    80018c <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800173:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80017a:	00 
  80017b:	8d 43 08             	lea    0x8(%ebx),%eax
  80017e:	89 04 24             	mov    %eax,(%esp)
  800181:	e8 f0 09 00 00       	call   800b76 <sys_cputs>
		b->idx = 0;
  800186:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80018c:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800190:	83 c4 14             	add    $0x14,%esp
  800193:	5b                   	pop    %ebx
  800194:	5d                   	pop    %ebp
  800195:	c3                   	ret    

00800196 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80019f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001a6:	00 00 00 
	b.cnt = 0;
  8001a9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001c1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001cb:	c7 04 24 54 01 80 00 	movl   $0x800154,(%esp)
  8001d2:	e8 b7 01 00 00       	call   80038e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e1:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e7:	89 04 24             	mov    %eax,(%esp)
  8001ea:	e8 87 09 00 00       	call   800b76 <sys_cputs>

	return b.cnt;
}
  8001ef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f5:	c9                   	leave  
  8001f6:	c3                   	ret    

008001f7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f7:	55                   	push   %ebp
  8001f8:	89 e5                	mov    %esp,%ebp
  8001fa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fd:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800200:	89 44 24 04          	mov    %eax,0x4(%esp)
  800204:	8b 45 08             	mov    0x8(%ebp),%eax
  800207:	89 04 24             	mov    %eax,(%esp)
  80020a:	e8 87 ff ff ff       	call   800196 <vcprintf>
	va_end(ap);

	return cnt;
}
  80020f:	c9                   	leave  
  800210:	c3                   	ret    
  800211:	66 90                	xchg   %ax,%ax
  800213:	66 90                	xchg   %ax,%ax
  800215:	66 90                	xchg   %ax,%ax
  800217:	66 90                	xchg   %ax,%ax
  800219:	66 90                	xchg   %ax,%ax
  80021b:	66 90                	xchg   %ax,%ax
  80021d:	66 90                	xchg   %ax,%ax
  80021f:	90                   	nop

00800220 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	57                   	push   %edi
  800224:	56                   	push   %esi
  800225:	53                   	push   %ebx
  800226:	83 ec 3c             	sub    $0x3c,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80022c:	89 d7                	mov    %edx,%edi
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800234:	8b 45 0c             	mov    0xc(%ebp),%eax
  800237:	89 c3                	mov    %eax,%ebx
  800239:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80023c:	8b 45 10             	mov    0x10(%ebp),%eax
  80023f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800242:	b9 00 00 00 00       	mov    $0x0,%ecx
  800247:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80024a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80024d:	39 d9                	cmp    %ebx,%ecx
  80024f:	72 05                	jb     800256 <printnum+0x36>
  800251:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800254:	77 69                	ja     8002bf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800256:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800259:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80025d:	83 ee 01             	sub    $0x1,%esi
  800260:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800264:	89 44 24 08          	mov    %eax,0x8(%esp)
  800268:	8b 44 24 08          	mov    0x8(%esp),%eax
  80026c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800270:	89 c3                	mov    %eax,%ebx
  800272:	89 d6                	mov    %edx,%esi
  800274:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800277:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80027a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80027e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800282:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800285:	89 04 24             	mov    %eax,(%esp)
  800288:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028f:	e8 8c 26 00 00       	call   802920 <__udivdi3>
  800294:	89 d9                	mov    %ebx,%ecx
  800296:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80029a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80029e:	89 04 24             	mov    %eax,(%esp)
  8002a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002a5:	89 fa                	mov    %edi,%edx
  8002a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002aa:	e8 71 ff ff ff       	call   800220 <printnum>
  8002af:	eb 1b                	jmp    8002cc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002b8:	89 04 24             	mov    %eax,(%esp)
  8002bb:	ff d3                	call   *%ebx
  8002bd:	eb 03                	jmp    8002c2 <printnum+0xa2>
  8002bf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002c2:	83 ee 01             	sub    $0x1,%esi
  8002c5:	85 f6                	test   %esi,%esi
  8002c7:	7f e8                	jg     8002b1 <printnum+0x91>
  8002c9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002d0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002de:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002e5:	89 04 24             	mov    %eax,(%esp)
  8002e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ef:	e8 5c 27 00 00       	call   802a50 <__umoddi3>
  8002f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f8:	0f be 80 e0 2b 80 00 	movsbl 0x802be0(%eax),%eax
  8002ff:	89 04 24             	mov    %eax,(%esp)
  800302:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800305:	ff d0                	call   *%eax
}
  800307:	83 c4 3c             	add    $0x3c,%esp
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5f                   	pop    %edi
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    

0080030f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800312:	83 fa 01             	cmp    $0x1,%edx
  800315:	7e 0e                	jle    800325 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800317:	8b 10                	mov    (%eax),%edx
  800319:	8d 4a 08             	lea    0x8(%edx),%ecx
  80031c:	89 08                	mov    %ecx,(%eax)
  80031e:	8b 02                	mov    (%edx),%eax
  800320:	8b 52 04             	mov    0x4(%edx),%edx
  800323:	eb 22                	jmp    800347 <getuint+0x38>
	else if (lflag)
  800325:	85 d2                	test   %edx,%edx
  800327:	74 10                	je     800339 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800329:	8b 10                	mov    (%eax),%edx
  80032b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80032e:	89 08                	mov    %ecx,(%eax)
  800330:	8b 02                	mov    (%edx),%eax
  800332:	ba 00 00 00 00       	mov    $0x0,%edx
  800337:	eb 0e                	jmp    800347 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800339:	8b 10                	mov    (%eax),%edx
  80033b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80033e:	89 08                	mov    %ecx,(%eax)
  800340:	8b 02                	mov    (%edx),%eax
  800342:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800347:	5d                   	pop    %ebp
  800348:	c3                   	ret    

00800349 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800349:	55                   	push   %ebp
  80034a:	89 e5                	mov    %esp,%ebp
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80034f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800353:	8b 10                	mov    (%eax),%edx
  800355:	3b 50 04             	cmp    0x4(%eax),%edx
  800358:	73 0a                	jae    800364 <sprintputch+0x1b>
		*b->buf++ = ch;
  80035a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80035d:	89 08                	mov    %ecx,(%eax)
  80035f:	8b 45 08             	mov    0x8(%ebp),%eax
  800362:	88 02                	mov    %al,(%edx)
}
  800364:	5d                   	pop    %ebp
  800365:	c3                   	ret    

00800366 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800366:	55                   	push   %ebp
  800367:	89 e5                	mov    %esp,%ebp
  800369:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80036c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80036f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800373:	8b 45 10             	mov    0x10(%ebp),%eax
  800376:	89 44 24 08          	mov    %eax,0x8(%esp)
  80037a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80037d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	89 04 24             	mov    %eax,(%esp)
  800387:	e8 02 00 00 00       	call   80038e <vprintfmt>
	va_end(ap);
}
  80038c:	c9                   	leave  
  80038d:	c3                   	ret    

0080038e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	57                   	push   %edi
  800392:	56                   	push   %esi
  800393:	53                   	push   %ebx
  800394:	83 ec 3c             	sub    $0x3c,%esp
  800397:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80039a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80039d:	eb 14                	jmp    8003b3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80039f:	85 c0                	test   %eax,%eax
  8003a1:	0f 84 b3 03 00 00    	je     80075a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8003a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003ab:	89 04 24             	mov    %eax,(%esp)
  8003ae:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003b1:	89 f3                	mov    %esi,%ebx
  8003b3:	8d 73 01             	lea    0x1(%ebx),%esi
  8003b6:	0f b6 03             	movzbl (%ebx),%eax
  8003b9:	83 f8 25             	cmp    $0x25,%eax
  8003bc:	75 e1                	jne    80039f <vprintfmt+0x11>
  8003be:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8003c2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003c9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8003d0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8003d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003dc:	eb 1d                	jmp    8003fb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003de:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003e0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8003e4:	eb 15                	jmp    8003fb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003e8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8003ec:	eb 0d                	jmp    8003fb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003f1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003f4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003fb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8003fe:	0f b6 0e             	movzbl (%esi),%ecx
  800401:	0f b6 c1             	movzbl %cl,%eax
  800404:	83 e9 23             	sub    $0x23,%ecx
  800407:	80 f9 55             	cmp    $0x55,%cl
  80040a:	0f 87 2a 03 00 00    	ja     80073a <vprintfmt+0x3ac>
  800410:	0f b6 c9             	movzbl %cl,%ecx
  800413:	ff 24 8d 20 2d 80 00 	jmp    *0x802d20(,%ecx,4)
  80041a:	89 de                	mov    %ebx,%esi
  80041c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800421:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800424:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800428:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80042b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80042e:	83 fb 09             	cmp    $0x9,%ebx
  800431:	77 36                	ja     800469 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800433:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800436:	eb e9                	jmp    800421 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800438:	8b 45 14             	mov    0x14(%ebp),%eax
  80043b:	8d 48 04             	lea    0x4(%eax),%ecx
  80043e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800441:	8b 00                	mov    (%eax),%eax
  800443:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800446:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800448:	eb 22                	jmp    80046c <vprintfmt+0xde>
  80044a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80044d:	85 c9                	test   %ecx,%ecx
  80044f:	b8 00 00 00 00       	mov    $0x0,%eax
  800454:	0f 49 c1             	cmovns %ecx,%eax
  800457:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045a:	89 de                	mov    %ebx,%esi
  80045c:	eb 9d                	jmp    8003fb <vprintfmt+0x6d>
  80045e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800460:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800467:	eb 92                	jmp    8003fb <vprintfmt+0x6d>
  800469:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80046c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800470:	79 89                	jns    8003fb <vprintfmt+0x6d>
  800472:	e9 77 ff ff ff       	jmp    8003ee <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800477:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80047c:	e9 7a ff ff ff       	jmp    8003fb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800481:	8b 45 14             	mov    0x14(%ebp),%eax
  800484:	8d 50 04             	lea    0x4(%eax),%edx
  800487:	89 55 14             	mov    %edx,0x14(%ebp)
  80048a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80048e:	8b 00                	mov    (%eax),%eax
  800490:	89 04 24             	mov    %eax,(%esp)
  800493:	ff 55 08             	call   *0x8(%ebp)
			break;
  800496:	e9 18 ff ff ff       	jmp    8003b3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80049b:	8b 45 14             	mov    0x14(%ebp),%eax
  80049e:	8d 50 04             	lea    0x4(%eax),%edx
  8004a1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	99                   	cltd   
  8004a7:	31 d0                	xor    %edx,%eax
  8004a9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004ab:	83 f8 11             	cmp    $0x11,%eax
  8004ae:	7f 0b                	jg     8004bb <vprintfmt+0x12d>
  8004b0:	8b 14 85 80 2e 80 00 	mov    0x802e80(,%eax,4),%edx
  8004b7:	85 d2                	test   %edx,%edx
  8004b9:	75 20                	jne    8004db <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8004bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004bf:	c7 44 24 08 f8 2b 80 	movl   $0x802bf8,0x8(%esp)
  8004c6:	00 
  8004c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ce:	89 04 24             	mov    %eax,(%esp)
  8004d1:	e8 90 fe ff ff       	call   800366 <printfmt>
  8004d6:	e9 d8 fe ff ff       	jmp    8003b3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8004db:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004df:	c7 44 24 08 ad 30 80 	movl   $0x8030ad,0x8(%esp)
  8004e6:	00 
  8004e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ee:	89 04 24             	mov    %eax,(%esp)
  8004f1:	e8 70 fe ff ff       	call   800366 <printfmt>
  8004f6:	e9 b8 fe ff ff       	jmp    8003b3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800501:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800504:	8b 45 14             	mov    0x14(%ebp),%eax
  800507:	8d 50 04             	lea    0x4(%eax),%edx
  80050a:	89 55 14             	mov    %edx,0x14(%ebp)
  80050d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80050f:	85 f6                	test   %esi,%esi
  800511:	b8 f1 2b 80 00       	mov    $0x802bf1,%eax
  800516:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800519:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80051d:	0f 84 97 00 00 00    	je     8005ba <vprintfmt+0x22c>
  800523:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800527:	0f 8e 9b 00 00 00    	jle    8005c8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80052d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800531:	89 34 24             	mov    %esi,(%esp)
  800534:	e8 cf 02 00 00       	call   800808 <strnlen>
  800539:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80053c:	29 c2                	sub    %eax,%edx
  80053e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800541:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800545:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800548:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80054b:	8b 75 08             	mov    0x8(%ebp),%esi
  80054e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800551:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800553:	eb 0f                	jmp    800564 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800555:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800559:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80055c:	89 04 24             	mov    %eax,(%esp)
  80055f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800561:	83 eb 01             	sub    $0x1,%ebx
  800564:	85 db                	test   %ebx,%ebx
  800566:	7f ed                	jg     800555 <vprintfmt+0x1c7>
  800568:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80056b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80056e:	85 d2                	test   %edx,%edx
  800570:	b8 00 00 00 00       	mov    $0x0,%eax
  800575:	0f 49 c2             	cmovns %edx,%eax
  800578:	29 c2                	sub    %eax,%edx
  80057a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80057d:	89 d7                	mov    %edx,%edi
  80057f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800582:	eb 50                	jmp    8005d4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800584:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800588:	74 1e                	je     8005a8 <vprintfmt+0x21a>
  80058a:	0f be d2             	movsbl %dl,%edx
  80058d:	83 ea 20             	sub    $0x20,%edx
  800590:	83 fa 5e             	cmp    $0x5e,%edx
  800593:	76 13                	jbe    8005a8 <vprintfmt+0x21a>
					putch('?', putdat);
  800595:	8b 45 0c             	mov    0xc(%ebp),%eax
  800598:	89 44 24 04          	mov    %eax,0x4(%esp)
  80059c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005a3:	ff 55 08             	call   *0x8(%ebp)
  8005a6:	eb 0d                	jmp    8005b5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8005a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005af:	89 04 24             	mov    %eax,(%esp)
  8005b2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005b5:	83 ef 01             	sub    $0x1,%edi
  8005b8:	eb 1a                	jmp    8005d4 <vprintfmt+0x246>
  8005ba:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005bd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005c0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005c3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005c6:	eb 0c                	jmp    8005d4 <vprintfmt+0x246>
  8005c8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005cb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005ce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005d1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005d4:	83 c6 01             	add    $0x1,%esi
  8005d7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8005db:	0f be c2             	movsbl %dl,%eax
  8005de:	85 c0                	test   %eax,%eax
  8005e0:	74 27                	je     800609 <vprintfmt+0x27b>
  8005e2:	85 db                	test   %ebx,%ebx
  8005e4:	78 9e                	js     800584 <vprintfmt+0x1f6>
  8005e6:	83 eb 01             	sub    $0x1,%ebx
  8005e9:	79 99                	jns    800584 <vprintfmt+0x1f6>
  8005eb:	89 f8                	mov    %edi,%eax
  8005ed:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005f3:	89 c3                	mov    %eax,%ebx
  8005f5:	eb 1a                	jmp    800611 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005fb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800602:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800604:	83 eb 01             	sub    $0x1,%ebx
  800607:	eb 08                	jmp    800611 <vprintfmt+0x283>
  800609:	89 fb                	mov    %edi,%ebx
  80060b:	8b 75 08             	mov    0x8(%ebp),%esi
  80060e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800611:	85 db                	test   %ebx,%ebx
  800613:	7f e2                	jg     8005f7 <vprintfmt+0x269>
  800615:	89 75 08             	mov    %esi,0x8(%ebp)
  800618:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80061b:	e9 93 fd ff ff       	jmp    8003b3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800620:	83 fa 01             	cmp    $0x1,%edx
  800623:	7e 16                	jle    80063b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8d 50 08             	lea    0x8(%eax),%edx
  80062b:	89 55 14             	mov    %edx,0x14(%ebp)
  80062e:	8b 50 04             	mov    0x4(%eax),%edx
  800631:	8b 00                	mov    (%eax),%eax
  800633:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800636:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800639:	eb 32                	jmp    80066d <vprintfmt+0x2df>
	else if (lflag)
  80063b:	85 d2                	test   %edx,%edx
  80063d:	74 18                	je     800657 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80063f:	8b 45 14             	mov    0x14(%ebp),%eax
  800642:	8d 50 04             	lea    0x4(%eax),%edx
  800645:	89 55 14             	mov    %edx,0x14(%ebp)
  800648:	8b 30                	mov    (%eax),%esi
  80064a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80064d:	89 f0                	mov    %esi,%eax
  80064f:	c1 f8 1f             	sar    $0x1f,%eax
  800652:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800655:	eb 16                	jmp    80066d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8d 50 04             	lea    0x4(%eax),%edx
  80065d:	89 55 14             	mov    %edx,0x14(%ebp)
  800660:	8b 30                	mov    (%eax),%esi
  800662:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800665:	89 f0                	mov    %esi,%eax
  800667:	c1 f8 1f             	sar    $0x1f,%eax
  80066a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80066d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800670:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800673:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800678:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067c:	0f 89 80 00 00 00    	jns    800702 <vprintfmt+0x374>
				putch('-', putdat);
  800682:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800686:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80068d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800693:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800696:	f7 d8                	neg    %eax
  800698:	83 d2 00             	adc    $0x0,%edx
  80069b:	f7 da                	neg    %edx
			}
			base = 10;
  80069d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006a2:	eb 5e                	jmp    800702 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006a4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a7:	e8 63 fc ff ff       	call   80030f <getuint>
			base = 10;
  8006ac:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006b1:	eb 4f                	jmp    800702 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b6:	e8 54 fc ff ff       	call   80030f <getuint>
			base = 8;
  8006bb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006c0:	eb 40                	jmp    800702 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  8006c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006cd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006db:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006ee:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006f3:	eb 0d                	jmp    800702 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006f5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f8:	e8 12 fc ff ff       	call   80030f <getuint>
			base = 16;
  8006fd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800702:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800706:	89 74 24 10          	mov    %esi,0x10(%esp)
  80070a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80070d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800711:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800715:	89 04 24             	mov    %eax,(%esp)
  800718:	89 54 24 04          	mov    %edx,0x4(%esp)
  80071c:	89 fa                	mov    %edi,%edx
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	e8 fa fa ff ff       	call   800220 <printnum>
			break;
  800726:	e9 88 fc ff ff       	jmp    8003b3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80072b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80072f:	89 04 24             	mov    %eax,(%esp)
  800732:	ff 55 08             	call   *0x8(%ebp)
			break;
  800735:	e9 79 fc ff ff       	jmp    8003b3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80073a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80073e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800745:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800748:	89 f3                	mov    %esi,%ebx
  80074a:	eb 03                	jmp    80074f <vprintfmt+0x3c1>
  80074c:	83 eb 01             	sub    $0x1,%ebx
  80074f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800753:	75 f7                	jne    80074c <vprintfmt+0x3be>
  800755:	e9 59 fc ff ff       	jmp    8003b3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80075a:	83 c4 3c             	add    $0x3c,%esp
  80075d:	5b                   	pop    %ebx
  80075e:	5e                   	pop    %esi
  80075f:	5f                   	pop    %edi
  800760:	5d                   	pop    %ebp
  800761:	c3                   	ret    

00800762 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
  800765:	83 ec 28             	sub    $0x28,%esp
  800768:	8b 45 08             	mov    0x8(%ebp),%eax
  80076b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80076e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800771:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800775:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800778:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80077f:	85 c0                	test   %eax,%eax
  800781:	74 30                	je     8007b3 <vsnprintf+0x51>
  800783:	85 d2                	test   %edx,%edx
  800785:	7e 2c                	jle    8007b3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80078e:	8b 45 10             	mov    0x10(%ebp),%eax
  800791:	89 44 24 08          	mov    %eax,0x8(%esp)
  800795:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800798:	89 44 24 04          	mov    %eax,0x4(%esp)
  80079c:	c7 04 24 49 03 80 00 	movl   $0x800349,(%esp)
  8007a3:	e8 e6 fb ff ff       	call   80038e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ab:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b1:	eb 05                	jmp    8007b8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007b8:	c9                   	leave  
  8007b9:	c3                   	ret    

008007ba <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ba:	55                   	push   %ebp
  8007bb:	89 e5                	mov    %esp,%ebp
  8007bd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007c0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	89 04 24             	mov    %eax,(%esp)
  8007db:	e8 82 ff ff ff       	call   800762 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007e0:	c9                   	leave  
  8007e1:	c3                   	ret    
  8007e2:	66 90                	xchg   %ax,%ax
  8007e4:	66 90                	xchg   %ax,%ax
  8007e6:	66 90                	xchg   %ax,%ax
  8007e8:	66 90                	xchg   %ax,%ax
  8007ea:	66 90                	xchg   %ax,%ax
  8007ec:	66 90                	xchg   %ax,%ax
  8007ee:	66 90                	xchg   %ax,%ax

008007f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fb:	eb 03                	jmp    800800 <strlen+0x10>
		n++;
  8007fd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800800:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800804:	75 f7                	jne    8007fd <strlen+0xd>
		n++;
	return n;
}
  800806:	5d                   	pop    %ebp
  800807:	c3                   	ret    

00800808 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80080e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800811:	b8 00 00 00 00       	mov    $0x0,%eax
  800816:	eb 03                	jmp    80081b <strnlen+0x13>
		n++;
  800818:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80081b:	39 d0                	cmp    %edx,%eax
  80081d:	74 06                	je     800825 <strnlen+0x1d>
  80081f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800823:	75 f3                	jne    800818 <strnlen+0x10>
		n++;
	return n;
}
  800825:	5d                   	pop    %ebp
  800826:	c3                   	ret    

00800827 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800827:	55                   	push   %ebp
  800828:	89 e5                	mov    %esp,%ebp
  80082a:	53                   	push   %ebx
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800831:	89 c2                	mov    %eax,%edx
  800833:	83 c2 01             	add    $0x1,%edx
  800836:	83 c1 01             	add    $0x1,%ecx
  800839:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80083d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800840:	84 db                	test   %bl,%bl
  800842:	75 ef                	jne    800833 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800844:	5b                   	pop    %ebx
  800845:	5d                   	pop    %ebp
  800846:	c3                   	ret    

00800847 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800847:	55                   	push   %ebp
  800848:	89 e5                	mov    %esp,%ebp
  80084a:	53                   	push   %ebx
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800851:	89 1c 24             	mov    %ebx,(%esp)
  800854:	e8 97 ff ff ff       	call   8007f0 <strlen>
	strcpy(dst + len, src);
  800859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800860:	01 d8                	add    %ebx,%eax
  800862:	89 04 24             	mov    %eax,(%esp)
  800865:	e8 bd ff ff ff       	call   800827 <strcpy>
	return dst;
}
  80086a:	89 d8                	mov    %ebx,%eax
  80086c:	83 c4 08             	add    $0x8,%esp
  80086f:	5b                   	pop    %ebx
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	56                   	push   %esi
  800876:	53                   	push   %ebx
  800877:	8b 75 08             	mov    0x8(%ebp),%esi
  80087a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80087d:	89 f3                	mov    %esi,%ebx
  80087f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800882:	89 f2                	mov    %esi,%edx
  800884:	eb 0f                	jmp    800895 <strncpy+0x23>
		*dst++ = *src;
  800886:	83 c2 01             	add    $0x1,%edx
  800889:	0f b6 01             	movzbl (%ecx),%eax
  80088c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80088f:	80 39 01             	cmpb   $0x1,(%ecx)
  800892:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800895:	39 da                	cmp    %ebx,%edx
  800897:	75 ed                	jne    800886 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800899:	89 f0                	mov    %esi,%eax
  80089b:	5b                   	pop    %ebx
  80089c:	5e                   	pop    %esi
  80089d:	5d                   	pop    %ebp
  80089e:	c3                   	ret    

0080089f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80089f:	55                   	push   %ebp
  8008a0:	89 e5                	mov    %esp,%ebp
  8008a2:	56                   	push   %esi
  8008a3:	53                   	push   %ebx
  8008a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008ad:	89 f0                	mov    %esi,%eax
  8008af:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008b3:	85 c9                	test   %ecx,%ecx
  8008b5:	75 0b                	jne    8008c2 <strlcpy+0x23>
  8008b7:	eb 1d                	jmp    8008d6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008b9:	83 c0 01             	add    $0x1,%eax
  8008bc:	83 c2 01             	add    $0x1,%edx
  8008bf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008c2:	39 d8                	cmp    %ebx,%eax
  8008c4:	74 0b                	je     8008d1 <strlcpy+0x32>
  8008c6:	0f b6 0a             	movzbl (%edx),%ecx
  8008c9:	84 c9                	test   %cl,%cl
  8008cb:	75 ec                	jne    8008b9 <strlcpy+0x1a>
  8008cd:	89 c2                	mov    %eax,%edx
  8008cf:	eb 02                	jmp    8008d3 <strlcpy+0x34>
  8008d1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8008d3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8008d6:	29 f0                	sub    %esi,%eax
}
  8008d8:	5b                   	pop    %ebx
  8008d9:	5e                   	pop    %esi
  8008da:	5d                   	pop    %ebp
  8008db:	c3                   	ret    

008008dc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008dc:	55                   	push   %ebp
  8008dd:	89 e5                	mov    %esp,%ebp
  8008df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008e2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008e5:	eb 06                	jmp    8008ed <strcmp+0x11>
		p++, q++;
  8008e7:	83 c1 01             	add    $0x1,%ecx
  8008ea:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008ed:	0f b6 01             	movzbl (%ecx),%eax
  8008f0:	84 c0                	test   %al,%al
  8008f2:	74 04                	je     8008f8 <strcmp+0x1c>
  8008f4:	3a 02                	cmp    (%edx),%al
  8008f6:	74 ef                	je     8008e7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008f8:	0f b6 c0             	movzbl %al,%eax
  8008fb:	0f b6 12             	movzbl (%edx),%edx
  8008fe:	29 d0                	sub    %edx,%eax
}
  800900:	5d                   	pop    %ebp
  800901:	c3                   	ret    

00800902 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	53                   	push   %ebx
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090c:	89 c3                	mov    %eax,%ebx
  80090e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800911:	eb 06                	jmp    800919 <strncmp+0x17>
		n--, p++, q++;
  800913:	83 c0 01             	add    $0x1,%eax
  800916:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800919:	39 d8                	cmp    %ebx,%eax
  80091b:	74 15                	je     800932 <strncmp+0x30>
  80091d:	0f b6 08             	movzbl (%eax),%ecx
  800920:	84 c9                	test   %cl,%cl
  800922:	74 04                	je     800928 <strncmp+0x26>
  800924:	3a 0a                	cmp    (%edx),%cl
  800926:	74 eb                	je     800913 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800928:	0f b6 00             	movzbl (%eax),%eax
  80092b:	0f b6 12             	movzbl (%edx),%edx
  80092e:	29 d0                	sub    %edx,%eax
  800930:	eb 05                	jmp    800937 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800932:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800937:	5b                   	pop    %ebx
  800938:	5d                   	pop    %ebp
  800939:	c3                   	ret    

0080093a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800944:	eb 07                	jmp    80094d <strchr+0x13>
		if (*s == c)
  800946:	38 ca                	cmp    %cl,%dl
  800948:	74 0f                	je     800959 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80094a:	83 c0 01             	add    $0x1,%eax
  80094d:	0f b6 10             	movzbl (%eax),%edx
  800950:	84 d2                	test   %dl,%dl
  800952:	75 f2                	jne    800946 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800954:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800965:	eb 07                	jmp    80096e <strfind+0x13>
		if (*s == c)
  800967:	38 ca                	cmp    %cl,%dl
  800969:	74 0a                	je     800975 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80096b:	83 c0 01             	add    $0x1,%eax
  80096e:	0f b6 10             	movzbl (%eax),%edx
  800971:	84 d2                	test   %dl,%dl
  800973:	75 f2                	jne    800967 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	57                   	push   %edi
  80097b:	56                   	push   %esi
  80097c:	53                   	push   %ebx
  80097d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800980:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800983:	85 c9                	test   %ecx,%ecx
  800985:	74 36                	je     8009bd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800987:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80098d:	75 28                	jne    8009b7 <memset+0x40>
  80098f:	f6 c1 03             	test   $0x3,%cl
  800992:	75 23                	jne    8009b7 <memset+0x40>
		c &= 0xFF;
  800994:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800998:	89 d3                	mov    %edx,%ebx
  80099a:	c1 e3 08             	shl    $0x8,%ebx
  80099d:	89 d6                	mov    %edx,%esi
  80099f:	c1 e6 18             	shl    $0x18,%esi
  8009a2:	89 d0                	mov    %edx,%eax
  8009a4:	c1 e0 10             	shl    $0x10,%eax
  8009a7:	09 f0                	or     %esi,%eax
  8009a9:	09 c2                	or     %eax,%edx
  8009ab:	89 d0                	mov    %edx,%eax
  8009ad:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009af:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009b2:	fc                   	cld    
  8009b3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009b5:	eb 06                	jmp    8009bd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	fc                   	cld    
  8009bb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009bd:	89 f8                	mov    %edi,%eax
  8009bf:	5b                   	pop    %ebx
  8009c0:	5e                   	pop    %esi
  8009c1:	5f                   	pop    %edi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	57                   	push   %edi
  8009c8:	56                   	push   %esi
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009d2:	39 c6                	cmp    %eax,%esi
  8009d4:	73 35                	jae    800a0b <memmove+0x47>
  8009d6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009d9:	39 d0                	cmp    %edx,%eax
  8009db:	73 2e                	jae    800a0b <memmove+0x47>
		s += n;
		d += n;
  8009dd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8009e0:	89 d6                	mov    %edx,%esi
  8009e2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009ea:	75 13                	jne    8009ff <memmove+0x3b>
  8009ec:	f6 c1 03             	test   $0x3,%cl
  8009ef:	75 0e                	jne    8009ff <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009f1:	83 ef 04             	sub    $0x4,%edi
  8009f4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009f7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009fa:	fd                   	std    
  8009fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009fd:	eb 09                	jmp    800a08 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009ff:	83 ef 01             	sub    $0x1,%edi
  800a02:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a05:	fd                   	std    
  800a06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a08:	fc                   	cld    
  800a09:	eb 1d                	jmp    800a28 <memmove+0x64>
  800a0b:	89 f2                	mov    %esi,%edx
  800a0d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0f:	f6 c2 03             	test   $0x3,%dl
  800a12:	75 0f                	jne    800a23 <memmove+0x5f>
  800a14:	f6 c1 03             	test   $0x3,%cl
  800a17:	75 0a                	jne    800a23 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a19:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a1c:	89 c7                	mov    %eax,%edi
  800a1e:	fc                   	cld    
  800a1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a21:	eb 05                	jmp    800a28 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a23:	89 c7                	mov    %eax,%edi
  800a25:	fc                   	cld    
  800a26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a28:	5e                   	pop    %esi
  800a29:	5f                   	pop    %edi
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a32:	8b 45 10             	mov    0x10(%ebp),%eax
  800a35:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	89 04 24             	mov    %eax,(%esp)
  800a46:	e8 79 ff ff ff       	call   8009c4 <memmove>
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	56                   	push   %esi
  800a51:	53                   	push   %ebx
  800a52:	8b 55 08             	mov    0x8(%ebp),%edx
  800a55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a58:	89 d6                	mov    %edx,%esi
  800a5a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a5d:	eb 1a                	jmp    800a79 <memcmp+0x2c>
		if (*s1 != *s2)
  800a5f:	0f b6 02             	movzbl (%edx),%eax
  800a62:	0f b6 19             	movzbl (%ecx),%ebx
  800a65:	38 d8                	cmp    %bl,%al
  800a67:	74 0a                	je     800a73 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a69:	0f b6 c0             	movzbl %al,%eax
  800a6c:	0f b6 db             	movzbl %bl,%ebx
  800a6f:	29 d8                	sub    %ebx,%eax
  800a71:	eb 0f                	jmp    800a82 <memcmp+0x35>
		s1++, s2++;
  800a73:	83 c2 01             	add    $0x1,%edx
  800a76:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a79:	39 f2                	cmp    %esi,%edx
  800a7b:	75 e2                	jne    800a5f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a82:	5b                   	pop    %ebx
  800a83:	5e                   	pop    %esi
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a8f:	89 c2                	mov    %eax,%edx
  800a91:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a94:	eb 07                	jmp    800a9d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a96:	38 08                	cmp    %cl,(%eax)
  800a98:	74 07                	je     800aa1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a9a:	83 c0 01             	add    $0x1,%eax
  800a9d:	39 d0                	cmp    %edx,%eax
  800a9f:	72 f5                	jb     800a96 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800aa1:	5d                   	pop    %ebp
  800aa2:	c3                   	ret    

00800aa3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800aa3:	55                   	push   %ebp
  800aa4:	89 e5                	mov    %esp,%ebp
  800aa6:	57                   	push   %edi
  800aa7:	56                   	push   %esi
  800aa8:	53                   	push   %ebx
  800aa9:	8b 55 08             	mov    0x8(%ebp),%edx
  800aac:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aaf:	eb 03                	jmp    800ab4 <strtol+0x11>
		s++;
  800ab1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ab4:	0f b6 0a             	movzbl (%edx),%ecx
  800ab7:	80 f9 09             	cmp    $0x9,%cl
  800aba:	74 f5                	je     800ab1 <strtol+0xe>
  800abc:	80 f9 20             	cmp    $0x20,%cl
  800abf:	74 f0                	je     800ab1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ac1:	80 f9 2b             	cmp    $0x2b,%cl
  800ac4:	75 0a                	jne    800ad0 <strtol+0x2d>
		s++;
  800ac6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ac9:	bf 00 00 00 00       	mov    $0x0,%edi
  800ace:	eb 11                	jmp    800ae1 <strtol+0x3e>
  800ad0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ad5:	80 f9 2d             	cmp    $0x2d,%cl
  800ad8:	75 07                	jne    800ae1 <strtol+0x3e>
		s++, neg = 1;
  800ada:	8d 52 01             	lea    0x1(%edx),%edx
  800add:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ae6:	75 15                	jne    800afd <strtol+0x5a>
  800ae8:	80 3a 30             	cmpb   $0x30,(%edx)
  800aeb:	75 10                	jne    800afd <strtol+0x5a>
  800aed:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800af1:	75 0a                	jne    800afd <strtol+0x5a>
		s += 2, base = 16;
  800af3:	83 c2 02             	add    $0x2,%edx
  800af6:	b8 10 00 00 00       	mov    $0x10,%eax
  800afb:	eb 10                	jmp    800b0d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800afd:	85 c0                	test   %eax,%eax
  800aff:	75 0c                	jne    800b0d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b01:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b03:	80 3a 30             	cmpb   $0x30,(%edx)
  800b06:	75 05                	jne    800b0d <strtol+0x6a>
		s++, base = 8;
  800b08:	83 c2 01             	add    $0x1,%edx
  800b0b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b12:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b15:	0f b6 0a             	movzbl (%edx),%ecx
  800b18:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b1b:	89 f0                	mov    %esi,%eax
  800b1d:	3c 09                	cmp    $0x9,%al
  800b1f:	77 08                	ja     800b29 <strtol+0x86>
			dig = *s - '0';
  800b21:	0f be c9             	movsbl %cl,%ecx
  800b24:	83 e9 30             	sub    $0x30,%ecx
  800b27:	eb 20                	jmp    800b49 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b29:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b2c:	89 f0                	mov    %esi,%eax
  800b2e:	3c 19                	cmp    $0x19,%al
  800b30:	77 08                	ja     800b3a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b32:	0f be c9             	movsbl %cl,%ecx
  800b35:	83 e9 57             	sub    $0x57,%ecx
  800b38:	eb 0f                	jmp    800b49 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b3a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b3d:	89 f0                	mov    %esi,%eax
  800b3f:	3c 19                	cmp    $0x19,%al
  800b41:	77 16                	ja     800b59 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b43:	0f be c9             	movsbl %cl,%ecx
  800b46:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b49:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b4c:	7d 0f                	jge    800b5d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b4e:	83 c2 01             	add    $0x1,%edx
  800b51:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b55:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b57:	eb bc                	jmp    800b15 <strtol+0x72>
  800b59:	89 d8                	mov    %ebx,%eax
  800b5b:	eb 02                	jmp    800b5f <strtol+0xbc>
  800b5d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b63:	74 05                	je     800b6a <strtol+0xc7>
		*endptr = (char *) s;
  800b65:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b68:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b6a:	f7 d8                	neg    %eax
  800b6c:	85 ff                	test   %edi,%edi
  800b6e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b71:	5b                   	pop    %ebx
  800b72:	5e                   	pop    %esi
  800b73:	5f                   	pop    %edi
  800b74:	5d                   	pop    %ebp
  800b75:	c3                   	ret    

00800b76 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b76:	55                   	push   %ebp
  800b77:	89 e5                	mov    %esp,%ebp
  800b79:	57                   	push   %edi
  800b7a:	56                   	push   %esi
  800b7b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b84:	8b 55 08             	mov    0x8(%ebp),%edx
  800b87:	89 c3                	mov    %eax,%ebx
  800b89:	89 c7                	mov    %eax,%edi
  800b8b:	89 c6                	mov    %eax,%esi
  800b8d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b8f:	5b                   	pop    %ebx
  800b90:	5e                   	pop    %esi
  800b91:	5f                   	pop    %edi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <sys_cgetc>:

int
sys_cgetc(void)
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
  800b9f:	b8 01 00 00 00       	mov    $0x1,%eax
  800ba4:	89 d1                	mov    %edx,%ecx
  800ba6:	89 d3                	mov    %edx,%ebx
  800ba8:	89 d7                	mov    %edx,%edi
  800baa:	89 d6                	mov    %edx,%esi
  800bac:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bae:	5b                   	pop    %ebx
  800baf:	5e                   	pop    %esi
  800bb0:	5f                   	pop    %edi
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800bbc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bc1:	b8 03 00 00 00       	mov    $0x3,%eax
  800bc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc9:	89 cb                	mov    %ecx,%ebx
  800bcb:	89 cf                	mov    %ecx,%edi
  800bcd:	89 ce                	mov    %ecx,%esi
  800bcf:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800bd1:	85 c0                	test   %eax,%eax
  800bd3:	7e 28                	jle    800bfd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bd9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800be0:	00 
  800be1:	c7 44 24 08 e7 2e 80 	movl   $0x802ee7,0x8(%esp)
  800be8:	00 
  800be9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bf0:	00 
  800bf1:	c7 04 24 04 2f 80 00 	movl   $0x802f04,(%esp)
  800bf8:	e8 a9 1a 00 00       	call   8026a6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bfd:	83 c4 2c             	add    $0x2c,%esp
  800c00:	5b                   	pop    %ebx
  800c01:	5e                   	pop    %esi
  800c02:	5f                   	pop    %edi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	57                   	push   %edi
  800c09:	56                   	push   %esi
  800c0a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c10:	b8 02 00 00 00       	mov    $0x2,%eax
  800c15:	89 d1                	mov    %edx,%ecx
  800c17:	89 d3                	mov    %edx,%ebx
  800c19:	89 d7                	mov    %edx,%edi
  800c1b:	89 d6                	mov    %edx,%esi
  800c1d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c1f:	5b                   	pop    %ebx
  800c20:	5e                   	pop    %esi
  800c21:	5f                   	pop    %edi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <sys_yield>:

void
sys_yield(void)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	57                   	push   %edi
  800c28:	56                   	push   %esi
  800c29:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c34:	89 d1                	mov    %edx,%ecx
  800c36:	89 d3                	mov    %edx,%ebx
  800c38:	89 d7                	mov    %edx,%edi
  800c3a:	89 d6                	mov    %edx,%esi
  800c3c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c3e:	5b                   	pop    %ebx
  800c3f:	5e                   	pop    %esi
  800c40:	5f                   	pop    %edi
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	57                   	push   %edi
  800c47:	56                   	push   %esi
  800c48:	53                   	push   %ebx
  800c49:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4c:	be 00 00 00 00       	mov    $0x0,%esi
  800c51:	b8 04 00 00 00       	mov    $0x4,%eax
  800c56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c59:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c5f:	89 f7                	mov    %esi,%edi
  800c61:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c63:	85 c0                	test   %eax,%eax
  800c65:	7e 28                	jle    800c8f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c67:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c6b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c72:	00 
  800c73:	c7 44 24 08 e7 2e 80 	movl   $0x802ee7,0x8(%esp)
  800c7a:	00 
  800c7b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c82:	00 
  800c83:	c7 04 24 04 2f 80 00 	movl   $0x802f04,(%esp)
  800c8a:	e8 17 1a 00 00       	call   8026a6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c8f:	83 c4 2c             	add    $0x2c,%esp
  800c92:	5b                   	pop    %ebx
  800c93:	5e                   	pop    %esi
  800c94:	5f                   	pop    %edi
  800c95:	5d                   	pop    %ebp
  800c96:	c3                   	ret    

00800c97 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	57                   	push   %edi
  800c9b:	56                   	push   %esi
  800c9c:	53                   	push   %ebx
  800c9d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca0:	b8 05 00 00 00       	mov    $0x5,%eax
  800ca5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cae:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cb1:	8b 75 18             	mov    0x18(%ebp),%esi
  800cb4:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cb6:	85 c0                	test   %eax,%eax
  800cb8:	7e 28                	jle    800ce2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cba:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cbe:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800cc5:	00 
  800cc6:	c7 44 24 08 e7 2e 80 	movl   $0x802ee7,0x8(%esp)
  800ccd:	00 
  800cce:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cd5:	00 
  800cd6:	c7 04 24 04 2f 80 00 	movl   $0x802f04,(%esp)
  800cdd:	e8 c4 19 00 00       	call   8026a6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ce2:	83 c4 2c             	add    $0x2c,%esp
  800ce5:	5b                   	pop    %ebx
  800ce6:	5e                   	pop    %esi
  800ce7:	5f                   	pop    %edi
  800ce8:	5d                   	pop    %ebp
  800ce9:	c3                   	ret    

00800cea <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cea:	55                   	push   %ebp
  800ceb:	89 e5                	mov    %esp,%ebp
  800ced:	57                   	push   %edi
  800cee:	56                   	push   %esi
  800cef:	53                   	push   %ebx
  800cf0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf8:	b8 06 00 00 00       	mov    $0x6,%eax
  800cfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d00:	8b 55 08             	mov    0x8(%ebp),%edx
  800d03:	89 df                	mov    %ebx,%edi
  800d05:	89 de                	mov    %ebx,%esi
  800d07:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d09:	85 c0                	test   %eax,%eax
  800d0b:	7e 28                	jle    800d35 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d11:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d18:	00 
  800d19:	c7 44 24 08 e7 2e 80 	movl   $0x802ee7,0x8(%esp)
  800d20:	00 
  800d21:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d28:	00 
  800d29:	c7 04 24 04 2f 80 00 	movl   $0x802f04,(%esp)
  800d30:	e8 71 19 00 00       	call   8026a6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d35:	83 c4 2c             	add    $0x2c,%esp
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	57                   	push   %edi
  800d41:	56                   	push   %esi
  800d42:	53                   	push   %ebx
  800d43:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d46:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	89 df                	mov    %ebx,%edi
  800d58:	89 de                	mov    %ebx,%esi
  800d5a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d5c:	85 c0                	test   %eax,%eax
  800d5e:	7e 28                	jle    800d88 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d60:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d64:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d6b:	00 
  800d6c:	c7 44 24 08 e7 2e 80 	movl   $0x802ee7,0x8(%esp)
  800d73:	00 
  800d74:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d7b:	00 
  800d7c:	c7 04 24 04 2f 80 00 	movl   $0x802f04,(%esp)
  800d83:	e8 1e 19 00 00       	call   8026a6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d88:	83 c4 2c             	add    $0x2c,%esp
  800d8b:	5b                   	pop    %ebx
  800d8c:	5e                   	pop    %esi
  800d8d:	5f                   	pop    %edi
  800d8e:	5d                   	pop    %ebp
  800d8f:	c3                   	ret    

00800d90 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	57                   	push   %edi
  800d94:	56                   	push   %esi
  800d95:	53                   	push   %ebx
  800d96:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d99:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9e:	b8 09 00 00 00       	mov    $0x9,%eax
  800da3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da6:	8b 55 08             	mov    0x8(%ebp),%edx
  800da9:	89 df                	mov    %ebx,%edi
  800dab:	89 de                	mov    %ebx,%esi
  800dad:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800daf:	85 c0                	test   %eax,%eax
  800db1:	7e 28                	jle    800ddb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dbe:	00 
  800dbf:	c7 44 24 08 e7 2e 80 	movl   $0x802ee7,0x8(%esp)
  800dc6:	00 
  800dc7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dce:	00 
  800dcf:	c7 04 24 04 2f 80 00 	movl   $0x802f04,(%esp)
  800dd6:	e8 cb 18 00 00       	call   8026a6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ddb:	83 c4 2c             	add    $0x2c,%esp
  800dde:	5b                   	pop    %ebx
  800ddf:	5e                   	pop    %esi
  800de0:	5f                   	pop    %edi
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
  800de9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dec:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800df6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfc:	89 df                	mov    %ebx,%edi
  800dfe:	89 de                	mov    %ebx,%esi
  800e00:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e02:	85 c0                	test   %eax,%eax
  800e04:	7e 28                	jle    800e2e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e06:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e11:	00 
  800e12:	c7 44 24 08 e7 2e 80 	movl   $0x802ee7,0x8(%esp)
  800e19:	00 
  800e1a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e21:	00 
  800e22:	c7 04 24 04 2f 80 00 	movl   $0x802f04,(%esp)
  800e29:	e8 78 18 00 00       	call   8026a6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e2e:	83 c4 2c             	add    $0x2c,%esp
  800e31:	5b                   	pop    %ebx
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3c:	be 00 00 00 00       	mov    $0x0,%esi
  800e41:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e52:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    

00800e59 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	57                   	push   %edi
  800e5d:	56                   	push   %esi
  800e5e:	53                   	push   %ebx
  800e5f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e67:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6f:	89 cb                	mov    %ecx,%ebx
  800e71:	89 cf                	mov    %ecx,%edi
  800e73:	89 ce                	mov    %ecx,%esi
  800e75:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e77:	85 c0                	test   %eax,%eax
  800e79:	7e 28                	jle    800ea3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e7f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e86:	00 
  800e87:	c7 44 24 08 e7 2e 80 	movl   $0x802ee7,0x8(%esp)
  800e8e:	00 
  800e8f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e96:	00 
  800e97:	c7 04 24 04 2f 80 00 	movl   $0x802f04,(%esp)
  800e9e:	e8 03 18 00 00       	call   8026a6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ea3:	83 c4 2c             	add    $0x2c,%esp
  800ea6:	5b                   	pop    %ebx
  800ea7:	5e                   	pop    %esi
  800ea8:	5f                   	pop    %edi
  800ea9:	5d                   	pop    %ebp
  800eaa:	c3                   	ret    

00800eab <sys_time_msec>:

unsigned int
sys_time_msec(void)
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
  800eb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ebb:	89 d1                	mov    %edx,%ecx
  800ebd:	89 d3                	mov    %edx,%ebx
  800ebf:	89 d7                	mov    %edx,%edi
  800ec1:	89 d6                	mov    %edx,%esi
  800ec3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5f                   	pop    %edi
  800ec8:	5d                   	pop    %ebp
  800ec9:	c3                   	ret    

00800eca <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	57                   	push   %edi
  800ece:	56                   	push   %esi
  800ecf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed5:	b8 0f 00 00 00       	mov    $0xf,%eax
  800eda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	89 df                	mov    %ebx,%edi
  800ee2:	89 de                	mov    %ebx,%esi
  800ee4:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5f                   	pop    %edi
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    

00800eeb <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	57                   	push   %edi
  800eef:	56                   	push   %esi
  800ef0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef6:	b8 10 00 00 00       	mov    $0x10,%eax
  800efb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efe:	8b 55 08             	mov    0x8(%ebp),%edx
  800f01:	89 df                	mov    %ebx,%edi
  800f03:	89 de                	mov    %ebx,%esi
  800f05:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800f07:	5b                   	pop    %ebx
  800f08:	5e                   	pop    %esi
  800f09:	5f                   	pop    %edi
  800f0a:	5d                   	pop    %ebp
  800f0b:	c3                   	ret    

00800f0c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	57                   	push   %edi
  800f10:	56                   	push   %esi
  800f11:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f12:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f17:	b8 11 00 00 00       	mov    $0x11,%eax
  800f1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1f:	89 cb                	mov    %ecx,%ebx
  800f21:	89 cf                	mov    %ecx,%edi
  800f23:	89 ce                	mov    %ecx,%esi
  800f25:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800f27:	5b                   	pop    %ebx
  800f28:	5e                   	pop    %esi
  800f29:	5f                   	pop    %edi
  800f2a:	5d                   	pop    %ebp
  800f2b:	c3                   	ret    

00800f2c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	57                   	push   %edi
  800f30:	56                   	push   %esi
  800f31:	53                   	push   %ebx
  800f32:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f35:	be 00 00 00 00       	mov    $0x0,%esi
  800f3a:	b8 12 00 00 00       	mov    $0x12,%eax
  800f3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f42:	8b 55 08             	mov    0x8(%ebp),%edx
  800f45:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f48:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f4b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f4d:	85 c0                	test   %eax,%eax
  800f4f:	7e 28                	jle    800f79 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f51:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f55:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800f5c:	00 
  800f5d:	c7 44 24 08 e7 2e 80 	movl   $0x802ee7,0x8(%esp)
  800f64:	00 
  800f65:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f6c:	00 
  800f6d:	c7 04 24 04 2f 80 00 	movl   $0x802f04,(%esp)
  800f74:	e8 2d 17 00 00       	call   8026a6 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  800f79:	83 c4 2c             	add    $0x2c,%esp
  800f7c:	5b                   	pop    %ebx
  800f7d:	5e                   	pop    %esi
  800f7e:	5f                   	pop    %edi
  800f7f:	5d                   	pop    %ebp
  800f80:	c3                   	ret    

00800f81 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	53                   	push   %ebx
  800f85:	83 ec 24             	sub    $0x24,%esp
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f8b:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0)
  800f8d:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f91:	75 20                	jne    800fb3 <pgfault+0x32>
		panic("pgfault: faulting address [%08x] not a write\n", addr);
  800f93:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800f97:	c7 44 24 08 14 2f 80 	movl   $0x802f14,0x8(%esp)
  800f9e:	00 
  800f9f:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  800fa6:	00 
  800fa7:	c7 04 24 94 2f 80 00 	movl   $0x802f94,(%esp)
  800fae:	e8 f3 16 00 00       	call   8026a6 <_panic>

	void *page_aligned_addr = (void *) ROUNDDOWN(addr, PGSIZE);
  800fb3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t page_num = (uint32_t) page_aligned_addr / PGSIZE;
  800fb9:	89 d8                	mov    %ebx,%eax
  800fbb:	c1 e8 0c             	shr    $0xc,%eax
	if (!(uvpt[page_num] & PTE_COW))
  800fbe:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fc5:	f6 c4 08             	test   $0x8,%ah
  800fc8:	75 1c                	jne    800fe6 <pgfault+0x65>
		panic("pgfault: fault was not on a copy-on-write page\n");
  800fca:	c7 44 24 08 44 2f 80 	movl   $0x802f44,0x8(%esp)
  800fd1:	00 
  800fd2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd9:	00 
  800fda:	c7 04 24 94 2f 80 00 	movl   $0x802f94,(%esp)
  800fe1:	e8 c0 16 00 00       	call   8026a6 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	// Allocate
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  800fe6:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800fed:	00 
  800fee:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  800ff5:	00 
  800ff6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ffd:	e8 41 fc ff ff       	call   800c43 <sys_page_alloc>
  801002:	85 c0                	test   %eax,%eax
  801004:	79 20                	jns    801026 <pgfault+0xa5>
		panic("sys_page_alloc: %e\n", r);
  801006:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80100a:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  801011:	00 
  801012:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  801019:	00 
  80101a:	c7 04 24 94 2f 80 00 	movl   $0x802f94,(%esp)
  801021:	e8 80 16 00 00       	call   8026a6 <_panic>

	// Copy over
	void *src_addr = (void *) ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, src_addr, PGSIZE);
  801026:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80102d:	00 
  80102e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801032:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801039:	e8 86 f9 ff ff       	call   8009c4 <memmove>

	// Remap
	if ((r = sys_page_map(0, PFTEMP, 0, src_addr, PTE_P | PTE_U | PTE_W)) < 0)
  80103e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801045:	00 
  801046:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80104a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801051:	00 
  801052:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801059:	00 
  80105a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801061:	e8 31 fc ff ff       	call   800c97 <sys_page_map>
  801066:	85 c0                	test   %eax,%eax
  801068:	79 20                	jns    80108a <pgfault+0x109>
		panic("sys_page_map: %e\n", r);
  80106a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80106e:	c7 44 24 08 b3 2f 80 	movl   $0x802fb3,0x8(%esp)
  801075:	00 
  801076:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  80107d:	00 
  80107e:	c7 04 24 94 2f 80 00 	movl   $0x802f94,(%esp)
  801085:	e8 1c 16 00 00       	call   8026a6 <_panic>

	//panic("pgfault not implemented");
}
  80108a:	83 c4 24             	add    $0x24,%esp
  80108d:	5b                   	pop    %ebx
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	57                   	push   %edi
  801094:	56                   	push   %esi
  801095:	53                   	push   %ebx
  801096:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	int r;
	envid_t child_envid;

	set_pgfault_handler(pgfault);
  801099:	c7 04 24 81 0f 80 00 	movl   $0x800f81,(%esp)
  8010a0:	e8 57 16 00 00       	call   8026fc <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010a5:	b8 07 00 00 00       	mov    $0x7,%eax
  8010aa:	cd 30                	int    $0x30
  8010ac:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8010af:	89 45 e0             	mov    %eax,-0x20(%ebp)

	child_envid = sys_exofork();
	if (child_envid < 0)
  8010b2:	85 c0                	test   %eax,%eax
  8010b4:	79 20                	jns    8010d6 <fork+0x46>
		panic("sys_exofork: %e\n", child_envid);
  8010b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010ba:	c7 44 24 08 c5 2f 80 	movl   $0x802fc5,0x8(%esp)
  8010c1:	00 
  8010c2:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  8010c9:	00 
  8010ca:	c7 04 24 94 2f 80 00 	movl   $0x802f94,(%esp)
  8010d1:	e8 d0 15 00 00       	call   8026a6 <_panic>
	if (child_envid == 0) { // child
  8010d6:	bf 00 00 00 00       	mov    $0x0,%edi
  8010db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010e0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010e4:	75 21                	jne    801107 <fork+0x77>
		// Fix thisenv like dumbfork does and return 0
		thisenv = &envs[ENVX(sys_getenvid())];
  8010e6:	e8 1a fb ff ff       	call   800c05 <sys_getenvid>
  8010eb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010f0:	c1 e0 07             	shl    $0x7,%eax
  8010f3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010f8:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8010fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801102:	e9 53 02 00 00       	jmp    80135a <fork+0x2ca>
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
  801107:	89 d8                	mov    %ebx,%eax
  801109:	c1 e8 0a             	shr    $0xa,%eax
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  80110c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801113:	a8 01                	test   $0x1,%al
  801115:	0f 84 7a 01 00 00    	je     801295 <fork+0x205>
			((uvpt[page_num] & PTE_P) == PTE_P)) {
  80111b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  801122:	a8 01                	test   $0x1,%al
  801124:	0f 84 6b 01 00 00    	je     801295 <fork+0x205>
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
	envid_t this_envid = thisenv->env_id;
  80112a:	a1 08 50 80 00       	mov    0x805008,%eax
  80112f:	8b 40 48             	mov    0x48(%eax),%eax
  801132:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 4: Your code here.
	if (uvpt[pn] & PTE_SHARE) {
  801135:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80113c:	f6 c4 04             	test   $0x4,%ah
  80113f:	74 52                	je     801193 <fork+0x103>
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801141:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801148:	25 07 0e 00 00       	and    $0xe07,%eax
  80114d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801151:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801155:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801158:	89 44 24 08          	mov    %eax,0x8(%esp)
  80115c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801160:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801163:	89 04 24             	mov    %eax,(%esp)
  801166:	e8 2c fb ff ff       	call   800c97 <sys_page_map>
  80116b:	85 c0                	test   %eax,%eax
  80116d:	0f 89 22 01 00 00    	jns    801295 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801173:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801177:	c7 44 24 08 b3 2f 80 	movl   $0x802fb3,0x8(%esp)
  80117e:	00 
  80117f:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  801186:	00 
  801187:	c7 04 24 94 2f 80 00 	movl   $0x802f94,(%esp)
  80118e:	e8 13 15 00 00       	call   8026a6 <_panic>
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
  801193:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80119a:	f6 c4 08             	test   $0x8,%ah
  80119d:	75 0f                	jne    8011ae <fork+0x11e>
  80119f:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011a6:	a8 02                	test   $0x2,%al
  8011a8:	0f 84 99 00 00 00    	je     801247 <fork+0x1b7>
		if (uvpt[pn] & PTE_U)
  8011ae:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011b5:	83 e0 04             	and    $0x4,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
  8011b8:	83 f8 01             	cmp    $0x1,%eax
  8011bb:	19 f6                	sbb    %esi,%esi
  8011bd:	83 e6 fc             	and    $0xfffffffc,%esi
  8011c0:	81 c6 05 08 00 00    	add    $0x805,%esi
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
		if (uvpt[pn] & PTE_U)
			perm |= PTE_U;

		// Map page COW, U and P in child
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), perm)) < 0)
  8011c6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8011ca:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011dc:	89 04 24             	mov    %eax,(%esp)
  8011df:	e8 b3 fa ff ff       	call   800c97 <sys_page_map>
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	79 20                	jns    801208 <fork+0x178>
			panic("sys_page_map: %e\n", r);
  8011e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011ec:	c7 44 24 08 b3 2f 80 	movl   $0x802fb3,0x8(%esp)
  8011f3:	00 
  8011f4:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  8011fb:	00 
  8011fc:	c7 04 24 94 2f 80 00 	movl   $0x802f94,(%esp)
  801203:	e8 9e 14 00 00       	call   8026a6 <_panic>

		// Map page COW, U and P in parent
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), this_envid, (void *) (pn*PGSIZE), perm)) < 0)
  801208:	89 74 24 10          	mov    %esi,0x10(%esp)
  80120c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801210:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801213:	89 44 24 08          	mov    %eax,0x8(%esp)
  801217:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80121b:	89 04 24             	mov    %eax,(%esp)
  80121e:	e8 74 fa ff ff       	call   800c97 <sys_page_map>
  801223:	85 c0                	test   %eax,%eax
  801225:	79 6e                	jns    801295 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801227:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80122b:	c7 44 24 08 b3 2f 80 	movl   $0x802fb3,0x8(%esp)
  801232:	00 
  801233:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  80123a:	00 
  80123b:	c7 04 24 94 2f 80 00 	movl   $0x802f94,(%esp)
  801242:	e8 5f 14 00 00       	call   8026a6 <_panic>

	} else { // map pages that are present but not writable or COW with their original permissions
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801247:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80124e:	25 07 0e 00 00       	and    $0xe07,%eax
  801253:	89 44 24 10          	mov    %eax,0x10(%esp)
  801257:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80125b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80125e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801262:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801266:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801269:	89 04 24             	mov    %eax,(%esp)
  80126c:	e8 26 fa ff ff       	call   800c97 <sys_page_map>
  801271:	85 c0                	test   %eax,%eax
  801273:	79 20                	jns    801295 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801275:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801279:	c7 44 24 08 b3 2f 80 	movl   $0x802fb3,0x8(%esp)
  801280:	00 
  801281:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  801288:	00 
  801289:	c7 04 24 94 2f 80 00 	movl   $0x802f94,(%esp)
  801290:	e8 11 14 00 00       	call   8026a6 <_panic>
	// and let duppage worry about the permissions.
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
  801295:	83 c3 01             	add    $0x1,%ebx
  801298:	81 c7 00 10 00 00    	add    $0x1000,%edi
  80129e:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  8012a4:	0f 85 5d fe ff ff    	jne    801107 <fork+0x77>
	}

	// Allocate exception stack space for child. The child can't do this themselves
	// because the mechanism by which it would is to run the pgfault handler, which
	// needs to run on the exception stack (catch 22).
	if ((r = sys_page_alloc(child_envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8012aa:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012b1:	00 
  8012b2:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8012b9:	ee 
  8012ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012bd:	89 04 24             	mov    %eax,(%esp)
  8012c0:	e8 7e f9 ff ff       	call   800c43 <sys_page_alloc>
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	79 20                	jns    8012e9 <fork+0x259>
		panic("sys_page_alloc: %e\n", r);
  8012c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012cd:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  8012d4:	00 
  8012d5:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  8012dc:	00 
  8012dd:	c7 04 24 94 2f 80 00 	movl   $0x802f94,(%esp)
  8012e4:	e8 bd 13 00 00       	call   8026a6 <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  8012e9:	c7 44 24 04 7d 27 80 	movl   $0x80277d,0x4(%esp)
  8012f0:	00 
  8012f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012f4:	89 04 24             	mov    %eax,(%esp)
  8012f7:	e8 e7 fa ff ff       	call   800de3 <sys_env_set_pgfault_upcall>
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	79 20                	jns    801320 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801300:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801304:	c7 44 24 08 74 2f 80 	movl   $0x802f74,0x8(%esp)
  80130b:	00 
  80130c:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801313:	00 
  801314:	c7 04 24 94 2f 80 00 	movl   $0x802f94,(%esp)
  80131b:	e8 86 13 00 00       	call   8026a6 <_panic>

	// Mark child environment as runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801320:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801327:	00 
  801328:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80132b:	89 04 24             	mov    %eax,(%esp)
  80132e:	e8 0a fa ff ff       	call   800d3d <sys_env_set_status>
  801333:	85 c0                	test   %eax,%eax
  801335:	79 20                	jns    801357 <fork+0x2c7>
		panic("sys_env_set_status: %e\n", r);
  801337:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80133b:	c7 44 24 08 d6 2f 80 	movl   $0x802fd6,0x8(%esp)
  801342:	00 
  801343:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80134a:	00 
  80134b:	c7 04 24 94 2f 80 00 	movl   $0x802f94,(%esp)
  801352:	e8 4f 13 00 00       	call   8026a6 <_panic>

	return child_envid;
  801357:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  80135a:	83 c4 2c             	add    $0x2c,%esp
  80135d:	5b                   	pop    %ebx
  80135e:	5e                   	pop    %esi
  80135f:	5f                   	pop    %edi
  801360:	5d                   	pop    %ebp
  801361:	c3                   	ret    

00801362 <sfork>:

// Challenge!
int
sfork(void)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	83 ec 18             	sub    $0x18,%esp
//	return __fork(1);
	panic("sfork not implemented");
  801368:	c7 44 24 08 ee 2f 80 	movl   $0x802fee,0x8(%esp)
  80136f:	00 
  801370:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  801377:	00 
  801378:	c7 04 24 94 2f 80 00 	movl   $0x802f94,(%esp)
  80137f:	e8 22 13 00 00       	call   8026a6 <_panic>
  801384:	66 90                	xchg   %ax,%ax
  801386:	66 90                	xchg   %ax,%ax
  801388:	66 90                	xchg   %ax,%ax
  80138a:	66 90                	xchg   %ax,%ax
  80138c:	66 90                	xchg   %ax,%ax
  80138e:	66 90                	xchg   %ax,%ax

00801390 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	05 00 00 00 30       	add    $0x30000000,%eax
  80139b:	c1 e8 0c             	shr    $0xc,%eax
}
  80139e:	5d                   	pop    %ebp
  80139f:	c3                   	ret    

008013a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8013ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013b5:	5d                   	pop    %ebp
  8013b6:	c3                   	ret    

008013b7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013bd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013c2:	89 c2                	mov    %eax,%edx
  8013c4:	c1 ea 16             	shr    $0x16,%edx
  8013c7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013ce:	f6 c2 01             	test   $0x1,%dl
  8013d1:	74 11                	je     8013e4 <fd_alloc+0x2d>
  8013d3:	89 c2                	mov    %eax,%edx
  8013d5:	c1 ea 0c             	shr    $0xc,%edx
  8013d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013df:	f6 c2 01             	test   $0x1,%dl
  8013e2:	75 09                	jne    8013ed <fd_alloc+0x36>
			*fd_store = fd;
  8013e4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013eb:	eb 17                	jmp    801404 <fd_alloc+0x4d>
  8013ed:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013f2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013f7:	75 c9                	jne    8013c2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013f9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8013ff:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801404:	5d                   	pop    %ebp
  801405:	c3                   	ret    

00801406 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80140c:	83 f8 1f             	cmp    $0x1f,%eax
  80140f:	77 36                	ja     801447 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801411:	c1 e0 0c             	shl    $0xc,%eax
  801414:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801419:	89 c2                	mov    %eax,%edx
  80141b:	c1 ea 16             	shr    $0x16,%edx
  80141e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801425:	f6 c2 01             	test   $0x1,%dl
  801428:	74 24                	je     80144e <fd_lookup+0x48>
  80142a:	89 c2                	mov    %eax,%edx
  80142c:	c1 ea 0c             	shr    $0xc,%edx
  80142f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801436:	f6 c2 01             	test   $0x1,%dl
  801439:	74 1a                	je     801455 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80143b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143e:	89 02                	mov    %eax,(%edx)
	return 0;
  801440:	b8 00 00 00 00       	mov    $0x0,%eax
  801445:	eb 13                	jmp    80145a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801447:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80144c:	eb 0c                	jmp    80145a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80144e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801453:	eb 05                	jmp    80145a <fd_lookup+0x54>
  801455:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80145a:	5d                   	pop    %ebp
  80145b:	c3                   	ret    

0080145c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 18             	sub    $0x18,%esp
  801462:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801465:	ba 00 00 00 00       	mov    $0x0,%edx
  80146a:	eb 13                	jmp    80147f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80146c:	39 08                	cmp    %ecx,(%eax)
  80146e:	75 0c                	jne    80147c <dev_lookup+0x20>
			*dev = devtab[i];
  801470:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801473:	89 01                	mov    %eax,(%ecx)
			return 0;
  801475:	b8 00 00 00 00       	mov    $0x0,%eax
  80147a:	eb 38                	jmp    8014b4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80147c:	83 c2 01             	add    $0x1,%edx
  80147f:	8b 04 95 80 30 80 00 	mov    0x803080(,%edx,4),%eax
  801486:	85 c0                	test   %eax,%eax
  801488:	75 e2                	jne    80146c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80148a:	a1 08 50 80 00       	mov    0x805008,%eax
  80148f:	8b 40 48             	mov    0x48(%eax),%eax
  801492:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801496:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149a:	c7 04 24 04 30 80 00 	movl   $0x803004,(%esp)
  8014a1:	e8 51 ed ff ff       	call   8001f7 <cprintf>
	*dev = 0;
  8014a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
  8014b9:	56                   	push   %esi
  8014ba:	53                   	push   %ebx
  8014bb:	83 ec 20             	sub    $0x20,%esp
  8014be:	8b 75 08             	mov    0x8(%ebp),%esi
  8014c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014cb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014d1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014d4:	89 04 24             	mov    %eax,(%esp)
  8014d7:	e8 2a ff ff ff       	call   801406 <fd_lookup>
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 05                	js     8014e5 <fd_close+0x2f>
	    || fd != fd2)
  8014e0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014e3:	74 0c                	je     8014f1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8014e5:	84 db                	test   %bl,%bl
  8014e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ec:	0f 44 c2             	cmove  %edx,%eax
  8014ef:	eb 3f                	jmp    801530 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f8:	8b 06                	mov    (%esi),%eax
  8014fa:	89 04 24             	mov    %eax,(%esp)
  8014fd:	e8 5a ff ff ff       	call   80145c <dev_lookup>
  801502:	89 c3                	mov    %eax,%ebx
  801504:	85 c0                	test   %eax,%eax
  801506:	78 16                	js     80151e <fd_close+0x68>
		if (dev->dev_close)
  801508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80150e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801513:	85 c0                	test   %eax,%eax
  801515:	74 07                	je     80151e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801517:	89 34 24             	mov    %esi,(%esp)
  80151a:	ff d0                	call   *%eax
  80151c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80151e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801522:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801529:	e8 bc f7 ff ff       	call   800cea <sys_page_unmap>
	return r;
  80152e:	89 d8                	mov    %ebx,%eax
}
  801530:	83 c4 20             	add    $0x20,%esp
  801533:	5b                   	pop    %ebx
  801534:	5e                   	pop    %esi
  801535:	5d                   	pop    %ebp
  801536:	c3                   	ret    

00801537 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80153d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801540:	89 44 24 04          	mov    %eax,0x4(%esp)
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	89 04 24             	mov    %eax,(%esp)
  80154a:	e8 b7 fe ff ff       	call   801406 <fd_lookup>
  80154f:	89 c2                	mov    %eax,%edx
  801551:	85 d2                	test   %edx,%edx
  801553:	78 13                	js     801568 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801555:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80155c:	00 
  80155d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801560:	89 04 24             	mov    %eax,(%esp)
  801563:	e8 4e ff ff ff       	call   8014b6 <fd_close>
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <close_all>:

void
close_all(void)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	53                   	push   %ebx
  80156e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801571:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801576:	89 1c 24             	mov    %ebx,(%esp)
  801579:	e8 b9 ff ff ff       	call   801537 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80157e:	83 c3 01             	add    $0x1,%ebx
  801581:	83 fb 20             	cmp    $0x20,%ebx
  801584:	75 f0                	jne    801576 <close_all+0xc>
		close(i);
}
  801586:	83 c4 14             	add    $0x14,%esp
  801589:	5b                   	pop    %ebx
  80158a:	5d                   	pop    %ebp
  80158b:	c3                   	ret    

0080158c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	57                   	push   %edi
  801590:	56                   	push   %esi
  801591:	53                   	push   %ebx
  801592:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801595:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801598:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	89 04 24             	mov    %eax,(%esp)
  8015a2:	e8 5f fe ff ff       	call   801406 <fd_lookup>
  8015a7:	89 c2                	mov    %eax,%edx
  8015a9:	85 d2                	test   %edx,%edx
  8015ab:	0f 88 e1 00 00 00    	js     801692 <dup+0x106>
		return r;
	close(newfdnum);
  8015b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b4:	89 04 24             	mov    %eax,(%esp)
  8015b7:	e8 7b ff ff ff       	call   801537 <close>

	newfd = INDEX2FD(newfdnum);
  8015bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8015bf:	c1 e3 0c             	shl    $0xc,%ebx
  8015c2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8015c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015cb:	89 04 24             	mov    %eax,(%esp)
  8015ce:	e8 cd fd ff ff       	call   8013a0 <fd2data>
  8015d3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8015d5:	89 1c 24             	mov    %ebx,(%esp)
  8015d8:	e8 c3 fd ff ff       	call   8013a0 <fd2data>
  8015dd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015df:	89 f0                	mov    %esi,%eax
  8015e1:	c1 e8 16             	shr    $0x16,%eax
  8015e4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015eb:	a8 01                	test   $0x1,%al
  8015ed:	74 43                	je     801632 <dup+0xa6>
  8015ef:	89 f0                	mov    %esi,%eax
  8015f1:	c1 e8 0c             	shr    $0xc,%eax
  8015f4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015fb:	f6 c2 01             	test   $0x1,%dl
  8015fe:	74 32                	je     801632 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801600:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801607:	25 07 0e 00 00       	and    $0xe07,%eax
  80160c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801610:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801614:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80161b:	00 
  80161c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801620:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801627:	e8 6b f6 ff ff       	call   800c97 <sys_page_map>
  80162c:	89 c6                	mov    %eax,%esi
  80162e:	85 c0                	test   %eax,%eax
  801630:	78 3e                	js     801670 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801635:	89 c2                	mov    %eax,%edx
  801637:	c1 ea 0c             	shr    $0xc,%edx
  80163a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801641:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801647:	89 54 24 10          	mov    %edx,0x10(%esp)
  80164b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80164f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801656:	00 
  801657:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801662:	e8 30 f6 ff ff       	call   800c97 <sys_page_map>
  801667:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801669:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80166c:	85 f6                	test   %esi,%esi
  80166e:	79 22                	jns    801692 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801670:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801674:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80167b:	e8 6a f6 ff ff       	call   800cea <sys_page_unmap>
	sys_page_unmap(0, nva);
  801680:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801684:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80168b:	e8 5a f6 ff ff       	call   800cea <sys_page_unmap>
	return r;
  801690:	89 f0                	mov    %esi,%eax
}
  801692:	83 c4 3c             	add    $0x3c,%esp
  801695:	5b                   	pop    %ebx
  801696:	5e                   	pop    %esi
  801697:	5f                   	pop    %edi
  801698:	5d                   	pop    %ebp
  801699:	c3                   	ret    

0080169a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	53                   	push   %ebx
  80169e:	83 ec 24             	sub    $0x24,%esp
  8016a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ab:	89 1c 24             	mov    %ebx,(%esp)
  8016ae:	e8 53 fd ff ff       	call   801406 <fd_lookup>
  8016b3:	89 c2                	mov    %eax,%edx
  8016b5:	85 d2                	test   %edx,%edx
  8016b7:	78 6d                	js     801726 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c3:	8b 00                	mov    (%eax),%eax
  8016c5:	89 04 24             	mov    %eax,(%esp)
  8016c8:	e8 8f fd ff ff       	call   80145c <dev_lookup>
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	78 55                	js     801726 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d4:	8b 50 08             	mov    0x8(%eax),%edx
  8016d7:	83 e2 03             	and    $0x3,%edx
  8016da:	83 fa 01             	cmp    $0x1,%edx
  8016dd:	75 23                	jne    801702 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016df:	a1 08 50 80 00       	mov    0x805008,%eax
  8016e4:	8b 40 48             	mov    0x48(%eax),%eax
  8016e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ef:	c7 04 24 45 30 80 00 	movl   $0x803045,(%esp)
  8016f6:	e8 fc ea ff ff       	call   8001f7 <cprintf>
		return -E_INVAL;
  8016fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801700:	eb 24                	jmp    801726 <read+0x8c>
	}
	if (!dev->dev_read)
  801702:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801705:	8b 52 08             	mov    0x8(%edx),%edx
  801708:	85 d2                	test   %edx,%edx
  80170a:	74 15                	je     801721 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80170c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80170f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801713:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801716:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80171a:	89 04 24             	mov    %eax,(%esp)
  80171d:	ff d2                	call   *%edx
  80171f:	eb 05                	jmp    801726 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801721:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801726:	83 c4 24             	add    $0x24,%esp
  801729:	5b                   	pop    %ebx
  80172a:	5d                   	pop    %ebp
  80172b:	c3                   	ret    

0080172c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	57                   	push   %edi
  801730:	56                   	push   %esi
  801731:	53                   	push   %ebx
  801732:	83 ec 1c             	sub    $0x1c,%esp
  801735:	8b 7d 08             	mov    0x8(%ebp),%edi
  801738:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80173b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801740:	eb 23                	jmp    801765 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801742:	89 f0                	mov    %esi,%eax
  801744:	29 d8                	sub    %ebx,%eax
  801746:	89 44 24 08          	mov    %eax,0x8(%esp)
  80174a:	89 d8                	mov    %ebx,%eax
  80174c:	03 45 0c             	add    0xc(%ebp),%eax
  80174f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801753:	89 3c 24             	mov    %edi,(%esp)
  801756:	e8 3f ff ff ff       	call   80169a <read>
		if (m < 0)
  80175b:	85 c0                	test   %eax,%eax
  80175d:	78 10                	js     80176f <readn+0x43>
			return m;
		if (m == 0)
  80175f:	85 c0                	test   %eax,%eax
  801761:	74 0a                	je     80176d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801763:	01 c3                	add    %eax,%ebx
  801765:	39 f3                	cmp    %esi,%ebx
  801767:	72 d9                	jb     801742 <readn+0x16>
  801769:	89 d8                	mov    %ebx,%eax
  80176b:	eb 02                	jmp    80176f <readn+0x43>
  80176d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80176f:	83 c4 1c             	add    $0x1c,%esp
  801772:	5b                   	pop    %ebx
  801773:	5e                   	pop    %esi
  801774:	5f                   	pop    %edi
  801775:	5d                   	pop    %ebp
  801776:	c3                   	ret    

00801777 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	53                   	push   %ebx
  80177b:	83 ec 24             	sub    $0x24,%esp
  80177e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801781:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801784:	89 44 24 04          	mov    %eax,0x4(%esp)
  801788:	89 1c 24             	mov    %ebx,(%esp)
  80178b:	e8 76 fc ff ff       	call   801406 <fd_lookup>
  801790:	89 c2                	mov    %eax,%edx
  801792:	85 d2                	test   %edx,%edx
  801794:	78 68                	js     8017fe <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801796:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801799:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a0:	8b 00                	mov    (%eax),%eax
  8017a2:	89 04 24             	mov    %eax,(%esp)
  8017a5:	e8 b2 fc ff ff       	call   80145c <dev_lookup>
  8017aa:	85 c0                	test   %eax,%eax
  8017ac:	78 50                	js     8017fe <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017b5:	75 23                	jne    8017da <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017b7:	a1 08 50 80 00       	mov    0x805008,%eax
  8017bc:	8b 40 48             	mov    0x48(%eax),%eax
  8017bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c7:	c7 04 24 61 30 80 00 	movl   $0x803061,(%esp)
  8017ce:	e8 24 ea ff ff       	call   8001f7 <cprintf>
		return -E_INVAL;
  8017d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d8:	eb 24                	jmp    8017fe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017dd:	8b 52 0c             	mov    0xc(%edx),%edx
  8017e0:	85 d2                	test   %edx,%edx
  8017e2:	74 15                	je     8017f9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017ee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017f2:	89 04 24             	mov    %eax,(%esp)
  8017f5:	ff d2                	call   *%edx
  8017f7:	eb 05                	jmp    8017fe <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8017f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8017fe:	83 c4 24             	add    $0x24,%esp
  801801:	5b                   	pop    %ebx
  801802:	5d                   	pop    %ebp
  801803:	c3                   	ret    

00801804 <seek>:

int
seek(int fdnum, off_t offset)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80180a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80180d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	89 04 24             	mov    %eax,(%esp)
  801817:	e8 ea fb ff ff       	call   801406 <fd_lookup>
  80181c:	85 c0                	test   %eax,%eax
  80181e:	78 0e                	js     80182e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801820:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801823:	8b 55 0c             	mov    0xc(%ebp),%edx
  801826:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801829:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	53                   	push   %ebx
  801834:	83 ec 24             	sub    $0x24,%esp
  801837:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80183a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80183d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801841:	89 1c 24             	mov    %ebx,(%esp)
  801844:	e8 bd fb ff ff       	call   801406 <fd_lookup>
  801849:	89 c2                	mov    %eax,%edx
  80184b:	85 d2                	test   %edx,%edx
  80184d:	78 61                	js     8018b0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80184f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801852:	89 44 24 04          	mov    %eax,0x4(%esp)
  801856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801859:	8b 00                	mov    (%eax),%eax
  80185b:	89 04 24             	mov    %eax,(%esp)
  80185e:	e8 f9 fb ff ff       	call   80145c <dev_lookup>
  801863:	85 c0                	test   %eax,%eax
  801865:	78 49                	js     8018b0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80186e:	75 23                	jne    801893 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801870:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801875:	8b 40 48             	mov    0x48(%eax),%eax
  801878:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80187c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801880:	c7 04 24 24 30 80 00 	movl   $0x803024,(%esp)
  801887:	e8 6b e9 ff ff       	call   8001f7 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80188c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801891:	eb 1d                	jmp    8018b0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801893:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801896:	8b 52 18             	mov    0x18(%edx),%edx
  801899:	85 d2                	test   %edx,%edx
  80189b:	74 0e                	je     8018ab <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80189d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018a4:	89 04 24             	mov    %eax,(%esp)
  8018a7:	ff d2                	call   *%edx
  8018a9:	eb 05                	jmp    8018b0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8018ab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8018b0:	83 c4 24             	add    $0x24,%esp
  8018b3:	5b                   	pop    %ebx
  8018b4:	5d                   	pop    %ebp
  8018b5:	c3                   	ret    

008018b6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	53                   	push   %ebx
  8018ba:	83 ec 24             	sub    $0x24,%esp
  8018bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	89 04 24             	mov    %eax,(%esp)
  8018cd:	e8 34 fb ff ff       	call   801406 <fd_lookup>
  8018d2:	89 c2                	mov    %eax,%edx
  8018d4:	85 d2                	test   %edx,%edx
  8018d6:	78 52                	js     80192a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e2:	8b 00                	mov    (%eax),%eax
  8018e4:	89 04 24             	mov    %eax,(%esp)
  8018e7:	e8 70 fb ff ff       	call   80145c <dev_lookup>
  8018ec:	85 c0                	test   %eax,%eax
  8018ee:	78 3a                	js     80192a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8018f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018f7:	74 2c                	je     801925 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018f9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018fc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801903:	00 00 00 
	stat->st_isdir = 0;
  801906:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80190d:	00 00 00 
	stat->st_dev = dev;
  801910:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801916:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80191a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80191d:	89 14 24             	mov    %edx,(%esp)
  801920:	ff 50 14             	call   *0x14(%eax)
  801923:	eb 05                	jmp    80192a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801925:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80192a:	83 c4 24             	add    $0x24,%esp
  80192d:	5b                   	pop    %ebx
  80192e:	5d                   	pop    %ebp
  80192f:	c3                   	ret    

00801930 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
  801933:	56                   	push   %esi
  801934:	53                   	push   %ebx
  801935:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801938:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80193f:	00 
  801940:	8b 45 08             	mov    0x8(%ebp),%eax
  801943:	89 04 24             	mov    %eax,(%esp)
  801946:	e8 84 02 00 00       	call   801bcf <open>
  80194b:	89 c3                	mov    %eax,%ebx
  80194d:	85 db                	test   %ebx,%ebx
  80194f:	78 1b                	js     80196c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801951:	8b 45 0c             	mov    0xc(%ebp),%eax
  801954:	89 44 24 04          	mov    %eax,0x4(%esp)
  801958:	89 1c 24             	mov    %ebx,(%esp)
  80195b:	e8 56 ff ff ff       	call   8018b6 <fstat>
  801960:	89 c6                	mov    %eax,%esi
	close(fd);
  801962:	89 1c 24             	mov    %ebx,(%esp)
  801965:	e8 cd fb ff ff       	call   801537 <close>
	return r;
  80196a:	89 f0                	mov    %esi,%eax
}
  80196c:	83 c4 10             	add    $0x10,%esp
  80196f:	5b                   	pop    %ebx
  801970:	5e                   	pop    %esi
  801971:	5d                   	pop    %ebp
  801972:	c3                   	ret    

00801973 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	56                   	push   %esi
  801977:	53                   	push   %ebx
  801978:	83 ec 10             	sub    $0x10,%esp
  80197b:	89 c6                	mov    %eax,%esi
  80197d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80197f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801986:	75 11                	jne    801999 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801988:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80198f:	e8 11 0f 00 00       	call   8028a5 <ipc_find_env>
  801994:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801999:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8019a0:	00 
  8019a1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8019a8:	00 
  8019a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019ad:	a1 00 50 80 00       	mov    0x805000,%eax
  8019b2:	89 04 24             	mov    %eax,(%esp)
  8019b5:	e8 5e 0e 00 00       	call   802818 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019c1:	00 
  8019c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019cd:	e8 de 0d 00 00       	call   8027b0 <ipc_recv>
}
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	5b                   	pop    %ebx
  8019d6:	5e                   	pop    %esi
  8019d7:	5d                   	pop    %ebp
  8019d8:	c3                   	ret    

008019d9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8019ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ed:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f7:	b8 02 00 00 00       	mov    $0x2,%eax
  8019fc:	e8 72 ff ff ff       	call   801973 <fsipc>
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a09:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a0f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a14:	ba 00 00 00 00       	mov    $0x0,%edx
  801a19:	b8 06 00 00 00       	mov    $0x6,%eax
  801a1e:	e8 50 ff ff ff       	call   801973 <fsipc>
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
  801a28:	53                   	push   %ebx
  801a29:	83 ec 14             	sub    $0x14,%esp
  801a2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	8b 40 0c             	mov    0xc(%eax),%eax
  801a35:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a44:	e8 2a ff ff ff       	call   801973 <fsipc>
  801a49:	89 c2                	mov    %eax,%edx
  801a4b:	85 d2                	test   %edx,%edx
  801a4d:	78 2b                	js     801a7a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a4f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801a56:	00 
  801a57:	89 1c 24             	mov    %ebx,(%esp)
  801a5a:	e8 c8 ed ff ff       	call   800827 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a5f:	a1 80 60 80 00       	mov    0x806080,%eax
  801a64:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a6a:	a1 84 60 80 00       	mov    0x806084,%eax
  801a6f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a75:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7a:	83 c4 14             	add    $0x14,%esp
  801a7d:	5b                   	pop    %ebx
  801a7e:	5d                   	pop    %ebp
  801a7f:	c3                   	ret    

00801a80 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	53                   	push   %ebx
  801a84:	83 ec 14             	sub    $0x14,%esp
  801a87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a90:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801a95:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801a9b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801aa0:	0f 46 c3             	cmovbe %ebx,%eax
  801aa3:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801aa8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab3:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801aba:	e8 05 ef ff ff       	call   8009c4 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801abf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ac4:	b8 04 00 00 00       	mov    $0x4,%eax
  801ac9:	e8 a5 fe ff ff       	call   801973 <fsipc>
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	78 53                	js     801b25 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801ad2:	39 c3                	cmp    %eax,%ebx
  801ad4:	73 24                	jae    801afa <devfile_write+0x7a>
  801ad6:	c7 44 24 0c 94 30 80 	movl   $0x803094,0xc(%esp)
  801add:	00 
  801ade:	c7 44 24 08 9b 30 80 	movl   $0x80309b,0x8(%esp)
  801ae5:	00 
  801ae6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801aed:	00 
  801aee:	c7 04 24 b0 30 80 00 	movl   $0x8030b0,(%esp)
  801af5:	e8 ac 0b 00 00       	call   8026a6 <_panic>
	assert(r <= PGSIZE);
  801afa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801aff:	7e 24                	jle    801b25 <devfile_write+0xa5>
  801b01:	c7 44 24 0c bb 30 80 	movl   $0x8030bb,0xc(%esp)
  801b08:	00 
  801b09:	c7 44 24 08 9b 30 80 	movl   $0x80309b,0x8(%esp)
  801b10:	00 
  801b11:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801b18:	00 
  801b19:	c7 04 24 b0 30 80 00 	movl   $0x8030b0,(%esp)
  801b20:	e8 81 0b 00 00       	call   8026a6 <_panic>
	return r;
}
  801b25:	83 c4 14             	add    $0x14,%esp
  801b28:	5b                   	pop    %ebx
  801b29:	5d                   	pop    %ebp
  801b2a:	c3                   	ret    

00801b2b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
  801b2e:	56                   	push   %esi
  801b2f:	53                   	push   %ebx
  801b30:	83 ec 10             	sub    $0x10,%esp
  801b33:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	8b 40 0c             	mov    0xc(%eax),%eax
  801b3c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b41:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b47:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4c:	b8 03 00 00 00       	mov    $0x3,%eax
  801b51:	e8 1d fe ff ff       	call   801973 <fsipc>
  801b56:	89 c3                	mov    %eax,%ebx
  801b58:	85 c0                	test   %eax,%eax
  801b5a:	78 6a                	js     801bc6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b5c:	39 c6                	cmp    %eax,%esi
  801b5e:	73 24                	jae    801b84 <devfile_read+0x59>
  801b60:	c7 44 24 0c 94 30 80 	movl   $0x803094,0xc(%esp)
  801b67:	00 
  801b68:	c7 44 24 08 9b 30 80 	movl   $0x80309b,0x8(%esp)
  801b6f:	00 
  801b70:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801b77:	00 
  801b78:	c7 04 24 b0 30 80 00 	movl   $0x8030b0,(%esp)
  801b7f:	e8 22 0b 00 00       	call   8026a6 <_panic>
	assert(r <= PGSIZE);
  801b84:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b89:	7e 24                	jle    801baf <devfile_read+0x84>
  801b8b:	c7 44 24 0c bb 30 80 	movl   $0x8030bb,0xc(%esp)
  801b92:	00 
  801b93:	c7 44 24 08 9b 30 80 	movl   $0x80309b,0x8(%esp)
  801b9a:	00 
  801b9b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801ba2:	00 
  801ba3:	c7 04 24 b0 30 80 00 	movl   $0x8030b0,(%esp)
  801baa:	e8 f7 0a 00 00       	call   8026a6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801baf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bb3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bba:	00 
  801bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbe:	89 04 24             	mov    %eax,(%esp)
  801bc1:	e8 fe ed ff ff       	call   8009c4 <memmove>
	return r;
}
  801bc6:	89 d8                	mov    %ebx,%eax
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	5b                   	pop    %ebx
  801bcc:	5e                   	pop    %esi
  801bcd:	5d                   	pop    %ebp
  801bce:	c3                   	ret    

00801bcf <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	53                   	push   %ebx
  801bd3:	83 ec 24             	sub    $0x24,%esp
  801bd6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801bd9:	89 1c 24             	mov    %ebx,(%esp)
  801bdc:	e8 0f ec ff ff       	call   8007f0 <strlen>
  801be1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801be6:	7f 60                	jg     801c48 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801be8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801beb:	89 04 24             	mov    %eax,(%esp)
  801bee:	e8 c4 f7 ff ff       	call   8013b7 <fd_alloc>
  801bf3:	89 c2                	mov    %eax,%edx
  801bf5:	85 d2                	test   %edx,%edx
  801bf7:	78 54                	js     801c4d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801bf9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bfd:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801c04:	e8 1e ec ff ff       	call   800827 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c14:	b8 01 00 00 00       	mov    $0x1,%eax
  801c19:	e8 55 fd ff ff       	call   801973 <fsipc>
  801c1e:	89 c3                	mov    %eax,%ebx
  801c20:	85 c0                	test   %eax,%eax
  801c22:	79 17                	jns    801c3b <open+0x6c>
		fd_close(fd, 0);
  801c24:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c2b:	00 
  801c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2f:	89 04 24             	mov    %eax,(%esp)
  801c32:	e8 7f f8 ff ff       	call   8014b6 <fd_close>
		return r;
  801c37:	89 d8                	mov    %ebx,%eax
  801c39:	eb 12                	jmp    801c4d <open+0x7e>
	}

	return fd2num(fd);
  801c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3e:	89 04 24             	mov    %eax,(%esp)
  801c41:	e8 4a f7 ff ff       	call   801390 <fd2num>
  801c46:	eb 05                	jmp    801c4d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c48:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801c4d:	83 c4 24             	add    $0x24,%esp
  801c50:	5b                   	pop    %ebx
  801c51:	5d                   	pop    %ebp
  801c52:	c3                   	ret    

00801c53 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c59:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5e:	b8 08 00 00 00       	mov    $0x8,%eax
  801c63:	e8 0b fd ff ff       	call   801973 <fsipc>
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    
  801c6a:	66 90                	xchg   %ax,%ax
  801c6c:	66 90                	xchg   %ax,%ax
  801c6e:	66 90                	xchg   %ax,%ax

00801c70 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801c76:	c7 44 24 04 c7 30 80 	movl   $0x8030c7,0x4(%esp)
  801c7d:	00 
  801c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c81:	89 04 24             	mov    %eax,(%esp)
  801c84:	e8 9e eb ff ff       	call   800827 <strcpy>
	return 0;
}
  801c89:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	53                   	push   %ebx
  801c94:	83 ec 14             	sub    $0x14,%esp
  801c97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c9a:	89 1c 24             	mov    %ebx,(%esp)
  801c9d:	e8 3d 0c 00 00       	call   8028df <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801ca2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801ca7:	83 f8 01             	cmp    $0x1,%eax
  801caa:	75 0d                	jne    801cb9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801cac:	8b 43 0c             	mov    0xc(%ebx),%eax
  801caf:	89 04 24             	mov    %eax,(%esp)
  801cb2:	e8 29 03 00 00       	call   801fe0 <nsipc_close>
  801cb7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801cb9:	89 d0                	mov    %edx,%eax
  801cbb:	83 c4 14             	add    $0x14,%esp
  801cbe:	5b                   	pop    %ebx
  801cbf:	5d                   	pop    %ebp
  801cc0:	c3                   	ret    

00801cc1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801cc7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cce:	00 
  801ccf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce3:	89 04 24             	mov    %eax,(%esp)
  801ce6:	e8 f0 03 00 00       	call   8020db <nsipc_send>
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cf3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cfa:	00 
  801cfb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cfe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d05:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0f:	89 04 24             	mov    %eax,(%esp)
  801d12:	e8 44 03 00 00       	call   80205b <nsipc_recv>
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d1f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d22:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d26:	89 04 24             	mov    %eax,(%esp)
  801d29:	e8 d8 f6 ff ff       	call   801406 <fd_lookup>
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	78 17                	js     801d49 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d35:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801d3b:	39 08                	cmp    %ecx,(%eax)
  801d3d:	75 05                	jne    801d44 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801d3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d42:	eb 05                	jmp    801d49 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801d44:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	56                   	push   %esi
  801d4f:	53                   	push   %ebx
  801d50:	83 ec 20             	sub    $0x20,%esp
  801d53:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d58:	89 04 24             	mov    %eax,(%esp)
  801d5b:	e8 57 f6 ff ff       	call   8013b7 <fd_alloc>
  801d60:	89 c3                	mov    %eax,%ebx
  801d62:	85 c0                	test   %eax,%eax
  801d64:	78 21                	js     801d87 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d66:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d6d:	00 
  801d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d7c:	e8 c2 ee ff ff       	call   800c43 <sys_page_alloc>
  801d81:	89 c3                	mov    %eax,%ebx
  801d83:	85 c0                	test   %eax,%eax
  801d85:	79 0c                	jns    801d93 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801d87:	89 34 24             	mov    %esi,(%esp)
  801d8a:	e8 51 02 00 00       	call   801fe0 <nsipc_close>
		return r;
  801d8f:	89 d8                	mov    %ebx,%eax
  801d91:	eb 20                	jmp    801db3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801d93:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801da8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801dab:	89 14 24             	mov    %edx,(%esp)
  801dae:	e8 dd f5 ff ff       	call   801390 <fd2num>
}
  801db3:	83 c4 20             	add    $0x20,%esp
  801db6:	5b                   	pop    %ebx
  801db7:	5e                   	pop    %esi
  801db8:	5d                   	pop    %ebp
  801db9:	c3                   	ret    

00801dba <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc3:	e8 51 ff ff ff       	call   801d19 <fd2sockid>
		return r;
  801dc8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	78 23                	js     801df1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801dce:	8b 55 10             	mov    0x10(%ebp),%edx
  801dd1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801dd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ddc:	89 04 24             	mov    %eax,(%esp)
  801ddf:	e8 45 01 00 00       	call   801f29 <nsipc_accept>
		return r;
  801de4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801de6:	85 c0                	test   %eax,%eax
  801de8:	78 07                	js     801df1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801dea:	e8 5c ff ff ff       	call   801d4b <alloc_sockfd>
  801def:	89 c1                	mov    %eax,%ecx
}
  801df1:	89 c8                	mov    %ecx,%eax
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	e8 16 ff ff ff       	call   801d19 <fd2sockid>
  801e03:	89 c2                	mov    %eax,%edx
  801e05:	85 d2                	test   %edx,%edx
  801e07:	78 16                	js     801e1f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801e09:	8b 45 10             	mov    0x10(%ebp),%eax
  801e0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e17:	89 14 24             	mov    %edx,(%esp)
  801e1a:	e8 60 01 00 00       	call   801f7f <nsipc_bind>
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <shutdown>:

int
shutdown(int s, int how)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	e8 ea fe ff ff       	call   801d19 <fd2sockid>
  801e2f:	89 c2                	mov    %eax,%edx
  801e31:	85 d2                	test   %edx,%edx
  801e33:	78 0f                	js     801e44 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e3c:	89 14 24             	mov    %edx,(%esp)
  801e3f:	e8 7a 01 00 00       	call   801fbe <nsipc_shutdown>
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4f:	e8 c5 fe ff ff       	call   801d19 <fd2sockid>
  801e54:	89 c2                	mov    %eax,%edx
  801e56:	85 d2                	test   %edx,%edx
  801e58:	78 16                	js     801e70 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801e5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e68:	89 14 24             	mov    %edx,(%esp)
  801e6b:	e8 8a 01 00 00       	call   801ffa <nsipc_connect>
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <listen>:

int
listen(int s, int backlog)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	e8 99 fe ff ff       	call   801d19 <fd2sockid>
  801e80:	89 c2                	mov    %eax,%edx
  801e82:	85 d2                	test   %edx,%edx
  801e84:	78 0f                	js     801e95 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e8d:	89 14 24             	mov    %edx,(%esp)
  801e90:	e8 a4 01 00 00       	call   802039 <nsipc_listen>
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	89 04 24             	mov    %eax,(%esp)
  801eb1:	e8 98 02 00 00       	call   80214e <nsipc_socket>
  801eb6:	89 c2                	mov    %eax,%edx
  801eb8:	85 d2                	test   %edx,%edx
  801eba:	78 05                	js     801ec1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801ebc:	e8 8a fe ff ff       	call   801d4b <alloc_sockfd>
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	53                   	push   %ebx
  801ec7:	83 ec 14             	sub    $0x14,%esp
  801eca:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ecc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801ed3:	75 11                	jne    801ee6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ed5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801edc:	e8 c4 09 00 00       	call   8028a5 <ipc_find_env>
  801ee1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ee6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801eed:	00 
  801eee:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801ef5:	00 
  801ef6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801efa:	a1 04 50 80 00       	mov    0x805004,%eax
  801eff:	89 04 24             	mov    %eax,(%esp)
  801f02:	e8 11 09 00 00       	call   802818 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f07:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f0e:	00 
  801f0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f16:	00 
  801f17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f1e:	e8 8d 08 00 00       	call   8027b0 <ipc_recv>
}
  801f23:	83 c4 14             	add    $0x14,%esp
  801f26:	5b                   	pop    %ebx
  801f27:	5d                   	pop    %ebp
  801f28:	c3                   	ret    

00801f29 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	56                   	push   %esi
  801f2d:	53                   	push   %ebx
  801f2e:	83 ec 10             	sub    $0x10,%esp
  801f31:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f34:	8b 45 08             	mov    0x8(%ebp),%eax
  801f37:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f3c:	8b 06                	mov    (%esi),%eax
  801f3e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f43:	b8 01 00 00 00       	mov    $0x1,%eax
  801f48:	e8 76 ff ff ff       	call   801ec3 <nsipc>
  801f4d:	89 c3                	mov    %eax,%ebx
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	78 23                	js     801f76 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f53:	a1 10 70 80 00       	mov    0x807010,%eax
  801f58:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f5c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801f63:	00 
  801f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f67:	89 04 24             	mov    %eax,(%esp)
  801f6a:	e8 55 ea ff ff       	call   8009c4 <memmove>
		*addrlen = ret->ret_addrlen;
  801f6f:	a1 10 70 80 00       	mov    0x807010,%eax
  801f74:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801f76:	89 d8                	mov    %ebx,%eax
  801f78:	83 c4 10             	add    $0x10,%esp
  801f7b:	5b                   	pop    %ebx
  801f7c:	5e                   	pop    %esi
  801f7d:	5d                   	pop    %ebp
  801f7e:	c3                   	ret    

00801f7f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	53                   	push   %ebx
  801f83:	83 ec 14             	sub    $0x14,%esp
  801f86:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f9c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801fa3:	e8 1c ea ff ff       	call   8009c4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fa8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801fae:	b8 02 00 00 00       	mov    $0x2,%eax
  801fb3:	e8 0b ff ff ff       	call   801ec3 <nsipc>
}
  801fb8:	83 c4 14             	add    $0x14,%esp
  801fbb:	5b                   	pop    %ebx
  801fbc:	5d                   	pop    %ebp
  801fbd:	c3                   	ret    

00801fbe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801fcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fcf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801fd4:	b8 03 00 00 00       	mov    $0x3,%eax
  801fd9:	e8 e5 fe ff ff       	call   801ec3 <nsipc>
}
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <nsipc_close>:

int
nsipc_close(int s)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801fee:	b8 04 00 00 00       	mov    $0x4,%eax
  801ff3:	e8 cb fe ff ff       	call   801ec3 <nsipc>
}
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    

00801ffa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
  801ffd:	53                   	push   %ebx
  801ffe:	83 ec 14             	sub    $0x14,%esp
  802001:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802004:	8b 45 08             	mov    0x8(%ebp),%eax
  802007:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80200c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802010:	8b 45 0c             	mov    0xc(%ebp),%eax
  802013:	89 44 24 04          	mov    %eax,0x4(%esp)
  802017:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80201e:	e8 a1 e9 ff ff       	call   8009c4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802023:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802029:	b8 05 00 00 00       	mov    $0x5,%eax
  80202e:	e8 90 fe ff ff       	call   801ec3 <nsipc>
}
  802033:	83 c4 14             	add    $0x14,%esp
  802036:	5b                   	pop    %ebx
  802037:	5d                   	pop    %ebp
  802038:	c3                   	ret    

00802039 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
  80203c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802047:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80204f:	b8 06 00 00 00       	mov    $0x6,%eax
  802054:	e8 6a fe ff ff       	call   801ec3 <nsipc>
}
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	56                   	push   %esi
  80205f:	53                   	push   %ebx
  802060:	83 ec 10             	sub    $0x10,%esp
  802063:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80206e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802074:	8b 45 14             	mov    0x14(%ebp),%eax
  802077:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80207c:	b8 07 00 00 00       	mov    $0x7,%eax
  802081:	e8 3d fe ff ff       	call   801ec3 <nsipc>
  802086:	89 c3                	mov    %eax,%ebx
  802088:	85 c0                	test   %eax,%eax
  80208a:	78 46                	js     8020d2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80208c:	39 f0                	cmp    %esi,%eax
  80208e:	7f 07                	jg     802097 <nsipc_recv+0x3c>
  802090:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802095:	7e 24                	jle    8020bb <nsipc_recv+0x60>
  802097:	c7 44 24 0c d3 30 80 	movl   $0x8030d3,0xc(%esp)
  80209e:	00 
  80209f:	c7 44 24 08 9b 30 80 	movl   $0x80309b,0x8(%esp)
  8020a6:	00 
  8020a7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8020ae:	00 
  8020af:	c7 04 24 e8 30 80 00 	movl   $0x8030e8,(%esp)
  8020b6:	e8 eb 05 00 00       	call   8026a6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020bf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8020c6:	00 
  8020c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ca:	89 04 24             	mov    %eax,(%esp)
  8020cd:	e8 f2 e8 ff ff       	call   8009c4 <memmove>
	}

	return r;
}
  8020d2:	89 d8                	mov    %ebx,%eax
  8020d4:	83 c4 10             	add    $0x10,%esp
  8020d7:	5b                   	pop    %ebx
  8020d8:	5e                   	pop    %esi
  8020d9:	5d                   	pop    %ebp
  8020da:	c3                   	ret    

008020db <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
  8020de:	53                   	push   %ebx
  8020df:	83 ec 14             	sub    $0x14,%esp
  8020e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8020ed:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020f3:	7e 24                	jle    802119 <nsipc_send+0x3e>
  8020f5:	c7 44 24 0c f4 30 80 	movl   $0x8030f4,0xc(%esp)
  8020fc:	00 
  8020fd:	c7 44 24 08 9b 30 80 	movl   $0x80309b,0x8(%esp)
  802104:	00 
  802105:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80210c:	00 
  80210d:	c7 04 24 e8 30 80 00 	movl   $0x8030e8,(%esp)
  802114:	e8 8d 05 00 00       	call   8026a6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802119:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80211d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802120:	89 44 24 04          	mov    %eax,0x4(%esp)
  802124:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80212b:	e8 94 e8 ff ff       	call   8009c4 <memmove>
	nsipcbuf.send.req_size = size;
  802130:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802136:	8b 45 14             	mov    0x14(%ebp),%eax
  802139:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80213e:	b8 08 00 00 00       	mov    $0x8,%eax
  802143:	e8 7b fd ff ff       	call   801ec3 <nsipc>
}
  802148:	83 c4 14             	add    $0x14,%esp
  80214b:	5b                   	pop    %ebx
  80214c:	5d                   	pop    %ebp
  80214d:	c3                   	ret    

0080214e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
  802151:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80215c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802164:	8b 45 10             	mov    0x10(%ebp),%eax
  802167:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80216c:	b8 09 00 00 00       	mov    $0x9,%eax
  802171:	e8 4d fd ff ff       	call   801ec3 <nsipc>
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	56                   	push   %esi
  80217c:	53                   	push   %ebx
  80217d:	83 ec 10             	sub    $0x10,%esp
  802180:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802183:	8b 45 08             	mov    0x8(%ebp),%eax
  802186:	89 04 24             	mov    %eax,(%esp)
  802189:	e8 12 f2 ff ff       	call   8013a0 <fd2data>
  80218e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802190:	c7 44 24 04 00 31 80 	movl   $0x803100,0x4(%esp)
  802197:	00 
  802198:	89 1c 24             	mov    %ebx,(%esp)
  80219b:	e8 87 e6 ff ff       	call   800827 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021a0:	8b 46 04             	mov    0x4(%esi),%eax
  8021a3:	2b 06                	sub    (%esi),%eax
  8021a5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021ab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021b2:	00 00 00 
	stat->st_dev = &devpipe;
  8021b5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8021bc:	40 80 00 
	return 0;
}
  8021bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c4:	83 c4 10             	add    $0x10,%esp
  8021c7:	5b                   	pop    %ebx
  8021c8:	5e                   	pop    %esi
  8021c9:	5d                   	pop    %ebp
  8021ca:	c3                   	ret    

008021cb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021cb:	55                   	push   %ebp
  8021cc:	89 e5                	mov    %esp,%ebp
  8021ce:	53                   	push   %ebx
  8021cf:	83 ec 14             	sub    $0x14,%esp
  8021d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021d5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021e0:	e8 05 eb ff ff       	call   800cea <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021e5:	89 1c 24             	mov    %ebx,(%esp)
  8021e8:	e8 b3 f1 ff ff       	call   8013a0 <fd2data>
  8021ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021f8:	e8 ed ea ff ff       	call   800cea <sys_page_unmap>
}
  8021fd:	83 c4 14             	add    $0x14,%esp
  802200:	5b                   	pop    %ebx
  802201:	5d                   	pop    %ebp
  802202:	c3                   	ret    

00802203 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802203:	55                   	push   %ebp
  802204:	89 e5                	mov    %esp,%ebp
  802206:	57                   	push   %edi
  802207:	56                   	push   %esi
  802208:	53                   	push   %ebx
  802209:	83 ec 2c             	sub    $0x2c,%esp
  80220c:	89 c6                	mov    %eax,%esi
  80220e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802211:	a1 08 50 80 00       	mov    0x805008,%eax
  802216:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802219:	89 34 24             	mov    %esi,(%esp)
  80221c:	e8 be 06 00 00       	call   8028df <pageref>
  802221:	89 c7                	mov    %eax,%edi
  802223:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802226:	89 04 24             	mov    %eax,(%esp)
  802229:	e8 b1 06 00 00       	call   8028df <pageref>
  80222e:	39 c7                	cmp    %eax,%edi
  802230:	0f 94 c2             	sete   %dl
  802233:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802236:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80223c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80223f:	39 fb                	cmp    %edi,%ebx
  802241:	74 21                	je     802264 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802243:	84 d2                	test   %dl,%dl
  802245:	74 ca                	je     802211 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802247:	8b 51 58             	mov    0x58(%ecx),%edx
  80224a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80224e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802252:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802256:	c7 04 24 07 31 80 00 	movl   $0x803107,(%esp)
  80225d:	e8 95 df ff ff       	call   8001f7 <cprintf>
  802262:	eb ad                	jmp    802211 <_pipeisclosed+0xe>
	}
}
  802264:	83 c4 2c             	add    $0x2c,%esp
  802267:	5b                   	pop    %ebx
  802268:	5e                   	pop    %esi
  802269:	5f                   	pop    %edi
  80226a:	5d                   	pop    %ebp
  80226b:	c3                   	ret    

0080226c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
  80226f:	57                   	push   %edi
  802270:	56                   	push   %esi
  802271:	53                   	push   %ebx
  802272:	83 ec 1c             	sub    $0x1c,%esp
  802275:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802278:	89 34 24             	mov    %esi,(%esp)
  80227b:	e8 20 f1 ff ff       	call   8013a0 <fd2data>
  802280:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802282:	bf 00 00 00 00       	mov    $0x0,%edi
  802287:	eb 45                	jmp    8022ce <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802289:	89 da                	mov    %ebx,%edx
  80228b:	89 f0                	mov    %esi,%eax
  80228d:	e8 71 ff ff ff       	call   802203 <_pipeisclosed>
  802292:	85 c0                	test   %eax,%eax
  802294:	75 41                	jne    8022d7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802296:	e8 89 e9 ff ff       	call   800c24 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80229b:	8b 43 04             	mov    0x4(%ebx),%eax
  80229e:	8b 0b                	mov    (%ebx),%ecx
  8022a0:	8d 51 20             	lea    0x20(%ecx),%edx
  8022a3:	39 d0                	cmp    %edx,%eax
  8022a5:	73 e2                	jae    802289 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022aa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8022ae:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8022b1:	99                   	cltd   
  8022b2:	c1 ea 1b             	shr    $0x1b,%edx
  8022b5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8022b8:	83 e1 1f             	and    $0x1f,%ecx
  8022bb:	29 d1                	sub    %edx,%ecx
  8022bd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8022c1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8022c5:	83 c0 01             	add    $0x1,%eax
  8022c8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022cb:	83 c7 01             	add    $0x1,%edi
  8022ce:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022d1:	75 c8                	jne    80229b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8022d3:	89 f8                	mov    %edi,%eax
  8022d5:	eb 05                	jmp    8022dc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8022d7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8022dc:	83 c4 1c             	add    $0x1c,%esp
  8022df:	5b                   	pop    %ebx
  8022e0:	5e                   	pop    %esi
  8022e1:	5f                   	pop    %edi
  8022e2:	5d                   	pop    %ebp
  8022e3:	c3                   	ret    

008022e4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	57                   	push   %edi
  8022e8:	56                   	push   %esi
  8022e9:	53                   	push   %ebx
  8022ea:	83 ec 1c             	sub    $0x1c,%esp
  8022ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8022f0:	89 3c 24             	mov    %edi,(%esp)
  8022f3:	e8 a8 f0 ff ff       	call   8013a0 <fd2data>
  8022f8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022fa:	be 00 00 00 00       	mov    $0x0,%esi
  8022ff:	eb 3d                	jmp    80233e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802301:	85 f6                	test   %esi,%esi
  802303:	74 04                	je     802309 <devpipe_read+0x25>
				return i;
  802305:	89 f0                	mov    %esi,%eax
  802307:	eb 43                	jmp    80234c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802309:	89 da                	mov    %ebx,%edx
  80230b:	89 f8                	mov    %edi,%eax
  80230d:	e8 f1 fe ff ff       	call   802203 <_pipeisclosed>
  802312:	85 c0                	test   %eax,%eax
  802314:	75 31                	jne    802347 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802316:	e8 09 e9 ff ff       	call   800c24 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80231b:	8b 03                	mov    (%ebx),%eax
  80231d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802320:	74 df                	je     802301 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802322:	99                   	cltd   
  802323:	c1 ea 1b             	shr    $0x1b,%edx
  802326:	01 d0                	add    %edx,%eax
  802328:	83 e0 1f             	and    $0x1f,%eax
  80232b:	29 d0                	sub    %edx,%eax
  80232d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802332:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802335:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802338:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80233b:	83 c6 01             	add    $0x1,%esi
  80233e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802341:	75 d8                	jne    80231b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802343:	89 f0                	mov    %esi,%eax
  802345:	eb 05                	jmp    80234c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802347:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80234c:	83 c4 1c             	add    $0x1c,%esp
  80234f:	5b                   	pop    %ebx
  802350:	5e                   	pop    %esi
  802351:	5f                   	pop    %edi
  802352:	5d                   	pop    %ebp
  802353:	c3                   	ret    

00802354 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	56                   	push   %esi
  802358:	53                   	push   %ebx
  802359:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80235c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80235f:	89 04 24             	mov    %eax,(%esp)
  802362:	e8 50 f0 ff ff       	call   8013b7 <fd_alloc>
  802367:	89 c2                	mov    %eax,%edx
  802369:	85 d2                	test   %edx,%edx
  80236b:	0f 88 4d 01 00 00    	js     8024be <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802371:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802378:	00 
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802380:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802387:	e8 b7 e8 ff ff       	call   800c43 <sys_page_alloc>
  80238c:	89 c2                	mov    %eax,%edx
  80238e:	85 d2                	test   %edx,%edx
  802390:	0f 88 28 01 00 00    	js     8024be <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802396:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802399:	89 04 24             	mov    %eax,(%esp)
  80239c:	e8 16 f0 ff ff       	call   8013b7 <fd_alloc>
  8023a1:	89 c3                	mov    %eax,%ebx
  8023a3:	85 c0                	test   %eax,%eax
  8023a5:	0f 88 fe 00 00 00    	js     8024a9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023ab:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023b2:	00 
  8023b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023c1:	e8 7d e8 ff ff       	call   800c43 <sys_page_alloc>
  8023c6:	89 c3                	mov    %eax,%ebx
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	0f 88 d9 00 00 00    	js     8024a9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	89 04 24             	mov    %eax,(%esp)
  8023d6:	e8 c5 ef ff ff       	call   8013a0 <fd2data>
  8023db:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023dd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023e4:	00 
  8023e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f0:	e8 4e e8 ff ff       	call   800c43 <sys_page_alloc>
  8023f5:	89 c3                	mov    %eax,%ebx
  8023f7:	85 c0                	test   %eax,%eax
  8023f9:	0f 88 97 00 00 00    	js     802496 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802402:	89 04 24             	mov    %eax,(%esp)
  802405:	e8 96 ef ff ff       	call   8013a0 <fd2data>
  80240a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802411:	00 
  802412:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802416:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80241d:	00 
  80241e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802422:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802429:	e8 69 e8 ff ff       	call   800c97 <sys_page_map>
  80242e:	89 c3                	mov    %eax,%ebx
  802430:	85 c0                	test   %eax,%eax
  802432:	78 52                	js     802486 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802434:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802449:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80244f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802452:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802457:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	89 04 24             	mov    %eax,(%esp)
  802464:	e8 27 ef ff ff       	call   801390 <fd2num>
  802469:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80246c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80246e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802471:	89 04 24             	mov    %eax,(%esp)
  802474:	e8 17 ef ff ff       	call   801390 <fd2num>
  802479:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80247c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80247f:	b8 00 00 00 00       	mov    $0x0,%eax
  802484:	eb 38                	jmp    8024be <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802486:	89 74 24 04          	mov    %esi,0x4(%esp)
  80248a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802491:	e8 54 e8 ff ff       	call   800cea <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802496:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802499:	89 44 24 04          	mov    %eax,0x4(%esp)
  80249d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a4:	e8 41 e8 ff ff       	call   800cea <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024b7:	e8 2e e8 ff ff       	call   800cea <sys_page_unmap>
  8024bc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8024be:	83 c4 30             	add    $0x30,%esp
  8024c1:	5b                   	pop    %ebx
  8024c2:	5e                   	pop    %esi
  8024c3:	5d                   	pop    %ebp
  8024c4:	c3                   	ret    

008024c5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
  8024c8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d5:	89 04 24             	mov    %eax,(%esp)
  8024d8:	e8 29 ef ff ff       	call   801406 <fd_lookup>
  8024dd:	89 c2                	mov    %eax,%edx
  8024df:	85 d2                	test   %edx,%edx
  8024e1:	78 15                	js     8024f8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	89 04 24             	mov    %eax,(%esp)
  8024e9:	e8 b2 ee ff ff       	call   8013a0 <fd2data>
	return _pipeisclosed(fd, p);
  8024ee:	89 c2                	mov    %eax,%edx
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	e8 0b fd ff ff       	call   802203 <_pipeisclosed>
}
  8024f8:	c9                   	leave  
  8024f9:	c3                   	ret    
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802503:	b8 00 00 00 00       	mov    $0x0,%eax
  802508:	5d                   	pop    %ebp
  802509:	c3                   	ret    

0080250a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802510:	c7 44 24 04 1f 31 80 	movl   $0x80311f,0x4(%esp)
  802517:	00 
  802518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251b:	89 04 24             	mov    %eax,(%esp)
  80251e:	e8 04 e3 ff ff       	call   800827 <strcpy>
	return 0;
}
  802523:	b8 00 00 00 00       	mov    $0x0,%eax
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
  80252d:	57                   	push   %edi
  80252e:	56                   	push   %esi
  80252f:	53                   	push   %ebx
  802530:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802536:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80253b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802541:	eb 31                	jmp    802574 <devcons_write+0x4a>
		m = n - tot;
  802543:	8b 75 10             	mov    0x10(%ebp),%esi
  802546:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802548:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80254b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802550:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802553:	89 74 24 08          	mov    %esi,0x8(%esp)
  802557:	03 45 0c             	add    0xc(%ebp),%eax
  80255a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80255e:	89 3c 24             	mov    %edi,(%esp)
  802561:	e8 5e e4 ff ff       	call   8009c4 <memmove>
		sys_cputs(buf, m);
  802566:	89 74 24 04          	mov    %esi,0x4(%esp)
  80256a:	89 3c 24             	mov    %edi,(%esp)
  80256d:	e8 04 e6 ff ff       	call   800b76 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802572:	01 f3                	add    %esi,%ebx
  802574:	89 d8                	mov    %ebx,%eax
  802576:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802579:	72 c8                	jb     802543 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80257b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802581:	5b                   	pop    %ebx
  802582:	5e                   	pop    %esi
  802583:	5f                   	pop    %edi
  802584:	5d                   	pop    %ebp
  802585:	c3                   	ret    

00802586 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
  802589:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80258c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802591:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802595:	75 07                	jne    80259e <devcons_read+0x18>
  802597:	eb 2a                	jmp    8025c3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802599:	e8 86 e6 ff ff       	call   800c24 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80259e:	66 90                	xchg   %ax,%ax
  8025a0:	e8 ef e5 ff ff       	call   800b94 <sys_cgetc>
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	74 f0                	je     802599 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8025a9:	85 c0                	test   %eax,%eax
  8025ab:	78 16                	js     8025c3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8025ad:	83 f8 04             	cmp    $0x4,%eax
  8025b0:	74 0c                	je     8025be <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8025b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b5:	88 02                	mov    %al,(%edx)
	return 1;
  8025b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bc:	eb 05                	jmp    8025c3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8025be:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8025c3:	c9                   	leave  
  8025c4:	c3                   	ret    

008025c5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8025c5:	55                   	push   %ebp
  8025c6:	89 e5                	mov    %esp,%ebp
  8025c8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8025cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ce:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8025d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8025d8:	00 
  8025d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025dc:	89 04 24             	mov    %eax,(%esp)
  8025df:	e8 92 e5 ff ff       	call   800b76 <sys_cputs>
}
  8025e4:	c9                   	leave  
  8025e5:	c3                   	ret    

008025e6 <getchar>:

int
getchar(void)
{
  8025e6:	55                   	push   %ebp
  8025e7:	89 e5                	mov    %esp,%ebp
  8025e9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8025ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8025f3:	00 
  8025f4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802602:	e8 93 f0 ff ff       	call   80169a <read>
	if (r < 0)
  802607:	85 c0                	test   %eax,%eax
  802609:	78 0f                	js     80261a <getchar+0x34>
		return r;
	if (r < 1)
  80260b:	85 c0                	test   %eax,%eax
  80260d:	7e 06                	jle    802615 <getchar+0x2f>
		return -E_EOF;
	return c;
  80260f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802613:	eb 05                	jmp    80261a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802615:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80261a:	c9                   	leave  
  80261b:	c3                   	ret    

0080261c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
  80261f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802622:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802625:	89 44 24 04          	mov    %eax,0x4(%esp)
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	89 04 24             	mov    %eax,(%esp)
  80262f:	e8 d2 ed ff ff       	call   801406 <fd_lookup>
  802634:	85 c0                	test   %eax,%eax
  802636:	78 11                	js     802649 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802641:	39 10                	cmp    %edx,(%eax)
  802643:	0f 94 c0             	sete   %al
  802646:	0f b6 c0             	movzbl %al,%eax
}
  802649:	c9                   	leave  
  80264a:	c3                   	ret    

0080264b <opencons>:

int
opencons(void)
{
  80264b:	55                   	push   %ebp
  80264c:	89 e5                	mov    %esp,%ebp
  80264e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802651:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802654:	89 04 24             	mov    %eax,(%esp)
  802657:	e8 5b ed ff ff       	call   8013b7 <fd_alloc>
		return r;
  80265c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80265e:	85 c0                	test   %eax,%eax
  802660:	78 40                	js     8026a2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802662:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802669:	00 
  80266a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802671:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802678:	e8 c6 e5 ff ff       	call   800c43 <sys_page_alloc>
		return r;
  80267d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80267f:	85 c0                	test   %eax,%eax
  802681:	78 1f                	js     8026a2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802683:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802698:	89 04 24             	mov    %eax,(%esp)
  80269b:	e8 f0 ec ff ff       	call   801390 <fd2num>
  8026a0:	89 c2                	mov    %eax,%edx
}
  8026a2:	89 d0                	mov    %edx,%eax
  8026a4:	c9                   	leave  
  8026a5:	c3                   	ret    

008026a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8026a6:	55                   	push   %ebp
  8026a7:	89 e5                	mov    %esp,%ebp
  8026a9:	56                   	push   %esi
  8026aa:	53                   	push   %ebx
  8026ab:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8026ae:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8026b1:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8026b7:	e8 49 e5 ff ff       	call   800c05 <sys_getenvid>
  8026bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026bf:	89 54 24 10          	mov    %edx,0x10(%esp)
  8026c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026ca:	89 74 24 08          	mov    %esi,0x8(%esp)
  8026ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d2:	c7 04 24 2c 31 80 00 	movl   $0x80312c,(%esp)
  8026d9:	e8 19 db ff ff       	call   8001f7 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8026de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8026e5:	89 04 24             	mov    %eax,(%esp)
  8026e8:	e8 a9 da ff ff       	call   800196 <vcprintf>
	cprintf("\n");
  8026ed:	c7 04 24 cf 2b 80 00 	movl   $0x802bcf,(%esp)
  8026f4:	e8 fe da ff ff       	call   8001f7 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8026f9:	cc                   	int3   
  8026fa:	eb fd                	jmp    8026f9 <_panic+0x53>

008026fc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8026fc:	55                   	push   %ebp
  8026fd:	89 e5                	mov    %esp,%ebp
  8026ff:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802702:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802709:	75 68                	jne    802773 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  80270b:	a1 08 50 80 00       	mov    0x805008,%eax
  802710:	8b 40 48             	mov    0x48(%eax),%eax
  802713:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80271a:	00 
  80271b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802722:	ee 
  802723:	89 04 24             	mov    %eax,(%esp)
  802726:	e8 18 e5 ff ff       	call   800c43 <sys_page_alloc>
  80272b:	85 c0                	test   %eax,%eax
  80272d:	74 2c                	je     80275b <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  80272f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802733:	c7 04 24 50 31 80 00 	movl   $0x803150,(%esp)
  80273a:	e8 b8 da ff ff       	call   8001f7 <cprintf>
			panic("set_pg_fault_handler");
  80273f:	c7 44 24 08 84 31 80 	movl   $0x803184,0x8(%esp)
  802746:	00 
  802747:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  80274e:	00 
  80274f:	c7 04 24 99 31 80 00 	movl   $0x803199,(%esp)
  802756:	e8 4b ff ff ff       	call   8026a6 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80275b:	a1 08 50 80 00       	mov    0x805008,%eax
  802760:	8b 40 48             	mov    0x48(%eax),%eax
  802763:	c7 44 24 04 7d 27 80 	movl   $0x80277d,0x4(%esp)
  80276a:	00 
  80276b:	89 04 24             	mov    %eax,(%esp)
  80276e:	e8 70 e6 ff ff       	call   800de3 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802773:	8b 45 08             	mov    0x8(%ebp),%eax
  802776:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80277b:	c9                   	leave  
  80277c:	c3                   	ret    

0080277d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80277d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80277e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802783:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802785:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  802788:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  80278c:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  80278e:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  802792:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  802793:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  802796:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  802798:	58                   	pop    %eax
	popl %eax
  802799:	58                   	pop    %eax
	popal
  80279a:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80279b:	83 c4 04             	add    $0x4,%esp
	popfl
  80279e:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80279f:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8027a0:	c3                   	ret    
  8027a1:	66 90                	xchg   %ax,%ax
  8027a3:	66 90                	xchg   %ax,%ax
  8027a5:	66 90                	xchg   %ax,%ax
  8027a7:	66 90                	xchg   %ax,%ax
  8027a9:	66 90                	xchg   %ax,%ax
  8027ab:	66 90                	xchg   %ax,%ax
  8027ad:	66 90                	xchg   %ax,%ax
  8027af:	90                   	nop

008027b0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
  8027b3:	56                   	push   %esi
  8027b4:	53                   	push   %ebx
  8027b5:	83 ec 10             	sub    $0x10,%esp
  8027b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8027bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8027c1:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  8027c3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8027c8:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  8027cb:	89 04 24             	mov    %eax,(%esp)
  8027ce:	e8 86 e6 ff ff       	call   800e59 <sys_ipc_recv>
  8027d3:	85 c0                	test   %eax,%eax
  8027d5:	74 16                	je     8027ed <ipc_recv+0x3d>
		if (from_env_store != NULL)
  8027d7:	85 f6                	test   %esi,%esi
  8027d9:	74 06                	je     8027e1 <ipc_recv+0x31>
			*from_env_store = 0;
  8027db:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8027e1:	85 db                	test   %ebx,%ebx
  8027e3:	74 2c                	je     802811 <ipc_recv+0x61>
			*perm_store = 0;
  8027e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8027eb:	eb 24                	jmp    802811 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8027ed:	85 f6                	test   %esi,%esi
  8027ef:	74 0a                	je     8027fb <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8027f1:	a1 08 50 80 00       	mov    0x805008,%eax
  8027f6:	8b 40 74             	mov    0x74(%eax),%eax
  8027f9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8027fb:	85 db                	test   %ebx,%ebx
  8027fd:	74 0a                	je     802809 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8027ff:	a1 08 50 80 00       	mov    0x805008,%eax
  802804:	8b 40 78             	mov    0x78(%eax),%eax
  802807:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802809:	a1 08 50 80 00       	mov    0x805008,%eax
  80280e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802811:	83 c4 10             	add    $0x10,%esp
  802814:	5b                   	pop    %ebx
  802815:	5e                   	pop    %esi
  802816:	5d                   	pop    %ebp
  802817:	c3                   	ret    

00802818 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802818:	55                   	push   %ebp
  802819:	89 e5                	mov    %esp,%ebp
  80281b:	57                   	push   %edi
  80281c:	56                   	push   %esi
  80281d:	53                   	push   %ebx
  80281e:	83 ec 1c             	sub    $0x1c,%esp
  802821:	8b 75 0c             	mov    0xc(%ebp),%esi
  802824:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802827:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80282a:	85 db                	test   %ebx,%ebx
  80282c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802831:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802834:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802838:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80283c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802840:	8b 45 08             	mov    0x8(%ebp),%eax
  802843:	89 04 24             	mov    %eax,(%esp)
  802846:	e8 eb e5 ff ff       	call   800e36 <sys_ipc_try_send>
	if (r == 0) return;
  80284b:	85 c0                	test   %eax,%eax
  80284d:	75 22                	jne    802871 <ipc_send+0x59>
  80284f:	eb 4c                	jmp    80289d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802851:	84 d2                	test   %dl,%dl
  802853:	75 48                	jne    80289d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802855:	e8 ca e3 ff ff       	call   800c24 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80285a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80285e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802862:	89 74 24 04          	mov    %esi,0x4(%esp)
  802866:	8b 45 08             	mov    0x8(%ebp),%eax
  802869:	89 04 24             	mov    %eax,(%esp)
  80286c:	e8 c5 e5 ff ff       	call   800e36 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802871:	85 c0                	test   %eax,%eax
  802873:	0f 94 c2             	sete   %dl
  802876:	74 d9                	je     802851 <ipc_send+0x39>
  802878:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80287b:	74 d4                	je     802851 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80287d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802881:	c7 44 24 08 a7 31 80 	movl   $0x8031a7,0x8(%esp)
  802888:	00 
  802889:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802890:	00 
  802891:	c7 04 24 b5 31 80 00 	movl   $0x8031b5,(%esp)
  802898:	e8 09 fe ff ff       	call   8026a6 <_panic>
}
  80289d:	83 c4 1c             	add    $0x1c,%esp
  8028a0:	5b                   	pop    %ebx
  8028a1:	5e                   	pop    %esi
  8028a2:	5f                   	pop    %edi
  8028a3:	5d                   	pop    %ebp
  8028a4:	c3                   	ret    

008028a5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028a5:	55                   	push   %ebp
  8028a6:	89 e5                	mov    %esp,%ebp
  8028a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028ab:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028b0:	89 c2                	mov    %eax,%edx
  8028b2:	c1 e2 07             	shl    $0x7,%edx
  8028b5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028bb:	8b 52 50             	mov    0x50(%edx),%edx
  8028be:	39 ca                	cmp    %ecx,%edx
  8028c0:	75 0d                	jne    8028cf <ipc_find_env+0x2a>
			return envs[i].env_id;
  8028c2:	c1 e0 07             	shl    $0x7,%eax
  8028c5:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8028ca:	8b 40 40             	mov    0x40(%eax),%eax
  8028cd:	eb 0e                	jmp    8028dd <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8028cf:	83 c0 01             	add    $0x1,%eax
  8028d2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028d7:	75 d7                	jne    8028b0 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8028d9:	66 b8 00 00          	mov    $0x0,%ax
}
  8028dd:	5d                   	pop    %ebp
  8028de:	c3                   	ret    

008028df <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028df:	55                   	push   %ebp
  8028e0:	89 e5                	mov    %esp,%ebp
  8028e2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028e5:	89 d0                	mov    %edx,%eax
  8028e7:	c1 e8 16             	shr    $0x16,%eax
  8028ea:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8028f1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028f6:	f6 c1 01             	test   $0x1,%cl
  8028f9:	74 1d                	je     802918 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8028fb:	c1 ea 0c             	shr    $0xc,%edx
  8028fe:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802905:	f6 c2 01             	test   $0x1,%dl
  802908:	74 0e                	je     802918 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80290a:	c1 ea 0c             	shr    $0xc,%edx
  80290d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802914:	ef 
  802915:	0f b7 c0             	movzwl %ax,%eax
}
  802918:	5d                   	pop    %ebp
  802919:	c3                   	ret    
  80291a:	66 90                	xchg   %ax,%ax
  80291c:	66 90                	xchg   %ax,%ax
  80291e:	66 90                	xchg   %ax,%ax

00802920 <__udivdi3>:
  802920:	55                   	push   %ebp
  802921:	57                   	push   %edi
  802922:	56                   	push   %esi
  802923:	83 ec 0c             	sub    $0xc,%esp
  802926:	8b 44 24 28          	mov    0x28(%esp),%eax
  80292a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80292e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802932:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802936:	85 c0                	test   %eax,%eax
  802938:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80293c:	89 ea                	mov    %ebp,%edx
  80293e:	89 0c 24             	mov    %ecx,(%esp)
  802941:	75 2d                	jne    802970 <__udivdi3+0x50>
  802943:	39 e9                	cmp    %ebp,%ecx
  802945:	77 61                	ja     8029a8 <__udivdi3+0x88>
  802947:	85 c9                	test   %ecx,%ecx
  802949:	89 ce                	mov    %ecx,%esi
  80294b:	75 0b                	jne    802958 <__udivdi3+0x38>
  80294d:	b8 01 00 00 00       	mov    $0x1,%eax
  802952:	31 d2                	xor    %edx,%edx
  802954:	f7 f1                	div    %ecx
  802956:	89 c6                	mov    %eax,%esi
  802958:	31 d2                	xor    %edx,%edx
  80295a:	89 e8                	mov    %ebp,%eax
  80295c:	f7 f6                	div    %esi
  80295e:	89 c5                	mov    %eax,%ebp
  802960:	89 f8                	mov    %edi,%eax
  802962:	f7 f6                	div    %esi
  802964:	89 ea                	mov    %ebp,%edx
  802966:	83 c4 0c             	add    $0xc,%esp
  802969:	5e                   	pop    %esi
  80296a:	5f                   	pop    %edi
  80296b:	5d                   	pop    %ebp
  80296c:	c3                   	ret    
  80296d:	8d 76 00             	lea    0x0(%esi),%esi
  802970:	39 e8                	cmp    %ebp,%eax
  802972:	77 24                	ja     802998 <__udivdi3+0x78>
  802974:	0f bd e8             	bsr    %eax,%ebp
  802977:	83 f5 1f             	xor    $0x1f,%ebp
  80297a:	75 3c                	jne    8029b8 <__udivdi3+0x98>
  80297c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802980:	39 34 24             	cmp    %esi,(%esp)
  802983:	0f 86 9f 00 00 00    	jbe    802a28 <__udivdi3+0x108>
  802989:	39 d0                	cmp    %edx,%eax
  80298b:	0f 82 97 00 00 00    	jb     802a28 <__udivdi3+0x108>
  802991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802998:	31 d2                	xor    %edx,%edx
  80299a:	31 c0                	xor    %eax,%eax
  80299c:	83 c4 0c             	add    $0xc,%esp
  80299f:	5e                   	pop    %esi
  8029a0:	5f                   	pop    %edi
  8029a1:	5d                   	pop    %ebp
  8029a2:	c3                   	ret    
  8029a3:	90                   	nop
  8029a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029a8:	89 f8                	mov    %edi,%eax
  8029aa:	f7 f1                	div    %ecx
  8029ac:	31 d2                	xor    %edx,%edx
  8029ae:	83 c4 0c             	add    $0xc,%esp
  8029b1:	5e                   	pop    %esi
  8029b2:	5f                   	pop    %edi
  8029b3:	5d                   	pop    %ebp
  8029b4:	c3                   	ret    
  8029b5:	8d 76 00             	lea    0x0(%esi),%esi
  8029b8:	89 e9                	mov    %ebp,%ecx
  8029ba:	8b 3c 24             	mov    (%esp),%edi
  8029bd:	d3 e0                	shl    %cl,%eax
  8029bf:	89 c6                	mov    %eax,%esi
  8029c1:	b8 20 00 00 00       	mov    $0x20,%eax
  8029c6:	29 e8                	sub    %ebp,%eax
  8029c8:	89 c1                	mov    %eax,%ecx
  8029ca:	d3 ef                	shr    %cl,%edi
  8029cc:	89 e9                	mov    %ebp,%ecx
  8029ce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8029d2:	8b 3c 24             	mov    (%esp),%edi
  8029d5:	09 74 24 08          	or     %esi,0x8(%esp)
  8029d9:	89 d6                	mov    %edx,%esi
  8029db:	d3 e7                	shl    %cl,%edi
  8029dd:	89 c1                	mov    %eax,%ecx
  8029df:	89 3c 24             	mov    %edi,(%esp)
  8029e2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8029e6:	d3 ee                	shr    %cl,%esi
  8029e8:	89 e9                	mov    %ebp,%ecx
  8029ea:	d3 e2                	shl    %cl,%edx
  8029ec:	89 c1                	mov    %eax,%ecx
  8029ee:	d3 ef                	shr    %cl,%edi
  8029f0:	09 d7                	or     %edx,%edi
  8029f2:	89 f2                	mov    %esi,%edx
  8029f4:	89 f8                	mov    %edi,%eax
  8029f6:	f7 74 24 08          	divl   0x8(%esp)
  8029fa:	89 d6                	mov    %edx,%esi
  8029fc:	89 c7                	mov    %eax,%edi
  8029fe:	f7 24 24             	mull   (%esp)
  802a01:	39 d6                	cmp    %edx,%esi
  802a03:	89 14 24             	mov    %edx,(%esp)
  802a06:	72 30                	jb     802a38 <__udivdi3+0x118>
  802a08:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a0c:	89 e9                	mov    %ebp,%ecx
  802a0e:	d3 e2                	shl    %cl,%edx
  802a10:	39 c2                	cmp    %eax,%edx
  802a12:	73 05                	jae    802a19 <__udivdi3+0xf9>
  802a14:	3b 34 24             	cmp    (%esp),%esi
  802a17:	74 1f                	je     802a38 <__udivdi3+0x118>
  802a19:	89 f8                	mov    %edi,%eax
  802a1b:	31 d2                	xor    %edx,%edx
  802a1d:	e9 7a ff ff ff       	jmp    80299c <__udivdi3+0x7c>
  802a22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a28:	31 d2                	xor    %edx,%edx
  802a2a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a2f:	e9 68 ff ff ff       	jmp    80299c <__udivdi3+0x7c>
  802a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a38:	8d 47 ff             	lea    -0x1(%edi),%eax
  802a3b:	31 d2                	xor    %edx,%edx
  802a3d:	83 c4 0c             	add    $0xc,%esp
  802a40:	5e                   	pop    %esi
  802a41:	5f                   	pop    %edi
  802a42:	5d                   	pop    %ebp
  802a43:	c3                   	ret    
  802a44:	66 90                	xchg   %ax,%ax
  802a46:	66 90                	xchg   %ax,%ax
  802a48:	66 90                	xchg   %ax,%ax
  802a4a:	66 90                	xchg   %ax,%ax
  802a4c:	66 90                	xchg   %ax,%ax
  802a4e:	66 90                	xchg   %ax,%ax

00802a50 <__umoddi3>:
  802a50:	55                   	push   %ebp
  802a51:	57                   	push   %edi
  802a52:	56                   	push   %esi
  802a53:	83 ec 14             	sub    $0x14,%esp
  802a56:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a5a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a5e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802a62:	89 c7                	mov    %eax,%edi
  802a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a68:	8b 44 24 30          	mov    0x30(%esp),%eax
  802a6c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802a70:	89 34 24             	mov    %esi,(%esp)
  802a73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a77:	85 c0                	test   %eax,%eax
  802a79:	89 c2                	mov    %eax,%edx
  802a7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a7f:	75 17                	jne    802a98 <__umoddi3+0x48>
  802a81:	39 fe                	cmp    %edi,%esi
  802a83:	76 4b                	jbe    802ad0 <__umoddi3+0x80>
  802a85:	89 c8                	mov    %ecx,%eax
  802a87:	89 fa                	mov    %edi,%edx
  802a89:	f7 f6                	div    %esi
  802a8b:	89 d0                	mov    %edx,%eax
  802a8d:	31 d2                	xor    %edx,%edx
  802a8f:	83 c4 14             	add    $0x14,%esp
  802a92:	5e                   	pop    %esi
  802a93:	5f                   	pop    %edi
  802a94:	5d                   	pop    %ebp
  802a95:	c3                   	ret    
  802a96:	66 90                	xchg   %ax,%ax
  802a98:	39 f8                	cmp    %edi,%eax
  802a9a:	77 54                	ja     802af0 <__umoddi3+0xa0>
  802a9c:	0f bd e8             	bsr    %eax,%ebp
  802a9f:	83 f5 1f             	xor    $0x1f,%ebp
  802aa2:	75 5c                	jne    802b00 <__umoddi3+0xb0>
  802aa4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802aa8:	39 3c 24             	cmp    %edi,(%esp)
  802aab:	0f 87 e7 00 00 00    	ja     802b98 <__umoddi3+0x148>
  802ab1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ab5:	29 f1                	sub    %esi,%ecx
  802ab7:	19 c7                	sbb    %eax,%edi
  802ab9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802abd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ac1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ac5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802ac9:	83 c4 14             	add    $0x14,%esp
  802acc:	5e                   	pop    %esi
  802acd:	5f                   	pop    %edi
  802ace:	5d                   	pop    %ebp
  802acf:	c3                   	ret    
  802ad0:	85 f6                	test   %esi,%esi
  802ad2:	89 f5                	mov    %esi,%ebp
  802ad4:	75 0b                	jne    802ae1 <__umoddi3+0x91>
  802ad6:	b8 01 00 00 00       	mov    $0x1,%eax
  802adb:	31 d2                	xor    %edx,%edx
  802add:	f7 f6                	div    %esi
  802adf:	89 c5                	mov    %eax,%ebp
  802ae1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802ae5:	31 d2                	xor    %edx,%edx
  802ae7:	f7 f5                	div    %ebp
  802ae9:	89 c8                	mov    %ecx,%eax
  802aeb:	f7 f5                	div    %ebp
  802aed:	eb 9c                	jmp    802a8b <__umoddi3+0x3b>
  802aef:	90                   	nop
  802af0:	89 c8                	mov    %ecx,%eax
  802af2:	89 fa                	mov    %edi,%edx
  802af4:	83 c4 14             	add    $0x14,%esp
  802af7:	5e                   	pop    %esi
  802af8:	5f                   	pop    %edi
  802af9:	5d                   	pop    %ebp
  802afa:	c3                   	ret    
  802afb:	90                   	nop
  802afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b00:	8b 04 24             	mov    (%esp),%eax
  802b03:	be 20 00 00 00       	mov    $0x20,%esi
  802b08:	89 e9                	mov    %ebp,%ecx
  802b0a:	29 ee                	sub    %ebp,%esi
  802b0c:	d3 e2                	shl    %cl,%edx
  802b0e:	89 f1                	mov    %esi,%ecx
  802b10:	d3 e8                	shr    %cl,%eax
  802b12:	89 e9                	mov    %ebp,%ecx
  802b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b18:	8b 04 24             	mov    (%esp),%eax
  802b1b:	09 54 24 04          	or     %edx,0x4(%esp)
  802b1f:	89 fa                	mov    %edi,%edx
  802b21:	d3 e0                	shl    %cl,%eax
  802b23:	89 f1                	mov    %esi,%ecx
  802b25:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b29:	8b 44 24 10          	mov    0x10(%esp),%eax
  802b2d:	d3 ea                	shr    %cl,%edx
  802b2f:	89 e9                	mov    %ebp,%ecx
  802b31:	d3 e7                	shl    %cl,%edi
  802b33:	89 f1                	mov    %esi,%ecx
  802b35:	d3 e8                	shr    %cl,%eax
  802b37:	89 e9                	mov    %ebp,%ecx
  802b39:	09 f8                	or     %edi,%eax
  802b3b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802b3f:	f7 74 24 04          	divl   0x4(%esp)
  802b43:	d3 e7                	shl    %cl,%edi
  802b45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b49:	89 d7                	mov    %edx,%edi
  802b4b:	f7 64 24 08          	mull   0x8(%esp)
  802b4f:	39 d7                	cmp    %edx,%edi
  802b51:	89 c1                	mov    %eax,%ecx
  802b53:	89 14 24             	mov    %edx,(%esp)
  802b56:	72 2c                	jb     802b84 <__umoddi3+0x134>
  802b58:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802b5c:	72 22                	jb     802b80 <__umoddi3+0x130>
  802b5e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802b62:	29 c8                	sub    %ecx,%eax
  802b64:	19 d7                	sbb    %edx,%edi
  802b66:	89 e9                	mov    %ebp,%ecx
  802b68:	89 fa                	mov    %edi,%edx
  802b6a:	d3 e8                	shr    %cl,%eax
  802b6c:	89 f1                	mov    %esi,%ecx
  802b6e:	d3 e2                	shl    %cl,%edx
  802b70:	89 e9                	mov    %ebp,%ecx
  802b72:	d3 ef                	shr    %cl,%edi
  802b74:	09 d0                	or     %edx,%eax
  802b76:	89 fa                	mov    %edi,%edx
  802b78:	83 c4 14             	add    $0x14,%esp
  802b7b:	5e                   	pop    %esi
  802b7c:	5f                   	pop    %edi
  802b7d:	5d                   	pop    %ebp
  802b7e:	c3                   	ret    
  802b7f:	90                   	nop
  802b80:	39 d7                	cmp    %edx,%edi
  802b82:	75 da                	jne    802b5e <__umoddi3+0x10e>
  802b84:	8b 14 24             	mov    (%esp),%edx
  802b87:	89 c1                	mov    %eax,%ecx
  802b89:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802b8d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802b91:	eb cb                	jmp    802b5e <__umoddi3+0x10e>
  802b93:	90                   	nop
  802b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b98:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802b9c:	0f 82 0f ff ff ff    	jb     802ab1 <__umoddi3+0x61>
  802ba2:	e9 1a ff ff ff       	jmp    802ac1 <__umoddi3+0x71>
