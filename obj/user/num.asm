
obj/user/num.debug:     file format elf32-i386


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
  80002c:	e8 95 01 00 00       	call   8001c6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <num>:
int bol = 1;
int line = 0;

void
num(int f, const char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 30             	sub    $0x30,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  80003e:	8d 5d f7             	lea    -0x9(%ebp),%ebx
  800041:	e9 84 00 00 00       	jmp    8000ca <num+0x97>
		if (bol) {
  800046:	83 3d 00 30 80 00 00 	cmpl   $0x0,0x803000
  80004d:	74 27                	je     800076 <num+0x43>
			printf("%5d ", ++line);
  80004f:	a1 00 40 80 00       	mov    0x804000,%eax
  800054:	83 c0 01             	add    $0x1,%eax
  800057:	a3 00 40 80 00       	mov    %eax,0x804000
  80005c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800060:	c7 04 24 20 29 80 00 	movl   $0x802920,(%esp)
  800067:	e8 33 1a 00 00       	call   801a9f <printf>
			bol = 0;
  80006c:	c7 05 00 30 80 00 00 	movl   $0x0,0x803000
  800073:	00 00 00 
		}
		if ((r = write(1, &c, 1)) != 1)
  800076:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80007d:	00 
  80007e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800082:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800089:	e8 09 14 00 00       	call   801497 <write>
  80008e:	83 f8 01             	cmp    $0x1,%eax
  800091:	74 27                	je     8000ba <num+0x87>
			panic("write error copying %s: %e", s, r);
  800093:	89 44 24 10          	mov    %eax,0x10(%esp)
  800097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80009a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80009e:	c7 44 24 08 25 29 80 	movl   $0x802925,0x8(%esp)
  8000a5:	00 
  8000a6:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000ad:	00 
  8000ae:	c7 04 24 40 29 80 00 	movl   $0x802940,(%esp)
  8000b5:	e8 6d 01 00 00       	call   800227 <_panic>
		if (c == '\n')
  8000ba:	80 7d f7 0a          	cmpb   $0xa,-0x9(%ebp)
  8000be:	75 0a                	jne    8000ca <num+0x97>
			bol = 1;
  8000c0:	c7 05 00 30 80 00 01 	movl   $0x1,0x803000
  8000c7:	00 00 00 
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  8000ca:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000d1:	00 
  8000d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d6:	89 34 24             	mov    %esi,(%esp)
  8000d9:	e8 dc 12 00 00       	call   8013ba <read>
  8000de:	85 c0                	test   %eax,%eax
  8000e0:	0f 8f 60 ff ff ff    	jg     800046 <num+0x13>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  8000e6:	85 c0                	test   %eax,%eax
  8000e8:	79 27                	jns    800111 <num+0xde>
		panic("error reading %s: %e", s, n);
  8000ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f5:	c7 44 24 08 4b 29 80 	movl   $0x80294b,0x8(%esp)
  8000fc:	00 
  8000fd:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  800104:	00 
  800105:	c7 04 24 40 29 80 00 	movl   $0x802940,(%esp)
  80010c:	e8 16 01 00 00       	call   800227 <_panic>
}
  800111:	83 c4 30             	add    $0x30,%esp
  800114:	5b                   	pop    %ebx
  800115:	5e                   	pop    %esi
  800116:	5d                   	pop    %ebp
  800117:	c3                   	ret    

00800118 <umain>:

void
umain(int argc, char **argv)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
  80011e:	83 ec 2c             	sub    $0x2c,%esp
	int f, i;

	binaryname = "num";
  800121:	c7 05 04 30 80 00 60 	movl   $0x802960,0x803004
  800128:	29 80 00 
	if (argc == 1)
  80012b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80012f:	74 0d                	je     80013e <umain+0x26>
  800131:	8b 45 0c             	mov    0xc(%ebp),%eax
  800134:	8d 58 04             	lea    0x4(%eax),%ebx
  800137:	bf 01 00 00 00       	mov    $0x1,%edi
  80013c:	eb 76                	jmp    8001b4 <umain+0x9c>
		num(0, "<stdin>");
  80013e:	c7 44 24 04 64 29 80 	movl   $0x802964,0x4(%esp)
  800145:	00 
  800146:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014d:	e8 e1 fe ff ff       	call   800033 <num>
  800152:	eb 65                	jmp    8001b9 <umain+0xa1>
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  800154:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800157:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80015e:	00 
  80015f:	8b 03                	mov    (%ebx),%eax
  800161:	89 04 24             	mov    %eax,(%esp)
  800164:	e8 86 17 00 00       	call   8018ef <open>
  800169:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80016b:	85 c0                	test   %eax,%eax
  80016d:	79 29                	jns    800198 <umain+0x80>
				panic("can't open %s: %e", argv[i], f);
  80016f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800176:	8b 00                	mov    (%eax),%eax
  800178:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80017c:	c7 44 24 08 6c 29 80 	movl   $0x80296c,0x8(%esp)
  800183:	00 
  800184:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  80018b:	00 
  80018c:	c7 04 24 40 29 80 00 	movl   $0x802940,(%esp)
  800193:	e8 8f 00 00 00       	call   800227 <_panic>
			else {
				num(f, argv[i]);
  800198:	8b 03                	mov    (%ebx),%eax
  80019a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019e:	89 34 24             	mov    %esi,(%esp)
  8001a1:	e8 8d fe ff ff       	call   800033 <num>
				close(f);
  8001a6:	89 34 24             	mov    %esi,(%esp)
  8001a9:	e8 a9 10 00 00       	call   801257 <close>

	binaryname = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8001ae:	83 c7 01             	add    $0x1,%edi
  8001b1:	83 c3 04             	add    $0x4,%ebx
  8001b4:	3b 7d 08             	cmp    0x8(%ebp),%edi
  8001b7:	7c 9b                	jl     800154 <umain+0x3c>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8001b9:	e8 50 00 00 00       	call   80020e <exit>
}
  8001be:	83 c4 2c             	add    $0x2c,%esp
  8001c1:	5b                   	pop    %ebx
  8001c2:	5e                   	pop    %esi
  8001c3:	5f                   	pop    %edi
  8001c4:	5d                   	pop    %ebp
  8001c5:	c3                   	ret    

008001c6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	56                   	push   %esi
  8001ca:	53                   	push   %ebx
  8001cb:	83 ec 10             	sub    $0x10,%esp
  8001ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001d4:	e8 4c 0b 00 00       	call   800d25 <sys_getenvid>
  8001d9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001de:	c1 e0 07             	shl    $0x7,%eax
  8001e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001e6:	a3 0c 40 80 00       	mov    %eax,0x80400c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001eb:	85 db                	test   %ebx,%ebx
  8001ed:	7e 07                	jle    8001f6 <libmain+0x30>
		binaryname = argv[0];
  8001ef:	8b 06                	mov    (%esi),%eax
  8001f1:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  8001f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001fa:	89 1c 24             	mov    %ebx,(%esp)
  8001fd:	e8 16 ff ff ff       	call   800118 <umain>

	// exit gracefully
	exit();
  800202:	e8 07 00 00 00       	call   80020e <exit>
}
  800207:	83 c4 10             	add    $0x10,%esp
  80020a:	5b                   	pop    %ebx
  80020b:	5e                   	pop    %esi
  80020c:	5d                   	pop    %ebp
  80020d:	c3                   	ret    

0080020e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80020e:	55                   	push   %ebp
  80020f:	89 e5                	mov    %esp,%ebp
  800211:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800214:	e8 71 10 00 00       	call   80128a <close_all>
	sys_env_destroy(0);
  800219:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800220:	e8 ae 0a 00 00       	call   800cd3 <sys_env_destroy>
}
  800225:	c9                   	leave  
  800226:	c3                   	ret    

00800227 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	56                   	push   %esi
  80022b:	53                   	push   %ebx
  80022c:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80022f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800232:	8b 35 04 30 80 00    	mov    0x803004,%esi
  800238:	e8 e8 0a 00 00       	call   800d25 <sys_getenvid>
  80023d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800240:	89 54 24 10          	mov    %edx,0x10(%esp)
  800244:	8b 55 08             	mov    0x8(%ebp),%edx
  800247:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80024b:	89 74 24 08          	mov    %esi,0x8(%esp)
  80024f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800253:	c7 04 24 88 29 80 00 	movl   $0x802988,(%esp)
  80025a:	e8 c1 00 00 00       	call   800320 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80025f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800263:	8b 45 10             	mov    0x10(%ebp),%eax
  800266:	89 04 24             	mov    %eax,(%esp)
  800269:	e8 51 00 00 00       	call   8002bf <vcprintf>
	cprintf("\n");
  80026e:	c7 04 24 ec 2d 80 00 	movl   $0x802dec,(%esp)
  800275:	e8 a6 00 00 00       	call   800320 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80027a:	cc                   	int3   
  80027b:	eb fd                	jmp    80027a <_panic+0x53>

0080027d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	53                   	push   %ebx
  800281:	83 ec 14             	sub    $0x14,%esp
  800284:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800287:	8b 13                	mov    (%ebx),%edx
  800289:	8d 42 01             	lea    0x1(%edx),%eax
  80028c:	89 03                	mov    %eax,(%ebx)
  80028e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800291:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800295:	3d ff 00 00 00       	cmp    $0xff,%eax
  80029a:	75 19                	jne    8002b5 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80029c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002a3:	00 
  8002a4:	8d 43 08             	lea    0x8(%ebx),%eax
  8002a7:	89 04 24             	mov    %eax,(%esp)
  8002aa:	e8 e7 09 00 00       	call   800c96 <sys_cputs>
		b->idx = 0;
  8002af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002b9:	83 c4 14             	add    $0x14,%esp
  8002bc:	5b                   	pop    %ebx
  8002bd:	5d                   	pop    %ebp
  8002be:	c3                   	ret    

008002bf <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002c8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002cf:	00 00 00 
	b.cnt = 0;
  8002d2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f4:	c7 04 24 7d 02 80 00 	movl   $0x80027d,(%esp)
  8002fb:	e8 ae 01 00 00       	call   8004ae <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800300:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800306:	89 44 24 04          	mov    %eax,0x4(%esp)
  80030a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800310:	89 04 24             	mov    %eax,(%esp)
  800313:	e8 7e 09 00 00       	call   800c96 <sys_cputs>

	return b.cnt;
}
  800318:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800326:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800329:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032d:	8b 45 08             	mov    0x8(%ebp),%eax
  800330:	89 04 24             	mov    %eax,(%esp)
  800333:	e8 87 ff ff ff       	call   8002bf <vcprintf>
	va_end(ap);

	return cnt;
}
  800338:	c9                   	leave  
  800339:	c3                   	ret    
  80033a:	66 90                	xchg   %ax,%ax
  80033c:	66 90                	xchg   %ax,%ax
  80033e:	66 90                	xchg   %ax,%ax

00800340 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	57                   	push   %edi
  800344:	56                   	push   %esi
  800345:	53                   	push   %ebx
  800346:	83 ec 3c             	sub    $0x3c,%esp
  800349:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80034c:	89 d7                	mov    %edx,%edi
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800354:	8b 45 0c             	mov    0xc(%ebp),%eax
  800357:	89 c3                	mov    %eax,%ebx
  800359:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800362:	b9 00 00 00 00       	mov    $0x0,%ecx
  800367:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80036d:	39 d9                	cmp    %ebx,%ecx
  80036f:	72 05                	jb     800376 <printnum+0x36>
  800371:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800374:	77 69                	ja     8003df <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800376:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800379:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80037d:	83 ee 01             	sub    $0x1,%esi
  800380:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800384:	89 44 24 08          	mov    %eax,0x8(%esp)
  800388:	8b 44 24 08          	mov    0x8(%esp),%eax
  80038c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800390:	89 c3                	mov    %eax,%ebx
  800392:	89 d6                	mov    %edx,%esi
  800394:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800397:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80039a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80039e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8003a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a5:	89 04 24             	mov    %eax,(%esp)
  8003a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003af:	e8 cc 22 00 00       	call   802680 <__udivdi3>
  8003b4:	89 d9                	mov    %ebx,%ecx
  8003b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003ba:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003be:	89 04 24             	mov    %eax,(%esp)
  8003c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003c5:	89 fa                	mov    %edi,%edx
  8003c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ca:	e8 71 ff ff ff       	call   800340 <printnum>
  8003cf:	eb 1b                	jmp    8003ec <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003d1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d8:	89 04 24             	mov    %eax,(%esp)
  8003db:	ff d3                	call   *%ebx
  8003dd:	eb 03                	jmp    8003e2 <printnum+0xa2>
  8003df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e2:	83 ee 01             	sub    $0x1,%esi
  8003e5:	85 f6                	test   %esi,%esi
  8003e7:	7f e8                	jg     8003d1 <printnum+0x91>
  8003e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003f0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800405:	89 04 24             	mov    %eax,(%esp)
  800408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80040b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040f:	e8 9c 23 00 00       	call   8027b0 <__umoddi3>
  800414:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800418:	0f be 80 ab 29 80 00 	movsbl 0x8029ab(%eax),%eax
  80041f:	89 04 24             	mov    %eax,(%esp)
  800422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800425:	ff d0                	call   *%eax
}
  800427:	83 c4 3c             	add    $0x3c,%esp
  80042a:	5b                   	pop    %ebx
  80042b:	5e                   	pop    %esi
  80042c:	5f                   	pop    %edi
  80042d:	5d                   	pop    %ebp
  80042e:	c3                   	ret    

0080042f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800432:	83 fa 01             	cmp    $0x1,%edx
  800435:	7e 0e                	jle    800445 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800437:	8b 10                	mov    (%eax),%edx
  800439:	8d 4a 08             	lea    0x8(%edx),%ecx
  80043c:	89 08                	mov    %ecx,(%eax)
  80043e:	8b 02                	mov    (%edx),%eax
  800440:	8b 52 04             	mov    0x4(%edx),%edx
  800443:	eb 22                	jmp    800467 <getuint+0x38>
	else if (lflag)
  800445:	85 d2                	test   %edx,%edx
  800447:	74 10                	je     800459 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800449:	8b 10                	mov    (%eax),%edx
  80044b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80044e:	89 08                	mov    %ecx,(%eax)
  800450:	8b 02                	mov    (%edx),%eax
  800452:	ba 00 00 00 00       	mov    $0x0,%edx
  800457:	eb 0e                	jmp    800467 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800459:	8b 10                	mov    (%eax),%edx
  80045b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80045e:	89 08                	mov    %ecx,(%eax)
  800460:	8b 02                	mov    (%edx),%eax
  800462:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800467:	5d                   	pop    %ebp
  800468:	c3                   	ret    

00800469 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800469:	55                   	push   %ebp
  80046a:	89 e5                	mov    %esp,%ebp
  80046c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80046f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800473:	8b 10                	mov    (%eax),%edx
  800475:	3b 50 04             	cmp    0x4(%eax),%edx
  800478:	73 0a                	jae    800484 <sprintputch+0x1b>
		*b->buf++ = ch;
  80047a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80047d:	89 08                	mov    %ecx,(%eax)
  80047f:	8b 45 08             	mov    0x8(%ebp),%eax
  800482:	88 02                	mov    %al,(%edx)
}
  800484:	5d                   	pop    %ebp
  800485:	c3                   	ret    

00800486 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80048c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80048f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800493:	8b 45 10             	mov    0x10(%ebp),%eax
  800496:	89 44 24 08          	mov    %eax,0x8(%esp)
  80049a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	89 04 24             	mov    %eax,(%esp)
  8004a7:	e8 02 00 00 00       	call   8004ae <vprintfmt>
	va_end(ap);
}
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	57                   	push   %edi
  8004b2:	56                   	push   %esi
  8004b3:	53                   	push   %ebx
  8004b4:	83 ec 3c             	sub    $0x3c,%esp
  8004b7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8004ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004bd:	eb 14                	jmp    8004d3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004bf:	85 c0                	test   %eax,%eax
  8004c1:	0f 84 b3 03 00 00    	je     80087a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8004c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004cb:	89 04 24             	mov    %eax,(%esp)
  8004ce:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d1:	89 f3                	mov    %esi,%ebx
  8004d3:	8d 73 01             	lea    0x1(%ebx),%esi
  8004d6:	0f b6 03             	movzbl (%ebx),%eax
  8004d9:	83 f8 25             	cmp    $0x25,%eax
  8004dc:	75 e1                	jne    8004bf <vprintfmt+0x11>
  8004de:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8004e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004e9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8004f0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8004f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fc:	eb 1d                	jmp    80051b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fe:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800500:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800504:	eb 15                	jmp    80051b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800506:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800508:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80050c:	eb 0d                	jmp    80051b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80050e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800511:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800514:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80051e:	0f b6 0e             	movzbl (%esi),%ecx
  800521:	0f b6 c1             	movzbl %cl,%eax
  800524:	83 e9 23             	sub    $0x23,%ecx
  800527:	80 f9 55             	cmp    $0x55,%cl
  80052a:	0f 87 2a 03 00 00    	ja     80085a <vprintfmt+0x3ac>
  800530:	0f b6 c9             	movzbl %cl,%ecx
  800533:	ff 24 8d e0 2a 80 00 	jmp    *0x802ae0(,%ecx,4)
  80053a:	89 de                	mov    %ebx,%esi
  80053c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800541:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800544:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800548:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80054b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80054e:	83 fb 09             	cmp    $0x9,%ebx
  800551:	77 36                	ja     800589 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800553:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800556:	eb e9                	jmp    800541 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800558:	8b 45 14             	mov    0x14(%ebp),%eax
  80055b:	8d 48 04             	lea    0x4(%eax),%ecx
  80055e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800561:	8b 00                	mov    (%eax),%eax
  800563:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800566:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800568:	eb 22                	jmp    80058c <vprintfmt+0xde>
  80056a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80056d:	85 c9                	test   %ecx,%ecx
  80056f:	b8 00 00 00 00       	mov    $0x0,%eax
  800574:	0f 49 c1             	cmovns %ecx,%eax
  800577:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057a:	89 de                	mov    %ebx,%esi
  80057c:	eb 9d                	jmp    80051b <vprintfmt+0x6d>
  80057e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800580:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800587:	eb 92                	jmp    80051b <vprintfmt+0x6d>
  800589:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80058c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800590:	79 89                	jns    80051b <vprintfmt+0x6d>
  800592:	e9 77 ff ff ff       	jmp    80050e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800597:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80059c:	e9 7a ff ff ff       	jmp    80051b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8d 50 04             	lea    0x4(%eax),%edx
  8005a7:	89 55 14             	mov    %edx,0x14(%ebp)
  8005aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	89 04 24             	mov    %eax,(%esp)
  8005b3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005b6:	e9 18 ff ff ff       	jmp    8004d3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8d 50 04             	lea    0x4(%eax),%edx
  8005c1:	89 55 14             	mov    %edx,0x14(%ebp)
  8005c4:	8b 00                	mov    (%eax),%eax
  8005c6:	99                   	cltd   
  8005c7:	31 d0                	xor    %edx,%eax
  8005c9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005cb:	83 f8 11             	cmp    $0x11,%eax
  8005ce:	7f 0b                	jg     8005db <vprintfmt+0x12d>
  8005d0:	8b 14 85 40 2c 80 00 	mov    0x802c40(,%eax,4),%edx
  8005d7:	85 d2                	test   %edx,%edx
  8005d9:	75 20                	jne    8005fb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8005db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005df:	c7 44 24 08 c3 29 80 	movl   $0x8029c3,0x8(%esp)
  8005e6:	00 
  8005e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	89 04 24             	mov    %eax,(%esp)
  8005f1:	e8 90 fe ff ff       	call   800486 <printfmt>
  8005f6:	e9 d8 fe ff ff       	jmp    8004d3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8005fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005ff:	c7 44 24 08 81 2d 80 	movl   $0x802d81,0x8(%esp)
  800606:	00 
  800607:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80060b:	8b 45 08             	mov    0x8(%ebp),%eax
  80060e:	89 04 24             	mov    %eax,(%esp)
  800611:	e8 70 fe ff ff       	call   800486 <printfmt>
  800616:	e9 b8 fe ff ff       	jmp    8004d3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80061b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80061e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800621:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	8d 50 04             	lea    0x4(%eax),%edx
  80062a:	89 55 14             	mov    %edx,0x14(%ebp)
  80062d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80062f:	85 f6                	test   %esi,%esi
  800631:	b8 bc 29 80 00       	mov    $0x8029bc,%eax
  800636:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800639:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80063d:	0f 84 97 00 00 00    	je     8006da <vprintfmt+0x22c>
  800643:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800647:	0f 8e 9b 00 00 00    	jle    8006e8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80064d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800651:	89 34 24             	mov    %esi,(%esp)
  800654:	e8 cf 02 00 00       	call   800928 <strnlen>
  800659:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80065c:	29 c2                	sub    %eax,%edx
  80065e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800661:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800665:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800668:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80066b:	8b 75 08             	mov    0x8(%ebp),%esi
  80066e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800671:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800673:	eb 0f                	jmp    800684 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800675:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800679:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80067c:	89 04 24             	mov    %eax,(%esp)
  80067f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800681:	83 eb 01             	sub    $0x1,%ebx
  800684:	85 db                	test   %ebx,%ebx
  800686:	7f ed                	jg     800675 <vprintfmt+0x1c7>
  800688:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80068b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80068e:	85 d2                	test   %edx,%edx
  800690:	b8 00 00 00 00       	mov    $0x0,%eax
  800695:	0f 49 c2             	cmovns %edx,%eax
  800698:	29 c2                	sub    %eax,%edx
  80069a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80069d:	89 d7                	mov    %edx,%edi
  80069f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006a2:	eb 50                	jmp    8006f4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006a8:	74 1e                	je     8006c8 <vprintfmt+0x21a>
  8006aa:	0f be d2             	movsbl %dl,%edx
  8006ad:	83 ea 20             	sub    $0x20,%edx
  8006b0:	83 fa 5e             	cmp    $0x5e,%edx
  8006b3:	76 13                	jbe    8006c8 <vprintfmt+0x21a>
					putch('?', putdat);
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006bc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006c3:	ff 55 08             	call   *0x8(%ebp)
  8006c6:	eb 0d                	jmp    8006d5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8006c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006cf:	89 04 24             	mov    %eax,(%esp)
  8006d2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006d5:	83 ef 01             	sub    $0x1,%edi
  8006d8:	eb 1a                	jmp    8006f4 <vprintfmt+0x246>
  8006da:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006dd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006e0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006e3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006e6:	eb 0c                	jmp    8006f4 <vprintfmt+0x246>
  8006e8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006eb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006f1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006f4:	83 c6 01             	add    $0x1,%esi
  8006f7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8006fb:	0f be c2             	movsbl %dl,%eax
  8006fe:	85 c0                	test   %eax,%eax
  800700:	74 27                	je     800729 <vprintfmt+0x27b>
  800702:	85 db                	test   %ebx,%ebx
  800704:	78 9e                	js     8006a4 <vprintfmt+0x1f6>
  800706:	83 eb 01             	sub    $0x1,%ebx
  800709:	79 99                	jns    8006a4 <vprintfmt+0x1f6>
  80070b:	89 f8                	mov    %edi,%eax
  80070d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800710:	8b 75 08             	mov    0x8(%ebp),%esi
  800713:	89 c3                	mov    %eax,%ebx
  800715:	eb 1a                	jmp    800731 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800717:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80071b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800722:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800724:	83 eb 01             	sub    $0x1,%ebx
  800727:	eb 08                	jmp    800731 <vprintfmt+0x283>
  800729:	89 fb                	mov    %edi,%ebx
  80072b:	8b 75 08             	mov    0x8(%ebp),%esi
  80072e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800731:	85 db                	test   %ebx,%ebx
  800733:	7f e2                	jg     800717 <vprintfmt+0x269>
  800735:	89 75 08             	mov    %esi,0x8(%ebp)
  800738:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80073b:	e9 93 fd ff ff       	jmp    8004d3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800740:	83 fa 01             	cmp    $0x1,%edx
  800743:	7e 16                	jle    80075b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800745:	8b 45 14             	mov    0x14(%ebp),%eax
  800748:	8d 50 08             	lea    0x8(%eax),%edx
  80074b:	89 55 14             	mov    %edx,0x14(%ebp)
  80074e:	8b 50 04             	mov    0x4(%eax),%edx
  800751:	8b 00                	mov    (%eax),%eax
  800753:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800756:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800759:	eb 32                	jmp    80078d <vprintfmt+0x2df>
	else if (lflag)
  80075b:	85 d2                	test   %edx,%edx
  80075d:	74 18                	je     800777 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80075f:	8b 45 14             	mov    0x14(%ebp),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	89 55 14             	mov    %edx,0x14(%ebp)
  800768:	8b 30                	mov    (%eax),%esi
  80076a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80076d:	89 f0                	mov    %esi,%eax
  80076f:	c1 f8 1f             	sar    $0x1f,%eax
  800772:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800775:	eb 16                	jmp    80078d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8d 50 04             	lea    0x4(%eax),%edx
  80077d:	89 55 14             	mov    %edx,0x14(%ebp)
  800780:	8b 30                	mov    (%eax),%esi
  800782:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800785:	89 f0                	mov    %esi,%eax
  800787:	c1 f8 1f             	sar    $0x1f,%eax
  80078a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80078d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800790:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800793:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800798:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80079c:	0f 89 80 00 00 00    	jns    800822 <vprintfmt+0x374>
				putch('-', putdat);
  8007a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007ad:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007b6:	f7 d8                	neg    %eax
  8007b8:	83 d2 00             	adc    $0x0,%edx
  8007bb:	f7 da                	neg    %edx
			}
			base = 10;
  8007bd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007c2:	eb 5e                	jmp    800822 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007c4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007c7:	e8 63 fc ff ff       	call   80042f <getuint>
			base = 10;
  8007cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8007d1:	eb 4f                	jmp    800822 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8007d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d6:	e8 54 fc ff ff       	call   80042f <getuint>
			base = 8;
  8007db:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007e0:	eb 40                	jmp    800822 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  8007e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007ed:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007f4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007fb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	8d 50 04             	lea    0x4(%eax),%edx
  800804:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800807:	8b 00                	mov    (%eax),%eax
  800809:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80080e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800813:	eb 0d                	jmp    800822 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800815:	8d 45 14             	lea    0x14(%ebp),%eax
  800818:	e8 12 fc ff ff       	call   80042f <getuint>
			base = 16;
  80081d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800822:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800826:	89 74 24 10          	mov    %esi,0x10(%esp)
  80082a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80082d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800831:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800835:	89 04 24             	mov    %eax,(%esp)
  800838:	89 54 24 04          	mov    %edx,0x4(%esp)
  80083c:	89 fa                	mov    %edi,%edx
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	e8 fa fa ff ff       	call   800340 <printnum>
			break;
  800846:	e9 88 fc ff ff       	jmp    8004d3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80084b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80084f:	89 04 24             	mov    %eax,(%esp)
  800852:	ff 55 08             	call   *0x8(%ebp)
			break;
  800855:	e9 79 fc ff ff       	jmp    8004d3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80085a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80085e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800865:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800868:	89 f3                	mov    %esi,%ebx
  80086a:	eb 03                	jmp    80086f <vprintfmt+0x3c1>
  80086c:	83 eb 01             	sub    $0x1,%ebx
  80086f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800873:	75 f7                	jne    80086c <vprintfmt+0x3be>
  800875:	e9 59 fc ff ff       	jmp    8004d3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80087a:	83 c4 3c             	add    $0x3c,%esp
  80087d:	5b                   	pop    %ebx
  80087e:	5e                   	pop    %esi
  80087f:	5f                   	pop    %edi
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	83 ec 28             	sub    $0x28,%esp
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800891:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800895:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800898:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80089f:	85 c0                	test   %eax,%eax
  8008a1:	74 30                	je     8008d3 <vsnprintf+0x51>
  8008a3:	85 d2                	test   %edx,%edx
  8008a5:	7e 2c                	jle    8008d3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008bc:	c7 04 24 69 04 80 00 	movl   $0x800469,(%esp)
  8008c3:	e8 e6 fb ff ff       	call   8004ae <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008cb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d1:	eb 05                	jmp    8008d8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8008d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8008d8:	c9                   	leave  
  8008d9:	c3                   	ret    

008008da <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	89 04 24             	mov    %eax,(%esp)
  8008fb:	e8 82 ff ff ff       	call   800882 <vsnprintf>
	va_end(ap);

	return rc;
}
  800900:	c9                   	leave  
  800901:	c3                   	ret    
  800902:	66 90                	xchg   %ax,%ax
  800904:	66 90                	xchg   %ax,%ax
  800906:	66 90                	xchg   %ax,%ax
  800908:	66 90                	xchg   %ax,%ax
  80090a:	66 90                	xchg   %ax,%ax
  80090c:	66 90                	xchg   %ax,%ax
  80090e:	66 90                	xchg   %ax,%ax

00800910 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
  80091b:	eb 03                	jmp    800920 <strlen+0x10>
		n++;
  80091d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800920:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800924:	75 f7                	jne    80091d <strlen+0xd>
		n++;
	return n;
}
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800931:	b8 00 00 00 00       	mov    $0x0,%eax
  800936:	eb 03                	jmp    80093b <strnlen+0x13>
		n++;
  800938:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093b:	39 d0                	cmp    %edx,%eax
  80093d:	74 06                	je     800945 <strnlen+0x1d>
  80093f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800943:	75 f3                	jne    800938 <strnlen+0x10>
		n++;
	return n;
}
  800945:	5d                   	pop    %ebp
  800946:	c3                   	ret    

00800947 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800947:	55                   	push   %ebp
  800948:	89 e5                	mov    %esp,%ebp
  80094a:	53                   	push   %ebx
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800951:	89 c2                	mov    %eax,%edx
  800953:	83 c2 01             	add    $0x1,%edx
  800956:	83 c1 01             	add    $0x1,%ecx
  800959:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80095d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800960:	84 db                	test   %bl,%bl
  800962:	75 ef                	jne    800953 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800964:	5b                   	pop    %ebx
  800965:	5d                   	pop    %ebp
  800966:	c3                   	ret    

00800967 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	53                   	push   %ebx
  80096b:	83 ec 08             	sub    $0x8,%esp
  80096e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800971:	89 1c 24             	mov    %ebx,(%esp)
  800974:	e8 97 ff ff ff       	call   800910 <strlen>
	strcpy(dst + len, src);
  800979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800980:	01 d8                	add    %ebx,%eax
  800982:	89 04 24             	mov    %eax,(%esp)
  800985:	e8 bd ff ff ff       	call   800947 <strcpy>
	return dst;
}
  80098a:	89 d8                	mov    %ebx,%eax
  80098c:	83 c4 08             	add    $0x8,%esp
  80098f:	5b                   	pop    %ebx
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	56                   	push   %esi
  800996:	53                   	push   %ebx
  800997:	8b 75 08             	mov    0x8(%ebp),%esi
  80099a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80099d:	89 f3                	mov    %esi,%ebx
  80099f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a2:	89 f2                	mov    %esi,%edx
  8009a4:	eb 0f                	jmp    8009b5 <strncpy+0x23>
		*dst++ = *src;
  8009a6:	83 c2 01             	add    $0x1,%edx
  8009a9:	0f b6 01             	movzbl (%ecx),%eax
  8009ac:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009af:	80 39 01             	cmpb   $0x1,(%ecx)
  8009b2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b5:	39 da                	cmp    %ebx,%edx
  8009b7:	75 ed                	jne    8009a6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009b9:	89 f0                	mov    %esi,%eax
  8009bb:	5b                   	pop    %ebx
  8009bc:	5e                   	pop    %esi
  8009bd:	5d                   	pop    %ebp
  8009be:	c3                   	ret    

008009bf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	56                   	push   %esi
  8009c3:	53                   	push   %ebx
  8009c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009cd:	89 f0                	mov    %esi,%eax
  8009cf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d3:	85 c9                	test   %ecx,%ecx
  8009d5:	75 0b                	jne    8009e2 <strlcpy+0x23>
  8009d7:	eb 1d                	jmp    8009f6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009d9:	83 c0 01             	add    $0x1,%eax
  8009dc:	83 c2 01             	add    $0x1,%edx
  8009df:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009e2:	39 d8                	cmp    %ebx,%eax
  8009e4:	74 0b                	je     8009f1 <strlcpy+0x32>
  8009e6:	0f b6 0a             	movzbl (%edx),%ecx
  8009e9:	84 c9                	test   %cl,%cl
  8009eb:	75 ec                	jne    8009d9 <strlcpy+0x1a>
  8009ed:	89 c2                	mov    %eax,%edx
  8009ef:	eb 02                	jmp    8009f3 <strlcpy+0x34>
  8009f1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8009f3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8009f6:	29 f0                	sub    %esi,%eax
}
  8009f8:	5b                   	pop    %ebx
  8009f9:	5e                   	pop    %esi
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a02:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a05:	eb 06                	jmp    800a0d <strcmp+0x11>
		p++, q++;
  800a07:	83 c1 01             	add    $0x1,%ecx
  800a0a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a0d:	0f b6 01             	movzbl (%ecx),%eax
  800a10:	84 c0                	test   %al,%al
  800a12:	74 04                	je     800a18 <strcmp+0x1c>
  800a14:	3a 02                	cmp    (%edx),%al
  800a16:	74 ef                	je     800a07 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a18:	0f b6 c0             	movzbl %al,%eax
  800a1b:	0f b6 12             	movzbl (%edx),%edx
  800a1e:	29 d0                	sub    %edx,%eax
}
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    

00800a22 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	53                   	push   %ebx
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2c:	89 c3                	mov    %eax,%ebx
  800a2e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a31:	eb 06                	jmp    800a39 <strncmp+0x17>
		n--, p++, q++;
  800a33:	83 c0 01             	add    $0x1,%eax
  800a36:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a39:	39 d8                	cmp    %ebx,%eax
  800a3b:	74 15                	je     800a52 <strncmp+0x30>
  800a3d:	0f b6 08             	movzbl (%eax),%ecx
  800a40:	84 c9                	test   %cl,%cl
  800a42:	74 04                	je     800a48 <strncmp+0x26>
  800a44:	3a 0a                	cmp    (%edx),%cl
  800a46:	74 eb                	je     800a33 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a48:	0f b6 00             	movzbl (%eax),%eax
  800a4b:	0f b6 12             	movzbl (%edx),%edx
  800a4e:	29 d0                	sub    %edx,%eax
  800a50:	eb 05                	jmp    800a57 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a52:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a57:	5b                   	pop    %ebx
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a60:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a64:	eb 07                	jmp    800a6d <strchr+0x13>
		if (*s == c)
  800a66:	38 ca                	cmp    %cl,%dl
  800a68:	74 0f                	je     800a79 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a6a:	83 c0 01             	add    $0x1,%eax
  800a6d:	0f b6 10             	movzbl (%eax),%edx
  800a70:	84 d2                	test   %dl,%dl
  800a72:	75 f2                	jne    800a66 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a85:	eb 07                	jmp    800a8e <strfind+0x13>
		if (*s == c)
  800a87:	38 ca                	cmp    %cl,%dl
  800a89:	74 0a                	je     800a95 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a8b:	83 c0 01             	add    $0x1,%eax
  800a8e:	0f b6 10             	movzbl (%eax),%edx
  800a91:	84 d2                	test   %dl,%dl
  800a93:	75 f2                	jne    800a87 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	57                   	push   %edi
  800a9b:	56                   	push   %esi
  800a9c:	53                   	push   %ebx
  800a9d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa3:	85 c9                	test   %ecx,%ecx
  800aa5:	74 36                	je     800add <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aad:	75 28                	jne    800ad7 <memset+0x40>
  800aaf:	f6 c1 03             	test   $0x3,%cl
  800ab2:	75 23                	jne    800ad7 <memset+0x40>
		c &= 0xFF;
  800ab4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab8:	89 d3                	mov    %edx,%ebx
  800aba:	c1 e3 08             	shl    $0x8,%ebx
  800abd:	89 d6                	mov    %edx,%esi
  800abf:	c1 e6 18             	shl    $0x18,%esi
  800ac2:	89 d0                	mov    %edx,%eax
  800ac4:	c1 e0 10             	shl    $0x10,%eax
  800ac7:	09 f0                	or     %esi,%eax
  800ac9:	09 c2                	or     %eax,%edx
  800acb:	89 d0                	mov    %edx,%eax
  800acd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800acf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800ad2:	fc                   	cld    
  800ad3:	f3 ab                	rep stos %eax,%es:(%edi)
  800ad5:	eb 06                	jmp    800add <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ada:	fc                   	cld    
  800adb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800add:	89 f8                	mov    %edi,%eax
  800adf:	5b                   	pop    %ebx
  800ae0:	5e                   	pop    %esi
  800ae1:	5f                   	pop    %edi
  800ae2:	5d                   	pop    %ebp
  800ae3:	c3                   	ret    

00800ae4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ae4:	55                   	push   %ebp
  800ae5:	89 e5                	mov    %esp,%ebp
  800ae7:	57                   	push   %edi
  800ae8:	56                   	push   %esi
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aef:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af2:	39 c6                	cmp    %eax,%esi
  800af4:	73 35                	jae    800b2b <memmove+0x47>
  800af6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af9:	39 d0                	cmp    %edx,%eax
  800afb:	73 2e                	jae    800b2b <memmove+0x47>
		s += n;
		d += n;
  800afd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b00:	89 d6                	mov    %edx,%esi
  800b02:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b04:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b0a:	75 13                	jne    800b1f <memmove+0x3b>
  800b0c:	f6 c1 03             	test   $0x3,%cl
  800b0f:	75 0e                	jne    800b1f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b11:	83 ef 04             	sub    $0x4,%edi
  800b14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b17:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b1a:	fd                   	std    
  800b1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1d:	eb 09                	jmp    800b28 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b1f:	83 ef 01             	sub    $0x1,%edi
  800b22:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b25:	fd                   	std    
  800b26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b28:	fc                   	cld    
  800b29:	eb 1d                	jmp    800b48 <memmove+0x64>
  800b2b:	89 f2                	mov    %esi,%edx
  800b2d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2f:	f6 c2 03             	test   $0x3,%dl
  800b32:	75 0f                	jne    800b43 <memmove+0x5f>
  800b34:	f6 c1 03             	test   $0x3,%cl
  800b37:	75 0a                	jne    800b43 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b39:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b3c:	89 c7                	mov    %eax,%edi
  800b3e:	fc                   	cld    
  800b3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b41:	eb 05                	jmp    800b48 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b43:	89 c7                	mov    %eax,%edi
  800b45:	fc                   	cld    
  800b46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b48:	5e                   	pop    %esi
  800b49:	5f                   	pop    %edi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b52:	8b 45 10             	mov    0x10(%ebp),%eax
  800b55:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	89 04 24             	mov    %eax,(%esp)
  800b66:	e8 79 ff ff ff       	call   800ae4 <memmove>
}
  800b6b:	c9                   	leave  
  800b6c:	c3                   	ret    

00800b6d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b6d:	55                   	push   %ebp
  800b6e:	89 e5                	mov    %esp,%ebp
  800b70:	56                   	push   %esi
  800b71:	53                   	push   %ebx
  800b72:	8b 55 08             	mov    0x8(%ebp),%edx
  800b75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b78:	89 d6                	mov    %edx,%esi
  800b7a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b7d:	eb 1a                	jmp    800b99 <memcmp+0x2c>
		if (*s1 != *s2)
  800b7f:	0f b6 02             	movzbl (%edx),%eax
  800b82:	0f b6 19             	movzbl (%ecx),%ebx
  800b85:	38 d8                	cmp    %bl,%al
  800b87:	74 0a                	je     800b93 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b89:	0f b6 c0             	movzbl %al,%eax
  800b8c:	0f b6 db             	movzbl %bl,%ebx
  800b8f:	29 d8                	sub    %ebx,%eax
  800b91:	eb 0f                	jmp    800ba2 <memcmp+0x35>
		s1++, s2++;
  800b93:	83 c2 01             	add    $0x1,%edx
  800b96:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b99:	39 f2                	cmp    %esi,%edx
  800b9b:	75 e2                	jne    800b7f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ba2:	5b                   	pop    %ebx
  800ba3:	5e                   	pop    %esi
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800baf:	89 c2                	mov    %eax,%edx
  800bb1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bb4:	eb 07                	jmp    800bbd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bb6:	38 08                	cmp    %cl,(%eax)
  800bb8:	74 07                	je     800bc1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bba:	83 c0 01             	add    $0x1,%eax
  800bbd:	39 d0                	cmp    %edx,%eax
  800bbf:	72 f5                	jb     800bb6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bc1:	5d                   	pop    %ebp
  800bc2:	c3                   	ret    

00800bc3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	57                   	push   %edi
  800bc7:	56                   	push   %esi
  800bc8:	53                   	push   %ebx
  800bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bcf:	eb 03                	jmp    800bd4 <strtol+0x11>
		s++;
  800bd1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd4:	0f b6 0a             	movzbl (%edx),%ecx
  800bd7:	80 f9 09             	cmp    $0x9,%cl
  800bda:	74 f5                	je     800bd1 <strtol+0xe>
  800bdc:	80 f9 20             	cmp    $0x20,%cl
  800bdf:	74 f0                	je     800bd1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800be1:	80 f9 2b             	cmp    $0x2b,%cl
  800be4:	75 0a                	jne    800bf0 <strtol+0x2d>
		s++;
  800be6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800be9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bee:	eb 11                	jmp    800c01 <strtol+0x3e>
  800bf0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bf5:	80 f9 2d             	cmp    $0x2d,%cl
  800bf8:	75 07                	jne    800c01 <strtol+0x3e>
		s++, neg = 1;
  800bfa:	8d 52 01             	lea    0x1(%edx),%edx
  800bfd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c01:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c06:	75 15                	jne    800c1d <strtol+0x5a>
  800c08:	80 3a 30             	cmpb   $0x30,(%edx)
  800c0b:	75 10                	jne    800c1d <strtol+0x5a>
  800c0d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c11:	75 0a                	jne    800c1d <strtol+0x5a>
		s += 2, base = 16;
  800c13:	83 c2 02             	add    $0x2,%edx
  800c16:	b8 10 00 00 00       	mov    $0x10,%eax
  800c1b:	eb 10                	jmp    800c2d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c1d:	85 c0                	test   %eax,%eax
  800c1f:	75 0c                	jne    800c2d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c21:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c23:	80 3a 30             	cmpb   $0x30,(%edx)
  800c26:	75 05                	jne    800c2d <strtol+0x6a>
		s++, base = 8;
  800c28:	83 c2 01             	add    $0x1,%edx
  800c2b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c32:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c35:	0f b6 0a             	movzbl (%edx),%ecx
  800c38:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c3b:	89 f0                	mov    %esi,%eax
  800c3d:	3c 09                	cmp    $0x9,%al
  800c3f:	77 08                	ja     800c49 <strtol+0x86>
			dig = *s - '0';
  800c41:	0f be c9             	movsbl %cl,%ecx
  800c44:	83 e9 30             	sub    $0x30,%ecx
  800c47:	eb 20                	jmp    800c69 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c49:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c4c:	89 f0                	mov    %esi,%eax
  800c4e:	3c 19                	cmp    $0x19,%al
  800c50:	77 08                	ja     800c5a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c52:	0f be c9             	movsbl %cl,%ecx
  800c55:	83 e9 57             	sub    $0x57,%ecx
  800c58:	eb 0f                	jmp    800c69 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c5a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c5d:	89 f0                	mov    %esi,%eax
  800c5f:	3c 19                	cmp    $0x19,%al
  800c61:	77 16                	ja     800c79 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c63:	0f be c9             	movsbl %cl,%ecx
  800c66:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c69:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c6c:	7d 0f                	jge    800c7d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c6e:	83 c2 01             	add    $0x1,%edx
  800c71:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c75:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c77:	eb bc                	jmp    800c35 <strtol+0x72>
  800c79:	89 d8                	mov    %ebx,%eax
  800c7b:	eb 02                	jmp    800c7f <strtol+0xbc>
  800c7d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c83:	74 05                	je     800c8a <strtol+0xc7>
		*endptr = (char *) s;
  800c85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c88:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c8a:	f7 d8                	neg    %eax
  800c8c:	85 ff                	test   %edi,%edi
  800c8e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c91:	5b                   	pop    %ebx
  800c92:	5e                   	pop    %esi
  800c93:	5f                   	pop    %edi
  800c94:	5d                   	pop    %ebp
  800c95:	c3                   	ret    

00800c96 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	57                   	push   %edi
  800c9a:	56                   	push   %esi
  800c9b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca7:	89 c3                	mov    %eax,%ebx
  800ca9:	89 c7                	mov    %eax,%edi
  800cab:	89 c6                	mov    %eax,%esi
  800cad:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800caf:	5b                   	pop    %ebx
  800cb0:	5e                   	pop    %esi
  800cb1:	5f                   	pop    %edi
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cba:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbf:	b8 01 00 00 00       	mov    $0x1,%eax
  800cc4:	89 d1                	mov    %edx,%ecx
  800cc6:	89 d3                	mov    %edx,%ebx
  800cc8:	89 d7                	mov    %edx,%edi
  800cca:	89 d6                	mov    %edx,%esi
  800ccc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cce:	5b                   	pop    %ebx
  800ccf:	5e                   	pop    %esi
  800cd0:	5f                   	pop    %edi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
  800cd9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cdc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ce1:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce9:	89 cb                	mov    %ecx,%ebx
  800ceb:	89 cf                	mov    %ecx,%edi
  800ced:	89 ce                	mov    %ecx,%esi
  800cef:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cf1:	85 c0                	test   %eax,%eax
  800cf3:	7e 28                	jle    800d1d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cf9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d00:	00 
  800d01:	c7 44 24 08 a7 2c 80 	movl   $0x802ca7,0x8(%esp)
  800d08:	00 
  800d09:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d10:	00 
  800d11:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  800d18:	e8 0a f5 ff ff       	call   800227 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d1d:	83 c4 2c             	add    $0x2c,%esp
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5f                   	pop    %edi
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    

00800d25 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	57                   	push   %edi
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d30:	b8 02 00 00 00       	mov    $0x2,%eax
  800d35:	89 d1                	mov    %edx,%ecx
  800d37:	89 d3                	mov    %edx,%ebx
  800d39:	89 d7                	mov    %edx,%edi
  800d3b:	89 d6                	mov    %edx,%esi
  800d3d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    

00800d44 <sys_yield>:

void
sys_yield(void)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d4f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d54:	89 d1                	mov    %edx,%ecx
  800d56:	89 d3                	mov    %edx,%ebx
  800d58:	89 d7                	mov    %edx,%edi
  800d5a:	89 d6                	mov    %edx,%esi
  800d5c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d5e:	5b                   	pop    %ebx
  800d5f:	5e                   	pop    %esi
  800d60:	5f                   	pop    %edi
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	57                   	push   %edi
  800d67:	56                   	push   %esi
  800d68:	53                   	push   %ebx
  800d69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d6c:	be 00 00 00 00       	mov    $0x0,%esi
  800d71:	b8 04 00 00 00       	mov    $0x4,%eax
  800d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d79:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7f:	89 f7                	mov    %esi,%edi
  800d81:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d83:	85 c0                	test   %eax,%eax
  800d85:	7e 28                	jle    800daf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d87:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d8b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d92:	00 
  800d93:	c7 44 24 08 a7 2c 80 	movl   $0x802ca7,0x8(%esp)
  800d9a:	00 
  800d9b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800da2:	00 
  800da3:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  800daa:	e8 78 f4 ff ff       	call   800227 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800daf:	83 c4 2c             	add    $0x2c,%esp
  800db2:	5b                   	pop    %ebx
  800db3:	5e                   	pop    %esi
  800db4:	5f                   	pop    %edi
  800db5:	5d                   	pop    %ebp
  800db6:	c3                   	ret    

00800db7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	57                   	push   %edi
  800dbb:	56                   	push   %esi
  800dbc:	53                   	push   %ebx
  800dbd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc0:	b8 05 00 00 00       	mov    $0x5,%eax
  800dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dce:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dd1:	8b 75 18             	mov    0x18(%ebp),%esi
  800dd4:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800dd6:	85 c0                	test   %eax,%eax
  800dd8:	7e 28                	jle    800e02 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dda:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dde:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800de5:	00 
  800de6:	c7 44 24 08 a7 2c 80 	movl   $0x802ca7,0x8(%esp)
  800ded:	00 
  800dee:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df5:	00 
  800df6:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  800dfd:	e8 25 f4 ff ff       	call   800227 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e02:	83 c4 2c             	add    $0x2c,%esp
  800e05:	5b                   	pop    %ebx
  800e06:	5e                   	pop    %esi
  800e07:	5f                   	pop    %edi
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	57                   	push   %edi
  800e0e:	56                   	push   %esi
  800e0f:	53                   	push   %ebx
  800e10:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e18:	b8 06 00 00 00       	mov    $0x6,%eax
  800e1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e20:	8b 55 08             	mov    0x8(%ebp),%edx
  800e23:	89 df                	mov    %ebx,%edi
  800e25:	89 de                	mov    %ebx,%esi
  800e27:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	7e 28                	jle    800e55 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e31:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e38:	00 
  800e39:	c7 44 24 08 a7 2c 80 	movl   $0x802ca7,0x8(%esp)
  800e40:	00 
  800e41:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e48:	00 
  800e49:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  800e50:	e8 d2 f3 ff ff       	call   800227 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e55:	83 c4 2c             	add    $0x2c,%esp
  800e58:	5b                   	pop    %ebx
  800e59:	5e                   	pop    %esi
  800e5a:	5f                   	pop    %edi
  800e5b:	5d                   	pop    %ebp
  800e5c:	c3                   	ret    

00800e5d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	57                   	push   %edi
  800e61:	56                   	push   %esi
  800e62:	53                   	push   %ebx
  800e63:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e73:	8b 55 08             	mov    0x8(%ebp),%edx
  800e76:	89 df                	mov    %ebx,%edi
  800e78:	89 de                	mov    %ebx,%esi
  800e7a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e7c:	85 c0                	test   %eax,%eax
  800e7e:	7e 28                	jle    800ea8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e80:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e84:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e8b:	00 
  800e8c:	c7 44 24 08 a7 2c 80 	movl   $0x802ca7,0x8(%esp)
  800e93:	00 
  800e94:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e9b:	00 
  800e9c:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  800ea3:	e8 7f f3 ff ff       	call   800227 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ea8:	83 c4 2c             	add    $0x2c,%esp
  800eab:	5b                   	pop    %ebx
  800eac:	5e                   	pop    %esi
  800ead:	5f                   	pop    %edi
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    

00800eb0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	57                   	push   %edi
  800eb4:	56                   	push   %esi
  800eb5:	53                   	push   %ebx
  800eb6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebe:	b8 09 00 00 00       	mov    $0x9,%eax
  800ec3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec9:	89 df                	mov    %ebx,%edi
  800ecb:	89 de                	mov    %ebx,%esi
  800ecd:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ecf:	85 c0                	test   %eax,%eax
  800ed1:	7e 28                	jle    800efb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ed7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ede:	00 
  800edf:	c7 44 24 08 a7 2c 80 	movl   $0x802ca7,0x8(%esp)
  800ee6:	00 
  800ee7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eee:	00 
  800eef:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  800ef6:	e8 2c f3 ff ff       	call   800227 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800efb:	83 c4 2c             	add    $0x2c,%esp
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	57                   	push   %edi
  800f07:	56                   	push   %esi
  800f08:	53                   	push   %ebx
  800f09:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f11:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f19:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1c:	89 df                	mov    %ebx,%edi
  800f1e:	89 de                	mov    %ebx,%esi
  800f20:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f22:	85 c0                	test   %eax,%eax
  800f24:	7e 28                	jle    800f4e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f26:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f31:	00 
  800f32:	c7 44 24 08 a7 2c 80 	movl   $0x802ca7,0x8(%esp)
  800f39:	00 
  800f3a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f41:	00 
  800f42:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  800f49:	e8 d9 f2 ff ff       	call   800227 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f4e:	83 c4 2c             	add    $0x2c,%esp
  800f51:	5b                   	pop    %ebx
  800f52:	5e                   	pop    %esi
  800f53:	5f                   	pop    %edi
  800f54:	5d                   	pop    %ebp
  800f55:	c3                   	ret    

00800f56 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f56:	55                   	push   %ebp
  800f57:	89 e5                	mov    %esp,%ebp
  800f59:	57                   	push   %edi
  800f5a:	56                   	push   %esi
  800f5b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5c:	be 00 00 00 00       	mov    $0x0,%esi
  800f61:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f69:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f72:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	57                   	push   %edi
  800f7d:	56                   	push   %esi
  800f7e:	53                   	push   %ebx
  800f7f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f87:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8f:	89 cb                	mov    %ecx,%ebx
  800f91:	89 cf                	mov    %ecx,%edi
  800f93:	89 ce                	mov    %ecx,%esi
  800f95:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f97:	85 c0                	test   %eax,%eax
  800f99:	7e 28                	jle    800fc3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f9f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fa6:	00 
  800fa7:	c7 44 24 08 a7 2c 80 	movl   $0x802ca7,0x8(%esp)
  800fae:	00 
  800faf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb6:	00 
  800fb7:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  800fbe:	e8 64 f2 ff ff       	call   800227 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fc3:	83 c4 2c             	add    $0x2c,%esp
  800fc6:	5b                   	pop    %ebx
  800fc7:	5e                   	pop    %esi
  800fc8:	5f                   	pop    %edi
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    

00800fcb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	57                   	push   %edi
  800fcf:	56                   	push   %esi
  800fd0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd1:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fdb:	89 d1                	mov    %edx,%ecx
  800fdd:	89 d3                	mov    %edx,%ebx
  800fdf:	89 d7                	mov    %edx,%edi
  800fe1:	89 d6                	mov    %edx,%esi
  800fe3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fe5:	5b                   	pop    %ebx
  800fe6:	5e                   	pop    %esi
  800fe7:	5f                   	pop    %edi
  800fe8:	5d                   	pop    %ebp
  800fe9:	c3                   	ret    

00800fea <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	57                   	push   %edi
  800fee:	56                   	push   %esi
  800fef:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff5:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ffa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffd:	8b 55 08             	mov    0x8(%ebp),%edx
  801000:	89 df                	mov    %ebx,%edi
  801002:	89 de                	mov    %ebx,%esi
  801004:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  801006:	5b                   	pop    %ebx
  801007:	5e                   	pop    %esi
  801008:	5f                   	pop    %edi
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    

0080100b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	57                   	push   %edi
  80100f:	56                   	push   %esi
  801010:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801011:	bb 00 00 00 00       	mov    $0x0,%ebx
  801016:	b8 10 00 00 00       	mov    $0x10,%eax
  80101b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101e:	8b 55 08             	mov    0x8(%ebp),%edx
  801021:	89 df                	mov    %ebx,%edi
  801023:	89 de                	mov    %ebx,%esi
  801025:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  801027:	5b                   	pop    %ebx
  801028:	5e                   	pop    %esi
  801029:	5f                   	pop    %edi
  80102a:	5d                   	pop    %ebp
  80102b:	c3                   	ret    

0080102c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	57                   	push   %edi
  801030:	56                   	push   %esi
  801031:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801032:	b9 00 00 00 00       	mov    $0x0,%ecx
  801037:	b8 11 00 00 00       	mov    $0x11,%eax
  80103c:	8b 55 08             	mov    0x8(%ebp),%edx
  80103f:	89 cb                	mov    %ecx,%ebx
  801041:	89 cf                	mov    %ecx,%edi
  801043:	89 ce                	mov    %ecx,%esi
  801045:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801047:	5b                   	pop    %ebx
  801048:	5e                   	pop    %esi
  801049:	5f                   	pop    %edi
  80104a:	5d                   	pop    %ebp
  80104b:	c3                   	ret    

0080104c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
  80104f:	57                   	push   %edi
  801050:	56                   	push   %esi
  801051:	53                   	push   %ebx
  801052:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801055:	be 00 00 00 00       	mov    $0x0,%esi
  80105a:	b8 12 00 00 00       	mov    $0x12,%eax
  80105f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801062:	8b 55 08             	mov    0x8(%ebp),%edx
  801065:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801068:	8b 7d 14             	mov    0x14(%ebp),%edi
  80106b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80106d:	85 c0                	test   %eax,%eax
  80106f:	7e 28                	jle    801099 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801071:	89 44 24 10          	mov    %eax,0x10(%esp)
  801075:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80107c:	00 
  80107d:	c7 44 24 08 a7 2c 80 	movl   $0x802ca7,0x8(%esp)
  801084:	00 
  801085:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80108c:	00 
  80108d:	c7 04 24 c4 2c 80 00 	movl   $0x802cc4,(%esp)
  801094:	e8 8e f1 ff ff       	call   800227 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801099:	83 c4 2c             	add    $0x2c,%esp
  80109c:	5b                   	pop    %ebx
  80109d:	5e                   	pop    %esi
  80109e:	5f                   	pop    %edi
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    
  8010a1:	66 90                	xchg   %ax,%ax
  8010a3:	66 90                	xchg   %ax,%ax
  8010a5:	66 90                	xchg   %ax,%ax
  8010a7:	66 90                	xchg   %ax,%ax
  8010a9:	66 90                	xchg   %ax,%ax
  8010ab:	66 90                	xchg   %ax,%ax
  8010ad:	66 90                	xchg   %ax,%ax
  8010af:	90                   	nop

008010b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010bb:	c1 e8 0c             	shr    $0xc,%eax
}
  8010be:	5d                   	pop    %ebp
  8010bf:	c3                   	ret    

008010c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8010cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010d0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010d5:	5d                   	pop    %ebp
  8010d6:	c3                   	ret    

008010d7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010dd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010e2:	89 c2                	mov    %eax,%edx
  8010e4:	c1 ea 16             	shr    $0x16,%edx
  8010e7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ee:	f6 c2 01             	test   $0x1,%dl
  8010f1:	74 11                	je     801104 <fd_alloc+0x2d>
  8010f3:	89 c2                	mov    %eax,%edx
  8010f5:	c1 ea 0c             	shr    $0xc,%edx
  8010f8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010ff:	f6 c2 01             	test   $0x1,%dl
  801102:	75 09                	jne    80110d <fd_alloc+0x36>
			*fd_store = fd;
  801104:	89 01                	mov    %eax,(%ecx)
			return 0;
  801106:	b8 00 00 00 00       	mov    $0x0,%eax
  80110b:	eb 17                	jmp    801124 <fd_alloc+0x4d>
  80110d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801112:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801117:	75 c9                	jne    8010e2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801119:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80111f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801124:	5d                   	pop    %ebp
  801125:	c3                   	ret    

00801126 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80112c:	83 f8 1f             	cmp    $0x1f,%eax
  80112f:	77 36                	ja     801167 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801131:	c1 e0 0c             	shl    $0xc,%eax
  801134:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801139:	89 c2                	mov    %eax,%edx
  80113b:	c1 ea 16             	shr    $0x16,%edx
  80113e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801145:	f6 c2 01             	test   $0x1,%dl
  801148:	74 24                	je     80116e <fd_lookup+0x48>
  80114a:	89 c2                	mov    %eax,%edx
  80114c:	c1 ea 0c             	shr    $0xc,%edx
  80114f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801156:	f6 c2 01             	test   $0x1,%dl
  801159:	74 1a                	je     801175 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80115b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80115e:	89 02                	mov    %eax,(%edx)
	return 0;
  801160:	b8 00 00 00 00       	mov    $0x0,%eax
  801165:	eb 13                	jmp    80117a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801167:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116c:	eb 0c                	jmp    80117a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80116e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801173:	eb 05                	jmp    80117a <fd_lookup+0x54>
  801175:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80117a:	5d                   	pop    %ebp
  80117b:	c3                   	ret    

0080117c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	83 ec 18             	sub    $0x18,%esp
  801182:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801185:	ba 00 00 00 00       	mov    $0x0,%edx
  80118a:	eb 13                	jmp    80119f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80118c:	39 08                	cmp    %ecx,(%eax)
  80118e:	75 0c                	jne    80119c <dev_lookup+0x20>
			*dev = devtab[i];
  801190:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801193:	89 01                	mov    %eax,(%ecx)
			return 0;
  801195:	b8 00 00 00 00       	mov    $0x0,%eax
  80119a:	eb 38                	jmp    8011d4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80119c:	83 c2 01             	add    $0x1,%edx
  80119f:	8b 04 95 54 2d 80 00 	mov    0x802d54(,%edx,4),%eax
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	75 e2                	jne    80118c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011aa:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8011af:	8b 40 48             	mov    0x48(%eax),%eax
  8011b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8011b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ba:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  8011c1:	e8 5a f1 ff ff       	call   800320 <cprintf>
	*dev = 0;
  8011c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    

008011d6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	56                   	push   %esi
  8011da:	53                   	push   %ebx
  8011db:	83 ec 20             	sub    $0x20,%esp
  8011de:	8b 75 08             	mov    0x8(%ebp),%esi
  8011e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011eb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011f1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011f4:	89 04 24             	mov    %eax,(%esp)
  8011f7:	e8 2a ff ff ff       	call   801126 <fd_lookup>
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	78 05                	js     801205 <fd_close+0x2f>
	    || fd != fd2)
  801200:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801203:	74 0c                	je     801211 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801205:	84 db                	test   %bl,%bl
  801207:	ba 00 00 00 00       	mov    $0x0,%edx
  80120c:	0f 44 c2             	cmove  %edx,%eax
  80120f:	eb 3f                	jmp    801250 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801211:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801214:	89 44 24 04          	mov    %eax,0x4(%esp)
  801218:	8b 06                	mov    (%esi),%eax
  80121a:	89 04 24             	mov    %eax,(%esp)
  80121d:	e8 5a ff ff ff       	call   80117c <dev_lookup>
  801222:	89 c3                	mov    %eax,%ebx
  801224:	85 c0                	test   %eax,%eax
  801226:	78 16                	js     80123e <fd_close+0x68>
		if (dev->dev_close)
  801228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80122e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801233:	85 c0                	test   %eax,%eax
  801235:	74 07                	je     80123e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801237:	89 34 24             	mov    %esi,(%esp)
  80123a:	ff d0                	call   *%eax
  80123c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80123e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801242:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801249:	e8 bc fb ff ff       	call   800e0a <sys_page_unmap>
	return r;
  80124e:	89 d8                	mov    %ebx,%eax
}
  801250:	83 c4 20             	add    $0x20,%esp
  801253:	5b                   	pop    %ebx
  801254:	5e                   	pop    %esi
  801255:	5d                   	pop    %ebp
  801256:	c3                   	ret    

00801257 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
  80125a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80125d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801260:	89 44 24 04          	mov    %eax,0x4(%esp)
  801264:	8b 45 08             	mov    0x8(%ebp),%eax
  801267:	89 04 24             	mov    %eax,(%esp)
  80126a:	e8 b7 fe ff ff       	call   801126 <fd_lookup>
  80126f:	89 c2                	mov    %eax,%edx
  801271:	85 d2                	test   %edx,%edx
  801273:	78 13                	js     801288 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801275:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80127c:	00 
  80127d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801280:	89 04 24             	mov    %eax,(%esp)
  801283:	e8 4e ff ff ff       	call   8011d6 <fd_close>
}
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <close_all>:

void
close_all(void)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	53                   	push   %ebx
  80128e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801291:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801296:	89 1c 24             	mov    %ebx,(%esp)
  801299:	e8 b9 ff ff ff       	call   801257 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80129e:	83 c3 01             	add    $0x1,%ebx
  8012a1:	83 fb 20             	cmp    $0x20,%ebx
  8012a4:	75 f0                	jne    801296 <close_all+0xc>
		close(i);
}
  8012a6:	83 c4 14             	add    $0x14,%esp
  8012a9:	5b                   	pop    %ebx
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    

008012ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	57                   	push   %edi
  8012b0:	56                   	push   %esi
  8012b1:	53                   	push   %ebx
  8012b2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	89 04 24             	mov    %eax,(%esp)
  8012c2:	e8 5f fe ff ff       	call   801126 <fd_lookup>
  8012c7:	89 c2                	mov    %eax,%edx
  8012c9:	85 d2                	test   %edx,%edx
  8012cb:	0f 88 e1 00 00 00    	js     8013b2 <dup+0x106>
		return r;
	close(newfdnum);
  8012d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d4:	89 04 24             	mov    %eax,(%esp)
  8012d7:	e8 7b ff ff ff       	call   801257 <close>

	newfd = INDEX2FD(newfdnum);
  8012dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8012df:	c1 e3 0c             	shl    $0xc,%ebx
  8012e2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8012e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012eb:	89 04 24             	mov    %eax,(%esp)
  8012ee:	e8 cd fd ff ff       	call   8010c0 <fd2data>
  8012f3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8012f5:	89 1c 24             	mov    %ebx,(%esp)
  8012f8:	e8 c3 fd ff ff       	call   8010c0 <fd2data>
  8012fd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012ff:	89 f0                	mov    %esi,%eax
  801301:	c1 e8 16             	shr    $0x16,%eax
  801304:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80130b:	a8 01                	test   $0x1,%al
  80130d:	74 43                	je     801352 <dup+0xa6>
  80130f:	89 f0                	mov    %esi,%eax
  801311:	c1 e8 0c             	shr    $0xc,%eax
  801314:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80131b:	f6 c2 01             	test   $0x1,%dl
  80131e:	74 32                	je     801352 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801320:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801327:	25 07 0e 00 00       	and    $0xe07,%eax
  80132c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801330:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801334:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80133b:	00 
  80133c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801340:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801347:	e8 6b fa ff ff       	call   800db7 <sys_page_map>
  80134c:	89 c6                	mov    %eax,%esi
  80134e:	85 c0                	test   %eax,%eax
  801350:	78 3e                	js     801390 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801355:	89 c2                	mov    %eax,%edx
  801357:	c1 ea 0c             	shr    $0xc,%edx
  80135a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801361:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801367:	89 54 24 10          	mov    %edx,0x10(%esp)
  80136b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80136f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801376:	00 
  801377:	89 44 24 04          	mov    %eax,0x4(%esp)
  80137b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801382:	e8 30 fa ff ff       	call   800db7 <sys_page_map>
  801387:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801389:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80138c:	85 f6                	test   %esi,%esi
  80138e:	79 22                	jns    8013b2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801390:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801394:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80139b:	e8 6a fa ff ff       	call   800e0a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013ab:	e8 5a fa ff ff       	call   800e0a <sys_page_unmap>
	return r;
  8013b0:	89 f0                	mov    %esi,%eax
}
  8013b2:	83 c4 3c             	add    $0x3c,%esp
  8013b5:	5b                   	pop    %ebx
  8013b6:	5e                   	pop    %esi
  8013b7:	5f                   	pop    %edi
  8013b8:	5d                   	pop    %ebp
  8013b9:	c3                   	ret    

008013ba <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013ba:	55                   	push   %ebp
  8013bb:	89 e5                	mov    %esp,%ebp
  8013bd:	53                   	push   %ebx
  8013be:	83 ec 24             	sub    $0x24,%esp
  8013c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013cb:	89 1c 24             	mov    %ebx,(%esp)
  8013ce:	e8 53 fd ff ff       	call   801126 <fd_lookup>
  8013d3:	89 c2                	mov    %eax,%edx
  8013d5:	85 d2                	test   %edx,%edx
  8013d7:	78 6d                	js     801446 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e3:	8b 00                	mov    (%eax),%eax
  8013e5:	89 04 24             	mov    %eax,(%esp)
  8013e8:	e8 8f fd ff ff       	call   80117c <dev_lookup>
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	78 55                	js     801446 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f4:	8b 50 08             	mov    0x8(%eax),%edx
  8013f7:	83 e2 03             	and    $0x3,%edx
  8013fa:	83 fa 01             	cmp    $0x1,%edx
  8013fd:	75 23                	jne    801422 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013ff:	a1 0c 40 80 00       	mov    0x80400c,%eax
  801404:	8b 40 48             	mov    0x48(%eax),%eax
  801407:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80140b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140f:	c7 04 24 18 2d 80 00 	movl   $0x802d18,(%esp)
  801416:	e8 05 ef ff ff       	call   800320 <cprintf>
		return -E_INVAL;
  80141b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801420:	eb 24                	jmp    801446 <read+0x8c>
	}
	if (!dev->dev_read)
  801422:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801425:	8b 52 08             	mov    0x8(%edx),%edx
  801428:	85 d2                	test   %edx,%edx
  80142a:	74 15                	je     801441 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80142c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80142f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801433:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801436:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80143a:	89 04 24             	mov    %eax,(%esp)
  80143d:	ff d2                	call   *%edx
  80143f:	eb 05                	jmp    801446 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801441:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801446:	83 c4 24             	add    $0x24,%esp
  801449:	5b                   	pop    %ebx
  80144a:	5d                   	pop    %ebp
  80144b:	c3                   	ret    

0080144c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	57                   	push   %edi
  801450:	56                   	push   %esi
  801451:	53                   	push   %ebx
  801452:	83 ec 1c             	sub    $0x1c,%esp
  801455:	8b 7d 08             	mov    0x8(%ebp),%edi
  801458:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80145b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801460:	eb 23                	jmp    801485 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801462:	89 f0                	mov    %esi,%eax
  801464:	29 d8                	sub    %ebx,%eax
  801466:	89 44 24 08          	mov    %eax,0x8(%esp)
  80146a:	89 d8                	mov    %ebx,%eax
  80146c:	03 45 0c             	add    0xc(%ebp),%eax
  80146f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801473:	89 3c 24             	mov    %edi,(%esp)
  801476:	e8 3f ff ff ff       	call   8013ba <read>
		if (m < 0)
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 10                	js     80148f <readn+0x43>
			return m;
		if (m == 0)
  80147f:	85 c0                	test   %eax,%eax
  801481:	74 0a                	je     80148d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801483:	01 c3                	add    %eax,%ebx
  801485:	39 f3                	cmp    %esi,%ebx
  801487:	72 d9                	jb     801462 <readn+0x16>
  801489:	89 d8                	mov    %ebx,%eax
  80148b:	eb 02                	jmp    80148f <readn+0x43>
  80148d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80148f:	83 c4 1c             	add    $0x1c,%esp
  801492:	5b                   	pop    %ebx
  801493:	5e                   	pop    %esi
  801494:	5f                   	pop    %edi
  801495:	5d                   	pop    %ebp
  801496:	c3                   	ret    

00801497 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	53                   	push   %ebx
  80149b:	83 ec 24             	sub    $0x24,%esp
  80149e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a8:	89 1c 24             	mov    %ebx,(%esp)
  8014ab:	e8 76 fc ff ff       	call   801126 <fd_lookup>
  8014b0:	89 c2                	mov    %eax,%edx
  8014b2:	85 d2                	test   %edx,%edx
  8014b4:	78 68                	js     80151e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c0:	8b 00                	mov    (%eax),%eax
  8014c2:	89 04 24             	mov    %eax,(%esp)
  8014c5:	e8 b2 fc ff ff       	call   80117c <dev_lookup>
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	78 50                	js     80151e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014d5:	75 23                	jne    8014fa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014d7:	a1 0c 40 80 00       	mov    0x80400c,%eax
  8014dc:	8b 40 48             	mov    0x48(%eax),%eax
  8014df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e7:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  8014ee:	e8 2d ee ff ff       	call   800320 <cprintf>
		return -E_INVAL;
  8014f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f8:	eb 24                	jmp    80151e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014fd:	8b 52 0c             	mov    0xc(%edx),%edx
  801500:	85 d2                	test   %edx,%edx
  801502:	74 15                	je     801519 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801504:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801507:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80150b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80150e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801512:	89 04 24             	mov    %eax,(%esp)
  801515:	ff d2                	call   *%edx
  801517:	eb 05                	jmp    80151e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801519:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80151e:	83 c4 24             	add    $0x24,%esp
  801521:	5b                   	pop    %ebx
  801522:	5d                   	pop    %ebp
  801523:	c3                   	ret    

00801524 <seek>:

int
seek(int fdnum, off_t offset)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80152a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80152d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	89 04 24             	mov    %eax,(%esp)
  801537:	e8 ea fb ff ff       	call   801126 <fd_lookup>
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 0e                	js     80154e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801543:	8b 55 0c             	mov    0xc(%ebp),%edx
  801546:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801549:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154e:	c9                   	leave  
  80154f:	c3                   	ret    

00801550 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	53                   	push   %ebx
  801554:	83 ec 24             	sub    $0x24,%esp
  801557:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80155a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80155d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801561:	89 1c 24             	mov    %ebx,(%esp)
  801564:	e8 bd fb ff ff       	call   801126 <fd_lookup>
  801569:	89 c2                	mov    %eax,%edx
  80156b:	85 d2                	test   %edx,%edx
  80156d:	78 61                	js     8015d0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80156f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801572:	89 44 24 04          	mov    %eax,0x4(%esp)
  801576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801579:	8b 00                	mov    (%eax),%eax
  80157b:	89 04 24             	mov    %eax,(%esp)
  80157e:	e8 f9 fb ff ff       	call   80117c <dev_lookup>
  801583:	85 c0                	test   %eax,%eax
  801585:	78 49                	js     8015d0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80158e:	75 23                	jne    8015b3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801590:	a1 0c 40 80 00       	mov    0x80400c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801595:	8b 40 48             	mov    0x48(%eax),%eax
  801598:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80159c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a0:	c7 04 24 f4 2c 80 00 	movl   $0x802cf4,(%esp)
  8015a7:	e8 74 ed ff ff       	call   800320 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8015ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b1:	eb 1d                	jmp    8015d0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8015b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b6:	8b 52 18             	mov    0x18(%edx),%edx
  8015b9:	85 d2                	test   %edx,%edx
  8015bb:	74 0e                	je     8015cb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015c0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015c4:	89 04 24             	mov    %eax,(%esp)
  8015c7:	ff d2                	call   *%edx
  8015c9:	eb 05                	jmp    8015d0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8015cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8015d0:	83 c4 24             	add    $0x24,%esp
  8015d3:	5b                   	pop    %ebx
  8015d4:	5d                   	pop    %ebp
  8015d5:	c3                   	ret    

008015d6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	53                   	push   %ebx
  8015da:	83 ec 24             	sub    $0x24,%esp
  8015dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	89 04 24             	mov    %eax,(%esp)
  8015ed:	e8 34 fb ff ff       	call   801126 <fd_lookup>
  8015f2:	89 c2                	mov    %eax,%edx
  8015f4:	85 d2                	test   %edx,%edx
  8015f6:	78 52                	js     80164a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801602:	8b 00                	mov    (%eax),%eax
  801604:	89 04 24             	mov    %eax,(%esp)
  801607:	e8 70 fb ff ff       	call   80117c <dev_lookup>
  80160c:	85 c0                	test   %eax,%eax
  80160e:	78 3a                	js     80164a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801613:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801617:	74 2c                	je     801645 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801619:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80161c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801623:	00 00 00 
	stat->st_isdir = 0;
  801626:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80162d:	00 00 00 
	stat->st_dev = dev;
  801630:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801636:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80163a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80163d:	89 14 24             	mov    %edx,(%esp)
  801640:	ff 50 14             	call   *0x14(%eax)
  801643:	eb 05                	jmp    80164a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801645:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80164a:	83 c4 24             	add    $0x24,%esp
  80164d:	5b                   	pop    %ebx
  80164e:	5d                   	pop    %ebp
  80164f:	c3                   	ret    

00801650 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	56                   	push   %esi
  801654:	53                   	push   %ebx
  801655:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801658:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80165f:	00 
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	89 04 24             	mov    %eax,(%esp)
  801666:	e8 84 02 00 00       	call   8018ef <open>
  80166b:	89 c3                	mov    %eax,%ebx
  80166d:	85 db                	test   %ebx,%ebx
  80166f:	78 1b                	js     80168c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801671:	8b 45 0c             	mov    0xc(%ebp),%eax
  801674:	89 44 24 04          	mov    %eax,0x4(%esp)
  801678:	89 1c 24             	mov    %ebx,(%esp)
  80167b:	e8 56 ff ff ff       	call   8015d6 <fstat>
  801680:	89 c6                	mov    %eax,%esi
	close(fd);
  801682:	89 1c 24             	mov    %ebx,(%esp)
  801685:	e8 cd fb ff ff       	call   801257 <close>
	return r;
  80168a:	89 f0                	mov    %esi,%eax
}
  80168c:	83 c4 10             	add    $0x10,%esp
  80168f:	5b                   	pop    %ebx
  801690:	5e                   	pop    %esi
  801691:	5d                   	pop    %ebp
  801692:	c3                   	ret    

00801693 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	56                   	push   %esi
  801697:	53                   	push   %ebx
  801698:	83 ec 10             	sub    $0x10,%esp
  80169b:	89 c6                	mov    %eax,%esi
  80169d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80169f:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8016a6:	75 11                	jne    8016b9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8016a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8016af:	e8 51 0f 00 00       	call   802605 <ipc_find_env>
  8016b4:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016b9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8016c0:	00 
  8016c1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8016c8:	00 
  8016c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016cd:	a1 04 40 80 00       	mov    0x804004,%eax
  8016d2:	89 04 24             	mov    %eax,(%esp)
  8016d5:	e8 9e 0e 00 00       	call   802578 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016e1:	00 
  8016e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016ed:	e8 1e 0e 00 00       	call   802510 <ipc_recv>
}
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	5b                   	pop    %ebx
  8016f6:	5e                   	pop    %esi
  8016f7:	5d                   	pop    %ebp
  8016f8:	c3                   	ret    

008016f9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	8b 40 0c             	mov    0xc(%eax),%eax
  801705:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80170a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801712:	ba 00 00 00 00       	mov    $0x0,%edx
  801717:	b8 02 00 00 00       	mov    $0x2,%eax
  80171c:	e8 72 ff ff ff       	call   801693 <fsipc>
}
  801721:	c9                   	leave  
  801722:	c3                   	ret    

00801723 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	8b 40 0c             	mov    0xc(%eax),%eax
  80172f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801734:	ba 00 00 00 00       	mov    $0x0,%edx
  801739:	b8 06 00 00 00       	mov    $0x6,%eax
  80173e:	e8 50 ff ff ff       	call   801693 <fsipc>
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	53                   	push   %ebx
  801749:	83 ec 14             	sub    $0x14,%esp
  80174c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	8b 40 0c             	mov    0xc(%eax),%eax
  801755:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80175a:	ba 00 00 00 00       	mov    $0x0,%edx
  80175f:	b8 05 00 00 00       	mov    $0x5,%eax
  801764:	e8 2a ff ff ff       	call   801693 <fsipc>
  801769:	89 c2                	mov    %eax,%edx
  80176b:	85 d2                	test   %edx,%edx
  80176d:	78 2b                	js     80179a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80176f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801776:	00 
  801777:	89 1c 24             	mov    %ebx,(%esp)
  80177a:	e8 c8 f1 ff ff       	call   800947 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80177f:	a1 80 50 80 00       	mov    0x805080,%eax
  801784:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80178a:	a1 84 50 80 00       	mov    0x805084,%eax
  80178f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179a:	83 c4 14             	add    $0x14,%esp
  80179d:	5b                   	pop    %ebx
  80179e:	5d                   	pop    %ebp
  80179f:	c3                   	ret    

008017a0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	53                   	push   %ebx
  8017a4:	83 ec 14             	sub    $0x14,%esp
  8017a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8017b0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  8017b5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8017bb:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8017c0:	0f 46 c3             	cmovbe %ebx,%eax
  8017c3:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8017c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d3:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8017da:	e8 05 f3 ff ff       	call   800ae4 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8017df:	ba 00 00 00 00       	mov    $0x0,%edx
  8017e4:	b8 04 00 00 00       	mov    $0x4,%eax
  8017e9:	e8 a5 fe ff ff       	call   801693 <fsipc>
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	78 53                	js     801845 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  8017f2:	39 c3                	cmp    %eax,%ebx
  8017f4:	73 24                	jae    80181a <devfile_write+0x7a>
  8017f6:	c7 44 24 0c 68 2d 80 	movl   $0x802d68,0xc(%esp)
  8017fd:	00 
  8017fe:	c7 44 24 08 6f 2d 80 	movl   $0x802d6f,0x8(%esp)
  801805:	00 
  801806:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  80180d:	00 
  80180e:	c7 04 24 84 2d 80 00 	movl   $0x802d84,(%esp)
  801815:	e8 0d ea ff ff       	call   800227 <_panic>
	assert(r <= PGSIZE);
  80181a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80181f:	7e 24                	jle    801845 <devfile_write+0xa5>
  801821:	c7 44 24 0c 8f 2d 80 	movl   $0x802d8f,0xc(%esp)
  801828:	00 
  801829:	c7 44 24 08 6f 2d 80 	movl   $0x802d6f,0x8(%esp)
  801830:	00 
  801831:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801838:	00 
  801839:	c7 04 24 84 2d 80 00 	movl   $0x802d84,(%esp)
  801840:	e8 e2 e9 ff ff       	call   800227 <_panic>
	return r;
}
  801845:	83 c4 14             	add    $0x14,%esp
  801848:	5b                   	pop    %ebx
  801849:	5d                   	pop    %ebp
  80184a:	c3                   	ret    

0080184b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	56                   	push   %esi
  80184f:	53                   	push   %ebx
  801850:	83 ec 10             	sub    $0x10,%esp
  801853:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	8b 40 0c             	mov    0xc(%eax),%eax
  80185c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801861:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801867:	ba 00 00 00 00       	mov    $0x0,%edx
  80186c:	b8 03 00 00 00       	mov    $0x3,%eax
  801871:	e8 1d fe ff ff       	call   801693 <fsipc>
  801876:	89 c3                	mov    %eax,%ebx
  801878:	85 c0                	test   %eax,%eax
  80187a:	78 6a                	js     8018e6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  80187c:	39 c6                	cmp    %eax,%esi
  80187e:	73 24                	jae    8018a4 <devfile_read+0x59>
  801880:	c7 44 24 0c 68 2d 80 	movl   $0x802d68,0xc(%esp)
  801887:	00 
  801888:	c7 44 24 08 6f 2d 80 	movl   $0x802d6f,0x8(%esp)
  80188f:	00 
  801890:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801897:	00 
  801898:	c7 04 24 84 2d 80 00 	movl   $0x802d84,(%esp)
  80189f:	e8 83 e9 ff ff       	call   800227 <_panic>
	assert(r <= PGSIZE);
  8018a4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018a9:	7e 24                	jle    8018cf <devfile_read+0x84>
  8018ab:	c7 44 24 0c 8f 2d 80 	movl   $0x802d8f,0xc(%esp)
  8018b2:	00 
  8018b3:	c7 44 24 08 6f 2d 80 	movl   $0x802d6f,0x8(%esp)
  8018ba:	00 
  8018bb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8018c2:	00 
  8018c3:	c7 04 24 84 2d 80 00 	movl   $0x802d84,(%esp)
  8018ca:	e8 58 e9 ff ff       	call   800227 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018d3:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8018da:	00 
  8018db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018de:	89 04 24             	mov    %eax,(%esp)
  8018e1:	e8 fe f1 ff ff       	call   800ae4 <memmove>
	return r;
}
  8018e6:	89 d8                	mov    %ebx,%eax
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	5b                   	pop    %ebx
  8018ec:	5e                   	pop    %esi
  8018ed:	5d                   	pop    %ebp
  8018ee:	c3                   	ret    

008018ef <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	53                   	push   %ebx
  8018f3:	83 ec 24             	sub    $0x24,%esp
  8018f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018f9:	89 1c 24             	mov    %ebx,(%esp)
  8018fc:	e8 0f f0 ff ff       	call   800910 <strlen>
  801901:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801906:	7f 60                	jg     801968 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801908:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80190b:	89 04 24             	mov    %eax,(%esp)
  80190e:	e8 c4 f7 ff ff       	call   8010d7 <fd_alloc>
  801913:	89 c2                	mov    %eax,%edx
  801915:	85 d2                	test   %edx,%edx
  801917:	78 54                	js     80196d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801919:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80191d:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801924:	e8 1e f0 ff ff       	call   800947 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192c:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801931:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801934:	b8 01 00 00 00       	mov    $0x1,%eax
  801939:	e8 55 fd ff ff       	call   801693 <fsipc>
  80193e:	89 c3                	mov    %eax,%ebx
  801940:	85 c0                	test   %eax,%eax
  801942:	79 17                	jns    80195b <open+0x6c>
		fd_close(fd, 0);
  801944:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80194b:	00 
  80194c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194f:	89 04 24             	mov    %eax,(%esp)
  801952:	e8 7f f8 ff ff       	call   8011d6 <fd_close>
		return r;
  801957:	89 d8                	mov    %ebx,%eax
  801959:	eb 12                	jmp    80196d <open+0x7e>
	}

	return fd2num(fd);
  80195b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195e:	89 04 24             	mov    %eax,(%esp)
  801961:	e8 4a f7 ff ff       	call   8010b0 <fd2num>
  801966:	eb 05                	jmp    80196d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801968:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80196d:	83 c4 24             	add    $0x24,%esp
  801970:	5b                   	pop    %ebx
  801971:	5d                   	pop    %ebp
  801972:	c3                   	ret    

00801973 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801979:	ba 00 00 00 00       	mov    $0x0,%edx
  80197e:	b8 08 00 00 00       	mov    $0x8,%eax
  801983:	e8 0b fd ff ff       	call   801693 <fsipc>
}
  801988:	c9                   	leave  
  801989:	c3                   	ret    

0080198a <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	53                   	push   %ebx
  80198e:	83 ec 14             	sub    $0x14,%esp
  801991:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801993:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801997:	7e 31                	jle    8019ca <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801999:	8b 40 04             	mov    0x4(%eax),%eax
  80199c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019a0:	8d 43 10             	lea    0x10(%ebx),%eax
  8019a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a7:	8b 03                	mov    (%ebx),%eax
  8019a9:	89 04 24             	mov    %eax,(%esp)
  8019ac:	e8 e6 fa ff ff       	call   801497 <write>
		if (result > 0)
  8019b1:	85 c0                	test   %eax,%eax
  8019b3:	7e 03                	jle    8019b8 <writebuf+0x2e>
			b->result += result;
  8019b5:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8019b8:	39 43 04             	cmp    %eax,0x4(%ebx)
  8019bb:	74 0d                	je     8019ca <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  8019bd:	85 c0                	test   %eax,%eax
  8019bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c4:	0f 4f c2             	cmovg  %edx,%eax
  8019c7:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8019ca:	83 c4 14             	add    $0x14,%esp
  8019cd:	5b                   	pop    %ebx
  8019ce:	5d                   	pop    %ebp
  8019cf:	c3                   	ret    

008019d0 <putch>:

static void
putch(int ch, void *thunk)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	53                   	push   %ebx
  8019d4:	83 ec 04             	sub    $0x4,%esp
  8019d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8019da:	8b 53 04             	mov    0x4(%ebx),%edx
  8019dd:	8d 42 01             	lea    0x1(%edx),%eax
  8019e0:	89 43 04             	mov    %eax,0x4(%ebx)
  8019e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019e6:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  8019ea:	3d 00 01 00 00       	cmp    $0x100,%eax
  8019ef:	75 0e                	jne    8019ff <putch+0x2f>
		writebuf(b);
  8019f1:	89 d8                	mov    %ebx,%eax
  8019f3:	e8 92 ff ff ff       	call   80198a <writebuf>
		b->idx = 0;
  8019f8:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  8019ff:	83 c4 04             	add    $0x4,%esp
  801a02:	5b                   	pop    %ebx
  801a03:	5d                   	pop    %ebp
  801a04:	c3                   	ret    

00801a05 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801a17:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801a1e:	00 00 00 
	b.result = 0;
  801a21:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a28:	00 00 00 
	b.error = 1;
  801a2b:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801a32:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801a35:	8b 45 10             	mov    0x10(%ebp),%eax
  801a38:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a43:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4d:	c7 04 24 d0 19 80 00 	movl   $0x8019d0,(%esp)
  801a54:	e8 55 ea ff ff       	call   8004ae <vprintfmt>
	if (b.idx > 0)
  801a59:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a60:	7e 0b                	jle    801a6d <vfprintf+0x68>
		writebuf(&b);
  801a62:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a68:	e8 1d ff ff ff       	call   80198a <writebuf>

	return (b.result ? b.result : b.error);
  801a6d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a73:	85 c0                	test   %eax,%eax
  801a75:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a84:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a87:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 04 24             	mov    %eax,(%esp)
  801a98:	e8 68 ff ff ff       	call   801a05 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <printf>:

int
printf(const char *fmt, ...)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801aa5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801aa8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801aba:	e8 46 ff ff ff       	call   801a05 <vfprintf>
	va_end(ap);

	return cnt;
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    
  801ac1:	66 90                	xchg   %ax,%ax
  801ac3:	66 90                	xchg   %ax,%ax
  801ac5:	66 90                	xchg   %ax,%ax
  801ac7:	66 90                	xchg   %ax,%ax
  801ac9:	66 90                	xchg   %ax,%ax
  801acb:	66 90                	xchg   %ax,%ax
  801acd:	66 90                	xchg   %ax,%ax
  801acf:	90                   	nop

00801ad0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ad6:	c7 44 24 04 9b 2d 80 	movl   $0x802d9b,0x4(%esp)
  801add:	00 
  801ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae1:	89 04 24             	mov    %eax,(%esp)
  801ae4:	e8 5e ee ff ff       	call   800947 <strcpy>
	return 0;
}
  801ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	53                   	push   %ebx
  801af4:	83 ec 14             	sub    $0x14,%esp
  801af7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801afa:	89 1c 24             	mov    %ebx,(%esp)
  801afd:	e8 3d 0b 00 00       	call   80263f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801b02:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801b07:	83 f8 01             	cmp    $0x1,%eax
  801b0a:	75 0d                	jne    801b19 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801b0c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801b0f:	89 04 24             	mov    %eax,(%esp)
  801b12:	e8 29 03 00 00       	call   801e40 <nsipc_close>
  801b17:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801b19:	89 d0                	mov    %edx,%eax
  801b1b:	83 c4 14             	add    $0x14,%esp
  801b1e:	5b                   	pop    %ebx
  801b1f:	5d                   	pop    %ebp
  801b20:	c3                   	ret    

00801b21 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b27:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b2e:	00 
  801b2f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b32:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b40:	8b 40 0c             	mov    0xc(%eax),%eax
  801b43:	89 04 24             	mov    %eax,(%esp)
  801b46:	e8 f0 03 00 00       	call   801f3b <nsipc_send>
}
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
  801b50:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801b53:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b5a:	00 
  801b5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6f:	89 04 24             	mov    %eax,(%esp)
  801b72:	e8 44 03 00 00       	call   801ebb <nsipc_recv>
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b7f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b82:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b86:	89 04 24             	mov    %eax,(%esp)
  801b89:	e8 98 f5 ff ff       	call   801126 <fd_lookup>
  801b8e:	85 c0                	test   %eax,%eax
  801b90:	78 17                	js     801ba9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b95:	8b 0d 24 30 80 00    	mov    0x803024,%ecx
  801b9b:	39 08                	cmp    %ecx,(%eax)
  801b9d:	75 05                	jne    801ba4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801b9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba2:	eb 05                	jmp    801ba9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ba4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	56                   	push   %esi
  801baf:	53                   	push   %ebx
  801bb0:	83 ec 20             	sub    $0x20,%esp
  801bb3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801bb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb8:	89 04 24             	mov    %eax,(%esp)
  801bbb:	e8 17 f5 ff ff       	call   8010d7 <fd_alloc>
  801bc0:	89 c3                	mov    %eax,%ebx
  801bc2:	85 c0                	test   %eax,%eax
  801bc4:	78 21                	js     801be7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801bc6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801bcd:	00 
  801bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bdc:	e8 82 f1 ff ff       	call   800d63 <sys_page_alloc>
  801be1:	89 c3                	mov    %eax,%ebx
  801be3:	85 c0                	test   %eax,%eax
  801be5:	79 0c                	jns    801bf3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801be7:	89 34 24             	mov    %esi,(%esp)
  801bea:	e8 51 02 00 00       	call   801e40 <nsipc_close>
		return r;
  801bef:	89 d8                	mov    %ebx,%eax
  801bf1:	eb 20                	jmp    801c13 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801bf3:	8b 15 24 30 80 00    	mov    0x803024,%edx
  801bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801bfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c01:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801c08:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801c0b:	89 14 24             	mov    %edx,(%esp)
  801c0e:	e8 9d f4 ff ff       	call   8010b0 <fd2num>
}
  801c13:	83 c4 20             	add    $0x20,%esp
  801c16:	5b                   	pop    %ebx
  801c17:	5e                   	pop    %esi
  801c18:	5d                   	pop    %ebp
  801c19:	c3                   	ret    

00801c1a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	e8 51 ff ff ff       	call   801b79 <fd2sockid>
		return r;
  801c28:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	78 23                	js     801c51 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c2e:	8b 55 10             	mov    0x10(%ebp),%edx
  801c31:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c38:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c3c:	89 04 24             	mov    %eax,(%esp)
  801c3f:	e8 45 01 00 00       	call   801d89 <nsipc_accept>
		return r;
  801c44:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801c46:	85 c0                	test   %eax,%eax
  801c48:	78 07                	js     801c51 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801c4a:	e8 5c ff ff ff       	call   801bab <alloc_sockfd>
  801c4f:	89 c1                	mov    %eax,%ecx
}
  801c51:	89 c8                	mov    %ecx,%eax
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	e8 16 ff ff ff       	call   801b79 <fd2sockid>
  801c63:	89 c2                	mov    %eax,%edx
  801c65:	85 d2                	test   %edx,%edx
  801c67:	78 16                	js     801c7f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801c69:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c77:	89 14 24             	mov    %edx,(%esp)
  801c7a:	e8 60 01 00 00       	call   801ddf <nsipc_bind>
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <shutdown>:

int
shutdown(int s, int how)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	e8 ea fe ff ff       	call   801b79 <fd2sockid>
  801c8f:	89 c2                	mov    %eax,%edx
  801c91:	85 d2                	test   %edx,%edx
  801c93:	78 0f                	js     801ca4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9c:	89 14 24             	mov    %edx,(%esp)
  801c9f:	e8 7a 01 00 00       	call   801e1e <nsipc_shutdown>
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cac:	8b 45 08             	mov    0x8(%ebp),%eax
  801caf:	e8 c5 fe ff ff       	call   801b79 <fd2sockid>
  801cb4:	89 c2                	mov    %eax,%edx
  801cb6:	85 d2                	test   %edx,%edx
  801cb8:	78 16                	js     801cd0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801cba:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc8:	89 14 24             	mov    %edx,(%esp)
  801ccb:	e8 8a 01 00 00       	call   801e5a <nsipc_connect>
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <listen>:

int
listen(int s, int backlog)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	e8 99 fe ff ff       	call   801b79 <fd2sockid>
  801ce0:	89 c2                	mov    %eax,%edx
  801ce2:	85 d2                	test   %edx,%edx
  801ce4:	78 0f                	js     801cf5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ced:	89 14 24             	mov    %edx,(%esp)
  801cf0:	e8 a4 01 00 00       	call   801e99 <nsipc_listen>
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801cfd:	8b 45 10             	mov    0x10(%ebp),%eax
  801d00:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	89 04 24             	mov    %eax,(%esp)
  801d11:	e8 98 02 00 00       	call   801fae <nsipc_socket>
  801d16:	89 c2                	mov    %eax,%edx
  801d18:	85 d2                	test   %edx,%edx
  801d1a:	78 05                	js     801d21 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801d1c:	e8 8a fe ff ff       	call   801bab <alloc_sockfd>
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	53                   	push   %ebx
  801d27:	83 ec 14             	sub    $0x14,%esp
  801d2a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801d2c:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  801d33:	75 11                	jne    801d46 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801d35:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801d3c:	e8 c4 08 00 00       	call   802605 <ipc_find_env>
  801d41:	a3 08 40 80 00       	mov    %eax,0x804008
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d46:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d4d:	00 
  801d4e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801d55:	00 
  801d56:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d5a:	a1 08 40 80 00       	mov    0x804008,%eax
  801d5f:	89 04 24             	mov    %eax,(%esp)
  801d62:	e8 11 08 00 00       	call   802578 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d67:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d6e:	00 
  801d6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d76:	00 
  801d77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d7e:	e8 8d 07 00 00       	call   802510 <ipc_recv>
}
  801d83:	83 c4 14             	add    $0x14,%esp
  801d86:	5b                   	pop    %ebx
  801d87:	5d                   	pop    %ebp
  801d88:	c3                   	ret    

00801d89 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	56                   	push   %esi
  801d8d:	53                   	push   %ebx
  801d8e:	83 ec 10             	sub    $0x10,%esp
  801d91:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d9c:	8b 06                	mov    (%esi),%eax
  801d9e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801da3:	b8 01 00 00 00       	mov    $0x1,%eax
  801da8:	e8 76 ff ff ff       	call   801d23 <nsipc>
  801dad:	89 c3                	mov    %eax,%ebx
  801daf:	85 c0                	test   %eax,%eax
  801db1:	78 23                	js     801dd6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801db3:	a1 10 60 80 00       	mov    0x806010,%eax
  801db8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dbc:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801dc3:	00 
  801dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc7:	89 04 24             	mov    %eax,(%esp)
  801dca:	e8 15 ed ff ff       	call   800ae4 <memmove>
		*addrlen = ret->ret_addrlen;
  801dcf:	a1 10 60 80 00       	mov    0x806010,%eax
  801dd4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801dd6:	89 d8                	mov    %ebx,%eax
  801dd8:	83 c4 10             	add    $0x10,%esp
  801ddb:	5b                   	pop    %ebx
  801ddc:	5e                   	pop    %esi
  801ddd:	5d                   	pop    %ebp
  801dde:	c3                   	ret    

00801ddf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	53                   	push   %ebx
  801de3:	83 ec 14             	sub    $0x14,%esp
  801de6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801df1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801df5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfc:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801e03:	e8 dc ec ff ff       	call   800ae4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e08:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801e0e:	b8 02 00 00 00       	mov    $0x2,%eax
  801e13:	e8 0b ff ff ff       	call   801d23 <nsipc>
}
  801e18:	83 c4 14             	add    $0x14,%esp
  801e1b:	5b                   	pop    %ebx
  801e1c:	5d                   	pop    %ebp
  801e1d:	c3                   	ret    

00801e1e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801e34:	b8 03 00 00 00       	mov    $0x3,%eax
  801e39:	e8 e5 fe ff ff       	call   801d23 <nsipc>
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <nsipc_close>:

int
nsipc_close(int s)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801e4e:	b8 04 00 00 00       	mov    $0x4,%eax
  801e53:	e8 cb fe ff ff       	call   801d23 <nsipc>
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	53                   	push   %ebx
  801e5e:	83 ec 14             	sub    $0x14,%esp
  801e61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e64:	8b 45 08             	mov    0x8(%ebp),%eax
  801e67:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e6c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e73:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e77:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801e7e:	e8 61 ec ff ff       	call   800ae4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e83:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801e89:	b8 05 00 00 00       	mov    $0x5,%eax
  801e8e:	e8 90 fe ff ff       	call   801d23 <nsipc>
}
  801e93:	83 c4 14             	add    $0x14,%esp
  801e96:	5b                   	pop    %ebx
  801e97:	5d                   	pop    %ebp
  801e98:	c3                   	ret    

00801e99 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eaa:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801eaf:	b8 06 00 00 00       	mov    $0x6,%eax
  801eb4:	e8 6a fe ff ff       	call   801d23 <nsipc>
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	56                   	push   %esi
  801ebf:	53                   	push   %ebx
  801ec0:	83 ec 10             	sub    $0x10,%esp
  801ec3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801ece:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ed4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801edc:	b8 07 00 00 00       	mov    $0x7,%eax
  801ee1:	e8 3d fe ff ff       	call   801d23 <nsipc>
  801ee6:	89 c3                	mov    %eax,%ebx
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	78 46                	js     801f32 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801eec:	39 f0                	cmp    %esi,%eax
  801eee:	7f 07                	jg     801ef7 <nsipc_recv+0x3c>
  801ef0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ef5:	7e 24                	jle    801f1b <nsipc_recv+0x60>
  801ef7:	c7 44 24 0c a7 2d 80 	movl   $0x802da7,0xc(%esp)
  801efe:	00 
  801eff:	c7 44 24 08 6f 2d 80 	movl   $0x802d6f,0x8(%esp)
  801f06:	00 
  801f07:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801f0e:	00 
  801f0f:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  801f16:	e8 0c e3 ff ff       	call   800227 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f1b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f1f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f26:	00 
  801f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2a:	89 04 24             	mov    %eax,(%esp)
  801f2d:	e8 b2 eb ff ff       	call   800ae4 <memmove>
	}

	return r;
}
  801f32:	89 d8                	mov    %ebx,%eax
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	5b                   	pop    %ebx
  801f38:	5e                   	pop    %esi
  801f39:	5d                   	pop    %ebp
  801f3a:	c3                   	ret    

00801f3b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
  801f3e:	53                   	push   %ebx
  801f3f:	83 ec 14             	sub    $0x14,%esp
  801f42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f45:	8b 45 08             	mov    0x8(%ebp),%eax
  801f48:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801f4d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f53:	7e 24                	jle    801f79 <nsipc_send+0x3e>
  801f55:	c7 44 24 0c c8 2d 80 	movl   $0x802dc8,0xc(%esp)
  801f5c:	00 
  801f5d:	c7 44 24 08 6f 2d 80 	movl   $0x802d6f,0x8(%esp)
  801f64:	00 
  801f65:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801f6c:	00 
  801f6d:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  801f74:	e8 ae e2 ff ff       	call   800227 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f79:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f84:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801f8b:	e8 54 eb ff ff       	call   800ae4 <memmove>
	nsipcbuf.send.req_size = size;
  801f90:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801f96:	8b 45 14             	mov    0x14(%ebp),%eax
  801f99:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801f9e:	b8 08 00 00 00       	mov    $0x8,%eax
  801fa3:	e8 7b fd ff ff       	call   801d23 <nsipc>
}
  801fa8:	83 c4 14             	add    $0x14,%esp
  801fab:	5b                   	pop    %ebx
  801fac:	5d                   	pop    %ebp
  801fad:	c3                   	ret    

00801fae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbf:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801fc4:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801fcc:	b8 09 00 00 00       	mov    $0x9,%eax
  801fd1:	e8 4d fd ff ff       	call   801d23 <nsipc>
}
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	56                   	push   %esi
  801fdc:	53                   	push   %ebx
  801fdd:	83 ec 10             	sub    $0x10,%esp
  801fe0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	89 04 24             	mov    %eax,(%esp)
  801fe9:	e8 d2 f0 ff ff       	call   8010c0 <fd2data>
  801fee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ff0:	c7 44 24 04 d4 2d 80 	movl   $0x802dd4,0x4(%esp)
  801ff7:	00 
  801ff8:	89 1c 24             	mov    %ebx,(%esp)
  801ffb:	e8 47 e9 ff ff       	call   800947 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802000:	8b 46 04             	mov    0x4(%esi),%eax
  802003:	2b 06                	sub    (%esi),%eax
  802005:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80200b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802012:	00 00 00 
	stat->st_dev = &devpipe;
  802015:	c7 83 88 00 00 00 40 	movl   $0x803040,0x88(%ebx)
  80201c:	30 80 00 
	return 0;
}
  80201f:	b8 00 00 00 00       	mov    $0x0,%eax
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	5b                   	pop    %ebx
  802028:	5e                   	pop    %esi
  802029:	5d                   	pop    %ebp
  80202a:	c3                   	ret    

0080202b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	53                   	push   %ebx
  80202f:	83 ec 14             	sub    $0x14,%esp
  802032:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802035:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802039:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802040:	e8 c5 ed ff ff       	call   800e0a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802045:	89 1c 24             	mov    %ebx,(%esp)
  802048:	e8 73 f0 ff ff       	call   8010c0 <fd2data>
  80204d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802051:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802058:	e8 ad ed ff ff       	call   800e0a <sys_page_unmap>
}
  80205d:	83 c4 14             	add    $0x14,%esp
  802060:	5b                   	pop    %ebx
  802061:	5d                   	pop    %ebp
  802062:	c3                   	ret    

00802063 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	57                   	push   %edi
  802067:	56                   	push   %esi
  802068:	53                   	push   %ebx
  802069:	83 ec 2c             	sub    $0x2c,%esp
  80206c:	89 c6                	mov    %eax,%esi
  80206e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802071:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802076:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802079:	89 34 24             	mov    %esi,(%esp)
  80207c:	e8 be 05 00 00       	call   80263f <pageref>
  802081:	89 c7                	mov    %eax,%edi
  802083:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802086:	89 04 24             	mov    %eax,(%esp)
  802089:	e8 b1 05 00 00       	call   80263f <pageref>
  80208e:	39 c7                	cmp    %eax,%edi
  802090:	0f 94 c2             	sete   %dl
  802093:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802096:	8b 0d 0c 40 80 00    	mov    0x80400c,%ecx
  80209c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80209f:	39 fb                	cmp    %edi,%ebx
  8020a1:	74 21                	je     8020c4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8020a3:	84 d2                	test   %dl,%dl
  8020a5:	74 ca                	je     802071 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020a7:	8b 51 58             	mov    0x58(%ecx),%edx
  8020aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020ae:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020b6:	c7 04 24 db 2d 80 00 	movl   $0x802ddb,(%esp)
  8020bd:	e8 5e e2 ff ff       	call   800320 <cprintf>
  8020c2:	eb ad                	jmp    802071 <_pipeisclosed+0xe>
	}
}
  8020c4:	83 c4 2c             	add    $0x2c,%esp
  8020c7:	5b                   	pop    %ebx
  8020c8:	5e                   	pop    %esi
  8020c9:	5f                   	pop    %edi
  8020ca:	5d                   	pop    %ebp
  8020cb:	c3                   	ret    

008020cc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8020cc:	55                   	push   %ebp
  8020cd:	89 e5                	mov    %esp,%ebp
  8020cf:	57                   	push   %edi
  8020d0:	56                   	push   %esi
  8020d1:	53                   	push   %ebx
  8020d2:	83 ec 1c             	sub    $0x1c,%esp
  8020d5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8020d8:	89 34 24             	mov    %esi,(%esp)
  8020db:	e8 e0 ef ff ff       	call   8010c0 <fd2data>
  8020e0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8020e7:	eb 45                	jmp    80212e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8020e9:	89 da                	mov    %ebx,%edx
  8020eb:	89 f0                	mov    %esi,%eax
  8020ed:	e8 71 ff ff ff       	call   802063 <_pipeisclosed>
  8020f2:	85 c0                	test   %eax,%eax
  8020f4:	75 41                	jne    802137 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8020f6:	e8 49 ec ff ff       	call   800d44 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020fb:	8b 43 04             	mov    0x4(%ebx),%eax
  8020fe:	8b 0b                	mov    (%ebx),%ecx
  802100:	8d 51 20             	lea    0x20(%ecx),%edx
  802103:	39 d0                	cmp    %edx,%eax
  802105:	73 e2                	jae    8020e9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802107:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80210a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80210e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802111:	99                   	cltd   
  802112:	c1 ea 1b             	shr    $0x1b,%edx
  802115:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802118:	83 e1 1f             	and    $0x1f,%ecx
  80211b:	29 d1                	sub    %edx,%ecx
  80211d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802121:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802125:	83 c0 01             	add    $0x1,%eax
  802128:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80212b:	83 c7 01             	add    $0x1,%edi
  80212e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802131:	75 c8                	jne    8020fb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802133:	89 f8                	mov    %edi,%eax
  802135:	eb 05                	jmp    80213c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802137:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80213c:	83 c4 1c             	add    $0x1c,%esp
  80213f:	5b                   	pop    %ebx
  802140:	5e                   	pop    %esi
  802141:	5f                   	pop    %edi
  802142:	5d                   	pop    %ebp
  802143:	c3                   	ret    

00802144 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	57                   	push   %edi
  802148:	56                   	push   %esi
  802149:	53                   	push   %ebx
  80214a:	83 ec 1c             	sub    $0x1c,%esp
  80214d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802150:	89 3c 24             	mov    %edi,(%esp)
  802153:	e8 68 ef ff ff       	call   8010c0 <fd2data>
  802158:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80215a:	be 00 00 00 00       	mov    $0x0,%esi
  80215f:	eb 3d                	jmp    80219e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802161:	85 f6                	test   %esi,%esi
  802163:	74 04                	je     802169 <devpipe_read+0x25>
				return i;
  802165:	89 f0                	mov    %esi,%eax
  802167:	eb 43                	jmp    8021ac <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802169:	89 da                	mov    %ebx,%edx
  80216b:	89 f8                	mov    %edi,%eax
  80216d:	e8 f1 fe ff ff       	call   802063 <_pipeisclosed>
  802172:	85 c0                	test   %eax,%eax
  802174:	75 31                	jne    8021a7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802176:	e8 c9 eb ff ff       	call   800d44 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80217b:	8b 03                	mov    (%ebx),%eax
  80217d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802180:	74 df                	je     802161 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802182:	99                   	cltd   
  802183:	c1 ea 1b             	shr    $0x1b,%edx
  802186:	01 d0                	add    %edx,%eax
  802188:	83 e0 1f             	and    $0x1f,%eax
  80218b:	29 d0                	sub    %edx,%eax
  80218d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802192:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802195:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802198:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80219b:	83 c6 01             	add    $0x1,%esi
  80219e:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021a1:	75 d8                	jne    80217b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8021a3:	89 f0                	mov    %esi,%eax
  8021a5:	eb 05                	jmp    8021ac <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8021a7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8021ac:	83 c4 1c             	add    $0x1c,%esp
  8021af:	5b                   	pop    %ebx
  8021b0:	5e                   	pop    %esi
  8021b1:	5f                   	pop    %edi
  8021b2:	5d                   	pop    %ebp
  8021b3:	c3                   	ret    

008021b4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	56                   	push   %esi
  8021b8:	53                   	push   %ebx
  8021b9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8021bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021bf:	89 04 24             	mov    %eax,(%esp)
  8021c2:	e8 10 ef ff ff       	call   8010d7 <fd_alloc>
  8021c7:	89 c2                	mov    %eax,%edx
  8021c9:	85 d2                	test   %edx,%edx
  8021cb:	0f 88 4d 01 00 00    	js     80231e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021d1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021d8:	00 
  8021d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021e7:	e8 77 eb ff ff       	call   800d63 <sys_page_alloc>
  8021ec:	89 c2                	mov    %eax,%edx
  8021ee:	85 d2                	test   %edx,%edx
  8021f0:	0f 88 28 01 00 00    	js     80231e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8021f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021f9:	89 04 24             	mov    %eax,(%esp)
  8021fc:	e8 d6 ee ff ff       	call   8010d7 <fd_alloc>
  802201:	89 c3                	mov    %eax,%ebx
  802203:	85 c0                	test   %eax,%eax
  802205:	0f 88 fe 00 00 00    	js     802309 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80220b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802212:	00 
  802213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802216:	89 44 24 04          	mov    %eax,0x4(%esp)
  80221a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802221:	e8 3d eb ff ff       	call   800d63 <sys_page_alloc>
  802226:	89 c3                	mov    %eax,%ebx
  802228:	85 c0                	test   %eax,%eax
  80222a:	0f 88 d9 00 00 00    	js     802309 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802233:	89 04 24             	mov    %eax,(%esp)
  802236:	e8 85 ee ff ff       	call   8010c0 <fd2data>
  80223b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80223d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802244:	00 
  802245:	89 44 24 04          	mov    %eax,0x4(%esp)
  802249:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802250:	e8 0e eb ff ff       	call   800d63 <sys_page_alloc>
  802255:	89 c3                	mov    %eax,%ebx
  802257:	85 c0                	test   %eax,%eax
  802259:	0f 88 97 00 00 00    	js     8022f6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80225f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802262:	89 04 24             	mov    %eax,(%esp)
  802265:	e8 56 ee ff ff       	call   8010c0 <fd2data>
  80226a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802271:	00 
  802272:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802276:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80227d:	00 
  80227e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802282:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802289:	e8 29 eb ff ff       	call   800db7 <sys_page_map>
  80228e:	89 c3                	mov    %eax,%ebx
  802290:	85 c0                	test   %eax,%eax
  802292:	78 52                	js     8022e6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802294:	8b 15 40 30 80 00    	mov    0x803040,%edx
  80229a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8022a9:	8b 15 40 30 80 00    	mov    0x803040,%edx
  8022af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8022b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8022be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c1:	89 04 24             	mov    %eax,(%esp)
  8022c4:	e8 e7 ed ff ff       	call   8010b0 <fd2num>
  8022c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022cc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8022ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022d1:	89 04 24             	mov    %eax,(%esp)
  8022d4:	e8 d7 ed ff ff       	call   8010b0 <fd2num>
  8022d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022dc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8022df:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e4:	eb 38                	jmp    80231e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8022e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022f1:	e8 14 eb ff ff       	call   800e0a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8022f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802304:	e8 01 eb ff ff       	call   800e0a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802309:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802310:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802317:	e8 ee ea ff ff       	call   800e0a <sys_page_unmap>
  80231c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80231e:	83 c4 30             	add    $0x30,%esp
  802321:	5b                   	pop    %ebx
  802322:	5e                   	pop    %esi
  802323:	5d                   	pop    %ebp
  802324:	c3                   	ret    

00802325 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
  802328:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80232b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80232e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	89 04 24             	mov    %eax,(%esp)
  802338:	e8 e9 ed ff ff       	call   801126 <fd_lookup>
  80233d:	89 c2                	mov    %eax,%edx
  80233f:	85 d2                	test   %edx,%edx
  802341:	78 15                	js     802358 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802346:	89 04 24             	mov    %eax,(%esp)
  802349:	e8 72 ed ff ff       	call   8010c0 <fd2data>
	return _pipeisclosed(fd, p);
  80234e:	89 c2                	mov    %eax,%edx
  802350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802353:	e8 0b fd ff ff       	call   802063 <_pipeisclosed>
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    
  80235a:	66 90                	xchg   %ax,%ax
  80235c:	66 90                	xchg   %ax,%ax
  80235e:	66 90                	xchg   %ax,%ax

00802360 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802363:	b8 00 00 00 00       	mov    $0x0,%eax
  802368:	5d                   	pop    %ebp
  802369:	c3                   	ret    

0080236a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
  80236d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802370:	c7 44 24 04 f3 2d 80 	movl   $0x802df3,0x4(%esp)
  802377:	00 
  802378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237b:	89 04 24             	mov    %eax,(%esp)
  80237e:	e8 c4 e5 ff ff       	call   800947 <strcpy>
	return 0;
}
  802383:	b8 00 00 00 00       	mov    $0x0,%eax
  802388:	c9                   	leave  
  802389:	c3                   	ret    

0080238a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80238a:	55                   	push   %ebp
  80238b:	89 e5                	mov    %esp,%ebp
  80238d:	57                   	push   %edi
  80238e:	56                   	push   %esi
  80238f:	53                   	push   %ebx
  802390:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802396:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80239b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023a1:	eb 31                	jmp    8023d4 <devcons_write+0x4a>
		m = n - tot;
  8023a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8023a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8023a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8023ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8023b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8023b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8023b7:	03 45 0c             	add    0xc(%ebp),%eax
  8023ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023be:	89 3c 24             	mov    %edi,(%esp)
  8023c1:	e8 1e e7 ff ff       	call   800ae4 <memmove>
		sys_cputs(buf, m);
  8023c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023ca:	89 3c 24             	mov    %edi,(%esp)
  8023cd:	e8 c4 e8 ff ff       	call   800c96 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023d2:	01 f3                	add    %esi,%ebx
  8023d4:	89 d8                	mov    %ebx,%eax
  8023d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8023d9:	72 c8                	jb     8023a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8023db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5f                   	pop    %edi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    

008023e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
  8023e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8023ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8023f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023f5:	75 07                	jne    8023fe <devcons_read+0x18>
  8023f7:	eb 2a                	jmp    802423 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8023f9:	e8 46 e9 ff ff       	call   800d44 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8023fe:	66 90                	xchg   %ax,%ax
  802400:	e8 af e8 ff ff       	call   800cb4 <sys_cgetc>
  802405:	85 c0                	test   %eax,%eax
  802407:	74 f0                	je     8023f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802409:	85 c0                	test   %eax,%eax
  80240b:	78 16                	js     802423 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80240d:	83 f8 04             	cmp    $0x4,%eax
  802410:	74 0c                	je     80241e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802412:	8b 55 0c             	mov    0xc(%ebp),%edx
  802415:	88 02                	mov    %al,(%edx)
	return 1;
  802417:	b8 01 00 00 00       	mov    $0x1,%eax
  80241c:	eb 05                	jmp    802423 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80241e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802423:	c9                   	leave  
  802424:	c3                   	ret    

00802425 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802425:	55                   	push   %ebp
  802426:	89 e5                	mov    %esp,%ebp
  802428:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802431:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802438:	00 
  802439:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80243c:	89 04 24             	mov    %eax,(%esp)
  80243f:	e8 52 e8 ff ff       	call   800c96 <sys_cputs>
}
  802444:	c9                   	leave  
  802445:	c3                   	ret    

00802446 <getchar>:

int
getchar(void)
{
  802446:	55                   	push   %ebp
  802447:	89 e5                	mov    %esp,%ebp
  802449:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80244c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802453:	00 
  802454:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802457:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802462:	e8 53 ef ff ff       	call   8013ba <read>
	if (r < 0)
  802467:	85 c0                	test   %eax,%eax
  802469:	78 0f                	js     80247a <getchar+0x34>
		return r;
	if (r < 1)
  80246b:	85 c0                	test   %eax,%eax
  80246d:	7e 06                	jle    802475 <getchar+0x2f>
		return -E_EOF;
	return c;
  80246f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802473:	eb 05                	jmp    80247a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802475:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
  80247f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802482:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802485:	89 44 24 04          	mov    %eax,0x4(%esp)
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	89 04 24             	mov    %eax,(%esp)
  80248f:	e8 92 ec ff ff       	call   801126 <fd_lookup>
  802494:	85 c0                	test   %eax,%eax
  802496:	78 11                	js     8024a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8024a1:	39 10                	cmp    %edx,(%eax)
  8024a3:	0f 94 c0             	sete   %al
  8024a6:	0f b6 c0             	movzbl %al,%eax
}
  8024a9:	c9                   	leave  
  8024aa:	c3                   	ret    

008024ab <opencons>:

int
opencons(void)
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
  8024ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024b4:	89 04 24             	mov    %eax,(%esp)
  8024b7:	e8 1b ec ff ff       	call   8010d7 <fd_alloc>
		return r;
  8024bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024be:	85 c0                	test   %eax,%eax
  8024c0:	78 40                	js     802502 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8024c9:	00 
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d8:	e8 86 e8 ff ff       	call   800d63 <sys_page_alloc>
		return r;
  8024dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	78 1f                	js     802502 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8024e3:	8b 15 5c 30 80 00    	mov    0x80305c,%edx
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8024f8:	89 04 24             	mov    %eax,(%esp)
  8024fb:	e8 b0 eb ff ff       	call   8010b0 <fd2num>
  802500:	89 c2                	mov    %eax,%edx
}
  802502:	89 d0                	mov    %edx,%eax
  802504:	c9                   	leave  
  802505:	c3                   	ret    
  802506:	66 90                	xchg   %ax,%ax
  802508:	66 90                	xchg   %ax,%ax
  80250a:	66 90                	xchg   %ax,%ax
  80250c:	66 90                	xchg   %ax,%ax
  80250e:	66 90                	xchg   %ax,%ax

00802510 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	56                   	push   %esi
  802514:	53                   	push   %ebx
  802515:	83 ec 10             	sub    $0x10,%esp
  802518:	8b 75 08             	mov    0x8(%ebp),%esi
  80251b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802521:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802523:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802528:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80252b:	89 04 24             	mov    %eax,(%esp)
  80252e:	e8 46 ea ff ff       	call   800f79 <sys_ipc_recv>
  802533:	85 c0                	test   %eax,%eax
  802535:	74 16                	je     80254d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802537:	85 f6                	test   %esi,%esi
  802539:	74 06                	je     802541 <ipc_recv+0x31>
			*from_env_store = 0;
  80253b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802541:	85 db                	test   %ebx,%ebx
  802543:	74 2c                	je     802571 <ipc_recv+0x61>
			*perm_store = 0;
  802545:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80254b:	eb 24                	jmp    802571 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80254d:	85 f6                	test   %esi,%esi
  80254f:	74 0a                	je     80255b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802551:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802556:	8b 40 74             	mov    0x74(%eax),%eax
  802559:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80255b:	85 db                	test   %ebx,%ebx
  80255d:	74 0a                	je     802569 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80255f:	a1 0c 40 80 00       	mov    0x80400c,%eax
  802564:	8b 40 78             	mov    0x78(%eax),%eax
  802567:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802569:	a1 0c 40 80 00       	mov    0x80400c,%eax
  80256e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802571:	83 c4 10             	add    $0x10,%esp
  802574:	5b                   	pop    %ebx
  802575:	5e                   	pop    %esi
  802576:	5d                   	pop    %ebp
  802577:	c3                   	ret    

00802578 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
  80257b:	57                   	push   %edi
  80257c:	56                   	push   %esi
  80257d:	53                   	push   %ebx
  80257e:	83 ec 1c             	sub    $0x1c,%esp
  802581:	8b 75 0c             	mov    0xc(%ebp),%esi
  802584:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802587:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80258a:	85 db                	test   %ebx,%ebx
  80258c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802591:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802594:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802598:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80259c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a3:	89 04 24             	mov    %eax,(%esp)
  8025a6:	e8 ab e9 ff ff       	call   800f56 <sys_ipc_try_send>
	if (r == 0) return;
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	75 22                	jne    8025d1 <ipc_send+0x59>
  8025af:	eb 4c                	jmp    8025fd <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  8025b1:	84 d2                	test   %dl,%dl
  8025b3:	75 48                	jne    8025fd <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  8025b5:	e8 8a e7 ff ff       	call   800d44 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  8025ba:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025be:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c9:	89 04 24             	mov    %eax,(%esp)
  8025cc:	e8 85 e9 ff ff       	call   800f56 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  8025d1:	85 c0                	test   %eax,%eax
  8025d3:	0f 94 c2             	sete   %dl
  8025d6:	74 d9                	je     8025b1 <ipc_send+0x39>
  8025d8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8025db:	74 d4                	je     8025b1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  8025dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025e1:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  8025e8:	00 
  8025e9:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  8025f0:	00 
  8025f1:	c7 04 24 0d 2e 80 00 	movl   $0x802e0d,(%esp)
  8025f8:	e8 2a dc ff ff       	call   800227 <_panic>
}
  8025fd:	83 c4 1c             	add    $0x1c,%esp
  802600:	5b                   	pop    %ebx
  802601:	5e                   	pop    %esi
  802602:	5f                   	pop    %edi
  802603:	5d                   	pop    %ebp
  802604:	c3                   	ret    

00802605 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
  802608:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80260b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802610:	89 c2                	mov    %eax,%edx
  802612:	c1 e2 07             	shl    $0x7,%edx
  802615:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80261b:	8b 52 50             	mov    0x50(%edx),%edx
  80261e:	39 ca                	cmp    %ecx,%edx
  802620:	75 0d                	jne    80262f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802622:	c1 e0 07             	shl    $0x7,%eax
  802625:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80262a:	8b 40 40             	mov    0x40(%eax),%eax
  80262d:	eb 0e                	jmp    80263d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80262f:	83 c0 01             	add    $0x1,%eax
  802632:	3d 00 04 00 00       	cmp    $0x400,%eax
  802637:	75 d7                	jne    802610 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802639:	66 b8 00 00          	mov    $0x0,%ax
}
  80263d:	5d                   	pop    %ebp
  80263e:	c3                   	ret    

0080263f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
  802642:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802645:	89 d0                	mov    %edx,%eax
  802647:	c1 e8 16             	shr    $0x16,%eax
  80264a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802651:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802656:	f6 c1 01             	test   $0x1,%cl
  802659:	74 1d                	je     802678 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80265b:	c1 ea 0c             	shr    $0xc,%edx
  80265e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802665:	f6 c2 01             	test   $0x1,%dl
  802668:	74 0e                	je     802678 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80266a:	c1 ea 0c             	shr    $0xc,%edx
  80266d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802674:	ef 
  802675:	0f b7 c0             	movzwl %ax,%eax
}
  802678:	5d                   	pop    %ebp
  802679:	c3                   	ret    
  80267a:	66 90                	xchg   %ax,%ax
  80267c:	66 90                	xchg   %ax,%ax
  80267e:	66 90                	xchg   %ax,%ax

00802680 <__udivdi3>:
  802680:	55                   	push   %ebp
  802681:	57                   	push   %edi
  802682:	56                   	push   %esi
  802683:	83 ec 0c             	sub    $0xc,%esp
  802686:	8b 44 24 28          	mov    0x28(%esp),%eax
  80268a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80268e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802692:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802696:	85 c0                	test   %eax,%eax
  802698:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80269c:	89 ea                	mov    %ebp,%edx
  80269e:	89 0c 24             	mov    %ecx,(%esp)
  8026a1:	75 2d                	jne    8026d0 <__udivdi3+0x50>
  8026a3:	39 e9                	cmp    %ebp,%ecx
  8026a5:	77 61                	ja     802708 <__udivdi3+0x88>
  8026a7:	85 c9                	test   %ecx,%ecx
  8026a9:	89 ce                	mov    %ecx,%esi
  8026ab:	75 0b                	jne    8026b8 <__udivdi3+0x38>
  8026ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8026b2:	31 d2                	xor    %edx,%edx
  8026b4:	f7 f1                	div    %ecx
  8026b6:	89 c6                	mov    %eax,%esi
  8026b8:	31 d2                	xor    %edx,%edx
  8026ba:	89 e8                	mov    %ebp,%eax
  8026bc:	f7 f6                	div    %esi
  8026be:	89 c5                	mov    %eax,%ebp
  8026c0:	89 f8                	mov    %edi,%eax
  8026c2:	f7 f6                	div    %esi
  8026c4:	89 ea                	mov    %ebp,%edx
  8026c6:	83 c4 0c             	add    $0xc,%esp
  8026c9:	5e                   	pop    %esi
  8026ca:	5f                   	pop    %edi
  8026cb:	5d                   	pop    %ebp
  8026cc:	c3                   	ret    
  8026cd:	8d 76 00             	lea    0x0(%esi),%esi
  8026d0:	39 e8                	cmp    %ebp,%eax
  8026d2:	77 24                	ja     8026f8 <__udivdi3+0x78>
  8026d4:	0f bd e8             	bsr    %eax,%ebp
  8026d7:	83 f5 1f             	xor    $0x1f,%ebp
  8026da:	75 3c                	jne    802718 <__udivdi3+0x98>
  8026dc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8026e0:	39 34 24             	cmp    %esi,(%esp)
  8026e3:	0f 86 9f 00 00 00    	jbe    802788 <__udivdi3+0x108>
  8026e9:	39 d0                	cmp    %edx,%eax
  8026eb:	0f 82 97 00 00 00    	jb     802788 <__udivdi3+0x108>
  8026f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8026f8:	31 d2                	xor    %edx,%edx
  8026fa:	31 c0                	xor    %eax,%eax
  8026fc:	83 c4 0c             	add    $0xc,%esp
  8026ff:	5e                   	pop    %esi
  802700:	5f                   	pop    %edi
  802701:	5d                   	pop    %ebp
  802702:	c3                   	ret    
  802703:	90                   	nop
  802704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802708:	89 f8                	mov    %edi,%eax
  80270a:	f7 f1                	div    %ecx
  80270c:	31 d2                	xor    %edx,%edx
  80270e:	83 c4 0c             	add    $0xc,%esp
  802711:	5e                   	pop    %esi
  802712:	5f                   	pop    %edi
  802713:	5d                   	pop    %ebp
  802714:	c3                   	ret    
  802715:	8d 76 00             	lea    0x0(%esi),%esi
  802718:	89 e9                	mov    %ebp,%ecx
  80271a:	8b 3c 24             	mov    (%esp),%edi
  80271d:	d3 e0                	shl    %cl,%eax
  80271f:	89 c6                	mov    %eax,%esi
  802721:	b8 20 00 00 00       	mov    $0x20,%eax
  802726:	29 e8                	sub    %ebp,%eax
  802728:	89 c1                	mov    %eax,%ecx
  80272a:	d3 ef                	shr    %cl,%edi
  80272c:	89 e9                	mov    %ebp,%ecx
  80272e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802732:	8b 3c 24             	mov    (%esp),%edi
  802735:	09 74 24 08          	or     %esi,0x8(%esp)
  802739:	89 d6                	mov    %edx,%esi
  80273b:	d3 e7                	shl    %cl,%edi
  80273d:	89 c1                	mov    %eax,%ecx
  80273f:	89 3c 24             	mov    %edi,(%esp)
  802742:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802746:	d3 ee                	shr    %cl,%esi
  802748:	89 e9                	mov    %ebp,%ecx
  80274a:	d3 e2                	shl    %cl,%edx
  80274c:	89 c1                	mov    %eax,%ecx
  80274e:	d3 ef                	shr    %cl,%edi
  802750:	09 d7                	or     %edx,%edi
  802752:	89 f2                	mov    %esi,%edx
  802754:	89 f8                	mov    %edi,%eax
  802756:	f7 74 24 08          	divl   0x8(%esp)
  80275a:	89 d6                	mov    %edx,%esi
  80275c:	89 c7                	mov    %eax,%edi
  80275e:	f7 24 24             	mull   (%esp)
  802761:	39 d6                	cmp    %edx,%esi
  802763:	89 14 24             	mov    %edx,(%esp)
  802766:	72 30                	jb     802798 <__udivdi3+0x118>
  802768:	8b 54 24 04          	mov    0x4(%esp),%edx
  80276c:	89 e9                	mov    %ebp,%ecx
  80276e:	d3 e2                	shl    %cl,%edx
  802770:	39 c2                	cmp    %eax,%edx
  802772:	73 05                	jae    802779 <__udivdi3+0xf9>
  802774:	3b 34 24             	cmp    (%esp),%esi
  802777:	74 1f                	je     802798 <__udivdi3+0x118>
  802779:	89 f8                	mov    %edi,%eax
  80277b:	31 d2                	xor    %edx,%edx
  80277d:	e9 7a ff ff ff       	jmp    8026fc <__udivdi3+0x7c>
  802782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802788:	31 d2                	xor    %edx,%edx
  80278a:	b8 01 00 00 00       	mov    $0x1,%eax
  80278f:	e9 68 ff ff ff       	jmp    8026fc <__udivdi3+0x7c>
  802794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802798:	8d 47 ff             	lea    -0x1(%edi),%eax
  80279b:	31 d2                	xor    %edx,%edx
  80279d:	83 c4 0c             	add    $0xc,%esp
  8027a0:	5e                   	pop    %esi
  8027a1:	5f                   	pop    %edi
  8027a2:	5d                   	pop    %ebp
  8027a3:	c3                   	ret    
  8027a4:	66 90                	xchg   %ax,%ax
  8027a6:	66 90                	xchg   %ax,%ax
  8027a8:	66 90                	xchg   %ax,%ax
  8027aa:	66 90                	xchg   %ax,%ax
  8027ac:	66 90                	xchg   %ax,%ax
  8027ae:	66 90                	xchg   %ax,%ax

008027b0 <__umoddi3>:
  8027b0:	55                   	push   %ebp
  8027b1:	57                   	push   %edi
  8027b2:	56                   	push   %esi
  8027b3:	83 ec 14             	sub    $0x14,%esp
  8027b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8027ba:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8027be:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8027c2:	89 c7                	mov    %eax,%edi
  8027c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8027cc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8027d0:	89 34 24             	mov    %esi,(%esp)
  8027d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	89 c2                	mov    %eax,%edx
  8027db:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027df:	75 17                	jne    8027f8 <__umoddi3+0x48>
  8027e1:	39 fe                	cmp    %edi,%esi
  8027e3:	76 4b                	jbe    802830 <__umoddi3+0x80>
  8027e5:	89 c8                	mov    %ecx,%eax
  8027e7:	89 fa                	mov    %edi,%edx
  8027e9:	f7 f6                	div    %esi
  8027eb:	89 d0                	mov    %edx,%eax
  8027ed:	31 d2                	xor    %edx,%edx
  8027ef:	83 c4 14             	add    $0x14,%esp
  8027f2:	5e                   	pop    %esi
  8027f3:	5f                   	pop    %edi
  8027f4:	5d                   	pop    %ebp
  8027f5:	c3                   	ret    
  8027f6:	66 90                	xchg   %ax,%ax
  8027f8:	39 f8                	cmp    %edi,%eax
  8027fa:	77 54                	ja     802850 <__umoddi3+0xa0>
  8027fc:	0f bd e8             	bsr    %eax,%ebp
  8027ff:	83 f5 1f             	xor    $0x1f,%ebp
  802802:	75 5c                	jne    802860 <__umoddi3+0xb0>
  802804:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802808:	39 3c 24             	cmp    %edi,(%esp)
  80280b:	0f 87 e7 00 00 00    	ja     8028f8 <__umoddi3+0x148>
  802811:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802815:	29 f1                	sub    %esi,%ecx
  802817:	19 c7                	sbb    %eax,%edi
  802819:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80281d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802821:	8b 44 24 08          	mov    0x8(%esp),%eax
  802825:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802829:	83 c4 14             	add    $0x14,%esp
  80282c:	5e                   	pop    %esi
  80282d:	5f                   	pop    %edi
  80282e:	5d                   	pop    %ebp
  80282f:	c3                   	ret    
  802830:	85 f6                	test   %esi,%esi
  802832:	89 f5                	mov    %esi,%ebp
  802834:	75 0b                	jne    802841 <__umoddi3+0x91>
  802836:	b8 01 00 00 00       	mov    $0x1,%eax
  80283b:	31 d2                	xor    %edx,%edx
  80283d:	f7 f6                	div    %esi
  80283f:	89 c5                	mov    %eax,%ebp
  802841:	8b 44 24 04          	mov    0x4(%esp),%eax
  802845:	31 d2                	xor    %edx,%edx
  802847:	f7 f5                	div    %ebp
  802849:	89 c8                	mov    %ecx,%eax
  80284b:	f7 f5                	div    %ebp
  80284d:	eb 9c                	jmp    8027eb <__umoddi3+0x3b>
  80284f:	90                   	nop
  802850:	89 c8                	mov    %ecx,%eax
  802852:	89 fa                	mov    %edi,%edx
  802854:	83 c4 14             	add    $0x14,%esp
  802857:	5e                   	pop    %esi
  802858:	5f                   	pop    %edi
  802859:	5d                   	pop    %ebp
  80285a:	c3                   	ret    
  80285b:	90                   	nop
  80285c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802860:	8b 04 24             	mov    (%esp),%eax
  802863:	be 20 00 00 00       	mov    $0x20,%esi
  802868:	89 e9                	mov    %ebp,%ecx
  80286a:	29 ee                	sub    %ebp,%esi
  80286c:	d3 e2                	shl    %cl,%edx
  80286e:	89 f1                	mov    %esi,%ecx
  802870:	d3 e8                	shr    %cl,%eax
  802872:	89 e9                	mov    %ebp,%ecx
  802874:	89 44 24 04          	mov    %eax,0x4(%esp)
  802878:	8b 04 24             	mov    (%esp),%eax
  80287b:	09 54 24 04          	or     %edx,0x4(%esp)
  80287f:	89 fa                	mov    %edi,%edx
  802881:	d3 e0                	shl    %cl,%eax
  802883:	89 f1                	mov    %esi,%ecx
  802885:	89 44 24 08          	mov    %eax,0x8(%esp)
  802889:	8b 44 24 10          	mov    0x10(%esp),%eax
  80288d:	d3 ea                	shr    %cl,%edx
  80288f:	89 e9                	mov    %ebp,%ecx
  802891:	d3 e7                	shl    %cl,%edi
  802893:	89 f1                	mov    %esi,%ecx
  802895:	d3 e8                	shr    %cl,%eax
  802897:	89 e9                	mov    %ebp,%ecx
  802899:	09 f8                	or     %edi,%eax
  80289b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80289f:	f7 74 24 04          	divl   0x4(%esp)
  8028a3:	d3 e7                	shl    %cl,%edi
  8028a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028a9:	89 d7                	mov    %edx,%edi
  8028ab:	f7 64 24 08          	mull   0x8(%esp)
  8028af:	39 d7                	cmp    %edx,%edi
  8028b1:	89 c1                	mov    %eax,%ecx
  8028b3:	89 14 24             	mov    %edx,(%esp)
  8028b6:	72 2c                	jb     8028e4 <__umoddi3+0x134>
  8028b8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8028bc:	72 22                	jb     8028e0 <__umoddi3+0x130>
  8028be:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8028c2:	29 c8                	sub    %ecx,%eax
  8028c4:	19 d7                	sbb    %edx,%edi
  8028c6:	89 e9                	mov    %ebp,%ecx
  8028c8:	89 fa                	mov    %edi,%edx
  8028ca:	d3 e8                	shr    %cl,%eax
  8028cc:	89 f1                	mov    %esi,%ecx
  8028ce:	d3 e2                	shl    %cl,%edx
  8028d0:	89 e9                	mov    %ebp,%ecx
  8028d2:	d3 ef                	shr    %cl,%edi
  8028d4:	09 d0                	or     %edx,%eax
  8028d6:	89 fa                	mov    %edi,%edx
  8028d8:	83 c4 14             	add    $0x14,%esp
  8028db:	5e                   	pop    %esi
  8028dc:	5f                   	pop    %edi
  8028dd:	5d                   	pop    %ebp
  8028de:	c3                   	ret    
  8028df:	90                   	nop
  8028e0:	39 d7                	cmp    %edx,%edi
  8028e2:	75 da                	jne    8028be <__umoddi3+0x10e>
  8028e4:	8b 14 24             	mov    (%esp),%edx
  8028e7:	89 c1                	mov    %eax,%ecx
  8028e9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8028ed:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8028f1:	eb cb                	jmp    8028be <__umoddi3+0x10e>
  8028f3:	90                   	nop
  8028f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8028fc:	0f 82 0f ff ff ff    	jb     802811 <__umoddi3+0x61>
  802902:	e9 1a ff ff ff       	jmp    802821 <__umoddi3+0x71>
