
obj/user/primespipe.debug:     file format elf32-i386


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
  80002c:	e8 8c 02 00 00       	call   8002bd <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 3c             	sub    $0x3c,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  80003f:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800042:	8d 7d d8             	lea    -0x28(%ebp),%edi
{
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800045:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80004c:	00 
  80004d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800051:	89 1c 24             	mov    %ebx,(%esp)
  800054:	e8 f3 18 00 00       	call   80194c <readn>
  800059:	83 f8 04             	cmp    $0x4,%eax
  80005c:	74 2e                	je     80008c <primeproc+0x59>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  80005e:	85 c0                	test   %eax,%eax
  800060:	ba 00 00 00 00       	mov    $0x0,%edx
  800065:	0f 4e d0             	cmovle %eax,%edx
  800068:	89 54 24 10          	mov    %edx,0x10(%esp)
  80006c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800070:	c7 44 24 08 80 2d 80 	movl   $0x802d80,0x8(%esp)
  800077:	00 
  800078:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  80007f:	00 
  800080:	c7 04 24 af 2d 80 00 	movl   $0x802daf,(%esp)
  800087:	e8 92 02 00 00       	call   80031e <_panic>

	cprintf("%d\n", p);
  80008c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80008f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800093:	c7 04 24 c1 2d 80 00 	movl   $0x802dc1,(%esp)
  80009a:	e8 78 03 00 00       	call   800417 <cprintf>

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  80009f:	89 3c 24             	mov    %edi,(%esp)
  8000a2:	e8 cd 24 00 00       	call   802574 <pipe>
  8000a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	79 20                	jns    8000ce <primeproc+0x9b>
		panic("pipe: %e", i);
  8000ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b2:	c7 44 24 08 c5 2d 80 	movl   $0x802dc5,0x8(%esp)
  8000b9:	00 
  8000ba:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  8000c1:	00 
  8000c2:	c7 04 24 af 2d 80 00 	movl   $0x802daf,(%esp)
  8000c9:	e8 50 02 00 00       	call   80031e <_panic>
	if ((id = fork()) < 0)
  8000ce:	e8 dd 11 00 00       	call   8012b0 <fork>
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	79 20                	jns    8000f7 <primeproc+0xc4>
		panic("fork: %e", id);
  8000d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000db:	c7 44 24 08 ce 2d 80 	movl   $0x802dce,0x8(%esp)
  8000e2:	00 
  8000e3:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  8000ea:	00 
  8000eb:	c7 04 24 af 2d 80 00 	movl   $0x802daf,(%esp)
  8000f2:	e8 27 02 00 00       	call   80031e <_panic>
	if (id == 0) {
  8000f7:	85 c0                	test   %eax,%eax
  8000f9:	75 1b                	jne    800116 <primeproc+0xe3>
		close(fd);
  8000fb:	89 1c 24             	mov    %ebx,(%esp)
  8000fe:	e8 54 16 00 00       	call   801757 <close>
		close(pfd[1]);
  800103:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800106:	89 04 24             	mov    %eax,(%esp)
  800109:	e8 49 16 00 00       	call   801757 <close>
		fd = pfd[0];
  80010e:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  800111:	e9 2f ff ff ff       	jmp    800045 <primeproc+0x12>
	}

	close(pfd[0]);
  800116:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800119:	89 04 24             	mov    %eax,(%esp)
  80011c:	e8 36 16 00 00       	call   801757 <close>
	wfd = pfd[1];
  800121:	8b 7d dc             	mov    -0x24(%ebp),%edi

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  800124:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800127:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80012e:	00 
  80012f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800133:	89 1c 24             	mov    %ebx,(%esp)
  800136:	e8 11 18 00 00       	call   80194c <readn>
  80013b:	83 f8 04             	cmp    $0x4,%eax
  80013e:	74 39                	je     800179 <primeproc+0x146>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800140:	85 c0                	test   %eax,%eax
  800142:	ba 00 00 00 00       	mov    $0x0,%edx
  800147:	0f 4e d0             	cmovle %eax,%edx
  80014a:	89 54 24 18          	mov    %edx,0x18(%esp)
  80014e:	89 44 24 14          	mov    %eax,0x14(%esp)
  800152:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800156:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800159:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80015d:	c7 44 24 08 d7 2d 80 	movl   $0x802dd7,0x8(%esp)
  800164:	00 
  800165:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  80016c:	00 
  80016d:	c7 04 24 af 2d 80 00 	movl   $0x802daf,(%esp)
  800174:	e8 a5 01 00 00       	call   80031e <_panic>
		if (i%p)
  800179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80017c:	99                   	cltd   
  80017d:	f7 7d e0             	idivl  -0x20(%ebp)
  800180:	85 d2                	test   %edx,%edx
  800182:	74 a3                	je     800127 <primeproc+0xf4>
			if ((r=write(wfd, &i, 4)) != 4)
  800184:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80018b:	00 
  80018c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800190:	89 3c 24             	mov    %edi,(%esp)
  800193:	e8 ff 17 00 00       	call   801997 <write>
  800198:	83 f8 04             	cmp    $0x4,%eax
  80019b:	74 8a                	je     800127 <primeproc+0xf4>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  80019d:	85 c0                	test   %eax,%eax
  80019f:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a4:	0f 4e d0             	cmovle %eax,%edx
  8001a7:	89 54 24 14          	mov    %edx,0x14(%esp)
  8001ab:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b6:	c7 44 24 08 f3 2d 80 	movl   $0x802df3,0x8(%esp)
  8001bd:	00 
  8001be:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8001c5:	00 
  8001c6:	c7 04 24 af 2d 80 00 	movl   $0x802daf,(%esp)
  8001cd:	e8 4c 01 00 00       	call   80031e <_panic>

008001d2 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	53                   	push   %ebx
  8001d6:	83 ec 34             	sub    $0x34,%esp
	int i, id, p[2], r;

	binaryname = "primespipe";
  8001d9:	c7 05 00 40 80 00 0d 	movl   $0x802e0d,0x804000
  8001e0:	2e 80 00 

	if ((i=pipe(p)) < 0)
  8001e3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001e6:	89 04 24             	mov    %eax,(%esp)
  8001e9:	e8 86 23 00 00       	call   802574 <pipe>
  8001ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	79 20                	jns    800215 <umain+0x43>
		panic("pipe: %e", i);
  8001f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001f9:	c7 44 24 08 c5 2d 80 	movl   $0x802dc5,0x8(%esp)
  800200:	00 
  800201:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  800208:	00 
  800209:	c7 04 24 af 2d 80 00 	movl   $0x802daf,(%esp)
  800210:	e8 09 01 00 00       	call   80031e <_panic>

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800215:	e8 96 10 00 00       	call   8012b0 <fork>
  80021a:	85 c0                	test   %eax,%eax
  80021c:	79 20                	jns    80023e <umain+0x6c>
		panic("fork: %e", id);
  80021e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800222:	c7 44 24 08 ce 2d 80 	movl   $0x802dce,0x8(%esp)
  800229:	00 
  80022a:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  800231:	00 
  800232:	c7 04 24 af 2d 80 00 	movl   $0x802daf,(%esp)
  800239:	e8 e0 00 00 00       	call   80031e <_panic>

	if (id == 0) {
  80023e:	85 c0                	test   %eax,%eax
  800240:	75 16                	jne    800258 <umain+0x86>
		close(p[1]);
  800242:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800245:	89 04 24             	mov    %eax,(%esp)
  800248:	e8 0a 15 00 00       	call   801757 <close>
		primeproc(p[0]);
  80024d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800250:	89 04 24             	mov    %eax,(%esp)
  800253:	e8 db fd ff ff       	call   800033 <primeproc>
	}

	close(p[0]);
  800258:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025b:	89 04 24             	mov    %eax,(%esp)
  80025e:	e8 f4 14 00 00       	call   801757 <close>

	// feed all the integers through
	for (i=2;; i++)
  800263:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  80026a:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  80026d:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800274:	00 
  800275:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800279:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80027c:	89 04 24             	mov    %eax,(%esp)
  80027f:	e8 13 17 00 00       	call   801997 <write>
  800284:	83 f8 04             	cmp    $0x4,%eax
  800287:	74 2e                	je     8002b7 <umain+0xe5>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800289:	85 c0                	test   %eax,%eax
  80028b:	ba 00 00 00 00       	mov    $0x0,%edx
  800290:	0f 4e d0             	cmovle %eax,%edx
  800293:	89 54 24 10          	mov    %edx,0x10(%esp)
  800297:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80029b:	c7 44 24 08 18 2e 80 	movl   $0x802e18,0x8(%esp)
  8002a2:	00 
  8002a3:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8002aa:	00 
  8002ab:	c7 04 24 af 2d 80 00 	movl   $0x802daf,(%esp)
  8002b2:	e8 67 00 00 00       	call   80031e <_panic>
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  8002b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  8002bb:	eb b0                	jmp    80026d <umain+0x9b>

008002bd <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	56                   	push   %esi
  8002c1:	53                   	push   %ebx
  8002c2:	83 ec 10             	sub    $0x10,%esp
  8002c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002c8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002cb:	e8 55 0b 00 00       	call   800e25 <sys_getenvid>
  8002d0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002d5:	c1 e0 07             	shl    $0x7,%eax
  8002d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002dd:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002e2:	85 db                	test   %ebx,%ebx
  8002e4:	7e 07                	jle    8002ed <libmain+0x30>
		binaryname = argv[0];
  8002e6:	8b 06                	mov    (%esi),%eax
  8002e8:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  8002ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002f1:	89 1c 24             	mov    %ebx,(%esp)
  8002f4:	e8 d9 fe ff ff       	call   8001d2 <umain>

	// exit gracefully
	exit();
  8002f9:	e8 07 00 00 00       	call   800305 <exit>
}
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	5b                   	pop    %ebx
  800302:	5e                   	pop    %esi
  800303:	5d                   	pop    %ebp
  800304:	c3                   	ret    

00800305 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80030b:	e8 7a 14 00 00       	call   80178a <close_all>
	sys_env_destroy(0);
  800310:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800317:	e8 b7 0a 00 00       	call   800dd3 <sys_env_destroy>
}
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    

0080031e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80031e:	55                   	push   %ebp
  80031f:	89 e5                	mov    %esp,%ebp
  800321:	56                   	push   %esi
  800322:	53                   	push   %ebx
  800323:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800326:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800329:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80032f:	e8 f1 0a 00 00       	call   800e25 <sys_getenvid>
  800334:	8b 55 0c             	mov    0xc(%ebp),%edx
  800337:	89 54 24 10          	mov    %edx,0x10(%esp)
  80033b:	8b 55 08             	mov    0x8(%ebp),%edx
  80033e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800342:	89 74 24 08          	mov    %esi,0x8(%esp)
  800346:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034a:	c7 04 24 3c 2e 80 00 	movl   $0x802e3c,(%esp)
  800351:	e8 c1 00 00 00       	call   800417 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800356:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80035a:	8b 45 10             	mov    0x10(%ebp),%eax
  80035d:	89 04 24             	mov    %eax,(%esp)
  800360:	e8 51 00 00 00       	call   8003b6 <vcprintf>
	cprintf("\n");
  800365:	c7 04 24 c3 2d 80 00 	movl   $0x802dc3,(%esp)
  80036c:	e8 a6 00 00 00       	call   800417 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800371:	cc                   	int3   
  800372:	eb fd                	jmp    800371 <_panic+0x53>

00800374 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800374:	55                   	push   %ebp
  800375:	89 e5                	mov    %esp,%ebp
  800377:	53                   	push   %ebx
  800378:	83 ec 14             	sub    $0x14,%esp
  80037b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80037e:	8b 13                	mov    (%ebx),%edx
  800380:	8d 42 01             	lea    0x1(%edx),%eax
  800383:	89 03                	mov    %eax,(%ebx)
  800385:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800388:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80038c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800391:	75 19                	jne    8003ac <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800393:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80039a:	00 
  80039b:	8d 43 08             	lea    0x8(%ebx),%eax
  80039e:	89 04 24             	mov    %eax,(%esp)
  8003a1:	e8 f0 09 00 00       	call   800d96 <sys_cputs>
		b->idx = 0;
  8003a6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003ac:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003b0:	83 c4 14             	add    $0x14,%esp
  8003b3:	5b                   	pop    %ebx
  8003b4:	5d                   	pop    %ebp
  8003b5:	c3                   	ret    

008003b6 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003bf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003c6:	00 00 00 
	b.cnt = 0;
  8003c9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003d0:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003da:	8b 45 08             	mov    0x8(%ebp),%eax
  8003dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003eb:	c7 04 24 74 03 80 00 	movl   $0x800374,(%esp)
  8003f2:	e8 b7 01 00 00       	call   8005ae <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003f7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8003fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800401:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800407:	89 04 24             	mov    %eax,(%esp)
  80040a:	e8 87 09 00 00       	call   800d96 <sys_cputs>

	return b.cnt;
}
  80040f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800415:	c9                   	leave  
  800416:	c3                   	ret    

00800417 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800417:	55                   	push   %ebp
  800418:	89 e5                	mov    %esp,%ebp
  80041a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80041d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800420:	89 44 24 04          	mov    %eax,0x4(%esp)
  800424:	8b 45 08             	mov    0x8(%ebp),%eax
  800427:	89 04 24             	mov    %eax,(%esp)
  80042a:	e8 87 ff ff ff       	call   8003b6 <vcprintf>
	va_end(ap);

	return cnt;
}
  80042f:	c9                   	leave  
  800430:	c3                   	ret    
  800431:	66 90                	xchg   %ax,%ax
  800433:	66 90                	xchg   %ax,%ax
  800435:	66 90                	xchg   %ax,%ax
  800437:	66 90                	xchg   %ax,%ax
  800439:	66 90                	xchg   %ax,%ax
  80043b:	66 90                	xchg   %ax,%ax
  80043d:	66 90                	xchg   %ax,%ax
  80043f:	90                   	nop

00800440 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	57                   	push   %edi
  800444:	56                   	push   %esi
  800445:	53                   	push   %ebx
  800446:	83 ec 3c             	sub    $0x3c,%esp
  800449:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80044c:	89 d7                	mov    %edx,%edi
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800454:	8b 45 0c             	mov    0xc(%ebp),%eax
  800457:	89 c3                	mov    %eax,%ebx
  800459:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80045c:	8b 45 10             	mov    0x10(%ebp),%eax
  80045f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800462:	b9 00 00 00 00       	mov    $0x0,%ecx
  800467:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80046a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80046d:	39 d9                	cmp    %ebx,%ecx
  80046f:	72 05                	jb     800476 <printnum+0x36>
  800471:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800474:	77 69                	ja     8004df <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800476:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800479:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80047d:	83 ee 01             	sub    $0x1,%esi
  800480:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800484:	89 44 24 08          	mov    %eax,0x8(%esp)
  800488:	8b 44 24 08          	mov    0x8(%esp),%eax
  80048c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800490:	89 c3                	mov    %eax,%ebx
  800492:	89 d6                	mov    %edx,%esi
  800494:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800497:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80049a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80049e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8004a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a5:	89 04 24             	mov    %eax,(%esp)
  8004a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004af:	e8 2c 26 00 00       	call   802ae0 <__udivdi3>
  8004b4:	89 d9                	mov    %ebx,%ecx
  8004b6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8004ba:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004be:	89 04 24             	mov    %eax,(%esp)
  8004c1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004c5:	89 fa                	mov    %edi,%edx
  8004c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004ca:	e8 71 ff ff ff       	call   800440 <printnum>
  8004cf:	eb 1b                	jmp    8004ec <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8004d1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004d5:	8b 45 18             	mov    0x18(%ebp),%eax
  8004d8:	89 04 24             	mov    %eax,(%esp)
  8004db:	ff d3                	call   *%ebx
  8004dd:	eb 03                	jmp    8004e2 <printnum+0xa2>
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e2:	83 ee 01             	sub    $0x1,%esi
  8004e5:	85 f6                	test   %esi,%esi
  8004e7:	7f e8                	jg     8004d1 <printnum+0x91>
  8004e9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8004ec:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004f0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8004f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8004fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004fe:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800505:	89 04 24             	mov    %eax,(%esp)
  800508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80050b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050f:	e8 fc 26 00 00       	call   802c10 <__umoddi3>
  800514:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800518:	0f be 80 5f 2e 80 00 	movsbl 0x802e5f(%eax),%eax
  80051f:	89 04 24             	mov    %eax,(%esp)
  800522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800525:	ff d0                	call   *%eax
}
  800527:	83 c4 3c             	add    $0x3c,%esp
  80052a:	5b                   	pop    %ebx
  80052b:	5e                   	pop    %esi
  80052c:	5f                   	pop    %edi
  80052d:	5d                   	pop    %ebp
  80052e:	c3                   	ret    

0080052f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800532:	83 fa 01             	cmp    $0x1,%edx
  800535:	7e 0e                	jle    800545 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800537:	8b 10                	mov    (%eax),%edx
  800539:	8d 4a 08             	lea    0x8(%edx),%ecx
  80053c:	89 08                	mov    %ecx,(%eax)
  80053e:	8b 02                	mov    (%edx),%eax
  800540:	8b 52 04             	mov    0x4(%edx),%edx
  800543:	eb 22                	jmp    800567 <getuint+0x38>
	else if (lflag)
  800545:	85 d2                	test   %edx,%edx
  800547:	74 10                	je     800559 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800549:	8b 10                	mov    (%eax),%edx
  80054b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80054e:	89 08                	mov    %ecx,(%eax)
  800550:	8b 02                	mov    (%edx),%eax
  800552:	ba 00 00 00 00       	mov    $0x0,%edx
  800557:	eb 0e                	jmp    800567 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800559:	8b 10                	mov    (%eax),%edx
  80055b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80055e:	89 08                	mov    %ecx,(%eax)
  800560:	8b 02                	mov    (%edx),%eax
  800562:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800567:	5d                   	pop    %ebp
  800568:	c3                   	ret    

00800569 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80056f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800573:	8b 10                	mov    (%eax),%edx
  800575:	3b 50 04             	cmp    0x4(%eax),%edx
  800578:	73 0a                	jae    800584 <sprintputch+0x1b>
		*b->buf++ = ch;
  80057a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80057d:	89 08                	mov    %ecx,(%eax)
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	88 02                	mov    %al,(%edx)
}
  800584:	5d                   	pop    %ebp
  800585:	c3                   	ret    

00800586 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800586:	55                   	push   %ebp
  800587:	89 e5                	mov    %esp,%ebp
  800589:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80058c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80058f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800593:	8b 45 10             	mov    0x10(%ebp),%eax
  800596:	89 44 24 08          	mov    %eax,0x8(%esp)
  80059a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	89 04 24             	mov    %eax,(%esp)
  8005a7:	e8 02 00 00 00       	call   8005ae <vprintfmt>
	va_end(ap);
}
  8005ac:	c9                   	leave  
  8005ad:	c3                   	ret    

008005ae <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005ae:	55                   	push   %ebp
  8005af:	89 e5                	mov    %esp,%ebp
  8005b1:	57                   	push   %edi
  8005b2:	56                   	push   %esi
  8005b3:	53                   	push   %ebx
  8005b4:	83 ec 3c             	sub    $0x3c,%esp
  8005b7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005bd:	eb 14                	jmp    8005d3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8005bf:	85 c0                	test   %eax,%eax
  8005c1:	0f 84 b3 03 00 00    	je     80097a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8005c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005cb:	89 04 24             	mov    %eax,(%esp)
  8005ce:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005d1:	89 f3                	mov    %esi,%ebx
  8005d3:	8d 73 01             	lea    0x1(%ebx),%esi
  8005d6:	0f b6 03             	movzbl (%ebx),%eax
  8005d9:	83 f8 25             	cmp    $0x25,%eax
  8005dc:	75 e1                	jne    8005bf <vprintfmt+0x11>
  8005de:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8005e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005e9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8005f0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8005f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fc:	eb 1d                	jmp    80061b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fe:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800600:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800604:	eb 15                	jmp    80061b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800606:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800608:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80060c:	eb 0d                	jmp    80061b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80060e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800611:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800614:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80061b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80061e:	0f b6 0e             	movzbl (%esi),%ecx
  800621:	0f b6 c1             	movzbl %cl,%eax
  800624:	83 e9 23             	sub    $0x23,%ecx
  800627:	80 f9 55             	cmp    $0x55,%cl
  80062a:	0f 87 2a 03 00 00    	ja     80095a <vprintfmt+0x3ac>
  800630:	0f b6 c9             	movzbl %cl,%ecx
  800633:	ff 24 8d a0 2f 80 00 	jmp    *0x802fa0(,%ecx,4)
  80063a:	89 de                	mov    %ebx,%esi
  80063c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800641:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800644:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800648:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80064b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80064e:	83 fb 09             	cmp    $0x9,%ebx
  800651:	77 36                	ja     800689 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800653:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800656:	eb e9                	jmp    800641 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800658:	8b 45 14             	mov    0x14(%ebp),%eax
  80065b:	8d 48 04             	lea    0x4(%eax),%ecx
  80065e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800661:	8b 00                	mov    (%eax),%eax
  800663:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800666:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800668:	eb 22                	jmp    80068c <vprintfmt+0xde>
  80066a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80066d:	85 c9                	test   %ecx,%ecx
  80066f:	b8 00 00 00 00       	mov    $0x0,%eax
  800674:	0f 49 c1             	cmovns %ecx,%eax
  800677:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067a:	89 de                	mov    %ebx,%esi
  80067c:	eb 9d                	jmp    80061b <vprintfmt+0x6d>
  80067e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800680:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800687:	eb 92                	jmp    80061b <vprintfmt+0x6d>
  800689:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80068c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800690:	79 89                	jns    80061b <vprintfmt+0x6d>
  800692:	e9 77 ff ff ff       	jmp    80060e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800697:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80069a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80069c:	e9 7a ff ff ff       	jmp    80061b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a4:	8d 50 04             	lea    0x4(%eax),%edx
  8006a7:	89 55 14             	mov    %edx,0x14(%ebp)
  8006aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	89 04 24             	mov    %eax,(%esp)
  8006b3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006b6:	e9 18 ff ff ff       	jmp    8005d3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8d 50 04             	lea    0x4(%eax),%edx
  8006c1:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	99                   	cltd   
  8006c7:	31 d0                	xor    %edx,%eax
  8006c9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8006cb:	83 f8 11             	cmp    $0x11,%eax
  8006ce:	7f 0b                	jg     8006db <vprintfmt+0x12d>
  8006d0:	8b 14 85 00 31 80 00 	mov    0x803100(,%eax,4),%edx
  8006d7:	85 d2                	test   %edx,%edx
  8006d9:	75 20                	jne    8006fb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8006db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006df:	c7 44 24 08 77 2e 80 	movl   $0x802e77,0x8(%esp)
  8006e6:	00 
  8006e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	89 04 24             	mov    %eax,(%esp)
  8006f1:	e8 90 fe ff ff       	call   800586 <printfmt>
  8006f6:	e9 d8 fe ff ff       	jmp    8005d3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8006fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006ff:	c7 44 24 08 2d 33 80 	movl   $0x80332d,0x8(%esp)
  800706:	00 
  800707:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	89 04 24             	mov    %eax,(%esp)
  800711:	e8 70 fe ff ff       	call   800586 <printfmt>
  800716:	e9 b8 fe ff ff       	jmp    8005d3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80071e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800721:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8d 50 04             	lea    0x4(%eax),%edx
  80072a:	89 55 14             	mov    %edx,0x14(%ebp)
  80072d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80072f:	85 f6                	test   %esi,%esi
  800731:	b8 70 2e 80 00       	mov    $0x802e70,%eax
  800736:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800739:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80073d:	0f 84 97 00 00 00    	je     8007da <vprintfmt+0x22c>
  800743:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800747:	0f 8e 9b 00 00 00    	jle    8007e8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80074d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800751:	89 34 24             	mov    %esi,(%esp)
  800754:	e8 cf 02 00 00       	call   800a28 <strnlen>
  800759:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80075c:	29 c2                	sub    %eax,%edx
  80075e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800761:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800765:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800768:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80076b:	8b 75 08             	mov    0x8(%ebp),%esi
  80076e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800771:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800773:	eb 0f                	jmp    800784 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800775:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800779:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80077c:	89 04 24             	mov    %eax,(%esp)
  80077f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800781:	83 eb 01             	sub    $0x1,%ebx
  800784:	85 db                	test   %ebx,%ebx
  800786:	7f ed                	jg     800775 <vprintfmt+0x1c7>
  800788:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80078b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80078e:	85 d2                	test   %edx,%edx
  800790:	b8 00 00 00 00       	mov    $0x0,%eax
  800795:	0f 49 c2             	cmovns %edx,%eax
  800798:	29 c2                	sub    %eax,%edx
  80079a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80079d:	89 d7                	mov    %edx,%edi
  80079f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007a2:	eb 50                	jmp    8007f4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007a8:	74 1e                	je     8007c8 <vprintfmt+0x21a>
  8007aa:	0f be d2             	movsbl %dl,%edx
  8007ad:	83 ea 20             	sub    $0x20,%edx
  8007b0:	83 fa 5e             	cmp    $0x5e,%edx
  8007b3:	76 13                	jbe    8007c8 <vprintfmt+0x21a>
					putch('?', putdat);
  8007b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007bc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007c3:	ff 55 08             	call   *0x8(%ebp)
  8007c6:	eb 0d                	jmp    8007d5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8007c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007cf:	89 04 24             	mov    %eax,(%esp)
  8007d2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007d5:	83 ef 01             	sub    $0x1,%edi
  8007d8:	eb 1a                	jmp    8007f4 <vprintfmt+0x246>
  8007da:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007dd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8007e0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007e3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007e6:	eb 0c                	jmp    8007f4 <vprintfmt+0x246>
  8007e8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007eb:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8007ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007f1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007f4:	83 c6 01             	add    $0x1,%esi
  8007f7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8007fb:	0f be c2             	movsbl %dl,%eax
  8007fe:	85 c0                	test   %eax,%eax
  800800:	74 27                	je     800829 <vprintfmt+0x27b>
  800802:	85 db                	test   %ebx,%ebx
  800804:	78 9e                	js     8007a4 <vprintfmt+0x1f6>
  800806:	83 eb 01             	sub    $0x1,%ebx
  800809:	79 99                	jns    8007a4 <vprintfmt+0x1f6>
  80080b:	89 f8                	mov    %edi,%eax
  80080d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800810:	8b 75 08             	mov    0x8(%ebp),%esi
  800813:	89 c3                	mov    %eax,%ebx
  800815:	eb 1a                	jmp    800831 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800817:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80081b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800822:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800824:	83 eb 01             	sub    $0x1,%ebx
  800827:	eb 08                	jmp    800831 <vprintfmt+0x283>
  800829:	89 fb                	mov    %edi,%ebx
  80082b:	8b 75 08             	mov    0x8(%ebp),%esi
  80082e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800831:	85 db                	test   %ebx,%ebx
  800833:	7f e2                	jg     800817 <vprintfmt+0x269>
  800835:	89 75 08             	mov    %esi,0x8(%ebp)
  800838:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80083b:	e9 93 fd ff ff       	jmp    8005d3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800840:	83 fa 01             	cmp    $0x1,%edx
  800843:	7e 16                	jle    80085b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800845:	8b 45 14             	mov    0x14(%ebp),%eax
  800848:	8d 50 08             	lea    0x8(%eax),%edx
  80084b:	89 55 14             	mov    %edx,0x14(%ebp)
  80084e:	8b 50 04             	mov    0x4(%eax),%edx
  800851:	8b 00                	mov    (%eax),%eax
  800853:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800856:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800859:	eb 32                	jmp    80088d <vprintfmt+0x2df>
	else if (lflag)
  80085b:	85 d2                	test   %edx,%edx
  80085d:	74 18                	je     800877 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80085f:	8b 45 14             	mov    0x14(%ebp),%eax
  800862:	8d 50 04             	lea    0x4(%eax),%edx
  800865:	89 55 14             	mov    %edx,0x14(%ebp)
  800868:	8b 30                	mov    (%eax),%esi
  80086a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80086d:	89 f0                	mov    %esi,%eax
  80086f:	c1 f8 1f             	sar    $0x1f,%eax
  800872:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800875:	eb 16                	jmp    80088d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	8d 50 04             	lea    0x4(%eax),%edx
  80087d:	89 55 14             	mov    %edx,0x14(%ebp)
  800880:	8b 30                	mov    (%eax),%esi
  800882:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800885:	89 f0                	mov    %esi,%eax
  800887:	c1 f8 1f             	sar    $0x1f,%eax
  80088a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800890:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800893:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800898:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089c:	0f 89 80 00 00 00    	jns    800922 <vprintfmt+0x374>
				putch('-', putdat);
  8008a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008a6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008ad:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8008b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8008b6:	f7 d8                	neg    %eax
  8008b8:	83 d2 00             	adc    $0x0,%edx
  8008bb:	f7 da                	neg    %edx
			}
			base = 10;
  8008bd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8008c2:	eb 5e                	jmp    800922 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008c4:	8d 45 14             	lea    0x14(%ebp),%eax
  8008c7:	e8 63 fc ff ff       	call   80052f <getuint>
			base = 10;
  8008cc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8008d1:	eb 4f                	jmp    800922 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  8008d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8008d6:	e8 54 fc ff ff       	call   80052f <getuint>
			base = 8;
  8008db:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8008e0:	eb 40                	jmp    800922 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  8008e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008e6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8008ed:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8008f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008f4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8008fb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8008fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800901:	8d 50 04             	lea    0x4(%eax),%edx
  800904:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800907:	8b 00                	mov    (%eax),%eax
  800909:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80090e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800913:	eb 0d                	jmp    800922 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800915:	8d 45 14             	lea    0x14(%ebp),%eax
  800918:	e8 12 fc ff ff       	call   80052f <getuint>
			base = 16;
  80091d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800922:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800926:	89 74 24 10          	mov    %esi,0x10(%esp)
  80092a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80092d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800931:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800935:	89 04 24             	mov    %eax,(%esp)
  800938:	89 54 24 04          	mov    %edx,0x4(%esp)
  80093c:	89 fa                	mov    %edi,%edx
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	e8 fa fa ff ff       	call   800440 <printnum>
			break;
  800946:	e9 88 fc ff ff       	jmp    8005d3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80094b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80094f:	89 04 24             	mov    %eax,(%esp)
  800952:	ff 55 08             	call   *0x8(%ebp)
			break;
  800955:	e9 79 fc ff ff       	jmp    8005d3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80095a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80095e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800965:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800968:	89 f3                	mov    %esi,%ebx
  80096a:	eb 03                	jmp    80096f <vprintfmt+0x3c1>
  80096c:	83 eb 01             	sub    $0x1,%ebx
  80096f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800973:	75 f7                	jne    80096c <vprintfmt+0x3be>
  800975:	e9 59 fc ff ff       	jmp    8005d3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80097a:	83 c4 3c             	add    $0x3c,%esp
  80097d:	5b                   	pop    %ebx
  80097e:	5e                   	pop    %esi
  80097f:	5f                   	pop    %edi
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	83 ec 28             	sub    $0x28,%esp
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80098e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800991:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800995:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800998:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099f:	85 c0                	test   %eax,%eax
  8009a1:	74 30                	je     8009d3 <vsnprintf+0x51>
  8009a3:	85 d2                	test   %edx,%edx
  8009a5:	7e 2c                	jle    8009d3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009bc:	c7 04 24 69 05 80 00 	movl   $0x800569,(%esp)
  8009c3:	e8 e6 fb ff ff       	call   8005ae <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8009c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009cb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d1:	eb 05                	jmp    8009d8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8009d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009e0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8009e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	89 04 24             	mov    %eax,(%esp)
  8009fb:	e8 82 ff ff ff       	call   800982 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a00:	c9                   	leave  
  800a01:	c3                   	ret    
  800a02:	66 90                	xchg   %ax,%ax
  800a04:	66 90                	xchg   %ax,%ax
  800a06:	66 90                	xchg   %ax,%ax
  800a08:	66 90                	xchg   %ax,%ax
  800a0a:	66 90                	xchg   %ax,%ax
  800a0c:	66 90                	xchg   %ax,%ax
  800a0e:	66 90                	xchg   %ax,%ax

00800a10 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a16:	b8 00 00 00 00       	mov    $0x0,%eax
  800a1b:	eb 03                	jmp    800a20 <strlen+0x10>
		n++;
  800a1d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a20:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a24:	75 f7                	jne    800a1d <strlen+0xd>
		n++;
	return n;
}
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a31:	b8 00 00 00 00       	mov    $0x0,%eax
  800a36:	eb 03                	jmp    800a3b <strnlen+0x13>
		n++;
  800a38:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a3b:	39 d0                	cmp    %edx,%eax
  800a3d:	74 06                	je     800a45 <strnlen+0x1d>
  800a3f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a43:	75 f3                	jne    800a38 <strnlen+0x10>
		n++;
	return n;
}
  800a45:	5d                   	pop    %ebp
  800a46:	c3                   	ret    

00800a47 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a47:	55                   	push   %ebp
  800a48:	89 e5                	mov    %esp,%ebp
  800a4a:	53                   	push   %ebx
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a51:	89 c2                	mov    %eax,%edx
  800a53:	83 c2 01             	add    $0x1,%edx
  800a56:	83 c1 01             	add    $0x1,%ecx
  800a59:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800a5d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a60:	84 db                	test   %bl,%bl
  800a62:	75 ef                	jne    800a53 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800a64:	5b                   	pop    %ebx
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
  800a6a:	53                   	push   %ebx
  800a6b:	83 ec 08             	sub    $0x8,%esp
  800a6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a71:	89 1c 24             	mov    %ebx,(%esp)
  800a74:	e8 97 ff ff ff       	call   800a10 <strlen>
	strcpy(dst + len, src);
  800a79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a7c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a80:	01 d8                	add    %ebx,%eax
  800a82:	89 04 24             	mov    %eax,(%esp)
  800a85:	e8 bd ff ff ff       	call   800a47 <strcpy>
	return dst;
}
  800a8a:	89 d8                	mov    %ebx,%eax
  800a8c:	83 c4 08             	add    $0x8,%esp
  800a8f:	5b                   	pop    %ebx
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	56                   	push   %esi
  800a96:	53                   	push   %ebx
  800a97:	8b 75 08             	mov    0x8(%ebp),%esi
  800a9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a9d:	89 f3                	mov    %esi,%ebx
  800a9f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aa2:	89 f2                	mov    %esi,%edx
  800aa4:	eb 0f                	jmp    800ab5 <strncpy+0x23>
		*dst++ = *src;
  800aa6:	83 c2 01             	add    $0x1,%edx
  800aa9:	0f b6 01             	movzbl (%ecx),%eax
  800aac:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aaf:	80 39 01             	cmpb   $0x1,(%ecx)
  800ab2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ab5:	39 da                	cmp    %ebx,%edx
  800ab7:	75 ed                	jne    800aa6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800ab9:	89 f0                	mov    %esi,%eax
  800abb:	5b                   	pop    %ebx
  800abc:	5e                   	pop    %esi
  800abd:	5d                   	pop    %ebp
  800abe:	c3                   	ret    

00800abf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800abf:	55                   	push   %ebp
  800ac0:	89 e5                	mov    %esp,%ebp
  800ac2:	56                   	push   %esi
  800ac3:	53                   	push   %ebx
  800ac4:	8b 75 08             	mov    0x8(%ebp),%esi
  800ac7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800acd:	89 f0                	mov    %esi,%eax
  800acf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ad3:	85 c9                	test   %ecx,%ecx
  800ad5:	75 0b                	jne    800ae2 <strlcpy+0x23>
  800ad7:	eb 1d                	jmp    800af6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ad9:	83 c0 01             	add    $0x1,%eax
  800adc:	83 c2 01             	add    $0x1,%edx
  800adf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae2:	39 d8                	cmp    %ebx,%eax
  800ae4:	74 0b                	je     800af1 <strlcpy+0x32>
  800ae6:	0f b6 0a             	movzbl (%edx),%ecx
  800ae9:	84 c9                	test   %cl,%cl
  800aeb:	75 ec                	jne    800ad9 <strlcpy+0x1a>
  800aed:	89 c2                	mov    %eax,%edx
  800aef:	eb 02                	jmp    800af3 <strlcpy+0x34>
  800af1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800af3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800af6:	29 f0                	sub    %esi,%eax
}
  800af8:	5b                   	pop    %ebx
  800af9:	5e                   	pop    %esi
  800afa:	5d                   	pop    %ebp
  800afb:	c3                   	ret    

00800afc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800afc:	55                   	push   %ebp
  800afd:	89 e5                	mov    %esp,%ebp
  800aff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b05:	eb 06                	jmp    800b0d <strcmp+0x11>
		p++, q++;
  800b07:	83 c1 01             	add    $0x1,%ecx
  800b0a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b0d:	0f b6 01             	movzbl (%ecx),%eax
  800b10:	84 c0                	test   %al,%al
  800b12:	74 04                	je     800b18 <strcmp+0x1c>
  800b14:	3a 02                	cmp    (%edx),%al
  800b16:	74 ef                	je     800b07 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b18:	0f b6 c0             	movzbl %al,%eax
  800b1b:	0f b6 12             	movzbl (%edx),%edx
  800b1e:	29 d0                	sub    %edx,%eax
}
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	53                   	push   %ebx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	89 c3                	mov    %eax,%ebx
  800b2e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b31:	eb 06                	jmp    800b39 <strncmp+0x17>
		n--, p++, q++;
  800b33:	83 c0 01             	add    $0x1,%eax
  800b36:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b39:	39 d8                	cmp    %ebx,%eax
  800b3b:	74 15                	je     800b52 <strncmp+0x30>
  800b3d:	0f b6 08             	movzbl (%eax),%ecx
  800b40:	84 c9                	test   %cl,%cl
  800b42:	74 04                	je     800b48 <strncmp+0x26>
  800b44:	3a 0a                	cmp    (%edx),%cl
  800b46:	74 eb                	je     800b33 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b48:	0f b6 00             	movzbl (%eax),%eax
  800b4b:	0f b6 12             	movzbl (%edx),%edx
  800b4e:	29 d0                	sub    %edx,%eax
  800b50:	eb 05                	jmp    800b57 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800b52:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b57:	5b                   	pop    %ebx
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    

00800b5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b64:	eb 07                	jmp    800b6d <strchr+0x13>
		if (*s == c)
  800b66:	38 ca                	cmp    %cl,%dl
  800b68:	74 0f                	je     800b79 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b6a:	83 c0 01             	add    $0x1,%eax
  800b6d:	0f b6 10             	movzbl (%eax),%edx
  800b70:	84 d2                	test   %dl,%dl
  800b72:	75 f2                	jne    800b66 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800b74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b85:	eb 07                	jmp    800b8e <strfind+0x13>
		if (*s == c)
  800b87:	38 ca                	cmp    %cl,%dl
  800b89:	74 0a                	je     800b95 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b8b:	83 c0 01             	add    $0x1,%eax
  800b8e:	0f b6 10             	movzbl (%eax),%edx
  800b91:	84 d2                	test   %dl,%dl
  800b93:	75 f2                	jne    800b87 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    

00800b97 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	57                   	push   %edi
  800b9b:	56                   	push   %esi
  800b9c:	53                   	push   %ebx
  800b9d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ba0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ba3:	85 c9                	test   %ecx,%ecx
  800ba5:	74 36                	je     800bdd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ba7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bad:	75 28                	jne    800bd7 <memset+0x40>
  800baf:	f6 c1 03             	test   $0x3,%cl
  800bb2:	75 23                	jne    800bd7 <memset+0x40>
		c &= 0xFF;
  800bb4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb8:	89 d3                	mov    %edx,%ebx
  800bba:	c1 e3 08             	shl    $0x8,%ebx
  800bbd:	89 d6                	mov    %edx,%esi
  800bbf:	c1 e6 18             	shl    $0x18,%esi
  800bc2:	89 d0                	mov    %edx,%eax
  800bc4:	c1 e0 10             	shl    $0x10,%eax
  800bc7:	09 f0                	or     %esi,%eax
  800bc9:	09 c2                	or     %eax,%edx
  800bcb:	89 d0                	mov    %edx,%eax
  800bcd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800bcf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800bd2:	fc                   	cld    
  800bd3:	f3 ab                	rep stos %eax,%es:(%edi)
  800bd5:	eb 06                	jmp    800bdd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bda:	fc                   	cld    
  800bdb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bdd:	89 f8                	mov    %edi,%eax
  800bdf:	5b                   	pop    %ebx
  800be0:	5e                   	pop    %esi
  800be1:	5f                   	pop    %edi
  800be2:	5d                   	pop    %ebp
  800be3:	c3                   	ret    

00800be4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be4:	55                   	push   %ebp
  800be5:	89 e5                	mov    %esp,%ebp
  800be7:	57                   	push   %edi
  800be8:	56                   	push   %esi
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bef:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bf2:	39 c6                	cmp    %eax,%esi
  800bf4:	73 35                	jae    800c2b <memmove+0x47>
  800bf6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bf9:	39 d0                	cmp    %edx,%eax
  800bfb:	73 2e                	jae    800c2b <memmove+0x47>
		s += n;
		d += n;
  800bfd:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c00:	89 d6                	mov    %edx,%esi
  800c02:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c04:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c0a:	75 13                	jne    800c1f <memmove+0x3b>
  800c0c:	f6 c1 03             	test   $0x3,%cl
  800c0f:	75 0e                	jne    800c1f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c11:	83 ef 04             	sub    $0x4,%edi
  800c14:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c17:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c1a:	fd                   	std    
  800c1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c1d:	eb 09                	jmp    800c28 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c1f:	83 ef 01             	sub    $0x1,%edi
  800c22:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c25:	fd                   	std    
  800c26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c28:	fc                   	cld    
  800c29:	eb 1d                	jmp    800c48 <memmove+0x64>
  800c2b:	89 f2                	mov    %esi,%edx
  800c2d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c2f:	f6 c2 03             	test   $0x3,%dl
  800c32:	75 0f                	jne    800c43 <memmove+0x5f>
  800c34:	f6 c1 03             	test   $0x3,%cl
  800c37:	75 0a                	jne    800c43 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c39:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800c3c:	89 c7                	mov    %eax,%edi
  800c3e:	fc                   	cld    
  800c3f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c41:	eb 05                	jmp    800c48 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c43:	89 c7                	mov    %eax,%edi
  800c45:	fc                   	cld    
  800c46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c48:	5e                   	pop    %esi
  800c49:	5f                   	pop    %edi
  800c4a:	5d                   	pop    %ebp
  800c4b:	c3                   	ret    

00800c4c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c4c:	55                   	push   %ebp
  800c4d:	89 e5                	mov    %esp,%ebp
  800c4f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	89 04 24             	mov    %eax,(%esp)
  800c66:	e8 79 ff ff ff       	call   800be4 <memmove>
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	8b 55 08             	mov    0x8(%ebp),%edx
  800c75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c78:	89 d6                	mov    %edx,%esi
  800c7a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c7d:	eb 1a                	jmp    800c99 <memcmp+0x2c>
		if (*s1 != *s2)
  800c7f:	0f b6 02             	movzbl (%edx),%eax
  800c82:	0f b6 19             	movzbl (%ecx),%ebx
  800c85:	38 d8                	cmp    %bl,%al
  800c87:	74 0a                	je     800c93 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800c89:	0f b6 c0             	movzbl %al,%eax
  800c8c:	0f b6 db             	movzbl %bl,%ebx
  800c8f:	29 d8                	sub    %ebx,%eax
  800c91:	eb 0f                	jmp    800ca2 <memcmp+0x35>
		s1++, s2++;
  800c93:	83 c2 01             	add    $0x1,%edx
  800c96:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c99:	39 f2                	cmp    %esi,%edx
  800c9b:	75 e2                	jne    800c7f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ca2:	5b                   	pop    %ebx
  800ca3:	5e                   	pop    %esi
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800caf:	89 c2                	mov    %eax,%edx
  800cb1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb4:	eb 07                	jmp    800cbd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb6:	38 08                	cmp    %cl,(%eax)
  800cb8:	74 07                	je     800cc1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cba:	83 c0 01             	add    $0x1,%eax
  800cbd:	39 d0                	cmp    %edx,%eax
  800cbf:	72 f5                	jb     800cb6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ccf:	eb 03                	jmp    800cd4 <strtol+0x11>
		s++;
  800cd1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd4:	0f b6 0a             	movzbl (%edx),%ecx
  800cd7:	80 f9 09             	cmp    $0x9,%cl
  800cda:	74 f5                	je     800cd1 <strtol+0xe>
  800cdc:	80 f9 20             	cmp    $0x20,%cl
  800cdf:	74 f0                	je     800cd1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ce1:	80 f9 2b             	cmp    $0x2b,%cl
  800ce4:	75 0a                	jne    800cf0 <strtol+0x2d>
		s++;
  800ce6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ce9:	bf 00 00 00 00       	mov    $0x0,%edi
  800cee:	eb 11                	jmp    800d01 <strtol+0x3e>
  800cf0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800cf5:	80 f9 2d             	cmp    $0x2d,%cl
  800cf8:	75 07                	jne    800d01 <strtol+0x3e>
		s++, neg = 1;
  800cfa:	8d 52 01             	lea    0x1(%edx),%edx
  800cfd:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d01:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d06:	75 15                	jne    800d1d <strtol+0x5a>
  800d08:	80 3a 30             	cmpb   $0x30,(%edx)
  800d0b:	75 10                	jne    800d1d <strtol+0x5a>
  800d0d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d11:	75 0a                	jne    800d1d <strtol+0x5a>
		s += 2, base = 16;
  800d13:	83 c2 02             	add    $0x2,%edx
  800d16:	b8 10 00 00 00       	mov    $0x10,%eax
  800d1b:	eb 10                	jmp    800d2d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	75 0c                	jne    800d2d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d21:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d23:	80 3a 30             	cmpb   $0x30,(%edx)
  800d26:	75 05                	jne    800d2d <strtol+0x6a>
		s++, base = 8;
  800d28:	83 c2 01             	add    $0x1,%edx
  800d2b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d32:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d35:	0f b6 0a             	movzbl (%edx),%ecx
  800d38:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800d3b:	89 f0                	mov    %esi,%eax
  800d3d:	3c 09                	cmp    $0x9,%al
  800d3f:	77 08                	ja     800d49 <strtol+0x86>
			dig = *s - '0';
  800d41:	0f be c9             	movsbl %cl,%ecx
  800d44:	83 e9 30             	sub    $0x30,%ecx
  800d47:	eb 20                	jmp    800d69 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800d49:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800d4c:	89 f0                	mov    %esi,%eax
  800d4e:	3c 19                	cmp    $0x19,%al
  800d50:	77 08                	ja     800d5a <strtol+0x97>
			dig = *s - 'a' + 10;
  800d52:	0f be c9             	movsbl %cl,%ecx
  800d55:	83 e9 57             	sub    $0x57,%ecx
  800d58:	eb 0f                	jmp    800d69 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800d5a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800d5d:	89 f0                	mov    %esi,%eax
  800d5f:	3c 19                	cmp    $0x19,%al
  800d61:	77 16                	ja     800d79 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800d63:	0f be c9             	movsbl %cl,%ecx
  800d66:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d69:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800d6c:	7d 0f                	jge    800d7d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800d6e:	83 c2 01             	add    $0x1,%edx
  800d71:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800d75:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800d77:	eb bc                	jmp    800d35 <strtol+0x72>
  800d79:	89 d8                	mov    %ebx,%eax
  800d7b:	eb 02                	jmp    800d7f <strtol+0xbc>
  800d7d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800d7f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d83:	74 05                	je     800d8a <strtol+0xc7>
		*endptr = (char *) s;
  800d85:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d88:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d8a:	f7 d8                	neg    %eax
  800d8c:	85 ff                	test   %edi,%edi
  800d8e:	0f 44 c3             	cmove  %ebx,%eax
}
  800d91:	5b                   	pop    %ebx
  800d92:	5e                   	pop    %esi
  800d93:	5f                   	pop    %edi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	57                   	push   %edi
  800d9a:	56                   	push   %esi
  800d9b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800da1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	89 c3                	mov    %eax,%ebx
  800da9:	89 c7                	mov    %eax,%edi
  800dab:	89 c6                	mov    %eax,%esi
  800dad:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800daf:	5b                   	pop    %ebx
  800db0:	5e                   	pop    %esi
  800db1:	5f                   	pop    %edi
  800db2:	5d                   	pop    %ebp
  800db3:	c3                   	ret    

00800db4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	57                   	push   %edi
  800db8:	56                   	push   %esi
  800db9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dba:	ba 00 00 00 00       	mov    $0x0,%edx
  800dbf:	b8 01 00 00 00       	mov    $0x1,%eax
  800dc4:	89 d1                	mov    %edx,%ecx
  800dc6:	89 d3                	mov    %edx,%ebx
  800dc8:	89 d7                	mov    %edx,%edi
  800dca:	89 d6                	mov    %edx,%esi
  800dcc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dce:	5b                   	pop    %ebx
  800dcf:	5e                   	pop    %esi
  800dd0:	5f                   	pop    %edi
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	57                   	push   %edi
  800dd7:	56                   	push   %esi
  800dd8:	53                   	push   %ebx
  800dd9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ddc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800de1:	b8 03 00 00 00       	mov    $0x3,%eax
  800de6:	8b 55 08             	mov    0x8(%ebp),%edx
  800de9:	89 cb                	mov    %ecx,%ebx
  800deb:	89 cf                	mov    %ecx,%edi
  800ded:	89 ce                	mov    %ecx,%esi
  800def:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800df1:	85 c0                	test   %eax,%eax
  800df3:	7e 28                	jle    800e1d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e00:	00 
  800e01:	c7 44 24 08 67 31 80 	movl   $0x803167,0x8(%esp)
  800e08:	00 
  800e09:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e10:	00 
  800e11:	c7 04 24 84 31 80 00 	movl   $0x803184,(%esp)
  800e18:	e8 01 f5 ff ff       	call   80031e <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e1d:	83 c4 2c             	add    $0x2c,%esp
  800e20:	5b                   	pop    %ebx
  800e21:	5e                   	pop    %esi
  800e22:	5f                   	pop    %edi
  800e23:	5d                   	pop    %ebp
  800e24:	c3                   	ret    

00800e25 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	57                   	push   %edi
  800e29:	56                   	push   %esi
  800e2a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e30:	b8 02 00 00 00       	mov    $0x2,%eax
  800e35:	89 d1                	mov    %edx,%ecx
  800e37:	89 d3                	mov    %edx,%ebx
  800e39:	89 d7                	mov    %edx,%edi
  800e3b:	89 d6                	mov    %edx,%esi
  800e3d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e3f:	5b                   	pop    %ebx
  800e40:	5e                   	pop    %esi
  800e41:	5f                   	pop    %edi
  800e42:	5d                   	pop    %ebp
  800e43:	c3                   	ret    

00800e44 <sys_yield>:

void
sys_yield(void)
{
  800e44:	55                   	push   %ebp
  800e45:	89 e5                	mov    %esp,%ebp
  800e47:	57                   	push   %edi
  800e48:	56                   	push   %esi
  800e49:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e4f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e54:	89 d1                	mov    %edx,%ecx
  800e56:	89 d3                	mov    %edx,%ebx
  800e58:	89 d7                	mov    %edx,%edi
  800e5a:	89 d6                	mov    %edx,%esi
  800e5c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
  800e69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6c:	be 00 00 00 00       	mov    $0x0,%esi
  800e71:	b8 04 00 00 00       	mov    $0x4,%eax
  800e76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e79:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7f:	89 f7                	mov    %esi,%edi
  800e81:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e83:	85 c0                	test   %eax,%eax
  800e85:	7e 28                	jle    800eaf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e87:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e8b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e92:	00 
  800e93:	c7 44 24 08 67 31 80 	movl   $0x803167,0x8(%esp)
  800e9a:	00 
  800e9b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea2:	00 
  800ea3:	c7 04 24 84 31 80 00 	movl   $0x803184,(%esp)
  800eaa:	e8 6f f4 ff ff       	call   80031e <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800eaf:	83 c4 2c             	add    $0x2c,%esp
  800eb2:	5b                   	pop    %ebx
  800eb3:	5e                   	pop    %esi
  800eb4:	5f                   	pop    %edi
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    

00800eb7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	57                   	push   %edi
  800ebb:	56                   	push   %esi
  800ebc:	53                   	push   %ebx
  800ebd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec0:	b8 05 00 00 00       	mov    $0x5,%eax
  800ec5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ece:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed1:	8b 75 18             	mov    0x18(%ebp),%esi
  800ed4:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	7e 28                	jle    800f02 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eda:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ede:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800ee5:	00 
  800ee6:	c7 44 24 08 67 31 80 	movl   $0x803167,0x8(%esp)
  800eed:	00 
  800eee:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef5:	00 
  800ef6:	c7 04 24 84 31 80 00 	movl   $0x803184,(%esp)
  800efd:	e8 1c f4 ff ff       	call   80031e <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f02:	83 c4 2c             	add    $0x2c,%esp
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	57                   	push   %edi
  800f0e:	56                   	push   %esi
  800f0f:	53                   	push   %ebx
  800f10:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f13:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f18:	b8 06 00 00 00       	mov    $0x6,%eax
  800f1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	89 df                	mov    %ebx,%edi
  800f25:	89 de                	mov    %ebx,%esi
  800f27:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	7e 28                	jle    800f55 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f31:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f38:	00 
  800f39:	c7 44 24 08 67 31 80 	movl   $0x803167,0x8(%esp)
  800f40:	00 
  800f41:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f48:	00 
  800f49:	c7 04 24 84 31 80 00 	movl   $0x803184,(%esp)
  800f50:	e8 c9 f3 ff ff       	call   80031e <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f55:	83 c4 2c             	add    $0x2c,%esp
  800f58:	5b                   	pop    %ebx
  800f59:	5e                   	pop    %esi
  800f5a:	5f                   	pop    %edi
  800f5b:	5d                   	pop    %ebp
  800f5c:	c3                   	ret    

00800f5d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f5d:	55                   	push   %ebp
  800f5e:	89 e5                	mov    %esp,%ebp
  800f60:	57                   	push   %edi
  800f61:	56                   	push   %esi
  800f62:	53                   	push   %ebx
  800f63:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6b:	b8 08 00 00 00       	mov    $0x8,%eax
  800f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f73:	8b 55 08             	mov    0x8(%ebp),%edx
  800f76:	89 df                	mov    %ebx,%edi
  800f78:	89 de                	mov    %ebx,%esi
  800f7a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f7c:	85 c0                	test   %eax,%eax
  800f7e:	7e 28                	jle    800fa8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f80:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f84:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f8b:	00 
  800f8c:	c7 44 24 08 67 31 80 	movl   $0x803167,0x8(%esp)
  800f93:	00 
  800f94:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f9b:	00 
  800f9c:	c7 04 24 84 31 80 00 	movl   $0x803184,(%esp)
  800fa3:	e8 76 f3 ff ff       	call   80031e <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fa8:	83 c4 2c             	add    $0x2c,%esp
  800fab:	5b                   	pop    %ebx
  800fac:	5e                   	pop    %esi
  800fad:	5f                   	pop    %edi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	57                   	push   %edi
  800fb4:	56                   	push   %esi
  800fb5:	53                   	push   %ebx
  800fb6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbe:	b8 09 00 00 00       	mov    $0x9,%eax
  800fc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc9:	89 df                	mov    %ebx,%edi
  800fcb:	89 de                	mov    %ebx,%esi
  800fcd:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800fcf:	85 c0                	test   %eax,%eax
  800fd1:	7e 28                	jle    800ffb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800fde:	00 
  800fdf:	c7 44 24 08 67 31 80 	movl   $0x803167,0x8(%esp)
  800fe6:	00 
  800fe7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fee:	00 
  800fef:	c7 04 24 84 31 80 00 	movl   $0x803184,(%esp)
  800ff6:	e8 23 f3 ff ff       	call   80031e <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ffb:	83 c4 2c             	add    $0x2c,%esp
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	57                   	push   %edi
  801007:	56                   	push   %esi
  801008:	53                   	push   %ebx
  801009:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801011:	b8 0a 00 00 00       	mov    $0xa,%eax
  801016:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801019:	8b 55 08             	mov    0x8(%ebp),%edx
  80101c:	89 df                	mov    %ebx,%edi
  80101e:	89 de                	mov    %ebx,%esi
  801020:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801022:	85 c0                	test   %eax,%eax
  801024:	7e 28                	jle    80104e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801026:	89 44 24 10          	mov    %eax,0x10(%esp)
  80102a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801031:	00 
  801032:	c7 44 24 08 67 31 80 	movl   $0x803167,0x8(%esp)
  801039:	00 
  80103a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801041:	00 
  801042:	c7 04 24 84 31 80 00 	movl   $0x803184,(%esp)
  801049:	e8 d0 f2 ff ff       	call   80031e <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80104e:	83 c4 2c             	add    $0x2c,%esp
  801051:	5b                   	pop    %ebx
  801052:	5e                   	pop    %esi
  801053:	5f                   	pop    %edi
  801054:	5d                   	pop    %ebp
  801055:	c3                   	ret    

00801056 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	57                   	push   %edi
  80105a:	56                   	push   %esi
  80105b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105c:	be 00 00 00 00       	mov    $0x0,%esi
  801061:	b8 0c 00 00 00       	mov    $0xc,%eax
  801066:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801069:	8b 55 08             	mov    0x8(%ebp),%edx
  80106c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80106f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801072:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801074:	5b                   	pop    %ebx
  801075:	5e                   	pop    %esi
  801076:	5f                   	pop    %edi
  801077:	5d                   	pop    %ebp
  801078:	c3                   	ret    

00801079 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801079:	55                   	push   %ebp
  80107a:	89 e5                	mov    %esp,%ebp
  80107c:	57                   	push   %edi
  80107d:	56                   	push   %esi
  80107e:	53                   	push   %ebx
  80107f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801082:	b9 00 00 00 00       	mov    $0x0,%ecx
  801087:	b8 0d 00 00 00       	mov    $0xd,%eax
  80108c:	8b 55 08             	mov    0x8(%ebp),%edx
  80108f:	89 cb                	mov    %ecx,%ebx
  801091:	89 cf                	mov    %ecx,%edi
  801093:	89 ce                	mov    %ecx,%esi
  801095:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801097:	85 c0                	test   %eax,%eax
  801099:	7e 28                	jle    8010c3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80109b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80109f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8010a6:	00 
  8010a7:	c7 44 24 08 67 31 80 	movl   $0x803167,0x8(%esp)
  8010ae:	00 
  8010af:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b6:	00 
  8010b7:	c7 04 24 84 31 80 00 	movl   $0x803184,(%esp)
  8010be:	e8 5b f2 ff ff       	call   80031e <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010c3:	83 c4 2c             	add    $0x2c,%esp
  8010c6:	5b                   	pop    %ebx
  8010c7:	5e                   	pop    %esi
  8010c8:	5f                   	pop    %edi
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	57                   	push   %edi
  8010cf:	56                   	push   %esi
  8010d0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010db:	89 d1                	mov    %edx,%ecx
  8010dd:	89 d3                	mov    %edx,%ebx
  8010df:	89 d7                	mov    %edx,%edi
  8010e1:	89 d6                	mov    %edx,%esi
  8010e3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010e5:	5b                   	pop    %ebx
  8010e6:	5e                   	pop    %esi
  8010e7:	5f                   	pop    %edi
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    

008010ea <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  8010ea:	55                   	push   %ebp
  8010eb:	89 e5                	mov    %esp,%ebp
  8010ed:	57                   	push   %edi
  8010ee:	56                   	push   %esi
  8010ef:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f5:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801100:	89 df                	mov    %ebx,%edi
  801102:	89 de                	mov    %ebx,%esi
  801104:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  801106:	5b                   	pop    %ebx
  801107:	5e                   	pop    %esi
  801108:	5f                   	pop    %edi
  801109:	5d                   	pop    %ebp
  80110a:	c3                   	ret    

0080110b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	57                   	push   %edi
  80110f:	56                   	push   %esi
  801110:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801111:	bb 00 00 00 00       	mov    $0x0,%ebx
  801116:	b8 10 00 00 00       	mov    $0x10,%eax
  80111b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111e:	8b 55 08             	mov    0x8(%ebp),%edx
  801121:	89 df                	mov    %ebx,%edi
  801123:	89 de                	mov    %ebx,%esi
  801125:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  801127:	5b                   	pop    %ebx
  801128:	5e                   	pop    %esi
  801129:	5f                   	pop    %edi
  80112a:	5d                   	pop    %ebp
  80112b:	c3                   	ret    

0080112c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	57                   	push   %edi
  801130:	56                   	push   %esi
  801131:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801132:	b9 00 00 00 00       	mov    $0x0,%ecx
  801137:	b8 11 00 00 00       	mov    $0x11,%eax
  80113c:	8b 55 08             	mov    0x8(%ebp),%edx
  80113f:	89 cb                	mov    %ecx,%ebx
  801141:	89 cf                	mov    %ecx,%edi
  801143:	89 ce                	mov    %ecx,%esi
  801145:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801147:	5b                   	pop    %ebx
  801148:	5e                   	pop    %esi
  801149:	5f                   	pop    %edi
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    

0080114c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	57                   	push   %edi
  801150:	56                   	push   %esi
  801151:	53                   	push   %ebx
  801152:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801155:	be 00 00 00 00       	mov    $0x0,%esi
  80115a:	b8 12 00 00 00       	mov    $0x12,%eax
  80115f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801162:	8b 55 08             	mov    0x8(%ebp),%edx
  801165:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801168:	8b 7d 14             	mov    0x14(%ebp),%edi
  80116b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80116d:	85 c0                	test   %eax,%eax
  80116f:	7e 28                	jle    801199 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801171:	89 44 24 10          	mov    %eax,0x10(%esp)
  801175:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80117c:	00 
  80117d:	c7 44 24 08 67 31 80 	movl   $0x803167,0x8(%esp)
  801184:	00 
  801185:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80118c:	00 
  80118d:	c7 04 24 84 31 80 00 	movl   $0x803184,(%esp)
  801194:	e8 85 f1 ff ff       	call   80031e <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801199:	83 c4 2c             	add    $0x2c,%esp
  80119c:	5b                   	pop    %ebx
  80119d:	5e                   	pop    %esi
  80119e:	5f                   	pop    %edi
  80119f:	5d                   	pop    %ebp
  8011a0:	c3                   	ret    

008011a1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	53                   	push   %ebx
  8011a5:	83 ec 24             	sub    $0x24,%esp
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8011ab:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0)
  8011ad:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8011b1:	75 20                	jne    8011d3 <pgfault+0x32>
		panic("pgfault: faulting address [%08x] not a write\n", addr);
  8011b3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011b7:	c7 44 24 08 94 31 80 	movl   $0x803194,0x8(%esp)
  8011be:	00 
  8011bf:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8011c6:	00 
  8011c7:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  8011ce:	e8 4b f1 ff ff       	call   80031e <_panic>

	void *page_aligned_addr = (void *) ROUNDDOWN(addr, PGSIZE);
  8011d3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t page_num = (uint32_t) page_aligned_addr / PGSIZE;
  8011d9:	89 d8                	mov    %ebx,%eax
  8011db:	c1 e8 0c             	shr    $0xc,%eax
	if (!(uvpt[page_num] & PTE_COW))
  8011de:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011e5:	f6 c4 08             	test   $0x8,%ah
  8011e8:	75 1c                	jne    801206 <pgfault+0x65>
		panic("pgfault: fault was not on a copy-on-write page\n");
  8011ea:	c7 44 24 08 c4 31 80 	movl   $0x8031c4,0x8(%esp)
  8011f1:	00 
  8011f2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011f9:	00 
  8011fa:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  801201:	e8 18 f1 ff ff       	call   80031e <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	// Allocate
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801206:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80120d:	00 
  80120e:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801215:	00 
  801216:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80121d:	e8 41 fc ff ff       	call   800e63 <sys_page_alloc>
  801222:	85 c0                	test   %eax,%eax
  801224:	79 20                	jns    801246 <pgfault+0xa5>
		panic("sys_page_alloc: %e\n", r);
  801226:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80122a:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  801231:	00 
  801232:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  801239:	00 
  80123a:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  801241:	e8 d8 f0 ff ff       	call   80031e <_panic>

	// Copy over
	void *src_addr = (void *) ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, src_addr, PGSIZE);
  801246:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80124d:	00 
  80124e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801252:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801259:	e8 86 f9 ff ff       	call   800be4 <memmove>

	// Remap
	if ((r = sys_page_map(0, PFTEMP, 0, src_addr, PTE_P | PTE_U | PTE_W)) < 0)
  80125e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801265:	00 
  801266:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80126a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801271:	00 
  801272:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801279:	00 
  80127a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801281:	e8 31 fc ff ff       	call   800eb7 <sys_page_map>
  801286:	85 c0                	test   %eax,%eax
  801288:	79 20                	jns    8012aa <pgfault+0x109>
		panic("sys_page_map: %e\n", r);
  80128a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80128e:	c7 44 24 08 33 32 80 	movl   $0x803233,0x8(%esp)
  801295:	00 
  801296:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  80129d:	00 
  80129e:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  8012a5:	e8 74 f0 ff ff       	call   80031e <_panic>

	//panic("pgfault not implemented");
}
  8012aa:	83 c4 24             	add    $0x24,%esp
  8012ad:	5b                   	pop    %ebx
  8012ae:	5d                   	pop    %ebp
  8012af:	c3                   	ret    

008012b0 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	57                   	push   %edi
  8012b4:	56                   	push   %esi
  8012b5:	53                   	push   %ebx
  8012b6:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	int r;
	envid_t child_envid;

	set_pgfault_handler(pgfault);
  8012b9:	c7 04 24 a1 11 80 00 	movl   $0x8011a1,(%esp)
  8012c0:	e8 01 16 00 00       	call   8028c6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8012c5:	b8 07 00 00 00       	mov    $0x7,%eax
  8012ca:	cd 30                	int    $0x30
  8012cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8012cf:	89 45 e0             	mov    %eax,-0x20(%ebp)

	child_envid = sys_exofork();
	if (child_envid < 0)
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	79 20                	jns    8012f6 <fork+0x46>
		panic("sys_exofork: %e\n", child_envid);
  8012d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012da:	c7 44 24 08 45 32 80 	movl   $0x803245,0x8(%esp)
  8012e1:	00 
  8012e2:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  8012e9:	00 
  8012ea:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  8012f1:	e8 28 f0 ff ff       	call   80031e <_panic>
	if (child_envid == 0) { // child
  8012f6:	bf 00 00 00 00       	mov    $0x0,%edi
  8012fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801300:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801304:	75 21                	jne    801327 <fork+0x77>
		// Fix thisenv like dumbfork does and return 0
		thisenv = &envs[ENVX(sys_getenvid())];
  801306:	e8 1a fb ff ff       	call   800e25 <sys_getenvid>
  80130b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801310:	c1 e0 07             	shl    $0x7,%eax
  801313:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801318:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80131d:	b8 00 00 00 00       	mov    $0x0,%eax
  801322:	e9 53 02 00 00       	jmp    80157a <fork+0x2ca>
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
  801327:	89 d8                	mov    %ebx,%eax
  801329:	c1 e8 0a             	shr    $0xa,%eax
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  80132c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801333:	a8 01                	test   $0x1,%al
  801335:	0f 84 7a 01 00 00    	je     8014b5 <fork+0x205>
			((uvpt[page_num] & PTE_P) == PTE_P)) {
  80133b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  801342:	a8 01                	test   $0x1,%al
  801344:	0f 84 6b 01 00 00    	je     8014b5 <fork+0x205>
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
	envid_t this_envid = thisenv->env_id;
  80134a:	a1 08 50 80 00       	mov    0x805008,%eax
  80134f:	8b 40 48             	mov    0x48(%eax),%eax
  801352:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 4: Your code here.
	if (uvpt[pn] & PTE_SHARE) {
  801355:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80135c:	f6 c4 04             	test   $0x4,%ah
  80135f:	74 52                	je     8013b3 <fork+0x103>
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801361:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801368:	25 07 0e 00 00       	and    $0xe07,%eax
  80136d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801371:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801375:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801378:	89 44 24 08          	mov    %eax,0x8(%esp)
  80137c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801380:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801383:	89 04 24             	mov    %eax,(%esp)
  801386:	e8 2c fb ff ff       	call   800eb7 <sys_page_map>
  80138b:	85 c0                	test   %eax,%eax
  80138d:	0f 89 22 01 00 00    	jns    8014b5 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801393:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801397:	c7 44 24 08 33 32 80 	movl   $0x803233,0x8(%esp)
  80139e:	00 
  80139f:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  8013a6:	00 
  8013a7:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  8013ae:	e8 6b ef ff ff       	call   80031e <_panic>
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
  8013b3:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8013ba:	f6 c4 08             	test   $0x8,%ah
  8013bd:	75 0f                	jne    8013ce <fork+0x11e>
  8013bf:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8013c6:	a8 02                	test   $0x2,%al
  8013c8:	0f 84 99 00 00 00    	je     801467 <fork+0x1b7>
		if (uvpt[pn] & PTE_U)
  8013ce:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8013d5:	83 e0 04             	and    $0x4,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
  8013d8:	83 f8 01             	cmp    $0x1,%eax
  8013db:	19 f6                	sbb    %esi,%esi
  8013dd:	83 e6 fc             	and    $0xfffffffc,%esi
  8013e0:	81 c6 05 08 00 00    	add    $0x805,%esi
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
		if (uvpt[pn] & PTE_U)
			perm |= PTE_U;

		// Map page COW, U and P in child
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), perm)) < 0)
  8013e6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8013ea:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013fc:	89 04 24             	mov    %eax,(%esp)
  8013ff:	e8 b3 fa ff ff       	call   800eb7 <sys_page_map>
  801404:	85 c0                	test   %eax,%eax
  801406:	79 20                	jns    801428 <fork+0x178>
			panic("sys_page_map: %e\n", r);
  801408:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80140c:	c7 44 24 08 33 32 80 	movl   $0x803233,0x8(%esp)
  801413:	00 
  801414:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80141b:	00 
  80141c:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  801423:	e8 f6 ee ff ff       	call   80031e <_panic>

		// Map page COW, U and P in parent
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), this_envid, (void *) (pn*PGSIZE), perm)) < 0)
  801428:	89 74 24 10          	mov    %esi,0x10(%esp)
  80142c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801433:	89 44 24 08          	mov    %eax,0x8(%esp)
  801437:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80143b:	89 04 24             	mov    %eax,(%esp)
  80143e:	e8 74 fa ff ff       	call   800eb7 <sys_page_map>
  801443:	85 c0                	test   %eax,%eax
  801445:	79 6e                	jns    8014b5 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801447:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80144b:	c7 44 24 08 33 32 80 	movl   $0x803233,0x8(%esp)
  801452:	00 
  801453:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  80145a:	00 
  80145b:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  801462:	e8 b7 ee ff ff       	call   80031e <_panic>

	} else { // map pages that are present but not writable or COW with their original permissions
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  801467:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80146e:	25 07 0e 00 00       	and    $0xe07,%eax
  801473:	89 44 24 10          	mov    %eax,0x10(%esp)
  801477:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80147b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801482:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801489:	89 04 24             	mov    %eax,(%esp)
  80148c:	e8 26 fa ff ff       	call   800eb7 <sys_page_map>
  801491:	85 c0                	test   %eax,%eax
  801493:	79 20                	jns    8014b5 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801495:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801499:	c7 44 24 08 33 32 80 	movl   $0x803233,0x8(%esp)
  8014a0:	00 
  8014a1:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  8014a8:	00 
  8014a9:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  8014b0:	e8 69 ee ff ff       	call   80031e <_panic>
	// and let duppage worry about the permissions.
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
  8014b5:	83 c3 01             	add    $0x1,%ebx
  8014b8:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8014be:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  8014c4:	0f 85 5d fe ff ff    	jne    801327 <fork+0x77>
	}

	// Allocate exception stack space for child. The child can't do this themselves
	// because the mechanism by which it would is to run the pgfault handler, which
	// needs to run on the exception stack (catch 22).
	if ((r = sys_page_alloc(child_envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8014ca:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014d1:	00 
  8014d2:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014d9:	ee 
  8014da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014dd:	89 04 24             	mov    %eax,(%esp)
  8014e0:	e8 7e f9 ff ff       	call   800e63 <sys_page_alloc>
  8014e5:	85 c0                	test   %eax,%eax
  8014e7:	79 20                	jns    801509 <fork+0x259>
		panic("sys_page_alloc: %e\n", r);
  8014e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014ed:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  8014f4:	00 
  8014f5:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  8014fc:	00 
  8014fd:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  801504:	e8 15 ee ff ff       	call   80031e <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801509:	c7 44 24 04 47 29 80 	movl   $0x802947,0x4(%esp)
  801510:	00 
  801511:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801514:	89 04 24             	mov    %eax,(%esp)
  801517:	e8 e7 fa ff ff       	call   801003 <sys_env_set_pgfault_upcall>
  80151c:	85 c0                	test   %eax,%eax
  80151e:	79 20                	jns    801540 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801520:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801524:	c7 44 24 08 f4 31 80 	movl   $0x8031f4,0x8(%esp)
  80152b:	00 
  80152c:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801533:	00 
  801534:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  80153b:	e8 de ed ff ff       	call   80031e <_panic>

	// Mark child environment as runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801540:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801547:	00 
  801548:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80154b:	89 04 24             	mov    %eax,(%esp)
  80154e:	e8 0a fa ff ff       	call   800f5d <sys_env_set_status>
  801553:	85 c0                	test   %eax,%eax
  801555:	79 20                	jns    801577 <fork+0x2c7>
		panic("sys_env_set_status: %e\n", r);
  801557:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80155b:	c7 44 24 08 56 32 80 	movl   $0x803256,0x8(%esp)
  801562:	00 
  801563:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80156a:	00 
  80156b:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  801572:	e8 a7 ed ff ff       	call   80031e <_panic>

	return child_envid;
  801577:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  80157a:	83 c4 2c             	add    $0x2c,%esp
  80157d:	5b                   	pop    %ebx
  80157e:	5e                   	pop    %esi
  80157f:	5f                   	pop    %edi
  801580:	5d                   	pop    %ebp
  801581:	c3                   	ret    

00801582 <sfork>:

// Challenge!
int
sfork(void)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	83 ec 18             	sub    $0x18,%esp
//	return __fork(1);
	panic("sfork not implemented");
  801588:	c7 44 24 08 6e 32 80 	movl   $0x80326e,0x8(%esp)
  80158f:	00 
  801590:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  801597:	00 
  801598:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  80159f:	e8 7a ed ff ff       	call   80031e <_panic>
  8015a4:	66 90                	xchg   %ax,%ax
  8015a6:	66 90                	xchg   %ax,%ax
  8015a8:	66 90                	xchg   %ax,%ax
  8015aa:	66 90                	xchg   %ax,%ax
  8015ac:	66 90                	xchg   %ax,%ax
  8015ae:	66 90                	xchg   %ax,%ax

008015b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8015bb:	c1 e8 0c             	shr    $0xc,%eax
}
  8015be:	5d                   	pop    %ebp
  8015bf:	c3                   	ret    

008015c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8015cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015d0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8015d5:	5d                   	pop    %ebp
  8015d6:	c3                   	ret    

008015d7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015dd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015e2:	89 c2                	mov    %eax,%edx
  8015e4:	c1 ea 16             	shr    $0x16,%edx
  8015e7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015ee:	f6 c2 01             	test   $0x1,%dl
  8015f1:	74 11                	je     801604 <fd_alloc+0x2d>
  8015f3:	89 c2                	mov    %eax,%edx
  8015f5:	c1 ea 0c             	shr    $0xc,%edx
  8015f8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015ff:	f6 c2 01             	test   $0x1,%dl
  801602:	75 09                	jne    80160d <fd_alloc+0x36>
			*fd_store = fd;
  801604:	89 01                	mov    %eax,(%ecx)
			return 0;
  801606:	b8 00 00 00 00       	mov    $0x0,%eax
  80160b:	eb 17                	jmp    801624 <fd_alloc+0x4d>
  80160d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801612:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801617:	75 c9                	jne    8015e2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801619:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80161f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801624:	5d                   	pop    %ebp
  801625:	c3                   	ret    

00801626 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801626:	55                   	push   %ebp
  801627:	89 e5                	mov    %esp,%ebp
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80162c:	83 f8 1f             	cmp    $0x1f,%eax
  80162f:	77 36                	ja     801667 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801631:	c1 e0 0c             	shl    $0xc,%eax
  801634:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801639:	89 c2                	mov    %eax,%edx
  80163b:	c1 ea 16             	shr    $0x16,%edx
  80163e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801645:	f6 c2 01             	test   $0x1,%dl
  801648:	74 24                	je     80166e <fd_lookup+0x48>
  80164a:	89 c2                	mov    %eax,%edx
  80164c:	c1 ea 0c             	shr    $0xc,%edx
  80164f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801656:	f6 c2 01             	test   $0x1,%dl
  801659:	74 1a                	je     801675 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80165b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165e:	89 02                	mov    %eax,(%edx)
	return 0;
  801660:	b8 00 00 00 00       	mov    $0x0,%eax
  801665:	eb 13                	jmp    80167a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801667:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80166c:	eb 0c                	jmp    80167a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80166e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801673:	eb 05                	jmp    80167a <fd_lookup+0x54>
  801675:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80167a:	5d                   	pop    %ebp
  80167b:	c3                   	ret    

0080167c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	83 ec 18             	sub    $0x18,%esp
  801682:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801685:	ba 00 00 00 00       	mov    $0x0,%edx
  80168a:	eb 13                	jmp    80169f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80168c:	39 08                	cmp    %ecx,(%eax)
  80168e:	75 0c                	jne    80169c <dev_lookup+0x20>
			*dev = devtab[i];
  801690:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801693:	89 01                	mov    %eax,(%ecx)
			return 0;
  801695:	b8 00 00 00 00       	mov    $0x0,%eax
  80169a:	eb 38                	jmp    8016d4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80169c:	83 c2 01             	add    $0x1,%edx
  80169f:	8b 04 95 00 33 80 00 	mov    0x803300(,%edx,4),%eax
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	75 e2                	jne    80168c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016aa:	a1 08 50 80 00       	mov    0x805008,%eax
  8016af:	8b 40 48             	mov    0x48(%eax),%eax
  8016b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ba:	c7 04 24 84 32 80 00 	movl   $0x803284,(%esp)
  8016c1:	e8 51 ed ff ff       	call   800417 <cprintf>
	*dev = 0;
  8016c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8016cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
  8016d9:	56                   	push   %esi
  8016da:	53                   	push   %ebx
  8016db:	83 ec 20             	sub    $0x20,%esp
  8016de:	8b 75 08             	mov    0x8(%ebp),%esi
  8016e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016eb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016f1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016f4:	89 04 24             	mov    %eax,(%esp)
  8016f7:	e8 2a ff ff ff       	call   801626 <fd_lookup>
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	78 05                	js     801705 <fd_close+0x2f>
	    || fd != fd2)
  801700:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801703:	74 0c                	je     801711 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801705:	84 db                	test   %bl,%bl
  801707:	ba 00 00 00 00       	mov    $0x0,%edx
  80170c:	0f 44 c2             	cmove  %edx,%eax
  80170f:	eb 3f                	jmp    801750 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801711:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801714:	89 44 24 04          	mov    %eax,0x4(%esp)
  801718:	8b 06                	mov    (%esi),%eax
  80171a:	89 04 24             	mov    %eax,(%esp)
  80171d:	e8 5a ff ff ff       	call   80167c <dev_lookup>
  801722:	89 c3                	mov    %eax,%ebx
  801724:	85 c0                	test   %eax,%eax
  801726:	78 16                	js     80173e <fd_close+0x68>
		if (dev->dev_close)
  801728:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80172e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801733:	85 c0                	test   %eax,%eax
  801735:	74 07                	je     80173e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801737:	89 34 24             	mov    %esi,(%esp)
  80173a:	ff d0                	call   *%eax
  80173c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80173e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801742:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801749:	e8 bc f7 ff ff       	call   800f0a <sys_page_unmap>
	return r;
  80174e:	89 d8                	mov    %ebx,%eax
}
  801750:	83 c4 20             	add    $0x20,%esp
  801753:	5b                   	pop    %ebx
  801754:	5e                   	pop    %esi
  801755:	5d                   	pop    %ebp
  801756:	c3                   	ret    

00801757 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80175d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801760:	89 44 24 04          	mov    %eax,0x4(%esp)
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	89 04 24             	mov    %eax,(%esp)
  80176a:	e8 b7 fe ff ff       	call   801626 <fd_lookup>
  80176f:	89 c2                	mov    %eax,%edx
  801771:	85 d2                	test   %edx,%edx
  801773:	78 13                	js     801788 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801775:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80177c:	00 
  80177d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801780:	89 04 24             	mov    %eax,(%esp)
  801783:	e8 4e ff ff ff       	call   8016d6 <fd_close>
}
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <close_all>:

void
close_all(void)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	53                   	push   %ebx
  80178e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801791:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801796:	89 1c 24             	mov    %ebx,(%esp)
  801799:	e8 b9 ff ff ff       	call   801757 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80179e:	83 c3 01             	add    $0x1,%ebx
  8017a1:	83 fb 20             	cmp    $0x20,%ebx
  8017a4:	75 f0                	jne    801796 <close_all+0xc>
		close(i);
}
  8017a6:	83 c4 14             	add    $0x14,%esp
  8017a9:	5b                   	pop    %ebx
  8017aa:	5d                   	pop    %ebp
  8017ab:	c3                   	ret    

008017ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	57                   	push   %edi
  8017b0:	56                   	push   %esi
  8017b1:	53                   	push   %ebx
  8017b2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	89 04 24             	mov    %eax,(%esp)
  8017c2:	e8 5f fe ff ff       	call   801626 <fd_lookup>
  8017c7:	89 c2                	mov    %eax,%edx
  8017c9:	85 d2                	test   %edx,%edx
  8017cb:	0f 88 e1 00 00 00    	js     8018b2 <dup+0x106>
		return r;
	close(newfdnum);
  8017d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d4:	89 04 24             	mov    %eax,(%esp)
  8017d7:	e8 7b ff ff ff       	call   801757 <close>

	newfd = INDEX2FD(newfdnum);
  8017dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017df:	c1 e3 0c             	shl    $0xc,%ebx
  8017e2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8017e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017eb:	89 04 24             	mov    %eax,(%esp)
  8017ee:	e8 cd fd ff ff       	call   8015c0 <fd2data>
  8017f3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8017f5:	89 1c 24             	mov    %ebx,(%esp)
  8017f8:	e8 c3 fd ff ff       	call   8015c0 <fd2data>
  8017fd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017ff:	89 f0                	mov    %esi,%eax
  801801:	c1 e8 16             	shr    $0x16,%eax
  801804:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80180b:	a8 01                	test   $0x1,%al
  80180d:	74 43                	je     801852 <dup+0xa6>
  80180f:	89 f0                	mov    %esi,%eax
  801811:	c1 e8 0c             	shr    $0xc,%eax
  801814:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80181b:	f6 c2 01             	test   $0x1,%dl
  80181e:	74 32                	je     801852 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801820:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801827:	25 07 0e 00 00       	and    $0xe07,%eax
  80182c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801830:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801834:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80183b:	00 
  80183c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801840:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801847:	e8 6b f6 ff ff       	call   800eb7 <sys_page_map>
  80184c:	89 c6                	mov    %eax,%esi
  80184e:	85 c0                	test   %eax,%eax
  801850:	78 3e                	js     801890 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801855:	89 c2                	mov    %eax,%edx
  801857:	c1 ea 0c             	shr    $0xc,%edx
  80185a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801861:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801867:	89 54 24 10          	mov    %edx,0x10(%esp)
  80186b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80186f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801876:	00 
  801877:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801882:	e8 30 f6 ff ff       	call   800eb7 <sys_page_map>
  801887:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801889:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80188c:	85 f6                	test   %esi,%esi
  80188e:	79 22                	jns    8018b2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801890:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801894:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80189b:	e8 6a f6 ff ff       	call   800f0a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8018a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018ab:	e8 5a f6 ff ff       	call   800f0a <sys_page_unmap>
	return r;
  8018b0:	89 f0                	mov    %esi,%eax
}
  8018b2:	83 c4 3c             	add    $0x3c,%esp
  8018b5:	5b                   	pop    %ebx
  8018b6:	5e                   	pop    %esi
  8018b7:	5f                   	pop    %edi
  8018b8:	5d                   	pop    %ebp
  8018b9:	c3                   	ret    

008018ba <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	53                   	push   %ebx
  8018be:	83 ec 24             	sub    $0x24,%esp
  8018c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018cb:	89 1c 24             	mov    %ebx,(%esp)
  8018ce:	e8 53 fd ff ff       	call   801626 <fd_lookup>
  8018d3:	89 c2                	mov    %eax,%edx
  8018d5:	85 d2                	test   %edx,%edx
  8018d7:	78 6d                	js     801946 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e3:	8b 00                	mov    (%eax),%eax
  8018e5:	89 04 24             	mov    %eax,(%esp)
  8018e8:	e8 8f fd ff ff       	call   80167c <dev_lookup>
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	78 55                	js     801946 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f4:	8b 50 08             	mov    0x8(%eax),%edx
  8018f7:	83 e2 03             	and    $0x3,%edx
  8018fa:	83 fa 01             	cmp    $0x1,%edx
  8018fd:	75 23                	jne    801922 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018ff:	a1 08 50 80 00       	mov    0x805008,%eax
  801904:	8b 40 48             	mov    0x48(%eax),%eax
  801907:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80190b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190f:	c7 04 24 c5 32 80 00 	movl   $0x8032c5,(%esp)
  801916:	e8 fc ea ff ff       	call   800417 <cprintf>
		return -E_INVAL;
  80191b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801920:	eb 24                	jmp    801946 <read+0x8c>
	}
	if (!dev->dev_read)
  801922:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801925:	8b 52 08             	mov    0x8(%edx),%edx
  801928:	85 d2                	test   %edx,%edx
  80192a:	74 15                	je     801941 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80192c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801933:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801936:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80193a:	89 04 24             	mov    %eax,(%esp)
  80193d:	ff d2                	call   *%edx
  80193f:	eb 05                	jmp    801946 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801941:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801946:	83 c4 24             	add    $0x24,%esp
  801949:	5b                   	pop    %ebx
  80194a:	5d                   	pop    %ebp
  80194b:	c3                   	ret    

0080194c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	57                   	push   %edi
  801950:	56                   	push   %esi
  801951:	53                   	push   %ebx
  801952:	83 ec 1c             	sub    $0x1c,%esp
  801955:	8b 7d 08             	mov    0x8(%ebp),%edi
  801958:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80195b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801960:	eb 23                	jmp    801985 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801962:	89 f0                	mov    %esi,%eax
  801964:	29 d8                	sub    %ebx,%eax
  801966:	89 44 24 08          	mov    %eax,0x8(%esp)
  80196a:	89 d8                	mov    %ebx,%eax
  80196c:	03 45 0c             	add    0xc(%ebp),%eax
  80196f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801973:	89 3c 24             	mov    %edi,(%esp)
  801976:	e8 3f ff ff ff       	call   8018ba <read>
		if (m < 0)
  80197b:	85 c0                	test   %eax,%eax
  80197d:	78 10                	js     80198f <readn+0x43>
			return m;
		if (m == 0)
  80197f:	85 c0                	test   %eax,%eax
  801981:	74 0a                	je     80198d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801983:	01 c3                	add    %eax,%ebx
  801985:	39 f3                	cmp    %esi,%ebx
  801987:	72 d9                	jb     801962 <readn+0x16>
  801989:	89 d8                	mov    %ebx,%eax
  80198b:	eb 02                	jmp    80198f <readn+0x43>
  80198d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80198f:	83 c4 1c             	add    $0x1c,%esp
  801992:	5b                   	pop    %ebx
  801993:	5e                   	pop    %esi
  801994:	5f                   	pop    %edi
  801995:	5d                   	pop    %ebp
  801996:	c3                   	ret    

00801997 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	53                   	push   %ebx
  80199b:	83 ec 24             	sub    $0x24,%esp
  80199e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a8:	89 1c 24             	mov    %ebx,(%esp)
  8019ab:	e8 76 fc ff ff       	call   801626 <fd_lookup>
  8019b0:	89 c2                	mov    %eax,%edx
  8019b2:	85 d2                	test   %edx,%edx
  8019b4:	78 68                	js     801a1e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c0:	8b 00                	mov    (%eax),%eax
  8019c2:	89 04 24             	mov    %eax,(%esp)
  8019c5:	e8 b2 fc ff ff       	call   80167c <dev_lookup>
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	78 50                	js     801a1e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019d5:	75 23                	jne    8019fa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019d7:	a1 08 50 80 00       	mov    0x805008,%eax
  8019dc:	8b 40 48             	mov    0x48(%eax),%eax
  8019df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e7:	c7 04 24 e1 32 80 00 	movl   $0x8032e1,(%esp)
  8019ee:	e8 24 ea ff ff       	call   800417 <cprintf>
		return -E_INVAL;
  8019f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019f8:	eb 24                	jmp    801a1e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019fd:	8b 52 0c             	mov    0xc(%edx),%edx
  801a00:	85 d2                	test   %edx,%edx
  801a02:	74 15                	je     801a19 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a04:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a07:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a0e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a12:	89 04 24             	mov    %eax,(%esp)
  801a15:	ff d2                	call   *%edx
  801a17:	eb 05                	jmp    801a1e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a19:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a1e:	83 c4 24             	add    $0x24,%esp
  801a21:	5b                   	pop    %ebx
  801a22:	5d                   	pop    %ebp
  801a23:	c3                   	ret    

00801a24 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a2a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a31:	8b 45 08             	mov    0x8(%ebp),%eax
  801a34:	89 04 24             	mov    %eax,(%esp)
  801a37:	e8 ea fb ff ff       	call   801626 <fd_lookup>
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	78 0e                	js     801a4e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801a40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a46:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    

00801a50 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a50:	55                   	push   %ebp
  801a51:	89 e5                	mov    %esp,%ebp
  801a53:	53                   	push   %ebx
  801a54:	83 ec 24             	sub    $0x24,%esp
  801a57:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a5a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a61:	89 1c 24             	mov    %ebx,(%esp)
  801a64:	e8 bd fb ff ff       	call   801626 <fd_lookup>
  801a69:	89 c2                	mov    %eax,%edx
  801a6b:	85 d2                	test   %edx,%edx
  801a6d:	78 61                	js     801ad0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a6f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a72:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a79:	8b 00                	mov    (%eax),%eax
  801a7b:	89 04 24             	mov    %eax,(%esp)
  801a7e:	e8 f9 fb ff ff       	call   80167c <dev_lookup>
  801a83:	85 c0                	test   %eax,%eax
  801a85:	78 49                	js     801ad0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a8e:	75 23                	jne    801ab3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a90:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a95:	8b 40 48             	mov    0x48(%eax),%eax
  801a98:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa0:	c7 04 24 a4 32 80 00 	movl   $0x8032a4,(%esp)
  801aa7:	e8 6b e9 ff ff       	call   800417 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801aac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ab1:	eb 1d                	jmp    801ad0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801ab3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab6:	8b 52 18             	mov    0x18(%edx),%edx
  801ab9:	85 d2                	test   %edx,%edx
  801abb:	74 0e                	je     801acb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801abd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ac0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ac4:	89 04 24             	mov    %eax,(%esp)
  801ac7:	ff d2                	call   *%edx
  801ac9:	eb 05                	jmp    801ad0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801acb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801ad0:	83 c4 24             	add    $0x24,%esp
  801ad3:	5b                   	pop    %ebx
  801ad4:	5d                   	pop    %ebp
  801ad5:	c3                   	ret    

00801ad6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	53                   	push   %ebx
  801ada:	83 ec 24             	sub    $0x24,%esp
  801add:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ae0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	89 04 24             	mov    %eax,(%esp)
  801aed:	e8 34 fb ff ff       	call   801626 <fd_lookup>
  801af2:	89 c2                	mov    %eax,%edx
  801af4:	85 d2                	test   %edx,%edx
  801af6:	78 52                	js     801b4a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801af8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801afb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b02:	8b 00                	mov    (%eax),%eax
  801b04:	89 04 24             	mov    %eax,(%esp)
  801b07:	e8 70 fb ff ff       	call   80167c <dev_lookup>
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	78 3a                	js     801b4a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b13:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b17:	74 2c                	je     801b45 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b19:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b1c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b23:	00 00 00 
	stat->st_isdir = 0;
  801b26:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b2d:	00 00 00 
	stat->st_dev = dev;
  801b30:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b36:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b3d:	89 14 24             	mov    %edx,(%esp)
  801b40:	ff 50 14             	call   *0x14(%eax)
  801b43:	eb 05                	jmp    801b4a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801b45:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801b4a:	83 c4 24             	add    $0x24,%esp
  801b4d:	5b                   	pop    %ebx
  801b4e:	5d                   	pop    %ebp
  801b4f:	c3                   	ret    

00801b50 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	56                   	push   %esi
  801b54:	53                   	push   %ebx
  801b55:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b58:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b5f:	00 
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	89 04 24             	mov    %eax,(%esp)
  801b66:	e8 84 02 00 00       	call   801def <open>
  801b6b:	89 c3                	mov    %eax,%ebx
  801b6d:	85 db                	test   %ebx,%ebx
  801b6f:	78 1b                	js     801b8c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b78:	89 1c 24             	mov    %ebx,(%esp)
  801b7b:	e8 56 ff ff ff       	call   801ad6 <fstat>
  801b80:	89 c6                	mov    %eax,%esi
	close(fd);
  801b82:	89 1c 24             	mov    %ebx,(%esp)
  801b85:	e8 cd fb ff ff       	call   801757 <close>
	return r;
  801b8a:	89 f0                	mov    %esi,%eax
}
  801b8c:	83 c4 10             	add    $0x10,%esp
  801b8f:	5b                   	pop    %ebx
  801b90:	5e                   	pop    %esi
  801b91:	5d                   	pop    %ebp
  801b92:	c3                   	ret    

00801b93 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	56                   	push   %esi
  801b97:	53                   	push   %ebx
  801b98:	83 ec 10             	sub    $0x10,%esp
  801b9b:	89 c6                	mov    %eax,%esi
  801b9d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b9f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801ba6:	75 11                	jne    801bb9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ba8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801baf:	e8 b1 0e 00 00       	call   802a65 <ipc_find_env>
  801bb4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bb9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bc0:	00 
  801bc1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801bc8:	00 
  801bc9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bcd:	a1 00 50 80 00       	mov    0x805000,%eax
  801bd2:	89 04 24             	mov    %eax,(%esp)
  801bd5:	e8 fe 0d 00 00       	call   8029d8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bda:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801be1:	00 
  801be2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801be6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bed:	e8 7e 0d 00 00       	call   802970 <ipc_recv>
}
  801bf2:	83 c4 10             	add    $0x10,%esp
  801bf5:	5b                   	pop    %ebx
  801bf6:	5e                   	pop    %esi
  801bf7:	5d                   	pop    %ebp
  801bf8:	c3                   	ret    

00801bf9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	8b 40 0c             	mov    0xc(%eax),%eax
  801c05:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c12:	ba 00 00 00 00       	mov    $0x0,%edx
  801c17:	b8 02 00 00 00       	mov    $0x2,%eax
  801c1c:	e8 72 ff ff ff       	call   801b93 <fsipc>
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c2f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c34:	ba 00 00 00 00       	mov    $0x0,%edx
  801c39:	b8 06 00 00 00       	mov    $0x6,%eax
  801c3e:	e8 50 ff ff ff       	call   801b93 <fsipc>
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	53                   	push   %ebx
  801c49:	83 ec 14             	sub    $0x14,%esp
  801c4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	8b 40 0c             	mov    0xc(%eax),%eax
  801c55:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c5a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5f:	b8 05 00 00 00       	mov    $0x5,%eax
  801c64:	e8 2a ff ff ff       	call   801b93 <fsipc>
  801c69:	89 c2                	mov    %eax,%edx
  801c6b:	85 d2                	test   %edx,%edx
  801c6d:	78 2b                	js     801c9a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c6f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c76:	00 
  801c77:	89 1c 24             	mov    %ebx,(%esp)
  801c7a:	e8 c8 ed ff ff       	call   800a47 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c7f:	a1 80 60 80 00       	mov    0x806080,%eax
  801c84:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c8a:	a1 84 60 80 00       	mov    0x806084,%eax
  801c8f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9a:	83 c4 14             	add    $0x14,%esp
  801c9d:	5b                   	pop    %ebx
  801c9e:	5d                   	pop    %ebp
  801c9f:	c3                   	ret    

00801ca0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	53                   	push   %ebx
  801ca4:	83 ec 14             	sub    $0x14,%esp
  801ca7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801caa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cad:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801cb5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801cbb:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801cc0:	0f 46 c3             	cmovbe %ebx,%eax
  801cc3:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801cc8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd3:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801cda:	e8 05 ef ff ff       	call   800be4 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801cdf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ce4:	b8 04 00 00 00       	mov    $0x4,%eax
  801ce9:	e8 a5 fe ff ff       	call   801b93 <fsipc>
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	78 53                	js     801d45 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801cf2:	39 c3                	cmp    %eax,%ebx
  801cf4:	73 24                	jae    801d1a <devfile_write+0x7a>
  801cf6:	c7 44 24 0c 14 33 80 	movl   $0x803314,0xc(%esp)
  801cfd:	00 
  801cfe:	c7 44 24 08 1b 33 80 	movl   $0x80331b,0x8(%esp)
  801d05:	00 
  801d06:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801d0d:	00 
  801d0e:	c7 04 24 30 33 80 00 	movl   $0x803330,(%esp)
  801d15:	e8 04 e6 ff ff       	call   80031e <_panic>
	assert(r <= PGSIZE);
  801d1a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d1f:	7e 24                	jle    801d45 <devfile_write+0xa5>
  801d21:	c7 44 24 0c 3b 33 80 	movl   $0x80333b,0xc(%esp)
  801d28:	00 
  801d29:	c7 44 24 08 1b 33 80 	movl   $0x80331b,0x8(%esp)
  801d30:	00 
  801d31:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801d38:	00 
  801d39:	c7 04 24 30 33 80 00 	movl   $0x803330,(%esp)
  801d40:	e8 d9 e5 ff ff       	call   80031e <_panic>
	return r;
}
  801d45:	83 c4 14             	add    $0x14,%esp
  801d48:	5b                   	pop    %ebx
  801d49:	5d                   	pop    %ebp
  801d4a:	c3                   	ret    

00801d4b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	56                   	push   %esi
  801d4f:	53                   	push   %ebx
  801d50:	83 ec 10             	sub    $0x10,%esp
  801d53:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d56:	8b 45 08             	mov    0x8(%ebp),%eax
  801d59:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5c:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801d61:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801d67:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6c:	b8 03 00 00 00       	mov    $0x3,%eax
  801d71:	e8 1d fe ff ff       	call   801b93 <fsipc>
  801d76:	89 c3                	mov    %eax,%ebx
  801d78:	85 c0                	test   %eax,%eax
  801d7a:	78 6a                	js     801de6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801d7c:	39 c6                	cmp    %eax,%esi
  801d7e:	73 24                	jae    801da4 <devfile_read+0x59>
  801d80:	c7 44 24 0c 14 33 80 	movl   $0x803314,0xc(%esp)
  801d87:	00 
  801d88:	c7 44 24 08 1b 33 80 	movl   $0x80331b,0x8(%esp)
  801d8f:	00 
  801d90:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801d97:	00 
  801d98:	c7 04 24 30 33 80 00 	movl   $0x803330,(%esp)
  801d9f:	e8 7a e5 ff ff       	call   80031e <_panic>
	assert(r <= PGSIZE);
  801da4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801da9:	7e 24                	jle    801dcf <devfile_read+0x84>
  801dab:	c7 44 24 0c 3b 33 80 	movl   $0x80333b,0xc(%esp)
  801db2:	00 
  801db3:	c7 44 24 08 1b 33 80 	movl   $0x80331b,0x8(%esp)
  801dba:	00 
  801dbb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801dc2:	00 
  801dc3:	c7 04 24 30 33 80 00 	movl   $0x803330,(%esp)
  801dca:	e8 4f e5 ff ff       	call   80031e <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801dcf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801dda:	00 
  801ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dde:	89 04 24             	mov    %eax,(%esp)
  801de1:	e8 fe ed ff ff       	call   800be4 <memmove>
	return r;
}
  801de6:	89 d8                	mov    %ebx,%eax
  801de8:	83 c4 10             	add    $0x10,%esp
  801deb:	5b                   	pop    %ebx
  801dec:	5e                   	pop    %esi
  801ded:	5d                   	pop    %ebp
  801dee:	c3                   	ret    

00801def <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	53                   	push   %ebx
  801df3:	83 ec 24             	sub    $0x24,%esp
  801df6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801df9:	89 1c 24             	mov    %ebx,(%esp)
  801dfc:	e8 0f ec ff ff       	call   800a10 <strlen>
  801e01:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e06:	7f 60                	jg     801e68 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801e08:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e0b:	89 04 24             	mov    %eax,(%esp)
  801e0e:	e8 c4 f7 ff ff       	call   8015d7 <fd_alloc>
  801e13:	89 c2                	mov    %eax,%edx
  801e15:	85 d2                	test   %edx,%edx
  801e17:	78 54                	js     801e6d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801e19:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e1d:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801e24:	e8 1e ec ff ff       	call   800a47 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e34:	b8 01 00 00 00       	mov    $0x1,%eax
  801e39:	e8 55 fd ff ff       	call   801b93 <fsipc>
  801e3e:	89 c3                	mov    %eax,%ebx
  801e40:	85 c0                	test   %eax,%eax
  801e42:	79 17                	jns    801e5b <open+0x6c>
		fd_close(fd, 0);
  801e44:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e4b:	00 
  801e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4f:	89 04 24             	mov    %eax,(%esp)
  801e52:	e8 7f f8 ff ff       	call   8016d6 <fd_close>
		return r;
  801e57:	89 d8                	mov    %ebx,%eax
  801e59:	eb 12                	jmp    801e6d <open+0x7e>
	}

	return fd2num(fd);
  801e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5e:	89 04 24             	mov    %eax,(%esp)
  801e61:	e8 4a f7 ff ff       	call   8015b0 <fd2num>
  801e66:	eb 05                	jmp    801e6d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801e68:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801e6d:	83 c4 24             	add    $0x24,%esp
  801e70:	5b                   	pop    %ebx
  801e71:	5d                   	pop    %ebp
  801e72:	c3                   	ret    

00801e73 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e79:	ba 00 00 00 00       	mov    $0x0,%edx
  801e7e:	b8 08 00 00 00       	mov    $0x8,%eax
  801e83:	e8 0b fd ff ff       	call   801b93 <fsipc>
}
  801e88:	c9                   	leave  
  801e89:	c3                   	ret    
  801e8a:	66 90                	xchg   %ax,%ax
  801e8c:	66 90                	xchg   %ax,%ax
  801e8e:	66 90                	xchg   %ax,%ax

00801e90 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e96:	c7 44 24 04 47 33 80 	movl   $0x803347,0x4(%esp)
  801e9d:	00 
  801e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea1:	89 04 24             	mov    %eax,(%esp)
  801ea4:	e8 9e eb ff ff       	call   800a47 <strcpy>
	return 0;
}
  801ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	53                   	push   %ebx
  801eb4:	83 ec 14             	sub    $0x14,%esp
  801eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801eba:	89 1c 24             	mov    %ebx,(%esp)
  801ebd:	e8 dd 0b 00 00       	call   802a9f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801ec2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801ec7:	83 f8 01             	cmp    $0x1,%eax
  801eca:	75 0d                	jne    801ed9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801ecc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801ecf:	89 04 24             	mov    %eax,(%esp)
  801ed2:	e8 29 03 00 00       	call   802200 <nsipc_close>
  801ed7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801ed9:	89 d0                	mov    %edx,%eax
  801edb:	83 c4 14             	add    $0x14,%esp
  801ede:	5b                   	pop    %ebx
  801edf:	5d                   	pop    %ebp
  801ee0:	c3                   	ret    

00801ee1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ee7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801eee:	00 
  801eef:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801efd:	8b 45 08             	mov    0x8(%ebp),%eax
  801f00:	8b 40 0c             	mov    0xc(%eax),%eax
  801f03:	89 04 24             	mov    %eax,(%esp)
  801f06:	e8 f0 03 00 00       	call   8022fb <nsipc_send>
}
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
  801f10:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f13:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f1a:	00 
  801f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f29:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f2f:	89 04 24             	mov    %eax,(%esp)
  801f32:	e8 44 03 00 00       	call   80227b <nsipc_recv>
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    

00801f39 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f3f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f42:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f46:	89 04 24             	mov    %eax,(%esp)
  801f49:	e8 d8 f6 ff ff       	call   801626 <fd_lookup>
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	78 17                	js     801f69 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801f5b:	39 08                	cmp    %ecx,(%eax)
  801f5d:	75 05                	jne    801f64 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801f5f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f62:	eb 05                	jmp    801f69 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801f64:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	56                   	push   %esi
  801f6f:	53                   	push   %ebx
  801f70:	83 ec 20             	sub    $0x20,%esp
  801f73:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f78:	89 04 24             	mov    %eax,(%esp)
  801f7b:	e8 57 f6 ff ff       	call   8015d7 <fd_alloc>
  801f80:	89 c3                	mov    %eax,%ebx
  801f82:	85 c0                	test   %eax,%eax
  801f84:	78 21                	js     801fa7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f86:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f8d:	00 
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f9c:	e8 c2 ee ff ff       	call   800e63 <sys_page_alloc>
  801fa1:	89 c3                	mov    %eax,%ebx
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	79 0c                	jns    801fb3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801fa7:	89 34 24             	mov    %esi,(%esp)
  801faa:	e8 51 02 00 00       	call   802200 <nsipc_close>
		return r;
  801faf:	89 d8                	mov    %ebx,%eax
  801fb1:	eb 20                	jmp    801fd3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801fb3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801fbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801fc8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801fcb:	89 14 24             	mov    %edx,(%esp)
  801fce:	e8 dd f5 ff ff       	call   8015b0 <fd2num>
}
  801fd3:	83 c4 20             	add    $0x20,%esp
  801fd6:	5b                   	pop    %ebx
  801fd7:	5e                   	pop    %esi
  801fd8:	5d                   	pop    %ebp
  801fd9:	c3                   	ret    

00801fda <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
  801fdd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe3:	e8 51 ff ff ff       	call   801f39 <fd2sockid>
		return r;
  801fe8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fea:	85 c0                	test   %eax,%eax
  801fec:	78 23                	js     802011 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801fee:	8b 55 10             	mov    0x10(%ebp),%edx
  801ff1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ff5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ffc:	89 04 24             	mov    %eax,(%esp)
  801fff:	e8 45 01 00 00       	call   802149 <nsipc_accept>
		return r;
  802004:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802006:	85 c0                	test   %eax,%eax
  802008:	78 07                	js     802011 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80200a:	e8 5c ff ff ff       	call   801f6b <alloc_sockfd>
  80200f:	89 c1                	mov    %eax,%ecx
}
  802011:	89 c8                	mov    %ecx,%eax
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	e8 16 ff ff ff       	call   801f39 <fd2sockid>
  802023:	89 c2                	mov    %eax,%edx
  802025:	85 d2                	test   %edx,%edx
  802027:	78 16                	js     80203f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802029:	8b 45 10             	mov    0x10(%ebp),%eax
  80202c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802030:	8b 45 0c             	mov    0xc(%ebp),%eax
  802033:	89 44 24 04          	mov    %eax,0x4(%esp)
  802037:	89 14 24             	mov    %edx,(%esp)
  80203a:	e8 60 01 00 00       	call   80219f <nsipc_bind>
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <shutdown>:

int
shutdown(int s, int how)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	e8 ea fe ff ff       	call   801f39 <fd2sockid>
  80204f:	89 c2                	mov    %eax,%edx
  802051:	85 d2                	test   %edx,%edx
  802053:	78 0f                	js     802064 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802055:	8b 45 0c             	mov    0xc(%ebp),%eax
  802058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205c:	89 14 24             	mov    %edx,(%esp)
  80205f:	e8 7a 01 00 00       	call   8021de <nsipc_shutdown>
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80206c:	8b 45 08             	mov    0x8(%ebp),%eax
  80206f:	e8 c5 fe ff ff       	call   801f39 <fd2sockid>
  802074:	89 c2                	mov    %eax,%edx
  802076:	85 d2                	test   %edx,%edx
  802078:	78 16                	js     802090 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80207a:	8b 45 10             	mov    0x10(%ebp),%eax
  80207d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802081:	8b 45 0c             	mov    0xc(%ebp),%eax
  802084:	89 44 24 04          	mov    %eax,0x4(%esp)
  802088:	89 14 24             	mov    %edx,(%esp)
  80208b:	e8 8a 01 00 00       	call   80221a <nsipc_connect>
}
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <listen>:

int
listen(int s, int backlog)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
  802095:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802098:	8b 45 08             	mov    0x8(%ebp),%eax
  80209b:	e8 99 fe ff ff       	call   801f39 <fd2sockid>
  8020a0:	89 c2                	mov    %eax,%edx
  8020a2:	85 d2                	test   %edx,%edx
  8020a4:	78 0f                	js     8020b5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8020a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ad:	89 14 24             	mov    %edx,(%esp)
  8020b0:	e8 a4 01 00 00       	call   802259 <nsipc_listen>
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8020bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	89 04 24             	mov    %eax,(%esp)
  8020d1:	e8 98 02 00 00       	call   80236e <nsipc_socket>
  8020d6:	89 c2                	mov    %eax,%edx
  8020d8:	85 d2                	test   %edx,%edx
  8020da:	78 05                	js     8020e1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8020dc:	e8 8a fe ff ff       	call   801f6b <alloc_sockfd>
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	53                   	push   %ebx
  8020e7:	83 ec 14             	sub    $0x14,%esp
  8020ea:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8020ec:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  8020f3:	75 11                	jne    802106 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  8020f5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8020fc:	e8 64 09 00 00       	call   802a65 <ipc_find_env>
  802101:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802106:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80210d:	00 
  80210e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802115:	00 
  802116:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80211a:	a1 04 50 80 00       	mov    0x805004,%eax
  80211f:	89 04 24             	mov    %eax,(%esp)
  802122:	e8 b1 08 00 00       	call   8029d8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802127:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80212e:	00 
  80212f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802136:	00 
  802137:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80213e:	e8 2d 08 00 00       	call   802970 <ipc_recv>
}
  802143:	83 c4 14             	add    $0x14,%esp
  802146:	5b                   	pop    %ebx
  802147:	5d                   	pop    %ebp
  802148:	c3                   	ret    

00802149 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	56                   	push   %esi
  80214d:	53                   	push   %ebx
  80214e:	83 ec 10             	sub    $0x10,%esp
  802151:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80215c:	8b 06                	mov    (%esi),%eax
  80215e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802163:	b8 01 00 00 00       	mov    $0x1,%eax
  802168:	e8 76 ff ff ff       	call   8020e3 <nsipc>
  80216d:	89 c3                	mov    %eax,%ebx
  80216f:	85 c0                	test   %eax,%eax
  802171:	78 23                	js     802196 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802173:	a1 10 70 80 00       	mov    0x807010,%eax
  802178:	89 44 24 08          	mov    %eax,0x8(%esp)
  80217c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802183:	00 
  802184:	8b 45 0c             	mov    0xc(%ebp),%eax
  802187:	89 04 24             	mov    %eax,(%esp)
  80218a:	e8 55 ea ff ff       	call   800be4 <memmove>
		*addrlen = ret->ret_addrlen;
  80218f:	a1 10 70 80 00       	mov    0x807010,%eax
  802194:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802196:	89 d8                	mov    %ebx,%eax
  802198:	83 c4 10             	add    $0x10,%esp
  80219b:	5b                   	pop    %ebx
  80219c:	5e                   	pop    %esi
  80219d:	5d                   	pop    %ebp
  80219e:	c3                   	ret    

0080219f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
  8021a2:	53                   	push   %ebx
  8021a3:	83 ec 14             	sub    $0x14,%esp
  8021a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ac:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8021b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021bc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8021c3:	e8 1c ea ff ff       	call   800be4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8021c8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8021ce:	b8 02 00 00 00       	mov    $0x2,%eax
  8021d3:	e8 0b ff ff ff       	call   8020e3 <nsipc>
}
  8021d8:	83 c4 14             	add    $0x14,%esp
  8021db:	5b                   	pop    %ebx
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    

008021de <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  8021ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ef:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  8021f4:	b8 03 00 00 00       	mov    $0x3,%eax
  8021f9:	e8 e5 fe ff ff       	call   8020e3 <nsipc>
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <nsipc_close>:

int
nsipc_close(int s)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80220e:	b8 04 00 00 00       	mov    $0x4,%eax
  802213:	e8 cb fe ff ff       	call   8020e3 <nsipc>
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
  80221d:	53                   	push   %ebx
  80221e:	83 ec 14             	sub    $0x14,%esp
  802221:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80222c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802230:	8b 45 0c             	mov    0xc(%ebp),%eax
  802233:	89 44 24 04          	mov    %eax,0x4(%esp)
  802237:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80223e:	e8 a1 e9 ff ff       	call   800be4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802243:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802249:	b8 05 00 00 00       	mov    $0x5,%eax
  80224e:	e8 90 fe ff ff       	call   8020e3 <nsipc>
}
  802253:	83 c4 14             	add    $0x14,%esp
  802256:	5b                   	pop    %ebx
  802257:	5d                   	pop    %ebp
  802258:	c3                   	ret    

00802259 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
  80225c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80226f:	b8 06 00 00 00       	mov    $0x6,%eax
  802274:	e8 6a fe ff ff       	call   8020e3 <nsipc>
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	56                   	push   %esi
  80227f:	53                   	push   %ebx
  802280:	83 ec 10             	sub    $0x10,%esp
  802283:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80228e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802294:	8b 45 14             	mov    0x14(%ebp),%eax
  802297:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80229c:	b8 07 00 00 00       	mov    $0x7,%eax
  8022a1:	e8 3d fe ff ff       	call   8020e3 <nsipc>
  8022a6:	89 c3                	mov    %eax,%ebx
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	78 46                	js     8022f2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8022ac:	39 f0                	cmp    %esi,%eax
  8022ae:	7f 07                	jg     8022b7 <nsipc_recv+0x3c>
  8022b0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022b5:	7e 24                	jle    8022db <nsipc_recv+0x60>
  8022b7:	c7 44 24 0c 53 33 80 	movl   $0x803353,0xc(%esp)
  8022be:	00 
  8022bf:	c7 44 24 08 1b 33 80 	movl   $0x80331b,0x8(%esp)
  8022c6:	00 
  8022c7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8022ce:	00 
  8022cf:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  8022d6:	e8 43 e0 ff ff       	call   80031e <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022df:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8022e6:	00 
  8022e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ea:	89 04 24             	mov    %eax,(%esp)
  8022ed:	e8 f2 e8 ff ff       	call   800be4 <memmove>
	}

	return r;
}
  8022f2:	89 d8                	mov    %ebx,%eax
  8022f4:	83 c4 10             	add    $0x10,%esp
  8022f7:	5b                   	pop    %ebx
  8022f8:	5e                   	pop    %esi
  8022f9:	5d                   	pop    %ebp
  8022fa:	c3                   	ret    

008022fb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
  8022fe:	53                   	push   %ebx
  8022ff:	83 ec 14             	sub    $0x14,%esp
  802302:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80230d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802313:	7e 24                	jle    802339 <nsipc_send+0x3e>
  802315:	c7 44 24 0c 74 33 80 	movl   $0x803374,0xc(%esp)
  80231c:	00 
  80231d:	c7 44 24 08 1b 33 80 	movl   $0x80331b,0x8(%esp)
  802324:	00 
  802325:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80232c:	00 
  80232d:	c7 04 24 68 33 80 00 	movl   $0x803368,(%esp)
  802334:	e8 e5 df ff ff       	call   80031e <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802339:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80233d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802340:	89 44 24 04          	mov    %eax,0x4(%esp)
  802344:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80234b:	e8 94 e8 ff ff       	call   800be4 <memmove>
	nsipcbuf.send.req_size = size;
  802350:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802356:	8b 45 14             	mov    0x14(%ebp),%eax
  802359:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80235e:	b8 08 00 00 00       	mov    $0x8,%eax
  802363:	e8 7b fd ff ff       	call   8020e3 <nsipc>
}
  802368:	83 c4 14             	add    $0x14,%esp
  80236b:	5b                   	pop    %ebx
  80236c:	5d                   	pop    %ebp
  80236d:	c3                   	ret    

0080236e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80237c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802384:	8b 45 10             	mov    0x10(%ebp),%eax
  802387:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80238c:	b8 09 00 00 00       	mov    $0x9,%eax
  802391:	e8 4d fd ff ff       	call   8020e3 <nsipc>
}
  802396:	c9                   	leave  
  802397:	c3                   	ret    

00802398 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802398:	55                   	push   %ebp
  802399:	89 e5                	mov    %esp,%ebp
  80239b:	56                   	push   %esi
  80239c:	53                   	push   %ebx
  80239d:	83 ec 10             	sub    $0x10,%esp
  8023a0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	89 04 24             	mov    %eax,(%esp)
  8023a9:	e8 12 f2 ff ff       	call   8015c0 <fd2data>
  8023ae:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8023b0:	c7 44 24 04 80 33 80 	movl   $0x803380,0x4(%esp)
  8023b7:	00 
  8023b8:	89 1c 24             	mov    %ebx,(%esp)
  8023bb:	e8 87 e6 ff ff       	call   800a47 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023c0:	8b 46 04             	mov    0x4(%esi),%eax
  8023c3:	2b 06                	sub    (%esi),%eax
  8023c5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8023cb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8023d2:	00 00 00 
	stat->st_dev = &devpipe;
  8023d5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8023dc:	40 80 00 
	return 0;
}
  8023df:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e4:	83 c4 10             	add    $0x10,%esp
  8023e7:	5b                   	pop    %ebx
  8023e8:	5e                   	pop    %esi
  8023e9:	5d                   	pop    %ebp
  8023ea:	c3                   	ret    

008023eb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
  8023ee:	53                   	push   %ebx
  8023ef:	83 ec 14             	sub    $0x14,%esp
  8023f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802400:	e8 05 eb ff ff       	call   800f0a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802405:	89 1c 24             	mov    %ebx,(%esp)
  802408:	e8 b3 f1 ff ff       	call   8015c0 <fd2data>
  80240d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802411:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802418:	e8 ed ea ff ff       	call   800f0a <sys_page_unmap>
}
  80241d:	83 c4 14             	add    $0x14,%esp
  802420:	5b                   	pop    %ebx
  802421:	5d                   	pop    %ebp
  802422:	c3                   	ret    

00802423 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802423:	55                   	push   %ebp
  802424:	89 e5                	mov    %esp,%ebp
  802426:	57                   	push   %edi
  802427:	56                   	push   %esi
  802428:	53                   	push   %ebx
  802429:	83 ec 2c             	sub    $0x2c,%esp
  80242c:	89 c6                	mov    %eax,%esi
  80242e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802431:	a1 08 50 80 00       	mov    0x805008,%eax
  802436:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802439:	89 34 24             	mov    %esi,(%esp)
  80243c:	e8 5e 06 00 00       	call   802a9f <pageref>
  802441:	89 c7                	mov    %eax,%edi
  802443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802446:	89 04 24             	mov    %eax,(%esp)
  802449:	e8 51 06 00 00       	call   802a9f <pageref>
  80244e:	39 c7                	cmp    %eax,%edi
  802450:	0f 94 c2             	sete   %dl
  802453:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802456:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80245c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80245f:	39 fb                	cmp    %edi,%ebx
  802461:	74 21                	je     802484 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802463:	84 d2                	test   %dl,%dl
  802465:	74 ca                	je     802431 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802467:	8b 51 58             	mov    0x58(%ecx),%edx
  80246a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80246e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802472:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802476:	c7 04 24 87 33 80 00 	movl   $0x803387,(%esp)
  80247d:	e8 95 df ff ff       	call   800417 <cprintf>
  802482:	eb ad                	jmp    802431 <_pipeisclosed+0xe>
	}
}
  802484:	83 c4 2c             	add    $0x2c,%esp
  802487:	5b                   	pop    %ebx
  802488:	5e                   	pop    %esi
  802489:	5f                   	pop    %edi
  80248a:	5d                   	pop    %ebp
  80248b:	c3                   	ret    

0080248c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	57                   	push   %edi
  802490:	56                   	push   %esi
  802491:	53                   	push   %ebx
  802492:	83 ec 1c             	sub    $0x1c,%esp
  802495:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802498:	89 34 24             	mov    %esi,(%esp)
  80249b:	e8 20 f1 ff ff       	call   8015c0 <fd2data>
  8024a0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024a7:	eb 45                	jmp    8024ee <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8024a9:	89 da                	mov    %ebx,%edx
  8024ab:	89 f0                	mov    %esi,%eax
  8024ad:	e8 71 ff ff ff       	call   802423 <_pipeisclosed>
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	75 41                	jne    8024f7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8024b6:	e8 89 e9 ff ff       	call   800e44 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024bb:	8b 43 04             	mov    0x4(%ebx),%eax
  8024be:	8b 0b                	mov    (%ebx),%ecx
  8024c0:	8d 51 20             	lea    0x20(%ecx),%edx
  8024c3:	39 d0                	cmp    %edx,%eax
  8024c5:	73 e2                	jae    8024a9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024ca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8024ce:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8024d1:	99                   	cltd   
  8024d2:	c1 ea 1b             	shr    $0x1b,%edx
  8024d5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8024d8:	83 e1 1f             	and    $0x1f,%ecx
  8024db:	29 d1                	sub    %edx,%ecx
  8024dd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8024e1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8024e5:	83 c0 01             	add    $0x1,%eax
  8024e8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024eb:	83 c7 01             	add    $0x1,%edi
  8024ee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8024f1:	75 c8                	jne    8024bb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8024f3:	89 f8                	mov    %edi,%eax
  8024f5:	eb 05                	jmp    8024fc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024f7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8024fc:	83 c4 1c             	add    $0x1c,%esp
  8024ff:	5b                   	pop    %ebx
  802500:	5e                   	pop    %esi
  802501:	5f                   	pop    %edi
  802502:	5d                   	pop    %ebp
  802503:	c3                   	ret    

00802504 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802504:	55                   	push   %ebp
  802505:	89 e5                	mov    %esp,%ebp
  802507:	57                   	push   %edi
  802508:	56                   	push   %esi
  802509:	53                   	push   %ebx
  80250a:	83 ec 1c             	sub    $0x1c,%esp
  80250d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802510:	89 3c 24             	mov    %edi,(%esp)
  802513:	e8 a8 f0 ff ff       	call   8015c0 <fd2data>
  802518:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80251a:	be 00 00 00 00       	mov    $0x0,%esi
  80251f:	eb 3d                	jmp    80255e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802521:	85 f6                	test   %esi,%esi
  802523:	74 04                	je     802529 <devpipe_read+0x25>
				return i;
  802525:	89 f0                	mov    %esi,%eax
  802527:	eb 43                	jmp    80256c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802529:	89 da                	mov    %ebx,%edx
  80252b:	89 f8                	mov    %edi,%eax
  80252d:	e8 f1 fe ff ff       	call   802423 <_pipeisclosed>
  802532:	85 c0                	test   %eax,%eax
  802534:	75 31                	jne    802567 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802536:	e8 09 e9 ff ff       	call   800e44 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80253b:	8b 03                	mov    (%ebx),%eax
  80253d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802540:	74 df                	je     802521 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802542:	99                   	cltd   
  802543:	c1 ea 1b             	shr    $0x1b,%edx
  802546:	01 d0                	add    %edx,%eax
  802548:	83 e0 1f             	and    $0x1f,%eax
  80254b:	29 d0                	sub    %edx,%eax
  80254d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802552:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802555:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802558:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80255b:	83 c6 01             	add    $0x1,%esi
  80255e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802561:	75 d8                	jne    80253b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802563:	89 f0                	mov    %esi,%eax
  802565:	eb 05                	jmp    80256c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802567:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80256c:	83 c4 1c             	add    $0x1c,%esp
  80256f:	5b                   	pop    %ebx
  802570:	5e                   	pop    %esi
  802571:	5f                   	pop    %edi
  802572:	5d                   	pop    %ebp
  802573:	c3                   	ret    

00802574 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
  802577:	56                   	push   %esi
  802578:	53                   	push   %ebx
  802579:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80257c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80257f:	89 04 24             	mov    %eax,(%esp)
  802582:	e8 50 f0 ff ff       	call   8015d7 <fd_alloc>
  802587:	89 c2                	mov    %eax,%edx
  802589:	85 d2                	test   %edx,%edx
  80258b:	0f 88 4d 01 00 00    	js     8026de <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802591:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802598:	00 
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a7:	e8 b7 e8 ff ff       	call   800e63 <sys_page_alloc>
  8025ac:	89 c2                	mov    %eax,%edx
  8025ae:	85 d2                	test   %edx,%edx
  8025b0:	0f 88 28 01 00 00    	js     8026de <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8025b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8025b9:	89 04 24             	mov    %eax,(%esp)
  8025bc:	e8 16 f0 ff ff       	call   8015d7 <fd_alloc>
  8025c1:	89 c3                	mov    %eax,%ebx
  8025c3:	85 c0                	test   %eax,%eax
  8025c5:	0f 88 fe 00 00 00    	js     8026c9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025cb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025d2:	00 
  8025d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025e1:	e8 7d e8 ff ff       	call   800e63 <sys_page_alloc>
  8025e6:	89 c3                	mov    %eax,%ebx
  8025e8:	85 c0                	test   %eax,%eax
  8025ea:	0f 88 d9 00 00 00    	js     8026c9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	89 04 24             	mov    %eax,(%esp)
  8025f6:	e8 c5 ef ff ff       	call   8015c0 <fd2data>
  8025fb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025fd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802604:	00 
  802605:	89 44 24 04          	mov    %eax,0x4(%esp)
  802609:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802610:	e8 4e e8 ff ff       	call   800e63 <sys_page_alloc>
  802615:	89 c3                	mov    %eax,%ebx
  802617:	85 c0                	test   %eax,%eax
  802619:	0f 88 97 00 00 00    	js     8026b6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80261f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802622:	89 04 24             	mov    %eax,(%esp)
  802625:	e8 96 ef ff ff       	call   8015c0 <fd2data>
  80262a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802631:	00 
  802632:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802636:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80263d:	00 
  80263e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802642:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802649:	e8 69 e8 ff ff       	call   800eb7 <sys_page_map>
  80264e:	89 c3                	mov    %eax,%ebx
  802650:	85 c0                	test   %eax,%eax
  802652:	78 52                	js     8026a6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802654:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802669:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80266f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802672:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802677:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	89 04 24             	mov    %eax,(%esp)
  802684:	e8 27 ef ff ff       	call   8015b0 <fd2num>
  802689:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80268c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80268e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802691:	89 04 24             	mov    %eax,(%esp)
  802694:	e8 17 ef ff ff       	call   8015b0 <fd2num>
  802699:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80269c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80269f:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a4:	eb 38                	jmp    8026de <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8026a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b1:	e8 54 e8 ff ff       	call   800f0a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8026b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c4:	e8 41 e8 ff ff       	call   800f0a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026d7:	e8 2e e8 ff ff       	call   800f0a <sys_page_unmap>
  8026dc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8026de:	83 c4 30             	add    $0x30,%esp
  8026e1:	5b                   	pop    %ebx
  8026e2:	5e                   	pop    %esi
  8026e3:	5d                   	pop    %ebp
  8026e4:	c3                   	ret    

008026e5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8026e5:	55                   	push   %ebp
  8026e6:	89 e5                	mov    %esp,%ebp
  8026e8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	89 04 24             	mov    %eax,(%esp)
  8026f8:	e8 29 ef ff ff       	call   801626 <fd_lookup>
  8026fd:	89 c2                	mov    %eax,%edx
  8026ff:	85 d2                	test   %edx,%edx
  802701:	78 15                	js     802718 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	89 04 24             	mov    %eax,(%esp)
  802709:	e8 b2 ee ff ff       	call   8015c0 <fd2data>
	return _pipeisclosed(fd, p);
  80270e:	89 c2                	mov    %eax,%edx
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	e8 0b fd ff ff       	call   802423 <_pipeisclosed>
}
  802718:	c9                   	leave  
  802719:	c3                   	ret    
  80271a:	66 90                	xchg   %ax,%ax
  80271c:	66 90                	xchg   %ax,%ax
  80271e:	66 90                	xchg   %ax,%ax

00802720 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802723:	b8 00 00 00 00       	mov    $0x0,%eax
  802728:	5d                   	pop    %ebp
  802729:	c3                   	ret    

0080272a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802730:	c7 44 24 04 9a 33 80 	movl   $0x80339a,0x4(%esp)
  802737:	00 
  802738:	8b 45 0c             	mov    0xc(%ebp),%eax
  80273b:	89 04 24             	mov    %eax,(%esp)
  80273e:	e8 04 e3 ff ff       	call   800a47 <strcpy>
	return 0;
}
  802743:	b8 00 00 00 00       	mov    $0x0,%eax
  802748:	c9                   	leave  
  802749:	c3                   	ret    

0080274a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80274a:	55                   	push   %ebp
  80274b:	89 e5                	mov    %esp,%ebp
  80274d:	57                   	push   %edi
  80274e:	56                   	push   %esi
  80274f:	53                   	push   %ebx
  802750:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802756:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80275b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802761:	eb 31                	jmp    802794 <devcons_write+0x4a>
		m = n - tot;
  802763:	8b 75 10             	mov    0x10(%ebp),%esi
  802766:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802768:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80276b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802770:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802773:	89 74 24 08          	mov    %esi,0x8(%esp)
  802777:	03 45 0c             	add    0xc(%ebp),%eax
  80277a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80277e:	89 3c 24             	mov    %edi,(%esp)
  802781:	e8 5e e4 ff ff       	call   800be4 <memmove>
		sys_cputs(buf, m);
  802786:	89 74 24 04          	mov    %esi,0x4(%esp)
  80278a:	89 3c 24             	mov    %edi,(%esp)
  80278d:	e8 04 e6 ff ff       	call   800d96 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802792:	01 f3                	add    %esi,%ebx
  802794:	89 d8                	mov    %ebx,%eax
  802796:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802799:	72 c8                	jb     802763 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80279b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8027a1:	5b                   	pop    %ebx
  8027a2:	5e                   	pop    %esi
  8027a3:	5f                   	pop    %edi
  8027a4:	5d                   	pop    %ebp
  8027a5:	c3                   	ret    

008027a6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027a6:	55                   	push   %ebp
  8027a7:	89 e5                	mov    %esp,%ebp
  8027a9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8027ac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8027b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027b5:	75 07                	jne    8027be <devcons_read+0x18>
  8027b7:	eb 2a                	jmp    8027e3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8027b9:	e8 86 e6 ff ff       	call   800e44 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8027be:	66 90                	xchg   %ax,%ax
  8027c0:	e8 ef e5 ff ff       	call   800db4 <sys_cgetc>
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	74 f0                	je     8027b9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	78 16                	js     8027e3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8027cd:	83 f8 04             	cmp    $0x4,%eax
  8027d0:	74 0c                	je     8027de <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8027d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d5:	88 02                	mov    %al,(%edx)
	return 1;
  8027d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8027dc:	eb 05                	jmp    8027e3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8027de:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8027e3:	c9                   	leave  
  8027e4:	c3                   	ret    

008027e5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8027e5:	55                   	push   %ebp
  8027e6:	89 e5                	mov    %esp,%ebp
  8027e8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8027eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8027f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8027f8:	00 
  8027f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027fc:	89 04 24             	mov    %eax,(%esp)
  8027ff:	e8 92 e5 ff ff       	call   800d96 <sys_cputs>
}
  802804:	c9                   	leave  
  802805:	c3                   	ret    

00802806 <getchar>:

int
getchar(void)
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
  802809:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80280c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802813:	00 
  802814:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802817:	89 44 24 04          	mov    %eax,0x4(%esp)
  80281b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802822:	e8 93 f0 ff ff       	call   8018ba <read>
	if (r < 0)
  802827:	85 c0                	test   %eax,%eax
  802829:	78 0f                	js     80283a <getchar+0x34>
		return r;
	if (r < 1)
  80282b:	85 c0                	test   %eax,%eax
  80282d:	7e 06                	jle    802835 <getchar+0x2f>
		return -E_EOF;
	return c;
  80282f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802833:	eb 05                	jmp    80283a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802835:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80283a:	c9                   	leave  
  80283b:	c3                   	ret    

0080283c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
  80283f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802842:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802845:	89 44 24 04          	mov    %eax,0x4(%esp)
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	89 04 24             	mov    %eax,(%esp)
  80284f:	e8 d2 ed ff ff       	call   801626 <fd_lookup>
  802854:	85 c0                	test   %eax,%eax
  802856:	78 11                	js     802869 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802861:	39 10                	cmp    %edx,(%eax)
  802863:	0f 94 c0             	sete   %al
  802866:	0f b6 c0             	movzbl %al,%eax
}
  802869:	c9                   	leave  
  80286a:	c3                   	ret    

0080286b <opencons>:

int
opencons(void)
{
  80286b:	55                   	push   %ebp
  80286c:	89 e5                	mov    %esp,%ebp
  80286e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802871:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802874:	89 04 24             	mov    %eax,(%esp)
  802877:	e8 5b ed ff ff       	call   8015d7 <fd_alloc>
		return r;
  80287c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80287e:	85 c0                	test   %eax,%eax
  802880:	78 40                	js     8028c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802882:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802889:	00 
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802891:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802898:	e8 c6 e5 ff ff       	call   800e63 <sys_page_alloc>
		return r;
  80289d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80289f:	85 c0                	test   %eax,%eax
  8028a1:	78 1f                	js     8028c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8028a3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028b8:	89 04 24             	mov    %eax,(%esp)
  8028bb:	e8 f0 ec ff ff       	call   8015b0 <fd2num>
  8028c0:	89 c2                	mov    %eax,%edx
}
  8028c2:	89 d0                	mov    %edx,%eax
  8028c4:	c9                   	leave  
  8028c5:	c3                   	ret    

008028c6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8028c6:	55                   	push   %ebp
  8028c7:	89 e5                	mov    %esp,%ebp
  8028c9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8028cc:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8028d3:	75 68                	jne    80293d <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  8028d5:	a1 08 50 80 00       	mov    0x805008,%eax
  8028da:	8b 40 48             	mov    0x48(%eax),%eax
  8028dd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8028e4:	00 
  8028e5:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8028ec:	ee 
  8028ed:	89 04 24             	mov    %eax,(%esp)
  8028f0:	e8 6e e5 ff ff       	call   800e63 <sys_page_alloc>
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 2c                	je     802925 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  8028f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028fd:	c7 04 24 a8 33 80 00 	movl   $0x8033a8,(%esp)
  802904:	e8 0e db ff ff       	call   800417 <cprintf>
			panic("set_pg_fault_handler");
  802909:	c7 44 24 08 dc 33 80 	movl   $0x8033dc,0x8(%esp)
  802910:	00 
  802911:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802918:	00 
  802919:	c7 04 24 f1 33 80 00 	movl   $0x8033f1,(%esp)
  802920:	e8 f9 d9 ff ff       	call   80031e <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  802925:	a1 08 50 80 00       	mov    0x805008,%eax
  80292a:	8b 40 48             	mov    0x48(%eax),%eax
  80292d:	c7 44 24 04 47 29 80 	movl   $0x802947,0x4(%esp)
  802934:	00 
  802935:	89 04 24             	mov    %eax,(%esp)
  802938:	e8 c6 e6 ff ff       	call   801003 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80293d:	8b 45 08             	mov    0x8(%ebp),%eax
  802940:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802945:	c9                   	leave  
  802946:	c3                   	ret    

00802947 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802947:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802948:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80294d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80294f:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  802952:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  802956:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  802958:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  80295c:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  80295d:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  802960:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  802962:	58                   	pop    %eax
	popl %eax
  802963:	58                   	pop    %eax
	popal
  802964:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802965:	83 c4 04             	add    $0x4,%esp
	popfl
  802968:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802969:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80296a:	c3                   	ret    
  80296b:	66 90                	xchg   %ax,%ax
  80296d:	66 90                	xchg   %ax,%ax
  80296f:	90                   	nop

00802970 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
  802973:	56                   	push   %esi
  802974:	53                   	push   %ebx
  802975:	83 ec 10             	sub    $0x10,%esp
  802978:	8b 75 08             	mov    0x8(%ebp),%esi
  80297b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80297e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802981:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802983:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802988:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80298b:	89 04 24             	mov    %eax,(%esp)
  80298e:	e8 e6 e6 ff ff       	call   801079 <sys_ipc_recv>
  802993:	85 c0                	test   %eax,%eax
  802995:	74 16                	je     8029ad <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802997:	85 f6                	test   %esi,%esi
  802999:	74 06                	je     8029a1 <ipc_recv+0x31>
			*from_env_store = 0;
  80299b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8029a1:	85 db                	test   %ebx,%ebx
  8029a3:	74 2c                	je     8029d1 <ipc_recv+0x61>
			*perm_store = 0;
  8029a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8029ab:	eb 24                	jmp    8029d1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8029ad:	85 f6                	test   %esi,%esi
  8029af:	74 0a                	je     8029bb <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8029b1:	a1 08 50 80 00       	mov    0x805008,%eax
  8029b6:	8b 40 74             	mov    0x74(%eax),%eax
  8029b9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8029bb:	85 db                	test   %ebx,%ebx
  8029bd:	74 0a                	je     8029c9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8029bf:	a1 08 50 80 00       	mov    0x805008,%eax
  8029c4:	8b 40 78             	mov    0x78(%eax),%eax
  8029c7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8029c9:	a1 08 50 80 00       	mov    0x805008,%eax
  8029ce:	8b 40 70             	mov    0x70(%eax),%eax
}
  8029d1:	83 c4 10             	add    $0x10,%esp
  8029d4:	5b                   	pop    %ebx
  8029d5:	5e                   	pop    %esi
  8029d6:	5d                   	pop    %ebp
  8029d7:	c3                   	ret    

008029d8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8029d8:	55                   	push   %ebp
  8029d9:	89 e5                	mov    %esp,%ebp
  8029db:	57                   	push   %edi
  8029dc:	56                   	push   %esi
  8029dd:	53                   	push   %ebx
  8029de:	83 ec 1c             	sub    $0x1c,%esp
  8029e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8029e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8029e7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8029ea:	85 db                	test   %ebx,%ebx
  8029ec:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8029f1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8029f4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	89 04 24             	mov    %eax,(%esp)
  802a06:	e8 4b e6 ff ff       	call   801056 <sys_ipc_try_send>
	if (r == 0) return;
  802a0b:	85 c0                	test   %eax,%eax
  802a0d:	75 22                	jne    802a31 <ipc_send+0x59>
  802a0f:	eb 4c                	jmp    802a5d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802a11:	84 d2                	test   %dl,%dl
  802a13:	75 48                	jne    802a5d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802a15:	e8 2a e4 ff ff       	call   800e44 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  802a1a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a1e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a22:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	89 04 24             	mov    %eax,(%esp)
  802a2c:	e8 25 e6 ff ff       	call   801056 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802a31:	85 c0                	test   %eax,%eax
  802a33:	0f 94 c2             	sete   %dl
  802a36:	74 d9                	je     802a11 <ipc_send+0x39>
  802a38:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a3b:	74 d4                	je     802a11 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  802a3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a41:	c7 44 24 08 ff 33 80 	movl   $0x8033ff,0x8(%esp)
  802a48:	00 
  802a49:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802a50:	00 
  802a51:	c7 04 24 0d 34 80 00 	movl   $0x80340d,(%esp)
  802a58:	e8 c1 d8 ff ff       	call   80031e <_panic>
}
  802a5d:	83 c4 1c             	add    $0x1c,%esp
  802a60:	5b                   	pop    %ebx
  802a61:	5e                   	pop    %esi
  802a62:	5f                   	pop    %edi
  802a63:	5d                   	pop    %ebp
  802a64:	c3                   	ret    

00802a65 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802a65:	55                   	push   %ebp
  802a66:	89 e5                	mov    %esp,%ebp
  802a68:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802a6b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802a70:	89 c2                	mov    %eax,%edx
  802a72:	c1 e2 07             	shl    $0x7,%edx
  802a75:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802a7b:	8b 52 50             	mov    0x50(%edx),%edx
  802a7e:	39 ca                	cmp    %ecx,%edx
  802a80:	75 0d                	jne    802a8f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802a82:	c1 e0 07             	shl    $0x7,%eax
  802a85:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802a8a:	8b 40 40             	mov    0x40(%eax),%eax
  802a8d:	eb 0e                	jmp    802a9d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802a8f:	83 c0 01             	add    $0x1,%eax
  802a92:	3d 00 04 00 00       	cmp    $0x400,%eax
  802a97:	75 d7                	jne    802a70 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802a99:	66 b8 00 00          	mov    $0x0,%ax
}
  802a9d:	5d                   	pop    %ebp
  802a9e:	c3                   	ret    

00802a9f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a9f:	55                   	push   %ebp
  802aa0:	89 e5                	mov    %esp,%ebp
  802aa2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802aa5:	89 d0                	mov    %edx,%eax
  802aa7:	c1 e8 16             	shr    $0x16,%eax
  802aaa:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802ab1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ab6:	f6 c1 01             	test   $0x1,%cl
  802ab9:	74 1d                	je     802ad8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802abb:	c1 ea 0c             	shr    $0xc,%edx
  802abe:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802ac5:	f6 c2 01             	test   $0x1,%dl
  802ac8:	74 0e                	je     802ad8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802aca:	c1 ea 0c             	shr    $0xc,%edx
  802acd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802ad4:	ef 
  802ad5:	0f b7 c0             	movzwl %ax,%eax
}
  802ad8:	5d                   	pop    %ebp
  802ad9:	c3                   	ret    
  802ada:	66 90                	xchg   %ax,%ax
  802adc:	66 90                	xchg   %ax,%ax
  802ade:	66 90                	xchg   %ax,%ax

00802ae0 <__udivdi3>:
  802ae0:	55                   	push   %ebp
  802ae1:	57                   	push   %edi
  802ae2:	56                   	push   %esi
  802ae3:	83 ec 0c             	sub    $0xc,%esp
  802ae6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802aea:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802aee:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802af2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802af6:	85 c0                	test   %eax,%eax
  802af8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802afc:	89 ea                	mov    %ebp,%edx
  802afe:	89 0c 24             	mov    %ecx,(%esp)
  802b01:	75 2d                	jne    802b30 <__udivdi3+0x50>
  802b03:	39 e9                	cmp    %ebp,%ecx
  802b05:	77 61                	ja     802b68 <__udivdi3+0x88>
  802b07:	85 c9                	test   %ecx,%ecx
  802b09:	89 ce                	mov    %ecx,%esi
  802b0b:	75 0b                	jne    802b18 <__udivdi3+0x38>
  802b0d:	b8 01 00 00 00       	mov    $0x1,%eax
  802b12:	31 d2                	xor    %edx,%edx
  802b14:	f7 f1                	div    %ecx
  802b16:	89 c6                	mov    %eax,%esi
  802b18:	31 d2                	xor    %edx,%edx
  802b1a:	89 e8                	mov    %ebp,%eax
  802b1c:	f7 f6                	div    %esi
  802b1e:	89 c5                	mov    %eax,%ebp
  802b20:	89 f8                	mov    %edi,%eax
  802b22:	f7 f6                	div    %esi
  802b24:	89 ea                	mov    %ebp,%edx
  802b26:	83 c4 0c             	add    $0xc,%esp
  802b29:	5e                   	pop    %esi
  802b2a:	5f                   	pop    %edi
  802b2b:	5d                   	pop    %ebp
  802b2c:	c3                   	ret    
  802b2d:	8d 76 00             	lea    0x0(%esi),%esi
  802b30:	39 e8                	cmp    %ebp,%eax
  802b32:	77 24                	ja     802b58 <__udivdi3+0x78>
  802b34:	0f bd e8             	bsr    %eax,%ebp
  802b37:	83 f5 1f             	xor    $0x1f,%ebp
  802b3a:	75 3c                	jne    802b78 <__udivdi3+0x98>
  802b3c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802b40:	39 34 24             	cmp    %esi,(%esp)
  802b43:	0f 86 9f 00 00 00    	jbe    802be8 <__udivdi3+0x108>
  802b49:	39 d0                	cmp    %edx,%eax
  802b4b:	0f 82 97 00 00 00    	jb     802be8 <__udivdi3+0x108>
  802b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b58:	31 d2                	xor    %edx,%edx
  802b5a:	31 c0                	xor    %eax,%eax
  802b5c:	83 c4 0c             	add    $0xc,%esp
  802b5f:	5e                   	pop    %esi
  802b60:	5f                   	pop    %edi
  802b61:	5d                   	pop    %ebp
  802b62:	c3                   	ret    
  802b63:	90                   	nop
  802b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b68:	89 f8                	mov    %edi,%eax
  802b6a:	f7 f1                	div    %ecx
  802b6c:	31 d2                	xor    %edx,%edx
  802b6e:	83 c4 0c             	add    $0xc,%esp
  802b71:	5e                   	pop    %esi
  802b72:	5f                   	pop    %edi
  802b73:	5d                   	pop    %ebp
  802b74:	c3                   	ret    
  802b75:	8d 76 00             	lea    0x0(%esi),%esi
  802b78:	89 e9                	mov    %ebp,%ecx
  802b7a:	8b 3c 24             	mov    (%esp),%edi
  802b7d:	d3 e0                	shl    %cl,%eax
  802b7f:	89 c6                	mov    %eax,%esi
  802b81:	b8 20 00 00 00       	mov    $0x20,%eax
  802b86:	29 e8                	sub    %ebp,%eax
  802b88:	89 c1                	mov    %eax,%ecx
  802b8a:	d3 ef                	shr    %cl,%edi
  802b8c:	89 e9                	mov    %ebp,%ecx
  802b8e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802b92:	8b 3c 24             	mov    (%esp),%edi
  802b95:	09 74 24 08          	or     %esi,0x8(%esp)
  802b99:	89 d6                	mov    %edx,%esi
  802b9b:	d3 e7                	shl    %cl,%edi
  802b9d:	89 c1                	mov    %eax,%ecx
  802b9f:	89 3c 24             	mov    %edi,(%esp)
  802ba2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ba6:	d3 ee                	shr    %cl,%esi
  802ba8:	89 e9                	mov    %ebp,%ecx
  802baa:	d3 e2                	shl    %cl,%edx
  802bac:	89 c1                	mov    %eax,%ecx
  802bae:	d3 ef                	shr    %cl,%edi
  802bb0:	09 d7                	or     %edx,%edi
  802bb2:	89 f2                	mov    %esi,%edx
  802bb4:	89 f8                	mov    %edi,%eax
  802bb6:	f7 74 24 08          	divl   0x8(%esp)
  802bba:	89 d6                	mov    %edx,%esi
  802bbc:	89 c7                	mov    %eax,%edi
  802bbe:	f7 24 24             	mull   (%esp)
  802bc1:	39 d6                	cmp    %edx,%esi
  802bc3:	89 14 24             	mov    %edx,(%esp)
  802bc6:	72 30                	jb     802bf8 <__udivdi3+0x118>
  802bc8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802bcc:	89 e9                	mov    %ebp,%ecx
  802bce:	d3 e2                	shl    %cl,%edx
  802bd0:	39 c2                	cmp    %eax,%edx
  802bd2:	73 05                	jae    802bd9 <__udivdi3+0xf9>
  802bd4:	3b 34 24             	cmp    (%esp),%esi
  802bd7:	74 1f                	je     802bf8 <__udivdi3+0x118>
  802bd9:	89 f8                	mov    %edi,%eax
  802bdb:	31 d2                	xor    %edx,%edx
  802bdd:	e9 7a ff ff ff       	jmp    802b5c <__udivdi3+0x7c>
  802be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802be8:	31 d2                	xor    %edx,%edx
  802bea:	b8 01 00 00 00       	mov    $0x1,%eax
  802bef:	e9 68 ff ff ff       	jmp    802b5c <__udivdi3+0x7c>
  802bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bf8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802bfb:	31 d2                	xor    %edx,%edx
  802bfd:	83 c4 0c             	add    $0xc,%esp
  802c00:	5e                   	pop    %esi
  802c01:	5f                   	pop    %edi
  802c02:	5d                   	pop    %ebp
  802c03:	c3                   	ret    
  802c04:	66 90                	xchg   %ax,%ax
  802c06:	66 90                	xchg   %ax,%ax
  802c08:	66 90                	xchg   %ax,%ax
  802c0a:	66 90                	xchg   %ax,%ax
  802c0c:	66 90                	xchg   %ax,%ax
  802c0e:	66 90                	xchg   %ax,%ax

00802c10 <__umoddi3>:
  802c10:	55                   	push   %ebp
  802c11:	57                   	push   %edi
  802c12:	56                   	push   %esi
  802c13:	83 ec 14             	sub    $0x14,%esp
  802c16:	8b 44 24 28          	mov    0x28(%esp),%eax
  802c1a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802c1e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802c22:	89 c7                	mov    %eax,%edi
  802c24:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c28:	8b 44 24 30          	mov    0x30(%esp),%eax
  802c2c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802c30:	89 34 24             	mov    %esi,(%esp)
  802c33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c37:	85 c0                	test   %eax,%eax
  802c39:	89 c2                	mov    %eax,%edx
  802c3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c3f:	75 17                	jne    802c58 <__umoddi3+0x48>
  802c41:	39 fe                	cmp    %edi,%esi
  802c43:	76 4b                	jbe    802c90 <__umoddi3+0x80>
  802c45:	89 c8                	mov    %ecx,%eax
  802c47:	89 fa                	mov    %edi,%edx
  802c49:	f7 f6                	div    %esi
  802c4b:	89 d0                	mov    %edx,%eax
  802c4d:	31 d2                	xor    %edx,%edx
  802c4f:	83 c4 14             	add    $0x14,%esp
  802c52:	5e                   	pop    %esi
  802c53:	5f                   	pop    %edi
  802c54:	5d                   	pop    %ebp
  802c55:	c3                   	ret    
  802c56:	66 90                	xchg   %ax,%ax
  802c58:	39 f8                	cmp    %edi,%eax
  802c5a:	77 54                	ja     802cb0 <__umoddi3+0xa0>
  802c5c:	0f bd e8             	bsr    %eax,%ebp
  802c5f:	83 f5 1f             	xor    $0x1f,%ebp
  802c62:	75 5c                	jne    802cc0 <__umoddi3+0xb0>
  802c64:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802c68:	39 3c 24             	cmp    %edi,(%esp)
  802c6b:	0f 87 e7 00 00 00    	ja     802d58 <__umoddi3+0x148>
  802c71:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c75:	29 f1                	sub    %esi,%ecx
  802c77:	19 c7                	sbb    %eax,%edi
  802c79:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c7d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c81:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c85:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802c89:	83 c4 14             	add    $0x14,%esp
  802c8c:	5e                   	pop    %esi
  802c8d:	5f                   	pop    %edi
  802c8e:	5d                   	pop    %ebp
  802c8f:	c3                   	ret    
  802c90:	85 f6                	test   %esi,%esi
  802c92:	89 f5                	mov    %esi,%ebp
  802c94:	75 0b                	jne    802ca1 <__umoddi3+0x91>
  802c96:	b8 01 00 00 00       	mov    $0x1,%eax
  802c9b:	31 d2                	xor    %edx,%edx
  802c9d:	f7 f6                	div    %esi
  802c9f:	89 c5                	mov    %eax,%ebp
  802ca1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802ca5:	31 d2                	xor    %edx,%edx
  802ca7:	f7 f5                	div    %ebp
  802ca9:	89 c8                	mov    %ecx,%eax
  802cab:	f7 f5                	div    %ebp
  802cad:	eb 9c                	jmp    802c4b <__umoddi3+0x3b>
  802caf:	90                   	nop
  802cb0:	89 c8                	mov    %ecx,%eax
  802cb2:	89 fa                	mov    %edi,%edx
  802cb4:	83 c4 14             	add    $0x14,%esp
  802cb7:	5e                   	pop    %esi
  802cb8:	5f                   	pop    %edi
  802cb9:	5d                   	pop    %ebp
  802cba:	c3                   	ret    
  802cbb:	90                   	nop
  802cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cc0:	8b 04 24             	mov    (%esp),%eax
  802cc3:	be 20 00 00 00       	mov    $0x20,%esi
  802cc8:	89 e9                	mov    %ebp,%ecx
  802cca:	29 ee                	sub    %ebp,%esi
  802ccc:	d3 e2                	shl    %cl,%edx
  802cce:	89 f1                	mov    %esi,%ecx
  802cd0:	d3 e8                	shr    %cl,%eax
  802cd2:	89 e9                	mov    %ebp,%ecx
  802cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cd8:	8b 04 24             	mov    (%esp),%eax
  802cdb:	09 54 24 04          	or     %edx,0x4(%esp)
  802cdf:	89 fa                	mov    %edi,%edx
  802ce1:	d3 e0                	shl    %cl,%eax
  802ce3:	89 f1                	mov    %esi,%ecx
  802ce5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ce9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802ced:	d3 ea                	shr    %cl,%edx
  802cef:	89 e9                	mov    %ebp,%ecx
  802cf1:	d3 e7                	shl    %cl,%edi
  802cf3:	89 f1                	mov    %esi,%ecx
  802cf5:	d3 e8                	shr    %cl,%eax
  802cf7:	89 e9                	mov    %ebp,%ecx
  802cf9:	09 f8                	or     %edi,%eax
  802cfb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802cff:	f7 74 24 04          	divl   0x4(%esp)
  802d03:	d3 e7                	shl    %cl,%edi
  802d05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d09:	89 d7                	mov    %edx,%edi
  802d0b:	f7 64 24 08          	mull   0x8(%esp)
  802d0f:	39 d7                	cmp    %edx,%edi
  802d11:	89 c1                	mov    %eax,%ecx
  802d13:	89 14 24             	mov    %edx,(%esp)
  802d16:	72 2c                	jb     802d44 <__umoddi3+0x134>
  802d18:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802d1c:	72 22                	jb     802d40 <__umoddi3+0x130>
  802d1e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802d22:	29 c8                	sub    %ecx,%eax
  802d24:	19 d7                	sbb    %edx,%edi
  802d26:	89 e9                	mov    %ebp,%ecx
  802d28:	89 fa                	mov    %edi,%edx
  802d2a:	d3 e8                	shr    %cl,%eax
  802d2c:	89 f1                	mov    %esi,%ecx
  802d2e:	d3 e2                	shl    %cl,%edx
  802d30:	89 e9                	mov    %ebp,%ecx
  802d32:	d3 ef                	shr    %cl,%edi
  802d34:	09 d0                	or     %edx,%eax
  802d36:	89 fa                	mov    %edi,%edx
  802d38:	83 c4 14             	add    $0x14,%esp
  802d3b:	5e                   	pop    %esi
  802d3c:	5f                   	pop    %edi
  802d3d:	5d                   	pop    %ebp
  802d3e:	c3                   	ret    
  802d3f:	90                   	nop
  802d40:	39 d7                	cmp    %edx,%edi
  802d42:	75 da                	jne    802d1e <__umoddi3+0x10e>
  802d44:	8b 14 24             	mov    (%esp),%edx
  802d47:	89 c1                	mov    %eax,%ecx
  802d49:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802d4d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802d51:	eb cb                	jmp    802d1e <__umoddi3+0x10e>
  802d53:	90                   	nop
  802d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d58:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802d5c:	0f 82 0f ff ff ff    	jb     802c71 <__umoddi3+0x61>
  802d62:	e9 1a ff ff ff       	jmp    802c81 <__umoddi3+0x71>
