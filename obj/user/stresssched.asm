
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 e0 00 00 00       	call   800111 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <umain>:

volatile int counter;

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800048:	e8 28 0c 00 00       	call   800c75 <sys_getenvid>
  80004d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80004f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800054:	e8 a7 10 00 00       	call   801100 <fork>
  800059:	85 c0                	test   %eax,%eax
  80005b:	74 0a                	je     800067 <umain+0x27>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  80005d:	83 c3 01             	add    $0x1,%ebx
  800060:	83 fb 14             	cmp    $0x14,%ebx
  800063:	75 ef                	jne    800054 <umain+0x14>
  800065:	eb 18                	jmp    80007f <umain+0x3f>
		if (fork() == 0)
			break;
	if (i == 20) {
  800067:	83 fb 14             	cmp    $0x14,%ebx
  80006a:	74 13                	je     80007f <umain+0x3f>
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80006c:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800072:	89 f2                	mov    %esi,%edx
  800074:	c1 e2 07             	shl    $0x7,%edx
  800077:	81 c2 04 00 c0 ee    	add    $0xeec00004,%edx
  80007d:	eb 0c                	jmp    80008b <umain+0x4b>
	// Fork several environments
	for (i = 0; i < 20; i++)
		if (fork() == 0)
			break;
	if (i == 20) {
		sys_yield();
  80007f:	e8 10 0c 00 00       	call   800c94 <sys_yield>
		return;
  800084:	e9 81 00 00 00       	jmp    80010a <umain+0xca>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");
  800089:	f3 90                	pause  
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80008b:	8b 42 50             	mov    0x50(%edx),%eax
  80008e:	85 c0                	test   %eax,%eax
  800090:	75 f7                	jne    800089 <umain+0x49>
  800092:	bb 0a 00 00 00       	mov    $0xa,%ebx
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  800097:	e8 f8 0b 00 00       	call   800c94 <sys_yield>
  80009c:	b8 10 27 00 00       	mov    $0x2710,%eax
		for (j = 0; j < 10000; j++)
			counter++;
  8000a1:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8000a7:	83 c2 01             	add    $0x1,%edx
  8000aa:	89 15 08 50 80 00    	mov    %edx,0x805008
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
		for (j = 0; j < 10000; j++)
  8000b0:	83 e8 01             	sub    $0x1,%eax
  8000b3:	75 ec                	jne    8000a1 <umain+0x61>
	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  8000b5:	83 eb 01             	sub    $0x1,%ebx
  8000b8:	75 dd                	jne    800097 <umain+0x57>
		sys_yield();
		for (j = 0; j < 10000; j++)
			counter++;
	}

	if (counter != 10*10000)
  8000ba:	a1 08 50 80 00       	mov    0x805008,%eax
  8000bf:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000c4:	74 25                	je     8000eb <umain+0xab>
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8000cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000cf:	c7 44 24 08 c0 2b 80 	movl   $0x802bc0,0x8(%esp)
  8000d6:	00 
  8000d7:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8000de:	00 
  8000df:	c7 04 24 e8 2b 80 00 	movl   $0x802be8,(%esp)
  8000e6:	e8 87 00 00 00       	call   800172 <_panic>

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000eb:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8000f0:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000f3:	8b 40 48             	mov    0x48(%eax),%eax
  8000f6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000fe:	c7 04 24 fb 2b 80 00 	movl   $0x802bfb,(%esp)
  800105:	e8 61 01 00 00       	call   80026b <cprintf>

}
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	5b                   	pop    %ebx
  80010e:	5e                   	pop    %esi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    

00800111 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	83 ec 10             	sub    $0x10,%esp
  800119:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80011c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80011f:	e8 51 0b 00 00       	call   800c75 <sys_getenvid>
  800124:	25 ff 03 00 00       	and    $0x3ff,%eax
  800129:	c1 e0 07             	shl    $0x7,%eax
  80012c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800131:	a3 0c 50 80 00       	mov    %eax,0x80500c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800136:	85 db                	test   %ebx,%ebx
  800138:	7e 07                	jle    800141 <libmain+0x30>
		binaryname = argv[0];
  80013a:	8b 06                	mov    (%esi),%eax
  80013c:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800141:	89 74 24 04          	mov    %esi,0x4(%esp)
  800145:	89 1c 24             	mov    %ebx,(%esp)
  800148:	e8 f3 fe ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  80014d:	e8 07 00 00 00       	call   800159 <exit>
}
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5d                   	pop    %ebp
  800158:	c3                   	ret    

00800159 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80015f:	e8 76 14 00 00       	call   8015da <close_all>
	sys_env_destroy(0);
  800164:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80016b:	e8 b3 0a 00 00       	call   800c23 <sys_env_destroy>
}
  800170:	c9                   	leave  
  800171:	c3                   	ret    

00800172 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800172:	55                   	push   %ebp
  800173:	89 e5                	mov    %esp,%ebp
  800175:	56                   	push   %esi
  800176:	53                   	push   %ebx
  800177:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80017a:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80017d:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800183:	e8 ed 0a 00 00       	call   800c75 <sys_getenvid>
  800188:	8b 55 0c             	mov    0xc(%ebp),%edx
  80018b:	89 54 24 10          	mov    %edx,0x10(%esp)
  80018f:	8b 55 08             	mov    0x8(%ebp),%edx
  800192:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800196:	89 74 24 08          	mov    %esi,0x8(%esp)
  80019a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019e:	c7 04 24 24 2c 80 00 	movl   $0x802c24,(%esp)
  8001a5:	e8 c1 00 00 00       	call   80026b <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001aa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8001b1:	89 04 24             	mov    %eax,(%esp)
  8001b4:	e8 51 00 00 00       	call   80020a <vcprintf>
	cprintf("\n");
  8001b9:	c7 04 24 17 2c 80 00 	movl   $0x802c17,(%esp)
  8001c0:	e8 a6 00 00 00       	call   80026b <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001c5:	cc                   	int3   
  8001c6:	eb fd                	jmp    8001c5 <_panic+0x53>

008001c8 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	53                   	push   %ebx
  8001cc:	83 ec 14             	sub    $0x14,%esp
  8001cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001d2:	8b 13                	mov    (%ebx),%edx
  8001d4:	8d 42 01             	lea    0x1(%edx),%eax
  8001d7:	89 03                	mov    %eax,(%ebx)
  8001d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001dc:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001e0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001e5:	75 19                	jne    800200 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001e7:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001ee:	00 
  8001ef:	8d 43 08             	lea    0x8(%ebx),%eax
  8001f2:	89 04 24             	mov    %eax,(%esp)
  8001f5:	e8 ec 09 00 00       	call   800be6 <sys_cputs>
		b->idx = 0;
  8001fa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800200:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800204:	83 c4 14             	add    $0x14,%esp
  800207:	5b                   	pop    %ebx
  800208:	5d                   	pop    %ebp
  800209:	c3                   	ret    

0080020a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80020a:	55                   	push   %ebp
  80020b:	89 e5                	mov    %esp,%ebp
  80020d:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800213:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80021a:	00 00 00 
	b.cnt = 0;
  80021d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800224:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	89 44 24 08          	mov    %eax,0x8(%esp)
  800235:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023f:	c7 04 24 c8 01 80 00 	movl   $0x8001c8,(%esp)
  800246:	e8 b3 01 00 00       	call   8003fe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80024b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800251:	89 44 24 04          	mov    %eax,0x4(%esp)
  800255:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80025b:	89 04 24             	mov    %eax,(%esp)
  80025e:	e8 83 09 00 00       	call   800be6 <sys_cputs>

	return b.cnt;
}
  800263:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800269:	c9                   	leave  
  80026a:	c3                   	ret    

0080026b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800271:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800274:	89 44 24 04          	mov    %eax,0x4(%esp)
  800278:	8b 45 08             	mov    0x8(%ebp),%eax
  80027b:	89 04 24             	mov    %eax,(%esp)
  80027e:	e8 87 ff ff ff       	call   80020a <vcprintf>
	va_end(ap);

	return cnt;
}
  800283:	c9                   	leave  
  800284:	c3                   	ret    
  800285:	66 90                	xchg   %ax,%ax
  800287:	66 90                	xchg   %ax,%ax
  800289:	66 90                	xchg   %ax,%ax
  80028b:	66 90                	xchg   %ax,%ax
  80028d:	66 90                	xchg   %ax,%ax
  80028f:	90                   	nop

00800290 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	57                   	push   %edi
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	83 ec 3c             	sub    $0x3c,%esp
  800299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80029c:	89 d7                	mov    %edx,%edi
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a7:	89 c3                	mov    %eax,%ebx
  8002a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8002af:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002bd:	39 d9                	cmp    %ebx,%ecx
  8002bf:	72 05                	jb     8002c6 <printnum+0x36>
  8002c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c4:	77 69                	ja     80032f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002c9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002cd:	83 ee 01             	sub    $0x1,%esi
  8002d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002dc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002e0:	89 c3                	mov    %eax,%ebx
  8002e2:	89 d6                	mov    %edx,%esi
  8002e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f5:	89 04 24             	mov    %eax,(%esp)
  8002f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ff:	e8 2c 26 00 00       	call   802930 <__udivdi3>
  800304:	89 d9                	mov    %ebx,%ecx
  800306:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80030a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80030e:	89 04 24             	mov    %eax,(%esp)
  800311:	89 54 24 04          	mov    %edx,0x4(%esp)
  800315:	89 fa                	mov    %edi,%edx
  800317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031a:	e8 71 ff ff ff       	call   800290 <printnum>
  80031f:	eb 1b                	jmp    80033c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800321:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800325:	8b 45 18             	mov    0x18(%ebp),%eax
  800328:	89 04 24             	mov    %eax,(%esp)
  80032b:	ff d3                	call   *%ebx
  80032d:	eb 03                	jmp    800332 <printnum+0xa2>
  80032f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800332:	83 ee 01             	sub    $0x1,%esi
  800335:	85 f6                	test   %esi,%esi
  800337:	7f e8                	jg     800321 <printnum+0x91>
  800339:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80033c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800340:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800344:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800347:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80034a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80034e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800352:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800355:	89 04 24             	mov    %eax,(%esp)
  800358:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035f:	e8 fc 26 00 00       	call   802a60 <__umoddi3>
  800364:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800368:	0f be 80 47 2c 80 00 	movsbl 0x802c47(%eax),%eax
  80036f:	89 04 24             	mov    %eax,(%esp)
  800372:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800375:	ff d0                	call   *%eax
}
  800377:	83 c4 3c             	add    $0x3c,%esp
  80037a:	5b                   	pop    %ebx
  80037b:	5e                   	pop    %esi
  80037c:	5f                   	pop    %edi
  80037d:	5d                   	pop    %ebp
  80037e:	c3                   	ret    

0080037f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800382:	83 fa 01             	cmp    $0x1,%edx
  800385:	7e 0e                	jle    800395 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800387:	8b 10                	mov    (%eax),%edx
  800389:	8d 4a 08             	lea    0x8(%edx),%ecx
  80038c:	89 08                	mov    %ecx,(%eax)
  80038e:	8b 02                	mov    (%edx),%eax
  800390:	8b 52 04             	mov    0x4(%edx),%edx
  800393:	eb 22                	jmp    8003b7 <getuint+0x38>
	else if (lflag)
  800395:	85 d2                	test   %edx,%edx
  800397:	74 10                	je     8003a9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800399:	8b 10                	mov    (%eax),%edx
  80039b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80039e:	89 08                	mov    %ecx,(%eax)
  8003a0:	8b 02                	mov    (%edx),%eax
  8003a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a7:	eb 0e                	jmp    8003b7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003a9:	8b 10                	mov    (%eax),%edx
  8003ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ae:	89 08                	mov    %ecx,(%eax)
  8003b0:	8b 02                	mov    (%edx),%eax
  8003b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003b7:	5d                   	pop    %ebp
  8003b8:	c3                   	ret    

008003b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003b9:	55                   	push   %ebp
  8003ba:	89 e5                	mov    %esp,%ebp
  8003bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003bf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003c3:	8b 10                	mov    (%eax),%edx
  8003c5:	3b 50 04             	cmp    0x4(%eax),%edx
  8003c8:	73 0a                	jae    8003d4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003cd:	89 08                	mov    %ecx,(%eax)
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	88 02                	mov    %al,(%edx)
}
  8003d4:	5d                   	pop    %ebp
  8003d5:	c3                   	ret    

008003d6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
  8003d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003dc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	89 04 24             	mov    %eax,(%esp)
  8003f7:	e8 02 00 00 00       	call   8003fe <vprintfmt>
	va_end(ap);
}
  8003fc:	c9                   	leave  
  8003fd:	c3                   	ret    

008003fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	57                   	push   %edi
  800402:	56                   	push   %esi
  800403:	53                   	push   %ebx
  800404:	83 ec 3c             	sub    $0x3c,%esp
  800407:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80040a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80040d:	eb 14                	jmp    800423 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80040f:	85 c0                	test   %eax,%eax
  800411:	0f 84 b3 03 00 00    	je     8007ca <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800417:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80041b:	89 04 24             	mov    %eax,(%esp)
  80041e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800421:	89 f3                	mov    %esi,%ebx
  800423:	8d 73 01             	lea    0x1(%ebx),%esi
  800426:	0f b6 03             	movzbl (%ebx),%eax
  800429:	83 f8 25             	cmp    $0x25,%eax
  80042c:	75 e1                	jne    80040f <vprintfmt+0x11>
  80042e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800432:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800439:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800440:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800447:	ba 00 00 00 00       	mov    $0x0,%edx
  80044c:	eb 1d                	jmp    80046b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800450:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800454:	eb 15                	jmp    80046b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800456:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800458:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80045c:	eb 0d                	jmp    80046b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80045e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800461:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800464:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80046e:	0f b6 0e             	movzbl (%esi),%ecx
  800471:	0f b6 c1             	movzbl %cl,%eax
  800474:	83 e9 23             	sub    $0x23,%ecx
  800477:	80 f9 55             	cmp    $0x55,%cl
  80047a:	0f 87 2a 03 00 00    	ja     8007aa <vprintfmt+0x3ac>
  800480:	0f b6 c9             	movzbl %cl,%ecx
  800483:	ff 24 8d 80 2d 80 00 	jmp    *0x802d80(,%ecx,4)
  80048a:	89 de                	mov    %ebx,%esi
  80048c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800491:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800494:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800498:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80049b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80049e:	83 fb 09             	cmp    $0x9,%ebx
  8004a1:	77 36                	ja     8004d9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004a3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004a6:	eb e9                	jmp    800491 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	8d 48 04             	lea    0x4(%eax),%ecx
  8004ae:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004b8:	eb 22                	jmp    8004dc <vprintfmt+0xde>
  8004ba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004bd:	85 c9                	test   %ecx,%ecx
  8004bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c4:	0f 49 c1             	cmovns %ecx,%eax
  8004c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ca:	89 de                	mov    %ebx,%esi
  8004cc:	eb 9d                	jmp    80046b <vprintfmt+0x6d>
  8004ce:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004d0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8004d7:	eb 92                	jmp    80046b <vprintfmt+0x6d>
  8004d9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8004dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004e0:	79 89                	jns    80046b <vprintfmt+0x6d>
  8004e2:	e9 77 ff ff ff       	jmp    80045e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004e7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ea:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004ec:	e9 7a ff ff ff       	jmp    80046b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8d 50 04             	lea    0x4(%eax),%edx
  8004f7:	89 55 14             	mov    %edx,0x14(%ebp)
  8004fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	89 04 24             	mov    %eax,(%esp)
  800503:	ff 55 08             	call   *0x8(%ebp)
			break;
  800506:	e9 18 ff ff ff       	jmp    800423 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	8d 50 04             	lea    0x4(%eax),%edx
  800511:	89 55 14             	mov    %edx,0x14(%ebp)
  800514:	8b 00                	mov    (%eax),%eax
  800516:	99                   	cltd   
  800517:	31 d0                	xor    %edx,%eax
  800519:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051b:	83 f8 11             	cmp    $0x11,%eax
  80051e:	7f 0b                	jg     80052b <vprintfmt+0x12d>
  800520:	8b 14 85 e0 2e 80 00 	mov    0x802ee0(,%eax,4),%edx
  800527:	85 d2                	test   %edx,%edx
  800529:	75 20                	jne    80054b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80052b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80052f:	c7 44 24 08 5f 2c 80 	movl   $0x802c5f,0x8(%esp)
  800536:	00 
  800537:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	89 04 24             	mov    %eax,(%esp)
  800541:	e8 90 fe ff ff       	call   8003d6 <printfmt>
  800546:	e9 d8 fe ff ff       	jmp    800423 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80054b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80054f:	c7 44 24 08 0d 31 80 	movl   $0x80310d,0x8(%esp)
  800556:	00 
  800557:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	89 04 24             	mov    %eax,(%esp)
  800561:	e8 70 fe ff ff       	call   8003d6 <printfmt>
  800566:	e9 b8 fe ff ff       	jmp    800423 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80056e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800571:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8d 50 04             	lea    0x4(%eax),%edx
  80057a:	89 55 14             	mov    %edx,0x14(%ebp)
  80057d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80057f:	85 f6                	test   %esi,%esi
  800581:	b8 58 2c 80 00       	mov    $0x802c58,%eax
  800586:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800589:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80058d:	0f 84 97 00 00 00    	je     80062a <vprintfmt+0x22c>
  800593:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800597:	0f 8e 9b 00 00 00    	jle    800638 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80059d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005a1:	89 34 24             	mov    %esi,(%esp)
  8005a4:	e8 cf 02 00 00       	call   800878 <strnlen>
  8005a9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ac:	29 c2                	sub    %eax,%edx
  8005ae:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8005b1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005c1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c3:	eb 0f                	jmp    8005d4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8005c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005cc:	89 04 24             	mov    %eax,(%esp)
  8005cf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d1:	83 eb 01             	sub    $0x1,%ebx
  8005d4:	85 db                	test   %ebx,%ebx
  8005d6:	7f ed                	jg     8005c5 <vprintfmt+0x1c7>
  8005d8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005db:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005de:	85 d2                	test   %edx,%edx
  8005e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e5:	0f 49 c2             	cmovns %edx,%eax
  8005e8:	29 c2                	sub    %eax,%edx
  8005ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005ed:	89 d7                	mov    %edx,%edi
  8005ef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005f2:	eb 50                	jmp    800644 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f8:	74 1e                	je     800618 <vprintfmt+0x21a>
  8005fa:	0f be d2             	movsbl %dl,%edx
  8005fd:	83 ea 20             	sub    $0x20,%edx
  800600:	83 fa 5e             	cmp    $0x5e,%edx
  800603:	76 13                	jbe    800618 <vprintfmt+0x21a>
					putch('?', putdat);
  800605:	8b 45 0c             	mov    0xc(%ebp),%eax
  800608:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800613:	ff 55 08             	call   *0x8(%ebp)
  800616:	eb 0d                	jmp    800625 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800618:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80061f:	89 04 24             	mov    %eax,(%esp)
  800622:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800625:	83 ef 01             	sub    $0x1,%edi
  800628:	eb 1a                	jmp    800644 <vprintfmt+0x246>
  80062a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80062d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800630:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800633:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800636:	eb 0c                	jmp    800644 <vprintfmt+0x246>
  800638:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80063b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80063e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800641:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800644:	83 c6 01             	add    $0x1,%esi
  800647:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80064b:	0f be c2             	movsbl %dl,%eax
  80064e:	85 c0                	test   %eax,%eax
  800650:	74 27                	je     800679 <vprintfmt+0x27b>
  800652:	85 db                	test   %ebx,%ebx
  800654:	78 9e                	js     8005f4 <vprintfmt+0x1f6>
  800656:	83 eb 01             	sub    $0x1,%ebx
  800659:	79 99                	jns    8005f4 <vprintfmt+0x1f6>
  80065b:	89 f8                	mov    %edi,%eax
  80065d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800660:	8b 75 08             	mov    0x8(%ebp),%esi
  800663:	89 c3                	mov    %eax,%ebx
  800665:	eb 1a                	jmp    800681 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800667:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80066b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800672:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800674:	83 eb 01             	sub    $0x1,%ebx
  800677:	eb 08                	jmp    800681 <vprintfmt+0x283>
  800679:	89 fb                	mov    %edi,%ebx
  80067b:	8b 75 08             	mov    0x8(%ebp),%esi
  80067e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800681:	85 db                	test   %ebx,%ebx
  800683:	7f e2                	jg     800667 <vprintfmt+0x269>
  800685:	89 75 08             	mov    %esi,0x8(%ebp)
  800688:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80068b:	e9 93 fd ff ff       	jmp    800423 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800690:	83 fa 01             	cmp    $0x1,%edx
  800693:	7e 16                	jle    8006ab <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 50 08             	lea    0x8(%eax),%edx
  80069b:	89 55 14             	mov    %edx,0x14(%ebp)
  80069e:	8b 50 04             	mov    0x4(%eax),%edx
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006a9:	eb 32                	jmp    8006dd <vprintfmt+0x2df>
	else if (lflag)
  8006ab:	85 d2                	test   %edx,%edx
  8006ad:	74 18                	je     8006c7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8d 50 04             	lea    0x4(%eax),%edx
  8006b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b8:	8b 30                	mov    (%eax),%esi
  8006ba:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006bd:	89 f0                	mov    %esi,%eax
  8006bf:	c1 f8 1f             	sar    $0x1f,%eax
  8006c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006c5:	eb 16                	jmp    8006dd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8d 50 04             	lea    0x4(%eax),%edx
  8006cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d0:	8b 30                	mov    (%eax),%esi
  8006d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006d5:	89 f0                	mov    %esi,%eax
  8006d7:	c1 f8 1f             	sar    $0x1f,%eax
  8006da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ec:	0f 89 80 00 00 00    	jns    800772 <vprintfmt+0x374>
				putch('-', putdat);
  8006f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006fd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800703:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800706:	f7 d8                	neg    %eax
  800708:	83 d2 00             	adc    $0x0,%edx
  80070b:	f7 da                	neg    %edx
			}
			base = 10;
  80070d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800712:	eb 5e                	jmp    800772 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800714:	8d 45 14             	lea    0x14(%ebp),%eax
  800717:	e8 63 fc ff ff       	call   80037f <getuint>
			base = 10;
  80071c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800721:	eb 4f                	jmp    800772 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800723:	8d 45 14             	lea    0x14(%ebp),%eax
  800726:	e8 54 fc ff ff       	call   80037f <getuint>
			base = 8;
  80072b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800730:	eb 40                	jmp    800772 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800732:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800736:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80073d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800740:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800744:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80074b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8d 50 04             	lea    0x4(%eax),%edx
  800754:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800757:	8b 00                	mov    (%eax),%eax
  800759:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80075e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800763:	eb 0d                	jmp    800772 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800765:	8d 45 14             	lea    0x14(%ebp),%eax
  800768:	e8 12 fc ff ff       	call   80037f <getuint>
			base = 16;
  80076d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800772:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800776:	89 74 24 10          	mov    %esi,0x10(%esp)
  80077a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80077d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800781:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800785:	89 04 24             	mov    %eax,(%esp)
  800788:	89 54 24 04          	mov    %edx,0x4(%esp)
  80078c:	89 fa                	mov    %edi,%edx
  80078e:	8b 45 08             	mov    0x8(%ebp),%eax
  800791:	e8 fa fa ff ff       	call   800290 <printnum>
			break;
  800796:	e9 88 fc ff ff       	jmp    800423 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80079b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80079f:	89 04 24             	mov    %eax,(%esp)
  8007a2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007a5:	e9 79 fc ff ff       	jmp    800423 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ae:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007b5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007b8:	89 f3                	mov    %esi,%ebx
  8007ba:	eb 03                	jmp    8007bf <vprintfmt+0x3c1>
  8007bc:	83 eb 01             	sub    $0x1,%ebx
  8007bf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007c3:	75 f7                	jne    8007bc <vprintfmt+0x3be>
  8007c5:	e9 59 fc ff ff       	jmp    800423 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007ca:	83 c4 3c             	add    $0x3c,%esp
  8007cd:	5b                   	pop    %ebx
  8007ce:	5e                   	pop    %esi
  8007cf:	5f                   	pop    %edi
  8007d0:	5d                   	pop    %ebp
  8007d1:	c3                   	ret    

008007d2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	83 ec 28             	sub    $0x28,%esp
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007e1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007e5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ef:	85 c0                	test   %eax,%eax
  8007f1:	74 30                	je     800823 <vsnprintf+0x51>
  8007f3:	85 d2                	test   %edx,%edx
  8007f5:	7e 2c                	jle    800823 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800801:	89 44 24 08          	mov    %eax,0x8(%esp)
  800805:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800808:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080c:	c7 04 24 b9 03 80 00 	movl   $0x8003b9,(%esp)
  800813:	e8 e6 fb ff ff       	call   8003fe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800818:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80081e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800821:	eb 05                	jmp    800828 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800823:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800828:	c9                   	leave  
  800829:	c3                   	ret    

0080082a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800830:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800833:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800837:	8b 45 10             	mov    0x10(%ebp),%eax
  80083a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80083e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800841:	89 44 24 04          	mov    %eax,0x4(%esp)
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	89 04 24             	mov    %eax,(%esp)
  80084b:	e8 82 ff ff ff       	call   8007d2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800850:	c9                   	leave  
  800851:	c3                   	ret    
  800852:	66 90                	xchg   %ax,%ax
  800854:	66 90                	xchg   %ax,%ax
  800856:	66 90                	xchg   %ax,%ax
  800858:	66 90                	xchg   %ax,%ax
  80085a:	66 90                	xchg   %ax,%ax
  80085c:	66 90                	xchg   %ax,%ax
  80085e:	66 90                	xchg   %ax,%ax

00800860 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800866:	b8 00 00 00 00       	mov    $0x0,%eax
  80086b:	eb 03                	jmp    800870 <strlen+0x10>
		n++;
  80086d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800870:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800874:	75 f7                	jne    80086d <strlen+0xd>
		n++;
	return n;
}
  800876:	5d                   	pop    %ebp
  800877:	c3                   	ret    

00800878 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800881:	b8 00 00 00 00       	mov    $0x0,%eax
  800886:	eb 03                	jmp    80088b <strnlen+0x13>
		n++;
  800888:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80088b:	39 d0                	cmp    %edx,%eax
  80088d:	74 06                	je     800895 <strnlen+0x1d>
  80088f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800893:	75 f3                	jne    800888 <strnlen+0x10>
		n++;
	return n;
}
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	53                   	push   %ebx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008a1:	89 c2                	mov    %eax,%edx
  8008a3:	83 c2 01             	add    $0x1,%edx
  8008a6:	83 c1 01             	add    $0x1,%ecx
  8008a9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008ad:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008b0:	84 db                	test   %bl,%bl
  8008b2:	75 ef                	jne    8008a3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008b4:	5b                   	pop    %ebx
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	53                   	push   %ebx
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c1:	89 1c 24             	mov    %ebx,(%esp)
  8008c4:	e8 97 ff ff ff       	call   800860 <strlen>
	strcpy(dst + len, src);
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008d0:	01 d8                	add    %ebx,%eax
  8008d2:	89 04 24             	mov    %eax,(%esp)
  8008d5:	e8 bd ff ff ff       	call   800897 <strcpy>
	return dst;
}
  8008da:	89 d8                	mov    %ebx,%eax
  8008dc:	83 c4 08             	add    $0x8,%esp
  8008df:	5b                   	pop    %ebx
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	56                   	push   %esi
  8008e6:	53                   	push   %ebx
  8008e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ed:	89 f3                	mov    %esi,%ebx
  8008ef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f2:	89 f2                	mov    %esi,%edx
  8008f4:	eb 0f                	jmp    800905 <strncpy+0x23>
		*dst++ = *src;
  8008f6:	83 c2 01             	add    $0x1,%edx
  8008f9:	0f b6 01             	movzbl (%ecx),%eax
  8008fc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ff:	80 39 01             	cmpb   $0x1,(%ecx)
  800902:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800905:	39 da                	cmp    %ebx,%edx
  800907:	75 ed                	jne    8008f6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800909:	89 f0                	mov    %esi,%eax
  80090b:	5b                   	pop    %ebx
  80090c:	5e                   	pop    %esi
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	56                   	push   %esi
  800913:	53                   	push   %ebx
  800914:	8b 75 08             	mov    0x8(%ebp),%esi
  800917:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80091d:	89 f0                	mov    %esi,%eax
  80091f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800923:	85 c9                	test   %ecx,%ecx
  800925:	75 0b                	jne    800932 <strlcpy+0x23>
  800927:	eb 1d                	jmp    800946 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800929:	83 c0 01             	add    $0x1,%eax
  80092c:	83 c2 01             	add    $0x1,%edx
  80092f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800932:	39 d8                	cmp    %ebx,%eax
  800934:	74 0b                	je     800941 <strlcpy+0x32>
  800936:	0f b6 0a             	movzbl (%edx),%ecx
  800939:	84 c9                	test   %cl,%cl
  80093b:	75 ec                	jne    800929 <strlcpy+0x1a>
  80093d:	89 c2                	mov    %eax,%edx
  80093f:	eb 02                	jmp    800943 <strlcpy+0x34>
  800941:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800943:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800946:	29 f0                	sub    %esi,%eax
}
  800948:	5b                   	pop    %ebx
  800949:	5e                   	pop    %esi
  80094a:	5d                   	pop    %ebp
  80094b:	c3                   	ret    

0080094c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800952:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800955:	eb 06                	jmp    80095d <strcmp+0x11>
		p++, q++;
  800957:	83 c1 01             	add    $0x1,%ecx
  80095a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80095d:	0f b6 01             	movzbl (%ecx),%eax
  800960:	84 c0                	test   %al,%al
  800962:	74 04                	je     800968 <strcmp+0x1c>
  800964:	3a 02                	cmp    (%edx),%al
  800966:	74 ef                	je     800957 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800968:	0f b6 c0             	movzbl %al,%eax
  80096b:	0f b6 12             	movzbl (%edx),%edx
  80096e:	29 d0                	sub    %edx,%eax
}
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	53                   	push   %ebx
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097c:	89 c3                	mov    %eax,%ebx
  80097e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800981:	eb 06                	jmp    800989 <strncmp+0x17>
		n--, p++, q++;
  800983:	83 c0 01             	add    $0x1,%eax
  800986:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800989:	39 d8                	cmp    %ebx,%eax
  80098b:	74 15                	je     8009a2 <strncmp+0x30>
  80098d:	0f b6 08             	movzbl (%eax),%ecx
  800990:	84 c9                	test   %cl,%cl
  800992:	74 04                	je     800998 <strncmp+0x26>
  800994:	3a 0a                	cmp    (%edx),%cl
  800996:	74 eb                	je     800983 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800998:	0f b6 00             	movzbl (%eax),%eax
  80099b:	0f b6 12             	movzbl (%edx),%edx
  80099e:	29 d0                	sub    %edx,%eax
  8009a0:	eb 05                	jmp    8009a7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009a2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009a7:	5b                   	pop    %ebx
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b4:	eb 07                	jmp    8009bd <strchr+0x13>
		if (*s == c)
  8009b6:	38 ca                	cmp    %cl,%dl
  8009b8:	74 0f                	je     8009c9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009ba:	83 c0 01             	add    $0x1,%eax
  8009bd:	0f b6 10             	movzbl (%eax),%edx
  8009c0:	84 d2                	test   %dl,%dl
  8009c2:	75 f2                	jne    8009b6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009d5:	eb 07                	jmp    8009de <strfind+0x13>
		if (*s == c)
  8009d7:	38 ca                	cmp    %cl,%dl
  8009d9:	74 0a                	je     8009e5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009db:	83 c0 01             	add    $0x1,%eax
  8009de:	0f b6 10             	movzbl (%eax),%edx
  8009e1:	84 d2                	test   %dl,%dl
  8009e3:	75 f2                	jne    8009d7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    

008009e7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	57                   	push   %edi
  8009eb:	56                   	push   %esi
  8009ec:	53                   	push   %ebx
  8009ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009f3:	85 c9                	test   %ecx,%ecx
  8009f5:	74 36                	je     800a2d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009f7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009fd:	75 28                	jne    800a27 <memset+0x40>
  8009ff:	f6 c1 03             	test   $0x3,%cl
  800a02:	75 23                	jne    800a27 <memset+0x40>
		c &= 0xFF;
  800a04:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a08:	89 d3                	mov    %edx,%ebx
  800a0a:	c1 e3 08             	shl    $0x8,%ebx
  800a0d:	89 d6                	mov    %edx,%esi
  800a0f:	c1 e6 18             	shl    $0x18,%esi
  800a12:	89 d0                	mov    %edx,%eax
  800a14:	c1 e0 10             	shl    $0x10,%eax
  800a17:	09 f0                	or     %esi,%eax
  800a19:	09 c2                	or     %eax,%edx
  800a1b:	89 d0                	mov    %edx,%eax
  800a1d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a1f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a22:	fc                   	cld    
  800a23:	f3 ab                	rep stos %eax,%es:(%edi)
  800a25:	eb 06                	jmp    800a2d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	fc                   	cld    
  800a2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a2d:	89 f8                	mov    %edi,%eax
  800a2f:	5b                   	pop    %ebx
  800a30:	5e                   	pop    %esi
  800a31:	5f                   	pop    %edi
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	57                   	push   %edi
  800a38:	56                   	push   %esi
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a42:	39 c6                	cmp    %eax,%esi
  800a44:	73 35                	jae    800a7b <memmove+0x47>
  800a46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a49:	39 d0                	cmp    %edx,%eax
  800a4b:	73 2e                	jae    800a7b <memmove+0x47>
		s += n;
		d += n;
  800a4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a50:	89 d6                	mov    %edx,%esi
  800a52:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a54:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a5a:	75 13                	jne    800a6f <memmove+0x3b>
  800a5c:	f6 c1 03             	test   $0x3,%cl
  800a5f:	75 0e                	jne    800a6f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a61:	83 ef 04             	sub    $0x4,%edi
  800a64:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a67:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a6a:	fd                   	std    
  800a6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a6d:	eb 09                	jmp    800a78 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a6f:	83 ef 01             	sub    $0x1,%edi
  800a72:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a75:	fd                   	std    
  800a76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a78:	fc                   	cld    
  800a79:	eb 1d                	jmp    800a98 <memmove+0x64>
  800a7b:	89 f2                	mov    %esi,%edx
  800a7d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7f:	f6 c2 03             	test   $0x3,%dl
  800a82:	75 0f                	jne    800a93 <memmove+0x5f>
  800a84:	f6 c1 03             	test   $0x3,%cl
  800a87:	75 0a                	jne    800a93 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a89:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a8c:	89 c7                	mov    %eax,%edi
  800a8e:	fc                   	cld    
  800a8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a91:	eb 05                	jmp    800a98 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a93:	89 c7                	mov    %eax,%edi
  800a95:	fc                   	cld    
  800a96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a98:	5e                   	pop    %esi
  800a99:	5f                   	pop    %edi
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aa2:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	89 04 24             	mov    %eax,(%esp)
  800ab6:	e8 79 ff ff ff       	call   800a34 <memmove>
}
  800abb:	c9                   	leave  
  800abc:	c3                   	ret    

00800abd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	56                   	push   %esi
  800ac1:	53                   	push   %ebx
  800ac2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac8:	89 d6                	mov    %edx,%esi
  800aca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800acd:	eb 1a                	jmp    800ae9 <memcmp+0x2c>
		if (*s1 != *s2)
  800acf:	0f b6 02             	movzbl (%edx),%eax
  800ad2:	0f b6 19             	movzbl (%ecx),%ebx
  800ad5:	38 d8                	cmp    %bl,%al
  800ad7:	74 0a                	je     800ae3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ad9:	0f b6 c0             	movzbl %al,%eax
  800adc:	0f b6 db             	movzbl %bl,%ebx
  800adf:	29 d8                	sub    %ebx,%eax
  800ae1:	eb 0f                	jmp    800af2 <memcmp+0x35>
		s1++, s2++;
  800ae3:	83 c2 01             	add    $0x1,%edx
  800ae6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ae9:	39 f2                	cmp    %esi,%edx
  800aeb:	75 e2                	jne    800acf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800aed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af2:	5b                   	pop    %ebx
  800af3:	5e                   	pop    %esi
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aff:	89 c2                	mov    %eax,%edx
  800b01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b04:	eb 07                	jmp    800b0d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b06:	38 08                	cmp    %cl,(%eax)
  800b08:	74 07                	je     800b11 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b0a:	83 c0 01             	add    $0x1,%eax
  800b0d:	39 d0                	cmp    %edx,%eax
  800b0f:	72 f5                	jb     800b06 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	57                   	push   %edi
  800b17:	56                   	push   %esi
  800b18:	53                   	push   %ebx
  800b19:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b1f:	eb 03                	jmp    800b24 <strtol+0x11>
		s++;
  800b21:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b24:	0f b6 0a             	movzbl (%edx),%ecx
  800b27:	80 f9 09             	cmp    $0x9,%cl
  800b2a:	74 f5                	je     800b21 <strtol+0xe>
  800b2c:	80 f9 20             	cmp    $0x20,%cl
  800b2f:	74 f0                	je     800b21 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b31:	80 f9 2b             	cmp    $0x2b,%cl
  800b34:	75 0a                	jne    800b40 <strtol+0x2d>
		s++;
  800b36:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b39:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3e:	eb 11                	jmp    800b51 <strtol+0x3e>
  800b40:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b45:	80 f9 2d             	cmp    $0x2d,%cl
  800b48:	75 07                	jne    800b51 <strtol+0x3e>
		s++, neg = 1;
  800b4a:	8d 52 01             	lea    0x1(%edx),%edx
  800b4d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b51:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b56:	75 15                	jne    800b6d <strtol+0x5a>
  800b58:	80 3a 30             	cmpb   $0x30,(%edx)
  800b5b:	75 10                	jne    800b6d <strtol+0x5a>
  800b5d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b61:	75 0a                	jne    800b6d <strtol+0x5a>
		s += 2, base = 16;
  800b63:	83 c2 02             	add    $0x2,%edx
  800b66:	b8 10 00 00 00       	mov    $0x10,%eax
  800b6b:	eb 10                	jmp    800b7d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b6d:	85 c0                	test   %eax,%eax
  800b6f:	75 0c                	jne    800b7d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b71:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b73:	80 3a 30             	cmpb   $0x30,(%edx)
  800b76:	75 05                	jne    800b7d <strtol+0x6a>
		s++, base = 8;
  800b78:	83 c2 01             	add    $0x1,%edx
  800b7b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b82:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b85:	0f b6 0a             	movzbl (%edx),%ecx
  800b88:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b8b:	89 f0                	mov    %esi,%eax
  800b8d:	3c 09                	cmp    $0x9,%al
  800b8f:	77 08                	ja     800b99 <strtol+0x86>
			dig = *s - '0';
  800b91:	0f be c9             	movsbl %cl,%ecx
  800b94:	83 e9 30             	sub    $0x30,%ecx
  800b97:	eb 20                	jmp    800bb9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b99:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b9c:	89 f0                	mov    %esi,%eax
  800b9e:	3c 19                	cmp    $0x19,%al
  800ba0:	77 08                	ja     800baa <strtol+0x97>
			dig = *s - 'a' + 10;
  800ba2:	0f be c9             	movsbl %cl,%ecx
  800ba5:	83 e9 57             	sub    $0x57,%ecx
  800ba8:	eb 0f                	jmp    800bb9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800baa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bad:	89 f0                	mov    %esi,%eax
  800baf:	3c 19                	cmp    $0x19,%al
  800bb1:	77 16                	ja     800bc9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800bb3:	0f be c9             	movsbl %cl,%ecx
  800bb6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bb9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bbc:	7d 0f                	jge    800bcd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bbe:	83 c2 01             	add    $0x1,%edx
  800bc1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800bc5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800bc7:	eb bc                	jmp    800b85 <strtol+0x72>
  800bc9:	89 d8                	mov    %ebx,%eax
  800bcb:	eb 02                	jmp    800bcf <strtol+0xbc>
  800bcd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800bcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd3:	74 05                	je     800bda <strtol+0xc7>
		*endptr = (char *) s;
  800bd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bda:	f7 d8                	neg    %eax
  800bdc:	85 ff                	test   %edi,%edi
  800bde:	0f 44 c3             	cmove  %ebx,%eax
}
  800be1:	5b                   	pop    %ebx
  800be2:	5e                   	pop    %esi
  800be3:	5f                   	pop    %edi
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    

00800be6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	57                   	push   %edi
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bec:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf7:	89 c3                	mov    %eax,%ebx
  800bf9:	89 c7                	mov    %eax,%edi
  800bfb:	89 c6                	mov    %eax,%esi
  800bfd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bff:	5b                   	pop    %ebx
  800c00:	5e                   	pop    %esi
  800c01:	5f                   	pop    %edi
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	57                   	push   %edi
  800c08:	56                   	push   %esi
  800c09:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c14:	89 d1                	mov    %edx,%ecx
  800c16:	89 d3                	mov    %edx,%ebx
  800c18:	89 d7                	mov    %edx,%edi
  800c1a:	89 d6                	mov    %edx,%esi
  800c1c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c1e:	5b                   	pop    %ebx
  800c1f:	5e                   	pop    %esi
  800c20:	5f                   	pop    %edi
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	57                   	push   %edi
  800c27:	56                   	push   %esi
  800c28:	53                   	push   %ebx
  800c29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c31:	b8 03 00 00 00       	mov    $0x3,%eax
  800c36:	8b 55 08             	mov    0x8(%ebp),%edx
  800c39:	89 cb                	mov    %ecx,%ebx
  800c3b:	89 cf                	mov    %ecx,%edi
  800c3d:	89 ce                	mov    %ecx,%esi
  800c3f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c41:	85 c0                	test   %eax,%eax
  800c43:	7e 28                	jle    800c6d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c45:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c49:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c50:	00 
  800c51:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  800c58:	00 
  800c59:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c60:	00 
  800c61:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  800c68:	e8 05 f5 ff ff       	call   800172 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c6d:	83 c4 2c             	add    $0x2c,%esp
  800c70:	5b                   	pop    %ebx
  800c71:	5e                   	pop    %esi
  800c72:	5f                   	pop    %edi
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	57                   	push   %edi
  800c79:	56                   	push   %esi
  800c7a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c80:	b8 02 00 00 00       	mov    $0x2,%eax
  800c85:	89 d1                	mov    %edx,%ecx
  800c87:	89 d3                	mov    %edx,%ebx
  800c89:	89 d7                	mov    %edx,%edi
  800c8b:	89 d6                	mov    %edx,%esi
  800c8d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    

00800c94 <sys_yield>:

void
sys_yield(void)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	57                   	push   %edi
  800c98:	56                   	push   %esi
  800c99:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ca4:	89 d1                	mov    %edx,%ecx
  800ca6:	89 d3                	mov    %edx,%ebx
  800ca8:	89 d7                	mov    %edx,%edi
  800caa:	89 d6                	mov    %edx,%esi
  800cac:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cae:	5b                   	pop    %ebx
  800caf:	5e                   	pop    %esi
  800cb0:	5f                   	pop    %edi
  800cb1:	5d                   	pop    %ebp
  800cb2:	c3                   	ret    

00800cb3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	57                   	push   %edi
  800cb7:	56                   	push   %esi
  800cb8:	53                   	push   %ebx
  800cb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cbc:	be 00 00 00 00       	mov    $0x0,%esi
  800cc1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ccf:	89 f7                	mov    %esi,%edi
  800cd1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	7e 28                	jle    800cff <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cdb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ce2:	00 
  800ce3:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  800cea:	00 
  800ceb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cf2:	00 
  800cf3:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  800cfa:	e8 73 f4 ff ff       	call   800172 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cff:	83 c4 2c             	add    $0x2c,%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	57                   	push   %edi
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
  800d0d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d10:	b8 05 00 00 00       	mov    $0x5,%eax
  800d15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d18:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d21:	8b 75 18             	mov    0x18(%ebp),%esi
  800d24:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d26:	85 c0                	test   %eax,%eax
  800d28:	7e 28                	jle    800d52 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d2e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d35:	00 
  800d36:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  800d3d:	00 
  800d3e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d45:	00 
  800d46:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  800d4d:	e8 20 f4 ff ff       	call   800172 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d52:	83 c4 2c             	add    $0x2c,%esp
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	57                   	push   %edi
  800d5e:	56                   	push   %esi
  800d5f:	53                   	push   %ebx
  800d60:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d63:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d68:	b8 06 00 00 00       	mov    $0x6,%eax
  800d6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d70:	8b 55 08             	mov    0x8(%ebp),%edx
  800d73:	89 df                	mov    %ebx,%edi
  800d75:	89 de                	mov    %ebx,%esi
  800d77:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d79:	85 c0                	test   %eax,%eax
  800d7b:	7e 28                	jle    800da5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d81:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d88:	00 
  800d89:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  800d90:	00 
  800d91:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d98:	00 
  800d99:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  800da0:	e8 cd f3 ff ff       	call   800172 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800da5:	83 c4 2c             	add    $0x2c,%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	57                   	push   %edi
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
  800db3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbb:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	89 df                	mov    %ebx,%edi
  800dc8:	89 de                	mov    %ebx,%esi
  800dca:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	7e 28                	jle    800df8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dd4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ddb:	00 
  800ddc:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  800de3:	00 
  800de4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800deb:	00 
  800dec:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  800df3:	e8 7a f3 ff ff       	call   800172 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800df8:	83 c4 2c             	add    $0x2c,%esp
  800dfb:	5b                   	pop    %ebx
  800dfc:	5e                   	pop    %esi
  800dfd:	5f                   	pop    %edi
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	57                   	push   %edi
  800e04:	56                   	push   %esi
  800e05:	53                   	push   %ebx
  800e06:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e16:	8b 55 08             	mov    0x8(%ebp),%edx
  800e19:	89 df                	mov    %ebx,%edi
  800e1b:	89 de                	mov    %ebx,%esi
  800e1d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e1f:	85 c0                	test   %eax,%eax
  800e21:	7e 28                	jle    800e4b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e23:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e27:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e2e:	00 
  800e2f:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  800e36:	00 
  800e37:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e3e:	00 
  800e3f:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  800e46:	e8 27 f3 ff ff       	call   800172 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e4b:	83 c4 2c             	add    $0x2c,%esp
  800e4e:	5b                   	pop    %ebx
  800e4f:	5e                   	pop    %esi
  800e50:	5f                   	pop    %edi
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    

00800e53 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	57                   	push   %edi
  800e57:	56                   	push   %esi
  800e58:	53                   	push   %ebx
  800e59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e69:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6c:	89 df                	mov    %ebx,%edi
  800e6e:	89 de                	mov    %ebx,%esi
  800e70:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e72:	85 c0                	test   %eax,%eax
  800e74:	7e 28                	jle    800e9e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e76:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e7a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e81:	00 
  800e82:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  800e89:	00 
  800e8a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e91:	00 
  800e92:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  800e99:	e8 d4 f2 ff ff       	call   800172 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e9e:	83 c4 2c             	add    $0x2c,%esp
  800ea1:	5b                   	pop    %ebx
  800ea2:	5e                   	pop    %esi
  800ea3:	5f                   	pop    %edi
  800ea4:	5d                   	pop    %ebp
  800ea5:	c3                   	ret    

00800ea6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	57                   	push   %edi
  800eaa:	56                   	push   %esi
  800eab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eac:	be 00 00 00 00       	mov    $0x0,%esi
  800eb1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800edc:	8b 55 08             	mov    0x8(%ebp),%edx
  800edf:	89 cb                	mov    %ecx,%ebx
  800ee1:	89 cf                	mov    %ecx,%edi
  800ee3:	89 ce                	mov    %ecx,%esi
  800ee5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	7e 28                	jle    800f13 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eeb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eef:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ef6:	00 
  800ef7:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  800efe:	00 
  800eff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f06:	00 
  800f07:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  800f0e:	e8 5f f2 ff ff       	call   800172 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f13:	83 c4 2c             	add    $0x2c,%esp
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <sys_time_msec>:

unsigned int
sys_time_msec(void)
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
  800f21:	ba 00 00 00 00       	mov    $0x0,%edx
  800f26:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f2b:	89 d1                	mov    %edx,%ecx
  800f2d:	89 d3                	mov    %edx,%ebx
  800f2f:	89 d7                	mov    %edx,%edi
  800f31:	89 d6                	mov    %edx,%esi
  800f33:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    

00800f3a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	57                   	push   %edi
  800f3e:	56                   	push   %esi
  800f3f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f45:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	89 df                	mov    %ebx,%edi
  800f52:	89 de                	mov    %ebx,%esi
  800f54:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
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
  800f61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f66:	b8 10 00 00 00       	mov    $0x10,%eax
  800f6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f71:	89 df                	mov    %ebx,%edi
  800f73:	89 de                	mov    %ebx,%esi
  800f75:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f82:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f87:	b8 11 00 00 00       	mov    $0x11,%eax
  800f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8f:	89 cb                	mov    %ecx,%ebx
  800f91:	89 cf                	mov    %ecx,%edi
  800f93:	89 ce                	mov    %ecx,%esi
  800f95:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800f97:	5b                   	pop    %ebx
  800f98:	5e                   	pop    %esi
  800f99:	5f                   	pop    %edi
  800f9a:	5d                   	pop    %ebp
  800f9b:	c3                   	ret    

00800f9c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	57                   	push   %edi
  800fa0:	56                   	push   %esi
  800fa1:	53                   	push   %ebx
  800fa2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa5:	be 00 00 00 00       	mov    $0x0,%esi
  800faa:	b8 12 00 00 00       	mov    $0x12,%eax
  800faf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fb8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fbb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	7e 28                	jle    800fe9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800fcc:	00 
  800fcd:	c7 44 24 08 47 2f 80 	movl   $0x802f47,0x8(%esp)
  800fd4:	00 
  800fd5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fdc:	00 
  800fdd:	c7 04 24 64 2f 80 00 	movl   $0x802f64,(%esp)
  800fe4:	e8 89 f1 ff ff       	call   800172 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  800fe9:	83 c4 2c             	add    $0x2c,%esp
  800fec:	5b                   	pop    %ebx
  800fed:	5e                   	pop    %esi
  800fee:	5f                   	pop    %edi
  800fef:	5d                   	pop    %ebp
  800ff0:	c3                   	ret    

00800ff1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	53                   	push   %ebx
  800ff5:	83 ec 24             	sub    $0x24,%esp
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800ffb:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0)
  800ffd:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801001:	75 20                	jne    801023 <pgfault+0x32>
		panic("pgfault: faulting address [%08x] not a write\n", addr);
  801003:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801007:	c7 44 24 08 74 2f 80 	movl   $0x802f74,0x8(%esp)
  80100e:	00 
  80100f:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  801016:	00 
  801017:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  80101e:	e8 4f f1 ff ff       	call   800172 <_panic>

	void *page_aligned_addr = (void *) ROUNDDOWN(addr, PGSIZE);
  801023:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t page_num = (uint32_t) page_aligned_addr / PGSIZE;
  801029:	89 d8                	mov    %ebx,%eax
  80102b:	c1 e8 0c             	shr    $0xc,%eax
	if (!(uvpt[page_num] & PTE_COW))
  80102e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801035:	f6 c4 08             	test   $0x8,%ah
  801038:	75 1c                	jne    801056 <pgfault+0x65>
		panic("pgfault: fault was not on a copy-on-write page\n");
  80103a:	c7 44 24 08 a4 2f 80 	movl   $0x802fa4,0x8(%esp)
  801041:	00 
  801042:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801049:	00 
  80104a:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  801051:	e8 1c f1 ff ff       	call   800172 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	// Allocate
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801056:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80105d:	00 
  80105e:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801065:	00 
  801066:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80106d:	e8 41 fc ff ff       	call   800cb3 <sys_page_alloc>
  801072:	85 c0                	test   %eax,%eax
  801074:	79 20                	jns    801096 <pgfault+0xa5>
		panic("sys_page_alloc: %e\n", r);
  801076:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80107a:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  801081:	00 
  801082:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  801089:	00 
  80108a:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  801091:	e8 dc f0 ff ff       	call   800172 <_panic>

	// Copy over
	void *src_addr = (void *) ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, src_addr, PGSIZE);
  801096:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80109d:	00 
  80109e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010a2:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8010a9:	e8 86 f9 ff ff       	call   800a34 <memmove>

	// Remap
	if ((r = sys_page_map(0, PFTEMP, 0, src_addr, PTE_P | PTE_U | PTE_W)) < 0)
  8010ae:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8010b5:	00 
  8010b6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010c1:	00 
  8010c2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010c9:	00 
  8010ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010d1:	e8 31 fc ff ff       	call   800d07 <sys_page_map>
  8010d6:	85 c0                	test   %eax,%eax
  8010d8:	79 20                	jns    8010fa <pgfault+0x109>
		panic("sys_page_map: %e\n", r);
  8010da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010de:	c7 44 24 08 13 30 80 	movl   $0x803013,0x8(%esp)
  8010e5:	00 
  8010e6:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  8010ed:	00 
  8010ee:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  8010f5:	e8 78 f0 ff ff       	call   800172 <_panic>

	//panic("pgfault not implemented");
}
  8010fa:	83 c4 24             	add    $0x24,%esp
  8010fd:	5b                   	pop    %ebx
  8010fe:	5d                   	pop    %ebp
  8010ff:	c3                   	ret    

00801100 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801100:	55                   	push   %ebp
  801101:	89 e5                	mov    %esp,%ebp
  801103:	57                   	push   %edi
  801104:	56                   	push   %esi
  801105:	53                   	push   %ebx
  801106:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	int r;
	envid_t child_envid;

	set_pgfault_handler(pgfault);
  801109:	c7 04 24 f1 0f 80 00 	movl   $0x800ff1,(%esp)
  801110:	e8 01 16 00 00       	call   802716 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801115:	b8 07 00 00 00       	mov    $0x7,%eax
  80111a:	cd 30                	int    $0x30
  80111c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80111f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	child_envid = sys_exofork();
	if (child_envid < 0)
  801122:	85 c0                	test   %eax,%eax
  801124:	79 20                	jns    801146 <fork+0x46>
		panic("sys_exofork: %e\n", child_envid);
  801126:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80112a:	c7 44 24 08 25 30 80 	movl   $0x803025,0x8(%esp)
  801131:	00 
  801132:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  801139:	00 
  80113a:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  801141:	e8 2c f0 ff ff       	call   800172 <_panic>
	if (child_envid == 0) { // child
  801146:	bf 00 00 00 00       	mov    $0x0,%edi
  80114b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801150:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801154:	75 21                	jne    801177 <fork+0x77>
		// Fix thisenv like dumbfork does and return 0
		thisenv = &envs[ENVX(sys_getenvid())];
  801156:	e8 1a fb ff ff       	call   800c75 <sys_getenvid>
  80115b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801160:	c1 e0 07             	shl    $0x7,%eax
  801163:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801168:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  80116d:	b8 00 00 00 00       	mov    $0x0,%eax
  801172:	e9 53 02 00 00       	jmp    8013ca <fork+0x2ca>
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
  801177:	89 d8                	mov    %ebx,%eax
  801179:	c1 e8 0a             	shr    $0xa,%eax
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  80117c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801183:	a8 01                	test   $0x1,%al
  801185:	0f 84 7a 01 00 00    	je     801305 <fork+0x205>
			((uvpt[page_num] & PTE_P) == PTE_P)) {
  80118b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  801192:	a8 01                	test   $0x1,%al
  801194:	0f 84 6b 01 00 00    	je     801305 <fork+0x205>
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
	envid_t this_envid = thisenv->env_id;
  80119a:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80119f:	8b 40 48             	mov    0x48(%eax),%eax
  8011a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 4: Your code here.
	if (uvpt[pn] & PTE_SHARE) {
  8011a5:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011ac:	f6 c4 04             	test   $0x4,%ah
  8011af:	74 52                	je     801203 <fork+0x103>
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  8011b1:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8011b8:	25 07 0e 00 00       	and    $0xe07,%eax
  8011bd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011d3:	89 04 24             	mov    %eax,(%esp)
  8011d6:	e8 2c fb ff ff       	call   800d07 <sys_page_map>
  8011db:	85 c0                	test   %eax,%eax
  8011dd:	0f 89 22 01 00 00    	jns    801305 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  8011e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011e7:	c7 44 24 08 13 30 80 	movl   $0x803013,0x8(%esp)
  8011ee:	00 
  8011ef:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  8011f6:	00 
  8011f7:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  8011fe:	e8 6f ef ff ff       	call   800172 <_panic>
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
  801203:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80120a:	f6 c4 08             	test   $0x8,%ah
  80120d:	75 0f                	jne    80121e <fork+0x11e>
  80120f:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801216:	a8 02                	test   $0x2,%al
  801218:	0f 84 99 00 00 00    	je     8012b7 <fork+0x1b7>
		if (uvpt[pn] & PTE_U)
  80121e:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801225:	83 e0 04             	and    $0x4,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
  801228:	83 f8 01             	cmp    $0x1,%eax
  80122b:	19 f6                	sbb    %esi,%esi
  80122d:	83 e6 fc             	and    $0xfffffffc,%esi
  801230:	81 c6 05 08 00 00    	add    $0x805,%esi
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
		if (uvpt[pn] & PTE_U)
			perm |= PTE_U;

		// Map page COW, U and P in child
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), perm)) < 0)
  801236:	89 74 24 10          	mov    %esi,0x10(%esp)
  80123a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80123e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801241:	89 44 24 08          	mov    %eax,0x8(%esp)
  801245:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801249:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80124c:	89 04 24             	mov    %eax,(%esp)
  80124f:	e8 b3 fa ff ff       	call   800d07 <sys_page_map>
  801254:	85 c0                	test   %eax,%eax
  801256:	79 20                	jns    801278 <fork+0x178>
			panic("sys_page_map: %e\n", r);
  801258:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80125c:	c7 44 24 08 13 30 80 	movl   $0x803013,0x8(%esp)
  801263:	00 
  801264:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80126b:	00 
  80126c:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  801273:	e8 fa ee ff ff       	call   800172 <_panic>

		// Map page COW, U and P in parent
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), this_envid, (void *) (pn*PGSIZE), perm)) < 0)
  801278:	89 74 24 10          	mov    %esi,0x10(%esp)
  80127c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801280:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801283:	89 44 24 08          	mov    %eax,0x8(%esp)
  801287:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80128b:	89 04 24             	mov    %eax,(%esp)
  80128e:	e8 74 fa ff ff       	call   800d07 <sys_page_map>
  801293:	85 c0                	test   %eax,%eax
  801295:	79 6e                	jns    801305 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801297:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80129b:	c7 44 24 08 13 30 80 	movl   $0x803013,0x8(%esp)
  8012a2:	00 
  8012a3:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8012aa:	00 
  8012ab:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  8012b2:	e8 bb ee ff ff       	call   800172 <_panic>

	} else { // map pages that are present but not writable or COW with their original permissions
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  8012b7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8012be:	25 07 0e 00 00       	and    $0xe07,%eax
  8012c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012c7:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012d9:	89 04 24             	mov    %eax,(%esp)
  8012dc:	e8 26 fa ff ff       	call   800d07 <sys_page_map>
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	79 20                	jns    801305 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  8012e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012e9:	c7 44 24 08 13 30 80 	movl   $0x803013,0x8(%esp)
  8012f0:	00 
  8012f1:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  8012f8:	00 
  8012f9:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  801300:	e8 6d ee ff ff       	call   800172 <_panic>
	// and let duppage worry about the permissions.
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
  801305:	83 c3 01             	add    $0x1,%ebx
  801308:	81 c7 00 10 00 00    	add    $0x1000,%edi
  80130e:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801314:	0f 85 5d fe ff ff    	jne    801177 <fork+0x77>
	}

	// Allocate exception stack space for child. The child can't do this themselves
	// because the mechanism by which it would is to run the pgfault handler, which
	// needs to run on the exception stack (catch 22).
	if ((r = sys_page_alloc(child_envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80131a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801321:	00 
  801322:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801329:	ee 
  80132a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80132d:	89 04 24             	mov    %eax,(%esp)
  801330:	e8 7e f9 ff ff       	call   800cb3 <sys_page_alloc>
  801335:	85 c0                	test   %eax,%eax
  801337:	79 20                	jns    801359 <fork+0x259>
		panic("sys_page_alloc: %e\n", r);
  801339:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80133d:	c7 44 24 08 ff 2f 80 	movl   $0x802fff,0x8(%esp)
  801344:	00 
  801345:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  80134c:	00 
  80134d:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  801354:	e8 19 ee ff ff       	call   800172 <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801359:	c7 44 24 04 97 27 80 	movl   $0x802797,0x4(%esp)
  801360:	00 
  801361:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801364:	89 04 24             	mov    %eax,(%esp)
  801367:	e8 e7 fa ff ff       	call   800e53 <sys_env_set_pgfault_upcall>
  80136c:	85 c0                	test   %eax,%eax
  80136e:	79 20                	jns    801390 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801370:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801374:	c7 44 24 08 d4 2f 80 	movl   $0x802fd4,0x8(%esp)
  80137b:	00 
  80137c:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801383:	00 
  801384:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  80138b:	e8 e2 ed ff ff       	call   800172 <_panic>

	// Mark child environment as runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801390:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801397:	00 
  801398:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80139b:	89 04 24             	mov    %eax,(%esp)
  80139e:	e8 0a fa ff ff       	call   800dad <sys_env_set_status>
  8013a3:	85 c0                	test   %eax,%eax
  8013a5:	79 20                	jns    8013c7 <fork+0x2c7>
		panic("sys_env_set_status: %e\n", r);
  8013a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ab:	c7 44 24 08 36 30 80 	movl   $0x803036,0x8(%esp)
  8013b2:	00 
  8013b3:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8013ba:	00 
  8013bb:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  8013c2:	e8 ab ed ff ff       	call   800172 <_panic>

	return child_envid;
  8013c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8013ca:	83 c4 2c             	add    $0x2c,%esp
  8013cd:	5b                   	pop    %ebx
  8013ce:	5e                   	pop    %esi
  8013cf:	5f                   	pop    %edi
  8013d0:	5d                   	pop    %ebp
  8013d1:	c3                   	ret    

008013d2 <sfork>:

// Challenge!
int
sfork(void)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	83 ec 18             	sub    $0x18,%esp
//	return __fork(1);
	panic("sfork not implemented");
  8013d8:	c7 44 24 08 4e 30 80 	movl   $0x80304e,0x8(%esp)
  8013df:	00 
  8013e0:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  8013e7:	00 
  8013e8:	c7 04 24 f4 2f 80 00 	movl   $0x802ff4,(%esp)
  8013ef:	e8 7e ed ff ff       	call   800172 <_panic>
  8013f4:	66 90                	xchg   %ax,%ax
  8013f6:	66 90                	xchg   %ax,%ax
  8013f8:	66 90                	xchg   %ax,%ax
  8013fa:	66 90                	xchg   %ax,%ax
  8013fc:	66 90                	xchg   %ax,%ax
  8013fe:	66 90                	xchg   %ax,%ax

00801400 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	05 00 00 00 30       	add    $0x30000000,%eax
  80140b:	c1 e8 0c             	shr    $0xc,%eax
}
  80140e:	5d                   	pop    %ebp
  80140f:	c3                   	ret    

00801410 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80141b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801420:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    

00801427 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80142d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801432:	89 c2                	mov    %eax,%edx
  801434:	c1 ea 16             	shr    $0x16,%edx
  801437:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80143e:	f6 c2 01             	test   $0x1,%dl
  801441:	74 11                	je     801454 <fd_alloc+0x2d>
  801443:	89 c2                	mov    %eax,%edx
  801445:	c1 ea 0c             	shr    $0xc,%edx
  801448:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80144f:	f6 c2 01             	test   $0x1,%dl
  801452:	75 09                	jne    80145d <fd_alloc+0x36>
			*fd_store = fd;
  801454:	89 01                	mov    %eax,(%ecx)
			return 0;
  801456:	b8 00 00 00 00       	mov    $0x0,%eax
  80145b:	eb 17                	jmp    801474 <fd_alloc+0x4d>
  80145d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801462:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801467:	75 c9                	jne    801432 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801469:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80146f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801474:	5d                   	pop    %ebp
  801475:	c3                   	ret    

00801476 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80147c:	83 f8 1f             	cmp    $0x1f,%eax
  80147f:	77 36                	ja     8014b7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801481:	c1 e0 0c             	shl    $0xc,%eax
  801484:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801489:	89 c2                	mov    %eax,%edx
  80148b:	c1 ea 16             	shr    $0x16,%edx
  80148e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801495:	f6 c2 01             	test   $0x1,%dl
  801498:	74 24                	je     8014be <fd_lookup+0x48>
  80149a:	89 c2                	mov    %eax,%edx
  80149c:	c1 ea 0c             	shr    $0xc,%edx
  80149f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014a6:	f6 c2 01             	test   $0x1,%dl
  8014a9:	74 1a                	je     8014c5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ae:	89 02                	mov    %eax,(%edx)
	return 0;
  8014b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b5:	eb 13                	jmp    8014ca <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014bc:	eb 0c                	jmp    8014ca <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c3:	eb 05                	jmp    8014ca <fd_lookup+0x54>
  8014c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8014ca:	5d                   	pop    %ebp
  8014cb:	c3                   	ret    

008014cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	83 ec 18             	sub    $0x18,%esp
  8014d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8014d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014da:	eb 13                	jmp    8014ef <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8014dc:	39 08                	cmp    %ecx,(%eax)
  8014de:	75 0c                	jne    8014ec <dev_lookup+0x20>
			*dev = devtab[i];
  8014e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ea:	eb 38                	jmp    801524 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8014ec:	83 c2 01             	add    $0x1,%edx
  8014ef:	8b 04 95 e0 30 80 00 	mov    0x8030e0(,%edx,4),%eax
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	75 e2                	jne    8014dc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014fa:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8014ff:	8b 40 48             	mov    0x48(%eax),%eax
  801502:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801506:	89 44 24 04          	mov    %eax,0x4(%esp)
  80150a:	c7 04 24 64 30 80 00 	movl   $0x803064,(%esp)
  801511:	e8 55 ed ff ff       	call   80026b <cprintf>
	*dev = 0;
  801516:	8b 45 0c             	mov    0xc(%ebp),%eax
  801519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80151f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	56                   	push   %esi
  80152a:	53                   	push   %ebx
  80152b:	83 ec 20             	sub    $0x20,%esp
  80152e:	8b 75 08             	mov    0x8(%ebp),%esi
  801531:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801534:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801537:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80153b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801541:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801544:	89 04 24             	mov    %eax,(%esp)
  801547:	e8 2a ff ff ff       	call   801476 <fd_lookup>
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 05                	js     801555 <fd_close+0x2f>
	    || fd != fd2)
  801550:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801553:	74 0c                	je     801561 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801555:	84 db                	test   %bl,%bl
  801557:	ba 00 00 00 00       	mov    $0x0,%edx
  80155c:	0f 44 c2             	cmove  %edx,%eax
  80155f:	eb 3f                	jmp    8015a0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801561:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801564:	89 44 24 04          	mov    %eax,0x4(%esp)
  801568:	8b 06                	mov    (%esi),%eax
  80156a:	89 04 24             	mov    %eax,(%esp)
  80156d:	e8 5a ff ff ff       	call   8014cc <dev_lookup>
  801572:	89 c3                	mov    %eax,%ebx
  801574:	85 c0                	test   %eax,%eax
  801576:	78 16                	js     80158e <fd_close+0x68>
		if (dev->dev_close)
  801578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80157e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801583:	85 c0                	test   %eax,%eax
  801585:	74 07                	je     80158e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801587:	89 34 24             	mov    %esi,(%esp)
  80158a:	ff d0                	call   *%eax
  80158c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80158e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801592:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801599:	e8 bc f7 ff ff       	call   800d5a <sys_page_unmap>
	return r;
  80159e:	89 d8                	mov    %ebx,%eax
}
  8015a0:	83 c4 20             	add    $0x20,%esp
  8015a3:	5b                   	pop    %ebx
  8015a4:	5e                   	pop    %esi
  8015a5:	5d                   	pop    %ebp
  8015a6:	c3                   	ret    

008015a7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8015a7:	55                   	push   %ebp
  8015a8:	89 e5                	mov    %esp,%ebp
  8015aa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	89 04 24             	mov    %eax,(%esp)
  8015ba:	e8 b7 fe ff ff       	call   801476 <fd_lookup>
  8015bf:	89 c2                	mov    %eax,%edx
  8015c1:	85 d2                	test   %edx,%edx
  8015c3:	78 13                	js     8015d8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8015c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015cc:	00 
  8015cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d0:	89 04 24             	mov    %eax,(%esp)
  8015d3:	e8 4e ff ff ff       	call   801526 <fd_close>
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <close_all>:

void
close_all(void)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
  8015dd:	53                   	push   %ebx
  8015de:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015e6:	89 1c 24             	mov    %ebx,(%esp)
  8015e9:	e8 b9 ff ff ff       	call   8015a7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8015ee:	83 c3 01             	add    $0x1,%ebx
  8015f1:	83 fb 20             	cmp    $0x20,%ebx
  8015f4:	75 f0                	jne    8015e6 <close_all+0xc>
		close(i);
}
  8015f6:	83 c4 14             	add    $0x14,%esp
  8015f9:	5b                   	pop    %ebx
  8015fa:	5d                   	pop    %ebp
  8015fb:	c3                   	ret    

008015fc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015fc:	55                   	push   %ebp
  8015fd:	89 e5                	mov    %esp,%ebp
  8015ff:	57                   	push   %edi
  801600:	56                   	push   %esi
  801601:	53                   	push   %ebx
  801602:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801605:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801608:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	89 04 24             	mov    %eax,(%esp)
  801612:	e8 5f fe ff ff       	call   801476 <fd_lookup>
  801617:	89 c2                	mov    %eax,%edx
  801619:	85 d2                	test   %edx,%edx
  80161b:	0f 88 e1 00 00 00    	js     801702 <dup+0x106>
		return r;
	close(newfdnum);
  801621:	8b 45 0c             	mov    0xc(%ebp),%eax
  801624:	89 04 24             	mov    %eax,(%esp)
  801627:	e8 7b ff ff ff       	call   8015a7 <close>

	newfd = INDEX2FD(newfdnum);
  80162c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80162f:	c1 e3 0c             	shl    $0xc,%ebx
  801632:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80163b:	89 04 24             	mov    %eax,(%esp)
  80163e:	e8 cd fd ff ff       	call   801410 <fd2data>
  801643:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801645:	89 1c 24             	mov    %ebx,(%esp)
  801648:	e8 c3 fd ff ff       	call   801410 <fd2data>
  80164d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80164f:	89 f0                	mov    %esi,%eax
  801651:	c1 e8 16             	shr    $0x16,%eax
  801654:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80165b:	a8 01                	test   $0x1,%al
  80165d:	74 43                	je     8016a2 <dup+0xa6>
  80165f:	89 f0                	mov    %esi,%eax
  801661:	c1 e8 0c             	shr    $0xc,%eax
  801664:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80166b:	f6 c2 01             	test   $0x1,%dl
  80166e:	74 32                	je     8016a2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801670:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801677:	25 07 0e 00 00       	and    $0xe07,%eax
  80167c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801680:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801684:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80168b:	00 
  80168c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801690:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801697:	e8 6b f6 ff ff       	call   800d07 <sys_page_map>
  80169c:	89 c6                	mov    %eax,%esi
  80169e:	85 c0                	test   %eax,%eax
  8016a0:	78 3e                	js     8016e0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016a5:	89 c2                	mov    %eax,%edx
  8016a7:	c1 ea 0c             	shr    $0xc,%edx
  8016aa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016b1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016b7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8016bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016c6:	00 
  8016c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016d2:	e8 30 f6 ff ff       	call   800d07 <sys_page_map>
  8016d7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8016d9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016dc:	85 f6                	test   %esi,%esi
  8016de:	79 22                	jns    801702 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8016e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016eb:	e8 6a f6 ff ff       	call   800d5a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016fb:	e8 5a f6 ff ff       	call   800d5a <sys_page_unmap>
	return r;
  801700:	89 f0                	mov    %esi,%eax
}
  801702:	83 c4 3c             	add    $0x3c,%esp
  801705:	5b                   	pop    %ebx
  801706:	5e                   	pop    %esi
  801707:	5f                   	pop    %edi
  801708:	5d                   	pop    %ebp
  801709:	c3                   	ret    

0080170a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	53                   	push   %ebx
  80170e:	83 ec 24             	sub    $0x24,%esp
  801711:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801714:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801717:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171b:	89 1c 24             	mov    %ebx,(%esp)
  80171e:	e8 53 fd ff ff       	call   801476 <fd_lookup>
  801723:	89 c2                	mov    %eax,%edx
  801725:	85 d2                	test   %edx,%edx
  801727:	78 6d                	js     801796 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801729:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80172c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801733:	8b 00                	mov    (%eax),%eax
  801735:	89 04 24             	mov    %eax,(%esp)
  801738:	e8 8f fd ff ff       	call   8014cc <dev_lookup>
  80173d:	85 c0                	test   %eax,%eax
  80173f:	78 55                	js     801796 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801744:	8b 50 08             	mov    0x8(%eax),%edx
  801747:	83 e2 03             	and    $0x3,%edx
  80174a:	83 fa 01             	cmp    $0x1,%edx
  80174d:	75 23                	jne    801772 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80174f:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801754:	8b 40 48             	mov    0x48(%eax),%eax
  801757:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80175b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80175f:	c7 04 24 a5 30 80 00 	movl   $0x8030a5,(%esp)
  801766:	e8 00 eb ff ff       	call   80026b <cprintf>
		return -E_INVAL;
  80176b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801770:	eb 24                	jmp    801796 <read+0x8c>
	}
	if (!dev->dev_read)
  801772:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801775:	8b 52 08             	mov    0x8(%edx),%edx
  801778:	85 d2                	test   %edx,%edx
  80177a:	74 15                	je     801791 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80177c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80177f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801783:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801786:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80178a:	89 04 24             	mov    %eax,(%esp)
  80178d:	ff d2                	call   *%edx
  80178f:	eb 05                	jmp    801796 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801791:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801796:	83 c4 24             	add    $0x24,%esp
  801799:	5b                   	pop    %ebx
  80179a:	5d                   	pop    %ebp
  80179b:	c3                   	ret    

0080179c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	57                   	push   %edi
  8017a0:	56                   	push   %esi
  8017a1:	53                   	push   %ebx
  8017a2:	83 ec 1c             	sub    $0x1c,%esp
  8017a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017b0:	eb 23                	jmp    8017d5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017b2:	89 f0                	mov    %esi,%eax
  8017b4:	29 d8                	sub    %ebx,%eax
  8017b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017ba:	89 d8                	mov    %ebx,%eax
  8017bc:	03 45 0c             	add    0xc(%ebp),%eax
  8017bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c3:	89 3c 24             	mov    %edi,(%esp)
  8017c6:	e8 3f ff ff ff       	call   80170a <read>
		if (m < 0)
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	78 10                	js     8017df <readn+0x43>
			return m;
		if (m == 0)
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	74 0a                	je     8017dd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017d3:	01 c3                	add    %eax,%ebx
  8017d5:	39 f3                	cmp    %esi,%ebx
  8017d7:	72 d9                	jb     8017b2 <readn+0x16>
  8017d9:	89 d8                	mov    %ebx,%eax
  8017db:	eb 02                	jmp    8017df <readn+0x43>
  8017dd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8017df:	83 c4 1c             	add    $0x1c,%esp
  8017e2:	5b                   	pop    %ebx
  8017e3:	5e                   	pop    %esi
  8017e4:	5f                   	pop    %edi
  8017e5:	5d                   	pop    %ebp
  8017e6:	c3                   	ret    

008017e7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	53                   	push   %ebx
  8017eb:	83 ec 24             	sub    $0x24,%esp
  8017ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f8:	89 1c 24             	mov    %ebx,(%esp)
  8017fb:	e8 76 fc ff ff       	call   801476 <fd_lookup>
  801800:	89 c2                	mov    %eax,%edx
  801802:	85 d2                	test   %edx,%edx
  801804:	78 68                	js     80186e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801806:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801809:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801810:	8b 00                	mov    (%eax),%eax
  801812:	89 04 24             	mov    %eax,(%esp)
  801815:	e8 b2 fc ff ff       	call   8014cc <dev_lookup>
  80181a:	85 c0                	test   %eax,%eax
  80181c:	78 50                	js     80186e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80181e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801821:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801825:	75 23                	jne    80184a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801827:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80182c:	8b 40 48             	mov    0x48(%eax),%eax
  80182f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801833:	89 44 24 04          	mov    %eax,0x4(%esp)
  801837:	c7 04 24 c1 30 80 00 	movl   $0x8030c1,(%esp)
  80183e:	e8 28 ea ff ff       	call   80026b <cprintf>
		return -E_INVAL;
  801843:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801848:	eb 24                	jmp    80186e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80184a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80184d:	8b 52 0c             	mov    0xc(%edx),%edx
  801850:	85 d2                	test   %edx,%edx
  801852:	74 15                	je     801869 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801854:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801857:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80185b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80185e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801862:	89 04 24             	mov    %eax,(%esp)
  801865:	ff d2                	call   *%edx
  801867:	eb 05                	jmp    80186e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801869:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80186e:	83 c4 24             	add    $0x24,%esp
  801871:	5b                   	pop    %ebx
  801872:	5d                   	pop    %ebp
  801873:	c3                   	ret    

00801874 <seek>:

int
seek(int fdnum, off_t offset)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80187a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80187d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	89 04 24             	mov    %eax,(%esp)
  801887:	e8 ea fb ff ff       	call   801476 <fd_lookup>
  80188c:	85 c0                	test   %eax,%eax
  80188e:	78 0e                	js     80189e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801890:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801893:	8b 55 0c             	mov    0xc(%ebp),%edx
  801896:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801899:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 24             	sub    $0x24,%esp
  8018a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b1:	89 1c 24             	mov    %ebx,(%esp)
  8018b4:	e8 bd fb ff ff       	call   801476 <fd_lookup>
  8018b9:	89 c2                	mov    %eax,%edx
  8018bb:	85 d2                	test   %edx,%edx
  8018bd:	78 61                	js     801920 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c9:	8b 00                	mov    (%eax),%eax
  8018cb:	89 04 24             	mov    %eax,(%esp)
  8018ce:	e8 f9 fb ff ff       	call   8014cc <dev_lookup>
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	78 49                	js     801920 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018da:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018de:	75 23                	jne    801903 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8018e0:	a1 0c 50 80 00       	mov    0x80500c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018e5:	8b 40 48             	mov    0x48(%eax),%eax
  8018e8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f0:	c7 04 24 84 30 80 00 	movl   $0x803084,(%esp)
  8018f7:	e8 6f e9 ff ff       	call   80026b <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801901:	eb 1d                	jmp    801920 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801903:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801906:	8b 52 18             	mov    0x18(%edx),%edx
  801909:	85 d2                	test   %edx,%edx
  80190b:	74 0e                	je     80191b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80190d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801910:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801914:	89 04 24             	mov    %eax,(%esp)
  801917:	ff d2                	call   *%edx
  801919:	eb 05                	jmp    801920 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80191b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801920:	83 c4 24             	add    $0x24,%esp
  801923:	5b                   	pop    %ebx
  801924:	5d                   	pop    %ebp
  801925:	c3                   	ret    

00801926 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
  801929:	53                   	push   %ebx
  80192a:	83 ec 24             	sub    $0x24,%esp
  80192d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801930:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801933:	89 44 24 04          	mov    %eax,0x4(%esp)
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	89 04 24             	mov    %eax,(%esp)
  80193d:	e8 34 fb ff ff       	call   801476 <fd_lookup>
  801942:	89 c2                	mov    %eax,%edx
  801944:	85 d2                	test   %edx,%edx
  801946:	78 52                	js     80199a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801948:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801952:	8b 00                	mov    (%eax),%eax
  801954:	89 04 24             	mov    %eax,(%esp)
  801957:	e8 70 fb ff ff       	call   8014cc <dev_lookup>
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 3a                	js     80199a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801963:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801967:	74 2c                	je     801995 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801969:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80196c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801973:	00 00 00 
	stat->st_isdir = 0;
  801976:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80197d:	00 00 00 
	stat->st_dev = dev;
  801980:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801986:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80198a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80198d:	89 14 24             	mov    %edx,(%esp)
  801990:	ff 50 14             	call   *0x14(%eax)
  801993:	eb 05                	jmp    80199a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801995:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80199a:	83 c4 24             	add    $0x24,%esp
  80199d:	5b                   	pop    %ebx
  80199e:	5d                   	pop    %ebp
  80199f:	c3                   	ret    

008019a0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	56                   	push   %esi
  8019a4:	53                   	push   %ebx
  8019a5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019af:	00 
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	89 04 24             	mov    %eax,(%esp)
  8019b6:	e8 84 02 00 00       	call   801c3f <open>
  8019bb:	89 c3                	mov    %eax,%ebx
  8019bd:	85 db                	test   %ebx,%ebx
  8019bf:	78 1b                	js     8019dc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8019c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c8:	89 1c 24             	mov    %ebx,(%esp)
  8019cb:	e8 56 ff ff ff       	call   801926 <fstat>
  8019d0:	89 c6                	mov    %eax,%esi
	close(fd);
  8019d2:	89 1c 24             	mov    %ebx,(%esp)
  8019d5:	e8 cd fb ff ff       	call   8015a7 <close>
	return r;
  8019da:	89 f0                	mov    %esi,%eax
}
  8019dc:	83 c4 10             	add    $0x10,%esp
  8019df:	5b                   	pop    %ebx
  8019e0:	5e                   	pop    %esi
  8019e1:	5d                   	pop    %ebp
  8019e2:	c3                   	ret    

008019e3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	56                   	push   %esi
  8019e7:	53                   	push   %ebx
  8019e8:	83 ec 10             	sub    $0x10,%esp
  8019eb:	89 c6                	mov    %eax,%esi
  8019ed:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019ef:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8019f6:	75 11                	jne    801a09 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019ff:	e8 b1 0e 00 00       	call   8028b5 <ipc_find_env>
  801a04:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a09:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a10:	00 
  801a11:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a18:	00 
  801a19:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a1d:	a1 00 50 80 00       	mov    0x805000,%eax
  801a22:	89 04 24             	mov    %eax,(%esp)
  801a25:	e8 fe 0d 00 00       	call   802828 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a2a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a31:	00 
  801a32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a36:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a3d:	e8 7e 0d 00 00       	call   8027c0 <ipc_recv>
}
  801a42:	83 c4 10             	add    $0x10,%esp
  801a45:	5b                   	pop    %ebx
  801a46:	5e                   	pop    %esi
  801a47:	5d                   	pop    %ebp
  801a48:	c3                   	ret    

00801a49 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	8b 40 0c             	mov    0xc(%eax),%eax
  801a55:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a62:	ba 00 00 00 00       	mov    $0x0,%edx
  801a67:	b8 02 00 00 00       	mov    $0x2,%eax
  801a6c:	e8 72 ff ff ff       	call   8019e3 <fsipc>
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a7f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a84:	ba 00 00 00 00       	mov    $0x0,%edx
  801a89:	b8 06 00 00 00       	mov    $0x6,%eax
  801a8e:	e8 50 ff ff ff       	call   8019e3 <fsipc>
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	53                   	push   %ebx
  801a99:	83 ec 14             	sub    $0x14,%esp
  801a9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aaa:	ba 00 00 00 00       	mov    $0x0,%edx
  801aaf:	b8 05 00 00 00       	mov    $0x5,%eax
  801ab4:	e8 2a ff ff ff       	call   8019e3 <fsipc>
  801ab9:	89 c2                	mov    %eax,%edx
  801abb:	85 d2                	test   %edx,%edx
  801abd:	78 2b                	js     801aea <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801abf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ac6:	00 
  801ac7:	89 1c 24             	mov    %ebx,(%esp)
  801aca:	e8 c8 ed ff ff       	call   800897 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801acf:	a1 80 60 80 00       	mov    0x806080,%eax
  801ad4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ada:	a1 84 60 80 00       	mov    0x806084,%eax
  801adf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ae5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aea:	83 c4 14             	add    $0x14,%esp
  801aed:	5b                   	pop    %ebx
  801aee:	5d                   	pop    %ebp
  801aef:	c3                   	ret    

00801af0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	53                   	push   %ebx
  801af4:	83 ec 14             	sub    $0x14,%esp
  801af7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	8b 40 0c             	mov    0xc(%eax),%eax
  801b00:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801b05:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801b0b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801b10:	0f 46 c3             	cmovbe %ebx,%eax
  801b13:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801b18:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b23:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801b2a:	e8 05 ef ff ff       	call   800a34 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801b2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b34:	b8 04 00 00 00       	mov    $0x4,%eax
  801b39:	e8 a5 fe ff ff       	call   8019e3 <fsipc>
  801b3e:	85 c0                	test   %eax,%eax
  801b40:	78 53                	js     801b95 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801b42:	39 c3                	cmp    %eax,%ebx
  801b44:	73 24                	jae    801b6a <devfile_write+0x7a>
  801b46:	c7 44 24 0c f4 30 80 	movl   $0x8030f4,0xc(%esp)
  801b4d:	00 
  801b4e:	c7 44 24 08 fb 30 80 	movl   $0x8030fb,0x8(%esp)
  801b55:	00 
  801b56:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801b5d:	00 
  801b5e:	c7 04 24 10 31 80 00 	movl   $0x803110,(%esp)
  801b65:	e8 08 e6 ff ff       	call   800172 <_panic>
	assert(r <= PGSIZE);
  801b6a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b6f:	7e 24                	jle    801b95 <devfile_write+0xa5>
  801b71:	c7 44 24 0c 1b 31 80 	movl   $0x80311b,0xc(%esp)
  801b78:	00 
  801b79:	c7 44 24 08 fb 30 80 	movl   $0x8030fb,0x8(%esp)
  801b80:	00 
  801b81:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801b88:	00 
  801b89:	c7 04 24 10 31 80 00 	movl   $0x803110,(%esp)
  801b90:	e8 dd e5 ff ff       	call   800172 <_panic>
	return r;
}
  801b95:	83 c4 14             	add    $0x14,%esp
  801b98:	5b                   	pop    %ebx
  801b99:	5d                   	pop    %ebp
  801b9a:	c3                   	ret    

00801b9b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
  801b9e:	56                   	push   %esi
  801b9f:	53                   	push   %ebx
  801ba0:	83 ec 10             	sub    $0x10,%esp
  801ba3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba9:	8b 40 0c             	mov    0xc(%eax),%eax
  801bac:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801bb1:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bb7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbc:	b8 03 00 00 00       	mov    $0x3,%eax
  801bc1:	e8 1d fe ff ff       	call   8019e3 <fsipc>
  801bc6:	89 c3                	mov    %eax,%ebx
  801bc8:	85 c0                	test   %eax,%eax
  801bca:	78 6a                	js     801c36 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801bcc:	39 c6                	cmp    %eax,%esi
  801bce:	73 24                	jae    801bf4 <devfile_read+0x59>
  801bd0:	c7 44 24 0c f4 30 80 	movl   $0x8030f4,0xc(%esp)
  801bd7:	00 
  801bd8:	c7 44 24 08 fb 30 80 	movl   $0x8030fb,0x8(%esp)
  801bdf:	00 
  801be0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801be7:	00 
  801be8:	c7 04 24 10 31 80 00 	movl   $0x803110,(%esp)
  801bef:	e8 7e e5 ff ff       	call   800172 <_panic>
	assert(r <= PGSIZE);
  801bf4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bf9:	7e 24                	jle    801c1f <devfile_read+0x84>
  801bfb:	c7 44 24 0c 1b 31 80 	movl   $0x80311b,0xc(%esp)
  801c02:	00 
  801c03:	c7 44 24 08 fb 30 80 	movl   $0x8030fb,0x8(%esp)
  801c0a:	00 
  801c0b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801c12:	00 
  801c13:	c7 04 24 10 31 80 00 	movl   $0x803110,(%esp)
  801c1a:	e8 53 e5 ff ff       	call   800172 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c1f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c23:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c2a:	00 
  801c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2e:	89 04 24             	mov    %eax,(%esp)
  801c31:	e8 fe ed ff ff       	call   800a34 <memmove>
	return r;
}
  801c36:	89 d8                	mov    %ebx,%eax
  801c38:	83 c4 10             	add    $0x10,%esp
  801c3b:	5b                   	pop    %ebx
  801c3c:	5e                   	pop    %esi
  801c3d:	5d                   	pop    %ebp
  801c3e:	c3                   	ret    

00801c3f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	53                   	push   %ebx
  801c43:	83 ec 24             	sub    $0x24,%esp
  801c46:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c49:	89 1c 24             	mov    %ebx,(%esp)
  801c4c:	e8 0f ec ff ff       	call   800860 <strlen>
  801c51:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c56:	7f 60                	jg     801cb8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c5b:	89 04 24             	mov    %eax,(%esp)
  801c5e:	e8 c4 f7 ff ff       	call   801427 <fd_alloc>
  801c63:	89 c2                	mov    %eax,%edx
  801c65:	85 d2                	test   %edx,%edx
  801c67:	78 54                	js     801cbd <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c69:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c6d:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801c74:	e8 1e ec ff ff       	call   800897 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c84:	b8 01 00 00 00       	mov    $0x1,%eax
  801c89:	e8 55 fd ff ff       	call   8019e3 <fsipc>
  801c8e:	89 c3                	mov    %eax,%ebx
  801c90:	85 c0                	test   %eax,%eax
  801c92:	79 17                	jns    801cab <open+0x6c>
		fd_close(fd, 0);
  801c94:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c9b:	00 
  801c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9f:	89 04 24             	mov    %eax,(%esp)
  801ca2:	e8 7f f8 ff ff       	call   801526 <fd_close>
		return r;
  801ca7:	89 d8                	mov    %ebx,%eax
  801ca9:	eb 12                	jmp    801cbd <open+0x7e>
	}

	return fd2num(fd);
  801cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cae:	89 04 24             	mov    %eax,(%esp)
  801cb1:	e8 4a f7 ff ff       	call   801400 <fd2num>
  801cb6:	eb 05                	jmp    801cbd <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801cb8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801cbd:	83 c4 24             	add    $0x24,%esp
  801cc0:	5b                   	pop    %ebx
  801cc1:	5d                   	pop    %ebp
  801cc2:	c3                   	ret    

00801cc3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  801cce:	b8 08 00 00 00       	mov    $0x8,%eax
  801cd3:	e8 0b fd ff ff       	call   8019e3 <fsipc>
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    
  801cda:	66 90                	xchg   %ax,%ax
  801cdc:	66 90                	xchg   %ax,%ax
  801cde:	66 90                	xchg   %ax,%ax

00801ce0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ce6:	c7 44 24 04 27 31 80 	movl   $0x803127,0x4(%esp)
  801ced:	00 
  801cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf1:	89 04 24             	mov    %eax,(%esp)
  801cf4:	e8 9e eb ff ff       	call   800897 <strcpy>
	return 0;
}
  801cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	53                   	push   %ebx
  801d04:	83 ec 14             	sub    $0x14,%esp
  801d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d0a:	89 1c 24             	mov    %ebx,(%esp)
  801d0d:	e8 dd 0b 00 00       	call   8028ef <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801d12:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801d17:	83 f8 01             	cmp    $0x1,%eax
  801d1a:	75 0d                	jne    801d29 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801d1c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801d1f:	89 04 24             	mov    %eax,(%esp)
  801d22:	e8 29 03 00 00       	call   802050 <nsipc_close>
  801d27:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801d29:	89 d0                	mov    %edx,%eax
  801d2b:	83 c4 14             	add    $0x14,%esp
  801d2e:	5b                   	pop    %ebx
  801d2f:	5d                   	pop    %ebp
  801d30:	c3                   	ret    

00801d31 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d37:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d3e:	00 
  801d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d42:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d50:	8b 40 0c             	mov    0xc(%eax),%eax
  801d53:	89 04 24             	mov    %eax,(%esp)
  801d56:	e8 f0 03 00 00       	call   80214b <nsipc_send>
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
  801d60:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d63:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d6a:	00 
  801d6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d75:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7f:	89 04 24             	mov    %eax,(%esp)
  801d82:	e8 44 03 00 00       	call   8020cb <nsipc_recv>
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d8f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d92:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d96:	89 04 24             	mov    %eax,(%esp)
  801d99:	e8 d8 f6 ff ff       	call   801476 <fd_lookup>
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	78 17                	js     801db9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801dab:	39 08                	cmp    %ecx,(%eax)
  801dad:	75 05                	jne    801db4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801daf:	8b 40 0c             	mov    0xc(%eax),%eax
  801db2:	eb 05                	jmp    801db9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801db4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	56                   	push   %esi
  801dbf:	53                   	push   %ebx
  801dc0:	83 ec 20             	sub    $0x20,%esp
  801dc3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801dc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dc8:	89 04 24             	mov    %eax,(%esp)
  801dcb:	e8 57 f6 ff ff       	call   801427 <fd_alloc>
  801dd0:	89 c3                	mov    %eax,%ebx
  801dd2:	85 c0                	test   %eax,%eax
  801dd4:	78 21                	js     801df7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801dd6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ddd:	00 
  801dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dec:	e8 c2 ee ff ff       	call   800cb3 <sys_page_alloc>
  801df1:	89 c3                	mov    %eax,%ebx
  801df3:	85 c0                	test   %eax,%eax
  801df5:	79 0c                	jns    801e03 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801df7:	89 34 24             	mov    %esi,(%esp)
  801dfa:	e8 51 02 00 00       	call   802050 <nsipc_close>
		return r;
  801dff:	89 d8                	mov    %ebx,%eax
  801e01:	eb 20                	jmp    801e23 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801e03:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e11:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801e18:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801e1b:	89 14 24             	mov    %edx,(%esp)
  801e1e:	e8 dd f5 ff ff       	call   801400 <fd2num>
}
  801e23:	83 c4 20             	add    $0x20,%esp
  801e26:	5b                   	pop    %ebx
  801e27:	5e                   	pop    %esi
  801e28:	5d                   	pop    %ebp
  801e29:	c3                   	ret    

00801e2a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e30:	8b 45 08             	mov    0x8(%ebp),%eax
  801e33:	e8 51 ff ff ff       	call   801d89 <fd2sockid>
		return r;
  801e38:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e3a:	85 c0                	test   %eax,%eax
  801e3c:	78 23                	js     801e61 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e3e:	8b 55 10             	mov    0x10(%ebp),%edx
  801e41:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e48:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e4c:	89 04 24             	mov    %eax,(%esp)
  801e4f:	e8 45 01 00 00       	call   801f99 <nsipc_accept>
		return r;
  801e54:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e56:	85 c0                	test   %eax,%eax
  801e58:	78 07                	js     801e61 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801e5a:	e8 5c ff ff ff       	call   801dbb <alloc_sockfd>
  801e5f:	89 c1                	mov    %eax,%ecx
}
  801e61:	89 c8                	mov    %ecx,%eax
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6e:	e8 16 ff ff ff       	call   801d89 <fd2sockid>
  801e73:	89 c2                	mov    %eax,%edx
  801e75:	85 d2                	test   %edx,%edx
  801e77:	78 16                	js     801e8f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801e79:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e87:	89 14 24             	mov    %edx,(%esp)
  801e8a:	e8 60 01 00 00       	call   801fef <nsipc_bind>
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <shutdown>:

int
shutdown(int s, int how)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	e8 ea fe ff ff       	call   801d89 <fd2sockid>
  801e9f:	89 c2                	mov    %eax,%edx
  801ea1:	85 d2                	test   %edx,%edx
  801ea3:	78 0f                	js     801eb4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801ea5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eac:	89 14 24             	mov    %edx,(%esp)
  801eaf:	e8 7a 01 00 00       	call   80202e <nsipc_shutdown>
}
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebf:	e8 c5 fe ff ff       	call   801d89 <fd2sockid>
  801ec4:	89 c2                	mov    %eax,%edx
  801ec6:	85 d2                	test   %edx,%edx
  801ec8:	78 16                	js     801ee0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801eca:	8b 45 10             	mov    0x10(%ebp),%eax
  801ecd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed8:	89 14 24             	mov    %edx,(%esp)
  801edb:	e8 8a 01 00 00       	call   80206a <nsipc_connect>
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <listen>:

int
listen(int s, int backlog)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	e8 99 fe ff ff       	call   801d89 <fd2sockid>
  801ef0:	89 c2                	mov    %eax,%edx
  801ef2:	85 d2                	test   %edx,%edx
  801ef4:	78 0f                	js     801f05 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801efd:	89 14 24             	mov    %edx,(%esp)
  801f00:	e8 a4 01 00 00       	call   8020a9 <nsipc_listen>
}
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
  801f0a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f0d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f10:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f17:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	89 04 24             	mov    %eax,(%esp)
  801f21:	e8 98 02 00 00       	call   8021be <nsipc_socket>
  801f26:	89 c2                	mov    %eax,%edx
  801f28:	85 d2                	test   %edx,%edx
  801f2a:	78 05                	js     801f31 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801f2c:	e8 8a fe ff ff       	call   801dbb <alloc_sockfd>
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
  801f36:	53                   	push   %ebx
  801f37:	83 ec 14             	sub    $0x14,%esp
  801f3a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f3c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f43:	75 11                	jne    801f56 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f45:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801f4c:	e8 64 09 00 00       	call   8028b5 <ipc_find_env>
  801f51:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f56:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f5d:	00 
  801f5e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801f65:	00 
  801f66:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f6a:	a1 04 50 80 00       	mov    0x805004,%eax
  801f6f:	89 04 24             	mov    %eax,(%esp)
  801f72:	e8 b1 08 00 00       	call   802828 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f77:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f7e:	00 
  801f7f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f86:	00 
  801f87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f8e:	e8 2d 08 00 00       	call   8027c0 <ipc_recv>
}
  801f93:	83 c4 14             	add    $0x14,%esp
  801f96:	5b                   	pop    %ebx
  801f97:	5d                   	pop    %ebp
  801f98:	c3                   	ret    

00801f99 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	56                   	push   %esi
  801f9d:	53                   	push   %ebx
  801f9e:	83 ec 10             	sub    $0x10,%esp
  801fa1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801fac:	8b 06                	mov    (%esi),%eax
  801fae:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801fb3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb8:	e8 76 ff ff ff       	call   801f33 <nsipc>
  801fbd:	89 c3                	mov    %eax,%ebx
  801fbf:	85 c0                	test   %eax,%eax
  801fc1:	78 23                	js     801fe6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fc3:	a1 10 70 80 00       	mov    0x807010,%eax
  801fc8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fcc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801fd3:	00 
  801fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd7:	89 04 24             	mov    %eax,(%esp)
  801fda:	e8 55 ea ff ff       	call   800a34 <memmove>
		*addrlen = ret->ret_addrlen;
  801fdf:	a1 10 70 80 00       	mov    0x807010,%eax
  801fe4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801fe6:	89 d8                	mov    %ebx,%eax
  801fe8:	83 c4 10             	add    $0x10,%esp
  801feb:	5b                   	pop    %ebx
  801fec:	5e                   	pop    %esi
  801fed:	5d                   	pop    %ebp
  801fee:	c3                   	ret    

00801fef <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	53                   	push   %ebx
  801ff3:	83 ec 14             	sub    $0x14,%esp
  801ff6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802001:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802005:	8b 45 0c             	mov    0xc(%ebp),%eax
  802008:	89 44 24 04          	mov    %eax,0x4(%esp)
  80200c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802013:	e8 1c ea ff ff       	call   800a34 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802018:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80201e:	b8 02 00 00 00       	mov    $0x2,%eax
  802023:	e8 0b ff ff ff       	call   801f33 <nsipc>
}
  802028:	83 c4 14             	add    $0x14,%esp
  80202b:	5b                   	pop    %ebx
  80202c:	5d                   	pop    %ebp
  80202d:	c3                   	ret    

0080202e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80203c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802044:	b8 03 00 00 00       	mov    $0x3,%eax
  802049:	e8 e5 fe ff ff       	call   801f33 <nsipc>
}
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <nsipc_close>:

int
nsipc_close(int s)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80205e:	b8 04 00 00 00       	mov    $0x4,%eax
  802063:	e8 cb fe ff ff       	call   801f33 <nsipc>
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	53                   	push   %ebx
  80206e:	83 ec 14             	sub    $0x14,%esp
  802071:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80207c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802080:	8b 45 0c             	mov    0xc(%ebp),%eax
  802083:	89 44 24 04          	mov    %eax,0x4(%esp)
  802087:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80208e:	e8 a1 e9 ff ff       	call   800a34 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802093:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802099:	b8 05 00 00 00       	mov    $0x5,%eax
  80209e:	e8 90 fe ff ff       	call   801f33 <nsipc>
}
  8020a3:	83 c4 14             	add    $0x14,%esp
  8020a6:	5b                   	pop    %ebx
  8020a7:	5d                   	pop    %ebp
  8020a8:	c3                   	ret    

008020a9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ba:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020bf:	b8 06 00 00 00       	mov    $0x6,%eax
  8020c4:	e8 6a fe ff ff       	call   801f33 <nsipc>
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	56                   	push   %esi
  8020cf:	53                   	push   %ebx
  8020d0:	83 ec 10             	sub    $0x10,%esp
  8020d3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8020de:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8020e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020e7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020ec:	b8 07 00 00 00       	mov    $0x7,%eax
  8020f1:	e8 3d fe ff ff       	call   801f33 <nsipc>
  8020f6:	89 c3                	mov    %eax,%ebx
  8020f8:	85 c0                	test   %eax,%eax
  8020fa:	78 46                	js     802142 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8020fc:	39 f0                	cmp    %esi,%eax
  8020fe:	7f 07                	jg     802107 <nsipc_recv+0x3c>
  802100:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802105:	7e 24                	jle    80212b <nsipc_recv+0x60>
  802107:	c7 44 24 0c 33 31 80 	movl   $0x803133,0xc(%esp)
  80210e:	00 
  80210f:	c7 44 24 08 fb 30 80 	movl   $0x8030fb,0x8(%esp)
  802116:	00 
  802117:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80211e:	00 
  80211f:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  802126:	e8 47 e0 ff ff       	call   800172 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80212b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80212f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802136:	00 
  802137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213a:	89 04 24             	mov    %eax,(%esp)
  80213d:	e8 f2 e8 ff ff       	call   800a34 <memmove>
	}

	return r;
}
  802142:	89 d8                	mov    %ebx,%eax
  802144:	83 c4 10             	add    $0x10,%esp
  802147:	5b                   	pop    %ebx
  802148:	5e                   	pop    %esi
  802149:	5d                   	pop    %ebp
  80214a:	c3                   	ret    

0080214b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	53                   	push   %ebx
  80214f:	83 ec 14             	sub    $0x14,%esp
  802152:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80215d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802163:	7e 24                	jle    802189 <nsipc_send+0x3e>
  802165:	c7 44 24 0c 54 31 80 	movl   $0x803154,0xc(%esp)
  80216c:	00 
  80216d:	c7 44 24 08 fb 30 80 	movl   $0x8030fb,0x8(%esp)
  802174:	00 
  802175:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80217c:	00 
  80217d:	c7 04 24 48 31 80 00 	movl   $0x803148,(%esp)
  802184:	e8 e9 df ff ff       	call   800172 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802189:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80218d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802190:	89 44 24 04          	mov    %eax,0x4(%esp)
  802194:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80219b:	e8 94 e8 ff ff       	call   800a34 <memmove>
	nsipcbuf.send.req_size = size;
  8021a0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8021a9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8021b3:	e8 7b fd ff ff       	call   801f33 <nsipc>
}
  8021b8:	83 c4 14             	add    $0x14,%esp
  8021bb:	5b                   	pop    %ebx
  8021bc:	5d                   	pop    %ebp
  8021bd:	c3                   	ret    

008021be <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8021cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021cf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8021d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021d7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8021dc:	b8 09 00 00 00       	mov    $0x9,%eax
  8021e1:	e8 4d fd ff ff       	call   801f33 <nsipc>
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
  8021eb:	56                   	push   %esi
  8021ec:	53                   	push   %ebx
  8021ed:	83 ec 10             	sub    $0x10,%esp
  8021f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	89 04 24             	mov    %eax,(%esp)
  8021f9:	e8 12 f2 ff ff       	call   801410 <fd2data>
  8021fe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802200:	c7 44 24 04 60 31 80 	movl   $0x803160,0x4(%esp)
  802207:	00 
  802208:	89 1c 24             	mov    %ebx,(%esp)
  80220b:	e8 87 e6 ff ff       	call   800897 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802210:	8b 46 04             	mov    0x4(%esi),%eax
  802213:	2b 06                	sub    (%esi),%eax
  802215:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80221b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802222:	00 00 00 
	stat->st_dev = &devpipe;
  802225:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80222c:	40 80 00 
	return 0;
}
  80222f:	b8 00 00 00 00       	mov    $0x0,%eax
  802234:	83 c4 10             	add    $0x10,%esp
  802237:	5b                   	pop    %ebx
  802238:	5e                   	pop    %esi
  802239:	5d                   	pop    %ebp
  80223a:	c3                   	ret    

0080223b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
  80223e:	53                   	push   %ebx
  80223f:	83 ec 14             	sub    $0x14,%esp
  802242:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802245:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802249:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802250:	e8 05 eb ff ff       	call   800d5a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802255:	89 1c 24             	mov    %ebx,(%esp)
  802258:	e8 b3 f1 ff ff       	call   801410 <fd2data>
  80225d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802261:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802268:	e8 ed ea ff ff       	call   800d5a <sys_page_unmap>
}
  80226d:	83 c4 14             	add    $0x14,%esp
  802270:	5b                   	pop    %ebx
  802271:	5d                   	pop    %ebp
  802272:	c3                   	ret    

00802273 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
  802276:	57                   	push   %edi
  802277:	56                   	push   %esi
  802278:	53                   	push   %ebx
  802279:	83 ec 2c             	sub    $0x2c,%esp
  80227c:	89 c6                	mov    %eax,%esi
  80227e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802281:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802286:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802289:	89 34 24             	mov    %esi,(%esp)
  80228c:	e8 5e 06 00 00       	call   8028ef <pageref>
  802291:	89 c7                	mov    %eax,%edi
  802293:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802296:	89 04 24             	mov    %eax,(%esp)
  802299:	e8 51 06 00 00       	call   8028ef <pageref>
  80229e:	39 c7                	cmp    %eax,%edi
  8022a0:	0f 94 c2             	sete   %dl
  8022a3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8022a6:	8b 0d 0c 50 80 00    	mov    0x80500c,%ecx
  8022ac:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8022af:	39 fb                	cmp    %edi,%ebx
  8022b1:	74 21                	je     8022d4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8022b3:	84 d2                	test   %dl,%dl
  8022b5:	74 ca                	je     802281 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022b7:	8b 51 58             	mov    0x58(%ecx),%edx
  8022ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022be:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022c6:	c7 04 24 67 31 80 00 	movl   $0x803167,(%esp)
  8022cd:	e8 99 df ff ff       	call   80026b <cprintf>
  8022d2:	eb ad                	jmp    802281 <_pipeisclosed+0xe>
	}
}
  8022d4:	83 c4 2c             	add    $0x2c,%esp
  8022d7:	5b                   	pop    %ebx
  8022d8:	5e                   	pop    %esi
  8022d9:	5f                   	pop    %edi
  8022da:	5d                   	pop    %ebp
  8022db:	c3                   	ret    

008022dc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	57                   	push   %edi
  8022e0:	56                   	push   %esi
  8022e1:	53                   	push   %ebx
  8022e2:	83 ec 1c             	sub    $0x1c,%esp
  8022e5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8022e8:	89 34 24             	mov    %esi,(%esp)
  8022eb:	e8 20 f1 ff ff       	call   801410 <fd2data>
  8022f0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022f7:	eb 45                	jmp    80233e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8022f9:	89 da                	mov    %ebx,%edx
  8022fb:	89 f0                	mov    %esi,%eax
  8022fd:	e8 71 ff ff ff       	call   802273 <_pipeisclosed>
  802302:	85 c0                	test   %eax,%eax
  802304:	75 41                	jne    802347 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802306:	e8 89 e9 ff ff       	call   800c94 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80230b:	8b 43 04             	mov    0x4(%ebx),%eax
  80230e:	8b 0b                	mov    (%ebx),%ecx
  802310:	8d 51 20             	lea    0x20(%ecx),%edx
  802313:	39 d0                	cmp    %edx,%eax
  802315:	73 e2                	jae    8022f9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80231a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80231e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802321:	99                   	cltd   
  802322:	c1 ea 1b             	shr    $0x1b,%edx
  802325:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802328:	83 e1 1f             	and    $0x1f,%ecx
  80232b:	29 d1                	sub    %edx,%ecx
  80232d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802331:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802335:	83 c0 01             	add    $0x1,%eax
  802338:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80233b:	83 c7 01             	add    $0x1,%edi
  80233e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802341:	75 c8                	jne    80230b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802343:	89 f8                	mov    %edi,%eax
  802345:	eb 05                	jmp    80234c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802347:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80234c:	83 c4 1c             	add    $0x1c,%esp
  80234f:	5b                   	pop    %ebx
  802350:	5e                   	pop    %esi
  802351:	5f                   	pop    %edi
  802352:	5d                   	pop    %ebp
  802353:	c3                   	ret    

00802354 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	57                   	push   %edi
  802358:	56                   	push   %esi
  802359:	53                   	push   %ebx
  80235a:	83 ec 1c             	sub    $0x1c,%esp
  80235d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802360:	89 3c 24             	mov    %edi,(%esp)
  802363:	e8 a8 f0 ff ff       	call   801410 <fd2data>
  802368:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80236a:	be 00 00 00 00       	mov    $0x0,%esi
  80236f:	eb 3d                	jmp    8023ae <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802371:	85 f6                	test   %esi,%esi
  802373:	74 04                	je     802379 <devpipe_read+0x25>
				return i;
  802375:	89 f0                	mov    %esi,%eax
  802377:	eb 43                	jmp    8023bc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802379:	89 da                	mov    %ebx,%edx
  80237b:	89 f8                	mov    %edi,%eax
  80237d:	e8 f1 fe ff ff       	call   802273 <_pipeisclosed>
  802382:	85 c0                	test   %eax,%eax
  802384:	75 31                	jne    8023b7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802386:	e8 09 e9 ff ff       	call   800c94 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80238b:	8b 03                	mov    (%ebx),%eax
  80238d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802390:	74 df                	je     802371 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802392:	99                   	cltd   
  802393:	c1 ea 1b             	shr    $0x1b,%edx
  802396:	01 d0                	add    %edx,%eax
  802398:	83 e0 1f             	and    $0x1f,%eax
  80239b:	29 d0                	sub    %edx,%eax
  80239d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023a5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023a8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023ab:	83 c6 01             	add    $0x1,%esi
  8023ae:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023b1:	75 d8                	jne    80238b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8023b3:	89 f0                	mov    %esi,%eax
  8023b5:	eb 05                	jmp    8023bc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8023b7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8023bc:	83 c4 1c             	add    $0x1c,%esp
  8023bf:	5b                   	pop    %ebx
  8023c0:	5e                   	pop    %esi
  8023c1:	5f                   	pop    %edi
  8023c2:	5d                   	pop    %ebp
  8023c3:	c3                   	ret    

008023c4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	56                   	push   %esi
  8023c8:	53                   	push   %ebx
  8023c9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8023cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023cf:	89 04 24             	mov    %eax,(%esp)
  8023d2:	e8 50 f0 ff ff       	call   801427 <fd_alloc>
  8023d7:	89 c2                	mov    %eax,%edx
  8023d9:	85 d2                	test   %edx,%edx
  8023db:	0f 88 4d 01 00 00    	js     80252e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023e1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023e8:	00 
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f7:	e8 b7 e8 ff ff       	call   800cb3 <sys_page_alloc>
  8023fc:	89 c2                	mov    %eax,%edx
  8023fe:	85 d2                	test   %edx,%edx
  802400:	0f 88 28 01 00 00    	js     80252e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802406:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802409:	89 04 24             	mov    %eax,(%esp)
  80240c:	e8 16 f0 ff ff       	call   801427 <fd_alloc>
  802411:	89 c3                	mov    %eax,%ebx
  802413:	85 c0                	test   %eax,%eax
  802415:	0f 88 fe 00 00 00    	js     802519 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80241b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802422:	00 
  802423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802426:	89 44 24 04          	mov    %eax,0x4(%esp)
  80242a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802431:	e8 7d e8 ff ff       	call   800cb3 <sys_page_alloc>
  802436:	89 c3                	mov    %eax,%ebx
  802438:	85 c0                	test   %eax,%eax
  80243a:	0f 88 d9 00 00 00    	js     802519 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	89 04 24             	mov    %eax,(%esp)
  802446:	e8 c5 ef ff ff       	call   801410 <fd2data>
  80244b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80244d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802454:	00 
  802455:	89 44 24 04          	mov    %eax,0x4(%esp)
  802459:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802460:	e8 4e e8 ff ff       	call   800cb3 <sys_page_alloc>
  802465:	89 c3                	mov    %eax,%ebx
  802467:	85 c0                	test   %eax,%eax
  802469:	0f 88 97 00 00 00    	js     802506 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80246f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802472:	89 04 24             	mov    %eax,(%esp)
  802475:	e8 96 ef ff ff       	call   801410 <fd2data>
  80247a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802481:	00 
  802482:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802486:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80248d:	00 
  80248e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802492:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802499:	e8 69 e8 ff ff       	call   800d07 <sys_page_map>
  80249e:	89 c3                	mov    %eax,%ebx
  8024a0:	85 c0                	test   %eax,%eax
  8024a2:	78 52                	js     8024f6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8024a4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8024b9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8024bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8024c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8024ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d1:	89 04 24             	mov    %eax,(%esp)
  8024d4:	e8 27 ef ff ff       	call   801400 <fd2num>
  8024d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024dc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e1:	89 04 24             	mov    %eax,(%esp)
  8024e4:	e8 17 ef ff ff       	call   801400 <fd2num>
  8024e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ec:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f4:	eb 38                	jmp    80252e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8024f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802501:	e8 54 e8 ff ff       	call   800d5a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802509:	89 44 24 04          	mov    %eax,0x4(%esp)
  80250d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802514:	e8 41 e8 ff ff       	call   800d5a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802520:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802527:	e8 2e e8 ff ff       	call   800d5a <sys_page_unmap>
  80252c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80252e:	83 c4 30             	add    $0x30,%esp
  802531:	5b                   	pop    %ebx
  802532:	5e                   	pop    %esi
  802533:	5d                   	pop    %ebp
  802534:	c3                   	ret    

00802535 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802535:	55                   	push   %ebp
  802536:	89 e5                	mov    %esp,%ebp
  802538:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80253b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80253e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802542:	8b 45 08             	mov    0x8(%ebp),%eax
  802545:	89 04 24             	mov    %eax,(%esp)
  802548:	e8 29 ef ff ff       	call   801476 <fd_lookup>
  80254d:	89 c2                	mov    %eax,%edx
  80254f:	85 d2                	test   %edx,%edx
  802551:	78 15                	js     802568 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	89 04 24             	mov    %eax,(%esp)
  802559:	e8 b2 ee ff ff       	call   801410 <fd2data>
	return _pipeisclosed(fd, p);
  80255e:	89 c2                	mov    %eax,%edx
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	e8 0b fd ff ff       	call   802273 <_pipeisclosed>
}
  802568:	c9                   	leave  
  802569:	c3                   	ret    
  80256a:	66 90                	xchg   %ax,%ax
  80256c:	66 90                	xchg   %ax,%ax
  80256e:	66 90                	xchg   %ax,%ax

00802570 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802573:	b8 00 00 00 00       	mov    $0x0,%eax
  802578:	5d                   	pop    %ebp
  802579:	c3                   	ret    

0080257a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
  80257d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802580:	c7 44 24 04 7f 31 80 	movl   $0x80317f,0x4(%esp)
  802587:	00 
  802588:	8b 45 0c             	mov    0xc(%ebp),%eax
  80258b:	89 04 24             	mov    %eax,(%esp)
  80258e:	e8 04 e3 ff ff       	call   800897 <strcpy>
	return 0;
}
  802593:	b8 00 00 00 00       	mov    $0x0,%eax
  802598:	c9                   	leave  
  802599:	c3                   	ret    

0080259a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
  80259d:	57                   	push   %edi
  80259e:	56                   	push   %esi
  80259f:	53                   	push   %ebx
  8025a0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025a6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025ab:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025b1:	eb 31                	jmp    8025e4 <devcons_write+0x4a>
		m = n - tot;
  8025b3:	8b 75 10             	mov    0x10(%ebp),%esi
  8025b6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8025b8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8025bb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8025c0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025c3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8025c7:	03 45 0c             	add    0xc(%ebp),%eax
  8025ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ce:	89 3c 24             	mov    %edi,(%esp)
  8025d1:	e8 5e e4 ff ff       	call   800a34 <memmove>
		sys_cputs(buf, m);
  8025d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025da:	89 3c 24             	mov    %edi,(%esp)
  8025dd:	e8 04 e6 ff ff       	call   800be6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025e2:	01 f3                	add    %esi,%ebx
  8025e4:	89 d8                	mov    %ebx,%eax
  8025e6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8025e9:	72 c8                	jb     8025b3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8025eb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8025f1:	5b                   	pop    %ebx
  8025f2:	5e                   	pop    %esi
  8025f3:	5f                   	pop    %edi
  8025f4:	5d                   	pop    %ebp
  8025f5:	c3                   	ret    

008025f6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
  8025f9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8025fc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802601:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802605:	75 07                	jne    80260e <devcons_read+0x18>
  802607:	eb 2a                	jmp    802633 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802609:	e8 86 e6 ff ff       	call   800c94 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80260e:	66 90                	xchg   %ax,%ax
  802610:	e8 ef e5 ff ff       	call   800c04 <sys_cgetc>
  802615:	85 c0                	test   %eax,%eax
  802617:	74 f0                	je     802609 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802619:	85 c0                	test   %eax,%eax
  80261b:	78 16                	js     802633 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80261d:	83 f8 04             	cmp    $0x4,%eax
  802620:	74 0c                	je     80262e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802622:	8b 55 0c             	mov    0xc(%ebp),%edx
  802625:	88 02                	mov    %al,(%edx)
	return 1;
  802627:	b8 01 00 00 00       	mov    $0x1,%eax
  80262c:	eb 05                	jmp    802633 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80262e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802633:	c9                   	leave  
  802634:	c3                   	ret    

00802635 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
  802638:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80263b:	8b 45 08             	mov    0x8(%ebp),%eax
  80263e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802641:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802648:	00 
  802649:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80264c:	89 04 24             	mov    %eax,(%esp)
  80264f:	e8 92 e5 ff ff       	call   800be6 <sys_cputs>
}
  802654:	c9                   	leave  
  802655:	c3                   	ret    

00802656 <getchar>:

int
getchar(void)
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
  802659:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80265c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802663:	00 
  802664:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802667:	89 44 24 04          	mov    %eax,0x4(%esp)
  80266b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802672:	e8 93 f0 ff ff       	call   80170a <read>
	if (r < 0)
  802677:	85 c0                	test   %eax,%eax
  802679:	78 0f                	js     80268a <getchar+0x34>
		return r;
	if (r < 1)
  80267b:	85 c0                	test   %eax,%eax
  80267d:	7e 06                	jle    802685 <getchar+0x2f>
		return -E_EOF;
	return c;
  80267f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802683:	eb 05                	jmp    80268a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802685:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80268a:	c9                   	leave  
  80268b:	c3                   	ret    

0080268c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80268c:	55                   	push   %ebp
  80268d:	89 e5                	mov    %esp,%ebp
  80268f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802692:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802695:	89 44 24 04          	mov    %eax,0x4(%esp)
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	89 04 24             	mov    %eax,(%esp)
  80269f:	e8 d2 ed ff ff       	call   801476 <fd_lookup>
  8026a4:	85 c0                	test   %eax,%eax
  8026a6:	78 11                	js     8026b9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026b1:	39 10                	cmp    %edx,(%eax)
  8026b3:	0f 94 c0             	sete   %al
  8026b6:	0f b6 c0             	movzbl %al,%eax
}
  8026b9:	c9                   	leave  
  8026ba:	c3                   	ret    

008026bb <opencons>:

int
opencons(void)
{
  8026bb:	55                   	push   %ebp
  8026bc:	89 e5                	mov    %esp,%ebp
  8026be:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8026c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026c4:	89 04 24             	mov    %eax,(%esp)
  8026c7:	e8 5b ed ff ff       	call   801427 <fd_alloc>
		return r;
  8026cc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8026ce:	85 c0                	test   %eax,%eax
  8026d0:	78 40                	js     802712 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026d9:	00 
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e8:	e8 c6 e5 ff ff       	call   800cb3 <sys_page_alloc>
		return r;
  8026ed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	78 1f                	js     802712 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8026f3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802708:	89 04 24             	mov    %eax,(%esp)
  80270b:	e8 f0 ec ff ff       	call   801400 <fd2num>
  802710:	89 c2                	mov    %eax,%edx
}
  802712:	89 d0                	mov    %edx,%eax
  802714:	c9                   	leave  
  802715:	c3                   	ret    

00802716 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802716:	55                   	push   %ebp
  802717:	89 e5                	mov    %esp,%ebp
  802719:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80271c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802723:	75 68                	jne    80278d <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  802725:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80272a:	8b 40 48             	mov    0x48(%eax),%eax
  80272d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802734:	00 
  802735:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80273c:	ee 
  80273d:	89 04 24             	mov    %eax,(%esp)
  802740:	e8 6e e5 ff ff       	call   800cb3 <sys_page_alloc>
  802745:	85 c0                	test   %eax,%eax
  802747:	74 2c                	je     802775 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  802749:	89 44 24 04          	mov    %eax,0x4(%esp)
  80274d:	c7 04 24 8c 31 80 00 	movl   $0x80318c,(%esp)
  802754:	e8 12 db ff ff       	call   80026b <cprintf>
			panic("set_pg_fault_handler");
  802759:	c7 44 24 08 c0 31 80 	movl   $0x8031c0,0x8(%esp)
  802760:	00 
  802761:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802768:	00 
  802769:	c7 04 24 d5 31 80 00 	movl   $0x8031d5,(%esp)
  802770:	e8 fd d9 ff ff       	call   800172 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802775:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80277a:	8b 40 48             	mov    0x48(%eax),%eax
  80277d:	c7 44 24 04 97 27 80 	movl   $0x802797,0x4(%esp)
  802784:	00 
  802785:	89 04 24             	mov    %eax,(%esp)
  802788:	e8 c6 e6 ff ff       	call   800e53 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80278d:	8b 45 08             	mov    0x8(%ebp),%eax
  802790:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802795:	c9                   	leave  
  802796:	c3                   	ret    

00802797 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802797:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802798:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80279d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80279f:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  8027a2:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  8027a6:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  8027a8:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  8027ac:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  8027ad:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  8027b0:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  8027b2:	58                   	pop    %eax
	popl %eax
  8027b3:	58                   	pop    %eax
	popal
  8027b4:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8027b5:	83 c4 04             	add    $0x4,%esp
	popfl
  8027b8:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8027b9:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8027ba:	c3                   	ret    
  8027bb:	66 90                	xchg   %ax,%ax
  8027bd:	66 90                	xchg   %ax,%ax
  8027bf:	90                   	nop

008027c0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	56                   	push   %esi
  8027c4:	53                   	push   %ebx
  8027c5:	83 ec 10             	sub    $0x10,%esp
  8027c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8027cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8027d1:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  8027d3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8027d8:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  8027db:	89 04 24             	mov    %eax,(%esp)
  8027de:	e8 e6 e6 ff ff       	call   800ec9 <sys_ipc_recv>
  8027e3:	85 c0                	test   %eax,%eax
  8027e5:	74 16                	je     8027fd <ipc_recv+0x3d>
		if (from_env_store != NULL)
  8027e7:	85 f6                	test   %esi,%esi
  8027e9:	74 06                	je     8027f1 <ipc_recv+0x31>
			*from_env_store = 0;
  8027eb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8027f1:	85 db                	test   %ebx,%ebx
  8027f3:	74 2c                	je     802821 <ipc_recv+0x61>
			*perm_store = 0;
  8027f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8027fb:	eb 24                	jmp    802821 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8027fd:	85 f6                	test   %esi,%esi
  8027ff:	74 0a                	je     80280b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802801:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802806:	8b 40 74             	mov    0x74(%eax),%eax
  802809:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80280b:	85 db                	test   %ebx,%ebx
  80280d:	74 0a                	je     802819 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80280f:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802814:	8b 40 78             	mov    0x78(%eax),%eax
  802817:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802819:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80281e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802821:	83 c4 10             	add    $0x10,%esp
  802824:	5b                   	pop    %ebx
  802825:	5e                   	pop    %esi
  802826:	5d                   	pop    %ebp
  802827:	c3                   	ret    

00802828 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802828:	55                   	push   %ebp
  802829:	89 e5                	mov    %esp,%ebp
  80282b:	57                   	push   %edi
  80282c:	56                   	push   %esi
  80282d:	53                   	push   %ebx
  80282e:	83 ec 1c             	sub    $0x1c,%esp
  802831:	8b 75 0c             	mov    0xc(%ebp),%esi
  802834:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802837:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80283a:	85 db                	test   %ebx,%ebx
  80283c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802841:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802844:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802848:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80284c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802850:	8b 45 08             	mov    0x8(%ebp),%eax
  802853:	89 04 24             	mov    %eax,(%esp)
  802856:	e8 4b e6 ff ff       	call   800ea6 <sys_ipc_try_send>
	if (r == 0) return;
  80285b:	85 c0                	test   %eax,%eax
  80285d:	75 22                	jne    802881 <ipc_send+0x59>
  80285f:	eb 4c                	jmp    8028ad <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802861:	84 d2                	test   %dl,%dl
  802863:	75 48                	jne    8028ad <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802865:	e8 2a e4 ff ff       	call   800c94 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80286a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80286e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802872:	89 74 24 04          	mov    %esi,0x4(%esp)
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	89 04 24             	mov    %eax,(%esp)
  80287c:	e8 25 e6 ff ff       	call   800ea6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802881:	85 c0                	test   %eax,%eax
  802883:	0f 94 c2             	sete   %dl
  802886:	74 d9                	je     802861 <ipc_send+0x39>
  802888:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80288b:	74 d4                	je     802861 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80288d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802891:	c7 44 24 08 e3 31 80 	movl   $0x8031e3,0x8(%esp)
  802898:	00 
  802899:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  8028a0:	00 
  8028a1:	c7 04 24 f1 31 80 00 	movl   $0x8031f1,(%esp)
  8028a8:	e8 c5 d8 ff ff       	call   800172 <_panic>
}
  8028ad:	83 c4 1c             	add    $0x1c,%esp
  8028b0:	5b                   	pop    %ebx
  8028b1:	5e                   	pop    %esi
  8028b2:	5f                   	pop    %edi
  8028b3:	5d                   	pop    %ebp
  8028b4:	c3                   	ret    

008028b5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8028b5:	55                   	push   %ebp
  8028b6:	89 e5                	mov    %esp,%ebp
  8028b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8028bb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8028c0:	89 c2                	mov    %eax,%edx
  8028c2:	c1 e2 07             	shl    $0x7,%edx
  8028c5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8028cb:	8b 52 50             	mov    0x50(%edx),%edx
  8028ce:	39 ca                	cmp    %ecx,%edx
  8028d0:	75 0d                	jne    8028df <ipc_find_env+0x2a>
			return envs[i].env_id;
  8028d2:	c1 e0 07             	shl    $0x7,%eax
  8028d5:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8028da:	8b 40 40             	mov    0x40(%eax),%eax
  8028dd:	eb 0e                	jmp    8028ed <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8028df:	83 c0 01             	add    $0x1,%eax
  8028e2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8028e7:	75 d7                	jne    8028c0 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8028e9:	66 b8 00 00          	mov    $0x0,%ax
}
  8028ed:	5d                   	pop    %ebp
  8028ee:	c3                   	ret    

008028ef <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8028ef:	55                   	push   %ebp
  8028f0:	89 e5                	mov    %esp,%ebp
  8028f2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8028f5:	89 d0                	mov    %edx,%eax
  8028f7:	c1 e8 16             	shr    $0x16,%eax
  8028fa:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802901:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802906:	f6 c1 01             	test   $0x1,%cl
  802909:	74 1d                	je     802928 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80290b:	c1 ea 0c             	shr    $0xc,%edx
  80290e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802915:	f6 c2 01             	test   $0x1,%dl
  802918:	74 0e                	je     802928 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80291a:	c1 ea 0c             	shr    $0xc,%edx
  80291d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802924:	ef 
  802925:	0f b7 c0             	movzwl %ax,%eax
}
  802928:	5d                   	pop    %ebp
  802929:	c3                   	ret    
  80292a:	66 90                	xchg   %ax,%ax
  80292c:	66 90                	xchg   %ax,%ax
  80292e:	66 90                	xchg   %ax,%ax

00802930 <__udivdi3>:
  802930:	55                   	push   %ebp
  802931:	57                   	push   %edi
  802932:	56                   	push   %esi
  802933:	83 ec 0c             	sub    $0xc,%esp
  802936:	8b 44 24 28          	mov    0x28(%esp),%eax
  80293a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80293e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802942:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802946:	85 c0                	test   %eax,%eax
  802948:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80294c:	89 ea                	mov    %ebp,%edx
  80294e:	89 0c 24             	mov    %ecx,(%esp)
  802951:	75 2d                	jne    802980 <__udivdi3+0x50>
  802953:	39 e9                	cmp    %ebp,%ecx
  802955:	77 61                	ja     8029b8 <__udivdi3+0x88>
  802957:	85 c9                	test   %ecx,%ecx
  802959:	89 ce                	mov    %ecx,%esi
  80295b:	75 0b                	jne    802968 <__udivdi3+0x38>
  80295d:	b8 01 00 00 00       	mov    $0x1,%eax
  802962:	31 d2                	xor    %edx,%edx
  802964:	f7 f1                	div    %ecx
  802966:	89 c6                	mov    %eax,%esi
  802968:	31 d2                	xor    %edx,%edx
  80296a:	89 e8                	mov    %ebp,%eax
  80296c:	f7 f6                	div    %esi
  80296e:	89 c5                	mov    %eax,%ebp
  802970:	89 f8                	mov    %edi,%eax
  802972:	f7 f6                	div    %esi
  802974:	89 ea                	mov    %ebp,%edx
  802976:	83 c4 0c             	add    $0xc,%esp
  802979:	5e                   	pop    %esi
  80297a:	5f                   	pop    %edi
  80297b:	5d                   	pop    %ebp
  80297c:	c3                   	ret    
  80297d:	8d 76 00             	lea    0x0(%esi),%esi
  802980:	39 e8                	cmp    %ebp,%eax
  802982:	77 24                	ja     8029a8 <__udivdi3+0x78>
  802984:	0f bd e8             	bsr    %eax,%ebp
  802987:	83 f5 1f             	xor    $0x1f,%ebp
  80298a:	75 3c                	jne    8029c8 <__udivdi3+0x98>
  80298c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802990:	39 34 24             	cmp    %esi,(%esp)
  802993:	0f 86 9f 00 00 00    	jbe    802a38 <__udivdi3+0x108>
  802999:	39 d0                	cmp    %edx,%eax
  80299b:	0f 82 97 00 00 00    	jb     802a38 <__udivdi3+0x108>
  8029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8029a8:	31 d2                	xor    %edx,%edx
  8029aa:	31 c0                	xor    %eax,%eax
  8029ac:	83 c4 0c             	add    $0xc,%esp
  8029af:	5e                   	pop    %esi
  8029b0:	5f                   	pop    %edi
  8029b1:	5d                   	pop    %ebp
  8029b2:	c3                   	ret    
  8029b3:	90                   	nop
  8029b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029b8:	89 f8                	mov    %edi,%eax
  8029ba:	f7 f1                	div    %ecx
  8029bc:	31 d2                	xor    %edx,%edx
  8029be:	83 c4 0c             	add    $0xc,%esp
  8029c1:	5e                   	pop    %esi
  8029c2:	5f                   	pop    %edi
  8029c3:	5d                   	pop    %ebp
  8029c4:	c3                   	ret    
  8029c5:	8d 76 00             	lea    0x0(%esi),%esi
  8029c8:	89 e9                	mov    %ebp,%ecx
  8029ca:	8b 3c 24             	mov    (%esp),%edi
  8029cd:	d3 e0                	shl    %cl,%eax
  8029cf:	89 c6                	mov    %eax,%esi
  8029d1:	b8 20 00 00 00       	mov    $0x20,%eax
  8029d6:	29 e8                	sub    %ebp,%eax
  8029d8:	89 c1                	mov    %eax,%ecx
  8029da:	d3 ef                	shr    %cl,%edi
  8029dc:	89 e9                	mov    %ebp,%ecx
  8029de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8029e2:	8b 3c 24             	mov    (%esp),%edi
  8029e5:	09 74 24 08          	or     %esi,0x8(%esp)
  8029e9:	89 d6                	mov    %edx,%esi
  8029eb:	d3 e7                	shl    %cl,%edi
  8029ed:	89 c1                	mov    %eax,%ecx
  8029ef:	89 3c 24             	mov    %edi,(%esp)
  8029f2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8029f6:	d3 ee                	shr    %cl,%esi
  8029f8:	89 e9                	mov    %ebp,%ecx
  8029fa:	d3 e2                	shl    %cl,%edx
  8029fc:	89 c1                	mov    %eax,%ecx
  8029fe:	d3 ef                	shr    %cl,%edi
  802a00:	09 d7                	or     %edx,%edi
  802a02:	89 f2                	mov    %esi,%edx
  802a04:	89 f8                	mov    %edi,%eax
  802a06:	f7 74 24 08          	divl   0x8(%esp)
  802a0a:	89 d6                	mov    %edx,%esi
  802a0c:	89 c7                	mov    %eax,%edi
  802a0e:	f7 24 24             	mull   (%esp)
  802a11:	39 d6                	cmp    %edx,%esi
  802a13:	89 14 24             	mov    %edx,(%esp)
  802a16:	72 30                	jb     802a48 <__udivdi3+0x118>
  802a18:	8b 54 24 04          	mov    0x4(%esp),%edx
  802a1c:	89 e9                	mov    %ebp,%ecx
  802a1e:	d3 e2                	shl    %cl,%edx
  802a20:	39 c2                	cmp    %eax,%edx
  802a22:	73 05                	jae    802a29 <__udivdi3+0xf9>
  802a24:	3b 34 24             	cmp    (%esp),%esi
  802a27:	74 1f                	je     802a48 <__udivdi3+0x118>
  802a29:	89 f8                	mov    %edi,%eax
  802a2b:	31 d2                	xor    %edx,%edx
  802a2d:	e9 7a ff ff ff       	jmp    8029ac <__udivdi3+0x7c>
  802a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a38:	31 d2                	xor    %edx,%edx
  802a3a:	b8 01 00 00 00       	mov    $0x1,%eax
  802a3f:	e9 68 ff ff ff       	jmp    8029ac <__udivdi3+0x7c>
  802a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a48:	8d 47 ff             	lea    -0x1(%edi),%eax
  802a4b:	31 d2                	xor    %edx,%edx
  802a4d:	83 c4 0c             	add    $0xc,%esp
  802a50:	5e                   	pop    %esi
  802a51:	5f                   	pop    %edi
  802a52:	5d                   	pop    %ebp
  802a53:	c3                   	ret    
  802a54:	66 90                	xchg   %ax,%ax
  802a56:	66 90                	xchg   %ax,%ax
  802a58:	66 90                	xchg   %ax,%ax
  802a5a:	66 90                	xchg   %ax,%ax
  802a5c:	66 90                	xchg   %ax,%ax
  802a5e:	66 90                	xchg   %ax,%ax

00802a60 <__umoddi3>:
  802a60:	55                   	push   %ebp
  802a61:	57                   	push   %edi
  802a62:	56                   	push   %esi
  802a63:	83 ec 14             	sub    $0x14,%esp
  802a66:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a6a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a6e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802a72:	89 c7                	mov    %eax,%edi
  802a74:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a78:	8b 44 24 30          	mov    0x30(%esp),%eax
  802a7c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802a80:	89 34 24             	mov    %esi,(%esp)
  802a83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a87:	85 c0                	test   %eax,%eax
  802a89:	89 c2                	mov    %eax,%edx
  802a8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a8f:	75 17                	jne    802aa8 <__umoddi3+0x48>
  802a91:	39 fe                	cmp    %edi,%esi
  802a93:	76 4b                	jbe    802ae0 <__umoddi3+0x80>
  802a95:	89 c8                	mov    %ecx,%eax
  802a97:	89 fa                	mov    %edi,%edx
  802a99:	f7 f6                	div    %esi
  802a9b:	89 d0                	mov    %edx,%eax
  802a9d:	31 d2                	xor    %edx,%edx
  802a9f:	83 c4 14             	add    $0x14,%esp
  802aa2:	5e                   	pop    %esi
  802aa3:	5f                   	pop    %edi
  802aa4:	5d                   	pop    %ebp
  802aa5:	c3                   	ret    
  802aa6:	66 90                	xchg   %ax,%ax
  802aa8:	39 f8                	cmp    %edi,%eax
  802aaa:	77 54                	ja     802b00 <__umoddi3+0xa0>
  802aac:	0f bd e8             	bsr    %eax,%ebp
  802aaf:	83 f5 1f             	xor    $0x1f,%ebp
  802ab2:	75 5c                	jne    802b10 <__umoddi3+0xb0>
  802ab4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802ab8:	39 3c 24             	cmp    %edi,(%esp)
  802abb:	0f 87 e7 00 00 00    	ja     802ba8 <__umoddi3+0x148>
  802ac1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ac5:	29 f1                	sub    %esi,%ecx
  802ac7:	19 c7                	sbb    %eax,%edi
  802ac9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802acd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ad1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ad5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802ad9:	83 c4 14             	add    $0x14,%esp
  802adc:	5e                   	pop    %esi
  802add:	5f                   	pop    %edi
  802ade:	5d                   	pop    %ebp
  802adf:	c3                   	ret    
  802ae0:	85 f6                	test   %esi,%esi
  802ae2:	89 f5                	mov    %esi,%ebp
  802ae4:	75 0b                	jne    802af1 <__umoddi3+0x91>
  802ae6:	b8 01 00 00 00       	mov    $0x1,%eax
  802aeb:	31 d2                	xor    %edx,%edx
  802aed:	f7 f6                	div    %esi
  802aef:	89 c5                	mov    %eax,%ebp
  802af1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802af5:	31 d2                	xor    %edx,%edx
  802af7:	f7 f5                	div    %ebp
  802af9:	89 c8                	mov    %ecx,%eax
  802afb:	f7 f5                	div    %ebp
  802afd:	eb 9c                	jmp    802a9b <__umoddi3+0x3b>
  802aff:	90                   	nop
  802b00:	89 c8                	mov    %ecx,%eax
  802b02:	89 fa                	mov    %edi,%edx
  802b04:	83 c4 14             	add    $0x14,%esp
  802b07:	5e                   	pop    %esi
  802b08:	5f                   	pop    %edi
  802b09:	5d                   	pop    %ebp
  802b0a:	c3                   	ret    
  802b0b:	90                   	nop
  802b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b10:	8b 04 24             	mov    (%esp),%eax
  802b13:	be 20 00 00 00       	mov    $0x20,%esi
  802b18:	89 e9                	mov    %ebp,%ecx
  802b1a:	29 ee                	sub    %ebp,%esi
  802b1c:	d3 e2                	shl    %cl,%edx
  802b1e:	89 f1                	mov    %esi,%ecx
  802b20:	d3 e8                	shr    %cl,%eax
  802b22:	89 e9                	mov    %ebp,%ecx
  802b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b28:	8b 04 24             	mov    (%esp),%eax
  802b2b:	09 54 24 04          	or     %edx,0x4(%esp)
  802b2f:	89 fa                	mov    %edi,%edx
  802b31:	d3 e0                	shl    %cl,%eax
  802b33:	89 f1                	mov    %esi,%ecx
  802b35:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b39:	8b 44 24 10          	mov    0x10(%esp),%eax
  802b3d:	d3 ea                	shr    %cl,%edx
  802b3f:	89 e9                	mov    %ebp,%ecx
  802b41:	d3 e7                	shl    %cl,%edi
  802b43:	89 f1                	mov    %esi,%ecx
  802b45:	d3 e8                	shr    %cl,%eax
  802b47:	89 e9                	mov    %ebp,%ecx
  802b49:	09 f8                	or     %edi,%eax
  802b4b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802b4f:	f7 74 24 04          	divl   0x4(%esp)
  802b53:	d3 e7                	shl    %cl,%edi
  802b55:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b59:	89 d7                	mov    %edx,%edi
  802b5b:	f7 64 24 08          	mull   0x8(%esp)
  802b5f:	39 d7                	cmp    %edx,%edi
  802b61:	89 c1                	mov    %eax,%ecx
  802b63:	89 14 24             	mov    %edx,(%esp)
  802b66:	72 2c                	jb     802b94 <__umoddi3+0x134>
  802b68:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802b6c:	72 22                	jb     802b90 <__umoddi3+0x130>
  802b6e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802b72:	29 c8                	sub    %ecx,%eax
  802b74:	19 d7                	sbb    %edx,%edi
  802b76:	89 e9                	mov    %ebp,%ecx
  802b78:	89 fa                	mov    %edi,%edx
  802b7a:	d3 e8                	shr    %cl,%eax
  802b7c:	89 f1                	mov    %esi,%ecx
  802b7e:	d3 e2                	shl    %cl,%edx
  802b80:	89 e9                	mov    %ebp,%ecx
  802b82:	d3 ef                	shr    %cl,%edi
  802b84:	09 d0                	or     %edx,%eax
  802b86:	89 fa                	mov    %edi,%edx
  802b88:	83 c4 14             	add    $0x14,%esp
  802b8b:	5e                   	pop    %esi
  802b8c:	5f                   	pop    %edi
  802b8d:	5d                   	pop    %ebp
  802b8e:	c3                   	ret    
  802b8f:	90                   	nop
  802b90:	39 d7                	cmp    %edx,%edi
  802b92:	75 da                	jne    802b6e <__umoddi3+0x10e>
  802b94:	8b 14 24             	mov    (%esp),%edx
  802b97:	89 c1                	mov    %eax,%ecx
  802b99:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802b9d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802ba1:	eb cb                	jmp    802b6e <__umoddi3+0x10e>
  802ba3:	90                   	nop
  802ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ba8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802bac:	0f 82 0f ff ff ff    	jb     802ac1 <__umoddi3+0x61>
  802bb2:	e9 1a ff ff ff       	jmp    802ad1 <__umoddi3+0x71>
