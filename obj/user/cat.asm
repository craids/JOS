
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 34 01 00 00       	call   800165 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 20             	sub    $0x20,%esp
  80003b:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003e:	eb 43                	jmp    800083 <cat+0x50>
		if ((r = write(1, buf, n)) != n)
  800040:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800044:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  80004b:	00 
  80004c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800053:	e8 df 13 00 00       	call   801437 <write>
  800058:	39 d8                	cmp    %ebx,%eax
  80005a:	74 27                	je     800083 <cat+0x50>
			panic("write error copying %s: %e", s, r);
  80005c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800060:	8b 45 0c             	mov    0xc(%ebp),%eax
  800063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800067:	c7 44 24 08 c0 28 80 	movl   $0x8028c0,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 db 28 80 00 	movl   $0x8028db,(%esp)
  80007e:	e8 43 01 00 00       	call   8001c6 <_panic>
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800083:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
  80008a:	00 
  80008b:	c7 44 24 04 20 40 80 	movl   $0x804020,0x4(%esp)
  800092:	00 
  800093:	89 34 24             	mov    %esi,(%esp)
  800096:	e8 bf 12 00 00       	call   80135a <read>
  80009b:	89 c3                	mov    %eax,%ebx
  80009d:	85 c0                	test   %eax,%eax
  80009f:	7f 9f                	jg     800040 <cat+0xd>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	79 27                	jns    8000cc <cat+0x99>
		panic("error reading %s: %e", s, n);
  8000a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b0:	c7 44 24 08 e6 28 80 	movl   $0x8028e6,0x8(%esp)
  8000b7:	00 
  8000b8:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000bf:	00 
  8000c0:	c7 04 24 db 28 80 00 	movl   $0x8028db,(%esp)
  8000c7:	e8 fa 00 00 00       	call   8001c6 <_panic>
}
  8000cc:	83 c4 20             	add    $0x20,%esp
  8000cf:	5b                   	pop    %ebx
  8000d0:	5e                   	pop    %esi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    

008000d3 <umain>:

void
umain(int argc, char **argv)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	57                   	push   %edi
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 1c             	sub    $0x1c,%esp
  8000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000df:	c7 05 00 30 80 00 fb 	movl   $0x8028fb,0x803000
  8000e6:	28 80 00 
	if (argc == 1)
  8000e9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ed:	74 07                	je     8000f6 <umain+0x23>
  8000ef:	bb 01 00 00 00       	mov    $0x1,%ebx
  8000f4:	eb 62                	jmp    800158 <umain+0x85>
		cat(0, "<stdin>");
  8000f6:	c7 44 24 04 ff 28 80 	movl   $0x8028ff,0x4(%esp)
  8000fd:	00 
  8000fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800105:	e8 29 ff ff ff       	call   800033 <cat>
  80010a:	eb 51                	jmp    80015d <umain+0x8a>
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  80010c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800113:	00 
  800114:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800117:	89 04 24             	mov    %eax,(%esp)
  80011a:	e8 70 17 00 00       	call   80188f <open>
  80011f:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800121:	85 c0                	test   %eax,%eax
  800123:	79 19                	jns    80013e <umain+0x6b>
				printf("can't open %s: %e\n", argv[i], f);
  800125:	89 44 24 08          	mov    %eax,0x8(%esp)
  800129:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800130:	c7 04 24 07 29 80 00 	movl   $0x802907,(%esp)
  800137:	e8 03 19 00 00       	call   801a3f <printf>
  80013c:	eb 17                	jmp    800155 <umain+0x82>
			else {
				cat(f, argv[i]);
  80013e:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800141:	89 44 24 04          	mov    %eax,0x4(%esp)
  800145:	89 34 24             	mov    %esi,(%esp)
  800148:	e8 e6 fe ff ff       	call   800033 <cat>
				close(f);
  80014d:	89 34 24             	mov    %esi,(%esp)
  800150:	e8 a2 10 00 00       	call   8011f7 <close>

	binaryname = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800155:	83 c3 01             	add    $0x1,%ebx
  800158:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  80015b:	7c af                	jl     80010c <umain+0x39>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  80015d:	83 c4 1c             	add    $0x1c,%esp
  800160:	5b                   	pop    %ebx
  800161:	5e                   	pop    %esi
  800162:	5f                   	pop    %edi
  800163:	5d                   	pop    %ebp
  800164:	c3                   	ret    

00800165 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800165:	55                   	push   %ebp
  800166:	89 e5                	mov    %esp,%ebp
  800168:	56                   	push   %esi
  800169:	53                   	push   %ebx
  80016a:	83 ec 10             	sub    $0x10,%esp
  80016d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800170:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800173:	e8 4d 0b 00 00       	call   800cc5 <sys_getenvid>
  800178:	25 ff 03 00 00       	and    $0x3ff,%eax
  80017d:	c1 e0 07             	shl    $0x7,%eax
  800180:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800185:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018a:	85 db                	test   %ebx,%ebx
  80018c:	7e 07                	jle    800195 <libmain+0x30>
		binaryname = argv[0];
  80018e:	8b 06                	mov    (%esi),%eax
  800190:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800195:	89 74 24 04          	mov    %esi,0x4(%esp)
  800199:	89 1c 24             	mov    %ebx,(%esp)
  80019c:	e8 32 ff ff ff       	call   8000d3 <umain>

	// exit gracefully
	exit();
  8001a1:	e8 07 00 00 00       	call   8001ad <exit>
}
  8001a6:	83 c4 10             	add    $0x10,%esp
  8001a9:	5b                   	pop    %ebx
  8001aa:	5e                   	pop    %esi
  8001ab:	5d                   	pop    %ebp
  8001ac:	c3                   	ret    

008001ad <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001b3:	e8 72 10 00 00       	call   80122a <close_all>
	sys_env_destroy(0);
  8001b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001bf:	e8 af 0a 00 00       	call   800c73 <sys_env_destroy>
}
  8001c4:	c9                   	leave  
  8001c5:	c3                   	ret    

008001c6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001c6:	55                   	push   %ebp
  8001c7:	89 e5                	mov    %esp,%ebp
  8001c9:	56                   	push   %esi
  8001ca:	53                   	push   %ebx
  8001cb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001ce:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001d1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8001d7:	e8 e9 0a 00 00       	call   800cc5 <sys_getenvid>
  8001dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001df:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001ea:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f2:	c7 04 24 24 29 80 00 	movl   $0x802924,(%esp)
  8001f9:	e8 c1 00 00 00       	call   8002bf <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800202:	8b 45 10             	mov    0x10(%ebp),%eax
  800205:	89 04 24             	mov    %eax,(%esp)
  800208:	e8 51 00 00 00       	call   80025e <vcprintf>
	cprintf("\n");
  80020d:	c7 04 24 8c 2d 80 00 	movl   $0x802d8c,(%esp)
  800214:	e8 a6 00 00 00       	call   8002bf <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800219:	cc                   	int3   
  80021a:	eb fd                	jmp    800219 <_panic+0x53>

0080021c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80021c:	55                   	push   %ebp
  80021d:	89 e5                	mov    %esp,%ebp
  80021f:	53                   	push   %ebx
  800220:	83 ec 14             	sub    $0x14,%esp
  800223:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800226:	8b 13                	mov    (%ebx),%edx
  800228:	8d 42 01             	lea    0x1(%edx),%eax
  80022b:	89 03                	mov    %eax,(%ebx)
  80022d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800230:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800234:	3d ff 00 00 00       	cmp    $0xff,%eax
  800239:	75 19                	jne    800254 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80023b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800242:	00 
  800243:	8d 43 08             	lea    0x8(%ebx),%eax
  800246:	89 04 24             	mov    %eax,(%esp)
  800249:	e8 e8 09 00 00       	call   800c36 <sys_cputs>
		b->idx = 0;
  80024e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800254:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800258:	83 c4 14             	add    $0x14,%esp
  80025b:	5b                   	pop    %ebx
  80025c:	5d                   	pop    %ebp
  80025d:	c3                   	ret    

0080025e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800267:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80026e:	00 00 00 
	b.cnt = 0;
  800271:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800278:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80027b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800282:	8b 45 08             	mov    0x8(%ebp),%eax
  800285:	89 44 24 08          	mov    %eax,0x8(%esp)
  800289:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80028f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800293:	c7 04 24 1c 02 80 00 	movl   $0x80021c,(%esp)
  80029a:	e8 af 01 00 00       	call   80044e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80029f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002af:	89 04 24             	mov    %eax,(%esp)
  8002b2:	e8 7f 09 00 00       	call   800c36 <sys_cputs>

	return b.cnt;
}
  8002b7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002bd:	c9                   	leave  
  8002be:	c3                   	ret    

008002bf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002c5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cf:	89 04 24             	mov    %eax,(%esp)
  8002d2:	e8 87 ff ff ff       	call   80025e <vcprintf>
	va_end(ap);

	return cnt;
}
  8002d7:	c9                   	leave  
  8002d8:	c3                   	ret    
  8002d9:	66 90                	xchg   %ax,%ax
  8002db:	66 90                	xchg   %ax,%ax
  8002dd:	66 90                	xchg   %ax,%ax
  8002df:	90                   	nop

008002e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	57                   	push   %edi
  8002e4:	56                   	push   %esi
  8002e5:	53                   	push   %ebx
  8002e6:	83 ec 3c             	sub    $0x3c,%esp
  8002e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ec:	89 d7                	mov    %edx,%edi
  8002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f7:	89 c3                	mov    %eax,%ebx
  8002f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ff:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800302:	b9 00 00 00 00       	mov    $0x0,%ecx
  800307:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80030a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80030d:	39 d9                	cmp    %ebx,%ecx
  80030f:	72 05                	jb     800316 <printnum+0x36>
  800311:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800314:	77 69                	ja     80037f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800316:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800319:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80031d:	83 ee 01             	sub    $0x1,%esi
  800320:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800324:	89 44 24 08          	mov    %eax,0x8(%esp)
  800328:	8b 44 24 08          	mov    0x8(%esp),%eax
  80032c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800330:	89 c3                	mov    %eax,%ebx
  800332:	89 d6                	mov    %edx,%esi
  800334:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800337:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80033a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80033e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800342:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800345:	89 04 24             	mov    %eax,(%esp)
  800348:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034f:	e8 cc 22 00 00       	call   802620 <__udivdi3>
  800354:	89 d9                	mov    %ebx,%ecx
  800356:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80035a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80035e:	89 04 24             	mov    %eax,(%esp)
  800361:	89 54 24 04          	mov    %edx,0x4(%esp)
  800365:	89 fa                	mov    %edi,%edx
  800367:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80036a:	e8 71 ff ff ff       	call   8002e0 <printnum>
  80036f:	eb 1b                	jmp    80038c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800371:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800375:	8b 45 18             	mov    0x18(%ebp),%eax
  800378:	89 04 24             	mov    %eax,(%esp)
  80037b:	ff d3                	call   *%ebx
  80037d:	eb 03                	jmp    800382 <printnum+0xa2>
  80037f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800382:	83 ee 01             	sub    $0x1,%esi
  800385:	85 f6                	test   %esi,%esi
  800387:	7f e8                	jg     800371 <printnum+0x91>
  800389:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80038c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800390:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800394:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800397:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80039a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80039e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a5:	89 04 24             	mov    %eax,(%esp)
  8003a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003af:	e8 9c 23 00 00       	call   802750 <__umoddi3>
  8003b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003b8:	0f be 80 47 29 80 00 	movsbl 0x802947(%eax),%eax
  8003bf:	89 04 24             	mov    %eax,(%esp)
  8003c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003c5:	ff d0                	call   *%eax
}
  8003c7:	83 c4 3c             	add    $0x3c,%esp
  8003ca:	5b                   	pop    %ebx
  8003cb:	5e                   	pop    %esi
  8003cc:	5f                   	pop    %edi
  8003cd:	5d                   	pop    %ebp
  8003ce:	c3                   	ret    

008003cf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003cf:	55                   	push   %ebp
  8003d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d2:	83 fa 01             	cmp    $0x1,%edx
  8003d5:	7e 0e                	jle    8003e5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003d7:	8b 10                	mov    (%eax),%edx
  8003d9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003dc:	89 08                	mov    %ecx,(%eax)
  8003de:	8b 02                	mov    (%edx),%eax
  8003e0:	8b 52 04             	mov    0x4(%edx),%edx
  8003e3:	eb 22                	jmp    800407 <getuint+0x38>
	else if (lflag)
  8003e5:	85 d2                	test   %edx,%edx
  8003e7:	74 10                	je     8003f9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ee:	89 08                	mov    %ecx,(%eax)
  8003f0:	8b 02                	mov    (%edx),%eax
  8003f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f7:	eb 0e                	jmp    800407 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003f9:	8b 10                	mov    (%eax),%edx
  8003fb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003fe:	89 08                	mov    %ecx,(%eax)
  800400:	8b 02                	mov    (%edx),%eax
  800402:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800407:	5d                   	pop    %ebp
  800408:	c3                   	ret    

00800409 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80040f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800413:	8b 10                	mov    (%eax),%edx
  800415:	3b 50 04             	cmp    0x4(%eax),%edx
  800418:	73 0a                	jae    800424 <sprintputch+0x1b>
		*b->buf++ = ch;
  80041a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80041d:	89 08                	mov    %ecx,(%eax)
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
  800422:	88 02                	mov    %al,(%edx)
}
  800424:	5d                   	pop    %ebp
  800425:	c3                   	ret    

00800426 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80042c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80042f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800433:	8b 45 10             	mov    0x10(%ebp),%eax
  800436:	89 44 24 08          	mov    %eax,0x8(%esp)
  80043a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	89 04 24             	mov    %eax,(%esp)
  800447:	e8 02 00 00 00       	call   80044e <vprintfmt>
	va_end(ap);
}
  80044c:	c9                   	leave  
  80044d:	c3                   	ret    

0080044e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
  800451:	57                   	push   %edi
  800452:	56                   	push   %esi
  800453:	53                   	push   %ebx
  800454:	83 ec 3c             	sub    $0x3c,%esp
  800457:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80045a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80045d:	eb 14                	jmp    800473 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80045f:	85 c0                	test   %eax,%eax
  800461:	0f 84 b3 03 00 00    	je     80081a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800467:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80046b:	89 04 24             	mov    %eax,(%esp)
  80046e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800471:	89 f3                	mov    %esi,%ebx
  800473:	8d 73 01             	lea    0x1(%ebx),%esi
  800476:	0f b6 03             	movzbl (%ebx),%eax
  800479:	83 f8 25             	cmp    $0x25,%eax
  80047c:	75 e1                	jne    80045f <vprintfmt+0x11>
  80047e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800482:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800489:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800490:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800497:	ba 00 00 00 00       	mov    $0x0,%edx
  80049c:	eb 1d                	jmp    8004bb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004a0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8004a4:	eb 15                	jmp    8004bb <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004a8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8004ac:	eb 0d                	jmp    8004bb <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004bb:	8d 5e 01             	lea    0x1(%esi),%ebx
  8004be:	0f b6 0e             	movzbl (%esi),%ecx
  8004c1:	0f b6 c1             	movzbl %cl,%eax
  8004c4:	83 e9 23             	sub    $0x23,%ecx
  8004c7:	80 f9 55             	cmp    $0x55,%cl
  8004ca:	0f 87 2a 03 00 00    	ja     8007fa <vprintfmt+0x3ac>
  8004d0:	0f b6 c9             	movzbl %cl,%ecx
  8004d3:	ff 24 8d 80 2a 80 00 	jmp    *0x802a80(,%ecx,4)
  8004da:	89 de                	mov    %ebx,%esi
  8004dc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004e1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004e4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004e8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004eb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004ee:	83 fb 09             	cmp    $0x9,%ebx
  8004f1:	77 36                	ja     800529 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004f3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004f6:	eb e9                	jmp    8004e1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fb:	8d 48 04             	lea    0x4(%eax),%ecx
  8004fe:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800501:	8b 00                	mov    (%eax),%eax
  800503:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800506:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800508:	eb 22                	jmp    80052c <vprintfmt+0xde>
  80050a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80050d:	85 c9                	test   %ecx,%ecx
  80050f:	b8 00 00 00 00       	mov    $0x0,%eax
  800514:	0f 49 c1             	cmovns %ecx,%eax
  800517:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	89 de                	mov    %ebx,%esi
  80051c:	eb 9d                	jmp    8004bb <vprintfmt+0x6d>
  80051e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800520:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800527:	eb 92                	jmp    8004bb <vprintfmt+0x6d>
  800529:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80052c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800530:	79 89                	jns    8004bb <vprintfmt+0x6d>
  800532:	e9 77 ff ff ff       	jmp    8004ae <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800537:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80053c:	e9 7a ff ff ff       	jmp    8004bb <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8d 50 04             	lea    0x4(%eax),%edx
  800547:	89 55 14             	mov    %edx,0x14(%ebp)
  80054a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80054e:	8b 00                	mov    (%eax),%eax
  800550:	89 04 24             	mov    %eax,(%esp)
  800553:	ff 55 08             	call   *0x8(%ebp)
			break;
  800556:	e9 18 ff ff ff       	jmp    800473 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	8d 50 04             	lea    0x4(%eax),%edx
  800561:	89 55 14             	mov    %edx,0x14(%ebp)
  800564:	8b 00                	mov    (%eax),%eax
  800566:	99                   	cltd   
  800567:	31 d0                	xor    %edx,%eax
  800569:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80056b:	83 f8 11             	cmp    $0x11,%eax
  80056e:	7f 0b                	jg     80057b <vprintfmt+0x12d>
  800570:	8b 14 85 e0 2b 80 00 	mov    0x802be0(,%eax,4),%edx
  800577:	85 d2                	test   %edx,%edx
  800579:	75 20                	jne    80059b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80057b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80057f:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  800586:	00 
  800587:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80058b:	8b 45 08             	mov    0x8(%ebp),%eax
  80058e:	89 04 24             	mov    %eax,(%esp)
  800591:	e8 90 fe ff ff       	call   800426 <printfmt>
  800596:	e9 d8 fe ff ff       	jmp    800473 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80059b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80059f:	c7 44 24 08 21 2d 80 	movl   $0x802d21,0x8(%esp)
  8005a6:	00 
  8005a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	89 04 24             	mov    %eax,(%esp)
  8005b1:	e8 70 fe ff ff       	call   800426 <printfmt>
  8005b6:	e9 b8 fe ff ff       	jmp    800473 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005bb:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	8d 50 04             	lea    0x4(%eax),%edx
  8005ca:	89 55 14             	mov    %edx,0x14(%ebp)
  8005cd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8005cf:	85 f6                	test   %esi,%esi
  8005d1:	b8 58 29 80 00       	mov    $0x802958,%eax
  8005d6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8005d9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8005dd:	0f 84 97 00 00 00    	je     80067a <vprintfmt+0x22c>
  8005e3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005e7:	0f 8e 9b 00 00 00    	jle    800688 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ed:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005f1:	89 34 24             	mov    %esi,(%esp)
  8005f4:	e8 cf 02 00 00       	call   8008c8 <strnlen>
  8005f9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005fc:	29 c2                	sub    %eax,%edx
  8005fe:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800601:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800605:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800608:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80060b:	8b 75 08             	mov    0x8(%ebp),%esi
  80060e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800611:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800613:	eb 0f                	jmp    800624 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800615:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800619:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80061c:	89 04 24             	mov    %eax,(%esp)
  80061f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800621:	83 eb 01             	sub    $0x1,%ebx
  800624:	85 db                	test   %ebx,%ebx
  800626:	7f ed                	jg     800615 <vprintfmt+0x1c7>
  800628:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80062b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80062e:	85 d2                	test   %edx,%edx
  800630:	b8 00 00 00 00       	mov    $0x0,%eax
  800635:	0f 49 c2             	cmovns %edx,%eax
  800638:	29 c2                	sub    %eax,%edx
  80063a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80063d:	89 d7                	mov    %edx,%edi
  80063f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800642:	eb 50                	jmp    800694 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800644:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800648:	74 1e                	je     800668 <vprintfmt+0x21a>
  80064a:	0f be d2             	movsbl %dl,%edx
  80064d:	83 ea 20             	sub    $0x20,%edx
  800650:	83 fa 5e             	cmp    $0x5e,%edx
  800653:	76 13                	jbe    800668 <vprintfmt+0x21a>
					putch('?', putdat);
  800655:	8b 45 0c             	mov    0xc(%ebp),%eax
  800658:	89 44 24 04          	mov    %eax,0x4(%esp)
  80065c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800663:	ff 55 08             	call   *0x8(%ebp)
  800666:	eb 0d                	jmp    800675 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800668:	8b 55 0c             	mov    0xc(%ebp),%edx
  80066b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80066f:	89 04 24             	mov    %eax,(%esp)
  800672:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800675:	83 ef 01             	sub    $0x1,%edi
  800678:	eb 1a                	jmp    800694 <vprintfmt+0x246>
  80067a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80067d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800680:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800683:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800686:	eb 0c                	jmp    800694 <vprintfmt+0x246>
  800688:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80068b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80068e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800691:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800694:	83 c6 01             	add    $0x1,%esi
  800697:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80069b:	0f be c2             	movsbl %dl,%eax
  80069e:	85 c0                	test   %eax,%eax
  8006a0:	74 27                	je     8006c9 <vprintfmt+0x27b>
  8006a2:	85 db                	test   %ebx,%ebx
  8006a4:	78 9e                	js     800644 <vprintfmt+0x1f6>
  8006a6:	83 eb 01             	sub    $0x1,%ebx
  8006a9:	79 99                	jns    800644 <vprintfmt+0x1f6>
  8006ab:	89 f8                	mov    %edi,%eax
  8006ad:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8006b3:	89 c3                	mov    %eax,%ebx
  8006b5:	eb 1a                	jmp    8006d1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006bb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006c2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006c4:	83 eb 01             	sub    $0x1,%ebx
  8006c7:	eb 08                	jmp    8006d1 <vprintfmt+0x283>
  8006c9:	89 fb                	mov    %edi,%ebx
  8006cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ce:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006d1:	85 db                	test   %ebx,%ebx
  8006d3:	7f e2                	jg     8006b7 <vprintfmt+0x269>
  8006d5:	89 75 08             	mov    %esi,0x8(%ebp)
  8006d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006db:	e9 93 fd ff ff       	jmp    800473 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006e0:	83 fa 01             	cmp    $0x1,%edx
  8006e3:	7e 16                	jle    8006fb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8d 50 08             	lea    0x8(%eax),%edx
  8006eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ee:	8b 50 04             	mov    0x4(%eax),%edx
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006f6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006f9:	eb 32                	jmp    80072d <vprintfmt+0x2df>
	else if (lflag)
  8006fb:	85 d2                	test   %edx,%edx
  8006fd:	74 18                	je     800717 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8d 50 04             	lea    0x4(%eax),%edx
  800705:	89 55 14             	mov    %edx,0x14(%ebp)
  800708:	8b 30                	mov    (%eax),%esi
  80070a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80070d:	89 f0                	mov    %esi,%eax
  80070f:	c1 f8 1f             	sar    $0x1f,%eax
  800712:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800715:	eb 16                	jmp    80072d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 50 04             	lea    0x4(%eax),%edx
  80071d:	89 55 14             	mov    %edx,0x14(%ebp)
  800720:	8b 30                	mov    (%eax),%esi
  800722:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800725:	89 f0                	mov    %esi,%eax
  800727:	c1 f8 1f             	sar    $0x1f,%eax
  80072a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80072d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800730:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800733:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800738:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80073c:	0f 89 80 00 00 00    	jns    8007c2 <vprintfmt+0x374>
				putch('-', putdat);
  800742:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800746:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80074d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800750:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800753:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800756:	f7 d8                	neg    %eax
  800758:	83 d2 00             	adc    $0x0,%edx
  80075b:	f7 da                	neg    %edx
			}
			base = 10;
  80075d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800762:	eb 5e                	jmp    8007c2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800764:	8d 45 14             	lea    0x14(%ebp),%eax
  800767:	e8 63 fc ff ff       	call   8003cf <getuint>
			base = 10;
  80076c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800771:	eb 4f                	jmp    8007c2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800773:	8d 45 14             	lea    0x14(%ebp),%eax
  800776:	e8 54 fc ff ff       	call   8003cf <getuint>
			base = 8;
  80077b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800780:	eb 40                	jmp    8007c2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800782:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800786:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80078d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800790:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800794:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80079b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	8d 50 04             	lea    0x4(%eax),%edx
  8007a4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007ae:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007b3:	eb 0d                	jmp    8007c2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007b5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b8:	e8 12 fc ff ff       	call   8003cf <getuint>
			base = 16;
  8007bd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007c2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8007c6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007ca:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8007cd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007d1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007d5:	89 04 24             	mov    %eax,(%esp)
  8007d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007dc:	89 fa                	mov    %edi,%edx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	e8 fa fa ff ff       	call   8002e0 <printnum>
			break;
  8007e6:	e9 88 fc ff ff       	jmp    800473 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007eb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ef:	89 04 24             	mov    %eax,(%esp)
  8007f2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007f5:	e9 79 fc ff ff       	jmp    800473 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007fe:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800805:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800808:	89 f3                	mov    %esi,%ebx
  80080a:	eb 03                	jmp    80080f <vprintfmt+0x3c1>
  80080c:	83 eb 01             	sub    $0x1,%ebx
  80080f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800813:	75 f7                	jne    80080c <vprintfmt+0x3be>
  800815:	e9 59 fc ff ff       	jmp    800473 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80081a:	83 c4 3c             	add    $0x3c,%esp
  80081d:	5b                   	pop    %ebx
  80081e:	5e                   	pop    %esi
  80081f:	5f                   	pop    %edi
  800820:	5d                   	pop    %ebp
  800821:	c3                   	ret    

00800822 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	83 ec 28             	sub    $0x28,%esp
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80082e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800831:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800835:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800838:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80083f:	85 c0                	test   %eax,%eax
  800841:	74 30                	je     800873 <vsnprintf+0x51>
  800843:	85 d2                	test   %edx,%edx
  800845:	7e 2c                	jle    800873 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80084e:	8b 45 10             	mov    0x10(%ebp),%eax
  800851:	89 44 24 08          	mov    %eax,0x8(%esp)
  800855:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800858:	89 44 24 04          	mov    %eax,0x4(%esp)
  80085c:	c7 04 24 09 04 80 00 	movl   $0x800409,(%esp)
  800863:	e8 e6 fb ff ff       	call   80044e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800868:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80086b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80086e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800871:	eb 05                	jmp    800878 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800873:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800878:	c9                   	leave  
  800879:	c3                   	ret    

0080087a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80087a:	55                   	push   %ebp
  80087b:	89 e5                	mov    %esp,%ebp
  80087d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800880:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800883:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800887:	8b 45 10             	mov    0x10(%ebp),%eax
  80088a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80088e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800891:	89 44 24 04          	mov    %eax,0x4(%esp)
  800895:	8b 45 08             	mov    0x8(%ebp),%eax
  800898:	89 04 24             	mov    %eax,(%esp)
  80089b:	e8 82 ff ff ff       	call   800822 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008a0:	c9                   	leave  
  8008a1:	c3                   	ret    
  8008a2:	66 90                	xchg   %ax,%ax
  8008a4:	66 90                	xchg   %ax,%ax
  8008a6:	66 90                	xchg   %ax,%ax
  8008a8:	66 90                	xchg   %ax,%ax
  8008aa:	66 90                	xchg   %ax,%ax
  8008ac:	66 90                	xchg   %ax,%ax
  8008ae:	66 90                	xchg   %ax,%ax

008008b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
  8008b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008bb:	eb 03                	jmp    8008c0 <strlen+0x10>
		n++;
  8008bd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008c4:	75 f7                	jne    8008bd <strlen+0xd>
		n++;
	return n;
}
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d6:	eb 03                	jmp    8008db <strnlen+0x13>
		n++;
  8008d8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008db:	39 d0                	cmp    %edx,%eax
  8008dd:	74 06                	je     8008e5 <strnlen+0x1d>
  8008df:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008e3:	75 f3                	jne    8008d8 <strnlen+0x10>
		n++;
	return n;
}
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	53                   	push   %ebx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f1:	89 c2                	mov    %eax,%edx
  8008f3:	83 c2 01             	add    $0x1,%edx
  8008f6:	83 c1 01             	add    $0x1,%ecx
  8008f9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008fd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800900:	84 db                	test   %bl,%bl
  800902:	75 ef                	jne    8008f3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800904:	5b                   	pop    %ebx
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	53                   	push   %ebx
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800911:	89 1c 24             	mov    %ebx,(%esp)
  800914:	e8 97 ff ff ff       	call   8008b0 <strlen>
	strcpy(dst + len, src);
  800919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800920:	01 d8                	add    %ebx,%eax
  800922:	89 04 24             	mov    %eax,(%esp)
  800925:	e8 bd ff ff ff       	call   8008e7 <strcpy>
	return dst;
}
  80092a:	89 d8                	mov    %ebx,%eax
  80092c:	83 c4 08             	add    $0x8,%esp
  80092f:	5b                   	pop    %ebx
  800930:	5d                   	pop    %ebp
  800931:	c3                   	ret    

00800932 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800932:	55                   	push   %ebp
  800933:	89 e5                	mov    %esp,%ebp
  800935:	56                   	push   %esi
  800936:	53                   	push   %ebx
  800937:	8b 75 08             	mov    0x8(%ebp),%esi
  80093a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80093d:	89 f3                	mov    %esi,%ebx
  80093f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800942:	89 f2                	mov    %esi,%edx
  800944:	eb 0f                	jmp    800955 <strncpy+0x23>
		*dst++ = *src;
  800946:	83 c2 01             	add    $0x1,%edx
  800949:	0f b6 01             	movzbl (%ecx),%eax
  80094c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80094f:	80 39 01             	cmpb   $0x1,(%ecx)
  800952:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800955:	39 da                	cmp    %ebx,%edx
  800957:	75 ed                	jne    800946 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800959:	89 f0                	mov    %esi,%eax
  80095b:	5b                   	pop    %ebx
  80095c:	5e                   	pop    %esi
  80095d:	5d                   	pop    %ebp
  80095e:	c3                   	ret    

0080095f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	56                   	push   %esi
  800963:	53                   	push   %ebx
  800964:	8b 75 08             	mov    0x8(%ebp),%esi
  800967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80096d:	89 f0                	mov    %esi,%eax
  80096f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800973:	85 c9                	test   %ecx,%ecx
  800975:	75 0b                	jne    800982 <strlcpy+0x23>
  800977:	eb 1d                	jmp    800996 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800979:	83 c0 01             	add    $0x1,%eax
  80097c:	83 c2 01             	add    $0x1,%edx
  80097f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800982:	39 d8                	cmp    %ebx,%eax
  800984:	74 0b                	je     800991 <strlcpy+0x32>
  800986:	0f b6 0a             	movzbl (%edx),%ecx
  800989:	84 c9                	test   %cl,%cl
  80098b:	75 ec                	jne    800979 <strlcpy+0x1a>
  80098d:	89 c2                	mov    %eax,%edx
  80098f:	eb 02                	jmp    800993 <strlcpy+0x34>
  800991:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800993:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800996:	29 f0                	sub    %esi,%eax
}
  800998:	5b                   	pop    %ebx
  800999:	5e                   	pop    %esi
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009a5:	eb 06                	jmp    8009ad <strcmp+0x11>
		p++, q++;
  8009a7:	83 c1 01             	add    $0x1,%ecx
  8009aa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009ad:	0f b6 01             	movzbl (%ecx),%eax
  8009b0:	84 c0                	test   %al,%al
  8009b2:	74 04                	je     8009b8 <strcmp+0x1c>
  8009b4:	3a 02                	cmp    (%edx),%al
  8009b6:	74 ef                	je     8009a7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009b8:	0f b6 c0             	movzbl %al,%eax
  8009bb:	0f b6 12             	movzbl (%edx),%edx
  8009be:	29 d0                	sub    %edx,%eax
}
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	53                   	push   %ebx
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009cc:	89 c3                	mov    %eax,%ebx
  8009ce:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009d1:	eb 06                	jmp    8009d9 <strncmp+0x17>
		n--, p++, q++;
  8009d3:	83 c0 01             	add    $0x1,%eax
  8009d6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009d9:	39 d8                	cmp    %ebx,%eax
  8009db:	74 15                	je     8009f2 <strncmp+0x30>
  8009dd:	0f b6 08             	movzbl (%eax),%ecx
  8009e0:	84 c9                	test   %cl,%cl
  8009e2:	74 04                	je     8009e8 <strncmp+0x26>
  8009e4:	3a 0a                	cmp    (%edx),%cl
  8009e6:	74 eb                	je     8009d3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e8:	0f b6 00             	movzbl (%eax),%eax
  8009eb:	0f b6 12             	movzbl (%edx),%edx
  8009ee:	29 d0                	sub    %edx,%eax
  8009f0:	eb 05                	jmp    8009f7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009f2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009f7:	5b                   	pop    %ebx
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a04:	eb 07                	jmp    800a0d <strchr+0x13>
		if (*s == c)
  800a06:	38 ca                	cmp    %cl,%dl
  800a08:	74 0f                	je     800a19 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a0a:	83 c0 01             	add    $0x1,%eax
  800a0d:	0f b6 10             	movzbl (%eax),%edx
  800a10:	84 d2                	test   %dl,%dl
  800a12:	75 f2                	jne    800a06 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a25:	eb 07                	jmp    800a2e <strfind+0x13>
		if (*s == c)
  800a27:	38 ca                	cmp    %cl,%dl
  800a29:	74 0a                	je     800a35 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a2b:	83 c0 01             	add    $0x1,%eax
  800a2e:	0f b6 10             	movzbl (%eax),%edx
  800a31:	84 d2                	test   %dl,%dl
  800a33:	75 f2                	jne    800a27 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    

00800a37 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	57                   	push   %edi
  800a3b:	56                   	push   %esi
  800a3c:	53                   	push   %ebx
  800a3d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a40:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a43:	85 c9                	test   %ecx,%ecx
  800a45:	74 36                	je     800a7d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a47:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a4d:	75 28                	jne    800a77 <memset+0x40>
  800a4f:	f6 c1 03             	test   $0x3,%cl
  800a52:	75 23                	jne    800a77 <memset+0x40>
		c &= 0xFF;
  800a54:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a58:	89 d3                	mov    %edx,%ebx
  800a5a:	c1 e3 08             	shl    $0x8,%ebx
  800a5d:	89 d6                	mov    %edx,%esi
  800a5f:	c1 e6 18             	shl    $0x18,%esi
  800a62:	89 d0                	mov    %edx,%eax
  800a64:	c1 e0 10             	shl    $0x10,%eax
  800a67:	09 f0                	or     %esi,%eax
  800a69:	09 c2                	or     %eax,%edx
  800a6b:	89 d0                	mov    %edx,%eax
  800a6d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a6f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a72:	fc                   	cld    
  800a73:	f3 ab                	rep stos %eax,%es:(%edi)
  800a75:	eb 06                	jmp    800a7d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7a:	fc                   	cld    
  800a7b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a7d:	89 f8                	mov    %edi,%eax
  800a7f:	5b                   	pop    %ebx
  800a80:	5e                   	pop    %esi
  800a81:	5f                   	pop    %edi
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    

00800a84 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	57                   	push   %edi
  800a88:	56                   	push   %esi
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a92:	39 c6                	cmp    %eax,%esi
  800a94:	73 35                	jae    800acb <memmove+0x47>
  800a96:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a99:	39 d0                	cmp    %edx,%eax
  800a9b:	73 2e                	jae    800acb <memmove+0x47>
		s += n;
		d += n;
  800a9d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800aa0:	89 d6                	mov    %edx,%esi
  800aa2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aaa:	75 13                	jne    800abf <memmove+0x3b>
  800aac:	f6 c1 03             	test   $0x3,%cl
  800aaf:	75 0e                	jne    800abf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ab1:	83 ef 04             	sub    $0x4,%edi
  800ab4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aba:	fd                   	std    
  800abb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abd:	eb 09                	jmp    800ac8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800abf:	83 ef 01             	sub    $0x1,%edi
  800ac2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ac5:	fd                   	std    
  800ac6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac8:	fc                   	cld    
  800ac9:	eb 1d                	jmp    800ae8 <memmove+0x64>
  800acb:	89 f2                	mov    %esi,%edx
  800acd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800acf:	f6 c2 03             	test   $0x3,%dl
  800ad2:	75 0f                	jne    800ae3 <memmove+0x5f>
  800ad4:	f6 c1 03             	test   $0x3,%cl
  800ad7:	75 0a                	jne    800ae3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800adc:	89 c7                	mov    %eax,%edi
  800ade:	fc                   	cld    
  800adf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ae1:	eb 05                	jmp    800ae8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ae3:	89 c7                	mov    %eax,%edi
  800ae5:	fc                   	cld    
  800ae6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae8:	5e                   	pop    %esi
  800ae9:	5f                   	pop    %edi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800af2:	8b 45 10             	mov    0x10(%ebp),%eax
  800af5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	89 04 24             	mov    %eax,(%esp)
  800b06:	e8 79 ff ff ff       	call   800a84 <memmove>
}
  800b0b:	c9                   	leave  
  800b0c:	c3                   	ret    

00800b0d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	56                   	push   %esi
  800b11:	53                   	push   %ebx
  800b12:	8b 55 08             	mov    0x8(%ebp),%edx
  800b15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b18:	89 d6                	mov    %edx,%esi
  800b1a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b1d:	eb 1a                	jmp    800b39 <memcmp+0x2c>
		if (*s1 != *s2)
  800b1f:	0f b6 02             	movzbl (%edx),%eax
  800b22:	0f b6 19             	movzbl (%ecx),%ebx
  800b25:	38 d8                	cmp    %bl,%al
  800b27:	74 0a                	je     800b33 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b29:	0f b6 c0             	movzbl %al,%eax
  800b2c:	0f b6 db             	movzbl %bl,%ebx
  800b2f:	29 d8                	sub    %ebx,%eax
  800b31:	eb 0f                	jmp    800b42 <memcmp+0x35>
		s1++, s2++;
  800b33:	83 c2 01             	add    $0x1,%edx
  800b36:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b39:	39 f2                	cmp    %esi,%edx
  800b3b:	75 e2                	jne    800b1f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b42:	5b                   	pop    %ebx
  800b43:	5e                   	pop    %esi
  800b44:	5d                   	pop    %ebp
  800b45:	c3                   	ret    

00800b46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b46:	55                   	push   %ebp
  800b47:	89 e5                	mov    %esp,%ebp
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b4f:	89 c2                	mov    %eax,%edx
  800b51:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b54:	eb 07                	jmp    800b5d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b56:	38 08                	cmp    %cl,(%eax)
  800b58:	74 07                	je     800b61 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b5a:	83 c0 01             	add    $0x1,%eax
  800b5d:	39 d0                	cmp    %edx,%eax
  800b5f:	72 f5                	jb     800b56 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	57                   	push   %edi
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b6f:	eb 03                	jmp    800b74 <strtol+0x11>
		s++;
  800b71:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b74:	0f b6 0a             	movzbl (%edx),%ecx
  800b77:	80 f9 09             	cmp    $0x9,%cl
  800b7a:	74 f5                	je     800b71 <strtol+0xe>
  800b7c:	80 f9 20             	cmp    $0x20,%cl
  800b7f:	74 f0                	je     800b71 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b81:	80 f9 2b             	cmp    $0x2b,%cl
  800b84:	75 0a                	jne    800b90 <strtol+0x2d>
		s++;
  800b86:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b89:	bf 00 00 00 00       	mov    $0x0,%edi
  800b8e:	eb 11                	jmp    800ba1 <strtol+0x3e>
  800b90:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b95:	80 f9 2d             	cmp    $0x2d,%cl
  800b98:	75 07                	jne    800ba1 <strtol+0x3e>
		s++, neg = 1;
  800b9a:	8d 52 01             	lea    0x1(%edx),%edx
  800b9d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800ba6:	75 15                	jne    800bbd <strtol+0x5a>
  800ba8:	80 3a 30             	cmpb   $0x30,(%edx)
  800bab:	75 10                	jne    800bbd <strtol+0x5a>
  800bad:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bb1:	75 0a                	jne    800bbd <strtol+0x5a>
		s += 2, base = 16;
  800bb3:	83 c2 02             	add    $0x2,%edx
  800bb6:	b8 10 00 00 00       	mov    $0x10,%eax
  800bbb:	eb 10                	jmp    800bcd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800bbd:	85 c0                	test   %eax,%eax
  800bbf:	75 0c                	jne    800bcd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bc1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bc3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bc6:	75 05                	jne    800bcd <strtol+0x6a>
		s++, base = 8;
  800bc8:	83 c2 01             	add    $0x1,%edx
  800bcb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bd2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bd5:	0f b6 0a             	movzbl (%edx),%ecx
  800bd8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bdb:	89 f0                	mov    %esi,%eax
  800bdd:	3c 09                	cmp    $0x9,%al
  800bdf:	77 08                	ja     800be9 <strtol+0x86>
			dig = *s - '0';
  800be1:	0f be c9             	movsbl %cl,%ecx
  800be4:	83 e9 30             	sub    $0x30,%ecx
  800be7:	eb 20                	jmp    800c09 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800be9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bec:	89 f0                	mov    %esi,%eax
  800bee:	3c 19                	cmp    $0x19,%al
  800bf0:	77 08                	ja     800bfa <strtol+0x97>
			dig = *s - 'a' + 10;
  800bf2:	0f be c9             	movsbl %cl,%ecx
  800bf5:	83 e9 57             	sub    $0x57,%ecx
  800bf8:	eb 0f                	jmp    800c09 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bfa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bfd:	89 f0                	mov    %esi,%eax
  800bff:	3c 19                	cmp    $0x19,%al
  800c01:	77 16                	ja     800c19 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c03:	0f be c9             	movsbl %cl,%ecx
  800c06:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c09:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c0c:	7d 0f                	jge    800c1d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c0e:	83 c2 01             	add    $0x1,%edx
  800c11:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c15:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c17:	eb bc                	jmp    800bd5 <strtol+0x72>
  800c19:	89 d8                	mov    %ebx,%eax
  800c1b:	eb 02                	jmp    800c1f <strtol+0xbc>
  800c1d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c1f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c23:	74 05                	je     800c2a <strtol+0xc7>
		*endptr = (char *) s;
  800c25:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c28:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c2a:	f7 d8                	neg    %eax
  800c2c:	85 ff                	test   %edi,%edi
  800c2e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c31:	5b                   	pop    %ebx
  800c32:	5e                   	pop    %esi
  800c33:	5f                   	pop    %edi
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	57                   	push   %edi
  800c3a:	56                   	push   %esi
  800c3b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c44:	8b 55 08             	mov    0x8(%ebp),%edx
  800c47:	89 c3                	mov    %eax,%ebx
  800c49:	89 c7                	mov    %eax,%edi
  800c4b:	89 c6                	mov    %eax,%esi
  800c4d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <sys_cgetc>:

int
sys_cgetc(void)
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
  800c5f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c64:	89 d1                	mov    %edx,%ecx
  800c66:	89 d3                	mov    %edx,%ebx
  800c68:	89 d7                	mov    %edx,%edi
  800c6a:	89 d6                	mov    %edx,%esi
  800c6c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    

00800c73 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800c7c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c81:	b8 03 00 00 00       	mov    $0x3,%eax
  800c86:	8b 55 08             	mov    0x8(%ebp),%edx
  800c89:	89 cb                	mov    %ecx,%ebx
  800c8b:	89 cf                	mov    %ecx,%edi
  800c8d:	89 ce                	mov    %ecx,%esi
  800c8f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c91:	85 c0                	test   %eax,%eax
  800c93:	7e 28                	jle    800cbd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c95:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c99:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ca0:	00 
  800ca1:	c7 44 24 08 47 2c 80 	movl   $0x802c47,0x8(%esp)
  800ca8:	00 
  800ca9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cb0:	00 
  800cb1:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  800cb8:	e8 09 f5 ff ff       	call   8001c6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cbd:	83 c4 2c             	add    $0x2c,%esp
  800cc0:	5b                   	pop    %ebx
  800cc1:	5e                   	pop    %esi
  800cc2:	5f                   	pop    %edi
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	57                   	push   %edi
  800cc9:	56                   	push   %esi
  800cca:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd0:	b8 02 00 00 00       	mov    $0x2,%eax
  800cd5:	89 d1                	mov    %edx,%ecx
  800cd7:	89 d3                	mov    %edx,%ebx
  800cd9:	89 d7                	mov    %edx,%edi
  800cdb:	89 d6                	mov    %edx,%esi
  800cdd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <sys_yield>:

void
sys_yield(void)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cea:	ba 00 00 00 00       	mov    $0x0,%edx
  800cef:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cf4:	89 d1                	mov    %edx,%ecx
  800cf6:	89 d3                	mov    %edx,%ebx
  800cf8:	89 d7                	mov    %edx,%edi
  800cfa:	89 d6                	mov    %edx,%esi
  800cfc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
  800d09:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0c:	be 00 00 00 00       	mov    $0x0,%esi
  800d11:	b8 04 00 00 00       	mov    $0x4,%eax
  800d16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1f:	89 f7                	mov    %esi,%edi
  800d21:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d23:	85 c0                	test   %eax,%eax
  800d25:	7e 28                	jle    800d4f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d27:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d2b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d32:	00 
  800d33:	c7 44 24 08 47 2c 80 	movl   $0x802c47,0x8(%esp)
  800d3a:	00 
  800d3b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d42:	00 
  800d43:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  800d4a:	e8 77 f4 ff ff       	call   8001c6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d4f:	83 c4 2c             	add    $0x2c,%esp
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5f                   	pop    %edi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	57                   	push   %edi
  800d5b:	56                   	push   %esi
  800d5c:	53                   	push   %ebx
  800d5d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d60:	b8 05 00 00 00       	mov    $0x5,%eax
  800d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d68:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d71:	8b 75 18             	mov    0x18(%ebp),%esi
  800d74:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d76:	85 c0                	test   %eax,%eax
  800d78:	7e 28                	jle    800da2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d7e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d85:	00 
  800d86:	c7 44 24 08 47 2c 80 	movl   $0x802c47,0x8(%esp)
  800d8d:	00 
  800d8e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d95:	00 
  800d96:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  800d9d:	e8 24 f4 ff ff       	call   8001c6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da2:	83 c4 2c             	add    $0x2c,%esp
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db8:	b8 06 00 00 00       	mov    $0x6,%eax
  800dbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc3:	89 df                	mov    %ebx,%edi
  800dc5:	89 de                	mov    %ebx,%esi
  800dc7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	7e 28                	jle    800df5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dcd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dd1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800dd8:	00 
  800dd9:	c7 44 24 08 47 2c 80 	movl   $0x802c47,0x8(%esp)
  800de0:	00 
  800de1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800de8:	00 
  800de9:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  800df0:	e8 d1 f3 ff ff       	call   8001c6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800df5:	83 c4 2c             	add    $0x2c,%esp
  800df8:	5b                   	pop    %ebx
  800df9:	5e                   	pop    %esi
  800dfa:	5f                   	pop    %edi
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	57                   	push   %edi
  800e01:	56                   	push   %esi
  800e02:	53                   	push   %ebx
  800e03:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e13:	8b 55 08             	mov    0x8(%ebp),%edx
  800e16:	89 df                	mov    %ebx,%edi
  800e18:	89 de                	mov    %ebx,%esi
  800e1a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	7e 28                	jle    800e48 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e20:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e24:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e2b:	00 
  800e2c:	c7 44 24 08 47 2c 80 	movl   $0x802c47,0x8(%esp)
  800e33:	00 
  800e34:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e3b:	00 
  800e3c:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  800e43:	e8 7e f3 ff ff       	call   8001c6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e48:	83 c4 2c             	add    $0x2c,%esp
  800e4b:	5b                   	pop    %ebx
  800e4c:	5e                   	pop    %esi
  800e4d:	5f                   	pop    %edi
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    

00800e50 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	57                   	push   %edi
  800e54:	56                   	push   %esi
  800e55:	53                   	push   %ebx
  800e56:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e66:	8b 55 08             	mov    0x8(%ebp),%edx
  800e69:	89 df                	mov    %ebx,%edi
  800e6b:	89 de                	mov    %ebx,%esi
  800e6d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	7e 28                	jle    800e9b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e73:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e77:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e7e:	00 
  800e7f:	c7 44 24 08 47 2c 80 	movl   $0x802c47,0x8(%esp)
  800e86:	00 
  800e87:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8e:	00 
  800e8f:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  800e96:	e8 2b f3 ff ff       	call   8001c6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e9b:	83 c4 2c             	add    $0x2c,%esp
  800e9e:	5b                   	pop    %ebx
  800e9f:	5e                   	pop    %esi
  800ea0:	5f                   	pop    %edi
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    

00800ea3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	57                   	push   %edi
  800ea7:	56                   	push   %esi
  800ea8:	53                   	push   %ebx
  800ea9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eac:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebc:	89 df                	mov    %ebx,%edi
  800ebe:	89 de                	mov    %ebx,%esi
  800ec0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	7e 28                	jle    800eee <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eca:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ed1:	00 
  800ed2:	c7 44 24 08 47 2c 80 	movl   $0x802c47,0x8(%esp)
  800ed9:	00 
  800eda:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee1:	00 
  800ee2:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  800ee9:	e8 d8 f2 ff ff       	call   8001c6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eee:	83 c4 2c             	add    $0x2c,%esp
  800ef1:	5b                   	pop    %ebx
  800ef2:	5e                   	pop    %esi
  800ef3:	5f                   	pop    %edi
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    

00800ef6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	57                   	push   %edi
  800efa:	56                   	push   %esi
  800efb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efc:	be 00 00 00 00       	mov    $0x0,%esi
  800f01:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f12:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    

00800f19 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
  800f1f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f22:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f27:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2f:	89 cb                	mov    %ecx,%ebx
  800f31:	89 cf                	mov    %ecx,%edi
  800f33:	89 ce                	mov    %ecx,%esi
  800f35:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f37:	85 c0                	test   %eax,%eax
  800f39:	7e 28                	jle    800f63 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f46:	00 
  800f47:	c7 44 24 08 47 2c 80 	movl   $0x802c47,0x8(%esp)
  800f4e:	00 
  800f4f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f56:	00 
  800f57:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  800f5e:	e8 63 f2 ff ff       	call   8001c6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f63:	83 c4 2c             	add    $0x2c,%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    

00800f6b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	57                   	push   %edi
  800f6f:	56                   	push   %esi
  800f70:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f71:	ba 00 00 00 00       	mov    $0x0,%edx
  800f76:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f7b:	89 d1                	mov    %edx,%ecx
  800f7d:	89 d3                	mov    %edx,%ebx
  800f7f:	89 d7                	mov    %edx,%edi
  800f81:	89 d6                	mov    %edx,%esi
  800f83:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f85:	5b                   	pop    %ebx
  800f86:	5e                   	pop    %esi
  800f87:	5f                   	pop    %edi
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    

00800f8a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f95:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa0:	89 df                	mov    %ebx,%edi
  800fa2:	89 de                	mov    %ebx,%esi
  800fa4:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800fa6:	5b                   	pop    %ebx
  800fa7:	5e                   	pop    %esi
  800fa8:	5f                   	pop    %edi
  800fa9:	5d                   	pop    %ebp
  800faa:	c3                   	ret    

00800fab <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	57                   	push   %edi
  800faf:	56                   	push   %esi
  800fb0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb6:	b8 10 00 00 00       	mov    $0x10,%eax
  800fbb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc1:	89 df                	mov    %ebx,%edi
  800fc3:	89 de                	mov    %ebx,%esi
  800fc5:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800fc7:	5b                   	pop    %ebx
  800fc8:	5e                   	pop    %esi
  800fc9:	5f                   	pop    %edi
  800fca:	5d                   	pop    %ebp
  800fcb:	c3                   	ret    

00800fcc <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	57                   	push   %edi
  800fd0:	56                   	push   %esi
  800fd1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd7:	b8 11 00 00 00       	mov    $0x11,%eax
  800fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdf:	89 cb                	mov    %ecx,%ebx
  800fe1:	89 cf                	mov    %ecx,%edi
  800fe3:	89 ce                	mov    %ecx,%esi
  800fe5:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	57                   	push   %edi
  800ff0:	56                   	push   %esi
  800ff1:	53                   	push   %ebx
  800ff2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff5:	be 00 00 00 00       	mov    $0x0,%esi
  800ffa:	b8 12 00 00 00       	mov    $0x12,%eax
  800fff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801002:	8b 55 08             	mov    0x8(%ebp),%edx
  801005:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801008:	8b 7d 14             	mov    0x14(%ebp),%edi
  80100b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80100d:	85 c0                	test   %eax,%eax
  80100f:	7e 28                	jle    801039 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801011:	89 44 24 10          	mov    %eax,0x10(%esp)
  801015:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80101c:	00 
  80101d:	c7 44 24 08 47 2c 80 	movl   $0x802c47,0x8(%esp)
  801024:	00 
  801025:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80102c:	00 
  80102d:	c7 04 24 64 2c 80 00 	movl   $0x802c64,(%esp)
  801034:	e8 8d f1 ff ff       	call   8001c6 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801039:	83 c4 2c             	add    $0x2c,%esp
  80103c:	5b                   	pop    %ebx
  80103d:	5e                   	pop    %esi
  80103e:	5f                   	pop    %edi
  80103f:	5d                   	pop    %ebp
  801040:	c3                   	ret    
  801041:	66 90                	xchg   %ax,%ax
  801043:	66 90                	xchg   %ax,%ax
  801045:	66 90                	xchg   %ax,%ax
  801047:	66 90                	xchg   %ax,%ax
  801049:	66 90                	xchg   %ax,%ax
  80104b:	66 90                	xchg   %ax,%ax
  80104d:	66 90                	xchg   %ax,%ax
  80104f:	90                   	nop

00801050 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801050:	55                   	push   %ebp
  801051:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	05 00 00 00 30       	add    $0x30000000,%eax
  80105b:	c1 e8 0c             	shr    $0xc,%eax
}
  80105e:	5d                   	pop    %ebp
  80105f:	c3                   	ret    

00801060 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80106b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801070:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80107d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801082:	89 c2                	mov    %eax,%edx
  801084:	c1 ea 16             	shr    $0x16,%edx
  801087:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80108e:	f6 c2 01             	test   $0x1,%dl
  801091:	74 11                	je     8010a4 <fd_alloc+0x2d>
  801093:	89 c2                	mov    %eax,%edx
  801095:	c1 ea 0c             	shr    $0xc,%edx
  801098:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80109f:	f6 c2 01             	test   $0x1,%dl
  8010a2:	75 09                	jne    8010ad <fd_alloc+0x36>
			*fd_store = fd;
  8010a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ab:	eb 17                	jmp    8010c4 <fd_alloc+0x4d>
  8010ad:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010b2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010b7:	75 c9                	jne    801082 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010b9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8010bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    

008010c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010cc:	83 f8 1f             	cmp    $0x1f,%eax
  8010cf:	77 36                	ja     801107 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010d1:	c1 e0 0c             	shl    $0xc,%eax
  8010d4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010d9:	89 c2                	mov    %eax,%edx
  8010db:	c1 ea 16             	shr    $0x16,%edx
  8010de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010e5:	f6 c2 01             	test   $0x1,%dl
  8010e8:	74 24                	je     80110e <fd_lookup+0x48>
  8010ea:	89 c2                	mov    %eax,%edx
  8010ec:	c1 ea 0c             	shr    $0xc,%edx
  8010ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f6:	f6 c2 01             	test   $0x1,%dl
  8010f9:	74 1a                	je     801115 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fe:	89 02                	mov    %eax,(%edx)
	return 0;
  801100:	b8 00 00 00 00       	mov    $0x0,%eax
  801105:	eb 13                	jmp    80111a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801107:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80110c:	eb 0c                	jmp    80111a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80110e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801113:	eb 05                	jmp    80111a <fd_lookup+0x54>
  801115:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    

0080111c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 18             	sub    $0x18,%esp
  801122:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801125:	ba 00 00 00 00       	mov    $0x0,%edx
  80112a:	eb 13                	jmp    80113f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80112c:	39 08                	cmp    %ecx,(%eax)
  80112e:	75 0c                	jne    80113c <dev_lookup+0x20>
			*dev = devtab[i];
  801130:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801133:	89 01                	mov    %eax,(%ecx)
			return 0;
  801135:	b8 00 00 00 00       	mov    $0x0,%eax
  80113a:	eb 38                	jmp    801174 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80113c:	83 c2 01             	add    $0x1,%edx
  80113f:	8b 04 95 f4 2c 80 00 	mov    0x802cf4(,%edx,4),%eax
  801146:	85 c0                	test   %eax,%eax
  801148:	75 e2                	jne    80112c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80114a:	a1 20 60 80 00       	mov    0x806020,%eax
  80114f:	8b 40 48             	mov    0x48(%eax),%eax
  801152:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801156:	89 44 24 04          	mov    %eax,0x4(%esp)
  80115a:	c7 04 24 74 2c 80 00 	movl   $0x802c74,(%esp)
  801161:	e8 59 f1 ff ff       	call   8002bf <cprintf>
	*dev = 0;
  801166:	8b 45 0c             	mov    0xc(%ebp),%eax
  801169:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80116f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	56                   	push   %esi
  80117a:	53                   	push   %ebx
  80117b:	83 ec 20             	sub    $0x20,%esp
  80117e:	8b 75 08             	mov    0x8(%ebp),%esi
  801181:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801184:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801187:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80118b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801191:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801194:	89 04 24             	mov    %eax,(%esp)
  801197:	e8 2a ff ff ff       	call   8010c6 <fd_lookup>
  80119c:	85 c0                	test   %eax,%eax
  80119e:	78 05                	js     8011a5 <fd_close+0x2f>
	    || fd != fd2)
  8011a0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8011a3:	74 0c                	je     8011b1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8011a5:	84 db                	test   %bl,%bl
  8011a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ac:	0f 44 c2             	cmove  %edx,%eax
  8011af:	eb 3f                	jmp    8011f0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011b8:	8b 06                	mov    (%esi),%eax
  8011ba:	89 04 24             	mov    %eax,(%esp)
  8011bd:	e8 5a ff ff ff       	call   80111c <dev_lookup>
  8011c2:	89 c3                	mov    %eax,%ebx
  8011c4:	85 c0                	test   %eax,%eax
  8011c6:	78 16                	js     8011de <fd_close+0x68>
		if (dev->dev_close)
  8011c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011d3:	85 c0                	test   %eax,%eax
  8011d5:	74 07                	je     8011de <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8011d7:	89 34 24             	mov    %esi,(%esp)
  8011da:	ff d0                	call   *%eax
  8011dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011e9:	e8 bc fb ff ff       	call   800daa <sys_page_unmap>
	return r;
  8011ee:	89 d8                	mov    %ebx,%eax
}
  8011f0:	83 c4 20             	add    $0x20,%esp
  8011f3:	5b                   	pop    %ebx
  8011f4:	5e                   	pop    %esi
  8011f5:	5d                   	pop    %ebp
  8011f6:	c3                   	ret    

008011f7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801200:	89 44 24 04          	mov    %eax,0x4(%esp)
  801204:	8b 45 08             	mov    0x8(%ebp),%eax
  801207:	89 04 24             	mov    %eax,(%esp)
  80120a:	e8 b7 fe ff ff       	call   8010c6 <fd_lookup>
  80120f:	89 c2                	mov    %eax,%edx
  801211:	85 d2                	test   %edx,%edx
  801213:	78 13                	js     801228 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801215:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80121c:	00 
  80121d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801220:	89 04 24             	mov    %eax,(%esp)
  801223:	e8 4e ff ff ff       	call   801176 <fd_close>
}
  801228:	c9                   	leave  
  801229:	c3                   	ret    

0080122a <close_all>:

void
close_all(void)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	53                   	push   %ebx
  80122e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801231:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801236:	89 1c 24             	mov    %ebx,(%esp)
  801239:	e8 b9 ff ff ff       	call   8011f7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80123e:	83 c3 01             	add    $0x1,%ebx
  801241:	83 fb 20             	cmp    $0x20,%ebx
  801244:	75 f0                	jne    801236 <close_all+0xc>
		close(i);
}
  801246:	83 c4 14             	add    $0x14,%esp
  801249:	5b                   	pop    %ebx
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	57                   	push   %edi
  801250:	56                   	push   %esi
  801251:	53                   	push   %ebx
  801252:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801255:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801258:	89 44 24 04          	mov    %eax,0x4(%esp)
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	89 04 24             	mov    %eax,(%esp)
  801262:	e8 5f fe ff ff       	call   8010c6 <fd_lookup>
  801267:	89 c2                	mov    %eax,%edx
  801269:	85 d2                	test   %edx,%edx
  80126b:	0f 88 e1 00 00 00    	js     801352 <dup+0x106>
		return r;
	close(newfdnum);
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	89 04 24             	mov    %eax,(%esp)
  801277:	e8 7b ff ff ff       	call   8011f7 <close>

	newfd = INDEX2FD(newfdnum);
  80127c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80127f:	c1 e3 0c             	shl    $0xc,%ebx
  801282:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80128b:	89 04 24             	mov    %eax,(%esp)
  80128e:	e8 cd fd ff ff       	call   801060 <fd2data>
  801293:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801295:	89 1c 24             	mov    %ebx,(%esp)
  801298:	e8 c3 fd ff ff       	call   801060 <fd2data>
  80129d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80129f:	89 f0                	mov    %esi,%eax
  8012a1:	c1 e8 16             	shr    $0x16,%eax
  8012a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ab:	a8 01                	test   $0x1,%al
  8012ad:	74 43                	je     8012f2 <dup+0xa6>
  8012af:	89 f0                	mov    %esi,%eax
  8012b1:	c1 e8 0c             	shr    $0xc,%eax
  8012b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012bb:	f6 c2 01             	test   $0x1,%dl
  8012be:	74 32                	je     8012f2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012cc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012d0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012db:	00 
  8012dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012e7:	e8 6b fa ff ff       	call   800d57 <sys_page_map>
  8012ec:	89 c6                	mov    %eax,%esi
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	78 3e                	js     801330 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012f5:	89 c2                	mov    %eax,%edx
  8012f7:	c1 ea 0c             	shr    $0xc,%edx
  8012fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801301:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801307:	89 54 24 10          	mov    %edx,0x10(%esp)
  80130b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80130f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801316:	00 
  801317:	89 44 24 04          	mov    %eax,0x4(%esp)
  80131b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801322:	e8 30 fa ff ff       	call   800d57 <sys_page_map>
  801327:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801329:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80132c:	85 f6                	test   %esi,%esi
  80132e:	79 22                	jns    801352 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801330:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801334:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80133b:	e8 6a fa ff ff       	call   800daa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801340:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801344:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80134b:	e8 5a fa ff ff       	call   800daa <sys_page_unmap>
	return r;
  801350:	89 f0                	mov    %esi,%eax
}
  801352:	83 c4 3c             	add    $0x3c,%esp
  801355:	5b                   	pop    %ebx
  801356:	5e                   	pop    %esi
  801357:	5f                   	pop    %edi
  801358:	5d                   	pop    %ebp
  801359:	c3                   	ret    

0080135a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	53                   	push   %ebx
  80135e:	83 ec 24             	sub    $0x24,%esp
  801361:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801364:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801367:	89 44 24 04          	mov    %eax,0x4(%esp)
  80136b:	89 1c 24             	mov    %ebx,(%esp)
  80136e:	e8 53 fd ff ff       	call   8010c6 <fd_lookup>
  801373:	89 c2                	mov    %eax,%edx
  801375:	85 d2                	test   %edx,%edx
  801377:	78 6d                	js     8013e6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801379:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80137c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801383:	8b 00                	mov    (%eax),%eax
  801385:	89 04 24             	mov    %eax,(%esp)
  801388:	e8 8f fd ff ff       	call   80111c <dev_lookup>
  80138d:	85 c0                	test   %eax,%eax
  80138f:	78 55                	js     8013e6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801394:	8b 50 08             	mov    0x8(%eax),%edx
  801397:	83 e2 03             	and    $0x3,%edx
  80139a:	83 fa 01             	cmp    $0x1,%edx
  80139d:	75 23                	jne    8013c2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80139f:	a1 20 60 80 00       	mov    0x806020,%eax
  8013a4:	8b 40 48             	mov    0x48(%eax),%eax
  8013a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013af:	c7 04 24 b8 2c 80 00 	movl   $0x802cb8,(%esp)
  8013b6:	e8 04 ef ff ff       	call   8002bf <cprintf>
		return -E_INVAL;
  8013bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c0:	eb 24                	jmp    8013e6 <read+0x8c>
	}
	if (!dev->dev_read)
  8013c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c5:	8b 52 08             	mov    0x8(%edx),%edx
  8013c8:	85 d2                	test   %edx,%edx
  8013ca:	74 15                	je     8013e1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013da:	89 04 24             	mov    %eax,(%esp)
  8013dd:	ff d2                	call   *%edx
  8013df:	eb 05                	jmp    8013e6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8013e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8013e6:	83 c4 24             	add    $0x24,%esp
  8013e9:	5b                   	pop    %ebx
  8013ea:	5d                   	pop    %ebp
  8013eb:	c3                   	ret    

008013ec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	57                   	push   %edi
  8013f0:	56                   	push   %esi
  8013f1:	53                   	push   %ebx
  8013f2:	83 ec 1c             	sub    $0x1c,%esp
  8013f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013f8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801400:	eb 23                	jmp    801425 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801402:	89 f0                	mov    %esi,%eax
  801404:	29 d8                	sub    %ebx,%eax
  801406:	89 44 24 08          	mov    %eax,0x8(%esp)
  80140a:	89 d8                	mov    %ebx,%eax
  80140c:	03 45 0c             	add    0xc(%ebp),%eax
  80140f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801413:	89 3c 24             	mov    %edi,(%esp)
  801416:	e8 3f ff ff ff       	call   80135a <read>
		if (m < 0)
  80141b:	85 c0                	test   %eax,%eax
  80141d:	78 10                	js     80142f <readn+0x43>
			return m;
		if (m == 0)
  80141f:	85 c0                	test   %eax,%eax
  801421:	74 0a                	je     80142d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801423:	01 c3                	add    %eax,%ebx
  801425:	39 f3                	cmp    %esi,%ebx
  801427:	72 d9                	jb     801402 <readn+0x16>
  801429:	89 d8                	mov    %ebx,%eax
  80142b:	eb 02                	jmp    80142f <readn+0x43>
  80142d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80142f:	83 c4 1c             	add    $0x1c,%esp
  801432:	5b                   	pop    %ebx
  801433:	5e                   	pop    %esi
  801434:	5f                   	pop    %edi
  801435:	5d                   	pop    %ebp
  801436:	c3                   	ret    

00801437 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	53                   	push   %ebx
  80143b:	83 ec 24             	sub    $0x24,%esp
  80143e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801441:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801444:	89 44 24 04          	mov    %eax,0x4(%esp)
  801448:	89 1c 24             	mov    %ebx,(%esp)
  80144b:	e8 76 fc ff ff       	call   8010c6 <fd_lookup>
  801450:	89 c2                	mov    %eax,%edx
  801452:	85 d2                	test   %edx,%edx
  801454:	78 68                	js     8014be <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801456:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801459:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801460:	8b 00                	mov    (%eax),%eax
  801462:	89 04 24             	mov    %eax,(%esp)
  801465:	e8 b2 fc ff ff       	call   80111c <dev_lookup>
  80146a:	85 c0                	test   %eax,%eax
  80146c:	78 50                	js     8014be <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80146e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801471:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801475:	75 23                	jne    80149a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801477:	a1 20 60 80 00       	mov    0x806020,%eax
  80147c:	8b 40 48             	mov    0x48(%eax),%eax
  80147f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801483:	89 44 24 04          	mov    %eax,0x4(%esp)
  801487:	c7 04 24 d4 2c 80 00 	movl   $0x802cd4,(%esp)
  80148e:	e8 2c ee ff ff       	call   8002bf <cprintf>
		return -E_INVAL;
  801493:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801498:	eb 24                	jmp    8014be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80149a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149d:	8b 52 0c             	mov    0xc(%edx),%edx
  8014a0:	85 d2                	test   %edx,%edx
  8014a2:	74 15                	je     8014b9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014b2:	89 04 24             	mov    %eax,(%esp)
  8014b5:	ff d2                	call   *%edx
  8014b7:	eb 05                	jmp    8014be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8014b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8014be:	83 c4 24             	add    $0x24,%esp
  8014c1:	5b                   	pop    %ebx
  8014c2:	5d                   	pop    %ebp
  8014c3:	c3                   	ret    

008014c4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ca:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	89 04 24             	mov    %eax,(%esp)
  8014d7:	e8 ea fb ff ff       	call   8010c6 <fd_lookup>
  8014dc:	85 c0                	test   %eax,%eax
  8014de:	78 0e                	js     8014ee <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8014e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	53                   	push   %ebx
  8014f4:	83 ec 24             	sub    $0x24,%esp
  8014f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801501:	89 1c 24             	mov    %ebx,(%esp)
  801504:	e8 bd fb ff ff       	call   8010c6 <fd_lookup>
  801509:	89 c2                	mov    %eax,%edx
  80150b:	85 d2                	test   %edx,%edx
  80150d:	78 61                	js     801570 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801512:	89 44 24 04          	mov    %eax,0x4(%esp)
  801516:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801519:	8b 00                	mov    (%eax),%eax
  80151b:	89 04 24             	mov    %eax,(%esp)
  80151e:	e8 f9 fb ff ff       	call   80111c <dev_lookup>
  801523:	85 c0                	test   %eax,%eax
  801525:	78 49                	js     801570 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80152e:	75 23                	jne    801553 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801530:	a1 20 60 80 00       	mov    0x806020,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801535:	8b 40 48             	mov    0x48(%eax),%eax
  801538:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80153c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801540:	c7 04 24 94 2c 80 00 	movl   $0x802c94,(%esp)
  801547:	e8 73 ed ff ff       	call   8002bf <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80154c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801551:	eb 1d                	jmp    801570 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801553:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801556:	8b 52 18             	mov    0x18(%edx),%edx
  801559:	85 d2                	test   %edx,%edx
  80155b:	74 0e                	je     80156b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80155d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801560:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801564:	89 04 24             	mov    %eax,(%esp)
  801567:	ff d2                	call   *%edx
  801569:	eb 05                	jmp    801570 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80156b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801570:	83 c4 24             	add    $0x24,%esp
  801573:	5b                   	pop    %ebx
  801574:	5d                   	pop    %ebp
  801575:	c3                   	ret    

00801576 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801576:	55                   	push   %ebp
  801577:	89 e5                	mov    %esp,%ebp
  801579:	53                   	push   %ebx
  80157a:	83 ec 24             	sub    $0x24,%esp
  80157d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801580:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801583:	89 44 24 04          	mov    %eax,0x4(%esp)
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	89 04 24             	mov    %eax,(%esp)
  80158d:	e8 34 fb ff ff       	call   8010c6 <fd_lookup>
  801592:	89 c2                	mov    %eax,%edx
  801594:	85 d2                	test   %edx,%edx
  801596:	78 52                	js     8015ea <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801598:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80159f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a2:	8b 00                	mov    (%eax),%eax
  8015a4:	89 04 24             	mov    %eax,(%esp)
  8015a7:	e8 70 fb ff ff       	call   80111c <dev_lookup>
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 3a                	js     8015ea <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015b7:	74 2c                	je     8015e5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015b9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015bc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015c3:	00 00 00 
	stat->st_isdir = 0;
  8015c6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015cd:	00 00 00 
	stat->st_dev = dev;
  8015d0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015dd:	89 14 24             	mov    %edx,(%esp)
  8015e0:	ff 50 14             	call   *0x14(%eax)
  8015e3:	eb 05                	jmp    8015ea <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8015e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8015ea:	83 c4 24             	add    $0x24,%esp
  8015ed:	5b                   	pop    %ebx
  8015ee:	5d                   	pop    %ebp
  8015ef:	c3                   	ret    

008015f0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	56                   	push   %esi
  8015f4:	53                   	push   %ebx
  8015f5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015ff:	00 
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	89 04 24             	mov    %eax,(%esp)
  801606:	e8 84 02 00 00       	call   80188f <open>
  80160b:	89 c3                	mov    %eax,%ebx
  80160d:	85 db                	test   %ebx,%ebx
  80160f:	78 1b                	js     80162c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801611:	8b 45 0c             	mov    0xc(%ebp),%eax
  801614:	89 44 24 04          	mov    %eax,0x4(%esp)
  801618:	89 1c 24             	mov    %ebx,(%esp)
  80161b:	e8 56 ff ff ff       	call   801576 <fstat>
  801620:	89 c6                	mov    %eax,%esi
	close(fd);
  801622:	89 1c 24             	mov    %ebx,(%esp)
  801625:	e8 cd fb ff ff       	call   8011f7 <close>
	return r;
  80162a:	89 f0                	mov    %esi,%eax
}
  80162c:	83 c4 10             	add    $0x10,%esp
  80162f:	5b                   	pop    %ebx
  801630:	5e                   	pop    %esi
  801631:	5d                   	pop    %ebp
  801632:	c3                   	ret    

00801633 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	56                   	push   %esi
  801637:	53                   	push   %ebx
  801638:	83 ec 10             	sub    $0x10,%esp
  80163b:	89 c6                	mov    %eax,%esi
  80163d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80163f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801646:	75 11                	jne    801659 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801648:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80164f:	e8 51 0f 00 00       	call   8025a5 <ipc_find_env>
  801654:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801659:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801660:	00 
  801661:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801668:	00 
  801669:	89 74 24 04          	mov    %esi,0x4(%esp)
  80166d:	a1 00 40 80 00       	mov    0x804000,%eax
  801672:	89 04 24             	mov    %eax,(%esp)
  801675:	e8 9e 0e 00 00       	call   802518 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80167a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801681:	00 
  801682:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801686:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80168d:	e8 1e 0e 00 00       	call   8024b0 <ipc_recv>
}
  801692:	83 c4 10             	add    $0x10,%esp
  801695:	5b                   	pop    %ebx
  801696:	5e                   	pop    %esi
  801697:	5d                   	pop    %ebp
  801698:	c3                   	ret    

00801699 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a5:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  8016aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ad:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b7:	b8 02 00 00 00       	mov    $0x2,%eax
  8016bc:	e8 72 ff ff ff       	call   801633 <fsipc>
}
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8016cf:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8016d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d9:	b8 06 00 00 00       	mov    $0x6,%eax
  8016de:	e8 50 ff ff ff       	call   801633 <fsipc>
}
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	53                   	push   %ebx
  8016e9:	83 ec 14             	sub    $0x14,%esp
  8016ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f5:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ff:	b8 05 00 00 00       	mov    $0x5,%eax
  801704:	e8 2a ff ff ff       	call   801633 <fsipc>
  801709:	89 c2                	mov    %eax,%edx
  80170b:	85 d2                	test   %edx,%edx
  80170d:	78 2b                	js     80173a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80170f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801716:	00 
  801717:	89 1c 24             	mov    %ebx,(%esp)
  80171a:	e8 c8 f1 ff ff       	call   8008e7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80171f:	a1 80 70 80 00       	mov    0x807080,%eax
  801724:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80172a:	a1 84 70 80 00       	mov    0x807084,%eax
  80172f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173a:	83 c4 14             	add    $0x14,%esp
  80173d:	5b                   	pop    %ebx
  80173e:	5d                   	pop    %ebp
  80173f:	c3                   	ret    

00801740 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	53                   	push   %ebx
  801744:	83 ec 14             	sub    $0x14,%esp
  801747:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8b 40 0c             	mov    0xc(%eax),%eax
  801750:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801755:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80175b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801760:	0f 46 c3             	cmovbe %ebx,%eax
  801763:	a3 04 70 80 00       	mov    %eax,0x807004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801768:	89 44 24 08          	mov    %eax,0x8(%esp)
  80176c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801773:	c7 04 24 08 70 80 00 	movl   $0x807008,(%esp)
  80177a:	e8 05 f3 ff ff       	call   800a84 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80177f:	ba 00 00 00 00       	mov    $0x0,%edx
  801784:	b8 04 00 00 00       	mov    $0x4,%eax
  801789:	e8 a5 fe ff ff       	call   801633 <fsipc>
  80178e:	85 c0                	test   %eax,%eax
  801790:	78 53                	js     8017e5 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801792:	39 c3                	cmp    %eax,%ebx
  801794:	73 24                	jae    8017ba <devfile_write+0x7a>
  801796:	c7 44 24 0c 08 2d 80 	movl   $0x802d08,0xc(%esp)
  80179d:	00 
  80179e:	c7 44 24 08 0f 2d 80 	movl   $0x802d0f,0x8(%esp)
  8017a5:	00 
  8017a6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  8017ad:	00 
  8017ae:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  8017b5:	e8 0c ea ff ff       	call   8001c6 <_panic>
	assert(r <= PGSIZE);
  8017ba:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017bf:	7e 24                	jle    8017e5 <devfile_write+0xa5>
  8017c1:	c7 44 24 0c 2f 2d 80 	movl   $0x802d2f,0xc(%esp)
  8017c8:	00 
  8017c9:	c7 44 24 08 0f 2d 80 	movl   $0x802d0f,0x8(%esp)
  8017d0:	00 
  8017d1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  8017d8:	00 
  8017d9:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  8017e0:	e8 e1 e9 ff ff       	call   8001c6 <_panic>
	return r;
}
  8017e5:	83 c4 14             	add    $0x14,%esp
  8017e8:	5b                   	pop    %ebx
  8017e9:	5d                   	pop    %ebp
  8017ea:	c3                   	ret    

008017eb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	56                   	push   %esi
  8017ef:	53                   	push   %ebx
  8017f0:	83 ec 10             	sub    $0x10,%esp
  8017f3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8017fc:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801801:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801807:	ba 00 00 00 00       	mov    $0x0,%edx
  80180c:	b8 03 00 00 00       	mov    $0x3,%eax
  801811:	e8 1d fe ff ff       	call   801633 <fsipc>
  801816:	89 c3                	mov    %eax,%ebx
  801818:	85 c0                	test   %eax,%eax
  80181a:	78 6a                	js     801886 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  80181c:	39 c6                	cmp    %eax,%esi
  80181e:	73 24                	jae    801844 <devfile_read+0x59>
  801820:	c7 44 24 0c 08 2d 80 	movl   $0x802d08,0xc(%esp)
  801827:	00 
  801828:	c7 44 24 08 0f 2d 80 	movl   $0x802d0f,0x8(%esp)
  80182f:	00 
  801830:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801837:	00 
  801838:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  80183f:	e8 82 e9 ff ff       	call   8001c6 <_panic>
	assert(r <= PGSIZE);
  801844:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801849:	7e 24                	jle    80186f <devfile_read+0x84>
  80184b:	c7 44 24 0c 2f 2d 80 	movl   $0x802d2f,0xc(%esp)
  801852:	00 
  801853:	c7 44 24 08 0f 2d 80 	movl   $0x802d0f,0x8(%esp)
  80185a:	00 
  80185b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801862:	00 
  801863:	c7 04 24 24 2d 80 00 	movl   $0x802d24,(%esp)
  80186a:	e8 57 e9 ff ff       	call   8001c6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80186f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801873:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80187a:	00 
  80187b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187e:	89 04 24             	mov    %eax,(%esp)
  801881:	e8 fe f1 ff ff       	call   800a84 <memmove>
	return r;
}
  801886:	89 d8                	mov    %ebx,%eax
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	5b                   	pop    %ebx
  80188c:	5e                   	pop    %esi
  80188d:	5d                   	pop    %ebp
  80188e:	c3                   	ret    

0080188f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	53                   	push   %ebx
  801893:	83 ec 24             	sub    $0x24,%esp
  801896:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801899:	89 1c 24             	mov    %ebx,(%esp)
  80189c:	e8 0f f0 ff ff       	call   8008b0 <strlen>
  8018a1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018a6:	7f 60                	jg     801908 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ab:	89 04 24             	mov    %eax,(%esp)
  8018ae:	e8 c4 f7 ff ff       	call   801077 <fd_alloc>
  8018b3:	89 c2                	mov    %eax,%edx
  8018b5:	85 d2                	test   %edx,%edx
  8018b7:	78 54                	js     80190d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018b9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018bd:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  8018c4:	e8 1e f0 ff ff       	call   8008e7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d9:	e8 55 fd ff ff       	call   801633 <fsipc>
  8018de:	89 c3                	mov    %eax,%ebx
  8018e0:	85 c0                	test   %eax,%eax
  8018e2:	79 17                	jns    8018fb <open+0x6c>
		fd_close(fd, 0);
  8018e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018eb:	00 
  8018ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ef:	89 04 24             	mov    %eax,(%esp)
  8018f2:	e8 7f f8 ff ff       	call   801176 <fd_close>
		return r;
  8018f7:	89 d8                	mov    %ebx,%eax
  8018f9:	eb 12                	jmp    80190d <open+0x7e>
	}

	return fd2num(fd);
  8018fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fe:	89 04 24             	mov    %eax,(%esp)
  801901:	e8 4a f7 ff ff       	call   801050 <fd2num>
  801906:	eb 05                	jmp    80190d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801908:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80190d:	83 c4 24             	add    $0x24,%esp
  801910:	5b                   	pop    %ebx
  801911:	5d                   	pop    %ebp
  801912:	c3                   	ret    

00801913 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801919:	ba 00 00 00 00       	mov    $0x0,%edx
  80191e:	b8 08 00 00 00       	mov    $0x8,%eax
  801923:	e8 0b fd ff ff       	call   801633 <fsipc>
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	53                   	push   %ebx
  80192e:	83 ec 14             	sub    $0x14,%esp
  801931:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801933:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801937:	7e 31                	jle    80196a <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801939:	8b 40 04             	mov    0x4(%eax),%eax
  80193c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801940:	8d 43 10             	lea    0x10(%ebx),%eax
  801943:	89 44 24 04          	mov    %eax,0x4(%esp)
  801947:	8b 03                	mov    (%ebx),%eax
  801949:	89 04 24             	mov    %eax,(%esp)
  80194c:	e8 e6 fa ff ff       	call   801437 <write>
		if (result > 0)
  801951:	85 c0                	test   %eax,%eax
  801953:	7e 03                	jle    801958 <writebuf+0x2e>
			b->result += result;
  801955:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801958:	39 43 04             	cmp    %eax,0x4(%ebx)
  80195b:	74 0d                	je     80196a <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  80195d:	85 c0                	test   %eax,%eax
  80195f:	ba 00 00 00 00       	mov    $0x0,%edx
  801964:	0f 4f c2             	cmovg  %edx,%eax
  801967:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80196a:	83 c4 14             	add    $0x14,%esp
  80196d:	5b                   	pop    %ebx
  80196e:	5d                   	pop    %ebp
  80196f:	c3                   	ret    

00801970 <putch>:

static void
putch(int ch, void *thunk)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	53                   	push   %ebx
  801974:	83 ec 04             	sub    $0x4,%esp
  801977:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80197a:	8b 53 04             	mov    0x4(%ebx),%edx
  80197d:	8d 42 01             	lea    0x1(%edx),%eax
  801980:	89 43 04             	mov    %eax,0x4(%ebx)
  801983:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801986:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80198a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80198f:	75 0e                	jne    80199f <putch+0x2f>
		writebuf(b);
  801991:	89 d8                	mov    %ebx,%eax
  801993:	e8 92 ff ff ff       	call   80192a <writebuf>
		b->idx = 0;
  801998:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  80199f:	83 c4 04             	add    $0x4,%esp
  8019a2:	5b                   	pop    %ebx
  8019a3:	5d                   	pop    %ebp
  8019a4:	c3                   	ret    

008019a5 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8019b7:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8019be:	00 00 00 
	b.result = 0;
  8019c1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8019c8:	00 00 00 
	b.error = 1;
  8019cb:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8019d2:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8019d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019e3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8019e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ed:	c7 04 24 70 19 80 00 	movl   $0x801970,(%esp)
  8019f4:	e8 55 ea ff ff       	call   80044e <vprintfmt>
	if (b.idx > 0)
  8019f9:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801a00:	7e 0b                	jle    801a0d <vfprintf+0x68>
		writebuf(&b);
  801a02:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801a08:	e8 1d ff ff ff       	call   80192a <writebuf>

	return (b.result ? b.result : b.error);
  801a0d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801a13:	85 c0                	test   %eax,%eax
  801a15:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
  801a21:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a24:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801a27:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	89 04 24             	mov    %eax,(%esp)
  801a38:	e8 68 ff ff ff       	call   8019a5 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <printf>:

int
printf(const char *fmt, ...)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801a45:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801a48:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a5a:	e8 46 ff ff ff       	call   8019a5 <vfprintf>
	va_end(ap);

	return cnt;
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    
  801a61:	66 90                	xchg   %ax,%ax
  801a63:	66 90                	xchg   %ax,%ax
  801a65:	66 90                	xchg   %ax,%ax
  801a67:	66 90                	xchg   %ax,%ax
  801a69:	66 90                	xchg   %ax,%ax
  801a6b:	66 90                	xchg   %ax,%ax
  801a6d:	66 90                	xchg   %ax,%ax
  801a6f:	90                   	nop

00801a70 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801a76:	c7 44 24 04 3b 2d 80 	movl   $0x802d3b,0x4(%esp)
  801a7d:	00 
  801a7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a81:	89 04 24             	mov    %eax,(%esp)
  801a84:	e8 5e ee ff ff       	call   8008e7 <strcpy>
	return 0;
}
  801a89:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	53                   	push   %ebx
  801a94:	83 ec 14             	sub    $0x14,%esp
  801a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a9a:	89 1c 24             	mov    %ebx,(%esp)
  801a9d:	e8 3d 0b 00 00       	call   8025df <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801aa2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801aa7:	83 f8 01             	cmp    $0x1,%eax
  801aaa:	75 0d                	jne    801ab9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801aac:	8b 43 0c             	mov    0xc(%ebx),%eax
  801aaf:	89 04 24             	mov    %eax,(%esp)
  801ab2:	e8 29 03 00 00       	call   801de0 <nsipc_close>
  801ab7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801ab9:	89 d0                	mov    %edx,%eax
  801abb:	83 c4 14             	add    $0x14,%esp
  801abe:	5b                   	pop    %ebx
  801abf:	5d                   	pop    %ebp
  801ac0:	c3                   	ret    

00801ac1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ac7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801ace:	00 
  801acf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801add:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae3:	89 04 24             	mov    %eax,(%esp)
  801ae6:	e8 f0 03 00 00       	call   801edb <nsipc_send>
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801af3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801afa:	00 
  801afb:	8b 45 10             	mov    0x10(%ebp),%eax
  801afe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b05:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801b0f:	89 04 24             	mov    %eax,(%esp)
  801b12:	e8 44 03 00 00       	call   801e5b <nsipc_recv>
}
  801b17:	c9                   	leave  
  801b18:	c3                   	ret    

00801b19 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b1f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b22:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b26:	89 04 24             	mov    %eax,(%esp)
  801b29:	e8 98 f5 ff ff       	call   8010c6 <fd_lookup>
  801b2e:	85 c0                	test   %eax,%eax
  801b30:	78 17                	js     801b49 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b35:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801b3b:	39 08                	cmp    %ecx,(%eax)
  801b3d:	75 05                	jne    801b44 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801b3f:	8b 40 0c             	mov    0xc(%eax),%eax
  801b42:	eb 05                	jmp    801b49 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801b44:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
  801b4e:	56                   	push   %esi
  801b4f:	53                   	push   %ebx
  801b50:	83 ec 20             	sub    $0x20,%esp
  801b53:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801b55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b58:	89 04 24             	mov    %eax,(%esp)
  801b5b:	e8 17 f5 ff ff       	call   801077 <fd_alloc>
  801b60:	89 c3                	mov    %eax,%ebx
  801b62:	85 c0                	test   %eax,%eax
  801b64:	78 21                	js     801b87 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b66:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b6d:	00 
  801b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b7c:	e8 82 f1 ff ff       	call   800d03 <sys_page_alloc>
  801b81:	89 c3                	mov    %eax,%ebx
  801b83:	85 c0                	test   %eax,%eax
  801b85:	79 0c                	jns    801b93 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801b87:	89 34 24             	mov    %esi,(%esp)
  801b8a:	e8 51 02 00 00       	call   801de0 <nsipc_close>
		return r;
  801b8f:	89 d8                	mov    %ebx,%eax
  801b91:	eb 20                	jmp    801bb3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801b93:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801ba8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801bab:	89 14 24             	mov    %edx,(%esp)
  801bae:	e8 9d f4 ff ff       	call   801050 <fd2num>
}
  801bb3:	83 c4 20             	add    $0x20,%esp
  801bb6:	5b                   	pop    %ebx
  801bb7:	5e                   	pop    %esi
  801bb8:	5d                   	pop    %ebp
  801bb9:	c3                   	ret    

00801bba <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc3:	e8 51 ff ff ff       	call   801b19 <fd2sockid>
		return r;
  801bc8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	78 23                	js     801bf1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bce:	8b 55 10             	mov    0x10(%ebp),%edx
  801bd1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bdc:	89 04 24             	mov    %eax,(%esp)
  801bdf:	e8 45 01 00 00       	call   801d29 <nsipc_accept>
		return r;
  801be4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801be6:	85 c0                	test   %eax,%eax
  801be8:	78 07                	js     801bf1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801bea:	e8 5c ff ff ff       	call   801b4b <alloc_sockfd>
  801bef:	89 c1                	mov    %eax,%ecx
}
  801bf1:	89 c8                	mov    %ecx,%eax
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	e8 16 ff ff ff       	call   801b19 <fd2sockid>
  801c03:	89 c2                	mov    %eax,%edx
  801c05:	85 d2                	test   %edx,%edx
  801c07:	78 16                	js     801c1f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c17:	89 14 24             	mov    %edx,(%esp)
  801c1a:	e8 60 01 00 00       	call   801d7f <nsipc_bind>
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <shutdown>:

int
shutdown(int s, int how)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	e8 ea fe ff ff       	call   801b19 <fd2sockid>
  801c2f:	89 c2                	mov    %eax,%edx
  801c31:	85 d2                	test   %edx,%edx
  801c33:	78 0f                	js     801c44 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3c:	89 14 24             	mov    %edx,(%esp)
  801c3f:	e8 7a 01 00 00       	call   801dbe <nsipc_shutdown>
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
  801c49:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	e8 c5 fe ff ff       	call   801b19 <fd2sockid>
  801c54:	89 c2                	mov    %eax,%edx
  801c56:	85 d2                	test   %edx,%edx
  801c58:	78 16                	js     801c70 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801c5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c68:	89 14 24             	mov    %edx,(%esp)
  801c6b:	e8 8a 01 00 00       	call   801dfa <nsipc_connect>
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <listen>:

int
listen(int s, int backlog)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
  801c75:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c78:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7b:	e8 99 fe ff ff       	call   801b19 <fd2sockid>
  801c80:	89 c2                	mov    %eax,%edx
  801c82:	85 d2                	test   %edx,%edx
  801c84:	78 0f                	js     801c95 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c8d:	89 14 24             	mov    %edx,(%esp)
  801c90:	e8 a4 01 00 00       	call   801e39 <nsipc_listen>
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
  801c9a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	89 04 24             	mov    %eax,(%esp)
  801cb1:	e8 98 02 00 00       	call   801f4e <nsipc_socket>
  801cb6:	89 c2                	mov    %eax,%edx
  801cb8:	85 d2                	test   %edx,%edx
  801cba:	78 05                	js     801cc1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801cbc:	e8 8a fe ff ff       	call   801b4b <alloc_sockfd>
}
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	53                   	push   %ebx
  801cc7:	83 ec 14             	sub    $0x14,%esp
  801cca:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ccc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801cd3:	75 11                	jne    801ce6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801cd5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801cdc:	e8 c4 08 00 00       	call   8025a5 <ipc_find_env>
  801ce1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ce6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ced:	00 
  801cee:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  801cf5:	00 
  801cf6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cfa:	a1 04 40 80 00       	mov    0x804004,%eax
  801cff:	89 04 24             	mov    %eax,(%esp)
  801d02:	e8 11 08 00 00       	call   802518 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801d07:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d0e:	00 
  801d0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d16:	00 
  801d17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d1e:	e8 8d 07 00 00       	call   8024b0 <ipc_recv>
}
  801d23:	83 c4 14             	add    $0x14,%esp
  801d26:	5b                   	pop    %ebx
  801d27:	5d                   	pop    %ebp
  801d28:	c3                   	ret    

00801d29 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
  801d2c:	56                   	push   %esi
  801d2d:	53                   	push   %ebx
  801d2e:	83 ec 10             	sub    $0x10,%esp
  801d31:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801d34:	8b 45 08             	mov    0x8(%ebp),%eax
  801d37:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801d3c:	8b 06                	mov    (%esi),%eax
  801d3e:	a3 04 80 80 00       	mov    %eax,0x808004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801d43:	b8 01 00 00 00       	mov    $0x1,%eax
  801d48:	e8 76 ff ff ff       	call   801cc3 <nsipc>
  801d4d:	89 c3                	mov    %eax,%ebx
  801d4f:	85 c0                	test   %eax,%eax
  801d51:	78 23                	js     801d76 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d53:	a1 10 80 80 00       	mov    0x808010,%eax
  801d58:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d5c:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801d63:	00 
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	89 04 24             	mov    %eax,(%esp)
  801d6a:	e8 15 ed ff ff       	call   800a84 <memmove>
		*addrlen = ret->ret_addrlen;
  801d6f:	a1 10 80 80 00       	mov    0x808010,%eax
  801d74:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801d76:	89 d8                	mov    %ebx,%eax
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	5b                   	pop    %ebx
  801d7c:	5e                   	pop    %esi
  801d7d:	5d                   	pop    %ebp
  801d7e:	c3                   	ret    

00801d7f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	53                   	push   %ebx
  801d83:	83 ec 14             	sub    $0x14,%esp
  801d86:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9c:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  801da3:	e8 dc ec ff ff       	call   800a84 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801da8:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  801dae:	b8 02 00 00 00       	mov    $0x2,%eax
  801db3:	e8 0b ff ff ff       	call   801cc3 <nsipc>
}
  801db8:	83 c4 14             	add    $0x14,%esp
  801dbb:	5b                   	pop    %ebx
  801dbc:	5d                   	pop    %ebp
  801dbd:	c3                   	ret    

00801dbe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  801dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dcf:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  801dd4:	b8 03 00 00 00       	mov    $0x3,%eax
  801dd9:	e8 e5 fe ff ff       	call   801cc3 <nsipc>
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <nsipc_close>:

int
nsipc_close(int s)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
  801de3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  801dee:	b8 04 00 00 00       	mov    $0x4,%eax
  801df3:	e8 cb fe ff ff       	call   801cc3 <nsipc>
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	53                   	push   %ebx
  801dfe:	83 ec 14             	sub    $0x14,%esp
  801e01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e0c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e17:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  801e1e:	e8 61 ec ff ff       	call   800a84 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e23:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  801e29:	b8 05 00 00 00       	mov    $0x5,%eax
  801e2e:	e8 90 fe ff ff       	call   801cc3 <nsipc>
}
  801e33:	83 c4 14             	add    $0x14,%esp
  801e36:	5b                   	pop    %ebx
  801e37:	5d                   	pop    %ebp
  801e38:	c3                   	ret    

00801e39 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  801e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4a:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  801e4f:	b8 06 00 00 00       	mov    $0x6,%eax
  801e54:	e8 6a fe ff ff       	call   801cc3 <nsipc>
}
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	56                   	push   %esi
  801e5f:	53                   	push   %ebx
  801e60:	83 ec 10             	sub    $0x10,%esp
  801e63:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  801e6e:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  801e74:	8b 45 14             	mov    0x14(%ebp),%eax
  801e77:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e7c:	b8 07 00 00 00       	mov    $0x7,%eax
  801e81:	e8 3d fe ff ff       	call   801cc3 <nsipc>
  801e86:	89 c3                	mov    %eax,%ebx
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	78 46                	js     801ed2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801e8c:	39 f0                	cmp    %esi,%eax
  801e8e:	7f 07                	jg     801e97 <nsipc_recv+0x3c>
  801e90:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e95:	7e 24                	jle    801ebb <nsipc_recv+0x60>
  801e97:	c7 44 24 0c 47 2d 80 	movl   $0x802d47,0xc(%esp)
  801e9e:	00 
  801e9f:	c7 44 24 08 0f 2d 80 	movl   $0x802d0f,0x8(%esp)
  801ea6:	00 
  801ea7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801eae:	00 
  801eaf:	c7 04 24 5c 2d 80 00 	movl   $0x802d5c,(%esp)
  801eb6:	e8 0b e3 ff ff       	call   8001c6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ebb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ebf:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801ec6:	00 
  801ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eca:	89 04 24             	mov    %eax,(%esp)
  801ecd:	e8 b2 eb ff ff       	call   800a84 <memmove>
	}

	return r;
}
  801ed2:	89 d8                	mov    %ebx,%eax
  801ed4:	83 c4 10             	add    $0x10,%esp
  801ed7:	5b                   	pop    %ebx
  801ed8:	5e                   	pop    %esi
  801ed9:	5d                   	pop    %ebp
  801eda:	c3                   	ret    

00801edb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	53                   	push   %ebx
  801edf:	83 ec 14             	sub    $0x14,%esp
  801ee2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee8:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  801eed:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ef3:	7e 24                	jle    801f19 <nsipc_send+0x3e>
  801ef5:	c7 44 24 0c 68 2d 80 	movl   $0x802d68,0xc(%esp)
  801efc:	00 
  801efd:	c7 44 24 08 0f 2d 80 	movl   $0x802d0f,0x8(%esp)
  801f04:	00 
  801f05:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801f0c:	00 
  801f0d:	c7 04 24 5c 2d 80 00 	movl   $0x802d5c,(%esp)
  801f14:	e8 ad e2 ff ff       	call   8001c6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f24:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  801f2b:	e8 54 eb ff ff       	call   800a84 <memmove>
	nsipcbuf.send.req_size = size;
  801f30:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  801f36:	8b 45 14             	mov    0x14(%ebp),%eax
  801f39:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  801f3e:	b8 08 00 00 00       	mov    $0x8,%eax
  801f43:	e8 7b fd ff ff       	call   801cc3 <nsipc>
}
  801f48:	83 c4 14             	add    $0x14,%esp
  801f4b:	5b                   	pop    %ebx
  801f4c:	5d                   	pop    %ebp
  801f4d:	c3                   	ret    

00801f4e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  801f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5f:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  801f64:	8b 45 10             	mov    0x10(%ebp),%eax
  801f67:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  801f6c:	b8 09 00 00 00       	mov    $0x9,%eax
  801f71:	e8 4d fd ff ff       	call   801cc3 <nsipc>
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	56                   	push   %esi
  801f7c:	53                   	push   %ebx
  801f7d:	83 ec 10             	sub    $0x10,%esp
  801f80:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	89 04 24             	mov    %eax,(%esp)
  801f89:	e8 d2 f0 ff ff       	call   801060 <fd2data>
  801f8e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f90:	c7 44 24 04 74 2d 80 	movl   $0x802d74,0x4(%esp)
  801f97:	00 
  801f98:	89 1c 24             	mov    %ebx,(%esp)
  801f9b:	e8 47 e9 ff ff       	call   8008e7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801fa0:	8b 46 04             	mov    0x4(%esi),%eax
  801fa3:	2b 06                	sub    (%esi),%eax
  801fa5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801fab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801fb2:	00 00 00 
	stat->st_dev = &devpipe;
  801fb5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801fbc:	30 80 00 
	return 0;
}
  801fbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc4:	83 c4 10             	add    $0x10,%esp
  801fc7:	5b                   	pop    %ebx
  801fc8:	5e                   	pop    %esi
  801fc9:	5d                   	pop    %ebp
  801fca:	c3                   	ret    

00801fcb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	53                   	push   %ebx
  801fcf:	83 ec 14             	sub    $0x14,%esp
  801fd2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801fd5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe0:	e8 c5 ed ff ff       	call   800daa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801fe5:	89 1c 24             	mov    %ebx,(%esp)
  801fe8:	e8 73 f0 ff ff       	call   801060 <fd2data>
  801fed:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ff8:	e8 ad ed ff ff       	call   800daa <sys_page_unmap>
}
  801ffd:	83 c4 14             	add    $0x14,%esp
  802000:	5b                   	pop    %ebx
  802001:	5d                   	pop    %ebp
  802002:	c3                   	ret    

00802003 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	57                   	push   %edi
  802007:	56                   	push   %esi
  802008:	53                   	push   %ebx
  802009:	83 ec 2c             	sub    $0x2c,%esp
  80200c:	89 c6                	mov    %eax,%esi
  80200e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802011:	a1 20 60 80 00       	mov    0x806020,%eax
  802016:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802019:	89 34 24             	mov    %esi,(%esp)
  80201c:	e8 be 05 00 00       	call   8025df <pageref>
  802021:	89 c7                	mov    %eax,%edi
  802023:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802026:	89 04 24             	mov    %eax,(%esp)
  802029:	e8 b1 05 00 00       	call   8025df <pageref>
  80202e:	39 c7                	cmp    %eax,%edi
  802030:	0f 94 c2             	sete   %dl
  802033:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802036:	8b 0d 20 60 80 00    	mov    0x806020,%ecx
  80203c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80203f:	39 fb                	cmp    %edi,%ebx
  802041:	74 21                	je     802064 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802043:	84 d2                	test   %dl,%dl
  802045:	74 ca                	je     802011 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802047:	8b 51 58             	mov    0x58(%ecx),%edx
  80204a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80204e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802052:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802056:	c7 04 24 7b 2d 80 00 	movl   $0x802d7b,(%esp)
  80205d:	e8 5d e2 ff ff       	call   8002bf <cprintf>
  802062:	eb ad                	jmp    802011 <_pipeisclosed+0xe>
	}
}
  802064:	83 c4 2c             	add    $0x2c,%esp
  802067:	5b                   	pop    %ebx
  802068:	5e                   	pop    %esi
  802069:	5f                   	pop    %edi
  80206a:	5d                   	pop    %ebp
  80206b:	c3                   	ret    

0080206c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	57                   	push   %edi
  802070:	56                   	push   %esi
  802071:	53                   	push   %ebx
  802072:	83 ec 1c             	sub    $0x1c,%esp
  802075:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802078:	89 34 24             	mov    %esi,(%esp)
  80207b:	e8 e0 ef ff ff       	call   801060 <fd2data>
  802080:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802082:	bf 00 00 00 00       	mov    $0x0,%edi
  802087:	eb 45                	jmp    8020ce <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802089:	89 da                	mov    %ebx,%edx
  80208b:	89 f0                	mov    %esi,%eax
  80208d:	e8 71 ff ff ff       	call   802003 <_pipeisclosed>
  802092:	85 c0                	test   %eax,%eax
  802094:	75 41                	jne    8020d7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802096:	e8 49 ec ff ff       	call   800ce4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80209b:	8b 43 04             	mov    0x4(%ebx),%eax
  80209e:	8b 0b                	mov    (%ebx),%ecx
  8020a0:	8d 51 20             	lea    0x20(%ecx),%edx
  8020a3:	39 d0                	cmp    %edx,%eax
  8020a5:	73 e2                	jae    802089 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020aa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8020ae:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8020b1:	99                   	cltd   
  8020b2:	c1 ea 1b             	shr    $0x1b,%edx
  8020b5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8020b8:	83 e1 1f             	and    $0x1f,%ecx
  8020bb:	29 d1                	sub    %edx,%ecx
  8020bd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8020c1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8020c5:	83 c0 01             	add    $0x1,%eax
  8020c8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020cb:	83 c7 01             	add    $0x1,%edi
  8020ce:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8020d1:	75 c8                	jne    80209b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8020d3:	89 f8                	mov    %edi,%eax
  8020d5:	eb 05                	jmp    8020dc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8020d7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8020dc:	83 c4 1c             	add    $0x1c,%esp
  8020df:	5b                   	pop    %ebx
  8020e0:	5e                   	pop    %esi
  8020e1:	5f                   	pop    %edi
  8020e2:	5d                   	pop    %ebp
  8020e3:	c3                   	ret    

008020e4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
  8020e7:	57                   	push   %edi
  8020e8:	56                   	push   %esi
  8020e9:	53                   	push   %ebx
  8020ea:	83 ec 1c             	sub    $0x1c,%esp
  8020ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8020f0:	89 3c 24             	mov    %edi,(%esp)
  8020f3:	e8 68 ef ff ff       	call   801060 <fd2data>
  8020f8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020fa:	be 00 00 00 00       	mov    $0x0,%esi
  8020ff:	eb 3d                	jmp    80213e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802101:	85 f6                	test   %esi,%esi
  802103:	74 04                	je     802109 <devpipe_read+0x25>
				return i;
  802105:	89 f0                	mov    %esi,%eax
  802107:	eb 43                	jmp    80214c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802109:	89 da                	mov    %ebx,%edx
  80210b:	89 f8                	mov    %edi,%eax
  80210d:	e8 f1 fe ff ff       	call   802003 <_pipeisclosed>
  802112:	85 c0                	test   %eax,%eax
  802114:	75 31                	jne    802147 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802116:	e8 c9 eb ff ff       	call   800ce4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80211b:	8b 03                	mov    (%ebx),%eax
  80211d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802120:	74 df                	je     802101 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802122:	99                   	cltd   
  802123:	c1 ea 1b             	shr    $0x1b,%edx
  802126:	01 d0                	add    %edx,%eax
  802128:	83 e0 1f             	and    $0x1f,%eax
  80212b:	29 d0                	sub    %edx,%eax
  80212d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802132:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802135:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802138:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80213b:	83 c6 01             	add    $0x1,%esi
  80213e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802141:	75 d8                	jne    80211b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802143:	89 f0                	mov    %esi,%eax
  802145:	eb 05                	jmp    80214c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802147:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80214c:	83 c4 1c             	add    $0x1c,%esp
  80214f:	5b                   	pop    %ebx
  802150:	5e                   	pop    %esi
  802151:	5f                   	pop    %edi
  802152:	5d                   	pop    %ebp
  802153:	c3                   	ret    

00802154 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	56                   	push   %esi
  802158:	53                   	push   %ebx
  802159:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80215c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80215f:	89 04 24             	mov    %eax,(%esp)
  802162:	e8 10 ef ff ff       	call   801077 <fd_alloc>
  802167:	89 c2                	mov    %eax,%edx
  802169:	85 d2                	test   %edx,%edx
  80216b:	0f 88 4d 01 00 00    	js     8022be <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802171:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802178:	00 
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802180:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802187:	e8 77 eb ff ff       	call   800d03 <sys_page_alloc>
  80218c:	89 c2                	mov    %eax,%edx
  80218e:	85 d2                	test   %edx,%edx
  802190:	0f 88 28 01 00 00    	js     8022be <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802196:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802199:	89 04 24             	mov    %eax,(%esp)
  80219c:	e8 d6 ee ff ff       	call   801077 <fd_alloc>
  8021a1:	89 c3                	mov    %eax,%ebx
  8021a3:	85 c0                	test   %eax,%eax
  8021a5:	0f 88 fe 00 00 00    	js     8022a9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021ab:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021b2:	00 
  8021b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021c1:	e8 3d eb ff ff       	call   800d03 <sys_page_alloc>
  8021c6:	89 c3                	mov    %eax,%ebx
  8021c8:	85 c0                	test   %eax,%eax
  8021ca:	0f 88 d9 00 00 00    	js     8022a9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8021d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d3:	89 04 24             	mov    %eax,(%esp)
  8021d6:	e8 85 ee ff ff       	call   801060 <fd2data>
  8021db:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021dd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021e4:	00 
  8021e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021f0:	e8 0e eb ff ff       	call   800d03 <sys_page_alloc>
  8021f5:	89 c3                	mov    %eax,%ebx
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	0f 88 97 00 00 00    	js     802296 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802202:	89 04 24             	mov    %eax,(%esp)
  802205:	e8 56 ee ff ff       	call   801060 <fd2data>
  80220a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802211:	00 
  802212:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802216:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80221d:	00 
  80221e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802222:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802229:	e8 29 eb ff ff       	call   800d57 <sys_page_map>
  80222e:	89 c3                	mov    %eax,%ebx
  802230:	85 c0                	test   %eax,%eax
  802232:	78 52                	js     802286 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802234:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80223a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802242:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802249:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80224f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802252:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802257:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	89 04 24             	mov    %eax,(%esp)
  802264:	e8 e7 ed ff ff       	call   801050 <fd2num>
  802269:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80226c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80226e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802271:	89 04 24             	mov    %eax,(%esp)
  802274:	e8 d7 ed ff ff       	call   801050 <fd2num>
  802279:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80227c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80227f:	b8 00 00 00 00       	mov    $0x0,%eax
  802284:	eb 38                	jmp    8022be <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802286:	89 74 24 04          	mov    %esi,0x4(%esp)
  80228a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802291:	e8 14 eb ff ff       	call   800daa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802296:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802299:	89 44 24 04          	mov    %eax,0x4(%esp)
  80229d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022a4:	e8 01 eb ff ff       	call   800daa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b7:	e8 ee ea ff ff       	call   800daa <sys_page_unmap>
  8022bc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8022be:	83 c4 30             	add    $0x30,%esp
  8022c1:	5b                   	pop    %ebx
  8022c2:	5e                   	pop    %esi
  8022c3:	5d                   	pop    %ebp
  8022c4:	c3                   	ret    

008022c5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	89 04 24             	mov    %eax,(%esp)
  8022d8:	e8 e9 ed ff ff       	call   8010c6 <fd_lookup>
  8022dd:	89 c2                	mov    %eax,%edx
  8022df:	85 d2                	test   %edx,%edx
  8022e1:	78 15                	js     8022f8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e6:	89 04 24             	mov    %eax,(%esp)
  8022e9:	e8 72 ed ff ff       	call   801060 <fd2data>
	return _pipeisclosed(fd, p);
  8022ee:	89 c2                	mov    %eax,%edx
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	e8 0b fd ff ff       	call   802003 <_pipeisclosed>
}
  8022f8:	c9                   	leave  
  8022f9:	c3                   	ret    
  8022fa:	66 90                	xchg   %ax,%ax
  8022fc:	66 90                	xchg   %ax,%ax
  8022fe:	66 90                	xchg   %ax,%ax

00802300 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802303:	b8 00 00 00 00       	mov    $0x0,%eax
  802308:	5d                   	pop    %ebp
  802309:	c3                   	ret    

0080230a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
  80230d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802310:	c7 44 24 04 93 2d 80 	movl   $0x802d93,0x4(%esp)
  802317:	00 
  802318:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231b:	89 04 24             	mov    %eax,(%esp)
  80231e:	e8 c4 e5 ff ff       	call   8008e7 <strcpy>
	return 0;
}
  802323:	b8 00 00 00 00       	mov    $0x0,%eax
  802328:	c9                   	leave  
  802329:	c3                   	ret    

0080232a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80232a:	55                   	push   %ebp
  80232b:	89 e5                	mov    %esp,%ebp
  80232d:	57                   	push   %edi
  80232e:	56                   	push   %esi
  80232f:	53                   	push   %ebx
  802330:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802336:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80233b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802341:	eb 31                	jmp    802374 <devcons_write+0x4a>
		m = n - tot;
  802343:	8b 75 10             	mov    0x10(%ebp),%esi
  802346:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802348:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80234b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802350:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802353:	89 74 24 08          	mov    %esi,0x8(%esp)
  802357:	03 45 0c             	add    0xc(%ebp),%eax
  80235a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80235e:	89 3c 24             	mov    %edi,(%esp)
  802361:	e8 1e e7 ff ff       	call   800a84 <memmove>
		sys_cputs(buf, m);
  802366:	89 74 24 04          	mov    %esi,0x4(%esp)
  80236a:	89 3c 24             	mov    %edi,(%esp)
  80236d:	e8 c4 e8 ff ff       	call   800c36 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802372:	01 f3                	add    %esi,%ebx
  802374:	89 d8                	mov    %ebx,%eax
  802376:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802379:	72 c8                	jb     802343 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80237b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5f                   	pop    %edi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    

00802386 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
  802389:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80238c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802391:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802395:	75 07                	jne    80239e <devcons_read+0x18>
  802397:	eb 2a                	jmp    8023c3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802399:	e8 46 e9 ff ff       	call   800ce4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80239e:	66 90                	xchg   %ax,%ax
  8023a0:	e8 af e8 ff ff       	call   800c54 <sys_cgetc>
  8023a5:	85 c0                	test   %eax,%eax
  8023a7:	74 f0                	je     802399 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	78 16                	js     8023c3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8023ad:	83 f8 04             	cmp    $0x4,%eax
  8023b0:	74 0c                	je     8023be <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8023b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b5:	88 02                	mov    %al,(%edx)
	return 1;
  8023b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8023bc:	eb 05                	jmp    8023c3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8023be:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
  8023c8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8023d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8023d8:	00 
  8023d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023dc:	89 04 24             	mov    %eax,(%esp)
  8023df:	e8 52 e8 ff ff       	call   800c36 <sys_cputs>
}
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <getchar>:

int
getchar(void)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
  8023e9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8023ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8023f3:	00 
  8023f4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802402:	e8 53 ef ff ff       	call   80135a <read>
	if (r < 0)
  802407:	85 c0                	test   %eax,%eax
  802409:	78 0f                	js     80241a <getchar+0x34>
		return r;
	if (r < 1)
  80240b:	85 c0                	test   %eax,%eax
  80240d:	7e 06                	jle    802415 <getchar+0x2f>
		return -E_EOF;
	return c;
  80240f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802413:	eb 05                	jmp    80241a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802415:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    

0080241c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
  80241f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802422:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802425:	89 44 24 04          	mov    %eax,0x4(%esp)
  802429:	8b 45 08             	mov    0x8(%ebp),%eax
  80242c:	89 04 24             	mov    %eax,(%esp)
  80242f:	e8 92 ec ff ff       	call   8010c6 <fd_lookup>
  802434:	85 c0                	test   %eax,%eax
  802436:	78 11                	js     802449 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802441:	39 10                	cmp    %edx,(%eax)
  802443:	0f 94 c0             	sete   %al
  802446:	0f b6 c0             	movzbl %al,%eax
}
  802449:	c9                   	leave  
  80244a:	c3                   	ret    

0080244b <opencons>:

int
opencons(void)
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
  80244e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802451:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802454:	89 04 24             	mov    %eax,(%esp)
  802457:	e8 1b ec ff ff       	call   801077 <fd_alloc>
		return r;
  80245c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80245e:	85 c0                	test   %eax,%eax
  802460:	78 40                	js     8024a2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802462:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802469:	00 
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802471:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802478:	e8 86 e8 ff ff       	call   800d03 <sys_page_alloc>
		return r;
  80247d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80247f:	85 c0                	test   %eax,%eax
  802481:	78 1f                	js     8024a2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802483:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802498:	89 04 24             	mov    %eax,(%esp)
  80249b:	e8 b0 eb ff ff       	call   801050 <fd2num>
  8024a0:	89 c2                	mov    %eax,%edx
}
  8024a2:	89 d0                	mov    %edx,%eax
  8024a4:	c9                   	leave  
  8024a5:	c3                   	ret    
  8024a6:	66 90                	xchg   %ax,%ax
  8024a8:	66 90                	xchg   %ax,%ax
  8024aa:	66 90                	xchg   %ax,%ax
  8024ac:	66 90                	xchg   %ax,%ax
  8024ae:	66 90                	xchg   %ax,%ax

008024b0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	56                   	push   %esi
  8024b4:	53                   	push   %ebx
  8024b5:	83 ec 10             	sub    $0x10,%esp
  8024b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8024bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8024c1:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  8024c3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8024c8:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  8024cb:	89 04 24             	mov    %eax,(%esp)
  8024ce:	e8 46 ea ff ff       	call   800f19 <sys_ipc_recv>
  8024d3:	85 c0                	test   %eax,%eax
  8024d5:	74 16                	je     8024ed <ipc_recv+0x3d>
		if (from_env_store != NULL)
  8024d7:	85 f6                	test   %esi,%esi
  8024d9:	74 06                	je     8024e1 <ipc_recv+0x31>
			*from_env_store = 0;
  8024db:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8024e1:	85 db                	test   %ebx,%ebx
  8024e3:	74 2c                	je     802511 <ipc_recv+0x61>
			*perm_store = 0;
  8024e5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8024eb:	eb 24                	jmp    802511 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8024ed:	85 f6                	test   %esi,%esi
  8024ef:	74 0a                	je     8024fb <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8024f1:	a1 20 60 80 00       	mov    0x806020,%eax
  8024f6:	8b 40 74             	mov    0x74(%eax),%eax
  8024f9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8024fb:	85 db                	test   %ebx,%ebx
  8024fd:	74 0a                	je     802509 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8024ff:	a1 20 60 80 00       	mov    0x806020,%eax
  802504:	8b 40 78             	mov    0x78(%eax),%eax
  802507:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802509:	a1 20 60 80 00       	mov    0x806020,%eax
  80250e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802511:	83 c4 10             	add    $0x10,%esp
  802514:	5b                   	pop    %ebx
  802515:	5e                   	pop    %esi
  802516:	5d                   	pop    %ebp
  802517:	c3                   	ret    

00802518 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
  80251b:	57                   	push   %edi
  80251c:	56                   	push   %esi
  80251d:	53                   	push   %ebx
  80251e:	83 ec 1c             	sub    $0x1c,%esp
  802521:	8b 75 0c             	mov    0xc(%ebp),%esi
  802524:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802527:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80252a:	85 db                	test   %ebx,%ebx
  80252c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802531:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802534:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802538:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80253c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802540:	8b 45 08             	mov    0x8(%ebp),%eax
  802543:	89 04 24             	mov    %eax,(%esp)
  802546:	e8 ab e9 ff ff       	call   800ef6 <sys_ipc_try_send>
	if (r == 0) return;
  80254b:	85 c0                	test   %eax,%eax
  80254d:	75 22                	jne    802571 <ipc_send+0x59>
  80254f:	eb 4c                	jmp    80259d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802551:	84 d2                	test   %dl,%dl
  802553:	75 48                	jne    80259d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802555:	e8 8a e7 ff ff       	call   800ce4 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80255a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80255e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802562:	89 74 24 04          	mov    %esi,0x4(%esp)
  802566:	8b 45 08             	mov    0x8(%ebp),%eax
  802569:	89 04 24             	mov    %eax,(%esp)
  80256c:	e8 85 e9 ff ff       	call   800ef6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802571:	85 c0                	test   %eax,%eax
  802573:	0f 94 c2             	sete   %dl
  802576:	74 d9                	je     802551 <ipc_send+0x39>
  802578:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80257b:	74 d4                	je     802551 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80257d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802581:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  802588:	00 
  802589:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802590:	00 
  802591:	c7 04 24 ad 2d 80 00 	movl   $0x802dad,(%esp)
  802598:	e8 29 dc ff ff       	call   8001c6 <_panic>
}
  80259d:	83 c4 1c             	add    $0x1c,%esp
  8025a0:	5b                   	pop    %ebx
  8025a1:	5e                   	pop    %esi
  8025a2:	5f                   	pop    %edi
  8025a3:	5d                   	pop    %ebp
  8025a4:	c3                   	ret    

008025a5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8025a5:	55                   	push   %ebp
  8025a6:	89 e5                	mov    %esp,%ebp
  8025a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8025ab:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8025b0:	89 c2                	mov    %eax,%edx
  8025b2:	c1 e2 07             	shl    $0x7,%edx
  8025b5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8025bb:	8b 52 50             	mov    0x50(%edx),%edx
  8025be:	39 ca                	cmp    %ecx,%edx
  8025c0:	75 0d                	jne    8025cf <ipc_find_env+0x2a>
			return envs[i].env_id;
  8025c2:	c1 e0 07             	shl    $0x7,%eax
  8025c5:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8025ca:	8b 40 40             	mov    0x40(%eax),%eax
  8025cd:	eb 0e                	jmp    8025dd <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8025cf:	83 c0 01             	add    $0x1,%eax
  8025d2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8025d7:	75 d7                	jne    8025b0 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8025d9:	66 b8 00 00          	mov    $0x0,%ax
}
  8025dd:	5d                   	pop    %ebp
  8025de:	c3                   	ret    

008025df <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
  8025e2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025e5:	89 d0                	mov    %edx,%eax
  8025e7:	c1 e8 16             	shr    $0x16,%eax
  8025ea:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025f1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025f6:	f6 c1 01             	test   $0x1,%cl
  8025f9:	74 1d                	je     802618 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8025fb:	c1 ea 0c             	shr    $0xc,%edx
  8025fe:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802605:	f6 c2 01             	test   $0x1,%dl
  802608:	74 0e                	je     802618 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80260a:	c1 ea 0c             	shr    $0xc,%edx
  80260d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802614:	ef 
  802615:	0f b7 c0             	movzwl %ax,%eax
}
  802618:	5d                   	pop    %ebp
  802619:	c3                   	ret    
  80261a:	66 90                	xchg   %ax,%ax
  80261c:	66 90                	xchg   %ax,%ax
  80261e:	66 90                	xchg   %ax,%ax

00802620 <__udivdi3>:
  802620:	55                   	push   %ebp
  802621:	57                   	push   %edi
  802622:	56                   	push   %esi
  802623:	83 ec 0c             	sub    $0xc,%esp
  802626:	8b 44 24 28          	mov    0x28(%esp),%eax
  80262a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80262e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802632:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802636:	85 c0                	test   %eax,%eax
  802638:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80263c:	89 ea                	mov    %ebp,%edx
  80263e:	89 0c 24             	mov    %ecx,(%esp)
  802641:	75 2d                	jne    802670 <__udivdi3+0x50>
  802643:	39 e9                	cmp    %ebp,%ecx
  802645:	77 61                	ja     8026a8 <__udivdi3+0x88>
  802647:	85 c9                	test   %ecx,%ecx
  802649:	89 ce                	mov    %ecx,%esi
  80264b:	75 0b                	jne    802658 <__udivdi3+0x38>
  80264d:	b8 01 00 00 00       	mov    $0x1,%eax
  802652:	31 d2                	xor    %edx,%edx
  802654:	f7 f1                	div    %ecx
  802656:	89 c6                	mov    %eax,%esi
  802658:	31 d2                	xor    %edx,%edx
  80265a:	89 e8                	mov    %ebp,%eax
  80265c:	f7 f6                	div    %esi
  80265e:	89 c5                	mov    %eax,%ebp
  802660:	89 f8                	mov    %edi,%eax
  802662:	f7 f6                	div    %esi
  802664:	89 ea                	mov    %ebp,%edx
  802666:	83 c4 0c             	add    $0xc,%esp
  802669:	5e                   	pop    %esi
  80266a:	5f                   	pop    %edi
  80266b:	5d                   	pop    %ebp
  80266c:	c3                   	ret    
  80266d:	8d 76 00             	lea    0x0(%esi),%esi
  802670:	39 e8                	cmp    %ebp,%eax
  802672:	77 24                	ja     802698 <__udivdi3+0x78>
  802674:	0f bd e8             	bsr    %eax,%ebp
  802677:	83 f5 1f             	xor    $0x1f,%ebp
  80267a:	75 3c                	jne    8026b8 <__udivdi3+0x98>
  80267c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802680:	39 34 24             	cmp    %esi,(%esp)
  802683:	0f 86 9f 00 00 00    	jbe    802728 <__udivdi3+0x108>
  802689:	39 d0                	cmp    %edx,%eax
  80268b:	0f 82 97 00 00 00    	jb     802728 <__udivdi3+0x108>
  802691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802698:	31 d2                	xor    %edx,%edx
  80269a:	31 c0                	xor    %eax,%eax
  80269c:	83 c4 0c             	add    $0xc,%esp
  80269f:	5e                   	pop    %esi
  8026a0:	5f                   	pop    %edi
  8026a1:	5d                   	pop    %ebp
  8026a2:	c3                   	ret    
  8026a3:	90                   	nop
  8026a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026a8:	89 f8                	mov    %edi,%eax
  8026aa:	f7 f1                	div    %ecx
  8026ac:	31 d2                	xor    %edx,%edx
  8026ae:	83 c4 0c             	add    $0xc,%esp
  8026b1:	5e                   	pop    %esi
  8026b2:	5f                   	pop    %edi
  8026b3:	5d                   	pop    %ebp
  8026b4:	c3                   	ret    
  8026b5:	8d 76 00             	lea    0x0(%esi),%esi
  8026b8:	89 e9                	mov    %ebp,%ecx
  8026ba:	8b 3c 24             	mov    (%esp),%edi
  8026bd:	d3 e0                	shl    %cl,%eax
  8026bf:	89 c6                	mov    %eax,%esi
  8026c1:	b8 20 00 00 00       	mov    $0x20,%eax
  8026c6:	29 e8                	sub    %ebp,%eax
  8026c8:	89 c1                	mov    %eax,%ecx
  8026ca:	d3 ef                	shr    %cl,%edi
  8026cc:	89 e9                	mov    %ebp,%ecx
  8026ce:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8026d2:	8b 3c 24             	mov    (%esp),%edi
  8026d5:	09 74 24 08          	or     %esi,0x8(%esp)
  8026d9:	89 d6                	mov    %edx,%esi
  8026db:	d3 e7                	shl    %cl,%edi
  8026dd:	89 c1                	mov    %eax,%ecx
  8026df:	89 3c 24             	mov    %edi,(%esp)
  8026e2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8026e6:	d3 ee                	shr    %cl,%esi
  8026e8:	89 e9                	mov    %ebp,%ecx
  8026ea:	d3 e2                	shl    %cl,%edx
  8026ec:	89 c1                	mov    %eax,%ecx
  8026ee:	d3 ef                	shr    %cl,%edi
  8026f0:	09 d7                	or     %edx,%edi
  8026f2:	89 f2                	mov    %esi,%edx
  8026f4:	89 f8                	mov    %edi,%eax
  8026f6:	f7 74 24 08          	divl   0x8(%esp)
  8026fa:	89 d6                	mov    %edx,%esi
  8026fc:	89 c7                	mov    %eax,%edi
  8026fe:	f7 24 24             	mull   (%esp)
  802701:	39 d6                	cmp    %edx,%esi
  802703:	89 14 24             	mov    %edx,(%esp)
  802706:	72 30                	jb     802738 <__udivdi3+0x118>
  802708:	8b 54 24 04          	mov    0x4(%esp),%edx
  80270c:	89 e9                	mov    %ebp,%ecx
  80270e:	d3 e2                	shl    %cl,%edx
  802710:	39 c2                	cmp    %eax,%edx
  802712:	73 05                	jae    802719 <__udivdi3+0xf9>
  802714:	3b 34 24             	cmp    (%esp),%esi
  802717:	74 1f                	je     802738 <__udivdi3+0x118>
  802719:	89 f8                	mov    %edi,%eax
  80271b:	31 d2                	xor    %edx,%edx
  80271d:	e9 7a ff ff ff       	jmp    80269c <__udivdi3+0x7c>
  802722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802728:	31 d2                	xor    %edx,%edx
  80272a:	b8 01 00 00 00       	mov    $0x1,%eax
  80272f:	e9 68 ff ff ff       	jmp    80269c <__udivdi3+0x7c>
  802734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802738:	8d 47 ff             	lea    -0x1(%edi),%eax
  80273b:	31 d2                	xor    %edx,%edx
  80273d:	83 c4 0c             	add    $0xc,%esp
  802740:	5e                   	pop    %esi
  802741:	5f                   	pop    %edi
  802742:	5d                   	pop    %ebp
  802743:	c3                   	ret    
  802744:	66 90                	xchg   %ax,%ax
  802746:	66 90                	xchg   %ax,%ax
  802748:	66 90                	xchg   %ax,%ax
  80274a:	66 90                	xchg   %ax,%ax
  80274c:	66 90                	xchg   %ax,%ax
  80274e:	66 90                	xchg   %ax,%ax

00802750 <__umoddi3>:
  802750:	55                   	push   %ebp
  802751:	57                   	push   %edi
  802752:	56                   	push   %esi
  802753:	83 ec 14             	sub    $0x14,%esp
  802756:	8b 44 24 28          	mov    0x28(%esp),%eax
  80275a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80275e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802762:	89 c7                	mov    %eax,%edi
  802764:	89 44 24 04          	mov    %eax,0x4(%esp)
  802768:	8b 44 24 30          	mov    0x30(%esp),%eax
  80276c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802770:	89 34 24             	mov    %esi,(%esp)
  802773:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802777:	85 c0                	test   %eax,%eax
  802779:	89 c2                	mov    %eax,%edx
  80277b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80277f:	75 17                	jne    802798 <__umoddi3+0x48>
  802781:	39 fe                	cmp    %edi,%esi
  802783:	76 4b                	jbe    8027d0 <__umoddi3+0x80>
  802785:	89 c8                	mov    %ecx,%eax
  802787:	89 fa                	mov    %edi,%edx
  802789:	f7 f6                	div    %esi
  80278b:	89 d0                	mov    %edx,%eax
  80278d:	31 d2                	xor    %edx,%edx
  80278f:	83 c4 14             	add    $0x14,%esp
  802792:	5e                   	pop    %esi
  802793:	5f                   	pop    %edi
  802794:	5d                   	pop    %ebp
  802795:	c3                   	ret    
  802796:	66 90                	xchg   %ax,%ax
  802798:	39 f8                	cmp    %edi,%eax
  80279a:	77 54                	ja     8027f0 <__umoddi3+0xa0>
  80279c:	0f bd e8             	bsr    %eax,%ebp
  80279f:	83 f5 1f             	xor    $0x1f,%ebp
  8027a2:	75 5c                	jne    802800 <__umoddi3+0xb0>
  8027a4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8027a8:	39 3c 24             	cmp    %edi,(%esp)
  8027ab:	0f 87 e7 00 00 00    	ja     802898 <__umoddi3+0x148>
  8027b1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8027b5:	29 f1                	sub    %esi,%ecx
  8027b7:	19 c7                	sbb    %eax,%edi
  8027b9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8027bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027c1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027c5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8027c9:	83 c4 14             	add    $0x14,%esp
  8027cc:	5e                   	pop    %esi
  8027cd:	5f                   	pop    %edi
  8027ce:	5d                   	pop    %ebp
  8027cf:	c3                   	ret    
  8027d0:	85 f6                	test   %esi,%esi
  8027d2:	89 f5                	mov    %esi,%ebp
  8027d4:	75 0b                	jne    8027e1 <__umoddi3+0x91>
  8027d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8027db:	31 d2                	xor    %edx,%edx
  8027dd:	f7 f6                	div    %esi
  8027df:	89 c5                	mov    %eax,%ebp
  8027e1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8027e5:	31 d2                	xor    %edx,%edx
  8027e7:	f7 f5                	div    %ebp
  8027e9:	89 c8                	mov    %ecx,%eax
  8027eb:	f7 f5                	div    %ebp
  8027ed:	eb 9c                	jmp    80278b <__umoddi3+0x3b>
  8027ef:	90                   	nop
  8027f0:	89 c8                	mov    %ecx,%eax
  8027f2:	89 fa                	mov    %edi,%edx
  8027f4:	83 c4 14             	add    $0x14,%esp
  8027f7:	5e                   	pop    %esi
  8027f8:	5f                   	pop    %edi
  8027f9:	5d                   	pop    %ebp
  8027fa:	c3                   	ret    
  8027fb:	90                   	nop
  8027fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802800:	8b 04 24             	mov    (%esp),%eax
  802803:	be 20 00 00 00       	mov    $0x20,%esi
  802808:	89 e9                	mov    %ebp,%ecx
  80280a:	29 ee                	sub    %ebp,%esi
  80280c:	d3 e2                	shl    %cl,%edx
  80280e:	89 f1                	mov    %esi,%ecx
  802810:	d3 e8                	shr    %cl,%eax
  802812:	89 e9                	mov    %ebp,%ecx
  802814:	89 44 24 04          	mov    %eax,0x4(%esp)
  802818:	8b 04 24             	mov    (%esp),%eax
  80281b:	09 54 24 04          	or     %edx,0x4(%esp)
  80281f:	89 fa                	mov    %edi,%edx
  802821:	d3 e0                	shl    %cl,%eax
  802823:	89 f1                	mov    %esi,%ecx
  802825:	89 44 24 08          	mov    %eax,0x8(%esp)
  802829:	8b 44 24 10          	mov    0x10(%esp),%eax
  80282d:	d3 ea                	shr    %cl,%edx
  80282f:	89 e9                	mov    %ebp,%ecx
  802831:	d3 e7                	shl    %cl,%edi
  802833:	89 f1                	mov    %esi,%ecx
  802835:	d3 e8                	shr    %cl,%eax
  802837:	89 e9                	mov    %ebp,%ecx
  802839:	09 f8                	or     %edi,%eax
  80283b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80283f:	f7 74 24 04          	divl   0x4(%esp)
  802843:	d3 e7                	shl    %cl,%edi
  802845:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802849:	89 d7                	mov    %edx,%edi
  80284b:	f7 64 24 08          	mull   0x8(%esp)
  80284f:	39 d7                	cmp    %edx,%edi
  802851:	89 c1                	mov    %eax,%ecx
  802853:	89 14 24             	mov    %edx,(%esp)
  802856:	72 2c                	jb     802884 <__umoddi3+0x134>
  802858:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80285c:	72 22                	jb     802880 <__umoddi3+0x130>
  80285e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802862:	29 c8                	sub    %ecx,%eax
  802864:	19 d7                	sbb    %edx,%edi
  802866:	89 e9                	mov    %ebp,%ecx
  802868:	89 fa                	mov    %edi,%edx
  80286a:	d3 e8                	shr    %cl,%eax
  80286c:	89 f1                	mov    %esi,%ecx
  80286e:	d3 e2                	shl    %cl,%edx
  802870:	89 e9                	mov    %ebp,%ecx
  802872:	d3 ef                	shr    %cl,%edi
  802874:	09 d0                	or     %edx,%eax
  802876:	89 fa                	mov    %edi,%edx
  802878:	83 c4 14             	add    $0x14,%esp
  80287b:	5e                   	pop    %esi
  80287c:	5f                   	pop    %edi
  80287d:	5d                   	pop    %ebp
  80287e:	c3                   	ret    
  80287f:	90                   	nop
  802880:	39 d7                	cmp    %edx,%edi
  802882:	75 da                	jne    80285e <__umoddi3+0x10e>
  802884:	8b 14 24             	mov    (%esp),%edx
  802887:	89 c1                	mov    %eax,%ecx
  802889:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80288d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802891:	eb cb                	jmp    80285e <__umoddi3+0x10e>
  802893:	90                   	nop
  802894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802898:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80289c:	0f 82 0f ff ff ff    	jb     8027b1 <__umoddi3+0x61>
  8028a2:	e9 1a ff ff ff       	jmp    8027c1 <__umoddi3+0x71>
