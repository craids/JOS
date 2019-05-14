
obj/user/testkbd.debug:     file format elf32-i386


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
  80002c:	e8 95 02 00 00       	call   8002c6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
  80003a:	bb 0a 00 00 00       	mov    $0xa,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  80003f:	e8 f0 0e 00 00       	call   800f34 <sys_yield>
umain(int argc, char **argv)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800044:	83 eb 01             	sub    $0x1,%ebx
  800047:	75 f6                	jne    80003f <umain+0xc>
		sys_yield();

	close(0);
  800049:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800050:	e8 f2 13 00 00       	call   801447 <close>
	if ((r = opencons()) < 0)
  800055:	e8 11 02 00 00       	call   80026b <opencons>
  80005a:	85 c0                	test   %eax,%eax
  80005c:	79 20                	jns    80007e <umain+0x4b>
		panic("opencons: %e", r);
  80005e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800062:	c7 44 24 08 60 29 80 	movl   $0x802960,0x8(%esp)
  800069:	00 
  80006a:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800071:	00 
  800072:	c7 04 24 6d 29 80 00 	movl   $0x80296d,(%esp)
  800079:	e8 a9 02 00 00       	call   800327 <_panic>
	if (r != 0)
  80007e:	85 c0                	test   %eax,%eax
  800080:	74 20                	je     8000a2 <umain+0x6f>
		panic("first opencons used fd %d", r);
  800082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800086:	c7 44 24 08 7c 29 80 	movl   $0x80297c,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 6d 29 80 00 	movl   $0x80296d,(%esp)
  80009d:	e8 85 02 00 00       	call   800327 <_panic>
	if ((r = dup(0, 1)) < 0)
  8000a2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8000a9:	00 
  8000aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b1:	e8 e6 13 00 00       	call   80149c <dup>
  8000b6:	85 c0                	test   %eax,%eax
  8000b8:	79 20                	jns    8000da <umain+0xa7>
		panic("dup: %e", r);
  8000ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000be:	c7 44 24 08 96 29 80 	movl   $0x802996,0x8(%esp)
  8000c5:	00 
  8000c6:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000cd:	00 
  8000ce:	c7 04 24 6d 29 80 00 	movl   $0x80296d,(%esp)
  8000d5:	e8 4d 02 00 00       	call   800327 <_panic>

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  8000da:	c7 04 24 9e 29 80 00 	movl   $0x80299e,(%esp)
  8000e1:	e8 2a 09 00 00       	call   800a10 <readline>
		if (buf != NULL)
  8000e6:	85 c0                	test   %eax,%eax
  8000e8:	74 1a                	je     800104 <umain+0xd1>
			fprintf(1, "%s\n", buf);
  8000ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000ee:	c7 44 24 04 ac 29 80 	movl   $0x8029ac,0x4(%esp)
  8000f5:	00 
  8000f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000fd:	e8 6c 1b 00 00       	call   801c6e <fprintf>
  800102:	eb d6                	jmp    8000da <umain+0xa7>
		else
			fprintf(1, "(end of file received)\n");
  800104:	c7 44 24 04 b0 29 80 	movl   $0x8029b0,0x4(%esp)
  80010b:	00 
  80010c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800113:	e8 56 1b 00 00       	call   801c6e <fprintf>
  800118:	eb c0                	jmp    8000da <umain+0xa7>
  80011a:	66 90                	xchg   %ax,%ax
  80011c:	66 90                	xchg   %ax,%ax
  80011e:	66 90                	xchg   %ax,%ax

00800120 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800123:	b8 00 00 00 00       	mov    $0x0,%eax
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800130:	c7 44 24 04 c8 29 80 	movl   $0x8029c8,0x4(%esp)
  800137:	00 
  800138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013b:	89 04 24             	mov    %eax,(%esp)
  80013e:	e8 f4 09 00 00       	call   800b37 <strcpy>
	return 0;
}
  800143:	b8 00 00 00 00       	mov    $0x0,%eax
  800148:	c9                   	leave  
  800149:	c3                   	ret    

0080014a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	57                   	push   %edi
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
  800150:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800156:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80015b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800161:	eb 31                	jmp    800194 <devcons_write+0x4a>
		m = n - tot;
  800163:	8b 75 10             	mov    0x10(%ebp),%esi
  800166:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  800168:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80016b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  800170:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800173:	89 74 24 08          	mov    %esi,0x8(%esp)
  800177:	03 45 0c             	add    0xc(%ebp),%eax
  80017a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017e:	89 3c 24             	mov    %edi,(%esp)
  800181:	e8 4e 0b 00 00       	call   800cd4 <memmove>
		sys_cputs(buf, m);
  800186:	89 74 24 04          	mov    %esi,0x4(%esp)
  80018a:	89 3c 24             	mov    %edi,(%esp)
  80018d:	e8 f4 0c 00 00       	call   800e86 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800192:	01 f3                	add    %esi,%ebx
  800194:	89 d8                	mov    %ebx,%eax
  800196:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800199:	72 c8                	jb     800163 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80019b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8001a1:	5b                   	pop    %ebx
  8001a2:	5e                   	pop    %esi
  8001a3:	5f                   	pop    %edi
  8001a4:	5d                   	pop    %ebp
  8001a5:	c3                   	ret    

008001a6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8001a6:	55                   	push   %ebp
  8001a7:	89 e5                	mov    %esp,%ebp
  8001a9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8001ac:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8001b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8001b5:	75 07                	jne    8001be <devcons_read+0x18>
  8001b7:	eb 2a                	jmp    8001e3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8001b9:	e8 76 0d 00 00       	call   800f34 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8001be:	66 90                	xchg   %ax,%ax
  8001c0:	e8 df 0c 00 00       	call   800ea4 <sys_cgetc>
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	74 f0                	je     8001b9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8001c9:	85 c0                	test   %eax,%eax
  8001cb:	78 16                	js     8001e3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8001cd:	83 f8 04             	cmp    $0x4,%eax
  8001d0:	74 0c                	je     8001de <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8001d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d5:	88 02                	mov    %al,(%edx)
	return 1;
  8001d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8001dc:	eb 05                	jmp    8001e3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8001de:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8001e3:	c9                   	leave  
  8001e4:	c3                   	ret    

008001e5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001e5:	55                   	push   %ebp
  8001e6:	89 e5                	mov    %esp,%ebp
  8001e8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8001eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001f8:	00 
  8001f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001fc:	89 04 24             	mov    %eax,(%esp)
  8001ff:	e8 82 0c 00 00       	call   800e86 <sys_cputs>
}
  800204:	c9                   	leave  
  800205:	c3                   	ret    

00800206 <getchar>:

int
getchar(void)
{
  800206:	55                   	push   %ebp
  800207:	89 e5                	mov    %esp,%ebp
  800209:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80020c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800213:	00 
  800214:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800217:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800222:	e8 83 13 00 00       	call   8015aa <read>
	if (r < 0)
  800227:	85 c0                	test   %eax,%eax
  800229:	78 0f                	js     80023a <getchar+0x34>
		return r;
	if (r < 1)
  80022b:	85 c0                	test   %eax,%eax
  80022d:	7e 06                	jle    800235 <getchar+0x2f>
		return -E_EOF;
	return c;
  80022f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  800233:	eb 05                	jmp    80023a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  800235:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80023a:	c9                   	leave  
  80023b:	c3                   	ret    

0080023c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800242:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800245:	89 44 24 04          	mov    %eax,0x4(%esp)
  800249:	8b 45 08             	mov    0x8(%ebp),%eax
  80024c:	89 04 24             	mov    %eax,(%esp)
  80024f:	e8 c2 10 00 00       	call   801316 <fd_lookup>
  800254:	85 c0                	test   %eax,%eax
  800256:	78 11                	js     800269 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80025b:	8b 15 00 30 80 00    	mov    0x803000,%edx
  800261:	39 10                	cmp    %edx,(%eax)
  800263:	0f 94 c0             	sete   %al
  800266:	0f b6 c0             	movzbl %al,%eax
}
  800269:	c9                   	leave  
  80026a:	c3                   	ret    

0080026b <opencons>:

int
opencons(void)
{
  80026b:	55                   	push   %ebp
  80026c:	89 e5                	mov    %esp,%ebp
  80026e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800271:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800274:	89 04 24             	mov    %eax,(%esp)
  800277:	e8 4b 10 00 00       	call   8012c7 <fd_alloc>
		return r;
  80027c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80027e:	85 c0                	test   %eax,%eax
  800280:	78 40                	js     8002c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800282:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800289:	00 
  80028a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80028d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800291:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800298:	e8 b6 0c 00 00       	call   800f53 <sys_page_alloc>
		return r;
  80029d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	78 1f                	js     8002c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8002a3:	8b 15 00 30 80 00    	mov    0x803000,%edx
  8002a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8002ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8002b8:	89 04 24             	mov    %eax,(%esp)
  8002bb:	e8 e0 0f 00 00       	call   8012a0 <fd2num>
  8002c0:	89 c2                	mov    %eax,%edx
}
  8002c2:	89 d0                	mov    %edx,%eax
  8002c4:	c9                   	leave  
  8002c5:	c3                   	ret    

008002c6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8002c6:	55                   	push   %ebp
  8002c7:	89 e5                	mov    %esp,%ebp
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	83 ec 10             	sub    $0x10,%esp
  8002ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002d1:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8002d4:	e8 3c 0c 00 00       	call   800f15 <sys_getenvid>
  8002d9:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002de:	c1 e0 07             	shl    $0x7,%eax
  8002e1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e6:	a3 08 44 80 00       	mov    %eax,0x804408

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002eb:	85 db                	test   %ebx,%ebx
  8002ed:	7e 07                	jle    8002f6 <libmain+0x30>
		binaryname = argv[0];
  8002ef:	8b 06                	mov    (%esi),%eax
  8002f1:	a3 1c 30 80 00       	mov    %eax,0x80301c

	// call user main routine
	umain(argc, argv);
  8002f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002fa:	89 1c 24             	mov    %ebx,(%esp)
  8002fd:	e8 31 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800302:	e8 07 00 00 00       	call   80030e <exit>
}
  800307:	83 c4 10             	add    $0x10,%esp
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5d                   	pop    %ebp
  80030d:	c3                   	ret    

0080030e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80030e:	55                   	push   %ebp
  80030f:	89 e5                	mov    %esp,%ebp
  800311:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800314:	e8 61 11 00 00       	call   80147a <close_all>
	sys_env_destroy(0);
  800319:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800320:	e8 9e 0b 00 00       	call   800ec3 <sys_env_destroy>
}
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	56                   	push   %esi
  80032b:	53                   	push   %ebx
  80032c:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80032f:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800332:	8b 35 1c 30 80 00    	mov    0x80301c,%esi
  800338:	e8 d8 0b 00 00       	call   800f15 <sys_getenvid>
  80033d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800340:	89 54 24 10          	mov    %edx,0x10(%esp)
  800344:	8b 55 08             	mov    0x8(%ebp),%edx
  800347:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80034b:	89 74 24 08          	mov    %esi,0x8(%esp)
  80034f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800353:	c7 04 24 e0 29 80 00 	movl   $0x8029e0,(%esp)
  80035a:	e8 c1 00 00 00       	call   800420 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80035f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800363:	8b 45 10             	mov    0x10(%ebp),%eax
  800366:	89 04 24             	mov    %eax,(%esp)
  800369:	e8 51 00 00 00       	call   8003bf <vcprintf>
	cprintf("\n");
  80036e:	c7 04 24 c6 29 80 00 	movl   $0x8029c6,(%esp)
  800375:	e8 a6 00 00 00       	call   800420 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80037a:	cc                   	int3   
  80037b:	eb fd                	jmp    80037a <_panic+0x53>

0080037d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	53                   	push   %ebx
  800381:	83 ec 14             	sub    $0x14,%esp
  800384:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800387:	8b 13                	mov    (%ebx),%edx
  800389:	8d 42 01             	lea    0x1(%edx),%eax
  80038c:	89 03                	mov    %eax,(%ebx)
  80038e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800391:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800395:	3d ff 00 00 00       	cmp    $0xff,%eax
  80039a:	75 19                	jne    8003b5 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80039c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003a3:	00 
  8003a4:	8d 43 08             	lea    0x8(%ebx),%eax
  8003a7:	89 04 24             	mov    %eax,(%esp)
  8003aa:	e8 d7 0a 00 00       	call   800e86 <sys_cputs>
		b->idx = 0;
  8003af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003b9:	83 c4 14             	add    $0x14,%esp
  8003bc:	5b                   	pop    %ebx
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    

008003bf <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003c8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003cf:	00 00 00 
	b.cnt = 0;
  8003d2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003d9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f4:	c7 04 24 7d 03 80 00 	movl   $0x80037d,(%esp)
  8003fb:	e8 ae 01 00 00       	call   8005ae <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800400:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800406:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800410:	89 04 24             	mov    %eax,(%esp)
  800413:	e8 6e 0a 00 00       	call   800e86 <sys_cputs>

	return b.cnt;
}
  800418:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800426:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800429:	89 44 24 04          	mov    %eax,0x4(%esp)
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	89 04 24             	mov    %eax,(%esp)
  800433:	e8 87 ff ff ff       	call   8003bf <vcprintf>
	va_end(ap);

	return cnt;
}
  800438:	c9                   	leave  
  800439:	c3                   	ret    
  80043a:	66 90                	xchg   %ax,%ax
  80043c:	66 90                	xchg   %ax,%ax
  80043e:	66 90                	xchg   %ax,%ax

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
  8004af:	e8 0c 22 00 00       	call   8026c0 <__udivdi3>
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
  80050f:	e8 dc 22 00 00       	call   8027f0 <__umoddi3>
  800514:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800518:	0f be 80 03 2a 80 00 	movsbl 0x802a03(%eax),%eax
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
  800633:	ff 24 8d 40 2b 80 00 	jmp    *0x802b40(,%ecx,4)
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
  8006d0:	8b 14 85 a0 2c 80 00 	mov    0x802ca0(,%eax,4),%edx
  8006d7:	85 d2                	test   %edx,%edx
  8006d9:	75 20                	jne    8006fb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8006db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006df:	c7 44 24 08 1b 2a 80 	movl   $0x802a1b,0x8(%esp)
  8006e6:	00 
  8006e7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	89 04 24             	mov    %eax,(%esp)
  8006f1:	e8 90 fe ff ff       	call   800586 <printfmt>
  8006f6:	e9 d8 fe ff ff       	jmp    8005d3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8006fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006ff:	c7 44 24 08 f1 2d 80 	movl   $0x802df1,0x8(%esp)
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
  800731:	b8 14 2a 80 00       	mov    $0x802a14,%eax
  800736:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800739:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80073d:	0f 84 97 00 00 00    	je     8007da <vprintfmt+0x22c>
  800743:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800747:	0f 8e 9b 00 00 00    	jle    8007e8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80074d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800751:	89 34 24             	mov    %esi,(%esp)
  800754:	e8 bf 03 00 00       	call   800b18 <strnlen>
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

00800a10 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	57                   	push   %edi
  800a14:	56                   	push   %esi
  800a15:	53                   	push   %ebx
  800a16:	83 ec 1c             	sub    $0x1c,%esp
  800a19:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800a1c:	85 c0                	test   %eax,%eax
  800a1e:	74 18                	je     800a38 <readline+0x28>
		fprintf(1, "%s", prompt);
  800a20:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a24:	c7 44 24 04 f1 2d 80 	movl   $0x802df1,0x4(%esp)
  800a2b:	00 
  800a2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a33:	e8 36 12 00 00       	call   801c6e <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  800a38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a3f:	e8 f8 f7 ff ff       	call   80023c <iscons>
  800a44:	89 c7                	mov    %eax,%edi
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
  800a46:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
  800a4b:	e8 b6 f7 ff ff       	call   800206 <getchar>
  800a50:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800a52:	85 c0                	test   %eax,%eax
  800a54:	79 25                	jns    800a7b <readline+0x6b>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  800a56:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  800a5b:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800a5e:	0f 84 88 00 00 00    	je     800aec <readline+0xdc>
				cprintf("read error: %e\n", c);
  800a64:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a68:	c7 04 24 07 2d 80 00 	movl   $0x802d07,(%esp)
  800a6f:	e8 ac f9 ff ff       	call   800420 <cprintf>
			return NULL;
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
  800a79:	eb 71                	jmp    800aec <readline+0xdc>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800a7b:	83 f8 7f             	cmp    $0x7f,%eax
  800a7e:	74 05                	je     800a85 <readline+0x75>
  800a80:	83 f8 08             	cmp    $0x8,%eax
  800a83:	75 19                	jne    800a9e <readline+0x8e>
  800a85:	85 f6                	test   %esi,%esi
  800a87:	7e 15                	jle    800a9e <readline+0x8e>
			if (echoing)
  800a89:	85 ff                	test   %edi,%edi
  800a8b:	74 0c                	je     800a99 <readline+0x89>
				cputchar('\b');
  800a8d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  800a94:	e8 4c f7 ff ff       	call   8001e5 <cputchar>
			i--;
  800a99:	83 ee 01             	sub    $0x1,%esi
  800a9c:	eb ad                	jmp    800a4b <readline+0x3b>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a9e:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800aa4:	7f 1c                	jg     800ac2 <readline+0xb2>
  800aa6:	83 fb 1f             	cmp    $0x1f,%ebx
  800aa9:	7e 17                	jle    800ac2 <readline+0xb2>
			if (echoing)
  800aab:	85 ff                	test   %edi,%edi
  800aad:	74 08                	je     800ab7 <readline+0xa7>
				cputchar(c);
  800aaf:	89 1c 24             	mov    %ebx,(%esp)
  800ab2:	e8 2e f7 ff ff       	call   8001e5 <cputchar>
			buf[i++] = c;
  800ab7:	88 9e 00 40 80 00    	mov    %bl,0x804000(%esi)
  800abd:	8d 76 01             	lea    0x1(%esi),%esi
  800ac0:	eb 89                	jmp    800a4b <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  800ac2:	83 fb 0d             	cmp    $0xd,%ebx
  800ac5:	74 09                	je     800ad0 <readline+0xc0>
  800ac7:	83 fb 0a             	cmp    $0xa,%ebx
  800aca:	0f 85 7b ff ff ff    	jne    800a4b <readline+0x3b>
			if (echoing)
  800ad0:	85 ff                	test   %edi,%edi
  800ad2:	74 0c                	je     800ae0 <readline+0xd0>
				cputchar('\n');
  800ad4:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800adb:	e8 05 f7 ff ff       	call   8001e5 <cputchar>
			buf[i] = 0;
  800ae0:	c6 86 00 40 80 00 00 	movb   $0x0,0x804000(%esi)
			return buf;
  800ae7:	b8 00 40 80 00       	mov    $0x804000,%eax
		}
	}
}
  800aec:	83 c4 1c             	add    $0x1c,%esp
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5f                   	pop    %edi
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    
  800af4:	66 90                	xchg   %ax,%ax
  800af6:	66 90                	xchg   %ax,%ax
  800af8:	66 90                	xchg   %ax,%ax
  800afa:	66 90                	xchg   %ax,%ax
  800afc:	66 90                	xchg   %ax,%ax
  800afe:	66 90                	xchg   %ax,%ax

00800b00 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b06:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0b:	eb 03                	jmp    800b10 <strlen+0x10>
		n++;
  800b0d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b10:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b14:	75 f7                	jne    800b0d <strlen+0xd>
		n++;
	return n;
}
  800b16:	5d                   	pop    %ebp
  800b17:	c3                   	ret    

00800b18 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b21:	b8 00 00 00 00       	mov    $0x0,%eax
  800b26:	eb 03                	jmp    800b2b <strnlen+0x13>
		n++;
  800b28:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b2b:	39 d0                	cmp    %edx,%eax
  800b2d:	74 06                	je     800b35 <strnlen+0x1d>
  800b2f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b33:	75 f3                	jne    800b28 <strnlen+0x10>
		n++;
	return n;
}
  800b35:	5d                   	pop    %ebp
  800b36:	c3                   	ret    

00800b37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	53                   	push   %ebx
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b41:	89 c2                	mov    %eax,%edx
  800b43:	83 c2 01             	add    $0x1,%edx
  800b46:	83 c1 01             	add    $0x1,%ecx
  800b49:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800b4d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b50:	84 db                	test   %bl,%bl
  800b52:	75 ef                	jne    800b43 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800b54:	5b                   	pop    %ebx
  800b55:	5d                   	pop    %ebp
  800b56:	c3                   	ret    

00800b57 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	53                   	push   %ebx
  800b5b:	83 ec 08             	sub    $0x8,%esp
  800b5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b61:	89 1c 24             	mov    %ebx,(%esp)
  800b64:	e8 97 ff ff ff       	call   800b00 <strlen>
	strcpy(dst + len, src);
  800b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b70:	01 d8                	add    %ebx,%eax
  800b72:	89 04 24             	mov    %eax,(%esp)
  800b75:	e8 bd ff ff ff       	call   800b37 <strcpy>
	return dst;
}
  800b7a:	89 d8                	mov    %ebx,%eax
  800b7c:	83 c4 08             	add    $0x8,%esp
  800b7f:	5b                   	pop    %ebx
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	56                   	push   %esi
  800b86:	53                   	push   %ebx
  800b87:	8b 75 08             	mov    0x8(%ebp),%esi
  800b8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b8d:	89 f3                	mov    %esi,%ebx
  800b8f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b92:	89 f2                	mov    %esi,%edx
  800b94:	eb 0f                	jmp    800ba5 <strncpy+0x23>
		*dst++ = *src;
  800b96:	83 c2 01             	add    $0x1,%edx
  800b99:	0f b6 01             	movzbl (%ecx),%eax
  800b9c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b9f:	80 39 01             	cmpb   $0x1,(%ecx)
  800ba2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ba5:	39 da                	cmp    %ebx,%edx
  800ba7:	75 ed                	jne    800b96 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800ba9:	89 f0                	mov    %esi,%eax
  800bab:	5b                   	pop    %ebx
  800bac:	5e                   	pop    %esi
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	56                   	push   %esi
  800bb3:	53                   	push   %ebx
  800bb4:	8b 75 08             	mov    0x8(%ebp),%esi
  800bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800bbd:	89 f0                	mov    %esi,%eax
  800bbf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800bc3:	85 c9                	test   %ecx,%ecx
  800bc5:	75 0b                	jne    800bd2 <strlcpy+0x23>
  800bc7:	eb 1d                	jmp    800be6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800bc9:	83 c0 01             	add    $0x1,%eax
  800bcc:	83 c2 01             	add    $0x1,%edx
  800bcf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bd2:	39 d8                	cmp    %ebx,%eax
  800bd4:	74 0b                	je     800be1 <strlcpy+0x32>
  800bd6:	0f b6 0a             	movzbl (%edx),%ecx
  800bd9:	84 c9                	test   %cl,%cl
  800bdb:	75 ec                	jne    800bc9 <strlcpy+0x1a>
  800bdd:	89 c2                	mov    %eax,%edx
  800bdf:	eb 02                	jmp    800be3 <strlcpy+0x34>
  800be1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800be3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800be6:	29 f0                	sub    %esi,%eax
}
  800be8:	5b                   	pop    %ebx
  800be9:	5e                   	pop    %esi
  800bea:	5d                   	pop    %ebp
  800beb:	c3                   	ret    

00800bec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bf5:	eb 06                	jmp    800bfd <strcmp+0x11>
		p++, q++;
  800bf7:	83 c1 01             	add    $0x1,%ecx
  800bfa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bfd:	0f b6 01             	movzbl (%ecx),%eax
  800c00:	84 c0                	test   %al,%al
  800c02:	74 04                	je     800c08 <strcmp+0x1c>
  800c04:	3a 02                	cmp    (%edx),%al
  800c06:	74 ef                	je     800bf7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c08:	0f b6 c0             	movzbl %al,%eax
  800c0b:	0f b6 12             	movzbl (%edx),%edx
  800c0e:	29 d0                	sub    %edx,%eax
}
  800c10:	5d                   	pop    %ebp
  800c11:	c3                   	ret    

00800c12 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	53                   	push   %ebx
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1c:	89 c3                	mov    %eax,%ebx
  800c1e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800c21:	eb 06                	jmp    800c29 <strncmp+0x17>
		n--, p++, q++;
  800c23:	83 c0 01             	add    $0x1,%eax
  800c26:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c29:	39 d8                	cmp    %ebx,%eax
  800c2b:	74 15                	je     800c42 <strncmp+0x30>
  800c2d:	0f b6 08             	movzbl (%eax),%ecx
  800c30:	84 c9                	test   %cl,%cl
  800c32:	74 04                	je     800c38 <strncmp+0x26>
  800c34:	3a 0a                	cmp    (%edx),%cl
  800c36:	74 eb                	je     800c23 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c38:	0f b6 00             	movzbl (%eax),%eax
  800c3b:	0f b6 12             	movzbl (%edx),%edx
  800c3e:	29 d0                	sub    %edx,%eax
  800c40:	eb 05                	jmp    800c47 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800c42:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c47:	5b                   	pop    %ebx
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    

00800c4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c54:	eb 07                	jmp    800c5d <strchr+0x13>
		if (*s == c)
  800c56:	38 ca                	cmp    %cl,%dl
  800c58:	74 0f                	je     800c69 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c5a:	83 c0 01             	add    $0x1,%eax
  800c5d:	0f b6 10             	movzbl (%eax),%edx
  800c60:	84 d2                	test   %dl,%dl
  800c62:	75 f2                	jne    800c56 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800c64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    

00800c6b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c75:	eb 07                	jmp    800c7e <strfind+0x13>
		if (*s == c)
  800c77:	38 ca                	cmp    %cl,%dl
  800c79:	74 0a                	je     800c85 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c7b:	83 c0 01             	add    $0x1,%eax
  800c7e:	0f b6 10             	movzbl (%eax),%edx
  800c81:	84 d2                	test   %dl,%dl
  800c83:	75 f2                	jne    800c77 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800c85:	5d                   	pop    %ebp
  800c86:	c3                   	ret    

00800c87 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	57                   	push   %edi
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
  800c8d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c93:	85 c9                	test   %ecx,%ecx
  800c95:	74 36                	je     800ccd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c97:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c9d:	75 28                	jne    800cc7 <memset+0x40>
  800c9f:	f6 c1 03             	test   $0x3,%cl
  800ca2:	75 23                	jne    800cc7 <memset+0x40>
		c &= 0xFF;
  800ca4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ca8:	89 d3                	mov    %edx,%ebx
  800caa:	c1 e3 08             	shl    $0x8,%ebx
  800cad:	89 d6                	mov    %edx,%esi
  800caf:	c1 e6 18             	shl    $0x18,%esi
  800cb2:	89 d0                	mov    %edx,%eax
  800cb4:	c1 e0 10             	shl    $0x10,%eax
  800cb7:	09 f0                	or     %esi,%eax
  800cb9:	09 c2                	or     %eax,%edx
  800cbb:	89 d0                	mov    %edx,%eax
  800cbd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800cbf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800cc2:	fc                   	cld    
  800cc3:	f3 ab                	rep stos %eax,%es:(%edi)
  800cc5:	eb 06                	jmp    800ccd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	fc                   	cld    
  800ccb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ccd:	89 f8                	mov    %edi,%eax
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cdf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ce2:	39 c6                	cmp    %eax,%esi
  800ce4:	73 35                	jae    800d1b <memmove+0x47>
  800ce6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ce9:	39 d0                	cmp    %edx,%eax
  800ceb:	73 2e                	jae    800d1b <memmove+0x47>
		s += n;
		d += n;
  800ced:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800cf0:	89 d6                	mov    %edx,%esi
  800cf2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cf4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cfa:	75 13                	jne    800d0f <memmove+0x3b>
  800cfc:	f6 c1 03             	test   $0x3,%cl
  800cff:	75 0e                	jne    800d0f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800d01:	83 ef 04             	sub    $0x4,%edi
  800d04:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d07:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800d0a:	fd                   	std    
  800d0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d0d:	eb 09                	jmp    800d18 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800d0f:	83 ef 01             	sub    $0x1,%edi
  800d12:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d15:	fd                   	std    
  800d16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d18:	fc                   	cld    
  800d19:	eb 1d                	jmp    800d38 <memmove+0x64>
  800d1b:	89 f2                	mov    %esi,%edx
  800d1d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d1f:	f6 c2 03             	test   $0x3,%dl
  800d22:	75 0f                	jne    800d33 <memmove+0x5f>
  800d24:	f6 c1 03             	test   $0x3,%cl
  800d27:	75 0a                	jne    800d33 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800d29:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800d2c:	89 c7                	mov    %eax,%edi
  800d2e:	fc                   	cld    
  800d2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800d31:	eb 05                	jmp    800d38 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d33:	89 c7                	mov    %eax,%edi
  800d35:	fc                   	cld    
  800d36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d38:	5e                   	pop    %esi
  800d39:	5f                   	pop    %edi
  800d3a:	5d                   	pop    %ebp
  800d3b:	c3                   	ret    

00800d3c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800d3c:	55                   	push   %ebp
  800d3d:	89 e5                	mov    %esp,%ebp
  800d3f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d42:	8b 45 10             	mov    0x10(%ebp),%eax
  800d45:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	89 04 24             	mov    %eax,(%esp)
  800d56:	e8 79 ff ff ff       	call   800cd4 <memmove>
}
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	56                   	push   %esi
  800d61:	53                   	push   %ebx
  800d62:	8b 55 08             	mov    0x8(%ebp),%edx
  800d65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d68:	89 d6                	mov    %edx,%esi
  800d6a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d6d:	eb 1a                	jmp    800d89 <memcmp+0x2c>
		if (*s1 != *s2)
  800d6f:	0f b6 02             	movzbl (%edx),%eax
  800d72:	0f b6 19             	movzbl (%ecx),%ebx
  800d75:	38 d8                	cmp    %bl,%al
  800d77:	74 0a                	je     800d83 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800d79:	0f b6 c0             	movzbl %al,%eax
  800d7c:	0f b6 db             	movzbl %bl,%ebx
  800d7f:	29 d8                	sub    %ebx,%eax
  800d81:	eb 0f                	jmp    800d92 <memcmp+0x35>
		s1++, s2++;
  800d83:	83 c2 01             	add    $0x1,%edx
  800d86:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d89:	39 f2                	cmp    %esi,%edx
  800d8b:	75 e2                	jne    800d6f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d92:	5b                   	pop    %ebx
  800d93:	5e                   	pop    %esi
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d9f:	89 c2                	mov    %eax,%edx
  800da1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800da4:	eb 07                	jmp    800dad <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800da6:	38 08                	cmp    %cl,(%eax)
  800da8:	74 07                	je     800db1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800daa:	83 c0 01             	add    $0x1,%eax
  800dad:	39 d0                	cmp    %edx,%eax
  800daf:	72 f5                	jb     800da6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dbf:	eb 03                	jmp    800dc4 <strtol+0x11>
		s++;
  800dc1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dc4:	0f b6 0a             	movzbl (%edx),%ecx
  800dc7:	80 f9 09             	cmp    $0x9,%cl
  800dca:	74 f5                	je     800dc1 <strtol+0xe>
  800dcc:	80 f9 20             	cmp    $0x20,%cl
  800dcf:	74 f0                	je     800dc1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800dd1:	80 f9 2b             	cmp    $0x2b,%cl
  800dd4:	75 0a                	jne    800de0 <strtol+0x2d>
		s++;
  800dd6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800dd9:	bf 00 00 00 00       	mov    $0x0,%edi
  800dde:	eb 11                	jmp    800df1 <strtol+0x3e>
  800de0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800de5:	80 f9 2d             	cmp    $0x2d,%cl
  800de8:	75 07                	jne    800df1 <strtol+0x3e>
		s++, neg = 1;
  800dea:	8d 52 01             	lea    0x1(%edx),%edx
  800ded:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800df1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800df6:	75 15                	jne    800e0d <strtol+0x5a>
  800df8:	80 3a 30             	cmpb   $0x30,(%edx)
  800dfb:	75 10                	jne    800e0d <strtol+0x5a>
  800dfd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e01:	75 0a                	jne    800e0d <strtol+0x5a>
		s += 2, base = 16;
  800e03:	83 c2 02             	add    $0x2,%edx
  800e06:	b8 10 00 00 00       	mov    $0x10,%eax
  800e0b:	eb 10                	jmp    800e1d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800e0d:	85 c0                	test   %eax,%eax
  800e0f:	75 0c                	jne    800e1d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e11:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e13:	80 3a 30             	cmpb   $0x30,(%edx)
  800e16:	75 05                	jne    800e1d <strtol+0x6a>
		s++, base = 8;
  800e18:	83 c2 01             	add    $0x1,%edx
  800e1b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800e1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e22:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e25:	0f b6 0a             	movzbl (%edx),%ecx
  800e28:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800e2b:	89 f0                	mov    %esi,%eax
  800e2d:	3c 09                	cmp    $0x9,%al
  800e2f:	77 08                	ja     800e39 <strtol+0x86>
			dig = *s - '0';
  800e31:	0f be c9             	movsbl %cl,%ecx
  800e34:	83 e9 30             	sub    $0x30,%ecx
  800e37:	eb 20                	jmp    800e59 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800e39:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800e3c:	89 f0                	mov    %esi,%eax
  800e3e:	3c 19                	cmp    $0x19,%al
  800e40:	77 08                	ja     800e4a <strtol+0x97>
			dig = *s - 'a' + 10;
  800e42:	0f be c9             	movsbl %cl,%ecx
  800e45:	83 e9 57             	sub    $0x57,%ecx
  800e48:	eb 0f                	jmp    800e59 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800e4a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800e4d:	89 f0                	mov    %esi,%eax
  800e4f:	3c 19                	cmp    $0x19,%al
  800e51:	77 16                	ja     800e69 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800e53:	0f be c9             	movsbl %cl,%ecx
  800e56:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e59:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800e5c:	7d 0f                	jge    800e6d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800e5e:	83 c2 01             	add    $0x1,%edx
  800e61:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800e65:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800e67:	eb bc                	jmp    800e25 <strtol+0x72>
  800e69:	89 d8                	mov    %ebx,%eax
  800e6b:	eb 02                	jmp    800e6f <strtol+0xbc>
  800e6d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800e6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e73:	74 05                	je     800e7a <strtol+0xc7>
		*endptr = (char *) s;
  800e75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e78:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800e7a:	f7 d8                	neg    %eax
  800e7c:	85 ff                	test   %edi,%edi
  800e7e:	0f 44 c3             	cmove  %ebx,%eax
}
  800e81:	5b                   	pop    %ebx
  800e82:	5e                   	pop    %esi
  800e83:	5f                   	pop    %edi
  800e84:	5d                   	pop    %ebp
  800e85:	c3                   	ret    

00800e86 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
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
  800e8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	89 c3                	mov    %eax,%ebx
  800e99:	89 c7                	mov    %eax,%edi
  800e9b:	89 c6                	mov    %eax,%esi
  800e9d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e9f:	5b                   	pop    %ebx
  800ea0:	5e                   	pop    %esi
  800ea1:	5f                   	pop    %edi
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    

00800ea4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	57                   	push   %edi
  800ea8:	56                   	push   %esi
  800ea9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eaa:	ba 00 00 00 00       	mov    $0x0,%edx
  800eaf:	b8 01 00 00 00       	mov    $0x1,%eax
  800eb4:	89 d1                	mov    %edx,%ecx
  800eb6:	89 d3                	mov    %edx,%ebx
  800eb8:	89 d7                	mov    %edx,%edi
  800eba:	89 d6                	mov    %edx,%esi
  800ebc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  800ecc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed1:	b8 03 00 00 00       	mov    $0x3,%eax
  800ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed9:	89 cb                	mov    %ecx,%ebx
  800edb:	89 cf                	mov    %ecx,%edi
  800edd:	89 ce                	mov    %ecx,%esi
  800edf:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800ee1:	85 c0                	test   %eax,%eax
  800ee3:	7e 28                	jle    800f0d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ef0:	00 
  800ef1:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  800ef8:	00 
  800ef9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f00:	00 
  800f01:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  800f08:	e8 1a f4 ff ff       	call   800327 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f0d:	83 c4 2c             	add    $0x2c,%esp
  800f10:	5b                   	pop    %ebx
  800f11:	5e                   	pop    %esi
  800f12:	5f                   	pop    %edi
  800f13:	5d                   	pop    %ebp
  800f14:	c3                   	ret    

00800f15 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	57                   	push   %edi
  800f19:	56                   	push   %esi
  800f1a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f20:	b8 02 00 00 00       	mov    $0x2,%eax
  800f25:	89 d1                	mov    %edx,%ecx
  800f27:	89 d3                	mov    %edx,%ebx
  800f29:	89 d7                	mov    %edx,%edi
  800f2b:	89 d6                	mov    %edx,%esi
  800f2d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800f2f:	5b                   	pop    %ebx
  800f30:	5e                   	pop    %esi
  800f31:	5f                   	pop    %edi
  800f32:	5d                   	pop    %ebp
  800f33:	c3                   	ret    

00800f34 <sys_yield>:

void
sys_yield(void)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	57                   	push   %edi
  800f38:	56                   	push   %esi
  800f39:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800f3f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800f44:	89 d1                	mov    %edx,%ecx
  800f46:	89 d3                	mov    %edx,%ebx
  800f48:	89 d7                	mov    %edx,%edi
  800f4a:	89 d6                	mov    %edx,%esi
  800f4c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800f4e:	5b                   	pop    %ebx
  800f4f:	5e                   	pop    %esi
  800f50:	5f                   	pop    %edi
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	57                   	push   %edi
  800f57:	56                   	push   %esi
  800f58:	53                   	push   %ebx
  800f59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5c:	be 00 00 00 00       	mov    $0x0,%esi
  800f61:	b8 04 00 00 00       	mov    $0x4,%eax
  800f66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f69:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f6f:	89 f7                	mov    %esi,%edi
  800f71:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800f73:	85 c0                	test   %eax,%eax
  800f75:	7e 28                	jle    800f9f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f77:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f7b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f82:	00 
  800f83:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  800f8a:	00 
  800f8b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f92:	00 
  800f93:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  800f9a:	e8 88 f3 ff ff       	call   800327 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f9f:	83 c4 2c             	add    $0x2c,%esp
  800fa2:	5b                   	pop    %ebx
  800fa3:	5e                   	pop    %esi
  800fa4:	5f                   	pop    %edi
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    

00800fa7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	57                   	push   %edi
  800fab:	56                   	push   %esi
  800fac:	53                   	push   %ebx
  800fad:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb0:	b8 05 00 00 00       	mov    $0x5,%eax
  800fb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fbe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc1:	8b 75 18             	mov    0x18(%ebp),%esi
  800fc4:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  800fc6:	85 c0                	test   %eax,%eax
  800fc8:	7e 28                	jle    800ff2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fca:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fce:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800fd5:	00 
  800fd6:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  800fdd:	00 
  800fde:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fe5:	00 
  800fe6:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  800fed:	e8 35 f3 ff ff       	call   800327 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ff2:	83 c4 2c             	add    $0x2c,%esp
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5f                   	pop    %edi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    

00800ffa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	57                   	push   %edi
  800ffe:	56                   	push   %esi
  800fff:	53                   	push   %ebx
  801000:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801003:	bb 00 00 00 00       	mov    $0x0,%ebx
  801008:	b8 06 00 00 00       	mov    $0x6,%eax
  80100d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801010:	8b 55 08             	mov    0x8(%ebp),%edx
  801013:	89 df                	mov    %ebx,%edi
  801015:	89 de                	mov    %ebx,%esi
  801017:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801019:	85 c0                	test   %eax,%eax
  80101b:	7e 28                	jle    801045 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80101d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801021:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801028:	00 
  801029:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  801030:	00 
  801031:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801038:	00 
  801039:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  801040:	e8 e2 f2 ff ff       	call   800327 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801045:	83 c4 2c             	add    $0x2c,%esp
  801048:	5b                   	pop    %ebx
  801049:	5e                   	pop    %esi
  80104a:	5f                   	pop    %edi
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	57                   	push   %edi
  801051:	56                   	push   %esi
  801052:	53                   	push   %ebx
  801053:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801056:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105b:	b8 08 00 00 00       	mov    $0x8,%eax
  801060:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801063:	8b 55 08             	mov    0x8(%ebp),%edx
  801066:	89 df                	mov    %ebx,%edi
  801068:	89 de                	mov    %ebx,%esi
  80106a:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80106c:	85 c0                	test   %eax,%eax
  80106e:	7e 28                	jle    801098 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801070:	89 44 24 10          	mov    %eax,0x10(%esp)
  801074:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80107b:	00 
  80107c:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  801083:	00 
  801084:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80108b:	00 
  80108c:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  801093:	e8 8f f2 ff ff       	call   800327 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801098:	83 c4 2c             	add    $0x2c,%esp
  80109b:	5b                   	pop    %ebx
  80109c:	5e                   	pop    %esi
  80109d:	5f                   	pop    %edi
  80109e:	5d                   	pop    %ebp
  80109f:	c3                   	ret    

008010a0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010a0:	55                   	push   %ebp
  8010a1:	89 e5                	mov    %esp,%ebp
  8010a3:	57                   	push   %edi
  8010a4:	56                   	push   %esi
  8010a5:	53                   	push   %ebx
  8010a6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ae:	b8 09 00 00 00       	mov    $0x9,%eax
  8010b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b9:	89 df                	mov    %ebx,%edi
  8010bb:	89 de                	mov    %ebx,%esi
  8010bd:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8010bf:	85 c0                	test   %eax,%eax
  8010c1:	7e 28                	jle    8010eb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8010ce:	00 
  8010cf:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  8010d6:	00 
  8010d7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010de:	00 
  8010df:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  8010e6:	e8 3c f2 ff ff       	call   800327 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8010eb:	83 c4 2c             	add    $0x2c,%esp
  8010ee:	5b                   	pop    %ebx
  8010ef:	5e                   	pop    %esi
  8010f0:	5f                   	pop    %edi
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    

008010f3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	57                   	push   %edi
  8010f7:	56                   	push   %esi
  8010f8:	53                   	push   %ebx
  8010f9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  801101:	b8 0a 00 00 00       	mov    $0xa,%eax
  801106:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801109:	8b 55 08             	mov    0x8(%ebp),%edx
  80110c:	89 df                	mov    %ebx,%edi
  80110e:	89 de                	mov    %ebx,%esi
  801110:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801112:	85 c0                	test   %eax,%eax
  801114:	7e 28                	jle    80113e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801116:	89 44 24 10          	mov    %eax,0x10(%esp)
  80111a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801121:	00 
  801122:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  801129:	00 
  80112a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801131:	00 
  801132:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  801139:	e8 e9 f1 ff ff       	call   800327 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80113e:	83 c4 2c             	add    $0x2c,%esp
  801141:	5b                   	pop    %ebx
  801142:	5e                   	pop    %esi
  801143:	5f                   	pop    %edi
  801144:	5d                   	pop    %ebp
  801145:	c3                   	ret    

00801146 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	57                   	push   %edi
  80114a:	56                   	push   %esi
  80114b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80114c:	be 00 00 00 00       	mov    $0x0,%esi
  801151:	b8 0c 00 00 00       	mov    $0xc,%eax
  801156:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801159:	8b 55 08             	mov    0x8(%ebp),%edx
  80115c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80115f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801162:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801164:	5b                   	pop    %ebx
  801165:	5e                   	pop    %esi
  801166:	5f                   	pop    %edi
  801167:	5d                   	pop    %ebp
  801168:	c3                   	ret    

00801169 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	57                   	push   %edi
  80116d:	56                   	push   %esi
  80116e:	53                   	push   %ebx
  80116f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801172:	b9 00 00 00 00       	mov    $0x0,%ecx
  801177:	b8 0d 00 00 00       	mov    $0xd,%eax
  80117c:	8b 55 08             	mov    0x8(%ebp),%edx
  80117f:	89 cb                	mov    %ecx,%ebx
  801181:	89 cf                	mov    %ecx,%edi
  801183:	89 ce                	mov    %ecx,%esi
  801185:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801187:	85 c0                	test   %eax,%eax
  801189:	7e 28                	jle    8011b3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80118b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80118f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801196:	00 
  801197:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  80119e:	00 
  80119f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011a6:	00 
  8011a7:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  8011ae:	e8 74 f1 ff ff       	call   800327 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011b3:	83 c4 2c             	add    $0x2c,%esp
  8011b6:	5b                   	pop    %ebx
  8011b7:	5e                   	pop    %esi
  8011b8:	5f                   	pop    %edi
  8011b9:	5d                   	pop    %ebp
  8011ba:	c3                   	ret    

008011bb <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	57                   	push   %edi
  8011bf:	56                   	push   %esi
  8011c0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c6:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011cb:	89 d1                	mov    %edx,%ecx
  8011cd:	89 d3                	mov    %edx,%ebx
  8011cf:	89 d7                	mov    %edx,%edi
  8011d1:	89 d6                	mov    %edx,%esi
  8011d3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8011d5:	5b                   	pop    %ebx
  8011d6:	5e                   	pop    %esi
  8011d7:	5f                   	pop    %edi
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    

008011da <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	57                   	push   %edi
  8011de:	56                   	push   %esi
  8011df:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e5:	b8 0f 00 00 00       	mov    $0xf,%eax
  8011ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f0:	89 df                	mov    %ebx,%edi
  8011f2:	89 de                	mov    %ebx,%esi
  8011f4:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  8011f6:	5b                   	pop    %ebx
  8011f7:	5e                   	pop    %esi
  8011f8:	5f                   	pop    %edi
  8011f9:	5d                   	pop    %ebp
  8011fa:	c3                   	ret    

008011fb <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	57                   	push   %edi
  8011ff:	56                   	push   %esi
  801200:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801201:	bb 00 00 00 00       	mov    $0x0,%ebx
  801206:	b8 10 00 00 00       	mov    $0x10,%eax
  80120b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80120e:	8b 55 08             	mov    0x8(%ebp),%edx
  801211:	89 df                	mov    %ebx,%edi
  801213:	89 de                	mov    %ebx,%esi
  801215:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  801217:	5b                   	pop    %ebx
  801218:	5e                   	pop    %esi
  801219:	5f                   	pop    %edi
  80121a:	5d                   	pop    %ebp
  80121b:	c3                   	ret    

0080121c <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	57                   	push   %edi
  801220:	56                   	push   %esi
  801221:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801222:	b9 00 00 00 00       	mov    $0x0,%ecx
  801227:	b8 11 00 00 00       	mov    $0x11,%eax
  80122c:	8b 55 08             	mov    0x8(%ebp),%edx
  80122f:	89 cb                	mov    %ecx,%ebx
  801231:	89 cf                	mov    %ecx,%edi
  801233:	89 ce                	mov    %ecx,%esi
  801235:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  801237:	5b                   	pop    %ebx
  801238:	5e                   	pop    %esi
  801239:	5f                   	pop    %edi
  80123a:	5d                   	pop    %ebp
  80123b:	c3                   	ret    

0080123c <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	57                   	push   %edi
  801240:	56                   	push   %esi
  801241:	53                   	push   %ebx
  801242:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801245:	be 00 00 00 00       	mov    $0x0,%esi
  80124a:	b8 12 00 00 00       	mov    $0x12,%eax
  80124f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801252:	8b 55 08             	mov    0x8(%ebp),%edx
  801255:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801258:	8b 7d 14             	mov    0x14(%ebp),%edi
  80125b:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80125d:	85 c0                	test   %eax,%eax
  80125f:	7e 28                	jle    801289 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  801261:	89 44 24 10          	mov    %eax,0x10(%esp)
  801265:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  80126c:	00 
  80126d:	c7 44 24 08 17 2d 80 	movl   $0x802d17,0x8(%esp)
  801274:	00 
  801275:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80127c:	00 
  80127d:	c7 04 24 34 2d 80 00 	movl   $0x802d34,(%esp)
  801284:	e8 9e f0 ff ff       	call   800327 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801289:	83 c4 2c             	add    $0x2c,%esp
  80128c:	5b                   	pop    %ebx
  80128d:	5e                   	pop    %esi
  80128e:	5f                   	pop    %edi
  80128f:	5d                   	pop    %ebp
  801290:	c3                   	ret    
  801291:	66 90                	xchg   %ax,%ax
  801293:	66 90                	xchg   %ax,%ax
  801295:	66 90                	xchg   %ax,%ax
  801297:	66 90                	xchg   %ax,%ax
  801299:	66 90                	xchg   %ax,%ax
  80129b:	66 90                	xchg   %ax,%ax
  80129d:	66 90                	xchg   %ax,%ax
  80129f:	90                   	nop

008012a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8012ab:	c1 e8 0c             	shr    $0xc,%eax
}
  8012ae:	5d                   	pop    %ebp
  8012af:	c3                   	ret    

008012b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8012bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012c0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012c5:	5d                   	pop    %ebp
  8012c6:	c3                   	ret    

008012c7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012c7:	55                   	push   %ebp
  8012c8:	89 e5                	mov    %esp,%ebp
  8012ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012cd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012d2:	89 c2                	mov    %eax,%edx
  8012d4:	c1 ea 16             	shr    $0x16,%edx
  8012d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012de:	f6 c2 01             	test   $0x1,%dl
  8012e1:	74 11                	je     8012f4 <fd_alloc+0x2d>
  8012e3:	89 c2                	mov    %eax,%edx
  8012e5:	c1 ea 0c             	shr    $0xc,%edx
  8012e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012ef:	f6 c2 01             	test   $0x1,%dl
  8012f2:	75 09                	jne    8012fd <fd_alloc+0x36>
			*fd_store = fd;
  8012f4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fb:	eb 17                	jmp    801314 <fd_alloc+0x4d>
  8012fd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801302:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801307:	75 c9                	jne    8012d2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801309:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80130f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801314:	5d                   	pop    %ebp
  801315:	c3                   	ret    

00801316 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80131c:	83 f8 1f             	cmp    $0x1f,%eax
  80131f:	77 36                	ja     801357 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801321:	c1 e0 0c             	shl    $0xc,%eax
  801324:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801329:	89 c2                	mov    %eax,%edx
  80132b:	c1 ea 16             	shr    $0x16,%edx
  80132e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801335:	f6 c2 01             	test   $0x1,%dl
  801338:	74 24                	je     80135e <fd_lookup+0x48>
  80133a:	89 c2                	mov    %eax,%edx
  80133c:	c1 ea 0c             	shr    $0xc,%edx
  80133f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801346:	f6 c2 01             	test   $0x1,%dl
  801349:	74 1a                	je     801365 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80134b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134e:	89 02                	mov    %eax,(%edx)
	return 0;
  801350:	b8 00 00 00 00       	mov    $0x0,%eax
  801355:	eb 13                	jmp    80136a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801357:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80135c:	eb 0c                	jmp    80136a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80135e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801363:	eb 05                	jmp    80136a <fd_lookup+0x54>
  801365:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80136a:	5d                   	pop    %ebp
  80136b:	c3                   	ret    

0080136c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
  80136f:	83 ec 18             	sub    $0x18,%esp
  801372:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801375:	ba 00 00 00 00       	mov    $0x0,%edx
  80137a:	eb 13                	jmp    80138f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80137c:	39 08                	cmp    %ecx,(%eax)
  80137e:	75 0c                	jne    80138c <dev_lookup+0x20>
			*dev = devtab[i];
  801380:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801383:	89 01                	mov    %eax,(%ecx)
			return 0;
  801385:	b8 00 00 00 00       	mov    $0x0,%eax
  80138a:	eb 38                	jmp    8013c4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80138c:	83 c2 01             	add    $0x1,%edx
  80138f:	8b 04 95 c4 2d 80 00 	mov    0x802dc4(,%edx,4),%eax
  801396:	85 c0                	test   %eax,%eax
  801398:	75 e2                	jne    80137c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80139a:	a1 08 44 80 00       	mov    0x804408,%eax
  80139f:	8b 40 48             	mov    0x48(%eax),%eax
  8013a2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013aa:	c7 04 24 44 2d 80 00 	movl   $0x802d44,(%esp)
  8013b1:	e8 6a f0 ff ff       	call   800420 <cprintf>
	*dev = 0;
  8013b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	56                   	push   %esi
  8013ca:	53                   	push   %ebx
  8013cb:	83 ec 20             	sub    $0x20,%esp
  8013ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8013d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013db:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013e1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013e4:	89 04 24             	mov    %eax,(%esp)
  8013e7:	e8 2a ff ff ff       	call   801316 <fd_lookup>
  8013ec:	85 c0                	test   %eax,%eax
  8013ee:	78 05                	js     8013f5 <fd_close+0x2f>
	    || fd != fd2)
  8013f0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8013f3:	74 0c                	je     801401 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8013f5:	84 db                	test   %bl,%bl
  8013f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013fc:	0f 44 c2             	cmove  %edx,%eax
  8013ff:	eb 3f                	jmp    801440 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801401:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801404:	89 44 24 04          	mov    %eax,0x4(%esp)
  801408:	8b 06                	mov    (%esi),%eax
  80140a:	89 04 24             	mov    %eax,(%esp)
  80140d:	e8 5a ff ff ff       	call   80136c <dev_lookup>
  801412:	89 c3                	mov    %eax,%ebx
  801414:	85 c0                	test   %eax,%eax
  801416:	78 16                	js     80142e <fd_close+0x68>
		if (dev->dev_close)
  801418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80141e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801423:	85 c0                	test   %eax,%eax
  801425:	74 07                	je     80142e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801427:	89 34 24             	mov    %esi,(%esp)
  80142a:	ff d0                	call   *%eax
  80142c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80142e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801432:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801439:	e8 bc fb ff ff       	call   800ffa <sys_page_unmap>
	return r;
  80143e:	89 d8                	mov    %ebx,%eax
}
  801440:	83 c4 20             	add    $0x20,%esp
  801443:	5b                   	pop    %ebx
  801444:	5e                   	pop    %esi
  801445:	5d                   	pop    %ebp
  801446:	c3                   	ret    

00801447 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80144d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801450:	89 44 24 04          	mov    %eax,0x4(%esp)
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	89 04 24             	mov    %eax,(%esp)
  80145a:	e8 b7 fe ff ff       	call   801316 <fd_lookup>
  80145f:	89 c2                	mov    %eax,%edx
  801461:	85 d2                	test   %edx,%edx
  801463:	78 13                	js     801478 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801465:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80146c:	00 
  80146d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801470:	89 04 24             	mov    %eax,(%esp)
  801473:	e8 4e ff ff ff       	call   8013c6 <fd_close>
}
  801478:	c9                   	leave  
  801479:	c3                   	ret    

0080147a <close_all>:

void
close_all(void)
{
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
  80147d:	53                   	push   %ebx
  80147e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801481:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801486:	89 1c 24             	mov    %ebx,(%esp)
  801489:	e8 b9 ff ff ff       	call   801447 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80148e:	83 c3 01             	add    $0x1,%ebx
  801491:	83 fb 20             	cmp    $0x20,%ebx
  801494:	75 f0                	jne    801486 <close_all+0xc>
		close(i);
}
  801496:	83 c4 14             	add    $0x14,%esp
  801499:	5b                   	pop    %ebx
  80149a:	5d                   	pop    %ebp
  80149b:	c3                   	ret    

0080149c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	57                   	push   %edi
  8014a0:	56                   	push   %esi
  8014a1:	53                   	push   %ebx
  8014a2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014a5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	89 04 24             	mov    %eax,(%esp)
  8014b2:	e8 5f fe ff ff       	call   801316 <fd_lookup>
  8014b7:	89 c2                	mov    %eax,%edx
  8014b9:	85 d2                	test   %edx,%edx
  8014bb:	0f 88 e1 00 00 00    	js     8015a2 <dup+0x106>
		return r;
	close(newfdnum);
  8014c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c4:	89 04 24             	mov    %eax,(%esp)
  8014c7:	e8 7b ff ff ff       	call   801447 <close>

	newfd = INDEX2FD(newfdnum);
  8014cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8014cf:	c1 e3 0c             	shl    $0xc,%ebx
  8014d2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8014d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014db:	89 04 24             	mov    %eax,(%esp)
  8014de:	e8 cd fd ff ff       	call   8012b0 <fd2data>
  8014e3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8014e5:	89 1c 24             	mov    %ebx,(%esp)
  8014e8:	e8 c3 fd ff ff       	call   8012b0 <fd2data>
  8014ed:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014ef:	89 f0                	mov    %esi,%eax
  8014f1:	c1 e8 16             	shr    $0x16,%eax
  8014f4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8014fb:	a8 01                	test   $0x1,%al
  8014fd:	74 43                	je     801542 <dup+0xa6>
  8014ff:	89 f0                	mov    %esi,%eax
  801501:	c1 e8 0c             	shr    $0xc,%eax
  801504:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80150b:	f6 c2 01             	test   $0x1,%dl
  80150e:	74 32                	je     801542 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801510:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801517:	25 07 0e 00 00       	and    $0xe07,%eax
  80151c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801520:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801524:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80152b:	00 
  80152c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801530:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801537:	e8 6b fa ff ff       	call   800fa7 <sys_page_map>
  80153c:	89 c6                	mov    %eax,%esi
  80153e:	85 c0                	test   %eax,%eax
  801540:	78 3e                	js     801580 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801542:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801545:	89 c2                	mov    %eax,%edx
  801547:	c1 ea 0c             	shr    $0xc,%edx
  80154a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801551:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801557:	89 54 24 10          	mov    %edx,0x10(%esp)
  80155b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80155f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801566:	00 
  801567:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801572:	e8 30 fa ff ff       	call   800fa7 <sys_page_map>
  801577:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801579:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80157c:	85 f6                	test   %esi,%esi
  80157e:	79 22                	jns    8015a2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801580:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801584:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80158b:	e8 6a fa ff ff       	call   800ffa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801590:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801594:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80159b:	e8 5a fa ff ff       	call   800ffa <sys_page_unmap>
	return r;
  8015a0:	89 f0                	mov    %esi,%eax
}
  8015a2:	83 c4 3c             	add    $0x3c,%esp
  8015a5:	5b                   	pop    %ebx
  8015a6:	5e                   	pop    %esi
  8015a7:	5f                   	pop    %edi
  8015a8:	5d                   	pop    %ebp
  8015a9:	c3                   	ret    

008015aa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	53                   	push   %ebx
  8015ae:	83 ec 24             	sub    $0x24,%esp
  8015b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015bb:	89 1c 24             	mov    %ebx,(%esp)
  8015be:	e8 53 fd ff ff       	call   801316 <fd_lookup>
  8015c3:	89 c2                	mov    %eax,%edx
  8015c5:	85 d2                	test   %edx,%edx
  8015c7:	78 6d                	js     801636 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d3:	8b 00                	mov    (%eax),%eax
  8015d5:	89 04 24             	mov    %eax,(%esp)
  8015d8:	e8 8f fd ff ff       	call   80136c <dev_lookup>
  8015dd:	85 c0                	test   %eax,%eax
  8015df:	78 55                	js     801636 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e4:	8b 50 08             	mov    0x8(%eax),%edx
  8015e7:	83 e2 03             	and    $0x3,%edx
  8015ea:	83 fa 01             	cmp    $0x1,%edx
  8015ed:	75 23                	jne    801612 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015ef:	a1 08 44 80 00       	mov    0x804408,%eax
  8015f4:	8b 40 48             	mov    0x48(%eax),%eax
  8015f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ff:	c7 04 24 88 2d 80 00 	movl   $0x802d88,(%esp)
  801606:	e8 15 ee ff ff       	call   800420 <cprintf>
		return -E_INVAL;
  80160b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801610:	eb 24                	jmp    801636 <read+0x8c>
	}
	if (!dev->dev_read)
  801612:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801615:	8b 52 08             	mov    0x8(%edx),%edx
  801618:	85 d2                	test   %edx,%edx
  80161a:	74 15                	je     801631 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80161c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80161f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801623:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801626:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80162a:	89 04 24             	mov    %eax,(%esp)
  80162d:	ff d2                	call   *%edx
  80162f:	eb 05                	jmp    801636 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801631:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801636:	83 c4 24             	add    $0x24,%esp
  801639:	5b                   	pop    %ebx
  80163a:	5d                   	pop    %ebp
  80163b:	c3                   	ret    

0080163c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	57                   	push   %edi
  801640:	56                   	push   %esi
  801641:	53                   	push   %ebx
  801642:	83 ec 1c             	sub    $0x1c,%esp
  801645:	8b 7d 08             	mov    0x8(%ebp),%edi
  801648:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80164b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801650:	eb 23                	jmp    801675 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801652:	89 f0                	mov    %esi,%eax
  801654:	29 d8                	sub    %ebx,%eax
  801656:	89 44 24 08          	mov    %eax,0x8(%esp)
  80165a:	89 d8                	mov    %ebx,%eax
  80165c:	03 45 0c             	add    0xc(%ebp),%eax
  80165f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801663:	89 3c 24             	mov    %edi,(%esp)
  801666:	e8 3f ff ff ff       	call   8015aa <read>
		if (m < 0)
  80166b:	85 c0                	test   %eax,%eax
  80166d:	78 10                	js     80167f <readn+0x43>
			return m;
		if (m == 0)
  80166f:	85 c0                	test   %eax,%eax
  801671:	74 0a                	je     80167d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801673:	01 c3                	add    %eax,%ebx
  801675:	39 f3                	cmp    %esi,%ebx
  801677:	72 d9                	jb     801652 <readn+0x16>
  801679:	89 d8                	mov    %ebx,%eax
  80167b:	eb 02                	jmp    80167f <readn+0x43>
  80167d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80167f:	83 c4 1c             	add    $0x1c,%esp
  801682:	5b                   	pop    %ebx
  801683:	5e                   	pop    %esi
  801684:	5f                   	pop    %edi
  801685:	5d                   	pop    %ebp
  801686:	c3                   	ret    

00801687 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801687:	55                   	push   %ebp
  801688:	89 e5                	mov    %esp,%ebp
  80168a:	53                   	push   %ebx
  80168b:	83 ec 24             	sub    $0x24,%esp
  80168e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801691:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801694:	89 44 24 04          	mov    %eax,0x4(%esp)
  801698:	89 1c 24             	mov    %ebx,(%esp)
  80169b:	e8 76 fc ff ff       	call   801316 <fd_lookup>
  8016a0:	89 c2                	mov    %eax,%edx
  8016a2:	85 d2                	test   %edx,%edx
  8016a4:	78 68                	js     80170e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b0:	8b 00                	mov    (%eax),%eax
  8016b2:	89 04 24             	mov    %eax,(%esp)
  8016b5:	e8 b2 fc ff ff       	call   80136c <dev_lookup>
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	78 50                	js     80170e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016c5:	75 23                	jne    8016ea <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016c7:	a1 08 44 80 00       	mov    0x804408,%eax
  8016cc:	8b 40 48             	mov    0x48(%eax),%eax
  8016cf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d7:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  8016de:	e8 3d ed ff ff       	call   800420 <cprintf>
		return -E_INVAL;
  8016e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016e8:	eb 24                	jmp    80170e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8016f0:	85 d2                	test   %edx,%edx
  8016f2:	74 15                	je     801709 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016f4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801702:	89 04 24             	mov    %eax,(%esp)
  801705:	ff d2                	call   *%edx
  801707:	eb 05                	jmp    80170e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801709:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80170e:	83 c4 24             	add    $0x24,%esp
  801711:	5b                   	pop    %ebx
  801712:	5d                   	pop    %ebp
  801713:	c3                   	ret    

00801714 <seek>:

int
seek(int fdnum, off_t offset)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80171a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80171d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801721:	8b 45 08             	mov    0x8(%ebp),%eax
  801724:	89 04 24             	mov    %eax,(%esp)
  801727:	e8 ea fb ff ff       	call   801316 <fd_lookup>
  80172c:	85 c0                	test   %eax,%eax
  80172e:	78 0e                	js     80173e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801730:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801733:	8b 55 0c             	mov    0xc(%ebp),%edx
  801736:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801739:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	53                   	push   %ebx
  801744:	83 ec 24             	sub    $0x24,%esp
  801747:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80174a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80174d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801751:	89 1c 24             	mov    %ebx,(%esp)
  801754:	e8 bd fb ff ff       	call   801316 <fd_lookup>
  801759:	89 c2                	mov    %eax,%edx
  80175b:	85 d2                	test   %edx,%edx
  80175d:	78 61                	js     8017c0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80175f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801762:	89 44 24 04          	mov    %eax,0x4(%esp)
  801766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801769:	8b 00                	mov    (%eax),%eax
  80176b:	89 04 24             	mov    %eax,(%esp)
  80176e:	e8 f9 fb ff ff       	call   80136c <dev_lookup>
  801773:	85 c0                	test   %eax,%eax
  801775:	78 49                	js     8017c0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801777:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80177e:	75 23                	jne    8017a3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801780:	a1 08 44 80 00       	mov    0x804408,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801785:	8b 40 48             	mov    0x48(%eax),%eax
  801788:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80178c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801790:	c7 04 24 64 2d 80 00 	movl   $0x802d64,(%esp)
  801797:	e8 84 ec ff ff       	call   800420 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80179c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017a1:	eb 1d                	jmp    8017c0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8017a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a6:	8b 52 18             	mov    0x18(%edx),%edx
  8017a9:	85 d2                	test   %edx,%edx
  8017ab:	74 0e                	je     8017bb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017ad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017b4:	89 04 24             	mov    %eax,(%esp)
  8017b7:	ff d2                	call   *%edx
  8017b9:	eb 05                	jmp    8017c0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8017bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8017c0:	83 c4 24             	add    $0x24,%esp
  8017c3:	5b                   	pop    %ebx
  8017c4:	5d                   	pop    %ebp
  8017c5:	c3                   	ret    

008017c6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	53                   	push   %ebx
  8017ca:	83 ec 24             	sub    $0x24,%esp
  8017cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	89 04 24             	mov    %eax,(%esp)
  8017dd:	e8 34 fb ff ff       	call   801316 <fd_lookup>
  8017e2:	89 c2                	mov    %eax,%edx
  8017e4:	85 d2                	test   %edx,%edx
  8017e6:	78 52                	js     80183a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f2:	8b 00                	mov    (%eax),%eax
  8017f4:	89 04 24             	mov    %eax,(%esp)
  8017f7:	e8 70 fb ff ff       	call   80136c <dev_lookup>
  8017fc:	85 c0                	test   %eax,%eax
  8017fe:	78 3a                	js     80183a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801803:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801807:	74 2c                	je     801835 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801809:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80180c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801813:	00 00 00 
	stat->st_isdir = 0;
  801816:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80181d:	00 00 00 
	stat->st_dev = dev;
  801820:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801826:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80182a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80182d:	89 14 24             	mov    %edx,(%esp)
  801830:	ff 50 14             	call   *0x14(%eax)
  801833:	eb 05                	jmp    80183a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801835:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80183a:	83 c4 24             	add    $0x24,%esp
  80183d:	5b                   	pop    %ebx
  80183e:	5d                   	pop    %ebp
  80183f:	c3                   	ret    

00801840 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	56                   	push   %esi
  801844:	53                   	push   %ebx
  801845:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801848:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80184f:	00 
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	89 04 24             	mov    %eax,(%esp)
  801856:	e8 84 02 00 00       	call   801adf <open>
  80185b:	89 c3                	mov    %eax,%ebx
  80185d:	85 db                	test   %ebx,%ebx
  80185f:	78 1b                	js     80187c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801861:	8b 45 0c             	mov    0xc(%ebp),%eax
  801864:	89 44 24 04          	mov    %eax,0x4(%esp)
  801868:	89 1c 24             	mov    %ebx,(%esp)
  80186b:	e8 56 ff ff ff       	call   8017c6 <fstat>
  801870:	89 c6                	mov    %eax,%esi
	close(fd);
  801872:	89 1c 24             	mov    %ebx,(%esp)
  801875:	e8 cd fb ff ff       	call   801447 <close>
	return r;
  80187a:	89 f0                	mov    %esi,%eax
}
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	5b                   	pop    %ebx
  801880:	5e                   	pop    %esi
  801881:	5d                   	pop    %ebp
  801882:	c3                   	ret    

00801883 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
  801886:	56                   	push   %esi
  801887:	53                   	push   %ebx
  801888:	83 ec 10             	sub    $0x10,%esp
  80188b:	89 c6                	mov    %eax,%esi
  80188d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80188f:	83 3d 00 44 80 00 00 	cmpl   $0x0,0x804400
  801896:	75 11                	jne    8018a9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801898:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80189f:	e8 a1 0d 00 00       	call   802645 <ipc_find_env>
  8018a4:	a3 00 44 80 00       	mov    %eax,0x804400
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018a9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8018b0:	00 
  8018b1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8018b8:	00 
  8018b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018bd:	a1 00 44 80 00       	mov    0x804400,%eax
  8018c2:	89 04 24             	mov    %eax,(%esp)
  8018c5:	e8 ee 0c 00 00       	call   8025b8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018d1:	00 
  8018d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018dd:	e8 6e 0c 00 00       	call   802550 <ipc_recv>
}
  8018e2:	83 c4 10             	add    $0x10,%esp
  8018e5:	5b                   	pop    %ebx
  8018e6:	5e                   	pop    %esi
  8018e7:	5d                   	pop    %ebp
  8018e8:	c3                   	ret    

008018e9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
  8018ec:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8018f5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8018fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fd:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801902:	ba 00 00 00 00       	mov    $0x0,%edx
  801907:	b8 02 00 00 00       	mov    $0x2,%eax
  80190c:	e8 72 ff ff ff       	call   801883 <fsipc>
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	8b 40 0c             	mov    0xc(%eax),%eax
  80191f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801924:	ba 00 00 00 00       	mov    $0x0,%edx
  801929:	b8 06 00 00 00       	mov    $0x6,%eax
  80192e:	e8 50 ff ff ff       	call   801883 <fsipc>
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	53                   	push   %ebx
  801939:	83 ec 14             	sub    $0x14,%esp
  80193c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	8b 40 0c             	mov    0xc(%eax),%eax
  801945:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80194a:	ba 00 00 00 00       	mov    $0x0,%edx
  80194f:	b8 05 00 00 00       	mov    $0x5,%eax
  801954:	e8 2a ff ff ff       	call   801883 <fsipc>
  801959:	89 c2                	mov    %eax,%edx
  80195b:	85 d2                	test   %edx,%edx
  80195d:	78 2b                	js     80198a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80195f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801966:	00 
  801967:	89 1c 24             	mov    %ebx,(%esp)
  80196a:	e8 c8 f1 ff ff       	call   800b37 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80196f:	a1 80 50 80 00       	mov    0x805080,%eax
  801974:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80197a:	a1 84 50 80 00       	mov    0x805084,%eax
  80197f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801985:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80198a:	83 c4 14             	add    $0x14,%esp
  80198d:	5b                   	pop    %ebx
  80198e:	5d                   	pop    %ebp
  80198f:	c3                   	ret    

00801990 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
  801993:	53                   	push   %ebx
  801994:	83 ec 14             	sub    $0x14,%esp
  801997:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80199a:	8b 45 08             	mov    0x8(%ebp),%eax
  80199d:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  8019a5:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  8019ab:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  8019b0:	0f 46 c3             	cmovbe %ebx,%eax
  8019b3:	a3 04 50 80 00       	mov    %eax,0x805004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  8019b8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c3:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8019ca:	e8 05 f3 ff ff       	call   800cd4 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8019cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d4:	b8 04 00 00 00       	mov    $0x4,%eax
  8019d9:	e8 a5 fe ff ff       	call   801883 <fsipc>
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	78 53                	js     801a35 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  8019e2:	39 c3                	cmp    %eax,%ebx
  8019e4:	73 24                	jae    801a0a <devfile_write+0x7a>
  8019e6:	c7 44 24 0c d8 2d 80 	movl   $0x802dd8,0xc(%esp)
  8019ed:	00 
  8019ee:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  8019f5:	00 
  8019f6:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  8019fd:	00 
  8019fe:	c7 04 24 f4 2d 80 00 	movl   $0x802df4,(%esp)
  801a05:	e8 1d e9 ff ff       	call   800327 <_panic>
	assert(r <= PGSIZE);
  801a0a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a0f:	7e 24                	jle    801a35 <devfile_write+0xa5>
  801a11:	c7 44 24 0c ff 2d 80 	movl   $0x802dff,0xc(%esp)
  801a18:	00 
  801a19:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  801a20:	00 
  801a21:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801a28:	00 
  801a29:	c7 04 24 f4 2d 80 00 	movl   $0x802df4,(%esp)
  801a30:	e8 f2 e8 ff ff       	call   800327 <_panic>
	return r;
}
  801a35:	83 c4 14             	add    $0x14,%esp
  801a38:	5b                   	pop    %ebx
  801a39:	5d                   	pop    %ebp
  801a3a:	c3                   	ret    

00801a3b <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	56                   	push   %esi
  801a3f:	53                   	push   %ebx
  801a40:	83 ec 10             	sub    $0x10,%esp
  801a43:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	8b 40 0c             	mov    0xc(%eax),%eax
  801a4c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801a51:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a57:	ba 00 00 00 00       	mov    $0x0,%edx
  801a5c:	b8 03 00 00 00       	mov    $0x3,%eax
  801a61:	e8 1d fe ff ff       	call   801883 <fsipc>
  801a66:	89 c3                	mov    %eax,%ebx
  801a68:	85 c0                	test   %eax,%eax
  801a6a:	78 6a                	js     801ad6 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801a6c:	39 c6                	cmp    %eax,%esi
  801a6e:	73 24                	jae    801a94 <devfile_read+0x59>
  801a70:	c7 44 24 0c d8 2d 80 	movl   $0x802dd8,0xc(%esp)
  801a77:	00 
  801a78:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  801a7f:	00 
  801a80:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801a87:	00 
  801a88:	c7 04 24 f4 2d 80 00 	movl   $0x802df4,(%esp)
  801a8f:	e8 93 e8 ff ff       	call   800327 <_panic>
	assert(r <= PGSIZE);
  801a94:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a99:	7e 24                	jle    801abf <devfile_read+0x84>
  801a9b:	c7 44 24 0c ff 2d 80 	movl   $0x802dff,0xc(%esp)
  801aa2:	00 
  801aa3:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  801aaa:	00 
  801aab:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801ab2:	00 
  801ab3:	c7 04 24 f4 2d 80 00 	movl   $0x802df4,(%esp)
  801aba:	e8 68 e8 ff ff       	call   800327 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801abf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ac3:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801aca:	00 
  801acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ace:	89 04 24             	mov    %eax,(%esp)
  801ad1:	e8 fe f1 ff ff       	call   800cd4 <memmove>
	return r;
}
  801ad6:	89 d8                	mov    %ebx,%eax
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	5b                   	pop    %ebx
  801adc:	5e                   	pop    %esi
  801add:	5d                   	pop    %ebp
  801ade:	c3                   	ret    

00801adf <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	53                   	push   %ebx
  801ae3:	83 ec 24             	sub    $0x24,%esp
  801ae6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801ae9:	89 1c 24             	mov    %ebx,(%esp)
  801aec:	e8 0f f0 ff ff       	call   800b00 <strlen>
  801af1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801af6:	7f 60                	jg     801b58 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801af8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801afb:	89 04 24             	mov    %eax,(%esp)
  801afe:	e8 c4 f7 ff ff       	call   8012c7 <fd_alloc>
  801b03:	89 c2                	mov    %eax,%edx
  801b05:	85 d2                	test   %edx,%edx
  801b07:	78 54                	js     801b5d <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b09:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b0d:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801b14:	e8 1e f0 ff ff       	call   800b37 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1c:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b24:	b8 01 00 00 00       	mov    $0x1,%eax
  801b29:	e8 55 fd ff ff       	call   801883 <fsipc>
  801b2e:	89 c3                	mov    %eax,%ebx
  801b30:	85 c0                	test   %eax,%eax
  801b32:	79 17                	jns    801b4b <open+0x6c>
		fd_close(fd, 0);
  801b34:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b3b:	00 
  801b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3f:	89 04 24             	mov    %eax,(%esp)
  801b42:	e8 7f f8 ff ff       	call   8013c6 <fd_close>
		return r;
  801b47:	89 d8                	mov    %ebx,%eax
  801b49:	eb 12                	jmp    801b5d <open+0x7e>
	}

	return fd2num(fd);
  801b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4e:	89 04 24             	mov    %eax,(%esp)
  801b51:	e8 4a f7 ff ff       	call   8012a0 <fd2num>
  801b56:	eb 05                	jmp    801b5d <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801b58:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801b5d:	83 c4 24             	add    $0x24,%esp
  801b60:	5b                   	pop    %ebx
  801b61:	5d                   	pop    %ebp
  801b62:	c3                   	ret    

00801b63 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b69:	ba 00 00 00 00       	mov    $0x0,%edx
  801b6e:	b8 08 00 00 00       	mov    $0x8,%eax
  801b73:	e8 0b fd ff ff       	call   801883 <fsipc>
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	53                   	push   %ebx
  801b7e:	83 ec 14             	sub    $0x14,%esp
  801b81:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801b83:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801b87:	7e 31                	jle    801bba <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801b89:	8b 40 04             	mov    0x4(%eax),%eax
  801b8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b90:	8d 43 10             	lea    0x10(%ebx),%eax
  801b93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b97:	8b 03                	mov    (%ebx),%eax
  801b99:	89 04 24             	mov    %eax,(%esp)
  801b9c:	e8 e6 fa ff ff       	call   801687 <write>
		if (result > 0)
  801ba1:	85 c0                	test   %eax,%eax
  801ba3:	7e 03                	jle    801ba8 <writebuf+0x2e>
			b->result += result;
  801ba5:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801ba8:	39 43 04             	cmp    %eax,0x4(%ebx)
  801bab:	74 0d                	je     801bba <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  801bad:	85 c0                	test   %eax,%eax
  801baf:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb4:	0f 4f c2             	cmovg  %edx,%eax
  801bb7:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801bba:	83 c4 14             	add    $0x14,%esp
  801bbd:	5b                   	pop    %ebx
  801bbe:	5d                   	pop    %ebp
  801bbf:	c3                   	ret    

00801bc0 <putch>:

static void
putch(int ch, void *thunk)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	53                   	push   %ebx
  801bc4:	83 ec 04             	sub    $0x4,%esp
  801bc7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801bca:	8b 53 04             	mov    0x4(%ebx),%edx
  801bcd:	8d 42 01             	lea    0x1(%edx),%eax
  801bd0:	89 43 04             	mov    %eax,0x4(%ebx)
  801bd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bd6:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801bda:	3d 00 01 00 00       	cmp    $0x100,%eax
  801bdf:	75 0e                	jne    801bef <putch+0x2f>
		writebuf(b);
  801be1:	89 d8                	mov    %ebx,%eax
  801be3:	e8 92 ff ff ff       	call   801b7a <writebuf>
		b->idx = 0;
  801be8:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801bef:	83 c4 04             	add    $0x4,%esp
  801bf2:	5b                   	pop    %ebx
  801bf3:	5d                   	pop    %ebp
  801bf4:	c3                   	ret    

00801bf5 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801c07:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801c0e:	00 00 00 
	b.result = 0;
  801c11:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801c18:	00 00 00 
	b.error = 1;
  801c1b:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801c22:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801c25:	8b 45 10             	mov    0x10(%ebp),%eax
  801c28:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c33:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3d:	c7 04 24 c0 1b 80 00 	movl   $0x801bc0,(%esp)
  801c44:	e8 65 e9 ff ff       	call   8005ae <vprintfmt>
	if (b.idx > 0)
  801c49:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801c50:	7e 0b                	jle    801c5d <vfprintf+0x68>
		writebuf(&b);
  801c52:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c58:	e8 1d ff ff ff       	call   801b7a <writebuf>

	return (b.result ? b.result : b.error);
  801c5d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801c63:	85 c0                	test   %eax,%eax
  801c65:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c74:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801c77:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c82:	8b 45 08             	mov    0x8(%ebp),%eax
  801c85:	89 04 24             	mov    %eax,(%esp)
  801c88:	e8 68 ff ff ff       	call   801bf5 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <printf>:

int
printf(const char *fmt, ...)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801c95:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801c98:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801caa:	e8 46 ff ff ff       	call   801bf5 <vfprintf>
	va_end(ap);

	return cnt;
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    
  801cb1:	66 90                	xchg   %ax,%ax
  801cb3:	66 90                	xchg   %ax,%ax
  801cb5:	66 90                	xchg   %ax,%ax
  801cb7:	66 90                	xchg   %ax,%ax
  801cb9:	66 90                	xchg   %ax,%ax
  801cbb:	66 90                	xchg   %ax,%ax
  801cbd:	66 90                	xchg   %ax,%ax
  801cbf:	90                   	nop

00801cc0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801cc6:	c7 44 24 04 0b 2e 80 	movl   $0x802e0b,0x4(%esp)
  801ccd:	00 
  801cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd1:	89 04 24             	mov    %eax,(%esp)
  801cd4:	e8 5e ee ff ff       	call   800b37 <strcpy>
	return 0;
}
  801cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	53                   	push   %ebx
  801ce4:	83 ec 14             	sub    $0x14,%esp
  801ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cea:	89 1c 24             	mov    %ebx,(%esp)
  801ced:	e8 8d 09 00 00       	call   80267f <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801cf2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801cf7:	83 f8 01             	cmp    $0x1,%eax
  801cfa:	75 0d                	jne    801d09 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801cfc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801cff:	89 04 24             	mov    %eax,(%esp)
  801d02:	e8 29 03 00 00       	call   802030 <nsipc_close>
  801d07:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801d09:	89 d0                	mov    %edx,%eax
  801d0b:	83 c4 14             	add    $0x14,%esp
  801d0e:	5b                   	pop    %ebx
  801d0f:	5d                   	pop    %ebp
  801d10:	c3                   	ret    

00801d11 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d17:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d1e:	00 
  801d1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d22:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d30:	8b 40 0c             	mov    0xc(%eax),%eax
  801d33:	89 04 24             	mov    %eax,(%esp)
  801d36:	e8 f0 03 00 00       	call   80212b <nsipc_send>
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d43:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d4a:	00 
  801d4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d5f:	89 04 24             	mov    %eax,(%esp)
  801d62:	e8 44 03 00 00       	call   8020ab <nsipc_recv>
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d6f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d72:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d76:	89 04 24             	mov    %eax,(%esp)
  801d79:	e8 98 f5 ff ff       	call   801316 <fd_lookup>
  801d7e:	85 c0                	test   %eax,%eax
  801d80:	78 17                	js     801d99 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d85:	8b 0d 3c 30 80 00    	mov    0x80303c,%ecx
  801d8b:	39 08                	cmp    %ecx,(%eax)
  801d8d:	75 05                	jne    801d94 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801d8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d92:	eb 05                	jmp    801d99 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801d94:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	56                   	push   %esi
  801d9f:	53                   	push   %ebx
  801da0:	83 ec 20             	sub    $0x20,%esp
  801da3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801da5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da8:	89 04 24             	mov    %eax,(%esp)
  801dab:	e8 17 f5 ff ff       	call   8012c7 <fd_alloc>
  801db0:	89 c3                	mov    %eax,%ebx
  801db2:	85 c0                	test   %eax,%eax
  801db4:	78 21                	js     801dd7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801db6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801dbd:	00 
  801dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dcc:	e8 82 f1 ff ff       	call   800f53 <sys_page_alloc>
  801dd1:	89 c3                	mov    %eax,%ebx
  801dd3:	85 c0                	test   %eax,%eax
  801dd5:	79 0c                	jns    801de3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801dd7:	89 34 24             	mov    %esi,(%esp)
  801dda:	e8 51 02 00 00       	call   802030 <nsipc_close>
		return r;
  801ddf:	89 d8                	mov    %ebx,%eax
  801de1:	eb 20                	jmp    801e03 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801de3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dec:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801dee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801df1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801df8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801dfb:	89 14 24             	mov    %edx,(%esp)
  801dfe:	e8 9d f4 ff ff       	call   8012a0 <fd2num>
}
  801e03:	83 c4 20             	add    $0x20,%esp
  801e06:	5b                   	pop    %ebx
  801e07:	5e                   	pop    %esi
  801e08:	5d                   	pop    %ebp
  801e09:	c3                   	ret    

00801e0a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
  801e0d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e10:	8b 45 08             	mov    0x8(%ebp),%eax
  801e13:	e8 51 ff ff ff       	call   801d69 <fd2sockid>
		return r;
  801e18:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	78 23                	js     801e41 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e1e:	8b 55 10             	mov    0x10(%ebp),%edx
  801e21:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e28:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e2c:	89 04 24             	mov    %eax,(%esp)
  801e2f:	e8 45 01 00 00       	call   801f79 <nsipc_accept>
		return r;
  801e34:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e36:	85 c0                	test   %eax,%eax
  801e38:	78 07                	js     801e41 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801e3a:	e8 5c ff ff ff       	call   801d9b <alloc_sockfd>
  801e3f:	89 c1                	mov    %eax,%ecx
}
  801e41:	89 c8                	mov    %ecx,%eax
  801e43:	c9                   	leave  
  801e44:	c3                   	ret    

00801e45 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	e8 16 ff ff ff       	call   801d69 <fd2sockid>
  801e53:	89 c2                	mov    %eax,%edx
  801e55:	85 d2                	test   %edx,%edx
  801e57:	78 16                	js     801e6f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801e59:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e67:	89 14 24             	mov    %edx,(%esp)
  801e6a:	e8 60 01 00 00       	call   801fcf <nsipc_bind>
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <shutdown>:

int
shutdown(int s, int how)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	e8 ea fe ff ff       	call   801d69 <fd2sockid>
  801e7f:	89 c2                	mov    %eax,%edx
  801e81:	85 d2                	test   %edx,%edx
  801e83:	78 0f                	js     801e94 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e8c:	89 14 24             	mov    %edx,(%esp)
  801e8f:	e8 7a 01 00 00       	call   80200e <nsipc_shutdown>
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9f:	e8 c5 fe ff ff       	call   801d69 <fd2sockid>
  801ea4:	89 c2                	mov    %eax,%edx
  801ea6:	85 d2                	test   %edx,%edx
  801ea8:	78 16                	js     801ec0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801eaa:	8b 45 10             	mov    0x10(%ebp),%eax
  801ead:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb8:	89 14 24             	mov    %edx,(%esp)
  801ebb:	e8 8a 01 00 00       	call   80204a <nsipc_connect>
}
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <listen>:

int
listen(int s, int backlog)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecb:	e8 99 fe ff ff       	call   801d69 <fd2sockid>
  801ed0:	89 c2                	mov    %eax,%edx
  801ed2:	85 d2                	test   %edx,%edx
  801ed4:	78 0f                	js     801ee5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801ed6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801edd:	89 14 24             	mov    %edx,(%esp)
  801ee0:	e8 a4 01 00 00       	call   802089 <nsipc_listen>
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801eed:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	89 04 24             	mov    %eax,(%esp)
  801f01:	e8 98 02 00 00       	call   80219e <nsipc_socket>
  801f06:	89 c2                	mov    %eax,%edx
  801f08:	85 d2                	test   %edx,%edx
  801f0a:	78 05                	js     801f11 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801f0c:	e8 8a fe ff ff       	call   801d9b <alloc_sockfd>
}
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
  801f16:	53                   	push   %ebx
  801f17:	83 ec 14             	sub    $0x14,%esp
  801f1a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f1c:	83 3d 04 44 80 00 00 	cmpl   $0x0,0x804404
  801f23:	75 11                	jne    801f36 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f25:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801f2c:	e8 14 07 00 00       	call   802645 <ipc_find_env>
  801f31:	a3 04 44 80 00       	mov    %eax,0x804404
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f36:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f3d:	00 
  801f3e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801f45:	00 
  801f46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f4a:	a1 04 44 80 00       	mov    0x804404,%eax
  801f4f:	89 04 24             	mov    %eax,(%esp)
  801f52:	e8 61 06 00 00       	call   8025b8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f57:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f5e:	00 
  801f5f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f66:	00 
  801f67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f6e:	e8 dd 05 00 00       	call   802550 <ipc_recv>
}
  801f73:	83 c4 14             	add    $0x14,%esp
  801f76:	5b                   	pop    %ebx
  801f77:	5d                   	pop    %ebp
  801f78:	c3                   	ret    

00801f79 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	56                   	push   %esi
  801f7d:	53                   	push   %ebx
  801f7e:	83 ec 10             	sub    $0x10,%esp
  801f81:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f8c:	8b 06                	mov    (%esi),%eax
  801f8e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f93:	b8 01 00 00 00       	mov    $0x1,%eax
  801f98:	e8 76 ff ff ff       	call   801f13 <nsipc>
  801f9d:	89 c3                	mov    %eax,%ebx
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	78 23                	js     801fc6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fa3:	a1 10 60 80 00       	mov    0x806010,%eax
  801fa8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fac:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801fb3:	00 
  801fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb7:	89 04 24             	mov    %eax,(%esp)
  801fba:	e8 15 ed ff ff       	call   800cd4 <memmove>
		*addrlen = ret->ret_addrlen;
  801fbf:	a1 10 60 80 00       	mov    0x806010,%eax
  801fc4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801fc6:	89 d8                	mov    %ebx,%eax
  801fc8:	83 c4 10             	add    $0x10,%esp
  801fcb:	5b                   	pop    %ebx
  801fcc:	5e                   	pop    %esi
  801fcd:	5d                   	pop    %ebp
  801fce:	c3                   	ret    

00801fcf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	53                   	push   %ebx
  801fd3:	83 ec 14             	sub    $0x14,%esp
  801fd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fe1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fec:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801ff3:	e8 dc ec ff ff       	call   800cd4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ff8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ffe:	b8 02 00 00 00       	mov    $0x2,%eax
  802003:	e8 0b ff ff ff       	call   801f13 <nsipc>
}
  802008:	83 c4 14             	add    $0x14,%esp
  80200b:	5b                   	pop    %ebx
  80200c:	5d                   	pop    %ebp
  80200d:	c3                   	ret    

0080200e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
  802011:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80201c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802024:	b8 03 00 00 00       	mov    $0x3,%eax
  802029:	e8 e5 fe ff ff       	call   801f13 <nsipc>
}
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <nsipc_close>:

int
nsipc_close(int s)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802036:	8b 45 08             	mov    0x8(%ebp),%eax
  802039:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  80203e:	b8 04 00 00 00       	mov    $0x4,%eax
  802043:	e8 cb fe ff ff       	call   801f13 <nsipc>
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
  80204d:	53                   	push   %ebx
  80204e:	83 ec 14             	sub    $0x14,%esp
  802051:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80205c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802060:	8b 45 0c             	mov    0xc(%ebp),%eax
  802063:	89 44 24 04          	mov    %eax,0x4(%esp)
  802067:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  80206e:	e8 61 ec ff ff       	call   800cd4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802073:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802079:	b8 05 00 00 00       	mov    $0x5,%eax
  80207e:	e8 90 fe ff ff       	call   801f13 <nsipc>
}
  802083:	83 c4 14             	add    $0x14,%esp
  802086:	5b                   	pop    %ebx
  802087:	5d                   	pop    %ebp
  802088:	c3                   	ret    

00802089 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80208f:	8b 45 08             	mov    0x8(%ebp),%eax
  802092:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  80209f:	b8 06 00 00 00       	mov    $0x6,%eax
  8020a4:	e8 6a fe ff ff       	call   801f13 <nsipc>
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	56                   	push   %esi
  8020af:	53                   	push   %ebx
  8020b0:	83 ec 10             	sub    $0x10,%esp
  8020b3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8020be:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8020c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020c7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020cc:	b8 07 00 00 00       	mov    $0x7,%eax
  8020d1:	e8 3d fe ff ff       	call   801f13 <nsipc>
  8020d6:	89 c3                	mov    %eax,%ebx
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	78 46                	js     802122 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8020dc:	39 f0                	cmp    %esi,%eax
  8020de:	7f 07                	jg     8020e7 <nsipc_recv+0x3c>
  8020e0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020e5:	7e 24                	jle    80210b <nsipc_recv+0x60>
  8020e7:	c7 44 24 0c 17 2e 80 	movl   $0x802e17,0xc(%esp)
  8020ee:	00 
  8020ef:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  8020f6:	00 
  8020f7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8020fe:	00 
  8020ff:	c7 04 24 2c 2e 80 00 	movl   $0x802e2c,(%esp)
  802106:	e8 1c e2 ff ff       	call   800327 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80210b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80210f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802116:	00 
  802117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211a:	89 04 24             	mov    %eax,(%esp)
  80211d:	e8 b2 eb ff ff       	call   800cd4 <memmove>
	}

	return r;
}
  802122:	89 d8                	mov    %ebx,%eax
  802124:	83 c4 10             	add    $0x10,%esp
  802127:	5b                   	pop    %ebx
  802128:	5e                   	pop    %esi
  802129:	5d                   	pop    %ebp
  80212a:	c3                   	ret    

0080212b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
  80212e:	53                   	push   %ebx
  80212f:	83 ec 14             	sub    $0x14,%esp
  802132:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802135:	8b 45 08             	mov    0x8(%ebp),%eax
  802138:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  80213d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802143:	7e 24                	jle    802169 <nsipc_send+0x3e>
  802145:	c7 44 24 0c 38 2e 80 	movl   $0x802e38,0xc(%esp)
  80214c:	00 
  80214d:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  802154:	00 
  802155:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80215c:	00 
  80215d:	c7 04 24 2c 2e 80 00 	movl   $0x802e2c,(%esp)
  802164:	e8 be e1 ff ff       	call   800327 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802169:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80216d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802170:	89 44 24 04          	mov    %eax,0x4(%esp)
  802174:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80217b:	e8 54 eb ff ff       	call   800cd4 <memmove>
	nsipcbuf.send.req_size = size;
  802180:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802186:	8b 45 14             	mov    0x14(%ebp),%eax
  802189:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  80218e:	b8 08 00 00 00       	mov    $0x8,%eax
  802193:	e8 7b fd ff ff       	call   801f13 <nsipc>
}
  802198:	83 c4 14             	add    $0x14,%esp
  80219b:	5b                   	pop    %ebx
  80219c:	5d                   	pop    %ebp
  80219d:	c3                   	ret    

0080219e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8021ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021af:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8021b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b7:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8021bc:	b8 09 00 00 00       	mov    $0x9,%eax
  8021c1:	e8 4d fd ff ff       	call   801f13 <nsipc>
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
  8021cb:	56                   	push   %esi
  8021cc:	53                   	push   %ebx
  8021cd:	83 ec 10             	sub    $0x10,%esp
  8021d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	89 04 24             	mov    %eax,(%esp)
  8021d9:	e8 d2 f0 ff ff       	call   8012b0 <fd2data>
  8021de:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021e0:	c7 44 24 04 44 2e 80 	movl   $0x802e44,0x4(%esp)
  8021e7:	00 
  8021e8:	89 1c 24             	mov    %ebx,(%esp)
  8021eb:	e8 47 e9 ff ff       	call   800b37 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021f0:	8b 46 04             	mov    0x4(%esi),%eax
  8021f3:	2b 06                	sub    (%esi),%eax
  8021f5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021fb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802202:	00 00 00 
	stat->st_dev = &devpipe;
  802205:	c7 83 88 00 00 00 58 	movl   $0x803058,0x88(%ebx)
  80220c:	30 80 00 
	return 0;
}
  80220f:	b8 00 00 00 00       	mov    $0x0,%eax
  802214:	83 c4 10             	add    $0x10,%esp
  802217:	5b                   	pop    %ebx
  802218:	5e                   	pop    %esi
  802219:	5d                   	pop    %ebp
  80221a:	c3                   	ret    

0080221b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	53                   	push   %ebx
  80221f:	83 ec 14             	sub    $0x14,%esp
  802222:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802225:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802229:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802230:	e8 c5 ed ff ff       	call   800ffa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802235:	89 1c 24             	mov    %ebx,(%esp)
  802238:	e8 73 f0 ff ff       	call   8012b0 <fd2data>
  80223d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802241:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802248:	e8 ad ed ff ff       	call   800ffa <sys_page_unmap>
}
  80224d:	83 c4 14             	add    $0x14,%esp
  802250:	5b                   	pop    %ebx
  802251:	5d                   	pop    %ebp
  802252:	c3                   	ret    

00802253 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	57                   	push   %edi
  802257:	56                   	push   %esi
  802258:	53                   	push   %ebx
  802259:	83 ec 2c             	sub    $0x2c,%esp
  80225c:	89 c6                	mov    %eax,%esi
  80225e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802261:	a1 08 44 80 00       	mov    0x804408,%eax
  802266:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802269:	89 34 24             	mov    %esi,(%esp)
  80226c:	e8 0e 04 00 00       	call   80267f <pageref>
  802271:	89 c7                	mov    %eax,%edi
  802273:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802276:	89 04 24             	mov    %eax,(%esp)
  802279:	e8 01 04 00 00       	call   80267f <pageref>
  80227e:	39 c7                	cmp    %eax,%edi
  802280:	0f 94 c2             	sete   %dl
  802283:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802286:	8b 0d 08 44 80 00    	mov    0x804408,%ecx
  80228c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80228f:	39 fb                	cmp    %edi,%ebx
  802291:	74 21                	je     8022b4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802293:	84 d2                	test   %dl,%dl
  802295:	74 ca                	je     802261 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802297:	8b 51 58             	mov    0x58(%ecx),%edx
  80229a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80229e:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022a6:	c7 04 24 4b 2e 80 00 	movl   $0x802e4b,(%esp)
  8022ad:	e8 6e e1 ff ff       	call   800420 <cprintf>
  8022b2:	eb ad                	jmp    802261 <_pipeisclosed+0xe>
	}
}
  8022b4:	83 c4 2c             	add    $0x2c,%esp
  8022b7:	5b                   	pop    %ebx
  8022b8:	5e                   	pop    %esi
  8022b9:	5f                   	pop    %edi
  8022ba:	5d                   	pop    %ebp
  8022bb:	c3                   	ret    

008022bc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	57                   	push   %edi
  8022c0:	56                   	push   %esi
  8022c1:	53                   	push   %ebx
  8022c2:	83 ec 1c             	sub    $0x1c,%esp
  8022c5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8022c8:	89 34 24             	mov    %esi,(%esp)
  8022cb:	e8 e0 ef ff ff       	call   8012b0 <fd2data>
  8022d0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022d7:	eb 45                	jmp    80231e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8022d9:	89 da                	mov    %ebx,%edx
  8022db:	89 f0                	mov    %esi,%eax
  8022dd:	e8 71 ff ff ff       	call   802253 <_pipeisclosed>
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	75 41                	jne    802327 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8022e6:	e8 49 ec ff ff       	call   800f34 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022eb:	8b 43 04             	mov    0x4(%ebx),%eax
  8022ee:	8b 0b                	mov    (%ebx),%ecx
  8022f0:	8d 51 20             	lea    0x20(%ecx),%edx
  8022f3:	39 d0                	cmp    %edx,%eax
  8022f5:	73 e2                	jae    8022d9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022fa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8022fe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802301:	99                   	cltd   
  802302:	c1 ea 1b             	shr    $0x1b,%edx
  802305:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802308:	83 e1 1f             	and    $0x1f,%ecx
  80230b:	29 d1                	sub    %edx,%ecx
  80230d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802311:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802315:	83 c0 01             	add    $0x1,%eax
  802318:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80231b:	83 c7 01             	add    $0x1,%edi
  80231e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802321:	75 c8                	jne    8022eb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802323:	89 f8                	mov    %edi,%eax
  802325:	eb 05                	jmp    80232c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80232c:	83 c4 1c             	add    $0x1c,%esp
  80232f:	5b                   	pop    %ebx
  802330:	5e                   	pop    %esi
  802331:	5f                   	pop    %edi
  802332:	5d                   	pop    %ebp
  802333:	c3                   	ret    

00802334 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
  802337:	57                   	push   %edi
  802338:	56                   	push   %esi
  802339:	53                   	push   %ebx
  80233a:	83 ec 1c             	sub    $0x1c,%esp
  80233d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802340:	89 3c 24             	mov    %edi,(%esp)
  802343:	e8 68 ef ff ff       	call   8012b0 <fd2data>
  802348:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80234a:	be 00 00 00 00       	mov    $0x0,%esi
  80234f:	eb 3d                	jmp    80238e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802351:	85 f6                	test   %esi,%esi
  802353:	74 04                	je     802359 <devpipe_read+0x25>
				return i;
  802355:	89 f0                	mov    %esi,%eax
  802357:	eb 43                	jmp    80239c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802359:	89 da                	mov    %ebx,%edx
  80235b:	89 f8                	mov    %edi,%eax
  80235d:	e8 f1 fe ff ff       	call   802253 <_pipeisclosed>
  802362:	85 c0                	test   %eax,%eax
  802364:	75 31                	jne    802397 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802366:	e8 c9 eb ff ff       	call   800f34 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80236b:	8b 03                	mov    (%ebx),%eax
  80236d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802370:	74 df                	je     802351 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802372:	99                   	cltd   
  802373:	c1 ea 1b             	shr    $0x1b,%edx
  802376:	01 d0                	add    %edx,%eax
  802378:	83 e0 1f             	and    $0x1f,%eax
  80237b:	29 d0                	sub    %edx,%eax
  80237d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802382:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802385:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802388:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80238b:	83 c6 01             	add    $0x1,%esi
  80238e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802391:	75 d8                	jne    80236b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802393:	89 f0                	mov    %esi,%eax
  802395:	eb 05                	jmp    80239c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802397:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80239c:	83 c4 1c             	add    $0x1c,%esp
  80239f:	5b                   	pop    %ebx
  8023a0:	5e                   	pop    %esi
  8023a1:	5f                   	pop    %edi
  8023a2:	5d                   	pop    %ebp
  8023a3:	c3                   	ret    

008023a4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
  8023a7:	56                   	push   %esi
  8023a8:	53                   	push   %ebx
  8023a9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8023ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023af:	89 04 24             	mov    %eax,(%esp)
  8023b2:	e8 10 ef ff ff       	call   8012c7 <fd_alloc>
  8023b7:	89 c2                	mov    %eax,%edx
  8023b9:	85 d2                	test   %edx,%edx
  8023bb:	0f 88 4d 01 00 00    	js     80250e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023c1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023c8:	00 
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023d7:	e8 77 eb ff ff       	call   800f53 <sys_page_alloc>
  8023dc:	89 c2                	mov    %eax,%edx
  8023de:	85 d2                	test   %edx,%edx
  8023e0:	0f 88 28 01 00 00    	js     80250e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8023e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023e9:	89 04 24             	mov    %eax,(%esp)
  8023ec:	e8 d6 ee ff ff       	call   8012c7 <fd_alloc>
  8023f1:	89 c3                	mov    %eax,%ebx
  8023f3:	85 c0                	test   %eax,%eax
  8023f5:	0f 88 fe 00 00 00    	js     8024f9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023fb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802402:	00 
  802403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802406:	89 44 24 04          	mov    %eax,0x4(%esp)
  80240a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802411:	e8 3d eb ff ff       	call   800f53 <sys_page_alloc>
  802416:	89 c3                	mov    %eax,%ebx
  802418:	85 c0                	test   %eax,%eax
  80241a:	0f 88 d9 00 00 00    	js     8024f9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	89 04 24             	mov    %eax,(%esp)
  802426:	e8 85 ee ff ff       	call   8012b0 <fd2data>
  80242b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80242d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802434:	00 
  802435:	89 44 24 04          	mov    %eax,0x4(%esp)
  802439:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802440:	e8 0e eb ff ff       	call   800f53 <sys_page_alloc>
  802445:	89 c3                	mov    %eax,%ebx
  802447:	85 c0                	test   %eax,%eax
  802449:	0f 88 97 00 00 00    	js     8024e6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80244f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802452:	89 04 24             	mov    %eax,(%esp)
  802455:	e8 56 ee ff ff       	call   8012b0 <fd2data>
  80245a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802461:	00 
  802462:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802466:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80246d:	00 
  80246e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802472:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802479:	e8 29 eb ff ff       	call   800fa7 <sys_page_map>
  80247e:	89 c3                	mov    %eax,%ebx
  802480:	85 c0                	test   %eax,%eax
  802482:	78 52                	js     8024d6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802484:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802499:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80249f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8024a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	89 04 24             	mov    %eax,(%esp)
  8024b4:	e8 e7 ed ff ff       	call   8012a0 <fd2num>
  8024b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024bc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c1:	89 04 24             	mov    %eax,(%esp)
  8024c4:	e8 d7 ed ff ff       	call   8012a0 <fd2num>
  8024c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024cc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d4:	eb 38                	jmp    80250e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8024d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024e1:	e8 14 eb ff ff       	call   800ffa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8024e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024f4:	e8 01 eb ff ff       	call   800ffa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802500:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802507:	e8 ee ea ff ff       	call   800ffa <sys_page_unmap>
  80250c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80250e:	83 c4 30             	add    $0x30,%esp
  802511:	5b                   	pop    %ebx
  802512:	5e                   	pop    %esi
  802513:	5d                   	pop    %ebp
  802514:	c3                   	ret    

00802515 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80251b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80251e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	89 04 24             	mov    %eax,(%esp)
  802528:	e8 e9 ed ff ff       	call   801316 <fd_lookup>
  80252d:	89 c2                	mov    %eax,%edx
  80252f:	85 d2                	test   %edx,%edx
  802531:	78 15                	js     802548 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	89 04 24             	mov    %eax,(%esp)
  802539:	e8 72 ed ff ff       	call   8012b0 <fd2data>
	return _pipeisclosed(fd, p);
  80253e:	89 c2                	mov    %eax,%edx
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	e8 0b fd ff ff       	call   802253 <_pipeisclosed>
}
  802548:	c9                   	leave  
  802549:	c3                   	ret    
  80254a:	66 90                	xchg   %ax,%ax
  80254c:	66 90                	xchg   %ax,%ax
  80254e:	66 90                	xchg   %ax,%ax

00802550 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	56                   	push   %esi
  802554:	53                   	push   %ebx
  802555:	83 ec 10             	sub    $0x10,%esp
  802558:	8b 75 08             	mov    0x8(%ebp),%esi
  80255b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802561:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  802563:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  802568:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  80256b:	89 04 24             	mov    %eax,(%esp)
  80256e:	e8 f6 eb ff ff       	call   801169 <sys_ipc_recv>
  802573:	85 c0                	test   %eax,%eax
  802575:	74 16                	je     80258d <ipc_recv+0x3d>
		if (from_env_store != NULL)
  802577:	85 f6                	test   %esi,%esi
  802579:	74 06                	je     802581 <ipc_recv+0x31>
			*from_env_store = 0;
  80257b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  802581:	85 db                	test   %ebx,%ebx
  802583:	74 2c                	je     8025b1 <ipc_recv+0x61>
			*perm_store = 0;
  802585:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80258b:	eb 24                	jmp    8025b1 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  80258d:	85 f6                	test   %esi,%esi
  80258f:	74 0a                	je     80259b <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  802591:	a1 08 44 80 00       	mov    0x804408,%eax
  802596:	8b 40 74             	mov    0x74(%eax),%eax
  802599:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  80259b:	85 db                	test   %ebx,%ebx
  80259d:	74 0a                	je     8025a9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  80259f:	a1 08 44 80 00       	mov    0x804408,%eax
  8025a4:	8b 40 78             	mov    0x78(%eax),%eax
  8025a7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8025a9:	a1 08 44 80 00       	mov    0x804408,%eax
  8025ae:	8b 40 70             	mov    0x70(%eax),%eax
}
  8025b1:	83 c4 10             	add    $0x10,%esp
  8025b4:	5b                   	pop    %ebx
  8025b5:	5e                   	pop    %esi
  8025b6:	5d                   	pop    %ebp
  8025b7:	c3                   	ret    

008025b8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
  8025bb:	57                   	push   %edi
  8025bc:	56                   	push   %esi
  8025bd:	53                   	push   %ebx
  8025be:	83 ec 1c             	sub    $0x1c,%esp
  8025c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8025c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025c7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  8025ca:	85 db                	test   %ebx,%ebx
  8025cc:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8025d1:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  8025d4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e3:	89 04 24             	mov    %eax,(%esp)
  8025e6:	e8 5b eb ff ff       	call   801146 <sys_ipc_try_send>
	if (r == 0) return;
  8025eb:	85 c0                	test   %eax,%eax
  8025ed:	75 22                	jne    802611 <ipc_send+0x59>
  8025ef:	eb 4c                	jmp    80263d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  8025f1:	84 d2                	test   %dl,%dl
  8025f3:	75 48                	jne    80263d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  8025f5:	e8 3a e9 ff ff       	call   800f34 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  8025fa:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025fe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802602:	89 74 24 04          	mov    %esi,0x4(%esp)
  802606:	8b 45 08             	mov    0x8(%ebp),%eax
  802609:	89 04 24             	mov    %eax,(%esp)
  80260c:	e8 35 eb ff ff       	call   801146 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  802611:	85 c0                	test   %eax,%eax
  802613:	0f 94 c2             	sete   %dl
  802616:	74 d9                	je     8025f1 <ipc_send+0x39>
  802618:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80261b:	74 d4                	je     8025f1 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80261d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802621:	c7 44 24 08 63 2e 80 	movl   $0x802e63,0x8(%esp)
  802628:	00 
  802629:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  802630:	00 
  802631:	c7 04 24 71 2e 80 00 	movl   $0x802e71,(%esp)
  802638:	e8 ea dc ff ff       	call   800327 <_panic>
}
  80263d:	83 c4 1c             	add    $0x1c,%esp
  802640:	5b                   	pop    %ebx
  802641:	5e                   	pop    %esi
  802642:	5f                   	pop    %edi
  802643:	5d                   	pop    %ebp
  802644:	c3                   	ret    

00802645 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80264b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802650:	89 c2                	mov    %eax,%edx
  802652:	c1 e2 07             	shl    $0x7,%edx
  802655:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80265b:	8b 52 50             	mov    0x50(%edx),%edx
  80265e:	39 ca                	cmp    %ecx,%edx
  802660:	75 0d                	jne    80266f <ipc_find_env+0x2a>
			return envs[i].env_id;
  802662:	c1 e0 07             	shl    $0x7,%eax
  802665:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  80266a:	8b 40 40             	mov    0x40(%eax),%eax
  80266d:	eb 0e                	jmp    80267d <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80266f:	83 c0 01             	add    $0x1,%eax
  802672:	3d 00 04 00 00       	cmp    $0x400,%eax
  802677:	75 d7                	jne    802650 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802679:	66 b8 00 00          	mov    $0x0,%ax
}
  80267d:	5d                   	pop    %ebp
  80267e:	c3                   	ret    

0080267f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80267f:	55                   	push   %ebp
  802680:	89 e5                	mov    %esp,%ebp
  802682:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802685:	89 d0                	mov    %edx,%eax
  802687:	c1 e8 16             	shr    $0x16,%eax
  80268a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802691:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802696:	f6 c1 01             	test   $0x1,%cl
  802699:	74 1d                	je     8026b8 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80269b:	c1 ea 0c             	shr    $0xc,%edx
  80269e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8026a5:	f6 c2 01             	test   $0x1,%dl
  8026a8:	74 0e                	je     8026b8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8026aa:	c1 ea 0c             	shr    $0xc,%edx
  8026ad:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8026b4:	ef 
  8026b5:	0f b7 c0             	movzwl %ax,%eax
}
  8026b8:	5d                   	pop    %ebp
  8026b9:	c3                   	ret    
  8026ba:	66 90                	xchg   %ax,%ax
  8026bc:	66 90                	xchg   %ax,%ax
  8026be:	66 90                	xchg   %ax,%ax

008026c0 <__udivdi3>:
  8026c0:	55                   	push   %ebp
  8026c1:	57                   	push   %edi
  8026c2:	56                   	push   %esi
  8026c3:	83 ec 0c             	sub    $0xc,%esp
  8026c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8026ca:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8026ce:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8026d2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8026d6:	85 c0                	test   %eax,%eax
  8026d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8026dc:	89 ea                	mov    %ebp,%edx
  8026de:	89 0c 24             	mov    %ecx,(%esp)
  8026e1:	75 2d                	jne    802710 <__udivdi3+0x50>
  8026e3:	39 e9                	cmp    %ebp,%ecx
  8026e5:	77 61                	ja     802748 <__udivdi3+0x88>
  8026e7:	85 c9                	test   %ecx,%ecx
  8026e9:	89 ce                	mov    %ecx,%esi
  8026eb:	75 0b                	jne    8026f8 <__udivdi3+0x38>
  8026ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f2:	31 d2                	xor    %edx,%edx
  8026f4:	f7 f1                	div    %ecx
  8026f6:	89 c6                	mov    %eax,%esi
  8026f8:	31 d2                	xor    %edx,%edx
  8026fa:	89 e8                	mov    %ebp,%eax
  8026fc:	f7 f6                	div    %esi
  8026fe:	89 c5                	mov    %eax,%ebp
  802700:	89 f8                	mov    %edi,%eax
  802702:	f7 f6                	div    %esi
  802704:	89 ea                	mov    %ebp,%edx
  802706:	83 c4 0c             	add    $0xc,%esp
  802709:	5e                   	pop    %esi
  80270a:	5f                   	pop    %edi
  80270b:	5d                   	pop    %ebp
  80270c:	c3                   	ret    
  80270d:	8d 76 00             	lea    0x0(%esi),%esi
  802710:	39 e8                	cmp    %ebp,%eax
  802712:	77 24                	ja     802738 <__udivdi3+0x78>
  802714:	0f bd e8             	bsr    %eax,%ebp
  802717:	83 f5 1f             	xor    $0x1f,%ebp
  80271a:	75 3c                	jne    802758 <__udivdi3+0x98>
  80271c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802720:	39 34 24             	cmp    %esi,(%esp)
  802723:	0f 86 9f 00 00 00    	jbe    8027c8 <__udivdi3+0x108>
  802729:	39 d0                	cmp    %edx,%eax
  80272b:	0f 82 97 00 00 00    	jb     8027c8 <__udivdi3+0x108>
  802731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802738:	31 d2                	xor    %edx,%edx
  80273a:	31 c0                	xor    %eax,%eax
  80273c:	83 c4 0c             	add    $0xc,%esp
  80273f:	5e                   	pop    %esi
  802740:	5f                   	pop    %edi
  802741:	5d                   	pop    %ebp
  802742:	c3                   	ret    
  802743:	90                   	nop
  802744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802748:	89 f8                	mov    %edi,%eax
  80274a:	f7 f1                	div    %ecx
  80274c:	31 d2                	xor    %edx,%edx
  80274e:	83 c4 0c             	add    $0xc,%esp
  802751:	5e                   	pop    %esi
  802752:	5f                   	pop    %edi
  802753:	5d                   	pop    %ebp
  802754:	c3                   	ret    
  802755:	8d 76 00             	lea    0x0(%esi),%esi
  802758:	89 e9                	mov    %ebp,%ecx
  80275a:	8b 3c 24             	mov    (%esp),%edi
  80275d:	d3 e0                	shl    %cl,%eax
  80275f:	89 c6                	mov    %eax,%esi
  802761:	b8 20 00 00 00       	mov    $0x20,%eax
  802766:	29 e8                	sub    %ebp,%eax
  802768:	89 c1                	mov    %eax,%ecx
  80276a:	d3 ef                	shr    %cl,%edi
  80276c:	89 e9                	mov    %ebp,%ecx
  80276e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802772:	8b 3c 24             	mov    (%esp),%edi
  802775:	09 74 24 08          	or     %esi,0x8(%esp)
  802779:	89 d6                	mov    %edx,%esi
  80277b:	d3 e7                	shl    %cl,%edi
  80277d:	89 c1                	mov    %eax,%ecx
  80277f:	89 3c 24             	mov    %edi,(%esp)
  802782:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802786:	d3 ee                	shr    %cl,%esi
  802788:	89 e9                	mov    %ebp,%ecx
  80278a:	d3 e2                	shl    %cl,%edx
  80278c:	89 c1                	mov    %eax,%ecx
  80278e:	d3 ef                	shr    %cl,%edi
  802790:	09 d7                	or     %edx,%edi
  802792:	89 f2                	mov    %esi,%edx
  802794:	89 f8                	mov    %edi,%eax
  802796:	f7 74 24 08          	divl   0x8(%esp)
  80279a:	89 d6                	mov    %edx,%esi
  80279c:	89 c7                	mov    %eax,%edi
  80279e:	f7 24 24             	mull   (%esp)
  8027a1:	39 d6                	cmp    %edx,%esi
  8027a3:	89 14 24             	mov    %edx,(%esp)
  8027a6:	72 30                	jb     8027d8 <__udivdi3+0x118>
  8027a8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8027ac:	89 e9                	mov    %ebp,%ecx
  8027ae:	d3 e2                	shl    %cl,%edx
  8027b0:	39 c2                	cmp    %eax,%edx
  8027b2:	73 05                	jae    8027b9 <__udivdi3+0xf9>
  8027b4:	3b 34 24             	cmp    (%esp),%esi
  8027b7:	74 1f                	je     8027d8 <__udivdi3+0x118>
  8027b9:	89 f8                	mov    %edi,%eax
  8027bb:	31 d2                	xor    %edx,%edx
  8027bd:	e9 7a ff ff ff       	jmp    80273c <__udivdi3+0x7c>
  8027c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027c8:	31 d2                	xor    %edx,%edx
  8027ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8027cf:	e9 68 ff ff ff       	jmp    80273c <__udivdi3+0x7c>
  8027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027d8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8027db:	31 d2                	xor    %edx,%edx
  8027dd:	83 c4 0c             	add    $0xc,%esp
  8027e0:	5e                   	pop    %esi
  8027e1:	5f                   	pop    %edi
  8027e2:	5d                   	pop    %ebp
  8027e3:	c3                   	ret    
  8027e4:	66 90                	xchg   %ax,%ax
  8027e6:	66 90                	xchg   %ax,%ax
  8027e8:	66 90                	xchg   %ax,%ax
  8027ea:	66 90                	xchg   %ax,%ax
  8027ec:	66 90                	xchg   %ax,%ax
  8027ee:	66 90                	xchg   %ax,%ax

008027f0 <__umoddi3>:
  8027f0:	55                   	push   %ebp
  8027f1:	57                   	push   %edi
  8027f2:	56                   	push   %esi
  8027f3:	83 ec 14             	sub    $0x14,%esp
  8027f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8027fa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8027fe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802802:	89 c7                	mov    %eax,%edi
  802804:	89 44 24 04          	mov    %eax,0x4(%esp)
  802808:	8b 44 24 30          	mov    0x30(%esp),%eax
  80280c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802810:	89 34 24             	mov    %esi,(%esp)
  802813:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802817:	85 c0                	test   %eax,%eax
  802819:	89 c2                	mov    %eax,%edx
  80281b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80281f:	75 17                	jne    802838 <__umoddi3+0x48>
  802821:	39 fe                	cmp    %edi,%esi
  802823:	76 4b                	jbe    802870 <__umoddi3+0x80>
  802825:	89 c8                	mov    %ecx,%eax
  802827:	89 fa                	mov    %edi,%edx
  802829:	f7 f6                	div    %esi
  80282b:	89 d0                	mov    %edx,%eax
  80282d:	31 d2                	xor    %edx,%edx
  80282f:	83 c4 14             	add    $0x14,%esp
  802832:	5e                   	pop    %esi
  802833:	5f                   	pop    %edi
  802834:	5d                   	pop    %ebp
  802835:	c3                   	ret    
  802836:	66 90                	xchg   %ax,%ax
  802838:	39 f8                	cmp    %edi,%eax
  80283a:	77 54                	ja     802890 <__umoddi3+0xa0>
  80283c:	0f bd e8             	bsr    %eax,%ebp
  80283f:	83 f5 1f             	xor    $0x1f,%ebp
  802842:	75 5c                	jne    8028a0 <__umoddi3+0xb0>
  802844:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802848:	39 3c 24             	cmp    %edi,(%esp)
  80284b:	0f 87 e7 00 00 00    	ja     802938 <__umoddi3+0x148>
  802851:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802855:	29 f1                	sub    %esi,%ecx
  802857:	19 c7                	sbb    %eax,%edi
  802859:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80285d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802861:	8b 44 24 08          	mov    0x8(%esp),%eax
  802865:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802869:	83 c4 14             	add    $0x14,%esp
  80286c:	5e                   	pop    %esi
  80286d:	5f                   	pop    %edi
  80286e:	5d                   	pop    %ebp
  80286f:	c3                   	ret    
  802870:	85 f6                	test   %esi,%esi
  802872:	89 f5                	mov    %esi,%ebp
  802874:	75 0b                	jne    802881 <__umoddi3+0x91>
  802876:	b8 01 00 00 00       	mov    $0x1,%eax
  80287b:	31 d2                	xor    %edx,%edx
  80287d:	f7 f6                	div    %esi
  80287f:	89 c5                	mov    %eax,%ebp
  802881:	8b 44 24 04          	mov    0x4(%esp),%eax
  802885:	31 d2                	xor    %edx,%edx
  802887:	f7 f5                	div    %ebp
  802889:	89 c8                	mov    %ecx,%eax
  80288b:	f7 f5                	div    %ebp
  80288d:	eb 9c                	jmp    80282b <__umoddi3+0x3b>
  80288f:	90                   	nop
  802890:	89 c8                	mov    %ecx,%eax
  802892:	89 fa                	mov    %edi,%edx
  802894:	83 c4 14             	add    $0x14,%esp
  802897:	5e                   	pop    %esi
  802898:	5f                   	pop    %edi
  802899:	5d                   	pop    %ebp
  80289a:	c3                   	ret    
  80289b:	90                   	nop
  80289c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028a0:	8b 04 24             	mov    (%esp),%eax
  8028a3:	be 20 00 00 00       	mov    $0x20,%esi
  8028a8:	89 e9                	mov    %ebp,%ecx
  8028aa:	29 ee                	sub    %ebp,%esi
  8028ac:	d3 e2                	shl    %cl,%edx
  8028ae:	89 f1                	mov    %esi,%ecx
  8028b0:	d3 e8                	shr    %cl,%eax
  8028b2:	89 e9                	mov    %ebp,%ecx
  8028b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028b8:	8b 04 24             	mov    (%esp),%eax
  8028bb:	09 54 24 04          	or     %edx,0x4(%esp)
  8028bf:	89 fa                	mov    %edi,%edx
  8028c1:	d3 e0                	shl    %cl,%eax
  8028c3:	89 f1                	mov    %esi,%ecx
  8028c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028c9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8028cd:	d3 ea                	shr    %cl,%edx
  8028cf:	89 e9                	mov    %ebp,%ecx
  8028d1:	d3 e7                	shl    %cl,%edi
  8028d3:	89 f1                	mov    %esi,%ecx
  8028d5:	d3 e8                	shr    %cl,%eax
  8028d7:	89 e9                	mov    %ebp,%ecx
  8028d9:	09 f8                	or     %edi,%eax
  8028db:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8028df:	f7 74 24 04          	divl   0x4(%esp)
  8028e3:	d3 e7                	shl    %cl,%edi
  8028e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8028e9:	89 d7                	mov    %edx,%edi
  8028eb:	f7 64 24 08          	mull   0x8(%esp)
  8028ef:	39 d7                	cmp    %edx,%edi
  8028f1:	89 c1                	mov    %eax,%ecx
  8028f3:	89 14 24             	mov    %edx,(%esp)
  8028f6:	72 2c                	jb     802924 <__umoddi3+0x134>
  8028f8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8028fc:	72 22                	jb     802920 <__umoddi3+0x130>
  8028fe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802902:	29 c8                	sub    %ecx,%eax
  802904:	19 d7                	sbb    %edx,%edi
  802906:	89 e9                	mov    %ebp,%ecx
  802908:	89 fa                	mov    %edi,%edx
  80290a:	d3 e8                	shr    %cl,%eax
  80290c:	89 f1                	mov    %esi,%ecx
  80290e:	d3 e2                	shl    %cl,%edx
  802910:	89 e9                	mov    %ebp,%ecx
  802912:	d3 ef                	shr    %cl,%edi
  802914:	09 d0                	or     %edx,%eax
  802916:	89 fa                	mov    %edi,%edx
  802918:	83 c4 14             	add    $0x14,%esp
  80291b:	5e                   	pop    %esi
  80291c:	5f                   	pop    %edi
  80291d:	5d                   	pop    %ebp
  80291e:	c3                   	ret    
  80291f:	90                   	nop
  802920:	39 d7                	cmp    %edx,%edi
  802922:	75 da                	jne    8028fe <__umoddi3+0x10e>
  802924:	8b 14 24             	mov    (%esp),%edx
  802927:	89 c1                	mov    %eax,%ecx
  802929:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80292d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802931:	eb cb                	jmp    8028fe <__umoddi3+0x10e>
  802933:	90                   	nop
  802934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802938:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80293c:	0f 82 0f ff ff ff    	jb     802851 <__umoddi3+0x61>
  802942:	e9 1a ff ff ff       	jmp    802861 <__umoddi3+0x71>
