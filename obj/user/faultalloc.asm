
obj/user/faultalloc.debug:     file format elf32-i386


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
  80002c:	e8 c3 00 00 00       	call   8000f4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 24             	sub    $0x24,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  80003a:	8b 45 08             	mov    0x8(%ebp),%eax
  80003d:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80003f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800043:	c7 04 24 a0 27 80 00 	movl   $0x8027a0,(%esp)
  80004a:	e8 ff 01 00 00       	call   80024e <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800056:	00 
  800057:	89 d8                	mov    %ebx,%eax
  800059:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800069:	e8 25 0c 00 00       	call   800c93 <sys_page_alloc>
  80006e:	85 c0                	test   %eax,%eax
  800070:	79 24                	jns    800096 <handler+0x63>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  800072:	89 44 24 10          	mov    %eax,0x10(%esp)
  800076:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80007a:	c7 44 24 08 c0 27 80 	movl   $0x8027c0,0x8(%esp)
  800081:	00 
  800082:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  800089:	00 
  80008a:	c7 04 24 aa 27 80 00 	movl   $0x8027aa,(%esp)
  800091:	e8 bf 00 00 00       	call   800155 <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800096:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009a:	c7 44 24 08 ec 27 80 	movl   $0x8027ec,0x8(%esp)
  8000a1:	00 
  8000a2:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000a9:	00 
  8000aa:	89 1c 24             	mov    %ebx,(%esp)
  8000ad:	e8 58 07 00 00       	call   80080a <snprintf>
}
  8000b2:	83 c4 24             	add    $0x24,%esp
  8000b5:	5b                   	pop    %ebx
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <umain>:

void
umain(int argc, char **argv)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  8000be:	c7 04 24 33 00 80 00 	movl   $0x800033,(%esp)
  8000c5:	e8 07 0f 00 00       	call   800fd1 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  8000ca:	c7 44 24 04 ef be ad 	movl   $0xdeadbeef,0x4(%esp)
  8000d1:	de 
  8000d2:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  8000d9:	e8 70 01 00 00       	call   80024e <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  8000de:	c7 44 24 04 fe bf fe 	movl   $0xcafebffe,0x4(%esp)
  8000e5:	ca 
  8000e6:	c7 04 24 bc 27 80 00 	movl   $0x8027bc,(%esp)
  8000ed:	e8 5c 01 00 00       	call   80024e <cprintf>
}
  8000f2:	c9                   	leave  
  8000f3:	c3                   	ret    

008000f4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	56                   	push   %esi
  8000f8:	53                   	push   %ebx
  8000f9:	83 ec 10             	sub    $0x10,%esp
  8000fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ff:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800102:	e8 4e 0b 00 00       	call   800c55 <sys_getenvid>
  800107:	25 ff 03 00 00       	and    $0x3ff,%eax
  80010c:	c1 e0 07             	shl    $0x7,%eax
  80010f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800114:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800119:	85 db                	test   %ebx,%ebx
  80011b:	7e 07                	jle    800124 <libmain+0x30>
		binaryname = argv[0];
  80011d:	8b 06                	mov    (%esi),%eax
  80011f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800124:	89 74 24 04          	mov    %esi,0x4(%esp)
  800128:	89 1c 24             	mov    %ebx,(%esp)
  80012b:	e8 88 ff ff ff       	call   8000b8 <umain>

	// exit gracefully
	exit();
  800130:	e8 07 00 00 00       	call   80013c <exit>
}
  800135:	83 c4 10             	add    $0x10,%esp
  800138:	5b                   	pop    %ebx
  800139:	5e                   	pop    %esi
  80013a:	5d                   	pop    %ebp
  80013b:	c3                   	ret    

0080013c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800142:	e8 13 11 00 00       	call   80125a <close_all>
	sys_env_destroy(0);
  800147:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014e:	e8 b0 0a 00 00       	call   800c03 <sys_env_destroy>
}
  800153:	c9                   	leave  
  800154:	c3                   	ret    

00800155 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	56                   	push   %esi
  800159:	53                   	push   %ebx
  80015a:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80015d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800160:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800166:	e8 ea 0a 00 00       	call   800c55 <sys_getenvid>
  80016b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80016e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800172:	8b 55 08             	mov    0x8(%ebp),%edx
  800175:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800179:	89 74 24 08          	mov    %esi,0x8(%esp)
  80017d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800181:	c7 04 24 18 28 80 00 	movl   $0x802818,(%esp)
  800188:	e8 c1 00 00 00       	call   80024e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80018d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800191:	8b 45 10             	mov    0x10(%ebp),%eax
  800194:	89 04 24             	mov    %eax,(%esp)
  800197:	e8 51 00 00 00       	call   8001ed <vcprintf>
	cprintf("\n");
  80019c:	c7 04 24 e4 2c 80 00 	movl   $0x802ce4,(%esp)
  8001a3:	e8 a6 00 00 00       	call   80024e <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001a8:	cc                   	int3   
  8001a9:	eb fd                	jmp    8001a8 <_panic+0x53>

008001ab <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	53                   	push   %ebx
  8001af:	83 ec 14             	sub    $0x14,%esp
  8001b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001b5:	8b 13                	mov    (%ebx),%edx
  8001b7:	8d 42 01             	lea    0x1(%edx),%eax
  8001ba:	89 03                	mov    %eax,(%ebx)
  8001bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001bf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001c3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c8:	75 19                	jne    8001e3 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001ca:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001d1:	00 
  8001d2:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d5:	89 04 24             	mov    %eax,(%esp)
  8001d8:	e8 e9 09 00 00       	call   800bc6 <sys_cputs>
		b->idx = 0;
  8001dd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001e3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001e7:	83 c4 14             	add    $0x14,%esp
  8001ea:	5b                   	pop    %ebx
  8001eb:	5d                   	pop    %ebp
  8001ec:	c3                   	ret    

008001ed <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001f6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001fd:	00 00 00 
	b.cnt = 0;
  800200:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800207:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80020a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800211:	8b 45 08             	mov    0x8(%ebp),%eax
  800214:	89 44 24 08          	mov    %eax,0x8(%esp)
  800218:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80021e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800222:	c7 04 24 ab 01 80 00 	movl   $0x8001ab,(%esp)
  800229:	e8 b0 01 00 00       	call   8003de <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80022e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800234:	89 44 24 04          	mov    %eax,0x4(%esp)
  800238:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80023e:	89 04 24             	mov    %eax,(%esp)
  800241:	e8 80 09 00 00       	call   800bc6 <sys_cputs>

	return b.cnt;
}
  800246:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80024c:	c9                   	leave  
  80024d:	c3                   	ret    

0080024e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800254:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800257:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025b:	8b 45 08             	mov    0x8(%ebp),%eax
  80025e:	89 04 24             	mov    %eax,(%esp)
  800261:	e8 87 ff ff ff       	call   8001ed <vcprintf>
	va_end(ap);

	return cnt;
}
  800266:	c9                   	leave  
  800267:	c3                   	ret    
  800268:	66 90                	xchg   %ax,%ax
  80026a:	66 90                	xchg   %ax,%ax
  80026c:	66 90                	xchg   %ax,%ax
  80026e:	66 90                	xchg   %ax,%ax

00800270 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	57                   	push   %edi
  800274:	56                   	push   %esi
  800275:	53                   	push   %ebx
  800276:	83 ec 3c             	sub    $0x3c,%esp
  800279:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80027c:	89 d7                	mov    %edx,%edi
  80027e:	8b 45 08             	mov    0x8(%ebp),%eax
  800281:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	89 c3                	mov    %eax,%ebx
  800289:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80028c:	8b 45 10             	mov    0x10(%ebp),%eax
  80028f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800292:	b9 00 00 00 00       	mov    $0x0,%ecx
  800297:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80029a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80029d:	39 d9                	cmp    %ebx,%ecx
  80029f:	72 05                	jb     8002a6 <printnum+0x36>
  8002a1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002a4:	77 69                	ja     80030f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002a6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002a9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002ad:	83 ee 01             	sub    $0x1,%esi
  8002b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002bc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002c0:	89 c3                	mov    %eax,%ebx
  8002c2:	89 d6                	mov    %edx,%esi
  8002c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ca:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002ce:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d5:	89 04 24             	mov    %eax,(%esp)
  8002d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002df:	e8 2c 22 00 00       	call   802510 <__udivdi3>
  8002e4:	89 d9                	mov    %ebx,%ecx
  8002e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002ea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002ee:	89 04 24             	mov    %eax,(%esp)
  8002f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002f5:	89 fa                	mov    %edi,%edx
  8002f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002fa:	e8 71 ff ff ff       	call   800270 <printnum>
  8002ff:	eb 1b                	jmp    80031c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800301:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800305:	8b 45 18             	mov    0x18(%ebp),%eax
  800308:	89 04 24             	mov    %eax,(%esp)
  80030b:	ff d3                	call   *%ebx
  80030d:	eb 03                	jmp    800312 <printnum+0xa2>
  80030f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800312:	83 ee 01             	sub    $0x1,%esi
  800315:	85 f6                	test   %esi,%esi
  800317:	7f e8                	jg     800301 <printnum+0x91>
  800319:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80031c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800320:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800324:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800327:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80032a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80032e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800335:	89 04 24             	mov    %eax,(%esp)
  800338:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80033b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033f:	e8 fc 22 00 00       	call   802640 <__umoddi3>
  800344:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800348:	0f be 80 3b 28 80 00 	movsbl 0x80283b(%eax),%eax
  80034f:	89 04 24             	mov    %eax,(%esp)
  800352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800355:	ff d0                	call   *%eax
}
  800357:	83 c4 3c             	add    $0x3c,%esp
  80035a:	5b                   	pop    %ebx
  80035b:	5e                   	pop    %esi
  80035c:	5f                   	pop    %edi
  80035d:	5d                   	pop    %ebp
  80035e:	c3                   	ret    

0080035f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800362:	83 fa 01             	cmp    $0x1,%edx
  800365:	7e 0e                	jle    800375 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800367:	8b 10                	mov    (%eax),%edx
  800369:	8d 4a 08             	lea    0x8(%edx),%ecx
  80036c:	89 08                	mov    %ecx,(%eax)
  80036e:	8b 02                	mov    (%edx),%eax
  800370:	8b 52 04             	mov    0x4(%edx),%edx
  800373:	eb 22                	jmp    800397 <getuint+0x38>
	else if (lflag)
  800375:	85 d2                	test   %edx,%edx
  800377:	74 10                	je     800389 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800379:	8b 10                	mov    (%eax),%edx
  80037b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80037e:	89 08                	mov    %ecx,(%eax)
  800380:	8b 02                	mov    (%edx),%eax
  800382:	ba 00 00 00 00       	mov    $0x0,%edx
  800387:	eb 0e                	jmp    800397 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800389:	8b 10                	mov    (%eax),%edx
  80038b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80038e:	89 08                	mov    %ecx,(%eax)
  800390:	8b 02                	mov    (%edx),%eax
  800392:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800397:	5d                   	pop    %ebp
  800398:	c3                   	ret    

00800399 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80039f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003a3:	8b 10                	mov    (%eax),%edx
  8003a5:	3b 50 04             	cmp    0x4(%eax),%edx
  8003a8:	73 0a                	jae    8003b4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003ad:	89 08                	mov    %ecx,(%eax)
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	88 02                	mov    %al,(%edx)
}
  8003b4:	5d                   	pop    %ebp
  8003b5:	c3                   	ret    

008003b6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003bc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d4:	89 04 24             	mov    %eax,(%esp)
  8003d7:	e8 02 00 00 00       	call   8003de <vprintfmt>
	va_end(ap);
}
  8003dc:	c9                   	leave  
  8003dd:	c3                   	ret    

008003de <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003de:	55                   	push   %ebp
  8003df:	89 e5                	mov    %esp,%ebp
  8003e1:	57                   	push   %edi
  8003e2:	56                   	push   %esi
  8003e3:	53                   	push   %ebx
  8003e4:	83 ec 3c             	sub    $0x3c,%esp
  8003e7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003ed:	eb 14                	jmp    800403 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003ef:	85 c0                	test   %eax,%eax
  8003f1:	0f 84 b3 03 00 00    	je     8007aa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8003f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003fb:	89 04 24             	mov    %eax,(%esp)
  8003fe:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800401:	89 f3                	mov    %esi,%ebx
  800403:	8d 73 01             	lea    0x1(%ebx),%esi
  800406:	0f b6 03             	movzbl (%ebx),%eax
  800409:	83 f8 25             	cmp    $0x25,%eax
  80040c:	75 e1                	jne    8003ef <vprintfmt+0x11>
  80040e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800412:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800419:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800420:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800427:	ba 00 00 00 00       	mov    $0x0,%edx
  80042c:	eb 1d                	jmp    80044b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800430:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800434:	eb 15                	jmp    80044b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800436:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800438:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80043c:	eb 0d                	jmp    80044b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80043e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800441:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800444:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80044e:	0f b6 0e             	movzbl (%esi),%ecx
  800451:	0f b6 c1             	movzbl %cl,%eax
  800454:	83 e9 23             	sub    $0x23,%ecx
  800457:	80 f9 55             	cmp    $0x55,%cl
  80045a:	0f 87 2a 03 00 00    	ja     80078a <vprintfmt+0x3ac>
  800460:	0f b6 c9             	movzbl %cl,%ecx
  800463:	ff 24 8d 80 29 80 00 	jmp    *0x802980(,%ecx,4)
  80046a:	89 de                	mov    %ebx,%esi
  80046c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800471:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800474:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800478:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80047b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80047e:	83 fb 09             	cmp    $0x9,%ebx
  800481:	77 36                	ja     8004b9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800483:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800486:	eb e9                	jmp    800471 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800488:	8b 45 14             	mov    0x14(%ebp),%eax
  80048b:	8d 48 04             	lea    0x4(%eax),%ecx
  80048e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800491:	8b 00                	mov    (%eax),%eax
  800493:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800496:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800498:	eb 22                	jmp    8004bc <vprintfmt+0xde>
  80049a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80049d:	85 c9                	test   %ecx,%ecx
  80049f:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a4:	0f 49 c1             	cmovns %ecx,%eax
  8004a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004aa:	89 de                	mov    %ebx,%esi
  8004ac:	eb 9d                	jmp    80044b <vprintfmt+0x6d>
  8004ae:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004b0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8004b7:	eb 92                	jmp    80044b <vprintfmt+0x6d>
  8004b9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8004bc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004c0:	79 89                	jns    80044b <vprintfmt+0x6d>
  8004c2:	e9 77 ff ff ff       	jmp    80043e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004c7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ca:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004cc:	e9 7a ff ff ff       	jmp    80044b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d4:	8d 50 04             	lea    0x4(%eax),%edx
  8004d7:	89 55 14             	mov    %edx,0x14(%ebp)
  8004da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004de:	8b 00                	mov    (%eax),%eax
  8004e0:	89 04 24             	mov    %eax,(%esp)
  8004e3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004e6:	e9 18 ff ff ff       	jmp    800403 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ee:	8d 50 04             	lea    0x4(%eax),%edx
  8004f1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f4:	8b 00                	mov    (%eax),%eax
  8004f6:	99                   	cltd   
  8004f7:	31 d0                	xor    %edx,%eax
  8004f9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004fb:	83 f8 11             	cmp    $0x11,%eax
  8004fe:	7f 0b                	jg     80050b <vprintfmt+0x12d>
  800500:	8b 14 85 e0 2a 80 00 	mov    0x802ae0(,%eax,4),%edx
  800507:	85 d2                	test   %edx,%edx
  800509:	75 20                	jne    80052b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80050b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80050f:	c7 44 24 08 53 28 80 	movl   $0x802853,0x8(%esp)
  800516:	00 
  800517:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80051b:	8b 45 08             	mov    0x8(%ebp),%eax
  80051e:	89 04 24             	mov    %eax,(%esp)
  800521:	e8 90 fe ff ff       	call   8003b6 <printfmt>
  800526:	e9 d8 fe ff ff       	jmp    800403 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80052b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80052f:	c7 44 24 08 79 2c 80 	movl   $0x802c79,0x8(%esp)
  800536:	00 
  800537:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	89 04 24             	mov    %eax,(%esp)
  800541:	e8 70 fe ff ff       	call   8003b6 <printfmt>
  800546:	e9 b8 fe ff ff       	jmp    800403 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80054e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800551:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	8d 50 04             	lea    0x4(%eax),%edx
  80055a:	89 55 14             	mov    %edx,0x14(%ebp)
  80055d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80055f:	85 f6                	test   %esi,%esi
  800561:	b8 4c 28 80 00       	mov    $0x80284c,%eax
  800566:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800569:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80056d:	0f 84 97 00 00 00    	je     80060a <vprintfmt+0x22c>
  800573:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800577:	0f 8e 9b 00 00 00    	jle    800618 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80057d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800581:	89 34 24             	mov    %esi,(%esp)
  800584:	e8 cf 02 00 00       	call   800858 <strnlen>
  800589:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80058c:	29 c2                	sub    %eax,%edx
  80058e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800591:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800595:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800598:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80059b:	8b 75 08             	mov    0x8(%ebp),%esi
  80059e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005a1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a3:	eb 0f                	jmp    8005b4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8005a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ac:	89 04 24             	mov    %eax,(%esp)
  8005af:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b1:	83 eb 01             	sub    $0x1,%ebx
  8005b4:	85 db                	test   %ebx,%ebx
  8005b6:	7f ed                	jg     8005a5 <vprintfmt+0x1c7>
  8005b8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005bb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005be:	85 d2                	test   %edx,%edx
  8005c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005c5:	0f 49 c2             	cmovns %edx,%eax
  8005c8:	29 c2                	sub    %eax,%edx
  8005ca:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005cd:	89 d7                	mov    %edx,%edi
  8005cf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005d2:	eb 50                	jmp    800624 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005d8:	74 1e                	je     8005f8 <vprintfmt+0x21a>
  8005da:	0f be d2             	movsbl %dl,%edx
  8005dd:	83 ea 20             	sub    $0x20,%edx
  8005e0:	83 fa 5e             	cmp    $0x5e,%edx
  8005e3:	76 13                	jbe    8005f8 <vprintfmt+0x21a>
					putch('?', putdat);
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ec:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005f3:	ff 55 08             	call   *0x8(%ebp)
  8005f6:	eb 0d                	jmp    800605 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8005f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005fb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005ff:	89 04 24             	mov    %eax,(%esp)
  800602:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800605:	83 ef 01             	sub    $0x1,%edi
  800608:	eb 1a                	jmp    800624 <vprintfmt+0x246>
  80060a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80060d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800610:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800613:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800616:	eb 0c                	jmp    800624 <vprintfmt+0x246>
  800618:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80061b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80061e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800621:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800624:	83 c6 01             	add    $0x1,%esi
  800627:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80062b:	0f be c2             	movsbl %dl,%eax
  80062e:	85 c0                	test   %eax,%eax
  800630:	74 27                	je     800659 <vprintfmt+0x27b>
  800632:	85 db                	test   %ebx,%ebx
  800634:	78 9e                	js     8005d4 <vprintfmt+0x1f6>
  800636:	83 eb 01             	sub    $0x1,%ebx
  800639:	79 99                	jns    8005d4 <vprintfmt+0x1f6>
  80063b:	89 f8                	mov    %edi,%eax
  80063d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800640:	8b 75 08             	mov    0x8(%ebp),%esi
  800643:	89 c3                	mov    %eax,%ebx
  800645:	eb 1a                	jmp    800661 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800647:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80064b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800652:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800654:	83 eb 01             	sub    $0x1,%ebx
  800657:	eb 08                	jmp    800661 <vprintfmt+0x283>
  800659:	89 fb                	mov    %edi,%ebx
  80065b:	8b 75 08             	mov    0x8(%ebp),%esi
  80065e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800661:	85 db                	test   %ebx,%ebx
  800663:	7f e2                	jg     800647 <vprintfmt+0x269>
  800665:	89 75 08             	mov    %esi,0x8(%ebp)
  800668:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80066b:	e9 93 fd ff ff       	jmp    800403 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800670:	83 fa 01             	cmp    $0x1,%edx
  800673:	7e 16                	jle    80068b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8d 50 08             	lea    0x8(%eax),%edx
  80067b:	89 55 14             	mov    %edx,0x14(%ebp)
  80067e:	8b 50 04             	mov    0x4(%eax),%edx
  800681:	8b 00                	mov    (%eax),%eax
  800683:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800686:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800689:	eb 32                	jmp    8006bd <vprintfmt+0x2df>
	else if (lflag)
  80068b:	85 d2                	test   %edx,%edx
  80068d:	74 18                	je     8006a7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8d 50 04             	lea    0x4(%eax),%edx
  800695:	89 55 14             	mov    %edx,0x14(%ebp)
  800698:	8b 30                	mov    (%eax),%esi
  80069a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80069d:	89 f0                	mov    %esi,%eax
  80069f:	c1 f8 1f             	sar    $0x1f,%eax
  8006a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006a5:	eb 16                	jmp    8006bd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8d 50 04             	lea    0x4(%eax),%edx
  8006ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b0:	8b 30                	mov    (%eax),%esi
  8006b2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006b5:	89 f0                	mov    %esi,%eax
  8006b7:	c1 f8 1f             	sar    $0x1f,%eax
  8006ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006cc:	0f 89 80 00 00 00    	jns    800752 <vprintfmt+0x374>
				putch('-', putdat);
  8006d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006dd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006e6:	f7 d8                	neg    %eax
  8006e8:	83 d2 00             	adc    $0x0,%edx
  8006eb:	f7 da                	neg    %edx
			}
			base = 10;
  8006ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006f2:	eb 5e                	jmp    800752 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f7:	e8 63 fc ff ff       	call   80035f <getuint>
			base = 10;
  8006fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800701:	eb 4f                	jmp    800752 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800703:	8d 45 14             	lea    0x14(%ebp),%eax
  800706:	e8 54 fc ff ff       	call   80035f <getuint>
			base = 8;
  80070b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800710:	eb 40                	jmp    800752 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800712:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800716:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80071d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800720:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800724:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80072b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80072e:	8b 45 14             	mov    0x14(%ebp),%eax
  800731:	8d 50 04             	lea    0x4(%eax),%edx
  800734:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800737:	8b 00                	mov    (%eax),%eax
  800739:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80073e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800743:	eb 0d                	jmp    800752 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800745:	8d 45 14             	lea    0x14(%ebp),%eax
  800748:	e8 12 fc ff ff       	call   80035f <getuint>
			base = 16;
  80074d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800752:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800756:	89 74 24 10          	mov    %esi,0x10(%esp)
  80075a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80075d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800761:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800765:	89 04 24             	mov    %eax,(%esp)
  800768:	89 54 24 04          	mov    %edx,0x4(%esp)
  80076c:	89 fa                	mov    %edi,%edx
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	e8 fa fa ff ff       	call   800270 <printnum>
			break;
  800776:	e9 88 fc ff ff       	jmp    800403 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80077b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077f:	89 04 24             	mov    %eax,(%esp)
  800782:	ff 55 08             	call   *0x8(%ebp)
			break;
  800785:	e9 79 fc ff ff       	jmp    800403 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80078a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80078e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800795:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800798:	89 f3                	mov    %esi,%ebx
  80079a:	eb 03                	jmp    80079f <vprintfmt+0x3c1>
  80079c:	83 eb 01             	sub    $0x1,%ebx
  80079f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007a3:	75 f7                	jne    80079c <vprintfmt+0x3be>
  8007a5:	e9 59 fc ff ff       	jmp    800403 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007aa:	83 c4 3c             	add    $0x3c,%esp
  8007ad:	5b                   	pop    %ebx
  8007ae:	5e                   	pop    %esi
  8007af:	5f                   	pop    %edi
  8007b0:	5d                   	pop    %ebp
  8007b1:	c3                   	ret    

008007b2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007b2:	55                   	push   %ebp
  8007b3:	89 e5                	mov    %esp,%ebp
  8007b5:	83 ec 28             	sub    $0x28,%esp
  8007b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007c1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007c5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007cf:	85 c0                	test   %eax,%eax
  8007d1:	74 30                	je     800803 <vsnprintf+0x51>
  8007d3:	85 d2                	test   %edx,%edx
  8007d5:	7e 2c                	jle    800803 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007de:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ec:	c7 04 24 99 03 80 00 	movl   $0x800399,(%esp)
  8007f3:	e8 e6 fb ff ff       	call   8003de <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007fb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800801:	eb 05                	jmp    800808 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800803:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800808:	c9                   	leave  
  800809:	c3                   	ret    

0080080a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800810:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800813:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80081e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800821:	89 44 24 04          	mov    %eax,0x4(%esp)
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	89 04 24             	mov    %eax,(%esp)
  80082b:	e8 82 ff ff ff       	call   8007b2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800830:	c9                   	leave  
  800831:	c3                   	ret    
  800832:	66 90                	xchg   %ax,%ax
  800834:	66 90                	xchg   %ax,%ax
  800836:	66 90                	xchg   %ax,%ax
  800838:	66 90                	xchg   %ax,%ax
  80083a:	66 90                	xchg   %ax,%ax
  80083c:	66 90                	xchg   %ax,%ax
  80083e:	66 90                	xchg   %ax,%ax

00800840 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800846:	b8 00 00 00 00       	mov    $0x0,%eax
  80084b:	eb 03                	jmp    800850 <strlen+0x10>
		n++;
  80084d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800850:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800854:	75 f7                	jne    80084d <strlen+0xd>
		n++;
	return n;
}
  800856:	5d                   	pop    %ebp
  800857:	c3                   	ret    

00800858 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800858:	55                   	push   %ebp
  800859:	89 e5                	mov    %esp,%ebp
  80085b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80085e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800861:	b8 00 00 00 00       	mov    $0x0,%eax
  800866:	eb 03                	jmp    80086b <strnlen+0x13>
		n++;
  800868:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80086b:	39 d0                	cmp    %edx,%eax
  80086d:	74 06                	je     800875 <strnlen+0x1d>
  80086f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800873:	75 f3                	jne    800868 <strnlen+0x10>
		n++;
	return n;
}
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	53                   	push   %ebx
  80087b:	8b 45 08             	mov    0x8(%ebp),%eax
  80087e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800881:	89 c2                	mov    %eax,%edx
  800883:	83 c2 01             	add    $0x1,%edx
  800886:	83 c1 01             	add    $0x1,%ecx
  800889:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80088d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800890:	84 db                	test   %bl,%bl
  800892:	75 ef                	jne    800883 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800894:	5b                   	pop    %ebx
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	53                   	push   %ebx
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008a1:	89 1c 24             	mov    %ebx,(%esp)
  8008a4:	e8 97 ff ff ff       	call   800840 <strlen>
	strcpy(dst + len, src);
  8008a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008b0:	01 d8                	add    %ebx,%eax
  8008b2:	89 04 24             	mov    %eax,(%esp)
  8008b5:	e8 bd ff ff ff       	call   800877 <strcpy>
	return dst;
}
  8008ba:	89 d8                	mov    %ebx,%eax
  8008bc:	83 c4 08             	add    $0x8,%esp
  8008bf:	5b                   	pop    %ebx
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    

008008c2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	56                   	push   %esi
  8008c6:	53                   	push   %ebx
  8008c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008cd:	89 f3                	mov    %esi,%ebx
  8008cf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d2:	89 f2                	mov    %esi,%edx
  8008d4:	eb 0f                	jmp    8008e5 <strncpy+0x23>
		*dst++ = *src;
  8008d6:	83 c2 01             	add    $0x1,%edx
  8008d9:	0f b6 01             	movzbl (%ecx),%eax
  8008dc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008df:	80 39 01             	cmpb   $0x1,(%ecx)
  8008e2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008e5:	39 da                	cmp    %ebx,%edx
  8008e7:	75 ed                	jne    8008d6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008e9:	89 f0                	mov    %esi,%eax
  8008eb:	5b                   	pop    %ebx
  8008ec:	5e                   	pop    %esi
  8008ed:	5d                   	pop    %ebp
  8008ee:	c3                   	ret    

008008ef <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	56                   	push   %esi
  8008f3:	53                   	push   %ebx
  8008f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008fd:	89 f0                	mov    %esi,%eax
  8008ff:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800903:	85 c9                	test   %ecx,%ecx
  800905:	75 0b                	jne    800912 <strlcpy+0x23>
  800907:	eb 1d                	jmp    800926 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800909:	83 c0 01             	add    $0x1,%eax
  80090c:	83 c2 01             	add    $0x1,%edx
  80090f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800912:	39 d8                	cmp    %ebx,%eax
  800914:	74 0b                	je     800921 <strlcpy+0x32>
  800916:	0f b6 0a             	movzbl (%edx),%ecx
  800919:	84 c9                	test   %cl,%cl
  80091b:	75 ec                	jne    800909 <strlcpy+0x1a>
  80091d:	89 c2                	mov    %eax,%edx
  80091f:	eb 02                	jmp    800923 <strlcpy+0x34>
  800921:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800923:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800926:	29 f0                	sub    %esi,%eax
}
  800928:	5b                   	pop    %ebx
  800929:	5e                   	pop    %esi
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800932:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800935:	eb 06                	jmp    80093d <strcmp+0x11>
		p++, q++;
  800937:	83 c1 01             	add    $0x1,%ecx
  80093a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80093d:	0f b6 01             	movzbl (%ecx),%eax
  800940:	84 c0                	test   %al,%al
  800942:	74 04                	je     800948 <strcmp+0x1c>
  800944:	3a 02                	cmp    (%edx),%al
  800946:	74 ef                	je     800937 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800948:	0f b6 c0             	movzbl %al,%eax
  80094b:	0f b6 12             	movzbl (%edx),%edx
  80094e:	29 d0                	sub    %edx,%eax
}
  800950:	5d                   	pop    %ebp
  800951:	c3                   	ret    

00800952 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	53                   	push   %ebx
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095c:	89 c3                	mov    %eax,%ebx
  80095e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800961:	eb 06                	jmp    800969 <strncmp+0x17>
		n--, p++, q++;
  800963:	83 c0 01             	add    $0x1,%eax
  800966:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800969:	39 d8                	cmp    %ebx,%eax
  80096b:	74 15                	je     800982 <strncmp+0x30>
  80096d:	0f b6 08             	movzbl (%eax),%ecx
  800970:	84 c9                	test   %cl,%cl
  800972:	74 04                	je     800978 <strncmp+0x26>
  800974:	3a 0a                	cmp    (%edx),%cl
  800976:	74 eb                	je     800963 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800978:	0f b6 00             	movzbl (%eax),%eax
  80097b:	0f b6 12             	movzbl (%edx),%edx
  80097e:	29 d0                	sub    %edx,%eax
  800980:	eb 05                	jmp    800987 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800982:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800987:	5b                   	pop    %ebx
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800994:	eb 07                	jmp    80099d <strchr+0x13>
		if (*s == c)
  800996:	38 ca                	cmp    %cl,%dl
  800998:	74 0f                	je     8009a9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80099a:	83 c0 01             	add    $0x1,%eax
  80099d:	0f b6 10             	movzbl (%eax),%edx
  8009a0:	84 d2                	test   %dl,%dl
  8009a2:	75 f2                	jne    800996 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b5:	eb 07                	jmp    8009be <strfind+0x13>
		if (*s == c)
  8009b7:	38 ca                	cmp    %cl,%dl
  8009b9:	74 0a                	je     8009c5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009bb:	83 c0 01             	add    $0x1,%eax
  8009be:	0f b6 10             	movzbl (%eax),%edx
  8009c1:	84 d2                	test   %dl,%dl
  8009c3:	75 f2                	jne    8009b7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	57                   	push   %edi
  8009cb:	56                   	push   %esi
  8009cc:	53                   	push   %ebx
  8009cd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009d3:	85 c9                	test   %ecx,%ecx
  8009d5:	74 36                	je     800a0d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009dd:	75 28                	jne    800a07 <memset+0x40>
  8009df:	f6 c1 03             	test   $0x3,%cl
  8009e2:	75 23                	jne    800a07 <memset+0x40>
		c &= 0xFF;
  8009e4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009e8:	89 d3                	mov    %edx,%ebx
  8009ea:	c1 e3 08             	shl    $0x8,%ebx
  8009ed:	89 d6                	mov    %edx,%esi
  8009ef:	c1 e6 18             	shl    $0x18,%esi
  8009f2:	89 d0                	mov    %edx,%eax
  8009f4:	c1 e0 10             	shl    $0x10,%eax
  8009f7:	09 f0                	or     %esi,%eax
  8009f9:	09 c2                	or     %eax,%edx
  8009fb:	89 d0                	mov    %edx,%eax
  8009fd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ff:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a02:	fc                   	cld    
  800a03:	f3 ab                	rep stos %eax,%es:(%edi)
  800a05:	eb 06                	jmp    800a0d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0a:	fc                   	cld    
  800a0b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a0d:	89 f8                	mov    %edi,%eax
  800a0f:	5b                   	pop    %ebx
  800a10:	5e                   	pop    %esi
  800a11:	5f                   	pop    %edi
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	57                   	push   %edi
  800a18:	56                   	push   %esi
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a22:	39 c6                	cmp    %eax,%esi
  800a24:	73 35                	jae    800a5b <memmove+0x47>
  800a26:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a29:	39 d0                	cmp    %edx,%eax
  800a2b:	73 2e                	jae    800a5b <memmove+0x47>
		s += n;
		d += n;
  800a2d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a30:	89 d6                	mov    %edx,%esi
  800a32:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a34:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a3a:	75 13                	jne    800a4f <memmove+0x3b>
  800a3c:	f6 c1 03             	test   $0x3,%cl
  800a3f:	75 0e                	jne    800a4f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a41:	83 ef 04             	sub    $0x4,%edi
  800a44:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a47:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a4a:	fd                   	std    
  800a4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a4d:	eb 09                	jmp    800a58 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a4f:	83 ef 01             	sub    $0x1,%edi
  800a52:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a55:	fd                   	std    
  800a56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a58:	fc                   	cld    
  800a59:	eb 1d                	jmp    800a78 <memmove+0x64>
  800a5b:	89 f2                	mov    %esi,%edx
  800a5d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a5f:	f6 c2 03             	test   $0x3,%dl
  800a62:	75 0f                	jne    800a73 <memmove+0x5f>
  800a64:	f6 c1 03             	test   $0x3,%cl
  800a67:	75 0a                	jne    800a73 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a69:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a6c:	89 c7                	mov    %eax,%edi
  800a6e:	fc                   	cld    
  800a6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a71:	eb 05                	jmp    800a78 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a73:	89 c7                	mov    %eax,%edi
  800a75:	fc                   	cld    
  800a76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a78:	5e                   	pop    %esi
  800a79:	5f                   	pop    %edi
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a82:	8b 45 10             	mov    0x10(%ebp),%eax
  800a85:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	89 04 24             	mov    %eax,(%esp)
  800a96:	e8 79 ff ff ff       	call   800a14 <memmove>
}
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	56                   	push   %esi
  800aa1:	53                   	push   %ebx
  800aa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800aa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa8:	89 d6                	mov    %edx,%esi
  800aaa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aad:	eb 1a                	jmp    800ac9 <memcmp+0x2c>
		if (*s1 != *s2)
  800aaf:	0f b6 02             	movzbl (%edx),%eax
  800ab2:	0f b6 19             	movzbl (%ecx),%ebx
  800ab5:	38 d8                	cmp    %bl,%al
  800ab7:	74 0a                	je     800ac3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ab9:	0f b6 c0             	movzbl %al,%eax
  800abc:	0f b6 db             	movzbl %bl,%ebx
  800abf:	29 d8                	sub    %ebx,%eax
  800ac1:	eb 0f                	jmp    800ad2 <memcmp+0x35>
		s1++, s2++;
  800ac3:	83 c2 01             	add    $0x1,%edx
  800ac6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ac9:	39 f2                	cmp    %esi,%edx
  800acb:	75 e2                	jne    800aaf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800acd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  800adc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800adf:	89 c2                	mov    %eax,%edx
  800ae1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ae4:	eb 07                	jmp    800aed <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ae6:	38 08                	cmp    %cl,(%eax)
  800ae8:	74 07                	je     800af1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800aea:	83 c0 01             	add    $0x1,%eax
  800aed:	39 d0                	cmp    %edx,%eax
  800aef:	72 f5                	jb     800ae6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    

00800af3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	57                   	push   %edi
  800af7:	56                   	push   %esi
  800af8:	53                   	push   %ebx
  800af9:	8b 55 08             	mov    0x8(%ebp),%edx
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aff:	eb 03                	jmp    800b04 <strtol+0x11>
		s++;
  800b01:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b04:	0f b6 0a             	movzbl (%edx),%ecx
  800b07:	80 f9 09             	cmp    $0x9,%cl
  800b0a:	74 f5                	je     800b01 <strtol+0xe>
  800b0c:	80 f9 20             	cmp    $0x20,%cl
  800b0f:	74 f0                	je     800b01 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b11:	80 f9 2b             	cmp    $0x2b,%cl
  800b14:	75 0a                	jne    800b20 <strtol+0x2d>
		s++;
  800b16:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b19:	bf 00 00 00 00       	mov    $0x0,%edi
  800b1e:	eb 11                	jmp    800b31 <strtol+0x3e>
  800b20:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b25:	80 f9 2d             	cmp    $0x2d,%cl
  800b28:	75 07                	jne    800b31 <strtol+0x3e>
		s++, neg = 1;
  800b2a:	8d 52 01             	lea    0x1(%edx),%edx
  800b2d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b31:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b36:	75 15                	jne    800b4d <strtol+0x5a>
  800b38:	80 3a 30             	cmpb   $0x30,(%edx)
  800b3b:	75 10                	jne    800b4d <strtol+0x5a>
  800b3d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b41:	75 0a                	jne    800b4d <strtol+0x5a>
		s += 2, base = 16;
  800b43:	83 c2 02             	add    $0x2,%edx
  800b46:	b8 10 00 00 00       	mov    $0x10,%eax
  800b4b:	eb 10                	jmp    800b5d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b4d:	85 c0                	test   %eax,%eax
  800b4f:	75 0c                	jne    800b5d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b51:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b53:	80 3a 30             	cmpb   $0x30,(%edx)
  800b56:	75 05                	jne    800b5d <strtol+0x6a>
		s++, base = 8;
  800b58:	83 c2 01             	add    $0x1,%edx
  800b5b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b62:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b65:	0f b6 0a             	movzbl (%edx),%ecx
  800b68:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b6b:	89 f0                	mov    %esi,%eax
  800b6d:	3c 09                	cmp    $0x9,%al
  800b6f:	77 08                	ja     800b79 <strtol+0x86>
			dig = *s - '0';
  800b71:	0f be c9             	movsbl %cl,%ecx
  800b74:	83 e9 30             	sub    $0x30,%ecx
  800b77:	eb 20                	jmp    800b99 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b79:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b7c:	89 f0                	mov    %esi,%eax
  800b7e:	3c 19                	cmp    $0x19,%al
  800b80:	77 08                	ja     800b8a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b82:	0f be c9             	movsbl %cl,%ecx
  800b85:	83 e9 57             	sub    $0x57,%ecx
  800b88:	eb 0f                	jmp    800b99 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b8a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b8d:	89 f0                	mov    %esi,%eax
  800b8f:	3c 19                	cmp    $0x19,%al
  800b91:	77 16                	ja     800ba9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b93:	0f be c9             	movsbl %cl,%ecx
  800b96:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b99:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b9c:	7d 0f                	jge    800bad <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b9e:	83 c2 01             	add    $0x1,%edx
  800ba1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ba5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ba7:	eb bc                	jmp    800b65 <strtol+0x72>
  800ba9:	89 d8                	mov    %ebx,%eax
  800bab:	eb 02                	jmp    800baf <strtol+0xbc>
  800bad:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800baf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb3:	74 05                	je     800bba <strtol+0xc7>
		*endptr = (char *) s;
  800bb5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bb8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bba:	f7 d8                	neg    %eax
  800bbc:	85 ff                	test   %edi,%edi
  800bbe:	0f 44 c3             	cmove  %ebx,%eax
}
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	57                   	push   %edi
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bcc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd7:	89 c3                	mov    %eax,%ebx
  800bd9:	89 c7                	mov    %eax,%edi
  800bdb:	89 c6                	mov    %eax,%esi
  800bdd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5f                   	pop    %edi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <sys_cgetc>:

int
sys_cgetc(void)
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
  800bef:	b8 01 00 00 00       	mov    $0x1,%eax
  800bf4:	89 d1                	mov    %edx,%ecx
  800bf6:	89 d3                	mov    %edx,%ebx
  800bf8:	89 d7                	mov    %edx,%edi
  800bfa:	89 d6                	mov    %edx,%esi
  800bfc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bfe:	5b                   	pop    %ebx
  800bff:	5e                   	pop    %esi
  800c00:	5f                   	pop    %edi
  800c01:	5d                   	pop    %ebp
  800c02:	c3                   	ret    

00800c03 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800c0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c11:	b8 03 00 00 00       	mov    $0x3,%eax
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	89 cb                	mov    %ecx,%ebx
  800c1b:	89 cf                	mov    %ecx,%edi
  800c1d:	89 ce                	mov    %ecx,%esi
  800c1f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c21:	85 c0                	test   %eax,%eax
  800c23:	7e 28                	jle    800c4d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c25:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c29:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c30:	00 
  800c31:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800c38:	00 
  800c39:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c40:	00 
  800c41:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800c48:	e8 08 f5 ff ff       	call   800155 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c4d:	83 c4 2c             	add    $0x2c,%esp
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5f                   	pop    %edi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	57                   	push   %edi
  800c59:	56                   	push   %esi
  800c5a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c60:	b8 02 00 00 00       	mov    $0x2,%eax
  800c65:	89 d1                	mov    %edx,%ecx
  800c67:	89 d3                	mov    %edx,%ebx
  800c69:	89 d7                	mov    %edx,%edi
  800c6b:	89 d6                	mov    %edx,%esi
  800c6d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c6f:	5b                   	pop    %ebx
  800c70:	5e                   	pop    %esi
  800c71:	5f                   	pop    %edi
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <sys_yield>:

void
sys_yield(void)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	57                   	push   %edi
  800c78:	56                   	push   %esi
  800c79:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c84:	89 d1                	mov    %edx,%ecx
  800c86:	89 d3                	mov    %edx,%ebx
  800c88:	89 d7                	mov    %edx,%edi
  800c8a:	89 d6                	mov    %edx,%esi
  800c8c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c8e:	5b                   	pop    %ebx
  800c8f:	5e                   	pop    %esi
  800c90:	5f                   	pop    %edi
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	57                   	push   %edi
  800c97:	56                   	push   %esi
  800c98:	53                   	push   %ebx
  800c99:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9c:	be 00 00 00 00       	mov    $0x0,%esi
  800ca1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ca6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800caf:	89 f7                	mov    %esi,%edi
  800cb1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cb3:	85 c0                	test   %eax,%eax
  800cb5:	7e 28                	jle    800cdf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cbb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cc2:	00 
  800cc3:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800cca:	00 
  800ccb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cd2:	00 
  800cd3:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800cda:	e8 76 f4 ff ff       	call   800155 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cdf:	83 c4 2c             	add    $0x2c,%esp
  800ce2:	5b                   	pop    %ebx
  800ce3:	5e                   	pop    %esi
  800ce4:	5f                   	pop    %edi
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	57                   	push   %edi
  800ceb:	56                   	push   %esi
  800cec:	53                   	push   %ebx
  800ced:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf0:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cfe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d01:	8b 75 18             	mov    0x18(%ebp),%esi
  800d04:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d06:	85 c0                	test   %eax,%eax
  800d08:	7e 28                	jle    800d32 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d0e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d15:	00 
  800d16:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800d1d:	00 
  800d1e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d25:	00 
  800d26:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800d2d:	e8 23 f4 ff ff       	call   800155 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d32:	83 c4 2c             	add    $0x2c,%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    

00800d3a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	57                   	push   %edi
  800d3e:	56                   	push   %esi
  800d3f:	53                   	push   %ebx
  800d40:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d48:	b8 06 00 00 00       	mov    $0x6,%eax
  800d4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d50:	8b 55 08             	mov    0x8(%ebp),%edx
  800d53:	89 df                	mov    %ebx,%edi
  800d55:	89 de                	mov    %ebx,%esi
  800d57:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d59:	85 c0                	test   %eax,%eax
  800d5b:	7e 28                	jle    800d85 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d61:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d68:	00 
  800d69:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800d70:	00 
  800d71:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d78:	00 
  800d79:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800d80:	e8 d0 f3 ff ff       	call   800155 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d85:	83 c4 2c             	add    $0x2c,%esp
  800d88:	5b                   	pop    %ebx
  800d89:	5e                   	pop    %esi
  800d8a:	5f                   	pop    %edi
  800d8b:	5d                   	pop    %ebp
  800d8c:	c3                   	ret    

00800d8d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d8d:	55                   	push   %ebp
  800d8e:	89 e5                	mov    %esp,%ebp
  800d90:	57                   	push   %edi
  800d91:	56                   	push   %esi
  800d92:	53                   	push   %ebx
  800d93:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9b:	b8 08 00 00 00       	mov    $0x8,%eax
  800da0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da3:	8b 55 08             	mov    0x8(%ebp),%edx
  800da6:	89 df                	mov    %ebx,%edi
  800da8:	89 de                	mov    %ebx,%esi
  800daa:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800dac:	85 c0                	test   %eax,%eax
  800dae:	7e 28                	jle    800dd8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800db4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800dbb:	00 
  800dbc:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800dc3:	00 
  800dc4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dcb:	00 
  800dcc:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800dd3:	e8 7d f3 ff ff       	call   800155 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dd8:	83 c4 2c             	add    $0x2c,%esp
  800ddb:	5b                   	pop    %ebx
  800ddc:	5e                   	pop    %esi
  800ddd:	5f                   	pop    %edi
  800dde:	5d                   	pop    %ebp
  800ddf:	c3                   	ret    

00800de0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	57                   	push   %edi
  800de4:	56                   	push   %esi
  800de5:	53                   	push   %ebx
  800de6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dee:	b8 09 00 00 00       	mov    $0x9,%eax
  800df3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	89 df                	mov    %ebx,%edi
  800dfb:	89 de                	mov    %ebx,%esi
  800dfd:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800dff:	85 c0                	test   %eax,%eax
  800e01:	7e 28                	jle    800e2b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e03:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e07:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e0e:	00 
  800e0f:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800e16:	00 
  800e17:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e1e:	00 
  800e1f:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800e26:	e8 2a f3 ff ff       	call   800155 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e2b:	83 c4 2c             	add    $0x2c,%esp
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    

00800e33 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	57                   	push   %edi
  800e37:	56                   	push   %esi
  800e38:	53                   	push   %ebx
  800e39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	89 df                	mov    %ebx,%edi
  800e4e:	89 de                	mov    %ebx,%esi
  800e50:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e52:	85 c0                	test   %eax,%eax
  800e54:	7e 28                	jle    800e7e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e56:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e5a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e61:	00 
  800e62:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800e69:	00 
  800e6a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e71:	00 
  800e72:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800e79:	e8 d7 f2 ff ff       	call   800155 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e7e:	83 c4 2c             	add    $0x2c,%esp
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    

00800e86 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	57                   	push   %edi
  800e8a:	56                   	push   %esi
  800e8b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8c:	be 00 00 00 00       	mov    $0x0,%esi
  800e91:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e99:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ea2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ea4:	5b                   	pop    %ebx
  800ea5:	5e                   	pop    %esi
  800ea6:	5f                   	pop    %edi
  800ea7:	5d                   	pop    %ebp
  800ea8:	c3                   	ret    

00800ea9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ea9:	55                   	push   %ebp
  800eaa:	89 e5                	mov    %esp,%ebp
  800eac:	57                   	push   %edi
  800ead:	56                   	push   %esi
  800eae:	53                   	push   %ebx
  800eaf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eb7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ebc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebf:	89 cb                	mov    %ecx,%ebx
  800ec1:	89 cf                	mov    %ecx,%edi
  800ec3:	89 ce                	mov    %ecx,%esi
  800ec5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	7e 28                	jle    800ef3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ecf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ed6:	00 
  800ed7:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800ede:	00 
  800edf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee6:	00 
  800ee7:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800eee:	e8 62 f2 ff ff       	call   800155 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ef3:	83 c4 2c             	add    $0x2c,%esp
  800ef6:	5b                   	pop    %ebx
  800ef7:	5e                   	pop    %esi
  800ef8:	5f                   	pop    %edi
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    

00800efb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	57                   	push   %edi
  800eff:	56                   	push   %esi
  800f00:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f01:	ba 00 00 00 00       	mov    $0x0,%edx
  800f06:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f0b:	89 d1                	mov    %edx,%ecx
  800f0d:	89 d3                	mov    %edx,%ebx
  800f0f:	89 d7                	mov    %edx,%edi
  800f11:	89 d6                	mov    %edx,%esi
  800f13:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f15:	5b                   	pop    %ebx
  800f16:	5e                   	pop    %esi
  800f17:	5f                   	pop    %edi
  800f18:	5d                   	pop    %ebp
  800f19:	c3                   	ret    

00800f1a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	57                   	push   %edi
  800f1e:	56                   	push   %esi
  800f1f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f20:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f25:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f30:	89 df                	mov    %ebx,%edi
  800f32:	89 de                	mov    %ebx,%esi
  800f34:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800f36:	5b                   	pop    %ebx
  800f37:	5e                   	pop    %esi
  800f38:	5f                   	pop    %edi
  800f39:	5d                   	pop    %ebp
  800f3a:	c3                   	ret    

00800f3b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	57                   	push   %edi
  800f3f:	56                   	push   %esi
  800f40:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f41:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f46:	b8 10 00 00 00       	mov    $0x10,%eax
  800f4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f51:	89 df                	mov    %ebx,%edi
  800f53:	89 de                	mov    %ebx,%esi
  800f55:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800f57:	5b                   	pop    %ebx
  800f58:	5e                   	pop    %esi
  800f59:	5f                   	pop    %edi
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f67:	b8 11 00 00 00       	mov    $0x11,%eax
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	89 cb                	mov    %ecx,%ebx
  800f71:	89 cf                	mov    %ecx,%edi
  800f73:	89 ce                	mov    %ecx,%esi
  800f75:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
  800f82:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f85:	be 00 00 00 00       	mov    $0x0,%esi
  800f8a:	b8 12 00 00 00       	mov    $0x12,%eax
  800f8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f92:	8b 55 08             	mov    0x8(%ebp),%edx
  800f95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f98:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f9b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	7e 28                	jle    800fc9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800fac:	00 
  800fad:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800fb4:	00 
  800fb5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fbc:	00 
  800fbd:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800fc4:	e8 8c f1 ff ff       	call   800155 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  800fc9:	83 c4 2c             	add    $0x2c,%esp
  800fcc:	5b                   	pop    %ebx
  800fcd:	5e                   	pop    %esi
  800fce:	5f                   	pop    %edi
  800fcf:	5d                   	pop    %ebp
  800fd0:	c3                   	ret    

00800fd1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  800fd7:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800fde:	75 68                	jne    801048 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  800fe0:	a1 08 40 80 00       	mov    0x804008,%eax
  800fe5:	8b 40 48             	mov    0x48(%eax),%eax
  800fe8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800fef:	00 
  800ff0:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800ff7:	ee 
  800ff8:	89 04 24             	mov    %eax,(%esp)
  800ffb:	e8 93 fc ff ff       	call   800c93 <sys_page_alloc>
  801000:	85 c0                	test   %eax,%eax
  801002:	74 2c                	je     801030 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  801004:	89 44 24 04          	mov    %eax,0x4(%esp)
  801008:	c7 04 24 74 2b 80 00 	movl   $0x802b74,(%esp)
  80100f:	e8 3a f2 ff ff       	call   80024e <cprintf>
			panic("set_pg_fault_handler");
  801014:	c7 44 24 08 a7 2b 80 	movl   $0x802ba7,0x8(%esp)
  80101b:	00 
  80101c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  801023:	00 
  801024:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  80102b:	e8 25 f1 ff ff       	call   800155 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  801030:	a1 08 40 80 00       	mov    0x804008,%eax
  801035:	8b 40 48             	mov    0x48(%eax),%eax
  801038:	c7 44 24 04 52 10 80 	movl   $0x801052,0x4(%esp)
  80103f:	00 
  801040:	89 04 24             	mov    %eax,(%esp)
  801043:	e8 eb fd ff ff       	call   800e33 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801052:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801053:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  801058:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80105a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  80105d:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  801061:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  801063:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  801067:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  801068:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  80106b:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  80106d:	58                   	pop    %eax
	popl %eax
  80106e:	58                   	pop    %eax
	popal
  80106f:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801070:	83 c4 04             	add    $0x4,%esp
	popfl
  801073:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801074:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801075:	c3                   	ret    
  801076:	66 90                	xchg   %ax,%ax
  801078:	66 90                	xchg   %ax,%ax
  80107a:	66 90                	xchg   %ax,%ax
  80107c:	66 90                	xchg   %ax,%ax
  80107e:	66 90                	xchg   %ax,%ax

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
  80116f:	8b 04 95 4c 2c 80 00 	mov    0x802c4c(,%edx,4),%eax
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
  80118a:	c7 04 24 cc 2b 80 00 	movl   $0x802bcc,(%esp)
  801191:	e8 b8 f0 ff ff       	call   80024e <cprintf>
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
  801219:	e8 1c fb ff ff       	call   800d3a <sys_page_unmap>
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
  801317:	e8 cb f9 ff ff       	call   800ce7 <sys_page_map>
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
  801352:	e8 90 f9 ff ff       	call   800ce7 <sys_page_map>
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
  80136b:	e8 ca f9 ff ff       	call   800d3a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801370:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801374:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80137b:	e8 ba f9 ff ff       	call   800d3a <sys_page_unmap>
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
  8013df:	c7 04 24 10 2c 80 00 	movl   $0x802c10,(%esp)
  8013e6:	e8 63 ee ff ff       	call   80024e <cprintf>
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
  8014b7:	c7 04 24 2c 2c 80 00 	movl   $0x802c2c,(%esp)
  8014be:	e8 8b ed ff ff       	call   80024e <cprintf>
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
  801570:	c7 04 24 ec 2b 80 00 	movl   $0x802bec,(%esp)
  801577:	e8 d2 ec ff ff       	call   80024e <cprintf>
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
  80167f:	e8 11 0e 00 00       	call   802495 <ipc_find_env>
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
  8016a5:	e8 5e 0d 00 00       	call   802408 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8016aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016b1:	00 
  8016b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016bd:	e8 de 0c 00 00       	call   8023a0 <ipc_recv>
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
  80174a:	e8 28 f1 ff ff       	call   800877 <strcpy>
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
  8017aa:	e8 65 f2 ff ff       	call   800a14 <memmove>

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
  8017c6:	c7 44 24 0c 60 2c 80 	movl   $0x802c60,0xc(%esp)
  8017cd:	00 
  8017ce:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  8017d5:	00 
  8017d6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  8017dd:	00 
  8017de:	c7 04 24 7c 2c 80 00 	movl   $0x802c7c,(%esp)
  8017e5:	e8 6b e9 ff ff       	call   800155 <_panic>
	assert(r <= PGSIZE);
  8017ea:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017ef:	7e 24                	jle    801815 <devfile_write+0xa5>
  8017f1:	c7 44 24 0c 87 2c 80 	movl   $0x802c87,0xc(%esp)
  8017f8:	00 
  8017f9:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  801800:	00 
  801801:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801808:	00 
  801809:	c7 04 24 7c 2c 80 00 	movl   $0x802c7c,(%esp)
  801810:	e8 40 e9 ff ff       	call   800155 <_panic>
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
  801850:	c7 44 24 0c 60 2c 80 	movl   $0x802c60,0xc(%esp)
  801857:	00 
  801858:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  80185f:	00 
  801860:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801867:	00 
  801868:	c7 04 24 7c 2c 80 00 	movl   $0x802c7c,(%esp)
  80186f:	e8 e1 e8 ff ff       	call   800155 <_panic>
	assert(r <= PGSIZE);
  801874:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801879:	7e 24                	jle    80189f <devfile_read+0x84>
  80187b:	c7 44 24 0c 87 2c 80 	movl   $0x802c87,0xc(%esp)
  801882:	00 
  801883:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  80188a:	00 
  80188b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801892:	00 
  801893:	c7 04 24 7c 2c 80 00 	movl   $0x802c7c,(%esp)
  80189a:	e8 b6 e8 ff ff       	call   800155 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80189f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018a3:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8018aa:	00 
  8018ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ae:	89 04 24             	mov    %eax,(%esp)
  8018b1:	e8 5e f1 ff ff       	call   800a14 <memmove>
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
  8018cc:	e8 6f ef ff ff       	call   800840 <strlen>
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
  8018f4:	e8 7e ef ff ff       	call   800877 <strcpy>
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
  801966:	c7 44 24 04 93 2c 80 	movl   $0x802c93,0x4(%esp)
  80196d:	00 
  80196e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801971:	89 04 24             	mov    %eax,(%esp)
  801974:	e8 fe ee ff ff       	call   800877 <strcpy>
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
  80198d:	e8 3d 0b 00 00       	call   8024cf <pageref>
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
  801a6c:	e8 22 f2 ff ff       	call   800c93 <sys_page_alloc>
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
  801bcc:	e8 c4 08 00 00       	call   802495 <ipc_find_env>
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
  801bf2:	e8 11 08 00 00       	call   802408 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801bf7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bfe:	00 
  801bff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c06:	00 
  801c07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0e:	e8 8d 07 00 00       	call   8023a0 <ipc_recv>
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
  801c5a:	e8 b5 ed ff ff       	call   800a14 <memmove>
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
  801c93:	e8 7c ed ff ff       	call   800a14 <memmove>
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
  801d0e:	e8 01 ed ff ff       	call   800a14 <memmove>
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
  801d87:	c7 44 24 0c 9f 2c 80 	movl   $0x802c9f,0xc(%esp)
  801d8e:	00 
  801d8f:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  801d96:	00 
  801d97:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801d9e:	00 
  801d9f:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  801da6:	e8 aa e3 ff ff       	call   800155 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801dab:	89 44 24 08          	mov    %eax,0x8(%esp)
  801daf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801db6:	00 
  801db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dba:	89 04 24             	mov    %eax,(%esp)
  801dbd:	e8 52 ec ff ff       	call   800a14 <memmove>
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
  801de5:	c7 44 24 0c c0 2c 80 	movl   $0x802cc0,0xc(%esp)
  801dec:	00 
  801ded:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  801df4:	00 
  801df5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801dfc:	00 
  801dfd:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  801e04:	e8 4c e3 ff ff       	call   800155 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e10:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e14:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801e1b:	e8 f4 eb ff ff       	call   800a14 <memmove>
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
  801e80:	c7 44 24 04 cc 2c 80 	movl   $0x802ccc,0x4(%esp)
  801e87:	00 
  801e88:	89 1c 24             	mov    %ebx,(%esp)
  801e8b:	e8 e7 e9 ff ff       	call   800877 <strcpy>
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
  801ed0:	e8 65 ee ff ff       	call   800d3a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ed5:	89 1c 24             	mov    %ebx,(%esp)
  801ed8:	e8 b3 f1 ff ff       	call   801090 <fd2data>
  801edd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ee8:	e8 4d ee ff ff       	call   800d3a <sys_page_unmap>
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
  801f0c:	e8 be 05 00 00       	call   8024cf <pageref>
  801f11:	89 c7                	mov    %eax,%edi
  801f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f16:	89 04 24             	mov    %eax,(%esp)
  801f19:	e8 b1 05 00 00       	call   8024cf <pageref>
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
  801f46:	c7 04 24 d3 2c 80 00 	movl   $0x802cd3,(%esp)
  801f4d:	e8 fc e2 ff ff       	call   80024e <cprintf>
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
  801f86:	e8 e9 ec ff ff       	call   800c74 <sys_yield>
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
  802006:	e8 69 ec ff ff       	call   800c74 <sys_yield>
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
  802077:	e8 17 ec ff ff       	call   800c93 <sys_page_alloc>
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
  8020b1:	e8 dd eb ff ff       	call   800c93 <sys_page_alloc>
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
  8020e0:	e8 ae eb ff ff       	call   800c93 <sys_page_alloc>
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
  802119:	e8 c9 eb ff ff       	call   800ce7 <sys_page_map>
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
  802181:	e8 b4 eb ff ff       	call   800d3a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802189:	89 44 24 04          	mov    %eax,0x4(%esp)
  80218d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802194:	e8 a1 eb ff ff       	call   800d3a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a7:	e8 8e eb ff ff       	call   800d3a <sys_page_unmap>
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
  802200:	c7 44 24 04 eb 2c 80 	movl   $0x802ceb,0x4(%esp)
  802207:	00 
  802208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220b:	89 04 24             	mov    %eax,(%esp)
  80220e:	e8 64 e6 ff ff       	call   800877 <strcpy>
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
  802251:	e8 be e7 ff ff       	call   800a14 <memmove>
		sys_cputs(buf, m);
  802256:	89 74 24 04          	mov    %esi,0x4(%esp)
  80225a:	89 3c 24             	mov    %edi,(%esp)
  80225d:	e8 64 e9 ff ff       	call   800bc6 <sys_cputs>
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
  802289:	e8 e6 e9 ff ff       	call   800c74 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80228e:	66 90                	xchg   %ax,%ax
  802290:	e8 4f e9 ff ff       	call   800be4 <sys_cgetc>
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
  8022cf:	e8 f2 e8 ff ff       	call   800bc6 <sys_cputs>
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
  802368:	e8 26 e9 ff ff       	call   800c93 <sys_page_alloc>
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
  802396:	66 90                	xchg   %ax,%ax
  802398:	66 90                	xchg   %ax,%ax
  80239a:	66 90                	xchg   %ax,%ax
  80239c:	66 90                	xchg   %ax,%ax
  80239e:	66 90                	xchg   %ax,%ax

008023a0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	56                   	push   %esi
  8023a4:	53                   	push   %ebx
  8023a5:	83 ec 10             	sub    $0x10,%esp
  8023a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8023ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8023b1:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  8023b3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8023b8:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  8023bb:	89 04 24             	mov    %eax,(%esp)
  8023be:	e8 e6 ea ff ff       	call   800ea9 <sys_ipc_recv>
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	74 16                	je     8023dd <ipc_recv+0x3d>
		if (from_env_store != NULL)
  8023c7:	85 f6                	test   %esi,%esi
  8023c9:	74 06                	je     8023d1 <ipc_recv+0x31>
			*from_env_store = 0;
  8023cb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8023d1:	85 db                	test   %ebx,%ebx
  8023d3:	74 2c                	je     802401 <ipc_recv+0x61>
			*perm_store = 0;
  8023d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8023db:	eb 24                	jmp    802401 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8023dd:	85 f6                	test   %esi,%esi
  8023df:	74 0a                	je     8023eb <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8023e1:	a1 08 40 80 00       	mov    0x804008,%eax
  8023e6:	8b 40 74             	mov    0x74(%eax),%eax
  8023e9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8023eb:	85 db                	test   %ebx,%ebx
  8023ed:	74 0a                	je     8023f9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8023ef:	a1 08 40 80 00       	mov    0x804008,%eax
  8023f4:	8b 40 78             	mov    0x78(%eax),%eax
  8023f7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8023f9:	a1 08 40 80 00       	mov    0x804008,%eax
  8023fe:	8b 40 70             	mov    0x70(%eax),%eax
}
  802401:	83 c4 10             	add    $0x10,%esp
  802404:	5b                   	pop    %ebx
  802405:	5e                   	pop    %esi
  802406:	5d                   	pop    %ebp
  802407:	c3                   	ret    

00802408 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802408:	55                   	push   %ebp
  802409:	89 e5                	mov    %esp,%ebp
  80240b:	57                   	push   %edi
  80240c:	56                   	push   %esi
  80240d:	53                   	push   %ebx
  80240e:	83 ec 1c             	sub    $0x1c,%esp
  802411:	8b 75 0c             	mov    0xc(%ebp),%esi
  802414:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802417:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80241a:	85 db                	test   %ebx,%ebx
  80241c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802421:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802424:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802428:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80242c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802430:	8b 45 08             	mov    0x8(%ebp),%eax
  802433:	89 04 24             	mov    %eax,(%esp)
  802436:	e8 4b ea ff ff       	call   800e86 <sys_ipc_try_send>
	if (r == 0) return;
  80243b:	85 c0                	test   %eax,%eax
  80243d:	75 22                	jne    802461 <ipc_send+0x59>
  80243f:	eb 4c                	jmp    80248d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802441:	84 d2                	test   %dl,%dl
  802443:	75 48                	jne    80248d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802445:	e8 2a e8 ff ff       	call   800c74 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80244a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80244e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802452:	89 74 24 04          	mov    %esi,0x4(%esp)
  802456:	8b 45 08             	mov    0x8(%ebp),%eax
  802459:	89 04 24             	mov    %eax,(%esp)
  80245c:	e8 25 ea ff ff       	call   800e86 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802461:	85 c0                	test   %eax,%eax
  802463:	0f 94 c2             	sete   %dl
  802466:	74 d9                	je     802441 <ipc_send+0x39>
  802468:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80246b:	74 d4                	je     802441 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80246d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802471:	c7 44 24 08 f7 2c 80 	movl   $0x802cf7,0x8(%esp)
  802478:	00 
  802479:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802480:	00 
  802481:	c7 04 24 05 2d 80 00 	movl   $0x802d05,(%esp)
  802488:	e8 c8 dc ff ff       	call   800155 <_panic>
}
  80248d:	83 c4 1c             	add    $0x1c,%esp
  802490:	5b                   	pop    %ebx
  802491:	5e                   	pop    %esi
  802492:	5f                   	pop    %edi
  802493:	5d                   	pop    %ebp
  802494:	c3                   	ret    

00802495 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
  802498:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80249b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8024a0:	89 c2                	mov    %eax,%edx
  8024a2:	c1 e2 07             	shl    $0x7,%edx
  8024a5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8024ab:	8b 52 50             	mov    0x50(%edx),%edx
  8024ae:	39 ca                	cmp    %ecx,%edx
  8024b0:	75 0d                	jne    8024bf <ipc_find_env+0x2a>
			return envs[i].env_id;
  8024b2:	c1 e0 07             	shl    $0x7,%eax
  8024b5:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8024ba:	8b 40 40             	mov    0x40(%eax),%eax
  8024bd:	eb 0e                	jmp    8024cd <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024bf:	83 c0 01             	add    $0x1,%eax
  8024c2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024c7:	75 d7                	jne    8024a0 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8024c9:	66 b8 00 00          	mov    $0x0,%ax
}
  8024cd:	5d                   	pop    %ebp
  8024ce:	c3                   	ret    

008024cf <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
  8024d2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024d5:	89 d0                	mov    %edx,%eax
  8024d7:	c1 e8 16             	shr    $0x16,%eax
  8024da:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024e6:	f6 c1 01             	test   $0x1,%cl
  8024e9:	74 1d                	je     802508 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8024eb:	c1 ea 0c             	shr    $0xc,%edx
  8024ee:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024f5:	f6 c2 01             	test   $0x1,%dl
  8024f8:	74 0e                	je     802508 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024fa:	c1 ea 0c             	shr    $0xc,%edx
  8024fd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802504:	ef 
  802505:	0f b7 c0             	movzwl %ax,%eax
}
  802508:	5d                   	pop    %ebp
  802509:	c3                   	ret    
  80250a:	66 90                	xchg   %ax,%ax
  80250c:	66 90                	xchg   %ax,%ax
  80250e:	66 90                	xchg   %ax,%ax

00802510 <__udivdi3>:
  802510:	55                   	push   %ebp
  802511:	57                   	push   %edi
  802512:	56                   	push   %esi
  802513:	83 ec 0c             	sub    $0xc,%esp
  802516:	8b 44 24 28          	mov    0x28(%esp),%eax
  80251a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80251e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802522:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802526:	85 c0                	test   %eax,%eax
  802528:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80252c:	89 ea                	mov    %ebp,%edx
  80252e:	89 0c 24             	mov    %ecx,(%esp)
  802531:	75 2d                	jne    802560 <__udivdi3+0x50>
  802533:	39 e9                	cmp    %ebp,%ecx
  802535:	77 61                	ja     802598 <__udivdi3+0x88>
  802537:	85 c9                	test   %ecx,%ecx
  802539:	89 ce                	mov    %ecx,%esi
  80253b:	75 0b                	jne    802548 <__udivdi3+0x38>
  80253d:	b8 01 00 00 00       	mov    $0x1,%eax
  802542:	31 d2                	xor    %edx,%edx
  802544:	f7 f1                	div    %ecx
  802546:	89 c6                	mov    %eax,%esi
  802548:	31 d2                	xor    %edx,%edx
  80254a:	89 e8                	mov    %ebp,%eax
  80254c:	f7 f6                	div    %esi
  80254e:	89 c5                	mov    %eax,%ebp
  802550:	89 f8                	mov    %edi,%eax
  802552:	f7 f6                	div    %esi
  802554:	89 ea                	mov    %ebp,%edx
  802556:	83 c4 0c             	add    $0xc,%esp
  802559:	5e                   	pop    %esi
  80255a:	5f                   	pop    %edi
  80255b:	5d                   	pop    %ebp
  80255c:	c3                   	ret    
  80255d:	8d 76 00             	lea    0x0(%esi),%esi
  802560:	39 e8                	cmp    %ebp,%eax
  802562:	77 24                	ja     802588 <__udivdi3+0x78>
  802564:	0f bd e8             	bsr    %eax,%ebp
  802567:	83 f5 1f             	xor    $0x1f,%ebp
  80256a:	75 3c                	jne    8025a8 <__udivdi3+0x98>
  80256c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802570:	39 34 24             	cmp    %esi,(%esp)
  802573:	0f 86 9f 00 00 00    	jbe    802618 <__udivdi3+0x108>
  802579:	39 d0                	cmp    %edx,%eax
  80257b:	0f 82 97 00 00 00    	jb     802618 <__udivdi3+0x108>
  802581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802588:	31 d2                	xor    %edx,%edx
  80258a:	31 c0                	xor    %eax,%eax
  80258c:	83 c4 0c             	add    $0xc,%esp
  80258f:	5e                   	pop    %esi
  802590:	5f                   	pop    %edi
  802591:	5d                   	pop    %ebp
  802592:	c3                   	ret    
  802593:	90                   	nop
  802594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802598:	89 f8                	mov    %edi,%eax
  80259a:	f7 f1                	div    %ecx
  80259c:	31 d2                	xor    %edx,%edx
  80259e:	83 c4 0c             	add    $0xc,%esp
  8025a1:	5e                   	pop    %esi
  8025a2:	5f                   	pop    %edi
  8025a3:	5d                   	pop    %ebp
  8025a4:	c3                   	ret    
  8025a5:	8d 76 00             	lea    0x0(%esi),%esi
  8025a8:	89 e9                	mov    %ebp,%ecx
  8025aa:	8b 3c 24             	mov    (%esp),%edi
  8025ad:	d3 e0                	shl    %cl,%eax
  8025af:	89 c6                	mov    %eax,%esi
  8025b1:	b8 20 00 00 00       	mov    $0x20,%eax
  8025b6:	29 e8                	sub    %ebp,%eax
  8025b8:	89 c1                	mov    %eax,%ecx
  8025ba:	d3 ef                	shr    %cl,%edi
  8025bc:	89 e9                	mov    %ebp,%ecx
  8025be:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8025c2:	8b 3c 24             	mov    (%esp),%edi
  8025c5:	09 74 24 08          	or     %esi,0x8(%esp)
  8025c9:	89 d6                	mov    %edx,%esi
  8025cb:	d3 e7                	shl    %cl,%edi
  8025cd:	89 c1                	mov    %eax,%ecx
  8025cf:	89 3c 24             	mov    %edi,(%esp)
  8025d2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025d6:	d3 ee                	shr    %cl,%esi
  8025d8:	89 e9                	mov    %ebp,%ecx
  8025da:	d3 e2                	shl    %cl,%edx
  8025dc:	89 c1                	mov    %eax,%ecx
  8025de:	d3 ef                	shr    %cl,%edi
  8025e0:	09 d7                	or     %edx,%edi
  8025e2:	89 f2                	mov    %esi,%edx
  8025e4:	89 f8                	mov    %edi,%eax
  8025e6:	f7 74 24 08          	divl   0x8(%esp)
  8025ea:	89 d6                	mov    %edx,%esi
  8025ec:	89 c7                	mov    %eax,%edi
  8025ee:	f7 24 24             	mull   (%esp)
  8025f1:	39 d6                	cmp    %edx,%esi
  8025f3:	89 14 24             	mov    %edx,(%esp)
  8025f6:	72 30                	jb     802628 <__udivdi3+0x118>
  8025f8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025fc:	89 e9                	mov    %ebp,%ecx
  8025fe:	d3 e2                	shl    %cl,%edx
  802600:	39 c2                	cmp    %eax,%edx
  802602:	73 05                	jae    802609 <__udivdi3+0xf9>
  802604:	3b 34 24             	cmp    (%esp),%esi
  802607:	74 1f                	je     802628 <__udivdi3+0x118>
  802609:	89 f8                	mov    %edi,%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	e9 7a ff ff ff       	jmp    80258c <__udivdi3+0x7c>
  802612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802618:	31 d2                	xor    %edx,%edx
  80261a:	b8 01 00 00 00       	mov    $0x1,%eax
  80261f:	e9 68 ff ff ff       	jmp    80258c <__udivdi3+0x7c>
  802624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802628:	8d 47 ff             	lea    -0x1(%edi),%eax
  80262b:	31 d2                	xor    %edx,%edx
  80262d:	83 c4 0c             	add    $0xc,%esp
  802630:	5e                   	pop    %esi
  802631:	5f                   	pop    %edi
  802632:	5d                   	pop    %ebp
  802633:	c3                   	ret    
  802634:	66 90                	xchg   %ax,%ax
  802636:	66 90                	xchg   %ax,%ax
  802638:	66 90                	xchg   %ax,%ax
  80263a:	66 90                	xchg   %ax,%ax
  80263c:	66 90                	xchg   %ax,%ax
  80263e:	66 90                	xchg   %ax,%ax

00802640 <__umoddi3>:
  802640:	55                   	push   %ebp
  802641:	57                   	push   %edi
  802642:	56                   	push   %esi
  802643:	83 ec 14             	sub    $0x14,%esp
  802646:	8b 44 24 28          	mov    0x28(%esp),%eax
  80264a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80264e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802652:	89 c7                	mov    %eax,%edi
  802654:	89 44 24 04          	mov    %eax,0x4(%esp)
  802658:	8b 44 24 30          	mov    0x30(%esp),%eax
  80265c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802660:	89 34 24             	mov    %esi,(%esp)
  802663:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802667:	85 c0                	test   %eax,%eax
  802669:	89 c2                	mov    %eax,%edx
  80266b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80266f:	75 17                	jne    802688 <__umoddi3+0x48>
  802671:	39 fe                	cmp    %edi,%esi
  802673:	76 4b                	jbe    8026c0 <__umoddi3+0x80>
  802675:	89 c8                	mov    %ecx,%eax
  802677:	89 fa                	mov    %edi,%edx
  802679:	f7 f6                	div    %esi
  80267b:	89 d0                	mov    %edx,%eax
  80267d:	31 d2                	xor    %edx,%edx
  80267f:	83 c4 14             	add    $0x14,%esp
  802682:	5e                   	pop    %esi
  802683:	5f                   	pop    %edi
  802684:	5d                   	pop    %ebp
  802685:	c3                   	ret    
  802686:	66 90                	xchg   %ax,%ax
  802688:	39 f8                	cmp    %edi,%eax
  80268a:	77 54                	ja     8026e0 <__umoddi3+0xa0>
  80268c:	0f bd e8             	bsr    %eax,%ebp
  80268f:	83 f5 1f             	xor    $0x1f,%ebp
  802692:	75 5c                	jne    8026f0 <__umoddi3+0xb0>
  802694:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802698:	39 3c 24             	cmp    %edi,(%esp)
  80269b:	0f 87 e7 00 00 00    	ja     802788 <__umoddi3+0x148>
  8026a1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8026a5:	29 f1                	sub    %esi,%ecx
  8026a7:	19 c7                	sbb    %eax,%edi
  8026a9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026b1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026b5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8026b9:	83 c4 14             	add    $0x14,%esp
  8026bc:	5e                   	pop    %esi
  8026bd:	5f                   	pop    %edi
  8026be:	5d                   	pop    %ebp
  8026bf:	c3                   	ret    
  8026c0:	85 f6                	test   %esi,%esi
  8026c2:	89 f5                	mov    %esi,%ebp
  8026c4:	75 0b                	jne    8026d1 <__umoddi3+0x91>
  8026c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026cb:	31 d2                	xor    %edx,%edx
  8026cd:	f7 f6                	div    %esi
  8026cf:	89 c5                	mov    %eax,%ebp
  8026d1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026d5:	31 d2                	xor    %edx,%edx
  8026d7:	f7 f5                	div    %ebp
  8026d9:	89 c8                	mov    %ecx,%eax
  8026db:	f7 f5                	div    %ebp
  8026dd:	eb 9c                	jmp    80267b <__umoddi3+0x3b>
  8026df:	90                   	nop
  8026e0:	89 c8                	mov    %ecx,%eax
  8026e2:	89 fa                	mov    %edi,%edx
  8026e4:	83 c4 14             	add    $0x14,%esp
  8026e7:	5e                   	pop    %esi
  8026e8:	5f                   	pop    %edi
  8026e9:	5d                   	pop    %ebp
  8026ea:	c3                   	ret    
  8026eb:	90                   	nop
  8026ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026f0:	8b 04 24             	mov    (%esp),%eax
  8026f3:	be 20 00 00 00       	mov    $0x20,%esi
  8026f8:	89 e9                	mov    %ebp,%ecx
  8026fa:	29 ee                	sub    %ebp,%esi
  8026fc:	d3 e2                	shl    %cl,%edx
  8026fe:	89 f1                	mov    %esi,%ecx
  802700:	d3 e8                	shr    %cl,%eax
  802702:	89 e9                	mov    %ebp,%ecx
  802704:	89 44 24 04          	mov    %eax,0x4(%esp)
  802708:	8b 04 24             	mov    (%esp),%eax
  80270b:	09 54 24 04          	or     %edx,0x4(%esp)
  80270f:	89 fa                	mov    %edi,%edx
  802711:	d3 e0                	shl    %cl,%eax
  802713:	89 f1                	mov    %esi,%ecx
  802715:	89 44 24 08          	mov    %eax,0x8(%esp)
  802719:	8b 44 24 10          	mov    0x10(%esp),%eax
  80271d:	d3 ea                	shr    %cl,%edx
  80271f:	89 e9                	mov    %ebp,%ecx
  802721:	d3 e7                	shl    %cl,%edi
  802723:	89 f1                	mov    %esi,%ecx
  802725:	d3 e8                	shr    %cl,%eax
  802727:	89 e9                	mov    %ebp,%ecx
  802729:	09 f8                	or     %edi,%eax
  80272b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80272f:	f7 74 24 04          	divl   0x4(%esp)
  802733:	d3 e7                	shl    %cl,%edi
  802735:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802739:	89 d7                	mov    %edx,%edi
  80273b:	f7 64 24 08          	mull   0x8(%esp)
  80273f:	39 d7                	cmp    %edx,%edi
  802741:	89 c1                	mov    %eax,%ecx
  802743:	89 14 24             	mov    %edx,(%esp)
  802746:	72 2c                	jb     802774 <__umoddi3+0x134>
  802748:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80274c:	72 22                	jb     802770 <__umoddi3+0x130>
  80274e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802752:	29 c8                	sub    %ecx,%eax
  802754:	19 d7                	sbb    %edx,%edi
  802756:	89 e9                	mov    %ebp,%ecx
  802758:	89 fa                	mov    %edi,%edx
  80275a:	d3 e8                	shr    %cl,%eax
  80275c:	89 f1                	mov    %esi,%ecx
  80275e:	d3 e2                	shl    %cl,%edx
  802760:	89 e9                	mov    %ebp,%ecx
  802762:	d3 ef                	shr    %cl,%edi
  802764:	09 d0                	or     %edx,%eax
  802766:	89 fa                	mov    %edi,%edx
  802768:	83 c4 14             	add    $0x14,%esp
  80276b:	5e                   	pop    %esi
  80276c:	5f                   	pop    %edi
  80276d:	5d                   	pop    %ebp
  80276e:	c3                   	ret    
  80276f:	90                   	nop
  802770:	39 d7                	cmp    %edx,%edi
  802772:	75 da                	jne    80274e <__umoddi3+0x10e>
  802774:	8b 14 24             	mov    (%esp),%edx
  802777:	89 c1                	mov    %eax,%ecx
  802779:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80277d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802781:	eb cb                	jmp    80274e <__umoddi3+0x10e>
  802783:	90                   	nop
  802784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802788:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80278c:	0f 82 0f ff ff ff    	jb     8026a1 <__umoddi3+0x61>
  802792:	e9 1a ff ff ff       	jmp    8026b1 <__umoddi3+0x71>
