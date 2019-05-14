
obj/user/testpipe.debug:     file format elf32-i386


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
  80002c:	e8 e4 02 00 00       	call   800315 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 c4 80             	add    $0xffffff80,%esp
	char buf[100];
	int i, pid, p[2];

	binaryname = "pipereadeof";
  80003b:	c7 05 04 40 80 00 20 	movl   $0x802e20,0x804004
  800042:	2e 80 00 

	if ((i = pipe(p)) < 0)
  800045:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 74 25 00 00       	call   8025c4 <pipe>
  800050:	89 c6                	mov    %eax,%esi
  800052:	85 c0                	test   %eax,%eax
  800054:	79 20                	jns    800076 <umain+0x43>
		panic("pipe: %e", i);
  800056:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005a:	c7 44 24 08 2c 2e 80 	movl   $0x802e2c,0x8(%esp)
  800061:	00 
  800062:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  800069:	00 
  80006a:	c7 04 24 35 2e 80 00 	movl   $0x802e35,(%esp)
  800071:	e8 00 03 00 00       	call   800376 <_panic>

	if ((pid = fork()) < 0)
  800076:	e8 85 12 00 00       	call   801300 <fork>
  80007b:	89 c3                	mov    %eax,%ebx
  80007d:	85 c0                	test   %eax,%eax
  80007f:	79 20                	jns    8000a1 <umain+0x6e>
		panic("fork: %e", i);
  800081:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800085:	c7 44 24 08 45 2e 80 	movl   $0x802e45,0x8(%esp)
  80008c:	00 
  80008d:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800094:	00 
  800095:	c7 04 24 35 2e 80 00 	movl   $0x802e35,(%esp)
  80009c:	e8 d5 02 00 00       	call   800376 <_panic>

	if (pid == 0) {
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	0f 85 d5 00 00 00    	jne    80017e <umain+0x14b>
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[1]);
  8000a9:	a1 08 50 80 00       	mov    0x805008,%eax
  8000ae:	8b 40 48             	mov    0x48(%eax),%eax
  8000b1:	8b 55 90             	mov    -0x70(%ebp),%edx
  8000b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bc:	c7 04 24 4e 2e 80 00 	movl   $0x802e4e,(%esp)
  8000c3:	e8 a7 03 00 00       	call   80046f <cprintf>
		close(p[1]);
  8000c8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000cb:	89 04 24             	mov    %eax,(%esp)
  8000ce:	e8 d4 16 00 00       	call   8017a7 <close>
		cprintf("[%08x] pipereadeof readn %d\n", thisenv->env_id, p[0]);
  8000d3:	a1 08 50 80 00       	mov    0x805008,%eax
  8000d8:	8b 40 48             	mov    0x48(%eax),%eax
  8000db:	8b 55 8c             	mov    -0x74(%ebp),%edx
  8000de:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e6:	c7 04 24 6b 2e 80 00 	movl   $0x802e6b,(%esp)
  8000ed:	e8 7d 03 00 00       	call   80046f <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000f2:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000f9:	00 
  8000fa:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800101:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800104:	89 04 24             	mov    %eax,(%esp)
  800107:	e8 90 18 00 00       	call   80199c <readn>
  80010c:	89 c6                	mov    %eax,%esi
		if (i < 0)
  80010e:	85 c0                	test   %eax,%eax
  800110:	79 20                	jns    800132 <umain+0xff>
			panic("read: %e", i);
  800112:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800116:	c7 44 24 08 88 2e 80 	movl   $0x802e88,0x8(%esp)
  80011d:	00 
  80011e:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  800125:	00 
  800126:	c7 04 24 35 2e 80 00 	movl   $0x802e35,(%esp)
  80012d:	e8 44 02 00 00       	call   800376 <_panic>
		buf[i] = 0;
  800132:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  800137:	a1 00 40 80 00       	mov    0x804000,%eax
  80013c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800140:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800143:	89 04 24             	mov    %eax,(%esp)
  800146:	e8 01 0a 00 00       	call   800b4c <strcmp>
  80014b:	85 c0                	test   %eax,%eax
  80014d:	75 0e                	jne    80015d <umain+0x12a>
			cprintf("\npipe read closed properly\n");
  80014f:	c7 04 24 91 2e 80 00 	movl   $0x802e91,(%esp)
  800156:	e8 14 03 00 00       	call   80046f <cprintf>
  80015b:	eb 17                	jmp    800174 <umain+0x141>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  80015d:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800160:	89 44 24 08          	mov    %eax,0x8(%esp)
  800164:	89 74 24 04          	mov    %esi,0x4(%esp)
  800168:	c7 04 24 ad 2e 80 00 	movl   $0x802ead,(%esp)
  80016f:	e8 fb 02 00 00       	call   80046f <cprintf>
		exit();
  800174:	e8 e4 01 00 00       	call   80035d <exit>
  800179:	e9 ac 00 00 00       	jmp    80022a <umain+0x1f7>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", thisenv->env_id, p[0]);
  80017e:	a1 08 50 80 00       	mov    0x805008,%eax
  800183:	8b 40 48             	mov    0x48(%eax),%eax
  800186:	8b 55 8c             	mov    -0x74(%ebp),%edx
  800189:	89 54 24 08          	mov    %edx,0x8(%esp)
  80018d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800191:	c7 04 24 4e 2e 80 00 	movl   $0x802e4e,(%esp)
  800198:	e8 d2 02 00 00       	call   80046f <cprintf>
		close(p[0]);
  80019d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8001a0:	89 04 24             	mov    %eax,(%esp)
  8001a3:	e8 ff 15 00 00       	call   8017a7 <close>
		cprintf("[%08x] pipereadeof write %d\n", thisenv->env_id, p[1]);
  8001a8:	a1 08 50 80 00       	mov    0x805008,%eax
  8001ad:	8b 40 48             	mov    0x48(%eax),%eax
  8001b0:	8b 55 90             	mov    -0x70(%ebp),%edx
  8001b3:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001bb:	c7 04 24 c0 2e 80 00 	movl   $0x802ec0,(%esp)
  8001c2:	e8 a8 02 00 00       	call   80046f <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8001c7:	a1 00 40 80 00       	mov    0x804000,%eax
  8001cc:	89 04 24             	mov    %eax,(%esp)
  8001cf:	e8 8c 08 00 00       	call   800a60 <strlen>
  8001d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d8:	a1 00 40 80 00       	mov    0x804000,%eax
  8001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8001e4:	89 04 24             	mov    %eax,(%esp)
  8001e7:	e8 fb 17 00 00       	call   8019e7 <write>
  8001ec:	89 c6                	mov    %eax,%esi
  8001ee:	a1 00 40 80 00       	mov    0x804000,%eax
  8001f3:	89 04 24             	mov    %eax,(%esp)
  8001f6:	e8 65 08 00 00       	call   800a60 <strlen>
  8001fb:	39 c6                	cmp    %eax,%esi
  8001fd:	74 20                	je     80021f <umain+0x1ec>
			panic("write: %e", i);
  8001ff:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800203:	c7 44 24 08 dd 2e 80 	movl   $0x802edd,0x8(%esp)
  80020a:	00 
  80020b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800212:	00 
  800213:	c7 04 24 35 2e 80 00 	movl   $0x802e35,(%esp)
  80021a:	e8 57 01 00 00       	call   800376 <_panic>
		close(p[1]);
  80021f:	8b 45 90             	mov    -0x70(%ebp),%eax
  800222:	89 04 24             	mov    %eax,(%esp)
  800225:	e8 7d 15 00 00       	call   8017a7 <close>
	}
	wait(pid);
  80022a:	89 1c 24             	mov    %ebx,(%esp)
  80022d:	e8 38 25 00 00       	call   80276a <wait>

	binaryname = "pipewriteeof";
  800232:	c7 05 04 40 80 00 e7 	movl   $0x802ee7,0x804004
  800239:	2e 80 00 
	if ((i = pipe(p)) < 0)
  80023c:	8d 45 8c             	lea    -0x74(%ebp),%eax
  80023f:	89 04 24             	mov    %eax,(%esp)
  800242:	e8 7d 23 00 00       	call   8025c4 <pipe>
  800247:	89 c6                	mov    %eax,%esi
  800249:	85 c0                	test   %eax,%eax
  80024b:	79 20                	jns    80026d <umain+0x23a>
		panic("pipe: %e", i);
  80024d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800251:	c7 44 24 08 2c 2e 80 	movl   $0x802e2c,0x8(%esp)
  800258:	00 
  800259:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  800260:	00 
  800261:	c7 04 24 35 2e 80 00 	movl   $0x802e35,(%esp)
  800268:	e8 09 01 00 00       	call   800376 <_panic>

	if ((pid = fork()) < 0)
  80026d:	e8 8e 10 00 00       	call   801300 <fork>
  800272:	89 c3                	mov    %eax,%ebx
  800274:	85 c0                	test   %eax,%eax
  800276:	79 20                	jns    800298 <umain+0x265>
		panic("fork: %e", i);
  800278:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80027c:	c7 44 24 08 45 2e 80 	movl   $0x802e45,0x8(%esp)
  800283:	00 
  800284:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  80028b:	00 
  80028c:	c7 04 24 35 2e 80 00 	movl   $0x802e35,(%esp)
  800293:	e8 de 00 00 00       	call   800376 <_panic>

	if (pid == 0) {
  800298:	85 c0                	test   %eax,%eax
  80029a:	75 48                	jne    8002e4 <umain+0x2b1>
		close(p[0]);
  80029c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80029f:	89 04 24             	mov    %eax,(%esp)
  8002a2:	e8 00 15 00 00       	call   8017a7 <close>
		while (1) {
			cprintf(".");
  8002a7:	c7 04 24 f4 2e 80 00 	movl   $0x802ef4,(%esp)
  8002ae:	e8 bc 01 00 00       	call   80046f <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002b3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002ba:	00 
  8002bb:	c7 44 24 04 f6 2e 80 	movl   $0x802ef6,0x4(%esp)
  8002c2:	00 
  8002c3:	8b 55 90             	mov    -0x70(%ebp),%edx
  8002c6:	89 14 24             	mov    %edx,(%esp)
  8002c9:	e8 19 17 00 00       	call   8019e7 <write>
  8002ce:	83 f8 01             	cmp    $0x1,%eax
  8002d1:	74 d4                	je     8002a7 <umain+0x274>
				break;
		}
		cprintf("\npipe write closed properly\n");
  8002d3:	c7 04 24 f8 2e 80 00 	movl   $0x802ef8,(%esp)
  8002da:	e8 90 01 00 00       	call   80046f <cprintf>
		exit();
  8002df:	e8 79 00 00 00       	call   80035d <exit>
	}
	close(p[0]);
  8002e4:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002e7:	89 04 24             	mov    %eax,(%esp)
  8002ea:	e8 b8 14 00 00       	call   8017a7 <close>
	close(p[1]);
  8002ef:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002f2:	89 04 24             	mov    %eax,(%esp)
  8002f5:	e8 ad 14 00 00       	call   8017a7 <close>
	wait(pid);
  8002fa:	89 1c 24             	mov    %ebx,(%esp)
  8002fd:	e8 68 24 00 00       	call   80276a <wait>

	cprintf("pipe tests passed\n");
  800302:	c7 04 24 15 2f 80 00 	movl   $0x802f15,(%esp)
  800309:	e8 61 01 00 00       	call   80046f <cprintf>
}
  80030e:	83 ec 80             	sub    $0xffffff80,%esp
  800311:	5b                   	pop    %ebx
  800312:	5e                   	pop    %esi
  800313:	5d                   	pop    %ebp
  800314:	c3                   	ret    

00800315 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	56                   	push   %esi
  800319:	53                   	push   %ebx
  80031a:	83 ec 10             	sub    $0x10,%esp
  80031d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800320:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800323:	e8 4d 0b 00 00       	call   800e75 <sys_getenvid>
  800328:	25 ff 03 00 00       	and    $0x3ff,%eax
  80032d:	c1 e0 07             	shl    $0x7,%eax
  800330:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800335:	a3 08 50 80 00       	mov    %eax,0x805008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80033a:	85 db                	test   %ebx,%ebx
  80033c:	7e 07                	jle    800345 <libmain+0x30>
		binaryname = argv[0];
  80033e:	8b 06                	mov    (%esi),%eax
  800340:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  800345:	89 74 24 04          	mov    %esi,0x4(%esp)
  800349:	89 1c 24             	mov    %ebx,(%esp)
  80034c:	e8 e2 fc ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800351:	e8 07 00 00 00       	call   80035d <exit>
}
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	5b                   	pop    %ebx
  80035a:	5e                   	pop    %esi
  80035b:	5d                   	pop    %ebp
  80035c:	c3                   	ret    

0080035d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800363:	e8 72 14 00 00       	call   8017da <close_all>
	sys_env_destroy(0);
  800368:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80036f:	e8 af 0a 00 00       	call   800e23 <sys_env_destroy>
}
  800374:	c9                   	leave  
  800375:	c3                   	ret    

00800376 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
  800379:	56                   	push   %esi
  80037a:	53                   	push   %ebx
  80037b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80037e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800381:	8b 35 04 40 80 00    	mov    0x804004,%esi
  800387:	e8 e9 0a 00 00       	call   800e75 <sys_getenvid>
  80038c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80038f:	89 54 24 10          	mov    %edx,0x10(%esp)
  800393:	8b 55 08             	mov    0x8(%ebp),%edx
  800396:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80039a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80039e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a2:	c7 04 24 78 2f 80 00 	movl   $0x802f78,(%esp)
  8003a9:	e8 c1 00 00 00       	call   80046f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b5:	89 04 24             	mov    %eax,(%esp)
  8003b8:	e8 51 00 00 00       	call   80040e <vcprintf>
	cprintf("\n");
  8003bd:	c7 04 24 69 2e 80 00 	movl   $0x802e69,(%esp)
  8003c4:	e8 a6 00 00 00       	call   80046f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003c9:	cc                   	int3   
  8003ca:	eb fd                	jmp    8003c9 <_panic+0x53>

008003cc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8003cc:	55                   	push   %ebp
  8003cd:	89 e5                	mov    %esp,%ebp
  8003cf:	53                   	push   %ebx
  8003d0:	83 ec 14             	sub    $0x14,%esp
  8003d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003d6:	8b 13                	mov    (%ebx),%edx
  8003d8:	8d 42 01             	lea    0x1(%edx),%eax
  8003db:	89 03                	mov    %eax,(%ebx)
  8003dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003e0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8003e4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003e9:	75 19                	jne    800404 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8003eb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003f2:	00 
  8003f3:	8d 43 08             	lea    0x8(%ebx),%eax
  8003f6:	89 04 24             	mov    %eax,(%esp)
  8003f9:	e8 e8 09 00 00       	call   800de6 <sys_cputs>
		b->idx = 0;
  8003fe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800404:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800408:	83 c4 14             	add    $0x14,%esp
  80040b:	5b                   	pop    %ebx
  80040c:	5d                   	pop    %ebp
  80040d:	c3                   	ret    

0080040e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800417:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80041e:	00 00 00 
	b.cnt = 0;
  800421:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800428:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80042b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	89 44 24 08          	mov    %eax,0x8(%esp)
  800439:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800443:	c7 04 24 cc 03 80 00 	movl   $0x8003cc,(%esp)
  80044a:	e8 af 01 00 00       	call   8005fe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80044f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800455:	89 44 24 04          	mov    %eax,0x4(%esp)
  800459:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80045f:	89 04 24             	mov    %eax,(%esp)
  800462:	e8 7f 09 00 00       	call   800de6 <sys_cputs>

	return b.cnt;
}
  800467:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80046d:	c9                   	leave  
  80046e:	c3                   	ret    

0080046f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800475:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800478:	89 44 24 04          	mov    %eax,0x4(%esp)
  80047c:	8b 45 08             	mov    0x8(%ebp),%eax
  80047f:	89 04 24             	mov    %eax,(%esp)
  800482:	e8 87 ff ff ff       	call   80040e <vcprintf>
	va_end(ap);

	return cnt;
}
  800487:	c9                   	leave  
  800488:	c3                   	ret    
  800489:	66 90                	xchg   %ax,%ax
  80048b:	66 90                	xchg   %ax,%ax
  80048d:	66 90                	xchg   %ax,%ax
  80048f:	90                   	nop

00800490 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	57                   	push   %edi
  800494:	56                   	push   %esi
  800495:	53                   	push   %ebx
  800496:	83 ec 3c             	sub    $0x3c,%esp
  800499:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80049c:	89 d7                	mov    %edx,%edi
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a7:	89 c3                	mov    %eax,%ebx
  8004a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8004af:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004bd:	39 d9                	cmp    %ebx,%ecx
  8004bf:	72 05                	jb     8004c6 <printnum+0x36>
  8004c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004c4:	77 69                	ja     80052f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004c9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004cd:	83 ee 01             	sub    $0x1,%esi
  8004d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8004dc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8004e0:	89 c3                	mov    %eax,%ebx
  8004e2:	89 d6                	mov    %edx,%esi
  8004e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8004ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8004f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f5:	89 04 24             	mov    %eax,(%esp)
  8004f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ff:	e8 8c 26 00 00       	call   802b90 <__udivdi3>
  800504:	89 d9                	mov    %ebx,%ecx
  800506:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80050a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80050e:	89 04 24             	mov    %eax,(%esp)
  800511:	89 54 24 04          	mov    %edx,0x4(%esp)
  800515:	89 fa                	mov    %edi,%edx
  800517:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80051a:	e8 71 ff ff ff       	call   800490 <printnum>
  80051f:	eb 1b                	jmp    80053c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800521:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800525:	8b 45 18             	mov    0x18(%ebp),%eax
  800528:	89 04 24             	mov    %eax,(%esp)
  80052b:	ff d3                	call   *%ebx
  80052d:	eb 03                	jmp    800532 <printnum+0xa2>
  80052f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800532:	83 ee 01             	sub    $0x1,%esi
  800535:	85 f6                	test   %esi,%esi
  800537:	7f e8                	jg     800521 <printnum+0x91>
  800539:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80053c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800540:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800544:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800547:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80054a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80054e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800552:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800555:	89 04 24             	mov    %eax,(%esp)
  800558:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80055b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80055f:	e8 5c 27 00 00       	call   802cc0 <__umoddi3>
  800564:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800568:	0f be 80 9b 2f 80 00 	movsbl 0x802f9b(%eax),%eax
  80056f:	89 04 24             	mov    %eax,(%esp)
  800572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800575:	ff d0                	call   *%eax
}
  800577:	83 c4 3c             	add    $0x3c,%esp
  80057a:	5b                   	pop    %ebx
  80057b:	5e                   	pop    %esi
  80057c:	5f                   	pop    %edi
  80057d:	5d                   	pop    %ebp
  80057e:	c3                   	ret    

0080057f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80057f:	55                   	push   %ebp
  800580:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800582:	83 fa 01             	cmp    $0x1,%edx
  800585:	7e 0e                	jle    800595 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800587:	8b 10                	mov    (%eax),%edx
  800589:	8d 4a 08             	lea    0x8(%edx),%ecx
  80058c:	89 08                	mov    %ecx,(%eax)
  80058e:	8b 02                	mov    (%edx),%eax
  800590:	8b 52 04             	mov    0x4(%edx),%edx
  800593:	eb 22                	jmp    8005b7 <getuint+0x38>
	else if (lflag)
  800595:	85 d2                	test   %edx,%edx
  800597:	74 10                	je     8005a9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800599:	8b 10                	mov    (%eax),%edx
  80059b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80059e:	89 08                	mov    %ecx,(%eax)
  8005a0:	8b 02                	mov    (%edx),%eax
  8005a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a7:	eb 0e                	jmp    8005b7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005a9:	8b 10                	mov    (%eax),%edx
  8005ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005ae:	89 08                	mov    %ecx,(%eax)
  8005b0:	8b 02                	mov    (%edx),%eax
  8005b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005b7:	5d                   	pop    %ebp
  8005b8:	c3                   	ret    

008005b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005b9:	55                   	push   %ebp
  8005ba:	89 e5                	mov    %esp,%ebp
  8005bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005bf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005c3:	8b 10                	mov    (%eax),%edx
  8005c5:	3b 50 04             	cmp    0x4(%eax),%edx
  8005c8:	73 0a                	jae    8005d4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005cd:	89 08                	mov    %ecx,(%eax)
  8005cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d2:	88 02                	mov    %al,(%edx)
}
  8005d4:	5d                   	pop    %ebp
  8005d5:	c3                   	ret    

008005d6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8005d6:	55                   	push   %ebp
  8005d7:	89 e5                	mov    %esp,%ebp
  8005d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8005dc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8005df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f4:	89 04 24             	mov    %eax,(%esp)
  8005f7:	e8 02 00 00 00       	call   8005fe <vprintfmt>
	va_end(ap);
}
  8005fc:	c9                   	leave  
  8005fd:	c3                   	ret    

008005fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005fe:	55                   	push   %ebp
  8005ff:	89 e5                	mov    %esp,%ebp
  800601:	57                   	push   %edi
  800602:	56                   	push   %esi
  800603:	53                   	push   %ebx
  800604:	83 ec 3c             	sub    $0x3c,%esp
  800607:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80060a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80060d:	eb 14                	jmp    800623 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80060f:	85 c0                	test   %eax,%eax
  800611:	0f 84 b3 03 00 00    	je     8009ca <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800617:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80061b:	89 04 24             	mov    %eax,(%esp)
  80061e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800621:	89 f3                	mov    %esi,%ebx
  800623:	8d 73 01             	lea    0x1(%ebx),%esi
  800626:	0f b6 03             	movzbl (%ebx),%eax
  800629:	83 f8 25             	cmp    $0x25,%eax
  80062c:	75 e1                	jne    80060f <vprintfmt+0x11>
  80062e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800632:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800639:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800640:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800647:	ba 00 00 00 00       	mov    $0x0,%edx
  80064c:	eb 1d                	jmp    80066b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80064e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800650:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800654:	eb 15                	jmp    80066b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800656:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800658:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80065c:	eb 0d                	jmp    80066b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80065e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800661:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800664:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80066b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80066e:	0f b6 0e             	movzbl (%esi),%ecx
  800671:	0f b6 c1             	movzbl %cl,%eax
  800674:	83 e9 23             	sub    $0x23,%ecx
  800677:	80 f9 55             	cmp    $0x55,%cl
  80067a:	0f 87 2a 03 00 00    	ja     8009aa <vprintfmt+0x3ac>
  800680:	0f b6 c9             	movzbl %cl,%ecx
  800683:	ff 24 8d e0 30 80 00 	jmp    *0x8030e0(,%ecx,4)
  80068a:	89 de                	mov    %ebx,%esi
  80068c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800691:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800694:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800698:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80069b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80069e:	83 fb 09             	cmp    $0x9,%ebx
  8006a1:	77 36                	ja     8006d9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006a3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006a6:	eb e9                	jmp    800691 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ab:	8d 48 04             	lea    0x4(%eax),%ecx
  8006ae:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006b6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8006b8:	eb 22                	jmp    8006dc <vprintfmt+0xde>
  8006ba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006bd:	85 c9                	test   %ecx,%ecx
  8006bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c4:	0f 49 c1             	cmovns %ecx,%eax
  8006c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ca:	89 de                	mov    %ebx,%esi
  8006cc:	eb 9d                	jmp    80066b <vprintfmt+0x6d>
  8006ce:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8006d0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8006d7:	eb 92                	jmp    80066b <vprintfmt+0x6d>
  8006d9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8006dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006e0:	79 89                	jns    80066b <vprintfmt+0x6d>
  8006e2:	e9 77 ff ff ff       	jmp    80065e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006e7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ea:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8006ec:	e9 7a ff ff ff       	jmp    80066b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	8d 50 04             	lea    0x4(%eax),%edx
  8006f7:	89 55 14             	mov    %edx,0x14(%ebp)
  8006fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	89 04 24             	mov    %eax,(%esp)
  800703:	ff 55 08             	call   *0x8(%ebp)
			break;
  800706:	e9 18 ff ff ff       	jmp    800623 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8d 50 04             	lea    0x4(%eax),%edx
  800711:	89 55 14             	mov    %edx,0x14(%ebp)
  800714:	8b 00                	mov    (%eax),%eax
  800716:	99                   	cltd   
  800717:	31 d0                	xor    %edx,%eax
  800719:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80071b:	83 f8 11             	cmp    $0x11,%eax
  80071e:	7f 0b                	jg     80072b <vprintfmt+0x12d>
  800720:	8b 14 85 40 32 80 00 	mov    0x803240(,%eax,4),%edx
  800727:	85 d2                	test   %edx,%edx
  800729:	75 20                	jne    80074b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80072b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80072f:	c7 44 24 08 b3 2f 80 	movl   $0x802fb3,0x8(%esp)
  800736:	00 
  800737:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	89 04 24             	mov    %eax,(%esp)
  800741:	e8 90 fe ff ff       	call   8005d6 <printfmt>
  800746:	e9 d8 fe ff ff       	jmp    800623 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80074b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80074f:	c7 44 24 08 6d 34 80 	movl   $0x80346d,0x8(%esp)
  800756:	00 
  800757:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	89 04 24             	mov    %eax,(%esp)
  800761:	e8 70 fe ff ff       	call   8005d6 <printfmt>
  800766:	e9 b8 fe ff ff       	jmp    800623 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80076b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80076e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800771:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800774:	8b 45 14             	mov    0x14(%ebp),%eax
  800777:	8d 50 04             	lea    0x4(%eax),%edx
  80077a:	89 55 14             	mov    %edx,0x14(%ebp)
  80077d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80077f:	85 f6                	test   %esi,%esi
  800781:	b8 ac 2f 80 00       	mov    $0x802fac,%eax
  800786:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800789:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80078d:	0f 84 97 00 00 00    	je     80082a <vprintfmt+0x22c>
  800793:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800797:	0f 8e 9b 00 00 00    	jle    800838 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80079d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007a1:	89 34 24             	mov    %esi,(%esp)
  8007a4:	e8 cf 02 00 00       	call   800a78 <strnlen>
  8007a9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007ac:	29 c2                	sub    %eax,%edx
  8007ae:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8007b1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8007b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007b8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007c1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c3:	eb 0f                	jmp    8007d4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8007c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007cc:	89 04 24             	mov    %eax,(%esp)
  8007cf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d1:	83 eb 01             	sub    $0x1,%ebx
  8007d4:	85 db                	test   %ebx,%ebx
  8007d6:	7f ed                	jg     8007c5 <vprintfmt+0x1c7>
  8007d8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8007db:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007de:	85 d2                	test   %edx,%edx
  8007e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8007e5:	0f 49 c2             	cmovns %edx,%eax
  8007e8:	29 c2                	sub    %eax,%edx
  8007ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8007ed:	89 d7                	mov    %edx,%edi
  8007ef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007f2:	eb 50                	jmp    800844 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007f8:	74 1e                	je     800818 <vprintfmt+0x21a>
  8007fa:	0f be d2             	movsbl %dl,%edx
  8007fd:	83 ea 20             	sub    $0x20,%edx
  800800:	83 fa 5e             	cmp    $0x5e,%edx
  800803:	76 13                	jbe    800818 <vprintfmt+0x21a>
					putch('?', putdat);
  800805:	8b 45 0c             	mov    0xc(%ebp),%eax
  800808:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800813:	ff 55 08             	call   *0x8(%ebp)
  800816:	eb 0d                	jmp    800825 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800818:	8b 55 0c             	mov    0xc(%ebp),%edx
  80081b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80081f:	89 04 24             	mov    %eax,(%esp)
  800822:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800825:	83 ef 01             	sub    $0x1,%edi
  800828:	eb 1a                	jmp    800844 <vprintfmt+0x246>
  80082a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80082d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800830:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800833:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800836:	eb 0c                	jmp    800844 <vprintfmt+0x246>
  800838:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80083b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80083e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800841:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800844:	83 c6 01             	add    $0x1,%esi
  800847:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80084b:	0f be c2             	movsbl %dl,%eax
  80084e:	85 c0                	test   %eax,%eax
  800850:	74 27                	je     800879 <vprintfmt+0x27b>
  800852:	85 db                	test   %ebx,%ebx
  800854:	78 9e                	js     8007f4 <vprintfmt+0x1f6>
  800856:	83 eb 01             	sub    $0x1,%ebx
  800859:	79 99                	jns    8007f4 <vprintfmt+0x1f6>
  80085b:	89 f8                	mov    %edi,%eax
  80085d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800860:	8b 75 08             	mov    0x8(%ebp),%esi
  800863:	89 c3                	mov    %eax,%ebx
  800865:	eb 1a                	jmp    800881 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800867:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80086b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800872:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800874:	83 eb 01             	sub    $0x1,%ebx
  800877:	eb 08                	jmp    800881 <vprintfmt+0x283>
  800879:	89 fb                	mov    %edi,%ebx
  80087b:	8b 75 08             	mov    0x8(%ebp),%esi
  80087e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800881:	85 db                	test   %ebx,%ebx
  800883:	7f e2                	jg     800867 <vprintfmt+0x269>
  800885:	89 75 08             	mov    %esi,0x8(%ebp)
  800888:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80088b:	e9 93 fd ff ff       	jmp    800623 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800890:	83 fa 01             	cmp    $0x1,%edx
  800893:	7e 16                	jle    8008ab <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	8d 50 08             	lea    0x8(%eax),%edx
  80089b:	89 55 14             	mov    %edx,0x14(%ebp)
  80089e:	8b 50 04             	mov    0x4(%eax),%edx
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008a9:	eb 32                	jmp    8008dd <vprintfmt+0x2df>
	else if (lflag)
  8008ab:	85 d2                	test   %edx,%edx
  8008ad:	74 18                	je     8008c7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8008af:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b2:	8d 50 04             	lea    0x4(%eax),%edx
  8008b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8008b8:	8b 30                	mov    (%eax),%esi
  8008ba:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008bd:	89 f0                	mov    %esi,%eax
  8008bf:	c1 f8 1f             	sar    $0x1f,%eax
  8008c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008c5:	eb 16                	jmp    8008dd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8008c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ca:	8d 50 04             	lea    0x4(%eax),%edx
  8008cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8008d0:	8b 30                	mov    (%eax),%esi
  8008d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008d5:	89 f0                	mov    %esi,%eax
  8008d7:	c1 f8 1f             	sar    $0x1f,%eax
  8008da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8008e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8008e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ec:	0f 89 80 00 00 00    	jns    800972 <vprintfmt+0x374>
				putch('-', putdat);
  8008f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008fd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800900:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800903:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800906:	f7 d8                	neg    %eax
  800908:	83 d2 00             	adc    $0x0,%edx
  80090b:	f7 da                	neg    %edx
			}
			base = 10;
  80090d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800912:	eb 5e                	jmp    800972 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800914:	8d 45 14             	lea    0x14(%ebp),%eax
  800917:	e8 63 fc ff ff       	call   80057f <getuint>
			base = 10;
  80091c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800921:	eb 4f                	jmp    800972 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800923:	8d 45 14             	lea    0x14(%ebp),%eax
  800926:	e8 54 fc ff ff       	call   80057f <getuint>
			base = 8;
  80092b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800930:	eb 40                	jmp    800972 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800932:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800936:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80093d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800940:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800944:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80094b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80094e:	8b 45 14             	mov    0x14(%ebp),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800957:	8b 00                	mov    (%eax),%eax
  800959:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80095e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800963:	eb 0d                	jmp    800972 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800965:	8d 45 14             	lea    0x14(%ebp),%eax
  800968:	e8 12 fc ff ff       	call   80057f <getuint>
			base = 16;
  80096d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800972:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800976:	89 74 24 10          	mov    %esi,0x10(%esp)
  80097a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80097d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800981:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800985:	89 04 24             	mov    %eax,(%esp)
  800988:	89 54 24 04          	mov    %edx,0x4(%esp)
  80098c:	89 fa                	mov    %edi,%edx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	e8 fa fa ff ff       	call   800490 <printnum>
			break;
  800996:	e9 88 fc ff ff       	jmp    800623 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80099b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80099f:	89 04 24             	mov    %eax,(%esp)
  8009a2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009a5:	e9 79 fc ff ff       	jmp    800623 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009ae:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009b5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009b8:	89 f3                	mov    %esi,%ebx
  8009ba:	eb 03                	jmp    8009bf <vprintfmt+0x3c1>
  8009bc:	83 eb 01             	sub    $0x1,%ebx
  8009bf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8009c3:	75 f7                	jne    8009bc <vprintfmt+0x3be>
  8009c5:	e9 59 fc ff ff       	jmp    800623 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8009ca:	83 c4 3c             	add    $0x3c,%esp
  8009cd:	5b                   	pop    %ebx
  8009ce:	5e                   	pop    %esi
  8009cf:	5f                   	pop    %edi
  8009d0:	5d                   	pop    %ebp
  8009d1:	c3                   	ret    

008009d2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 28             	sub    $0x28,%esp
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009e1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8009e5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8009e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ef:	85 c0                	test   %eax,%eax
  8009f1:	74 30                	je     800a23 <vsnprintf+0x51>
  8009f3:	85 d2                	test   %edx,%edx
  8009f5:	7e 2c                	jle    800a23 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800a01:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a05:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a08:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a0c:	c7 04 24 b9 05 80 00 	movl   $0x8005b9,(%esp)
  800a13:	e8 e6 fb ff ff       	call   8005fe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a1b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a21:	eb 05                	jmp    800a28 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a23:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a30:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a37:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a41:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a45:	8b 45 08             	mov    0x8(%ebp),%eax
  800a48:	89 04 24             	mov    %eax,(%esp)
  800a4b:	e8 82 ff ff ff       	call   8009d2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a50:	c9                   	leave  
  800a51:	c3                   	ret    
  800a52:	66 90                	xchg   %ax,%ax
  800a54:	66 90                	xchg   %ax,%ax
  800a56:	66 90                	xchg   %ax,%ax
  800a58:	66 90                	xchg   %ax,%ax
  800a5a:	66 90                	xchg   %ax,%ax
  800a5c:	66 90                	xchg   %ax,%ax
  800a5e:	66 90                	xchg   %ax,%ax

00800a60 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a66:	b8 00 00 00 00       	mov    $0x0,%eax
  800a6b:	eb 03                	jmp    800a70 <strlen+0x10>
		n++;
  800a6d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a70:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a74:	75 f7                	jne    800a6d <strlen+0xd>
		n++;
	return n;
}
  800a76:	5d                   	pop    %ebp
  800a77:	c3                   	ret    

00800a78 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a81:	b8 00 00 00 00       	mov    $0x0,%eax
  800a86:	eb 03                	jmp    800a8b <strnlen+0x13>
		n++;
  800a88:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a8b:	39 d0                	cmp    %edx,%eax
  800a8d:	74 06                	je     800a95 <strnlen+0x1d>
  800a8f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800a93:	75 f3                	jne    800a88 <strnlen+0x10>
		n++;
	return n;
}
  800a95:	5d                   	pop    %ebp
  800a96:	c3                   	ret    

00800a97 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
  800a9a:	53                   	push   %ebx
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800aa1:	89 c2                	mov    %eax,%edx
  800aa3:	83 c2 01             	add    $0x1,%edx
  800aa6:	83 c1 01             	add    $0x1,%ecx
  800aa9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800aad:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ab0:	84 db                	test   %bl,%bl
  800ab2:	75 ef                	jne    800aa3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ab4:	5b                   	pop    %ebx
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	53                   	push   %ebx
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800ac1:	89 1c 24             	mov    %ebx,(%esp)
  800ac4:	e8 97 ff ff ff       	call   800a60 <strlen>
	strcpy(dst + len, src);
  800ac9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800acc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ad0:	01 d8                	add    %ebx,%eax
  800ad2:	89 04 24             	mov    %eax,(%esp)
  800ad5:	e8 bd ff ff ff       	call   800a97 <strcpy>
	return dst;
}
  800ada:	89 d8                	mov    %ebx,%eax
  800adc:	83 c4 08             	add    $0x8,%esp
  800adf:	5b                   	pop    %ebx
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	56                   	push   %esi
  800ae6:	53                   	push   %ebx
  800ae7:	8b 75 08             	mov    0x8(%ebp),%esi
  800aea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aed:	89 f3                	mov    %esi,%ebx
  800aef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800af2:	89 f2                	mov    %esi,%edx
  800af4:	eb 0f                	jmp    800b05 <strncpy+0x23>
		*dst++ = *src;
  800af6:	83 c2 01             	add    $0x1,%edx
  800af9:	0f b6 01             	movzbl (%ecx),%eax
  800afc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800aff:	80 39 01             	cmpb   $0x1,(%ecx)
  800b02:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b05:	39 da                	cmp    %ebx,%edx
  800b07:	75 ed                	jne    800af6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b09:	89 f0                	mov    %esi,%eax
  800b0b:	5b                   	pop    %ebx
  800b0c:	5e                   	pop    %esi
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	56                   	push   %esi
  800b13:	53                   	push   %ebx
  800b14:	8b 75 08             	mov    0x8(%ebp),%esi
  800b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b1d:	89 f0                	mov    %esi,%eax
  800b1f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b23:	85 c9                	test   %ecx,%ecx
  800b25:	75 0b                	jne    800b32 <strlcpy+0x23>
  800b27:	eb 1d                	jmp    800b46 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b29:	83 c0 01             	add    $0x1,%eax
  800b2c:	83 c2 01             	add    $0x1,%edx
  800b2f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b32:	39 d8                	cmp    %ebx,%eax
  800b34:	74 0b                	je     800b41 <strlcpy+0x32>
  800b36:	0f b6 0a             	movzbl (%edx),%ecx
  800b39:	84 c9                	test   %cl,%cl
  800b3b:	75 ec                	jne    800b29 <strlcpy+0x1a>
  800b3d:	89 c2                	mov    %eax,%edx
  800b3f:	eb 02                	jmp    800b43 <strlcpy+0x34>
  800b41:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800b43:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800b46:	29 f0                	sub    %esi,%eax
}
  800b48:	5b                   	pop    %ebx
  800b49:	5e                   	pop    %esi
  800b4a:	5d                   	pop    %ebp
  800b4b:	c3                   	ret    

00800b4c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
  800b4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b52:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b55:	eb 06                	jmp    800b5d <strcmp+0x11>
		p++, q++;
  800b57:	83 c1 01             	add    $0x1,%ecx
  800b5a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b5d:	0f b6 01             	movzbl (%ecx),%eax
  800b60:	84 c0                	test   %al,%al
  800b62:	74 04                	je     800b68 <strcmp+0x1c>
  800b64:	3a 02                	cmp    (%edx),%al
  800b66:	74 ef                	je     800b57 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b68:	0f b6 c0             	movzbl %al,%eax
  800b6b:	0f b6 12             	movzbl (%edx),%edx
  800b6e:	29 d0                	sub    %edx,%eax
}
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	53                   	push   %ebx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7c:	89 c3                	mov    %eax,%ebx
  800b7e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800b81:	eb 06                	jmp    800b89 <strncmp+0x17>
		n--, p++, q++;
  800b83:	83 c0 01             	add    $0x1,%eax
  800b86:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b89:	39 d8                	cmp    %ebx,%eax
  800b8b:	74 15                	je     800ba2 <strncmp+0x30>
  800b8d:	0f b6 08             	movzbl (%eax),%ecx
  800b90:	84 c9                	test   %cl,%cl
  800b92:	74 04                	je     800b98 <strncmp+0x26>
  800b94:	3a 0a                	cmp    (%edx),%cl
  800b96:	74 eb                	je     800b83 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b98:	0f b6 00             	movzbl (%eax),%eax
  800b9b:	0f b6 12             	movzbl (%edx),%edx
  800b9e:	29 d0                	sub    %edx,%eax
  800ba0:	eb 05                	jmp    800ba7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800ba2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ba7:	5b                   	pop    %ebx
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bb4:	eb 07                	jmp    800bbd <strchr+0x13>
		if (*s == c)
  800bb6:	38 ca                	cmp    %cl,%dl
  800bb8:	74 0f                	je     800bc9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bba:	83 c0 01             	add    $0x1,%eax
  800bbd:	0f b6 10             	movzbl (%eax),%edx
  800bc0:	84 d2                	test   %dl,%dl
  800bc2:	75 f2                	jne    800bb6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800bc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bc9:	5d                   	pop    %ebp
  800bca:	c3                   	ret    

00800bcb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800bd5:	eb 07                	jmp    800bde <strfind+0x13>
		if (*s == c)
  800bd7:	38 ca                	cmp    %cl,%dl
  800bd9:	74 0a                	je     800be5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bdb:	83 c0 01             	add    $0x1,%eax
  800bde:	0f b6 10             	movzbl (%eax),%edx
  800be1:	84 d2                	test   %dl,%dl
  800be3:	75 f2                	jne    800bd7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	57                   	push   %edi
  800beb:	56                   	push   %esi
  800bec:	53                   	push   %ebx
  800bed:	8b 7d 08             	mov    0x8(%ebp),%edi
  800bf0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bf3:	85 c9                	test   %ecx,%ecx
  800bf5:	74 36                	je     800c2d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bf7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bfd:	75 28                	jne    800c27 <memset+0x40>
  800bff:	f6 c1 03             	test   $0x3,%cl
  800c02:	75 23                	jne    800c27 <memset+0x40>
		c &= 0xFF;
  800c04:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c08:	89 d3                	mov    %edx,%ebx
  800c0a:	c1 e3 08             	shl    $0x8,%ebx
  800c0d:	89 d6                	mov    %edx,%esi
  800c0f:	c1 e6 18             	shl    $0x18,%esi
  800c12:	89 d0                	mov    %edx,%eax
  800c14:	c1 e0 10             	shl    $0x10,%eax
  800c17:	09 f0                	or     %esi,%eax
  800c19:	09 c2                	or     %eax,%edx
  800c1b:	89 d0                	mov    %edx,%eax
  800c1d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c1f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c22:	fc                   	cld    
  800c23:	f3 ab                	rep stos %eax,%es:(%edi)
  800c25:	eb 06                	jmp    800c2d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	fc                   	cld    
  800c2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c2d:	89 f8                	mov    %edi,%eax
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c42:	39 c6                	cmp    %eax,%esi
  800c44:	73 35                	jae    800c7b <memmove+0x47>
  800c46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c49:	39 d0                	cmp    %edx,%eax
  800c4b:	73 2e                	jae    800c7b <memmove+0x47>
		s += n;
		d += n;
  800c4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c50:	89 d6                	mov    %edx,%esi
  800c52:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c54:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c5a:	75 13                	jne    800c6f <memmove+0x3b>
  800c5c:	f6 c1 03             	test   $0x3,%cl
  800c5f:	75 0e                	jne    800c6f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c61:	83 ef 04             	sub    $0x4,%edi
  800c64:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c67:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c6a:	fd                   	std    
  800c6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c6d:	eb 09                	jmp    800c78 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c6f:	83 ef 01             	sub    $0x1,%edi
  800c72:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c75:	fd                   	std    
  800c76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c78:	fc                   	cld    
  800c79:	eb 1d                	jmp    800c98 <memmove+0x64>
  800c7b:	89 f2                	mov    %esi,%edx
  800c7d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c7f:	f6 c2 03             	test   $0x3,%dl
  800c82:	75 0f                	jne    800c93 <memmove+0x5f>
  800c84:	f6 c1 03             	test   $0x3,%cl
  800c87:	75 0a                	jne    800c93 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800c89:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800c8c:	89 c7                	mov    %eax,%edi
  800c8e:	fc                   	cld    
  800c8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c91:	eb 05                	jmp    800c98 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c93:	89 c7                	mov    %eax,%edi
  800c95:	fc                   	cld    
  800c96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ca2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 04 24             	mov    %eax,(%esp)
  800cb6:	e8 79 ff ff ff       	call   800c34 <memmove>
}
  800cbb:	c9                   	leave  
  800cbc:	c3                   	ret    

00800cbd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	56                   	push   %esi
  800cc1:	53                   	push   %ebx
  800cc2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc8:	89 d6                	mov    %edx,%esi
  800cca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ccd:	eb 1a                	jmp    800ce9 <memcmp+0x2c>
		if (*s1 != *s2)
  800ccf:	0f b6 02             	movzbl (%edx),%eax
  800cd2:	0f b6 19             	movzbl (%ecx),%ebx
  800cd5:	38 d8                	cmp    %bl,%al
  800cd7:	74 0a                	je     800ce3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800cd9:	0f b6 c0             	movzbl %al,%eax
  800cdc:	0f b6 db             	movzbl %bl,%ebx
  800cdf:	29 d8                	sub    %ebx,%eax
  800ce1:	eb 0f                	jmp    800cf2 <memcmp+0x35>
		s1++, s2++;
  800ce3:	83 c2 01             	add    $0x1,%edx
  800ce6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ce9:	39 f2                	cmp    %esi,%edx
  800ceb:	75 e2                	jne    800ccf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ced:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cf2:	5b                   	pop    %ebx
  800cf3:	5e                   	pop    %esi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800cff:	89 c2                	mov    %eax,%edx
  800d01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d04:	eb 07                	jmp    800d0d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d06:	38 08                	cmp    %cl,(%eax)
  800d08:	74 07                	je     800d11 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d0a:	83 c0 01             	add    $0x1,%eax
  800d0d:	39 d0                	cmp    %edx,%eax
  800d0f:	72 f5                	jb     800d06 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    

00800d13 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	57                   	push   %edi
  800d17:	56                   	push   %esi
  800d18:	53                   	push   %ebx
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d1f:	eb 03                	jmp    800d24 <strtol+0x11>
		s++;
  800d21:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d24:	0f b6 0a             	movzbl (%edx),%ecx
  800d27:	80 f9 09             	cmp    $0x9,%cl
  800d2a:	74 f5                	je     800d21 <strtol+0xe>
  800d2c:	80 f9 20             	cmp    $0x20,%cl
  800d2f:	74 f0                	je     800d21 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d31:	80 f9 2b             	cmp    $0x2b,%cl
  800d34:	75 0a                	jne    800d40 <strtol+0x2d>
		s++;
  800d36:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d39:	bf 00 00 00 00       	mov    $0x0,%edi
  800d3e:	eb 11                	jmp    800d51 <strtol+0x3e>
  800d40:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d45:	80 f9 2d             	cmp    $0x2d,%cl
  800d48:	75 07                	jne    800d51 <strtol+0x3e>
		s++, neg = 1;
  800d4a:	8d 52 01             	lea    0x1(%edx),%edx
  800d4d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d51:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d56:	75 15                	jne    800d6d <strtol+0x5a>
  800d58:	80 3a 30             	cmpb   $0x30,(%edx)
  800d5b:	75 10                	jne    800d6d <strtol+0x5a>
  800d5d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d61:	75 0a                	jne    800d6d <strtol+0x5a>
		s += 2, base = 16;
  800d63:	83 c2 02             	add    $0x2,%edx
  800d66:	b8 10 00 00 00       	mov    $0x10,%eax
  800d6b:	eb 10                	jmp    800d7d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800d6d:	85 c0                	test   %eax,%eax
  800d6f:	75 0c                	jne    800d7d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d71:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d73:	80 3a 30             	cmpb   $0x30,(%edx)
  800d76:	75 05                	jne    800d7d <strtol+0x6a>
		s++, base = 8;
  800d78:	83 c2 01             	add    $0x1,%edx
  800d7b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800d7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d82:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d85:	0f b6 0a             	movzbl (%edx),%ecx
  800d88:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800d8b:	89 f0                	mov    %esi,%eax
  800d8d:	3c 09                	cmp    $0x9,%al
  800d8f:	77 08                	ja     800d99 <strtol+0x86>
			dig = *s - '0';
  800d91:	0f be c9             	movsbl %cl,%ecx
  800d94:	83 e9 30             	sub    $0x30,%ecx
  800d97:	eb 20                	jmp    800db9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800d99:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800d9c:	89 f0                	mov    %esi,%eax
  800d9e:	3c 19                	cmp    $0x19,%al
  800da0:	77 08                	ja     800daa <strtol+0x97>
			dig = *s - 'a' + 10;
  800da2:	0f be c9             	movsbl %cl,%ecx
  800da5:	83 e9 57             	sub    $0x57,%ecx
  800da8:	eb 0f                	jmp    800db9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800daa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800dad:	89 f0                	mov    %esi,%eax
  800daf:	3c 19                	cmp    $0x19,%al
  800db1:	77 16                	ja     800dc9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800db3:	0f be c9             	movsbl %cl,%ecx
  800db6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800db9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800dbc:	7d 0f                	jge    800dcd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800dbe:	83 c2 01             	add    $0x1,%edx
  800dc1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800dc5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800dc7:	eb bc                	jmp    800d85 <strtol+0x72>
  800dc9:	89 d8                	mov    %ebx,%eax
  800dcb:	eb 02                	jmp    800dcf <strtol+0xbc>
  800dcd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800dcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd3:	74 05                	je     800dda <strtol+0xc7>
		*endptr = (char *) s;
  800dd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800dd8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800dda:	f7 d8                	neg    %eax
  800ddc:	85 ff                	test   %edi,%edi
  800dde:	0f 44 c3             	cmove  %ebx,%eax
}
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	57                   	push   %edi
  800dea:	56                   	push   %esi
  800deb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dec:	b8 00 00 00 00       	mov    $0x0,%eax
  800df1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df4:	8b 55 08             	mov    0x8(%ebp),%edx
  800df7:	89 c3                	mov    %eax,%ebx
  800df9:	89 c7                	mov    %eax,%edi
  800dfb:	89 c6                	mov    %eax,%esi
  800dfd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dff:	5b                   	pop    %ebx
  800e00:	5e                   	pop    %esi
  800e01:	5f                   	pop    %edi
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e0f:	b8 01 00 00 00       	mov    $0x1,%eax
  800e14:	89 d1                	mov    %edx,%ecx
  800e16:	89 d3                	mov    %edx,%ebx
  800e18:	89 d7                	mov    %edx,%edi
  800e1a:	89 d6                	mov    %edx,%esi
  800e1c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e1e:	5b                   	pop    %ebx
  800e1f:	5e                   	pop    %esi
  800e20:	5f                   	pop    %edi
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800e2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e31:	b8 03 00 00 00       	mov    $0x3,%eax
  800e36:	8b 55 08             	mov    0x8(%ebp),%edx
  800e39:	89 cb                	mov    %ecx,%ebx
  800e3b:	89 cf                	mov    %ecx,%edi
  800e3d:	89 ce                	mov    %ecx,%esi
  800e3f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e41:	85 c0                	test   %eax,%eax
  800e43:	7e 28                	jle    800e6d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e45:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e49:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e50:	00 
  800e51:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  800e58:	00 
  800e59:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e60:	00 
  800e61:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  800e68:	e8 09 f5 ff ff       	call   800376 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e6d:	83 c4 2c             	add    $0x2c,%esp
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    

00800e75 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	57                   	push   %edi
  800e79:	56                   	push   %esi
  800e7a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e80:	b8 02 00 00 00       	mov    $0x2,%eax
  800e85:	89 d1                	mov    %edx,%ecx
  800e87:	89 d3                	mov    %edx,%ebx
  800e89:	89 d7                	mov    %edx,%edi
  800e8b:	89 d6                	mov    %edx,%esi
  800e8d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800e8f:	5b                   	pop    %ebx
  800e90:	5e                   	pop    %esi
  800e91:	5f                   	pop    %edi
  800e92:	5d                   	pop    %ebp
  800e93:	c3                   	ret    

00800e94 <sys_yield>:

void
sys_yield(void)
{
  800e94:	55                   	push   %ebp
  800e95:	89 e5                	mov    %esp,%ebp
  800e97:	57                   	push   %edi
  800e98:	56                   	push   %esi
  800e99:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ea4:	89 d1                	mov    %edx,%ecx
  800ea6:	89 d3                	mov    %edx,%ebx
  800ea8:	89 d7                	mov    %edx,%edi
  800eaa:	89 d6                	mov    %edx,%esi
  800eac:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800eae:	5b                   	pop    %ebx
  800eaf:	5e                   	pop    %esi
  800eb0:	5f                   	pop    %edi
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    

00800eb3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800eb3:	55                   	push   %ebp
  800eb4:	89 e5                	mov    %esp,%ebp
  800eb6:	57                   	push   %edi
  800eb7:	56                   	push   %esi
  800eb8:	53                   	push   %ebx
  800eb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ebc:	be 00 00 00 00       	mov    $0x0,%esi
  800ec1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ec6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ecf:	89 f7                	mov    %esi,%edi
  800ed1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ed3:	85 c0                	test   %eax,%eax
  800ed5:	7e 28                	jle    800eff <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800edb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ee2:	00 
  800ee3:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  800eea:	00 
  800eeb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ef2:	00 
  800ef3:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  800efa:	e8 77 f4 ff ff       	call   800376 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800eff:	83 c4 2c             	add    $0x2c,%esp
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    

00800f07 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	57                   	push   %edi
  800f0b:	56                   	push   %esi
  800f0c:	53                   	push   %ebx
  800f0d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f10:	b8 05 00 00 00       	mov    $0x5,%eax
  800f15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f18:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f1e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f21:	8b 75 18             	mov    0x18(%ebp),%esi
  800f24:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f26:	85 c0                	test   %eax,%eax
  800f28:	7e 28                	jle    800f52 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f35:	00 
  800f36:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  800f3d:	00 
  800f3e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f45:	00 
  800f46:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  800f4d:	e8 24 f4 ff ff       	call   800376 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f52:	83 c4 2c             	add    $0x2c,%esp
  800f55:	5b                   	pop    %ebx
  800f56:	5e                   	pop    %esi
  800f57:	5f                   	pop    %edi
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    

00800f5a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	57                   	push   %edi
  800f5e:	56                   	push   %esi
  800f5f:	53                   	push   %ebx
  800f60:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f63:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f68:	b8 06 00 00 00       	mov    $0x6,%eax
  800f6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f70:	8b 55 08             	mov    0x8(%ebp),%edx
  800f73:	89 df                	mov    %ebx,%edi
  800f75:	89 de                	mov    %ebx,%esi
  800f77:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	7e 28                	jle    800fa5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f81:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f88:	00 
  800f89:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  800f90:	00 
  800f91:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f98:	00 
  800f99:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  800fa0:	e8 d1 f3 ff ff       	call   800376 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fa5:	83 c4 2c             	add    $0x2c,%esp
  800fa8:	5b                   	pop    %ebx
  800fa9:	5e                   	pop    %esi
  800faa:	5f                   	pop    %edi
  800fab:	5d                   	pop    %ebp
  800fac:	c3                   	ret    

00800fad <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	57                   	push   %edi
  800fb1:	56                   	push   %esi
  800fb2:	53                   	push   %ebx
  800fb3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbb:	b8 08 00 00 00       	mov    $0x8,%eax
  800fc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc6:	89 df                	mov    %ebx,%edi
  800fc8:	89 de                	mov    %ebx,%esi
  800fca:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800fcc:	85 c0                	test   %eax,%eax
  800fce:	7e 28                	jle    800ff8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800fdb:	00 
  800fdc:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  800fe3:	00 
  800fe4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800feb:	00 
  800fec:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  800ff3:	e8 7e f3 ff ff       	call   800376 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ff8:	83 c4 2c             	add    $0x2c,%esp
  800ffb:	5b                   	pop    %ebx
  800ffc:	5e                   	pop    %esi
  800ffd:	5f                   	pop    %edi
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    

00801000 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	57                   	push   %edi
  801004:	56                   	push   %esi
  801005:	53                   	push   %ebx
  801006:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801009:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100e:	b8 09 00 00 00       	mov    $0x9,%eax
  801013:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801016:	8b 55 08             	mov    0x8(%ebp),%edx
  801019:	89 df                	mov    %ebx,%edi
  80101b:	89 de                	mov    %ebx,%esi
  80101d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80101f:	85 c0                	test   %eax,%eax
  801021:	7e 28                	jle    80104b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801023:	89 44 24 10          	mov    %eax,0x10(%esp)
  801027:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80102e:	00 
  80102f:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  801036:	00 
  801037:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80103e:	00 
  80103f:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  801046:	e8 2b f3 ff ff       	call   800376 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80104b:	83 c4 2c             	add    $0x2c,%esp
  80104e:	5b                   	pop    %ebx
  80104f:	5e                   	pop    %esi
  801050:	5f                   	pop    %edi
  801051:	5d                   	pop    %ebp
  801052:	c3                   	ret    

00801053 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	57                   	push   %edi
  801057:	56                   	push   %esi
  801058:	53                   	push   %ebx
  801059:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801061:	b8 0a 00 00 00       	mov    $0xa,%eax
  801066:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801069:	8b 55 08             	mov    0x8(%ebp),%edx
  80106c:	89 df                	mov    %ebx,%edi
  80106e:	89 de                	mov    %ebx,%esi
  801070:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801072:	85 c0                	test   %eax,%eax
  801074:	7e 28                	jle    80109e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801076:	89 44 24 10          	mov    %eax,0x10(%esp)
  80107a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801081:	00 
  801082:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  801089:	00 
  80108a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801091:	00 
  801092:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  801099:	e8 d8 f2 ff ff       	call   800376 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80109e:	83 c4 2c             	add    $0x2c,%esp
  8010a1:	5b                   	pop    %ebx
  8010a2:	5e                   	pop    %esi
  8010a3:	5f                   	pop    %edi
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    

008010a6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	57                   	push   %edi
  8010aa:	56                   	push   %esi
  8010ab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ac:	be 00 00 00 00       	mov    $0x0,%esi
  8010b1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010bf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010c2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010c4:	5b                   	pop    %ebx
  8010c5:	5e                   	pop    %esi
  8010c6:	5f                   	pop    %edi
  8010c7:	5d                   	pop    %ebp
  8010c8:	c3                   	ret    

008010c9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010c9:	55                   	push   %ebp
  8010ca:	89 e5                	mov    %esp,%ebp
  8010cc:	57                   	push   %edi
  8010cd:	56                   	push   %esi
  8010ce:	53                   	push   %ebx
  8010cf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010d7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010df:	89 cb                	mov    %ecx,%ebx
  8010e1:	89 cf                	mov    %ecx,%edi
  8010e3:	89 ce                	mov    %ecx,%esi
  8010e5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8010e7:	85 c0                	test   %eax,%eax
  8010e9:	7e 28                	jle    801113 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010eb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ef:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8010f6:	00 
  8010f7:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  8010fe:	00 
  8010ff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801106:	00 
  801107:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  80110e:	e8 63 f2 ff ff       	call   800376 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801113:	83 c4 2c             	add    $0x2c,%esp
  801116:	5b                   	pop    %ebx
  801117:	5e                   	pop    %esi
  801118:	5f                   	pop    %edi
  801119:	5d                   	pop    %ebp
  80111a:	c3                   	ret    

0080111b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
  80111e:	57                   	push   %edi
  80111f:	56                   	push   %esi
  801120:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801121:	ba 00 00 00 00       	mov    $0x0,%edx
  801126:	b8 0e 00 00 00       	mov    $0xe,%eax
  80112b:	89 d1                	mov    %edx,%ecx
  80112d:	89 d3                	mov    %edx,%ebx
  80112f:	89 d7                	mov    %edx,%edi
  801131:	89 d6                	mov    %edx,%esi
  801133:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801135:	5b                   	pop    %ebx
  801136:	5e                   	pop    %esi
  801137:	5f                   	pop    %edi
  801138:	5d                   	pop    %ebp
  801139:	c3                   	ret    

0080113a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	57                   	push   %edi
  80113e:	56                   	push   %esi
  80113f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801140:	bb 00 00 00 00       	mov    $0x0,%ebx
  801145:	b8 0f 00 00 00       	mov    $0xf,%eax
  80114a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114d:	8b 55 08             	mov    0x8(%ebp),%edx
  801150:	89 df                	mov    %ebx,%edi
  801152:	89 de                	mov    %ebx,%esi
  801154:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  801156:	5b                   	pop    %ebx
  801157:	5e                   	pop    %esi
  801158:	5f                   	pop    %edi
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	57                   	push   %edi
  80115f:	56                   	push   %esi
  801160:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801161:	bb 00 00 00 00       	mov    $0x0,%ebx
  801166:	b8 10 00 00 00       	mov    $0x10,%eax
  80116b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116e:	8b 55 08             	mov    0x8(%ebp),%edx
  801171:	89 df                	mov    %ebx,%edi
  801173:	89 de                	mov    %ebx,%esi
  801175:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  801177:	5b                   	pop    %ebx
  801178:	5e                   	pop    %esi
  801179:	5f                   	pop    %edi
  80117a:	5d                   	pop    %ebp
  80117b:	c3                   	ret    

0080117c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	57                   	push   %edi
  801180:	56                   	push   %esi
  801181:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801182:	b9 00 00 00 00       	mov    $0x0,%ecx
  801187:	b8 11 00 00 00       	mov    $0x11,%eax
  80118c:	8b 55 08             	mov    0x8(%ebp),%edx
  80118f:	89 cb                	mov    %ecx,%ebx
  801191:	89 cf                	mov    %ecx,%edi
  801193:	89 ce                	mov    %ecx,%esi
  801195:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801197:	5b                   	pop    %ebx
  801198:	5e                   	pop    %esi
  801199:	5f                   	pop    %edi
  80119a:	5d                   	pop    %ebp
  80119b:	c3                   	ret    

0080119c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	57                   	push   %edi
  8011a0:	56                   	push   %esi
  8011a1:	53                   	push   %ebx
  8011a2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a5:	be 00 00 00 00       	mov    $0x0,%esi
  8011aa:	b8 12 00 00 00       	mov    $0x12,%eax
  8011af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011b8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011bb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	7e 28                	jle    8011e9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011c5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8011cc:	00 
  8011cd:	c7 44 24 08 a7 32 80 	movl   $0x8032a7,0x8(%esp)
  8011d4:	00 
  8011d5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011dc:	00 
  8011dd:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  8011e4:	e8 8d f1 ff ff       	call   800376 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  8011e9:	83 c4 2c             	add    $0x2c,%esp
  8011ec:	5b                   	pop    %ebx
  8011ed:	5e                   	pop    %esi
  8011ee:	5f                   	pop    %edi
  8011ef:	5d                   	pop    %ebp
  8011f0:	c3                   	ret    

008011f1 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
  8011f4:	53                   	push   %ebx
  8011f5:	83 ec 24             	sub    $0x24,%esp
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8011fb:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0)
  8011fd:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801201:	75 20                	jne    801223 <pgfault+0x32>
		panic("pgfault: faulting address [%08x] not a write\n", addr);
  801203:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801207:	c7 44 24 08 d4 32 80 	movl   $0x8032d4,0x8(%esp)
  80120e:	00 
  80120f:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  801216:	00 
  801217:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  80121e:	e8 53 f1 ff ff       	call   800376 <_panic>

	void *page_aligned_addr = (void *) ROUNDDOWN(addr, PGSIZE);
  801223:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t page_num = (uint32_t) page_aligned_addr / PGSIZE;
  801229:	89 d8                	mov    %ebx,%eax
  80122b:	c1 e8 0c             	shr    $0xc,%eax
	if (!(uvpt[page_num] & PTE_COW))
  80122e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801235:	f6 c4 08             	test   $0x8,%ah
  801238:	75 1c                	jne    801256 <pgfault+0x65>
		panic("pgfault: fault was not on a copy-on-write page\n");
  80123a:	c7 44 24 08 04 33 80 	movl   $0x803304,0x8(%esp)
  801241:	00 
  801242:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801249:	00 
  80124a:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  801251:	e8 20 f1 ff ff       	call   800376 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	// Allocate
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801256:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80125d:	00 
  80125e:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801265:	00 
  801266:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80126d:	e8 41 fc ff ff       	call   800eb3 <sys_page_alloc>
  801272:	85 c0                	test   %eax,%eax
  801274:	79 20                	jns    801296 <pgfault+0xa5>
		panic("sys_page_alloc: %e\n", r);
  801276:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80127a:	c7 44 24 08 5f 33 80 	movl   $0x80335f,0x8(%esp)
  801281:	00 
  801282:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  801289:	00 
  80128a:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  801291:	e8 e0 f0 ff ff       	call   800376 <_panic>

	// Copy over
	void *src_addr = (void *) ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, src_addr, PGSIZE);
  801296:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80129d:	00 
  80129e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012a2:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8012a9:	e8 86 f9 ff ff       	call   800c34 <memmove>

	// Remap
	if ((r = sys_page_map(0, PFTEMP, 0, src_addr, PTE_P | PTE_U | PTE_W)) < 0)
  8012ae:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8012b5:	00 
  8012b6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012ba:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012c1:	00 
  8012c2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012c9:	00 
  8012ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d1:	e8 31 fc ff ff       	call   800f07 <sys_page_map>
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	79 20                	jns    8012fa <pgfault+0x109>
		panic("sys_page_map: %e\n", r);
  8012da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012de:	c7 44 24 08 73 33 80 	movl   $0x803373,0x8(%esp)
  8012e5:	00 
  8012e6:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  8012ed:	00 
  8012ee:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  8012f5:	e8 7c f0 ff ff       	call   800376 <_panic>

	//panic("pgfault not implemented");
}
  8012fa:	83 c4 24             	add    $0x24,%esp
  8012fd:	5b                   	pop    %ebx
  8012fe:	5d                   	pop    %ebp
  8012ff:	c3                   	ret    

00801300 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	57                   	push   %edi
  801304:	56                   	push   %esi
  801305:	53                   	push   %ebx
  801306:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	int r;
	envid_t child_envid;

	set_pgfault_handler(pgfault);
  801309:	c7 04 24 f1 11 80 00 	movl   $0x8011f1,(%esp)
  801310:	e8 61 16 00 00       	call   802976 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801315:	b8 07 00 00 00       	mov    $0x7,%eax
  80131a:	cd 30                	int    $0x30
  80131c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80131f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	child_envid = sys_exofork();
	if (child_envid < 0)
  801322:	85 c0                	test   %eax,%eax
  801324:	79 20                	jns    801346 <fork+0x46>
		panic("sys_exofork: %e\n", child_envid);
  801326:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80132a:	c7 44 24 08 85 33 80 	movl   $0x803385,0x8(%esp)
  801331:	00 
  801332:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  801339:	00 
  80133a:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  801341:	e8 30 f0 ff ff       	call   800376 <_panic>
	if (child_envid == 0) { // child
  801346:	bf 00 00 00 00       	mov    $0x0,%edi
  80134b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801350:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801354:	75 21                	jne    801377 <fork+0x77>
		// Fix thisenv like dumbfork does and return 0
		thisenv = &envs[ENVX(sys_getenvid())];
  801356:	e8 1a fb ff ff       	call   800e75 <sys_getenvid>
  80135b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801360:	c1 e0 07             	shl    $0x7,%eax
  801363:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801368:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  80136d:	b8 00 00 00 00       	mov    $0x0,%eax
  801372:	e9 53 02 00 00       	jmp    8015ca <fork+0x2ca>
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
  801377:	89 d8                	mov    %ebx,%eax
  801379:	c1 e8 0a             	shr    $0xa,%eax
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  80137c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801383:	a8 01                	test   $0x1,%al
  801385:	0f 84 7a 01 00 00    	je     801505 <fork+0x205>
			((uvpt[page_num] & PTE_P) == PTE_P)) {
  80138b:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  801392:	a8 01                	test   $0x1,%al
  801394:	0f 84 6b 01 00 00    	je     801505 <fork+0x205>
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
	envid_t this_envid = thisenv->env_id;
  80139a:	a1 08 50 80 00       	mov    0x805008,%eax
  80139f:	8b 40 48             	mov    0x48(%eax),%eax
  8013a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 4: Your code here.
	if (uvpt[pn] & PTE_SHARE) {
  8013a5:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8013ac:	f6 c4 04             	test   $0x4,%ah
  8013af:	74 52                	je     801403 <fork+0x103>
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  8013b1:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8013b8:	25 07 0e 00 00       	and    $0xe07,%eax
  8013bd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013cc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d3:	89 04 24             	mov    %eax,(%esp)
  8013d6:	e8 2c fb ff ff       	call   800f07 <sys_page_map>
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	0f 89 22 01 00 00    	jns    801505 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  8013e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013e7:	c7 44 24 08 73 33 80 	movl   $0x803373,0x8(%esp)
  8013ee:	00 
  8013ef:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  8013f6:	00 
  8013f7:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  8013fe:	e8 73 ef ff ff       	call   800376 <_panic>
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
  801403:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80140a:	f6 c4 08             	test   $0x8,%ah
  80140d:	75 0f                	jne    80141e <fork+0x11e>
  80140f:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801416:	a8 02                	test   $0x2,%al
  801418:	0f 84 99 00 00 00    	je     8014b7 <fork+0x1b7>
		if (uvpt[pn] & PTE_U)
  80141e:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801425:	83 e0 04             	and    $0x4,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
  801428:	83 f8 01             	cmp    $0x1,%eax
  80142b:	19 f6                	sbb    %esi,%esi
  80142d:	83 e6 fc             	and    $0xfffffffc,%esi
  801430:	81 c6 05 08 00 00    	add    $0x805,%esi
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
		if (uvpt[pn] & PTE_U)
			perm |= PTE_U;

		// Map page COW, U and P in child
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), perm)) < 0)
  801436:	89 74 24 10          	mov    %esi,0x10(%esp)
  80143a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80143e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801441:	89 44 24 08          	mov    %eax,0x8(%esp)
  801445:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80144c:	89 04 24             	mov    %eax,(%esp)
  80144f:	e8 b3 fa ff ff       	call   800f07 <sys_page_map>
  801454:	85 c0                	test   %eax,%eax
  801456:	79 20                	jns    801478 <fork+0x178>
			panic("sys_page_map: %e\n", r);
  801458:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80145c:	c7 44 24 08 73 33 80 	movl   $0x803373,0x8(%esp)
  801463:	00 
  801464:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80146b:	00 
  80146c:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  801473:	e8 fe ee ff ff       	call   800376 <_panic>

		// Map page COW, U and P in parent
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), this_envid, (void *) (pn*PGSIZE), perm)) < 0)
  801478:	89 74 24 10          	mov    %esi,0x10(%esp)
  80147c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801480:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801483:	89 44 24 08          	mov    %eax,0x8(%esp)
  801487:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80148b:	89 04 24             	mov    %eax,(%esp)
  80148e:	e8 74 fa ff ff       	call   800f07 <sys_page_map>
  801493:	85 c0                	test   %eax,%eax
  801495:	79 6e                	jns    801505 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801497:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80149b:	c7 44 24 08 73 33 80 	movl   $0x803373,0x8(%esp)
  8014a2:	00 
  8014a3:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8014aa:	00 
  8014ab:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  8014b2:	e8 bf ee ff ff       	call   800376 <_panic>

	} else { // map pages that are present but not writable or COW with their original permissions
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  8014b7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8014be:	25 07 0e 00 00       	and    $0xe07,%eax
  8014c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014c7:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8014cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014d9:	89 04 24             	mov    %eax,(%esp)
  8014dc:	e8 26 fa ff ff       	call   800f07 <sys_page_map>
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	79 20                	jns    801505 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  8014e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014e9:	c7 44 24 08 73 33 80 	movl   $0x803373,0x8(%esp)
  8014f0:	00 
  8014f1:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  8014f8:	00 
  8014f9:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  801500:	e8 71 ee ff ff       	call   800376 <_panic>
	// and let duppage worry about the permissions.
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
  801505:	83 c3 01             	add    $0x1,%ebx
  801508:	81 c7 00 10 00 00    	add    $0x1000,%edi
  80150e:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801514:	0f 85 5d fe ff ff    	jne    801377 <fork+0x77>
	}

	// Allocate exception stack space for child. The child can't do this themselves
	// because the mechanism by which it would is to run the pgfault handler, which
	// needs to run on the exception stack (catch 22).
	if ((r = sys_page_alloc(child_envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80151a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801521:	00 
  801522:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801529:	ee 
  80152a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80152d:	89 04 24             	mov    %eax,(%esp)
  801530:	e8 7e f9 ff ff       	call   800eb3 <sys_page_alloc>
  801535:	85 c0                	test   %eax,%eax
  801537:	79 20                	jns    801559 <fork+0x259>
		panic("sys_page_alloc: %e\n", r);
  801539:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80153d:	c7 44 24 08 5f 33 80 	movl   $0x80335f,0x8(%esp)
  801544:	00 
  801545:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  80154c:	00 
  80154d:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  801554:	e8 1d ee ff ff       	call   800376 <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801559:	c7 44 24 04 f7 29 80 	movl   $0x8029f7,0x4(%esp)
  801560:	00 
  801561:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801564:	89 04 24             	mov    %eax,(%esp)
  801567:	e8 e7 fa ff ff       	call   801053 <sys_env_set_pgfault_upcall>
  80156c:	85 c0                	test   %eax,%eax
  80156e:	79 20                	jns    801590 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  801570:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801574:	c7 44 24 08 34 33 80 	movl   $0x803334,0x8(%esp)
  80157b:	00 
  80157c:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  801583:	00 
  801584:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  80158b:	e8 e6 ed ff ff       	call   800376 <_panic>

	// Mark child environment as runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801590:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801597:	00 
  801598:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80159b:	89 04 24             	mov    %eax,(%esp)
  80159e:	e8 0a fa ff ff       	call   800fad <sys_env_set_status>
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	79 20                	jns    8015c7 <fork+0x2c7>
		panic("sys_env_set_status: %e\n", r);
  8015a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015ab:	c7 44 24 08 96 33 80 	movl   $0x803396,0x8(%esp)
  8015b2:	00 
  8015b3:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8015ba:	00 
  8015bb:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  8015c2:	e8 af ed ff ff       	call   800376 <_panic>

	return child_envid;
  8015c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8015ca:	83 c4 2c             	add    $0x2c,%esp
  8015cd:	5b                   	pop    %ebx
  8015ce:	5e                   	pop    %esi
  8015cf:	5f                   	pop    %edi
  8015d0:	5d                   	pop    %ebp
  8015d1:	c3                   	ret    

008015d2 <sfork>:

// Challenge!
int
sfork(void)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	83 ec 18             	sub    $0x18,%esp
//	return __fork(1);
	panic("sfork not implemented");
  8015d8:	c7 44 24 08 ae 33 80 	movl   $0x8033ae,0x8(%esp)
  8015df:	00 
  8015e0:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  8015e7:	00 
  8015e8:	c7 04 24 54 33 80 00 	movl   $0x803354,(%esp)
  8015ef:	e8 82 ed ff ff       	call   800376 <_panic>
  8015f4:	66 90                	xchg   %ax,%ax
  8015f6:	66 90                	xchg   %ax,%ax
  8015f8:	66 90                	xchg   %ax,%ax
  8015fa:	66 90                	xchg   %ax,%ax
  8015fc:	66 90                	xchg   %ax,%ax
  8015fe:	66 90                	xchg   %ax,%ax

00801600 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	05 00 00 00 30       	add    $0x30000000,%eax
  80160b:	c1 e8 0c             	shr    $0xc,%eax
}
  80160e:	5d                   	pop    %ebp
  80160f:	c3                   	ret    

00801610 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80161b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801620:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801625:	5d                   	pop    %ebp
  801626:	c3                   	ret    

00801627 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80162d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801632:	89 c2                	mov    %eax,%edx
  801634:	c1 ea 16             	shr    $0x16,%edx
  801637:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80163e:	f6 c2 01             	test   $0x1,%dl
  801641:	74 11                	je     801654 <fd_alloc+0x2d>
  801643:	89 c2                	mov    %eax,%edx
  801645:	c1 ea 0c             	shr    $0xc,%edx
  801648:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80164f:	f6 c2 01             	test   $0x1,%dl
  801652:	75 09                	jne    80165d <fd_alloc+0x36>
			*fd_store = fd;
  801654:	89 01                	mov    %eax,(%ecx)
			return 0;
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
  80165b:	eb 17                	jmp    801674 <fd_alloc+0x4d>
  80165d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801662:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801667:	75 c9                	jne    801632 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801669:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80166f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801674:	5d                   	pop    %ebp
  801675:	c3                   	ret    

00801676 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80167c:	83 f8 1f             	cmp    $0x1f,%eax
  80167f:	77 36                	ja     8016b7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801681:	c1 e0 0c             	shl    $0xc,%eax
  801684:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801689:	89 c2                	mov    %eax,%edx
  80168b:	c1 ea 16             	shr    $0x16,%edx
  80168e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801695:	f6 c2 01             	test   $0x1,%dl
  801698:	74 24                	je     8016be <fd_lookup+0x48>
  80169a:	89 c2                	mov    %eax,%edx
  80169c:	c1 ea 0c             	shr    $0xc,%edx
  80169f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016a6:	f6 c2 01             	test   $0x1,%dl
  8016a9:	74 1a                	je     8016c5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ae:	89 02                	mov    %eax,(%edx)
	return 0;
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	eb 13                	jmp    8016ca <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016bc:	eb 0c                	jmp    8016ca <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8016be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016c3:	eb 05                	jmp    8016ca <fd_lookup+0x54>
  8016c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8016ca:	5d                   	pop    %ebp
  8016cb:	c3                   	ret    

008016cc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 18             	sub    $0x18,%esp
  8016d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8016d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8016da:	eb 13                	jmp    8016ef <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8016dc:	39 08                	cmp    %ecx,(%eax)
  8016de:	75 0c                	jne    8016ec <dev_lookup+0x20>
			*dev = devtab[i];
  8016e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016e3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ea:	eb 38                	jmp    801724 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8016ec:	83 c2 01             	add    $0x1,%edx
  8016ef:	8b 04 95 40 34 80 00 	mov    0x803440(,%edx,4),%eax
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	75 e2                	jne    8016dc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8016fa:	a1 08 50 80 00       	mov    0x805008,%eax
  8016ff:	8b 40 48             	mov    0x48(%eax),%eax
  801702:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801706:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170a:	c7 04 24 c4 33 80 00 	movl   $0x8033c4,(%esp)
  801711:	e8 59 ed ff ff       	call   80046f <cprintf>
	*dev = 0;
  801716:	8b 45 0c             	mov    0xc(%ebp),%eax
  801719:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80171f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	56                   	push   %esi
  80172a:	53                   	push   %ebx
  80172b:	83 ec 20             	sub    $0x20,%esp
  80172e:	8b 75 08             	mov    0x8(%ebp),%esi
  801731:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801734:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801737:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80173b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801741:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801744:	89 04 24             	mov    %eax,(%esp)
  801747:	e8 2a ff ff ff       	call   801676 <fd_lookup>
  80174c:	85 c0                	test   %eax,%eax
  80174e:	78 05                	js     801755 <fd_close+0x2f>
	    || fd != fd2)
  801750:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801753:	74 0c                	je     801761 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801755:	84 db                	test   %bl,%bl
  801757:	ba 00 00 00 00       	mov    $0x0,%edx
  80175c:	0f 44 c2             	cmove  %edx,%eax
  80175f:	eb 3f                	jmp    8017a0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801761:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801764:	89 44 24 04          	mov    %eax,0x4(%esp)
  801768:	8b 06                	mov    (%esi),%eax
  80176a:	89 04 24             	mov    %eax,(%esp)
  80176d:	e8 5a ff ff ff       	call   8016cc <dev_lookup>
  801772:	89 c3                	mov    %eax,%ebx
  801774:	85 c0                	test   %eax,%eax
  801776:	78 16                	js     80178e <fd_close+0x68>
		if (dev->dev_close)
  801778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80177e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801783:	85 c0                	test   %eax,%eax
  801785:	74 07                	je     80178e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801787:	89 34 24             	mov    %esi,(%esp)
  80178a:	ff d0                	call   *%eax
  80178c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80178e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801792:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801799:	e8 bc f7 ff ff       	call   800f5a <sys_page_unmap>
	return r;
  80179e:	89 d8                	mov    %ebx,%eax
}
  8017a0:	83 c4 20             	add    $0x20,%esp
  8017a3:	5b                   	pop    %ebx
  8017a4:	5e                   	pop    %esi
  8017a5:	5d                   	pop    %ebp
  8017a6:	c3                   	ret    

008017a7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	89 04 24             	mov    %eax,(%esp)
  8017ba:	e8 b7 fe ff ff       	call   801676 <fd_lookup>
  8017bf:	89 c2                	mov    %eax,%edx
  8017c1:	85 d2                	test   %edx,%edx
  8017c3:	78 13                	js     8017d8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8017c5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017cc:	00 
  8017cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d0:	89 04 24             	mov    %eax,(%esp)
  8017d3:	e8 4e ff ff ff       	call   801726 <fd_close>
}
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <close_all>:

void
close_all(void)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	53                   	push   %ebx
  8017de:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8017e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8017e6:	89 1c 24             	mov    %ebx,(%esp)
  8017e9:	e8 b9 ff ff ff       	call   8017a7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8017ee:	83 c3 01             	add    $0x1,%ebx
  8017f1:	83 fb 20             	cmp    $0x20,%ebx
  8017f4:	75 f0                	jne    8017e6 <close_all+0xc>
		close(i);
}
  8017f6:	83 c4 14             	add    $0x14,%esp
  8017f9:	5b                   	pop    %ebx
  8017fa:	5d                   	pop    %ebp
  8017fb:	c3                   	ret    

008017fc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	57                   	push   %edi
  801800:	56                   	push   %esi
  801801:	53                   	push   %ebx
  801802:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801805:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801808:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	89 04 24             	mov    %eax,(%esp)
  801812:	e8 5f fe ff ff       	call   801676 <fd_lookup>
  801817:	89 c2                	mov    %eax,%edx
  801819:	85 d2                	test   %edx,%edx
  80181b:	0f 88 e1 00 00 00    	js     801902 <dup+0x106>
		return r;
	close(newfdnum);
  801821:	8b 45 0c             	mov    0xc(%ebp),%eax
  801824:	89 04 24             	mov    %eax,(%esp)
  801827:	e8 7b ff ff ff       	call   8017a7 <close>

	newfd = INDEX2FD(newfdnum);
  80182c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80182f:	c1 e3 0c             	shl    $0xc,%ebx
  801832:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801838:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80183b:	89 04 24             	mov    %eax,(%esp)
  80183e:	e8 cd fd ff ff       	call   801610 <fd2data>
  801843:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801845:	89 1c 24             	mov    %ebx,(%esp)
  801848:	e8 c3 fd ff ff       	call   801610 <fd2data>
  80184d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80184f:	89 f0                	mov    %esi,%eax
  801851:	c1 e8 16             	shr    $0x16,%eax
  801854:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80185b:	a8 01                	test   $0x1,%al
  80185d:	74 43                	je     8018a2 <dup+0xa6>
  80185f:	89 f0                	mov    %esi,%eax
  801861:	c1 e8 0c             	shr    $0xc,%eax
  801864:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80186b:	f6 c2 01             	test   $0x1,%dl
  80186e:	74 32                	je     8018a2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801870:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801877:	25 07 0e 00 00       	and    $0xe07,%eax
  80187c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801880:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801884:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80188b:	00 
  80188c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801890:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801897:	e8 6b f6 ff ff       	call   800f07 <sys_page_map>
  80189c:	89 c6                	mov    %eax,%esi
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	78 3e                	js     8018e0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018a5:	89 c2                	mov    %eax,%edx
  8018a7:	c1 ea 0c             	shr    $0xc,%edx
  8018aa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018b1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8018b7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8018bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8018bf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018c6:	00 
  8018c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018d2:	e8 30 f6 ff ff       	call   800f07 <sys_page_map>
  8018d7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8018d9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8018dc:	85 f6                	test   %esi,%esi
  8018de:	79 22                	jns    801902 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8018e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018eb:	e8 6a f6 ff ff       	call   800f5a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8018f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018fb:	e8 5a f6 ff ff       	call   800f5a <sys_page_unmap>
	return r;
  801900:	89 f0                	mov    %esi,%eax
}
  801902:	83 c4 3c             	add    $0x3c,%esp
  801905:	5b                   	pop    %ebx
  801906:	5e                   	pop    %esi
  801907:	5f                   	pop    %edi
  801908:	5d                   	pop    %ebp
  801909:	c3                   	ret    

0080190a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80190a:	55                   	push   %ebp
  80190b:	89 e5                	mov    %esp,%ebp
  80190d:	53                   	push   %ebx
  80190e:	83 ec 24             	sub    $0x24,%esp
  801911:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801914:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801917:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191b:	89 1c 24             	mov    %ebx,(%esp)
  80191e:	e8 53 fd ff ff       	call   801676 <fd_lookup>
  801923:	89 c2                	mov    %eax,%edx
  801925:	85 d2                	test   %edx,%edx
  801927:	78 6d                	js     801996 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801929:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801933:	8b 00                	mov    (%eax),%eax
  801935:	89 04 24             	mov    %eax,(%esp)
  801938:	e8 8f fd ff ff       	call   8016cc <dev_lookup>
  80193d:	85 c0                	test   %eax,%eax
  80193f:	78 55                	js     801996 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801944:	8b 50 08             	mov    0x8(%eax),%edx
  801947:	83 e2 03             	and    $0x3,%edx
  80194a:	83 fa 01             	cmp    $0x1,%edx
  80194d:	75 23                	jne    801972 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80194f:	a1 08 50 80 00       	mov    0x805008,%eax
  801954:	8b 40 48             	mov    0x48(%eax),%eax
  801957:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80195b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195f:	c7 04 24 05 34 80 00 	movl   $0x803405,(%esp)
  801966:	e8 04 eb ff ff       	call   80046f <cprintf>
		return -E_INVAL;
  80196b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801970:	eb 24                	jmp    801996 <read+0x8c>
	}
	if (!dev->dev_read)
  801972:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801975:	8b 52 08             	mov    0x8(%edx),%edx
  801978:	85 d2                	test   %edx,%edx
  80197a:	74 15                	je     801991 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80197c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80197f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801983:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801986:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80198a:	89 04 24             	mov    %eax,(%esp)
  80198d:	ff d2                	call   *%edx
  80198f:	eb 05                	jmp    801996 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801991:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801996:	83 c4 24             	add    $0x24,%esp
  801999:	5b                   	pop    %ebx
  80199a:	5d                   	pop    %ebp
  80199b:	c3                   	ret    

0080199c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	57                   	push   %edi
  8019a0:	56                   	push   %esi
  8019a1:	53                   	push   %ebx
  8019a2:	83 ec 1c             	sub    $0x1c,%esp
  8019a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019b0:	eb 23                	jmp    8019d5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019b2:	89 f0                	mov    %esi,%eax
  8019b4:	29 d8                	sub    %ebx,%eax
  8019b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019ba:	89 d8                	mov    %ebx,%eax
  8019bc:	03 45 0c             	add    0xc(%ebp),%eax
  8019bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c3:	89 3c 24             	mov    %edi,(%esp)
  8019c6:	e8 3f ff ff ff       	call   80190a <read>
		if (m < 0)
  8019cb:	85 c0                	test   %eax,%eax
  8019cd:	78 10                	js     8019df <readn+0x43>
			return m;
		if (m == 0)
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	74 0a                	je     8019dd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019d3:	01 c3                	add    %eax,%ebx
  8019d5:	39 f3                	cmp    %esi,%ebx
  8019d7:	72 d9                	jb     8019b2 <readn+0x16>
  8019d9:	89 d8                	mov    %ebx,%eax
  8019db:	eb 02                	jmp    8019df <readn+0x43>
  8019dd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8019df:	83 c4 1c             	add    $0x1c,%esp
  8019e2:	5b                   	pop    %ebx
  8019e3:	5e                   	pop    %esi
  8019e4:	5f                   	pop    %edi
  8019e5:	5d                   	pop    %ebp
  8019e6:	c3                   	ret    

008019e7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	53                   	push   %ebx
  8019eb:	83 ec 24             	sub    $0x24,%esp
  8019ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f8:	89 1c 24             	mov    %ebx,(%esp)
  8019fb:	e8 76 fc ff ff       	call   801676 <fd_lookup>
  801a00:	89 c2                	mov    %eax,%edx
  801a02:	85 d2                	test   %edx,%edx
  801a04:	78 68                	js     801a6e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a10:	8b 00                	mov    (%eax),%eax
  801a12:	89 04 24             	mov    %eax,(%esp)
  801a15:	e8 b2 fc ff ff       	call   8016cc <dev_lookup>
  801a1a:	85 c0                	test   %eax,%eax
  801a1c:	78 50                	js     801a6e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a21:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a25:	75 23                	jne    801a4a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a27:	a1 08 50 80 00       	mov    0x805008,%eax
  801a2c:	8b 40 48             	mov    0x48(%eax),%eax
  801a2f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a37:	c7 04 24 21 34 80 00 	movl   $0x803421,(%esp)
  801a3e:	e8 2c ea ff ff       	call   80046f <cprintf>
		return -E_INVAL;
  801a43:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a48:	eb 24                	jmp    801a6e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a4d:	8b 52 0c             	mov    0xc(%edx),%edx
  801a50:	85 d2                	test   %edx,%edx
  801a52:	74 15                	je     801a69 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a54:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a5e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a62:	89 04 24             	mov    %eax,(%esp)
  801a65:	ff d2                	call   *%edx
  801a67:	eb 05                	jmp    801a6e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a69:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a6e:	83 c4 24             	add    $0x24,%esp
  801a71:	5b                   	pop    %ebx
  801a72:	5d                   	pop    %ebp
  801a73:	c3                   	ret    

00801a74 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a7a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	89 04 24             	mov    %eax,(%esp)
  801a87:	e8 ea fb ff ff       	call   801676 <fd_lookup>
  801a8c:	85 c0                	test   %eax,%eax
  801a8e:	78 0e                	js     801a9e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801a90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a96:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	53                   	push   %ebx
  801aa4:	83 ec 24             	sub    $0x24,%esp
  801aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aaa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab1:	89 1c 24             	mov    %ebx,(%esp)
  801ab4:	e8 bd fb ff ff       	call   801676 <fd_lookup>
  801ab9:	89 c2                	mov    %eax,%edx
  801abb:	85 d2                	test   %edx,%edx
  801abd:	78 61                	js     801b20 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801abf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac9:	8b 00                	mov    (%eax),%eax
  801acb:	89 04 24             	mov    %eax,(%esp)
  801ace:	e8 f9 fb ff ff       	call   8016cc <dev_lookup>
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	78 49                	js     801b20 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ada:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801ade:	75 23                	jne    801b03 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801ae0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801ae5:	8b 40 48             	mov    0x48(%eax),%eax
  801ae8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af0:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  801af7:	e8 73 e9 ff ff       	call   80046f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801afc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b01:	eb 1d                	jmp    801b20 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801b03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b06:	8b 52 18             	mov    0x18(%edx),%edx
  801b09:	85 d2                	test   %edx,%edx
  801b0b:	74 0e                	je     801b1b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b10:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b14:	89 04 24             	mov    %eax,(%esp)
  801b17:	ff d2                	call   *%edx
  801b19:	eb 05                	jmp    801b20 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801b1b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801b20:	83 c4 24             	add    $0x24,%esp
  801b23:	5b                   	pop    %ebx
  801b24:	5d                   	pop    %ebp
  801b25:	c3                   	ret    

00801b26 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	53                   	push   %ebx
  801b2a:	83 ec 24             	sub    $0x24,%esp
  801b2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b30:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	89 04 24             	mov    %eax,(%esp)
  801b3d:	e8 34 fb ff ff       	call   801676 <fd_lookup>
  801b42:	89 c2                	mov    %eax,%edx
  801b44:	85 d2                	test   %edx,%edx
  801b46:	78 52                	js     801b9a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b52:	8b 00                	mov    (%eax),%eax
  801b54:	89 04 24             	mov    %eax,(%esp)
  801b57:	e8 70 fb ff ff       	call   8016cc <dev_lookup>
  801b5c:	85 c0                	test   %eax,%eax
  801b5e:	78 3a                	js     801b9a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b63:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b67:	74 2c                	je     801b95 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b69:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b6c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b73:	00 00 00 
	stat->st_isdir = 0;
  801b76:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b7d:	00 00 00 
	stat->st_dev = dev;
  801b80:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b86:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b8d:	89 14 24             	mov    %edx,(%esp)
  801b90:	ff 50 14             	call   *0x14(%eax)
  801b93:	eb 05                	jmp    801b9a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801b95:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801b9a:	83 c4 24             	add    $0x24,%esp
  801b9d:	5b                   	pop    %ebx
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    

00801ba0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	56                   	push   %esi
  801ba4:	53                   	push   %ebx
  801ba5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ba8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801baf:	00 
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	89 04 24             	mov    %eax,(%esp)
  801bb6:	e8 84 02 00 00       	call   801e3f <open>
  801bbb:	89 c3                	mov    %eax,%ebx
  801bbd:	85 db                	test   %ebx,%ebx
  801bbf:	78 1b                	js     801bdc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc8:	89 1c 24             	mov    %ebx,(%esp)
  801bcb:	e8 56 ff ff ff       	call   801b26 <fstat>
  801bd0:	89 c6                	mov    %eax,%esi
	close(fd);
  801bd2:	89 1c 24             	mov    %ebx,(%esp)
  801bd5:	e8 cd fb ff ff       	call   8017a7 <close>
	return r;
  801bda:	89 f0                	mov    %esi,%eax
}
  801bdc:	83 c4 10             	add    $0x10,%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5d                   	pop    %ebp
  801be2:	c3                   	ret    

00801be3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
  801be6:	56                   	push   %esi
  801be7:	53                   	push   %ebx
  801be8:	83 ec 10             	sub    $0x10,%esp
  801beb:	89 c6                	mov    %eax,%esi
  801bed:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801bef:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801bf6:	75 11                	jne    801c09 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801bf8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801bff:	e8 11 0f 00 00       	call   802b15 <ipc_find_env>
  801c04:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c09:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c10:	00 
  801c11:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801c18:	00 
  801c19:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c1d:	a1 00 50 80 00       	mov    0x805000,%eax
  801c22:	89 04 24             	mov    %eax,(%esp)
  801c25:	e8 5e 0e 00 00       	call   802a88 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c2a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c31:	00 
  801c32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c36:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c3d:	e8 de 0d 00 00       	call   802a20 <ipc_recv>
}
  801c42:	83 c4 10             	add    $0x10,%esp
  801c45:	5b                   	pop    %ebx
  801c46:	5e                   	pop    %esi
  801c47:	5d                   	pop    %ebp
  801c48:	c3                   	ret    

00801c49 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	8b 40 0c             	mov    0xc(%eax),%eax
  801c55:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c62:	ba 00 00 00 00       	mov    $0x0,%edx
  801c67:	b8 02 00 00 00       	mov    $0x2,%eax
  801c6c:	e8 72 ff ff ff       	call   801be3 <fsipc>
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c7f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801c84:	ba 00 00 00 00       	mov    $0x0,%edx
  801c89:	b8 06 00 00 00       	mov    $0x6,%eax
  801c8e:	e8 50 ff ff ff       	call   801be3 <fsipc>
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	53                   	push   %ebx
  801c99:	83 ec 14             	sub    $0x14,%esp
  801c9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801caa:	ba 00 00 00 00       	mov    $0x0,%edx
  801caf:	b8 05 00 00 00       	mov    $0x5,%eax
  801cb4:	e8 2a ff ff ff       	call   801be3 <fsipc>
  801cb9:	89 c2                	mov    %eax,%edx
  801cbb:	85 d2                	test   %edx,%edx
  801cbd:	78 2b                	js     801cea <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cbf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cc6:	00 
  801cc7:	89 1c 24             	mov    %ebx,(%esp)
  801cca:	e8 c8 ed ff ff       	call   800a97 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ccf:	a1 80 60 80 00       	mov    0x806080,%eax
  801cd4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cda:	a1 84 60 80 00       	mov    0x806084,%eax
  801cdf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ce5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cea:	83 c4 14             	add    $0x14,%esp
  801ced:	5b                   	pop    %ebx
  801cee:	5d                   	pop    %ebp
  801cef:	c3                   	ret    

00801cf0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
  801cf3:	53                   	push   %ebx
  801cf4:	83 ec 14             	sub    $0x14,%esp
  801cf7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	8b 40 0c             	mov    0xc(%eax),%eax
  801d00:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801d05:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801d0b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801d10:	0f 46 c3             	cmovbe %ebx,%eax
  801d13:	a3 04 60 80 00       	mov    %eax,0x806004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801d18:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d23:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801d2a:	e8 05 ef ff ff       	call   800c34 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801d2f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d34:	b8 04 00 00 00       	mov    $0x4,%eax
  801d39:	e8 a5 fe ff ff       	call   801be3 <fsipc>
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	78 53                	js     801d95 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801d42:	39 c3                	cmp    %eax,%ebx
  801d44:	73 24                	jae    801d6a <devfile_write+0x7a>
  801d46:	c7 44 24 0c 54 34 80 	movl   $0x803454,0xc(%esp)
  801d4d:	00 
  801d4e:	c7 44 24 08 5b 34 80 	movl   $0x80345b,0x8(%esp)
  801d55:	00 
  801d56:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801d5d:	00 
  801d5e:	c7 04 24 70 34 80 00 	movl   $0x803470,(%esp)
  801d65:	e8 0c e6 ff ff       	call   800376 <_panic>
	assert(r <= PGSIZE);
  801d6a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801d6f:	7e 24                	jle    801d95 <devfile_write+0xa5>
  801d71:	c7 44 24 0c 7b 34 80 	movl   $0x80347b,0xc(%esp)
  801d78:	00 
  801d79:	c7 44 24 08 5b 34 80 	movl   $0x80345b,0x8(%esp)
  801d80:	00 
  801d81:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801d88:	00 
  801d89:	c7 04 24 70 34 80 00 	movl   $0x803470,(%esp)
  801d90:	e8 e1 e5 ff ff       	call   800376 <_panic>
	return r;
}
  801d95:	83 c4 14             	add    $0x14,%esp
  801d98:	5b                   	pop    %ebx
  801d99:	5d                   	pop    %ebp
  801d9a:	c3                   	ret    

00801d9b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	56                   	push   %esi
  801d9f:	53                   	push   %ebx
  801da0:	83 ec 10             	sub    $0x10,%esp
  801da3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	8b 40 0c             	mov    0xc(%eax),%eax
  801dac:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801db1:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801db7:	ba 00 00 00 00       	mov    $0x0,%edx
  801dbc:	b8 03 00 00 00       	mov    $0x3,%eax
  801dc1:	e8 1d fe ff ff       	call   801be3 <fsipc>
  801dc6:	89 c3                	mov    %eax,%ebx
  801dc8:	85 c0                	test   %eax,%eax
  801dca:	78 6a                	js     801e36 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801dcc:	39 c6                	cmp    %eax,%esi
  801dce:	73 24                	jae    801df4 <devfile_read+0x59>
  801dd0:	c7 44 24 0c 54 34 80 	movl   $0x803454,0xc(%esp)
  801dd7:	00 
  801dd8:	c7 44 24 08 5b 34 80 	movl   $0x80345b,0x8(%esp)
  801ddf:	00 
  801de0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801de7:	00 
  801de8:	c7 04 24 70 34 80 00 	movl   $0x803470,(%esp)
  801def:	e8 82 e5 ff ff       	call   800376 <_panic>
	assert(r <= PGSIZE);
  801df4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801df9:	7e 24                	jle    801e1f <devfile_read+0x84>
  801dfb:	c7 44 24 0c 7b 34 80 	movl   $0x80347b,0xc(%esp)
  801e02:	00 
  801e03:	c7 44 24 08 5b 34 80 	movl   $0x80345b,0x8(%esp)
  801e0a:	00 
  801e0b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801e12:	00 
  801e13:	c7 04 24 70 34 80 00 	movl   $0x803470,(%esp)
  801e1a:	e8 57 e5 ff ff       	call   800376 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e1f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e23:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e2a:	00 
  801e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2e:	89 04 24             	mov    %eax,(%esp)
  801e31:	e8 fe ed ff ff       	call   800c34 <memmove>
	return r;
}
  801e36:	89 d8                	mov    %ebx,%eax
  801e38:	83 c4 10             	add    $0x10,%esp
  801e3b:	5b                   	pop    %ebx
  801e3c:	5e                   	pop    %esi
  801e3d:	5d                   	pop    %ebp
  801e3e:	c3                   	ret    

00801e3f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	53                   	push   %ebx
  801e43:	83 ec 24             	sub    $0x24,%esp
  801e46:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801e49:	89 1c 24             	mov    %ebx,(%esp)
  801e4c:	e8 0f ec ff ff       	call   800a60 <strlen>
  801e51:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e56:	7f 60                	jg     801eb8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801e58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e5b:	89 04 24             	mov    %eax,(%esp)
  801e5e:	e8 c4 f7 ff ff       	call   801627 <fd_alloc>
  801e63:	89 c2                	mov    %eax,%edx
  801e65:	85 d2                	test   %edx,%edx
  801e67:	78 54                	js     801ebd <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801e69:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e6d:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801e74:	e8 1e ec ff ff       	call   800a97 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7c:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e84:	b8 01 00 00 00       	mov    $0x1,%eax
  801e89:	e8 55 fd ff ff       	call   801be3 <fsipc>
  801e8e:	89 c3                	mov    %eax,%ebx
  801e90:	85 c0                	test   %eax,%eax
  801e92:	79 17                	jns    801eab <open+0x6c>
		fd_close(fd, 0);
  801e94:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e9b:	00 
  801e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9f:	89 04 24             	mov    %eax,(%esp)
  801ea2:	e8 7f f8 ff ff       	call   801726 <fd_close>
		return r;
  801ea7:	89 d8                	mov    %ebx,%eax
  801ea9:	eb 12                	jmp    801ebd <open+0x7e>
	}

	return fd2num(fd);
  801eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eae:	89 04 24             	mov    %eax,(%esp)
  801eb1:	e8 4a f7 ff ff       	call   801600 <fd2num>
  801eb6:	eb 05                	jmp    801ebd <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801eb8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801ebd:	83 c4 24             	add    $0x24,%esp
  801ec0:	5b                   	pop    %ebx
  801ec1:	5d                   	pop    %ebp
  801ec2:	c3                   	ret    

00801ec3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
  801ec6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ec9:	ba 00 00 00 00       	mov    $0x0,%edx
  801ece:	b8 08 00 00 00       	mov    $0x8,%eax
  801ed3:	e8 0b fd ff ff       	call   801be3 <fsipc>
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    
  801eda:	66 90                	xchg   %ax,%ax
  801edc:	66 90                	xchg   %ax,%ax
  801ede:	66 90                	xchg   %ax,%ax

00801ee0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ee6:	c7 44 24 04 87 34 80 	movl   $0x803487,0x4(%esp)
  801eed:	00 
  801eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef1:	89 04 24             	mov    %eax,(%esp)
  801ef4:	e8 9e eb ff ff       	call   800a97 <strcpy>
	return 0;
}
  801ef9:	b8 00 00 00 00       	mov    $0x0,%eax
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	53                   	push   %ebx
  801f04:	83 ec 14             	sub    $0x14,%esp
  801f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f0a:	89 1c 24             	mov    %ebx,(%esp)
  801f0d:	e8 3d 0c 00 00       	call   802b4f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801f12:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801f17:	83 f8 01             	cmp    $0x1,%eax
  801f1a:	75 0d                	jne    801f29 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801f1c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f1f:	89 04 24             	mov    %eax,(%esp)
  801f22:	e8 29 03 00 00       	call   802250 <nsipc_close>
  801f27:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801f29:	89 d0                	mov    %edx,%eax
  801f2b:	83 c4 14             	add    $0x14,%esp
  801f2e:	5b                   	pop    %ebx
  801f2f:	5d                   	pop    %ebp
  801f30:	c3                   	ret    

00801f31 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f37:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f3e:	00 
  801f3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f42:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f50:	8b 40 0c             	mov    0xc(%eax),%eax
  801f53:	89 04 24             	mov    %eax,(%esp)
  801f56:	e8 f0 03 00 00       	call   80234b <nsipc_send>
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f63:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f6a:	00 
  801f6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f75:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7f:	89 04 24             	mov    %eax,(%esp)
  801f82:	e8 44 03 00 00       	call   8022cb <nsipc_recv>
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f8f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801f92:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f96:	89 04 24             	mov    %eax,(%esp)
  801f99:	e8 d8 f6 ff ff       	call   801676 <fd_lookup>
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	78 17                	js     801fb9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa5:	8b 0d 24 40 80 00    	mov    0x804024,%ecx
  801fab:	39 08                	cmp    %ecx,(%eax)
  801fad:	75 05                	jne    801fb4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801faf:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb2:	eb 05                	jmp    801fb9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801fb4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	56                   	push   %esi
  801fbf:	53                   	push   %ebx
  801fc0:	83 ec 20             	sub    $0x20,%esp
  801fc3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801fc5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc8:	89 04 24             	mov    %eax,(%esp)
  801fcb:	e8 57 f6 ff ff       	call   801627 <fd_alloc>
  801fd0:	89 c3                	mov    %eax,%ebx
  801fd2:	85 c0                	test   %eax,%eax
  801fd4:	78 21                	js     801ff7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fd6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fdd:	00 
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fec:	e8 c2 ee ff ff       	call   800eb3 <sys_page_alloc>
  801ff1:	89 c3                	mov    %eax,%ebx
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	79 0c                	jns    802003 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801ff7:	89 34 24             	mov    %esi,(%esp)
  801ffa:	e8 51 02 00 00       	call   802250 <nsipc_close>
		return r;
  801fff:	89 d8                	mov    %ebx,%eax
  802001:	eb 20                	jmp    802023 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802003:	8b 15 24 40 80 00    	mov    0x804024,%edx
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80200e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802011:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802018:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80201b:	89 14 24             	mov    %edx,(%esp)
  80201e:	e8 dd f5 ff ff       	call   801600 <fd2num>
}
  802023:	83 c4 20             	add    $0x20,%esp
  802026:	5b                   	pop    %ebx
  802027:	5e                   	pop    %esi
  802028:	5d                   	pop    %ebp
  802029:	c3                   	ret    

0080202a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	e8 51 ff ff ff       	call   801f89 <fd2sockid>
		return r;
  802038:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80203a:	85 c0                	test   %eax,%eax
  80203c:	78 23                	js     802061 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80203e:	8b 55 10             	mov    0x10(%ebp),%edx
  802041:	89 54 24 08          	mov    %edx,0x8(%esp)
  802045:	8b 55 0c             	mov    0xc(%ebp),%edx
  802048:	89 54 24 04          	mov    %edx,0x4(%esp)
  80204c:	89 04 24             	mov    %eax,(%esp)
  80204f:	e8 45 01 00 00       	call   802199 <nsipc_accept>
		return r;
  802054:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802056:	85 c0                	test   %eax,%eax
  802058:	78 07                	js     802061 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80205a:	e8 5c ff ff ff       	call   801fbb <alloc_sockfd>
  80205f:	89 c1                	mov    %eax,%ecx
}
  802061:	89 c8                	mov    %ecx,%eax
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	e8 16 ff ff ff       	call   801f89 <fd2sockid>
  802073:	89 c2                	mov    %eax,%edx
  802075:	85 d2                	test   %edx,%edx
  802077:	78 16                	js     80208f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802079:	8b 45 10             	mov    0x10(%ebp),%eax
  80207c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802080:	8b 45 0c             	mov    0xc(%ebp),%eax
  802083:	89 44 24 04          	mov    %eax,0x4(%esp)
  802087:	89 14 24             	mov    %edx,(%esp)
  80208a:	e8 60 01 00 00       	call   8021ef <nsipc_bind>
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <shutdown>:

int
shutdown(int s, int how)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	e8 ea fe ff ff       	call   801f89 <fd2sockid>
  80209f:	89 c2                	mov    %eax,%edx
  8020a1:	85 d2                	test   %edx,%edx
  8020a3:	78 0f                	js     8020b4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8020a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ac:	89 14 24             	mov    %edx,(%esp)
  8020af:	e8 7a 01 00 00       	call   80222e <nsipc_shutdown>
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bf:	e8 c5 fe ff ff       	call   801f89 <fd2sockid>
  8020c4:	89 c2                	mov    %eax,%edx
  8020c6:	85 d2                	test   %edx,%edx
  8020c8:	78 16                	js     8020e0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8020ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8020cd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d8:	89 14 24             	mov    %edx,(%esp)
  8020db:	e8 8a 01 00 00       	call   80226a <nsipc_connect>
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <listen>:

int
listen(int s, int backlog)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	e8 99 fe ff ff       	call   801f89 <fd2sockid>
  8020f0:	89 c2                	mov    %eax,%edx
  8020f2:	85 d2                	test   %edx,%edx
  8020f4:	78 0f                	js     802105 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8020f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fd:	89 14 24             	mov    %edx,(%esp)
  802100:	e8 a4 01 00 00       	call   8022a9 <nsipc_listen>
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80210d:	8b 45 10             	mov    0x10(%ebp),%eax
  802110:	89 44 24 08          	mov    %eax,0x8(%esp)
  802114:	8b 45 0c             	mov    0xc(%ebp),%eax
  802117:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	89 04 24             	mov    %eax,(%esp)
  802121:	e8 98 02 00 00       	call   8023be <nsipc_socket>
  802126:	89 c2                	mov    %eax,%edx
  802128:	85 d2                	test   %edx,%edx
  80212a:	78 05                	js     802131 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80212c:	e8 8a fe ff ff       	call   801fbb <alloc_sockfd>
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	53                   	push   %ebx
  802137:	83 ec 14             	sub    $0x14,%esp
  80213a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80213c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802143:	75 11                	jne    802156 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802145:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80214c:	e8 c4 09 00 00       	call   802b15 <ipc_find_env>
  802151:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802156:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80215d:	00 
  80215e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802165:	00 
  802166:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80216a:	a1 04 50 80 00       	mov    0x805004,%eax
  80216f:	89 04 24             	mov    %eax,(%esp)
  802172:	e8 11 09 00 00       	call   802a88 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802177:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80217e:	00 
  80217f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802186:	00 
  802187:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80218e:	e8 8d 08 00 00       	call   802a20 <ipc_recv>
}
  802193:	83 c4 14             	add    $0x14,%esp
  802196:	5b                   	pop    %ebx
  802197:	5d                   	pop    %ebp
  802198:	c3                   	ret    

00802199 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
  80219c:	56                   	push   %esi
  80219d:	53                   	push   %ebx
  80219e:	83 ec 10             	sub    $0x10,%esp
  8021a1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021ac:	8b 06                	mov    (%esi),%eax
  8021ae:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8021b8:	e8 76 ff ff ff       	call   802133 <nsipc>
  8021bd:	89 c3                	mov    %eax,%ebx
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	78 23                	js     8021e6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021c3:	a1 10 70 80 00       	mov    0x807010,%eax
  8021c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021cc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8021d3:	00 
  8021d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d7:	89 04 24             	mov    %eax,(%esp)
  8021da:	e8 55 ea ff ff       	call   800c34 <memmove>
		*addrlen = ret->ret_addrlen;
  8021df:	a1 10 70 80 00       	mov    0x807010,%eax
  8021e4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8021e6:	89 d8                	mov    %ebx,%eax
  8021e8:	83 c4 10             	add    $0x10,%esp
  8021eb:	5b                   	pop    %ebx
  8021ec:	5e                   	pop    %esi
  8021ed:	5d                   	pop    %ebp
  8021ee:	c3                   	ret    

008021ef <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
  8021f2:	53                   	push   %ebx
  8021f3:	83 ec 14             	sub    $0x14,%esp
  8021f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802201:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802205:	8b 45 0c             	mov    0xc(%ebp),%eax
  802208:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802213:	e8 1c ea ff ff       	call   800c34 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802218:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80221e:	b8 02 00 00 00       	mov    $0x2,%eax
  802223:	e8 0b ff ff ff       	call   802133 <nsipc>
}
  802228:	83 c4 14             	add    $0x14,%esp
  80222b:	5b                   	pop    %ebx
  80222c:	5d                   	pop    %ebp
  80222d:	c3                   	ret    

0080222e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80223c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802244:	b8 03 00 00 00       	mov    $0x3,%eax
  802249:	e8 e5 fe ff ff       	call   802133 <nsipc>
}
  80224e:	c9                   	leave  
  80224f:	c3                   	ret    

00802250 <nsipc_close>:

int
nsipc_close(int s)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80225e:	b8 04 00 00 00       	mov    $0x4,%eax
  802263:	e8 cb fe ff ff       	call   802133 <nsipc>
}
  802268:	c9                   	leave  
  802269:	c3                   	ret    

0080226a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80226a:	55                   	push   %ebp
  80226b:	89 e5                	mov    %esp,%ebp
  80226d:	53                   	push   %ebx
  80226e:	83 ec 14             	sub    $0x14,%esp
  802271:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80227c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802280:	8b 45 0c             	mov    0xc(%ebp),%eax
  802283:	89 44 24 04          	mov    %eax,0x4(%esp)
  802287:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80228e:	e8 a1 e9 ff ff       	call   800c34 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802293:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802299:	b8 05 00 00 00       	mov    $0x5,%eax
  80229e:	e8 90 fe ff ff       	call   802133 <nsipc>
}
  8022a3:	83 c4 14             	add    $0x14,%esp
  8022a6:	5b                   	pop    %ebx
  8022a7:	5d                   	pop    %ebp
  8022a8:	c3                   	ret    

008022a9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
  8022ac:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8022b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ba:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8022bf:	b8 06 00 00 00       	mov    $0x6,%eax
  8022c4:	e8 6a fe ff ff       	call   802133 <nsipc>
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	56                   	push   %esi
  8022cf:	53                   	push   %ebx
  8022d0:	83 ec 10             	sub    $0x10,%esp
  8022d3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8022de:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8022e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8022e7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022ec:	b8 07 00 00 00       	mov    $0x7,%eax
  8022f1:	e8 3d fe ff ff       	call   802133 <nsipc>
  8022f6:	89 c3                	mov    %eax,%ebx
  8022f8:	85 c0                	test   %eax,%eax
  8022fa:	78 46                	js     802342 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8022fc:	39 f0                	cmp    %esi,%eax
  8022fe:	7f 07                	jg     802307 <nsipc_recv+0x3c>
  802300:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802305:	7e 24                	jle    80232b <nsipc_recv+0x60>
  802307:	c7 44 24 0c 93 34 80 	movl   $0x803493,0xc(%esp)
  80230e:	00 
  80230f:	c7 44 24 08 5b 34 80 	movl   $0x80345b,0x8(%esp)
  802316:	00 
  802317:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80231e:	00 
  80231f:	c7 04 24 a8 34 80 00 	movl   $0x8034a8,(%esp)
  802326:	e8 4b e0 ff ff       	call   800376 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80232b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80232f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802336:	00 
  802337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80233a:	89 04 24             	mov    %eax,(%esp)
  80233d:	e8 f2 e8 ff ff       	call   800c34 <memmove>
	}

	return r;
}
  802342:	89 d8                	mov    %ebx,%eax
  802344:	83 c4 10             	add    $0x10,%esp
  802347:	5b                   	pop    %ebx
  802348:	5e                   	pop    %esi
  802349:	5d                   	pop    %ebp
  80234a:	c3                   	ret    

0080234b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	53                   	push   %ebx
  80234f:	83 ec 14             	sub    $0x14,%esp
  802352:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80235d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802363:	7e 24                	jle    802389 <nsipc_send+0x3e>
  802365:	c7 44 24 0c b4 34 80 	movl   $0x8034b4,0xc(%esp)
  80236c:	00 
  80236d:	c7 44 24 08 5b 34 80 	movl   $0x80345b,0x8(%esp)
  802374:	00 
  802375:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80237c:	00 
  80237d:	c7 04 24 a8 34 80 00 	movl   $0x8034a8,(%esp)
  802384:	e8 ed df ff ff       	call   800376 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802389:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80238d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802390:	89 44 24 04          	mov    %eax,0x4(%esp)
  802394:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80239b:	e8 94 e8 ff ff       	call   800c34 <memmove>
	nsipcbuf.send.req_size = size;
  8023a0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8023a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8023ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8023b3:	e8 7b fd ff ff       	call   802133 <nsipc>
}
  8023b8:	83 c4 14             	add    $0x14,%esp
  8023bb:	5b                   	pop    %ebx
  8023bc:	5d                   	pop    %ebp
  8023bd:	c3                   	ret    

008023be <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023be:	55                   	push   %ebp
  8023bf:	89 e5                	mov    %esp,%ebp
  8023c1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8023cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023cf:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8023d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8023dc:	b8 09 00 00 00       	mov    $0x9,%eax
  8023e1:	e8 4d fd ff ff       	call   802133 <nsipc>
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
  8023eb:	56                   	push   %esi
  8023ec:	53                   	push   %ebx
  8023ed:	83 ec 10             	sub    $0x10,%esp
  8023f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f6:	89 04 24             	mov    %eax,(%esp)
  8023f9:	e8 12 f2 ff ff       	call   801610 <fd2data>
  8023fe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802400:	c7 44 24 04 c0 34 80 	movl   $0x8034c0,0x4(%esp)
  802407:	00 
  802408:	89 1c 24             	mov    %ebx,(%esp)
  80240b:	e8 87 e6 ff ff       	call   800a97 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802410:	8b 46 04             	mov    0x4(%esi),%eax
  802413:	2b 06                	sub    (%esi),%eax
  802415:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80241b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802422:	00 00 00 
	stat->st_dev = &devpipe;
  802425:	c7 83 88 00 00 00 40 	movl   $0x804040,0x88(%ebx)
  80242c:	40 80 00 
	return 0;
}
  80242f:	b8 00 00 00 00       	mov    $0x0,%eax
  802434:	83 c4 10             	add    $0x10,%esp
  802437:	5b                   	pop    %ebx
  802438:	5e                   	pop    %esi
  802439:	5d                   	pop    %ebp
  80243a:	c3                   	ret    

0080243b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
  80243e:	53                   	push   %ebx
  80243f:	83 ec 14             	sub    $0x14,%esp
  802442:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802445:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802449:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802450:	e8 05 eb ff ff       	call   800f5a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802455:	89 1c 24             	mov    %ebx,(%esp)
  802458:	e8 b3 f1 ff ff       	call   801610 <fd2data>
  80245d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802461:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802468:	e8 ed ea ff ff       	call   800f5a <sys_page_unmap>
}
  80246d:	83 c4 14             	add    $0x14,%esp
  802470:	5b                   	pop    %ebx
  802471:	5d                   	pop    %ebp
  802472:	c3                   	ret    

00802473 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
  802476:	57                   	push   %edi
  802477:	56                   	push   %esi
  802478:	53                   	push   %ebx
  802479:	83 ec 2c             	sub    $0x2c,%esp
  80247c:	89 c6                	mov    %eax,%esi
  80247e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802481:	a1 08 50 80 00       	mov    0x805008,%eax
  802486:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802489:	89 34 24             	mov    %esi,(%esp)
  80248c:	e8 be 06 00 00       	call   802b4f <pageref>
  802491:	89 c7                	mov    %eax,%edi
  802493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802496:	89 04 24             	mov    %eax,(%esp)
  802499:	e8 b1 06 00 00       	call   802b4f <pageref>
  80249e:	39 c7                	cmp    %eax,%edi
  8024a0:	0f 94 c2             	sete   %dl
  8024a3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8024a6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8024ac:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8024af:	39 fb                	cmp    %edi,%ebx
  8024b1:	74 21                	je     8024d4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8024b3:	84 d2                	test   %dl,%dl
  8024b5:	74 ca                	je     802481 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024b7:	8b 51 58             	mov    0x58(%ecx),%edx
  8024ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024be:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024c2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024c6:	c7 04 24 c7 34 80 00 	movl   $0x8034c7,(%esp)
  8024cd:	e8 9d df ff ff       	call   80046f <cprintf>
  8024d2:	eb ad                	jmp    802481 <_pipeisclosed+0xe>
	}
}
  8024d4:	83 c4 2c             	add    $0x2c,%esp
  8024d7:	5b                   	pop    %ebx
  8024d8:	5e                   	pop    %esi
  8024d9:	5f                   	pop    %edi
  8024da:	5d                   	pop    %ebp
  8024db:	c3                   	ret    

008024dc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
  8024df:	57                   	push   %edi
  8024e0:	56                   	push   %esi
  8024e1:	53                   	push   %ebx
  8024e2:	83 ec 1c             	sub    $0x1c,%esp
  8024e5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8024e8:	89 34 24             	mov    %esi,(%esp)
  8024eb:	e8 20 f1 ff ff       	call   801610 <fd2data>
  8024f0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024f7:	eb 45                	jmp    80253e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8024f9:	89 da                	mov    %ebx,%edx
  8024fb:	89 f0                	mov    %esi,%eax
  8024fd:	e8 71 ff ff ff       	call   802473 <_pipeisclosed>
  802502:	85 c0                	test   %eax,%eax
  802504:	75 41                	jne    802547 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802506:	e8 89 e9 ff ff       	call   800e94 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80250b:	8b 43 04             	mov    0x4(%ebx),%eax
  80250e:	8b 0b                	mov    (%ebx),%ecx
  802510:	8d 51 20             	lea    0x20(%ecx),%edx
  802513:	39 d0                	cmp    %edx,%eax
  802515:	73 e2                	jae    8024f9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802517:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80251a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80251e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802521:	99                   	cltd   
  802522:	c1 ea 1b             	shr    $0x1b,%edx
  802525:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802528:	83 e1 1f             	and    $0x1f,%ecx
  80252b:	29 d1                	sub    %edx,%ecx
  80252d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802531:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802535:	83 c0 01             	add    $0x1,%eax
  802538:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80253b:	83 c7 01             	add    $0x1,%edi
  80253e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802541:	75 c8                	jne    80250b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802543:	89 f8                	mov    %edi,%eax
  802545:	eb 05                	jmp    80254c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802547:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80254c:	83 c4 1c             	add    $0x1c,%esp
  80254f:	5b                   	pop    %ebx
  802550:	5e                   	pop    %esi
  802551:	5f                   	pop    %edi
  802552:	5d                   	pop    %ebp
  802553:	c3                   	ret    

00802554 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
  802557:	57                   	push   %edi
  802558:	56                   	push   %esi
  802559:	53                   	push   %ebx
  80255a:	83 ec 1c             	sub    $0x1c,%esp
  80255d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802560:	89 3c 24             	mov    %edi,(%esp)
  802563:	e8 a8 f0 ff ff       	call   801610 <fd2data>
  802568:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80256a:	be 00 00 00 00       	mov    $0x0,%esi
  80256f:	eb 3d                	jmp    8025ae <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802571:	85 f6                	test   %esi,%esi
  802573:	74 04                	je     802579 <devpipe_read+0x25>
				return i;
  802575:	89 f0                	mov    %esi,%eax
  802577:	eb 43                	jmp    8025bc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802579:	89 da                	mov    %ebx,%edx
  80257b:	89 f8                	mov    %edi,%eax
  80257d:	e8 f1 fe ff ff       	call   802473 <_pipeisclosed>
  802582:	85 c0                	test   %eax,%eax
  802584:	75 31                	jne    8025b7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802586:	e8 09 e9 ff ff       	call   800e94 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80258b:	8b 03                	mov    (%ebx),%eax
  80258d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802590:	74 df                	je     802571 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802592:	99                   	cltd   
  802593:	c1 ea 1b             	shr    $0x1b,%edx
  802596:	01 d0                	add    %edx,%eax
  802598:	83 e0 1f             	and    $0x1f,%eax
  80259b:	29 d0                	sub    %edx,%eax
  80259d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025a5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025a8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025ab:	83 c6 01             	add    $0x1,%esi
  8025ae:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025b1:	75 d8                	jne    80258b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8025b3:	89 f0                	mov    %esi,%eax
  8025b5:	eb 05                	jmp    8025bc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8025b7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8025bc:	83 c4 1c             	add    $0x1c,%esp
  8025bf:	5b                   	pop    %ebx
  8025c0:	5e                   	pop    %esi
  8025c1:	5f                   	pop    %edi
  8025c2:	5d                   	pop    %ebp
  8025c3:	c3                   	ret    

008025c4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	56                   	push   %esi
  8025c8:	53                   	push   %ebx
  8025c9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8025cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025cf:	89 04 24             	mov    %eax,(%esp)
  8025d2:	e8 50 f0 ff ff       	call   801627 <fd_alloc>
  8025d7:	89 c2                	mov    %eax,%edx
  8025d9:	85 d2                	test   %edx,%edx
  8025db:	0f 88 4d 01 00 00    	js     80272e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025e1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025e8:	00 
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025f7:	e8 b7 e8 ff ff       	call   800eb3 <sys_page_alloc>
  8025fc:	89 c2                	mov    %eax,%edx
  8025fe:	85 d2                	test   %edx,%edx
  802600:	0f 88 28 01 00 00    	js     80272e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802606:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802609:	89 04 24             	mov    %eax,(%esp)
  80260c:	e8 16 f0 ff ff       	call   801627 <fd_alloc>
  802611:	89 c3                	mov    %eax,%ebx
  802613:	85 c0                	test   %eax,%eax
  802615:	0f 88 fe 00 00 00    	js     802719 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80261b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802622:	00 
  802623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802626:	89 44 24 04          	mov    %eax,0x4(%esp)
  80262a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802631:	e8 7d e8 ff ff       	call   800eb3 <sys_page_alloc>
  802636:	89 c3                	mov    %eax,%ebx
  802638:	85 c0                	test   %eax,%eax
  80263a:	0f 88 d9 00 00 00    	js     802719 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	89 04 24             	mov    %eax,(%esp)
  802646:	e8 c5 ef ff ff       	call   801610 <fd2data>
  80264b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80264d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802654:	00 
  802655:	89 44 24 04          	mov    %eax,0x4(%esp)
  802659:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802660:	e8 4e e8 ff ff       	call   800eb3 <sys_page_alloc>
  802665:	89 c3                	mov    %eax,%ebx
  802667:	85 c0                	test   %eax,%eax
  802669:	0f 88 97 00 00 00    	js     802706 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80266f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802672:	89 04 24             	mov    %eax,(%esp)
  802675:	e8 96 ef ff ff       	call   801610 <fd2data>
  80267a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802681:	00 
  802682:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802686:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80268d:	00 
  80268e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802692:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802699:	e8 69 e8 ff ff       	call   800f07 <sys_page_map>
  80269e:	89 c3                	mov    %eax,%ebx
  8026a0:	85 c0                	test   %eax,%eax
  8026a2:	78 52                	js     8026f6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8026a4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8026b9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8026bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8026c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	89 04 24             	mov    %eax,(%esp)
  8026d4:	e8 27 ef ff ff       	call   801600 <fd2num>
  8026d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026dc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e1:	89 04 24             	mov    %eax,(%esp)
  8026e4:	e8 17 ef ff ff       	call   801600 <fd2num>
  8026e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026ec:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f4:	eb 38                	jmp    80272e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8026f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802701:	e8 54 e8 ff ff       	call   800f5a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802706:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802709:	89 44 24 04          	mov    %eax,0x4(%esp)
  80270d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802714:	e8 41 e8 ff ff       	call   800f5a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802720:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802727:	e8 2e e8 ff ff       	call   800f5a <sys_page_unmap>
  80272c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80272e:	83 c4 30             	add    $0x30,%esp
  802731:	5b                   	pop    %ebx
  802732:	5e                   	pop    %esi
  802733:	5d                   	pop    %ebp
  802734:	c3                   	ret    

00802735 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802735:	55                   	push   %ebp
  802736:	89 e5                	mov    %esp,%ebp
  802738:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80273b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80273e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802742:	8b 45 08             	mov    0x8(%ebp),%eax
  802745:	89 04 24             	mov    %eax,(%esp)
  802748:	e8 29 ef ff ff       	call   801676 <fd_lookup>
  80274d:	89 c2                	mov    %eax,%edx
  80274f:	85 d2                	test   %edx,%edx
  802751:	78 15                	js     802768 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	89 04 24             	mov    %eax,(%esp)
  802759:	e8 b2 ee ff ff       	call   801610 <fd2data>
	return _pipeisclosed(fd, p);
  80275e:	89 c2                	mov    %eax,%edx
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	e8 0b fd ff ff       	call   802473 <_pipeisclosed>
}
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	56                   	push   %esi
  80276e:	53                   	push   %ebx
  80276f:	83 ec 10             	sub    $0x10,%esp
  802772:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802775:	85 f6                	test   %esi,%esi
  802777:	75 24                	jne    80279d <wait+0x33>
  802779:	c7 44 24 0c df 34 80 	movl   $0x8034df,0xc(%esp)
  802780:	00 
  802781:	c7 44 24 08 5b 34 80 	movl   $0x80345b,0x8(%esp)
  802788:	00 
  802789:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802790:	00 
  802791:	c7 04 24 ea 34 80 00 	movl   $0x8034ea,(%esp)
  802798:	e8 d9 db ff ff       	call   800376 <_panic>
	e = &envs[ENVX(envid)];
  80279d:	89 f3                	mov    %esi,%ebx
  80279f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8027a5:	c1 e3 07             	shl    $0x7,%ebx
  8027a8:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027ae:	eb 05                	jmp    8027b5 <wait+0x4b>
		sys_yield();
  8027b0:	e8 df e6 ff ff       	call   800e94 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8027b5:	8b 43 48             	mov    0x48(%ebx),%eax
  8027b8:	39 f0                	cmp    %esi,%eax
  8027ba:	75 07                	jne    8027c3 <wait+0x59>
  8027bc:	8b 43 54             	mov    0x54(%ebx),%eax
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	75 ed                	jne    8027b0 <wait+0x46>
		sys_yield();
}
  8027c3:	83 c4 10             	add    $0x10,%esp
  8027c6:	5b                   	pop    %ebx
  8027c7:	5e                   	pop    %esi
  8027c8:	5d                   	pop    %ebp
  8027c9:	c3                   	ret    
  8027ca:	66 90                	xchg   %ax,%ax
  8027cc:	66 90                	xchg   %ax,%ax
  8027ce:	66 90                	xchg   %ax,%ax

008027d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8027d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d8:	5d                   	pop    %ebp
  8027d9:	c3                   	ret    

008027da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8027da:	55                   	push   %ebp
  8027db:	89 e5                	mov    %esp,%ebp
  8027dd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8027e0:	c7 44 24 04 f5 34 80 	movl   $0x8034f5,0x4(%esp)
  8027e7:	00 
  8027e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027eb:	89 04 24             	mov    %eax,(%esp)
  8027ee:	e8 a4 e2 ff ff       	call   800a97 <strcpy>
	return 0;
}
  8027f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
  8027fd:	57                   	push   %edi
  8027fe:	56                   	push   %esi
  8027ff:	53                   	push   %ebx
  802800:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802806:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80280b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802811:	eb 31                	jmp    802844 <devcons_write+0x4a>
		m = n - tot;
  802813:	8b 75 10             	mov    0x10(%ebp),%esi
  802816:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802818:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80281b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802820:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802823:	89 74 24 08          	mov    %esi,0x8(%esp)
  802827:	03 45 0c             	add    0xc(%ebp),%eax
  80282a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80282e:	89 3c 24             	mov    %edi,(%esp)
  802831:	e8 fe e3 ff ff       	call   800c34 <memmove>
		sys_cputs(buf, m);
  802836:	89 74 24 04          	mov    %esi,0x4(%esp)
  80283a:	89 3c 24             	mov    %edi,(%esp)
  80283d:	e8 a4 e5 ff ff       	call   800de6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802842:	01 f3                	add    %esi,%ebx
  802844:	89 d8                	mov    %ebx,%eax
  802846:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802849:	72 c8                	jb     802813 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80284b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802851:	5b                   	pop    %ebx
  802852:	5e                   	pop    %esi
  802853:	5f                   	pop    %edi
  802854:	5d                   	pop    %ebp
  802855:	c3                   	ret    

00802856 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802856:	55                   	push   %ebp
  802857:	89 e5                	mov    %esp,%ebp
  802859:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80285c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802861:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802865:	75 07                	jne    80286e <devcons_read+0x18>
  802867:	eb 2a                	jmp    802893 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802869:	e8 26 e6 ff ff       	call   800e94 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80286e:	66 90                	xchg   %ax,%ax
  802870:	e8 8f e5 ff ff       	call   800e04 <sys_cgetc>
  802875:	85 c0                	test   %eax,%eax
  802877:	74 f0                	je     802869 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802879:	85 c0                	test   %eax,%eax
  80287b:	78 16                	js     802893 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80287d:	83 f8 04             	cmp    $0x4,%eax
  802880:	74 0c                	je     80288e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802882:	8b 55 0c             	mov    0xc(%ebp),%edx
  802885:	88 02                	mov    %al,(%edx)
	return 1;
  802887:	b8 01 00 00 00       	mov    $0x1,%eax
  80288c:	eb 05                	jmp    802893 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80288e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802893:	c9                   	leave  
  802894:	c3                   	ret    

00802895 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802895:	55                   	push   %ebp
  802896:	89 e5                	mov    %esp,%ebp
  802898:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80289b:	8b 45 08             	mov    0x8(%ebp),%eax
  80289e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8028a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8028a8:	00 
  8028a9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028ac:	89 04 24             	mov    %eax,(%esp)
  8028af:	e8 32 e5 ff ff       	call   800de6 <sys_cputs>
}
  8028b4:	c9                   	leave  
  8028b5:	c3                   	ret    

008028b6 <getchar>:

int
getchar(void)
{
  8028b6:	55                   	push   %ebp
  8028b7:	89 e5                	mov    %esp,%ebp
  8028b9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8028bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8028c3:	00 
  8028c4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028d2:	e8 33 f0 ff ff       	call   80190a <read>
	if (r < 0)
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	78 0f                	js     8028ea <getchar+0x34>
		return r;
	if (r < 1)
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	7e 06                	jle    8028e5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8028df:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8028e3:	eb 05                	jmp    8028ea <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8028e5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8028ea:	c9                   	leave  
  8028eb:	c3                   	ret    

008028ec <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8028ec:	55                   	push   %ebp
  8028ed:	89 e5                	mov    %esp,%ebp
  8028ef:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	89 04 24             	mov    %eax,(%esp)
  8028ff:	e8 72 ed ff ff       	call   801676 <fd_lookup>
  802904:	85 c0                	test   %eax,%eax
  802906:	78 11                	js     802919 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802911:	39 10                	cmp    %edx,(%eax)
  802913:	0f 94 c0             	sete   %al
  802916:	0f b6 c0             	movzbl %al,%eax
}
  802919:	c9                   	leave  
  80291a:	c3                   	ret    

0080291b <opencons>:

int
opencons(void)
{
  80291b:	55                   	push   %ebp
  80291c:	89 e5                	mov    %esp,%ebp
  80291e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802921:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802924:	89 04 24             	mov    %eax,(%esp)
  802927:	e8 fb ec ff ff       	call   801627 <fd_alloc>
		return r;
  80292c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80292e:	85 c0                	test   %eax,%eax
  802930:	78 40                	js     802972 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802932:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802939:	00 
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802941:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802948:	e8 66 e5 ff ff       	call   800eb3 <sys_page_alloc>
		return r;
  80294d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80294f:	85 c0                	test   %eax,%eax
  802951:	78 1f                	js     802972 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802953:	8b 15 5c 40 80 00    	mov    0x80405c,%edx
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802968:	89 04 24             	mov    %eax,(%esp)
  80296b:	e8 90 ec ff ff       	call   801600 <fd2num>
  802970:	89 c2                	mov    %eax,%edx
}
  802972:	89 d0                	mov    %edx,%eax
  802974:	c9                   	leave  
  802975:	c3                   	ret    

00802976 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802976:	55                   	push   %ebp
  802977:	89 e5                	mov    %esp,%ebp
  802979:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80297c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802983:	75 68                	jne    8029ed <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  802985:	a1 08 50 80 00       	mov    0x805008,%eax
  80298a:	8b 40 48             	mov    0x48(%eax),%eax
  80298d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802994:	00 
  802995:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80299c:	ee 
  80299d:	89 04 24             	mov    %eax,(%esp)
  8029a0:	e8 0e e5 ff ff       	call   800eb3 <sys_page_alloc>
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	74 2c                	je     8029d5 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  8029a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ad:	c7 04 24 04 35 80 00 	movl   $0x803504,(%esp)
  8029b4:	e8 b6 da ff ff       	call   80046f <cprintf>
			panic("set_pg_fault_handler");
  8029b9:	c7 44 24 08 38 35 80 	movl   $0x803538,0x8(%esp)
  8029c0:	00 
  8029c1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8029c8:	00 
  8029c9:	c7 04 24 4d 35 80 00 	movl   $0x80354d,(%esp)
  8029d0:	e8 a1 d9 ff ff       	call   800376 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  8029d5:	a1 08 50 80 00       	mov    0x805008,%eax
  8029da:	8b 40 48             	mov    0x48(%eax),%eax
  8029dd:	c7 44 24 04 f7 29 80 	movl   $0x8029f7,0x4(%esp)
  8029e4:	00 
  8029e5:	89 04 24             	mov    %eax,(%esp)
  8029e8:	e8 66 e6 ff ff       	call   801053 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8029f5:	c9                   	leave  
  8029f6:	c3                   	ret    

008029f7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8029f7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8029f8:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8029fd:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8029ff:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  802a02:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  802a06:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  802a08:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  802a0c:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  802a0d:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  802a10:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  802a12:	58                   	pop    %eax
	popl %eax
  802a13:	58                   	pop    %eax
	popal
  802a14:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  802a15:	83 c4 04             	add    $0x4,%esp
	popfl
  802a18:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802a19:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  802a1a:	c3                   	ret    
  802a1b:	66 90                	xchg   %ax,%ax
  802a1d:	66 90                	xchg   %ax,%ax
  802a1f:	90                   	nop

00802a20 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a20:	55                   	push   %ebp
  802a21:	89 e5                	mov    %esp,%ebp
  802a23:	56                   	push   %esi
  802a24:	53                   	push   %ebx
  802a25:	83 ec 10             	sub    $0x10,%esp
  802a28:	8b 75 08             	mov    0x8(%ebp),%esi
  802a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802a31:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802a33:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802a38:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  802a3b:	89 04 24             	mov    %eax,(%esp)
  802a3e:	e8 86 e6 ff ff       	call   8010c9 <sys_ipc_recv>
  802a43:	85 c0                	test   %eax,%eax
  802a45:	74 16                	je     802a5d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802a47:	85 f6                	test   %esi,%esi
  802a49:	74 06                	je     802a51 <ipc_recv+0x31>
			*from_env_store = 0;
  802a4b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802a51:	85 db                	test   %ebx,%ebx
  802a53:	74 2c                	je     802a81 <ipc_recv+0x61>
			*perm_store = 0;
  802a55:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802a5b:	eb 24                	jmp    802a81 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  802a5d:	85 f6                	test   %esi,%esi
  802a5f:	74 0a                	je     802a6b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802a61:	a1 08 50 80 00       	mov    0x805008,%eax
  802a66:	8b 40 74             	mov    0x74(%eax),%eax
  802a69:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  802a6b:	85 db                	test   %ebx,%ebx
  802a6d:	74 0a                	je     802a79 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  802a6f:	a1 08 50 80 00       	mov    0x805008,%eax
  802a74:	8b 40 78             	mov    0x78(%eax),%eax
  802a77:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802a79:	a1 08 50 80 00       	mov    0x805008,%eax
  802a7e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802a81:	83 c4 10             	add    $0x10,%esp
  802a84:	5b                   	pop    %ebx
  802a85:	5e                   	pop    %esi
  802a86:	5d                   	pop    %ebp
  802a87:	c3                   	ret    

00802a88 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a88:	55                   	push   %ebp
  802a89:	89 e5                	mov    %esp,%ebp
  802a8b:	57                   	push   %edi
  802a8c:	56                   	push   %esi
  802a8d:	53                   	push   %ebx
  802a8e:	83 ec 1c             	sub    $0x1c,%esp
  802a91:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a94:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802a97:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  802a9a:	85 db                	test   %ebx,%ebx
  802a9c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802aa1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802aa4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802aa8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802aac:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab3:	89 04 24             	mov    %eax,(%esp)
  802ab6:	e8 eb e5 ff ff       	call   8010a6 <sys_ipc_try_send>
	if (r == 0) return;
  802abb:	85 c0                	test   %eax,%eax
  802abd:	75 22                	jne    802ae1 <ipc_send+0x59>
  802abf:	eb 4c                	jmp    802b0d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802ac1:	84 d2                	test   %dl,%dl
  802ac3:	75 48                	jne    802b0d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802ac5:	e8 ca e3 ff ff       	call   800e94 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  802aca:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ace:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ad2:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad9:	89 04 24             	mov    %eax,(%esp)
  802adc:	e8 c5 e5 ff ff       	call   8010a6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	0f 94 c2             	sete   %dl
  802ae6:	74 d9                	je     802ac1 <ipc_send+0x39>
  802ae8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802aeb:	74 d4                	je     802ac1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  802aed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802af1:	c7 44 24 08 5b 35 80 	movl   $0x80355b,0x8(%esp)
  802af8:	00 
  802af9:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802b00:	00 
  802b01:	c7 04 24 69 35 80 00 	movl   $0x803569,(%esp)
  802b08:	e8 69 d8 ff ff       	call   800376 <_panic>
}
  802b0d:	83 c4 1c             	add    $0x1c,%esp
  802b10:	5b                   	pop    %ebx
  802b11:	5e                   	pop    %esi
  802b12:	5f                   	pop    %edi
  802b13:	5d                   	pop    %ebp
  802b14:	c3                   	ret    

00802b15 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802b15:	55                   	push   %ebp
  802b16:	89 e5                	mov    %esp,%ebp
  802b18:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802b1b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802b20:	89 c2                	mov    %eax,%edx
  802b22:	c1 e2 07             	shl    $0x7,%edx
  802b25:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802b2b:	8b 52 50             	mov    0x50(%edx),%edx
  802b2e:	39 ca                	cmp    %ecx,%edx
  802b30:	75 0d                	jne    802b3f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802b32:	c1 e0 07             	shl    $0x7,%eax
  802b35:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802b3a:	8b 40 40             	mov    0x40(%eax),%eax
  802b3d:	eb 0e                	jmp    802b4d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802b3f:	83 c0 01             	add    $0x1,%eax
  802b42:	3d 00 04 00 00       	cmp    $0x400,%eax
  802b47:	75 d7                	jne    802b20 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802b49:	66 b8 00 00          	mov    $0x0,%ax
}
  802b4d:	5d                   	pop    %ebp
  802b4e:	c3                   	ret    

00802b4f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b4f:	55                   	push   %ebp
  802b50:	89 e5                	mov    %esp,%ebp
  802b52:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b55:	89 d0                	mov    %edx,%eax
  802b57:	c1 e8 16             	shr    $0x16,%eax
  802b5a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802b61:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802b66:	f6 c1 01             	test   $0x1,%cl
  802b69:	74 1d                	je     802b88 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802b6b:	c1 ea 0c             	shr    $0xc,%edx
  802b6e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802b75:	f6 c2 01             	test   $0x1,%dl
  802b78:	74 0e                	je     802b88 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802b7a:	c1 ea 0c             	shr    $0xc,%edx
  802b7d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802b84:	ef 
  802b85:	0f b7 c0             	movzwl %ax,%eax
}
  802b88:	5d                   	pop    %ebp
  802b89:	c3                   	ret    
  802b8a:	66 90                	xchg   %ax,%ax
  802b8c:	66 90                	xchg   %ax,%ax
  802b8e:	66 90                	xchg   %ax,%ax

00802b90 <__udivdi3>:
  802b90:	55                   	push   %ebp
  802b91:	57                   	push   %edi
  802b92:	56                   	push   %esi
  802b93:	83 ec 0c             	sub    $0xc,%esp
  802b96:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b9a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802b9e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802ba2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802bac:	89 ea                	mov    %ebp,%edx
  802bae:	89 0c 24             	mov    %ecx,(%esp)
  802bb1:	75 2d                	jne    802be0 <__udivdi3+0x50>
  802bb3:	39 e9                	cmp    %ebp,%ecx
  802bb5:	77 61                	ja     802c18 <__udivdi3+0x88>
  802bb7:	85 c9                	test   %ecx,%ecx
  802bb9:	89 ce                	mov    %ecx,%esi
  802bbb:	75 0b                	jne    802bc8 <__udivdi3+0x38>
  802bbd:	b8 01 00 00 00       	mov    $0x1,%eax
  802bc2:	31 d2                	xor    %edx,%edx
  802bc4:	f7 f1                	div    %ecx
  802bc6:	89 c6                	mov    %eax,%esi
  802bc8:	31 d2                	xor    %edx,%edx
  802bca:	89 e8                	mov    %ebp,%eax
  802bcc:	f7 f6                	div    %esi
  802bce:	89 c5                	mov    %eax,%ebp
  802bd0:	89 f8                	mov    %edi,%eax
  802bd2:	f7 f6                	div    %esi
  802bd4:	89 ea                	mov    %ebp,%edx
  802bd6:	83 c4 0c             	add    $0xc,%esp
  802bd9:	5e                   	pop    %esi
  802bda:	5f                   	pop    %edi
  802bdb:	5d                   	pop    %ebp
  802bdc:	c3                   	ret    
  802bdd:	8d 76 00             	lea    0x0(%esi),%esi
  802be0:	39 e8                	cmp    %ebp,%eax
  802be2:	77 24                	ja     802c08 <__udivdi3+0x78>
  802be4:	0f bd e8             	bsr    %eax,%ebp
  802be7:	83 f5 1f             	xor    $0x1f,%ebp
  802bea:	75 3c                	jne    802c28 <__udivdi3+0x98>
  802bec:	8b 74 24 04          	mov    0x4(%esp),%esi
  802bf0:	39 34 24             	cmp    %esi,(%esp)
  802bf3:	0f 86 9f 00 00 00    	jbe    802c98 <__udivdi3+0x108>
  802bf9:	39 d0                	cmp    %edx,%eax
  802bfb:	0f 82 97 00 00 00    	jb     802c98 <__udivdi3+0x108>
  802c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c08:	31 d2                	xor    %edx,%edx
  802c0a:	31 c0                	xor    %eax,%eax
  802c0c:	83 c4 0c             	add    $0xc,%esp
  802c0f:	5e                   	pop    %esi
  802c10:	5f                   	pop    %edi
  802c11:	5d                   	pop    %ebp
  802c12:	c3                   	ret    
  802c13:	90                   	nop
  802c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c18:	89 f8                	mov    %edi,%eax
  802c1a:	f7 f1                	div    %ecx
  802c1c:	31 d2                	xor    %edx,%edx
  802c1e:	83 c4 0c             	add    $0xc,%esp
  802c21:	5e                   	pop    %esi
  802c22:	5f                   	pop    %edi
  802c23:	5d                   	pop    %ebp
  802c24:	c3                   	ret    
  802c25:	8d 76 00             	lea    0x0(%esi),%esi
  802c28:	89 e9                	mov    %ebp,%ecx
  802c2a:	8b 3c 24             	mov    (%esp),%edi
  802c2d:	d3 e0                	shl    %cl,%eax
  802c2f:	89 c6                	mov    %eax,%esi
  802c31:	b8 20 00 00 00       	mov    $0x20,%eax
  802c36:	29 e8                	sub    %ebp,%eax
  802c38:	89 c1                	mov    %eax,%ecx
  802c3a:	d3 ef                	shr    %cl,%edi
  802c3c:	89 e9                	mov    %ebp,%ecx
  802c3e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c42:	8b 3c 24             	mov    (%esp),%edi
  802c45:	09 74 24 08          	or     %esi,0x8(%esp)
  802c49:	89 d6                	mov    %edx,%esi
  802c4b:	d3 e7                	shl    %cl,%edi
  802c4d:	89 c1                	mov    %eax,%ecx
  802c4f:	89 3c 24             	mov    %edi,(%esp)
  802c52:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c56:	d3 ee                	shr    %cl,%esi
  802c58:	89 e9                	mov    %ebp,%ecx
  802c5a:	d3 e2                	shl    %cl,%edx
  802c5c:	89 c1                	mov    %eax,%ecx
  802c5e:	d3 ef                	shr    %cl,%edi
  802c60:	09 d7                	or     %edx,%edi
  802c62:	89 f2                	mov    %esi,%edx
  802c64:	89 f8                	mov    %edi,%eax
  802c66:	f7 74 24 08          	divl   0x8(%esp)
  802c6a:	89 d6                	mov    %edx,%esi
  802c6c:	89 c7                	mov    %eax,%edi
  802c6e:	f7 24 24             	mull   (%esp)
  802c71:	39 d6                	cmp    %edx,%esi
  802c73:	89 14 24             	mov    %edx,(%esp)
  802c76:	72 30                	jb     802ca8 <__udivdi3+0x118>
  802c78:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c7c:	89 e9                	mov    %ebp,%ecx
  802c7e:	d3 e2                	shl    %cl,%edx
  802c80:	39 c2                	cmp    %eax,%edx
  802c82:	73 05                	jae    802c89 <__udivdi3+0xf9>
  802c84:	3b 34 24             	cmp    (%esp),%esi
  802c87:	74 1f                	je     802ca8 <__udivdi3+0x118>
  802c89:	89 f8                	mov    %edi,%eax
  802c8b:	31 d2                	xor    %edx,%edx
  802c8d:	e9 7a ff ff ff       	jmp    802c0c <__udivdi3+0x7c>
  802c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c98:	31 d2                	xor    %edx,%edx
  802c9a:	b8 01 00 00 00       	mov    $0x1,%eax
  802c9f:	e9 68 ff ff ff       	jmp    802c0c <__udivdi3+0x7c>
  802ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ca8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802cab:	31 d2                	xor    %edx,%edx
  802cad:	83 c4 0c             	add    $0xc,%esp
  802cb0:	5e                   	pop    %esi
  802cb1:	5f                   	pop    %edi
  802cb2:	5d                   	pop    %ebp
  802cb3:	c3                   	ret    
  802cb4:	66 90                	xchg   %ax,%ax
  802cb6:	66 90                	xchg   %ax,%ax
  802cb8:	66 90                	xchg   %ax,%ax
  802cba:	66 90                	xchg   %ax,%ax
  802cbc:	66 90                	xchg   %ax,%ax
  802cbe:	66 90                	xchg   %ax,%ax

00802cc0 <__umoddi3>:
  802cc0:	55                   	push   %ebp
  802cc1:	57                   	push   %edi
  802cc2:	56                   	push   %esi
  802cc3:	83 ec 14             	sub    $0x14,%esp
  802cc6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802cca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802cce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802cd2:	89 c7                	mov    %eax,%edi
  802cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cd8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802cdc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802ce0:	89 34 24             	mov    %esi,(%esp)
  802ce3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802ce7:	85 c0                	test   %eax,%eax
  802ce9:	89 c2                	mov    %eax,%edx
  802ceb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cef:	75 17                	jne    802d08 <__umoddi3+0x48>
  802cf1:	39 fe                	cmp    %edi,%esi
  802cf3:	76 4b                	jbe    802d40 <__umoddi3+0x80>
  802cf5:	89 c8                	mov    %ecx,%eax
  802cf7:	89 fa                	mov    %edi,%edx
  802cf9:	f7 f6                	div    %esi
  802cfb:	89 d0                	mov    %edx,%eax
  802cfd:	31 d2                	xor    %edx,%edx
  802cff:	83 c4 14             	add    $0x14,%esp
  802d02:	5e                   	pop    %esi
  802d03:	5f                   	pop    %edi
  802d04:	5d                   	pop    %ebp
  802d05:	c3                   	ret    
  802d06:	66 90                	xchg   %ax,%ax
  802d08:	39 f8                	cmp    %edi,%eax
  802d0a:	77 54                	ja     802d60 <__umoddi3+0xa0>
  802d0c:	0f bd e8             	bsr    %eax,%ebp
  802d0f:	83 f5 1f             	xor    $0x1f,%ebp
  802d12:	75 5c                	jne    802d70 <__umoddi3+0xb0>
  802d14:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802d18:	39 3c 24             	cmp    %edi,(%esp)
  802d1b:	0f 87 e7 00 00 00    	ja     802e08 <__umoddi3+0x148>
  802d21:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d25:	29 f1                	sub    %esi,%ecx
  802d27:	19 c7                	sbb    %eax,%edi
  802d29:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d2d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d31:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d35:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802d39:	83 c4 14             	add    $0x14,%esp
  802d3c:	5e                   	pop    %esi
  802d3d:	5f                   	pop    %edi
  802d3e:	5d                   	pop    %ebp
  802d3f:	c3                   	ret    
  802d40:	85 f6                	test   %esi,%esi
  802d42:	89 f5                	mov    %esi,%ebp
  802d44:	75 0b                	jne    802d51 <__umoddi3+0x91>
  802d46:	b8 01 00 00 00       	mov    $0x1,%eax
  802d4b:	31 d2                	xor    %edx,%edx
  802d4d:	f7 f6                	div    %esi
  802d4f:	89 c5                	mov    %eax,%ebp
  802d51:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d55:	31 d2                	xor    %edx,%edx
  802d57:	f7 f5                	div    %ebp
  802d59:	89 c8                	mov    %ecx,%eax
  802d5b:	f7 f5                	div    %ebp
  802d5d:	eb 9c                	jmp    802cfb <__umoddi3+0x3b>
  802d5f:	90                   	nop
  802d60:	89 c8                	mov    %ecx,%eax
  802d62:	89 fa                	mov    %edi,%edx
  802d64:	83 c4 14             	add    $0x14,%esp
  802d67:	5e                   	pop    %esi
  802d68:	5f                   	pop    %edi
  802d69:	5d                   	pop    %ebp
  802d6a:	c3                   	ret    
  802d6b:	90                   	nop
  802d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d70:	8b 04 24             	mov    (%esp),%eax
  802d73:	be 20 00 00 00       	mov    $0x20,%esi
  802d78:	89 e9                	mov    %ebp,%ecx
  802d7a:	29 ee                	sub    %ebp,%esi
  802d7c:	d3 e2                	shl    %cl,%edx
  802d7e:	89 f1                	mov    %esi,%ecx
  802d80:	d3 e8                	shr    %cl,%eax
  802d82:	89 e9                	mov    %ebp,%ecx
  802d84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d88:	8b 04 24             	mov    (%esp),%eax
  802d8b:	09 54 24 04          	or     %edx,0x4(%esp)
  802d8f:	89 fa                	mov    %edi,%edx
  802d91:	d3 e0                	shl    %cl,%eax
  802d93:	89 f1                	mov    %esi,%ecx
  802d95:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d99:	8b 44 24 10          	mov    0x10(%esp),%eax
  802d9d:	d3 ea                	shr    %cl,%edx
  802d9f:	89 e9                	mov    %ebp,%ecx
  802da1:	d3 e7                	shl    %cl,%edi
  802da3:	89 f1                	mov    %esi,%ecx
  802da5:	d3 e8                	shr    %cl,%eax
  802da7:	89 e9                	mov    %ebp,%ecx
  802da9:	09 f8                	or     %edi,%eax
  802dab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802daf:	f7 74 24 04          	divl   0x4(%esp)
  802db3:	d3 e7                	shl    %cl,%edi
  802db5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802db9:	89 d7                	mov    %edx,%edi
  802dbb:	f7 64 24 08          	mull   0x8(%esp)
  802dbf:	39 d7                	cmp    %edx,%edi
  802dc1:	89 c1                	mov    %eax,%ecx
  802dc3:	89 14 24             	mov    %edx,(%esp)
  802dc6:	72 2c                	jb     802df4 <__umoddi3+0x134>
  802dc8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802dcc:	72 22                	jb     802df0 <__umoddi3+0x130>
  802dce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802dd2:	29 c8                	sub    %ecx,%eax
  802dd4:	19 d7                	sbb    %edx,%edi
  802dd6:	89 e9                	mov    %ebp,%ecx
  802dd8:	89 fa                	mov    %edi,%edx
  802dda:	d3 e8                	shr    %cl,%eax
  802ddc:	89 f1                	mov    %esi,%ecx
  802dde:	d3 e2                	shl    %cl,%edx
  802de0:	89 e9                	mov    %ebp,%ecx
  802de2:	d3 ef                	shr    %cl,%edi
  802de4:	09 d0                	or     %edx,%eax
  802de6:	89 fa                	mov    %edi,%edx
  802de8:	83 c4 14             	add    $0x14,%esp
  802deb:	5e                   	pop    %esi
  802dec:	5f                   	pop    %edi
  802ded:	5d                   	pop    %ebp
  802dee:	c3                   	ret    
  802def:	90                   	nop
  802df0:	39 d7                	cmp    %edx,%edi
  802df2:	75 da                	jne    802dce <__umoddi3+0x10e>
  802df4:	8b 14 24             	mov    (%esp),%edx
  802df7:	89 c1                	mov    %eax,%ecx
  802df9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802dfd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802e01:	eb cb                	jmp    802dce <__umoddi3+0x10e>
  802e03:	90                   	nop
  802e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e08:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802e0c:	0f 82 0f ff ff ff    	jb     802d21 <__umoddi3+0x61>
  802e12:	e9 1a ff ff ff       	jmp    802d31 <__umoddi3+0x71>
