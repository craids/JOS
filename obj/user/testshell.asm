
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 15 05 00 00       	call   800546 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
  800042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800048:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80004c:	89 34 24             	mov    %esi,(%esp)
  80004f:	e8 50 1c 00 00       	call   801ca4 <seek>
	seek(kfd, off);
  800054:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800058:	89 3c 24             	mov    %edi,(%esp)
  80005b:	e8 44 1c 00 00       	call   801ca4 <seek>

	cprintf("shell produced incorrect output.\n");
  800060:	c7 04 24 a0 38 80 00 	movl   $0x8038a0,(%esp)
  800067:	e8 34 06 00 00       	call   8006a0 <cprintf>
	cprintf("expected:\n===\n");
  80006c:	c7 04 24 0b 39 80 00 	movl   $0x80390b,(%esp)
  800073:	e8 28 06 00 00       	call   8006a0 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800078:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  80007b:	eb 0c                	jmp    800089 <wrong+0x56>
		sys_cputs(buf, n);
  80007d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800081:	89 1c 24             	mov    %ebx,(%esp)
  800084:	e8 8d 0f 00 00       	call   801016 <sys_cputs>
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800089:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  800090:	00 
  800091:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800095:	89 3c 24             	mov    %edi,(%esp)
  800098:	e8 9d 1a 00 00       	call   801b3a <read>
  80009d:	85 c0                	test   %eax,%eax
  80009f:	7f dc                	jg     80007d <wrong+0x4a>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8000a1:	c7 04 24 1a 39 80 00 	movl   $0x80391a,(%esp)
  8000a8:	e8 f3 05 00 00       	call   8006a0 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000ad:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000b0:	eb 0c                	jmp    8000be <wrong+0x8b>
		sys_cputs(buf, n);
  8000b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b6:	89 1c 24             	mov    %ebx,(%esp)
  8000b9:	e8 58 0f 00 00       	call   801016 <sys_cputs>
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000be:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000c5:	00 
  8000c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000ca:	89 34 24             	mov    %esi,(%esp)
  8000cd:	e8 68 1a 00 00       	call   801b3a <read>
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	7f dc                	jg     8000b2 <wrong+0x7f>
		sys_cputs(buf, n);
	cprintf("===\n");
  8000d6:	c7 04 24 15 39 80 00 	movl   $0x803915,(%esp)
  8000dd:	e8 be 05 00 00       	call   8006a0 <cprintf>
	exit();
  8000e2:	e8 a7 04 00 00       	call   80058e <exit>
}
  8000e7:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  8000ed:	5b                   	pop    %ebx
  8000ee:	5e                   	pop    %esi
  8000ef:	5f                   	pop    %edi
  8000f0:	5d                   	pop    %ebp
  8000f1:	c3                   	ret    

008000f2 <umain>:

void wrong(int, int, int);

void
umain(int argc, char **argv)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	57                   	push   %edi
  8000f6:	56                   	push   %esi
  8000f7:	53                   	push   %ebx
  8000f8:	83 ec 3c             	sub    $0x3c,%esp
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;
	int pfds[2];

	close(0);
  8000fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800102:	e8 d0 18 00 00       	call   8019d7 <close>
	close(1);
  800107:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80010e:	e8 c4 18 00 00       	call   8019d7 <close>
	opencons();
  800113:	e8 d3 03 00 00       	call   8004eb <opencons>
	opencons();
  800118:	e8 ce 03 00 00       	call   8004eb <opencons>

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80011d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800124:	00 
  800125:	c7 04 24 28 39 80 00 	movl   $0x803928,(%esp)
  80012c:	e8 3e 1f 00 00       	call   80206f <open>
  800131:	89 c3                	mov    %eax,%ebx
  800133:	85 c0                	test   %eax,%eax
  800135:	79 20                	jns    800157 <umain+0x65>
		panic("open testshell.sh: %e", rfd);
  800137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013b:	c7 44 24 08 35 39 80 	movl   $0x803935,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80014a:	00 
  80014b:	c7 04 24 4b 39 80 00 	movl   $0x80394b,(%esp)
  800152:	e8 50 04 00 00       	call   8005a7 <_panic>
	if ((wfd = pipe(pfds)) < 0)
  800157:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80015a:	89 04 24             	mov    %eax,(%esp)
  80015d:	e8 92 30 00 00       	call   8031f4 <pipe>
  800162:	85 c0                	test   %eax,%eax
  800164:	79 20                	jns    800186 <umain+0x94>
		panic("pipe: %e", wfd);
  800166:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80016a:	c7 44 24 08 5c 39 80 	movl   $0x80395c,0x8(%esp)
  800171:	00 
  800172:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  800179:	00 
  80017a:	c7 04 24 4b 39 80 00 	movl   $0x80394b,(%esp)
  800181:	e8 21 04 00 00       	call   8005a7 <_panic>
	wfd = pfds[1];
  800186:	8b 75 e0             	mov    -0x20(%ebp),%esi

	cprintf("running sh -x < testshell.sh | cat\n");
  800189:	c7 04 24 c4 38 80 00 	movl   $0x8038c4,(%esp)
  800190:	e8 0b 05 00 00       	call   8006a0 <cprintf>
	if ((r = fork()) < 0)
  800195:	e8 96 13 00 00       	call   801530 <fork>
  80019a:	85 c0                	test   %eax,%eax
  80019c:	79 20                	jns    8001be <umain+0xcc>
		panic("fork: %e", r);
  80019e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001a2:	c7 44 24 08 65 39 80 	movl   $0x803965,0x8(%esp)
  8001a9:	00 
  8001aa:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  8001b1:	00 
  8001b2:	c7 04 24 4b 39 80 00 	movl   $0x80394b,(%esp)
  8001b9:	e8 e9 03 00 00       	call   8005a7 <_panic>
	if (r == 0) {
  8001be:	85 c0                	test   %eax,%eax
  8001c0:	0f 85 9f 00 00 00    	jne    800265 <umain+0x173>
		dup(rfd, 0);
  8001c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001cd:	00 
  8001ce:	89 1c 24             	mov    %ebx,(%esp)
  8001d1:	e8 56 18 00 00       	call   801a2c <dup>
		dup(wfd, 1);
  8001d6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001dd:	00 
  8001de:	89 34 24             	mov    %esi,(%esp)
  8001e1:	e8 46 18 00 00       	call   801a2c <dup>
		close(rfd);
  8001e6:	89 1c 24             	mov    %ebx,(%esp)
  8001e9:	e8 e9 17 00 00       	call   8019d7 <close>
		close(wfd);
  8001ee:	89 34 24             	mov    %esi,(%esp)
  8001f1:	e8 e1 17 00 00       	call   8019d7 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  8001f6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001fd:	00 
  8001fe:	c7 44 24 08 6e 39 80 	movl   $0x80396e,0x8(%esp)
  800205:	00 
  800206:	c7 44 24 04 32 39 80 	movl   $0x803932,0x4(%esp)
  80020d:	00 
  80020e:	c7 04 24 71 39 80 00 	movl   $0x803971,(%esp)
  800215:	e8 99 24 00 00       	call   8026b3 <spawnl>
  80021a:	89 c7                	mov    %eax,%edi
  80021c:	85 c0                	test   %eax,%eax
  80021e:	79 20                	jns    800240 <umain+0x14e>
			panic("spawn: %e", r);
  800220:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800224:	c7 44 24 08 75 39 80 	movl   $0x803975,0x8(%esp)
  80022b:	00 
  80022c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800233:	00 
  800234:	c7 04 24 4b 39 80 00 	movl   $0x80394b,(%esp)
  80023b:	e8 67 03 00 00       	call   8005a7 <_panic>
		close(0);
  800240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800247:	e8 8b 17 00 00       	call   8019d7 <close>
		close(1);
  80024c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800253:	e8 7f 17 00 00       	call   8019d7 <close>
		wait(r);
  800258:	89 3c 24             	mov    %edi,(%esp)
  80025b:	e8 3a 31 00 00       	call   80339a <wait>
		exit();
  800260:	e8 29 03 00 00       	call   80058e <exit>
	}
	close(rfd);
  800265:	89 1c 24             	mov    %ebx,(%esp)
  800268:	e8 6a 17 00 00       	call   8019d7 <close>
	close(wfd);
  80026d:	89 34 24             	mov    %esi,(%esp)
  800270:	e8 62 17 00 00       	call   8019d7 <close>

	rfd = pfds[0];
  800275:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800278:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  80027b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800282:	00 
  800283:	c7 04 24 7f 39 80 00 	movl   $0x80397f,(%esp)
  80028a:	e8 e0 1d 00 00       	call   80206f <open>
  80028f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800292:	85 c0                	test   %eax,%eax
  800294:	79 20                	jns    8002b6 <umain+0x1c4>
		panic("open testshell.key for reading: %e", kfd);
  800296:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80029a:	c7 44 24 08 e8 38 80 	movl   $0x8038e8,0x8(%esp)
  8002a1:	00 
  8002a2:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8002a9:	00 
  8002aa:	c7 04 24 4b 39 80 00 	movl   $0x80394b,(%esp)
  8002b1:	e8 f1 02 00 00       	call   8005a7 <_panic>
	}
	close(rfd);
	close(wfd);

	rfd = pfds[0];
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002b6:	be 01 00 00 00       	mov    $0x1,%esi
  8002bb:	bf 00 00 00 00       	mov    $0x0,%edi
		panic("open testshell.key for reading: %e", kfd);

	nloff = 0;
	for (off=0;; off++) {
		n1 = read(rfd, &c1, 1);
  8002c0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002c7:	00 
  8002c8:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002d2:	89 04 24             	mov    %eax,(%esp)
  8002d5:	e8 60 18 00 00       	call   801b3a <read>
  8002da:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002e3:	00 
  8002e4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002eb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ee:	89 04 24             	mov    %eax,(%esp)
  8002f1:	e8 44 18 00 00       	call   801b3a <read>
		if (n1 < 0)
  8002f6:	85 db                	test   %ebx,%ebx
  8002f8:	79 20                	jns    80031a <umain+0x228>
			panic("reading testshell.out: %e", n1);
  8002fa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002fe:	c7 44 24 08 8d 39 80 	movl   $0x80398d,0x8(%esp)
  800305:	00 
  800306:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80030d:	00 
  80030e:	c7 04 24 4b 39 80 00 	movl   $0x80394b,(%esp)
  800315:	e8 8d 02 00 00       	call   8005a7 <_panic>
		if (n2 < 0)
  80031a:	85 c0                	test   %eax,%eax
  80031c:	79 20                	jns    80033e <umain+0x24c>
			panic("reading testshell.key: %e", n2);
  80031e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800322:	c7 44 24 08 a7 39 80 	movl   $0x8039a7,0x8(%esp)
  800329:	00 
  80032a:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  800331:	00 
  800332:	c7 04 24 4b 39 80 00 	movl   $0x80394b,(%esp)
  800339:	e8 69 02 00 00       	call   8005a7 <_panic>
		if (n1 == 0 && n2 == 0)
  80033e:	89 c2                	mov    %eax,%edx
  800340:	09 da                	or     %ebx,%edx
  800342:	74 38                	je     80037c <umain+0x28a>
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
  800344:	83 fb 01             	cmp    $0x1,%ebx
  800347:	75 0e                	jne    800357 <umain+0x265>
  800349:	83 f8 01             	cmp    $0x1,%eax
  80034c:	75 09                	jne    800357 <umain+0x265>
  80034e:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
  800352:	38 45 e7             	cmp    %al,-0x19(%ebp)
  800355:	74 16                	je     80036d <umain+0x27b>
			wrong(rfd, kfd, nloff);
  800357:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80035b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800362:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800365:	89 04 24             	mov    %eax,(%esp)
  800368:	e8 c6 fc ff ff       	call   800033 <wrong>
		if (c1 == '\n')
			nloff = off+1;
  80036d:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  800371:	0f 44 fe             	cmove  %esi,%edi
  800374:	83 c6 01             	add    $0x1,%esi
	}
  800377:	e9 44 ff ff ff       	jmp    8002c0 <umain+0x1ce>
	cprintf("shell ran correctly\n");
  80037c:	c7 04 24 c1 39 80 00 	movl   $0x8039c1,(%esp)
  800383:	e8 18 03 00 00       	call   8006a0 <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  800388:	cc                   	int3   

	breakpoint();
}
  800389:	83 c4 3c             	add    $0x3c,%esp
  80038c:	5b                   	pop    %ebx
  80038d:	5e                   	pop    %esi
  80038e:	5f                   	pop    %edi
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    
  800391:	66 90                	xchg   %ax,%ax
  800393:	66 90                	xchg   %ax,%ax
  800395:	66 90                	xchg   %ax,%ax
  800397:	66 90                	xchg   %ax,%ax
  800399:	66 90                	xchg   %ax,%ax
  80039b:	66 90                	xchg   %ax,%ax
  80039d:	66 90                	xchg   %ax,%ax
  80039f:	90                   	nop

008003a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8003a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a8:	5d                   	pop    %ebp
  8003a9:	c3                   	ret    

008003aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8003b0:	c7 44 24 04 d6 39 80 	movl   $0x8039d6,0x4(%esp)
  8003b7:	00 
  8003b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bb:	89 04 24             	mov    %eax,(%esp)
  8003be:	e8 04 09 00 00       	call   800cc7 <strcpy>
	return 0;
}
  8003c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003c8:	c9                   	leave  
  8003c9:	c3                   	ret    

008003ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	57                   	push   %edi
  8003ce:	56                   	push   %esi
  8003cf:	53                   	push   %ebx
  8003d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8003d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8003db:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8003e1:	eb 31                	jmp    800414 <devcons_write+0x4a>
		m = n - tot;
  8003e3:	8b 75 10             	mov    0x10(%ebp),%esi
  8003e6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8003e8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8003eb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8003f0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8003f3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003f7:	03 45 0c             	add    0xc(%ebp),%eax
  8003fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003fe:	89 3c 24             	mov    %edi,(%esp)
  800401:	e8 5e 0a 00 00       	call   800e64 <memmove>
		sys_cputs(buf, m);
  800406:	89 74 24 04          	mov    %esi,0x4(%esp)
  80040a:	89 3c 24             	mov    %edi,(%esp)
  80040d:	e8 04 0c 00 00       	call   801016 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800412:	01 f3                	add    %esi,%ebx
  800414:	89 d8                	mov    %ebx,%eax
  800416:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800419:	72 c8                	jb     8003e3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80041b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  800421:	5b                   	pop    %ebx
  800422:	5e                   	pop    %esi
  800423:	5f                   	pop    %edi
  800424:	5d                   	pop    %ebp
  800425:	c3                   	ret    

00800426 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
  800429:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80042c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  800431:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800435:	75 07                	jne    80043e <devcons_read+0x18>
  800437:	eb 2a                	jmp    800463 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  800439:	e8 86 0c 00 00       	call   8010c4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80043e:	66 90                	xchg   %ax,%ax
  800440:	e8 ef 0b 00 00       	call   801034 <sys_cgetc>
  800445:	85 c0                	test   %eax,%eax
  800447:	74 f0                	je     800439 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800449:	85 c0                	test   %eax,%eax
  80044b:	78 16                	js     800463 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80044d:	83 f8 04             	cmp    $0x4,%eax
  800450:	74 0c                	je     80045e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  800452:	8b 55 0c             	mov    0xc(%ebp),%edx
  800455:	88 02                	mov    %al,(%edx)
	return 1;
  800457:	b8 01 00 00 00       	mov    $0x1,%eax
  80045c:	eb 05                	jmp    800463 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80045e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800463:	c9                   	leave  
  800464:	c3                   	ret    

00800465 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800465:	55                   	push   %ebp
  800466:	89 e5                	mov    %esp,%ebp
  800468:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800471:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800478:	00 
  800479:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80047c:	89 04 24             	mov    %eax,(%esp)
  80047f:	e8 92 0b 00 00       	call   801016 <sys_cputs>
}
  800484:	c9                   	leave  
  800485:	c3                   	ret    

00800486 <getchar>:

int
getchar(void)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80048c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800493:	00 
  800494:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800497:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004a2:	e8 93 16 00 00       	call   801b3a <read>
	if (r < 0)
  8004a7:	85 c0                	test   %eax,%eax
  8004a9:	78 0f                	js     8004ba <getchar+0x34>
		return r;
	if (r < 1)
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	7e 06                	jle    8004b5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8004af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8004b3:	eb 05                	jmp    8004ba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8004b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8004ba:	c9                   	leave  
  8004bb:	c3                   	ret    

008004bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8004bc:	55                   	push   %ebp
  8004bd:	89 e5                	mov    %esp,%ebp
  8004bf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8004c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	89 04 24             	mov    %eax,(%esp)
  8004cf:	e8 d2 13 00 00       	call   8018a6 <fd_lookup>
  8004d4:	85 c0                	test   %eax,%eax
  8004d6:	78 11                	js     8004e9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8004d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004db:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8004e1:	39 10                	cmp    %edx,(%eax)
  8004e3:	0f 94 c0             	sete   %al
  8004e6:	0f b6 c0             	movzbl %al,%eax
}
  8004e9:	c9                   	leave  
  8004ea:	c3                   	ret    

008004eb <opencons>:

int
opencons(void)
{
  8004eb:	55                   	push   %ebp
  8004ec:	89 e5                	mov    %esp,%ebp
  8004ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004f4:	89 04 24             	mov    %eax,(%esp)
  8004f7:	e8 5b 13 00 00       	call   801857 <fd_alloc>
		return r;
  8004fc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004fe:	85 c0                	test   %eax,%eax
  800500:	78 40                	js     800542 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800502:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800509:	00 
  80050a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80050d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800511:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800518:	e8 c6 0b 00 00       	call   8010e3 <sys_page_alloc>
		return r;
  80051d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80051f:	85 c0                	test   %eax,%eax
  800521:	78 1f                	js     800542 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800523:	8b 15 00 50 80 00    	mov    0x805000,%edx
  800529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80052e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800531:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800538:	89 04 24             	mov    %eax,(%esp)
  80053b:	e8 f0 12 00 00       	call   801830 <fd2num>
  800540:	89 c2                	mov    %eax,%edx
}
  800542:	89 d0                	mov    %edx,%eax
  800544:	c9                   	leave  
  800545:	c3                   	ret    

00800546 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800546:	55                   	push   %ebp
  800547:	89 e5                	mov    %esp,%ebp
  800549:	56                   	push   %esi
  80054a:	53                   	push   %ebx
  80054b:	83 ec 10             	sub    $0x10,%esp
  80054e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800551:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800554:	e8 4c 0b 00 00       	call   8010a5 <sys_getenvid>
  800559:	25 ff 03 00 00       	and    $0x3ff,%eax
  80055e:	c1 e0 07             	shl    $0x7,%eax
  800561:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800566:	a3 08 60 80 00       	mov    %eax,0x806008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80056b:	85 db                	test   %ebx,%ebx
  80056d:	7e 07                	jle    800576 <libmain+0x30>
		binaryname = argv[0];
  80056f:	8b 06                	mov    (%esi),%eax
  800571:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	umain(argc, argv);
  800576:	89 74 24 04          	mov    %esi,0x4(%esp)
  80057a:	89 1c 24             	mov    %ebx,(%esp)
  80057d:	e8 70 fb ff ff       	call   8000f2 <umain>

	// exit gracefully
	exit();
  800582:	e8 07 00 00 00       	call   80058e <exit>
}
  800587:	83 c4 10             	add    $0x10,%esp
  80058a:	5b                   	pop    %ebx
  80058b:	5e                   	pop    %esi
  80058c:	5d                   	pop    %ebp
  80058d:	c3                   	ret    

0080058e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800594:	e8 71 14 00 00       	call   801a0a <close_all>
	sys_env_destroy(0);
  800599:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005a0:	e8 ae 0a 00 00       	call   801053 <sys_env_destroy>
}
  8005a5:	c9                   	leave  
  8005a6:	c3                   	ret    

008005a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8005a7:	55                   	push   %ebp
  8005a8:	89 e5                	mov    %esp,%ebp
  8005aa:	56                   	push   %esi
  8005ab:	53                   	push   %ebx
  8005ac:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8005af:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8005b2:	8b 35 1c 50 80 00    	mov    0x80501c,%esi
  8005b8:	e8 e8 0a 00 00       	call   8010a5 <sys_getenvid>
  8005bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c0:	89 54 24 10          	mov    %edx,0x10(%esp)
  8005c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005cb:	89 74 24 08          	mov    %esi,0x8(%esp)
  8005cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005d3:	c7 04 24 ec 39 80 00 	movl   $0x8039ec,(%esp)
  8005da:	e8 c1 00 00 00       	call   8006a0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8005df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e6:	89 04 24             	mov    %eax,(%esp)
  8005e9:	e8 51 00 00 00       	call   80063f <vcprintf>
	cprintf("\n");
  8005ee:	c7 04 24 18 39 80 00 	movl   $0x803918,(%esp)
  8005f5:	e8 a6 00 00 00       	call   8006a0 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8005fa:	cc                   	int3   
  8005fb:	eb fd                	jmp    8005fa <_panic+0x53>

008005fd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	53                   	push   %ebx
  800601:	83 ec 14             	sub    $0x14,%esp
  800604:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800607:	8b 13                	mov    (%ebx),%edx
  800609:	8d 42 01             	lea    0x1(%edx),%eax
  80060c:	89 03                	mov    %eax,(%ebx)
  80060e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800611:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800615:	3d ff 00 00 00       	cmp    $0xff,%eax
  80061a:	75 19                	jne    800635 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80061c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800623:	00 
  800624:	8d 43 08             	lea    0x8(%ebx),%eax
  800627:	89 04 24             	mov    %eax,(%esp)
  80062a:	e8 e7 09 00 00       	call   801016 <sys_cputs>
		b->idx = 0;
  80062f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800635:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800639:	83 c4 14             	add    $0x14,%esp
  80063c:	5b                   	pop    %ebx
  80063d:	5d                   	pop    %ebp
  80063e:	c3                   	ret    

0080063f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
  800642:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800648:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80064f:	00 00 00 
	b.cnt = 0;
  800652:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800659:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80065f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800663:	8b 45 08             	mov    0x8(%ebp),%eax
  800666:	89 44 24 08          	mov    %eax,0x8(%esp)
  80066a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800670:	89 44 24 04          	mov    %eax,0x4(%esp)
  800674:	c7 04 24 fd 05 80 00 	movl   $0x8005fd,(%esp)
  80067b:	e8 ae 01 00 00       	call   80082e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800680:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800686:	89 44 24 04          	mov    %eax,0x4(%esp)
  80068a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800690:	89 04 24             	mov    %eax,(%esp)
  800693:	e8 7e 09 00 00       	call   801016 <sys_cputs>

	return b.cnt;
}
  800698:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80069e:	c9                   	leave  
  80069f:	c3                   	ret    

008006a0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
  8006a3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006a6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8006a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	89 04 24             	mov    %eax,(%esp)
  8006b3:	e8 87 ff ff ff       	call   80063f <vcprintf>
	va_end(ap);

	return cnt;
}
  8006b8:	c9                   	leave  
  8006b9:	c3                   	ret    
  8006ba:	66 90                	xchg   %ax,%ax
  8006bc:	66 90                	xchg   %ax,%ax
  8006be:	66 90                	xchg   %ax,%ax

008006c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006c0:	55                   	push   %ebp
  8006c1:	89 e5                	mov    %esp,%ebp
  8006c3:	57                   	push   %edi
  8006c4:	56                   	push   %esi
  8006c5:	53                   	push   %ebx
  8006c6:	83 ec 3c             	sub    $0x3c,%esp
  8006c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006cc:	89 d7                	mov    %edx,%edi
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d7:	89 c3                	mov    %eax,%ebx
  8006d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8006df:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ea:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006ed:	39 d9                	cmp    %ebx,%ecx
  8006ef:	72 05                	jb     8006f6 <printnum+0x36>
  8006f1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006f4:	77 69                	ja     80075f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006f6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006f9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8006fd:	83 ee 01             	sub    $0x1,%esi
  800700:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800704:	89 44 24 08          	mov    %eax,0x8(%esp)
  800708:	8b 44 24 08          	mov    0x8(%esp),%eax
  80070c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800710:	89 c3                	mov    %eax,%ebx
  800712:	89 d6                	mov    %edx,%esi
  800714:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800717:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80071a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80071e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800722:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800725:	89 04 24             	mov    %eax,(%esp)
  800728:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80072b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80072f:	e8 dc 2e 00 00       	call   803610 <__udivdi3>
  800734:	89 d9                	mov    %ebx,%ecx
  800736:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80073a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80073e:	89 04 24             	mov    %eax,(%esp)
  800741:	89 54 24 04          	mov    %edx,0x4(%esp)
  800745:	89 fa                	mov    %edi,%edx
  800747:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80074a:	e8 71 ff ff ff       	call   8006c0 <printnum>
  80074f:	eb 1b                	jmp    80076c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800751:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800755:	8b 45 18             	mov    0x18(%ebp),%eax
  800758:	89 04 24             	mov    %eax,(%esp)
  80075b:	ff d3                	call   *%ebx
  80075d:	eb 03                	jmp    800762 <printnum+0xa2>
  80075f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800762:	83 ee 01             	sub    $0x1,%esi
  800765:	85 f6                	test   %esi,%esi
  800767:	7f e8                	jg     800751 <printnum+0x91>
  800769:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80076c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800770:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800774:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800777:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80077a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80077e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800782:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800785:	89 04 24             	mov    %eax,(%esp)
  800788:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80078b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80078f:	e8 ac 2f 00 00       	call   803740 <__umoddi3>
  800794:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800798:	0f be 80 0f 3a 80 00 	movsbl 0x803a0f(%eax),%eax
  80079f:	89 04 24             	mov    %eax,(%esp)
  8007a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007a5:	ff d0                	call   *%eax
}
  8007a7:	83 c4 3c             	add    $0x3c,%esp
  8007aa:	5b                   	pop    %ebx
  8007ab:	5e                   	pop    %esi
  8007ac:	5f                   	pop    %edi
  8007ad:	5d                   	pop    %ebp
  8007ae:	c3                   	ret    

008007af <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007af:	55                   	push   %ebp
  8007b0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b2:	83 fa 01             	cmp    $0x1,%edx
  8007b5:	7e 0e                	jle    8007c5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8007b7:	8b 10                	mov    (%eax),%edx
  8007b9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8007bc:	89 08                	mov    %ecx,(%eax)
  8007be:	8b 02                	mov    (%edx),%eax
  8007c0:	8b 52 04             	mov    0x4(%edx),%edx
  8007c3:	eb 22                	jmp    8007e7 <getuint+0x38>
	else if (lflag)
  8007c5:	85 d2                	test   %edx,%edx
  8007c7:	74 10                	je     8007d9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8007c9:	8b 10                	mov    (%eax),%edx
  8007cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007ce:	89 08                	mov    %ecx,(%eax)
  8007d0:	8b 02                	mov    (%edx),%eax
  8007d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d7:	eb 0e                	jmp    8007e7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8007d9:	8b 10                	mov    (%eax),%edx
  8007db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8007de:	89 08                	mov    %ecx,(%eax)
  8007e0:	8b 02                	mov    (%edx),%eax
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007e7:	5d                   	pop    %ebp
  8007e8:	c3                   	ret    

008007e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007ef:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8007f3:	8b 10                	mov    (%eax),%edx
  8007f5:	3b 50 04             	cmp    0x4(%eax),%edx
  8007f8:	73 0a                	jae    800804 <sprintputch+0x1b>
		*b->buf++ = ch;
  8007fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8007fd:	89 08                	mov    %ecx,(%eax)
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	88 02                	mov    %al,(%edx)
}
  800804:	5d                   	pop    %ebp
  800805:	c3                   	ret    

00800806 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800806:	55                   	push   %ebp
  800807:	89 e5                	mov    %esp,%ebp
  800809:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80080c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80080f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800813:	8b 45 10             	mov    0x10(%ebp),%eax
  800816:	89 44 24 08          	mov    %eax,0x8(%esp)
  80081a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800821:	8b 45 08             	mov    0x8(%ebp),%eax
  800824:	89 04 24             	mov    %eax,(%esp)
  800827:	e8 02 00 00 00       	call   80082e <vprintfmt>
	va_end(ap);
}
  80082c:	c9                   	leave  
  80082d:	c3                   	ret    

0080082e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	57                   	push   %edi
  800832:	56                   	push   %esi
  800833:	53                   	push   %ebx
  800834:	83 ec 3c             	sub    $0x3c,%esp
  800837:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80083a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80083d:	eb 14                	jmp    800853 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80083f:	85 c0                	test   %eax,%eax
  800841:	0f 84 b3 03 00 00    	je     800bfa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800847:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80084b:	89 04 24             	mov    %eax,(%esp)
  80084e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800851:	89 f3                	mov    %esi,%ebx
  800853:	8d 73 01             	lea    0x1(%ebx),%esi
  800856:	0f b6 03             	movzbl (%ebx),%eax
  800859:	83 f8 25             	cmp    $0x25,%eax
  80085c:	75 e1                	jne    80083f <vprintfmt+0x11>
  80085e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800862:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800869:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800870:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800877:	ba 00 00 00 00       	mov    $0x0,%edx
  80087c:	eb 1d                	jmp    80089b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80087e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800880:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800884:	eb 15                	jmp    80089b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800886:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800888:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80088c:	eb 0d                	jmp    80089b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80088e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800891:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800894:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80089b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80089e:	0f b6 0e             	movzbl (%esi),%ecx
  8008a1:	0f b6 c1             	movzbl %cl,%eax
  8008a4:	83 e9 23             	sub    $0x23,%ecx
  8008a7:	80 f9 55             	cmp    $0x55,%cl
  8008aa:	0f 87 2a 03 00 00    	ja     800bda <vprintfmt+0x3ac>
  8008b0:	0f b6 c9             	movzbl %cl,%ecx
  8008b3:	ff 24 8d 60 3b 80 00 	jmp    *0x803b60(,%ecx,4)
  8008ba:	89 de                	mov    %ebx,%esi
  8008bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8008c1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8008c4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8008c8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8008cb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8008ce:	83 fb 09             	cmp    $0x9,%ebx
  8008d1:	77 36                	ja     800909 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008d3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008d6:	eb e9                	jmp    8008c1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008db:	8d 48 04             	lea    0x4(%eax),%ecx
  8008de:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008e6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8008e8:	eb 22                	jmp    80090c <vprintfmt+0xde>
  8008ea:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8008ed:	85 c9                	test   %ecx,%ecx
  8008ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f4:	0f 49 c1             	cmovns %ecx,%eax
  8008f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008fa:	89 de                	mov    %ebx,%esi
  8008fc:	eb 9d                	jmp    80089b <vprintfmt+0x6d>
  8008fe:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800900:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800907:	eb 92                	jmp    80089b <vprintfmt+0x6d>
  800909:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80090c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800910:	79 89                	jns    80089b <vprintfmt+0x6d>
  800912:	e9 77 ff ff ff       	jmp    80088e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800917:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80091a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80091c:	e9 7a ff ff ff       	jmp    80089b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800921:	8b 45 14             	mov    0x14(%ebp),%eax
  800924:	8d 50 04             	lea    0x4(%eax),%edx
  800927:	89 55 14             	mov    %edx,0x14(%ebp)
  80092a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80092e:	8b 00                	mov    (%eax),%eax
  800930:	89 04 24             	mov    %eax,(%esp)
  800933:	ff 55 08             	call   *0x8(%ebp)
			break;
  800936:	e9 18 ff ff ff       	jmp    800853 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80093b:	8b 45 14             	mov    0x14(%ebp),%eax
  80093e:	8d 50 04             	lea    0x4(%eax),%edx
  800941:	89 55 14             	mov    %edx,0x14(%ebp)
  800944:	8b 00                	mov    (%eax),%eax
  800946:	99                   	cltd   
  800947:	31 d0                	xor    %edx,%eax
  800949:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80094b:	83 f8 11             	cmp    $0x11,%eax
  80094e:	7f 0b                	jg     80095b <vprintfmt+0x12d>
  800950:	8b 14 85 c0 3c 80 00 	mov    0x803cc0(,%eax,4),%edx
  800957:	85 d2                	test   %edx,%edx
  800959:	75 20                	jne    80097b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80095b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80095f:	c7 44 24 08 27 3a 80 	movl   $0x803a27,0x8(%esp)
  800966:	00 
  800967:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80096b:	8b 45 08             	mov    0x8(%ebp),%eax
  80096e:	89 04 24             	mov    %eax,(%esp)
  800971:	e8 90 fe ff ff       	call   800806 <printfmt>
  800976:	e9 d8 fe ff ff       	jmp    800853 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80097b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80097f:	c7 44 24 08 ed 3e 80 	movl   $0x803eed,0x8(%esp)
  800986:	00 
  800987:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	89 04 24             	mov    %eax,(%esp)
  800991:	e8 70 fe ff ff       	call   800806 <printfmt>
  800996:	e9 b8 fe ff ff       	jmp    800853 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80099b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80099e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	8d 50 04             	lea    0x4(%eax),%edx
  8009aa:	89 55 14             	mov    %edx,0x14(%ebp)
  8009ad:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8009af:	85 f6                	test   %esi,%esi
  8009b1:	b8 20 3a 80 00       	mov    $0x803a20,%eax
  8009b6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8009b9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8009bd:	0f 84 97 00 00 00    	je     800a5a <vprintfmt+0x22c>
  8009c3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8009c7:	0f 8e 9b 00 00 00    	jle    800a68 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009cd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009d1:	89 34 24             	mov    %esi,(%esp)
  8009d4:	e8 cf 02 00 00       	call   800ca8 <strnlen>
  8009d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8009dc:	29 c2                	sub    %eax,%edx
  8009de:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8009e1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8009e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009e8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8009eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8009f1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f3:	eb 0f                	jmp    800a04 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8009f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009fc:	89 04 24             	mov    %eax,(%esp)
  8009ff:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a01:	83 eb 01             	sub    $0x1,%ebx
  800a04:	85 db                	test   %ebx,%ebx
  800a06:	7f ed                	jg     8009f5 <vprintfmt+0x1c7>
  800a08:	8b 75 d8             	mov    -0x28(%ebp),%esi
  800a0b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800a0e:	85 d2                	test   %edx,%edx
  800a10:	b8 00 00 00 00       	mov    $0x0,%eax
  800a15:	0f 49 c2             	cmovns %edx,%eax
  800a18:	29 c2                	sub    %eax,%edx
  800a1a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800a1d:	89 d7                	mov    %edx,%edi
  800a1f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a22:	eb 50                	jmp    800a74 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a24:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a28:	74 1e                	je     800a48 <vprintfmt+0x21a>
  800a2a:	0f be d2             	movsbl %dl,%edx
  800a2d:	83 ea 20             	sub    $0x20,%edx
  800a30:	83 fa 5e             	cmp    $0x5e,%edx
  800a33:	76 13                	jbe    800a48 <vprintfmt+0x21a>
					putch('?', putdat);
  800a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a3c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800a43:	ff 55 08             	call   *0x8(%ebp)
  800a46:	eb 0d                	jmp    800a55 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4b:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a4f:	89 04 24             	mov    %eax,(%esp)
  800a52:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a55:	83 ef 01             	sub    $0x1,%edi
  800a58:	eb 1a                	jmp    800a74 <vprintfmt+0x246>
  800a5a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800a5d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800a60:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a63:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a66:	eb 0c                	jmp    800a74 <vprintfmt+0x246>
  800a68:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800a6b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800a6e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a71:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a74:	83 c6 01             	add    $0x1,%esi
  800a77:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800a7b:	0f be c2             	movsbl %dl,%eax
  800a7e:	85 c0                	test   %eax,%eax
  800a80:	74 27                	je     800aa9 <vprintfmt+0x27b>
  800a82:	85 db                	test   %ebx,%ebx
  800a84:	78 9e                	js     800a24 <vprintfmt+0x1f6>
  800a86:	83 eb 01             	sub    $0x1,%ebx
  800a89:	79 99                	jns    800a24 <vprintfmt+0x1f6>
  800a8b:	89 f8                	mov    %edi,%eax
  800a8d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a90:	8b 75 08             	mov    0x8(%ebp),%esi
  800a93:	89 c3                	mov    %eax,%ebx
  800a95:	eb 1a                	jmp    800ab1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800a97:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a9b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800aa2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa4:	83 eb 01             	sub    $0x1,%ebx
  800aa7:	eb 08                	jmp    800ab1 <vprintfmt+0x283>
  800aa9:	89 fb                	mov    %edi,%ebx
  800aab:	8b 75 08             	mov    0x8(%ebp),%esi
  800aae:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800ab1:	85 db                	test   %ebx,%ebx
  800ab3:	7f e2                	jg     800a97 <vprintfmt+0x269>
  800ab5:	89 75 08             	mov    %esi,0x8(%ebp)
  800ab8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800abb:	e9 93 fd ff ff       	jmp    800853 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800ac0:	83 fa 01             	cmp    $0x1,%edx
  800ac3:	7e 16                	jle    800adb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800ac5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac8:	8d 50 08             	lea    0x8(%eax),%edx
  800acb:	89 55 14             	mov    %edx,0x14(%ebp)
  800ace:	8b 50 04             	mov    0x4(%eax),%edx
  800ad1:	8b 00                	mov    (%eax),%eax
  800ad3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ad6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800ad9:	eb 32                	jmp    800b0d <vprintfmt+0x2df>
	else if (lflag)
  800adb:	85 d2                	test   %edx,%edx
  800add:	74 18                	je     800af7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	8d 50 04             	lea    0x4(%eax),%edx
  800ae5:	89 55 14             	mov    %edx,0x14(%ebp)
  800ae8:	8b 30                	mov    (%eax),%esi
  800aea:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800aed:	89 f0                	mov    %esi,%eax
  800aef:	c1 f8 1f             	sar    $0x1f,%eax
  800af2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800af5:	eb 16                	jmp    800b0d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800af7:	8b 45 14             	mov    0x14(%ebp),%eax
  800afa:	8d 50 04             	lea    0x4(%eax),%edx
  800afd:	89 55 14             	mov    %edx,0x14(%ebp)
  800b00:	8b 30                	mov    (%eax),%esi
  800b02:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800b05:	89 f0                	mov    %esi,%eax
  800b07:	c1 f8 1f             	sar    $0x1f,%eax
  800b0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800b13:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800b18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b1c:	0f 89 80 00 00 00    	jns    800ba2 <vprintfmt+0x374>
				putch('-', putdat);
  800b22:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b26:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b2d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800b30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b36:	f7 d8                	neg    %eax
  800b38:	83 d2 00             	adc    $0x0,%edx
  800b3b:	f7 da                	neg    %edx
			}
			base = 10;
  800b3d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800b42:	eb 5e                	jmp    800ba2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b44:	8d 45 14             	lea    0x14(%ebp),%eax
  800b47:	e8 63 fc ff ff       	call   8007af <getuint>
			base = 10;
  800b4c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800b51:	eb 4f                	jmp    800ba2 <vprintfmt+0x374>

		// (unsigned) octal
		case 'o':
			num = getuint(&ap, lflag);
  800b53:	8d 45 14             	lea    0x14(%ebp),%eax
  800b56:	e8 54 fc ff ff       	call   8007af <getuint>
			base = 8;
  800b5b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800b60:	eb 40                	jmp    800ba2 <vprintfmt+0x374>

		// pointer
		case 'p':
			putch('0', putdat);
  800b62:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b66:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800b6d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800b70:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b74:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800b7b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b81:	8d 50 04             	lea    0x4(%eax),%edx
  800b84:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b87:	8b 00                	mov    (%eax),%eax
  800b89:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800b8e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800b93:	eb 0d                	jmp    800ba2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b95:	8d 45 14             	lea    0x14(%ebp),%eax
  800b98:	e8 12 fc ff ff       	call   8007af <getuint>
			base = 16;
  800b9d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ba2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800ba6:	89 74 24 10          	mov    %esi,0x10(%esp)
  800baa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  800bad:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800bb1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800bb5:	89 04 24             	mov    %eax,(%esp)
  800bb8:	89 54 24 04          	mov    %edx,0x4(%esp)
  800bbc:	89 fa                	mov    %edi,%edx
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	e8 fa fa ff ff       	call   8006c0 <printnum>
			break;
  800bc6:	e9 88 fc ff ff       	jmp    800853 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bcb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bcf:	89 04 24             	mov    %eax,(%esp)
  800bd2:	ff 55 08             	call   *0x8(%ebp)
			break;
  800bd5:	e9 79 fc ff ff       	jmp    800853 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bda:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bde:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800be5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800be8:	89 f3                	mov    %esi,%ebx
  800bea:	eb 03                	jmp    800bef <vprintfmt+0x3c1>
  800bec:	83 eb 01             	sub    $0x1,%ebx
  800bef:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800bf3:	75 f7                	jne    800bec <vprintfmt+0x3be>
  800bf5:	e9 59 fc ff ff       	jmp    800853 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  800bfa:	83 c4 3c             	add    $0x3c,%esp
  800bfd:	5b                   	pop    %ebx
  800bfe:	5e                   	pop    %esi
  800bff:	5f                   	pop    %edi
  800c00:	5d                   	pop    %ebp
  800c01:	c3                   	ret    

00800c02 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	83 ec 28             	sub    $0x28,%esp
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c11:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c15:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c1f:	85 c0                	test   %eax,%eax
  800c21:	74 30                	je     800c53 <vsnprintf+0x51>
  800c23:	85 d2                	test   %edx,%edx
  800c25:	7e 2c                	jle    800c53 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c27:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c35:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c3c:	c7 04 24 e9 07 80 00 	movl   $0x8007e9,(%esp)
  800c43:	e8 e6 fb ff ff       	call   80082e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c4b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c51:	eb 05                	jmp    800c58 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800c53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800c58:	c9                   	leave  
  800c59:	c3                   	ret    

00800c5a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c60:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800c63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c67:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	89 04 24             	mov    %eax,(%esp)
  800c7b:	e8 82 ff ff ff       	call   800c02 <vsnprintf>
	va_end(ap);

	return rc;
}
  800c80:	c9                   	leave  
  800c81:	c3                   	ret    
  800c82:	66 90                	xchg   %ax,%ax
  800c84:	66 90                	xchg   %ax,%ax
  800c86:	66 90                	xchg   %ax,%ax
  800c88:	66 90                	xchg   %ax,%ax
  800c8a:	66 90                	xchg   %ax,%ax
  800c8c:	66 90                	xchg   %ax,%ax
  800c8e:	66 90                	xchg   %ax,%ax

00800c90 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800c96:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9b:	eb 03                	jmp    800ca0 <strlen+0x10>
		n++;
  800c9d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ca4:	75 f7                	jne    800c9d <strlen+0xd>
		n++;
	return n;
}
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb6:	eb 03                	jmp    800cbb <strnlen+0x13>
		n++;
  800cb8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cbb:	39 d0                	cmp    %edx,%eax
  800cbd:	74 06                	je     800cc5 <strnlen+0x1d>
  800cbf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800cc3:	75 f3                	jne    800cb8 <strnlen+0x10>
		n++;
	return n;
}
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    

00800cc7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	53                   	push   %ebx
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800cd1:	89 c2                	mov    %eax,%edx
  800cd3:	83 c2 01             	add    $0x1,%edx
  800cd6:	83 c1 01             	add    $0x1,%ecx
  800cd9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800cdd:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ce0:	84 db                	test   %bl,%bl
  800ce2:	75 ef                	jne    800cd3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ce4:	5b                   	pop    %ebx
  800ce5:	5d                   	pop    %ebp
  800ce6:	c3                   	ret    

00800ce7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ce7:	55                   	push   %ebp
  800ce8:	89 e5                	mov    %esp,%ebp
  800cea:	53                   	push   %ebx
  800ceb:	83 ec 08             	sub    $0x8,%esp
  800cee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800cf1:	89 1c 24             	mov    %ebx,(%esp)
  800cf4:	e8 97 ff ff ff       	call   800c90 <strlen>
	strcpy(dst + len, src);
  800cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d00:	01 d8                	add    %ebx,%eax
  800d02:	89 04 24             	mov    %eax,(%esp)
  800d05:	e8 bd ff ff ff       	call   800cc7 <strcpy>
	return dst;
}
  800d0a:	89 d8                	mov    %ebx,%eax
  800d0c:	83 c4 08             	add    $0x8,%esp
  800d0f:	5b                   	pop    %ebx
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    

00800d12 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	56                   	push   %esi
  800d16:	53                   	push   %ebx
  800d17:	8b 75 08             	mov    0x8(%ebp),%esi
  800d1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1d:	89 f3                	mov    %esi,%ebx
  800d1f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d22:	89 f2                	mov    %esi,%edx
  800d24:	eb 0f                	jmp    800d35 <strncpy+0x23>
		*dst++ = *src;
  800d26:	83 c2 01             	add    $0x1,%edx
  800d29:	0f b6 01             	movzbl (%ecx),%eax
  800d2c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d2f:	80 39 01             	cmpb   $0x1,(%ecx)
  800d32:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d35:	39 da                	cmp    %ebx,%edx
  800d37:	75 ed                	jne    800d26 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800d39:	89 f0                	mov    %esi,%eax
  800d3b:	5b                   	pop    %ebx
  800d3c:	5e                   	pop    %esi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	56                   	push   %esi
  800d43:	53                   	push   %ebx
  800d44:	8b 75 08             	mov    0x8(%ebp),%esi
  800d47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800d4d:	89 f0                	mov    %esi,%eax
  800d4f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d53:	85 c9                	test   %ecx,%ecx
  800d55:	75 0b                	jne    800d62 <strlcpy+0x23>
  800d57:	eb 1d                	jmp    800d76 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800d59:	83 c0 01             	add    $0x1,%eax
  800d5c:	83 c2 01             	add    $0x1,%edx
  800d5f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d62:	39 d8                	cmp    %ebx,%eax
  800d64:	74 0b                	je     800d71 <strlcpy+0x32>
  800d66:	0f b6 0a             	movzbl (%edx),%ecx
  800d69:	84 c9                	test   %cl,%cl
  800d6b:	75 ec                	jne    800d59 <strlcpy+0x1a>
  800d6d:	89 c2                	mov    %eax,%edx
  800d6f:	eb 02                	jmp    800d73 <strlcpy+0x34>
  800d71:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800d73:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800d76:	29 f0                	sub    %esi,%eax
}
  800d78:	5b                   	pop    %ebx
  800d79:	5e                   	pop    %esi
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d82:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800d85:	eb 06                	jmp    800d8d <strcmp+0x11>
		p++, q++;
  800d87:	83 c1 01             	add    $0x1,%ecx
  800d8a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d8d:	0f b6 01             	movzbl (%ecx),%eax
  800d90:	84 c0                	test   %al,%al
  800d92:	74 04                	je     800d98 <strcmp+0x1c>
  800d94:	3a 02                	cmp    (%edx),%al
  800d96:	74 ef                	je     800d87 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d98:	0f b6 c0             	movzbl %al,%eax
  800d9b:	0f b6 12             	movzbl (%edx),%edx
  800d9e:	29 d0                	sub    %edx,%eax
}
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	53                   	push   %ebx
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dac:	89 c3                	mov    %eax,%ebx
  800dae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800db1:	eb 06                	jmp    800db9 <strncmp+0x17>
		n--, p++, q++;
  800db3:	83 c0 01             	add    $0x1,%eax
  800db6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800db9:	39 d8                	cmp    %ebx,%eax
  800dbb:	74 15                	je     800dd2 <strncmp+0x30>
  800dbd:	0f b6 08             	movzbl (%eax),%ecx
  800dc0:	84 c9                	test   %cl,%cl
  800dc2:	74 04                	je     800dc8 <strncmp+0x26>
  800dc4:	3a 0a                	cmp    (%edx),%cl
  800dc6:	74 eb                	je     800db3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc8:	0f b6 00             	movzbl (%eax),%eax
  800dcb:	0f b6 12             	movzbl (%edx),%edx
  800dce:	29 d0                	sub    %edx,%eax
  800dd0:	eb 05                	jmp    800dd7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800dd2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800dd7:	5b                   	pop    %ebx
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    

00800dda <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800de4:	eb 07                	jmp    800ded <strchr+0x13>
		if (*s == c)
  800de6:	38 ca                	cmp    %cl,%dl
  800de8:	74 0f                	je     800df9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dea:	83 c0 01             	add    $0x1,%eax
  800ded:	0f b6 10             	movzbl (%eax),%edx
  800df0:	84 d2                	test   %dl,%dl
  800df2:	75 f2                	jne    800de6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800df4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800e05:	eb 07                	jmp    800e0e <strfind+0x13>
		if (*s == c)
  800e07:	38 ca                	cmp    %cl,%dl
  800e09:	74 0a                	je     800e15 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e0b:	83 c0 01             	add    $0x1,%eax
  800e0e:	0f b6 10             	movzbl (%eax),%edx
  800e11:	84 d2                	test   %dl,%dl
  800e13:	75 f2                	jne    800e07 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	57                   	push   %edi
  800e1b:	56                   	push   %esi
  800e1c:	53                   	push   %ebx
  800e1d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e20:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e23:	85 c9                	test   %ecx,%ecx
  800e25:	74 36                	je     800e5d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e27:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e2d:	75 28                	jne    800e57 <memset+0x40>
  800e2f:	f6 c1 03             	test   $0x3,%cl
  800e32:	75 23                	jne    800e57 <memset+0x40>
		c &= 0xFF;
  800e34:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e38:	89 d3                	mov    %edx,%ebx
  800e3a:	c1 e3 08             	shl    $0x8,%ebx
  800e3d:	89 d6                	mov    %edx,%esi
  800e3f:	c1 e6 18             	shl    $0x18,%esi
  800e42:	89 d0                	mov    %edx,%eax
  800e44:	c1 e0 10             	shl    $0x10,%eax
  800e47:	09 f0                	or     %esi,%eax
  800e49:	09 c2                	or     %eax,%edx
  800e4b:	89 d0                	mov    %edx,%eax
  800e4d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800e4f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800e52:	fc                   	cld    
  800e53:	f3 ab                	rep stos %eax,%es:(%edi)
  800e55:	eb 06                	jmp    800e5d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	fc                   	cld    
  800e5b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e5d:	89 f8                	mov    %edi,%eax
  800e5f:	5b                   	pop    %ebx
  800e60:	5e                   	pop    %esi
  800e61:	5f                   	pop    %edi
  800e62:	5d                   	pop    %ebp
  800e63:	c3                   	ret    

00800e64 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e64:	55                   	push   %ebp
  800e65:	89 e5                	mov    %esp,%ebp
  800e67:	57                   	push   %edi
  800e68:	56                   	push   %esi
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e72:	39 c6                	cmp    %eax,%esi
  800e74:	73 35                	jae    800eab <memmove+0x47>
  800e76:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800e79:	39 d0                	cmp    %edx,%eax
  800e7b:	73 2e                	jae    800eab <memmove+0x47>
		s += n;
		d += n;
  800e7d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800e80:	89 d6                	mov    %edx,%esi
  800e82:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e84:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e8a:	75 13                	jne    800e9f <memmove+0x3b>
  800e8c:	f6 c1 03             	test   $0x3,%cl
  800e8f:	75 0e                	jne    800e9f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800e91:	83 ef 04             	sub    $0x4,%edi
  800e94:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e97:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800e9a:	fd                   	std    
  800e9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800e9d:	eb 09                	jmp    800ea8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800e9f:	83 ef 01             	sub    $0x1,%edi
  800ea2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ea5:	fd                   	std    
  800ea6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ea8:	fc                   	cld    
  800ea9:	eb 1d                	jmp    800ec8 <memmove+0x64>
  800eab:	89 f2                	mov    %esi,%edx
  800ead:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eaf:	f6 c2 03             	test   $0x3,%dl
  800eb2:	75 0f                	jne    800ec3 <memmove+0x5f>
  800eb4:	f6 c1 03             	test   $0x3,%cl
  800eb7:	75 0a                	jne    800ec3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800eb9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800ebc:	89 c7                	mov    %eax,%edi
  800ebe:	fc                   	cld    
  800ebf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ec1:	eb 05                	jmp    800ec8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ec3:	89 c7                	mov    %eax,%edi
  800ec5:	fc                   	cld    
  800ec6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ec8:	5e                   	pop    %esi
  800ec9:	5f                   	pop    %edi
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    

00800ecc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	89 04 24             	mov    %eax,(%esp)
  800ee6:	e8 79 ff ff ff       	call   800e64 <memmove>
}
  800eeb:	c9                   	leave  
  800eec:	c3                   	ret    

00800eed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	56                   	push   %esi
  800ef1:	53                   	push   %ebx
  800ef2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef8:	89 d6                	mov    %edx,%esi
  800efa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800efd:	eb 1a                	jmp    800f19 <memcmp+0x2c>
		if (*s1 != *s2)
  800eff:	0f b6 02             	movzbl (%edx),%eax
  800f02:	0f b6 19             	movzbl (%ecx),%ebx
  800f05:	38 d8                	cmp    %bl,%al
  800f07:	74 0a                	je     800f13 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800f09:	0f b6 c0             	movzbl %al,%eax
  800f0c:	0f b6 db             	movzbl %bl,%ebx
  800f0f:	29 d8                	sub    %ebx,%eax
  800f11:	eb 0f                	jmp    800f22 <memcmp+0x35>
		s1++, s2++;
  800f13:	83 c2 01             	add    $0x1,%edx
  800f16:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800f19:	39 f2                	cmp    %esi,%edx
  800f1b:	75 e2                	jne    800eff <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f2f:	89 c2                	mov    %eax,%edx
  800f31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f34:	eb 07                	jmp    800f3d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f36:	38 08                	cmp    %cl,(%eax)
  800f38:	74 07                	je     800f41 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f3a:	83 c0 01             	add    $0x1,%eax
  800f3d:	39 d0                	cmp    %edx,%eax
  800f3f:	72 f5                	jb     800f36 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800f41:	5d                   	pop    %ebp
  800f42:	c3                   	ret    

00800f43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f43:	55                   	push   %ebp
  800f44:	89 e5                	mov    %esp,%ebp
  800f46:	57                   	push   %edi
  800f47:	56                   	push   %esi
  800f48:	53                   	push   %ebx
  800f49:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f4f:	eb 03                	jmp    800f54 <strtol+0x11>
		s++;
  800f51:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f54:	0f b6 0a             	movzbl (%edx),%ecx
  800f57:	80 f9 09             	cmp    $0x9,%cl
  800f5a:	74 f5                	je     800f51 <strtol+0xe>
  800f5c:	80 f9 20             	cmp    $0x20,%cl
  800f5f:	74 f0                	je     800f51 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f61:	80 f9 2b             	cmp    $0x2b,%cl
  800f64:	75 0a                	jne    800f70 <strtol+0x2d>
		s++;
  800f66:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800f69:	bf 00 00 00 00       	mov    $0x0,%edi
  800f6e:	eb 11                	jmp    800f81 <strtol+0x3e>
  800f70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800f75:	80 f9 2d             	cmp    $0x2d,%cl
  800f78:	75 07                	jne    800f81 <strtol+0x3e>
		s++, neg = 1;
  800f7a:	8d 52 01             	lea    0x1(%edx),%edx
  800f7d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f81:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800f86:	75 15                	jne    800f9d <strtol+0x5a>
  800f88:	80 3a 30             	cmpb   $0x30,(%edx)
  800f8b:	75 10                	jne    800f9d <strtol+0x5a>
  800f8d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f91:	75 0a                	jne    800f9d <strtol+0x5a>
		s += 2, base = 16;
  800f93:	83 c2 02             	add    $0x2,%edx
  800f96:	b8 10 00 00 00       	mov    $0x10,%eax
  800f9b:	eb 10                	jmp    800fad <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800f9d:	85 c0                	test   %eax,%eax
  800f9f:	75 0c                	jne    800fad <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800fa1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800fa3:	80 3a 30             	cmpb   $0x30,(%edx)
  800fa6:	75 05                	jne    800fad <strtol+0x6a>
		s++, base = 8;
  800fa8:	83 c2 01             	add    $0x1,%edx
  800fab:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800fad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb5:	0f b6 0a             	movzbl (%edx),%ecx
  800fb8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800fbb:	89 f0                	mov    %esi,%eax
  800fbd:	3c 09                	cmp    $0x9,%al
  800fbf:	77 08                	ja     800fc9 <strtol+0x86>
			dig = *s - '0';
  800fc1:	0f be c9             	movsbl %cl,%ecx
  800fc4:	83 e9 30             	sub    $0x30,%ecx
  800fc7:	eb 20                	jmp    800fe9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800fc9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800fcc:	89 f0                	mov    %esi,%eax
  800fce:	3c 19                	cmp    $0x19,%al
  800fd0:	77 08                	ja     800fda <strtol+0x97>
			dig = *s - 'a' + 10;
  800fd2:	0f be c9             	movsbl %cl,%ecx
  800fd5:	83 e9 57             	sub    $0x57,%ecx
  800fd8:	eb 0f                	jmp    800fe9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800fda:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800fdd:	89 f0                	mov    %esi,%eax
  800fdf:	3c 19                	cmp    $0x19,%al
  800fe1:	77 16                	ja     800ff9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800fe3:	0f be c9             	movsbl %cl,%ecx
  800fe6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800fe9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800fec:	7d 0f                	jge    800ffd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800fee:	83 c2 01             	add    $0x1,%edx
  800ff1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ff5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ff7:	eb bc                	jmp    800fb5 <strtol+0x72>
  800ff9:	89 d8                	mov    %ebx,%eax
  800ffb:	eb 02                	jmp    800fff <strtol+0xbc>
  800ffd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800fff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801003:	74 05                	je     80100a <strtol+0xc7>
		*endptr = (char *) s;
  801005:	8b 75 0c             	mov    0xc(%ebp),%esi
  801008:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  80100a:	f7 d8                	neg    %eax
  80100c:	85 ff                	test   %edi,%edi
  80100e:	0f 44 c3             	cmove  %ebx,%eax
}
  801011:	5b                   	pop    %ebx
  801012:	5e                   	pop    %esi
  801013:	5f                   	pop    %edi
  801014:	5d                   	pop    %ebp
  801015:	c3                   	ret    

00801016 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	57                   	push   %edi
  80101a:	56                   	push   %esi
  80101b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101c:	b8 00 00 00 00       	mov    $0x0,%eax
  801021:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801024:	8b 55 08             	mov    0x8(%ebp),%edx
  801027:	89 c3                	mov    %eax,%ebx
  801029:	89 c7                	mov    %eax,%edi
  80102b:	89 c6                	mov    %eax,%esi
  80102d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80102f:	5b                   	pop    %ebx
  801030:	5e                   	pop    %esi
  801031:	5f                   	pop    %edi
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <sys_cgetc>:

int
sys_cgetc(void)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	57                   	push   %edi
  801038:	56                   	push   %esi
  801039:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80103a:	ba 00 00 00 00       	mov    $0x0,%edx
  80103f:	b8 01 00 00 00       	mov    $0x1,%eax
  801044:	89 d1                	mov    %edx,%ecx
  801046:	89 d3                	mov    %edx,%ebx
  801048:	89 d7                	mov    %edx,%edi
  80104a:	89 d6                	mov    %edx,%esi
  80104c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80104e:	5b                   	pop    %ebx
  80104f:	5e                   	pop    %esi
  801050:	5f                   	pop    %edi
  801051:	5d                   	pop    %ebp
  801052:	c3                   	ret    

00801053 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  80105c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801061:	b8 03 00 00 00       	mov    $0x3,%eax
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	89 cb                	mov    %ecx,%ebx
  80106b:	89 cf                	mov    %ecx,%edi
  80106d:	89 ce                	mov    %ecx,%esi
  80106f:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801071:	85 c0                	test   %eax,%eax
  801073:	7e 28                	jle    80109d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801075:	89 44 24 10          	mov    %eax,0x10(%esp)
  801079:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801080:	00 
  801081:	c7 44 24 08 27 3d 80 	movl   $0x803d27,0x8(%esp)
  801088:	00 
  801089:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801090:	00 
  801091:	c7 04 24 44 3d 80 00 	movl   $0x803d44,(%esp)
  801098:	e8 0a f5 ff ff       	call   8005a7 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80109d:	83 c4 2c             	add    $0x2c,%esp
  8010a0:	5b                   	pop    %ebx
  8010a1:	5e                   	pop    %esi
  8010a2:	5f                   	pop    %edi
  8010a3:	5d                   	pop    %ebp
  8010a4:	c3                   	ret    

008010a5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	57                   	push   %edi
  8010a9:	56                   	push   %esi
  8010aa:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b0:	b8 02 00 00 00       	mov    $0x2,%eax
  8010b5:	89 d1                	mov    %edx,%ecx
  8010b7:	89 d3                	mov    %edx,%ebx
  8010b9:	89 d7                	mov    %edx,%edi
  8010bb:	89 d6                	mov    %edx,%esi
  8010bd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010bf:	5b                   	pop    %ebx
  8010c0:	5e                   	pop    %esi
  8010c1:	5f                   	pop    %edi
  8010c2:	5d                   	pop    %ebp
  8010c3:	c3                   	ret    

008010c4 <sys_yield>:

void
sys_yield(void)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	57                   	push   %edi
  8010c8:	56                   	push   %esi
  8010c9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8010cf:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010d4:	89 d1                	mov    %edx,%ecx
  8010d6:	89 d3                	mov    %edx,%ebx
  8010d8:	89 d7                	mov    %edx,%edi
  8010da:	89 d6                	mov    %edx,%esi
  8010dc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010de:	5b                   	pop    %ebx
  8010df:	5e                   	pop    %esi
  8010e0:	5f                   	pop    %edi
  8010e1:	5d                   	pop    %ebp
  8010e2:	c3                   	ret    

008010e3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
  8010e6:	57                   	push   %edi
  8010e7:	56                   	push   %esi
  8010e8:	53                   	push   %ebx
  8010e9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ec:	be 00 00 00 00       	mov    $0x0,%esi
  8010f1:	b8 04 00 00 00       	mov    $0x4,%eax
  8010f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010ff:	89 f7                	mov    %esi,%edi
  801101:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801103:	85 c0                	test   %eax,%eax
  801105:	7e 28                	jle    80112f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  801107:	89 44 24 10          	mov    %eax,0x10(%esp)
  80110b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801112:	00 
  801113:	c7 44 24 08 27 3d 80 	movl   $0x803d27,0x8(%esp)
  80111a:	00 
  80111b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801122:	00 
  801123:	c7 04 24 44 3d 80 00 	movl   $0x803d44,(%esp)
  80112a:	e8 78 f4 ff ff       	call   8005a7 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80112f:	83 c4 2c             	add    $0x2c,%esp
  801132:	5b                   	pop    %ebx
  801133:	5e                   	pop    %esi
  801134:	5f                   	pop    %edi
  801135:	5d                   	pop    %ebp
  801136:	c3                   	ret    

00801137 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	57                   	push   %edi
  80113b:	56                   	push   %esi
  80113c:	53                   	push   %ebx
  80113d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801140:	b8 05 00 00 00       	mov    $0x5,%eax
  801145:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801148:	8b 55 08             	mov    0x8(%ebp),%edx
  80114b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80114e:	8b 7d 14             	mov    0x14(%ebp),%edi
  801151:	8b 75 18             	mov    0x18(%ebp),%esi
  801154:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801156:	85 c0                	test   %eax,%eax
  801158:	7e 28                	jle    801182 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80115a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80115e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801165:	00 
  801166:	c7 44 24 08 27 3d 80 	movl   $0x803d27,0x8(%esp)
  80116d:	00 
  80116e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801175:	00 
  801176:	c7 04 24 44 3d 80 00 	movl   $0x803d44,(%esp)
  80117d:	e8 25 f4 ff ff       	call   8005a7 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801182:	83 c4 2c             	add    $0x2c,%esp
  801185:	5b                   	pop    %ebx
  801186:	5e                   	pop    %esi
  801187:	5f                   	pop    %edi
  801188:	5d                   	pop    %ebp
  801189:	c3                   	ret    

0080118a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	57                   	push   %edi
  80118e:	56                   	push   %esi
  80118f:	53                   	push   %ebx
  801190:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801193:	bb 00 00 00 00       	mov    $0x0,%ebx
  801198:	b8 06 00 00 00       	mov    $0x6,%eax
  80119d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a3:	89 df                	mov    %ebx,%edi
  8011a5:	89 de                	mov    %ebx,%esi
  8011a7:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8011a9:	85 c0                	test   %eax,%eax
  8011ab:	7e 28                	jle    8011d5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ad:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011b1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8011b8:	00 
  8011b9:	c7 44 24 08 27 3d 80 	movl   $0x803d27,0x8(%esp)
  8011c0:	00 
  8011c1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011c8:	00 
  8011c9:	c7 04 24 44 3d 80 00 	movl   $0x803d44,(%esp)
  8011d0:	e8 d2 f3 ff ff       	call   8005a7 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011d5:	83 c4 2c             	add    $0x2c,%esp
  8011d8:	5b                   	pop    %ebx
  8011d9:	5e                   	pop    %esi
  8011da:	5f                   	pop    %edi
  8011db:	5d                   	pop    %ebp
  8011dc:	c3                   	ret    

008011dd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	57                   	push   %edi
  8011e1:	56                   	push   %esi
  8011e2:	53                   	push   %ebx
  8011e3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011eb:	b8 08 00 00 00       	mov    $0x8,%eax
  8011f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f6:	89 df                	mov    %ebx,%edi
  8011f8:	89 de                	mov    %ebx,%esi
  8011fa:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	7e 28                	jle    801228 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801200:	89 44 24 10          	mov    %eax,0x10(%esp)
  801204:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80120b:	00 
  80120c:	c7 44 24 08 27 3d 80 	movl   $0x803d27,0x8(%esp)
  801213:	00 
  801214:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80121b:	00 
  80121c:	c7 04 24 44 3d 80 00 	movl   $0x803d44,(%esp)
  801223:	e8 7f f3 ff ff       	call   8005a7 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801228:	83 c4 2c             	add    $0x2c,%esp
  80122b:	5b                   	pop    %ebx
  80122c:	5e                   	pop    %esi
  80122d:	5f                   	pop    %edi
  80122e:	5d                   	pop    %ebp
  80122f:	c3                   	ret    

00801230 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	57                   	push   %edi
  801234:	56                   	push   %esi
  801235:	53                   	push   %ebx
  801236:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801239:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123e:	b8 09 00 00 00       	mov    $0x9,%eax
  801243:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801246:	8b 55 08             	mov    0x8(%ebp),%edx
  801249:	89 df                	mov    %ebx,%edi
  80124b:	89 de                	mov    %ebx,%esi
  80124d:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  80124f:	85 c0                	test   %eax,%eax
  801251:	7e 28                	jle    80127b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801253:	89 44 24 10          	mov    %eax,0x10(%esp)
  801257:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80125e:	00 
  80125f:	c7 44 24 08 27 3d 80 	movl   $0x803d27,0x8(%esp)
  801266:	00 
  801267:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80126e:	00 
  80126f:	c7 04 24 44 3d 80 00 	movl   $0x803d44,(%esp)
  801276:	e8 2c f3 ff ff       	call   8005a7 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80127b:	83 c4 2c             	add    $0x2c,%esp
  80127e:	5b                   	pop    %ebx
  80127f:	5e                   	pop    %esi
  801280:	5f                   	pop    %edi
  801281:	5d                   	pop    %ebp
  801282:	c3                   	ret    

00801283 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	57                   	push   %edi
  801287:	56                   	push   %esi
  801288:	53                   	push   %ebx
  801289:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80128c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801291:	b8 0a 00 00 00       	mov    $0xa,%eax
  801296:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801299:	8b 55 08             	mov    0x8(%ebp),%edx
  80129c:	89 df                	mov    %ebx,%edi
  80129e:	89 de                	mov    %ebx,%esi
  8012a0:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8012a2:	85 c0                	test   %eax,%eax
  8012a4:	7e 28                	jle    8012ce <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012aa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8012b1:	00 
  8012b2:	c7 44 24 08 27 3d 80 	movl   $0x803d27,0x8(%esp)
  8012b9:	00 
  8012ba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012c1:	00 
  8012c2:	c7 04 24 44 3d 80 00 	movl   $0x803d44,(%esp)
  8012c9:	e8 d9 f2 ff ff       	call   8005a7 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012ce:	83 c4 2c             	add    $0x2c,%esp
  8012d1:	5b                   	pop    %ebx
  8012d2:	5e                   	pop    %esi
  8012d3:	5f                   	pop    %edi
  8012d4:	5d                   	pop    %ebp
  8012d5:	c3                   	ret    

008012d6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012d6:	55                   	push   %ebp
  8012d7:	89 e5                	mov    %esp,%ebp
  8012d9:	57                   	push   %edi
  8012da:	56                   	push   %esi
  8012db:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012dc:	be 00 00 00 00       	mov    $0x0,%esi
  8012e1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012ef:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012f2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012f4:	5b                   	pop    %ebx
  8012f5:	5e                   	pop    %esi
  8012f6:	5f                   	pop    %edi
  8012f7:	5d                   	pop    %ebp
  8012f8:	c3                   	ret    

008012f9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	57                   	push   %edi
  8012fd:	56                   	push   %esi
  8012fe:	53                   	push   %ebx
  8012ff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801302:	b9 00 00 00 00       	mov    $0x0,%ecx
  801307:	b8 0d 00 00 00       	mov    $0xd,%eax
  80130c:	8b 55 08             	mov    0x8(%ebp),%edx
  80130f:	89 cb                	mov    %ecx,%ebx
  801311:	89 cf                	mov    %ecx,%edi
  801313:	89 ce                	mov    %ecx,%esi
  801315:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  801317:	85 c0                	test   %eax,%eax
  801319:	7e 28                	jle    801343 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80131b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80131f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801326:	00 
  801327:	c7 44 24 08 27 3d 80 	movl   $0x803d27,0x8(%esp)
  80132e:	00 
  80132f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801336:	00 
  801337:	c7 04 24 44 3d 80 00 	movl   $0x803d44,(%esp)
  80133e:	e8 64 f2 ff ff       	call   8005a7 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801343:	83 c4 2c             	add    $0x2c,%esp
  801346:	5b                   	pop    %ebx
  801347:	5e                   	pop    %esi
  801348:	5f                   	pop    %edi
  801349:	5d                   	pop    %ebp
  80134a:	c3                   	ret    

0080134b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	57                   	push   %edi
  80134f:	56                   	push   %esi
  801350:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801351:	ba 00 00 00 00       	mov    $0x0,%edx
  801356:	b8 0e 00 00 00       	mov    $0xe,%eax
  80135b:	89 d1                	mov    %edx,%ecx
  80135d:	89 d3                	mov    %edx,%ebx
  80135f:	89 d7                	mov    %edx,%edi
  801361:	89 d6                	mov    %edx,%esi
  801363:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801365:	5b                   	pop    %ebx
  801366:	5e                   	pop    %esi
  801367:	5f                   	pop    %edi
  801368:	5d                   	pop    %ebp
  801369:	c3                   	ret    

0080136a <sys_e1000_transmit>:

int
sys_e1000_transmit(char *pkt, size_t length)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	57                   	push   %edi
  80136e:	56                   	push   %esi
  80136f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801370:	bb 00 00 00 00       	mov    $0x0,%ebx
  801375:	b8 0f 00 00 00       	mov    $0xf,%eax
  80137a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80137d:	8b 55 08             	mov    0x8(%ebp),%edx
  801380:	89 df                	mov    %ebx,%edi
  801382:	89 de                	mov    %ebx,%esi
  801384:	cd 30                	int    $0x30

int
sys_e1000_transmit(char *pkt, size_t length)
{
	return syscall(SYS_e1000_transmit, 0, (uint32_t) pkt, length, 0, 0, 0);
}
  801386:	5b                   	pop    %ebx
  801387:	5e                   	pop    %esi
  801388:	5f                   	pop    %edi
  801389:	5d                   	pop    %ebp
  80138a:	c3                   	ret    

0080138b <sys_e1000_receive>:

int
sys_e1000_receive(char *pkt, size_t *length)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	57                   	push   %edi
  80138f:	56                   	push   %esi
  801390:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801391:	bb 00 00 00 00       	mov    $0x0,%ebx
  801396:	b8 10 00 00 00       	mov    $0x10,%eax
  80139b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80139e:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a1:	89 df                	mov    %ebx,%edi
  8013a3:	89 de                	mov    %ebx,%esi
  8013a5:	cd 30                	int    $0x30

int
sys_e1000_receive(char *pkt, size_t *length)
{
	return syscall(SYS_e1000_receive, 0, (uint32_t) pkt, (uint32_t) length, 0, 0, 0);
}
  8013a7:	5b                   	pop    %ebx
  8013a8:	5e                   	pop    %esi
  8013a9:	5f                   	pop    %edi
  8013aa:	5d                   	pop    %ebp
  8013ab:	c3                   	ret    

008013ac <sys_e1000_get_mac>:

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	57                   	push   %edi
  8013b0:	56                   	push   %esi
  8013b1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013b7:	b8 11 00 00 00       	mov    $0x11,%eax
  8013bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bf:	89 cb                	mov    %ecx,%ebx
  8013c1:	89 cf                	mov    %ecx,%edi
  8013c3:	89 ce                	mov    %ecx,%esi
  8013c5:	cd 30                	int    $0x30

int
sys_e1000_get_mac(uint8_t *mac_addr)
{
	return syscall(SYS_e1000_get_mac, 0, (uint32_t) mac_addr, 0, 0, 0, 0);
}
  8013c7:	5b                   	pop    %ebx
  8013c8:	5e                   	pop    %esi
  8013c9:	5f                   	pop    %edi
  8013ca:	5d                   	pop    %ebp
  8013cb:	c3                   	ret    

008013cc <sys_exec>:

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
  8013cc:	55                   	push   %ebp
  8013cd:	89 e5                	mov    %esp,%ebp
  8013cf:	57                   	push   %edi
  8013d0:	56                   	push   %esi
  8013d1:	53                   	push   %ebx
  8013d2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013d5:	be 00 00 00 00       	mov    $0x0,%esi
  8013da:	b8 12 00 00 00       	mov    $0x12,%eax
  8013df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013e8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013eb:	cd 30                	int    $0x30
		       "b" (a3),
		       "D" (a4),
		       "S" (a5)
		     : "cc", "memory");

	if(check && ret > 0)
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	7e 28                	jle    801419 <sys_exec+0x4d>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013f5:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8013fc:	00 
  8013fd:	c7 44 24 08 27 3d 80 	movl   $0x803d27,0x8(%esp)
  801404:	00 
  801405:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80140c:	00 
  80140d:	c7 04 24 44 3d 80 00 	movl   $0x803d44,(%esp)
  801414:	e8 8e f1 ff ff       	call   8005a7 <_panic>

int 
sys_exec(uint32_t eip, uint32_t esp, void * v_ph, uint32_t phnum)
{
	return syscall(SYS_exec, 1, eip, esp, (uint32_t)v_ph, phnum, 0);
}
  801419:	83 c4 2c             	add    $0x2c,%esp
  80141c:	5b                   	pop    %ebx
  80141d:	5e                   	pop    %esi
  80141e:	5f                   	pop    %edi
  80141f:	5d                   	pop    %ebp
  801420:	c3                   	ret    

00801421 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801421:	55                   	push   %ebp
  801422:	89 e5                	mov    %esp,%ebp
  801424:	53                   	push   %ebx
  801425:	83 ec 24             	sub    $0x24,%esp
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80142b:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	if ((err & FEC_WR) == 0)
  80142d:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801431:	75 20                	jne    801453 <pgfault+0x32>
		panic("pgfault: faulting address [%08x] not a write\n", addr);
  801433:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801437:	c7 44 24 08 54 3d 80 	movl   $0x803d54,0x8(%esp)
  80143e:	00 
  80143f:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  801446:	00 
  801447:	c7 04 24 d4 3d 80 00 	movl   $0x803dd4,(%esp)
  80144e:	e8 54 f1 ff ff       	call   8005a7 <_panic>

	void *page_aligned_addr = (void *) ROUNDDOWN(addr, PGSIZE);
  801453:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t page_num = (uint32_t) page_aligned_addr / PGSIZE;
  801459:	89 d8                	mov    %ebx,%eax
  80145b:	c1 e8 0c             	shr    $0xc,%eax
	if (!(uvpt[page_num] & PTE_COW))
  80145e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801465:	f6 c4 08             	test   $0x8,%ah
  801468:	75 1c                	jne    801486 <pgfault+0x65>
		panic("pgfault: fault was not on a copy-on-write page\n");
  80146a:	c7 44 24 08 84 3d 80 	movl   $0x803d84,0x8(%esp)
  801471:	00 
  801472:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801479:	00 
  80147a:	c7 04 24 d4 3d 80 00 	movl   $0x803dd4,(%esp)
  801481:	e8 21 f1 ff ff       	call   8005a7 <_panic>
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	// Allocate
	if ((r = sys_page_alloc(0, PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801486:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80148d:	00 
  80148e:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801495:	00 
  801496:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80149d:	e8 41 fc ff ff       	call   8010e3 <sys_page_alloc>
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	79 20                	jns    8014c6 <pgfault+0xa5>
		panic("sys_page_alloc: %e\n", r);
  8014a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014aa:	c7 44 24 08 df 3d 80 	movl   $0x803ddf,0x8(%esp)
  8014b1:	00 
  8014b2:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  8014b9:	00 
  8014ba:	c7 04 24 d4 3d 80 00 	movl   $0x803dd4,(%esp)
  8014c1:	e8 e1 f0 ff ff       	call   8005a7 <_panic>

	// Copy over
	void *src_addr = (void *) ROUNDDOWN(addr, PGSIZE);
	memmove(PFTEMP, src_addr, PGSIZE);
  8014c6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8014cd:	00 
  8014ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014d2:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8014d9:	e8 86 f9 ff ff       	call   800e64 <memmove>

	// Remap
	if ((r = sys_page_map(0, PFTEMP, 0, src_addr, PTE_P | PTE_U | PTE_W)) < 0)
  8014de:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8014e5:	00 
  8014e6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8014ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014f1:	00 
  8014f2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8014f9:	00 
  8014fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801501:	e8 31 fc ff ff       	call   801137 <sys_page_map>
  801506:	85 c0                	test   %eax,%eax
  801508:	79 20                	jns    80152a <pgfault+0x109>
		panic("sys_page_map: %e\n", r);
  80150a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80150e:	c7 44 24 08 f3 3d 80 	movl   $0x803df3,0x8(%esp)
  801515:	00 
  801516:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  80151d:	00 
  80151e:	c7 04 24 d4 3d 80 00 	movl   $0x803dd4,(%esp)
  801525:	e8 7d f0 ff ff       	call   8005a7 <_panic>

	//panic("pgfault not implemented");
}
  80152a:	83 c4 24             	add    $0x24,%esp
  80152d:	5b                   	pop    %ebx
  80152e:	5d                   	pop    %ebp
  80152f:	c3                   	ret    

00801530 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	57                   	push   %edi
  801534:	56                   	push   %esi
  801535:	53                   	push   %ebx
  801536:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.
	int r;
	envid_t child_envid;

	set_pgfault_handler(pgfault);
  801539:	c7 04 24 21 14 80 00 	movl   $0x801421,(%esp)
  801540:	e8 b5 1e 00 00       	call   8033fa <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801545:	b8 07 00 00 00       	mov    $0x7,%eax
  80154a:	cd 30                	int    $0x30
  80154c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80154f:	89 45 e0             	mov    %eax,-0x20(%ebp)

	child_envid = sys_exofork();
	if (child_envid < 0)
  801552:	85 c0                	test   %eax,%eax
  801554:	79 20                	jns    801576 <fork+0x46>
		panic("sys_exofork: %e\n", child_envid);
  801556:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80155a:	c7 44 24 08 05 3e 80 	movl   $0x803e05,0x8(%esp)
  801561:	00 
  801562:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  801569:	00 
  80156a:	c7 04 24 d4 3d 80 00 	movl   $0x803dd4,(%esp)
  801571:	e8 31 f0 ff ff       	call   8005a7 <_panic>
	if (child_envid == 0) { // child
  801576:	bf 00 00 00 00       	mov    $0x0,%edi
  80157b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801580:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801584:	75 21                	jne    8015a7 <fork+0x77>
		// Fix thisenv like dumbfork does and return 0
		thisenv = &envs[ENVX(sys_getenvid())];
  801586:	e8 1a fb ff ff       	call   8010a5 <sys_getenvid>
  80158b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801590:	c1 e0 07             	shl    $0x7,%eax
  801593:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801598:	a3 08 60 80 00       	mov    %eax,0x806008
		return 0;
  80159d:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a2:	e9 53 02 00 00       	jmp    8017fa <fork+0x2ca>
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
  8015a7:	89 d8                	mov    %ebx,%eax
  8015a9:	c1 e8 0a             	shr    $0xa,%eax
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  8015ac:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015b3:	a8 01                	test   $0x1,%al
  8015b5:	0f 84 7a 01 00 00    	je     801735 <fork+0x205>
			((uvpt[page_num] & PTE_P) == PTE_P)) {
  8015bb:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
		uint32_t pdx = ROUNDDOWN(page_num, NPDENTRIES) / NPDENTRIES;
		if ((uvpd[pdx] & PTE_P) == PTE_P &&
  8015c2:	a8 01                	test   $0x1,%al
  8015c4:	0f 84 6b 01 00 00    	je     801735 <fork+0x205>
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
	envid_t this_envid = thisenv->env_id;
  8015ca:	a1 08 60 80 00       	mov    0x806008,%eax
  8015cf:	8b 40 48             	mov    0x48(%eax),%eax
  8015d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// LAB 4: Your code here.
	if (uvpt[pn] & PTE_SHARE) {
  8015d5:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8015dc:	f6 c4 04             	test   $0x4,%ah
  8015df:	74 52                	je     801633 <fork+0x103>
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  8015e1:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8015e8:	25 07 0e 00 00       	and    $0xe07,%eax
  8015ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801600:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801603:	89 04 24             	mov    %eax,(%esp)
  801606:	e8 2c fb ff ff       	call   801137 <sys_page_map>
  80160b:	85 c0                	test   %eax,%eax
  80160d:	0f 89 22 01 00 00    	jns    801735 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801613:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801617:	c7 44 24 08 f3 3d 80 	movl   $0x803df3,0x8(%esp)
  80161e:	00 
  80161f:	c7 44 24 04 4f 00 00 	movl   $0x4f,0x4(%esp)
  801626:	00 
  801627:	c7 04 24 d4 3d 80 00 	movl   $0x803dd4,(%esp)
  80162e:	e8 74 ef ff ff       	call   8005a7 <_panic>
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
  801633:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80163a:	f6 c4 08             	test   $0x8,%ah
  80163d:	75 0f                	jne    80164e <fork+0x11e>
  80163f:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801646:	a8 02                	test   $0x2,%al
  801648:	0f 84 99 00 00 00    	je     8016e7 <fork+0x1b7>
		if (uvpt[pn] & PTE_U)
  80164e:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801655:	83 e0 04             	and    $0x4,%eax
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;
	uint32_t perm = PTE_P | PTE_COW;
  801658:	83 f8 01             	cmp    $0x1,%eax
  80165b:	19 f6                	sbb    %esi,%esi
  80165d:	83 e6 fc             	and    $0xfffffffc,%esi
  801660:	81 c6 05 08 00 00    	add    $0x805,%esi
	} else if (uvpt[pn] & PTE_COW || uvpt[pn] & PTE_W) {
		if (uvpt[pn] & PTE_U)
			perm |= PTE_U;

		// Map page COW, U and P in child
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), perm)) < 0)
  801666:	89 74 24 10          	mov    %esi,0x10(%esp)
  80166a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80166e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801671:	89 44 24 08          	mov    %eax,0x8(%esp)
  801675:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80167c:	89 04 24             	mov    %eax,(%esp)
  80167f:	e8 b3 fa ff ff       	call   801137 <sys_page_map>
  801684:	85 c0                	test   %eax,%eax
  801686:	79 20                	jns    8016a8 <fork+0x178>
			panic("sys_page_map: %e\n", r);
  801688:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80168c:	c7 44 24 08 f3 3d 80 	movl   $0x803df3,0x8(%esp)
  801693:	00 
  801694:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  80169b:	00 
  80169c:	c7 04 24 d4 3d 80 00 	movl   $0x803dd4,(%esp)
  8016a3:	e8 ff ee ff ff       	call   8005a7 <_panic>

		// Map page COW, U and P in parent
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), this_envid, (void *) (pn*PGSIZE), perm)) < 0)
  8016a8:	89 74 24 10          	mov    %esi,0x10(%esp)
  8016ac:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016bb:	89 04 24             	mov    %eax,(%esp)
  8016be:	e8 74 fa ff ff       	call   801137 <sys_page_map>
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	79 6e                	jns    801735 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  8016c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016cb:	c7 44 24 08 f3 3d 80 	movl   $0x803df3,0x8(%esp)
  8016d2:	00 
  8016d3:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8016da:	00 
  8016db:	c7 04 24 d4 3d 80 00 	movl   $0x803dd4,(%esp)
  8016e2:	e8 c0 ee ff ff       	call   8005a7 <_panic>

	} else { // map pages that are present but not writable or COW with their original permissions
		if ((r = sys_page_map(this_envid, (void *) (pn*PGSIZE), envid, (void *) (pn*PGSIZE), uvpt[pn] & PTE_SYSCALL)) < 0)
  8016e7:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8016ee:	25 07 0e 00 00       	and    $0xe07,%eax
  8016f3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016f7:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801702:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801709:	89 04 24             	mov    %eax,(%esp)
  80170c:	e8 26 fa ff ff       	call   801137 <sys_page_map>
  801711:	85 c0                	test   %eax,%eax
  801713:	79 20                	jns    801735 <fork+0x205>
			panic("sys_page_map: %e\n", r);
  801715:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801719:	c7 44 24 08 f3 3d 80 	movl   $0x803df3,0x8(%esp)
  801720:	00 
  801721:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  801728:	00 
  801729:	c7 04 24 d4 3d 80 00 	movl   $0x803dd4,(%esp)
  801730:	e8 72 ee ff ff       	call   8005a7 <_panic>
	// and let duppage worry about the permissions.
	// Note that we don't remap anything above UTOP because the kernel took
	// care of that for us in env_setup_vm().
	uint32_t page_num;
	pte_t *pte;
	for (page_num = 0; page_num < PGNUM(UTOP - PGSIZE); page_num++) {
  801735:	83 c3 01             	add    $0x1,%ebx
  801738:	81 c7 00 10 00 00    	add    $0x1000,%edi
  80173e:	81 fb ff eb 0e 00    	cmp    $0xeebff,%ebx
  801744:	0f 85 5d fe ff ff    	jne    8015a7 <fork+0x77>
	}

	// Allocate exception stack space for child. The child can't do this themselves
	// because the mechanism by which it would is to run the pgfault handler, which
	// needs to run on the exception stack (catch 22).
	if ((r = sys_page_alloc(child_envid, (void *) (UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80174a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801751:	00 
  801752:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801759:	ee 
  80175a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80175d:	89 04 24             	mov    %eax,(%esp)
  801760:	e8 7e f9 ff ff       	call   8010e3 <sys_page_alloc>
  801765:	85 c0                	test   %eax,%eax
  801767:	79 20                	jns    801789 <fork+0x259>
		panic("sys_page_alloc: %e\n", r);
  801769:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80176d:	c7 44 24 08 df 3d 80 	movl   $0x803ddf,0x8(%esp)
  801774:	00 
  801775:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
  80177c:	00 
  80177d:	c7 04 24 d4 3d 80 00 	movl   $0x803dd4,(%esp)
  801784:	e8 1e ee ff ff       	call   8005a7 <_panic>

	// Set page fault handler for the child
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801789:	c7 44 24 04 7b 34 80 	movl   $0x80347b,0x4(%esp)
  801790:	00 
  801791:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801794:	89 04 24             	mov    %eax,(%esp)
  801797:	e8 e7 fa ff ff       	call   801283 <sys_env_set_pgfault_upcall>
  80179c:	85 c0                	test   %eax,%eax
  80179e:	79 20                	jns    8017c0 <fork+0x290>
		panic("sys_env_set_pgfault_upcall: %e\n", r);
  8017a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017a4:	c7 44 24 08 b4 3d 80 	movl   $0x803db4,0x8(%esp)
  8017ab:	00 
  8017ac:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  8017b3:	00 
  8017b4:	c7 04 24 d4 3d 80 00 	movl   $0x803dd4,(%esp)
  8017bb:	e8 e7 ed ff ff       	call   8005a7 <_panic>

	// Mark child environment as runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  8017c0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8017c7:	00 
  8017c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017cb:	89 04 24             	mov    %eax,(%esp)
  8017ce:	e8 0a fa ff ff       	call   8011dd <sys_env_set_status>
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	79 20                	jns    8017f7 <fork+0x2c7>
		panic("sys_env_set_status: %e\n", r);
  8017d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017db:	c7 44 24 08 16 3e 80 	movl   $0x803e16,0x8(%esp)
  8017e2:	00 
  8017e3:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8017ea:	00 
  8017eb:	c7 04 24 d4 3d 80 00 	movl   $0x803dd4,(%esp)
  8017f2:	e8 b0 ed ff ff       	call   8005a7 <_panic>

	return child_envid;
  8017f7:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
  8017fa:	83 c4 2c             	add    $0x2c,%esp
  8017fd:	5b                   	pop    %ebx
  8017fe:	5e                   	pop    %esi
  8017ff:	5f                   	pop    %edi
  801800:	5d                   	pop    %ebp
  801801:	c3                   	ret    

00801802 <sfork>:

// Challenge!
int
sfork(void)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	83 ec 18             	sub    $0x18,%esp
//	return __fork(1);
	panic("sfork not implemented");
  801808:	c7 44 24 08 2e 3e 80 	movl   $0x803e2e,0x8(%esp)
  80180f:	00 
  801810:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  801817:	00 
  801818:	c7 04 24 d4 3d 80 00 	movl   $0x803dd4,(%esp)
  80181f:	e8 83 ed ff ff       	call   8005a7 <_panic>
  801824:	66 90                	xchg   %ax,%ax
  801826:	66 90                	xchg   %ax,%ax
  801828:	66 90                	xchg   %ax,%ax
  80182a:	66 90                	xchg   %ax,%ax
  80182c:	66 90                	xchg   %ax,%ax
  80182e:	66 90                	xchg   %ax,%ax

00801830 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	05 00 00 00 30       	add    $0x30000000,%eax
  80183b:	c1 e8 0c             	shr    $0xc,%eax
}
  80183e:	5d                   	pop    %ebp
  80183f:	c3                   	ret    

00801840 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80184b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801850:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801855:	5d                   	pop    %ebp
  801856:	c3                   	ret    

00801857 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80185d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801862:	89 c2                	mov    %eax,%edx
  801864:	c1 ea 16             	shr    $0x16,%edx
  801867:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80186e:	f6 c2 01             	test   $0x1,%dl
  801871:	74 11                	je     801884 <fd_alloc+0x2d>
  801873:	89 c2                	mov    %eax,%edx
  801875:	c1 ea 0c             	shr    $0xc,%edx
  801878:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80187f:	f6 c2 01             	test   $0x1,%dl
  801882:	75 09                	jne    80188d <fd_alloc+0x36>
			*fd_store = fd;
  801884:	89 01                	mov    %eax,(%ecx)
			return 0;
  801886:	b8 00 00 00 00       	mov    $0x0,%eax
  80188b:	eb 17                	jmp    8018a4 <fd_alloc+0x4d>
  80188d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801892:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801897:	75 c9                	jne    801862 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801899:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80189f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8018a4:	5d                   	pop    %ebp
  8018a5:	c3                   	ret    

008018a6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8018ac:	83 f8 1f             	cmp    $0x1f,%eax
  8018af:	77 36                	ja     8018e7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8018b1:	c1 e0 0c             	shl    $0xc,%eax
  8018b4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8018b9:	89 c2                	mov    %eax,%edx
  8018bb:	c1 ea 16             	shr    $0x16,%edx
  8018be:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8018c5:	f6 c2 01             	test   $0x1,%dl
  8018c8:	74 24                	je     8018ee <fd_lookup+0x48>
  8018ca:	89 c2                	mov    %eax,%edx
  8018cc:	c1 ea 0c             	shr    $0xc,%edx
  8018cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018d6:	f6 c2 01             	test   $0x1,%dl
  8018d9:	74 1a                	je     8018f5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018de:	89 02                	mov    %eax,(%edx)
	return 0;
  8018e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e5:	eb 13                	jmp    8018fa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8018e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018ec:	eb 0c                	jmp    8018fa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8018ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018f3:	eb 05                	jmp    8018fa <fd_lookup+0x54>
  8018f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8018fa:	5d                   	pop    %ebp
  8018fb:	c3                   	ret    

008018fc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	83 ec 18             	sub    $0x18,%esp
  801902:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801905:	ba 00 00 00 00       	mov    $0x0,%edx
  80190a:	eb 13                	jmp    80191f <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
  80190c:	39 08                	cmp    %ecx,(%eax)
  80190e:	75 0c                	jne    80191c <dev_lookup+0x20>
			*dev = devtab[i];
  801910:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801913:	89 01                	mov    %eax,(%ecx)
			return 0;
  801915:	b8 00 00 00 00       	mov    $0x0,%eax
  80191a:	eb 38                	jmp    801954 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  80191c:	83 c2 01             	add    $0x1,%edx
  80191f:	8b 04 95 c0 3e 80 00 	mov    0x803ec0(,%edx,4),%eax
  801926:	85 c0                	test   %eax,%eax
  801928:	75 e2                	jne    80190c <dev_lookup+0x10>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80192a:	a1 08 60 80 00       	mov    0x806008,%eax
  80192f:	8b 40 48             	mov    0x48(%eax),%eax
  801932:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801936:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193a:	c7 04 24 44 3e 80 00 	movl   $0x803e44,(%esp)
  801941:	e8 5a ed ff ff       	call   8006a0 <cprintf>
	*dev = 0;
  801946:	8b 45 0c             	mov    0xc(%ebp),%eax
  801949:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80194f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	56                   	push   %esi
  80195a:	53                   	push   %ebx
  80195b:	83 ec 20             	sub    $0x20,%esp
  80195e:	8b 75 08             	mov    0x8(%ebp),%esi
  801961:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801964:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801967:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80196b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801971:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801974:	89 04 24             	mov    %eax,(%esp)
  801977:	e8 2a ff ff ff       	call   8018a6 <fd_lookup>
  80197c:	85 c0                	test   %eax,%eax
  80197e:	78 05                	js     801985 <fd_close+0x2f>
	    || fd != fd2)
  801980:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801983:	74 0c                	je     801991 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801985:	84 db                	test   %bl,%bl
  801987:	ba 00 00 00 00       	mov    $0x0,%edx
  80198c:	0f 44 c2             	cmove  %edx,%eax
  80198f:	eb 3f                	jmp    8019d0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801991:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801994:	89 44 24 04          	mov    %eax,0x4(%esp)
  801998:	8b 06                	mov    (%esi),%eax
  80199a:	89 04 24             	mov    %eax,(%esp)
  80199d:	e8 5a ff ff ff       	call   8018fc <dev_lookup>
  8019a2:	89 c3                	mov    %eax,%ebx
  8019a4:	85 c0                	test   %eax,%eax
  8019a6:	78 16                	js     8019be <fd_close+0x68>
		if (dev->dev_close)
  8019a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ab:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8019ae:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8019b3:	85 c0                	test   %eax,%eax
  8019b5:	74 07                	je     8019be <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8019b7:	89 34 24             	mov    %esi,(%esp)
  8019ba:	ff d0                	call   *%eax
  8019bc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8019be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019c9:	e8 bc f7 ff ff       	call   80118a <sys_page_unmap>
	return r;
  8019ce:	89 d8                	mov    %ebx,%eax
}
  8019d0:	83 c4 20             	add    $0x20,%esp
  8019d3:	5b                   	pop    %ebx
  8019d4:	5e                   	pop    %esi
  8019d5:	5d                   	pop    %ebp
  8019d6:	c3                   	ret    

008019d7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	89 04 24             	mov    %eax,(%esp)
  8019ea:	e8 b7 fe ff ff       	call   8018a6 <fd_lookup>
  8019ef:	89 c2                	mov    %eax,%edx
  8019f1:	85 d2                	test   %edx,%edx
  8019f3:	78 13                	js     801a08 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8019f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8019fc:	00 
  8019fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a00:	89 04 24             	mov    %eax,(%esp)
  801a03:	e8 4e ff ff ff       	call   801956 <fd_close>
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <close_all>:

void
close_all(void)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	53                   	push   %ebx
  801a0e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801a11:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801a16:	89 1c 24             	mov    %ebx,(%esp)
  801a19:	e8 b9 ff ff ff       	call   8019d7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801a1e:	83 c3 01             	add    $0x1,%ebx
  801a21:	83 fb 20             	cmp    $0x20,%ebx
  801a24:	75 f0                	jne    801a16 <close_all+0xc>
		close(i);
}
  801a26:	83 c4 14             	add    $0x14,%esp
  801a29:	5b                   	pop    %ebx
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    

00801a2c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	57                   	push   %edi
  801a30:	56                   	push   %esi
  801a31:	53                   	push   %ebx
  801a32:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a35:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	89 04 24             	mov    %eax,(%esp)
  801a42:	e8 5f fe ff ff       	call   8018a6 <fd_lookup>
  801a47:	89 c2                	mov    %eax,%edx
  801a49:	85 d2                	test   %edx,%edx
  801a4b:	0f 88 e1 00 00 00    	js     801b32 <dup+0x106>
		return r;
	close(newfdnum);
  801a51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a54:	89 04 24             	mov    %eax,(%esp)
  801a57:	e8 7b ff ff ff       	call   8019d7 <close>

	newfd = INDEX2FD(newfdnum);
  801a5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a5f:	c1 e3 0c             	shl    $0xc,%ebx
  801a62:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801a68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a6b:	89 04 24             	mov    %eax,(%esp)
  801a6e:	e8 cd fd ff ff       	call   801840 <fd2data>
  801a73:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801a75:	89 1c 24             	mov    %ebx,(%esp)
  801a78:	e8 c3 fd ff ff       	call   801840 <fd2data>
  801a7d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801a7f:	89 f0                	mov    %esi,%eax
  801a81:	c1 e8 16             	shr    $0x16,%eax
  801a84:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a8b:	a8 01                	test   $0x1,%al
  801a8d:	74 43                	je     801ad2 <dup+0xa6>
  801a8f:	89 f0                	mov    %esi,%eax
  801a91:	c1 e8 0c             	shr    $0xc,%eax
  801a94:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801a9b:	f6 c2 01             	test   $0x1,%dl
  801a9e:	74 32                	je     801ad2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801aa0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801aa7:	25 07 0e 00 00       	and    $0xe07,%eax
  801aac:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ab0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ab4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801abb:	00 
  801abc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ac0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ac7:	e8 6b f6 ff ff       	call   801137 <sys_page_map>
  801acc:	89 c6                	mov    %eax,%esi
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	78 3e                	js     801b10 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ad5:	89 c2                	mov    %eax,%edx
  801ad7:	c1 ea 0c             	shr    $0xc,%edx
  801ada:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801ae1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801ae7:	89 54 24 10          	mov    %edx,0x10(%esp)
  801aeb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801aef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801af6:	00 
  801af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b02:	e8 30 f6 ff ff       	call   801137 <sys_page_map>
  801b07:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801b09:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801b0c:	85 f6                	test   %esi,%esi
  801b0e:	79 22                	jns    801b32 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801b10:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b1b:	e8 6a f6 ff ff       	call   80118a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b20:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b2b:	e8 5a f6 ff ff       	call   80118a <sys_page_unmap>
	return r;
  801b30:	89 f0                	mov    %esi,%eax
}
  801b32:	83 c4 3c             	add    $0x3c,%esp
  801b35:	5b                   	pop    %ebx
  801b36:	5e                   	pop    %esi
  801b37:	5f                   	pop    %edi
  801b38:	5d                   	pop    %ebp
  801b39:	c3                   	ret    

00801b3a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	53                   	push   %ebx
  801b3e:	83 ec 24             	sub    $0x24,%esp
  801b41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b44:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4b:	89 1c 24             	mov    %ebx,(%esp)
  801b4e:	e8 53 fd ff ff       	call   8018a6 <fd_lookup>
  801b53:	89 c2                	mov    %eax,%edx
  801b55:	85 d2                	test   %edx,%edx
  801b57:	78 6d                	js     801bc6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b59:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b63:	8b 00                	mov    (%eax),%eax
  801b65:	89 04 24             	mov    %eax,(%esp)
  801b68:	e8 8f fd ff ff       	call   8018fc <dev_lookup>
  801b6d:	85 c0                	test   %eax,%eax
  801b6f:	78 55                	js     801bc6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b74:	8b 50 08             	mov    0x8(%eax),%edx
  801b77:	83 e2 03             	and    $0x3,%edx
  801b7a:	83 fa 01             	cmp    $0x1,%edx
  801b7d:	75 23                	jne    801ba2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801b7f:	a1 08 60 80 00       	mov    0x806008,%eax
  801b84:	8b 40 48             	mov    0x48(%eax),%eax
  801b87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8f:	c7 04 24 85 3e 80 00 	movl   $0x803e85,(%esp)
  801b96:	e8 05 eb ff ff       	call   8006a0 <cprintf>
		return -E_INVAL;
  801b9b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ba0:	eb 24                	jmp    801bc6 <read+0x8c>
	}
	if (!dev->dev_read)
  801ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba5:	8b 52 08             	mov    0x8(%edx),%edx
  801ba8:	85 d2                	test   %edx,%edx
  801baa:	74 15                	je     801bc1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801bac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801baf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801bb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801bb6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bba:	89 04 24             	mov    %eax,(%esp)
  801bbd:	ff d2                	call   *%edx
  801bbf:	eb 05                	jmp    801bc6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801bc1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801bc6:	83 c4 24             	add    $0x24,%esp
  801bc9:	5b                   	pop    %ebx
  801bca:	5d                   	pop    %ebp
  801bcb:	c3                   	ret    

00801bcc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	57                   	push   %edi
  801bd0:	56                   	push   %esi
  801bd1:	53                   	push   %ebx
  801bd2:	83 ec 1c             	sub    $0x1c,%esp
  801bd5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bd8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801be0:	eb 23                	jmp    801c05 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801be2:	89 f0                	mov    %esi,%eax
  801be4:	29 d8                	sub    %ebx,%eax
  801be6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bea:	89 d8                	mov    %ebx,%eax
  801bec:	03 45 0c             	add    0xc(%ebp),%eax
  801bef:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf3:	89 3c 24             	mov    %edi,(%esp)
  801bf6:	e8 3f ff ff ff       	call   801b3a <read>
		if (m < 0)
  801bfb:	85 c0                	test   %eax,%eax
  801bfd:	78 10                	js     801c0f <readn+0x43>
			return m;
		if (m == 0)
  801bff:	85 c0                	test   %eax,%eax
  801c01:	74 0a                	je     801c0d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c03:	01 c3                	add    %eax,%ebx
  801c05:	39 f3                	cmp    %esi,%ebx
  801c07:	72 d9                	jb     801be2 <readn+0x16>
  801c09:	89 d8                	mov    %ebx,%eax
  801c0b:	eb 02                	jmp    801c0f <readn+0x43>
  801c0d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801c0f:	83 c4 1c             	add    $0x1c,%esp
  801c12:	5b                   	pop    %ebx
  801c13:	5e                   	pop    %esi
  801c14:	5f                   	pop    %edi
  801c15:	5d                   	pop    %ebp
  801c16:	c3                   	ret    

00801c17 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	53                   	push   %ebx
  801c1b:	83 ec 24             	sub    $0x24,%esp
  801c1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c21:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c28:	89 1c 24             	mov    %ebx,(%esp)
  801c2b:	e8 76 fc ff ff       	call   8018a6 <fd_lookup>
  801c30:	89 c2                	mov    %eax,%edx
  801c32:	85 d2                	test   %edx,%edx
  801c34:	78 68                	js     801c9e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c40:	8b 00                	mov    (%eax),%eax
  801c42:	89 04 24             	mov    %eax,(%esp)
  801c45:	e8 b2 fc ff ff       	call   8018fc <dev_lookup>
  801c4a:	85 c0                	test   %eax,%eax
  801c4c:	78 50                	js     801c9e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c51:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801c55:	75 23                	jne    801c7a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801c57:	a1 08 60 80 00       	mov    0x806008,%eax
  801c5c:	8b 40 48             	mov    0x48(%eax),%eax
  801c5f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c67:	c7 04 24 a1 3e 80 00 	movl   $0x803ea1,(%esp)
  801c6e:	e8 2d ea ff ff       	call   8006a0 <cprintf>
		return -E_INVAL;
  801c73:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801c78:	eb 24                	jmp    801c9e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c7d:	8b 52 0c             	mov    0xc(%edx),%edx
  801c80:	85 d2                	test   %edx,%edx
  801c82:	74 15                	je     801c99 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801c84:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c8b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c92:	89 04 24             	mov    %eax,(%esp)
  801c95:	ff d2                	call   *%edx
  801c97:	eb 05                	jmp    801c9e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801c99:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801c9e:	83 c4 24             	add    $0x24,%esp
  801ca1:	5b                   	pop    %ebx
  801ca2:	5d                   	pop    %ebp
  801ca3:	c3                   	ret    

00801ca4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ca4:	55                   	push   %ebp
  801ca5:	89 e5                	mov    %esp,%ebp
  801ca7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801caa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801cad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	89 04 24             	mov    %eax,(%esp)
  801cb7:	e8 ea fb ff ff       	call   8018a6 <fd_lookup>
  801cbc:	85 c0                	test   %eax,%eax
  801cbe:	78 0e                	js     801cce <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801cc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801cc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	53                   	push   %ebx
  801cd4:	83 ec 24             	sub    $0x24,%esp
  801cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cda:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce1:	89 1c 24             	mov    %ebx,(%esp)
  801ce4:	e8 bd fb ff ff       	call   8018a6 <fd_lookup>
  801ce9:	89 c2                	mov    %eax,%edx
  801ceb:	85 d2                	test   %edx,%edx
  801ced:	78 61                	js     801d50 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cf2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf9:	8b 00                	mov    (%eax),%eax
  801cfb:	89 04 24             	mov    %eax,(%esp)
  801cfe:	e8 f9 fb ff ff       	call   8018fc <dev_lookup>
  801d03:	85 c0                	test   %eax,%eax
  801d05:	78 49                	js     801d50 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801d0e:	75 23                	jne    801d33 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801d10:	a1 08 60 80 00       	mov    0x806008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d15:	8b 40 48             	mov    0x48(%eax),%eax
  801d18:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d20:	c7 04 24 64 3e 80 00 	movl   $0x803e64,(%esp)
  801d27:	e8 74 e9 ff ff       	call   8006a0 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801d2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d31:	eb 1d                	jmp    801d50 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801d33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d36:	8b 52 18             	mov    0x18(%edx),%edx
  801d39:	85 d2                	test   %edx,%edx
  801d3b:	74 0e                	je     801d4b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d40:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d44:	89 04 24             	mov    %eax,(%esp)
  801d47:	ff d2                	call   *%edx
  801d49:	eb 05                	jmp    801d50 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801d4b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801d50:	83 c4 24             	add    $0x24,%esp
  801d53:	5b                   	pop    %ebx
  801d54:	5d                   	pop    %ebp
  801d55:	c3                   	ret    

00801d56 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	53                   	push   %ebx
  801d5a:	83 ec 24             	sub    $0x24,%esp
  801d5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d60:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	89 04 24             	mov    %eax,(%esp)
  801d6d:	e8 34 fb ff ff       	call   8018a6 <fd_lookup>
  801d72:	89 c2                	mov    %eax,%edx
  801d74:	85 d2                	test   %edx,%edx
  801d76:	78 52                	js     801dca <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d78:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d82:	8b 00                	mov    (%eax),%eax
  801d84:	89 04 24             	mov    %eax,(%esp)
  801d87:	e8 70 fb ff ff       	call   8018fc <dev_lookup>
  801d8c:	85 c0                	test   %eax,%eax
  801d8e:	78 3a                	js     801dca <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d93:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801d97:	74 2c                	je     801dc5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d99:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d9c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801da3:	00 00 00 
	stat->st_isdir = 0;
  801da6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dad:	00 00 00 
	stat->st_dev = dev;
  801db0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801db6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dbd:	89 14 24             	mov    %edx,(%esp)
  801dc0:	ff 50 14             	call   *0x14(%eax)
  801dc3:	eb 05                	jmp    801dca <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801dc5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801dca:	83 c4 24             	add    $0x24,%esp
  801dcd:	5b                   	pop    %ebx
  801dce:	5d                   	pop    %ebp
  801dcf:	c3                   	ret    

00801dd0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
  801dd3:	56                   	push   %esi
  801dd4:	53                   	push   %ebx
  801dd5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801dd8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ddf:	00 
  801de0:	8b 45 08             	mov    0x8(%ebp),%eax
  801de3:	89 04 24             	mov    %eax,(%esp)
  801de6:	e8 84 02 00 00       	call   80206f <open>
  801deb:	89 c3                	mov    %eax,%ebx
  801ded:	85 db                	test   %ebx,%ebx
  801def:	78 1b                	js     801e0c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df8:	89 1c 24             	mov    %ebx,(%esp)
  801dfb:	e8 56 ff ff ff       	call   801d56 <fstat>
  801e00:	89 c6                	mov    %eax,%esi
	close(fd);
  801e02:	89 1c 24             	mov    %ebx,(%esp)
  801e05:	e8 cd fb ff ff       	call   8019d7 <close>
	return r;
  801e0a:	89 f0                	mov    %esi,%eax
}
  801e0c:	83 c4 10             	add    $0x10,%esp
  801e0f:	5b                   	pop    %ebx
  801e10:	5e                   	pop    %esi
  801e11:	5d                   	pop    %ebp
  801e12:	c3                   	ret    

00801e13 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	56                   	push   %esi
  801e17:	53                   	push   %ebx
  801e18:	83 ec 10             	sub    $0x10,%esp
  801e1b:	89 c6                	mov    %eax,%esi
  801e1d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801e1f:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801e26:	75 11                	jne    801e39 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801e28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801e2f:	e8 61 17 00 00       	call   803595 <ipc_find_env>
  801e34:	a3 00 60 80 00       	mov    %eax,0x806000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e39:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e40:	00 
  801e41:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801e48:	00 
  801e49:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e4d:	a1 00 60 80 00       	mov    0x806000,%eax
  801e52:	89 04 24             	mov    %eax,(%esp)
  801e55:	e8 ae 16 00 00       	call   803508 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e5a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e61:	00 
  801e62:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e66:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e6d:	e8 2e 16 00 00       	call   8034a0 <ipc_recv>
}
  801e72:	83 c4 10             	add    $0x10,%esp
  801e75:	5b                   	pop    %ebx
  801e76:	5e                   	pop    %esi
  801e77:	5d                   	pop    %ebp
  801e78:	c3                   	ret    

00801e79 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	8b 40 0c             	mov    0xc(%eax),%eax
  801e85:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  801e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e8d:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e92:	ba 00 00 00 00       	mov    $0x0,%edx
  801e97:	b8 02 00 00 00       	mov    $0x2,%eax
  801e9c:	e8 72 ff ff ff       	call   801e13 <fsipc>
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	8b 40 0c             	mov    0xc(%eax),%eax
  801eaf:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801eb4:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb9:	b8 06 00 00 00       	mov    $0x6,%eax
  801ebe:	e8 50 ff ff ff       	call   801e13 <fsipc>
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <devfile_stat>:
	return r;
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	53                   	push   %ebx
  801ec9:	83 ec 14             	sub    $0x14,%esp
  801ecc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed5:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801eda:	ba 00 00 00 00       	mov    $0x0,%edx
  801edf:	b8 05 00 00 00       	mov    $0x5,%eax
  801ee4:	e8 2a ff ff ff       	call   801e13 <fsipc>
  801ee9:	89 c2                	mov    %eax,%edx
  801eeb:	85 d2                	test   %edx,%edx
  801eed:	78 2b                	js     801f1a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801eef:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801ef6:	00 
  801ef7:	89 1c 24             	mov    %ebx,(%esp)
  801efa:	e8 c8 ed ff ff       	call   800cc7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801eff:	a1 80 70 80 00       	mov    0x807080,%eax
  801f04:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f0a:	a1 84 70 80 00       	mov    0x807084,%eax
  801f0f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801f15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1a:	83 c4 14             	add    $0x14,%esp
  801f1d:	5b                   	pop    %ebx
  801f1e:	5d                   	pop    %ebp
  801f1f:	c3                   	ret    

00801f20 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	53                   	push   %ebx
  801f24:	83 ec 14             	sub    $0x14,%esp
  801f27:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// bytes than requested.
	// LAB 5: Your code here
	int r;

	const ssize_t wbuf_size = sizeof(fsipcbuf.write.req_buf);
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f30:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.write.req_n = n > wbuf_size? wbuf_size: n;
  801f35:	81 fb f8 0f 00 00    	cmp    $0xff8,%ebx
  801f3b:	b8 f8 0f 00 00       	mov    $0xff8,%eax
  801f40:	0f 46 c3             	cmovbe %ebx,%eax
  801f43:	a3 04 70 80 00       	mov    %eax,0x807004

	memmove(fsipcbuf.write.req_buf, buf, fsipcbuf.write.req_n);
  801f48:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f53:	c7 04 24 08 70 80 00 	movl   $0x807008,(%esp)
  801f5a:	e8 05 ef ff ff       	call   800e64 <memmove>

	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801f5f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f64:	b8 04 00 00 00       	mov    $0x4,%eax
  801f69:	e8 a5 fe ff ff       	call   801e13 <fsipc>
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	78 53                	js     801fc5 <devfile_write+0xa5>
		return r;

	assert(r <= n);
  801f72:	39 c3                	cmp    %eax,%ebx
  801f74:	73 24                	jae    801f9a <devfile_write+0x7a>
  801f76:	c7 44 24 0c d4 3e 80 	movl   $0x803ed4,0xc(%esp)
  801f7d:	00 
  801f7e:	c7 44 24 08 db 3e 80 	movl   $0x803edb,0x8(%esp)
  801f85:	00 
  801f86:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  801f8d:	00 
  801f8e:	c7 04 24 f0 3e 80 00 	movl   $0x803ef0,(%esp)
  801f95:	e8 0d e6 ff ff       	call   8005a7 <_panic>
	assert(r <= PGSIZE);
  801f9a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f9f:	7e 24                	jle    801fc5 <devfile_write+0xa5>
  801fa1:	c7 44 24 0c fb 3e 80 	movl   $0x803efb,0xc(%esp)
  801fa8:	00 
  801fa9:	c7 44 24 08 db 3e 80 	movl   $0x803edb,0x8(%esp)
  801fb0:	00 
  801fb1:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  801fb8:	00 
  801fb9:	c7 04 24 f0 3e 80 00 	movl   $0x803ef0,(%esp)
  801fc0:	e8 e2 e5 ff ff       	call   8005a7 <_panic>
	return r;
}
  801fc5:	83 c4 14             	add    $0x14,%esp
  801fc8:	5b                   	pop    %ebx
  801fc9:	5d                   	pop    %ebp
  801fca:	c3                   	ret    

00801fcb <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	56                   	push   %esi
  801fcf:	53                   	push   %ebx
  801fd0:	83 ec 10             	sub    $0x10,%esp
  801fd3:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	8b 40 0c             	mov    0xc(%eax),%eax
  801fdc:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801fe1:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801fe7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fec:	b8 03 00 00 00       	mov    $0x3,%eax
  801ff1:	e8 1d fe ff ff       	call   801e13 <fsipc>
  801ff6:	89 c3                	mov    %eax,%ebx
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	78 6a                	js     802066 <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ffc:	39 c6                	cmp    %eax,%esi
  801ffe:	73 24                	jae    802024 <devfile_read+0x59>
  802000:	c7 44 24 0c d4 3e 80 	movl   $0x803ed4,0xc(%esp)
  802007:	00 
  802008:	c7 44 24 08 db 3e 80 	movl   $0x803edb,0x8(%esp)
  80200f:	00 
  802010:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  802017:	00 
  802018:	c7 04 24 f0 3e 80 00 	movl   $0x803ef0,(%esp)
  80201f:	e8 83 e5 ff ff       	call   8005a7 <_panic>
	assert(r <= PGSIZE);
  802024:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802029:	7e 24                	jle    80204f <devfile_read+0x84>
  80202b:	c7 44 24 0c fb 3e 80 	movl   $0x803efb,0xc(%esp)
  802032:	00 
  802033:	c7 44 24 08 db 3e 80 	movl   $0x803edb,0x8(%esp)
  80203a:	00 
  80203b:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  802042:	00 
  802043:	c7 04 24 f0 3e 80 00 	movl   $0x803ef0,(%esp)
  80204a:	e8 58 e5 ff ff       	call   8005a7 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80204f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802053:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80205a:	00 
  80205b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205e:	89 04 24             	mov    %eax,(%esp)
  802061:	e8 fe ed ff ff       	call   800e64 <memmove>
	return r;
}
  802066:	89 d8                	mov    %ebx,%eax
  802068:	83 c4 10             	add    $0x10,%esp
  80206b:	5b                   	pop    %ebx
  80206c:	5e                   	pop    %esi
  80206d:	5d                   	pop    %ebp
  80206e:	c3                   	ret    

0080206f <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  80206f:	55                   	push   %ebp
  802070:	89 e5                	mov    %esp,%ebp
  802072:	53                   	push   %ebx
  802073:	83 ec 24             	sub    $0x24,%esp
  802076:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802079:	89 1c 24             	mov    %ebx,(%esp)
  80207c:	e8 0f ec ff ff       	call   800c90 <strlen>
  802081:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802086:	7f 60                	jg     8020e8 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  802088:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80208b:	89 04 24             	mov    %eax,(%esp)
  80208e:	e8 c4 f7 ff ff       	call   801857 <fd_alloc>
  802093:	89 c2                	mov    %eax,%edx
  802095:	85 d2                	test   %edx,%edx
  802097:	78 54                	js     8020ed <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  802099:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80209d:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  8020a4:	e8 1e ec ff ff       	call   800cc7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8020a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ac:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8020b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b9:	e8 55 fd ff ff       	call   801e13 <fsipc>
  8020be:	89 c3                	mov    %eax,%ebx
  8020c0:	85 c0                	test   %eax,%eax
  8020c2:	79 17                	jns    8020db <open+0x6c>
		fd_close(fd, 0);
  8020c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020cb:	00 
  8020cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cf:	89 04 24             	mov    %eax,(%esp)
  8020d2:	e8 7f f8 ff ff       	call   801956 <fd_close>
		return r;
  8020d7:	89 d8                	mov    %ebx,%eax
  8020d9:	eb 12                	jmp    8020ed <open+0x7e>
	}

	return fd2num(fd);
  8020db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020de:	89 04 24             	mov    %eax,(%esp)
  8020e1:	e8 4a f7 ff ff       	call   801830 <fd2num>
  8020e6:	eb 05                	jmp    8020ed <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8020e8:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  8020ed:	83 c4 24             	add    $0x24,%esp
  8020f0:	5b                   	pop    %ebx
  8020f1:	5d                   	pop    %ebp
  8020f2:	c3                   	ret    

008020f3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8020f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8020fe:	b8 08 00 00 00       	mov    $0x8,%eax
  802103:	e8 0b fd ff ff       	call   801e13 <fsipc>
}
  802108:	c9                   	leave  
  802109:	c3                   	ret    
  80210a:	66 90                	xchg   %ax,%ax
  80210c:	66 90                	xchg   %ax,%ax
  80210e:	66 90                	xchg   %ax,%ax

00802110 <map_segment>:
}

static int
map_segment(envid_t child, uintptr_t va, size_t memsz,
	int fd, size_t filesz, off_t fileoffset, int perm)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	57                   	push   %edi
  802114:	56                   	push   %esi
  802115:	53                   	push   %ebx
  802116:	83 ec 2c             	sub    $0x2c,%esp
  802119:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80211c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  80211f:	89 d0                	mov    %edx,%eax
  802121:	25 ff 0f 00 00       	and    $0xfff,%eax
  802126:	74 0b                	je     802133 <map_segment+0x23>
		va -= i;
  802128:	29 c2                	sub    %eax,%edx
		memsz += i;
  80212a:	01 45 e4             	add    %eax,-0x1c(%ebp)
		filesz += i;
  80212d:	01 45 0c             	add    %eax,0xc(%ebp)
		fileoffset -= i;
  802130:	29 45 10             	sub    %eax,0x10(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802133:	89 d6                	mov    %edx,%esi
  802135:	bb 00 00 00 00       	mov    $0x0,%ebx
  80213a:	e9 ff 00 00 00       	jmp    80223e <map_segment+0x12e>
		if (i >= filesz) {
  80213f:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
  802142:	77 23                	ja     802167 <map_segment+0x57>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802144:	8b 45 14             	mov    0x14(%ebp),%eax
  802147:	89 44 24 08          	mov    %eax,0x8(%esp)
  80214b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80214f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802152:	89 04 24             	mov    %eax,(%esp)
  802155:	e8 89 ef ff ff       	call   8010e3 <sys_page_alloc>
  80215a:	85 c0                	test   %eax,%eax
  80215c:	0f 89 d0 00 00 00    	jns    802232 <map_segment+0x122>
  802162:	e9 e7 00 00 00       	jmp    80224e <map_segment+0x13e>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802167:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80216e:	00 
  80216f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802176:	00 
  802177:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80217e:	e8 60 ef ff ff       	call   8010e3 <sys_page_alloc>
  802183:	85 c0                	test   %eax,%eax
  802185:	0f 88 c3 00 00 00    	js     80224e <map_segment+0x13e>
  80218b:	89 f8                	mov    %edi,%eax
  80218d:	03 45 10             	add    0x10(%ebp),%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802190:	89 44 24 04          	mov    %eax,0x4(%esp)
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	89 04 24             	mov    %eax,(%esp)
  80219a:	e8 05 fb ff ff       	call   801ca4 <seek>
  80219f:	85 c0                	test   %eax,%eax
  8021a1:	0f 88 a7 00 00 00    	js     80224e <map_segment+0x13e>
  8021a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021aa:	29 f8                	sub    %edi,%eax
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8021ac:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8021b1:	b9 00 10 00 00       	mov    $0x1000,%ecx
  8021b6:	0f 47 c1             	cmova  %ecx,%eax
  8021b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021bd:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8021c4:	00 
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	89 04 24             	mov    %eax,(%esp)
  8021cb:	e8 fc f9 ff ff       	call   801bcc <readn>
  8021d0:	85 c0                	test   %eax,%eax
  8021d2:	78 7a                	js     80224e <map_segment+0x13e>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8021d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8021d7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8021db:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8021df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021e6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8021ed:	00 
  8021ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021f5:	e8 3d ef ff ff       	call   801137 <sys_page_map>
  8021fa:	85 c0                	test   %eax,%eax
  8021fc:	79 20                	jns    80221e <map_segment+0x10e>
				panic("spawn: sys_page_map data: %e", r);
  8021fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802202:	c7 44 24 08 07 3f 80 	movl   $0x803f07,0x8(%esp)
  802209:	00 
  80220a:	c7 44 24 04 ac 01 00 	movl   $0x1ac,0x4(%esp)
  802211:	00 
  802212:	c7 04 24 24 3f 80 00 	movl   $0x803f24,(%esp)
  802219:	e8 89 e3 ff ff       	call   8005a7 <_panic>
			sys_page_unmap(0, UTEMP);
  80221e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802225:	00 
  802226:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80222d:	e8 58 ef ff ff       	call   80118a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802232:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802238:	81 c6 00 10 00 00    	add    $0x1000,%esi
  80223e:	89 df                	mov    %ebx,%edi
  802240:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
  802243:	0f 87 f6 fe ff ff    	ja     80213f <map_segment+0x2f>
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
		}
	}
	return 0;
  802249:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80224e:	83 c4 2c             	add    $0x2c,%esp
  802251:	5b                   	pop    %ebx
  802252:	5e                   	pop    %esi
  802253:	5f                   	pop    %edi
  802254:	5d                   	pop    %ebp
  802255:	c3                   	ret    

00802256 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	57                   	push   %edi
  80225a:	56                   	push   %esi
  80225b:	53                   	push   %ebx
  80225c:	81 ec 8c 02 00 00    	sub    $0x28c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802262:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802269:	00 
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	89 04 24             	mov    %eax,(%esp)
  802270:	e8 fa fd ff ff       	call   80206f <open>
  802275:	89 c1                	mov    %eax,%ecx
  802277:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
  80227d:	85 c0                	test   %eax,%eax
  80227f:	0f 88 9f 03 00 00    	js     802624 <spawn+0x3ce>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802285:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80228c:	00 
  80228d:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802293:	89 44 24 04          	mov    %eax,0x4(%esp)
  802297:	89 0c 24             	mov    %ecx,(%esp)
  80229a:	e8 2d f9 ff ff       	call   801bcc <readn>
  80229f:	3d 00 02 00 00       	cmp    $0x200,%eax
  8022a4:	75 0c                	jne    8022b2 <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  8022a6:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8022ad:	45 4c 46 
  8022b0:	74 36                	je     8022e8 <spawn+0x92>
		close(fd);
  8022b2:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8022b8:	89 04 24             	mov    %eax,(%esp)
  8022bb:	e8 17 f7 ff ff       	call   8019d7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8022c0:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  8022c7:	46 
  8022c8:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  8022ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d2:	c7 04 24 30 3f 80 00 	movl   $0x803f30,(%esp)
  8022d9:	e8 c2 e3 ff ff       	call   8006a0 <cprintf>
		return -E_NOT_EXEC;
  8022de:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8022e3:	e9 c0 03 00 00       	jmp    8026a8 <spawn+0x452>
  8022e8:	b8 07 00 00 00       	mov    $0x7,%eax
  8022ed:	cd 30                	int    $0x30
  8022ef:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  8022f5:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8022fb:	85 c0                	test   %eax,%eax
  8022fd:	0f 88 29 03 00 00    	js     80262c <spawn+0x3d6>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802303:	89 c6                	mov    %eax,%esi
  802305:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  80230b:	c1 e6 07             	shl    $0x7,%esi
  80230e:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802314:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80231a:	b9 11 00 00 00       	mov    $0x11,%ecx
  80231f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802321:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802327:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80232d:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802332:	be 00 00 00 00       	mov    $0x0,%esi
  802337:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80233a:	eb 0f                	jmp    80234b <spawn+0xf5>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  80233c:	89 04 24             	mov    %eax,(%esp)
  80233f:	e8 4c e9 ff ff       	call   800c90 <strlen>
  802344:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802348:	83 c3 01             	add    $0x1,%ebx
  80234b:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  802352:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  802355:	85 c0                	test   %eax,%eax
  802357:	75 e3                	jne    80233c <spawn+0xe6>
  802359:	89 9d 80 fd ff ff    	mov    %ebx,-0x280(%ebp)
  80235f:	89 8d 7c fd ff ff    	mov    %ecx,-0x284(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802365:	bf 00 10 40 00       	mov    $0x401000,%edi
  80236a:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80236c:	89 fa                	mov    %edi,%edx
  80236e:	83 e2 fc             	and    $0xfffffffc,%edx
  802371:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  802378:	29 c2                	sub    %eax,%edx
  80237a:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802380:	8d 42 f8             	lea    -0x8(%edx),%eax
  802383:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802388:	0f 86 ae 02 00 00    	jbe    80263c <spawn+0x3e6>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80238e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802395:	00 
  802396:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80239d:	00 
  80239e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023a5:	e8 39 ed ff ff       	call   8010e3 <sys_page_alloc>
  8023aa:	85 c0                	test   %eax,%eax
  8023ac:	0f 88 f6 02 00 00    	js     8026a8 <spawn+0x452>
  8023b2:	be 00 00 00 00       	mov    $0x0,%esi
  8023b7:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  8023bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8023c0:	eb 30                	jmp    8023f2 <spawn+0x19c>
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  8023c2:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8023c8:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8023ce:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  8023d1:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  8023d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d8:	89 3c 24             	mov    %edi,(%esp)
  8023db:	e8 e7 e8 ff ff       	call   800cc7 <strcpy>
		string_store += strlen(argv[i]) + 1;
  8023e0:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  8023e3:	89 04 24             	mov    %eax,(%esp)
  8023e6:	e8 a5 e8 ff ff       	call   800c90 <strlen>
  8023eb:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8023ef:	83 c6 01             	add    $0x1,%esi
  8023f2:	3b b5 90 fd ff ff    	cmp    -0x270(%ebp),%esi
  8023f8:	7c c8                	jl     8023c2 <spawn+0x16c>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8023fa:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802400:	8b 8d 7c fd ff ff    	mov    -0x284(%ebp),%ecx
  802406:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  80240d:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802413:	74 24                	je     802439 <spawn+0x1e3>
  802415:	c7 44 24 0c a8 3f 80 	movl   $0x803fa8,0xc(%esp)
  80241c:	00 
  80241d:	c7 44 24 08 db 3e 80 	movl   $0x803edb,0x8(%esp)
  802424:	00 
  802425:	c7 44 24 04 4a 01 00 	movl   $0x14a,0x4(%esp)
  80242c:	00 
  80242d:	c7 04 24 24 3f 80 00 	movl   $0x803f24,(%esp)
  802434:	e8 6e e1 ff ff       	call   8005a7 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802439:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  80243f:	89 c8                	mov    %ecx,%eax
  802441:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802446:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802449:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80244f:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802452:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  802458:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80245e:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802465:	00 
  802466:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  80246d:	ee 
  80246e:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802474:	89 44 24 08          	mov    %eax,0x8(%esp)
  802478:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80247f:	00 
  802480:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802487:	e8 ab ec ff ff       	call   801137 <sys_page_map>
  80248c:	89 c7                	mov    %eax,%edi
  80248e:	85 c0                	test   %eax,%eax
  802490:	0f 88 fc 01 00 00    	js     802692 <spawn+0x43c>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802496:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80249d:	00 
  80249e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a5:	e8 e0 ec ff ff       	call   80118a <sys_page_unmap>
  8024aa:	89 c7                	mov    %eax,%edi
  8024ac:	85 c0                	test   %eax,%eax
  8024ae:	0f 88 de 01 00 00    	js     802692 <spawn+0x43c>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8024b4:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8024ba:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8024c1:	be 00 00 00 00       	mov    $0x0,%esi
  8024c6:	8b bd 88 fd ff ff    	mov    -0x278(%ebp),%edi
  8024cc:	eb 4a                	jmp    802518 <spawn+0x2c2>
		if (ph->p_type != ELF_PROG_LOAD)
  8024ce:	83 3b 01             	cmpl   $0x1,(%ebx)
  8024d1:	75 3f                	jne    802512 <spawn+0x2bc>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8024d3:	8b 43 18             	mov    0x18(%ebx),%eax
  8024d6:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  8024d9:	83 f8 01             	cmp    $0x1,%eax
  8024dc:	19 c0                	sbb    %eax,%eax
  8024de:	83 e0 fe             	and    $0xfffffffe,%eax
  8024e1:	83 c0 07             	add    $0x7,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  8024e4:	8b 4b 14             	mov    0x14(%ebx),%ecx
  8024e7:	8b 53 08             	mov    0x8(%ebx),%edx
  8024ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024ee:	8b 43 04             	mov    0x4(%ebx),%eax
  8024f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024f5:	8b 43 10             	mov    0x10(%ebx),%eax
  8024f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024fc:	89 3c 24             	mov    %edi,(%esp)
  8024ff:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802505:	e8 06 fc ff ff       	call   802110 <map_segment>
  80250a:	85 c0                	test   %eax,%eax
  80250c:	0f 88 ed 00 00 00    	js     8025ff <spawn+0x3a9>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802512:	83 c6 01             	add    $0x1,%esi
  802515:	83 c3 20             	add    $0x20,%ebx
  802518:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  80251f:	39 c6                	cmp    %eax,%esi
  802521:	7c ab                	jl     8024ce <spawn+0x278>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802523:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802529:	89 04 24             	mov    %eax,(%esp)
  80252c:	e8 a6 f4 ff ff       	call   8019d7 <close>
	uint8_t *addr, *end_addr;
    int perm;
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
  802531:	bb 00 00 00 00       	mov    $0x0,%ebx
  802536:	8b b5 8c fd ff ff    	mov    -0x274(%ebp),%esi
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)) {
  80253c:	89 d8                	mov    %ebx,%eax
  80253e:	c1 e8 16             	shr    $0x16,%eax
  802541:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802548:	a8 01                	test   $0x1,%al
  80254a:	74 46                	je     802592 <spawn+0x33c>
  80254c:	89 d8                	mov    %ebx,%eax
  80254e:	c1 e8 0c             	shr    $0xc,%eax
  802551:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802558:	f6 c2 01             	test   $0x1,%dl
  80255b:	74 35                	je     802592 <spawn+0x33c>
			perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  80255d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
            if (perm & PTE_SHARE) {
  802564:	f6 c4 04             	test   $0x4,%ah
  802567:	74 29                	je     802592 <spawn+0x33c>
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
		if ((uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_P)) {
			perm = uvpt[PGNUM(addr)] & PTE_SYSCALL;
  802569:	25 07 0e 00 00       	and    $0xe07,%eax
            if (perm & PTE_SHARE) {
                if ((r = sys_page_map(0, addr, child, addr, perm)) < 0) 
  80256e:	89 44 24 10          	mov    %eax,0x10(%esp)
  802572:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802576:	89 74 24 08          	mov    %esi,0x8(%esp)
  80257a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80257e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802585:	e8 ad eb ff ff       	call   801137 <sys_page_map>
  80258a:	85 c0                	test   %eax,%eax
  80258c:	0f 88 b1 00 00 00    	js     802643 <spawn+0x3ed>
	uint8_t *addr, *end_addr;
    int perm;
    int r;

	end_addr = (uint8_t *) (UXSTACKTOP - PGSIZE);
	for (addr = 0; addr < end_addr; addr += PGSIZE) {	
  802592:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802598:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  80259e:	75 9c                	jne    80253c <spawn+0x2e6>
  8025a0:	e9 be 00 00 00       	jmp    802663 <spawn+0x40d>
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  8025a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025a9:	c7 44 24 08 4a 3f 80 	movl   $0x803f4a,0x8(%esp)
  8025b0:	00 
  8025b1:	c7 44 24 04 8b 00 00 	movl   $0x8b,0x4(%esp)
  8025b8:	00 
  8025b9:	c7 04 24 24 3f 80 00 	movl   $0x803f24,(%esp)
  8025c0:	e8 e2 df ff ff       	call   8005a7 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8025c5:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8025cc:	00 
  8025cd:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8025d3:	89 04 24             	mov    %eax,(%esp)
  8025d6:	e8 02 ec ff ff       	call   8011dd <sys_env_set_status>
  8025db:	85 c0                	test   %eax,%eax
  8025dd:	79 55                	jns    802634 <spawn+0x3de>
		panic("sys_env_set_status: %e", r);
  8025df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025e3:	c7 44 24 08 64 3f 80 	movl   $0x803f64,0x8(%esp)
  8025ea:	00 
  8025eb:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  8025f2:	00 
  8025f3:	c7 04 24 24 3f 80 00 	movl   $0x803f24,(%esp)
  8025fa:	e8 a8 df ff ff       	call   8005a7 <_panic>
  8025ff:	89 c7                	mov    %eax,%edi

	return child;

error:
	sys_env_destroy(child);
  802601:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802607:	89 04 24             	mov    %eax,(%esp)
  80260a:	e8 44 ea ff ff       	call   801053 <sys_env_destroy>
	close(fd);
  80260f:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802615:	89 04 24             	mov    %eax,(%esp)
  802618:	e8 ba f3 ff ff       	call   8019d7 <close>
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  80261d:	89 f8                	mov    %edi,%eax
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  80261f:	e9 84 00 00 00       	jmp    8026a8 <spawn+0x452>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  802624:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80262a:	eb 7c                	jmp    8026a8 <spawn+0x452>
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  80262c:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802632:	eb 74                	jmp    8026a8 <spawn+0x452>
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);

	return child;
  802634:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  80263a:	eb 6c                	jmp    8026a8 <spawn+0x452>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  80263c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  802641:	eb 65                	jmp    8026a8 <spawn+0x452>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  802643:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802647:	c7 44 24 08 7b 3f 80 	movl   $0x803f7b,0x8(%esp)
  80264e:	00 
  80264f:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  802656:	00 
  802657:	c7 04 24 24 3f 80 00 	movl   $0x803f24,(%esp)
  80265e:	e8 44 df ff ff       	call   8005a7 <_panic>

	child_tf.tf_eflags |= FL_IOPL_3;   // devious: see user/faultio.c
  802663:	81 8d dc fd ff ff 00 	orl    $0x3000,-0x224(%ebp)
  80266a:	30 00 00 
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80266d:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802673:	89 44 24 04          	mov    %eax,0x4(%esp)
  802677:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  80267d:	89 04 24             	mov    %eax,(%esp)
  802680:	e8 ab eb ff ff       	call   801230 <sys_env_set_trapframe>
  802685:	85 c0                	test   %eax,%eax
  802687:	0f 89 38 ff ff ff    	jns    8025c5 <spawn+0x36f>
  80268d:	e9 13 ff ff ff       	jmp    8025a5 <spawn+0x34f>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802692:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802699:	00 
  80269a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a1:	e8 e4 ea ff ff       	call   80118a <sys_page_unmap>
  8026a6:	89 f8                	mov    %edi,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  8026a8:	81 c4 8c 02 00 00    	add    $0x28c,%esp
  8026ae:	5b                   	pop    %ebx
  8026af:	5e                   	pop    %esi
  8026b0:	5f                   	pop    %edi
  8026b1:	5d                   	pop    %ebp
  8026b2:	c3                   	ret    

008026b3 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  8026b3:	55                   	push   %ebp
  8026b4:	89 e5                	mov    %esp,%ebp
  8026b6:	56                   	push   %esi
  8026b7:	53                   	push   %ebx
  8026b8:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8026bb:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  8026be:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8026c3:	eb 03                	jmp    8026c8 <spawnl+0x15>
		argc++;
  8026c5:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  8026c8:	83 c0 04             	add    $0x4,%eax
  8026cb:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  8026cf:	75 f4                	jne    8026c5 <spawnl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  8026d1:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  8026d8:	83 e0 f0             	and    $0xfffffff0,%eax
  8026db:	29 c4                	sub    %eax,%esp
  8026dd:	8d 44 24 0b          	lea    0xb(%esp),%eax
  8026e1:	c1 e8 02             	shr    $0x2,%eax
  8026e4:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  8026eb:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8026ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026f0:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  8026f7:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  8026fe:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  8026ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802704:	eb 0a                	jmp    802710 <spawnl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  802706:	83 c0 01             	add    $0x1,%eax
  802709:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  80270d:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802710:	39 d0                	cmp    %edx,%eax
  802712:	75 f2                	jne    802706 <spawnl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802714:	89 74 24 04          	mov    %esi,0x4(%esp)
  802718:	8b 45 08             	mov    0x8(%ebp),%eax
  80271b:	89 04 24             	mov    %eax,(%esp)
  80271e:	e8 33 fb ff ff       	call   802256 <spawn>
}
  802723:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802726:	5b                   	pop    %ebx
  802727:	5e                   	pop    %esi
  802728:	5d                   	pop    %ebp
  802729:	c3                   	ret    

0080272a <exec>:

int
exec(const char *prog, const char **argv)
{
  80272a:	55                   	push   %ebp
  80272b:	89 e5                	mov    %esp,%ebp
  80272d:	57                   	push   %edi
  80272e:	56                   	push   %esi
  80272f:	53                   	push   %ebx
  802730:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
	int fd, i, r;
	struct Elf *elf;
	struct Proghdr *ph;
	int perm;	

	if ((r = open(prog, O_RDONLY)) < 0)
  802736:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80273d:	00 
  80273e:	8b 45 08             	mov    0x8(%ebp),%eax
  802741:	89 04 24             	mov    %eax,(%esp)
  802744:	e8 26 f9 ff ff       	call   80206f <open>
  802749:	89 c7                	mov    %eax,%edi
  80274b:	85 c0                	test   %eax,%eax
  80274d:	0f 88 14 03 00 00    	js     802a67 <exec+0x33d>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802753:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80275a:	00 
  80275b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802761:	89 44 24 04          	mov    %eax,0x4(%esp)
  802765:	89 3c 24             	mov    %edi,(%esp)
  802768:	e8 5f f4 ff ff       	call   801bcc <readn>
  80276d:	3d 00 02 00 00       	cmp    $0x200,%eax
  802772:	75 0c                	jne    802780 <exec+0x56>
	    || elf->e_magic != ELF_MAGIC) {
  802774:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80277b:	45 4c 46 
  80277e:	74 30                	je     8027b0 <exec+0x86>
		close(fd);
  802780:	89 3c 24             	mov    %edi,(%esp)
  802783:	e8 4f f2 ff ff       	call   8019d7 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802788:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  80278f:	46 
  802790:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802796:	89 44 24 04          	mov    %eax,0x4(%esp)
  80279a:	c7 04 24 30 3f 80 00 	movl   $0x803f30,(%esp)
  8027a1:	e8 fa de ff ff       	call   8006a0 <cprintf>
		return -E_NOT_EXEC;
  8027a6:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  8027ab:	e9 d8 02 00 00       	jmp    802a88 <exec+0x35e>
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8027b0:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  8027b6:	8d 9c 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%ebx
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
  8027bd:	b8 00 00 00 e0       	mov    $0xe0000000,%eax
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8027c2:	be 00 00 00 00       	mov    $0x0,%esi
  8027c7:	89 bd e4 fd ff ff    	mov    %edi,-0x21c(%ebp)
  8027cd:	89 c7                	mov    %eax,%edi
  8027cf:	eb 71                	jmp    802842 <exec+0x118>
		if (ph->p_type != ELF_PROG_LOAD)
  8027d1:	83 3b 01             	cmpl   $0x1,(%ebx)
  8027d4:	75 66                	jne    80283c <exec+0x112>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8027d6:	8b 43 18             	mov    0x18(%ebx),%eax
  8027d9:	83 e0 02             	and    $0x2,%eax
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  8027dc:	83 f8 01             	cmp    $0x1,%eax
  8027df:	19 c0                	sbb    %eax,%eax
  8027e1:	83 e0 fe             	and    $0xfffffffe,%eax
  8027e4:	83 c0 07             	add    $0x7,%eax
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(0, PGOFF(ph->p_va) + tmp, ph->p_memsz,
  8027e7:	8b 4b 14             	mov    0x14(%ebx),%ecx
  8027ea:	8b 53 08             	mov    0x8(%ebx),%edx
  8027ed:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  8027f3:	01 fa                	add    %edi,%edx
  8027f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027f9:	8b 43 04             	mov    0x4(%ebx),%eax
  8027fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802800:	8b 43 10             	mov    0x10(%ebx),%eax
  802803:	89 44 24 04          	mov    %eax,0x4(%esp)
  802807:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
  80280d:	89 04 24             	mov    %eax,(%esp)
  802810:	b8 00 00 00 00       	mov    $0x0,%eax
  802815:	e8 f6 f8 ff ff       	call   802110 <map_segment>
  80281a:	85 c0                	test   %eax,%eax
  80281c:	0f 88 25 02 00 00    	js     802a47 <exec+0x31d>
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
  802822:	8b 53 14             	mov    0x14(%ebx),%edx
  802825:	8b 43 08             	mov    0x8(%ebx),%eax
  802828:	25 ff 0f 00 00       	and    $0xfff,%eax
  80282d:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
  802834:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802839:	8d 3c 38             	lea    (%eax,%edi,1),%edi
	}

	// Set up program segments as defined in ELF header.
	uint32_t tmp = ETEMPREGION;
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80283c:	83 c6 01             	add    $0x1,%esi
  80283f:	83 c3 20             	add    $0x20,%ebx
  802842:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802849:	39 c6                	cmp    %eax,%esi
  80284b:	7c 84                	jl     8027d1 <exec+0xa7>
  80284d:	89 bd dc fd ff ff    	mov    %edi,-0x224(%ebp)
  802853:	8b bd e4 fd ff ff    	mov    -0x21c(%ebp),%edi
		if ((r = map_segment(0, PGOFF(ph->p_va) + tmp, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
	}
	close(fd);
  802859:	89 3c 24             	mov    %edi,(%esp)
  80285c:	e8 76 f1 ff ff       	call   8019d7 <close>
	fd = -1;
	cprintf("tf_esp: %x\n", tf_esp);
  802861:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802868:	00 
  802869:	c7 04 24 91 3f 80 00 	movl   $0x803f91,(%esp)
  802870:	e8 2b de ff ff       	call   8006a0 <cprintf>
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802875:	bb 00 00 00 00       	mov    $0x0,%ebx
	size_t string_size;
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
  80287a:	be 00 00 00 00       	mov    $0x0,%esi
  80287f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802882:	eb 0f                	jmp    802893 <exec+0x169>
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  802884:	89 04 24             	mov    %eax,(%esp)
  802887:	e8 04 e4 ff ff       	call   800c90 <strlen>
  80288c:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	int argc, i, r;
	char *string_store;
	uintptr_t *argv_store;

	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802890:	83 c3 01             	add    $0x1,%ebx
  802893:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  80289a:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	75 e3                	jne    802884 <exec+0x15a>
  8028a1:	89 9d d8 fd ff ff    	mov    %ebx,-0x228(%ebp)
  8028a7:	89 8d d4 fd ff ff    	mov    %ecx,-0x22c(%ebp)
		string_size += strlen(argv[argc]) + 1;

	string_store = (char*) UTEMP + PGSIZE - string_size;
  8028ad:	bf 00 10 40 00       	mov    $0x401000,%edi
  8028b2:	29 f7                	sub    %esi,%edi
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8028b4:	89 fa                	mov    %edi,%edx
  8028b6:	83 e2 fc             	and    $0xfffffffc,%edx
  8028b9:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8028c0:	29 c2                	sub    %eax,%edx
  8028c2:	89 95 e4 fd ff ff    	mov    %edx,-0x21c(%ebp)
	
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8028c8:	8d 42 f8             	lea    -0x8(%edx),%eax
  8028cb:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  8028d0:	0f 86 93 01 00 00    	jbe    802a69 <exec+0x33f>
		return -E_NO_MEM;

	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8028d6:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8028dd:	00 
  8028de:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8028e5:	00 
  8028e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028ed:	e8 f1 e7 ff ff       	call   8010e3 <sys_page_alloc>
  8028f2:	85 c0                	test   %eax,%eax
  8028f4:	0f 88 8e 01 00 00    	js     802a88 <exec+0x35e>
  8028fa:	be 00 00 00 00       	mov    $0x0,%esi
  8028ff:	89 9d e0 fd ff ff    	mov    %ebx,-0x220(%ebp)
  802905:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802908:	eb 30                	jmp    80293a <exec+0x210>
		return r;

	for (i = 0; i < argc; i++) {
		argv_store[i] = UTEMP2USTACK(string_store);
  80290a:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802910:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
  802916:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802919:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80291c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802920:	89 3c 24             	mov    %edi,(%esp)
  802923:	e8 9f e3 ff ff       	call   800cc7 <strcpy>
		string_store += strlen(argv[i]) + 1;
  802928:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  80292b:	89 04 24             	mov    %eax,(%esp)
  80292e:	e8 5d e3 ff ff       	call   800c90 <strlen>
  802933:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
		return -E_NO_MEM;

	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
		return r;

	for (i = 0; i < argc; i++) {
  802937:	83 c6 01             	add    $0x1,%esi
  80293a:	39 b5 e0 fd ff ff    	cmp    %esi,-0x220(%ebp)
  802940:	7f c8                	jg     80290a <exec+0x1e0>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802942:	8b 85 e4 fd ff ff    	mov    -0x21c(%ebp),%eax
  802948:	8b 8d d4 fd ff ff    	mov    -0x22c(%ebp),%ecx
  80294e:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802955:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  80295b:	74 24                	je     802981 <exec+0x257>
  80295d:	c7 44 24 0c a8 3f 80 	movl   $0x803fa8,0xc(%esp)
  802964:	00 
  802965:	c7 44 24 08 db 3e 80 	movl   $0x803edb,0x8(%esp)
  80296c:	00 
  80296d:	c7 44 24 04 7b 01 00 	movl   $0x17b,0x4(%esp)
  802974:	00 
  802975:	c7 04 24 24 3f 80 00 	movl   $0x803f24,(%esp)
  80297c:	e8 26 dc ff ff       	call   8005a7 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802981:	8b 8d e4 fd ff ff    	mov    -0x21c(%ebp),%ecx
  802987:	89 c8                	mov    %ecx,%eax
  802989:	2d 00 30 80 11       	sub    $0x11803000,%eax
  80298e:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802991:	8b 85 d8 fd ff ff    	mov    -0x228(%ebp),%eax
  802997:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80299a:	8d 99 f8 cf 7f ee    	lea    -0x11803008(%ecx),%ebx

	cprintf("stack: %x\n", stack);
  8029a0:	8b bd dc fd ff ff    	mov    -0x224(%ebp),%edi
  8029a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8029aa:	c7 04 24 9d 3f 80 00 	movl   $0x803f9d,(%esp)
  8029b1:	e8 ea dc ff ff       	call   8006a0 <cprintf>
	if ((r = sys_page_map(0, UTEMP, child, (void*) stack, PTE_P | PTE_U | PTE_W)) < 0)
  8029b6:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8029bd:	00 
  8029be:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029c2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8029c9:	00 
  8029ca:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8029d1:	00 
  8029d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029d9:	e8 59 e7 ff ff       	call   801137 <sys_page_map>
  8029de:	89 c7                	mov    %eax,%edi
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	0f 88 8a 00 00 00    	js     802a72 <exec+0x348>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8029e8:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8029ef:	00 
  8029f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029f7:	e8 8e e7 ff ff       	call   80118a <sys_page_unmap>
  8029fc:	89 c7                	mov    %eax,%edi
  8029fe:	85 c0                	test   %eax,%eax
  802a00:	78 70                	js     802a72 <exec+0x348>
	// cprintf("tf_eip: %x\n", tf_eip);
	if ((r = init_stack_with_addr(0, argv, &tf_esp, tmp)) < 0)
		return r;

	// Syscall to exec
	if (sys_exec(elf->e_entry, tf_esp, (void *)(elf_buf + elf->e_phoff), elf->e_phnum) < 0)
  802a02:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802a09:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a0d:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802a13:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802a1a:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a1e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a22:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802a28:	89 04 24             	mov    %eax,(%esp)
  802a2b:	e8 9c e9 ff ff       	call   8013cc <sys_exec>
  802a30:	89 c2                	mov    %eax,%edx
		goto error;
	return 0;
  802a32:	b8 00 00 00 00       	mov    $0x0,%eax
  802a37:	be 00 00 00 00       	mov    $0x0,%esi
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
		tmp += ROUNDUP(ph->p_memsz + PGOFF(ph->p_va), PGSIZE);
	}
	close(fd);
	fd = -1;
  802a3c:	bf ff ff ff ff       	mov    $0xffffffff,%edi
	// cprintf("tf_eip: %x\n", tf_eip);
	if ((r = init_stack_with_addr(0, argv, &tf_esp, tmp)) < 0)
		return r;

	// Syscall to exec
	if (sys_exec(elf->e_entry, tf_esp, (void *)(elf_buf + elf->e_phoff), elf->e_phnum) < 0)
  802a41:	85 d2                	test   %edx,%edx
  802a43:	78 0a                	js     802a4f <exec+0x325>
  802a45:	eb 41                	jmp    802a88 <exec+0x35e>
  802a47:	8b bd e4 fd ff ff    	mov    -0x21c(%ebp),%edi
  802a4d:	89 c6                	mov    %eax,%esi
		goto error;
	return 0;

error:
	sys_env_destroy(0);
  802a4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a56:	e8 f8 e5 ff ff       	call   801053 <sys_env_destroy>
	close(fd);
  802a5b:	89 3c 24             	mov    %edi,(%esp)
  802a5e:	e8 74 ef ff ff       	call   8019d7 <close>
	return r;
  802a63:	89 f0                	mov    %esi,%eax
  802a65:	eb 21                	jmp    802a88 <exec+0x35e>
  802a67:	eb 1f                	jmp    802a88 <exec+0x35e>

	string_store = (char*) UTEMP + PGSIZE - string_size;
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  802a69:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  802a6e:	66 90                	xchg   %ax,%ax
  802a70:	eb 16                	jmp    802a88 <exec+0x35e>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
		goto error;
	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802a72:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802a79:	00 
  802a7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a81:	e8 04 e7 ff ff       	call   80118a <sys_page_unmap>
  802a86:	89 f8                	mov    %edi,%eax

error:
	sys_env_destroy(0);
	close(fd);
	return r;
}
  802a88:	81 c4 3c 02 00 00    	add    $0x23c,%esp
  802a8e:	5b                   	pop    %ebx
  802a8f:	5e                   	pop    %esi
  802a90:	5f                   	pop    %edi
  802a91:	5d                   	pop    %ebp
  802a92:	c3                   	ret    

00802a93 <execl>:

int
execl(const char *prog, const char *arg0, ...)
{
  802a93:	55                   	push   %ebp
  802a94:	89 e5                	mov    %esp,%ebp
  802a96:	56                   	push   %esi
  802a97:	53                   	push   %ebx
  802a98:	83 ec 10             	sub    $0x10,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802a9b:	8d 45 10             	lea    0x10(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802a9e:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802aa3:	eb 03                	jmp    802aa8 <execl+0x15>
		argc++;
  802aa5:	83 c2 01             	add    $0x1,%edx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802aa8:	83 c0 04             	add    $0x4,%eax
  802aab:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  802aaf:	75 f4                	jne    802aa5 <execl+0x12>
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802ab1:	8d 04 95 1a 00 00 00 	lea    0x1a(,%edx,4),%eax
  802ab8:	83 e0 f0             	and    $0xfffffff0,%eax
  802abb:	29 c4                	sub    %eax,%esp
  802abd:	8d 44 24 0b          	lea    0xb(%esp),%eax
  802ac1:	c1 e8 02             	shr    $0x2,%eax
  802ac4:	8d 34 85 00 00 00 00 	lea    0x0(,%eax,4),%esi
  802acb:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802acd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ad0:	89 0c 85 00 00 00 00 	mov    %ecx,0x0(,%eax,4)
	argv[argc+1] = NULL;
  802ad7:	c7 44 96 04 00 00 00 	movl   $0x0,0x4(%esi,%edx,4)
  802ade:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802adf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae4:	eb 0a                	jmp    802af0 <execl+0x5d>
		argv[i+1] = va_arg(vl, const char *);
  802ae6:	83 c0 01             	add    $0x1,%eax
  802ae9:	8b 4c 85 0c          	mov    0xc(%ebp,%eax,4),%ecx
  802aed:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802af0:	39 d0                	cmp    %edx,%eax
  802af2:	75 f2                	jne    802ae6 <execl+0x53>
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return exec(prog, argv);
  802af4:	89 74 24 04          	mov    %esi,0x4(%esp)
  802af8:	8b 45 08             	mov    0x8(%ebp),%eax
  802afb:	89 04 24             	mov    %eax,(%esp)
  802afe:	e8 27 fc ff ff       	call   80272a <exec>
}
  802b03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802b06:	5b                   	pop    %ebx
  802b07:	5e                   	pop    %esi
  802b08:	5d                   	pop    %ebp
  802b09:	c3                   	ret    
  802b0a:	66 90                	xchg   %ax,%ax
  802b0c:	66 90                	xchg   %ax,%ax
  802b0e:	66 90                	xchg   %ax,%ax

00802b10 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802b10:	55                   	push   %ebp
  802b11:	89 e5                	mov    %esp,%ebp
  802b13:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802b16:	c7 44 24 04 ce 3f 80 	movl   $0x803fce,0x4(%esp)
  802b1d:	00 
  802b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b21:	89 04 24             	mov    %eax,(%esp)
  802b24:	e8 9e e1 ff ff       	call   800cc7 <strcpy>
	return 0;
}
  802b29:	b8 00 00 00 00       	mov    $0x0,%eax
  802b2e:	c9                   	leave  
  802b2f:	c3                   	ret    

00802b30 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802b30:	55                   	push   %ebp
  802b31:	89 e5                	mov    %esp,%ebp
  802b33:	53                   	push   %ebx
  802b34:	83 ec 14             	sub    $0x14,%esp
  802b37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  802b3a:	89 1c 24             	mov    %ebx,(%esp)
  802b3d:	e8 8d 0a 00 00       	call   8035cf <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  802b42:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  802b47:	83 f8 01             	cmp    $0x1,%eax
  802b4a:	75 0d                	jne    802b59 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  802b4c:	8b 43 0c             	mov    0xc(%ebx),%eax
  802b4f:	89 04 24             	mov    %eax,(%esp)
  802b52:	e8 29 03 00 00       	call   802e80 <nsipc_close>
  802b57:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  802b59:	89 d0                	mov    %edx,%eax
  802b5b:	83 c4 14             	add    $0x14,%esp
  802b5e:	5b                   	pop    %ebx
  802b5f:	5d                   	pop    %ebp
  802b60:	c3                   	ret    

00802b61 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802b61:	55                   	push   %ebp
  802b62:	89 e5                	mov    %esp,%ebp
  802b64:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  802b67:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802b6e:	00 
  802b6f:	8b 45 10             	mov    0x10(%ebp),%eax
  802b72:	89 44 24 08          	mov    %eax,0x8(%esp)
  802b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b79:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	8b 40 0c             	mov    0xc(%eax),%eax
  802b83:	89 04 24             	mov    %eax,(%esp)
  802b86:	e8 f0 03 00 00       	call   802f7b <nsipc_send>
}
  802b8b:	c9                   	leave  
  802b8c:	c3                   	ret    

00802b8d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802b8d:	55                   	push   %ebp
  802b8e:	89 e5                	mov    %esp,%ebp
  802b90:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802b93:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802b9a:	00 
  802b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  802b9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ba5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	8b 40 0c             	mov    0xc(%eax),%eax
  802baf:	89 04 24             	mov    %eax,(%esp)
  802bb2:	e8 44 03 00 00       	call   802efb <nsipc_recv>
}
  802bb7:	c9                   	leave  
  802bb8:	c3                   	ret    

00802bb9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802bb9:	55                   	push   %ebp
  802bba:	89 e5                	mov    %esp,%ebp
  802bbc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802bbf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802bc2:	89 54 24 04          	mov    %edx,0x4(%esp)
  802bc6:	89 04 24             	mov    %eax,(%esp)
  802bc9:	e8 d8 ec ff ff       	call   8018a6 <fd_lookup>
  802bce:	85 c0                	test   %eax,%eax
  802bd0:	78 17                	js     802be9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 0d 3c 50 80 00    	mov    0x80503c,%ecx
  802bdb:	39 08                	cmp    %ecx,(%eax)
  802bdd:	75 05                	jne    802be4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  802bdf:	8b 40 0c             	mov    0xc(%eax),%eax
  802be2:	eb 05                	jmp    802be9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  802be4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  802be9:	c9                   	leave  
  802bea:	c3                   	ret    

00802beb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  802beb:	55                   	push   %ebp
  802bec:	89 e5                	mov    %esp,%ebp
  802bee:	56                   	push   %esi
  802bef:	53                   	push   %ebx
  802bf0:	83 ec 20             	sub    $0x20,%esp
  802bf3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802bf5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802bf8:	89 04 24             	mov    %eax,(%esp)
  802bfb:	e8 57 ec ff ff       	call   801857 <fd_alloc>
  802c00:	89 c3                	mov    %eax,%ebx
  802c02:	85 c0                	test   %eax,%eax
  802c04:	78 21                	js     802c27 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  802c06:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802c0d:	00 
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c1c:	e8 c2 e4 ff ff       	call   8010e3 <sys_page_alloc>
  802c21:	89 c3                	mov    %eax,%ebx
  802c23:	85 c0                	test   %eax,%eax
  802c25:	79 0c                	jns    802c33 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802c27:	89 34 24             	mov    %esi,(%esp)
  802c2a:	e8 51 02 00 00       	call   802e80 <nsipc_close>
		return r;
  802c2f:	89 d8                	mov    %ebx,%eax
  802c31:	eb 20                	jmp    802c53 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802c33:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  802c3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c41:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802c48:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  802c4b:	89 14 24             	mov    %edx,(%esp)
  802c4e:	e8 dd eb ff ff       	call   801830 <fd2num>
}
  802c53:	83 c4 20             	add    $0x20,%esp
  802c56:	5b                   	pop    %ebx
  802c57:	5e                   	pop    %esi
  802c58:	5d                   	pop    %ebp
  802c59:	c3                   	ret    

00802c5a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802c5a:	55                   	push   %ebp
  802c5b:	89 e5                	mov    %esp,%ebp
  802c5d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c60:	8b 45 08             	mov    0x8(%ebp),%eax
  802c63:	e8 51 ff ff ff       	call   802bb9 <fd2sockid>
		return r;
  802c68:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c6a:	85 c0                	test   %eax,%eax
  802c6c:	78 23                	js     802c91 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802c6e:	8b 55 10             	mov    0x10(%ebp),%edx
  802c71:	89 54 24 08          	mov    %edx,0x8(%esp)
  802c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c78:	89 54 24 04          	mov    %edx,0x4(%esp)
  802c7c:	89 04 24             	mov    %eax,(%esp)
  802c7f:	e8 45 01 00 00       	call   802dc9 <nsipc_accept>
		return r;
  802c84:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802c86:	85 c0                	test   %eax,%eax
  802c88:	78 07                	js     802c91 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  802c8a:	e8 5c ff ff ff       	call   802beb <alloc_sockfd>
  802c8f:	89 c1                	mov    %eax,%ecx
}
  802c91:	89 c8                	mov    %ecx,%eax
  802c93:	c9                   	leave  
  802c94:	c3                   	ret    

00802c95 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802c95:	55                   	push   %ebp
  802c96:	89 e5                	mov    %esp,%ebp
  802c98:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	e8 16 ff ff ff       	call   802bb9 <fd2sockid>
  802ca3:	89 c2                	mov    %eax,%edx
  802ca5:	85 d2                	test   %edx,%edx
  802ca7:	78 16                	js     802cbf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  802cac:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cb7:	89 14 24             	mov    %edx,(%esp)
  802cba:	e8 60 01 00 00       	call   802e1f <nsipc_bind>
}
  802cbf:	c9                   	leave  
  802cc0:	c3                   	ret    

00802cc1 <shutdown>:

int
shutdown(int s, int how)
{
  802cc1:	55                   	push   %ebp
  802cc2:	89 e5                	mov    %esp,%ebp
  802cc4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cca:	e8 ea fe ff ff       	call   802bb9 <fd2sockid>
  802ccf:	89 c2                	mov    %eax,%edx
  802cd1:	85 d2                	test   %edx,%edx
  802cd3:	78 0f                	js     802ce4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  802cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cdc:	89 14 24             	mov    %edx,(%esp)
  802cdf:	e8 7a 01 00 00       	call   802e5e <nsipc_shutdown>
}
  802ce4:	c9                   	leave  
  802ce5:	c3                   	ret    

00802ce6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802ce6:	55                   	push   %ebp
  802ce7:	89 e5                	mov    %esp,%ebp
  802ce9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	e8 c5 fe ff ff       	call   802bb9 <fd2sockid>
  802cf4:	89 c2                	mov    %eax,%edx
  802cf6:	85 d2                	test   %edx,%edx
  802cf8:	78 16                	js     802d10 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  802cfa:	8b 45 10             	mov    0x10(%ebp),%eax
  802cfd:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d08:	89 14 24             	mov    %edx,(%esp)
  802d0b:	e8 8a 01 00 00       	call   802e9a <nsipc_connect>
}
  802d10:	c9                   	leave  
  802d11:	c3                   	ret    

00802d12 <listen>:

int
listen(int s, int backlog)
{
  802d12:	55                   	push   %ebp
  802d13:	89 e5                	mov    %esp,%ebp
  802d15:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	e8 99 fe ff ff       	call   802bb9 <fd2sockid>
  802d20:	89 c2                	mov    %eax,%edx
  802d22:	85 d2                	test   %edx,%edx
  802d24:	78 0f                	js     802d35 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d29:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d2d:	89 14 24             	mov    %edx,(%esp)
  802d30:	e8 a4 01 00 00       	call   802ed9 <nsipc_listen>
}
  802d35:	c9                   	leave  
  802d36:	c3                   	ret    

00802d37 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802d37:	55                   	push   %ebp
  802d38:	89 e5                	mov    %esp,%ebp
  802d3a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802d3d:	8b 45 10             	mov    0x10(%ebp),%eax
  802d40:	89 44 24 08          	mov    %eax,0x8(%esp)
  802d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d47:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	89 04 24             	mov    %eax,(%esp)
  802d51:	e8 98 02 00 00       	call   802fee <nsipc_socket>
  802d56:	89 c2                	mov    %eax,%edx
  802d58:	85 d2                	test   %edx,%edx
  802d5a:	78 05                	js     802d61 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  802d5c:	e8 8a fe ff ff       	call   802beb <alloc_sockfd>
}
  802d61:	c9                   	leave  
  802d62:	c3                   	ret    

00802d63 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802d63:	55                   	push   %ebp
  802d64:	89 e5                	mov    %esp,%ebp
  802d66:	53                   	push   %ebx
  802d67:	83 ec 14             	sub    $0x14,%esp
  802d6a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  802d6c:	83 3d 04 60 80 00 00 	cmpl   $0x0,0x806004
  802d73:	75 11                	jne    802d86 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802d75:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  802d7c:	e8 14 08 00 00       	call   803595 <ipc_find_env>
  802d81:	a3 04 60 80 00       	mov    %eax,0x806004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802d86:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802d8d:	00 
  802d8e:	c7 44 24 08 00 90 80 	movl   $0x809000,0x8(%esp)
  802d95:	00 
  802d96:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802d9a:	a1 04 60 80 00       	mov    0x806004,%eax
  802d9f:	89 04 24             	mov    %eax,(%esp)
  802da2:	e8 61 07 00 00       	call   803508 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802da7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802dae:	00 
  802daf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802db6:	00 
  802db7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dbe:	e8 dd 06 00 00       	call   8034a0 <ipc_recv>
}
  802dc3:	83 c4 14             	add    $0x14,%esp
  802dc6:	5b                   	pop    %ebx
  802dc7:	5d                   	pop    %ebp
  802dc8:	c3                   	ret    

00802dc9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802dc9:	55                   	push   %ebp
  802dca:	89 e5                	mov    %esp,%ebp
  802dcc:	56                   	push   %esi
  802dcd:	53                   	push   %ebx
  802dce:	83 ec 10             	sub    $0x10,%esp
  802dd1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.accept.req_addrlen = *addrlen;
  802ddc:	8b 06                	mov    (%esi),%eax
  802dde:	a3 04 90 80 00       	mov    %eax,0x809004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802de3:	b8 01 00 00 00       	mov    $0x1,%eax
  802de8:	e8 76 ff ff ff       	call   802d63 <nsipc>
  802ded:	89 c3                	mov    %eax,%ebx
  802def:	85 c0                	test   %eax,%eax
  802df1:	78 23                	js     802e16 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802df3:	a1 10 90 80 00       	mov    0x809010,%eax
  802df8:	89 44 24 08          	mov    %eax,0x8(%esp)
  802dfc:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  802e03:	00 
  802e04:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e07:	89 04 24             	mov    %eax,(%esp)
  802e0a:	e8 55 e0 ff ff       	call   800e64 <memmove>
		*addrlen = ret->ret_addrlen;
  802e0f:	a1 10 90 80 00       	mov    0x809010,%eax
  802e14:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802e16:	89 d8                	mov    %ebx,%eax
  802e18:	83 c4 10             	add    $0x10,%esp
  802e1b:	5b                   	pop    %ebx
  802e1c:	5e                   	pop    %esi
  802e1d:	5d                   	pop    %ebp
  802e1e:	c3                   	ret    

00802e1f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802e1f:	55                   	push   %ebp
  802e20:	89 e5                	mov    %esp,%ebp
  802e22:	53                   	push   %ebx
  802e23:	83 ec 14             	sub    $0x14,%esp
  802e26:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802e31:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e35:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e38:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e3c:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  802e43:	e8 1c e0 ff ff       	call   800e64 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802e48:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_BIND);
  802e4e:	b8 02 00 00 00       	mov    $0x2,%eax
  802e53:	e8 0b ff ff ff       	call   802d63 <nsipc>
}
  802e58:	83 c4 14             	add    $0x14,%esp
  802e5b:	5b                   	pop    %ebx
  802e5c:	5d                   	pop    %ebp
  802e5d:	c3                   	ret    

00802e5e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  802e5e:	55                   	push   %ebp
  802e5f:	89 e5                	mov    %esp,%ebp
  802e61:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.shutdown.req_how = how;
  802e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6f:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_SHUTDOWN);
  802e74:	b8 03 00 00 00       	mov    $0x3,%eax
  802e79:	e8 e5 fe ff ff       	call   802d63 <nsipc>
}
  802e7e:	c9                   	leave  
  802e7f:	c3                   	ret    

00802e80 <nsipc_close>:

int
nsipc_close(int s)
{
  802e80:	55                   	push   %ebp
  802e81:	89 e5                	mov    %esp,%ebp
  802e83:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	a3 00 90 80 00       	mov    %eax,0x809000
	return nsipc(NSREQ_CLOSE);
  802e8e:	b8 04 00 00 00       	mov    $0x4,%eax
  802e93:	e8 cb fe ff ff       	call   802d63 <nsipc>
}
  802e98:	c9                   	leave  
  802e99:	c3                   	ret    

00802e9a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802e9a:	55                   	push   %ebp
  802e9b:	89 e5                	mov    %esp,%ebp
  802e9d:	53                   	push   %ebx
  802e9e:	83 ec 14             	sub    $0x14,%esp
  802ea1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	a3 00 90 80 00       	mov    %eax,0x809000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802eac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  802eb7:	c7 04 24 04 90 80 00 	movl   $0x809004,(%esp)
  802ebe:	e8 a1 df ff ff       	call   800e64 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802ec3:	89 1d 14 90 80 00    	mov    %ebx,0x809014
	return nsipc(NSREQ_CONNECT);
  802ec9:	b8 05 00 00 00       	mov    $0x5,%eax
  802ece:	e8 90 fe ff ff       	call   802d63 <nsipc>
}
  802ed3:	83 c4 14             	add    $0x14,%esp
  802ed6:	5b                   	pop    %ebx
  802ed7:	5d                   	pop    %ebp
  802ed8:	c3                   	ret    

00802ed9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802ed9:	55                   	push   %ebp
  802eda:	89 e5                	mov    %esp,%ebp
  802edc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.listen.req_backlog = backlog;
  802ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eea:	a3 04 90 80 00       	mov    %eax,0x809004
	return nsipc(NSREQ_LISTEN);
  802eef:	b8 06 00 00 00       	mov    $0x6,%eax
  802ef4:	e8 6a fe ff ff       	call   802d63 <nsipc>
}
  802ef9:	c9                   	leave  
  802efa:	c3                   	ret    

00802efb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802efb:	55                   	push   %ebp
  802efc:	89 e5                	mov    %esp,%ebp
  802efe:	56                   	push   %esi
  802eff:	53                   	push   %ebx
  802f00:	83 ec 10             	sub    $0x10,%esp
  802f03:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.recv.req_len = len;
  802f0e:	89 35 04 90 80 00    	mov    %esi,0x809004
	nsipcbuf.recv.req_flags = flags;
  802f14:	8b 45 14             	mov    0x14(%ebp),%eax
  802f17:	a3 08 90 80 00       	mov    %eax,0x809008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802f1c:	b8 07 00 00 00       	mov    $0x7,%eax
  802f21:	e8 3d fe ff ff       	call   802d63 <nsipc>
  802f26:	89 c3                	mov    %eax,%ebx
  802f28:	85 c0                	test   %eax,%eax
  802f2a:	78 46                	js     802f72 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802f2c:	39 f0                	cmp    %esi,%eax
  802f2e:	7f 07                	jg     802f37 <nsipc_recv+0x3c>
  802f30:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802f35:	7e 24                	jle    802f5b <nsipc_recv+0x60>
  802f37:	c7 44 24 0c da 3f 80 	movl   $0x803fda,0xc(%esp)
  802f3e:	00 
  802f3f:	c7 44 24 08 db 3e 80 	movl   $0x803edb,0x8(%esp)
  802f46:	00 
  802f47:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  802f4e:	00 
  802f4f:	c7 04 24 ef 3f 80 00 	movl   $0x803fef,(%esp)
  802f56:	e8 4c d6 ff ff       	call   8005a7 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802f5b:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f5f:	c7 44 24 04 00 90 80 	movl   $0x809000,0x4(%esp)
  802f66:	00 
  802f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f6a:	89 04 24             	mov    %eax,(%esp)
  802f6d:	e8 f2 de ff ff       	call   800e64 <memmove>
	}

	return r;
}
  802f72:	89 d8                	mov    %ebx,%eax
  802f74:	83 c4 10             	add    $0x10,%esp
  802f77:	5b                   	pop    %ebx
  802f78:	5e                   	pop    %esi
  802f79:	5d                   	pop    %ebp
  802f7a:	c3                   	ret    

00802f7b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802f7b:	55                   	push   %ebp
  802f7c:	89 e5                	mov    %esp,%ebp
  802f7e:	53                   	push   %ebx
  802f7f:	83 ec 14             	sub    $0x14,%esp
  802f82:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	a3 00 90 80 00       	mov    %eax,0x809000
	assert(size < 1600);
  802f8d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802f93:	7e 24                	jle    802fb9 <nsipc_send+0x3e>
  802f95:	c7 44 24 0c fb 3f 80 	movl   $0x803ffb,0xc(%esp)
  802f9c:	00 
  802f9d:	c7 44 24 08 db 3e 80 	movl   $0x803edb,0x8(%esp)
  802fa4:	00 
  802fa5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  802fac:	00 
  802fad:	c7 04 24 ef 3f 80 00 	movl   $0x803fef,(%esp)
  802fb4:	e8 ee d5 ff ff       	call   8005a7 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802fb9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fc4:	c7 04 24 0c 90 80 00 	movl   $0x80900c,(%esp)
  802fcb:	e8 94 de ff ff       	call   800e64 <memmove>
	nsipcbuf.send.req_size = size;
  802fd0:	89 1d 04 90 80 00    	mov    %ebx,0x809004
	nsipcbuf.send.req_flags = flags;
  802fd6:	8b 45 14             	mov    0x14(%ebp),%eax
  802fd9:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SEND);
  802fde:	b8 08 00 00 00       	mov    $0x8,%eax
  802fe3:	e8 7b fd ff ff       	call   802d63 <nsipc>
}
  802fe8:	83 c4 14             	add    $0x14,%esp
  802feb:	5b                   	pop    %ebx
  802fec:	5d                   	pop    %ebp
  802fed:	c3                   	ret    

00802fee <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  802fee:	55                   	push   %ebp
  802fef:	89 e5                	mov    %esp,%ebp
  802ff1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff7:	a3 00 90 80 00       	mov    %eax,0x809000
	nsipcbuf.socket.req_type = type;
  802ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fff:	a3 04 90 80 00       	mov    %eax,0x809004
	nsipcbuf.socket.req_protocol = protocol;
  803004:	8b 45 10             	mov    0x10(%ebp),%eax
  803007:	a3 08 90 80 00       	mov    %eax,0x809008
	return nsipc(NSREQ_SOCKET);
  80300c:	b8 09 00 00 00       	mov    $0x9,%eax
  803011:	e8 4d fd ff ff       	call   802d63 <nsipc>
}
  803016:	c9                   	leave  
  803017:	c3                   	ret    

00803018 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803018:	55                   	push   %ebp
  803019:	89 e5                	mov    %esp,%ebp
  80301b:	56                   	push   %esi
  80301c:	53                   	push   %ebx
  80301d:	83 ec 10             	sub    $0x10,%esp
  803020:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	89 04 24             	mov    %eax,(%esp)
  803029:	e8 12 e8 ff ff       	call   801840 <fd2data>
  80302e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  803030:	c7 44 24 04 07 40 80 	movl   $0x804007,0x4(%esp)
  803037:	00 
  803038:	89 1c 24             	mov    %ebx,(%esp)
  80303b:	e8 87 dc ff ff       	call   800cc7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803040:	8b 46 04             	mov    0x4(%esi),%eax
  803043:	2b 06                	sub    (%esi),%eax
  803045:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80304b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803052:	00 00 00 
	stat->st_dev = &devpipe;
  803055:	c7 83 88 00 00 00 58 	movl   $0x805058,0x88(%ebx)
  80305c:	50 80 00 
	return 0;
}
  80305f:	b8 00 00 00 00       	mov    $0x0,%eax
  803064:	83 c4 10             	add    $0x10,%esp
  803067:	5b                   	pop    %ebx
  803068:	5e                   	pop    %esi
  803069:	5d                   	pop    %ebp
  80306a:	c3                   	ret    

0080306b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80306b:	55                   	push   %ebp
  80306c:	89 e5                	mov    %esp,%ebp
  80306e:	53                   	push   %ebx
  80306f:	83 ec 14             	sub    $0x14,%esp
  803072:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803075:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803079:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803080:	e8 05 e1 ff ff       	call   80118a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803085:	89 1c 24             	mov    %ebx,(%esp)
  803088:	e8 b3 e7 ff ff       	call   801840 <fd2data>
  80308d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803091:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803098:	e8 ed e0 ff ff       	call   80118a <sys_page_unmap>
}
  80309d:	83 c4 14             	add    $0x14,%esp
  8030a0:	5b                   	pop    %ebx
  8030a1:	5d                   	pop    %ebp
  8030a2:	c3                   	ret    

008030a3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8030a3:	55                   	push   %ebp
  8030a4:	89 e5                	mov    %esp,%ebp
  8030a6:	57                   	push   %edi
  8030a7:	56                   	push   %esi
  8030a8:	53                   	push   %ebx
  8030a9:	83 ec 2c             	sub    $0x2c,%esp
  8030ac:	89 c6                	mov    %eax,%esi
  8030ae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8030b1:	a1 08 60 80 00       	mov    0x806008,%eax
  8030b6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8030b9:	89 34 24             	mov    %esi,(%esp)
  8030bc:	e8 0e 05 00 00       	call   8035cf <pageref>
  8030c1:	89 c7                	mov    %eax,%edi
  8030c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030c6:	89 04 24             	mov    %eax,(%esp)
  8030c9:	e8 01 05 00 00       	call   8035cf <pageref>
  8030ce:	39 c7                	cmp    %eax,%edi
  8030d0:	0f 94 c2             	sete   %dl
  8030d3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8030d6:	8b 0d 08 60 80 00    	mov    0x806008,%ecx
  8030dc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8030df:	39 fb                	cmp    %edi,%ebx
  8030e1:	74 21                	je     803104 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8030e3:	84 d2                	test   %dl,%dl
  8030e5:	74 ca                	je     8030b1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8030e7:	8b 51 58             	mov    0x58(%ecx),%edx
  8030ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030ee:	89 54 24 08          	mov    %edx,0x8(%esp)
  8030f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8030f6:	c7 04 24 0e 40 80 00 	movl   $0x80400e,(%esp)
  8030fd:	e8 9e d5 ff ff       	call   8006a0 <cprintf>
  803102:	eb ad                	jmp    8030b1 <_pipeisclosed+0xe>
	}
}
  803104:	83 c4 2c             	add    $0x2c,%esp
  803107:	5b                   	pop    %ebx
  803108:	5e                   	pop    %esi
  803109:	5f                   	pop    %edi
  80310a:	5d                   	pop    %ebp
  80310b:	c3                   	ret    

0080310c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80310c:	55                   	push   %ebp
  80310d:	89 e5                	mov    %esp,%ebp
  80310f:	57                   	push   %edi
  803110:	56                   	push   %esi
  803111:	53                   	push   %ebx
  803112:	83 ec 1c             	sub    $0x1c,%esp
  803115:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803118:	89 34 24             	mov    %esi,(%esp)
  80311b:	e8 20 e7 ff ff       	call   801840 <fd2data>
  803120:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803122:	bf 00 00 00 00       	mov    $0x0,%edi
  803127:	eb 45                	jmp    80316e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803129:	89 da                	mov    %ebx,%edx
  80312b:	89 f0                	mov    %esi,%eax
  80312d:	e8 71 ff ff ff       	call   8030a3 <_pipeisclosed>
  803132:	85 c0                	test   %eax,%eax
  803134:	75 41                	jne    803177 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803136:	e8 89 df ff ff       	call   8010c4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80313b:	8b 43 04             	mov    0x4(%ebx),%eax
  80313e:	8b 0b                	mov    (%ebx),%ecx
  803140:	8d 51 20             	lea    0x20(%ecx),%edx
  803143:	39 d0                	cmp    %edx,%eax
  803145:	73 e2                	jae    803129 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803147:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80314a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80314e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  803151:	99                   	cltd   
  803152:	c1 ea 1b             	shr    $0x1b,%edx
  803155:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  803158:	83 e1 1f             	and    $0x1f,%ecx
  80315b:	29 d1                	sub    %edx,%ecx
  80315d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  803161:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  803165:	83 c0 01             	add    $0x1,%eax
  803168:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80316b:	83 c7 01             	add    $0x1,%edi
  80316e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  803171:	75 c8                	jne    80313b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803173:	89 f8                	mov    %edi,%eax
  803175:	eb 05                	jmp    80317c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803177:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80317c:	83 c4 1c             	add    $0x1c,%esp
  80317f:	5b                   	pop    %ebx
  803180:	5e                   	pop    %esi
  803181:	5f                   	pop    %edi
  803182:	5d                   	pop    %ebp
  803183:	c3                   	ret    

00803184 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803184:	55                   	push   %ebp
  803185:	89 e5                	mov    %esp,%ebp
  803187:	57                   	push   %edi
  803188:	56                   	push   %esi
  803189:	53                   	push   %ebx
  80318a:	83 ec 1c             	sub    $0x1c,%esp
  80318d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803190:	89 3c 24             	mov    %edi,(%esp)
  803193:	e8 a8 e6 ff ff       	call   801840 <fd2data>
  803198:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80319a:	be 00 00 00 00       	mov    $0x0,%esi
  80319f:	eb 3d                	jmp    8031de <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8031a1:	85 f6                	test   %esi,%esi
  8031a3:	74 04                	je     8031a9 <devpipe_read+0x25>
				return i;
  8031a5:	89 f0                	mov    %esi,%eax
  8031a7:	eb 43                	jmp    8031ec <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8031a9:	89 da                	mov    %ebx,%edx
  8031ab:	89 f8                	mov    %edi,%eax
  8031ad:	e8 f1 fe ff ff       	call   8030a3 <_pipeisclosed>
  8031b2:	85 c0                	test   %eax,%eax
  8031b4:	75 31                	jne    8031e7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8031b6:	e8 09 df ff ff       	call   8010c4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8031bb:	8b 03                	mov    (%ebx),%eax
  8031bd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8031c0:	74 df                	je     8031a1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8031c2:	99                   	cltd   
  8031c3:	c1 ea 1b             	shr    $0x1b,%edx
  8031c6:	01 d0                	add    %edx,%eax
  8031c8:	83 e0 1f             	and    $0x1f,%eax
  8031cb:	29 d0                	sub    %edx,%eax
  8031cd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8031d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8031d5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8031d8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8031db:	83 c6 01             	add    $0x1,%esi
  8031de:	3b 75 10             	cmp    0x10(%ebp),%esi
  8031e1:	75 d8                	jne    8031bb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8031e3:	89 f0                	mov    %esi,%eax
  8031e5:	eb 05                	jmp    8031ec <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8031e7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8031ec:	83 c4 1c             	add    $0x1c,%esp
  8031ef:	5b                   	pop    %ebx
  8031f0:	5e                   	pop    %esi
  8031f1:	5f                   	pop    %edi
  8031f2:	5d                   	pop    %ebp
  8031f3:	c3                   	ret    

008031f4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8031f4:	55                   	push   %ebp
  8031f5:	89 e5                	mov    %esp,%ebp
  8031f7:	56                   	push   %esi
  8031f8:	53                   	push   %ebx
  8031f9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8031fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8031ff:	89 04 24             	mov    %eax,(%esp)
  803202:	e8 50 e6 ff ff       	call   801857 <fd_alloc>
  803207:	89 c2                	mov    %eax,%edx
  803209:	85 d2                	test   %edx,%edx
  80320b:	0f 88 4d 01 00 00    	js     80335e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803211:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803218:	00 
  803219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803220:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803227:	e8 b7 de ff ff       	call   8010e3 <sys_page_alloc>
  80322c:	89 c2                	mov    %eax,%edx
  80322e:	85 d2                	test   %edx,%edx
  803230:	0f 88 28 01 00 00    	js     80335e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803236:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803239:	89 04 24             	mov    %eax,(%esp)
  80323c:	e8 16 e6 ff ff       	call   801857 <fd_alloc>
  803241:	89 c3                	mov    %eax,%ebx
  803243:	85 c0                	test   %eax,%eax
  803245:	0f 88 fe 00 00 00    	js     803349 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80324b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803252:	00 
  803253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803256:	89 44 24 04          	mov    %eax,0x4(%esp)
  80325a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803261:	e8 7d de ff ff       	call   8010e3 <sys_page_alloc>
  803266:	89 c3                	mov    %eax,%ebx
  803268:	85 c0                	test   %eax,%eax
  80326a:	0f 88 d9 00 00 00    	js     803349 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803273:	89 04 24             	mov    %eax,(%esp)
  803276:	e8 c5 e5 ff ff       	call   801840 <fd2data>
  80327b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80327d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803284:	00 
  803285:	89 44 24 04          	mov    %eax,0x4(%esp)
  803289:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803290:	e8 4e de ff ff       	call   8010e3 <sys_page_alloc>
  803295:	89 c3                	mov    %eax,%ebx
  803297:	85 c0                	test   %eax,%eax
  803299:	0f 88 97 00 00 00    	js     803336 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80329f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032a2:	89 04 24             	mov    %eax,(%esp)
  8032a5:	e8 96 e5 ff ff       	call   801840 <fd2data>
  8032aa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8032b1:	00 
  8032b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8032bd:	00 
  8032be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8032c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032c9:	e8 69 de ff ff       	call   801137 <sys_page_map>
  8032ce:	89 c3                	mov    %eax,%ebx
  8032d0:	85 c0                	test   %eax,%eax
  8032d2:	78 52                	js     803326 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8032d4:	8b 15 58 50 80 00    	mov    0x805058,%edx
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8032df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8032e9:	8b 15 58 50 80 00    	mov    0x805058,%edx
  8032ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8032f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8032fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803301:	89 04 24             	mov    %eax,(%esp)
  803304:	e8 27 e5 ff ff       	call   801830 <fd2num>
  803309:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80330c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80330e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803311:	89 04 24             	mov    %eax,(%esp)
  803314:	e8 17 e5 ff ff       	call   801830 <fd2num>
  803319:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80331c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80331f:	b8 00 00 00 00       	mov    $0x0,%eax
  803324:	eb 38                	jmp    80335e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  803326:	89 74 24 04          	mov    %esi,0x4(%esp)
  80332a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803331:	e8 54 de ff ff       	call   80118a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  803336:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803339:	89 44 24 04          	mov    %eax,0x4(%esp)
  80333d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803344:	e8 41 de ff ff       	call   80118a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  803349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803350:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803357:	e8 2e de ff ff       	call   80118a <sys_page_unmap>
  80335c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80335e:	83 c4 30             	add    $0x30,%esp
  803361:	5b                   	pop    %ebx
  803362:	5e                   	pop    %esi
  803363:	5d                   	pop    %ebp
  803364:	c3                   	ret    

00803365 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  803365:	55                   	push   %ebp
  803366:	89 e5                	mov    %esp,%ebp
  803368:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80336b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80336e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	89 04 24             	mov    %eax,(%esp)
  803378:	e8 29 e5 ff ff       	call   8018a6 <fd_lookup>
  80337d:	89 c2                	mov    %eax,%edx
  80337f:	85 d2                	test   %edx,%edx
  803381:	78 15                	js     803398 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803386:	89 04 24             	mov    %eax,(%esp)
  803389:	e8 b2 e4 ff ff       	call   801840 <fd2data>
	return _pipeisclosed(fd, p);
  80338e:	89 c2                	mov    %eax,%edx
  803390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803393:	e8 0b fd ff ff       	call   8030a3 <_pipeisclosed>
}
  803398:	c9                   	leave  
  803399:	c3                   	ret    

0080339a <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80339a:	55                   	push   %ebp
  80339b:	89 e5                	mov    %esp,%ebp
  80339d:	56                   	push   %esi
  80339e:	53                   	push   %ebx
  80339f:	83 ec 10             	sub    $0x10,%esp
  8033a2:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8033a5:	85 f6                	test   %esi,%esi
  8033a7:	75 24                	jne    8033cd <wait+0x33>
  8033a9:	c7 44 24 0c 26 40 80 	movl   $0x804026,0xc(%esp)
  8033b0:	00 
  8033b1:	c7 44 24 08 db 3e 80 	movl   $0x803edb,0x8(%esp)
  8033b8:	00 
  8033b9:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8033c0:	00 
  8033c1:	c7 04 24 31 40 80 00 	movl   $0x804031,(%esp)
  8033c8:	e8 da d1 ff ff       	call   8005a7 <_panic>
	e = &envs[ENVX(envid)];
  8033cd:	89 f3                	mov    %esi,%ebx
  8033cf:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8033d5:	c1 e3 07             	shl    $0x7,%ebx
  8033d8:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8033de:	eb 05                	jmp    8033e5 <wait+0x4b>
		sys_yield();
  8033e0:	e8 df dc ff ff       	call   8010c4 <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8033e5:	8b 43 48             	mov    0x48(%ebx),%eax
  8033e8:	39 f0                	cmp    %esi,%eax
  8033ea:	75 07                	jne    8033f3 <wait+0x59>
  8033ec:	8b 43 54             	mov    0x54(%ebx),%eax
  8033ef:	85 c0                	test   %eax,%eax
  8033f1:	75 ed                	jne    8033e0 <wait+0x46>
		sys_yield();
}
  8033f3:	83 c4 10             	add    $0x10,%esp
  8033f6:	5b                   	pop    %ebx
  8033f7:	5e                   	pop    %esi
  8033f8:	5d                   	pop    %ebp
  8033f9:	c3                   	ret    

008033fa <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8033fa:	55                   	push   %ebp
  8033fb:	89 e5                	mov    %esp,%ebp
  8033fd:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  803400:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  803407:	75 68                	jne    803471 <set_pgfault_handler+0x77>
		// First time through!
		// LAB 4: Your code here.
		int ret;
		if ((ret = sys_page_alloc(thisenv->env_id,
  803409:	a1 08 60 80 00       	mov    0x806008,%eax
  80340e:	8b 40 48             	mov    0x48(%eax),%eax
  803411:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803418:	00 
  803419:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  803420:	ee 
  803421:	89 04 24             	mov    %eax,(%esp)
  803424:	e8 ba dc ff ff       	call   8010e3 <sys_page_alloc>
  803429:	85 c0                	test   %eax,%eax
  80342b:	74 2c                	je     803459 <set_pgfault_handler+0x5f>
				(void *) (UXSTACKTOP - PGSIZE),
				PTE_W | PTE_U | PTE_P)) != 0) {
			cprintf("set_pg_fault_handler: can't allocate new page, %e\n", ret);
  80342d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803431:	c7 04 24 3c 40 80 00 	movl   $0x80403c,(%esp)
  803438:	e8 63 d2 ff ff       	call   8006a0 <cprintf>
			panic("set_pg_fault_handler");
  80343d:	c7 44 24 08 70 40 80 	movl   $0x804070,0x8(%esp)
  803444:	00 
  803445:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  80344c:	00 
  80344d:	c7 04 24 85 40 80 00 	movl   $0x804085,(%esp)
  803454:	e8 4e d1 ff ff       	call   8005a7 <_panic>
		}
		sys_env_set_pgfault_upcall(thisenv->env_id, _pgfault_upcall);
  803459:	a1 08 60 80 00       	mov    0x806008,%eax
  80345e:	8b 40 48             	mov    0x48(%eax),%eax
  803461:	c7 44 24 04 7b 34 80 	movl   $0x80347b,0x4(%esp)
  803468:	00 
  803469:	89 04 24             	mov    %eax,(%esp)
  80346c:	e8 12 de ff ff       	call   801283 <sys_env_set_pgfault_upcall>
		//panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  803471:	8b 45 08             	mov    0x8(%ebp),%eax
  803474:	a3 00 a0 80 00       	mov    %eax,0x80a000
}
  803479:	c9                   	leave  
  80347a:	c3                   	ret    

0080347b <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80347b:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80347c:	a1 00 a0 80 00       	mov    0x80a000,%eax
	call *%eax
  803481:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803483:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %eax
  803486:	8b 44 24 28          	mov    0x28(%esp),%eax
	movl %esp, %ebp
  80348a:	89 e5                	mov    %esp,%ebp
	movl 0x30(%esp), %esp
  80348c:	8b 64 24 30          	mov    0x30(%esp),%esp
	pushl %eax
  803490:	50                   	push   %eax
	movl %esp, 0x30(%ebp)
  803491:	89 65 30             	mov    %esp,0x30(%ebp)
	movl %ebp, %esp
  803494:	89 ec                	mov    %ebp,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popl %eax
  803496:	58                   	pop    %eax
	popl %eax
  803497:	58                   	pop    %eax
	popal
  803498:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  803499:	83 c4 04             	add    $0x4,%esp
	popfl
  80349c:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80349d:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret
  80349e:	c3                   	ret    
  80349f:	90                   	nop

008034a0 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8034a0:	55                   	push   %ebp
  8034a1:	89 e5                	mov    %esp,%ebp
  8034a3:	56                   	push   %esi
  8034a4:	53                   	push   %ebx
  8034a5:	83 ec 10             	sub    $0x10,%esp
  8034a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8034ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8034b1:	85 c0                	test   %eax,%eax
		pg = (void *) KERNBASE; // KERNBASE should be rejected by sys_ipc_recv()
  8034b3:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
  8034b8:	0f 44 c2             	cmove  %edx,%eax

	if ((r = sys_ipc_recv(pg)) != 0) {
  8034bb:	89 04 24             	mov    %eax,(%esp)
  8034be:	e8 36 de ff ff       	call   8012f9 <sys_ipc_recv>
  8034c3:	85 c0                	test   %eax,%eax
  8034c5:	74 16                	je     8034dd <ipc_recv+0x3d>
		if (from_env_store != NULL)
  8034c7:	85 f6                	test   %esi,%esi
  8034c9:	74 06                	je     8034d1 <ipc_recv+0x31>
			*from_env_store = 0;
  8034cb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store != NULL)
  8034d1:	85 db                	test   %ebx,%ebx
  8034d3:	74 2c                	je     803501 <ipc_recv+0x61>
			*perm_store = 0;
  8034d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8034db:	eb 24                	jmp    803501 <ipc_recv+0x61>
		return r;
	}

	if (from_env_store != NULL)
  8034dd:	85 f6                	test   %esi,%esi
  8034df:	74 0a                	je     8034eb <ipc_recv+0x4b>
		*from_env_store = thisenv->env_ipc_from;
  8034e1:	a1 08 60 80 00       	mov    0x806008,%eax
  8034e6:	8b 40 74             	mov    0x74(%eax),%eax
  8034e9:	89 06                	mov    %eax,(%esi)
	if (perm_store != NULL)
  8034eb:	85 db                	test   %ebx,%ebx
  8034ed:	74 0a                	je     8034f9 <ipc_recv+0x59>
		*perm_store = thisenv->env_ipc_perm;
  8034ef:	a1 08 60 80 00       	mov    0x806008,%eax
  8034f4:	8b 40 78             	mov    0x78(%eax),%eax
  8034f7:	89 03                	mov    %eax,(%ebx)

	return thisenv->env_ipc_value;
  8034f9:	a1 08 60 80 00       	mov    0x806008,%eax
  8034fe:	8b 40 70             	mov    0x70(%eax),%eax
}
  803501:	83 c4 10             	add    $0x10,%esp
  803504:	5b                   	pop    %ebx
  803505:	5e                   	pop    %esi
  803506:	5d                   	pop    %ebp
  803507:	c3                   	ret    

00803508 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803508:	55                   	push   %ebp
  803509:	89 e5                	mov    %esp,%ebp
  80350b:	57                   	push   %edi
  80350c:	56                   	push   %esi
  80350d:	53                   	push   %ebx
  80350e:	83 ec 1c             	sub    $0x1c,%esp
  803511:	8b 75 0c             	mov    0xc(%ebp),%esi
  803514:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803517:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL)
		pg = (void *) KERNBASE;
  80351a:	85 db                	test   %ebx,%ebx
  80351c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  803521:	0f 44 d8             	cmove  %eax,%ebx

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
  803524:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803528:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80352c:	89 74 24 04          	mov    %esi,0x4(%esp)
  803530:	8b 45 08             	mov    0x8(%ebp),%eax
  803533:	89 04 24             	mov    %eax,(%esp)
  803536:	e8 9b dd ff ff       	call   8012d6 <sys_ipc_try_send>
	if (r == 0) return;
  80353b:	85 c0                	test   %eax,%eax
  80353d:	75 22                	jne    803561 <ipc_send+0x59>
  80353f:	eb 4c                	jmp    80358d <ipc_send+0x85>
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
		if (r == 0)
  803541:	84 d2                	test   %dl,%dl
  803543:	75 48                	jne    80358d <ipc_send+0x85>
			return;

		sys_yield(); // release CPU before attempting to send again
  803545:	e8 7a db ff ff       	call   8010c4 <sys_yield>

		r = sys_ipc_try_send(to_env, val, pg, perm);
  80354a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80354e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803552:	89 74 24 04          	mov    %esi,0x4(%esp)
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	89 04 24             	mov    %eax,(%esp)
  80355c:	e8 75 dd ff ff       	call   8012d6 <sys_ipc_try_send>
		pg = (void *) KERNBASE;

	int r = sys_ipc_try_send(to_env, val, pg, perm); // non-blocking call
	if (r == 0) return;
		
	while ((r == -E_IPC_NOT_RECV) || (r == 0)) {
  803561:	85 c0                	test   %eax,%eax
  803563:	0f 94 c2             	sete   %dl
  803566:	74 d9                	je     803541 <ipc_send+0x39>
  803568:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80356b:	74 d4                	je     803541 <ipc_send+0x39>

		sys_yield(); // release CPU before attempting to send again

		r = sys_ipc_try_send(to_env, val, pg, perm);
	}
	panic("ipc_send: %e\n", r);
  80356d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803571:	c7 44 24 08 93 40 80 	movl   $0x804093,0x8(%esp)
  803578:	00 
  803579:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  803580:	00 
  803581:	c7 04 24 a1 40 80 00 	movl   $0x8040a1,(%esp)
  803588:	e8 1a d0 ff ff       	call   8005a7 <_panic>
}
  80358d:	83 c4 1c             	add    $0x1c,%esp
  803590:	5b                   	pop    %ebx
  803591:	5e                   	pop    %esi
  803592:	5f                   	pop    %edi
  803593:	5d                   	pop    %ebp
  803594:	c3                   	ret    

00803595 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803595:	55                   	push   %ebp
  803596:	89 e5                	mov    %esp,%ebp
  803598:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80359b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8035a0:	89 c2                	mov    %eax,%edx
  8035a2:	c1 e2 07             	shl    $0x7,%edx
  8035a5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8035ab:	8b 52 50             	mov    0x50(%edx),%edx
  8035ae:	39 ca                	cmp    %ecx,%edx
  8035b0:	75 0d                	jne    8035bf <ipc_find_env+0x2a>
			return envs[i].env_id;
  8035b2:	c1 e0 07             	shl    $0x7,%eax
  8035b5:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8035ba:	8b 40 40             	mov    0x40(%eax),%eax
  8035bd:	eb 0e                	jmp    8035cd <ipc_find_env+0x38>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8035bf:	83 c0 01             	add    $0x1,%eax
  8035c2:	3d 00 04 00 00       	cmp    $0x400,%eax
  8035c7:	75 d7                	jne    8035a0 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8035c9:	66 b8 00 00          	mov    $0x0,%ax
}
  8035cd:	5d                   	pop    %ebp
  8035ce:	c3                   	ret    

008035cf <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8035cf:	55                   	push   %ebp
  8035d0:	89 e5                	mov    %esp,%ebp
  8035d2:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8035d5:	89 d0                	mov    %edx,%eax
  8035d7:	c1 e8 16             	shr    $0x16,%eax
  8035da:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8035e1:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8035e6:	f6 c1 01             	test   $0x1,%cl
  8035e9:	74 1d                	je     803608 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8035eb:	c1 ea 0c             	shr    $0xc,%edx
  8035ee:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8035f5:	f6 c2 01             	test   $0x1,%dl
  8035f8:	74 0e                	je     803608 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8035fa:	c1 ea 0c             	shr    $0xc,%edx
  8035fd:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803604:	ef 
  803605:	0f b7 c0             	movzwl %ax,%eax
}
  803608:	5d                   	pop    %ebp
  803609:	c3                   	ret    
  80360a:	66 90                	xchg   %ax,%ax
  80360c:	66 90                	xchg   %ax,%ax
  80360e:	66 90                	xchg   %ax,%ax

00803610 <__udivdi3>:
  803610:	55                   	push   %ebp
  803611:	57                   	push   %edi
  803612:	56                   	push   %esi
  803613:	83 ec 0c             	sub    $0xc,%esp
  803616:	8b 44 24 28          	mov    0x28(%esp),%eax
  80361a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80361e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  803622:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803626:	85 c0                	test   %eax,%eax
  803628:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80362c:	89 ea                	mov    %ebp,%edx
  80362e:	89 0c 24             	mov    %ecx,(%esp)
  803631:	75 2d                	jne    803660 <__udivdi3+0x50>
  803633:	39 e9                	cmp    %ebp,%ecx
  803635:	77 61                	ja     803698 <__udivdi3+0x88>
  803637:	85 c9                	test   %ecx,%ecx
  803639:	89 ce                	mov    %ecx,%esi
  80363b:	75 0b                	jne    803648 <__udivdi3+0x38>
  80363d:	b8 01 00 00 00       	mov    $0x1,%eax
  803642:	31 d2                	xor    %edx,%edx
  803644:	f7 f1                	div    %ecx
  803646:	89 c6                	mov    %eax,%esi
  803648:	31 d2                	xor    %edx,%edx
  80364a:	89 e8                	mov    %ebp,%eax
  80364c:	f7 f6                	div    %esi
  80364e:	89 c5                	mov    %eax,%ebp
  803650:	89 f8                	mov    %edi,%eax
  803652:	f7 f6                	div    %esi
  803654:	89 ea                	mov    %ebp,%edx
  803656:	83 c4 0c             	add    $0xc,%esp
  803659:	5e                   	pop    %esi
  80365a:	5f                   	pop    %edi
  80365b:	5d                   	pop    %ebp
  80365c:	c3                   	ret    
  80365d:	8d 76 00             	lea    0x0(%esi),%esi
  803660:	39 e8                	cmp    %ebp,%eax
  803662:	77 24                	ja     803688 <__udivdi3+0x78>
  803664:	0f bd e8             	bsr    %eax,%ebp
  803667:	83 f5 1f             	xor    $0x1f,%ebp
  80366a:	75 3c                	jne    8036a8 <__udivdi3+0x98>
  80366c:	8b 74 24 04          	mov    0x4(%esp),%esi
  803670:	39 34 24             	cmp    %esi,(%esp)
  803673:	0f 86 9f 00 00 00    	jbe    803718 <__udivdi3+0x108>
  803679:	39 d0                	cmp    %edx,%eax
  80367b:	0f 82 97 00 00 00    	jb     803718 <__udivdi3+0x108>
  803681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803688:	31 d2                	xor    %edx,%edx
  80368a:	31 c0                	xor    %eax,%eax
  80368c:	83 c4 0c             	add    $0xc,%esp
  80368f:	5e                   	pop    %esi
  803690:	5f                   	pop    %edi
  803691:	5d                   	pop    %ebp
  803692:	c3                   	ret    
  803693:	90                   	nop
  803694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803698:	89 f8                	mov    %edi,%eax
  80369a:	f7 f1                	div    %ecx
  80369c:	31 d2                	xor    %edx,%edx
  80369e:	83 c4 0c             	add    $0xc,%esp
  8036a1:	5e                   	pop    %esi
  8036a2:	5f                   	pop    %edi
  8036a3:	5d                   	pop    %ebp
  8036a4:	c3                   	ret    
  8036a5:	8d 76 00             	lea    0x0(%esi),%esi
  8036a8:	89 e9                	mov    %ebp,%ecx
  8036aa:	8b 3c 24             	mov    (%esp),%edi
  8036ad:	d3 e0                	shl    %cl,%eax
  8036af:	89 c6                	mov    %eax,%esi
  8036b1:	b8 20 00 00 00       	mov    $0x20,%eax
  8036b6:	29 e8                	sub    %ebp,%eax
  8036b8:	89 c1                	mov    %eax,%ecx
  8036ba:	d3 ef                	shr    %cl,%edi
  8036bc:	89 e9                	mov    %ebp,%ecx
  8036be:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8036c2:	8b 3c 24             	mov    (%esp),%edi
  8036c5:	09 74 24 08          	or     %esi,0x8(%esp)
  8036c9:	89 d6                	mov    %edx,%esi
  8036cb:	d3 e7                	shl    %cl,%edi
  8036cd:	89 c1                	mov    %eax,%ecx
  8036cf:	89 3c 24             	mov    %edi,(%esp)
  8036d2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8036d6:	d3 ee                	shr    %cl,%esi
  8036d8:	89 e9                	mov    %ebp,%ecx
  8036da:	d3 e2                	shl    %cl,%edx
  8036dc:	89 c1                	mov    %eax,%ecx
  8036de:	d3 ef                	shr    %cl,%edi
  8036e0:	09 d7                	or     %edx,%edi
  8036e2:	89 f2                	mov    %esi,%edx
  8036e4:	89 f8                	mov    %edi,%eax
  8036e6:	f7 74 24 08          	divl   0x8(%esp)
  8036ea:	89 d6                	mov    %edx,%esi
  8036ec:	89 c7                	mov    %eax,%edi
  8036ee:	f7 24 24             	mull   (%esp)
  8036f1:	39 d6                	cmp    %edx,%esi
  8036f3:	89 14 24             	mov    %edx,(%esp)
  8036f6:	72 30                	jb     803728 <__udivdi3+0x118>
  8036f8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036fc:	89 e9                	mov    %ebp,%ecx
  8036fe:	d3 e2                	shl    %cl,%edx
  803700:	39 c2                	cmp    %eax,%edx
  803702:	73 05                	jae    803709 <__udivdi3+0xf9>
  803704:	3b 34 24             	cmp    (%esp),%esi
  803707:	74 1f                	je     803728 <__udivdi3+0x118>
  803709:	89 f8                	mov    %edi,%eax
  80370b:	31 d2                	xor    %edx,%edx
  80370d:	e9 7a ff ff ff       	jmp    80368c <__udivdi3+0x7c>
  803712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803718:	31 d2                	xor    %edx,%edx
  80371a:	b8 01 00 00 00       	mov    $0x1,%eax
  80371f:	e9 68 ff ff ff       	jmp    80368c <__udivdi3+0x7c>
  803724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803728:	8d 47 ff             	lea    -0x1(%edi),%eax
  80372b:	31 d2                	xor    %edx,%edx
  80372d:	83 c4 0c             	add    $0xc,%esp
  803730:	5e                   	pop    %esi
  803731:	5f                   	pop    %edi
  803732:	5d                   	pop    %ebp
  803733:	c3                   	ret    
  803734:	66 90                	xchg   %ax,%ax
  803736:	66 90                	xchg   %ax,%ax
  803738:	66 90                	xchg   %ax,%ax
  80373a:	66 90                	xchg   %ax,%ax
  80373c:	66 90                	xchg   %ax,%ax
  80373e:	66 90                	xchg   %ax,%ax

00803740 <__umoddi3>:
  803740:	55                   	push   %ebp
  803741:	57                   	push   %edi
  803742:	56                   	push   %esi
  803743:	83 ec 14             	sub    $0x14,%esp
  803746:	8b 44 24 28          	mov    0x28(%esp),%eax
  80374a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80374e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803752:	89 c7                	mov    %eax,%edi
  803754:	89 44 24 04          	mov    %eax,0x4(%esp)
  803758:	8b 44 24 30          	mov    0x30(%esp),%eax
  80375c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803760:	89 34 24             	mov    %esi,(%esp)
  803763:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803767:	85 c0                	test   %eax,%eax
  803769:	89 c2                	mov    %eax,%edx
  80376b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80376f:	75 17                	jne    803788 <__umoddi3+0x48>
  803771:	39 fe                	cmp    %edi,%esi
  803773:	76 4b                	jbe    8037c0 <__umoddi3+0x80>
  803775:	89 c8                	mov    %ecx,%eax
  803777:	89 fa                	mov    %edi,%edx
  803779:	f7 f6                	div    %esi
  80377b:	89 d0                	mov    %edx,%eax
  80377d:	31 d2                	xor    %edx,%edx
  80377f:	83 c4 14             	add    $0x14,%esp
  803782:	5e                   	pop    %esi
  803783:	5f                   	pop    %edi
  803784:	5d                   	pop    %ebp
  803785:	c3                   	ret    
  803786:	66 90                	xchg   %ax,%ax
  803788:	39 f8                	cmp    %edi,%eax
  80378a:	77 54                	ja     8037e0 <__umoddi3+0xa0>
  80378c:	0f bd e8             	bsr    %eax,%ebp
  80378f:	83 f5 1f             	xor    $0x1f,%ebp
  803792:	75 5c                	jne    8037f0 <__umoddi3+0xb0>
  803794:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803798:	39 3c 24             	cmp    %edi,(%esp)
  80379b:	0f 87 e7 00 00 00    	ja     803888 <__umoddi3+0x148>
  8037a1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8037a5:	29 f1                	sub    %esi,%ecx
  8037a7:	19 c7                	sbb    %eax,%edi
  8037a9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037b1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037b5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8037b9:	83 c4 14             	add    $0x14,%esp
  8037bc:	5e                   	pop    %esi
  8037bd:	5f                   	pop    %edi
  8037be:	5d                   	pop    %ebp
  8037bf:	c3                   	ret    
  8037c0:	85 f6                	test   %esi,%esi
  8037c2:	89 f5                	mov    %esi,%ebp
  8037c4:	75 0b                	jne    8037d1 <__umoddi3+0x91>
  8037c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8037cb:	31 d2                	xor    %edx,%edx
  8037cd:	f7 f6                	div    %esi
  8037cf:	89 c5                	mov    %eax,%ebp
  8037d1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037d5:	31 d2                	xor    %edx,%edx
  8037d7:	f7 f5                	div    %ebp
  8037d9:	89 c8                	mov    %ecx,%eax
  8037db:	f7 f5                	div    %ebp
  8037dd:	eb 9c                	jmp    80377b <__umoddi3+0x3b>
  8037df:	90                   	nop
  8037e0:	89 c8                	mov    %ecx,%eax
  8037e2:	89 fa                	mov    %edi,%edx
  8037e4:	83 c4 14             	add    $0x14,%esp
  8037e7:	5e                   	pop    %esi
  8037e8:	5f                   	pop    %edi
  8037e9:	5d                   	pop    %ebp
  8037ea:	c3                   	ret    
  8037eb:	90                   	nop
  8037ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8037f0:	8b 04 24             	mov    (%esp),%eax
  8037f3:	be 20 00 00 00       	mov    $0x20,%esi
  8037f8:	89 e9                	mov    %ebp,%ecx
  8037fa:	29 ee                	sub    %ebp,%esi
  8037fc:	d3 e2                	shl    %cl,%edx
  8037fe:	89 f1                	mov    %esi,%ecx
  803800:	d3 e8                	shr    %cl,%eax
  803802:	89 e9                	mov    %ebp,%ecx
  803804:	89 44 24 04          	mov    %eax,0x4(%esp)
  803808:	8b 04 24             	mov    (%esp),%eax
  80380b:	09 54 24 04          	or     %edx,0x4(%esp)
  80380f:	89 fa                	mov    %edi,%edx
  803811:	d3 e0                	shl    %cl,%eax
  803813:	89 f1                	mov    %esi,%ecx
  803815:	89 44 24 08          	mov    %eax,0x8(%esp)
  803819:	8b 44 24 10          	mov    0x10(%esp),%eax
  80381d:	d3 ea                	shr    %cl,%edx
  80381f:	89 e9                	mov    %ebp,%ecx
  803821:	d3 e7                	shl    %cl,%edi
  803823:	89 f1                	mov    %esi,%ecx
  803825:	d3 e8                	shr    %cl,%eax
  803827:	89 e9                	mov    %ebp,%ecx
  803829:	09 f8                	or     %edi,%eax
  80382b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80382f:	f7 74 24 04          	divl   0x4(%esp)
  803833:	d3 e7                	shl    %cl,%edi
  803835:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803839:	89 d7                	mov    %edx,%edi
  80383b:	f7 64 24 08          	mull   0x8(%esp)
  80383f:	39 d7                	cmp    %edx,%edi
  803841:	89 c1                	mov    %eax,%ecx
  803843:	89 14 24             	mov    %edx,(%esp)
  803846:	72 2c                	jb     803874 <__umoddi3+0x134>
  803848:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80384c:	72 22                	jb     803870 <__umoddi3+0x130>
  80384e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803852:	29 c8                	sub    %ecx,%eax
  803854:	19 d7                	sbb    %edx,%edi
  803856:	89 e9                	mov    %ebp,%ecx
  803858:	89 fa                	mov    %edi,%edx
  80385a:	d3 e8                	shr    %cl,%eax
  80385c:	89 f1                	mov    %esi,%ecx
  80385e:	d3 e2                	shl    %cl,%edx
  803860:	89 e9                	mov    %ebp,%ecx
  803862:	d3 ef                	shr    %cl,%edi
  803864:	09 d0                	or     %edx,%eax
  803866:	89 fa                	mov    %edi,%edx
  803868:	83 c4 14             	add    $0x14,%esp
  80386b:	5e                   	pop    %esi
  80386c:	5f                   	pop    %edi
  80386d:	5d                   	pop    %ebp
  80386e:	c3                   	ret    
  80386f:	90                   	nop
  803870:	39 d7                	cmp    %edx,%edi
  803872:	75 da                	jne    80384e <__umoddi3+0x10e>
  803874:	8b 14 24             	mov    (%esp),%edx
  803877:	89 c1                	mov    %eax,%ecx
  803879:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80387d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803881:	eb cb                	jmp    80384e <__umoddi3+0x10e>
  803883:	90                   	nop
  803884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803888:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80388c:	0f 82 0f ff ff ff    	jb     8037a1 <__umoddi3+0x61>
  803892:	e9 1a ff ff ff       	jmp    8037b1 <__umoddi3+0x71>
