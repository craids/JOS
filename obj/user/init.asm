
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 d5 03 00 00       	call   800406 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	8b 75 08             	mov    0x8(%ebp),%esi
  800048:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80004b:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800050:	ba 00 00 00 00       	mov    $0x0,%edx
  800055:	eb 0c                	jmp    800063 <sum+0x23>
		tot ^= i * s[i];
  800057:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  80005b:	0f af ca             	imul   %edx,%ecx
  80005e:	31 c8                	xor    %ecx,%eax

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  800060:	83 c2 01             	add    $0x1,%edx
  800063:	39 da                	cmp    %ebx,%edx
  800065:	7c f0                	jl     800057 <sum+0x17>
		tot ^= i * s[i];
	return tot;
}
  800067:	5b                   	pop    %ebx
  800068:	5e                   	pop    %esi
  800069:	5d                   	pop    %ebp
  80006a:	c3                   	ret    

0080006b <umain>:

void
umain(int argc, char **argv)
{
  80006b:	55                   	push   %ebp
  80006c:	89 e5                	mov    %esp,%ebp
  80006e:	57                   	push   %edi
  80006f:	56                   	push   %esi
  800070:	53                   	push   %ebx
  800071:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  800077:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80007a:	c7 04 24 c0 32 80 00 	movl   $0x8032c0,(%esp)
  800081:	e8 da 04 00 00       	call   800560 <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800086:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  80008d:	00 
  80008e:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  800095:	e8 a6 ff ff ff       	call   800040 <sum>
  80009a:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  80009f:	74 1a                	je     8000bb <umain+0x50>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000a1:	c7 44 24 08 9e 98 0f 	movl   $0xf989e,0x8(%esp)
  8000a8:	00 
  8000a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ad:	c7 04 24 88 33 80 00 	movl   $0x803388,(%esp)
  8000b4:	e8 a7 04 00 00       	call   800560 <cprintf>
  8000b9:	eb 0c                	jmp    8000c7 <umain+0x5c>
			x, want);
	else
		cprintf("init: data seems okay\n");
  8000bb:	c7 04 24 cf 32 80 00 	movl   $0x8032cf,(%esp)
  8000c2:	e8 99 04 00 00       	call   800560 <cprintf>
	if ((x = sum(bss, sizeof bss)) != 0)
  8000c7:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  8000ce:	00 
  8000cf:	c7 04 24 20 60 80 00 	movl   $0x806020,(%esp)
  8000d6:	e8 65 ff ff ff       	call   800040 <sum>
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	74 12                	je     8000f1 <umain+0x86>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e3:	c7 04 24 c4 33 80 00 	movl   $0x8033c4,(%esp)
  8000ea:	e8 71 04 00 00       	call   800560 <cprintf>
  8000ef:	eb 0c                	jmp    8000fd <umain+0x92>
	else
		cprintf("init: bss seems okay\n");
  8000f1:	c7 04 24 e6 32 80 00 	movl   $0x8032e6,(%esp)
  8000f8:	e8 63 04 00 00       	call   800560 <cprintf>

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000fd:	c7 44 24 04 fc 32 80 	movl   $0x8032fc,0x4(%esp)
  800104:	00 
  800105:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80010b:	89 04 24             	mov    %eax,(%esp)
  80010e:	e8 94 0a 00 00       	call   800ba7 <strcat>
	for (i = 0; i < argc; i++) {
  800113:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  800118:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80011e:	eb 32                	jmp    800152 <umain+0xe7>
		strcat(args, " '");
  800120:	c7 44 24 04 08 33 80 	movl   $0x803308,0x4(%esp)
  800127:	00 
  800128:	89 34 24             	mov    %esi,(%esp)
  80012b:	e8 77 0a 00 00       	call   800ba7 <strcat>
		strcat(args, argv[i]);
  800130:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  800133:	89 44 24 04          	mov    %eax,0x4(%esp)
  800137:	89 34 24             	mov    %esi,(%esp)
  80013a:	e8 68 0a 00 00       	call   800ba7 <strcat>
		strcat(args, "'");
  80013f:	c7 44 24 04 09 33 80 	movl   $0x803309,0x4(%esp)
  800146:	00 
  800147:	89 34 24             	mov    %esi,(%esp)
  80014a:	e8 58 0a 00 00       	call   800ba7 <strcat>
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
	for (i = 0; i < argc; i++) {
  80014f:	83 c3 01             	add    $0x1,%ebx
  800152:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800155:	7c c9                	jl     800120 <umain+0xb5>
		strcat(args, " '");
		strcat(args, argv[i]);
		strcat(args, "'");
	}
	cprintf("%s\n", args);
  800157:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80015d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800161:	c7 04 24 0b 33 80 00 	movl   $0x80330b,(%esp)
  800168:	e8 f3 03 00 00       	call   800560 <cprintf>

	cprintf("init: running sh\n");
  80016d:	c7 04 24 0f 33 80 00 	movl   $0x80330f,(%esp)
  800174:	e8 e7 03 00 00       	call   800560 <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800179:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800180:	e8 12 13 00 00       	call   801497 <close>
	if ((r = opencons()) < 0)
  800185:	e8 21 02 00 00       	call   8003ab <opencons>
  80018a:	85 c0                	test   %eax,%eax
  80018c:	79 20                	jns    8001ae <umain+0x143>
		panic("opencons: %e", r);
  80018e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800192:	c7 44 24 08 21 33 80 	movl   $0x803321,0x8(%esp)
  800199:	00 
  80019a:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8001a1:	00 
  8001a2:	c7 04 24 2e 33 80 00 	movl   $0x80332e,(%esp)
  8001a9:	e8 b9 02 00 00       	call   800467 <_panic>
	if (r != 0)
  8001ae:	85 c0                	test   %eax,%eax
  8001b0:	74 20                	je     8001d2 <umain+0x167>
		panic("first opencons used fd %d", r);
  8001b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b6:	c7 44 24 08 3a 33 80 	movl   $0x80333a,0x8(%esp)
  8001bd:	00 
  8001be:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  8001c5:	00 
  8001c6:	c7 04 24 2e 33 80 00 	movl   $0x80332e,(%esp)
  8001cd:	e8 95 02 00 00       	call   800467 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001d9:	00 
  8001da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001e1:	e8 06 13 00 00       	call   8014ec <dup>
  8001e6:	85 c0                	test   %eax,%eax
  8001e8:	79 20                	jns    80020a <umain+0x19f>
		panic("dup: %e", r);
  8001ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ee:	c7 44 24 08 54 33 80 	movl   $0x803354,0x8(%esp)
  8001f5:	00 
  8001f6:	c7 44 24 04 3b 00 00 	movl   $0x3b,0x4(%esp)
  8001fd:	00 
  8001fe:	c7 04 24 2e 33 80 00 	movl   $0x80332e,(%esp)
  800205:	e8 5d 02 00 00       	call   800467 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
  80020a:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  800211:	e8 4a 03 00 00       	call   800560 <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  800216:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80021d:	00 
  80021e:	c7 44 24 04 70 33 80 	movl   $0x803370,0x4(%esp)
  800225:	00 
  800226:	c7 04 24 6f 33 80 00 	movl   $0x80336f,(%esp)
  80022d:	e8 41 1f 00 00       	call   802173 <spawnl>
		if (r < 0) {
  800232:	85 c0                	test   %eax,%eax
  800234:	79 12                	jns    800248 <umain+0x1dd>
			cprintf("init: spawn sh: %e\n", r);
  800236:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023a:	c7 04 24 73 33 80 00 	movl   $0x803373,(%esp)
  800241:	e8 1a 03 00 00       	call   800560 <cprintf>
			continue;
  800246:	eb c2                	jmp    80020a <umain+0x19f>
		}
		wait(r);
  800248:	89 04 24             	mov    %eax,(%esp)
  80024b:	e8 0a 2c 00 00       	call   802e5a <wait>
  800250:	eb b8                	jmp    80020a <umain+0x19f>
  800252:	66 90                	xchg   %ax,%ax
  800254:	66 90                	xchg   %ax,%ax
  800256:	66 90                	xchg   %ax,%ax
  800258:	66 90                	xchg   %ax,%ax
  80025a:	66 90                	xchg   %ax,%ax
  80025c:	66 90                	xchg   %ax,%ax
  80025e:	66 90                	xchg   %ax,%ax

00800260 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800260:	55                   	push   %ebp
  800261:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800263:	b8 00 00 00 00       	mov    $0x0,%eax
  800268:	5d                   	pop    %ebp
  800269:	c3                   	ret    

0080026a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800270:	c7 44 24 04 f3 33 80 	movl   $0x8033f3,0x4(%esp)
  800277:	00 
  800278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027b:	89 04 24             	mov    %eax,(%esp)
  80027e:	e8 04 09 00 00       	call   800b87 <strcpy>
	return 0;
}
  800283:	b8 00 00 00 00       	mov    $0x0,%eax
  800288:	c9                   	leave  
  800289:	c3                   	ret    

0080028a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80028a:	55                   	push   %ebp
  80028b:	89 e5                	mov    %esp,%ebp
  80028d:	57                   	push   %edi
  80028e:	56                   	push   %esi
  80028f:	53                   	push   %ebx
  800290:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800296:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80029b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8002a1:	eb 31                	jmp    8002d4 <devcons_write+0x4a>
		m = n - tot;
  8002a3:	8b 75 10             	mov    0x10(%ebp),%esi
  8002a6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8002a8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8002ab:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8002b0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8002b3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002b7:	03 45 0c             	add    0xc(%ebp),%eax
  8002ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002be:	89 3c 24             	mov    %edi,(%esp)
  8002c1:	e8 5e 0a 00 00       	call   800d24 <memmove>
		sys_cputs(buf, m);
  8002c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002ca:	89 3c 24             	mov    %edi,(%esp)
  8002cd:	e8 04 0c 00 00       	call   800ed6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8002d2:	01 f3                	add    %esi,%ebx
  8002d4:	89 d8                	mov    %ebx,%eax
  8002d6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8002d9:	72 c8                	jb     8002a3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8002db:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8002e1:	5b                   	pop    %ebx
  8002e2:	5e                   	pop    %esi
  8002e3:	5f                   	pop    %edi
  8002e4:	5d                   	pop    %ebp
  8002e5:	c3                   	ret    

008002e6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8002ec:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8002f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002f5:	75 07                	jne    8002fe <devcons_read+0x18>
  8002f7:	eb 2a                	jmp    800323 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8002f9:	e8 86 0c 00 00       	call   800f84 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8002fe:	66 90                	xchg   %ax,%ax
  800300:	e8 ef 0b 00 00       	call   800ef4 <sys_cgetc>
  800305:	85 c0                	test   %eax,%eax
  800307:	74 f0                	je     8002f9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800309:	85 c0                	test   %eax,%eax
  80030b:	78 16                	js     800323 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80030d:	83 f8 04             	cmp    $0x4,%eax
  800310:	74 0c                	je     80031e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  800312:	8b 55 0c             	mov    0xc(%ebp),%edx
  800315:	88 02                	mov    %al,(%edx)
	return 1;
  800317:	b8 01 00 00 00       	mov    $0x1,%eax
  80031c:	eb 05                	jmp    800323 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80031e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800331:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800338:	00 
  800339:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80033c:	89 04 24             	mov    %eax,(%esp)
  80033f:	e8 92 0b 00 00       	call   800ed6 <sys_cputs>
}
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <getchar>:

int
getchar(void)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80034c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800353:	00 
  800354:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800357:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800362:	e8 93 12 00 00       	call   8015fa <read>
	if (r < 0)
  800367:	85 c0                	test   %eax,%eax
  800369:	78 0f                	js     80037a <getchar+0x34>
		return r;
	if (r < 1)
  80036b:	85 c0                	test   %eax,%eax
  80036d:	7e 06                	jle    800375 <getchar+0x2f>
		return -E_EOF;
	return c;
  80036f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800373:	eb 05                	jmp    80037a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800375:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800382:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800385:	89 44 24 04          	mov    %eax,0x4(%esp)
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	89 04 24             	mov    %eax,(%esp)
  80038f:	e8 d2 0f 00 00       	call   801366 <fd_lookup>
  800394:	85 c0                	test   %eax,%eax
  800396:	78 11                	js     8003a9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80039b:	8b 15 70 57 80 00    	mov    0x805770,%edx
  8003a1:	39 10                	cmp    %edx,(%eax)
  8003a3:	0f 94 c0             	sete   %al
  8003a6:	0f b6 c0             	movzbl %al,%eax
}
  8003a9:	c9                   	leave  
  8003aa:	c3                   	ret    

008003ab <opencons>:

int
opencons(void)
{
  8003ab:	55                   	push   %ebp
  8003ac:	89 e5                	mov    %esp,%ebp
  8003ae:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8003b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8003b4:	89 04 24             	mov    %eax,(%esp)
  8003b7:	e8 5b 0f 00 00       	call   801317 <fd_alloc>
		return r;
  8003bc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8003be:	85 c0                	test   %eax,%eax
  8003c0:	78 40                	js     800402 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8003c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8003c9:	00 
  8003ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003d8:	e8 c6 0b 00 00       	call   800fa3 <sys_page_alloc>
		return r;
  8003dd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8003df:	85 c0                	test   %eax,%eax
  8003e1:	78 1f                	js     800402 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8003e3:	8b 15 70 57 80 00    	mov    0x805770,%edx
  8003e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ec:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8003ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8003f8:	89 04 24             	mov    %eax,(%esp)
  8003fb:	e8 f0 0e 00 00       	call   8012f0 <fd2num>
  800400:	89 c2                	mov    %eax,%edx
}
  800402:	89 d0                	mov    %edx,%eax
  800404:	c9                   	leave  
  800405:	c3                   	ret    

00800406 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	56                   	push   %esi
  80040a:	53                   	push   %ebx
  80040b:	83 ec 10             	sub    $0x10,%esp
  80040e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800411:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800414:	e8 4c 0b 00 00       	call   800f65 <sys_getenvid>
  800419:	25 ff 03 00 00       	and    $0x3ff,%eax
  80041e:	c1 e0 07             	shl    $0x7,%eax
  800421:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800426:	a3 90 77 80 00       	mov    %eax,0x807790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80042b:	85 db                	test   %ebx,%ebx
  80042d:	7e 07                	jle    800436 <libmain+0x30>
		binaryname = argv[0];
  80042f:	8b 06                	mov    (%esi),%eax
  800431:	a3 8c 57 80 00       	mov    %eax,0x80578c

	// call user main routine
	umain(argc, argv);
  800436:	89 74 24 04          	mov    %esi,0x4(%esp)
  80043a:	89 1c 24             	mov    %ebx,(%esp)
  80043d:	e8 29 fc ff ff       	call   80006b <umain>

	// exit gracefully
	exit();
  800442:	e8 07 00 00 00       	call   80044e <exit>
}
  800447:	83 c4 10             	add    $0x10,%esp
  80044a:	5b                   	pop    %ebx
  80044b:	5e                   	pop    %esi
  80044c:	5d                   	pop    %ebp
  80044d:	c3                   	ret    

0080044e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
  800451:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800454:	e8 71 10 00 00       	call   8014ca <close_all>
	sys_env_destroy(0);
  800459:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800460:	e8 ae 0a 00 00       	call   800f13 <sys_env_destroy>
}
  800465:	c9                   	leave  
  800466:	c3                   	ret    

00800467 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
  80046a:	56                   	push   %esi
  80046b:	53                   	push   %ebx
  80046c:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80046f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800472:	8b 35 8c 57 80 00    	mov    0x80578c,%esi
  800478:	e8 e8 0a 00 00       	call   800f65 <sys_getenvid>
  80047d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800480:	89 54 24 10          	mov    %edx,0x10(%esp)
  800484:	8b 55 08             	mov    0x8(%ebp),%edx
  800487:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80048b:	89 74 24 08          	mov    %esi,0x8(%esp)
  80048f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800493:	c7 04 24 0c 34 80 00 	movl   $0x80340c,(%esp)
  80049a:	e8 c1 00 00 00       	call   800560 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80049f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a6:	89 04 24             	mov    %eax,(%esp)
  8004a9:	e8 51 00 00 00       	call   8004ff <vcprintf>
	cprintf("\n");
  8004ae:	c7 04 24 51 39 80 00 	movl   $0x803951,(%esp)
  8004b5:	e8 a6 00 00 00       	call   800560 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004ba:	cc                   	int3   
  8004bb:	eb fd                	jmp    8004ba <_panic+0x53>

008004bd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8004bd:	55                   	push   %ebp
  8004be:	89 e5                	mov    %esp,%ebp
  8004c0:	53                   	push   %ebx
  8004c1:	83 ec 14             	sub    $0x14,%esp
  8004c4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8004c7:	8b 13                	mov    (%ebx),%edx
  8004c9:	8d 42 01             	lea    0x1(%edx),%eax
  8004cc:	89 03                	mov    %eax,(%ebx)
  8004ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004d1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8004d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004da:	75 19                	jne    8004f5 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8004dc:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8004e3:	00 
  8004e4:	8d 43 08             	lea    0x8(%ebx),%eax
  8004e7:	89 04 24             	mov    %eax,(%esp)
  8004ea:	e8 e7 09 00 00       	call   800ed6 <sys_cputs>
		b->idx = 0;
  8004ef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8004f5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8004f9:	83 c4 14             	add    $0x14,%esp
  8004fc:	5b                   	pop    %ebx
  8004fd:	5d                   	pop    %ebp
  8004fe:	c3                   	ret    

008004ff <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800508:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050f:	00 00 00 
	b.cnt = 0;
  800512:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800519:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800523:	8b 45 08             	mov    0x8(%ebp),%eax
  800526:	89 44 24 08          	mov    %eax,0x8(%esp)
  80052a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800530:	89 44 24 04          	mov    %eax,0x4(%esp)
  800534:	c7 04 24 bd 04 80 00 	movl   $0x8004bd,(%esp)
  80053b:	e8 ae 01 00 00       	call   8006ee <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800540:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800546:	89 44 24 04          	mov    %eax,0x4(%esp)
  80054a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800550:	89 04 24             	mov    %eax,(%esp)
  800553:	e8 7e 09 00 00       	call   800ed6 <sys_cputs>

	return b.cnt;
}
  800558:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800566:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800569:	89 44 24 04          	mov    %eax,0x4(%esp)
  80056d:	8b 45 08             	mov    0x8(%ebp),%eax
  800570:	89 04 24             	mov    %eax,(%esp)
  800573:	e8 87 ff ff ff       	call   8004ff <vcprintf>
	va_end(ap);

	return cnt;
}
  800578:	c9                   	leave  
  800579:	c3                   	ret    
  80057a:	66 90                	xchg   %ax,%ax
  80057c:	66 90                	xchg   %ax,%ax
  80057e:	66 90                	xchg   %ax,%ax

00800580 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800580:	55                   	push   %ebp
  800581:	89 e5                	mov    %esp,%ebp
  800583:	57                   	push   %edi
  800584:	56                   	push   %esi
  800585:	53                   	push   %ebx
  800586:	83 ec 3c             	sub    $0x3c,%esp
  800589:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80058c:	89 d7                	mov    %edx,%edi
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800594:	8b 45 0c             	mov    0xc(%ebp),%eax
  800597:	89 c3                	mov    %eax,%ebx
  800599:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80059c:	8b 45 10             	mov    0x10(%ebp),%eax
  80059f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005a7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005aa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ad:	39 d9                	cmp    %ebx,%ecx
  8005af:	72 05                	jb     8005b6 <printnum+0x36>
  8005b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005b4:	77 69                	ja     80061f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005b9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8005bd:	83 ee 01             	sub    $0x1,%esi
  8005c0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8005c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8005cc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8005d0:	89 c3                	mov    %eax,%ebx
  8005d2:	89 d6                	mov    %edx,%esi
  8005d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005d7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005da:	89 54 24 08          	mov    %edx,0x8(%esp)
  8005de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8005e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005e5:	89 04 24             	mov    %eax,(%esp)
  8005e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ef:	e8 3c 2a 00 00       	call   803030 <__udivdi3>
  8005f4:	89 d9                	mov    %ebx,%ecx
  8005f6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005fa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8005fe:	89 04 24             	mov    %eax,(%esp)
  800601:	89 54 24 04          	mov    %edx,0x4(%esp)
  800605:	89 fa                	mov    %edi,%edx
  800607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80060a:	e8 71 ff ff ff       	call   800580 <printnum>
  80060f:	eb 1b                	jmp    80062c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800611:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800615:	8b 45 18             	mov    0x18(%ebp),%eax
  800618:	89 04 24             	mov    %eax,(%esp)
  80061b:	ff d3                	call   *%ebx
  80061d:	eb 03                	jmp    800622 <printnum+0xa2>
  80061f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800622:	83 ee 01             	sub    $0x1,%esi
  800625:	85 f6                	test   %esi,%esi
  800627:	7f e8                	jg     800611 <printnum+0x91>
  800629:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80062c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800630:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800634:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800637:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80063a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80063e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800645:	89 04 24             	mov    %eax,(%esp)
  800648:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80064b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80064f:	e8 0c 2b 00 00       	call   803160 <__umoddi3>
  800654:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800658:	0f be 80 2f 34 80 00 	movsbl 0x80342f(%eax),%eax
  80065f:	89 04 24             	mov    %eax,(%esp)
  800662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800665:	ff d0                	call   *%eax
}
  800667:	83 c4 3c             	add    $0x3c,%esp
  80066a:	5b                   	pop    %ebx
  80066b:	5e                   	pop    %esi
  80066c:	5f                   	pop    %edi
  80066d:	5d                   	pop    %ebp
  80066e:	c3                   	ret    

0080066f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80066f:	55                   	push   %ebp
  800670:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800672:	83 fa 01             	cmp    $0x1,%edx
  800675:	7e 0e                	jle    800685 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800677:	8b 10                	mov    (%eax),%edx
  800679:	8d 4a 08             	lea    0x8(%edx),%ecx
  80067c:	89 08                	mov    %ecx,(%eax)
  80067e:	8b 02                	mov    (%edx),%eax
  800680:	8b 52 04             	mov    0x4(%edx),%edx
  800683:	eb 22                	jmp    8006a7 <getuint+0x38>
	else if (lflag)
  800685:	85 d2                	test   %edx,%edx
  800687:	74 10                	je     800699 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800689:	8b 10                	mov    (%eax),%edx
  80068b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80068e:	89 08                	mov    %ecx,(%eax)
  800690:	8b 02                	mov    (%edx),%eax
  800692:	ba 00 00 00 00       	mov    $0x0,%edx
  800697:	eb 0e                	jmp    8006a7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800699:	8b 10                	mov    (%eax),%edx
  80069b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80069e:	89 08                	mov    %ecx,(%eax)
  8006a0:	8b 02                	mov    (%edx),%eax
  8006a2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a7:	5d                   	pop    %ebp
  8006a8:	c3                   	ret    

008006a9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006a9:	55                   	push   %ebp
  8006aa:	89 e5                	mov    %esp,%ebp
  8006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006af:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006b3:	8b 10                	mov    (%eax),%edx
  8006b5:	3b 50 04             	cmp    0x4(%eax),%edx
  8006b8:	73 0a                	jae    8006c4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8006ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006bd:	89 08                	mov    %ecx,(%eax)
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	88 02                	mov    %al,(%edx)
}
  8006c4:	5d                   	pop    %ebp
  8006c5:	c3                   	ret    

008006c6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8006c6:	55                   	push   %ebp
  8006c7:	89 e5                	mov    %esp,%ebp
  8006c9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8006cc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 04 24             	mov    %eax,(%esp)
  8006e7:	e8 02 00 00 00       	call   8006ee <vprintfmt>
	va_end(ap);
}
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
  8006f1:	57                   	push   %edi
  8006f2:	56                   	push   %esi
  8006f3:	53                   	push   %ebx
  8006f4:	83 ec 3c             	sub    $0x3c,%esp
  8006f7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006fd:	eb 14                	jmp    800713 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8006ff:	85 c0                	test   %eax,%eax
  800701:	0f 84 b3 03 00 00    	je     800aba <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800707:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80070b:	89 04 24             	mov    %eax,(%esp)
  80070e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800711:	89 f3                	mov    %esi,%ebx
  800713:	8d 73 01             	lea    0x1(%ebx),%esi
  800716:	0f b6 03             	movzbl (%ebx),%eax
  800719:	83 f8 25             	cmp    $0x25,%eax
  80071c:	75 e1                	jne    8006ff <vprintfmt+0x11>
  80071e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800722:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800729:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800730:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800737:	ba 00 00 00 00       	mov    $0x0,%edx
  80073c:	eb 1d                	jmp    80075b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800740:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800744:	eb 15                	jmp    80075b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800746:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800748:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80074c:	eb 0d                	jmp    80075b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80074e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800751:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800754:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80075e:	0f b6 0e             	movzbl (%esi),%ecx
  800761:	0f b6 c1             	movzbl %cl,%eax
  800764:	83 e9 23             	sub    $0x23,%ecx
  800767:	80 f9 55             	cmp    $0x55,%cl
  80076a:	0f 87 2a 03 00 00    	ja     800a9a <vprintfmt+0x3ac>
  800770:	0f b6 c9             	movzbl %cl,%ecx
  800773:	ff 24 8d 80 35 80 00 	jmp    *0x803580(,%ecx,4)
  80077a:	89 de                	mov    %ebx,%esi
  80077c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800781:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800784:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800788:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80078b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80078e:	83 fb 09             	cmp    $0x9,%ebx
  800791:	77 36                	ja     8007c9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800793:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800796:	eb e9                	jmp    800781 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800798:	8b 45 14             	mov    0x14(%ebp),%eax
  80079b:	8d 48 04             	lea    0x4(%eax),%ecx
  80079e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8007a1:	8b 00                	mov    (%eax),%eax
  8007a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007a6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8007a8:	eb 22                	jmp    8007cc <vprintfmt+0xde>
  8007aa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007ad:	85 c9                	test   %ecx,%ecx
  8007af:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b4:	0f 49 c1             	cmovns %ecx,%eax
  8007b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007ba:	89 de                	mov    %ebx,%esi
  8007bc:	eb 9d                	jmp    80075b <vprintfmt+0x6d>
  8007be:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8007c0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8007c7:	eb 92                	jmp    80075b <vprintfmt+0x6d>
  8007c9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8007cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007d0:	79 89                	jns    80075b <vprintfmt+0x6d>
  8007d2:	e9 77 ff ff ff       	jmp    80074e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007d7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007da:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8007dc:	e9 7a ff ff ff       	jmp    80075b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e4:	8d 50 04             	lea    0x4(%eax),%edx
  8007e7:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	89 04 24             	mov    %eax,(%esp)
  8007f3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007f6:	e9 18 ff ff ff       	jmp    800713 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8d 50 04             	lea    0x4(%eax),%edx
  800801:	89 55 14             	mov    %edx,0x14(%ebp)
  800804:	8b 00                	mov    (%eax),%eax
  800806:	99                   	cltd   
  800807:	31 d0                	xor    %edx,%eax
  800809:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80080b:	83 f8 11             	cmp    $0x11,%eax
  80080e:	7f 0b                	jg     80081b <vprintfmt+0x12d>
  800810:	8b 14 85 e0 36 80 00 	mov    0x8036e0(,%eax,4),%edx
  800817:	85 d2                	test   %edx,%edx
  800819:	75 20                	jne    80083b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80081b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80081f:	c7 44 24 08 47 34 80 	movl   $0x803447,0x8(%esp)
  800826:	00 
  800827:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	89 04 24             	mov    %eax,(%esp)
  800831:	e8 90 fe ff ff       	call   8006c6 <printfmt>
  800836:	e9 d8 fe ff ff       	jmp    800713 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80083b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80083f:	c7 44 24 08 1d 38 80 	movl   $0x80381d,0x8(%esp)
  800846:	00 
  800847:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	89 04 24             	mov    %eax,(%esp)
  800851:	e8 70 fe ff ff       	call   8006c6 <printfmt>
  800856:	e9 b8 fe ff ff       	jmp    800713 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80085b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80085e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800861:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800864:	8b 45 14             	mov    0x14(%ebp),%eax
  800867:	8d 50 04             	lea    0x4(%eax),%edx
  80086a:	89 55 14             	mov    %edx,0x14(%ebp)
  80086d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80086f:	85 f6                	test   %esi,%esi
  800871:	b8 40 34 80 00       	mov    $0x803440,%eax
  800876:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800879:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80087d:	0f 84 97 00 00 00    	je     80091a <vprintfmt+0x22c>
  800883:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800887:	0f 8e 9b 00 00 00    	jle    800928 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80088d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800891:	89 34 24             	mov    %esi,(%esp)
  800894:	e8 cf 02 00 00       	call   800b68 <strnlen>
  800899:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80089c:	29 c2                	sub    %eax,%edx
  80089e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8008a1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8008a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008a8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8008b1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b3:	eb 0f                	jmp    8008c4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8008b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008bc:	89 04 24             	mov    %eax,(%esp)
  8008bf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c1:	83 eb 01             	sub    $0x1,%ebx
  8008c4:	85 db                	test   %ebx,%ebx
  8008c6:	7f ed                	jg     8008b5 <vprintfmt+0x1c7>
  8008c8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8008cb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8008ce:	85 d2                	test   %edx,%edx
  8008d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d5:	0f 49 c2             	cmovns %edx,%eax
  8008d8:	29 c2                	sub    %eax,%edx
  8008da:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8008dd:	89 d7                	mov    %edx,%edi
  8008df:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8008e2:	eb 50                	jmp    800934 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008e8:	74 1e                	je     800908 <vprintfmt+0x21a>
  8008ea:	0f be d2             	movsbl %dl,%edx
  8008ed:	83 ea 20             	sub    $0x20,%edx
  8008f0:	83 fa 5e             	cmp    $0x5e,%edx
  8008f3:	76 13                	jbe    800908 <vprintfmt+0x21a>
					putch('?', putdat);
  8008f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008fc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800903:	ff 55 08             	call   *0x8(%ebp)
  800906:	eb 0d                	jmp    800915 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800908:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80090f:	89 04 24             	mov    %eax,(%esp)
  800912:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800915:	83 ef 01             	sub    $0x1,%edi
  800918:	eb 1a                	jmp    800934 <vprintfmt+0x246>
  80091a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80091d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800920:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800923:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800926:	eb 0c                	jmp    800934 <vprintfmt+0x246>
  800928:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80092b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80092e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800931:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800934:	83 c6 01             	add    $0x1,%esi
  800937:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80093b:	0f be c2             	movsbl %dl,%eax
  80093e:	85 c0                	test   %eax,%eax
  800940:	74 27                	je     800969 <vprintfmt+0x27b>
  800942:	85 db                	test   %ebx,%ebx
  800944:	78 9e                	js     8008e4 <vprintfmt+0x1f6>
  800946:	83 eb 01             	sub    $0x1,%ebx
  800949:	79 99                	jns    8008e4 <vprintfmt+0x1f6>
  80094b:	89 f8                	mov    %edi,%eax
  80094d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800950:	8b 75 08             	mov    0x8(%ebp),%esi
  800953:	89 c3                	mov    %eax,%ebx
  800955:	eb 1a                	jmp    800971 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800957:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80095b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800962:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800964:	83 eb 01             	sub    $0x1,%ebx
  800967:	eb 08                	jmp    800971 <vprintfmt+0x283>
  800969:	89 fb                	mov    %edi,%ebx
  80096b:	8b 75 08             	mov    0x8(%ebp),%esi
  80096e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800971:	85 db                	test   %ebx,%ebx
  800973:	7f e2                	jg     800957 <vprintfmt+0x269>
  800975:	89 75 08             	mov    %esi,0x8(%ebp)
  800978:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80097b:	e9 93 fd ff ff       	jmp    800713 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800980:	83 fa 01             	cmp    $0x1,%edx
  800983:	7e 16                	jle    80099b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800985:	8b 45 14             	mov    0x14(%ebp),%eax
  800988:	8d 50 08             	lea    0x8(%eax),%edx
  80098b:	89 55 14             	mov    %edx,0x14(%ebp)
  80098e:	8b 50 04             	mov    0x4(%eax),%edx
  800991:	8b 00                	mov    (%eax),%eax
  800993:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800996:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800999:	eb 32                	jmp    8009cd <vprintfmt+0x2df>
	else if (lflag)
  80099b:	85 d2                	test   %edx,%edx
  80099d:	74 18                	je     8009b7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80099f:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a2:	8d 50 04             	lea    0x4(%eax),%edx
  8009a5:	89 55 14             	mov    %edx,0x14(%ebp)
  8009a8:	8b 30                	mov    (%eax),%esi
  8009aa:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8009ad:	89 f0                	mov    %esi,%eax
  8009af:	c1 f8 1f             	sar    $0x1f,%eax
  8009b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009b5:	eb 16                	jmp    8009cd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8009b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ba:	8d 50 04             	lea    0x4(%eax),%edx
  8009bd:	89 55 14             	mov    %edx,0x14(%ebp)
  8009c0:	8b 30                	mov    (%eax),%esi
  8009c2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8009c5:	89 f0                	mov    %esi,%eax
  8009c7:	c1 f8 1f             	sar    $0x1f,%eax
  8009ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8009d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8009d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dc:	0f 89 80 00 00 00    	jns    800a62 <vprintfmt+0x374>
				putch('-', putdat);
  8009e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009e6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8009ed:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8009f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009f6:	f7 d8                	neg    %eax
  8009f8:	83 d2 00             	adc    $0x0,%edx
  8009fb:	f7 da                	neg    %edx
			}
			base = 10;
  8009fd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800a02:	eb 5e                	jmp    800a62 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a04:	8d 45 14             	lea    0x14(%ebp),%eax
  800a07:	e8 63 fc ff ff       	call   80066f <getuint>
			base = 10;
  800a0c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800a11:	eb 4f                	jmp    800a62 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800a13:	8d 45 14             	lea    0x14(%ebp),%eax
  800a16:	e8 54 fc ff ff       	call   80066f <getuint>
			base = 8;
  800a1b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800a20:	eb 40                	jmp    800a62 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800a22:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a26:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a2d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800a30:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a34:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a3b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	8d 50 04             	lea    0x4(%eax),%edx
  800a44:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a47:	8b 00                	mov    (%eax),%eax
  800a49:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800a4e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800a53:	eb 0d                	jmp    800a62 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a55:	8d 45 14             	lea    0x14(%ebp),%eax
  800a58:	e8 12 fc ff ff       	call   80066f <getuint>
			base = 16;
  800a5d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a62:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800a66:	89 74 24 10          	mov    %esi,0x10(%esp)
  800a6a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800a6d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800a71:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800a75:	89 04 24             	mov    %eax,(%esp)
  800a78:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a7c:	89 fa                	mov    %edi,%edx
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	e8 fa fa ff ff       	call   800580 <printnum>
			break;
  800a86:	e9 88 fc ff ff       	jmp    800713 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a8b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a8f:	89 04 24             	mov    %eax,(%esp)
  800a92:	ff 55 08             	call   *0x8(%ebp)
			break;
  800a95:	e9 79 fc ff ff       	jmp    800713 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a9a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a9e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800aa5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa8:	89 f3                	mov    %esi,%ebx
  800aaa:	eb 03                	jmp    800aaf <vprintfmt+0x3c1>
  800aac:	83 eb 01             	sub    $0x1,%ebx
  800aaf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800ab3:	75 f7                	jne    800aac <vprintfmt+0x3be>
  800ab5:	e9 59 fc ff ff       	jmp    800713 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800aba:	83 c4 3c             	add    $0x3c,%esp
  800abd:	5b                   	pop    %ebx
  800abe:	5e                   	pop    %esi
  800abf:	5f                   	pop    %edi
  800ac0:	5d                   	pop    %ebp
  800ac1:	c3                   	ret    

00800ac2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ac2:	55                   	push   %ebp
  800ac3:	89 e5                	mov    %esp,%ebp
  800ac5:	83 ec 28             	sub    $0x28,%esp
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ace:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ad1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800ad5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800ad8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800adf:	85 c0                	test   %eax,%eax
  800ae1:	74 30                	je     800b13 <vsnprintf+0x51>
  800ae3:	85 d2                	test   %edx,%edx
  800ae5:	7e 2c                	jle    800b13 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ae7:	8b 45 14             	mov    0x14(%ebp),%eax
  800aea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800aee:	8b 45 10             	mov    0x10(%ebp),%eax
  800af1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800af5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800afc:	c7 04 24 a9 06 80 00 	movl   $0x8006a9,(%esp)
  800b03:	e8 e6 fb ff ff       	call   8006ee <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b0b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b11:	eb 05                	jmp    800b18 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800b13:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800b18:	c9                   	leave  
  800b19:	c3                   	ret    

00800b1a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b1a:	55                   	push   %ebp
  800b1b:	89 e5                	mov    %esp,%ebp
  800b1d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b20:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800b23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b27:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b31:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	89 04 24             	mov    %eax,(%esp)
  800b3b:	e8 82 ff ff ff       	call   800ac2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b40:	c9                   	leave  
  800b41:	c3                   	ret    
  800b42:	66 90                	xchg   %ax,%ax
  800b44:	66 90                	xchg   %ax,%ax
  800b46:	66 90                	xchg   %ax,%ax
  800b48:	66 90                	xchg   %ax,%ax
  800b4a:	66 90                	xchg   %ax,%ax
  800b4c:	66 90                	xchg   %ax,%ax
  800b4e:	66 90                	xchg   %ax,%ax

00800b50 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b56:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5b:	eb 03                	jmp    800b60 <strlen+0x10>
		n++;
  800b5d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b60:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b64:	75 f7                	jne    800b5d <strlen+0xd>
		n++;
	return n;
}
  800b66:	5d                   	pop    %ebp
  800b67:	c3                   	ret    

00800b68 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b68:	55                   	push   %ebp
  800b69:	89 e5                	mov    %esp,%ebp
  800b6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b71:	b8 00 00 00 00       	mov    $0x0,%eax
  800b76:	eb 03                	jmp    800b7b <strnlen+0x13>
		n++;
  800b78:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b7b:	39 d0                	cmp    %edx,%eax
  800b7d:	74 06                	je     800b85 <strnlen+0x1d>
  800b7f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b83:	75 f3                	jne    800b78 <strnlen+0x10>
		n++;
	return n;
}
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	53                   	push   %ebx
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b91:	89 c2                	mov    %eax,%edx
  800b93:	83 c2 01             	add    $0x1,%edx
  800b96:	83 c1 01             	add    $0x1,%ecx
  800b99:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800b9d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ba0:	84 db                	test   %bl,%bl
  800ba2:	75 ef                	jne    800b93 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ba4:	5b                   	pop    %ebx
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	53                   	push   %ebx
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800bb1:	89 1c 24             	mov    %ebx,(%esp)
  800bb4:	e8 97 ff ff ff       	call   800b50 <strlen>
	strcpy(dst + len, src);
  800bb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800bc0:	01 d8                	add    %ebx,%eax
  800bc2:	89 04 24             	mov    %eax,(%esp)
  800bc5:	e8 bd ff ff ff       	call   800b87 <strcpy>
	return dst;
}
  800bca:	89 d8                	mov    %ebx,%eax
  800bcc:	83 c4 08             	add    $0x8,%esp
  800bcf:	5b                   	pop    %ebx
  800bd0:	5d                   	pop    %ebp
  800bd1:	c3                   	ret    

00800bd2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bd2:	55                   	push   %ebp
  800bd3:	89 e5                	mov    %esp,%ebp
  800bd5:	56                   	push   %esi
  800bd6:	53                   	push   %ebx
  800bd7:	8b 75 08             	mov    0x8(%ebp),%esi
  800bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bdd:	89 f3                	mov    %esi,%ebx
  800bdf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800be2:	89 f2                	mov    %esi,%edx
  800be4:	eb 0f                	jmp    800bf5 <strncpy+0x23>
		*dst++ = *src;
  800be6:	83 c2 01             	add    $0x1,%edx
  800be9:	0f b6 01             	movzbl (%ecx),%eax
  800bec:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bef:	80 39 01             	cmpb   $0x1,(%ecx)
  800bf2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bf5:	39 da                	cmp    %ebx,%edx
  800bf7:	75 ed                	jne    800be6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800bf9:	89 f0                	mov    %esi,%eax
  800bfb:	5b                   	pop    %ebx
  800bfc:	5e                   	pop    %esi
  800bfd:	5d                   	pop    %ebp
  800bfe:	c3                   	ret    

00800bff <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bff:	55                   	push   %ebp
  800c00:	89 e5                	mov    %esp,%ebp
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
  800c04:	8b 75 08             	mov    0x8(%ebp),%esi
  800c07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800c0d:	89 f0                	mov    %esi,%eax
  800c0f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c13:	85 c9                	test   %ecx,%ecx
  800c15:	75 0b                	jne    800c22 <strlcpy+0x23>
  800c17:	eb 1d                	jmp    800c36 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800c19:	83 c0 01             	add    $0x1,%eax
  800c1c:	83 c2 01             	add    $0x1,%edx
  800c1f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c22:	39 d8                	cmp    %ebx,%eax
  800c24:	74 0b                	je     800c31 <strlcpy+0x32>
  800c26:	0f b6 0a             	movzbl (%edx),%ecx
  800c29:	84 c9                	test   %cl,%cl
  800c2b:	75 ec                	jne    800c19 <strlcpy+0x1a>
  800c2d:	89 c2                	mov    %eax,%edx
  800c2f:	eb 02                	jmp    800c33 <strlcpy+0x34>
  800c31:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800c33:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800c36:	29 f0                	sub    %esi,%eax
}
  800c38:	5b                   	pop    %ebx
  800c39:	5e                   	pop    %esi
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c42:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c45:	eb 06                	jmp    800c4d <strcmp+0x11>
		p++, q++;
  800c47:	83 c1 01             	add    $0x1,%ecx
  800c4a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c4d:	0f b6 01             	movzbl (%ecx),%eax
  800c50:	84 c0                	test   %al,%al
  800c52:	74 04                	je     800c58 <strcmp+0x1c>
  800c54:	3a 02                	cmp    (%edx),%al
  800c56:	74 ef                	je     800c47 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c58:	0f b6 c0             	movzbl %al,%eax
  800c5b:	0f b6 12             	movzbl (%edx),%edx
  800c5e:	29 d0                	sub    %edx,%eax
}
  800c60:	5d                   	pop    %ebp
  800c61:	c3                   	ret    

00800c62 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	53                   	push   %ebx
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6c:	89 c3                	mov    %eax,%ebx
  800c6e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c71:	eb 06                	jmp    800c79 <strncmp+0x17>
		n--, p++, q++;
  800c73:	83 c0 01             	add    $0x1,%eax
  800c76:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c79:	39 d8                	cmp    %ebx,%eax
  800c7b:	74 15                	je     800c92 <strncmp+0x30>
  800c7d:	0f b6 08             	movzbl (%eax),%ecx
  800c80:	84 c9                	test   %cl,%cl
  800c82:	74 04                	je     800c88 <strncmp+0x26>
  800c84:	3a 0a                	cmp    (%edx),%cl
  800c86:	74 eb                	je     800c73 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c88:	0f b6 00             	movzbl (%eax),%eax
  800c8b:	0f b6 12             	movzbl (%edx),%edx
  800c8e:	29 d0                	sub    %edx,%eax
  800c90:	eb 05                	jmp    800c97 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800c92:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c97:	5b                   	pop    %ebx
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    

00800c9a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ca4:	eb 07                	jmp    800cad <strchr+0x13>
		if (*s == c)
  800ca6:	38 ca                	cmp    %cl,%dl
  800ca8:	74 0f                	je     800cb9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800caa:	83 c0 01             	add    $0x1,%eax
  800cad:	0f b6 10             	movzbl (%eax),%edx
  800cb0:	84 d2                	test   %dl,%dl
  800cb2:	75 f2                	jne    800ca6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc5:	eb 07                	jmp    800cce <strfind+0x13>
		if (*s == c)
  800cc7:	38 ca                	cmp    %cl,%dl
  800cc9:	74 0a                	je     800cd5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ccb:	83 c0 01             	add    $0x1,%eax
  800cce:	0f b6 10             	movzbl (%eax),%edx
  800cd1:	84 d2                	test   %dl,%dl
  800cd3:	75 f2                	jne    800cc7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800cd5:	5d                   	pop    %ebp
  800cd6:	c3                   	ret    

00800cd7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ce0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ce3:	85 c9                	test   %ecx,%ecx
  800ce5:	74 36                	je     800d1d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ce7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ced:	75 28                	jne    800d17 <memset+0x40>
  800cef:	f6 c1 03             	test   $0x3,%cl
  800cf2:	75 23                	jne    800d17 <memset+0x40>
		c &= 0xFF;
  800cf4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cf8:	89 d3                	mov    %edx,%ebx
  800cfa:	c1 e3 08             	shl    $0x8,%ebx
  800cfd:	89 d6                	mov    %edx,%esi
  800cff:	c1 e6 18             	shl    $0x18,%esi
  800d02:	89 d0                	mov    %edx,%eax
  800d04:	c1 e0 10             	shl    $0x10,%eax
  800d07:	09 f0                	or     %esi,%eax
  800d09:	09 c2                	or     %eax,%edx
  800d0b:	89 d0                	mov    %edx,%eax
  800d0d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800d0f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800d12:	fc                   	cld    
  800d13:	f3 ab                	rep stos %eax,%es:(%edi)
  800d15:	eb 06                	jmp    800d1d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1a:	fc                   	cld    
  800d1b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d1d:	89 f8                	mov    %edi,%eax
  800d1f:	5b                   	pop    %ebx
  800d20:	5e                   	pop    %esi
  800d21:	5f                   	pop    %edi
  800d22:	5d                   	pop    %ebp
  800d23:	c3                   	ret    

00800d24 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d2f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d32:	39 c6                	cmp    %eax,%esi
  800d34:	73 35                	jae    800d6b <memmove+0x47>
  800d36:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d39:	39 d0                	cmp    %edx,%eax
  800d3b:	73 2e                	jae    800d6b <memmove+0x47>
		s += n;
		d += n;
  800d3d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800d40:	89 d6                	mov    %edx,%esi
  800d42:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d44:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d4a:	75 13                	jne    800d5f <memmove+0x3b>
  800d4c:	f6 c1 03             	test   $0x3,%cl
  800d4f:	75 0e                	jne    800d5f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d51:	83 ef 04             	sub    $0x4,%edi
  800d54:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d57:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800d5a:	fd                   	std    
  800d5b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d5d:	eb 09                	jmp    800d68 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d5f:	83 ef 01             	sub    $0x1,%edi
  800d62:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d65:	fd                   	std    
  800d66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d68:	fc                   	cld    
  800d69:	eb 1d                	jmp    800d88 <memmove+0x64>
  800d6b:	89 f2                	mov    %esi,%edx
  800d6d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d6f:	f6 c2 03             	test   $0x3,%dl
  800d72:	75 0f                	jne    800d83 <memmove+0x5f>
  800d74:	f6 c1 03             	test   $0x3,%cl
  800d77:	75 0a                	jne    800d83 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d79:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800d7c:	89 c7                	mov    %eax,%edi
  800d7e:	fc                   	cld    
  800d7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d81:	eb 05                	jmp    800d88 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d83:	89 c7                	mov    %eax,%edi
  800d85:	fc                   	cld    
  800d86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d92:	8b 45 10             	mov    0x10(%ebp),%eax
  800d95:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	89 04 24             	mov    %eax,(%esp)
  800da6:	e8 79 ff ff ff       	call   800d24 <memmove>
}
  800dab:	c9                   	leave  
  800dac:	c3                   	ret    

00800dad <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	56                   	push   %esi
  800db1:	53                   	push   %ebx
  800db2:	8b 55 08             	mov    0x8(%ebp),%edx
  800db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db8:	89 d6                	mov    %edx,%esi
  800dba:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dbd:	eb 1a                	jmp    800dd9 <memcmp+0x2c>
		if (*s1 != *s2)
  800dbf:	0f b6 02             	movzbl (%edx),%eax
  800dc2:	0f b6 19             	movzbl (%ecx),%ebx
  800dc5:	38 d8                	cmp    %bl,%al
  800dc7:	74 0a                	je     800dd3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800dc9:	0f b6 c0             	movzbl %al,%eax
  800dcc:	0f b6 db             	movzbl %bl,%ebx
  800dcf:	29 d8                	sub    %ebx,%eax
  800dd1:	eb 0f                	jmp    800de2 <memcmp+0x35>
		s1++, s2++;
  800dd3:	83 c2 01             	add    $0x1,%edx
  800dd6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dd9:	39 f2                	cmp    %esi,%edx
  800ddb:	75 e2                	jne    800dbf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ddd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800def:	89 c2                	mov    %eax,%edx
  800df1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800df4:	eb 07                	jmp    800dfd <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800df6:	38 08                	cmp    %cl,(%eax)
  800df8:	74 07                	je     800e01 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dfa:	83 c0 01             	add    $0x1,%eax
  800dfd:	39 d0                	cmp    %edx,%eax
  800dff:	72 f5                	jb     800df6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    

00800e03 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	57                   	push   %edi
  800e07:	56                   	push   %esi
  800e08:	53                   	push   %ebx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e0f:	eb 03                	jmp    800e14 <strtol+0x11>
		s++;
  800e11:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e14:	0f b6 0a             	movzbl (%edx),%ecx
  800e17:	80 f9 09             	cmp    $0x9,%cl
  800e1a:	74 f5                	je     800e11 <strtol+0xe>
  800e1c:	80 f9 20             	cmp    $0x20,%cl
  800e1f:	74 f0                	je     800e11 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e21:	80 f9 2b             	cmp    $0x2b,%cl
  800e24:	75 0a                	jne    800e30 <strtol+0x2d>
		s++;
  800e26:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800e29:	bf 00 00 00 00       	mov    $0x0,%edi
  800e2e:	eb 11                	jmp    800e41 <strtol+0x3e>
  800e30:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800e35:	80 f9 2d             	cmp    $0x2d,%cl
  800e38:	75 07                	jne    800e41 <strtol+0x3e>
		s++, neg = 1;
  800e3a:	8d 52 01             	lea    0x1(%edx),%edx
  800e3d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e41:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800e46:	75 15                	jne    800e5d <strtol+0x5a>
  800e48:	80 3a 30             	cmpb   $0x30,(%edx)
  800e4b:	75 10                	jne    800e5d <strtol+0x5a>
  800e4d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e51:	75 0a                	jne    800e5d <strtol+0x5a>
		s += 2, base = 16;
  800e53:	83 c2 02             	add    $0x2,%edx
  800e56:	b8 10 00 00 00       	mov    $0x10,%eax
  800e5b:	eb 10                	jmp    800e6d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	75 0c                	jne    800e6d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e61:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e63:	80 3a 30             	cmpb   $0x30,(%edx)
  800e66:	75 05                	jne    800e6d <strtol+0x6a>
		s++, base = 8;
  800e68:	83 c2 01             	add    $0x1,%edx
  800e6b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800e6d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e72:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e75:	0f b6 0a             	movzbl (%edx),%ecx
  800e78:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800e7b:	89 f0                	mov    %esi,%eax
  800e7d:	3c 09                	cmp    $0x9,%al
  800e7f:	77 08                	ja     800e89 <strtol+0x86>
			dig = *s - '0';
  800e81:	0f be c9             	movsbl %cl,%ecx
  800e84:	83 e9 30             	sub    $0x30,%ecx
  800e87:	eb 20                	jmp    800ea9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800e89:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800e8c:	89 f0                	mov    %esi,%eax
  800e8e:	3c 19                	cmp    $0x19,%al
  800e90:	77 08                	ja     800e9a <strtol+0x97>
			dig = *s - 'a' + 10;
  800e92:	0f be c9             	movsbl %cl,%ecx
  800e95:	83 e9 57             	sub    $0x57,%ecx
  800e98:	eb 0f                	jmp    800ea9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800e9a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800e9d:	89 f0                	mov    %esi,%eax
  800e9f:	3c 19                	cmp    $0x19,%al
  800ea1:	77 16                	ja     800eb9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800ea3:	0f be c9             	movsbl %cl,%ecx
  800ea6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ea9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800eac:	7d 0f                	jge    800ebd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800eae:	83 c2 01             	add    $0x1,%edx
  800eb1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800eb5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800eb7:	eb bc                	jmp    800e75 <strtol+0x72>
  800eb9:	89 d8                	mov    %ebx,%eax
  800ebb:	eb 02                	jmp    800ebf <strtol+0xbc>
  800ebd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800ebf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ec3:	74 05                	je     800eca <strtol+0xc7>
		*endptr = (char *) s;
  800ec5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ec8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800eca:	f7 d8                	neg    %eax
  800ecc:	85 ff                	test   %edi,%edi
  800ece:	0f 44 c3             	cmove  %ebx,%eax
}
  800ed1:	5b                   	pop    %ebx
  800ed2:	5e                   	pop    %esi
  800ed3:	5f                   	pop    %edi
  800ed4:	5d                   	pop    %ebp
  800ed5:	c3                   	ret    

00800ed6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
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
  800edc:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee7:	89 c3                	mov    %eax,%ebx
  800ee9:	89 c7                	mov    %eax,%edi
  800eeb:	89 c6                	mov    %eax,%esi
  800eed:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800eef:	5b                   	pop    %ebx
  800ef0:	5e                   	pop    %esi
  800ef1:	5f                   	pop    %edi
  800ef2:	5d                   	pop    %ebp
  800ef3:	c3                   	ret    

00800ef4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	57                   	push   %edi
  800ef8:	56                   	push   %esi
  800ef9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efa:	ba 00 00 00 00       	mov    $0x0,%edx
  800eff:	b8 01 00 00 00       	mov    $0x1,%eax
  800f04:	89 d1                	mov    %edx,%ecx
  800f06:	89 d3                	mov    %edx,%ebx
  800f08:	89 d7                	mov    %edx,%edi
  800f0a:	89 d6                	mov    %edx,%esi
  800f0c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f0e:	5b                   	pop    %ebx
  800f0f:	5e                   	pop    %esi
  800f10:	5f                   	pop    %edi
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	57                   	push   %edi
  800f17:	56                   	push   %esi
  800f18:	53                   	push   %ebx
  800f19:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f21:	b8 03 00 00 00       	mov    $0x3,%eax
  800f26:	8b 55 08             	mov    0x8(%ebp),%edx
  800f29:	89 cb                	mov    %ecx,%ebx
  800f2b:	89 cf                	mov    %ecx,%edi
  800f2d:	89 ce                	mov    %ecx,%esi
  800f2f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f31:	85 c0                	test   %eax,%eax
  800f33:	7e 28                	jle    800f5d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f35:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f39:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800f40:	00 
  800f41:	c7 44 24 08 47 37 80 	movl   $0x803747,0x8(%esp)
  800f48:	00 
  800f49:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f50:	00 
  800f51:	c7 04 24 64 37 80 00 	movl   $0x803764,(%esp)
  800f58:	e8 0a f5 ff ff       	call   800467 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f5d:	83 c4 2c             	add    $0x2c,%esp
  800f60:	5b                   	pop    %ebx
  800f61:	5e                   	pop    %esi
  800f62:	5f                   	pop    %edi
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	57                   	push   %edi
  800f69:	56                   	push   %esi
  800f6a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f70:	b8 02 00 00 00       	mov    $0x2,%eax
  800f75:	89 d1                	mov    %edx,%ecx
  800f77:	89 d3                	mov    %edx,%ebx
  800f79:	89 d7                	mov    %edx,%edi
  800f7b:	89 d6                	mov    %edx,%esi
  800f7d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f7f:	5b                   	pop    %ebx
  800f80:	5e                   	pop    %esi
  800f81:	5f                   	pop    %edi
  800f82:	5d                   	pop    %ebp
  800f83:	c3                   	ret    

00800f84 <sys_yield>:

void
sys_yield(void)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	57                   	push   %edi
  800f88:	56                   	push   %esi
  800f89:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f94:	89 d1                	mov    %edx,%ecx
  800f96:	89 d3                	mov    %edx,%ebx
  800f98:	89 d7                	mov    %edx,%edi
  800f9a:	89 d6                	mov    %edx,%esi
  800f9c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f9e:	5b                   	pop    %ebx
  800f9f:	5e                   	pop    %esi
  800fa0:	5f                   	pop    %edi
  800fa1:	5d                   	pop    %ebp
  800fa2:	c3                   	ret    

00800fa3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	57                   	push   %edi
  800fa7:	56                   	push   %esi
  800fa8:	53                   	push   %ebx
  800fa9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fac:	be 00 00 00 00       	mov    $0x0,%esi
  800fb1:	b8 04 00 00 00       	mov    $0x4,%eax
  800fb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fbf:	89 f7                	mov    %esi,%edi
  800fc1:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800fc3:	85 c0                	test   %eax,%eax
  800fc5:	7e 28                	jle    800fef <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fcb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800fd2:	00 
  800fd3:	c7 44 24 08 47 37 80 	movl   $0x803747,0x8(%esp)
  800fda:	00 
  800fdb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fe2:	00 
  800fe3:	c7 04 24 64 37 80 00 	movl   $0x803764,(%esp)
  800fea:	e8 78 f4 ff ff       	call   800467 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fef:	83 c4 2c             	add    $0x2c,%esp
  800ff2:	5b                   	pop    %ebx
  800ff3:	5e                   	pop    %esi
  800ff4:	5f                   	pop    %edi
  800ff5:	5d                   	pop    %ebp
  800ff6:	c3                   	ret    

00800ff7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ff7:	55                   	push   %ebp
  800ff8:	89 e5                	mov    %esp,%ebp
  800ffa:	57                   	push   %edi
  800ffb:	56                   	push   %esi
  800ffc:	53                   	push   %ebx
  800ffd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801000:	b8 05 00 00 00       	mov    $0x5,%eax
  801005:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801008:	8b 55 08             	mov    0x8(%ebp),%edx
  80100b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80100e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801011:	8b 75 18             	mov    0x18(%ebp),%esi
  801014:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801016:	85 c0                	test   %eax,%eax
  801018:	7e 28                	jle    801042 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80101a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80101e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801025:	00 
  801026:	c7 44 24 08 47 37 80 	movl   $0x803747,0x8(%esp)
  80102d:	00 
  80102e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801035:	00 
  801036:	c7 04 24 64 37 80 00 	movl   $0x803764,(%esp)
  80103d:	e8 25 f4 ff ff       	call   800467 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801042:	83 c4 2c             	add    $0x2c,%esp
  801045:	5b                   	pop    %ebx
  801046:	5e                   	pop    %esi
  801047:	5f                   	pop    %edi
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    

0080104a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	57                   	push   %edi
  80104e:	56                   	push   %esi
  80104f:	53                   	push   %ebx
  801050:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801053:	bb 00 00 00 00       	mov    $0x0,%ebx
  801058:	b8 06 00 00 00       	mov    $0x6,%eax
  80105d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	89 df                	mov    %ebx,%edi
  801065:	89 de                	mov    %ebx,%esi
  801067:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801069:	85 c0                	test   %eax,%eax
  80106b:	7e 28                	jle    801095 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80106d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801071:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801078:	00 
  801079:	c7 44 24 08 47 37 80 	movl   $0x803747,0x8(%esp)
  801080:	00 
  801081:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801088:	00 
  801089:	c7 04 24 64 37 80 00 	movl   $0x803764,(%esp)
  801090:	e8 d2 f3 ff ff       	call   800467 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801095:	83 c4 2c             	add    $0x2c,%esp
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5f                   	pop    %edi
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
  8010a3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ab:	b8 08 00 00 00       	mov    $0x8,%eax
  8010b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b6:	89 df                	mov    %ebx,%edi
  8010b8:	89 de                	mov    %ebx,%esi
  8010ba:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	7e 28                	jle    8010e8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8010cb:	00 
  8010cc:	c7 44 24 08 47 37 80 	movl   $0x803747,0x8(%esp)
  8010d3:	00 
  8010d4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010db:	00 
  8010dc:	c7 04 24 64 37 80 00 	movl   $0x803764,(%esp)
  8010e3:	e8 7f f3 ff ff       	call   800467 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010e8:	83 c4 2c             	add    $0x2c,%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	57                   	push   %edi
  8010f4:	56                   	push   %esi
  8010f5:	53                   	push   %ebx
  8010f6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010fe:	b8 09 00 00 00       	mov    $0x9,%eax
  801103:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801106:	8b 55 08             	mov    0x8(%ebp),%edx
  801109:	89 df                	mov    %ebx,%edi
  80110b:	89 de                	mov    %ebx,%esi
  80110d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80110f:	85 c0                	test   %eax,%eax
  801111:	7e 28                	jle    80113b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801113:	89 44 24 10          	mov    %eax,0x10(%esp)
  801117:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80111e:	00 
  80111f:	c7 44 24 08 47 37 80 	movl   $0x803747,0x8(%esp)
  801126:	00 
  801127:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80112e:	00 
  80112f:	c7 04 24 64 37 80 00 	movl   $0x803764,(%esp)
  801136:	e8 2c f3 ff ff       	call   800467 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80113b:	83 c4 2c             	add    $0x2c,%esp
  80113e:	5b                   	pop    %ebx
  80113f:	5e                   	pop    %esi
  801140:	5f                   	pop    %edi
  801141:	5d                   	pop    %ebp
  801142:	c3                   	ret    

00801143 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801143:	55                   	push   %ebp
  801144:	89 e5                	mov    %esp,%ebp
  801146:	57                   	push   %edi
  801147:	56                   	push   %esi
  801148:	53                   	push   %ebx
  801149:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80114c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801151:	b8 0a 00 00 00       	mov    $0xa,%eax
  801156:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801159:	8b 55 08             	mov    0x8(%ebp),%edx
  80115c:	89 df                	mov    %ebx,%edi
  80115e:	89 de                	mov    %ebx,%esi
  801160:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801162:	85 c0                	test   %eax,%eax
  801164:	7e 28                	jle    80118e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801166:	89 44 24 10          	mov    %eax,0x10(%esp)
  80116a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801171:	00 
  801172:	c7 44 24 08 47 37 80 	movl   $0x803747,0x8(%esp)
  801179:	00 
  80117a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801181:	00 
  801182:	c7 04 24 64 37 80 00 	movl   $0x803764,(%esp)
  801189:	e8 d9 f2 ff ff       	call   800467 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80118e:	83 c4 2c             	add    $0x2c,%esp
  801191:	5b                   	pop    %ebx
  801192:	5e                   	pop    %esi
  801193:	5f                   	pop    %edi
  801194:	5d                   	pop    %ebp
  801195:	c3                   	ret    

00801196 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	57                   	push   %edi
  80119a:	56                   	push   %esi
  80119b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80119c:	be 00 00 00 00       	mov    $0x0,%esi
  8011a1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011af:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011b2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011b4:	5b                   	pop    %ebx
  8011b5:	5e                   	pop    %esi
  8011b6:	5f                   	pop    %edi
  8011b7:	5d                   	pop    %ebp
  8011b8:	c3                   	ret    

008011b9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	57                   	push   %edi
  8011bd:	56                   	push   %esi
  8011be:	53                   	push   %ebx
  8011bf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011c7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cf:	89 cb                	mov    %ecx,%ebx
  8011d1:	89 cf                	mov    %ecx,%edi
  8011d3:	89 ce                	mov    %ecx,%esi
  8011d5:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8011d7:	85 c0                	test   %eax,%eax
  8011d9:	7e 28                	jle    801203 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011db:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011df:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8011e6:	00 
  8011e7:	c7 44 24 08 47 37 80 	movl   $0x803747,0x8(%esp)
  8011ee:	00 
  8011ef:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011f6:	00 
  8011f7:	c7 04 24 64 37 80 00 	movl   $0x803764,(%esp)
  8011fe:	e8 64 f2 ff ff       	call   800467 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801203:	83 c4 2c             	add    $0x2c,%esp
  801206:	5b                   	pop    %ebx
  801207:	5e                   	pop    %esi
  801208:	5f                   	pop    %edi
  801209:	5d                   	pop    %ebp
  80120a:	c3                   	ret    

0080120b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	57                   	push   %edi
  80120f:	56                   	push   %esi
  801210:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801211:	ba 00 00 00 00       	mov    $0x0,%edx
  801216:	b8 0e 00 00 00       	mov    $0xe,%eax
  80121b:	89 d1                	mov    %edx,%ecx
  80121d:	89 d3                	mov    %edx,%ebx
  80121f:	89 d7                	mov    %edx,%edi
  801221:	89 d6                	mov    %edx,%esi
  801223:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801225:	5b                   	pop    %ebx
  801226:	5e                   	pop    %esi
  801227:	5f                   	pop    %edi
  801228:	5d                   	pop    %ebp
  801229:	c3                   	ret    

0080122a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	57                   	push   %edi
  80122e:	56                   	push   %esi
  80122f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801230:	bb 00 00 00 00       	mov    $0x0,%ebx
  801235:	b8 0f 00 00 00       	mov    $0xf,%eax
  80123a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123d:	8b 55 08             	mov    0x8(%ebp),%edx
  801240:	89 df                	mov    %ebx,%edi
  801242:	89 de                	mov    %ebx,%esi
  801244:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  801246:	5b                   	pop    %ebx
  801247:	5e                   	pop    %esi
  801248:	5f                   	pop    %edi
  801249:	5d                   	pop    %ebp
  80124a:	c3                   	ret    

0080124b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  80124b:	55                   	push   %ebp
  80124c:	89 e5                	mov    %esp,%ebp
  80124e:	57                   	push   %edi
  80124f:	56                   	push   %esi
  801250:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801251:	bb 00 00 00 00       	mov    $0x0,%ebx
  801256:	b8 10 00 00 00       	mov    $0x10,%eax
  80125b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80125e:	8b 55 08             	mov    0x8(%ebp),%edx
  801261:	89 df                	mov    %ebx,%edi
  801263:	89 de                	mov    %ebx,%esi
  801265:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  801267:	5b                   	pop    %ebx
  801268:	5e                   	pop    %esi
  801269:	5f                   	pop    %edi
  80126a:	5d                   	pop    %ebp
  80126b:	c3                   	ret    

0080126c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
  80126f:	57                   	push   %edi
  801270:	56                   	push   %esi
  801271:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801272:	b9 00 00 00 00       	mov    $0x0,%ecx
  801277:	b8 11 00 00 00       	mov    $0x11,%eax
  80127c:	8b 55 08             	mov    0x8(%ebp),%edx
  80127f:	89 cb                	mov    %ecx,%ebx
  801281:	89 cf                	mov    %ecx,%edi
  801283:	89 ce                	mov    %ecx,%esi
  801285:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801287:	5b                   	pop    %ebx
  801288:	5e                   	pop    %esi
  801289:	5f                   	pop    %edi
  80128a:	5d                   	pop    %ebp
  80128b:	c3                   	ret    

0080128c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80128c:	55                   	push   %ebp
  80128d:	89 e5                	mov    %esp,%ebp
  80128f:	57                   	push   %edi
  801290:	56                   	push   %esi
  801291:	53                   	push   %ebx
  801292:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801295:	be 00 00 00 00       	mov    $0x0,%esi
  80129a:	b8 12 00 00 00       	mov    $0x12,%eax
  80129f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012a8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012ab:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	7e 28                	jle    8012d9 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012b5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8012bc:	00 
  8012bd:	c7 44 24 08 47 37 80 	movl   $0x803747,0x8(%esp)
  8012c4:	00 
  8012c5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012cc:	00 
  8012cd:	c7 04 24 64 37 80 00 	movl   $0x803764,(%esp)
  8012d4:	e8 8e f1 ff ff       	call   800467 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  8012d9:	83 c4 2c             	add    $0x2c,%esp
  8012dc:	5b                   	pop    %ebx
  8012dd:	5e                   	pop    %esi
  8012de:	5f                   	pop    %edi
  8012df:	5d                   	pop    %ebp
  8012e0:	c3                   	ret    
  8012e1:	66 90                	xchg   %ax,%ax
  8012e3:	66 90                	xchg   %ax,%ax
  8012e5:	66 90                	xchg   %ax,%ax
  8012e7:	66 90                	xchg   %ax,%ax
  8012e9:	66 90                	xchg   %ax,%ax
  8012eb:	66 90                	xchg   %ax,%ax
  8012ed:	66 90                	xchg   %ax,%ax
  8012ef:	90                   	nop

008012f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8012fb:	c1 e8 0c             	shr    $0xc,%eax
}
  8012fe:	5d                   	pop    %ebp
  8012ff:	c3                   	ret    

00801300 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801303:	8b 45 08             	mov    0x8(%ebp),%eax
  801306:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80130b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801310:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801315:	5d                   	pop    %ebp
  801316:	c3                   	ret    

00801317 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80131d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801322:	89 c2                	mov    %eax,%edx
  801324:	c1 ea 16             	shr    $0x16,%edx
  801327:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80132e:	f6 c2 01             	test   $0x1,%dl
  801331:	74 11                	je     801344 <fd_alloc+0x2d>
  801333:	89 c2                	mov    %eax,%edx
  801335:	c1 ea 0c             	shr    $0xc,%edx
  801338:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80133f:	f6 c2 01             	test   $0x1,%dl
  801342:	75 09                	jne    80134d <fd_alloc+0x36>
			*fd_store = fd;
  801344:	89 01                	mov    %eax,(%ecx)
			return 0;
  801346:	b8 00 00 00 00       	mov    $0x0,%eax
  80134b:	eb 17                	jmp    801364 <fd_alloc+0x4d>
  80134d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801352:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801357:	75 c9                	jne    801322 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801359:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80135f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801364:	5d                   	pop    %ebp
  801365:	c3                   	ret    

00801366 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80136c:	83 f8 1f             	cmp    $0x1f,%eax
  80136f:	77 36                	ja     8013a7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801371:	c1 e0 0c             	shl    $0xc,%eax
  801374:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801379:	89 c2                	mov    %eax,%edx
  80137b:	c1 ea 16             	shr    $0x16,%edx
  80137e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801385:	f6 c2 01             	test   $0x1,%dl
  801388:	74 24                	je     8013ae <fd_lookup+0x48>
  80138a:	89 c2                	mov    %eax,%edx
  80138c:	c1 ea 0c             	shr    $0xc,%edx
  80138f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801396:	f6 c2 01             	test   $0x1,%dl
  801399:	74 1a                	je     8013b5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80139b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139e:	89 02                	mov    %eax,(%edx)
	return 0;
  8013a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a5:	eb 13                	jmp    8013ba <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ac:	eb 0c                	jmp    8013ba <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013b3:	eb 05                	jmp    8013ba <fd_lookup+0x54>
  8013b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8013ba:	5d                   	pop    %ebp
  8013bb:	c3                   	ret    

008013bc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 18             	sub    $0x18,%esp
  8013c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8013c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ca:	eb 13                	jmp    8013df <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  8013cc:	39 08                	cmp    %ecx,(%eax)
  8013ce:	75 0c                	jne    8013dc <dev_lookup+0x20>
			*dev = devtab[i];
  8013d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013da:	eb 38                	jmp    801414 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013dc:	83 c2 01             	add    $0x1,%edx
  8013df:	8b 04 95 f0 37 80 00 	mov    0x8037f0(,%edx,4),%eax
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	75 e2                	jne    8013cc <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013ea:	a1 90 77 80 00       	mov    0x807790,%eax
  8013ef:	8b 40 48             	mov    0x48(%eax),%eax
  8013f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013fa:	c7 04 24 74 37 80 00 	movl   $0x803774,(%esp)
  801401:	e8 5a f1 ff ff       	call   800560 <cprintf>
	*dev = 0;
  801406:	8b 45 0c             	mov    0xc(%ebp),%eax
  801409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80140f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801414:	c9                   	leave  
  801415:	c3                   	ret    

00801416 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801416:	55                   	push   %ebp
  801417:	89 e5                	mov    %esp,%ebp
  801419:	56                   	push   %esi
  80141a:	53                   	push   %ebx
  80141b:	83 ec 20             	sub    $0x20,%esp
  80141e:	8b 75 08             	mov    0x8(%ebp),%esi
  801421:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801424:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801427:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80142b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801431:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801434:	89 04 24             	mov    %eax,(%esp)
  801437:	e8 2a ff ff ff       	call   801366 <fd_lookup>
  80143c:	85 c0                	test   %eax,%eax
  80143e:	78 05                	js     801445 <fd_close+0x2f>
	    || fd != fd2)
  801440:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801443:	74 0c                	je     801451 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801445:	84 db                	test   %bl,%bl
  801447:	ba 00 00 00 00       	mov    $0x0,%edx
  80144c:	0f 44 c2             	cmove  %edx,%eax
  80144f:	eb 3f                	jmp    801490 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801451:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801454:	89 44 24 04          	mov    %eax,0x4(%esp)
  801458:	8b 06                	mov    (%esi),%eax
  80145a:	89 04 24             	mov    %eax,(%esp)
  80145d:	e8 5a ff ff ff       	call   8013bc <dev_lookup>
  801462:	89 c3                	mov    %eax,%ebx
  801464:	85 c0                	test   %eax,%eax
  801466:	78 16                	js     80147e <fd_close+0x68>
		if (dev->dev_close)
  801468:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80146e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801473:	85 c0                	test   %eax,%eax
  801475:	74 07                	je     80147e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801477:	89 34 24             	mov    %esi,(%esp)
  80147a:	ff d0                	call   *%eax
  80147c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80147e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801482:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801489:	e8 bc fb ff ff       	call   80104a <sys_page_unmap>
	return r;
  80148e:	89 d8                	mov    %ebx,%eax
}
  801490:	83 c4 20             	add    $0x20,%esp
  801493:	5b                   	pop    %ebx
  801494:	5e                   	pop    %esi
  801495:	5d                   	pop    %ebp
  801496:	c3                   	ret    

00801497 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80149d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	89 04 24             	mov    %eax,(%esp)
  8014aa:	e8 b7 fe ff ff       	call   801366 <fd_lookup>
  8014af:	89 c2                	mov    %eax,%edx
  8014b1:	85 d2                	test   %edx,%edx
  8014b3:	78 13                	js     8014c8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8014b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014bc:	00 
  8014bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c0:	89 04 24             	mov    %eax,(%esp)
  8014c3:	e8 4e ff ff ff       	call   801416 <fd_close>
}
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <close_all>:

void
close_all(void)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	53                   	push   %ebx
  8014ce:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8014d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8014d6:	89 1c 24             	mov    %ebx,(%esp)
  8014d9:	e8 b9 ff ff ff       	call   801497 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8014de:	83 c3 01             	add    $0x1,%ebx
  8014e1:	83 fb 20             	cmp    $0x20,%ebx
  8014e4:	75 f0                	jne    8014d6 <close_all+0xc>
		close(i);
}
  8014e6:	83 c4 14             	add    $0x14,%esp
  8014e9:	5b                   	pop    %ebx
  8014ea:	5d                   	pop    %ebp
  8014eb:	c3                   	ret    

008014ec <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	57                   	push   %edi
  8014f0:	56                   	push   %esi
  8014f1:	53                   	push   %ebx
  8014f2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	89 04 24             	mov    %eax,(%esp)
  801502:	e8 5f fe ff ff       	call   801366 <fd_lookup>
  801507:	89 c2                	mov    %eax,%edx
  801509:	85 d2                	test   %edx,%edx
  80150b:	0f 88 e1 00 00 00    	js     8015f2 <dup+0x106>
		return r;
	close(newfdnum);
  801511:	8b 45 0c             	mov    0xc(%ebp),%eax
  801514:	89 04 24             	mov    %eax,(%esp)
  801517:	e8 7b ff ff ff       	call   801497 <close>

	newfd = INDEX2FD(newfdnum);
  80151c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80151f:	c1 e3 0c             	shl    $0xc,%ebx
  801522:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801528:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80152b:	89 04 24             	mov    %eax,(%esp)
  80152e:	e8 cd fd ff ff       	call   801300 <fd2data>
  801533:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801535:	89 1c 24             	mov    %ebx,(%esp)
  801538:	e8 c3 fd ff ff       	call   801300 <fd2data>
  80153d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80153f:	89 f0                	mov    %esi,%eax
  801541:	c1 e8 16             	shr    $0x16,%eax
  801544:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80154b:	a8 01                	test   $0x1,%al
  80154d:	74 43                	je     801592 <dup+0xa6>
  80154f:	89 f0                	mov    %esi,%eax
  801551:	c1 e8 0c             	shr    $0xc,%eax
  801554:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80155b:	f6 c2 01             	test   $0x1,%dl
  80155e:	74 32                	je     801592 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801560:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801567:	25 07 0e 00 00       	and    $0xe07,%eax
  80156c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801570:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801574:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80157b:	00 
  80157c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801580:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801587:	e8 6b fa ff ff       	call   800ff7 <sys_page_map>
  80158c:	89 c6                	mov    %eax,%esi
  80158e:	85 c0                	test   %eax,%eax
  801590:	78 3e                	js     8015d0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801595:	89 c2                	mov    %eax,%edx
  801597:	c1 ea 0c             	shr    $0xc,%edx
  80159a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015a1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8015a7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8015ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015b6:	00 
  8015b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015c2:	e8 30 fa ff ff       	call   800ff7 <sys_page_map>
  8015c7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8015c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015cc:	85 f6                	test   %esi,%esi
  8015ce:	79 22                	jns    8015f2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8015d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015db:	e8 6a fa ff ff       	call   80104a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8015e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015eb:	e8 5a fa ff ff       	call   80104a <sys_page_unmap>
	return r;
  8015f0:	89 f0                	mov    %esi,%eax
}
  8015f2:	83 c4 3c             	add    $0x3c,%esp
  8015f5:	5b                   	pop    %ebx
  8015f6:	5e                   	pop    %esi
  8015f7:	5f                   	pop    %edi
  8015f8:	5d                   	pop    %ebp
  8015f9:	c3                   	ret    

008015fa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	53                   	push   %ebx
  8015fe:	83 ec 24             	sub    $0x24,%esp
  801601:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801604:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801607:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160b:	89 1c 24             	mov    %ebx,(%esp)
  80160e:	e8 53 fd ff ff       	call   801366 <fd_lookup>
  801613:	89 c2                	mov    %eax,%edx
  801615:	85 d2                	test   %edx,%edx
  801617:	78 6d                	js     801686 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801619:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80161c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801623:	8b 00                	mov    (%eax),%eax
  801625:	89 04 24             	mov    %eax,(%esp)
  801628:	e8 8f fd ff ff       	call   8013bc <dev_lookup>
  80162d:	85 c0                	test   %eax,%eax
  80162f:	78 55                	js     801686 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801631:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801634:	8b 50 08             	mov    0x8(%eax),%edx
  801637:	83 e2 03             	and    $0x3,%edx
  80163a:	83 fa 01             	cmp    $0x1,%edx
  80163d:	75 23                	jne    801662 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80163f:	a1 90 77 80 00       	mov    0x807790,%eax
  801644:	8b 40 48             	mov    0x48(%eax),%eax
  801647:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80164b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164f:	c7 04 24 b5 37 80 00 	movl   $0x8037b5,(%esp)
  801656:	e8 05 ef ff ff       	call   800560 <cprintf>
		return -E_INVAL;
  80165b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801660:	eb 24                	jmp    801686 <read+0x8c>
	}
	if (!dev->dev_read)
  801662:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801665:	8b 52 08             	mov    0x8(%edx),%edx
  801668:	85 d2                	test   %edx,%edx
  80166a:	74 15                	je     801681 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80166c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80166f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801673:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801676:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80167a:	89 04 24             	mov    %eax,(%esp)
  80167d:	ff d2                	call   *%edx
  80167f:	eb 05                	jmp    801686 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801681:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801686:	83 c4 24             	add    $0x24,%esp
  801689:	5b                   	pop    %ebx
  80168a:	5d                   	pop    %ebp
  80168b:	c3                   	ret    

0080168c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	57                   	push   %edi
  801690:	56                   	push   %esi
  801691:	53                   	push   %ebx
  801692:	83 ec 1c             	sub    $0x1c,%esp
  801695:	8b 7d 08             	mov    0x8(%ebp),%edi
  801698:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80169b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016a0:	eb 23                	jmp    8016c5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016a2:	89 f0                	mov    %esi,%eax
  8016a4:	29 d8                	sub    %ebx,%eax
  8016a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016aa:	89 d8                	mov    %ebx,%eax
  8016ac:	03 45 0c             	add    0xc(%ebp),%eax
  8016af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b3:	89 3c 24             	mov    %edi,(%esp)
  8016b6:	e8 3f ff ff ff       	call   8015fa <read>
		if (m < 0)
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	78 10                	js     8016cf <readn+0x43>
			return m;
		if (m == 0)
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	74 0a                	je     8016cd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016c3:	01 c3                	add    %eax,%ebx
  8016c5:	39 f3                	cmp    %esi,%ebx
  8016c7:	72 d9                	jb     8016a2 <readn+0x16>
  8016c9:	89 d8                	mov    %ebx,%eax
  8016cb:	eb 02                	jmp    8016cf <readn+0x43>
  8016cd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8016cf:	83 c4 1c             	add    $0x1c,%esp
  8016d2:	5b                   	pop    %ebx
  8016d3:	5e                   	pop    %esi
  8016d4:	5f                   	pop    %edi
  8016d5:	5d                   	pop    %ebp
  8016d6:	c3                   	ret    

008016d7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	53                   	push   %ebx
  8016db:	83 ec 24             	sub    $0x24,%esp
  8016de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e8:	89 1c 24             	mov    %ebx,(%esp)
  8016eb:	e8 76 fc ff ff       	call   801366 <fd_lookup>
  8016f0:	89 c2                	mov    %eax,%edx
  8016f2:	85 d2                	test   %edx,%edx
  8016f4:	78 68                	js     80175e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801700:	8b 00                	mov    (%eax),%eax
  801702:	89 04 24             	mov    %eax,(%esp)
  801705:	e8 b2 fc ff ff       	call   8013bc <dev_lookup>
  80170a:	85 c0                	test   %eax,%eax
  80170c:	78 50                	js     80175e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80170e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801711:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801715:	75 23                	jne    80173a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801717:	a1 90 77 80 00       	mov    0x807790,%eax
  80171c:	8b 40 48             	mov    0x48(%eax),%eax
  80171f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801723:	89 44 24 04          	mov    %eax,0x4(%esp)
  801727:	c7 04 24 d1 37 80 00 	movl   $0x8037d1,(%esp)
  80172e:	e8 2d ee ff ff       	call   800560 <cprintf>
		return -E_INVAL;
  801733:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801738:	eb 24                	jmp    80175e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80173a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173d:	8b 52 0c             	mov    0xc(%edx),%edx
  801740:	85 d2                	test   %edx,%edx
  801742:	74 15                	je     801759 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801744:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801747:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80174b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80174e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801752:	89 04 24             	mov    %eax,(%esp)
  801755:	ff d2                	call   *%edx
  801757:	eb 05                	jmp    80175e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801759:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80175e:	83 c4 24             	add    $0x24,%esp
  801761:	5b                   	pop    %ebx
  801762:	5d                   	pop    %ebp
  801763:	c3                   	ret    

00801764 <seek>:

int
seek(int fdnum, off_t offset)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80176a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80176d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801771:	8b 45 08             	mov    0x8(%ebp),%eax
  801774:	89 04 24             	mov    %eax,(%esp)
  801777:	e8 ea fb ff ff       	call   801366 <fd_lookup>
  80177c:	85 c0                	test   %eax,%eax
  80177e:	78 0e                	js     80178e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801780:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801783:	8b 55 0c             	mov    0xc(%ebp),%edx
  801786:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801789:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	53                   	push   %ebx
  801794:	83 ec 24             	sub    $0x24,%esp
  801797:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80179a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80179d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a1:	89 1c 24             	mov    %ebx,(%esp)
  8017a4:	e8 bd fb ff ff       	call   801366 <fd_lookup>
  8017a9:	89 c2                	mov    %eax,%edx
  8017ab:	85 d2                	test   %edx,%edx
  8017ad:	78 61                	js     801810 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b9:	8b 00                	mov    (%eax),%eax
  8017bb:	89 04 24             	mov    %eax,(%esp)
  8017be:	e8 f9 fb ff ff       	call   8013bc <dev_lookup>
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	78 49                	js     801810 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017ce:	75 23                	jne    8017f3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8017d0:	a1 90 77 80 00       	mov    0x807790,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017d5:	8b 40 48             	mov    0x48(%eax),%eax
  8017d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e0:	c7 04 24 94 37 80 00 	movl   $0x803794,(%esp)
  8017e7:	e8 74 ed ff ff       	call   800560 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8017ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017f1:	eb 1d                	jmp    801810 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8017f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f6:	8b 52 18             	mov    0x18(%edx),%edx
  8017f9:	85 d2                	test   %edx,%edx
  8017fb:	74 0e                	je     80180b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801800:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801804:	89 04 24             	mov    %eax,(%esp)
  801807:	ff d2                	call   *%edx
  801809:	eb 05                	jmp    801810 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80180b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801810:	83 c4 24             	add    $0x24,%esp
  801813:	5b                   	pop    %ebx
  801814:	5d                   	pop    %ebp
  801815:	c3                   	ret    

00801816 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	53                   	push   %ebx
  80181a:	83 ec 24             	sub    $0x24,%esp
  80181d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801820:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801823:	89 44 24 04          	mov    %eax,0x4(%esp)
  801827:	8b 45 08             	mov    0x8(%ebp),%eax
  80182a:	89 04 24             	mov    %eax,(%esp)
  80182d:	e8 34 fb ff ff       	call   801366 <fd_lookup>
  801832:	89 c2                	mov    %eax,%edx
  801834:	85 d2                	test   %edx,%edx
  801836:	78 52                	js     80188a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801838:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80183b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80183f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801842:	8b 00                	mov    (%eax),%eax
  801844:	89 04 24             	mov    %eax,(%esp)
  801847:	e8 70 fb ff ff       	call   8013bc <dev_lookup>
  80184c:	85 c0                	test   %eax,%eax
  80184e:	78 3a                	js     80188a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801853:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801857:	74 2c                	je     801885 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801859:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80185c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801863:	00 00 00 
	stat->st_isdir = 0;
  801866:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80186d:	00 00 00 
	stat->st_dev = dev;
  801870:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801876:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80187a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80187d:	89 14 24             	mov    %edx,(%esp)
  801880:	ff 50 14             	call   *0x14(%eax)
  801883:	eb 05                	jmp    80188a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801885:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80188a:	83 c4 24             	add    $0x24,%esp
  80188d:	5b                   	pop    %ebx
  80188e:	5d                   	pop    %ebp
  80188f:	c3                   	ret    

00801890 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	56                   	push   %esi
  801894:	53                   	push   %ebx
  801895:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801898:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80189f:	00 
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	89 04 24             	mov    %eax,(%esp)
  8018a6:	e8 84 02 00 00       	call   801b2f <open>
  8018ab:	89 c3                	mov    %eax,%ebx
  8018ad:	85 db                	test   %ebx,%ebx
  8018af:	78 1b                	js     8018cc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8018b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b8:	89 1c 24             	mov    %ebx,(%esp)
  8018bb:	e8 56 ff ff ff       	call   801816 <fstat>
  8018c0:	89 c6                	mov    %eax,%esi
	close(fd);
  8018c2:	89 1c 24             	mov    %ebx,(%esp)
  8018c5:	e8 cd fb ff ff       	call   801497 <close>
	return r;
  8018ca:	89 f0                	mov    %esi,%eax
}
  8018cc:	83 c4 10             	add    $0x10,%esp
  8018cf:	5b                   	pop    %ebx
  8018d0:	5e                   	pop    %esi
  8018d1:	5d                   	pop    %ebp
  8018d2:	c3                   	ret    

008018d3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	56                   	push   %esi
  8018d7:	53                   	push   %ebx
  8018d8:	83 ec 10             	sub    $0x10,%esp
  8018db:	89 c6                	mov    %eax,%esi
  8018dd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8018df:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8018e6:	75 11                	jne    8018f9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8018e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8018ef:	e8 c1 16 00 00       	call   802fb5 <ipc_find_env>
  8018f4:	a3 00 60 80 00       	mov    %eax,0x806000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018f9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801900:	00 
  801901:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  801908:	00 
  801909:	89 74 24 04          	mov    %esi,0x4(%esp)
  80190d:	a1 00 60 80 00       	mov    0x806000,%eax
  801912:	89 04 24             	mov    %eax,(%esp)
  801915:	e8 0e 16 00 00       	call   802f28 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80191a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801921:	00 
  801922:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801926:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80192d:	e8 8e 15 00 00       	call   802ec0 <ipc_recv>
}
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	5b                   	pop    %ebx
  801936:	5e                   	pop    %esi
  801937:	5d                   	pop    %ebp
  801938:	c3                   	ret    

00801939 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	8b 40 0c             	mov    0xc(%eax),%eax
  801945:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.set_size.req_size = newsize;
  80194a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194d:	a3 04 80 80 00       	mov    %eax,0x808004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801952:	ba 00 00 00 00       	mov    $0x0,%edx
  801957:	b8 02 00 00 00       	mov    $0x2,%eax
  80195c:	e8 72 ff ff ff       	call   8018d3 <fsipc>
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	8b 40 0c             	mov    0xc(%eax),%eax
  80196f:	a3 00 80 80 00       	mov    %eax,0x808000
	return fsipc(FSREQ_FLUSH, NULL);
  801974:	ba 00 00 00 00       	mov    $0x0,%edx
  801979:	b8 06 00 00 00       	mov    $0x6,%eax
  80197e:	e8 50 ff ff ff       	call   8018d3 <fsipc>
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	53                   	push   %ebx
  801989:	83 ec 14             	sub    $0x14,%esp
  80198c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	8b 40 0c             	mov    0xc(%eax),%eax
  801995:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80199a:	ba 00 00 00 00       	mov    $0x0,%edx
  80199f:	b8 05 00 00 00       	mov    $0x5,%eax
  8019a4:	e8 2a ff ff ff       	call   8018d3 <fsipc>
  8019a9:	89 c2                	mov    %eax,%edx
  8019ab:	85 d2                	test   %edx,%edx
  8019ad:	78 2b                	js     8019da <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019af:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  8019b6:	00 
  8019b7:	89 1c 24             	mov    %ebx,(%esp)
  8019ba:	e8 c8 f1 ff ff       	call   800b87 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019bf:	a1 80 80 80 00       	mov    0x808080,%eax
  8019c4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019ca:	a1 84 80 80 00       	mov    0x808084,%eax
  8019cf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8019d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019da:	83 c4 14             	add    $0x14,%esp
  8019dd:	5b                   	pop    %ebx
  8019de:	5d                   	pop    %ebp
  8019df:	c3                   	ret    

008019e0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	53                   	push   %ebx
  8019e4:	83 ec 14             	sub    $0x14,%esp
  8019e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f0:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  8019f5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8019fb:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801a00:	0f 46 c3             	cmovbe %ebx,%eax
  801a03:	a3 04 80 80 00       	mov    %eax,0x808004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801a08:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a13:	c7 04 24 08 80 80 00 	movl   $0x808008,(%esp)
  801a1a:	e8 05 f3 ff ff       	call   800d24 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801a1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801a24:	b8 04 00 00 00       	mov    $0x4,%eax
  801a29:	e8 a5 fe ff ff       	call   8018d3 <fsipc>
  801a2e:	85 c0                	test   %eax,%eax
  801a30:	78 53                	js     801a85 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801a32:	39 c3                	cmp    %eax,%ebx
  801a34:	73 24                	jae    801a5a <devfile_write+0x7a>
  801a36:	c7 44 24 0c 04 38 80 	movl   $0x803804,0xc(%esp)
  801a3d:	00 
  801a3e:	c7 44 24 08 0b 38 80 	movl   $0x80380b,0x8(%esp)
  801a45:	00 
  801a46:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801a4d:	00 
  801a4e:	c7 04 24 20 38 80 00 	movl   $0x803820,(%esp)
  801a55:	e8 0d ea ff ff       	call   800467 <_panic>
	assert(r <= PGSIZE);
  801a5a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a5f:	7e 24                	jle    801a85 <devfile_write+0xa5>
  801a61:	c7 44 24 0c 2b 38 80 	movl   $0x80382b,0xc(%esp)
  801a68:	00 
  801a69:	c7 44 24 08 0b 38 80 	movl   $0x80380b,0x8(%esp)
  801a70:	00 
  801a71:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801a78:	00 
  801a79:	c7 04 24 20 38 80 00 	movl   $0x803820,(%esp)
  801a80:	e8 e2 e9 ff ff       	call   800467 <_panic>
	return r;
}
  801a85:	83 c4 14             	add    $0x14,%esp
  801a88:	5b                   	pop    %ebx
  801a89:	5d                   	pop    %ebp
  801a8a:	c3                   	ret    

00801a8b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	56                   	push   %esi
  801a8f:	53                   	push   %ebx
  801a90:	83 ec 10             	sub    $0x10,%esp
  801a93:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	8b 40 0c             	mov    0xc(%eax),%eax
  801a9c:	a3 00 80 80 00       	mov    %eax,0x808000
	fsipcbuf.read.req_n = n;
  801aa1:	89 35 04 80 80 00    	mov    %esi,0x808004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  801aac:	b8 03 00 00 00       	mov    $0x3,%eax
  801ab1:	e8 1d fe ff ff       	call   8018d3 <fsipc>
  801ab6:	89 c3                	mov    %eax,%ebx
  801ab8:	85 c0                	test   %eax,%eax
  801aba:	78 6a                	js     801b26 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801abc:	39 c6                	cmp    %eax,%esi
  801abe:	73 24                	jae    801ae4 <devfile_read+0x59>
  801ac0:	c7 44 24 0c 04 38 80 	movl   $0x803804,0xc(%esp)
  801ac7:	00 
  801ac8:	c7 44 24 08 0b 38 80 	movl   $0x80380b,0x8(%esp)
  801acf:	00 
  801ad0:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801ad7:	00 
  801ad8:	c7 04 24 20 38 80 00 	movl   $0x803820,(%esp)
  801adf:	e8 83 e9 ff ff       	call   800467 <_panic>
	assert(r <= PGSIZE);
  801ae4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ae9:	7e 24                	jle    801b0f <devfile_read+0x84>
  801aeb:	c7 44 24 0c 2b 38 80 	movl   $0x80382b,0xc(%esp)
  801af2:	00 
  801af3:	c7 44 24 08 0b 38 80 	movl   $0x80380b,0x8(%esp)
  801afa:	00 
  801afb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801b02:	00 
  801b03:	c7 04 24 20 38 80 00 	movl   $0x803820,(%esp)
  801b0a:	e8 58 e9 ff ff       	call   800467 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b0f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b13:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  801b1a:	00 
  801b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1e:	89 04 24             	mov    %eax,(%esp)
  801b21:	e8 fe f1 ff ff       	call   800d24 <memmove>
	return r;
}
  801b26:	89 d8                	mov    %ebx,%eax
  801b28:	83 c4 10             	add    $0x10,%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5d                   	pop    %ebp
  801b2e:	c3                   	ret    

00801b2f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	53                   	push   %ebx
  801b33:	83 ec 24             	sub    $0x24,%esp
  801b36:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b39:	89 1c 24             	mov    %ebx,(%esp)
  801b3c:	e8 0f f0 ff ff       	call   800b50 <strlen>
  801b41:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b46:	7f 60                	jg     801ba8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b4b:	89 04 24             	mov    %eax,(%esp)
  801b4e:	e8 c4 f7 ff ff       	call   801317 <fd_alloc>
  801b53:	89 c2                	mov    %eax,%edx
  801b55:	85 d2                	test   %edx,%edx
  801b57:	78 54                	js     801bad <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b59:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b5d:	c7 04 24 00 80 80 00 	movl   $0x808000,(%esp)
  801b64:	e8 1e f0 ff ff       	call   800b87 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b69:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6c:	a3 00 84 80 00       	mov    %eax,0x808400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b74:	b8 01 00 00 00       	mov    $0x1,%eax
  801b79:	e8 55 fd ff ff       	call   8018d3 <fsipc>
  801b7e:	89 c3                	mov    %eax,%ebx
  801b80:	85 c0                	test   %eax,%eax
  801b82:	79 17                	jns    801b9b <open+0x6c>
		fd_close(fd, 0);
  801b84:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b8b:	00 
  801b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8f:	89 04 24             	mov    %eax,(%esp)
  801b92:	e8 7f f8 ff ff       	call   801416 <fd_close>
		return r;
  801b97:	89 d8                	mov    %ebx,%eax
  801b99:	eb 12                	jmp    801bad <open+0x7e>
	}

	return fd2num(fd);
  801b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9e:	89 04 24             	mov    %eax,(%esp)
  801ba1:	e8 4a f7 ff ff       	call   8012f0 <fd2num>
  801ba6:	eb 05                	jmp    801bad <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801ba8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801bad:	83 c4 24             	add    $0x24,%esp
  801bb0:	5b                   	pop    %ebx
  801bb1:	5d                   	pop    %ebp
  801bb2:	c3                   	ret    

00801bb3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bb9:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbe:	b8 08 00 00 00       	mov    $0x8,%eax
  801bc3:	e8 0b fd ff ff       	call   8018d3 <fsipc>
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    
  801bca:	66 90                	xchg   %ax,%ax
  801bcc:	66 90                	xchg   %ax,%ax
  801bce:	66 90                	xchg   %ax,%ax

00801bd0 <map_segment>:
}

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	57                   	push   %edi
  801bd4:	56                   	push   %esi
  801bd5:	53                   	push   %ebx
  801bd6:	83 ec 2c             	sub    $0x2c,%esp
  801bd9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801bdc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801bdf:	89 d0                	mov    %edx,%eax
  801be1:	25 ff 0f 00 00       	and    $0xfff,%eax
  801be6:	74 0b                	je     801bf3 <map_segment+0x23>
		va -= i;
  801be8:	29 c2                	sub    %eax,%edx
		memsz += i;
  801bea:	01 45 e4             	add    %eax,-0x1c(%ebp)
		filesz += i;
  801bed:	01 45 0c             	add    %eax,0xc(%ebp)
		fileoffset -= i;
  801bf0:	29 45 10             	sub    %eax,0x10(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801bf3:	89 d6                	mov    %edx,%esi
  801bf5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bfa:	e9 ff 00 00 00       	jmp    801cfe <map_segment+0x12e>
		if (i >= filesz) {
  801bff:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
  801c02:	77 23                	ja     801c27 <map_segment+0x57>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801c04:	8b 45 14             	mov    0x14(%ebp),%eax
  801c07:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c0b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c12:	89 04 24             	mov    %eax,(%esp)
  801c15:	e8 89 f3 ff ff       	call   800fa3 <sys_page_alloc>
  801c1a:	85 c0                	test   %eax,%eax
  801c1c:	0f 89 d0 00 00 00    	jns    801cf2 <map_segment+0x122>
  801c22:	e9 e7 00 00 00       	jmp    801d0e <map_segment+0x13e>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c27:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c2e:	00 
  801c2f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c36:	00 
  801c37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c3e:	e8 60 f3 ff ff       	call   800fa3 <sys_page_alloc>
  801c43:	85 c0                	test   %eax,%eax
  801c45:	0f 88 c3 00 00 00    	js     801d0e <map_segment+0x13e>
  801c4b:	89 f8                	mov    %edi,%eax
  801c4d:	03 45 10             	add    0x10(%ebp),%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	89 04 24             	mov    %eax,(%esp)
  801c5a:	e8 05 fb ff ff       	call   801764 <seek>
  801c5f:	85 c0                	test   %eax,%eax
  801c61:	0f 88 a7 00 00 00    	js     801d0e <map_segment+0x13e>
  801c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6a:	29 f8                	sub    %edi,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801c6c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c71:	b9 00 10 00 00       	mov    $0x1000,%ecx
  801c76:	0f 47 c1             	cmova  %ecx,%eax
  801c79:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c7d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c84:	00 
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	89 04 24             	mov    %eax,(%esp)
  801c8b:	e8 fc f9 ff ff       	call   80168c <readn>
  801c90:	85 c0                	test   %eax,%eax
  801c92:	78 7a                	js     801d0e <map_segment+0x13e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801c94:	8b 45 14             	mov    0x14(%ebp),%eax
  801c97:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c9b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ca6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801cad:	00 
  801cae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cb5:	e8 3d f3 ff ff       	call   800ff7 <sys_page_map>
  801cba:	85 c0                	test   %eax,%eax
  801cbc:	79 20                	jns    801cde <map_segment+0x10e>
				panic("spawn: sys_page_map data: %e", r);
  801cbe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cc2:	c7 44 24 08 37 38 80 	movl   $0x803837,0x8(%esp)
  801cc9:	00 
  801cca:	c7 44 24 04 ac 01 00 	movl   $0x1ac,0x4(%esp)
  801cd1:	00 
  801cd2:	c7 04 24 54 38 80 00 	movl   $0x803854,(%esp)
  801cd9:	e8 89 e7 ff ff       	call   800467 <_panic>
			sys_page_unmap(0, UTEMP);
  801cde:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ce5:	00 
  801ce6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ced:	e8 58 f3 ff ff       	call   80104a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801cf2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801cf8:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801cfe:	89 df                	mov    %ebx,%edi
  801d00:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  801d03:	0f 87 f6 fe ff ff    	ja     801bff <map_segment+0x2f>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  801d09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0e:	83 c4 2c             	add    $0x2c,%esp
  801d11:	5b                   	pop    %ebx
  801d12:	5e                   	pop    %esi
  801d13:	5f                   	pop    %edi
  801d14:	5d                   	pop    %ebp
  801d15:	c3                   	ret    

00801d16 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801d16:	55                   	push   %ebp
  801d17:	89 e5                	mov    %esp,%ebp
  801d19:	57                   	push   %edi
  801d1a:	56                   	push   %esi
  801d1b:	53                   	push   %ebx
  801d1c:	81 ec 8c 02 00 00    	sub    $0x28c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801d22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d29:	00 
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	89 04 24             	mov    %eax,(%esp)
  801d30:	e8 fa fd ff ff       	call   801b2f <open>
  801d35:	89 c1                	mov    %eax,%ecx
  801d37:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  801d3d:	85 c0                	test   %eax,%eax
  801d3f:	0f 88 9f 03 00 00    	js     8020e4 <spawn+0x3ce>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801d45:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801d4c:	00 
  801d4d:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801d53:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d57:	89 0c 24             	mov    %ecx,(%esp)
  801d5a:	e8 2d f9 ff ff       	call   80168c <readn>
  801d5f:	3d 00 02 00 00       	cmp    $0x200,%eax
  801d64:	75 0c                	jne    801d72 <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801d66:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801d6d:	45 4c 46 
  801d70:	74 36                	je     801da8 <spawn+0x92>
		close(fd);
  801d72:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d78:	89 04 24             	mov    %eax,(%esp)
  801d7b:	e8 17 f7 ff ff       	call   801497 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801d80:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801d87:	46 
  801d88:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d92:	c7 04 24 60 38 80 00 	movl   $0x803860,(%esp)
  801d99:	e8 c2 e7 ff ff       	call   800560 <cprintf>
		return -E_NOT_EXEC;
  801d9e:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  801da3:	e9 c0 03 00 00       	jmp    802168 <spawn+0x452>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801da8:	b8 07 00 00 00       	mov    $0x7,%eax
  801dad:	cd 30                	int    $0x30
  801daf:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  801db5:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801dbb:	85 c0                	test   %eax,%eax
  801dbd:	0f 88 29 03 00 00    	js     8020ec <spawn+0x3d6>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801dc3:	89 c6                	mov    %eax,%esi
  801dc5:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801dcb:	c1 e6 07             	shl    $0x7,%esi
  801dce:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801dd4:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801dda:	b9 11 00 00 00       	mov    $0x11,%ecx
  801ddf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801de1:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801de7:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801ded:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  801df2:	be 00 00 00 00       	mov    $0x0,%esi
  801df7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801dfa:	eb 0f                	jmp    801e0b <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  801dfc:	89 04 24             	mov    %eax,(%esp)
  801dff:	e8 4c ed ff ff       	call   800b50 <strlen>
  801e04:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801e08:	83 c3 01             	add    $0x1,%ebx
  801e0b:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  801e12:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  801e15:	85 c0                	test   %eax,%eax
  801e17:	75 e3                	jne    801dfc <spawn+0xe6>
  801e19:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
  801e1f:	89 8d 7c fd ff ff    	mov    %ecx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801e25:	bf 00 10 40 00       	mov    $0x401000,%edi
  801e2a:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801e2c:	89 fa                	mov    %edi,%edx
  801e2e:	83 e2 fc             	and    $0xfffffffc,%edx
  801e31:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  801e38:	29 c2                	sub    %eax,%edx
  801e3a:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801e40:	8d 42 f8             	lea    -0x8(%edx),%eax
  801e43:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801e48:	0f 86 ae 02 00 00    	jbe    8020fc <spawn+0x3e6>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e4e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801e55:	00 
  801e56:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e5d:	00 
  801e5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e65:	e8 39 f1 ff ff       	call   800fa3 <sys_page_alloc>
  801e6a:	85 c0                	test   %eax,%eax
  801e6c:	0f 88 f6 02 00 00    	js     802168 <spawn+0x452>
  801e72:	be 00 00 00 00       	mov    $0x0,%esi
  801e77:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801e7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801e80:	eb 30                	jmp    801eb2 <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  801e82:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801e88:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801e8e:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  801e91:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801e94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e98:	89 3c 24             	mov    %edi,(%esp)
  801e9b:	e8 e7 ec ff ff       	call   800b87 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801ea0:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  801ea3:	89 04 24             	mov    %eax,(%esp)
  801ea6:	e8 a5 ec ff ff       	call   800b50 <strlen>
  801eab:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801eaf:	83 c6 01             	add    $0x1,%esi
  801eb2:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  801eb8:	7c c8                	jl     801e82 <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801eba:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801ec0:	8b 8d 7c fd ff ff    	mov    -0x284(%ebp),%ecx
  801ec6:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801ecd:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801ed3:	74 24                	je     801ef9 <spawn+0x1e3>
  801ed5:	c7 44 24 0c d8 38 80 	movl   $0x8038d8,0xc(%esp)
  801edc:	00 
  801edd:	c7 44 24 08 0b 38 80 	movl   $0x80380b,0x8(%esp)
  801ee4:	00 
  801ee5:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
  801eec:	00 
  801eed:	c7 04 24 54 38 80 00 	movl   $0x803854,(%esp)
  801ef4:	e8 6e e5 ff ff       	call   800467 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801ef9:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801eff:	89 c8                	mov    %ecx,%eax
  801f01:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801f06:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801f09:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801f0f:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801f12:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801f18:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801f1e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801f25:	00 
  801f26:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801f2d:	ee 
  801f2e:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801f34:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f38:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f3f:	00 
  801f40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f47:	e8 ab f0 ff ff       	call   800ff7 <sys_page_map>
  801f4c:	89 c7                	mov    %eax,%edi
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	0f 88 fc 01 00 00    	js     802152 <spawn+0x43c>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801f56:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f5d:	00 
  801f5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f65:	e8 e0 f0 ff ff       	call   80104a <sys_page_unmap>
  801f6a:	89 c7                	mov    %eax,%edi
  801f6c:	85 c0                	test   %eax,%eax
  801f6e:	0f 88 de 01 00 00    	js     802152 <spawn+0x43c>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801f74:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801f7a:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f81:	be 00 00 00 00       	mov    $0x0,%esi
  801f86:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  801f8c:	eb 4a                	jmp    801fd8 <spawn+0x2c2>
		if (ph->p_type != ELF_PROG_LOAD)
  801f8e:	83 3b 01             	cmpl   $0x1,(%ebx)
  801f91:	75 3f                	jne    801fd2 <spawn+0x2bc>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801f93:	8b 43 18             	mov    0x18(%ebx),%eax
  801f96:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  801f99:	83 f8 01             	cmp    $0x1,%eax
  801f9c:	19 c0                	sbb    %eax,%eax
  801f9e:	83 e0 fe             	and    $0xfffffffe,%eax
  801fa1:	83 c0 07             	add    $0x7,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801fa4:	8b 4b 14             	mov    0x14(%ebx),%ecx
  801fa7:	8b 53 08             	mov    0x8(%ebx),%edx
  801faa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fae:	8b 43 04             	mov    0x4(%ebx),%eax
  801fb1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fb5:	8b 43 10             	mov    0x10(%ebx),%eax
  801fb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbc:	89 3c 24             	mov    %edi,(%esp)
  801fbf:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801fc5:	e8 06 fc ff ff       	call   801bd0 <map_segment>
  801fca:	85 c0                	test   %eax,%eax
  801fcc:	0f 88 ed 00 00 00    	js     8020bf <spawn+0x3a9>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801fd2:	83 c6 01             	add    $0x1,%esi
  801fd5:	83 c3 20             	add    $0x20,%ebx
  801fd8:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801fdf:	39 c6                	cmp    %eax,%esi
  801fe1:	7c ab                	jl     801f8e <spawn+0x278>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801fe3:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801fe9:	89 04 24             	mov    %eax,(%esp)
  801fec:	e8 a6 f4 ff ff       	call   801497 <close>
	uint8_t *addr, *end_addr;
    int perm;
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
  801ff1:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ff6:	8b b5 8c fd ff ff    	mov    -0x274(%ebp),%esi
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)) {
  801ffc:	89 d8                	mov    %ebx,%eax
  801ffe:	c1 e8 16             	shr    $0x16,%eax
  802001:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802008:	a8 01                	test   $0x1,%al
  80200a:	74 46                	je     802052 <spawn+0x33c>
  80200c:	89 d8                	mov    %ebx,%eax
  80200e:	c1 e8 0c             	shr    $0xc,%eax
  802011:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802018:	f6 c2 01             	test   $0x1,%dl
  80201b:	74 35                	je     802052 <spawn+0x33c>
			perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  80201d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
            if (perm & PTE_SHARE) {
  802024:	f6 c4 04             	test   $0x4,%ah
  802027:	74 29                	je     802052 <spawn+0x33c>
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)) {
			perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  802029:	25 07 0e 00 00       	and    $0xe07,%eax
            if (perm & PTE_SHARE) {
                if ((r = sys_page_map(0, addr, child, addr, perm)) < 0) 
  80202e:	89 44 24 10          	mov    %eax,0x10(%esp)
  802032:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802036:	89 74 24 08          	mov    %esi,0x8(%esp)
  80203a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80203e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802045:	e8 ad ef ff ff       	call   800ff7 <sys_page_map>
  80204a:	85 c0                	test   %eax,%eax
  80204c:	0f 88 b1 00 00 00    	js     802103 <spawn+0x3ed>
	uint8_t *addr, *end_addr;
    int perm;
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
  802052:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802058:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  80205e:	75 9c                	jne    801ffc <spawn+0x2e6>
  802060:	e9 be 00 00 00       	jmp    802123 <spawn+0x40d>
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  802065:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802069:	c7 44 24 08 7a 38 80 	movl   $0x80387a,0x8(%esp)
  802070:	00 
  802071:	c7 44 24 04 8b 00 00 	movl   $0x8b,0x4(%esp)
  802078:	00 
  802079:	c7 04 24 54 38 80 00 	movl   $0x803854,(%esp)
  802080:	e8 e2 e3 ff ff       	call   800467 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802085:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  80208c:	00 
  80208d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802093:	89 04 24             	mov    %eax,(%esp)
  802096:	e8 02 f0 ff ff       	call   80109d <sys_env_set_status>
  80209b:	85 c0                	test   %eax,%eax
  80209d:	79 55                	jns    8020f4 <spawn+0x3de>
		panic("sys_env_set_status: %e", r);
  80209f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020a3:	c7 44 24 08 94 38 80 	movl   $0x803894,0x8(%esp)
  8020aa:	00 
  8020ab:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  8020b2:	00 
  8020b3:	c7 04 24 54 38 80 00 	movl   $0x803854,(%esp)
  8020ba:	e8 a8 e3 ff ff       	call   800467 <_panic>
  8020bf:	89 c7                	mov    %eax,%edi

	return child;

error:
	sys_env_destroy(child);
  8020c1:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8020c7:	89 04 24             	mov    %eax,(%esp)
  8020ca:	e8 44 ee ff ff       	call   800f13 <sys_env_destroy>
	close(fd);
  8020cf:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8020d5:	89 04 24             	mov    %eax,(%esp)
  8020d8:	e8 ba f3 ff ff       	call   801497 <close>
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8020dd:	89 f8                	mov    %edi,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  8020df:	e9 84 00 00 00       	jmp    802168 <spawn+0x452>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  8020e4:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8020ea:	eb 7c                	jmp    802168 <spawn+0x452>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  8020ec:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8020f2:	eb 74                	jmp    802168 <spawn+0x452>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  8020f4:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8020fa:	eb 6c                	jmp    802168 <spawn+0x452>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  8020fc:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  802101:	eb 65                	jmp    802168 <spawn+0x452>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  802103:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802107:	c7 44 24 08 ab 38 80 	movl   $0x8038ab,0x8(%esp)
  80210e:	00 
  80210f:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  802116:	00 
  802117:	c7 04 24 54 38 80 00 	movl   $0x803854,(%esp)
  80211e:	e8 44 e3 ff ff       	call   800467 <_panic>

	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802123:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  80212a:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80212d:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802133:	89 44 24 04          	mov    %eax,0x4(%esp)
  802137:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  80213d:	89 04 24             	mov    %eax,(%esp)
  802140:	e8 ab ef ff ff       	call   8010f0 <sys_env_set_trapframe>
  802145:	85 c0                	test   %eax,%eax
  802147:	0f 89 38 ff ff ff    	jns    802085 <spawn+0x36f>
  80214d:	e9 13 ff ff ff       	jmp    802065 <spawn+0x34f>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802152:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802159:	00 
  80215a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802161:	e8 e4 ee ff ff       	call   80104a <sys_page_unmap>
  802166:	89 f8                	mov    %edi,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802168:	81 c4 8c 02 00 00    	add    $0x28c,%esp
  80216e:	5b                   	pop    %ebx
  80216f:	5e                   	pop    %esi
  802170:	5f                   	pop    %edi
  802171:	5d                   	pop    %ebp
  802172:	c3                   	ret    

00802173 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	56                   	push   %esi
  802177:	53                   	push   %ebx
  802178:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80217b:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  80217e:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802183:	eb 03                	jmp    802188 <spawnl+0x15>
		argc++;
  802185:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802188:	83 c0 04             	add    $0x4,%eax
  80218b:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  80218f:	75 f4                	jne    802185 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802191:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  802198:	83 e0 f0             	and    $0xfffffff0,%eax
  80219b:	29 c4                	sub    %eax,%esp
  80219d:	8d 44 24 0b          	lea    0xb(%esp),%eax
  8021a1:	c1 e8 02             	shr    $0x2,%eax
  8021a4:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  8021ab:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8021ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021b0:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  8021b7:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  8021be:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8021bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c4:	eb 0a                	jmp    8021d0 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  8021c6:	83 c0 01             	add    $0x1,%eax
  8021c9:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  8021cd:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8021d0:	39 d0                	cmp    %edx,%eax
  8021d2:	75 f2                	jne    8021c6 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  8021d4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	89 04 24             	mov    %eax,(%esp)
  8021de:	e8 33 fb ff ff       	call   801d16 <spawn>
}
  8021e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021e6:	5b                   	pop    %ebx
  8021e7:	5e                   	pop    %esi
  8021e8:	5d                   	pop    %ebp
  8021e9:	c3                   	ret    

008021ea <exec>:

int
exec(const char *prog, const char **argv)
{
  8021ea:	55                   	push   %ebp
  8021eb:	89 e5                	mov    %esp,%ebp
  8021ed:	57                   	push   %edi
  8021ee:	56                   	push   %esi
  8021ef:	53                   	push   %ebx
  8021f0:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
	int fd, i, r;
	struct Elf *elf;
	struct Proghdr *ph;
	int perm;	

	if ((r = open(prog, O_RDONLY)) < 0)
  8021f6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8021fd:	00 
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	89 04 24             	mov    %eax,(%esp)
  802204:	e8 26 f9 ff ff       	call   801b2f <open>
  802209:	89 c7                	mov    %eax,%edi
  80220b:	85 c0                	test   %eax,%eax
  80220d:	0f 88 14 03 00 00    	js     802527 <exec+0x33d>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802213:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80221a:	00 
  80221b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802221:	89 44 24 04          	mov    %eax,0x4(%esp)
  802225:	89 3c 24             	mov    %edi,(%esp)
  802228:	e8 5f f4 ff ff       	call   80168c <readn>
  80222d:	3d 00 02 00 00       	cmp    $0x200,%eax
  802232:	75 0c                	jne    802240 <exec+0x56>
	    || elf->e_magic != ELF_MAGIC) {
  802234:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80223b:	45 4c 46 
  80223e:	74 30                	je     802270 <exec+0x86>
		close(fd);
  802240:	89 3c 24             	mov    %edi,(%esp)
  802243:	e8 4f f2 ff ff       	call   801497 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802248:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  80224f:	46 
  802250:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802256:	89 44 24 04          	mov    %eax,0x4(%esp)
  80225a:	c7 04 24 60 38 80 00 	movl   $0x803860,(%esp)
  802261:	e8 fa e2 ff ff       	call   800560 <cprintf>
		return -E_NOT_EXEC;
  802266:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  80226b:	e9 d8 02 00 00       	jmp    802548 <exec+0x35e>
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802270:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802276:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
  80227d:	b8 00 00 00 e0       	mov    $0xe0000000,%eax
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802282:	be 00 00 00 00       	mov    $0x0,%esi
  802287:	89 bd e4 fd ff ff    	mov    %edi,-0x21c(%ebp)
  80228d:	89 c7                	mov    %eax,%edi
  80228f:	eb 71                	jmp    802302 <exec+0x118>
		if (ph->p_type != ELF_PROG_LOAD)
  802291:	83 3b 01             	cmpl   $0x1,(%ebx)
  802294:	75 66                	jne    8022fc <exec+0x112>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802296:	8b 43 18             	mov    0x18(%ebx),%eax
  802299:	83 e0 02             	and    $0x2,%eax
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  80229c:	83 f8 01             	cmp    $0x1,%eax
  80229f:	19 c0                	sbb    %eax,%eax
  8022a1:	83 e0 fe             	and    $0xfffffffe,%eax
  8022a4:	83 c0 07             	add    $0x7,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(0, PGOFF(ph->p_va) + tmp, ph->p_memsz,
  8022a7:	8b 4b 14             	mov    0x14(%ebx),%ecx
  8022aa:	8b 53 08             	mov    0x8(%ebx),%edx
  8022ad:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8022b3:	01 fa                	add    %edi,%edx
  8022b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022b9:	8b 43 04             	mov    0x4(%ebx),%eax
  8022bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022c0:	8b 43 10             	mov    0x10(%ebx),%eax
  8022c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c7:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
  8022cd:	89 04 24             	mov    %eax,(%esp)
  8022d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d5:	e8 f6 f8 ff ff       	call   801bd0 <map_segment>
  8022da:	85 c0                	test   %eax,%eax
  8022dc:	0f 88 25 02 00 00    	js     802507 <exec+0x31d>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
  8022e2:	8b 53 14             	mov    0x14(%ebx),%edx
  8022e5:	8b 43 08             	mov    0x8(%ebx),%eax
  8022e8:	25 ff 0f 00 00       	and    $0xfff,%eax
  8022ed:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
  8022f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8022f9:	8d 3c 38             	lea    (%eax,%edi,1),%edi
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8022fc:	83 c6 01             	add    $0x1,%esi
  8022ff:	83 c3 20             	add    $0x20,%ebx
  802302:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802309:	39 c6                	cmp    %eax,%esi
  80230b:	7c 84                	jl     802291 <exec+0xa7>
  80230d:	89 bd dc fd ff ff    	mov    %edi,-0x224(%ebp)
  802313:	8b bd e4 fd ff ff    	mov    -0x21c(%ebp),%edi
		if ((r = map_segment(0, PGOFF(ph->p_va) + tmp, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
	}
	close(fd);
  802319:	89 3c 24             	mov    %edi,(%esp)
  80231c:	e8 76 f1 ff ff       	call   801497 <close>
	fd = -1;
	cprintf("tf_esp: %x\n", tf_esp);
  802321:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802328:	00 
  802329:	c7 04 24 c1 38 80 00 	movl   $0x8038c1,(%esp)
  802330:	e8 2b e2 ff ff       	call   800560 <cprintf>
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802335:	bb 00 00 00 00       	mov    $0x0,%ebx
	size_t string_size;
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
  80233a:	be 00 00 00 00       	mov    $0x0,%esi
  80233f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802342:	eb 0f                	jmp    802353 <exec+0x169>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  802344:	89 04 24             	mov    %eax,(%esp)
  802347:	e8 04 e8 ff ff       	call   800b50 <strlen>
  80234c:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802350:	83 c3 01             	add    $0x1,%ebx
  802353:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80235a:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80235d:	85 c0                	test   %eax,%eax
  80235f:	75 e3                	jne    802344 <exec+0x15a>
  802361:	89 9d d8 fd ff ff    	mov    %ebx,-0x228(%ebp)
  802367:	89 8d d4 fd ff ff    	mov    %ecx,-0x22c(%ebp)
		string_size += strlen(argv[argc]) + 1;

	string_store = (char*) UTEMP + PGSIZE - string_size;
  80236d:	bf 00 10 40 00       	mov    $0x401000,%edi
  802372:	29 f7                	sub    %esi,%edi
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802374:	89 fa                	mov    %edi,%edx
  802376:	83 e2 fc             	and    $0xfffffffc,%edx
  802379:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802380:	29 c2                	sub    %eax,%edx
  802382:	89 95 e4 fd ff ff    	mov    %edx,-0x21c(%ebp)
	
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802388:	8d 42 f8             	lea    -0x8(%edx),%eax
  80238b:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802390:	0f 86 93 01 00 00    	jbe    802529 <exec+0x33f>
		return -E_NO_MEM;

	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802396:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80239d:	00 
  80239e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8023a5:	00 
  8023a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023ad:	e8 f1 eb ff ff       	call   800fa3 <sys_page_alloc>
  8023b2:	85 c0                	test   %eax,%eax
  8023b4:	0f 88 8e 01 00 00    	js     802548 <exec+0x35e>
  8023ba:	be 00 00 00 00       	mov    $0x0,%esi
  8023bf:	89 9d e0 fd ff ff    	mov    %ebx,-0x220(%ebp)
  8023c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8023c8:	eb 30                	jmp    8023fa <exec+0x210>
		return r;

	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  8023ca:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8023d0:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
  8023d6:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8023d9:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  8023dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023e0:	89 3c 24             	mov    %edi,(%esp)
  8023e3:	e8 9f e7 ff ff       	call   800b87 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8023e8:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  8023eb:	89 04 24             	mov    %eax,(%esp)
  8023ee:	e8 5d e7 ff ff       	call   800b50 <strlen>
  8023f3:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
		return -E_NO_MEM;

	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		return r;

	for (i = 0; i < argc; i++) {
  8023f7:	83 c6 01             	add    $0x1,%esi
  8023fa:	39 b5 e0 fd ff ff    	cmp    %esi,-0x220(%ebp)
  802400:	7f c8                	jg     8023ca <exec+0x1e0>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802402:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
  802408:	8b 8d d4 fd ff ff    	mov    -0x22c(%ebp),%ecx
  80240e:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802415:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80241b:	74 24                	je     802441 <exec+0x257>
  80241d:	c7 44 24 0c d8 38 80 	movl   $0x8038d8,0xc(%esp)
  802424:	00 
  802425:	c7 44 24 08 0b 38 80 	movl   $0x80380b,0x8(%esp)
  80242c:	00 
  80242d:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
  802434:	00 
  802435:	c7 04 24 54 38 80 00 	movl   $0x803854,(%esp)
  80243c:	e8 26 e0 ff ff       	call   800467 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802441:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
  802447:	89 c8                	mov    %ecx,%eax
  802449:	2d 00 30 80 11       	sub    $0x11803000,%eax
  80244e:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802451:	8b 85 d8 fd ff ff    	mov    -0x228(%ebp),%eax
  802457:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80245a:	8d 99 f8 cf 7f ee    	lea    -0x11803008(%ecx),%ebx

	cprintf("stack: %x\n", stack);
  802460:	8b bd dc fd ff ff    	mov    -0x224(%ebp),%edi
  802466:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80246a:	c7 04 24 cd 38 80 00 	movl   $0x8038cd,(%esp)
  802471:	e8 ea e0 ff ff       	call   800560 <cprintf>
	if ((r = sys_page_map(0, UTEMP, child, (void*) stack, PTE_P | PTE_U | PTE_W)) < 0)
  802476:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80247d:	00 
  80247e:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802482:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802489:	00 
  80248a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802491:	00 
  802492:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802499:	e8 59 eb ff ff       	call   800ff7 <sys_page_map>
  80249e:	89 c7                	mov    %eax,%edi
  8024a0:	85 c0                	test   %eax,%eax
  8024a2:	0f 88 8a 00 00 00    	js     802532 <exec+0x348>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8024a8:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8024af:	00 
  8024b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024b7:	e8 8e eb ff ff       	call   80104a <sys_page_unmap>
  8024bc:	89 c7                	mov    %eax,%edi
  8024be:	85 c0                	test   %eax,%eax
  8024c0:	78 70                	js     802532 <exec+0x348>
	// cprintf("tf_eip: %x\n", tf_eip);
	if ((r = init_stack_with_addr(0, argv, &tf_esp, tmp)) < 0)
		return r;

	// Syscall to exec
	if (sys_exec(elf->e_entry, tf_esp, (void *)(elf_buf + elf->e_phoff), elf->e_phnum) < 0)
  8024c2:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8024c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024cd:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8024d3:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8024da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024e2:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8024e8:	89 04 24             	mov    %eax,(%esp)
  8024eb:	e8 9c ed ff ff       	call   80128c <sys_exec>
  8024f0:	89 c2                	mov    %eax,%edx
		goto error;
	return 0;
  8024f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f7:	be 00 00 00 00       	mov    $0x0,%esi
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
	}
	close(fd);
	fd = -1;
  8024fc:	bf ff ff ff ff       	mov    $0xffffffff,%edi
	// cprintf("tf_eip: %x\n", tf_eip);
	if ((r = init_stack_with_addr(0, argv, &tf_esp, tmp)) < 0)
		return r;

	// Syscall to exec
	if (sys_exec(elf->e_entry, tf_esp, (void *)(elf_buf + elf->e_phoff), elf->e_phnum) < 0)
  802501:	85 d2                	test   %edx,%edx
  802503:	78 0a                	js     80250f <exec+0x325>
  802505:	eb 41                	jmp    802548 <exec+0x35e>
  802507:	8b bd e4 fd ff ff    	mov    -0x21c(%ebp),%edi
  80250d:	89 c6                	mov    %eax,%esi
		goto error;
	return 0;

error:
	sys_env_destroy(0);
  80250f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802516:	e8 f8 e9 ff ff       	call   800f13 <sys_env_destroy>
	close(fd);
  80251b:	89 3c 24             	mov    %edi,(%esp)
  80251e:	e8 74 ef ff ff       	call   801497 <close>
	return r;
  802523:	89 f0                	mov    %esi,%eax
  802525:	eb 21                	jmp    802548 <exec+0x35e>
  802527:	eb 1f                	jmp    802548 <exec+0x35e>

	string_store = (char*) UTEMP + PGSIZE - string_size;
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  802529:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  80252e:	66 90                	xchg   %ax,%ax
  802530:	eb 16                	jmp    802548 <exec+0x35e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802532:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802539:	00 
  80253a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802541:	e8 04 eb ff ff       	call   80104a <sys_page_unmap>
  802546:	89 f8                	mov    %edi,%eax

error:
	sys_env_destroy(0);
	close(fd);
	return r;
}
  802548:	81 c4 3c 02 00 00    	add    $0x23c,%esp
  80254e:	5b                   	pop    %ebx
  80254f:	5e                   	pop    %esi
  802550:	5f                   	pop    %edi
  802551:	5d                   	pop    %ebp
  802552:	c3                   	ret    

00802553 <execl>:

int
execl(const char *prog, const char *arg0, ...)
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
  802556:	56                   	push   %esi
  802557:	53                   	push   %ebx
  802558:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  80255b:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  80255e:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802563:	eb 03                	jmp    802568 <execl+0x15>
		argc++;
  802565:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802568:	83 c0 04             	add    $0x4,%eax
  80256b:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  80256f:	75 f4                	jne    802565 <execl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802571:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  802578:	83 e0 f0             	and    $0xfffffff0,%eax
  80257b:	29 c4                	sub    %eax,%esp
  80257d:	8d 44 24 0b          	lea    0xb(%esp),%eax
  802581:	c1 e8 02             	shr    $0x2,%eax
  802584:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  80258b:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  80258d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802590:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  802597:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  80259e:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  80259f:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a4:	eb 0a                	jmp    8025b0 <execl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  8025a6:	83 c0 01             	add    $0x1,%eax
  8025a9:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  8025ad:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8025b0:	39 d0                	cmp    %edx,%eax
  8025b2:	75 f2                	jne    8025a6 <execl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return exec(prog, argv);
  8025b4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bb:	89 04 24             	mov    %eax,(%esp)
  8025be:	e8 27 fc ff ff       	call   8021ea <exec>
}
  8025c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8025c6:	5b                   	pop    %ebx
  8025c7:	5e                   	pop    %esi
  8025c8:	5d                   	pop    %ebp
  8025c9:	c3                   	ret    
  8025ca:	66 90                	xchg   %ax,%ax
  8025cc:	66 90                	xchg   %ax,%ax
  8025ce:	66 90                	xchg   %ax,%ax

008025d0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8025d6:	c7 44 24 04 00 39 80 	movl   $0x803900,0x4(%esp)
  8025dd:	00 
  8025de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e1:	89 04 24             	mov    %eax,(%esp)
  8025e4:	e8 9e e5 ff ff       	call   800b87 <strcpy>
	return 0;
}
  8025e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ee:	c9                   	leave  
  8025ef:	c3                   	ret    

008025f0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
  8025f3:	53                   	push   %ebx
  8025f4:	83 ec 14             	sub    $0x14,%esp
  8025f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8025fa:	89 1c 24             	mov    %ebx,(%esp)
  8025fd:	e8 ed 09 00 00       	call   802fef <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802602:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802607:	83 f8 01             	cmp    $0x1,%eax
  80260a:	75 0d                	jne    802619 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80260c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80260f:	89 04 24             	mov    %eax,(%esp)
  802612:	e8 29 03 00 00       	call   802940 <nsipc_close>
  802617:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802619:	89 d0                	mov    %edx,%eax
  80261b:	83 c4 14             	add    $0x14,%esp
  80261e:	5b                   	pop    %ebx
  80261f:	5d                   	pop    %ebp
  802620:	c3                   	ret    

00802621 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802621:	55                   	push   %ebp
  802622:	89 e5                	mov    %esp,%ebp
  802624:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802627:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80262e:	00 
  80262f:	8b 45 10             	mov    0x10(%ebp),%eax
  802632:	89 44 24 08          	mov    %eax,0x8(%esp)
  802636:	8b 45 0c             	mov    0xc(%ebp),%eax
  802639:	89 44 24 04          	mov    %eax,0x4(%esp)
  80263d:	8b 45 08             	mov    0x8(%ebp),%eax
  802640:	8b 40 0c             	mov    0xc(%eax),%eax
  802643:	89 04 24             	mov    %eax,(%esp)
  802646:	e8 f0 03 00 00       	call   802a3b <nsipc_send>
}
  80264b:	c9                   	leave  
  80264c:	c3                   	ret    

0080264d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802653:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80265a:	00 
  80265b:	8b 45 10             	mov    0x10(%ebp),%eax
  80265e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802662:	8b 45 0c             	mov    0xc(%ebp),%eax
  802665:	89 44 24 04          	mov    %eax,0x4(%esp)
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	8b 40 0c             	mov    0xc(%eax),%eax
  80266f:	89 04 24             	mov    %eax,(%esp)
  802672:	e8 44 03 00 00       	call   8029bb <nsipc_recv>
}
  802677:	c9                   	leave  
  802678:	c3                   	ret    

00802679 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802679:	55                   	push   %ebp
  80267a:	89 e5                	mov    %esp,%ebp
  80267c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80267f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802682:	89 54 24 04          	mov    %edx,0x4(%esp)
  802686:	89 04 24             	mov    %eax,(%esp)
  802689:	e8 d8 ec ff ff       	call   801366 <fd_lookup>
  80268e:	85 c0                	test   %eax,%eax
  802690:	78 17                	js     8026a9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 0d ac 57 80 00    	mov    0x8057ac,%ecx
  80269b:	39 08                	cmp    %ecx,(%eax)
  80269d:	75 05                	jne    8026a4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80269f:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a2:	eb 05                	jmp    8026a9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  8026a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  8026a9:	c9                   	leave  
  8026aa:	c3                   	ret    

008026ab <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  8026ab:	55                   	push   %ebp
  8026ac:	89 e5                	mov    %esp,%ebp
  8026ae:	56                   	push   %esi
  8026af:	53                   	push   %ebx
  8026b0:	83 ec 20             	sub    $0x20,%esp
  8026b3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8026b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026b8:	89 04 24             	mov    %eax,(%esp)
  8026bb:	e8 57 ec ff ff       	call   801317 <fd_alloc>
  8026c0:	89 c3                	mov    %eax,%ebx
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	78 21                	js     8026e7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8026c6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026cd:	00 
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026dc:	e8 c2 e8 ff ff       	call   800fa3 <sys_page_alloc>
  8026e1:	89 c3                	mov    %eax,%ebx
  8026e3:	85 c0                	test   %eax,%eax
  8026e5:	79 0c                	jns    8026f3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8026e7:	89 34 24             	mov    %esi,(%esp)
  8026ea:	e8 51 02 00 00       	call   802940 <nsipc_close>
		return r;
  8026ef:	89 d8                	mov    %ebx,%eax
  8026f1:	eb 20                	jmp    802713 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8026f3:	8b 15 ac 57 80 00    	mov    0x8057ac,%edx
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8026fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802701:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802708:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80270b:	89 14 24             	mov    %edx,(%esp)
  80270e:	e8 dd eb ff ff       	call   8012f0 <fd2num>
}
  802713:	83 c4 20             	add    $0x20,%esp
  802716:	5b                   	pop    %ebx
  802717:	5e                   	pop    %esi
  802718:	5d                   	pop    %ebp
  802719:	c3                   	ret    

0080271a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80271a:	55                   	push   %ebp
  80271b:	89 e5                	mov    %esp,%ebp
  80271d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802720:	8b 45 08             	mov    0x8(%ebp),%eax
  802723:	e8 51 ff ff ff       	call   802679 <fd2sockid>
		return r;
  802728:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80272a:	85 c0                	test   %eax,%eax
  80272c:	78 23                	js     802751 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80272e:	8b 55 10             	mov    0x10(%ebp),%edx
  802731:	89 54 24 08          	mov    %edx,0x8(%esp)
  802735:	8b 55 0c             	mov    0xc(%ebp),%edx
  802738:	89 54 24 04          	mov    %edx,0x4(%esp)
  80273c:	89 04 24             	mov    %eax,(%esp)
  80273f:	e8 45 01 00 00       	call   802889 <nsipc_accept>
		return r;
  802744:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802746:	85 c0                	test   %eax,%eax
  802748:	78 07                	js     802751 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80274a:	e8 5c ff ff ff       	call   8026ab <alloc_sockfd>
  80274f:	89 c1                	mov    %eax,%ecx
}
  802751:	89 c8                	mov    %ecx,%eax
  802753:	c9                   	leave  
  802754:	c3                   	ret    

00802755 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
  802758:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80275b:	8b 45 08             	mov    0x8(%ebp),%eax
  80275e:	e8 16 ff ff ff       	call   802679 <fd2sockid>
  802763:	89 c2                	mov    %eax,%edx
  802765:	85 d2                	test   %edx,%edx
  802767:	78 16                	js     80277f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802769:	8b 45 10             	mov    0x10(%ebp),%eax
  80276c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802770:	8b 45 0c             	mov    0xc(%ebp),%eax
  802773:	89 44 24 04          	mov    %eax,0x4(%esp)
  802777:	89 14 24             	mov    %edx,(%esp)
  80277a:	e8 60 01 00 00       	call   8028df <nsipc_bind>
}
  80277f:	c9                   	leave  
  802780:	c3                   	ret    

00802781 <shutdown>:

int
shutdown(int s, int how)
{
  802781:	55                   	push   %ebp
  802782:	89 e5                	mov    %esp,%ebp
  802784:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802787:	8b 45 08             	mov    0x8(%ebp),%eax
  80278a:	e8 ea fe ff ff       	call   802679 <fd2sockid>
  80278f:	89 c2                	mov    %eax,%edx
  802791:	85 d2                	test   %edx,%edx
  802793:	78 0f                	js     8027a4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802795:	8b 45 0c             	mov    0xc(%ebp),%eax
  802798:	89 44 24 04          	mov    %eax,0x4(%esp)
  80279c:	89 14 24             	mov    %edx,(%esp)
  80279f:	e8 7a 01 00 00       	call   80291e <nsipc_shutdown>
}
  8027a4:	c9                   	leave  
  8027a5:	c3                   	ret    

008027a6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8027a6:	55                   	push   %ebp
  8027a7:	89 e5                	mov    %esp,%ebp
  8027a9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8027ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8027af:	e8 c5 fe ff ff       	call   802679 <fd2sockid>
  8027b4:	89 c2                	mov    %eax,%edx
  8027b6:	85 d2                	test   %edx,%edx
  8027b8:	78 16                	js     8027d0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8027ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8027bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c8:	89 14 24             	mov    %edx,(%esp)
  8027cb:	e8 8a 01 00 00       	call   80295a <nsipc_connect>
}
  8027d0:	c9                   	leave  
  8027d1:	c3                   	ret    

008027d2 <listen>:

int
listen(int s, int backlog)
{
  8027d2:	55                   	push   %ebp
  8027d3:	89 e5                	mov    %esp,%ebp
  8027d5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8027d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027db:	e8 99 fe ff ff       	call   802679 <fd2sockid>
  8027e0:	89 c2                	mov    %eax,%edx
  8027e2:	85 d2                	test   %edx,%edx
  8027e4:	78 0f                	js     8027f5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8027e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ed:	89 14 24             	mov    %edx,(%esp)
  8027f0:	e8 a4 01 00 00       	call   802999 <nsipc_listen>
}
  8027f5:	c9                   	leave  
  8027f6:	c3                   	ret    

008027f7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8027f7:	55                   	push   %ebp
  8027f8:	89 e5                	mov    %esp,%ebp
  8027fa:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8027fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802800:	89 44 24 08          	mov    %eax,0x8(%esp)
  802804:	8b 45 0c             	mov    0xc(%ebp),%eax
  802807:	89 44 24 04          	mov    %eax,0x4(%esp)
  80280b:	8b 45 08             	mov    0x8(%ebp),%eax
  80280e:	89 04 24             	mov    %eax,(%esp)
  802811:	e8 98 02 00 00       	call   802aae <nsipc_socket>
  802816:	89 c2                	mov    %eax,%edx
  802818:	85 d2                	test   %edx,%edx
  80281a:	78 05                	js     802821 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80281c:	e8 8a fe ff ff       	call   8026ab <alloc_sockfd>
}
  802821:	c9                   	leave  
  802822:	c3                   	ret    

00802823 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802823:	55                   	push   %ebp
  802824:	89 e5                	mov    %esp,%ebp
  802826:	53                   	push   %ebx
  802827:	83 ec 14             	sub    $0x14,%esp
  80282a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80282c:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  802833:	75 11                	jne    802846 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802835:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80283c:	e8 74 07 00 00       	call   802fb5 <ipc_find_env>
  802841:	a3 04 60 80 00       	mov    %eax,0x806004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802846:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80284d:	00 
  80284e:	c7 44 24 08 00 a0 80 	movl   $0x80a000,0x8(%esp)
  802855:	00 
  802856:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80285a:	a1 04 60 80 00       	mov    0x806004,%eax
  80285f:	89 04 24             	mov    %eax,(%esp)
  802862:	e8 c1 06 00 00       	call   802f28 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802867:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80286e:	00 
  80286f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802876:	00 
  802877:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80287e:	e8 3d 06 00 00       	call   802ec0 <ipc_recv>
}
  802883:	83 c4 14             	add    $0x14,%esp
  802886:	5b                   	pop    %ebx
  802887:	5d                   	pop    %ebp
  802888:	c3                   	ret    

00802889 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802889:	55                   	push   %ebp
  80288a:	89 e5                	mov    %esp,%ebp
  80288c:	56                   	push   %esi
  80288d:	53                   	push   %ebx
  80288e:	83 ec 10             	sub    $0x10,%esp
  802891:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802894:	8b 45 08             	mov    0x8(%ebp),%eax
  802897:	a3 00 a0 80 00       	mov    %eax,0x80a000
	nsipcbuf.accept.req_addrlen = *addrlen;
  80289c:	8b 06                	mov    (%esi),%eax
  80289e:	a3 04 a0 80 00       	mov    %eax,0x80a004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8028a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8028a8:	e8 76 ff ff ff       	call   802823 <nsipc>
  8028ad:	89 c3                	mov    %eax,%ebx
  8028af:	85 c0                	test   %eax,%eax
  8028b1:	78 23                	js     8028d6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8028b3:	a1 10 a0 80 00       	mov    0x80a010,%eax
  8028b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028bc:	c7 44 24 04 00 a0 80 	movl   $0x80a000,0x4(%esp)
  8028c3:	00 
  8028c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028c7:	89 04 24             	mov    %eax,(%esp)
  8028ca:	e8 55 e4 ff ff       	call   800d24 <memmove>
		*addrlen = ret->ret_addrlen;
  8028cf:	a1 10 a0 80 00       	mov    0x80a010,%eax
  8028d4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8028d6:	89 d8                	mov    %ebx,%eax
  8028d8:	83 c4 10             	add    $0x10,%esp
  8028db:	5b                   	pop    %ebx
  8028dc:	5e                   	pop    %esi
  8028dd:	5d                   	pop    %ebp
  8028de:	c3                   	ret    

008028df <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8028df:	55                   	push   %ebp
  8028e0:	89 e5                	mov    %esp,%ebp
  8028e2:	53                   	push   %ebx
  8028e3:	83 ec 14             	sub    $0x14,%esp
  8028e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ec:	a3 00 a0 80 00       	mov    %eax,0x80a000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8028f1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028fc:	c7 04 24 04 a0 80 00 	movl   $0x80a004,(%esp)
  802903:	e8 1c e4 ff ff       	call   800d24 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802908:	89 1d 14 a0 80 00    	mov    %ebx,0x80a014
	return nsipc(NSREQ_BIND);
  80290e:	b8 02 00 00 00       	mov    $0x2,%eax
  802913:	e8 0b ff ff ff       	call   802823 <nsipc>
}
  802918:	83 c4 14             	add    $0x14,%esp
  80291b:	5b                   	pop    %ebx
  80291c:	5d                   	pop    %ebp
  80291d:	c3                   	ret    

0080291e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80291e:	55                   	push   %ebp
  80291f:	89 e5                	mov    %esp,%ebp
  802921:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802924:	8b 45 08             	mov    0x8(%ebp),%eax
  802927:	a3 00 a0 80 00       	mov    %eax,0x80a000
	nsipcbuf.shutdown.req_how = how;
  80292c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80292f:	a3 04 a0 80 00       	mov    %eax,0x80a004
	return nsipc(NSREQ_SHUTDOWN);
  802934:	b8 03 00 00 00       	mov    $0x3,%eax
  802939:	e8 e5 fe ff ff       	call   802823 <nsipc>
}
  80293e:	c9                   	leave  
  80293f:	c3                   	ret    

00802940 <nsipc_close>:

int
nsipc_close(int s)
{
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
  802943:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	a3 00 a0 80 00       	mov    %eax,0x80a000
	return nsipc(NSREQ_CLOSE);
  80294e:	b8 04 00 00 00       	mov    $0x4,%eax
  802953:	e8 cb fe ff ff       	call   802823 <nsipc>
}
  802958:	c9                   	leave  
  802959:	c3                   	ret    

0080295a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80295a:	55                   	push   %ebp
  80295b:	89 e5                	mov    %esp,%ebp
  80295d:	53                   	push   %ebx
  80295e:	83 ec 14             	sub    $0x14,%esp
  802961:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802964:	8b 45 08             	mov    0x8(%ebp),%eax
  802967:	a3 00 a0 80 00       	mov    %eax,0x80a000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80296c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802970:	8b 45 0c             	mov    0xc(%ebp),%eax
  802973:	89 44 24 04          	mov    %eax,0x4(%esp)
  802977:	c7 04 24 04 a0 80 00 	movl   $0x80a004,(%esp)
  80297e:	e8 a1 e3 ff ff       	call   800d24 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802983:	89 1d 14 a0 80 00    	mov    %ebx,0x80a014
	return nsipc(NSREQ_CONNECT);
  802989:	b8 05 00 00 00       	mov    $0x5,%eax
  80298e:	e8 90 fe ff ff       	call   802823 <nsipc>
}
  802993:	83 c4 14             	add    $0x14,%esp
  802996:	5b                   	pop    %ebx
  802997:	5d                   	pop    %ebp
  802998:	c3                   	ret    

00802999 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802999:	55                   	push   %ebp
  80299a:	89 e5                	mov    %esp,%ebp
  80299c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80299f:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a2:	a3 00 a0 80 00       	mov    %eax,0x80a000
	nsipcbuf.listen.req_backlog = backlog;
  8029a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029aa:	a3 04 a0 80 00       	mov    %eax,0x80a004
	return nsipc(NSREQ_LISTEN);
  8029af:	b8 06 00 00 00       	mov    $0x6,%eax
  8029b4:	e8 6a fe ff ff       	call   802823 <nsipc>
}
  8029b9:	c9                   	leave  
  8029ba:	c3                   	ret    

008029bb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8029bb:	55                   	push   %ebp
  8029bc:	89 e5                	mov    %esp,%ebp
  8029be:	56                   	push   %esi
  8029bf:	53                   	push   %ebx
  8029c0:	83 ec 10             	sub    $0x10,%esp
  8029c3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	a3 00 a0 80 00       	mov    %eax,0x80a000
	nsipcbuf.recv.req_len = len;
  8029ce:	89 35 04 a0 80 00    	mov    %esi,0x80a004
	nsipcbuf.recv.req_flags = flags;
  8029d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8029d7:	a3 08 a0 80 00       	mov    %eax,0x80a008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8029dc:	b8 07 00 00 00       	mov    $0x7,%eax
  8029e1:	e8 3d fe ff ff       	call   802823 <nsipc>
  8029e6:	89 c3                	mov    %eax,%ebx
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	78 46                	js     802a32 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8029ec:	39 f0                	cmp    %esi,%eax
  8029ee:	7f 07                	jg     8029f7 <nsipc_recv+0x3c>
  8029f0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8029f5:	7e 24                	jle    802a1b <nsipc_recv+0x60>
  8029f7:	c7 44 24 0c 0c 39 80 	movl   $0x80390c,0xc(%esp)
  8029fe:	00 
  8029ff:	c7 44 24 08 0b 38 80 	movl   $0x80380b,0x8(%esp)
  802a06:	00 
  802a07:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  802a0e:	00 
  802a0f:	c7 04 24 21 39 80 00 	movl   $0x803921,(%esp)
  802a16:	e8 4c da ff ff       	call   800467 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802a1b:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a1f:	c7 44 24 04 00 a0 80 	movl   $0x80a000,0x4(%esp)
  802a26:	00 
  802a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a2a:	89 04 24             	mov    %eax,(%esp)
  802a2d:	e8 f2 e2 ff ff       	call   800d24 <memmove>
	}

	return r;
}
  802a32:	89 d8                	mov    %ebx,%eax
  802a34:	83 c4 10             	add    $0x10,%esp
  802a37:	5b                   	pop    %ebx
  802a38:	5e                   	pop    %esi
  802a39:	5d                   	pop    %ebp
  802a3a:	c3                   	ret    

00802a3b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802a3b:	55                   	push   %ebp
  802a3c:	89 e5                	mov    %esp,%ebp
  802a3e:	53                   	push   %ebx
  802a3f:	83 ec 14             	sub    $0x14,%esp
  802a42:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802a45:	8b 45 08             	mov    0x8(%ebp),%eax
  802a48:	a3 00 a0 80 00       	mov    %eax,0x80a000
	assert(size < 1600);
  802a4d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802a53:	7e 24                	jle    802a79 <nsipc_send+0x3e>
  802a55:	c7 44 24 0c 2d 39 80 	movl   $0x80392d,0xc(%esp)
  802a5c:	00 
  802a5d:	c7 44 24 08 0b 38 80 	movl   $0x80380b,0x8(%esp)
  802a64:	00 
  802a65:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  802a6c:	00 
  802a6d:	c7 04 24 21 39 80 00 	movl   $0x803921,(%esp)
  802a74:	e8 ee d9 ff ff       	call   800467 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802a79:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a80:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a84:	c7 04 24 0c a0 80 00 	movl   $0x80a00c,(%esp)
  802a8b:	e8 94 e2 ff ff       	call   800d24 <memmove>
	nsipcbuf.send.req_size = size;
  802a90:	89 1d 04 a0 80 00    	mov    %ebx,0x80a004
	nsipcbuf.send.req_flags = flags;
  802a96:	8b 45 14             	mov    0x14(%ebp),%eax
  802a99:	a3 08 a0 80 00       	mov    %eax,0x80a008
	return nsipc(NSREQ_SEND);
  802a9e:	b8 08 00 00 00       	mov    $0x8,%eax
  802aa3:	e8 7b fd ff ff       	call   802823 <nsipc>
}
  802aa8:	83 c4 14             	add    $0x14,%esp
  802aab:	5b                   	pop    %ebx
  802aac:	5d                   	pop    %ebp
  802aad:	c3                   	ret    

00802aae <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802aae:	55                   	push   %ebp
  802aaf:	89 e5                	mov    %esp,%ebp
  802ab1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	a3 00 a0 80 00       	mov    %eax,0x80a000
	nsipcbuf.socket.req_type = type;
  802abc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802abf:	a3 04 a0 80 00       	mov    %eax,0x80a004
	nsipcbuf.socket.req_protocol = protocol;
  802ac4:	8b 45 10             	mov    0x10(%ebp),%eax
  802ac7:	a3 08 a0 80 00       	mov    %eax,0x80a008
	return nsipc(NSREQ_SOCKET);
  802acc:	b8 09 00 00 00       	mov    $0x9,%eax
  802ad1:	e8 4d fd ff ff       	call   802823 <nsipc>
}
  802ad6:	c9                   	leave  
  802ad7:	c3                   	ret    

00802ad8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802ad8:	55                   	push   %ebp
  802ad9:	89 e5                	mov    %esp,%ebp
  802adb:	56                   	push   %esi
  802adc:	53                   	push   %ebx
  802add:	83 ec 10             	sub    $0x10,%esp
  802ae0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	89 04 24             	mov    %eax,(%esp)
  802ae9:	e8 12 e8 ff ff       	call   801300 <fd2data>
  802aee:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802af0:	c7 44 24 04 39 39 80 	movl   $0x803939,0x4(%esp)
  802af7:	00 
  802af8:	89 1c 24             	mov    %ebx,(%esp)
  802afb:	e8 87 e0 ff ff       	call   800b87 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802b00:	8b 46 04             	mov    0x4(%esi),%eax
  802b03:	2b 06                	sub    (%esi),%eax
  802b05:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802b0b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802b12:	00 00 00 
	stat->st_dev = &devpipe;
  802b15:	c7 83 88 00 00 00 c8 	movl   $0x8057c8,0x88(%ebx)
  802b1c:	57 80 00 
	return 0;
}
  802b1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b24:	83 c4 10             	add    $0x10,%esp
  802b27:	5b                   	pop    %ebx
  802b28:	5e                   	pop    %esi
  802b29:	5d                   	pop    %ebp
  802b2a:	c3                   	ret    

00802b2b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802b2b:	55                   	push   %ebp
  802b2c:	89 e5                	mov    %esp,%ebp
  802b2e:	53                   	push   %ebx
  802b2f:	83 ec 14             	sub    $0x14,%esp
  802b32:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802b35:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802b39:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b40:	e8 05 e5 ff ff       	call   80104a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802b45:	89 1c 24             	mov    %ebx,(%esp)
  802b48:	e8 b3 e7 ff ff       	call   801300 <fd2data>
  802b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b58:	e8 ed e4 ff ff       	call   80104a <sys_page_unmap>
}
  802b5d:	83 c4 14             	add    $0x14,%esp
  802b60:	5b                   	pop    %ebx
  802b61:	5d                   	pop    %ebp
  802b62:	c3                   	ret    

00802b63 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802b63:	55                   	push   %ebp
  802b64:	89 e5                	mov    %esp,%ebp
  802b66:	57                   	push   %edi
  802b67:	56                   	push   %esi
  802b68:	53                   	push   %ebx
  802b69:	83 ec 2c             	sub    $0x2c,%esp
  802b6c:	89 c6                	mov    %eax,%esi
  802b6e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802b71:	a1 90 77 80 00       	mov    0x807790,%eax
  802b76:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802b79:	89 34 24             	mov    %esi,(%esp)
  802b7c:	e8 6e 04 00 00       	call   802fef <pageref>
  802b81:	89 c7                	mov    %eax,%edi
  802b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b86:	89 04 24             	mov    %eax,(%esp)
  802b89:	e8 61 04 00 00       	call   802fef <pageref>
  802b8e:	39 c7                	cmp    %eax,%edi
  802b90:	0f 94 c2             	sete   %dl
  802b93:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802b96:	8b 0d 90 77 80 00    	mov    0x807790,%ecx
  802b9c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802b9f:	39 fb                	cmp    %edi,%ebx
  802ba1:	74 21                	je     802bc4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802ba3:	84 d2                	test   %dl,%dl
  802ba5:	74 ca                	je     802b71 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802ba7:	8b 51 58             	mov    0x58(%ecx),%edx
  802baa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bae:	89 54 24 08          	mov    %edx,0x8(%esp)
  802bb2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802bb6:	c7 04 24 40 39 80 00 	movl   $0x803940,(%esp)
  802bbd:	e8 9e d9 ff ff       	call   800560 <cprintf>
  802bc2:	eb ad                	jmp    802b71 <_pipeisclosed+0xe>
	}
}
  802bc4:	83 c4 2c             	add    $0x2c,%esp
  802bc7:	5b                   	pop    %ebx
  802bc8:	5e                   	pop    %esi
  802bc9:	5f                   	pop    %edi
  802bca:	5d                   	pop    %ebp
  802bcb:	c3                   	ret    

00802bcc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802bcc:	55                   	push   %ebp
  802bcd:	89 e5                	mov    %esp,%ebp
  802bcf:	57                   	push   %edi
  802bd0:	56                   	push   %esi
  802bd1:	53                   	push   %ebx
  802bd2:	83 ec 1c             	sub    $0x1c,%esp
  802bd5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802bd8:	89 34 24             	mov    %esi,(%esp)
  802bdb:	e8 20 e7 ff ff       	call   801300 <fd2data>
  802be0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802be2:	bf 00 00 00 00       	mov    $0x0,%edi
  802be7:	eb 45                	jmp    802c2e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802be9:	89 da                	mov    %ebx,%edx
  802beb:	89 f0                	mov    %esi,%eax
  802bed:	e8 71 ff ff ff       	call   802b63 <_pipeisclosed>
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	75 41                	jne    802c37 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802bf6:	e8 89 e3 ff ff       	call   800f84 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802bfb:	8b 43 04             	mov    0x4(%ebx),%eax
  802bfe:	8b 0b                	mov    (%ebx),%ecx
  802c00:	8d 51 20             	lea    0x20(%ecx),%edx
  802c03:	39 d0                	cmp    %edx,%eax
  802c05:	73 e2                	jae    802be9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802c07:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c0a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  802c0e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802c11:	99                   	cltd   
  802c12:	c1 ea 1b             	shr    $0x1b,%edx
  802c15:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802c18:	83 e1 1f             	and    $0x1f,%ecx
  802c1b:	29 d1                	sub    %edx,%ecx
  802c1d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802c21:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802c25:	83 c0 01             	add    $0x1,%eax
  802c28:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802c2b:	83 c7 01             	add    $0x1,%edi
  802c2e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802c31:	75 c8                	jne    802bfb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802c33:	89 f8                	mov    %edi,%eax
  802c35:	eb 05                	jmp    802c3c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802c37:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  802c3c:	83 c4 1c             	add    $0x1c,%esp
  802c3f:	5b                   	pop    %ebx
  802c40:	5e                   	pop    %esi
  802c41:	5f                   	pop    %edi
  802c42:	5d                   	pop    %ebp
  802c43:	c3                   	ret    

00802c44 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802c44:	55                   	push   %ebp
  802c45:	89 e5                	mov    %esp,%ebp
  802c47:	57                   	push   %edi
  802c48:	56                   	push   %esi
  802c49:	53                   	push   %ebx
  802c4a:	83 ec 1c             	sub    $0x1c,%esp
  802c4d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802c50:	89 3c 24             	mov    %edi,(%esp)
  802c53:	e8 a8 e6 ff ff       	call   801300 <fd2data>
  802c58:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802c5a:	be 00 00 00 00       	mov    $0x0,%esi
  802c5f:	eb 3d                	jmp    802c9e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802c61:	85 f6                	test   %esi,%esi
  802c63:	74 04                	je     802c69 <devpipe_read+0x25>
				return i;
  802c65:	89 f0                	mov    %esi,%eax
  802c67:	eb 43                	jmp    802cac <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802c69:	89 da                	mov    %ebx,%edx
  802c6b:	89 f8                	mov    %edi,%eax
  802c6d:	e8 f1 fe ff ff       	call   802b63 <_pipeisclosed>
  802c72:	85 c0                	test   %eax,%eax
  802c74:	75 31                	jne    802ca7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802c76:	e8 09 e3 ff ff       	call   800f84 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802c7b:	8b 03                	mov    (%ebx),%eax
  802c7d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802c80:	74 df                	je     802c61 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802c82:	99                   	cltd   
  802c83:	c1 ea 1b             	shr    $0x1b,%edx
  802c86:	01 d0                	add    %edx,%eax
  802c88:	83 e0 1f             	and    $0x1f,%eax
  802c8b:	29 d0                	sub    %edx,%eax
  802c8d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802c92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c95:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802c98:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802c9b:	83 c6 01             	add    $0x1,%esi
  802c9e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802ca1:	75 d8                	jne    802c7b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802ca3:	89 f0                	mov    %esi,%eax
  802ca5:	eb 05                	jmp    802cac <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802ca7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802cac:	83 c4 1c             	add    $0x1c,%esp
  802caf:	5b                   	pop    %ebx
  802cb0:	5e                   	pop    %esi
  802cb1:	5f                   	pop    %edi
  802cb2:	5d                   	pop    %ebp
  802cb3:	c3                   	ret    

00802cb4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802cb4:	55                   	push   %ebp
  802cb5:	89 e5                	mov    %esp,%ebp
  802cb7:	56                   	push   %esi
  802cb8:	53                   	push   %ebx
  802cb9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802cbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802cbf:	89 04 24             	mov    %eax,(%esp)
  802cc2:	e8 50 e6 ff ff       	call   801317 <fd_alloc>
  802cc7:	89 c2                	mov    %eax,%edx
  802cc9:	85 d2                	test   %edx,%edx
  802ccb:	0f 88 4d 01 00 00    	js     802e1e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cd1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802cd8:	00 
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ce0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ce7:	e8 b7 e2 ff ff       	call   800fa3 <sys_page_alloc>
  802cec:	89 c2                	mov    %eax,%edx
  802cee:	85 d2                	test   %edx,%edx
  802cf0:	0f 88 28 01 00 00    	js     802e1e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802cf6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802cf9:	89 04 24             	mov    %eax,(%esp)
  802cfc:	e8 16 e6 ff ff       	call   801317 <fd_alloc>
  802d01:	89 c3                	mov    %eax,%ebx
  802d03:	85 c0                	test   %eax,%eax
  802d05:	0f 88 fe 00 00 00    	js     802e09 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d0b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802d12:	00 
  802d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d16:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d21:	e8 7d e2 ff ff       	call   800fa3 <sys_page_alloc>
  802d26:	89 c3                	mov    %eax,%ebx
  802d28:	85 c0                	test   %eax,%eax
  802d2a:	0f 88 d9 00 00 00    	js     802e09 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	89 04 24             	mov    %eax,(%esp)
  802d36:	e8 c5 e5 ff ff       	call   801300 <fd2data>
  802d3b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d3d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802d44:	00 
  802d45:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d50:	e8 4e e2 ff ff       	call   800fa3 <sys_page_alloc>
  802d55:	89 c3                	mov    %eax,%ebx
  802d57:	85 c0                	test   %eax,%eax
  802d59:	0f 88 97 00 00 00    	js     802df6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d62:	89 04 24             	mov    %eax,(%esp)
  802d65:	e8 96 e5 ff ff       	call   801300 <fd2data>
  802d6a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802d71:	00 
  802d72:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d76:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802d7d:	00 
  802d7e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d89:	e8 69 e2 ff ff       	call   800ff7 <sys_page_map>
  802d8e:	89 c3                	mov    %eax,%ebx
  802d90:	85 c0                	test   %eax,%eax
  802d92:	78 52                	js     802de6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802d94:	8b 15 c8 57 80 00    	mov    0x8057c8,%edx
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802da9:	8b 15 c8 57 80 00    	mov    0x8057c8,%edx
  802daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	89 04 24             	mov    %eax,(%esp)
  802dc4:	e8 27 e5 ff ff       	call   8012f0 <fd2num>
  802dc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dcc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd1:	89 04 24             	mov    %eax,(%esp)
  802dd4:	e8 17 e5 ff ff       	call   8012f0 <fd2num>
  802dd9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802ddc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802ddf:	b8 00 00 00 00       	mov    $0x0,%eax
  802de4:	eb 38                	jmp    802e1e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802de6:	89 74 24 04          	mov    %esi,0x4(%esp)
  802dea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802df1:	e8 54 e2 ff ff       	call   80104a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df9:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dfd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e04:	e8 41 e2 ff ff       	call   80104a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e17:	e8 2e e2 ff ff       	call   80104a <sys_page_unmap>
  802e1c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802e1e:	83 c4 30             	add    $0x30,%esp
  802e21:	5b                   	pop    %ebx
  802e22:	5e                   	pop    %esi
  802e23:	5d                   	pop    %ebp
  802e24:	c3                   	ret    

00802e25 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802e25:	55                   	push   %ebp
  802e26:	89 e5                	mov    %esp,%ebp
  802e28:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e32:	8b 45 08             	mov    0x8(%ebp),%eax
  802e35:	89 04 24             	mov    %eax,(%esp)
  802e38:	e8 29 e5 ff ff       	call   801366 <fd_lookup>
  802e3d:	89 c2                	mov    %eax,%edx
  802e3f:	85 d2                	test   %edx,%edx
  802e41:	78 15                	js     802e58 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	89 04 24             	mov    %eax,(%esp)
  802e49:	e8 b2 e4 ff ff       	call   801300 <fd2data>
	return _pipeisclosed(fd, p);
  802e4e:	89 c2                	mov    %eax,%edx
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	e8 0b fd ff ff       	call   802b63 <_pipeisclosed>
}
  802e58:	c9                   	leave  
  802e59:	c3                   	ret    

00802e5a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802e5a:	55                   	push   %ebp
  802e5b:	89 e5                	mov    %esp,%ebp
  802e5d:	56                   	push   %esi
  802e5e:	53                   	push   %ebx
  802e5f:	83 ec 10             	sub    $0x10,%esp
  802e62:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802e65:	85 f6                	test   %esi,%esi
  802e67:	75 24                	jne    802e8d <wait+0x33>
  802e69:	c7 44 24 0c 58 39 80 	movl   $0x803958,0xc(%esp)
  802e70:	00 
  802e71:	c7 44 24 08 0b 38 80 	movl   $0x80380b,0x8(%esp)
  802e78:	00 
  802e79:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802e80:	00 
  802e81:	c7 04 24 63 39 80 00 	movl   $0x803963,(%esp)
  802e88:	e8 da d5 ff ff       	call   800467 <_panic>
	e = &envs[ENVX(envid)];
  802e8d:	89 f3                	mov    %esi,%ebx
  802e8f:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802e95:	c1 e3 07             	shl    $0x7,%ebx
  802e98:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802e9e:	eb 05                	jmp    802ea5 <wait+0x4b>
		sys_yield();
  802ea0:	e8 df e0 ff ff       	call   800f84 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802ea5:	8b 43 48             	mov    0x48(%ebx),%eax
  802ea8:	39 f0                	cmp    %esi,%eax
  802eaa:	75 07                	jne    802eb3 <wait+0x59>
  802eac:	8b 43 54             	mov    0x54(%ebx),%eax
  802eaf:	85 c0                	test   %eax,%eax
  802eb1:	75 ed                	jne    802ea0 <wait+0x46>
		sys_yield();
}
  802eb3:	83 c4 10             	add    $0x10,%esp
  802eb6:	5b                   	pop    %ebx
  802eb7:	5e                   	pop    %esi
  802eb8:	5d                   	pop    %ebp
  802eb9:	c3                   	ret    
  802eba:	66 90                	xchg   %ax,%ax
  802ebc:	66 90                	xchg   %ax,%ax
  802ebe:	66 90                	xchg   %ax,%ax

00802ec0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802ec0:	55                   	push   %ebp
  802ec1:	89 e5                	mov    %esp,%ebp
  802ec3:	56                   	push   %esi
  802ec4:	53                   	push   %ebx
  802ec5:	83 ec 10             	sub    $0x10,%esp
  802ec8:	8b 75 08             	mov    0x8(%ebp),%esi
  802ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ece:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802ed1:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802ed3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802ed8:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  802edb:	89 04 24             	mov    %eax,(%esp)
  802ede:	e8 d6 e2 ff ff       	call   8011b9 <sys_ipc_recv>
  802ee3:	85 c0                	test   %eax,%eax
  802ee5:	74 16                	je     802efd <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802ee7:	85 f6                	test   %esi,%esi
  802ee9:	74 06                	je     802ef1 <ipc_recv+0x31>
			*from_env_store = 0;
  802eeb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802ef1:	85 db                	test   %ebx,%ebx
  802ef3:	74 2c                	je     802f21 <ipc_recv+0x61>
			*perm_store = 0;
  802ef5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802efb:	eb 24                	jmp    802f21 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  802efd:	85 f6                	test   %esi,%esi
  802eff:	74 0a                	je     802f0b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802f01:	a1 90 77 80 00       	mov    0x807790,%eax
  802f06:	8b 40 74             	mov    0x74(%eax),%eax
  802f09:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  802f0b:	85 db                	test   %ebx,%ebx
  802f0d:	74 0a                	je     802f19 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  802f0f:	a1 90 77 80 00       	mov    0x807790,%eax
  802f14:	8b 40 78             	mov    0x78(%eax),%eax
  802f17:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  802f19:	a1 90 77 80 00       	mov    0x807790,%eax
  802f1e:	8b 40 70             	mov    0x70(%eax),%eax
}
  802f21:	83 c4 10             	add    $0x10,%esp
  802f24:	5b                   	pop    %ebx
  802f25:	5e                   	pop    %esi
  802f26:	5d                   	pop    %ebp
  802f27:	c3                   	ret    

00802f28 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802f28:	55                   	push   %ebp
  802f29:	89 e5                	mov    %esp,%ebp
  802f2b:	57                   	push   %edi
  802f2c:	56                   	push   %esi
  802f2d:	53                   	push   %ebx
  802f2e:	83 ec 1c             	sub    $0x1c,%esp
  802f31:	8b 75 0c             	mov    0xc(%ebp),%esi
  802f34:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802f37:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  802f3a:	85 db                	test   %ebx,%ebx
  802f3c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802f41:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  802f44:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f48:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f4c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	89 04 24             	mov    %eax,(%esp)
  802f56:	e8 3b e2 ff ff       	call   801196 <sys_ipc_try_send>
	if (r == 0) return;
  802f5b:	85 c0                	test   %eax,%eax
  802f5d:	75 22                	jne    802f81 <ipc_send+0x59>
  802f5f:	eb 4c                	jmp    802fad <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  802f61:	84 d2                	test   %dl,%dl
  802f63:	75 48                	jne    802fad <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  802f65:	e8 1a e0 ff ff       	call   800f84 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  802f6a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802f6e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f72:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	89 04 24             	mov    %eax,(%esp)
  802f7c:	e8 15 e2 ff ff       	call   801196 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802f81:	85 c0                	test   %eax,%eax
  802f83:	0f 94 c2             	sete   %dl
  802f86:	74 d9                	je     802f61 <ipc_send+0x39>
  802f88:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802f8b:	74 d4                	je     802f61 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  802f8d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f91:	c7 44 24 08 6e 39 80 	movl   $0x80396e,0x8(%esp)
  802f98:	00 
  802f99:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802fa0:	00 
  802fa1:	c7 04 24 7c 39 80 00 	movl   $0x80397c,(%esp)
  802fa8:	e8 ba d4 ff ff       	call   800467 <_panic>
}
  802fad:	83 c4 1c             	add    $0x1c,%esp
  802fb0:	5b                   	pop    %ebx
  802fb1:	5e                   	pop    %esi
  802fb2:	5f                   	pop    %edi
  802fb3:	5d                   	pop    %ebp
  802fb4:	c3                   	ret    

00802fb5 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802fb5:	55                   	push   %ebp
  802fb6:	89 e5                	mov    %esp,%ebp
  802fb8:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802fbb:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802fc0:	89 c2                	mov    %eax,%edx
  802fc2:	c1 e2 07             	shl    $0x7,%edx
  802fc5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802fcb:	8b 52 50             	mov    0x50(%edx),%edx
  802fce:	39 ca                	cmp    %ecx,%edx
  802fd0:	75 0d                	jne    802fdf <ipc_find_env+0x2a>
			return envs[i].env_id;
  802fd2:	c1 e0 07             	shl    $0x7,%eax
  802fd5:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802fda:	8b 40 40             	mov    0x40(%eax),%eax
  802fdd:	eb 0e                	jmp    802fed <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802fdf:	83 c0 01             	add    $0x1,%eax
  802fe2:	3d 00 04 00 00       	cmp    $0x400,%eax
  802fe7:	75 d7                	jne    802fc0 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802fe9:	66 b8 00 00          	mov    $0x0,%ax
}
  802fed:	5d                   	pop    %ebp
  802fee:	c3                   	ret    

00802fef <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802fef:	55                   	push   %ebp
  802ff0:	89 e5                	mov    %esp,%ebp
  802ff2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802ff5:	89 d0                	mov    %edx,%eax
  802ff7:	c1 e8 16             	shr    $0x16,%eax
  802ffa:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  803001:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803006:	f6 c1 01             	test   $0x1,%cl
  803009:	74 1d                	je     803028 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80300b:	c1 ea 0c             	shr    $0xc,%edx
  80300e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803015:	f6 c2 01             	test   $0x1,%dl
  803018:	74 0e                	je     803028 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80301a:	c1 ea 0c             	shr    $0xc,%edx
  80301d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803024:	ef 
  803025:	0f b7 c0             	movzwl %ax,%eax
}
  803028:	5d                   	pop    %ebp
  803029:	c3                   	ret    
  80302a:	66 90                	xchg   %ax,%ax
  80302c:	66 90                	xchg   %ax,%ax
  80302e:	66 90                	xchg   %ax,%ax

00803030 <__udivdi3>:
  803030:	55                   	push   %ebp
  803031:	57                   	push   %edi
  803032:	56                   	push   %esi
  803033:	83 ec 0c             	sub    $0xc,%esp
  803036:	8b 44 24 28          	mov    0x28(%esp),%eax
  80303a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80303e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  803042:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803046:	85 c0                	test   %eax,%eax
  803048:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80304c:	89 ea                	mov    %ebp,%edx
  80304e:	89 0c 24             	mov    %ecx,(%esp)
  803051:	75 2d                	jne    803080 <__udivdi3+0x50>
  803053:	39 e9                	cmp    %ebp,%ecx
  803055:	77 61                	ja     8030b8 <__udivdi3+0x88>
  803057:	85 c9                	test   %ecx,%ecx
  803059:	89 ce                	mov    %ecx,%esi
  80305b:	75 0b                	jne    803068 <__udivdi3+0x38>
  80305d:	b8 01 00 00 00       	mov    $0x1,%eax
  803062:	31 d2                	xor    %edx,%edx
  803064:	f7 f1                	div    %ecx
  803066:	89 c6                	mov    %eax,%esi
  803068:	31 d2                	xor    %edx,%edx
  80306a:	89 e8                	mov    %ebp,%eax
  80306c:	f7 f6                	div    %esi
  80306e:	89 c5                	mov    %eax,%ebp
  803070:	89 f8                	mov    %edi,%eax
  803072:	f7 f6                	div    %esi
  803074:	89 ea                	mov    %ebp,%edx
  803076:	83 c4 0c             	add    $0xc,%esp
  803079:	5e                   	pop    %esi
  80307a:	5f                   	pop    %edi
  80307b:	5d                   	pop    %ebp
  80307c:	c3                   	ret    
  80307d:	8d 76 00             	lea    0x0(%esi),%esi
  803080:	39 e8                	cmp    %ebp,%eax
  803082:	77 24                	ja     8030a8 <__udivdi3+0x78>
  803084:	0f bd e8             	bsr    %eax,%ebp
  803087:	83 f5 1f             	xor    $0x1f,%ebp
  80308a:	75 3c                	jne    8030c8 <__udivdi3+0x98>
  80308c:	8b 74 24 04          	mov    0x4(%esp),%esi
  803090:	39 34 24             	cmp    %esi,(%esp)
  803093:	0f 86 9f 00 00 00    	jbe    803138 <__udivdi3+0x108>
  803099:	39 d0                	cmp    %edx,%eax
  80309b:	0f 82 97 00 00 00    	jb     803138 <__udivdi3+0x108>
  8030a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8030a8:	31 d2                	xor    %edx,%edx
  8030aa:	31 c0                	xor    %eax,%eax
  8030ac:	83 c4 0c             	add    $0xc,%esp
  8030af:	5e                   	pop    %esi
  8030b0:	5f                   	pop    %edi
  8030b1:	5d                   	pop    %ebp
  8030b2:	c3                   	ret    
  8030b3:	90                   	nop
  8030b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8030b8:	89 f8                	mov    %edi,%eax
  8030ba:	f7 f1                	div    %ecx
  8030bc:	31 d2                	xor    %edx,%edx
  8030be:	83 c4 0c             	add    $0xc,%esp
  8030c1:	5e                   	pop    %esi
  8030c2:	5f                   	pop    %edi
  8030c3:	5d                   	pop    %ebp
  8030c4:	c3                   	ret    
  8030c5:	8d 76 00             	lea    0x0(%esi),%esi
  8030c8:	89 e9                	mov    %ebp,%ecx
  8030ca:	8b 3c 24             	mov    (%esp),%edi
  8030cd:	d3 e0                	shl    %cl,%eax
  8030cf:	89 c6                	mov    %eax,%esi
  8030d1:	b8 20 00 00 00       	mov    $0x20,%eax
  8030d6:	29 e8                	sub    %ebp,%eax
  8030d8:	89 c1                	mov    %eax,%ecx
  8030da:	d3 ef                	shr    %cl,%edi
  8030dc:	89 e9                	mov    %ebp,%ecx
  8030de:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8030e2:	8b 3c 24             	mov    (%esp),%edi
  8030e5:	09 74 24 08          	or     %esi,0x8(%esp)
  8030e9:	89 d6                	mov    %edx,%esi
  8030eb:	d3 e7                	shl    %cl,%edi
  8030ed:	89 c1                	mov    %eax,%ecx
  8030ef:	89 3c 24             	mov    %edi,(%esp)
  8030f2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8030f6:	d3 ee                	shr    %cl,%esi
  8030f8:	89 e9                	mov    %ebp,%ecx
  8030fa:	d3 e2                	shl    %cl,%edx
  8030fc:	89 c1                	mov    %eax,%ecx
  8030fe:	d3 ef                	shr    %cl,%edi
  803100:	09 d7                	or     %edx,%edi
  803102:	89 f2                	mov    %esi,%edx
  803104:	89 f8                	mov    %edi,%eax
  803106:	f7 74 24 08          	divl   0x8(%esp)
  80310a:	89 d6                	mov    %edx,%esi
  80310c:	89 c7                	mov    %eax,%edi
  80310e:	f7 24 24             	mull   (%esp)
  803111:	39 d6                	cmp    %edx,%esi
  803113:	89 14 24             	mov    %edx,(%esp)
  803116:	72 30                	jb     803148 <__udivdi3+0x118>
  803118:	8b 54 24 04          	mov    0x4(%esp),%edx
  80311c:	89 e9                	mov    %ebp,%ecx
  80311e:	d3 e2                	shl    %cl,%edx
  803120:	39 c2                	cmp    %eax,%edx
  803122:	73 05                	jae    803129 <__udivdi3+0xf9>
  803124:	3b 34 24             	cmp    (%esp),%esi
  803127:	74 1f                	je     803148 <__udivdi3+0x118>
  803129:	89 f8                	mov    %edi,%eax
  80312b:	31 d2                	xor    %edx,%edx
  80312d:	e9 7a ff ff ff       	jmp    8030ac <__udivdi3+0x7c>
  803132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803138:	31 d2                	xor    %edx,%edx
  80313a:	b8 01 00 00 00       	mov    $0x1,%eax
  80313f:	e9 68 ff ff ff       	jmp    8030ac <__udivdi3+0x7c>
  803144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803148:	8d 47 ff             	lea    -0x1(%edi),%eax
  80314b:	31 d2                	xor    %edx,%edx
  80314d:	83 c4 0c             	add    $0xc,%esp
  803150:	5e                   	pop    %esi
  803151:	5f                   	pop    %edi
  803152:	5d                   	pop    %ebp
  803153:	c3                   	ret    
  803154:	66 90                	xchg   %ax,%ax
  803156:	66 90                	xchg   %ax,%ax
  803158:	66 90                	xchg   %ax,%ax
  80315a:	66 90                	xchg   %ax,%ax
  80315c:	66 90                	xchg   %ax,%ax
  80315e:	66 90                	xchg   %ax,%ax

00803160 <__umoddi3>:
  803160:	55                   	push   %ebp
  803161:	57                   	push   %edi
  803162:	56                   	push   %esi
  803163:	83 ec 14             	sub    $0x14,%esp
  803166:	8b 44 24 28          	mov    0x28(%esp),%eax
  80316a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80316e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803172:	89 c7                	mov    %eax,%edi
  803174:	89 44 24 04          	mov    %eax,0x4(%esp)
  803178:	8b 44 24 30          	mov    0x30(%esp),%eax
  80317c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803180:	89 34 24             	mov    %esi,(%esp)
  803183:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803187:	85 c0                	test   %eax,%eax
  803189:	89 c2                	mov    %eax,%edx
  80318b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80318f:	75 17                	jne    8031a8 <__umoddi3+0x48>
  803191:	39 fe                	cmp    %edi,%esi
  803193:	76 4b                	jbe    8031e0 <__umoddi3+0x80>
  803195:	89 c8                	mov    %ecx,%eax
  803197:	89 fa                	mov    %edi,%edx
  803199:	f7 f6                	div    %esi
  80319b:	89 d0                	mov    %edx,%eax
  80319d:	31 d2                	xor    %edx,%edx
  80319f:	83 c4 14             	add    $0x14,%esp
  8031a2:	5e                   	pop    %esi
  8031a3:	5f                   	pop    %edi
  8031a4:	5d                   	pop    %ebp
  8031a5:	c3                   	ret    
  8031a6:	66 90                	xchg   %ax,%ax
  8031a8:	39 f8                	cmp    %edi,%eax
  8031aa:	77 54                	ja     803200 <__umoddi3+0xa0>
  8031ac:	0f bd e8             	bsr    %eax,%ebp
  8031af:	83 f5 1f             	xor    $0x1f,%ebp
  8031b2:	75 5c                	jne    803210 <__umoddi3+0xb0>
  8031b4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8031b8:	39 3c 24             	cmp    %edi,(%esp)
  8031bb:	0f 87 e7 00 00 00    	ja     8032a8 <__umoddi3+0x148>
  8031c1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8031c5:	29 f1                	sub    %esi,%ecx
  8031c7:	19 c7                	sbb    %eax,%edi
  8031c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031d1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031d5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8031d9:	83 c4 14             	add    $0x14,%esp
  8031dc:	5e                   	pop    %esi
  8031dd:	5f                   	pop    %edi
  8031de:	5d                   	pop    %ebp
  8031df:	c3                   	ret    
  8031e0:	85 f6                	test   %esi,%esi
  8031e2:	89 f5                	mov    %esi,%ebp
  8031e4:	75 0b                	jne    8031f1 <__umoddi3+0x91>
  8031e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8031eb:	31 d2                	xor    %edx,%edx
  8031ed:	f7 f6                	div    %esi
  8031ef:	89 c5                	mov    %eax,%ebp
  8031f1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031f5:	31 d2                	xor    %edx,%edx
  8031f7:	f7 f5                	div    %ebp
  8031f9:	89 c8                	mov    %ecx,%eax
  8031fb:	f7 f5                	div    %ebp
  8031fd:	eb 9c                	jmp    80319b <__umoddi3+0x3b>
  8031ff:	90                   	nop
  803200:	89 c8                	mov    %ecx,%eax
  803202:	89 fa                	mov    %edi,%edx
  803204:	83 c4 14             	add    $0x14,%esp
  803207:	5e                   	pop    %esi
  803208:	5f                   	pop    %edi
  803209:	5d                   	pop    %ebp
  80320a:	c3                   	ret    
  80320b:	90                   	nop
  80320c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803210:	8b 04 24             	mov    (%esp),%eax
  803213:	be 20 00 00 00       	mov    $0x20,%esi
  803218:	89 e9                	mov    %ebp,%ecx
  80321a:	29 ee                	sub    %ebp,%esi
  80321c:	d3 e2                	shl    %cl,%edx
  80321e:	89 f1                	mov    %esi,%ecx
  803220:	d3 e8                	shr    %cl,%eax
  803222:	89 e9                	mov    %ebp,%ecx
  803224:	89 44 24 04          	mov    %eax,0x4(%esp)
  803228:	8b 04 24             	mov    (%esp),%eax
  80322b:	09 54 24 04          	or     %edx,0x4(%esp)
  80322f:	89 fa                	mov    %edi,%edx
  803231:	d3 e0                	shl    %cl,%eax
  803233:	89 f1                	mov    %esi,%ecx
  803235:	89 44 24 08          	mov    %eax,0x8(%esp)
  803239:	8b 44 24 10          	mov    0x10(%esp),%eax
  80323d:	d3 ea                	shr    %cl,%edx
  80323f:	89 e9                	mov    %ebp,%ecx
  803241:	d3 e7                	shl    %cl,%edi
  803243:	89 f1                	mov    %esi,%ecx
  803245:	d3 e8                	shr    %cl,%eax
  803247:	89 e9                	mov    %ebp,%ecx
  803249:	09 f8                	or     %edi,%eax
  80324b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80324f:	f7 74 24 04          	divl   0x4(%esp)
  803253:	d3 e7                	shl    %cl,%edi
  803255:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803259:	89 d7                	mov    %edx,%edi
  80325b:	f7 64 24 08          	mull   0x8(%esp)
  80325f:	39 d7                	cmp    %edx,%edi
  803261:	89 c1                	mov    %eax,%ecx
  803263:	89 14 24             	mov    %edx,(%esp)
  803266:	72 2c                	jb     803294 <__umoddi3+0x134>
  803268:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80326c:	72 22                	jb     803290 <__umoddi3+0x130>
  80326e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803272:	29 c8                	sub    %ecx,%eax
  803274:	19 d7                	sbb    %edx,%edi
  803276:	89 e9                	mov    %ebp,%ecx
  803278:	89 fa                	mov    %edi,%edx
  80327a:	d3 e8                	shr    %cl,%eax
  80327c:	89 f1                	mov    %esi,%ecx
  80327e:	d3 e2                	shl    %cl,%edx
  803280:	89 e9                	mov    %ebp,%ecx
  803282:	d3 ef                	shr    %cl,%edi
  803284:	09 d0                	or     %edx,%eax
  803286:	89 fa                	mov    %edi,%edx
  803288:	83 c4 14             	add    $0x14,%esp
  80328b:	5e                   	pop    %esi
  80328c:	5f                   	pop    %edi
  80328d:	5d                   	pop    %ebp
  80328e:	c3                   	ret    
  80328f:	90                   	nop
  803290:	39 d7                	cmp    %edx,%edi
  803292:	75 da                	jne    80326e <__umoddi3+0x10e>
  803294:	8b 14 24             	mov    (%esp),%edx
  803297:	89 c1                	mov    %eax,%ecx
  803299:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80329d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8032a1:	eb cb                	jmp    80326e <__umoddi3+0x10e>
  8032a3:	90                   	nop
  8032a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8032a8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8032ac:	0f 82 0f ff ff ff    	jb     8031c1 <__umoddi3+0x61>
  8032b2:	e9 1a ff ff ff       	jmp    8031d1 <__umoddi3+0x71>
