
obj/user/dumbfork.debug:     file format elf32-i386


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
  80002c:	e8 1d 02 00 00       	call   80024e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 20             	sub    $0x20,%esp
  800048:	8b 75 08             	mov    0x8(%ebp),%esi
  80004b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  80004e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800055:	00 
  800056:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80005a:	89 34 24             	mov    %esi,(%esp)
  80005d:	e8 91 0d 00 00       	call   800df3 <sys_page_alloc>
  800062:	85 c0                	test   %eax,%eax
  800064:	79 20                	jns    800086 <duppage+0x46>
		panic("sys_page_alloc: %e", r);
  800066:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80006a:	c7 44 24 08 60 28 80 	movl   $0x802860,0x8(%esp)
  800071:	00 
  800072:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  800079:	00 
  80007a:	c7 04 24 73 28 80 00 	movl   $0x802873,(%esp)
  800081:	e8 29 02 00 00       	call   8002af <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  800086:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80008d:	00 
  80008e:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  800095:	00 
  800096:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80009d:	00 
  80009e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000a2:	89 34 24             	mov    %esi,(%esp)
  8000a5:	e8 9d 0d 00 00       	call   800e47 <sys_page_map>
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	79 20                	jns    8000ce <duppage+0x8e>
		panic("sys_page_map: %e", r);
  8000ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b2:	c7 44 24 08 83 28 80 	movl   $0x802883,0x8(%esp)
  8000b9:	00 
  8000ba:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8000c1:	00 
  8000c2:	c7 04 24 73 28 80 00 	movl   $0x802873,(%esp)
  8000c9:	e8 e1 01 00 00       	call   8002af <_panic>
	memmove(UTEMP, addr, PGSIZE);
  8000ce:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8000d5:	00 
  8000d6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000da:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8000e1:	e8 8e 0a 00 00       	call   800b74 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8000e6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8000ed:	00 
  8000ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000f5:	e8 a0 0d 00 00       	call   800e9a <sys_page_unmap>
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	79 20                	jns    80011e <duppage+0xde>
		panic("sys_page_unmap: %e", r);
  8000fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800102:	c7 44 24 08 94 28 80 	movl   $0x802894,0x8(%esp)
  800109:	00 
  80010a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800111:	00 
  800112:	c7 04 24 73 28 80 00 	movl   $0x802873,(%esp)
  800119:	e8 91 01 00 00       	call   8002af <_panic>
}
  80011e:	83 c4 20             	add    $0x20,%esp
  800121:	5b                   	pop    %ebx
  800122:	5e                   	pop    %esi
  800123:	5d                   	pop    %ebp
  800124:	c3                   	ret    

00800125 <dumbfork>:

envid_t
dumbfork(void)
{
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
  80012a:	83 ec 20             	sub    $0x20,%esp
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80012d:	b8 07 00 00 00       	mov    $0x7,%eax
  800132:	cd 30                	int    $0x30
  800134:	89 c6                	mov    %eax,%esi
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  800136:	85 c0                	test   %eax,%eax
  800138:	79 20                	jns    80015a <dumbfork+0x35>
		panic("sys_exofork: %e", envid);
  80013a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013e:	c7 44 24 08 a7 28 80 	movl   $0x8028a7,0x8(%esp)
  800145:	00 
  800146:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80014d:	00 
  80014e:	c7 04 24 73 28 80 00 	movl   $0x802873,(%esp)
  800155:	e8 55 01 00 00       	call   8002af <_panic>
  80015a:	89 c3                	mov    %eax,%ebx
	if (envid == 0) {
  80015c:	85 c0                	test   %eax,%eax
  80015e:	75 1e                	jne    80017e <dumbfork+0x59>
		// We're the child.
		// The copied value of the global variable 'thisenv'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		thisenv = &envs[ENVX(sys_getenvid())];
  800160:	e8 50 0c 00 00       	call   800db5 <sys_getenvid>
  800165:	25 ff 03 00 00       	and    $0x3ff,%eax
  80016a:	c1 e0 07             	shl    $0x7,%eax
  80016d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800172:	a3 08 40 80 00       	mov    %eax,0x804008
		return 0;
  800177:	b8 00 00 00 00       	mov    $0x0,%eax
  80017c:	eb 71                	jmp    8001ef <dumbfork+0xca>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80017e:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  800185:	eb 13                	jmp    80019a <dumbfork+0x75>
		duppage(envid, addr);
  800187:	89 54 24 04          	mov    %edx,0x4(%esp)
  80018b:	89 1c 24             	mov    %ebx,(%esp)
  80018e:	e8 ad fe ff ff       	call   800040 <duppage>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  800193:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  80019a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80019d:	81 fa 00 70 80 00    	cmp    $0x807000,%edx
  8001a3:	72 e2                	jb     800187 <dumbfork+0x62>
		duppage(envid, addr);

	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  8001a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b1:	89 34 24             	mov    %esi,(%esp)
  8001b4:	e8 87 fe ff ff       	call   800040 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8001b9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8001c0:	00 
  8001c1:	89 34 24             	mov    %esi,(%esp)
  8001c4:	e8 24 0d 00 00       	call   800eed <sys_env_set_status>
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	79 20                	jns    8001ed <dumbfork+0xc8>
		panic("sys_env_set_status: %e", r);
  8001cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d1:	c7 44 24 08 b7 28 80 	movl   $0x8028b7,0x8(%esp)
  8001d8:	00 
  8001d9:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  8001e0:	00 
  8001e1:	c7 04 24 73 28 80 00 	movl   $0x802873,(%esp)
  8001e8:	e8 c2 00 00 00       	call   8002af <_panic>

	return envid;
  8001ed:	89 f0                	mov    %esi,%eax
}
  8001ef:	83 c4 20             	add    $0x20,%esp
  8001f2:	5b                   	pop    %ebx
  8001f3:	5e                   	pop    %esi
  8001f4:	5d                   	pop    %ebp
  8001f5:	c3                   	ret    

008001f6 <umain>:

envid_t dumbfork(void);

void
umain(int argc, char **argv)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	56                   	push   %esi
  8001fa:	53                   	push   %ebx
  8001fb:	83 ec 10             	sub    $0x10,%esp
	envid_t who;
	int i;

	// fork a child process
	who = dumbfork();
  8001fe:	e8 22 ff ff ff       	call   800125 <dumbfork>
  800203:	89 c6                	mov    %eax,%esi

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800205:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020a:	eb 28                	jmp    800234 <umain+0x3e>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  80020c:	b8 d5 28 80 00       	mov    $0x8028d5,%eax
  800211:	eb 05                	jmp    800218 <umain+0x22>
  800213:	b8 ce 28 80 00       	mov    $0x8028ce,%eax
  800218:	89 44 24 08          	mov    %eax,0x8(%esp)
  80021c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800220:	c7 04 24 db 28 80 00 	movl   $0x8028db,(%esp)
  800227:	e8 7c 01 00 00       	call   8003a8 <cprintf>
		sys_yield();
  80022c:	e8 a3 0b 00 00       	call   800dd4 <sys_yield>

	// fork a child process
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800231:	83 c3 01             	add    $0x1,%ebx
  800234:	85 f6                	test   %esi,%esi
  800236:	75 0a                	jne    800242 <umain+0x4c>
  800238:	83 fb 13             	cmp    $0x13,%ebx
  80023b:	7e cf                	jle    80020c <umain+0x16>
  80023d:	8d 76 00             	lea    0x0(%esi),%esi
  800240:	eb 05                	jmp    800247 <umain+0x51>
  800242:	83 fb 09             	cmp    $0x9,%ebx
  800245:	7e cc                	jle    800213 <umain+0x1d>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
		sys_yield();
	}
}
  800247:	83 c4 10             	add    $0x10,%esp
  80024a:	5b                   	pop    %ebx
  80024b:	5e                   	pop    %esi
  80024c:	5d                   	pop    %ebp
  80024d:	c3                   	ret    

0080024e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	56                   	push   %esi
  800252:	53                   	push   %ebx
  800253:	83 ec 10             	sub    $0x10,%esp
  800256:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800259:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80025c:	e8 54 0b 00 00       	call   800db5 <sys_getenvid>
  800261:	25 ff 03 00 00       	and    $0x3ff,%eax
  800266:	c1 e0 07             	shl    $0x7,%eax
  800269:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80026e:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800273:	85 db                	test   %ebx,%ebx
  800275:	7e 07                	jle    80027e <libmain+0x30>
		binaryname = argv[0];
  800277:	8b 06                	mov    (%esi),%eax
  800279:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80027e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800282:	89 1c 24             	mov    %ebx,(%esp)
  800285:	e8 6c ff ff ff       	call   8001f6 <umain>

	// exit gracefully
	exit();
  80028a:	e8 07 00 00 00       	call   800296 <exit>
}
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	5b                   	pop    %ebx
  800293:	5e                   	pop    %esi
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    

00800296 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80029c:	e8 79 10 00 00       	call   80131a <close_all>
	sys_env_destroy(0);
  8002a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002a8:	e8 b6 0a 00 00       	call   800d63 <sys_env_destroy>
}
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	56                   	push   %esi
  8002b3:	53                   	push   %ebx
  8002b4:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8002b7:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8002ba:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8002c0:	e8 f0 0a 00 00       	call   800db5 <sys_getenvid>
  8002c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c8:	89 54 24 10          	mov    %edx,0x10(%esp)
  8002cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cf:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002d3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002db:	c7 04 24 f8 28 80 00 	movl   $0x8028f8,(%esp)
  8002e2:	e8 c1 00 00 00       	call   8003a8 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002e7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ee:	89 04 24             	mov    %eax,(%esp)
  8002f1:	e8 51 00 00 00       	call   800347 <vcprintf>
	cprintf("\n");
  8002f6:	c7 04 24 eb 28 80 00 	movl   $0x8028eb,(%esp)
  8002fd:	e8 a6 00 00 00       	call   8003a8 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800302:	cc                   	int3   
  800303:	eb fd                	jmp    800302 <_panic+0x53>

00800305 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800305:	55                   	push   %ebp
  800306:	89 e5                	mov    %esp,%ebp
  800308:	53                   	push   %ebx
  800309:	83 ec 14             	sub    $0x14,%esp
  80030c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80030f:	8b 13                	mov    (%ebx),%edx
  800311:	8d 42 01             	lea    0x1(%edx),%eax
  800314:	89 03                	mov    %eax,(%ebx)
  800316:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800319:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80031d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800322:	75 19                	jne    80033d <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800324:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80032b:	00 
  80032c:	8d 43 08             	lea    0x8(%ebx),%eax
  80032f:	89 04 24             	mov    %eax,(%esp)
  800332:	e8 ef 09 00 00       	call   800d26 <sys_cputs>
		b->idx = 0;
  800337:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80033d:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800341:	83 c4 14             	add    $0x14,%esp
  800344:	5b                   	pop    %ebx
  800345:	5d                   	pop    %ebp
  800346:	c3                   	ret    

00800347 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800347:	55                   	push   %ebp
  800348:	89 e5                	mov    %esp,%ebp
  80034a:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800350:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800357:	00 00 00 
	b.cnt = 0;
  80035a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800361:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800364:	8b 45 0c             	mov    0xc(%ebp),%eax
  800367:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800372:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800378:	89 44 24 04          	mov    %eax,0x4(%esp)
  80037c:	c7 04 24 05 03 80 00 	movl   $0x800305,(%esp)
  800383:	e8 b6 01 00 00       	call   80053e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800388:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80038e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800392:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800398:	89 04 24             	mov    %eax,(%esp)
  80039b:	e8 86 09 00 00       	call   800d26 <sys_cputs>

	return b.cnt;
}
  8003a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003ae:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8003b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b8:	89 04 24             	mov    %eax,(%esp)
  8003bb:	e8 87 ff ff ff       	call   800347 <vcprintf>
	va_end(ap);

	return cnt;
}
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    
  8003c2:	66 90                	xchg   %ax,%ax
  8003c4:	66 90                	xchg   %ax,%ax
  8003c6:	66 90                	xchg   %ax,%ax
  8003c8:	66 90                	xchg   %ax,%ax
  8003ca:	66 90                	xchg   %ax,%ax
  8003cc:	66 90                	xchg   %ax,%ax
  8003ce:	66 90                	xchg   %ax,%ax

008003d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	57                   	push   %edi
  8003d4:	56                   	push   %esi
  8003d5:	53                   	push   %ebx
  8003d6:	83 ec 3c             	sub    $0x3c,%esp
  8003d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003dc:	89 d7                	mov    %edx,%edi
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e7:	89 c3                	mov    %eax,%ebx
  8003e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ef:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003fa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003fd:	39 d9                	cmp    %ebx,%ecx
  8003ff:	72 05                	jb     800406 <printnum+0x36>
  800401:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800404:	77 69                	ja     80046f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800406:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800409:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80040d:	83 ee 01             	sub    $0x1,%esi
  800410:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800414:	89 44 24 08          	mov    %eax,0x8(%esp)
  800418:	8b 44 24 08          	mov    0x8(%esp),%eax
  80041c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800420:	89 c3                	mov    %eax,%ebx
  800422:	89 d6                	mov    %edx,%esi
  800424:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800427:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80042a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80042e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800432:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800435:	89 04 24             	mov    %eax,(%esp)
  800438:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80043f:	e8 8c 21 00 00       	call   8025d0 <__udivdi3>
  800444:	89 d9                	mov    %ebx,%ecx
  800446:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80044a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80044e:	89 04 24             	mov    %eax,(%esp)
  800451:	89 54 24 04          	mov    %edx,0x4(%esp)
  800455:	89 fa                	mov    %edi,%edx
  800457:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80045a:	e8 71 ff ff ff       	call   8003d0 <printnum>
  80045f:	eb 1b                	jmp    80047c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800461:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800465:	8b 45 18             	mov    0x18(%ebp),%eax
  800468:	89 04 24             	mov    %eax,(%esp)
  80046b:	ff d3                	call   *%ebx
  80046d:	eb 03                	jmp    800472 <printnum+0xa2>
  80046f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800472:	83 ee 01             	sub    $0x1,%esi
  800475:	85 f6                	test   %esi,%esi
  800477:	7f e8                	jg     800461 <printnum+0x91>
  800479:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80047c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800480:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800484:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800487:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80048a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80048e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800492:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800495:	89 04 24             	mov    %eax,(%esp)
  800498:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80049b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049f:	e8 5c 22 00 00       	call   802700 <__umoddi3>
  8004a4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004a8:	0f be 80 1b 29 80 00 	movsbl 0x80291b(%eax),%eax
  8004af:	89 04 24             	mov    %eax,(%esp)
  8004b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004b5:	ff d0                	call   *%eax
}
  8004b7:	83 c4 3c             	add    $0x3c,%esp
  8004ba:	5b                   	pop    %ebx
  8004bb:	5e                   	pop    %esi
  8004bc:	5f                   	pop    %edi
  8004bd:	5d                   	pop    %ebp
  8004be:	c3                   	ret    

008004bf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004bf:	55                   	push   %ebp
  8004c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004c2:	83 fa 01             	cmp    $0x1,%edx
  8004c5:	7e 0e                	jle    8004d5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8004c7:	8b 10                	mov    (%eax),%edx
  8004c9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8004cc:	89 08                	mov    %ecx,(%eax)
  8004ce:	8b 02                	mov    (%edx),%eax
  8004d0:	8b 52 04             	mov    0x4(%edx),%edx
  8004d3:	eb 22                	jmp    8004f7 <getuint+0x38>
	else if (lflag)
  8004d5:	85 d2                	test   %edx,%edx
  8004d7:	74 10                	je     8004e9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004d9:	8b 10                	mov    (%eax),%edx
  8004db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004de:	89 08                	mov    %ecx,(%eax)
  8004e0:	8b 02                	mov    (%edx),%eax
  8004e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004e7:	eb 0e                	jmp    8004f7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004e9:	8b 10                	mov    (%eax),%edx
  8004eb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004ee:	89 08                	mov    %ecx,(%eax)
  8004f0:	8b 02                	mov    (%edx),%eax
  8004f2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f7:	5d                   	pop    %ebp
  8004f8:	c3                   	ret    

008004f9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004f9:	55                   	push   %ebp
  8004fa:	89 e5                	mov    %esp,%ebp
  8004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004ff:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800503:	8b 10                	mov    (%eax),%edx
  800505:	3b 50 04             	cmp    0x4(%eax),%edx
  800508:	73 0a                	jae    800514 <sprintputch+0x1b>
		*b->buf++ = ch;
  80050a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80050d:	89 08                	mov    %ecx,(%eax)
  80050f:	8b 45 08             	mov    0x8(%ebp),%eax
  800512:	88 02                	mov    %al,(%edx)
}
  800514:	5d                   	pop    %ebp
  800515:	c3                   	ret    

00800516 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800516:	55                   	push   %ebp
  800517:	89 e5                	mov    %esp,%ebp
  800519:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80051c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80051f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800523:	8b 45 10             	mov    0x10(%ebp),%eax
  800526:	89 44 24 08          	mov    %eax,0x8(%esp)
  80052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800531:	8b 45 08             	mov    0x8(%ebp),%eax
  800534:	89 04 24             	mov    %eax,(%esp)
  800537:	e8 02 00 00 00       	call   80053e <vprintfmt>
	va_end(ap);
}
  80053c:	c9                   	leave  
  80053d:	c3                   	ret    

0080053e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80053e:	55                   	push   %ebp
  80053f:	89 e5                	mov    %esp,%ebp
  800541:	57                   	push   %edi
  800542:	56                   	push   %esi
  800543:	53                   	push   %ebx
  800544:	83 ec 3c             	sub    $0x3c,%esp
  800547:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80054a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80054d:	eb 14                	jmp    800563 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80054f:	85 c0                	test   %eax,%eax
  800551:	0f 84 b3 03 00 00    	je     80090a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800557:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80055b:	89 04 24             	mov    %eax,(%esp)
  80055e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800561:	89 f3                	mov    %esi,%ebx
  800563:	8d 73 01             	lea    0x1(%ebx),%esi
  800566:	0f b6 03             	movzbl (%ebx),%eax
  800569:	83 f8 25             	cmp    $0x25,%eax
  80056c:	75 e1                	jne    80054f <vprintfmt+0x11>
  80056e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800572:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800579:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800580:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800587:	ba 00 00 00 00       	mov    $0x0,%edx
  80058c:	eb 1d                	jmp    8005ab <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80058e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800590:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800594:	eb 15                	jmp    8005ab <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800596:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800598:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80059c:	eb 0d                	jmp    8005ab <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80059e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005a4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ab:	8d 5e 01             	lea    0x1(%esi),%ebx
  8005ae:	0f b6 0e             	movzbl (%esi),%ecx
  8005b1:	0f b6 c1             	movzbl %cl,%eax
  8005b4:	83 e9 23             	sub    $0x23,%ecx
  8005b7:	80 f9 55             	cmp    $0x55,%cl
  8005ba:	0f 87 2a 03 00 00    	ja     8008ea <vprintfmt+0x3ac>
  8005c0:	0f b6 c9             	movzbl %cl,%ecx
  8005c3:	ff 24 8d 60 2a 80 00 	jmp    *0x802a60(,%ecx,4)
  8005ca:	89 de                	mov    %ebx,%esi
  8005cc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005d1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8005d4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8005d8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8005db:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8005de:	83 fb 09             	cmp    $0x9,%ebx
  8005e1:	77 36                	ja     800619 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005e3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005e6:	eb e9                	jmp    8005d1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	8d 48 04             	lea    0x4(%eax),%ecx
  8005ee:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005f1:	8b 00                	mov    (%eax),%eax
  8005f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005f6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005f8:	eb 22                	jmp    80061c <vprintfmt+0xde>
  8005fa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005fd:	85 c9                	test   %ecx,%ecx
  8005ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800604:	0f 49 c1             	cmovns %ecx,%eax
  800607:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80060a:	89 de                	mov    %ebx,%esi
  80060c:	eb 9d                	jmp    8005ab <vprintfmt+0x6d>
  80060e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800610:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800617:	eb 92                	jmp    8005ab <vprintfmt+0x6d>
  800619:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80061c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800620:	79 89                	jns    8005ab <vprintfmt+0x6d>
  800622:	e9 77 ff ff ff       	jmp    80059e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800627:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80062a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80062c:	e9 7a ff ff ff       	jmp    8005ab <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8d 50 04             	lea    0x4(%eax),%edx
  800637:	89 55 14             	mov    %edx,0x14(%ebp)
  80063a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80063e:	8b 00                	mov    (%eax),%eax
  800640:	89 04 24             	mov    %eax,(%esp)
  800643:	ff 55 08             	call   *0x8(%ebp)
			break;
  800646:	e9 18 ff ff ff       	jmp    800563 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	8d 50 04             	lea    0x4(%eax),%edx
  800651:	89 55 14             	mov    %edx,0x14(%ebp)
  800654:	8b 00                	mov    (%eax),%eax
  800656:	99                   	cltd   
  800657:	31 d0                	xor    %edx,%eax
  800659:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80065b:	83 f8 11             	cmp    $0x11,%eax
  80065e:	7f 0b                	jg     80066b <vprintfmt+0x12d>
  800660:	8b 14 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%edx
  800667:	85 d2                	test   %edx,%edx
  800669:	75 20                	jne    80068b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80066b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80066f:	c7 44 24 08 33 29 80 	movl   $0x802933,0x8(%esp)
  800676:	00 
  800677:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	89 04 24             	mov    %eax,(%esp)
  800681:	e8 90 fe ff ff       	call   800516 <printfmt>
  800686:	e9 d8 fe ff ff       	jmp    800563 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80068b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80068f:	c7 44 24 08 01 2d 80 	movl   $0x802d01,0x8(%esp)
  800696:	00 
  800697:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 04 24             	mov    %eax,(%esp)
  8006a1:	e8 70 fe ff ff       	call   800516 <printfmt>
  8006a6:	e9 b8 fe ff ff       	jmp    800563 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006ab:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8006ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ba:	89 55 14             	mov    %edx,0x14(%ebp)
  8006bd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8006bf:	85 f6                	test   %esi,%esi
  8006c1:	b8 2c 29 80 00       	mov    $0x80292c,%eax
  8006c6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8006c9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8006cd:	0f 84 97 00 00 00    	je     80076a <vprintfmt+0x22c>
  8006d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006d7:	0f 8e 9b 00 00 00    	jle    800778 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006dd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006e1:	89 34 24             	mov    %esi,(%esp)
  8006e4:	e8 cf 02 00 00       	call   8009b8 <strnlen>
  8006e9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006ec:	29 c2                	sub    %eax,%edx
  8006ee:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8006f1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8006f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006f8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800701:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800703:	eb 0f                	jmp    800714 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800705:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800709:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80070c:	89 04 24             	mov    %eax,(%esp)
  80070f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800711:	83 eb 01             	sub    $0x1,%ebx
  800714:	85 db                	test   %ebx,%ebx
  800716:	7f ed                	jg     800705 <vprintfmt+0x1c7>
  800718:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80071b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80071e:	85 d2                	test   %edx,%edx
  800720:	b8 00 00 00 00       	mov    $0x0,%eax
  800725:	0f 49 c2             	cmovns %edx,%eax
  800728:	29 c2                	sub    %eax,%edx
  80072a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80072d:	89 d7                	mov    %edx,%edi
  80072f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800732:	eb 50                	jmp    800784 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800734:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800738:	74 1e                	je     800758 <vprintfmt+0x21a>
  80073a:	0f be d2             	movsbl %dl,%edx
  80073d:	83 ea 20             	sub    $0x20,%edx
  800740:	83 fa 5e             	cmp    $0x5e,%edx
  800743:	76 13                	jbe    800758 <vprintfmt+0x21a>
					putch('?', putdat);
  800745:	8b 45 0c             	mov    0xc(%ebp),%eax
  800748:	89 44 24 04          	mov    %eax,0x4(%esp)
  80074c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800753:	ff 55 08             	call   *0x8(%ebp)
  800756:	eb 0d                	jmp    800765 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800758:	8b 55 0c             	mov    0xc(%ebp),%edx
  80075b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80075f:	89 04 24             	mov    %eax,(%esp)
  800762:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800765:	83 ef 01             	sub    $0x1,%edi
  800768:	eb 1a                	jmp    800784 <vprintfmt+0x246>
  80076a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80076d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800770:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800773:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800776:	eb 0c                	jmp    800784 <vprintfmt+0x246>
  800778:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80077b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80077e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800781:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800784:	83 c6 01             	add    $0x1,%esi
  800787:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80078b:	0f be c2             	movsbl %dl,%eax
  80078e:	85 c0                	test   %eax,%eax
  800790:	74 27                	je     8007b9 <vprintfmt+0x27b>
  800792:	85 db                	test   %ebx,%ebx
  800794:	78 9e                	js     800734 <vprintfmt+0x1f6>
  800796:	83 eb 01             	sub    $0x1,%ebx
  800799:	79 99                	jns    800734 <vprintfmt+0x1f6>
  80079b:	89 f8                	mov    %edi,%eax
  80079d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8007a3:	89 c3                	mov    %eax,%ebx
  8007a5:	eb 1a                	jmp    8007c1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8007a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ab:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8007b2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007b4:	83 eb 01             	sub    $0x1,%ebx
  8007b7:	eb 08                	jmp    8007c1 <vprintfmt+0x283>
  8007b9:	89 fb                	mov    %edi,%ebx
  8007bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007be:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8007c1:	85 db                	test   %ebx,%ebx
  8007c3:	7f e2                	jg     8007a7 <vprintfmt+0x269>
  8007c5:	89 75 08             	mov    %esi,0x8(%ebp)
  8007c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007cb:	e9 93 fd ff ff       	jmp    800563 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007d0:	83 fa 01             	cmp    $0x1,%edx
  8007d3:	7e 16                	jle    8007eb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8007d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d8:	8d 50 08             	lea    0x8(%eax),%edx
  8007db:	89 55 14             	mov    %edx,0x14(%ebp)
  8007de:	8b 50 04             	mov    0x4(%eax),%edx
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007e9:	eb 32                	jmp    80081d <vprintfmt+0x2df>
	else if (lflag)
  8007eb:	85 d2                	test   %edx,%edx
  8007ed:	74 18                	je     800807 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8d 50 04             	lea    0x4(%eax),%edx
  8007f5:	89 55 14             	mov    %edx,0x14(%ebp)
  8007f8:	8b 30                	mov    (%eax),%esi
  8007fa:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007fd:	89 f0                	mov    %esi,%eax
  8007ff:	c1 f8 1f             	sar    $0x1f,%eax
  800802:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800805:	eb 16                	jmp    80081d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	8d 50 04             	lea    0x4(%eax),%edx
  80080d:	89 55 14             	mov    %edx,0x14(%ebp)
  800810:	8b 30                	mov    (%eax),%esi
  800812:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800815:	89 f0                	mov    %esi,%eax
  800817:	c1 f8 1f             	sar    $0x1f,%eax
  80081a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80081d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800820:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800823:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800828:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082c:	0f 89 80 00 00 00    	jns    8008b2 <vprintfmt+0x374>
				putch('-', putdat);
  800832:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800836:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80083d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800840:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800843:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800846:	f7 d8                	neg    %eax
  800848:	83 d2 00             	adc    $0x0,%edx
  80084b:	f7 da                	neg    %edx
			}
			base = 10;
  80084d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800852:	eb 5e                	jmp    8008b2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800854:	8d 45 14             	lea    0x14(%ebp),%eax
  800857:	e8 63 fc ff ff       	call   8004bf <getuint>
			base = 10;
  80085c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800861:	eb 4f                	jmp    8008b2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800863:	8d 45 14             	lea    0x14(%ebp),%eax
  800866:	e8 54 fc ff ff       	call   8004bf <getuint>
			base = 8;
  80086b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800870:	eb 40                	jmp    8008b2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800872:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800876:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80087d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800880:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800884:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80088b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	8d 50 04             	lea    0x4(%eax),%edx
  800894:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800897:	8b 00                	mov    (%eax),%eax
  800899:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80089e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8008a3:	eb 0d                	jmp    8008b2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008a5:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a8:	e8 12 fc ff ff       	call   8004bf <getuint>
			base = 16;
  8008ad:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8008b6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8008ba:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8008bd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8008c1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8008c5:	89 04 24             	mov    %eax,(%esp)
  8008c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008cc:	89 fa                	mov    %edi,%edx
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	e8 fa fa ff ff       	call   8003d0 <printnum>
			break;
  8008d6:	e9 88 fc ff ff       	jmp    800563 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008db:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008df:	89 04 24             	mov    %eax,(%esp)
  8008e2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008e5:	e9 79 fc ff ff       	jmp    800563 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008ee:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008f5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008f8:	89 f3                	mov    %esi,%ebx
  8008fa:	eb 03                	jmp    8008ff <vprintfmt+0x3c1>
  8008fc:	83 eb 01             	sub    $0x1,%ebx
  8008ff:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800903:	75 f7                	jne    8008fc <vprintfmt+0x3be>
  800905:	e9 59 fc ff ff       	jmp    800563 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80090a:	83 c4 3c             	add    $0x3c,%esp
  80090d:	5b                   	pop    %ebx
  80090e:	5e                   	pop    %esi
  80090f:	5f                   	pop    %edi
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	83 ec 28             	sub    $0x28,%esp
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80091e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800921:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800925:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800928:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80092f:	85 c0                	test   %eax,%eax
  800931:	74 30                	je     800963 <vsnprintf+0x51>
  800933:	85 d2                	test   %edx,%edx
  800935:	7e 2c                	jle    800963 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80093e:	8b 45 10             	mov    0x10(%ebp),%eax
  800941:	89 44 24 08          	mov    %eax,0x8(%esp)
  800945:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800948:	89 44 24 04          	mov    %eax,0x4(%esp)
  80094c:	c7 04 24 f9 04 80 00 	movl   $0x8004f9,(%esp)
  800953:	e8 e6 fb ff ff       	call   80053e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800958:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80095b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80095e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800961:	eb 05                	jmp    800968 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800963:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800968:	c9                   	leave  
  800969:	c3                   	ret    

0080096a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800970:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800973:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800977:	8b 45 10             	mov    0x10(%ebp),%eax
  80097a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80097e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800981:	89 44 24 04          	mov    %eax,0x4(%esp)
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	89 04 24             	mov    %eax,(%esp)
  80098b:	e8 82 ff ff ff       	call   800912 <vsnprintf>
	va_end(ap);

	return rc;
}
  800990:	c9                   	leave  
  800991:	c3                   	ret    
  800992:	66 90                	xchg   %ax,%ax
  800994:	66 90                	xchg   %ax,%ax
  800996:	66 90                	xchg   %ax,%ax
  800998:	66 90                	xchg   %ax,%ax
  80099a:	66 90                	xchg   %ax,%ax
  80099c:	66 90                	xchg   %ax,%ax
  80099e:	66 90                	xchg   %ax,%ax

008009a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009a0:	55                   	push   %ebp
  8009a1:	89 e5                	mov    %esp,%ebp
  8009a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ab:	eb 03                	jmp    8009b0 <strlen+0x10>
		n++;
  8009ad:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009b0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009b4:	75 f7                	jne    8009ad <strlen+0xd>
		n++;
	return n;
}
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    

008009b8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8009c6:	eb 03                	jmp    8009cb <strnlen+0x13>
		n++;
  8009c8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009cb:	39 d0                	cmp    %edx,%eax
  8009cd:	74 06                	je     8009d5 <strnlen+0x1d>
  8009cf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009d3:	75 f3                	jne    8009c8 <strnlen+0x10>
		n++;
	return n;
}
  8009d5:	5d                   	pop    %ebp
  8009d6:	c3                   	ret    

008009d7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009d7:	55                   	push   %ebp
  8009d8:	89 e5                	mov    %esp,%ebp
  8009da:	53                   	push   %ebx
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009e1:	89 c2                	mov    %eax,%edx
  8009e3:	83 c2 01             	add    $0x1,%edx
  8009e6:	83 c1 01             	add    $0x1,%ecx
  8009e9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009ed:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009f0:	84 db                	test   %bl,%bl
  8009f2:	75 ef                	jne    8009e3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009f4:	5b                   	pop    %ebx
  8009f5:	5d                   	pop    %ebp
  8009f6:	c3                   	ret    

008009f7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	53                   	push   %ebx
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a01:	89 1c 24             	mov    %ebx,(%esp)
  800a04:	e8 97 ff ff ff       	call   8009a0 <strlen>
	strcpy(dst + len, src);
  800a09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a10:	01 d8                	add    %ebx,%eax
  800a12:	89 04 24             	mov    %eax,(%esp)
  800a15:	e8 bd ff ff ff       	call   8009d7 <strcpy>
	return dst;
}
  800a1a:	89 d8                	mov    %ebx,%eax
  800a1c:	83 c4 08             	add    $0x8,%esp
  800a1f:	5b                   	pop    %ebx
  800a20:	5d                   	pop    %ebp
  800a21:	c3                   	ret    

00800a22 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	56                   	push   %esi
  800a26:	53                   	push   %ebx
  800a27:	8b 75 08             	mov    0x8(%ebp),%esi
  800a2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a2d:	89 f3                	mov    %esi,%ebx
  800a2f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a32:	89 f2                	mov    %esi,%edx
  800a34:	eb 0f                	jmp    800a45 <strncpy+0x23>
		*dst++ = *src;
  800a36:	83 c2 01             	add    $0x1,%edx
  800a39:	0f b6 01             	movzbl (%ecx),%eax
  800a3c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a3f:	80 39 01             	cmpb   $0x1,(%ecx)
  800a42:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a45:	39 da                	cmp    %ebx,%edx
  800a47:	75 ed                	jne    800a36 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a49:	89 f0                	mov    %esi,%eax
  800a4b:	5b                   	pop    %ebx
  800a4c:	5e                   	pop    %esi
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    

00800a4f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	56                   	push   %esi
  800a53:	53                   	push   %ebx
  800a54:	8b 75 08             	mov    0x8(%ebp),%esi
  800a57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a5d:	89 f0                	mov    %esi,%eax
  800a5f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a63:	85 c9                	test   %ecx,%ecx
  800a65:	75 0b                	jne    800a72 <strlcpy+0x23>
  800a67:	eb 1d                	jmp    800a86 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a69:	83 c0 01             	add    $0x1,%eax
  800a6c:	83 c2 01             	add    $0x1,%edx
  800a6f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a72:	39 d8                	cmp    %ebx,%eax
  800a74:	74 0b                	je     800a81 <strlcpy+0x32>
  800a76:	0f b6 0a             	movzbl (%edx),%ecx
  800a79:	84 c9                	test   %cl,%cl
  800a7b:	75 ec                	jne    800a69 <strlcpy+0x1a>
  800a7d:	89 c2                	mov    %eax,%edx
  800a7f:	eb 02                	jmp    800a83 <strlcpy+0x34>
  800a81:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a83:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a86:	29 f0                	sub    %esi,%eax
}
  800a88:	5b                   	pop    %ebx
  800a89:	5e                   	pop    %esi
  800a8a:	5d                   	pop    %ebp
  800a8b:	c3                   	ret    

00800a8c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a92:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a95:	eb 06                	jmp    800a9d <strcmp+0x11>
		p++, q++;
  800a97:	83 c1 01             	add    $0x1,%ecx
  800a9a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a9d:	0f b6 01             	movzbl (%ecx),%eax
  800aa0:	84 c0                	test   %al,%al
  800aa2:	74 04                	je     800aa8 <strcmp+0x1c>
  800aa4:	3a 02                	cmp    (%edx),%al
  800aa6:	74 ef                	je     800a97 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa8:	0f b6 c0             	movzbl %al,%eax
  800aab:	0f b6 12             	movzbl (%edx),%edx
  800aae:	29 d0                	sub    %edx,%eax
}
  800ab0:	5d                   	pop    %ebp
  800ab1:	c3                   	ret    

00800ab2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	53                   	push   %ebx
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800abc:	89 c3                	mov    %eax,%ebx
  800abe:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ac1:	eb 06                	jmp    800ac9 <strncmp+0x17>
		n--, p++, q++;
  800ac3:	83 c0 01             	add    $0x1,%eax
  800ac6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ac9:	39 d8                	cmp    %ebx,%eax
  800acb:	74 15                	je     800ae2 <strncmp+0x30>
  800acd:	0f b6 08             	movzbl (%eax),%ecx
  800ad0:	84 c9                	test   %cl,%cl
  800ad2:	74 04                	je     800ad8 <strncmp+0x26>
  800ad4:	3a 0a                	cmp    (%edx),%cl
  800ad6:	74 eb                	je     800ac3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad8:	0f b6 00             	movzbl (%eax),%eax
  800adb:	0f b6 12             	movzbl (%edx),%edx
  800ade:	29 d0                	sub    %edx,%eax
  800ae0:	eb 05                	jmp    800ae7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800ae2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ae7:	5b                   	pop    %ebx
  800ae8:	5d                   	pop    %ebp
  800ae9:	c3                   	ret    

00800aea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aea:	55                   	push   %ebp
  800aeb:	89 e5                	mov    %esp,%ebp
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af4:	eb 07                	jmp    800afd <strchr+0x13>
		if (*s == c)
  800af6:	38 ca                	cmp    %cl,%dl
  800af8:	74 0f                	je     800b09 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800afa:	83 c0 01             	add    $0x1,%eax
  800afd:	0f b6 10             	movzbl (%eax),%edx
  800b00:	84 d2                	test   %dl,%dl
  800b02:	75 f2                	jne    800af6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800b04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b09:	5d                   	pop    %ebp
  800b0a:	c3                   	ret    

00800b0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b15:	eb 07                	jmp    800b1e <strfind+0x13>
		if (*s == c)
  800b17:	38 ca                	cmp    %cl,%dl
  800b19:	74 0a                	je     800b25 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b1b:	83 c0 01             	add    $0x1,%eax
  800b1e:	0f b6 10             	movzbl (%eax),%edx
  800b21:	84 d2                	test   %dl,%dl
  800b23:	75 f2                	jne    800b17 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800b25:	5d                   	pop    %ebp
  800b26:	c3                   	ret    

00800b27 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b27:	55                   	push   %ebp
  800b28:	89 e5                	mov    %esp,%ebp
  800b2a:	57                   	push   %edi
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
  800b2d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b30:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b33:	85 c9                	test   %ecx,%ecx
  800b35:	74 36                	je     800b6d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b37:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b3d:	75 28                	jne    800b67 <memset+0x40>
  800b3f:	f6 c1 03             	test   $0x3,%cl
  800b42:	75 23                	jne    800b67 <memset+0x40>
		c &= 0xFF;
  800b44:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b48:	89 d3                	mov    %edx,%ebx
  800b4a:	c1 e3 08             	shl    $0x8,%ebx
  800b4d:	89 d6                	mov    %edx,%esi
  800b4f:	c1 e6 18             	shl    $0x18,%esi
  800b52:	89 d0                	mov    %edx,%eax
  800b54:	c1 e0 10             	shl    $0x10,%eax
  800b57:	09 f0                	or     %esi,%eax
  800b59:	09 c2                	or     %eax,%edx
  800b5b:	89 d0                	mov    %edx,%eax
  800b5d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b5f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b62:	fc                   	cld    
  800b63:	f3 ab                	rep stos %eax,%es:(%edi)
  800b65:	eb 06                	jmp    800b6d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6a:	fc                   	cld    
  800b6b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b6d:	89 f8                	mov    %edi,%eax
  800b6f:	5b                   	pop    %ebx
  800b70:	5e                   	pop    %esi
  800b71:	5f                   	pop    %edi
  800b72:	5d                   	pop    %ebp
  800b73:	c3                   	ret    

00800b74 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b74:	55                   	push   %ebp
  800b75:	89 e5                	mov    %esp,%ebp
  800b77:	57                   	push   %edi
  800b78:	56                   	push   %esi
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b82:	39 c6                	cmp    %eax,%esi
  800b84:	73 35                	jae    800bbb <memmove+0x47>
  800b86:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b89:	39 d0                	cmp    %edx,%eax
  800b8b:	73 2e                	jae    800bbb <memmove+0x47>
		s += n;
		d += n;
  800b8d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b90:	89 d6                	mov    %edx,%esi
  800b92:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b94:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b9a:	75 13                	jne    800baf <memmove+0x3b>
  800b9c:	f6 c1 03             	test   $0x3,%cl
  800b9f:	75 0e                	jne    800baf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ba1:	83 ef 04             	sub    $0x4,%edi
  800ba4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ba7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800baa:	fd                   	std    
  800bab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bad:	eb 09                	jmp    800bb8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800baf:	83 ef 01             	sub    $0x1,%edi
  800bb2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800bb5:	fd                   	std    
  800bb6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bb8:	fc                   	cld    
  800bb9:	eb 1d                	jmp    800bd8 <memmove+0x64>
  800bbb:	89 f2                	mov    %esi,%edx
  800bbd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bbf:	f6 c2 03             	test   $0x3,%dl
  800bc2:	75 0f                	jne    800bd3 <memmove+0x5f>
  800bc4:	f6 c1 03             	test   $0x3,%cl
  800bc7:	75 0a                	jne    800bd3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bc9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800bcc:	89 c7                	mov    %eax,%edi
  800bce:	fc                   	cld    
  800bcf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bd1:	eb 05                	jmp    800bd8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bd3:	89 c7                	mov    %eax,%edi
  800bd5:	fc                   	cld    
  800bd6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bd8:	5e                   	pop    %esi
  800bd9:	5f                   	pop    %edi
  800bda:	5d                   	pop    %ebp
  800bdb:	c3                   	ret    

00800bdc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800be2:	8b 45 10             	mov    0x10(%ebp),%eax
  800be5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800be9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bec:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	89 04 24             	mov    %eax,(%esp)
  800bf6:	e8 79 ff ff ff       	call   800b74 <memmove>
}
  800bfb:	c9                   	leave  
  800bfc:	c3                   	ret    

00800bfd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	56                   	push   %esi
  800c01:	53                   	push   %ebx
  800c02:	8b 55 08             	mov    0x8(%ebp),%edx
  800c05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c08:	89 d6                	mov    %edx,%esi
  800c0a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c0d:	eb 1a                	jmp    800c29 <memcmp+0x2c>
		if (*s1 != *s2)
  800c0f:	0f b6 02             	movzbl (%edx),%eax
  800c12:	0f b6 19             	movzbl (%ecx),%ebx
  800c15:	38 d8                	cmp    %bl,%al
  800c17:	74 0a                	je     800c23 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800c19:	0f b6 c0             	movzbl %al,%eax
  800c1c:	0f b6 db             	movzbl %bl,%ebx
  800c1f:	29 d8                	sub    %ebx,%eax
  800c21:	eb 0f                	jmp    800c32 <memcmp+0x35>
		s1++, s2++;
  800c23:	83 c2 01             	add    $0x1,%edx
  800c26:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c29:	39 f2                	cmp    %esi,%edx
  800c2b:	75 e2                	jne    800c0f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c32:	5b                   	pop    %ebx
  800c33:	5e                   	pop    %esi
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c3f:	89 c2                	mov    %eax,%edx
  800c41:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c44:	eb 07                	jmp    800c4d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c46:	38 08                	cmp    %cl,(%eax)
  800c48:	74 07                	je     800c51 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c4a:	83 c0 01             	add    $0x1,%eax
  800c4d:	39 d0                	cmp    %edx,%eax
  800c4f:	72 f5                	jb     800c46 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
  800c59:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c5f:	eb 03                	jmp    800c64 <strtol+0x11>
		s++;
  800c61:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c64:	0f b6 0a             	movzbl (%edx),%ecx
  800c67:	80 f9 09             	cmp    $0x9,%cl
  800c6a:	74 f5                	je     800c61 <strtol+0xe>
  800c6c:	80 f9 20             	cmp    $0x20,%cl
  800c6f:	74 f0                	je     800c61 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c71:	80 f9 2b             	cmp    $0x2b,%cl
  800c74:	75 0a                	jne    800c80 <strtol+0x2d>
		s++;
  800c76:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c79:	bf 00 00 00 00       	mov    $0x0,%edi
  800c7e:	eb 11                	jmp    800c91 <strtol+0x3e>
  800c80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c85:	80 f9 2d             	cmp    $0x2d,%cl
  800c88:	75 07                	jne    800c91 <strtol+0x3e>
		s++, neg = 1;
  800c8a:	8d 52 01             	lea    0x1(%edx),%edx
  800c8d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c91:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c96:	75 15                	jne    800cad <strtol+0x5a>
  800c98:	80 3a 30             	cmpb   $0x30,(%edx)
  800c9b:	75 10                	jne    800cad <strtol+0x5a>
  800c9d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ca1:	75 0a                	jne    800cad <strtol+0x5a>
		s += 2, base = 16;
  800ca3:	83 c2 02             	add    $0x2,%edx
  800ca6:	b8 10 00 00 00       	mov    $0x10,%eax
  800cab:	eb 10                	jmp    800cbd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800cad:	85 c0                	test   %eax,%eax
  800caf:	75 0c                	jne    800cbd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800cb1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cb3:	80 3a 30             	cmpb   $0x30,(%edx)
  800cb6:	75 05                	jne    800cbd <strtol+0x6a>
		s++, base = 8;
  800cb8:	83 c2 01             	add    $0x1,%edx
  800cbb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800cbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cc2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cc5:	0f b6 0a             	movzbl (%edx),%ecx
  800cc8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800ccb:	89 f0                	mov    %esi,%eax
  800ccd:	3c 09                	cmp    $0x9,%al
  800ccf:	77 08                	ja     800cd9 <strtol+0x86>
			dig = *s - '0';
  800cd1:	0f be c9             	movsbl %cl,%ecx
  800cd4:	83 e9 30             	sub    $0x30,%ecx
  800cd7:	eb 20                	jmp    800cf9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800cd9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800cdc:	89 f0                	mov    %esi,%eax
  800cde:	3c 19                	cmp    $0x19,%al
  800ce0:	77 08                	ja     800cea <strtol+0x97>
			dig = *s - 'a' + 10;
  800ce2:	0f be c9             	movsbl %cl,%ecx
  800ce5:	83 e9 57             	sub    $0x57,%ecx
  800ce8:	eb 0f                	jmp    800cf9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800cea:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800ced:	89 f0                	mov    %esi,%eax
  800cef:	3c 19                	cmp    $0x19,%al
  800cf1:	77 16                	ja     800d09 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800cf3:	0f be c9             	movsbl %cl,%ecx
  800cf6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cf9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800cfc:	7d 0f                	jge    800d0d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800cfe:	83 c2 01             	add    $0x1,%edx
  800d01:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800d05:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800d07:	eb bc                	jmp    800cc5 <strtol+0x72>
  800d09:	89 d8                	mov    %ebx,%eax
  800d0b:	eb 02                	jmp    800d0f <strtol+0xbc>
  800d0d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800d0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d13:	74 05                	je     800d1a <strtol+0xc7>
		*endptr = (char *) s;
  800d15:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d18:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800d1a:	f7 d8                	neg    %eax
  800d1c:	85 ff                	test   %edi,%edi
  800d1e:	0f 44 c3             	cmove  %ebx,%eax
}
  800d21:	5b                   	pop    %ebx
  800d22:	5e                   	pop    %esi
  800d23:	5f                   	pop    %edi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	57                   	push   %edi
  800d2a:	56                   	push   %esi
  800d2b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d34:	8b 55 08             	mov    0x8(%ebp),%edx
  800d37:	89 c3                	mov    %eax,%ebx
  800d39:	89 c7                	mov    %eax,%edi
  800d3b:	89 c6                	mov    %eax,%esi
  800d3d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    

00800d44 <sys_cgetc>:

int
sys_cgetc(void)
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
  800d4f:	b8 01 00 00 00       	mov    $0x1,%eax
  800d54:	89 d1                	mov    %edx,%ecx
  800d56:	89 d3                	mov    %edx,%ebx
  800d58:	89 d7                	mov    %edx,%edi
  800d5a:	89 d6                	mov    %edx,%esi
  800d5c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d5e:	5b                   	pop    %ebx
  800d5f:	5e                   	pop    %esi
  800d60:	5f                   	pop    %edi
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800d6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d71:	b8 03 00 00 00       	mov    $0x3,%eax
  800d76:	8b 55 08             	mov    0x8(%ebp),%edx
  800d79:	89 cb                	mov    %ecx,%ebx
  800d7b:	89 cf                	mov    %ecx,%edi
  800d7d:	89 ce                	mov    %ecx,%esi
  800d7f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800d81:	85 c0                	test   %eax,%eax
  800d83:	7e 28                	jle    800dad <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d85:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d89:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d90:	00 
  800d91:	c7 44 24 08 27 2c 80 	movl   $0x802c27,0x8(%esp)
  800d98:	00 
  800d99:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800da0:	00 
  800da1:	c7 04 24 44 2c 80 00 	movl   $0x802c44,(%esp)
  800da8:	e8 02 f5 ff ff       	call   8002af <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800dad:	83 c4 2c             	add    $0x2c,%esp
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	57                   	push   %edi
  800db9:	56                   	push   %esi
  800dba:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc0:	b8 02 00 00 00       	mov    $0x2,%eax
  800dc5:	89 d1                	mov    %edx,%ecx
  800dc7:	89 d3                	mov    %edx,%ebx
  800dc9:	89 d7                	mov    %edx,%edi
  800dcb:	89 d6                	mov    %edx,%esi
  800dcd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <sys_yield>:

void
sys_yield(void)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	57                   	push   %edi
  800dd8:	56                   	push   %esi
  800dd9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dda:	ba 00 00 00 00       	mov    $0x0,%edx
  800ddf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800de4:	89 d1                	mov    %edx,%ecx
  800de6:	89 d3                	mov    %edx,%ebx
  800de8:	89 d7                	mov    %edx,%edi
  800dea:	89 d6                	mov    %edx,%esi
  800dec:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	57                   	push   %edi
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dfc:	be 00 00 00 00       	mov    $0x0,%esi
  800e01:	b8 04 00 00 00       	mov    $0x4,%eax
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e0f:	89 f7                	mov    %esi,%edi
  800e11:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e13:	85 c0                	test   %eax,%eax
  800e15:	7e 28                	jle    800e3f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e17:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e1b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800e22:	00 
  800e23:	c7 44 24 08 27 2c 80 	movl   $0x802c27,0x8(%esp)
  800e2a:	00 
  800e2b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e32:	00 
  800e33:	c7 04 24 44 2c 80 00 	movl   $0x802c44,(%esp)
  800e3a:	e8 70 f4 ff ff       	call   8002af <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e3f:	83 c4 2c             	add    $0x2c,%esp
  800e42:	5b                   	pop    %ebx
  800e43:	5e                   	pop    %esi
  800e44:	5f                   	pop    %edi
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    

00800e47 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	57                   	push   %edi
  800e4b:	56                   	push   %esi
  800e4c:	53                   	push   %ebx
  800e4d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e50:	b8 05 00 00 00       	mov    $0x5,%eax
  800e55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e58:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e61:	8b 75 18             	mov    0x18(%ebp),%esi
  800e64:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800e66:	85 c0                	test   %eax,%eax
  800e68:	7e 28                	jle    800e92 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e75:	00 
  800e76:	c7 44 24 08 27 2c 80 	movl   $0x802c27,0x8(%esp)
  800e7d:	00 
  800e7e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e85:	00 
  800e86:	c7 04 24 44 2c 80 00 	movl   $0x802c44,(%esp)
  800e8d:	e8 1d f4 ff ff       	call   8002af <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e92:	83 c4 2c             	add    $0x2c,%esp
  800e95:	5b                   	pop    %ebx
  800e96:	5e                   	pop    %esi
  800e97:	5f                   	pop    %edi
  800e98:	5d                   	pop    %ebp
  800e99:	c3                   	ret    

00800e9a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	57                   	push   %edi
  800e9e:	56                   	push   %esi
  800e9f:	53                   	push   %ebx
  800ea0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea8:	b8 06 00 00 00       	mov    $0x6,%eax
  800ead:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb3:	89 df                	mov    %ebx,%edi
  800eb5:	89 de                	mov    %ebx,%esi
  800eb7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	7e 28                	jle    800ee5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800ec8:	00 
  800ec9:	c7 44 24 08 27 2c 80 	movl   $0x802c27,0x8(%esp)
  800ed0:	00 
  800ed1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed8:	00 
  800ed9:	c7 04 24 44 2c 80 00 	movl   $0x802c44,(%esp)
  800ee0:	e8 ca f3 ff ff       	call   8002af <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ee5:	83 c4 2c             	add    $0x2c,%esp
  800ee8:	5b                   	pop    %ebx
  800ee9:	5e                   	pop    %esi
  800eea:	5f                   	pop    %edi
  800eeb:	5d                   	pop    %ebp
  800eec:	c3                   	ret    

00800eed <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	57                   	push   %edi
  800ef1:	56                   	push   %esi
  800ef2:	53                   	push   %ebx
  800ef3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800efb:	b8 08 00 00 00       	mov    $0x8,%eax
  800f00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f03:	8b 55 08             	mov    0x8(%ebp),%edx
  800f06:	89 df                	mov    %ebx,%edi
  800f08:	89 de                	mov    %ebx,%esi
  800f0a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f0c:	85 c0                	test   %eax,%eax
  800f0e:	7e 28                	jle    800f38 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f10:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f14:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f1b:	00 
  800f1c:	c7 44 24 08 27 2c 80 	movl   $0x802c27,0x8(%esp)
  800f23:	00 
  800f24:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f2b:	00 
  800f2c:	c7 04 24 44 2c 80 00 	movl   $0x802c44,(%esp)
  800f33:	e8 77 f3 ff ff       	call   8002af <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f38:	83 c4 2c             	add    $0x2c,%esp
  800f3b:	5b                   	pop    %ebx
  800f3c:	5e                   	pop    %esi
  800f3d:	5f                   	pop    %edi
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	57                   	push   %edi
  800f44:	56                   	push   %esi
  800f45:	53                   	push   %ebx
  800f46:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f56:	8b 55 08             	mov    0x8(%ebp),%edx
  800f59:	89 df                	mov    %ebx,%edi
  800f5b:	89 de                	mov    %ebx,%esi
  800f5d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f5f:	85 c0                	test   %eax,%eax
  800f61:	7e 28                	jle    800f8b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f63:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f67:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f6e:	00 
  800f6f:	c7 44 24 08 27 2c 80 	movl   $0x802c27,0x8(%esp)
  800f76:	00 
  800f77:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f7e:	00 
  800f7f:	c7 04 24 44 2c 80 00 	movl   $0x802c44,(%esp)
  800f86:	e8 24 f3 ff ff       	call   8002af <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f8b:	83 c4 2c             	add    $0x2c,%esp
  800f8e:	5b                   	pop    %ebx
  800f8f:	5e                   	pop    %esi
  800f90:	5f                   	pop    %edi
  800f91:	5d                   	pop    %ebp
  800f92:	c3                   	ret    

00800f93 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	57                   	push   %edi
  800f97:	56                   	push   %esi
  800f98:	53                   	push   %ebx
  800f99:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fa6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fac:	89 df                	mov    %ebx,%edi
  800fae:	89 de                	mov    %ebx,%esi
  800fb0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800fb2:	85 c0                	test   %eax,%eax
  800fb4:	7e 28                	jle    800fde <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fba:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800fc1:	00 
  800fc2:	c7 44 24 08 27 2c 80 	movl   $0x802c27,0x8(%esp)
  800fc9:	00 
  800fca:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd1:	00 
  800fd2:	c7 04 24 44 2c 80 00 	movl   $0x802c44,(%esp)
  800fd9:	e8 d1 f2 ff ff       	call   8002af <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fde:	83 c4 2c             	add    $0x2c,%esp
  800fe1:	5b                   	pop    %ebx
  800fe2:	5e                   	pop    %esi
  800fe3:	5f                   	pop    %edi
  800fe4:	5d                   	pop    %ebp
  800fe5:	c3                   	ret    

00800fe6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	57                   	push   %edi
  800fea:	56                   	push   %esi
  800feb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fec:	be 00 00 00 00       	mov    $0x0,%esi
  800ff1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ff6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fff:	8b 7d 14             	mov    0x14(%ebp),%edi
  801002:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801004:	5b                   	pop    %ebx
  801005:	5e                   	pop    %esi
  801006:	5f                   	pop    %edi
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    

00801009 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	57                   	push   %edi
  80100d:	56                   	push   %esi
  80100e:	53                   	push   %ebx
  80100f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801012:	b9 00 00 00 00       	mov    $0x0,%ecx
  801017:	b8 0d 00 00 00       	mov    $0xd,%eax
  80101c:	8b 55 08             	mov    0x8(%ebp),%edx
  80101f:	89 cb                	mov    %ecx,%ebx
  801021:	89 cf                	mov    %ecx,%edi
  801023:	89 ce                	mov    %ecx,%esi
  801025:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801027:	85 c0                	test   %eax,%eax
  801029:	7e 28                	jle    801053 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80102b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80102f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801036:	00 
  801037:	c7 44 24 08 27 2c 80 	movl   $0x802c27,0x8(%esp)
  80103e:	00 
  80103f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801046:	00 
  801047:	c7 04 24 44 2c 80 00 	movl   $0x802c44,(%esp)
  80104e:	e8 5c f2 ff ff       	call   8002af <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801053:	83 c4 2c             	add    $0x2c,%esp
  801056:	5b                   	pop    %ebx
  801057:	5e                   	pop    %esi
  801058:	5f                   	pop    %edi
  801059:	5d                   	pop    %ebp
  80105a:	c3                   	ret    

0080105b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	57                   	push   %edi
  80105f:	56                   	push   %esi
  801060:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801061:	ba 00 00 00 00       	mov    $0x0,%edx
  801066:	b8 0e 00 00 00       	mov    $0xe,%eax
  80106b:	89 d1                	mov    %edx,%ecx
  80106d:	89 d3                	mov    %edx,%ebx
  80106f:	89 d7                	mov    %edx,%edi
  801071:	89 d6                	mov    %edx,%esi
  801073:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801075:	5b                   	pop    %ebx
  801076:	5e                   	pop    %esi
  801077:	5f                   	pop    %edi
  801078:	5d                   	pop    %ebp
  801079:	c3                   	ret    

0080107a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	57                   	push   %edi
  80107e:	56                   	push   %esi
  80107f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801080:	bb 00 00 00 00       	mov    $0x0,%ebx
  801085:	b8 0f 00 00 00       	mov    $0xf,%eax
  80108a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108d:	8b 55 08             	mov    0x8(%ebp),%edx
  801090:	89 df                	mov    %ebx,%edi
  801092:	89 de                	mov    %ebx,%esi
  801094:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  801096:	5b                   	pop    %ebx
  801097:	5e                   	pop    %esi
  801098:	5f                   	pop    %edi
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    

0080109b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	57                   	push   %edi
  80109f:	56                   	push   %esi
  8010a0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a6:	b8 10 00 00 00       	mov    $0x10,%eax
  8010ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b1:	89 df                	mov    %ebx,%edi
  8010b3:	89 de                	mov    %ebx,%esi
  8010b5:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  8010b7:	5b                   	pop    %ebx
  8010b8:	5e                   	pop    %esi
  8010b9:	5f                   	pop    %edi
  8010ba:	5d                   	pop    %ebp
  8010bb:	c3                   	ret    

008010bc <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	57                   	push   %edi
  8010c0:	56                   	push   %esi
  8010c1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010c7:	b8 11 00 00 00       	mov    $0x11,%eax
  8010cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cf:	89 cb                	mov    %ecx,%ebx
  8010d1:	89 cf                	mov    %ecx,%edi
  8010d3:	89 ce                	mov    %ecx,%esi
  8010d5:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  8010d7:	5b                   	pop    %ebx
  8010d8:	5e                   	pop    %esi
  8010d9:	5f                   	pop    %edi
  8010da:	5d                   	pop    %ebp
  8010db:	c3                   	ret    

008010dc <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	57                   	push   %edi
  8010e0:	56                   	push   %esi
  8010e1:	53                   	push   %ebx
  8010e2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e5:	be 00 00 00 00       	mov    $0x0,%esi
  8010ea:	b8 12 00 00 00       	mov    $0x12,%eax
  8010ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010f8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010fb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	7e 28                	jle    801129 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801101:	89 44 24 10          	mov    %eax,0x10(%esp)
  801105:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80110c:	00 
  80110d:	c7 44 24 08 27 2c 80 	movl   $0x802c27,0x8(%esp)
  801114:	00 
  801115:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80111c:	00 
  80111d:	c7 04 24 44 2c 80 00 	movl   $0x802c44,(%esp)
  801124:	e8 86 f1 ff ff       	call   8002af <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801129:	83 c4 2c             	add    $0x2c,%esp
  80112c:	5b                   	pop    %ebx
  80112d:	5e                   	pop    %esi
  80112e:	5f                   	pop    %edi
  80112f:	5d                   	pop    %ebp
  801130:	c3                   	ret    
  801131:	66 90                	xchg   %ax,%ax
  801133:	66 90                	xchg   %ax,%ax
  801135:	66 90                	xchg   %ax,%ax
  801137:	66 90                	xchg   %ax,%ax
  801139:	66 90                	xchg   %ax,%ax
  80113b:	66 90                	xchg   %ax,%ax
  80113d:	66 90                	xchg   %ax,%ax
  80113f:	90                   	nop

00801140 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801143:	8b 45 08             	mov    0x8(%ebp),%eax
  801146:	05 00 00 00 30       	add    $0x30000000,%eax
  80114b:	c1 e8 0c             	shr    $0xc,%eax
}
  80114e:	5d                   	pop    %ebp
  80114f:	c3                   	ret    

00801150 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80115b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801160:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801165:	5d                   	pop    %ebp
  801166:	c3                   	ret    

00801167 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
  80116a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80116d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801172:	89 c2                	mov    %eax,%edx
  801174:	c1 ea 16             	shr    $0x16,%edx
  801177:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80117e:	f6 c2 01             	test   $0x1,%dl
  801181:	74 11                	je     801194 <fd_alloc+0x2d>
  801183:	89 c2                	mov    %eax,%edx
  801185:	c1 ea 0c             	shr    $0xc,%edx
  801188:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80118f:	f6 c2 01             	test   $0x1,%dl
  801192:	75 09                	jne    80119d <fd_alloc+0x36>
			*fd_store = fd;
  801194:	89 01                	mov    %eax,(%ecx)
			return 0;
  801196:	b8 00 00 00 00       	mov    $0x0,%eax
  80119b:	eb 17                	jmp    8011b4 <fd_alloc+0x4d>
  80119d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8011a2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011a7:	75 c9                	jne    801172 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011a9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011af:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8011b4:	5d                   	pop    %ebp
  8011b5:	c3                   	ret    

008011b6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8011bc:	83 f8 1f             	cmp    $0x1f,%eax
  8011bf:	77 36                	ja     8011f7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8011c1:	c1 e0 0c             	shl    $0xc,%eax
  8011c4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8011c9:	89 c2                	mov    %eax,%edx
  8011cb:	c1 ea 16             	shr    $0x16,%edx
  8011ce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011d5:	f6 c2 01             	test   $0x1,%dl
  8011d8:	74 24                	je     8011fe <fd_lookup+0x48>
  8011da:	89 c2                	mov    %eax,%edx
  8011dc:	c1 ea 0c             	shr    $0xc,%edx
  8011df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011e6:	f6 c2 01             	test   $0x1,%dl
  8011e9:	74 1a                	je     801205 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8011eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ee:	89 02                	mov    %eax,(%edx)
	return 0;
  8011f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f5:	eb 13                	jmp    80120a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011fc:	eb 0c                	jmp    80120a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8011fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801203:	eb 05                	jmp    80120a <fd_lookup+0x54>
  801205:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    

0080120c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	83 ec 18             	sub    $0x18,%esp
  801212:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801215:	ba 00 00 00 00       	mov    $0x0,%edx
  80121a:	eb 13                	jmp    80122f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80121c:	39 08                	cmp    %ecx,(%eax)
  80121e:	75 0c                	jne    80122c <dev_lookup+0x20>
			*dev = devtab[i];
  801220:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801223:	89 01                	mov    %eax,(%ecx)
			return 0;
  801225:	b8 00 00 00 00       	mov    $0x0,%eax
  80122a:	eb 38                	jmp    801264 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80122c:	83 c2 01             	add    $0x1,%edx
  80122f:	8b 04 95 d4 2c 80 00 	mov    0x802cd4(,%edx,4),%eax
  801236:	85 c0                	test   %eax,%eax
  801238:	75 e2                	jne    80121c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80123a:	a1 08 40 80 00       	mov    0x804008,%eax
  80123f:	8b 40 48             	mov    0x48(%eax),%eax
  801242:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801246:	89 44 24 04          	mov    %eax,0x4(%esp)
  80124a:	c7 04 24 54 2c 80 00 	movl   $0x802c54,(%esp)
  801251:	e8 52 f1 ff ff       	call   8003a8 <cprintf>
	*dev = 0;
  801256:	8b 45 0c             	mov    0xc(%ebp),%eax
  801259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80125f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801264:	c9                   	leave  
  801265:	c3                   	ret    

00801266 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	56                   	push   %esi
  80126a:	53                   	push   %ebx
  80126b:	83 ec 20             	sub    $0x20,%esp
  80126e:	8b 75 08             	mov    0x8(%ebp),%esi
  801271:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801274:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801277:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80127b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801281:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801284:	89 04 24             	mov    %eax,(%esp)
  801287:	e8 2a ff ff ff       	call   8011b6 <fd_lookup>
  80128c:	85 c0                	test   %eax,%eax
  80128e:	78 05                	js     801295 <fd_close+0x2f>
	    || fd != fd2)
  801290:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801293:	74 0c                	je     8012a1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801295:	84 db                	test   %bl,%bl
  801297:	ba 00 00 00 00       	mov    $0x0,%edx
  80129c:	0f 44 c2             	cmove  %edx,%eax
  80129f:	eb 3f                	jmp    8012e0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012a8:	8b 06                	mov    (%esi),%eax
  8012aa:	89 04 24             	mov    %eax,(%esp)
  8012ad:	e8 5a ff ff ff       	call   80120c <dev_lookup>
  8012b2:	89 c3                	mov    %eax,%ebx
  8012b4:	85 c0                	test   %eax,%eax
  8012b6:	78 16                	js     8012ce <fd_close+0x68>
		if (dev->dev_close)
  8012b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8012be:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	74 07                	je     8012ce <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8012c7:	89 34 24             	mov    %esi,(%esp)
  8012ca:	ff d0                	call   *%eax
  8012cc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8012ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d9:	e8 bc fb ff ff       	call   800e9a <sys_page_unmap>
	return r;
  8012de:	89 d8                	mov    %ebx,%eax
}
  8012e0:	83 c4 20             	add    $0x20,%esp
  8012e3:	5b                   	pop    %ebx
  8012e4:	5e                   	pop    %esi
  8012e5:	5d                   	pop    %ebp
  8012e6:	c3                   	ret    

008012e7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	89 04 24             	mov    %eax,(%esp)
  8012fa:	e8 b7 fe ff ff       	call   8011b6 <fd_lookup>
  8012ff:	89 c2                	mov    %eax,%edx
  801301:	85 d2                	test   %edx,%edx
  801303:	78 13                	js     801318 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801305:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80130c:	00 
  80130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801310:	89 04 24             	mov    %eax,(%esp)
  801313:	e8 4e ff ff ff       	call   801266 <fd_close>
}
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <close_all>:

void
close_all(void)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	53                   	push   %ebx
  80131e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801321:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801326:	89 1c 24             	mov    %ebx,(%esp)
  801329:	e8 b9 ff ff ff       	call   8012e7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80132e:	83 c3 01             	add    $0x1,%ebx
  801331:	83 fb 20             	cmp    $0x20,%ebx
  801334:	75 f0                	jne    801326 <close_all+0xc>
		close(i);
}
  801336:	83 c4 14             	add    $0x14,%esp
  801339:	5b                   	pop    %ebx
  80133a:	5d                   	pop    %ebp
  80133b:	c3                   	ret    

0080133c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	57                   	push   %edi
  801340:	56                   	push   %esi
  801341:	53                   	push   %ebx
  801342:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801345:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801348:	89 44 24 04          	mov    %eax,0x4(%esp)
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	89 04 24             	mov    %eax,(%esp)
  801352:	e8 5f fe ff ff       	call   8011b6 <fd_lookup>
  801357:	89 c2                	mov    %eax,%edx
  801359:	85 d2                	test   %edx,%edx
  80135b:	0f 88 e1 00 00 00    	js     801442 <dup+0x106>
		return r;
	close(newfdnum);
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	89 04 24             	mov    %eax,(%esp)
  801367:	e8 7b ff ff ff       	call   8012e7 <close>

	newfd = INDEX2FD(newfdnum);
  80136c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80136f:	c1 e3 0c             	shl    $0xc,%ebx
  801372:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80137b:	89 04 24             	mov    %eax,(%esp)
  80137e:	e8 cd fd ff ff       	call   801150 <fd2data>
  801383:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801385:	89 1c 24             	mov    %ebx,(%esp)
  801388:	e8 c3 fd ff ff       	call   801150 <fd2data>
  80138d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80138f:	89 f0                	mov    %esi,%eax
  801391:	c1 e8 16             	shr    $0x16,%eax
  801394:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80139b:	a8 01                	test   $0x1,%al
  80139d:	74 43                	je     8013e2 <dup+0xa6>
  80139f:	89 f0                	mov    %esi,%eax
  8013a1:	c1 e8 0c             	shr    $0xc,%eax
  8013a4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013ab:	f6 c2 01             	test   $0x1,%dl
  8013ae:	74 32                	je     8013e2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8013b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8013b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8013bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013c0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8013c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013cb:	00 
  8013cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013d7:	e8 6b fa ff ff       	call   800e47 <sys_page_map>
  8013dc:	89 c6                	mov    %eax,%esi
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	78 3e                	js     801420 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e5:	89 c2                	mov    %eax,%edx
  8013e7:	c1 ea 0c             	shr    $0xc,%edx
  8013ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013f1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8013f7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801406:	00 
  801407:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801412:	e8 30 fa ff ff       	call   800e47 <sys_page_map>
  801417:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801419:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80141c:	85 f6                	test   %esi,%esi
  80141e:	79 22                	jns    801442 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801420:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801424:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80142b:	e8 6a fa ff ff       	call   800e9a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801430:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801434:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80143b:	e8 5a fa ff ff       	call   800e9a <sys_page_unmap>
	return r;
  801440:	89 f0                	mov    %esi,%eax
}
  801442:	83 c4 3c             	add    $0x3c,%esp
  801445:	5b                   	pop    %ebx
  801446:	5e                   	pop    %esi
  801447:	5f                   	pop    %edi
  801448:	5d                   	pop    %ebp
  801449:	c3                   	ret    

0080144a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	53                   	push   %ebx
  80144e:	83 ec 24             	sub    $0x24,%esp
  801451:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801454:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801457:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145b:	89 1c 24             	mov    %ebx,(%esp)
  80145e:	e8 53 fd ff ff       	call   8011b6 <fd_lookup>
  801463:	89 c2                	mov    %eax,%edx
  801465:	85 d2                	test   %edx,%edx
  801467:	78 6d                	js     8014d6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801469:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80146c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801473:	8b 00                	mov    (%eax),%eax
  801475:	89 04 24             	mov    %eax,(%esp)
  801478:	e8 8f fd ff ff       	call   80120c <dev_lookup>
  80147d:	85 c0                	test   %eax,%eax
  80147f:	78 55                	js     8014d6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801484:	8b 50 08             	mov    0x8(%eax),%edx
  801487:	83 e2 03             	and    $0x3,%edx
  80148a:	83 fa 01             	cmp    $0x1,%edx
  80148d:	75 23                	jne    8014b2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80148f:	a1 08 40 80 00       	mov    0x804008,%eax
  801494:	8b 40 48             	mov    0x48(%eax),%eax
  801497:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80149b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149f:	c7 04 24 98 2c 80 00 	movl   $0x802c98,(%esp)
  8014a6:	e8 fd ee ff ff       	call   8003a8 <cprintf>
		return -E_INVAL;
  8014ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b0:	eb 24                	jmp    8014d6 <read+0x8c>
	}
	if (!dev->dev_read)
  8014b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b5:	8b 52 08             	mov    0x8(%edx),%edx
  8014b8:	85 d2                	test   %edx,%edx
  8014ba:	74 15                	je     8014d1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014ca:	89 04 24             	mov    %eax,(%esp)
  8014cd:	ff d2                	call   *%edx
  8014cf:	eb 05                	jmp    8014d6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8014d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8014d6:	83 c4 24             	add    $0x24,%esp
  8014d9:	5b                   	pop    %ebx
  8014da:	5d                   	pop    %ebp
  8014db:	c3                   	ret    

008014dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	57                   	push   %edi
  8014e0:	56                   	push   %esi
  8014e1:	53                   	push   %ebx
  8014e2:	83 ec 1c             	sub    $0x1c,%esp
  8014e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8014eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014f0:	eb 23                	jmp    801515 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8014f2:	89 f0                	mov    %esi,%eax
  8014f4:	29 d8                	sub    %ebx,%eax
  8014f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014fa:	89 d8                	mov    %ebx,%eax
  8014fc:	03 45 0c             	add    0xc(%ebp),%eax
  8014ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801503:	89 3c 24             	mov    %edi,(%esp)
  801506:	e8 3f ff ff ff       	call   80144a <read>
		if (m < 0)
  80150b:	85 c0                	test   %eax,%eax
  80150d:	78 10                	js     80151f <readn+0x43>
			return m;
		if (m == 0)
  80150f:	85 c0                	test   %eax,%eax
  801511:	74 0a                	je     80151d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801513:	01 c3                	add    %eax,%ebx
  801515:	39 f3                	cmp    %esi,%ebx
  801517:	72 d9                	jb     8014f2 <readn+0x16>
  801519:	89 d8                	mov    %ebx,%eax
  80151b:	eb 02                	jmp    80151f <readn+0x43>
  80151d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80151f:	83 c4 1c             	add    $0x1c,%esp
  801522:	5b                   	pop    %ebx
  801523:	5e                   	pop    %esi
  801524:	5f                   	pop    %edi
  801525:	5d                   	pop    %ebp
  801526:	c3                   	ret    

00801527 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	53                   	push   %ebx
  80152b:	83 ec 24             	sub    $0x24,%esp
  80152e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801531:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801534:	89 44 24 04          	mov    %eax,0x4(%esp)
  801538:	89 1c 24             	mov    %ebx,(%esp)
  80153b:	e8 76 fc ff ff       	call   8011b6 <fd_lookup>
  801540:	89 c2                	mov    %eax,%edx
  801542:	85 d2                	test   %edx,%edx
  801544:	78 68                	js     8015ae <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801546:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801549:	89 44 24 04          	mov    %eax,0x4(%esp)
  80154d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801550:	8b 00                	mov    (%eax),%eax
  801552:	89 04 24             	mov    %eax,(%esp)
  801555:	e8 b2 fc ff ff       	call   80120c <dev_lookup>
  80155a:	85 c0                	test   %eax,%eax
  80155c:	78 50                	js     8015ae <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80155e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801561:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801565:	75 23                	jne    80158a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801567:	a1 08 40 80 00       	mov    0x804008,%eax
  80156c:	8b 40 48             	mov    0x48(%eax),%eax
  80156f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801573:	89 44 24 04          	mov    %eax,0x4(%esp)
  801577:	c7 04 24 b4 2c 80 00 	movl   $0x802cb4,(%esp)
  80157e:	e8 25 ee ff ff       	call   8003a8 <cprintf>
		return -E_INVAL;
  801583:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801588:	eb 24                	jmp    8015ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80158a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158d:	8b 52 0c             	mov    0xc(%edx),%edx
  801590:	85 d2                	test   %edx,%edx
  801592:	74 15                	je     8015a9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801594:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801597:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80159b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80159e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015a2:	89 04 24             	mov    %eax,(%esp)
  8015a5:	ff d2                	call   *%edx
  8015a7:	eb 05                	jmp    8015ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8015a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8015ae:	83 c4 24             	add    $0x24,%esp
  8015b1:	5b                   	pop    %ebx
  8015b2:	5d                   	pop    %ebp
  8015b3:	c3                   	ret    

008015b4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
  8015b7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ba:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c4:	89 04 24             	mov    %eax,(%esp)
  8015c7:	e8 ea fb ff ff       	call   8011b6 <fd_lookup>
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	78 0e                	js     8015de <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	53                   	push   %ebx
  8015e4:	83 ec 24             	sub    $0x24,%esp
  8015e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f1:	89 1c 24             	mov    %ebx,(%esp)
  8015f4:	e8 bd fb ff ff       	call   8011b6 <fd_lookup>
  8015f9:	89 c2                	mov    %eax,%edx
  8015fb:	85 d2                	test   %edx,%edx
  8015fd:	78 61                	js     801660 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801602:	89 44 24 04          	mov    %eax,0x4(%esp)
  801606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801609:	8b 00                	mov    (%eax),%eax
  80160b:	89 04 24             	mov    %eax,(%esp)
  80160e:	e8 f9 fb ff ff       	call   80120c <dev_lookup>
  801613:	85 c0                	test   %eax,%eax
  801615:	78 49                	js     801660 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80161e:	75 23                	jne    801643 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801620:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801625:	8b 40 48             	mov    0x48(%eax),%eax
  801628:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80162c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801630:	c7 04 24 74 2c 80 00 	movl   $0x802c74,(%esp)
  801637:	e8 6c ed ff ff       	call   8003a8 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80163c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801641:	eb 1d                	jmp    801660 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801643:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801646:	8b 52 18             	mov    0x18(%edx),%edx
  801649:	85 d2                	test   %edx,%edx
  80164b:	74 0e                	je     80165b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80164d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801650:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801654:	89 04 24             	mov    %eax,(%esp)
  801657:	ff d2                	call   *%edx
  801659:	eb 05                	jmp    801660 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80165b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801660:	83 c4 24             	add    $0x24,%esp
  801663:	5b                   	pop    %ebx
  801664:	5d                   	pop    %ebp
  801665:	c3                   	ret    

00801666 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	53                   	push   %ebx
  80166a:	83 ec 24             	sub    $0x24,%esp
  80166d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801670:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801673:	89 44 24 04          	mov    %eax,0x4(%esp)
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	89 04 24             	mov    %eax,(%esp)
  80167d:	e8 34 fb ff ff       	call   8011b6 <fd_lookup>
  801682:	89 c2                	mov    %eax,%edx
  801684:	85 d2                	test   %edx,%edx
  801686:	78 52                	js     8016da <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801688:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80168b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80168f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801692:	8b 00                	mov    (%eax),%eax
  801694:	89 04 24             	mov    %eax,(%esp)
  801697:	e8 70 fb ff ff       	call   80120c <dev_lookup>
  80169c:	85 c0                	test   %eax,%eax
  80169e:	78 3a                	js     8016da <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8016a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016a7:	74 2c                	je     8016d5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016a9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016ac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016b3:	00 00 00 
	stat->st_isdir = 0;
  8016b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016bd:	00 00 00 
	stat->st_dev = dev;
  8016c0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016cd:	89 14 24             	mov    %edx,(%esp)
  8016d0:	ff 50 14             	call   *0x14(%eax)
  8016d3:	eb 05                	jmp    8016da <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8016d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8016da:	83 c4 24             	add    $0x24,%esp
  8016dd:	5b                   	pop    %ebx
  8016de:	5d                   	pop    %ebp
  8016df:	c3                   	ret    

008016e0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	56                   	push   %esi
  8016e4:	53                   	push   %ebx
  8016e5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016ef:	00 
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	89 04 24             	mov    %eax,(%esp)
  8016f6:	e8 84 02 00 00       	call   80197f <open>
  8016fb:	89 c3                	mov    %eax,%ebx
  8016fd:	85 db                	test   %ebx,%ebx
  8016ff:	78 1b                	js     80171c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801701:	8b 45 0c             	mov    0xc(%ebp),%eax
  801704:	89 44 24 04          	mov    %eax,0x4(%esp)
  801708:	89 1c 24             	mov    %ebx,(%esp)
  80170b:	e8 56 ff ff ff       	call   801666 <fstat>
  801710:	89 c6                	mov    %eax,%esi
	close(fd);
  801712:	89 1c 24             	mov    %ebx,(%esp)
  801715:	e8 cd fb ff ff       	call   8012e7 <close>
	return r;
  80171a:	89 f0                	mov    %esi,%eax
}
  80171c:	83 c4 10             	add    $0x10,%esp
  80171f:	5b                   	pop    %ebx
  801720:	5e                   	pop    %esi
  801721:	5d                   	pop    %ebp
  801722:	c3                   	ret    

00801723 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	56                   	push   %esi
  801727:	53                   	push   %ebx
  801728:	83 ec 10             	sub    $0x10,%esp
  80172b:	89 c6                	mov    %eax,%esi
  80172d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80172f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801736:	75 11                	jne    801749 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801738:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80173f:	e8 11 0e 00 00       	call   802555 <ipc_find_env>
  801744:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801749:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801750:	00 
  801751:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801758:	00 
  801759:	89 74 24 04          	mov    %esi,0x4(%esp)
  80175d:	a1 00 40 80 00       	mov    0x804000,%eax
  801762:	89 04 24             	mov    %eax,(%esp)
  801765:	e8 5e 0d 00 00       	call   8024c8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80176a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801771:	00 
  801772:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801776:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80177d:	e8 de 0c 00 00       	call   802460 <ipc_recv>
}
  801782:	83 c4 10             	add    $0x10,%esp
  801785:	5b                   	pop    %ebx
  801786:	5e                   	pop    %esi
  801787:	5d                   	pop    %ebp
  801788:	c3                   	ret    

00801789 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	8b 40 0c             	mov    0xc(%eax),%eax
  801795:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80179a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8017a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8017ac:	e8 72 ff ff ff       	call   801723 <fsipc>
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bf:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8017c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ce:	e8 50 ff ff ff       	call   801723 <fsipc>
}
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	53                   	push   %ebx
  8017d9:	83 ec 14             	sub    $0x14,%esp
  8017dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8017f4:	e8 2a ff ff ff       	call   801723 <fsipc>
  8017f9:	89 c2                	mov    %eax,%edx
  8017fb:	85 d2                	test   %edx,%edx
  8017fd:	78 2b                	js     80182a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017ff:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801806:	00 
  801807:	89 1c 24             	mov    %ebx,(%esp)
  80180a:	e8 c8 f1 ff ff       	call   8009d7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80180f:	a1 80 50 80 00       	mov    0x805080,%eax
  801814:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80181a:	a1 84 50 80 00       	mov    0x805084,%eax
  80181f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801825:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182a:	83 c4 14             	add    $0x14,%esp
  80182d:	5b                   	pop    %ebx
  80182e:	5d                   	pop    %ebp
  80182f:	c3                   	ret    

00801830 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	53                   	push   %ebx
  801834:	83 ec 14             	sub    $0x14,%esp
  801837:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	8b 40 0c             	mov    0xc(%eax),%eax
  801840:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801845:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  80184b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801850:	0f 46 c3             	cmovbe %ebx,%eax
  801853:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801858:	89 44 24 08          	mov    %eax,0x8(%esp)
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801863:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  80186a:	e8 05 f3 ff ff       	call   800b74 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80186f:	ba 00 00 00 00       	mov    $0x0,%edx
  801874:	b8 04 00 00 00       	mov    $0x4,%eax
  801879:	e8 a5 fe ff ff       	call   801723 <fsipc>
  80187e:	85 c0                	test   %eax,%eax
  801880:	78 53                	js     8018d5 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801882:	39 c3                	cmp    %eax,%ebx
  801884:	73 24                	jae    8018aa <devfile_write+0x7a>
  801886:	c7 44 24 0c e8 2c 80 	movl   $0x802ce8,0xc(%esp)
  80188d:	00 
  80188e:	c7 44 24 08 ef 2c 80 	movl   $0x802cef,0x8(%esp)
  801895:	00 
  801896:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  80189d:	00 
  80189e:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  8018a5:	e8 05 ea ff ff       	call   8002af <_panic>
	assert(r <= PGSIZE);
  8018aa:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018af:	7e 24                	jle    8018d5 <devfile_write+0xa5>
  8018b1:	c7 44 24 0c 0f 2d 80 	movl   $0x802d0f,0xc(%esp)
  8018b8:	00 
  8018b9:	c7 44 24 08 ef 2c 80 	movl   $0x802cef,0x8(%esp)
  8018c0:	00 
  8018c1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  8018c8:	00 
  8018c9:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  8018d0:	e8 da e9 ff ff       	call   8002af <_panic>
	return r;
}
  8018d5:	83 c4 14             	add    $0x14,%esp
  8018d8:	5b                   	pop    %ebx
  8018d9:	5d                   	pop    %ebp
  8018da:	c3                   	ret    

008018db <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
  8018de:	56                   	push   %esi
  8018df:	53                   	push   %ebx
  8018e0:	83 ec 10             	sub    $0x10,%esp
  8018e3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ec:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8018f1:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fc:	b8 03 00 00 00       	mov    $0x3,%eax
  801901:	e8 1d fe ff ff       	call   801723 <fsipc>
  801906:	89 c3                	mov    %eax,%ebx
  801908:	85 c0                	test   %eax,%eax
  80190a:	78 6a                	js     801976 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  80190c:	39 c6                	cmp    %eax,%esi
  80190e:	73 24                	jae    801934 <devfile_read+0x59>
  801910:	c7 44 24 0c e8 2c 80 	movl   $0x802ce8,0xc(%esp)
  801917:	00 
  801918:	c7 44 24 08 ef 2c 80 	movl   $0x802cef,0x8(%esp)
  80191f:	00 
  801920:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801927:	00 
  801928:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  80192f:	e8 7b e9 ff ff       	call   8002af <_panic>
	assert(r <= PGSIZE);
  801934:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801939:	7e 24                	jle    80195f <devfile_read+0x84>
  80193b:	c7 44 24 0c 0f 2d 80 	movl   $0x802d0f,0xc(%esp)
  801942:	00 
  801943:	c7 44 24 08 ef 2c 80 	movl   $0x802cef,0x8(%esp)
  80194a:	00 
  80194b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801952:	00 
  801953:	c7 04 24 04 2d 80 00 	movl   $0x802d04,(%esp)
  80195a:	e8 50 e9 ff ff       	call   8002af <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80195f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801963:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80196a:	00 
  80196b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196e:	89 04 24             	mov    %eax,(%esp)
  801971:	e8 fe f1 ff ff       	call   800b74 <memmove>
	return r;
}
  801976:	89 d8                	mov    %ebx,%eax
  801978:	83 c4 10             	add    $0x10,%esp
  80197b:	5b                   	pop    %ebx
  80197c:	5e                   	pop    %esi
  80197d:	5d                   	pop    %ebp
  80197e:	c3                   	ret    

0080197f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	53                   	push   %ebx
  801983:	83 ec 24             	sub    $0x24,%esp
  801986:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801989:	89 1c 24             	mov    %ebx,(%esp)
  80198c:	e8 0f f0 ff ff       	call   8009a0 <strlen>
  801991:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801996:	7f 60                	jg     8019f8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801998:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80199b:	89 04 24             	mov    %eax,(%esp)
  80199e:	e8 c4 f7 ff ff       	call   801167 <fd_alloc>
  8019a3:	89 c2                	mov    %eax,%edx
  8019a5:	85 d2                	test   %edx,%edx
  8019a7:	78 54                	js     8019fd <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8019a9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019ad:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8019b4:	e8 1e f0 ff ff       	call   8009d7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8019b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bc:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8019c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8019c9:	e8 55 fd ff ff       	call   801723 <fsipc>
  8019ce:	89 c3                	mov    %eax,%ebx
  8019d0:	85 c0                	test   %eax,%eax
  8019d2:	79 17                	jns    8019eb <open+0x6c>
		fd_close(fd, 0);
  8019d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019db:	00 
  8019dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019df:	89 04 24             	mov    %eax,(%esp)
  8019e2:	e8 7f f8 ff ff       	call   801266 <fd_close>
		return r;
  8019e7:	89 d8                	mov    %ebx,%eax
  8019e9:	eb 12                	jmp    8019fd <open+0x7e>
	}

	return fd2num(fd);
  8019eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ee:	89 04 24             	mov    %eax,(%esp)
  8019f1:	e8 4a f7 ff ff       	call   801140 <fd2num>
  8019f6:	eb 05                	jmp    8019fd <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8019f8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8019fd:	83 c4 24             	add    $0x24,%esp
  801a00:	5b                   	pop    %ebx
  801a01:	5d                   	pop    %ebp
  801a02:	c3                   	ret    

00801a03 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a09:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0e:	b8 08 00 00 00       	mov    $0x8,%eax
  801a13:	e8 0b fd ff ff       	call   801723 <fsipc>
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    
  801a1a:	66 90                	xchg   %ax,%ax
  801a1c:	66 90                	xchg   %ax,%ax
  801a1e:	66 90                	xchg   %ax,%ax

00801a20 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801a26:	c7 44 24 04 1b 2d 80 	movl   $0x802d1b,0x4(%esp)
  801a2d:	00 
  801a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a31:	89 04 24             	mov    %eax,(%esp)
  801a34:	e8 9e ef ff ff       	call   8009d7 <strcpy>
	return 0;
}
  801a39:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	53                   	push   %ebx
  801a44:	83 ec 14             	sub    $0x14,%esp
  801a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801a4a:	89 1c 24             	mov    %ebx,(%esp)
  801a4d:	e8 3d 0b 00 00       	call   80258f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801a52:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801a57:	83 f8 01             	cmp    $0x1,%eax
  801a5a:	75 0d                	jne    801a69 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801a5c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801a5f:	89 04 24             	mov    %eax,(%esp)
  801a62:	e8 29 03 00 00       	call   801d90 <nsipc_close>
  801a67:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801a69:	89 d0                	mov    %edx,%eax
  801a6b:	83 c4 14             	add    $0x14,%esp
  801a6e:	5b                   	pop    %ebx
  801a6f:	5d                   	pop    %ebp
  801a70:	c3                   	ret    

00801a71 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a77:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a7e:	00 
  801a7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a82:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	8b 40 0c             	mov    0xc(%eax),%eax
  801a93:	89 04 24             	mov    %eax,(%esp)
  801a96:	e8 f0 03 00 00       	call   801e8b <nsipc_send>
}
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801aa3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801aaa:	00 
  801aab:	8b 45 10             	mov    0x10(%ebp),%eax
  801aae:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ab5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	8b 40 0c             	mov    0xc(%eax),%eax
  801abf:	89 04 24             	mov    %eax,(%esp)
  801ac2:	e8 44 03 00 00       	call   801e0b <nsipc_recv>
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801acf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ad2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ad6:	89 04 24             	mov    %eax,(%esp)
  801ad9:	e8 d8 f6 ff ff       	call   8011b6 <fd_lookup>
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	78 17                	js     801af9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801aeb:	39 08                	cmp    %ecx,(%eax)
  801aed:	75 05                	jne    801af4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801aef:	8b 40 0c             	mov    0xc(%eax),%eax
  801af2:	eb 05                	jmp    801af9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801af4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	56                   	push   %esi
  801aff:	53                   	push   %ebx
  801b00:	83 ec 20             	sub    $0x20,%esp
  801b03:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801b05:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b08:	89 04 24             	mov    %eax,(%esp)
  801b0b:	e8 57 f6 ff ff       	call   801167 <fd_alloc>
  801b10:	89 c3                	mov    %eax,%ebx
  801b12:	85 c0                	test   %eax,%eax
  801b14:	78 21                	js     801b37 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801b16:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b1d:	00 
  801b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b21:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b2c:	e8 c2 f2 ff ff       	call   800df3 <sys_page_alloc>
  801b31:	89 c3                	mov    %eax,%ebx
  801b33:	85 c0                	test   %eax,%eax
  801b35:	79 0c                	jns    801b43 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801b37:	89 34 24             	mov    %esi,(%esp)
  801b3a:	e8 51 02 00 00       	call   801d90 <nsipc_close>
		return r;
  801b3f:	89 d8                	mov    %ebx,%eax
  801b41:	eb 20                	jmp    801b63 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801b43:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801b4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b51:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801b58:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801b5b:	89 14 24             	mov    %edx,(%esp)
  801b5e:	e8 dd f5 ff ff       	call   801140 <fd2num>
}
  801b63:	83 c4 20             	add    $0x20,%esp
  801b66:	5b                   	pop    %ebx
  801b67:	5e                   	pop    %esi
  801b68:	5d                   	pop    %ebp
  801b69:	c3                   	ret    

00801b6a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	e8 51 ff ff ff       	call   801ac9 <fd2sockid>
		return r;
  801b78:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	78 23                	js     801ba1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b7e:	8b 55 10             	mov    0x10(%ebp),%edx
  801b81:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b88:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b8c:	89 04 24             	mov    %eax,(%esp)
  801b8f:	e8 45 01 00 00       	call   801cd9 <nsipc_accept>
		return r;
  801b94:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801b96:	85 c0                	test   %eax,%eax
  801b98:	78 07                	js     801ba1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801b9a:	e8 5c ff ff ff       	call   801afb <alloc_sockfd>
  801b9f:	89 c1                	mov    %eax,%ecx
}
  801ba1:	89 c8                	mov    %ecx,%eax
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	e8 16 ff ff ff       	call   801ac9 <fd2sockid>
  801bb3:	89 c2                	mov    %eax,%edx
  801bb5:	85 d2                	test   %edx,%edx
  801bb7:	78 16                	js     801bcf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801bb9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc7:	89 14 24             	mov    %edx,(%esp)
  801bca:	e8 60 01 00 00       	call   801d2f <nsipc_bind>
}
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <shutdown>:

int
shutdown(int s, int how)
{
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
  801bd4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	e8 ea fe ff ff       	call   801ac9 <fd2sockid>
  801bdf:	89 c2                	mov    %eax,%edx
  801be1:	85 d2                	test   %edx,%edx
  801be3:	78 0f                	js     801bf4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801be5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bec:	89 14 24             	mov    %edx,(%esp)
  801bef:	e8 7a 01 00 00       	call   801d6e <nsipc_shutdown>
}
  801bf4:	c9                   	leave  
  801bf5:	c3                   	ret    

00801bf6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bf6:	55                   	push   %ebp
  801bf7:	89 e5                	mov    %esp,%ebp
  801bf9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bff:	e8 c5 fe ff ff       	call   801ac9 <fd2sockid>
  801c04:	89 c2                	mov    %eax,%edx
  801c06:	85 d2                	test   %edx,%edx
  801c08:	78 16                	js     801c20 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801c0a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c18:	89 14 24             	mov    %edx,(%esp)
  801c1b:	e8 8a 01 00 00       	call   801daa <nsipc_connect>
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <listen>:

int
listen(int s, int backlog)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	e8 99 fe ff ff       	call   801ac9 <fd2sockid>
  801c30:	89 c2                	mov    %eax,%edx
  801c32:	85 d2                	test   %edx,%edx
  801c34:	78 0f                	js     801c45 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3d:	89 14 24             	mov    %edx,(%esp)
  801c40:	e8 a4 01 00 00       	call   801de9 <nsipc_listen>
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c50:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	89 04 24             	mov    %eax,(%esp)
  801c61:	e8 98 02 00 00       	call   801efe <nsipc_socket>
  801c66:	89 c2                	mov    %eax,%edx
  801c68:	85 d2                	test   %edx,%edx
  801c6a:	78 05                	js     801c71 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801c6c:	e8 8a fe ff ff       	call   801afb <alloc_sockfd>
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
  801c76:	53                   	push   %ebx
  801c77:	83 ec 14             	sub    $0x14,%esp
  801c7a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801c7c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801c83:	75 11                	jne    801c96 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801c85:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801c8c:	e8 c4 08 00 00       	call   802555 <ipc_find_env>
  801c91:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c96:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c9d:	00 
  801c9e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801ca5:	00 
  801ca6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801caa:	a1 04 40 80 00       	mov    0x804004,%eax
  801caf:	89 04 24             	mov    %eax,(%esp)
  801cb2:	e8 11 08 00 00       	call   8024c8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801cb7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cbe:	00 
  801cbf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cc6:	00 
  801cc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cce:	e8 8d 07 00 00       	call   802460 <ipc_recv>
}
  801cd3:	83 c4 14             	add    $0x14,%esp
  801cd6:	5b                   	pop    %ebx
  801cd7:	5d                   	pop    %ebp
  801cd8:	c3                   	ret    

00801cd9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	56                   	push   %esi
  801cdd:	53                   	push   %ebx
  801cde:	83 ec 10             	sub    $0x10,%esp
  801ce1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801cec:	8b 06                	mov    (%esi),%eax
  801cee:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801cf3:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf8:	e8 76 ff ff ff       	call   801c73 <nsipc>
  801cfd:	89 c3                	mov    %eax,%ebx
  801cff:	85 c0                	test   %eax,%eax
  801d01:	78 23                	js     801d26 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801d03:	a1 10 60 80 00       	mov    0x806010,%eax
  801d08:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d0c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d13:	00 
  801d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d17:	89 04 24             	mov    %eax,(%esp)
  801d1a:	e8 55 ee ff ff       	call   800b74 <memmove>
		*addrlen = ret->ret_addrlen;
  801d1f:	a1 10 60 80 00       	mov    0x806010,%eax
  801d24:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801d26:	89 d8                	mov    %ebx,%eax
  801d28:	83 c4 10             	add    $0x10,%esp
  801d2b:	5b                   	pop    %ebx
  801d2c:	5e                   	pop    %esi
  801d2d:	5d                   	pop    %ebp
  801d2e:	c3                   	ret    

00801d2f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	53                   	push   %ebx
  801d33:	83 ec 14             	sub    $0x14,%esp
  801d36:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801d41:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d4c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801d53:	e8 1c ee ff ff       	call   800b74 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801d58:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801d5e:	b8 02 00 00 00       	mov    $0x2,%eax
  801d63:	e8 0b ff ff ff       	call   801c73 <nsipc>
}
  801d68:	83 c4 14             	add    $0x14,%esp
  801d6b:	5b                   	pop    %ebx
  801d6c:	5d                   	pop    %ebp
  801d6d:	c3                   	ret    

00801d6e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
  801d71:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d7f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801d84:	b8 03 00 00 00       	mov    $0x3,%eax
  801d89:	e8 e5 fe ff ff       	call   801c73 <nsipc>
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <nsipc_close>:

int
nsipc_close(int s)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801d9e:	b8 04 00 00 00       	mov    $0x4,%eax
  801da3:	e8 cb fe ff ff       	call   801c73 <nsipc>
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	53                   	push   %ebx
  801dae:	83 ec 14             	sub    $0x14,%esp
  801db1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801dbc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801dce:	e8 a1 ed ff ff       	call   800b74 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801dd3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801dd9:	b8 05 00 00 00       	mov    $0x5,%eax
  801dde:	e8 90 fe ff ff       	call   801c73 <nsipc>
}
  801de3:	83 c4 14             	add    $0x14,%esp
  801de6:	5b                   	pop    %ebx
  801de7:	5d                   	pop    %ebp
  801de8:	c3                   	ret    

00801de9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801de9:	55                   	push   %ebp
  801dea:	89 e5                	mov    %esp,%ebp
  801dec:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801df7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dfa:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801dff:	b8 06 00 00 00       	mov    $0x6,%eax
  801e04:	e8 6a fe ff ff       	call   801c73 <nsipc>
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	56                   	push   %esi
  801e0f:	53                   	push   %ebx
  801e10:	83 ec 10             	sub    $0x10,%esp
  801e13:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801e16:	8b 45 08             	mov    0x8(%ebp),%eax
  801e19:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801e1e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801e24:	8b 45 14             	mov    0x14(%ebp),%eax
  801e27:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801e2c:	b8 07 00 00 00       	mov    $0x7,%eax
  801e31:	e8 3d fe ff ff       	call   801c73 <nsipc>
  801e36:	89 c3                	mov    %eax,%ebx
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	78 46                	js     801e82 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801e3c:	39 f0                	cmp    %esi,%eax
  801e3e:	7f 07                	jg     801e47 <nsipc_recv+0x3c>
  801e40:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801e45:	7e 24                	jle    801e6b <nsipc_recv+0x60>
  801e47:	c7 44 24 0c 27 2d 80 	movl   $0x802d27,0xc(%esp)
  801e4e:	00 
  801e4f:	c7 44 24 08 ef 2c 80 	movl   $0x802cef,0x8(%esp)
  801e56:	00 
  801e57:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801e5e:	00 
  801e5f:	c7 04 24 3c 2d 80 00 	movl   $0x802d3c,(%esp)
  801e66:	e8 44 e4 ff ff       	call   8002af <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801e6b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e6f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801e76:	00 
  801e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e7a:	89 04 24             	mov    %eax,(%esp)
  801e7d:	e8 f2 ec ff ff       	call   800b74 <memmove>
	}

	return r;
}
  801e82:	89 d8                	mov    %ebx,%eax
  801e84:	83 c4 10             	add    $0x10,%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5d                   	pop    %ebp
  801e8a:	c3                   	ret    

00801e8b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	53                   	push   %ebx
  801e8f:	83 ec 14             	sub    $0x14,%esp
  801e92:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801e9d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ea3:	7e 24                	jle    801ec9 <nsipc_send+0x3e>
  801ea5:	c7 44 24 0c 48 2d 80 	movl   $0x802d48,0xc(%esp)
  801eac:	00 
  801ead:	c7 44 24 08 ef 2c 80 	movl   $0x802cef,0x8(%esp)
  801eb4:	00 
  801eb5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801ebc:	00 
  801ebd:	c7 04 24 3c 2d 80 00 	movl   $0x802d3c,(%esp)
  801ec4:	e8 e6 e3 ff ff       	call   8002af <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801ec9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801edb:	e8 94 ec ff ff       	call   800b74 <memmove>
	nsipcbuf.send.req_size = size;
  801ee0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ee6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801eee:	b8 08 00 00 00       	mov    $0x8,%eax
  801ef3:	e8 7b fd ff ff       	call   801c73 <nsipc>
}
  801ef8:	83 c4 14             	add    $0x14,%esp
  801efb:	5b                   	pop    %ebx
  801efc:	5d                   	pop    %ebp
  801efd:	c3                   	ret    

00801efe <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801f14:	8b 45 10             	mov    0x10(%ebp),%eax
  801f17:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801f1c:	b8 09 00 00 00       	mov    $0x9,%eax
  801f21:	e8 4d fd ff ff       	call   801c73 <nsipc>
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	56                   	push   %esi
  801f2c:	53                   	push   %ebx
  801f2d:	83 ec 10             	sub    $0x10,%esp
  801f30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	89 04 24             	mov    %eax,(%esp)
  801f39:	e8 12 f2 ff ff       	call   801150 <fd2data>
  801f3e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801f40:	c7 44 24 04 54 2d 80 	movl   $0x802d54,0x4(%esp)
  801f47:	00 
  801f48:	89 1c 24             	mov    %ebx,(%esp)
  801f4b:	e8 87 ea ff ff       	call   8009d7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801f50:	8b 46 04             	mov    0x4(%esi),%eax
  801f53:	2b 06                	sub    (%esi),%eax
  801f55:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801f5b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801f62:	00 00 00 
	stat->st_dev = &devpipe;
  801f65:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801f6c:	30 80 00 
	return 0;
}
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	83 c4 10             	add    $0x10,%esp
  801f77:	5b                   	pop    %ebx
  801f78:	5e                   	pop    %esi
  801f79:	5d                   	pop    %ebp
  801f7a:	c3                   	ret    

00801f7b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	53                   	push   %ebx
  801f7f:	83 ec 14             	sub    $0x14,%esp
  801f82:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f85:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f90:	e8 05 ef ff ff       	call   800e9a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f95:	89 1c 24             	mov    %ebx,(%esp)
  801f98:	e8 b3 f1 ff ff       	call   801150 <fd2data>
  801f9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fa8:	e8 ed ee ff ff       	call   800e9a <sys_page_unmap>
}
  801fad:	83 c4 14             	add    $0x14,%esp
  801fb0:	5b                   	pop    %ebx
  801fb1:	5d                   	pop    %ebp
  801fb2:	c3                   	ret    

00801fb3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801fb3:	55                   	push   %ebp
  801fb4:	89 e5                	mov    %esp,%ebp
  801fb6:	57                   	push   %edi
  801fb7:	56                   	push   %esi
  801fb8:	53                   	push   %ebx
  801fb9:	83 ec 2c             	sub    $0x2c,%esp
  801fbc:	89 c6                	mov    %eax,%esi
  801fbe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801fc1:	a1 08 40 80 00       	mov    0x804008,%eax
  801fc6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801fc9:	89 34 24             	mov    %esi,(%esp)
  801fcc:	e8 be 05 00 00       	call   80258f <pageref>
  801fd1:	89 c7                	mov    %eax,%edi
  801fd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fd6:	89 04 24             	mov    %eax,(%esp)
  801fd9:	e8 b1 05 00 00       	call   80258f <pageref>
  801fde:	39 c7                	cmp    %eax,%edi
  801fe0:	0f 94 c2             	sete   %dl
  801fe3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801fe6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801fec:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801fef:	39 fb                	cmp    %edi,%ebx
  801ff1:	74 21                	je     802014 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801ff3:	84 d2                	test   %dl,%dl
  801ff5:	74 ca                	je     801fc1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ff7:	8b 51 58             	mov    0x58(%ecx),%edx
  801ffa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ffe:	89 54 24 08          	mov    %edx,0x8(%esp)
  802002:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802006:	c7 04 24 5b 2d 80 00 	movl   $0x802d5b,(%esp)
  80200d:	e8 96 e3 ff ff       	call   8003a8 <cprintf>
  802012:	eb ad                	jmp    801fc1 <_pipeisclosed+0xe>
	}
}
  802014:	83 c4 2c             	add    $0x2c,%esp
  802017:	5b                   	pop    %ebx
  802018:	5e                   	pop    %esi
  802019:	5f                   	pop    %edi
  80201a:	5d                   	pop    %ebp
  80201b:	c3                   	ret    

0080201c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
  80201f:	57                   	push   %edi
  802020:	56                   	push   %esi
  802021:	53                   	push   %ebx
  802022:	83 ec 1c             	sub    $0x1c,%esp
  802025:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802028:	89 34 24             	mov    %esi,(%esp)
  80202b:	e8 20 f1 ff ff       	call   801150 <fd2data>
  802030:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802032:	bf 00 00 00 00       	mov    $0x0,%edi
  802037:	eb 45                	jmp    80207e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802039:	89 da                	mov    %ebx,%edx
  80203b:	89 f0                	mov    %esi,%eax
  80203d:	e8 71 ff ff ff       	call   801fb3 <_pipeisclosed>
  802042:	85 c0                	test   %eax,%eax
  802044:	75 41                	jne    802087 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802046:	e8 89 ed ff ff       	call   800dd4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80204b:	8b 43 04             	mov    0x4(%ebx),%eax
  80204e:	8b 0b                	mov    (%ebx),%ecx
  802050:	8d 51 20             	lea    0x20(%ecx),%edx
  802053:	39 d0                	cmp    %edx,%eax
  802055:	73 e2                	jae    802039 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802057:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80205a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80205e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802061:	99                   	cltd   
  802062:	c1 ea 1b             	shr    $0x1b,%edx
  802065:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802068:	83 e1 1f             	and    $0x1f,%ecx
  80206b:	29 d1                	sub    %edx,%ecx
  80206d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802071:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802075:	83 c0 01             	add    $0x1,%eax
  802078:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80207b:	83 c7 01             	add    $0x1,%edi
  80207e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802081:	75 c8                	jne    80204b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802083:	89 f8                	mov    %edi,%eax
  802085:	eb 05                	jmp    80208c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802087:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80208c:	83 c4 1c             	add    $0x1c,%esp
  80208f:	5b                   	pop    %ebx
  802090:	5e                   	pop    %esi
  802091:	5f                   	pop    %edi
  802092:	5d                   	pop    %ebp
  802093:	c3                   	ret    

00802094 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	57                   	push   %edi
  802098:	56                   	push   %esi
  802099:	53                   	push   %ebx
  80209a:	83 ec 1c             	sub    $0x1c,%esp
  80209d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8020a0:	89 3c 24             	mov    %edi,(%esp)
  8020a3:	e8 a8 f0 ff ff       	call   801150 <fd2data>
  8020a8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020aa:	be 00 00 00 00       	mov    $0x0,%esi
  8020af:	eb 3d                	jmp    8020ee <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8020b1:	85 f6                	test   %esi,%esi
  8020b3:	74 04                	je     8020b9 <devpipe_read+0x25>
				return i;
  8020b5:	89 f0                	mov    %esi,%eax
  8020b7:	eb 43                	jmp    8020fc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8020b9:	89 da                	mov    %ebx,%edx
  8020bb:	89 f8                	mov    %edi,%eax
  8020bd:	e8 f1 fe ff ff       	call   801fb3 <_pipeisclosed>
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	75 31                	jne    8020f7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8020c6:	e8 09 ed ff ff       	call   800dd4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8020cb:	8b 03                	mov    (%ebx),%eax
  8020cd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020d0:	74 df                	je     8020b1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020d2:	99                   	cltd   
  8020d3:	c1 ea 1b             	shr    $0x1b,%edx
  8020d6:	01 d0                	add    %edx,%eax
  8020d8:	83 e0 1f             	and    $0x1f,%eax
  8020db:	29 d0                	sub    %edx,%eax
  8020dd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020e5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8020e8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020eb:	83 c6 01             	add    $0x1,%esi
  8020ee:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020f1:	75 d8                	jne    8020cb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8020f3:	89 f0                	mov    %esi,%eax
  8020f5:	eb 05                	jmp    8020fc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8020f7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8020fc:	83 c4 1c             	add    $0x1c,%esp
  8020ff:	5b                   	pop    %ebx
  802100:	5e                   	pop    %esi
  802101:	5f                   	pop    %edi
  802102:	5d                   	pop    %ebp
  802103:	c3                   	ret    

00802104 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	56                   	push   %esi
  802108:	53                   	push   %ebx
  802109:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80210c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80210f:	89 04 24             	mov    %eax,(%esp)
  802112:	e8 50 f0 ff ff       	call   801167 <fd_alloc>
  802117:	89 c2                	mov    %eax,%edx
  802119:	85 d2                	test   %edx,%edx
  80211b:	0f 88 4d 01 00 00    	js     80226e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802121:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802128:	00 
  802129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802130:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802137:	e8 b7 ec ff ff       	call   800df3 <sys_page_alloc>
  80213c:	89 c2                	mov    %eax,%edx
  80213e:	85 d2                	test   %edx,%edx
  802140:	0f 88 28 01 00 00    	js     80226e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802146:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802149:	89 04 24             	mov    %eax,(%esp)
  80214c:	e8 16 f0 ff ff       	call   801167 <fd_alloc>
  802151:	89 c3                	mov    %eax,%ebx
  802153:	85 c0                	test   %eax,%eax
  802155:	0f 88 fe 00 00 00    	js     802259 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80215b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802162:	00 
  802163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802166:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802171:	e8 7d ec ff ff       	call   800df3 <sys_page_alloc>
  802176:	89 c3                	mov    %eax,%ebx
  802178:	85 c0                	test   %eax,%eax
  80217a:	0f 88 d9 00 00 00    	js     802259 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	89 04 24             	mov    %eax,(%esp)
  802186:	e8 c5 ef ff ff       	call   801150 <fd2data>
  80218b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80218d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802194:	00 
  802195:	89 44 24 04          	mov    %eax,0x4(%esp)
  802199:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a0:	e8 4e ec ff ff       	call   800df3 <sys_page_alloc>
  8021a5:	89 c3                	mov    %eax,%ebx
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	0f 88 97 00 00 00    	js     802246 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b2:	89 04 24             	mov    %eax,(%esp)
  8021b5:	e8 96 ef ff ff       	call   801150 <fd2data>
  8021ba:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8021c1:	00 
  8021c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021cd:	00 
  8021ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d9:	e8 69 ec ff ff       	call   800e47 <sys_page_map>
  8021de:	89 c3                	mov    %eax,%ebx
  8021e0:	85 c0                	test   %eax,%eax
  8021e2:	78 52                	js     802236 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8021e4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8021ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8021f9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8021ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802202:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802204:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802207:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80220e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802211:	89 04 24             	mov    %eax,(%esp)
  802214:	e8 27 ef ff ff       	call   801140 <fd2num>
  802219:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80221c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80221e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802221:	89 04 24             	mov    %eax,(%esp)
  802224:	e8 17 ef ff ff       	call   801140 <fd2num>
  802229:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80222c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80222f:	b8 00 00 00 00       	mov    $0x0,%eax
  802234:	eb 38                	jmp    80226e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802236:	89 74 24 04          	mov    %esi,0x4(%esp)
  80223a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802241:	e8 54 ec ff ff       	call   800e9a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802249:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802254:	e8 41 ec ff ff       	call   800e9a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802260:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802267:	e8 2e ec ff ff       	call   800e9a <sys_page_unmap>
  80226c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80226e:	83 c4 30             	add    $0x30,%esp
  802271:	5b                   	pop    %ebx
  802272:	5e                   	pop    %esi
  802273:	5d                   	pop    %ebp
  802274:	c3                   	ret    

00802275 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80227b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80227e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	89 04 24             	mov    %eax,(%esp)
  802288:	e8 29 ef ff ff       	call   8011b6 <fd_lookup>
  80228d:	89 c2                	mov    %eax,%edx
  80228f:	85 d2                	test   %edx,%edx
  802291:	78 15                	js     8022a8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802296:	89 04 24             	mov    %eax,(%esp)
  802299:	e8 b2 ee ff ff       	call   801150 <fd2data>
	return _pipeisclosed(fd, p);
  80229e:	89 c2                	mov    %eax,%edx
  8022a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a3:	e8 0b fd ff ff       	call   801fb3 <_pipeisclosed>
}
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    
  8022aa:	66 90                	xchg   %ax,%ax
  8022ac:	66 90                	xchg   %ax,%ax
  8022ae:	66 90                	xchg   %ax,%ax

008022b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8022b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b8:	5d                   	pop    %ebp
  8022b9:	c3                   	ret    

008022ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8022c0:	c7 44 24 04 73 2d 80 	movl   $0x802d73,0x4(%esp)
  8022c7:	00 
  8022c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cb:	89 04 24             	mov    %eax,(%esp)
  8022ce:	e8 04 e7 ff ff       	call   8009d7 <strcpy>
	return 0;
}
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	57                   	push   %edi
  8022de:	56                   	push   %esi
  8022df:	53                   	push   %ebx
  8022e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022e6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022eb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022f1:	eb 31                	jmp    802324 <devcons_write+0x4a>
		m = n - tot;
  8022f3:	8b 75 10             	mov    0x10(%ebp),%esi
  8022f6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8022f8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8022fb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802300:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802303:	89 74 24 08          	mov    %esi,0x8(%esp)
  802307:	03 45 0c             	add    0xc(%ebp),%eax
  80230a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80230e:	89 3c 24             	mov    %edi,(%esp)
  802311:	e8 5e e8 ff ff       	call   800b74 <memmove>
		sys_cputs(buf, m);
  802316:	89 74 24 04          	mov    %esi,0x4(%esp)
  80231a:	89 3c 24             	mov    %edi,(%esp)
  80231d:	e8 04 ea ff ff       	call   800d26 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802322:	01 f3                	add    %esi,%ebx
  802324:	89 d8                	mov    %ebx,%eax
  802326:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802329:	72 c8                	jb     8022f3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80232b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802331:	5b                   	pop    %ebx
  802332:	5e                   	pop    %esi
  802333:	5f                   	pop    %edi
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    

00802336 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802336:	55                   	push   %ebp
  802337:	89 e5                	mov    %esp,%ebp
  802339:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80233c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802341:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802345:	75 07                	jne    80234e <devcons_read+0x18>
  802347:	eb 2a                	jmp    802373 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802349:	e8 86 ea ff ff       	call   800dd4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80234e:	66 90                	xchg   %ax,%ax
  802350:	e8 ef e9 ff ff       	call   800d44 <sys_cgetc>
  802355:	85 c0                	test   %eax,%eax
  802357:	74 f0                	je     802349 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802359:	85 c0                	test   %eax,%eax
  80235b:	78 16                	js     802373 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80235d:	83 f8 04             	cmp    $0x4,%eax
  802360:	74 0c                	je     80236e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802362:	8b 55 0c             	mov    0xc(%ebp),%edx
  802365:	88 02                	mov    %al,(%edx)
	return 1;
  802367:	b8 01 00 00 00       	mov    $0x1,%eax
  80236c:	eb 05                	jmp    802373 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80236e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
  802378:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802381:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802388:	00 
  802389:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80238c:	89 04 24             	mov    %eax,(%esp)
  80238f:	e8 92 e9 ff ff       	call   800d26 <sys_cputs>
}
  802394:	c9                   	leave  
  802395:	c3                   	ret    

00802396 <getchar>:

int
getchar(void)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80239c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8023a3:	00 
  8023a4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8023a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023b2:	e8 93 f0 ff ff       	call   80144a <read>
	if (r < 0)
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	78 0f                	js     8023ca <getchar+0x34>
		return r;
	if (r < 1)
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	7e 06                	jle    8023c5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8023bf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8023c3:	eb 05                	jmp    8023ca <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8023c5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
  8023cf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dc:	89 04 24             	mov    %eax,(%esp)
  8023df:	e8 d2 ed ff ff       	call   8011b6 <fd_lookup>
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	78 11                	js     8023f9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8023e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023eb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8023f1:	39 10                	cmp    %edx,(%eax)
  8023f3:	0f 94 c0             	sete   %al
  8023f6:	0f b6 c0             	movzbl %al,%eax
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <opencons>:

int
opencons(void)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
  8023fe:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802401:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802404:	89 04 24             	mov    %eax,(%esp)
  802407:	e8 5b ed ff ff       	call   801167 <fd_alloc>
		return r;
  80240c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80240e:	85 c0                	test   %eax,%eax
  802410:	78 40                	js     802452 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802412:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802419:	00 
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802421:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802428:	e8 c6 e9 ff ff       	call   800df3 <sys_page_alloc>
		return r;
  80242d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80242f:	85 c0                	test   %eax,%eax
  802431:	78 1f                	js     802452 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802433:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802448:	89 04 24             	mov    %eax,(%esp)
  80244b:	e8 f0 ec ff ff       	call   801140 <fd2num>
  802450:	89 c2                	mov    %eax,%edx
}
  802452:	89 d0                	mov    %edx,%eax
  802454:	c9                   	leave  
  802455:	c3                   	ret    
  802456:	66 90                	xchg   %ax,%ax
  802458:	66 90                	xchg   %ax,%ax
  80245a:	66 90                	xchg   %ax,%ax
  80245c:	66 90                	xchg   %ax,%ax
  80245e:	66 90                	xchg   %ax,%ax

00802460 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	56                   	push   %esi
  802464:	53                   	push   %ebx
  802465:	83 ec 10             	sub    $0x10,%esp
  802468:	8b 75 08             	mov    0x8(%ebp),%esi
  80246b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80246e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802471:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802473:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802478:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80247b:	89 04 24             	mov    %eax,(%esp)
  80247e:	e8 86 eb ff ff       	call   801009 <sys_ipc_recv>
  802483:	85 c0                	test   %eax,%eax
  802485:	74 16                	je     80249d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802487:	85 f6                	test   %esi,%esi
  802489:	74 06                	je     802491 <ipc_recv+0x31>
			*from_env_store = 0;
  80248b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802491:	85 db                	test   %ebx,%ebx
  802493:	74 2c                	je     8024c1 <ipc_recv+0x61>
			*perm_store = 0;
  802495:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80249b:	eb 24                	jmp    8024c1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80249d:	85 f6                	test   %esi,%esi
  80249f:	74 0a                	je     8024ab <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8024a1:	a1 08 40 80 00       	mov    0x804008,%eax
  8024a6:	8b 40 74             	mov    0x74(%eax),%eax
  8024a9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8024ab:	85 db                	test   %ebx,%ebx
  8024ad:	74 0a                	je     8024b9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8024af:	a1 08 40 80 00       	mov    0x804008,%eax
  8024b4:	8b 40 78             	mov    0x78(%eax),%eax
  8024b7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8024b9:	a1 08 40 80 00       	mov    0x804008,%eax
  8024be:	8b 40 70             	mov    0x70(%eax),%eax
}
  8024c1:	83 c4 10             	add    $0x10,%esp
  8024c4:	5b                   	pop    %ebx
  8024c5:	5e                   	pop    %esi
  8024c6:	5d                   	pop    %ebp
  8024c7:	c3                   	ret    

008024c8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
  8024cb:	57                   	push   %edi
  8024cc:	56                   	push   %esi
  8024cd:	53                   	push   %ebx
  8024ce:	83 ec 1c             	sub    $0x1c,%esp
  8024d1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8024d7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8024da:	85 db                	test   %ebx,%ebx
  8024dc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8024e1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8024e4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024e8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f3:	89 04 24             	mov    %eax,(%esp)
  8024f6:	e8 eb ea ff ff       	call   800fe6 <sys_ipc_try_send>
	if (r == 0) return;
  8024fb:	85 c0                	test   %eax,%eax
  8024fd:	75 22                	jne    802521 <ipc_send+0x59>
  8024ff:	eb 4c                	jmp    80254d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802501:	84 d2                	test   %dl,%dl
  802503:	75 48                	jne    80254d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802505:	e8 ca e8 ff ff       	call   800dd4 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80250a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80250e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802512:	89 74 24 04          	mov    %esi,0x4(%esp)
  802516:	8b 45 08             	mov    0x8(%ebp),%eax
  802519:	89 04 24             	mov    %eax,(%esp)
  80251c:	e8 c5 ea ff ff       	call   800fe6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802521:	85 c0                	test   %eax,%eax
  802523:	0f 94 c2             	sete   %dl
  802526:	74 d9                	je     802501 <ipc_send+0x39>
  802528:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80252b:	74 d4                	je     802501 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80252d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802531:	c7 44 24 08 7f 2d 80 	movl   $0x802d7f,0x8(%esp)
  802538:	00 
  802539:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802540:	00 
  802541:	c7 04 24 8d 2d 80 00 	movl   $0x802d8d,(%esp)
  802548:	e8 62 dd ff ff       	call   8002af <_panic>
}
  80254d:	83 c4 1c             	add    $0x1c,%esp
  802550:	5b                   	pop    %ebx
  802551:	5e                   	pop    %esi
  802552:	5f                   	pop    %edi
  802553:	5d                   	pop    %ebp
  802554:	c3                   	ret    

00802555 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802555:	55                   	push   %ebp
  802556:	89 e5                	mov    %esp,%ebp
  802558:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80255b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802560:	89 c2                	mov    %eax,%edx
  802562:	c1 e2 07             	shl    $0x7,%edx
  802565:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80256b:	8b 52 50             	mov    0x50(%edx),%edx
  80256e:	39 ca                	cmp    %ecx,%edx
  802570:	75 0d                	jne    80257f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802572:	c1 e0 07             	shl    $0x7,%eax
  802575:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80257a:	8b 40 40             	mov    0x40(%eax),%eax
  80257d:	eb 0e                	jmp    80258d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80257f:	83 c0 01             	add    $0x1,%eax
  802582:	3d 00 04 00 00       	cmp    $0x400,%eax
  802587:	75 d7                	jne    802560 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802589:	66 b8 00 00          	mov    $0x0,%ax
}
  80258d:	5d                   	pop    %ebp
  80258e:	c3                   	ret    

0080258f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
  802592:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802595:	89 d0                	mov    %edx,%eax
  802597:	c1 e8 16             	shr    $0x16,%eax
  80259a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8025a1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8025a6:	f6 c1 01             	test   $0x1,%cl
  8025a9:	74 1d                	je     8025c8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8025ab:	c1 ea 0c             	shr    $0xc,%edx
  8025ae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8025b5:	f6 c2 01             	test   $0x1,%dl
  8025b8:	74 0e                	je     8025c8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8025ba:	c1 ea 0c             	shr    $0xc,%edx
  8025bd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8025c4:	ef 
  8025c5:	0f b7 c0             	movzwl %ax,%eax
}
  8025c8:	5d                   	pop    %ebp
  8025c9:	c3                   	ret    
  8025ca:	66 90                	xchg   %ax,%ax
  8025cc:	66 90                	xchg   %ax,%ax
  8025ce:	66 90                	xchg   %ax,%ax

008025d0 <__udivdi3>:
  8025d0:	55                   	push   %ebp
  8025d1:	57                   	push   %edi
  8025d2:	56                   	push   %esi
  8025d3:	83 ec 0c             	sub    $0xc,%esp
  8025d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8025da:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8025de:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8025e2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025e6:	85 c0                	test   %eax,%eax
  8025e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8025ec:	89 ea                	mov    %ebp,%edx
  8025ee:	89 0c 24             	mov    %ecx,(%esp)
  8025f1:	75 2d                	jne    802620 <__udivdi3+0x50>
  8025f3:	39 e9                	cmp    %ebp,%ecx
  8025f5:	77 61                	ja     802658 <__udivdi3+0x88>
  8025f7:	85 c9                	test   %ecx,%ecx
  8025f9:	89 ce                	mov    %ecx,%esi
  8025fb:	75 0b                	jne    802608 <__udivdi3+0x38>
  8025fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802602:	31 d2                	xor    %edx,%edx
  802604:	f7 f1                	div    %ecx
  802606:	89 c6                	mov    %eax,%esi
  802608:	31 d2                	xor    %edx,%edx
  80260a:	89 e8                	mov    %ebp,%eax
  80260c:	f7 f6                	div    %esi
  80260e:	89 c5                	mov    %eax,%ebp
  802610:	89 f8                	mov    %edi,%eax
  802612:	f7 f6                	div    %esi
  802614:	89 ea                	mov    %ebp,%edx
  802616:	83 c4 0c             	add    $0xc,%esp
  802619:	5e                   	pop    %esi
  80261a:	5f                   	pop    %edi
  80261b:	5d                   	pop    %ebp
  80261c:	c3                   	ret    
  80261d:	8d 76 00             	lea    0x0(%esi),%esi
  802620:	39 e8                	cmp    %ebp,%eax
  802622:	77 24                	ja     802648 <__udivdi3+0x78>
  802624:	0f bd e8             	bsr    %eax,%ebp
  802627:	83 f5 1f             	xor    $0x1f,%ebp
  80262a:	75 3c                	jne    802668 <__udivdi3+0x98>
  80262c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802630:	39 34 24             	cmp    %esi,(%esp)
  802633:	0f 86 9f 00 00 00    	jbe    8026d8 <__udivdi3+0x108>
  802639:	39 d0                	cmp    %edx,%eax
  80263b:	0f 82 97 00 00 00    	jb     8026d8 <__udivdi3+0x108>
  802641:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802648:	31 d2                	xor    %edx,%edx
  80264a:	31 c0                	xor    %eax,%eax
  80264c:	83 c4 0c             	add    $0xc,%esp
  80264f:	5e                   	pop    %esi
  802650:	5f                   	pop    %edi
  802651:	5d                   	pop    %ebp
  802652:	c3                   	ret    
  802653:	90                   	nop
  802654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802658:	89 f8                	mov    %edi,%eax
  80265a:	f7 f1                	div    %ecx
  80265c:	31 d2                	xor    %edx,%edx
  80265e:	83 c4 0c             	add    $0xc,%esp
  802661:	5e                   	pop    %esi
  802662:	5f                   	pop    %edi
  802663:	5d                   	pop    %ebp
  802664:	c3                   	ret    
  802665:	8d 76 00             	lea    0x0(%esi),%esi
  802668:	89 e9                	mov    %ebp,%ecx
  80266a:	8b 3c 24             	mov    (%esp),%edi
  80266d:	d3 e0                	shl    %cl,%eax
  80266f:	89 c6                	mov    %eax,%esi
  802671:	b8 20 00 00 00       	mov    $0x20,%eax
  802676:	29 e8                	sub    %ebp,%eax
  802678:	89 c1                	mov    %eax,%ecx
  80267a:	d3 ef                	shr    %cl,%edi
  80267c:	89 e9                	mov    %ebp,%ecx
  80267e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802682:	8b 3c 24             	mov    (%esp),%edi
  802685:	09 74 24 08          	or     %esi,0x8(%esp)
  802689:	89 d6                	mov    %edx,%esi
  80268b:	d3 e7                	shl    %cl,%edi
  80268d:	89 c1                	mov    %eax,%ecx
  80268f:	89 3c 24             	mov    %edi,(%esp)
  802692:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802696:	d3 ee                	shr    %cl,%esi
  802698:	89 e9                	mov    %ebp,%ecx
  80269a:	d3 e2                	shl    %cl,%edx
  80269c:	89 c1                	mov    %eax,%ecx
  80269e:	d3 ef                	shr    %cl,%edi
  8026a0:	09 d7                	or     %edx,%edi
  8026a2:	89 f2                	mov    %esi,%edx
  8026a4:	89 f8                	mov    %edi,%eax
  8026a6:	f7 74 24 08          	divl   0x8(%esp)
  8026aa:	89 d6                	mov    %edx,%esi
  8026ac:	89 c7                	mov    %eax,%edi
  8026ae:	f7 24 24             	mull   (%esp)
  8026b1:	39 d6                	cmp    %edx,%esi
  8026b3:	89 14 24             	mov    %edx,(%esp)
  8026b6:	72 30                	jb     8026e8 <__udivdi3+0x118>
  8026b8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026bc:	89 e9                	mov    %ebp,%ecx
  8026be:	d3 e2                	shl    %cl,%edx
  8026c0:	39 c2                	cmp    %eax,%edx
  8026c2:	73 05                	jae    8026c9 <__udivdi3+0xf9>
  8026c4:	3b 34 24             	cmp    (%esp),%esi
  8026c7:	74 1f                	je     8026e8 <__udivdi3+0x118>
  8026c9:	89 f8                	mov    %edi,%eax
  8026cb:	31 d2                	xor    %edx,%edx
  8026cd:	e9 7a ff ff ff       	jmp    80264c <__udivdi3+0x7c>
  8026d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026d8:	31 d2                	xor    %edx,%edx
  8026da:	b8 01 00 00 00       	mov    $0x1,%eax
  8026df:	e9 68 ff ff ff       	jmp    80264c <__udivdi3+0x7c>
  8026e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026e8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8026eb:	31 d2                	xor    %edx,%edx
  8026ed:	83 c4 0c             	add    $0xc,%esp
  8026f0:	5e                   	pop    %esi
  8026f1:	5f                   	pop    %edi
  8026f2:	5d                   	pop    %ebp
  8026f3:	c3                   	ret    
  8026f4:	66 90                	xchg   %ax,%ax
  8026f6:	66 90                	xchg   %ax,%ax
  8026f8:	66 90                	xchg   %ax,%ax
  8026fa:	66 90                	xchg   %ax,%ax
  8026fc:	66 90                	xchg   %ax,%ax
  8026fe:	66 90                	xchg   %ax,%ax

00802700 <__umoddi3>:
  802700:	55                   	push   %ebp
  802701:	57                   	push   %edi
  802702:	56                   	push   %esi
  802703:	83 ec 14             	sub    $0x14,%esp
  802706:	8b 44 24 28          	mov    0x28(%esp),%eax
  80270a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80270e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802712:	89 c7                	mov    %eax,%edi
  802714:	89 44 24 04          	mov    %eax,0x4(%esp)
  802718:	8b 44 24 30          	mov    0x30(%esp),%eax
  80271c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802720:	89 34 24             	mov    %esi,(%esp)
  802723:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802727:	85 c0                	test   %eax,%eax
  802729:	89 c2                	mov    %eax,%edx
  80272b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80272f:	75 17                	jne    802748 <__umoddi3+0x48>
  802731:	39 fe                	cmp    %edi,%esi
  802733:	76 4b                	jbe    802780 <__umoddi3+0x80>
  802735:	89 c8                	mov    %ecx,%eax
  802737:	89 fa                	mov    %edi,%edx
  802739:	f7 f6                	div    %esi
  80273b:	89 d0                	mov    %edx,%eax
  80273d:	31 d2                	xor    %edx,%edx
  80273f:	83 c4 14             	add    $0x14,%esp
  802742:	5e                   	pop    %esi
  802743:	5f                   	pop    %edi
  802744:	5d                   	pop    %ebp
  802745:	c3                   	ret    
  802746:	66 90                	xchg   %ax,%ax
  802748:	39 f8                	cmp    %edi,%eax
  80274a:	77 54                	ja     8027a0 <__umoddi3+0xa0>
  80274c:	0f bd e8             	bsr    %eax,%ebp
  80274f:	83 f5 1f             	xor    $0x1f,%ebp
  802752:	75 5c                	jne    8027b0 <__umoddi3+0xb0>
  802754:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802758:	39 3c 24             	cmp    %edi,(%esp)
  80275b:	0f 87 e7 00 00 00    	ja     802848 <__umoddi3+0x148>
  802761:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802765:	29 f1                	sub    %esi,%ecx
  802767:	19 c7                	sbb    %eax,%edi
  802769:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80276d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802771:	8b 44 24 08          	mov    0x8(%esp),%eax
  802775:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802779:	83 c4 14             	add    $0x14,%esp
  80277c:	5e                   	pop    %esi
  80277d:	5f                   	pop    %edi
  80277e:	5d                   	pop    %ebp
  80277f:	c3                   	ret    
  802780:	85 f6                	test   %esi,%esi
  802782:	89 f5                	mov    %esi,%ebp
  802784:	75 0b                	jne    802791 <__umoddi3+0x91>
  802786:	b8 01 00 00 00       	mov    $0x1,%eax
  80278b:	31 d2                	xor    %edx,%edx
  80278d:	f7 f6                	div    %esi
  80278f:	89 c5                	mov    %eax,%ebp
  802791:	8b 44 24 04          	mov    0x4(%esp),%eax
  802795:	31 d2                	xor    %edx,%edx
  802797:	f7 f5                	div    %ebp
  802799:	89 c8                	mov    %ecx,%eax
  80279b:	f7 f5                	div    %ebp
  80279d:	eb 9c                	jmp    80273b <__umoddi3+0x3b>
  80279f:	90                   	nop
  8027a0:	89 c8                	mov    %ecx,%eax
  8027a2:	89 fa                	mov    %edi,%edx
  8027a4:	83 c4 14             	add    $0x14,%esp
  8027a7:	5e                   	pop    %esi
  8027a8:	5f                   	pop    %edi
  8027a9:	5d                   	pop    %ebp
  8027aa:	c3                   	ret    
  8027ab:	90                   	nop
  8027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027b0:	8b 04 24             	mov    (%esp),%eax
  8027b3:	be 20 00 00 00       	mov    $0x20,%esi
  8027b8:	89 e9                	mov    %ebp,%ecx
  8027ba:	29 ee                	sub    %ebp,%esi
  8027bc:	d3 e2                	shl    %cl,%edx
  8027be:	89 f1                	mov    %esi,%ecx
  8027c0:	d3 e8                	shr    %cl,%eax
  8027c2:	89 e9                	mov    %ebp,%ecx
  8027c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c8:	8b 04 24             	mov    (%esp),%eax
  8027cb:	09 54 24 04          	or     %edx,0x4(%esp)
  8027cf:	89 fa                	mov    %edi,%edx
  8027d1:	d3 e0                	shl    %cl,%eax
  8027d3:	89 f1                	mov    %esi,%ecx
  8027d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027d9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8027dd:	d3 ea                	shr    %cl,%edx
  8027df:	89 e9                	mov    %ebp,%ecx
  8027e1:	d3 e7                	shl    %cl,%edi
  8027e3:	89 f1                	mov    %esi,%ecx
  8027e5:	d3 e8                	shr    %cl,%eax
  8027e7:	89 e9                	mov    %ebp,%ecx
  8027e9:	09 f8                	or     %edi,%eax
  8027eb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8027ef:	f7 74 24 04          	divl   0x4(%esp)
  8027f3:	d3 e7                	shl    %cl,%edi
  8027f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027f9:	89 d7                	mov    %edx,%edi
  8027fb:	f7 64 24 08          	mull   0x8(%esp)
  8027ff:	39 d7                	cmp    %edx,%edi
  802801:	89 c1                	mov    %eax,%ecx
  802803:	89 14 24             	mov    %edx,(%esp)
  802806:	72 2c                	jb     802834 <__umoddi3+0x134>
  802808:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80280c:	72 22                	jb     802830 <__umoddi3+0x130>
  80280e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802812:	29 c8                	sub    %ecx,%eax
  802814:	19 d7                	sbb    %edx,%edi
  802816:	89 e9                	mov    %ebp,%ecx
  802818:	89 fa                	mov    %edi,%edx
  80281a:	d3 e8                	shr    %cl,%eax
  80281c:	89 f1                	mov    %esi,%ecx
  80281e:	d3 e2                	shl    %cl,%edx
  802820:	89 e9                	mov    %ebp,%ecx
  802822:	d3 ef                	shr    %cl,%edi
  802824:	09 d0                	or     %edx,%eax
  802826:	89 fa                	mov    %edi,%edx
  802828:	83 c4 14             	add    $0x14,%esp
  80282b:	5e                   	pop    %esi
  80282c:	5f                   	pop    %edi
  80282d:	5d                   	pop    %ebp
  80282e:	c3                   	ret    
  80282f:	90                   	nop
  802830:	39 d7                	cmp    %edx,%edi
  802832:	75 da                	jne    80280e <__umoddi3+0x10e>
  802834:	8b 14 24             	mov    (%esp),%edx
  802837:	89 c1                	mov    %eax,%ecx
  802839:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80283d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802841:	eb cb                	jmp    80280e <__umoddi3+0x10e>
  802843:	90                   	nop
  802844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802848:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80284c:	0f 82 0f ff ff ff    	jb     802761 <__umoddi3+0x61>
  802852:	e9 1a ff ff ff       	jmp    802771 <__umoddi3+0x71>
