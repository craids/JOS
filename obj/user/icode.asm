
obj/user/icode.debug:     file format elf32-i386


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
  80002c:	e8 27 01 00 00       	call   800158 <libmain>
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
  800038:	81 ec 30 02 00 00    	sub    $0x230,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003e:	c7 05 00 40 80 00 60 	movl   $0x803160,0x804000
  800045:	31 80 00 

	cprintf("icode startup\n");
  800048:	c7 04 24 66 31 80 00 	movl   $0x803166,(%esp)
  80004f:	e8 5e 02 00 00       	call   8002b2 <cprintf>

	cprintf("icode: open /motd\n");
  800054:	c7 04 24 75 31 80 00 	movl   $0x803175,(%esp)
  80005b:	e8 52 02 00 00       	call   8002b2 <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  800060:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800067:	00 
  800068:	c7 04 24 88 31 80 00 	movl   $0x803188,(%esp)
  80006f:	e8 0b 18 00 00       	call   80187f <open>
  800074:	89 c6                	mov    %eax,%esi
  800076:	85 c0                	test   %eax,%eax
  800078:	79 20                	jns    80009a <umain+0x67>
		panic("icode: open /motd: %e", fd);
  80007a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80007e:	c7 44 24 08 8e 31 80 	movl   $0x80318e,0x8(%esp)
  800085:	00 
  800086:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  80008d:	00 
  80008e:	c7 04 24 a4 31 80 00 	movl   $0x8031a4,(%esp)
  800095:	e8 1f 01 00 00       	call   8001b9 <_panic>

	cprintf("icode: read /motd\n");
  80009a:	c7 04 24 b1 31 80 00 	movl   $0x8031b1,(%esp)
  8000a1:	e8 0c 02 00 00       	call   8002b2 <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000a6:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  8000ac:	eb 0c                	jmp    8000ba <umain+0x87>
		sys_cputs(buf, n);
  8000ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b2:	89 1c 24             	mov    %ebx,(%esp)
  8000b5:	e8 6c 0b 00 00       	call   800c26 <sys_cputs>
	cprintf("icode: open /motd\n");
	if ((fd = open("/motd", O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000ba:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8000c1:	00 
  8000c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000c6:	89 34 24             	mov    %esi,(%esp)
  8000c9:	e8 7c 12 00 00       	call   80134a <read>
  8000ce:	85 c0                	test   %eax,%eax
  8000d0:	7f dc                	jg     8000ae <umain+0x7b>
		sys_cputs(buf, n);

	cprintf("icode: close /motd\n");
  8000d2:	c7 04 24 c4 31 80 00 	movl   $0x8031c4,(%esp)
  8000d9:	e8 d4 01 00 00       	call   8002b2 <cprintf>
	close(fd);
  8000de:	89 34 24             	mov    %esi,(%esp)
  8000e1:	e8 01 11 00 00       	call   8011e7 <close>

	cprintf("icode: spawn /init\n");
  8000e6:	c7 04 24 d8 31 80 00 	movl   $0x8031d8,(%esp)
  8000ed:	e8 c0 01 00 00       	call   8002b2 <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000f2:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8000f9:	00 
  8000fa:	c7 44 24 0c ec 31 80 	movl   $0x8031ec,0xc(%esp)
  800101:	00 
  800102:	c7 44 24 08 f5 31 80 	movl   $0x8031f5,0x8(%esp)
  800109:	00 
  80010a:	c7 44 24 04 ff 31 80 	movl   $0x8031ff,0x4(%esp)
  800111:	00 
  800112:	c7 04 24 fe 31 80 00 	movl   $0x8031fe,(%esp)
  800119:	e8 a5 1d 00 00       	call   801ec3 <spawnl>
  80011e:	85 c0                	test   %eax,%eax
  800120:	79 20                	jns    800142 <umain+0x10f>
		panic("icode: spawn /init: %e", r);
  800122:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800126:	c7 44 24 08 04 32 80 	movl   $0x803204,0x8(%esp)
  80012d:	00 
  80012e:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800135:	00 
  800136:	c7 04 24 a4 31 80 00 	movl   $0x8031a4,(%esp)
  80013d:	e8 77 00 00 00       	call   8001b9 <_panic>

	cprintf("icode: exiting\n");
  800142:	c7 04 24 1b 32 80 00 	movl   $0x80321b,(%esp)
  800149:	e8 64 01 00 00       	call   8002b2 <cprintf>
}
  80014e:	81 c4 30 02 00 00    	add    $0x230,%esp
  800154:	5b                   	pop    %ebx
  800155:	5e                   	pop    %esi
  800156:	5d                   	pop    %ebp
  800157:	c3                   	ret    

00800158 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	56                   	push   %esi
  80015c:	53                   	push   %ebx
  80015d:	83 ec 10             	sub    $0x10,%esp
  800160:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800163:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800166:	e8 4a 0b 00 00       	call   800cb5 <sys_getenvid>
  80016b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800170:	c1 e0 07             	shl    $0x7,%eax
  800173:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800178:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017d:	85 db                	test   %ebx,%ebx
  80017f:	7e 07                	jle    800188 <libmain+0x30>
		binaryname = argv[0];
  800181:	8b 06                	mov    (%esi),%eax
  800183:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800188:	89 74 24 04          	mov    %esi,0x4(%esp)
  80018c:	89 1c 24             	mov    %ebx,(%esp)
  80018f:	e8 9f fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800194:	e8 07 00 00 00       	call   8001a0 <exit>
}
  800199:	83 c4 10             	add    $0x10,%esp
  80019c:	5b                   	pop    %ebx
  80019d:	5e                   	pop    %esi
  80019e:	5d                   	pop    %ebp
  80019f:	c3                   	ret    

008001a0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001a6:	e8 6f 10 00 00       	call   80121a <close_all>
	sys_env_destroy(0);
  8001ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001b2:	e8 ac 0a 00 00       	call   800c63 <sys_env_destroy>
}
  8001b7:	c9                   	leave  
  8001b8:	c3                   	ret    

008001b9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001b9:	55                   	push   %ebp
  8001ba:	89 e5                	mov    %esp,%ebp
  8001bc:	56                   	push   %esi
  8001bd:	53                   	push   %ebx
  8001be:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001c1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001c4:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001ca:	e8 e6 0a 00 00       	call   800cb5 <sys_getenvid>
  8001cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001dd:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e5:	c7 04 24 38 32 80 00 	movl   $0x803238,(%esp)
  8001ec:	e8 c1 00 00 00       	call   8002b2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001f1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f8:	89 04 24             	mov    %eax,(%esp)
  8001fb:	e8 51 00 00 00       	call   800251 <vcprintf>
	cprintf("\n");
  800200:	c7 04 24 71 37 80 00 	movl   $0x803771,(%esp)
  800207:	e8 a6 00 00 00       	call   8002b2 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80020c:	cc                   	int3   
  80020d:	eb fd                	jmp    80020c <_panic+0x53>

0080020f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80020f:	55                   	push   %ebp
  800210:	89 e5                	mov    %esp,%ebp
  800212:	53                   	push   %ebx
  800213:	83 ec 14             	sub    $0x14,%esp
  800216:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800219:	8b 13                	mov    (%ebx),%edx
  80021b:	8d 42 01             	lea    0x1(%edx),%eax
  80021e:	89 03                	mov    %eax,(%ebx)
  800220:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800223:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800227:	3d ff 00 00 00       	cmp    $0xff,%eax
  80022c:	75 19                	jne    800247 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80022e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800235:	00 
  800236:	8d 43 08             	lea    0x8(%ebx),%eax
  800239:	89 04 24             	mov    %eax,(%esp)
  80023c:	e8 e5 09 00 00       	call   800c26 <sys_cputs>
		b->idx = 0;
  800241:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800247:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80024b:	83 c4 14             	add    $0x14,%esp
  80024e:	5b                   	pop    %ebx
  80024f:	5d                   	pop    %ebp
  800250:	c3                   	ret    

00800251 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80025a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800261:	00 00 00 
	b.cnt = 0;
  800264:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80026b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80026e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800271:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800275:	8b 45 08             	mov    0x8(%ebp),%eax
  800278:	89 44 24 08          	mov    %eax,0x8(%esp)
  80027c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800282:	89 44 24 04          	mov    %eax,0x4(%esp)
  800286:	c7 04 24 0f 02 80 00 	movl   $0x80020f,(%esp)
  80028d:	e8 ac 01 00 00       	call   80043e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800292:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800298:	89 44 24 04          	mov    %eax,0x4(%esp)
  80029c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002a2:	89 04 24             	mov    %eax,(%esp)
  8002a5:	e8 7c 09 00 00       	call   800c26 <sys_cputs>

	return b.cnt;
}
  8002aa:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002b8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	89 04 24             	mov    %eax,(%esp)
  8002c5:	e8 87 ff ff ff       	call   800251 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002ca:	c9                   	leave  
  8002cb:	c3                   	ret    
  8002cc:	66 90                	xchg   %ax,%ax
  8002ce:	66 90                	xchg   %ax,%ax

008002d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	57                   	push   %edi
  8002d4:	56                   	push   %esi
  8002d5:	53                   	push   %ebx
  8002d6:	83 ec 3c             	sub    $0x3c,%esp
  8002d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002dc:	89 d7                	mov    %edx,%edi
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e7:	89 c3                	mov    %eax,%ebx
  8002e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ef:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002fa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002fd:	39 d9                	cmp    %ebx,%ecx
  8002ff:	72 05                	jb     800306 <printnum+0x36>
  800301:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800304:	77 69                	ja     80036f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800306:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800309:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80030d:	83 ee 01             	sub    $0x1,%esi
  800310:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800314:	89 44 24 08          	mov    %eax,0x8(%esp)
  800318:	8b 44 24 08          	mov    0x8(%esp),%eax
  80031c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800320:	89 c3                	mov    %eax,%ebx
  800322:	89 d6                	mov    %edx,%esi
  800324:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800327:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80032a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80032e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800335:	89 04 24             	mov    %eax,(%esp)
  800338:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80033b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033f:	e8 8c 2b 00 00       	call   802ed0 <__udivdi3>
  800344:	89 d9                	mov    %ebx,%ecx
  800346:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80034a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80034e:	89 04 24             	mov    %eax,(%esp)
  800351:	89 54 24 04          	mov    %edx,0x4(%esp)
  800355:	89 fa                	mov    %edi,%edx
  800357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80035a:	e8 71 ff ff ff       	call   8002d0 <printnum>
  80035f:	eb 1b                	jmp    80037c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800361:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800365:	8b 45 18             	mov    0x18(%ebp),%eax
  800368:	89 04 24             	mov    %eax,(%esp)
  80036b:	ff d3                	call   *%ebx
  80036d:	eb 03                	jmp    800372 <printnum+0xa2>
  80036f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800372:	83 ee 01             	sub    $0x1,%esi
  800375:	85 f6                	test   %esi,%esi
  800377:	7f e8                	jg     800361 <printnum+0x91>
  800379:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80037c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800380:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800384:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800387:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80038a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80038e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800392:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800395:	89 04 24             	mov    %eax,(%esp)
  800398:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80039b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039f:	e8 5c 2c 00 00       	call   803000 <__umoddi3>
  8003a4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003a8:	0f be 80 5b 32 80 00 	movsbl 0x80325b(%eax),%eax
  8003af:	89 04 24             	mov    %eax,(%esp)
  8003b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b5:	ff d0                	call   *%eax
}
  8003b7:	83 c4 3c             	add    $0x3c,%esp
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5f                   	pop    %edi
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    

008003bf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003c2:	83 fa 01             	cmp    $0x1,%edx
  8003c5:	7e 0e                	jle    8003d5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003c7:	8b 10                	mov    (%eax),%edx
  8003c9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003cc:	89 08                	mov    %ecx,(%eax)
  8003ce:	8b 02                	mov    (%edx),%eax
  8003d0:	8b 52 04             	mov    0x4(%edx),%edx
  8003d3:	eb 22                	jmp    8003f7 <getuint+0x38>
	else if (lflag)
  8003d5:	85 d2                	test   %edx,%edx
  8003d7:	74 10                	je     8003e9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003d9:	8b 10                	mov    (%eax),%edx
  8003db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003de:	89 08                	mov    %ecx,(%eax)
  8003e0:	8b 02                	mov    (%edx),%eax
  8003e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e7:	eb 0e                	jmp    8003f7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ee:	89 08                	mov    %ecx,(%eax)
  8003f0:	8b 02                	mov    (%edx),%eax
  8003f2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003f7:	5d                   	pop    %ebp
  8003f8:	c3                   	ret    

008003f9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003f9:	55                   	push   %ebp
  8003fa:	89 e5                	mov    %esp,%ebp
  8003fc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ff:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800403:	8b 10                	mov    (%eax),%edx
  800405:	3b 50 04             	cmp    0x4(%eax),%edx
  800408:	73 0a                	jae    800414 <sprintputch+0x1b>
		*b->buf++ = ch;
  80040a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80040d:	89 08                	mov    %ecx,(%eax)
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	88 02                	mov    %al,(%edx)
}
  800414:	5d                   	pop    %ebp
  800415:	c3                   	ret    

00800416 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800416:	55                   	push   %ebp
  800417:	89 e5                	mov    %esp,%ebp
  800419:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80041c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80041f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800423:	8b 45 10             	mov    0x10(%ebp),%eax
  800426:	89 44 24 08          	mov    %eax,0x8(%esp)
  80042a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
  800434:	89 04 24             	mov    %eax,(%esp)
  800437:	e8 02 00 00 00       	call   80043e <vprintfmt>
	va_end(ap);
}
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    

0080043e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	57                   	push   %edi
  800442:	56                   	push   %esi
  800443:	53                   	push   %ebx
  800444:	83 ec 3c             	sub    $0x3c,%esp
  800447:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80044a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80044d:	eb 14                	jmp    800463 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80044f:	85 c0                	test   %eax,%eax
  800451:	0f 84 b3 03 00 00    	je     80080a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800457:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80045b:	89 04 24             	mov    %eax,(%esp)
  80045e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800461:	89 f3                	mov    %esi,%ebx
  800463:	8d 73 01             	lea    0x1(%ebx),%esi
  800466:	0f b6 03             	movzbl (%ebx),%eax
  800469:	83 f8 25             	cmp    $0x25,%eax
  80046c:	75 e1                	jne    80044f <vprintfmt+0x11>
  80046e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800472:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800479:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800480:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800487:	ba 00 00 00 00       	mov    $0x0,%edx
  80048c:	eb 1d                	jmp    8004ab <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800490:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800494:	eb 15                	jmp    8004ab <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800496:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800498:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80049c:	eb 0d                	jmp    8004ab <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80049e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ab:	8d 5e 01             	lea    0x1(%esi),%ebx
  8004ae:	0f b6 0e             	movzbl (%esi),%ecx
  8004b1:	0f b6 c1             	movzbl %cl,%eax
  8004b4:	83 e9 23             	sub    $0x23,%ecx
  8004b7:	80 f9 55             	cmp    $0x55,%cl
  8004ba:	0f 87 2a 03 00 00    	ja     8007ea <vprintfmt+0x3ac>
  8004c0:	0f b6 c9             	movzbl %cl,%ecx
  8004c3:	ff 24 8d a0 33 80 00 	jmp    *0x8033a0(,%ecx,4)
  8004ca:	89 de                	mov    %ebx,%esi
  8004cc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004d1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004d4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004d8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004db:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004de:	83 fb 09             	cmp    $0x9,%ebx
  8004e1:	77 36                	ja     800519 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004e3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004e6:	eb e9                	jmp    8004d1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004eb:	8d 48 04             	lea    0x4(%eax),%ecx
  8004ee:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004f8:	eb 22                	jmp    80051c <vprintfmt+0xde>
  8004fa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004fd:	85 c9                	test   %ecx,%ecx
  8004ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800504:	0f 49 c1             	cmovns %ecx,%eax
  800507:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	89 de                	mov    %ebx,%esi
  80050c:	eb 9d                	jmp    8004ab <vprintfmt+0x6d>
  80050e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800510:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800517:	eb 92                	jmp    8004ab <vprintfmt+0x6d>
  800519:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80051c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800520:	79 89                	jns    8004ab <vprintfmt+0x6d>
  800522:	e9 77 ff ff ff       	jmp    80049e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800527:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80052c:	e9 7a ff ff ff       	jmp    8004ab <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8d 50 04             	lea    0x4(%eax),%edx
  800537:	89 55 14             	mov    %edx,0x14(%ebp)
  80053a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	89 04 24             	mov    %eax,(%esp)
  800543:	ff 55 08             	call   *0x8(%ebp)
			break;
  800546:	e9 18 ff ff ff       	jmp    800463 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	8d 50 04             	lea    0x4(%eax),%edx
  800551:	89 55 14             	mov    %edx,0x14(%ebp)
  800554:	8b 00                	mov    (%eax),%eax
  800556:	99                   	cltd   
  800557:	31 d0                	xor    %edx,%eax
  800559:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80055b:	83 f8 11             	cmp    $0x11,%eax
  80055e:	7f 0b                	jg     80056b <vprintfmt+0x12d>
  800560:	8b 14 85 00 35 80 00 	mov    0x803500(,%eax,4),%edx
  800567:	85 d2                	test   %edx,%edx
  800569:	75 20                	jne    80058b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80056b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80056f:	c7 44 24 08 73 32 80 	movl   $0x803273,0x8(%esp)
  800576:	00 
  800577:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80057b:	8b 45 08             	mov    0x8(%ebp),%eax
  80057e:	89 04 24             	mov    %eax,(%esp)
  800581:	e8 90 fe ff ff       	call   800416 <printfmt>
  800586:	e9 d8 fe ff ff       	jmp    800463 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80058b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80058f:	c7 44 24 08 3d 36 80 	movl   $0x80363d,0x8(%esp)
  800596:	00 
  800597:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	89 04 24             	mov    %eax,(%esp)
  8005a1:	e8 70 fe ff ff       	call   800416 <printfmt>
  8005a6:	e9 b8 fe ff ff       	jmp    800463 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ab:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8d 50 04             	lea    0x4(%eax),%edx
  8005ba:	89 55 14             	mov    %edx,0x14(%ebp)
  8005bd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8005bf:	85 f6                	test   %esi,%esi
  8005c1:	b8 6c 32 80 00       	mov    $0x80326c,%eax
  8005c6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8005c9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8005cd:	0f 84 97 00 00 00    	je     80066a <vprintfmt+0x22c>
  8005d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005d7:	0f 8e 9b 00 00 00    	jle    800678 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005dd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005e1:	89 34 24             	mov    %esi,(%esp)
  8005e4:	e8 cf 02 00 00       	call   8008b8 <strnlen>
  8005e9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ec:	29 c2                	sub    %eax,%edx
  8005ee:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8005f1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005f8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800601:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800603:	eb 0f                	jmp    800614 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800605:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800609:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060c:	89 04 24             	mov    %eax,(%esp)
  80060f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800611:	83 eb 01             	sub    $0x1,%ebx
  800614:	85 db                	test   %ebx,%ebx
  800616:	7f ed                	jg     800605 <vprintfmt+0x1c7>
  800618:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80061b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80061e:	85 d2                	test   %edx,%edx
  800620:	b8 00 00 00 00       	mov    $0x0,%eax
  800625:	0f 49 c2             	cmovns %edx,%eax
  800628:	29 c2                	sub    %eax,%edx
  80062a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80062d:	89 d7                	mov    %edx,%edi
  80062f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800632:	eb 50                	jmp    800684 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800634:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800638:	74 1e                	je     800658 <vprintfmt+0x21a>
  80063a:	0f be d2             	movsbl %dl,%edx
  80063d:	83 ea 20             	sub    $0x20,%edx
  800640:	83 fa 5e             	cmp    $0x5e,%edx
  800643:	76 13                	jbe    800658 <vprintfmt+0x21a>
					putch('?', putdat);
  800645:	8b 45 0c             	mov    0xc(%ebp),%eax
  800648:	89 44 24 04          	mov    %eax,0x4(%esp)
  80064c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800653:	ff 55 08             	call   *0x8(%ebp)
  800656:	eb 0d                	jmp    800665 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80065b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80065f:	89 04 24             	mov    %eax,(%esp)
  800662:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800665:	83 ef 01             	sub    $0x1,%edi
  800668:	eb 1a                	jmp    800684 <vprintfmt+0x246>
  80066a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80066d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800670:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800673:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800676:	eb 0c                	jmp    800684 <vprintfmt+0x246>
  800678:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80067b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80067e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800681:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800684:	83 c6 01             	add    $0x1,%esi
  800687:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80068b:	0f be c2             	movsbl %dl,%eax
  80068e:	85 c0                	test   %eax,%eax
  800690:	74 27                	je     8006b9 <vprintfmt+0x27b>
  800692:	85 db                	test   %ebx,%ebx
  800694:	78 9e                	js     800634 <vprintfmt+0x1f6>
  800696:	83 eb 01             	sub    $0x1,%ebx
  800699:	79 99                	jns    800634 <vprintfmt+0x1f6>
  80069b:	89 f8                	mov    %edi,%eax
  80069d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8006a3:	89 c3                	mov    %eax,%ebx
  8006a5:	eb 1a                	jmp    8006c1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ab:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006b2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006b4:	83 eb 01             	sub    $0x1,%ebx
  8006b7:	eb 08                	jmp    8006c1 <vprintfmt+0x283>
  8006b9:	89 fb                	mov    %edi,%ebx
  8006bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006be:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006c1:	85 db                	test   %ebx,%ebx
  8006c3:	7f e2                	jg     8006a7 <vprintfmt+0x269>
  8006c5:	89 75 08             	mov    %esi,0x8(%ebp)
  8006c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006cb:	e9 93 fd ff ff       	jmp    800463 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006d0:	83 fa 01             	cmp    $0x1,%edx
  8006d3:	7e 16                	jle    8006eb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	8d 50 08             	lea    0x8(%eax),%edx
  8006db:	89 55 14             	mov    %edx,0x14(%ebp)
  8006de:	8b 50 04             	mov    0x4(%eax),%edx
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006e9:	eb 32                	jmp    80071d <vprintfmt+0x2df>
	else if (lflag)
  8006eb:	85 d2                	test   %edx,%edx
  8006ed:	74 18                	je     800707 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8d 50 04             	lea    0x4(%eax),%edx
  8006f5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006f8:	8b 30                	mov    (%eax),%esi
  8006fa:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006fd:	89 f0                	mov    %esi,%eax
  8006ff:	c1 f8 1f             	sar    $0x1f,%eax
  800702:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800705:	eb 16                	jmp    80071d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8d 50 04             	lea    0x4(%eax),%edx
  80070d:	89 55 14             	mov    %edx,0x14(%ebp)
  800710:	8b 30                	mov    (%eax),%esi
  800712:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800715:	89 f0                	mov    %esi,%eax
  800717:	c1 f8 1f             	sar    $0x1f,%eax
  80071a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80071d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800720:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800723:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800728:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072c:	0f 89 80 00 00 00    	jns    8007b2 <vprintfmt+0x374>
				putch('-', putdat);
  800732:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800736:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80073d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800740:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800743:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800746:	f7 d8                	neg    %eax
  800748:	83 d2 00             	adc    $0x0,%edx
  80074b:	f7 da                	neg    %edx
			}
			base = 10;
  80074d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800752:	eb 5e                	jmp    8007b2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800754:	8d 45 14             	lea    0x14(%ebp),%eax
  800757:	e8 63 fc ff ff       	call   8003bf <getuint>
			base = 10;
  80075c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800761:	eb 4f                	jmp    8007b2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800763:	8d 45 14             	lea    0x14(%ebp),%eax
  800766:	e8 54 fc ff ff       	call   8003bf <getuint>
			base = 8;
  80076b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800770:	eb 40                	jmp    8007b2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800772:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800776:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80077d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800780:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800784:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80078b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80078e:	8b 45 14             	mov    0x14(%ebp),%eax
  800791:	8d 50 04             	lea    0x4(%eax),%edx
  800794:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800797:	8b 00                	mov    (%eax),%eax
  800799:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80079e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007a3:	eb 0d                	jmp    8007b2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007a5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a8:	e8 12 fc ff ff       	call   8003bf <getuint>
			base = 16;
  8007ad:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007b2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8007b6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007ba:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8007bd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007c1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007c5:	89 04 24             	mov    %eax,(%esp)
  8007c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007cc:	89 fa                	mov    %edi,%edx
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	e8 fa fa ff ff       	call   8002d0 <printnum>
			break;
  8007d6:	e9 88 fc ff ff       	jmp    800463 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007db:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007df:	89 04 24             	mov    %eax,(%esp)
  8007e2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007e5:	e9 79 fc ff ff       	jmp    800463 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ee:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007f5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f8:	89 f3                	mov    %esi,%ebx
  8007fa:	eb 03                	jmp    8007ff <vprintfmt+0x3c1>
  8007fc:	83 eb 01             	sub    $0x1,%ebx
  8007ff:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800803:	75 f7                	jne    8007fc <vprintfmt+0x3be>
  800805:	e9 59 fc ff ff       	jmp    800463 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80080a:	83 c4 3c             	add    $0x3c,%esp
  80080d:	5b                   	pop    %ebx
  80080e:	5e                   	pop    %esi
  80080f:	5f                   	pop    %edi
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	83 ec 28             	sub    $0x28,%esp
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80081e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800821:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800825:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800828:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80082f:	85 c0                	test   %eax,%eax
  800831:	74 30                	je     800863 <vsnprintf+0x51>
  800833:	85 d2                	test   %edx,%edx
  800835:	7e 2c                	jle    800863 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80083e:	8b 45 10             	mov    0x10(%ebp),%eax
  800841:	89 44 24 08          	mov    %eax,0x8(%esp)
  800845:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800848:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084c:	c7 04 24 f9 03 80 00 	movl   $0x8003f9,(%esp)
  800853:	e8 e6 fb ff ff       	call   80043e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800858:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80085b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80085e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800861:	eb 05                	jmp    800868 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800863:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800868:	c9                   	leave  
  800869:	c3                   	ret    

0080086a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800870:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800873:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800877:	8b 45 10             	mov    0x10(%ebp),%eax
  80087a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80087e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800881:	89 44 24 04          	mov    %eax,0x4(%esp)
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	89 04 24             	mov    %eax,(%esp)
  80088b:	e8 82 ff ff ff       	call   800812 <vsnprintf>
	va_end(ap);

	return rc;
}
  800890:	c9                   	leave  
  800891:	c3                   	ret    
  800892:	66 90                	xchg   %ax,%ax
  800894:	66 90                	xchg   %ax,%ax
  800896:	66 90                	xchg   %ax,%ax
  800898:	66 90                	xchg   %ax,%ax
  80089a:	66 90                	xchg   %ax,%ax
  80089c:	66 90                	xchg   %ax,%ax
  80089e:	66 90                	xchg   %ax,%ax

008008a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ab:	eb 03                	jmp    8008b0 <strlen+0x10>
		n++;
  8008ad:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b4:	75 f7                	jne    8008ad <strlen+0xd>
		n++;
	return n;
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008be:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c6:	eb 03                	jmp    8008cb <strnlen+0x13>
		n++;
  8008c8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008cb:	39 d0                	cmp    %edx,%eax
  8008cd:	74 06                	je     8008d5 <strnlen+0x1d>
  8008cf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008d3:	75 f3                	jne    8008c8 <strnlen+0x10>
		n++;
	return n;
}
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	53                   	push   %ebx
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e1:	89 c2                	mov    %eax,%edx
  8008e3:	83 c2 01             	add    $0x1,%edx
  8008e6:	83 c1 01             	add    $0x1,%ecx
  8008e9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008ed:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008f0:	84 db                	test   %bl,%bl
  8008f2:	75 ef                	jne    8008e3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008f4:	5b                   	pop    %ebx
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	53                   	push   %ebx
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800901:	89 1c 24             	mov    %ebx,(%esp)
  800904:	e8 97 ff ff ff       	call   8008a0 <strlen>
	strcpy(dst + len, src);
  800909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800910:	01 d8                	add    %ebx,%eax
  800912:	89 04 24             	mov    %eax,(%esp)
  800915:	e8 bd ff ff ff       	call   8008d7 <strcpy>
	return dst;
}
  80091a:	89 d8                	mov    %ebx,%eax
  80091c:	83 c4 08             	add    $0x8,%esp
  80091f:	5b                   	pop    %ebx
  800920:	5d                   	pop    %ebp
  800921:	c3                   	ret    

00800922 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	56                   	push   %esi
  800926:	53                   	push   %ebx
  800927:	8b 75 08             	mov    0x8(%ebp),%esi
  80092a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80092d:	89 f3                	mov    %esi,%ebx
  80092f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800932:	89 f2                	mov    %esi,%edx
  800934:	eb 0f                	jmp    800945 <strncpy+0x23>
		*dst++ = *src;
  800936:	83 c2 01             	add    $0x1,%edx
  800939:	0f b6 01             	movzbl (%ecx),%eax
  80093c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80093f:	80 39 01             	cmpb   $0x1,(%ecx)
  800942:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800945:	39 da                	cmp    %ebx,%edx
  800947:	75 ed                	jne    800936 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800949:	89 f0                	mov    %esi,%eax
  80094b:	5b                   	pop    %ebx
  80094c:	5e                   	pop    %esi
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	56                   	push   %esi
  800953:	53                   	push   %ebx
  800954:	8b 75 08             	mov    0x8(%ebp),%esi
  800957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80095d:	89 f0                	mov    %esi,%eax
  80095f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800963:	85 c9                	test   %ecx,%ecx
  800965:	75 0b                	jne    800972 <strlcpy+0x23>
  800967:	eb 1d                	jmp    800986 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800969:	83 c0 01             	add    $0x1,%eax
  80096c:	83 c2 01             	add    $0x1,%edx
  80096f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800972:	39 d8                	cmp    %ebx,%eax
  800974:	74 0b                	je     800981 <strlcpy+0x32>
  800976:	0f b6 0a             	movzbl (%edx),%ecx
  800979:	84 c9                	test   %cl,%cl
  80097b:	75 ec                	jne    800969 <strlcpy+0x1a>
  80097d:	89 c2                	mov    %eax,%edx
  80097f:	eb 02                	jmp    800983 <strlcpy+0x34>
  800981:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800983:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800986:	29 f0                	sub    %esi,%eax
}
  800988:	5b                   	pop    %ebx
  800989:	5e                   	pop    %esi
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800992:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800995:	eb 06                	jmp    80099d <strcmp+0x11>
		p++, q++;
  800997:	83 c1 01             	add    $0x1,%ecx
  80099a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80099d:	0f b6 01             	movzbl (%ecx),%eax
  8009a0:	84 c0                	test   %al,%al
  8009a2:	74 04                	je     8009a8 <strcmp+0x1c>
  8009a4:	3a 02                	cmp    (%edx),%al
  8009a6:	74 ef                	je     800997 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a8:	0f b6 c0             	movzbl %al,%eax
  8009ab:	0f b6 12             	movzbl (%edx),%edx
  8009ae:	29 d0                	sub    %edx,%eax
}
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    

008009b2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	53                   	push   %ebx
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bc:	89 c3                	mov    %eax,%ebx
  8009be:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c1:	eb 06                	jmp    8009c9 <strncmp+0x17>
		n--, p++, q++;
  8009c3:	83 c0 01             	add    $0x1,%eax
  8009c6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009c9:	39 d8                	cmp    %ebx,%eax
  8009cb:	74 15                	je     8009e2 <strncmp+0x30>
  8009cd:	0f b6 08             	movzbl (%eax),%ecx
  8009d0:	84 c9                	test   %cl,%cl
  8009d2:	74 04                	je     8009d8 <strncmp+0x26>
  8009d4:	3a 0a                	cmp    (%edx),%cl
  8009d6:	74 eb                	je     8009c3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d8:	0f b6 00             	movzbl (%eax),%eax
  8009db:	0f b6 12             	movzbl (%edx),%edx
  8009de:	29 d0                	sub    %edx,%eax
  8009e0:	eb 05                	jmp    8009e7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009e2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009e7:	5b                   	pop    %ebx
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f4:	eb 07                	jmp    8009fd <strchr+0x13>
		if (*s == c)
  8009f6:	38 ca                	cmp    %cl,%dl
  8009f8:	74 0f                	je     800a09 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009fa:	83 c0 01             	add    $0x1,%eax
  8009fd:	0f b6 10             	movzbl (%eax),%edx
  800a00:	84 d2                	test   %dl,%dl
  800a02:	75 f2                	jne    8009f6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a15:	eb 07                	jmp    800a1e <strfind+0x13>
		if (*s == c)
  800a17:	38 ca                	cmp    %cl,%dl
  800a19:	74 0a                	je     800a25 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a1b:	83 c0 01             	add    $0x1,%eax
  800a1e:	0f b6 10             	movzbl (%eax),%edx
  800a21:	84 d2                	test   %dl,%dl
  800a23:	75 f2                	jne    800a17 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	57                   	push   %edi
  800a2b:	56                   	push   %esi
  800a2c:	53                   	push   %ebx
  800a2d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a30:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a33:	85 c9                	test   %ecx,%ecx
  800a35:	74 36                	je     800a6d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a37:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a3d:	75 28                	jne    800a67 <memset+0x40>
  800a3f:	f6 c1 03             	test   $0x3,%cl
  800a42:	75 23                	jne    800a67 <memset+0x40>
		c &= 0xFF;
  800a44:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a48:	89 d3                	mov    %edx,%ebx
  800a4a:	c1 e3 08             	shl    $0x8,%ebx
  800a4d:	89 d6                	mov    %edx,%esi
  800a4f:	c1 e6 18             	shl    $0x18,%esi
  800a52:	89 d0                	mov    %edx,%eax
  800a54:	c1 e0 10             	shl    $0x10,%eax
  800a57:	09 f0                	or     %esi,%eax
  800a59:	09 c2                	or     %eax,%edx
  800a5b:	89 d0                	mov    %edx,%eax
  800a5d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a5f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a62:	fc                   	cld    
  800a63:	f3 ab                	rep stos %eax,%es:(%edi)
  800a65:	eb 06                	jmp    800a6d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	fc                   	cld    
  800a6b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a6d:	89 f8                	mov    %edi,%eax
  800a6f:	5b                   	pop    %ebx
  800a70:	5e                   	pop    %esi
  800a71:	5f                   	pop    %edi
  800a72:	5d                   	pop    %ebp
  800a73:	c3                   	ret    

00800a74 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	57                   	push   %edi
  800a78:	56                   	push   %esi
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a82:	39 c6                	cmp    %eax,%esi
  800a84:	73 35                	jae    800abb <memmove+0x47>
  800a86:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a89:	39 d0                	cmp    %edx,%eax
  800a8b:	73 2e                	jae    800abb <memmove+0x47>
		s += n;
		d += n;
  800a8d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a90:	89 d6                	mov    %edx,%esi
  800a92:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a94:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a9a:	75 13                	jne    800aaf <memmove+0x3b>
  800a9c:	f6 c1 03             	test   $0x3,%cl
  800a9f:	75 0e                	jne    800aaf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa1:	83 ef 04             	sub    $0x4,%edi
  800aa4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aaa:	fd                   	std    
  800aab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aad:	eb 09                	jmp    800ab8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aaf:	83 ef 01             	sub    $0x1,%edi
  800ab2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ab5:	fd                   	std    
  800ab6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab8:	fc                   	cld    
  800ab9:	eb 1d                	jmp    800ad8 <memmove+0x64>
  800abb:	89 f2                	mov    %esi,%edx
  800abd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abf:	f6 c2 03             	test   $0x3,%dl
  800ac2:	75 0f                	jne    800ad3 <memmove+0x5f>
  800ac4:	f6 c1 03             	test   $0x3,%cl
  800ac7:	75 0a                	jne    800ad3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800acc:	89 c7                	mov    %eax,%edi
  800ace:	fc                   	cld    
  800acf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad1:	eb 05                	jmp    800ad8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ad3:	89 c7                	mov    %eax,%edi
  800ad5:	fc                   	cld    
  800ad6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad8:	5e                   	pop    %esi
  800ad9:	5f                   	pop    %edi
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	89 04 24             	mov    %eax,(%esp)
  800af6:	e8 79 ff ff ff       	call   800a74 <memmove>
}
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	56                   	push   %esi
  800b01:	53                   	push   %ebx
  800b02:	8b 55 08             	mov    0x8(%ebp),%edx
  800b05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b08:	89 d6                	mov    %edx,%esi
  800b0a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0d:	eb 1a                	jmp    800b29 <memcmp+0x2c>
		if (*s1 != *s2)
  800b0f:	0f b6 02             	movzbl (%edx),%eax
  800b12:	0f b6 19             	movzbl (%ecx),%ebx
  800b15:	38 d8                	cmp    %bl,%al
  800b17:	74 0a                	je     800b23 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b19:	0f b6 c0             	movzbl %al,%eax
  800b1c:	0f b6 db             	movzbl %bl,%ebx
  800b1f:	29 d8                	sub    %ebx,%eax
  800b21:	eb 0f                	jmp    800b32 <memcmp+0x35>
		s1++, s2++;
  800b23:	83 c2 01             	add    $0x1,%edx
  800b26:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b29:	39 f2                	cmp    %esi,%edx
  800b2b:	75 e2                	jne    800b0f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b32:	5b                   	pop    %ebx
  800b33:	5e                   	pop    %esi
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b3f:	89 c2                	mov    %eax,%edx
  800b41:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b44:	eb 07                	jmp    800b4d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b46:	38 08                	cmp    %cl,(%eax)
  800b48:	74 07                	je     800b51 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b4a:	83 c0 01             	add    $0x1,%eax
  800b4d:	39 d0                	cmp    %edx,%eax
  800b4f:	72 f5                	jb     800b46 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	57                   	push   %edi
  800b57:	56                   	push   %esi
  800b58:	53                   	push   %ebx
  800b59:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5f:	eb 03                	jmp    800b64 <strtol+0x11>
		s++;
  800b61:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b64:	0f b6 0a             	movzbl (%edx),%ecx
  800b67:	80 f9 09             	cmp    $0x9,%cl
  800b6a:	74 f5                	je     800b61 <strtol+0xe>
  800b6c:	80 f9 20             	cmp    $0x20,%cl
  800b6f:	74 f0                	je     800b61 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b71:	80 f9 2b             	cmp    $0x2b,%cl
  800b74:	75 0a                	jne    800b80 <strtol+0x2d>
		s++;
  800b76:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b79:	bf 00 00 00 00       	mov    $0x0,%edi
  800b7e:	eb 11                	jmp    800b91 <strtol+0x3e>
  800b80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b85:	80 f9 2d             	cmp    $0x2d,%cl
  800b88:	75 07                	jne    800b91 <strtol+0x3e>
		s++, neg = 1;
  800b8a:	8d 52 01             	lea    0x1(%edx),%edx
  800b8d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b91:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b96:	75 15                	jne    800bad <strtol+0x5a>
  800b98:	80 3a 30             	cmpb   $0x30,(%edx)
  800b9b:	75 10                	jne    800bad <strtol+0x5a>
  800b9d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ba1:	75 0a                	jne    800bad <strtol+0x5a>
		s += 2, base = 16;
  800ba3:	83 c2 02             	add    $0x2,%edx
  800ba6:	b8 10 00 00 00       	mov    $0x10,%eax
  800bab:	eb 10                	jmp    800bbd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800bad:	85 c0                	test   %eax,%eax
  800baf:	75 0c                	jne    800bbd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bb1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bb6:	75 05                	jne    800bbd <strtol+0x6a>
		s++, base = 8;
  800bb8:	83 c2 01             	add    $0x1,%edx
  800bbb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bc2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bc5:	0f b6 0a             	movzbl (%edx),%ecx
  800bc8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bcb:	89 f0                	mov    %esi,%eax
  800bcd:	3c 09                	cmp    $0x9,%al
  800bcf:	77 08                	ja     800bd9 <strtol+0x86>
			dig = *s - '0';
  800bd1:	0f be c9             	movsbl %cl,%ecx
  800bd4:	83 e9 30             	sub    $0x30,%ecx
  800bd7:	eb 20                	jmp    800bf9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800bd9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bdc:	89 f0                	mov    %esi,%eax
  800bde:	3c 19                	cmp    $0x19,%al
  800be0:	77 08                	ja     800bea <strtol+0x97>
			dig = *s - 'a' + 10;
  800be2:	0f be c9             	movsbl %cl,%ecx
  800be5:	83 e9 57             	sub    $0x57,%ecx
  800be8:	eb 0f                	jmp    800bf9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bea:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bed:	89 f0                	mov    %esi,%eax
  800bef:	3c 19                	cmp    $0x19,%al
  800bf1:	77 16                	ja     800c09 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800bf3:	0f be c9             	movsbl %cl,%ecx
  800bf6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bf9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bfc:	7d 0f                	jge    800c0d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bfe:	83 c2 01             	add    $0x1,%edx
  800c01:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c05:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c07:	eb bc                	jmp    800bc5 <strtol+0x72>
  800c09:	89 d8                	mov    %ebx,%eax
  800c0b:	eb 02                	jmp    800c0f <strtol+0xbc>
  800c0d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c13:	74 05                	je     800c1a <strtol+0xc7>
		*endptr = (char *) s;
  800c15:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c18:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c1a:	f7 d8                	neg    %eax
  800c1c:	85 ff                	test   %edi,%edi
  800c1e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	57                   	push   %edi
  800c2a:	56                   	push   %esi
  800c2b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c34:	8b 55 08             	mov    0x8(%ebp),%edx
  800c37:	89 c3                	mov    %eax,%ebx
  800c39:	89 c7                	mov    %eax,%edi
  800c3b:	89 c6                	mov    %eax,%esi
  800c3d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c54:	89 d1                	mov    %edx,%ecx
  800c56:	89 d3                	mov    %edx,%ebx
  800c58:	89 d7                	mov    %edx,%edi
  800c5a:	89 d6                	mov    %edx,%esi
  800c5c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c5e:	5b                   	pop    %ebx
  800c5f:	5e                   	pop    %esi
  800c60:	5f                   	pop    %edi
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
  800c69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c71:	b8 03 00 00 00       	mov    $0x3,%eax
  800c76:	8b 55 08             	mov    0x8(%ebp),%edx
  800c79:	89 cb                	mov    %ecx,%ebx
  800c7b:	89 cf                	mov    %ecx,%edi
  800c7d:	89 ce                	mov    %ecx,%esi
  800c7f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c81:	85 c0                	test   %eax,%eax
  800c83:	7e 28                	jle    800cad <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c85:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c89:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c90:	00 
  800c91:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  800c98:	00 
  800c99:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ca0:	00 
  800ca1:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  800ca8:	e8 0c f5 ff ff       	call   8001b9 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cad:	83 c4 2c             	add    $0x2c,%esp
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    

00800cb5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	57                   	push   %edi
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc0:	b8 02 00 00 00       	mov    $0x2,%eax
  800cc5:	89 d1                	mov    %edx,%ecx
  800cc7:	89 d3                	mov    %edx,%ebx
  800cc9:	89 d7                	mov    %edx,%edi
  800ccb:	89 d6                	mov    %edx,%esi
  800ccd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <sys_yield>:

void
sys_yield(void)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cda:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ce4:	89 d1                	mov    %edx,%ecx
  800ce6:	89 d3                	mov    %edx,%ebx
  800ce8:	89 d7                	mov    %edx,%edi
  800cea:	89 d6                	mov    %edx,%esi
  800cec:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
  800cf9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfc:	be 00 00 00 00       	mov    $0x0,%esi
  800d01:	b8 04 00 00 00       	mov    $0x4,%eax
  800d06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d09:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0f:	89 f7                	mov    %esi,%edi
  800d11:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	7e 28                	jle    800d3f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d17:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d1b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d22:	00 
  800d23:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  800d2a:	00 
  800d2b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d32:	00 
  800d33:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  800d3a:	e8 7a f4 ff ff       	call   8001b9 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d3f:	83 c4 2c             	add    $0x2c,%esp
  800d42:	5b                   	pop    %ebx
  800d43:	5e                   	pop    %esi
  800d44:	5f                   	pop    %edi
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	57                   	push   %edi
  800d4b:	56                   	push   %esi
  800d4c:	53                   	push   %ebx
  800d4d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d50:	b8 05 00 00 00       	mov    $0x5,%eax
  800d55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d58:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d61:	8b 75 18             	mov    0x18(%ebp),%esi
  800d64:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d66:	85 c0                	test   %eax,%eax
  800d68:	7e 28                	jle    800d92 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d6e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d75:	00 
  800d76:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  800d7d:	00 
  800d7e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d85:	00 
  800d86:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  800d8d:	e8 27 f4 ff ff       	call   8001b9 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d92:	83 c4 2c             	add    $0x2c,%esp
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	57                   	push   %edi
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
  800da0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da8:	b8 06 00 00 00       	mov    $0x6,%eax
  800dad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	89 df                	mov    %ebx,%edi
  800db5:	89 de                	mov    %ebx,%esi
  800db7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800db9:	85 c0                	test   %eax,%eax
  800dbb:	7e 28                	jle    800de5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800dc8:	00 
  800dc9:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  800dd0:	00 
  800dd1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dd8:	00 
  800dd9:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  800de0:	e8 d4 f3 ff ff       	call   8001b9 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800de5:	83 c4 2c             	add    $0x2c,%esp
  800de8:	5b                   	pop    %ebx
  800de9:	5e                   	pop    %esi
  800dea:	5f                   	pop    %edi
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    

00800ded <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	57                   	push   %edi
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
  800df3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfb:	b8 08 00 00 00       	mov    $0x8,%eax
  800e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e03:	8b 55 08             	mov    0x8(%ebp),%edx
  800e06:	89 df                	mov    %ebx,%edi
  800e08:	89 de                	mov    %ebx,%esi
  800e0a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	7e 28                	jle    800e38 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e10:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e14:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e1b:	00 
  800e1c:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  800e23:	00 
  800e24:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2b:	00 
  800e2c:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  800e33:	e8 81 f3 ff ff       	call   8001b9 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e38:	83 c4 2c             	add    $0x2c,%esp
  800e3b:	5b                   	pop    %ebx
  800e3c:	5e                   	pop    %esi
  800e3d:	5f                   	pop    %edi
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	57                   	push   %edi
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
  800e46:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e56:	8b 55 08             	mov    0x8(%ebp),%edx
  800e59:	89 df                	mov    %ebx,%edi
  800e5b:	89 de                	mov    %ebx,%esi
  800e5d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	7e 28                	jle    800e8b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e63:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e67:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e6e:	00 
  800e6f:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  800e76:	00 
  800e77:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e7e:	00 
  800e7f:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  800e86:	e8 2e f3 ff ff       	call   8001b9 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e8b:	83 c4 2c             	add    $0x2c,%esp
  800e8e:	5b                   	pop    %ebx
  800e8f:	5e                   	pop    %esi
  800e90:	5f                   	pop    %edi
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    

00800e93 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	57                   	push   %edi
  800e97:	56                   	push   %esi
  800e98:	53                   	push   %ebx
  800e99:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eac:	89 df                	mov    %ebx,%edi
  800eae:	89 de                	mov    %ebx,%esi
  800eb0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	7e 28                	jle    800ede <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eba:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ec1:	00 
  800ec2:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  800ec9:	00 
  800eca:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed1:	00 
  800ed2:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  800ed9:	e8 db f2 ff ff       	call   8001b9 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ede:	83 c4 2c             	add    $0x2c,%esp
  800ee1:	5b                   	pop    %ebx
  800ee2:	5e                   	pop    %esi
  800ee3:	5f                   	pop    %edi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    

00800ee6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	57                   	push   %edi
  800eea:	56                   	push   %esi
  800eeb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eec:	be 00 00 00 00       	mov    $0x0,%esi
  800ef1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eff:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f02:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f04:	5b                   	pop    %ebx
  800f05:	5e                   	pop    %esi
  800f06:	5f                   	pop    %edi
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    

00800f09 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	57                   	push   %edi
  800f0d:	56                   	push   %esi
  800f0e:	53                   	push   %ebx
  800f0f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f12:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f17:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1f:	89 cb                	mov    %ecx,%ebx
  800f21:	89 cf                	mov    %ecx,%edi
  800f23:	89 ce                	mov    %ecx,%esi
  800f25:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f27:	85 c0                	test   %eax,%eax
  800f29:	7e 28                	jle    800f53 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f36:	00 
  800f37:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  800f3e:	00 
  800f3f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f46:	00 
  800f47:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  800f4e:	e8 66 f2 ff ff       	call   8001b9 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f53:	83 c4 2c             	add    $0x2c,%esp
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	57                   	push   %edi
  800f5f:	56                   	push   %esi
  800f60:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f61:	ba 00 00 00 00       	mov    $0x0,%edx
  800f66:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f6b:	89 d1                	mov    %edx,%ecx
  800f6d:	89 d3                	mov    %edx,%ebx
  800f6f:	89 d7                	mov    %edx,%edi
  800f71:	89 d6                	mov    %edx,%esi
  800f73:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f75:	5b                   	pop    %ebx
  800f76:	5e                   	pop    %esi
  800f77:	5f                   	pop    %edi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    

00800f7a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	57                   	push   %edi
  800f7e:	56                   	push   %esi
  800f7f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f80:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f85:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	89 df                	mov    %ebx,%edi
  800f92:	89 de                	mov    %ebx,%esi
  800f94:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800f96:	5b                   	pop    %ebx
  800f97:	5e                   	pop    %esi
  800f98:	5f                   	pop    %edi
  800f99:	5d                   	pop    %ebp
  800f9a:	c3                   	ret    

00800f9b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	57                   	push   %edi
  800f9f:	56                   	push   %esi
  800fa0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa6:	b8 10 00 00 00       	mov    $0x10,%eax
  800fab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fae:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb1:	89 df                	mov    %ebx,%edi
  800fb3:	89 de                	mov    %ebx,%esi
  800fb5:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800fb7:	5b                   	pop    %ebx
  800fb8:	5e                   	pop    %esi
  800fb9:	5f                   	pop    %edi
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    

00800fbc <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	57                   	push   %edi
  800fc0:	56                   	push   %esi
  800fc1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fc7:	b8 11 00 00 00       	mov    $0x11,%eax
  800fcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcf:	89 cb                	mov    %ecx,%ebx
  800fd1:	89 cf                	mov    %ecx,%edi
  800fd3:	89 ce                	mov    %ecx,%esi
  800fd5:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800fd7:	5b                   	pop    %ebx
  800fd8:	5e                   	pop    %esi
  800fd9:	5f                   	pop    %edi
  800fda:	5d                   	pop    %ebp
  800fdb:	c3                   	ret    

00800fdc <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	57                   	push   %edi
  800fe0:	56                   	push   %esi
  800fe1:	53                   	push   %ebx
  800fe2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe5:	be 00 00 00 00       	mov    $0x0,%esi
  800fea:	b8 12 00 00 00       	mov    $0x12,%eax
  800fef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ffb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ffd:	85 c0                	test   %eax,%eax
  800fff:	7e 28                	jle    801029 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801001:	89 44 24 10          	mov    %eax,0x10(%esp)
  801005:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80100c:	00 
  80100d:	c7 44 24 08 67 35 80 	movl   $0x803567,0x8(%esp)
  801014:	00 
  801015:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80101c:	00 
  80101d:	c7 04 24 84 35 80 00 	movl   $0x803584,(%esp)
  801024:	e8 90 f1 ff ff       	call   8001b9 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801029:	83 c4 2c             	add    $0x2c,%esp
  80102c:	5b                   	pop    %ebx
  80102d:	5e                   	pop    %esi
  80102e:	5f                   	pop    %edi
  80102f:	5d                   	pop    %ebp
  801030:	c3                   	ret    
  801031:	66 90                	xchg   %ax,%ax
  801033:	66 90                	xchg   %ax,%ax
  801035:	66 90                	xchg   %ax,%ax
  801037:	66 90                	xchg   %ax,%ax
  801039:	66 90                	xchg   %ax,%ax
  80103b:	66 90                	xchg   %ax,%ax
  80103d:	66 90                	xchg   %ax,%ax
  80103f:	90                   	nop

00801040 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	05 00 00 00 30       	add    $0x30000000,%eax
  80104b:	c1 e8 0c             	shr    $0xc,%eax
}
  80104e:	5d                   	pop    %ebp
  80104f:	c3                   	ret    

00801050 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80105b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801060:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801065:	5d                   	pop    %ebp
  801066:	c3                   	ret    

00801067 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80106d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801072:	89 c2                	mov    %eax,%edx
  801074:	c1 ea 16             	shr    $0x16,%edx
  801077:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80107e:	f6 c2 01             	test   $0x1,%dl
  801081:	74 11                	je     801094 <fd_alloc+0x2d>
  801083:	89 c2                	mov    %eax,%edx
  801085:	c1 ea 0c             	shr    $0xc,%edx
  801088:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80108f:	f6 c2 01             	test   $0x1,%dl
  801092:	75 09                	jne    80109d <fd_alloc+0x36>
			*fd_store = fd;
  801094:	89 01                	mov    %eax,(%ecx)
			return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
  80109b:	eb 17                	jmp    8010b4 <fd_alloc+0x4d>
  80109d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010a2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010a7:	75 c9                	jne    801072 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010a9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8010af:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010bc:	83 f8 1f             	cmp    $0x1f,%eax
  8010bf:	77 36                	ja     8010f7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010c1:	c1 e0 0c             	shl    $0xc,%eax
  8010c4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010c9:	89 c2                	mov    %eax,%edx
  8010cb:	c1 ea 16             	shr    $0x16,%edx
  8010ce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010d5:	f6 c2 01             	test   $0x1,%dl
  8010d8:	74 24                	je     8010fe <fd_lookup+0x48>
  8010da:	89 c2                	mov    %eax,%edx
  8010dc:	c1 ea 0c             	shr    $0xc,%edx
  8010df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010e6:	f6 c2 01             	test   $0x1,%dl
  8010e9:	74 1a                	je     801105 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ee:	89 02                	mov    %eax,(%edx)
	return 0;
  8010f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f5:	eb 13                	jmp    80110a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010fc:	eb 0c                	jmp    80110a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801103:	eb 05                	jmp    80110a <fd_lookup+0x54>
  801105:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80110a:	5d                   	pop    %ebp
  80110b:	c3                   	ret    

0080110c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 18             	sub    $0x18,%esp
  801112:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801115:	ba 00 00 00 00       	mov    $0x0,%edx
  80111a:	eb 13                	jmp    80112f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80111c:	39 08                	cmp    %ecx,(%eax)
  80111e:	75 0c                	jne    80112c <dev_lookup+0x20>
			*dev = devtab[i];
  801120:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801123:	89 01                	mov    %eax,(%ecx)
			return 0;
  801125:	b8 00 00 00 00       	mov    $0x0,%eax
  80112a:	eb 38                	jmp    801164 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80112c:	83 c2 01             	add    $0x1,%edx
  80112f:	8b 04 95 10 36 80 00 	mov    0x803610(,%edx,4),%eax
  801136:	85 c0                	test   %eax,%eax
  801138:	75 e2                	jne    80111c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80113a:	a1 08 50 80 00       	mov    0x805008,%eax
  80113f:	8b 40 48             	mov    0x48(%eax),%eax
  801142:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801146:	89 44 24 04          	mov    %eax,0x4(%esp)
  80114a:	c7 04 24 94 35 80 00 	movl   $0x803594,(%esp)
  801151:	e8 5c f1 ff ff       	call   8002b2 <cprintf>
	*dev = 0;
  801156:	8b 45 0c             	mov    0xc(%ebp),%eax
  801159:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80115f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801164:	c9                   	leave  
  801165:	c3                   	ret    

00801166 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	56                   	push   %esi
  80116a:	53                   	push   %ebx
  80116b:	83 ec 20             	sub    $0x20,%esp
  80116e:	8b 75 08             	mov    0x8(%ebp),%esi
  801171:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801174:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801177:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80117b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801181:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801184:	89 04 24             	mov    %eax,(%esp)
  801187:	e8 2a ff ff ff       	call   8010b6 <fd_lookup>
  80118c:	85 c0                	test   %eax,%eax
  80118e:	78 05                	js     801195 <fd_close+0x2f>
	    || fd != fd2)
  801190:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801193:	74 0c                	je     8011a1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801195:	84 db                	test   %bl,%bl
  801197:	ba 00 00 00 00       	mov    $0x0,%edx
  80119c:	0f 44 c2             	cmove  %edx,%eax
  80119f:	eb 3f                	jmp    8011e0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011a8:	8b 06                	mov    (%esi),%eax
  8011aa:	89 04 24             	mov    %eax,(%esp)
  8011ad:	e8 5a ff ff ff       	call   80110c <dev_lookup>
  8011b2:	89 c3                	mov    %eax,%ebx
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	78 16                	js     8011ce <fd_close+0x68>
		if (dev->dev_close)
  8011b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011bb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011be:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	74 07                	je     8011ce <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8011c7:	89 34 24             	mov    %esi,(%esp)
  8011ca:	ff d0                	call   *%eax
  8011cc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d9:	e8 bc fb ff ff       	call   800d9a <sys_page_unmap>
	return r;
  8011de:	89 d8                	mov    %ebx,%eax
}
  8011e0:	83 c4 20             	add    $0x20,%esp
  8011e3:	5b                   	pop    %ebx
  8011e4:	5e                   	pop    %esi
  8011e5:	5d                   	pop    %ebp
  8011e6:	c3                   	ret    

008011e7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	89 04 24             	mov    %eax,(%esp)
  8011fa:	e8 b7 fe ff ff       	call   8010b6 <fd_lookup>
  8011ff:	89 c2                	mov    %eax,%edx
  801201:	85 d2                	test   %edx,%edx
  801203:	78 13                	js     801218 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801205:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80120c:	00 
  80120d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801210:	89 04 24             	mov    %eax,(%esp)
  801213:	e8 4e ff ff ff       	call   801166 <fd_close>
}
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <close_all>:

void
close_all(void)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	53                   	push   %ebx
  80121e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801221:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801226:	89 1c 24             	mov    %ebx,(%esp)
  801229:	e8 b9 ff ff ff       	call   8011e7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80122e:	83 c3 01             	add    $0x1,%ebx
  801231:	83 fb 20             	cmp    $0x20,%ebx
  801234:	75 f0                	jne    801226 <close_all+0xc>
		close(i);
}
  801236:	83 c4 14             	add    $0x14,%esp
  801239:	5b                   	pop    %ebx
  80123a:	5d                   	pop    %ebp
  80123b:	c3                   	ret    

0080123c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	57                   	push   %edi
  801240:	56                   	push   %esi
  801241:	53                   	push   %ebx
  801242:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801245:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801248:	89 44 24 04          	mov    %eax,0x4(%esp)
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	89 04 24             	mov    %eax,(%esp)
  801252:	e8 5f fe ff ff       	call   8010b6 <fd_lookup>
  801257:	89 c2                	mov    %eax,%edx
  801259:	85 d2                	test   %edx,%edx
  80125b:	0f 88 e1 00 00 00    	js     801342 <dup+0x106>
		return r;
	close(newfdnum);
  801261:	8b 45 0c             	mov    0xc(%ebp),%eax
  801264:	89 04 24             	mov    %eax,(%esp)
  801267:	e8 7b ff ff ff       	call   8011e7 <close>

	newfd = INDEX2FD(newfdnum);
  80126c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80126f:	c1 e3 0c             	shl    $0xc,%ebx
  801272:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80127b:	89 04 24             	mov    %eax,(%esp)
  80127e:	e8 cd fd ff ff       	call   801050 <fd2data>
  801283:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801285:	89 1c 24             	mov    %ebx,(%esp)
  801288:	e8 c3 fd ff ff       	call   801050 <fd2data>
  80128d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80128f:	89 f0                	mov    %esi,%eax
  801291:	c1 e8 16             	shr    $0x16,%eax
  801294:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80129b:	a8 01                	test   $0x1,%al
  80129d:	74 43                	je     8012e2 <dup+0xa6>
  80129f:	89 f0                	mov    %esi,%eax
  8012a1:	c1 e8 0c             	shr    $0xc,%eax
  8012a4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012ab:	f6 c2 01             	test   $0x1,%dl
  8012ae:	74 32                	je     8012e2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012c0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012cb:	00 
  8012cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d7:	e8 6b fa ff ff       	call   800d47 <sys_page_map>
  8012dc:	89 c6                	mov    %eax,%esi
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	78 3e                	js     801320 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012e5:	89 c2                	mov    %eax,%edx
  8012e7:	c1 ea 0c             	shr    $0xc,%edx
  8012ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012f1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8012f7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801306:	00 
  801307:	89 44 24 04          	mov    %eax,0x4(%esp)
  80130b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801312:	e8 30 fa ff ff       	call   800d47 <sys_page_map>
  801317:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801319:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80131c:	85 f6                	test   %esi,%esi
  80131e:	79 22                	jns    801342 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801320:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801324:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80132b:	e8 6a fa ff ff       	call   800d9a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801330:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801334:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80133b:	e8 5a fa ff ff       	call   800d9a <sys_page_unmap>
	return r;
  801340:	89 f0                	mov    %esi,%eax
}
  801342:	83 c4 3c             	add    $0x3c,%esp
  801345:	5b                   	pop    %ebx
  801346:	5e                   	pop    %esi
  801347:	5f                   	pop    %edi
  801348:	5d                   	pop    %ebp
  801349:	c3                   	ret    

0080134a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	53                   	push   %ebx
  80134e:	83 ec 24             	sub    $0x24,%esp
  801351:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801354:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801357:	89 44 24 04          	mov    %eax,0x4(%esp)
  80135b:	89 1c 24             	mov    %ebx,(%esp)
  80135e:	e8 53 fd ff ff       	call   8010b6 <fd_lookup>
  801363:	89 c2                	mov    %eax,%edx
  801365:	85 d2                	test   %edx,%edx
  801367:	78 6d                	js     8013d6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801369:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801370:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801373:	8b 00                	mov    (%eax),%eax
  801375:	89 04 24             	mov    %eax,(%esp)
  801378:	e8 8f fd ff ff       	call   80110c <dev_lookup>
  80137d:	85 c0                	test   %eax,%eax
  80137f:	78 55                	js     8013d6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801381:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801384:	8b 50 08             	mov    0x8(%eax),%edx
  801387:	83 e2 03             	and    $0x3,%edx
  80138a:	83 fa 01             	cmp    $0x1,%edx
  80138d:	75 23                	jne    8013b2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80138f:	a1 08 50 80 00       	mov    0x805008,%eax
  801394:	8b 40 48             	mov    0x48(%eax),%eax
  801397:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80139b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80139f:	c7 04 24 d5 35 80 00 	movl   $0x8035d5,(%esp)
  8013a6:	e8 07 ef ff ff       	call   8002b2 <cprintf>
		return -E_INVAL;
  8013ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b0:	eb 24                	jmp    8013d6 <read+0x8c>
	}
	if (!dev->dev_read)
  8013b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b5:	8b 52 08             	mov    0x8(%edx),%edx
  8013b8:	85 d2                	test   %edx,%edx
  8013ba:	74 15                	je     8013d1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013ca:	89 04 24             	mov    %eax,(%esp)
  8013cd:	ff d2                	call   *%edx
  8013cf:	eb 05                	jmp    8013d6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8013d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8013d6:	83 c4 24             	add    $0x24,%esp
  8013d9:	5b                   	pop    %ebx
  8013da:	5d                   	pop    %ebp
  8013db:	c3                   	ret    

008013dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
  8013df:	57                   	push   %edi
  8013e0:	56                   	push   %esi
  8013e1:	53                   	push   %ebx
  8013e2:	83 ec 1c             	sub    $0x1c,%esp
  8013e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013f0:	eb 23                	jmp    801415 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013f2:	89 f0                	mov    %esi,%eax
  8013f4:	29 d8                	sub    %ebx,%eax
  8013f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013fa:	89 d8                	mov    %ebx,%eax
  8013fc:	03 45 0c             	add    0xc(%ebp),%eax
  8013ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801403:	89 3c 24             	mov    %edi,(%esp)
  801406:	e8 3f ff ff ff       	call   80134a <read>
		if (m < 0)
  80140b:	85 c0                	test   %eax,%eax
  80140d:	78 10                	js     80141f <readn+0x43>
			return m;
		if (m == 0)
  80140f:	85 c0                	test   %eax,%eax
  801411:	74 0a                	je     80141d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801413:	01 c3                	add    %eax,%ebx
  801415:	39 f3                	cmp    %esi,%ebx
  801417:	72 d9                	jb     8013f2 <readn+0x16>
  801419:	89 d8                	mov    %ebx,%eax
  80141b:	eb 02                	jmp    80141f <readn+0x43>
  80141d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80141f:	83 c4 1c             	add    $0x1c,%esp
  801422:	5b                   	pop    %ebx
  801423:	5e                   	pop    %esi
  801424:	5f                   	pop    %edi
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    

00801427 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	53                   	push   %ebx
  80142b:	83 ec 24             	sub    $0x24,%esp
  80142e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801431:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801434:	89 44 24 04          	mov    %eax,0x4(%esp)
  801438:	89 1c 24             	mov    %ebx,(%esp)
  80143b:	e8 76 fc ff ff       	call   8010b6 <fd_lookup>
  801440:	89 c2                	mov    %eax,%edx
  801442:	85 d2                	test   %edx,%edx
  801444:	78 68                	js     8014ae <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801446:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801449:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801450:	8b 00                	mov    (%eax),%eax
  801452:	89 04 24             	mov    %eax,(%esp)
  801455:	e8 b2 fc ff ff       	call   80110c <dev_lookup>
  80145a:	85 c0                	test   %eax,%eax
  80145c:	78 50                	js     8014ae <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80145e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801461:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801465:	75 23                	jne    80148a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801467:	a1 08 50 80 00       	mov    0x805008,%eax
  80146c:	8b 40 48             	mov    0x48(%eax),%eax
  80146f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801473:	89 44 24 04          	mov    %eax,0x4(%esp)
  801477:	c7 04 24 f1 35 80 00 	movl   $0x8035f1,(%esp)
  80147e:	e8 2f ee ff ff       	call   8002b2 <cprintf>
		return -E_INVAL;
  801483:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801488:	eb 24                	jmp    8014ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80148a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80148d:	8b 52 0c             	mov    0xc(%edx),%edx
  801490:	85 d2                	test   %edx,%edx
  801492:	74 15                	je     8014a9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801494:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801497:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80149b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80149e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014a2:	89 04 24             	mov    %eax,(%esp)
  8014a5:	ff d2                	call   *%edx
  8014a7:	eb 05                	jmp    8014ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8014a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8014ae:	83 c4 24             	add    $0x24,%esp
  8014b1:	5b                   	pop    %ebx
  8014b2:	5d                   	pop    %ebp
  8014b3:	c3                   	ret    

008014b4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ba:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	89 04 24             	mov    %eax,(%esp)
  8014c7:	e8 ea fb ff ff       	call   8010b6 <fd_lookup>
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	78 0e                	js     8014de <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8014d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014de:	c9                   	leave  
  8014df:	c3                   	ret    

008014e0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	53                   	push   %ebx
  8014e4:	83 ec 24             	sub    $0x24,%esp
  8014e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f1:	89 1c 24             	mov    %ebx,(%esp)
  8014f4:	e8 bd fb ff ff       	call   8010b6 <fd_lookup>
  8014f9:	89 c2                	mov    %eax,%edx
  8014fb:	85 d2                	test   %edx,%edx
  8014fd:	78 61                	js     801560 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801502:	89 44 24 04          	mov    %eax,0x4(%esp)
  801506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801509:	8b 00                	mov    (%eax),%eax
  80150b:	89 04 24             	mov    %eax,(%esp)
  80150e:	e8 f9 fb ff ff       	call   80110c <dev_lookup>
  801513:	85 c0                	test   %eax,%eax
  801515:	78 49                	js     801560 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80151e:	75 23                	jne    801543 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801520:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801525:	8b 40 48             	mov    0x48(%eax),%eax
  801528:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80152c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801530:	c7 04 24 b4 35 80 00 	movl   $0x8035b4,(%esp)
  801537:	e8 76 ed ff ff       	call   8002b2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80153c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801541:	eb 1d                	jmp    801560 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801543:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801546:	8b 52 18             	mov    0x18(%edx),%edx
  801549:	85 d2                	test   %edx,%edx
  80154b:	74 0e                	je     80155b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80154d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801550:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801554:	89 04 24             	mov    %eax,(%esp)
  801557:	ff d2                	call   *%edx
  801559:	eb 05                	jmp    801560 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80155b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801560:	83 c4 24             	add    $0x24,%esp
  801563:	5b                   	pop    %ebx
  801564:	5d                   	pop    %ebp
  801565:	c3                   	ret    

00801566 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	53                   	push   %ebx
  80156a:	83 ec 24             	sub    $0x24,%esp
  80156d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801570:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801573:	89 44 24 04          	mov    %eax,0x4(%esp)
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	89 04 24             	mov    %eax,(%esp)
  80157d:	e8 34 fb ff ff       	call   8010b6 <fd_lookup>
  801582:	89 c2                	mov    %eax,%edx
  801584:	85 d2                	test   %edx,%edx
  801586:	78 52                	js     8015da <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801588:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80158b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80158f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801592:	8b 00                	mov    (%eax),%eax
  801594:	89 04 24             	mov    %eax,(%esp)
  801597:	e8 70 fb ff ff       	call   80110c <dev_lookup>
  80159c:	85 c0                	test   %eax,%eax
  80159e:	78 3a                	js     8015da <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8015a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015a7:	74 2c                	je     8015d5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015a9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015ac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015b3:	00 00 00 
	stat->st_isdir = 0;
  8015b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015bd:	00 00 00 
	stat->st_dev = dev;
  8015c0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cd:	89 14 24             	mov    %edx,(%esp)
  8015d0:	ff 50 14             	call   *0x14(%eax)
  8015d3:	eb 05                	jmp    8015da <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8015d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8015da:	83 c4 24             	add    $0x24,%esp
  8015dd:	5b                   	pop    %ebx
  8015de:	5d                   	pop    %ebp
  8015df:	c3                   	ret    

008015e0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	56                   	push   %esi
  8015e4:	53                   	push   %ebx
  8015e5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015ef:	00 
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	89 04 24             	mov    %eax,(%esp)
  8015f6:	e8 84 02 00 00       	call   80187f <open>
  8015fb:	89 c3                	mov    %eax,%ebx
  8015fd:	85 db                	test   %ebx,%ebx
  8015ff:	78 1b                	js     80161c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
  801604:	89 44 24 04          	mov    %eax,0x4(%esp)
  801608:	89 1c 24             	mov    %ebx,(%esp)
  80160b:	e8 56 ff ff ff       	call   801566 <fstat>
  801610:	89 c6                	mov    %eax,%esi
	close(fd);
  801612:	89 1c 24             	mov    %ebx,(%esp)
  801615:	e8 cd fb ff ff       	call   8011e7 <close>
	return r;
  80161a:	89 f0                	mov    %esi,%eax
}
  80161c:	83 c4 10             	add    $0x10,%esp
  80161f:	5b                   	pop    %ebx
  801620:	5e                   	pop    %esi
  801621:	5d                   	pop    %ebp
  801622:	c3                   	ret    

00801623 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	56                   	push   %esi
  801627:	53                   	push   %ebx
  801628:	83 ec 10             	sub    $0x10,%esp
  80162b:	89 c6                	mov    %eax,%esi
  80162d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80162f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801636:	75 11                	jne    801649 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801638:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80163f:	e8 11 18 00 00       	call   802e55 <ipc_find_env>
  801644:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801649:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801650:	00 
  801651:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801658:	00 
  801659:	89 74 24 04          	mov    %esi,0x4(%esp)
  80165d:	a1 00 50 80 00       	mov    0x805000,%eax
  801662:	89 04 24             	mov    %eax,(%esp)
  801665:	e8 5e 17 00 00       	call   802dc8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80166a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801671:	00 
  801672:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801676:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80167d:	e8 de 16 00 00       	call   802d60 <ipc_recv>
}
  801682:	83 c4 10             	add    $0x10,%esp
  801685:	5b                   	pop    %ebx
  801686:	5e                   	pop    %esi
  801687:	5d                   	pop    %ebp
  801688:	c3                   	ret    

00801689 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8b 40 0c             	mov    0xc(%eax),%eax
  801695:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80169a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8016ac:	e8 72 ff ff ff       	call   801623 <fsipc>
}
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016bf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8016c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8016ce:	e8 50 ff ff ff       	call   801623 <fsipc>
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	53                   	push   %ebx
  8016d9:	83 ec 14             	sub    $0x14,%esp
  8016dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8016f4:	e8 2a ff ff ff       	call   801623 <fsipc>
  8016f9:	89 c2                	mov    %eax,%edx
  8016fb:	85 d2                	test   %edx,%edx
  8016fd:	78 2b                	js     80172a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016ff:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801706:	00 
  801707:	89 1c 24             	mov    %ebx,(%esp)
  80170a:	e8 c8 f1 ff ff       	call   8008d7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80170f:	a1 80 60 80 00       	mov    0x806080,%eax
  801714:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80171a:	a1 84 60 80 00       	mov    0x806084,%eax
  80171f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801725:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172a:	83 c4 14             	add    $0x14,%esp
  80172d:	5b                   	pop    %ebx
  80172e:	5d                   	pop    %ebp
  80172f:	c3                   	ret    

00801730 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	53                   	push   %ebx
  801734:	83 ec 14             	sub    $0x14,%esp
  801737:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8b 40 0c             	mov    0xc(%eax),%eax
  801740:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801745:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80174b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801750:	0f 46 c3             	cmovbe %ebx,%eax
  801753:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801758:	89 44 24 08          	mov    %eax,0x8(%esp)
  80175c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801763:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  80176a:	e8 05 f3 ff ff       	call   800a74 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80176f:	ba 00 00 00 00       	mov    $0x0,%edx
  801774:	b8 04 00 00 00       	mov    $0x4,%eax
  801779:	e8 a5 fe ff ff       	call   801623 <fsipc>
  80177e:	85 c0                	test   %eax,%eax
  801780:	78 53                	js     8017d5 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801782:	39 c3                	cmp    %eax,%ebx
  801784:	73 24                	jae    8017aa <devfile_write+0x7a>
  801786:	c7 44 24 0c 24 36 80 	movl   $0x803624,0xc(%esp)
  80178d:	00 
  80178e:	c7 44 24 08 2b 36 80 	movl   $0x80362b,0x8(%esp)
  801795:	00 
  801796:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  80179d:	00 
  80179e:	c7 04 24 40 36 80 00 	movl   $0x803640,(%esp)
  8017a5:	e8 0f ea ff ff       	call   8001b9 <_panic>
	assert(r <= PGSIZE);
  8017aa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017af:	7e 24                	jle    8017d5 <devfile_write+0xa5>
  8017b1:	c7 44 24 0c 4b 36 80 	movl   $0x80364b,0xc(%esp)
  8017b8:	00 
  8017b9:	c7 44 24 08 2b 36 80 	movl   $0x80362b,0x8(%esp)
  8017c0:	00 
  8017c1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  8017c8:	00 
  8017c9:	c7 04 24 40 36 80 00 	movl   $0x803640,(%esp)
  8017d0:	e8 e4 e9 ff ff       	call   8001b9 <_panic>
	return r;
}
  8017d5:	83 c4 14             	add    $0x14,%esp
  8017d8:	5b                   	pop    %ebx
  8017d9:	5d                   	pop    %ebp
  8017da:	c3                   	ret    

008017db <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	56                   	push   %esi
  8017df:	53                   	push   %ebx
  8017e0:	83 ec 10             	sub    $0x10,%esp
  8017e3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ec:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  8017f1:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017fc:	b8 03 00 00 00       	mov    $0x3,%eax
  801801:	e8 1d fe ff ff       	call   801623 <fsipc>
  801806:	89 c3                	mov    %eax,%ebx
  801808:	85 c0                	test   %eax,%eax
  80180a:	78 6a                	js     801876 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  80180c:	39 c6                	cmp    %eax,%esi
  80180e:	73 24                	jae    801834 <devfile_read+0x59>
  801810:	c7 44 24 0c 24 36 80 	movl   $0x803624,0xc(%esp)
  801817:	00 
  801818:	c7 44 24 08 2b 36 80 	movl   $0x80362b,0x8(%esp)
  80181f:	00 
  801820:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801827:	00 
  801828:	c7 04 24 40 36 80 00 	movl   $0x803640,(%esp)
  80182f:	e8 85 e9 ff ff       	call   8001b9 <_panic>
	assert(r <= PGSIZE);
  801834:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801839:	7e 24                	jle    80185f <devfile_read+0x84>
  80183b:	c7 44 24 0c 4b 36 80 	movl   $0x80364b,0xc(%esp)
  801842:	00 
  801843:	c7 44 24 08 2b 36 80 	movl   $0x80362b,0x8(%esp)
  80184a:	00 
  80184b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801852:	00 
  801853:	c7 04 24 40 36 80 00 	movl   $0x803640,(%esp)
  80185a:	e8 5a e9 ff ff       	call   8001b9 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80185f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801863:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80186a:	00 
  80186b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80186e:	89 04 24             	mov    %eax,(%esp)
  801871:	e8 fe f1 ff ff       	call   800a74 <memmove>
	return r;
}
  801876:	89 d8                	mov    %ebx,%eax
  801878:	83 c4 10             	add    $0x10,%esp
  80187b:	5b                   	pop    %ebx
  80187c:	5e                   	pop    %esi
  80187d:	5d                   	pop    %ebp
  80187e:	c3                   	ret    

0080187f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	53                   	push   %ebx
  801883:	83 ec 24             	sub    $0x24,%esp
  801886:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801889:	89 1c 24             	mov    %ebx,(%esp)
  80188c:	e8 0f f0 ff ff       	call   8008a0 <strlen>
  801891:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801896:	7f 60                	jg     8018f8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801898:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189b:	89 04 24             	mov    %eax,(%esp)
  80189e:	e8 c4 f7 ff ff       	call   801067 <fd_alloc>
  8018a3:	89 c2                	mov    %eax,%edx
  8018a5:	85 d2                	test   %edx,%edx
  8018a7:	78 54                	js     8018fd <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018a9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018ad:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  8018b4:	e8 1e f0 ff ff       	call   8008d7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bc:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8018c9:	e8 55 fd ff ff       	call   801623 <fsipc>
  8018ce:	89 c3                	mov    %eax,%ebx
  8018d0:	85 c0                	test   %eax,%eax
  8018d2:	79 17                	jns    8018eb <open+0x6c>
		fd_close(fd, 0);
  8018d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018db:	00 
  8018dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018df:	89 04 24             	mov    %eax,(%esp)
  8018e2:	e8 7f f8 ff ff       	call   801166 <fd_close>
		return r;
  8018e7:	89 d8                	mov    %ebx,%eax
  8018e9:	eb 12                	jmp    8018fd <open+0x7e>
	}

	return fd2num(fd);
  8018eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ee:	89 04 24             	mov    %eax,(%esp)
  8018f1:	e8 4a f7 ff ff       	call   801040 <fd2num>
  8018f6:	eb 05                	jmp    8018fd <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8018f8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8018fd:	83 c4 24             	add    $0x24,%esp
  801900:	5b                   	pop    %ebx
  801901:	5d                   	pop    %ebp
  801902:	c3                   	ret    

00801903 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801909:	ba 00 00 00 00       	mov    $0x0,%edx
  80190e:	b8 08 00 00 00       	mov    $0x8,%eax
  801913:	e8 0b fd ff ff       	call   801623 <fsipc>
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    
  80191a:	66 90                	xchg   %ax,%ax
  80191c:	66 90                	xchg   %ax,%ax
  80191e:	66 90                	xchg   %ax,%ax

00801920 <map_segment>:
}

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	57                   	push   %edi
  801924:	56                   	push   %esi
  801925:	53                   	push   %ebx
  801926:	83 ec 2c             	sub    $0x2c,%esp
  801929:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80192c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80192f:	89 d0                	mov    %edx,%eax
  801931:	25 ff 0f 00 00       	and    $0xfff,%eax
  801936:	74 0b                	je     801943 <map_segment+0x23>
		va -= i;
  801938:	29 c2                	sub    %eax,%edx
		memsz += i;
  80193a:	01 45 e4             	add    %eax,-0x1c(%ebp)
		filesz += i;
  80193d:	01 45 0c             	add    %eax,0xc(%ebp)
		fileoffset -= i;
  801940:	29 45 10             	sub    %eax,0x10(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801943:	89 d6                	mov    %edx,%esi
  801945:	bb 00 00 00 00       	mov    $0x0,%ebx
  80194a:	e9 ff 00 00 00       	jmp    801a4e <map_segment+0x12e>
		if (i >= filesz) {
  80194f:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
  801952:	77 23                	ja     801977 <map_segment+0x57>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801954:	8b 45 14             	mov    0x14(%ebp),%eax
  801957:	89 44 24 08          	mov    %eax,0x8(%esp)
  80195b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80195f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801962:	89 04 24             	mov    %eax,(%esp)
  801965:	e8 89 f3 ff ff       	call   800cf3 <sys_page_alloc>
  80196a:	85 c0                	test   %eax,%eax
  80196c:	0f 89 d0 00 00 00    	jns    801a42 <map_segment+0x122>
  801972:	e9 e7 00 00 00       	jmp    801a5e <map_segment+0x13e>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801977:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80197e:	00 
  80197f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801986:	00 
  801987:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80198e:	e8 60 f3 ff ff       	call   800cf3 <sys_page_alloc>
  801993:	85 c0                	test   %eax,%eax
  801995:	0f 88 c3 00 00 00    	js     801a5e <map_segment+0x13e>
  80199b:	89 f8                	mov    %edi,%eax
  80199d:	03 45 10             	add    0x10(%ebp),%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8019a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	89 04 24             	mov    %eax,(%esp)
  8019aa:	e8 05 fb ff ff       	call   8014b4 <seek>
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	0f 88 a7 00 00 00    	js     801a5e <map_segment+0x13e>
  8019b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ba:	29 f8                	sub    %edi,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8019bc:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019c1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8019c6:	0f 47 c1             	cmova  %ecx,%eax
  8019c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019cd:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8019d4:	00 
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	89 04 24             	mov    %eax,(%esp)
  8019db:	e8 fc f9 ff ff       	call   8013dc <readn>
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	78 7a                	js     801a5e <map_segment+0x13e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8019e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019eb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019f6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8019fd:	00 
  8019fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a05:	e8 3d f3 ff ff       	call   800d47 <sys_page_map>
  801a0a:	85 c0                	test   %eax,%eax
  801a0c:	79 20                	jns    801a2e <map_segment+0x10e>
				panic("spawn: sys_page_map data: %e", r);
  801a0e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a12:	c7 44 24 08 57 36 80 	movl   $0x803657,0x8(%esp)
  801a19:	00 
  801a1a:	c7 44 24 04 ac 01 00 	movl   $0x1ac,0x4(%esp)
  801a21:	00 
  801a22:	c7 04 24 74 36 80 00 	movl   $0x803674,(%esp)
  801a29:	e8 8b e7 ff ff       	call   8001b9 <_panic>
			sys_page_unmap(0, UTEMP);
  801a2e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801a35:	00 
  801a36:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a3d:	e8 58 f3 ff ff       	call   800d9a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801a42:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a48:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801a4e:	89 df                	mov    %ebx,%edi
  801a50:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  801a53:	0f 87 f6 fe ff ff    	ja     80194f <map_segment+0x2f>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5e:	83 c4 2c             	add    $0x2c,%esp
  801a61:	5b                   	pop    %ebx
  801a62:	5e                   	pop    %esi
  801a63:	5f                   	pop    %edi
  801a64:	5d                   	pop    %ebp
  801a65:	c3                   	ret    

00801a66 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	57                   	push   %edi
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	81 ec 8c 02 00 00    	sub    $0x28c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801a72:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a79:	00 
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	89 04 24             	mov    %eax,(%esp)
  801a80:	e8 fa fd ff ff       	call   80187f <open>
  801a85:	89 c1                	mov    %eax,%ecx
  801a87:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801a8d:	85 c0                	test   %eax,%eax
  801a8f:	0f 88 9f 03 00 00    	js     801e34 <spawn+0x3ce>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801a95:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801a9c:	00 
  801a9d:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa7:	89 0c 24             	mov    %ecx,(%esp)
  801aaa:	e8 2d f9 ff ff       	call   8013dc <readn>
  801aaf:	3d 00 02 00 00       	cmp    $0x200,%eax
  801ab4:	75 0c                	jne    801ac2 <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801ab6:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801abd:	45 4c 46 
  801ac0:	74 36                	je     801af8 <spawn+0x92>
		close(fd);
  801ac2:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801ac8:	89 04 24             	mov    %eax,(%esp)
  801acb:	e8 17 f7 ff ff       	call   8011e7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801ad0:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801ad7:	46 
  801ad8:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801ade:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae2:	c7 04 24 80 36 80 00 	movl   $0x803680,(%esp)
  801ae9:	e8 c4 e7 ff ff       	call   8002b2 <cprintf>
		return -E_NOT_EXEC;
  801aee:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801af3:	e9 c0 03 00 00       	jmp    801eb8 <spawn+0x452>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801af8:	b8 07 00 00 00       	mov    $0x7,%eax
  801afd:	cd 30                	int    $0x30
  801aff:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  801b05:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801b0b:	85 c0                	test   %eax,%eax
  801b0d:	0f 88 29 03 00 00    	js     801e3c <spawn+0x3d6>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801b13:	89 c6                	mov    %eax,%esi
  801b15:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801b1b:	c1 e6 07             	shl    $0x7,%esi
  801b1e:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801b24:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801b2a:	b9 11 00 00 00       	mov    $0x11,%ecx
  801b2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801b31:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801b37:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801b3d:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801b42:	be 00 00 00 00       	mov    $0x0,%esi
  801b47:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b4a:	eb 0f                	jmp    801b5b <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801b4c:	89 04 24             	mov    %eax,(%esp)
  801b4f:	e8 4c ed ff ff       	call   8008a0 <strlen>
  801b54:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801b58:	83 c3 01             	add    $0x1,%ebx
  801b5b:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801b62:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801b65:	85 c0                	test   %eax,%eax
  801b67:	75 e3                	jne    801b4c <spawn+0xe6>
  801b69:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
  801b6f:	89 8d 7c fd ff ff    	mov    %ecx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801b75:	bf 00 10 40 00       	mov    $0x401000,%edi
  801b7a:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801b7c:	89 fa                	mov    %edi,%edx
  801b7e:	83 e2 fc             	and    $0xfffffffc,%edx
  801b81:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801b88:	29 c2                	sub    %eax,%edx
  801b8a:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801b90:	8d 42 f8             	lea    -0x8(%edx),%eax
  801b93:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801b98:	0f 86 ae 02 00 00    	jbe    801e4c <spawn+0x3e6>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b9e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801ba5:	00 
  801ba6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801bad:	00 
  801bae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bb5:	e8 39 f1 ff ff       	call   800cf3 <sys_page_alloc>
  801bba:	85 c0                	test   %eax,%eax
  801bbc:	0f 88 f6 02 00 00    	js     801eb8 <spawn+0x452>
  801bc2:	be 00 00 00 00       	mov    $0x0,%esi
  801bc7:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801bcd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801bd0:	eb 30                	jmp    801c02 <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801bd2:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801bd8:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801bde:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801be1:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be8:	89 3c 24             	mov    %edi,(%esp)
  801beb:	e8 e7 ec ff ff       	call   8008d7 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801bf0:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801bf3:	89 04 24             	mov    %eax,(%esp)
  801bf6:	e8 a5 ec ff ff       	call   8008a0 <strlen>
  801bfb:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801bff:	83 c6 01             	add    $0x1,%esi
  801c02:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  801c08:	7c c8                	jl     801bd2 <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801c0a:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801c10:	8b 8d 7c fd ff ff    	mov    -0x284(%ebp),%ecx
  801c16:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801c1d:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801c23:	74 24                	je     801c49 <spawn+0x1e3>
  801c25:	c7 44 24 0c f8 36 80 	movl   $0x8036f8,0xc(%esp)
  801c2c:	00 
  801c2d:	c7 44 24 08 2b 36 80 	movl   $0x80362b,0x8(%esp)
  801c34:	00 
  801c35:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
  801c3c:	00 
  801c3d:	c7 04 24 74 36 80 00 	movl   $0x803674,(%esp)
  801c44:	e8 70 e5 ff ff       	call   8001b9 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801c49:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801c4f:	89 c8                	mov    %ecx,%eax
  801c51:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801c56:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801c59:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c5f:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801c62:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801c68:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801c6e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801c75:	00 
  801c76:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801c7d:	ee 
  801c7e:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801c84:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c88:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c8f:	00 
  801c90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c97:	e8 ab f0 ff ff       	call   800d47 <sys_page_map>
  801c9c:	89 c7                	mov    %eax,%edi
  801c9e:	85 c0                	test   %eax,%eax
  801ca0:	0f 88 fc 01 00 00    	js     801ea2 <spawn+0x43c>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801ca6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801cad:	00 
  801cae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cb5:	e8 e0 f0 ff ff       	call   800d9a <sys_page_unmap>
  801cba:	89 c7                	mov    %eax,%edi
  801cbc:	85 c0                	test   %eax,%eax
  801cbe:	0f 88 de 01 00 00    	js     801ea2 <spawn+0x43c>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801cc4:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801cca:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801cd1:	be 00 00 00 00       	mov    $0x0,%esi
  801cd6:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  801cdc:	eb 4a                	jmp    801d28 <spawn+0x2c2>
		if (ph->p_type != ELF_PROG_LOAD)
  801cde:	83 3b 01             	cmpl   $0x1,(%ebx)
  801ce1:	75 3f                	jne    801d22 <spawn+0x2bc>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801ce3:	8b 43 18             	mov    0x18(%ebx),%eax
  801ce6:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801ce9:	83 f8 01             	cmp    $0x1,%eax
  801cec:	19 c0                	sbb    %eax,%eax
  801cee:	83 e0 fe             	and    $0xfffffffe,%eax
  801cf1:	83 c0 07             	add    $0x7,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801cf4:	8b 4b 14             	mov    0x14(%ebx),%ecx
  801cf7:	8b 53 08             	mov    0x8(%ebx),%edx
  801cfa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cfe:	8b 43 04             	mov    0x4(%ebx),%eax
  801d01:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d05:	8b 43 10             	mov    0x10(%ebx),%eax
  801d08:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0c:	89 3c 24             	mov    %edi,(%esp)
  801d0f:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801d15:	e8 06 fc ff ff       	call   801920 <map_segment>
  801d1a:	85 c0                	test   %eax,%eax
  801d1c:	0f 88 ed 00 00 00    	js     801e0f <spawn+0x3a9>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d22:	83 c6 01             	add    $0x1,%esi
  801d25:	83 c3 20             	add    $0x20,%ebx
  801d28:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801d2f:	39 c6                	cmp    %eax,%esi
  801d31:	7c ab                	jl     801cde <spawn+0x278>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801d33:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d39:	89 04 24             	mov    %eax,(%esp)
  801d3c:	e8 a6 f4 ff ff       	call   8011e7 <close>
	uint8_t *addr, *end_addr;
    int perm;
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
  801d41:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d46:	8b b5 8c fd ff ff    	mov    -0x274(%ebp),%esi
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)) {
  801d4c:	89 d8                	mov    %ebx,%eax
  801d4e:	c1 e8 16             	shr    $0x16,%eax
  801d51:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d58:	a8 01                	test   $0x1,%al
  801d5a:	74 46                	je     801da2 <spawn+0x33c>
  801d5c:	89 d8                	mov    %ebx,%eax
  801d5e:	c1 e8 0c             	shr    $0xc,%eax
  801d61:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801d68:	f6 c2 01             	test   $0x1,%dl
  801d6b:	74 35                	je     801da2 <spawn+0x33c>
			perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  801d6d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
            if (perm & PTE_SHARE) {
  801d74:	f6 c4 04             	test   $0x4,%ah
  801d77:	74 29                	je     801da2 <spawn+0x33c>
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)) {
			perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  801d79:	25 07 0e 00 00       	and    $0xe07,%eax
            if (perm & PTE_SHARE) {
                if ((r = sys_page_map(0, addr, child, addr, perm)) < 0) 
  801d7e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d82:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d86:	89 74 24 08          	mov    %esi,0x8(%esp)
  801d8a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d8e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d95:	e8 ad ef ff ff       	call   800d47 <sys_page_map>
  801d9a:	85 c0                	test   %eax,%eax
  801d9c:	0f 88 b1 00 00 00    	js     801e53 <spawn+0x3ed>
	uint8_t *addr, *end_addr;
    int perm;
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
  801da2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801da8:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801dae:	75 9c                	jne    801d4c <spawn+0x2e6>
  801db0:	e9 be 00 00 00       	jmp    801e73 <spawn+0x40d>
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  801db5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801db9:	c7 44 24 08 9a 36 80 	movl   $0x80369a,0x8(%esp)
  801dc0:	00 
  801dc1:	c7 44 24 04 8b 00 00 	movl   $0x8b,0x4(%esp)
  801dc8:	00 
  801dc9:	c7 04 24 74 36 80 00 	movl   $0x803674,(%esp)
  801dd0:	e8 e4 e3 ff ff       	call   8001b9 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801dd5:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801ddc:	00 
  801ddd:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801de3:	89 04 24             	mov    %eax,(%esp)
  801de6:	e8 02 f0 ff ff       	call   800ded <sys_env_set_status>
  801deb:	85 c0                	test   %eax,%eax
  801ded:	79 55                	jns    801e44 <spawn+0x3de>
		panic("sys_env_set_status: %e", r);
  801def:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801df3:	c7 44 24 08 b4 36 80 	movl   $0x8036b4,0x8(%esp)
  801dfa:	00 
  801dfb:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  801e02:	00 
  801e03:	c7 04 24 74 36 80 00 	movl   $0x803674,(%esp)
  801e0a:	e8 aa e3 ff ff       	call   8001b9 <_panic>
  801e0f:	89 c7                	mov    %eax,%edi

	return child;

error:
	sys_env_destroy(child);
  801e11:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801e17:	89 04 24             	mov    %eax,(%esp)
  801e1a:	e8 44 ee ff ff       	call   800c63 <sys_env_destroy>
	close(fd);
  801e1f:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801e25:	89 04 24             	mov    %eax,(%esp)
  801e28:	e8 ba f3 ff ff       	call   8011e7 <close>
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801e2d:	89 f8                	mov    %edi,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801e2f:	e9 84 00 00 00       	jmp    801eb8 <spawn+0x452>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  801e34:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801e3a:	eb 7c                	jmp    801eb8 <spawn+0x452>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  801e3c:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801e42:	eb 74                	jmp    801eb8 <spawn+0x452>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  801e44:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801e4a:	eb 6c                	jmp    801eb8 <spawn+0x452>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  801e4c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  801e51:	eb 65                	jmp    801eb8 <spawn+0x452>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  801e53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e57:	c7 44 24 08 cb 36 80 	movl   $0x8036cb,0x8(%esp)
  801e5e:	00 
  801e5f:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  801e66:	00 
  801e67:	c7 04 24 74 36 80 00 	movl   $0x803674,(%esp)
  801e6e:	e8 46 e3 ff ff       	call   8001b9 <_panic>

	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  801e73:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  801e7a:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801e7d:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801e83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e87:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801e8d:	89 04 24             	mov    %eax,(%esp)
  801e90:	e8 ab ef ff ff       	call   800e40 <sys_env_set_trapframe>
  801e95:	85 c0                	test   %eax,%eax
  801e97:	0f 89 38 ff ff ff    	jns    801dd5 <spawn+0x36f>
  801e9d:	e9 13 ff ff ff       	jmp    801db5 <spawn+0x34f>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801ea2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ea9:	00 
  801eaa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801eb1:	e8 e4 ee ff ff       	call   800d9a <sys_page_unmap>
  801eb6:	89 f8                	mov    %edi,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  801eb8:	81 c4 8c 02 00 00    	add    $0x28c,%esp
  801ebe:	5b                   	pop    %ebx
  801ebf:	5e                   	pop    %esi
  801ec0:	5f                   	pop    %edi
  801ec1:	5d                   	pop    %ebp
  801ec2:	c3                   	ret    

00801ec3 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	56                   	push   %esi
  801ec7:	53                   	push   %ebx
  801ec8:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801ecb:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  801ece:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801ed3:	eb 03                	jmp    801ed8 <spawnl+0x15>
		argc++;
  801ed5:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  801ed8:	83 c0 04             	add    $0x4,%eax
  801edb:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  801edf:	75 f4                	jne    801ed5 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  801ee1:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  801ee8:	83 e0 f0             	and    $0xfffffff0,%eax
  801eeb:	29 c4                	sub    %eax,%esp
  801eed:	8d 44 24 0b          	lea    0xb(%esp),%eax
  801ef1:	c1 e8 02             	shr    $0x2,%eax
  801ef4:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  801efb:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801efd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f00:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  801f07:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  801f0e:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801f0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f14:	eb 0a                	jmp    801f20 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  801f16:	83 c0 01             	add    $0x1,%eax
  801f19:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  801f1d:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  801f20:	39 d0                	cmp    %edx,%eax
  801f22:	75 f2                	jne    801f16 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  801f24:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	89 04 24             	mov    %eax,(%esp)
  801f2e:	e8 33 fb ff ff       	call   801a66 <spawn>
}
  801f33:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f36:	5b                   	pop    %ebx
  801f37:	5e                   	pop    %esi
  801f38:	5d                   	pop    %ebp
  801f39:	c3                   	ret    

00801f3a <exec>:

int
exec(const char *prog, const char **argv)
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
  801f3d:	57                   	push   %edi
  801f3e:	56                   	push   %esi
  801f3f:	53                   	push   %ebx
  801f40:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
	int fd, i, r;
	struct Elf *elf;
	struct Proghdr *ph;
	int perm;	

	if ((r = open(prog, O_RDONLY)) < 0)
  801f46:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f4d:	00 
  801f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f51:	89 04 24             	mov    %eax,(%esp)
  801f54:	e8 26 f9 ff ff       	call   80187f <open>
  801f59:	89 c7                	mov    %eax,%edi
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	0f 88 14 03 00 00    	js     802277 <exec+0x33d>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801f63:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801f6a:	00 
  801f6b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801f71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f75:	89 3c 24             	mov    %edi,(%esp)
  801f78:	e8 5f f4 ff ff       	call   8013dc <readn>
  801f7d:	3d 00 02 00 00       	cmp    $0x200,%eax
  801f82:	75 0c                	jne    801f90 <exec+0x56>
	    || elf->e_magic != ELF_MAGIC) {
  801f84:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801f8b:	45 4c 46 
  801f8e:	74 30                	je     801fc0 <exec+0x86>
		close(fd);
  801f90:	89 3c 24             	mov    %edi,(%esp)
  801f93:	e8 4f f2 ff ff       	call   8011e7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801f98:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801f9f:	46 
  801fa0:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801fa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801faa:	c7 04 24 80 36 80 00 	movl   $0x803680,(%esp)
  801fb1:	e8 fc e2 ff ff       	call   8002b2 <cprintf>
		return -E_NOT_EXEC;
  801fb6:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801fbb:	e9 d8 02 00 00       	jmp    802298 <exec+0x35e>
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801fc0:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801fc6:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
  801fcd:	b8 00 00 00 e0       	mov    $0xe0000000,%eax
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801fd2:	be 00 00 00 00       	mov    $0x0,%esi
  801fd7:	89 bd e4 fd ff ff    	mov    %edi,-0x21c(%ebp)
  801fdd:	89 c7                	mov    %eax,%edi
  801fdf:	eb 71                	jmp    802052 <exec+0x118>
		if (ph->p_type != ELF_PROG_LOAD)
  801fe1:	83 3b 01             	cmpl   $0x1,(%ebx)
  801fe4:	75 66                	jne    80204c <exec+0x112>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801fe6:	8b 43 18             	mov    0x18(%ebx),%eax
  801fe9:	83 e0 02             	and    $0x2,%eax
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801fec:	83 f8 01             	cmp    $0x1,%eax
  801fef:	19 c0                	sbb    %eax,%eax
  801ff1:	83 e0 fe             	and    $0xfffffffe,%eax
  801ff4:	83 c0 07             	add    $0x7,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(0, PGOFF(ph->p_va) + tmp, ph->p_memsz,
  801ff7:	8b 4b 14             	mov    0x14(%ebx),%ecx
  801ffa:	8b 53 08             	mov    0x8(%ebx),%edx
  801ffd:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  802003:	01 fa                	add    %edi,%edx
  802005:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802009:	8b 43 04             	mov    0x4(%ebx),%eax
  80200c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802010:	8b 43 10             	mov    0x10(%ebx),%eax
  802013:	89 44 24 04          	mov    %eax,0x4(%esp)
  802017:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
  80201d:	89 04 24             	mov    %eax,(%esp)
  802020:	b8 00 00 00 00       	mov    $0x0,%eax
  802025:	e8 f6 f8 ff ff       	call   801920 <map_segment>
  80202a:	85 c0                	test   %eax,%eax
  80202c:	0f 88 25 02 00 00    	js     802257 <exec+0x31d>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
  802032:	8b 53 14             	mov    0x14(%ebx),%edx
  802035:	8b 43 08             	mov    0x8(%ebx),%eax
  802038:	25 ff 0f 00 00       	and    $0xfff,%eax
  80203d:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
  802044:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802049:	8d 3c 38             	lea    (%eax,%edi,1),%edi
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80204c:	83 c6 01             	add    $0x1,%esi
  80204f:	83 c3 20             	add    $0x20,%ebx
  802052:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802059:	39 c6                	cmp    %eax,%esi
  80205b:	7c 84                	jl     801fe1 <exec+0xa7>
  80205d:	89 bd dc fd ff ff    	mov    %edi,-0x224(%ebp)
  802063:	8b bd e4 fd ff ff    	mov    -0x21c(%ebp),%edi
		if ((r = map_segment(0, PGOFF(ph->p_va) + tmp, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
	}
	close(fd);
  802069:	89 3c 24             	mov    %edi,(%esp)
  80206c:	e8 76 f1 ff ff       	call   8011e7 <close>
	fd = -1;
	cprintf("tf_esp: %x\n", tf_esp);
  802071:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802078:	00 
  802079:	c7 04 24 e1 36 80 00 	movl   $0x8036e1,(%esp)
  802080:	e8 2d e2 ff ff       	call   8002b2 <cprintf>
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802085:	bb 00 00 00 00       	mov    $0x0,%ebx
	size_t string_size;
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
  80208a:	be 00 00 00 00       	mov    $0x0,%esi
  80208f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802092:	eb 0f                	jmp    8020a3 <exec+0x169>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  802094:	89 04 24             	mov    %eax,(%esp)
  802097:	e8 04 e8 ff ff       	call   8008a0 <strlen>
  80209c:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8020a0:	83 c3 01             	add    $0x1,%ebx
  8020a3:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8020aa:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	75 e3                	jne    802094 <exec+0x15a>
  8020b1:	89 9d d8 fd ff ff    	mov    %ebx,-0x228(%ebp)
  8020b7:	89 8d d4 fd ff ff    	mov    %ecx,-0x22c(%ebp)
		string_size += strlen(argv[argc]) + 1;

	string_store = (char*) UTEMP + PGSIZE - string_size;
  8020bd:	bf 00 10 40 00       	mov    $0x401000,%edi
  8020c2:	29 f7                	sub    %esi,%edi
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8020c4:	89 fa                	mov    %edi,%edx
  8020c6:	83 e2 fc             	and    $0xfffffffc,%edx
  8020c9:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8020d0:	29 c2                	sub    %eax,%edx
  8020d2:	89 95 e4 fd ff ff    	mov    %edx,-0x21c(%ebp)
	
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8020d8:	8d 42 f8             	lea    -0x8(%edx),%eax
  8020db:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8020e0:	0f 86 93 01 00 00    	jbe    802279 <exec+0x33f>
		return -E_NO_MEM;

	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8020e6:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8020ed:	00 
  8020ee:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8020f5:	00 
  8020f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020fd:	e8 f1 eb ff ff       	call   800cf3 <sys_page_alloc>
  802102:	85 c0                	test   %eax,%eax
  802104:	0f 88 8e 01 00 00    	js     802298 <exec+0x35e>
  80210a:	be 00 00 00 00       	mov    $0x0,%esi
  80210f:	89 9d e0 fd ff ff    	mov    %ebx,-0x220(%ebp)
  802115:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802118:	eb 30                	jmp    80214a <exec+0x210>
		return r;

	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  80211a:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802120:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
  802126:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802129:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80212c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802130:	89 3c 24             	mov    %edi,(%esp)
  802133:	e8 9f e7 ff ff       	call   8008d7 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802138:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80213b:	89 04 24             	mov    %eax,(%esp)
  80213e:	e8 5d e7 ff ff       	call   8008a0 <strlen>
  802143:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
		return -E_NO_MEM;

	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		return r;

	for (i = 0; i < argc; i++) {
  802147:	83 c6 01             	add    $0x1,%esi
  80214a:	39 b5 e0 fd ff ff    	cmp    %esi,-0x220(%ebp)
  802150:	7f c8                	jg     80211a <exec+0x1e0>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802152:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
  802158:	8b 8d d4 fd ff ff    	mov    -0x22c(%ebp),%ecx
  80215e:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802165:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80216b:	74 24                	je     802191 <exec+0x257>
  80216d:	c7 44 24 0c f8 36 80 	movl   $0x8036f8,0xc(%esp)
  802174:	00 
  802175:	c7 44 24 08 2b 36 80 	movl   $0x80362b,0x8(%esp)
  80217c:	00 
  80217d:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
  802184:	00 
  802185:	c7 04 24 74 36 80 00 	movl   $0x803674,(%esp)
  80218c:	e8 28 e0 ff ff       	call   8001b9 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802191:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
  802197:	89 c8                	mov    %ecx,%eax
  802199:	2d 00 30 80 11       	sub    $0x11803000,%eax
  80219e:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  8021a1:	8b 85 d8 fd ff ff    	mov    -0x228(%ebp),%eax
  8021a7:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  8021aa:	8d 99 f8 cf 7f ee    	lea    -0x11803008(%ecx),%ebx

	cprintf("stack: %x\n", stack);
  8021b0:	8b bd dc fd ff ff    	mov    -0x224(%ebp),%edi
  8021b6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8021ba:	c7 04 24 ed 36 80 00 	movl   $0x8036ed,(%esp)
  8021c1:	e8 ec e0 ff ff       	call   8002b2 <cprintf>
	if ((r = sys_page_map(0, UTEMP, child, (void*) stack, PTE_P | PTE_U | PTE_W)) < 0)
  8021c6:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8021cd:	00 
  8021ce:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021d2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021d9:	00 
  8021da:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8021e1:	00 
  8021e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021e9:	e8 59 eb ff ff       	call   800d47 <sys_page_map>
  8021ee:	89 c7                	mov    %eax,%edi
  8021f0:	85 c0                	test   %eax,%eax
  8021f2:	0f 88 8a 00 00 00    	js     802282 <exec+0x348>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8021f8:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8021ff:	00 
  802200:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802207:	e8 8e eb ff ff       	call   800d9a <sys_page_unmap>
  80220c:	89 c7                	mov    %eax,%edi
  80220e:	85 c0                	test   %eax,%eax
  802210:	78 70                	js     802282 <exec+0x348>
	// cprintf("tf_eip: %x\n", tf_eip);
	if ((r = init_stack_with_addr(0, argv, &tf_esp, tmp)) < 0)
		return r;

	// Syscall to exec
	if (sys_exec(elf->e_entry, tf_esp, (void *)(elf_buf + elf->e_phoff), elf->e_phnum) < 0)
  802212:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802219:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80221d:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802223:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  80222a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80222e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802232:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802238:	89 04 24             	mov    %eax,(%esp)
  80223b:	e8 9c ed ff ff       	call   800fdc <sys_exec>
  802240:	89 c2                	mov    %eax,%edx
		goto error;
	return 0;
  802242:	b8 00 00 00 00       	mov    $0x0,%eax
  802247:	be 00 00 00 00       	mov    $0x0,%esi
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
	}
	close(fd);
	fd = -1;
  80224c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
	// cprintf("tf_eip: %x\n", tf_eip);
	if ((r = init_stack_with_addr(0, argv, &tf_esp, tmp)) < 0)
		return r;

	// Syscall to exec
	if (sys_exec(elf->e_entry, tf_esp, (void *)(elf_buf + elf->e_phoff), elf->e_phnum) < 0)
  802251:	85 d2                	test   %edx,%edx
  802253:	78 0a                	js     80225f <exec+0x325>
  802255:	eb 41                	jmp    802298 <exec+0x35e>
  802257:	8b bd e4 fd ff ff    	mov    -0x21c(%ebp),%edi
  80225d:	89 c6                	mov    %eax,%esi
		goto error;
	return 0;

error:
	sys_env_destroy(0);
  80225f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802266:	e8 f8 e9 ff ff       	call   800c63 <sys_env_destroy>
	close(fd);
  80226b:	89 3c 24             	mov    %edi,(%esp)
  80226e:	e8 74 ef ff ff       	call   8011e7 <close>
	return r;
  802273:	89 f0                	mov    %esi,%eax
  802275:	eb 21                	jmp    802298 <exec+0x35e>
  802277:	eb 1f                	jmp    802298 <exec+0x35e>

	string_store = (char*) UTEMP + PGSIZE - string_size;
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  802279:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80227e:	66 90                	xchg   %ax,%ax
  802280:	eb 16                	jmp    802298 <exec+0x35e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802282:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802289:	00 
  80228a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802291:	e8 04 eb ff ff       	call   800d9a <sys_page_unmap>
  802296:	89 f8                	mov    %edi,%eax

error:
	sys_env_destroy(0);
	close(fd);
	return r;
}
  802298:	81 c4 3c 02 00 00    	add    $0x23c,%esp
  80229e:	5b                   	pop    %ebx
  80229f:	5e                   	pop    %esi
  8022a0:	5f                   	pop    %edi
  8022a1:	5d                   	pop    %ebp
  8022a2:	c3                   	ret    

008022a3 <execl>:

int
execl(const char *prog, const char *arg0, ...)
{
  8022a3:	55                   	push   %ebp
  8022a4:	89 e5                	mov    %esp,%ebp
  8022a6:	56                   	push   %esi
  8022a7:	53                   	push   %ebx
  8022a8:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8022ab:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8022ae:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8022b3:	eb 03                	jmp    8022b8 <execl+0x15>
		argc++;
  8022b5:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8022b8:	83 c0 04             	add    $0x4,%eax
  8022bb:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  8022bf:	75 f4                	jne    8022b5 <execl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8022c1:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  8022c8:	83 e0 f0             	and    $0xfffffff0,%eax
  8022cb:	29 c4                	sub    %eax,%esp
  8022cd:	8d 44 24 0b          	lea    0xb(%esp),%eax
  8022d1:	c1 e8 02             	shr    $0x2,%eax
  8022d4:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  8022db:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8022dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022e0:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  8022e7:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  8022ee:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8022ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f4:	eb 0a                	jmp    802300 <execl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  8022f6:	83 c0 01             	add    $0x1,%eax
  8022f9:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  8022fd:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802300:	39 d0                	cmp    %edx,%eax
  802302:	75 f2                	jne    8022f6 <execl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return exec(prog, argv);
  802304:	89 74 24 04          	mov    %esi,0x4(%esp)
  802308:	8b 45 08             	mov    0x8(%ebp),%eax
  80230b:	89 04 24             	mov    %eax,(%esp)
  80230e:	e8 27 fc ff ff       	call   801f3a <exec>
}
  802313:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802316:	5b                   	pop    %ebx
  802317:	5e                   	pop    %esi
  802318:	5d                   	pop    %ebp
  802319:	c3                   	ret    
  80231a:	66 90                	xchg   %ax,%ax
  80231c:	66 90                	xchg   %ax,%ax
  80231e:	66 90                	xchg   %ax,%ax

00802320 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802326:	c7 44 24 04 20 37 80 	movl   $0x803720,0x4(%esp)
  80232d:	00 
  80232e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802331:	89 04 24             	mov    %eax,(%esp)
  802334:	e8 9e e5 ff ff       	call   8008d7 <strcpy>
	return 0;
}
  802339:	b8 00 00 00 00       	mov    $0x0,%eax
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	53                   	push   %ebx
  802344:	83 ec 14             	sub    $0x14,%esp
  802347:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80234a:	89 1c 24             	mov    %ebx,(%esp)
  80234d:	e8 3d 0b 00 00       	call   802e8f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802352:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802357:	83 f8 01             	cmp    $0x1,%eax
  80235a:	75 0d                	jne    802369 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80235c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80235f:	89 04 24             	mov    %eax,(%esp)
  802362:	e8 29 03 00 00       	call   802690 <nsipc_close>
  802367:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802369:	89 d0                	mov    %edx,%eax
  80236b:	83 c4 14             	add    $0x14,%esp
  80236e:	5b                   	pop    %ebx
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    

00802371 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802377:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80237e:	00 
  80237f:	8b 45 10             	mov    0x10(%ebp),%eax
  802382:	89 44 24 08          	mov    %eax,0x8(%esp)
  802386:	8b 45 0c             	mov    0xc(%ebp),%eax
  802389:	89 44 24 04          	mov    %eax,0x4(%esp)
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	8b 40 0c             	mov    0xc(%eax),%eax
  802393:	89 04 24             	mov    %eax,(%esp)
  802396:	e8 f0 03 00 00       	call   80278b <nsipc_send>
}
  80239b:	c9                   	leave  
  80239c:	c3                   	ret    

0080239d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80239d:	55                   	push   %ebp
  80239e:	89 e5                	mov    %esp,%ebp
  8023a0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8023a3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8023aa:	00 
  8023ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bf:	89 04 24             	mov    %eax,(%esp)
  8023c2:	e8 44 03 00 00       	call   80270b <nsipc_recv>
}
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8023cf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8023d2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023d6:	89 04 24             	mov    %eax,(%esp)
  8023d9:	e8 d8 ec ff ff       	call   8010b6 <fd_lookup>
  8023de:	85 c0                	test   %eax,%eax
  8023e0:	78 17                	js     8023f9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  8023eb:	39 08                	cmp    %ecx,(%eax)
  8023ed:	75 05                	jne    8023f4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8023ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f2:	eb 05                	jmp    8023f9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8023f4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	56                   	push   %esi
  8023ff:	53                   	push   %ebx
  802400:	83 ec 20             	sub    $0x20,%esp
  802403:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802405:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802408:	89 04 24             	mov    %eax,(%esp)
  80240b:	e8 57 ec ff ff       	call   801067 <fd_alloc>
  802410:	89 c3                	mov    %eax,%ebx
  802412:	85 c0                	test   %eax,%eax
  802414:	78 21                	js     802437 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802416:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80241d:	00 
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	89 44 24 04          	mov    %eax,0x4(%esp)
  802425:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80242c:	e8 c2 e8 ff ff       	call   800cf3 <sys_page_alloc>
  802431:	89 c3                	mov    %eax,%ebx
  802433:	85 c0                	test   %eax,%eax
  802435:	79 0c                	jns    802443 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802437:	89 34 24             	mov    %esi,(%esp)
  80243a:	e8 51 02 00 00       	call   802690 <nsipc_close>
		return r;
  80243f:	89 d8                	mov    %ebx,%eax
  802441:	eb 20                	jmp    802463 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802443:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80244e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802451:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802458:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80245b:	89 14 24             	mov    %edx,(%esp)
  80245e:	e8 dd eb ff ff       	call   801040 <fd2num>
}
  802463:	83 c4 20             	add    $0x20,%esp
  802466:	5b                   	pop    %ebx
  802467:	5e                   	pop    %esi
  802468:	5d                   	pop    %ebp
  802469:	c3                   	ret    

0080246a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802470:	8b 45 08             	mov    0x8(%ebp),%eax
  802473:	e8 51 ff ff ff       	call   8023c9 <fd2sockid>
		return r;
  802478:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80247a:	85 c0                	test   %eax,%eax
  80247c:	78 23                	js     8024a1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80247e:	8b 55 10             	mov    0x10(%ebp),%edx
  802481:	89 54 24 08          	mov    %edx,0x8(%esp)
  802485:	8b 55 0c             	mov    0xc(%ebp),%edx
  802488:	89 54 24 04          	mov    %edx,0x4(%esp)
  80248c:	89 04 24             	mov    %eax,(%esp)
  80248f:	e8 45 01 00 00       	call   8025d9 <nsipc_accept>
		return r;
  802494:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802496:	85 c0                	test   %eax,%eax
  802498:	78 07                	js     8024a1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80249a:	e8 5c ff ff ff       	call   8023fb <alloc_sockfd>
  80249f:	89 c1                	mov    %eax,%ecx
}
  8024a1:	89 c8                	mov    %ecx,%eax
  8024a3:	c9                   	leave  
  8024a4:	c3                   	ret    

008024a5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8024a5:	55                   	push   %ebp
  8024a6:	89 e5                	mov    %esp,%ebp
  8024a8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	e8 16 ff ff ff       	call   8023c9 <fd2sockid>
  8024b3:	89 c2                	mov    %eax,%edx
  8024b5:	85 d2                	test   %edx,%edx
  8024b7:	78 16                	js     8024cf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8024b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8024bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c7:	89 14 24             	mov    %edx,(%esp)
  8024ca:	e8 60 01 00 00       	call   80262f <nsipc_bind>
}
  8024cf:	c9                   	leave  
  8024d0:	c3                   	ret    

008024d1 <shutdown>:

int
shutdown(int s, int how)
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
  8024d4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8024d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024da:	e8 ea fe ff ff       	call   8023c9 <fd2sockid>
  8024df:	89 c2                	mov    %eax,%edx
  8024e1:	85 d2                	test   %edx,%edx
  8024e3:	78 0f                	js     8024f4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8024e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ec:	89 14 24             	mov    %edx,(%esp)
  8024ef:	e8 7a 01 00 00       	call   80266e <nsipc_shutdown>
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
  8024f9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8024fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ff:	e8 c5 fe ff ff       	call   8023c9 <fd2sockid>
  802504:	89 c2                	mov    %eax,%edx
  802506:	85 d2                	test   %edx,%edx
  802508:	78 16                	js     802520 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80250a:	8b 45 10             	mov    0x10(%ebp),%eax
  80250d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802511:	8b 45 0c             	mov    0xc(%ebp),%eax
  802514:	89 44 24 04          	mov    %eax,0x4(%esp)
  802518:	89 14 24             	mov    %edx,(%esp)
  80251b:	e8 8a 01 00 00       	call   8026aa <nsipc_connect>
}
  802520:	c9                   	leave  
  802521:	c3                   	ret    

00802522 <listen>:

int
listen(int s, int backlog)
{
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
  802525:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	e8 99 fe ff ff       	call   8023c9 <fd2sockid>
  802530:	89 c2                	mov    %eax,%edx
  802532:	85 d2                	test   %edx,%edx
  802534:	78 0f                	js     802545 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802536:	8b 45 0c             	mov    0xc(%ebp),%eax
  802539:	89 44 24 04          	mov    %eax,0x4(%esp)
  80253d:	89 14 24             	mov    %edx,(%esp)
  802540:	e8 a4 01 00 00       	call   8026e9 <nsipc_listen>
}
  802545:	c9                   	leave  
  802546:	c3                   	ret    

00802547 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802547:	55                   	push   %ebp
  802548:	89 e5                	mov    %esp,%ebp
  80254a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80254d:	8b 45 10             	mov    0x10(%ebp),%eax
  802550:	89 44 24 08          	mov    %eax,0x8(%esp)
  802554:	8b 45 0c             	mov    0xc(%ebp),%eax
  802557:	89 44 24 04          	mov    %eax,0x4(%esp)
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	89 04 24             	mov    %eax,(%esp)
  802561:	e8 98 02 00 00       	call   8027fe <nsipc_socket>
  802566:	89 c2                	mov    %eax,%edx
  802568:	85 d2                	test   %edx,%edx
  80256a:	78 05                	js     802571 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80256c:	e8 8a fe ff ff       	call   8023fb <alloc_sockfd>
}
  802571:	c9                   	leave  
  802572:	c3                   	ret    

00802573 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
  802576:	53                   	push   %ebx
  802577:	83 ec 14             	sub    $0x14,%esp
  80257a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80257c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802583:	75 11                	jne    802596 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802585:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80258c:	e8 c4 08 00 00       	call   802e55 <ipc_find_env>
  802591:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802596:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80259d:	00 
  80259e:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  8025a5:	00 
  8025a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025aa:	a1 04 50 80 00       	mov    0x805004,%eax
  8025af:	89 04 24             	mov    %eax,(%esp)
  8025b2:	e8 11 08 00 00       	call   802dc8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8025b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8025be:	00 
  8025bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8025c6:	00 
  8025c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025ce:	e8 8d 07 00 00       	call   802d60 <ipc_recv>
}
  8025d3:	83 c4 14             	add    $0x14,%esp
  8025d6:	5b                   	pop    %ebx
  8025d7:	5d                   	pop    %ebp
  8025d8:	c3                   	ret    

008025d9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
  8025dc:	56                   	push   %esi
  8025dd:	53                   	push   %ebx
  8025de:	83 ec 10             	sub    $0x10,%esp
  8025e1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8025e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8025ec:	8b 06                	mov    (%esi),%eax
  8025ee:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8025f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f8:	e8 76 ff ff ff       	call   802573 <nsipc>
  8025fd:	89 c3                	mov    %eax,%ebx
  8025ff:	85 c0                	test   %eax,%eax
  802601:	78 23                	js     802626 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802603:	a1 10 80 80 00       	mov    0x808010,%eax
  802608:	89 44 24 08          	mov    %eax,0x8(%esp)
  80260c:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802613:	00 
  802614:	8b 45 0c             	mov    0xc(%ebp),%eax
  802617:	89 04 24             	mov    %eax,(%esp)
  80261a:	e8 55 e4 ff ff       	call   800a74 <memmove>
		*addrlen = ret->ret_addrlen;
  80261f:	a1 10 80 80 00       	mov    0x808010,%eax
  802624:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802626:	89 d8                	mov    %ebx,%eax
  802628:	83 c4 10             	add    $0x10,%esp
  80262b:	5b                   	pop    %ebx
  80262c:	5e                   	pop    %esi
  80262d:	5d                   	pop    %ebp
  80262e:	c3                   	ret    

0080262f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
  802632:	53                   	push   %ebx
  802633:	83 ec 14             	sub    $0x14,%esp
  802636:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802639:	8b 45 08             	mov    0x8(%ebp),%eax
  80263c:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802641:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802645:	8b 45 0c             	mov    0xc(%ebp),%eax
  802648:	89 44 24 04          	mov    %eax,0x4(%esp)
  80264c:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  802653:	e8 1c e4 ff ff       	call   800a74 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802658:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  80265e:	b8 02 00 00 00       	mov    $0x2,%eax
  802663:	e8 0b ff ff ff       	call   802573 <nsipc>
}
  802668:	83 c4 14             	add    $0x14,%esp
  80266b:	5b                   	pop    %ebx
  80266c:	5d                   	pop    %ebp
  80266d:	c3                   	ret    

0080266e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80266e:	55                   	push   %ebp
  80266f:	89 e5                	mov    %esp,%ebp
  802671:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802674:	8b 45 08             	mov    0x8(%ebp),%eax
  802677:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  80267c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80267f:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  802684:	b8 03 00 00 00       	mov    $0x3,%eax
  802689:	e8 e5 fe ff ff       	call   802573 <nsipc>
}
  80268e:	c9                   	leave  
  80268f:	c3                   	ret    

00802690 <nsipc_close>:

int
nsipc_close(int s)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802696:	8b 45 08             	mov    0x8(%ebp),%eax
  802699:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  80269e:	b8 04 00 00 00       	mov    $0x4,%eax
  8026a3:	e8 cb fe ff ff       	call   802573 <nsipc>
}
  8026a8:	c9                   	leave  
  8026a9:	c3                   	ret    

008026aa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
  8026ad:	53                   	push   %ebx
  8026ae:	83 ec 14             	sub    $0x14,%esp
  8026b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8026b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b7:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8026bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8026c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c7:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  8026ce:	e8 a1 e3 ff ff       	call   800a74 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8026d3:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  8026d9:	b8 05 00 00 00       	mov    $0x5,%eax
  8026de:	e8 90 fe ff ff       	call   802573 <nsipc>
}
  8026e3:	83 c4 14             	add    $0x14,%esp
  8026e6:	5b                   	pop    %ebx
  8026e7:	5d                   	pop    %ebp
  8026e8:	c3                   	ret    

008026e9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8026e9:	55                   	push   %ebp
  8026ea:	89 e5                	mov    %esp,%ebp
  8026ec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  8026f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026fa:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  8026ff:	b8 06 00 00 00       	mov    $0x6,%eax
  802704:	e8 6a fe ff ff       	call   802573 <nsipc>
}
  802709:	c9                   	leave  
  80270a:	c3                   	ret    

0080270b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80270b:	55                   	push   %ebp
  80270c:	89 e5                	mov    %esp,%ebp
  80270e:	56                   	push   %esi
  80270f:	53                   	push   %ebx
  802710:	83 ec 10             	sub    $0x10,%esp
  802713:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  80271e:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  802724:	8b 45 14             	mov    0x14(%ebp),%eax
  802727:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80272c:	b8 07 00 00 00       	mov    $0x7,%eax
  802731:	e8 3d fe ff ff       	call   802573 <nsipc>
  802736:	89 c3                	mov    %eax,%ebx
  802738:	85 c0                	test   %eax,%eax
  80273a:	78 46                	js     802782 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80273c:	39 f0                	cmp    %esi,%eax
  80273e:	7f 07                	jg     802747 <nsipc_recv+0x3c>
  802740:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802745:	7e 24                	jle    80276b <nsipc_recv+0x60>
  802747:	c7 44 24 0c 2c 37 80 	movl   $0x80372c,0xc(%esp)
  80274e:	00 
  80274f:	c7 44 24 08 2b 36 80 	movl   $0x80362b,0x8(%esp)
  802756:	00 
  802757:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80275e:	00 
  80275f:	c7 04 24 41 37 80 00 	movl   $0x803741,(%esp)
  802766:	e8 4e da ff ff       	call   8001b9 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80276b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80276f:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  802776:	00 
  802777:	8b 45 0c             	mov    0xc(%ebp),%eax
  80277a:	89 04 24             	mov    %eax,(%esp)
  80277d:	e8 f2 e2 ff ff       	call   800a74 <memmove>
	}

	return r;
}
  802782:	89 d8                	mov    %ebx,%eax
  802784:	83 c4 10             	add    $0x10,%esp
  802787:	5b                   	pop    %ebx
  802788:	5e                   	pop    %esi
  802789:	5d                   	pop    %ebp
  80278a:	c3                   	ret    

0080278b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80278b:	55                   	push   %ebp
  80278c:	89 e5                	mov    %esp,%ebp
  80278e:	53                   	push   %ebx
  80278f:	83 ec 14             	sub    $0x14,%esp
  802792:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802795:	8b 45 08             	mov    0x8(%ebp),%eax
  802798:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  80279d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8027a3:	7e 24                	jle    8027c9 <nsipc_send+0x3e>
  8027a5:	c7 44 24 0c 4d 37 80 	movl   $0x80374d,0xc(%esp)
  8027ac:	00 
  8027ad:	c7 44 24 08 2b 36 80 	movl   $0x80362b,0x8(%esp)
  8027b4:	00 
  8027b5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8027bc:	00 
  8027bd:	c7 04 24 41 37 80 00 	movl   $0x803741,(%esp)
  8027c4:	e8 f0 d9 ff ff       	call   8001b9 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8027c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027d4:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  8027db:	e8 94 e2 ff ff       	call   800a74 <memmove>
	nsipcbuf.send.req_size = size;
  8027e0:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  8027e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8027e9:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  8027ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8027f3:	e8 7b fd ff ff       	call   802573 <nsipc>
}
  8027f8:	83 c4 14             	add    $0x14,%esp
  8027fb:	5b                   	pop    %ebx
  8027fc:	5d                   	pop    %ebp
  8027fd:	c3                   	ret    

008027fe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8027fe:	55                   	push   %ebp
  8027ff:	89 e5                	mov    %esp,%ebp
  802801:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802804:	8b 45 08             	mov    0x8(%ebp),%eax
  802807:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  80280c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80280f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  802814:	8b 45 10             	mov    0x10(%ebp),%eax
  802817:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  80281c:	b8 09 00 00 00       	mov    $0x9,%eax
  802821:	e8 4d fd ff ff       	call   802573 <nsipc>
}
  802826:	c9                   	leave  
  802827:	c3                   	ret    

00802828 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802828:	55                   	push   %ebp
  802829:	89 e5                	mov    %esp,%ebp
  80282b:	56                   	push   %esi
  80282c:	53                   	push   %ebx
  80282d:	83 ec 10             	sub    $0x10,%esp
  802830:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802833:	8b 45 08             	mov    0x8(%ebp),%eax
  802836:	89 04 24             	mov    %eax,(%esp)
  802839:	e8 12 e8 ff ff       	call   801050 <fd2data>
  80283e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802840:	c7 44 24 04 59 37 80 	movl   $0x803759,0x4(%esp)
  802847:	00 
  802848:	89 1c 24             	mov    %ebx,(%esp)
  80284b:	e8 87 e0 ff ff       	call   8008d7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802850:	8b 46 04             	mov    0x4(%esi),%eax
  802853:	2b 06                	sub    (%esi),%eax
  802855:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80285b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802862:	00 00 00 
	stat->st_dev = &devpipe;
  802865:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80286c:	40 80 00 
	return 0;
}
  80286f:	b8 00 00 00 00       	mov    $0x0,%eax
  802874:	83 c4 10             	add    $0x10,%esp
  802877:	5b                   	pop    %ebx
  802878:	5e                   	pop    %esi
  802879:	5d                   	pop    %ebp
  80287a:	c3                   	ret    

0080287b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80287b:	55                   	push   %ebp
  80287c:	89 e5                	mov    %esp,%ebp
  80287e:	53                   	push   %ebx
  80287f:	83 ec 14             	sub    $0x14,%esp
  802882:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802885:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802889:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802890:	e8 05 e5 ff ff       	call   800d9a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802895:	89 1c 24             	mov    %ebx,(%esp)
  802898:	e8 b3 e7 ff ff       	call   801050 <fd2data>
  80289d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028a8:	e8 ed e4 ff ff       	call   800d9a <sys_page_unmap>
}
  8028ad:	83 c4 14             	add    $0x14,%esp
  8028b0:	5b                   	pop    %ebx
  8028b1:	5d                   	pop    %ebp
  8028b2:	c3                   	ret    

008028b3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8028b3:	55                   	push   %ebp
  8028b4:	89 e5                	mov    %esp,%ebp
  8028b6:	57                   	push   %edi
  8028b7:	56                   	push   %esi
  8028b8:	53                   	push   %ebx
  8028b9:	83 ec 2c             	sub    $0x2c,%esp
  8028bc:	89 c6                	mov    %eax,%esi
  8028be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8028c1:	a1 08 50 80 00       	mov    0x805008,%eax
  8028c6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8028c9:	89 34 24             	mov    %esi,(%esp)
  8028cc:	e8 be 05 00 00       	call   802e8f <pageref>
  8028d1:	89 c7                	mov    %eax,%edi
  8028d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028d6:	89 04 24             	mov    %eax,(%esp)
  8028d9:	e8 b1 05 00 00       	call   802e8f <pageref>
  8028de:	39 c7                	cmp    %eax,%edi
  8028e0:	0f 94 c2             	sete   %dl
  8028e3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8028e6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8028ec:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8028ef:	39 fb                	cmp    %edi,%ebx
  8028f1:	74 21                	je     802914 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8028f3:	84 d2                	test   %dl,%dl
  8028f5:	74 ca                	je     8028c1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8028f7:	8b 51 58             	mov    0x58(%ecx),%edx
  8028fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8028fe:	89 54 24 08          	mov    %edx,0x8(%esp)
  802902:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802906:	c7 04 24 60 37 80 00 	movl   $0x803760,(%esp)
  80290d:	e8 a0 d9 ff ff       	call   8002b2 <cprintf>
  802912:	eb ad                	jmp    8028c1 <_pipeisclosed+0xe>
	}
}
  802914:	83 c4 2c             	add    $0x2c,%esp
  802917:	5b                   	pop    %ebx
  802918:	5e                   	pop    %esi
  802919:	5f                   	pop    %edi
  80291a:	5d                   	pop    %ebp
  80291b:	c3                   	ret    

0080291c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80291c:	55                   	push   %ebp
  80291d:	89 e5                	mov    %esp,%ebp
  80291f:	57                   	push   %edi
  802920:	56                   	push   %esi
  802921:	53                   	push   %ebx
  802922:	83 ec 1c             	sub    $0x1c,%esp
  802925:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802928:	89 34 24             	mov    %esi,(%esp)
  80292b:	e8 20 e7 ff ff       	call   801050 <fd2data>
  802930:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802932:	bf 00 00 00 00       	mov    $0x0,%edi
  802937:	eb 45                	jmp    80297e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802939:	89 da                	mov    %ebx,%edx
  80293b:	89 f0                	mov    %esi,%eax
  80293d:	e8 71 ff ff ff       	call   8028b3 <_pipeisclosed>
  802942:	85 c0                	test   %eax,%eax
  802944:	75 41                	jne    802987 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802946:	e8 89 e3 ff ff       	call   800cd4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80294b:	8b 43 04             	mov    0x4(%ebx),%eax
  80294e:	8b 0b                	mov    (%ebx),%ecx
  802950:	8d 51 20             	lea    0x20(%ecx),%edx
  802953:	39 d0                	cmp    %edx,%eax
  802955:	73 e2                	jae    802939 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802957:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80295a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80295e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802961:	99                   	cltd   
  802962:	c1 ea 1b             	shr    $0x1b,%edx
  802965:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802968:	83 e1 1f             	and    $0x1f,%ecx
  80296b:	29 d1                	sub    %edx,%ecx
  80296d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802971:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802975:	83 c0 01             	add    $0x1,%eax
  802978:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80297b:	83 c7 01             	add    $0x1,%edi
  80297e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802981:	75 c8                	jne    80294b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802983:	89 f8                	mov    %edi,%eax
  802985:	eb 05                	jmp    80298c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802987:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80298c:	83 c4 1c             	add    $0x1c,%esp
  80298f:	5b                   	pop    %ebx
  802990:	5e                   	pop    %esi
  802991:	5f                   	pop    %edi
  802992:	5d                   	pop    %ebp
  802993:	c3                   	ret    

00802994 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802994:	55                   	push   %ebp
  802995:	89 e5                	mov    %esp,%ebp
  802997:	57                   	push   %edi
  802998:	56                   	push   %esi
  802999:	53                   	push   %ebx
  80299a:	83 ec 1c             	sub    $0x1c,%esp
  80299d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8029a0:	89 3c 24             	mov    %edi,(%esp)
  8029a3:	e8 a8 e6 ff ff       	call   801050 <fd2data>
  8029a8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8029aa:	be 00 00 00 00       	mov    $0x0,%esi
  8029af:	eb 3d                	jmp    8029ee <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8029b1:	85 f6                	test   %esi,%esi
  8029b3:	74 04                	je     8029b9 <devpipe_read+0x25>
				return i;
  8029b5:	89 f0                	mov    %esi,%eax
  8029b7:	eb 43                	jmp    8029fc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8029b9:	89 da                	mov    %ebx,%edx
  8029bb:	89 f8                	mov    %edi,%eax
  8029bd:	e8 f1 fe ff ff       	call   8028b3 <_pipeisclosed>
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	75 31                	jne    8029f7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8029c6:	e8 09 e3 ff ff       	call   800cd4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8029cb:	8b 03                	mov    (%ebx),%eax
  8029cd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8029d0:	74 df                	je     8029b1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8029d2:	99                   	cltd   
  8029d3:	c1 ea 1b             	shr    $0x1b,%edx
  8029d6:	01 d0                	add    %edx,%eax
  8029d8:	83 e0 1f             	and    $0x1f,%eax
  8029db:	29 d0                	sub    %edx,%eax
  8029dd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8029e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029e5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8029e8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8029eb:	83 c6 01             	add    $0x1,%esi
  8029ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8029f1:	75 d8                	jne    8029cb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8029f3:	89 f0                	mov    %esi,%eax
  8029f5:	eb 05                	jmp    8029fc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8029f7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8029fc:	83 c4 1c             	add    $0x1c,%esp
  8029ff:	5b                   	pop    %ebx
  802a00:	5e                   	pop    %esi
  802a01:	5f                   	pop    %edi
  802a02:	5d                   	pop    %ebp
  802a03:	c3                   	ret    

00802a04 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802a04:	55                   	push   %ebp
  802a05:	89 e5                	mov    %esp,%ebp
  802a07:	56                   	push   %esi
  802a08:	53                   	push   %ebx
  802a09:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802a0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a0f:	89 04 24             	mov    %eax,(%esp)
  802a12:	e8 50 e6 ff ff       	call   801067 <fd_alloc>
  802a17:	89 c2                	mov    %eax,%edx
  802a19:	85 d2                	test   %edx,%edx
  802a1b:	0f 88 4d 01 00 00    	js     802b6e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a21:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a28:	00 
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a37:	e8 b7 e2 ff ff       	call   800cf3 <sys_page_alloc>
  802a3c:	89 c2                	mov    %eax,%edx
  802a3e:	85 d2                	test   %edx,%edx
  802a40:	0f 88 28 01 00 00    	js     802b6e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802a46:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802a49:	89 04 24             	mov    %eax,(%esp)
  802a4c:	e8 16 e6 ff ff       	call   801067 <fd_alloc>
  802a51:	89 c3                	mov    %eax,%ebx
  802a53:	85 c0                	test   %eax,%eax
  802a55:	0f 88 fe 00 00 00    	js     802b59 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a5b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a62:	00 
  802a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a66:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a71:	e8 7d e2 ff ff       	call   800cf3 <sys_page_alloc>
  802a76:	89 c3                	mov    %eax,%ebx
  802a78:	85 c0                	test   %eax,%eax
  802a7a:	0f 88 d9 00 00 00    	js     802b59 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	89 04 24             	mov    %eax,(%esp)
  802a86:	e8 c5 e5 ff ff       	call   801050 <fd2data>
  802a8b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802a8d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a94:	00 
  802a95:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a99:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802aa0:	e8 4e e2 ff ff       	call   800cf3 <sys_page_alloc>
  802aa5:	89 c3                	mov    %eax,%ebx
  802aa7:	85 c0                	test   %eax,%eax
  802aa9:	0f 88 97 00 00 00    	js     802b46 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab2:	89 04 24             	mov    %eax,(%esp)
  802ab5:	e8 96 e5 ff ff       	call   801050 <fd2data>
  802aba:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802ac1:	00 
  802ac2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ac6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802acd:	00 
  802ace:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ad2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ad9:	e8 69 e2 ff ff       	call   800d47 <sys_page_map>
  802ade:	89 c3                	mov    %eax,%ebx
  802ae0:	85 c0                	test   %eax,%eax
  802ae2:	78 52                	js     802b36 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802ae4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802af9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b02:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b07:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	89 04 24             	mov    %eax,(%esp)
  802b14:	e8 27 e5 ff ff       	call   801040 <fd2num>
  802b19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b1c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b21:	89 04 24             	mov    %eax,(%esp)
  802b24:	e8 17 e5 ff ff       	call   801040 <fd2num>
  802b29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b2c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b34:	eb 38                	jmp    802b6e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802b36:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b41:	e8 54 e2 ff ff       	call   800d9a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b49:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b4d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b54:	e8 41 e2 ff ff       	call   800d9a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b67:	e8 2e e2 ff ff       	call   800d9a <sys_page_unmap>
  802b6c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802b6e:	83 c4 30             	add    $0x30,%esp
  802b71:	5b                   	pop    %ebx
  802b72:	5e                   	pop    %esi
  802b73:	5d                   	pop    %ebp
  802b74:	c3                   	ret    

00802b75 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802b75:	55                   	push   %ebp
  802b76:	89 e5                	mov    %esp,%ebp
  802b78:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	89 04 24             	mov    %eax,(%esp)
  802b88:	e8 29 e5 ff ff       	call   8010b6 <fd_lookup>
  802b8d:	89 c2                	mov    %eax,%edx
  802b8f:	85 d2                	test   %edx,%edx
  802b91:	78 15                	js     802ba8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	89 04 24             	mov    %eax,(%esp)
  802b99:	e8 b2 e4 ff ff       	call   801050 <fd2data>
	return _pipeisclosed(fd, p);
  802b9e:	89 c2                	mov    %eax,%edx
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	e8 0b fd ff ff       	call   8028b3 <_pipeisclosed>
}
  802ba8:	c9                   	leave  
  802ba9:	c3                   	ret    
  802baa:	66 90                	xchg   %ax,%ax
  802bac:	66 90                	xchg   %ax,%ax
  802bae:	66 90                	xchg   %ax,%ax

00802bb0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802bb0:	55                   	push   %ebp
  802bb1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb8:	5d                   	pop    %ebp
  802bb9:	c3                   	ret    

00802bba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802bba:	55                   	push   %ebp
  802bbb:	89 e5                	mov    %esp,%ebp
  802bbd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802bc0:	c7 44 24 04 78 37 80 	movl   $0x803778,0x4(%esp)
  802bc7:	00 
  802bc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bcb:	89 04 24             	mov    %eax,(%esp)
  802bce:	e8 04 dd ff ff       	call   8008d7 <strcpy>
	return 0;
}
  802bd3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bd8:	c9                   	leave  
  802bd9:	c3                   	ret    

00802bda <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802bda:	55                   	push   %ebp
  802bdb:	89 e5                	mov    %esp,%ebp
  802bdd:	57                   	push   %edi
  802bde:	56                   	push   %esi
  802bdf:	53                   	push   %ebx
  802be0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802be6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802beb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802bf1:	eb 31                	jmp    802c24 <devcons_write+0x4a>
		m = n - tot;
  802bf3:	8b 75 10             	mov    0x10(%ebp),%esi
  802bf6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802bf8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802bfb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802c00:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802c03:	89 74 24 08          	mov    %esi,0x8(%esp)
  802c07:	03 45 0c             	add    0xc(%ebp),%eax
  802c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c0e:	89 3c 24             	mov    %edi,(%esp)
  802c11:	e8 5e de ff ff       	call   800a74 <memmove>
		sys_cputs(buf, m);
  802c16:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c1a:	89 3c 24             	mov    %edi,(%esp)
  802c1d:	e8 04 e0 ff ff       	call   800c26 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802c22:	01 f3                	add    %esi,%ebx
  802c24:	89 d8                	mov    %ebx,%eax
  802c26:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802c29:	72 c8                	jb     802bf3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802c2b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802c31:	5b                   	pop    %ebx
  802c32:	5e                   	pop    %esi
  802c33:	5f                   	pop    %edi
  802c34:	5d                   	pop    %ebp
  802c35:	c3                   	ret    

00802c36 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802c36:	55                   	push   %ebp
  802c37:	89 e5                	mov    %esp,%ebp
  802c39:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802c3c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802c41:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802c45:	75 07                	jne    802c4e <devcons_read+0x18>
  802c47:	eb 2a                	jmp    802c73 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802c49:	e8 86 e0 ff ff       	call   800cd4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802c4e:	66 90                	xchg   %ax,%ax
  802c50:	e8 ef df ff ff       	call   800c44 <sys_cgetc>
  802c55:	85 c0                	test   %eax,%eax
  802c57:	74 f0                	je     802c49 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802c59:	85 c0                	test   %eax,%eax
  802c5b:	78 16                	js     802c73 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802c5d:	83 f8 04             	cmp    $0x4,%eax
  802c60:	74 0c                	je     802c6e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c65:	88 02                	mov    %al,(%edx)
	return 1;
  802c67:	b8 01 00 00 00       	mov    $0x1,%eax
  802c6c:	eb 05                	jmp    802c73 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802c6e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802c73:	c9                   	leave  
  802c74:	c3                   	ret    

00802c75 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802c75:	55                   	push   %ebp
  802c76:	89 e5                	mov    %esp,%ebp
  802c78:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802c81:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802c88:	00 
  802c89:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802c8c:	89 04 24             	mov    %eax,(%esp)
  802c8f:	e8 92 df ff ff       	call   800c26 <sys_cputs>
}
  802c94:	c9                   	leave  
  802c95:	c3                   	ret    

00802c96 <getchar>:

int
getchar(void)
{
  802c96:	55                   	push   %ebp
  802c97:	89 e5                	mov    %esp,%ebp
  802c99:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802c9c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802ca3:	00 
  802ca4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802ca7:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cb2:	e8 93 e6 ff ff       	call   80134a <read>
	if (r < 0)
  802cb7:	85 c0                	test   %eax,%eax
  802cb9:	78 0f                	js     802cca <getchar+0x34>
		return r;
	if (r < 1)
  802cbb:	85 c0                	test   %eax,%eax
  802cbd:	7e 06                	jle    802cc5 <getchar+0x2f>
		return -E_EOF;
	return c;
  802cbf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802cc3:	eb 05                	jmp    802cca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802cc5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802cca:	c9                   	leave  
  802ccb:	c3                   	ret    

00802ccc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802ccc:	55                   	push   %ebp
  802ccd:	89 e5                	mov    %esp,%ebp
  802ccf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802cd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	89 04 24             	mov    %eax,(%esp)
  802cdf:	e8 d2 e3 ff ff       	call   8010b6 <fd_lookup>
  802ce4:	85 c0                	test   %eax,%eax
  802ce6:	78 11                	js     802cf9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802cf1:	39 10                	cmp    %edx,(%eax)
  802cf3:	0f 94 c0             	sete   %al
  802cf6:	0f b6 c0             	movzbl %al,%eax
}
  802cf9:	c9                   	leave  
  802cfa:	c3                   	ret    

00802cfb <opencons>:

int
opencons(void)
{
  802cfb:	55                   	push   %ebp
  802cfc:	89 e5                	mov    %esp,%ebp
  802cfe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802d01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802d04:	89 04 24             	mov    %eax,(%esp)
  802d07:	e8 5b e3 ff ff       	call   801067 <fd_alloc>
		return r;
  802d0c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802d0e:	85 c0                	test   %eax,%eax
  802d10:	78 40                	js     802d52 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802d12:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802d19:	00 
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d28:	e8 c6 df ff ff       	call   800cf3 <sys_page_alloc>
		return r;
  802d2d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802d2f:	85 c0                	test   %eax,%eax
  802d31:	78 1f                	js     802d52 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802d33:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d41:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802d48:	89 04 24             	mov    %eax,(%esp)
  802d4b:	e8 f0 e2 ff ff       	call   801040 <fd2num>
  802d50:	89 c2                	mov    %eax,%edx
}
  802d52:	89 d0                	mov    %edx,%eax
  802d54:	c9                   	leave  
  802d55:	c3                   	ret    
  802d56:	66 90                	xchg   %ax,%ax
  802d58:	66 90                	xchg   %ax,%ax
  802d5a:	66 90                	xchg   %ax,%ax
  802d5c:	66 90                	xchg   %ax,%ax
  802d5e:	66 90                	xchg   %ax,%ax

00802d60 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802d60:	55                   	push   %ebp
  802d61:	89 e5                	mov    %esp,%ebp
  802d63:	56                   	push   %esi
  802d64:	53                   	push   %ebx
  802d65:	83 ec 10             	sub    $0x10,%esp
  802d68:	8b 75 08             	mov    0x8(%ebp),%esi
  802d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802d71:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802d73:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802d78:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  802d7b:	89 04 24             	mov    %eax,(%esp)
  802d7e:	e8 86 e1 ff ff       	call   800f09 <sys_ipc_recv>
  802d83:	85 c0                	test   %eax,%eax
  802d85:	74 16                	je     802d9d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802d87:	85 f6                	test   %esi,%esi
  802d89:	74 06                	je     802d91 <ipc_recv+0x31>
			*from_env_store = 0;
  802d8b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802d91:	85 db                	test   %ebx,%ebx
  802d93:	74 2c                	je     802dc1 <ipc_recv+0x61>
			*perm_store = 0;
  802d95:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802d9b:	eb 24                	jmp    802dc1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  802d9d:	85 f6                	test   %esi,%esi
  802d9f:	74 0a                	je     802dab <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802da1:	a1 08 50 80 00       	mov    0x805008,%eax
  802da6:	8b 40 74             	mov    0x74(%eax),%eax
  802da9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  802dab:	85 db                	test   %ebx,%ebx
  802dad:	74 0a                	je     802db9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  802daf:	a1 08 50 80 00       	mov    0x805008,%eax
  802db4:	8b 40 78             	mov    0x78(%eax),%eax
  802db7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802db9:	a1 08 50 80 00       	mov    0x805008,%eax
  802dbe:	8b 40 70             	mov    0x70(%eax),%eax
}
  802dc1:	83 c4 10             	add    $0x10,%esp
  802dc4:	5b                   	pop    %ebx
  802dc5:	5e                   	pop    %esi
  802dc6:	5d                   	pop    %ebp
  802dc7:	c3                   	ret    

00802dc8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802dc8:	55                   	push   %ebp
  802dc9:	89 e5                	mov    %esp,%ebp
  802dcb:	57                   	push   %edi
  802dcc:	56                   	push   %esi
  802dcd:	53                   	push   %ebx
  802dce:	83 ec 1c             	sub    $0x1c,%esp
  802dd1:	8b 75 0c             	mov    0xc(%ebp),%esi
  802dd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802dd7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  802dda:	85 db                	test   %ebx,%ebx
  802ddc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802de1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802de4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802de8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802dec:	89 74 24 04          	mov    %esi,0x4(%esp)
  802df0:	8b 45 08             	mov    0x8(%ebp),%eax
  802df3:	89 04 24             	mov    %eax,(%esp)
  802df6:	e8 eb e0 ff ff       	call   800ee6 <sys_ipc_try_send>
	if (r == 0) return;
  802dfb:	85 c0                	test   %eax,%eax
  802dfd:	75 22                	jne    802e21 <ipc_send+0x59>
  802dff:	eb 4c                	jmp    802e4d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802e01:	84 d2                	test   %dl,%dl
  802e03:	75 48                	jne    802e4d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802e05:	e8 ca de ff ff       	call   800cd4 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  802e0a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e0e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e12:	89 74 24 04          	mov    %esi,0x4(%esp)
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	89 04 24             	mov    %eax,(%esp)
  802e1c:	e8 c5 e0 ff ff       	call   800ee6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802e21:	85 c0                	test   %eax,%eax
  802e23:	0f 94 c2             	sete   %dl
  802e26:	74 d9                	je     802e01 <ipc_send+0x39>
  802e28:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802e2b:	74 d4                	je     802e01 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  802e2d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e31:	c7 44 24 08 84 37 80 	movl   $0x803784,0x8(%esp)
  802e38:	00 
  802e39:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802e40:	00 
  802e41:	c7 04 24 92 37 80 00 	movl   $0x803792,(%esp)
  802e48:	e8 6c d3 ff ff       	call   8001b9 <_panic>
}
  802e4d:	83 c4 1c             	add    $0x1c,%esp
  802e50:	5b                   	pop    %ebx
  802e51:	5e                   	pop    %esi
  802e52:	5f                   	pop    %edi
  802e53:	5d                   	pop    %ebp
  802e54:	c3                   	ret    

00802e55 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802e55:	55                   	push   %ebp
  802e56:	89 e5                	mov    %esp,%ebp
  802e58:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802e5b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802e60:	89 c2                	mov    %eax,%edx
  802e62:	c1 e2 07             	shl    $0x7,%edx
  802e65:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802e6b:	8b 52 50             	mov    0x50(%edx),%edx
  802e6e:	39 ca                	cmp    %ecx,%edx
  802e70:	75 0d                	jne    802e7f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802e72:	c1 e0 07             	shl    $0x7,%eax
  802e75:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802e7a:	8b 40 40             	mov    0x40(%eax),%eax
  802e7d:	eb 0e                	jmp    802e8d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802e7f:	83 c0 01             	add    $0x1,%eax
  802e82:	3d 00 04 00 00       	cmp    $0x400,%eax
  802e87:	75 d7                	jne    802e60 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802e89:	66 b8 00 00          	mov    $0x0,%ax
}
  802e8d:	5d                   	pop    %ebp
  802e8e:	c3                   	ret    

00802e8f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802e8f:	55                   	push   %ebp
  802e90:	89 e5                	mov    %esp,%ebp
  802e92:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802e95:	89 d0                	mov    %edx,%eax
  802e97:	c1 e8 16             	shr    $0x16,%eax
  802e9a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802ea1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ea6:	f6 c1 01             	test   $0x1,%cl
  802ea9:	74 1d                	je     802ec8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802eab:	c1 ea 0c             	shr    $0xc,%edx
  802eae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802eb5:	f6 c2 01             	test   $0x1,%dl
  802eb8:	74 0e                	je     802ec8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802eba:	c1 ea 0c             	shr    $0xc,%edx
  802ebd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802ec4:	ef 
  802ec5:	0f b7 c0             	movzwl %ax,%eax
}
  802ec8:	5d                   	pop    %ebp
  802ec9:	c3                   	ret    
  802eca:	66 90                	xchg   %ax,%ax
  802ecc:	66 90                	xchg   %ax,%ax
  802ece:	66 90                	xchg   %ax,%ax

00802ed0 <__udivdi3>:
  802ed0:	55                   	push   %ebp
  802ed1:	57                   	push   %edi
  802ed2:	56                   	push   %esi
  802ed3:	83 ec 0c             	sub    $0xc,%esp
  802ed6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802eda:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802ede:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802ee2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802ee6:	85 c0                	test   %eax,%eax
  802ee8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802eec:	89 ea                	mov    %ebp,%edx
  802eee:	89 0c 24             	mov    %ecx,(%esp)
  802ef1:	75 2d                	jne    802f20 <__udivdi3+0x50>
  802ef3:	39 e9                	cmp    %ebp,%ecx
  802ef5:	77 61                	ja     802f58 <__udivdi3+0x88>
  802ef7:	85 c9                	test   %ecx,%ecx
  802ef9:	89 ce                	mov    %ecx,%esi
  802efb:	75 0b                	jne    802f08 <__udivdi3+0x38>
  802efd:	b8 01 00 00 00       	mov    $0x1,%eax
  802f02:	31 d2                	xor    %edx,%edx
  802f04:	f7 f1                	div    %ecx
  802f06:	89 c6                	mov    %eax,%esi
  802f08:	31 d2                	xor    %edx,%edx
  802f0a:	89 e8                	mov    %ebp,%eax
  802f0c:	f7 f6                	div    %esi
  802f0e:	89 c5                	mov    %eax,%ebp
  802f10:	89 f8                	mov    %edi,%eax
  802f12:	f7 f6                	div    %esi
  802f14:	89 ea                	mov    %ebp,%edx
  802f16:	83 c4 0c             	add    $0xc,%esp
  802f19:	5e                   	pop    %esi
  802f1a:	5f                   	pop    %edi
  802f1b:	5d                   	pop    %ebp
  802f1c:	c3                   	ret    
  802f1d:	8d 76 00             	lea    0x0(%esi),%esi
  802f20:	39 e8                	cmp    %ebp,%eax
  802f22:	77 24                	ja     802f48 <__udivdi3+0x78>
  802f24:	0f bd e8             	bsr    %eax,%ebp
  802f27:	83 f5 1f             	xor    $0x1f,%ebp
  802f2a:	75 3c                	jne    802f68 <__udivdi3+0x98>
  802f2c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802f30:	39 34 24             	cmp    %esi,(%esp)
  802f33:	0f 86 9f 00 00 00    	jbe    802fd8 <__udivdi3+0x108>
  802f39:	39 d0                	cmp    %edx,%eax
  802f3b:	0f 82 97 00 00 00    	jb     802fd8 <__udivdi3+0x108>
  802f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802f48:	31 d2                	xor    %edx,%edx
  802f4a:	31 c0                	xor    %eax,%eax
  802f4c:	83 c4 0c             	add    $0xc,%esp
  802f4f:	5e                   	pop    %esi
  802f50:	5f                   	pop    %edi
  802f51:	5d                   	pop    %ebp
  802f52:	c3                   	ret    
  802f53:	90                   	nop
  802f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f58:	89 f8                	mov    %edi,%eax
  802f5a:	f7 f1                	div    %ecx
  802f5c:	31 d2                	xor    %edx,%edx
  802f5e:	83 c4 0c             	add    $0xc,%esp
  802f61:	5e                   	pop    %esi
  802f62:	5f                   	pop    %edi
  802f63:	5d                   	pop    %ebp
  802f64:	c3                   	ret    
  802f65:	8d 76 00             	lea    0x0(%esi),%esi
  802f68:	89 e9                	mov    %ebp,%ecx
  802f6a:	8b 3c 24             	mov    (%esp),%edi
  802f6d:	d3 e0                	shl    %cl,%eax
  802f6f:	89 c6                	mov    %eax,%esi
  802f71:	b8 20 00 00 00       	mov    $0x20,%eax
  802f76:	29 e8                	sub    %ebp,%eax
  802f78:	89 c1                	mov    %eax,%ecx
  802f7a:	d3 ef                	shr    %cl,%edi
  802f7c:	89 e9                	mov    %ebp,%ecx
  802f7e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802f82:	8b 3c 24             	mov    (%esp),%edi
  802f85:	09 74 24 08          	or     %esi,0x8(%esp)
  802f89:	89 d6                	mov    %edx,%esi
  802f8b:	d3 e7                	shl    %cl,%edi
  802f8d:	89 c1                	mov    %eax,%ecx
  802f8f:	89 3c 24             	mov    %edi,(%esp)
  802f92:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802f96:	d3 ee                	shr    %cl,%esi
  802f98:	89 e9                	mov    %ebp,%ecx
  802f9a:	d3 e2                	shl    %cl,%edx
  802f9c:	89 c1                	mov    %eax,%ecx
  802f9e:	d3 ef                	shr    %cl,%edi
  802fa0:	09 d7                	or     %edx,%edi
  802fa2:	89 f2                	mov    %esi,%edx
  802fa4:	89 f8                	mov    %edi,%eax
  802fa6:	f7 74 24 08          	divl   0x8(%esp)
  802faa:	89 d6                	mov    %edx,%esi
  802fac:	89 c7                	mov    %eax,%edi
  802fae:	f7 24 24             	mull   (%esp)
  802fb1:	39 d6                	cmp    %edx,%esi
  802fb3:	89 14 24             	mov    %edx,(%esp)
  802fb6:	72 30                	jb     802fe8 <__udivdi3+0x118>
  802fb8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802fbc:	89 e9                	mov    %ebp,%ecx
  802fbe:	d3 e2                	shl    %cl,%edx
  802fc0:	39 c2                	cmp    %eax,%edx
  802fc2:	73 05                	jae    802fc9 <__udivdi3+0xf9>
  802fc4:	3b 34 24             	cmp    (%esp),%esi
  802fc7:	74 1f                	je     802fe8 <__udivdi3+0x118>
  802fc9:	89 f8                	mov    %edi,%eax
  802fcb:	31 d2                	xor    %edx,%edx
  802fcd:	e9 7a ff ff ff       	jmp    802f4c <__udivdi3+0x7c>
  802fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802fd8:	31 d2                	xor    %edx,%edx
  802fda:	b8 01 00 00 00       	mov    $0x1,%eax
  802fdf:	e9 68 ff ff ff       	jmp    802f4c <__udivdi3+0x7c>
  802fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802fe8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802feb:	31 d2                	xor    %edx,%edx
  802fed:	83 c4 0c             	add    $0xc,%esp
  802ff0:	5e                   	pop    %esi
  802ff1:	5f                   	pop    %edi
  802ff2:	5d                   	pop    %ebp
  802ff3:	c3                   	ret    
  802ff4:	66 90                	xchg   %ax,%ax
  802ff6:	66 90                	xchg   %ax,%ax
  802ff8:	66 90                	xchg   %ax,%ax
  802ffa:	66 90                	xchg   %ax,%ax
  802ffc:	66 90                	xchg   %ax,%ax
  802ffe:	66 90                	xchg   %ax,%ax

00803000 <__umoddi3>:
  803000:	55                   	push   %ebp
  803001:	57                   	push   %edi
  803002:	56                   	push   %esi
  803003:	83 ec 14             	sub    $0x14,%esp
  803006:	8b 44 24 28          	mov    0x28(%esp),%eax
  80300a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80300e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803012:	89 c7                	mov    %eax,%edi
  803014:	89 44 24 04          	mov    %eax,0x4(%esp)
  803018:	8b 44 24 30          	mov    0x30(%esp),%eax
  80301c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803020:	89 34 24             	mov    %esi,(%esp)
  803023:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803027:	85 c0                	test   %eax,%eax
  803029:	89 c2                	mov    %eax,%edx
  80302b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80302f:	75 17                	jne    803048 <__umoddi3+0x48>
  803031:	39 fe                	cmp    %edi,%esi
  803033:	76 4b                	jbe    803080 <__umoddi3+0x80>
  803035:	89 c8                	mov    %ecx,%eax
  803037:	89 fa                	mov    %edi,%edx
  803039:	f7 f6                	div    %esi
  80303b:	89 d0                	mov    %edx,%eax
  80303d:	31 d2                	xor    %edx,%edx
  80303f:	83 c4 14             	add    $0x14,%esp
  803042:	5e                   	pop    %esi
  803043:	5f                   	pop    %edi
  803044:	5d                   	pop    %ebp
  803045:	c3                   	ret    
  803046:	66 90                	xchg   %ax,%ax
  803048:	39 f8                	cmp    %edi,%eax
  80304a:	77 54                	ja     8030a0 <__umoddi3+0xa0>
  80304c:	0f bd e8             	bsr    %eax,%ebp
  80304f:	83 f5 1f             	xor    $0x1f,%ebp
  803052:	75 5c                	jne    8030b0 <__umoddi3+0xb0>
  803054:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803058:	39 3c 24             	cmp    %edi,(%esp)
  80305b:	0f 87 e7 00 00 00    	ja     803148 <__umoddi3+0x148>
  803061:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803065:	29 f1                	sub    %esi,%ecx
  803067:	19 c7                	sbb    %eax,%edi
  803069:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80306d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803071:	8b 44 24 08          	mov    0x8(%esp),%eax
  803075:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803079:	83 c4 14             	add    $0x14,%esp
  80307c:	5e                   	pop    %esi
  80307d:	5f                   	pop    %edi
  80307e:	5d                   	pop    %ebp
  80307f:	c3                   	ret    
  803080:	85 f6                	test   %esi,%esi
  803082:	89 f5                	mov    %esi,%ebp
  803084:	75 0b                	jne    803091 <__umoddi3+0x91>
  803086:	b8 01 00 00 00       	mov    $0x1,%eax
  80308b:	31 d2                	xor    %edx,%edx
  80308d:	f7 f6                	div    %esi
  80308f:	89 c5                	mov    %eax,%ebp
  803091:	8b 44 24 04          	mov    0x4(%esp),%eax
  803095:	31 d2                	xor    %edx,%edx
  803097:	f7 f5                	div    %ebp
  803099:	89 c8                	mov    %ecx,%eax
  80309b:	f7 f5                	div    %ebp
  80309d:	eb 9c                	jmp    80303b <__umoddi3+0x3b>
  80309f:	90                   	nop
  8030a0:	89 c8                	mov    %ecx,%eax
  8030a2:	89 fa                	mov    %edi,%edx
  8030a4:	83 c4 14             	add    $0x14,%esp
  8030a7:	5e                   	pop    %esi
  8030a8:	5f                   	pop    %edi
  8030a9:	5d                   	pop    %ebp
  8030aa:	c3                   	ret    
  8030ab:	90                   	nop
  8030ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8030b0:	8b 04 24             	mov    (%esp),%eax
  8030b3:	be 20 00 00 00       	mov    $0x20,%esi
  8030b8:	89 e9                	mov    %ebp,%ecx
  8030ba:	29 ee                	sub    %ebp,%esi
  8030bc:	d3 e2                	shl    %cl,%edx
  8030be:	89 f1                	mov    %esi,%ecx
  8030c0:	d3 e8                	shr    %cl,%eax
  8030c2:	89 e9                	mov    %ebp,%ecx
  8030c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030c8:	8b 04 24             	mov    (%esp),%eax
  8030cb:	09 54 24 04          	or     %edx,0x4(%esp)
  8030cf:	89 fa                	mov    %edi,%edx
  8030d1:	d3 e0                	shl    %cl,%eax
  8030d3:	89 f1                	mov    %esi,%ecx
  8030d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8030d9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8030dd:	d3 ea                	shr    %cl,%edx
  8030df:	89 e9                	mov    %ebp,%ecx
  8030e1:	d3 e7                	shl    %cl,%edi
  8030e3:	89 f1                	mov    %esi,%ecx
  8030e5:	d3 e8                	shr    %cl,%eax
  8030e7:	89 e9                	mov    %ebp,%ecx
  8030e9:	09 f8                	or     %edi,%eax
  8030eb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8030ef:	f7 74 24 04          	divl   0x4(%esp)
  8030f3:	d3 e7                	shl    %cl,%edi
  8030f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030f9:	89 d7                	mov    %edx,%edi
  8030fb:	f7 64 24 08          	mull   0x8(%esp)
  8030ff:	39 d7                	cmp    %edx,%edi
  803101:	89 c1                	mov    %eax,%ecx
  803103:	89 14 24             	mov    %edx,(%esp)
  803106:	72 2c                	jb     803134 <__umoddi3+0x134>
  803108:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80310c:	72 22                	jb     803130 <__umoddi3+0x130>
  80310e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803112:	29 c8                	sub    %ecx,%eax
  803114:	19 d7                	sbb    %edx,%edi
  803116:	89 e9                	mov    %ebp,%ecx
  803118:	89 fa                	mov    %edi,%edx
  80311a:	d3 e8                	shr    %cl,%eax
  80311c:	89 f1                	mov    %esi,%ecx
  80311e:	d3 e2                	shl    %cl,%edx
  803120:	89 e9                	mov    %ebp,%ecx
  803122:	d3 ef                	shr    %cl,%edi
  803124:	09 d0                	or     %edx,%eax
  803126:	89 fa                	mov    %edi,%edx
  803128:	83 c4 14             	add    $0x14,%esp
  80312b:	5e                   	pop    %esi
  80312c:	5f                   	pop    %edi
  80312d:	5d                   	pop    %ebp
  80312e:	c3                   	ret    
  80312f:	90                   	nop
  803130:	39 d7                	cmp    %edx,%edi
  803132:	75 da                	jne    80310e <__umoddi3+0x10e>
  803134:	8b 14 24             	mov    (%esp),%edx
  803137:	89 c1                	mov    %eax,%ecx
  803139:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80313d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803141:	eb cb                	jmp    80310e <__umoddi3+0x10e>
  803143:	90                   	nop
  803144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803148:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80314c:	0f 82 0f ff ff ff    	jb     803061 <__umoddi3+0x61>
  803152:	e9 1a ff ff ff       	jmp    803071 <__umoddi3+0x71>
