
obj/user/sendpage.debug:     file format elf32-i386


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
  80002c:	e8 af 01 00 00       	call   8001e0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 28             	sub    $0x28,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  800039:	e8 32 11 00 00       	call   801170 <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 85 bd 00 00 00    	jne    800106 <umain+0xd3>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  800049:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800050:	00 
  800051:	c7 44 24 04 00 00 b0 	movl   $0xb00000,0x4(%esp)
  800058:	00 
  800059:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80005c:	89 04 24             	mov    %eax,(%esp)
  80005f:	e8 0c 14 00 00       	call   801470 <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  800064:	c7 44 24 08 00 00 b0 	movl   $0xb00000,0x8(%esp)
  80006b:	00 
  80006c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80006f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800073:	c7 04 24 80 2c 80 00 	movl   $0x802c80,(%esp)
  80007a:	e8 65 02 00 00       	call   8002e4 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  80007f:	a1 04 40 80 00       	mov    0x804004,%eax
  800084:	89 04 24             	mov    %eax,(%esp)
  800087:	e8 44 08 00 00       	call   8008d0 <strlen>
  80008c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800090:	a1 04 40 80 00       	mov    0x804004,%eax
  800095:	89 44 24 04          	mov    %eax,0x4(%esp)
  800099:	c7 04 24 00 00 b0 00 	movl   $0xb00000,(%esp)
  8000a0:	e8 3d 09 00 00       	call   8009e2 <strncmp>
  8000a5:	85 c0                	test   %eax,%eax
  8000a7:	75 0c                	jne    8000b5 <umain+0x82>
			cprintf("child received correct message\n");
  8000a9:	c7 04 24 94 2c 80 00 	movl   $0x802c94,(%esp)
  8000b0:	e8 2f 02 00 00       	call   8002e4 <cprintf>

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  8000b5:	a1 00 40 80 00       	mov    0x804000,%eax
  8000ba:	89 04 24             	mov    %eax,(%esp)
  8000bd:	e8 0e 08 00 00       	call   8008d0 <strlen>
  8000c2:	83 c0 01             	add    $0x1,%eax
  8000c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000c9:	a1 00 40 80 00       	mov    0x804000,%eax
  8000ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000d2:	c7 04 24 00 00 b0 00 	movl   $0xb00000,(%esp)
  8000d9:	e8 2e 0a 00 00       	call   800b0c <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  8000de:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8000e5:	00 
  8000e6:	c7 44 24 08 00 00 b0 	movl   $0xb00000,0x8(%esp)
  8000ed:	00 
  8000ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000f5:	00 
  8000f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f9:	89 04 24             	mov    %eax,(%esp)
  8000fc:	e8 d7 13 00 00       	call   8014d8 <ipc_send>
		return;
  800101:	e9 d8 00 00 00       	jmp    8001de <umain+0x1ab>
	}

	// Parent
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800106:	a1 08 50 80 00       	mov    0x805008,%eax
  80010b:	8b 40 48             	mov    0x48(%eax),%eax
  80010e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800115:	00 
  800116:	c7 44 24 04 00 00 a0 	movl   $0xa00000,0x4(%esp)
  80011d:	00 
  80011e:	89 04 24             	mov    %eax,(%esp)
  800121:	e8 fd 0b 00 00       	call   800d23 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  800126:	a1 04 40 80 00       	mov    0x804004,%eax
  80012b:	89 04 24             	mov    %eax,(%esp)
  80012e:	e8 9d 07 00 00       	call   8008d0 <strlen>
  800133:	83 c0 01             	add    $0x1,%eax
  800136:	89 44 24 08          	mov    %eax,0x8(%esp)
  80013a:	a1 04 40 80 00       	mov    0x804004,%eax
  80013f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800143:	c7 04 24 00 00 a0 00 	movl   $0xa00000,(%esp)
  80014a:	e8 bd 09 00 00       	call   800b0c <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  80014f:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800156:	00 
  800157:	c7 44 24 08 00 00 a0 	movl   $0xa00000,0x8(%esp)
  80015e:	00 
  80015f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800166:	00 
  800167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80016a:	89 04 24             	mov    %eax,(%esp)
  80016d:	e8 66 13 00 00       	call   8014d8 <ipc_send>

	ipc_recv(&who, TEMP_ADDR, 0);
  800172:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800179:	00 
  80017a:	c7 44 24 04 00 00 a0 	movl   $0xa00000,0x4(%esp)
  800181:	00 
  800182:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800185:	89 04 24             	mov    %eax,(%esp)
  800188:	e8 e3 12 00 00       	call   801470 <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  80018d:	c7 44 24 08 00 00 a0 	movl   $0xa00000,0x8(%esp)
  800194:	00 
  800195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019c:	c7 04 24 80 2c 80 00 	movl   $0x802c80,(%esp)
  8001a3:	e8 3c 01 00 00       	call   8002e4 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  8001a8:	a1 00 40 80 00       	mov    0x804000,%eax
  8001ad:	89 04 24             	mov    %eax,(%esp)
  8001b0:	e8 1b 07 00 00       	call   8008d0 <strlen>
  8001b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001b9:	a1 00 40 80 00       	mov    0x804000,%eax
  8001be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001c2:	c7 04 24 00 00 a0 00 	movl   $0xa00000,(%esp)
  8001c9:	e8 14 08 00 00       	call   8009e2 <strncmp>
  8001ce:	85 c0                	test   %eax,%eax
  8001d0:	75 0c                	jne    8001de <umain+0x1ab>
		cprintf("parent received correct message\n");
  8001d2:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  8001d9:	e8 06 01 00 00       	call   8002e4 <cprintf>
	return;
}
  8001de:	c9                   	leave  
  8001df:	c3                   	ret    

008001e0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	56                   	push   %esi
  8001e4:	53                   	push   %ebx
  8001e5:	83 ec 10             	sub    $0x10,%esp
  8001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001ee:	e8 f2 0a 00 00       	call   800ce5 <sys_getenvid>
  8001f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001f8:	c1 e0 07             	shl    $0x7,%eax
  8001fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800200:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800205:	85 db                	test   %ebx,%ebx
  800207:	7e 07                	jle    800210 <libmain+0x30>
		binaryname = argv[0];
  800209:	8b 06                	mov    (%esi),%eax
  80020b:	a3 08 40 80 00       	mov    %eax,0x804008

	// call user main routine
	umain(argc, argv);
  800210:	89 74 24 04          	mov    %esi,0x4(%esp)
  800214:	89 1c 24             	mov    %ebx,(%esp)
  800217:	e8 17 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80021c:	e8 07 00 00 00       	call   800228 <exit>
}
  800221:	83 c4 10             	add    $0x10,%esp
  800224:	5b                   	pop    %ebx
  800225:	5e                   	pop    %esi
  800226:	5d                   	pop    %ebp
  800227:	c3                   	ret    

00800228 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800228:	55                   	push   %ebp
  800229:	89 e5                	mov    %esp,%ebp
  80022b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80022e:	e8 47 15 00 00       	call   80177a <close_all>
	sys_env_destroy(0);
  800233:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80023a:	e8 54 0a 00 00       	call   800c93 <sys_env_destroy>
}
  80023f:	c9                   	leave  
  800240:	c3                   	ret    

00800241 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800241:	55                   	push   %ebp
  800242:	89 e5                	mov    %esp,%ebp
  800244:	53                   	push   %ebx
  800245:	83 ec 14             	sub    $0x14,%esp
  800248:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80024b:	8b 13                	mov    (%ebx),%edx
  80024d:	8d 42 01             	lea    0x1(%edx),%eax
  800250:	89 03                	mov    %eax,(%ebx)
  800252:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800255:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800259:	3d ff 00 00 00       	cmp    $0xff,%eax
  80025e:	75 19                	jne    800279 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800260:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800267:	00 
  800268:	8d 43 08             	lea    0x8(%ebx),%eax
  80026b:	89 04 24             	mov    %eax,(%esp)
  80026e:	e8 e3 09 00 00       	call   800c56 <sys_cputs>
		b->idx = 0;
  800273:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800279:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80027d:	83 c4 14             	add    $0x14,%esp
  800280:	5b                   	pop    %ebx
  800281:	5d                   	pop    %ebp
  800282:	c3                   	ret    

00800283 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80028c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800293:	00 00 00 
	b.cnt = 0;
  800296:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80029d:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b8:	c7 04 24 41 02 80 00 	movl   $0x800241,(%esp)
  8002bf:	e8 aa 01 00 00       	call   80046e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002c4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ce:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002d4:	89 04 24             	mov    %eax,(%esp)
  8002d7:	e8 7a 09 00 00       	call   800c56 <sys_cputs>

	return b.cnt;
}
  8002dc:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002e2:	c9                   	leave  
  8002e3:	c3                   	ret    

008002e4 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002ea:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f4:	89 04 24             	mov    %eax,(%esp)
  8002f7:	e8 87 ff ff ff       	call   800283 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002fc:	c9                   	leave  
  8002fd:	c3                   	ret    
  8002fe:	66 90                	xchg   %ax,%ax

00800300 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	57                   	push   %edi
  800304:	56                   	push   %esi
  800305:	53                   	push   %ebx
  800306:	83 ec 3c             	sub    $0x3c,%esp
  800309:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80030c:	89 d7                	mov    %edx,%edi
  80030e:	8b 45 08             	mov    0x8(%ebp),%eax
  800311:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800314:	8b 45 0c             	mov    0xc(%ebp),%eax
  800317:	89 c3                	mov    %eax,%ebx
  800319:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80031c:	8b 45 10             	mov    0x10(%ebp),%eax
  80031f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800322:	b9 00 00 00 00       	mov    $0x0,%ecx
  800327:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80032a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80032d:	39 d9                	cmp    %ebx,%ecx
  80032f:	72 05                	jb     800336 <printnum+0x36>
  800331:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800334:	77 69                	ja     80039f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800336:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800339:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80033d:	83 ee 01             	sub    $0x1,%esi
  800340:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800344:	89 44 24 08          	mov    %eax,0x8(%esp)
  800348:	8b 44 24 08          	mov    0x8(%esp),%eax
  80034c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800350:	89 c3                	mov    %eax,%ebx
  800352:	89 d6                	mov    %edx,%esi
  800354:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800357:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80035a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80035e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800362:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800365:	89 04 24             	mov    %eax,(%esp)
  800368:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80036b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80036f:	e8 7c 26 00 00       	call   8029f0 <__udivdi3>
  800374:	89 d9                	mov    %ebx,%ecx
  800376:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80037a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80037e:	89 04 24             	mov    %eax,(%esp)
  800381:	89 54 24 04          	mov    %edx,0x4(%esp)
  800385:	89 fa                	mov    %edi,%edx
  800387:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80038a:	e8 71 ff ff ff       	call   800300 <printnum>
  80038f:	eb 1b                	jmp    8003ac <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800391:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800395:	8b 45 18             	mov    0x18(%ebp),%eax
  800398:	89 04 24             	mov    %eax,(%esp)
  80039b:	ff d3                	call   *%ebx
  80039d:	eb 03                	jmp    8003a2 <printnum+0xa2>
  80039f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003a2:	83 ee 01             	sub    $0x1,%esi
  8003a5:	85 f6                	test   %esi,%esi
  8003a7:	7f e8                	jg     800391 <printnum+0x91>
  8003a9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003ac:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003b0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003b7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8003ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003be:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003c5:	89 04 24             	mov    %eax,(%esp)
  8003c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003cf:	e8 4c 27 00 00       	call   802b20 <__umoddi3>
  8003d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003d8:	0f be 80 2c 2d 80 00 	movsbl 0x802d2c(%eax),%eax
  8003df:	89 04 24             	mov    %eax,(%esp)
  8003e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003e5:	ff d0                	call   *%eax
}
  8003e7:	83 c4 3c             	add    $0x3c,%esp
  8003ea:	5b                   	pop    %ebx
  8003eb:	5e                   	pop    %esi
  8003ec:	5f                   	pop    %edi
  8003ed:	5d                   	pop    %ebp
  8003ee:	c3                   	ret    

008003ef <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003f2:	83 fa 01             	cmp    $0x1,%edx
  8003f5:	7e 0e                	jle    800405 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003f7:	8b 10                	mov    (%eax),%edx
  8003f9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003fc:	89 08                	mov    %ecx,(%eax)
  8003fe:	8b 02                	mov    (%edx),%eax
  800400:	8b 52 04             	mov    0x4(%edx),%edx
  800403:	eb 22                	jmp    800427 <getuint+0x38>
	else if (lflag)
  800405:	85 d2                	test   %edx,%edx
  800407:	74 10                	je     800419 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800409:	8b 10                	mov    (%eax),%edx
  80040b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80040e:	89 08                	mov    %ecx,(%eax)
  800410:	8b 02                	mov    (%edx),%eax
  800412:	ba 00 00 00 00       	mov    $0x0,%edx
  800417:	eb 0e                	jmp    800427 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800419:	8b 10                	mov    (%eax),%edx
  80041b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80041e:	89 08                	mov    %ecx,(%eax)
  800420:	8b 02                	mov    (%edx),%eax
  800422:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800427:	5d                   	pop    %ebp
  800428:	c3                   	ret    

00800429 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800429:	55                   	push   %ebp
  80042a:	89 e5                	mov    %esp,%ebp
  80042c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80042f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800433:	8b 10                	mov    (%eax),%edx
  800435:	3b 50 04             	cmp    0x4(%eax),%edx
  800438:	73 0a                	jae    800444 <sprintputch+0x1b>
		*b->buf++ = ch;
  80043a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80043d:	89 08                	mov    %ecx,(%eax)
  80043f:	8b 45 08             	mov    0x8(%ebp),%eax
  800442:	88 02                	mov    %al,(%edx)
}
  800444:	5d                   	pop    %ebp
  800445:	c3                   	ret    

00800446 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
  800449:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80044c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80044f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	89 44 24 08          	mov    %eax,0x8(%esp)
  80045a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	89 04 24             	mov    %eax,(%esp)
  800467:	e8 02 00 00 00       	call   80046e <vprintfmt>
	va_end(ap);
}
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	57                   	push   %edi
  800472:	56                   	push   %esi
  800473:	53                   	push   %ebx
  800474:	83 ec 3c             	sub    $0x3c,%esp
  800477:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80047a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80047d:	eb 14                	jmp    800493 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80047f:	85 c0                	test   %eax,%eax
  800481:	0f 84 b3 03 00 00    	je     80083a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800487:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80048b:	89 04 24             	mov    %eax,(%esp)
  80048e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800491:	89 f3                	mov    %esi,%ebx
  800493:	8d 73 01             	lea    0x1(%ebx),%esi
  800496:	0f b6 03             	movzbl (%ebx),%eax
  800499:	83 f8 25             	cmp    $0x25,%eax
  80049c:	75 e1                	jne    80047f <vprintfmt+0x11>
  80049e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8004a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004a9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8004b0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8004b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8004bc:	eb 1d                	jmp    8004db <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004be:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8004c0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8004c4:	eb 15                	jmp    8004db <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004c8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8004cc:	eb 0d                	jmp    8004db <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8004ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004d1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004d4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004db:	8d 5e 01             	lea    0x1(%esi),%ebx
  8004de:	0f b6 0e             	movzbl (%esi),%ecx
  8004e1:	0f b6 c1             	movzbl %cl,%eax
  8004e4:	83 e9 23             	sub    $0x23,%ecx
  8004e7:	80 f9 55             	cmp    $0x55,%cl
  8004ea:	0f 87 2a 03 00 00    	ja     80081a <vprintfmt+0x3ac>
  8004f0:	0f b6 c9             	movzbl %cl,%ecx
  8004f3:	ff 24 8d 60 2e 80 00 	jmp    *0x802e60(,%ecx,4)
  8004fa:	89 de                	mov    %ebx,%esi
  8004fc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800501:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800504:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800508:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80050b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80050e:	83 fb 09             	cmp    $0x9,%ebx
  800511:	77 36                	ja     800549 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800513:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800516:	eb e9                	jmp    800501 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	8d 48 04             	lea    0x4(%eax),%ecx
  80051e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800521:	8b 00                	mov    (%eax),%eax
  800523:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800526:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800528:	eb 22                	jmp    80054c <vprintfmt+0xde>
  80052a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80052d:	85 c9                	test   %ecx,%ecx
  80052f:	b8 00 00 00 00       	mov    $0x0,%eax
  800534:	0f 49 c1             	cmovns %ecx,%eax
  800537:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053a:	89 de                	mov    %ebx,%esi
  80053c:	eb 9d                	jmp    8004db <vprintfmt+0x6d>
  80053e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800540:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800547:	eb 92                	jmp    8004db <vprintfmt+0x6d>
  800549:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80054c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800550:	79 89                	jns    8004db <vprintfmt+0x6d>
  800552:	e9 77 ff ff ff       	jmp    8004ce <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800557:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80055c:	e9 7a ff ff ff       	jmp    8004db <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800561:	8b 45 14             	mov    0x14(%ebp),%eax
  800564:	8d 50 04             	lea    0x4(%eax),%edx
  800567:	89 55 14             	mov    %edx,0x14(%ebp)
  80056a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80056e:	8b 00                	mov    (%eax),%eax
  800570:	89 04 24             	mov    %eax,(%esp)
  800573:	ff 55 08             	call   *0x8(%ebp)
			break;
  800576:	e9 18 ff ff ff       	jmp    800493 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80057b:	8b 45 14             	mov    0x14(%ebp),%eax
  80057e:	8d 50 04             	lea    0x4(%eax),%edx
  800581:	89 55 14             	mov    %edx,0x14(%ebp)
  800584:	8b 00                	mov    (%eax),%eax
  800586:	99                   	cltd   
  800587:	31 d0                	xor    %edx,%eax
  800589:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80058b:	83 f8 11             	cmp    $0x11,%eax
  80058e:	7f 0b                	jg     80059b <vprintfmt+0x12d>
  800590:	8b 14 85 c0 2f 80 00 	mov    0x802fc0(,%eax,4),%edx
  800597:	85 d2                	test   %edx,%edx
  800599:	75 20                	jne    8005bb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80059b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80059f:	c7 44 24 08 44 2d 80 	movl   $0x802d44,0x8(%esp)
  8005a6:	00 
  8005a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ae:	89 04 24             	mov    %eax,(%esp)
  8005b1:	e8 90 fe ff ff       	call   800446 <printfmt>
  8005b6:	e9 d8 fe ff ff       	jmp    800493 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8005bb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005bf:	c7 44 24 08 05 32 80 	movl   $0x803205,0x8(%esp)
  8005c6:	00 
  8005c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ce:	89 04 24             	mov    %eax,(%esp)
  8005d1:	e8 70 fe ff ff       	call   800446 <printfmt>
  8005d6:	e9 b8 fe ff ff       	jmp    800493 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005db:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8d 50 04             	lea    0x4(%eax),%edx
  8005ea:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ed:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8005ef:	85 f6                	test   %esi,%esi
  8005f1:	b8 3d 2d 80 00       	mov    $0x802d3d,%eax
  8005f6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8005f9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8005fd:	0f 84 97 00 00 00    	je     80069a <vprintfmt+0x22c>
  800603:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800607:	0f 8e 9b 00 00 00    	jle    8006a8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80060d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800611:	89 34 24             	mov    %esi,(%esp)
  800614:	e8 cf 02 00 00       	call   8008e8 <strnlen>
  800619:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80061c:	29 c2                	sub    %eax,%edx
  80061e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800621:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800625:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800628:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80062b:	8b 75 08             	mov    0x8(%ebp),%esi
  80062e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800631:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800633:	eb 0f                	jmp    800644 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800635:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800639:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80063c:	89 04 24             	mov    %eax,(%esp)
  80063f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800641:	83 eb 01             	sub    $0x1,%ebx
  800644:	85 db                	test   %ebx,%ebx
  800646:	7f ed                	jg     800635 <vprintfmt+0x1c7>
  800648:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80064b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80064e:	85 d2                	test   %edx,%edx
  800650:	b8 00 00 00 00       	mov    $0x0,%eax
  800655:	0f 49 c2             	cmovns %edx,%eax
  800658:	29 c2                	sub    %eax,%edx
  80065a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80065d:	89 d7                	mov    %edx,%edi
  80065f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800662:	eb 50                	jmp    8006b4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800664:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800668:	74 1e                	je     800688 <vprintfmt+0x21a>
  80066a:	0f be d2             	movsbl %dl,%edx
  80066d:	83 ea 20             	sub    $0x20,%edx
  800670:	83 fa 5e             	cmp    $0x5e,%edx
  800673:	76 13                	jbe    800688 <vprintfmt+0x21a>
					putch('?', putdat);
  800675:	8b 45 0c             	mov    0xc(%ebp),%eax
  800678:	89 44 24 04          	mov    %eax,0x4(%esp)
  80067c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800683:	ff 55 08             	call   *0x8(%ebp)
  800686:	eb 0d                	jmp    800695 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800688:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80068f:	89 04 24             	mov    %eax,(%esp)
  800692:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800695:	83 ef 01             	sub    $0x1,%edi
  800698:	eb 1a                	jmp    8006b4 <vprintfmt+0x246>
  80069a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80069d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006a0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006a3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006a6:	eb 0c                	jmp    8006b4 <vprintfmt+0x246>
  8006a8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006ab:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006ae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006b1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006b4:	83 c6 01             	add    $0x1,%esi
  8006b7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8006bb:	0f be c2             	movsbl %dl,%eax
  8006be:	85 c0                	test   %eax,%eax
  8006c0:	74 27                	je     8006e9 <vprintfmt+0x27b>
  8006c2:	85 db                	test   %ebx,%ebx
  8006c4:	78 9e                	js     800664 <vprintfmt+0x1f6>
  8006c6:	83 eb 01             	sub    $0x1,%ebx
  8006c9:	79 99                	jns    800664 <vprintfmt+0x1f6>
  8006cb:	89 f8                	mov    %edi,%eax
  8006cd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006d0:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d3:	89 c3                	mov    %eax,%ebx
  8006d5:	eb 1a                	jmp    8006f1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006db:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006e2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006e4:	83 eb 01             	sub    $0x1,%ebx
  8006e7:	eb 08                	jmp    8006f1 <vprintfmt+0x283>
  8006e9:	89 fb                	mov    %edi,%ebx
  8006eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ee:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006f1:	85 db                	test   %ebx,%ebx
  8006f3:	7f e2                	jg     8006d7 <vprintfmt+0x269>
  8006f5:	89 75 08             	mov    %esi,0x8(%ebp)
  8006f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006fb:	e9 93 fd ff ff       	jmp    800493 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800700:	83 fa 01             	cmp    $0x1,%edx
  800703:	7e 16                	jle    80071b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	8d 50 08             	lea    0x8(%eax),%edx
  80070b:	89 55 14             	mov    %edx,0x14(%ebp)
  80070e:	8b 50 04             	mov    0x4(%eax),%edx
  800711:	8b 00                	mov    (%eax),%eax
  800713:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800716:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800719:	eb 32                	jmp    80074d <vprintfmt+0x2df>
	else if (lflag)
  80071b:	85 d2                	test   %edx,%edx
  80071d:	74 18                	je     800737 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	8d 50 04             	lea    0x4(%eax),%edx
  800725:	89 55 14             	mov    %edx,0x14(%ebp)
  800728:	8b 30                	mov    (%eax),%esi
  80072a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80072d:	89 f0                	mov    %esi,%eax
  80072f:	c1 f8 1f             	sar    $0x1f,%eax
  800732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800735:	eb 16                	jmp    80074d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8d 50 04             	lea    0x4(%eax),%edx
  80073d:	89 55 14             	mov    %edx,0x14(%ebp)
  800740:	8b 30                	mov    (%eax),%esi
  800742:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800745:	89 f0                	mov    %esi,%eax
  800747:	c1 f8 1f             	sar    $0x1f,%eax
  80074a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80074d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800750:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800753:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800758:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80075c:	0f 89 80 00 00 00    	jns    8007e2 <vprintfmt+0x374>
				putch('-', putdat);
  800762:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800766:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80076d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800770:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800773:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800776:	f7 d8                	neg    %eax
  800778:	83 d2 00             	adc    $0x0,%edx
  80077b:	f7 da                	neg    %edx
			}
			base = 10;
  80077d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800782:	eb 5e                	jmp    8007e2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800784:	8d 45 14             	lea    0x14(%ebp),%eax
  800787:	e8 63 fc ff ff       	call   8003ef <getuint>
			base = 10;
  80078c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800791:	eb 4f                	jmp    8007e2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800793:	8d 45 14             	lea    0x14(%ebp),%eax
  800796:	e8 54 fc ff ff       	call   8003ef <getuint>
			base = 8;
  80079b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8007a0:	eb 40                	jmp    8007e2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  8007a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007ad:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8007b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007b4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007bb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8007be:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c1:	8d 50 04             	lea    0x4(%eax),%edx
  8007c4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8007ce:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007d3:	eb 0d                	jmp    8007e2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007d5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d8:	e8 12 fc ff ff       	call   8003ef <getuint>
			base = 16;
  8007dd:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007e2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8007e6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007ea:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8007ed:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007f1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007f5:	89 04 24             	mov    %eax,(%esp)
  8007f8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007fc:	89 fa                	mov    %edi,%edx
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	e8 fa fa ff ff       	call   800300 <printnum>
			break;
  800806:	e9 88 fc ff ff       	jmp    800493 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80080b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80080f:	89 04 24             	mov    %eax,(%esp)
  800812:	ff 55 08             	call   *0x8(%ebp)
			break;
  800815:	e9 79 fc ff ff       	jmp    800493 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80081a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80081e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800825:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800828:	89 f3                	mov    %esi,%ebx
  80082a:	eb 03                	jmp    80082f <vprintfmt+0x3c1>
  80082c:	83 eb 01             	sub    $0x1,%ebx
  80082f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800833:	75 f7                	jne    80082c <vprintfmt+0x3be>
  800835:	e9 59 fc ff ff       	jmp    800493 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80083a:	83 c4 3c             	add    $0x3c,%esp
  80083d:	5b                   	pop    %ebx
  80083e:	5e                   	pop    %esi
  80083f:	5f                   	pop    %edi
  800840:	5d                   	pop    %ebp
  800841:	c3                   	ret    

00800842 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800842:	55                   	push   %ebp
  800843:	89 e5                	mov    %esp,%ebp
  800845:	83 ec 28             	sub    $0x28,%esp
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80084e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800851:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800855:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800858:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80085f:	85 c0                	test   %eax,%eax
  800861:	74 30                	je     800893 <vsnprintf+0x51>
  800863:	85 d2                	test   %edx,%edx
  800865:	7e 2c                	jle    800893 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800867:	8b 45 14             	mov    0x14(%ebp),%eax
  80086a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80086e:	8b 45 10             	mov    0x10(%ebp),%eax
  800871:	89 44 24 08          	mov    %eax,0x8(%esp)
  800875:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800878:	89 44 24 04          	mov    %eax,0x4(%esp)
  80087c:	c7 04 24 29 04 80 00 	movl   $0x800429,(%esp)
  800883:	e8 e6 fb ff ff       	call   80046e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800888:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80088b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80088e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800891:	eb 05                	jmp    800898 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800893:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800898:	c9                   	leave  
  800899:	c3                   	ret    

0080089a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008a0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b8:	89 04 24             	mov    %eax,(%esp)
  8008bb:	e8 82 ff ff ff       	call   800842 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008c0:	c9                   	leave  
  8008c1:	c3                   	ret    
  8008c2:	66 90                	xchg   %ax,%ax
  8008c4:	66 90                	xchg   %ax,%ax
  8008c6:	66 90                	xchg   %ax,%ax
  8008c8:	66 90                	xchg   %ax,%ax
  8008ca:	66 90                	xchg   %ax,%ax
  8008cc:	66 90                	xchg   %ax,%ax
  8008ce:	66 90                	xchg   %ax,%ax

008008d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008db:	eb 03                	jmp    8008e0 <strlen+0x10>
		n++;
  8008dd:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008e0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008e4:	75 f7                	jne    8008dd <strlen+0xd>
		n++;
	return n;
}
  8008e6:	5d                   	pop    %ebp
  8008e7:	c3                   	ret    

008008e8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008ee:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f6:	eb 03                	jmp    8008fb <strnlen+0x13>
		n++;
  8008f8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008fb:	39 d0                	cmp    %edx,%eax
  8008fd:	74 06                	je     800905 <strnlen+0x1d>
  8008ff:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800903:	75 f3                	jne    8008f8 <strnlen+0x10>
		n++;
	return n;
}
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    

00800907 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800907:	55                   	push   %ebp
  800908:	89 e5                	mov    %esp,%ebp
  80090a:	53                   	push   %ebx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800911:	89 c2                	mov    %eax,%edx
  800913:	83 c2 01             	add    $0x1,%edx
  800916:	83 c1 01             	add    $0x1,%ecx
  800919:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80091d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800920:	84 db                	test   %bl,%bl
  800922:	75 ef                	jne    800913 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800924:	5b                   	pop    %ebx
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	53                   	push   %ebx
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800931:	89 1c 24             	mov    %ebx,(%esp)
  800934:	e8 97 ff ff ff       	call   8008d0 <strlen>
	strcpy(dst + len, src);
  800939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800940:	01 d8                	add    %ebx,%eax
  800942:	89 04 24             	mov    %eax,(%esp)
  800945:	e8 bd ff ff ff       	call   800907 <strcpy>
	return dst;
}
  80094a:	89 d8                	mov    %ebx,%eax
  80094c:	83 c4 08             	add    $0x8,%esp
  80094f:	5b                   	pop    %ebx
  800950:	5d                   	pop    %ebp
  800951:	c3                   	ret    

00800952 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800952:	55                   	push   %ebp
  800953:	89 e5                	mov    %esp,%ebp
  800955:	56                   	push   %esi
  800956:	53                   	push   %ebx
  800957:	8b 75 08             	mov    0x8(%ebp),%esi
  80095a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095d:	89 f3                	mov    %esi,%ebx
  80095f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800962:	89 f2                	mov    %esi,%edx
  800964:	eb 0f                	jmp    800975 <strncpy+0x23>
		*dst++ = *src;
  800966:	83 c2 01             	add    $0x1,%edx
  800969:	0f b6 01             	movzbl (%ecx),%eax
  80096c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80096f:	80 39 01             	cmpb   $0x1,(%ecx)
  800972:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800975:	39 da                	cmp    %ebx,%edx
  800977:	75 ed                	jne    800966 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800979:	89 f0                	mov    %esi,%eax
  80097b:	5b                   	pop    %ebx
  80097c:	5e                   	pop    %esi
  80097d:	5d                   	pop    %ebp
  80097e:	c3                   	ret    

0080097f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	56                   	push   %esi
  800983:	53                   	push   %ebx
  800984:	8b 75 08             	mov    0x8(%ebp),%esi
  800987:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80098d:	89 f0                	mov    %esi,%eax
  80098f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800993:	85 c9                	test   %ecx,%ecx
  800995:	75 0b                	jne    8009a2 <strlcpy+0x23>
  800997:	eb 1d                	jmp    8009b6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800999:	83 c0 01             	add    $0x1,%eax
  80099c:	83 c2 01             	add    $0x1,%edx
  80099f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009a2:	39 d8                	cmp    %ebx,%eax
  8009a4:	74 0b                	je     8009b1 <strlcpy+0x32>
  8009a6:	0f b6 0a             	movzbl (%edx),%ecx
  8009a9:	84 c9                	test   %cl,%cl
  8009ab:	75 ec                	jne    800999 <strlcpy+0x1a>
  8009ad:	89 c2                	mov    %eax,%edx
  8009af:	eb 02                	jmp    8009b3 <strlcpy+0x34>
  8009b1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8009b3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8009b6:	29 f0                	sub    %esi,%eax
}
  8009b8:	5b                   	pop    %ebx
  8009b9:	5e                   	pop    %esi
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009c2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009c5:	eb 06                	jmp    8009cd <strcmp+0x11>
		p++, q++;
  8009c7:	83 c1 01             	add    $0x1,%ecx
  8009ca:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009cd:	0f b6 01             	movzbl (%ecx),%eax
  8009d0:	84 c0                	test   %al,%al
  8009d2:	74 04                	je     8009d8 <strcmp+0x1c>
  8009d4:	3a 02                	cmp    (%edx),%al
  8009d6:	74 ef                	je     8009c7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d8:	0f b6 c0             	movzbl %al,%eax
  8009db:	0f b6 12             	movzbl (%edx),%edx
  8009de:	29 d0                	sub    %edx,%eax
}
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    

008009e2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	53                   	push   %ebx
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ec:	89 c3                	mov    %eax,%ebx
  8009ee:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009f1:	eb 06                	jmp    8009f9 <strncmp+0x17>
		n--, p++, q++;
  8009f3:	83 c0 01             	add    $0x1,%eax
  8009f6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009f9:	39 d8                	cmp    %ebx,%eax
  8009fb:	74 15                	je     800a12 <strncmp+0x30>
  8009fd:	0f b6 08             	movzbl (%eax),%ecx
  800a00:	84 c9                	test   %cl,%cl
  800a02:	74 04                	je     800a08 <strncmp+0x26>
  800a04:	3a 0a                	cmp    (%edx),%cl
  800a06:	74 eb                	je     8009f3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a08:	0f b6 00             	movzbl (%eax),%eax
  800a0b:	0f b6 12             	movzbl (%edx),%edx
  800a0e:	29 d0                	sub    %edx,%eax
  800a10:	eb 05                	jmp    800a17 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a12:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a17:	5b                   	pop    %ebx
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a24:	eb 07                	jmp    800a2d <strchr+0x13>
		if (*s == c)
  800a26:	38 ca                	cmp    %cl,%dl
  800a28:	74 0f                	je     800a39 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a2a:	83 c0 01             	add    $0x1,%eax
  800a2d:	0f b6 10             	movzbl (%eax),%edx
  800a30:	84 d2                	test   %dl,%dl
  800a32:	75 f2                	jne    800a26 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a39:	5d                   	pop    %ebp
  800a3a:	c3                   	ret    

00800a3b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a3b:	55                   	push   %ebp
  800a3c:	89 e5                	mov    %esp,%ebp
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a45:	eb 07                	jmp    800a4e <strfind+0x13>
		if (*s == c)
  800a47:	38 ca                	cmp    %cl,%dl
  800a49:	74 0a                	je     800a55 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a4b:	83 c0 01             	add    $0x1,%eax
  800a4e:	0f b6 10             	movzbl (%eax),%edx
  800a51:	84 d2                	test   %dl,%dl
  800a53:	75 f2                	jne    800a47 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    

00800a57 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	57                   	push   %edi
  800a5b:	56                   	push   %esi
  800a5c:	53                   	push   %ebx
  800a5d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a60:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a63:	85 c9                	test   %ecx,%ecx
  800a65:	74 36                	je     800a9d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a67:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a6d:	75 28                	jne    800a97 <memset+0x40>
  800a6f:	f6 c1 03             	test   $0x3,%cl
  800a72:	75 23                	jne    800a97 <memset+0x40>
		c &= 0xFF;
  800a74:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a78:	89 d3                	mov    %edx,%ebx
  800a7a:	c1 e3 08             	shl    $0x8,%ebx
  800a7d:	89 d6                	mov    %edx,%esi
  800a7f:	c1 e6 18             	shl    $0x18,%esi
  800a82:	89 d0                	mov    %edx,%eax
  800a84:	c1 e0 10             	shl    $0x10,%eax
  800a87:	09 f0                	or     %esi,%eax
  800a89:	09 c2                	or     %eax,%edx
  800a8b:	89 d0                	mov    %edx,%eax
  800a8d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a8f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a92:	fc                   	cld    
  800a93:	f3 ab                	rep stos %eax,%es:(%edi)
  800a95:	eb 06                	jmp    800a9d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9a:	fc                   	cld    
  800a9b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a9d:	89 f8                	mov    %edi,%eax
  800a9f:	5b                   	pop    %ebx
  800aa0:	5e                   	pop    %esi
  800aa1:	5f                   	pop    %edi
  800aa2:	5d                   	pop    %ebp
  800aa3:	c3                   	ret    

00800aa4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
  800aa7:	57                   	push   %edi
  800aa8:	56                   	push   %esi
  800aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aac:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aaf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ab2:	39 c6                	cmp    %eax,%esi
  800ab4:	73 35                	jae    800aeb <memmove+0x47>
  800ab6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab9:	39 d0                	cmp    %edx,%eax
  800abb:	73 2e                	jae    800aeb <memmove+0x47>
		s += n;
		d += n;
  800abd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800ac0:	89 d6                	mov    %edx,%esi
  800ac2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aca:	75 13                	jne    800adf <memmove+0x3b>
  800acc:	f6 c1 03             	test   $0x3,%cl
  800acf:	75 0e                	jne    800adf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ad1:	83 ef 04             	sub    $0x4,%edi
  800ad4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ad7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800ada:	fd                   	std    
  800adb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800add:	eb 09                	jmp    800ae8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800adf:	83 ef 01             	sub    $0x1,%edi
  800ae2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ae5:	fd                   	std    
  800ae6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ae8:	fc                   	cld    
  800ae9:	eb 1d                	jmp    800b08 <memmove+0x64>
  800aeb:	89 f2                	mov    %esi,%edx
  800aed:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aef:	f6 c2 03             	test   $0x3,%dl
  800af2:	75 0f                	jne    800b03 <memmove+0x5f>
  800af4:	f6 c1 03             	test   $0x3,%cl
  800af7:	75 0a                	jne    800b03 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800af9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800afc:	89 c7                	mov    %eax,%edi
  800afe:	fc                   	cld    
  800aff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b01:	eb 05                	jmp    800b08 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b03:	89 c7                	mov    %eax,%edi
  800b05:	fc                   	cld    
  800b06:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b08:	5e                   	pop    %esi
  800b09:	5f                   	pop    %edi
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    

00800b0c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b12:	8b 45 10             	mov    0x10(%ebp),%eax
  800b15:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	89 04 24             	mov    %eax,(%esp)
  800b26:	e8 79 ff ff ff       	call   800aa4 <memmove>
}
  800b2b:	c9                   	leave  
  800b2c:	c3                   	ret    

00800b2d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	56                   	push   %esi
  800b31:	53                   	push   %ebx
  800b32:	8b 55 08             	mov    0x8(%ebp),%edx
  800b35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b38:	89 d6                	mov    %edx,%esi
  800b3a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b3d:	eb 1a                	jmp    800b59 <memcmp+0x2c>
		if (*s1 != *s2)
  800b3f:	0f b6 02             	movzbl (%edx),%eax
  800b42:	0f b6 19             	movzbl (%ecx),%ebx
  800b45:	38 d8                	cmp    %bl,%al
  800b47:	74 0a                	je     800b53 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b49:	0f b6 c0             	movzbl %al,%eax
  800b4c:	0f b6 db             	movzbl %bl,%ebx
  800b4f:	29 d8                	sub    %ebx,%eax
  800b51:	eb 0f                	jmp    800b62 <memcmp+0x35>
		s1++, s2++;
  800b53:	83 c2 01             	add    $0x1,%edx
  800b56:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b59:	39 f2                	cmp    %esi,%edx
  800b5b:	75 e2                	jne    800b3f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b62:	5b                   	pop    %ebx
  800b63:	5e                   	pop    %esi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b6f:	89 c2                	mov    %eax,%edx
  800b71:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b74:	eb 07                	jmp    800b7d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b76:	38 08                	cmp    %cl,(%eax)
  800b78:	74 07                	je     800b81 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b7a:	83 c0 01             	add    $0x1,%eax
  800b7d:	39 d0                	cmp    %edx,%eax
  800b7f:	72 f5                	jb     800b76 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    

00800b83 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b83:	55                   	push   %ebp
  800b84:	89 e5                	mov    %esp,%ebp
  800b86:	57                   	push   %edi
  800b87:	56                   	push   %esi
  800b88:	53                   	push   %ebx
  800b89:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b8f:	eb 03                	jmp    800b94 <strtol+0x11>
		s++;
  800b91:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b94:	0f b6 0a             	movzbl (%edx),%ecx
  800b97:	80 f9 09             	cmp    $0x9,%cl
  800b9a:	74 f5                	je     800b91 <strtol+0xe>
  800b9c:	80 f9 20             	cmp    $0x20,%cl
  800b9f:	74 f0                	je     800b91 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ba1:	80 f9 2b             	cmp    $0x2b,%cl
  800ba4:	75 0a                	jne    800bb0 <strtol+0x2d>
		s++;
  800ba6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ba9:	bf 00 00 00 00       	mov    $0x0,%edi
  800bae:	eb 11                	jmp    800bc1 <strtol+0x3e>
  800bb0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800bb5:	80 f9 2d             	cmp    $0x2d,%cl
  800bb8:	75 07                	jne    800bc1 <strtol+0x3e>
		s++, neg = 1;
  800bba:	8d 52 01             	lea    0x1(%edx),%edx
  800bbd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800bc6:	75 15                	jne    800bdd <strtol+0x5a>
  800bc8:	80 3a 30             	cmpb   $0x30,(%edx)
  800bcb:	75 10                	jne    800bdd <strtol+0x5a>
  800bcd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bd1:	75 0a                	jne    800bdd <strtol+0x5a>
		s += 2, base = 16;
  800bd3:	83 c2 02             	add    $0x2,%edx
  800bd6:	b8 10 00 00 00       	mov    $0x10,%eax
  800bdb:	eb 10                	jmp    800bed <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800bdd:	85 c0                	test   %eax,%eax
  800bdf:	75 0c                	jne    800bed <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800be1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800be3:	80 3a 30             	cmpb   $0x30,(%edx)
  800be6:	75 05                	jne    800bed <strtol+0x6a>
		s++, base = 8;
  800be8:	83 c2 01             	add    $0x1,%edx
  800beb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bed:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bf2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bf5:	0f b6 0a             	movzbl (%edx),%ecx
  800bf8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bfb:	89 f0                	mov    %esi,%eax
  800bfd:	3c 09                	cmp    $0x9,%al
  800bff:	77 08                	ja     800c09 <strtol+0x86>
			dig = *s - '0';
  800c01:	0f be c9             	movsbl %cl,%ecx
  800c04:	83 e9 30             	sub    $0x30,%ecx
  800c07:	eb 20                	jmp    800c29 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c09:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c0c:	89 f0                	mov    %esi,%eax
  800c0e:	3c 19                	cmp    $0x19,%al
  800c10:	77 08                	ja     800c1a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c12:	0f be c9             	movsbl %cl,%ecx
  800c15:	83 e9 57             	sub    $0x57,%ecx
  800c18:	eb 0f                	jmp    800c29 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c1a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c1d:	89 f0                	mov    %esi,%eax
  800c1f:	3c 19                	cmp    $0x19,%al
  800c21:	77 16                	ja     800c39 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c23:	0f be c9             	movsbl %cl,%ecx
  800c26:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c29:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c2c:	7d 0f                	jge    800c3d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c2e:	83 c2 01             	add    $0x1,%edx
  800c31:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c35:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c37:	eb bc                	jmp    800bf5 <strtol+0x72>
  800c39:	89 d8                	mov    %ebx,%eax
  800c3b:	eb 02                	jmp    800c3f <strtol+0xbc>
  800c3d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c43:	74 05                	je     800c4a <strtol+0xc7>
		*endptr = (char *) s;
  800c45:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c48:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c4a:	f7 d8                	neg    %eax
  800c4c:	85 ff                	test   %edi,%edi
  800c4e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	57                   	push   %edi
  800c5a:	56                   	push   %esi
  800c5b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c64:	8b 55 08             	mov    0x8(%ebp),%edx
  800c67:	89 c3                	mov    %eax,%ebx
  800c69:	89 c7                	mov    %eax,%edi
  800c6b:	89 c6                	mov    %eax,%esi
  800c6d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c6f:	5b                   	pop    %ebx
  800c70:	5e                   	pop    %esi
  800c71:	5f                   	pop    %edi
  800c72:	5d                   	pop    %ebp
  800c73:	c3                   	ret    

00800c74 <sys_cgetc>:

int
sys_cgetc(void)
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
  800c7f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c84:	89 d1                	mov    %edx,%ecx
  800c86:	89 d3                	mov    %edx,%ebx
  800c88:	89 d7                	mov    %edx,%edi
  800c8a:	89 d6                	mov    %edx,%esi
  800c8c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c8e:	5b                   	pop    %ebx
  800c8f:	5e                   	pop    %esi
  800c90:	5f                   	pop    %edi
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800c9c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ca1:	b8 03 00 00 00       	mov    $0x3,%eax
  800ca6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca9:	89 cb                	mov    %ecx,%ebx
  800cab:	89 cf                	mov    %ecx,%edi
  800cad:	89 ce                	mov    %ecx,%esi
  800caf:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800cb1:	85 c0                	test   %eax,%eax
  800cb3:	7e 28                	jle    800cdd <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cb5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cb9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800cc0:	00 
  800cc1:	c7 44 24 08 27 30 80 	movl   $0x803027,0x8(%esp)
  800cc8:	00 
  800cc9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cd0:	00 
  800cd1:	c7 04 24 44 30 80 00 	movl   $0x803044,(%esp)
  800cd8:	e8 d9 1b 00 00       	call   8028b6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cdd:	83 c4 2c             	add    $0x2c,%esp
  800ce0:	5b                   	pop    %ebx
  800ce1:	5e                   	pop    %esi
  800ce2:	5f                   	pop    %edi
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    

00800ce5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	57                   	push   %edi
  800ce9:	56                   	push   %esi
  800cea:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ceb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf0:	b8 02 00 00 00       	mov    $0x2,%eax
  800cf5:	89 d1                	mov    %edx,%ecx
  800cf7:	89 d3                	mov    %edx,%ebx
  800cf9:	89 d7                	mov    %edx,%edi
  800cfb:	89 d6                	mov    %edx,%esi
  800cfd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cff:	5b                   	pop    %ebx
  800d00:	5e                   	pop    %esi
  800d01:	5f                   	pop    %edi
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    

00800d04 <sys_yield>:

void
sys_yield(void)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	57                   	push   %edi
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d14:	89 d1                	mov    %edx,%ecx
  800d16:	89 d3                	mov    %edx,%ebx
  800d18:	89 d7                	mov    %edx,%edi
  800d1a:	89 d6                	mov    %edx,%esi
  800d1c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d1e:	5b                   	pop    %ebx
  800d1f:	5e                   	pop    %esi
  800d20:	5f                   	pop    %edi
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	57                   	push   %edi
  800d27:	56                   	push   %esi
  800d28:	53                   	push   %ebx
  800d29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2c:	be 00 00 00 00       	mov    $0x0,%esi
  800d31:	b8 04 00 00 00       	mov    $0x4,%eax
  800d36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d39:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d3f:	89 f7                	mov    %esi,%edi
  800d41:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d43:	85 c0                	test   %eax,%eax
  800d45:	7e 28                	jle    800d6f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d47:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d4b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d52:	00 
  800d53:	c7 44 24 08 27 30 80 	movl   $0x803027,0x8(%esp)
  800d5a:	00 
  800d5b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d62:	00 
  800d63:	c7 04 24 44 30 80 00 	movl   $0x803044,(%esp)
  800d6a:	e8 47 1b 00 00       	call   8028b6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d6f:	83 c4 2c             	add    $0x2c,%esp
  800d72:	5b                   	pop    %ebx
  800d73:	5e                   	pop    %esi
  800d74:	5f                   	pop    %edi
  800d75:	5d                   	pop    %ebp
  800d76:	c3                   	ret    

00800d77 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	57                   	push   %edi
  800d7b:	56                   	push   %esi
  800d7c:	53                   	push   %ebx
  800d7d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d80:	b8 05 00 00 00       	mov    $0x5,%eax
  800d85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d88:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d8e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d91:	8b 75 18             	mov    0x18(%ebp),%esi
  800d94:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d96:	85 c0                	test   %eax,%eax
  800d98:	7e 28                	jle    800dc2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d9e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800da5:	00 
  800da6:	c7 44 24 08 27 30 80 	movl   $0x803027,0x8(%esp)
  800dad:	00 
  800dae:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800db5:	00 
  800db6:	c7 04 24 44 30 80 00 	movl   $0x803044,(%esp)
  800dbd:	e8 f4 1a 00 00       	call   8028b6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dc2:	83 c4 2c             	add    $0x2c,%esp
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    

00800dca <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	57                   	push   %edi
  800dce:	56                   	push   %esi
  800dcf:	53                   	push   %ebx
  800dd0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd8:	b8 06 00 00 00       	mov    $0x6,%eax
  800ddd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de0:	8b 55 08             	mov    0x8(%ebp),%edx
  800de3:	89 df                	mov    %ebx,%edi
  800de5:	89 de                	mov    %ebx,%esi
  800de7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800de9:	85 c0                	test   %eax,%eax
  800deb:	7e 28                	jle    800e15 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ded:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800df8:	00 
  800df9:	c7 44 24 08 27 30 80 	movl   $0x803027,0x8(%esp)
  800e00:	00 
  800e01:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e08:	00 
  800e09:	c7 04 24 44 30 80 00 	movl   $0x803044,(%esp)
  800e10:	e8 a1 1a 00 00       	call   8028b6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e15:	83 c4 2c             	add    $0x2c,%esp
  800e18:	5b                   	pop    %ebx
  800e19:	5e                   	pop    %esi
  800e1a:	5f                   	pop    %edi
  800e1b:	5d                   	pop    %ebp
  800e1c:	c3                   	ret    

00800e1d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e1d:	55                   	push   %ebp
  800e1e:	89 e5                	mov    %esp,%ebp
  800e20:	57                   	push   %edi
  800e21:	56                   	push   %esi
  800e22:	53                   	push   %ebx
  800e23:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2b:	b8 08 00 00 00       	mov    $0x8,%eax
  800e30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e33:	8b 55 08             	mov    0x8(%ebp),%edx
  800e36:	89 df                	mov    %ebx,%edi
  800e38:	89 de                	mov    %ebx,%esi
  800e3a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e3c:	85 c0                	test   %eax,%eax
  800e3e:	7e 28                	jle    800e68 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e40:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e44:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e4b:	00 
  800e4c:	c7 44 24 08 27 30 80 	movl   $0x803027,0x8(%esp)
  800e53:	00 
  800e54:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e5b:	00 
  800e5c:	c7 04 24 44 30 80 00 	movl   $0x803044,(%esp)
  800e63:	e8 4e 1a 00 00       	call   8028b6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e68:	83 c4 2c             	add    $0x2c,%esp
  800e6b:	5b                   	pop    %ebx
  800e6c:	5e                   	pop    %esi
  800e6d:	5f                   	pop    %edi
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    

00800e70 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	57                   	push   %edi
  800e74:	56                   	push   %esi
  800e75:	53                   	push   %ebx
  800e76:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e79:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e7e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e86:	8b 55 08             	mov    0x8(%ebp),%edx
  800e89:	89 df                	mov    %ebx,%edi
  800e8b:	89 de                	mov    %ebx,%esi
  800e8d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e8f:	85 c0                	test   %eax,%eax
  800e91:	7e 28                	jle    800ebb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e93:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e97:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e9e:	00 
  800e9f:	c7 44 24 08 27 30 80 	movl   $0x803027,0x8(%esp)
  800ea6:	00 
  800ea7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eae:	00 
  800eaf:	c7 04 24 44 30 80 00 	movl   $0x803044,(%esp)
  800eb6:	e8 fb 19 00 00       	call   8028b6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ebb:	83 c4 2c             	add    $0x2c,%esp
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	57                   	push   %edi
  800ec7:	56                   	push   %esi
  800ec8:	53                   	push   %ebx
  800ec9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ecc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ed6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  800edc:	89 df                	mov    %ebx,%edi
  800ede:	89 de                	mov    %ebx,%esi
  800ee0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ee2:	85 c0                	test   %eax,%eax
  800ee4:	7e 28                	jle    800f0e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eea:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ef1:	00 
  800ef2:	c7 44 24 08 27 30 80 	movl   $0x803027,0x8(%esp)
  800ef9:	00 
  800efa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f01:	00 
  800f02:	c7 04 24 44 30 80 00 	movl   $0x803044,(%esp)
  800f09:	e8 a8 19 00 00       	call   8028b6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f0e:	83 c4 2c             	add    $0x2c,%esp
  800f11:	5b                   	pop    %ebx
  800f12:	5e                   	pop    %esi
  800f13:	5f                   	pop    %edi
  800f14:	5d                   	pop    %ebp
  800f15:	c3                   	ret    

00800f16 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	57                   	push   %edi
  800f1a:	56                   	push   %esi
  800f1b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1c:	be 00 00 00 00       	mov    $0x0,%esi
  800f21:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f29:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f32:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f34:	5b                   	pop    %ebx
  800f35:	5e                   	pop    %esi
  800f36:	5f                   	pop    %edi
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    

00800f39 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	57                   	push   %edi
  800f3d:	56                   	push   %esi
  800f3e:	53                   	push   %ebx
  800f3f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f42:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f47:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4f:	89 cb                	mov    %ecx,%ebx
  800f51:	89 cf                	mov    %ecx,%edi
  800f53:	89 ce                	mov    %ecx,%esi
  800f55:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f57:	85 c0                	test   %eax,%eax
  800f59:	7e 28                	jle    800f83 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f5f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f66:	00 
  800f67:	c7 44 24 08 27 30 80 	movl   $0x803027,0x8(%esp)
  800f6e:	00 
  800f6f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f76:	00 
  800f77:	c7 04 24 44 30 80 00 	movl   $0x803044,(%esp)
  800f7e:	e8 33 19 00 00       	call   8028b6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f83:	83 c4 2c             	add    $0x2c,%esp
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    

00800f8b <sys_time_msec>:

unsigned int
sys_time_msec(void)
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
  800f91:	ba 00 00 00 00       	mov    $0x0,%edx
  800f96:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f9b:	89 d1                	mov    %edx,%ecx
  800f9d:	89 d3                	mov    %edx,%ebx
  800f9f:	89 d7                	mov    %edx,%edi
  800fa1:	89 d6                	mov    %edx,%esi
  800fa3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fa5:	5b                   	pop    %ebx
  800fa6:	5e                   	pop    %esi
  800fa7:	5f                   	pop    %edi
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    

00800faa <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	57                   	push   %edi
  800fae:	56                   	push   %esi
  800faf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb5:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc0:	89 df                	mov    %ebx,%edi
  800fc2:	89 de                	mov    %ebx,%esi
  800fc4:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  800fc6:	5b                   	pop    %ebx
  800fc7:	5e                   	pop    %esi
  800fc8:	5f                   	pop    %edi
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    

00800fcb <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
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
  800fd1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd6:	b8 10 00 00 00       	mov    $0x10,%eax
  800fdb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fde:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe1:	89 df                	mov    %ebx,%edi
  800fe3:	89 de                	mov    %ebx,%esi
  800fe5:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  800fe7:	5b                   	pop    %ebx
  800fe8:	5e                   	pop    %esi
  800fe9:	5f                   	pop    %edi
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	57                   	push   %edi
  800ff0:	56                   	push   %esi
  800ff1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff7:	b8 11 00 00 00       	mov    $0x11,%eax
  800ffc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fff:	89 cb                	mov    %ecx,%ebx
  801001:	89 cf                	mov    %ecx,%edi
  801003:	89 ce                	mov    %ecx,%esi
  801005:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801007:	5b                   	pop    %ebx
  801008:	5e                   	pop    %esi
  801009:	5f                   	pop    %edi
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    

0080100c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	57                   	push   %edi
  801010:	56                   	push   %esi
  801011:	53                   	push   %ebx
  801012:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801015:	be 00 00 00 00       	mov    $0x0,%esi
  80101a:	b8 12 00 00 00       	mov    $0x12,%eax
  80101f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801022:	8b 55 08             	mov    0x8(%ebp),%edx
  801025:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801028:	8b 7d 14             	mov    0x14(%ebp),%edi
  80102b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80102d:	85 c0                	test   %eax,%eax
  80102f:	7e 28                	jle    801059 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801031:	89 44 24 10          	mov    %eax,0x10(%esp)
  801035:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80103c:	00 
  80103d:	c7 44 24 08 27 30 80 	movl   $0x803027,0x8(%esp)
  801044:	00 
  801045:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80104c:	00 
  80104d:	c7 04 24 44 30 80 00 	movl   $0x803044,(%esp)
  801054:	e8 5d 18 00 00       	call   8028b6 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801059:	83 c4 2c             	add    $0x2c,%esp
  80105c:	5b                   	pop    %ebx
  80105d:	5e                   	pop    %esi
  80105e:	5f                   	pop    %edi
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    

00801061 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	53                   	push   %ebx
  801065:	83 ec 24             	sub    $0x24,%esp
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80106b:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0)
  80106d:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801071:	75 20                	jne    801093 <pgfault+0x32>
		panic("pgfault: faulting address [%08x] not a write\n", addr);
  801073:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801077:	c7 44 24 08 54 30 80 	movl   $0x803054,0x8(%esp)
  80107e:	00 
  80107f:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  801086:	00 
  801087:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  80108e:	e8 23 18 00 00       	call   8028b6 <_panic>

	void *page_aligned_addr = (void *) ROUNDDOWN(addr, PGSIZE);
  801093:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t page_num = (uint32_t) page_aligned_addr / PGSIZE;
  801099:	89 d8                	mov    %ebx,%eax
  80109b:	c1 e8 0c             	shr    $0xc,%eax
	if (!(uvpt[page_num] & PTE_COW))
  80109e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010a5:	f6 c4 08             	test   $0x8,%ah
  8010a8:	75 1c                	jne    8010c6 <pgfault+0x65>
		panic("pgfault: fault was not on a copy-on-write page\n");
  8010aa:	c7 44 24 08 84 30 80 	movl   $0x803084,0x8(%esp)
  8010b1:	00 
  8010b2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b9:	00 
  8010ba:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  8010c1:	e8 f0 17 00 00       	call   8028b6 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	// Allocate
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8010c6:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8010cd:	00 
  8010ce:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010d5:	00 
  8010d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010dd:	e8 41 fc ff ff       	call   800d23 <sys_page_alloc>
  8010e2:	85 c0                	test   %eax,%eax
  8010e4:	79 20                	jns    801106 <pgfault+0xa5>
		panic("sys_page_alloc: %e\n", r);
  8010e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010ea:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  8010f1:	00 
  8010f2:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  8010f9:	00 
  8010fa:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  801101:	e8 b0 17 00 00       	call   8028b6 <_panic>

	// Copy over
	void *src_addr = (void *) ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, src_addr, PGSIZE);
  801106:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80110d:	00 
  80110e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801112:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801119:	e8 86 f9 ff ff       	call   800aa4 <memmove>

	// Remap
	if ((r = sys_page_map(0, PFTEMP, 0, src_addr, PTE_P | PTE_U | PTE_W)) < 0)
  80111e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801125:	00 
  801126:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80112a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801131:	00 
  801132:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801139:	00 
  80113a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801141:	e8 31 fc ff ff       	call   800d77 <sys_page_map>
  801146:	85 c0                	test   %eax,%eax
  801148:	79 20                	jns    80116a <pgfault+0x109>
		panic("sys_page_map: %e\n", r);
  80114a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80114e:	c7 44 24 08 f3 30 80 	movl   $0x8030f3,0x8(%esp)
  801155:	00 
  801156:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  80115d:	00 
  80115e:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  801165:	e8 4c 17 00 00       	call   8028b6 <_panic>

	//panic("pgfault not implemented");
}
  80116a:	83 c4 24             	add    $0x24,%esp
  80116d:	5b                   	pop    %ebx
  80116e:	5d                   	pop    %ebp
  80116f:	c3                   	ret    

00801170 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	57                   	push   %edi
  801174:	56                   	push   %esi
  801175:	53                   	push   %ebx
  801176:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	int r;
	envid_t child_envid;

	set_pgfault_handler(pgfault);
  801179:	c7 04 24 61 10 80 00 	movl   $0x801061,(%esp)
  801180:	e8 87 17 00 00       	call   80290c <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801185:	b8 07 00 00 00       	mov    $0x7,%eax
  80118a:	cd 30                	int    $0x30
  80118c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80118f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	child_envid = sys_exofork();
	if (child_envid < 0)
  801192:	85 c0                	test   %eax,%eax
  801194:	79 20                	jns    8011b6 <fork+0x46>
		panic("sys_exofork: %e\n", child_envid);
  801196:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80119a:	c7 44 24 08 05 31 80 	movl   $0x803105,0x8(%esp)
  8011a1:	00 
  8011a2:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  8011a9:	00 
  8011aa:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  8011b1:	e8 00 17 00 00       	call   8028b6 <_panic>
	if (child_envid == 0) { // child
  8011b6:	bf 00 00 00 00       	mov    $0x0,%edi
  8011bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8011c4:	75 21                	jne    8011e7 <fork+0x77>
		// Fix thisenv like dumbfork does and return 0
		thisenv = &envs[ENVX(sys_getenvid())];
  8011c6:	e8 1a fb ff ff       	call   800ce5 <sys_getenvid>
  8011cb:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011d0:	c1 e0 07             	shl    $0x7,%eax
  8011d3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8011d8:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8011dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8011e2:	e9 53 02 00 00       	jmp    80143a <fork+0x2ca>
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
  8011e7:	89 d8                	mov    %ebx,%eax
  8011e9:	c1 e8 0a             	shr    $0xa,%eax
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  8011ec:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8011f3:	a8 01                	test   $0x1,%al
  8011f5:	0f 84 7a 01 00 00    	je     801375 <fork+0x205>
			((uvpt[page_num] & PTE_P) == PTE_P)) {
  8011fb:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  801202:	a8 01                	test   $0x1,%al
  801204:	0f 84 6b 01 00 00    	je     801375 <fork+0x205>
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
	envid_t this_envid = thisenv->env_id;
  80120a:	a1 08 50 80 00       	mov    0x805008,%eax
  80120f:	8b 40 48             	mov    0x48(%eax),%eax
  801212:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 4: Your code here.
	if (uvpt[pn] & PTE_SHARE) {
  801215:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80121c:	f6 c4 04             	test   $0x4,%ah
  80121f:	74 52                	je     801273 <fork+0x103>
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801221:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801228:	25 07 0e 00 00       	and    $0xe07,%eax
  80122d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801231:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801235:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801238:	89 44 24 08          	mov    %eax,0x8(%esp)
  80123c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801240:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801243:	89 04 24             	mov    %eax,(%esp)
  801246:	e8 2c fb ff ff       	call   800d77 <sys_page_map>
  80124b:	85 c0                	test   %eax,%eax
  80124d:	0f 89 22 01 00 00    	jns    801375 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801253:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801257:	c7 44 24 08 f3 30 80 	movl   $0x8030f3,0x8(%esp)
  80125e:	00 
  80125f:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  801266:	00 
  801267:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  80126e:	e8 43 16 00 00       	call   8028b6 <_panic>
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
  801273:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80127a:	f6 c4 08             	test   $0x8,%ah
  80127d:	75 0f                	jne    80128e <fork+0x11e>
  80127f:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801286:	a8 02                	test   $0x2,%al
  801288:	0f 84 99 00 00 00    	je     801327 <fork+0x1b7>
		if (uvpt[pn] & PTE_U)
  80128e:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801295:	83 e0 04             	and    $0x4,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
  801298:	83 f8 01             	cmp    $0x1,%eax
  80129b:	19 f6                	sbb    %esi,%esi
  80129d:	83 e6 fc             	and    $0xfffffffc,%esi
  8012a0:	81 c6 05 08 00 00    	add    $0x805,%esi
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
		if (uvpt[pn] & PTE_U)
			perm |= PTE_U;

		// Map page COW, U and P in child
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), perm)) < 0)
  8012a6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8012aa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012bc:	89 04 24             	mov    %eax,(%esp)
  8012bf:	e8 b3 fa ff ff       	call   800d77 <sys_page_map>
  8012c4:	85 c0                	test   %eax,%eax
  8012c6:	79 20                	jns    8012e8 <fork+0x178>
			panic("sys_page_map: %e\n", r);
  8012c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012cc:	c7 44 24 08 f3 30 80 	movl   $0x8030f3,0x8(%esp)
  8012d3:	00 
  8012d4:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  8012db:	00 
  8012dc:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  8012e3:	e8 ce 15 00 00       	call   8028b6 <_panic>

		// Map page COW, U and P in parent
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), this_envid, (void *) (pn*PGSIZE), perm)) < 0)
  8012e8:	89 74 24 10          	mov    %esi,0x10(%esp)
  8012ec:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8012f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012fb:	89 04 24             	mov    %eax,(%esp)
  8012fe:	e8 74 fa ff ff       	call   800d77 <sys_page_map>
  801303:	85 c0                	test   %eax,%eax
  801305:	79 6e                	jns    801375 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801307:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80130b:	c7 44 24 08 f3 30 80 	movl   $0x8030f3,0x8(%esp)
  801312:	00 
  801313:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  80131a:	00 
  80131b:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  801322:	e8 8f 15 00 00       	call   8028b6 <_panic>

	} else { // map pages that are present but not writable or COW with their original permissions
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801327:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80132e:	25 07 0e 00 00       	and    $0xe07,%eax
  801333:	89 44 24 10          	mov    %eax,0x10(%esp)
  801337:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80133b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80133e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801342:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801346:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801349:	89 04 24             	mov    %eax,(%esp)
  80134c:	e8 26 fa ff ff       	call   800d77 <sys_page_map>
  801351:	85 c0                	test   %eax,%eax
  801353:	79 20                	jns    801375 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801355:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801359:	c7 44 24 08 f3 30 80 	movl   $0x8030f3,0x8(%esp)
  801360:	00 
  801361:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  801368:	00 
  801369:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  801370:	e8 41 15 00 00       	call   8028b6 <_panic>
	// and let duppage worry about the permissions.
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
  801375:	83 c3 01             	add    $0x1,%ebx
  801378:	81 c7 00 10 00 00    	add    $0x1000,%edi
  80137e:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801384:	0f 85 5d fe ff ff    	jne    8011e7 <fork+0x77>
	}

	// Allocate exception stack space for child. The child can't do this themselves
	// because the mechanism by which it would is to run the pgfault handler, which
	// needs to run on the exception stack (catch 22).
	if ((r = sys_page_alloc(child_envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80138a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801391:	00 
  801392:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801399:	ee 
  80139a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80139d:	89 04 24             	mov    %eax,(%esp)
  8013a0:	e8 7e f9 ff ff       	call   800d23 <sys_page_alloc>
  8013a5:	85 c0                	test   %eax,%eax
  8013a7:	79 20                	jns    8013c9 <fork+0x259>
		panic("sys_page_alloc: %e\n", r);
  8013a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ad:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  8013b4:	00 
  8013b5:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  8013bc:	00 
  8013bd:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  8013c4:	e8 ed 14 00 00       	call   8028b6 <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  8013c9:	c7 44 24 04 8d 29 80 	movl   $0x80298d,0x4(%esp)
  8013d0:	00 
  8013d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013d4:	89 04 24             	mov    %eax,(%esp)
  8013d7:	e8 e7 fa ff ff       	call   800ec3 <sys_env_set_pgfault_upcall>
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	79 20                	jns    801400 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  8013e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013e4:	c7 44 24 08 b4 30 80 	movl   $0x8030b4,0x8(%esp)
  8013eb:	00 
  8013ec:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8013f3:	00 
  8013f4:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  8013fb:	e8 b6 14 00 00       	call   8028b6 <_panic>

	// Mark child environment as runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801400:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801407:	00 
  801408:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80140b:	89 04 24             	mov    %eax,(%esp)
  80140e:	e8 0a fa ff ff       	call   800e1d <sys_env_set_status>
  801413:	85 c0                	test   %eax,%eax
  801415:	79 20                	jns    801437 <fork+0x2c7>
		panic("sys_env_set_status: %e\n", r);
  801417:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80141b:	c7 44 24 08 16 31 80 	movl   $0x803116,0x8(%esp)
  801422:	00 
  801423:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80142a:	00 
  80142b:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  801432:	e8 7f 14 00 00       	call   8028b6 <_panic>

	return child_envid;
  801437:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  80143a:	83 c4 2c             	add    $0x2c,%esp
  80143d:	5b                   	pop    %ebx
  80143e:	5e                   	pop    %esi
  80143f:	5f                   	pop    %edi
  801440:	5d                   	pop    %ebp
  801441:	c3                   	ret    

00801442 <sfork>:

// Challenge!
int
sfork(void)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	83 ec 18             	sub    $0x18,%esp
//	return __fork(1);
	panic("sfork not implemented");
  801448:	c7 44 24 08 2e 31 80 	movl   $0x80312e,0x8(%esp)
  80144f:	00 
  801450:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  801457:	00 
  801458:	c7 04 24 d4 30 80 00 	movl   $0x8030d4,(%esp)
  80145f:	e8 52 14 00 00       	call   8028b6 <_panic>
  801464:	66 90                	xchg   %ax,%ax
  801466:	66 90                	xchg   %ax,%ax
  801468:	66 90                	xchg   %ax,%ax
  80146a:	66 90                	xchg   %ax,%ax
  80146c:	66 90                	xchg   %ax,%ax
  80146e:	66 90                	xchg   %ax,%ax

00801470 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	56                   	push   %esi
  801474:	53                   	push   %ebx
  801475:	83 ec 10             	sub    $0x10,%esp
  801478:	8b 75 08             	mov    0x8(%ebp),%esi
  80147b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  801481:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  801483:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  801488:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80148b:	89 04 24             	mov    %eax,(%esp)
  80148e:	e8 a6 fa ff ff       	call   800f39 <sys_ipc_recv>
  801493:	85 c0                	test   %eax,%eax
  801495:	74 16                	je     8014ad <ipc_recv+0x3d>
		if (from_env_store != NULL)
  801497:	85 f6                	test   %esi,%esi
  801499:	74 06                	je     8014a1 <ipc_recv+0x31>
			*from_env_store = 0;
  80149b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8014a1:	85 db                	test   %ebx,%ebx
  8014a3:	74 2c                	je     8014d1 <ipc_recv+0x61>
			*perm_store = 0;
  8014a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8014ab:	eb 24                	jmp    8014d1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8014ad:	85 f6                	test   %esi,%esi
  8014af:	74 0a                	je     8014bb <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8014b1:	a1 08 50 80 00       	mov    0x805008,%eax
  8014b6:	8b 40 74             	mov    0x74(%eax),%eax
  8014b9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8014bb:	85 db                	test   %ebx,%ebx
  8014bd:	74 0a                	je     8014c9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8014bf:	a1 08 50 80 00       	mov    0x805008,%eax
  8014c4:	8b 40 78             	mov    0x78(%eax),%eax
  8014c7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8014c9:	a1 08 50 80 00       	mov    0x805008,%eax
  8014ce:	8b 40 70             	mov    0x70(%eax),%eax
}
  8014d1:	83 c4 10             	add    $0x10,%esp
  8014d4:	5b                   	pop    %ebx
  8014d5:	5e                   	pop    %esi
  8014d6:	5d                   	pop    %ebp
  8014d7:	c3                   	ret    

008014d8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	57                   	push   %edi
  8014dc:	56                   	push   %esi
  8014dd:	53                   	push   %ebx
  8014de:	83 ec 1c             	sub    $0x1c,%esp
  8014e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014e7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8014ea:	85 db                	test   %ebx,%ebx
  8014ec:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8014f1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8014f4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8014f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	89 04 24             	mov    %eax,(%esp)
  801506:	e8 0b fa ff ff       	call   800f16 <sys_ipc_try_send>
	if (r == 0) return;
  80150b:	85 c0                	test   %eax,%eax
  80150d:	75 22                	jne    801531 <ipc_send+0x59>
  80150f:	eb 4c                	jmp    80155d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  801511:	84 d2                	test   %dl,%dl
  801513:	75 48                	jne    80155d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  801515:	e8 ea f7 ff ff       	call   800d04 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80151a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80151e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801522:	89 74 24 04          	mov    %esi,0x4(%esp)
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	89 04 24             	mov    %eax,(%esp)
  80152c:	e8 e5 f9 ff ff       	call   800f16 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  801531:	85 c0                	test   %eax,%eax
  801533:	0f 94 c2             	sete   %dl
  801536:	74 d9                	je     801511 <ipc_send+0x39>
  801538:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80153b:	74 d4                	je     801511 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80153d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801541:	c7 44 24 08 44 31 80 	movl   $0x803144,0x8(%esp)
  801548:	00 
  801549:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  801550:	00 
  801551:	c7 04 24 52 31 80 00 	movl   $0x803152,(%esp)
  801558:	e8 59 13 00 00       	call   8028b6 <_panic>
}
  80155d:	83 c4 1c             	add    $0x1c,%esp
  801560:	5b                   	pop    %ebx
  801561:	5e                   	pop    %esi
  801562:	5f                   	pop    %edi
  801563:	5d                   	pop    %ebp
  801564:	c3                   	ret    

00801565 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80156b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801570:	89 c2                	mov    %eax,%edx
  801572:	c1 e2 07             	shl    $0x7,%edx
  801575:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80157b:	8b 52 50             	mov    0x50(%edx),%edx
  80157e:	39 ca                	cmp    %ecx,%edx
  801580:	75 0d                	jne    80158f <ipc_find_env+0x2a>
			return envs[i].env_id;
  801582:	c1 e0 07             	shl    $0x7,%eax
  801585:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80158a:	8b 40 40             	mov    0x40(%eax),%eax
  80158d:	eb 0e                	jmp    80159d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80158f:	83 c0 01             	add    $0x1,%eax
  801592:	3d 00 04 00 00       	cmp    $0x400,%eax
  801597:	75 d7                	jne    801570 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801599:	66 b8 00 00          	mov    $0x0,%ax
}
  80159d:	5d                   	pop    %ebp
  80159e:	c3                   	ret    
  80159f:	90                   	nop

008015a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8015ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8015ae:	5d                   	pop    %ebp
  8015af:	c3                   	ret    

008015b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8015bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015c5:	5d                   	pop    %ebp
  8015c6:	c3                   	ret    

008015c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015d2:	89 c2                	mov    %eax,%edx
  8015d4:	c1 ea 16             	shr    $0x16,%edx
  8015d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015de:	f6 c2 01             	test   $0x1,%dl
  8015e1:	74 11                	je     8015f4 <fd_alloc+0x2d>
  8015e3:	89 c2                	mov    %eax,%edx
  8015e5:	c1 ea 0c             	shr    $0xc,%edx
  8015e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015ef:	f6 c2 01             	test   $0x1,%dl
  8015f2:	75 09                	jne    8015fd <fd_alloc+0x36>
			*fd_store = fd;
  8015f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fb:	eb 17                	jmp    801614 <fd_alloc+0x4d>
  8015fd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801602:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801607:	75 c9                	jne    8015d2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801609:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80160f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801614:	5d                   	pop    %ebp
  801615:	c3                   	ret    

00801616 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80161c:	83 f8 1f             	cmp    $0x1f,%eax
  80161f:	77 36                	ja     801657 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801621:	c1 e0 0c             	shl    $0xc,%eax
  801624:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801629:	89 c2                	mov    %eax,%edx
  80162b:	c1 ea 16             	shr    $0x16,%edx
  80162e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801635:	f6 c2 01             	test   $0x1,%dl
  801638:	74 24                	je     80165e <fd_lookup+0x48>
  80163a:	89 c2                	mov    %eax,%edx
  80163c:	c1 ea 0c             	shr    $0xc,%edx
  80163f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801646:	f6 c2 01             	test   $0x1,%dl
  801649:	74 1a                	je     801665 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80164b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164e:	89 02                	mov    %eax,(%edx)
	return 0;
  801650:	b8 00 00 00 00       	mov    $0x0,%eax
  801655:	eb 13                	jmp    80166a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801657:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80165c:	eb 0c                	jmp    80166a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80165e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801663:	eb 05                	jmp    80166a <fd_lookup+0x54>
  801665:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80166a:	5d                   	pop    %ebp
  80166b:	c3                   	ret    

0080166c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 18             	sub    $0x18,%esp
  801672:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801675:	ba 00 00 00 00       	mov    $0x0,%edx
  80167a:	eb 13                	jmp    80168f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80167c:	39 08                	cmp    %ecx,(%eax)
  80167e:	75 0c                	jne    80168c <dev_lookup+0x20>
			*dev = devtab[i];
  801680:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801683:	89 01                	mov    %eax,(%ecx)
			return 0;
  801685:	b8 00 00 00 00       	mov    $0x0,%eax
  80168a:	eb 38                	jmp    8016c4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80168c:	83 c2 01             	add    $0x1,%edx
  80168f:	8b 04 95 d8 31 80 00 	mov    0x8031d8(,%edx,4),%eax
  801696:	85 c0                	test   %eax,%eax
  801698:	75 e2                	jne    80167c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80169a:	a1 08 50 80 00       	mov    0x805008,%eax
  80169f:	8b 40 48             	mov    0x48(%eax),%eax
  8016a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016aa:	c7 04 24 5c 31 80 00 	movl   $0x80315c,(%esp)
  8016b1:	e8 2e ec ff ff       	call   8002e4 <cprintf>
	*dev = 0;
  8016b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	56                   	push   %esi
  8016ca:	53                   	push   %ebx
  8016cb:	83 ec 20             	sub    $0x20,%esp
  8016ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8016d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016e1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016e4:	89 04 24             	mov    %eax,(%esp)
  8016e7:	e8 2a ff ff ff       	call   801616 <fd_lookup>
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	78 05                	js     8016f5 <fd_close+0x2f>
	    || fd != fd2)
  8016f0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016f3:	74 0c                	je     801701 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8016f5:	84 db                	test   %bl,%bl
  8016f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016fc:	0f 44 c2             	cmove  %edx,%eax
  8016ff:	eb 3f                	jmp    801740 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801701:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801704:	89 44 24 04          	mov    %eax,0x4(%esp)
  801708:	8b 06                	mov    (%esi),%eax
  80170a:	89 04 24             	mov    %eax,(%esp)
  80170d:	e8 5a ff ff ff       	call   80166c <dev_lookup>
  801712:	89 c3                	mov    %eax,%ebx
  801714:	85 c0                	test   %eax,%eax
  801716:	78 16                	js     80172e <fd_close+0x68>
		if (dev->dev_close)
  801718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80171e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801723:	85 c0                	test   %eax,%eax
  801725:	74 07                	je     80172e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801727:	89 34 24             	mov    %esi,(%esp)
  80172a:	ff d0                	call   *%eax
  80172c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80172e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801732:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801739:	e8 8c f6 ff ff       	call   800dca <sys_page_unmap>
	return r;
  80173e:	89 d8                	mov    %ebx,%eax
}
  801740:	83 c4 20             	add    $0x20,%esp
  801743:	5b                   	pop    %ebx
  801744:	5e                   	pop    %esi
  801745:	5d                   	pop    %ebp
  801746:	c3                   	ret    

00801747 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80174d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801750:	89 44 24 04          	mov    %eax,0x4(%esp)
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	89 04 24             	mov    %eax,(%esp)
  80175a:	e8 b7 fe ff ff       	call   801616 <fd_lookup>
  80175f:	89 c2                	mov    %eax,%edx
  801761:	85 d2                	test   %edx,%edx
  801763:	78 13                	js     801778 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801765:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80176c:	00 
  80176d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801770:	89 04 24             	mov    %eax,(%esp)
  801773:	e8 4e ff ff ff       	call   8016c6 <fd_close>
}
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <close_all>:

void
close_all(void)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	53                   	push   %ebx
  80177e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801781:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801786:	89 1c 24             	mov    %ebx,(%esp)
  801789:	e8 b9 ff ff ff       	call   801747 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80178e:	83 c3 01             	add    $0x1,%ebx
  801791:	83 fb 20             	cmp    $0x20,%ebx
  801794:	75 f0                	jne    801786 <close_all+0xc>
		close(i);
}
  801796:	83 c4 14             	add    $0x14,%esp
  801799:	5b                   	pop    %ebx
  80179a:	5d                   	pop    %ebp
  80179b:	c3                   	ret    

0080179c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	57                   	push   %edi
  8017a0:	56                   	push   %esi
  8017a1:	53                   	push   %ebx
  8017a2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	89 04 24             	mov    %eax,(%esp)
  8017b2:	e8 5f fe ff ff       	call   801616 <fd_lookup>
  8017b7:	89 c2                	mov    %eax,%edx
  8017b9:	85 d2                	test   %edx,%edx
  8017bb:	0f 88 e1 00 00 00    	js     8018a2 <dup+0x106>
		return r;
	close(newfdnum);
  8017c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c4:	89 04 24             	mov    %eax,(%esp)
  8017c7:	e8 7b ff ff ff       	call   801747 <close>

	newfd = INDEX2FD(newfdnum);
  8017cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017cf:	c1 e3 0c             	shl    $0xc,%ebx
  8017d2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8017d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017db:	89 04 24             	mov    %eax,(%esp)
  8017de:	e8 cd fd ff ff       	call   8015b0 <fd2data>
  8017e3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8017e5:	89 1c 24             	mov    %ebx,(%esp)
  8017e8:	e8 c3 fd ff ff       	call   8015b0 <fd2data>
  8017ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017ef:	89 f0                	mov    %esi,%eax
  8017f1:	c1 e8 16             	shr    $0x16,%eax
  8017f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017fb:	a8 01                	test   $0x1,%al
  8017fd:	74 43                	je     801842 <dup+0xa6>
  8017ff:	89 f0                	mov    %esi,%eax
  801801:	c1 e8 0c             	shr    $0xc,%eax
  801804:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80180b:	f6 c2 01             	test   $0x1,%dl
  80180e:	74 32                	je     801842 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801810:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801817:	25 07 0e 00 00       	and    $0xe07,%eax
  80181c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801820:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801824:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80182b:	00 
  80182c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801830:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801837:	e8 3b f5 ff ff       	call   800d77 <sys_page_map>
  80183c:	89 c6                	mov    %eax,%esi
  80183e:	85 c0                	test   %eax,%eax
  801840:	78 3e                	js     801880 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801845:	89 c2                	mov    %eax,%edx
  801847:	c1 ea 0c             	shr    $0xc,%edx
  80184a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801851:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801857:	89 54 24 10          	mov    %edx,0x10(%esp)
  80185b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80185f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801866:	00 
  801867:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801872:	e8 00 f5 ff ff       	call   800d77 <sys_page_map>
  801877:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801879:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80187c:	85 f6                	test   %esi,%esi
  80187e:	79 22                	jns    8018a2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801880:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801884:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80188b:	e8 3a f5 ff ff       	call   800dca <sys_page_unmap>
	sys_page_unmap(0, nva);
  801890:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801894:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80189b:	e8 2a f5 ff ff       	call   800dca <sys_page_unmap>
	return r;
  8018a0:	89 f0                	mov    %esi,%eax
}
  8018a2:	83 c4 3c             	add    $0x3c,%esp
  8018a5:	5b                   	pop    %ebx
  8018a6:	5e                   	pop    %esi
  8018a7:	5f                   	pop    %edi
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    

008018aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	53                   	push   %ebx
  8018ae:	83 ec 24             	sub    $0x24,%esp
  8018b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bb:	89 1c 24             	mov    %ebx,(%esp)
  8018be:	e8 53 fd ff ff       	call   801616 <fd_lookup>
  8018c3:	89 c2                	mov    %eax,%edx
  8018c5:	85 d2                	test   %edx,%edx
  8018c7:	78 6d                	js     801936 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d3:	8b 00                	mov    (%eax),%eax
  8018d5:	89 04 24             	mov    %eax,(%esp)
  8018d8:	e8 8f fd ff ff       	call   80166c <dev_lookup>
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	78 55                	js     801936 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e4:	8b 50 08             	mov    0x8(%eax),%edx
  8018e7:	83 e2 03             	and    $0x3,%edx
  8018ea:	83 fa 01             	cmp    $0x1,%edx
  8018ed:	75 23                	jne    801912 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018ef:	a1 08 50 80 00       	mov    0x805008,%eax
  8018f4:	8b 40 48             	mov    0x48(%eax),%eax
  8018f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ff:	c7 04 24 9d 31 80 00 	movl   $0x80319d,(%esp)
  801906:	e8 d9 e9 ff ff       	call   8002e4 <cprintf>
		return -E_INVAL;
  80190b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801910:	eb 24                	jmp    801936 <read+0x8c>
	}
	if (!dev->dev_read)
  801912:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801915:	8b 52 08             	mov    0x8(%edx),%edx
  801918:	85 d2                	test   %edx,%edx
  80191a:	74 15                	je     801931 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80191c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80191f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801923:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801926:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80192a:	89 04 24             	mov    %eax,(%esp)
  80192d:	ff d2                	call   *%edx
  80192f:	eb 05                	jmp    801936 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801931:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801936:	83 c4 24             	add    $0x24,%esp
  801939:	5b                   	pop    %ebx
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    

0080193c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	57                   	push   %edi
  801940:	56                   	push   %esi
  801941:	53                   	push   %ebx
  801942:	83 ec 1c             	sub    $0x1c,%esp
  801945:	8b 7d 08             	mov    0x8(%ebp),%edi
  801948:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80194b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801950:	eb 23                	jmp    801975 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801952:	89 f0                	mov    %esi,%eax
  801954:	29 d8                	sub    %ebx,%eax
  801956:	89 44 24 08          	mov    %eax,0x8(%esp)
  80195a:	89 d8                	mov    %ebx,%eax
  80195c:	03 45 0c             	add    0xc(%ebp),%eax
  80195f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801963:	89 3c 24             	mov    %edi,(%esp)
  801966:	e8 3f ff ff ff       	call   8018aa <read>
		if (m < 0)
  80196b:	85 c0                	test   %eax,%eax
  80196d:	78 10                	js     80197f <readn+0x43>
			return m;
		if (m == 0)
  80196f:	85 c0                	test   %eax,%eax
  801971:	74 0a                	je     80197d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801973:	01 c3                	add    %eax,%ebx
  801975:	39 f3                	cmp    %esi,%ebx
  801977:	72 d9                	jb     801952 <readn+0x16>
  801979:	89 d8                	mov    %ebx,%eax
  80197b:	eb 02                	jmp    80197f <readn+0x43>
  80197d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80197f:	83 c4 1c             	add    $0x1c,%esp
  801982:	5b                   	pop    %ebx
  801983:	5e                   	pop    %esi
  801984:	5f                   	pop    %edi
  801985:	5d                   	pop    %ebp
  801986:	c3                   	ret    

00801987 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	53                   	push   %ebx
  80198b:	83 ec 24             	sub    $0x24,%esp
  80198e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801991:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801994:	89 44 24 04          	mov    %eax,0x4(%esp)
  801998:	89 1c 24             	mov    %ebx,(%esp)
  80199b:	e8 76 fc ff ff       	call   801616 <fd_lookup>
  8019a0:	89 c2                	mov    %eax,%edx
  8019a2:	85 d2                	test   %edx,%edx
  8019a4:	78 68                	js     801a0e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b0:	8b 00                	mov    (%eax),%eax
  8019b2:	89 04 24             	mov    %eax,(%esp)
  8019b5:	e8 b2 fc ff ff       	call   80166c <dev_lookup>
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	78 50                	js     801a0e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019c5:	75 23                	jne    8019ea <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019c7:	a1 08 50 80 00       	mov    0x805008,%eax
  8019cc:	8b 40 48             	mov    0x48(%eax),%eax
  8019cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d7:	c7 04 24 b9 31 80 00 	movl   $0x8031b9,(%esp)
  8019de:	e8 01 e9 ff ff       	call   8002e4 <cprintf>
		return -E_INVAL;
  8019e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019e8:	eb 24                	jmp    801a0e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8019f0:	85 d2                	test   %edx,%edx
  8019f2:	74 15                	je     801a09 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a02:	89 04 24             	mov    %eax,(%esp)
  801a05:	ff d2                	call   *%edx
  801a07:	eb 05                	jmp    801a0e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a09:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a0e:	83 c4 24             	add    $0x24,%esp
  801a11:	5b                   	pop    %ebx
  801a12:	5d                   	pop    %ebp
  801a13:	c3                   	ret    

00801a14 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a1a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	89 04 24             	mov    %eax,(%esp)
  801a27:	e8 ea fb ff ff       	call   801616 <fd_lookup>
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	78 0e                	js     801a3e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a36:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	53                   	push   %ebx
  801a44:	83 ec 24             	sub    $0x24,%esp
  801a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a4a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a51:	89 1c 24             	mov    %ebx,(%esp)
  801a54:	e8 bd fb ff ff       	call   801616 <fd_lookup>
  801a59:	89 c2                	mov    %eax,%edx
  801a5b:	85 d2                	test   %edx,%edx
  801a5d:	78 61                	js     801ac0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a62:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a69:	8b 00                	mov    (%eax),%eax
  801a6b:	89 04 24             	mov    %eax,(%esp)
  801a6e:	e8 f9 fb ff ff       	call   80166c <dev_lookup>
  801a73:	85 c0                	test   %eax,%eax
  801a75:	78 49                	js     801ac0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a7e:	75 23                	jne    801aa3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a80:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a85:	8b 40 48             	mov    0x48(%eax),%eax
  801a88:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a90:	c7 04 24 7c 31 80 00 	movl   $0x80317c,(%esp)
  801a97:	e8 48 e8 ff ff       	call   8002e4 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a9c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801aa1:	eb 1d                	jmp    801ac0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801aa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa6:	8b 52 18             	mov    0x18(%edx),%edx
  801aa9:	85 d2                	test   %edx,%edx
  801aab:	74 0e                	je     801abb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801aad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ab0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ab4:	89 04 24             	mov    %eax,(%esp)
  801ab7:	ff d2                	call   *%edx
  801ab9:	eb 05                	jmp    801ac0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801abb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801ac0:	83 c4 24             	add    $0x24,%esp
  801ac3:	5b                   	pop    %ebx
  801ac4:	5d                   	pop    %ebp
  801ac5:	c3                   	ret    

00801ac6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	53                   	push   %ebx
  801aca:	83 ec 24             	sub    $0x24,%esp
  801acd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ad0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	89 04 24             	mov    %eax,(%esp)
  801add:	e8 34 fb ff ff       	call   801616 <fd_lookup>
  801ae2:	89 c2                	mov    %eax,%edx
  801ae4:	85 d2                	test   %edx,%edx
  801ae6:	78 52                	js     801b3a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ae8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af2:	8b 00                	mov    (%eax),%eax
  801af4:	89 04 24             	mov    %eax,(%esp)
  801af7:	e8 70 fb ff ff       	call   80166c <dev_lookup>
  801afc:	85 c0                	test   %eax,%eax
  801afe:	78 3a                	js     801b3a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b03:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b07:	74 2c                	je     801b35 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b09:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b0c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b13:	00 00 00 
	stat->st_isdir = 0;
  801b16:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b1d:	00 00 00 
	stat->st_dev = dev;
  801b20:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b26:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b2d:	89 14 24             	mov    %edx,(%esp)
  801b30:	ff 50 14             	call   *0x14(%eax)
  801b33:	eb 05                	jmp    801b3a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801b35:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801b3a:	83 c4 24             	add    $0x24,%esp
  801b3d:	5b                   	pop    %ebx
  801b3e:	5d                   	pop    %ebp
  801b3f:	c3                   	ret    

00801b40 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	56                   	push   %esi
  801b44:	53                   	push   %ebx
  801b45:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b48:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b4f:	00 
  801b50:	8b 45 08             	mov    0x8(%ebp),%eax
  801b53:	89 04 24             	mov    %eax,(%esp)
  801b56:	e8 84 02 00 00       	call   801ddf <open>
  801b5b:	89 c3                	mov    %eax,%ebx
  801b5d:	85 db                	test   %ebx,%ebx
  801b5f:	78 1b                	js     801b7c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b68:	89 1c 24             	mov    %ebx,(%esp)
  801b6b:	e8 56 ff ff ff       	call   801ac6 <fstat>
  801b70:	89 c6                	mov    %eax,%esi
	close(fd);
  801b72:	89 1c 24             	mov    %ebx,(%esp)
  801b75:	e8 cd fb ff ff       	call   801747 <close>
	return r;
  801b7a:	89 f0                	mov    %esi,%eax
}
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5d                   	pop    %ebp
  801b82:	c3                   	ret    

00801b83 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	56                   	push   %esi
  801b87:	53                   	push   %ebx
  801b88:	83 ec 10             	sub    $0x10,%esp
  801b8b:	89 c6                	mov    %eax,%esi
  801b8d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b8f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b96:	75 11                	jne    801ba9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b9f:	e8 c1 f9 ff ff       	call   801565 <ipc_find_env>
  801ba4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ba9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bb0:	00 
  801bb1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801bb8:	00 
  801bb9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bbd:	a1 00 50 80 00       	mov    0x805000,%eax
  801bc2:	89 04 24             	mov    %eax,(%esp)
  801bc5:	e8 0e f9 ff ff       	call   8014d8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bd1:	00 
  801bd2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bd6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bdd:	e8 8e f8 ff ff       	call   801470 <ipc_recv>
}
  801be2:	83 c4 10             	add    $0x10,%esp
  801be5:	5b                   	pop    %ebx
  801be6:	5e                   	pop    %esi
  801be7:	5d                   	pop    %ebp
  801be8:	c3                   	ret    

00801be9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
  801bec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bfd:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c02:	ba 00 00 00 00       	mov    $0x0,%edx
  801c07:	b8 02 00 00 00       	mov    $0x2,%eax
  801c0c:	e8 72 ff ff ff       	call   801b83 <fsipc>
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
  801c16:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c1f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c24:	ba 00 00 00 00       	mov    $0x0,%edx
  801c29:	b8 06 00 00 00       	mov    $0x6,%eax
  801c2e:	e8 50 ff ff ff       	call   801b83 <fsipc>
}
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	53                   	push   %ebx
  801c39:	83 ec 14             	sub    $0x14,%esp
  801c3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	8b 40 0c             	mov    0xc(%eax),%eax
  801c45:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4f:	b8 05 00 00 00       	mov    $0x5,%eax
  801c54:	e8 2a ff ff ff       	call   801b83 <fsipc>
  801c59:	89 c2                	mov    %eax,%edx
  801c5b:	85 d2                	test   %edx,%edx
  801c5d:	78 2b                	js     801c8a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c5f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c66:	00 
  801c67:	89 1c 24             	mov    %ebx,(%esp)
  801c6a:	e8 98 ec ff ff       	call   800907 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c6f:	a1 80 60 80 00       	mov    0x806080,%eax
  801c74:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c7a:	a1 84 60 80 00       	mov    0x806084,%eax
  801c7f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8a:	83 c4 14             	add    $0x14,%esp
  801c8d:	5b                   	pop    %ebx
  801c8e:	5d                   	pop    %ebp
  801c8f:	c3                   	ret    

00801c90 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	53                   	push   %ebx
  801c94:	83 ec 14             	sub    $0x14,%esp
  801c97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9d:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801ca5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801cab:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801cb0:	0f 46 c3             	cmovbe %ebx,%eax
  801cb3:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801cb8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc3:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801cca:	e8 d5 ed ff ff       	call   800aa4 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801ccf:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd4:	b8 04 00 00 00       	mov    $0x4,%eax
  801cd9:	e8 a5 fe ff ff       	call   801b83 <fsipc>
  801cde:	85 c0                	test   %eax,%eax
  801ce0:	78 53                	js     801d35 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801ce2:	39 c3                	cmp    %eax,%ebx
  801ce4:	73 24                	jae    801d0a <devfile_write+0x7a>
  801ce6:	c7 44 24 0c ec 31 80 	movl   $0x8031ec,0xc(%esp)
  801ced:	00 
  801cee:	c7 44 24 08 f3 31 80 	movl   $0x8031f3,0x8(%esp)
  801cf5:	00 
  801cf6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801cfd:	00 
  801cfe:	c7 04 24 08 32 80 00 	movl   $0x803208,(%esp)
  801d05:	e8 ac 0b 00 00       	call   8028b6 <_panic>
	assert(r <= PGSIZE);
  801d0a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d0f:	7e 24                	jle    801d35 <devfile_write+0xa5>
  801d11:	c7 44 24 0c 13 32 80 	movl   $0x803213,0xc(%esp)
  801d18:	00 
  801d19:	c7 44 24 08 f3 31 80 	movl   $0x8031f3,0x8(%esp)
  801d20:	00 
  801d21:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801d28:	00 
  801d29:	c7 04 24 08 32 80 00 	movl   $0x803208,(%esp)
  801d30:	e8 81 0b 00 00       	call   8028b6 <_panic>
	return r;
}
  801d35:	83 c4 14             	add    $0x14,%esp
  801d38:	5b                   	pop    %ebx
  801d39:	5d                   	pop    %ebp
  801d3a:	c3                   	ret    

00801d3b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	56                   	push   %esi
  801d3f:	53                   	push   %ebx
  801d40:	83 ec 10             	sub    $0x10,%esp
  801d43:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d46:	8b 45 08             	mov    0x8(%ebp),%eax
  801d49:	8b 40 0c             	mov    0xc(%eax),%eax
  801d4c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d51:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d57:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5c:	b8 03 00 00 00       	mov    $0x3,%eax
  801d61:	e8 1d fe ff ff       	call   801b83 <fsipc>
  801d66:	89 c3                	mov    %eax,%ebx
  801d68:	85 c0                	test   %eax,%eax
  801d6a:	78 6a                	js     801dd6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801d6c:	39 c6                	cmp    %eax,%esi
  801d6e:	73 24                	jae    801d94 <devfile_read+0x59>
  801d70:	c7 44 24 0c ec 31 80 	movl   $0x8031ec,0xc(%esp)
  801d77:	00 
  801d78:	c7 44 24 08 f3 31 80 	movl   $0x8031f3,0x8(%esp)
  801d7f:	00 
  801d80:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801d87:	00 
  801d88:	c7 04 24 08 32 80 00 	movl   $0x803208,(%esp)
  801d8f:	e8 22 0b 00 00       	call   8028b6 <_panic>
	assert(r <= PGSIZE);
  801d94:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d99:	7e 24                	jle    801dbf <devfile_read+0x84>
  801d9b:	c7 44 24 0c 13 32 80 	movl   $0x803213,0xc(%esp)
  801da2:	00 
  801da3:	c7 44 24 08 f3 31 80 	movl   $0x8031f3,0x8(%esp)
  801daa:	00 
  801dab:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801db2:	00 
  801db3:	c7 04 24 08 32 80 00 	movl   $0x803208,(%esp)
  801dba:	e8 f7 0a 00 00       	call   8028b6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801dbf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dc3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801dca:	00 
  801dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dce:	89 04 24             	mov    %eax,(%esp)
  801dd1:	e8 ce ec ff ff       	call   800aa4 <memmove>
	return r;
}
  801dd6:	89 d8                	mov    %ebx,%eax
  801dd8:	83 c4 10             	add    $0x10,%esp
  801ddb:	5b                   	pop    %ebx
  801ddc:	5e                   	pop    %esi
  801ddd:	5d                   	pop    %ebp
  801dde:	c3                   	ret    

00801ddf <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	53                   	push   %ebx
  801de3:	83 ec 24             	sub    $0x24,%esp
  801de6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801de9:	89 1c 24             	mov    %ebx,(%esp)
  801dec:	e8 df ea ff ff       	call   8008d0 <strlen>
  801df1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801df6:	7f 60                	jg     801e58 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801df8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dfb:	89 04 24             	mov    %eax,(%esp)
  801dfe:	e8 c4 f7 ff ff       	call   8015c7 <fd_alloc>
  801e03:	89 c2                	mov    %eax,%edx
  801e05:	85 d2                	test   %edx,%edx
  801e07:	78 54                	js     801e5d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801e09:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e0d:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801e14:	e8 ee ea ff ff       	call   800907 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e24:	b8 01 00 00 00       	mov    $0x1,%eax
  801e29:	e8 55 fd ff ff       	call   801b83 <fsipc>
  801e2e:	89 c3                	mov    %eax,%ebx
  801e30:	85 c0                	test   %eax,%eax
  801e32:	79 17                	jns    801e4b <open+0x6c>
		fd_close(fd, 0);
  801e34:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e3b:	00 
  801e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3f:	89 04 24             	mov    %eax,(%esp)
  801e42:	e8 7f f8 ff ff       	call   8016c6 <fd_close>
		return r;
  801e47:	89 d8                	mov    %ebx,%eax
  801e49:	eb 12                	jmp    801e5d <open+0x7e>
	}

	return fd2num(fd);
  801e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4e:	89 04 24             	mov    %eax,(%esp)
  801e51:	e8 4a f7 ff ff       	call   8015a0 <fd2num>
  801e56:	eb 05                	jmp    801e5d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801e58:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801e5d:	83 c4 24             	add    $0x24,%esp
  801e60:	5b                   	pop    %ebx
  801e61:	5d                   	pop    %ebp
  801e62:	c3                   	ret    

00801e63 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
  801e66:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e69:	ba 00 00 00 00       	mov    $0x0,%edx
  801e6e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e73:	e8 0b fd ff ff       	call   801b83 <fsipc>
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    
  801e7a:	66 90                	xchg   %ax,%ax
  801e7c:	66 90                	xchg   %ax,%ax
  801e7e:	66 90                	xchg   %ax,%ax

00801e80 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e80:	55                   	push   %ebp
  801e81:	89 e5                	mov    %esp,%ebp
  801e83:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e86:	c7 44 24 04 1f 32 80 	movl   $0x80321f,0x4(%esp)
  801e8d:	00 
  801e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e91:	89 04 24             	mov    %eax,(%esp)
  801e94:	e8 6e ea ff ff       	call   800907 <strcpy>
	return 0;
}
  801e99:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	53                   	push   %ebx
  801ea4:	83 ec 14             	sub    $0x14,%esp
  801ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801eaa:	89 1c 24             	mov    %ebx,(%esp)
  801ead:	e8 ff 0a 00 00       	call   8029b1 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801eb2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801eb7:	83 f8 01             	cmp    $0x1,%eax
  801eba:	75 0d                	jne    801ec9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801ebc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801ebf:	89 04 24             	mov    %eax,(%esp)
  801ec2:	e8 29 03 00 00       	call   8021f0 <nsipc_close>
  801ec7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801ec9:	89 d0                	mov    %edx,%eax
  801ecb:	83 c4 14             	add    $0x14,%esp
  801ece:	5b                   	pop    %ebx
  801ecf:	5d                   	pop    %ebp
  801ed0:	c3                   	ret    

00801ed1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ed7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801ede:	00 
  801edf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef3:	89 04 24             	mov    %eax,(%esp)
  801ef6:	e8 f0 03 00 00       	call   8022eb <nsipc_send>
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f03:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f0a:	00 
  801f0b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1f:	89 04 24             	mov    %eax,(%esp)
  801f22:	e8 44 03 00 00       	call   80226b <nsipc_recv>
}
  801f27:	c9                   	leave  
  801f28:	c3                   	ret    

00801f29 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
  801f2c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f2f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f32:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f36:	89 04 24             	mov    %eax,(%esp)
  801f39:	e8 d8 f6 ff ff       	call   801616 <fd_lookup>
  801f3e:	85 c0                	test   %eax,%eax
  801f40:	78 17                	js     801f59 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	8b 0d 28 40 80 00    	mov    0x804028,%ecx
  801f4b:	39 08                	cmp    %ecx,(%eax)
  801f4d:	75 05                	jne    801f54 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801f4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f52:	eb 05                	jmp    801f59 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801f54:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	56                   	push   %esi
  801f5f:	53                   	push   %ebx
  801f60:	83 ec 20             	sub    $0x20,%esp
  801f63:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f68:	89 04 24             	mov    %eax,(%esp)
  801f6b:	e8 57 f6 ff ff       	call   8015c7 <fd_alloc>
  801f70:	89 c3                	mov    %eax,%ebx
  801f72:	85 c0                	test   %eax,%eax
  801f74:	78 21                	js     801f97 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f76:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f7d:	00 
  801f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f81:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f8c:	e8 92 ed ff ff       	call   800d23 <sys_page_alloc>
  801f91:	89 c3                	mov    %eax,%ebx
  801f93:	85 c0                	test   %eax,%eax
  801f95:	79 0c                	jns    801fa3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801f97:	89 34 24             	mov    %esi,(%esp)
  801f9a:	e8 51 02 00 00       	call   8021f0 <nsipc_close>
		return r;
  801f9f:	89 d8                	mov    %ebx,%eax
  801fa1:	eb 20                	jmp    801fc3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801fa3:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801fb8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801fbb:	89 14 24             	mov    %edx,(%esp)
  801fbe:	e8 dd f5 ff ff       	call   8015a0 <fd2num>
}
  801fc3:	83 c4 20             	add    $0x20,%esp
  801fc6:	5b                   	pop    %ebx
  801fc7:	5e                   	pop    %esi
  801fc8:	5d                   	pop    %ebp
  801fc9:	c3                   	ret    

00801fca <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd3:	e8 51 ff ff ff       	call   801f29 <fd2sockid>
		return r;
  801fd8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	78 23                	js     802001 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fde:	8b 55 10             	mov    0x10(%ebp),%edx
  801fe1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fe5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fec:	89 04 24             	mov    %eax,(%esp)
  801fef:	e8 45 01 00 00       	call   802139 <nsipc_accept>
		return r;
  801ff4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	78 07                	js     802001 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801ffa:	e8 5c ff ff ff       	call   801f5b <alloc_sockfd>
  801fff:	89 c1                	mov    %eax,%ecx
}
  802001:	89 c8                	mov    %ecx,%eax
  802003:	c9                   	leave  
  802004:	c3                   	ret    

00802005 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80200b:	8b 45 08             	mov    0x8(%ebp),%eax
  80200e:	e8 16 ff ff ff       	call   801f29 <fd2sockid>
  802013:	89 c2                	mov    %eax,%edx
  802015:	85 d2                	test   %edx,%edx
  802017:	78 16                	js     80202f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802019:	8b 45 10             	mov    0x10(%ebp),%eax
  80201c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802020:	8b 45 0c             	mov    0xc(%ebp),%eax
  802023:	89 44 24 04          	mov    %eax,0x4(%esp)
  802027:	89 14 24             	mov    %edx,(%esp)
  80202a:	e8 60 01 00 00       	call   80218f <nsipc_bind>
}
  80202f:	c9                   	leave  
  802030:	c3                   	ret    

00802031 <shutdown>:

int
shutdown(int s, int how)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	e8 ea fe ff ff       	call   801f29 <fd2sockid>
  80203f:	89 c2                	mov    %eax,%edx
  802041:	85 d2                	test   %edx,%edx
  802043:	78 0f                	js     802054 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802045:	8b 45 0c             	mov    0xc(%ebp),%eax
  802048:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204c:	89 14 24             	mov    %edx,(%esp)
  80204f:	e8 7a 01 00 00       	call   8021ce <nsipc_shutdown>
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	e8 c5 fe ff ff       	call   801f29 <fd2sockid>
  802064:	89 c2                	mov    %eax,%edx
  802066:	85 d2                	test   %edx,%edx
  802068:	78 16                	js     802080 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80206a:	8b 45 10             	mov    0x10(%ebp),%eax
  80206d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802071:	8b 45 0c             	mov    0xc(%ebp),%eax
  802074:	89 44 24 04          	mov    %eax,0x4(%esp)
  802078:	89 14 24             	mov    %edx,(%esp)
  80207b:	e8 8a 01 00 00       	call   80220a <nsipc_connect>
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <listen>:

int
listen(int s, int backlog)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802088:	8b 45 08             	mov    0x8(%ebp),%eax
  80208b:	e8 99 fe ff ff       	call   801f29 <fd2sockid>
  802090:	89 c2                	mov    %eax,%edx
  802092:	85 d2                	test   %edx,%edx
  802094:	78 0f                	js     8020a5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802096:	8b 45 0c             	mov    0xc(%ebp),%eax
  802099:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209d:	89 14 24             	mov    %edx,(%esp)
  8020a0:	e8 a4 01 00 00       	call   802249 <nsipc_listen>
}
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	89 04 24             	mov    %eax,(%esp)
  8020c1:	e8 98 02 00 00       	call   80235e <nsipc_socket>
  8020c6:	89 c2                	mov    %eax,%edx
  8020c8:	85 d2                	test   %edx,%edx
  8020ca:	78 05                	js     8020d1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8020cc:	e8 8a fe ff ff       	call   801f5b <alloc_sockfd>
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	53                   	push   %ebx
  8020d7:	83 ec 14             	sub    $0x14,%esp
  8020da:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020dc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020e3:	75 11                	jne    8020f6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020e5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8020ec:	e8 74 f4 ff ff       	call   801565 <ipc_find_env>
  8020f1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020f6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8020fd:	00 
  8020fe:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802105:	00 
  802106:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80210a:	a1 04 50 80 00       	mov    0x805004,%eax
  80210f:	89 04 24             	mov    %eax,(%esp)
  802112:	e8 c1 f3 ff ff       	call   8014d8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802117:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80211e:	00 
  80211f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802126:	00 
  802127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80212e:	e8 3d f3 ff ff       	call   801470 <ipc_recv>
}
  802133:	83 c4 14             	add    $0x14,%esp
  802136:	5b                   	pop    %ebx
  802137:	5d                   	pop    %ebp
  802138:	c3                   	ret    

00802139 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	56                   	push   %esi
  80213d:	53                   	push   %ebx
  80213e:	83 ec 10             	sub    $0x10,%esp
  802141:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80214c:	8b 06                	mov    (%esi),%eax
  80214e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802153:	b8 01 00 00 00       	mov    $0x1,%eax
  802158:	e8 76 ff ff ff       	call   8020d3 <nsipc>
  80215d:	89 c3                	mov    %eax,%ebx
  80215f:	85 c0                	test   %eax,%eax
  802161:	78 23                	js     802186 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802163:	a1 10 70 80 00       	mov    0x807010,%eax
  802168:	89 44 24 08          	mov    %eax,0x8(%esp)
  80216c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802173:	00 
  802174:	8b 45 0c             	mov    0xc(%ebp),%eax
  802177:	89 04 24             	mov    %eax,(%esp)
  80217a:	e8 25 e9 ff ff       	call   800aa4 <memmove>
		*addrlen = ret->ret_addrlen;
  80217f:	a1 10 70 80 00       	mov    0x807010,%eax
  802184:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802186:	89 d8                	mov    %ebx,%eax
  802188:	83 c4 10             	add    $0x10,%esp
  80218b:	5b                   	pop    %ebx
  80218c:	5e                   	pop    %esi
  80218d:	5d                   	pop    %ebp
  80218e:	c3                   	ret    

0080218f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
  802192:	53                   	push   %ebx
  802193:	83 ec 14             	sub    $0x14,%esp
  802196:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021a1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ac:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8021b3:	e8 ec e8 ff ff       	call   800aa4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021b8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021be:	b8 02 00 00 00       	mov    $0x2,%eax
  8021c3:	e8 0b ff ff ff       	call   8020d3 <nsipc>
}
  8021c8:	83 c4 14             	add    $0x14,%esp
  8021cb:	5b                   	pop    %ebx
  8021cc:	5d                   	pop    %ebp
  8021cd:	c3                   	ret    

008021ce <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021df:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8021e9:	e8 e5 fe ff ff       	call   8020d3 <nsipc>
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <nsipc_close>:

int
nsipc_close(int s)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  8021fe:	b8 04 00 00 00       	mov    $0x4,%eax
  802203:	e8 cb fe ff ff       	call   8020d3 <nsipc>
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
  80220d:	53                   	push   %ebx
  80220e:	83 ec 14             	sub    $0x14,%esp
  802211:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80221c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802220:	8b 45 0c             	mov    0xc(%ebp),%eax
  802223:	89 44 24 04          	mov    %eax,0x4(%esp)
  802227:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80222e:	e8 71 e8 ff ff       	call   800aa4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802233:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802239:	b8 05 00 00 00       	mov    $0x5,%eax
  80223e:	e8 90 fe ff ff       	call   8020d3 <nsipc>
}
  802243:	83 c4 14             	add    $0x14,%esp
  802246:	5b                   	pop    %ebx
  802247:	5d                   	pop    %ebp
  802248:	c3                   	ret    

00802249 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80224f:	8b 45 08             	mov    0x8(%ebp),%eax
  802252:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80225a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80225f:	b8 06 00 00 00       	mov    $0x6,%eax
  802264:	e8 6a fe ff ff       	call   8020d3 <nsipc>
}
  802269:	c9                   	leave  
  80226a:	c3                   	ret    

0080226b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
  80226e:	56                   	push   %esi
  80226f:	53                   	push   %ebx
  802270:	83 ec 10             	sub    $0x10,%esp
  802273:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80227e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802284:	8b 45 14             	mov    0x14(%ebp),%eax
  802287:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80228c:	b8 07 00 00 00       	mov    $0x7,%eax
  802291:	e8 3d fe ff ff       	call   8020d3 <nsipc>
  802296:	89 c3                	mov    %eax,%ebx
  802298:	85 c0                	test   %eax,%eax
  80229a:	78 46                	js     8022e2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80229c:	39 f0                	cmp    %esi,%eax
  80229e:	7f 07                	jg     8022a7 <nsipc_recv+0x3c>
  8022a0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022a5:	7e 24                	jle    8022cb <nsipc_recv+0x60>
  8022a7:	c7 44 24 0c 2b 32 80 	movl   $0x80322b,0xc(%esp)
  8022ae:	00 
  8022af:	c7 44 24 08 f3 31 80 	movl   $0x8031f3,0x8(%esp)
  8022b6:	00 
  8022b7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8022be:	00 
  8022bf:	c7 04 24 40 32 80 00 	movl   $0x803240,(%esp)
  8022c6:	e8 eb 05 00 00       	call   8028b6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022cb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022cf:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8022d6:	00 
  8022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022da:	89 04 24             	mov    %eax,(%esp)
  8022dd:	e8 c2 e7 ff ff       	call   800aa4 <memmove>
	}

	return r;
}
  8022e2:	89 d8                	mov    %ebx,%eax
  8022e4:	83 c4 10             	add    $0x10,%esp
  8022e7:	5b                   	pop    %ebx
  8022e8:	5e                   	pop    %esi
  8022e9:	5d                   	pop    %ebp
  8022ea:	c3                   	ret    

008022eb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	53                   	push   %ebx
  8022ef:	83 ec 14             	sub    $0x14,%esp
  8022f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8022fd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802303:	7e 24                	jle    802329 <nsipc_send+0x3e>
  802305:	c7 44 24 0c 4c 32 80 	movl   $0x80324c,0xc(%esp)
  80230c:	00 
  80230d:	c7 44 24 08 f3 31 80 	movl   $0x8031f3,0x8(%esp)
  802314:	00 
  802315:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80231c:	00 
  80231d:	c7 04 24 40 32 80 00 	movl   $0x803240,(%esp)
  802324:	e8 8d 05 00 00       	call   8028b6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802329:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80232d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802330:	89 44 24 04          	mov    %eax,0x4(%esp)
  802334:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80233b:	e8 64 e7 ff ff       	call   800aa4 <memmove>
	nsipcbuf.send.req_size = size;
  802340:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802346:	8b 45 14             	mov    0x14(%ebp),%eax
  802349:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80234e:	b8 08 00 00 00       	mov    $0x8,%eax
  802353:	e8 7b fd ff ff       	call   8020d3 <nsipc>
}
  802358:	83 c4 14             	add    $0x14,%esp
  80235b:	5b                   	pop    %ebx
  80235c:	5d                   	pop    %ebp
  80235d:	c3                   	ret    

0080235e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
  802361:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80236c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802374:	8b 45 10             	mov    0x10(%ebp),%eax
  802377:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80237c:	b8 09 00 00 00       	mov    $0x9,%eax
  802381:	e8 4d fd ff ff       	call   8020d3 <nsipc>
}
  802386:	c9                   	leave  
  802387:	c3                   	ret    

00802388 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802388:	55                   	push   %ebp
  802389:	89 e5                	mov    %esp,%ebp
  80238b:	56                   	push   %esi
  80238c:	53                   	push   %ebx
  80238d:	83 ec 10             	sub    $0x10,%esp
  802390:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	89 04 24             	mov    %eax,(%esp)
  802399:	e8 12 f2 ff ff       	call   8015b0 <fd2data>
  80239e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023a0:	c7 44 24 04 58 32 80 	movl   $0x803258,0x4(%esp)
  8023a7:	00 
  8023a8:	89 1c 24             	mov    %ebx,(%esp)
  8023ab:	e8 57 e5 ff ff       	call   800907 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023b0:	8b 46 04             	mov    0x4(%esi),%eax
  8023b3:	2b 06                	sub    (%esi),%eax
  8023b5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023bb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023c2:	00 00 00 
	stat->st_dev = &devpipe;
  8023c5:	c7 83 88 00 00 00 44 	movl   $0x804044,0x88(%ebx)
  8023cc:	40 80 00 
	return 0;
}
  8023cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d4:	83 c4 10             	add    $0x10,%esp
  8023d7:	5b                   	pop    %ebx
  8023d8:	5e                   	pop    %esi
  8023d9:	5d                   	pop    %ebp
  8023da:	c3                   	ret    

008023db <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
  8023de:	53                   	push   %ebx
  8023df:	83 ec 14             	sub    $0x14,%esp
  8023e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023e5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f0:	e8 d5 e9 ff ff       	call   800dca <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023f5:	89 1c 24             	mov    %ebx,(%esp)
  8023f8:	e8 b3 f1 ff ff       	call   8015b0 <fd2data>
  8023fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802401:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802408:	e8 bd e9 ff ff       	call   800dca <sys_page_unmap>
}
  80240d:	83 c4 14             	add    $0x14,%esp
  802410:	5b                   	pop    %ebx
  802411:	5d                   	pop    %ebp
  802412:	c3                   	ret    

00802413 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
  802416:	57                   	push   %edi
  802417:	56                   	push   %esi
  802418:	53                   	push   %ebx
  802419:	83 ec 2c             	sub    $0x2c,%esp
  80241c:	89 c6                	mov    %eax,%esi
  80241e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802421:	a1 08 50 80 00       	mov    0x805008,%eax
  802426:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802429:	89 34 24             	mov    %esi,(%esp)
  80242c:	e8 80 05 00 00       	call   8029b1 <pageref>
  802431:	89 c7                	mov    %eax,%edi
  802433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802436:	89 04 24             	mov    %eax,(%esp)
  802439:	e8 73 05 00 00       	call   8029b1 <pageref>
  80243e:	39 c7                	cmp    %eax,%edi
  802440:	0f 94 c2             	sete   %dl
  802443:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802446:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80244c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80244f:	39 fb                	cmp    %edi,%ebx
  802451:	74 21                	je     802474 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802453:	84 d2                	test   %dl,%dl
  802455:	74 ca                	je     802421 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802457:	8b 51 58             	mov    0x58(%ecx),%edx
  80245a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80245e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802462:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802466:	c7 04 24 5f 32 80 00 	movl   $0x80325f,(%esp)
  80246d:	e8 72 de ff ff       	call   8002e4 <cprintf>
  802472:	eb ad                	jmp    802421 <_pipeisclosed+0xe>
	}
}
  802474:	83 c4 2c             	add    $0x2c,%esp
  802477:	5b                   	pop    %ebx
  802478:	5e                   	pop    %esi
  802479:	5f                   	pop    %edi
  80247a:	5d                   	pop    %ebp
  80247b:	c3                   	ret    

0080247c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
  80247f:	57                   	push   %edi
  802480:	56                   	push   %esi
  802481:	53                   	push   %ebx
  802482:	83 ec 1c             	sub    $0x1c,%esp
  802485:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802488:	89 34 24             	mov    %esi,(%esp)
  80248b:	e8 20 f1 ff ff       	call   8015b0 <fd2data>
  802490:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802492:	bf 00 00 00 00       	mov    $0x0,%edi
  802497:	eb 45                	jmp    8024de <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802499:	89 da                	mov    %ebx,%edx
  80249b:	89 f0                	mov    %esi,%eax
  80249d:	e8 71 ff ff ff       	call   802413 <_pipeisclosed>
  8024a2:	85 c0                	test   %eax,%eax
  8024a4:	75 41                	jne    8024e7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8024a6:	e8 59 e8 ff ff       	call   800d04 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024ab:	8b 43 04             	mov    0x4(%ebx),%eax
  8024ae:	8b 0b                	mov    (%ebx),%ecx
  8024b0:	8d 51 20             	lea    0x20(%ecx),%edx
  8024b3:	39 d0                	cmp    %edx,%eax
  8024b5:	73 e2                	jae    802499 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024ba:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024be:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024c1:	99                   	cltd   
  8024c2:	c1 ea 1b             	shr    $0x1b,%edx
  8024c5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8024c8:	83 e1 1f             	and    $0x1f,%ecx
  8024cb:	29 d1                	sub    %edx,%ecx
  8024cd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8024d1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8024d5:	83 c0 01             	add    $0x1,%eax
  8024d8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024db:	83 c7 01             	add    $0x1,%edi
  8024de:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024e1:	75 c8                	jne    8024ab <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8024e3:	89 f8                	mov    %edi,%eax
  8024e5:	eb 05                	jmp    8024ec <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024e7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8024ec:	83 c4 1c             	add    $0x1c,%esp
  8024ef:	5b                   	pop    %ebx
  8024f0:	5e                   	pop    %esi
  8024f1:	5f                   	pop    %edi
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    

008024f4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
  8024f7:	57                   	push   %edi
  8024f8:	56                   	push   %esi
  8024f9:	53                   	push   %ebx
  8024fa:	83 ec 1c             	sub    $0x1c,%esp
  8024fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802500:	89 3c 24             	mov    %edi,(%esp)
  802503:	e8 a8 f0 ff ff       	call   8015b0 <fd2data>
  802508:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80250a:	be 00 00 00 00       	mov    $0x0,%esi
  80250f:	eb 3d                	jmp    80254e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802511:	85 f6                	test   %esi,%esi
  802513:	74 04                	je     802519 <devpipe_read+0x25>
				return i;
  802515:	89 f0                	mov    %esi,%eax
  802517:	eb 43                	jmp    80255c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802519:	89 da                	mov    %ebx,%edx
  80251b:	89 f8                	mov    %edi,%eax
  80251d:	e8 f1 fe ff ff       	call   802413 <_pipeisclosed>
  802522:	85 c0                	test   %eax,%eax
  802524:	75 31                	jne    802557 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802526:	e8 d9 e7 ff ff       	call   800d04 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80252b:	8b 03                	mov    (%ebx),%eax
  80252d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802530:	74 df                	je     802511 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802532:	99                   	cltd   
  802533:	c1 ea 1b             	shr    $0x1b,%edx
  802536:	01 d0                	add    %edx,%eax
  802538:	83 e0 1f             	and    $0x1f,%eax
  80253b:	29 d0                	sub    %edx,%eax
  80253d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802542:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802545:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802548:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80254b:	83 c6 01             	add    $0x1,%esi
  80254e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802551:	75 d8                	jne    80252b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802553:	89 f0                	mov    %esi,%eax
  802555:	eb 05                	jmp    80255c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802557:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80255c:	83 c4 1c             	add    $0x1c,%esp
  80255f:	5b                   	pop    %ebx
  802560:	5e                   	pop    %esi
  802561:	5f                   	pop    %edi
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    

00802564 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	56                   	push   %esi
  802568:	53                   	push   %ebx
  802569:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80256c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80256f:	89 04 24             	mov    %eax,(%esp)
  802572:	e8 50 f0 ff ff       	call   8015c7 <fd_alloc>
  802577:	89 c2                	mov    %eax,%edx
  802579:	85 d2                	test   %edx,%edx
  80257b:	0f 88 4d 01 00 00    	js     8026ce <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802581:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802588:	00 
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802590:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802597:	e8 87 e7 ff ff       	call   800d23 <sys_page_alloc>
  80259c:	89 c2                	mov    %eax,%edx
  80259e:	85 d2                	test   %edx,%edx
  8025a0:	0f 88 28 01 00 00    	js     8026ce <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8025a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025a9:	89 04 24             	mov    %eax,(%esp)
  8025ac:	e8 16 f0 ff ff       	call   8015c7 <fd_alloc>
  8025b1:	89 c3                	mov    %eax,%ebx
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	0f 88 fe 00 00 00    	js     8026b9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025bb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025c2:	00 
  8025c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025d1:	e8 4d e7 ff ff       	call   800d23 <sys_page_alloc>
  8025d6:	89 c3                	mov    %eax,%ebx
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	0f 88 d9 00 00 00    	js     8026b9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	89 04 24             	mov    %eax,(%esp)
  8025e6:	e8 c5 ef ff ff       	call   8015b0 <fd2data>
  8025eb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025ed:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025f4:	00 
  8025f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802600:	e8 1e e7 ff ff       	call   800d23 <sys_page_alloc>
  802605:	89 c3                	mov    %eax,%ebx
  802607:	85 c0                	test   %eax,%eax
  802609:	0f 88 97 00 00 00    	js     8026a6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80260f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802612:	89 04 24             	mov    %eax,(%esp)
  802615:	e8 96 ef ff ff       	call   8015b0 <fd2data>
  80261a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802621:	00 
  802622:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802626:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80262d:	00 
  80262e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802632:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802639:	e8 39 e7 ff ff       	call   800d77 <sys_page_map>
  80263e:	89 c3                	mov    %eax,%ebx
  802640:	85 c0                	test   %eax,%eax
  802642:	78 52                	js     802696 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802644:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802659:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80265f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802662:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802667:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	89 04 24             	mov    %eax,(%esp)
  802674:	e8 27 ef ff ff       	call   8015a0 <fd2num>
  802679:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80267c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80267e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802681:	89 04 24             	mov    %eax,(%esp)
  802684:	e8 17 ef ff ff       	call   8015a0 <fd2num>
  802689:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80268c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80268f:	b8 00 00 00 00       	mov    $0x0,%eax
  802694:	eb 38                	jmp    8026ce <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802696:	89 74 24 04          	mov    %esi,0x4(%esp)
  80269a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a1:	e8 24 e7 ff ff       	call   800dca <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8026a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b4:	e8 11 e7 ff ff       	call   800dca <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c7:	e8 fe e6 ff ff       	call   800dca <sys_page_unmap>
  8026cc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8026ce:	83 c4 30             	add    $0x30,%esp
  8026d1:	5b                   	pop    %ebx
  8026d2:	5e                   	pop    %esi
  8026d3:	5d                   	pop    %ebp
  8026d4:	c3                   	ret    

008026d5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
  8026d8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e5:	89 04 24             	mov    %eax,(%esp)
  8026e8:	e8 29 ef ff ff       	call   801616 <fd_lookup>
  8026ed:	89 c2                	mov    %eax,%edx
  8026ef:	85 d2                	test   %edx,%edx
  8026f1:	78 15                	js     802708 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	89 04 24             	mov    %eax,(%esp)
  8026f9:	e8 b2 ee ff ff       	call   8015b0 <fd2data>
	return _pipeisclosed(fd, p);
  8026fe:	89 c2                	mov    %eax,%edx
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	e8 0b fd ff ff       	call   802413 <_pipeisclosed>
}
  802708:	c9                   	leave  
  802709:	c3                   	ret    
  80270a:	66 90                	xchg   %ax,%ax
  80270c:	66 90                	xchg   %ax,%ax
  80270e:	66 90                	xchg   %ax,%ax

00802710 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802713:	b8 00 00 00 00       	mov    $0x0,%eax
  802718:	5d                   	pop    %ebp
  802719:	c3                   	ret    

0080271a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80271a:	55                   	push   %ebp
  80271b:	89 e5                	mov    %esp,%ebp
  80271d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802720:	c7 44 24 04 77 32 80 	movl   $0x803277,0x4(%esp)
  802727:	00 
  802728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272b:	89 04 24             	mov    %eax,(%esp)
  80272e:	e8 d4 e1 ff ff       	call   800907 <strcpy>
	return 0;
}
  802733:	b8 00 00 00 00       	mov    $0x0,%eax
  802738:	c9                   	leave  
  802739:	c3                   	ret    

0080273a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80273a:	55                   	push   %ebp
  80273b:	89 e5                	mov    %esp,%ebp
  80273d:	57                   	push   %edi
  80273e:	56                   	push   %esi
  80273f:	53                   	push   %ebx
  802740:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802746:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80274b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802751:	eb 31                	jmp    802784 <devcons_write+0x4a>
		m = n - tot;
  802753:	8b 75 10             	mov    0x10(%ebp),%esi
  802756:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802758:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80275b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802760:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802763:	89 74 24 08          	mov    %esi,0x8(%esp)
  802767:	03 45 0c             	add    0xc(%ebp),%eax
  80276a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80276e:	89 3c 24             	mov    %edi,(%esp)
  802771:	e8 2e e3 ff ff       	call   800aa4 <memmove>
		sys_cputs(buf, m);
  802776:	89 74 24 04          	mov    %esi,0x4(%esp)
  80277a:	89 3c 24             	mov    %edi,(%esp)
  80277d:	e8 d4 e4 ff ff       	call   800c56 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802782:	01 f3                	add    %esi,%ebx
  802784:	89 d8                	mov    %ebx,%eax
  802786:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802789:	72 c8                	jb     802753 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80278b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802791:	5b                   	pop    %ebx
  802792:	5e                   	pop    %esi
  802793:	5f                   	pop    %edi
  802794:	5d                   	pop    %ebp
  802795:	c3                   	ret    

00802796 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
  802799:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80279c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8027a1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027a5:	75 07                	jne    8027ae <devcons_read+0x18>
  8027a7:	eb 2a                	jmp    8027d3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8027a9:	e8 56 e5 ff ff       	call   800d04 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8027ae:	66 90                	xchg   %ax,%ax
  8027b0:	e8 bf e4 ff ff       	call   800c74 <sys_cgetc>
  8027b5:	85 c0                	test   %eax,%eax
  8027b7:	74 f0                	je     8027a9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8027b9:	85 c0                	test   %eax,%eax
  8027bb:	78 16                	js     8027d3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8027bd:	83 f8 04             	cmp    $0x4,%eax
  8027c0:	74 0c                	je     8027ce <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8027c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c5:	88 02                	mov    %al,(%edx)
	return 1;
  8027c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8027cc:	eb 05                	jmp    8027d3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8027ce:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8027d3:	c9                   	leave  
  8027d4:	c3                   	ret    

008027d5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8027d5:	55                   	push   %ebp
  8027d6:	89 e5                	mov    %esp,%ebp
  8027d8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8027db:	8b 45 08             	mov    0x8(%ebp),%eax
  8027de:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8027e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8027e8:	00 
  8027e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027ec:	89 04 24             	mov    %eax,(%esp)
  8027ef:	e8 62 e4 ff ff       	call   800c56 <sys_cputs>
}
  8027f4:	c9                   	leave  
  8027f5:	c3                   	ret    

008027f6 <getchar>:

int
getchar(void)
{
  8027f6:	55                   	push   %ebp
  8027f7:	89 e5                	mov    %esp,%ebp
  8027f9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8027fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802803:	00 
  802804:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802807:	89 44 24 04          	mov    %eax,0x4(%esp)
  80280b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802812:	e8 93 f0 ff ff       	call   8018aa <read>
	if (r < 0)
  802817:	85 c0                	test   %eax,%eax
  802819:	78 0f                	js     80282a <getchar+0x34>
		return r;
	if (r < 1)
  80281b:	85 c0                	test   %eax,%eax
  80281d:	7e 06                	jle    802825 <getchar+0x2f>
		return -E_EOF;
	return c;
  80281f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802823:	eb 05                	jmp    80282a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802825:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80282a:	c9                   	leave  
  80282b:	c3                   	ret    

0080282c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80282c:	55                   	push   %ebp
  80282d:	89 e5                	mov    %esp,%ebp
  80282f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802832:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802835:	89 44 24 04          	mov    %eax,0x4(%esp)
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	89 04 24             	mov    %eax,(%esp)
  80283f:	e8 d2 ed ff ff       	call   801616 <fd_lookup>
  802844:	85 c0                	test   %eax,%eax
  802846:	78 11                	js     802859 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802851:	39 10                	cmp    %edx,(%eax)
  802853:	0f 94 c0             	sete   %al
  802856:	0f b6 c0             	movzbl %al,%eax
}
  802859:	c9                   	leave  
  80285a:	c3                   	ret    

0080285b <opencons>:

int
opencons(void)
{
  80285b:	55                   	push   %ebp
  80285c:	89 e5                	mov    %esp,%ebp
  80285e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802861:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802864:	89 04 24             	mov    %eax,(%esp)
  802867:	e8 5b ed ff ff       	call   8015c7 <fd_alloc>
		return r;
  80286c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80286e:	85 c0                	test   %eax,%eax
  802870:	78 40                	js     8028b2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802872:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802879:	00 
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802881:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802888:	e8 96 e4 ff ff       	call   800d23 <sys_page_alloc>
		return r;
  80288d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80288f:	85 c0                	test   %eax,%eax
  802891:	78 1f                	js     8028b2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802893:	8b 15 60 40 80 00    	mov    0x804060,%edx
  802899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028a8:	89 04 24             	mov    %eax,(%esp)
  8028ab:	e8 f0 ec ff ff       	call   8015a0 <fd2num>
  8028b0:	89 c2                	mov    %eax,%edx
}
  8028b2:	89 d0                	mov    %edx,%eax
  8028b4:	c9                   	leave  
  8028b5:	c3                   	ret    

008028b6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8028b6:	55                   	push   %ebp
  8028b7:	89 e5                	mov    %esp,%ebp
  8028b9:	56                   	push   %esi
  8028ba:	53                   	push   %ebx
  8028bb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8028be:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8028c1:	8b 35 08 40 80 00    	mov    0x804008,%esi
  8028c7:	e8 19 e4 ff ff       	call   800ce5 <sys_getenvid>
  8028cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028cf:	89 54 24 10          	mov    %edx,0x10(%esp)
  8028d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8028da:	89 74 24 08          	mov    %esi,0x8(%esp)
  8028de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028e2:	c7 04 24 84 32 80 00 	movl   $0x803284,(%esp)
  8028e9:	e8 f6 d9 ff ff       	call   8002e4 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8028ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8028f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8028f5:	89 04 24             	mov    %eax,(%esp)
  8028f8:	e8 86 d9 ff ff       	call   800283 <vcprintf>
	cprintf("\n");
  8028fd:	c7 04 24 70 32 80 00 	movl   $0x803270,(%esp)
  802904:	e8 db d9 ff ff       	call   8002e4 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802909:	cc                   	int3   
  80290a:	eb fd                	jmp    802909 <_panic+0x53>

0080290c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80290c:	55                   	push   %ebp
  80290d:	89 e5                	mov    %esp,%ebp
  80290f:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802912:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802919:	75 68                	jne    802983 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  80291b:	a1 08 50 80 00       	mov    0x805008,%eax
  802920:	8b 40 48             	mov    0x48(%eax),%eax
  802923:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80292a:	00 
  80292b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802932:	ee 
  802933:	89 04 24             	mov    %eax,(%esp)
  802936:	e8 e8 e3 ff ff       	call   800d23 <sys_page_alloc>
  80293b:	85 c0                	test   %eax,%eax
  80293d:	74 2c                	je     80296b <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  80293f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802943:	c7 04 24 a8 32 80 00 	movl   $0x8032a8,(%esp)
  80294a:	e8 95 d9 ff ff       	call   8002e4 <cprintf>
			panic("set_pg_fault_handler");
  80294f:	c7 44 24 08 dc 32 80 	movl   $0x8032dc,0x8(%esp)
  802956:	00 
  802957:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  80295e:	00 
  80295f:	c7 04 24 f1 32 80 00 	movl   $0x8032f1,(%esp)
  802966:	e8 4b ff ff ff       	call   8028b6 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  80296b:	a1 08 50 80 00       	mov    0x805008,%eax
  802970:	8b 40 48             	mov    0x48(%eax),%eax
  802973:	c7 44 24 04 8d 29 80 	movl   $0x80298d,0x4(%esp)
  80297a:	00 
  80297b:	89 04 24             	mov    %eax,(%esp)
  80297e:	e8 40 e5 ff ff       	call   800ec3 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80298b:	c9                   	leave  
  80298c:	c3                   	ret    

0080298d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80298d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80298e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802993:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802995:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  802998:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  80299c:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  80299e:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  8029a2:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  8029a3:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  8029a6:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  8029a8:	58                   	pop    %eax
	popl %eax
  8029a9:	58                   	pop    %eax
	popal
  8029aa:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  8029ab:	83 c4 04             	add    $0x4,%esp
	popfl
  8029ae:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8029af:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  8029b0:	c3                   	ret    

008029b1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029b1:	55                   	push   %ebp
  8029b2:	89 e5                	mov    %esp,%ebp
  8029b4:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029b7:	89 d0                	mov    %edx,%eax
  8029b9:	c1 e8 16             	shr    $0x16,%eax
  8029bc:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029c3:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029c8:	f6 c1 01             	test   $0x1,%cl
  8029cb:	74 1d                	je     8029ea <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8029cd:	c1 ea 0c             	shr    $0xc,%edx
  8029d0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029d7:	f6 c2 01             	test   $0x1,%dl
  8029da:	74 0e                	je     8029ea <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029dc:	c1 ea 0c             	shr    $0xc,%edx
  8029df:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029e6:	ef 
  8029e7:	0f b7 c0             	movzwl %ax,%eax
}
  8029ea:	5d                   	pop    %ebp
  8029eb:	c3                   	ret    
  8029ec:	66 90                	xchg   %ax,%ax
  8029ee:	66 90                	xchg   %ax,%ax

008029f0 <__udivdi3>:
  8029f0:	55                   	push   %ebp
  8029f1:	57                   	push   %edi
  8029f2:	56                   	push   %esi
  8029f3:	83 ec 0c             	sub    $0xc,%esp
  8029f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8029fa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8029fe:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802a02:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a06:	85 c0                	test   %eax,%eax
  802a08:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802a0c:	89 ea                	mov    %ebp,%edx
  802a0e:	89 0c 24             	mov    %ecx,(%esp)
  802a11:	75 2d                	jne    802a40 <__udivdi3+0x50>
  802a13:	39 e9                	cmp    %ebp,%ecx
  802a15:	77 61                	ja     802a78 <__udivdi3+0x88>
  802a17:	85 c9                	test   %ecx,%ecx
  802a19:	89 ce                	mov    %ecx,%esi
  802a1b:	75 0b                	jne    802a28 <__udivdi3+0x38>
  802a1d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a22:	31 d2                	xor    %edx,%edx
  802a24:	f7 f1                	div    %ecx
  802a26:	89 c6                	mov    %eax,%esi
  802a28:	31 d2                	xor    %edx,%edx
  802a2a:	89 e8                	mov    %ebp,%eax
  802a2c:	f7 f6                	div    %esi
  802a2e:	89 c5                	mov    %eax,%ebp
  802a30:	89 f8                	mov    %edi,%eax
  802a32:	f7 f6                	div    %esi
  802a34:	89 ea                	mov    %ebp,%edx
  802a36:	83 c4 0c             	add    $0xc,%esp
  802a39:	5e                   	pop    %esi
  802a3a:	5f                   	pop    %edi
  802a3b:	5d                   	pop    %ebp
  802a3c:	c3                   	ret    
  802a3d:	8d 76 00             	lea    0x0(%esi),%esi
  802a40:	39 e8                	cmp    %ebp,%eax
  802a42:	77 24                	ja     802a68 <__udivdi3+0x78>
  802a44:	0f bd e8             	bsr    %eax,%ebp
  802a47:	83 f5 1f             	xor    $0x1f,%ebp
  802a4a:	75 3c                	jne    802a88 <__udivdi3+0x98>
  802a4c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802a50:	39 34 24             	cmp    %esi,(%esp)
  802a53:	0f 86 9f 00 00 00    	jbe    802af8 <__udivdi3+0x108>
  802a59:	39 d0                	cmp    %edx,%eax
  802a5b:	0f 82 97 00 00 00    	jb     802af8 <__udivdi3+0x108>
  802a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a68:	31 d2                	xor    %edx,%edx
  802a6a:	31 c0                	xor    %eax,%eax
  802a6c:	83 c4 0c             	add    $0xc,%esp
  802a6f:	5e                   	pop    %esi
  802a70:	5f                   	pop    %edi
  802a71:	5d                   	pop    %ebp
  802a72:	c3                   	ret    
  802a73:	90                   	nop
  802a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a78:	89 f8                	mov    %edi,%eax
  802a7a:	f7 f1                	div    %ecx
  802a7c:	31 d2                	xor    %edx,%edx
  802a7e:	83 c4 0c             	add    $0xc,%esp
  802a81:	5e                   	pop    %esi
  802a82:	5f                   	pop    %edi
  802a83:	5d                   	pop    %ebp
  802a84:	c3                   	ret    
  802a85:	8d 76 00             	lea    0x0(%esi),%esi
  802a88:	89 e9                	mov    %ebp,%ecx
  802a8a:	8b 3c 24             	mov    (%esp),%edi
  802a8d:	d3 e0                	shl    %cl,%eax
  802a8f:	89 c6                	mov    %eax,%esi
  802a91:	b8 20 00 00 00       	mov    $0x20,%eax
  802a96:	29 e8                	sub    %ebp,%eax
  802a98:	89 c1                	mov    %eax,%ecx
  802a9a:	d3 ef                	shr    %cl,%edi
  802a9c:	89 e9                	mov    %ebp,%ecx
  802a9e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802aa2:	8b 3c 24             	mov    (%esp),%edi
  802aa5:	09 74 24 08          	or     %esi,0x8(%esp)
  802aa9:	89 d6                	mov    %edx,%esi
  802aab:	d3 e7                	shl    %cl,%edi
  802aad:	89 c1                	mov    %eax,%ecx
  802aaf:	89 3c 24             	mov    %edi,(%esp)
  802ab2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ab6:	d3 ee                	shr    %cl,%esi
  802ab8:	89 e9                	mov    %ebp,%ecx
  802aba:	d3 e2                	shl    %cl,%edx
  802abc:	89 c1                	mov    %eax,%ecx
  802abe:	d3 ef                	shr    %cl,%edi
  802ac0:	09 d7                	or     %edx,%edi
  802ac2:	89 f2                	mov    %esi,%edx
  802ac4:	89 f8                	mov    %edi,%eax
  802ac6:	f7 74 24 08          	divl   0x8(%esp)
  802aca:	89 d6                	mov    %edx,%esi
  802acc:	89 c7                	mov    %eax,%edi
  802ace:	f7 24 24             	mull   (%esp)
  802ad1:	39 d6                	cmp    %edx,%esi
  802ad3:	89 14 24             	mov    %edx,(%esp)
  802ad6:	72 30                	jb     802b08 <__udivdi3+0x118>
  802ad8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802adc:	89 e9                	mov    %ebp,%ecx
  802ade:	d3 e2                	shl    %cl,%edx
  802ae0:	39 c2                	cmp    %eax,%edx
  802ae2:	73 05                	jae    802ae9 <__udivdi3+0xf9>
  802ae4:	3b 34 24             	cmp    (%esp),%esi
  802ae7:	74 1f                	je     802b08 <__udivdi3+0x118>
  802ae9:	89 f8                	mov    %edi,%eax
  802aeb:	31 d2                	xor    %edx,%edx
  802aed:	e9 7a ff ff ff       	jmp    802a6c <__udivdi3+0x7c>
  802af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802af8:	31 d2                	xor    %edx,%edx
  802afa:	b8 01 00 00 00       	mov    $0x1,%eax
  802aff:	e9 68 ff ff ff       	jmp    802a6c <__udivdi3+0x7c>
  802b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b08:	8d 47 ff             	lea    -0x1(%edi),%eax
  802b0b:	31 d2                	xor    %edx,%edx
  802b0d:	83 c4 0c             	add    $0xc,%esp
  802b10:	5e                   	pop    %esi
  802b11:	5f                   	pop    %edi
  802b12:	5d                   	pop    %ebp
  802b13:	c3                   	ret    
  802b14:	66 90                	xchg   %ax,%ax
  802b16:	66 90                	xchg   %ax,%ax
  802b18:	66 90                	xchg   %ax,%ax
  802b1a:	66 90                	xchg   %ax,%ax
  802b1c:	66 90                	xchg   %ax,%ax
  802b1e:	66 90                	xchg   %ax,%ax

00802b20 <__umoddi3>:
  802b20:	55                   	push   %ebp
  802b21:	57                   	push   %edi
  802b22:	56                   	push   %esi
  802b23:	83 ec 14             	sub    $0x14,%esp
  802b26:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b2a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b2e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802b32:	89 c7                	mov    %eax,%edi
  802b34:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b38:	8b 44 24 30          	mov    0x30(%esp),%eax
  802b3c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802b40:	89 34 24             	mov    %esi,(%esp)
  802b43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b47:	85 c0                	test   %eax,%eax
  802b49:	89 c2                	mov    %eax,%edx
  802b4b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b4f:	75 17                	jne    802b68 <__umoddi3+0x48>
  802b51:	39 fe                	cmp    %edi,%esi
  802b53:	76 4b                	jbe    802ba0 <__umoddi3+0x80>
  802b55:	89 c8                	mov    %ecx,%eax
  802b57:	89 fa                	mov    %edi,%edx
  802b59:	f7 f6                	div    %esi
  802b5b:	89 d0                	mov    %edx,%eax
  802b5d:	31 d2                	xor    %edx,%edx
  802b5f:	83 c4 14             	add    $0x14,%esp
  802b62:	5e                   	pop    %esi
  802b63:	5f                   	pop    %edi
  802b64:	5d                   	pop    %ebp
  802b65:	c3                   	ret    
  802b66:	66 90                	xchg   %ax,%ax
  802b68:	39 f8                	cmp    %edi,%eax
  802b6a:	77 54                	ja     802bc0 <__umoddi3+0xa0>
  802b6c:	0f bd e8             	bsr    %eax,%ebp
  802b6f:	83 f5 1f             	xor    $0x1f,%ebp
  802b72:	75 5c                	jne    802bd0 <__umoddi3+0xb0>
  802b74:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802b78:	39 3c 24             	cmp    %edi,(%esp)
  802b7b:	0f 87 e7 00 00 00    	ja     802c68 <__umoddi3+0x148>
  802b81:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b85:	29 f1                	sub    %esi,%ecx
  802b87:	19 c7                	sbb    %eax,%edi
  802b89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b91:	8b 44 24 08          	mov    0x8(%esp),%eax
  802b95:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802b99:	83 c4 14             	add    $0x14,%esp
  802b9c:	5e                   	pop    %esi
  802b9d:	5f                   	pop    %edi
  802b9e:	5d                   	pop    %ebp
  802b9f:	c3                   	ret    
  802ba0:	85 f6                	test   %esi,%esi
  802ba2:	89 f5                	mov    %esi,%ebp
  802ba4:	75 0b                	jne    802bb1 <__umoddi3+0x91>
  802ba6:	b8 01 00 00 00       	mov    $0x1,%eax
  802bab:	31 d2                	xor    %edx,%edx
  802bad:	f7 f6                	div    %esi
  802baf:	89 c5                	mov    %eax,%ebp
  802bb1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802bb5:	31 d2                	xor    %edx,%edx
  802bb7:	f7 f5                	div    %ebp
  802bb9:	89 c8                	mov    %ecx,%eax
  802bbb:	f7 f5                	div    %ebp
  802bbd:	eb 9c                	jmp    802b5b <__umoddi3+0x3b>
  802bbf:	90                   	nop
  802bc0:	89 c8                	mov    %ecx,%eax
  802bc2:	89 fa                	mov    %edi,%edx
  802bc4:	83 c4 14             	add    $0x14,%esp
  802bc7:	5e                   	pop    %esi
  802bc8:	5f                   	pop    %edi
  802bc9:	5d                   	pop    %ebp
  802bca:	c3                   	ret    
  802bcb:	90                   	nop
  802bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bd0:	8b 04 24             	mov    (%esp),%eax
  802bd3:	be 20 00 00 00       	mov    $0x20,%esi
  802bd8:	89 e9                	mov    %ebp,%ecx
  802bda:	29 ee                	sub    %ebp,%esi
  802bdc:	d3 e2                	shl    %cl,%edx
  802bde:	89 f1                	mov    %esi,%ecx
  802be0:	d3 e8                	shr    %cl,%eax
  802be2:	89 e9                	mov    %ebp,%ecx
  802be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802be8:	8b 04 24             	mov    (%esp),%eax
  802beb:	09 54 24 04          	or     %edx,0x4(%esp)
  802bef:	89 fa                	mov    %edi,%edx
  802bf1:	d3 e0                	shl    %cl,%eax
  802bf3:	89 f1                	mov    %esi,%ecx
  802bf5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bf9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802bfd:	d3 ea                	shr    %cl,%edx
  802bff:	89 e9                	mov    %ebp,%ecx
  802c01:	d3 e7                	shl    %cl,%edi
  802c03:	89 f1                	mov    %esi,%ecx
  802c05:	d3 e8                	shr    %cl,%eax
  802c07:	89 e9                	mov    %ebp,%ecx
  802c09:	09 f8                	or     %edi,%eax
  802c0b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802c0f:	f7 74 24 04          	divl   0x4(%esp)
  802c13:	d3 e7                	shl    %cl,%edi
  802c15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c19:	89 d7                	mov    %edx,%edi
  802c1b:	f7 64 24 08          	mull   0x8(%esp)
  802c1f:	39 d7                	cmp    %edx,%edi
  802c21:	89 c1                	mov    %eax,%ecx
  802c23:	89 14 24             	mov    %edx,(%esp)
  802c26:	72 2c                	jb     802c54 <__umoddi3+0x134>
  802c28:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802c2c:	72 22                	jb     802c50 <__umoddi3+0x130>
  802c2e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802c32:	29 c8                	sub    %ecx,%eax
  802c34:	19 d7                	sbb    %edx,%edi
  802c36:	89 e9                	mov    %ebp,%ecx
  802c38:	89 fa                	mov    %edi,%edx
  802c3a:	d3 e8                	shr    %cl,%eax
  802c3c:	89 f1                	mov    %esi,%ecx
  802c3e:	d3 e2                	shl    %cl,%edx
  802c40:	89 e9                	mov    %ebp,%ecx
  802c42:	d3 ef                	shr    %cl,%edi
  802c44:	09 d0                	or     %edx,%eax
  802c46:	89 fa                	mov    %edi,%edx
  802c48:	83 c4 14             	add    $0x14,%esp
  802c4b:	5e                   	pop    %esi
  802c4c:	5f                   	pop    %edi
  802c4d:	5d                   	pop    %ebp
  802c4e:	c3                   	ret    
  802c4f:	90                   	nop
  802c50:	39 d7                	cmp    %edx,%edi
  802c52:	75 da                	jne    802c2e <__umoddi3+0x10e>
  802c54:	8b 14 24             	mov    (%esp),%edx
  802c57:	89 c1                	mov    %eax,%ecx
  802c59:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802c5d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802c61:	eb cb                	jmp    802c2e <__umoddi3+0x10e>
  802c63:	90                   	nop
  802c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c68:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802c6c:	0f 82 0f ff ff ff    	jb     802b81 <__umoddi3+0x61>
  802c72:	e9 1a ff ff ff       	jmp    802b91 <__umoddi3+0x71>
