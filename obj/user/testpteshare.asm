
obj/user/testpteshare.debug:     file format elf32-i386


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
  80002c:	e8 86 01 00 00       	call   8001b7 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	strcpy(VA, msg2);
  800039:	a1 00 40 80 00       	mov    0x804000,%eax
  80003e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800042:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  800049:	e8 e9 08 00 00       	call   800937 <strcpy>
	exit();
  80004e:	e8 ac 01 00 00       	call   8001ff <exit>
}
  800053:	c9                   	leave  
  800054:	c3                   	ret    

00800055 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800055:	55                   	push   %ebp
  800056:	89 e5                	mov    %esp,%ebp
  800058:	53                   	push   %ebx
  800059:	83 ec 14             	sub    $0x14,%esp
	int r;

	if (argc != 0)
  80005c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800060:	74 05                	je     800067 <umain+0x12>
		childofspawn();
  800062:	e8 cc ff ff ff       	call   800033 <childofspawn>

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800067:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 00 00 00 	movl   $0xa0000000,0x4(%esp)
  800076:	a0 
  800077:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80007e:	e8 d0 0c 00 00       	call   800d53 <sys_page_alloc>
  800083:	85 c0                	test   %eax,%eax
  800085:	79 20                	jns    8000a7 <umain+0x52>
		panic("sys_page_alloc: %e", r);
  800087:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80008b:	c7 44 24 08 cc 36 80 	movl   $0x8036cc,0x8(%esp)
  800092:	00 
  800093:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80009a:	00 
  80009b:	c7 04 24 df 36 80 00 	movl   $0x8036df,(%esp)
  8000a2:	e8 71 01 00 00       	call   800218 <_panic>

	// check fork
	if ((r = fork()) < 0)
  8000a7:	e8 f4 10 00 00       	call   8011a0 <fork>
  8000ac:	89 c3                	mov    %eax,%ebx
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	79 20                	jns    8000d2 <umain+0x7d>
		panic("fork: %e", r);
  8000b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b6:	c7 44 24 08 f3 36 80 	movl   $0x8036f3,0x8(%esp)
  8000bd:	00 
  8000be:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  8000c5:	00 
  8000c6:	c7 04 24 df 36 80 00 	movl   $0x8036df,(%esp)
  8000cd:	e8 46 01 00 00       	call   800218 <_panic>
	if (r == 0) {
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	75 1a                	jne    8000f0 <umain+0x9b>
		strcpy(VA, msg);
  8000d6:	a1 04 40 80 00       	mov    0x804004,%eax
  8000db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000df:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  8000e6:	e8 4c 08 00 00       	call   800937 <strcpy>
		exit();
  8000eb:	e8 0f 01 00 00       	call   8001ff <exit>
	}
	wait(r);
  8000f0:	89 1c 24             	mov    %ebx,(%esp)
  8000f3:	e8 12 2f 00 00       	call   80300a <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000f8:	a1 04 40 80 00       	mov    0x804004,%eax
  8000fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800101:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  800108:	e8 df 08 00 00       	call   8009ec <strcmp>
  80010d:	85 c0                	test   %eax,%eax
  80010f:	b8 c0 36 80 00       	mov    $0x8036c0,%eax
  800114:	ba c6 36 80 00       	mov    $0x8036c6,%edx
  800119:	0f 45 c2             	cmovne %edx,%eax
  80011c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800120:	c7 04 24 fc 36 80 00 	movl   $0x8036fc,(%esp)
  800127:	e8 e5 01 00 00       	call   800311 <cprintf>

	// check spawn
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  80012c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800133:	00 
  800134:	c7 44 24 08 17 37 80 	movl   $0x803717,0x8(%esp)
  80013b:	00 
  80013c:	c7 44 24 04 1c 37 80 	movl   $0x80371c,0x4(%esp)
  800143:	00 
  800144:	c7 04 24 1b 37 80 00 	movl   $0x80371b,(%esp)
  80014b:	e8 d3 21 00 00       	call   802323 <spawnl>
  800150:	85 c0                	test   %eax,%eax
  800152:	79 20                	jns    800174 <umain+0x11f>
		panic("spawn: %e", r);
  800154:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800158:	c7 44 24 08 29 37 80 	movl   $0x803729,0x8(%esp)
  80015f:	00 
  800160:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800167:	00 
  800168:	c7 04 24 df 36 80 00 	movl   $0x8036df,(%esp)
  80016f:	e8 a4 00 00 00       	call   800218 <_panic>
	wait(r);
  800174:	89 04 24             	mov    %eax,(%esp)
  800177:	e8 8e 2e 00 00       	call   80300a <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80017c:	a1 00 40 80 00       	mov    0x804000,%eax
  800181:	89 44 24 04          	mov    %eax,0x4(%esp)
  800185:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80018c:	e8 5b 08 00 00       	call   8009ec <strcmp>
  800191:	85 c0                	test   %eax,%eax
  800193:	b8 c0 36 80 00       	mov    $0x8036c0,%eax
  800198:	ba c6 36 80 00       	mov    $0x8036c6,%edx
  80019d:	0f 45 c2             	cmovne %edx,%eax
  8001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a4:	c7 04 24 33 37 80 00 	movl   $0x803733,(%esp)
  8001ab:	e8 61 01 00 00       	call   800311 <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  8001b0:	cc                   	int3   

	breakpoint();
}
  8001b1:	83 c4 14             	add    $0x14,%esp
  8001b4:	5b                   	pop    %ebx
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	56                   	push   %esi
  8001bb:	53                   	push   %ebx
  8001bc:	83 ec 10             	sub    $0x10,%esp
  8001bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001c2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001c5:	e8 4b 0b 00 00       	call   800d15 <sys_getenvid>
  8001ca:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001cf:	c1 e0 07             	shl    $0x7,%eax
  8001d2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001d7:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001dc:	85 db                	test   %ebx,%ebx
  8001de:	7e 07                	jle    8001e7 <libmain+0x30>
		binaryname = argv[0];
  8001e0:	8b 06                	mov    (%esi),%eax
  8001e2:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  8001e7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001eb:	89 1c 24             	mov    %ebx,(%esp)
  8001ee:	e8 62 fe ff ff       	call   800055 <umain>

	// exit gracefully
	exit();
  8001f3:	e8 07 00 00 00       	call   8001ff <exit>
}
  8001f8:	83 c4 10             	add    $0x10,%esp
  8001fb:	5b                   	pop    %ebx
  8001fc:	5e                   	pop    %esi
  8001fd:	5d                   	pop    %ebp
  8001fe:	c3                   	ret    

008001ff <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800205:	e8 70 14 00 00       	call   80167a <close_all>
	sys_env_destroy(0);
  80020a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800211:	e8 ad 0a 00 00       	call   800cc3 <sys_env_destroy>
}
  800216:	c9                   	leave  
  800217:	c3                   	ret    

00800218 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	56                   	push   %esi
  80021c:	53                   	push   %ebx
  80021d:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800220:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800223:	8b 35 08 40 80 00    	mov    0x804008,%esi
  800229:	e8 e7 0a 00 00       	call   800d15 <sys_getenvid>
  80022e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800231:	89 54 24 10          	mov    %edx,0x10(%esp)
  800235:	8b 55 08             	mov    0x8(%ebp),%edx
  800238:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80023c:	89 74 24 08          	mov    %esi,0x8(%esp)
  800240:	89 44 24 04          	mov    %eax,0x4(%esp)
  800244:	c7 04 24 78 37 80 00 	movl   $0x803778,(%esp)
  80024b:	e8 c1 00 00 00       	call   800311 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800250:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800254:	8b 45 10             	mov    0x10(%ebp),%eax
  800257:	89 04 24             	mov    %eax,(%esp)
  80025a:	e8 51 00 00 00       	call   8002b0 <vcprintf>
	cprintf("\n");
  80025f:	c7 04 24 9f 3d 80 00 	movl   $0x803d9f,(%esp)
  800266:	e8 a6 00 00 00       	call   800311 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80026b:	cc                   	int3   
  80026c:	eb fd                	jmp    80026b <_panic+0x53>

0080026e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80026e:	55                   	push   %ebp
  80026f:	89 e5                	mov    %esp,%ebp
  800271:	53                   	push   %ebx
  800272:	83 ec 14             	sub    $0x14,%esp
  800275:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800278:	8b 13                	mov    (%ebx),%edx
  80027a:	8d 42 01             	lea    0x1(%edx),%eax
  80027d:	89 03                	mov    %eax,(%ebx)
  80027f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800282:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800286:	3d ff 00 00 00       	cmp    $0xff,%eax
  80028b:	75 19                	jne    8002a6 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80028d:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800294:	00 
  800295:	8d 43 08             	lea    0x8(%ebx),%eax
  800298:	89 04 24             	mov    %eax,(%esp)
  80029b:	e8 e6 09 00 00       	call   800c86 <sys_cputs>
		b->idx = 0;
  8002a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002a6:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002aa:	83 c4 14             	add    $0x14,%esp
  8002ad:	5b                   	pop    %ebx
  8002ae:	5d                   	pop    %ebp
  8002af:	c3                   	ret    

008002b0 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002b0:	55                   	push   %ebp
  8002b1:	89 e5                	mov    %esp,%ebp
  8002b3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002b9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002c0:	00 00 00 
	b.cnt = 0;
  8002c3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ca:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e5:	c7 04 24 6e 02 80 00 	movl   $0x80026e,(%esp)
  8002ec:	e8 ad 01 00 00       	call   80049e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002f1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002fb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800301:	89 04 24             	mov    %eax,(%esp)
  800304:	e8 7d 09 00 00       	call   800c86 <sys_cputs>

	return b.cnt;
}
  800309:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800317:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80031a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	89 04 24             	mov    %eax,(%esp)
  800324:	e8 87 ff ff ff       	call   8002b0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800329:	c9                   	leave  
  80032a:	c3                   	ret    
  80032b:	66 90                	xchg   %ax,%ax
  80032d:	66 90                	xchg   %ax,%ax
  80032f:	90                   	nop

00800330 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	57                   	push   %edi
  800334:	56                   	push   %esi
  800335:	53                   	push   %ebx
  800336:	83 ec 3c             	sub    $0x3c,%esp
  800339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80033c:	89 d7                	mov    %edx,%edi
  80033e:	8b 45 08             	mov    0x8(%ebp),%eax
  800341:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800344:	8b 45 0c             	mov    0xc(%ebp),%eax
  800347:	89 c3                	mov    %eax,%ebx
  800349:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80034c:	8b 45 10             	mov    0x10(%ebp),%eax
  80034f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800352:	b9 00 00 00 00       	mov    $0x0,%ecx
  800357:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80035d:	39 d9                	cmp    %ebx,%ecx
  80035f:	72 05                	jb     800366 <printnum+0x36>
  800361:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800364:	77 69                	ja     8003cf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800366:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800369:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80036d:	83 ee 01             	sub    $0x1,%esi
  800370:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800374:	89 44 24 08          	mov    %eax,0x8(%esp)
  800378:	8b 44 24 08          	mov    0x8(%esp),%eax
  80037c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800380:	89 c3                	mov    %eax,%ebx
  800382:	89 d6                	mov    %edx,%esi
  800384:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800387:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80038a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80038e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800392:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800395:	89 04 24             	mov    %eax,(%esp)
  800398:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80039b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039f:	e8 8c 30 00 00       	call   803430 <__udivdi3>
  8003a4:	89 d9                	mov    %ebx,%ecx
  8003a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003aa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003ae:	89 04 24             	mov    %eax,(%esp)
  8003b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003b5:	89 fa                	mov    %edi,%edx
  8003b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ba:	e8 71 ff ff ff       	call   800330 <printnum>
  8003bf:	eb 1b                	jmp    8003dc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003c1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c8:	89 04 24             	mov    %eax,(%esp)
  8003cb:	ff d3                	call   *%ebx
  8003cd:	eb 03                	jmp    8003d2 <printnum+0xa2>
  8003cf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003d2:	83 ee 01             	sub    $0x1,%esi
  8003d5:	85 f6                	test   %esi,%esi
  8003d7:	7f e8                	jg     8003c1 <printnum+0x91>
  8003d9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003e0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ee:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f5:	89 04 24             	mov    %eax,(%esp)
  8003f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ff:	e8 5c 31 00 00       	call   803560 <__umoddi3>
  800404:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800408:	0f be 80 9b 37 80 00 	movsbl 0x80379b(%eax),%eax
  80040f:	89 04 24             	mov    %eax,(%esp)
  800412:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800415:	ff d0                	call   *%eax
}
  800417:	83 c4 3c             	add    $0x3c,%esp
  80041a:	5b                   	pop    %ebx
  80041b:	5e                   	pop    %esi
  80041c:	5f                   	pop    %edi
  80041d:	5d                   	pop    %ebp
  80041e:	c3                   	ret    

0080041f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80041f:	55                   	push   %ebp
  800420:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800422:	83 fa 01             	cmp    $0x1,%edx
  800425:	7e 0e                	jle    800435 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800427:	8b 10                	mov    (%eax),%edx
  800429:	8d 4a 08             	lea    0x8(%edx),%ecx
  80042c:	89 08                	mov    %ecx,(%eax)
  80042e:	8b 02                	mov    (%edx),%eax
  800430:	8b 52 04             	mov    0x4(%edx),%edx
  800433:	eb 22                	jmp    800457 <getuint+0x38>
	else if (lflag)
  800435:	85 d2                	test   %edx,%edx
  800437:	74 10                	je     800449 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800439:	8b 10                	mov    (%eax),%edx
  80043b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80043e:	89 08                	mov    %ecx,(%eax)
  800440:	8b 02                	mov    (%edx),%eax
  800442:	ba 00 00 00 00       	mov    $0x0,%edx
  800447:	eb 0e                	jmp    800457 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800449:	8b 10                	mov    (%eax),%edx
  80044b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80044e:	89 08                	mov    %ecx,(%eax)
  800450:	8b 02                	mov    (%edx),%eax
  800452:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800457:	5d                   	pop    %ebp
  800458:	c3                   	ret    

00800459 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80045f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800463:	8b 10                	mov    (%eax),%edx
  800465:	3b 50 04             	cmp    0x4(%eax),%edx
  800468:	73 0a                	jae    800474 <sprintputch+0x1b>
		*b->buf++ = ch;
  80046a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80046d:	89 08                	mov    %ecx,(%eax)
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	88 02                	mov    %al,(%edx)
}
  800474:	5d                   	pop    %ebp
  800475:	c3                   	ret    

00800476 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
  800479:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80047c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80047f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800483:	8b 45 10             	mov    0x10(%ebp),%eax
  800486:	89 44 24 08          	mov    %eax,0x8(%esp)
  80048a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800491:	8b 45 08             	mov    0x8(%ebp),%eax
  800494:	89 04 24             	mov    %eax,(%esp)
  800497:	e8 02 00 00 00       	call   80049e <vprintfmt>
	va_end(ap);
}
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    

0080049e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80049e:	55                   	push   %ebp
  80049f:	89 e5                	mov    %esp,%ebp
  8004a1:	57                   	push   %edi
  8004a2:	56                   	push   %esi
  8004a3:	53                   	push   %ebx
  8004a4:	83 ec 3c             	sub    $0x3c,%esp
  8004a7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8004aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004ad:	eb 14                	jmp    8004c3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004af:	85 c0                	test   %eax,%eax
  8004b1:	0f 84 b3 03 00 00    	je     80086a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8004b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004bb:	89 04 24             	mov    %eax,(%esp)
  8004be:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004c1:	89 f3                	mov    %esi,%ebx
  8004c3:	8d 73 01             	lea    0x1(%ebx),%esi
  8004c6:	0f b6 03             	movzbl (%ebx),%eax
  8004c9:	83 f8 25             	cmp    $0x25,%eax
  8004cc:	75 e1                	jne    8004af <vprintfmt+0x11>
  8004ce:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8004d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004d9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8004e0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8004e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ec:	eb 1d                	jmp    80050b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ee:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004f0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8004f4:	eb 15                	jmp    80050b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004f8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8004fc:	eb 0d                	jmp    80050b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800501:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800504:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80050e:	0f b6 0e             	movzbl (%esi),%ecx
  800511:	0f b6 c1             	movzbl %cl,%eax
  800514:	83 e9 23             	sub    $0x23,%ecx
  800517:	80 f9 55             	cmp    $0x55,%cl
  80051a:	0f 87 2a 03 00 00    	ja     80084a <vprintfmt+0x3ac>
  800520:	0f b6 c9             	movzbl %cl,%ecx
  800523:	ff 24 8d e0 38 80 00 	jmp    *0x8038e0(,%ecx,4)
  80052a:	89 de                	mov    %ebx,%esi
  80052c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800531:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800534:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800538:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80053b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80053e:	83 fb 09             	cmp    $0x9,%ebx
  800541:	77 36                	ja     800579 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800543:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800546:	eb e9                	jmp    800531 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800548:	8b 45 14             	mov    0x14(%ebp),%eax
  80054b:	8d 48 04             	lea    0x4(%eax),%ecx
  80054e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800551:	8b 00                	mov    (%eax),%eax
  800553:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800556:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800558:	eb 22                	jmp    80057c <vprintfmt+0xde>
  80055a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80055d:	85 c9                	test   %ecx,%ecx
  80055f:	b8 00 00 00 00       	mov    $0x0,%eax
  800564:	0f 49 c1             	cmovns %ecx,%eax
  800567:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056a:	89 de                	mov    %ebx,%esi
  80056c:	eb 9d                	jmp    80050b <vprintfmt+0x6d>
  80056e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800570:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800577:	eb 92                	jmp    80050b <vprintfmt+0x6d>
  800579:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80057c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800580:	79 89                	jns    80050b <vprintfmt+0x6d>
  800582:	e9 77 ff ff ff       	jmp    8004fe <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800587:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80058a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80058c:	e9 7a ff ff ff       	jmp    80050b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8d 50 04             	lea    0x4(%eax),%edx
  800597:	89 55 14             	mov    %edx,0x14(%ebp)
  80059a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 04 24             	mov    %eax,(%esp)
  8005a3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005a6:	e9 18 ff ff ff       	jmp    8004c3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ae:	8d 50 04             	lea    0x4(%eax),%edx
  8005b1:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b4:	8b 00                	mov    (%eax),%eax
  8005b6:	99                   	cltd   
  8005b7:	31 d0                	xor    %edx,%eax
  8005b9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005bb:	83 f8 11             	cmp    $0x11,%eax
  8005be:	7f 0b                	jg     8005cb <vprintfmt+0x12d>
  8005c0:	8b 14 85 40 3a 80 00 	mov    0x803a40(,%eax,4),%edx
  8005c7:	85 d2                	test   %edx,%edx
  8005c9:	75 20                	jne    8005eb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8005cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005cf:	c7 44 24 08 b3 37 80 	movl   $0x8037b3,0x8(%esp)
  8005d6:	00 
  8005d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	89 04 24             	mov    %eax,(%esp)
  8005e1:	e8 90 fe ff ff       	call   800476 <printfmt>
  8005e6:	e9 d8 fe ff ff       	jmp    8004c3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8005eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005ef:	c7 44 24 08 6d 3c 80 	movl   $0x803c6d,0x8(%esp)
  8005f6:	00 
  8005f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fe:	89 04 24             	mov    %eax,(%esp)
  800601:	e8 70 fe ff ff       	call   800476 <printfmt>
  800606:	e9 b8 fe ff ff       	jmp    8004c3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80060b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80060e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800611:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8d 50 04             	lea    0x4(%eax),%edx
  80061a:	89 55 14             	mov    %edx,0x14(%ebp)
  80061d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80061f:	85 f6                	test   %esi,%esi
  800621:	b8 ac 37 80 00       	mov    $0x8037ac,%eax
  800626:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800629:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80062d:	0f 84 97 00 00 00    	je     8006ca <vprintfmt+0x22c>
  800633:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800637:	0f 8e 9b 00 00 00    	jle    8006d8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80063d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800641:	89 34 24             	mov    %esi,(%esp)
  800644:	e8 cf 02 00 00       	call   800918 <strnlen>
  800649:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80064c:	29 c2                	sub    %eax,%edx
  80064e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800651:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800655:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800658:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80065b:	8b 75 08             	mov    0x8(%ebp),%esi
  80065e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800661:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800663:	eb 0f                	jmp    800674 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800665:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800669:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80066c:	89 04 24             	mov    %eax,(%esp)
  80066f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800671:	83 eb 01             	sub    $0x1,%ebx
  800674:	85 db                	test   %ebx,%ebx
  800676:	7f ed                	jg     800665 <vprintfmt+0x1c7>
  800678:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80067b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80067e:	85 d2                	test   %edx,%edx
  800680:	b8 00 00 00 00       	mov    $0x0,%eax
  800685:	0f 49 c2             	cmovns %edx,%eax
  800688:	29 c2                	sub    %eax,%edx
  80068a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80068d:	89 d7                	mov    %edx,%edi
  80068f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800692:	eb 50                	jmp    8006e4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800694:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800698:	74 1e                	je     8006b8 <vprintfmt+0x21a>
  80069a:	0f be d2             	movsbl %dl,%edx
  80069d:	83 ea 20             	sub    $0x20,%edx
  8006a0:	83 fa 5e             	cmp    $0x5e,%edx
  8006a3:	76 13                	jbe    8006b8 <vprintfmt+0x21a>
					putch('?', putdat);
  8006a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ac:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006b3:	ff 55 08             	call   *0x8(%ebp)
  8006b6:	eb 0d                	jmp    8006c5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8006b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006bb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006bf:	89 04 24             	mov    %eax,(%esp)
  8006c2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c5:	83 ef 01             	sub    $0x1,%edi
  8006c8:	eb 1a                	jmp    8006e4 <vprintfmt+0x246>
  8006ca:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006cd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006d0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006d3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006d6:	eb 0c                	jmp    8006e4 <vprintfmt+0x246>
  8006d8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006db:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006de:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006e1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006e4:	83 c6 01             	add    $0x1,%esi
  8006e7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8006eb:	0f be c2             	movsbl %dl,%eax
  8006ee:	85 c0                	test   %eax,%eax
  8006f0:	74 27                	je     800719 <vprintfmt+0x27b>
  8006f2:	85 db                	test   %ebx,%ebx
  8006f4:	78 9e                	js     800694 <vprintfmt+0x1f6>
  8006f6:	83 eb 01             	sub    $0x1,%ebx
  8006f9:	79 99                	jns    800694 <vprintfmt+0x1f6>
  8006fb:	89 f8                	mov    %edi,%eax
  8006fd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800700:	8b 75 08             	mov    0x8(%ebp),%esi
  800703:	89 c3                	mov    %eax,%ebx
  800705:	eb 1a                	jmp    800721 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800707:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800712:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800714:	83 eb 01             	sub    $0x1,%ebx
  800717:	eb 08                	jmp    800721 <vprintfmt+0x283>
  800719:	89 fb                	mov    %edi,%ebx
  80071b:	8b 75 08             	mov    0x8(%ebp),%esi
  80071e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800721:	85 db                	test   %ebx,%ebx
  800723:	7f e2                	jg     800707 <vprintfmt+0x269>
  800725:	89 75 08             	mov    %esi,0x8(%ebp)
  800728:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80072b:	e9 93 fd ff ff       	jmp    8004c3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800730:	83 fa 01             	cmp    $0x1,%edx
  800733:	7e 16                	jle    80074b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8d 50 08             	lea    0x8(%eax),%edx
  80073b:	89 55 14             	mov    %edx,0x14(%ebp)
  80073e:	8b 50 04             	mov    0x4(%eax),%edx
  800741:	8b 00                	mov    (%eax),%eax
  800743:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800746:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800749:	eb 32                	jmp    80077d <vprintfmt+0x2df>
	else if (lflag)
  80074b:	85 d2                	test   %edx,%edx
  80074d:	74 18                	je     800767 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8d 50 04             	lea    0x4(%eax),%edx
  800755:	89 55 14             	mov    %edx,0x14(%ebp)
  800758:	8b 30                	mov    (%eax),%esi
  80075a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80075d:	89 f0                	mov    %esi,%eax
  80075f:	c1 f8 1f             	sar    $0x1f,%eax
  800762:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800765:	eb 16                	jmp    80077d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8d 50 04             	lea    0x4(%eax),%edx
  80076d:	89 55 14             	mov    %edx,0x14(%ebp)
  800770:	8b 30                	mov    (%eax),%esi
  800772:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800775:	89 f0                	mov    %esi,%eax
  800777:	c1 f8 1f             	sar    $0x1f,%eax
  80077a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80077d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800780:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800783:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800788:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80078c:	0f 89 80 00 00 00    	jns    800812 <vprintfmt+0x374>
				putch('-', putdat);
  800792:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800796:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80079d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007a6:	f7 d8                	neg    %eax
  8007a8:	83 d2 00             	adc    $0x0,%edx
  8007ab:	f7 da                	neg    %edx
			}
			base = 10;
  8007ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007b2:	eb 5e                	jmp    800812 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007b4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b7:	e8 63 fc ff ff       	call   80041f <getuint>
			base = 10;
  8007bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007c1:	eb 4f                	jmp    800812 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8007c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c6:	e8 54 fc ff ff       	call   80041f <getuint>
			base = 8;
  8007cb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007d0:	eb 40                	jmp    800812 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  8007d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007dd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007eb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8d 50 04             	lea    0x4(%eax),%edx
  8007f4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007fe:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800803:	eb 0d                	jmp    800812 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800805:	8d 45 14             	lea    0x14(%ebp),%eax
  800808:	e8 12 fc ff ff       	call   80041f <getuint>
			base = 16;
  80080d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800812:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800816:	89 74 24 10          	mov    %esi,0x10(%esp)
  80081a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80081d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800821:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800825:	89 04 24             	mov    %eax,(%esp)
  800828:	89 54 24 04          	mov    %edx,0x4(%esp)
  80082c:	89 fa                	mov    %edi,%edx
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	e8 fa fa ff ff       	call   800330 <printnum>
			break;
  800836:	e9 88 fc ff ff       	jmp    8004c3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80083b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80083f:	89 04 24             	mov    %eax,(%esp)
  800842:	ff 55 08             	call   *0x8(%ebp)
			break;
  800845:	e9 79 fc ff ff       	jmp    8004c3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80084a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80084e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800855:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800858:	89 f3                	mov    %esi,%ebx
  80085a:	eb 03                	jmp    80085f <vprintfmt+0x3c1>
  80085c:	83 eb 01             	sub    $0x1,%ebx
  80085f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800863:	75 f7                	jne    80085c <vprintfmt+0x3be>
  800865:	e9 59 fc ff ff       	jmp    8004c3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80086a:	83 c4 3c             	add    $0x3c,%esp
  80086d:	5b                   	pop    %ebx
  80086e:	5e                   	pop    %esi
  80086f:	5f                   	pop    %edi
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	83 ec 28             	sub    $0x28,%esp
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80087e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800881:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800885:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800888:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80088f:	85 c0                	test   %eax,%eax
  800891:	74 30                	je     8008c3 <vsnprintf+0x51>
  800893:	85 d2                	test   %edx,%edx
  800895:	7e 2c                	jle    8008c3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80089e:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008a5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ac:	c7 04 24 59 04 80 00 	movl   $0x800459,(%esp)
  8008b3:	e8 e6 fb ff ff       	call   80049e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c1:	eb 05                	jmp    8008c8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008c8:	c9                   	leave  
  8008c9:	c3                   	ret    

008008ca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	89 04 24             	mov    %eax,(%esp)
  8008eb:	e8 82 ff ff ff       	call   800872 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008f0:	c9                   	leave  
  8008f1:	c3                   	ret    
  8008f2:	66 90                	xchg   %ax,%ax
  8008f4:	66 90                	xchg   %ax,%ax
  8008f6:	66 90                	xchg   %ax,%ax
  8008f8:	66 90                	xchg   %ax,%ax
  8008fa:	66 90                	xchg   %ax,%ax
  8008fc:	66 90                	xchg   %ax,%ax
  8008fe:	66 90                	xchg   %ax,%ax

00800900 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800906:	b8 00 00 00 00       	mov    $0x0,%eax
  80090b:	eb 03                	jmp    800910 <strlen+0x10>
		n++;
  80090d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800910:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800914:	75 f7                	jne    80090d <strlen+0xd>
		n++;
	return n;
}
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800921:	b8 00 00 00 00       	mov    $0x0,%eax
  800926:	eb 03                	jmp    80092b <strnlen+0x13>
		n++;
  800928:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092b:	39 d0                	cmp    %edx,%eax
  80092d:	74 06                	je     800935 <strnlen+0x1d>
  80092f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800933:	75 f3                	jne    800928 <strnlen+0x10>
		n++;
	return n;
}
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	53                   	push   %ebx
  80093b:	8b 45 08             	mov    0x8(%ebp),%eax
  80093e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800941:	89 c2                	mov    %eax,%edx
  800943:	83 c2 01             	add    $0x1,%edx
  800946:	83 c1 01             	add    $0x1,%ecx
  800949:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80094d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800950:	84 db                	test   %bl,%bl
  800952:	75 ef                	jne    800943 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800954:	5b                   	pop    %ebx
  800955:	5d                   	pop    %ebp
  800956:	c3                   	ret    

00800957 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800957:	55                   	push   %ebp
  800958:	89 e5                	mov    %esp,%ebp
  80095a:	53                   	push   %ebx
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800961:	89 1c 24             	mov    %ebx,(%esp)
  800964:	e8 97 ff ff ff       	call   800900 <strlen>
	strcpy(dst + len, src);
  800969:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800970:	01 d8                	add    %ebx,%eax
  800972:	89 04 24             	mov    %eax,(%esp)
  800975:	e8 bd ff ff ff       	call   800937 <strcpy>
	return dst;
}
  80097a:	89 d8                	mov    %ebx,%eax
  80097c:	83 c4 08             	add    $0x8,%esp
  80097f:	5b                   	pop    %ebx
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	56                   	push   %esi
  800986:	53                   	push   %ebx
  800987:	8b 75 08             	mov    0x8(%ebp),%esi
  80098a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098d:	89 f3                	mov    %esi,%ebx
  80098f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800992:	89 f2                	mov    %esi,%edx
  800994:	eb 0f                	jmp    8009a5 <strncpy+0x23>
		*dst++ = *src;
  800996:	83 c2 01             	add    $0x1,%edx
  800999:	0f b6 01             	movzbl (%ecx),%eax
  80099c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80099f:	80 39 01             	cmpb   $0x1,(%ecx)
  8009a2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a5:	39 da                	cmp    %ebx,%edx
  8009a7:	75 ed                	jne    800996 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009a9:	89 f0                	mov    %esi,%eax
  8009ab:	5b                   	pop    %ebx
  8009ac:	5e                   	pop    %esi
  8009ad:	5d                   	pop    %ebp
  8009ae:	c3                   	ret    

008009af <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	56                   	push   %esi
  8009b3:	53                   	push   %ebx
  8009b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009bd:	89 f0                	mov    %esi,%eax
  8009bf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c3:	85 c9                	test   %ecx,%ecx
  8009c5:	75 0b                	jne    8009d2 <strlcpy+0x23>
  8009c7:	eb 1d                	jmp    8009e6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009c9:	83 c0 01             	add    $0x1,%eax
  8009cc:	83 c2 01             	add    $0x1,%edx
  8009cf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009d2:	39 d8                	cmp    %ebx,%eax
  8009d4:	74 0b                	je     8009e1 <strlcpy+0x32>
  8009d6:	0f b6 0a             	movzbl (%edx),%ecx
  8009d9:	84 c9                	test   %cl,%cl
  8009db:	75 ec                	jne    8009c9 <strlcpy+0x1a>
  8009dd:	89 c2                	mov    %eax,%edx
  8009df:	eb 02                	jmp    8009e3 <strlcpy+0x34>
  8009e1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8009e3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8009e6:	29 f0                	sub    %esi,%eax
}
  8009e8:	5b                   	pop    %ebx
  8009e9:	5e                   	pop    %esi
  8009ea:	5d                   	pop    %ebp
  8009eb:	c3                   	ret    

008009ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f5:	eb 06                	jmp    8009fd <strcmp+0x11>
		p++, q++;
  8009f7:	83 c1 01             	add    $0x1,%ecx
  8009fa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009fd:	0f b6 01             	movzbl (%ecx),%eax
  800a00:	84 c0                	test   %al,%al
  800a02:	74 04                	je     800a08 <strcmp+0x1c>
  800a04:	3a 02                	cmp    (%edx),%al
  800a06:	74 ef                	je     8009f7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a08:	0f b6 c0             	movzbl %al,%eax
  800a0b:	0f b6 12             	movzbl (%edx),%edx
  800a0e:	29 d0                	sub    %edx,%eax
}
  800a10:	5d                   	pop    %ebp
  800a11:	c3                   	ret    

00800a12 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a12:	55                   	push   %ebp
  800a13:	89 e5                	mov    %esp,%ebp
  800a15:	53                   	push   %ebx
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a1c:	89 c3                	mov    %eax,%ebx
  800a1e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a21:	eb 06                	jmp    800a29 <strncmp+0x17>
		n--, p++, q++;
  800a23:	83 c0 01             	add    $0x1,%eax
  800a26:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a29:	39 d8                	cmp    %ebx,%eax
  800a2b:	74 15                	je     800a42 <strncmp+0x30>
  800a2d:	0f b6 08             	movzbl (%eax),%ecx
  800a30:	84 c9                	test   %cl,%cl
  800a32:	74 04                	je     800a38 <strncmp+0x26>
  800a34:	3a 0a                	cmp    (%edx),%cl
  800a36:	74 eb                	je     800a23 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a38:	0f b6 00             	movzbl (%eax),%eax
  800a3b:	0f b6 12             	movzbl (%edx),%edx
  800a3e:	29 d0                	sub    %edx,%eax
  800a40:	eb 05                	jmp    800a47 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a42:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a47:	5b                   	pop    %ebx
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    

00800a4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a54:	eb 07                	jmp    800a5d <strchr+0x13>
		if (*s == c)
  800a56:	38 ca                	cmp    %cl,%dl
  800a58:	74 0f                	je     800a69 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a5a:	83 c0 01             	add    $0x1,%eax
  800a5d:	0f b6 10             	movzbl (%eax),%edx
  800a60:	84 d2                	test   %dl,%dl
  800a62:	75 f2                	jne    800a56 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a69:	5d                   	pop    %ebp
  800a6a:	c3                   	ret    

00800a6b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a6b:	55                   	push   %ebp
  800a6c:	89 e5                	mov    %esp,%ebp
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a75:	eb 07                	jmp    800a7e <strfind+0x13>
		if (*s == c)
  800a77:	38 ca                	cmp    %cl,%dl
  800a79:	74 0a                	je     800a85 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a7b:	83 c0 01             	add    $0x1,%eax
  800a7e:	0f b6 10             	movzbl (%eax),%edx
  800a81:	84 d2                	test   %dl,%dl
  800a83:	75 f2                	jne    800a77 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a85:	5d                   	pop    %ebp
  800a86:	c3                   	ret    

00800a87 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	57                   	push   %edi
  800a8b:	56                   	push   %esi
  800a8c:	53                   	push   %ebx
  800a8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a93:	85 c9                	test   %ecx,%ecx
  800a95:	74 36                	je     800acd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a97:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a9d:	75 28                	jne    800ac7 <memset+0x40>
  800a9f:	f6 c1 03             	test   $0x3,%cl
  800aa2:	75 23                	jne    800ac7 <memset+0x40>
		c &= 0xFF;
  800aa4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aa8:	89 d3                	mov    %edx,%ebx
  800aaa:	c1 e3 08             	shl    $0x8,%ebx
  800aad:	89 d6                	mov    %edx,%esi
  800aaf:	c1 e6 18             	shl    $0x18,%esi
  800ab2:	89 d0                	mov    %edx,%eax
  800ab4:	c1 e0 10             	shl    $0x10,%eax
  800ab7:	09 f0                	or     %esi,%eax
  800ab9:	09 c2                	or     %eax,%edx
  800abb:	89 d0                	mov    %edx,%eax
  800abd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800abf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ac2:	fc                   	cld    
  800ac3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ac5:	eb 06                	jmp    800acd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aca:	fc                   	cld    
  800acb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800acd:	89 f8                	mov    %edi,%eax
  800acf:	5b                   	pop    %ebx
  800ad0:	5e                   	pop    %esi
  800ad1:	5f                   	pop    %edi
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	57                   	push   %edi
  800ad8:	56                   	push   %esi
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800adf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae2:	39 c6                	cmp    %eax,%esi
  800ae4:	73 35                	jae    800b1b <memmove+0x47>
  800ae6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ae9:	39 d0                	cmp    %edx,%eax
  800aeb:	73 2e                	jae    800b1b <memmove+0x47>
		s += n;
		d += n;
  800aed:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800af0:	89 d6                	mov    %edx,%esi
  800af2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800afa:	75 13                	jne    800b0f <memmove+0x3b>
  800afc:	f6 c1 03             	test   $0x3,%cl
  800aff:	75 0e                	jne    800b0f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b01:	83 ef 04             	sub    $0x4,%edi
  800b04:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b07:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b0a:	fd                   	std    
  800b0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b0d:	eb 09                	jmp    800b18 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b0f:	83 ef 01             	sub    $0x1,%edi
  800b12:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b15:	fd                   	std    
  800b16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b18:	fc                   	cld    
  800b19:	eb 1d                	jmp    800b38 <memmove+0x64>
  800b1b:	89 f2                	mov    %esi,%edx
  800b1d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1f:	f6 c2 03             	test   $0x3,%dl
  800b22:	75 0f                	jne    800b33 <memmove+0x5f>
  800b24:	f6 c1 03             	test   $0x3,%cl
  800b27:	75 0a                	jne    800b33 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b29:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b2c:	89 c7                	mov    %eax,%edi
  800b2e:	fc                   	cld    
  800b2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b31:	eb 05                	jmp    800b38 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b33:	89 c7                	mov    %eax,%edi
  800b35:	fc                   	cld    
  800b36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b38:	5e                   	pop    %esi
  800b39:	5f                   	pop    %edi
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b42:	8b 45 10             	mov    0x10(%ebp),%eax
  800b45:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	89 04 24             	mov    %eax,(%esp)
  800b56:	e8 79 ff ff ff       	call   800ad4 <memmove>
}
  800b5b:	c9                   	leave  
  800b5c:	c3                   	ret    

00800b5d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
  800b65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b68:	89 d6                	mov    %edx,%esi
  800b6a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b6d:	eb 1a                	jmp    800b89 <memcmp+0x2c>
		if (*s1 != *s2)
  800b6f:	0f b6 02             	movzbl (%edx),%eax
  800b72:	0f b6 19             	movzbl (%ecx),%ebx
  800b75:	38 d8                	cmp    %bl,%al
  800b77:	74 0a                	je     800b83 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b79:	0f b6 c0             	movzbl %al,%eax
  800b7c:	0f b6 db             	movzbl %bl,%ebx
  800b7f:	29 d8                	sub    %ebx,%eax
  800b81:	eb 0f                	jmp    800b92 <memcmp+0x35>
		s1++, s2++;
  800b83:	83 c2 01             	add    $0x1,%edx
  800b86:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b89:	39 f2                	cmp    %esi,%edx
  800b8b:	75 e2                	jne    800b6f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b92:	5b                   	pop    %ebx
  800b93:	5e                   	pop    %esi
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b9f:	89 c2                	mov    %eax,%edx
  800ba1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ba4:	eb 07                	jmp    800bad <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ba6:	38 08                	cmp    %cl,(%eax)
  800ba8:	74 07                	je     800bb1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800baa:	83 c0 01             	add    $0x1,%eax
  800bad:	39 d0                	cmp    %edx,%eax
  800baf:	72 f5                	jb     800ba6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bb1:	5d                   	pop    %ebp
  800bb2:	c3                   	ret    

00800bb3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	57                   	push   %edi
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bbc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bbf:	eb 03                	jmp    800bc4 <strtol+0x11>
		s++;
  800bc1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bc4:	0f b6 0a             	movzbl (%edx),%ecx
  800bc7:	80 f9 09             	cmp    $0x9,%cl
  800bca:	74 f5                	je     800bc1 <strtol+0xe>
  800bcc:	80 f9 20             	cmp    $0x20,%cl
  800bcf:	74 f0                	je     800bc1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bd1:	80 f9 2b             	cmp    $0x2b,%cl
  800bd4:	75 0a                	jne    800be0 <strtol+0x2d>
		s++;
  800bd6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800bd9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bde:	eb 11                	jmp    800bf1 <strtol+0x3e>
  800be0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800be5:	80 f9 2d             	cmp    $0x2d,%cl
  800be8:	75 07                	jne    800bf1 <strtol+0x3e>
		s++, neg = 1;
  800bea:	8d 52 01             	lea    0x1(%edx),%edx
  800bed:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800bf6:	75 15                	jne    800c0d <strtol+0x5a>
  800bf8:	80 3a 30             	cmpb   $0x30,(%edx)
  800bfb:	75 10                	jne    800c0d <strtol+0x5a>
  800bfd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c01:	75 0a                	jne    800c0d <strtol+0x5a>
		s += 2, base = 16;
  800c03:	83 c2 02             	add    $0x2,%edx
  800c06:	b8 10 00 00 00       	mov    $0x10,%eax
  800c0b:	eb 10                	jmp    800c1d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c0d:	85 c0                	test   %eax,%eax
  800c0f:	75 0c                	jne    800c1d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c11:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c13:	80 3a 30             	cmpb   $0x30,(%edx)
  800c16:	75 05                	jne    800c1d <strtol+0x6a>
		s++, base = 8;
  800c18:	83 c2 01             	add    $0x1,%edx
  800c1b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c22:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c25:	0f b6 0a             	movzbl (%edx),%ecx
  800c28:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c2b:	89 f0                	mov    %esi,%eax
  800c2d:	3c 09                	cmp    $0x9,%al
  800c2f:	77 08                	ja     800c39 <strtol+0x86>
			dig = *s - '0';
  800c31:	0f be c9             	movsbl %cl,%ecx
  800c34:	83 e9 30             	sub    $0x30,%ecx
  800c37:	eb 20                	jmp    800c59 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c39:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c3c:	89 f0                	mov    %esi,%eax
  800c3e:	3c 19                	cmp    $0x19,%al
  800c40:	77 08                	ja     800c4a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c42:	0f be c9             	movsbl %cl,%ecx
  800c45:	83 e9 57             	sub    $0x57,%ecx
  800c48:	eb 0f                	jmp    800c59 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c4a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c4d:	89 f0                	mov    %esi,%eax
  800c4f:	3c 19                	cmp    $0x19,%al
  800c51:	77 16                	ja     800c69 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c53:	0f be c9             	movsbl %cl,%ecx
  800c56:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c59:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c5c:	7d 0f                	jge    800c6d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c5e:	83 c2 01             	add    $0x1,%edx
  800c61:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c65:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c67:	eb bc                	jmp    800c25 <strtol+0x72>
  800c69:	89 d8                	mov    %ebx,%eax
  800c6b:	eb 02                	jmp    800c6f <strtol+0xbc>
  800c6d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c73:	74 05                	je     800c7a <strtol+0xc7>
		*endptr = (char *) s;
  800c75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c78:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c7a:	f7 d8                	neg    %eax
  800c7c:	85 ff                	test   %edi,%edi
  800c7e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5f                   	pop    %edi
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	57                   	push   %edi
  800c8a:	56                   	push   %esi
  800c8b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
  800c97:	89 c3                	mov    %eax,%ebx
  800c99:	89 c7                	mov    %eax,%edi
  800c9b:	89 c6                	mov    %eax,%esi
  800c9d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c9f:	5b                   	pop    %ebx
  800ca0:	5e                   	pop    %esi
  800ca1:	5f                   	pop    %edi
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	57                   	push   %edi
  800ca8:	56                   	push   %esi
  800ca9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800caa:	ba 00 00 00 00       	mov    $0x0,%edx
  800caf:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb4:	89 d1                	mov    %edx,%ecx
  800cb6:	89 d3                	mov    %edx,%ebx
  800cb8:	89 d7                	mov    %edx,%edi
  800cba:	89 d6                	mov    %edx,%esi
  800cbc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cbe:	5b                   	pop    %ebx
  800cbf:	5e                   	pop    %esi
  800cc0:	5f                   	pop    %edi
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd1:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	89 cb                	mov    %ecx,%ebx
  800cdb:	89 cf                	mov    %ecx,%edi
  800cdd:	89 ce                	mov    %ecx,%esi
  800cdf:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ce1:	85 c0                	test   %eax,%eax
  800ce3:	7e 28                	jle    800d0d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ce9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cf0:	00 
  800cf1:	c7 44 24 08 a7 3a 80 	movl   $0x803aa7,0x8(%esp)
  800cf8:	00 
  800cf9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d00:	00 
  800d01:	c7 04 24 c4 3a 80 00 	movl   $0x803ac4,(%esp)
  800d08:	e8 0b f5 ff ff       	call   800218 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d0d:	83 c4 2c             	add    $0x2c,%esp
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    

00800d15 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	57                   	push   %edi
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d20:	b8 02 00 00 00       	mov    $0x2,%eax
  800d25:	89 d1                	mov    %edx,%ecx
  800d27:	89 d3                	mov    %edx,%ebx
  800d29:	89 d7                	mov    %edx,%edi
  800d2b:	89 d6                	mov    %edx,%esi
  800d2d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <sys_yield>:

void
sys_yield(void)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d44:	89 d1                	mov    %edx,%ecx
  800d46:	89 d3                	mov    %edx,%ebx
  800d48:	89 d7                	mov    %edx,%edi
  800d4a:	89 d6                	mov    %edx,%esi
  800d4c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d4e:	5b                   	pop    %ebx
  800d4f:	5e                   	pop    %esi
  800d50:	5f                   	pop    %edi
  800d51:	5d                   	pop    %ebp
  800d52:	c3                   	ret    

00800d53 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
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
  800d5c:	be 00 00 00 00       	mov    $0x0,%esi
  800d61:	b8 04 00 00 00       	mov    $0x4,%eax
  800d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6f:	89 f7                	mov    %esi,%edi
  800d71:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d73:	85 c0                	test   %eax,%eax
  800d75:	7e 28                	jle    800d9f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d77:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d7b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d82:	00 
  800d83:	c7 44 24 08 a7 3a 80 	movl   $0x803aa7,0x8(%esp)
  800d8a:	00 
  800d8b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d92:	00 
  800d93:	c7 04 24 c4 3a 80 00 	movl   $0x803ac4,(%esp)
  800d9a:	e8 79 f4 ff ff       	call   800218 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d9f:	83 c4 2c             	add    $0x2c,%esp
  800da2:	5b                   	pop    %ebx
  800da3:	5e                   	pop    %esi
  800da4:	5f                   	pop    %edi
  800da5:	5d                   	pop    %ebp
  800da6:	c3                   	ret    

00800da7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	57                   	push   %edi
  800dab:	56                   	push   %esi
  800dac:	53                   	push   %ebx
  800dad:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db0:	b8 05 00 00 00       	mov    $0x5,%eax
  800db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dbe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc1:	8b 75 18             	mov    0x18(%ebp),%esi
  800dc4:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800dc6:	85 c0                	test   %eax,%eax
  800dc8:	7e 28                	jle    800df2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dca:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dce:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800dd5:	00 
  800dd6:	c7 44 24 08 a7 3a 80 	movl   $0x803aa7,0x8(%esp)
  800ddd:	00 
  800dde:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800de5:	00 
  800de6:	c7 04 24 c4 3a 80 00 	movl   $0x803ac4,(%esp)
  800ded:	e8 26 f4 ff ff       	call   800218 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800df2:	83 c4 2c             	add    $0x2c,%esp
  800df5:	5b                   	pop    %ebx
  800df6:	5e                   	pop    %esi
  800df7:	5f                   	pop    %edi
  800df8:	5d                   	pop    %ebp
  800df9:	c3                   	ret    

00800dfa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
  800dfd:	57                   	push   %edi
  800dfe:	56                   	push   %esi
  800dff:	53                   	push   %ebx
  800e00:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e08:	b8 06 00 00 00       	mov    $0x6,%eax
  800e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e10:	8b 55 08             	mov    0x8(%ebp),%edx
  800e13:	89 df                	mov    %ebx,%edi
  800e15:	89 de                	mov    %ebx,%esi
  800e17:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	7e 28                	jle    800e45 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e21:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e28:	00 
  800e29:	c7 44 24 08 a7 3a 80 	movl   $0x803aa7,0x8(%esp)
  800e30:	00 
  800e31:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e38:	00 
  800e39:	c7 04 24 c4 3a 80 00 	movl   $0x803ac4,(%esp)
  800e40:	e8 d3 f3 ff ff       	call   800218 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e45:	83 c4 2c             	add    $0x2c,%esp
  800e48:	5b                   	pop    %ebx
  800e49:	5e                   	pop    %esi
  800e4a:	5f                   	pop    %edi
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    

00800e4d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	57                   	push   %edi
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
  800e53:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e56:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e63:	8b 55 08             	mov    0x8(%ebp),%edx
  800e66:	89 df                	mov    %ebx,%edi
  800e68:	89 de                	mov    %ebx,%esi
  800e6a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	7e 28                	jle    800e98 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e70:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e74:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e7b:	00 
  800e7c:	c7 44 24 08 a7 3a 80 	movl   $0x803aa7,0x8(%esp)
  800e83:	00 
  800e84:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8b:	00 
  800e8c:	c7 04 24 c4 3a 80 00 	movl   $0x803ac4,(%esp)
  800e93:	e8 80 f3 ff ff       	call   800218 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e98:	83 c4 2c             	add    $0x2c,%esp
  800e9b:	5b                   	pop    %ebx
  800e9c:	5e                   	pop    %esi
  800e9d:	5f                   	pop    %edi
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    

00800ea0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	57                   	push   %edi
  800ea4:	56                   	push   %esi
  800ea5:	53                   	push   %ebx
  800ea6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eae:	b8 09 00 00 00       	mov    $0x9,%eax
  800eb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb9:	89 df                	mov    %ebx,%edi
  800ebb:	89 de                	mov    %ebx,%esi
  800ebd:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7e 28                	jle    800eeb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ece:	00 
  800ecf:	c7 44 24 08 a7 3a 80 	movl   $0x803aa7,0x8(%esp)
  800ed6:	00 
  800ed7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ede:	00 
  800edf:	c7 04 24 c4 3a 80 00 	movl   $0x803ac4,(%esp)
  800ee6:	e8 2d f3 ff ff       	call   800218 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eeb:	83 c4 2c             	add    $0x2c,%esp
  800eee:	5b                   	pop    %ebx
  800eef:	5e                   	pop    %esi
  800ef0:	5f                   	pop    %edi
  800ef1:	5d                   	pop    %ebp
  800ef2:	c3                   	ret    

00800ef3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	57                   	push   %edi
  800ef7:	56                   	push   %esi
  800ef8:	53                   	push   %ebx
  800ef9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f01:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	89 df                	mov    %ebx,%edi
  800f0e:	89 de                	mov    %ebx,%esi
  800f10:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f12:	85 c0                	test   %eax,%eax
  800f14:	7e 28                	jle    800f3e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f16:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f1a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f21:	00 
  800f22:	c7 44 24 08 a7 3a 80 	movl   $0x803aa7,0x8(%esp)
  800f29:	00 
  800f2a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f31:	00 
  800f32:	c7 04 24 c4 3a 80 00 	movl   $0x803ac4,(%esp)
  800f39:	e8 da f2 ff ff       	call   800218 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f3e:	83 c4 2c             	add    $0x2c,%esp
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4c:	be 00 00 00 00       	mov    $0x0,%esi
  800f51:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f59:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f62:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    

00800f69 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f69:	55                   	push   %ebp
  800f6a:	89 e5                	mov    %esp,%ebp
  800f6c:	57                   	push   %edi
  800f6d:	56                   	push   %esi
  800f6e:	53                   	push   %ebx
  800f6f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f77:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7f:	89 cb                	mov    %ecx,%ebx
  800f81:	89 cf                	mov    %ecx,%edi
  800f83:	89 ce                	mov    %ecx,%esi
  800f85:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f87:	85 c0                	test   %eax,%eax
  800f89:	7e 28                	jle    800fb3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f96:	00 
  800f97:	c7 44 24 08 a7 3a 80 	movl   $0x803aa7,0x8(%esp)
  800f9e:	00 
  800f9f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa6:	00 
  800fa7:	c7 04 24 c4 3a 80 00 	movl   $0x803ac4,(%esp)
  800fae:	e8 65 f2 ff ff       	call   800218 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fb3:	83 c4 2c             	add    $0x2c,%esp
  800fb6:	5b                   	pop    %ebx
  800fb7:	5e                   	pop    %esi
  800fb8:	5f                   	pop    %edi
  800fb9:	5d                   	pop    %ebp
  800fba:	c3                   	ret    

00800fbb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	57                   	push   %edi
  800fbf:	56                   	push   %esi
  800fc0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fcb:	89 d1                	mov    %edx,%ecx
  800fcd:	89 d3                	mov    %edx,%ebx
  800fcf:	89 d7                	mov    %edx,%edi
  800fd1:	89 d6                	mov    %edx,%esi
  800fd3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fd5:	5b                   	pop    %ebx
  800fd6:	5e                   	pop    %esi
  800fd7:	5f                   	pop    %edi
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	57                   	push   %edi
  800fde:	56                   	push   %esi
  800fdf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe5:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff0:	89 df                	mov    %ebx,%edi
  800ff2:	89 de                	mov    %ebx,%esi
  800ff4:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800ff6:	5b                   	pop    %ebx
  800ff7:	5e                   	pop    %esi
  800ff8:	5f                   	pop    %edi
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    

00800ffb <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	57                   	push   %edi
  800fff:	56                   	push   %esi
  801000:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801001:	bb 00 00 00 00       	mov    $0x0,%ebx
  801006:	b8 10 00 00 00       	mov    $0x10,%eax
  80100b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80100e:	8b 55 08             	mov    0x8(%ebp),%edx
  801011:	89 df                	mov    %ebx,%edi
  801013:	89 de                	mov    %ebx,%esi
  801015:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  801017:	5b                   	pop    %ebx
  801018:	5e                   	pop    %esi
  801019:	5f                   	pop    %edi
  80101a:	5d                   	pop    %ebp
  80101b:	c3                   	ret    

0080101c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	57                   	push   %edi
  801020:	56                   	push   %esi
  801021:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801022:	b9 00 00 00 00       	mov    $0x0,%ecx
  801027:	b8 11 00 00 00       	mov    $0x11,%eax
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	89 cb                	mov    %ecx,%ebx
  801031:	89 cf                	mov    %ecx,%edi
  801033:	89 ce                	mov    %ecx,%esi
  801035:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801037:	5b                   	pop    %ebx
  801038:	5e                   	pop    %esi
  801039:	5f                   	pop    %edi
  80103a:	5d                   	pop    %ebp
  80103b:	c3                   	ret    

0080103c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	57                   	push   %edi
  801040:	56                   	push   %esi
  801041:	53                   	push   %ebx
  801042:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801045:	be 00 00 00 00       	mov    $0x0,%esi
  80104a:	b8 12 00 00 00       	mov    $0x12,%eax
  80104f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801052:	8b 55 08             	mov    0x8(%ebp),%edx
  801055:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801058:	8b 7d 14             	mov    0x14(%ebp),%edi
  80105b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80105d:	85 c0                	test   %eax,%eax
  80105f:	7e 28                	jle    801089 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801061:	89 44 24 10          	mov    %eax,0x10(%esp)
  801065:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80106c:	00 
  80106d:	c7 44 24 08 a7 3a 80 	movl   $0x803aa7,0x8(%esp)
  801074:	00 
  801075:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80107c:	00 
  80107d:	c7 04 24 c4 3a 80 00 	movl   $0x803ac4,(%esp)
  801084:	e8 8f f1 ff ff       	call   800218 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801089:	83 c4 2c             	add    $0x2c,%esp
  80108c:	5b                   	pop    %ebx
  80108d:	5e                   	pop    %esi
  80108e:	5f                   	pop    %edi
  80108f:	5d                   	pop    %ebp
  801090:	c3                   	ret    

00801091 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801091:	55                   	push   %ebp
  801092:	89 e5                	mov    %esp,%ebp
  801094:	53                   	push   %ebx
  801095:	83 ec 24             	sub    $0x24,%esp
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80109b:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0)
  80109d:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8010a1:	75 20                	jne    8010c3 <pgfault+0x32>
		panic("pgfault: faulting address [%08x] not a write\n", addr);
  8010a3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010a7:	c7 44 24 08 d4 3a 80 	movl   $0x803ad4,0x8(%esp)
  8010ae:	00 
  8010af:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8010b6:	00 
  8010b7:	c7 04 24 54 3b 80 00 	movl   $0x803b54,(%esp)
  8010be:	e8 55 f1 ff ff       	call   800218 <_panic>

	void *page_aligned_addr = (void *) ROUNDDOWN(addr, PGSIZE);
  8010c3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t page_num = (uint32_t) page_aligned_addr / PGSIZE;
  8010c9:	89 d8                	mov    %ebx,%eax
  8010cb:	c1 e8 0c             	shr    $0xc,%eax
	if (!(uvpt[page_num] & PTE_COW))
  8010ce:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010d5:	f6 c4 08             	test   $0x8,%ah
  8010d8:	75 1c                	jne    8010f6 <pgfault+0x65>
		panic("pgfault: fault was not on a copy-on-write page\n");
  8010da:	c7 44 24 08 04 3b 80 	movl   $0x803b04,0x8(%esp)
  8010e1:	00 
  8010e2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e9:	00 
  8010ea:	c7 04 24 54 3b 80 00 	movl   $0x803b54,(%esp)
  8010f1:	e8 22 f1 ff ff       	call   800218 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	// Allocate
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8010f6:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8010fd:	00 
  8010fe:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801105:	00 
  801106:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80110d:	e8 41 fc ff ff       	call   800d53 <sys_page_alloc>
  801112:	85 c0                	test   %eax,%eax
  801114:	79 20                	jns    801136 <pgfault+0xa5>
		panic("sys_page_alloc: %e\n", r);
  801116:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80111a:	c7 44 24 08 5f 3b 80 	movl   $0x803b5f,0x8(%esp)
  801121:	00 
  801122:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  801129:	00 
  80112a:	c7 04 24 54 3b 80 00 	movl   $0x803b54,(%esp)
  801131:	e8 e2 f0 ff ff       	call   800218 <_panic>

	// Copy over
	void *src_addr = (void *) ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, src_addr, PGSIZE);
  801136:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80113d:	00 
  80113e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801142:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801149:	e8 86 f9 ff ff       	call   800ad4 <memmove>

	// Remap
	if ((r = sys_page_map(0, PFTEMP, 0, src_addr, PTE_P | PTE_U | PTE_W)) < 0)
  80114e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801155:	00 
  801156:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80115a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801161:	00 
  801162:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801169:	00 
  80116a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801171:	e8 31 fc ff ff       	call   800da7 <sys_page_map>
  801176:	85 c0                	test   %eax,%eax
  801178:	79 20                	jns    80119a <pgfault+0x109>
		panic("sys_page_map: %e\n", r);
  80117a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80117e:	c7 44 24 08 73 3b 80 	movl   $0x803b73,0x8(%esp)
  801185:	00 
  801186:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  80118d:	00 
  80118e:	c7 04 24 54 3b 80 00 	movl   $0x803b54,(%esp)
  801195:	e8 7e f0 ff ff       	call   800218 <_panic>

	//panic("pgfault not implemented");
}
  80119a:	83 c4 24             	add    $0x24,%esp
  80119d:	5b                   	pop    %ebx
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    

008011a0 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	57                   	push   %edi
  8011a4:	56                   	push   %esi
  8011a5:	53                   	push   %ebx
  8011a6:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	int r;
	envid_t child_envid;

	set_pgfault_handler(pgfault);
  8011a9:	c7 04 24 91 10 80 00 	movl   $0x801091,(%esp)
  8011b0:	e8 61 20 00 00       	call   803216 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8011b5:	b8 07 00 00 00       	mov    $0x7,%eax
  8011ba:	cd 30                	int    $0x30
  8011bc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8011bf:	89 45 e0             	mov    %eax,-0x20(%ebp)

	child_envid = sys_exofork();
	if (child_envid < 0)
  8011c2:	85 c0                	test   %eax,%eax
  8011c4:	79 20                	jns    8011e6 <fork+0x46>
		panic("sys_exofork: %e\n", child_envid);
  8011c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011ca:	c7 44 24 08 85 3b 80 	movl   $0x803b85,0x8(%esp)
  8011d1:	00 
  8011d2:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  8011d9:	00 
  8011da:	c7 04 24 54 3b 80 00 	movl   $0x803b54,(%esp)
  8011e1:	e8 32 f0 ff ff       	call   800218 <_panic>
	if (child_envid == 0) { // child
  8011e6:	bf 00 00 00 00       	mov    $0x0,%edi
  8011eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8011f4:	75 21                	jne    801217 <fork+0x77>
		// Fix thisenv like dumbfork does and return 0
		thisenv = &envs[ENVX(sys_getenvid())];
  8011f6:	e8 1a fb ff ff       	call   800d15 <sys_getenvid>
  8011fb:	25 ff 03 00 00       	and    $0x3ff,%eax
  801200:	c1 e0 07             	shl    $0x7,%eax
  801203:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801208:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80120d:	b8 00 00 00 00       	mov    $0x0,%eax
  801212:	e9 53 02 00 00       	jmp    80146a <fork+0x2ca>
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
  801217:	89 d8                	mov    %ebx,%eax
  801219:	c1 e8 0a             	shr    $0xa,%eax
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  80121c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801223:	a8 01                	test   $0x1,%al
  801225:	0f 84 7a 01 00 00    	je     8013a5 <fork+0x205>
			((uvpt[page_num] & PTE_P) == PTE_P)) {
  80122b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  801232:	a8 01                	test   $0x1,%al
  801234:	0f 84 6b 01 00 00    	je     8013a5 <fork+0x205>
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
	envid_t this_envid = thisenv->env_id;
  80123a:	a1 08 50 80 00       	mov    0x805008,%eax
  80123f:	8b 40 48             	mov    0x48(%eax),%eax
  801242:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 4: Your code here.
	if (uvpt[pn] & PTE_SHARE) {
  801245:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80124c:	f6 c4 04             	test   $0x4,%ah
  80124f:	74 52                	je     8012a3 <fork+0x103>
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801251:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801258:	25 07 0e 00 00       	and    $0xe07,%eax
  80125d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801261:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801265:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801268:	89 44 24 08          	mov    %eax,0x8(%esp)
  80126c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801273:	89 04 24             	mov    %eax,(%esp)
  801276:	e8 2c fb ff ff       	call   800da7 <sys_page_map>
  80127b:	85 c0                	test   %eax,%eax
  80127d:	0f 89 22 01 00 00    	jns    8013a5 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801283:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801287:	c7 44 24 08 73 3b 80 	movl   $0x803b73,0x8(%esp)
  80128e:	00 
  80128f:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  801296:	00 
  801297:	c7 04 24 54 3b 80 00 	movl   $0x803b54,(%esp)
  80129e:	e8 75 ef ff ff       	call   800218 <_panic>
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
  8012a3:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012aa:	f6 c4 08             	test   $0x8,%ah
  8012ad:	75 0f                	jne    8012be <fork+0x11e>
  8012af:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012b6:	a8 02                	test   $0x2,%al
  8012b8:	0f 84 99 00 00 00    	je     801357 <fork+0x1b7>
		if (uvpt[pn] & PTE_U)
  8012be:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012c5:	83 e0 04             	and    $0x4,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
  8012c8:	83 f8 01             	cmp    $0x1,%eax
  8012cb:	19 f6                	sbb    %esi,%esi
  8012cd:	83 e6 fc             	and    $0xfffffffc,%esi
  8012d0:	81 c6 05 08 00 00    	add    $0x805,%esi
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
		if (uvpt[pn] & PTE_U)
			perm |= PTE_U;

		// Map page COW, U and P in child
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), perm)) < 0)
  8012d6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8012da:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012ec:	89 04 24             	mov    %eax,(%esp)
  8012ef:	e8 b3 fa ff ff       	call   800da7 <sys_page_map>
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	79 20                	jns    801318 <fork+0x178>
			panic("sys_page_map: %e\n", r);
  8012f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012fc:	c7 44 24 08 73 3b 80 	movl   $0x803b73,0x8(%esp)
  801303:	00 
  801304:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80130b:	00 
  80130c:	c7 04 24 54 3b 80 00 	movl   $0x803b54,(%esp)
  801313:	e8 00 ef ff ff       	call   800218 <_panic>

		// Map page COW, U and P in parent
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), this_envid, (void *) (pn*PGSIZE), perm)) < 0)
  801318:	89 74 24 10          	mov    %esi,0x10(%esp)
  80131c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801320:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801323:	89 44 24 08          	mov    %eax,0x8(%esp)
  801327:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80132b:	89 04 24             	mov    %eax,(%esp)
  80132e:	e8 74 fa ff ff       	call   800da7 <sys_page_map>
  801333:	85 c0                	test   %eax,%eax
  801335:	79 6e                	jns    8013a5 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801337:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80133b:	c7 44 24 08 73 3b 80 	movl   $0x803b73,0x8(%esp)
  801342:	00 
  801343:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  80134a:	00 
  80134b:	c7 04 24 54 3b 80 00 	movl   $0x803b54,(%esp)
  801352:	e8 c1 ee ff ff       	call   800218 <_panic>

	} else { // map pages that are present but not writable or COW with their original permissions
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801357:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80135e:	25 07 0e 00 00       	and    $0xe07,%eax
  801363:	89 44 24 10          	mov    %eax,0x10(%esp)
  801367:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80136b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801372:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801379:	89 04 24             	mov    %eax,(%esp)
  80137c:	e8 26 fa ff ff       	call   800da7 <sys_page_map>
  801381:	85 c0                	test   %eax,%eax
  801383:	79 20                	jns    8013a5 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801385:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801389:	c7 44 24 08 73 3b 80 	movl   $0x803b73,0x8(%esp)
  801390:	00 
  801391:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  801398:	00 
  801399:	c7 04 24 54 3b 80 00 	movl   $0x803b54,(%esp)
  8013a0:	e8 73 ee ff ff       	call   800218 <_panic>
	// and let duppage worry about the permissions.
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
  8013a5:	83 c3 01             	add    $0x1,%ebx
  8013a8:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8013ae:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  8013b4:	0f 85 5d fe ff ff    	jne    801217 <fork+0x77>
	}

	// Allocate exception stack space for child. The child can't do this themselves
	// because the mechanism by which it would is to run the pgfault handler, which
	// needs to run on the exception stack (catch 22).
	if ((r = sys_page_alloc(child_envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8013ba:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013c1:	00 
  8013c2:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8013c9:	ee 
  8013ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013cd:	89 04 24             	mov    %eax,(%esp)
  8013d0:	e8 7e f9 ff ff       	call   800d53 <sys_page_alloc>
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	79 20                	jns    8013f9 <fork+0x259>
		panic("sys_page_alloc: %e\n", r);
  8013d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013dd:	c7 44 24 08 5f 3b 80 	movl   $0x803b5f,0x8(%esp)
  8013e4:	00 
  8013e5:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  8013ec:	00 
  8013ed:	c7 04 24 54 3b 80 00 	movl   $0x803b54,(%esp)
  8013f4:	e8 1f ee ff ff       	call   800218 <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  8013f9:	c7 44 24 04 97 32 80 	movl   $0x803297,0x4(%esp)
  801400:	00 
  801401:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801404:	89 04 24             	mov    %eax,(%esp)
  801407:	e8 e7 fa ff ff       	call   800ef3 <sys_env_set_pgfault_upcall>
  80140c:	85 c0                	test   %eax,%eax
  80140e:	79 20                	jns    801430 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801410:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801414:	c7 44 24 08 34 3b 80 	movl   $0x803b34,0x8(%esp)
  80141b:	00 
  80141c:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801423:	00 
  801424:	c7 04 24 54 3b 80 00 	movl   $0x803b54,(%esp)
  80142b:	e8 e8 ed ff ff       	call   800218 <_panic>

	// Mark child environment as runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801430:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801437:	00 
  801438:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80143b:	89 04 24             	mov    %eax,(%esp)
  80143e:	e8 0a fa ff ff       	call   800e4d <sys_env_set_status>
  801443:	85 c0                	test   %eax,%eax
  801445:	79 20                	jns    801467 <fork+0x2c7>
		panic("sys_env_set_status: %e\n", r);
  801447:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80144b:	c7 44 24 08 96 3b 80 	movl   $0x803b96,0x8(%esp)
  801452:	00 
  801453:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80145a:	00 
  80145b:	c7 04 24 54 3b 80 00 	movl   $0x803b54,(%esp)
  801462:	e8 b1 ed ff ff       	call   800218 <_panic>

	return child_envid;
  801467:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  80146a:	83 c4 2c             	add    $0x2c,%esp
  80146d:	5b                   	pop    %ebx
  80146e:	5e                   	pop    %esi
  80146f:	5f                   	pop    %edi
  801470:	5d                   	pop    %ebp
  801471:	c3                   	ret    

00801472 <sfork>:

// Challenge!
int
sfork(void)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	83 ec 18             	sub    $0x18,%esp
//	return __fork(1);
	panic("sfork not implemented");
  801478:	c7 44 24 08 ae 3b 80 	movl   $0x803bae,0x8(%esp)
  80147f:	00 
  801480:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  801487:	00 
  801488:	c7 04 24 54 3b 80 00 	movl   $0x803b54,(%esp)
  80148f:	e8 84 ed ff ff       	call   800218 <_panic>
  801494:	66 90                	xchg   %ax,%ax
  801496:	66 90                	xchg   %ax,%ax
  801498:	66 90                	xchg   %ax,%ax
  80149a:	66 90                	xchg   %ax,%ax
  80149c:	66 90                	xchg   %ax,%ax
  80149e:	66 90                	xchg   %ax,%ax

008014a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8014ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8014ae:	5d                   	pop    %ebp
  8014af:	c3                   	ret    

008014b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8014bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014c5:	5d                   	pop    %ebp
  8014c6:	c3                   	ret    

008014c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014d2:	89 c2                	mov    %eax,%edx
  8014d4:	c1 ea 16             	shr    $0x16,%edx
  8014d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014de:	f6 c2 01             	test   $0x1,%dl
  8014e1:	74 11                	je     8014f4 <fd_alloc+0x2d>
  8014e3:	89 c2                	mov    %eax,%edx
  8014e5:	c1 ea 0c             	shr    $0xc,%edx
  8014e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014ef:	f6 c2 01             	test   $0x1,%dl
  8014f2:	75 09                	jne    8014fd <fd_alloc+0x36>
			*fd_store = fd;
  8014f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fb:	eb 17                	jmp    801514 <fd_alloc+0x4d>
  8014fd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801502:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801507:	75 c9                	jne    8014d2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801509:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80150f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801514:	5d                   	pop    %ebp
  801515:	c3                   	ret    

00801516 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80151c:	83 f8 1f             	cmp    $0x1f,%eax
  80151f:	77 36                	ja     801557 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801521:	c1 e0 0c             	shl    $0xc,%eax
  801524:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801529:	89 c2                	mov    %eax,%edx
  80152b:	c1 ea 16             	shr    $0x16,%edx
  80152e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801535:	f6 c2 01             	test   $0x1,%dl
  801538:	74 24                	je     80155e <fd_lookup+0x48>
  80153a:	89 c2                	mov    %eax,%edx
  80153c:	c1 ea 0c             	shr    $0xc,%edx
  80153f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801546:	f6 c2 01             	test   $0x1,%dl
  801549:	74 1a                	je     801565 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80154b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154e:	89 02                	mov    %eax,(%edx)
	return 0;
  801550:	b8 00 00 00 00       	mov    $0x0,%eax
  801555:	eb 13                	jmp    80156a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801557:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80155c:	eb 0c                	jmp    80156a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80155e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801563:	eb 05                	jmp    80156a <fd_lookup+0x54>
  801565:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80156a:	5d                   	pop    %ebp
  80156b:	c3                   	ret    

0080156c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	83 ec 18             	sub    $0x18,%esp
  801572:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801575:	ba 00 00 00 00       	mov    $0x0,%edx
  80157a:	eb 13                	jmp    80158f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80157c:	39 08                	cmp    %ecx,(%eax)
  80157e:	75 0c                	jne    80158c <dev_lookup+0x20>
			*dev = devtab[i];
  801580:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801583:	89 01                	mov    %eax,(%ecx)
			return 0;
  801585:	b8 00 00 00 00       	mov    $0x0,%eax
  80158a:	eb 38                	jmp    8015c4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80158c:	83 c2 01             	add    $0x1,%edx
  80158f:	8b 04 95 40 3c 80 00 	mov    0x803c40(,%edx,4),%eax
  801596:	85 c0                	test   %eax,%eax
  801598:	75 e2                	jne    80157c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80159a:	a1 08 50 80 00       	mov    0x805008,%eax
  80159f:	8b 40 48             	mov    0x48(%eax),%eax
  8015a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015aa:	c7 04 24 c4 3b 80 00 	movl   $0x803bc4,(%esp)
  8015b1:	e8 5b ed ff ff       	call   800311 <cprintf>
	*dev = 0;
  8015b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8015bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	56                   	push   %esi
  8015ca:	53                   	push   %ebx
  8015cb:	83 ec 20             	sub    $0x20,%esp
  8015ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8015d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015e1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015e4:	89 04 24             	mov    %eax,(%esp)
  8015e7:	e8 2a ff ff ff       	call   801516 <fd_lookup>
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	78 05                	js     8015f5 <fd_close+0x2f>
	    || fd != fd2)
  8015f0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8015f3:	74 0c                	je     801601 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8015f5:	84 db                	test   %bl,%bl
  8015f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fc:	0f 44 c2             	cmove  %edx,%eax
  8015ff:	eb 3f                	jmp    801640 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801601:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801604:	89 44 24 04          	mov    %eax,0x4(%esp)
  801608:	8b 06                	mov    (%esi),%eax
  80160a:	89 04 24             	mov    %eax,(%esp)
  80160d:	e8 5a ff ff ff       	call   80156c <dev_lookup>
  801612:	89 c3                	mov    %eax,%ebx
  801614:	85 c0                	test   %eax,%eax
  801616:	78 16                	js     80162e <fd_close+0x68>
		if (dev->dev_close)
  801618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80161e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801623:	85 c0                	test   %eax,%eax
  801625:	74 07                	je     80162e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801627:	89 34 24             	mov    %esi,(%esp)
  80162a:	ff d0                	call   *%eax
  80162c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80162e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801632:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801639:	e8 bc f7 ff ff       	call   800dfa <sys_page_unmap>
	return r;
  80163e:	89 d8                	mov    %ebx,%eax
}
  801640:	83 c4 20             	add    $0x20,%esp
  801643:	5b                   	pop    %ebx
  801644:	5e                   	pop    %esi
  801645:	5d                   	pop    %ebp
  801646:	c3                   	ret    

00801647 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80164d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801650:	89 44 24 04          	mov    %eax,0x4(%esp)
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	89 04 24             	mov    %eax,(%esp)
  80165a:	e8 b7 fe ff ff       	call   801516 <fd_lookup>
  80165f:	89 c2                	mov    %eax,%edx
  801661:	85 d2                	test   %edx,%edx
  801663:	78 13                	js     801678 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801665:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80166c:	00 
  80166d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801670:	89 04 24             	mov    %eax,(%esp)
  801673:	e8 4e ff ff ff       	call   8015c6 <fd_close>
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <close_all>:

void
close_all(void)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	53                   	push   %ebx
  80167e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801681:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801686:	89 1c 24             	mov    %ebx,(%esp)
  801689:	e8 b9 ff ff ff       	call   801647 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80168e:	83 c3 01             	add    $0x1,%ebx
  801691:	83 fb 20             	cmp    $0x20,%ebx
  801694:	75 f0                	jne    801686 <close_all+0xc>
		close(i);
}
  801696:	83 c4 14             	add    $0x14,%esp
  801699:	5b                   	pop    %ebx
  80169a:	5d                   	pop    %ebp
  80169b:	c3                   	ret    

0080169c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	57                   	push   %edi
  8016a0:	56                   	push   %esi
  8016a1:	53                   	push   %ebx
  8016a2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	89 04 24             	mov    %eax,(%esp)
  8016b2:	e8 5f fe ff ff       	call   801516 <fd_lookup>
  8016b7:	89 c2                	mov    %eax,%edx
  8016b9:	85 d2                	test   %edx,%edx
  8016bb:	0f 88 e1 00 00 00    	js     8017a2 <dup+0x106>
		return r;
	close(newfdnum);
  8016c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c4:	89 04 24             	mov    %eax,(%esp)
  8016c7:	e8 7b ff ff ff       	call   801647 <close>

	newfd = INDEX2FD(newfdnum);
  8016cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016cf:	c1 e3 0c             	shl    $0xc,%ebx
  8016d2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8016d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016db:	89 04 24             	mov    %eax,(%esp)
  8016de:	e8 cd fd ff ff       	call   8014b0 <fd2data>
  8016e3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8016e5:	89 1c 24             	mov    %ebx,(%esp)
  8016e8:	e8 c3 fd ff ff       	call   8014b0 <fd2data>
  8016ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016ef:	89 f0                	mov    %esi,%eax
  8016f1:	c1 e8 16             	shr    $0x16,%eax
  8016f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016fb:	a8 01                	test   $0x1,%al
  8016fd:	74 43                	je     801742 <dup+0xa6>
  8016ff:	89 f0                	mov    %esi,%eax
  801701:	c1 e8 0c             	shr    $0xc,%eax
  801704:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80170b:	f6 c2 01             	test   $0x1,%dl
  80170e:	74 32                	je     801742 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801710:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801717:	25 07 0e 00 00       	and    $0xe07,%eax
  80171c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801720:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801724:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80172b:	00 
  80172c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801730:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801737:	e8 6b f6 ff ff       	call   800da7 <sys_page_map>
  80173c:	89 c6                	mov    %eax,%esi
  80173e:	85 c0                	test   %eax,%eax
  801740:	78 3e                	js     801780 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801742:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801745:	89 c2                	mov    %eax,%edx
  801747:	c1 ea 0c             	shr    $0xc,%edx
  80174a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801751:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801757:	89 54 24 10          	mov    %edx,0x10(%esp)
  80175b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80175f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801766:	00 
  801767:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801772:	e8 30 f6 ff ff       	call   800da7 <sys_page_map>
  801777:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801779:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80177c:	85 f6                	test   %esi,%esi
  80177e:	79 22                	jns    8017a2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801780:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801784:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80178b:	e8 6a f6 ff ff       	call   800dfa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801790:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801794:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80179b:	e8 5a f6 ff ff       	call   800dfa <sys_page_unmap>
	return r;
  8017a0:	89 f0                	mov    %esi,%eax
}
  8017a2:	83 c4 3c             	add    $0x3c,%esp
  8017a5:	5b                   	pop    %ebx
  8017a6:	5e                   	pop    %esi
  8017a7:	5f                   	pop    %edi
  8017a8:	5d                   	pop    %ebp
  8017a9:	c3                   	ret    

008017aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017aa:	55                   	push   %ebp
  8017ab:	89 e5                	mov    %esp,%ebp
  8017ad:	53                   	push   %ebx
  8017ae:	83 ec 24             	sub    $0x24,%esp
  8017b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bb:	89 1c 24             	mov    %ebx,(%esp)
  8017be:	e8 53 fd ff ff       	call   801516 <fd_lookup>
  8017c3:	89 c2                	mov    %eax,%edx
  8017c5:	85 d2                	test   %edx,%edx
  8017c7:	78 6d                	js     801836 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d3:	8b 00                	mov    (%eax),%eax
  8017d5:	89 04 24             	mov    %eax,(%esp)
  8017d8:	e8 8f fd ff ff       	call   80156c <dev_lookup>
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	78 55                	js     801836 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e4:	8b 50 08             	mov    0x8(%eax),%edx
  8017e7:	83 e2 03             	and    $0x3,%edx
  8017ea:	83 fa 01             	cmp    $0x1,%edx
  8017ed:	75 23                	jne    801812 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017ef:	a1 08 50 80 00       	mov    0x805008,%eax
  8017f4:	8b 40 48             	mov    0x48(%eax),%eax
  8017f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ff:	c7 04 24 05 3c 80 00 	movl   $0x803c05,(%esp)
  801806:	e8 06 eb ff ff       	call   800311 <cprintf>
		return -E_INVAL;
  80180b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801810:	eb 24                	jmp    801836 <read+0x8c>
	}
	if (!dev->dev_read)
  801812:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801815:	8b 52 08             	mov    0x8(%edx),%edx
  801818:	85 d2                	test   %edx,%edx
  80181a:	74 15                	je     801831 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80181c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80181f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801823:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801826:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80182a:	89 04 24             	mov    %eax,(%esp)
  80182d:	ff d2                	call   *%edx
  80182f:	eb 05                	jmp    801836 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801831:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801836:	83 c4 24             	add    $0x24,%esp
  801839:	5b                   	pop    %ebx
  80183a:	5d                   	pop    %ebp
  80183b:	c3                   	ret    

0080183c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	57                   	push   %edi
  801840:	56                   	push   %esi
  801841:	53                   	push   %ebx
  801842:	83 ec 1c             	sub    $0x1c,%esp
  801845:	8b 7d 08             	mov    0x8(%ebp),%edi
  801848:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80184b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801850:	eb 23                	jmp    801875 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801852:	89 f0                	mov    %esi,%eax
  801854:	29 d8                	sub    %ebx,%eax
  801856:	89 44 24 08          	mov    %eax,0x8(%esp)
  80185a:	89 d8                	mov    %ebx,%eax
  80185c:	03 45 0c             	add    0xc(%ebp),%eax
  80185f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801863:	89 3c 24             	mov    %edi,(%esp)
  801866:	e8 3f ff ff ff       	call   8017aa <read>
		if (m < 0)
  80186b:	85 c0                	test   %eax,%eax
  80186d:	78 10                	js     80187f <readn+0x43>
			return m;
		if (m == 0)
  80186f:	85 c0                	test   %eax,%eax
  801871:	74 0a                	je     80187d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801873:	01 c3                	add    %eax,%ebx
  801875:	39 f3                	cmp    %esi,%ebx
  801877:	72 d9                	jb     801852 <readn+0x16>
  801879:	89 d8                	mov    %ebx,%eax
  80187b:	eb 02                	jmp    80187f <readn+0x43>
  80187d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80187f:	83 c4 1c             	add    $0x1c,%esp
  801882:	5b                   	pop    %ebx
  801883:	5e                   	pop    %esi
  801884:	5f                   	pop    %edi
  801885:	5d                   	pop    %ebp
  801886:	c3                   	ret    

00801887 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	53                   	push   %ebx
  80188b:	83 ec 24             	sub    $0x24,%esp
  80188e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801891:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801894:	89 44 24 04          	mov    %eax,0x4(%esp)
  801898:	89 1c 24             	mov    %ebx,(%esp)
  80189b:	e8 76 fc ff ff       	call   801516 <fd_lookup>
  8018a0:	89 c2                	mov    %eax,%edx
  8018a2:	85 d2                	test   %edx,%edx
  8018a4:	78 68                	js     80190e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b0:	8b 00                	mov    (%eax),%eax
  8018b2:	89 04 24             	mov    %eax,(%esp)
  8018b5:	e8 b2 fc ff ff       	call   80156c <dev_lookup>
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	78 50                	js     80190e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018c5:	75 23                	jne    8018ea <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018c7:	a1 08 50 80 00       	mov    0x805008,%eax
  8018cc:	8b 40 48             	mov    0x48(%eax),%eax
  8018cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d7:	c7 04 24 21 3c 80 00 	movl   $0x803c21,(%esp)
  8018de:	e8 2e ea ff ff       	call   800311 <cprintf>
		return -E_INVAL;
  8018e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018e8:	eb 24                	jmp    80190e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8018f0:	85 d2                	test   %edx,%edx
  8018f2:	74 15                	je     801909 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801902:	89 04 24             	mov    %eax,(%esp)
  801905:	ff d2                	call   *%edx
  801907:	eb 05                	jmp    80190e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801909:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80190e:	83 c4 24             	add    $0x24,%esp
  801911:	5b                   	pop    %ebx
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    

00801914 <seek>:

int
seek(int fdnum, off_t offset)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80191a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80191d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	89 04 24             	mov    %eax,(%esp)
  801927:	e8 ea fb ff ff       	call   801516 <fd_lookup>
  80192c:	85 c0                	test   %eax,%eax
  80192e:	78 0e                	js     80193e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801930:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801933:	8b 55 0c             	mov    0xc(%ebp),%edx
  801936:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801939:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	53                   	push   %ebx
  801944:	83 ec 24             	sub    $0x24,%esp
  801947:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80194a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80194d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801951:	89 1c 24             	mov    %ebx,(%esp)
  801954:	e8 bd fb ff ff       	call   801516 <fd_lookup>
  801959:	89 c2                	mov    %eax,%edx
  80195b:	85 d2                	test   %edx,%edx
  80195d:	78 61                	js     8019c0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80195f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801962:	89 44 24 04          	mov    %eax,0x4(%esp)
  801966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801969:	8b 00                	mov    (%eax),%eax
  80196b:	89 04 24             	mov    %eax,(%esp)
  80196e:	e8 f9 fb ff ff       	call   80156c <dev_lookup>
  801973:	85 c0                	test   %eax,%eax
  801975:	78 49                	js     8019c0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801977:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80197e:	75 23                	jne    8019a3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801980:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801985:	8b 40 48             	mov    0x48(%eax),%eax
  801988:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80198c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801990:	c7 04 24 e4 3b 80 00 	movl   $0x803be4,(%esp)
  801997:	e8 75 e9 ff ff       	call   800311 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80199c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019a1:	eb 1d                	jmp    8019c0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8019a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a6:	8b 52 18             	mov    0x18(%edx),%edx
  8019a9:	85 d2                	test   %edx,%edx
  8019ab:	74 0e                	je     8019bb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019b0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019b4:	89 04 24             	mov    %eax,(%esp)
  8019b7:	ff d2                	call   *%edx
  8019b9:	eb 05                	jmp    8019c0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8019bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8019c0:	83 c4 24             	add    $0x24,%esp
  8019c3:	5b                   	pop    %ebx
  8019c4:	5d                   	pop    %ebp
  8019c5:	c3                   	ret    

008019c6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	53                   	push   %ebx
  8019ca:	83 ec 24             	sub    $0x24,%esp
  8019cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	89 04 24             	mov    %eax,(%esp)
  8019dd:	e8 34 fb ff ff       	call   801516 <fd_lookup>
  8019e2:	89 c2                	mov    %eax,%edx
  8019e4:	85 d2                	test   %edx,%edx
  8019e6:	78 52                	js     801a3a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f2:	8b 00                	mov    (%eax),%eax
  8019f4:	89 04 24             	mov    %eax,(%esp)
  8019f7:	e8 70 fb ff ff       	call   80156c <dev_lookup>
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 3a                	js     801a3a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a03:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a07:	74 2c                	je     801a35 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a09:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a0c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a13:	00 00 00 
	stat->st_isdir = 0;
  801a16:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a1d:	00 00 00 
	stat->st_dev = dev;
  801a20:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a26:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a2d:	89 14 24             	mov    %edx,(%esp)
  801a30:	ff 50 14             	call   *0x14(%eax)
  801a33:	eb 05                	jmp    801a3a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801a35:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801a3a:	83 c4 24             	add    $0x24,%esp
  801a3d:	5b                   	pop    %ebx
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    

00801a40 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	56                   	push   %esi
  801a44:	53                   	push   %ebx
  801a45:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a48:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a4f:	00 
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	89 04 24             	mov    %eax,(%esp)
  801a56:	e8 84 02 00 00       	call   801cdf <open>
  801a5b:	89 c3                	mov    %eax,%ebx
  801a5d:	85 db                	test   %ebx,%ebx
  801a5f:	78 1b                	js     801a7c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a68:	89 1c 24             	mov    %ebx,(%esp)
  801a6b:	e8 56 ff ff ff       	call   8019c6 <fstat>
  801a70:	89 c6                	mov    %eax,%esi
	close(fd);
  801a72:	89 1c 24             	mov    %ebx,(%esp)
  801a75:	e8 cd fb ff ff       	call   801647 <close>
	return r;
  801a7a:	89 f0                	mov    %esi,%eax
}
  801a7c:	83 c4 10             	add    $0x10,%esp
  801a7f:	5b                   	pop    %ebx
  801a80:	5e                   	pop    %esi
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    

00801a83 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	56                   	push   %esi
  801a87:	53                   	push   %ebx
  801a88:	83 ec 10             	sub    $0x10,%esp
  801a8b:	89 c6                	mov    %eax,%esi
  801a8d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a8f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a96:	75 11                	jne    801aa9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a9f:	e8 11 19 00 00       	call   8033b5 <ipc_find_env>
  801aa4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801aa9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ab0:	00 
  801ab1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801ab8:	00 
  801ab9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801abd:	a1 00 50 80 00       	mov    0x805000,%eax
  801ac2:	89 04 24             	mov    %eax,(%esp)
  801ac5:	e8 5e 18 00 00       	call   803328 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801aca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ad1:	00 
  801ad2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ad6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801add:	e8 de 17 00 00       	call   8032c0 <ipc_recv>
}
  801ae2:	83 c4 10             	add    $0x10,%esp
  801ae5:	5b                   	pop    %ebx
  801ae6:	5e                   	pop    %esi
  801ae7:	5d                   	pop    %ebp
  801ae8:	c3                   	ret    

00801ae9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	8b 40 0c             	mov    0xc(%eax),%eax
  801af5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b02:	ba 00 00 00 00       	mov    $0x0,%edx
  801b07:	b8 02 00 00 00       	mov    $0x2,%eax
  801b0c:	e8 72 ff ff ff       	call   801a83 <fsipc>
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b1f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b24:	ba 00 00 00 00       	mov    $0x0,%edx
  801b29:	b8 06 00 00 00       	mov    $0x6,%eax
  801b2e:	e8 50 ff ff ff       	call   801a83 <fsipc>
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
  801b38:	53                   	push   %ebx
  801b39:	83 ec 14             	sub    $0x14,%esp
  801b3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	8b 40 0c             	mov    0xc(%eax),%eax
  801b45:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4f:	b8 05 00 00 00       	mov    $0x5,%eax
  801b54:	e8 2a ff ff ff       	call   801a83 <fsipc>
  801b59:	89 c2                	mov    %eax,%edx
  801b5b:	85 d2                	test   %edx,%edx
  801b5d:	78 2b                	js     801b8a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b5f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b66:	00 
  801b67:	89 1c 24             	mov    %ebx,(%esp)
  801b6a:	e8 c8 ed ff ff       	call   800937 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b6f:	a1 80 60 80 00       	mov    0x806080,%eax
  801b74:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b7a:	a1 84 60 80 00       	mov    0x806084,%eax
  801b7f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8a:	83 c4 14             	add    $0x14,%esp
  801b8d:	5b                   	pop    %ebx
  801b8e:	5d                   	pop    %ebp
  801b8f:	c3                   	ret    

00801b90 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	53                   	push   %ebx
  801b94:	83 ec 14             	sub    $0x14,%esp
  801b97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801ba5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801bab:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801bb0:	0f 46 c3             	cmovbe %ebx,%eax
  801bb3:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801bb8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc3:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801bca:	e8 05 ef ff ff       	call   800ad4 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801bcf:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd4:	b8 04 00 00 00       	mov    $0x4,%eax
  801bd9:	e8 a5 fe ff ff       	call   801a83 <fsipc>
  801bde:	85 c0                	test   %eax,%eax
  801be0:	78 53                	js     801c35 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801be2:	39 c3                	cmp    %eax,%ebx
  801be4:	73 24                	jae    801c0a <devfile_write+0x7a>
  801be6:	c7 44 24 0c 54 3c 80 	movl   $0x803c54,0xc(%esp)
  801bed:	00 
  801bee:	c7 44 24 08 5b 3c 80 	movl   $0x803c5b,0x8(%esp)
  801bf5:	00 
  801bf6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801bfd:	00 
  801bfe:	c7 04 24 70 3c 80 00 	movl   $0x803c70,(%esp)
  801c05:	e8 0e e6 ff ff       	call   800218 <_panic>
	assert(r <= PGSIZE);
  801c0a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c0f:	7e 24                	jle    801c35 <devfile_write+0xa5>
  801c11:	c7 44 24 0c 7b 3c 80 	movl   $0x803c7b,0xc(%esp)
  801c18:	00 
  801c19:	c7 44 24 08 5b 3c 80 	movl   $0x803c5b,0x8(%esp)
  801c20:	00 
  801c21:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801c28:	00 
  801c29:	c7 04 24 70 3c 80 00 	movl   $0x803c70,(%esp)
  801c30:	e8 e3 e5 ff ff       	call   800218 <_panic>
	return r;
}
  801c35:	83 c4 14             	add    $0x14,%esp
  801c38:	5b                   	pop    %ebx
  801c39:	5d                   	pop    %ebp
  801c3a:	c3                   	ret    

00801c3b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	56                   	push   %esi
  801c3f:	53                   	push   %ebx
  801c40:	83 ec 10             	sub    $0x10,%esp
  801c43:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	8b 40 0c             	mov    0xc(%eax),%eax
  801c4c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c51:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c57:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5c:	b8 03 00 00 00       	mov    $0x3,%eax
  801c61:	e8 1d fe ff ff       	call   801a83 <fsipc>
  801c66:	89 c3                	mov    %eax,%ebx
  801c68:	85 c0                	test   %eax,%eax
  801c6a:	78 6a                	js     801cd6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c6c:	39 c6                	cmp    %eax,%esi
  801c6e:	73 24                	jae    801c94 <devfile_read+0x59>
  801c70:	c7 44 24 0c 54 3c 80 	movl   $0x803c54,0xc(%esp)
  801c77:	00 
  801c78:	c7 44 24 08 5b 3c 80 	movl   $0x803c5b,0x8(%esp)
  801c7f:	00 
  801c80:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801c87:	00 
  801c88:	c7 04 24 70 3c 80 00 	movl   $0x803c70,(%esp)
  801c8f:	e8 84 e5 ff ff       	call   800218 <_panic>
	assert(r <= PGSIZE);
  801c94:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c99:	7e 24                	jle    801cbf <devfile_read+0x84>
  801c9b:	c7 44 24 0c 7b 3c 80 	movl   $0x803c7b,0xc(%esp)
  801ca2:	00 
  801ca3:	c7 44 24 08 5b 3c 80 	movl   $0x803c5b,0x8(%esp)
  801caa:	00 
  801cab:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801cb2:	00 
  801cb3:	c7 04 24 70 3c 80 00 	movl   $0x803c70,(%esp)
  801cba:	e8 59 e5 ff ff       	call   800218 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cbf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cc3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cca:	00 
  801ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cce:	89 04 24             	mov    %eax,(%esp)
  801cd1:	e8 fe ed ff ff       	call   800ad4 <memmove>
	return r;
}
  801cd6:	89 d8                	mov    %ebx,%eax
  801cd8:	83 c4 10             	add    $0x10,%esp
  801cdb:	5b                   	pop    %ebx
  801cdc:	5e                   	pop    %esi
  801cdd:	5d                   	pop    %ebp
  801cde:	c3                   	ret    

00801cdf <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	53                   	push   %ebx
  801ce3:	83 ec 24             	sub    $0x24,%esp
  801ce6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801ce9:	89 1c 24             	mov    %ebx,(%esp)
  801cec:	e8 0f ec ff ff       	call   800900 <strlen>
  801cf1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cf6:	7f 60                	jg     801d58 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801cf8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cfb:	89 04 24             	mov    %eax,(%esp)
  801cfe:	e8 c4 f7 ff ff       	call   8014c7 <fd_alloc>
  801d03:	89 c2                	mov    %eax,%edx
  801d05:	85 d2                	test   %edx,%edx
  801d07:	78 54                	js     801d5d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d09:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d0d:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801d14:	e8 1e ec ff ff       	call   800937 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d24:	b8 01 00 00 00       	mov    $0x1,%eax
  801d29:	e8 55 fd ff ff       	call   801a83 <fsipc>
  801d2e:	89 c3                	mov    %eax,%ebx
  801d30:	85 c0                	test   %eax,%eax
  801d32:	79 17                	jns    801d4b <open+0x6c>
		fd_close(fd, 0);
  801d34:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d3b:	00 
  801d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3f:	89 04 24             	mov    %eax,(%esp)
  801d42:	e8 7f f8 ff ff       	call   8015c6 <fd_close>
		return r;
  801d47:	89 d8                	mov    %ebx,%eax
  801d49:	eb 12                	jmp    801d5d <open+0x7e>
	}

	return fd2num(fd);
  801d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4e:	89 04 24             	mov    %eax,(%esp)
  801d51:	e8 4a f7 ff ff       	call   8014a0 <fd2num>
  801d56:	eb 05                	jmp    801d5d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801d58:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801d5d:	83 c4 24             	add    $0x24,%esp
  801d60:	5b                   	pop    %ebx
  801d61:	5d                   	pop    %ebp
  801d62:	c3                   	ret    

00801d63 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d69:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6e:	b8 08 00 00 00       	mov    $0x8,%eax
  801d73:	e8 0b fd ff ff       	call   801a83 <fsipc>
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    
  801d7a:	66 90                	xchg   %ax,%ax
  801d7c:	66 90                	xchg   %ax,%ax
  801d7e:	66 90                	xchg   %ax,%ax

00801d80 <map_segment>:
}

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	57                   	push   %edi
  801d84:	56                   	push   %esi
  801d85:	53                   	push   %ebx
  801d86:	83 ec 2c             	sub    $0x2c,%esp
  801d89:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d8c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801d8f:	89 d0                	mov    %edx,%eax
  801d91:	25 ff 0f 00 00       	and    $0xfff,%eax
  801d96:	74 0b                	je     801da3 <map_segment+0x23>
		va -= i;
  801d98:	29 c2                	sub    %eax,%edx
		memsz += i;
  801d9a:	01 45 e4             	add    %eax,-0x1c(%ebp)
		filesz += i;
  801d9d:	01 45 0c             	add    %eax,0xc(%ebp)
		fileoffset -= i;
  801da0:	29 45 10             	sub    %eax,0x10(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801da3:	89 d6                	mov    %edx,%esi
  801da5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801daa:	e9 ff 00 00 00       	jmp    801eae <map_segment+0x12e>
		if (i >= filesz) {
  801daf:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
  801db2:	77 23                	ja     801dd7 <map_segment+0x57>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801db4:	8b 45 14             	mov    0x14(%ebp),%eax
  801db7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dbb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dc2:	89 04 24             	mov    %eax,(%esp)
  801dc5:	e8 89 ef ff ff       	call   800d53 <sys_page_alloc>
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	0f 89 d0 00 00 00    	jns    801ea2 <map_segment+0x122>
  801dd2:	e9 e7 00 00 00       	jmp    801ebe <map_segment+0x13e>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801dd7:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801dde:	00 
  801ddf:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801de6:	00 
  801de7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dee:	e8 60 ef ff ff       	call   800d53 <sys_page_alloc>
  801df3:	85 c0                	test   %eax,%eax
  801df5:	0f 88 c3 00 00 00    	js     801ebe <map_segment+0x13e>
  801dfb:	89 f8                	mov    %edi,%eax
  801dfd:	03 45 10             	add    0x10(%ebp),%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801e00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	89 04 24             	mov    %eax,(%esp)
  801e0a:	e8 05 fb ff ff       	call   801914 <seek>
  801e0f:	85 c0                	test   %eax,%eax
  801e11:	0f 88 a7 00 00 00    	js     801ebe <map_segment+0x13e>
  801e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1a:	29 f8                	sub    %edi,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801e1c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e21:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801e26:	0f 47 c1             	cmova  %ecx,%eax
  801e29:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e2d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e34:	00 
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	89 04 24             	mov    %eax,(%esp)
  801e3b:	e8 fc f9 ff ff       	call   80183c <readn>
  801e40:	85 c0                	test   %eax,%eax
  801e42:	78 7a                	js     801ebe <map_segment+0x13e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801e44:	8b 45 14             	mov    0x14(%ebp),%eax
  801e47:	89 44 24 10          	mov    %eax,0x10(%esp)
  801e4b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801e4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e52:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e56:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e5d:	00 
  801e5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e65:	e8 3d ef ff ff       	call   800da7 <sys_page_map>
  801e6a:	85 c0                	test   %eax,%eax
  801e6c:	79 20                	jns    801e8e <map_segment+0x10e>
				panic("spawn: sys_page_map data: %e", r);
  801e6e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e72:	c7 44 24 08 87 3c 80 	movl   $0x803c87,0x8(%esp)
  801e79:	00 
  801e7a:	c7 44 24 04 ac 01 00 	movl   $0x1ac,0x4(%esp)
  801e81:	00 
  801e82:	c7 04 24 a4 3c 80 00 	movl   $0x803ca4,(%esp)
  801e89:	e8 8a e3 ff ff       	call   800218 <_panic>
			sys_page_unmap(0, UTEMP);
  801e8e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e95:	00 
  801e96:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e9d:	e8 58 ef ff ff       	call   800dfa <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801ea2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ea8:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801eae:	89 df                	mov    %ebx,%edi
  801eb0:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  801eb3:	0f 87 f6 fe ff ff    	ja     801daf <map_segment+0x2f>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  801eb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebe:	83 c4 2c             	add    $0x2c,%esp
  801ec1:	5b                   	pop    %ebx
  801ec2:	5e                   	pop    %esi
  801ec3:	5f                   	pop    %edi
  801ec4:	5d                   	pop    %ebp
  801ec5:	c3                   	ret    

00801ec6 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	57                   	push   %edi
  801eca:	56                   	push   %esi
  801ecb:	53                   	push   %ebx
  801ecc:	81 ec 8c 02 00 00    	sub    $0x28c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801ed2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ed9:	00 
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	89 04 24             	mov    %eax,(%esp)
  801ee0:	e8 fa fd ff ff       	call   801cdf <open>
  801ee5:	89 c1                	mov    %eax,%ecx
  801ee7:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801eed:	85 c0                	test   %eax,%eax
  801eef:	0f 88 9f 03 00 00    	js     802294 <spawn+0x3ce>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801ef5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801efc:	00 
  801efd:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801f03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f07:	89 0c 24             	mov    %ecx,(%esp)
  801f0a:	e8 2d f9 ff ff       	call   80183c <readn>
  801f0f:	3d 00 02 00 00       	cmp    $0x200,%eax
  801f14:	75 0c                	jne    801f22 <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801f16:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801f1d:	45 4c 46 
  801f20:	74 36                	je     801f58 <spawn+0x92>
		close(fd);
  801f22:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801f28:	89 04 24             	mov    %eax,(%esp)
  801f2b:	e8 17 f7 ff ff       	call   801647 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801f30:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801f37:	46 
  801f38:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801f3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f42:	c7 04 24 b0 3c 80 00 	movl   $0x803cb0,(%esp)
  801f49:	e8 c3 e3 ff ff       	call   800311 <cprintf>
		return -E_NOT_EXEC;
  801f4e:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801f53:	e9 c0 03 00 00       	jmp    802318 <spawn+0x452>
  801f58:	b8 07 00 00 00       	mov    $0x7,%eax
  801f5d:	cd 30                	int    $0x30
  801f5f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  801f65:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801f6b:	85 c0                	test   %eax,%eax
  801f6d:	0f 88 29 03 00 00    	js     80229c <spawn+0x3d6>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801f73:	89 c6                	mov    %eax,%esi
  801f75:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801f7b:	c1 e6 07             	shl    $0x7,%esi
  801f7e:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801f84:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801f8a:	b9 11 00 00 00       	mov    $0x11,%ecx
  801f8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801f91:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801f97:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801f9d:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801fa2:	be 00 00 00 00       	mov    $0x0,%esi
  801fa7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801faa:	eb 0f                	jmp    801fbb <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801fac:	89 04 24             	mov    %eax,(%esp)
  801faf:	e8 4c e9 ff ff       	call   800900 <strlen>
  801fb4:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801fb8:	83 c3 01             	add    $0x1,%ebx
  801fbb:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801fc2:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	75 e3                	jne    801fac <spawn+0xe6>
  801fc9:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
  801fcf:	89 8d 7c fd ff ff    	mov    %ecx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801fd5:	bf 00 10 40 00       	mov    $0x401000,%edi
  801fda:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801fdc:	89 fa                	mov    %edi,%edx
  801fde:	83 e2 fc             	and    $0xfffffffc,%edx
  801fe1:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801fe8:	29 c2                	sub    %eax,%edx
  801fea:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801ff0:	8d 42 f8             	lea    -0x8(%edx),%eax
  801ff3:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801ff8:	0f 86 ae 02 00 00    	jbe    8022ac <spawn+0x3e6>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ffe:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802005:	00 
  802006:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80200d:	00 
  80200e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802015:	e8 39 ed ff ff       	call   800d53 <sys_page_alloc>
  80201a:	85 c0                	test   %eax,%eax
  80201c:	0f 88 f6 02 00 00    	js     802318 <spawn+0x452>
  802022:	be 00 00 00 00       	mov    $0x0,%esi
  802027:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  80202d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802030:	eb 30                	jmp    802062 <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  802032:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802038:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  80203e:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802041:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  802044:	89 44 24 04          	mov    %eax,0x4(%esp)
  802048:	89 3c 24             	mov    %edi,(%esp)
  80204b:	e8 e7 e8 ff ff       	call   800937 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802050:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  802053:	89 04 24             	mov    %eax,(%esp)
  802056:	e8 a5 e8 ff ff       	call   800900 <strlen>
  80205b:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80205f:	83 c6 01             	add    $0x1,%esi
  802062:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  802068:	7c c8                	jl     802032 <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  80206a:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802070:	8b 8d 7c fd ff ff    	mov    -0x284(%ebp),%ecx
  802076:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80207d:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802083:	74 24                	je     8020a9 <spawn+0x1e3>
  802085:	c7 44 24 0c 28 3d 80 	movl   $0x803d28,0xc(%esp)
  80208c:	00 
  80208d:	c7 44 24 08 5b 3c 80 	movl   $0x803c5b,0x8(%esp)
  802094:	00 
  802095:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
  80209c:	00 
  80209d:	c7 04 24 a4 3c 80 00 	movl   $0x803ca4,(%esp)
  8020a4:	e8 6f e1 ff ff       	call   800218 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8020a9:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8020af:	89 c8                	mov    %ecx,%eax
  8020b1:	2d 00 30 80 11       	sub    $0x11803000,%eax
  8020b6:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8020b9:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8020bf:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8020c2:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  8020c8:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8020ce:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8020d5:	00 
  8020d6:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  8020dd:	ee 
  8020de:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8020e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020e8:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8020ef:	00 
  8020f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020f7:	e8 ab ec ff ff       	call   800da7 <sys_page_map>
  8020fc:	89 c7                	mov    %eax,%edi
  8020fe:	85 c0                	test   %eax,%eax
  802100:	0f 88 fc 01 00 00    	js     802302 <spawn+0x43c>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802106:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80210d:	00 
  80210e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802115:	e8 e0 ec ff ff       	call   800dfa <sys_page_unmap>
  80211a:	89 c7                	mov    %eax,%edi
  80211c:	85 c0                	test   %eax,%eax
  80211e:	0f 88 de 01 00 00    	js     802302 <spawn+0x43c>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802124:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80212a:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802131:	be 00 00 00 00       	mov    $0x0,%esi
  802136:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  80213c:	eb 4a                	jmp    802188 <spawn+0x2c2>
		if (ph->p_type != ELF_PROG_LOAD)
  80213e:	83 3b 01             	cmpl   $0x1,(%ebx)
  802141:	75 3f                	jne    802182 <spawn+0x2bc>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802143:	8b 43 18             	mov    0x18(%ebx),%eax
  802146:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  802149:	83 f8 01             	cmp    $0x1,%eax
  80214c:	19 c0                	sbb    %eax,%eax
  80214e:	83 e0 fe             	and    $0xfffffffe,%eax
  802151:	83 c0 07             	add    $0x7,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802154:	8b 4b 14             	mov    0x14(%ebx),%ecx
  802157:	8b 53 08             	mov    0x8(%ebx),%edx
  80215a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80215e:	8b 43 04             	mov    0x4(%ebx),%eax
  802161:	89 44 24 08          	mov    %eax,0x8(%esp)
  802165:	8b 43 10             	mov    0x10(%ebx),%eax
  802168:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216c:	89 3c 24             	mov    %edi,(%esp)
  80216f:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802175:	e8 06 fc ff ff       	call   801d80 <map_segment>
  80217a:	85 c0                	test   %eax,%eax
  80217c:	0f 88 ed 00 00 00    	js     80226f <spawn+0x3a9>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802182:	83 c6 01             	add    $0x1,%esi
  802185:	83 c3 20             	add    $0x20,%ebx
  802188:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80218f:	39 c6                	cmp    %eax,%esi
  802191:	7c ab                	jl     80213e <spawn+0x278>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802193:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802199:	89 04 24             	mov    %eax,(%esp)
  80219c:	e8 a6 f4 ff ff       	call   801647 <close>
	uint8_t *addr, *end_addr;
    int perm;
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
  8021a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8021a6:	8b b5 8c fd ff ff    	mov    -0x274(%ebp),%esi
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)) {
  8021ac:	89 d8                	mov    %ebx,%eax
  8021ae:	c1 e8 16             	shr    $0x16,%eax
  8021b1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8021b8:	a8 01                	test   $0x1,%al
  8021ba:	74 46                	je     802202 <spawn+0x33c>
  8021bc:	89 d8                	mov    %ebx,%eax
  8021be:	c1 e8 0c             	shr    $0xc,%eax
  8021c1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8021c8:	f6 c2 01             	test   $0x1,%dl
  8021cb:	74 35                	je     802202 <spawn+0x33c>
			perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  8021cd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
            if (perm & PTE_SHARE) {
  8021d4:	f6 c4 04             	test   $0x4,%ah
  8021d7:	74 29                	je     802202 <spawn+0x33c>
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)) {
			perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  8021d9:	25 07 0e 00 00       	and    $0xe07,%eax
            if (perm & PTE_SHARE) {
                if ((r = sys_page_map(0, addr, child, addr, perm)) < 0) 
  8021de:	89 44 24 10          	mov    %eax,0x10(%esp)
  8021e2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021e6:	89 74 24 08          	mov    %esi,0x8(%esp)
  8021ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021f5:	e8 ad eb ff ff       	call   800da7 <sys_page_map>
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	0f 88 b1 00 00 00    	js     8022b3 <spawn+0x3ed>
	uint8_t *addr, *end_addr;
    int perm;
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
  802202:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802208:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  80220e:	75 9c                	jne    8021ac <spawn+0x2e6>
  802210:	e9 be 00 00 00       	jmp    8022d3 <spawn+0x40d>
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  802215:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802219:	c7 44 24 08 ca 3c 80 	movl   $0x803cca,0x8(%esp)
  802220:	00 
  802221:	c7 44 24 04 8b 00 00 	movl   $0x8b,0x4(%esp)
  802228:	00 
  802229:	c7 04 24 a4 3c 80 00 	movl   $0x803ca4,(%esp)
  802230:	e8 e3 df ff ff       	call   800218 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802235:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80223c:	00 
  80223d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802243:	89 04 24             	mov    %eax,(%esp)
  802246:	e8 02 ec ff ff       	call   800e4d <sys_env_set_status>
  80224b:	85 c0                	test   %eax,%eax
  80224d:	79 55                	jns    8022a4 <spawn+0x3de>
		panic("sys_env_set_status: %e", r);
  80224f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802253:	c7 44 24 08 e4 3c 80 	movl   $0x803ce4,0x8(%esp)
  80225a:	00 
  80225b:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  802262:	00 
  802263:	c7 04 24 a4 3c 80 00 	movl   $0x803ca4,(%esp)
  80226a:	e8 a9 df ff ff       	call   800218 <_panic>
  80226f:	89 c7                	mov    %eax,%edi

	return child;

error:
	sys_env_destroy(child);
  802271:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802277:	89 04 24             	mov    %eax,(%esp)
  80227a:	e8 44 ea ff ff       	call   800cc3 <sys_env_destroy>
	close(fd);
  80227f:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802285:	89 04 24             	mov    %eax,(%esp)
  802288:	e8 ba f3 ff ff       	call   801647 <close>
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80228d:	89 f8                	mov    %edi,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  80228f:	e9 84 00 00 00       	jmp    802318 <spawn+0x452>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  802294:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80229a:	eb 7c                	jmp    802318 <spawn+0x452>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  80229c:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8022a2:	eb 74                	jmp    802318 <spawn+0x452>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  8022a4:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8022aa:	eb 6c                	jmp    802318 <spawn+0x452>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  8022ac:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8022b1:	eb 65                	jmp    802318 <spawn+0x452>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  8022b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022b7:	c7 44 24 08 fb 3c 80 	movl   $0x803cfb,0x8(%esp)
  8022be:	00 
  8022bf:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  8022c6:	00 
  8022c7:	c7 04 24 a4 3c 80 00 	movl   $0x803ca4,(%esp)
  8022ce:	e8 45 df ff ff       	call   800218 <_panic>

	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  8022d3:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  8022da:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8022dd:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8022e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e7:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8022ed:	89 04 24             	mov    %eax,(%esp)
  8022f0:	e8 ab eb ff ff       	call   800ea0 <sys_env_set_trapframe>
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	0f 89 38 ff ff ff    	jns    802235 <spawn+0x36f>
  8022fd:	e9 13 ff ff ff       	jmp    802215 <spawn+0x34f>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802302:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802309:	00 
  80230a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802311:	e8 e4 ea ff ff       	call   800dfa <sys_page_unmap>
  802316:	89 f8                	mov    %edi,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802318:	81 c4 8c 02 00 00    	add    $0x28c,%esp
  80231e:	5b                   	pop    %ebx
  80231f:	5e                   	pop    %esi
  802320:	5f                   	pop    %edi
  802321:	5d                   	pop    %ebp
  802322:	c3                   	ret    

00802323 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
  802326:	56                   	push   %esi
  802327:	53                   	push   %ebx
  802328:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80232b:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  80232e:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802333:	eb 03                	jmp    802338 <spawnl+0x15>
		argc++;
  802335:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802338:	83 c0 04             	add    $0x4,%eax
  80233b:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  80233f:	75 f4                	jne    802335 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802341:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  802348:	83 e0 f0             	and    $0xfffffff0,%eax
  80234b:	29 c4                	sub    %eax,%esp
  80234d:	8d 44 24 0b          	lea    0xb(%esp),%eax
  802351:	c1 e8 02             	shr    $0x2,%eax
  802354:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  80235b:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80235d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802360:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  802367:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  80236e:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80236f:	b8 00 00 00 00       	mov    $0x0,%eax
  802374:	eb 0a                	jmp    802380 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  802376:	83 c0 01             	add    $0x1,%eax
  802379:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  80237d:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802380:	39 d0                	cmp    %edx,%eax
  802382:	75 f2                	jne    802376 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802384:	89 74 24 04          	mov    %esi,0x4(%esp)
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	89 04 24             	mov    %eax,(%esp)
  80238e:	e8 33 fb ff ff       	call   801ec6 <spawn>
}
  802393:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802396:	5b                   	pop    %ebx
  802397:	5e                   	pop    %esi
  802398:	5d                   	pop    %ebp
  802399:	c3                   	ret    

0080239a <exec>:

int
exec(const char *prog, const char **argv)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
  80239d:	57                   	push   %edi
  80239e:	56                   	push   %esi
  80239f:	53                   	push   %ebx
  8023a0:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
	int fd, i, r;
	struct Elf *elf;
	struct Proghdr *ph;
	int perm;	

	if ((r = open(prog, O_RDONLY)) < 0)
  8023a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023ad:	00 
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	89 04 24             	mov    %eax,(%esp)
  8023b4:	e8 26 f9 ff ff       	call   801cdf <open>
  8023b9:	89 c7                	mov    %eax,%edi
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	0f 88 14 03 00 00    	js     8026d7 <exec+0x33d>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8023c3:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8023ca:	00 
  8023cb:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8023d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d5:	89 3c 24             	mov    %edi,(%esp)
  8023d8:	e8 5f f4 ff ff       	call   80183c <readn>
  8023dd:	3d 00 02 00 00       	cmp    $0x200,%eax
  8023e2:	75 0c                	jne    8023f0 <exec+0x56>
	    || elf->e_magic != ELF_MAGIC) {
  8023e4:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8023eb:	45 4c 46 
  8023ee:	74 30                	je     802420 <exec+0x86>
		close(fd);
  8023f0:	89 3c 24             	mov    %edi,(%esp)
  8023f3:	e8 4f f2 ff ff       	call   801647 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8023f8:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  8023ff:	46 
  802400:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802406:	89 44 24 04          	mov    %eax,0x4(%esp)
  80240a:	c7 04 24 b0 3c 80 00 	movl   $0x803cb0,(%esp)
  802411:	e8 fb de ff ff       	call   800311 <cprintf>
		return -E_NOT_EXEC;
  802416:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80241b:	e9 d8 02 00 00       	jmp    8026f8 <exec+0x35e>
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802420:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802426:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
  80242d:	b8 00 00 00 e0       	mov    $0xe0000000,%eax
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802432:	be 00 00 00 00       	mov    $0x0,%esi
  802437:	89 bd e4 fd ff ff    	mov    %edi,-0x21c(%ebp)
  80243d:	89 c7                	mov    %eax,%edi
  80243f:	eb 71                	jmp    8024b2 <exec+0x118>
		if (ph->p_type != ELF_PROG_LOAD)
  802441:	83 3b 01             	cmpl   $0x1,(%ebx)
  802444:	75 66                	jne    8024ac <exec+0x112>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802446:	8b 43 18             	mov    0x18(%ebx),%eax
  802449:	83 e0 02             	and    $0x2,%eax
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  80244c:	83 f8 01             	cmp    $0x1,%eax
  80244f:	19 c0                	sbb    %eax,%eax
  802451:	83 e0 fe             	and    $0xfffffffe,%eax
  802454:	83 c0 07             	add    $0x7,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(0, PGOFF(ph->p_va) + tmp, ph->p_memsz,
  802457:	8b 4b 14             	mov    0x14(%ebx),%ecx
  80245a:	8b 53 08             	mov    0x8(%ebx),%edx
  80245d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802463:	01 fa                	add    %edi,%edx
  802465:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802469:	8b 43 04             	mov    0x4(%ebx),%eax
  80246c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802470:	8b 43 10             	mov    0x10(%ebx),%eax
  802473:	89 44 24 04          	mov    %eax,0x4(%esp)
  802477:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
  80247d:	89 04 24             	mov    %eax,(%esp)
  802480:	b8 00 00 00 00       	mov    $0x0,%eax
  802485:	e8 f6 f8 ff ff       	call   801d80 <map_segment>
  80248a:	85 c0                	test   %eax,%eax
  80248c:	0f 88 25 02 00 00    	js     8026b7 <exec+0x31d>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
  802492:	8b 53 14             	mov    0x14(%ebx),%edx
  802495:	8b 43 08             	mov    0x8(%ebx),%eax
  802498:	25 ff 0f 00 00       	and    $0xfff,%eax
  80249d:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
  8024a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8024a9:	8d 3c 38             	lea    (%eax,%edi,1),%edi
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8024ac:	83 c6 01             	add    $0x1,%esi
  8024af:	83 c3 20             	add    $0x20,%ebx
  8024b2:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8024b9:	39 c6                	cmp    %eax,%esi
  8024bb:	7c 84                	jl     802441 <exec+0xa7>
  8024bd:	89 bd dc fd ff ff    	mov    %edi,-0x224(%ebp)
  8024c3:	8b bd e4 fd ff ff    	mov    -0x21c(%ebp),%edi
		if ((r = map_segment(0, PGOFF(ph->p_va) + tmp, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
	}
	close(fd);
  8024c9:	89 3c 24             	mov    %edi,(%esp)
  8024cc:	e8 76 f1 ff ff       	call   801647 <close>
	fd = -1;
	cprintf("tf_esp: %x\n", tf_esp);
  8024d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8024d8:	00 
  8024d9:	c7 04 24 11 3d 80 00 	movl   $0x803d11,(%esp)
  8024e0:	e8 2c de ff ff       	call   800311 <cprintf>
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8024e5:	bb 00 00 00 00       	mov    $0x0,%ebx
	size_t string_size;
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
  8024ea:	be 00 00 00 00       	mov    $0x0,%esi
  8024ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8024f2:	eb 0f                	jmp    802503 <exec+0x169>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  8024f4:	89 04 24             	mov    %eax,(%esp)
  8024f7:	e8 04 e4 ff ff       	call   800900 <strlen>
  8024fc:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802500:	83 c3 01             	add    $0x1,%ebx
  802503:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80250a:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80250d:	85 c0                	test   %eax,%eax
  80250f:	75 e3                	jne    8024f4 <exec+0x15a>
  802511:	89 9d d8 fd ff ff    	mov    %ebx,-0x228(%ebp)
  802517:	89 8d d4 fd ff ff    	mov    %ecx,-0x22c(%ebp)
		string_size += strlen(argv[argc]) + 1;

	string_store = (char*) UTEMP + PGSIZE - string_size;
  80251d:	bf 00 10 40 00       	mov    $0x401000,%edi
  802522:	29 f7                	sub    %esi,%edi
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802524:	89 fa                	mov    %edi,%edx
  802526:	83 e2 fc             	and    $0xfffffffc,%edx
  802529:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802530:	29 c2                	sub    %eax,%edx
  802532:	89 95 e4 fd ff ff    	mov    %edx,-0x21c(%ebp)
	
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802538:	8d 42 f8             	lea    -0x8(%edx),%eax
  80253b:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802540:	0f 86 93 01 00 00    	jbe    8026d9 <exec+0x33f>
		return -E_NO_MEM;

	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802546:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80254d:	00 
  80254e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802555:	00 
  802556:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80255d:	e8 f1 e7 ff ff       	call   800d53 <sys_page_alloc>
  802562:	85 c0                	test   %eax,%eax
  802564:	0f 88 8e 01 00 00    	js     8026f8 <exec+0x35e>
  80256a:	be 00 00 00 00       	mov    $0x0,%esi
  80256f:	89 9d e0 fd ff ff    	mov    %ebx,-0x220(%ebp)
  802575:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802578:	eb 30                	jmp    8025aa <exec+0x210>
		return r;

	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  80257a:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802580:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
  802586:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802589:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80258c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802590:	89 3c 24             	mov    %edi,(%esp)
  802593:	e8 9f e3 ff ff       	call   800937 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802598:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80259b:	89 04 24             	mov    %eax,(%esp)
  80259e:	e8 5d e3 ff ff       	call   800900 <strlen>
  8025a3:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
		return -E_NO_MEM;

	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		return r;

	for (i = 0; i < argc; i++) {
  8025a7:	83 c6 01             	add    $0x1,%esi
  8025aa:	39 b5 e0 fd ff ff    	cmp    %esi,-0x220(%ebp)
  8025b0:	7f c8                	jg     80257a <exec+0x1e0>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8025b2:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
  8025b8:	8b 8d d4 fd ff ff    	mov    -0x22c(%ebp),%ecx
  8025be:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8025c5:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8025cb:	74 24                	je     8025f1 <exec+0x257>
  8025cd:	c7 44 24 0c 28 3d 80 	movl   $0x803d28,0xc(%esp)
  8025d4:	00 
  8025d5:	c7 44 24 08 5b 3c 80 	movl   $0x803c5b,0x8(%esp)
  8025dc:	00 
  8025dd:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
  8025e4:	00 
  8025e5:	c7 04 24 a4 3c 80 00 	movl   $0x803ca4,(%esp)
  8025ec:	e8 27 dc ff ff       	call   800218 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8025f1:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
  8025f7:	89 c8                	mov    %ecx,%eax
  8025f9:	2d 00 30 80 11       	sub    $0x11803000,%eax
  8025fe:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802601:	8b 85 d8 fd ff ff    	mov    -0x228(%ebp),%eax
  802607:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80260a:	8d 99 f8 cf 7f ee    	lea    -0x11803008(%ecx),%ebx

	cprintf("stack: %x\n", stack);
  802610:	8b bd dc fd ff ff    	mov    -0x224(%ebp),%edi
  802616:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80261a:	c7 04 24 1d 3d 80 00 	movl   $0x803d1d,(%esp)
  802621:	e8 eb dc ff ff       	call   800311 <cprintf>
	if ((r = sys_page_map(0, UTEMP, child, (void*) stack, PTE_P | PTE_U | PTE_W)) < 0)
  802626:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80262d:	00 
  80262e:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802632:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802639:	00 
  80263a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802641:	00 
  802642:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802649:	e8 59 e7 ff ff       	call   800da7 <sys_page_map>
  80264e:	89 c7                	mov    %eax,%edi
  802650:	85 c0                	test   %eax,%eax
  802652:	0f 88 8a 00 00 00    	js     8026e2 <exec+0x348>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802658:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80265f:	00 
  802660:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802667:	e8 8e e7 ff ff       	call   800dfa <sys_page_unmap>
  80266c:	89 c7                	mov    %eax,%edi
  80266e:	85 c0                	test   %eax,%eax
  802670:	78 70                	js     8026e2 <exec+0x348>
	// cprintf("tf_eip: %x\n", tf_eip);
	if ((r = init_stack_with_addr(0, argv, &tf_esp, tmp)) < 0)
		return r;

	// Syscall to exec
	if (sys_exec(elf->e_entry, tf_esp, (void *)(elf_buf + elf->e_phoff), elf->e_phnum) < 0)
  802672:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802679:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80267d:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802683:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  80268a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80268e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802692:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802698:	89 04 24             	mov    %eax,(%esp)
  80269b:	e8 9c e9 ff ff       	call   80103c <sys_exec>
  8026a0:	89 c2                	mov    %eax,%edx
		goto error;
	return 0;
  8026a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a7:	be 00 00 00 00       	mov    $0x0,%esi
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
	}
	close(fd);
	fd = -1;
  8026ac:	bf ff ff ff ff       	mov    $0xffffffff,%edi
	// cprintf("tf_eip: %x\n", tf_eip);
	if ((r = init_stack_with_addr(0, argv, &tf_esp, tmp)) < 0)
		return r;

	// Syscall to exec
	if (sys_exec(elf->e_entry, tf_esp, (void *)(elf_buf + elf->e_phoff), elf->e_phnum) < 0)
  8026b1:	85 d2                	test   %edx,%edx
  8026b3:	78 0a                	js     8026bf <exec+0x325>
  8026b5:	eb 41                	jmp    8026f8 <exec+0x35e>
  8026b7:	8b bd e4 fd ff ff    	mov    -0x21c(%ebp),%edi
  8026bd:	89 c6                	mov    %eax,%esi
		goto error;
	return 0;

error:
	sys_env_destroy(0);
  8026bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c6:	e8 f8 e5 ff ff       	call   800cc3 <sys_env_destroy>
	close(fd);
  8026cb:	89 3c 24             	mov    %edi,(%esp)
  8026ce:	e8 74 ef ff ff       	call   801647 <close>
	return r;
  8026d3:	89 f0                	mov    %esi,%eax
  8026d5:	eb 21                	jmp    8026f8 <exec+0x35e>
  8026d7:	eb 1f                	jmp    8026f8 <exec+0x35e>

	string_store = (char*) UTEMP + PGSIZE - string_size;
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  8026d9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  8026de:	66 90                	xchg   %ax,%ax
  8026e0:	eb 16                	jmp    8026f8 <exec+0x35e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8026e2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8026e9:	00 
  8026ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026f1:	e8 04 e7 ff ff       	call   800dfa <sys_page_unmap>
  8026f6:	89 f8                	mov    %edi,%eax

error:
	sys_env_destroy(0);
	close(fd);
	return r;
}
  8026f8:	81 c4 3c 02 00 00    	add    $0x23c,%esp
  8026fe:	5b                   	pop    %ebx
  8026ff:	5e                   	pop    %esi
  802700:	5f                   	pop    %edi
  802701:	5d                   	pop    %ebp
  802702:	c3                   	ret    

00802703 <execl>:

int
execl(const char *prog, const char *arg0, ...)
{
  802703:	55                   	push   %ebp
  802704:	89 e5                	mov    %esp,%ebp
  802706:	56                   	push   %esi
  802707:	53                   	push   %ebx
  802708:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80270b:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  80270e:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802713:	eb 03                	jmp    802718 <execl+0x15>
		argc++;
  802715:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802718:	83 c0 04             	add    $0x4,%eax
  80271b:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  80271f:	75 f4                	jne    802715 <execl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802721:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  802728:	83 e0 f0             	and    $0xfffffff0,%eax
  80272b:	29 c4                	sub    %eax,%esp
  80272d:	8d 44 24 0b          	lea    0xb(%esp),%eax
  802731:	c1 e8 02             	shr    $0x2,%eax
  802734:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  80273b:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80273d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802740:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  802747:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  80274e:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80274f:	b8 00 00 00 00       	mov    $0x0,%eax
  802754:	eb 0a                	jmp    802760 <execl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  802756:	83 c0 01             	add    $0x1,%eax
  802759:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  80275d:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802760:	39 d0                	cmp    %edx,%eax
  802762:	75 f2                	jne    802756 <execl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return exec(prog, argv);
  802764:	89 74 24 04          	mov    %esi,0x4(%esp)
  802768:	8b 45 08             	mov    0x8(%ebp),%eax
  80276b:	89 04 24             	mov    %eax,(%esp)
  80276e:	e8 27 fc ff ff       	call   80239a <exec>
}
  802773:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802776:	5b                   	pop    %ebx
  802777:	5e                   	pop    %esi
  802778:	5d                   	pop    %ebp
  802779:	c3                   	ret    
  80277a:	66 90                	xchg   %ax,%ax
  80277c:	66 90                	xchg   %ax,%ax
  80277e:	66 90                	xchg   %ax,%ax

00802780 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
  802783:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802786:	c7 44 24 04 4e 3d 80 	movl   $0x803d4e,0x4(%esp)
  80278d:	00 
  80278e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802791:	89 04 24             	mov    %eax,(%esp)
  802794:	e8 9e e1 ff ff       	call   800937 <strcpy>
	return 0;
}
  802799:	b8 00 00 00 00       	mov    $0x0,%eax
  80279e:	c9                   	leave  
  80279f:	c3                   	ret    

008027a0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8027a0:	55                   	push   %ebp
  8027a1:	89 e5                	mov    %esp,%ebp
  8027a3:	53                   	push   %ebx
  8027a4:	83 ec 14             	sub    $0x14,%esp
  8027a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8027aa:	89 1c 24             	mov    %ebx,(%esp)
  8027ad:	e8 3d 0c 00 00       	call   8033ef <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8027b2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8027b7:	83 f8 01             	cmp    $0x1,%eax
  8027ba:	75 0d                	jne    8027c9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8027bc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8027bf:	89 04 24             	mov    %eax,(%esp)
  8027c2:	e8 29 03 00 00       	call   802af0 <nsipc_close>
  8027c7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8027c9:	89 d0                	mov    %edx,%eax
  8027cb:	83 c4 14             	add    $0x14,%esp
  8027ce:	5b                   	pop    %ebx
  8027cf:	5d                   	pop    %ebp
  8027d0:	c3                   	ret    

008027d1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8027d1:	55                   	push   %ebp
  8027d2:	89 e5                	mov    %esp,%ebp
  8027d4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8027d7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8027de:	00 
  8027df:	8b 45 10             	mov    0x10(%ebp),%eax
  8027e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f3:	89 04 24             	mov    %eax,(%esp)
  8027f6:	e8 f0 03 00 00       	call   802beb <nsipc_send>
}
  8027fb:	c9                   	leave  
  8027fc:	c3                   	ret    

008027fd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8027fd:	55                   	push   %ebp
  8027fe:	89 e5                	mov    %esp,%ebp
  802800:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802803:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80280a:	00 
  80280b:	8b 45 10             	mov    0x10(%ebp),%eax
  80280e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802812:	8b 45 0c             	mov    0xc(%ebp),%eax
  802815:	89 44 24 04          	mov    %eax,0x4(%esp)
  802819:	8b 45 08             	mov    0x8(%ebp),%eax
  80281c:	8b 40 0c             	mov    0xc(%eax),%eax
  80281f:	89 04 24             	mov    %eax,(%esp)
  802822:	e8 44 03 00 00       	call   802b6b <nsipc_recv>
}
  802827:	c9                   	leave  
  802828:	c3                   	ret    

00802829 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802829:	55                   	push   %ebp
  80282a:	89 e5                	mov    %esp,%ebp
  80282c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80282f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802832:	89 54 24 04          	mov    %edx,0x4(%esp)
  802836:	89 04 24             	mov    %eax,(%esp)
  802839:	e8 d8 ec ff ff       	call   801516 <fd_lookup>
  80283e:	85 c0                	test   %eax,%eax
  802840:	78 17                	js     802859 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  80284b:	39 08                	cmp    %ecx,(%eax)
  80284d:	75 05                	jne    802854 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80284f:	8b 40 0c             	mov    0xc(%eax),%eax
  802852:	eb 05                	jmp    802859 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802854:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802859:	c9                   	leave  
  80285a:	c3                   	ret    

0080285b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
  80285e:	56                   	push   %esi
  80285f:	53                   	push   %ebx
  802860:	83 ec 20             	sub    $0x20,%esp
  802863:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802865:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802868:	89 04 24             	mov    %eax,(%esp)
  80286b:	e8 57 ec ff ff       	call   8014c7 <fd_alloc>
  802870:	89 c3                	mov    %eax,%ebx
  802872:	85 c0                	test   %eax,%eax
  802874:	78 21                	js     802897 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802876:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80287d:	00 
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	89 44 24 04          	mov    %eax,0x4(%esp)
  802885:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80288c:	e8 c2 e4 ff ff       	call   800d53 <sys_page_alloc>
  802891:	89 c3                	mov    %eax,%ebx
  802893:	85 c0                	test   %eax,%eax
  802895:	79 0c                	jns    8028a3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802897:	89 34 24             	mov    %esi,(%esp)
  80289a:	e8 51 02 00 00       	call   802af0 <nsipc_close>
		return r;
  80289f:	89 d8                	mov    %ebx,%eax
  8028a1:	eb 20                	jmp    8028c3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8028a3:	8b 15 28 40 80 00    	mov    0x804028,%edx
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8028ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8028b8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8028bb:	89 14 24             	mov    %edx,(%esp)
  8028be:	e8 dd eb ff ff       	call   8014a0 <fd2num>
}
  8028c3:	83 c4 20             	add    $0x20,%esp
  8028c6:	5b                   	pop    %ebx
  8028c7:	5e                   	pop    %esi
  8028c8:	5d                   	pop    %ebp
  8028c9:	c3                   	ret    

008028ca <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8028ca:	55                   	push   %ebp
  8028cb:	89 e5                	mov    %esp,%ebp
  8028cd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8028d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d3:	e8 51 ff ff ff       	call   802829 <fd2sockid>
		return r;
  8028d8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8028da:	85 c0                	test   %eax,%eax
  8028dc:	78 23                	js     802901 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8028de:	8b 55 10             	mov    0x10(%ebp),%edx
  8028e1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8028e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8028ec:	89 04 24             	mov    %eax,(%esp)
  8028ef:	e8 45 01 00 00       	call   802a39 <nsipc_accept>
		return r;
  8028f4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	78 07                	js     802901 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8028fa:	e8 5c ff ff ff       	call   80285b <alloc_sockfd>
  8028ff:	89 c1                	mov    %eax,%ecx
}
  802901:	89 c8                	mov    %ecx,%eax
  802903:	c9                   	leave  
  802904:	c3                   	ret    

00802905 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802905:	55                   	push   %ebp
  802906:	89 e5                	mov    %esp,%ebp
  802908:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80290b:	8b 45 08             	mov    0x8(%ebp),%eax
  80290e:	e8 16 ff ff ff       	call   802829 <fd2sockid>
  802913:	89 c2                	mov    %eax,%edx
  802915:	85 d2                	test   %edx,%edx
  802917:	78 16                	js     80292f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802919:	8b 45 10             	mov    0x10(%ebp),%eax
  80291c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802920:	8b 45 0c             	mov    0xc(%ebp),%eax
  802923:	89 44 24 04          	mov    %eax,0x4(%esp)
  802927:	89 14 24             	mov    %edx,(%esp)
  80292a:	e8 60 01 00 00       	call   802a8f <nsipc_bind>
}
  80292f:	c9                   	leave  
  802930:	c3                   	ret    

00802931 <shutdown>:

int
shutdown(int s, int how)
{
  802931:	55                   	push   %ebp
  802932:	89 e5                	mov    %esp,%ebp
  802934:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	e8 ea fe ff ff       	call   802829 <fd2sockid>
  80293f:	89 c2                	mov    %eax,%edx
  802941:	85 d2                	test   %edx,%edx
  802943:	78 0f                	js     802954 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802945:	8b 45 0c             	mov    0xc(%ebp),%eax
  802948:	89 44 24 04          	mov    %eax,0x4(%esp)
  80294c:	89 14 24             	mov    %edx,(%esp)
  80294f:	e8 7a 01 00 00       	call   802ace <nsipc_shutdown>
}
  802954:	c9                   	leave  
  802955:	c3                   	ret    

00802956 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802956:	55                   	push   %ebp
  802957:	89 e5                	mov    %esp,%ebp
  802959:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	e8 c5 fe ff ff       	call   802829 <fd2sockid>
  802964:	89 c2                	mov    %eax,%edx
  802966:	85 d2                	test   %edx,%edx
  802968:	78 16                	js     802980 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80296a:	8b 45 10             	mov    0x10(%ebp),%eax
  80296d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802971:	8b 45 0c             	mov    0xc(%ebp),%eax
  802974:	89 44 24 04          	mov    %eax,0x4(%esp)
  802978:	89 14 24             	mov    %edx,(%esp)
  80297b:	e8 8a 01 00 00       	call   802b0a <nsipc_connect>
}
  802980:	c9                   	leave  
  802981:	c3                   	ret    

00802982 <listen>:

int
listen(int s, int backlog)
{
  802982:	55                   	push   %ebp
  802983:	89 e5                	mov    %esp,%ebp
  802985:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802988:	8b 45 08             	mov    0x8(%ebp),%eax
  80298b:	e8 99 fe ff ff       	call   802829 <fd2sockid>
  802990:	89 c2                	mov    %eax,%edx
  802992:	85 d2                	test   %edx,%edx
  802994:	78 0f                	js     8029a5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802996:	8b 45 0c             	mov    0xc(%ebp),%eax
  802999:	89 44 24 04          	mov    %eax,0x4(%esp)
  80299d:	89 14 24             	mov    %edx,(%esp)
  8029a0:	e8 a4 01 00 00       	call   802b49 <nsipc_listen>
}
  8029a5:	c9                   	leave  
  8029a6:	c3                   	ret    

008029a7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8029a7:	55                   	push   %ebp
  8029a8:	89 e5                	mov    %esp,%ebp
  8029aa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8029ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8029b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029be:	89 04 24             	mov    %eax,(%esp)
  8029c1:	e8 98 02 00 00       	call   802c5e <nsipc_socket>
  8029c6:	89 c2                	mov    %eax,%edx
  8029c8:	85 d2                	test   %edx,%edx
  8029ca:	78 05                	js     8029d1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8029cc:	e8 8a fe ff ff       	call   80285b <alloc_sockfd>
}
  8029d1:	c9                   	leave  
  8029d2:	c3                   	ret    

008029d3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8029d3:	55                   	push   %ebp
  8029d4:	89 e5                	mov    %esp,%ebp
  8029d6:	53                   	push   %ebx
  8029d7:	83 ec 14             	sub    $0x14,%esp
  8029da:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8029dc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8029e3:	75 11                	jne    8029f6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8029e5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8029ec:	e8 c4 09 00 00       	call   8033b5 <ipc_find_env>
  8029f1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8029f6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8029fd:	00 
  8029fe:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  802a05:	00 
  802a06:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a0a:	a1 04 50 80 00       	mov    0x805004,%eax
  802a0f:	89 04 24             	mov    %eax,(%esp)
  802a12:	e8 11 09 00 00       	call   803328 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802a17:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802a1e:	00 
  802a1f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802a26:	00 
  802a27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a2e:	e8 8d 08 00 00       	call   8032c0 <ipc_recv>
}
  802a33:	83 c4 14             	add    $0x14,%esp
  802a36:	5b                   	pop    %ebx
  802a37:	5d                   	pop    %ebp
  802a38:	c3                   	ret    

00802a39 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802a39:	55                   	push   %ebp
  802a3a:	89 e5                	mov    %esp,%ebp
  802a3c:	56                   	push   %esi
  802a3d:	53                   	push   %ebx
  802a3e:	83 ec 10             	sub    $0x10,%esp
  802a41:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802a44:	8b 45 08             	mov    0x8(%ebp),%eax
  802a47:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802a4c:	8b 06                	mov    (%esi),%eax
  802a4e:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802a53:	b8 01 00 00 00       	mov    $0x1,%eax
  802a58:	e8 76 ff ff ff       	call   8029d3 <nsipc>
  802a5d:	89 c3                	mov    %eax,%ebx
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	78 23                	js     802a86 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802a63:	a1 10 80 80 00       	mov    0x808010,%eax
  802a68:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a6c:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802a73:	00 
  802a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a77:	89 04 24             	mov    %eax,(%esp)
  802a7a:	e8 55 e0 ff ff       	call   800ad4 <memmove>
		*addrlen = ret->ret_addrlen;
  802a7f:	a1 10 80 80 00       	mov    0x808010,%eax
  802a84:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802a86:	89 d8                	mov    %ebx,%eax
  802a88:	83 c4 10             	add    $0x10,%esp
  802a8b:	5b                   	pop    %ebx
  802a8c:	5e                   	pop    %esi
  802a8d:	5d                   	pop    %ebp
  802a8e:	c3                   	ret    

00802a8f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802a8f:	55                   	push   %ebp
  802a90:	89 e5                	mov    %esp,%ebp
  802a92:	53                   	push   %ebx
  802a93:	83 ec 14             	sub    $0x14,%esp
  802a96:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802a99:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9c:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802aa1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802aa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aac:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  802ab3:	e8 1c e0 ff ff       	call   800ad4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802ab8:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  802abe:	b8 02 00 00 00       	mov    $0x2,%eax
  802ac3:	e8 0b ff ff ff       	call   8029d3 <nsipc>
}
  802ac8:	83 c4 14             	add    $0x14,%esp
  802acb:	5b                   	pop    %ebx
  802acc:	5d                   	pop    %ebp
  802acd:	c3                   	ret    

00802ace <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802ace:	55                   	push   %ebp
  802acf:	89 e5                	mov    %esp,%ebp
  802ad1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  802adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802adf:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  802ae4:	b8 03 00 00 00       	mov    $0x3,%eax
  802ae9:	e8 e5 fe ff ff       	call   8029d3 <nsipc>
}
  802aee:	c9                   	leave  
  802aef:	c3                   	ret    

00802af0 <nsipc_close>:

int
nsipc_close(int s)
{
  802af0:	55                   	push   %ebp
  802af1:	89 e5                	mov    %esp,%ebp
  802af3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802af6:	8b 45 08             	mov    0x8(%ebp),%eax
  802af9:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  802afe:	b8 04 00 00 00       	mov    $0x4,%eax
  802b03:	e8 cb fe ff ff       	call   8029d3 <nsipc>
}
  802b08:	c9                   	leave  
  802b09:	c3                   	ret    

00802b0a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802b0a:	55                   	push   %ebp
  802b0b:	89 e5                	mov    %esp,%ebp
  802b0d:	53                   	push   %ebx
  802b0e:	83 ec 14             	sub    $0x14,%esp
  802b11:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802b14:	8b 45 08             	mov    0x8(%ebp),%eax
  802b17:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802b1c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b23:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b27:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  802b2e:	e8 a1 df ff ff       	call   800ad4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802b33:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  802b39:	b8 05 00 00 00       	mov    $0x5,%eax
  802b3e:	e8 90 fe ff ff       	call   8029d3 <nsipc>
}
  802b43:	83 c4 14             	add    $0x14,%esp
  802b46:	5b                   	pop    %ebx
  802b47:	5d                   	pop    %ebp
  802b48:	c3                   	ret    

00802b49 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802b49:	55                   	push   %ebp
  802b4a:	89 e5                	mov    %esp,%ebp
  802b4c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  802b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b5a:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  802b5f:	b8 06 00 00 00       	mov    $0x6,%eax
  802b64:	e8 6a fe ff ff       	call   8029d3 <nsipc>
}
  802b69:	c9                   	leave  
  802b6a:	c3                   	ret    

00802b6b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802b6b:	55                   	push   %ebp
  802b6c:	89 e5                	mov    %esp,%ebp
  802b6e:	56                   	push   %esi
  802b6f:	53                   	push   %ebx
  802b70:	83 ec 10             	sub    $0x10,%esp
  802b73:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  802b7e:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  802b84:	8b 45 14             	mov    0x14(%ebp),%eax
  802b87:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802b8c:	b8 07 00 00 00       	mov    $0x7,%eax
  802b91:	e8 3d fe ff ff       	call   8029d3 <nsipc>
  802b96:	89 c3                	mov    %eax,%ebx
  802b98:	85 c0                	test   %eax,%eax
  802b9a:	78 46                	js     802be2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802b9c:	39 f0                	cmp    %esi,%eax
  802b9e:	7f 07                	jg     802ba7 <nsipc_recv+0x3c>
  802ba0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802ba5:	7e 24                	jle    802bcb <nsipc_recv+0x60>
  802ba7:	c7 44 24 0c 5a 3d 80 	movl   $0x803d5a,0xc(%esp)
  802bae:	00 
  802baf:	c7 44 24 08 5b 3c 80 	movl   $0x803c5b,0x8(%esp)
  802bb6:	00 
  802bb7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  802bbe:	00 
  802bbf:	c7 04 24 6f 3d 80 00 	movl   $0x803d6f,(%esp)
  802bc6:	e8 4d d6 ff ff       	call   800218 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802bcb:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bcf:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802bd6:	00 
  802bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bda:	89 04 24             	mov    %eax,(%esp)
  802bdd:	e8 f2 de ff ff       	call   800ad4 <memmove>
	}

	return r;
}
  802be2:	89 d8                	mov    %ebx,%eax
  802be4:	83 c4 10             	add    $0x10,%esp
  802be7:	5b                   	pop    %ebx
  802be8:	5e                   	pop    %esi
  802be9:	5d                   	pop    %ebp
  802bea:	c3                   	ret    

00802beb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802beb:	55                   	push   %ebp
  802bec:	89 e5                	mov    %esp,%ebp
  802bee:	53                   	push   %ebx
  802bef:	83 ec 14             	sub    $0x14,%esp
  802bf2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  802bfd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802c03:	7e 24                	jle    802c29 <nsipc_send+0x3e>
  802c05:	c7 44 24 0c 7b 3d 80 	movl   $0x803d7b,0xc(%esp)
  802c0c:	00 
  802c0d:	c7 44 24 08 5b 3c 80 	movl   $0x803c5b,0x8(%esp)
  802c14:	00 
  802c15:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  802c1c:	00 
  802c1d:	c7 04 24 6f 3d 80 00 	movl   $0x803d6f,(%esp)
  802c24:	e8 ef d5 ff ff       	call   800218 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802c29:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c30:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c34:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  802c3b:	e8 94 de ff ff       	call   800ad4 <memmove>
	nsipcbuf.send.req_size = size;
  802c40:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  802c46:	8b 45 14             	mov    0x14(%ebp),%eax
  802c49:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  802c4e:	b8 08 00 00 00       	mov    $0x8,%eax
  802c53:	e8 7b fd ff ff       	call   8029d3 <nsipc>
}
  802c58:	83 c4 14             	add    $0x14,%esp
  802c5b:	5b                   	pop    %ebx
  802c5c:	5d                   	pop    %ebp
  802c5d:	c3                   	ret    

00802c5e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802c5e:	55                   	push   %ebp
  802c5f:	89 e5                	mov    %esp,%ebp
  802c61:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802c64:	8b 45 08             	mov    0x8(%ebp),%eax
  802c67:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  802c6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c6f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  802c74:	8b 45 10             	mov    0x10(%ebp),%eax
  802c77:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  802c7c:	b8 09 00 00 00       	mov    $0x9,%eax
  802c81:	e8 4d fd ff ff       	call   8029d3 <nsipc>
}
  802c86:	c9                   	leave  
  802c87:	c3                   	ret    

00802c88 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802c88:	55                   	push   %ebp
  802c89:	89 e5                	mov    %esp,%ebp
  802c8b:	56                   	push   %esi
  802c8c:	53                   	push   %ebx
  802c8d:	83 ec 10             	sub    $0x10,%esp
  802c90:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	89 04 24             	mov    %eax,(%esp)
  802c99:	e8 12 e8 ff ff       	call   8014b0 <fd2data>
  802c9e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802ca0:	c7 44 24 04 87 3d 80 	movl   $0x803d87,0x4(%esp)
  802ca7:	00 
  802ca8:	89 1c 24             	mov    %ebx,(%esp)
  802cab:	e8 87 dc ff ff       	call   800937 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802cb0:	8b 46 04             	mov    0x4(%esi),%eax
  802cb3:	2b 06                	sub    (%esi),%eax
  802cb5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802cbb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802cc2:	00 00 00 
	stat->st_dev = &devpipe;
  802cc5:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  802ccc:	40 80 00 
	return 0;
}
  802ccf:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd4:	83 c4 10             	add    $0x10,%esp
  802cd7:	5b                   	pop    %ebx
  802cd8:	5e                   	pop    %esi
  802cd9:	5d                   	pop    %ebp
  802cda:	c3                   	ret    

00802cdb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802cdb:	55                   	push   %ebp
  802cdc:	89 e5                	mov    %esp,%ebp
  802cde:	53                   	push   %ebx
  802cdf:	83 ec 14             	sub    $0x14,%esp
  802ce2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802ce5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802ce9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cf0:	e8 05 e1 ff ff       	call   800dfa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802cf5:	89 1c 24             	mov    %ebx,(%esp)
  802cf8:	e8 b3 e7 ff ff       	call   8014b0 <fd2data>
  802cfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d01:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d08:	e8 ed e0 ff ff       	call   800dfa <sys_page_unmap>
}
  802d0d:	83 c4 14             	add    $0x14,%esp
  802d10:	5b                   	pop    %ebx
  802d11:	5d                   	pop    %ebp
  802d12:	c3                   	ret    

00802d13 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802d13:	55                   	push   %ebp
  802d14:	89 e5                	mov    %esp,%ebp
  802d16:	57                   	push   %edi
  802d17:	56                   	push   %esi
  802d18:	53                   	push   %ebx
  802d19:	83 ec 2c             	sub    $0x2c,%esp
  802d1c:	89 c6                	mov    %eax,%esi
  802d1e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802d21:	a1 08 50 80 00       	mov    0x805008,%eax
  802d26:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802d29:	89 34 24             	mov    %esi,(%esp)
  802d2c:	e8 be 06 00 00       	call   8033ef <pageref>
  802d31:	89 c7                	mov    %eax,%edi
  802d33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d36:	89 04 24             	mov    %eax,(%esp)
  802d39:	e8 b1 06 00 00       	call   8033ef <pageref>
  802d3e:	39 c7                	cmp    %eax,%edi
  802d40:	0f 94 c2             	sete   %dl
  802d43:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802d46:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  802d4c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802d4f:	39 fb                	cmp    %edi,%ebx
  802d51:	74 21                	je     802d74 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802d53:	84 d2                	test   %dl,%dl
  802d55:	74 ca                	je     802d21 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802d57:	8b 51 58             	mov    0x58(%ecx),%edx
  802d5a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d5e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802d62:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802d66:	c7 04 24 8e 3d 80 00 	movl   $0x803d8e,(%esp)
  802d6d:	e8 9f d5 ff ff       	call   800311 <cprintf>
  802d72:	eb ad                	jmp    802d21 <_pipeisclosed+0xe>
	}
}
  802d74:	83 c4 2c             	add    $0x2c,%esp
  802d77:	5b                   	pop    %ebx
  802d78:	5e                   	pop    %esi
  802d79:	5f                   	pop    %edi
  802d7a:	5d                   	pop    %ebp
  802d7b:	c3                   	ret    

00802d7c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802d7c:	55                   	push   %ebp
  802d7d:	89 e5                	mov    %esp,%ebp
  802d7f:	57                   	push   %edi
  802d80:	56                   	push   %esi
  802d81:	53                   	push   %ebx
  802d82:	83 ec 1c             	sub    $0x1c,%esp
  802d85:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802d88:	89 34 24             	mov    %esi,(%esp)
  802d8b:	e8 20 e7 ff ff       	call   8014b0 <fd2data>
  802d90:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802d92:	bf 00 00 00 00       	mov    $0x0,%edi
  802d97:	eb 45                	jmp    802dde <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802d99:	89 da                	mov    %ebx,%edx
  802d9b:	89 f0                	mov    %esi,%eax
  802d9d:	e8 71 ff ff ff       	call   802d13 <_pipeisclosed>
  802da2:	85 c0                	test   %eax,%eax
  802da4:	75 41                	jne    802de7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802da6:	e8 89 df ff ff       	call   800d34 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802dab:	8b 43 04             	mov    0x4(%ebx),%eax
  802dae:	8b 0b                	mov    (%ebx),%ecx
  802db0:	8d 51 20             	lea    0x20(%ecx),%edx
  802db3:	39 d0                	cmp    %edx,%eax
  802db5:	73 e2                	jae    802d99 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802db7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802dba:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802dbe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802dc1:	99                   	cltd   
  802dc2:	c1 ea 1b             	shr    $0x1b,%edx
  802dc5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802dc8:	83 e1 1f             	and    $0x1f,%ecx
  802dcb:	29 d1                	sub    %edx,%ecx
  802dcd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802dd1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802dd5:	83 c0 01             	add    $0x1,%eax
  802dd8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ddb:	83 c7 01             	add    $0x1,%edi
  802dde:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802de1:	75 c8                	jne    802dab <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802de3:	89 f8                	mov    %edi,%eax
  802de5:	eb 05                	jmp    802dec <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802de7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802dec:	83 c4 1c             	add    $0x1c,%esp
  802def:	5b                   	pop    %ebx
  802df0:	5e                   	pop    %esi
  802df1:	5f                   	pop    %edi
  802df2:	5d                   	pop    %ebp
  802df3:	c3                   	ret    

00802df4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802df4:	55                   	push   %ebp
  802df5:	89 e5                	mov    %esp,%ebp
  802df7:	57                   	push   %edi
  802df8:	56                   	push   %esi
  802df9:	53                   	push   %ebx
  802dfa:	83 ec 1c             	sub    $0x1c,%esp
  802dfd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802e00:	89 3c 24             	mov    %edi,(%esp)
  802e03:	e8 a8 e6 ff ff       	call   8014b0 <fd2data>
  802e08:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e0a:	be 00 00 00 00       	mov    $0x0,%esi
  802e0f:	eb 3d                	jmp    802e4e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802e11:	85 f6                	test   %esi,%esi
  802e13:	74 04                	je     802e19 <devpipe_read+0x25>
				return i;
  802e15:	89 f0                	mov    %esi,%eax
  802e17:	eb 43                	jmp    802e5c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802e19:	89 da                	mov    %ebx,%edx
  802e1b:	89 f8                	mov    %edi,%eax
  802e1d:	e8 f1 fe ff ff       	call   802d13 <_pipeisclosed>
  802e22:	85 c0                	test   %eax,%eax
  802e24:	75 31                	jne    802e57 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802e26:	e8 09 df ff ff       	call   800d34 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802e2b:	8b 03                	mov    (%ebx),%eax
  802e2d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802e30:	74 df                	je     802e11 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802e32:	99                   	cltd   
  802e33:	c1 ea 1b             	shr    $0x1b,%edx
  802e36:	01 d0                	add    %edx,%eax
  802e38:	83 e0 1f             	and    $0x1f,%eax
  802e3b:	29 d0                	sub    %edx,%eax
  802e3d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802e42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e45:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802e48:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802e4b:	83 c6 01             	add    $0x1,%esi
  802e4e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802e51:	75 d8                	jne    802e2b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802e53:	89 f0                	mov    %esi,%eax
  802e55:	eb 05                	jmp    802e5c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802e57:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802e5c:	83 c4 1c             	add    $0x1c,%esp
  802e5f:	5b                   	pop    %ebx
  802e60:	5e                   	pop    %esi
  802e61:	5f                   	pop    %edi
  802e62:	5d                   	pop    %ebp
  802e63:	c3                   	ret    

00802e64 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802e64:	55                   	push   %ebp
  802e65:	89 e5                	mov    %esp,%ebp
  802e67:	56                   	push   %esi
  802e68:	53                   	push   %ebx
  802e69:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802e6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e6f:	89 04 24             	mov    %eax,(%esp)
  802e72:	e8 50 e6 ff ff       	call   8014c7 <fd_alloc>
  802e77:	89 c2                	mov    %eax,%edx
  802e79:	85 d2                	test   %edx,%edx
  802e7b:	0f 88 4d 01 00 00    	js     802fce <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e81:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802e88:	00 
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e97:	e8 b7 de ff ff       	call   800d53 <sys_page_alloc>
  802e9c:	89 c2                	mov    %eax,%edx
  802e9e:	85 d2                	test   %edx,%edx
  802ea0:	0f 88 28 01 00 00    	js     802fce <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802ea6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802ea9:	89 04 24             	mov    %eax,(%esp)
  802eac:	e8 16 e6 ff ff       	call   8014c7 <fd_alloc>
  802eb1:	89 c3                	mov    %eax,%ebx
  802eb3:	85 c0                	test   %eax,%eax
  802eb5:	0f 88 fe 00 00 00    	js     802fb9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802ebb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802ec2:	00 
  802ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802eca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ed1:	e8 7d de ff ff       	call   800d53 <sys_page_alloc>
  802ed6:	89 c3                	mov    %eax,%ebx
  802ed8:	85 c0                	test   %eax,%eax
  802eda:	0f 88 d9 00 00 00    	js     802fb9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee3:	89 04 24             	mov    %eax,(%esp)
  802ee6:	e8 c5 e5 ff ff       	call   8014b0 <fd2data>
  802eeb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802eed:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802ef4:	00 
  802ef5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ef9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f00:	e8 4e de ff ff       	call   800d53 <sys_page_alloc>
  802f05:	89 c3                	mov    %eax,%ebx
  802f07:	85 c0                	test   %eax,%eax
  802f09:	0f 88 97 00 00 00    	js     802fa6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f12:	89 04 24             	mov    %eax,(%esp)
  802f15:	e8 96 e5 ff ff       	call   8014b0 <fd2data>
  802f1a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802f21:	00 
  802f22:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f26:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802f2d:	00 
  802f2e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f32:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f39:	e8 69 de ff ff       	call   800da7 <sys_page_map>
  802f3e:	89 c3                	mov    %eax,%ebx
  802f40:	85 c0                	test   %eax,%eax
  802f42:	78 52                	js     802f96 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802f44:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802f59:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f62:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f67:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f71:	89 04 24             	mov    %eax,(%esp)
  802f74:	e8 27 e5 ff ff       	call   8014a0 <fd2num>
  802f79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f7c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f81:	89 04 24             	mov    %eax,(%esp)
  802f84:	e8 17 e5 ff ff       	call   8014a0 <fd2num>
  802f89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f8c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f94:	eb 38                	jmp    802fce <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802f96:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802fa1:	e8 54 de ff ff       	call   800dfa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802fb4:	e8 41 de ff ff       	call   800dfa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802fc7:	e8 2e de ff ff       	call   800dfa <sys_page_unmap>
  802fcc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802fce:	83 c4 30             	add    $0x30,%esp
  802fd1:	5b                   	pop    %ebx
  802fd2:	5e                   	pop    %esi
  802fd3:	5d                   	pop    %ebp
  802fd4:	c3                   	ret    

00802fd5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802fd5:	55                   	push   %ebp
  802fd6:	89 e5                	mov    %esp,%ebp
  802fd8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802fde:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	89 04 24             	mov    %eax,(%esp)
  802fe8:	e8 29 e5 ff ff       	call   801516 <fd_lookup>
  802fed:	89 c2                	mov    %eax,%edx
  802fef:	85 d2                	test   %edx,%edx
  802ff1:	78 15                	js     803008 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff6:	89 04 24             	mov    %eax,(%esp)
  802ff9:	e8 b2 e4 ff ff       	call   8014b0 <fd2data>
	return _pipeisclosed(fd, p);
  802ffe:	89 c2                	mov    %eax,%edx
  803000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803003:	e8 0b fd ff ff       	call   802d13 <_pipeisclosed>
}
  803008:	c9                   	leave  
  803009:	c3                   	ret    

0080300a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80300a:	55                   	push   %ebp
  80300b:	89 e5                	mov    %esp,%ebp
  80300d:	56                   	push   %esi
  80300e:	53                   	push   %ebx
  80300f:	83 ec 10             	sub    $0x10,%esp
  803012:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  803015:	85 f6                	test   %esi,%esi
  803017:	75 24                	jne    80303d <wait+0x33>
  803019:	c7 44 24 0c a6 3d 80 	movl   $0x803da6,0xc(%esp)
  803020:	00 
  803021:	c7 44 24 08 5b 3c 80 	movl   $0x803c5b,0x8(%esp)
  803028:	00 
  803029:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  803030:	00 
  803031:	c7 04 24 b1 3d 80 00 	movl   $0x803db1,(%esp)
  803038:	e8 db d1 ff ff       	call   800218 <_panic>
	e = &envs[ENVX(envid)];
  80303d:	89 f3                	mov    %esi,%ebx
  80303f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  803045:	c1 e3 07             	shl    $0x7,%ebx
  803048:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80304e:	eb 05                	jmp    803055 <wait+0x4b>
		sys_yield();
  803050:	e8 df dc ff ff       	call   800d34 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803055:	8b 43 48             	mov    0x48(%ebx),%eax
  803058:	39 f0                	cmp    %esi,%eax
  80305a:	75 07                	jne    803063 <wait+0x59>
  80305c:	8b 43 54             	mov    0x54(%ebx),%eax
  80305f:	85 c0                	test   %eax,%eax
  803061:	75 ed                	jne    803050 <wait+0x46>
		sys_yield();
}
  803063:	83 c4 10             	add    $0x10,%esp
  803066:	5b                   	pop    %ebx
  803067:	5e                   	pop    %esi
  803068:	5d                   	pop    %ebp
  803069:	c3                   	ret    
  80306a:	66 90                	xchg   %ax,%ax
  80306c:	66 90                	xchg   %ax,%ax
  80306e:	66 90                	xchg   %ax,%ax

00803070 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  803070:	55                   	push   %ebp
  803071:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  803073:	b8 00 00 00 00       	mov    $0x0,%eax
  803078:	5d                   	pop    %ebp
  803079:	c3                   	ret    

0080307a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80307a:	55                   	push   %ebp
  80307b:	89 e5                	mov    %esp,%ebp
  80307d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  803080:	c7 44 24 04 bc 3d 80 	movl   $0x803dbc,0x4(%esp)
  803087:	00 
  803088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80308b:	89 04 24             	mov    %eax,(%esp)
  80308e:	e8 a4 d8 ff ff       	call   800937 <strcpy>
	return 0;
}
  803093:	b8 00 00 00 00       	mov    $0x0,%eax
  803098:	c9                   	leave  
  803099:	c3                   	ret    

0080309a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80309a:	55                   	push   %ebp
  80309b:	89 e5                	mov    %esp,%ebp
  80309d:	57                   	push   %edi
  80309e:	56                   	push   %esi
  80309f:	53                   	push   %ebx
  8030a0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8030a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8030ab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8030b1:	eb 31                	jmp    8030e4 <devcons_write+0x4a>
		m = n - tot;
  8030b3:	8b 75 10             	mov    0x10(%ebp),%esi
  8030b6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8030b8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8030bb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8030c0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8030c3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8030c7:	03 45 0c             	add    0xc(%ebp),%eax
  8030ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030ce:	89 3c 24             	mov    %edi,(%esp)
  8030d1:	e8 fe d9 ff ff       	call   800ad4 <memmove>
		sys_cputs(buf, m);
  8030d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8030da:	89 3c 24             	mov    %edi,(%esp)
  8030dd:	e8 a4 db ff ff       	call   800c86 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8030e2:	01 f3                	add    %esi,%ebx
  8030e4:	89 d8                	mov    %ebx,%eax
  8030e6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8030e9:	72 c8                	jb     8030b3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8030eb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8030f1:	5b                   	pop    %ebx
  8030f2:	5e                   	pop    %esi
  8030f3:	5f                   	pop    %edi
  8030f4:	5d                   	pop    %ebp
  8030f5:	c3                   	ret    

008030f6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8030f6:	55                   	push   %ebp
  8030f7:	89 e5                	mov    %esp,%ebp
  8030f9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8030fc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  803101:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803105:	75 07                	jne    80310e <devcons_read+0x18>
  803107:	eb 2a                	jmp    803133 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  803109:	e8 26 dc ff ff       	call   800d34 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80310e:	66 90                	xchg   %ax,%ax
  803110:	e8 8f db ff ff       	call   800ca4 <sys_cgetc>
  803115:	85 c0                	test   %eax,%eax
  803117:	74 f0                	je     803109 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  803119:	85 c0                	test   %eax,%eax
  80311b:	78 16                	js     803133 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80311d:	83 f8 04             	cmp    $0x4,%eax
  803120:	74 0c                	je     80312e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  803122:	8b 55 0c             	mov    0xc(%ebp),%edx
  803125:	88 02                	mov    %al,(%edx)
	return 1;
  803127:	b8 01 00 00 00       	mov    $0x1,%eax
  80312c:	eb 05                	jmp    803133 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80312e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  803133:	c9                   	leave  
  803134:	c3                   	ret    

00803135 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  803135:	55                   	push   %ebp
  803136:	89 e5                	mov    %esp,%ebp
  803138:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80313b:	8b 45 08             	mov    0x8(%ebp),%eax
  80313e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  803141:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803148:	00 
  803149:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80314c:	89 04 24             	mov    %eax,(%esp)
  80314f:	e8 32 db ff ff       	call   800c86 <sys_cputs>
}
  803154:	c9                   	leave  
  803155:	c3                   	ret    

00803156 <getchar>:

int
getchar(void)
{
  803156:	55                   	push   %ebp
  803157:	89 e5                	mov    %esp,%ebp
  803159:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80315c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  803163:	00 
  803164:	8d 45 f7             	lea    -0x9(%ebp),%eax
  803167:	89 44 24 04          	mov    %eax,0x4(%esp)
  80316b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803172:	e8 33 e6 ff ff       	call   8017aa <read>
	if (r < 0)
  803177:	85 c0                	test   %eax,%eax
  803179:	78 0f                	js     80318a <getchar+0x34>
		return r;
	if (r < 1)
  80317b:	85 c0                	test   %eax,%eax
  80317d:	7e 06                	jle    803185 <getchar+0x2f>
		return -E_EOF;
	return c;
  80317f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  803183:	eb 05                	jmp    80318a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  803185:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80318a:	c9                   	leave  
  80318b:	c3                   	ret    

0080318c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80318c:	55                   	push   %ebp
  80318d:	89 e5                	mov    %esp,%ebp
  80318f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803192:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803195:	89 44 24 04          	mov    %eax,0x4(%esp)
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	89 04 24             	mov    %eax,(%esp)
  80319f:	e8 72 e3 ff ff       	call   801516 <fd_lookup>
  8031a4:	85 c0                	test   %eax,%eax
  8031a6:	78 11                	js     8031b9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8031a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ab:	8b 15 60 40 80 00    	mov    0x804060,%edx
  8031b1:	39 10                	cmp    %edx,(%eax)
  8031b3:	0f 94 c0             	sete   %al
  8031b6:	0f b6 c0             	movzbl %al,%eax
}
  8031b9:	c9                   	leave  
  8031ba:	c3                   	ret    

008031bb <opencons>:

int
opencons(void)
{
  8031bb:	55                   	push   %ebp
  8031bc:	89 e5                	mov    %esp,%ebp
  8031be:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8031c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031c4:	89 04 24             	mov    %eax,(%esp)
  8031c7:	e8 fb e2 ff ff       	call   8014c7 <fd_alloc>
		return r;
  8031cc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8031ce:	85 c0                	test   %eax,%eax
  8031d0:	78 40                	js     803212 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8031d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8031d9:	00 
  8031da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031e8:	e8 66 db ff ff       	call   800d53 <sys_page_alloc>
		return r;
  8031ed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8031ef:	85 c0                	test   %eax,%eax
  8031f1:	78 1f                	js     803212 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8031f3:	8b 15 60 40 80 00    	mov    0x804060,%edx
  8031f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8031fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803201:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803208:	89 04 24             	mov    %eax,(%esp)
  80320b:	e8 90 e2 ff ff       	call   8014a0 <fd2num>
  803210:	89 c2                	mov    %eax,%edx
}
  803212:	89 d0                	mov    %edx,%eax
  803214:	c9                   	leave  
  803215:	c3                   	ret    

00803216 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803216:	55                   	push   %ebp
  803217:	89 e5                	mov    %esp,%ebp
  803219:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80321c:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  803223:	75 68                	jne    80328d <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  803225:	a1 08 50 80 00       	mov    0x805008,%eax
  80322a:	8b 40 48             	mov    0x48(%eax),%eax
  80322d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803234:	00 
  803235:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80323c:	ee 
  80323d:	89 04 24             	mov    %eax,(%esp)
  803240:	e8 0e db ff ff       	call   800d53 <sys_page_alloc>
  803245:	85 c0                	test   %eax,%eax
  803247:	74 2c                	je     803275 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  803249:	89 44 24 04          	mov    %eax,0x4(%esp)
  80324d:	c7 04 24 c8 3d 80 00 	movl   $0x803dc8,(%esp)
  803254:	e8 b8 d0 ff ff       	call   800311 <cprintf>
			panic("set_pg_fault_handler");
  803259:	c7 44 24 08 fc 3d 80 	movl   $0x803dfc,0x8(%esp)
  803260:	00 
  803261:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  803268:	00 
  803269:	c7 04 24 11 3e 80 00 	movl   $0x803e11,(%esp)
  803270:	e8 a3 cf ff ff       	call   800218 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  803275:	a1 08 50 80 00       	mov    0x805008,%eax
  80327a:	8b 40 48             	mov    0x48(%eax),%eax
  80327d:	c7 44 24 04 97 32 80 	movl   $0x803297,0x4(%esp)
  803284:	00 
  803285:	89 04 24             	mov    %eax,(%esp)
  803288:	e8 66 dc ff ff       	call   800ef3 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80328d:	8b 45 08             	mov    0x8(%ebp),%eax
  803290:	a3 00 90 80 00       	mov    %eax,0x809000
}
  803295:	c9                   	leave  
  803296:	c3                   	ret    

00803297 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803297:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803298:	a1 00 90 80 00       	mov    0x809000,%eax
	call *%eax
  80329d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80329f:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  8032a2:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  8032a6:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  8032a8:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  8032ac:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  8032ad:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  8032b0:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  8032b2:	58                   	pop    %eax
	popl %eax
  8032b3:	58                   	pop    %eax
	popal
  8032b4:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8032b5:	83 c4 04             	add    $0x4,%esp
	popfl
  8032b8:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8032b9:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8032ba:	c3                   	ret    
  8032bb:	66 90                	xchg   %ax,%ax
  8032bd:	66 90                	xchg   %ax,%ax
  8032bf:	90                   	nop

008032c0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8032c0:	55                   	push   %ebp
  8032c1:	89 e5                	mov    %esp,%ebp
  8032c3:	56                   	push   %esi
  8032c4:	53                   	push   %ebx
  8032c5:	83 ec 10             	sub    $0x10,%esp
  8032c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8032cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8032d1:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  8032d3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8032d8:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  8032db:	89 04 24             	mov    %eax,(%esp)
  8032de:	e8 86 dc ff ff       	call   800f69 <sys_ipc_recv>
  8032e3:	85 c0                	test   %eax,%eax
  8032e5:	74 16                	je     8032fd <ipc_recv+0x3d>
		if (from_env_store != NULL)
  8032e7:	85 f6                	test   %esi,%esi
  8032e9:	74 06                	je     8032f1 <ipc_recv+0x31>
			*from_env_store = 0;
  8032eb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8032f1:	85 db                	test   %ebx,%ebx
  8032f3:	74 2c                	je     803321 <ipc_recv+0x61>
			*perm_store = 0;
  8032f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8032fb:	eb 24                	jmp    803321 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8032fd:	85 f6                	test   %esi,%esi
  8032ff:	74 0a                	je     80330b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  803301:	a1 08 50 80 00       	mov    0x805008,%eax
  803306:	8b 40 74             	mov    0x74(%eax),%eax
  803309:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80330b:	85 db                	test   %ebx,%ebx
  80330d:	74 0a                	je     803319 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80330f:	a1 08 50 80 00       	mov    0x805008,%eax
  803314:	8b 40 78             	mov    0x78(%eax),%eax
  803317:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  803319:	a1 08 50 80 00       	mov    0x805008,%eax
  80331e:	8b 40 70             	mov    0x70(%eax),%eax
}
  803321:	83 c4 10             	add    $0x10,%esp
  803324:	5b                   	pop    %ebx
  803325:	5e                   	pop    %esi
  803326:	5d                   	pop    %ebp
  803327:	c3                   	ret    

00803328 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803328:	55                   	push   %ebp
  803329:	89 e5                	mov    %esp,%ebp
  80332b:	57                   	push   %edi
  80332c:	56                   	push   %esi
  80332d:	53                   	push   %ebx
  80332e:	83 ec 1c             	sub    $0x1c,%esp
  803331:	8b 75 0c             	mov    0xc(%ebp),%esi
  803334:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803337:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80333a:	85 db                	test   %ebx,%ebx
  80333c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  803341:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  803344:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803348:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80334c:	89 74 24 04          	mov    %esi,0x4(%esp)
  803350:	8b 45 08             	mov    0x8(%ebp),%eax
  803353:	89 04 24             	mov    %eax,(%esp)
  803356:	e8 eb db ff ff       	call   800f46 <sys_ipc_try_send>
	if (r == 0) return;
  80335b:	85 c0                	test   %eax,%eax
  80335d:	75 22                	jne    803381 <ipc_send+0x59>
  80335f:	eb 4c                	jmp    8033ad <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  803361:	84 d2                	test   %dl,%dl
  803363:	75 48                	jne    8033ad <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  803365:	e8 ca d9 ff ff       	call   800d34 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80336a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80336e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803372:	89 74 24 04          	mov    %esi,0x4(%esp)
  803376:	8b 45 08             	mov    0x8(%ebp),%eax
  803379:	89 04 24             	mov    %eax,(%esp)
  80337c:	e8 c5 db ff ff       	call   800f46 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  803381:	85 c0                	test   %eax,%eax
  803383:	0f 94 c2             	sete   %dl
  803386:	74 d9                	je     803361 <ipc_send+0x39>
  803388:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80338b:	74 d4                	je     803361 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80338d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803391:	c7 44 24 08 1f 3e 80 	movl   $0x803e1f,0x8(%esp)
  803398:	00 
  803399:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  8033a0:	00 
  8033a1:	c7 04 24 2d 3e 80 00 	movl   $0x803e2d,(%esp)
  8033a8:	e8 6b ce ff ff       	call   800218 <_panic>
}
  8033ad:	83 c4 1c             	add    $0x1c,%esp
  8033b0:	5b                   	pop    %ebx
  8033b1:	5e                   	pop    %esi
  8033b2:	5f                   	pop    %edi
  8033b3:	5d                   	pop    %ebp
  8033b4:	c3                   	ret    

008033b5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8033b5:	55                   	push   %ebp
  8033b6:	89 e5                	mov    %esp,%ebp
  8033b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8033bb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8033c0:	89 c2                	mov    %eax,%edx
  8033c2:	c1 e2 07             	shl    $0x7,%edx
  8033c5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8033cb:	8b 52 50             	mov    0x50(%edx),%edx
  8033ce:	39 ca                	cmp    %ecx,%edx
  8033d0:	75 0d                	jne    8033df <ipc_find_env+0x2a>
			return envs[i].env_id;
  8033d2:	c1 e0 07             	shl    $0x7,%eax
  8033d5:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8033da:	8b 40 40             	mov    0x40(%eax),%eax
  8033dd:	eb 0e                	jmp    8033ed <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8033df:	83 c0 01             	add    $0x1,%eax
  8033e2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8033e7:	75 d7                	jne    8033c0 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8033e9:	66 b8 00 00          	mov    $0x0,%ax
}
  8033ed:	5d                   	pop    %ebp
  8033ee:	c3                   	ret    

008033ef <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8033ef:	55                   	push   %ebp
  8033f0:	89 e5                	mov    %esp,%ebp
  8033f2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8033f5:	89 d0                	mov    %edx,%eax
  8033f7:	c1 e8 16             	shr    $0x16,%eax
  8033fa:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803401:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803406:	f6 c1 01             	test   $0x1,%cl
  803409:	74 1d                	je     803428 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80340b:	c1 ea 0c             	shr    $0xc,%edx
  80340e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803415:	f6 c2 01             	test   $0x1,%dl
  803418:	74 0e                	je     803428 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80341a:	c1 ea 0c             	shr    $0xc,%edx
  80341d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803424:	ef 
  803425:	0f b7 c0             	movzwl %ax,%eax
}
  803428:	5d                   	pop    %ebp
  803429:	c3                   	ret    
  80342a:	66 90                	xchg   %ax,%ax
  80342c:	66 90                	xchg   %ax,%ax
  80342e:	66 90                	xchg   %ax,%ax

00803430 <__udivdi3>:
  803430:	55                   	push   %ebp
  803431:	57                   	push   %edi
  803432:	56                   	push   %esi
  803433:	83 ec 0c             	sub    $0xc,%esp
  803436:	8b 44 24 28          	mov    0x28(%esp),%eax
  80343a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80343e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  803442:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803446:	85 c0                	test   %eax,%eax
  803448:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80344c:	89 ea                	mov    %ebp,%edx
  80344e:	89 0c 24             	mov    %ecx,(%esp)
  803451:	75 2d                	jne    803480 <__udivdi3+0x50>
  803453:	39 e9                	cmp    %ebp,%ecx
  803455:	77 61                	ja     8034b8 <__udivdi3+0x88>
  803457:	85 c9                	test   %ecx,%ecx
  803459:	89 ce                	mov    %ecx,%esi
  80345b:	75 0b                	jne    803468 <__udivdi3+0x38>
  80345d:	b8 01 00 00 00       	mov    $0x1,%eax
  803462:	31 d2                	xor    %edx,%edx
  803464:	f7 f1                	div    %ecx
  803466:	89 c6                	mov    %eax,%esi
  803468:	31 d2                	xor    %edx,%edx
  80346a:	89 e8                	mov    %ebp,%eax
  80346c:	f7 f6                	div    %esi
  80346e:	89 c5                	mov    %eax,%ebp
  803470:	89 f8                	mov    %edi,%eax
  803472:	f7 f6                	div    %esi
  803474:	89 ea                	mov    %ebp,%edx
  803476:	83 c4 0c             	add    $0xc,%esp
  803479:	5e                   	pop    %esi
  80347a:	5f                   	pop    %edi
  80347b:	5d                   	pop    %ebp
  80347c:	c3                   	ret    
  80347d:	8d 76 00             	lea    0x0(%esi),%esi
  803480:	39 e8                	cmp    %ebp,%eax
  803482:	77 24                	ja     8034a8 <__udivdi3+0x78>
  803484:	0f bd e8             	bsr    %eax,%ebp
  803487:	83 f5 1f             	xor    $0x1f,%ebp
  80348a:	75 3c                	jne    8034c8 <__udivdi3+0x98>
  80348c:	8b 74 24 04          	mov    0x4(%esp),%esi
  803490:	39 34 24             	cmp    %esi,(%esp)
  803493:	0f 86 9f 00 00 00    	jbe    803538 <__udivdi3+0x108>
  803499:	39 d0                	cmp    %edx,%eax
  80349b:	0f 82 97 00 00 00    	jb     803538 <__udivdi3+0x108>
  8034a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8034a8:	31 d2                	xor    %edx,%edx
  8034aa:	31 c0                	xor    %eax,%eax
  8034ac:	83 c4 0c             	add    $0xc,%esp
  8034af:	5e                   	pop    %esi
  8034b0:	5f                   	pop    %edi
  8034b1:	5d                   	pop    %ebp
  8034b2:	c3                   	ret    
  8034b3:	90                   	nop
  8034b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8034b8:	89 f8                	mov    %edi,%eax
  8034ba:	f7 f1                	div    %ecx
  8034bc:	31 d2                	xor    %edx,%edx
  8034be:	83 c4 0c             	add    $0xc,%esp
  8034c1:	5e                   	pop    %esi
  8034c2:	5f                   	pop    %edi
  8034c3:	5d                   	pop    %ebp
  8034c4:	c3                   	ret    
  8034c5:	8d 76 00             	lea    0x0(%esi),%esi
  8034c8:	89 e9                	mov    %ebp,%ecx
  8034ca:	8b 3c 24             	mov    (%esp),%edi
  8034cd:	d3 e0                	shl    %cl,%eax
  8034cf:	89 c6                	mov    %eax,%esi
  8034d1:	b8 20 00 00 00       	mov    $0x20,%eax
  8034d6:	29 e8                	sub    %ebp,%eax
  8034d8:	89 c1                	mov    %eax,%ecx
  8034da:	d3 ef                	shr    %cl,%edi
  8034dc:	89 e9                	mov    %ebp,%ecx
  8034de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8034e2:	8b 3c 24             	mov    (%esp),%edi
  8034e5:	09 74 24 08          	or     %esi,0x8(%esp)
  8034e9:	89 d6                	mov    %edx,%esi
  8034eb:	d3 e7                	shl    %cl,%edi
  8034ed:	89 c1                	mov    %eax,%ecx
  8034ef:	89 3c 24             	mov    %edi,(%esp)
  8034f2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8034f6:	d3 ee                	shr    %cl,%esi
  8034f8:	89 e9                	mov    %ebp,%ecx
  8034fa:	d3 e2                	shl    %cl,%edx
  8034fc:	89 c1                	mov    %eax,%ecx
  8034fe:	d3 ef                	shr    %cl,%edi
  803500:	09 d7                	or     %edx,%edi
  803502:	89 f2                	mov    %esi,%edx
  803504:	89 f8                	mov    %edi,%eax
  803506:	f7 74 24 08          	divl   0x8(%esp)
  80350a:	89 d6                	mov    %edx,%esi
  80350c:	89 c7                	mov    %eax,%edi
  80350e:	f7 24 24             	mull   (%esp)
  803511:	39 d6                	cmp    %edx,%esi
  803513:	89 14 24             	mov    %edx,(%esp)
  803516:	72 30                	jb     803548 <__udivdi3+0x118>
  803518:	8b 54 24 04          	mov    0x4(%esp),%edx
  80351c:	89 e9                	mov    %ebp,%ecx
  80351e:	d3 e2                	shl    %cl,%edx
  803520:	39 c2                	cmp    %eax,%edx
  803522:	73 05                	jae    803529 <__udivdi3+0xf9>
  803524:	3b 34 24             	cmp    (%esp),%esi
  803527:	74 1f                	je     803548 <__udivdi3+0x118>
  803529:	89 f8                	mov    %edi,%eax
  80352b:	31 d2                	xor    %edx,%edx
  80352d:	e9 7a ff ff ff       	jmp    8034ac <__udivdi3+0x7c>
  803532:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803538:	31 d2                	xor    %edx,%edx
  80353a:	b8 01 00 00 00       	mov    $0x1,%eax
  80353f:	e9 68 ff ff ff       	jmp    8034ac <__udivdi3+0x7c>
  803544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803548:	8d 47 ff             	lea    -0x1(%edi),%eax
  80354b:	31 d2                	xor    %edx,%edx
  80354d:	83 c4 0c             	add    $0xc,%esp
  803550:	5e                   	pop    %esi
  803551:	5f                   	pop    %edi
  803552:	5d                   	pop    %ebp
  803553:	c3                   	ret    
  803554:	66 90                	xchg   %ax,%ax
  803556:	66 90                	xchg   %ax,%ax
  803558:	66 90                	xchg   %ax,%ax
  80355a:	66 90                	xchg   %ax,%ax
  80355c:	66 90                	xchg   %ax,%ax
  80355e:	66 90                	xchg   %ax,%ax

00803560 <__umoddi3>:
  803560:	55                   	push   %ebp
  803561:	57                   	push   %edi
  803562:	56                   	push   %esi
  803563:	83 ec 14             	sub    $0x14,%esp
  803566:	8b 44 24 28          	mov    0x28(%esp),%eax
  80356a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80356e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803572:	89 c7                	mov    %eax,%edi
  803574:	89 44 24 04          	mov    %eax,0x4(%esp)
  803578:	8b 44 24 30          	mov    0x30(%esp),%eax
  80357c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803580:	89 34 24             	mov    %esi,(%esp)
  803583:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803587:	85 c0                	test   %eax,%eax
  803589:	89 c2                	mov    %eax,%edx
  80358b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80358f:	75 17                	jne    8035a8 <__umoddi3+0x48>
  803591:	39 fe                	cmp    %edi,%esi
  803593:	76 4b                	jbe    8035e0 <__umoddi3+0x80>
  803595:	89 c8                	mov    %ecx,%eax
  803597:	89 fa                	mov    %edi,%edx
  803599:	f7 f6                	div    %esi
  80359b:	89 d0                	mov    %edx,%eax
  80359d:	31 d2                	xor    %edx,%edx
  80359f:	83 c4 14             	add    $0x14,%esp
  8035a2:	5e                   	pop    %esi
  8035a3:	5f                   	pop    %edi
  8035a4:	5d                   	pop    %ebp
  8035a5:	c3                   	ret    
  8035a6:	66 90                	xchg   %ax,%ax
  8035a8:	39 f8                	cmp    %edi,%eax
  8035aa:	77 54                	ja     803600 <__umoddi3+0xa0>
  8035ac:	0f bd e8             	bsr    %eax,%ebp
  8035af:	83 f5 1f             	xor    $0x1f,%ebp
  8035b2:	75 5c                	jne    803610 <__umoddi3+0xb0>
  8035b4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8035b8:	39 3c 24             	cmp    %edi,(%esp)
  8035bb:	0f 87 e7 00 00 00    	ja     8036a8 <__umoddi3+0x148>
  8035c1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8035c5:	29 f1                	sub    %esi,%ecx
  8035c7:	19 c7                	sbb    %eax,%edi
  8035c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035d1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035d5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8035d9:	83 c4 14             	add    $0x14,%esp
  8035dc:	5e                   	pop    %esi
  8035dd:	5f                   	pop    %edi
  8035de:	5d                   	pop    %ebp
  8035df:	c3                   	ret    
  8035e0:	85 f6                	test   %esi,%esi
  8035e2:	89 f5                	mov    %esi,%ebp
  8035e4:	75 0b                	jne    8035f1 <__umoddi3+0x91>
  8035e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035eb:	31 d2                	xor    %edx,%edx
  8035ed:	f7 f6                	div    %esi
  8035ef:	89 c5                	mov    %eax,%ebp
  8035f1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035f5:	31 d2                	xor    %edx,%edx
  8035f7:	f7 f5                	div    %ebp
  8035f9:	89 c8                	mov    %ecx,%eax
  8035fb:	f7 f5                	div    %ebp
  8035fd:	eb 9c                	jmp    80359b <__umoddi3+0x3b>
  8035ff:	90                   	nop
  803600:	89 c8                	mov    %ecx,%eax
  803602:	89 fa                	mov    %edi,%edx
  803604:	83 c4 14             	add    $0x14,%esp
  803607:	5e                   	pop    %esi
  803608:	5f                   	pop    %edi
  803609:	5d                   	pop    %ebp
  80360a:	c3                   	ret    
  80360b:	90                   	nop
  80360c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803610:	8b 04 24             	mov    (%esp),%eax
  803613:	be 20 00 00 00       	mov    $0x20,%esi
  803618:	89 e9                	mov    %ebp,%ecx
  80361a:	29 ee                	sub    %ebp,%esi
  80361c:	d3 e2                	shl    %cl,%edx
  80361e:	89 f1                	mov    %esi,%ecx
  803620:	d3 e8                	shr    %cl,%eax
  803622:	89 e9                	mov    %ebp,%ecx
  803624:	89 44 24 04          	mov    %eax,0x4(%esp)
  803628:	8b 04 24             	mov    (%esp),%eax
  80362b:	09 54 24 04          	or     %edx,0x4(%esp)
  80362f:	89 fa                	mov    %edi,%edx
  803631:	d3 e0                	shl    %cl,%eax
  803633:	89 f1                	mov    %esi,%ecx
  803635:	89 44 24 08          	mov    %eax,0x8(%esp)
  803639:	8b 44 24 10          	mov    0x10(%esp),%eax
  80363d:	d3 ea                	shr    %cl,%edx
  80363f:	89 e9                	mov    %ebp,%ecx
  803641:	d3 e7                	shl    %cl,%edi
  803643:	89 f1                	mov    %esi,%ecx
  803645:	d3 e8                	shr    %cl,%eax
  803647:	89 e9                	mov    %ebp,%ecx
  803649:	09 f8                	or     %edi,%eax
  80364b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80364f:	f7 74 24 04          	divl   0x4(%esp)
  803653:	d3 e7                	shl    %cl,%edi
  803655:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803659:	89 d7                	mov    %edx,%edi
  80365b:	f7 64 24 08          	mull   0x8(%esp)
  80365f:	39 d7                	cmp    %edx,%edi
  803661:	89 c1                	mov    %eax,%ecx
  803663:	89 14 24             	mov    %edx,(%esp)
  803666:	72 2c                	jb     803694 <__umoddi3+0x134>
  803668:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80366c:	72 22                	jb     803690 <__umoddi3+0x130>
  80366e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803672:	29 c8                	sub    %ecx,%eax
  803674:	19 d7                	sbb    %edx,%edi
  803676:	89 e9                	mov    %ebp,%ecx
  803678:	89 fa                	mov    %edi,%edx
  80367a:	d3 e8                	shr    %cl,%eax
  80367c:	89 f1                	mov    %esi,%ecx
  80367e:	d3 e2                	shl    %cl,%edx
  803680:	89 e9                	mov    %ebp,%ecx
  803682:	d3 ef                	shr    %cl,%edi
  803684:	09 d0                	or     %edx,%eax
  803686:	89 fa                	mov    %edi,%edx
  803688:	83 c4 14             	add    $0x14,%esp
  80368b:	5e                   	pop    %esi
  80368c:	5f                   	pop    %edi
  80368d:	5d                   	pop    %ebp
  80368e:	c3                   	ret    
  80368f:	90                   	nop
  803690:	39 d7                	cmp    %edx,%edi
  803692:	75 da                	jne    80366e <__umoddi3+0x10e>
  803694:	8b 14 24             	mov    (%esp),%edx
  803697:	89 c1                	mov    %eax,%ecx
  803699:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80369d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8036a1:	eb cb                	jmp    80366e <__umoddi3+0x10e>
  8036a3:	90                   	nop
  8036a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8036a8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8036ac:	0f 82 0f ff ff ff    	jb     8035c1 <__umoddi3+0x61>
  8036b2:	e9 1a ff ff ff       	jmp    8035d1 <__umoddi3+0x71>
