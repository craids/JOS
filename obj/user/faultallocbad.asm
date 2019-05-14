
obj/user/faultallocbad.debug:     file format elf32-i386


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
  80002c:	e8 af 00 00 00       	call   8000e0 <libmain>
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
  80004a:	e8 eb 01 00 00       	call   80023a <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80004f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800056:	00 
  800057:	89 d8                	mov    %ebx,%eax
  800059:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800069:	e8 15 0c 00 00       	call   800c83 <sys_page_alloc>
  80006e:	85 c0                	test   %eax,%eax
  800070:	79 24                	jns    800096 <handler+0x63>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  800072:	89 44 24 10          	mov    %eax,0x10(%esp)
  800076:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80007a:	c7 44 24 08 c0 27 80 	movl   $0x8027c0,0x8(%esp)
  800081:	00 
  800082:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800089:	00 
  80008a:	c7 04 24 aa 27 80 00 	movl   $0x8027aa,(%esp)
  800091:	e8 ab 00 00 00       	call   800141 <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  800096:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80009a:	c7 44 24 08 ec 27 80 	movl   $0x8027ec,0x8(%esp)
  8000a1:	00 
  8000a2:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000a9:	00 
  8000aa:	89 1c 24             	mov    %ebx,(%esp)
  8000ad:	e8 48 07 00 00       	call   8007fa <snprintf>
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
  8000c5:	e8 f7 0e 00 00       	call   800fc1 <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  8000ca:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  8000d1:	00 
  8000d2:	c7 04 24 ef be ad de 	movl   $0xdeadbeef,(%esp)
  8000d9:	e8 d8 0a 00 00       	call   800bb6 <sys_cputs>
}
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    

008000e0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	56                   	push   %esi
  8000e4:	53                   	push   %ebx
  8000e5:	83 ec 10             	sub    $0x10,%esp
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ee:	e8 52 0b 00 00       	call   800c45 <sys_getenvid>
  8000f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f8:	c1 e0 07             	shl    $0x7,%eax
  8000fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800100:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800105:	85 db                	test   %ebx,%ebx
  800107:	7e 07                	jle    800110 <libmain+0x30>
		binaryname = argv[0];
  800109:	8b 06                	mov    (%esi),%eax
  80010b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800110:	89 74 24 04          	mov    %esi,0x4(%esp)
  800114:	89 1c 24             	mov    %ebx,(%esp)
  800117:	e8 9c ff ff ff       	call   8000b8 <umain>

	// exit gracefully
	exit();
  80011c:	e8 07 00 00 00       	call   800128 <exit>
}
  800121:	83 c4 10             	add    $0x10,%esp
  800124:	5b                   	pop    %ebx
  800125:	5e                   	pop    %esi
  800126:	5d                   	pop    %ebp
  800127:	c3                   	ret    

00800128 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800128:	55                   	push   %ebp
  800129:	89 e5                	mov    %esp,%ebp
  80012b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80012e:	e8 17 11 00 00       	call   80124a <close_all>
	sys_env_destroy(0);
  800133:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80013a:	e8 b4 0a 00 00       	call   800bf3 <sys_env_destroy>
}
  80013f:	c9                   	leave  
  800140:	c3                   	ret    

00800141 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800141:	55                   	push   %ebp
  800142:	89 e5                	mov    %esp,%ebp
  800144:	56                   	push   %esi
  800145:	53                   	push   %ebx
  800146:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800149:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80014c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800152:	e8 ee 0a 00 00       	call   800c45 <sys_getenvid>
  800157:	8b 55 0c             	mov    0xc(%ebp),%edx
  80015a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80015e:	8b 55 08             	mov    0x8(%ebp),%edx
  800161:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800165:	89 74 24 08          	mov    %esi,0x8(%esp)
  800169:	89 44 24 04          	mov    %eax,0x4(%esp)
  80016d:	c7 04 24 18 28 80 00 	movl   $0x802818,(%esp)
  800174:	e8 c1 00 00 00       	call   80023a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800179:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80017d:	8b 45 10             	mov    0x10(%ebp),%eax
  800180:	89 04 24             	mov    %eax,(%esp)
  800183:	e8 51 00 00 00       	call   8001d9 <vcprintf>
	cprintf("\n");
  800188:	c7 04 24 e4 2c 80 00 	movl   $0x802ce4,(%esp)
  80018f:	e8 a6 00 00 00       	call   80023a <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800194:	cc                   	int3   
  800195:	eb fd                	jmp    800194 <_panic+0x53>

00800197 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	53                   	push   %ebx
  80019b:	83 ec 14             	sub    $0x14,%esp
  80019e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a1:	8b 13                	mov    (%ebx),%edx
  8001a3:	8d 42 01             	lea    0x1(%edx),%eax
  8001a6:	89 03                	mov    %eax,(%ebx)
  8001a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ab:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b4:	75 19                	jne    8001cf <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001b6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001bd:	00 
  8001be:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c1:	89 04 24             	mov    %eax,(%esp)
  8001c4:	e8 ed 09 00 00       	call   800bb6 <sys_cputs>
		b->idx = 0;
  8001c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001cf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001d3:	83 c4 14             	add    $0x14,%esp
  8001d6:	5b                   	pop    %ebx
  8001d7:	5d                   	pop    %ebp
  8001d8:	c3                   	ret    

008001d9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001e9:	00 00 00 
	b.cnt = 0;
  8001ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800200:	89 44 24 08          	mov    %eax,0x8(%esp)
  800204:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80020a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80020e:	c7 04 24 97 01 80 00 	movl   $0x800197,(%esp)
  800215:	e8 b4 01 00 00       	call   8003ce <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80021a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800220:	89 44 24 04          	mov    %eax,0x4(%esp)
  800224:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80022a:	89 04 24             	mov    %eax,(%esp)
  80022d:	e8 84 09 00 00       	call   800bb6 <sys_cputs>

	return b.cnt;
}
  800232:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800238:	c9                   	leave  
  800239:	c3                   	ret    

0080023a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800240:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800243:	89 44 24 04          	mov    %eax,0x4(%esp)
  800247:	8b 45 08             	mov    0x8(%ebp),%eax
  80024a:	89 04 24             	mov    %eax,(%esp)
  80024d:	e8 87 ff ff ff       	call   8001d9 <vcprintf>
	va_end(ap);

	return cnt;
}
  800252:	c9                   	leave  
  800253:	c3                   	ret    
  800254:	66 90                	xchg   %ax,%ax
  800256:	66 90                	xchg   %ax,%ax
  800258:	66 90                	xchg   %ax,%ax
  80025a:	66 90                	xchg   %ax,%ax
  80025c:	66 90                	xchg   %ax,%ax
  80025e:	66 90                	xchg   %ax,%ax

00800260 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
  800263:	57                   	push   %edi
  800264:	56                   	push   %esi
  800265:	53                   	push   %ebx
  800266:	83 ec 3c             	sub    $0x3c,%esp
  800269:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80026c:	89 d7                	mov    %edx,%edi
  80026e:	8b 45 08             	mov    0x8(%ebp),%eax
  800271:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800274:	8b 45 0c             	mov    0xc(%ebp),%eax
  800277:	89 c3                	mov    %eax,%ebx
  800279:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80027c:	8b 45 10             	mov    0x10(%ebp),%eax
  80027f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800282:	b9 00 00 00 00       	mov    $0x0,%ecx
  800287:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80028a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80028d:	39 d9                	cmp    %ebx,%ecx
  80028f:	72 05                	jb     800296 <printnum+0x36>
  800291:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800294:	77 69                	ja     8002ff <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800296:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800299:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80029d:	83 ee 01             	sub    $0x1,%esi
  8002a0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002a8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002ac:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002b0:	89 c3                	mov    %eax,%ebx
  8002b2:	89 d6                	mov    %edx,%esi
  8002b4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ba:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002be:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002c5:	89 04 24             	mov    %eax,(%esp)
  8002c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cf:	e8 2c 22 00 00       	call   802500 <__udivdi3>
  8002d4:	89 d9                	mov    %ebx,%ecx
  8002d6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002da:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002de:	89 04 24             	mov    %eax,(%esp)
  8002e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002e5:	89 fa                	mov    %edi,%edx
  8002e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ea:	e8 71 ff ff ff       	call   800260 <printnum>
  8002ef:	eb 1b                	jmp    80030c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002f1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f8:	89 04 24             	mov    %eax,(%esp)
  8002fb:	ff d3                	call   *%ebx
  8002fd:	eb 03                	jmp    800302 <printnum+0xa2>
  8002ff:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800302:	83 ee 01             	sub    $0x1,%esi
  800305:	85 f6                	test   %esi,%esi
  800307:	7f e8                	jg     8002f1 <printnum+0x91>
  800309:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80030c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800310:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800314:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800317:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80031a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80031e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800322:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800325:	89 04 24             	mov    %eax,(%esp)
  800328:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80032b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032f:	e8 fc 22 00 00       	call   802630 <__umoddi3>
  800334:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800338:	0f be 80 3b 28 80 00 	movsbl 0x80283b(%eax),%eax
  80033f:	89 04 24             	mov    %eax,(%esp)
  800342:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800345:	ff d0                	call   *%eax
}
  800347:	83 c4 3c             	add    $0x3c,%esp
  80034a:	5b                   	pop    %ebx
  80034b:	5e                   	pop    %esi
  80034c:	5f                   	pop    %edi
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    

0080034f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800352:	83 fa 01             	cmp    $0x1,%edx
  800355:	7e 0e                	jle    800365 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800357:	8b 10                	mov    (%eax),%edx
  800359:	8d 4a 08             	lea    0x8(%edx),%ecx
  80035c:	89 08                	mov    %ecx,(%eax)
  80035e:	8b 02                	mov    (%edx),%eax
  800360:	8b 52 04             	mov    0x4(%edx),%edx
  800363:	eb 22                	jmp    800387 <getuint+0x38>
	else if (lflag)
  800365:	85 d2                	test   %edx,%edx
  800367:	74 10                	je     800379 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800369:	8b 10                	mov    (%eax),%edx
  80036b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80036e:	89 08                	mov    %ecx,(%eax)
  800370:	8b 02                	mov    (%edx),%eax
  800372:	ba 00 00 00 00       	mov    $0x0,%edx
  800377:	eb 0e                	jmp    800387 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800379:	8b 10                	mov    (%eax),%edx
  80037b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80037e:	89 08                	mov    %ecx,(%eax)
  800380:	8b 02                	mov    (%edx),%eax
  800382:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800387:	5d                   	pop    %ebp
  800388:	c3                   	ret    

00800389 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800389:	55                   	push   %ebp
  80038a:	89 e5                	mov    %esp,%ebp
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80038f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800393:	8b 10                	mov    (%eax),%edx
  800395:	3b 50 04             	cmp    0x4(%eax),%edx
  800398:	73 0a                	jae    8003a4 <sprintputch+0x1b>
		*b->buf++ = ch;
  80039a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80039d:	89 08                	mov    %ecx,(%eax)
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a2:	88 02                	mov    %al,(%edx)
}
  8003a4:	5d                   	pop    %ebp
  8003a5:	c3                   	ret    

008003a6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003a6:	55                   	push   %ebp
  8003a7:	89 e5                	mov    %esp,%ebp
  8003a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003ac:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	89 04 24             	mov    %eax,(%esp)
  8003c7:	e8 02 00 00 00       	call   8003ce <vprintfmt>
	va_end(ap);
}
  8003cc:	c9                   	leave  
  8003cd:	c3                   	ret    

008003ce <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003ce:	55                   	push   %ebp
  8003cf:	89 e5                	mov    %esp,%ebp
  8003d1:	57                   	push   %edi
  8003d2:	56                   	push   %esi
  8003d3:	53                   	push   %ebx
  8003d4:	83 ec 3c             	sub    $0x3c,%esp
  8003d7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003dd:	eb 14                	jmp    8003f3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003df:	85 c0                	test   %eax,%eax
  8003e1:	0f 84 b3 03 00 00    	je     80079a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8003e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003eb:	89 04 24             	mov    %eax,(%esp)
  8003ee:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003f1:	89 f3                	mov    %esi,%ebx
  8003f3:	8d 73 01             	lea    0x1(%ebx),%esi
  8003f6:	0f b6 03             	movzbl (%ebx),%eax
  8003f9:	83 f8 25             	cmp    $0x25,%eax
  8003fc:	75 e1                	jne    8003df <vprintfmt+0x11>
  8003fe:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800402:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800409:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800410:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800417:	ba 00 00 00 00       	mov    $0x0,%edx
  80041c:	eb 1d                	jmp    80043b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800420:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800424:	eb 15                	jmp    80043b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800426:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800428:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80042c:	eb 0d                	jmp    80043b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80042e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800431:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800434:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80043b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80043e:	0f b6 0e             	movzbl (%esi),%ecx
  800441:	0f b6 c1             	movzbl %cl,%eax
  800444:	83 e9 23             	sub    $0x23,%ecx
  800447:	80 f9 55             	cmp    $0x55,%cl
  80044a:	0f 87 2a 03 00 00    	ja     80077a <vprintfmt+0x3ac>
  800450:	0f b6 c9             	movzbl %cl,%ecx
  800453:	ff 24 8d 80 29 80 00 	jmp    *0x802980(,%ecx,4)
  80045a:	89 de                	mov    %ebx,%esi
  80045c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800461:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800464:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800468:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80046b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80046e:	83 fb 09             	cmp    $0x9,%ebx
  800471:	77 36                	ja     8004a9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800473:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800476:	eb e9                	jmp    800461 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800478:	8b 45 14             	mov    0x14(%ebp),%eax
  80047b:	8d 48 04             	lea    0x4(%eax),%ecx
  80047e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800481:	8b 00                	mov    (%eax),%eax
  800483:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800486:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800488:	eb 22                	jmp    8004ac <vprintfmt+0xde>
  80048a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80048d:	85 c9                	test   %ecx,%ecx
  80048f:	b8 00 00 00 00       	mov    $0x0,%eax
  800494:	0f 49 c1             	cmovns %ecx,%eax
  800497:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	89 de                	mov    %ebx,%esi
  80049c:	eb 9d                	jmp    80043b <vprintfmt+0x6d>
  80049e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004a0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8004a7:	eb 92                	jmp    80043b <vprintfmt+0x6d>
  8004a9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8004ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004b0:	79 89                	jns    80043b <vprintfmt+0x6d>
  8004b2:	e9 77 ff ff ff       	jmp    80042e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004b7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004bc:	e9 7a ff ff ff       	jmp    80043b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c4:	8d 50 04             	lea    0x4(%eax),%edx
  8004c7:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004ce:	8b 00                	mov    (%eax),%eax
  8004d0:	89 04 24             	mov    %eax,(%esp)
  8004d3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004d6:	e9 18 ff ff ff       	jmp    8003f3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004db:	8b 45 14             	mov    0x14(%ebp),%eax
  8004de:	8d 50 04             	lea    0x4(%eax),%edx
  8004e1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	99                   	cltd   
  8004e7:	31 d0                	xor    %edx,%eax
  8004e9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004eb:	83 f8 11             	cmp    $0x11,%eax
  8004ee:	7f 0b                	jg     8004fb <vprintfmt+0x12d>
  8004f0:	8b 14 85 e0 2a 80 00 	mov    0x802ae0(,%eax,4),%edx
  8004f7:	85 d2                	test   %edx,%edx
  8004f9:	75 20                	jne    80051b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8004fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004ff:	c7 44 24 08 53 28 80 	movl   $0x802853,0x8(%esp)
  800506:	00 
  800507:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80050b:	8b 45 08             	mov    0x8(%ebp),%eax
  80050e:	89 04 24             	mov    %eax,(%esp)
  800511:	e8 90 fe ff ff       	call   8003a6 <printfmt>
  800516:	e9 d8 fe ff ff       	jmp    8003f3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80051b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80051f:	c7 44 24 08 79 2c 80 	movl   $0x802c79,0x8(%esp)
  800526:	00 
  800527:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052b:	8b 45 08             	mov    0x8(%ebp),%eax
  80052e:	89 04 24             	mov    %eax,(%esp)
  800531:	e8 70 fe ff ff       	call   8003a6 <printfmt>
  800536:	e9 b8 fe ff ff       	jmp    8003f3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80053e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800541:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8d 50 04             	lea    0x4(%eax),%edx
  80054a:	89 55 14             	mov    %edx,0x14(%ebp)
  80054d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80054f:	85 f6                	test   %esi,%esi
  800551:	b8 4c 28 80 00       	mov    $0x80284c,%eax
  800556:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800559:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80055d:	0f 84 97 00 00 00    	je     8005fa <vprintfmt+0x22c>
  800563:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800567:	0f 8e 9b 00 00 00    	jle    800608 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80056d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800571:	89 34 24             	mov    %esi,(%esp)
  800574:	e8 cf 02 00 00       	call   800848 <strnlen>
  800579:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80057c:	29 c2                	sub    %eax,%edx
  80057e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800581:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800585:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800588:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80058b:	8b 75 08             	mov    0x8(%ebp),%esi
  80058e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800591:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800593:	eb 0f                	jmp    8005a4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800595:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800599:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80059c:	89 04 24             	mov    %eax,(%esp)
  80059f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a1:	83 eb 01             	sub    $0x1,%ebx
  8005a4:	85 db                	test   %ebx,%ebx
  8005a6:	7f ed                	jg     800595 <vprintfmt+0x1c7>
  8005a8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005ab:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ae:	85 d2                	test   %edx,%edx
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	0f 49 c2             	cmovns %edx,%eax
  8005b8:	29 c2                	sub    %eax,%edx
  8005ba:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005bd:	89 d7                	mov    %edx,%edi
  8005bf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005c2:	eb 50                	jmp    800614 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005c8:	74 1e                	je     8005e8 <vprintfmt+0x21a>
  8005ca:	0f be d2             	movsbl %dl,%edx
  8005cd:	83 ea 20             	sub    $0x20,%edx
  8005d0:	83 fa 5e             	cmp    $0x5e,%edx
  8005d3:	76 13                	jbe    8005e8 <vprintfmt+0x21a>
					putch('?', putdat);
  8005d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005dc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005e3:	ff 55 08             	call   *0x8(%ebp)
  8005e6:	eb 0d                	jmp    8005f5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8005e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005eb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005ef:	89 04 24             	mov    %eax,(%esp)
  8005f2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005f5:	83 ef 01             	sub    $0x1,%edi
  8005f8:	eb 1a                	jmp    800614 <vprintfmt+0x246>
  8005fa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005fd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800600:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800603:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800606:	eb 0c                	jmp    800614 <vprintfmt+0x246>
  800608:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80060b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80060e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800611:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800614:	83 c6 01             	add    $0x1,%esi
  800617:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80061b:	0f be c2             	movsbl %dl,%eax
  80061e:	85 c0                	test   %eax,%eax
  800620:	74 27                	je     800649 <vprintfmt+0x27b>
  800622:	85 db                	test   %ebx,%ebx
  800624:	78 9e                	js     8005c4 <vprintfmt+0x1f6>
  800626:	83 eb 01             	sub    $0x1,%ebx
  800629:	79 99                	jns    8005c4 <vprintfmt+0x1f6>
  80062b:	89 f8                	mov    %edi,%eax
  80062d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800630:	8b 75 08             	mov    0x8(%ebp),%esi
  800633:	89 c3                	mov    %eax,%ebx
  800635:	eb 1a                	jmp    800651 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800637:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80063b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800642:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800644:	83 eb 01             	sub    $0x1,%ebx
  800647:	eb 08                	jmp    800651 <vprintfmt+0x283>
  800649:	89 fb                	mov    %edi,%ebx
  80064b:	8b 75 08             	mov    0x8(%ebp),%esi
  80064e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800651:	85 db                	test   %ebx,%ebx
  800653:	7f e2                	jg     800637 <vprintfmt+0x269>
  800655:	89 75 08             	mov    %esi,0x8(%ebp)
  800658:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80065b:	e9 93 fd ff ff       	jmp    8003f3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800660:	83 fa 01             	cmp    $0x1,%edx
  800663:	7e 16                	jle    80067b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8d 50 08             	lea    0x8(%eax),%edx
  80066b:	89 55 14             	mov    %edx,0x14(%ebp)
  80066e:	8b 50 04             	mov    0x4(%eax),%edx
  800671:	8b 00                	mov    (%eax),%eax
  800673:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800676:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800679:	eb 32                	jmp    8006ad <vprintfmt+0x2df>
	else if (lflag)
  80067b:	85 d2                	test   %edx,%edx
  80067d:	74 18                	je     800697 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8d 50 04             	lea    0x4(%eax),%edx
  800685:	89 55 14             	mov    %edx,0x14(%ebp)
  800688:	8b 30                	mov    (%eax),%esi
  80068a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80068d:	89 f0                	mov    %esi,%eax
  80068f:	c1 f8 1f             	sar    $0x1f,%eax
  800692:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800695:	eb 16                	jmp    8006ad <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8d 50 04             	lea    0x4(%eax),%edx
  80069d:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a0:	8b 30                	mov    (%eax),%esi
  8006a2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006a5:	89 f0                	mov    %esi,%eax
  8006a7:	c1 f8 1f             	sar    $0x1f,%eax
  8006aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006bc:	0f 89 80 00 00 00    	jns    800742 <vprintfmt+0x374>
				putch('-', putdat);
  8006c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006cd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006d6:	f7 d8                	neg    %eax
  8006d8:	83 d2 00             	adc    $0x0,%edx
  8006db:	f7 da                	neg    %edx
			}
			base = 10;
  8006dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006e2:	eb 5e                	jmp    800742 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006e7:	e8 63 fc ff ff       	call   80034f <getuint>
			base = 10;
  8006ec:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006f1:	eb 4f                	jmp    800742 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8006f3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f6:	e8 54 fc ff ff       	call   80034f <getuint>
			base = 8;
  8006fb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800700:	eb 40                	jmp    800742 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800702:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800706:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80070d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800710:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800714:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80071b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80071e:	8b 45 14             	mov    0x14(%ebp),%eax
  800721:	8d 50 04             	lea    0x4(%eax),%edx
  800724:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800727:	8b 00                	mov    (%eax),%eax
  800729:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80072e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800733:	eb 0d                	jmp    800742 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800735:	8d 45 14             	lea    0x14(%ebp),%eax
  800738:	e8 12 fc ff ff       	call   80034f <getuint>
			base = 16;
  80073d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800742:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800746:	89 74 24 10          	mov    %esi,0x10(%esp)
  80074a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80074d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800751:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800755:	89 04 24             	mov    %eax,(%esp)
  800758:	89 54 24 04          	mov    %edx,0x4(%esp)
  80075c:	89 fa                	mov    %edi,%edx
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	e8 fa fa ff ff       	call   800260 <printnum>
			break;
  800766:	e9 88 fc ff ff       	jmp    8003f3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80076b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076f:	89 04 24             	mov    %eax,(%esp)
  800772:	ff 55 08             	call   *0x8(%ebp)
			break;
  800775:	e9 79 fc ff ff       	jmp    8003f3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80077a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800785:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800788:	89 f3                	mov    %esi,%ebx
  80078a:	eb 03                	jmp    80078f <vprintfmt+0x3c1>
  80078c:	83 eb 01             	sub    $0x1,%ebx
  80078f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800793:	75 f7                	jne    80078c <vprintfmt+0x3be>
  800795:	e9 59 fc ff ff       	jmp    8003f3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80079a:	83 c4 3c             	add    $0x3c,%esp
  80079d:	5b                   	pop    %ebx
  80079e:	5e                   	pop    %esi
  80079f:	5f                   	pop    %edi
  8007a0:	5d                   	pop    %ebp
  8007a1:	c3                   	ret    

008007a2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	83 ec 28             	sub    $0x28,%esp
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007b1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007b5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	74 30                	je     8007f3 <vsnprintf+0x51>
  8007c3:	85 d2                	test   %edx,%edx
  8007c5:	7e 2c                	jle    8007f3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007dc:	c7 04 24 89 03 80 00 	movl   $0x800389,(%esp)
  8007e3:	e8 e6 fb ff ff       	call   8003ce <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007eb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f1:	eb 05                	jmp    8007f8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007f8:	c9                   	leave  
  8007f9:	c3                   	ret    

008007fa <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007fa:	55                   	push   %ebp
  8007fb:	89 e5                	mov    %esp,%ebp
  8007fd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800800:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800803:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800807:	8b 45 10             	mov    0x10(%ebp),%eax
  80080a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80080e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800811:	89 44 24 04          	mov    %eax,0x4(%esp)
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	89 04 24             	mov    %eax,(%esp)
  80081b:	e8 82 ff ff ff       	call   8007a2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800820:	c9                   	leave  
  800821:	c3                   	ret    
  800822:	66 90                	xchg   %ax,%ax
  800824:	66 90                	xchg   %ax,%ax
  800826:	66 90                	xchg   %ax,%ax
  800828:	66 90                	xchg   %ax,%ax
  80082a:	66 90                	xchg   %ax,%ax
  80082c:	66 90                	xchg   %ax,%ax
  80082e:	66 90                	xchg   %ax,%ax

00800830 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800836:	b8 00 00 00 00       	mov    $0x0,%eax
  80083b:	eb 03                	jmp    800840 <strlen+0x10>
		n++;
  80083d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800840:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800844:	75 f7                	jne    80083d <strlen+0xd>
		n++;
	return n;
}
  800846:	5d                   	pop    %ebp
  800847:	c3                   	ret    

00800848 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80084e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800851:	b8 00 00 00 00       	mov    $0x0,%eax
  800856:	eb 03                	jmp    80085b <strnlen+0x13>
		n++;
  800858:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80085b:	39 d0                	cmp    %edx,%eax
  80085d:	74 06                	je     800865 <strnlen+0x1d>
  80085f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800863:	75 f3                	jne    800858 <strnlen+0x10>
		n++;
	return n;
}
  800865:	5d                   	pop    %ebp
  800866:	c3                   	ret    

00800867 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800867:	55                   	push   %ebp
  800868:	89 e5                	mov    %esp,%ebp
  80086a:	53                   	push   %ebx
  80086b:	8b 45 08             	mov    0x8(%ebp),%eax
  80086e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800871:	89 c2                	mov    %eax,%edx
  800873:	83 c2 01             	add    $0x1,%edx
  800876:	83 c1 01             	add    $0x1,%ecx
  800879:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80087d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800880:	84 db                	test   %bl,%bl
  800882:	75 ef                	jne    800873 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800884:	5b                   	pop    %ebx
  800885:	5d                   	pop    %ebp
  800886:	c3                   	ret    

00800887 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800887:	55                   	push   %ebp
  800888:	89 e5                	mov    %esp,%ebp
  80088a:	53                   	push   %ebx
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800891:	89 1c 24             	mov    %ebx,(%esp)
  800894:	e8 97 ff ff ff       	call   800830 <strlen>
	strcpy(dst + len, src);
  800899:	8b 55 0c             	mov    0xc(%ebp),%edx
  80089c:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008a0:	01 d8                	add    %ebx,%eax
  8008a2:	89 04 24             	mov    %eax,(%esp)
  8008a5:	e8 bd ff ff ff       	call   800867 <strcpy>
	return dst;
}
  8008aa:	89 d8                	mov    %ebx,%eax
  8008ac:	83 c4 08             	add    $0x8,%esp
  8008af:	5b                   	pop    %ebx
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    

008008b2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	56                   	push   %esi
  8008b6:	53                   	push   %ebx
  8008b7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008bd:	89 f3                	mov    %esi,%ebx
  8008bf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008c2:	89 f2                	mov    %esi,%edx
  8008c4:	eb 0f                	jmp    8008d5 <strncpy+0x23>
		*dst++ = *src;
  8008c6:	83 c2 01             	add    $0x1,%edx
  8008c9:	0f b6 01             	movzbl (%ecx),%eax
  8008cc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008cf:	80 39 01             	cmpb   $0x1,(%ecx)
  8008d2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d5:	39 da                	cmp    %ebx,%edx
  8008d7:	75 ed                	jne    8008c6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008d9:	89 f0                	mov    %esi,%eax
  8008db:	5b                   	pop    %ebx
  8008dc:	5e                   	pop    %esi
  8008dd:	5d                   	pop    %ebp
  8008de:	c3                   	ret    

008008df <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008df:	55                   	push   %ebp
  8008e0:	89 e5                	mov    %esp,%ebp
  8008e2:	56                   	push   %esi
  8008e3:	53                   	push   %ebx
  8008e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008ed:	89 f0                	mov    %esi,%eax
  8008ef:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008f3:	85 c9                	test   %ecx,%ecx
  8008f5:	75 0b                	jne    800902 <strlcpy+0x23>
  8008f7:	eb 1d                	jmp    800916 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008f9:	83 c0 01             	add    $0x1,%eax
  8008fc:	83 c2 01             	add    $0x1,%edx
  8008ff:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800902:	39 d8                	cmp    %ebx,%eax
  800904:	74 0b                	je     800911 <strlcpy+0x32>
  800906:	0f b6 0a             	movzbl (%edx),%ecx
  800909:	84 c9                	test   %cl,%cl
  80090b:	75 ec                	jne    8008f9 <strlcpy+0x1a>
  80090d:	89 c2                	mov    %eax,%edx
  80090f:	eb 02                	jmp    800913 <strlcpy+0x34>
  800911:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800913:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800916:	29 f0                	sub    %esi,%eax
}
  800918:	5b                   	pop    %ebx
  800919:	5e                   	pop    %esi
  80091a:	5d                   	pop    %ebp
  80091b:	c3                   	ret    

0080091c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800922:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800925:	eb 06                	jmp    80092d <strcmp+0x11>
		p++, q++;
  800927:	83 c1 01             	add    $0x1,%ecx
  80092a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80092d:	0f b6 01             	movzbl (%ecx),%eax
  800930:	84 c0                	test   %al,%al
  800932:	74 04                	je     800938 <strcmp+0x1c>
  800934:	3a 02                	cmp    (%edx),%al
  800936:	74 ef                	je     800927 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800938:	0f b6 c0             	movzbl %al,%eax
  80093b:	0f b6 12             	movzbl (%edx),%edx
  80093e:	29 d0                	sub    %edx,%eax
}
  800940:	5d                   	pop    %ebp
  800941:	c3                   	ret    

00800942 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800942:	55                   	push   %ebp
  800943:	89 e5                	mov    %esp,%ebp
  800945:	53                   	push   %ebx
  800946:	8b 45 08             	mov    0x8(%ebp),%eax
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094c:	89 c3                	mov    %eax,%ebx
  80094e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800951:	eb 06                	jmp    800959 <strncmp+0x17>
		n--, p++, q++;
  800953:	83 c0 01             	add    $0x1,%eax
  800956:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800959:	39 d8                	cmp    %ebx,%eax
  80095b:	74 15                	je     800972 <strncmp+0x30>
  80095d:	0f b6 08             	movzbl (%eax),%ecx
  800960:	84 c9                	test   %cl,%cl
  800962:	74 04                	je     800968 <strncmp+0x26>
  800964:	3a 0a                	cmp    (%edx),%cl
  800966:	74 eb                	je     800953 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800968:	0f b6 00             	movzbl (%eax),%eax
  80096b:	0f b6 12             	movzbl (%edx),%edx
  80096e:	29 d0                	sub    %edx,%eax
  800970:	eb 05                	jmp    800977 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800972:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800977:	5b                   	pop    %ebx
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800984:	eb 07                	jmp    80098d <strchr+0x13>
		if (*s == c)
  800986:	38 ca                	cmp    %cl,%dl
  800988:	74 0f                	je     800999 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80098a:	83 c0 01             	add    $0x1,%eax
  80098d:	0f b6 10             	movzbl (%eax),%edx
  800990:	84 d2                	test   %dl,%dl
  800992:	75 f2                	jne    800986 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800994:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009a5:	eb 07                	jmp    8009ae <strfind+0x13>
		if (*s == c)
  8009a7:	38 ca                	cmp    %cl,%dl
  8009a9:	74 0a                	je     8009b5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009ab:	83 c0 01             	add    $0x1,%eax
  8009ae:	0f b6 10             	movzbl (%eax),%edx
  8009b1:	84 d2                	test   %dl,%dl
  8009b3:	75 f2                	jne    8009a7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	57                   	push   %edi
  8009bb:	56                   	push   %esi
  8009bc:	53                   	push   %ebx
  8009bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009c3:	85 c9                	test   %ecx,%ecx
  8009c5:	74 36                	je     8009fd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009c7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009cd:	75 28                	jne    8009f7 <memset+0x40>
  8009cf:	f6 c1 03             	test   $0x3,%cl
  8009d2:	75 23                	jne    8009f7 <memset+0x40>
		c &= 0xFF;
  8009d4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009d8:	89 d3                	mov    %edx,%ebx
  8009da:	c1 e3 08             	shl    $0x8,%ebx
  8009dd:	89 d6                	mov    %edx,%esi
  8009df:	c1 e6 18             	shl    $0x18,%esi
  8009e2:	89 d0                	mov    %edx,%eax
  8009e4:	c1 e0 10             	shl    $0x10,%eax
  8009e7:	09 f0                	or     %esi,%eax
  8009e9:	09 c2                	or     %eax,%edx
  8009eb:	89 d0                	mov    %edx,%eax
  8009ed:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009ef:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009f2:	fc                   	cld    
  8009f3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009f5:	eb 06                	jmp    8009fd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fa:	fc                   	cld    
  8009fb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009fd:	89 f8                	mov    %edi,%eax
  8009ff:	5b                   	pop    %ebx
  800a00:	5e                   	pop    %esi
  800a01:	5f                   	pop    %edi
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	57                   	push   %edi
  800a08:	56                   	push   %esi
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a0f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a12:	39 c6                	cmp    %eax,%esi
  800a14:	73 35                	jae    800a4b <memmove+0x47>
  800a16:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a19:	39 d0                	cmp    %edx,%eax
  800a1b:	73 2e                	jae    800a4b <memmove+0x47>
		s += n;
		d += n;
  800a1d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a20:	89 d6                	mov    %edx,%esi
  800a22:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a24:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a2a:	75 13                	jne    800a3f <memmove+0x3b>
  800a2c:	f6 c1 03             	test   $0x3,%cl
  800a2f:	75 0e                	jne    800a3f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a31:	83 ef 04             	sub    $0x4,%edi
  800a34:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a37:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a3a:	fd                   	std    
  800a3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a3d:	eb 09                	jmp    800a48 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a3f:	83 ef 01             	sub    $0x1,%edi
  800a42:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a45:	fd                   	std    
  800a46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a48:	fc                   	cld    
  800a49:	eb 1d                	jmp    800a68 <memmove+0x64>
  800a4b:	89 f2                	mov    %esi,%edx
  800a4d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a4f:	f6 c2 03             	test   $0x3,%dl
  800a52:	75 0f                	jne    800a63 <memmove+0x5f>
  800a54:	f6 c1 03             	test   $0x3,%cl
  800a57:	75 0a                	jne    800a63 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a59:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a5c:	89 c7                	mov    %eax,%edi
  800a5e:	fc                   	cld    
  800a5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a61:	eb 05                	jmp    800a68 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a63:	89 c7                	mov    %eax,%edi
  800a65:	fc                   	cld    
  800a66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a68:	5e                   	pop    %esi
  800a69:	5f                   	pop    %edi
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    

00800a6c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a72:	8b 45 10             	mov    0x10(%ebp),%eax
  800a75:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 04 24             	mov    %eax,(%esp)
  800a86:	e8 79 ff ff ff       	call   800a04 <memmove>
}
  800a8b:	c9                   	leave  
  800a8c:	c3                   	ret    

00800a8d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a8d:	55                   	push   %ebp
  800a8e:	89 e5                	mov    %esp,%ebp
  800a90:	56                   	push   %esi
  800a91:	53                   	push   %ebx
  800a92:	8b 55 08             	mov    0x8(%ebp),%edx
  800a95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a98:	89 d6                	mov    %edx,%esi
  800a9a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a9d:	eb 1a                	jmp    800ab9 <memcmp+0x2c>
		if (*s1 != *s2)
  800a9f:	0f b6 02             	movzbl (%edx),%eax
  800aa2:	0f b6 19             	movzbl (%ecx),%ebx
  800aa5:	38 d8                	cmp    %bl,%al
  800aa7:	74 0a                	je     800ab3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800aa9:	0f b6 c0             	movzbl %al,%eax
  800aac:	0f b6 db             	movzbl %bl,%ebx
  800aaf:	29 d8                	sub    %ebx,%eax
  800ab1:	eb 0f                	jmp    800ac2 <memcmp+0x35>
		s1++, s2++;
  800ab3:	83 c2 01             	add    $0x1,%edx
  800ab6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ab9:	39 f2                	cmp    %esi,%edx
  800abb:	75 e2                	jne    800a9f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800abd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac2:	5b                   	pop    %ebx
  800ac3:	5e                   	pop    %esi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800acf:	89 c2                	mov    %eax,%edx
  800ad1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ad4:	eb 07                	jmp    800add <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ad6:	38 08                	cmp    %cl,(%eax)
  800ad8:	74 07                	je     800ae1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ada:	83 c0 01             	add    $0x1,%eax
  800add:	39 d0                	cmp    %edx,%eax
  800adf:	72 f5                	jb     800ad6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	57                   	push   %edi
  800ae7:	56                   	push   %esi
  800ae8:	53                   	push   %ebx
  800ae9:	8b 55 08             	mov    0x8(%ebp),%edx
  800aec:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800aef:	eb 03                	jmp    800af4 <strtol+0x11>
		s++;
  800af1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800af4:	0f b6 0a             	movzbl (%edx),%ecx
  800af7:	80 f9 09             	cmp    $0x9,%cl
  800afa:	74 f5                	je     800af1 <strtol+0xe>
  800afc:	80 f9 20             	cmp    $0x20,%cl
  800aff:	74 f0                	je     800af1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b01:	80 f9 2b             	cmp    $0x2b,%cl
  800b04:	75 0a                	jne    800b10 <strtol+0x2d>
		s++;
  800b06:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b09:	bf 00 00 00 00       	mov    $0x0,%edi
  800b0e:	eb 11                	jmp    800b21 <strtol+0x3e>
  800b10:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b15:	80 f9 2d             	cmp    $0x2d,%cl
  800b18:	75 07                	jne    800b21 <strtol+0x3e>
		s++, neg = 1;
  800b1a:	8d 52 01             	lea    0x1(%edx),%edx
  800b1d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b21:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b26:	75 15                	jne    800b3d <strtol+0x5a>
  800b28:	80 3a 30             	cmpb   $0x30,(%edx)
  800b2b:	75 10                	jne    800b3d <strtol+0x5a>
  800b2d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b31:	75 0a                	jne    800b3d <strtol+0x5a>
		s += 2, base = 16;
  800b33:	83 c2 02             	add    $0x2,%edx
  800b36:	b8 10 00 00 00       	mov    $0x10,%eax
  800b3b:	eb 10                	jmp    800b4d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b3d:	85 c0                	test   %eax,%eax
  800b3f:	75 0c                	jne    800b4d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b41:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b43:	80 3a 30             	cmpb   $0x30,(%edx)
  800b46:	75 05                	jne    800b4d <strtol+0x6a>
		s++, base = 8;
  800b48:	83 c2 01             	add    $0x1,%edx
  800b4b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b52:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b55:	0f b6 0a             	movzbl (%edx),%ecx
  800b58:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b5b:	89 f0                	mov    %esi,%eax
  800b5d:	3c 09                	cmp    $0x9,%al
  800b5f:	77 08                	ja     800b69 <strtol+0x86>
			dig = *s - '0';
  800b61:	0f be c9             	movsbl %cl,%ecx
  800b64:	83 e9 30             	sub    $0x30,%ecx
  800b67:	eb 20                	jmp    800b89 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b69:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b6c:	89 f0                	mov    %esi,%eax
  800b6e:	3c 19                	cmp    $0x19,%al
  800b70:	77 08                	ja     800b7a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b72:	0f be c9             	movsbl %cl,%ecx
  800b75:	83 e9 57             	sub    $0x57,%ecx
  800b78:	eb 0f                	jmp    800b89 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b7a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	3c 19                	cmp    $0x19,%al
  800b81:	77 16                	ja     800b99 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b83:	0f be c9             	movsbl %cl,%ecx
  800b86:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b89:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b8c:	7d 0f                	jge    800b9d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b8e:	83 c2 01             	add    $0x1,%edx
  800b91:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b95:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b97:	eb bc                	jmp    800b55 <strtol+0x72>
  800b99:	89 d8                	mov    %ebx,%eax
  800b9b:	eb 02                	jmp    800b9f <strtol+0xbc>
  800b9d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ba3:	74 05                	je     800baa <strtol+0xc7>
		*endptr = (char *) s;
  800ba5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ba8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800baa:	f7 d8                	neg    %eax
  800bac:	85 ff                	test   %edi,%edi
  800bae:	0f 44 c3             	cmove  %ebx,%eax
}
  800bb1:	5b                   	pop    %ebx
  800bb2:	5e                   	pop    %esi
  800bb3:	5f                   	pop    %edi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	57                   	push   %edi
  800bba:	56                   	push   %esi
  800bbb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc7:	89 c3                	mov    %eax,%ebx
  800bc9:	89 c7                	mov    %eax,%edi
  800bcb:	89 c6                	mov    %eax,%esi
  800bcd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	57                   	push   %edi
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bda:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdf:	b8 01 00 00 00       	mov    $0x1,%eax
  800be4:	89 d1                	mov    %edx,%ecx
  800be6:	89 d3                	mov    %edx,%ebx
  800be8:	89 d7                	mov    %edx,%edi
  800bea:	89 d6                	mov    %edx,%esi
  800bec:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c01:	b8 03 00 00 00       	mov    $0x3,%eax
  800c06:	8b 55 08             	mov    0x8(%ebp),%edx
  800c09:	89 cb                	mov    %ecx,%ebx
  800c0b:	89 cf                	mov    %ecx,%edi
  800c0d:	89 ce                	mov    %ecx,%esi
  800c0f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800c11:	85 c0                	test   %eax,%eax
  800c13:	7e 28                	jle    800c3d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c15:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c19:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c20:	00 
  800c21:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800c28:	00 
  800c29:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c30:	00 
  800c31:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800c38:	e8 04 f5 ff ff       	call   800141 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c3d:	83 c4 2c             	add    $0x2c,%esp
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5f                   	pop    %edi
  800c43:	5d                   	pop    %ebp
  800c44:	c3                   	ret    

00800c45 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c45:	55                   	push   %ebp
  800c46:	89 e5                	mov    %esp,%ebp
  800c48:	57                   	push   %edi
  800c49:	56                   	push   %esi
  800c4a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c50:	b8 02 00 00 00       	mov    $0x2,%eax
  800c55:	89 d1                	mov    %edx,%ecx
  800c57:	89 d3                	mov    %edx,%ebx
  800c59:	89 d7                	mov    %edx,%edi
  800c5b:	89 d6                	mov    %edx,%esi
  800c5d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5f                   	pop    %edi
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <sys_yield>:

void
sys_yield(void)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	57                   	push   %edi
  800c68:	56                   	push   %esi
  800c69:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c74:	89 d1                	mov    %edx,%ecx
  800c76:	89 d3                	mov    %edx,%ebx
  800c78:	89 d7                	mov    %edx,%edi
  800c7a:	89 d6                	mov    %edx,%esi
  800c7c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	57                   	push   %edi
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
  800c89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c8c:	be 00 00 00 00       	mov    $0x0,%esi
  800c91:	b8 04 00 00 00       	mov    $0x4,%eax
  800c96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c99:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c9f:	89 f7                	mov    %esi,%edi
  800ca1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ca3:	85 c0                	test   %eax,%eax
  800ca5:	7e 28                	jle    800ccf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cab:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cb2:	00 
  800cb3:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800cba:	00 
  800cbb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc2:	00 
  800cc3:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800cca:	e8 72 f4 ff ff       	call   800141 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ccf:	83 c4 2c             	add    $0x2c,%esp
  800cd2:	5b                   	pop    %ebx
  800cd3:	5e                   	pop    %esi
  800cd4:	5f                   	pop    %edi
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce0:	b8 05 00 00 00       	mov    $0x5,%eax
  800ce5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ceb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cee:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cf1:	8b 75 18             	mov    0x18(%ebp),%esi
  800cf4:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	7e 28                	jle    800d22 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cfa:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cfe:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d05:	00 
  800d06:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800d0d:	00 
  800d0e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d15:	00 
  800d16:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800d1d:	e8 1f f4 ff ff       	call   800141 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d22:	83 c4 2c             	add    $0x2c,%esp
  800d25:	5b                   	pop    %ebx
  800d26:	5e                   	pop    %esi
  800d27:	5f                   	pop    %edi
  800d28:	5d                   	pop    %ebp
  800d29:	c3                   	ret    

00800d2a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	57                   	push   %edi
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d33:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d38:	b8 06 00 00 00       	mov    $0x6,%eax
  800d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d40:	8b 55 08             	mov    0x8(%ebp),%edx
  800d43:	89 df                	mov    %ebx,%edi
  800d45:	89 de                	mov    %ebx,%esi
  800d47:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d49:	85 c0                	test   %eax,%eax
  800d4b:	7e 28                	jle    800d75 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d51:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d58:	00 
  800d59:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800d60:	00 
  800d61:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d68:	00 
  800d69:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800d70:	e8 cc f3 ff ff       	call   800141 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d75:	83 c4 2c             	add    $0x2c,%esp
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5f                   	pop    %edi
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    

00800d7d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
  800d83:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d86:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d8b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	89 df                	mov    %ebx,%edi
  800d98:	89 de                	mov    %ebx,%esi
  800d9a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	7e 28                	jle    800dc8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800dab:	00 
  800dac:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800db3:	00 
  800db4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dbb:	00 
  800dbc:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800dc3:	e8 79 f3 ff ff       	call   800141 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dc8:	83 c4 2c             	add    $0x2c,%esp
  800dcb:	5b                   	pop    %ebx
  800dcc:	5e                   	pop    %esi
  800dcd:	5f                   	pop    %edi
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	57                   	push   %edi
  800dd4:	56                   	push   %esi
  800dd5:	53                   	push   %ebx
  800dd6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dde:	b8 09 00 00 00       	mov    $0x9,%eax
  800de3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	89 df                	mov    %ebx,%edi
  800deb:	89 de                	mov    %ebx,%esi
  800ded:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800def:	85 c0                	test   %eax,%eax
  800df1:	7e 28                	jle    800e1b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dfe:	00 
  800dff:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800e06:	00 
  800e07:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e0e:	00 
  800e0f:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800e16:	e8 26 f3 ff ff       	call   800141 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e1b:	83 c4 2c             	add    $0x2c,%esp
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	57                   	push   %edi
  800e27:	56                   	push   %esi
  800e28:	53                   	push   %ebx
  800e29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e39:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3c:	89 df                	mov    %ebx,%edi
  800e3e:	89 de                	mov    %ebx,%esi
  800e40:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e42:	85 c0                	test   %eax,%eax
  800e44:	7e 28                	jle    800e6e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e46:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e4a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e51:	00 
  800e52:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800e59:	00 
  800e5a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e61:	00 
  800e62:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800e69:	e8 d3 f2 ff ff       	call   800141 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e6e:	83 c4 2c             	add    $0x2c,%esp
  800e71:	5b                   	pop    %ebx
  800e72:	5e                   	pop    %esi
  800e73:	5f                   	pop    %edi
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	57                   	push   %edi
  800e7a:	56                   	push   %esi
  800e7b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7c:	be 00 00 00 00       	mov    $0x0,%esi
  800e81:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e86:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e89:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e92:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	57                   	push   %edi
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
  800e9f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eac:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaf:	89 cb                	mov    %ecx,%ebx
  800eb1:	89 cf                	mov    %ecx,%edi
  800eb3:	89 ce                	mov    %ecx,%esi
  800eb5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	7e 28                	jle    800ee3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ebf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ec6:	00 
  800ec7:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800ece:	00 
  800ecf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed6:	00 
  800ed7:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800ede:	e8 5e f2 ff ff       	call   800141 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ee3:	83 c4 2c             	add    $0x2c,%esp
  800ee6:	5b                   	pop    %ebx
  800ee7:	5e                   	pop    %esi
  800ee8:	5f                   	pop    %edi
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    

00800eeb <sys_time_msec>:

unsigned int
sys_time_msec(void)
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
  800ef1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800efb:	89 d1                	mov    %edx,%ecx
  800efd:	89 d3                	mov    %edx,%ebx
  800eff:	89 d7                	mov    %edx,%edi
  800f01:	89 d6                	mov    %edx,%esi
  800f03:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	57                   	push   %edi
  800f0e:	56                   	push   %esi
  800f0f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f10:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f15:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f20:	89 df                	mov    %ebx,%edi
  800f22:	89 de                	mov    %ebx,%esi
  800f24:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800f26:	5b                   	pop    %ebx
  800f27:	5e                   	pop    %esi
  800f28:	5f                   	pop    %edi
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    

00800f2b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	57                   	push   %edi
  800f2f:	56                   	push   %esi
  800f30:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f31:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f36:	b8 10 00 00 00       	mov    $0x10,%eax
  800f3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	89 df                	mov    %ebx,%edi
  800f43:	89 de                	mov    %ebx,%esi
  800f45:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800f47:	5b                   	pop    %ebx
  800f48:	5e                   	pop    %esi
  800f49:	5f                   	pop    %edi
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    

00800f4c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	57                   	push   %edi
  800f50:	56                   	push   %esi
  800f51:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f57:	b8 11 00 00 00       	mov    $0x11,%eax
  800f5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5f:	89 cb                	mov    %ecx,%ebx
  800f61:	89 cf                	mov    %ecx,%edi
  800f63:	89 ce                	mov    %ecx,%esi
  800f65:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  800f67:	5b                   	pop    %ebx
  800f68:	5e                   	pop    %esi
  800f69:	5f                   	pop    %edi
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	57                   	push   %edi
  800f70:	56                   	push   %esi
  800f71:	53                   	push   %ebx
  800f72:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f75:	be 00 00 00 00       	mov    $0x0,%esi
  800f7a:	b8 12 00 00 00       	mov    $0x12,%eax
  800f7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f82:	8b 55 08             	mov    0x8(%ebp),%edx
  800f85:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f88:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f8b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	7e 28                	jle    800fb9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f91:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f95:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800f9c:	00 
  800f9d:	c7 44 24 08 47 2b 80 	movl   $0x802b47,0x8(%esp)
  800fa4:	00 
  800fa5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fac:	00 
  800fad:	c7 04 24 64 2b 80 00 	movl   $0x802b64,(%esp)
  800fb4:	e8 88 f1 ff ff       	call   800141 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  800fb9:	83 c4 2c             	add    $0x2c,%esp
  800fbc:	5b                   	pop    %ebx
  800fbd:	5e                   	pop    %esi
  800fbe:	5f                   	pop    %edi
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    

00800fc1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  800fc7:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800fce:	75 68                	jne    801038 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  800fd0:	a1 08 40 80 00       	mov    0x804008,%eax
  800fd5:	8b 40 48             	mov    0x48(%eax),%eax
  800fd8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800fdf:	00 
  800fe0:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800fe7:	ee 
  800fe8:	89 04 24             	mov    %eax,(%esp)
  800feb:	e8 93 fc ff ff       	call   800c83 <sys_page_alloc>
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	74 2c                	je     801020 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  800ff4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ff8:	c7 04 24 74 2b 80 00 	movl   $0x802b74,(%esp)
  800fff:	e8 36 f2 ff ff       	call   80023a <cprintf>
			panic("set_pg_fault_handler");
  801004:	c7 44 24 08 a7 2b 80 	movl   $0x802ba7,0x8(%esp)
  80100b:	00 
  80100c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  801013:	00 
  801014:	c7 04 24 bc 2b 80 00 	movl   $0x802bbc,(%esp)
  80101b:	e8 21 f1 ff ff       	call   800141 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  801020:	a1 08 40 80 00       	mov    0x804008,%eax
  801025:	8b 40 48             	mov    0x48(%eax),%eax
  801028:	c7 44 24 04 42 10 80 	movl   $0x801042,0x4(%esp)
  80102f:	00 
  801030:	89 04 24             	mov    %eax,(%esp)
  801033:	e8 eb fd ff ff       	call   800e23 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801042:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801043:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  801048:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80104a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  80104d:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  801051:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  801053:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  801057:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  801058:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  80105b:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  80105d:	58                   	pop    %eax
	popl %eax
  80105e:	58                   	pop    %eax
	popal
  80105f:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  801060:	83 c4 04             	add    $0x4,%esp
	popfl
  801063:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801064:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  801065:	c3                   	ret    
  801066:	66 90                	xchg   %ax,%ax
  801068:	66 90                	xchg   %ax,%ax
  80106a:	66 90                	xchg   %ax,%ax
  80106c:	66 90                	xchg   %ax,%ax
  80106e:	66 90                	xchg   %ax,%ax

00801070 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801070:	55                   	push   %ebp
  801071:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	05 00 00 00 30       	add    $0x30000000,%eax
  80107b:	c1 e8 0c             	shr    $0xc,%eax
}
  80107e:	5d                   	pop    %ebp
  80107f:	c3                   	ret    

00801080 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80108b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801090:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801095:	5d                   	pop    %ebp
  801096:	c3                   	ret    

00801097 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	c1 ea 16             	shr    $0x16,%edx
  8010a7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010ae:	f6 c2 01             	test   $0x1,%dl
  8010b1:	74 11                	je     8010c4 <fd_alloc+0x2d>
  8010b3:	89 c2                	mov    %eax,%edx
  8010b5:	c1 ea 0c             	shr    $0xc,%edx
  8010b8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010bf:	f6 c2 01             	test   $0x1,%dl
  8010c2:	75 09                	jne    8010cd <fd_alloc+0x36>
			*fd_store = fd;
  8010c4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010cb:	eb 17                	jmp    8010e4 <fd_alloc+0x4d>
  8010cd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8010d2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010d7:	75 c9                	jne    8010a2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010d9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8010df:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8010e4:	5d                   	pop    %ebp
  8010e5:	c3                   	ret    

008010e6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010ec:	83 f8 1f             	cmp    $0x1f,%eax
  8010ef:	77 36                	ja     801127 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010f1:	c1 e0 0c             	shl    $0xc,%eax
  8010f4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010f9:	89 c2                	mov    %eax,%edx
  8010fb:	c1 ea 16             	shr    $0x16,%edx
  8010fe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801105:	f6 c2 01             	test   $0x1,%dl
  801108:	74 24                	je     80112e <fd_lookup+0x48>
  80110a:	89 c2                	mov    %eax,%edx
  80110c:	c1 ea 0c             	shr    $0xc,%edx
  80110f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801116:	f6 c2 01             	test   $0x1,%dl
  801119:	74 1a                	je     801135 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80111b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111e:	89 02                	mov    %eax,(%edx)
	return 0;
  801120:	b8 00 00 00 00       	mov    $0x0,%eax
  801125:	eb 13                	jmp    80113a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801127:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80112c:	eb 0c                	jmp    80113a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80112e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801133:	eb 05                	jmp    80113a <fd_lookup+0x54>
  801135:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80113a:	5d                   	pop    %ebp
  80113b:	c3                   	ret    

0080113c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	83 ec 18             	sub    $0x18,%esp
  801142:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801145:	ba 00 00 00 00       	mov    $0x0,%edx
  80114a:	eb 13                	jmp    80115f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80114c:	39 08                	cmp    %ecx,(%eax)
  80114e:	75 0c                	jne    80115c <dev_lookup+0x20>
			*dev = devtab[i];
  801150:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801153:	89 01                	mov    %eax,(%ecx)
			return 0;
  801155:	b8 00 00 00 00       	mov    $0x0,%eax
  80115a:	eb 38                	jmp    801194 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80115c:	83 c2 01             	add    $0x1,%edx
  80115f:	8b 04 95 4c 2c 80 00 	mov    0x802c4c(,%edx,4),%eax
  801166:	85 c0                	test   %eax,%eax
  801168:	75 e2                	jne    80114c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80116a:	a1 08 40 80 00       	mov    0x804008,%eax
  80116f:	8b 40 48             	mov    0x48(%eax),%eax
  801172:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801176:	89 44 24 04          	mov    %eax,0x4(%esp)
  80117a:	c7 04 24 cc 2b 80 00 	movl   $0x802bcc,(%esp)
  801181:	e8 b4 f0 ff ff       	call   80023a <cprintf>
	*dev = 0;
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80118f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801194:	c9                   	leave  
  801195:	c3                   	ret    

00801196 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	56                   	push   %esi
  80119a:	53                   	push   %ebx
  80119b:	83 ec 20             	sub    $0x20,%esp
  80119e:	8b 75 08             	mov    0x8(%ebp),%esi
  8011a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011ab:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011b1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011b4:	89 04 24             	mov    %eax,(%esp)
  8011b7:	e8 2a ff ff ff       	call   8010e6 <fd_lookup>
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	78 05                	js     8011c5 <fd_close+0x2f>
	    || fd != fd2)
  8011c0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8011c3:	74 0c                	je     8011d1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8011c5:	84 db                	test   %bl,%bl
  8011c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011cc:	0f 44 c2             	cmove  %edx,%eax
  8011cf:	eb 3f                	jmp    801210 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011d8:	8b 06                	mov    (%esi),%eax
  8011da:	89 04 24             	mov    %eax,(%esp)
  8011dd:	e8 5a ff ff ff       	call   80113c <dev_lookup>
  8011e2:	89 c3                	mov    %eax,%ebx
  8011e4:	85 c0                	test   %eax,%eax
  8011e6:	78 16                	js     8011fe <fd_close+0x68>
		if (dev->dev_close)
  8011e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011eb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8011ee:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	74 07                	je     8011fe <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8011f7:	89 34 24             	mov    %esi,(%esp)
  8011fa:	ff d0                	call   *%eax
  8011fc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8011fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801202:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801209:	e8 1c fb ff ff       	call   800d2a <sys_page_unmap>
	return r;
  80120e:	89 d8                	mov    %ebx,%eax
}
  801210:	83 c4 20             	add    $0x20,%esp
  801213:	5b                   	pop    %ebx
  801214:	5e                   	pop    %esi
  801215:	5d                   	pop    %ebp
  801216:	c3                   	ret    

00801217 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801217:	55                   	push   %ebp
  801218:	89 e5                	mov    %esp,%ebp
  80121a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80121d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801220:	89 44 24 04          	mov    %eax,0x4(%esp)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	89 04 24             	mov    %eax,(%esp)
  80122a:	e8 b7 fe ff ff       	call   8010e6 <fd_lookup>
  80122f:	89 c2                	mov    %eax,%edx
  801231:	85 d2                	test   %edx,%edx
  801233:	78 13                	js     801248 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801235:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80123c:	00 
  80123d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801240:	89 04 24             	mov    %eax,(%esp)
  801243:	e8 4e ff ff ff       	call   801196 <fd_close>
}
  801248:	c9                   	leave  
  801249:	c3                   	ret    

0080124a <close_all>:

void
close_all(void)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	53                   	push   %ebx
  80124e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801251:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801256:	89 1c 24             	mov    %ebx,(%esp)
  801259:	e8 b9 ff ff ff       	call   801217 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80125e:	83 c3 01             	add    $0x1,%ebx
  801261:	83 fb 20             	cmp    $0x20,%ebx
  801264:	75 f0                	jne    801256 <close_all+0xc>
		close(i);
}
  801266:	83 c4 14             	add    $0x14,%esp
  801269:	5b                   	pop    %ebx
  80126a:	5d                   	pop    %ebp
  80126b:	c3                   	ret    

0080126c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
  80126f:	57                   	push   %edi
  801270:	56                   	push   %esi
  801271:	53                   	push   %ebx
  801272:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801275:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801278:	89 44 24 04          	mov    %eax,0x4(%esp)
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	89 04 24             	mov    %eax,(%esp)
  801282:	e8 5f fe ff ff       	call   8010e6 <fd_lookup>
  801287:	89 c2                	mov    %eax,%edx
  801289:	85 d2                	test   %edx,%edx
  80128b:	0f 88 e1 00 00 00    	js     801372 <dup+0x106>
		return r;
	close(newfdnum);
  801291:	8b 45 0c             	mov    0xc(%ebp),%eax
  801294:	89 04 24             	mov    %eax,(%esp)
  801297:	e8 7b ff ff ff       	call   801217 <close>

	newfd = INDEX2FD(newfdnum);
  80129c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80129f:	c1 e3 0c             	shl    $0xc,%ebx
  8012a2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8012a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012ab:	89 04 24             	mov    %eax,(%esp)
  8012ae:	e8 cd fd ff ff       	call   801080 <fd2data>
  8012b3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8012b5:	89 1c 24             	mov    %ebx,(%esp)
  8012b8:	e8 c3 fd ff ff       	call   801080 <fd2data>
  8012bd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012bf:	89 f0                	mov    %esi,%eax
  8012c1:	c1 e8 16             	shr    $0x16,%eax
  8012c4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012cb:	a8 01                	test   $0x1,%al
  8012cd:	74 43                	je     801312 <dup+0xa6>
  8012cf:	89 f0                	mov    %esi,%eax
  8012d1:	c1 e8 0c             	shr    $0xc,%eax
  8012d4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012db:	f6 c2 01             	test   $0x1,%dl
  8012de:	74 32                	je     801312 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012f0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012fb:	00 
  8012fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801300:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801307:	e8 cb f9 ff ff       	call   800cd7 <sys_page_map>
  80130c:	89 c6                	mov    %eax,%esi
  80130e:	85 c0                	test   %eax,%eax
  801310:	78 3e                	js     801350 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801312:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801315:	89 c2                	mov    %eax,%edx
  801317:	c1 ea 0c             	shr    $0xc,%edx
  80131a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801321:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801327:	89 54 24 10          	mov    %edx,0x10(%esp)
  80132b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80132f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801336:	00 
  801337:	89 44 24 04          	mov    %eax,0x4(%esp)
  80133b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801342:	e8 90 f9 ff ff       	call   800cd7 <sys_page_map>
  801347:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80134c:	85 f6                	test   %esi,%esi
  80134e:	79 22                	jns    801372 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801350:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801354:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80135b:	e8 ca f9 ff ff       	call   800d2a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801360:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801364:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80136b:	e8 ba f9 ff ff       	call   800d2a <sys_page_unmap>
	return r;
  801370:	89 f0                	mov    %esi,%eax
}
  801372:	83 c4 3c             	add    $0x3c,%esp
  801375:	5b                   	pop    %ebx
  801376:	5e                   	pop    %esi
  801377:	5f                   	pop    %edi
  801378:	5d                   	pop    %ebp
  801379:	c3                   	ret    

0080137a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	53                   	push   %ebx
  80137e:	83 ec 24             	sub    $0x24,%esp
  801381:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801384:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801387:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138b:	89 1c 24             	mov    %ebx,(%esp)
  80138e:	e8 53 fd ff ff       	call   8010e6 <fd_lookup>
  801393:	89 c2                	mov    %eax,%edx
  801395:	85 d2                	test   %edx,%edx
  801397:	78 6d                	js     801406 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801399:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80139c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a3:	8b 00                	mov    (%eax),%eax
  8013a5:	89 04 24             	mov    %eax,(%esp)
  8013a8:	e8 8f fd ff ff       	call   80113c <dev_lookup>
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	78 55                	js     801406 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b4:	8b 50 08             	mov    0x8(%eax),%edx
  8013b7:	83 e2 03             	and    $0x3,%edx
  8013ba:	83 fa 01             	cmp    $0x1,%edx
  8013bd:	75 23                	jne    8013e2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013bf:	a1 08 40 80 00       	mov    0x804008,%eax
  8013c4:	8b 40 48             	mov    0x48(%eax),%eax
  8013c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013cf:	c7 04 24 10 2c 80 00 	movl   $0x802c10,(%esp)
  8013d6:	e8 5f ee ff ff       	call   80023a <cprintf>
		return -E_INVAL;
  8013db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013e0:	eb 24                	jmp    801406 <read+0x8c>
	}
	if (!dev->dev_read)
  8013e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e5:	8b 52 08             	mov    0x8(%edx),%edx
  8013e8:	85 d2                	test   %edx,%edx
  8013ea:	74 15                	je     801401 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8013fa:	89 04 24             	mov    %eax,(%esp)
  8013fd:	ff d2                	call   *%edx
  8013ff:	eb 05                	jmp    801406 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801401:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801406:	83 c4 24             	add    $0x24,%esp
  801409:	5b                   	pop    %ebx
  80140a:	5d                   	pop    %ebp
  80140b:	c3                   	ret    

0080140c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	57                   	push   %edi
  801410:	56                   	push   %esi
  801411:	53                   	push   %ebx
  801412:	83 ec 1c             	sub    $0x1c,%esp
  801415:	8b 7d 08             	mov    0x8(%ebp),%edi
  801418:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80141b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801420:	eb 23                	jmp    801445 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801422:	89 f0                	mov    %esi,%eax
  801424:	29 d8                	sub    %ebx,%eax
  801426:	89 44 24 08          	mov    %eax,0x8(%esp)
  80142a:	89 d8                	mov    %ebx,%eax
  80142c:	03 45 0c             	add    0xc(%ebp),%eax
  80142f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801433:	89 3c 24             	mov    %edi,(%esp)
  801436:	e8 3f ff ff ff       	call   80137a <read>
		if (m < 0)
  80143b:	85 c0                	test   %eax,%eax
  80143d:	78 10                	js     80144f <readn+0x43>
			return m;
		if (m == 0)
  80143f:	85 c0                	test   %eax,%eax
  801441:	74 0a                	je     80144d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801443:	01 c3                	add    %eax,%ebx
  801445:	39 f3                	cmp    %esi,%ebx
  801447:	72 d9                	jb     801422 <readn+0x16>
  801449:	89 d8                	mov    %ebx,%eax
  80144b:	eb 02                	jmp    80144f <readn+0x43>
  80144d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80144f:	83 c4 1c             	add    $0x1c,%esp
  801452:	5b                   	pop    %ebx
  801453:	5e                   	pop    %esi
  801454:	5f                   	pop    %edi
  801455:	5d                   	pop    %ebp
  801456:	c3                   	ret    

00801457 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	53                   	push   %ebx
  80145b:	83 ec 24             	sub    $0x24,%esp
  80145e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801461:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801464:	89 44 24 04          	mov    %eax,0x4(%esp)
  801468:	89 1c 24             	mov    %ebx,(%esp)
  80146b:	e8 76 fc ff ff       	call   8010e6 <fd_lookup>
  801470:	89 c2                	mov    %eax,%edx
  801472:	85 d2                	test   %edx,%edx
  801474:	78 68                	js     8014de <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801476:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801479:	89 44 24 04          	mov    %eax,0x4(%esp)
  80147d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801480:	8b 00                	mov    (%eax),%eax
  801482:	89 04 24             	mov    %eax,(%esp)
  801485:	e8 b2 fc ff ff       	call   80113c <dev_lookup>
  80148a:	85 c0                	test   %eax,%eax
  80148c:	78 50                	js     8014de <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80148e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801491:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801495:	75 23                	jne    8014ba <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801497:	a1 08 40 80 00       	mov    0x804008,%eax
  80149c:	8b 40 48             	mov    0x48(%eax),%eax
  80149f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a7:	c7 04 24 2c 2c 80 00 	movl   $0x802c2c,(%esp)
  8014ae:	e8 87 ed ff ff       	call   80023a <cprintf>
		return -E_INVAL;
  8014b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b8:	eb 24                	jmp    8014de <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014bd:	8b 52 0c             	mov    0xc(%edx),%edx
  8014c0:	85 d2                	test   %edx,%edx
  8014c2:	74 15                	je     8014d9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014d2:	89 04 24             	mov    %eax,(%esp)
  8014d5:	ff d2                	call   *%edx
  8014d7:	eb 05                	jmp    8014de <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8014d9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8014de:	83 c4 24             	add    $0x24,%esp
  8014e1:	5b                   	pop    %ebx
  8014e2:	5d                   	pop    %ebp
  8014e3:	c3                   	ret    

008014e4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ea:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	89 04 24             	mov    %eax,(%esp)
  8014f7:	e8 ea fb ff ff       	call   8010e6 <fd_lookup>
  8014fc:	85 c0                	test   %eax,%eax
  8014fe:	78 0e                	js     80150e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801500:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801503:	8b 55 0c             	mov    0xc(%ebp),%edx
  801506:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801509:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	53                   	push   %ebx
  801514:	83 ec 24             	sub    $0x24,%esp
  801517:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801521:	89 1c 24             	mov    %ebx,(%esp)
  801524:	e8 bd fb ff ff       	call   8010e6 <fd_lookup>
  801529:	89 c2                	mov    %eax,%edx
  80152b:	85 d2                	test   %edx,%edx
  80152d:	78 61                	js     801590 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801532:	89 44 24 04          	mov    %eax,0x4(%esp)
  801536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801539:	8b 00                	mov    (%eax),%eax
  80153b:	89 04 24             	mov    %eax,(%esp)
  80153e:	e8 f9 fb ff ff       	call   80113c <dev_lookup>
  801543:	85 c0                	test   %eax,%eax
  801545:	78 49                	js     801590 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80154e:	75 23                	jne    801573 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801550:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801555:	8b 40 48             	mov    0x48(%eax),%eax
  801558:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80155c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801560:	c7 04 24 ec 2b 80 00 	movl   $0x802bec,(%esp)
  801567:	e8 ce ec ff ff       	call   80023a <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80156c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801571:	eb 1d                	jmp    801590 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801573:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801576:	8b 52 18             	mov    0x18(%edx),%edx
  801579:	85 d2                	test   %edx,%edx
  80157b:	74 0e                	je     80158b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80157d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801580:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801584:	89 04 24             	mov    %eax,(%esp)
  801587:	ff d2                	call   *%edx
  801589:	eb 05                	jmp    801590 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80158b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801590:	83 c4 24             	add    $0x24,%esp
  801593:	5b                   	pop    %ebx
  801594:	5d                   	pop    %ebp
  801595:	c3                   	ret    

00801596 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	53                   	push   %ebx
  80159a:	83 ec 24             	sub    $0x24,%esp
  80159d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015aa:	89 04 24             	mov    %eax,(%esp)
  8015ad:	e8 34 fb ff ff       	call   8010e6 <fd_lookup>
  8015b2:	89 c2                	mov    %eax,%edx
  8015b4:	85 d2                	test   %edx,%edx
  8015b6:	78 52                	js     80160a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c2:	8b 00                	mov    (%eax),%eax
  8015c4:	89 04 24             	mov    %eax,(%esp)
  8015c7:	e8 70 fb ff ff       	call   80113c <dev_lookup>
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	78 3a                	js     80160a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8015d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015d7:	74 2c                	je     801605 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015d9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015dc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015e3:	00 00 00 
	stat->st_isdir = 0;
  8015e6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015ed:	00 00 00 
	stat->st_dev = dev;
  8015f0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015fd:	89 14 24             	mov    %edx,(%esp)
  801600:	ff 50 14             	call   *0x14(%eax)
  801603:	eb 05                	jmp    80160a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801605:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80160a:	83 c4 24             	add    $0x24,%esp
  80160d:	5b                   	pop    %ebx
  80160e:	5d                   	pop    %ebp
  80160f:	c3                   	ret    

00801610 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	56                   	push   %esi
  801614:	53                   	push   %ebx
  801615:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801618:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80161f:	00 
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	89 04 24             	mov    %eax,(%esp)
  801626:	e8 84 02 00 00       	call   8018af <open>
  80162b:	89 c3                	mov    %eax,%ebx
  80162d:	85 db                	test   %ebx,%ebx
  80162f:	78 1b                	js     80164c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801631:	8b 45 0c             	mov    0xc(%ebp),%eax
  801634:	89 44 24 04          	mov    %eax,0x4(%esp)
  801638:	89 1c 24             	mov    %ebx,(%esp)
  80163b:	e8 56 ff ff ff       	call   801596 <fstat>
  801640:	89 c6                	mov    %eax,%esi
	close(fd);
  801642:	89 1c 24             	mov    %ebx,(%esp)
  801645:	e8 cd fb ff ff       	call   801217 <close>
	return r;
  80164a:	89 f0                	mov    %esi,%eax
}
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	5b                   	pop    %ebx
  801650:	5e                   	pop    %esi
  801651:	5d                   	pop    %ebp
  801652:	c3                   	ret    

00801653 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
  801656:	56                   	push   %esi
  801657:	53                   	push   %ebx
  801658:	83 ec 10             	sub    $0x10,%esp
  80165b:	89 c6                	mov    %eax,%esi
  80165d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80165f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801666:	75 11                	jne    801679 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801668:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80166f:	e8 11 0e 00 00       	call   802485 <ipc_find_env>
  801674:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801679:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801680:	00 
  801681:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801688:	00 
  801689:	89 74 24 04          	mov    %esi,0x4(%esp)
  80168d:	a1 00 40 80 00       	mov    0x804000,%eax
  801692:	89 04 24             	mov    %eax,(%esp)
  801695:	e8 5e 0d 00 00       	call   8023f8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80169a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016a1:	00 
  8016a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016ad:	e8 de 0c 00 00       	call   802390 <ipc_recv>
}
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	5b                   	pop    %ebx
  8016b6:	5e                   	pop    %esi
  8016b7:	5d                   	pop    %ebp
  8016b8:	c3                   	ret    

008016b9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d7:	b8 02 00 00 00       	mov    $0x2,%eax
  8016dc:	e8 72 ff ff ff       	call   801653 <fsipc>
}
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ef:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f9:	b8 06 00 00 00       	mov    $0x6,%eax
  8016fe:	e8 50 ff ff ff       	call   801653 <fsipc>
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	53                   	push   %ebx
  801709:	83 ec 14             	sub    $0x14,%esp
  80170c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	8b 40 0c             	mov    0xc(%eax),%eax
  801715:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80171a:	ba 00 00 00 00       	mov    $0x0,%edx
  80171f:	b8 05 00 00 00       	mov    $0x5,%eax
  801724:	e8 2a ff ff ff       	call   801653 <fsipc>
  801729:	89 c2                	mov    %eax,%edx
  80172b:	85 d2                	test   %edx,%edx
  80172d:	78 2b                	js     80175a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80172f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801736:	00 
  801737:	89 1c 24             	mov    %ebx,(%esp)
  80173a:	e8 28 f1 ff ff       	call   800867 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80173f:	a1 80 50 80 00       	mov    0x805080,%eax
  801744:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80174a:	a1 84 50 80 00       	mov    0x805084,%eax
  80174f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175a:	83 c4 14             	add    $0x14,%esp
  80175d:	5b                   	pop    %ebx
  80175e:	5d                   	pop    %ebp
  80175f:	c3                   	ret    

00801760 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	53                   	push   %ebx
  801764:	83 ec 14             	sub    $0x14,%esp
  801767:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80176a:	8b 45 08             	mov    0x8(%ebp),%eax
  80176d:	8b 40 0c             	mov    0xc(%eax),%eax
  801770:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801775:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80177b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801780:	0f 46 c3             	cmovbe %ebx,%eax
  801783:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801788:	89 44 24 08          	mov    %eax,0x8(%esp)
  80178c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801793:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80179a:	e8 65 f2 ff ff       	call   800a04 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80179f:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a4:	b8 04 00 00 00       	mov    $0x4,%eax
  8017a9:	e8 a5 fe ff ff       	call   801653 <fsipc>
  8017ae:	85 c0                	test   %eax,%eax
  8017b0:	78 53                	js     801805 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  8017b2:	39 c3                	cmp    %eax,%ebx
  8017b4:	73 24                	jae    8017da <devfile_write+0x7a>
  8017b6:	c7 44 24 0c 60 2c 80 	movl   $0x802c60,0xc(%esp)
  8017bd:	00 
  8017be:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  8017c5:	00 
  8017c6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  8017cd:	00 
  8017ce:	c7 04 24 7c 2c 80 00 	movl   $0x802c7c,(%esp)
  8017d5:	e8 67 e9 ff ff       	call   800141 <_panic>
	assert(r <= PGSIZE);
  8017da:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017df:	7e 24                	jle    801805 <devfile_write+0xa5>
  8017e1:	c7 44 24 0c 87 2c 80 	movl   $0x802c87,0xc(%esp)
  8017e8:	00 
  8017e9:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  8017f0:	00 
  8017f1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  8017f8:	00 
  8017f9:	c7 04 24 7c 2c 80 00 	movl   $0x802c7c,(%esp)
  801800:	e8 3c e9 ff ff       	call   800141 <_panic>
	return r;
}
  801805:	83 c4 14             	add    $0x14,%esp
  801808:	5b                   	pop    %ebx
  801809:	5d                   	pop    %ebp
  80180a:	c3                   	ret    

0080180b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	56                   	push   %esi
  80180f:	53                   	push   %ebx
  801810:	83 ec 10             	sub    $0x10,%esp
  801813:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	8b 40 0c             	mov    0xc(%eax),%eax
  80181c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801821:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801827:	ba 00 00 00 00       	mov    $0x0,%edx
  80182c:	b8 03 00 00 00       	mov    $0x3,%eax
  801831:	e8 1d fe ff ff       	call   801653 <fsipc>
  801836:	89 c3                	mov    %eax,%ebx
  801838:	85 c0                	test   %eax,%eax
  80183a:	78 6a                	js     8018a6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  80183c:	39 c6                	cmp    %eax,%esi
  80183e:	73 24                	jae    801864 <devfile_read+0x59>
  801840:	c7 44 24 0c 60 2c 80 	movl   $0x802c60,0xc(%esp)
  801847:	00 
  801848:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  80184f:	00 
  801850:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801857:	00 
  801858:	c7 04 24 7c 2c 80 00 	movl   $0x802c7c,(%esp)
  80185f:	e8 dd e8 ff ff       	call   800141 <_panic>
	assert(r <= PGSIZE);
  801864:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801869:	7e 24                	jle    80188f <devfile_read+0x84>
  80186b:	c7 44 24 0c 87 2c 80 	movl   $0x802c87,0xc(%esp)
  801872:	00 
  801873:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  80187a:	00 
  80187b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801882:	00 
  801883:	c7 04 24 7c 2c 80 00 	movl   $0x802c7c,(%esp)
  80188a:	e8 b2 e8 ff ff       	call   800141 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80188f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801893:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80189a:	00 
  80189b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189e:	89 04 24             	mov    %eax,(%esp)
  8018a1:	e8 5e f1 ff ff       	call   800a04 <memmove>
	return r;
}
  8018a6:	89 d8                	mov    %ebx,%eax
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	5b                   	pop    %ebx
  8018ac:	5e                   	pop    %esi
  8018ad:	5d                   	pop    %ebp
  8018ae:	c3                   	ret    

008018af <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	53                   	push   %ebx
  8018b3:	83 ec 24             	sub    $0x24,%esp
  8018b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8018b9:	89 1c 24             	mov    %ebx,(%esp)
  8018bc:	e8 6f ef ff ff       	call   800830 <strlen>
  8018c1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8018c6:	7f 60                	jg     801928 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8018c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cb:	89 04 24             	mov    %eax,(%esp)
  8018ce:	e8 c4 f7 ff ff       	call   801097 <fd_alloc>
  8018d3:	89 c2                	mov    %eax,%edx
  8018d5:	85 d2                	test   %edx,%edx
  8018d7:	78 54                	js     80192d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8018d9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018dd:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8018e4:	e8 7e ef ff ff       	call   800867 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ec:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8018f9:	e8 55 fd ff ff       	call   801653 <fsipc>
  8018fe:	89 c3                	mov    %eax,%ebx
  801900:	85 c0                	test   %eax,%eax
  801902:	79 17                	jns    80191b <open+0x6c>
		fd_close(fd, 0);
  801904:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80190b:	00 
  80190c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190f:	89 04 24             	mov    %eax,(%esp)
  801912:	e8 7f f8 ff ff       	call   801196 <fd_close>
		return r;
  801917:	89 d8                	mov    %ebx,%eax
  801919:	eb 12                	jmp    80192d <open+0x7e>
	}

	return fd2num(fd);
  80191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191e:	89 04 24             	mov    %eax,(%esp)
  801921:	e8 4a f7 ff ff       	call   801070 <fd2num>
  801926:	eb 05                	jmp    80192d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801928:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  80192d:	83 c4 24             	add    $0x24,%esp
  801930:	5b                   	pop    %ebx
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    

00801933 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801939:	ba 00 00 00 00       	mov    $0x0,%edx
  80193e:	b8 08 00 00 00       	mov    $0x8,%eax
  801943:	e8 0b fd ff ff       	call   801653 <fsipc>
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    
  80194a:	66 90                	xchg   %ax,%ax
  80194c:	66 90                	xchg   %ax,%ax
  80194e:	66 90                	xchg   %ax,%ax

00801950 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
  801953:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801956:	c7 44 24 04 93 2c 80 	movl   $0x802c93,0x4(%esp)
  80195d:	00 
  80195e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801961:	89 04 24             	mov    %eax,(%esp)
  801964:	e8 fe ee ff ff       	call   800867 <strcpy>
	return 0;
}
  801969:	b8 00 00 00 00       	mov    $0x0,%eax
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	53                   	push   %ebx
  801974:	83 ec 14             	sub    $0x14,%esp
  801977:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80197a:	89 1c 24             	mov    %ebx,(%esp)
  80197d:	e8 3d 0b 00 00       	call   8024bf <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801982:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801987:	83 f8 01             	cmp    $0x1,%eax
  80198a:	75 0d                	jne    801999 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80198c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80198f:	89 04 24             	mov    %eax,(%esp)
  801992:	e8 29 03 00 00       	call   801cc0 <nsipc_close>
  801997:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801999:	89 d0                	mov    %edx,%eax
  80199b:	83 c4 14             	add    $0x14,%esp
  80199e:	5b                   	pop    %ebx
  80199f:	5d                   	pop    %ebp
  8019a0:	c3                   	ret    

008019a1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8019a7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019ae:	00 
  8019af:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c3:	89 04 24             	mov    %eax,(%esp)
  8019c6:	e8 f0 03 00 00       	call   801dbb <nsipc_send>
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8019d3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8019da:	00 
  8019db:	8b 45 10             	mov    0x10(%ebp),%eax
  8019de:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ef:	89 04 24             	mov    %eax,(%esp)
  8019f2:	e8 44 03 00 00       	call   801d3b <nsipc_recv>
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8019ff:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a02:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a06:	89 04 24             	mov    %eax,(%esp)
  801a09:	e8 d8 f6 ff ff       	call   8010e6 <fd_lookup>
  801a0e:	85 c0                	test   %eax,%eax
  801a10:	78 17                	js     801a29 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a15:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801a1b:	39 08                	cmp    %ecx,(%eax)
  801a1d:	75 05                	jne    801a24 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801a1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a22:	eb 05                	jmp    801a29 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801a24:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
  801a2e:	56                   	push   %esi
  801a2f:	53                   	push   %ebx
  801a30:	83 ec 20             	sub    $0x20,%esp
  801a33:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a35:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a38:	89 04 24             	mov    %eax,(%esp)
  801a3b:	e8 57 f6 ff ff       	call   801097 <fd_alloc>
  801a40:	89 c3                	mov    %eax,%ebx
  801a42:	85 c0                	test   %eax,%eax
  801a44:	78 21                	js     801a67 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801a46:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801a4d:	00 
  801a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a5c:	e8 22 f2 ff ff       	call   800c83 <sys_page_alloc>
  801a61:	89 c3                	mov    %eax,%ebx
  801a63:	85 c0                	test   %eax,%eax
  801a65:	79 0c                	jns    801a73 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801a67:	89 34 24             	mov    %esi,(%esp)
  801a6a:	e8 51 02 00 00       	call   801cc0 <nsipc_close>
		return r;
  801a6f:	89 d8                	mov    %ebx,%eax
  801a71:	eb 20                	jmp    801a93 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801a73:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801a7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a81:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801a88:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801a8b:	89 14 24             	mov    %edx,(%esp)
  801a8e:	e8 dd f5 ff ff       	call   801070 <fd2num>
}
  801a93:	83 c4 20             	add    $0x20,%esp
  801a96:	5b                   	pop    %ebx
  801a97:	5e                   	pop    %esi
  801a98:	5d                   	pop    %ebp
  801a99:	c3                   	ret    

00801a9a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	e8 51 ff ff ff       	call   8019f9 <fd2sockid>
		return r;
  801aa8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	78 23                	js     801ad1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801aae:	8b 55 10             	mov    0x10(%ebp),%edx
  801ab1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ab5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801abc:	89 04 24             	mov    %eax,(%esp)
  801abf:	e8 45 01 00 00       	call   801c09 <nsipc_accept>
		return r;
  801ac4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	78 07                	js     801ad1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801aca:	e8 5c ff ff ff       	call   801a2b <alloc_sockfd>
  801acf:	89 c1                	mov    %eax,%ecx
}
  801ad1:	89 c8                	mov    %ecx,%eax
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	e8 16 ff ff ff       	call   8019f9 <fd2sockid>
  801ae3:	89 c2                	mov    %eax,%edx
  801ae5:	85 d2                	test   %edx,%edx
  801ae7:	78 16                	js     801aff <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  801aec:	89 44 24 08          	mov    %eax,0x8(%esp)
  801af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af7:	89 14 24             	mov    %edx,(%esp)
  801afa:	e8 60 01 00 00       	call   801c5f <nsipc_bind>
}
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <shutdown>:

int
shutdown(int s, int how)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	e8 ea fe ff ff       	call   8019f9 <fd2sockid>
  801b0f:	89 c2                	mov    %eax,%edx
  801b11:	85 d2                	test   %edx,%edx
  801b13:	78 0f                	js     801b24 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1c:	89 14 24             	mov    %edx,(%esp)
  801b1f:	e8 7a 01 00 00       	call   801c9e <nsipc_shutdown>
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	e8 c5 fe ff ff       	call   8019f9 <fd2sockid>
  801b34:	89 c2                	mov    %eax,%edx
  801b36:	85 d2                	test   %edx,%edx
  801b38:	78 16                	js     801b50 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801b3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b48:	89 14 24             	mov    %edx,(%esp)
  801b4b:	e8 8a 01 00 00       	call   801cda <nsipc_connect>
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <listen>:

int
listen(int s, int backlog)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
  801b55:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	e8 99 fe ff ff       	call   8019f9 <fd2sockid>
  801b60:	89 c2                	mov    %eax,%edx
  801b62:	85 d2                	test   %edx,%edx
  801b64:	78 0f                	js     801b75 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b6d:	89 14 24             	mov    %edx,(%esp)
  801b70:	e8 a4 01 00 00       	call   801d19 <nsipc_listen>
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801b7d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b80:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b87:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	89 04 24             	mov    %eax,(%esp)
  801b91:	e8 98 02 00 00       	call   801e2e <nsipc_socket>
  801b96:	89 c2                	mov    %eax,%edx
  801b98:	85 d2                	test   %edx,%edx
  801b9a:	78 05                	js     801ba1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801b9c:	e8 8a fe ff ff       	call   801a2b <alloc_sockfd>
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	53                   	push   %ebx
  801ba7:	83 ec 14             	sub    $0x14,%esp
  801baa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801bac:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801bb3:	75 11                	jne    801bc6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801bb5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801bbc:	e8 c4 08 00 00       	call   802485 <ipc_find_env>
  801bc1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801bc6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bcd:	00 
  801bce:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801bd5:	00 
  801bd6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bda:	a1 04 40 80 00       	mov    0x804004,%eax
  801bdf:	89 04 24             	mov    %eax,(%esp)
  801be2:	e8 11 08 00 00       	call   8023f8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801be7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bee:	00 
  801bef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bf6:	00 
  801bf7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bfe:	e8 8d 07 00 00       	call   802390 <ipc_recv>
}
  801c03:	83 c4 14             	add    $0x14,%esp
  801c06:	5b                   	pop    %ebx
  801c07:	5d                   	pop    %ebp
  801c08:	c3                   	ret    

00801c09 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	56                   	push   %esi
  801c0d:	53                   	push   %ebx
  801c0e:	83 ec 10             	sub    $0x10,%esp
  801c11:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801c1c:	8b 06                	mov    (%esi),%eax
  801c1e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801c23:	b8 01 00 00 00       	mov    $0x1,%eax
  801c28:	e8 76 ff ff ff       	call   801ba3 <nsipc>
  801c2d:	89 c3                	mov    %eax,%ebx
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	78 23                	js     801c56 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801c33:	a1 10 60 80 00       	mov    0x806010,%eax
  801c38:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c3c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c43:	00 
  801c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c47:	89 04 24             	mov    %eax,(%esp)
  801c4a:	e8 b5 ed ff ff       	call   800a04 <memmove>
		*addrlen = ret->ret_addrlen;
  801c4f:	a1 10 60 80 00       	mov    0x806010,%eax
  801c54:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801c56:	89 d8                	mov    %ebx,%eax
  801c58:	83 c4 10             	add    $0x10,%esp
  801c5b:	5b                   	pop    %ebx
  801c5c:	5e                   	pop    %esi
  801c5d:	5d                   	pop    %ebp
  801c5e:	c3                   	ret    

00801c5f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	53                   	push   %ebx
  801c63:	83 ec 14             	sub    $0x14,%esp
  801c66:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801c71:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c78:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c7c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c83:	e8 7c ed ff ff       	call   800a04 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801c88:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801c8e:	b8 02 00 00 00       	mov    $0x2,%eax
  801c93:	e8 0b ff ff ff       	call   801ba3 <nsipc>
}
  801c98:	83 c4 14             	add    $0x14,%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5d                   	pop    %ebp
  801c9d:	c3                   	ret    

00801c9e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801caf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801cb4:	b8 03 00 00 00       	mov    $0x3,%eax
  801cb9:	e8 e5 fe ff ff       	call   801ba3 <nsipc>
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <nsipc_close>:

int
nsipc_close(int s)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801cce:	b8 04 00 00 00       	mov    $0x4,%eax
  801cd3:	e8 cb fe ff ff       	call   801ba3 <nsipc>
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	53                   	push   %ebx
  801cde:	83 ec 14             	sub    $0x14,%esp
  801ce1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801cec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801cfe:	e8 01 ed ff ff       	call   800a04 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801d03:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801d09:	b8 05 00 00 00       	mov    $0x5,%eax
  801d0e:	e8 90 fe ff ff       	call   801ba3 <nsipc>
}
  801d13:	83 c4 14             	add    $0x14,%esp
  801d16:	5b                   	pop    %ebx
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    

00801d19 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d22:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801d2f:	b8 06 00 00 00       	mov    $0x6,%eax
  801d34:	e8 6a fe ff ff       	call   801ba3 <nsipc>
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	56                   	push   %esi
  801d3f:	53                   	push   %ebx
  801d40:	83 ec 10             	sub    $0x10,%esp
  801d43:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801d4e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801d54:	8b 45 14             	mov    0x14(%ebp),%eax
  801d57:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d5c:	b8 07 00 00 00       	mov    $0x7,%eax
  801d61:	e8 3d fe ff ff       	call   801ba3 <nsipc>
  801d66:	89 c3                	mov    %eax,%ebx
  801d68:	85 c0                	test   %eax,%eax
  801d6a:	78 46                	js     801db2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801d6c:	39 f0                	cmp    %esi,%eax
  801d6e:	7f 07                	jg     801d77 <nsipc_recv+0x3c>
  801d70:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801d75:	7e 24                	jle    801d9b <nsipc_recv+0x60>
  801d77:	c7 44 24 0c 9f 2c 80 	movl   $0x802c9f,0xc(%esp)
  801d7e:	00 
  801d7f:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  801d86:	00 
  801d87:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801d8e:	00 
  801d8f:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  801d96:	e8 a6 e3 ff ff       	call   800141 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801d9b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d9f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801da6:	00 
  801da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801daa:	89 04 24             	mov    %eax,(%esp)
  801dad:	e8 52 ec ff ff       	call   800a04 <memmove>
	}

	return r;
}
  801db2:	89 d8                	mov    %ebx,%eax
  801db4:	83 c4 10             	add    $0x10,%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5d                   	pop    %ebp
  801dba:	c3                   	ret    

00801dbb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	53                   	push   %ebx
  801dbf:	83 ec 14             	sub    $0x14,%esp
  801dc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801dcd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801dd3:	7e 24                	jle    801df9 <nsipc_send+0x3e>
  801dd5:	c7 44 24 0c c0 2c 80 	movl   $0x802cc0,0xc(%esp)
  801ddc:	00 
  801ddd:	c7 44 24 08 67 2c 80 	movl   $0x802c67,0x8(%esp)
  801de4:	00 
  801de5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801dec:	00 
  801ded:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  801df4:	e8 48 e3 ff ff       	call   800141 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801df9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e00:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e04:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801e0b:	e8 f4 eb ff ff       	call   800a04 <memmove>
	nsipcbuf.send.req_size = size;
  801e10:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801e16:	8b 45 14             	mov    0x14(%ebp),%eax
  801e19:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801e1e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e23:	e8 7b fd ff ff       	call   801ba3 <nsipc>
}
  801e28:	83 c4 14             	add    $0x14,%esp
  801e2b:	5b                   	pop    %ebx
  801e2c:	5d                   	pop    %ebp
  801e2d:	c3                   	ret    

00801e2e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801e44:	8b 45 10             	mov    0x10(%ebp),%eax
  801e47:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801e4c:	b8 09 00 00 00       	mov    $0x9,%eax
  801e51:	e8 4d fd ff ff       	call   801ba3 <nsipc>
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	56                   	push   %esi
  801e5c:	53                   	push   %ebx
  801e5d:	83 ec 10             	sub    $0x10,%esp
  801e60:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801e63:	8b 45 08             	mov    0x8(%ebp),%eax
  801e66:	89 04 24             	mov    %eax,(%esp)
  801e69:	e8 12 f2 ff ff       	call   801080 <fd2data>
  801e6e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801e70:	c7 44 24 04 cc 2c 80 	movl   $0x802ccc,0x4(%esp)
  801e77:	00 
  801e78:	89 1c 24             	mov    %ebx,(%esp)
  801e7b:	e8 e7 e9 ff ff       	call   800867 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801e80:	8b 46 04             	mov    0x4(%esi),%eax
  801e83:	2b 06                	sub    (%esi),%eax
  801e85:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801e8b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801e92:	00 00 00 
	stat->st_dev = &devpipe;
  801e95:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801e9c:	30 80 00 
	return 0;
}
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea4:	83 c4 10             	add    $0x10,%esp
  801ea7:	5b                   	pop    %ebx
  801ea8:	5e                   	pop    %esi
  801ea9:	5d                   	pop    %ebp
  801eaa:	c3                   	ret    

00801eab <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	53                   	push   %ebx
  801eaf:	83 ec 14             	sub    $0x14,%esp
  801eb2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801eb5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801eb9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ec0:	e8 65 ee ff ff       	call   800d2a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ec5:	89 1c 24             	mov    %ebx,(%esp)
  801ec8:	e8 b3 f1 ff ff       	call   801080 <fd2data>
  801ecd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ed8:	e8 4d ee ff ff       	call   800d2a <sys_page_unmap>
}
  801edd:	83 c4 14             	add    $0x14,%esp
  801ee0:	5b                   	pop    %ebx
  801ee1:	5d                   	pop    %ebp
  801ee2:	c3                   	ret    

00801ee3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	57                   	push   %edi
  801ee7:	56                   	push   %esi
  801ee8:	53                   	push   %ebx
  801ee9:	83 ec 2c             	sub    $0x2c,%esp
  801eec:	89 c6                	mov    %eax,%esi
  801eee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801ef1:	a1 08 40 80 00       	mov    0x804008,%eax
  801ef6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ef9:	89 34 24             	mov    %esi,(%esp)
  801efc:	e8 be 05 00 00       	call   8024bf <pageref>
  801f01:	89 c7                	mov    %eax,%edi
  801f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f06:	89 04 24             	mov    %eax,(%esp)
  801f09:	e8 b1 05 00 00       	call   8024bf <pageref>
  801f0e:	39 c7                	cmp    %eax,%edi
  801f10:	0f 94 c2             	sete   %dl
  801f13:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801f16:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801f1c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801f1f:	39 fb                	cmp    %edi,%ebx
  801f21:	74 21                	je     801f44 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801f23:	84 d2                	test   %dl,%dl
  801f25:	74 ca                	je     801ef1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801f27:	8b 51 58             	mov    0x58(%ecx),%edx
  801f2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f2e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f36:	c7 04 24 d3 2c 80 00 	movl   $0x802cd3,(%esp)
  801f3d:	e8 f8 e2 ff ff       	call   80023a <cprintf>
  801f42:	eb ad                	jmp    801ef1 <_pipeisclosed+0xe>
	}
}
  801f44:	83 c4 2c             	add    $0x2c,%esp
  801f47:	5b                   	pop    %ebx
  801f48:	5e                   	pop    %esi
  801f49:	5f                   	pop    %edi
  801f4a:	5d                   	pop    %ebp
  801f4b:	c3                   	ret    

00801f4c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	57                   	push   %edi
  801f50:	56                   	push   %esi
  801f51:	53                   	push   %ebx
  801f52:	83 ec 1c             	sub    $0x1c,%esp
  801f55:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801f58:	89 34 24             	mov    %esi,(%esp)
  801f5b:	e8 20 f1 ff ff       	call   801080 <fd2data>
  801f60:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f62:	bf 00 00 00 00       	mov    $0x0,%edi
  801f67:	eb 45                	jmp    801fae <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801f69:	89 da                	mov    %ebx,%edx
  801f6b:	89 f0                	mov    %esi,%eax
  801f6d:	e8 71 ff ff ff       	call   801ee3 <_pipeisclosed>
  801f72:	85 c0                	test   %eax,%eax
  801f74:	75 41                	jne    801fb7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801f76:	e8 e9 ec ff ff       	call   800c64 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801f7b:	8b 43 04             	mov    0x4(%ebx),%eax
  801f7e:	8b 0b                	mov    (%ebx),%ecx
  801f80:	8d 51 20             	lea    0x20(%ecx),%edx
  801f83:	39 d0                	cmp    %edx,%eax
  801f85:	73 e2                	jae    801f69 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801f87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f8a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801f8e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801f91:	99                   	cltd   
  801f92:	c1 ea 1b             	shr    $0x1b,%edx
  801f95:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801f98:	83 e1 1f             	and    $0x1f,%ecx
  801f9b:	29 d1                	sub    %edx,%ecx
  801f9d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801fa1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801fa5:	83 c0 01             	add    $0x1,%eax
  801fa8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fab:	83 c7 01             	add    $0x1,%edi
  801fae:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801fb1:	75 c8                	jne    801f7b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801fb3:	89 f8                	mov    %edi,%eax
  801fb5:	eb 05                	jmp    801fbc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801fb7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801fbc:	83 c4 1c             	add    $0x1c,%esp
  801fbf:	5b                   	pop    %ebx
  801fc0:	5e                   	pop    %esi
  801fc1:	5f                   	pop    %edi
  801fc2:	5d                   	pop    %ebp
  801fc3:	c3                   	ret    

00801fc4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	57                   	push   %edi
  801fc8:	56                   	push   %esi
  801fc9:	53                   	push   %ebx
  801fca:	83 ec 1c             	sub    $0x1c,%esp
  801fcd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801fd0:	89 3c 24             	mov    %edi,(%esp)
  801fd3:	e8 a8 f0 ff ff       	call   801080 <fd2data>
  801fd8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fda:	be 00 00 00 00       	mov    $0x0,%esi
  801fdf:	eb 3d                	jmp    80201e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801fe1:	85 f6                	test   %esi,%esi
  801fe3:	74 04                	je     801fe9 <devpipe_read+0x25>
				return i;
  801fe5:	89 f0                	mov    %esi,%eax
  801fe7:	eb 43                	jmp    80202c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801fe9:	89 da                	mov    %ebx,%edx
  801feb:	89 f8                	mov    %edi,%eax
  801fed:	e8 f1 fe ff ff       	call   801ee3 <_pipeisclosed>
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	75 31                	jne    802027 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801ff6:	e8 69 ec ff ff       	call   800c64 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801ffb:	8b 03                	mov    (%ebx),%eax
  801ffd:	3b 43 04             	cmp    0x4(%ebx),%eax
  802000:	74 df                	je     801fe1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802002:	99                   	cltd   
  802003:	c1 ea 1b             	shr    $0x1b,%edx
  802006:	01 d0                	add    %edx,%eax
  802008:	83 e0 1f             	and    $0x1f,%eax
  80200b:	29 d0                	sub    %edx,%eax
  80200d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802012:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802015:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802018:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80201b:	83 c6 01             	add    $0x1,%esi
  80201e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802021:	75 d8                	jne    801ffb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802023:	89 f0                	mov    %esi,%eax
  802025:	eb 05                	jmp    80202c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802027:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80202c:	83 c4 1c             	add    $0x1c,%esp
  80202f:	5b                   	pop    %ebx
  802030:	5e                   	pop    %esi
  802031:	5f                   	pop    %edi
  802032:	5d                   	pop    %ebp
  802033:	c3                   	ret    

00802034 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	56                   	push   %esi
  802038:	53                   	push   %ebx
  802039:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80203c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80203f:	89 04 24             	mov    %eax,(%esp)
  802042:	e8 50 f0 ff ff       	call   801097 <fd_alloc>
  802047:	89 c2                	mov    %eax,%edx
  802049:	85 d2                	test   %edx,%edx
  80204b:	0f 88 4d 01 00 00    	js     80219e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802051:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802058:	00 
  802059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802060:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802067:	e8 17 ec ff ff       	call   800c83 <sys_page_alloc>
  80206c:	89 c2                	mov    %eax,%edx
  80206e:	85 d2                	test   %edx,%edx
  802070:	0f 88 28 01 00 00    	js     80219e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802076:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802079:	89 04 24             	mov    %eax,(%esp)
  80207c:	e8 16 f0 ff ff       	call   801097 <fd_alloc>
  802081:	89 c3                	mov    %eax,%ebx
  802083:	85 c0                	test   %eax,%eax
  802085:	0f 88 fe 00 00 00    	js     802189 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80208b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802092:	00 
  802093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802096:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a1:	e8 dd eb ff ff       	call   800c83 <sys_page_alloc>
  8020a6:	89 c3                	mov    %eax,%ebx
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	0f 88 d9 00 00 00    	js     802189 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8020b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b3:	89 04 24             	mov    %eax,(%esp)
  8020b6:	e8 c5 ef ff ff       	call   801080 <fd2data>
  8020bb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020bd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8020c4:	00 
  8020c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d0:	e8 ae eb ff ff       	call   800c83 <sys_page_alloc>
  8020d5:	89 c3                	mov    %eax,%ebx
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	0f 88 97 00 00 00    	js     802176 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8020df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e2:	89 04 24             	mov    %eax,(%esp)
  8020e5:	e8 96 ef ff ff       	call   801080 <fd2data>
  8020ea:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8020f1:	00 
  8020f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020fd:	00 
  8020fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  802102:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802109:	e8 c9 eb ff ff       	call   800cd7 <sys_page_map>
  80210e:	89 c3                	mov    %eax,%ebx
  802110:	85 c0                	test   %eax,%eax
  802112:	78 52                	js     802166 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802114:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80211f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802122:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802129:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80212f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802132:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802134:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802137:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80213e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802141:	89 04 24             	mov    %eax,(%esp)
  802144:	e8 27 ef ff ff       	call   801070 <fd2num>
  802149:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80214c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80214e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802151:	89 04 24             	mov    %eax,(%esp)
  802154:	e8 17 ef ff ff       	call   801070 <fd2num>
  802159:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80215c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80215f:	b8 00 00 00 00       	mov    $0x0,%eax
  802164:	eb 38                	jmp    80219e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802166:	89 74 24 04          	mov    %esi,0x4(%esp)
  80216a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802171:	e8 b4 eb ff ff       	call   800d2a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802179:	89 44 24 04          	mov    %eax,0x4(%esp)
  80217d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802184:	e8 a1 eb ff ff       	call   800d2a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802190:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802197:	e8 8e eb ff ff       	call   800d2a <sys_page_unmap>
  80219c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80219e:	83 c4 30             	add    $0x30,%esp
  8021a1:	5b                   	pop    %ebx
  8021a2:	5e                   	pop    %esi
  8021a3:	5d                   	pop    %ebp
  8021a4:	c3                   	ret    

008021a5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	89 04 24             	mov    %eax,(%esp)
  8021b8:	e8 29 ef ff ff       	call   8010e6 <fd_lookup>
  8021bd:	89 c2                	mov    %eax,%edx
  8021bf:	85 d2                	test   %edx,%edx
  8021c1:	78 15                	js     8021d8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	89 04 24             	mov    %eax,(%esp)
  8021c9:	e8 b2 ee ff ff       	call   801080 <fd2data>
	return _pipeisclosed(fd, p);
  8021ce:	89 c2                	mov    %eax,%edx
  8021d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d3:	e8 0b fd ff ff       	call   801ee3 <_pipeisclosed>
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    
  8021da:	66 90                	xchg   %ax,%ax
  8021dc:	66 90                	xchg   %ax,%ax
  8021de:	66 90                	xchg   %ax,%ax

008021e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8021e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021e8:	5d                   	pop    %ebp
  8021e9:	c3                   	ret    

008021ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8021f0:	c7 44 24 04 eb 2c 80 	movl   $0x802ceb,0x4(%esp)
  8021f7:	00 
  8021f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fb:	89 04 24             	mov    %eax,(%esp)
  8021fe:	e8 64 e6 ff ff       	call   800867 <strcpy>
	return 0;
}
  802203:	b8 00 00 00 00       	mov    $0x0,%eax
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	57                   	push   %edi
  80220e:	56                   	push   %esi
  80220f:	53                   	push   %ebx
  802210:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802216:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80221b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802221:	eb 31                	jmp    802254 <devcons_write+0x4a>
		m = n - tot;
  802223:	8b 75 10             	mov    0x10(%ebp),%esi
  802226:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802228:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80222b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802230:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802233:	89 74 24 08          	mov    %esi,0x8(%esp)
  802237:	03 45 0c             	add    0xc(%ebp),%eax
  80223a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223e:	89 3c 24             	mov    %edi,(%esp)
  802241:	e8 be e7 ff ff       	call   800a04 <memmove>
		sys_cputs(buf, m);
  802246:	89 74 24 04          	mov    %esi,0x4(%esp)
  80224a:	89 3c 24             	mov    %edi,(%esp)
  80224d:	e8 64 e9 ff ff       	call   800bb6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802252:	01 f3                	add    %esi,%ebx
  802254:	89 d8                	mov    %ebx,%eax
  802256:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802259:	72 c8                	jb     802223 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80225b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802261:	5b                   	pop    %ebx
  802262:	5e                   	pop    %esi
  802263:	5f                   	pop    %edi
  802264:	5d                   	pop    %ebp
  802265:	c3                   	ret    

00802266 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80226c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802271:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802275:	75 07                	jne    80227e <devcons_read+0x18>
  802277:	eb 2a                	jmp    8022a3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802279:	e8 e6 e9 ff ff       	call   800c64 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80227e:	66 90                	xchg   %ax,%ax
  802280:	e8 4f e9 ff ff       	call   800bd4 <sys_cgetc>
  802285:	85 c0                	test   %eax,%eax
  802287:	74 f0                	je     802279 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802289:	85 c0                	test   %eax,%eax
  80228b:	78 16                	js     8022a3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80228d:	83 f8 04             	cmp    $0x4,%eax
  802290:	74 0c                	je     80229e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802292:	8b 55 0c             	mov    0xc(%ebp),%edx
  802295:	88 02                	mov    %al,(%edx)
	return 1;
  802297:	b8 01 00 00 00       	mov    $0x1,%eax
  80229c:	eb 05                	jmp    8022a3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80229e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
  8022a8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8022b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022b8:	00 
  8022b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022bc:	89 04 24             	mov    %eax,(%esp)
  8022bf:	e8 f2 e8 ff ff       	call   800bb6 <sys_cputs>
}
  8022c4:	c9                   	leave  
  8022c5:	c3                   	ret    

008022c6 <getchar>:

int
getchar(void)
{
  8022c6:	55                   	push   %ebp
  8022c7:	89 e5                	mov    %esp,%ebp
  8022c9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8022cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8022d3:	00 
  8022d4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8022d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022e2:	e8 93 f0 ff ff       	call   80137a <read>
	if (r < 0)
  8022e7:	85 c0                	test   %eax,%eax
  8022e9:	78 0f                	js     8022fa <getchar+0x34>
		return r;
	if (r < 1)
  8022eb:	85 c0                	test   %eax,%eax
  8022ed:	7e 06                	jle    8022f5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8022ef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8022f3:	eb 05                	jmp    8022fa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8022f5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8022fa:	c9                   	leave  
  8022fb:	c3                   	ret    

008022fc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
  8022ff:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802302:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802305:	89 44 24 04          	mov    %eax,0x4(%esp)
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	89 04 24             	mov    %eax,(%esp)
  80230f:	e8 d2 ed ff ff       	call   8010e6 <fd_lookup>
  802314:	85 c0                	test   %eax,%eax
  802316:	78 11                	js     802329 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802321:	39 10                	cmp    %edx,(%eax)
  802323:	0f 94 c0             	sete   %al
  802326:	0f b6 c0             	movzbl %al,%eax
}
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <opencons>:

int
opencons(void)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802331:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802334:	89 04 24             	mov    %eax,(%esp)
  802337:	e8 5b ed ff ff       	call   801097 <fd_alloc>
		return r;
  80233c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80233e:	85 c0                	test   %eax,%eax
  802340:	78 40                	js     802382 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802342:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802349:	00 
  80234a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802351:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802358:	e8 26 e9 ff ff       	call   800c83 <sys_page_alloc>
		return r;
  80235d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80235f:	85 c0                	test   %eax,%eax
  802361:	78 1f                	js     802382 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802363:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80236e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802371:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802378:	89 04 24             	mov    %eax,(%esp)
  80237b:	e8 f0 ec ff ff       	call   801070 <fd2num>
  802380:	89 c2                	mov    %eax,%edx
}
  802382:	89 d0                	mov    %edx,%eax
  802384:	c9                   	leave  
  802385:	c3                   	ret    
  802386:	66 90                	xchg   %ax,%ax
  802388:	66 90                	xchg   %ax,%ax
  80238a:	66 90                	xchg   %ax,%ax
  80238c:	66 90                	xchg   %ax,%ax
  80238e:	66 90                	xchg   %ax,%ax

00802390 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	56                   	push   %esi
  802394:	53                   	push   %ebx
  802395:	83 ec 10             	sub    $0x10,%esp
  802398:	8b 75 08             	mov    0x8(%ebp),%esi
  80239b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80239e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8023a1:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  8023a3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8023a8:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  8023ab:	89 04 24             	mov    %eax,(%esp)
  8023ae:	e8 e6 ea ff ff       	call   800e99 <sys_ipc_recv>
  8023b3:	85 c0                	test   %eax,%eax
  8023b5:	74 16                	je     8023cd <ipc_recv+0x3d>
		if (from_env_store != NULL)
  8023b7:	85 f6                	test   %esi,%esi
  8023b9:	74 06                	je     8023c1 <ipc_recv+0x31>
			*from_env_store = 0;
  8023bb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8023c1:	85 db                	test   %ebx,%ebx
  8023c3:	74 2c                	je     8023f1 <ipc_recv+0x61>
			*perm_store = 0;
  8023c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8023cb:	eb 24                	jmp    8023f1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8023cd:	85 f6                	test   %esi,%esi
  8023cf:	74 0a                	je     8023db <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8023d1:	a1 08 40 80 00       	mov    0x804008,%eax
  8023d6:	8b 40 74             	mov    0x74(%eax),%eax
  8023d9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8023db:	85 db                	test   %ebx,%ebx
  8023dd:	74 0a                	je     8023e9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8023df:	a1 08 40 80 00       	mov    0x804008,%eax
  8023e4:	8b 40 78             	mov    0x78(%eax),%eax
  8023e7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8023e9:	a1 08 40 80 00       	mov    0x804008,%eax
  8023ee:	8b 40 70             	mov    0x70(%eax),%eax
}
  8023f1:	83 c4 10             	add    $0x10,%esp
  8023f4:	5b                   	pop    %ebx
  8023f5:	5e                   	pop    %esi
  8023f6:	5d                   	pop    %ebp
  8023f7:	c3                   	ret    

008023f8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	57                   	push   %edi
  8023fc:	56                   	push   %esi
  8023fd:	53                   	push   %ebx
  8023fe:	83 ec 1c             	sub    $0x1c,%esp
  802401:	8b 75 0c             	mov    0xc(%ebp),%esi
  802404:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802407:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80240a:	85 db                	test   %ebx,%ebx
  80240c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802411:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802414:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802418:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80241c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802420:	8b 45 08             	mov    0x8(%ebp),%eax
  802423:	89 04 24             	mov    %eax,(%esp)
  802426:	e8 4b ea ff ff       	call   800e76 <sys_ipc_try_send>
	if (r == 0) return;
  80242b:	85 c0                	test   %eax,%eax
  80242d:	75 22                	jne    802451 <ipc_send+0x59>
  80242f:	eb 4c                	jmp    80247d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802431:	84 d2                	test   %dl,%dl
  802433:	75 48                	jne    80247d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802435:	e8 2a e8 ff ff       	call   800c64 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80243a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80243e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802442:	89 74 24 04          	mov    %esi,0x4(%esp)
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	89 04 24             	mov    %eax,(%esp)
  80244c:	e8 25 ea ff ff       	call   800e76 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802451:	85 c0                	test   %eax,%eax
  802453:	0f 94 c2             	sete   %dl
  802456:	74 d9                	je     802431 <ipc_send+0x39>
  802458:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80245b:	74 d4                	je     802431 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80245d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802461:	c7 44 24 08 f7 2c 80 	movl   $0x802cf7,0x8(%esp)
  802468:	00 
  802469:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802470:	00 
  802471:	c7 04 24 05 2d 80 00 	movl   $0x802d05,(%esp)
  802478:	e8 c4 dc ff ff       	call   800141 <_panic>
}
  80247d:	83 c4 1c             	add    $0x1c,%esp
  802480:	5b                   	pop    %ebx
  802481:	5e                   	pop    %esi
  802482:	5f                   	pop    %edi
  802483:	5d                   	pop    %ebp
  802484:	c3                   	ret    

00802485 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802485:	55                   	push   %ebp
  802486:	89 e5                	mov    %esp,%ebp
  802488:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80248b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802490:	89 c2                	mov    %eax,%edx
  802492:	c1 e2 07             	shl    $0x7,%edx
  802495:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80249b:	8b 52 50             	mov    0x50(%edx),%edx
  80249e:	39 ca                	cmp    %ecx,%edx
  8024a0:	75 0d                	jne    8024af <ipc_find_env+0x2a>
			return envs[i].env_id;
  8024a2:	c1 e0 07             	shl    $0x7,%eax
  8024a5:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8024aa:	8b 40 40             	mov    0x40(%eax),%eax
  8024ad:	eb 0e                	jmp    8024bd <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8024af:	83 c0 01             	add    $0x1,%eax
  8024b2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8024b7:	75 d7                	jne    802490 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8024b9:	66 b8 00 00          	mov    $0x0,%ax
}
  8024bd:	5d                   	pop    %ebp
  8024be:	c3                   	ret    

008024bf <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
  8024c2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024c5:	89 d0                	mov    %edx,%eax
  8024c7:	c1 e8 16             	shr    $0x16,%eax
  8024ca:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024d1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024d6:	f6 c1 01             	test   $0x1,%cl
  8024d9:	74 1d                	je     8024f8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8024db:	c1 ea 0c             	shr    $0xc,%edx
  8024de:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8024e5:	f6 c2 01             	test   $0x1,%dl
  8024e8:	74 0e                	je     8024f8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8024ea:	c1 ea 0c             	shr    $0xc,%edx
  8024ed:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8024f4:	ef 
  8024f5:	0f b7 c0             	movzwl %ax,%eax
}
  8024f8:	5d                   	pop    %ebp
  8024f9:	c3                   	ret    
  8024fa:	66 90                	xchg   %ax,%ax
  8024fc:	66 90                	xchg   %ax,%ax
  8024fe:	66 90                	xchg   %ax,%ax

00802500 <__udivdi3>:
  802500:	55                   	push   %ebp
  802501:	57                   	push   %edi
  802502:	56                   	push   %esi
  802503:	83 ec 0c             	sub    $0xc,%esp
  802506:	8b 44 24 28          	mov    0x28(%esp),%eax
  80250a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80250e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802512:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802516:	85 c0                	test   %eax,%eax
  802518:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80251c:	89 ea                	mov    %ebp,%edx
  80251e:	89 0c 24             	mov    %ecx,(%esp)
  802521:	75 2d                	jne    802550 <__udivdi3+0x50>
  802523:	39 e9                	cmp    %ebp,%ecx
  802525:	77 61                	ja     802588 <__udivdi3+0x88>
  802527:	85 c9                	test   %ecx,%ecx
  802529:	89 ce                	mov    %ecx,%esi
  80252b:	75 0b                	jne    802538 <__udivdi3+0x38>
  80252d:	b8 01 00 00 00       	mov    $0x1,%eax
  802532:	31 d2                	xor    %edx,%edx
  802534:	f7 f1                	div    %ecx
  802536:	89 c6                	mov    %eax,%esi
  802538:	31 d2                	xor    %edx,%edx
  80253a:	89 e8                	mov    %ebp,%eax
  80253c:	f7 f6                	div    %esi
  80253e:	89 c5                	mov    %eax,%ebp
  802540:	89 f8                	mov    %edi,%eax
  802542:	f7 f6                	div    %esi
  802544:	89 ea                	mov    %ebp,%edx
  802546:	83 c4 0c             	add    $0xc,%esp
  802549:	5e                   	pop    %esi
  80254a:	5f                   	pop    %edi
  80254b:	5d                   	pop    %ebp
  80254c:	c3                   	ret    
  80254d:	8d 76 00             	lea    0x0(%esi),%esi
  802550:	39 e8                	cmp    %ebp,%eax
  802552:	77 24                	ja     802578 <__udivdi3+0x78>
  802554:	0f bd e8             	bsr    %eax,%ebp
  802557:	83 f5 1f             	xor    $0x1f,%ebp
  80255a:	75 3c                	jne    802598 <__udivdi3+0x98>
  80255c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802560:	39 34 24             	cmp    %esi,(%esp)
  802563:	0f 86 9f 00 00 00    	jbe    802608 <__udivdi3+0x108>
  802569:	39 d0                	cmp    %edx,%eax
  80256b:	0f 82 97 00 00 00    	jb     802608 <__udivdi3+0x108>
  802571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802578:	31 d2                	xor    %edx,%edx
  80257a:	31 c0                	xor    %eax,%eax
  80257c:	83 c4 0c             	add    $0xc,%esp
  80257f:	5e                   	pop    %esi
  802580:	5f                   	pop    %edi
  802581:	5d                   	pop    %ebp
  802582:	c3                   	ret    
  802583:	90                   	nop
  802584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802588:	89 f8                	mov    %edi,%eax
  80258a:	f7 f1                	div    %ecx
  80258c:	31 d2                	xor    %edx,%edx
  80258e:	83 c4 0c             	add    $0xc,%esp
  802591:	5e                   	pop    %esi
  802592:	5f                   	pop    %edi
  802593:	5d                   	pop    %ebp
  802594:	c3                   	ret    
  802595:	8d 76 00             	lea    0x0(%esi),%esi
  802598:	89 e9                	mov    %ebp,%ecx
  80259a:	8b 3c 24             	mov    (%esp),%edi
  80259d:	d3 e0                	shl    %cl,%eax
  80259f:	89 c6                	mov    %eax,%esi
  8025a1:	b8 20 00 00 00       	mov    $0x20,%eax
  8025a6:	29 e8                	sub    %ebp,%eax
  8025a8:	89 c1                	mov    %eax,%ecx
  8025aa:	d3 ef                	shr    %cl,%edi
  8025ac:	89 e9                	mov    %ebp,%ecx
  8025ae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8025b2:	8b 3c 24             	mov    (%esp),%edi
  8025b5:	09 74 24 08          	or     %esi,0x8(%esp)
  8025b9:	89 d6                	mov    %edx,%esi
  8025bb:	d3 e7                	shl    %cl,%edi
  8025bd:	89 c1                	mov    %eax,%ecx
  8025bf:	89 3c 24             	mov    %edi,(%esp)
  8025c2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025c6:	d3 ee                	shr    %cl,%esi
  8025c8:	89 e9                	mov    %ebp,%ecx
  8025ca:	d3 e2                	shl    %cl,%edx
  8025cc:	89 c1                	mov    %eax,%ecx
  8025ce:	d3 ef                	shr    %cl,%edi
  8025d0:	09 d7                	or     %edx,%edi
  8025d2:	89 f2                	mov    %esi,%edx
  8025d4:	89 f8                	mov    %edi,%eax
  8025d6:	f7 74 24 08          	divl   0x8(%esp)
  8025da:	89 d6                	mov    %edx,%esi
  8025dc:	89 c7                	mov    %eax,%edi
  8025de:	f7 24 24             	mull   (%esp)
  8025e1:	39 d6                	cmp    %edx,%esi
  8025e3:	89 14 24             	mov    %edx,(%esp)
  8025e6:	72 30                	jb     802618 <__udivdi3+0x118>
  8025e8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025ec:	89 e9                	mov    %ebp,%ecx
  8025ee:	d3 e2                	shl    %cl,%edx
  8025f0:	39 c2                	cmp    %eax,%edx
  8025f2:	73 05                	jae    8025f9 <__udivdi3+0xf9>
  8025f4:	3b 34 24             	cmp    (%esp),%esi
  8025f7:	74 1f                	je     802618 <__udivdi3+0x118>
  8025f9:	89 f8                	mov    %edi,%eax
  8025fb:	31 d2                	xor    %edx,%edx
  8025fd:	e9 7a ff ff ff       	jmp    80257c <__udivdi3+0x7c>
  802602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802608:	31 d2                	xor    %edx,%edx
  80260a:	b8 01 00 00 00       	mov    $0x1,%eax
  80260f:	e9 68 ff ff ff       	jmp    80257c <__udivdi3+0x7c>
  802614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802618:	8d 47 ff             	lea    -0x1(%edi),%eax
  80261b:	31 d2                	xor    %edx,%edx
  80261d:	83 c4 0c             	add    $0xc,%esp
  802620:	5e                   	pop    %esi
  802621:	5f                   	pop    %edi
  802622:	5d                   	pop    %ebp
  802623:	c3                   	ret    
  802624:	66 90                	xchg   %ax,%ax
  802626:	66 90                	xchg   %ax,%ax
  802628:	66 90                	xchg   %ax,%ax
  80262a:	66 90                	xchg   %ax,%ax
  80262c:	66 90                	xchg   %ax,%ax
  80262e:	66 90                	xchg   %ax,%ax

00802630 <__umoddi3>:
  802630:	55                   	push   %ebp
  802631:	57                   	push   %edi
  802632:	56                   	push   %esi
  802633:	83 ec 14             	sub    $0x14,%esp
  802636:	8b 44 24 28          	mov    0x28(%esp),%eax
  80263a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80263e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802642:	89 c7                	mov    %eax,%edi
  802644:	89 44 24 04          	mov    %eax,0x4(%esp)
  802648:	8b 44 24 30          	mov    0x30(%esp),%eax
  80264c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802650:	89 34 24             	mov    %esi,(%esp)
  802653:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802657:	85 c0                	test   %eax,%eax
  802659:	89 c2                	mov    %eax,%edx
  80265b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80265f:	75 17                	jne    802678 <__umoddi3+0x48>
  802661:	39 fe                	cmp    %edi,%esi
  802663:	76 4b                	jbe    8026b0 <__umoddi3+0x80>
  802665:	89 c8                	mov    %ecx,%eax
  802667:	89 fa                	mov    %edi,%edx
  802669:	f7 f6                	div    %esi
  80266b:	89 d0                	mov    %edx,%eax
  80266d:	31 d2                	xor    %edx,%edx
  80266f:	83 c4 14             	add    $0x14,%esp
  802672:	5e                   	pop    %esi
  802673:	5f                   	pop    %edi
  802674:	5d                   	pop    %ebp
  802675:	c3                   	ret    
  802676:	66 90                	xchg   %ax,%ax
  802678:	39 f8                	cmp    %edi,%eax
  80267a:	77 54                	ja     8026d0 <__umoddi3+0xa0>
  80267c:	0f bd e8             	bsr    %eax,%ebp
  80267f:	83 f5 1f             	xor    $0x1f,%ebp
  802682:	75 5c                	jne    8026e0 <__umoddi3+0xb0>
  802684:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802688:	39 3c 24             	cmp    %edi,(%esp)
  80268b:	0f 87 e7 00 00 00    	ja     802778 <__umoddi3+0x148>
  802691:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802695:	29 f1                	sub    %esi,%ecx
  802697:	19 c7                	sbb    %eax,%edi
  802699:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80269d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026a1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026a5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8026a9:	83 c4 14             	add    $0x14,%esp
  8026ac:	5e                   	pop    %esi
  8026ad:	5f                   	pop    %edi
  8026ae:	5d                   	pop    %ebp
  8026af:	c3                   	ret    
  8026b0:	85 f6                	test   %esi,%esi
  8026b2:	89 f5                	mov    %esi,%ebp
  8026b4:	75 0b                	jne    8026c1 <__umoddi3+0x91>
  8026b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8026bb:	31 d2                	xor    %edx,%edx
  8026bd:	f7 f6                	div    %esi
  8026bf:	89 c5                	mov    %eax,%ebp
  8026c1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026c5:	31 d2                	xor    %edx,%edx
  8026c7:	f7 f5                	div    %ebp
  8026c9:	89 c8                	mov    %ecx,%eax
  8026cb:	f7 f5                	div    %ebp
  8026cd:	eb 9c                	jmp    80266b <__umoddi3+0x3b>
  8026cf:	90                   	nop
  8026d0:	89 c8                	mov    %ecx,%eax
  8026d2:	89 fa                	mov    %edi,%edx
  8026d4:	83 c4 14             	add    $0x14,%esp
  8026d7:	5e                   	pop    %esi
  8026d8:	5f                   	pop    %edi
  8026d9:	5d                   	pop    %ebp
  8026da:	c3                   	ret    
  8026db:	90                   	nop
  8026dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026e0:	8b 04 24             	mov    (%esp),%eax
  8026e3:	be 20 00 00 00       	mov    $0x20,%esi
  8026e8:	89 e9                	mov    %ebp,%ecx
  8026ea:	29 ee                	sub    %ebp,%esi
  8026ec:	d3 e2                	shl    %cl,%edx
  8026ee:	89 f1                	mov    %esi,%ecx
  8026f0:	d3 e8                	shr    %cl,%eax
  8026f2:	89 e9                	mov    %ebp,%ecx
  8026f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026f8:	8b 04 24             	mov    (%esp),%eax
  8026fb:	09 54 24 04          	or     %edx,0x4(%esp)
  8026ff:	89 fa                	mov    %edi,%edx
  802701:	d3 e0                	shl    %cl,%eax
  802703:	89 f1                	mov    %esi,%ecx
  802705:	89 44 24 08          	mov    %eax,0x8(%esp)
  802709:	8b 44 24 10          	mov    0x10(%esp),%eax
  80270d:	d3 ea                	shr    %cl,%edx
  80270f:	89 e9                	mov    %ebp,%ecx
  802711:	d3 e7                	shl    %cl,%edi
  802713:	89 f1                	mov    %esi,%ecx
  802715:	d3 e8                	shr    %cl,%eax
  802717:	89 e9                	mov    %ebp,%ecx
  802719:	09 f8                	or     %edi,%eax
  80271b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80271f:	f7 74 24 04          	divl   0x4(%esp)
  802723:	d3 e7                	shl    %cl,%edi
  802725:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802729:	89 d7                	mov    %edx,%edi
  80272b:	f7 64 24 08          	mull   0x8(%esp)
  80272f:	39 d7                	cmp    %edx,%edi
  802731:	89 c1                	mov    %eax,%ecx
  802733:	89 14 24             	mov    %edx,(%esp)
  802736:	72 2c                	jb     802764 <__umoddi3+0x134>
  802738:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80273c:	72 22                	jb     802760 <__umoddi3+0x130>
  80273e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802742:	29 c8                	sub    %ecx,%eax
  802744:	19 d7                	sbb    %edx,%edi
  802746:	89 e9                	mov    %ebp,%ecx
  802748:	89 fa                	mov    %edi,%edx
  80274a:	d3 e8                	shr    %cl,%eax
  80274c:	89 f1                	mov    %esi,%ecx
  80274e:	d3 e2                	shl    %cl,%edx
  802750:	89 e9                	mov    %ebp,%ecx
  802752:	d3 ef                	shr    %cl,%edi
  802754:	09 d0                	or     %edx,%eax
  802756:	89 fa                	mov    %edi,%edx
  802758:	83 c4 14             	add    $0x14,%esp
  80275b:	5e                   	pop    %esi
  80275c:	5f                   	pop    %edi
  80275d:	5d                   	pop    %ebp
  80275e:	c3                   	ret    
  80275f:	90                   	nop
  802760:	39 d7                	cmp    %edx,%edi
  802762:	75 da                	jne    80273e <__umoddi3+0x10e>
  802764:	8b 14 24             	mov    (%esp),%edx
  802767:	89 c1                	mov    %eax,%ecx
  802769:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80276d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802771:	eb cb                	jmp    80273e <__umoddi3+0x10e>
  802773:	90                   	nop
  802774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802778:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80277c:	0f 82 0f ff ff ff    	jb     802691 <__umoddi3+0x61>
  802782:	e9 1a ff ff ff       	jmp    8026a1 <__umoddi3+0x71>
