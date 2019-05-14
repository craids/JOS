
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 17 01 00 00       	call   800148 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800046:	00 
  800047:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80004e:	00 
  80004f:	89 34 24             	mov    %esi,(%esp)
  800052:	e8 d9 13 00 00       	call   801430 <ipc_recv>
  800057:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  800059:	a1 08 50 80 00       	mov    0x805008,%eax
  80005e:	8b 40 5c             	mov    0x5c(%eax),%eax
  800061:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800065:	89 44 24 04          	mov    %eax,0x4(%esp)
  800069:	c7 04 24 00 2c 80 00 	movl   $0x802c00,(%esp)
  800070:	e8 2d 02 00 00       	call   8002a2 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800075:	e8 b6 10 00 00       	call   801130 <fork>
  80007a:	89 c7                	mov    %eax,%edi
  80007c:	85 c0                	test   %eax,%eax
  80007e:	79 20                	jns    8000a0 <primeproc+0x6d>
		panic("fork: %e", id);
  800080:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800084:	c7 44 24 08 0c 2c 80 	movl   $0x802c0c,0x8(%esp)
  80008b:	00 
  80008c:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800093:	00 
  800094:	c7 04 24 15 2c 80 00 	movl   $0x802c15,(%esp)
  80009b:	e8 09 01 00 00       	call   8001a9 <_panic>
	if (id == 0)
  8000a0:	85 c0                	test   %eax,%eax
  8000a2:	74 9b                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000a4:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000ae:	00 
  8000af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b6:	00 
  8000b7:	89 34 24             	mov    %esi,(%esp)
  8000ba:	e8 71 13 00 00       	call   801430 <ipc_recv>
  8000bf:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000c1:	99                   	cltd   
  8000c2:	f7 fb                	idiv   %ebx
  8000c4:	85 d2                	test   %edx,%edx
  8000c6:	74 df                	je     8000a7 <primeproc+0x74>
			ipc_send(id, i, 0, 0);
  8000c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000cf:	00 
  8000d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000d7:	00 
  8000d8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8000dc:	89 3c 24             	mov    %edi,(%esp)
  8000df:	e8 b4 13 00 00       	call   801498 <ipc_send>
  8000e4:	eb c1                	jmp    8000a7 <primeproc+0x74>

008000e6 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
  8000eb:	83 ec 10             	sub    $0x10,%esp
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ee:	e8 3d 10 00 00       	call   801130 <fork>
  8000f3:	89 c6                	mov    %eax,%esi
  8000f5:	85 c0                	test   %eax,%eax
  8000f7:	79 20                	jns    800119 <umain+0x33>
		panic("fork: %e", id);
  8000f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000fd:	c7 44 24 08 0c 2c 80 	movl   $0x802c0c,0x8(%esp)
  800104:	00 
  800105:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  80010c:	00 
  80010d:	c7 04 24 15 2c 80 00 	movl   $0x802c15,(%esp)
  800114:	e8 90 00 00 00       	call   8001a9 <_panic>
	if (id == 0)
  800119:	bb 02 00 00 00       	mov    $0x2,%ebx
  80011e:	85 c0                	test   %eax,%eax
  800120:	75 05                	jne    800127 <umain+0x41>
		primeproc();
  800122:	e8 0c ff ff ff       	call   800033 <primeproc>

	// feed all the integers through
	for (i = 2; ; i++)
		ipc_send(id, i, 0, 0);
  800127:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80012e:	00 
  80012f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800136:	00 
  800137:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80013b:	89 34 24             	mov    %esi,(%esp)
  80013e:	e8 55 13 00 00       	call   801498 <ipc_send>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  800143:	83 c3 01             	add    $0x1,%ebx
  800146:	eb df                	jmp    800127 <umain+0x41>

00800148 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	56                   	push   %esi
  80014c:	53                   	push   %ebx
  80014d:	83 ec 10             	sub    $0x10,%esp
  800150:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800153:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800156:	e8 4a 0b 00 00       	call   800ca5 <sys_getenvid>
  80015b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800160:	c1 e0 07             	shl    $0x7,%eax
  800163:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800168:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016d:	85 db                	test   %ebx,%ebx
  80016f:	7e 07                	jle    800178 <libmain+0x30>
		binaryname = argv[0];
  800171:	8b 06                	mov    (%esi),%eax
  800173:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800178:	89 74 24 04          	mov    %esi,0x4(%esp)
  80017c:	89 1c 24             	mov    %ebx,(%esp)
  80017f:	e8 62 ff ff ff       	call   8000e6 <umain>

	// exit gracefully
	exit();
  800184:	e8 07 00 00 00       	call   800190 <exit>
}
  800189:	83 c4 10             	add    $0x10,%esp
  80018c:	5b                   	pop    %ebx
  80018d:	5e                   	pop    %esi
  80018e:	5d                   	pop    %ebp
  80018f:	c3                   	ret    

00800190 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800196:	e8 9f 15 00 00       	call   80173a <close_all>
	sys_env_destroy(0);
  80019b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001a2:	e8 ac 0a 00 00       	call   800c53 <sys_env_destroy>
}
  8001a7:	c9                   	leave  
  8001a8:	c3                   	ret    

008001a9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001a9:	55                   	push   %ebp
  8001aa:	89 e5                	mov    %esp,%ebp
  8001ac:	56                   	push   %esi
  8001ad:	53                   	push   %ebx
  8001ae:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001b1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001b4:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001ba:	e8 e6 0a 00 00       	call   800ca5 <sys_getenvid>
  8001bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001cd:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d5:	c7 04 24 30 2c 80 00 	movl   $0x802c30,(%esp)
  8001dc:	e8 c1 00 00 00       	call   8002a2 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001e1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e8:	89 04 24             	mov    %eax,(%esp)
  8001eb:	e8 51 00 00 00       	call   800241 <vcprintf>
	cprintf("\n");
  8001f0:	c7 04 24 b0 31 80 00 	movl   $0x8031b0,(%esp)
  8001f7:	e8 a6 00 00 00       	call   8002a2 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001fc:	cc                   	int3   
  8001fd:	eb fd                	jmp    8001fc <_panic+0x53>

008001ff <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	53                   	push   %ebx
  800203:	83 ec 14             	sub    $0x14,%esp
  800206:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800209:	8b 13                	mov    (%ebx),%edx
  80020b:	8d 42 01             	lea    0x1(%edx),%eax
  80020e:	89 03                	mov    %eax,(%ebx)
  800210:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800213:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800217:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021c:	75 19                	jne    800237 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80021e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800225:	00 
  800226:	8d 43 08             	lea    0x8(%ebx),%eax
  800229:	89 04 24             	mov    %eax,(%esp)
  80022c:	e8 e5 09 00 00       	call   800c16 <sys_cputs>
		b->idx = 0;
  800231:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800237:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80023b:	83 c4 14             	add    $0x14,%esp
  80023e:	5b                   	pop    %ebx
  80023f:	5d                   	pop    %ebp
  800240:	c3                   	ret    

00800241 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80024a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800251:	00 00 00 
	b.cnt = 0;
  800254:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80025e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800261:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800265:	8b 45 08             	mov    0x8(%ebp),%eax
  800268:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800272:	89 44 24 04          	mov    %eax,0x4(%esp)
  800276:	c7 04 24 ff 01 80 00 	movl   $0x8001ff,(%esp)
  80027d:	e8 ac 01 00 00       	call   80042e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800282:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800288:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800292:	89 04 24             	mov    %eax,(%esp)
  800295:	e8 7c 09 00 00       	call   800c16 <sys_cputs>

	return b.cnt;
}
  80029a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    

008002a2 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002a8:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002af:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b2:	89 04 24             	mov    %eax,(%esp)
  8002b5:	e8 87 ff ff ff       	call   800241 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    
  8002bc:	66 90                	xchg   %ax,%ax
  8002be:	66 90                	xchg   %ax,%ax

008002c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	57                   	push   %edi
  8002c4:	56                   	push   %esi
  8002c5:	53                   	push   %ebx
  8002c6:	83 ec 3c             	sub    $0x3c,%esp
  8002c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002cc:	89 d7                	mov    %edx,%edi
  8002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002d7:	89 c3                	mov    %eax,%ebx
  8002d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002df:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ea:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002ed:	39 d9                	cmp    %ebx,%ecx
  8002ef:	72 05                	jb     8002f6 <printnum+0x36>
  8002f1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002f4:	77 69                	ja     80035f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002f9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002fd:	83 ee 01             	sub    $0x1,%esi
  800300:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800304:	89 44 24 08          	mov    %eax,0x8(%esp)
  800308:	8b 44 24 08          	mov    0x8(%esp),%eax
  80030c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800310:	89 c3                	mov    %eax,%ebx
  800312:	89 d6                	mov    %edx,%esi
  800314:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800317:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80031a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80031e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800322:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800325:	89 04 24             	mov    %eax,(%esp)
  800328:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80032b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032f:	e8 2c 26 00 00       	call   802960 <__udivdi3>
  800334:	89 d9                	mov    %ebx,%ecx
  800336:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80033a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80033e:	89 04 24             	mov    %eax,(%esp)
  800341:	89 54 24 04          	mov    %edx,0x4(%esp)
  800345:	89 fa                	mov    %edi,%edx
  800347:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80034a:	e8 71 ff ff ff       	call   8002c0 <printnum>
  80034f:	eb 1b                	jmp    80036c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800351:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800355:	8b 45 18             	mov    0x18(%ebp),%eax
  800358:	89 04 24             	mov    %eax,(%esp)
  80035b:	ff d3                	call   *%ebx
  80035d:	eb 03                	jmp    800362 <printnum+0xa2>
  80035f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800362:	83 ee 01             	sub    $0x1,%esi
  800365:	85 f6                	test   %esi,%esi
  800367:	7f e8                	jg     800351 <printnum+0x91>
  800369:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80036c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800370:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800374:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800377:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80037a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80037e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800382:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800385:	89 04 24             	mov    %eax,(%esp)
  800388:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80038b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038f:	e8 fc 26 00 00       	call   802a90 <__umoddi3>
  800394:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800398:	0f be 80 53 2c 80 00 	movsbl 0x802c53(%eax),%eax
  80039f:	89 04 24             	mov    %eax,(%esp)
  8003a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003a5:	ff d0                	call   *%eax
}
  8003a7:	83 c4 3c             	add    $0x3c,%esp
  8003aa:	5b                   	pop    %ebx
  8003ab:	5e                   	pop    %esi
  8003ac:	5f                   	pop    %edi
  8003ad:	5d                   	pop    %ebp
  8003ae:	c3                   	ret    

008003af <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003b2:	83 fa 01             	cmp    $0x1,%edx
  8003b5:	7e 0e                	jle    8003c5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003b7:	8b 10                	mov    (%eax),%edx
  8003b9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003bc:	89 08                	mov    %ecx,(%eax)
  8003be:	8b 02                	mov    (%edx),%eax
  8003c0:	8b 52 04             	mov    0x4(%edx),%edx
  8003c3:	eb 22                	jmp    8003e7 <getuint+0x38>
	else if (lflag)
  8003c5:	85 d2                	test   %edx,%edx
  8003c7:	74 10                	je     8003d9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003c9:	8b 10                	mov    (%eax),%edx
  8003cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ce:	89 08                	mov    %ecx,(%eax)
  8003d0:	8b 02                	mov    (%edx),%eax
  8003d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d7:	eb 0e                	jmp    8003e7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003d9:	8b 10                	mov    (%eax),%edx
  8003db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003de:	89 08                	mov    %ecx,(%eax)
  8003e0:	8b 02                	mov    (%edx),%eax
  8003e2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003e7:	5d                   	pop    %ebp
  8003e8:	c3                   	ret    

008003e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ef:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003f3:	8b 10                	mov    (%eax),%edx
  8003f5:	3b 50 04             	cmp    0x4(%eax),%edx
  8003f8:	73 0a                	jae    800404 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003fd:	89 08                	mov    %ecx,(%eax)
  8003ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800402:	88 02                	mov    %al,(%edx)
}
  800404:	5d                   	pop    %ebp
  800405:	c3                   	ret    

00800406 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80040c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80040f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800413:	8b 45 10             	mov    0x10(%ebp),%eax
  800416:	89 44 24 08          	mov    %eax,0x8(%esp)
  80041a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800421:	8b 45 08             	mov    0x8(%ebp),%eax
  800424:	89 04 24             	mov    %eax,(%esp)
  800427:	e8 02 00 00 00       	call   80042e <vprintfmt>
	va_end(ap);
}
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	57                   	push   %edi
  800432:	56                   	push   %esi
  800433:	53                   	push   %ebx
  800434:	83 ec 3c             	sub    $0x3c,%esp
  800437:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80043a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80043d:	eb 14                	jmp    800453 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80043f:	85 c0                	test   %eax,%eax
  800441:	0f 84 b3 03 00 00    	je     8007fa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800447:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80044b:	89 04 24             	mov    %eax,(%esp)
  80044e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800451:	89 f3                	mov    %esi,%ebx
  800453:	8d 73 01             	lea    0x1(%ebx),%esi
  800456:	0f b6 03             	movzbl (%ebx),%eax
  800459:	83 f8 25             	cmp    $0x25,%eax
  80045c:	75 e1                	jne    80043f <vprintfmt+0x11>
  80045e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800462:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800469:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800470:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800477:	ba 00 00 00 00       	mov    $0x0,%edx
  80047c:	eb 1d                	jmp    80049b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800480:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800484:	eb 15                	jmp    80049b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800486:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800488:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80048c:	eb 0d                	jmp    80049b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80048e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800491:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800494:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80049e:	0f b6 0e             	movzbl (%esi),%ecx
  8004a1:	0f b6 c1             	movzbl %cl,%eax
  8004a4:	83 e9 23             	sub    $0x23,%ecx
  8004a7:	80 f9 55             	cmp    $0x55,%cl
  8004aa:	0f 87 2a 03 00 00    	ja     8007da <vprintfmt+0x3ac>
  8004b0:	0f b6 c9             	movzbl %cl,%ecx
  8004b3:	ff 24 8d a0 2d 80 00 	jmp    *0x802da0(,%ecx,4)
  8004ba:	89 de                	mov    %ebx,%esi
  8004bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004c1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004c4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004c8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004cb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004ce:	83 fb 09             	cmp    $0x9,%ebx
  8004d1:	77 36                	ja     800509 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004d3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004d6:	eb e9                	jmp    8004c1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004db:	8d 48 04             	lea    0x4(%eax),%ecx
  8004de:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004e1:	8b 00                	mov    (%eax),%eax
  8004e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004e6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004e8:	eb 22                	jmp    80050c <vprintfmt+0xde>
  8004ea:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004ed:	85 c9                	test   %ecx,%ecx
  8004ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f4:	0f 49 c1             	cmovns %ecx,%eax
  8004f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fa:	89 de                	mov    %ebx,%esi
  8004fc:	eb 9d                	jmp    80049b <vprintfmt+0x6d>
  8004fe:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800500:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800507:	eb 92                	jmp    80049b <vprintfmt+0x6d>
  800509:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80050c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800510:	79 89                	jns    80049b <vprintfmt+0x6d>
  800512:	e9 77 ff ff ff       	jmp    80048e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800517:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80051a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80051c:	e9 7a ff ff ff       	jmp    80049b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	8d 50 04             	lea    0x4(%eax),%edx
  800527:	89 55 14             	mov    %edx,0x14(%ebp)
  80052a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052e:	8b 00                	mov    (%eax),%eax
  800530:	89 04 24             	mov    %eax,(%esp)
  800533:	ff 55 08             	call   *0x8(%ebp)
			break;
  800536:	e9 18 ff ff ff       	jmp    800453 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80053b:	8b 45 14             	mov    0x14(%ebp),%eax
  80053e:	8d 50 04             	lea    0x4(%eax),%edx
  800541:	89 55 14             	mov    %edx,0x14(%ebp)
  800544:	8b 00                	mov    (%eax),%eax
  800546:	99                   	cltd   
  800547:	31 d0                	xor    %edx,%eax
  800549:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80054b:	83 f8 11             	cmp    $0x11,%eax
  80054e:	7f 0b                	jg     80055b <vprintfmt+0x12d>
  800550:	8b 14 85 00 2f 80 00 	mov    0x802f00(,%eax,4),%edx
  800557:	85 d2                	test   %edx,%edx
  800559:	75 20                	jne    80057b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80055b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80055f:	c7 44 24 08 6b 2c 80 	movl   $0x802c6b,0x8(%esp)
  800566:	00 
  800567:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	89 04 24             	mov    %eax,(%esp)
  800571:	e8 90 fe ff ff       	call   800406 <printfmt>
  800576:	e9 d8 fe ff ff       	jmp    800453 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80057b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80057f:	c7 44 24 08 45 31 80 	movl   $0x803145,0x8(%esp)
  800586:	00 
  800587:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80058b:	8b 45 08             	mov    0x8(%ebp),%eax
  80058e:	89 04 24             	mov    %eax,(%esp)
  800591:	e8 70 fe ff ff       	call   800406 <printfmt>
  800596:	e9 b8 fe ff ff       	jmp    800453 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80059b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80059e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	8d 50 04             	lea    0x4(%eax),%edx
  8005aa:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ad:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8005af:	85 f6                	test   %esi,%esi
  8005b1:	b8 64 2c 80 00       	mov    $0x802c64,%eax
  8005b6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8005b9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8005bd:	0f 84 97 00 00 00    	je     80065a <vprintfmt+0x22c>
  8005c3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005c7:	0f 8e 9b 00 00 00    	jle    800668 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005cd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005d1:	89 34 24             	mov    %esi,(%esp)
  8005d4:	e8 cf 02 00 00       	call   8008a8 <strnlen>
  8005d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005dc:	29 c2                	sub    %eax,%edx
  8005de:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8005e1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005e8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005f1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f3:	eb 0f                	jmp    800604 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8005f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005fc:	89 04 24             	mov    %eax,(%esp)
  8005ff:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800601:	83 eb 01             	sub    $0x1,%ebx
  800604:	85 db                	test   %ebx,%ebx
  800606:	7f ed                	jg     8005f5 <vprintfmt+0x1c7>
  800608:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80060b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80060e:	85 d2                	test   %edx,%edx
  800610:	b8 00 00 00 00       	mov    $0x0,%eax
  800615:	0f 49 c2             	cmovns %edx,%eax
  800618:	29 c2                	sub    %eax,%edx
  80061a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80061d:	89 d7                	mov    %edx,%edi
  80061f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800622:	eb 50                	jmp    800674 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800624:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800628:	74 1e                	je     800648 <vprintfmt+0x21a>
  80062a:	0f be d2             	movsbl %dl,%edx
  80062d:	83 ea 20             	sub    $0x20,%edx
  800630:	83 fa 5e             	cmp    $0x5e,%edx
  800633:	76 13                	jbe    800648 <vprintfmt+0x21a>
					putch('?', putdat);
  800635:	8b 45 0c             	mov    0xc(%ebp),%eax
  800638:	89 44 24 04          	mov    %eax,0x4(%esp)
  80063c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800643:	ff 55 08             	call   *0x8(%ebp)
  800646:	eb 0d                	jmp    800655 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80064b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80064f:	89 04 24             	mov    %eax,(%esp)
  800652:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800655:	83 ef 01             	sub    $0x1,%edi
  800658:	eb 1a                	jmp    800674 <vprintfmt+0x246>
  80065a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80065d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800660:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800663:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800666:	eb 0c                	jmp    800674 <vprintfmt+0x246>
  800668:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80066b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80066e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800671:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800674:	83 c6 01             	add    $0x1,%esi
  800677:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80067b:	0f be c2             	movsbl %dl,%eax
  80067e:	85 c0                	test   %eax,%eax
  800680:	74 27                	je     8006a9 <vprintfmt+0x27b>
  800682:	85 db                	test   %ebx,%ebx
  800684:	78 9e                	js     800624 <vprintfmt+0x1f6>
  800686:	83 eb 01             	sub    $0x1,%ebx
  800689:	79 99                	jns    800624 <vprintfmt+0x1f6>
  80068b:	89 f8                	mov    %edi,%eax
  80068d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800690:	8b 75 08             	mov    0x8(%ebp),%esi
  800693:	89 c3                	mov    %eax,%ebx
  800695:	eb 1a                	jmp    8006b1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800697:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80069b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006a2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006a4:	83 eb 01             	sub    $0x1,%ebx
  8006a7:	eb 08                	jmp    8006b1 <vprintfmt+0x283>
  8006a9:	89 fb                	mov    %edi,%ebx
  8006ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ae:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006b1:	85 db                	test   %ebx,%ebx
  8006b3:	7f e2                	jg     800697 <vprintfmt+0x269>
  8006b5:	89 75 08             	mov    %esi,0x8(%ebp)
  8006b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006bb:	e9 93 fd ff ff       	jmp    800453 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006c0:	83 fa 01             	cmp    $0x1,%edx
  8006c3:	7e 16                	jle    8006db <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	8d 50 08             	lea    0x8(%eax),%edx
  8006cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ce:	8b 50 04             	mov    0x4(%eax),%edx
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006d9:	eb 32                	jmp    80070d <vprintfmt+0x2df>
	else if (lflag)
  8006db:	85 d2                	test   %edx,%edx
  8006dd:	74 18                	je     8006f7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8d 50 04             	lea    0x4(%eax),%edx
  8006e5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e8:	8b 30                	mov    (%eax),%esi
  8006ea:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006ed:	89 f0                	mov    %esi,%eax
  8006ef:	c1 f8 1f             	sar    $0x1f,%eax
  8006f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006f5:	eb 16                	jmp    80070d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8006f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fa:	8d 50 04             	lea    0x4(%eax),%edx
  8006fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800700:	8b 30                	mov    (%eax),%esi
  800702:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800705:	89 f0                	mov    %esi,%eax
  800707:	c1 f8 1f             	sar    $0x1f,%eax
  80070a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80070d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800710:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800713:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800718:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071c:	0f 89 80 00 00 00    	jns    8007a2 <vprintfmt+0x374>
				putch('-', putdat);
  800722:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800726:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80072d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800730:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800733:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800736:	f7 d8                	neg    %eax
  800738:	83 d2 00             	adc    $0x0,%edx
  80073b:	f7 da                	neg    %edx
			}
			base = 10;
  80073d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800742:	eb 5e                	jmp    8007a2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800744:	8d 45 14             	lea    0x14(%ebp),%eax
  800747:	e8 63 fc ff ff       	call   8003af <getuint>
			base = 10;
  80074c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800751:	eb 4f                	jmp    8007a2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800753:	8d 45 14             	lea    0x14(%ebp),%eax
  800756:	e8 54 fc ff ff       	call   8003af <getuint>
			base = 8;
  80075b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800760:	eb 40                	jmp    8007a2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800762:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800766:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80076d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800770:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800774:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80077b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	8d 50 04             	lea    0x4(%eax),%edx
  800784:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800787:	8b 00                	mov    (%eax),%eax
  800789:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80078e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800793:	eb 0d                	jmp    8007a2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800795:	8d 45 14             	lea    0x14(%ebp),%eax
  800798:	e8 12 fc ff ff       	call   8003af <getuint>
			base = 16;
  80079d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007a2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8007a6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007aa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8007ad:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007b1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007b5:	89 04 24             	mov    %eax,(%esp)
  8007b8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007bc:	89 fa                	mov    %edi,%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	e8 fa fa ff ff       	call   8002c0 <printnum>
			break;
  8007c6:	e9 88 fc ff ff       	jmp    800453 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007cb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007cf:	89 04 24             	mov    %eax,(%esp)
  8007d2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007d5:	e9 79 fc ff ff       	jmp    800453 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007de:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007e5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007e8:	89 f3                	mov    %esi,%ebx
  8007ea:	eb 03                	jmp    8007ef <vprintfmt+0x3c1>
  8007ec:	83 eb 01             	sub    $0x1,%ebx
  8007ef:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007f3:	75 f7                	jne    8007ec <vprintfmt+0x3be>
  8007f5:	e9 59 fc ff ff       	jmp    800453 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007fa:	83 c4 3c             	add    $0x3c,%esp
  8007fd:	5b                   	pop    %ebx
  8007fe:	5e                   	pop    %esi
  8007ff:	5f                   	pop    %edi
  800800:	5d                   	pop    %ebp
  800801:	c3                   	ret    

00800802 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800802:	55                   	push   %ebp
  800803:	89 e5                	mov    %esp,%ebp
  800805:	83 ec 28             	sub    $0x28,%esp
  800808:	8b 45 08             	mov    0x8(%ebp),%eax
  80080b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80080e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800811:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800815:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800818:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80081f:	85 c0                	test   %eax,%eax
  800821:	74 30                	je     800853 <vsnprintf+0x51>
  800823:	85 d2                	test   %edx,%edx
  800825:	7e 2c                	jle    800853 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80082e:	8b 45 10             	mov    0x10(%ebp),%eax
  800831:	89 44 24 08          	mov    %eax,0x8(%esp)
  800835:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800838:	89 44 24 04          	mov    %eax,0x4(%esp)
  80083c:	c7 04 24 e9 03 80 00 	movl   $0x8003e9,(%esp)
  800843:	e8 e6 fb ff ff       	call   80042e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800848:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80084b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80084e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800851:	eb 05                	jmp    800858 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800853:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800858:	c9                   	leave  
  800859:	c3                   	ret    

0080085a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800860:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800863:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800867:	8b 45 10             	mov    0x10(%ebp),%eax
  80086a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80086e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800871:	89 44 24 04          	mov    %eax,0x4(%esp)
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	89 04 24             	mov    %eax,(%esp)
  80087b:	e8 82 ff ff ff       	call   800802 <vsnprintf>
	va_end(ap);

	return rc;
}
  800880:	c9                   	leave  
  800881:	c3                   	ret    
  800882:	66 90                	xchg   %ax,%ax
  800884:	66 90                	xchg   %ax,%ax
  800886:	66 90                	xchg   %ax,%ax
  800888:	66 90                	xchg   %ax,%ax
  80088a:	66 90                	xchg   %ax,%ax
  80088c:	66 90                	xchg   %ax,%ax
  80088e:	66 90                	xchg   %ax,%ax

00800890 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800896:	b8 00 00 00 00       	mov    $0x0,%eax
  80089b:	eb 03                	jmp    8008a0 <strlen+0x10>
		n++;
  80089d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008a4:	75 f7                	jne    80089d <strlen+0xd>
		n++;
	return n;
}
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b6:	eb 03                	jmp    8008bb <strnlen+0x13>
		n++;
  8008b8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008bb:	39 d0                	cmp    %edx,%eax
  8008bd:	74 06                	je     8008c5 <strnlen+0x1d>
  8008bf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008c3:	75 f3                	jne    8008b8 <strnlen+0x10>
		n++;
	return n;
}
  8008c5:	5d                   	pop    %ebp
  8008c6:	c3                   	ret    

008008c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	53                   	push   %ebx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008d1:	89 c2                	mov    %eax,%edx
  8008d3:	83 c2 01             	add    $0x1,%edx
  8008d6:	83 c1 01             	add    $0x1,%ecx
  8008d9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008dd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008e0:	84 db                	test   %bl,%bl
  8008e2:	75 ef                	jne    8008d3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008e4:	5b                   	pop    %ebx
  8008e5:	5d                   	pop    %ebp
  8008e6:	c3                   	ret    

008008e7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008e7:	55                   	push   %ebp
  8008e8:	89 e5                	mov    %esp,%ebp
  8008ea:	53                   	push   %ebx
  8008eb:	83 ec 08             	sub    $0x8,%esp
  8008ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008f1:	89 1c 24             	mov    %ebx,(%esp)
  8008f4:	e8 97 ff ff ff       	call   800890 <strlen>
	strcpy(dst + len, src);
  8008f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800900:	01 d8                	add    %ebx,%eax
  800902:	89 04 24             	mov    %eax,(%esp)
  800905:	e8 bd ff ff ff       	call   8008c7 <strcpy>
	return dst;
}
  80090a:	89 d8                	mov    %ebx,%eax
  80090c:	83 c4 08             	add    $0x8,%esp
  80090f:	5b                   	pop    %ebx
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	56                   	push   %esi
  800916:	53                   	push   %ebx
  800917:	8b 75 08             	mov    0x8(%ebp),%esi
  80091a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091d:	89 f3                	mov    %esi,%ebx
  80091f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800922:	89 f2                	mov    %esi,%edx
  800924:	eb 0f                	jmp    800935 <strncpy+0x23>
		*dst++ = *src;
  800926:	83 c2 01             	add    $0x1,%edx
  800929:	0f b6 01             	movzbl (%ecx),%eax
  80092c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80092f:	80 39 01             	cmpb   $0x1,(%ecx)
  800932:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800935:	39 da                	cmp    %ebx,%edx
  800937:	75 ed                	jne    800926 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800939:	89 f0                	mov    %esi,%eax
  80093b:	5b                   	pop    %ebx
  80093c:	5e                   	pop    %esi
  80093d:	5d                   	pop    %ebp
  80093e:	c3                   	ret    

0080093f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80093f:	55                   	push   %ebp
  800940:	89 e5                	mov    %esp,%ebp
  800942:	56                   	push   %esi
  800943:	53                   	push   %ebx
  800944:	8b 75 08             	mov    0x8(%ebp),%esi
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80094d:	89 f0                	mov    %esi,%eax
  80094f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800953:	85 c9                	test   %ecx,%ecx
  800955:	75 0b                	jne    800962 <strlcpy+0x23>
  800957:	eb 1d                	jmp    800976 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800959:	83 c0 01             	add    $0x1,%eax
  80095c:	83 c2 01             	add    $0x1,%edx
  80095f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800962:	39 d8                	cmp    %ebx,%eax
  800964:	74 0b                	je     800971 <strlcpy+0x32>
  800966:	0f b6 0a             	movzbl (%edx),%ecx
  800969:	84 c9                	test   %cl,%cl
  80096b:	75 ec                	jne    800959 <strlcpy+0x1a>
  80096d:	89 c2                	mov    %eax,%edx
  80096f:	eb 02                	jmp    800973 <strlcpy+0x34>
  800971:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800973:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800976:	29 f0                	sub    %esi,%eax
}
  800978:	5b                   	pop    %ebx
  800979:	5e                   	pop    %esi
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800982:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800985:	eb 06                	jmp    80098d <strcmp+0x11>
		p++, q++;
  800987:	83 c1 01             	add    $0x1,%ecx
  80098a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80098d:	0f b6 01             	movzbl (%ecx),%eax
  800990:	84 c0                	test   %al,%al
  800992:	74 04                	je     800998 <strcmp+0x1c>
  800994:	3a 02                	cmp    (%edx),%al
  800996:	74 ef                	je     800987 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800998:	0f b6 c0             	movzbl %al,%eax
  80099b:	0f b6 12             	movzbl (%edx),%edx
  80099e:	29 d0                	sub    %edx,%eax
}
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	53                   	push   %ebx
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ac:	89 c3                	mov    %eax,%ebx
  8009ae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009b1:	eb 06                	jmp    8009b9 <strncmp+0x17>
		n--, p++, q++;
  8009b3:	83 c0 01             	add    $0x1,%eax
  8009b6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009b9:	39 d8                	cmp    %ebx,%eax
  8009bb:	74 15                	je     8009d2 <strncmp+0x30>
  8009bd:	0f b6 08             	movzbl (%eax),%ecx
  8009c0:	84 c9                	test   %cl,%cl
  8009c2:	74 04                	je     8009c8 <strncmp+0x26>
  8009c4:	3a 0a                	cmp    (%edx),%cl
  8009c6:	74 eb                	je     8009b3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009c8:	0f b6 00             	movzbl (%eax),%eax
  8009cb:	0f b6 12             	movzbl (%edx),%edx
  8009ce:	29 d0                	sub    %edx,%eax
  8009d0:	eb 05                	jmp    8009d7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009d7:	5b                   	pop    %ebx
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e4:	eb 07                	jmp    8009ed <strchr+0x13>
		if (*s == c)
  8009e6:	38 ca                	cmp    %cl,%dl
  8009e8:	74 0f                	je     8009f9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009ea:	83 c0 01             	add    $0x1,%eax
  8009ed:	0f b6 10             	movzbl (%eax),%edx
  8009f0:	84 d2                	test   %dl,%dl
  8009f2:	75 f2                	jne    8009e6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a05:	eb 07                	jmp    800a0e <strfind+0x13>
		if (*s == c)
  800a07:	38 ca                	cmp    %cl,%dl
  800a09:	74 0a                	je     800a15 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a0b:	83 c0 01             	add    $0x1,%eax
  800a0e:	0f b6 10             	movzbl (%eax),%edx
  800a11:	84 d2                	test   %dl,%dl
  800a13:	75 f2                	jne    800a07 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a15:	5d                   	pop    %ebp
  800a16:	c3                   	ret    

00800a17 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a17:	55                   	push   %ebp
  800a18:	89 e5                	mov    %esp,%ebp
  800a1a:	57                   	push   %edi
  800a1b:	56                   	push   %esi
  800a1c:	53                   	push   %ebx
  800a1d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a20:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a23:	85 c9                	test   %ecx,%ecx
  800a25:	74 36                	je     800a5d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a27:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a2d:	75 28                	jne    800a57 <memset+0x40>
  800a2f:	f6 c1 03             	test   $0x3,%cl
  800a32:	75 23                	jne    800a57 <memset+0x40>
		c &= 0xFF;
  800a34:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a38:	89 d3                	mov    %edx,%ebx
  800a3a:	c1 e3 08             	shl    $0x8,%ebx
  800a3d:	89 d6                	mov    %edx,%esi
  800a3f:	c1 e6 18             	shl    $0x18,%esi
  800a42:	89 d0                	mov    %edx,%eax
  800a44:	c1 e0 10             	shl    $0x10,%eax
  800a47:	09 f0                	or     %esi,%eax
  800a49:	09 c2                	or     %eax,%edx
  800a4b:	89 d0                	mov    %edx,%eax
  800a4d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a4f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a52:	fc                   	cld    
  800a53:	f3 ab                	rep stos %eax,%es:(%edi)
  800a55:	eb 06                	jmp    800a5d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5a:	fc                   	cld    
  800a5b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a5d:	89 f8                	mov    %edi,%eax
  800a5f:	5b                   	pop    %ebx
  800a60:	5e                   	pop    %esi
  800a61:	5f                   	pop    %edi
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    

00800a64 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	57                   	push   %edi
  800a68:	56                   	push   %esi
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a72:	39 c6                	cmp    %eax,%esi
  800a74:	73 35                	jae    800aab <memmove+0x47>
  800a76:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a79:	39 d0                	cmp    %edx,%eax
  800a7b:	73 2e                	jae    800aab <memmove+0x47>
		s += n;
		d += n;
  800a7d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a80:	89 d6                	mov    %edx,%esi
  800a82:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a84:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a8a:	75 13                	jne    800a9f <memmove+0x3b>
  800a8c:	f6 c1 03             	test   $0x3,%cl
  800a8f:	75 0e                	jne    800a9f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a91:	83 ef 04             	sub    $0x4,%edi
  800a94:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a97:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a9a:	fd                   	std    
  800a9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9d:	eb 09                	jmp    800aa8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a9f:	83 ef 01             	sub    $0x1,%edi
  800aa2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800aa5:	fd                   	std    
  800aa6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aa8:	fc                   	cld    
  800aa9:	eb 1d                	jmp    800ac8 <memmove+0x64>
  800aab:	89 f2                	mov    %esi,%edx
  800aad:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aaf:	f6 c2 03             	test   $0x3,%dl
  800ab2:	75 0f                	jne    800ac3 <memmove+0x5f>
  800ab4:	f6 c1 03             	test   $0x3,%cl
  800ab7:	75 0a                	jne    800ac3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ab9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800abc:	89 c7                	mov    %eax,%edi
  800abe:	fc                   	cld    
  800abf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ac1:	eb 05                	jmp    800ac8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ac3:	89 c7                	mov    %eax,%edi
  800ac5:	fc                   	cld    
  800ac6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ac8:	5e                   	pop    %esi
  800ac9:	5f                   	pop    %edi
  800aca:	5d                   	pop    %ebp
  800acb:	c3                   	ret    

00800acc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800acc:	55                   	push   %ebp
  800acd:	89 e5                	mov    %esp,%ebp
  800acf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ad2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	89 04 24             	mov    %eax,(%esp)
  800ae6:	e8 79 ff ff ff       	call   800a64 <memmove>
}
  800aeb:	c9                   	leave  
  800aec:	c3                   	ret    

00800aed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	8b 55 08             	mov    0x8(%ebp),%edx
  800af5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af8:	89 d6                	mov    %edx,%esi
  800afa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800afd:	eb 1a                	jmp    800b19 <memcmp+0x2c>
		if (*s1 != *s2)
  800aff:	0f b6 02             	movzbl (%edx),%eax
  800b02:	0f b6 19             	movzbl (%ecx),%ebx
  800b05:	38 d8                	cmp    %bl,%al
  800b07:	74 0a                	je     800b13 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b09:	0f b6 c0             	movzbl %al,%eax
  800b0c:	0f b6 db             	movzbl %bl,%ebx
  800b0f:	29 d8                	sub    %ebx,%eax
  800b11:	eb 0f                	jmp    800b22 <memcmp+0x35>
		s1++, s2++;
  800b13:	83 c2 01             	add    $0x1,%edx
  800b16:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b19:	39 f2                	cmp    %esi,%edx
  800b1b:	75 e2                	jne    800aff <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b22:	5b                   	pop    %ebx
  800b23:	5e                   	pop    %esi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b2f:	89 c2                	mov    %eax,%edx
  800b31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b34:	eb 07                	jmp    800b3d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b36:	38 08                	cmp    %cl,(%eax)
  800b38:	74 07                	je     800b41 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b3a:	83 c0 01             	add    $0x1,%eax
  800b3d:	39 d0                	cmp    %edx,%eax
  800b3f:	72 f5                	jb     800b36 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	57                   	push   %edi
  800b47:	56                   	push   %esi
  800b48:	53                   	push   %ebx
  800b49:	8b 55 08             	mov    0x8(%ebp),%edx
  800b4c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b4f:	eb 03                	jmp    800b54 <strtol+0x11>
		s++;
  800b51:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b54:	0f b6 0a             	movzbl (%edx),%ecx
  800b57:	80 f9 09             	cmp    $0x9,%cl
  800b5a:	74 f5                	je     800b51 <strtol+0xe>
  800b5c:	80 f9 20             	cmp    $0x20,%cl
  800b5f:	74 f0                	je     800b51 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b61:	80 f9 2b             	cmp    $0x2b,%cl
  800b64:	75 0a                	jne    800b70 <strtol+0x2d>
		s++;
  800b66:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b69:	bf 00 00 00 00       	mov    $0x0,%edi
  800b6e:	eb 11                	jmp    800b81 <strtol+0x3e>
  800b70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b75:	80 f9 2d             	cmp    $0x2d,%cl
  800b78:	75 07                	jne    800b81 <strtol+0x3e>
		s++, neg = 1;
  800b7a:	8d 52 01             	lea    0x1(%edx),%edx
  800b7d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b81:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b86:	75 15                	jne    800b9d <strtol+0x5a>
  800b88:	80 3a 30             	cmpb   $0x30,(%edx)
  800b8b:	75 10                	jne    800b9d <strtol+0x5a>
  800b8d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b91:	75 0a                	jne    800b9d <strtol+0x5a>
		s += 2, base = 16;
  800b93:	83 c2 02             	add    $0x2,%edx
  800b96:	b8 10 00 00 00       	mov    $0x10,%eax
  800b9b:	eb 10                	jmp    800bad <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b9d:	85 c0                	test   %eax,%eax
  800b9f:	75 0c                	jne    800bad <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ba1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ba3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ba6:	75 05                	jne    800bad <strtol+0x6a>
		s++, base = 8;
  800ba8:	83 c2 01             	add    $0x1,%edx
  800bab:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bb2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bb5:	0f b6 0a             	movzbl (%edx),%ecx
  800bb8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bbb:	89 f0                	mov    %esi,%eax
  800bbd:	3c 09                	cmp    $0x9,%al
  800bbf:	77 08                	ja     800bc9 <strtol+0x86>
			dig = *s - '0';
  800bc1:	0f be c9             	movsbl %cl,%ecx
  800bc4:	83 e9 30             	sub    $0x30,%ecx
  800bc7:	eb 20                	jmp    800be9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800bc9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bcc:	89 f0                	mov    %esi,%eax
  800bce:	3c 19                	cmp    $0x19,%al
  800bd0:	77 08                	ja     800bda <strtol+0x97>
			dig = *s - 'a' + 10;
  800bd2:	0f be c9             	movsbl %cl,%ecx
  800bd5:	83 e9 57             	sub    $0x57,%ecx
  800bd8:	eb 0f                	jmp    800be9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bda:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bdd:	89 f0                	mov    %esi,%eax
  800bdf:	3c 19                	cmp    $0x19,%al
  800be1:	77 16                	ja     800bf9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800be3:	0f be c9             	movsbl %cl,%ecx
  800be6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800be9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bec:	7d 0f                	jge    800bfd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bee:	83 c2 01             	add    $0x1,%edx
  800bf1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800bf5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800bf7:	eb bc                	jmp    800bb5 <strtol+0x72>
  800bf9:	89 d8                	mov    %ebx,%eax
  800bfb:	eb 02                	jmp    800bff <strtol+0xbc>
  800bfd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800bff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c03:	74 05                	je     800c0a <strtol+0xc7>
		*endptr = (char *) s;
  800c05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c08:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c0a:	f7 d8                	neg    %eax
  800c0c:	85 ff                	test   %edi,%edi
  800c0e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c11:	5b                   	pop    %ebx
  800c12:	5e                   	pop    %esi
  800c13:	5f                   	pop    %edi
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    

00800c16 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	57                   	push   %edi
  800c1a:	56                   	push   %esi
  800c1b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c24:	8b 55 08             	mov    0x8(%ebp),%edx
  800c27:	89 c3                	mov    %eax,%ebx
  800c29:	89 c7                	mov    %eax,%edi
  800c2b:	89 c6                	mov    %eax,%esi
  800c2d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c44:	89 d1                	mov    %edx,%ecx
  800c46:	89 d3                	mov    %edx,%ebx
  800c48:	89 d7                	mov    %edx,%edi
  800c4a:	89 d6                	mov    %edx,%esi
  800c4c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c4e:	5b                   	pop    %ebx
  800c4f:	5e                   	pop    %esi
  800c50:	5f                   	pop    %edi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
  800c59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c61:	b8 03 00 00 00       	mov    $0x3,%eax
  800c66:	8b 55 08             	mov    0x8(%ebp),%edx
  800c69:	89 cb                	mov    %ecx,%ebx
  800c6b:	89 cf                	mov    %ecx,%edi
  800c6d:	89 ce                	mov    %ecx,%esi
  800c6f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c71:	85 c0                	test   %eax,%eax
  800c73:	7e 28                	jle    800c9d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c75:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c79:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c80:	00 
  800c81:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800c88:	00 
  800c89:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c90:	00 
  800c91:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800c98:	e8 0c f5 ff ff       	call   8001a9 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c9d:	83 c4 2c             	add    $0x2c,%esp
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	57                   	push   %edi
  800ca9:	56                   	push   %esi
  800caa:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cab:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb0:	b8 02 00 00 00       	mov    $0x2,%eax
  800cb5:	89 d1                	mov    %edx,%ecx
  800cb7:	89 d3                	mov    %edx,%ebx
  800cb9:	89 d7                	mov    %edx,%edi
  800cbb:	89 d6                	mov    %edx,%esi
  800cbd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5f                   	pop    %edi
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    

00800cc4 <sys_yield>:

void
sys_yield(void)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
  800cc7:	57                   	push   %edi
  800cc8:	56                   	push   %esi
  800cc9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cca:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cd4:	89 d1                	mov    %edx,%ecx
  800cd6:	89 d3                	mov    %edx,%ebx
  800cd8:	89 d7                	mov    %edx,%edi
  800cda:	89 d6                	mov    %edx,%esi
  800cdc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cde:	5b                   	pop    %ebx
  800cdf:	5e                   	pop    %esi
  800ce0:	5f                   	pop    %edi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    

00800ce3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
  800ce9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cec:	be 00 00 00 00       	mov    $0x0,%esi
  800cf1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cff:	89 f7                	mov    %esi,%edi
  800d01:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d03:	85 c0                	test   %eax,%eax
  800d05:	7e 28                	jle    800d2f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d07:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d0b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d12:	00 
  800d13:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800d1a:	00 
  800d1b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d22:	00 
  800d23:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800d2a:	e8 7a f4 ff ff       	call   8001a9 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d2f:	83 c4 2c             	add    $0x2c,%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5f                   	pop    %edi
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
  800d3a:	57                   	push   %edi
  800d3b:	56                   	push   %esi
  800d3c:	53                   	push   %ebx
  800d3d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d40:	b8 05 00 00 00       	mov    $0x5,%eax
  800d45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d48:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d51:	8b 75 18             	mov    0x18(%ebp),%esi
  800d54:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d56:	85 c0                	test   %eax,%eax
  800d58:	7e 28                	jle    800d82 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d5e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d65:	00 
  800d66:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800d6d:	00 
  800d6e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d75:	00 
  800d76:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800d7d:	e8 27 f4 ff ff       	call   8001a9 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d82:	83 c4 2c             	add    $0x2c,%esp
  800d85:	5b                   	pop    %ebx
  800d86:	5e                   	pop    %esi
  800d87:	5f                   	pop    %edi
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	57                   	push   %edi
  800d8e:	56                   	push   %esi
  800d8f:	53                   	push   %ebx
  800d90:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d98:	b8 06 00 00 00       	mov    $0x6,%eax
  800d9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
  800da3:	89 df                	mov    %ebx,%edi
  800da5:	89 de                	mov    %ebx,%esi
  800da7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	7e 28                	jle    800dd5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800db8:	00 
  800db9:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800dc0:	00 
  800dc1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc8:	00 
  800dc9:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800dd0:	e8 d4 f3 ff ff       	call   8001a9 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd5:	83 c4 2c             	add    $0x2c,%esp
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	57                   	push   %edi
  800de1:	56                   	push   %esi
  800de2:	53                   	push   %ebx
  800de3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800deb:	b8 08 00 00 00       	mov    $0x8,%eax
  800df0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df3:	8b 55 08             	mov    0x8(%ebp),%edx
  800df6:	89 df                	mov    %ebx,%edi
  800df8:	89 de                	mov    %ebx,%esi
  800dfa:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800dfc:	85 c0                	test   %eax,%eax
  800dfe:	7e 28                	jle    800e28 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e00:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e04:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e0b:	00 
  800e0c:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800e13:	00 
  800e14:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e1b:	00 
  800e1c:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800e23:	e8 81 f3 ff ff       	call   8001a9 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e28:	83 c4 2c             	add    $0x2c,%esp
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5f                   	pop    %edi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	57                   	push   %edi
  800e34:	56                   	push   %esi
  800e35:	53                   	push   %ebx
  800e36:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e46:	8b 55 08             	mov    0x8(%ebp),%edx
  800e49:	89 df                	mov    %ebx,%edi
  800e4b:	89 de                	mov    %ebx,%esi
  800e4d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	7e 28                	jle    800e7b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e53:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e57:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e5e:	00 
  800e5f:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800e66:	00 
  800e67:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e6e:	00 
  800e6f:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800e76:	e8 2e f3 ff ff       	call   8001a9 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e7b:	83 c4 2c             	add    $0x2c,%esp
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5f                   	pop    %edi
  800e81:	5d                   	pop    %ebp
  800e82:	c3                   	ret    

00800e83 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	57                   	push   %edi
  800e87:	56                   	push   %esi
  800e88:	53                   	push   %ebx
  800e89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e91:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	89 df                	mov    %ebx,%edi
  800e9e:	89 de                	mov    %ebx,%esi
  800ea0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ea2:	85 c0                	test   %eax,%eax
  800ea4:	7e 28                	jle    800ece <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eaa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800eb1:	00 
  800eb2:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800eb9:	00 
  800eba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ec1:	00 
  800ec2:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800ec9:	e8 db f2 ff ff       	call   8001a9 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ece:	83 c4 2c             	add    $0x2c,%esp
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    

00800ed6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	57                   	push   %edi
  800eda:	56                   	push   %esi
  800edb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800edc:	be 00 00 00 00       	mov    $0x0,%esi
  800ee1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ee6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eef:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ef2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ef4:	5b                   	pop    %ebx
  800ef5:	5e                   	pop    %esi
  800ef6:	5f                   	pop    %edi
  800ef7:	5d                   	pop    %ebp
  800ef8:	c3                   	ret    

00800ef9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	57                   	push   %edi
  800efd:	56                   	push   %esi
  800efe:	53                   	push   %ebx
  800eff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f07:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	89 cb                	mov    %ecx,%ebx
  800f11:	89 cf                	mov    %ecx,%edi
  800f13:	89 ce                	mov    %ecx,%esi
  800f15:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	7e 28                	jle    800f43 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f1f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f26:	00 
  800f27:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  800f2e:	00 
  800f2f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f36:	00 
  800f37:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800f3e:	e8 66 f2 ff ff       	call   8001a9 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f43:	83 c4 2c             	add    $0x2c,%esp
  800f46:	5b                   	pop    %ebx
  800f47:	5e                   	pop    %esi
  800f48:	5f                   	pop    %edi
  800f49:	5d                   	pop    %ebp
  800f4a:	c3                   	ret    

00800f4b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f4b:	55                   	push   %ebp
  800f4c:	89 e5                	mov    %esp,%ebp
  800f4e:	57                   	push   %edi
  800f4f:	56                   	push   %esi
  800f50:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f51:	ba 00 00 00 00       	mov    $0x0,%edx
  800f56:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f5b:	89 d1                	mov    %edx,%ecx
  800f5d:	89 d3                	mov    %edx,%ebx
  800f5f:	89 d7                	mov    %edx,%edi
  800f61:	89 d6                	mov    %edx,%esi
  800f63:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f65:	5b                   	pop    %ebx
  800f66:	5e                   	pop    %esi
  800f67:	5f                   	pop    %edi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    

00800f6a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	57                   	push   %edi
  800f6e:	56                   	push   %esi
  800f6f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f70:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f75:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f80:	89 df                	mov    %ebx,%edi
  800f82:	89 de                	mov    %ebx,%esi
  800f84:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    

00800f8b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	57                   	push   %edi
  800f8f:	56                   	push   %esi
  800f90:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f91:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f96:	b8 10 00 00 00       	mov    $0x10,%eax
  800f9b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa1:	89 df                	mov    %ebx,%edi
  800fa3:	89 de                	mov    %ebx,%esi
  800fa5:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800fa7:	5b                   	pop    %ebx
  800fa8:	5e                   	pop    %esi
  800fa9:	5f                   	pop    %edi
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    

00800fac <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
  800faf:	57                   	push   %edi
  800fb0:	56                   	push   %esi
  800fb1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb7:	b8 11 00 00 00       	mov    $0x11,%eax
  800fbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbf:	89 cb                	mov    %ecx,%ebx
  800fc1:	89 cf                	mov    %ecx,%edi
  800fc3:	89 ce                	mov    %ecx,%esi
  800fc5:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800fc7:	5b                   	pop    %ebx
  800fc8:	5e                   	pop    %esi
  800fc9:	5f                   	pop    %edi
  800fca:	5d                   	pop    %ebp
  800fcb:	c3                   	ret    

00800fcc <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	57                   	push   %edi
  800fd0:	56                   	push   %esi
  800fd1:	53                   	push   %ebx
  800fd2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd5:	be 00 00 00 00       	mov    $0x0,%esi
  800fda:	b8 12 00 00 00       	mov    $0x12,%eax
  800fdf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800feb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800fed:	85 c0                	test   %eax,%eax
  800fef:	7e 28                	jle    801019 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800ffc:	00 
  800ffd:	c7 44 24 08 67 2f 80 	movl   $0x802f67,0x8(%esp)
  801004:	00 
  801005:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80100c:	00 
  80100d:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  801014:	e8 90 f1 ff ff       	call   8001a9 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801019:	83 c4 2c             	add    $0x2c,%esp
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5f                   	pop    %edi
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    

00801021 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	53                   	push   %ebx
  801025:	83 ec 24             	sub    $0x24,%esp
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80102b:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0)
  80102d:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801031:	75 20                	jne    801053 <pgfault+0x32>
		panic("pgfault: faulting address [%08x] not a write\n", addr);
  801033:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801037:	c7 44 24 08 94 2f 80 	movl   $0x802f94,0x8(%esp)
  80103e:	00 
  80103f:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  801046:	00 
  801047:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  80104e:	e8 56 f1 ff ff       	call   8001a9 <_panic>

	void *page_aligned_addr = (void *) ROUNDDOWN(addr, PGSIZE);
  801053:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t page_num = (uint32_t) page_aligned_addr / PGSIZE;
  801059:	89 d8                	mov    %ebx,%eax
  80105b:	c1 e8 0c             	shr    $0xc,%eax
	if (!(uvpt[page_num] & PTE_COW))
  80105e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801065:	f6 c4 08             	test   $0x8,%ah
  801068:	75 1c                	jne    801086 <pgfault+0x65>
		panic("pgfault: fault was not on a copy-on-write page\n");
  80106a:	c7 44 24 08 c4 2f 80 	movl   $0x802fc4,0x8(%esp)
  801071:	00 
  801072:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801079:	00 
  80107a:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  801081:	e8 23 f1 ff ff       	call   8001a9 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	// Allocate
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801086:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80108d:	00 
  80108e:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801095:	00 
  801096:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80109d:	e8 41 fc ff ff       	call   800ce3 <sys_page_alloc>
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	79 20                	jns    8010c6 <pgfault+0xa5>
		panic("sys_page_alloc: %e\n", r);
  8010a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010aa:	c7 44 24 08 1f 30 80 	movl   $0x80301f,0x8(%esp)
  8010b1:	00 
  8010b2:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  8010b9:	00 
  8010ba:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  8010c1:	e8 e3 f0 ff ff       	call   8001a9 <_panic>

	// Copy over
	void *src_addr = (void *) ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, src_addr, PGSIZE);
  8010c6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8010cd:	00 
  8010ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010d2:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8010d9:	e8 86 f9 ff ff       	call   800a64 <memmove>

	// Remap
	if ((r = sys_page_map(0, PFTEMP, 0, src_addr, PTE_P | PTE_U | PTE_W)) < 0)
  8010de:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8010e5:	00 
  8010e6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010f1:	00 
  8010f2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010f9:	00 
  8010fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801101:	e8 31 fc ff ff       	call   800d37 <sys_page_map>
  801106:	85 c0                	test   %eax,%eax
  801108:	79 20                	jns    80112a <pgfault+0x109>
		panic("sys_page_map: %e\n", r);
  80110a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80110e:	c7 44 24 08 33 30 80 	movl   $0x803033,0x8(%esp)
  801115:	00 
  801116:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  80111d:	00 
  80111e:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  801125:	e8 7f f0 ff ff       	call   8001a9 <_panic>

	//panic("pgfault not implemented");
}
  80112a:	83 c4 24             	add    $0x24,%esp
  80112d:	5b                   	pop    %ebx
  80112e:	5d                   	pop    %ebp
  80112f:	c3                   	ret    

00801130 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	57                   	push   %edi
  801134:	56                   	push   %esi
  801135:	53                   	push   %ebx
  801136:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	int r;
	envid_t child_envid;

	set_pgfault_handler(pgfault);
  801139:	c7 04 24 21 10 80 00 	movl   $0x801021,(%esp)
  801140:	e8 31 17 00 00       	call   802876 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801145:	b8 07 00 00 00       	mov    $0x7,%eax
  80114a:	cd 30                	int    $0x30
  80114c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80114f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	child_envid = sys_exofork();
	if (child_envid < 0)
  801152:	85 c0                	test   %eax,%eax
  801154:	79 20                	jns    801176 <fork+0x46>
		panic("sys_exofork: %e\n", child_envid);
  801156:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80115a:	c7 44 24 08 45 30 80 	movl   $0x803045,0x8(%esp)
  801161:	00 
  801162:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  801169:	00 
  80116a:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  801171:	e8 33 f0 ff ff       	call   8001a9 <_panic>
	if (child_envid == 0) { // child
  801176:	bf 00 00 00 00       	mov    $0x0,%edi
  80117b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801180:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801184:	75 21                	jne    8011a7 <fork+0x77>
		// Fix thisenv like dumbfork does and return 0
		thisenv = &envs[ENVX(sys_getenvid())];
  801186:	e8 1a fb ff ff       	call   800ca5 <sys_getenvid>
  80118b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801190:	c1 e0 07             	shl    $0x7,%eax
  801193:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801198:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80119d:	b8 00 00 00 00       	mov    $0x0,%eax
  8011a2:	e9 53 02 00 00       	jmp    8013fa <fork+0x2ca>
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
  8011a7:	89 d8                	mov    %ebx,%eax
  8011a9:	c1 e8 0a             	shr    $0xa,%eax
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  8011ac:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011b3:	a8 01                	test   $0x1,%al
  8011b5:	0f 84 7a 01 00 00    	je     801335 <fork+0x205>
			((uvpt[page_num] & PTE_P) == PTE_P)) {
  8011bb:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  8011c2:	a8 01                	test   $0x1,%al
  8011c4:	0f 84 6b 01 00 00    	je     801335 <fork+0x205>
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
	envid_t this_envid = thisenv->env_id;
  8011ca:	a1 08 50 80 00       	mov    0x805008,%eax
  8011cf:	8b 40 48             	mov    0x48(%eax),%eax
  8011d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 4: Your code here.
	if (uvpt[pn] & PTE_SHARE) {
  8011d5:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011dc:	f6 c4 04             	test   $0x4,%ah
  8011df:	74 52                	je     801233 <fork+0x103>
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  8011e1:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011e8:	25 07 0e 00 00       	and    $0xe07,%eax
  8011ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801200:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801203:	89 04 24             	mov    %eax,(%esp)
  801206:	e8 2c fb ff ff       	call   800d37 <sys_page_map>
  80120b:	85 c0                	test   %eax,%eax
  80120d:	0f 89 22 01 00 00    	jns    801335 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801213:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801217:	c7 44 24 08 33 30 80 	movl   $0x803033,0x8(%esp)
  80121e:	00 
  80121f:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  801226:	00 
  801227:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  80122e:	e8 76 ef ff ff       	call   8001a9 <_panic>
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
  801233:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80123a:	f6 c4 08             	test   $0x8,%ah
  80123d:	75 0f                	jne    80124e <fork+0x11e>
  80123f:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801246:	a8 02                	test   $0x2,%al
  801248:	0f 84 99 00 00 00    	je     8012e7 <fork+0x1b7>
		if (uvpt[pn] & PTE_U)
  80124e:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801255:	83 e0 04             	and    $0x4,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
  801258:	83 f8 01             	cmp    $0x1,%eax
  80125b:	19 f6                	sbb    %esi,%esi
  80125d:	83 e6 fc             	and    $0xfffffffc,%esi
  801260:	81 c6 05 08 00 00    	add    $0x805,%esi
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
		if (uvpt[pn] & PTE_U)
			perm |= PTE_U;

		// Map page COW, U and P in child
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), perm)) < 0)
  801266:	89 74 24 10          	mov    %esi,0x10(%esp)
  80126a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80126e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801271:	89 44 24 08          	mov    %eax,0x8(%esp)
  801275:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801279:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80127c:	89 04 24             	mov    %eax,(%esp)
  80127f:	e8 b3 fa ff ff       	call   800d37 <sys_page_map>
  801284:	85 c0                	test   %eax,%eax
  801286:	79 20                	jns    8012a8 <fork+0x178>
			panic("sys_page_map: %e\n", r);
  801288:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80128c:	c7 44 24 08 33 30 80 	movl   $0x803033,0x8(%esp)
  801293:	00 
  801294:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80129b:	00 
  80129c:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  8012a3:	e8 01 ef ff ff       	call   8001a9 <_panic>

		// Map page COW, U and P in parent
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), this_envid, (void *) (pn*PGSIZE), perm)) < 0)
  8012a8:	89 74 24 10          	mov    %esi,0x10(%esp)
  8012ac:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012bb:	89 04 24             	mov    %eax,(%esp)
  8012be:	e8 74 fa ff ff       	call   800d37 <sys_page_map>
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	79 6e                	jns    801335 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  8012c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012cb:	c7 44 24 08 33 30 80 	movl   $0x803033,0x8(%esp)
  8012d2:	00 
  8012d3:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8012da:	00 
  8012db:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  8012e2:	e8 c2 ee ff ff       	call   8001a9 <_panic>

	} else { // map pages that are present but not writable or COW with their original permissions
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  8012e7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012ee:	25 07 0e 00 00       	and    $0xe07,%eax
  8012f3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012f7:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801302:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801306:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801309:	89 04 24             	mov    %eax,(%esp)
  80130c:	e8 26 fa ff ff       	call   800d37 <sys_page_map>
  801311:	85 c0                	test   %eax,%eax
  801313:	79 20                	jns    801335 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801315:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801319:	c7 44 24 08 33 30 80 	movl   $0x803033,0x8(%esp)
  801320:	00 
  801321:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  801328:	00 
  801329:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  801330:	e8 74 ee ff ff       	call   8001a9 <_panic>
	// and let duppage worry about the permissions.
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
  801335:	83 c3 01             	add    $0x1,%ebx
  801338:	81 c7 00 10 00 00    	add    $0x1000,%edi
  80133e:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801344:	0f 85 5d fe ff ff    	jne    8011a7 <fork+0x77>
	}

	// Allocate exception stack space for child. The child can't do this themselves
	// because the mechanism by which it would is to run the pgfault handler, which
	// needs to run on the exception stack (catch 22).
	if ((r = sys_page_alloc(child_envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80134a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801351:	00 
  801352:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801359:	ee 
  80135a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80135d:	89 04 24             	mov    %eax,(%esp)
  801360:	e8 7e f9 ff ff       	call   800ce3 <sys_page_alloc>
  801365:	85 c0                	test   %eax,%eax
  801367:	79 20                	jns    801389 <fork+0x259>
		panic("sys_page_alloc: %e\n", r);
  801369:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80136d:	c7 44 24 08 1f 30 80 	movl   $0x80301f,0x8(%esp)
  801374:	00 
  801375:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  80137c:	00 
  80137d:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  801384:	e8 20 ee ff ff       	call   8001a9 <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801389:	c7 44 24 04 f7 28 80 	movl   $0x8028f7,0x4(%esp)
  801390:	00 
  801391:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801394:	89 04 24             	mov    %eax,(%esp)
  801397:	e8 e7 fa ff ff       	call   800e83 <sys_env_set_pgfault_upcall>
  80139c:	85 c0                	test   %eax,%eax
  80139e:	79 20                	jns    8013c0 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  8013a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013a4:	c7 44 24 08 f4 2f 80 	movl   $0x802ff4,0x8(%esp)
  8013ab:	00 
  8013ac:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8013b3:	00 
  8013b4:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  8013bb:	e8 e9 ed ff ff       	call   8001a9 <_panic>

	// Mark child environment as runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  8013c0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8013c7:	00 
  8013c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013cb:	89 04 24             	mov    %eax,(%esp)
  8013ce:	e8 0a fa ff ff       	call   800ddd <sys_env_set_status>
  8013d3:	85 c0                	test   %eax,%eax
  8013d5:	79 20                	jns    8013f7 <fork+0x2c7>
		panic("sys_env_set_status: %e\n", r);
  8013d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013db:	c7 44 24 08 56 30 80 	movl   $0x803056,0x8(%esp)
  8013e2:	00 
  8013e3:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8013ea:	00 
  8013eb:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  8013f2:	e8 b2 ed ff ff       	call   8001a9 <_panic>

	return child_envid;
  8013f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8013fa:	83 c4 2c             	add    $0x2c,%esp
  8013fd:	5b                   	pop    %ebx
  8013fe:	5e                   	pop    %esi
  8013ff:	5f                   	pop    %edi
  801400:	5d                   	pop    %ebp
  801401:	c3                   	ret    

00801402 <sfork>:

// Challenge!
int
sfork(void)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	83 ec 18             	sub    $0x18,%esp
//	return __fork(1);
	panic("sfork not implemented");
  801408:	c7 44 24 08 6e 30 80 	movl   $0x80306e,0x8(%esp)
  80140f:	00 
  801410:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  801417:	00 
  801418:	c7 04 24 14 30 80 00 	movl   $0x803014,(%esp)
  80141f:	e8 85 ed ff ff       	call   8001a9 <_panic>
  801424:	66 90                	xchg   %ax,%ax
  801426:	66 90                	xchg   %ax,%ax
  801428:	66 90                	xchg   %ax,%ax
  80142a:	66 90                	xchg   %ax,%ax
  80142c:	66 90                	xchg   %ax,%ax
  80142e:	66 90                	xchg   %ax,%ax

00801430 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	56                   	push   %esi
  801434:	53                   	push   %ebx
  801435:	83 ec 10             	sub    $0x10,%esp
  801438:	8b 75 08             	mov    0x8(%ebp),%esi
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  801441:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  801443:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  801448:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80144b:	89 04 24             	mov    %eax,(%esp)
  80144e:	e8 a6 fa ff ff       	call   800ef9 <sys_ipc_recv>
  801453:	85 c0                	test   %eax,%eax
  801455:	74 16                	je     80146d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  801457:	85 f6                	test   %esi,%esi
  801459:	74 06                	je     801461 <ipc_recv+0x31>
			*from_env_store = 0;
  80145b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  801461:	85 db                	test   %ebx,%ebx
  801463:	74 2c                	je     801491 <ipc_recv+0x61>
			*perm_store = 0;
  801465:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80146b:	eb 24                	jmp    801491 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80146d:	85 f6                	test   %esi,%esi
  80146f:	74 0a                	je     80147b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  801471:	a1 08 50 80 00       	mov    0x805008,%eax
  801476:	8b 40 74             	mov    0x74(%eax),%eax
  801479:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80147b:	85 db                	test   %ebx,%ebx
  80147d:	74 0a                	je     801489 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80147f:	a1 08 50 80 00       	mov    0x805008,%eax
  801484:	8b 40 78             	mov    0x78(%eax),%eax
  801487:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  801489:	a1 08 50 80 00       	mov    0x805008,%eax
  80148e:	8b 40 70             	mov    0x70(%eax),%eax
}
  801491:	83 c4 10             	add    $0x10,%esp
  801494:	5b                   	pop    %ebx
  801495:	5e                   	pop    %esi
  801496:	5d                   	pop    %ebp
  801497:	c3                   	ret    

00801498 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
  80149b:	57                   	push   %edi
  80149c:	56                   	push   %esi
  80149d:	53                   	push   %ebx
  80149e:	83 ec 1c             	sub    $0x1c,%esp
  8014a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014a7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8014aa:	85 db                	test   %ebx,%ebx
  8014ac:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8014b1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8014b4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8014b8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	89 04 24             	mov    %eax,(%esp)
  8014c6:	e8 0b fa ff ff       	call   800ed6 <sys_ipc_try_send>
	if (r == 0) return;
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	75 22                	jne    8014f1 <ipc_send+0x59>
  8014cf:	eb 4c                	jmp    80151d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  8014d1:	84 d2                	test   %dl,%dl
  8014d3:	75 48                	jne    80151d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  8014d5:	e8 ea f7 ff ff       	call   800cc4 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  8014da:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8014de:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	89 04 24             	mov    %eax,(%esp)
  8014ec:	e8 e5 f9 ff ff       	call   800ed6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  8014f1:	85 c0                	test   %eax,%eax
  8014f3:	0f 94 c2             	sete   %dl
  8014f6:	74 d9                	je     8014d1 <ipc_send+0x39>
  8014f8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8014fb:	74 d4                	je     8014d1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  8014fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801501:	c7 44 24 08 84 30 80 	movl   $0x803084,0x8(%esp)
  801508:	00 
  801509:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  801510:	00 
  801511:	c7 04 24 92 30 80 00 	movl   $0x803092,(%esp)
  801518:	e8 8c ec ff ff       	call   8001a9 <_panic>
}
  80151d:	83 c4 1c             	add    $0x1c,%esp
  801520:	5b                   	pop    %ebx
  801521:	5e                   	pop    %esi
  801522:	5f                   	pop    %edi
  801523:	5d                   	pop    %ebp
  801524:	c3                   	ret    

00801525 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80152b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801530:	89 c2                	mov    %eax,%edx
  801532:	c1 e2 07             	shl    $0x7,%edx
  801535:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80153b:	8b 52 50             	mov    0x50(%edx),%edx
  80153e:	39 ca                	cmp    %ecx,%edx
  801540:	75 0d                	jne    80154f <ipc_find_env+0x2a>
			return envs[i].env_id;
  801542:	c1 e0 07             	shl    $0x7,%eax
  801545:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80154a:	8b 40 40             	mov    0x40(%eax),%eax
  80154d:	eb 0e                	jmp    80155d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80154f:	83 c0 01             	add    $0x1,%eax
  801552:	3d 00 04 00 00       	cmp    $0x400,%eax
  801557:	75 d7                	jne    801530 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801559:	66 b8 00 00          	mov    $0x0,%ax
}
  80155d:	5d                   	pop    %ebp
  80155e:	c3                   	ret    
  80155f:	90                   	nop

00801560 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	05 00 00 00 30       	add    $0x30000000,%eax
  80156b:	c1 e8 0c             	shr    $0xc,%eax
}
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    

00801570 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80157b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801580:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801585:	5d                   	pop    %ebp
  801586:	c3                   	ret    

00801587 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801592:	89 c2                	mov    %eax,%edx
  801594:	c1 ea 16             	shr    $0x16,%edx
  801597:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80159e:	f6 c2 01             	test   $0x1,%dl
  8015a1:	74 11                	je     8015b4 <fd_alloc+0x2d>
  8015a3:	89 c2                	mov    %eax,%edx
  8015a5:	c1 ea 0c             	shr    $0xc,%edx
  8015a8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015af:	f6 c2 01             	test   $0x1,%dl
  8015b2:	75 09                	jne    8015bd <fd_alloc+0x36>
			*fd_store = fd;
  8015b4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bb:	eb 17                	jmp    8015d4 <fd_alloc+0x4d>
  8015bd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8015c2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015c7:	75 c9                	jne    801592 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015c9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8015cf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8015d4:	5d                   	pop    %ebp
  8015d5:	c3                   	ret    

008015d6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015dc:	83 f8 1f             	cmp    $0x1f,%eax
  8015df:	77 36                	ja     801617 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015e1:	c1 e0 0c             	shl    $0xc,%eax
  8015e4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015e9:	89 c2                	mov    %eax,%edx
  8015eb:	c1 ea 16             	shr    $0x16,%edx
  8015ee:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015f5:	f6 c2 01             	test   $0x1,%dl
  8015f8:	74 24                	je     80161e <fd_lookup+0x48>
  8015fa:	89 c2                	mov    %eax,%edx
  8015fc:	c1 ea 0c             	shr    $0xc,%edx
  8015ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801606:	f6 c2 01             	test   $0x1,%dl
  801609:	74 1a                	je     801625 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80160b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80160e:	89 02                	mov    %eax,(%edx)
	return 0;
  801610:	b8 00 00 00 00       	mov    $0x0,%eax
  801615:	eb 13                	jmp    80162a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801617:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80161c:	eb 0c                	jmp    80162a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80161e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801623:	eb 05                	jmp    80162a <fd_lookup+0x54>
  801625:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80162a:	5d                   	pop    %ebp
  80162b:	c3                   	ret    

0080162c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 18             	sub    $0x18,%esp
  801632:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801635:	ba 00 00 00 00       	mov    $0x0,%edx
  80163a:	eb 13                	jmp    80164f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80163c:	39 08                	cmp    %ecx,(%eax)
  80163e:	75 0c                	jne    80164c <dev_lookup+0x20>
			*dev = devtab[i];
  801640:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801643:	89 01                	mov    %eax,(%ecx)
			return 0;
  801645:	b8 00 00 00 00       	mov    $0x0,%eax
  80164a:	eb 38                	jmp    801684 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80164c:	83 c2 01             	add    $0x1,%edx
  80164f:	8b 04 95 18 31 80 00 	mov    0x803118(,%edx,4),%eax
  801656:	85 c0                	test   %eax,%eax
  801658:	75 e2                	jne    80163c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80165a:	a1 08 50 80 00       	mov    0x805008,%eax
  80165f:	8b 40 48             	mov    0x48(%eax),%eax
  801662:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801666:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166a:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  801671:	e8 2c ec ff ff       	call   8002a2 <cprintf>
	*dev = 0;
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80167f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	56                   	push   %esi
  80168a:	53                   	push   %ebx
  80168b:	83 ec 20             	sub    $0x20,%esp
  80168e:	8b 75 08             	mov    0x8(%ebp),%esi
  801691:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801694:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801697:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80169b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016a1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016a4:	89 04 24             	mov    %eax,(%esp)
  8016a7:	e8 2a ff ff ff       	call   8015d6 <fd_lookup>
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	78 05                	js     8016b5 <fd_close+0x2f>
	    || fd != fd2)
  8016b0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016b3:	74 0c                	je     8016c1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8016b5:	84 db                	test   %bl,%bl
  8016b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bc:	0f 44 c2             	cmove  %edx,%eax
  8016bf:	eb 3f                	jmp    801700 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c8:	8b 06                	mov    (%esi),%eax
  8016ca:	89 04 24             	mov    %eax,(%esp)
  8016cd:	e8 5a ff ff ff       	call   80162c <dev_lookup>
  8016d2:	89 c3                	mov    %eax,%ebx
  8016d4:	85 c0                	test   %eax,%eax
  8016d6:	78 16                	js     8016ee <fd_close+0x68>
		if (dev->dev_close)
  8016d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016db:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8016de:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	74 07                	je     8016ee <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8016e7:	89 34 24             	mov    %esi,(%esp)
  8016ea:	ff d0                	call   *%eax
  8016ec:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016f9:	e8 8c f6 ff ff       	call   800d8a <sys_page_unmap>
	return r;
  8016fe:	89 d8                	mov    %ebx,%eax
}
  801700:	83 c4 20             	add    $0x20,%esp
  801703:	5b                   	pop    %ebx
  801704:	5e                   	pop    %esi
  801705:	5d                   	pop    %ebp
  801706:	c3                   	ret    

00801707 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80170d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801710:	89 44 24 04          	mov    %eax,0x4(%esp)
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	89 04 24             	mov    %eax,(%esp)
  80171a:	e8 b7 fe ff ff       	call   8015d6 <fd_lookup>
  80171f:	89 c2                	mov    %eax,%edx
  801721:	85 d2                	test   %edx,%edx
  801723:	78 13                	js     801738 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801725:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80172c:	00 
  80172d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801730:	89 04 24             	mov    %eax,(%esp)
  801733:	e8 4e ff ff ff       	call   801686 <fd_close>
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <close_all>:

void
close_all(void)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	53                   	push   %ebx
  80173e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801741:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801746:	89 1c 24             	mov    %ebx,(%esp)
  801749:	e8 b9 ff ff ff       	call   801707 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80174e:	83 c3 01             	add    $0x1,%ebx
  801751:	83 fb 20             	cmp    $0x20,%ebx
  801754:	75 f0                	jne    801746 <close_all+0xc>
		close(i);
}
  801756:	83 c4 14             	add    $0x14,%esp
  801759:	5b                   	pop    %ebx
  80175a:	5d                   	pop    %ebp
  80175b:	c3                   	ret    

0080175c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	57                   	push   %edi
  801760:	56                   	push   %esi
  801761:	53                   	push   %ebx
  801762:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801765:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801768:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176c:	8b 45 08             	mov    0x8(%ebp),%eax
  80176f:	89 04 24             	mov    %eax,(%esp)
  801772:	e8 5f fe ff ff       	call   8015d6 <fd_lookup>
  801777:	89 c2                	mov    %eax,%edx
  801779:	85 d2                	test   %edx,%edx
  80177b:	0f 88 e1 00 00 00    	js     801862 <dup+0x106>
		return r;
	close(newfdnum);
  801781:	8b 45 0c             	mov    0xc(%ebp),%eax
  801784:	89 04 24             	mov    %eax,(%esp)
  801787:	e8 7b ff ff ff       	call   801707 <close>

	newfd = INDEX2FD(newfdnum);
  80178c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80178f:	c1 e3 0c             	shl    $0xc,%ebx
  801792:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80179b:	89 04 24             	mov    %eax,(%esp)
  80179e:	e8 cd fd ff ff       	call   801570 <fd2data>
  8017a3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8017a5:	89 1c 24             	mov    %ebx,(%esp)
  8017a8:	e8 c3 fd ff ff       	call   801570 <fd2data>
  8017ad:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017af:	89 f0                	mov    %esi,%eax
  8017b1:	c1 e8 16             	shr    $0x16,%eax
  8017b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017bb:	a8 01                	test   $0x1,%al
  8017bd:	74 43                	je     801802 <dup+0xa6>
  8017bf:	89 f0                	mov    %esi,%eax
  8017c1:	c1 e8 0c             	shr    $0xc,%eax
  8017c4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017cb:	f6 c2 01             	test   $0x1,%dl
  8017ce:	74 32                	je     801802 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017d7:	25 07 0e 00 00       	and    $0xe07,%eax
  8017dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017e0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017e4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017eb:	00 
  8017ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f7:	e8 3b f5 ff ff       	call   800d37 <sys_page_map>
  8017fc:	89 c6                	mov    %eax,%esi
  8017fe:	85 c0                	test   %eax,%eax
  801800:	78 3e                	js     801840 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801802:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801805:	89 c2                	mov    %eax,%edx
  801807:	c1 ea 0c             	shr    $0xc,%edx
  80180a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801811:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801817:	89 54 24 10          	mov    %edx,0x10(%esp)
  80181b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80181f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801826:	00 
  801827:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801832:	e8 00 f5 ff ff       	call   800d37 <sys_page_map>
  801837:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801839:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80183c:	85 f6                	test   %esi,%esi
  80183e:	79 22                	jns    801862 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801840:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801844:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80184b:	e8 3a f5 ff ff       	call   800d8a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801850:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801854:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80185b:	e8 2a f5 ff ff       	call   800d8a <sys_page_unmap>
	return r;
  801860:	89 f0                	mov    %esi,%eax
}
  801862:	83 c4 3c             	add    $0x3c,%esp
  801865:	5b                   	pop    %ebx
  801866:	5e                   	pop    %esi
  801867:	5f                   	pop    %edi
  801868:	5d                   	pop    %ebp
  801869:	c3                   	ret    

0080186a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	53                   	push   %ebx
  80186e:	83 ec 24             	sub    $0x24,%esp
  801871:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801874:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801877:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187b:	89 1c 24             	mov    %ebx,(%esp)
  80187e:	e8 53 fd ff ff       	call   8015d6 <fd_lookup>
  801883:	89 c2                	mov    %eax,%edx
  801885:	85 d2                	test   %edx,%edx
  801887:	78 6d                	js     8018f6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801889:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801893:	8b 00                	mov    (%eax),%eax
  801895:	89 04 24             	mov    %eax,(%esp)
  801898:	e8 8f fd ff ff       	call   80162c <dev_lookup>
  80189d:	85 c0                	test   %eax,%eax
  80189f:	78 55                	js     8018f6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a4:	8b 50 08             	mov    0x8(%eax),%edx
  8018a7:	83 e2 03             	and    $0x3,%edx
  8018aa:	83 fa 01             	cmp    $0x1,%edx
  8018ad:	75 23                	jne    8018d2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018af:	a1 08 50 80 00       	mov    0x805008,%eax
  8018b4:	8b 40 48             	mov    0x48(%eax),%eax
  8018b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bf:	c7 04 24 dd 30 80 00 	movl   $0x8030dd,(%esp)
  8018c6:	e8 d7 e9 ff ff       	call   8002a2 <cprintf>
		return -E_INVAL;
  8018cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018d0:	eb 24                	jmp    8018f6 <read+0x8c>
	}
	if (!dev->dev_read)
  8018d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d5:	8b 52 08             	mov    0x8(%edx),%edx
  8018d8:	85 d2                	test   %edx,%edx
  8018da:	74 15                	je     8018f1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018ea:	89 04 24             	mov    %eax,(%esp)
  8018ed:	ff d2                	call   *%edx
  8018ef:	eb 05                	jmp    8018f6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8018f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8018f6:	83 c4 24             	add    $0x24,%esp
  8018f9:	5b                   	pop    %ebx
  8018fa:	5d                   	pop    %ebp
  8018fb:	c3                   	ret    

008018fc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	57                   	push   %edi
  801900:	56                   	push   %esi
  801901:	53                   	push   %ebx
  801902:	83 ec 1c             	sub    $0x1c,%esp
  801905:	8b 7d 08             	mov    0x8(%ebp),%edi
  801908:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80190b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801910:	eb 23                	jmp    801935 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801912:	89 f0                	mov    %esi,%eax
  801914:	29 d8                	sub    %ebx,%eax
  801916:	89 44 24 08          	mov    %eax,0x8(%esp)
  80191a:	89 d8                	mov    %ebx,%eax
  80191c:	03 45 0c             	add    0xc(%ebp),%eax
  80191f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801923:	89 3c 24             	mov    %edi,(%esp)
  801926:	e8 3f ff ff ff       	call   80186a <read>
		if (m < 0)
  80192b:	85 c0                	test   %eax,%eax
  80192d:	78 10                	js     80193f <readn+0x43>
			return m;
		if (m == 0)
  80192f:	85 c0                	test   %eax,%eax
  801931:	74 0a                	je     80193d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801933:	01 c3                	add    %eax,%ebx
  801935:	39 f3                	cmp    %esi,%ebx
  801937:	72 d9                	jb     801912 <readn+0x16>
  801939:	89 d8                	mov    %ebx,%eax
  80193b:	eb 02                	jmp    80193f <readn+0x43>
  80193d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80193f:	83 c4 1c             	add    $0x1c,%esp
  801942:	5b                   	pop    %ebx
  801943:	5e                   	pop    %esi
  801944:	5f                   	pop    %edi
  801945:	5d                   	pop    %ebp
  801946:	c3                   	ret    

00801947 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
  80194a:	53                   	push   %ebx
  80194b:	83 ec 24             	sub    $0x24,%esp
  80194e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801951:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801954:	89 44 24 04          	mov    %eax,0x4(%esp)
  801958:	89 1c 24             	mov    %ebx,(%esp)
  80195b:	e8 76 fc ff ff       	call   8015d6 <fd_lookup>
  801960:	89 c2                	mov    %eax,%edx
  801962:	85 d2                	test   %edx,%edx
  801964:	78 68                	js     8019ce <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801966:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801969:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	89 04 24             	mov    %eax,(%esp)
  801975:	e8 b2 fc ff ff       	call   80162c <dev_lookup>
  80197a:	85 c0                	test   %eax,%eax
  80197c:	78 50                	js     8019ce <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80197e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801981:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801985:	75 23                	jne    8019aa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801987:	a1 08 50 80 00       	mov    0x805008,%eax
  80198c:	8b 40 48             	mov    0x48(%eax),%eax
  80198f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801993:	89 44 24 04          	mov    %eax,0x4(%esp)
  801997:	c7 04 24 f9 30 80 00 	movl   $0x8030f9,(%esp)
  80199e:	e8 ff e8 ff ff       	call   8002a2 <cprintf>
		return -E_INVAL;
  8019a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019a8:	eb 24                	jmp    8019ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ad:	8b 52 0c             	mov    0xc(%edx),%edx
  8019b0:	85 d2                	test   %edx,%edx
  8019b2:	74 15                	je     8019c9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019c2:	89 04 24             	mov    %eax,(%esp)
  8019c5:	ff d2                	call   *%edx
  8019c7:	eb 05                	jmp    8019ce <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8019c9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8019ce:	83 c4 24             	add    $0x24,%esp
  8019d1:	5b                   	pop    %ebx
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    

008019d4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019da:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e4:	89 04 24             	mov    %eax,(%esp)
  8019e7:	e8 ea fb ff ff       	call   8015d6 <fd_lookup>
  8019ec:	85 c0                	test   %eax,%eax
  8019ee:	78 0e                	js     8019fe <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8019f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	53                   	push   %ebx
  801a04:	83 ec 24             	sub    $0x24,%esp
  801a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a0a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a11:	89 1c 24             	mov    %ebx,(%esp)
  801a14:	e8 bd fb ff ff       	call   8015d6 <fd_lookup>
  801a19:	89 c2                	mov    %eax,%edx
  801a1b:	85 d2                	test   %edx,%edx
  801a1d:	78 61                	js     801a80 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a1f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a22:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a29:	8b 00                	mov    (%eax),%eax
  801a2b:	89 04 24             	mov    %eax,(%esp)
  801a2e:	e8 f9 fb ff ff       	call   80162c <dev_lookup>
  801a33:	85 c0                	test   %eax,%eax
  801a35:	78 49                	js     801a80 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a3e:	75 23                	jne    801a63 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a40:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a45:	8b 40 48             	mov    0x48(%eax),%eax
  801a48:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a50:	c7 04 24 bc 30 80 00 	movl   $0x8030bc,(%esp)
  801a57:	e8 46 e8 ff ff       	call   8002a2 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a5c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a61:	eb 1d                	jmp    801a80 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801a63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a66:	8b 52 18             	mov    0x18(%edx),%edx
  801a69:	85 d2                	test   %edx,%edx
  801a6b:	74 0e                	je     801a7b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a70:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a74:	89 04 24             	mov    %eax,(%esp)
  801a77:	ff d2                	call   *%edx
  801a79:	eb 05                	jmp    801a80 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a7b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a80:	83 c4 24             	add    $0x24,%esp
  801a83:	5b                   	pop    %ebx
  801a84:	5d                   	pop    %ebp
  801a85:	c3                   	ret    

00801a86 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	53                   	push   %ebx
  801a8a:	83 ec 24             	sub    $0x24,%esp
  801a8d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a90:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	89 04 24             	mov    %eax,(%esp)
  801a9d:	e8 34 fb ff ff       	call   8015d6 <fd_lookup>
  801aa2:	89 c2                	mov    %eax,%edx
  801aa4:	85 d2                	test   %edx,%edx
  801aa6:	78 52                	js     801afa <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801aa8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab2:	8b 00                	mov    (%eax),%eax
  801ab4:	89 04 24             	mov    %eax,(%esp)
  801ab7:	e8 70 fb ff ff       	call   80162c <dev_lookup>
  801abc:	85 c0                	test   %eax,%eax
  801abe:	78 3a                	js     801afa <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ac7:	74 2c                	je     801af5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ac9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801acc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ad3:	00 00 00 
	stat->st_isdir = 0;
  801ad6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801add:	00 00 00 
	stat->st_dev = dev;
  801ae0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ae6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801aed:	89 14 24             	mov    %edx,(%esp)
  801af0:	ff 50 14             	call   *0x14(%eax)
  801af3:	eb 05                	jmp    801afa <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801af5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801afa:	83 c4 24             	add    $0x24,%esp
  801afd:	5b                   	pop    %ebx
  801afe:	5d                   	pop    %ebp
  801aff:	c3                   	ret    

00801b00 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	56                   	push   %esi
  801b04:	53                   	push   %ebx
  801b05:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b08:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b0f:	00 
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	89 04 24             	mov    %eax,(%esp)
  801b16:	e8 84 02 00 00       	call   801d9f <open>
  801b1b:	89 c3                	mov    %eax,%ebx
  801b1d:	85 db                	test   %ebx,%ebx
  801b1f:	78 1b                	js     801b3c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b28:	89 1c 24             	mov    %ebx,(%esp)
  801b2b:	e8 56 ff ff ff       	call   801a86 <fstat>
  801b30:	89 c6                	mov    %eax,%esi
	close(fd);
  801b32:	89 1c 24             	mov    %ebx,(%esp)
  801b35:	e8 cd fb ff ff       	call   801707 <close>
	return r;
  801b3a:	89 f0                	mov    %esi,%eax
}
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	5b                   	pop    %ebx
  801b40:	5e                   	pop    %esi
  801b41:	5d                   	pop    %ebp
  801b42:	c3                   	ret    

00801b43 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
  801b46:	56                   	push   %esi
  801b47:	53                   	push   %ebx
  801b48:	83 ec 10             	sub    $0x10,%esp
  801b4b:	89 c6                	mov    %eax,%esi
  801b4d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b4f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b56:	75 11                	jne    801b69 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b58:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b5f:	e8 c1 f9 ff ff       	call   801525 <ipc_find_env>
  801b64:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b69:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b70:	00 
  801b71:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b78:	00 
  801b79:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b7d:	a1 00 50 80 00       	mov    0x805000,%eax
  801b82:	89 04 24             	mov    %eax,(%esp)
  801b85:	e8 0e f9 ff ff       	call   801498 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b8a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b91:	00 
  801b92:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b96:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b9d:	e8 8e f8 ff ff       	call   801430 <ipc_recv>
}
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	5b                   	pop    %ebx
  801ba6:	5e                   	pop    %esi
  801ba7:	5d                   	pop    %ebp
  801ba8:	c3                   	ret    

00801ba9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
  801bac:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801bba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bc2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc7:	b8 02 00 00 00       	mov    $0x2,%eax
  801bcc:	e8 72 ff ff ff       	call   801b43 <fsipc>
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
  801bd6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	8b 40 0c             	mov    0xc(%eax),%eax
  801bdf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801be4:	ba 00 00 00 00       	mov    $0x0,%edx
  801be9:	b8 06 00 00 00       	mov    $0x6,%eax
  801bee:	e8 50 ff ff ff       	call   801b43 <fsipc>
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	53                   	push   %ebx
  801bf9:	83 ec 14             	sub    $0x14,%esp
  801bfc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	8b 40 0c             	mov    0xc(%eax),%eax
  801c05:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0f:	b8 05 00 00 00       	mov    $0x5,%eax
  801c14:	e8 2a ff ff ff       	call   801b43 <fsipc>
  801c19:	89 c2                	mov    %eax,%edx
  801c1b:	85 d2                	test   %edx,%edx
  801c1d:	78 2b                	js     801c4a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c1f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c26:	00 
  801c27:	89 1c 24             	mov    %ebx,(%esp)
  801c2a:	e8 98 ec ff ff       	call   8008c7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c2f:	a1 80 60 80 00       	mov    0x806080,%eax
  801c34:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c3a:	a1 84 60 80 00       	mov    0x806084,%eax
  801c3f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4a:	83 c4 14             	add    $0x14,%esp
  801c4d:	5b                   	pop    %ebx
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    

00801c50 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	53                   	push   %ebx
  801c54:	83 ec 14             	sub    $0x14,%esp
  801c57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c60:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801c65:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801c6b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801c70:	0f 46 c3             	cmovbe %ebx,%eax
  801c73:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801c78:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c83:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801c8a:	e8 d5 ed ff ff       	call   800a64 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801c8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c94:	b8 04 00 00 00       	mov    $0x4,%eax
  801c99:	e8 a5 fe ff ff       	call   801b43 <fsipc>
  801c9e:	85 c0                	test   %eax,%eax
  801ca0:	78 53                	js     801cf5 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801ca2:	39 c3                	cmp    %eax,%ebx
  801ca4:	73 24                	jae    801cca <devfile_write+0x7a>
  801ca6:	c7 44 24 0c 2c 31 80 	movl   $0x80312c,0xc(%esp)
  801cad:	00 
  801cae:	c7 44 24 08 33 31 80 	movl   $0x803133,0x8(%esp)
  801cb5:	00 
  801cb6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801cbd:	00 
  801cbe:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  801cc5:	e8 df e4 ff ff       	call   8001a9 <_panic>
	assert(r <= PGSIZE);
  801cca:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ccf:	7e 24                	jle    801cf5 <devfile_write+0xa5>
  801cd1:	c7 44 24 0c 53 31 80 	movl   $0x803153,0xc(%esp)
  801cd8:	00 
  801cd9:	c7 44 24 08 33 31 80 	movl   $0x803133,0x8(%esp)
  801ce0:	00 
  801ce1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801ce8:	00 
  801ce9:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  801cf0:	e8 b4 e4 ff ff       	call   8001a9 <_panic>
	return r;
}
  801cf5:	83 c4 14             	add    $0x14,%esp
  801cf8:	5b                   	pop    %ebx
  801cf9:	5d                   	pop    %ebp
  801cfa:	c3                   	ret    

00801cfb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	56                   	push   %esi
  801cff:	53                   	push   %ebx
  801d00:	83 ec 10             	sub    $0x10,%esp
  801d03:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	8b 40 0c             	mov    0xc(%eax),%eax
  801d0c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d11:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d17:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1c:	b8 03 00 00 00       	mov    $0x3,%eax
  801d21:	e8 1d fe ff ff       	call   801b43 <fsipc>
  801d26:	89 c3                	mov    %eax,%ebx
  801d28:	85 c0                	test   %eax,%eax
  801d2a:	78 6a                	js     801d96 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801d2c:	39 c6                	cmp    %eax,%esi
  801d2e:	73 24                	jae    801d54 <devfile_read+0x59>
  801d30:	c7 44 24 0c 2c 31 80 	movl   $0x80312c,0xc(%esp)
  801d37:	00 
  801d38:	c7 44 24 08 33 31 80 	movl   $0x803133,0x8(%esp)
  801d3f:	00 
  801d40:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801d47:	00 
  801d48:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  801d4f:	e8 55 e4 ff ff       	call   8001a9 <_panic>
	assert(r <= PGSIZE);
  801d54:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d59:	7e 24                	jle    801d7f <devfile_read+0x84>
  801d5b:	c7 44 24 0c 53 31 80 	movl   $0x803153,0xc(%esp)
  801d62:	00 
  801d63:	c7 44 24 08 33 31 80 	movl   $0x803133,0x8(%esp)
  801d6a:	00 
  801d6b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801d72:	00 
  801d73:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  801d7a:	e8 2a e4 ff ff       	call   8001a9 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d7f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d83:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d8a:	00 
  801d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8e:	89 04 24             	mov    %eax,(%esp)
  801d91:	e8 ce ec ff ff       	call   800a64 <memmove>
	return r;
}
  801d96:	89 d8                	mov    %ebx,%eax
  801d98:	83 c4 10             	add    $0x10,%esp
  801d9b:	5b                   	pop    %ebx
  801d9c:	5e                   	pop    %esi
  801d9d:	5d                   	pop    %ebp
  801d9e:	c3                   	ret    

00801d9f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	53                   	push   %ebx
  801da3:	83 ec 24             	sub    $0x24,%esp
  801da6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801da9:	89 1c 24             	mov    %ebx,(%esp)
  801dac:	e8 df ea ff ff       	call   800890 <strlen>
  801db1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801db6:	7f 60                	jg     801e18 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801db8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dbb:	89 04 24             	mov    %eax,(%esp)
  801dbe:	e8 c4 f7 ff ff       	call   801587 <fd_alloc>
  801dc3:	89 c2                	mov    %eax,%edx
  801dc5:	85 d2                	test   %edx,%edx
  801dc7:	78 54                	js     801e1d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801dc9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dcd:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801dd4:	e8 ee ea ff ff       	call   8008c7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ddc:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801de1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de4:	b8 01 00 00 00       	mov    $0x1,%eax
  801de9:	e8 55 fd ff ff       	call   801b43 <fsipc>
  801dee:	89 c3                	mov    %eax,%ebx
  801df0:	85 c0                	test   %eax,%eax
  801df2:	79 17                	jns    801e0b <open+0x6c>
		fd_close(fd, 0);
  801df4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801dfb:	00 
  801dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dff:	89 04 24             	mov    %eax,(%esp)
  801e02:	e8 7f f8 ff ff       	call   801686 <fd_close>
		return r;
  801e07:	89 d8                	mov    %ebx,%eax
  801e09:	eb 12                	jmp    801e1d <open+0x7e>
	}

	return fd2num(fd);
  801e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0e:	89 04 24             	mov    %eax,(%esp)
  801e11:	e8 4a f7 ff ff       	call   801560 <fd2num>
  801e16:	eb 05                	jmp    801e1d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801e18:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801e1d:	83 c4 24             	add    $0x24,%esp
  801e20:	5b                   	pop    %ebx
  801e21:	5d                   	pop    %ebp
  801e22:	c3                   	ret    

00801e23 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e29:	ba 00 00 00 00       	mov    $0x0,%edx
  801e2e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e33:	e8 0b fd ff ff       	call   801b43 <fsipc>
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    
  801e3a:	66 90                	xchg   %ax,%ax
  801e3c:	66 90                	xchg   %ax,%ax
  801e3e:	66 90                	xchg   %ax,%ax

00801e40 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e46:	c7 44 24 04 5f 31 80 	movl   $0x80315f,0x4(%esp)
  801e4d:	00 
  801e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e51:	89 04 24             	mov    %eax,(%esp)
  801e54:	e8 6e ea ff ff       	call   8008c7 <strcpy>
	return 0;
}
  801e59:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
  801e63:	53                   	push   %ebx
  801e64:	83 ec 14             	sub    $0x14,%esp
  801e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e6a:	89 1c 24             	mov    %ebx,(%esp)
  801e6d:	e8 a9 0a 00 00       	call   80291b <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801e72:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801e77:	83 f8 01             	cmp    $0x1,%eax
  801e7a:	75 0d                	jne    801e89 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801e7c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e7f:	89 04 24             	mov    %eax,(%esp)
  801e82:	e8 29 03 00 00       	call   8021b0 <nsipc_close>
  801e87:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801e89:	89 d0                	mov    %edx,%eax
  801e8b:	83 c4 14             	add    $0x14,%esp
  801e8e:	5b                   	pop    %ebx
  801e8f:	5d                   	pop    %ebp
  801e90:	c3                   	ret    

00801e91 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e97:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e9e:	00 
  801e9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb3:	89 04 24             	mov    %eax,(%esp)
  801eb6:	e8 f0 03 00 00       	call   8022ab <nsipc_send>
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ec3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801eca:	00 
  801ecb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ece:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	8b 40 0c             	mov    0xc(%eax),%eax
  801edf:	89 04 24             	mov    %eax,(%esp)
  801ee2:	e8 44 03 00 00       	call   80222b <nsipc_recv>
}
  801ee7:	c9                   	leave  
  801ee8:	c3                   	ret    

00801ee9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801ee9:	55                   	push   %ebp
  801eea:	89 e5                	mov    %esp,%ebp
  801eec:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801eef:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ef2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ef6:	89 04 24             	mov    %eax,(%esp)
  801ef9:	e8 d8 f6 ff ff       	call   8015d6 <fd_lookup>
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 17                	js     801f19 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f05:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f0b:	39 08                	cmp    %ecx,(%eax)
  801f0d:	75 05                	jne    801f14 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801f0f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f12:	eb 05                	jmp    801f19 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801f14:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
  801f1e:	56                   	push   %esi
  801f1f:	53                   	push   %ebx
  801f20:	83 ec 20             	sub    $0x20,%esp
  801f23:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f25:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f28:	89 04 24             	mov    %eax,(%esp)
  801f2b:	e8 57 f6 ff ff       	call   801587 <fd_alloc>
  801f30:	89 c3                	mov    %eax,%ebx
  801f32:	85 c0                	test   %eax,%eax
  801f34:	78 21                	js     801f57 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f36:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f3d:	00 
  801f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f41:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f45:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4c:	e8 92 ed ff ff       	call   800ce3 <sys_page_alloc>
  801f51:	89 c3                	mov    %eax,%ebx
  801f53:	85 c0                	test   %eax,%eax
  801f55:	79 0c                	jns    801f63 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801f57:	89 34 24             	mov    %esi,(%esp)
  801f5a:	e8 51 02 00 00       	call   8021b0 <nsipc_close>
		return r;
  801f5f:	89 d8                	mov    %ebx,%eax
  801f61:	eb 20                	jmp    801f83 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f63:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f71:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801f78:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801f7b:	89 14 24             	mov    %edx,(%esp)
  801f7e:	e8 dd f5 ff ff       	call   801560 <fd2num>
}
  801f83:	83 c4 20             	add    $0x20,%esp
  801f86:	5b                   	pop    %ebx
  801f87:	5e                   	pop    %esi
  801f88:	5d                   	pop    %ebp
  801f89:	c3                   	ret    

00801f8a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
  801f8d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f90:	8b 45 08             	mov    0x8(%ebp),%eax
  801f93:	e8 51 ff ff ff       	call   801ee9 <fd2sockid>
		return r;
  801f98:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	78 23                	js     801fc1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f9e:	8b 55 10             	mov    0x10(%ebp),%edx
  801fa1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fac:	89 04 24             	mov    %eax,(%esp)
  801faf:	e8 45 01 00 00       	call   8020f9 <nsipc_accept>
		return r;
  801fb4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	78 07                	js     801fc1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801fba:	e8 5c ff ff ff       	call   801f1b <alloc_sockfd>
  801fbf:	89 c1                	mov    %eax,%ecx
}
  801fc1:	89 c8                	mov    %ecx,%eax
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	e8 16 ff ff ff       	call   801ee9 <fd2sockid>
  801fd3:	89 c2                	mov    %eax,%edx
  801fd5:	85 d2                	test   %edx,%edx
  801fd7:	78 16                	js     801fef <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801fd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe7:	89 14 24             	mov    %edx,(%esp)
  801fea:	e8 60 01 00 00       	call   80214f <nsipc_bind>
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <shutdown>:

int
shutdown(int s, int how)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	e8 ea fe ff ff       	call   801ee9 <fd2sockid>
  801fff:	89 c2                	mov    %eax,%edx
  802001:	85 d2                	test   %edx,%edx
  802003:	78 0f                	js     802014 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802005:	8b 45 0c             	mov    0xc(%ebp),%eax
  802008:	89 44 24 04          	mov    %eax,0x4(%esp)
  80200c:	89 14 24             	mov    %edx,(%esp)
  80200f:	e8 7a 01 00 00       	call   80218e <nsipc_shutdown>
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	e8 c5 fe ff ff       	call   801ee9 <fd2sockid>
  802024:	89 c2                	mov    %eax,%edx
  802026:	85 d2                	test   %edx,%edx
  802028:	78 16                	js     802040 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80202a:	8b 45 10             	mov    0x10(%ebp),%eax
  80202d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802031:	8b 45 0c             	mov    0xc(%ebp),%eax
  802034:	89 44 24 04          	mov    %eax,0x4(%esp)
  802038:	89 14 24             	mov    %edx,(%esp)
  80203b:	e8 8a 01 00 00       	call   8021ca <nsipc_connect>
}
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <listen>:

int
listen(int s, int backlog)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	e8 99 fe ff ff       	call   801ee9 <fd2sockid>
  802050:	89 c2                	mov    %eax,%edx
  802052:	85 d2                	test   %edx,%edx
  802054:	78 0f                	js     802065 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802056:	8b 45 0c             	mov    0xc(%ebp),%eax
  802059:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205d:	89 14 24             	mov    %edx,(%esp)
  802060:	e8 a4 01 00 00       	call   802209 <nsipc_listen>
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
  80206a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80206d:	8b 45 10             	mov    0x10(%ebp),%eax
  802070:	89 44 24 08          	mov    %eax,0x8(%esp)
  802074:	8b 45 0c             	mov    0xc(%ebp),%eax
  802077:	89 44 24 04          	mov    %eax,0x4(%esp)
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	89 04 24             	mov    %eax,(%esp)
  802081:	e8 98 02 00 00       	call   80231e <nsipc_socket>
  802086:	89 c2                	mov    %eax,%edx
  802088:	85 d2                	test   %edx,%edx
  80208a:	78 05                	js     802091 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80208c:	e8 8a fe ff ff       	call   801f1b <alloc_sockfd>
}
  802091:	c9                   	leave  
  802092:	c3                   	ret    

00802093 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	53                   	push   %ebx
  802097:	83 ec 14             	sub    $0x14,%esp
  80209a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80209c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020a3:	75 11                	jne    8020b6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020a5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8020ac:	e8 74 f4 ff ff       	call   801525 <ipc_find_env>
  8020b1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020b6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8020bd:	00 
  8020be:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8020c5:	00 
  8020c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020ca:	a1 04 50 80 00       	mov    0x805004,%eax
  8020cf:	89 04 24             	mov    %eax,(%esp)
  8020d2:	e8 c1 f3 ff ff       	call   801498 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020de:	00 
  8020df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020e6:	00 
  8020e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ee:	e8 3d f3 ff ff       	call   801430 <ipc_recv>
}
  8020f3:	83 c4 14             	add    $0x14,%esp
  8020f6:	5b                   	pop    %ebx
  8020f7:	5d                   	pop    %ebp
  8020f8:	c3                   	ret    

008020f9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
  8020fc:	56                   	push   %esi
  8020fd:	53                   	push   %ebx
  8020fe:	83 ec 10             	sub    $0x10,%esp
  802101:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80210c:	8b 06                	mov    (%esi),%eax
  80210e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802113:	b8 01 00 00 00       	mov    $0x1,%eax
  802118:	e8 76 ff ff ff       	call   802093 <nsipc>
  80211d:	89 c3                	mov    %eax,%ebx
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 23                	js     802146 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802123:	a1 10 70 80 00       	mov    0x807010,%eax
  802128:	89 44 24 08          	mov    %eax,0x8(%esp)
  80212c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802133:	00 
  802134:	8b 45 0c             	mov    0xc(%ebp),%eax
  802137:	89 04 24             	mov    %eax,(%esp)
  80213a:	e8 25 e9 ff ff       	call   800a64 <memmove>
		*addrlen = ret->ret_addrlen;
  80213f:	a1 10 70 80 00       	mov    0x807010,%eax
  802144:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802146:	89 d8                	mov    %ebx,%eax
  802148:	83 c4 10             	add    $0x10,%esp
  80214b:	5b                   	pop    %ebx
  80214c:	5e                   	pop    %esi
  80214d:	5d                   	pop    %ebp
  80214e:	c3                   	ret    

0080214f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
  802152:	53                   	push   %ebx
  802153:	83 ec 14             	sub    $0x14,%esp
  802156:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802161:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802165:	8b 45 0c             	mov    0xc(%ebp),%eax
  802168:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802173:	e8 ec e8 ff ff       	call   800a64 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802178:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80217e:	b8 02 00 00 00       	mov    $0x2,%eax
  802183:	e8 0b ff ff ff       	call   802093 <nsipc>
}
  802188:	83 c4 14             	add    $0x14,%esp
  80218b:	5b                   	pop    %ebx
  80218c:	5d                   	pop    %ebp
  80218d:	c3                   	ret    

0080218e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80219c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021a4:	b8 03 00 00 00       	mov    $0x3,%eax
  8021a9:	e8 e5 fe ff ff       	call   802093 <nsipc>
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <nsipc_close>:

int
nsipc_close(int s)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021be:	b8 04 00 00 00       	mov    $0x4,%eax
  8021c3:	e8 cb fe ff ff       	call   802093 <nsipc>
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	53                   	push   %ebx
  8021ce:	83 ec 14             	sub    $0x14,%esp
  8021d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021dc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8021ee:	e8 71 e8 ff ff       	call   800a64 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021f3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021f9:	b8 05 00 00 00       	mov    $0x5,%eax
  8021fe:	e8 90 fe ff ff       	call   802093 <nsipc>
}
  802203:	83 c4 14             	add    $0x14,%esp
  802206:	5b                   	pop    %ebx
  802207:	5d                   	pop    %ebp
  802208:	c3                   	ret    

00802209 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802217:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80221f:	b8 06 00 00 00       	mov    $0x6,%eax
  802224:	e8 6a fe ff ff       	call   802093 <nsipc>
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	56                   	push   %esi
  80222f:	53                   	push   %ebx
  802230:	83 ec 10             	sub    $0x10,%esp
  802233:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80223e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802244:	8b 45 14             	mov    0x14(%ebp),%eax
  802247:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80224c:	b8 07 00 00 00       	mov    $0x7,%eax
  802251:	e8 3d fe ff ff       	call   802093 <nsipc>
  802256:	89 c3                	mov    %eax,%ebx
  802258:	85 c0                	test   %eax,%eax
  80225a:	78 46                	js     8022a2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80225c:	39 f0                	cmp    %esi,%eax
  80225e:	7f 07                	jg     802267 <nsipc_recv+0x3c>
  802260:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802265:	7e 24                	jle    80228b <nsipc_recv+0x60>
  802267:	c7 44 24 0c 6b 31 80 	movl   $0x80316b,0xc(%esp)
  80226e:	00 
  80226f:	c7 44 24 08 33 31 80 	movl   $0x803133,0x8(%esp)
  802276:	00 
  802277:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80227e:	00 
  80227f:	c7 04 24 80 31 80 00 	movl   $0x803180,(%esp)
  802286:	e8 1e df ff ff       	call   8001a9 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80228b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80228f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802296:	00 
  802297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229a:	89 04 24             	mov    %eax,(%esp)
  80229d:	e8 c2 e7 ff ff       	call   800a64 <memmove>
	}

	return r;
}
  8022a2:	89 d8                	mov    %ebx,%eax
  8022a4:	83 c4 10             	add    $0x10,%esp
  8022a7:	5b                   	pop    %ebx
  8022a8:	5e                   	pop    %esi
  8022a9:	5d                   	pop    %ebp
  8022aa:	c3                   	ret    

008022ab <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
  8022ae:	53                   	push   %ebx
  8022af:	83 ec 14             	sub    $0x14,%esp
  8022b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022bd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8022c3:	7e 24                	jle    8022e9 <nsipc_send+0x3e>
  8022c5:	c7 44 24 0c 8c 31 80 	movl   $0x80318c,0xc(%esp)
  8022cc:	00 
  8022cd:	c7 44 24 08 33 31 80 	movl   $0x803133,0x8(%esp)
  8022d4:	00 
  8022d5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8022dc:	00 
  8022dd:	c7 04 24 80 31 80 00 	movl   $0x803180,(%esp)
  8022e4:	e8 c0 de ff ff       	call   8001a9 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022e9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8022fb:	e8 64 e7 ff ff       	call   800a64 <memmove>
	nsipcbuf.send.req_size = size;
  802300:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802306:	8b 45 14             	mov    0x14(%ebp),%eax
  802309:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80230e:	b8 08 00 00 00       	mov    $0x8,%eax
  802313:	e8 7b fd ff ff       	call   802093 <nsipc>
}
  802318:	83 c4 14             	add    $0x14,%esp
  80231b:	5b                   	pop    %ebx
  80231c:	5d                   	pop    %ebp
  80231d:	c3                   	ret    

0080231e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802324:	8b 45 08             	mov    0x8(%ebp),%eax
  802327:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80232c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802334:	8b 45 10             	mov    0x10(%ebp),%eax
  802337:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80233c:	b8 09 00 00 00       	mov    $0x9,%eax
  802341:	e8 4d fd ff ff       	call   802093 <nsipc>
}
  802346:	c9                   	leave  
  802347:	c3                   	ret    

00802348 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802348:	55                   	push   %ebp
  802349:	89 e5                	mov    %esp,%ebp
  80234b:	56                   	push   %esi
  80234c:	53                   	push   %ebx
  80234d:	83 ec 10             	sub    $0x10,%esp
  802350:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	89 04 24             	mov    %eax,(%esp)
  802359:	e8 12 f2 ff ff       	call   801570 <fd2data>
  80235e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802360:	c7 44 24 04 98 31 80 	movl   $0x803198,0x4(%esp)
  802367:	00 
  802368:	89 1c 24             	mov    %ebx,(%esp)
  80236b:	e8 57 e5 ff ff       	call   8008c7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802370:	8b 46 04             	mov    0x4(%esi),%eax
  802373:	2b 06                	sub    (%esi),%eax
  802375:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80237b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802382:	00 00 00 
	stat->st_dev = &devpipe;
  802385:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80238c:	40 80 00 
	return 0;
}
  80238f:	b8 00 00 00 00       	mov    $0x0,%eax
  802394:	83 c4 10             	add    $0x10,%esp
  802397:	5b                   	pop    %ebx
  802398:	5e                   	pop    %esi
  802399:	5d                   	pop    %ebp
  80239a:	c3                   	ret    

0080239b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	53                   	push   %ebx
  80239f:	83 ec 14             	sub    $0x14,%esp
  8023a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023a5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023b0:	e8 d5 e9 ff ff       	call   800d8a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023b5:	89 1c 24             	mov    %ebx,(%esp)
  8023b8:	e8 b3 f1 ff ff       	call   801570 <fd2data>
  8023bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023c8:	e8 bd e9 ff ff       	call   800d8a <sys_page_unmap>
}
  8023cd:	83 c4 14             	add    $0x14,%esp
  8023d0:	5b                   	pop    %ebx
  8023d1:	5d                   	pop    %ebp
  8023d2:	c3                   	ret    

008023d3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
  8023d6:	57                   	push   %edi
  8023d7:	56                   	push   %esi
  8023d8:	53                   	push   %ebx
  8023d9:	83 ec 2c             	sub    $0x2c,%esp
  8023dc:	89 c6                	mov    %eax,%esi
  8023de:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8023e1:	a1 08 50 80 00       	mov    0x805008,%eax
  8023e6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023e9:	89 34 24             	mov    %esi,(%esp)
  8023ec:	e8 2a 05 00 00       	call   80291b <pageref>
  8023f1:	89 c7                	mov    %eax,%edi
  8023f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023f6:	89 04 24             	mov    %eax,(%esp)
  8023f9:	e8 1d 05 00 00       	call   80291b <pageref>
  8023fe:	39 c7                	cmp    %eax,%edi
  802400:	0f 94 c2             	sete   %dl
  802403:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802406:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80240c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80240f:	39 fb                	cmp    %edi,%ebx
  802411:	74 21                	je     802434 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802413:	84 d2                	test   %dl,%dl
  802415:	74 ca                	je     8023e1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802417:	8b 51 58             	mov    0x58(%ecx),%edx
  80241a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80241e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802422:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802426:	c7 04 24 9f 31 80 00 	movl   $0x80319f,(%esp)
  80242d:	e8 70 de ff ff       	call   8002a2 <cprintf>
  802432:	eb ad                	jmp    8023e1 <_pipeisclosed+0xe>
	}
}
  802434:	83 c4 2c             	add    $0x2c,%esp
  802437:	5b                   	pop    %ebx
  802438:	5e                   	pop    %esi
  802439:	5f                   	pop    %edi
  80243a:	5d                   	pop    %ebp
  80243b:	c3                   	ret    

0080243c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	57                   	push   %edi
  802440:	56                   	push   %esi
  802441:	53                   	push   %ebx
  802442:	83 ec 1c             	sub    $0x1c,%esp
  802445:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802448:	89 34 24             	mov    %esi,(%esp)
  80244b:	e8 20 f1 ff ff       	call   801570 <fd2data>
  802450:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802452:	bf 00 00 00 00       	mov    $0x0,%edi
  802457:	eb 45                	jmp    80249e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802459:	89 da                	mov    %ebx,%edx
  80245b:	89 f0                	mov    %esi,%eax
  80245d:	e8 71 ff ff ff       	call   8023d3 <_pipeisclosed>
  802462:	85 c0                	test   %eax,%eax
  802464:	75 41                	jne    8024a7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802466:	e8 59 e8 ff ff       	call   800cc4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80246b:	8b 43 04             	mov    0x4(%ebx),%eax
  80246e:	8b 0b                	mov    (%ebx),%ecx
  802470:	8d 51 20             	lea    0x20(%ecx),%edx
  802473:	39 d0                	cmp    %edx,%eax
  802475:	73 e2                	jae    802459 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802477:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80247a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80247e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802481:	99                   	cltd   
  802482:	c1 ea 1b             	shr    $0x1b,%edx
  802485:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802488:	83 e1 1f             	and    $0x1f,%ecx
  80248b:	29 d1                	sub    %edx,%ecx
  80248d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802491:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802495:	83 c0 01             	add    $0x1,%eax
  802498:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80249b:	83 c7 01             	add    $0x1,%edi
  80249e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024a1:	75 c8                	jne    80246b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8024a3:	89 f8                	mov    %edi,%eax
  8024a5:	eb 05                	jmp    8024ac <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024a7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8024ac:	83 c4 1c             	add    $0x1c,%esp
  8024af:	5b                   	pop    %ebx
  8024b0:	5e                   	pop    %esi
  8024b1:	5f                   	pop    %edi
  8024b2:	5d                   	pop    %ebp
  8024b3:	c3                   	ret    

008024b4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
  8024b7:	57                   	push   %edi
  8024b8:	56                   	push   %esi
  8024b9:	53                   	push   %ebx
  8024ba:	83 ec 1c             	sub    $0x1c,%esp
  8024bd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8024c0:	89 3c 24             	mov    %edi,(%esp)
  8024c3:	e8 a8 f0 ff ff       	call   801570 <fd2data>
  8024c8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024ca:	be 00 00 00 00       	mov    $0x0,%esi
  8024cf:	eb 3d                	jmp    80250e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8024d1:	85 f6                	test   %esi,%esi
  8024d3:	74 04                	je     8024d9 <devpipe_read+0x25>
				return i;
  8024d5:	89 f0                	mov    %esi,%eax
  8024d7:	eb 43                	jmp    80251c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8024d9:	89 da                	mov    %ebx,%edx
  8024db:	89 f8                	mov    %edi,%eax
  8024dd:	e8 f1 fe ff ff       	call   8023d3 <_pipeisclosed>
  8024e2:	85 c0                	test   %eax,%eax
  8024e4:	75 31                	jne    802517 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8024e6:	e8 d9 e7 ff ff       	call   800cc4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8024eb:	8b 03                	mov    (%ebx),%eax
  8024ed:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024f0:	74 df                	je     8024d1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024f2:	99                   	cltd   
  8024f3:	c1 ea 1b             	shr    $0x1b,%edx
  8024f6:	01 d0                	add    %edx,%eax
  8024f8:	83 e0 1f             	and    $0x1f,%eax
  8024fb:	29 d0                	sub    %edx,%eax
  8024fd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802502:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802505:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802508:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80250b:	83 c6 01             	add    $0x1,%esi
  80250e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802511:	75 d8                	jne    8024eb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802513:	89 f0                	mov    %esi,%eax
  802515:	eb 05                	jmp    80251c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802517:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80251c:	83 c4 1c             	add    $0x1c,%esp
  80251f:	5b                   	pop    %ebx
  802520:	5e                   	pop    %esi
  802521:	5f                   	pop    %edi
  802522:	5d                   	pop    %ebp
  802523:	c3                   	ret    

00802524 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
  802527:	56                   	push   %esi
  802528:	53                   	push   %ebx
  802529:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80252c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80252f:	89 04 24             	mov    %eax,(%esp)
  802532:	e8 50 f0 ff ff       	call   801587 <fd_alloc>
  802537:	89 c2                	mov    %eax,%edx
  802539:	85 d2                	test   %edx,%edx
  80253b:	0f 88 4d 01 00 00    	js     80268e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802541:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802548:	00 
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802550:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802557:	e8 87 e7 ff ff       	call   800ce3 <sys_page_alloc>
  80255c:	89 c2                	mov    %eax,%edx
  80255e:	85 d2                	test   %edx,%edx
  802560:	0f 88 28 01 00 00    	js     80268e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802566:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802569:	89 04 24             	mov    %eax,(%esp)
  80256c:	e8 16 f0 ff ff       	call   801587 <fd_alloc>
  802571:	89 c3                	mov    %eax,%ebx
  802573:	85 c0                	test   %eax,%eax
  802575:	0f 88 fe 00 00 00    	js     802679 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80257b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802582:	00 
  802583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802586:	89 44 24 04          	mov    %eax,0x4(%esp)
  80258a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802591:	e8 4d e7 ff ff       	call   800ce3 <sys_page_alloc>
  802596:	89 c3                	mov    %eax,%ebx
  802598:	85 c0                	test   %eax,%eax
  80259a:	0f 88 d9 00 00 00    	js     802679 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	89 04 24             	mov    %eax,(%esp)
  8025a6:	e8 c5 ef ff ff       	call   801570 <fd2data>
  8025ab:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025ad:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025b4:	00 
  8025b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c0:	e8 1e e7 ff ff       	call   800ce3 <sys_page_alloc>
  8025c5:	89 c3                	mov    %eax,%ebx
  8025c7:	85 c0                	test   %eax,%eax
  8025c9:	0f 88 97 00 00 00    	js     802666 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d2:	89 04 24             	mov    %eax,(%esp)
  8025d5:	e8 96 ef ff ff       	call   801570 <fd2data>
  8025da:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8025e1:	00 
  8025e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8025ed:	00 
  8025ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025f9:	e8 39 e7 ff ff       	call   800d37 <sys_page_map>
  8025fe:	89 c3                	mov    %eax,%ebx
  802600:	85 c0                	test   %eax,%eax
  802602:	78 52                	js     802656 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802604:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802619:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80261f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802622:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802627:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	89 04 24             	mov    %eax,(%esp)
  802634:	e8 27 ef ff ff       	call   801560 <fd2num>
  802639:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80263c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80263e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802641:	89 04 24             	mov    %eax,(%esp)
  802644:	e8 17 ef ff ff       	call   801560 <fd2num>
  802649:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80264c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80264f:	b8 00 00 00 00       	mov    $0x0,%eax
  802654:	eb 38                	jmp    80268e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802656:	89 74 24 04          	mov    %esi,0x4(%esp)
  80265a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802661:	e8 24 e7 ff ff       	call   800d8a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802666:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802669:	89 44 24 04          	mov    %eax,0x4(%esp)
  80266d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802674:	e8 11 e7 ff ff       	call   800d8a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802680:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802687:	e8 fe e6 ff ff       	call   800d8a <sys_page_unmap>
  80268c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80268e:	83 c4 30             	add    $0x30,%esp
  802691:	5b                   	pop    %ebx
  802692:	5e                   	pop    %esi
  802693:	5d                   	pop    %ebp
  802694:	c3                   	ret    

00802695 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
  802698:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80269b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80269e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	89 04 24             	mov    %eax,(%esp)
  8026a8:	e8 29 ef ff ff       	call   8015d6 <fd_lookup>
  8026ad:	89 c2                	mov    %eax,%edx
  8026af:	85 d2                	test   %edx,%edx
  8026b1:	78 15                	js     8026c8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	89 04 24             	mov    %eax,(%esp)
  8026b9:	e8 b2 ee ff ff       	call   801570 <fd2data>
	return _pipeisclosed(fd, p);
  8026be:	89 c2                	mov    %eax,%edx
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	e8 0b fd ff ff       	call   8023d3 <_pipeisclosed>
}
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    
  8026ca:	66 90                	xchg   %ax,%ax
  8026cc:	66 90                	xchg   %ax,%ax
  8026ce:	66 90                	xchg   %ax,%ax

008026d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8026d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d8:	5d                   	pop    %ebp
  8026d9:	c3                   	ret    

008026da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026da:	55                   	push   %ebp
  8026db:	89 e5                	mov    %esp,%ebp
  8026dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8026e0:	c7 44 24 04 b7 31 80 	movl   $0x8031b7,0x4(%esp)
  8026e7:	00 
  8026e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026eb:	89 04 24             	mov    %eax,(%esp)
  8026ee:	e8 d4 e1 ff ff       	call   8008c7 <strcpy>
	return 0;
}
  8026f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
  8026fd:	57                   	push   %edi
  8026fe:	56                   	push   %esi
  8026ff:	53                   	push   %ebx
  802700:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802706:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80270b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802711:	eb 31                	jmp    802744 <devcons_write+0x4a>
		m = n - tot;
  802713:	8b 75 10             	mov    0x10(%ebp),%esi
  802716:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802718:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80271b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802720:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802723:	89 74 24 08          	mov    %esi,0x8(%esp)
  802727:	03 45 0c             	add    0xc(%ebp),%eax
  80272a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80272e:	89 3c 24             	mov    %edi,(%esp)
  802731:	e8 2e e3 ff ff       	call   800a64 <memmove>
		sys_cputs(buf, m);
  802736:	89 74 24 04          	mov    %esi,0x4(%esp)
  80273a:	89 3c 24             	mov    %edi,(%esp)
  80273d:	e8 d4 e4 ff ff       	call   800c16 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802742:	01 f3                	add    %esi,%ebx
  802744:	89 d8                	mov    %ebx,%eax
  802746:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802749:	72 c8                	jb     802713 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80274b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802751:	5b                   	pop    %ebx
  802752:	5e                   	pop    %esi
  802753:	5f                   	pop    %edi
  802754:	5d                   	pop    %ebp
  802755:	c3                   	ret    

00802756 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802761:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802765:	75 07                	jne    80276e <devcons_read+0x18>
  802767:	eb 2a                	jmp    802793 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802769:	e8 56 e5 ff ff       	call   800cc4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80276e:	66 90                	xchg   %ax,%ax
  802770:	e8 bf e4 ff ff       	call   800c34 <sys_cgetc>
  802775:	85 c0                	test   %eax,%eax
  802777:	74 f0                	je     802769 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802779:	85 c0                	test   %eax,%eax
  80277b:	78 16                	js     802793 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80277d:	83 f8 04             	cmp    $0x4,%eax
  802780:	74 0c                	je     80278e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802782:	8b 55 0c             	mov    0xc(%ebp),%edx
  802785:	88 02                	mov    %al,(%edx)
	return 1;
  802787:	b8 01 00 00 00       	mov    $0x1,%eax
  80278c:	eb 05                	jmp    802793 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80278e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802793:	c9                   	leave  
  802794:	c3                   	ret    

00802795 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802795:	55                   	push   %ebp
  802796:	89 e5                	mov    %esp,%ebp
  802798:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80279b:	8b 45 08             	mov    0x8(%ebp),%eax
  80279e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8027a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8027a8:	00 
  8027a9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027ac:	89 04 24             	mov    %eax,(%esp)
  8027af:	e8 62 e4 ff ff       	call   800c16 <sys_cputs>
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <getchar>:

int
getchar(void)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
  8027b9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8027bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8027c3:	00 
  8027c4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d2:	e8 93 f0 ff ff       	call   80186a <read>
	if (r < 0)
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	78 0f                	js     8027ea <getchar+0x34>
		return r;
	if (r < 1)
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	7e 06                	jle    8027e5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8027df:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8027e3:	eb 05                	jmp    8027ea <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8027e5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8027ea:	c9                   	leave  
  8027eb:	c3                   	ret    

008027ec <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
  8027ef:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fc:	89 04 24             	mov    %eax,(%esp)
  8027ff:	e8 d2 ed ff ff       	call   8015d6 <fd_lookup>
  802804:	85 c0                	test   %eax,%eax
  802806:	78 11                	js     802819 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802811:	39 10                	cmp    %edx,(%eax)
  802813:	0f 94 c0             	sete   %al
  802816:	0f b6 c0             	movzbl %al,%eax
}
  802819:	c9                   	leave  
  80281a:	c3                   	ret    

0080281b <opencons>:

int
opencons(void)
{
  80281b:	55                   	push   %ebp
  80281c:	89 e5                	mov    %esp,%ebp
  80281e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802821:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802824:	89 04 24             	mov    %eax,(%esp)
  802827:	e8 5b ed ff ff       	call   801587 <fd_alloc>
		return r;
  80282c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80282e:	85 c0                	test   %eax,%eax
  802830:	78 40                	js     802872 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802832:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802839:	00 
  80283a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802841:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802848:	e8 96 e4 ff ff       	call   800ce3 <sys_page_alloc>
		return r;
  80284d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80284f:	85 c0                	test   %eax,%eax
  802851:	78 1f                	js     802872 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802853:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80285e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802861:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802868:	89 04 24             	mov    %eax,(%esp)
  80286b:	e8 f0 ec ff ff       	call   801560 <fd2num>
  802870:	89 c2                	mov    %eax,%edx
}
  802872:	89 d0                	mov    %edx,%eax
  802874:	c9                   	leave  
  802875:	c3                   	ret    

00802876 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802876:	55                   	push   %ebp
  802877:	89 e5                	mov    %esp,%ebp
  802879:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80287c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802883:	75 68                	jne    8028ed <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  802885:	a1 08 50 80 00       	mov    0x805008,%eax
  80288a:	8b 40 48             	mov    0x48(%eax),%eax
  80288d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802894:	00 
  802895:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80289c:	ee 
  80289d:	89 04 24             	mov    %eax,(%esp)
  8028a0:	e8 3e e4 ff ff       	call   800ce3 <sys_page_alloc>
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	74 2c                	je     8028d5 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  8028a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ad:	c7 04 24 c4 31 80 00 	movl   $0x8031c4,(%esp)
  8028b4:	e8 e9 d9 ff ff       	call   8002a2 <cprintf>
			panic("set_pg_fault_handler");
  8028b9:	c7 44 24 08 f8 31 80 	movl   $0x8031f8,0x8(%esp)
  8028c0:	00 
  8028c1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8028c8:	00 
  8028c9:	c7 04 24 0d 32 80 00 	movl   $0x80320d,(%esp)
  8028d0:	e8 d4 d8 ff ff       	call   8001a9 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  8028d5:	a1 08 50 80 00       	mov    0x805008,%eax
  8028da:	8b 40 48             	mov    0x48(%eax),%eax
  8028dd:	c7 44 24 04 f7 28 80 	movl   $0x8028f7,0x4(%esp)
  8028e4:	00 
  8028e5:	89 04 24             	mov    %eax,(%esp)
  8028e8:	e8 96 e5 ff ff       	call   800e83 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f0:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028f5:	c9                   	leave  
  8028f6:	c3                   	ret    

008028f7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028f7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028f8:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8028fd:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028ff:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  802902:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  802906:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  802908:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  80290c:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  80290d:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  802910:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  802912:	58                   	pop    %eax
	popl %eax
  802913:	58                   	pop    %eax
	popal
  802914:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802915:	83 c4 04             	add    $0x4,%esp
	popfl
  802918:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802919:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80291a:	c3                   	ret    

0080291b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80291b:	55                   	push   %ebp
  80291c:	89 e5                	mov    %esp,%ebp
  80291e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802921:	89 d0                	mov    %edx,%eax
  802923:	c1 e8 16             	shr    $0x16,%eax
  802926:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80292d:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802932:	f6 c1 01             	test   $0x1,%cl
  802935:	74 1d                	je     802954 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802937:	c1 ea 0c             	shr    $0xc,%edx
  80293a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802941:	f6 c2 01             	test   $0x1,%dl
  802944:	74 0e                	je     802954 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802946:	c1 ea 0c             	shr    $0xc,%edx
  802949:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802950:	ef 
  802951:	0f b7 c0             	movzwl %ax,%eax
}
  802954:	5d                   	pop    %ebp
  802955:	c3                   	ret    
  802956:	66 90                	xchg   %ax,%ax
  802958:	66 90                	xchg   %ax,%ax
  80295a:	66 90                	xchg   %ax,%ax
  80295c:	66 90                	xchg   %ax,%ax
  80295e:	66 90                	xchg   %ax,%ax

00802960 <__udivdi3>:
  802960:	55                   	push   %ebp
  802961:	57                   	push   %edi
  802962:	56                   	push   %esi
  802963:	83 ec 0c             	sub    $0xc,%esp
  802966:	8b 44 24 28          	mov    0x28(%esp),%eax
  80296a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80296e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802972:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802976:	85 c0                	test   %eax,%eax
  802978:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80297c:	89 ea                	mov    %ebp,%edx
  80297e:	89 0c 24             	mov    %ecx,(%esp)
  802981:	75 2d                	jne    8029b0 <__udivdi3+0x50>
  802983:	39 e9                	cmp    %ebp,%ecx
  802985:	77 61                	ja     8029e8 <__udivdi3+0x88>
  802987:	85 c9                	test   %ecx,%ecx
  802989:	89 ce                	mov    %ecx,%esi
  80298b:	75 0b                	jne    802998 <__udivdi3+0x38>
  80298d:	b8 01 00 00 00       	mov    $0x1,%eax
  802992:	31 d2                	xor    %edx,%edx
  802994:	f7 f1                	div    %ecx
  802996:	89 c6                	mov    %eax,%esi
  802998:	31 d2                	xor    %edx,%edx
  80299a:	89 e8                	mov    %ebp,%eax
  80299c:	f7 f6                	div    %esi
  80299e:	89 c5                	mov    %eax,%ebp
  8029a0:	89 f8                	mov    %edi,%eax
  8029a2:	f7 f6                	div    %esi
  8029a4:	89 ea                	mov    %ebp,%edx
  8029a6:	83 c4 0c             	add    $0xc,%esp
  8029a9:	5e                   	pop    %esi
  8029aa:	5f                   	pop    %edi
  8029ab:	5d                   	pop    %ebp
  8029ac:	c3                   	ret    
  8029ad:	8d 76 00             	lea    0x0(%esi),%esi
  8029b0:	39 e8                	cmp    %ebp,%eax
  8029b2:	77 24                	ja     8029d8 <__udivdi3+0x78>
  8029b4:	0f bd e8             	bsr    %eax,%ebp
  8029b7:	83 f5 1f             	xor    $0x1f,%ebp
  8029ba:	75 3c                	jne    8029f8 <__udivdi3+0x98>
  8029bc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8029c0:	39 34 24             	cmp    %esi,(%esp)
  8029c3:	0f 86 9f 00 00 00    	jbe    802a68 <__udivdi3+0x108>
  8029c9:	39 d0                	cmp    %edx,%eax
  8029cb:	0f 82 97 00 00 00    	jb     802a68 <__udivdi3+0x108>
  8029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029d8:	31 d2                	xor    %edx,%edx
  8029da:	31 c0                	xor    %eax,%eax
  8029dc:	83 c4 0c             	add    $0xc,%esp
  8029df:	5e                   	pop    %esi
  8029e0:	5f                   	pop    %edi
  8029e1:	5d                   	pop    %ebp
  8029e2:	c3                   	ret    
  8029e3:	90                   	nop
  8029e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029e8:	89 f8                	mov    %edi,%eax
  8029ea:	f7 f1                	div    %ecx
  8029ec:	31 d2                	xor    %edx,%edx
  8029ee:	83 c4 0c             	add    $0xc,%esp
  8029f1:	5e                   	pop    %esi
  8029f2:	5f                   	pop    %edi
  8029f3:	5d                   	pop    %ebp
  8029f4:	c3                   	ret    
  8029f5:	8d 76 00             	lea    0x0(%esi),%esi
  8029f8:	89 e9                	mov    %ebp,%ecx
  8029fa:	8b 3c 24             	mov    (%esp),%edi
  8029fd:	d3 e0                	shl    %cl,%eax
  8029ff:	89 c6                	mov    %eax,%esi
  802a01:	b8 20 00 00 00       	mov    $0x20,%eax
  802a06:	29 e8                	sub    %ebp,%eax
  802a08:	89 c1                	mov    %eax,%ecx
  802a0a:	d3 ef                	shr    %cl,%edi
  802a0c:	89 e9                	mov    %ebp,%ecx
  802a0e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802a12:	8b 3c 24             	mov    (%esp),%edi
  802a15:	09 74 24 08          	or     %esi,0x8(%esp)
  802a19:	89 d6                	mov    %edx,%esi
  802a1b:	d3 e7                	shl    %cl,%edi
  802a1d:	89 c1                	mov    %eax,%ecx
  802a1f:	89 3c 24             	mov    %edi,(%esp)
  802a22:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a26:	d3 ee                	shr    %cl,%esi
  802a28:	89 e9                	mov    %ebp,%ecx
  802a2a:	d3 e2                	shl    %cl,%edx
  802a2c:	89 c1                	mov    %eax,%ecx
  802a2e:	d3 ef                	shr    %cl,%edi
  802a30:	09 d7                	or     %edx,%edi
  802a32:	89 f2                	mov    %esi,%edx
  802a34:	89 f8                	mov    %edi,%eax
  802a36:	f7 74 24 08          	divl   0x8(%esp)
  802a3a:	89 d6                	mov    %edx,%esi
  802a3c:	89 c7                	mov    %eax,%edi
  802a3e:	f7 24 24             	mull   (%esp)
  802a41:	39 d6                	cmp    %edx,%esi
  802a43:	89 14 24             	mov    %edx,(%esp)
  802a46:	72 30                	jb     802a78 <__udivdi3+0x118>
  802a48:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a4c:	89 e9                	mov    %ebp,%ecx
  802a4e:	d3 e2                	shl    %cl,%edx
  802a50:	39 c2                	cmp    %eax,%edx
  802a52:	73 05                	jae    802a59 <__udivdi3+0xf9>
  802a54:	3b 34 24             	cmp    (%esp),%esi
  802a57:	74 1f                	je     802a78 <__udivdi3+0x118>
  802a59:	89 f8                	mov    %edi,%eax
  802a5b:	31 d2                	xor    %edx,%edx
  802a5d:	e9 7a ff ff ff       	jmp    8029dc <__udivdi3+0x7c>
  802a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a68:	31 d2                	xor    %edx,%edx
  802a6a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a6f:	e9 68 ff ff ff       	jmp    8029dc <__udivdi3+0x7c>
  802a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a78:	8d 47 ff             	lea    -0x1(%edi),%eax
  802a7b:	31 d2                	xor    %edx,%edx
  802a7d:	83 c4 0c             	add    $0xc,%esp
  802a80:	5e                   	pop    %esi
  802a81:	5f                   	pop    %edi
  802a82:	5d                   	pop    %ebp
  802a83:	c3                   	ret    
  802a84:	66 90                	xchg   %ax,%ax
  802a86:	66 90                	xchg   %ax,%ax
  802a88:	66 90                	xchg   %ax,%ax
  802a8a:	66 90                	xchg   %ax,%ax
  802a8c:	66 90                	xchg   %ax,%ax
  802a8e:	66 90                	xchg   %ax,%ax

00802a90 <__umoddi3>:
  802a90:	55                   	push   %ebp
  802a91:	57                   	push   %edi
  802a92:	56                   	push   %esi
  802a93:	83 ec 14             	sub    $0x14,%esp
  802a96:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a9a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a9e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802aa2:	89 c7                	mov    %eax,%edi
  802aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aa8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802aac:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ab0:	89 34 24             	mov    %esi,(%esp)
  802ab3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ab7:	85 c0                	test   %eax,%eax
  802ab9:	89 c2                	mov    %eax,%edx
  802abb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802abf:	75 17                	jne    802ad8 <__umoddi3+0x48>
  802ac1:	39 fe                	cmp    %edi,%esi
  802ac3:	76 4b                	jbe    802b10 <__umoddi3+0x80>
  802ac5:	89 c8                	mov    %ecx,%eax
  802ac7:	89 fa                	mov    %edi,%edx
  802ac9:	f7 f6                	div    %esi
  802acb:	89 d0                	mov    %edx,%eax
  802acd:	31 d2                	xor    %edx,%edx
  802acf:	83 c4 14             	add    $0x14,%esp
  802ad2:	5e                   	pop    %esi
  802ad3:	5f                   	pop    %edi
  802ad4:	5d                   	pop    %ebp
  802ad5:	c3                   	ret    
  802ad6:	66 90                	xchg   %ax,%ax
  802ad8:	39 f8                	cmp    %edi,%eax
  802ada:	77 54                	ja     802b30 <__umoddi3+0xa0>
  802adc:	0f bd e8             	bsr    %eax,%ebp
  802adf:	83 f5 1f             	xor    $0x1f,%ebp
  802ae2:	75 5c                	jne    802b40 <__umoddi3+0xb0>
  802ae4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802ae8:	39 3c 24             	cmp    %edi,(%esp)
  802aeb:	0f 87 e7 00 00 00    	ja     802bd8 <__umoddi3+0x148>
  802af1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802af5:	29 f1                	sub    %esi,%ecx
  802af7:	19 c7                	sbb    %eax,%edi
  802af9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802afd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b01:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b05:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802b09:	83 c4 14             	add    $0x14,%esp
  802b0c:	5e                   	pop    %esi
  802b0d:	5f                   	pop    %edi
  802b0e:	5d                   	pop    %ebp
  802b0f:	c3                   	ret    
  802b10:	85 f6                	test   %esi,%esi
  802b12:	89 f5                	mov    %esi,%ebp
  802b14:	75 0b                	jne    802b21 <__umoddi3+0x91>
  802b16:	b8 01 00 00 00       	mov    $0x1,%eax
  802b1b:	31 d2                	xor    %edx,%edx
  802b1d:	f7 f6                	div    %esi
  802b1f:	89 c5                	mov    %eax,%ebp
  802b21:	8b 44 24 04          	mov    0x4(%esp),%eax
  802b25:	31 d2                	xor    %edx,%edx
  802b27:	f7 f5                	div    %ebp
  802b29:	89 c8                	mov    %ecx,%eax
  802b2b:	f7 f5                	div    %ebp
  802b2d:	eb 9c                	jmp    802acb <__umoddi3+0x3b>
  802b2f:	90                   	nop
  802b30:	89 c8                	mov    %ecx,%eax
  802b32:	89 fa                	mov    %edi,%edx
  802b34:	83 c4 14             	add    $0x14,%esp
  802b37:	5e                   	pop    %esi
  802b38:	5f                   	pop    %edi
  802b39:	5d                   	pop    %ebp
  802b3a:	c3                   	ret    
  802b3b:	90                   	nop
  802b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b40:	8b 04 24             	mov    (%esp),%eax
  802b43:	be 20 00 00 00       	mov    $0x20,%esi
  802b48:	89 e9                	mov    %ebp,%ecx
  802b4a:	29 ee                	sub    %ebp,%esi
  802b4c:	d3 e2                	shl    %cl,%edx
  802b4e:	89 f1                	mov    %esi,%ecx
  802b50:	d3 e8                	shr    %cl,%eax
  802b52:	89 e9                	mov    %ebp,%ecx
  802b54:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b58:	8b 04 24             	mov    (%esp),%eax
  802b5b:	09 54 24 04          	or     %edx,0x4(%esp)
  802b5f:	89 fa                	mov    %edi,%edx
  802b61:	d3 e0                	shl    %cl,%eax
  802b63:	89 f1                	mov    %esi,%ecx
  802b65:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b69:	8b 44 24 10          	mov    0x10(%esp),%eax
  802b6d:	d3 ea                	shr    %cl,%edx
  802b6f:	89 e9                	mov    %ebp,%ecx
  802b71:	d3 e7                	shl    %cl,%edi
  802b73:	89 f1                	mov    %esi,%ecx
  802b75:	d3 e8                	shr    %cl,%eax
  802b77:	89 e9                	mov    %ebp,%ecx
  802b79:	09 f8                	or     %edi,%eax
  802b7b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802b7f:	f7 74 24 04          	divl   0x4(%esp)
  802b83:	d3 e7                	shl    %cl,%edi
  802b85:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b89:	89 d7                	mov    %edx,%edi
  802b8b:	f7 64 24 08          	mull   0x8(%esp)
  802b8f:	39 d7                	cmp    %edx,%edi
  802b91:	89 c1                	mov    %eax,%ecx
  802b93:	89 14 24             	mov    %edx,(%esp)
  802b96:	72 2c                	jb     802bc4 <__umoddi3+0x134>
  802b98:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802b9c:	72 22                	jb     802bc0 <__umoddi3+0x130>
  802b9e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802ba2:	29 c8                	sub    %ecx,%eax
  802ba4:	19 d7                	sbb    %edx,%edi
  802ba6:	89 e9                	mov    %ebp,%ecx
  802ba8:	89 fa                	mov    %edi,%edx
  802baa:	d3 e8                	shr    %cl,%eax
  802bac:	89 f1                	mov    %esi,%ecx
  802bae:	d3 e2                	shl    %cl,%edx
  802bb0:	89 e9                	mov    %ebp,%ecx
  802bb2:	d3 ef                	shr    %cl,%edi
  802bb4:	09 d0                	or     %edx,%eax
  802bb6:	89 fa                	mov    %edi,%edx
  802bb8:	83 c4 14             	add    $0x14,%esp
  802bbb:	5e                   	pop    %esi
  802bbc:	5f                   	pop    %edi
  802bbd:	5d                   	pop    %ebp
  802bbe:	c3                   	ret    
  802bbf:	90                   	nop
  802bc0:	39 d7                	cmp    %edx,%edi
  802bc2:	75 da                	jne    802b9e <__umoddi3+0x10e>
  802bc4:	8b 14 24             	mov    (%esp),%edx
  802bc7:	89 c1                	mov    %eax,%ecx
  802bc9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802bcd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802bd1:	eb cb                	jmp    802b9e <__umoddi3+0x10e>
  802bd3:	90                   	nop
  802bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bd8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802bdc:	0f 82 0f ff ff ff    	jb     802af1 <__umoddi3+0x61>
  802be2:	e9 1a ff ff ff       	jmp    802b01 <__umoddi3+0x71>
